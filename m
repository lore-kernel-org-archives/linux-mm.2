Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACEDCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 17:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B256B0092; Wed,  7 Oct 2026 13:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBEC6B0093; Wed,  7 Oct 2026 13:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2106B0095; Wed,  7 Oct 2026 13:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3036B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:18:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4669AC02D2
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:18:04 +0000 (UTC)
X-FDA: 85296488088.23.3377198
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D0D714000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:18:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nCoC4BTa;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791393482;
	b=CNp50gUsa8jDxdKC4+wbkcVRmrPAZofZ1igw76dXr4duchnfvUly29y0eAAfmM73S3+dHJ
	hl86sQAaTcfbeZFBKECppdeu+tngBwl/lpGUxxZuh5EqMf3LQSfpXzESe69wRI0NZrdGn0
	p5XnMttc6MrWgBZPzmfdXVNkusi0Vrk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nCoC4BTa;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791393482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LzZLCBZAwnFCQRD6C+T6iKIcbWqnM1Cc+hDqPL1/OQ=;
	b=ADuZlUdGdyrmFM1XwKqrLDmNV5A5x7BwUJf5V3nAfokrg2+fD3VFja55exHV0jTOV1m+w3
	6/acRaHeIt3fyGtVKwW9O075ExYs5B/LB3noFucmetXgTkb5gbUk4zobyGkt7nZk5CaKhk
	q1d4yQ2qyKSHa8AxTba30GkykeXN1N8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFD47601FD;
	Wed,  7 Oct 2026 17:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5049E1F000FF;
	Wed,  7 Oct 2026 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791393481;
	bh=0LzZLCBZAwnFCQRD6C+T6iKIcbWqnM1Cc+hDqPL1/OQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nCoC4BTa7Y2Fwd6snmgAAdaRSpLP1XQB6onKnUBkDcFVGUmC+eV/z5mPHcPBhnEGd
	 paof5LDn0411OEnunMdpowPIEh5CaexGFGMxncyrxmFbTuHwaIkpBfEzIuRX6RPa9s
	 f7NndyKR0pQLEO1igol06p/bUx20z8f+fR0kusI8=
Date: Wed, 7 Oct 2026 10:18:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Keri <okerixx@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: clear vm_file before unmap on mmap hook failure
Message-Id: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
In-Reply-To: <20261007070913.3923-1-okerixx@gmail.com>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
	<20261007070913.3923-1-okerixx@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D0D714000E
X-Stat-Signature: euirrgpxzw3rg1kbrkrwyrcik4q7y3qm
X-HE-Tag: 1791393482-584550
X-HE-Meta: U2FsdGVkX1954Bh1OBLuIuidviAvK1eEwbEbavZ4qMJTu7GznzPDEQ0Q3eywgEPj4pGpYNWZW3kMCtGVqTJO+riZq5kOKr5ijbi74AFZQJbbzS66gOelJZ0m0fJrY2oVUPSAWre7vMN2wNqYa84xYLGzuBNSFFTtR1+B09+ZYtxewjrrX7Tkr6GIZOfTeFihYyDV6b8k8TTLz2K76sZePpL1BHxlWuWzohEZYOi/e31xgjyB80nCewZ6ZIInWWBAJZy6USvyCkLfoB9bzsnhEy257Bn/asNRdzCMeDYxJms0dAAKB9tC4zZW9GsvB+JWzh5CE+LSwtsm0a5D5QLUKih5TLNs1vgYeW+UwYnuvqaI3b3JZLHtacNM3sMOkjR5xHRywMAqvfztqPfUdxPn89is+jBn7gMUQLHgR0zFsp0oRRCq25fgH5Jybo42UI/ZnkTHZ2lY9Wu9jKddT44lNLV7RNszeBm6ERXyXUqipkNl4iQ/8y/E6bkKIyTVb5P2pF+Pbfj8JeNQS4LxS/e55OhIfjMNzlk9n90uN2Mh2rhM3QCqZnpRu6gULnrMYzBz/bGRJdFj+Cp6E60wflW4D9dGZEBmlzpAhOaBDfMxL8IZsz0wa7u9dER+P00NMlERQNv24qwGIEEaTcS+Bna8LhStYG80FwD/qLc4s8/G/S2IbGdzgv5pgeduLXaYUNx9/HoEgA+/1X7V8JyR+MH28T7HlB3diFHyZ5nN63pzDcZtcRA5ZgeI6rMDf4O8k4qdq9vBxE86G2yCzr/Fcc3Z9mbLGhrlEsdrvNGIM1ViUG4u7z0fafDPmynkSB5ikIBTcgwAo4lk5u/WLSVbceiN+bhdVQcz/VtX2Ek9DOq1bnMUInuXUqZOQ0i4skPOU5HbXRuZLVk3FkjxBS6+MIdeV8qOW3R13nPBBBAUxvgl+JgHcrPBSuk/b6KJCbvZK9ykPmUl9HSLdskYgIvMiwm
 DsoVvs9G
 XVJMlol6kG4vTAqjMWdsKax5a2jUm7oGiLa37r6GeAxMZkGoW3lNDr2xzMfgOj8wOtmoQA9WSRO8hKHYgKjm9jtnzCHjhh8YmTnUlUwtBRbdHMK1VqsZIiuyoH6p12U+HxjVHZgcjSUbPor/ZRvEEVjCEDzV0FfuXIEWYmvGDz2qe5ZeH3XqeATptsvv7Amkz0a0pNKD5GERoOcY4yD2sgS+SvMRt36UbL6LBa9EbXCWkr23J6yGlDrN3/weXvVY7h0lBRReL80vB3JpjZEGgAcrk78Da6ZsfMbwL0foCk9DASHYgoJjGPwYeEs93mQaW74UHxSg0cGyGLonP9bIQ1grWDf4GZFGzIYr34405iYl/MIFZ4SUmPJWWVlRirffzzhX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Oct 2026 09:09:13 +0200 Oleg Keri <okerixx@gmail.com> wrote:

> Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
> mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
> after unmap_region(), so free_pgtables() unlinks the never-linked VMA
> and drops i_mmap_writable. Once it goes negative, every later shared
> writable mmap of that file fails with -EPERM until reboot.
> 
> Clear vm_file before unmap_region(), so that free_pgtables() does not
> unlink a VMA that was never linked to the file.

Thanks.

Sashiko thinks this fix might cause a null-deref:
	https://sashiko.dev/#/patchset/20261007070913.3923-1-okerixx@gmail.com

> Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
> Signed-off-by: Oleg Keri <okerixx@gmail.com>
> ---
> Seen on next-20261006: one refused PCM mmap probe from alsa-lib left the
> device unmappable, so PipeWire could not play anything.

Not good.  I'll add a note against the suspect mm-unstable patch.

