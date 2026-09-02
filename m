Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5933FC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B1C6B009E; Wed,  2 Sep 2026 03:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502756B009F; Wed,  2 Sep 2026 03:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9586B00A0; Wed,  2 Sep 2026 03:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 172A76B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:33:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E615140773
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:05 +0000 (UTC)
X-FDA: 85168005930.07.135AE33
Received: from mail-pz2-f9.google.com (mail-pz2-f9.google.com [74.125.228.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE64440003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2cM6L62;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+6c1mxNeRcK5OGJwTOV8Umz+CvUvEErlItanMxKc4I=;
	b=WVJapUfK+vXFQrkdL2aVYv8Rew57LjEOTT3IDU/lxJJIzvOzw2wny4nPZNvqNsUCQNuxpx
	RvIp0j9/Yh1Y6rwqWa/WHzhXMmUhaQYtAyhoCEleFmGGox1XaISIbF7UajHOf0UZ+hFJcb
	oL2pYMuJSATBO1RnwK3/G+zz9j4P21o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2cM6L62;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334383;
	b=pAhzw744p3bPhavGYfaL0zL23h8/emZKhduJejAEOldHfublywyPG+rxhx7SYFFq3DTIJY
	hH35hCOwysYRKlnmpY7nkgzCRgUi/y1jAqhdIAAjEtep3jq5+l532R8uqaFOUZe+NtLX7f
	16DzaKNdO/2aIOESZDOb/zcCbCvKlEo=
Received: by mail-pz2-f9.google.com with SMTP id 41be03b00d2f7-cc1cb94b583so255032a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334382; x=1788939182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+6c1mxNeRcK5OGJwTOV8Umz+CvUvEErlItanMxKc4I=;
        b=k2cM6L62yR7mfbmEkA7dLB3cpNDE7qY6M29FciPLGuhKQEgxRECDkXCIB5Bx55Iyjo
         WQtCAlHMQ5afzkYwN7C3hih8TMnQZMrWP3zIUi6KGukNwHRoFFSGJtSWlq9lR4fJKH5n
         61V7nwHgK5BMYxWF/4TX8+MbZzF0sbjpOmahqfsHEtkOHwtzDlSUiKzNsffXoQehU3si
         uQS4zp4qyR5jZrnLuT7cQXGDnzwnSlR9m+sE0UBoJ4S3Bs5Nv5++wVwsaSwkLErX4Sj3
         NEHzI63P0KYT6e1LhCo8N2jXQJtEpDyY1p7/KPKCiF0xsHj+NAVshzn0/tNKzZaH9w+s
         1qVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334382; x=1788939182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+6c1mxNeRcK5OGJwTOV8Umz+CvUvEErlItanMxKc4I=;
        b=F5kH5TuwOOcYvMKpz1v4FlSGmuzuTHP7WJPY9U+QpERHCmCAG+P6kDX14fQ7WEZbSY
         Ze9GQZTU9NOGDOj9TzFu1cirTqMfwigQAAbU2deW7Qdjzmea/ez65HT6Y0GqQL9qwBcb
         IuPWSN9VM6eCilEePqO0dLjaQwlqyTk4Pk3PzN+S9oxLqAj98Byrig25F+GRoGtYSe/Y
         VMnNl0lopWfsHSNFI4k4v2Ak0LbrJZCttmpcO3PEcWCoNPohhkg4ZeMNUu7+thVvAm46
         XGW2kPIO+8uH3KhqzFwPeCGvkvyVWm8ym6EbeKRiNh744HPxsxPBngdPSejSDToHW8El
         5jWg==
X-Forwarded-Encrypted: i=1; AKwUvBzHKjlDBqG3mgKneIxVPj6Vzgy3ktLWVrDbzIgzVjrZoQ86KzAcjAJNuJipt/2EtrqvZDpiEtjbdw==@kvack.org
X-Gm-Message-State: AFuF++k4DiQ2sTOc//YY1ld+jPL4K7A2sRGEFsT+Hmevjy60Tj5+u3iJ
	kDfYNq6ou8S9DY5B3ygmhw/Kd12XLwyCpOhmI2eFNCX7nMf2QhYo5WJB
X-Gm-Gg: AYBFou2kipmin+BTBhyNIddCMYcryDViqRA27Ab/qnwaI/cKkByC/bhmkGB89oByt2a
	UPqw6risFHGNwMlngbG+eehOnGo3oAHRvR1GQXYxB0ymGgm/BgaEw4eRahxedixIOsVUXGQboVd
	pQwcpUlgidIl9vf48H6zh3YEaK+YfdTSBhdDHy9DsF8Af4mhPRF/ld3QRhWdBWoIvWRNrNxdOKs
	thEIa/kH/K9rVyyE7s5yvj/Y0bKWBcQt7/L2xQqx2fMnAmYlCPm3wyDRIDX6l0bv/dMDtRvnt07
	w3VlKiEgUEb4c+7J1Syk3O6op08DsnKg32XCC7QRBDLpMsCmK6COOrml5fDRVsfPON01G53atUQ
	2caijUWxhHRXCYQ8X9RBn0AbZYLzXE8pE2DYrgNUt5BK2czwcsL9ok1uqjETTg0HzBoB+mtBlMN
	IypEcHm+VoUOIDngzmOObK1kdwhEnIPsd7ucCGFD5S0k5sqQ864k06/DowlxfvSK/rL7YdnUK6
X-Received: by 2002:a05:6a00:330a:b0:857:74ae:ad76 with SMTP id d2e1a72fcca58-85ed4e09b6fmr5077449b3a.26.1788334382541;
        Wed, 02 Sep 2026 00:33:02 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:33:02 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 07/10] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Wed,  2 Sep 2026 15:31:13 +0800
Message-ID: <20260902073116.802752-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zc3hrx3futiyhss4o7txjczwsy58bzss
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE64440003
X-Rspam-User: 
X-HE-Tag: 1788334383-66965
X-HE-Meta: U2FsdGVkX184Hzz0gN6LgIFeo6ZMnXEM5acv3oZaaHBVlabMJOqpLYXAl3jY2Bc819rZ+RWfHBhf4BHRimw6XAshIWWlOuLbyjR9UiSFXRYrd+dqhyOy58hMq+pPb8avCUDBtAVKUlBccJf4hxuijeRFb7Rp3bbqX/dAP+MVu/Mz5ftmkhVdXsx47tLob1VAidoKPq/ZSX//zt+Kn56YOGTcKxq5E4FeWWa9iHoGHlulgRQ8gygq0g1035L2TWb0rmjQAO5dzZH98sl/Ct1Z3E5Ynye05CUlHYd97f3cJv2LVXSexIdywFCwFg7gxxffdnSqYUhelR1LvuT6XXV55IzHiCCbjfoE9sod1CVMuNtctLA54o8IiWay2ag5b4rpmman0kLVCN47eb4dJt00bx8TegUSWV3zQb9pIeh4szXN0TrTe2ZI24sBYbItXmXCoZn5S4AoDZKNWjLDoUjw5gA0Cz5CfA2xik5joMbUl1x83LAO/Z+IWC/IxJJFXcX8FIeRro+qIqXTiBAx5TscwN4ApiwAXwe++634RKuf5ZX1ALwUr2ZINNMmhWTlTEjL+u25aC7BMxAl93SiyyGleCJRLt+Esug6HbdSdkrd1qqvMt81lqlDbEPmioU25PwOkwKMH1HOQLVck6SJbx+xofj3IS+dnVacrbEGOZ647PbLBeRE0loSqXDlUIUuiSNxDU0qhGND2BcGFkTO7fmXiLIpFG0dv4eb4d55wqNbAqZXLaNTyQvRHoZCztUq18pWb2xq/aSEAtXQfDUARV7a6Jm3Zq6EGCdUpbHLEhKMxOi9mRdjCRQ0xLB1KWeRgbKQgpcrBhRdcPzhSmjDCLpAWuz0zh0xAb5epNfsLVrBLoyPOE7PEktllvXEzglyb7m0IJyiK4ms01GejW3M+xPNBQ50f9K+XKr5VGxOQDyKhOTcLJThqCzIi4mWkvTe8keYnbMiUJTkB9iLgdKFahr
 5bRWB6sA
 dMl2VRMMkdpMoBEmoqo+hsw5Pq1mTpl+NizYHqn93qNjb540csPTf+mIz1sAc8slEYAz49Ideaa82HMNVrg3Y/0BT7375zISCFZ4J2ASpDhVTPw9sdNYz5yvCt5sIPpbz4E3Gr581M50XfDFg+v6EnC49QGVI2C+FA2s6ORBZ7g46Dlw9JyBT5Xg3PJZZGaeTVzw/BET+vF0IttA2QvCW0ro021VkEJb3Qlql7TN3ChxsxnuWHMoBVqBAEkbZ5TQp1X7XYRsaGwHoSxFDVmm2H/ksseD92D/8t+m6kC0Teib/ckPrN+kbxoPB2JhCU2wxxPdrm8z3JRSES6uRdN/Il7HuXoehv4NKtkJgHFmsEzPM6N9zBwcMzsRZNlwmJAvVRM94A3OMdzHXsE7/13PS4cm6RdHFm/TkEbEB+4A9Zsc58U3GfZlATGkoAZBqPTJ5hddQB8Pwoe2ycynPgo5g95wc0qPAdXTR1mbbimOPpzDYWsRZJMmzzheN/5127CRFHiju7QE9QquLxYxcfl5YpVpW0Di1sbRNMr7R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add a 'dumpable' flag to struct reserved_mem to decide whether a
reserved area should be included in the kdump vmcore. Non-dumpable
regions are later marked MEMBLOCK_NODUMP;the filtering itself happens
in memblock, keeping the arch kdump code independent of the DT API.

Most reserved regions are owned by devices and do not contain data
useful for kernel crash analysis, so dumpable default to false.
Reusable CMA regions are different: their pages are handed back to the
buddy allocator and may contain key data for crash analysis, so set
dumpable to true in rmem_cma_setup().

The dumpable flag is also used to check /memreserve/ entries for overlap
with other dumpable regions.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/of_reserved_mem.h | 1 +
 kernel/dma/contiguous.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 49da515859f2..99c0f3ccc297 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -15,6 +15,7 @@ struct reserved_mem {
 	phys_addr_t			base;
 	phys_addr_t			size;
 	void				*priv;
+	bool				dumpable;
 };
 
 struct reserved_mem_ops {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 66093460584e..caa6a5c66bd0 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -567,6 +567,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


