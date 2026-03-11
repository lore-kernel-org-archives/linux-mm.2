Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2B81125811
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03DA6B0005; Wed, 11 Mar 2026 14:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9936B0089; Wed, 11 Mar 2026 14:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA246B008A; Wed, 11 Mar 2026 14:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9A8F6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:28:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 733C98B56D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:28:05 +0000 (UTC)
X-FDA: 84534616530.27.2970BFD
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	by imf27.hostedemail.com (Postfix) with ESMTP id A6F4D40018
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:28:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=eGsrYbRV;
	spf=pass (imf27.hostedemail.com: domain of tj.iam.tj@proton.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=tj.iam.tj@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2dNayaBL5eKt6s5/rNfnULinc8m7UJIH8MLEilLX2c=;
	b=4tj25/iZJ8Ays8SFKY2uylxZJ5IZe+c95C8BR4VVeSeCWh3p4k6m7Re45pcR2+rf6zVTE8
	VV9q2e0r78WYyUX2WU5T3VLnsW1dUe/aTHQKfoNFF9ODqnkh8QRDR9YwknEs2mtbXBNrUE
	4+qAgs+ZXYu9eQm9P5k8JvwwtPRLCTs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=eGsrYbRV;
	spf=pass (imf27.hostedemail.com: domain of tj.iam.tj@proton.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=tj.iam.tj@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773253683; a=rsa-sha256;
	cv=none;
	b=iE3Kvwo2Gozp69VHPZtoKMM0dfcGiV16ohUpWzNsmG3rzb+UAQXSZMOV5MNut2EoZz2ojh
	JGHmZX9uc0G5bil0QIo9DoI6J23U5DFWBRWzIS3iRiMA75uRyCgZk7Ne0fUteJu7LFERIl
	46slNnIBTqWXY2dc9ECotZANbV4OtSA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1773253680; x=1773512880;
	bh=V2dNayaBL5eKt6s5/rNfnULinc8m7UJIH8MLEilLX2c=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eGsrYbRVVOk4yqYxgBVXbdu9YJj2IgJrQPT5TGr4kYyK9xzH9rpDE/zlOlduUcpyI
	 WWtqsP8U0WDmFKkvUiuuQZlZbCK5YtRsW2OTwR7s2zkH7oJcjWvRKAlDOUIsTrPzCm
	 SEog6OlJv0i5ORqwCD6OnDWnf1V8XjtzGBww1YK//YkNWYn8iZH9p9i6v/2pUQzhgb
	 yH8QbtMBGBMq2NnUJ3fSV6Fhgdk6R2MVTWwMRBrdyVgv5Y+UmchuLyxbQiigdsRQJV
	 RuhNeBcndS6zSxJE6zZpn4m8nyA22mUr5fClpx8Qs90h4M2Hvak2x47cY+pcbhqS+s
	 mDFm2/oIT5HLA==
Date: Wed, 11 Mar 2026 18:27:57 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
From: Tj <tj.iam.tj@proton.me>
Cc: linux-mm@kvack.org
Subject: Re: BUG: Bad page state in process kworker/u32:1
Message-ID: <2fc7c354-4e05-49d8-87c4-d80854033759@proton.me>
In-Reply-To: <9115acdf-edf8-4abf-a59c-8980c1375e67@kernel.org>
References: <4df99438-637c-4919-96dd-1fbe6dce70cb@proton.me> <9115acdf-edf8-4abf-a59c-8980c1375e67@kernel.org>
Feedback-ID: 113488376:user:proton
X-Pm-Message-ID: 328c4da44210ea01697433e3453ddf77692c65ef
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6F4D40018
X-Rspamd-Server: rspam07
X-Stat-Signature: yaneb3qtoh4reegafr79wkqh9qh7u1we
X-Rspam-User: 
X-HE-Tag: 1773253683-665142
X-HE-Meta: U2FsdGVkX1+qUUutqppi5FLW0SKI1WvyLCNGenLng0mwn5wtul5hfD7aHjZnyB28i1/FwOmCWQFqAe5qsX+tjR86w4ITAzYkBlc6dwD2KLIR9S2FO7oCDAa76XyLhf1s/cC6O8gWmyRfeKK5FbOJbNqCSJXgDPIDtGmS2AETCCkHyR4K1K6fnbFmg9zRFGLEBjxj+y1Ix896zfta0fiAQvyNXX3W5ghUsHXmInIh9uPOlYVasv5wXCQvJriUMM9sYLswb2LdvaqPEYF5VxL0e4uuiNrQHCC9/c5nT7Y34QqPGRpJm6Is8n5wQi7RVM8Rt0DMAzHRc2RPFnxwzjeRWvrD3yLj2No3mS8LppI3NCG4R1vNETENGrWyEt9Sqt4/G4DsUlc0l/PPcxWQZFZT+ZvViVpP1IUiVwOz9eUN+CZ/2yAtASwXERyObqUrCmAWXN2P2S4lkZ0r6bQNxhlyhtg9yqd1MK9WFypzCyMknIzp167XTbEWEAwhD8KWleOHsuI7AMW+bPWgcgJhspHOSl9QzdJZKbVrEmScAZsPr/98D0MXsxI54K8o+Ij5Ci63qwcz6MrwpULNQkvOT5sU38Rmw3/fcq9K0kmlGiQTv+2muLDZNkhIOXnaHqLSC5eI+CKf1KdrnNsSuuJ7T1scQN8QKktvscrxpPxzOVYBho4kTaEjj8cNODPvZhLqCqpxYCwuUTPmizZ4bW0IljSIhkv/5IT10BZj9O61SHZDuXzoNFAmi3grTmU3F3P2qXUBeYylsiXJr5pvsROX7QlQJGdKE0JwvSjFYh5Hr71g0jaHKTEpdca/dP2ScdD70HX9SwSAGe/fKQpnjzSIvzSwdyPbEgUmOwX17a59+qYC8UcHpb+VjbxZU3bFiThl38Dw579oQmqwLhpz722Iw0OvYgr88RPFALezxIdN9wEdrKevimZRU0Lt9REEk7xMKE2UQSZnIi4jF4xdtaUAqYu
 6bRryNZJ
 33efPila7+CrfZjQqaaPErZ+gkdhiL7X3/9lxXdWOJhAmRfQOiZXxr5xf/L1jDi2hNaS9bJccuIvBTFyJ8kU3hv0XD048FW2erDSKJuVFyq/oadzCgG4MCSPF491pVyGdGy0HYXbo6cNvG8jMipMnkdSR066/9XZ2kksAw5Gibzf7RbIDI0/Ql2kaf4oGZoPjLokiDX819dGLstyGrzFEqsWX0Km9neeL6IRrJruJYfsMMHBEOaff24a0UNyE2HocdWZ6657El1Qqx5kkIX4PR8Z3MjI7aFFOJM2fSkoUk5ynZ807WHisvtct7fFEbeqJkZ/RPbCHulcPW2Z0K2WHfORN3ZU/uo4g6igjhSRmD8w4SNJw3DHoeJWbdrfW8am6mPjXAyiHLjwACQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

That fixed it, thank-you. Lost a week due to this thinking I'd done=20
something wrong since I'm working on getting kernel working on Samsung=20
Galaxy Book2 W737 and many bits from device-tree to drivers are problematic=
.

On 11/03/2026 16:17, David Hildenbrand (Arm) wrote:
> On 3/11/26 17:12, Tj wrote:
>> On arm64, Qualcomm sdm845, an attempt to allocate and release a CMA for
>> DMA fails. It seems to be caused by the recent commit 9bda131c6093e9c4
>> "mm: cma: add cma_alloc_frozen{_compound}()" where cma_alloc() now calls
>> set_page_refcounted() but cma_release() or its callees do not undo it,
>> resulting in:
>>
>> kernel: BUG: Bad page state in process kworker/u32:1=C2=A0 pfn:f4b00
>> kernel: page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
>> pfn:0xf4b00
>> kernel: flags: 0x1ffe00000000000(node=3D0|zone=3D0|lastcpupid=3D0xfff) C=
MA
>> kernel: raw: 01ffe00000000000 fffffdffc1d2c048 ffff800080353608
>> 0000000000000000
>> kernel: raw: 0000000000000000 0000000000000000 00000001ffffffff
>> 0000000000000000
>> kernel: page dumped because: nonzero _refcount
>>
>> I've enabled pr_debug plus added in my own pr_info()s to track the
>> callers. The following shows, first, my manual dump_stack() in
>> __cma_alloc_frozen() in order to understand the callers, and immediately
>> after the BUG.
> This might be fixed by
>
> commit f4355d6bb39fc8e53d772fa0654c8441b214e349
> Author: Zi Yan <ziy@nvidia.com>
> Date:   Tue Feb 24 22:12:31 2026 -0500
>
>      mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
>
>      When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP.  Putting any
>      statement with side effect inside it is incorrect.  Collect all
>      !put_page_testzero() results and check the sum using WARN instead af=
ter
>      the loop.  It restores the same check in free_contig_range() before =
commit
>      e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}=
()"),
>      the commit prior to the Fixes one.
>
>      Link: https://lkml.kernel.org/r/20260225031231.2352011-1-ziy@nvidia.=
com
>
> Can you double-check?
>
> --
> Cheers,
>
> David


