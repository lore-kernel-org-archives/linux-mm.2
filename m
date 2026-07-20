Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A11EC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678D26B00AD; Mon, 20 Jul 2026 07:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650A26B00AE; Mon, 20 Jul 2026 07:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B886B00AF; Mon, 20 Jul 2026 07:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7416B00AD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:12:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7D5B16013E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:16 +0000 (UTC)
X-FDA: 85008891072.09.93EB331
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB51C100005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c1Qq1rME;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OFM0nRJoZuBfdWYZNC4phzSZOwI8EnxnT+H9jcsSDNE=;
	b=MRwzg6QD1ylXY0EwQg0SCtc5skdZgF9WAXFZsmBWrm10YuPwnsGeKR/JG740zJ4k5Zg6y4
	f/nJt2nG+JIZFdavz52bkLogdY7Phjh8+Fccm9c/5fet9t/HYPK199tvHOkKpxSLY7qNLe
	HV1XHvyw+Mu5ngWyxenN/Yns52BBLA8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c1Qq1rME;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545935;
	b=v7oDEB/huhESS5bpbkw6FwMTUYcK6z3SMGqHtxjfHhTlrUk+WrttJjXzOg7mU27evTc9Of
	s9sH/1jPeFr2fv1wJqJZvTJ5Pegdp/N/rfQC6GyC5Ao8bG8iai3mINjWW3SqqXIPOoQ+fd
	EaU3E2PfSztdZM+tLDWrDm4cVrJOTDg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784545931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OFM0nRJoZuBfdWYZNC4phzSZOwI8EnxnT+H9jcsSDNE=;
	b=c1Qq1rMEd10vohr4/PTgTRGqNEesFMCi1p/+SWCMF4bHw1asPO0d2YLqSWeDPPiLNUY6XgUeutnZGFR8PCTV0nWlJsldTsxBEBKTiZnF25+EB4ekkqUxVetRze1NZQXxzqW9aDOukMKV43da0zulnysfKl2zqybOpS9NnQBjg24=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7TBAFM_1784545928;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7TBAFM_1784545928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 19:12:09 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] promote mapped executable folios after first usage for MGLRU
Date: Mon, 20 Jul 2026 19:11:59 +0800
Message-ID: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB51C100005
X-Rspam-User: 
X-Stat-Signature: kycnm84o5tdt4cu391z9o8ho888ftaoa
X-Rspamd-Server: rspam04
X-HE-Tag: 1784545933-716009
X-HE-Meta: U2FsdGVkX1+PO+oGYnZgVebHzUksi4axCW2vzdGfqas3dI4Rq8UD92YFJt8ggjbJj96vHAfLCwC31gRapxxbW8theyQ8mSS8PPrWrOCDCatzXcwaD6ft9I3o+uYGcT8YEeFJBj1Ohohm25kHLKhff5HqI+3lYD92gxhze3uDK1PdF/QsdV3fMYm/EcJz/KZM7p/RxImOil4sr2VCIxaRX6wTwJVQJlgyL0twlV1VibmnGjWiajhxJJCHEJyda7Kt0quPhhkt08UYuoTQE9SyQihbd3bP9b0UyUnmCniionZMLBLfKWaJvG2z5tLRcoVeWVOE810UuTj8Mq1zbTE8fQIp0HnnQOS8lXXNGqzXSCkGnNW4M82WV2Spz5te1zxPKrFoPZsQxiCqcDo060QfvwHBaxgv5EA5MPpIADGHoR/K7Q44O9W5gF79WwDxF5h2YJ9qa3hMrjCTJWj3L/C6QJouqvcUHKiDQKzXh1dEXV0yI/TIKo3209Zdq8cnJArlalCW0bXd50kPbDGNaHgFSXZL2Z79NyqqWpqEhK+O5ePLZ2IoNEbao7eSht8MO4kWL2yTRZFoxo4aXaB+ACPsWroqv4g+nJqKXPJYAq6P6BZzeKlw1AdXDxJOJZyPNEAdVohBnbGe5d767dqYn+uci4ZDvvp03kkjTuvLJB2mlWIEdAdCmAs+r5XED5KjeMUKIWyEJsnII/nvYf4MLJVTvXeUBDrZMfWg3sc76qF9Pzo+QumlzFz+yvvlfc7//xSnEZa7enWzS5VKwwSoq4Q7rQV9tszNQ96J/LNv4S4bVBMvIzy4sg7rVoK0pVHnzdB3+gyiKRpnAR6islrDVLd8ti7Om/FlvAT6VWDSsCDsVer3THDsZ29eoiVqAoWHCoFUSe+RuXu3E8waWgKShAYGVaz4SwQ8oWIBpZCTmnx7rtHq8c0TNPijeIV+wN04SIkaClheCfe4hFu1OOA/zCa
 S1LolY+g
 uuziu1uN5/o15Oy2hBPuocJ7Ye76EUv9L/PKE6VS8sDZNZs9+wNLMYhdZt9xg0xlLLVURHZ4rNIJgPIsNU9Q1uexcymjwixjqNusbYg8Xqg2whGEImm2DV8RON+Si8QsNt6ac+xzR5X0ahm3+Hni3AJO41V+kvEzH91V6F2KQCcsQ3y8DiccA9nNl86/Z/VrGkHKO7IqViBl5qvGrwK1k4dohvJourgyRTJzYxiIJMokQkaMvHGCsVqjow1er+C+3TGg5pJ9K44lHE34tSL02RXC9hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now MGLRU's protection of mapped executable file folios is less reliable.
Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage to give executable code a better chance to stay in
memory and improve workload performance (See patch 2 for more details).

Changes from v3:
https://lore.kernel.org/all/cover.1784268206.git.baolin.wang@linux.alibaba.com/
 - Collect tags from Johannes, Axel, Barry and Kairui. Thanks.
 - Split the helper addition out into a separate patch (per Johannes).
 - Set PG_workingset before promoting in lru_gen_set_refs() (per Kairui).
 - Some code cleanups (per Kairui).

Changes from v2:
https://lore.kernel.org/all/cover.1784197559.git.baolin.wang@linux.alibaba.com/
 - Add acked tag from David. Thanks.
 - Rename the exec-file-folio helper and move it into vmscan.c (per David).

Changes from v1:
https://lore.kernel.org/all/4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com/
 - Add a new patch to clean up vma flags as preparation.
 - Add a new helper to check exec file folios (per Kaisui).
 - Promote exec file folios in lru_gen_set_refs (Per Sashiko).

Baolin Wang (3):
  mm: vmscan: convert folio_referenced() to use vma_flags_t
  mm: vmscan: add a helper to identify file-backed executable folios
  mm: mglru: promote mapped executable folios after first usage

 include/linux/rmap.h |  7 +++--
 mm/rmap.c            | 19 +++++++------
 mm/vmscan.c          | 63 ++++++++++++++++++++++++++++----------------
 3 files changed, 54 insertions(+), 35 deletions(-)

-- 
2.47.3


