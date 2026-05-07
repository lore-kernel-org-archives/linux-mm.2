Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EC8CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 19:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92606B0088; Thu,  7 May 2026 15:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43686B008A; Thu,  7 May 2026 15:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A036B008C; Thu,  7 May 2026 15:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B630A6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 15:06:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FA441C04B0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:06:40 +0000 (UTC)
X-FDA: 84741555360.13.18EF6A5
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80FE24001B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:06:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=AnRkkFmc;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778180798; a=rsa-sha256;
	cv=pass;
	b=zmm1oNRivuYpqUh5qX0moOadZB8GeJt8w1rnL7cgCYA21hVlF+VnuVmU145Pf8zkPIPfcT
	fW6yvn9/OeY1Hho73w6zvoFbK3Naos+8BoCTCqo1V/aOlK13qkADccxzXkpSUwkyHVVBKh
	5DUlZSrowRq8rdSMhjsM5pp1pw0/Uu4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=AnRkkFmc;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778180798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy7gplh9AWDpJJWOHt4Q3bkufap80ZtkvEdDH2UDMl8=;
	b=LeOYhB9xnW5Bj1UBCu1mXB5kZ6vEU4N3hR2RInHeOP5epeaVnAuKlTCUWy25T1njtLJ4NO
	XQ1jr7FLnBjdrx9aUbSfomyh3AX5F3QtGtVDCmDHVLiCQ7QlRjZB1NK0StkSBL8qv6/qwj
	+/zrmKYJD7JFTLb2DY+Emd1riCZqe6U=
ARC-Seal: i=1; a=rsa-sha256; t=1778180780; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Uc7rmArxEsP5yRFDmQvAPUEaqLBjHGcfdtjHNWteLfiIFwqTitP7GFXqu5VlOXupbKrfPkCcvuM05KMpZVmA+Fg/42kpu/rEYW6u8T/KbcQmBhz12yE2oBDRhsnq/ghmI2flrPfyltQILVY08OoEgyvjEbIzc4Zv1tgtKK3WnFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1778180780; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=hy7gplh9AWDpJJWOHt4Q3bkufap80ZtkvEdDH2UDMl8=; 
	b=G7yGC7Dv1ws1BNNPg02xDD2fcNLf1sYQ/BnFLT6UaCkwhJiYXMTy9tqeON7LYBzFWxxIDsf3u4OtWEl8Rh4pYmhemgfHYoyPxQkQYhBnZ+3HJykV22OQiXU6n/FzCNvtF2Q5nFgWuvmoW6Z52MPdVk+nR0keYGNvejDam/+260M=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778180780;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=hy7gplh9AWDpJJWOHt4Q3bkufap80ZtkvEdDH2UDMl8=;
	b=AnRkkFmcv3oiz4j5gPCB+STOw5nYVL5Plip1a2pmRv9uHHIrKMe7RMBRhA3d+dkh
	+uPRf/HJlxCuBkP475pGGLl0/duFOGNiQMJYJrGKstZ4BGyVeDqaKTGM7dGam51mLho
	yIqmWhPfa/p4ww+9zV4RHUm33UsxbHmCKM14Fb4s=
Received: by mx.zoho.in with SMTPS id 1778180779424705.8265284288666;
	Fri, 8 May 2026 00:36:19 +0530 (IST)
