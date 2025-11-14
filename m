Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4E3CE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA028E0037; Fri, 14 Nov 2025 14:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E835A8E0021; Fri, 14 Nov 2025 14:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73258E0037; Fri, 14 Nov 2025 14:37:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC4A58E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:37:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 525A4140177
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:37:48 +0000 (UTC)
X-FDA: 84110222616.24.A038DA0
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 544C140008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:37:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=HqoHODmj;
	spf=none (imf07.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.210.177) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763149066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XU8vU/KjPE99lkBMAKIxdrPamg7+p9OoEjvmjp1kXQ0=;
	b=E7YoUGedNSuILjmtI0q//8Nao8qlvvkEBN2Q6YQIU+ylzQVLGeb6oUk6171XHqh2kS3i53
	P98ncRfsdCpSAR6jndeveB3ioA78IAl0+zCod96VxZHA3XQKhPxIrAYECB3hiCYBYYNRWG
	BLJshyB9j+fD0jjbmFGukhheZKWhPoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763149066; a=rsa-sha256;
	cv=none;
	b=fatYWzlioUsL0nCe85zKYoODHrvk55bPxV26yiazo36ooCFddhAZySgpTRHAhIGbYBgCMJ
	dfwYChiRPbjNnD990FfmVc/WxnEuOX8tjELe+bLQ6t61HGWLtCPcnBjzRlMrrUHLa1ARO2
	r2fJk+O2iHDJaeE0zkevSsY6mtp6akY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=HqoHODmj;
	spf=none (imf07.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.210.177) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2113688b3a.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1763149065; x=1763753865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XU8vU/KjPE99lkBMAKIxdrPamg7+p9OoEjvmjp1kXQ0=;
        b=HqoHODmjuJcV30/lML/EVGDDpYNeIkuGXjBDAzMy8lhucP+AL/j1EyuaPwCgig4JYE
         e7Iv42fuKS3xyUDPZJ+mD2gWOB6pwYHry8kKoUf2mFv1esFkzACLMgg8772Et0tb3J4O
         9Me1jYAJq2eS9sA9nGl//47eH6GW5d6GU0GAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763149065; x=1763753865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XU8vU/KjPE99lkBMAKIxdrPamg7+p9OoEjvmjp1kXQ0=;
        b=uyLOvtrELpCKFlY4gmItDsPlvJUNHlh1GNtx1RbJLGxyK6Svu/1/HIXzqne/P6hDc+
         JggO1MO8/l49yUagkvxtdYHmx/Z0I40sqKhqkCeAwN+WvK0THp2auHzspENOyv3s8q24
         66W+CwFZU8Gw5gFET5l48y4AtFUuqQmVBuqSDVoP5M9o3sLH9m/pMSMh6WfwfTrTf0O0
         H45Q9o5rP7dp9t2lohpQ1xHGesanmHs8S76MvJ11sAlwkQFWGWfsAn2bqwpcuBalngD5
         1ostlgaDsdQq9rNZXKK1GYFBgUnOZ1mYA0Z07qVbZkhrcoBATLVcH/+LFGr//ZLgQkHo
         d/7w==
X-Forwarded-Encrypted: i=1; AJvYcCX14XIGeWpDHYLYsbjTRx1+X9vID9PW2hU0Vu4fLKyyPJFqBPPkBOcA7bt916yTULE5EO47W/iM7g==@kvack.org
X-Gm-Message-State: AOJu0YzsBjXv72Pu6z7s6Swj63eW3je732868JqHsL4sQ2pGr+vQzAVs
	i3x2OiDr9SFyUJ5zGhx88P/Pv4V2xcRsOWgf/f+tA4aVnfzkCI+DriCqDuc6ysI7Na0=
X-Gm-Gg: ASbGncuP7dD0HKzwoysBU3k6qtth2bAL0EBNQVA2OWnOe1s7m6/kCMIpnWg0Zj1DN9l
	+KP7JaX2ffRTyUB6hdaGzTMFuOHRQJjgUkF+N2G9Y8uD7htKVuAs6EwGjWK9ZSkwmun2FFoScvu
	h+xO1AQ+ddJKNZ3EFeJ1RcmmTMkqvLEtSn3G0YV1/UTcGc9NjWOBOaIHeaEURqj2MA5TXCtYg66
	K2u2Td6GjhoDl4ZCXCYXbKbcQEcPqdUI5A1c8r3A3XgF8i5cgYNcAhCZ5zMEPn7Qp9Eln+L5M17
	Fnfh81MQDCIYAwp1tNlGYhSCwE+spfX5srkOemUF2CJLP4seVH6GxqV9t4bVt2gs6uITOlwEk0p
	h+Jtd0hLI4h1GODrU1/6rv2VoTROAA9DboBI/qWJf5R5tHyeykUMAnSFAPG8L20l1bBmqTAurUr
	Nt5qGijl8YcKBJBvYjSAebhu4p3h1/3DsuBJimHJk0mym9UABMlYzK3Dnb
X-Google-Smtp-Source: AGHT+IE+LbpWEktarCB2Dnrv1yWZrNsnZpDCOeAp7apnz9uVsWtNi+RAN9rwFssQKUSctcc6Q3Qc9w==
X-Received: by 2002:a05:6a00:2e8f:b0:7b9:7349:4f0f with SMTP id d2e1a72fcca58-7ba3799f055mr4742484b3a.0.1763149064968;
        Fri, 14 Nov 2025 11:37:44 -0800 (PST)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2405:201:31:d869:6873:3448:fe16:68a6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9250cd5f6sm5941807b3a.16.2025.11.14.11.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:37:44 -0800 (PST)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	shakeel.butt@linux.dev,
	eddyz87@gmail.com,
	andrii@kernel.org,
	ast@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
