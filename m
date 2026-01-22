Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F710C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C63A6B0169; Thu, 22 Jan 2026 07:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849E66B016A; Thu, 22 Jan 2026 07:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748E06B016B; Thu, 22 Jan 2026 07:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6181E6B0169
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:05:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F20521AD2B7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:05:21 +0000 (UTC)
X-FDA: 84359469642.30.FB5EE95
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4805214000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:05:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QTR5bMdK
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769083520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXWW54h4kaUiEYhDhi0tKdenERduKH4QQYXp8ttP4zc=;
	b=jdS0WiNRpKOdHr6Jv0YwF2YiwKry6jurqVH1/eYedifhEaDJiV94GZxc1e8sMFTvAfewjh
	yujVzYh/4ahuSv3ysbGF1Yj/JO3DOqGciec6Apr6aA1JI7Wkj7Yj9xeGHzOxku9S5rzBbQ
	G+y+dBX9FqiS7JF21IVAXR7ej605jaw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QTR5bMdK;
	spf=none (imf09.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769083520; a=rsa-sha256;
	cv=none;
	b=rI87VyAPnnRz+Xo9vWWj228V4/TeqFFOupKRPWW1kRCUhDjMRtXonNFStHnFqT2iR4irQQ
	lFDckHm4XSQ92dfQoJSF3gplUz3Itbxv0DL5Y6kitFKCkLx7mJgxLRHBxe+8Ahrq4mND2H
	oroRDRHk/yaRxR/rdjP54XsnU+Ilx0o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SXWW54h4kaUiEYhDhi0tKdenERduKH4QQYXp8ttP4zc=; b=QTR5bMdKKQIdvaXl1F+VY653N5
	deoCWEBrVYM5kYB1ioI4txfqaRfnP3/o5wmJR2oU2T/VoDoj7W90huPy6y6/sdm2NEY9ITRF43+6H
	BeeHRXsBFRICDbM7413O2Nk4PFNOlU+PltnqN1zn7BdK8bsjLCiIwBZDP5UgtdcLdZ9gyGFXPsdNM
	LFlO8lwU6Bu22ZUYi65aKqLaxdQ0jLgryx5uGf6Gz7fQD/yINQjoqNHFB1SwVURunmeLGEAu0DPWT
	2JpJ9B9zf/hnKHZwWQ+jxU6KqB48S7sq2G8Edw4/CNsvZD+pF/go4hXkmlLs+/PP92bSZG0F5tsW+
	sHvLYNBQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vitQq-00D0EE-OM; Thu, 22 Jan 2026 12:05:01 +0000
Date: Thu, 22 Jan 2026 04:04:55 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, riel@surriel.com, 
	kernel-team@meta.com, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXILzST3NxyYXW1m@gmail.com>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
 <aXICriRKbYB5f3li@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXICriRKbYB5f3li@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: ypc4ewps6pqntat1345sxy54k455oaf1
X-Rspamd-Queue-Id: 4805214000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769083520-963796
X-HE-Meta: U2FsdGVkX19amXECH9iAozsCIiYJNdBfllsknisHeohTEqzs0i2KahIkAe+ZYzmojPCr9bO/XdIWTLHYQLNJ/4tDFiacfYYP5ELX4bXdlR1uR+w7iQbnTN1jLevdAldUfFX8hASJxcMRMNPv7zXNCqABK8Bvbxbq8sNg+mk4HxKMUsHQFaZekuBdABHvULQBmr/Bs00GqbSoSglaiufU/oVVavSNeaGrblwEvPKOBtAhmxKRF6u585HSXMYw3CYa8E+PsXM8jnnpYLI2qVDjSU2/NZHRRBsjTphudFg8N7QEHCZ4GF/RQwuFW12ZeLyyAcXBZd6/CyWlGONqOqWOrNm/ZDo2ERAdyrI6TvPSuvwEOf4GK++hUvckKRT7pFxuzzM8mP0n5mYaK9kWCzuRIbGce6U1OQaxZAPeBbHa4y5Pw3QwT6r9cA4Ru8HuWxRNJDXiT9RN0DbVP21dN59iFXDoq4L2/vPAA/Mlzy6QnyYvDFK/35zzHSMaYx1YQbRReaNvBac8ez23Bx2fekBBVUHTL+CCGyk+L8vXhIFupUhZ6XfXWNXk73HM5AFA/OWe6VYfiWrIc7Ji9+D8CfdFPYEcKMWPuPS6C3BJPU0ThJDREweVkSvVCkQCC3ZgTVF1UaeqNqpluR6aFFNOt8p6Mu+vkB9ML/iz1X42T3hIaOvLfpaPXVv9Jk+dCZdfMxYIpat12/FS2E/W1pp+S/RuViRzhFUhk8pvlazqA+73YSDdCu2OIj97jj6k2pVAs0J6W1wglq6nUQSYUQzoIAmEFD5AzMwxK1irP4+ZlTNZGZ93uuVeEJT2on9KKFxUvqqIrHM/EO/obVbmcyGogrUCb23TyxCQ1FU7TmkbDrCnwJ/8oOaToLHFlGGSRbblag/vlugkqGquTIpn/NVCYATLqm3b3rXRDtIUXPBSwtNPee1mbUfV7gCcS2BwZ3HkTaP/V4RxgiOitIan2MIFQle
 zBIIYQo5
 oA/J/fKqaWzwjPG/DlKTRs/nItRn5TxEIzLTbEj5UkSfiPVKu/bWwgUgN9+Gv2sFHPTRNYAaz3CfmbotQM3+kR9va2KTXmoE+RTqI/Mo9hnMSyTI7S1vbZvZVMAxNZa2bOKa164h5L776VOUvO5spkhUud1n1gAdcoBM/da6aoDiE7cc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike,

On Thu, Jan 22, 2026 at 12:57:50PM +0200, Mike Rapoport wrote:
> > +/**
> > + * DOC: Kexec Metadata ABI
> > + *
> 
> It would be nice to link it from Documentation/ as well ;-)

Ack! I am planning something as:

	commit 90e098ca0d611b44594f08e50ba1cff3c932dd2b
	Author: Breno Leitao <leitao@debian.org>
	Date:   Thu Jan 22 03:47:23 2026 -0800

	kho: document kexec-metadata tracking feature
	
	Add documentation for the kexec-metadata feature that tracks the
	previous kernel version and kexec boot count across kexec reboots.
	This helps diagnose bugs that only reproduce when kexecing from
	specific kernel versions.
	
	Suggested-by: Mike Rapoport <rppt@kernel.org>
	Signed-off-by: Breno Leitao <leitao@debian.org>

	diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
	index 6dc18ed4b8861..1faf2c3ba4620 100644
	--- a/Documentation/admin-guide/mm/kho.rst
	+++ b/Documentation/admin-guide/mm/kho.rst
	@@ -113,3 +113,42 @@ stabilized.
	``/sys/kernel/debug/kho/in/sub_fdts/``
	Similar to ``kho/out/sub_fdts/``, but contains sub FDT blobs
	of KHO producers passed from the old kernel.
	+
	+Kexec Metadata
	+==============
	+
	+KHO automatically tracks metadata about the kexec chain, passing information
	+about the previous kernel to the next kernel. This feature helps diagnose
	+bugs that only reproduce when kexecing from specific kernel versions.
	+
	+On each KHO kexec, the kernel logs the previous kernel's version and the
	+number of kexec reboots since the last cold boot::
	+
	+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
	+
	+The metadata includes:
	+
	+``previous_release``
	+    The kernel version string (from ``uname -r``) of the kernel that
	+    initiated the kexec.
	+
	+``kexec_count``
	+    The number of kexec boots since the last cold boot. On cold boot,
	+    this counter starts at 0 and increments with each kexec. This helps
	+    identify issues that only manifest after multiple consecutive kexec
	+    reboots.
	+
	+Use Cases
	+---------
	+
	+This metadata is particularly useful for debugging kexec transition bugs,
	+where a buggy kernel kexecs into a new kernel and the bug manifests only
	+in the second kernel. Examples of such bugs include:
	+
	+- Memory corruption from the previous kernel affecting the new kernel
	+- Incorrect hardware state left by the previous kernel
	+- Firmware/ACPI state issues that only appear in kexec scenarios
	+
	+At scale, correlating crashes to the previous kernel version enables
	+faster root cause analysis when issues only occur in specific kernel
	+transition scenarios.


> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> 
> ...
> 
> >  static __init int kho_init(void)
> >  {
> >  	const void *fdt = kho_get_fdt();
> > @@ -1357,6 +1413,15 @@ static __init int kho_init(void)
> >  	if (err)
> >  		goto err_free_fdt;
> >  
> > +	if (fdt)
> > +		kho_process_kexec_metadata();
> 
> Can't we move it into the existing if (fdt) below?

Unfortunately, that won't work due to a data dependency between the two
functions.

kho_process_kexec_metadata() reads from the FDT subtree and populates kho_in:

Basically:

	kho_in.kexec_count = metadata->kexec_count;

While kho_populate_kexec_metadata() increments metadata->kexec_count:

          /* kho_in.kexec_count is set to 0 on cold boot */
          metadata->kexec_count = kho_in.kexec_count + 1;

If kho_process_kexec_metadata() is moved after kho_populate_kexec_metadata(),
the count would always increment from 0 to 1, ignoring whatever was passed in
the FDT.

Restructuring to call kho_in_debugfs_init() earlier also doesn't work:


	if (fdt) {
		kho_in_debugfs_init(&kho_in.dbg, fdt);
		kho_process_kexec_metadata();
		return 0;
	}

	/* Populate kexec metadata for the possible next kexec */
	err = kho_populate_kexec_metadata();
	if (err)
                  pr_warn("failed to initialize kexec-metadata subtree: %d\n",
                          err);

This would return early without populating the kexec metadata for the next
kexec, breaking the chain on KHO boots.

Please let me know if I am missing any other option.

> > +
> > +	/* Populate kexec metadata for the possible next kexec */
> > +	err = kho_populate_kexec_metadata();
> > +	if (err)
> > +		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
> > +			err);
> 
> Please follow if (err) goto err_ pattern.
> 
> kho_populate_kexec_metadata() failure essentially means that we failed to
> allocate memory. This shouldn't happen that early in boot, but if it did,
> then something is utterly wrong.

Ack!

Thanks for the review,
--breno

