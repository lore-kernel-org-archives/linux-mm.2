Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E05B606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bh8bBD7a
Received: by kanga.kvack.org (Postfix)
	id DB8C66B026C; Wed, 21 Oct 2026 17:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BD16B026E; Wed, 21 Oct 2026 17:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC606B0270; Wed, 21 Oct 2026 17:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90FE76B026C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:11:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19D7A1C3F47
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:16 +0000 (UTC)
X-FDA: 85347878952.23.6BD8241
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D52FA0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bh8bBD7a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792617074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ye8qF9ArKGBdPFIMK4xZwrbqVNgRvHSV8RgsR2NKKBQ=;
	b=lhqhvRYSkJF9YX7sHpwXNbunYI5Jtn0aVuYjINKNsFdE6uD9kDZhgbdHDlD2yaN/hwelpE
	+E022UrsDid6hOf25KVWnwn1JsOKusV2Pg6Lk1Sy8DDjpp4JIPaKninSXHPQItG2ng10N1
	14H06V6SKZjR1vI4xKP9885UxBB/Srs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bh8bBD7a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792617074;
	b=GhbzBhOCsw66njEE5HLB/7J5ReGJTmP/torNZSHYiWqA5f2oPxCb5KM1QxNljPsUxIFHvu
	xlw++SZ8GuonY0j+KGiw2gnNyL9tsLGXLtjO0A2gx+zBo6Bh4cWUo5yzcjPTENdC+p+lyM
	Wad1z4G1j+kC2fRkoeWhwa9z4FQO8vk=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1e477fe16so7018525e9.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792617073; x=1793221873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ye8qF9ArKGBdPFIMK4xZwrbqVNgRvHSV8RgsR2NKKBQ=;
        b=bh8bBD7aMafAFpKENPI/vouef4578yHZxjoR0ChcXqRkMBBvlQTtDoy06JKIRDjHcd
         gtCSPKC+pLOFdeBNr6/gtjdj3/Brv858gAHdqgnMZJly+Av29bU8RRNfjyuFQUq2Gnvl
         Jb/Ln5/2pkfGBrJxMdvPZSJD4DQ/L6T9GJXu2/VGGlRifjNL6wldlE2cGo+Gk91V2/+4
         b+gQyWBSozDvG1eA11E7DI51QFh//iKhW0xNJgFXUstyCCBKd0zp16smSKoKjdNCBKIN
         kKmPgm3zThBTbD28akCkQqc4fzMsLe7xB5Drw4sOaQrfVk/P6pzDo7q7JhGN/+/jXgV6
         dSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617073; x=1793221873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ye8qF9ArKGBdPFIMK4xZwrbqVNgRvHSV8RgsR2NKKBQ=;
        b=DWressKdE/ywosz1b9TDGYfcNrHbwQzQZY88dXF0ZyTya/yDC6ui51PfRGaMGAHYGf
         heVMMA0c5hd/zrj71AOA1z84ZPHbjMpxwM67KyqZVYupoxieND+xgm+/vPfpC0NyKwhj
         uYRRmQz21n5ceMEqQcnTawOTuat6Sf3eRmHBVQUTjjdmxCBi8wJksao8u6w+qy11BKMV
         K8i0vfUIrUsTYN5WgtNMr2JODAyG+4O0xC5rtHb8pkw2JcHp89zOxJutyQYBO8A/lEtP
         xw+K87N9Krxob917XmAp78DU6KuEZku4S3Y2ZfBbNruendgV4GZreJfFhh06mhhQ2KzI
         gz9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwQCMubKpnall7+OtFRkaW9MGrOO/b+6LpzTLH0esYF6L0sA35hdxlaSQysA3UWNN5nTeeqcCITlA==@kvack.org
X-Gm-Message-State: AFq9FYKwHZoSWqJ4C1IlNxXUPSMGaABR7AD1bUPGGLodSCwNA+421bVb
	Sfl+G9n7te74LmsUkGsfmi6uTBOOF/S083xkokmRC1Swny5YImXJCiUs
