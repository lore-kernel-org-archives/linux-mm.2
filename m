Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C703EB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF786B0088; Tue, 10 Mar 2026 07:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D086B0089; Tue, 10 Mar 2026 07:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EA16B008A; Tue, 10 Mar 2026 07:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B32156B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:05:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B7F11C7FC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:05:04 +0000 (UTC)
X-FDA: 84529871328.02.22A9E66
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 844C9A0018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J1jkoKPi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGNmukUV6ZynmQPnufsr7pSOWgOJq6CQN8CVvI47374=;
	b=jRH/zfT6+VrWIWuR05lvEgnHfWHa6EJU+5GrOWHKAOG0aLTqHuMAUxWT0eWaJn6uTSsNrM
	uSUvZK2mefyDU4hhIal2MFr2t2/tvW1ip19Yibu5pO/TwMVQr2gsg89i9SBRfKHMhNehi2
	zMnEnVm6n6b60rgc1nEVIZbCrTW7cjg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J1jkoKPi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140702; a=rsa-sha256;
	cv=none;
	b=a8hwsaJUcc/C5Rx8vM97QEUymlfBhe+Ws31WR5pLyQPGcOuM9B8EY4hiI682Q9IYA9U6PQ
	l06Yz3UKeRBM3CZDNVl4jNez68g7HCcEV3dvKNNSJ+EhEqS5owWpQc5Goo8hzb8mqydeC8
	9ltdTuuA109P+Wl1Kfoa6v7YXWl0KyY=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so139392245ad.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773140701; x=1773745501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGNmukUV6ZynmQPnufsr7pSOWgOJq6CQN8CVvI47374=;
        b=J1jkoKPiVOsLz+3qr+AjG2sOeFc+nsv5Z+ag1BmMVac3KyUAe2W+9zp/Y08l/RFRNn
         zg7c5vG5p4v2K8PsM/hHgY65KKx0coAoeIz+3ES3hwN1VzY6V2OKyOZISRanisbHnX5w
         8FugvDo193GXIO7twul2rwxozdUlZ/FgQhCrB4PAR12MmUfn79n45myfx+MELJK4OfKI
         lEHY2T6HjdUww3Iv0t9WPHOk3fD/wrNnvQBcqaIGmy/N6CS8AwgsQsO8NDCULuzWFohL
         QkakEWmQshgJjKJCRJAdF1Lz36ZAW1GwHYLGFxHX2txus/CJlYsJP8TFDrNRQdsc8GOR
         wlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773140701; x=1773745501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GGNmukUV6ZynmQPnufsr7pSOWgOJq6CQN8CVvI47374=;
        b=ZwZ3/klQR/nakuvqoA6pkPE539gF4OO2/p2x/wQBpH5flNLipeJlSLghHtZl6H1Q4o
         ajFUqENVyQpv8eVcdMUlxd2FAMCw30/nyGUoc3EFs+Sd2JkaR5OOGZzG83IxVsaNALUS
         jvPWCf5szvWdaw4U9tP0ZmRZtQl2x/nLiSn2D0OkfcXm2mpfd9e2gT5sTbcpeEbnXh8h
         W+95qIBHbj+dHv/eCu7BIqvsLfDABLCQSAAD8yxhbgUmCLFFvMkomsl0shuUXJhlj+Em
         Yyz8pOz4ZI3uWCGu10pLpzIflvBJThvQkbiG+L0ODzWGNyroJoNO8zcwEkBYdUQheUca
         KgGw==
X-Forwarded-Encrypted: i=1; AJvYcCVmL8uLSEkkAoyrM7r5AXqAqO6RkR3UCIwjUdJVAhlB90BKoKhQYp+DZaQkRBKwGd2ENkZrjETD/g==@kvack.org
X-Gm-Message-State: AOJu0YwsD9DSDQzURD9q1kvsHCnnuiMttHme72zEuSmfycdLS5/B1KW4
	4o43Rt5063sVUIYWcSyrh4zX0VB8PP/h2yo20hqGc1VwM2cVg2OUWlRi
X-Gm-Gg: ATEYQzwazmf25Mvhqu9nm9ZCewUK3WISSiQZuZLYC+0apEL16Yzhbxe/3IBryPERwhY
	H28BKEI+l2mKrXV/bklh7c5Z+ntATigPQCpn7QmfTBgYE2NXNx6QztfskqCTTjzOUOhH2UQMaaL
	XZFvemh8D25cgeJIxXBjrlyA0sp0y+rSTGu/umnmIUxkoYD07j8drwcOszoCONOUusAvMz+c9vg
	TMq0DoehN9NJkqwLKnMi7DquCN0iJiB6GcsZrEsR4L09dBuqLCZgBqk7f1juWIZ2tS3yr3HkWOe
	wMR9wJsKWK8R6F2hgihO5QhoaNVjsYuA9xRebiHRKjBV/90IL/1PNG/5t5IbbLbjdhSlwN4iIqm
	P2mLXlrvc81Eevrc2k3M0L5Qa3t/t4QWZS7aUcFM+buwp7/Yi893oEKUy8ZInI+KI6TxMFBvr8A
	7vEk4ol22npa85eU3eERifKwR8l+j9KECBb3AEibI=
X-Received: by 2002:a17:903:2283:b0:2ae:5223:59ac with SMTP id d9443c01a7336-2ae823849famr139615335ad.13.1773140701141;
        Tue, 10 Mar 2026 04:05:01 -0700 (PDT)
