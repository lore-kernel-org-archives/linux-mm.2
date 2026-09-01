Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DEFC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B756B0112; Tue,  1 Sep 2026 05:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C366B0114; Tue,  1 Sep 2026 05:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A976B0115; Tue,  1 Sep 2026 05:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66FCC6B0112
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:52:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4900AC0380
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:52:10 +0000 (UTC)
X-FDA: 85164727620.04.9DAE399
Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2AB5140006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:52:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l0GaY6x8;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788256328;
	b=Le9BBSOajdgmhSmBeA+0xWPYIhuSYAPe/V5e79MDyd83+MhDI6n50o1MnRDQsbfxzDy/MJ
	KM926xr94bmqxh8Rgk92Bt/venSP08mvSRRnzq3C32nBysuXuAfFIrsmZJiyIo1gmUWjOO
	3RULF7tJqbdlc9AhgOwZgkTZy4ea0CY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788256328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHdiI6mdu0xONWISeoZhXqB8DL4xtbOoBETjGYyX37E=;
	b=SqKDNTYL+0+Tee502hxA7Qek6O8561UqY0n260VpAd5DC7hlfkdsNPYFGmTt1Aje0kDYC5
	5jIq7KFYkQNyjdi/fLCgsMm8w2VAu9AW0LbIdl7ZTCr6RAZJYke3p6kzhJc29jTxJejAdx
	qOBfYjLv8eHYk4lrstJIzled+x0WnKY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l0GaY6x8;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gWBMzccwztkDTNjZRc6ZiXACyk8Q9RyrtZihlTbMSpQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788256323; v=1; x=1788861123;
 b=l0GaY6x8G3+bJ9tShHnLgRR0DrK9VUUCYknCv20F24pixTdHJcU3+OggHO7efVcgq9Jm7fVw
 P9FFShdgjZ6svn96HcLcmU6IdXATwP6BqPU8wAcqE2Gv6PFkZTAVw66pgn8Cdq8xiiDHpTSZTnP
 ALk7iFR4imqa3HOjZ2GCJKdo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9cd017cf59f4577d;
	Tue, 01 Sep 2026 09:52:03 +0000
X-Mizu-Trace-ID: 9cd017cf59f4577d
X-Migadu-Flow: FLOW_OUT
Message-ID: <2638f163-7647-4739-9ee4-5a7e9993455b@linux.dev>
Date: Tue, 1 Sep 2026 10:51:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
To: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
 <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
 <eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
 <20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
 <c1ad6e39-3b21-413c-ad02-f90cfc4102f9@linux.dev>
 <20260831192143.84da447c4fa2afb60757afa4@linux-foundation.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260831192143.84da447c4fa2afb60757afa4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2AB5140006
X-Stat-Signature: nbwur14wbwgbtjtf6uisfnfe9jckfcwf
X-HE-Tag: 1788256326-175573
X-HE-Meta: U2FsdGVkX1+7J/RuiX1H7rJ8xAGiGK8LB8Ov8txuRBpUweAh6DJIaIVDArUpnU7aJK+wepzajxzxpmGXMXSktfNN4JqYTaDRFZ//9viRt6tSHkcA0pxpN9uqqFIjcjGUA82f1plJ1cPlUw1h8ErhB5mzc2wq5uYERqqdhzpUOjo1OFkj+fKxHkBtlVN/N1MXdiMWG8QJUle4/777X4dSspooAxV5wdaBSSO9igdSn9SVoMROa9jnL+vxbQ+XG8ywOUZkjhZuDiSqDd764iyi0U8831rdOGwuaH4BLEc7P2AAiBAmuAMT2pWYQ6jMtt/2lQTUmlLZSAtVbORq/S9hLR5NmJqxeSEPCrhZNXc1FEZbgeLW/caK/1JESj8cUo92pmLLClpZ+74Sdn41cz+nmBM3vNwDD7og8hprROamT5ecCEyeanXO7CydBijhy3gLj4b8sTruQ8RYE756ZlRUUtXNsCTTOL094wCa3BfizX6UM/Cl/H0pJtKMhdsprhFZf3SHxJkC/FV86JMFN8uPvyCRSUEBJa/0na3iQdnCq/eGGpVd+133BATQjs5NNRKRLEZqZkEoR3O3uJTEo4PD0ElyY/GLXWoqYLF9kyVVhsJgidynG1OTSQQS9gccov7Fc6KK8BQco1ck8x2d4utKKzPCSyxyIz1f7/bDKvjgCbrNwB2qDqWn+WMTB4TeA8kNx+NDAvCs3YBVJvM4BIQkAhLmWAKP8T78dFPD1RChywRgClz/Z9bAbr/iDayJe2QAcbcD+MlkVHwlhQjPs1hr7noMMaeGqd3pflaOiUErH03y8PFm853ng2/xa9Fr3wDbS9k9nhHp36ZaeYItpgOp/MU+TY2sESdAdRMFbtbNSVA9SpPcsSMhjQG+hGB0lGzQmdB02wHZVqwx48vAxGAFK+d8CattFwLqMhu9YrmWLWn3OOKvJy+8MNM7mTr3RIUkWa8Nv2CRouxvqEPgnsm
 hR+GC+yr
 3KGaJ0qawoxfwo3VKvWz82s8C3qa/zb14IvnKfhczeXXY4vRMqfAYqe2dBaIt4UmuQCMZ+KjalweJraXPIIv8HItUreAB2RZW6kOLdT81qzETmE9Xsw70YTnJBnhFyYD3uvaK6DZkkVJkcp6b+T0LKHVUBih+zxCOJMhM0+U1POov0t5UZVbhaWPBpCmyWQd6Mfa9pq2NVbXYvVp2FJnVYhzdIl3lLMINQHFJVAGxQOtbBuo2oFgbD8aYrGBHgmcbEpboDeT2Oyd4TlWXq1UMNOWDAoUJOuHoYpLgk90CrJzfY9gglLaeyJe5rEWRNHlNFvgQnisJYlAYNEpNttCtpoDMU5osLdHxMAFTkuYZiY+nhQ2Bxn5IYMJwC51T69n4t6fEfmio7jhEYQAzCS6bsPvACr13hK9hTn4L7ZJEo6dKULhwJI4NLAy62ukrVRDkXLgxp92oyD/0BHH55vB9TwQQeHk9z+LsTDThhVSsgUjF1Fyf4Qr94pamcLBxspWWH0KCpdXVPQfWIrqmArl+WV8iX0CwHcR0ueipVroEwJJKtpgQWvC/JRIJvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/2026 03:21, Andrew Morton wrote:
