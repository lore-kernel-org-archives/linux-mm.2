Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BEACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7538E0030; Mon,  1 Sep 2025 08:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A568E0013; Mon,  1 Sep 2025 08:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283DF8E0030; Mon,  1 Sep 2025 08:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2C208E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB9F713B0AA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:38 +0000 (UTC)
X-FDA: 83840614956.21.3F54514
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2976100005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GEtSQ5Q7;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKIQLUaaWXpeIWzcvUskrPePOLIqiIThIa1QtzzvUMQ=;
	b=WayxG4IAl5mOPgxW7gfxO3HWmTw+Ab5rkLMMa0FwO0UNLSGHjkt1maV0aJHZyLcYhv/vww
	XF662U3P0ZpgTo5aRjFBGfObvkCxjCvnV8fAnNYsRmp0qebbuiESevei6aNU9qGQeUXRgd
	E8MUAZsTKoLZi9D2atwWLXCb17kBUnQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GEtSQ5Q7;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729836; a=rsa-sha256;
	cv=none;
	b=d5lRLDhYxOh9LOb5/ll+myO/wz2/L7ZAaNJDC2lcWEM++rWLKBSrMDY1JZdaR2wYWU6906
	aIRtkmS4ed7cNQiEr3Jbv9ZSqLBEfbtZz5jWkuHHHjflqRxgkFCyWKff8ukoDHCz9RdqfN
	W55fR4pEM3BIZXlcouJhMosjipDZ9W4=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61cb4370e7bso6395380a12.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729835; x=1757334635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKIQLUaaWXpeIWzcvUskrPePOLIqiIThIa1QtzzvUMQ=;
        b=GEtSQ5Q734gHrFRpzbOl9ccPxjoU6IRnh1aqcXXwYEKcTw/umYl5ySgsYQKqWt+Rg/
         M0LGF7yaXfMNjZ5nvDsFCbxLdmeYTtGwCEn8HE6Ax3WoKzMu2sX78hOxmNqSDacNVyk7
         Yethb8tNv+c2LOKPDFga6z8V18+6++u1ZDX8lE0oFQfQhPTlAg+woUMTvrw+sc+Si6nz
         r+9KRW2vNFO6aLavZSsSPPhBsWmpOZD6//yy0mjM2Wm5mTF3zB/5A196CiUYRN+Nr9XB
         vY5eM6ydWQZQ12d3/P9MDSKeHYK4Enw6+SNfQSlYC19kTMo8fmIS0Rtm+0oY72P7RBb/
         nvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729835; x=1757334635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dKIQLUaaWXpeIWzcvUskrPePOLIqiIThIa1QtzzvUMQ=;
        b=ah5COelipTgRD6PmwuoCJnfgGFkV0zcl52EXdfpzcj8ou7E3UoT+KbH2mQHh6tb55u
         b8dnbz+0rciYa+e5F+wI/4o9g+voDiTyICc8KtquR0kthbe+d2k7vOi2Ge6Flmj97ga3
         FzmtN1eA7IeqrVI/WsK4ppi6RgoIbMG7h1l9n2DShmjLK0k6zktIv+tufnkzyrEj0uXG
         iCtcKlhOw12E1CJg+xukoL6GOHgxgXHtFRT9bVQcDAfzuRrHT+iG3+hiZ9er5a6S4miX
         LUv97wWfX6/FFzlPgrK8sqPDvTHhiL2T//LqRaxuRaavUcS53vXb4kqJGWZnRZiYbTmn
         7Lxw==
X-Forwarded-Encrypted: i=1; AJvYcCWaIN4/PCt/eqHDbpQzK5HFcika8gAMfWO7AoFgmhm3zxTOnQYsRU8Ox5/al4tJA6W7Yih/XRvk4g==@kvack.org
X-Gm-Message-State: AOJu0Yy27optZ8ZoeU8cvzOh/hwnPOMJh0Tzhs+cozNWajkojWWu5qyr
	EemFT57/uYHqi6f2UyeuJck+nUJM1nglrNn6ZfaVVmKElVpZEZ/P9Hor0jWQsWPTK3o=
X-Gm-Gg: ASbGncum61a45AS3ENM8FjTJ5ds3uOL3JPz9lhPG7IysO0k8ZPqriTcbgy5Xe779ILt
	5wG6/pYXEnwxUjhM+omkRz69Uj/4ZZ90KlVozFVWTrSqFUUpUpq6MOJVMOggpVchr0TvVdJ2cRP
	8PWmi58/VT4FnDZyFGWdEe3JwXsfcO/lsvK7Tmdg0vOZHAUCwyEWQRo1o1Ck1QFlzy0fBpCQgYL
	bbJTy8J4ZmatkGvcBK+YH7r561Ob1dSv9V2Kzhvz7e6xazA75wusy+vhtaHBhygelgNj2wJ89ul
	avKIvOUl+DMn2Rlbe4ULv66f9HStbTbJLRJ7OuFgwpJqVt/jvAto7LVzOU0GQXhcevQyAR/nBLE
	XJzXl2uLyMeHq3H7ufBQnYqxZjRGmmpoZ/X/pXHnPpgIjbP3GLhfDxMyLBhr2iBYYMNazQBieQW
	oSsyT2uplcbvRH54Qr9IpT9g==
