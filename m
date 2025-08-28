Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCAF0CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8008E0018; Thu, 28 Aug 2025 08:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994888E0001; Thu, 28 Aug 2025 08:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76BC18E0018; Thu, 28 Aug 2025 08:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 656858E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:28:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3118352AC6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:10 +0000 (UTC)
X-FDA: 83826093540.01.CC9C784
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A395100011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Esl7wUgs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3V0uwaAgKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3V0uwaAgKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384088; a=rsa-sha256;
	cv=none;
	b=FYZvjc3ubKdDjcYWTXQNm/9Tp3xxI2I+0FP5Jg/fgblYs/Yn05C0a4iTd2NIHQUlPywhxD
	pTuRr2ceif/SfIFodwfGMtoWIXzOpiTS0HERZzmxO65szIPnuCSiZgrlRlWWoM30zHl34K
	Ptf83SZE0qBk2vnKLXNaUqSTMcQW7ag=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Esl7wUgs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3V0uwaAgKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3V0uwaAgKCPolcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qm9V93bDt4mzncYEvbMk2UnVnKCadpO9FtS3vTNJKSc=;
	b=Y8i/Yn5c9rt1ez9t3YPOuzWMrbuoNyqJrBMDd2mrXcBIehKf2Zj/+c8/3WQBBrDmFiDUJ+
	dVB3vzbCrleMOxjAuT/jOn2l9oMAoHXjoeBp0i5yEzQvKA7rx9awAgzg8IxOdcSNrwm/Ma
	dhCXdUlsgASmce9JxV3CD4wOoXTR8Xs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b645707f1so3959295e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384087; x=1756988887; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qm9V93bDt4mzncYEvbMk2UnVnKCadpO9FtS3vTNJKSc=;
        b=Esl7wUgsW8xdldmZkeSG+bajrkSkutw3JbIN4hHCJH6cjK/A2NcABRLv9K+V9ICORA
         hTRqKvWZJVo72MdOdHkSD3BV2JuuJsieG9hiqsHhWRZkc7e6etc3EC0fsoOVXn8bimgu
         4xVkrx5asSsMsxJ6tGPlGdVK+Xyyp09HtG35sIgtSXeysh3Wejyiz9CpfyeZ3oHcwkht
         vWEW0hn35RVp8+yvrkmx5FBOTrvLDvIIkB3kc0BjWttbNIBgwAUQ5+EUBufl24xJZmT0
         xDZ9C9lyuqg677d/iXx7M4NyOwnPhZN4CEZcO8fefsvsU9QdlJaFpCUI8DrKIzYTdwtt
         Qy9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384087; x=1756988887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qm9V93bDt4mzncYEvbMk2UnVnKCadpO9FtS3vTNJKSc=;
        b=Ig6qDh+qUwgporm8MXPS7qGWCUVQcwHvzbkQNDnkpokqU8dqy27hvuO0TvaDiq5JhV
         kl/KSeu22QAIsFZpAZK+KxjwZpS76hT/ML+WLTtI7ExXHDgwAhhXvaMSK3iKgjZULk83
         zbkX4D1xDvVvoFKfNE/sHPzGmL7KLcbBAYh45+5dylDQdMSQYaDKayeoNAa8bZcT52tQ
         K/4I8jNI1tZ1Mz2zGy4h44VeCFjzA/R1cODfoMS2IZMlQxdpj+Q/bkZK3WOxrDDiuhF9
         3zKjptMzF0WcO52WlEM+2BcfI1fZ6fuMqimXm8EF6ssF9ri2xWPg4X42jfiDfLIa65+K
         ooJA==
X-Forwarded-Encrypted: i=1; AJvYcCWpbzGCCYMrF71EhkmXrRvqlSJODVhp1dxdJLGCo7BLOMy8PxQBXhUCuwLIN7HJMs3TyAuoA/7cGw==@kvack.org
X-Gm-Message-State: AOJu0YxKabXWeJqqipFkruJJ/Bz7lvs2AxS9GazLc8mjDYpKx8mZLOvc
	4rA2AYYRtpAQMZMqbeBf/PGC9FXx6MrTibXGfr824/UadNV8AD6M57/p/wKgblBVLyc2K0xqHWs
	jA4khAuz6aJrndQ==
