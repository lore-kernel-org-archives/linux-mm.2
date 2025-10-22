Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F4ACCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FCD8E0008; Tue, 21 Oct 2025 20:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178398E0002; Tue, 21 Oct 2025 20:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BCA8E0008; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD20C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89C90C0605
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:24 +0000 (UTC)
X-FDA: 84023936808.04.5EE3864
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCDAD20004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOeTXbpJ;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nnhz8RmEJ4aJVyp94lmGqv0dP2Oq39IOopI61ahIsMs=;
	b=IlfQNGPBmaTyKB5ofMEkGQhe6/ybkG5kdbUUNtBzojhX+T23IK6pJlw84YQ6t2y8pjzLTV
	gaSGgqsPtBH693jBY6UfVn95VhTYFNoBB7lYHFA+sDJI+Zj7m+EyTyU4LN4z2rMN47c7o9
	yJGFtCGjbnFm+X1VQvHE1n0bI01qQzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094642; a=rsa-sha256;
	cv=none;
	b=w5mO42+kvshrrqzz2c5eZ+gcLvkTRTICorlTEg14yiSNX79L3P8SODi9GjQyi4uWQDDy42
	BAWZevR1ciWUC3ODnEBBXlfOdxvKXi2lIQo4sMFxI1d+ZAEn9Ts0uRaqdRppT89VvoVC0i
	f3Vhc05X6eYfmKo88Qck80ZPqzK+46o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOeTXbpJ;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-890cc9b6bbbso939452885a.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094642; x=1761699442; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nnhz8RmEJ4aJVyp94lmGqv0dP2Oq39IOopI61ahIsMs=;
        b=QOeTXbpJ45JLlME7Ga9Wsz57Llzip/Tajby5BLxHjMlMI8haWNTyURdlOeIZhX2O9W
         1bc4BR5mc/dEymnutHA2qVwVBwpbrpI3jcIVIMa4pelDzED3Px9X4jIn6mHD5najN9xB
         4FSASw6RCHGShQly9Rw791q/rbQNZLRebaQnTMFFHvj8Iui6rIaFtiq4yMnHZlMEsYgw
         mwzwqJxsD17mQGTAkqW9bSQN7+vwSfV4FmuVqcUPIItdX1jEbAiIjRsz5TRbVf1NHF+p
         P/+iHLxeQenGedBG2sP7LWakZ+kA5OK0/As4UOqCuMiOlWtPFKEBsOw0brSqMI3T7oaE
         TJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094642; x=1761699442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nnhz8RmEJ4aJVyp94lmGqv0dP2Oq39IOopI61ahIsMs=;
        b=W7lmysKMjT15RYJyqETKjlzuePeSe4D4dkOqdcMy4lQGyQmxoMlYYIRw6+XkG1rfJ4
         2Nn/8LC3I+mnDqzgNh62JcRnmoDrfiStQkrMzKqBFi7Y39xIJU7Eexc9tyHrY5NcDn4P
         XE/ur6xQr3rhn76M5gDqVxZDY5t7WYE8wZGX5HyfUK7ttJjeRzxOSBidWufERAgCpt0B
         t8AXggNTrAiwn+qB71LHtoOxfGgAG1nLkrtmjqeKctH53Lj/sdqvDvi6QgicG2eIgO2r
         84Ay/solQRUNjR8lSuQrE4fpzRVVEj/EM1mTYkDtf1JNn0qTK896hTo5KTh8XYvKvDmb
         8P/A==
X-Forwarded-Encrypted: i=1; AJvYcCXAUJM+kn8v3CHt5Ha1+HnXhphl9b9Lzfl98gIlsTVPIv9v1i06j7Ad8mK2IgPttUeBY1SjhjHMlw==@kvack.org
X-Gm-Message-State: AOJu0YwnZ6ZuX2crDPs6NARKH/GI1ZzvJf/KnWvagaf95+9rCvpsFQd1
	coby0pgtK8N+/J+2x7Eh+Rq41YZ7hRa3sVXfPQzneRBeccTV8xeoOiMF1rQnWCZji0U=
X-Gm-Gg: ASbGncutbjARrpXWfYRJ6AW+XKgZzfFWU0wpBW+/0VFMdspr06uNajDIwz/NtDZ4jrQ
	7XVY0qjedkUvRrcolhdSDOpO4c779fPV5lv1nyJPVslAqfANnCBrFCFcCvugDLUEh+Ok96Y77vJ
	rPsDhs6mbk9DVJ2W6XCbJPs/R/N7Th5qHLRb2t47mCXBxx5zWwwQ/cs4Pd0Qt6w2he8WCAWjlbl
	XFDHnpenScwbEUEgNo8HKUYywIGP/91w1yBML4KjqH3xmCumyc8PenD+TD99tqT5B2j0X7YMucl
	9BznNMkgcZUIDQpn+BdFqlqx98NjT0jRKA0IdwKFaBNM8dkxhWnfK4YwqjdvSxpD/PjZLLrYh0r
	I3f+ujp5UNuV0af5hVNi8eAs/W8KxiV+RLj478erBF4H8stCw40RSBqQjg8KUKoY/kjWI5T2QcA
	cmNxk1652EDSLj+GIEx7xZwc1MfkUXYxZXPR170hq1ah1PN4b7xN8Lq8emiozqlIvNU1cfxxQyQ
	nGaRsaIC5ZLA8KjWkxPP56xV4VHu5If