X-Gm-Gg: AYBFou3nofpZ3uaNRiKvHV/TkSODPbzgZwvNdPaR0jMC+T8LG0d91V1uZ36AKbB2f7W
	fjJ6J9gClmuDXEiw2U1W5MkNl7Q55ra2UB6CozeMYiznMx1Yz1Or2JLYjlnG8MTL+Gmg5c5bkNk
	11viESBh1Eztr/x8wS1RRGSq2UMRPaBiIKNgSNRASrD1HK2KvsOJoEj5Ocv1UCtS2IUfwiCJA48
	sAFCADV/+2a5Loaazgj483VFlKRkG/nqO17PP6ZvmZPIq9ejjkvPRzbsduTZdeKmjJF0v6t2+EW
	c6/CmusHm2YgZktE0FIUJAfdzvq3XEUTT3ll2Vp+mhCG77kFBUSwRa86JSQvgArJztor181QGVe
	bcJ3xFiWSUZ3ZTce7vPATzlhIxRQLAzZ2E4fMsMY79xs5jvSCODtPNFjYqPOgV04X0nq9t4qQvw
	QwAOT8xQTbAMKlBS9CSyFHOCHfB1k12nmX02YWxHgRP03TlU/NUOQuT7ukE9GRAktB/g3cD4JRp
	tIbN13HKNc52JDvFVYx2dEsUGPDjzqj6O6acm+z
X-Received: by 2002:a05:600c:1d0f:b0:4a1:fbd5:26b0 with SMTP id 5b1f17b1804b1-4a1fdd15af8mr71632955e9.12.1792617072910;
        Wed, 21 Oct 2026 14:11:12 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a25fb5sm22891525e9.6.2026.10.21.14.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 14:11:12 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 2/2] memblock: don't allocate reserve_mem regions from KHO bootmem
