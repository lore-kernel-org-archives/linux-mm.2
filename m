Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26005CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65E1900145; Thu, 14 Aug 2025 07:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15C3900121; Thu, 14 Aug 2025 07:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0573900145; Thu, 14 Aug 2025 07:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 857EB900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D8D61A0635
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:32 +0000 (UTC)
X-FDA: 83775167784.15.B3E2AF6
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F50A180005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d6aPRkwW;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayvZ5dUHZHYBnN7fiC5x+TgX4Nps+9054dmh9GXnXkE=;
	b=O3DW7IWiEKu0e4aOveeYS9f9UouAfO9CVcVIYO1/iCUs8vW1gxybd5sRY516TE/q0UbTdN
	Va44V+egLwQ21R07KVY2rjRm9Yt+Yu3PnJZs76KyQi1y0VG8pxUAf/4b4VtIDa9RW0S6/7
	oz3JyqSWZTyX3myVSKC0qG7sQGesxfg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d6aPRkwW;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171570; a=rsa-sha256;
	cv=none;
	b=PGTI1ElrTocuxxsxIX8GgfGtsdZg0riL9MR9FuNLrZPF0rajL2vNDFmeP+hE3A73wdwlND
	d2EKAQK3u0LAc170NGun+PGzQj4GN2RFmt/42TN9z5yjodEX/JvsFomfsh7xyQNuoFCm3M
	IzvgbWPqzOodNC6e0YFjFFqjYXbwZ1U=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4717390ad7so490765a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171569; x=1755776369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayvZ5dUHZHYBnN7fiC5x+TgX4Nps+9054dmh9GXnXkE=;
        b=d6aPRkwWa+KN62LGO95XXzJjUm1Ypb77a4B9XBRvK/DXrs/UAjTrH6SWFnx62xTKnR
         kI8o6QEfi7+QFM+G3RxqxI2IymdqlW/u1BdcV8bYI8VcrkJFXYG68cgrrVljZzBJhFsf
         /bptZTre9G2Qk7PCvQZISH/gN1/7Ix3714Bi6GK8jH9AC6iUrd03MhiLrdRh9AvX8mvY
         AWjPiOPtCwDHwSWA9jSQb8YMdbahjMpkvqZzFenYqdW6wz1mM9FHFE0wxK8qIKcAWvIs
         AFMwQ9bBld+FdBmFbhwceLF52auUcDey+f3vORek4+6Kx9JY9ybvT5zSNvOkWKaXUQyS
         I+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171569; x=1755776369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayvZ5dUHZHYBnN7fiC5x+TgX4Nps+9054dmh9GXnXkE=;
        b=F5jUkcOxDkCZ8DK4936u3caCktZekhE3G/qNSJIR+s1v9Il8j4AEqf6LyYawRqWIbH
         2Qzj8JE4fuRDOFctDi5KYF8XYu9HouRU81RH0SaKfUyyI+69QeQOBJ1Isfi5rVnrulTw
         XxduRB4FUnpV/zsl9Mq01QMOdvjp5RpbD+r1X0dK1RZMW0n7POBwmZc2IKEVUmsHlcSo
         ZhlDp1CSLNYEeEt8NiOJ+i9vgY9C3D0qaAVYBNgPDbrgKKZls7BGoqPIadqjLlaK7Ly4
         AAOIMah5iu48tdgrr3ndMDeDElx4UOJeqeMt8AhjDAgNa2kwQ8ISgeDgEyF1rpZenXR2
         dpTQ==
X-Gm-Message-State: AOJu0YwBvw341czsGtUL1+kN2KRFO/86TrPTFHiS/kLnZngls8z81PuF
	NnSK7tbl9Y7GerqrwcO6GLTkahNky4iuvC66sIE+//8jYYPO9Uxatjuw
X-Gm-Gg: ASbGncuWO05DU4HJMBEU+IeXLGJqj76+Y6VbLYR1R+s5kJCrc3RQ5+0hho/TIzpd5WN
	QB8hT1PxAqACJzEh1SmL64eBg6NMYgJdGVZ2YFsNwj2NzPTkCocDuML2iMoZhJovFpFqGwNXi0u
	J4jTOksejvOd2cDtqMQUcxd+o31Cox6P+ktwTlDedgEIq3DYSnL60/r2ZqGNg89Z8mH4siFjoo3
	x5BRCBZ9Y7QQ1xz+nGHrDdU8CrZX4RPFBOUPfhxPMajK9UlrFlIqkJwkjrgI1uZoB2TIvOid1r2
	520KWADC/vsG8/o0lVTXdmDWWU3bQOzSNdyBnK0pGy6Xi+834Hi9inhVMxTiCbeij7I1Infe6PI
	IEuuWLfXoPnuZHoQm3wDLO3CpWSw=
X-Google-Smtp-Source: AGHT+IHSfvOxfw5DmKMaEy/JlDJCB3mLagTa7aiA6fiEDBi1eueH8dmGjxi20xp7/4FJKBEhhJWvaA==
X-Received: by 2002:a17:902:f711:b0:235:779:edf0 with SMTP id d9443c01a7336-244586dc54cmr34641645ad.50.1755171569348;
        Thu, 14 Aug 2025 04:39:29 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:28 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 2/7] mm: memory: add ptep_clear_flush_range function
