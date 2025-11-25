Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136F3CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 04:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B54B6B0026; Mon, 24 Nov 2025 23:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264EB6B0027; Mon, 24 Nov 2025 23:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B816B0028; Mon, 24 Nov 2025 23:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0381B6B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:26:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 688F2B8E1A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:26:27 +0000 (UTC)
X-FDA: 84147842814.06.0936ABE
Received: from out28-2.mail.aliyun.com (out28-2.mail.aliyun.com [115.124.28.2])
	by imf24.hostedemail.com (Postfix) with ESMTP id 888B218000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:26:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=sdiCiImf;
	spf=pass (imf24.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.2 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764044785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HHebMJqUXHsz+vWYUyAkO0gwd19IOceRKxNgMJRA9E=;
	b=L++vAk3vw6A9I7F1fij/2c3MwHM4o3/56z6KQwocZQFgWREIJ3LSI4j4DFJh+19Wx3JrMP
	xUwyMi0kCEkymbaGU0PlgVtriu44O64oS25VUAuQWAh8ocZockYFEc1iZUtZIbfmnDwLtv
	quclZU3ENTusg4/lwjUpYDWYGpxyNJQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=sdiCiImf;
	spf=pass (imf24.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.2 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764044785; a=rsa-sha256;
	cv=none;
	b=X89LIXjU9qpZOeEFH9VKyQt2CBBGgJwAbE/ylXOiitQadd5UXcpDMR0D3ZVOeRh66R2vwk
	2hndrx2Vvb1YZmMxxWXfKguLlvp9BgVwjT8oTecpQbzNjDJNByZWv2vyWHs8fw5mqP08T6
	wsLJdJtQmZ9ymONhCouOVTbKvTs9W9k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1764044781; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=6HHebMJqUXHsz+vWYUyAkO0gwd19IOceRKxNgMJRA9E=;
	b=sdiCiImfGh9iGdr9qb9VGs6mVTBBIvLOv06UVdIyrkh9Ta3n03DvXQlgRMX25YvGi/EWt5rCXIeGoL0VJwk7Wr+39Ug6CksqwiM6TPYZje3qIkymZVRSD0wql+68NvUAH3NR9Wcs6PhQZT6JWvuIYlg7r8aeNw7D243TkoC+USo=
Received: from i85a15111.eu95sqa(mailfrom:junchuan.tzh@antgroup.com fp:SMTPD_---.fVFjKd6_1764044779 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 12:26:21 +0800
Date: Tue, 25 Nov 2025 12:26:19 +0800
From: Zhiheng Tao <junchuan.tzh@antgroup.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, zokeefe@google.com,
	peterx@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH] mm/khugepaged: Fix skipping of alloc sleep after second
 failure
Message-ID: <20251125042619.GA119062@i85a15111.eu95sqa>
References: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
 <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
 <0f292735-4b13-417f-bc65-82cebd2040a3@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f292735-4b13-417f-bc65-82cebd2040a3@linux.dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 888B218000C
X-Stat-Signature: tex7q5zrgs3n6386xwh958aqophzypza
X-Rspam-User: 
X-HE-Tag: 1764044784-457885
X-HE-Meta: U2FsdGVkX1/XRZjoH+csZzOLPAPPhvdTvwQvSNMVfygAVaTPOJb5j2+qSu/orKRtZaFIe0qLzsWYa1lGq727CFAzkqj2qvUP+UcfkRfgCX+DLk1Pp+xUd1+TLKC//1s8f1B/See3pbiK4lhVi5STPlGwWBVEfYL7K6rheNZypngD3FzzTwE531hl4/FGFnzzQRS0HR8mqoYV/uhZP2JilF+iVn4qqF8BebvOSOYQ6r7RCE2BgVkwTqCNbFmnseP+FeUCDfgBbal17440reFoBhNBZMYkn1+DZJ+F22drMzgiu3uSbNV7Iwzb1JNrFglK3dnedYlHTcfEEypi2Sv0djxxRea/74Bn7H+6xEK0254EWwJQfBAqaokO71GHDujZRvHZyW599LqvzyKtmfYiIAHjGOHwFIPI48gXOSePi16ie0kYf38lVtVfHyqSq4u0PlQPhv6VytK6A0+1UCd2Tuw37jlJrHtdt2kRrt3vxlKBm76LpEZSsjw7wd1r/PBk6SrJIUZS7OFV31WGhxN1PQJAY/6cOmKat0SIE9JtElTk8KltCU6XueKqJmVLA8wNbAExd1t75M4rGoQWxd/J/Yx5m1PaMmal80GqAN8qQbEcMcZb1eGwPRjkFl41WFFIQG0a9Qkn2OKYS9TJfITx/WW5/GLDrwtt5KNwTtQK6o5h6KtWLn8Nsj0543aCNInx+wa9ojhRC1jEDKi2rgMNuzSDf/l7A72z1y94tgDPTxAfo9uxMpbbfoy/gsupE0xhTb/6H0cMrvzOhC2BCiLkZNVlaJLlVxH7sLmFTSRDKFfhVxOneYeIO84Lg49DBcdGzmzjkX5gdeZnYBbmeQgt81o5hySNQP+4ra6+zlSw7LdWeCY0NqFvMZG5r0R/cz4AhUT/12c1TGHu85wluzV4v8oZ9s8Ihsg6+sSKcn4BfTH1Pig70/5oLYEOEnCDABxj3YRhnlNneksv4GELTaO
 Q0OGdfYb
 l3sichfTh9Y8Dmc9a0DQOKdmgFrtfIIVo9SqjKllWsMy5uF4667X6CSW9fOiDr1NpuioRql1tLWVFc1j+xlPrQQP5sc82Od/PqTn78O8KS+SnQ4HnfdYVbZFZ0/pTGai8WkFiBEFvtP3bX+dsJR08pVYM4yDMR/wTy7cmAq5ReJIi3FI1oV85yjqon4h7M9S+fxM3f4bW0+E9hsoKvcYVQD36wMfjCkkPbEHcjz1FJTotFBQnXea5dTxmZrc7YfR7RBcv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 05:27:23PM +0800, Lance Yang wrote:
> 
> 
> On 2025/11/24 17:14, David Hildenbrand (Red Hat) wrote:
> >On 11/24/25 07:19, Zhiheng Tao wrote:
> >>In khugepaged_do_scan(), two consecutive allocation failures cause
> >>the logic to skip the dedicated 60s throttling sleep
> >>(khugepaged_alloc_sleep_millisecs), forcing a fallback to the
> >>shorter 10s scanning interval via the outer loop
> >>
> >>Since fragmentation is unlikely to resolve in 10s, this results in
> >>wasted CPU cycles on immediate retries.
> >
> >Why shouldn't memory comapction be able to compact a single THP in 10s?
> >
> >Why should it resolve in 60s?
> >
> >>
> >>Reorder the failure logic to ensure khugepaged_alloc_sleep() is
> >>always called on each allocation failure.
> >>
> >>Fixes: c6a7f445a272 ("mm: khugepaged: don't carry huge page to
> >>the next loop for !CONFIG_NUMA")
> >
> >What are we fixing here? This sounds like a change that might be
> >better on some systems, but worse on others?
> 
> Seems like we're not honoring khugepaged_alloc_sleep_millisecs on the
> second allocation failure... but is that actually a problem?
> 
Is it more appropriate to honor the second allocation failure?
It was a problem before commit c6a7f445a272 when
khugepaged_pages_to_scan=512.
> >
> >We really need more information on when/how an issue was hit, and
> >how this patch here really moves the needle in any way.
> 
> +1
> 

