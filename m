Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFC5CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE498E0065; Mon,  3 Nov 2025 14:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007DE8E0060; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1C28E0065; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C26BB8E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ACAC1A02EF
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:44 +0000 (UTC)
X-FDA: 84070222488.25.AF252D8
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE9D24000D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VGEu9UHr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196682; a=rsa-sha256;
	cv=none;
	b=H8X5tQiWOY/NN9rIbJHceRbbeLnc7x4TJMvVTpPm+C3tEm6SbR44KAg4gX9mjgxbRh7Gr+
	hHMmKRNFCnImznPrACd3NYu9a2+rLT4S9UDCoBMFqom/PuaMDYIk4Q+D0j2jxihvZy1qyz
	AanIiJSTTxmdBzOtLaZ+atQLhmh2ysk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VGEu9UHr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMnUjWbVQkFZgBYpGN6KEYbsBeg0MOvMFQqI7fxTNmc=;
	b=8nhe4MHZCC/RlfzvxINhz1egF3Ttvq1CCPQB8yf95TE7vP1L2PPkKYIaLLHyjPl/yEdxv+
	97NugyK8Ja9T23T1zfck87DirxlzFonVXS34gRy1rKZphBvwQEBa0Ek9kStmKXttXMuWYz
	YD1pHDVvlcweWACKg24vo108oOPGDp4=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47754547a38so2314405e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762196681; x=1762801481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMnUjWbVQkFZgBYpGN6KEYbsBeg0MOvMFQqI7fxTNmc=;
        b=VGEu9UHrjbbddbbg9pmc2X8XPZ25VAxkBUWTyj0JPD6CZh1dA6yHsra2+0bfLi4bH9
         PrldWmq5LNb9JiLpgg6Cud5/rlvrbimFDjWKcp/9iqFGqmkL8O8ep3c/CysHOvQVR2KK
         0OTzbVhrajzbLzwE/r9kRUbHzJFfhYsbMakuidUKQLgEdECZ/Gaix7xSCYwxq9bAvqSC
         NFPhNq6SYnLuiHn8rYowu/DM9ea8JJ53Xs3Eb0UEJeN+xfHiNqUqRO4BxRnhILw8Gap3
         R0IGqD3x2DRXDPPXMUgV3lgueCoGyJsO6QCB6DtB5wMEd9bx5sfPKWTAfIcWj8wgR1tZ
         jXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196681; x=1762801481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMnUjWbVQkFZgBYpGN6KEYbsBeg0MOvMFQqI7fxTNmc=;
        b=cyIiEeoZsxAuO02TWByszj4HChSCOhKtrcRb9rEYqmFL4bMr6O3VRzGENySsJVWk15
         qVQfHxUPz2Ms/hSWUgDepRYtaT4KieNwG4nDXJuasHi61r1HpzeSnrDacAHuSXnBKqVG
         yV7/RHeDnztfxUUrFDnsPdsPX3UIkfe+fm85+L1cj2LJeVofhe7EmIKgZkkOVpJVo9xT
         f01KRpqq4wVnM9QFNRHcE/y+CIS4sbHlsYLIac3E3DGqBrcOItCNO7LOaPYKRvJm9gee
         V8mKBGKPvm0TTA0Ssqj57T7IacLZOHIwugy+J7ujYeIlg9cuuPJadQA9YGLOHa2XRx28
         94ag==
X-Forwarded-Encrypted: i=1; AJvYcCU4OmexGgnMS2QB+X98rjvA/PVqE8cU7Ro+QhSdQpd+kO/6+wb8hbRF3Ch/Emt6Bfe+iuqNmDGAFg==@kvack.org
X-Gm-Message-State: AOJu0YzQ5fJP3nlGOkQiduDRGhq7HZAAVQtnpdmoc1jaZo+tE+holpaP
	AWOJuHrGmI4EXOK2gr6qVb/gR0uw1GDOfH2LOWP/s1zjtKVIUTp1XNgjgoOMQAlN
X-Gm-Gg: ASbGncvPV/LEbes6hrQ0BQH0ptuF1gHW+CwzxVmZvc+U+p3jOuFx4r0iANSg/8lXeqC
	zTBt+7N70D5RJJ2oLeluejM9/Ee6dkZdhWAi+qAge+EVudtriQerCCm9V/gCFG9HPZWB5b3Phpj
	SBxqpjY5UxjSwGa5+VefGLrkMWZDCUJwDC+Kq6GHxD+mvH+TSLZ8YdzpgrXnpNLe93OnFEtBWMj
	b7uD4P/GCJUnE1dO8SObaojdnQ639uaAuDcZ+wTB5FSl/AiVNkkWqIER/sLazw+/AJaN4d3Q0TD
	qlOoVWdfRFUJ6GhRSONvPBQBShaKG3EjzFV3hN8/r0NS/KiuKLiY8HenqE+bYHKAm2GVZjrL9w+
	M3JZ1Vhqc+L6glDKtlR0Jw4DS0Br3DwgwDCxZ1yZS/l4Er999F3et8EQf+SMYlnhg8owuSxKbtG
	rEyLE92XZ3+FUWQB4z6aiDMpYcVKOkoF2hA/NMLGdGlsf0aBJ4TzA=
