Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67DEE784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 09:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D166B0005; Sun, 28 Dec 2025 04:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B176B0089; Sun, 28 Dec 2025 04:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909D06B008A; Sun, 28 Dec 2025 04:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFFD6B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 04:54:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CE7A1420FE
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 09:54:28 +0000 (UTC)
X-FDA: 84268419816.25.C41CB77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77EB640002
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 09:54:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S2ph8a/f";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766915665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1JZaRUR7Zyb3+2+LPH4+g8vgPM6twkfCu2GKUIxxtU=;
	b=WlKKoekA4sEZXdoQugX033bZfz/bkYssNj2YxqqncjQuT0RSdp7ed967Gp1SbMbLj/8aYg
	fSrNKcE/qJzDN78iTnVEq3p97my5okrWIgFI7zeOOBKYXOycv2OL7niMomYJbXPaeHkSaT
	JVCNYDOiTaRtbz9G9iIkeYROIimaibs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S2ph8a/f";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766915665; a=rsa-sha256;
	cv=none;
	b=iGKjBH/8LMYwaTfyfRMsYJjUV/us6DKeHffzu9ewAOC1obG53BeyZNSOr562R8TpFzoDBT
	CCwqqu3jYIFwQRMnLWTINVxHoupN5Vv2Qcl5fZn2WZRgI2UOkMuv6eBSExxZXRi5+f67hb
	ZYGKsH8W/AHqUnlCA1J8baOK/k5+bas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FC2260055;
	Sun, 28 Dec 2025 09:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397ECC4CEFB;
	Sun, 28 Dec 2025 09:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766915663;
	bh=d1HWZ/gra3XXbf0pSMqW8Xa2iv1be8XgnIpd86Sciu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S2ph8a/fJAc0B+NhCYlZUvwtKpNEb86xETF+DEYN/ePGkRtbnyFHSSRtsbNuMUpUN
	 mlEmKNBxtFukASa1Gn4h0UHnkv0Fjaf8MraIitOIAF1I7gSNpiBNEzHD9O+Rn5L7+1
	 MwYl18Qfq24Hed1kWmbD8VuQiTqblZcpkIlPtsQWMP+ERZLPmQzlhwy/qCDblJi57J
	 LDqqKw3VdO437xnP+6aixjn/7iL9IyZXq+ho1aL3ffovZO7GTjpvZ0R/ykifDE6Lki
	 Z6danE2z94A4ZabQG6omWIlwQEhU5hGB7VaSCGZ+EXw3bNHYhDrjKhXsfr62tmttbb
	 n4Y/HYbursIxA==
Date: Sun, 28 Dec 2025 11:54:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: markus.stockhausen@gmx.de
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-mips@vger.kernel.org,
	jelonek.jonas@gmail.com,
	'Chris Packham' <Chris.Packham@alliedtelesis.co.nz>,
	hauke@hauke-m.de
