Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFCBDCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 13:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5816B0088; Wed,  7 Oct 2026 09:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685EB6B008C; Wed,  7 Oct 2026 09:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B816B0092; Wed,  7 Oct 2026 09:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2076B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:01:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5AB11C20C1
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:01:40 +0000 (UTC)
X-FDA: 85295841960.20.4C214F9
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B483180011
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:01:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O FT+rR+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ALnO33wx;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791378098;
	b=QcYuQzZjW2BGlsYJnkQ5+8ANYucGWo6JS475oEh+qutc02wz01T6pWuOa9/sJ+buegPWK5
	+xQRQEDy/nNdC4TQN2Xa4TO5/2l4QQ2wr2himm6OqZmkWJ93mzHvuZNLOy5phDyoRDN0W1
	dVEfvXQIsqSKqZbeLxmwkrCbsywY60Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O FT+rR+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ALnO33wx;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791378098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfyWAq2hiw63ziLXRgCl1FnUGuTYUXJNI/5k9KmmCgI=;
	b=Mqq8+otcncr7BDkMhh0vRwMO9qq9zipo/jd7Cln6JVGGYFKMZzf3FFyQCtyHs14IFELrRZ
	GrxirBL5yu/WdglvNaEBw134oYBSVEBsVaGxPKVrbcOI5MHVxNF207ci9oQxybVXWzK59O
	x+wYwlkiCmoUoMA+rjGuIDwtsX4aQCQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 21E847A0267
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:01:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 07 Oct 2026 09:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791378095; x=
	1791464495; bh=LfyWAq2hiw63ziLXRgCl1FnUGuTYUXJNI/5k9KmmCgI=; b=O
	FT+rR+mQ/p8l6KlOVpJc1V9f6iX6G9CvnxqlJJKTNKUq22keTPOkePKljlJPi5OP
	HYYnEha2Px/6ghgg6vKx27SfaXPUNo3FNe3k4nvLEfH+qh6uQ2ZfZbHqnVTn2VAU
	XDR4WpYH6N5JsXqt+CsKandENqWyxCbdlWmwbApWYZTBB4qdZGZYVcotAIQfEYMp
	YUJyEHjyB/7mMvgjmrYDFwFBie+XSfSfR8X3tVkNs37l9Khwmnrtr9O+EcCgorle
	VJYM1OTyjKHzr4BPJhZImk29t6TSlEMH7G5tpievEzaxTggdhIFudaAbJcP+fI1+
	twEbG7PkdqWl8plwBGJ6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791378095; x=1791464495; bh=LfyWAq2hiw63ziLXRgCl1FnUGuTYUXJNI/5
	k9KmmCgI=; b=ALnO33wxuA7li9y6LOWZcyR/M4aLNcHwQIMWCfQGo3oZg5gSXSz
	jmODkS24D0yJ3BdSFp5rMhdjeGMdjsEx53KvqJXBTrCk+OuSazjdO/7NG62hy0KR
	5YL5x1DakzKTjb65W9348AV54HqsHwVdZ3n3QU43i0djh9pU9S0kJewcwXhlqKH/
	R64ji8JnNwpuAJ25j16pDBFIZjbk4Wx2lbSkgUZbQV+vLEn+ZnDSOlFiGtjkP+tG
	pI8zQYRSdzLfkOiRNlmqb+HCQ/sir5Q5Zm5vj/KT+l0Wf486o3fGh9mbsJ/qFxd/
	1OpSsKbb2WnA+inhwDte16/cD6ktlYJ1zhA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791378095; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:Fkbi4L8lA5vG1EhbbUgce3K9ONF+sbObIKmq3jConLd/PyY
	iDb9Ui/5iiPve0GYS2ZqGxTJc75RsiDbpxX6FSABj0CDVtVXPSx9Rdlr7KNLwGrC
	K24Z54yua570rSv4SOyjiQ05Ioy2BQLS7IkjI73TZXzDP81fOiOUFFsAqlD3yhQW
	+Hl4IUUnlR7F4tXSJsmNcQnSBQE7RSlPGd16iPbloIsdzIB8hHYdePH05kD65pSg
	UsH97HeW5GNoY6NLMpIf+/pJkm7CyekUlHakypWmaLWa8o38FWqyx/WrDzLaeGB2
	n1xJExASKbM2+XfYt0UDtktKU7iri/y6S7lHcTQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:fTqP09/yrRsXlRFof8Z20HxbCUXgJOuxJBG4Pm3V3e8=:QUCxLO/LL8obTfMdSNVAjLHY2xg60URMy+9eXEgIuHI=;
