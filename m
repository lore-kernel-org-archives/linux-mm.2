Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376A4FC9ED9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 06:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31AFA6B0005; Sat,  7 Mar 2026 01:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3096B0089; Sat,  7 Mar 2026 01:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7926B008A; Sat,  7 Mar 2026 01:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6C6F6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:54:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 217BB1B8A03
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 06:54:25 +0000 (UTC)
X-FDA: 84518353290.17.8FBD75B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6778EC000C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 06:54:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9F13kfK;
	spf=pass (imf10.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772866463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CFh5xzf9mXTWKL8wgZ/1CT8NM6bT0JUa5sch2tV0MvY=;
	b=6rccAlVAPQV8ghNeymFUyrmNyfZUuxxDApwTIV1gEC8MXGsYOZuWoBq0zv+3GNy4BPZvOP
	YxfzLvd6DYRQcLaxaT1t+QtVsis5eZCMSyDrXq+NeqBtrckfKpiJvwKbPZ83fgEm+JVTEE
	E7gQ1eiVHZcyWHSYqidX2p/Kw22Y6yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772866463; a=rsa-sha256;
	cv=none;
	b=0nFM8DuoPPUpKVoBVWGl0A0MGOb1OeLuMEMlR/nRo4C1EmI37CpRPKsuNQk37ZoKeBy8tu
	MXcZgYL8mTCHxzLC9TNypiCeJWBwD+SUrF+l3lRIo4ZPjXU7iPHAtQ6TYIGHqF+3UJ0aMI
	dt0mOIjRdeNEoyWMjhkd4M0YlHCeY3M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9F13kfK;
	spf=pass (imf10.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a9296b3926so75393515ad.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 22:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772866462; x=1773471262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CFh5xzf9mXTWKL8wgZ/1CT8NM6bT0JUa5sch2tV0MvY=;
        b=k9F13kfKgFhBcFBdNekDiynhFaP/hfXnzo6QtAEnK5+wximjcNKn5Fs83spr22abZN
         00g6N/+yPWjJ/6Jj0h5jr93q/9A0V8OB3RzPRy/wT73Y8MLiV3hjo92FY3gjJRPn0Kco
         EnZOG9s3jhXq1oHNC4PQhzxeSFmk486nc22/j7+3MNu6boD7mOe0Yn5KPYYRn/8LLa7e
         xM9v2VsKIJE5MFFuzRByrW0u12FBV7ebxDs6x37wwtYRQ6WDzQco35JVT4+q/D+lC4AQ
         Vjhw/MqKwuaCdJkHyw8OXWWDqbb+OZ8QvOmOy3RkgIA5cwoaMG0sDScrBpDk+ivM7B6J
         nygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772866462; x=1773471262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFh5xzf9mXTWKL8wgZ/1CT8NM6bT0JUa5sch2tV0MvY=;
        b=VK+P17KBF8+l6XViwBFBq2Yc4D9oDTjlopmY1qGi9hrvHg/SrQD1dU+V+NCTCvqq8i
         iuID94207Z7mP7G009UFcZuuML19TvJMShOYUCss52zwwgD8qulUGWLh7jbOx4bPJhYG
         J2GtPA5VHGhHwIsErno4CbLeSK5dUM+68Dv5Q/G0Pa2RdmvbcdG+y3KC+Kx6ai2TPRrF
         j2yhH3gMB/+sSSqHKcs4HfoL7cBVktJ6k1N4ghoUUXF9BjFqIf51ypHWBxXdn91IonxV
         NeAC3rbu23GudLtcq42WcnUriurHgRt1Ay+yeztnb/AmY1lMEf7zET61/rz74n5i7Hz4
         4k5Q==
X-Gm-Message-State: AOJu0YyKu4VKihOe6HaOJCRFq8S4YK6P0Z64bOX1rUDQo5NYgwVU080d
	qg18yVwdG9zr8jry86ZJr4Yxvv10kv4uoRRsuHd7EMPCOyy9HFdJJMLe
X-Gm-Gg: ATEYQzw2I4W0x1mVjLkR/tvZF2VW77mTkCi93EJPuuW1ciGqBsxn/yIkRWflKSR8cjz
	o2A51sTkUa+VmPCwEDu02+IomHyYcARpLKcd/oHxke1Rm14dqPqzssU45gMVu/dfwzDWX8Dowbx
	36tNHEW808SDsKFD4RW5O5YgI7XKK4j5BCesBwuhdyCcor25i+3aAkh2cAZB0JZ//4AhEpTkWd0
	DajG7djNvGmFONM68G61ZsyVxx7tRYfiitxdJvEI7F/Rs4MRY6r8pbADLQ5Fx2hp8+48381bspv
	l/k29OhNE41scbmpJdi4ljn60vcSGkv/pVTP3h0nFypMxFs2a+4VFyV1yihjSfwbc5zh/3kSoue
	aTfYs+DFtJgUbqD8JdCRwpdZpbV6mpUfeJZI249FBKu562GKjBk9JeoqSKw6wrRwy/0InYd2Z3c
	R3yXXRPI0DUYR0/QK+MLPfoi7I4buP1nA13jUYcocldLs=
X-Received: by 2002:a17:903:120f:b0:2ae:670e:309f with SMTP id d9443c01a7336-2ae824f4d5fmr46909505ad.34.1772866462157;
        Fri, 06 Mar 2026 22:54:22 -0800 (PST)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e77197sm41388995ad.20.2026.03.06.22.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 22:54:21 -0800 (PST)
From: Xie Yuanbin <qq570070308@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Xie Yuanbin <qq570070308@gmail.com>
Subject: [PATCH] mm: optimize once judgment with clang
Date: Sat,  7 Mar 2026 14:54:04 +0800
Message-ID: <20260307065405.37473-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6778EC000C
X-Stat-Signature: yqynpywdwyfoxozrjptea9sdm8bmj1wu
X-Rspam-User: 
X-HE-Tag: 1772866463-311451
X-HE-Meta: U2FsdGVkX19tdc+l7nwP/Yap0s9VlEca1oYjPcKhbFRKpxK+E1QKp4xoYeqb89VKHyC6CGGWCZ63N3ES4ljHibpZiiUVJ9JBFpQNgi3iQhjgGT0Qc21qkYzsqTNJTj8zU8udrq4s+CX4DYU6hEZRZSnyJGln+pnAEDx5DAUp3PGq4X7iLBZWGH6/34o82aDO4Vl1gpB1Pp8bnZTCFKE+wVTr1U9bGpiOmUNwurkEM1KwCabFpdZmPjVzuln7cMOMqPeFOmeCtQ/kRKQNqExFggYsfjQaWslI1N3ivMrhByGfo/JcTcgPhuvgv7sbktUV3ObWXpRbHz8ezY71bCInpzPPBUacXi8zCYqH55HZML5y59ZzlpEgg8Gemg5lxdz/4GBrwBbzddlpbd+Vzy522Z/7MtfXmaFvL1Aak/b9pau2ZNsHbSoNsduhyR4slf3x7IjVSyrq7idyXb4xmQAv6h16ST4YA7mC1ar3nCuNvkcm15bvt+JirdyBIW5f4NJ4ZbUpkR8/21zOFTXL4wcT9W/6xVF1GE7IGml8ibZztWeouWeuzvpKonKlWlAL2qNuyC/ClXe+XHA2cTEmzKKeM0LVbds37UVsP7WueXKAFt+mKewYK3uvGIdkKKeHWXIbDIcSC+rASM9fPq2uIsaV1z9c+uR/oJPctBC/eDw4RQ5YcMB54LkFtqdk0Tvc583mAiF/fZp0IlX+1QL9RNLdNCgGyjxGnWVwzIrcZ3Qw45ED6NcE27wGvw5sdt023znk5csIVSKfXWFBsx4p26JyzsEdVyjLWJaR2kk4Zyeem2JDXrqXA4D5wTfu7/1fF9rTEihWZGb3rQMKC1ROln3YqN3rlxRKqO4Ifn+4/ooZjvJWsRaQRQlC13ocjXNkS3Do8NeRzSDpP/zh54eMf+4Kx6bvks0sErYuGL1zLVTlAZaIwjOP5COGA85q7J9JX71y2bDj1+khlHjL1hKDua2
 8TWYTNhS
 Gewvsv+g7IMIXWH8P/i7hWDAO21V+AFRBO+psDjMBG846TzlZs9vwJlbmv4URPmRyPS0+/cxkb87EhUXxvZrqSTyrzx+skkRkTmqxcSQcN0qw2Y92GSWxfHRY5uvH0ffDJUi0yoKa4R/Q6jlSpLzk/M2NhiZtXFMS3ddNzZNE3o4mhhyw/dVQflaKupNaEEUqKyZfAyvVT8nLV49ghjod/IMlLJReQvaW0kKqPbjvD90T5MjuptujUHX2Z457cIc5Okrh01VuEFpz0Mh2mhO0+g8YtQFEhQclWEe3CBB2+0ZBjAjicB/PU7cLmxpb/kyLyhyBINtiUdbZLMy1NH8UztoV3Q86OuCxobFDfe+ueB/CBs/KHHD7+/6jPbv6xOZ7xYLbiaY/lElYLYsKZR8fiOSVLx6S6eWYpBcB/9FEtzqJ46NdTMYAJSVsk2WThDQ0S46eHdXgN3XTugjtTXuWoDg7tFSWws3yPpfgdmOMJ8WSKau6r5r0XGipDNprkwUOlVC6x9cOL2YmkXFIFxqiJRnubONL1OxzKtxLrVwoTjS0Xhjuder73/BzD6cDwIr1plzzmka92eEKt1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
WARN_ONCE with clang") helps optimize performance and size under the
clang compiler, but the modification is not complete.

Port the modification to WARN_ON_ONCE_GFP(), VM_WARN_ON_ONCE_PAGE(),
VM_WARN_ON_ONCE_FOLIO(), VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
---
 include/linux/mmdebug.h | 8 ++++----
 mm/internal.h           | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index ab60ffba08f5..a167c5aa525e 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_mm(mm);						\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_vma(vma);						\
 		__warned = true;					\
 		WARN_ON(1);						\
diff --git a/mm/internal.h b/mm/internal.h
index 6e1162e13289..52367f52d623 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -93,7 +93,8 @@ struct pagetable_move_control {
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
+	if (unlikely(__ret_warn_once) && !(gfp & __GFP_NOWARN) &&	\
+	    unlikely(!__warned)) {					\
 		__warned = true;					\
 		WARN_ON(1);						\
 	}								\
-- 
2.51.0


