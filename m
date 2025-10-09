Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0D3CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9138E0037; Wed,  8 Oct 2025 21:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91E18E0002; Wed,  8 Oct 2025 21:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B378E0037; Wed,  8 Oct 2025 21:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCE18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53C9D160919
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:51 +0000 (UTC)
X-FDA: 83976917262.21.617C7E6
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7360EA000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="J/wn6IIG";
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Q8oT6hoS6cxQomKzX1vfx1V3ZAPioXY327lRhg5E1A=;
	b=XwsJnyTokkSSjmgz2C4dYqrgJo6DgNBJcJo18W/ZHEujiwtYGswQWpis2SqZu1xXELiIi8
	O0YsKE78fd7cSI3tNsql3WsowV/ufBXHufwLxPOfGjDG1qrYpoI2Jw5AzyWnipWfCSlnE6
	C5X79A0I6M+fyPk+hZ5PeP1nrx0txEM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="J/wn6IIG";
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975129; a=rsa-sha256;
	cv=none;
	b=xDl7En1udTu/C+8vkGKbRIEd4lrQ31ibh2Vqqah3kDaSfwCtkKINUkMTwpnBrS7TymjeRN
	undaPraWVOquIIGJBte2Tva5OTENLalEZxBwBSjj5MxC0OKTc040NE3rmxo5nmV+3xy1Pk
	+F3q1dJLcCnknVSSGZR015SQTBX28nY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so6246105ad.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975128; x=1760579928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Q8oT6hoS6cxQomKzX1vfx1V3ZAPioXY327lRhg5E1A=;
        b=J/wn6IIGAb1kYJkTT/HegIqxSX1I3eX63UfmCqf0EUY/v8KDgVWG088kuYe1EAv3xM
         evdudX1HmzcU7HsBjo6yacndWQR+5QZNbbo7FKRI3Mh3ykZckbmVrqthE8UkBUEj6S8d
         BTJwNisX7aoutJJO6tkLZ5FWB+EDFPnc0jWSEyNdPlsIgA0d1OH8IA5LFabqiOjJQ+5o
         Ms/2gE1nrdvEY8Hvdbsk4d52xlIK2rJzgijFsHnSkoI6B55w1MuWqR9L53XJ9gfX+uPs
         Rufn12xFB8MODlkVOkWFvOM6QsEHwj0FbJIEg0KWqZi08suUyEOOzddfl2Bz2LHhaydX
         OIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975128; x=1760579928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Q8oT6hoS6cxQomKzX1vfx1V3ZAPioXY327lRhg5E1A=;
        b=fOIbNT7NvGLgwfMp9lJyblrsKCTShKgp3cKKWGldPWl6ZnA+NdLt71jCEWC3MOFOGr
         70APc7eP7Gkf1m429uW9GgdMUIlGyAgW2jCUCPdIFY5QL1JL1RgbNCSx6giFbX1WMudM
         g23PzLW53NJHMdOP3S1i5LVdZSKNG19Pb2NJVNXAO1tuj58FrSQeGPAO/w4tEvWX7tfu
         P2eVs+qCJtv27Y/K7PN2MpIlRQbyKboS+qVIpy76E2Vy8k0AQUCifxRj3dzUndBN7+fp
         qDYPJtQL+S32QXwgZz+Ppdn+F+hhT3zPXeuOiFpWiZhJ0yI6ivERQFQA2KdaITb7Qi/D
         1wWw==
X-Forwarded-Encrypted: i=1; AJvYcCU1LYHMUdcelaXFVRt4Pv/DT5KIHKtsPQBzt3Ybn/atlx1krm3VZq4CSUc/uqJitdz2NmPGdf60ZQ==@kvack.org
X-Gm-Message-State: AOJu0Yww+cIYKYYgYKBTwr3KerUSaQuz0JN6gpF1LTZtGdG6xEni8Jtz
	BLOQ5TB+GI27Ui1/zhMjz2cQdGnLxNFugkSv0byk76TixBkneGqAmxVgCGYWQ37ZolM=
X-Gm-Gg: ASbGnctFGzzcVYz2ExyMjtPwB+Kmqu4AGQFQF0YoU6DvE3nJlWr2/a95zpgVvJK8mSZ
	ogY3tu9PJRWfkQmFfrGuf6KVRzbcXI0IZyQ24yYTUJcdx9Wep79bVcnjyZeH65IeEeau4cCKzJI
	AwDeYQrY5iwlY46lX89b2SHwhspIoN9VtQprPFdQ4Uw311zITG4AtSjdNkoMrGVDE82ieTfDRZ5
	GfeXzg5aHZ6ZFmkOnXtjS5xCdoWWiyjEj0Ml/tHnDS8ZE5Fs9dXEnhfd+k6CEa5n07H6k+Wk55M
	dfZP83GrZlNgng/T5dMB7/BdmUPbl7P0f/RuVrRMXIC6vbm7Bgwb8kurAsWBJsWkdogq3/VZdNG
	NcItsnDUdooGg8ODF/pgVbEKdA2Z7iPVpuM6UFd54Xp6qpwXx35tsvr5wDN+QCtqW9lKeKk38nS
	3AkU4=
