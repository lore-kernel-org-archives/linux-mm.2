Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA95CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA7C6B00C2; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEF16B00C3; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DF66B00C4; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAC506B00C2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7E721C1A57
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
X-FDA: 84791673162.10.2EA6DA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1700520008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOgQlyu0;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	b=NBJCmLFGp68270JS07l/wyJI2jTLHMrBZMr0gtssgh/Cwa/vL3OfO8TsD3NzLipIiyWZ9k
	4G+9buEVvNsv5TLDBcgkHLlF2Bu70ThtcI0YdMkHdBiIQNCKWjpOP3lo4OCVNqywNER10J
	66Ozhz3inzjv7CYfSRXcOK9wC/MvieU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOgQlyu0;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374080; a=rsa-sha256;
	cv=none;
	b=7wrXvOmVRRDIkZhV82VYt6dtG4Tr8sCGaRxPlUAhPNuDkYucF3oy2LDLhXuA1dhNDdbeZE
	BpqP9cqcL56CWBY/GDPvAcZ1E1T9G2qqR20y+rGToemneDeCe2gy5u/WINtJiH+0RbYSCd
	MpL45k7b6SidP4jR1uhHpYiyItXB98U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CF86439CB;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1902C1F00ADE;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374079;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOgQlyu0BYsrKxDGlx0PvO7DdBjbvN7CW5DtqEpZxMUx2Gcdtqam12jT6ss4J0h1C
	 y+R0+IWciA5VKq9J9KKjc0DwF2nzueOQhyBWFK7hqYBgy6ezzPOvvnFle30C7lkEoa
	 lEoZPAZFl+V5dSxi33GHp9x3NMsj76wu1qXq4t3oh6r5pHRpznDfPy+Bq09lYzd8cQ
	 bWEnmKmOn+lIY3dtRmU/g/jopxQUMyxiWkmSTu7x8nVoLmuup+GRvb5z8FYImMKHKk
	 Fi+QGPU4BNnF7VaXbzeTdRUyL7uLfCSPhnElHpOU6zEx+HqQ2kQG5jZlpwMnhDqpvW
	 u0YLb3ENq/SCw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 05/14] mm/damon/core: hide damon_add_region()
Date: Thu, 21 May 2026 07:34:15 -0700
Message-ID: <20260521143428.83157-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1700520008
X-Rspam-User: 
X-Stat-Signature: htem56ctftnr1depadhxege3shnuoyei
X-HE-Tag: 1779374079-725480
X-HE-Meta: U2FsdGVkX18HWp5v1R0MTVhm5Qh4SAqfEP24CnEHoCbixojU5yYwyMUKY9CElyAZwwRWLrTFIibQjilriexiX5hcjjESI0bOQ6DdFmmQp28bkS1PelpDCgRayQr6etb1ibcqwULPFMnfU11Exfmmw11iv8wQcIUeotYgUu4dkdKtCuG9inVt/+KeZk118xhzCRzTLCLnh++JS8Lya5G+tdiKk32Y09A2nSN2WwGDG+lVtEcwxRX8Nk5UAfm2DK/wEiQojtx6cikWEh+F6t+4fbKycmlpO2gZhohegloJajCyK1LDtkko5q2W5TvmpzuXXp/C2iMOz+G1NjFcCs8Ow9TSepdgZBgmuB+uVCx+bXBka5XEAefOFyghyZ1cQI6NRaLhPXJtJFbhpZdZlvB//vd30xCFONo67FPWKJ/XmLivzKElhtcuU8DIqA/N26oLWvvyedaSgWpHdKOY1J/l9mcEs4RAdwtbSCn7TWSQxcmnl8KfxmNGxd0fvrGaWbrLA+FjPvG6kjrcooGlvlY96c/pSXIao9e3jMAdiNhRuTN1AxgftOF8FT4JwFT4N3QhDt5ddyDzcK/7kWpULMlk4ws3O65oxQ9Oalz33XiOQqjhnx8+EO10SV2J9IMZD+9yU39GtkHkaUsEbZQPBama9mDzJ8xt30vknxTnQ3hV/v0HMngDdKPes1fys/SQpjGb5tCVxhyTEy13Krtdu4gCCqzhyuucuWSc+Ei3zLuJfkpm8DgNpK4e7ZDgZPdbCQNWKRnfEd5BKuYL3fMwq0dGmkf45OvYrvPAunK71K3XePD2daftmy4ni5nZ00BJaOwXIsIGbsNX2cJg/YSrmo444FVu5f1QGqxkrXheV84OsEXwZiU/2YdLijz7Q+SPr1973aS/uk8BrdOrXbKfTPQUftpJxX7x6buWxg2GcJ2lpcI5gkdQLKIvlSOtrN8CmJ+FwRLyfZuxXjmqp5nw88K
 bPGGyicX
 9Iqf1Rr73XreyH3IOAvcdUWs3O42k3CvcHGydpk1Fp4ScF8HOAy/BnrNRWlDM/Vr+YEtHPjAmKCCKycm57+RtlgsT+lzkUAeuyR/Ab1jv2IN+HwpFX/tGsmtfDpvbSg/xO04jLn81CuAtJXacyprXtlkpV+SxC+ACHXCHR2a8vZUJ5EfSe1RPRzxE36NKs00qghu35Py/T12/9JAA06/i5ukOt7GmAlMQEzsdFZgdsAewOxvBbfLcB2sx45XIWyLjTuxXJX+At3S+X9i2DHsKiyLMIMsBG/WxO86Wnzz0Iq216n8RsZPxlGBn3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_add_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4014fd0d463cb..b9370c1779cba 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1024,7 +1024,6 @@ static inline void damon_insert_region(struct damon_region *r,
 	t->nr_regions++;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8cf3632115e5..7d1de6ff54eba 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -250,7 +250,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	return region;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t)
+static void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
 	t->nr_regions++;
-- 
2.47.3

