Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593B3CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA948E0017; Wed, 12 Nov 2025 09:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1518E0011; Wed, 12 Nov 2025 09:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6F38E0017; Wed, 12 Nov 2025 09:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74AD78E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:50:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 174C7140530
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:50:49 +0000 (UTC)
X-FDA: 84102241818.24.6F6AA38
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3DFFD14000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:50:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iJztxQPl;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762959047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=04QlL+5Mx8OxfT7e5p1Z21nDjyi+h+Wk/vku3CS8HUg=;
	b=PB+/nJK6eZnW+TvbzXEloxfBvMAk3QTnhYkc08ThpKqfLRm6QVfN/HEY8IOVcQV1ihf9fu
	J+mx+8gSuyZ6cOjAfO3wRpe5eL0KC1ehak1SnU995XhHvzyMugzNbTtiLlvwE3b2Atyp1v
	aJWuOyA9wcYVD82DGJUpAx8x8pRvGgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762959047; a=rsa-sha256;
	cv=none;
	b=JdMPNcPumSxFK1u86yla96YqWeGV4akU5G/OMqSbh0KT9zn7QzV7ZjX3y92RtKCdjaKxGR
	nZ3O0/tEU8SZfuY8dfr/ArZmG9a5dTa8A0yJL7qCuYbjPeJK1Ks5TUGMpCWjSuipZ4IXod
	lV/mNQDqQD3nMBr+8vmxXmL0dcx+b7U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iJztxQPl;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297e239baecso7875625ad.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762959046; x=1763563846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=04QlL+5Mx8OxfT7e5p1Z21nDjyi+h+Wk/vku3CS8HUg=;
        b=iJztxQPlLfto2rPPEEIlc+EsSgCqEonhUtqJLiW0s8iaHYZULbsRkEoQloZZ+gpZJU
         MIZMbjiciTens0CQ+Es/FrKG7vfyYQ0bkWXLtxCGqgnYDWi6NBPIiNtAYWK181vLz2db
         ydmBGFUMaUEyCAxKuCUCohS6tSPXyPG49oHliQFmpff/07bKFlv3EZolmoyabHyjQCBz
         w/Jyodz+1kE+55P65ulTL3s21zCOo0QJd7nmrKG73LJmPE2oOof+Lk/D99dZveilpDpl
         IlRw8DHgDOHu4d0fBKQoyzmxjTlxa8YoSfcqVICXD+f7+hwwbJmMLBE7OyrP8HMqggR6
         GhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762959046; x=1763563846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04QlL+5Mx8OxfT7e5p1Z21nDjyi+h+Wk/vku3CS8HUg=;
        b=S9QErqf78MJ3ptWij3o9B4XSj2CwNWXdBeZCtWf+zDQ5eg4APY9L12lPw5iif9vvnk
         aFHcuOjuO/LSUgUDntCSNyoYYIZh23KY5Z140U1aXW5bVIN4vgmeiYLgoXpTP9mRu/Kw
         noDeWCaNeRT1qPVurbXuxZhvd9b3Q0OZmh5e7UEVaVbDyYpN/2aEGGqnU3PhWkYR971i
         ODzW8uNgGZaUPM9TUTnAb3hvm0K7IvV97Qn2IgBmyqCPDG8+jgle99ygPjsEf1Ljx6aF
         zJV0/X9MhTGObhyfjAYN2/8aChECcGEySddcGYxAZ8JAz4/qz9SDnHQ2y1CDRlvahJ1+
         Wt4A==
X-Forwarded-Encrypted: i=1; AJvYcCVmrr8IRuILp1ff3Wuaio0NOKv1B6syBPEWewVX9nrlxQVSo9RAIxu0pNlHIWjZ3r8+MtUbqQLNyA==@kvack.org
X-Gm-Message-State: AOJu0Yw8vXoBEgfxLvke52bRaEDrGgHpOricpSyb8lEN6+wr3+ueLRft
	yidYKQTCBLya6ttVWDQQigUsODuLP+33pr6ieLtXCfBp+L7ML5C/lCMg
