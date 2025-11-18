Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B292CEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032776B00A6; Tue, 18 Nov 2025 13:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25A76B00A8; Tue, 18 Nov 2025 13:24:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B726B00A9; Tue, 18 Nov 2025 13:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D60056B00A6
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:24:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D7BF1DF0E9
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:24:25 +0000 (UTC)
X-FDA: 84124552890.28.CEDB2B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0ED76C0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:24:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ud8H5qWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763490264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KzLyoYUtaV7JmG91OXsljbaoJdcsWdUcTqfEyos/6Ws=;
	b=pZZxMtUdnccboC40mYcZfRhOgeP+ERqauom12WN6hlwRm6SRUnOCV5MFQaozVum2c33QFA
	OFCtjTiAvgHFZWyUWy0nolLEl6vhYeT7PrP72Fq3pW7uij63zZn+AwPaffVLmT99UX/EKs
	rb0NXHzM7ks0fQs+RXlbbdez/62BmEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763490264; a=rsa-sha256;
	cv=none;
	b=Lu/+S9SQ+ZPeSAoP0ZNMFswogUNM3xeo/LHbvielKrykG2S6vWiOZfRosMepef45eU82id
	uDuB68G7sw9EbyBPRSvp0par6dd5l4Tfcb1cA+G4N91cE9zk+0ipCnyPFFK/WZMo/jPaLV
	VtT4U5YryQUKd1RaL5/+Oqmw/MWdVzg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ud8H5qWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A4A260129;
	Tue, 18 Nov 2025 18:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01115C4CEF1;
	Tue, 18 Nov 2025 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763490263;
	bh=fyLPAFBoJghiBCAB3NIk/qOCqx6vFu5htUaGPEmW1JU=;
	h=From:To:Cc:Subject:Date:From;
	b=Ud8H5qWjDYrgvHTvxseFOcZjgnjvjPGE1Fykjj2L3tZ23bYArNT/loOO2SCHFtK5P
	 w8elLHh/xQkRtb7pm9R/ENzwvEJ/Q4jdibfgTTbSUuxcoYp5161ptrIgl9lVTpfiKe
	 XAcBZjmcqoVSU4XlyyFhMLA5EQV3TzQRwtGMQFIa4w/oxdiBpJj3Ua7Tv8kx13dmTj
	 RKJ7Cd1LN20q19SqqR44PqI7P7ME7BLMvghYPQQxjJDdeLA8Q2Fl72kd7/E6EbBChw
	 B1pX3lxVWLtHFLwTLvQonK4zdPySJTLBVj4hTzXoKXOo4Lmb7uCB8hEvX5Xwq9VNKG
	 4wnNBXcBob2fw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add test_kho to KHO's entry
Date: Tue, 18 Nov 2025 19:24:15 +0100
Message-ID: <20251118182416.70660-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: erawegu1yi5se5gemg366co85uxn8ana
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ED76C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763490263-161274
X-HE-Meta: U2FsdGVkX18G/1g5EDy0pPae7AJXSAvgULxcGD7/Wr9mEf5LvmZzbDpbWtzEBvLgu2S6rhBhJG/lB0F5O0aXRqiM0rv2F17VGzs2ezEw3CKll7AMWPaVafhFNQLtc1Zr6desdJ6+zTWCgi4BuMkp5zRPeHOx10oEFQwBfoSSVoTpVAzaL3KyEFSQFIb3YQ1dq4sT4mW6uCGV9Hf8BEOnjbQuhxJJeSFpAnViWTabPexZshLZcFx/QIXwpX5eU02ygmrJJPICCQpDKwRnB4paklX0MFzo98BboCB0rZZ27Mr+LdyvTnm/pzJqDq38ZY9fxHrXkk1uabuvPFpZ+M9NETpELvbhgBJoUxV+ngHI4kYd9Ql7KFEkn0hk4tGu2ZcIfv6nSAFQSJbdpLoYCAOBDVRzmj77g2yWE8EgqZT2vG4C+xJHwCG6JtofqY66JXZYgdIWNaoVihX6146cMB5RjFsTWsYLMNOHDbHzbD4XKFCZbDrTHAKhJR75uZ+Hj1w0RQWPUH476UIMJT9NDJgRJQw8SUj9iERN+C7U8SbWYzi/SMtFJtLbjfhgzdXX79MYNRcDCnH7EymaVS5JhGvBZhbjcTZjvc9PHUEWjRN555DUrXd4+eGaG9p2U279jvlfIHglm4m5WjPunmHzqtlOICWeyokBfCrhszFs7C9QQDdZgVljNcn2OaHsyv5iDhKIz9cg71uT/UaydAtNcbCywJBO/ZaK6rpZaUURtflXx0viZnap5X1M80taaUou9mjL7Tphh7ViOy15VwLUkZSkoSYayNHy4fiSE9o3vcbS41z1h9mvzH0OtcMQA9nvvC8qSgONGWFwgy7JA3F/FtiG4Ts2jApP6YxZ2HrxcIYrxeYBUm8p3pxqKtBwmu+5I+/i8DnMqzH1RJFRHLSRyPA+IVh+9+DuM1jI/bdUpN0oN7fJ+PKSKTmIG3SjJX8XQcAZnmvxNW97kzIwTaylfJS
 0WfCjZmC
 2lRx21bTu49lNMtZBn0E6iW8geFfHs9pGSHnEQ7NF0C3i1hlkBcuMlPl0pZs5gvTTo0Qf0TFRuKBVITq4+GnByf5JOC6207fsVypxhKepNikYX3J2AqYRfsr44gZAuly04JAnFOp5u8HmY84HAzBYSVTjCmGSxP1LqDlYk/SZJcmhWRlYYjXNu53PvEN1LqYPe9vbdOvsKn2T4OuNtHQZDcKM4YeTxyp4WntnjXOuXNwgk5eOVdvzUlw6A9ZhxtTFadBsw4drlUtv/1TULbP3fGt4ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
KHO maintainers can get patches for its test.

Cc: stable@vger.kernel.org
Fixes: b753522bed0b7 ("kho: add test for kexec handover")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05e336174ede5..b0873f8ebcda6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13799,6 +13799,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	kernel/liveupdate/kexec_handover*
+F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
-- 
2.47.3