X-Google-Smtp-Source: AGHT+IHX4/WrNzbX/FYn6VIRfFQuxMO4r/uZ6gK2OY/lKgZ1ymFGCjrrA2HbF5ORNJdD5g5bjBWjoWc/vSleOQ==
X-Received: from wmte19.prod.google.com ([2002:a05:600c:8b33:b0:45b:73cf:2862])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f95:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-45b5179cfa5mr199709225e9.11.1756384087019;
 Thu, 28 Aug 2025 05:28:07 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:27:59 +0000
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
Mime-Version: 1.0
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250828-b4-vma-no-atomic-h-v2-2-02d146a58ed2@google.com>
Subject: [PATCH v2 2/4] tools: testing: Allow importing arch headers in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A395100011
X-Stat-Signature: d1rj94ktxr1i6ps8akysrf86yniy8is3
X-HE-Tag: 1756384088-665751
X-HE-Meta: U2FsdGVkX18oWKAXx6qWd6qb29dLFI5lKe7ZUcvbTUo//ALcUa1Q3zZBkG4dQmJrBLCc2jeMRONIwLxDSrS42yQR+O3/yi+bLI24+c7G3ORaLM1Zfemfs9M6c87/5/fxfmTOdwG48WoCf96reFwxKzhF1uNCZDdJFqTTwEX52dGOXWd/xvEuTiAheV1ZD1rAq/ZKLRxMi03wMjC6Ii1Tk3Y+CBx369EzoZ8L5rrs2zcYXdwY+9b1MpuPFR/Be8/WMOPmMDqpaTnaqnwrQXJdZUedntLM/KHdC7dkc1yY1qL7/XBMPsUcb4XQiYS0DyRRe4jou9PeW9Uz2RyWi21tz7D26hhyua3Ry0GvXavZiCWeM3P2skcHvJMv1QLlaZIMgIPGNDb6KP+jO370EYob5AIiAGoWUQt3iqQn3w1ckxVWiEKjkcko3+QLFpuaEZ89ug8gF8YFvDsr+/rH3K8b98XUbmzB3zyOybZRtTR0BsabpTTZQoHRbbrDujspQXaWyeboEAmRwJS7x9ND+yg7DgPdOHitCdLSUBSdqGKo9TJdTCQmB+66TV9TjCkBWivg0J9jKKGXf1BLevyK+NQFEAonjGuVdnUp0odZ6HI4v8i+FApQIwhJ8nTawCOuZDaM8AOEN3/eEuFcr4MnksTwGXC0hyXrh7zz20xcpW6u8r6JYd96KZgmM29vxh4wirm4r/JfSZUPNC8n3Q6aaGH3y2rJN5JbVDwxnW61wpuK1B5IjAD8pRobPeLRGa43hE3LzHHVnQp5Db9Jej8BiAvA85wrrydV7TSRAZF/3ysvnF1ufbapnSdIKBmmX3gWhIWuaZ0XgcYsFFNNinJFjbCvZNnaSgMOVOhBHMsnaiH1Nncw9ySP6Aza0q68tUEknptOFKZdL+JrKa4OHczzk5n4ZT3v465ctpsQnVPZHKbqLrcVEfHP0l4E8TOKmiAnrM/fo1kKJe7s0hW92cj5YPi
 b1JnHV1g
 6PkOPxJ0qXDV6XRuBR79KHFBv6N+Kqmn/sjpMiibF1woq+8BRfoxlED03Tn9+UQyR2jsEvAxltwnM+IlWQ3ta86UBxNB1yahYE/jANPE7t3PjVl0IdAjM9eRT/YbMiQlVdtv/njXgSd/7rs1qIdDoLcwKZ2XeGwAEH9Bx4OvtLiRV+eGCtDjCheXZJymQoU2jZg/15L6OupnU8+Hm4VE2CrEs3ogddifnRXtG0THqBaD8GQz6HC87ypegbHRDl3wySsSkq1qDkYgO4RmmRhsIdIWSlTBOLyKvje88WbAeKYZEbxds0CFUU3XeDjSPvdnNgZjIHHzydTPcJpJbXuudi4BWaMJOPDjBjzbnbMSkspDJ5nye/WK0urgsIXjsc7uaiSjlpD4fRUnxTTQ/IIm2K1W08HxUav+U1Lw2vQ5zmaTU3b+JV2YJ7LcMCW9JDUOWyE8NuGfuN/d1k8I/KFWBAv+LeUr43zeRIBEfXKkqjtEexXp9qUApxEr4YL//EKh2QgCWbuLvgUVtdCyMVpHLwm5fd9WZfsrnbb2TlRERXzGTiKa9BA80U7+XeV66+bdxJFDq9WiBhsFdZn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is an arch/ tree under tools. This contains some useful stuff, to
make that available, add it to the -I flags. This requires $(SRCARCH),
which is provided by Makefile.arch, so include that..

There still aren't that many headers so also just smush all of them into
SHARED_DEPS instead of starting to do any header dependency hocus pocus.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/shared.mk | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
index 923ee2492256b693c5cf16cc014d9d2410be5457..937aaa7623320da1085a8e0f43f6a728ddd3ab1c 100644
--- a/tools/testing/shared/shared.mk
+++ b/tools/testing/shared/shared.mk
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../scripts/Makefile.arch
 
-CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
+CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
+	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
@@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.mk ../shared/*.h generated/map-shift.h \
 	generated/bit-length.h generated/autoconf.h \
 	../../include/linux/*.h \
 	../../include/asm/*.h \
+	../../arch/$(SRCARCH)/include/asm/*.h \
 	../../../include/linux/xarray.h \
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \

-- 
2.50.1


