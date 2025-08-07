Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F1FC87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABE76B00B9; Wed,  6 Aug 2025 21:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D666B00BA; Wed,  6 Aug 2025 21:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5246D6B00BB; Wed,  6 Aug 2025 21:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0D26B00B9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0533E1DD575
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:31 +0000 (UTC)
X-FDA: 83748269262.29.0404069
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BB1040006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hU5Mgtfm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531129; a=rsa-sha256;
	cv=none;
	b=m44nlEe8cD1lqL1wScLsVokFV+0WIKP+/h5p1dUq3PtmBzULApoW+CujsU/9VQu9/jQ+WT
	lbMMg0hnGwbUaflImtkTKXolz9PtvLpUeX232oDgLf+kh4CyZaWrSJSwwWxnmwoQvUwTUw
	kKUb8D8kYno3PySbx5lhRFBbG+5t9Mc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hU5Mgtfm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNpjHXepLLwpraPv0r0ol85rEMD4xKPLfeNr8R2KnmQ=;
	b=4lfCANEMdc1xL8VLVWYHT1ozJ4E5qo+s/1TKpcMM1FbJMQrTk2Plj9UYHusbcfhI9H7b8k
	HVpeA8bldkw2GKSylBsh6U/mA1U2Was67YdOyADjj8tDAOZM+OXmgIJzXuait/WeNBnVES
	dq0/xs9rkeGhViMsdFPRxPnpuS3CrKY=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7074bad053bso7678336d6.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531128; x=1755135928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zNpjHXepLLwpraPv0r0ol85rEMD4xKPLfeNr8R2KnmQ=;
        b=hU5Mgtfm4Lev5aJ+8ijvjQInfMYO8aaLkc0YhhYJTyEb4uGDvaSmlA0xH7GcQ6YwcG
         3AW3AhqYw+nZVs586gSciB/7I5kUVdWnFTnY/pT8zqKCYCHooASb/DZnNgFc6Harivyb
         jC0p39coHAWfmYUZS76rWOq6LhPRq/GX2gtagYKJa9Ex/ujQVTLHgk+9W3QMDiSrzrGx
         Zs2cw9F8eCYFBFcqsgtYYc9hHbF689lMGP37myu4g277Wx6cD2MVAeem6duGN/XhNOg7
         RJQjA2EvkEVocGQ2uffxVolqOTioeMPZ6w7HKfh6JYMxldFPuWPp6xRfhjjwJFdYvvng
         P8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531128; x=1755135928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNpjHXepLLwpraPv0r0ol85rEMD4xKPLfeNr8R2KnmQ=;
        b=vWsYN+WekL709oKwsffpwvG1n2Tb/EHKjOntGnah761xPgPV1ec1JUzpe+IZkmAp/R
         Xek0ClNtGVLUUWikraNnrs96CbhZtJkJnyzk/QYDurLhTW8/oN7uZ3ailaZfV/JjLfxc
         egalADvt8MYfTpjHdqVppP7cFlA7Ve1Wpk/ZbmA5KbpTKUI8Ufhqxo4XoL9HNMmIuyr3
         7j+gVP3RRQ2kQ5oiwVinJFw69xiVYXN789iipIQtKUsLJAMMemi9FB6Xb1EymI6PAdVW
         Z21KitPTwNWTOzXdcDk+o0Pg3AMIkFc+I6Dj7lldesxXLUtX1ocB9vSIE2qtOPKVrmoj
         UCng==
X-Forwarded-Encrypted: i=1; AJvYcCXlh4twCYNuzsipWueIMgNW/dcroMC+t7qAa0vy/93wgilE8gj0NeNSJ4CfC40jqsmAtn1ah1XLyQ==@kvack.org
X-Gm-Message-State: AOJu0YwilqOZtaa5GUmXHg2s5n4sQvsBlmb+q4vtV7S0b4h/xKugcRNH
	bi0qsd9JGJLbqrw1PMBv2YL64ngjd9Oq4q08rfHlPvAL+OBSB2A4pG8NNeiS4QHxcQk=
X-Gm-Gg: ASbGncsn6v8nMU0vYzbJc9WVi5owKCzmSynzaAtr94WSgynDTJQf7hbP/bsWwoFKLLc
	hlsbVO8nYObDBRkFkil+es5mMtU+dVI7oaBY6DKPYUkGGUsaLwgX1UteXyylDU0nSjV+cjV8A4J
	I/12VR0+RbycubBcVg/7PVGLHnjUfWKo9ooYpoc7nX8UhybG7Rauhm97hYV+TaKHGV4oho+wL6j
	1QhvAji/wtabRqZRkDlY1rXtYZrSn4uQRVApmzZFASokiW7OJc6cb1MFEP/zBWVenfZxqWDqMgn
	rBLQsoITCza7wR4rRDl/h0/39g8lc9jWTQoyPF9XZ6U1x0TO+bRhlFqkhhJIl+Ze27iXPeQq3A9
	f7rv8vFBYPRgYARnHugjGfllc7hhgtLhLCUsRxezV8d59H+oRx4E9y9D6+vSQKM7q3hxjnDMp5S
	WDXJNtoFztzE0JmeJbJeoKHic=