X-ME-Sender: <xms:rkLGapakT6OsXu-8CX1JPAX_u3zvNDqwgup8exgPzv9vIrESGkrtvw>
    <xme:rkLGaoLLlZQKa7p3bKFiBf7hPRB1gE3jRf9TKLkoMdqSIBfKbnC5d9Cm-DAd6Wmm5
    LYXbj3ppcCoiaVyRmtI-0B1vB-ja94kXhjJRHP3OjZrrwl7O-8WDh6B>
X-ME-Received: <xmr:rkLGaqiY6BNY-rn00D70B5A6hBiJGrkB3rMKs3FFG0_l7A8mcONbmp77ctY>
X-ME-Proxy-Cause: dmFkZTEB5LT5N/hKuLOxpT3FhmzKZiCnsyboT+IoHzaDb9BIyJrdfFbpyx5h8L275dF8PR
    1gaqApSorCvJHpMZXRD92IT2iJigmNDxP+9aXeoSmFUv6wpCTIparKt+Bqx9VhivzdDX/F
    5yHRu6j6zXCVbzVbREN5Q8QNxazUx0Q6WAgLeWJ5Euq8kTY2kl7A/9KM6FImB0mD2d2s9e
    T5k3yp6GCmtgCgQ5ksHxAiYwscff1v8goq+9tmI479Bfbk4LLsV48UsxwGDpbozuNMM6k3
    vsz5GRjY878MXDTcLlIG5Dfp9OLn+BMyVLs0z9D3hx47GSolY8VKtcvID8VIj1m+SSh5LQ
    Y7W8dVwsmxChI/mKlxLp8FtSg5m+dpefBE+3kqD4/VWkP4bugBLMLNC9+0hGR1JxAeGIwj
    +x3eiXsxRvm8ZWV+ZGagBg220DPSV21UbBlV7SQTiJGk57cfe+S5rOwNG9qDTNl4S3Oyjt
    on/yIglD+lqCI7LeTGJqHFyyyBA9ZLVOvP1305ccb6UPCjlBDLvmDb7fILSYhYjfMhyHXe
    E6q+q3djwvOIrt82RShlzk7NcyYgyrxGtCn4BobF03IuQ3LLrwqWqXgUj9jbUTA4oItN3l
    tSlupDx6EprJ31sLSweI7kbSQPAdR+2fXwiTC0fG3pgHgMxuPGjDApFRDj5A
X-ME-Proxy: <xmx:rkLGah_xotdxkGOPNQuxfTnIVuPnCR32_1--ay87zLM9xbgo5dt5Hw>
    <xmx:rkLGaogvV-uiiYDX21dZLqyuNvH3iV9z1VQXLuxadsgHGZribGaVkw>
    <xmx:rkLGahx2pov5mDTu7HwQc_lNgxFd-qcHdnJcUBJdA9C8oLpX6M56Gw>
    <xmx:rkLGao-hkltAZ9Gt85bAc1zosbIoouDgA_Svh-QFD1ktiL9RqeS4Wg>
    <xmx:r0LGauhyR_MnGD1brXLe4Ga9aPNE1amajtK6zbsMP2maHcgSaxxTsPLr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Oct 2026 09:01:34 -0400 (EDT)
Date: Wed, 7 Oct 2026 14:01:33 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <asZCEttmL6VlMXKc@thinkstation>
References: <20261006091815.897133-1-kirill@shutemov.name>
 <20261006164122.ea9a673b336b8ac74725c35c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006164122.ea9a673b336b8ac74725c35c@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B483180011