Subject: Re: HIGHMEM freeing patch breaks Realtek RTL930x builds
Message-ID: <aVD-SaGkj7lG91pT@kernel.org>
References: <00bc01dc718e$b4108af0$1c31a0d0$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bc01dc718e$b4108af0$1c31a0d0$@gmx.de>
X-Rspamd-Server: rspam02
X-Stat-Signature: cqkcfzjgeybgfu3nb9x67n1q563b67dm
X-Rspam-User: 
X-Rspamd-Queue-Id: 77EB640002
X-HE-Tag: 1766915665-768105
X-HE-Meta: U2FsdGVkX18CC9et2bTZ7ebOmoKigITiqrClpJFExAzs3nHkNay3aS3KUT/9lyQrc5P6vtDWViIwW22/zozeuXC/nG2WoeDDplYxuyUR0kz0Pdr10QelSTtCkjhhJAaCQ3GvNA5OY+o7w5d6V+/j1KNLGchbolcwTAKePizwW2YLSt/1r+Uw42d0CsQNoWMADtwiK8NIgDuUqkXxB7FKqLKXvY4XQ8DeResLnfXTSsoF6CFJf4sAZY5kLPTfSf84YxvwubPQtrrUSOBU87K9nSot5+0tZs1Rbei0gWLkY1UaRnH/kScbi3mIjw7ZOEtT569kzRveeSuL0EzeSSSDH5SbLvR/IRzyABVRHnwN0LLY5pJk8dNsfRSO2Ur88D8+kbvNWgktzm2TiU2Ak8NwsJAvaVjjoo0tvFwqSjnwncBQzkD9MEP0oXI1fbCcNisotMg9hEpZ9ThCEiADuqB3zfPmGB7cbcmQg0uZPKUzo4PZ6vmhqfOOS+YkUVgiL4aaRcwYysHMJVkBbstOyQsle5sXcQm6/DJ5T2yIncmgYp9dpBkeQg8gkwGn5Q6B8Nm1lbpTAVEd+B6DgxlVjSdNAR91tl0fc93Et77mSy6W5GKsgllhosBBv0aO+QNxVHkm3K8fQKHIoUFqHXKDo2RnPmFUQ/nfHxqhnR0U2/MXJJ6mP8T7jQAkA+KVXX1N1NbaOpyhEENr82QETFXCAYBhffU82v9OLfduvPYJ4k/IRzPuouhBXGTNlvV0VZKyhaf2QNy5X3bpYPZZiB34sHF+g1OOqM2w5g+7l8AlmKKIkir5HoeMIfHEVtZUE4BrqyKamFgTXUUTFt/rQS3eV1keB+cs5hzfpEsoZUyzpQcYl95Wf5JfxFhAw7SmwXFRUmj3U3nPFxi0H6ifjWBM+Vlx/Js+A1ubzK+CNN/KS11dtm5bPXMjcn1Ra8g5Agw74flq9R1RNApEcl7MSuPfOX0
 IJLnE4uB
 jo79h0c76/UAcc+DxZTTMEzbTDHnh9/dwWdqEEnKLiH8+hzvH2tV6nvhW86hyJ6WBoUXn3M9T5x2ZBumqVVbRCi488eLcQqlzk5W4ZuEGq5O2X+4lm0UbIVRm8aUnGlLXM+OXU/WjijqX81hIZsgRkJrTl56U1uXrDUDIegimfeqmE0c6JTWzgoHJ2IqoDP/WF9D2an0zEOgKZcxx/+/C+3FHHCfKDv2aSOrlj2LZYz46PHqH+YZHx0vfOB2S7f8/KKQIneoUg/KhFX0FUidyRAMLhNzKQRXsOWC+p31eN4VY4riuzT8GtB6KWFJ/zqOsWV5LjDxosDeNKuHOSkfcsYeBdyLAJed0NOV98u1iHJzXuhbUWCcEl4VXv1uQ1XViEcuQUr9jReTmTtMsq+onfus8JiYmRgS/NJ2JycyJb4K2xWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Markus,

On Sat, Dec 20, 2025 at 09:57:40AM +0100, markus.stockhausen@gmx.de wrote:
> Hi,
> 
> sorry for being late on this topic but downstream OpenWrt just started
> kernel
> conversion from 6.12 to 6.18 these days. During preparation of the PR
> https://github.com/openwrt/openwrt/pull/21181 we noticed that Realtek 
> RTL930x soc based devices with more than 256MB (highmem) do not boot 
> any longer. 
> 
> These are MIPS 34k 32bit multithreaded SoC with layout 
> <0x00000000 0x10000000>, /* 256 MiB lowmem */
> <0x20000000 0x10000000>; /* 256 MiB highmem */
> 
> Bisecting the issue gave " arch, mm: streamline HIGHMEM freeing" 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> ?h=v6.15-rc1&id=6faea3422e3b4e8de44a55aa3e6e843320da66d2
> as the first bad commit. This is back from the 6.15 times.
> 
> I have no real idea why removing mem_init_free_highmem() and letting
> __free_memory_core() work on the whole memory range gives issues.
> 
> We are aligning to upstream very slowly and are still in need of 
> downstream patches so here some additional info.
> 
> - Until now we never cared about FLATMEM/SPARSEMEM configs
> 
> - We are still using dedicated prom.c/setup.c for the devices
> https://git.openwrt.org/?p=openwrt/openwrt.git;a=tree;f=target/linux/
> realtek/files-6.12/arch/mips/rtl838x;hb=HEAD
> 
> Any idea or hint is appreciated.

Can you please send logs from a working kernel and a failing kernel with
"memblock=debug" added to the kernel command line?

Another thing I think worth checking is will the system boot with a partial
revert of 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") for mips:

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index cd04200d0573..be5985155509 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -419,6 +419,23 @@ void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 static struct kcore_list kcore_kseg0;
 #endif
 
+static inline void __init mem_init_free_highmem(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+
+	if (cpu_has_dc_aliases)
+		return;
+
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+
+		if (!memblock_is_memory(PFN_PHYS(tmp)))
+			SetPageReserved(page);
+	}
+#endif
+}
+
 void __init arch_mm_preinit(void)
 {
 	/*
@@ -429,6 +446,7 @@ void __init arch_mm_preinit(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
+	mem_init_free_highmem();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
 
> Thanks in advance.
> Markus

-- 
Sincerely yours,
Mike.

