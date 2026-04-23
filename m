Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDD9FDEE25
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB786B0092; Thu, 23 Apr 2026 12:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75BE76B0093; Thu, 23 Apr 2026 12:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699606B0095; Thu, 23 Apr 2026 12:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1EB6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:43:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB08B1C03CA
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:41 +0000 (UTC)
X-FDA: 84690391842.25.AD24547
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 280A72000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYr8+U3K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIxrK91kn1M62e09nSfgNnwvs2jLd9c5g2/Rq/zkfec=;
	b=Has1L0t74VvAmtaGla6kp2G3F3zYdiZLyWL+WREFCPGY01lQlXJg559xchuBYVCsioklKq
	mOaeswHTYFRgRANFal/jRHpbcd4u7hDbpWgnaUchF1rDFkDfSNwuaXq7jGpDTqzBD3m0Dr
	W8qQl62Pvgo/+LGDfja107Y+hIBNnVo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYr8+U3K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776962620; a=rsa-sha256;
	cv=none;
	b=z84iA9HfQxD+27izLI5LU1pc86eGVA+2yeQoCTjGnDFiakdOlZ5AEUVnCM3JMLXNkSKVQh
	WV/0aEs52IhUF3ql2bycpGlQJJXzgsWINL+jyONbISgXj8qsUXGYrBRZIoG+RrUKh4Vtqu
	670QevsYMIjjkcHoU7u5rNLqVaEnLrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CF38443CC;
	Thu, 23 Apr 2026 16:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584EEC2BCAF;
	Thu, 23 Apr 2026 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776962619;
	bh=BwX/3pz1cBY/YrLGL/Zo60/ngbnFP6zgwqIPvFvoGGA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EYr8+U3KRMCF79F5UJRyc/iM2l4R6pBlqGkgAL/TgiLlvt2I/GBOWctUKN4vvoKUQ
	 20uncwssyv/1v+MgottmrjGc7OQ7VYWOwApxZZKxQRcDwOA1hpB7cVCo3Ccgj/2ZH+
	 HB4TqU6NfC3dNwCJncXHzB8DFqDbjJfkcDeS6JV2+8jahGtkytLctJTvwtbIM0oe5m
	 43gvqdjL5+aSYdmobsArVRnmW0imGK2oaQZizpMukjdUQR6HbFtDyGU2NlhbM9MUTq
	 yYaolstMkAnYknKvQxdq9YyPI9L+i3b5KP3BmjdQHGkGnJJwLyyf1O6lOuboWEfArn
	 uCjLN0/dyIVeA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <jackmanb@google.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 3/3] selftests: kho: test with deferred struct page init
In-Reply-To: <20260423122538.140993-4-mclapinski@google.com> (Michal
	Clapinski's message of "Thu, 23 Apr 2026 14:25:38 +0200")
References: <20260423122538.140993-1-mclapinski@google.com>
	<20260423122538.140993-4-mclapinski@google.com>
Date: Thu, 23 Apr 2026 18:43:34 +0200
Message-ID: <2vxzik9h630p.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 280A72000E
X-Stat-Signature: 1k484y6b8mzsfbt5nj4uxwu7wc15d3eg
X-HE-Tag: 1776962619-919456
X-HE-Meta: U2FsdGVkX1+Yn+IDFqcLUYl7kpLb2hMb+ZrbYepAm8MKgZanmvrlPaVNIvoJsXv2z0g4XpIj7JlwCs2JsKezXKXEy4SNiVJSnIHE2XgI4dmxjNXV3hgcDYkCDbngr+43KQ1rx0q539Pi2VGC6qB/TJlq1t6EBNciPri7Ab5jT/c/WK9wN1rjuMjtJps1+gB+LspmZuBL5/TqL/9NNVh24/1PnX9WLFVEoCiiQNO01gMp79y5nfVrY1nCM5HS2eSu4IYYqDDJijw9v/FJZWrGvWQIHTKevv1d5kukmxH+FNULjc+Q08Cq2aV7xq4R7Wr5gKlk0gMbKCwt9sARGORlzyCfBg6/TJHtrRtix5cnVc89/qTfXXeS/h4W4K8xiTp4uRmxkExyQGKrAO4sLZ200kh0mGlVgCpVlkqh+rniOg7c0JZKY9cQwd6yKpcHUS0Ii4ablpRp4WR9bELp/nxjrJXtc9T+CXbbwqrqYxZgvwViRtZ1OG4hZt4A40W9JzPv1eueF2FszGgIUps9HH4dQpCTx7rNrVcfq6QugXSKec/jBhVpqmtdk9SVVaTcxLJaSpxverYmMZk0ZT0prxXakx4QFgvXxW/HUv7m+Vu4XspLvsWz1WWXV1NY04rceQI47Dbnt1Eze8FrN26y5WPicdKkt2Mih/CpqZgidFdMJNV2KAwjSDSwTVglPCw9sI6RbsUQ0GwTlDAu4QMaMxcaKW+RKUkQoBhN2ACHKECdey9KHPTXTruLQTdsUsgfDL1zgMtpvcE4C2biQUNfIr+VPN/MmD26c59mqwtzR6KxPv0L6x4EaIZwWTM4F7NHpXPiL0zYE/mSQGTvYYAKHttgS04CHmqlDeFIrfG8IGv1h2gUGEfM0XFDe1BEpSXyqNuj7SULv4o35eWprXtfhlZBS/4pYOC1gnP4uz27QLrQIqhvQDbmDFoyWfHX7BpxbAiZHF0IBDdZPTPxWNFkmXz
 5G7c5kGD
 30rDZlH5NNQVIX6v84+DDQQuryeqbJCVI16u+Bd3hfO4DvKxCnM2b6AUnVny6VN9nlLnYgpBcnt3IdYmGqurqXPpiQX+X+1HVUm3pRRk9kt+eMgdviBRowvvzOfPh81EjZ01ftfPhm46sDvG1gs6ocnrUN/suynMOqB7iPdL5eTnEcrMqPWvZ0P/jnx5RmsYWZ1QmdoVy/X8P6sFjmgu1QWR54gPQ2K/V9ogB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23 2026, Michal Clapinski wrote:

> Enable DEFERRED_STRUCT_PAGE_INIT which depends on SMP.
> Also enable additional debugging options.
>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

