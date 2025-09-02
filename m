Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F502CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BAEB8E000F; Tue,  2 Sep 2025 06:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4922E8E0001; Tue,  2 Sep 2025 06:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF518E000F; Tue,  2 Sep 2025 06:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9088E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:57:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7BCD11A5A9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:57:27 +0000 (UTC)
X-FDA: 83844008934.03.C2B9107
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 271FA1C0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:57:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U19bxKED;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756810646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=za3j7Nsx9FbfsqR+xTgyWznJneadrQhaJdiMt1cLevA=;
	b=3+Z3ly8KOk5dgjPimJMw6HJDUi3I9kRNGnBy6n5/pkPmgJNiIpsd3mBJAsopdLnW83K24f
	svmQU7GAjTCR+mAJJliZ1AbswYS3+QLVX6DQ9UkdcZ7tmQMtTWY3m/3yB50jTtokk4llOa
	RWMgoHOmWC52qTBbCrM9PABRG/W3Fqw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U19bxKED;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756810646; a=rsa-sha256;
	cv=none;
	b=lsZ6IF71uRYVKNYzlTF6akjomvER5IWV8xw91rF7p8kSSe06tdKemgIqekAaSZ5rD1H0uF
	R9H1aNtDB5XhSU0Io0l9HajYmFRtpKJTVQLXrQ3+9IHFy4+K2KLalRGr/4ILtEACL6YZEI
	9SQCOhxVr3oCKet8js4CIC5Hy7uPcMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B992E44A76;
	Tue,  2 Sep 2025 10:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15A5C4CEF5;
	Tue,  2 Sep 2025 10:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756810644;
	bh=095NuIZ7Nx8c0fwOC2OSs+cDvccgtMlrYoeSjfTOcqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U19bxKEDTS2pl8YXrvOUOiOOiHTIAO1t3vzP+lNrLWXbKtcH/rW8K58r9I/DFwXZQ
	 KKANo+dhBTGZ2QEpTNoRVugjRz+PXRneWl73Z3M1PjupoeBDcSnESAA8BCcBbtFgzB
	 TKl/IuFL3r97oTI7JTDGFJ/O8jcR3yJwYnH6xItZGA/vWC1klv7Ta7e2nnqhbLiwfF
	 GBKMznnSxXtz+S2eQ7AU3FdpMlKDkJEpyW9goog22j31cMfjT/AZ+pH9r3o2mfXSjn
	 OdeEwbYi0gFpNcp5vQcsFv/d3ZNcbNGSlXR1TFL97sBKoF+PiO77gUSwI69FQsHPnY
	 HcioZpzP6CKng==
Date: Tue, 2 Sep 2025 12:57:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com, 
	broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au, 
	nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 04/12] fs: constify mapping related test functions for
 improved const-correctness
Message-ID: <20250902-einblick-nichtig-c4fe7fa5ae6f@brauner>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-5-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901205021.3573313-5-max.kellermann@ionos.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 271FA1C0006
X-Stat-Signature: fdottx7qy4sgfm834c4ww4x98tai9jko
X-Rspam-User: 
X-HE-Tag: 1756810645-272564
X-HE-Meta: U2FsdGVkX18IqMLpTFvqgZfvG8oA8DY5UPl2rL8lKrMFMlMuyhw2IYyeZXyKURNe5qSYQHPMKFtnWkOm6thq5tZSPm9/X5T5BSRl+iGKH5YMJOZuJgODCeyxW+czuuKMNeX4YoY5XGl3nVoqo7ErSZToBMbYfnGMG2658Y5jmnY/soZwfGrxMZ/svnyoY0KWxYHSqGOd9rnIEIXCJ295Z+D0SaNpL5E6+fS8xbmC7OnO3dcbQBdAe4Ky98TlU0CwGJuPMyTi1aoPBbumwBRJSMJVlE0FBjV8pIqnjz/MFL8InV0TxPMFGq/M4nnCfqbkJE8xextobHDPgvJKKL0E57zCZC82GkItnodukcwW2xg3lOLUXzpwy1jHwthYfIPt3RJxyXi2XLXQW/fBiYKuPHPSOtyrNWPkCCpNzoJzvKWz3m9d0bH25DR6qIPsv3Tf5JaB0gu463aUcJ72y17Nlqg+vk/EJhIHVrg/+4mu2Y46ZNVjcYxPuPImUptZ4UueD7xuEJGeZYPoGE8PNFan+ADbODnyppgw4m0Yc1gu5vi+F+5UgPMJHeQux4m3e7RFHWDJxSrh6onVcecJc9FGEG+l/hrxi4k9VAhEN9JSe57JlFlWrtshHJWU8cX/c+abBK4plIyujiSfHEWHL79HnMySbvxArZcR+dyAnJVvBGh7p38b2R+tBmcrO0U7wCgJFOMv9DAEroF5lUUlLcVLIL63D140N+qdS8QipT80LYCRFu0ofdtA8ziLdJtNSmWiDiBoZ+nge5Lb9tjjzzP1T446oS5631cEbVNaPHkScUWnzuSjNjVifFbcdEODuOgLSXE/Uyst03qHkxqgPUftqt6Gq75nfBz6JyeBHekgbWA0dJXiql4aVRAqkx634BC0O++2mKzetR8HV8sxN0ed8yTNhgRFhtrSs9sLIWAENRa8mju+LDbEaKxSefMip2W1Fr1HMxjkY1Uza04dcA4
 FNee6FmC
 0Bpv1p+bRgub+DLjF4Yw3tSGF0qz5fs0dG38ggZ6HwH+meHjUqqarJhKJpnIsk3j9xKXq6gs0UvY+CL8hHh3mhkAK4Ok6l/GjzyYtvPTdTlIdBLrtE2nqLJTyCi3P+Wy0ISTnYEFtos1BFlyCs9omH37VRwpxQj6PG0myWlXvmIQcU3gGM3EvK92Duomn/dpBrl6MZrDKYDRpECpGlyQysZ8PDyavZGZ6sDTSfdCpLK9WR4TWrptTX/KYRZRFTUzvOJHTnKuxDIjJgyUvWgfPQCd+VeCK1jzoPNV969o//8hT8+FiU3vu14ypd9nkY5hBIvwBB8IUhUHlVC4ig8Ctwax3UL9SGs1Occb/lW2AuimXrI4gJ4czIrA+ueOHXSpBpR8jpBlTRWdUq0wZfJcv2DWRjh5cg/O2/tQEWqVpAwXq13pA4MDUYCDklvUyofZRObuOzo89SbJ0NWIrjxFgCKTcp0IC3AufZIk0g3z16pxV6jsZyr4q/2sJ+6Mix2lPD96kzjOSEvQJ8EY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 10:50:13PM +0200, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

