Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D7EC79F85
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 23:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82A76B009E; Sat,  5 Sep 2026 19:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C529B6B00A3; Sat,  5 Sep 2026 19:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91FC6B00AA; Sat,  5 Sep 2026 19:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 976036B009E
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:03:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 197F64039A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:03:16 +0000 (UTC)
X-FDA: 85181236392.05.6E33118
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D55A100002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:03:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kI0Tv3mJ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788649394;
	b=33pIE3Bd5tHKL6m9RgoAVKT3HpVH3PxlKzQRrsiOXD6qhE1IUO26JoFyqjyUt8O7GIkWm8
	owrSbSn7cKdhMbHXymhvQJoXtdyJU+L92LFvWsc9LQP2kp4wMZWz8rWepWM2HXRLh+/IPV
	xZ7hw++o8VtYqf926j6UQjvDZO43/4s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kI0Tv3mJ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788649394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hErLB9whZgGx97oqfvPVfLwr+uJm48A3QwZhyfIVAfc=;
	b=t2ShqP74RfT7S0nNBAPf5T72N6aCVX0gcvBeloe9WDunAht2Cmq+csjXJzDz76rB0uyz7R
	P85COld8bAozSp2Qg7A5AiBiMZcvU+2jo8FVDu0DrVaqDWV3QJvtlnFmNmG94mVEJO+Vnh
	h6Cf79D+awycW+33jBe3IFHMBip52dI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B61460A97;
	Sat,  5 Sep 2026 23:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86951F00A3A;
	Sat,  5 Sep 2026 23:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788649393;
	bh=hErLB9whZgGx97oqfvPVfLwr+uJm48A3QwZhyfIVAfc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kI0Tv3mJEIZm9VmEyQS5AwmIRYNpAFOrDXTC1qjfpugX0SgopyQV1yg1j+BDA0vlt
	 I/P3PBDHU+ENnuMqS/E4joZ6HmZsW9U7+RvsE9/saNTWOUqIYYJ+QLN1NV3TbB/VJv
	 n/a6ziIjuJXld2ySdpOXUXAlXVjPSRQ0LZeFoZmM=
Date: Sat, 5 Sep 2026 16:03:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <weir@nebusec.ai>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH v2 1/1] mm/memory: constrain generic_access_phys() to
 page boundary
Message-Id: <20260905160312.9717eb43a63bed4de9f0248b@linux-foundation.org>
In-Reply-To: <eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com>
References: <cover.1788531737.git.rakukuip@gmail.com>
	<eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yr68u5j7e4t33xyjpdne491nrudzqgfd
X-Rspamd-Queue-Id: 6D55A100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788649394-655301
X-HE-Meta: U2FsdGVkX19KeAQUUiCqd32Kce17UaDzFiU2GVdAKp3eehov02TSTqhA5uWDmoXtt8pJsmh1zdAgRrPFWcW/dma3BPkIVrRlExT6mZNMh8/SmHJO+kn3F/+R4/riXMj/K/3rK+GFoYjNxAaZufj2CPO/gbaDAN5+CBLdKqMojzW5ryLthmutKelUaPtcpFprRYF361LsjJNqoCZHfjE/iFO8WJ4Nw/8qGOCJk2F4BelG3YyWsDKtBveGMzLgDG7ow7Kr6ayIqRUgMkMeXyofTi/+Qf2swWmA5jLLnBuGG1tRMb0DvZhwsAu8DrWFSvSOX/D600B6JHrLHDHFdgMRRf3T019Q1j2IoEkjXoAhnpKW3N6v20mRTMsC1QKuLEYtg7P7csVeowYqg8Pyat5oIVx6YGWV72HWoMUEAp05DFaUb6sqmiyxeJrHg+mRaGzA+j84PF8BFCIhIoV7FgGe2IwIIbONzEpp648jZNrDPEEOysbTRpw5XyOc9e0AlIYbL/hiJ/tjOY0tSMHGiFt7jdPLoMdkEWy2ub2JpufjBvP3ctMHmt70PEbX1RRhlaV8Vr01A5O2rLmAhT4TlsmpXZmj2Pee8p2SXEOrSbdVYmQJI0R+ir3fRYicHhSYPUJaWzQRXF4plpP3ZMu9EysZf3Lr5NA/7wPk+irHDtdOAcLmbQwJb5baJ6gAwRFwepX536O4uDwNkYnBh+eKL8pUVRhQsz6BvoCk2gc1c4ql7jvl10MC8er24oNQor+lnPTwohqv6XIFKzZdRbecjfTAoqQa5aLMgxVGbuhmieENCcALo0iLOtU52pVg6BIvu2/TJyl6wWRWzK/cIqkc1nrUjKmqcLRzNwOtrO4Y/fcUb9gJk1jcSQAOOhwNzWxA5emkCXWTmnFyulLGsRR0XDjEDwJ2HBlWWVNdRe+PLaN9bInz5kgGEkmWR6S/Ht3VIV34PjKjrVSYgOsXn7sKAfD
 nLknrVyU
 eGCgg5dhvUdeb7ha8r7VT5N35eUoQhi98Jidr/iNQsBYZeszNDcorMSgQbddzPWROizaG4rxWdW8KvEOvoG5JJfIyQKh10knOFLEQhMmWmnSSNftv2Np/3DCEE3piv2C77VLM0s+Zm0Bwa1De79YrAelUNoqN0kVZlZpDlktgFUdDjvFIWe0NhSOvL588BSHQhLdQIcj1a36bYcQpn08Ozy8H7u7GB3TVMWR7VQtXbhMjbyqd9HDETURZqW6Mw7OzPa2kITbpP7AL/8+B+ihdjZBBaAtY9UhZrB1Ae+T6YUiCxT9gyJf69BTO2Ril6NSEdHiO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  5 Sep 2026 22:12:17 +0800 Ren Wei <weir@nebusec.ai> wrote:

> generic_access_phys() improperly validates the memory access range: it
> only validates the start address using follow_pfnmap_start() and passes
> PAGE_ALIGN(len + offset) to ioremap_prot().
> 
> This poses two problems:
> 1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
>    physically contiguous, and individual PTEs may have different access
>    permissions or writability.
> 2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.
> 
> Since __access_remote_vm() already loops over the requested length and
> accesses normal (struct page) memory page-by-page, constrain the ->access()
> callback in __access_remote_vm() to at most the current page boundary.
> Because VMA boundaries are always page-aligned, this also ensures the
> access never exceeds the current VMA.
> 
> In generic_access_phys(), defensively clamp len to the page boundary as
> well, map only a single PAGE_SIZE via ioremap_prot(), and add a missing
> (resource_size_t) cast during PFN re-validation to avoid truncation on
> 32-bit PAE systems.

Thanks.

> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> Cc: stable@vger.kernel.org

Why are we proposing a backport?  To do that we should provide
recipients with a clear description of the userspace-visible runtime
affects of this bug and I'm not seeing that in the changelog?


