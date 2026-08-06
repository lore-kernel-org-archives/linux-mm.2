Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B752C5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5DF6B0092; Thu,  6 Aug 2026 05:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD616B0096; Thu,  6 Aug 2026 05:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3066B0098; Thu,  6 Aug 2026 05:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37BD86B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:36:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7310A0448
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:02 +0000 (UTC)
X-FDA: 85070338164.12.143A23E
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9A431C0004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOob4c+W;
	spf=pass (imf18.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knTPycIW4JC9RtVxI7lTQdVb1SJbys3U0akygREf/j8=;
	b=xQsWBSbrmzomPJ3m9Z9+iXlytvmir45y0tdQQpkPoBCPpDtfZADHtz3Wy1PswQKoGfrfHf
	BLQDXQN+de2BB4umvY12LI5AO44s0wt6yD8xrPsaawrqeCTVDgytzl/ZRXzRmYZ1Gmmz+H
	/IHUnadc71ud6flBMYkmXmeZozXyAJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008960;
	b=C0Dhqk9LkQGzvAXIzngIRPYH1ylg2WepvVOVwU8UhGDbSDFz9qmRVVrQQNeyvy6iT3Fb2b
	HbKDNWV5FICyj9rQInyvK7czfYcLGKGWuD8R1T4b9lB+DeEHk0qtxmlFUiCU/fMUjCfGNi
	EISJiUlPmmaN3A2QPGZnaDz4RC37xbg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOob4c+W;
	spf=pass (imf18.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca24d39d8a4so1086032a12.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008960; x=1786613760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=knTPycIW4JC9RtVxI7lTQdVb1SJbys3U0akygREf/j8=;
        b=GOob4c+WsHj3ibeT9c3V20FIHa+1vkQS3bZpshTkBwNEVTcNhzE7aU/okQnqhWZ84L
         e3tX++ZSlfVR/Bsuv+qlirkie4XSijaEKZJgkd64YhrWadlB3WYBlIDNXJ9zRVHrF01b
         KfRXWjiCx5FNyJXAOlMaozayXf1R4amxXJJPzx3K1go7VKKH7QoV8gnNNiP54bZkUsAJ
         XrkvufXh+UKJ6WyCzaZDn/jHgAqiOcEE9ECvbqQAyiyz7XKQUMjecxLbDEu+596nKwXI
         74UtBqT2J/Xu2+luISKdHzyK56+HYA5u7LrphCp4VNekSu/73+JAY0Vtm4JXauYSIxyG
         b0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008960; x=1786613760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=knTPycIW4JC9RtVxI7lTQdVb1SJbys3U0akygREf/j8=;
        b=A5eY43NOU1RA5PjNggFphpU+dLcf/WbItGLUd3DNbcqGZdpP+pAFwQwM+wdF8CW6FV
         KWvRu6HqYfDJ6TIqkKMduFeNDWsAqtyXdOFRmYcPaPUte7eG9G+0+hrkejhi2hTFz0jE
         zrpNYkbyr/Dif3YGPxzh95cI0MS/338Yt5B1hELQzU7F+wa5uvxHYJiQkUNPZSKuM7OW
         EOr6gAk26rggejCMRYvwnoWt2QbsnpnQP66HOgAXrpM3tWbl9FDoPX+0ChKpVmKWlOJA
         jg4LeYBC/JFrcLHZLZwRItQN58wTZEBbdl/6d1k3sP9Hh5A6cZt7M0m5gn8C5iE++eeo
         M3fQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqQ5QqnJ61lIVT5YyMCE8gg9EN+HlPullABByEawtmOK3id/tTuc42O5VUfILsSr8GawKY8zOGRg==@kvack.org
X-Gm-Message-State: AOJu0YyV6rcKhNy/LfoZlHe70gyZIgXGOf5FM9jP5jRSV7P73MLhrSga
	zN4sHpwxxX3Q9n0mv6XdBEZ4byWuGTm50CEFcIaguKELC6kkstWlBXGh
X-Gm-Gg: AR+sD11wMfEHxN++uTRjcuPrVoCRBFamK0iI7SzFTX7G1MxI5bSthdUhDQ2mzcsZx4U
	fxieRzM6+ryLMnkHzSrc4ZmLQwSPl//4Z5KOHRw1fpSBLbMJsRh1BabQfj1GbFF6i7/sjfz6Gbs
	DdZ7e4AGg0tFjyMniIqfY5qtJD1INXgFBa5GosvY/YZJH7ESXxiFLbA7ohPnSyFEjyL3CPn2ijm
	hyvfIABAANo1oclrqKJa/kehNNkQy7rLt/eP1ZBBUesH5MDYZkOngy//SSNCtA56qltaYWv5scS
	UaRDbdmbFbolS/793kLCYAPP3EXqHSIQyoOcH/j/MD5sdM6uzzWg3z4edQErWahWdN5bh6xV50k
	n0+uB6Fwf4yDhvVSotfQ/5XN7UPc+MVuEIQs909t+hH5A4l7LvtKcTSfyQjILYGXJ9Ru2+cAzJg
	4t/yDMgGcEFHB4u+LKEp4Kf94f4CjaFvrJ5l42FTmN0h7u26aiSZVmmN5MznAxZtI471pLagTUv
	mI=
X-Received: by 2002:a05:6a00:2d8f:b0:848:7552:3d86 with SMTP id d2e1a72fcca58-84f2e009be7mr14478703b3a.23.1786008959699;
        Thu, 06 Aug 2026 02:35:59 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:35:59 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 2/8] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Thu,  6 Aug 2026 17:35:13 +0800
Message-ID: <20260806093519.2907771-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9A431C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pzg3wygr33in5oiftoiofcabo8y3gbk1
X-HE-Tag: 1786008960-116227
X-HE-Meta: U2FsdGVkX1/S5E8B1+J91ojx6aJxXI8PSnbND03K/8evQ8NSPsK+BykAb6agFSBv3Ww3Cg8Iz9BURjDeoO01Q0TAhf6lDZCaNIJamn6kTniny5uHJIqcZCRA5Xp+1EVfeVPKDLkYzUu4MAafGqjvZ1fbYheij7d2nAUurQvJtWjm9ZWNlBY735EKH1YzT7rh9a/hyGJn6wu/B+RXIBXNyoUE3dODnB3FcVVtqlngw5RbcooFZelSH+G0KcvM+vtdKebrS9oBmYbnIasDzzKDJ4pZyleQGas9ZGZ/vx7gsvLVIk2fjiVgm89LOrquHVXxCKef7Zy5uLO5Cgeq5beROhVayoeEJSBdhrtY51u9UCh62jIxUesqPppYEvVxNYVq/Z0zFs3TIOb76CnnP/cHJutBFQkSGAitbaSdZkn+jD7uLjqUMkPuIgc/6KjwvM3i1h178/XUaePLKW2/HgIFFudN2MaehQcOmgsUS0B+7F2XEIHVyRE/A6joyoFPSoIjy1PPJ4H23+VUfScqN7X1qj98WPdbQFQgrIdYxOdbqemqzgtUOiCa7T+f/Ux27ymjVrtyZmSnLsJhvDvYUYQY+CNv725r0dxQbl9VVttZ1T0LuoqE5GEOfm/jgg3O4OAKfJhs16Eo1O+yiWfVSFtfXO7qNevHsiBh3GTuAfcbbe+N2y45NkMvsN0rYFQ+z5TS/1/gt3uEixiy7U+VZmK8ZPMid8zEggSPA3Q37YdnogRKUy6WhJsTT+je6O4BaC/3dRLpNpTr5yGmQaJ8PucxYICMp7tRgl1jgVlNVM2CwDPWluIx7inebK7RBcy2ra875D2qPJWJ8Ftoa30IGTCVBjGBd6YuJPxaG7YDFQahVpYBx5Bbw7kd+LgyDjtkG0r2y3fTLYeFlrmZ5g8vffWttM4tL+bl1wU3VISfeGhUvATMTKHnNF+XqrEcfuGf1ITUHX+8f9HXBMUW+vh4Vzc
 DbNU1fT+
 yJ0MSaYWdOQ9Uw1vuqAvvsxDEhIGN1bxzQ8CthE5q5dYNHm23B9ir94eyyeJLSpLkXFncJILnLal/eQb8KpOJUT/c4VbMqVnkWeQXmKjFGN1T6a3mwTzr2dVuxyXIhoqUa6yVkcrFBaYu89gyaX8Ta6FfKOUu6SFp7NBc6/d1r7u9qxGr9OGpnGWKUTvg7oRiRzbYbX8Iu2EX424qnx17EwJfHhx0g7riPPIDfCmaz3m+0I450zUnWqJ8KxwIziCJDSMiTMdpii1OKQlI2avZTTyisHM+pXGz16w0W95P6o7A5c9P8ZAW+c7zewaU+PRwaQlwIIDYc6vGJthLowqr/i4jHACFmTsL2gdDnIef3nutaxVlox+/B0KLkCCedVotUHKHNyPIipA8TN68oMujs7w444nrMQd0fqVAd3TyaU3W6ckDsH5eOGNSgUdCNRhfLnzsdscpHxTLJaYFAXFf8jEYhDRQlXMRWkVleMOE+q2gwvNWYd+k7bOrF0J9n67nMdtIB9jejJRg5BWYd53GTjW4TUAxOz7UgcLK
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
index e8b20b29fa68..55a67cee41ea 100644
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
index f754079a287d..63ff134dadd4 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -565,6 +565,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


