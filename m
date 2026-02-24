Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 986ABF3C991
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65886B0088; Tue, 24 Feb 2026 10:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33BD6B008A; Tue, 24 Feb 2026 10:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D176B008C; Tue, 24 Feb 2026 10:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2BA56B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:31:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AE071A014D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:31:55 +0000 (UTC)
X-FDA: 84479740590.22.59F0499
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 879F5C000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:31:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vL1rEGrX;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFKo780qs0EUB9bRLvonMSwiu65xGSRZnYQNeRwVQ+c=;
	b=5qX5ipgK5kGjaiYfTWM75CZt9x6cC3BrhJWH35WM4sFHv+1Hn8Wwl5mh0Q4SxqVydeg7t1
	wzAdbCt+MLlCFsJ2qmH+/TiUChteoQAmBkUflpWDp7aihpbp9u7OnccE98DSiupd1M0KOa
	Md77JxK3aoOLRBRzWqTXhXmdUH641nE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vL1rEGrX;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947113; a=rsa-sha256;
	cv=none;
	b=8UTwlNrg2QlHX9MLeVMPe4VH27Fm6XN3wKggtbpB3UIipAxUHJCdI8iOm0t7HG0JygBEhh
	tyzFWWhtO/Tmpni1f/D5K+/E1+bdL9AxvWEFqfxyNvV+dTbQ0uOCSdFAGquG7pQVzuKf0b
	wjoQhpDAdBYXVXicRUn7te9dXvA3siE=
Date: Tue, 24 Feb 2026 07:31:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771947111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFKo780qs0EUB9bRLvonMSwiu65xGSRZnYQNeRwVQ+c=;
	b=vL1rEGrXa9Myw8/HPFx/0GWaMW0jnmY7CINV9eDB0HBdF+O2vNvrBvO7JZ9MYx4BEdLykV
	A97CFgvourUTvWTjgLUcEBGrWmdY88Q+9cVdiAY5NIPOmcHakWCPNIkoOQKP/8NXB9A4oR
	gq0GamR12heBrnajYvl0hVLxhJJFvZ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: introduce zone lock wrappers
Message-ID: <aZ3EQRZ1XRLsGlzX@linux.dev>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 879F5C000B
X-Stat-Signature: rrsqoypkmx889mqzehe17et8fi3mp5i7
X-HE-Tag: 1771947113-411981
X-HE-Meta: U2FsdGVkX1/i7Hw/a4elKs7CLCE2PXCDhKDm8uxJl4ccarvbuJliuZl4FWXEewxEIz+4MvT1bvjJNIXI7/pH0TL60+fd0iuZ8t4p1l3ZqwbJjgp+8pcXaHzJdm67jN/JsNJPaM+aV7wC+iLd1KxYkHP2AxELkMUZaz+3PjZlBuiJoUxttEejAFKrZxkdjK8fV4ahgdHlhF7liEub0fTnK1icwWK8aXq7zRA/7cZ8zQ076CLwwep20E1UfYm9q+uQYyUTaa0XF0Smbzwzm00YQEnFvEGOeTCwbBLJmlTjFD60Pf/eY47k+aJ9D6E8aBwS4PoCZSJ90F3F1jYmaTNqCqFXnIgC2P8IHiZkqEHT+8cXkrQrKSoadHxd9W4QR1IQUzlQGETDM+YxHlIR/cstKe48KtuALWAnUMFLR2kfEtnpdHToX1t+Min3GWrqoYU7l/d18evThZYN4yqhKYmvEZsDZ57PqX1Icr7DDKeA4nKmMpsOq9+FXfrkL//j7Qzp1LULjr6EgNW4QZk8lhc1Ml7qSagW7tl8mhOed4Kq8zpCdhpCh2TAEWOKlvsY+6J+h9VdjGBbM/eWV/o/zS/LhB+4rF9m5otO+au74z9G+d2/sYV5CiJzZMSBHtCJEjpX3gpy2hrUQnexYgM//4Z9jdnZWdgT7jQTejnf+BSqvlH6cAyajNdsoGDlfu/DbLpWzSpSRaJN0invkmMyWwbwd2voIp3fEz1Qd+jqdH079ByCXc1qlJeqsEMFmJUsycj0YHOiHSMUBp2Gi7iC/BHuwxVwS8BjlcBmRC/1Ts4AJJJMfT/+Oi+dGMdQB5sHLwQv8pNVX1yA13es7kFbsPnlxlZ3QIAIxzw5Hit6q2FpUlRaE4GpbE+lfQj/dyE+YH/+/aG5U+CEMzkln/Hz2KUv1eYFgCAsesJtanB53A+uPe/jdgNs+Kb2Q5SFrT0IAM/migXWU+r3l96bF+UZFpb
 TMECEDCw
 1/xA/tuxAOX9aPF5SaHDAFXNNfoY42yKYSS+9y1whJ7Ol4BcMBwz5FDpxUPv3WVnwB/d661KO0B5AHtbQw1gFRR+xaFqZDvDJNrtB2QpwARvbbHoWah9n1Hq7n7p7JCczoBFzRP9Xtyfij7kI1LFiRsptLJPDL5z9xEUJ7r32e7GpYjfB8XlHkVJ+Mg8LFNF9svtG60ueM+QhuVvIvWa9g64yUPcQfYNjveXZaKyP/HLm8WdyWDvdxRK4mJ25MB1StmQJFlCRUe1dFZ2xzqbigMWjFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:22:13PM +0000, Dmitry Ilvokhin wrote:
> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

