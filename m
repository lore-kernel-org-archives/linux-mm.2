Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD54606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjnKkOqp
Received: by kanga.kvack.org (Postfix)
	id 0C2CD6B05BB; Fri, 13 Nov 2026 14:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09ADD6B05BE; Fri, 13 Nov 2026 14:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4B76B05BF; Fri, 13 Nov 2026 14:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6A576B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:38:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B38D40204
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:38:22 +0000 (UTC)
X-FDA: 85431107244.05.E5F20E1
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C2FE20002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:38:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EjnKkOqp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ivanrwcm25@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=ivanrwcm25@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794598700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lprKMd/Cznsmc5fuL6v7XxVzYtKcce6V0NZVQATR6sk=;
	b=UWKWfxt7gQr8/IKj1by4EDnaPVEldttfutttYRpFltcRvFbwsvx5KJ/ft7Qjb0VMIknSya
	4Oec737y6/jABvVageEFneD20ryGS4qNMl7Cd1Z9nnwNl5neY8IbN16bthhGP5UdeMSOif
	N9AHKxaOsDbrfi/PcDVCG4q4PHhH0Cc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EjnKkOqp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ivanrwcm25@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=ivanrwcm25@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794598700;
	b=PZyZoXHYOmkuofs5eOx7FOF2mq9kLqfNXr9WPxmC+PsLEhMiTPIauiemxhGwkcl4n47A7l
	f1rhXV/tV570fAOsUZj2fjIT8LfKWyWbXxFYu/KRrVYU0os1siLSxx+PUrFiLWiYvrZx+I
	agioGZbtmsG7Omoh6ZyyS62Ig8p40B8=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso1592459d50.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794598699; x=1795203499; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lprKMd/Cznsmc5fuL6v7XxVzYtKcce6V0NZVQATR6sk=;
        b=EjnKkOqpRwrArGQjG26NJ9m19L5v6nsbATs1vWANeN7gW9CzgIZTkdyKsNk/viGPuS
         JRMweY/eeh+ikynDaTgxwm7EQVCFe+MKLASyTAVbZnTZNHra4AahQ118WiAyIQldEvm5
         fXjTqJLx167rB+L5suo8J6Mg/w5AtHATzd/q4ABWp9g6tO8t/XV/v+EWh4j0tZNOSeef
         KCIFWvGggeQQliVCgBEthFOr4JPr+06gL3utiBmkRH5OEoYyrB56yl9GyG7Q6NFga5fn
         YO4PMgHCq1Pz5dUFZ04CAYkiV78L02TDAe6RleMyJRz74qL8qzAn8bYtftSri6fcZf+Z
         9WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794598699; x=1795203499;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lprKMd/Cznsmc5fuL6v7XxVzYtKcce6V0NZVQATR6sk=;
        b=LuwvIwGsKYOqnnM1FSJ2ueN/QismlbmTiSEN4rx725qIeK8yqi31RdBw0/EJM6/RBM
         0C+eLdQEG5zSjfzMK74HiK3VxmI/7qWKzufKhN+gNDhgsfj3H+FkiSOvuOz616/+MpZR
         LE1CbGHA5XTk74cwTbsM92RhFahxTciTEF8z72bIFfqebgp0kPZXL363JaTyRyWIBFmm
         N1aU9UYdJuBDID1zdsm6Lu+MAnooyAaZTcktZyUJImwW6oATJgCl9o/S0La/lllbhP4V
         tGZma81jk75MgL/iIe9RZ1q5+NxsHiZE/YG5ixAU1U1DAQ0iv0aq3rMgr5pVpyGPkgmJ
         TLDg==
X-Forwarded-Encrypted: i=1; AL+hErENgrpDMvM2b0w3dRw3f5PGZ3mUcW8ppct9ZM5sGxwlA2XcIap97Ieh1Ul1Q9O9Un1hacX175F78w==@kvack.org
X-Gm-Message-State: APuU4Z8KROggn/4LqESN67oZYpkZ8IW9MptAmg16DKBEcOhIJRTDeKVQ
	y2PXVoBVSC4+BmXvlShRfGZh/rabp/sMJ/S839aPIiR5KPJCE8SkBJWj
X-Gm-Gg: AYBFou2MrrSYyy6IILVcD0agnn/9I9DfKUWdPrAPnBmGZnacV9y54PHsFfh31H0uRxF
	1HVp9UpCta2St2yaPx5sh4FVzkWAJE6nELn6LXlLdewu7MncKTqJe209aaLO9NLDvZi4mf0qpzR
	QGuKAoapLqYOyJLRyAR0SMIqWbBKZmHIX/i1YsmmCZJs0S8x5++DvHcuix3yStCXn6US4nJJ1NS
	rFRJTtSUzlKSCBl0wY0+Tkh7g92hbhzyL3CVFNxqOL882RsS9pyVtTJX2AxrZVk0uPB9v55Hyl0
	crZ69xAbfCfEv4N7wcZnsYJ0uMl/2m8BEQpcEgk3Bdo/3Eu2JHYtxIsd2FSX0IovOf2y90PeN5j
	6TkJnj6tnlkg3PpybIfkZ/2iiFuaMgzmDHVnh+YYcv7J5WyTPoh1E1o2qlaU1y7fHACvtrGhfs8
	lQuJG8zt8bDqERLt6c7vLzWX7Pn4g75CcipXDoRaB0FHCgfbsds+k20McSf2l7eFqAvHvR99vOa
	eZwDB71lsaBRo+Ke7IGnLBYnpRGH1n/OjKcZqQSQgafqF0oHkjQwF7pmgnPuJeJ/5JXmhWR1YJ4
	0WNFeLYWGf8bkzbsZHsm5sXt