Date: Thu, 14 Aug 2025 19:38:08 +0800
Message-ID: <20250814113813.4533-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F50A180005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s4iipd5zuntdoxi8txyxfjjpnng6fj9i
X-HE-Tag: 1755171570-993956
X-HE-Meta: U2FsdGVkX1/dIIejLTiLlMPGoHWbjuCfxAdJartlk2G8roygmuytK+3QqFrvqUtIjhCWMElUP928roqGVRobzdRs0vx9Kj2Z1KCn+UpsH0BTNaA1J3MSyQwOme7g7JCpFdoZzG99q2Muz1yFf6WAQqQapwAv+KFzLFu2FsA+2GQp/S/pRyvLDWzfn97eVJvLh7WmYay7WotBECJJW+usKeaKiG7bIOGW73XehmLFKIso6IR0KgRj9cDVEAJYS9D0ZYarYjSYk8VGMnF3GMke+qV1Fo7u/qtAJLd95dEJiiT7mN6JWlG+6XMUy+tl0etc2r4sCSEfx7mhxVmEVYAkNCh9GDmqTUoce5dvXEi52IgdhP2ohZCVJQ3/Vts4rQxTK+KuaI5UudEh4rxHGFuhysEoVhnLfcfxD+J2AkTCxK98r4kZxBDMl70hU53b9XMITvF5lUqU3ccUOktLQCtYwCH7ycwXJ/jPcBkr9RLhnmoiw5k0NSebdYDdoAasbAc+j9Zn4Gy/nQ7GKMPfcslzrgurl2meqLl1OQ5SDLPxMTGB4rp5O0gMoAgJtAxXG0F9Bgwg7itzrZ10xw4yLEQqIDY/+zyD4qxyQLM3eegD0xx6gsZjlWVk+2pCx0bnU9ThrRWgPIYKyW5gSQ6EL4UzoJD+OwoMDcl7IlmVKJ/YEMfBrZtSgZDLcuBx54EIq0LV8XgOQCCsO862PRSNFlNaqLb5uzcOjUhsqp21Kk1I15NU0sHBS57H9Ftf1HUGxv/G/wBcTJXngKL0ZdahN3hobRRGmZhPf7Ni8oXU5Z8PtWdbFNjUY++nqxMqiuKVXw6wql25TF64hagwzvyc+oaTH63/hR1cxgvtRjMA+0alkmLZfbRm60jRq4ECZpQOihC2P+KZ2YYZ81OpAWugjtADE2aZ7rdkdm2LxdN5d+cajNa7UpN84/Hl5Z7T3ajeKTERz2xS4wjALqsqLnM3M/4
 sSlYolRW
 HGNKsuHTcVVO2C71EtPypN6ahwYLUuZn4xHYGJMRp14gVkHKQJrdBLUqftp8/MqQvA2aijy+A0p4adJOtxE7MeMwWcTIZtpy+LjAbNLIHmPxth3BzHGrfpJ5COTqF3nIPHlg8o9eoC6aFnAwEzLTlUYggOt8G2UaUAoIO/kE0zeutABwJnK3MIW2FMWxMg4PPWStN8OBlScSu3HHBoqGyIiGbe5o1BKVPj4PF4eBxewDHbJ4hA9tzK8X00KofVQxK7sT9Eb0Gjg99/OLiFGYpk0O6K32v+USerVRPe4noZucmYQHjsi6qYCoI8SYg1Fq8SJj4FAfRS3u2CgCjvzbB4OUtgOxeijSCH0kYFocmQ6aSoMa9v/eFwc6ohppGZIa6l8/BJMgkgjOamB/m1RoZDLQ2ydVP4SxSM0LZXXyvgSea+Becpn+pDZP96BLvZjOymlGg/KUufndBUSS9gIMSf62uwWPDSBW89NeZcTnP4bskFrJ5UPpq3Gf9xFtcsdR/7STgcq/lQFB8Y4oFmsMXXc8n9LlP+4q468SLyedLWZgn4KDb6lUfWc0cHih9jpm25bMe1Ve1ALrPeCvkwlhxUcifT1jtFtT+T0jXewcgE3ADy2vqt0Ny3NiRvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for wp to support mthp, add the ptep_clear_flush_range()
function to clear and flush TLB for PTE in the specified range.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/pgtable.h |  3 +++
 mm/memory.c             |  2 +-
 mm/pgtable-generic.c    | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 0b6e1f781d86..1ccddcd0098f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -826,6 +826,9 @@ static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
 			      unsigned long address,
 			      pte_t *ptep);
+extern void ptep_clear_flush_range(struct vm_area_struct *vma,
+				   unsigned long address,
+				   pte_t *ptep, unsigned int nr);
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
diff --git a/mm/memory.c b/mm/memory.c
index a6bc1db22387..90cbed5ad150 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3632,7 +3632,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		 * that left a window where the new PTE could be loaded into
 		 * some TLBs while the old PTE remains in others.
 		 */
-		ptep_clear_flush(vma, vmf->address, vmf->pte);
+		ptep_clear_flush_range(vma, vmf->address, vmf->pte, 1);
 		folio_add_new_anon_rmap(new_folio, vma, vmf->address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(new_folio, vma);
 		BUG_ON(unshare && pte_write(entry));
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 5a882f2b10f9..cdffec4f54d9 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -101,6 +101,26 @@ pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 		flush_tlb_page(vma, address);
 	return pte;
 }
+
+void ptep_clear_flush_range(struct vm_area_struct *vma, unsigned long address,
+			    pte_t *ptep, unsigned int nr)
+{
+	struct mm_struct *mm = (vma)->vm_mm;
+	bool accessible = false;
+	pte_t pte;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		pte = ptep_get_and_clear(mm, address + i * PAGE_SIZE, ptep + i);
+		if (!accessible && pte_accessible(mm, pte))
+			accessible = true;
+	}
+
+	if (accessible) {
+		flush_tlb_mm_range(vma->vm_mm, address, address + nr * PAGE_SIZE,
+				   PAGE_SHIFT, false);
+	}
+}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.50.1


