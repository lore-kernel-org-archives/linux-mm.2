Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38BCC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59726B0096; Thu, 10 Sep 2026 03:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36336B0098; Thu, 10 Sep 2026 03:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C487F6B00A0; Thu, 10 Sep 2026 03:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A663D6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:47:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3521314045C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:47:06 +0000 (UTC)
X-FDA: 85197071652.22.167400B
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3229540003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:47:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v9gf1qnu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026424;
	b=ZzNlaa6S99bqxwtbg+QXUp1agsHO0urgrD7XPXcgtlNKtuPz6VL2r04qRuhvsZevOr74gO
	A2en6hgYrp1qmpEw2dp/53LxynF+Mz6nc2yqqr/L3GihpT3lTdsVDUs7hk66GqVir4Zn8A
	49pPGn+r4RbNt7Ks9X11+euzFPchTR8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v9gf1qnu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBZDbA7m6Uk1x34vpkryq/YkYdbuGu1YkB4b+p78Org=;
	b=PMzFydh5bkOAu2o/G14QfhDAD/Wc8i886Kyi+2fBmwukcGBmn5oY55tw6R1J0gQuQhHtXo
	IHLqiczcuAPA7+CFyffBLtm7gYPU+JNkVBmG5udxictPS/3rrBu4mhG5nZzlA8oftCTxT1
	ebkxUDk0G+jHi63CkLi1Ogdjvtbcddg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789026420; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SBZDbA7m6Uk1x34vpkryq/YkYdbuGu1YkB4b+p78Org=;
	b=v9gf1qnug911Bfd6CyT7PlmnqESXvi3VKOKiXhnMx1Ddu23Tde+q6DF6ACEr4O3Z2DmaF5c70eFEDqvDmhpdDRSAKQDbZ+xy9IkEG2q0UsDlxvJ4v0d1Y5K6v+5u+nvGn+OauX+HgQwXRFh+pFUSOBIHPOrGVg2KHn5B85PqbE4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XAgyScL_1789026417;
Received: from 30.178.84.157(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAgyScL_1789026417 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 15:46:58 +0800
Message-ID: <f5f6327a-bc9e-415c-a8b2-b498883b9746@linux.alibaba.com>
Date: Thu, 10 Sep 2026 15:46:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
 <aqGlV7NjxrFPYtRH@cmpxchg.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqGlV7NjxrFPYtRH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3229540003
X-Stat-Signature: t19bbwe8apwh97x4jpm57nh841cr5qba
X-HE-Tag: 1789026422-944748
X-HE-Meta: U2FsdGVkX18pyYrirRz/RfdsodohdtESqYm0WOpK6Zvm18nQpPWIdJl567IOvLTD6jJ2y5dSkypv+fPwWelcVWb5AXBr70H/ffUFTYaa2QDGTDa/OmbSEUU8StgL4PHUg55Hxs8YoocFdumh+RhPO1HojRQ3oLEe2tbX+Ior+ooZbrEarn2QPqfnTq7EubmVJ/dgBEZDcBLbbuF/Zr2wZpubZD2fuvoJ8dTEEquqCyLsjjxtYu/qStiELSY+n+LuvJWY5S9iW6zLxA6mhWi9+rcXyDa5eA4I9OVQbbXLdQe/9uZpijkwmeGm+N0zLIsdhx5Zs+StVVXgqmeXUbSAkRvQ0rLmddYxOKiONoI3n34nmln2y+zy4JzA+zikZUrKBUtt5ba/DgMEQE5180/O4g4Cb+SZJ2aWT/TSNJ6JE3d+o046O4fBScVF/RCY3J7HNMbkl7LZ0WmcSzAL8LmNS1nlFIi80yh2Jonoc/STY86YJFxF2mXifN02Kih69rOppk15+vDMj5WEe+09xJb5Wi+Je9JakOA03s3pZcNTMfbCXsky86Bb7J+xdmiQH+poH7IHxpj3YoSFYAryExZntJ3bD8djvSKMHLHtDyQkUJW6FO2tAr3n99NW5HK5IotH65CakLuOLnn66Yn8k3M0Bnsph28tViMbJ+A1HPUhgoFyu9TtCw4m9Choluc9MsSvK7UeD2wR1XivonsmEGPckO4SKAnzQUBj+oU03MQA4n067IaWPnapBkEi9ndENATU/JhGnaYdPanQvtn3fIVoj3uZ+Mjvan4TO//SG/6kYq+rIR/lTLnwTJ1bkFDGqURIE9/WMT9NQHkV7eaKbYhheqwyoruTtsmOYtHUwI9IiebEPenIXQIOxJkEOZWsWMlCzSx0P5IejaiZOFHYEOw8Rb6YA3B95obeEVN5iaeNxoLyzXiBoS2Su9JtgppOOphWvujDe3dJDNpyEXsc6zS
 XFEU1RsR
 f1UWXvJvpL62aJ2GFmMfVbpLDlcN4DD8YLtvsQVWWusYiglj6wOnQ+8nEiMwpWPDEyx6ETOu4ZMYofIezhFWPpxkPPi51Fb74fckiS7HBPL/i7gGoQfh6zkJiShdidJjIIHV5i0AJsP+knp0bBARb9WKsPHQbUPNDagUao+4Q3HchXmO5GT3LaEk2yj8b94SyNCiMyBxcsgfcuU2re5P2IxlTZKg3HJhCrDnq+p9AlIIp0RsiD7fVd6cOdvOqRiY+5yYA2iomE9P+Bu9JrI//rrW/wMy15AQ+Cvk8KyJ2eyWsX0qLJ55fm0DMTBzegXLAMT4F5mQCusrpdbPa98KejNGdZ9E0q9RSW36nLBhrsHUo2RtdVAYn6OXnh/gaoEBOJ1eCuBZuZGJ7MjT1T2aKlbNSdsZHgNF8hENx8j/81zIzjTbVRlHIizveHfIT3isphtGUmWUo6LLzKQ78RMM63wwds1vUmIjprzf5MLMLJLltTzx4A9JJzr8NskOoAjnmtK65Y0jMTZuNXOfy8DXgMKMW3d7Lry2USm4v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On 9/10/26 2:28 AM, Johannes Weiner wrote:
> On Mon, Sep 07, 2026 at 07:01:10PM +0800, Qinyun Tan wrote:
>> On a system booted with cgroup.memory=nokmem, the deferred split
>> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
>> partially unmapped THPs are only split under global reclaim; memcg
>> (limit-induced) reclaim never splits them, so a cgroup under memory
>> pressure keeps its underused THPs intact.
>>
>> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
>> split shrinker to list_lru"), which re-registered the shrinker without
>> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
>> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
>> precisely so it would keep working with kmem accounting disabled.
>> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
>> nokmem and the shrinker loses its memcg awareness.
> 
> Here is the reason why it was dropped:
> https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
> 
> After your patch to make list_lru expand for NONSLAB shrinkers, it can
> be restored.
> 

Thanks for the pointer. I'll update the commit message in v3 and
reference that thread.

>> This was noticed by Michal during review of the patch "mm/list_lru:
>> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>>
>> Restore the flag.
>>
>> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
>>
>> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
>> Suggested-by: Michal Koutný <mkoutny@suse.com>
>> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>


Thanks again,
Qinyun Tan

