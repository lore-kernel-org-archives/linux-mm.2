Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FAD4C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEAA6B00A1; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A785B6B00A3; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967FB6B00A4; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731BD6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5486140258
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:48 +0000 (UTC)
X-FDA: 85126258896.29.FC44A21
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E54540005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k2x9HoMA;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=;
	b=zfWhr84g9Wvg+4oOdOnaaSy98s6T0jbF3R1n1x+OZ7TrOT+mDJ429gcavPqJjd5XYJqTPw
	9buDHLYA6kZOi8MocZFLEEM9vgk6scMLhaBF2blwO5vr45r5TdbZVSTNKsT/fTbI3H5Xd3
	0FP/rHHSOgmBA7zTFmrnwusZgYWsUt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340407;
	b=SE4z/GqlnoHI0Pp6vajh/4eRjFu7MHMQhjS2n+DKnYNdz1KVDDEv0ydHFhmCNgLnR+SCB0
	LnX2uuY0sFoLTMw95/j4rmLQenG/ezt+rsOcd5/FrRubESO6G8N1vFSqkF470Ph/rB45ZR
	tFFut25wf/VH5U0LsrOSArnH5BBOLIU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k2x9HoMA;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=; b=k2x9HoMAcdulhKEol/uXLoykNm
	h6mGyqpaRKbTyIT+/+X2eqUGuDyy5rEVmpKbYigIj5KKMf1pR2HXAeIajJSt4qklGzo2mvO09wLuD
	ntzwgXxSE1XyXG9SqJ+rrIpJ4xeCLTHlNRNKE9KEU/L+uTAO4Zvnd6Phs9ugC5oHC04st++jyl6Lw
	oqr/mJcxEs4Ce670WrhBrmIiGwCvICfkOgXoviH9f/zI6HV9RAhv5DZ9U2UzqfKI8s7aSN5fXwSQ1
	z+sfvDuOaclMtAd02dkopHEhb02iR+ZW0bCiurdQ2Z4xIGUau23vVMH/Y0uM1Uq3kqi1GJQOgMs8j
	eA/lAuSg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt4-0000000E0i6-1H2q;
	Fri, 21 Aug 2026 19:26:46 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 04/19] maple_tree: Documentation fix
Date: Fri, 21 Aug 2026 15:26:12 -0400
Message-ID: <20260821192627.4085470-5-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8zrz66uinut4sj7mxy8u7itpwmbqpzxo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E54540005
X-HE-Tag: 1787340407-879562
X-HE-Meta: U2FsdGVkX18406GHcgMqkDYJnYIUMrqRRHonOS7hOKWNCSUgSALd68euAvmbw1PqRxtkhsVGojj341GJCccPUOIphRxkeCXrGr0mPIfPx6R7YhnRsKnwp8Vc3Zcu9Ch1vFNYB3BCyptvb2Us/K3B+hyjZxnKbsbA/TsXgyx3bnNJfmiqRchgL18TXIdzbnq0aZ893fafTZk6X5t7PCftEUpob2nFxE8m0seFKqgmliehkfou0kSGliXFFzFyduaW1pzaSKU36QNViqfVuj72CWviJMUTuQKiq652dKxJG5j7FlJLx62dg/s7qSQFxsKKspu9Of0HzPwfHVMxFJRhC4m20IKCv0FfGo11g8tkErB6Z1c9JGkLvmsjx5zbGttf469tEzeyyvQj0YUQoluGTw5esDTuGYfXrPrK0HztT0gH51q9TEMeoT7hG53U/Y9dM4LZGbs7ymgsCdVPWzGuH+HwUDruyiWMXWtfz6a8vNl0D4KFebYJBF9ej9u4uKcWhx1RSzXhbRuIZIMPLYpfBrrPOqfjKssbFMKOspzc7B/Yz6SMzyB2ulpqjRRNw1Me5lmrFkAj3Kr5wEqX7mXcY7sWjBI5+dYv/7T01GLU2Bhic6w8b3o6dQUAsnKyzNV3SZmacCBwYu9AcHG59MW1Nea/6uI1C8FNNKB9OsgU2Wv1SRfPptfEIczbaIDLtiLzWa8LBwuYSOKxQCn0d7GWK7IRMkFWE04i+YidDwd+iZMk8WfiQpGuMj6UV96CwYzq0dC0GTPEs5BUlBtZljfASO1bf16HJrQYFWc0IttgpgzY0KufEBuN2euV3nqirp6+3L2J92sbnc03Ji7NALen/OUL/udmhKYxqbX/Bic5ckSfKt1WwmndQmvbwUxyLiinHpS7Z18ymnimqNj2HgQOLmdr1hXCCN5lgdS0P5txMiOqs0fXQQFxndRqCxUQA7onRIO1mYehy2hl/7DQ6pp
 QNhA/J6Z
 Qo0oxb3HUXPRjhWv4gBaoMXfPGic8q4CVYb9xyhO1BYGfxsxAxn2mnHObNOc9fU9cNGL7faIFBPtfWJOSgMqusql8FrHdKll/OsLC/fTDRLFEf/sxvxJYCp/OUw11axuJZviGkIQEQeqX6mSvolrEoCg8xJPA1RrK8pmwrlkpiDkeOhScn1e3yfftSPMaCQ9H12pyvCFpL1TsOwAV+K7/aFy5q8uEXhj2hkV+JC2AK1C8877g2z/LCZTlEPnhZ/SeZQvRwDWxo2ibghF6s1NkqXKNkym5de0DZGASYNqey0qgqUynEW1pUGUTHyGSyTu98cJnePmg+RbWMv88VpOQ+Tnjvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't include the word flag in the quotes with the actual flag.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 Documentation/core-api/maple_tree.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index ccdd1615cf974..34964ec88d179 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
-- 
2.47.3


