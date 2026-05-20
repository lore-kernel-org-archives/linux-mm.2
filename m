Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3CACD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EEB6B008A; Wed, 20 May 2026 10:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E906B0095; Wed, 20 May 2026 10:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D376B0096; Wed, 20 May 2026 10:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F86B6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:38:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BB9BC17C9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:38:55 +0000 (UTC)
X-FDA: 84788055030.22.D97677E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14633140013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:38:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiygwCkV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779287933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7rcEL73sq9QIWTen1JeXHihv7DANv0+QzPRZk/coa8=;
	b=gmEHS9504E44ce5ElrZj6yjGneO2cj4YYAgLXtAzULYwohGC+TnuM/SWcsaqgjoADbt4f9
	jnZLVA6vGwTF0R0FaWefDOrkZbhoj7TMpW41Lcg0FGDpuePL12xUsgzSkFu0qHYSovKiMw
	fTj480pumHfHdkg7pX6gu369lmxxXxM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiygwCkV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779287933; a=rsa-sha256;
	cv=none;
	b=VQ1V3UB2YM+Qy9hbnCNHcVitqVkoItSIzJsPvcgbOpipjexzJcIss/XU4kkuIYjbXj+wr0
	QmrDIn9h5KDzWf0J7WEjS7+BNQHDYt9ZHlNnQpA3/3QhfXypP9RiIwd7j5BRmvXn1MdqtN
	6Xk8OV1isZAfhxPn1kRMz7ZU7GcRvAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BEE040DC8;
	Wed, 20 May 2026 14:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D58E1F000E9;
	Wed, 20 May 2026 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779287932;
	bh=+7rcEL73sq9QIWTen1JeXHihv7DANv0+QzPRZk/coa8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PiygwCkVUt7wLXGUiPZY86Unli7lub9d3buEBZOr65YRoC1wzH5aT5wxU5wqIS0/N
	 MUHhZlSALuWQo87yE9npFAr27wCLmzgXO9YW1AAcmGEtxvI/cSAG/sRmD3vLRAl4pB
	 CxV33DmR7dwu9CSvSQ6yxcotUq0vrmTMTLg0i/gA7WMqYWeEb6oOR7e9I1AUO/E13r
	 DsqZZNRe9GNynCmMXnCj5aFXi2o6H0uBRsuY2pDyTF8kBlZJwxCEPpNiRiMrEU0qMK
	 fuK2I1wYgDJH1z20JZ7rXkbJfdP+4aME61fgYVka0z3XQrjqCfh+hhtpzzwF70yqrj
	 r+qKSKBGGrisQ==
Message-ID: <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
Date: Wed, 20 May 2026 16:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY
 retry
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <ag3BNLU1b6p9u_6K@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ag3BNLU1b6p9u_6K@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14633140013
X-Stat-Signature: hrq618dumtwdcsqkbu5h5nj36w8x9b55
X-HE-Tag: 1779287932-648156
X-HE-Meta: U2FsdGVkX19rNGE6wDXppVCJZCCAukUF8xyyCq0R1/TQXskVLAPqz5dJ89oglSu9mQo5VUSbSXv9GrKP8LTuo4PTS8BWF7bb8Hk02r4iCMgrsgptTh21PzSHh5nyMiwhoKfo1WuIEaRFc9ORfnwFstzrSaS6rLY3wVZ6Cl4RtFw5CaF54NCQUCX6fCsBKhJQGMfqSHyQrcBbNinG0c2ImYMw0x/892bQJtYoL0dZqpBiagPYh+w7ofGWqU52DsJGu1t2pW2idb9vqwHeG3/k0+nN8mo0UmUIrtVO/HD6l2H4YNhWXYdR3k5I/5FBEocb+oFcJRS9FC7UKZaHhIe1qNWdSfpx0WznAwC7P+DD316zgnoHkPleWQi+EBmRwzPHfEQdzYq+EGy/Pvq7TVz5Apcz17JWMYVDvC6ejo27rrnUy73h+srMB2JLo68ILWxeL+hY4ZwL5ji+fy0YinDlHxWl41sXMgLwOwwFb1lKcexzfwseMdf0gs1p28sTts5nh0ASnAP/88iw9LUEFfm28udTDUGkFxgEu/m1frRndXKMe7dZdSe8LmWFCc7jrUtJe6Yfvlmcw0icLweGsViP1mQy0Zh6nGUT3+/uRP4Jk5Rd/MXR4qde0PyJMORP/v3dFpDDnEeha2oYYdUNIbFLCWh4fXk2/bJ7AwYTolnYTiqnmeMNgRi5aEQfRi54CiHXiL9MGM4JlBftbsrihnw2hNO0RoxxCi0sOy/eMBLYBzPYhoAoTj2yc2XLn9XKM7aLw7KXQmQvcMjhszCvlLvZ8iGXT5PYFAjm1QuiV+DieaL86Yt6VcKyOmIPUBLs2PYsmPP7vhDHifr6C3I70+RDGFDwI4957P3LD40sHwIT01W+4LiGWKBGSMiuvdLXKjd1llkC5FVNAZz7llQHMF0jh+g5nLBkINpkxsbteybhsYYlTZC7JnqkPQPiA8uUw4oY/lTfaBibTCZSAPSrF51
 KbJGhdd2
 b4h/9wuMUYvKFLEr6dAbA+qcn4K6LMSkTTgC5vlL8jDPRKOxa3pZzAIpQVu1PXMTXwqtfdcNAUYyFUNl6kXRV7SMK9sJmu506gQzMRoqirz8W3Ku+pvd/wx3BJdpfddUb8kCXuFtFCB72tHbP/jgvPgF2BwpN5wd1bDxhN3jHbU9jVGE7aE/+NjjVmfOju/94GFsjedxRnT2hIWkZQ8j1sqiMOkgso6kZwZ47YEEsLx8+vl9N3Tja8+5GpIngjGrudk8JeCzZewniMsBcI4WN6t1RxO8UccbZ9vCWCWGEl7vCCtAS5KrPFHzvhqxWNroD+xTHDUqDOP7KgGPxnBByPMAqTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 16:12, Mike Rapoport wrote:
> On Wed, May 20, 2026 at 03:48:02PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/20/26 14:53, Mike Rapoport wrote:
>>>
>>> Do you mean per-VMA?
>>> Per-MM counter would capture unrelated changes, e.g. an masvise() for
>>> unrelated range.
>>
>> I was thinking about a per-MM thing for simplicity. If there were any changes,
>> we'd retry (-EAGAIN).
>>
>> IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.
>>
>> Not sure if unrelated changes would really be a problem in practice (another
>> thread gabbing the mmap_lock in write mode until we serviced the fault).
> 
> Let me reiterate:
> 
> A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
> re-gets the VMA and checks if the per-MM counter stayed the same.
> 
> If another thread makes any change to VMA while mfill_copy_folio_retry()
> waits to re-get the VMA, the counter would be incremented by another
> thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
> and will bail out with -EAGAIN.
> 

Yeah.

> So if another thread does, e.g. MADV_DONTFORK on completely unrelated VMA,
> mfill_copy_folio_retry() will return -EAGAIN and I'm not sure we'll not
> break the existing userspace by this.

Ah, you mean that -EAGAIN would not be handled by user space already even though
documented in the man page ... because it relies on -EAGAIN not happening in
specific situations (i.e., copying a single page).

That's very likely true and we'd have to retry internally, which makes it more
complicated indeed.

-- 
Cheers,

David