X-Rspam-User: 
X-Stat-Signature: 76kkqq1sx4xxdci1zug8q8sz9td9ncy4
X-HE-Tag: 1791378098-326795
X-HE-Meta: U2FsdGVkX1/ECCukl02hWpJOfo5gXoz5rfAr+RPvAu4GIolD1kqgSYf4vKd0MKp9fn+3qjfo7BkRDErOVSVCkGmIIYfoUVbPBOLwoFq8QGYSB/w+tWIDR7e/8GF8AjFtD+bsDJn7dh/0n1Qo8APkb6d3OLRwuYNpSJSZAByjfrorexu+FEqP5NMcxaUrbv2FMHiKB3st9tOhcMAA+cu58BAa+qKh6XMyDlCQiJ1Tr9xoVztH0sVT5nbkteUS476j2d2RF5Y2jdYfOv7EUPE9eSQuWz8XF40LCAL0+UAYLHN8kfi8H84vr1A5E+Q9qDWIdiblw8MkEmbD9Wi4OrsAv947sj179CXkK22XbEssYgqKy6liJcHIycJo2H0lSVLCuRfXKGl+HgNiK9Lg1MQs79Z9frswS7HXmwd14UrNj4yie7Yv4Carvy507+5BZCL04lqZGuIxACxB6BEb3ScF0tvWjHm1RWJak6Iha6Lq/T/2v8vkAzStJZdJBR1fCixWfcWQzRwm0rc1UKJQSg5Gwt9mNDSbxZxV556K+O3lteMH1gFNyr861CFUEHQdyFEWqxAvBn7P99YhRx6JwokzdIj9Rmyk27dIpzT95wy62gVLzJo85KDibWmEbaqFlLrKQZwxYbwe8CD8i+Liq9zGBFgdwKMY18SvKECPsjBHXJq8Rl+2riIna8aQ7rNhX2M44kyF+IAbEdjpLh0kkGKaDEK9KoMh7WC/FIRM/JlSoHGMll6G/qTnqc+vtKxyJzh12RbFMMN8SZR1ISvUz188vU39pjQJzrquaqN4pajv7Z1Qjd+/KAw+Mnll9970jlYtvvvgVHkTrZruTt16HP8mCZRwt/XrC/ryaHQE40x0Mf4S4a+iJECLmarFHLPnM3exXo3ouW303VqzXl9tRqcPdhtlqcxQ/Cq+OwF7+pGaFMwHHwgQGb8ZeSYVTBIAHmn/eqq8Q14qpOlSwqyLko3
 3NlVpoHj
 FebBeMc92EO2T+/BF41EfoU/NSRWapP/CAnmCjAqgWYzIgtraLw2YhKODaiEm+54lcgeF6c0a6wcYb1YX7pOB/J/qTHsH9DeLvT72NzSwwEwPBv5gSZEGH1rWH2ONa6vXt1Z7qSDIxWT8Pz2QVYNzO3vvmDxBokhG5W6CiyJObNMifBjR5YviI2QSFF5KvTare7H4yv06vy+0bzi8gNLXU1j6JcfQ8BtQMadpHi3ecggbYD5/BiE62j2S4OEhgAXccYhpQ9WQv5LPop5DHym8BzdwyqEq/kpzpPdE0rHkcY0TwDFbRwMmMZQbSMkccs+kSGEtybaur0ef1FI2kXd9b+oNHtGMUYXlMUvGp4r8/w8MkHOfxgP59CacVr4x8xCFl+h7+1SYmHeSEkj6C8nmqLb1jmb/J0vgMGbNuGwTTcjIB8RxIwQ/BmGOWmkAup5kMZvX0eeCrwnCN9oweo/MQqbqDc4DE6hQIlsmS5mbUeClOVdwklHoGTuifAs8mtANBP4Vno+NiTEWD7niatkGWYJCW/zP+W3hSUqTaN1Y/bFQFJWk1QBhO5Iea+PqMkKoqiopgntK4TS7pms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 04:41:22PM -0700, Andrew Morton wrote:
> On Tue,  6 Oct 2026 10:18:13 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> > storm in defrag_mode"), direct reclaim and compaction for non-movable
> > requests under defrag_mode run at pageblock_order, to produce the whole
> > blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> > still use the request order. An order-0 request can therefore retry
> > indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> > 
> > ...
> > 
> > In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> > 
> >                                         before    after
> >     should_reclaim_retry() calls           63M     293k
> >     peak memory pressure (PSI some avg10)  99%      12%
> > 
> > File creation runs 5.7x faster.
> 
> > Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> > v2:
> >  - keep the compaction priority floor and the COMPACT_SUCCESS retry
> >    limit on the request order, so non-costly requests still escalate to
> >    SYNC_FULL before falling back (Harry Yoo, Johannes Weiner)
> >  - compute the promoted order once in __alloc_pages_slowpath() and pass
> >    it to direct reclaim, direct compaction and the retry helpers, instead
> >    of each of them deriving it (Harry Yoo)
> 
> Thanks.  That's a fairly large update.  v2 diff is below.
> 
> Are we sure about cc:stable?  Or even 7.3-rcX?  It's a pretty big
> change.

I think defrag_mode is not widely used. Maybe only in Meta.

What about keeping cc:stable, but only submit it to Linus for v7.4-rc1?

By the time we would have the patch battle-tested in the fleet.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

