Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1664F109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835DD6B009D; Wed, 25 Mar 2026 10:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E66D6B009E; Wed, 25 Mar 2026 10:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7238A6B009F; Wed, 25 Mar 2026 10:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 656DF6B009D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:58:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01EBA140955
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:36 +0000 (UTC)
X-FDA: 84584891874.11.A47E1CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57D8C140002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5rpiVQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vccCkJeFSK7lbC8FnMs6QjYD7Tn4R9ZKb39ERuhTdlg=;
	b=24yECryV6/WSlGHoB3CVzYqhSt8INhN46gdwcgyEqgiwWSSy2kRugO/wLl+yK67M+CeUUJ
	mYplECfmCQcpxCYMboQaU642seR7OwStEhsrAzwSkg2l6EvA7LjaZJ9MpBq84Nk2oBrWPo
	YwmSrg1+eW6nWiHUrOWHVbavxr6B0bg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450715; a=rsa-sha256;
	cv=none;
	b=4AGV1w3GG7yHVgYDmP0jmfzOhafdNB4jG1G4MVKvngh34CVRMIfrtg6iAUhEmAqWJtN0rN
	//juQJxNjPW62gRFw2wyAV+KXbKKgBeibw3s+zZoiJnpCq+n1X+qImqzpNvYEzIxjoN+mE
	H0LFb8v9jQ4HK8jFAkorp1/62B0gRaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5rpiVQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE68A600C4;
	Wed, 25 Mar 2026 14:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74791C19423;
	Wed, 25 Mar 2026 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450714;
	bh=5VPo4Xz6qxiaSF1DeT+HopouvLgzZgCEx7q/c9OS0g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5rpiVQazkVl+/Uf4hxeNzefvz1dscY0p6VIOCZRkcRAUdT6xjC9m5Q3ZmGOs4Acz
	 rgB/QXWWqACD01Jo2GbD/bB2b22Qqfo0frdC/+7WnK4KMTyxJ9yMI7FEW74WeUvzeF
	 xkTD3aeoT+NsQ4Dw/5gRXYoG4Qj5gDpN2eQ14GfLPEBb7wr2c3EtUzJHuJe2y+E6Kz
	 lv/5J5M0oqc3PGbyYc5b0zALZ9tDUQOOuPb34HIWwk+zrFSqxirCWzhgJ31pvclFCB
	 wC+UDLBX093gQOuDevYXEvxKT9XJ2DNOekzbo8S4JgX7iW8Dpze/PP75qq+QTuunt0
	 8lEgjq9OAISMg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko status) [PATCH 0/3] mm/damon/core: small cleanups
Date: Wed, 25 Mar 2026 07:58:26 -0700
Message-ID: <20260325145827.88239-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325073800.141756-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57D8C140002
X-Stat-Signature: fxsm5oodnm5ezo4rug1y1w7t1hqwmeq3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774450715-994881
X-HE-Meta: U2FsdGVkX18qkZjchP2zVaDaUBnlJESxJZY+WfFO1mOVVK2NIWCtRj8X+bsPiyeEV2v2Nj7S7WdpxDZciOR3H3FbuzdxHgQ44xXFMnVjH1cxMYYvbM91gJqMyUDQ4nV8lAc9aIht1qfOqfWS+e+o15IvS4UR1H7iq7plmN/fgHxOO/NrgXuAFG+yg0MaZ7RGRBrwGOCnsiuhyQd5e1dZuiW5rfGo5s/cmB1FG2dHrSQdlcyTSn1AB4JvKn+Ng5ViHtBtMDtUSunxCLKw0s5VSaVQtGbC+213UJT1a4U/DcZqe3O7YXnXz5prIcP+FGTT7YuKaE+EB38gtrwErk2y3a2fZOjAIXQ9DhocGULLTzFcqRkf0XeRlhWcHWh1fxjS5zKo8g0icr9DASxwtD9+0Dzm6NZFWH/r3q83DtgXYccH2P7+xpFmEMC7iyZJcrLJnYS3IBRdK4riWb1uhBOCeNMtWbDkpt3+vEvzetwr/n1khNbZMzUKuibidjuAXalm/pqgqqMn9GJV2CP/P0E7kxCei6AexiwNbNxHH1cludsOoKS/H04FYsNLmq0yjPP2FolCr9eMDlAM/kpCUJu62EJmqvhkLmZR5N6dIUj5jeewr3xlJKcoIepMVuQOAebnLK2fDdlAYd1Sp9U44cuN1158yCnEutYShsFWwVAQey+mOB4MwuKOzOLAbsS6oeTyZARfw3eJw+0hsOWWjdxYCHecSL1SIlgjh3VpmwfD4Ew8JecjE0rPPDjUgy2a6gjLqXcu6jLH5mlbrj7/slCq1yDsYMqEJlb6s8SGYMi+OSCzggUKHMQbFq5cLFgQElk2b9mpG/jTZ13+WA3RouuytgpnRCBDvW7Xcw/RERgAb0VzQevpqB2JVlZdgg34hQpBs34cdnPwJDF0TEPoZoEfGKdWTt5olyoMv/FGiFzVTaeVCodzXjImxFEfXzA6IQyxuN7UW7w4FAMcN/mkUyk
 buWXdAgm
 TwrHPYYrw4+aFhmYrcqXKsorKhztqbz9tCinwi6qOmMm95D8hdFGlCPybVVcN76PlgjfJAa8rsL+Qolr92E+w4QNxag76NxlS6QVUxqvWY6nxoLVOIMMMcDoZARp2SZJ2NT7St72U/L5sAnVelwtUYXl5KxV3ED8amE+aN0jfFAYNa4pYEPPFvbW4Z6PzhJep7D2jhsq7pGKrPFuoXOBl9A/3Ot4/v57Bk0L0afmFZembqxpX2pfgMZYJHyz9WgFi3ql4JYKbt2SYlxnfPbDj7Gh67dXiHz+9cEECsuIGbPtEXlxz8jlV1mIugFfQSl2ZC4hHlAHxk9acIyjdMmRkm3fZOYFvgipHlinu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260325073800.141756-1-objecting@objecting.org

- [PATCH 1/3] mm/damon/core: deduplicate scheme index lookup into helper
  - status: Reviewed
  - review: No issues found.
- [PATCH 2/3] mm/damon/core: use damon_nr_regions() in damon_commit_target_regions()
  - status: Reviewed
  - review: No issues found.
- [PATCH 3/3] mm/damon/core: move last_nr_regions from static local to damon_ctx
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260325073800.141756-1-objecting@objecting.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

