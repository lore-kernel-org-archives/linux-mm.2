Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9C8CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF1D6B0092; Fri,  1 May 2026 13:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96A86B0093; Fri,  1 May 2026 13:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACA36B0095; Fri,  1 May 2026 13:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5F046B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 505921C03B8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:34 +0000 (UTC)
X-FDA: 84719542908.22.4A18CEC
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74A3E180009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T06ROZKr;
	spf=pass (imf24.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2jdlpGF4XpPc9ZFDgVdeXjA1AFqLuNKcjK8mHttf1o=;
	b=6McskrxJJOQ8nCqcn0bwvxUM6pM2QyFHBK5Dixwj6lHFDLBxHuR1n/ePe8EZyz6KjuqD7z
	5QhGI9iejnINvbudysvJBl9yGDy+Kz6rutiPEtBBxiciFCaRU4BN/3QTAj+5c4fIwaGxZW
	g00oD5qBAI583JyzrcRc3Qhl9QfM3fY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T06ROZKr;
	spf=pass (imf24.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656692; a=rsa-sha256;
	cv=none;
	b=Z3f5EW6VLrIUq94Z5oSuRrEBMCn/OG2BgWhrAEamjU2QHCufdCLEDF8xVc/VwbeX+mvbPd
	JUJ34LrivVmoRs5N3/CPd3eneGIlfW915yG5KpaHu7mkKPButi2bQiDtyAt4zul5NFvQ1H
	PqVB1nFRfSnZCGxY6XTSc70HDFk3akM=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b9ec9443c2so1651585ad.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656691; x=1778261491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2jdlpGF4XpPc9ZFDgVdeXjA1AFqLuNKcjK8mHttf1o=;
        b=T06ROZKrBZzceiiRYkBCxE1YT8zMCZk/0eaYBpz9gHbwPe4HG8KtjDfmmcCTUCK5zV
         Mt2+J22aV5Va9q9ZiZcybPKG9bvrDGzZkualmVS5WGr6U3YNt7Fap5T8e1a+G7kzn6ch
         ssXm6jFo6+k8OCaKTbdNyt8soekB+3IbQ353BZKShx4tp2J345SCSwJRKVW3lY4MIM54
         /7z5sf+FPpANUaRDM4B2CtiqWUj1WR+WJTBFv86rKFIBCVBlarZl//up2L815LNodKP1
         S8Ps73nnbWRqMClcxdiaI1DruwGCYeZwkzYnnnPfEybHSngl/baFkOUIvgR8HYGKOZuH
         sdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656691; x=1778261491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r2jdlpGF4XpPc9ZFDgVdeXjA1AFqLuNKcjK8mHttf1o=;
        b=VDWqPFwk50qbUO1R6Q5rSu3GBRBcT0bEkUzcHsC3pvwDtT1iCp8GJFQlb6p/Uhbcam
         FHKimwh4fyMiHFvGqVofWqBD4bNI/V2hSVBAQaYrzBRCJBI0NtABwkR5SrFUGydWbFXy
         LfZc8IpDV23jwvJwUvChoIO2qMo1+WvaAVet+w3ZdvI7BvfIaOH5fc9sqkwISDSPN4To
         Bok6OTq0nOL8/QgpJBbsNJdGrbXFTSb/aCgalL1YNMPi/RE4VIAwmI/KqYj/wd99ms6B
         osNZtuAy7rPoFmsfjDRIsjWTlDALdA+FIepc4sOqc1njo3c0Jb4YhJK2NYqUfko2LbFv
         +LaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8U6gWVuraLMCSnWCrCWibqEOS4EFXPoCbXp2qElWrsjcSTOr4czjHQsrKZFvRAZE1OfuMAOT96pA==@kvack.org
X-Gm-Message-State: AOJu0Yyfhol05iIWuLJAyB7Utrorr3NmDypzPSeEbfhS0V1VO9dpALV7
	zqlzdxTDYSHECmMXtF1fHt1GB2s2Gv2amuNZeM3xMLb1o1R1bdLNFYfU
X-Gm-Gg: AeBDieuzK94glMTwhUN/bCwNq2TcTytBePNZRbau8wFYjbZPBiw0G8OOI7a45dLUOju
	zm5tHKbUY0IZbkV+rLLD+TGDEaGqn1QRyNP95LW2OkaREGQ8yM90P/IwS/tStsSaO5UHl+0YD7z
	0IVteUA/CcobqoZ8YKi0GyUPr7tz0jVJ0o4qPKhokkD0/JnJcRKl/KTS4e6D2tTYp6WMyBLhqjY
	CqR+RhPbS0E+RqMebIq5StNlus+kNx+0snX/1ylm+thwM87xxq8kSlh0J2kC6EJvLs6A+zF/OfQ
	18lGfNQgB3vkIB7VMQHPxziZq2yy6sgPLckKn2aoHyTSQ+WZh+CdQFjGGUPfVnwVAOXamRW0mK2
	2cW05soxOhO9yOh8hanyv1RziOn7W91gZXFcoQ9WWqO4TMz0Hit82boBVeykQmQIMaRkKRkxLrv
	Kl9jpqrmboRNX2cU7FGiBCF7ieBrB9ojtY8aKNGw==
X-Received: by 2002:a17:902:e54b:b0:2b7:88f9:9c28 with SMTP id d9443c01a7336-2b9f1cede68mr3019515ad.5.1777656691129;
        Fri, 01 May 2026 10:31:31 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:30 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] liveupdate: validate LUO FDT physical address before mapping
Date: Sat,  2 May 2026 01:30:50 +0800
Message-ID: <20260501173053.73116-3-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74A3E180009
X-Stat-Signature: a93h7id4yz68d3rzntqqq4nhkdmoif6j
X-HE-Tag: 1777656692-797226
X-HE-Meta: U2FsdGVkX18adwarObIpzN0cYS9CW3diN2D+wniv8byfALxxDQ1+LwSA6K1XtAS0UGXYAN3uXQ+t60ZUlk5PVMDPyfNo4PCYUyMglJU1okHxw1wg2W6on3+F3frJY3f4B16C4SMvnFLHM7Z8h3Wzuw2dbjYojKuYyAWR314ag7yCcNM8wBNugoNqSYPPyzp7rrf6OrnOvrHKRwqzFvQD+fENx5Z6bWjC5AzusyJcH/lPqng7ad5Bg7d8OMSOAKnPyQNE5ig1gecujn8RmrIyh/CdshNQ67gNFsEBNm0oc+DlTkHtbGDpxIC2hiapfeGaWRY/ZpVHpgVTBaR+ZAA1lgmnUGwC6dlqnwk2FBe7iqpjm0m0wl0vIGZjt7Z/7LGZhHmzw5zDWVZYu47IJ0aVfERcxlhgiEaNabYPISKnWceza/soncXn9NKRGMJRUDRCu8FnnSyEiVJj/AirVYJDhIkG7FmtHFpdzKTX/u66e9LHTFQH+WRW/puTOqpNbQ8sbn2a8V9qR0QcJ6EnLBlZftgtqlwTH+SGGMYQD0id3dmE/T7Men7J+JBNdAunwrw74/gjmLN7a/ofaSAxiDS+zTV0+ApeK+BkMoBqdEOAZawWkxa7FRy/tvBQjAaB+8nUkdJXO12rggvcdHPuhEVSTH0enYQSXgwUeZ6bTpYXMET9tVyJJeCleqNfe84YWEmWesXIFbocLAP+D/ATJGLPbiDqF05tgM2NvWrjcK8XEDVgNIKMQpfAndVggpQPRNCoGVJLWLQbdAkvLj3j0PfVRRQ8/xMWkvDYUxMWvyMW8l8RYFZARwwhBoQtI5c4AA7EZFkaKU2zR29ffoKSIbxVqHSeO+MEr3zAmfIbJ032R11cYF86MwflGljBEJiyRIOvFHpnWUtUompBRY7xj+GzWS2O7jUpQ+wrr3j3bcUJmILVS7lLbU/EbpXsTfNQyVT4qSgRwJ2DVmvzRPM4n78
 2yBLT2E8
 HSGSH+huJ9Iq/gLt3eNBp15C6p7wdNWIc7+EW9az4G7QUgTLhWUo9rI+rkOWhTQ/QNlyEy1Ih7iUJ5f1QJWTKMrwWfcZPeWRcV9ITEQexpvk0jvRZ3T6rgCaltw/EbznN4B/nUF7+DB6aSdHaBcWNbxPRmR8ijE9Q0vgS9M0quHLKb8And49eluN9q+shr0MWGfPyaXA9f2SZWtGEK4BecB27FzXhN+saVqLQ75eKqNGQoH1tTYW/G6s0l2TXvMHTxlDy9z+RQltCyOGx99v/HjQutMeJPFWwWLymSXzCYIOJEb30xJ6zS8VY/olj12fen6oYoh/XrLOsC7VMHehnBX2d/OBJFycEbAtGJG9DtFoeZ5Kc/PhXBlO3ubFs0UbLvtgxyjYP7xuzy3gAsukbMlfyfy4W7IXDSdwp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LUO gets the restored FDT address from KHO and maps it with phys_to_virt().

Check the FDT size and make sure the address range is KHO-preserved before
mapping it. Reject empty or oversized FDT metadata.

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 803f51c84275..633a16434164 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -82,6 +82,7 @@ early_param("liveupdate", early_liveupdate_param);
 
 static int __init luo_early_startup(void)
 {
+	size_t fdt_size;
 	phys_addr_t fdt_phys;
 	int err, ln_size;
 	const void *ptr;
@@ -94,7 +95,8 @@ static int __init luo_early_startup(void)
 	}
 
 	/* Retrieve LUO subtree, and verify its format. */
-	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
+	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys,
+				   &fdt_size);
 	if (err) {
 		if (err != -ENOENT) {
 			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
@@ -105,6 +107,12 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
+	if (!fdt_size || fdt_size > LUO_FDT_SIZE ||
+	    !kho_is_preserved(fdt_phys, DIV_ROUND_UP(fdt_size, PAGE_SIZE))) {
+		pr_err("Invalid LUO FDT from KHO\n");
+		return -EINVAL;
+	}
+
 	luo_global.fdt_in = phys_to_virt(fdt_phys);
 	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
 					LUO_FDT_COMPATIBLE);
-- 
2.53.0


