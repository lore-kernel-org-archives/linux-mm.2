Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFC9CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0188E0029; Wed, 10 Sep 2025 12:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AB88E0005; Wed, 10 Sep 2025 12:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7210C8E0029; Wed, 10 Sep 2025 12:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 579968E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AA4914013A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:09 +0000 (UTC)
X-FDA: 83873824818.13.E0F7F17
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 043B54000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJJtF9vT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520547;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxLX4xyttOXeHBJj3J8i0UpcIMZfFqRb74t6SVPVOEc=;
	b=5I/imbShW6Vr2mb60qc5E3KhKA7fUud+xzvWWeK4sVoMzFfDAoepwwF3BcGzmjZrRi30TU
	g0oCvsu8o/5kJl/D4s7odOvCx7ENI0WXo/1zmiQsRmf56OkXO39NDAJaGHrnyJb+2g8YVn
	lhXrc0+6brm5oTW4MbHqxYQ5JQHyLYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520547; a=rsa-sha256;
	cv=none;
	b=ApUBYpZBtWzu8M6MRM/PuCn3IW1v+dPXMazwG+uktlGbD0/37qAa9dssqvVN9n5WcLAf9F
	8FifIsIusqO4QUUbd/KJ8ba+exdu0Yuk1GqvqfbSB9Xo859K+Bzf6UhaRvBb8JBASDcb+u
	skr5BQjJ5F5EsCpynKeZiA+qbiydktE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJJtF9vT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7725de6b57dso8158759b3a.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520545; x=1758125345; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BxLX4xyttOXeHBJj3J8i0UpcIMZfFqRb74t6SVPVOEc=;
        b=UJJtF9vTrfTwgAcJUdIp6lDSHR8eaJnP3ycWUWYNxxgjRtcbPKrbP2aCeY9O79yMAZ
         EjXLnDKbUTzfDT6C1iiOIjCQOX1ekBYjpnPwrmH/oJ4GH6fzK77gGrQP5dRRVhlv5Tcl
         zhWP9c7h7acZy/p+omybCY3UHIFjFj9AMOyUluSUuvTnDlaoYnuFLZTdfzQcS+7vwSE8
         CLrQVQ9A1OOF/SBFexTGjjRPxEmlhd0p/UCFkxin6Y5+Zo3HS1GfIk3jixLjSq6UlVmo
         c6tU/8AzillM9FGsfLb/LBKxowKpSKzEICMnBkrmkZ4xS5zp2KizwJ1NT2yS4uSvIwp3
         290w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520545; x=1758125345;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BxLX4xyttOXeHBJj3J8i0UpcIMZfFqRb74t6SVPVOEc=;
        b=MXNyWvICJ6ru3C3mca28qOSN7jK0FtZ7L4RCJ9JLwSt1rWfkslRfHYr85RhZh1QA/B
         ctjzx2AfTu5wJGfRYIwV175gyEoWeAiv2fPqTan3t5sIMrq2hLCSsN5SVRwxiag/b5sa
         s/7O0RrDm2RPuWNqFCTMdEliSwJgz8yTnIZbj3YjOsk019V0VVJUJhJ+vR4WKWMFSCeR
         P+Xo8ENQHUJPmjXvcAGL0aXQ/dypG4GUIXvaD6Qr5FdSK1fCDWPzZzalKSD01jxHdk7h
         s7SBihIdMDll1MjGTLvX9hxNaLjReNxxVlu2iJ1RAPCdU2e3TJ38mjCic1LZ1BWTw2Pc
         MsjA==
X-Gm-Message-State: AOJu0YzEaEd46OjoEUQwqZwFCLky2tkNtZvP6c5GPzaCpqMlzSrzq82i
	UgEHGeQy+4MxtfgCFZqp5Udgyxlehmf3fZT8JFuLF9xvkPNlQS2sQ4KFvs9x6JzIpy4=
X-Gm-Gg: ASbGncviIjYQ6NNu9Dz1aVn8hco1QEs0CIXsBYs10DQEuLvrG55HXvJij16cORZeph7
	7NmsMxfecOF794aYQ9eWvpUJmLDiAEfsRYRBxVUKsBPmVWYeH8lspW55YrfSrr/sQ8jd/Jl7aV0
	KGj1ZvSk1IQRbXAlLTKPphv2+E1iEX3vi7+sgrUqJhMsn9QirtfjYglPxI7D+0EID0d/Zq8EguL
	XqGVyuwUeG28QK9hOaU2Lxx+x1nFVB3Oh+EowULGPm+/0pK/WPDAgYx7qDpwwEEneMlSDnOlyOM
	dHrUMpUrsThAfsINFVKNSDFucS6CJeReyXh0KldtjWGDAWJIJ4H2EYu0KyZN3At2UzYcCppe9Zw
	TFCQRc7eF/7CxsgleMc9kQ2SHvWDENeuI9uBMhOfwUJLtVFIUd4ZJbu3CjA==
X-Google-Smtp-Source: AGHT+IFGnnTS7ld9IQLIIRQsAt7maX5kJ+os/mQb2BSw6qlHk3VZHZQENlh+ewVjuD1hIx8qBenBkg==
X-Received: by 2002:a05:6a20:1584:b0:24e:9d94:7b17 with SMTP id adf61e73a8af0-2533e8532f4mr19272123637.9.1757520545462;
        Wed, 10 Sep 2025 09:09:05 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:04 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 04/15] mm, swap: check page poison flag after locking it