Received: from zjh-os.zhaoxin.com ([2404:7ac0:6c5d:6b3c:b482:76f9:3eac:e82d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e5c167sm141829815ad.1.2026.03.10.04.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 04:05:00 -0700 (PDT)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	SeongJae Park <sj@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Tue, 10 Mar 2026 19:05:26 +0800
Message-ID: <20260310110526.335749-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 844C9A0018
X-Stat-Signature: 5mbeyok89pb1d4zxtpgpbukehtf8yprf
X-Rspam-User: 
X-HE-Tag: 1773140702-100997
X-HE-Meta: U2FsdGVkX19f795xRcTZ7lFp1fWMOYZr7WALEMBi26GSmSZKKs+8+kRpQuWNIbWw/AkdBfVXdfkiLmNeDtx57QFem0Ky6+rdVx6cmwoEC45hXHX7aRzeYk7iMcWc6WY/N2TowgzDPjhpneX90IQJbFMfD2W0LTf3jy8G973H4md0FYsCSCiabeEmld4/mvGWifNI71JyHbRrLphSU7fgIDqHbUUignVwjAKaZs8rekmS53EwDecA5/b7UAmzbKJxeDuzFPB5amb26MHgB2T1X0fjeFqKuzrK+B2CjvJPrHiUP2HzihOGzw/1qNtDxPUpC8NsWg3JqR6lAT0ptPnzcg1ZJdszOBAnl5opqkaGZlbgMqIZWsatgUuxXjBZSGgEMSosfKQB0bSNd81V8IIkOKMErfQgWhsJMJ5tNpim94noQ8skvjZGYwZg3csujypvCTkS2KB1n61QIlGVWQBxX80gvXnLxAsKx2p/m52csLy1E/m4lAvHe/bA0A5/vkiSNH1H8wIczNz9IsMUpVdq7GstcHIgYZNksD4TVOso4Nrv+jTcMfOBCJT+C6N+PGXB42spWY+zA8pT1hPpBJ6EmmOprYAFg9+3V2aMJy1vhA0JFIPthWaDnpgRgkHmiCTzrfhx1JRbATIWMkkgQ9yKPodNSNYFeQ65DkQQNK23+5czPGhpQ3StLaVUVIN872Iyffix0k0kVfqW5aPty0Z9wT61LAfAqdiv1C+f7FfP4LEXv5AzHo0yjuCxsgXHOxCi8+gHNNPp1RN/ZelFF8REBN0Acgct/EvDQmT0DYi2Fnakg6E8eHih2L2zYLwskJewaEv82TWZu3P7IPTHlKYhsuHyezzEnQupgcwE+o+Bzmt3vDQC+QYM5CVFc+ORKz0IX0Ozn4A+7CQVZy/qqeo8Bcc3WUoWPWZ+fIqeWluSMRlM2aKvLKUPyoJpzWDCoXQzxc0d5aAQFmW2JyTSdVW
 qJQBPQHZ
 aKTuSj4Y9uvvmOwlILQvgTUFOm53hY0Ijof/+IM8ebPuSWrFMTzWO0CSdjcUSVRsPBeYJYpgs+3P70xKXd9Czqn8ij1zSO74YAzO9n8CNeefNe9t4kH82kj/HPBA1qe9b0Za7xe4YcAzjfgJLGbIHD9L59Sz9fwHKvm0IVVARhhQu7xOHF+s7NIbqJwQVbDDcoPH/vRgnKK5xU82490EHMSZ7g+JdM8hQkG4K1VRJVAhanZpeHSG4GKEd44qvzYndopdwjadvnmEfWGz8IR4HRzNEluw35FVK1tQ4hs0DM08TmdHjUVznn5joGHmTpBVUlS5RYDQ29PqWd4g2fYON78lnJP3yCgSKGqJ7RA2izISKJ3HuB1AQf/mYow08vwnbHXLZpNUJZcjX0D19LDjPBfqyh7zo77vjKtVUmKK0sjWa6VsR4mxYE3oHRrioJidLNt8jP71VpCW3dmD2bRBOLqf3N2Dt/UAyIYqFSOywEH2LsBzoyD+gExzuphq4jFtF9hT9VlwE7I9iUMr2hexQZ8yKpuDynaupT7ijqpAFrcEu3yASnuBr1Z+0dbhUey4/wtK6T6Dt91+rIc0opvSqYI/lpMuV85wJ+RiejvLDPVbQXWRwy+qQTL9d4xyC1fJfSQ5F4SHstatTTNPZ+rfA+vAMLBxanOOYsD5YfFit7r6MPBpNzHb7il8N/CW22f7U7dNKelR6FBVbQrKyP1ptfkxhHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units. This mismatch means that different
addresses within the same huge page can produce different hash values,
leading to the use of different mutexes for the same huge page. This can
cause races between faulting threads, which can corrupt the reservation
map and trigger the BUG_ON in resv_map_release().

Fix this by introducing hugetlb_linear_page_index(), which returns the
page index in huge page granularity, and using it in place of
linear_page_index().

Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: stable@vger.kernel.org
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
---
v4:
- Introduce hugetlb_linear_page_index() instead of exposing
  vma_hugecache_offset(); call hstate_vma() internally to simplify
  the API (David Hildenbrand)

v3:
- Fix Fixes tag to a08c7193e4f1 (Hugh Dickins)

v2:
- Remove unnecessary !CONFIG_HUGETLB_PAGE stub for vma_hugecache_offset()
  (Peter Xu, SeongJae Park)

 include/linux/hugetlb.h | 17 +++++++++++++++++
 mm/userfaultfd.c        |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..67d4f0924646 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -796,6 +796,23 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
+/**
+ * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
+ *				 page size granularity.
+ * @vma: the hugetlb VMA
+ * @address: the virtual address within the VMA
+ *
+ * Return: the page offset within the mapping in huge page units.
+ */
+static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	struct hstate *h = hstate_vma(vma);
+
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 927086bb4a3c..5590989e18c7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -573,7 +573,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
-- 
2.43.0


