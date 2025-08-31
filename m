Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4865CCA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5991F8E0009; Sun, 31 Aug 2025 05:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DEB8E0001; Sun, 31 Aug 2025 05:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28ACA8E0009; Sun, 31 Aug 2025 05:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174AD8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAF6B1603D8
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:42 +0000 (UTC)
X-FDA: 83836555404.30.02A1307
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 12D2F40009
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e1fyTSQW;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
	b=2y6+VOS2WgQyAYmDDSOcM5SHjDvgvuybM4CLWVmzN03G/AgmmAaAsWv+I0Kg6RHNPZuPwP
	Sw3LJYUVuxbQW4Uj3LrsdcGzrknmxTiIOUNVpU4IngiFB5ED3DIk/thAtQl7yuurYraVHm
	cd0YYd0qFazAfFfetUVyZ5Gl7zngcnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633181; a=rsa-sha256;
	cv=none;
	b=lGAUDpknSH+EknKxkCYwlzNJ+HW9KzHSkYI20o2DUbYoRmXAiExIXJalJlackqYh9Hqn4I
	cuLngH3o+JsNGYPqcpwH6uVGTXBbG0bwN0asQk8W7vvoA/yMQ44M22hAqTwT5F/a1g4Ls3
	zusq0XbwjmyIq3QJ+K8zGcjqj/88cW0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e1fyTSQW;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aff0365277aso303077266b.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633179; x=1757237979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
        b=e1fyTSQWybsN5AThp01l1zl1clpt49cC/O6vVY8SxHO4w+SYVShNaZwBwQLN7BOwXC
         Uq7bLvD7gxKoqi/IadIwF+/r8StaAVUC/70w6r6S8vxvFkReVnD4t7ctKnU/BBDFxlY0
         au+mJWuD9FxZOc7Y3ml00Yu5bCJQbrt1Q7rD8rSxtT2PEKEQ/YWZuK235jscN9ltGL3v
         RuLO0mnNU9XSiLYbEu2IOLGM8i1R31QuehcduddAqpH2bd7O2uOZTcaUzAcytYvspihJ
         mbZf1YdUK+kKeQ8NOWWmlPbp2P0DkC5myk9GbJRJlOB4UDnf4vfZji8y4CdRLoifI2xS
         iL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633179; x=1757237979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
        b=tECuGm1yxR4m0CuI4fUd66zbe/FE5ka8ewJ5BqbH31abyFL53Gw9b6ZXrpnIoBd8In
         MvPs62eFcG6ATe/0snYDjP/I2a9UUXC8fdDqdfXMzDpMMrwfPIpiuWRwfPpZiyiL6izu
         mhiyL2xe2InLn5UuhJKjztnLMyXcl1MM5r2qecmcynGSDEC+S+CJWZm6ssqWPUmtyPKy
         CPRpk1JUHchSlClBap1gBrwZ1+7UTqtLhx2IOliR1JUR8ayTcNTgjTauCSKPZRKv2soz
         RubQKFEX5f8gl5UqbGK0niOaFpdsA8eceYIz+4Wwyrd+rXPSiMeNO9cLKN3pSlYETrGq
         NxoA==
X-Forwarded-Encrypted: i=1; AJvYcCVnrSlAq8uOcLitSxAIvstfr1itg8O8xdcm4iD/8tu7PkAp7rbJTwARz9NxZb9d1S+wTqCymlh9jg==@kvack.org
X-Gm-Message-State: AOJu0YyL/K/Wj9vnsCbMQwbC2LHrs6WjzkhYLqplcEGbKAA5cT7GeyMh
	INT0CnH1vhDgtTkkKCYuVj98IjGRZAZqJxNw33KFsL94I9Esvp50ZoSmfB608pvKuZk=
X-Gm-Gg: ASbGncsraKUgAhcf9Vb8AOEwdEfmcEln0Ww612tERbU+8y+VSNvaEkd23ti1uNzvtnn
	9pBIzrYNvsuRZdp1kcw0/ilj7CFJVOC+f2NKD3AvhgQ/cRpQwo5Ut4MR/Y1FF4k2d8JL5YvAYzI
	X9bjUXhkJ8vaL/dPQdNaK0R90gYcmMeIYCqNU2mGN7mfSX/h7cnB9rPo3bqavkh9PmjTjrPQxhU
	ohV2KgoOOdZgBaqcq5SdBTUENPmK4tITlklEnz0lQijRy8hLwoIU3KJ2H1K/vt3nDICeIcxToNA
	AMak3FpbPIaOM1yZIYSkFa0RVf8WbO8atHA41BTrnoP0tUqStjjwSgLSN6KQ+y+A9sNp2C2g2VF
	xI3NmD3OEO4zJv/Q8ynVpFgxwg9AYU6DG2SU0nksyeblO2caMgdEapEmGwiIX95DER+5UU0rapY
	+tomnTCBgc92osiFnE3d+01NaMt/xTtffj
