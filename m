Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FD0FED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B386B00A0; Fri, 24 Apr 2026 09:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33036B00A2; Fri, 24 Apr 2026 09:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70156B00A6; Fri, 24 Apr 2026 09:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98E696B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:36:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A20D140131
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:36:41 +0000 (UTC)
X-FDA: 84693549402.03.9D4D0F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 788D310000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:36:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GUfpMeUn;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nKe1p9G6yyTeCAUMmepn40BY9jO+hRDTnJGyyeG8P0=;
	b=a4+p+bh1UNPVrvO2+2aXwvQsPpRKjVNBsPAxb1tiAcR27DnS3JaVNIl86ZTIFueY7heeQ2
	9RNu4Lh8a7KHmixr5l3bSvfL/50V+XJY8e2wLwBRdgeoFOF4d73oYNOsocD9yPZcsOJkM5
	xNncXzAaNOPT2xmmriG797sjE+mtiHE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GUfpMeUn;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037799; a=rsa-sha256;
	cv=none;
	b=p0arDfSJnEUf2oPO3idR6mV6ERHXT1DmRNbq+cFcoKddeC51DdApyry22Tavf+oeNOYePp
	Uoi3AtbnOl/ojAOwKo7zr8osiq0tcZMTdbdh+6mYxhxLzWPmjhg/ZcHlEI6j9QA6GUx9gV
	051HJpVA+5xkmh171ZV4k+tMf9GJE+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4460F442BF;
	Fri, 24 Apr 2026 13:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689ECC19425;
	Fri, 24 Apr 2026 13:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037798;
	bh=myF9le/R6pGmIw8tiyhwd1Iy7g2x5mMlZx8UkRi5O80=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GUfpMeUnr2ggotIvQlkhMrquftqxygXwYRjitm1e5SI2yhyg5pwIRRwCwlACzWbe0
	 uPacpiPJ9LT9BZutRSnszT0MvL5OnXW4ufvARGO168Fyeq1UNTNe5HB2THUyLF4mvC
	 i3MnNmnsOinvlAMAb8+cacfVh1MW5E5qoQ6IINGA=
Date: Fri, 24 Apr 2026 06:36:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song
 <baohua@kernel.org>, David Stevens <stevensd@google.com>, Chen Ridong
 <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, Yafang Shao
 <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, Zicheng Wang
 <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, Suren
 Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, Qi Zheng
 <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-Id: <20260424063636.539c202e4d1326088843a0f2@linux-foundation.org>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 788D310000B
X-Stat-Signature: a4yh1haas7nc1czgdr3xfk88gmc9xrij
X-Rspam-User: 
X-HE-Tag: 1777037799-345359
X-HE-Meta: U2FsdGVkX19PJC+5povNoU2zd2Gg3qNexFRFRtINwChypcuSza/hrgGamse/hOX9gyLr6rsuOgexy5FfawIulaKHZw8CoFrHkMfX1cLReDl8Xp1c1IKafdo4Hvnz6XEW2lrhJ7CBYy6CdEAS3SIEpwg1MxqyEAJ34Lfq7Bjw60pLjPUIaVdfoUN8fpIgoU7tbGm46hw2UgwrSwieh1686vL9WwQEqljprmdgFJRlK+pGaPtUCB8l1lwcfbZLeyBVGIgt97diQIzxdzLRbaRTmK0o4mDGUjU6MrmccffidWzYlwkgQI47uHhLBpyrSRUcUr0e4oFlEuf7BCjGFJ22Bexdj2nSEq5aflciCKFGqIDfIeKkM0AkxWH2TJioKIWBYqdIO9M/o11VQQwqqVKJyGjCwb5QDbM73V6qpxxJPIG9CMPWVAmzW5AcDVmO85INQeFk6wWX6qzU8TQtXuT562qRmgv6en+NnI47fVwWHaPoQ1gXOAuE2/BzV3GHucoihcBZFFJu6DQf4w4wQMb89NHQERYHxMEIo0HccYJkJK1Y3OaSOoK9Fc/Ed9w7nG1tHn8r9LZmUew3TMaKWJPHn7my1vYr7awB8HCFHEMHslsSoka6Q+hlJwIBwX09uguuHW+2cWdoK7GBqmroHwWG5tl4AlRsta6kSzNKvmcRsvpLGwv1A8n8Y++DCjmS7Kd1wXpE+6uI+rhWn8JgPAvzSm/caGYaIiaqRljng3Ii7ZfT3LkbukCSy2Lr8RNPB49EkVThWPnk7kHZAikGuPJNjb6dJcSK60mRHcwuD0wu6kQ1mBXkjxY5c9PhPae9W+f5EV2pYS/hSFQVIRw5N3mknWtwHzQsZA3E4tqZt9ktbIf53IuWDN1dDV3gmKoAJjeUN719jt2BhinEAz/9/ThSilpAEA+9ufgSAb2po6oIUR95zLV5BTH0r/e665MdqCogfl3N2fz3404u07d4vSm
 J/Ll4pk2
 z4Mr1NP7WMkj5lDBzwst3KEYHXul74W5FECLj5zx6zIx1Wpq29sTrl7zm44DGw2avShp0COiPfm4Lxx+LynqoMB0N/T7exp9IqVZLLDuvca+mGRPViVKFosJ0kgt+Lg3JePmbjhyYsEdxjVSmDxbgZQelqFHE8sigqrbV4b/LQKTbW4+sPCIrgQLxnjnK5Wvhz53jB4c4dESQDmnILGRrxW1LE7pyW5i91RR5tBlqCR0daJiNbLNY0hkCJhA7+aFOo426AbAvhwsfjyCxQdGz5euBpKg1wYoaErOPHqBMgugrIKCIpzgCNd9juh2pQ2kweiiTK/9jVGRuV210+gTDF2WXcedSoJgz8pFwaD0/BZeNVdplGfm+BN+EfnS00OXnyOu24FPA11QEr3OuF8JDnt9J5t22bIakdTdt+zYrHQ/t9haEQRYHA6VF7pX7ETv0N/GQSUfFCcTegLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 01:43:11 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.

Sashiko:
	https://sashiko.dev/#/patchset/20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com

