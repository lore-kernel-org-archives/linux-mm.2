Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467C3CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7ED6B0088; Wed, 14 Oct 2026 12:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498C86B008A; Wed, 14 Oct 2026 12:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEC16B008C; Wed, 14 Oct 2026 12:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034976B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:04:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C8D51606D1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:04:48 +0000 (UTC)
X-FDA: 85321705056.17.9BAAB96
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20808140018
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:04:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FB2ic1WG;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791993886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkZZR0p9Vzi9220+twT+gKA4/7OY831iNe+HO/zdAnU=;
	b=WX39VCcC5Mhv/RyzJxNkZPA0mRmuPrZGWKxz5vbeoiCFZyMz91BAhixrRwhRsdLPD/yyu0
	br5771E3ytwzVhPhYImybG9u7pArt1ej2IjCsUKKroheYhEaeSUD60BCDmZ8ABhXCMa8/2
	dcSmKkeCUAXNhctRTxw8Cr/1FvlLBPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791993886;
	b=enITn4DJzmK68SF0vtbwMKNk+3ZB+ORh4mYLaAKOCIXDukL5WJQpadGMIILUmT9QXwgYwl
	ra7pHFXOz1yIDI/DJoay5xlLm8C6PU3cFkX4XV/iNR8zCeRu1BpWfRDf09PNrX+vKOU5RZ
	wWh069O3nv6dxg/4ui/ASNB1Dd8PNx4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FB2ic1WG;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PI0fOAv5zzJ41Ji3Z2QtwoPTiCXvJem5/RFTA0ekY0U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791993881; v=1; x=1792598681;
 b=FB2ic1WGugcHaPbviCEivRkLZWw6rAaFPdy2BZYb5aDlbMVpLQ4QRp/EaFsTU3lA6tRJugoS
 l/P+Y1zD2kd/5w573b/aFKTNx03vEhPg5K6XeQ/2N/QhYiJ3qoDoGXWldnKvH6p88DlRCbbU0h+
 /CIC+skOEpBCvkjLuyFJijRo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0ac52b3081cf7048;
	Wed, 14 Oct 2026 16:04:41 +0000
X-Mizu-Trace-ID: 0ac52b3081cf7048
X-Migadu-Flow: FLOW_OUT
Message-ID: <73f0dafd-5b26-42b9-a77b-90c32976942f@linux.dev>
Date: Thu, 15 Oct 2026 00:04:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/huge_memory: fix the copy of special PMDs at
 fork
Content-Language: en-US
To: Konstantin Khorenko <khorenko@virtuozzo.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
 <F6337325-E635-43BB-9E5E-DCD25F4FC951@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <F6337325-E635-43BB-9E5E-DCD25F4FC951@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20808140018
