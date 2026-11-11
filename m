Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242B5606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdbVel9j
Received: by kanga.kvack.org (Postfix)
	id 38C726B05B3; Tue, 10 Nov 2026 22:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D226B05B4; Tue, 10 Nov 2026 22:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D8C6B05B5; Tue, 10 Nov 2026 22:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E68FA6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:09:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F3FA1401E0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:09:33 +0000 (UTC)
X-FDA: 85421357826.13.2029C52
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A6C7140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:09:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pdbVel9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794366571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Km95marAPwW2pP8wgGsfAj1lfQ/5UdjiVvHJl74YYFY=;
	b=T+n+5NpWWHxmH52x0EXTWBH1ZuMepMRoaGJGmAfYFWXfJPTKPQn0Rz2ysiJNyG1XkVM1hV
	ekiT2+eUa+JYD7wDwvipvhJzT3YdtFfkU8iv2+nUDaC9Bk86J7r6Xsp7aA4BAtoFJL/+h2
	HDKWzVRK8pv15ZmXnireI7zLF5xRnrE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pdbVel9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794366571;
	b=MpyPju9auBVhOhf5a2o+Ck7zabEwwO018vHPNV+S9WP53KE6BiXykbnR8BDWUoGHEF7hZg
	xXlEvB7lffa0kQwNwY/RyHE+gknIvmELtcowRkfh26grVFZdkxGIzSDR86MgBpuWc2ckih
	qi2SZuvhJwD2h7jEe+nVRtr2yfbkCvM=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso4014265c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794366570; x=1794971370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Km95marAPwW2pP8wgGsfAj1lfQ/5UdjiVvHJl74YYFY=;
        b=pdbVel9jw0gvuQcfn+EYuQShQqrAOsIEkRZNnlK8rxCpNH+UjS8K+K1SNd02M8G3kH
         vwWFwCTtE58h88lPzI8Rrwe2NoTDez0bHiaJEhewRj0pmLMAMs0kkNGaT+2mZ8NVZ2JR
         SA3O2/+0adUXjgLgsQFLz7zdnLmr+vrxs36tbUm+K2A39WU6wJnez0DHM4wo1NL5cddT
         1lQ3WBbMkY7+4BD2AsNE1b6bm5kgfrRar/d3GwQN8W83Ml+/qnpfSqB1oPzqjWOqqHgF
         OTouAeigOzB6KAF/HRPQkrsr1+Y+pBP37bXikJSZM4gwSGCcg/yZsWApgZTSbhYEFen+
         oyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794366570; x=1794971370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Km95marAPwW2pP8wgGsfAj1lfQ/5UdjiVvHJl74YYFY=;
        b=SVdR8/rgbwymWws4we4EAL+2LmYYKw6+tctWiRrKitBvrGSlMH12zmkn2roEQkNYNu
         /PI/SGLptGvTB/ODW+AN3lyI4Wf32895irhsliL0Wo9HRYQ8dUCT0qO27nNgUS6g4zBg
         qkJXMUDl1axWLWYhsOuARVvUCuVforfbWO2i70iDBM9EBFB+Q3U3+cRNn0fLAQ9qEkpL
         ELec5ewoSYgGYu0dncARHYIyzOWI/GgYEM1BSFW+79hSPPcNP/sFMPnh9uSRbyMSse+j
         XDUXKcAK+BajhXGOt/mwn0XIVrSLLNiF19eKeAPehogOTYrlHhSBGrsxKjL7ftQdDbFC
         IUew==
X-Forwarded-Encrypted: i=1; AL+hErGDFYFGevol1CaVicObuU6lxrqBSkME9mLwlqRBUG8LMiHwRwFZH9IHbriLjNLeqb5b3sW3t+Rblw==@kvack.org
X-Gm-Message-State: APuU4Z8+8jyC3Eg1/1fnryu5UbUHlu2KdIgCX5RfWgWxSE20eNhpra3/
	+oIutAOITh6ReYMn/b+2W23liePf460UMfraigZJBEalUUT2C2MFeuNx
X-Gm-Gg: AYBFou3IL/vSMqRcz7BzddBUbBPg/AB+1bcso8buITO5LXKRXx+BjWFwnde9T6685E+
	gq7lkJPXY++LOSE/DFP/z08Fn/ZZ+xGEfbMU9Wfk4vdV7OGdSnv08JTykKpvlAZX9ao6i2iLLic
	P1BYneQT9dPU0DvvxOAAJYvzK8/S73IpbFN9AnnVIlkQy8vg14HlaKEHSF/zrd58RuqXNSmrLMw
	56KghnZe0HWgVuI29voSt5XamzDCQrgBB6VuOFls5xUuqRFG2ypl4vWF6pZ/d6a1euUZcQkZmkk
	oxUWZi7itZxJjG+Jv6srIAGmajp6wmA75vT8p7zfPGYGGlpamGeNh3Y4G/nbVuKqyBF3MY/a/DK
	Et5P8XBXT3H+83iPy4xDkUfj8bAmVWROyMptuWT88A5zaeC5RAAh4CKJXnvxsLtZxNo1R0BLA29
	hPHSJSilpxy1YE37wnFYMC5/a4RQioBxJhI4SnNV0STpQhP+lMfkkBBx3ef/feh2JmEYH2hnUsK
	eS0oMCeytLLg+Sa5rvqgVZdafDSXB5Jvti1BWQab6tSvuS+P/tYketPBkMbL76pyipzgRzgBRU3
	XFEKfgZclHMkG2xBAGDUCoMMCWTIre5uPF1fbea2r4r2i4gfajrONmLkEw==