X-Google-Smtp-Source: AGHT+IEaIzHHvFJMRfSnJtfU36gVB4GsmRc7NSrbXKPCCo1QHLpqLpx5MupgzuVuHjY2hx1vePG7Pw==
X-Received: by 2002:a05:620a:3186:b0:877:bc0f:985b with SMTP id af79cd13be357-8906fd1837fmr2516115385a.49.1761094641789;
        Tue, 21 Oct 2025 17:57:21 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:21 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCHv7 1/7] kho: allow to drive kho from within kernel
Date: Tue, 21 Oct 2025 20:57:13 -0400
Message-ID: <20251022005719.3670224-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: jbiecu487w5gxuu19s6psi538i8wi3b1
X-Rspam-User: 
X-Rspamd-Queue-Id: BCDAD20004
X-HE-Tag: 1761094642-686209
X-HE-Meta: U2FsdGVkX1+M+yucbHk6zik0C3F7zdD/W/jVkxJORd+9kw8uebQo3NvxEbwBPz5it6K53AVyIYYYQyvTQcFbysaKxbCdHTSTGpWRRnGv39i/enAbvt4fgKWg2CC/VOJ2TeGuFTDs+xJktv+ZGcQeh4LdEj1OWK+IebLsAlJtUYeyTvNx3ZXQRR/F844eLMt7gj3GwzUxW7hXUNQ4/lmPJhFRVSlxIHqaOlLrbTeOvmoByLFBzI6GskGl5PV+lmSGz12nm2AOA4cM1UNyxKpcvJybwVIhf+f2eml9+Vuy7q/xiZlDJ70fkVcL5NIXz2LcdS76YOzMCbGSQH7YudKifjmPT1iHotnrwpXcsbX/BnGkY9MW2RPU3cNklZRicm4iZSZ2Om4wVx9w4e1ugxXHQD+v47weYbMMEvG67dLVkdybk8L0Y477YSqPMcu+ddTH6Dlv12EQ4XakONdGE0C3HMhBZdT20GV9YNbpZoC72X0mR19G/PDgVTH+ShonnkeupMZ7GmNWcOf4EwJkOPgupSpS0+y/BLyzLV4xMlDbX02+U0AxU2ktG++TzcZEmrxR36mfXk5ILgZL2H24zAxuXcsZEDA6RIFtPM7MHSW5w464Rd+EvAcyqgDMMEBu7oN1XP/8B+uliQIESdNfah1mQOOXPvE7ux8D6Rez9jQyoKlIkDoNaf+q/NOrx6gEpxZiFy+VdIWd/EQfnKeL+MJNpwlqXw5pYasPqRf2XaAjQnwrthLuiYNrGa0vPWCAr4Gkv4GE9PPl+f6qFlyQkrGb0xnSHCW8rwYr0mCKB3hUV70Nb8y4BgBoGXYvUf4qtCQZIsRn2DMWLpMm9qG9VjXwTBamv9VEQM4vtcXOX/zcNrpU+gtg6U0PKhl22tQE3xgJ2uU9JS+LWctg7O45NFxHPBUsXKzBiA9Mh/rx993finNUsM6ngsXbozkYg9c9C7DiejTH/3b2FDXU8VlxzLZ
 H390F+s2
 KgSHPd16Drv34JI9G5ceTFlekLC1NSXHbbh5rzsDjZIKRIzWH3yzO/E5rtF5GbkBKKaPLpaOA3TRu687QFOHfKVpilndGRXUdbTC3xVC+65Mjj31/CgCO/1pRc9214EIWQmTZgfW+g66uoAcTE6zABI4DSITqU4RYdgvezn90vXjibyLIHjvsl6gnpHYpbrQMRe7IlKdBTlpm5sBHIvc8PpqdQIfRkxNwCG5q5kFiXy7fNGPZI8Nbw9w0KaHo4uDB5Pc5/H9hQzKCqHuFQ8biE/ZL5Vjh6sViQnbympodU8IjHiP5OWzMCZiBNKw6moxdORjM+C60nMYNfEt0PqOLTPkCdrg7mhnq5wJlf9qoGVzd/aWbMV/ZYU8x9u/gHYxj+GNP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow kernel to drive finalize and abort without requiring triggers
from the userspace.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kexec_handover.h | 15 +++++++
 kernel/kexec_handover.c        | 75 +++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 25042c1d8d54..04d0108db98e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index de4466b47455..6458f369a346 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1087,7 +1087,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1120,7 +1120,27 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (!kho_out.finalized)
+		return -ENOENT;
+
+	ret = __kho_abort();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = false;
+
+	return kho_out_update_debugfs_fdt();
+}
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -1163,12 +1183,32 @@ static int kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (kho_out.finalized)
+		return -EEXIST;
+
+	ret = __kho_finalize();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = true;
+
+	return kho_out_update_debugfs_fdt();
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1178,35 +1218,12 @@ static int kho_out_finalize_get(void *data, u64 *val)
 	return 0;
 }
 
-static int kho_out_finalize_set(void *data, u64 _val)
+static int kho_out_finalize_set(void *data, u64 val)
 {
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
 	if (val)
-		ret = kho_finalize();
+		return kho_finalize();
 	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
+		return kho_abort();
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-- 
2.51.0.915.g61a8936c21-goog


