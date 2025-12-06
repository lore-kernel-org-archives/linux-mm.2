Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1115FD3B7D3
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 13:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C5D6B0006; Sat,  6 Dec 2025 08:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D60E6B0007; Sat,  6 Dec 2025 08:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC296B0008; Sat,  6 Dec 2025 08:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0E56B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 08:20:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5904B9C87
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:10 +0000 (UTC)
X-FDA: 84189104580.08.5673867
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0535840003
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PGgqU8Ir;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765027209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
	b=Ii5H87xxPh0uU+z7lC/DPir/uhvnyACMzBi3IfM/vyGOXJaEIkfWgv+q6+5oSnl4Mm4g/n
	m6LkKn5FWfcnDQlVK06LlSbrVZGrHXj8L6Snj9aYGVkkCBdeCnSQH6M4bcljbwqrnU9N4f
	29LPw7MStlh79ZF/h8I0EdvgtDWjuK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765027209; a=rsa-sha256;
	cv=none;
	b=viDg9tM6FC2jX61QXP2GDCdZ4C9p4QLu99vhgsVCYNALI1Y/G1Os8wPd+wIgJqP4jkSkFS
	pLlQZK+hVXk2cjBmr7vvEQYmkNWJypjl70yL/Pn5slj/ZAEpk5RB7omlBzjS/3Cko0f/Dw
	fIaEcZ/30R1eqheFDv/hXHMvevqPbAE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PGgqU8Ir;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso38829355e9.0
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 05:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765027208; x=1765632008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=PGgqU8Ir5YvOdm/nmFvNlVFNfS2RfQ4lFr35qK2jllBXilGGpCO+puoAuGPMUsX7F+
         aSQQkGAp81QHCpDg41FfR98vcS91IZ6bY5x9vppj3H1DCsecduCn2wKlAeRKmK6K4XJy
         bUpvsJOSbK3AtkvsMunXzaUALxC294bdVzslLAdkIBeZcbLbaNYw8gqauwNi+rgT7PRJ
         X2SAdhPM+mpFNFeUly8P5GzKTEOFp/0nUuQ3Hh5gv7Nmuoh5mC05uiF/I7EI4a5rZEu9
         q9V52ddD4laoC/gzyqVibqLg2i51Afc7d4Luwp+Kiay+s5cB7FfNWTbCRmwUjYUwOHkE
         ovLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765027208; x=1765632008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=qqAghPkNBza2LR8/mdE9j33DeUla4LbXw5t3eJabeUvHuXMQPjrzwoV81q1AW+cuw7
         Ilon2KW6LvnjyCHFiJiyYHPbhIOiAYBdfNim9FxFDPU/vBVc2vfA5P3mvSHMPOvbIW7w
         w2l+FYPVwYDBLWAUyMVGiDTcipRgT8mdRz2lS7FQ61UpjAU9Y4bUu45WHrhMWChHetQB
         /1ThJ3WuQHSx5j60joJn8Okax6rd64wm0I8sHd+kQniMEpMTcEb7ky/0A1rt94Rctp6V
         VS82vp7b74NpTePWBXK/2+ZjuQCqjtwxtXn+ZjkoPoxr7bO7jpdSoBQohVr1VH+3Bpdv
         dsgg==
X-Forwarded-Encrypted: i=1; AJvYcCV1QMIsk0PY6LDKwLdsyZfO4iZ8bvKk9asI4Tc3SXLTbSd/RXhYYmRDhTTEUMbPAs8j+xsTG6yy3A==@kvack.org
X-Gm-Message-State: AOJu0YwJjKFMzR92hBETEVbPd6gbcdZ9mBtbKDbAi9ahRcDIUy4GZlKv
	BXeiy9yiAIMdvSGdH7E0z3WkSWeUDSZMxulxa344SCso2e0mMCOyz9OOWPyXng==
X-Gm-Gg: ASbGncsTKjUlAt3I+LlolWFBmDR5wVFIkNdNPvjJx3G+Gfd+ZuAw0Aht9OYkSqrPa5F
	Z8yTCsi5TAtOiLn2rSMBpzN8PYhSlcWkvAnSPbnYV23c2+bbbMADIrYp5HDb8Ca0lP6xbY1DRHr
	2gdalAWVVltqKIUwAkGSfgQ/33ABL1HnlaH9tQ0pThgDQVtmJreNZ/6gOhLH8GV1nisKBINiTHi
	FNfkk8CqHeSnyJXk8+l4DBxHdMcSY6Yabc0gsUsoPRNFua818jAXKb8arzoYYEA9X7zbFSLtJch
	SMHEBMnWpm6vF9Qjkpf5REWlvOcN2j13XKqN6BmDWP+tUvvZnwqMTOtdwH3Q/FuW0H5e6HEMxb7
	YkHNLXJYE7zgrOvfQ30T8KPa7pYtRKpBo9xTEeGqmxX1Z5Csra9UurIPpc38pWUUXx1zwZ6PY5U
	wjJeXbiKwZOneFy8xmRJ7xM17r+3ctHI9TpUmWVW3Ac5E3nHDQ4FeRFtC2oeU=