X-Google-Smtp-Source: AGHT+IHLtMfpsASWG7S0cjFNRLXUMrAvJHuz2m4ALPRQp+i8q8lJn/YDkN/bQbSK1wXLrkajg3vnmg==
X-Received: by 2002:a17:903:11cf:b0:269:63ea:6d4e with SMTP id d9443c01a7336-290272c1aa5mr61891525ad.37.1759975128385;
        Wed, 08 Oct 2025 18:58:48 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:48 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 06/18] riscv: hibernate: Replace open-coded pXXp_get()
Date: Wed,  8 Oct 2025 18:57:42 -0700
Message-ID: <20251009015839.3460231-7-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qdz3wi9jt5hihjugx6bckf71tafsxatw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7360EA000A
X-HE-Tag: 1759975129-906463
X-HE-Meta: U2FsdGVkX1/t0Bd+Ye76PwIG5M4yvlIpkGAOdvwxpEXYlrrqgFo4h3AjDBkr05KB5Wo4fnNXvzHcrPsj6yRSRiFPApphwSxXKoT/9dAW8j10DtBSSYXzrMIqj6J71zGqck7NaW5Sk5MD6Gc0dkegYbtYULU2Jv2ZgKwv1Tkyr1t/YyKsA/rg4DLDBPYFooRnWU+b0xs/l1MdNzBJJOzAl44uhlNf38SLNAFWd9rc7KA0C/s5qVgo6m/afFg9dSfUVg8ZIARs9OKARpvMONKfuE+5JSJMQ7gkZlgX649TGnToL0Md6bWIrt7uaD5XQV3zEnV55/pjW8d++xDJlf6wpMpuNXFy9SeCInphErc5a5V7ylUWNt8EIZb2TMCTkuiwxe2On7qAt2SSM2c22f7a90uFHsIVWJ4rVNFiqBdDBiy56d+B+rOiPk/r+Tv620cHMr1A7i9HFmpUraDKuVFlu0G8uIPoMFOW9g+2mub/PkVKT2CO4i6R1Wzc/q6pT63vgenfPXO5L4co3xBSfZpKF6wj9uqPwGqETxsAu/aevjUC9hYW+qDEbpP4+FDPZ5fTYhpk8iodbGMtHL0Kv1M+nZcW2trwv13zFVvgAXViCN7Vg2ScyzHZkSEz+4ghxniN2QLNGnh61Hz+eZf0aIoB17cQCokPbe/uLkiW5eHnD3q6lEKefwp/kS7km7TR9nUhx3wr8HEI4o6qJgps16c95cV14kiUcI/RMMpsN7qienZSQasFFnGCAVfWiUuYJyEA56pfV46gaBb219FSTJAFZyDSFQBpflhCopiMYskMmXhlNCW+uEhELB4cuhBrlEL5BzbweM3gv/+Bjnmg64NcCi+IqBLQWk+UIPPnxppwFXj8OTI4kuan6/hluCkqJmIb8XokdduNN5Z00jdQj0ydRD5nE+vKUbddU3dL2jUABInP3D6eq/Z0Xn7nDJ42JwufYFaQX1bzwilbKU6YTvD
 ZkedBaQR
 09DqFLmPUIqsUwWJ8W47xTeGqXrJaeQV5eDZveYSqDeWm9kBn/8rHJkzFK6nBuh9VodmxgPBEIiM2VeJgyI3Z0kBhVNU/R1tlCr0hyPZDFDAVBah4MRaFHRyc1Otj33VUvedi9/GceclTQQ/pYVsodkJ83nfEk5pcs7V0H6zH226SJK/URKHM+braBEmq5FM1ciX2kZnRHeWJsnEdAhUE/gBwXMfEkdMv/7hYRwl0/RktjkwDjdyrSvTgek+FhRZ8YjvzWZqYz9E9tyhENM97ZrQ77U0+g5zXMVpdYhJTmocJ93JIHbf1fa4A26ZhHcwHLm3eqJs20ypryl8D2h0tCsdSZYMIAT21bjk5S+j6Rwuq3cDvEotuzGw1Oi+/8lfJWRFz4uNNMdJDYulT6PaeaCGazihwN7z3GkJi4cV0Fp6QLhHDwbMOt4k2i38NBqaQYH5X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the semantically appropriate accessor function instead of open
