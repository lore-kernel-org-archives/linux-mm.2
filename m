Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FACC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559AB6B0088; Wed, 30 Jul 2025 14:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5320D6B0089; Wed, 30 Jul 2025 14:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448436B008A; Wed, 30 Jul 2025 14:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313F76B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:33:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8693C015A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:33:21 +0000 (UTC)
X-FDA: 83721778602.08.2E82D32
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 41AB44000E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:33:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8O4VZt8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753900400; a=rsa-sha256;
	cv=none;
	b=YVpNG11VBTxF+5dQ81BWX0ZhDGO6QV/RS6rzrT2EXuSx1gBPXdqu6O03qgG+MLqy+VB1pu
	OepidZVDIKv8ZdF1vqLmhz5lD+OkiEPe88I2ZC4Ny6l0VpILDNXz+3xTj5aSOn5K2aZ7Ic
	CjRwbGEFRjNTDUFjwqygiBWaf4KpbZc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8O4VZt8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753900400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pfr5Mj0mOFchlFGCNfQ/8BknjNq/tL5+q+1cQf2WpPw=;
	b=f1ixNDDqOcUDtztn2f5TOSTMMrPjVNQWKVWjbYPQ24L9+Fy5FvReGzCzw6Imawf0oMG+N4
	Por/QaJ17AmQpUJsBMX2DXPjpeWMqR4PP4P+fl30rrB9cxJIuqdt4b4kfDmh+UboXl2BzX
	UCwb3XoTKWRBbcUZqMixWWP2lXCw+fM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23fc5aedaf0so1501715ad.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753900399; x=1754505199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pfr5Mj0mOFchlFGCNfQ/8BknjNq/tL5+q+1cQf2WpPw=;
        b=E8O4VZt8ek/w/aBwBpD7SsXMhp0fpkKQYV0Zn4xXi8EeHrUd/ZwF2cQCjTW1aiBor1
         pCgbViyGxWjYdQRwhUtRuW10okLmB315Z3qwnZUJj/hSP04g1wWn0FkJUhT22XLnShIK
         qCWgXvz3RKi+cLSaFSOEPhGvlqfA6gDpdpyUu7vXMQuD0Qs5QuH2LNG3xrrMkYK5Wxjc
         ynNVBW7vHm5+NxBoNG5AWwjFSyj2Bx85tjr1UPuO0ymACK8UUweWRr9SymsIJC50/k09
         okTLBM5N53Zqo44Wqw5BqPbZtf9af6sevuCY31RLfBxAah8t2G9BRlG/9kByPtkWkyEN
         Pbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753900399; x=1754505199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfr5Mj0mOFchlFGCNfQ/8BknjNq/tL5+q+1cQf2WpPw=;
        b=VTQjWvYQYGg2acjlUKqFD5xiWl0iGkxFWl1CLhpinAy8L6yH0M/oIiVvi1S8pt/FDS
         +A4oD0y7jFA6Tk+mMgqtL0aGjUqEZnWr/f5kKT0Pyxuamya2aToi4rVDwENO8zMbzfkm
         vk1S44CmaksD4VKAdly8RLDt4vhzWOCzLZjP6VJxJczmW6SIKzXcHOX9KGU/J3ZTWyEw
         jTDx1lp15COgppi0UNDNGsrCw5+emAtFvXlwp27vcv7useu4kr7lkpiVjclKcslb0S7Z
         zeOwalELxlouQjoYdGr1Q4uVXCExUR4vGpUhSksjNWkeOs5ZwqOWGUPIm3fA63kOXwFT
         tzuQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4gJ6ve5C92arqRKqb8qTfr2KfA+Io1RgtOf8PoEZQIII2PTLe67MMK3xo8HWF4s9qrPejdRzuDQ==@kvack.org
X-Gm-Message-State: AOJu0YwQOAqX32j8uYjZ0kQCyeRs0KPL0+2qGBiBm9Dkysma+ZZfoz0y
	nZxhxmcRdBz8ztG0hzIKbF8nXumHCg6iMhCWgwQPlkgdmXjhbE/7m3Sk
X-Gm-Gg: ASbGnctIwJhMSxMp61nte14IIY8SxtMzmgTF0IbVPZaqHZMSF5pVOv7SLwPC/5eJ9/f
	Gf+y28AmnYPeAHAC6etzkqc5gw728F7Fydao3dvd/be2kuzHNQPcTNWlgIwbf5/kR86nBKkkjND
	NVxcFFA4BOY6K4YK6LVuBKTPg6GR+kus0vULe1fMO9LGkXfQuKOp7RBAiA4i5nPOxJpLmcr/IvG
	kD27sLBrHFLvaCkLoK3img1KW56TkJbt8n/ewt3yhKuz+FE0qPjyjY0fbfhZYLWA7HBEYg0XC8d
	NRPNpV8GPtfVBH/eb9K2Bqjp+uiUut+RIjLEqj5xXh35w+6HUWN1/VheuC3D3NHd+04q/z9UxCs
	eu2GIWnbvamdn3Qry30/whjlQ6JGs
