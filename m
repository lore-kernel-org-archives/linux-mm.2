Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037BDC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C32A6B00AE; Fri,  4 Sep 2026 06:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AA46B00AF; Fri,  4 Sep 2026 06:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A546B00B0; Fri,  4 Sep 2026 06:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE366B00AE
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:49:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE23FA3B4A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:25 +0000 (UTC)
X-FDA: 85175758290.29.9381277
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D7AD1C0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lbvEPN51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p3qhdKCBh5IlPhZs/uQwjI5uPM2Gq0BK3muJ2QsC0g=;
	b=OyoTKTK1yq4FP/pZdcAZ55FP57QGx57FtixEbbSQ1hCOAjnWTnOLRnE7+2F7mvBQ8NIVro
	NAqB/pkj9yjr/UpP18jRK41gmoN8b4ZxZiXitVKXd5EOYgtviLKKsH8GB02tbEJDoiBAwL
	covozpCjtV6RFh9GOq4149GsvzmxSe0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lbvEPN51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518964;
	b=C+Rn+67vzeee7UhKXCK6fBPTCEuObtPoYacXdbd3dL0YC8YgY+CXQNzu1m36fq0VVU9yZ0
	VcpinmERALZ7znizbeldIQHDWSKmFGgyBpddir73iNiMheO2V6rvT5g3lCHLfVRhXBZkCq
	KZjPNya5KV6eXSjtcmLLAyqfZih58+E=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d53197d8b5so7677885ad.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518963; x=1789123763; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+p3qhdKCBh5IlPhZs/uQwjI5uPM2Gq0BK3muJ2QsC0g=;
        b=lbvEPN51pxsrbDV1Tk5slrVEUq1wGdr1oCNJwb8zslihX9qtdeK0WcDbfnOry5TVWw
         8le/lnQyzpwW3uozbhKpyaThOnXfseF3WuGOGTrEOhTkXB/M0u7jzKer0bREIKi4lPbO
         e2weq1dz+vjbSRTmQl/vklBYJ9ytbfOyjNBWpB9XQz0Jg9EdoRXrikUL1vl6o5Jh+Ljb
         lDZtV2rqcKBsFIWocQkTwpfl7PS4RzY9d5/pJR8P4FMQ/qLNSRld6iZGFiHF2erSkYug
         v1wjBzS4ElqbX4YaoyNrnyl2yaJ7nq+VnUCvx9ZRkVV8KZeIvIR2VUsWFNjbuC38NfM/
         VGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518963; x=1789123763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+p3qhdKCBh5IlPhZs/uQwjI5uPM2Gq0BK3muJ2QsC0g=;
        b=geEs+V/L462cK80mmYY3RiiQnFtp57Fzpmi+2axGvj1UE+76iIv6sBnoPx5FFbtcNq
         OHOWc67zDMIkEX55kE6hkUeiR7rcgakFbfpLVV8NTOnqAQfJiQfyFz1c0OfXVzbWOGbJ
         N9SSXU7+CLj4jF/qYZVSuCxtxlyyCUXwUSEKXsWL+hquw2uHgykCC6Su6dXrxeDakaVZ
         gq5yHi7wMgkuzb9SoGvl0It0xSMXO/zq4bMnp5ZrsFvc31KvvUO2i5xn/72TORyCWhVh
         lvEu/i0wdYu/hVXaWiDmoj+Vcmh7xkn2dAdqQ00qHmqo/lpFg/nIo4UXEALHZkL8bEr4
         yqtw==
X-Forwarded-Encrypted: i=1; AKwUvByPuyc2+fWN1XnWy0RFeMri+Z7vr4pW6y39wuh+Z++g3cdh2zCPwUUagF86eu+HwPQP8VUYqXau3g==@kvack.org
X-Gm-Message-State: AFuF++mtD5zh4wiGHEC+A4l3g4iUTCCBrLInqmQqG2x/2oJzqQc2xVA+
	4qRW/LQKy/zCxS4sLFiAjz3oShaJ1s0i2vQMu/PUBB/bHtcJqo161gUN
X-Gm-Gg: AYBFou3+QA7ZglxbaUFTqtlo4gglCa3Qe++Ly+5NjozcJXChO4/xu6CyQqkyIwfUrLZ
	K+hklP5QC2nBlztBU65BtuzQzYBIgMAUBbRQSwDnlKDtUyE6EzMXbNr/3RxEvXRUPqf0bSc4Hgv
	N48Rp3E9X+Pxk26ur66qZ29tFMSt4IowOpb+9zYM7qyX9mh83TS/wPEiv5nxC7JpzohLR0VI9P8
	/a8Nmm3EsNDvBhaCshC6Q85NkyzPCwWp9gy3kcmIx9nt89ZkQcw6mQJxpZjoOJTdhgGFdVMlDj8
	ZNInYdWzcxS5th09MCOGhrwbaMl48jPUE+CDB2RhHrple8OGmPcOCK+8XVmJsvhJhUlrS8YrqG7
	lTYkl6dKWEwAEFcJmyk9DyezVCWYsOoWqow79QaHXSftM4y1pe4HMuwJvKGg0O825HAeGLqalbX
	MxbipapAFQPys+P+K/ICf4NaMu2JQXJX5rPZZUtL/7vJfNiCFWxOp2A0rSnOfYrFyQZ2gCam8vY
	8GFnIHKyv0PQVdLFZcMuBn8lXI=
