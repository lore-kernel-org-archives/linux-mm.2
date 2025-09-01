Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0969DCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FBB8E0006; Mon,  1 Sep 2025 16:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620108E0008; Mon,  1 Sep 2025 16:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D608E0006; Mon,  1 Sep 2025 16:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 422ED8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2A11862EB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:32 +0000 (UTC)
X-FDA: 83841874704.28.C059372
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0972C1C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Dp/kcQz6";
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tn78QatM6psXy56nBwVEP8sZrX8rAS66Lkst08QtRU=;
	b=ke4B1mdKWdtqmXhnMH7Tv1Q3n6GJBk5zew2zj91yicPXKgmsF1Rck8yw3lP0Saz53AbOaY
	OT7D9a5ynRzQjuhGmvHhJVrEfKocW/bzy62VWLTBBjbsrwpRQhPI16gPkHs6Q8+CZVKTX+
	FlEcuzqRC3N0Y/EnW5sJ5k9hacsbTPM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Dp/kcQz6";
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759831; a=rsa-sha256;
	cv=none;
	b=E+Yju03tvH59Xafx5jlEL2gdvv2XjDS+D+/w3S/Ocyj4vS/c4jY4GQllLe+2gDskRnWcCh
	hbU7f8D1QkPT+UctYcja8h0rXfCc1enHn8jJpPnf8uN8ETjOA1GKdkFRTbKxBjQ58iPf9f
	bBnil5MbJbS7tCMXct9sbyo8bxSdFbg=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7322da8so918599566b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759829; x=1757364629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1tn78QatM6psXy56nBwVEP8sZrX8rAS66Lkst08QtRU=;
        b=Dp/kcQz6XCkkv+BEx/1yuBK0VGWf8cwLWunAtluDlUbyjJkVrtKwYV4gnhQXtRt2P3
         R3DhIONURr/cGvx05y5cq6dLfe/Q7VF5TQJ7duq7PvTB3uqBNRKLlNoUUd9KaW0+/YEg
         D41RuJ63RM08RErtx/hgS3za6HujxEpaOBCqLAOGKw/hdEPN08vO82vJ8yWrMHOp6OAt
         f8pkHgCHUtrfHISkQMENBYgqm0RO/qQWBKRGd3T+r1+xVEJjCCPs2OVKVCu91bjBmR4m
         zYEdipAQTTKxuDwULye3jeUp0W3pnlAKHJtuaa2dEVL419ExJqRLNCY0lxVdbwNPh6g3
         9AXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759829; x=1757364629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tn78QatM6psXy56nBwVEP8sZrX8rAS66Lkst08QtRU=;
        b=jAPj7/gnVNndmojCRMujTNRABRL1dIWjarspSNt3SDXwzetOdu/nzLVE/OpjvZBTMz
         5PsSqlMZ1uQRwAVFjCjZzxk2DnioIxMKGeYY1rhgJ4bNRIW3py/2rL5KaCHO7BRHqsYq
         gGZl4Bw3pPL/1jCVxrZSHDGm7cHXHydgl5WT4DJAMtIyl7NesGhjcnCVUbqCiwJgoEF/
         OIKQ/mmbU4WoyccscbGbwGQAa7eOwAoJJEKOItRuOtZuUZdaWggJi12qUNTQnLs/brhG
         0nFGBiYq1ffGqe3Fsg6m+dbG6hTriZGkvpqMfwjUww0T2ya8Me1iMWuRNeEEUJP2ZdAf
         ECqw==
X-Forwarded-Encrypted: i=1; AJvYcCWDeQtBmyOiRouTuo9b1DPSEZNKtE+q2yMNo370gP8HOORPAS08pkco8GIQTPsvlozvo529gL5DDg==@kvack.org
X-Gm-Message-State: AOJu0YxVAc7G/1S//Ky+GgGZaxc6AheYFhp745pZ+6NOJqj6Gdl4rJQ8
	MlwXbiNBGoOvI+BSnfYDCvNWNNvMJThTSrSDCVJgc08z5LC0RFsNvEII2FBG0ewOE28=
X-Gm-Gg: ASbGncs0xwql98R68aq+sDorBYOPj37YwM4wNmSisFdHcSERPNxK+VQXIMfLJZp4a0H
	UMjlBMXyQneCTKkGZrgOXSsvAL7nk2T1WAEgNyPzSmj4gQK48Ps57wYRj68b4Hp2QVaiRrYYCaJ
	NTIDMCWQ9iBBt4HyugwrxDX1s7OZy9O3qCgLZCa4BBaf5sfH28So7KP6C/oC+LDqtz5lGln20RH
	4dZEITdyR0M+sRJA56KGbv0HQe/5rffbQb8o1LLQUN1qTzorMJOJixQpTFZTEYJL2C7nPw1kmOL
	p8enars3ATCmFDCKgUqZaNeIkvovOiXD+pRKdDperZaL5xfgrOBc0ZNbRdiI0XHjfBKRG2XwRmD
	pUuRAXnL+N3zs6/zSiaeXCmuJavvjBkLRB72TefZKphie3ZKCleU+CTILgor16dQjH5D2PMjnGK
	eVJAdCJoO2C0fbI8JfgsZNfXR0TMfZKUn3
