Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA8D606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Bivh2x29
Received: by kanga.kvack.org (Postfix)
	id 1E5456B05BF; Tue, 10 Nov 2026 17:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC346B05C0; Tue, 10 Nov 2026 17:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D26F6B05C1; Tue, 10 Nov 2026 17:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD3B96B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:00:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 690AD160151
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:00:56 +0000 (UTC)
X-FDA: 85420580112.29.2453262
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10B4B12000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:00:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Bivh2x29;
	spf=pass (imf29.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vv7dNVzIrUILO8od8syEGQggxT4QfI/iKHG9PeOeLsw=;
	b=SgME3eVKdNqk5bg/aN32WM5Bzvo4kjJ1zSIhs2ZfZ/HPthRtyYOZdlJ9aay8fxCzJfiVgC
	ox6sO3hbQm0/UsvDRZYvNIpsAu5CFiSEG5Xflya5HX49qQBx7N3QnQT7zUZB4iJiok1XJx
	A1Gnp15ozvv629FTfgzH7DbnAin/nCU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Bivh2x29;
	spf=pass (imf29.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348054;
	b=u9qkNuYKvPUSIfEevXH1hZqDqGls6nW0+HiNapSuIIqfhhYpUiJnjdDC41FIBg7y0vy70m
	PMMfiFFiFkPMC4X50oqnU5Kobk7/cmMkwI+eB7/Lqkiqi7nMgMbN2tvbF8qN4yBy7jE9xj
	DFTIgzdd3zH+FHBVULfLXgAiCkcd3g4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794348054; x=1825884054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vv7dNVzIrUILO8od8syEGQggxT4QfI/iKHG9PeOeLsw=;
  b=Bivh2x29KBte+O8TffY3qLG0OnCD0wO0X7SB6lKSd0znswtGqxn6OGup
   LrrsPKkB5RrYJYFlU+TjIDlXRVKc01NFZn3Sf6VD413Lyo58lnpmn3vD2
   q/j5ivNKMB3EUFfrLDvNf3ZAY+3LOUPqG39Fr/qoZL2KIk8WbvcbthJJX
   zsuKzXviM2DmgE/8cZu6UkONd1mloIMHCTIsh6On2QXKNlprIkH8XLLzc
   49AGqo0TH5S7X9646uMvAOGqX+i5nVq+qrXv8VXd3QQg6pTZcrVv0V5Dx
   O9P9XG9ygqujyx2+3oBP22RJwtd5Jsrq9h9IilIqOieJKOJC08aBGKguJ
   A==;
X-CSE-ConnectionGUID: IdC9D2Z7Ra6h0t7Z84UEHw==
X-CSE-MsgGUID: 132yf6aPRSi14wuzQIGaSw==
X-IronPort-AV: E=Sophos;i="6.27,206,1787011200"; 
   d="scan'208";a="33576604"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 22:00:52 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:10595]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id a47f0fa5-7764-4648-99ce-99640a84f1d6; Tue, 10 Nov 2026 22:00:52 +0000 (UTC)
X-Farcaster-Flow-ID: a47f0fa5-7764-4648-99ce-99640a84f1d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:00:52 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:00:51 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, "Mark
 Bundschuh" <mkbund@amazon.com>
Subject: [PATCH v3 6.12 0/2] mm: replace free hugepage folios after migration
Date: Tue, 10 Nov 2026 22:00:04 +0000
Message-ID: <20261110220006.3259056-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
References: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: trgh33ur74p3497qqqh3dog6zs7oio58
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 10B4B12000C
X-HE-Tag: 1794348053-168989
X-HE-Meta: U2FsdGVkX1+Z6GN7JcMXa0yX0KwCl+DSY2MHYMeuK8IVwmBj1v2K8Dpsa11ocpR0SZCXPoeTazQSXTrdbO6ncDLaZ+4Y7HdGRtfIdspResmO0BeYewUNDEN0JYoCjTC3VAhZ+XINxNbblsasFvi5N5KczJcTOymT+6sfLVFofeUzvcAsm1OVThVr4T/xZ/KmjcywdZf6901GAllw/6LLNDy0QA5LUILmsGDgTuXdhLtkogsHxMjiR96iuBk/bGi9kJ5AeM9/2RCf7X7t2hAV88NPtrGlgxJavzcQ6jR4lDPbsRVltCB5dHTWupjO49dUsl/kJZHeMV7zNAkDpF9SHD6oJcXhuCFfeQRi4TJDXC8rOyFdFhP2JvU7hDUVBmPB9DuikFWsG8n4V3l5YFxF47nkEeEEfLBNG/UL1nJNtZuYiSvek318AvML5t4kWNmooFo7M40XalXHTHAAbW20PlQkOiJE6cF7jPm4qg/Axxav07AjNPsKPzuyusrDMRj0CCNkeB1XNfBpHghv/KmMXGBFFqCp8AZtuhJ7Yvq3M9JqVK6aEdYlrzEeqxd9JLucA7YT7yL5N5g/0zs8G3oQ0U0IGcaqFEkNj9259kTiiIr/YL/7gz/WWAEMa5s9p3m4acCat/0T7RRBA6uEFW/IvnJjJ14bwDO/9iLh3WqyaoqrI+Z6VopFk4UKGelk7dMd9xoGvzCU7PjGtEQnEc+YPQ6JBlW2Fx5KTAYv+O6VyVl3kdF0L8/55tKiYGzLK74k5ASUWb0eO4Q0UxPyRbj4Zb57sHZSguZnfOdT2o/kgjlG8gBMmefQZs7jXJQCbtf+e2zR42Mbnf1o8RX6YGZvuZGbNmlbMwGbvcyh2AZcZJ6RQEmJR4VL48b8EiASLLxY6ElMcvT+UwX7vue1y4AQkSqWmgun+flUJDoi25kgRACDATi2pnqwCNZwV7zqsULFzMCMoIwM7Cp7pL90AQU
 cL3vfhVf
 lZgl7Mr1KVZmO22WSEeZjR5I7MqnDFGWuHphP8dDVBJnoheNIwqGEY98hdOap7K7LPEyocttGjSHmenc6TJrF84gTgCXs51k/tZxaOFF9gZaeV4uGx3SxSLXi43N1ZX6zpaa18cBx/X72dNJWyYz6+8drll4WtrlFy/gu7DUvCewSGffM9Isr150XYd0TMzESnD8FQlcdiaytQRd+4hLV99j1aZ1MgwyGo/XKOBE84QG44iZmloNCgagiFz6wlHjDe1it+7eNN6ho5lqL837MKs9mZngBWipMMQSM/2RCSGyNqI7tNjxZMDo/+YNgO05/a7fAidD8jeWvGHmpt8lcxVZK9T2Az9aC6k8ucs97/PIrw2yQ4pe/ei3pPP8ZmomKOu6Ycd4hu0fqfhwD8mLl0jcdlLd/BMzwK5zgEDAs54DKrIpSVcOjNnCKMeNfh75rrhjB17/AiUchaAwshtzES5JBmMjMbCVVCZFySKLb2Ug32Vrd64IT6GO1r/mo/CXzfnVlBBSDqrpW/pTaAL1fYRbZRImyk3cjZWxUoX/iA71JQD0d3iBzh0LXC8zyHBcEu6Cqp8E4X6d9i6GWqmJita6Y7mAaAqk+7Satm2y3ik4SNDtKS5MgaIg/Jcb8KsTOxVj9NLPVdftwI6viXg1bv8Mw/wYsKEFzHVKtPPIB6WXhUbnu9DGl4GlIGpN1OTbHaYu+dtaUuwbjX1MQ8J/qKbN9/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Full backport of 04f13d241b8b ("mm: replace free hugepage folios after
migration") with its fix 113ed54ad276.

v3: rebase on the current 6.12 queue (Sasha)
v2: https://lore.kernel.org/all/20261106220835.2878368-1-mkbund@amazon.com/

Ge Yang (1):
  mm/hugetlb: fix kernel NULL pointer dereference when replacing free
    hugetlb folios

yangge (1):
  mm: replace free hugepage folios after migration

 include/linux/hugetlb.h |  7 ++++++
 mm/hugetlb.c            | 50 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.50.1