X-Google-Smtp-Source: AGHT+IFk72ahEPEvl4D33vR6IcdQMO68lWrfY/canlFV5/QzGCtlFRDGLGn12c9w9tg2tlrldBG2bg==
X-Received: by 2002:a17:903:18b:b0:23f:f96d:7579 with SMTP id d9443c01a7336-24096b3fc61mr53132105ad.37.1753900398941;
        Wed, 30 Jul 2025 11:33:18 -0700 (PDT)
Received: from LilGuy ([157.32.139.86])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2402efa3500sm73585585ad.31.2025.07.30.11.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 11:33:18 -0700 (PDT)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Swaraj-1925 <swarajgaikwad1925@gmail.com>
Subject: [PATCH] selftests/mm: Fix typos and improve output messages
Date: Thu, 31 Jul 2025 00:02:51 +0000
Message-ID: <20250731000251.5412-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41AB44000E
X-Stat-Signature: 7gu6b38jmn98oz8npk7yixhcy9yacdi4
X-HE-Tag: 1753900400-398903
X-HE-Meta: U2FsdGVkX1/NdyaMyNnpUXgpwU3LIVW+5Coem+NqhxlSlhC6mbJJMA9l854OJ8/08qpQnxVOjHkkuwI5zWN9tXGyaCt6TTQR3z91OMZeWpGI+a4CcXPx4FKkBWQEaGarD2tgAa6VrcOHDX7qLPgkYZETf93Q6HZFk1nzHcCi0ANbyLWRaMojYtibz5HCfElOM/u6kwxQrdl8QwiC9xILK0+Yz/mHNzcXC4PMOMVb3UjorlISJ/CJcvLcy/D82yDAphgpALL+wiQdt6iheOeLwrJyi6nUyv5z7jTcNbPmDdJN4Z8PmEn1w5DJT8QP7pqzDRxrJsq50LqbO+X2L5zPIh/8wbJsV/yRqcf4lKN8zXA+iDxDv4MhOOtHSGL8f/HKyVWppeHIPqGlWFrPA9IkR3U3GTqTbaD935OzlzCQ+isY7rpU1Als6FNMjgGcDkJg28DdbaZPHGYvvwUrN1ubAvvTLLOP/qj+LWc+gsQVMctZt2WgqF3rUrV1OaVhOe3jir0s7g3C1eioqd9GloC8+jtwpJ+Susvo/THLLl564GBD/grH/d2hhIOwXOyrmXaHoTIoRbq20r5bicVPHLq7xxTaHmSC3IC5oTcnvzeqUlTae2Kry+Feq/9orSos7Q+d9BNL5bDQuhsoC6sTYmGjVYV1KUBzBRoVRBD9TIKxkM0CbyxVG0sM6IbfOrIap9sZR7GFPVIVrH4k1W/TPWfyL0bwy3QseW8KAxNrqwBIj5+HiajJNv1RBSjCfPAtS0tNDDoUu4bvZoNtARvorwvDlqVmUBa2X8Uyhs+31Jj0bcAydulsvo0cdq5gyM222CfFpa1HXMxVIej0msYMvrUknCHVbZhQpGidVaMNemwp/YuTBIn75fOr9ocOJPWMeXOT2EFBQasefbFvpEhQYH2HSWHxibc9UgYQDWHg3lZGOj4LnI7PBfdbRq8UHxMzFCc1za0p9r6ACFMmKwINYI6
 Qpt011iN
 3lgK+GZrJe6ZlbilVVHCk30AQV0kOEmw65/VZ+ZCk6q37sCjPhx82kXOC8omKmYvPmtutk2Lo7ecPylDAD8m4ol0hjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Swaraj-1925 <swarajgaikwad1925@gmail.com>

Fixed spelling and grammar issues in test output messages
to improve readability.

Signed-off-by: swarajgaikwad1925@gmail.com
---
 tools/testing/selftests/mm/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ae6f994d3add..96985c545d16 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -48,10 +48,10 @@ ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
+PAGE_FRAG_WARNING = "Missing page_frag_cache.h, Please use a newer kernel"
 endif
 else
-PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
+PAGE_FRAG_WARNING = "Missing Module.symvers, Please build the kernel first"
 endif
 
 TEST_GEN_FILES = cow
@@ -202,8 +202,8 @@ ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
 all: warn_32bit_failure
 
 warn_32bit_failure:
-	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;		\
-	echo  "environment. This will reduce test coverage of 64-bit" 2>&1;	\
+	@echo "Warning: you seem to have a broken 32-bit build environment." 2>&1;		\
+	echo  "This will reduce test coverage of 64-bit" 2>&1;	\
 	echo  "kernels. If you are using a Debian-like distribution," 2>&1;	\
 	echo  "try:"; 2>&1;							\
 	echo  "";								\
-- 
2.50.1


