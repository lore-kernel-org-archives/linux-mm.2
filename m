Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5416E7490E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BFA6B0088; Tue, 23 Dec 2025 23:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145EA6B008A; Tue, 23 Dec 2025 23:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F225E6B008C; Tue, 23 Dec 2025 23:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEC4B6B0088
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8948BA2C9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:19 +0000 (UTC)
X-FDA: 84253067598.04.E913725
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC11740009
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vz9Et8GS;
	spf=pass (imf07.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQkMD3ltAZru2XHuW3W3PQE75mGT0odUsu8IJA/78IY=;
	b=AuCnumhpcDkZXza7Rov37np82W5qveHxAGV3YNvyg/54pFp1NBlWIgLvWPr6VYZgxDIGHw
	0ZHUCAztbRJOtvN2+TTAavur7fd+JHFp0UvO0TqBvMHtOhKzPQobJRsvbjyauTLgP4zy80
	2IjL2QGUe/WJHqgjsMX0RMVNIK+XJgU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vz9Et8GS;
	spf=pass (imf07.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550137; a=rsa-sha256;
	cv=none;
	b=3SBwreAyIdtU1f6GOVi5+yr7ZtaSzUa0dVqiJszt6crLGvUTY9Chz2JPL2XekAUBpm0sWR
	Nlp/2Xspt5u6Z+63IBXLVnRoyVxzD/Ng6PULN4l72tmnI/h9WEuQZQVzXRD4MT1X1ejRLM
	5GOWo2nCs+ohbniIrk6gPuthafVhoss=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a1022dda33so46479185ad.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550137; x=1767154937; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQkMD3ltAZru2XHuW3W3PQE75mGT0odUsu8IJA/78IY=;
        b=Vz9Et8GShNJcADZUxicdg6b2YZfIgiD48XFnxN5Dmm8lOJgZ4RDIoDc3ElSbHLCGdi
         FRo8aSVRJYH8RDitvhy4nnSL0DUVnaoO0432W52PnC8hGiZy9YyOhUvFIy8/Pu13ky5Y
         OFXzmgZuKHVVtddjLsFqCDtAfgYawSfWPaIcG4kKllLMx/3++cQxofc4s2uLQomQK3DE
         lUvbeUs87MWZL618x/HesogjTB+F1qFtEgf5GeaDkqOkm7dyZofkFotPWxjUjKwO3sFZ
         ncHpQdKl6ghUZ7xGnz2sbPP44uA1rZ+ZtVr7Fi0pi3wBAp31IW8tzTbwfsdAOIWG7rcc
         Zk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550137; x=1767154937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VQkMD3ltAZru2XHuW3W3PQE75mGT0odUsu8IJA/78IY=;
        b=NtPhLb1BZqMb+0hr1bn2zZONt6Y9n8K9OcSCnbhmOSrrNprFmb4mr8USGWJARqhnIQ
         kVHHb5BpXMaw71A7BfiWBfCsh693VZopwKXukGTn18NhWoQpxb6PbM8kE2HN0KNe/r1P
         Qg4siUc/82kADqIW74Gwm3DIxe3i4ckMLHy2Og+Nvyz5YrVFtmY77O8GQGyImYsmrVby
         +6O2feAbvUXL1RuZs419ozcxr8WCPMOpf1gtN0hV/HbLSJkVvSikvZvIkW0douWA9oxW
         MpQ9P//uanVMkilQL8A56oTHCIbU/f36ibG05L65pSthFwgfmkFJPvjmlhTpx/zS8egk
         Vz7g==
X-Forwarded-Encrypted: i=1; AJvYcCWXnIFSsMSdPujEmwOuQFDEbtollasltNF+P6k5yB7233CPKobFe+QivwdUtRdlGUdqwN193M5GxQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4ue9nIUGBc81Er/ned9WiF1I3FXnzSu3TnPzbDciAs9uLUsmZ
	0J2EyOCslzF6cfPjhRJJk0QeQs9ssSZcQxkGYzc6blG/pq4F6mtOlX8V
X-Gm-Gg: AY/fxX45xGQRwsTfMhJKtkB8q+pt+N6rMsZzWUYbo3VY/niLadyeFTxUxtqmUblO/05
	pgjLox+zvks/O0f4+QNyp6XKGz82SuOupoK6gQd9H48V6yEyTqmIms++HrynOBWxBH0vdSZeutB
	ijGJTqIpDmNOkGu7b1Dse3EIF0C/6R39wBXCgRx8Yv1G4w/3E0mYgMpSjJS4dFR+pSUBWBfEtE0
	Bk/BzcDT8ujXlyJ80r31Hugi2l/3IeTabBpkA9x/qCGNfjkhZMMeSPTX7TcYZubls3yrxdT05PB
	vP/Tuj8HyxyElDHmKOikL+Jqy3KECXRgkQGBB3FdzLDflnZCcojGIgSh3Ed8U4uPKFaYUsbzOn5
	1aup9qUmCqLFrfR2uG4BA5m0xaFb8Qr1ITT9+YJvc+UEV4O7oD4AaqP1t9vlPSalNU4YKLjtigc
	vc
X-Google-Smtp-Source: AGHT+IEIattYmas64tB4sMSx+gkWrf4v4xDu3o/R+q0wk09aYhAA7BXdfFClMLqznY0MS+X0mGR6Tg==
X-Received: by 2002:a05:7022:e98b:b0:11c:b3ae:c9e9 with SMTP id a92af1059eb24-12172311f8fmr16335393c88.43.1766550136511;
        Tue, 23 Dec 2025 20:22:16 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:16 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 1/5] mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
Date: Wed, 24 Dec 2025 04:21:56 +0000
Message-ID: <20251224042200.2061847-2-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: <20251224042200.2061847-1-shu17az@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zi7nhqszto74ztos4fx1h4nfcbckoq4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC11740009
X-HE-Tag: 1766550137-834872
X-HE-Meta: U2FsdGVkX1/iITqj18X29945bkk3H23N3Kcu0/hwTc9whz4lFjWqX5k2Ak4FjL8vUBLLNVxoHCTX/S40Gxhcw9yo4o3JXeoSnTSF/Y5azKOLFrMeLAdx85rkyn0WY9yhLWyMEeeFkMVP2ExP5uwP3Lvcdk0ozygQCcq+699FkpxVEgjRokSHV0ZldQHotGsuim1P64+YbLpZdjgJMUS2OSBMS7MSTNczaRco1d38gFFVV3hm2I18F9r9zpOnhaG/XXwlLnkiQtdRkbX8vlCOPax1sbb0sTxir43iHJqQl+ovaGthmBjxM6dGVdwutSqbaeA2fy5hWQAMhBFK9eyeMuxKNxW9HCXYsTNsUcNv95oCrdEwaPWbqzMl9emLcfbvsqyvKhU145g7/umFgmx5n/ydzAimLGFQFkYAo3etfPBbM2U5Ml44yy3y6/cgSph4AvpqyfxYFbufuLIXgxcBExJ/BGYbGo8KacCB7d2tTsX97D1HnP5hCEW2Ef67qjmTAyoutyJCXkqP18oWNl4PDkIweaTTvJZwHvjFbbjxNs/1CWVVpBH4uqdCQygqQzqbarqy/BBtPHnQ+u7f3iy6XUnKzvyhBSpiD5vvzaKGhgQHL83R+Q26S/CnxXn+CZ5xpro081da8w9SIhGOe1Rk3Bc8EbDZSKMXOakD6bFX6nG/Jw2Me9s/m45nFVbcUKt8zEtVyvRsZw++YgiLx2/p2+1oVWRSpu5IYLtZ0gGVPo5hAbrFGq1Gb/Vc3hSLE0ozcffCGmMZ3TPSOio5JFouSrjANn8WvDLjiqGDmFsj71WhDT3804N1sULYvhlM3NJRcLDJO/as+fx32Yf8n+330E8mbsqPIKBKb8Rx/uWzdfrpyZXh4RLSFBJIeiGSvI7i+dvLFCfyb/ilv7V8fvO3okZCV7QXHrfv63aeuMQKTpTumNzObZPpVznDm3GY4UaaK1F+ah5/nLlTO19JpMB
 3eVYOwHZ
 M5Kds2VK2B4FDS7Fx01JNtLOZhnji794EePktH9Lt5fAVCHCgMS90kRzogUDCU6JdqGq+kD/ning+u4hGyfssyHpbTT3O7IpEVqgY7MccBu9lOP3MTKoCjXMuKr10lrYWLK9znPPrm/ryMBR0J5BtaodHfOTHmK4vLG7X7IDeoOf0qR0Po5aezQjX1EN1NQS/gS6FT/WciF5lUpa+9TGN/w76JVdgO0Cq/5J89AGXes25ESv730vq+s4MnwWEdfYBfe1Ge+3DzX2jXeBOD7P1ojjPY0Jn22t7U6/hgI4ae1MUhEWmhzElHqTdY/6Ly9w5pMVSZW1Z4GiwEvsDzC1wT7vhx/u9+kNduzDOSLYjVn4c6f+D7IzvJTaylbt1Mnk243vRkpSTV2bgoLDulElf6vfHPm9s/C7gAODhKXjT1V5Mp4WMKLwRGp4ukAMHHp4rg0KD+p88/+fWuLCiGN4AFWJVFVISkf4Y7Ttbq9/pu7HpDh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000053, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_test_split_at() to verify the 'age' field.

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index f59ae7ee19a0..88ec046f4942 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -158,6 +158,7 @@ static void damon_test_split_at(struct kunit *test)
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
@@ -170,6 +171,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 	damon_free_target(t);
 }
-- 
2.43.0


