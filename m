Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B6E109879E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9977D6B0115; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970F96B0114; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E99C6B0116; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1786B0114
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C2188A9D3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:21 +0000 (UTC)
X-FDA: 84566918562.08.4037F47
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52A9C40013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b25iGiyl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9kndfgMCZCKetzY2dV5de12tWjdS4gQ2EEcaKP+Gqc=;
	b=5sQoc5akRSR2iMbueRHzLNYO2xtTgoQn0SlrmvFoHCMbdd95nloO03HgbHu7HAKX8vFK2R
	38Jkihxb6LX7gcO+5VImtgfRVAJfgsMDGIQd2RoW/lzlldCswW0YaEItVX/R+C3jQazHhF
	h2yI6nXB6ahdXR+lxA/EReik4+s1BEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022779; a=rsa-sha256;
	cv=none;
	b=DHSet8qyiTGwR6Mv5k0q1/7TCdl+Nvc+xOifMDfmcFV3wF7+AOtmjto0JdggkIBLizGsJL
	cLYoOY6qa9aweXTf9msZY8qVXUBOwVauNJ0etSokZr2qL/sJOvS9l3tmos6mFyDb8iDIEw
	R8FWXKGUYwzDFYsPESNsa+ZY4lzrSwI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b25iGiyl;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=l9kndfgMCZCKetzY2dV5de12tWjdS4gQ2EEcaKP+Gqc=; b=b25iGiylgLjyndgl6W6bc3ZGs6
	KlZSpNyWNDd84Ib7bnrJ+Twnr9qOgFHISsnAiVNV+uIY5IRkPjaCmwxBzILLlCDoZhRN0QUFFw7iE
	TSw5gbm7SoRGNIgKdcnUlmGZFpPpZ2NnSNpD5FUH7TqifeRy1+RwVjWgdw3zTTwn6bipDVQomYYn5
	OJFj8OUWf56/viedsHtvvTjPblWDtdG0pNDGzZt6a814Gkaesz+I0ob82q4nZZlw3KaNPsE8HrlWP
	Zb4HzbBMip+OMf/F0/1xxPECfYQ9+DOae+E2re5yFY7R2EiYKr/DzHFZSk1w1+CcHj4uvX2m7eV1L
	RwHLUoUA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3cMR-005Jzp-2R; Fri, 20 Mar 2026 16:06:06 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 09:05:24 -0700
Subject: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
In-Reply-To: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4764; i=leitao@debian.org;
 h=from:subject:message-id; bh=jcKlEqc3tnW6wJZXZzWXv+1ozlKUNcVO+d6CbRLONSk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvXBkBmQWp9u1MFJo5jWEpvK9HSU85PcjeejVy
 RJ2GuPAYvyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab1wZAAKCRA1o5Of/Hh3
 bTqrD/4rF5MJ0vclBnpKacOkjWgWRZjhwC+jgdt91QucxfAEI0/Btsk0hztuEMeldxSsgHw34kh
 xnkBg0oj0HaV/V798fnohzt12Mb/lXH/si28DJ5L430kkeh1TxyuDkRNL2GfpachQig+Yw1Haf/
 QjlGJgh+eVopR4RQIgKZFtlYipYahaFkRVOXE1iIY5s3OwUE2ILCRYM0tjh0LQo4gLsoQnsrx26
 Ts1GfEbAEH0lrG08p7EAXDEh1f7qIOYYp5jFtu3GS38SxQ2d7mL9j/Pz0FPrfX1H8ijf/QkYVwY
 vYzcGJ9gLLjcMDKSxsgiDvWzZidd/rk0cW+9HfgF/ViMJL19l7bV/5LADnCZT6qVotdnZU4TqsT
 9OnI+d3YTOpQ56X5QwgSpyzFOayTcxjqZUBSce41KryzoOrfIJyCJfBe+81rXsMNWC1InUSRT9w
 GY/9aTOCfT9B+qaFY6TelVCEdE97qaf7xHPrM+bY6kvB8tniF8mUDWNaCmvTvmUG5O8cttimGta
 UD6d8XRI/v8KG3vN5N7IhTLW0PKs5RBrFwbMM1RyE0aF6cQnVY+gPfw2+Oc2ZcNmeeaxHtsRepG
 mJYcpbt8jrulAFpjOD+W1rgf3l8sIOPP/oNeOjm66WnN2IkE+SmmNPg5Uf+1fNr1RCQESsvqveh
 BC+0pw8nYMHqYGw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52A9C40013
