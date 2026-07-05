Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74676C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C65F6B00A4; Sun,  5 Jul 2026 14:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2779E6B00A5; Sun,  5 Jul 2026 14:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D6F6B00A6; Sun,  5 Jul 2026 14:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE3A36B00A4
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5527F120190
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:22 +0000 (UTC)
X-FDA: 84955505124.17.F1BBABA
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id A30AC180009
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pSre2ZvN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3V51KaggKCBY54wC4Kw92AA270.yA8749GJ-886Hwy6.AD2@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3V51KaggKCBY54wC4Kw92AA270.yA8749GJ-886Hwy6.AD2@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSFfgKio/Fj1RWPgF9Pjw9cJtka6DlFGczcIXs+Q11U=;
	b=dGE4H0+VWVh1rTEhcY7xZrTdeHyHSJRTb5JeP/xjiOvKGZRBO+4XXoVUC2Y99gX/SzC9Ww
	qR4ggqPJGDV/Ltpebb5oSttJzOwkPYr78+Xm3Eg0AdbtoMq9hJ5BSUrNV5NSUD7M95DzCI
	DuHy5Vjcs36TADzh6K52xiCSzHAFDw0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pSre2ZvN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3V51KaggKCBY54wC4Kw92AA270.yA8749GJ-886Hwy6.AD2@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3V51KaggKCBY54wC4Kw92AA270.yA8749GJ-886Hwy6.AD2@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274840;
	b=5dtPwHxY87NTmJFvjWI1yAbm/TJtFtNOeAbTgtIe+KwuShPUZlJTAj2eGd2xygjQuD3TuG
	tcA9uzg6izCjmEkSRmaylwPg/Hj6BxRS4slEPSsjQowfo1rVx7C3OhgDfgbIPVoQewtXHw
	oQyv2G6PRjMzcuk4FtyNTOoYYKUJ8xw=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c9e9cb6a44so17258035ad.2
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274839; x=1783879639; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OSFfgKio/Fj1RWPgF9Pjw9cJtka6DlFGczcIXs+Q11U=;
        b=pSre2ZvNsGuytLassfwZO8H3e+jjYES3v62cUNav5HthQHroxl0vUJQRvrnCSx6pVh
         ANjDcR9jukp0YeR4E7RVqScxZckqo3ZD+ZCW96wNE+hO3dmlKlncS+WQ1WApCs+MnfpW
         fRcPrJk5eY2Nh1mq+SeaPJOCafGq8uZQAVagXfKEJr6P6+qt5kL5lWH0Zqk3lbOZWS82
         8OKhvUQYBI0a8v7SsMs37zyVfvAqboyGvzskgDod4/siyUb0MaOQ2G9nBpvSXmFBIrn0
         Y8Z49JtigbQ4v6FkvFrvIYe7hmng1LysBYF9nafWaJZCY4ojdxSiZWhv4QqNikqer22L
         LWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274839; x=1783879639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSFfgKio/Fj1RWPgF9Pjw9cJtka6DlFGczcIXs+Q11U=;
        b=n4lHGpIcHwpCnp4WjiDZ0r8iO/sM7zznttijFHh0O2UwB2o6Bp5PbSnsloVP1DwwSz
         SjJIYqmOj/tPk8z1vg4xLPQg5tOAyfDXrH1M5j3JEGcTUTx4ikvaUkn4Ce6RZnAqybtC
         S9BCSYviwwH9xtK1nq0pDh0A1JPM0MpPzY7DaCRQTfdxx4jTYwxiBGVfak/UzY48SIRS
         cjA5nTK/AENfdHJmINtFBsmHWbH2AnW5eOqe8f+oiuH6tkayyzpPYDknStyWVVEQaAyC
         P5jFzKhBnu8SbaX7ARIPgzJD1ilzr/O79Ddz/9I4xZNclVWMiNlJBpN3Mufv+IzEdoWf
         S4PQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq30RbNwYFe928PTRcSHiYssrvbVbTFR/F69wv8tXB5ULnCIvGJ/bPW4jYhh4+i7yx9RQqrYzQ8CQ==@kvack.org
X-Gm-Message-State: AOJu0YwwnlCQ24YgW5ouo5BWtACBobmrLn/InYlYWwM1MszS8im3NOch
	1gGo7mdt6J9d5/alLfbxur2je2HA4ebWlvfhc8j1afp+bc6wyvLcpkqlFeMVp9CBBpkJXpexFd7
	P7FeuoJ1+AHbJtg==
X-Received: from plblo12.prod.google.com ([2002:a17:903:434c:b0:2ca:d98d:e037])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce12:b0:2ca:ed57:8586 with SMTP id d9443c01a7336-2cbb9eb40dfmr69811215ad.23.1783274839411;
 Sun, 05 Jul 2026 11:07:19 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:12 +0000
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-4-jiaqiyan@google.com>
Subject: [PATCH v6 3/5] mm/memory-failure: set has_hwpoisoned flags on
 dissolved HugeTLB folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A30AC180009
