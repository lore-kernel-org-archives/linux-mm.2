Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196A6C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279626B00B9; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE676B00BA; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13AB36B00BB; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEE2E6B00BA
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 403B4A052C
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
X-FDA: 84951887496.12.271C8E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD75880009
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWzj0rNe;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	b=S1K9Aj79XKYky0EP/mawOG0w8/eRF3a0/gB2zjqV0C5XtrvdtHLUBSniXf5v40kuzsqqIR
	rJ1AW7TTwpUwRDJ75qQqVhQtXQmuGseZu1oj0q3YuEP/T4/mPOrEFsITxqHpNtaOVeYP1U
	rRXtKNISmS8YcSNeWbLskk5VDAlnmuc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWzj0rNe;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188706;
	b=Iz2Ae62HnVLVhz2ZhYyxItDsJlPZkoQLGU7u2G8BRu+RMQvHoC82OCAzPhuKOzfyCMos13
	CStb0CYaZ/XG3KBJaBuswi52J+ILbXWbO1TDVclqb+qkmrYiHqdg8B/t5zBvwiAuSTWiYj
	LNbi9um3vTOCF4o+ZKyx5/Vffii6pis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5076B6132C;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27D81F00A3F;
	Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188706;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWzj0rNehdXjgnHmvP2SvRyGTlmdNS1ZLdg1+GnC52ueSO4Mm3a8QznUvmieKUZ+N
	 nsSC0Zfh9MrnVyi8SAq1lxBxNJULRmIWbXkLIXQV6RllnHrsqFZ1udwnYx+CD4W5e/
	 KiIICcOVC+/p+ObNMHa8hLIPFvD2aCZq7O7oDR5AMlxEM0O3VxZyMZe+xfs7j3Uxxw
	 mEyiDjSlpeZUabHMNUAkAY9jhMi3Bzyk9IzHw3yk4hYVIr8LDa8f0UnVx+LGPTPlB4
	 JUkY7RxPUEXuFRZ0YY02FkFwbW9Cp4FdPBujvag7RUtNuII553OMacjjNs9q0URspN
	 eZ+3IFi3mVmUQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/11] mm/damon/sysfs: ignore damon_stop() return value
Date: Sat,  4 Jul 2026 11:11:27 -0700
Message-ID: <20260704181135.132956-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD75880009
X-Stat-Signature: ts6ju5i7hiukxh4kdqc7oowcpezsds3j
X-HE-Tag: 1783188706-557276
X-HE-Meta: U2FsdGVkX1/3aFqB/6SwL/RiW4z+lYAvUoOpTzLnuBcKJES159N/iQ0dofFsyI2ijf+WM7KVX4UAbOF/ByzClT8aSAxlOzHoXXT3/HpFTK8VPU7lljWhg+rz29+GNwTiaQIn//00F99jrzRQ53FWJfULs3AXdT0TprzPMBNMm5YJUFZgf0O0upYGYuRHHn2Wysuz6h/+salrW/pxPLSA7fJC1Cisy7ROFc/2n9/Zj1oyV6TCecN+6XafUt8iXW+sh/f2twQVVA71qVAvlPzC3fL4EBZkE17kBJ57BWQFT8yUkZtbpWEQJZWSKlvbOtCheU92k25MhJf73Pl43vlvSdHOrrVjGE31yFeJkJcs+TKY8iLgVJMJvFB7W2txx9sboH8h623U0RNr0RztR2PpE1yKfoyny7TOJ7zrRJ1JRyYPfUGu5LTonfm0l6PYtsrG37/RCOB0xxhnhnJvg6rBAi9NLf1T3easI1haUTP35BIKu73Y4KjMjTgNJU8Jvgp/jbByQk73h9ZS4Dnpb/i6SkV/U0WFlsm+tTEdyI1wJ/sKamKtDUO4ktEi2lGcOysNigwfrPklGvDD3bctpyfx7yjntYG7JDELAK95HivgmffNcteGjGqRKwy4NPqiWuQfxDJ51g/Qo1OTq7wVvpK3fuT5gK/7Oaoe+1wP+1EA1m/Zoa8ak6OUDWxygXej/cIqdpf9Mv0m6FK7v/hUDLk/4ZHqLA2iTFwlV/h6LoBOmcYeiugT7ulyXPT3gqiMbVxhh0mIhKvxIb6isH2GTzR3jQNJstsZX4Bf/C2C2rNkuwU5MMPFsI8A4SuOdGnAq7P6N51jF4FblnnK5ScT1bK5j4MDxffGbtmjgpRt9crjZDzZfYVZUovcR35kFW1CE1ym9VNHo2V3N5BuCz1xwGa3RuLcHvp4BQ0AyE0Hl8fZSY0LqT8okcNfhVvwTu2p7GShoNFpUTrxUaSzpxRtIFe
 t3urwjA9
 V3uekpxXSffsW3zUUVCRoQteAOzI1Zr1aJK0pG+rfgiMEzo+L0sITplVHySwmAcMWa2IS8Xvv8pjsLTe79niJIyffKT4BEBYlnD1Kuc/Nt8DO2VmzsOzhELjMK54F0riOuYv/EwluoKNFjIACQnm8dBzF4PJZkb8nlXPN95kZwI0l4aMxaT9QxWVoOzTB5H9GkDRikj6aseMv6iBb44rnxVN06xZ6Q0CHe8XQa2JeLZWijDkjhtcQSRjRsaBQ+Glo+eSVOFczpLbHIe2nAxupRbU3Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b65651498e0d1..6d7e36c9e509d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2262,12 +2262,13 @@ static int damon_sysfs_turn_damon_off(struct damon_sysfs_kdamond *kdamond)
 {
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
-	return damon_stop(&kdamond->damon_ctx, 1);
+	damon_stop(&kdamond->damon_ctx, 1);
 	/*
 	 * To allow users show final monitoring results of already turned-off
 	 * DAMON, we free kdamond->damon_ctx in next
 	 * damon_sysfs_turn_damon_on(), or kdamonds_nr_store()
 	 */
+	return 0;
 }
 
 static int damon_sysfs_damon_call(int (*fn)(void *data),
-- 
2.47.3

