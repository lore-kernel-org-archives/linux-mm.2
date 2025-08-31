Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B89CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3038E0006; Sun, 31 Aug 2025 05:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C058E0001; Sun, 31 Aug 2025 05:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967D28E0006; Sun, 31 Aug 2025 05:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF768E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F13BC58DEE
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:39 +0000 (UTC)
X-FDA: 83836555278.01.8E4385C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 371C34000B
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PgkhHWnR;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZGxnQhsC2P8euySzPswvqJrcJH4ogAsIfO9DHwigow=;
	b=PhKUtNi10wrlkZFrXiM+lLcdAJbN8fQ6gDAh2ynSHERbCw5e6//sHeY3zT65fv05n1441t
	Qd5g4vP17yhro5Iik8NijU0GFRsq63zLQHj/qgrMwz00pEj/IQ3Wbde+3xcYD1hsSkaOG2
	csxoRQTQbhX0gboR36UiClIV1eZBf6k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PgkhHWnR;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633178; a=rsa-sha256;
	cv=none;
	b=KwfZ+wJACNoa3h1vcYJMMUtEjCcKapMAApulsLagZpDruqbIubJi9bl5LAKXR44yOzJsd8
	AUDnuyyC1STzNnlnOm+DOrGXSC24MJNbpY0dqotUoF0gQh6LV1hq7G2TdJHPM7bx9hkoDp
	KWcrar4zDASVmBYBX3G9BY5zvnNvG3Y=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b0428b537e5so5127966b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633177; x=1757237977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZGxnQhsC2P8euySzPswvqJrcJH4ogAsIfO9DHwigow=;
        b=PgkhHWnR4u7A39IMOz17dBqsrUzxxYGef/b8PNuVwQXGBx/nf7j+wESDgZtRwjvsry
         LNIKomX4iTbuC+REHLGgKEH5nKMqbiLZusH5eLTsWQleOyUawCDxKI8wUe3s+RiNFcNn
         Kd9cK9+Cq2253TbkpU318XYCirQny61pE4LJJraTihpa1XNYymaow9foXpgHhHNBtmAg
         dkJDcNqzx3VnH94+uT/e1/0x0374x49dXPJufbPPJyPOf9QrzxwpOmiDRKfV3WXsiMoV
         /e4QbQp4C0BJgZxIAO0rXlorfJ4kpabuDbVN78Z3FeKszDP5bXla1bYN9MqJ2aEYCdlA
         NY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633177; x=1757237977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZGxnQhsC2P8euySzPswvqJrcJH4ogAsIfO9DHwigow=;
        b=f5H3jJTPGjBJvqveVSzhoqAijYqMsiQlvUbQz/safazc9IL8Y1A7hemvQP8D2XFm3h
         1c3jcMwWJSi53Ji4o4gB8u+lrAgpkxZ2TU14xiQXl9Vv3iFtzPd/2fydtb/TOJtvxeJr
         PXzdJGcUYjnZeOPjQBUI5boO7ZS757luBcHG9OIOsL6akIjzz/ujPKWd8pyHXo3287Kv
         OxZSWZ72Etgcry8AQC2aL30IhZMLeCQt9Q/FWvHhF/AWGBhzWOo5zR/EWESbw8hm1DhK
         bK1IIblah4WyJskh+tKUJhhKmJlzm2dSFjcRR1Fb151LwZyjAGdmBha0TS76/mvsrN8C
         9s1w==
X-Forwarded-Encrypted: i=1; AJvYcCX/hsaey1MmWRVSDkZ5sdj0aZR8F7ObTzgFVtLklFJW6JrsoC4BxAhL2MNJcKMcz1W686yDZI3Mdw==@kvack.org
X-Gm-Message-State: AOJu0Yx1JEcc2qEYGPZgkDUDD/hlfigULFRgD0Yf6TYm9fVGnNBit507
	4eqycCtWjx9pac37gq5qKo7AhgtN7f9lR1ZOfT37Og5/02c/GFpBb/OW1U4Jk8/lYqM=