X-Google-Smtp-Source: AGHT+IGDWKKpCY+gwaNyKUXSsMGebFFbg8AoojoUj/75zRe+ebpEqmLb7gpe5dy7vu7IufqwC7egRw==
X-Received: by 2002:a05:6402:505c:b0:615:78c6:7aed with SMTP id 4fb4d7f45d1cf-61d26ebcdffmr6326182a12.32.1756729835027;
        Mon, 01 Sep 2025 05:30:35 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:34 -0700 (PDT)
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
Subject: [PATCH v5 01/12] mm: constify shmem related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:17 +0200
Message-ID: <20250901123028.3383461-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dmwbz6dmanie91d6pmoxypq31zd5ffeu
X-Rspam-User: 
X-Rspamd-Queue-Id: C2976100005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756729836-31242
X-HE-Meta: U2FsdGVkX1+5Nh9jZJzGQ8cvN2Q3G4WEWpC+WDd6pXkBcI9MoEPnj9HpKpzOoZ5Ct9SOyeZc4CpFJEfo/8aMEy5esV6/r2iZZN5Hndvvi+7PpDizr9w2G1JcMmjtks2ZIl9aVFOtUxIYPKaSMunIhx2q4UE3GyD8Vsjv4oc0K7+F8bKa3BV5ntBVv/7zx8fjr9RMHCv0mGWQjElZoYikieJqcsbKtTDabZ/MZ0eCnJPcftVilSr+Y0TnKtYPd5a8r26HIJfjpzzXrF+ltFXjVtG+gK1Oh5OZoqAgk6H93EU8m9XjMewoPThHRxoNuyk9NKj1XPkV+/e5QKrPULS+WLmQ3Qa2gqAswos4Lyr1ZUwlUtbNJneBQjplgtXJZD+6KusaD3BGHnxdyDKcAQ6CvrVdX+T106mMp65w3OsNLDnjDX4EW2uM/osncp6tumngfyd/Nb19w7Nk9YOzDCPRo8Mp8f06ogem4wE+GA/AmOrmUEvAPxxlVREHkiQtVUythleKkDu3+xOZe8SJr3yPtNBEbLNG7NJgB3LLpzs2BvHVvGKqtfsk30Jeq4bMTOWI31cbq918wPxpyq0S6nwQSk7VkmB98yNifEqLyzAw0dN9PBW2eO93rfwunQIWnRnN6M6JA8KXxCP8lgLibPcer7QsfOQfDqrvLOwsyPx39eAVyPcRBqqYH1MsVv9tjLV9T4EXy2zW8zRD2ZuuTaMvVgEpNcQip7xgJTc4Gee4Jloj5SbOcp7KZDQY1H7x7WAkuAinY1qU07OGTskpQlhszkYj2UzFGXwEAq1MuQgDh0Jb6U3xuGb5PfFnt/FI02cki8JQ9IgRmxZCmhyDku//mkjJaa8sA6N5S9bAmpP282KayVHcudRSicXABScoJAbk/9ONvMSg6ckaXUoAAMAtpQIdIosPGmZwlrt6CozpqSMNiL7nQPxIEIkGpAm4YjvFxqU3El6/MibmfjfENJc
 OHKUxZxf
 FovngOBSeouHBCZSSuGfJSohUk9E4W83lUDJxEywh1yf89+NssmLxGVvFVZBYebPhOC48oJl3oLnTOUOfDX/GyhcHGnq3WorME3p9XCqctgJVxLbaL5wY6sQeCXFionhe3B14a3lpNP38SVL/qD1HCLpvzQtrkdrkWXef4xISgmUzYrBaUJ2x9cQw7sX85YBlpjU8NazM76vM2NNbQQA9iH06LaCHwbEvaXaf/a8JMeRJU7sh0wIG1yL0iHte/Jg1P5xrC7jzL4OjeUNFm4LCw6B9jY5gK4v/IElkpzn4Jc0m8fwaANggSHAF4MF/S0d5BwE9/JvgEOjNtpcJSb6kmUMSkHxD0q1TJG4zbDu0yof23kUd7i2vDwxOr8ka5QuNYnuSn4j6mOTbUr/v5eUmocZ/drB6fNRV2YR53JbNhZvdlj7bHKVUBK4aQaAeBQo8a2Fmsz4dynuDFcI=
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
index 640fecc42f60..d55bceaa1c80 100644
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


