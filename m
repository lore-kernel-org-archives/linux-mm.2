Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1083BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CB56B0096; Fri,  2 Oct 2026 20:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E016B0098; Fri,  2 Oct 2026 20:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5336B0099; Fri,  2 Oct 2026 20:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D86C26B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0949160514
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:47 +0000 (UTC)
X-FDA: 85279406814.15.2D8F3ED
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E693C0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7fDNC7v;
	spf=pass (imf10.hostedemail.com: domain of 3IErAagoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3IErAagoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K+i7FF1JdoB4a6M9CS0sHYTwNj12mJrugew1z6DccSk=;
	b=U294WuDl5xo3fPjLCalWMm4s7xtL3ALcQYpSp+nAUsOTpQo0C+MgFz4sXYBK2Og2P0YJpi
	0Rc5a9AbiOR78LxQXv5no7f+edy/wq6eY07+dVPXzX3lnOdwNARD7qb4KihwexQQt7lmRb
	+NRdTYgtrN35ZytIiiBzinAAjUsLoxU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7fDNC7v;
	spf=pass (imf10.hostedemail.com: domain of 3IErAagoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3IErAagoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986786;
	b=iQkSQpq0O4/OQ3lHCzmJTVnjItdz7WC73jZvYr42BxREMr9DrqVVjGBxHOvAWHXyo6l/+9
	sYGmxyQeL0KV9f8A1S81RUF8zBOuX/R06bkl/P1r6eGJZHeozpA3VzeVcQKHUGPbPlCquK
	GQX3wQgQllbkxlVj6dZKsU5GTtqWvE0=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88732460a55so88930b3a.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986785; x=1791591585; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K+i7FF1JdoB4a6M9CS0sHYTwNj12mJrugew1z6DccSk=;
        b=e7fDNC7v874iReVp6oJTUcRZSHoGZ6jH3s6OAeJ7MPhPW2zQ02mab2a47HAtd/WlrZ
         TrBlBNAl/+KJiY7UyeOC5c77i03peZRJBKqj0U1r2WEx/zEhlBnOnMW0tPSKGD4VLlL6
         9lzRkRdA6W1n7v+pF6NvNlLJ53uNWJ4ZeZL5raXrIltNPFUsmVz1Y0iihOHBvQMNzGxQ
         l1KD1xd5jlmzgAabaBtGRiB7kWhpHkN4ilF8IlHS/3i/R2eKQvBpO/PqQrPbjFkUEZec
         rR1x4zHjuu1B9k/XSq8SmYobWtUtJnGe0IZNMGWv2+eaH9e8Cfwg5h7ygb8lSeLbe0WT
         CHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986785; x=1791591585;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K+i7FF1JdoB4a6M9CS0sHYTwNj12mJrugew1z6DccSk=;
        b=kTrRuoXfjp4KWzo4ybeNOEKUU5ti5NmtTZLCvoee3euFhVz1R7JOSQnw/L9mzA4g9m
         f4RfjXtyUgkYYayT6tJ5rLAf5sSWdUFan5bVahMtn765r3FAkQom+mb0WcTBpMg89Aqx
         +6gJFcsoeM0RKKe+2TGJTNAVQy3PHmJKOMW2WRUUWcspwdadxhHJxvm2ww9iUyaU2xQH
         2J6PW3HeJ3GyTTx3oCDrrDz3N/zXiMuTNzLLgzEJfb/fxsbGIYe+Td8TdBvbIM60ktFt
         qKW7i+thfhQ6W5pAeR2hpZN4adbh/vnW8fJRMBcDY3Wf+HlKUMsXMB8/Y8AZBA0qcIHu
         NEEQ==
X-Forwarded-Encrypted: i=1; AKwUvByyNg3KmV2YYQUwh8lknuYzlfM11eq0Uc5GUrmeaq/APOCe0q/ibgXfwP4k7QKi3sJ8U9wVTjfqEg==@kvack.org
X-Gm-Message-State: AFuF++kUA2U25SBqOG8cQDK48Hd73KNDe62JeVKaihPPz4c8jbjjbfbr
	yTcoXrhAbUBv2bcnq4ffyhWWJ8sQOzT1z+9NcYwKlRELxO5NLE3HaBgFeb44wWoTgXIyNJ/pjVN
	OoDatKdmoB52IF3axouHTMw==
X-Received: from pfpk16.prod.google.com ([2002:aa7:9d10:0:b0:88b:9d6d:1e0e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3d0d:b0:880:849d:c07c with SMTP id d2e1a72fcca58-88af665979cmr3880920b3a.25.1790986784885;
 Fri, 02 Oct 2026 17:19:44 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:18:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003001859.502725-1-jthoughton@google.com>
Subject: [PATCH v4 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E693C0008
X-Stat-Signature: xjx3wcpmm9g4owkp8i3gt8ze8iop6tab
X-Rspam-User: 
X-HE-Tag: 1790986786-592243
X-HE-Meta: U2FsdGVkX1/JOUb7QU/yGv4nOdrnoX70G3Iawj/V5Hz6LKfp8jOdqxDTEBIOvgxPK4yJhrgOxokyYPSHz9QfdbtctPYy0ZNoKElIeSUYx9HRQGBP/vY2tbxg9hxBfJo+WybC9FINDTWKWi/xz1ncqJg5icv6mi+WcWKClkrZmJlN4yqZ0tp4WrSgE0NpdS3zuBllVa/eWGJd2s9TZig4Vf8/1X4wgMSFhd74aLxQvU3L4mb09h9v/Pr5ow2/ZjSEd1SzZiwJCuXdmEEji14pexG73xhZ2blp3qq3EVTBXONtAnco7mGIuieN35zpDiOh9QgI25qdyUp60eiqcfuNRnwWIvWNZ9K1rK5SgIKCWhtCTr1iS5owFDP3jr6+mv+eUGhQwMTYuOCgbGbf5VMoun1B1titjqttKVeX/b7hrw6VmIXU1ijeDO3TCXsiKXtT+k7bctKCx1G2pgSV62zWG3b7glstVoXUa2sIqH3FtTHzb+NwoAIVK64XUclqenxMnkNSGovT26f1P/6uHKfqhrYutawIVErL3CClxX7vOtWGwo6mzYcTCilBcXgom9JlbaujSbq3vg3M1KjMdB1EYLPwMfzyTM97cJcyw6Q1GD+2/x1i2WjHU0GZec5XUya39UD2tvCNAZm/K5GDwUUOak6Z3XVQZAghQlHYWwngTk+dtaaGhjixCpljVhVGrUQTds53WKMUa6Xwfh14YF8wGhoBFvMhQnCcMjS8pkfmU/1H+ftK1bkWOJ9GPT26m5Gvg1VQCRVd8C3vI+PlYDoDEZ9HP9dY+2MJcP7oLYHv0u6GO4Okm+hGeODLdpKgrbqKk0oABiSfbRkNxds/n3WwZZmKb6kZD8hYXMmnOCxTvlmwPiJyOre42a9YZXs8WKBGGTQrQZgYgLPM7vLscf67E55XbJt+aozKB7UN80nh9Ea4hs+SnA8cawsYoq90WyQqJaIlVkq49/xMm0ZyQU6
 yBj8Rrbt
 qBEd+EEq+T9Y2TxwXOP8LkwjhRAYcG2rHmvPOwpqSIL6PBFtX/uktm5jDr3Xycj1Y6Fq15YAYzG4YS6OrOizLcOFsOjcjotrSouvBSjT23erlok9Tks5fr63wYPKYVBRZ6Ix1OT5wWm39cuS3s3ZiJL6ANR7gp1+skannsZQgKz+CdfGrTUX5qBLFZIhMbfBtGom4HEoMYQYHOqEUe7YlHxoZGKPVf+8JL5nlC3hEn8/+Cb764c31Q9cTp6Ne+I9jm751agVWED8BZN9h8VloNsMqKI031Y7Dd+UZHGZ9f0Is2s2iZCiZuDkl05kMcltM5UdpUU9R49B06FtwSQcCo+k5BQbQBDGCAUSgmxX2uKk1KrZ63cAz9Jfenj0s75gnD21mke9LveduXH1PyaRnr2myMZxXipOB2avJ8gsxM7WSNAEOm4/tdNtJ3UDnpDjAi6NW1dQhAiScyUYDghzFfrGVIIiJD95c30Va9mGNNuNojzebiUbCXMAo7hcHTesdXaO5TBo45LjYMatSmXR7gEaA7q4fRBll01XHFDb4Hw/0hamGjm5qCqV6M7URvl6kjwlLhTCAg0Y3XUhqvHY5DNN8HtQpjvEQQeG0MXw/aEnPS2ux3mn4tyc6/7NSQIFNTtWg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
holes in the VMA when a naturally-aligned THP is present. This is not
true for khugepaged collapse: the PTEs will be retracted, but a PMD will
not be installed.

When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
userspace is likely to expect UFFDIO_CONTINUE to succeed on the
should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.

This is not inherently a problem, as MADV_COLLAPSE is an explicit
userspace action. But, especially because MADV_COLLAPSE can be invoked
by an external process via process_madvise(), a rogue caller could break
a userfaultfd-minor resolver thread.

Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
faults, as MADV_COLLAPSE will only resolve such faults if a
naturally-aligned THP is present, so this is not a functional
regression for userspace.

The naturally-aligned THP case is the only case where this quirk exists.
Collapsing otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
correct. This check is essentially bypassed for naturally-aligned THPs.

Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: James Houghton <jthoughton@google.com>
---
Changes since v3:
  - Prevent page table retraction in patch 1. Please see the comment
    next to it. So this patch now has two hunks instead of one.
  - Reworded the comment and combined the userfaultfd checks in patch 1.
    (Thanks David)
  - Simplified the selftest a bit given the behavior change in patch 1.
  - Undid a change in v3's selftest that incorrectly handled the case
    where MADV_COLLAPSE was not supported entirely.
  - Rebased on top of mm-unstable, which includes Kiryl's changes.
v3: https://lore.kernel.org/linux-mm/20260910023411.514987-1-jthoughton@google.com/
v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughton@google.com/
v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughton@google.com/
---
 mm/khugepaged.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 913086eaf17b..438c4af1c058 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1868,10 +1868,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		return SCAN_VMA_CHECK;
 
 	/*
-	 * Keep pmd pgtable while the uffd bit is in use; see comment in
-	 * retract_page_tables().
+	 * Don't collapse if there might be PTE markers for userfaultfd-based
+	 * access protection or if collapsing might bypass userfaultfd minor
+	 * faults.
 	 */
-	if (userfaultfd_protected(vma))
+	if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
 		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
@@ -2093,8 +2094,13 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 	 * and cannot be recycled to a shared PMD. Other vmas can still
 	 * have the same file mapped hugely, but skip this one: it will
 	 * always be mapped in small page size for these registrations.
+	 *
+	 * Userfaultfd-minor-registered VMAs should also not be retracted.
+	 * PMDs will not be installed, as doing so can suppress minor faults.
+	 * If retraction were allowed, khugepaged might continually cause
+	 * unnecessary userfaultfd minor faults for already-CONTINUE'd pages.
 	 */
-	if (userfaultfd_protected(vma))
+	if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
 		return false;
 
 	/*

base-commit: b2b4b29b76dabdee576eba66953a66ca61c5fca0
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


