Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F7CCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6216B0092; Fri,  2 Oct 2026 12:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BDC6B0093; Fri,  2 Oct 2026 12:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8CC6B0095; Fri,  2 Oct 2026 12:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5E516B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:06:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77191A7768
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:06:03 +0000 (UTC)
X-FDA: 85278162606.25.623CA4E
Received: from mail-pj2-f14.google.com (mail-pj2-f14.google.com [74.125.227.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id A14CD18000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:06:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DAXU+V+E;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.142 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDVqQr9a+Wa1MAOG9bRmi0jhwnmrOJeH5SzcMrY83Xw=;
	b=5z6fgTh8mFpXJaUMIq0wyh7UqXkxZ76bz1s2kg80mLTvNopdBbrU7K0CrUWXpBvkxOzc9b
	vZdikItoobPNND63VChYyDtNGiJ96U1fpT+01sfxuEEI3O9kiGFKkHu05TuxvfJqIszJMT
	fPeO5ShlaJKZecVdI36VE1Y6gEsZM5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957161;
	b=EHiS8ObvDNjYobPlwOlf04AhbeWIrkJAQ3OiRdCV67tJhT0GDTQgJHkIbfLBGa98bwwbAS
	qwUFUS3f0BFU0sNmgcARRALpR3nrs4vz4PWmCyDN5OePkk2kUYVQM/bTBY4wst0/F8THfs
	g+B9/17TWL0CgHQCsI0lESwfpeWiDiE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DAXU+V+E;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.142 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f14.google.com with SMTP id d9443c01a7336-2d747f05ffcso37534075ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957160; x=1791561960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DDVqQr9a+Wa1MAOG9bRmi0jhwnmrOJeH5SzcMrY83Xw=;
        b=DAXU+V+E0T39XBc7JY9AZBIz4WXQUt91yIC5Td/p7beeliSumg6gbHLbbl/xbskjjl
         vGPvTYFejuARpZ37+Bktxgb9m4WRUDSH1U0vZd8X4Da9BYWodYrC2Lj8dkl7+73iVBl8
         h8TxVERzS1+Em0f3zjqkizUogWMRJVDeePIZO3oXM1Akg5pk4t1cVTKBKhv7apQo6QfN
         SDNwvhiIotHlpBHj3J6pzo5xzRHP89LvUyXDhqWEZiZpUOp7lBhHhU65197NhwOfsJr/
         rrHGffSBKpo9/sr9o3/EiPDD9SaY2PMTUX2lCw7Zmqrqb65CJCHuT3oRK4ePelvgWeg0
         jRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957160; x=1791561960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DDVqQr9a+Wa1MAOG9bRmi0jhwnmrOJeH5SzcMrY83Xw=;
        b=ZEOBvl2f/3ttfrcn8v2EDGJNcgnQhqTSt15LsPwQ0Ts4j2qA2emi+3gLUo86hz97Ir
         +lZf4kG9eUJVBnk0rpHPaYvBJ1Z0K4rzfmc4SmeXpLbLmus46NmHL3HVrf47RSr8rjdR
         BMZD7BA5EHBXyrBw/0G0cry8zGNzDXTGav/mNTbEAKEe6iQ2VT+3q8/T5MKH+ar7CzzQ
         Fmdhem6i1deNr3T/llnKmQn9HuP/2IVGIW8hylOQ7yD07+Fylz0YakRgTzdIv+EGBRDi
         tLqYxrCLTTUbvwtPX7LL8cR+ESNmd1CBOxzy7qkQSQvAXNmmxcthiUznYzc/k8tUgzgo
         Zr5g==
X-Forwarded-Encrypted: i=1; AKwUvBy5OXNM873kkm0WXJ/8N9/SGoDjvOC/JztrNNNxuLlWwz4vhQSaPE+3bHY54IfeBucAz7d/UdY+sA==@kvack.org
X-Gm-Message-State: AFq9FYLq6zAaVIgGQezghFPYE5Pa7SYKWhCaANebRZBbwFOak+UN7smg
	jV1vq/VPS4pH4buqST5ZB3hcRDxLgcXHV3ciRl0wzfOh4r5wwmsvDmEl
X-Gm-Gg: AYBFou2i0L+ALlCve9xZK2hS0F6iuR60r+SNGyR5NITESSm3e1ihDzZikNzMYubexGR
	iv9pQftZefTyMWEiOkZBmzcGIn+S8jCMKoU/BePRUjNNZXa/+NJ7Pwk87T8l05Rm6a5enB/jZPf
	3mHZ6/c8k2oBfe+UGscYxPfAhiHVB08hAQzDWP1fRio+OwHkM7YtWs16NbbU4xJuJde0aXCmNzD
	g9EtUHbhljTZWfQyJieTQAaocEiJuNoiOxoYs61b2GwM7B2mjsHl0aniGKfEXtv5P24Sh4AwmC0
	yLQzP0lsCvMTTnb6s4zc+o7HB2gdDseX+CNhwahm6luoMWXzOcirIibe4tt8LbMQ1w36lxSwV7/
	Z4xp+SlvbNvuBbSsD/HH0IiaC6FCiZt24wnWzbwR11x0CJ8G9UH0Q1Gvpb5f70ZDREKPvMqh6k0
	w9efLTmhbo4uVI9G1YYvInuB92vdwWKwylzoN6YsE7DjkJgVCsv/vP3aeGOb1rWqQjTUGiaLRig
	iRMuq4IhIDj2uKVQjN6i91/
X-Received: by 2002:a17:90b:35c3:b0:3a0:4668:4cb0 with SMTP id 98e67ed59e1d1-3a6cead5baemr2914038a91.47.1790957160294;
        Fri, 02 Oct 2026 09:06:00 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f47cb357sm9375672a91.17.2026.10.02.09.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:05:59 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
Date: Sat,  3 Oct 2026 01:05:34 +0900
Message-ID: <20261002160535.661399-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261002160535.661399-1-ekffu200098@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dy9q6rejsj5nwdcbddrgfys4sbg5zoyj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A14CD18000A
X-HE-Tag: 1790957161-972606
X-HE-Meta: U2FsdGVkX18/8U58CflMBEeyXhjsoB87sFaHV4nYhdXjKUD3KAecqhVOQMrToTvpM4dtc2OQ5YMR7oaNg4l6glXCGSP8iOg8JjVE5bsY85b5ta+C1rqZRX/fx27sKM2P04prvZSRrcsB7t4t4gGrrP3E/Jbk4D2xgPH2f7ZvHQH5Pz4ZgmHBPqxQET7tXL3dRxO5jYXFN+P6E1npA083rkjobF7UEjItXrh7iENJ6BY5H8hwCkbEpsC4HBNOjUEVEdSlUBxT3bYIFxjoMe1dQUbyUX6W59TUeWZ50v5p0hxgEyyeullb944NP6KFZSPKfDVSZN6LZj9X2VTGJ6+7dLzJbTlBpkFiZJBxYFegKyog8LIxB6zlqutSySIoqmLAQf52louIe5VRXLW24a3tNcbTu5VPtgXoM70Yb9nv/Ywsix4PIZrQUX4uV1wNxTY6chOzi9HjO1Y1cL++kKyigd5NXVK1uyGNdcyog/1R47X5MBaQjawRb0wNGe5AXHvpu4erWu+UJsvVIml69fhgE5Up4tojn49BY/gmcYgPJqapR/Xh/WCTe99O8Qtam44TAdleOBxXIUzwXModqquzGMU2eiwoteqaHymT7/UWrJze4BHZ+y1BHME1riHPom7amOVuAhea1nGQQ9KJR9M3EMehQ5FEtMjDQQhg3wxG0tan+m23cL3KVBBT5hCbb+jm/ykz7b8YE7TGyiA3P7dgZ0JBC5AwzmT1/jSfqhwRNTLy3pYQFw2N45HKQz5MWrpfxPSESEQAnyEqT1ZMNE4Gcc961ReGmgPGtIJS+2Jc0V4LteZCzcON3QwDYv0z0jlLxSaElYfCDT135RIE1MYKl4Jrq7N9KPp2kG6sQmM+KSNGqruqPIeo+jrLW7FSclqP0MzLhEfNr9RBJa98K4a7N5BlNu/7UATDbK6ERWC5pcQjouTdenemjiy5/E3GJK1vot3fLJPWXheX9jF4tIR
 6N+xUyJs
 MMtI/Mjva7SM6ZkL9+6mOlx/B0PTVVOiZKh53nonR96FrA0wP6romY4+X6wRbQ0tEu0Ksrq7x6qfCVPAUC8IOuFdn1FUmTulIGtywz73OBj03d98+kLiKVu0+4ki3uppW+f2atwOCEz+g1ECASeims11NiV6Eg5WgRkwu6OSLhdas/twvctaH9wu/daehX8kwZjP2fqYF2L279unsdZ4DzkMYWbE/JZHTyLOB9C/nr6Gp2ugNm0cY64Do56eB1SndttWrFOWtN0n9lL/STRI4/EpcsQh/f8iZ1WHEOOgidTE/Z5Dkj9wX+IrXtwO951oMQxoMi1iBM+CI3G8U+o2X/1PYYsnpdFMsNmR/P0HET2ZbpnnteaUnlDmKBoApftiot+32nmW/qY8SkxYK+yW1qgzXewzAfSQ/5V8sEJe1Mms9BcBI1ykqg1QcmiKEK0SVlvXnUlrRIf36Wn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmf_insert_mixed() just calls __vm_insert_mixed() with the same
arguments.

So merge __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/memory.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6c1d38eba7b2..bde650e207c9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2991,8 +2991,8 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
 	return false;
 }
 
-static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
+vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
@@ -3041,6 +3041,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
 
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL(vmf_insert_mixed);
 
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write)
@@ -3062,13 +3063,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 }
 EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 
-vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn);
-}
-EXPORT_SYMBOL(vmf_insert_mixed);
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
-- 
2.43.0