X-Rspam-User: 
X-Stat-Signature: xcwjmm5j4fq1j5jbwbtckccjetshtcuh
X-HE-Tag: 1791993885-408964
X-HE-Meta: U2FsdGVkX19eha1klRRW31C420nVjxURUIliKPL3LnCQthFAmj6dEwvjl7ZuKRzlcEnPZaSvMizzkaxa78vJFpJRKodNNR+TvyKEzjwZDjtFcEeGqHLsXmLG5FNdlWCGJ+miado8evcJv4YSdarETmeSJRR6re1zm0V7nyrzOM2vTpDnDoptQjiCwlg6Fn/k6EQ2mMpOcXZuchbwT5yTSvUvkySQm1vWDuFhiJCJG/zIStiZoAZm5cKPLLVfMaCETuZ9kbpRte9k8gDPEAR+/+PEdwi8vLZ+RprcR+Yovhot5rF0YeLwD6Bc35sIDrofH8W+sydvV6ZYgMAUzVdAB3TuMN+hxXo/TL5/y1cp5aLuHI/yZAOatdjdWljmWggNBT3qtqe41W9S83s71cwD5fCnp+lpIoyR8dwrOg+ncibIyuf5ih/TjWzWJ71eWNFFohQjM6IEeak2Z5MbJQ600qdsETSCXTP8uUz1Z+K4/6eCw2UIJ1iLPiyB0PInH+nLY8neurpQRQkB7ep0XzmHh6ocaIupVGwQPWTw2dTHjmVIKjCLUN8duJaeYqowEISFzSKVxpfhphBtQ40WYdtgVz/VFy1JeGLAJUTWphgN8lVG+vQYY5da26ze6ZJ1GLAuAcmqLHcj3UBDLrYg33yk+BSviXlguGLHPxUsNdAbMc/GrgNNiwc7XB8hx4rybsAxE/3fU+1B6dBPE5MDPW1Bk311yVbTPqH9tx3V4JULU4GlpvW130sOsW0eSy/KNApZ9SXthP4E3WdpBzLpNR6fkWGxrzXlsV9Dm7TlOclHsvLVkgO9ooWgOsrgJjQ6qp0Sy+hDRip5VZuwW1LV6a1Tr3uFnBuqvg7vnTIpGJBj3sW4MZyuEmr1vMwsZ3LCQSTxFsZFepPps6Uo9HoHQ4l9blvQNU/1Q3PTC8qrWEIyyX5+ONDPn++hzEw0/KkxY2+jnxvVeRgMD7MxmggoJyY
 jsBl+hJN
 PYeUhV+/k2fHbXRV9za+vWjRiJhZraCU3bKX7L9YXdCcShiyXQXL5tAHkqzVp4f5uuRNmpFsqlsCuDRzMc3JsZFKq9gIxKyCQmZFKJZYJaivowuGjg0aYjyvTcMCiboRhJi2+hXlnsx+oYJZahkd6NVPdx5vjQ6L3BOf3y6hNC7hALOqBqflxH9lXAoMG/Xkh/1aCKIMM7o+D7Ejh5XzTCDvz2Ha1DWNsH9J+5CQIqslNmZWYknrh9FovcaGwjQnQVvBPIppbRQGXBoYJnqNnCAAdjsRO2hXB3Y++umm26XPUfZLY6sdlyt3oHax4YROKjHo5q/pXypxRkoj5EHN7xmQ9Wj4ZQMJ++caqYmw9BU8HJEoJ/eRXwwhiYDLsifmx9Jk0ASBhd/QmqV8P/jzkTJlK+pdVWy5oPoZHwCgBPQwkkFvRijN3nw0hk96e3WIFhrapAebn+kmkxM3p1zTROeofJiIB4U61cOzG2DEKsTJmB+x3LT4YCmo8OSWySiVaZKcdVNWpWcLvnNeoVfAPtW6FNZyFWNK4GUlv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 23:57, Zi Yan wrote:
> On 14 Oct 2026, at 11:46, Konstantin Khorenko wrote:
> 
> <snip>
> 
>>
>>
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
>> Changes in v3:
>> - Patch 1: recheck the PMD with pmd_none(), as only a zap can change
>>    it and a zap leaves it none (Lance Yang).
>> - Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com
>>
>> Changes in v2:
>> - Add patch 2, the page table deposit for ppc64 hash, reported by
>>    Sashiko.
>> - Patch 1: name panthor instead of drm_gem_shmem as the driver whose
>>    stale child mapping reaches freed pages: drm_gem_shmem keeps the
>>    pages of a purged object until the last mapping goes away.
>> - Link to v1: https://patch.msgid.link/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com
>>
> 
> Please stop sending new versions of a patchset repeatedly.
> Wait at least a day for others to catch up.

+1

Please slow down a bit. You don't need to respin every few
hours. That just makes everyone start over ...

Post a version, wait for feedback, then revise. Twice a week
is plenty, honestly :)

Cheers, Lance

> Thanks.
> 
>> ---
>> Konstantin Khorenko (2):
>>        mm/huge_memory: recheck a special PMD under the lock in copy_huge_pmd()
>>        mm/huge_memory: deposit a page table for a special PMD copied by fork
>>
>>   mm/huge_memory.c | 34 +++++++++++++++++++++++++++-------
>>   1 file changed, 27 insertions(+), 7 deletions(-)
>> ---
>> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
>> change-id: 20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-bdf7efb612c2
>>
>> Best regards,
>> --
>> Konstantin Khorenko <khorenko@virtuozzo.com>
> 
> 
> Best Regards,
> Yan, Zi


