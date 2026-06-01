Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C1FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18716B02B9; Mon,  1 Jun 2026 04:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0616B02BB; Mon,  1 Jun 2026 04:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D063D6B02BC; Mon,  1 Jun 2026 04:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEDE76B02B9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:16:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 339E11621E5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:16:39 +0000 (UTC)
X-FDA: 84830637318.29.57A2666
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59AA7C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:16:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BapgHXqm;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780301797; a=rsa-sha256;
	cv=none;
	b=ErTzkkCcwe59OYcyznBm9UEd/lbLi5O2iSWKXrv2HPdXfYuAC/GHAYXCZ0KzgxENIlVQIe
	QbQRLMUZz3GU49+BstLL7l14E3wCMtQsCocwuaQHZuplX1vKHAevgiVJTOAVbQwsu2oWVl
	XcEpx99xCn0EtR089Wzf4YdudBXKoOA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BapgHXqm;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780301797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jvZqi8VkeRODB5KZOUNHa6HlOqHzuN+bUrucImc84I=;
	b=wjajHHdJob5B4wC1G0nOybP95PJ7TMv2YDM7c1isoYg6GUIl5y4grKXezMF/wzBtX5ITlm
	HLpRQO5xBQ8rD7YD1iI6Wu/LsI1YdiyJljFnD6jgg0q4Zpn1TgkZdmcZHigM80kDYRXNAu
	VFoXFluEo4z8zpHY9l8LMfLt34RLA1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D8A741574;
	Mon,  1 Jun 2026 08:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2A1F00893;
	Mon,  1 Jun 2026 08:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780301796;
	bh=7jvZqi8VkeRODB5KZOUNHa6HlOqHzuN+bUrucImc84I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BapgHXqmzEjlmgIoOeYSUlyeZ51lqH/ZOhNVuDeecVA6Z2r+IiW/BU4ZCKwAlXtgO
	 DHxzBeLpOvsdHOAmSXVtET9xfot7Tefb/TJDvKr1ooDumPMiEbfuSLJTJ8wbsDGLCg
	 MC1yp+/WAl6sEnceRcUzLtBPKj85SOfRCBtHzq76r5dnmEca8i4cLaN5PyrYUL0qmP
	 9dLAtNC/cJ5sCQP9BIyz0mfSIxAALpYHIYYnJZ2G+NBfLN8HSuaZUXKwTVlax/x0JR
	 dBYR6a8d2a/nXD3M0+hcCj/ZsKcUHXZyEjsF6Q1DeY10FKa//I0x9xqYF7z/6FTzMi
	 HjcK3n+tskndA==
Message-ID: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
Date: Mon, 1 Jun 2026 10:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Brown
 <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 59AA7C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 5hn8r75oxsb5cojar1x4ehrdomcs11jp
X-HE-Tag: 1780301797-530170
X-HE-Meta: U2FsdGVkX187JM4DdthHYNSha/0/ysO3QXtXiBjMVi3R3IpEKsKE2JPh9gF6niY0lLKTkfGUswcCpPNpndZhaUsXKpI5ajV8H16MQjs01Eg5fn5xHbLwkaGG99Pmyfb1vRfhnuT88RKZotVO7sTQQxXo1+Qr9F54b3fFty1g3UYaqd+hyffDhngTrraN5TVE1z/y24TdAQuDG09UW09Wdw18Fj56CtzabntECK34tY6/D612qfdyy6q3xpjPQpwgHPNEMmFDSgYzxmE9j9l3P2LaA5Dfn4PNzGynVnOtf6dQxKB1l8RW4dC//JmcjEhEqFsPSEk4Lvtj6F49N6vA8DfNth/kehy/zGCUu+wdcgdqBV4+f2zni6M8Oe6C4nZhaOIeUC5WoKxzdce0uh4yxqKH7FY3reG7+xn0ZI29Arh3rasccKJr2CquEx5j8OVSOlZkSyI6rnv7gFQHxG6b50sDhHtpY3PAX/rkZ5kgunaKFdWznHcx5i9KIxssY8hD1h+6Cjf/750tGBC4o8EaRlB5RiBTzR1YfbF+JSogqJbwHRozf1bFkgT1cRImapui/ts8MvJZZB2e7fh/qI9LcOVZn7lpatcxJWIN8AiamCA072jX+TzjwpEilYXz8a0WzCbJp622FC3ABazoexZv3iOtcXb2empvvrXwQ+TTQ31GqcUMh7uwx722FsRkC2KtDmZ9f0iEektV3vlZmEfCyI2dzK8TTKzwMMeHHHA7MU9xiEKf2VUvLDIYLUiHbTV7nDe4oRzQc+bFHlURJV418THavengeHc565fV7sh440KFoLfLYSdlKuZvGDIUHQSVM8rsItpXVS1K5vmfwxl8s1jViU1SGGCpmidVUW33S90mi6jnkdAzusTJlja1eDq0wRXPo9g5tD+MVrraQJHIEg+HntAolfeUTSPnrUSC7Xht+gaZVRuBMB3LjBU80SH0Q+S5ucKxQ+/8LQsF6fo
 1skXQBh6
 ilTM2W6zL+Hc/vFhVy7lXQ84I7wzsPVE3gN4i3B/mkTbNffYYVyQA/SFJawtsSE80YFttv80H0Dou+gTt0gxueI/v4xpo1+kctuKmsZKYSvbZSxxAJbJzYIAbJgO7/bzzW2MB6vDJMCl4U1N9RKsVCUfFpZ9dCya3UOW6xwX6oC/ztpnDiTcz2TwnyKlDcy3XsXDL764nL50/8gSaIxPZeCXjrtNLuFCgHyckJwMb2FSRivRGChEIxQ+b7w+TsoF04QCqdvt72Fc0HPEs2PfZ2Qa1OiYRKy0QU7Zuczgc6x5AyIbq09JyIHw8N2TAsqgXN1idULN7e2RSvVzphh2V804g+gJM7Uk6zo5auS/RGPhXAQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 08:39, Harry Yoo wrote:
> 
> 
> On 5/29/26 10:50 PM, Christoph Hellwig wrote:
>> On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrote:
>>> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for-next
>>> (it's still yankable in case of issues)
>>>
>>> Did some fixups below (the comment was stale prior to the patch; restored
>>> unlikely(), simplified one line).
>>>
>>> A test merge into yesterday's -next found a conflict in drivers/gpu/drm/
>>> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
>>> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the changed
>>> codeto a new function panthor_vm_op_ctx_prealloc_pts().
>>> But it's solvable so no need for a complicated coordination I think.
>> 
>> Ok, thanks.  The two Sashiko complains also look like they had merrits,
>> but I won't get to looking into them until Monday.
> The review:
> https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de
> 
> So there is a user who might call kmem_cache_alloc_bulk() with size = 0

I don't know if it can really happen there, but maybe DRM folks can tell us.

> (although the comment says @size must be larger than 0!) and

The comment is however new, the caller existed when there was no comment and
the return value 0 when asked for 0 was working there.

> kmem_cache_alloc_bulk() returning 0 was considered a success in that case.
> 
> Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
> user sounds fine to me.

Would it be wrong if we just returned true for size of 0? Would something
else break?

> And yeah freeing an object via kfree() allocated via kvmalloc is a bug...

Yep.