X-Google-Smtp-Source: AGHT+IGWqt+KVEWKYlHvaHszGcGmjarqiU1Lz88YHviAJZBcg99riD3I5jJ1gwoVHFqFNrl1LVVPOw==
X-Received: by 2002:a17:907:3f07:b0:afe:de1b:26cd with SMTP id a640c23a62f3a-b01d8a52c71mr478093666b.6.1756633179563;
        Sun, 31 Aug 2025 02:39:39 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:39 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 04/12] include/fs.h: add `const` to several pointer parameters
Date: Sun, 31 Aug 2025 11:39:10 +0200
Message-ID: <20250831093918.2815332-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12D2F40009
X-Stat-Signature: 8mpakigrztpezx6rpcpswqg3utxi7xpg
X-HE-Tag: 1756633180-926096
X-HE-Meta: U2FsdGVkX1+xYs7JbsU2iERyRAEEGTxCAnoiUP/H8I+CS/FQCwuzx9NMcmXD0O30ZgSjfYqOirfIafG3oW0QyBByiz0BLhfo355EIza4R7aVzKpMsCMthXmaGSIpUkwLHaQnyjWLKs+pSZm5JITI6KDORz4DMaf8cCnrfUPpQaWQDE9sYiYaHwldsuX//YSYhXKriLyQmzt+Yx9Ziuzp5/XwA2kWl4blwXxuJYAjUsSxpxJvuIoAUY4w5Akd+vQDz981UCEOxfCZxK0xR92ovOk2BskNEp59IVEc9fMy1jHZG+rc1zGjEGqASUTUwq156FJjEwcea5rNTmHE7NIvhnjyGz9HpuGklw3FUaHo5Bav5Zwpu84psb6xW3HDy6TLtGyRxFRow7hjAjP8fuj0mMNj5eXVhHyjV+6bCBAOiilf4NiItNTUcjl/FVGd3IJ+zNJSaT7mEgp6GfJDtqqKWpDVByymVu86t8EitsOtW5XO1t9nQ1wiWKa39GjlmL3WFlsqRQH7gfxyMOXhNuz9XS3GU3IQjhzsvgbi756hiOKTSgRUDL2bOwQPnumHnuai+0/14yHfbY92J/pMG6/B6Wcxl1p89ytMEEX9frBOa8+qKTP/KsKFi/QC9pirZgxYPWEaqHuKXf54Ks4xtNguwkLo0r5tczJc9oUMJ1jMgL00xbwx4uigWwDYfTwglIYi2BL3caLmSW0GJ9qNGGehkheVQ2fBT7h2Ts0DnZy2X+lwGAuJaiJZKJ/sBNPErUGwjEjXJBQmo2HImTJnozJKRlkfNw/0K+UnnayzCbmM0DPZG1VjI3xre67etH2CjvVwIP7S1d/15mZt3+yFXaSYQXQKHPh/LCrdQIAIF2dSI+j+gETIvj7oQ8CcnCCjfUyUPN9d1SmUdotJxxomvGUPZodqHHklVLLrOnhM+N3RpccgceW4yzVkamCB/FK8luIfRTlPjflx4QKak9VSxaG
 dlcEm68l
 y7FtjZwnM1U3y6osAJLxw5Yi+6GV+X5gYI4AjtGT0oYwT7cPSbMALKC3WH3aEQCZQgwuMkedWLsoPMyvehrkVm1dhLPON6pkYBV+JPTDEN2M91MUOClnXS17gmIeXE5TIyx5TlnBl3ydid13azCPXSZO3Gv8iqonEanm+Gkup2HiA6bCVy4GxbYlO/HCS748zdQMkPtvzHFz0koMYEtith76ahO1UxNUEuDFLIJvn0fD67AaYMFgP+lP4QxUw193Ko3l91PGZSe3tKsf7SDZJiKAi5r+541y5rxHJ0dxQVkDlMe8GV+Q3ly85kXjWeUOmSwhQDRJVzKmwB9OyA/UfgmTG+8W25sudojYdjuWtXsWFToj6o8LVwi0pJtnOA9Tsk4Oe+P+M+IUbuWkJd/HUMXhFesdX62bcCbsPqDo9MzneZ2OAHGWSMBMcKbClc02MlMGXq8eeRPoccmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/fs.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..8dc46337467d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,8 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *const mapping,
+				  const xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +586,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *const mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +600,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *const mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