X-Google-Smtp-Source: AGHT+IE5gyxbiCqCqrXVqnuWA1mkhz9OocyomyZ6jSXE5mTuz1p3dbFY4IvWv4kGZUKx4DkAznRCTg==
X-Received: by 2002:a05:6214:76d:b0:707:6977:aa77 with SMTP id 6a1803df08f44-7097969f103mr61593626d6.33.1754531128252;
        Wed, 06 Aug 2025 18:45:28 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:27 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 28/30] mm: shmem: export some functions to internal.h
Date: Thu,  7 Aug 2025 01:44:34 +0000
Message-ID: <20250807014442.3829950-29-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BB1040006
X-Stat-Signature: ccywpa1hoxci8h6fk37bufpg88kquy5e
X-HE-Tag: 1754531129-976240
X-HE-Meta: U2FsdGVkX19UNau0pfloGoKUyIeCo9tsa89G4PLxF7+BMsyLvisJy/a2bb6HTxIpoQofBoWKomaqhkEWV6ntd2+exrenonEgRMf4JbJ37uJgnix8IwRC8iB7SlQJ8XtAf6ZEyebiH+cI476bLosm218bDbsCrBZnNy8F7lx0W17W2Kzy3JwGLYAlIWPS0ZFjFaEWhjLemEy6s2dR7v3hpnzjvYx24uSFuNqkt47gipB0aiSmpF9jrv8j7cLwbRHkRRQpxTjZcxpG/wlAzItJ5q9mQqs9zzjLXZMta12w3DQZlveD8Y6aG+XPo/quQ0g1eQwjxEynf8hJNFsPV1/7Z/nakPV8sU9d6x1RdwKaUqPBt21m5kse9O/eWQ1h4GtbPQ82dCPt5WyUki7N/QIS9lF71iiT7rCX0xDR0HP/FnOUZIEaD07Rx2ZOwfdzz0X1ArRa1lcnWOAg4ECTG6NlawaQmftuBzMYHLddAbrFF0QSF9ZWN/QOz9LcJIEM12qjD7loVK8M8k99HhDe1BPxoAIX08NeuCIXaLO6FFdeOab6vG2lqpj3w95f7AOcKZ7VQ8YTDJFT5FxSRUzhxvR3Rs+LU+gP9nPUYn7C7cALPkNtGEL1haNQb2IXVy01ZUQf0mkZ13o3bidR86IMVodZmabpqCjdQjKrLhiri+qPhUOEybXHICAWNlUFDbAzGAJFG6HsA6rCUSd+xgJvJnhdS6f4ZQld4Rg5iKj8ajoayZQ525XrPFf6eXAsh0zGf1Z+Yqt2jMYFsI3uyL6+OAy6GYtyw01/tY7tomv7HJifisPtXG13PBt+3yf5numtXXyuzTpnKe98hxj+ZTNhILhQ4p+K9vB6WHDhnejM0cLDM8WkRFvo+QJZMPlxdO81Pc0FIbHL3P4hkbAJCxBld1wKYGVxUMWXJthgsVSuWdEXTgY1+hja7R5lYj2idEmU+ny6Ucf+I1UauSwO03hssiU
 pZCF+9Ug
 c/usuqzhqSCEuQyjoaFdt79hdwytQWxP5DFVw674egA/vB7eoy5iH/YL3pWjQCGKj7cXYutVbEjI36MHCsl0LI6/Tece+xdQNSiuXY5pg69FDz4t6u2pmXjL9K/BtSRUe3xrH02myXkDtyC+MV6VtARM8Yg2nh3LL8ZhZtj7W1gqBt1wFYMvpjI4Nzse5Vq0Q6eWdmbOUQbiz2ugVzVK31LZUl8a+fWF1BzO3B96yRJoGIofrgG1JDmpAvPTDnwhwpn6ltqnDNX9SzsBFRXDCpJ4PzoOBKFkRNmhknxENmBgf7Plb55JTElQ18Vz2jqW6yLWF4THbyCfBxna5Q2SjJ6cIInFJTL9iJOuLeDnk2sskZHKa/rmtlGwMaPZTTd5IUC6DU3ew3z+W8TyIIXDeS51Ts+KvZooqtxD8VQF8tzbBRHwMjhi//53z6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
functionality will also be used in the future by Live Update
Orchestrator (LUO) to recreate memfd files after a live update.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/internal.h |  6 ++++++
 mm/shmem.c    | 10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..5cf487ee6f83 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1566,6 +1566,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
diff --git a/mm/shmem.c b/mm/shmem.c
index ef57e2649a41..eea2e8ca205f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +435,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
  *
  * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	bool first_swapped = false;
@@ -898,9 +898,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	unsigned long nr = folio_nr_pages(folio);
-- 
2.50.1.565.gc32cd1483b-goog