X-Received: by 2002:a05:690e:1501:b0:675:3507:46f5 with SMTP id 956f58d0204a3-67d89758c74mr1463866d50.89.1794598699469;
        Fri, 13 Nov 2026 11:38:19 -0800 (PST)
Received: from unix.. ([181.229.23.179])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a4339c3sm2844892d50.3.2026.11.13.11.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:38:18 -0800 (PST)
From: Ivan Ezequiel Rodriguez <ivanrwcm25@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: use PFN_PHYS() in phys_mem_access_prot()
Date: Fri, 13 Nov 2026 16:38:12 -0300
Message-ID: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C2FE20002
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gbci3yqc83imn8tz9ngien59c3tkxc1r
X-HE-Tag: 1794598700-736001
X-HE-Meta: U2FsdGVkX1927BxLlaEAOkqKp7b+ApyFn5KNXwz/gtpGLT4V5DmkmhURxrP0MEevMTQaIN7tyB9+YpWSTvQmdcMExNQh+Bew7NbuHgCXGbMvtgaD7KCnqeWE3C9yUK3Gq1zhqFT9AqyHzmdL/MOffpbICBckdJ/gzEYnIxb6tkFIyL16XT39aY/CmvPcl9bAs8blf3wKoVLNA1SDYzN+fPxd3cGJ5Kin1x057n8Luvy94QqoVCbNWb3Oq45D8cN/7oRP2GWuw9Pw9BCrccTDnPqdbG1GofkGgxR4yl3qDHpzSXmiimU1FRoJoIDa1IeHukYvE4ttPCci8aSkja7XoIwzdwd5MF+CAzn0X2x/hYR4tLiUkX1YKIE3HUcWKG4bJWRyJ3uOlBeVdr2sPXw5NjknX+N4QLqU9bUkeasU9Fh/K8gzoQgHuBirIIhmXXzo4qcr5jT96ZCP/MPKXy1IX+8aoLACIFGhH3HadC6zcVmf3Go3Vz2uFdZcK5HbE+9j5faqcmj3X8wnRJSk3QrPDk3hI6AMqiM5m/ide02dqQIS27chPMegnYCtH+GRkxMBGx9R/p4LJDnbwbhpQt+lg8NPto/FhJXgydTIiXCDv2PXjs3XSX2nc8aRnH8rXgPNF1RJP9zxPF8zNnIeVGy8xlsBF/HCPl9EkMMK5QR9W0VspHnxbHxKnLQ5TVqXZuwFhnyBMRJUJoYTJfYvtWhoFf2lNmJOVCffCgj4JUbOfcCyRRWbASPjt6PNwqPNbDPOdrUyrMelwcmwmONGx2TEG1CnU87CQgsLhYlorqMFEj40V7/QiTjx8hEI+N4mak3BWrNO2wM3NISoHziH2VBesXUJqjZyHnu1Rq0vN1NjLsV+S7WYGbXNyfy5EmTui/VveacYqfLGG/md5/BiDuOD0603Y5HGPB5uYBc4Subdl24Zp5GdCihgkAdwYnD7oYszWmFuCzrfdAWrVhZBTUM
 MzWtgVuh
 efOf1y1Y8wEuDOIRfaMz3bcJd4z7Zl6mJj0wWLl7Sxnsk1ZNDBJ9dO2yQoAj81NR7lm6xhY2gG90IxQ/rsFlGpW0EZ+ijOLmnSv081w8y8rIwpkg9J3LlTAB3qnIOxz8/mX9GuHVLiCHJtUNOgoeeyeKJyp5hrNzcQhzGPYdbrpKjluRVQb10wpS4VshNC648He5436GZYhQJlU1QdbWzrB5q4IvnIxL2fYx8BaNqgeSLHA0lvA63sZIuPFhtN3KUqkL4JNwvJCzWNP+vFqSMW4gdQJ6SSnkgAISv1GqoD2ADJuBnvGVhLNz20qY0BA9V6X3Ykz7Fhh2/yv+ADgmoLJSq9LDxVVpLH99kPaIPjfFveD5sYwFNQoFxqdS/FlNUPQq2qW/FB1yO8BKg0Uk1pHBQ3N6hS0Mzv+kQUsknLeWmhn+HxJNUdEWLbQJtcY6Qhdz3WYEhAxhkO/mkFC+0zE437T3rbNeiEp0MmKUeCaqkHeUWRsu+NA+TZKd/hB8EoUB+yvZTOMFufjeuUMPjh46eh/wKMuyzCu3D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.
The shift is evaluated as unsigned long, so on a 32-bit kernel with
CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
uncached_access() compares it with __pa(high_memory).

mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
accepted and then left cacheable. PFN_PHYS() casts before the shift.

On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
O_DSYNC used the boot CCA. The same mapping with O_DSYNC was uncached.
With PFN_PHYS() both are uncached.

Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
---
 mm/char-mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index c5761ddedbd7..53ce0034a4c1 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
 {
 #ifdef pgprot_noncached
-	phys_addr_t offset = pfn << PAGE_SHIFT;
+	phys_addr_t offset = PFN_PHYS(pfn);
 
 	if (uncached_access(file, offset))
 		return pgprot_noncached(vma_prot);
-- 
2.43.0


