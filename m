Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009C1CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4F36B00CA; Wed, 27 May 2026 10:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517B36B00CC; Wed, 27 May 2026 10:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343D16B00CD; Wed, 27 May 2026 10:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F31D6B00CA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D09A416103A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:14 +0000 (UTC)
X-FDA: 84813369228.13.C508848
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE96414000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6rGhgS8;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890653; a=rsa-sha256;
	cv=none;
	b=drWtWeYGsFUGYD6SiWahHAKvi21HXIGgyO0FiooHNW8HWlkIKXRNLzdzp6+oz8s4aiR/AS
	PAz+t596PrHUmXJDDRBdWG69JyYFsImZ4utVcBqQTZPCF1mIz01EaavK6lnC8kact+bUXu
	kiBuYFAaGOyIcieg7BXNjxfyZbAmrNE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6rGhgS8;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03ZuRm/Jbp4iqH3ao4SMCilmZCLzKIEi1dSL1yhjeUw=;
	b=g5MwFLZZwUVYjGZW6BQpXTX2V914RrV8+eqULGOHinX6fn6tmsVSEFLwOh91VTUUdAG2/4
	c7CFQs5LtbNfS8pg4QI6pqnOqE0W+4j9ZQr51xRLfoPkt8XGEA8gD+DPsWuBE/5+cpqjFA
	LqQ5SnF89vHJ1ApjvwduSBVnUbbE3ks=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49050bfe053so22220055e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890651; x=1780495451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03ZuRm/Jbp4iqH3ao4SMCilmZCLzKIEi1dSL1yhjeUw=;
        b=X6rGhgS85tMqrBAy2aaua4a8oG41FTDYZfg/JdSFhf3eNnKFQOqstpEWPv15qf2ZkG
         ZAehR3MxzeOlhv9LeYWS9OgXDv9knVdFsC1AC+RxhKrDJudkM2W5wyJtaeg+jayE/Y/1
         Jh52vBlyGLFuR+0VllykNmF41FvhTQDtYIzDh7Co/oGEHatkBwd+HsFMqGRxI/R52fa+
         TEW3Qwrv++4xDltXJpfjiXtYu0aFYebp1/HLrdBtU4hSAogNxTcQgWdQxsG+hT4nyIaM
         KIuYOGYg32VxRAkTQcRmyMzWoLCftqFk8ppekMs50FuXiVpAKOH/jXYRm2i11atYqDK+
         BBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890651; x=1780495451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=03ZuRm/Jbp4iqH3ao4SMCilmZCLzKIEi1dSL1yhjeUw=;
        b=s4MWi+lhncXcgt/Fz3+tiZYbB5rescMnPpWjhjF91RRJPPrwf9/FCGRB4wMcntTqVD
         vnx7LMObvzrJXuhPIR7GO8nki/iesncWRdTPr57hG89OqPRNSZBwa+spWXY0PXbW4P1r
         +UziIDuth/jThfoDKc2zV6yEsPifVt1kxU2yP1C9lXhYzuiM1bRn225ofwpKxL/wttek
         BeVZ58ibDf7qmtsEkLqxzuTtohnwtoQ7+gYFxMYtXQpFKGtvdIf/M9keKtTfPd3LICsR
         zCqJaZZjUgit4TiLg5mbvEn9rRFCsA71uyHyRs8r1fEbfq1Tp7RpTTmMp9L8Wxv+o2U+
         o5BA==
X-Forwarded-Encrypted: i=1; AFNElJ8P2LapA6nC9hNBb4Syxw6aCW9o2WNFyat/sklzWnb+suSfwLuLXSiE54Pzopzzbe+w5zfFFT85JA==@kvack.org
X-Gm-Message-State: AOJu0YzWDB/4iTSuqLwYz090IQHmbFXf4wcKd3Vu3uLFtPJTIiBy4Kaj
	QIXmdKcg2rGlZ4UrNIsCszqgJ70PgB1M6ftfMdBufQliO4lAwriViNnC
X-Gm-Gg: Acq92OHcRT0sUdpr8xjQfDqJq3XL5QKjQcngDMWzhK75fzhs8WPB96CNTAfc222lUat
	vDa4F+1PkmwQH7mnDhm7oz1P4kVwv7xjQqqAmH2KjscY0H62SY/HIixzCr7FG+bM55tOr2jSHGI
	CfOaBV3vYO1oVtFXjQ8aGIXX7NFy/lK2NphMZvkBMsegg98rycfWnleUnFn73ByFbPgkWZcHjMY
	TKydTssu5VO7G8pbfPuYojDHc8HYE46ipgzLdM9KgGkpEJy0Hj6ihMe0vC2nFIMjikcnevthC9N
	MZ1nlwNYGATLTam11yKgpyGTGiLi784/jmk0QRqDKLuf4wmbjer8s1DtgRq0hIB554Uw9bmyPMv
	K2ZHS0OkCKYbjctdXrTj2/CRYb8U4jvGJNj0es53MT3PQNLV8uRVtah9YCE3bGtmMoL4yHPgnjI
	FU4Uk253EZArEcMWGSlVcf/xfdR+pN6YhIR/zZHd1wTGieAipC7/gSXSB8rB/7D6bpKZ9WrxQAc
	YAUKL30hsB4I3wsDe7Ni25wEunk2KmGpQ==