Message-ID: <a165e1ed-60ce-4836-bc58-96b4514861b5@zohomail.in>
Date: Fri, 8 May 2026 00:36:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/5] mm/vmalloc: use physical page count for
 vrealloc() grow-in-place check
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
 <afuMvOTfj977Bex5@pc636> <ed1a55f5-615f-42d4-805b-5f53ae2a529c@zohomail.in>
 <afzKM3qRDI5JOycs@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <afzKM3qRDI5JOycs@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: 538ynxt5ak6tpz3icpmufwah6yk8zk1i
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FE24001B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778180797-229844
X-HE-Meta: U2FsdGVkX18R1tBdsXdbfpYtTV9BrUiY25SSNNBvb2lo4O55JRBDsVXuG5FF8nu0Tcsbt/kQYxxrqcWaZTYLSJ3HdD935+fNRHXpicQvhR+E1LhP90lj5dgjtFVYyiS9CKqpSDLYgfRfd3UM+j18dzk4J86eDwQtmwJGi6zPGKEBMQhJnzG1RQyzMfqtziHEFegqUOwlirj2PMlvtnLTCpKmo3F4VIY/5DZdrkhfSQRvaHPqsLE46CEQxkm+pbBLY4ZFJy4r2RoJhh9GvSJfTOV85+6t98ZN2jeGtfFSGy4k9/6pxTcZh4rAIbWWH8i7A88u5NP5QnyC/bhYKVw8WIZkDEsqUs/XObaFcLfOhXBvOlxDBg+NkBf5eRxrtrLhKxIssgX/CxPfCOo2CJJ/LXeydvo+XHFChFNXNBLMcgrDPRzwFm2foPAAbDZL2hnthsyTIN1oD3reholj64YHU7YnMdHql9FkQEVBhCp6N8c/Eu/WT6W2a0LBg8U8ScJgTmPbBLLJMiE7+ODgjaxlUGluZJLyQDzEdnQkw5kpNVROPm3HR3nXivKWZT1zQ6sdHUhCNDyOF43B2tN9Ohjcoe3YBRXvcDjWmYhbBcc3Em9Ek5ViCimqSSDiEroe4SsgTUrOJedXzM36KjLX4KF7FPfa3XjneCHatV+Cshx77X5QVsPHYH/PWiTytuO9SUMudYKjK25vgfRagsD/6f2mctDdOhE1VmhsZ2ODfJYoeMrJ2K9NlTKJfczG8iiZ0I5FW8v1KQykT+u36kIiF5ej6S6SfK0W51MZyFcB0OL+o0GOkwfmA5PujakcqdPNNAYQuxymYNQSvwYdE7fKrlO5+9KlON+RTaJYOxdczHmy6/MCcNoGIFE7HWTice2Mj7wi8LnxAgnaRYscx7WCRTDoijhap5o1RgtZV+nI0G3CTGLzDYxP11U0zH+VtHtrp6unVZ8v0dWAG2RzXtI9KOR
 Qqii9YEf
 8YCd1wcISrE4bkVfgo1voPOGgOD3XJtIceydTtt/GOBO4UXUAXmZZ/+IciiWC4PxHMrAPZnm4wDFJ4onjJq4NL2Mp8fcu/zxenfZl7cnDRmF5zWhLP9WmC/lHlQsWtTetqt2erjTL/B/LA9U1uPbe0suLcXcW2SzMCk43gCEWDu/Kdc7tOdQiBTEFn+9cyhtNegwmQ/pD7DZ+RGmfiFii3HgZmZPH0TcZgw4tLNxRd50f6jLczbgfjX1APsn1jxo381LGW1h2Oa0cMvDxg7zxQ1Cyu7IaN0nS4tAFDFgkvW/PQjQMdFKuEQWy8YM+AsEKCtmUg9k+PdEvUI3uySOOpGH2OSIWEwh5FfMNJb5GU6xtmAMqPzyV15qG1FXn3wCqw6wK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/05/26 22:51, Uladzislau Rezki wrote:
> On Thu, May 07, 2026 at 01:13:35AM +0530, Shivam Kalra wrote:
>> On 07/05/26 00:17, Uladzislau Rezki wrote:
>>> Maybe we should consider Fujunjie approach and borrow his idea to shrink VA also?
>>> In that case, we do not need to switch to vm->nr_pages? And we do not
>>> need
>>>
>>> [PATCH v12 3/5] mm/vmalloc: use physical page count in vread_iter()
>>>
>>> ?
>>>
>>> --
>>> Uladzislau Rezki
>> I didn't want to change the va in this patch series and wanted to keep
>> it simple.
>> If we change the va, we will also need to rebalance the rb tree.
>> I can work on a followup patch series if VA space pressure is critical.
>>
> Actually it is not critical. The idea is if we shrink VA then we do not
> need care much about the size thus keeping vread_iter() unchanged as
> well as [PATCH v12 2/5]? at least partly.
> 
> I am find with it anyway.
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> --
> Uladzislau Rezki

Thanks for the review.

There's actually one more benefit of this approach for a future
grow-in-place optimization: since the VA reservation is kept intact
after a shrink, a subsequent grow wouldn't need to allocate a new
virtual address range or manipulate the vmap_area tree. It could
allocate and map new pages directly into the existing VA range.
So for workloads where shrinking and growing occur frequently,
this approach lays better groundwork.

