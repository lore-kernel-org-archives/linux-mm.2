Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3621606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=amFQq4lX
Received: by kanga.kvack.org (Postfix)
	id B56B76B06DB; Tue, 27 Oct 2026 08:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E836B06DD; Tue, 27 Oct 2026 08:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44A66B06DE; Tue, 27 Oct 2026 08:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E3E6B06DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:09:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19203A86F8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:09:13 +0000 (UTC)
X-FDA: 85368285786.03.E1DA673
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 566A5A0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:09:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=amFQq4lX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793102949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVLS0bNhd33XdBKUQzjPQnNldzAdOSb/v4EXvCbIPzY=;
	b=1YmS2bvgN/hqG34cEbtaI6Ie0GaNoDo5adjaULn5ylNdAM1EzdqsM60UIk279WRhdpVGfu
	Tz2uUKoZD3L+kzbeGPYWS5AvgSgqBxaenP0GLRGADoA3hMjqSOD8EbhvGOnnlNlM4dEqic
	K2flyVfEPr/1Wy+Zmazakrm2LUaoBAs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=amFQq4lX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793102949;
	b=7It0sM0Zqlfe3c9hsIrVaGB2euAjckNaKE+VlEp8EsfUSEau2rr8b+Ee5VJevPjqmhpcbK
	FICQV6EsJlnZlNOhIclQybaoHOyFaqhMujSRlmKjFWcN09ZZtRVzu3AGTXoLndbKQ3RUBH
	izwFNQ2qEx2UQNfN71JLyK+0n3fJ5/k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793102943; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=oVLS0bNhd33XdBKUQzjPQnNldzAdOSb/v4EXvCbIPzY=;
	b=amFQq4lX2ws0xXOllDiVhqyF0nqBdI+G9CeRTaPBWP3c830SJ6i7obKEVtHSKBj8u2cXpf6+b493LwANkGNWWcEpND4skqE7wEwNipBCN5MTT3N6On/6ASZwcYXnBagqHmKp6MGQr3pAwvsXqhRtn4m6cN71TJD1k+oFBBw6sv8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDdhbck_1793102934;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDdhbck_1793102934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 20:09:02 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH v2 0/2] mm: don't migrate folios containing hwpoisoned pages
Date: Tue, 27 Oct 2026 20:08:54 +0800
Message-ID: <20261027120854.1213156-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <18602383-2326-4e54-8dec-bb695ae8878e@kernel.org>
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com> <18602383-2326-4e54-8dec-bb695ae8878e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 566A5A0003
X-Stat-Signature: y4rgqonchptoex8whu5bdf19cmi8xnef
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793102946-861059
X-HE-Meta: U2FsdGVkX18DJ6bG6xHjG8gN+PbWuIRjKF78hewMG6VMyT6UmDHqSyB2gOsl50tyiQWPjAPhuiTzDlc3T0EPoNULX6f3KmV8eYLx6lP9fxxrjJ/k4wiBUG9G1COUYSSpXeNIavtfOAm0Kn50BgzVWUXJs6tV3nQ/T4wWMYXPmy1G3I3/PtTsc3525DZ6SCAJkhiWZPWnA640a7xFwYIJi3dBhhnaX6ucw1reV9llwnCWo0SyUgQZZcff7k1M+rGipNVO/meeBpW+2bTZRz7PyJ6lgXzIWFYaX7HYZaqeX+JvHh70K5iPnOFBEH/3gPSTu/RehLEcgNE5n81hSlaD10ytmBz6mEGSY3AgA4o7Ih/pDYxCUOMjTktThn4lXeTsxr6N2hlNVR1Ktwju+Eexe5hQm6mD1/km+GuZFvJrrQSs2UfXVJgU5oZlkEsN99iMhnQQrNUWACpZ//+/JIMwa+DhviIIDt0yogoU4z0Lj/LTvWLW+prgbQarE6ykA7jljkrB5WlRYABmiNakK+yYrRLLD5IlouNCR1yABro3cTXeYszIafCGxmN8pgRbOT/YOJoaGquYov8KYxutkbalN3lrqRaU14w6i5ikhRbJLzHWWMIWH+cjhT8L6uL4t01d7znU/DsgblfIBbiVmrIlLkYQdD42EW4oc7xY9f0IwjwObJavse3+rkQW5dNTiLOtNV4dPoDK8VMDe9jvfv5D6LiBYpsnmQYdISlzYptYWbytGbAyFw10y5eyhQB+B5xsPIKfKYLQPqBGcYpPM4WQBFOt3raLQWvxU8XibnIRZ1qksJJXiAIbXMNll7s8AMAVehDEyrio3dsW0A70jaXponXwSO4UNNhgwGJ+t5jLRClgpaoktavofT26bfpFN5lkAqIBZj5sf2kMek9erWSWx0Y2iBkScIr0nVpn0LiGC2ztT0ij1WSkl4EPZQhsBI9+C9QsOt5xlZj/gF2g3eB
 lwBN8yp5
 Bs69mor5xWHp3dU9j7JS4SpfCeJO0c62GOznhnhwjE92okNFJQENIcgqNJtZ28Ij/BwGzGuFHPnYfkPfTqnaQpX27beODt16XxssyK83fjowW7VsTUxqMPqLctlmNgeh4uEXxEzZqBmoJcI0xn2pJpuNf0NkDFjf6ZPUpEg6KoLv4TIDEJDeiKoM6ZlS6KrBRfqUSKrMdyI4mF0LvaisxQAPStK27+4/fXPagEjnp598Doce9GIX/R3g23KQ7+x+CDlSNZ59RrfHkiMAtwZzYLLZ548DDHMucCQj5xQbGcFkop8K9pl/y4Bt6Xv5l0Ntzt/GJuZ5OFEE8phWbrMNYZfoWWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fallback check does not compile on x86_64.  There,
folio_mc_copy() only catches a synchronous #MC at the copy, and
software-injected poison never triggers one.  The bug was reproduced
and measured on x86_64, so I think the series is still needed on the
arch it was found on.

-- 
Yuanhe

