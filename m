Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1842606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bbsz9qDk
Received: by kanga.kvack.org (Postfix)
	id B9AF76B0835; Tue, 27 Oct 2026 12:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B230D6B0837; Tue, 27 Oct 2026 12:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12E96B0838; Tue, 27 Oct 2026 12:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 759516B0835
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:29:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDC721203AD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:29:36 +0000 (UTC)
X-FDA: 85368941952.09.EAA3D1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C2B2C0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:29:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bbsz9qDk;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAcnFFHoGCaLIkdfu6vQlgxivqnlgRGe6B2VS1ojrEM=;
	b=BHwh788zCPASXVwiqK6LVLOBjgKnu+DzNkwn4xMxd2qUJ4BE/Lv3GmAVQmengmCThZmvCe
	0jg7OGa8aUl/JhTIyjmwE/tf9f2ICfdNG8Nkd/4iuN1mcomRHXCBlE8+z8ea6v5duBXjA/
	2m00TVHMkBSCl12+BDhBtkL1gXQQVaw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bbsz9qDk;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118575;
	b=QjjoPUaf5KZwC4SG1sgF9NOTq1ohgeqJL8ps5hP2/K6ajPYn28c6t5ZXMEJEsJOyLInf9f
	5bCTJQTNcWPYVhbbXwl4FS2SPP8yHS2HjgNd8cHoGKHWTslguZz/OF3+sPWmCh9k9fFVsH
	Hmt9hNAwLcJKui6zMpcV1OP/oNQE9W8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E6824183F;
	Tue, 27 Oct 2026 16:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F061F01828;
	Tue, 27 Oct 2026 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793118573;
	bh=kAcnFFHoGCaLIkdfu6vQlgxivqnlgRGe6B2VS1ojrEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bbsz9qDkyDs8H77dSEWFVVoSrMeEk+WXm5r3OPWiNyeYoBpxmsOCn5CmGtRqVetHo
	 mcFkRLPNplY4m3ig1H1ERqm+PaSGY5Qy91L8YocM14s/zdxHBU39CJJs+LR0NjqRUy
	 HYaZ+qVnsrkUB90AOxXitaTHRIDzbW2nZQKAt2axcvSGr90/Ecy4aiZxxfFFZPczPN
	 a6bkSOpR33GdMYXlejOZDAznosukKn1HJsw8fzq1fezE3Gnm3ptrKyXX0qKJZIsYvz
	 +AJX6Eljxg3TrZYEEkkyIT2+mZGLlRxnvv9SjcB2Q0e4+EvEqvROnMfyR4IutR6Tvb
	 hVXHbkO+pwc3A==
Date: Tue, 27 Oct 2026 16:29:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <baohua@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	surenb@google.com, david@kernel.org, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org, zhaonanzhe@xiaomi.com, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	loongarch@lists.linux.dev, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <auDRAEofBdqZy36y@gremlin>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
 <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin>
 <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
 <ar7MsOb6IJLt4eLo@casper.infradead.org>
 <ar-o1TrOMGrrcxLX@gremlin>
 <ataDTEZIKOYtwhUF@casper.infradead.org>
 <auDGPs8jzC-90-_y@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDGPs8jzC-90-_y@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C2B2C0009
