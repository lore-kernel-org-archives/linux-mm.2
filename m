Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57ACE606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=WH+0RidR
Received: by kanga.kvack.org (Postfix)
	id 771636B05B0; Wed, 28 Oct 2026 13:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749276B05B1; Wed, 28 Oct 2026 13:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FB26B05B2; Wed, 28 Oct 2026 13:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8656B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:44:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 335F71401B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:44:32 +0000 (UTC)
X-FDA: 85372759584.03.B87E8C4
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D385A0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:44:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WH+0RidR;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793209470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
	b=y1CvTGCmRCxrqzlzNUXrpy14r/qTf4JUo2zbsZ49S6kDAEs3yKoYiTrk6f4R69bItksDt3
	2Dlz/hZ9Msqxw6kbqc5f7WpOBFMqwccQJbU0fcYQiaecwWd7n6FLnxKDxAjhXjL9FBwVgj
	j+0C2xESh+wCfA5Ixn6NJPOQ/N8xp0M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WH+0RidR;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793209470;
	b=QZJTUYpRu5i5bNf3xSizF6i00VuipUv0KurOb6VY1JKypCcOBl7hqhCqxNVEK7/Q+2Sk1A
	Q4n12LkivACVcf3+UXm2UddruehsmqarP4xVYBA8jIZorsESoxrIJd0g+efSgCXdNR3DsF
	TATFqlT1OrKW2Y33Q3obdunqG6hqs/E=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7cc81984fceso396499137.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793209469; x=1793814269; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
        b=WH+0RidRNrTEFJ9c6ftVSm6UtUV2YdGF1EE+UHrI9Y6RRJDDOBybiNWAhBRzw3KaVg
         T1rNjGjh4Y9MfZvOrNPKEpJqr6wSUwqpWt0r5ycRHY7sGYXAxsuCRjcdmRdxf8FIFZnp
         GUu4cm8u7ENfHYZeD/1CI9XN2/cCqG71SXbFCiQUmpCU/VqXAaw03YaTsA1HPQMULo70
         e1gy3/Y7No3L6fEB+lm9FCR4tP83mzqsXid6hhuYDYC10qnCmL7VBcqB8Bwo1i+1wkG8
         UvBtn1OmX5xQEE8ZOAXw2ZcVARLunhdKXZCPTwwwLdJXFbgcDNFK98ArE5YUFDg+H1t4
         EwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209469; x=1793814269;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s56cw49H74YOeay3n+CLmJxr96H3PjfrjsaPdtr6E80=;
        b=klGANlMFDleInZCQUY5ZA/eANwmuk7Uf8/KwXI8ivRBPPXGKaknp7whZDKT41UuqbA
         pSLe2QctzKWCnn12/1trXq+dh6EF050jv83ZBTQ8EbDGgo89+Tz00aFDepEXWqXdmhzS
         NrY7FIriyd3AsMXXWvAGdfQxd2JASNoGYs9bH89n/32zdZHM0k916oJ22bVIhjKf81sq
         +Suy6MKGZ35hyUgp574Se/9PBddO2K+ftxhM9DzAh8yCS4zoxRSuFe86RHgjljqLCBPX
         HK5tLdFdGoph7Vp8qGpZLN3XzyKU3Av4elZ6W1oaZWrHDnNieN9vuDdQS49J8XWHXPza
         RdXw==
X-Forwarded-Encrypted: i=1; AKwUvBxXPjptMoYHMl5aH3cCw+GDW4qS4pLjXRM6pE9MhKcLTII30mUjhAkzsk9ErZX5oN1oUttlsKGWHQ==@kvack.org
X-Gm-Message-State: AFq9FYJwQGplMHcIseNV2bzm1NuLL3UDYSHx8etdARN38nXFwehxKoOZ
	ArQP8z8gpNTvN9aVBVv9REvVpISgMJIMlIc8IdnTpoB2XOAh9dl56p7ThD8H7httDT0=
X-Gm-Gg: AYBFou2WRALWgRKWnOq6ev+anOjyGe2Ic2T4WP2eeYBNkvMK1uM3zOAqsklczS6r+UT
	hSJlSJCg7e9++mJayxylaZWLZEsW/TBkxwWkqosMh+PwUZ05aB8mQmWIYUSeSGe6gFkJvx3/xMp
	BHzV6N+48sEUkVcUsjKpNLsNPb92DOwD78KeuDw13fFr+1gpuwIZFUEaM88OnIIUTskndfaMW72
	punuMTKieY084JoRGU2H3PP0NBdkeBu6CHM1no43XO+5kM+QYq8Ipw5RqFpfj4trrybIDOjRf25
	ruDyJoatmqVzvnAS3q5Q/zRIMXZPggaDOOaP0BnL6tW8o9tbfFcQHz5Gox5JVvKvnZfJtNAHTwa
	1HvGcoLZi7v6KQgjepkJuQFxcWvvQ72nsHhrlBviaLB0LhkEXKdthkTV5sebtRYbjoyGed0dGDg
	KsyWaNUwKbiJuJLyxHt2c/PkU5bAIr3z7OYR58Xzj34nl8RTii0T2P9YKrBJIoCHFwT73zdTM7G
	5IrMGAuNNXHMHjw/ytULEig9OWdX2+EE6am1cl0d2MnLNA8R5nyWfFUrysOJCey9bL5lvL4aoJB
	yW25tUVxhoSmaDnh6SsNnFvSDqre98ScHTbsC/5mwUb355tXmpzAIW/k5sIAFMeDgubUkHMuVwm
	X4+0s+QHwsRt18bcnpqengpvWhPRPDFx6
