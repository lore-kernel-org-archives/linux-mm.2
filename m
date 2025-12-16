Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274EBD5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691166B0005; Tue, 16 Dec 2025 01:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F1A6B0089; Tue, 16 Dec 2025 01:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569496B008A; Tue, 16 Dec 2025 01:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 447466B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:22:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D441B8ACA0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:22:19 +0000 (UTC)
X-FDA: 84224339598.17.53343FB
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61BD9A0017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:22:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=detDNI5L;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866137; a=rsa-sha256;
	cv=none;
	b=VPwcfnidl9xa5E3uO+C/3FSx3JIcsLUZbux7reyY3bBSeSSFnMxzhqKgxa3+/3U3+zrjlX
	6Eqq1Zt2Tf5EvLuCO4MUI+E56GcpDJx4dBqqbRMdMqwfiItZ4DsiSXV4+o8elTk9rXtb24
	0P/Li/hUTZ9fnZzBRG/ucY+7Av1QLeo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=detDNI5L;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDB4pFFOjEqefI5bQmHueWu/FzeTwPye7J8dm3yHS5M=;
	b=TXfVWBDzwAlTbmkEABJ7zhlUB3UV4+witX1F3mKfO8F6VebIsgWhXwGqEVgkMV2vPb0OeV
	BlJWyYnXbj566Ac8wp9OHcAiqQaqqsmq/bXWXt7COaT5/1xvBZgWW8n4csFkzTarqukgXs
	yQKEMHEVNZz05PDSEsOxju3RbCH+zeQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765866133; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UDB4pFFOjEqefI5bQmHueWu/FzeTwPye7J8dm3yHS5M=;
	b=detDNI5LmlcWHMNgKnzoxCjD7vdWlvEuo9F87H+bTMV4IXIwptHvTrCa2E97ztjNMGEvts9CF196o3j94jfsJ86mA0NjsIgYh5W/bfhKCGGx6kZeOZbX/gdC3UB/3XFaSKMfq8oqV5bAlHCBfGPwIQC3FR4FguoqaSjxiJ2QOaU=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuxwDsf_1765866131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 14:22:11 +0800
Message-ID: <9e038290-70ff-458d-b46d-bc512c3442be@linux.alibaba.com>
Date: Tue, 16 Dec 2025 14:22:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
 <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
 <CAGsJ_4xp40A3u=N5_mw00Eo6bPmFvctD3j=1Qmy3vOo2EmX3hA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4xp40A3u=N5_mw00Eo6bPmFvctD3j=1Qmy3vOo2EmX3hA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 61BD9A0017
X-Rspamd-Server: rspam04
X-Stat-Signature: cs8es4f5mai3c3cq7mfffg3ratost7jp
X-HE-Tag: 1765866135-245257
X-HE-Meta: U2FsdGVkX18yC/4qgfzeJM+GQEC79K3wDxlHm2s1l6J6kZ5d7l60pnmm37aIavUrJNBtspEgegSrUha9tEhGKEsDdY9m3MQyJ+PVqVuRqEJIrJQ8VKxv4HZz2EQo5rkj2gqhnav4IITmU7gloNRZmWSEsgf12BWsQFc2d3VJE1LoJNUphhbLAuUFaenqTTxn0qfqXpUHVLDPElKAkYSK0RBP1TF2HHhUpp4GLm3v/Goas6xIOYmENbeEpW/kmWGg7UOBgWZx//82ld9v7RQ3MG36VNOlk0uShUIAoKEq72X3s/5gAUGnfiyxxL40etXOoO9aFrIrnkKwHMw5MzgfOvY2BFpD6axV3zOUuiqIO6OlPE7s6Kt/C75CItNAzYeRogYLLEZ1mQ9wuA6qSODVw9x1iqecR69a4AbZLz8N3eM2aM44MAXRmkbADso/Y2rdF9wcvSXdlA0WTNcR0iPuMz4SL+wkq/k/akLKtmsJnu861mVgN37NPNP9lRc3obkCNhxm1noOmrbzyk30Qzqh1fmSuxcmGnIsM5HZf4037pXA9sLCOi912MTmHl5WeIRCIDJRBzARewQelxZL8yPWHukym4SZSZ5HrClUe8xdcnfEE2MIpKPriqY0prZjOz2Ibm3nxJa/7QxHymAuCgQ+bTRzzBfaHrrh/bYpS0YO7azC0P1aSvQR43SSB4ffmVLRL+A4KAnD5LTd6LrRvcwA9qelXF0ZMG9WSnMI5JS7W0kKfm/Ez2EpNu+HqpXXa2qBwF7VVVK4QmSu8ggGyxjS7gHW4njEf6P5036EH/AD24tK/gbQFgKf0V/Bpvd29/RYaPcgRI3JzhZ+5Z5egH26/vgFMhAcJNMV1fcZa9Aagub+zaOYTWy3JivX6y75a0duWPWm+xr6v1VeoGqrp/yhZ1yVmQOX9tIu86NZWEh6QNI6bX97b6FvG/npuhXlildsqUbiVMwiV6aQmFsKMKw
 u51+44uG
 g33TBuqx+/jeQminbUqT5bnQRpFn3w9FB92CLSVYVk2HNRW7uKl25Ntj+m3ER9/kg7xnQtEd05Wzg9FLt3UUO1OfMgR16N9QJhwmaVSfuMrljGnlU+6AtktYIBUQqrsvrNWjql2s8jXtB0jCq9rAaDb4QKoSxbpjopPD8za2VQ6J6h2vSVq5+XQ8r3vJ2gtga7tWB7DTyRjC8v8toquLinWGSL1Lwxtocglk7cgxia26L3YUCmPY3vDQTD8w6IyL/dj9mYeJz5tbDfE0yX0ZXubrrfQbdwfS4dOJGUReDKqKhe90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 14:13, Barry Song wrote:
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index ec232165c47d..4c9d5777c8da 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>       end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>
>>>> -    /* We only support lazyfree batching for now ... */
>>>> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>> +    /* We only support lazyfree or file folios batching for now ... */
>>>> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>
>>> Why is it now ok to support file-backed batched unmapping when it wasn't in
>>> Barry's series (see [0])? You don't seem to be justifying this?
>>
>> Barry's series[0] is merely aimed at optimizing lazyfree anonymous large
>> folios and does not continue to optimize anonymous large folios or
>> file-backed large folios at that point.
> 
> Yep. At that time, I didn’t have an Android machine with a filesystem
> that supported large folios, so I focused on lazyfree. But I
> agree that lazyfree anon folios and file folios are quite
> similar.
> 
>>
>> Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous
>> large folios. As for file-backed large folios, the batched unmapping
>> support is relatively simple, since we only need to clear the PTE
>> entries for file-backed large folios.
> 
> Yep. It is actually quite straightforward to go from lazyfree
> anon folios to file folios. Swap-backed anon folios are much
> more tricky, though.

Agree. Thanks Barry for reviewing and confirming.