coding the implementation. This will become important once these
functions start transforming the PTE value on some platforms.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 arch/riscv/kernel/hibernate.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/hibernate.c b/arch/riscv/kernel/hibernate.c
index 671b686c01587..2a9bc9d9e776e 100644
--- a/arch/riscv/kernel/hibernate.c
+++ b/arch/riscv/kernel/hibernate.c
@@ -171,7 +171,7 @@ static int temp_pgtable_map_pte(pmd_t *dst_pmdp, pmd_t *src_pmdp, unsigned long
 	pte_t *src_ptep;
 	pte_t *dst_ptep;
 
-	if (pmd_none(READ_ONCE(*dst_pmdp))) {
+	if (pmd_none(pmdp_get(dst_pmdp))) {
 		dst_ptep = (pte_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_ptep)
 			return -ENOMEM;
@@ -183,7 +183,7 @@ static int temp_pgtable_map_pte(pmd_t *dst_pmdp, pmd_t *src_pmdp, unsigned long
 	src_ptep = pte_offset_kernel(src_pmdp, start);
 
 	do {
-		pte_t pte = READ_ONCE(*src_ptep);
+		pte_t pte = ptep_get(src_ptep);
 
 		if (pte_present(pte))
 			set_pte(dst_ptep, __pte(pte_val(pte) | pgprot_val(prot)));
@@ -200,7 +200,7 @@ static int temp_pgtable_map_pmd(pud_t *dst_pudp, pud_t *src_pudp, unsigned long
 	pmd_t *src_pmdp;
 	pmd_t *dst_pmdp;
 
-	if (pud_none(READ_ONCE(*dst_pudp))) {
+	if (pud_none(pudp_get(dst_pudp))) {
 		dst_pmdp = (pmd_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_pmdp)
 			return -ENOMEM;
@@ -212,7 +212,7 @@ static int temp_pgtable_map_pmd(pud_t *dst_pudp, pud_t *src_pudp, unsigned long
 	src_pmdp = pmd_offset(src_pudp, start);
 
 	do {
-		pmd_t pmd = READ_ONCE(*src_pmdp);
+		pmd_t pmd = pmdp_get(src_pmdp);
 
 		next = pmd_addr_end(start, end);
 
@@ -239,7 +239,7 @@ static int temp_pgtable_map_pud(p4d_t *dst_p4dp, p4d_t *src_p4dp, unsigned long
 	pud_t *dst_pudp;
 	pud_t *src_pudp;
 
-	if (p4d_none(READ_ONCE(*dst_p4dp))) {
+	if (p4d_none(p4dp_get(dst_p4dp))) {
 		dst_pudp = (pud_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_pudp)
 			return -ENOMEM;
@@ -251,7 +251,7 @@ static int temp_pgtable_map_pud(p4d_t *dst_p4dp, p4d_t *src_p4dp, unsigned long
 	src_pudp = pud_offset(src_p4dp, start);
 
 	do {
-		pud_t pud = READ_ONCE(*src_pudp);
+		pud_t pud = pudp_get(src_pudp);
 
 		next = pud_addr_end(start, end);
 
@@ -278,7 +278,7 @@ static int temp_pgtable_map_p4d(pgd_t *dst_pgdp, pgd_t *src_pgdp, unsigned long
 	p4d_t *dst_p4dp;
 	p4d_t *src_p4dp;
 
-	if (pgd_none(READ_ONCE(*dst_pgdp))) {
+	if (pgd_none(pgdp_get(dst_pgdp))) {
 		dst_p4dp = (p4d_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_p4dp)
 			return -ENOMEM;
@@ -290,7 +290,7 @@ static int temp_pgtable_map_p4d(pgd_t *dst_pgdp, pgd_t *src_pgdp, unsigned long
 	src_p4dp = p4d_offset(src_pgdp, start);
 
 	do {
-		p4d_t p4d = READ_ONCE(*src_p4dp);
+		p4d_t p4d = p4dp_get(src_p4dp);
 
 		next = p4d_addr_end(start, end);
 
@@ -317,7 +317,7 @@ static int temp_pgtable_mapping(pgd_t *pgdp, unsigned long start, unsigned long
 	unsigned long ret;
 
 	do {
-		pgd_t pgd = READ_ONCE(*src_pgdp);
+		pgd_t pgd = pgdp_get(src_pgdp);
 
 		next = pgd_addr_end(start, end);
 
-- 
2.47.2