X-Google-Smtp-Source: AGHT+IF8f2IkqJ53snw7rUXbJM+rbFqtblA8YnCowS1e50uvKMXTh+/K+YqxtlkXHOf7uiwvUXJSGA==
X-Received: by 2002:a17:907:1c81:b0:aff:a36:e6e with SMTP id a640c23a62f3a-b01f20c705cmr970127566b.57.1756759829377;
        Mon, 01 Sep 2025 13:50:29 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:29 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 01/12] mm: constify shmem related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:10 +0200
Message-ID: <20250901205021.3573313-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pe7cuiafnbm47jd98a4rghpxjomq86ec
X-Rspam-User: 
X-Rspamd-Queue-Id: 0972C1C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756759830-593854
X-HE-Meta: U2FsdGVkX1+ir4MqzEJyXp3DwPSNixcmU2aWVVmD44htzJodbwHcYKAZfBCI1Xqoe0ZsRgRYj9O0vhU0vNFT75H/d0ouwrZ46IuVGrwbVlno+kn3tU9Y6FV4LiLPChC9tlWzemv9B5O2D8i65o2nL5V05FM1GDYe7aSqMzatPoCp4LB18J+Mh5kdxX5SoelmaYIjd3bxxlMqhcoRGJ2gfejWPmEC7uLXP/htV2VC6aqqTUrjsCko/3fnBclO3SN5nTh9JbLtfJVVd4DH01ze1pgRoRudkmqMyaCMhalDruVc2PU1rbhYMFPTp4GJBCYsCNvSVE0Uxu55Wk1XTFB5qG0sxqjf60yt3SjYkfFiCO3GbQz5LIFCdFUtzTG2wScE8z7OhsCTuQZu0bbu31lTL2JIFGhHZWkVLijfxn9qoxJP+d18xD+WLHkTwJ1YfHQwOtTsT/qReKqbEZY/Wo8qbiN0hrsCIzRUYQFQJop8tmEH2P7A2QM/eF3Ey2r4fyZqWn48x+Z4NEPazGtq/NG5tj+hR7DRM2p/XY1OIibhAN9LijMfOGy+O6TeD1ZcD6D4kmGzNGKi9wDenH9oljSL1ljJgpH5byGaibHfF+iX9o4z3jAvVBwwJHFh3URUrY4quXrc2yDl07GzF3J9BknE1p1TNsMj43CstIaokIxXntsq7puBs5od9tRs1vDtdezfC0A8ROtgBftBsCYLn/X5zlfQ88Cq1eBIK3D/lhl7BawmsH02ldKy0GIUHAUVb0dK6Auz05ZG7/+DzA0trcqRd8wZXM1Mloqe/ReF/IO/hADsdwLK2/1pR+Bq81inhQp90N11EHQ08mZVFtruktZQ1IwyhrrUwbzW/UHpkveg+5WhPkRQ7oMYf2RUYGYftAr4rAga3DQDiJDCgpcEsJHRNZw3d/ioFuvtL8jkgx8UQBLv8ZYqE8e9I/eNnNEocGd6CGFnccv9IJXOeiO02fx
 kxmmhJG5
 6Rgagpfn/LicKx2Wx1HkRM8ztgKiBPsiNX6h9+/6qB3k7C3AVyisDmgA0y7g+VguJ/QFMrpGXUmCLIRBwO93BiRtiEu4Oh6VlYhuV5YHqwYGPfcK2y39ScXAfS68Vddvqa5qkC+V/854y+OA+LHbNeSYZ/D0a38bGUGpi9bJwiG3llutkEXwM49ot6AWmSfB5NCwY9YfKqzdtiSgm8saodGc+Wd2xxSC98lrESlZMtzju3VCPhOC283kDVT64jcwNeAlCZB8rzbCEGSF2I15CgYKJ45bZh/jIwg4u8v5dHPB1VpeZPLlncIjVUL6MHTQ6w5kHfstLtdCP5Q0vaM9EwLjSLUdt24Cjo4WlkQlPXlDcAVXyneNg2jzFqzzbHSTqyi7Vgj1+a8nomnlem+Ck2vgBghYEs7Uck8/OFD2KmvG1Yst32Rs7VpTUFq/B8XGE/qvtBcPQ5p4qTDzsvUI0vIHWJ/9BAOukkg8lOB7bPWv2mLwqipoUYDuFNuxtszKgQRUt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h       | 8 ++++----
 include/linux/shmem_fs.h | 4 ++--
 mm/shmem.c               | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd14298bb958..18deb14cb1f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -979,11 +979,11 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
  * The vma_is_shmem is not inline because it is used only by slow
  * paths in userfault.
  */
-bool vma_is_shmem(struct vm_area_struct *vma);
-bool vma_is_anon_shmem(struct vm_area_struct *vma);
+bool vma_is_shmem(const struct vm_area_struct *vma);
+bool vma_is_anon_shmem(const struct vm_area_struct *vma);
 #else
-static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
-static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 6d0f9c599ff7..0e47465ef0fd 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
+bool shmem_mapping(const struct address_space *mapping);
 #else
-static inline bool shmem_mapping(struct address_space *mapping)
+static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 640fecc42f60..2df26f4d6e60 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
-- 
2.47.2


