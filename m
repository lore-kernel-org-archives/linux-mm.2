Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577E4CA0EE9
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 02:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0AF6B0369; Sat, 16 Aug 2025 22:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798386B036A; Sat, 16 Aug 2025 22:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE356B036B; Sat, 16 Aug 2025 22:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57DE16B0369
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 22:14:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF256138AB5
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 02:14:25 +0000 (UTC)
X-FDA: 83784630090.01.5AB7674
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3365E1C0004
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 02:14:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZblyM/3Q";
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755396864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f6It7N83D4C/K797xfMMN/txZOz69/E8M8kxi9IABYA=;
	b=tU1Rrghit0ORbRf1wW8ND0EgCxlYXMjJrQv/pRDsS/o3klX2cmGp/P26GQrxp1GYU7SE6c
	dop4a3+1Ij8od4AFGj/rWEQrMb5L61cB2+gbHFzznZ90LSgZGPvs1E6oMK3X82rXEpmTNM
	EOaxOZpf+qkMK3COSftyB6LDV6LiqTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755396864; a=rsa-sha256;
	cv=none;
	b=BD9qNw5MOi+43IwW/9Cepieg4tC6gVYIHhkGIBUXGomqnd1o64hxODRVk/Y0hliUvlGKK+
	wSmUXvkDz9t0YoZy8f1wZ/HuDaxPsPQeWFtW842QFU9087hdRYbQ2PHeZbwvN9YIkkFRbR
	1fXW83Mz/xhRQcVTUHvhexdwHbpeIAQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZblyM/3Q";
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2e614b84so2979154b3a.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755396863; x=1756001663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f6It7N83D4C/K797xfMMN/txZOz69/E8M8kxi9IABYA=;
        b=ZblyM/3QpIs6Kino/Ggbl7Tn4t9xAhTEfrzHbddtSCsWz5mzMHnTzwSBnGIzor4Kz0
         +NDAuwmGbizDMc6qlCZPeUjH+PuuCzy3fjx3FTUU5AzeHZpd6mlloOpTLzeVU86hlGwV
         QG3upBCI4dwlkT40RAD4xMwtHKsXxyymdvwb8H4zh7bBmTSQgvNpLAJC3yXjm+fOez98
         bzwKnJ+kVMKTJnYAZlmzth3SUhumNPpYOBrOHytYey1oLoqYGV3CgRC8un2Kdjv/26Ds
         84YJOedmvLHema9AjMIo+8dgZzCh208GBozNEdk/Ej8s9ekHVzHpVii7l6oKendObeOC
         65aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755396863; x=1756001663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f6It7N83D4C/K797xfMMN/txZOz69/E8M8kxi9IABYA=;
        b=Ysx0PJsJQ4TkSQnwOvUV+MA0tV9AZ3eTZriYAd3s+DnzqYbESXVrPK2xfkm7/HmLw9
         iIGgK9EJrjyKO3LJIKJh4kh3bognlMTWpxnNM+TmtqOBXPsdjMe6y0V3QjTlQc087tGj
         PddG8K8IW9GtUj0iEgkOt8TgomOwcmje84BnfWp0E06RO9odql/zmPuMYRrTxlpM+F4c
         GzjtrWnFjGKnDxjMSbZWijwMa9BCNoWFnytVHjf9/sSFgwn7qn7quRjLFxqstIaR6vXX
         Z8IHqfGU5ec1fESFEbDN4BEwQUDRPkVPknEMWiY3kx3vmxYFbVrq+1SC5K/2KlZGnXLs
         5unA==
X-Forwarded-Encrypted: i=1; AJvYcCWyyQR3Z3nxua1BgagnAbYBz2lUaQZFaVgvGX3TmAZNtStw2JLZDqW1SsEaMiHwtT9VN+BtA0aXyA==@kvack.org
X-Gm-Message-State: AOJu0Yw7diR16BuyTCxVg3+hYn4f/oCUkN2tAZdUuDZvV4ERVMluQ5cU
	lw0JyZMYhB1XHyDskudCxpjAEE1OJ/MK87o/cRLUlKSUzmXlzmyEq6F7
X-Gm-Gg: ASbGnctqtUrAfTzndd7bwzWDLZD+OV/NuecRrphLbKJgfA1H3rOeOMtuKZgvMGUcRmP
	nmwzByiNwJOWQFLRYRiJIYE2HaBWTHvQ6HubgANp8WkBLP5d/XJzoDaH7g3pJ+1R2Ttsyy2ywXu
	8tiGI2/oell/uvFqIn+39sHgQck3Xbta8KgFzJAUSCHzxla5H8iVgQZq7ALMqABlSL5FJU5S/dx
	oFPYlzqoKtKpqmzE9klaPvCgN+iPIgQ/wZE0xKXJ8qzceLD+NK5mkj1P3tQrKUys9jEeQ/m+f0x
	dj+AEnFK+kS9X3KiCkb41Oe9IcDIoCZAjuAEMzxKbDLHgJ3thkqJhHF/WmkZXzADjc3g6g/hn9O
	y9YC5rzC41pK6Tgbt