X-Received: by 2002:a05:600c:4ecc:b0:48a:56de:d62a with SMTP id 5b1f17b1804b1-490424b3c7fmr352223335e9.11.1779890651300;
        Wed, 27 May 2026 07:04:11 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:11 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 2/9] x86/mm/pat: Convert __set_pmd_pte() to ptdescs
Date: Wed, 27 May 2026 15:03:09 +0100
Message-ID: <20260527140316.294621-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DE96414000F
X-Rspamd-Server: rspam03
X-Stat-Signature: df3yes4we6pzr1xit3zqoaxqimxgwtuo
X-HE-Tag: 1779890652-345824
X-HE-Meta: U2FsdGVkX1/66rEcP1RFpo0AsDB31vOcxGJAi984fgoUPds9EiMOZHSd9Rc0odzXSIhIKg5N88ly1GYQlHcrH6gRMWYQGmFlPxzl1nOksJMPnZ4tGVu+OV70tvQ8ZhFIghLlLg4vx+TYNk8vbdOlwr9oZ3/cme4BYqHFuE13kGM6wEuK3msI+KmC2G+BrN8GqGOLLvjW7fJUv0MYCX1XFU5DCix0HdLovvl3dDZYR3d9PoisGS4wgsUzfKHKqPQc2smP7DqutFGi8OmOFX72E55Bw8n2StyzXbkQAV3PrnOhnMQT44teZrFxKtwVlZ2nc5gMEUukZkxUZYqAxpRnKb0gwi0jPnFS9Tqs06ZRJfFbx6n/HX6NNi9PMITVahwL4Aojb7X5BQ/e8Bu1zE5kN3sUrwPRGeJ9Zy0tJp9Vq5Z/Kl7ANIgrHnh5c5oGLvJj3SDb5Ef4l8Xcc/moAOu9DylXROqM17fQEtz5WiLVMElfwm2NHSbSFnqNZWHno45cOs+K7rkNZHfnnuNh1EUjoAY2KefDAs6X6hpKyxAU4J9Bu6meRoP2An6BQADAChMg+Vj5MWzrHPkn1O+j9AaIAPZVTW6nsYYwrBQgDg6jLcBXC4QB/KsF6nZF4l64SFa8v3q50ET0CNRO080KRZgeOwt/VRxBZ42rowvSs/M4k4w1kaRJ9idc677rjOOHN5CQpvX1yd0QBKlWJ8dT0+ImeM/jCQr7DIIAE0V/A3eWRGhCG4iX+01SgbOZL3EUvoKglloM0eKmS4W9RB5SC59oMS6Pr5vJbc8rtRXZ5KJdLw0ZZLJMFOtYXRdmKkCUcwxAvcxA5QOrU/eSjOCGAjmDZmPF5YYaQpCET/zRZ7GNzmD1IueoRZXTYx9crnl/9njJS8ewMRNq/R8A3ugnRs6E0ZlH6WQ1uKuDe2ZJtMe27Oel053HLGuXzcchK5Wwe9J0iZ8dham5YhiDJqv0VoX
 /fvTScKi
 NWxttblxZAuw6lkYDSZSbkXGkz+iouyQOEFY8MZGi9DdS29NbiYbVr6cDkYSfEdESku4DHWVJUHULSef+Cn4SffyfokKVIzzCyuFxGHZd4OOxVQaezojHI2s+Y/tXzuAo4s9cgOew+9lEcDIrwCruQsEIQ7ne1dKdddWPVw+ubKXd5y+eW34+Utk/OIQlnXth/60MjT18QHEIujCIFE/7IQJSUOoGxApTQn79JwY2toFIe20cWNwsma+OjPPIR8KXjYEjEGU8ahpCtg+NaiIDCus7OVYU8MeWv7C8jt8ikZyoP/qPJ5vvtG7NI6PFAXU8ibRvNYjXqrBn0mpaiv1u0oPa4o16R/BDvfknpBsNDk8tQoNSkwsW7b9w5ntFi4k5RV+/EeWvMUjy8ehJDkDJ76Lu575VeCx7es9P9aFfgFW+wdTko/EcvDLC7byXD01V1nVWQuSOx4J5Iu4zkuJfcCqG/nYTug0WqLksgOhDaZMI2kXuUY57Q6myCUReucKCriVlzKB76uzZc0lU7oODVky4P19N/nYRlCt4sd2BbbVGi4Qp32P7S8FB5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert __set_pmd_pte() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 3b9032a3f315..93cb71451ce2 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -890,15 +890,15 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 	set_pte_atomic(kpte, pte);
 
 	if (IS_ENABLED(CONFIG_X86_32)) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			p4d_t *p4d;
 			pud_t *pud;
 			pmd_t *pmd;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(address);
 			p4d = p4d_offset(pgd, address);
 			pud = pud_offset(p4d, address);
 			pmd = pmd_offset(pud, address);
-- 
2.54.0