> On Mon, 31 Aug 2026 10:28:00 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>> OK, please add this info to this patch's changelog.  Please also decide
>>> whether a cc:stable should be added and if so, ensure the changelog
>>> makes clear why we're recommending a backport.
>>>
>>> As part of this, let's expand on "XFS will also run into issues".
>>
>> How about this instead:
>>
>> ---
>> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
>> individual filesystems") was meant to drop the blanket memcg gate in
>> fs/super.c and let each ->nr_cached_objects() implementation decide
>> for itself whether it is meaningful in per-memcg reclaim. However,
>> when that patch was applied the removal of super_fs_objects_eligible()
>> and its two call sites in super_cache_scan() / super_cache_count() was
>> lost, so the helper is still gating every ->nr_cached_objects() hook
>> and 0ef8faff490be is effectively a no-op.
>>
>> Consequences of the leftover gate:
>>
>>    - XFS's inode-reclaim hook, which is intentionally driven from
>>      per-memcg contexts to free memcg-charged slab, is still
>>      short-circuited in fs/super.c — exactly the regression from
>>      commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
>>      nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
>>      written to undo. Memcg-charged XFS inode slab therefore keeps
>>      piling up under per-memcg pressure until global reclaim kicks in.
>>
>>    - Any future ->nr_cached_objects()/->free_cached_objects() that
>>      grows memcg awareness is likewise blocked before it can run, so
>>      filesystems cannot opt in to per-memcg reclaim on their own —
>>      defeating the whole point of pushing the gating decision down
>>      into the callbacks.
>>
>> Drop the leftover helper and its call sites so the intent of
>> 0ef8faff490be actually takes effect.
>>
>> Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into 
>> individual filesystems")
>> Cc: stable@vger.kernel.org
>> ---
>>
>> Can you fix up the commit message directly on your end? Let me know if
>> you prefer me to spin a v5 instead.
> 
> Thanks.  I pasted this in and turned your [1/4] into a standalone patch
> for mm-hotfixes, with a cc:stable.
> 
> The remaining three patches I turned into a separate series for the
> next merge window.
> 
> This particular patch has no evidence of reviewer input yet?
> 
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> Subject: fs: fix missed removal of super_fs_objects_eligible()
> Date: Mon, 17 Aug 2026 17:03:25 +0800
> 
> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> individual filesystems") was meant to drop the blanket memcg gate in
> fs/super.c and let each ->nr_cached_objects() implementation decide for
> itself whether it is meaningful in per-memcg reclaim.  However, when
> that patch was applied the removal of super_fs_objects_eligible() and
> its two call sites in super_cache_scan() / super_cache_count() was
> lost, so the helper is still gating every ->nr_cached_objects() hook
> and 0ef8faff490be is effectively a no-op.
> 
> Consequences of the leftover gate:
> 
>    - XFS's inode-reclaim hook, which is intentionally driven from
>      per-memcg contexts to free memcg-charged slab, is still
>      short-circuited in fs/super.c  exactly the regression from
>      commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
>      nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
>      written to undo. Memcg-charged XFS inode slab therefore keeps
>      piling up under per-memcg pressure until global reclaim kicks in.
> 
>    - Any future ->nr_cached_objects()/->free_cached_objects() that
>      grows memcg awareness is likewise blocked before it can run, so
>      filesystems cannot opt in to per-memcg reclaim on their own 
>      defeating the whole point of pushing the gating decision down
>      into the callbacks.
> 
> Drop the leftover helper and its call sites so the intent of
> 0ef8faff490be actually takes effect.
> 
> Link: https://lore.kernel.org/cover.1786955972.git.zhengqi.arch@bytedance.com
> Link: https://lore.kernel.org/3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com
> Link: https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/ [0]
> Fixes: 0ef8faff490b ("fs: push nr_cached_objects memcg gating into individual filesystems")
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
Yeah unfortunately this was a mess up with a part of the patch not being applied.

Acked-by: Usama Arif <usama.arif@linux.dev>



