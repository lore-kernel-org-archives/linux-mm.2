Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C199C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530616B00A6; Wed,  2 Sep 2026 11:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E02D6B00AA; Wed,  2 Sep 2026 11:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6FD6B00AB; Wed,  2 Sep 2026 11:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25C2C6B00A6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:37:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B11504028C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:37:10 +0000 (UTC)
X-FDA: 85169225820.28.56EC799
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADF2A40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:37:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7q4GQL8;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363429;
	b=MyPd3mNq+S5XQLfZIJjBv/2aHnrR9KElFxhS4TIb5qhZ3a5Tu8pkIz0zxUNlXr5ruQtGnb
	Ra5JpTOyt1MkbFzLXLynBbl63va1yjLUx6EyFBjVUPknAgm6EHbIiOdOJoQ+ZNj7sQdVLO
	9RLwDTxVjVjZk4IaWaH/++NTg8Qonok=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7q4GQL8;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YDT7xYE1cCIwsjCMbh5Krgj879TdKL/o0OhLi6/Vxw=;
	b=hFpkTBxwvb4vXKh7RNuLA9WD4UIs99Rop4y70vA9uJ82nDVMLfHeDa5akxLCeLLKEsK6F4
	mLAgvf93SsFTiOIrhKls1mu/7kqS0ZrGgGfOhbjvtYuYFb/uOxIDV9h6TY4O/Aj9KqW/pY
	b/OPSboQLYVptznoKFj0/J/15L+6mww=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=es/Uhjm8/c1u5ug4tjOA3nWWmmojdUXhgoapLjGTZa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363427; v=1; x=1788968227;
 b=a7q4GQL8xiDQwqXLM6Un6pDy1Sd5mVjnfuVQ2Jjcco3TvjqpE3EvWmUDFhI03fxUAhcHFjKt
 XLJgus0CHdSsvQ40iZRg3cRGBSK10pne+6PkfUaOhnRfnHrRAG1LqXfNm8XXUROf+vYgsUjeAjE
 Y1aMXzpvzR3geMDPWxFTC5dQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e468d896e5d8b7d1;
	Wed, 02 Sep 2026 15:37:07 +0000
X-Mizu-Trace-ID: e468d896e5d8b7d1
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:37:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func()
 check
Message-ID: <aphCit_ohMGmCe-2@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADF2A40006
X-Stat-Signature: iud5hitw6omnrue46os8rjnzcfre3ung
X-Rspam-User: 
X-HE-Tag: 1788363428-928082
X-HE-Meta: U2FsdGVkX1+yDswz1K4jM03E4aU1zr6UjeX3MBoXSTnxmh98Gr4GrKx7HWT3Em29LfIxuWgUQFhKprNjkE6rIdMII+GGwrThArChNIcsgtEctXJwHwh3cIiCCJBG7ej+M/7nLCXeYgl1eu+raVz6xoh59NXcQLahw3P+w7B9Yf7JYy/gqbM7BonFlDNEchs4ROAbawXH6Rvpvjn5qtcShi5aY2J6fUzJ116C+RL0g/jIMIOfaeq/4260tpTUtfCMdJhn7mfZqrZ4bIeDfGvpnEkAJBTNulm1rWfXMyTS/ywZ4zFjBAMy+6a2/9zr8vTf10eS0VtoT0VzICEQH98eoLze8f8NIfJSagCCnf2Jn42QPt+MUZIrpNqsJGFdstj2qwtfXLM83bUCPlYdk8g2h6I+VddNymIQtbVcHiSosPfUzafTt8/OJQYVlx0ly3BOamo0Jedpfq7kKafkPiB7ozKRlfBMG5w5DJTmH3wZkwr9gyMISpcCf6s1gtVH/bErTJ5BXZXPpvGpHeX24Ag0EvLg1yL4tDVez1HQWBycN5TDLsLyPg4wb2nyV3l7lcuKf/bL8IuMY2ylhQn+bBDWuHv6vBfSnPJ4+AOgZse9221clbeaV16l9AfFpjFtDpFbK6Af2NJn+wtF7tjJ2iUNRe+kXReNjmFk6xPYlatUU00LF881UvuOkUuNBerOUYzE0QAKulUA8Ci4OgCBU7sFNjEJsXAxb8t6yFezGULMVvjgxE20xt3Or0DM45Jo36bFPaoP0Artv1GTxqxsl70xFJLkMsEOrfdG7xCrHxjExb3yzzj8yD28ny7UaQrlB3zCQQx2XihYLdXwMGGjP4e8S+fEB84wN6mA0gsif2HZ4AUudDwj4n6WXsGPKyp/tSPK1tfefNaKF8qvh1eoRpEUO85MHVdpXJcD4wWXoqBlPGbm3uvo422TF+wJQQMLruBochRqwTXqxSEYNh2hHLQ
 1wTxf1IF
 ovHJ+8swC0ahudlk/NbZBQFii/onwq+kLnzvg1JNfA8cI8ITPFVQyAi73W+G5+Fcu0Fvmx3AaPXSUSYpucq0N5JOBGXd3wom0+Br8YnCHnrPHHHdgM91e/nNXjoH+l1cfvCsgiDh/nfM22bhuyyuw8wdh6ZvSr0c+nMbM3eUIsmm2SMuYMKw7OFGWxdfwqjBzHn7wh9KmTYlKQaDKyPewumiWMsqOmlvTFSETxxgHMPgo3/+XJVbuoK9ksdhZdQ3g4N/E0rO4pK3hzG4CFklB7sXlC2wr9KrI1v6PJrAtPUoUEDFeZP0nHWVbpX8Xt6wud9aHRx0ycTPc8ltt4Jzj0ak8PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:53PM +0800, Kefeng Wang wrote:
> PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
> nfs_release_folio() to not deadlock via kcompactd writeback") so
> nfs_release_folio() could detect kcompactd context and skip
> writeback.  The flag is only consumed by current_is_kcompactd(),
> whose sole caller is nfs_release_folio().
> 
> Replace the flag-based check with kthread_func(current) == kcompactd,
> freeing the 0x00010000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

