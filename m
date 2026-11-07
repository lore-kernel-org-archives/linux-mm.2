Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89579606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FpuHV36v
Received: by kanga.kvack.org (Postfix)
	id AEAF36B05B9; Sat,  7 Nov 2026 08:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2A36B05BA; Sat,  7 Nov 2026 08:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B08B6B05BB; Sat,  7 Nov 2026 08:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAAA6B05B9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A53CC0348
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:44 +0000 (UTC)
X-FDA: 85408458408.26.B7FBB8A
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32034A0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FpuHV36v;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juq+pi4pblAMzdsctIP8tsm6etRIcSlR/IjeGEKfwmM=;
	b=ozcDrVJjCQVrTtIM/0XUMpxl57Q+o4vf9zooKTHtPPIY6YMeRq/j2KNM8KTux5KAPFPvyk
	omXSeXcSyQ9MK2poFEukXKzZjLenYsCfE/c5nch8jmA5++4JsDhC1lpGGnQ3Fdcfj++6uL
	vGUks9rDmhW9yPRhmDZzPQciZGk5vjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059442;
	b=ksHrcZfoYZNphJ3sEjJOpKCyPeJ0K8gXz19VU0HAdEw5j9ynSlQRk0ANc9qGfeamJtDWzy
	mI8H3825u9BORkmQS82XGJoiXfCrXaqEOgBYirziUcROeo7ewkt4E7Vaba9FhxZJ12juqz
	J8PDo9bkcRZ10nnHktA+sHE/KJr010o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FpuHV36v;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3704d30b84fso1210871eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059441; x=1794664241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=juq+pi4pblAMzdsctIP8tsm6etRIcSlR/IjeGEKfwmM=;
        b=FpuHV36vMnwLHwK+usekXhOaM9wxCMAhZgiCJlyHoE6HJchnuCbd8s0C8MO2mfPmVs
         98OtLwm/tDuCuBu4DeKHRICtUnPSQ+BGXBb4RJkFjZtSaL0s+xVVrwEo+7vHcdLTi90M
         jUtidCLkO7arTcvCeMyiteBKz7MTcP5jHl6CcFbq4HrFbEcynbWP5PUNBr0i8WjpCjRQ
         Fc7q0+nYGZTVQ9LOP/FMur2y/nV6OIy+3hT6HLTdX6vOO3vqUhwuGNa9Q5ApNaH02DsM
         JRnhJpgIHUOjjG5TZBYFPepqNwLI46w1kg1jnb1LD2yyp64U7KpRQLC36nelJkVS7rlZ
         FYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059441; x=1794664241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=juq+pi4pblAMzdsctIP8tsm6etRIcSlR/IjeGEKfwmM=;
        b=0rsXnBHILuKZQ2qO62kiZyceI8Thn9+EufUgdHoUjHq6fUw8Om/YJVUasstZS1gOxZ
         FXRHG4Toii6yVkTAoqWDVj75P/XPnTvioVTqsdYnhr88iXIfHJr+sVpvekJAs4k12joT
         j5gMvChM24hNUZX3aUKqf7rPX5TlIrYIngZ/LxSbyREcL2i4TnpA+HhQy1GhewpMHcFC
         GrVinFCPveHX2vPsy5bqI4+aGRDlevm1/CiOcUD5r1Z4tQQv3Oc39tuhJ3JvomKqhyI2
         luykOgmO7vMD1REz3U6NSSaO/kgrucxOqzXUPWsbFGhfjBaNmQIN8L12IVmQ74Lm8LLB
         Wv3A==
X-Forwarded-Encrypted: i=1; AL+hErHHsgcWMTveibWXvQYpWipbf0Eddr8ddUWNek+NL41RAFk33qRco4x1fFnFQ/Dc0aPz0kw3ADxc0g==@kvack.org
X-Gm-Message-State: APuU4Z+kvI0oOI1ma3rH17SX9VXI5GwY1K/wrgaf6teoiuDZkQLaE1Ix
	uFhAzpdSwogj17k0b0pHyPolGzu1ZOZ/t4MFyvmOSgZLJcJU93+7tNbd
X-Gm-Gg: AYBFou14u4VV31zGl8TfFqhRUQPbC8lkgfnilUBFsZvzeoUWakiTS4T/UFKWvKyIPfe
	dqqE7eRzWYUZdlc4PWMA9dFd0ciiJpCSEz2yvrBV5pe/JNM1ekWeovlOz8Doq1Et7RNCHYH1s62
	LZ4pZkhsDDAz0QcUijrTmpCj8HJE0xCGfqLCuIP3ga9NJMnZ0ESChZB5az5PK7zgtLuO+6MJupK
	qphETClF4ls3t/SSHQcxxf0g/J/rc4bTVgTT8ZPbExJSMy2XTTYA6Tzga4foD9tIYwc8Er1bQvC
	ZH3jCnl7+ssPbrSkVWs5D1xEjPmz46hDkirxOvc+HEiapg55sl/KIQ1WyP9bx5IHrzYN+xlcQM3
	etWGdKtq39onUQCUPdXsor62Y2sTo77PVaP48votG7HIRW1cp4bIiST8Xlc2YDuZAhRVyi2UZa8
	8ZY0S+SFjwQInkYXgvHpS0TaDOhAwUaeAjt3rRqMlhGb9F+gQyEIKyMbwyVJCQ2IGD7lWEm4RFf
	i6bRmmFxcJpKKPmmJFLfPZv9xfX/KriNQANnMMRukmrbNUJjuxuyl8bJbeGxtMXfCjKV9KIaovK
	8FjBLBXmeuq1toWIBSXWTO0Ayxj17visakzMsDPxLwKPZtSLzdnlYIFOwg==
