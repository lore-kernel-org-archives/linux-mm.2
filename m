Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A9CC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 10:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328786B008C; Sat, 29 Aug 2026 06:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8CB6B0092; Sat, 29 Aug 2026 06:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2167D6B0095; Sat, 29 Aug 2026 06:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB88D6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:01:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 740D780697
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:01:06 +0000 (UTC)
X-FDA: 85153863732.22.6877CEE
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD65B40008
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:01:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KapEkxQu;
	spf=pass (imf07.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787997664;
	b=2XvlKGz8NylOStU1jxTGd76GABkMqQoWF3ZyI8ApTFFeJfYHqLapEPjdzcV4BsqkKgp+eO
	A04hFpqef0IhUJV3hoCl15jTG8XWlGe0MYeNSGvafXE9iupAUTPLFZ3kx3cdBScBiAokAr
	EvpZDJOPj9gcxjz8L+eHHjQQhboroII=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KapEkxQu;
	spf=pass (imf07.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787997664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IwFd7o8UMmNT+Gk1IhxdOOfmqQSINyznJ9kzHzL3VGw=;
	b=Tw5sYuVbD9n1E6uksQ+mGHz2Kb/IQaGjAd+McneshFsbXPakdedBZHhE9J2XYL6uLr0HWO
	qv8vvAQN7UaXswFlysNMElvOl/xLelxBeXzt/CYN6RazAnudeR24JaaqMAMwLY58zZpKQQ
	BIVtDwZb0Th0b2B0eu3l7dVeN9/BEOk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ccf2360620so16121915ad.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787997663; x=1788602463; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IwFd7o8UMmNT+Gk1IhxdOOfmqQSINyznJ9kzHzL3VGw=;
        b=KapEkxQu4waYPvuUlw4Ca+GFRwWB1UBSwr2e6kJwUkMMndYBJfFTSdvx1Wk0165D2U
         B/uOV7KjXaz+SSodlpGFw06/xpvaf6CKGp5hRh02WfoFNeM4+4SycCHhMDvoUjgquv3O
         b1prZ3NAH1uCvSJRM5vRcp8gcxi4BhBuaTBcbEF3KOIR+ZlcxG9qiOgZrOYX/eXmgYUW
         ae/hPcA3peDPjCwp1l5AJsJAeYJVdBMkWFlmId3lF29jTD6x1B0EZjVuB8NVSW93h09c
         PEcEYBLZnDqyb4gDnlVf56pM1DSk0eTWMirxBNNCuYfg7F3x3EPuHnnTWvQfKCxkEtlH
         FCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787997663; x=1788602463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IwFd7o8UMmNT+Gk1IhxdOOfmqQSINyznJ9kzHzL3VGw=;
        b=M6Z8E56gws22cFYZdPbZXU1YhZ/8PxDSlXue4N03B7hojUcRbBkGStMJe+6xAegQVU
         M7C7ci4o88S84MJVkh5sr3nXWiYrtdHqdoBfLT59WhqSZdOzsihjASPjQsUjjGMl4/sX
         lSKGzlCmSfVBbI//aM5Xi8AIG1bwqge1luqgWnHrsZznIJfpkdFSLH2y9JZ57t3ZRR1w
         s1LzO/Wlb0OaVvV/3cN5vPzctPdMFTeRz39n1yTvdwbZnU5tv/DtTRCstgT1q+rYjal/
         dWzM57n8H/iWnSFHACJAMTgIqeRi3sJYJX8aMCsmQSTjnkrKryfSVu5okz/QvGiMf7Sk
         pGNg==
X-Gm-Message-State: AFuF++nTLfXrNHCdVaSM1M01Eiz85xDT/QLgDIgeJnsakv9z6savCPBv
	IQclOBjZ8sDP/3M8IQa548b77Fm1uOxnF3jWV/X5CYbG5TiaKXl27D23
X-Gm-Gg: AYBFou3KiFlSMON/bDPuXmI++O8rbWwfIEjRNyOqp+t+k8GiBwwzQnkrtEvh5JinZsd
	2VPlRjJoYk1zP4/6DuHgxKFs2ze0r/+mApadSKYvwL5/MshOgXhoHNmZfDohi0wNzXFTiw6bO31
	6sIVKimXyc11jQItROXXXuE7riUK0IR+AHjPp5yNG6aXGrSUxlhmFO/AHh/5IKyi3YDAtVakcGc
	gUfHfV7qRMac4+3m6GHKtG1O/r7f/y0g63VpS55bGYj8BNPRJC5eXEsNsG5ziOZjbOXCwqF8Sc3
	PrAmYygAUnjbWarU3RjNKz6srwkW1fhjXXeDj/Nux+bA16pj941IfHuUQ0hNsI80xn0vhqJPqZf
	QBhW8oMdXzbg8jaOeaVsLNcREPqfaWHN8dKDyolHbgv66z+X+xP23YlgqUCj2krmeQWdJtbAe89
	d11nSwHSTYfgZYvviJ+L2byCdjT4KDPleLW5Z1ph0NsyvG/zgjLP7ovQpB54X4USFt0tlNNUFMO
	XHzqsaFOcHqDrP0YQPN/e2bo4znzAMTMT4CT8+4Xyw=
X-Received: by 2002:a17:903:1a30:b0:2d8:d4ce:9f32 with SMTP id d9443c01a7336-2d8d4cea3demr80305115ad.16.1787997660341;
        Sat, 29 Aug 2026 03:01:00 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b28ab0571sm1598051eec.4.2026.08.29.03.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 03:00:59 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
Subject: [PATCH] mm: fix the race on huge alloc failed
Date: Sat, 29 Aug 2026 07:00:34 -0300
Message-ID: <20260829100034.423064-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD65B40008
X-Stat-Signature: aun7riyeq8x7fk6tzuhtmd38igkiekgb
X-Rspam-User: 
X-HE-Tag: 1787997664-708285
X-HE-Meta: U2FsdGVkX18zh0x8fUAAufA79pvdMdFIFMkdj9/L4WF2wlaUUxq3zG3Kek54F1aPcFAdm28c8C1VzbPNkL7A3iODCSu+h6fOUONSbLTm6Cw2eJDSRBYmLdHBc9Ml8912jlz6wv2GzqZYh0+FqcJt9kDEn8HsbzhtyND0fO9BglCZOO03WjlsIlZjEOIQPjDwF37qs6gKJ2Edn5v0wvXvvbsY/CNNfMq9Xj3XSxjCV+DIBCNwrM0bK/If2lgds8lu4wdniIm84Ht6KboXdEb1YbaeDajNMIkODQ++cr2uiBDIP+4PkyIX3kLA8pw+GfHXAzBq3KS14ld8oCc53X1e4+gGVArqJyoYDy/j9TjFBTAtlk5budBRWGvzRqIy6kOHc6Iq3BUKMlGpl7luYeT9Akyt2hYR4MeJRnOng0UkU9VYSa/3yXfxHLmeXleUor5bAINOvm+lpn+3r9HzCSueepG3bUGN19wGq4n7KCA9iYUYje7Db6tTVQS/tSAybM/l9d9kbGlvyelYIb6YjJ5TtssWkYXXuwlFQutDvOzMtUdcFsoUdii/S+L5iGtOzjCmNI945rDw0Me5Jx2ABswF0TrynSQf8ED52tXsfg7SGK3SaQ9Y9H6EraP72eCcpf7o5QnMKUkKi0lsxa28arG/cdYZh2cUCxbYjTCozqKiHi28AK3U/CNVuzrfpy7i5yDjDU7YBNNpBl3kQOFKmPXXGD5TSa4Y20rxpd5Bd4Z1O017mM5z6fbsZaLxxYIAjoIpvZx9v+jbpHYjdLSvTJK1hyV1htiMRysOIk4uQPntVKA0KAlWvtlm+2porlHgrrMI7VvNRi7vMwLGYl1PxjNOieVIzXR5Hm97kgkpRTjMlRcoqvu1TH5pKhGfmr5Lb7Lg5ou7fF+g1pMF0yaD9WQdFxKPwdLJqq654Q0R8UbSUFD8lm3yZc8ZMZJmWcjz0Uzdu8Um1wfmk4AgdUkX5f4
 RkzDBLl9
 mQha/XRt3L5sk/VkmTJkxE8har7HqyhlLMLBbJQiknuwy4/JIl7A44Cpux+5GrT6kzYFmiWOL/BtqaBq6avZQxGNtuHzK2NyvBZSoRxFMWTPqjIiRJC5teRaL+C2i29Mo1MYJ4Fbpk7MpwSQa0S6P0TqmBq2HNtpw6rjS2+FxXMb5DZHhxc/M75d+lVJj5b7gHbYPOCaWJIfuwDUN5TbUIZHNkOKudmyF0VgDWYkhDmheYGfVw9IGu3AhAs+7/x882An9/i5O3znE/kr1y5M9rQ0vnKMnxkPKH0giaOYjq5dGwOdJNRS+SnD84q8WpMmD+OBka2JcZXVo7n96tn2bYHV74XyuCj1EcPYdKUR6F81k0/fp7ZAhw4EttU8EbWDIzZSQ3U+6etcq/kbaKDXJWAESSsxZu/hnbhia/Olt3+ZwcamPtiuuaKPSVDsTZdwPkL3oK5gsV5c+geIFPjxUAPg+m1rJ0EMIPf4MDuY5dC99GE+VApqPpxP7AOIk3dtGC8xf0eH9B46gG0qY6BTQr1eKpJXQI9UlY+kOU6YBExLpDvjEhQRXm5VpmIgrdE+IOanQYbPlduYl0HHuKZuUJLl9AHI5srvDr9+k0TbnUTiBmE4qojMksg9nfzSvslOO4gP7oYJQVTznFp9Hrf27ReXJZ8rp0SlGMS5Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The race occurs because the reader (__vmf_anon_prepare()) checks
`vma->anon->vma` without holding the mmap_lock and withou the
READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
mmap_lock and updating the pointer, it creates a data race as the two
access are not properly synchronized.

Use READ_ONCE() on the reader side and WRITE_ONCE() on the writer side
to tell to compiler treat these memory access carefully and not to
optimize them leading to inconsistent read.

Reported-by: syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=395b7abe9696862fc188
Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")
Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
---
 mm/memory.c | 2 +-
 mm/rmap.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..33c1fbd30cdd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3820,7 +3820,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
 
-	if (likely(vma->anon_vma))
+	if (likely(READ_ONCE(vma->anon_vma)))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..9d64d776b8c5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -209,7 +209,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		WRITE_ONCE(vma->anon_vma, anon_vma);
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
-- 
2.52.0


