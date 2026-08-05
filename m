Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDBFC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF2C6B008A; Wed,  5 Aug 2026 10:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F866B0092; Wed,  5 Aug 2026 10:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86126B0093; Wed,  5 Aug 2026 10:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1CA6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26B2112048E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:33 +0000 (UTC)
X-FDA: 85067481786.15.D8959B2
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4883940009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FqTB+8Z3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785940951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awORHCEFJ8S0UqHq55puPxkhFlpDUSfBHw3cahKX9ew=;
	b=SM5wYJj/g4v1uwXQ47lwzRLOnB3nA1Hy2mRwT3lXXSUszRL5AAJu8FJj/YpWfPXpgEINrr
	MTcKS27k7pb26fTZ7nifc1UHB2BIdJbdrdj5/aO1TKfAul1N/dq8xHPeOrC5yUARCJnnfh
	KDcMHJc6n2Ku6K5npUFCQZyjDlSzex4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FqTB+8Z3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785940951;
	b=1+vFK/zGSJJ+D6bcBZDR5MWvebp4QCEQ3t8mNwysRqxQvnwUfPWpVTHjlZxHOUiFN8oQNd
	WvwzF0fcsfR3Kj4XLH2qGjpPnIj/ZgdwOb8k3+j4Ujx9qpRbQEJ4uYlVJBJFqCr4GfK84g
	AbH6JVTZuwSnI/iB+c6Ib1XafoPUZVA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso746362f8f.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785940950; x=1786545750; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=awORHCEFJ8S0UqHq55puPxkhFlpDUSfBHw3cahKX9ew=;
        b=FqTB+8Z3u2gQgpe7qJ0XD+YdDtFtgcBapnOA/FPTuethy3eTjKmqVR3zdalckiGdNE
         rej+QqGPROhfJiMl8FKt2HFQbuNpNUaBajYd54pdBlVcSAtMp4CfcmoX0qNjF3GO3tWw
         NIapx2Z40oM4yanW9ehkB6Ej9OkmUIuPqBhRSBajFMd7OBmrbZDPJ3k0WyC9+IF8UMHc
         5YEXRVsI6M2dqaFYi/usGYcVHX+SNyRqU7gqMHyOJz6+WiFujSUVv8e1zY5NSk6ANbyj
         /MiKGK13/V8bomajx2Wb2WQp5jdzRLCOsdm+lUjGlDEcJYV8uNq38qA1nRYtm3vXdOQC
         xkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940950; x=1786545750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=awORHCEFJ8S0UqHq55puPxkhFlpDUSfBHw3cahKX9ew=;
        b=SpsnEdaJsH+/cxiumqUhOnnH6R2pNjyVAdHlk3F8PxnBFOtaA+gFavuL8p38jbfFMN
         mC7jTSBAh9BHa9EtEh+VE0ku1FkhGwv4RStVmA5ORRLlMZKAK5WH4Qdqd5Erhr1sjq5N
         gl15k3q1UcN7UsZJVR0jr0cCSfXCbwHOUwhBpGc0YS5hwCbARCC8DLCacxnd79ANUkyl
         khOfL9H/TDXWCvL+xQO4KXeEAZkQ877xwFGFpjurABSutmnLv2an9/brp2ivS9+F4j18
         O/IbIamZ8Zm/XJeBDm8kEbOKlg7tOlcZ81NujiVmLE3acI3O5OHO0LRXcX5wALj9ghd+
         ojQg==
X-Forwarded-Encrypted: i=1; AHgh+RoJgmg80w1FqLWdtstpXdJTdbuTqweSyxGUgZNCJ1ChfBfb0p0wii4awi231AI20U9fpwRJztjdfg==@kvack.org
X-Gm-Message-State: AOJu0YxyQ3NeRZTKNifNYW7cBYbgaj54qlDGuZONsMQM1pzuDA5vHdde
	nEjxOMmyzmuvPBZ6i5WEFWkwxdXc75MykOBtYoP/s1Mvb23oGbwb79nF
X-Gm-Gg: AR+sD10ibwRttZDsHiHEGGdoxTXMTrz8+OAi+L9nB6N+QCK0+m/ASLjU5/5BYOQd5iD
	24sZHVIaOrLTTkQHlFQGjz0SmnXhaCmfwg9eOE8FtPILuca0ZOE85CtDWgPiU3g6TyyN3zrfkH/
	tV611XxjejPsbuZGwDdpqkD6YUhIWaV+3IHoePPioO9xbJpPOTdapkgn/HxB7HdABE1ZBQQ+C3d
	oe/uiBYzbIMXo9sKn/EIYFc9aiM4poAu3CatT1mY3WvN3znIrEtBIDf1IBrnIN8z0EoBDDhpEW7
	84GmCFw3dczY+TDO3ms1qLmIzNIWCLcrJdAOFCYWihSEKfo949dkcAUWpfrY3myrRrMxCJI+6Zn
	qYaag8lqNSjpJDkauuds4GbS0/lxG7PUiPgfjeQtti0I0EGvPNjn7eMXlXPvF+2IIGEEdOZQsSa
	OmOVJFqG+B3ST8JItTIosAAKdG8YOoQU5WWlYQilg97daCCofJBtJd1Qp5EjBbPrfzimvUfbE5Y
	lteJgU+xpXI0T7Y3iSbCeY=