X-Stat-Signature: c53kbweahmksp4h6tsh89hfspsahut4e
X-Rspam-User: 
X-HE-Tag: 1783274840-233392
X-HE-Meta: U2FsdGVkX19xGpK27zPDSHv5rVFCPzOelZDxFxero6IejYXqkl80V9yZWLTErmuRebOc255f3iqSGb1D3IaC5Wid9UOOMeQzj9Bz8zFs5lfjQ7X4ll6+9ycD8ZdfFzNNRhVSOka4z1RDqfAyRHm2co9wqa8k8zS9Cf3iE8YD+cJxBMkLQvRV2VJT7g8akguQ4tNGISuYPIgK0bTbDFAtKY23OiyQJTkHsUGUxwKerN0QotWRobhtXP5LK0w4Hc1IOPcuim393mRSClcc8awWQbz3Pfdio3s5qhGUHDBwH7Fw7HDNFGSf3/qukMYbKu4yJxtRKY83FPVCd0qr7zQ7XcCASTwN9LS0A9+gQUicgBETvF2OK4mlmzwf5AZVpXEsgpkedrbGSe7fnxdX3UdHfIne4/0NVNnT/F5o6YaU1CcuH0eEh+ifjK7iSZIMneQN5pkyyjmG65GN5jul23Igork0ybAhApegCb/tkESvoTDE8RirjNjgv+67hOmz1zdaihHfRp33vaTUknTue+2prJIyDQxtUTkMfa6uZxakxnFqvH6KAop+umcULxQ59lS2phWsvw30ZVxUbXpzjZfToiaNT2oXCOoKsQmuFF/4YDTRB2VSSlDHCCP5LfFlBYKGVl9Im5brPXkqg+Q21NvAoR8eAe+dhr6gQWoUavfA0JemJ3OCXFzTN5tZtUZ+4wFMpSxXtPERCiGDHyWVt095keBrJgGpFl6fQxTvjVgIMuqRTlfnkbVUjnmtsGmjrH0T+hoN39L3RJ8Elgk2nzGgry5mkPQN49GooxV2L1zXT8rtqHKtfIObKBAz9kZyyFVVfGDKNw1JbVa0Ja2uL3s2LMg9+eeNOXPYDooxDJdFR41Ib9w9zPGSeYSgPuIItj//HSnlS/Ph52sYJEevJc69ha/6ciC4x6ulW1ladXkhooY3jN3QcWuufFcNiNjiLE52Kh+TS0PMbd9HkJwEiRl
 aMxHD1SW
 6BcA4+XNKhwYZTZGowELlF5iUxoY+r5rlLuCZP39lLunbLgcKo0YnfPwA+2UTizCDcTYnRzTnonMDj/sd58gs2w/wkmRJoNd23P2jhvj9MiefCWQLdKfGp1nBFH/sfyqTXUiYxuRBj2tKEZgRXEHrkRz0FN/9jraF4IknGoxPCn112TPUhbnG7KnLygttM0IqaJwdVvJ6GkoMiHE7XrGpHVBArGlXEF49eqPvK65ZlOgtI4IWy67OCs0NUGrdnpxN7OfVrNvgXxrICI/JNUOq0fpudi22vQv1n4sADzLuocLXqiEQBPVD2rP5zTesrtGE+TRibsoXMfIx1gn4HjX4+ZnmsQRgTvAJhCzvaIkEmQF5e3kIk++DhL1ywYfaBLXNS5xBhmYXGbmZ2CzbPAwQF3yS8XSEFlcRlOVfNOJIcR04IASEk2hjQAGOYQtM6xg4Bagio04vCmpiB5zJeLh05QFW8xrrjMoEp6JyvhJ47kujDdGZ+d7FuI0DI3JtB/0Q+NkgmUviYr7KIFvtUTnbb0nzCcbMHpqxN+szK9LKH/7MExlrrpSNHO2Ws/lw5eFpDrJqwdSvhkRKJGWWuspUSlimyPM6+Edjx8pVtf8arUq+10Kz8b+kGggcIfkV4VD5E3iCd/MzIXRdZVWJl1+p7N/MLmUjRz8FPPfAhKfjJco+ghVrfFYbbosZ/fKxUuSsMo9ZdLMJtg3NsLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a free HWPoison HugeTLB folio is dissolved, it becomes
non-HugeTLB and is released to buddy allocator as a high-order
folio.

Set has_hwpoisoned flags on the high-order folio so that buddy
allocator can tell that it contains certain HWPoison page(s),
and can handle it specially with free_has_hwpoisoned().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/page-flags.h | 2 +-
 mm/memory-failure.c        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..3cd524e04a30 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -879,7 +879,7 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE))
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
  * compound page.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4916ab145325..3d15b4c1b694 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2008,6 +2008,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
 	folio_clear_hwpoison(folio);
+	folio_set_has_hwpoisoned(folio);
 	folio_free_raw_hwp(folio, true);
 }
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


