Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B19FC9ED3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 09:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C836B0005; Sat,  7 Mar 2026 04:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419936B0089; Sat,  7 Mar 2026 04:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAED6B008A; Sat,  7 Mar 2026 04:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08E566B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:22:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 983AA1A0BF3
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:22:03 +0000 (UTC)
X-FDA: 84518725326.04.2A9FC1F
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7D87100005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:22:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cB90ZxwC;
	spf=pass (imf14.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772875321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tUDMCyWm+/oO4Lw6ZRAVy2JWY6tSsMFprlNQtLkw/dA=;
	b=iXb45eTNfgx3GHsA3OaVk8CMzZlcrhEQRyXBrNg53vw7TV9a134qjPVfVCI+Gr0UmE+iEF
	mXAxFGYAxjDm/DpPbPADwWK/zjT/DOaESTPvGiNJOLsgRJQBpVa4vqJ9bIjvIYfLjNASrt
	EV4gNRUMGzQvRFxGhCXC8niesgHHr+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772875321; a=rsa-sha256;
	cv=none;
	b=xfyfWfn+tFAWR+nancFdHXNALhX7EPJDV7NA+CcvKjVjceQspwCv4aiI3PR7AUZYJH4iPG
	uC78QTGXbokRbnjOkLggJvT1jrLFX1qfvq23mUJTtx5yTNI+21sNyFgOp24PcxPYleXevC
	ZQnXS6V6FJB3FUKN/J6D+76MEJGXfbM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cB90ZxwC;
	spf=pass (imf14.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ab46931cf1so69166565ad.0
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 01:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772875321; x=1773480121; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tUDMCyWm+/oO4Lw6ZRAVy2JWY6tSsMFprlNQtLkw/dA=;
        b=cB90ZxwCIWIXA01m8iKag3hCUUyyzk8bJkCn34FEDIp/3uv11DwhT1m76tkMHjzhVo
         yGtOmriPll2G0kemYiGvv+GJEQe0/xutwEpaF20iASasIu7523dwFJgsxicbMQB+vP9W
         SglPzwe07WyS7P2k+uxV8LLJ+QO2nquLskWibv/mt9WqZTk6mpZ/JvB4Bq0HLEaVWJfu
         PB435ZkUzK9enuc7nObJhIP3wbDpYHmQcrR49X3xoFPHIgan5WyJBhLyqh+/RUdEmKT8
         MD+HL2+CT/Qcfqu7ChTWlBcQRlNNxiPas2QRcL8Yzy+2z0CDHE4SbNamK63wIvwNxUTP
         //1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772875321; x=1773480121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUDMCyWm+/oO4Lw6ZRAVy2JWY6tSsMFprlNQtLkw/dA=;
        b=vKXQxHTAkFw+tkaWzQ8AbNGIOBq+W9C4NDf5H9fekUqbxPp7mJ7cSR5pIPwqxnoV+i
         GUGyBljz4KuCMyMonsdOUSGuKtH8U4fuAj4s4e/j9WyPi0V6bEon2sqkOoWtD7oxCrmo
         ZvCyWE9XKTnsTLdasFN5d/tql3Yl74PTum6aGdSpbp1+uMPy/kG+IFy2BWXyJuT7T6/R
         Zycu7bm1b55O6auSbZ0E7GIc8fAwG19YwdHtzr9+rX2sWjgIczCPpQKnojsTjVd71xDI
         YHOPHI1cG3VmEzjxEMyyvDaiG7l8N8yzWtUzWcAbcxaZPA62X1XUVm5L9T8as6oqoRue
         OvYA==
X-Forwarded-Encrypted: i=1; AJvYcCW1kWW1f7JIjySenhO+xukU2r67ekzoRnHFkehs53HOho8WQ6AkjgizXfx6CA6CGfb0mIBHc6UdWQ==@kvack.org
X-Gm-Message-State: AOJu0YwP0HlnRq3wn9NlAfkUB8rFU5K6rZbESTCYr4gjQ/RPdph1Rhvh
	Z9KxDj94MAmBFeibEaXsorflCcxQeXS+leb0x4iniy1ARxvwyv247Hak
X-Gm-Gg: ATEYQzz4MKu/oBhJDu3KwdD9Dbv75ELl1gkGPt0dEgp+kzdKsrAkyTYwcCW4u7VYbG7
	qpwTKSSeo6MkJ3wW5/O889OGAzwxRkMw/e57a+RqElmfIXK7ZU5G6woTjzN+uFRujpZp7LSw+cm
	TWYw7Yy9gJQm/f7qkZhq8/K9foXUe1o4/HVh3J7i8KoG+fbDa5GpgX7dKye5+rwWNJW1vRpW0h/
	ZLF6qmrg74JXhpk8TXVDgYDy1w243GcM43p1cuUdYTxZZi41+aEutEEPcDMuDyPRqKJ5iU7oSd/
	yTtS0sfIE4ZBVjxAN5eyE6uQhqEsEZVSKqjaoa6tHSR7SRUUi7PLVIdT9N4aKH81LIeRwep3ZSM
	ohBbSiBxrWnd7oc5QegoghoUzRNVohX0E+eSDXiw5b8qeSJfB+stogvaypQ8eQO8X5xHgZNaM8Q
	LlkUP7PbDICoo+9fA/1tY9e+etfk1eZwo3pe5k0ehTJ5q8bNQsCJgIopyYIls4Q0uJLinoqyOu7
	woxaunJLBJgIg==
X-Received: by 2002:a17:902:e541:b0:2ae:5c39:89c9 with SMTP id d9443c01a7336-2ae82a2598bmr47067115ad.24.1772875320536;
        Sat, 07 Mar 2026 01:22:00 -0800 (PST)
Received: from localhost.localdomain (123-194-188-82.dynamic.kbronet.com.tw. [123.194.188.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840c9967sm57525115ad.90.2026.03.07.01.21.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Mar 2026 01:22:00 -0800 (PST)
From: Min-Hsun Chang <chmh0624@gmail.com>
To: arnd@arndb.de
Cc: msalter@redhat.com,
	akpm@linux-foundation.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Min-Hsun Chang <chmh0624@gmail.com>
Subject: [PATCH] asm-generic: replace ________addr with __UNIQUE_ID(addr)
Date: Sat,  7 Mar 2026 17:21:19 +0800
Message-ID: <20260307092119.20733-1-chmh0624@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7D87100005
X-Stat-Signature: ud9rc7dj8wnmwbnftozmbmqd3z58fg5h
X-Rspam-User: 
X-HE-Tag: 1772875321-693286
X-HE-Meta: U2FsdGVkX195MLWrPhYAgI28a2TGIpV7AOLIN9k12+EmH7+6gnsMhWzTMfGJk/vk8bml0hh1AB6s1OJcqbyNyB718EiubysSw4T1R2igPnQKe6J2nJFhYgq7sVcZNJKyR955RKltD5aqnz0rvrCaV113rTAuI8aO9Zj4QBSOq7sov5j/h6HBL5dYh8EA/CuhnlOKXgR2ZdTENRXs6Wx8USNgUh7MkgepxpQaKn4+xiUCppvad7pWhY0s6c/iXIKJFmYKwYeAxNKcFcmprqG4pEVHkRwjfAjG+g38wkM6EMQjjgaYkpL1y6BQRVAiEfbrxC6ZpZp6aKpoVysBYoy+LMxfs3W46uVYwyHp48yLsMTYmi/RhOcxlkyIoPZbQmRTF5SPrQ85asRBicvPQwjUepIPn2qmfIAGqHyFaK1P2y1LlU1/P/aogf52qTIqs5sfACkhF861m7Hj9tQS+eZfbrTqdDyNLzf864/Dw/Oa791sooL/X1CzcSqG/xXovoXMDQT56ytUHrhkHkCM0ma8lODUnOdFJ/qUUu7Dr1Hvlwznm3YlnkRnkJr9dMJH/ai2bIowsQaRBknkwsJHL1WX+x8NzZ5EwStk87gCPbnd0ppvYr3xBIALwW7jjsOSoWLLkhV3QiJe+7sW41P/eaklAuUTjGLM1nlOb4QOf05HFoD3y3RnIY0z6eWGJVdf6yyww0PFhCiy7jKKYj/K84ZRczjAclRxh0kSjz+lf2fyRi3X81u6DWovmPPaSddXXHYRdZnLFUYaMSD6X9mcrd5ao4cPsbzHInDulQwQcnJfBH7brc3kcTkhB8CfG1DchPOQKFMMV9Mmfo8LjnZiv7WKk9iUbrnL/Ypd5romJ15r/dhs69vBQ7g6zmMFVZIv+PAfu42oeGiqRJSdyzEdLLjfiz+6sIuFwYN7yIADzsJC+kXRSCD2mLmRrRvnAd+GLPRiEqrFK8cedxzQe9LC08G
 2weg3k8V
 FVwq8lbfLhxWsntjDXDMgc+T1UGMu17G683/7Vo5n+s8ny5sZxe1f9lgCl66vouH1fi/7rjm7zo/nE7pjWrLN1eSheDUF8TBNROyfIUuDfwmB5bGdxJqhOZNjZpCJaziSNbk7IB7YQssxurqfBmRvTsCGyIjb3Yh1Ay9/3ZqLudnT9/LB2KldhFtYrjvwbjZx3NAD9AcdrXN/wBq6rz1yFknMCLz9jiMrwLiC3Y+vJTXnlXIZ8TagBPY3IusZBp8FxdqQ/eLOKp8BRXRI82x3sgoEZVVBKBF3EczcQG+sUnXbvhro0h3/CDm4utLTYywYY9Kg4ZF10OOJymtGCPFuYekbJBpIdiY1roOAAwNYnc3pYAMojqfYXgcEWCK6TP0/eOuMOHVMl3NtlB+X79D9hfH1r3ICWO3PiRHK2n6DGjFffleSeFQiW0PoOU2QQS1y0dmpzb9A8kbLbh/gYvTo+ip955yWLRqgN7FlzNlSgn+v0hQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The macro __set_fixmap_offset() uses a hardcoded identifier ________addr,
which can lead to variable name shadowing if a caller happens to use the
same name in its scope.

Following the pattern in commit 44238e82670e ("rcu: Replace ________p1 and
_________p1 with __UNIQUE_ID(rcu)") and commit 589a9785ee3a ("min/max:
remove sparse warnings when they're nested"), replace the hardcoded
identifier with __UNIQUE_ID(addr).

Since __UNIQUE_ID() must be expanded once to remain consistent across
declaration, assignment, and return within the statement expression,
introduce a nested helper macro ___set_fixmap_offset.

Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
---
 include/asm-generic/fixmap.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 29cab7947980..2d1e9a2c6a3b 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -16,6 +16,7 @@
 #define __ASM_GENERIC_FIXMAP_H
 
 #include <linux/bug.h>
+#include <linux/compiler.h>
 #include <linux/mm_types.h>
 
 #define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
@@ -71,14 +72,17 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 #endif
 
 /* Return a pointer with offset calculated */
-#define __set_fixmap_offset(idx, phys, flags)				\
-({									\
-	unsigned long ________addr;					\
-	__set_fixmap(idx, phys, flags);					\
-	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
-	________addr;							\
+#define ___set_fixmap_offset(idx, phys, flags, uniq)            \
+({                                                              \
+	unsigned long uniq;                                         \
+	__set_fixmap(idx, phys, flags);                             \
+	uniq = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));       \
+	uniq;                                                       \
 })
 
+#define __set_fixmap_offset(idx, phys, flags)                   \
+	___set_fixmap_offset(idx, phys, flags, __UNIQUE_ID(addr))
+
 #define set_fixmap_offset(idx, phys) \
 	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
 
-- 
2.50.1