X-Received: by 2002:a05:6000:460a:b0:47f:8866:bd6a with SMTP id ffacd0b85a97d-47fec63a8ddmr13340683f8f.19.1785940949557;
        Wed, 05 Aug 2026 07:42:29 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:6df7:ffe8:d01:255d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232333sm10094289f8f.18.2026.08.05.07.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:42:29 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2 2/3] mm/memory.c: simplify error handling in insert_pages()
Date: Wed,  5 Aug 2026 17:42:18 +0300
Message-ID: <ffb2c5669a69aeafa6c95ce792326caaae938ace.1785847364.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785847364.git.thnkslprpt@gmail.com>
References: <cover.1785847364.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4883940009
X-Stat-Signature: 6mrmiutsxkiprnweshhpnfwjinf5febm
X-Rspam-User: 
X-HE-Tag: 1785940951-274819
X-HE-Meta: U2FsdGVkX1/42GOCywuES04dKUYdm1u7OIeq2YquEcqf0q6Kb+Dqsv35LAxLCH6UEe9bhJ0p08oN2jqjDzNFuI/g19Os6nZ447mV5fqLYO8Ah/SObZV70qFGp8wvDBw60mqujOsk+o8uO4uLiKXyGoMJQbGOGIAyY20NVPUXrwqxpBfh073qNhZVezTUdBqvOcTOMHp13FBgPhQJ2QeeKuuYabN1gMmCAD7JZVWdKgR7LVTzid4gb8ti6jcItqXTW1mQRFfG9ntm2lsXkL2QOo9DgCxt79cReFI71FItdmV9QCaJOY11k6zVJd4eIattNuIBDMscXuRcKJzmaSgAxmX2aiPrXG/5X4l9fT3UUODFGnIijAXdDpuqMYKjwYzfnfl0mdJvrgWAXZO3zT4EmytXdKIzPgcYCyys6EjXaljqD8h6nMHOIkGdBkyEKZZX2cdZ/HXjju/oK0EqfOUCe9z2LaP6RXQnX2vdeO1CRZ0HkDNE52MdOLw/lda/iAxeSXH6F6m+8+i0LL8MtRiu/hzzdVDXMqiipKkniWH37IVCHIFWKyQAMb+fXudJusHXHW6ZBNtUj6/w3J/WbuvsgvcAkP5XaSHOkS20pgPjA9FSww0kggRqBwuOLEtXyiUuTJlpiUe33gy79bswa+MDNOszn70dSfLHfNzJtF7fCMtRovj77fdFlaChujMqFMdJTtWRBOIDRa0U1J3gMFsjrgq6qnoHSuchN7UUiJzY+iiS4rgggpp1HthqrBHYgytLxz/PtPqrF9ZTb1BdLKnDnfaPwSveNO2dfVKRxc4QSZu6ZjhB/md6mahLCv8wdD9luy7wzjQiNqaMo1oxOUVnnL2wc6SbxNqybn88Vq5aL3z7dPmGB7OI19B5hNkOvHhhud+4VagOtDk5R/Vx2RQH/j036lt5yOepodK6Z0flJt7vPj/kZqRIHn434gyCZPXk4FrvhOf1E+2tcxWkiCs
 eH+JrYds
 ffJgrXYEM+lHy71XFAvdIBE0UpzoCUblaorOUvSXb+3DxceCrBac4/hKRO/7Lf+qGslh9iyxi4GWRPOg9XBbT1dfGyWov86/WtyutKa1ydJwvV5JyTACL7KK/PgzqIJ5bVtSA1vJ+tz2GxtHT1dPX/6GW7EjB6uAo7er4cT7jSP3dDok/lc5XpDWRNX06bEEfE4HGfXukkPdeHd/26xYZuOsFJWFlHnrKust6f3IS84qirEaF9cxKmomT2SVTQQ3SDtHvOT4qwVR0WWyJ8rlu8vRsH7vVggiu1pZpSNdqpECjD7MUxdA7ijw2aHLvIflZorSr3nLv6sPgNHdmu1ykWpAP6tAjC8CnxuY1HPALn2/TiWXOWWGxLbVdOLnA00pmstoUyBso3/RUqzuS/hUh3vCaHYNmM/LgDPzMk20H+COgwREjhCUzhFGgYP+enXVWvh5QmmktMT7YFfYYUMCYzl2+JJXdbPiDtVOmgyTJpQSGJY2vgCrN8jTy0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize error return status to zero and then set it as needed at each
point of failure.

Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc()
macro returns a boolean.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8658feba8be9..11bb4fb98761 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2434,20 +2434,22 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int ret;
+	int err = 0;
 more:
-	ret = -EFAULT;
 	pmd = populate_to_pmd(mm, addr);
-	if (!pmd)
+	if (!pmd) {
+		err = -EFAULT;
 		goto out;
+	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
 
 	/* Allocate the PTE if necessary; takes PMD lock once only. */
-	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd))
+	if (pte_alloc(mm, pmd)) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
@@ -2455,15 +2457,14 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			ret = -EFAULT;
+			err = -EFAULT;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
-			int err = insert_page_in_batch_locked(vma, pte,
-				addr, pages[curr_page_idx], prot);
+			err = insert_page_in_batch_locked(vma, pte, addr,
+							  pages[curr_page_idx], prot);
 			if (unlikely(err)) {
 				pte_unmap_unlock(start_pte, pte_lock);
-				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
 			}
@@ -2476,10 +2477,9 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	}
 	if (remaining_pages_total)
 		goto more;
-	ret = 0;
 out:
 	*num = remaining_pages_total;
-	return ret;
+	return err;
 }
 
 /**
-- 
2.43.0