X-Gm-Gg: ASbGncsdRXMDsp7cn5snUOBOiGoWyVzRYwyZlJfaJ92AU0CcgdIAKMFprtkVhivdpMw
	2jmNMY8jWyaJGX2IfDIgyMh9ZHTZv1qRf0DucHjgDkjvXHp9E7UYN4q2YhrTr6WMJ3Mk2L9qc4C
	cMwlOuipinXAFwlZdESKKrGzf92VvmLP4PqyfqvQkI1WXxjIPao97Nh6gr0sI6ZYU5kIrIklKgu
	+rXYzlbV8Lx6nok9fNju+nLIJusspsrV6ubjrMkL2rAqTQTAQYsPTKR07d1irg34xrWrs/mrtAc
	MSEe8d6hSpaqesR1RMw/KOTD0iM+5WfhqEK2Qg6mOISgICoPZJbNbj4/8WGMlxeKezEsHbvlmlS
	gVhr/hXHkSxHHtUJqng9sYPiRliFlSSSwH4jH6FROWw4Vr/xg9qM7qnfRfHfI5+Sw3U9k+C3l+B
	rL3xY9Rzb6i2sYc9xvUOzMPSXt
X-Google-Smtp-Source: AGHT+IE2Jk3jIxHv0j57R0SoqELtg9Swv8OUP0MYlU3+JveRpVMaxRxaqU9rPiV1dpQNjx/a9aXLaQ==
X-Received: by 2002:a17:903:3b8b:b0:294:8c99:f318 with SMTP id d9443c01a7336-2984ed2b4b6mr40095785ad.3.1762959045905;
        Wed, 12 Nov 2025 06:50:45 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:3a14:81d0:725d:2dc7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dc0df31sm33048055ad.50.2025.11.12.06.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 06:50:44 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: kraxel@redhat.com,
	airlied@redhat.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vivek.kasireddy@intel.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/memfd: fix information leak in hugetlb folios
Date: Wed, 12 Nov 2025 20:20:34 +0530
Message-ID: <20251112145034.2320452-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: coh63d6x1c4uyu5sawax9sgqy4wy1dku
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DFFD14000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762959047-669839
X-HE-Meta: U2FsdGVkX1+vtXdb/bf/Pbpx9K+cc7AROa70eUktW6jLV1pHZb+LTfMFtB/T6NQwWaUiCRHeTQZBNfEWg4mJGJ44YyucJdPdng4sn/R9Fi/D3INGk+Ka9uU1bVnRw7jfUYhrpUKKpdy0H4tgLhHWJUUXypORnEkW2RmAK9Z90ikiYJBWobDIOuN60uMQ1sbnLm17IyPB59MKKHgi2iIsHxaxX0XeqCFpJK+nKvZKgHdCu1NRTGmAynC18KYQjMajF+rXzgHv9CL6JEUX6UPNFe0XT5yw0G612LgUgKhH54xnZwB+1GxMG6qdHt+LTncyqr5nzY0nXHgVIDWnVQo0YLtaY2x3wHhA80HEtoMz57K64ir+3xZrGs7ABRDaPFBzRmE6blvJYO5aRsm88z2FgVceb9iMOwaZaoxjthNxytWEbayrCdPIuJCV/jbg0F6kXLs4spPuaktLN2l+nMAH6uYxQtm95qqz2YmQV/8hXu2SWXmuS6OGzEyxqtgNAVCvAGuVRIJFCjBKwMOTL6/86EtCRP/iPcM85Sbczyqg3gY5kWRwbVJjGTNa7Cczb2ypK4iPjtWfqNB1ohrujCui1/L05MH1/Mx7MxKBu49g/voNtFHSX8ZgoSBCOBYI75QAjZnvAok/Jefqt8GGGpwT2wqcd44yFC4PmBUcIr8svZMH7oopzwYX/C9JweH4REWlfObgNEfrhG+QfwklV6/DFAWGsbSe7oZ7H39ri13hF30LUQLDS9FL7qwYuxUxHAAaLIjD2Y6TGsPZ+iIiQ8v0boWoO/kHrd27L1LuAjsPixpEz3cBSg5k2MoAI1v+she5GbyrRarzfOdiNOFWk9qPFzVTwpyn7ZLh/vT45jOFjFcPHOAppH3ZzHzqW/dnRRYCLO/jbbZcyamX9QcHItH3iFC2kCfhYPQbh1hY/U77Ko65D8Mx98i3dhiGsJzWg6iyex4tDaSLpZaf8CAgNMm
 MYarj0sa
 YTG70pZugKqJWfPx9VHcD60zbCVxIgnKnBQN8GUouiu2v72pT8FrBN8p1DX+q8j2RhIQ+VwD14H3ilZ0k+w7NZbVfkk8Cx75ZHfoHwhKDInM4hN+FIDNhmK6WZtUYr2idAcC5ZeXg+VRhJpOJRdH11OrUJdDLQwA4Fz0P+nQXLQkQ8IUluRfBdsKS0uV0YXwc3k4WVlYv8XoHpgbYxV2tgLT4eNjB0up0R1YDbYyVdteDkzEGeF2/dUT/JDTrKlxPu+aiaxUAY2yXaVPgpuz3AN+p13XeDJyhyfzI9aWZHeNwiwpE+c7c65A3lq0kQe2EiNRnZCBqQsfYOXDblYOrPq9nIxg1NBOmBbbTK9lNywIRpRnzhrK7nFoSwYwUE+8A6L43JeyiQXFbIrda99Q7AeM5KLWUC36KCJh1R3WkWplfLaY1rvyTd7/GZTLc8x27S1JZTi7p+AitcgDPyk8r6dfsMBU2NLxirT56GPpLebhLw8aiNHZsXYxTlX+gZ5+OWo6+0GSj/gzP9F39QHXjvjiAy/rElKGn851ikmiivSkVTQlJNH19AKZCsDWofUVOe1VsijU+ONvUKMBcFgLQjQovDnYmrg1YORZ4f7vtCP73RLpFenaV0A3IsHngDym1yoSInzzz0rE0gXWGeQLkmBg1cn4wpo/D7WD5uTqwKJJjpVx4hDPwY3zG8G9xinUg6QHIZE44epNLkHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When allocating hugetlb folios for memfd, three initialization steps