X-Received: by 2002:a17:90b:3ccf:b0:399:ea1:5a82 with SMTP id 98e67ed59e1d1-39b26101277mr6729394a91.3.1788518962867;
        Fri, 04 Sep 2026 03:49:22 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm8583927eec.16.2026.09.04.03.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:49:22 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] tools/testing: fix typo "mergable" in comment
Date: Fri,  4 Sep 2026 16:18:50 +0530
Message-ID: <20260904104854.25272-6-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904104854.25272-1-hemanth.selam@gmail.com>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D7AD1C0004
X-Stat-Signature: ts56uegubbh4xg9hgxwea7fs8ipaqyih
X-Rspam-User: 
X-HE-Tag: 1788518963-124877
X-HE-Meta: U2FsdGVkX1+tPw6mM8sHQ11jdZlBNDO6B/J+8iKG7oYptNYJgL6/cFZv/1IaH1EvhdWJAYBmXTLJ1YiK7JR88en50vnUnMqrk2r/55n8345dm0M43zFH8cJ3/le8s0Li0VZ1PtAEQmCbIsfRc7FQuV1B6saUAxF7PdSZNVgR+Tb7kXZqID1K8uJqLA6fzhgYoIGV1YK/CV1gWZIQaz9BkEJauZJIJitbOHwP4MkAcUO8VKmh7Aqt5gyZdtAa0Up0F9ANLPVy4l8qIPcIVyeDPhRa8ysvzoZeFp6HV08YqBK9Ca543Zvxs4fvELv4x/35LUw6dSppZ8hrosIb0XccE1YZeT2x0uvAxpLlQRhAuUTI+FPK2mtdYLq7KsUWeb5GI3TEe2LS++u+rYr+mIsocuTYlBRWSVK5sAxrrxn+zaawfkcl8Je4jmLIj6N+R4X6Y4aZG0MBirrZUDfG/ypwGImKW3mlsjkyWC76bwBFDjh3t8qoWHvQQ08lTIBl8eQWGhreCkYb2dCA0paaihrW6gvSJqKk4+vblmnKJZ0EqaBBBaj/fvLW4fA/TLymzY1KObvcQvIGXdkHWp2qYh6Shn4fxb/1gbs3einS8yVdjBBKqmqCei6hY8XaCJi5sQ5cB6ecarxX1yeYaqh4KZv9xyBYVRXM2xr0Lf/lTzKrPqSIPlm5BnoI2LnyHmcp4cDO2ieeukk1WSb9VRBtbpdOPdkK6Ztaf7KIO4in3jCQyzwl/jtbrHcz0wLVeIYCdjYWfEGuQfI7KMplKmsFwngzthZXj51XbMKzeVzlQTRSzFCRUEeEA83hxRrsQYxmrzCs5vBJp7uTIEIIUU24CSNI84pQT6jztxrQ6JQUW7767wcgQXS/gV2g5K1/WJdb0uXF+mABnAfoEsRrFvlQM4UEmgYNcA/g0ZajEv0+9mBI57veE/QR1euq6GzV3jtXHzOHvefYQorGPgxwLThm2Yb
 qW09VTpI
 5ytKFfq2oNst4cZLlhB73OmPg7NBJqpFq66AYvwFo29VGrk+191mHVAsQW+VskC7gk4mXzwqqBSSWVA1LQtm4UvgUtIcU+vW3lWATbJLB+2pYvFvKG/e4meo9ALEf+QsDyW1hpYRiVitoALpFa+qE15ipgiFnnkvJPkTnbi3FgfxG3A+jlHgqNZ28Lgm2t3Th80zBDhaUciv++xHqbr0WLSznuueWDd29JB2wh3tL5kdO3zFJFmxEbPGBSw9lEzbYgiAGN/PgPeuF69/p8XWALP0eSKVq2VT5Nuv1gPwypnyLjJutx+75RC8TtirMwQE2KwYY0pIpN14wYU30Es9b9c/Fegu4L7o0Rx4r/16mdJH52z90I3XDr7Kq0vwef06c7soBVo4mOpm94rcbW1x/6YUFZ3Jx2TBM47Z09Y56WU7g8AgvtiRXI82rUWkMX/RlJP9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "mergable" to "mergeable", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/vma/include/dup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 4c58487b764e..302a6774fca5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -353,7 +353,7 @@ enum {
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
- * Special vmas that are non-mergable, non-mlock()able.
+ * Special vmas that are non-mergeable, non-mlock()able.
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
-- 
2.48.1