Date: Wed, 21 Oct 2026 23:10:46 +0200
Message-ID: <20261021211058.83483-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021211058.83483-1-azpijr@gmail.com>
References: <20261021211058.83483-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D52FA0007
X-Stat-Signature: de81py7oyxiyxkeaire817s3cmyypd1y
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792617074-742949
X-HE-Meta: U2FsdGVkX19xTwxVJE2s11pYWlCb8hCp9+fDsmiKw/ov3Xe/DTGezwKGm3qwr/YdanTSHiaGYe0swm+HrhQ1RbJ3LJgWfhcvhOdqSFuVvsDrz60hcJx6VTPugraYwJWGV64Cv+TOty6p4A4szNdjcaWaS0UGU1+BF6x7mSxnNd0qGYhylpQBKiMdSdg5cR1YwvhEDY3C+DJMS9oaGW/tkqeH47JIVLqKePh6igT+la251kRv98+ODhCBveTd1mlWgP3kOoebJHaVd3COLyb3lEmtg9EKhDRzXVwIva6wYCD9pV8WLKF9b/6lndNO1BK94iL+gqRvu1vxuP4de1RA0y+Xp0vWdLaYxVH1lhrr3tsDTIgfo6JzEBhy+TsIeixZnCwcdkzh7HESCRRJ4yHhaiuYZm2sY90EcT8U2qiAns5CyRNJ2/SW8JGdZqrs84/38tiWQ2nh20OrV/C/xbRshcIb21B717pwmx+xS8j+SBkBwXnqLXTonuAFqnT/eamIkZ/tklDvaEtEjPU0DKGe2ChcBw28Lp2WrKodT39n45dNvgQMBSpsAY57oZ94FrBfBKZ+W2XZsHLjNq0Rp2H6Vb10BmplxJjDeXyrdmOE9Bf4246Fxo8YicsLt75j9wAEj19rDbfBeOq81vJ6lwGTidkjkui1x0LjuWJGZ3UkaennZRjTo0bXZVhPCQFLfSP0f/EucLlrCx00DEig7p07YtR4Y176XUB88ohg7x7tPQEJd/KDUt7htyw/nuh0Jt4akake8ZXAiE2JnnAAQFbtX8L6QQ6wRbPJ7lvF3pGHfQrIq609UYwr/m9HOXrBO7q+6MqSeRPCakTIKgBXcWiqtDLmK6CG4892Fb+/TNY5UJBnKpU9qoIpGcupTRggWd4SaQDfCIkXAUYZjinqbk6Dx6IBJy7HI35OcASUaGqay1KMbkWKUHT3pCGAh4J9p2iEsYlpbALDIVbzxG2O9Ox
 XUFDU9XG
 jGHf+x0aGDNIHsnPP78kOyX3BWGlTWixR+6+03lXFD3TWngkVcrt+PYnCIOPV4E9QL9BE2TAeBsGdvPMX22nY17zzXUgW0QdVcynCrBDLXJuaQqM9m/6miclw3dpcErbhIg3M2fo3a8G44nBd+rZnyv6UsLjG8cZAc501cKKTb5b56i3H8ZgOtmLEZ67JnBL+UMpGs6f2h0HRpjPtefXHdO0XuGyRw8I86ih8gMIkjKUq8GLMUuJcOeomyWtzHXbJTvhH1J8nT9vkfId4IFIdYXPjy+TA1A62qe0lcokZgrLbFmnjZYjpPEGJs8HsKHPBgajEPxUpgTe8sUtanMIoSzz20fAsC/H0c0Zc2PLUhVPEPaI+R/Pf6PlIxF6s+zHLKTNITkaGBfI66x3GinTSyc7oSLf406LsKnQ8v1f15q4uS9WuS538eRDlvX5PRkr5pEPzEh6gLVImsX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a KHO boot, a reserve_mem region that can't be revived is allocated
from KHO_NOPRSRV memory, which includes the bootmem the next kernel
boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
then fails:

  WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
  failed to prepare memblock FDT for KHO: -22

Without it, the next kernel puts its memmap on top of the region and
the ramoops records in it are lost.

Use the search that keeps HugeTLB pages out of bootmem, and keep the
mirrored memory fallback of memblock_phys_alloc().

Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/memblock.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f43659688681..0fa9d6529285 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2761,6 +2761,33 @@ static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
 }
 #endif /* CONFIG_KEXEC_HANDOVER */
 
+/*
+ * The region gets preserved with KHO, so it can't be in KHO bootmem. On a KHO
+ * boot only KHO_NOPRSRV memory is used at this point, and that is more than
+ * just bootmem.
+ */
+static phys_addr_t __init reserve_mem_alloc(phys_addr_t size, phys_addr_t align)
+{
+	enum memblock_flags flags = choose_memblock_flags();
+	phys_addr_t start;
+
+	start = memblock_find_outside_kho_bootmem(size, align, NUMA_NO_NODE,
+						  flags);
+	if (!start && (flags & MEMBLOCK_MIRROR)) {
+		pr_warn("Could not allocate %pap bytes of mirrored memory\n",
+			&size);
+		start = memblock_find_outside_kho_bootmem(size, align,
+							  NUMA_NO_NODE,
+							  flags & ~MEMBLOCK_MIRROR);
+	}
+
+	if (!start || memblock_reserve_kern(start, size))
+		return 0;
+
+	memblock_prep_allocation(start, size, true);
+	return start;
+}
+
 /*
  * Parse reserve_mem=nn:align:name
  */
@@ -2829,8 +2856,7 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
-	start = memblock_phys_alloc(size, align);
+	start = reserve_mem_alloc(size, align);
 	if (!start) {
 		pr_err("reserve_mem: memblock allocation failed\n");
 		return -ENOMEM;
-- 
2.55.0


