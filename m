Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D3FC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 23:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51BB6B008A; Wed, 26 Aug 2026 19:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D029A6B008C; Wed, 26 Aug 2026 19:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C409D6B0092; Wed, 26 Aug 2026 19:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0EC16B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:16:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 322D51402D4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:16:31 +0000 (UTC)
X-FDA: 85144981782.24.332AAFF
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19B1520002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:16:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+mMWDpf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787786189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+pt3woNzeRoDpDHMv6zGWu0vqUOFtEZBXl4HN0Nvhg=;
	b=KywQz8el6V+xt2Yht3l/VWcx6vnzuJPnIUBeYpXFBBnGyb7l21SrBUjr6hyWCGT3VJvPe/
	Ph7K/1vlpCRvVCLofM8VHGID1XF27fuZNCkfSYV9R2bL7sLsIrHZ8YCQj62XeWA892g4P1
	+n1IWcvWpRyfLsSkm6ASf0TfRu2IuiM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787786189;
	b=14sBF31JBuroJUghNc2zk8XJ25iZXumijmbVjT990omNaRIi2iwLnRP3/DJ2wOrlJdi9/e
	UQkXUfmaZQ0JtxriOyzSW/ZqTPl21s+I0Bo5RQPh2gJCtUM17GJT5RnmwQxQJIK4yh4jWm
	iAutHt/eENpMgNny74bAqgPAaTe/5j0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+mMWDpf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7GB9LDGc/ehsf2MrGh51/UolbCmkcOrybX27TcwbBiM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787786187; v=1; x=1788390987;
 b=B+mMWDpfye8MXWiJqFkip5HSbBBs6Z++TQ+Ia3t4UqA62aNsRoZsE8ToiGuL6VCrwoqfIX35
 fy6xHdiLiiHZ2ErpKmoVqEIU60+UYn07aWvKaJLKYhAQbbNwMcp0xoojO+DPm4QmTZ1K1L/CAIW
 RGNmPXb3aTuTgMu2dUJFRleU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:45::)
	by smtp.migadu.com with ESMTPS id c343a924b13046c4;
	Wed, 26 Aug 2026 23:16:27 +0000
X-Mizu-Trace-ID: c343a924b13046c4
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:16:26 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ye Liu <ye.liu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, David Rientjes <rientjes@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/oom_kill: remove unreachable __GFP_THISNODE check
 in constrained_alloc()
Message-ID: <ao9zZMgwva6nMXxN@linux.dev>
References: <20260813093810.573302-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813093810.573302-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19B1520002
X-Stat-Signature: 5j3xtx85q59tpxyf9ndjz1ed9cofdtj5
X-Rspam-User: 
X-HE-Tag: 1787786188-789538
X-HE-Meta: U2FsdGVkX18w/IWGB62LG478sY7LDZbDDw5ud4eEKWLacTg26vhUxXwA3cFZ6cNa3K1tYaYzLZx1vYM3i3lnhS0nmM8neGbd9y5O5/p1pJEfrgWAHCLNu+apzt3YPzjS+GPC3sfGUTqxgAErXgeiJI3g0sPtOzKDziNdS+mAdHOyiJ5NLMtZZQi3519VYAKR7FleyilqoAr7zfZh+01SSN/JoYMxuyVqmEGzrRRoYd+7r1WjfadPLNJly7CThXID4sPyuyCAxHsRx3isFFRj7phRgdnF9Aub783jb+BWsaKZqpfiPNMigqneUgChnS2P9iPJ0UfJsNYXU1qsIrqxZWNB1W8DIUgTVM/6bB1nB8n4CEHvk4TuDu3LIZdvynYrjOQNw5OI0r3ikTDRgftHAQGib3Cw+aCLZhdizhkZYqFCg/+7MksfRLg8F/0gnnDUwP2P+NMHAI1NP/pUhgOllGaP3V37g9SqXKCwEzQcppB1SyKb7WqbxzY2N7Pe0kxMdFIu27gj6l4P/m0J/qV8T17z9GOLSzwGqWpMm3Xtnt0tlVttIWYj3Ds71GYYUH5IItMdTn9ljcm+xoM5cYEW7Du7gM07TwBjGWxEQd+7jrcp36Xo5I/C3lUPYQIMef2UlNFvO77RiLa6qs2nZXQuhaHi9M/G2BgHamGIZz1QUwzf34qmhVTXDoc4zFg956o8qs7bjGQhZCH86f7E6Pvvs+/5RCJcaPnaQzMBdPa454uvzfmV8GLtLirtU5FVnWuzg8tHyupkK+lO5OlZr2a2ICD0QXLfaJiOJE/gdnfKlad24kGuKu8heK2hqL6mocozPlQ5P3HD5KvxBXpQwfA4fFUR3q1J5BwuVi+QZ/x//onzJg55vE9d4O2gwz8BjhHs36cspHq6Id73vERN6a8/a0I0vHpC2jhGbithOxt3spj6a0Sr6/XAyfYY2tj8nv8XEixgIpuRlV+SgBk9cCm
 gngp/cLn
 EvH4e9Cmk4PtCHRPnU0qbXIhcGyThaXLC1B4EmjHC1AWmXvj4PzcDWdJ0WiaVW0qVvXL1KwWjISthmTR65n8fa5tNksPlgIGTzCSY9OB2PeNKm0RcvUQpC04SPm6AE+LQ0VEyfzu7/A81df0x4Quaq6jiPP1Ny2yd6jjfoOhuT/0dLtnIFuNYqZrh5tsifBwH02NMN2BdZjOcK3CEn6Hjkh79/k9BCl7ElEpctwHd6E4kGxGfZAfkyTExJQyW+9WSXD5BezQFYwoMlfYwqWz9U7ob7jLeammNuKR+whibqwIW78yYt6UVuAizqwvMXWXrsaOy0JPHI1F7WKwvklp6g4U/ldkz21T4hzl4VytFCVzaim+mIrsR5jHWSjsjEoFWhrVDGi6J5ZYQNbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 05:38:09PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The __GFP_THISNODE check in constrained_alloc() is dead code: global
> OOM is never triggered with __GFP_THISNODE (blocked in
> __alloc_pages_may_oom before out_of_memory() is called), and memcg OOM
> returns CONSTRAINT_MEMCG at the top of the function before reaching
> this point. Remove the check, its stale comment, and update the
> following comment that referenced __GFP_THISNODE.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

