Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9779CCD5BC7
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B960E6B0093; Mon, 25 May 2026 02:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D806B0095; Mon, 25 May 2026 02:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA9D6B0096; Mon, 25 May 2026 02:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930626B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:21:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 242B940173
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:21:41 +0000 (UTC)
X-FDA: 84804946002.13.00ABC1C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 482BCA0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:21:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Q6R84yEr;
	spf=none (imf15.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=u6zKl9qnP1hXczaaMGz7ilm2seNJlSk+ObSn3+7a228=;
	b=aw0XBmPE6LRzp+5BHmJ+p3viB4NsQS/ZIzRquYUW/7R4oG7xBQpZ0pSQK5bPRw07ICUbXL
	84N8EIPtD0/AvZdiFSbbv13L+jdH3f0IhEGynYvxvRWOFj6oJ/jo+02vS5bjXW1dAUv4Fy
	2c2qHJwW03COeGbq2dKoq/hVYXWJcCY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Q6R84yEr;
	spf=none (imf15.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690099; a=rsa-sha256;
	cv=none;
	b=iFwcCbRm32Ev8Jzu7vxdcPtBdSvNnrjXFkZ0elSMkfu1XWaZyLQ+0PMAG4v0d4m3cyw3W6
	15UE3Rj7+R/bA7D1qM78E6CgDSV3wPO1M4L6lbZncDgBontXQxRFilWIz0+4KSu0hlUwc7
	IY7OxblSp+zaM81SqoJkNtGqQ24xie0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=u6zKl9qnP1hXczaaMGz7ilm2seNJlSk+ObSn3+7a228=; b=Q6R84yErpMKmdghfAxPpEVTgXs
	ab/TkoPdqEtIzV6x3bBxmGJncObuVgjtqyQ3gNdFNG7yuHe/rbMaJ9RTuh67b+OtVcjSgxaoFJqtu
	1JTv/UhhwKAx7NuDaTobbogBSpwp/o3B8QyfRc2zXsT1KKKOKTQBkH0iFe6c/ih8/dA55uwpt+90X
	rXNsdb8u+fnhCutZOpwEGp8lVBVrANCGsgxoMPw6o1m7tG2857HRKojm+UcY/083Kxg9Zp3zguAfx
	qDlrtsDt2bUnvzFtsdd0976FboRKYNUjH4s9GYpquer8CePhq5I/ekgdAyMdXyKVPCkK5+XMzmMv8
	pw6UUTaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wROgv-0000000GPAI-3Bil;
	Mon, 25 May 2026 06:21:33 +0000
Date: Sun, 24 May 2026 23:21:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
	mripard@kernel.org, sumit.semwal@linaro.org, lkp@intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <ahPqbfH54R3JJyaV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522225853.878411-1-tjmercier@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 482BCA0002
X-Stat-Signature: cuxrh5mq6cx9zrnfkoh5forsg1ekyt9f
X-HE-Tag: 1779690099-587055
X-HE-Meta: U2FsdGVkX1+a1hJgfWn42pCs/CGbu7Nssa83iW8bC7uF2EcvpzU7fpuCQnMuwZARKNAmXP3uNB5GZzJ7cdySLxDpmm5WWnIAsZVLsV/+0bYULzQO8aqkNOv5yznCnNlVHb4kzuSmm9kH6C1JGO34rgYkHlcR8Le1nho3PZnJxErKLjFXLXmC6z56tLjwIi5vjd6kAUnvIU86JK3cOD1VcwKTyA7jA6ikfCo939W0O5KsYCF6iL1NqZekTu2VERgRq5vxJJl6eN6tenT93GoDVnaJyxLlkjabZvoi+0okZY3k7gcY37R6ogtDah/7KWCi1lC1BtAER8f/Gk1WRoaBS2r3GQ81PgQVwvNu1VoNpT5p0yCejG+HbLjgl2XJ7BiuO462mZ3/dJwmShAHL3d4+qBFEkfu/JwgseMfpHBFxVJhpc46uZ+gpnpLZH5zpWCRqHvdDgpE3TeNt8LS6XNKQYXZXN9QU1Lwn4JL/Md2KWQ7dTccB+eyFzsm2sRsrkJazYooOCNF+0/P2EwIfqhQfegcTAWYAnW42lc978ujGCUneH/MEXXNpvCQArJJdat8o4ZYKb9iVRRtcaEDEK46D8wU+rBdt7hCmcWFCNfwdOXn6Y5Mjhf2bRHpIjcBSPQ9rnNCYmAnEr3qkDjxLbCx6AqTjRrhQpQF08kTNhpt3zpSQ87ByiyngRajDSw98n6t2N+NVzUOHVz2PX08EkChgj42bL90lbX8txRZ+cqd3CTvq9iof6wnvKdf1iAYtha++AEfW9lQUrrBocouqpjHBuxmRBzEihycA8XsowHXIVUHUUGLtaV1A7QOt+Z4XKo5oMX2KLguvvQRa9RqWzZ/n6NGEdQLdm0UQ8twqU+0PRhyKwxnyzrdDzH8HWz2OffqgqQKFC499cU+CiXFlQesvXzzyhiZ7M7pMKbSoLBnuiWkFUKITfnTKdxJnrDp7S+H4q6EPIaeU0mhH5lLVm5
 3eUlXwYZ
 jIbCtjg6xHJX4BusngKD9bsagZChDJhs5SmF2SwqSzTdyJVS/973VQLdm5pFt/FaDcYIz419U92KCFBzJM5+Q0NRMCoNQ2dHxNHpMN3l0Uy3772wSz1iWwSO2cFwwdFoRXTNvbgTD4fuwNqjlD4YsURh+GnHh/ZAOu40LVl2JBbzMaqbGobMPjrCox6HH3KcI7cYS9AXn0AANej33LLvvFk6YueMuerc9zBRJj/NPOBmcL6r3Lnk33s36eruirLAg8muuZO+3D5Hrxr9Ipl03+lV9vWszkph2eELuyZS7D3EUbxd9OG7mRBFzudrn2IN/zyE57ToMwSu4bxAKQNgQfyULNlHjaG4x9ZnyV+tslVVE2U23Szaox7msOq3OC5cXGpRr4PCtRlKmeKLXejrIKQvs58IGN2LY0wvrin1r1Ika99F0Y1gvEyQ3S8AVK9glsAoYm2TVJt/G5P7MwC8TJsEpLInbaIeu9X8AmnTKB6yHvU8lliWmFYQs/Njne+Peeo7dRe++35o/Nhe7Ck4hw1tWQjhpXH9tPuEXaYC9xLUwnhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 03:58:53PM -0700, T.J. Mercier wrote:
> After commit fd55edff8a0a ("dma-buf: heaps: system: Turn the heap into a
> module") the system dma-buf heaps can be built as a module. The
> system_cc_shared heap uses set_memory_encrypted and set_memory_decrypted
> but those functions are not exported on powerpc. This can result in a
> build error like:

I'd much rather revert the above commit.  Yes, x86 has exported these
since 2017, but that's a really bad idea, and we should fix it instead
of spreading the export.

Setting memory decrypted is a dangerous operations and should only
be available to core code.  We should have various allocators for
decrypted code, but not export the functionality to random code.