X-Received: by 2002:a05:6102:3e8d:b0:7a5:7282:1994 with SMTP id ada2fe7eead31-7d03a50a85cmr1269510137.7.1793209468986;
        Wed, 28 Oct 2026 10:44:28 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99125931983sm6616412241.2.2026.10.28.10.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:44:28 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:44:27 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, 
	seanjc@google.com, will@kernel.org, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auIvjVmWnsVPN_9g@google.com>
References: <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <2vxz8q3hoicx.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxz8q3hoicx.fsf@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D385A0007
X-Stat-Signature: oyho4i4mio9brhe96ss4hpstfaujcerz
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793209470-786149
X-HE-Meta: U2FsdGVkX1949t6ulmmabSaN9qA84ENxVW4vSTGNwVEaZm9j+gFYTW2WBBi9wi/pHYAXBOe3YwtwPcGohfW1UNAAusnpJxcmzW+UrWt6iuZz2OUe+zC3tvSzprlZBEROHOkAwcK0EXalpX1eeUsY4CxXM+LnkkXdDfdFSEgiHB1WqiTFzvPtirJWHeFIxjLoHRwaPiezd1tOk4IYtAap+LurfiXiZpBL/AZjlf4nTHAQ6HvEClmL6jmnvrITXTRQY4NbGs6SpWq62451VquxXU+V6wAxsggLnL5hwk2vyOkd9awBFIZ2/P+75JZDyFdQz6ifKjh5wlV9omuAkg7oGKxI2gJVuPceaI5Dfv/ZXsy9PzxgQpvkdejw178tTs2g5b7q96FcI6RP3pGKbVNIE68zXQBW+q6vwqYtwbNQQn1jbMjg+rvxRseopjXMGsL4zDOVkhs+hMaLpa4K2VgLZrydfNjr5U0yrz6Om+D1qlh9ds7sGOB25PTEB5N9SKOyPnzkuSakdYYfO395Eoi7/rF08tcaiXRndUIVhJt4dMv6mjgbCowj+MOjsIr3LoX418xvkvn7dHUC03xa4fKukwBYsB0byjEiPoQ5CdVagQ3s2Boi514KVTwHzUaL1+YH/8uibifqyYsQX3samOIbn/twcAcwwQFXHz7m5TgWbdkJfT2eN7IcptH6bpfLtGxzbm7ZyR9CyF6n1xST1yjpJ0bEFZ3+jEsAb+3i4Z1YAYOKSu50hbhB1c4pt7L+xIvOsrjxLmtsYvjUN3ML3oZSVduKU3OhMxk/vmyHopSww5PYNFymBH2VCvU8XoIOPeM0onXC8TH4v3jnAEQpPyT+80LklU/IcFq13lxazXsQnxnqyeZY3RTwCePGmCv8mi2k90MZbkZhyZd+CVlWs/bLXQ1ivHSSI52Rx+nQZLfa2z4Igp7f8VsekX4wmyKOb/tXTC5ybMDhPMaf8JT+HBp
 Sc8eVbQ/
 qlytXgCuAodkxvqcyBUrkVFzw3RVPDIE9hI3NwgXa8ecSkCJ11em5OLeLlwAha8mCoT3iuT1inFW4OiVI/DrYBlEjPIB2vtFwKDpcx3BiQjbQt8RGQRrCCOYy5SmcGMnDfOX9wc4ittpg/xx1MSa2iBSndQKMvszCn9v4kFuU9vN83HHmgNMrcc/GVx/PcWOVe7WNDx+ZAybSMipnzDOFiLtWglz+oOWE/s6hmRd1XWxblqs7SEqLMZDlxJuhylCaH3JqLTwid/4aWCXUHY7lxXmYmAYkKY8dakrfsnKAREH6tW65pcQRLpokQRNlp0KSrWRYh94v/YCL2HSNVb5yci75VzjClWr67QoveHAzXBzCZ1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-28 18:17, Pratyush Yadav wrote:
> On Mon, Oct 26 2026, David Matlack wrote:
> 
> > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> >> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:
> >
> [...]
> >> The reason I care about keeping the header compact is that we are
> >> defining a foundational kernel ABI and want to use this header across
> >> almost every serialized data structure so we can evolve them later
> >> without breaking compatibility. While some top-level structs are on
> >> sparse folios today, other serialized structs are tightly packed, and
> >> we are looking to add KHO slab support in the future where tightly
> >> packed allocations will be common.
> >
> > My intuition is we will have a small number of headers per preserved
> > file and per preserved FLB. One for the top-level struct and then
> > optionally a few more for sub-structs like arch-specific data. That is
> > why I am less worried 8 bytes per header, even if we fix the folio
> > problem.
> >
> > Maybe where our visions differ is when there are collections of
> > serialized structs, like KHO blocks. For collections I don't think the
> > elements will each have their own headers. Otherwise the elements could
> > be different sizes.
> 
> kho_block today doesn't store entry_size in the serialized payload. It
> relies on its caller to do so. With extensible structures, this can get
> messy. Sure, the owner of the kho_block_set can track the size somewhere
> in its payload, but perhaps we should store the size in
> kho_block_header_ser to begin with?

I agree, and we will discuss versioned vs. owned serialized data 
structures separately. With this series, we establish a common 
framework: size/feature flags and accessors, and we update most of our 
serialized structs to include them. All "shared" structs (e.g., KHO, 
FLB, radix-tree, block_sets, etc.) should have their own versioning.

kho_block_header_ser should have this header. 

Pasha

> 
> Anyway, not a problem this series needs to solve, but something we
> should eventually do.
> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

