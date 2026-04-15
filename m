Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43BCF41987
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CA06B009B; Wed, 15 Apr 2026 05:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404056B009D; Wed, 15 Apr 2026 05:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A116B009E; Wed, 15 Apr 2026 05:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 203DA6B009B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:54:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B37161B7BC3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:54:12 +0000 (UTC)
X-FDA: 84660329544.22.DD5F259
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DCF3080004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:54:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WT4zpnko;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776246851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbncXILEcoajtQPdLRvmNZUquk7eWicP7+0e9SIqwVQ=;
	b=WRcG4BU/tNUW7IeJuhNwNprWUJuwsD4sTIN+OR15Rud110z5abkA/1/uZFVxubEJHUFTwG
	/hAd0rxNCJPsXYqQ9fz4FbWb95y1cy/y3xYHRtFIMc7fKLidYh4Ac0Ber4mjx89faYUKlv
	dFnPLH92+9hZ6+bejtMbnVjTUp9io/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WT4zpnko;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776246851; a=rsa-sha256;
	cv=none;
	b=TAarTw5CWMqzP9LBcOxwb7i/b/sD3HYPwyAyc9IwqWQsXAcq5ZZt7y3ifUhynyKfmOOgsh
	dGQhO6KtGQFQZ0M+j98hRqac3LOFzT9yfIuFD7Ug+iafTRbPwh3gq/bV+iSVCCbP2/QCN6
	mYJn7bHggFi9MiqlHk7KV1IiDUwbeA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B43D144014;
	Wed, 15 Apr 2026 09:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F028AC19424;
	Wed, 15 Apr 2026 09:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776246849;
	bh=3F6cwswsouEqKn0KSjD6trG+dv/d5FAUIPx9gae0kC0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WT4zpnkoSW0aOFSRV871WrRtxflVsRg9rfHguPcazzwrWmrC/RG7AybINjzCihbkh
	 yCs1pC/0QDvYAO56mpWaBoVt/mQHviuWkrnoaVt9mstrNtdtXlgIZnJihiF0r0RDgA
	 W/MdHETbaVIWDDHif6wwdkEX9FUCPRizYZSm4rqIEr9a50I2tqRY20v9OMnIrP1jeL
	 0giKpBOwxbEaQwo1jAHvwje6lQede9d1tDmLiy7jhu4HK9vkbN2QnVsgM/kwjCllem
	 9pbzGfC/J63+iwp/bdc/yd+AL/mLzQee4MOGBESGqmN9aOn8GhtRWsnDzuIPEZJbn1
	 B2MZkvXibqmdQ==
Message-ID: <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
Date: Wed, 15 Apr 2026 11:54:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: octz6b713hif7z1bnk3e3wh16pcmc13z
X-Rspamd-Queue-Id: DCF3080004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776246850-228840
X-HE-Meta: U2FsdGVkX1+9ljZkeJl+zcc396OZh8Sf6Gvvm++cfDB3pL9HtPOezSPbL1ZpmyvSP32YNty/mQY65ufyaDC/492U6DX3zDr/LeRDyHX9HnIn9PABxXWOgKQabfxHC/3E/NjvriX0I5xsHrJjkApeakFnBgv4Jrt6QXmzA4K67zuoSW7sVc2BiYIyGANRHDBYwM+X5QsjKbZ1J54xL6eDvpZfZlrhl3rx8paC4En9W9dGgnvgqQAl7gdHzktQV6/m3sRnlr8/qYPGIa2NDGtxmLHOnd2ONBx/YeWSTPlSj5Fsnn/g/h/6SND89DvpFJG3D9+TnOHUPjr8o39RyBMI+ymjkk+RFZ2sWvzyoh2hont5ywO7aheiTnM896S0suPqPgaWBeK4PWzN0ka9H9AoNvu1TAR8AyVRN8f1kyoN4ytTPAdgfL7oquT8e/o7poQQdYNENFRjZqWGjDr16N4jGPR833qHm/+HaKmHKJvNqZj+tNtZFp9yheD36k0tzMlY/ep0HK7R6AS0OPtXEDhk2H3EiSQYoWb7XMaGtdlYirKtu87WlhBvaL7RJ9TEAex9MB2DK9WgdSJVXJrovRPCe46rdtw4G8qLUV4vUNvQy/j8GlAMjXZBZtARunRHeQ7/ZYL/k1+zHGM8IMMNUTqM0+tzIC1LA/5DipaRMTu3J2Lh1YOgz8NXKecmfRdCUgVY/Ww0Q0hJw+qUFz6SP9R9VasM5RwgIyjcsWkjgHQdpFTmOtAvNdtBGgfVu1FDyPuWd5Jn5EX7gBQq5rN4QWkO9FiJR7Fa6WKkb9PWWckQNjYlDzXPsXIRRqUzb22Xp++grH+mmPMvode8S9+Gj+em/IUhFFaqnJnr88ym4TskCkCmrF2R+6BnYQfcuok90/pKn5Gi0AewMDEN91f+5QehGaXxi99eMMjfmRP6IpWqzfbxk7hYg42uDWYkAQS0SXKm17bBExPHxxowgp9nOgs
 Snw/kHBP
 IWlkTRbkGt+UWohKfBlNeVPSCzm2v4gqDjqMtTu0eb2Ujy2TqnBbGkL8sE15kdyDNb1N+J2A8QX00F6w+epVVL1YoZvyFh9eZwhNF1un2R1ITPZ1nKl7fyqecgVpac0s8DF9uZXXhZg+nAGvfazaiCNm+kgIWCItMGhX44LrLd29WvG15AOHMf4z7DrWTjZtbZ51DfOcj4CT1EwL+L6+4nYePcXTXpOUBA1Qd2MTmcgOEeehKNfgDVlkzTt8kJ8TRCcr1zTY+1bJYVZE0GE2/rhEO8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> As I mentioned, the original logic has several issues for anonymous
>>> shmem:
>>>
>>> 1. Whether anonymous shmem supports large folios can be dynamically
>>> configured via sysfs interfaces, so mapping_set_large_folios() set
>>> during initialization cannot accurately reflect whether anonymous shmem
>>> actually supports large folios.
>>
>> Well, the mapping does support large folios, just the folio allocations
>> are currently disable.
>>
>> It feels cleaner to say "there might be large folios in this mapping"
>> than saying "there are no large folios in the mapping as the mapping
>> does not support it", no?
> 
> Yes, that makes sense.
> 
> However, it’s also possible that the mapping does not support large
> folios, yet anonymous shmem can still allocate large folios via the
> sysfs interfaces. That doesn't make sense, right?

That's what I am saying: if there could be large folios in there, then
let's tell the world.

Getting in a scenario where the mapping claims to not support large
folios, but then we have large folios in there is inconsistent, not?

[...]

>> What if we say:
>>
>> shmem that *will never have*/*does never allow* large folios never sets
>> mapping_set_large_folios().
>>
>> shmem that *might* have large folios (in the past, now, or in the
>> future) sets mapping_set_large_folios().
> 
> For the current anonymous shmem (tmpfs is already clear, no questions),
> I don’t think there will be any "will never have/does never allow"
> cases, because it can be changed dynamically via the sysfs interfaces.

Right. It's about non-anon shmem with huge=off.

> 
> If we still want that logic, then for anonymous shmem we can treat it as
> always "might have large folios".

Exactly.

-- 
Cheers,

David