X-Google-Smtp-Source: AGHT+IHsXFGHl8BMLHmt/CCXkj8VSf9vxbQIzflnN1FtUZfTdYecOi8VMSgUq5TzcBRzQ7yxWSFUew==
X-Received: by 2002:a05:600c:3b99:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-47939dfa082mr27910485e9.10.1765027207289;
        Sat, 06 Dec 2025 05:20:07 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792afd3b31sm110871215e9.0.2025.12.06.05.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 05:20:06 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v3 1/2] ns: pad refcount
Date: Sat,  6 Dec 2025 14:19:54 +0100
Message-ID: <20251206131955.780557-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206131955.780557-1-mjguzik@gmail.com>
References: <20251206131955.780557-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0535840003
X-Stat-Signature: nj3f7pmgzyekpot6bug5twy8wg3bfxwx
X-Rspam-User: 
X-HE-Tag: 1765027208-826270
X-HE-Meta: U2FsdGVkX18c1kTafUx67V+1zQJRaPS5CkNHuUHUHVeIY1RVfrBIHhkA6XAeBS7bo9q7TEajqpmSNhWhwQRdbROVnlXNo1/72lN8SkEOMgmWCrI6y26lziyTlOErg9c+tyCY6xCq33iJRe1j74KlEGiPD35ZYmpgAj9yqjvNYA2JHWcROjhzKnxN9KSXxUP+DZiy2gstKwyucBwE/LConcn3h6esNibPPFHyW37/ZlL/RcGoNChVYo5vKSxSOwk0W0c6PHt2jM+X5PwJVlwgnHZk2ftHTtWYkPJJ7x6yUZ1a6z3jK39vwlYW48jLP/pCd0vtn+e2v/ZVQyNsplJi3Qv/6MTOW8HmlETsZZhphBWUV7YAdJacdOKo/NoEjNM/5zaQkXj713YGrJnToUNsp61wYmE5+4tR/mQ5THeAp0X1oiaDcU4mD8a1viJ3tr/OjnH4+eamrWI81SCetHiFhk1NiiBFEYPQ1os5E/3G4cRHs1EP67oJQ7dktInZ8CQiiNqJbYHEgh8+lerJQB2KBnR6gC9xzriOPVBGnOcWSrx6HeUtDIvdYQ4YBvsWywyG8bbrDMw/N8kxIAjzG7sjRzuJMURUC92utDQDKKu3JmTdKd4Jb9n4rUkQTmV3Z2vCpJBVOzGmXvPbqEpIa8NdCQJVaSDnVDqVIggofcM9RJnAPYdFDt3+8kmENhj42PRAVgdr9alNczQpUAR1HEa3MZ/BI4nzyRl89nq8jN6U2etL5cUyT0p8jqw22h/ASSh6d68ZrlMJR4EIT/HCdHDE9oyEowsw8wmeO0JJD7sWP8YUD6PZPcNVLhRWhXVaykNOv32XShPs7xUSmP1iSnRE5gGaXYabo0a1XuQvXfphxblTcHlst6tyYsdLxRfPLTMmlIwaFJk8F7g421MmXGdsLikOeFWxqC7DOIbpi2LsA/FN7049OHBFa9pyeXyzNFheh4Mp/WN32cNXy0epskg
 c/P0Du42
 yY4znAg/rXSObHp5fK7fV+qGJz7rszhAqsrr7aNGLCWnp7zkMEVOqet0Z4FZknJ3BV+Bokb102cFQoHBd4JTAmFrAuyZXOSfYwBXtCw/+zsdxtvS3y+aMBwNY/Aa2SOXiYn0tOvwFW8uJc0ra/O48Zx5CVzn2ORPGy1c6PGkQUIoqPbSbNItD9kFg++9rrbHYfhYf4BU6kV8I1zeiGqu3GtjqBFKB6pLiwDPiT+7wsjQg3K596vkMvMFbFL6t9fWvXu1ssM8StOeOA3ScSOLJxmin11wOLL+tX8s1lcycW9OEjjGBFxxogFg63wrz8VrA5AKt4+t2NnRT6AS1AASFtkp0++3+cthlusocPG9wjiVm4j1d+M0mWcNLZr+s510mjc1Ibi+yzYpwl39vYnjMAPsb0Bp892FeKjwY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note no effort is made to make sure structs embedding the namespace are
themselves aligned, so this is not guaranteed to eliminate cacheline
bouncing due to refcount management.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/ns/ns_common_types.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ns/ns_common_types.h b/include/linux/ns/ns_common_types.h
index b332b019b29c..0014fbc1c626 100644
--- a/include/linux/ns/ns_common_types.h
+++ b/include/linux/ns/ns_common_types.h
@@ -108,11 +108,13 @@ extern const struct proc_ns_operations utsns_operations;
  * @ns_tree: namespace tree nodes and active reference count
  */
 struct ns_common {
+	struct {
+		refcount_t __ns_ref; /* do not use directly */
+	} ____cacheline_aligned_in_smp;
 	u32 ns_type;
 	struct dentry *stashed;
 	const struct proc_ns_operations *ops;
 	unsigned int inum;
-	refcount_t __ns_ref; /* do not use directly */
 	union {
 		struct ns_tree;
 		struct rcu_head ns_rcu;
-- 
2.48.1