X-Google-Smtp-Source: AGHT+IFX6uSEmtDxOm0TWD6UoPf5193LhYGsOHconnTVDoJa6z3u55A5GqdprLwahRV5aW/TdqHiEw==
X-Received: by 2002:a05:6000:2dc5:b0:429:d3c9:b88f with SMTP id ffacd0b85a97d-429d3c9bb11mr2872576f8f.8.1762196680880;
        Mon, 03 Nov 2025 11:04:40 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429dc192ac4sm327407f8f.17.2025.11.03.11.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:04:40 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Mon,  3 Nov 2025 11:04:26 -0800
Message-ID: <20251103190429.104747-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251103190429.104747-1-vishal.moola@gmail.com>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE9D24000D
X-Stat-Signature: 19cqqxwxtpcqmy36gso6k575fe3oj4jm
X-Rspam-User: 
X-HE-Tag: 1762196682-964239
X-HE-Meta: U2FsdGVkX18cIIjceJH2PmgSLV5gpgw9rwZphf5BTtsdUgrYDSREMsnCnZITi99VjwOcfiTfdV0eNTeRYU2ewzpWZvBgLXTfmVa8Tg/QXnR2ZHMdOM/eKvfuJt7INPydt4tls6prka8VbDs3Hnl/6p66o+E2cPeqLMVzybrJJ6tOYpWamGUXvBy6hszMUREtQ2yK7msHZXnKK8IE6UShk65vNiWQEEgcw3Fts+YsDR8GQ556hrMzqpOyZXdLyc7QEW4MVNQvy5i8G7IKBpO2ASTaNaDr20XRQJFvPOSY14IG+FgJ8uuS3pcf6WaGg1GVvAs50IzGwvncdd4dZMEA9E64+vijhD39miX9aBBFf+X32K+rcbzktUXlqFLnCP39C7HBjN0Qk+aMHvtXHFtCmu5Wi+R1DFLEfRzNVOhdMYjy88oNykIkCX5rfBN68C4pGivGf96HH2AMU8z3j3FB3O+ym18FsvkFitBqt+Fxk7SQsyeCmFaqL2NMO7oONEb9877FRK+YU+b+lnLduZOeG8Q2ZCcimEIrTAfw8nV/tzx1fibEUoMB8G4KkGqgvNlDKRgM2qIHo1hWjrE6jRzfPZZUFFt5v51YXT+Mue68NQ74Z3NpzttqvFypBxGXHNneWG9F5ynZWvifk3qKpFCw3jqf+8A8nMEn1HtJ8jgfsyTa8qX8wSGLWIQOXIEnGknxk46AF3Nr3j+XOKmZQVnxqoXNadnIDE64Iw5jD8FYU+4ByJ4QneOPtthHefoi01onnt7WA+XpqjGU/uW4ARw+TlN6NxmAA3/1ohE4FcmA3RYl15Srh8Ix/P4B8OfTWv7ickH3m4XY4WIMoAcvOOWAFPlZBssKMysKbHiuciZoE3bA8HTMynF2U92C5DkILNPM8LiJtHUNBXDcqfWqsIvmpBFmxNmR01E6dXTluVeJzfF+qBJHsqsTeN5zIziICfanY8EkR03E7QI1rYTwhPq
 8RNy1Tns
 tyOD1fM9HU9bxfNKIuHECw0wQyl2dwregv5VZr7hWwEm/1S9IBFJ1NFl4lw/p5fPAC9mNlabjy/VsIGVje2sW23ZDR4fdn5Loj7pGfm4qL6Fk5WH1wRBhIl5cHfLp2ZilR0FUPHql/vxCLKvrHjv90r/e0DWa12lwTbYD1r1w2tsK/OUUJmNdwoJz92paO5SUL4SiFWnBfVmZIoIY+eQaBWI2nJMd/CrbGrJ6STXI4dEWi10qTya5WgCrGGQaF5bdhd86Z9t7M1XHlk/ELOLYj+6g4Dxxcl1YBp+6TDl2Z6JbBiJ4RSEMANOv0RbZ9AU5Z4MJaZPGSgAd40peUVDiTrDFkUKiqmrUVVCUnhfKX9I8KLERq7LMYTlQzjq3s1MWjifdAqIjIgj1mwYcJU8k7y9Su3O3wgP2N2xXZyxZxLUbKPw2T80if1AmW3FfQMBnsHwI7dsaaVRPPWonLpM5okyNVCNgc7Z0qOAj5vJJ6foL6hudCi5jABK41B0FfHKcyyszi+XkB6O3qc+KISPXdeYcneVylPAbq9jqgPlhjhJSJg82u1k6yqRJVikLUQDLaMzXqGmhgS+ZBKNW37NcQbQHMCHcfSDt0Zfz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmalloc explicitly supports a list of flags, but we never enforce them.
vmalloc has been trying to handle unsupported flags by clearing and
setting flags wherever necessary. This is messy and makes the code
harder to understand, when we could simply check for a supported input
immediately instead.

Define a helper mask and function telling callers they have passed in
invalid flags, and clear those unsupported vmalloc flags.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..290016c7fb58 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
+
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
+
+	flags &= GFP_VMALLOC_SUPPORTED;
+	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	dump_stack();
+
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
  */
 void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
 {
+	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
 					   gfp_mask, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
 					   node, __builtin_return_address(0));
-- 
2.51.1