Date: Sat, 15 Nov 2025 01:07:29 +0530
Message-Id: <20251114193729.251892-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 54y37bozfg4k99ioug3i9xpjpe8knxq8
X-Rspam-User: 
X-Rspamd-Queue-Id: 544C140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763149066-416340
X-HE-Meta: U2FsdGVkX19LtvLy8XlSZr4+ClEUSUBHUsbZwHxA8oQvN8DMib3a5Y7cLqSoBwHzyjRBrvmC256kh3USsYtjBVSBx1dTo/CAcL2vPugXoZYufbAdDsZqaTvUW2+T43PqpfK3+bkO7ByEqUZDOYpeVWccjqKGchIy/oBkg7KfE2OgdFQizgFdcvbxw/Ib6LPB6lvA+1JQkNBJ9GheviLDRh+cDPI3Nabd/zxECEfV6kW4e9Oc0bYzqLUSBB/XCMfXMeXVfzjvc0FxyXu8mgoMj1AsPoL4vFR0R2ebK1+4p+cV4j9bRVCBrlHlW2nfHwJrDbj66DSie3uE4ImBQbGg9z0oCX90p7WJc64C3y7iV1gdNhpoPoMWnknHHtZmY4Eytq6MLPlwz5A2+QJ2V5H1KlAbq+WOV31c2Wdi2g8bmfaQVh98MpIvpKauWzpeU4RNOzzfoOFE293Jfw9HlYzsKp+09zff8AyVOdrRmcCOU0uu2gXfNvPv+sLSo9Ob/4SZ/H5T53NLqpI3Wd519DkQVekU28QLSfgYt/8OpqGG7EF5g/AUeKyOLhJhCjitr3iuVGUhP/CUQmIsvBwxP9zRO/mpHQq6Gzj86Esz17ww/ccLHTBpJuZHMqPZw1tEpzl5/ZxEtL5VWdqa9nlgQ086SCFT5KFgTmI0UoGexQgI29N51Nrsro/80UB4yIIjJA16y5oCFgE/65VeW3H1f4XwuhOue0jZGzTsjaG7JAMYqrzqHVfn5xkIz30wu8pu7a/wPSUMxNPQ6SkYWe59dnu7VvTCohfEDNwt6k2rqqp0h3snKd0PiUWv8KZWa67CgcUvMkWgg7DtqCMwNq08mZgWHdbHNRrRVI66ajz63oOOK9LyshuPdgmhYd5q3c1dut8x2DqSD6/7kIwrFQfrE7zOQDISN25fDfAdYe8J95PoZrEOYmmsvqDgwG4/tryNFecvK0aBG7OLkDir0If+KLG
 g9ujmLiX
 VzD4Fi4bmYcEO2iIUdMtHrgcts9Yx38l7iz8uGfQMCBpIgu52UFBk58O1Ndjp6I9M92OX1VNfd9GUTnG7i+IgrMe7f9qEF8UfIrERmXLMmr6IUhFsJY3ItVLRXY77oN/LHb9CZ9D/Ye/E6VEm4cVHAZ0bAWyKFFw5We1kDFAeOzr1nrQ1t/gq3z0bdI2uqrnEWVC/tdK6J1Dv8wmpASTQPYNLmp9+ijH4C3udBTUjelkqLWUxNTywGEF1y+mpTWlzB2jwl7gQJuJfg9+FF0KcEFrsFjpxaKxDelo+YtLNcYgX94Uya016dqHcQOHQaP9Orm4X9Xqz3Z5L3UN4GWoZYgfkbDhCrnUMQir3QEYGZFQUxh7M9QRefFxmh+kHxEtMhaUltdlsnLRp27+JS3O/kAGLSQQPsWtKwsTsgmhaWzYwhGXZ7mrbFpPoIAHTQ90491U347QwsCByYDlGm6OIC76eaDBQAEyZOmNzfhCVH6DCJb3eluwrB6qTCCNgrVVHtksSQ7ON3QEzqO8u64TnCDzGVDZInhfkHAo8gxto9RBsWi1vNSJH2oGQXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

When read_cache_folio() is called with a NULL filler function on a
mapping that does not implement read_folio, a NULL pointer
dereference occurs in filemap_read_folio().

The crash occurs when:

build_id_parse() is called on a VMA backed by a file from a
filesystem that does not implement ->read_folio() (e.g. procfs,
sysfs, or other virtual filesystems).

read_cache_folio() is called with filler = NULL.

do_read_cache_folio() assigns filler = mapping->a_ops->read_folio,
which is still NULL.

filemap_read_folio() calls filler(), causing a NULL pointer
dereference.

The fix is to add a NULL check after the fallback assignment and return
-EIO. Callers handle this error safely.

Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
 mm/filemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..f700fe931d61 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3980,6 +3980,8 @@ static struct folio *do_read_cache_folio(struct address_space *mapping,
 
 	if (!filler)
 		filler = mapping->a_ops->read_folio;
+	if (!filler)
+		return ERR_PTR(-EIO);
 repeat:
 	folio = filemap_get_folio(mapping, index);
 	if (IS_ERR(folio)) {
-- 
2.34.1


