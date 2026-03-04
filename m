Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85300EDEC08
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54946B009D; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6BB16B0098; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957656B009B; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 817636B0098
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34AD013AD85
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:32 +0000 (UTC)
X-FDA: 84507132024.10.8307717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B4C0140005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tbFpVsFl;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrqFhSNeRFwqG6RCU3wUlZ8s21n/U63opKYa/dBCS7w=;
	b=0PNHweENvPbdJUMUaXWQL6SpyinFAVyJycw5TET3pNzTO7pMpYgVI+IQkLvgR9x+5bad6O
	aP+n4OZL2pcVb9zRAOpXcBFhhF6EZZDOSXpOULS81GD+P+K/C+PYanZIHSpNyhc6rRciZL
	39vp+BT0LgUp/ub+b9G24HBtds/l6oY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599290; a=rsa-sha256;
	cv=none;
	b=bzGgx8fA1nhmUuOfPeoiJlfXzHkicXA0AjtGrSnzsiXhN69vddrHZYorh+u9cIW37kCUDT
	D0P3i+Mpz5+p2ipFrA2djKH21DGuLszTP03xA2thLh8Zz657qwvlasBBrWeckpu89ECEYP
	NX3WiGGVHfENrBxcsGgpYejLY4JmZr8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tbFpVsFl;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C251344731
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C5FC2BC9E;
	Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599289;
	bh=X4gj60NUP5Gx9WKLfYMZxZSkKyfsCySS7inf5fgIm6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbFpVsFlnQBOtv+KJazEbh0Cy0dQ0f6CkZ9Z4jYoAEgvMP5BuHO77eD2CSvnppaH6
	 hv5QGfbB/P1y/D2dZM7sH0Zx+Gp13w2oAimfgHw57a3RQIzacYm6SYOhiinjni88D3
	 oTG9iK90CaX2wJWK3QL1ELhTKa8oR0t7DqB6BR9dxB+nabx5MoZyqq0WwIasgprgdt
	 /LFnEguaqIVjbjxJAqiHgZ+p3LqUhekNa/gAp8kkkOiSP1JPLP+BVTOsmS3j2QXM42
	 KCvhd/V2N7qXB+tqoxyqUyDx1P6zZ1hVr8Gveq/3Xxh7osOJ9WmdF4aJCs5WpXE/ye
	 C+L04GDYmD14g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/10] Docs/ABI/damon: update for goal_tuner
Date: Tue,  3 Mar 2026 20:41:16 -0800
Message-ID: <20260304044122.79394-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zuhqs3nrr6tcwqe4tc59hor8izwsk3gn
X-Rspamd-Queue-Id: 8B4C0140005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772599290-951011
X-HE-Meta: U2FsdGVkX19ZyG3Zo4D1guUppYasJ1dBm6sfZJLCLfPjktTu3GBwSC0FVGPk4vrURYbxmNi3n3j7yXcycpsAdH9znG0smnJqlFx2/ppNJvotjSnrgcjCZHulnknsmYalbzzcfZtGZQ1FpYwTTxCm0yLFX1WlgHe1fFrDog2bLHRlPFwu9Q+ZS2RNXedA31leD0GxpylXUKKNI3o/ZSIH9BqRiW4A3VabtoXuL4AsUoElhcdUFQiAdt2Ez917bTb2Pt5VVhqbutdrFz/dKDmu9lOZU8AKQpPOFBfcIK4WVVfBHCBDARPMZPQh+AD9BuMJNCZehXt0GEGfWreGtCJRy8A+r9DULdZ8KjKNMpQkQyNlto42XGckoQ/kr99jbMbud3FTCcX/oYGft7Lp2+26XZ8SmLR2U6PLbMaOqzAB3ydhQPxVoSYk/j5k7HFNUiutDQ507T+xY0fH/nupAGGYgqO4APrsZ32fihf+3AUboaRjF4gKpcyaUFCO1npFHjHLjRDH/A5n/JfTEFPTXJfYub8euPFMNKo5pUUybfG0hX2kwFWqs8PoH8twIYoxXfpWqZ6TXDEjn93dfoZQOhp5pjmUypluoN2ZL6wmPe3Xn7AQ6t1CfgiZY1NFYYlOCXhTce7HSkGmIP+gMlbR8HNX9oL7FenVA4mjCrPWsH0FMRKhtWIGRxOBAsuwX9OeoAmcvs8u19nDD+wQJtzXO+1PrInV6U2PfWYkkQE804WMeFWnPV4xorx5z7gxZjpTaiua2fMFpjdrbLQk45eeiiDWjwFv7aRN2iT48tlxMf/ySJhOWzjuBbc/NTBdZW+g0ctT8QToCiDxvqF/tp+IHu0zvMV6q9wUL5UJSMeJmXlDBZi0RYx8f2tR5bUyp3+JK+SToDIJ1GRm62bAvCzO2XeX2oNF/fVLFDb7TfQ1+gTRBjDghGoeYC2xgWLrUQkvOH/TBWThc08AnVruqJJvPnI
 UGGKKRML
 4UONpcBhdb4rHyjNyrF4NhnPj3uPClNdSaTJyus0shtx/uaEnenw90wHZ30oi0cUgrQF51hosTN+KCe1iuV1Ayj1cBjjsftQ7zOygQGzSRgxRnlo3/XX80nhYwBUJ3OBneK8eyFcVVtExcy+v+V0RdBt29c53jVVVodHlExYtTvcCE3i7OJh2nl4588vYBsblT9CGKWmhtYHkI55mQkJCPP/ZR0vVzc+rL7ThY0S/k38VKVz2vEkiZ8dKSzMdPOBRLrIHl7TZnsknpZIfytuIsMqueIXD7tN/eVzeztF/pP3qWKwkEy4AclmmxiAtio6PcXFNHVSWMLjADluSkwIFXpxdEiyIbop4c79y+RDPJ6BnVo+uxu2dX/guDHbyGgcwmKfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the ABI document for the newly added goal_tuner sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f2af2ddedd323..2424237ebb105 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -316,6 +316,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the path
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goal_tuner
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		goal-based effective quota auto-tuning algorithm to use.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