X-Gm-Gg: ASbGncv4dv+K/ULPeoMY2hIaUu7OMGLsGABGpGBjxWdTzwf3JDlSOWXrY0MvipOi0DM
	sKZyu84V576Og5B0798x4Vy305xLvXriozfUy7u5gFt4g4GW93czaIaFiTClw5lz4ib2SLRLCKf
	z9a3lkd1xXEsnKdsIcwrB+jd+keLafAK8ma5F6HX4BYPu5rbDme2OXB0lmEI1ZnDQUSHUgye1dX
	01zfJXCJfyKVXhugi2odQ9/8LG60bdERuwPS0fkkgLGZA1dTW4LQOTobWLqb8oTL0W01jhHUTH7
	b3rZdChtINcWX20Yj2sUk4MhQSzS7IXeidpcRQxS+AITYS38Cu2eqouOU7aMOO4s9i5ebPlIr0R
	2xOM34QP9MJN0KvtYkR6eencfJvj98xfDR/AT/ruLCOs2vB+xqYPZC9RIGz63hQXMauv/CiAzj3
	BzklScCEFPqDuDvWdtDlinlBt1377A8ZO2
X-Google-Smtp-Source: AGHT+IHsLsYix0uo6uMedopX+OAnJsP45C6YTimEtUIUmbOP23yVgqxQq1YfVopQwWMRzI83RCvrdg==
X-Received: by 2002:a17:907:80c:b0:af9:a5f8:2f0c with SMTP id a640c23a62f3a-b01d8c9275bmr395699766b.28.1756633176716;
        Sun, 31 Aug 2025 02:39:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:36 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:07 +0200
Message-ID: <20250831093918.2815332-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 371C34000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b3mge594bji918dd81my85tozwq5b6ts
X-HE-Tag: 1756633177-48162
X-HE-Meta: U2FsdGVkX18/7me6RiFhqAhlmtx/aUJtM0rjXtS3o2eACRyIXhE1cWTgyBA2Jm15/2htItgjLkWPZOaFto1rhFCS+6nDl7IpQ5mQLb80jCeS8L1JUhRJqwYhf43vvgkftlzOexrkZAEpjnP/CnWTXCTWUgcp6P+yd6boSydmulJNO/O+Mmuik0axaiqZpNOmxxT5D5TyOL82YesFxXx3/87o/Q9KBdlXdYxkk5U4bslJgOr0JaLxdjYAFI1XxnBxSzpx5D2GLtzqFlECmDVtR6oqoIuT68TZRm92BibHwoTGPpMvcHs8JTNf9SPQ5skl8QszdcWCGuhKq05Vpm/MKegAWPSR/SWEeqqKZSNFi0p7PnWsF0ur2jg5byEiDWI5q6G1WdHcnoS6dCSHdBNHDFZsqmT5g3PdvF44ffRFqYR1oT4BOFzgcoQtG6EHRPi3u6qJAUjFLnUveI9JCxDxx2tdSBKtyJ4uVIdvMmQ7k86xmeAy+sEoqLMLbEoWnufGluusYttnF3TTFZYkmIA+rj+WGVgPfkCKmOpjFF5JV3vxCfqQw8XSPaoZtriXu4oRckBZUapBJAEHZYEmdKfYNIVXfKG+vXZQMRIPZUPqzSSjCKthX64eeUTwCGM/QzgxLlf6hicPeCyHt6pFg+CGdUBevyivkW9PEc5yMsK492585Kg9OgflQBOxaHIUdwzmch+G2pQxgPTfziWuEdW55rFRtvVnCKyCZGZ35LRLb9fVqAE6nzG4CxSqLy+y1GYKu5v/xyIlfzqUZEP8insm8tKdXhlK/3JpW2yq9VxUijbDxfxEFAR6P4KLW6SRndHKjsu7OVt3Pjt94L4giLVJ8A+fuztUfO7VrNskjdVa1LlO8JgHX3eaPVnyHbA1ucmc8Eo4fJWBZK7URmbsB41D4FZGtzAYFT++0KJgkV+c3llEdKsjCrQcKW3GjI1JjIy3WPpddTF/mAQ1h1Kch91
 7VUdNERN
 MtYOxvAZ9rr6Ft8CP3h3SuZsyjlXNnAg/FZasdmwLvO7TT5VWrkEbla/pA5M7dL1kvx5HqpwOwt3CjxGiKozy8yFaN1XcscHCBsdlxi4AU5PjEO5mBbSqB0HeGUFsn59205f1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm.h       | 8 ++++----
 include/linux/shmem_fs.h | 4 ++--
 mm/shmem.c               | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d3..a40a3c42c904 100644
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
index 13cc51df3893..2f765bbc20bc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *const mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *const vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *const vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
-- 
2.47.2