X-Stat-Signature: 69foj8qarzirh4qdepiriopifdd45kye
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793118575-105643
X-HE-Meta: U2FsdGVkX1/SvkbnmBejWLrYQvKTsLmOgkulR2cpQ6MCJihP2J6UPqtStz5vzsFkhAkiqVV3IReIv3HawqC7+XuBB+DoKco4yE08TZz+m1iNWFUQKGMNBAMcFTiA+PJgc39oaSkfrPXWNaaj28wNs3TwZj8El9RAz2Tq922s2sa/C8wlV8GskDkHQDKJ+TwqQnMjez45pNzqF7hZm2qVLbnyZIX17jsrtOIMdFCaICyfn1myIam2zk33D7mLCc7xR0P8gCSu32qawUlyoE3H2cIFSDwGURFD2DXb8Bqpgq/pTsKXNPwnTcnJNN+/QU9InpegrzNnCbyF4w+mcpKPb8YEUaesvDU+r4V3nyCV7SMuY47cdKCTStmKafMLzeSSOn8e2rzTrKcPI78fGkfM41Llhzgp9GkiLqZgkqgx0t0B2/r6S+q6BMhjN0R4BhuTayWZCbezVmR1/UkCIW3Wle8PwglycnYroIVhxyW6eg+fvfiFd/xe3clMxAytN/pGn+aT6P6ukUYivL3YpfKr/oHv4kX6opeDF3BEskCxnWuFAJUrFTKQGAd2g95doHm8Q1uj19lTyI5iq3bNTZTk7eYDzRlHJ7uFRPTfntaRe3Hvw9CPxQ4ROR52w856c3Dt/44WOlLXlq0sKGYpd8br9Yd2DGz1CEdSGobbsat7yooXg1JUZxlFP8ba9kuEfXhQcFc26ye+tBThq5cAhQ1/MDgZS1aCV8CBCN4/AcE7Dhal5ERRAJPoQfjv5ve21Cy6xvqQ06V0pUjBNHrlDcHkRhLeVfOkAO2CY6d3cguJvCmLXoGzZzggStZoJsFy1IrpcXq/ddpdtVNliNn95zwBdL5KfNJdPDEry8Izq4zV1RZFuciLP9XB0eF8nQd5cv4Evi0klGy0FqXDApWi2RJSVrWFo1Aaub6O3mofByVSRwVqI7Fts3QiSdW75srYaCu9YwFNg9WjkD71/wVGV8L
 uKiIWPR2
 zC6VSlgCuVnQ2L01NSILW0AAUBNSAMs73H0+1lstqberdl1K4V2GATBfCp+Br+LyPVz9OetonwjdoCsSPmO8BkEWyw1txBOseMXHDR+eRYSkZb84fQv9d/jgWNZLd4xLVwJwF65uCL9sdDARPH0aEQ+kjzovvnCSm/HJZm9pK4pSFDzuFrLaWoR3c0cAwr6TBsi1JKFccaYaLWcJDnmMEtBKltsj3dwFcPyHXSglNITPGWniN/fymaJ3fEaWViHwVqEer
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 04:26:39PM +0000, Lorenzo Stoakes (ARM) wrote:
>
> Thread A (Parent)          | Thread B (Parent)       | Thread C (Parent)
> ---------------------------|-------------------------|----------------------
> < Fork >                   |                         | < has TLB entry >
> copy_present_ptes()        | < no TLB entry >        |
>   wrprotect parent page X  |                         |
>   -> 2 mappings, refs      | *ptr = x                |
>                            | < Page fault >          |
>                            | do_wp_page()            |
>                            |   < shared, so CoW >    |
>                            |   wp_page_copy()        |
>                            |     copy X -> new pg N  |
>                            |                         | *ptr = x;
>                            |                         | [ OOPS! stale TLB,
>                            |                         |   lands in X not N ]
>                            |     ptep_clear_flush()  |
>                            |       < TLB flush >     |
>                            |     parent PTE -> N     |
>                            |     [ X now child-only ]|
>                            |                         | ASSERT(*ptr == x);
> flush_tlb_mm(oldmm)        |                         | // fails! N lacks x
>   < far too late >         |                         |
>

Sigh, I drew this entirely manually, then had the LLM overlords 'correct' it,
but it also made it less clear :).

Thread C ends up writing to what-becomes-the-child-page X, whereas the parent
ends up with page N after CoW.

So a thread in the parent writes to a page of ordinary memory and then it
disappears under them, and the child ends up with corruption in their page.

--
Cheers, Lorenzo