Date: Thu, 11 Sep 2025 00:08:22 +0800
Message-ID: <20250910160833.3464-5-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ocwd5cprj7rjaqss6xcb36n48x9j443f
X-Rspamd-Queue-Id: 043B54000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757520546-329704
X-HE-Meta: U2FsdGVkX19E1r8gdctiE+i3aux0g6P23XOR7cf59IBCzNs+AbK1iBr+1bjvFjB6V/1Ao/7a0GpyZaSMLbOHFcEoj5Lqw6UpyjsvpzQalx4rhH7rdD/fT6nnfHdKjI3NoBnXeQSh+dtho5OR3squNRhyBD2ohF2y37dKfXBqvxV9BCVrIUXp5H6t0GSmHwub2HqL37x3oWZAUZO8qPT7Dl1ppFuvRxWiUD4vAQv+LJ2d7VjscBKNAn7LLKtwpCDhROKZvkF8aG4WUrDTbxLIAcYn7J+fORgZJ9jov+USnvIBawGBynSo5GD7usdmR4RlGMGtpaHgccq29ACH5xWun5La5hukyyyt9fKgQNYX6UNL8sjpIMCmXpi5sVE6jpuZ0UwGKph9Ir3LCvDjEv+1GdqXW+YmX2SozRZ+FiHC0MD+vRrZ4iGVYNI/gB/W77Z4WO13jZXrp+XamfoIWjIMnOYm1lC/Ft1vrKsz3KrAoRROskeFJdPe0cGlCSAc71lR/EHqwrhJQETnmpdYZHy1VsNg+gHGr826TvzvG1LlaBs0gf4Zdpbu0WGLdiyHLSRZDyB9KrSBb2DiF2xZEfBAoYSrqmM5aGLnWirNl2KMCoRcxZcy81Xsy+rz2Y/V19P0ZTbs4aPS6YZkfpOQ1xEbMSX2/D1GBq7sXEQo1cSBkwTy45mPoUxc8FpzJFjK3yrvHEbxfSd6kTMvXNKmV5VgTBUZ6nww4XTAMqWVl2buc5cYdAtJ1LB3MnnZCj3PNnWpXubgLH9bqzbkbMPuen2YJKwqE0DBe+iuK5SwaSldd2jGJlPwIBzjGYAIbHnOfPE/PhlOUgGYhaH/YWrIDXmMGDwqLMAyrOGzUtQVSzu2W5kmAwCyxr2/9n4OJHOeHPii/XfOn2F7qn47/1lbPIOpuFRVolW7aiG0DfZ706LM032Dw4/Fs263orrVDwVXieduXpnD9wEtH18upG6OVSF
 ENsAlqHa
 2oxYtc2Ik4F7kb0ruHPwyIH7rdz8QGSeL8RKb2fpdH6r5dsToxA6/LzkSPi1OqfgiPmglRBoJ/mdUS/g+oxZVwgwyIVrv3F8/QGStk2aq3LkHM4VbY/gte6xMmXR+w7dZ7kSxVAx+g0NeY3Jlo+gLDST/ORT/wgwgvyzuJ1EevuBvYONDiGH9RotM72W16WNjUdu8+ec5cupWsOcAx+7Zn5atwT+MLOFliol1UgK+jYSZgXDcrvxnm7q0pGRScJhHWFbmdObX3aI2Bug0/yCNwhO5sIArls+Rm4ulx//nxR3K6aVVijWL9fJxlry0hwfQtbLaMJ34DcwYi9mB/gLlQx9T735OL2hdShX6qchY7pqm/D1lzngcjaNjRzZHeDvpuj1Ju+7T1ahRv+iAmfj2ZtHFFtQ+BLvqOi0i+ncwEhen8bGD06MF/JCyxl97zlJs03UhSf9QGHKTfDLl24tWoq+eC9+s3jLME5jjcgtxCyRgCz+h/V6lyVmJMORGFGG8vMVq9sADI/sGgEd1tM2anRp3pPj7gLNLcsdfrJB8gJo+CIc/gy6oK8PTlCgz5ITlK1SaBM3MOfnq0oPT6GdrqMcQvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of checking the poison flag only in the fast swap cache lookup
path, always check the poison flags after locking a swap cache folio.

There are two reasons to do so.

The folio is unstable and could be removed from the swap cache anytime,
so it's totally possible that the folio is no longer the backing folio
of a swap entry, and could be an irrelevant poisoned folio. We might
mistakenly kill a faulting process.

And it's totally possible or even common for the slow swap in path
(swapin_readahead) to bring in a cached folio. The cache folio could be
poisoned, too. Only checking the poison flag in the fast path will miss
such folios.

The race window is tiny, so it's very unlikely to happen, though.
While at it, also add a unlikely prefix.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 10ef528a5f44..94a5928e8ace 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
-	if (folio) {
+	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-		page = folio_file_page(folio, swp_offset(entry));
-	}
 	swapcache = folio;
 
 	if (!folio) {
@@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-		page = folio_file_page(folio, swp_offset(entry));
-	} else if (PageHWPoison(page)) {
-		/*
-		 * hwpoisoned dirty swapcache pages are kept for killing
-		 * owner processes (which may be unknown at hwpoison time)
-		 */
-		ret = VM_FAULT_HWPOISON;
-		goto out_release;
 	}
 
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
 
+	page = folio_file_page(folio, swp_offset(entry));
 	if (swapcache) {
 		/*
 		 * Make sure folio_free_swap() or swapoff did not release the
@@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			     page_swap_entry(page).val != entry.val))
 			goto out_page;
 
+		if (unlikely(PageHWPoison(page))) {
+			/*
+			 * hwpoisoned dirty swapcache pages are kept for killing
+			 * owner processes (which may be unknown at hwpoison time)
+			 */
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
+		}
+
 		/*
 		 * KSM sometimes has to copy on read faults, for example, if
 		 * folio->index of non-ksm folios would be nonlinear inside the
-- 
2.51.0


