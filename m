Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D56B3CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A486B00AB; Sat, 16 May 2026 14:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF306B00AC; Sat, 16 May 2026 14:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFF16B00AE; Sat, 16 May 2026 14:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20C586B00AB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D96B18CD9D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:35 +0000 (UTC)
X-FDA: 84774141270.20.4F903AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51E7640007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qi0oWhV/";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghk15344U0jdYPPBIp2zMrtab1Syzv57b2ofc9bouiA=;
	b=8BE1HRoDEPJdxce0T+5YOsPpBcnILtLLvEf90apA1Hq2PKGJ+dELI436PCcl4nipgnngMu
	9zIio9sSbR0XkW55nQ9yPK4gwLcYpjN2GJGEjTd3lkxaR5mlwQUnajhLWNm8lp0ldIV2mU
	HhhYm/VE41wAKC+l1GzVPaeeFqEqdyQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qi0oWhV/";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956654; a=rsa-sha256;
	cv=none;
	b=p8iAPs9ZMUoTsFczAzo82pPg06pLNXWwRvyKoES7uM0sc4lt6QZSotqmhfl9GSYYm98zXa
	kCJq3Le3Y2EjpayjsDduG6pJNNcydS1tGVbIukCM3RcNnDxA0uBwBezavfEqJ2oiNtxAGX
	zFJqL0G8fiVFydptcyJ0Sl2+KdENdM0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD2B26020B;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F96C2BCC7;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956653;
	bh=onL2oA2hYb1zaxrnUJeL671RaJBAxGU6o7+rYnG/uh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi0oWhV/hz3fVqVfc9dcYPFprssBLlVKN9rpYjeUANPC2uPTW25eSDIP712BxzE14
	 bD9+/aog6rGqovT/4eylDDDpeNJOn+fXT5udYwY+LTh+h7f42E6Rh+8X4TCMwAx9RO
	 FY8ehGGRmRIPOXjx6M9/FZkZNPrfsScFYcJ550Rgblgi1APDA8ZL3SMLgKOT3vwDYd
	 qyiiSMt3eFu4iwLI5gxdmTfkPS1cfboGcg75aP2J9p+DX0rylcuvV11X7+hf+l0g+w
	 h5gohnM1hgfVVFw39wr1VSXmbOLW3Ydz6+HsOlnisy2tw3QPQxO7zTcGU3eKYByQpK
	 3YckedT71iVlA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 23/28] mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Sat, 16 May 2026 11:37:04 -0700
Message-ID: <20260516183712.81393-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51E7640007
X-Rspamd-Server: rspam06
X-Stat-Signature: qnnix536i7hmhuxqsnnfags6sf9wrz9f
X-HE-Tag: 1778956654-396677
X-HE-Meta: U2FsdGVkX19SbjwrA3n9NGuglXtOqMbiSn+ze4ba+9P50uDBFhSpLcrPtYJELm/1Rm6VjKuV/HKhzCzfNPszwjbl328kiiWJlpYXWZNoYlS8bIzzmO16fwpFWcw3Jbh+Cd2gUf9mBgQLrh7zIGWgwnG/pI72uec8TdEMWSQwpPyAFvpNoHDDViaHXrpXAQpowMCJnu2odVIXABYqCIKHjkvLrpnmVPe4jCJ4i0iljQWFd6ikGSWfmvEbbVOejNp6CCoGoz9fuBgvMd02Y5rC0Mg8Mp679wFxkpglSd4mP4jbvPmCHV/IiJ4d6KqFw8H9+87Za0SmeX5lEN1jDbentYkT3gJ9yQdX55mGQbOVJ1IMIGZV7iM+Ig9qigwzodWO71Gn95DHlz0jRQgE75SCPN/v0A97S5US2rzrAR5SVTC/r5sSt7qB78RFeKtIdn9ChkZMK/K8hnSAShc+pqR49dz5g6t//e0D45nUsrr8bmpdMkfAE5kTI+5mcCRoL857vvS+KfwA8AaYmIKzq0nfuGAV6z5NFgN3pNFT7mOFoG72q5B64QrNwbzXr4EZFpCxORd0wtI+EPsvMTnW0t40xeJj9Is+YkOHA56oMwfagmqIBiakU71F6Y1R4UqPLIRfCEtJtRkFB68JOWw4qcun5YsC1u/hhGmTaMg23N2BWmo/Kaqjv7ON1eAObv/xgB12/9bIyKbuDqMtR8SaAjgOp+VnoVXgguZKiLHjC9+KRmhze6ukL/nsk7lBxnP+1fKtBfSMr3LyhBgLoPHBJAy24EEX5iNN8Z4zqNRjjIL9bTkbn5afalhLtHvFFifj0GXGFEefVM8sJJ4ntILmU2eON6vvl8BaGlDXTOxr6X5ve9fIF4uV+vtRKyTZaF4Lw9a7ao/J3JBqPkoO0xUgy3wPYiGKPFNWDoI+4+aQ/fsWBw13KujsiPDZrIPvlbAP7ogsD9UcQyhGSUZK6cAowe9
 5m6tMOig
 ltV7rp1++g4FKrDm2CZ81Wpvw/Tb+TBM0mAX0ic30N6FV5bgulJOltMfpi3she0C0uolGqm8E4ggGfu99Hvc/FCWYJOutOM4JEpqjTzF7tmEcv83VchW0CVkOLfF8ZYM52smcl1jx73K0DA/vXiFk6xcPwv8CEcCkfQrDs752Tu99fAl5ac1PvKu/LqJVCEDK4aylL+oYappJenUyjzqII5vwBIOaGSeHnpNf0tQbSJfa+e6arx+rEdnkvdZMcchZDe3srsW1RzV6CskrcBoPED0s/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the support of DAMON_FILTER_TYPE_MEMCG on the DAMON operation
set implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 81780b05c175e..ad5a65f2398f0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -124,6 +124,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
+	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -133,6 +134,19 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		}
 		matched = folio_test_anon(folio);
 		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