X-Received: by 2002:a05:7301:fc02:b0:36a:1788:3d1c with SMTP id 5a478bee46e88-36f761249e4mr8433809eec.34.1794059440743;
        Sat, 07 Nov 2026 05:50:40 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:40 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 06/10] mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Sat,  7 Nov 2026 21:49:49 +0800
Message-Id: <20261107134953.748622-7-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: od7wmumdupz4wqriwwuy9p55ex7g39yp
X-Rspamd-Queue-Id: 32034A0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794059442-648998
X-HE-Meta: U2FsdGVkX1+G1kdUjBOLeWOX863funtwJTaSEDgEmiydWiQkS6HmBgCD9dnpJcjZ9tzB4t0uSkghOh18rxMpisKS0B772VbtjQqWhC510KB0MJN9wVj35EY+ZdLy3EfbFDorbx8DJN0XoZEEqNno3tlgobnaTC6uskpOQWlwZ4yNPGBySE28wIWt+ZVMET2Zl5tNyU+wD9YZA2XE9Skd1e2xKrxw/z/cPTg0S5+wDenux7niSeWpYbmdSOsS+HOsAG9dW7bzmRwLjf2FigTXwgxq0sORnt1EWKmGfw0FcYETWKZqrEw65j4lFaw8QWLhFkYWmVcPKaDryyeQjPUSf3VD9167yUaLPsU2HRuBF+t7hoigFjPchlX/7Ew80nYo9srkH4Kk96px0UVzqE7UaQGkjbZGZinzg/9tz9eKjK88DDGHS977A4Fyc5Op3g/D3XnFxvUDZeb0lwmUc7Zk6juG2aYdNNWSYrJk+deNPX7A4ESjpWst5IsO1lVZQkhOzlPtE4/4y3hZ3ChODsdUhqVV036e2wTSKV+vjAm6U+3hLkSNNKHxmEMmJRjSzzRoPSCGt2VPlct5ul72xfnrbL9vq/pzZt+DNbTjt5ygzpi5/8Ejh6meKYx28Ae1kuDLZdmwIAxROfcQs3pSQqCxhawOVhIvf+JfztfCHjryZx5kbz4mNrPSCYLn0eopVp8d9ev049bEFO+cdFuxNI33N4pf0vzY6EdhxA12WyfmoTkNWhtGqc0hV6aqZ8UqDPU5snduKoPzc6Fw6M3mRpSpWhNw1S53DgmgifptJXN+ySZyTEf/cHdsX97bcKs8uwOem73Tq/mw35ouwI8OFwmL3aH88HTFB9q3gwwrWnLNPO3rzKpxNPcVa/wxL8n668xjQ8xmXgMj569XJBkZBsTsyrsZKkicEpunEqpNOCeVzeSg2/D4PtpeWYOZG3cZbCD86k3ogOpKmxHALfCmJn+
 +HdU+d7O
 PvPfm4A3Ps3JNR2+8ngsPwJAMLblsdOTWWWAKyB12IWj18PgzDubgR16zeGUd74QiCO4yw4b55XELOLWyPgbNZngL71+f1Cgtew7rN9/oMfMnKGtixfUGjrZXQkL2osEUL7r4hbM+uwoqgOUhbGdk+v3jHrsmkcs82noBIf0AjsPtRlaVH5CcjKpLNDI3Zmqc4Ze7BVRdWxoJg+UIw1i0sP7E6JRzNUqk7hrsSF/W4k/UkxIXL7vGOPFuyhyWpf4SWRwDb4M0BjSurkF0QK6xxnGpiP8ajxwnrcdKsKM8vwpzC8D1A9ZetGmiLVzp3aFEmrMStt52eIWeH3Pe7ZrDAa1N+PzNTbvi3cXZskqfN8DsUuboixMRrB1mtZ8JcHjTdAjj70LUICH2RK10myLteLIPEHjZRSDWSWrFIOZsmGXqKhgPPfGr3EFWcqLiTmS6nVBWDq3Yl3ucHy9QvJNuEKU5ixWaOqLFCAmcDp47/lmM1b/VyqSoeRmo37aiEGob8LJgv0+DkqDfScJzyKQxfVWQlXPpPxc5tUNHVN7nKSqD4zJu+mBVrhFMFBogv1lWuDvoxiNeTvO/IPa1ks2DiexPGCh9ju9qacveESZ1QBMslbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index df37c8490ae7e..e3ea9581e68d0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -92,6 +92,29 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		vmap_pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
+		return size;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	u64 pfn;
 	struct page *page;
 	unsigned long size;
+	unsigned int nr_pages;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			vmap_pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