X-Google-Smtp-Source: AGHT+IHN3lJKC5Ayd/Md04E0eyowb0RhMB3NC0RYYz1UDMZh3sAVI5KBiuVr3IHvz15y6m4dACPfYg==
X-Received: by 2002:a17:903:3d06:b0:243:e324:a36d with SMTP id d9443c01a7336-2446d749c0bmr90644345ad.23.1755396862836;
        Sat, 16 Aug 2025 19:14:22 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d56d5bbsm44762545ad.147.2025.08.16.19.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 19:14:22 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/damon/tests/core-kunit: add damos_commit_filter test
Date: Sun, 17 Aug 2025 11:13:48 +0900
Message-ID: <20250817021348.570692-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3365E1C0004
X-Stat-Signature: 41nq9uu8qrbiygf79axiamwdmbwbn7dx
X-HE-Tag: 1755396863-227
X-HE-Meta: U2FsdGVkX18PeG0oCy1AktrGcsjd0ByumSrJVXwG53Ib1MztlXWaslxMaHDPynQin0Pk5pdsIc/prdYGGSq9Grb1ac23YFXEs1Y0jtHvheBR5mNcKQ6/BWUCcZ936xOZl0etuhrgAGTbGTKCsmT7Z6LCi+BTGT8pnzm9/uK1hliNePRxKEaimPTEYFtfPRmZ2nzLuy0uQiWvur8EW/1G5DyFryaOObk8mCrfs9dD0xpCCxbOC8q8Hyfo9pi0EmeI4XDXl7KYyw7IbFOwE2pX0/szMBfFF8g79vWfVMcJc4wHuEOzsGwO2t7JkqQVGB2ILj/zIxAo1JXMxluvJQhYWTDju3/9i9bsnXQWT2rEqTz1f/Z9xZfCzqTRN2a7LkeVUQGvW/m55Bd4Aoa91s9Lc4ZRRxmaOHxBdEnIRR2xNNbspMbRHid5dZeqrvVTMVfhcEukQuIOuU5mn/vr24zmztzn5TxYuK1oNq4qvCGgRXb9jXv5Ta7fwutG3hgwlvYVHENbYxc+dIyo4OdyxZchUrRQLdPkjzu4lqHFTIoPG+KG2uVloxpGgFET9aM4nqgESt9xXuYEff8okaNrb3++GWdUZh8VTg9qky4v2qS1HC/56MUDwfxuG6UTYMLIIV9XBCzKtzizsdFLRqAc33LOsLYrcFiZ8cC1cTMqp8e0yznSGyAbL546JyH2S50YfaiZW0lrNOhsIV/TdQCFEq1guvY+sCdIxOYljP9cq1z+2K7ZJvaD6mtnz2VC86TMExgqwtrQHUzBnNKrTk0hpwDEqErW/n9av1F7BwbOkA0z/DQ8lC1XB7ybWY1JjLWxXIJnBXN+dUPgZg1lTCe/FiTWPWTmiefd1IVX4plwahK5OOyA7pFyGGqPDFoq1GoUkc1W3wAhX7tlJ1tPhFhFCVYdVsmgfOO0lZFTdS3tAzG4JVZn2ZaC6mH0LuEIaZjjOddLxLErIcmgDoZQ5gv9tcx
 04rNTbrV
 dAV+etMGnqGo8T1D9HqFUepLFXdutG35EVJh4PWCk1mFrwtOdyUzkJPi4gMcC+971y2DKZJ/faBc1GUNHw5xv9J+FQfl/CCvsbuTaDvPxNkNmIKWYlWlhQNq/EXRSVki7W4lxp5Vy+SC3Xf/VKijRm2yaiSQ5eCVUzINx15Cds2YyG46aaIhMDZA9HI2jNJJROtFO6tikjsYd2DNrU9fyKkogUUbN0AmpsK6k/5/Ft+RSppDOhqFZsd6x2KhM9UKX16I2yL//t73kiGi7NBEoB/H757ZfwErfb6iOGgJPDIWaUL0WKvwvSgWIFcY2DuMTgpwKAX2E4mpaspEmt256ZelN7PmkcolcuWtAzhpcZZL5m7J4KwL3Ux+Gcsp4+V84T2lNzbz3PJRAQwn1B0mIvQqss+q5XRz0IeXjkUpoLdwDPgNS3KK5GtEzF25kvDn4ELi8CI7M5Dppfkkz3gUwYCTX8TxImugtml/G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add unit test to verify that damos_commmit_filter() change dest value well.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
This test will be succeeded after this patch [1] applied.

[1] https://lore.kernel.org/damon/20250816015116.194589-1-ekffu200098@gmail.com/

---
 mm/damon/tests/core-kunit.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index dfedfff19940..5f5dc9db2e90 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -419,6 +419,22 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_filter(struct kunit *test)
+{
+	struct damos_filter *src_filter = damos_new_filter(
+		DAMOS_FILTER_TYPE_ANON, true, true);
+	struct damos_filter *dst_filter = damos_new_filter(
+		DAMOS_FILTER_TYPE_ACTIVE, false, false);
+
+	damos_commit_filter(dst_filter, src_filter);
+	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
+	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
+	KUNIT_EXPECT_EQ(test, dst_filter->allow, src_filter->allow);
+
+	damos_destroy_filter(src_filter);
+	damos_destroy_filter(dst_filter);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -594,6 +610,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.43.0