X-Stat-Signature: 565uecn5tn5xw3t1mtxiwm69k6bkr1xt
X-Rspam-User: 
X-HE-Tag: 1774022779-687703
X-HE-Meta: U2FsdGVkX1/c8Ayye+eDk9U61HM0xfXV9KMAY6U19FsDpz0kRNLbOhgNmkPmrGpoimancEbhYKViCkosT4ljer5jiltAWwn/HApxD8pjfUnrobxt8Ot5YJyEde6cfh85/xUm6F+nK5AGRN8PgEt+DYkPHl/GsXibi7wdORt6/3NhNwuAXOuSout0hI1734R7STwM5y4ZpTJajgqRfjZaINKV9sBbHe0BAloFk2HV93lUnQki302A1Tlk+Ni0B0iM3YHrp6vCnmM421X5m1kdvu8lfebyuBTwysXOJRqNEZ/PspUeMMz/+llS4xkKc/6bsV3z3Es/PB0P1Sj4+KSClW6i9sbuigwEN6ESbur+YypnlAOk4nixnHBEadaKutrkAwMD2/tdauhzs0XNtSiQEDrPGRZ9pr/kvYdIgVRGwzo3zp8XEfjcqrpBHM5ybhsiXluwvMwuyt25v/sWdFwRgjtJZf334U7RLcyg4jvo6lS0TPgjOdojI3MAZbtchQs0B1wiRf/Wk3/QlyBSp04J0XIQKtSfIxNsNa7ZaUQiuSVAiZ/mU1Jg6Lh9zT9AQ+cKY+vwYBTb3L7uOUe7D+BgJK4/mg/c50TUkTHjf4iQGQvfR3DnDFbJGcctXaKi6BKrQAK9TtC+nmEDaLJeDzNmHE1CWpEGH3qOF6TGHBmRpppQEkAkhzT8rsU77p0chjLUXjDr9VRMung/FRgox/cbxt9DMrv4QlH/jfzPtQWyu8LX1uBKHsoZMWC008h/xJJP8hP2ns/xZPq/y5vaW04i3OQ4CtsSEFz+CujvRqtV4W8DoZKFjSYbV3ANBR1sjY3a3wbXVNMqqBd51/7miJ0Ana550ZsOTTt22w2lyeAnsAw89BrNT4hODA3oaoeoaAcWa5oZu1siGoxn1VJDed9VI6bojB7APfAYMNaDBKM+EFPFtKDaVCSn+X+MtVG4NrhdSgfRv9oCFnEBiulItOR
 m9WUZljO
 jLEvqyYmHxIMaxqQK1TDCWErW84EUGmbpBJDN7pKGP8ipntgxr3nhArI1qyw1fSg/tqriwN07jEbt0s8chtB4lxdOvJo+Xus+Aov284I7b2fNDrDpOqWcRNhr31YkZ9q8R93H/SOHN0nJ1Jvn52dBRu28g8mqIBw5D1WNPkVg1dBtZQUItcWr6YQOqNDAUt3X8uxEtA6RRGZds0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the if/else chain of sysfs_streq() calls in defrag_store()
with sysfs_match_string() and a defrag_mode_strings[] table.

Introduce enum defrag_mode and defrag_flags[] array mapping each mode
to its corresponding transparent_hugepage_flag. The store function now
loops over defrag_flags[], setting the bit for the selected mode and
clearing the others. When mode is DEFRAG_NEVER (index 4), no index
in the 4-element defrag_flags[] matches, so all flags are cleared.

Note that the enum ordering (always, defer, defer+madvise, madvise,
never) differs from the original if/else chain order in defrag_store()
(always, defer+madvise, defer, madvise, never). This is intentional to
match the display order used by defrag_show().

This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
refactor anon_enabled_store() with change_anon_orders()") which applied
the same sysfs_match_string() pattern to anon_enabled_store().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3fc02913b63e3..4843e2154038f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -421,6 +421,29 @@ ssize_t single_hugepage_flag_store(struct kobject *kobj,
 	return count;
 }
 
+enum defrag_mode {
+	DEFRAG_ALWAYS		= 0,
+	DEFRAG_DEFER		= 1,
+	DEFRAG_DEFER_MADVISE	= 2,
+	DEFRAG_MADVISE		= 3,
+	DEFRAG_NEVER		= 4,
+};
+
+static const char * const defrag_mode_strings[] = {
+	[DEFRAG_ALWAYS]		= "always",
+	[DEFRAG_DEFER]		= "defer",
+	[DEFRAG_DEFER_MADVISE]	= "defer+madvise",
+	[DEFRAG_MADVISE]	= "madvise",
+	[DEFRAG_NEVER]		= "never",
+};
+
+static const enum transparent_hugepage_flag defrag_flags[] = {
+	[DEFRAG_ALWAYS]		= TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
+	[DEFRAG_DEFER]		= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
+	[DEFRAG_DEFER_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
+	[DEFRAG_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+};
+
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
@@ -448,34 +471,19 @@ static ssize_t defrag_store(struct kobject *kobj,
 			    struct kobj_attribute *attr,
 			    const char *buf, size_t count)
 {
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer+madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
+	int mode, m;
+
+	mode = sysfs_match_string(defrag_mode_strings, buf);
+	if (mode < 0)
 		return -EINVAL;
 
+	for (m = 0; m < ARRAY_SIZE(defrag_flags); m++) {
+		if (m == mode)
+			set_bit(defrag_flags[m], &transparent_hugepage_flags);
+		else
+			clear_bit(defrag_flags[m], &transparent_hugepage_flags);
+	}
+
 	return count;
 }
 static struct kobj_attribute defrag_attr = __ATTR_RW(defrag);

-- 
2.52.0