are missing:

1. Folios are not zeroed, leading to kernel memory disclosure to userspace
2. Folios are not marked uptodate before adding to page cache
3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()

The memfd allocation path bypasses the normal page fault handler
(hugetlb_no_page) which would handle all of these initialization steps.
This is problematic especially for udmabuf use cases where folios are
pinned and directly accessed by userspace via DMA.

Fix by matching the initialization pattern used in hugetlb_no_page():
- Zero the folio using folio_zero_user() which is optimized for huge pages
- Mark it uptodate with folio_mark_uptodate()
- Take hugetlb_fault_mutex before adding to page cache to prevent races

The folio_zero_user() change also fixes a potential security issue where
uninitialized kernel memory could be disclosed to userspace through
read() or mmap() operations on the memfd.

Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: stable@vger.kernel.org
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---

v1 -> v2:
- Use folio_zero_user() instead of folio_zero_range() (optimized for huge pages)
- Add folio_mark_uptodate() before adding to page cache
- Add hugetlb_fault_mutex locking around hugetlb_add_to_page_cache()
- Add Fixes: tag and Cc: stable for backporting
- Add Suggested-by: tags for Oscar and David
---
 mm/memfd.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 1d109c1acf21..d32eef58d154 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -96,9 +96,36 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 						    NULL,
 						    gfp_mask);
 		if (folio) {
+			u32 hash;
+
+			/*
+			 * Zero the folio to prevent information leaks to userspace.
+			 * Use folio_zero_user() which is optimized for huge/gigantic
+			 * pages. Pass 0 as addr_hint since this is not a faulting path
+			 *  and we don't have a user virtual address yet.
+			 */
+			folio_zero_user(folio, 0);
+
+			/*
+			 * Mark the folio uptodate before adding to page cache,
+			 * as required by filemap.c and other hugetlb paths.
+			 */
+			__folio_mark_uptodate(folio);
+
+			/*
+			 * Serialize hugepage allocation and instantiation to prevent
+			 * races with concurrent allocations, as required by all other
+			 * callers of hugetlb_add_to_page_cache().
+			 */
+			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
+
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
-- 
2.43.0