X-Received: by 2002:a05:7022:7e8c:b0:1b2:43cc:48 with SMTP id a92af1059eb24-1b3c03387cfmr1271942c88.33.1794366570168;
        Tue, 10 Nov 2026 19:09:30 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4ecccsm9623484c88.13.2026.11.10.19.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 19:09:29 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	baohua@kernel.org,
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
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Wed, 11 Nov 2026 11:09:20 +0800
Message-Id: <20261111030920.1297625-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-8-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-8-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A6C7140009
X-Stat-Signature: tsuj5hfgchy8wetwcrtofcqte99cs8uj
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794366571-545192
X-HE-Meta: U2FsdGVkX1+fPiXMVrNecbvBj7adBXCHeqB6CxNRvV4EFQNHc64vMoWkJ6OWGeoEgC9NMukTAz5BpDWUnqxdL/K1YMOvUlR4wxytQw0TKPiZz6V3gq8XwO59w9TA4zDKwqSh0KR21uj4n+Qe7feRMNuxcz6qFFnf5prJKZc7GFdYFySU5FXX2Pue7YxaiGvdJC8c8fpbDKnx6+4RuRHARmHS+kyiJWblU8M4+5kbnDVtTng2c3gz57Lk4IVlZcpdqUJhRkLWBqtJaeyRfuPfI5sUEeOUS90cz9+pbO4KHm5Q9d4JEUxQhxtoP81g+45B7HrvKm1NO5gT1o+EiFo+6L+4eV1vbyrWfGPXavjY7sobWyjzfTUOkyVE8uPMruNzZPpd5D+qLeI+vBavTgd///pfLpweYtnR3FMgh7YAQ95gSh3TvJMyH/glHaHOsBCFT5sLHbX/EmetQ9xgg+wGoOsyAE7ety3wmyTYfgecJHoGwYkm2GyN1pniWgON9KSfHd+MuHepizNleAlMAATCZpYqQWT0Q0GEsCs7PHcGuYSKvkkTbEyDYJfnr4FHDJQ8g6YLV8hBzCTE0QN1EIJgsDA8eLoiUaK3gJn3tHv3WtF9GX9HPUIoFwbc9mDUJW2EYmypZQyq6POzztXCk0GQ+fsywnvlruVY8E0Kg5u4stS9BGpsbw0rWTMiLfx904N5kJFHzpGcqHPvqV0nUGQ02f+J/ZVN6tGuoaKqpmAGeEhSHkManePIO04A5N2NDVn4lq/i83/fnhv/1K+HE/Uf4Ea+aA/jRT9a74KBxL6xYAzHpY/m9ipjSV3k5NjgRMUJMr5zdLh3ZBlKF5hQxjjeQxBaQ9Wmq24HBY+KEQQT9yTfO8ei3VvdeZ5KBXSK4p8sraAW26/jeRebPE8ojL50TBkzDSMnef8neCJDA8GlYgGFXspKWQKvbIXZcHwvFWYp7re1NcSOI4zjmfZLqPm
 B631HzwG
 r7WrPxaxMygaf3XWZ7MAP3TehpxuUGYi+4wHZi92GpU+hVnmxUgYzmdcYkfl1GWAVkZKlIjH5AKbeXOwQaoBxW+2GuiZViJQ0Y2kjezK7NVwFeGboQWgnNyY+ru15QyQgAFfSHGxYs+qz7OUymEdV4Oliw4DTyu6jKxqxI4xunvRd2xEm3V0ejiauJEwQswvo5yF1u8/tiAOFteNjRvbS2lQAEO6KPAD47usMpzCNLM+LMZuJhewcThScVRBDv2xT2kxMCcsv2aiEA0WGOUpn2jaeGDU1cHNY+Nmak25s/SayH5mPqFIkhRNeZEt2W72VQNYJ11ivtCRovnt+7SZGQx7qeEioZ2ij3W7+kvFWNae9BieM8D2nw65SRz0wUmbNMMIUi6ujBy+hS0J3+xmIdV09R/GupsOjypWWjD1fedMGAEuXrVLb4CIy5vEx99rR/zou/iS4wXdvPFAPO0RhEGP5GqZDsx3jC6eeHlNjxzX4s4Hi+ekPt2rm2nTLeqmqciFI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Could you please fold this into this patch to use an unsigned long
page index in the walker?

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6a150b11261a3..48240fb674b9d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -557,8 +557,8 @@ void vunmap_range(unsigned long addr, unsigned long end)
 }
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	const unsigned long chunk_pages = 1UL << (shift - PAGE_SHIFT);
 	unsigned long pfn, size, chunk_end;
@@ -608,8 +608,8 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 }
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -646,8 +646,8 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 }
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -666,8 +666,8 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 }
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -696,7 +696,7 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
-	int nr = 0;
+	unsigned long nr = 0;
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);

Thanks,
Wen

