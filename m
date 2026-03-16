Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4689FF506DA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 22:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442DA6B03B3; Mon, 16 Mar 2026 18:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0AC6B03B4; Mon, 16 Mar 2026 18:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D26F6B03B5; Mon, 16 Mar 2026 18:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8836B03B3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:29:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD9681C177
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:29:13 +0000 (UTC)
X-FDA: 84553368186.03.8CAD96A
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf18.hostedemail.com (Postfix) with ESMTP id 966F11C0010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:29:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773700152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+GUbJm3eVSZWoqUFKARXTWLjFwcxyceiZBnXEncqP8=;
	b=Pv7KccJj5s9w++XhidjPR1DDm7uanF3Qz9gThG8Rgh0qCmX75HXwDjeyDX1WTM0IKWO37+
	pTgQvJ22IWl0frqXS7gMYDbgq8y9KhOoHL8/iAOoIu8nucDgcvGRNf1IajVt9/BCRuYV7D
	lZj7BRvJjI8P6rx0IwKjQq++fedsnBM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773700152; a=rsa-sha256;
	cv=none;
	b=cSpVT17hDzi6g4EQOQwIw2MhbQF80IgnOv3QkA2TnUUYWXgFq34rnmPDhB2JIdyPROk6xs
	OZeMk310SwVkEvIEvxPGEcT2mUGPFxVhEhcHFV0rNK3QzQBh1CL4o+HW78mPqLoFVLYXQw
	pB3dteSCDj+saLjdHg+GCY0exDQbSJE=
X-AuditID: a67dfc5b-c2dff70000001609-16-69b884321b69
Date: Tue, 17 Mar 2026 07:29:01 +0900
From: Byungchul Park <byungchul@sk.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, ziy@nvidia.com, ilias.apalodimas@linaro.org,
	willy@infradead.org, brauner@kernel.org, kas@kernel.org,
	yuzhao@google.com, usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com, almasrymina@google.com,
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260316222901.GA59948@system.software.com>
References: <20260224051347.19621-1-byungchul@sk.com>
 <aaCVzc2lexW0TiPf@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaCVzc2lexW0TiPf@cmpxchg.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA03Se0hTURzAcc69d/deR8vbcnZ6QLXeRlZS9IsyKhDOH/agKKIoG+2WK7XY
	1LQHrBIyaWZmYXOiTvId1iqdolLTLFeRrIzby6mVPSyLZea012ZF/ffhd8758vvj8LTSKRvH
	6+LiRX2cJkbNyhn5hxEFc8JS7Lp5LemhYKmsYKF8IAmKO+wy8Fa8psBSVoWgz/uUg5/1zQg+
	N91ioafRg6CwoJ8Gy/0UBr5UDtJQU/sawbvsiyy8au7ioNy2CtxF3QzUHa+moevUbRZMKUM0
	1Ht7OThqL/GFrxg5aK1Kl0HW4AUaqo0dHDyotbDQXvFTBt0OEwMt5lIGPp1tosGdvhya84Oh
	/857BE2V1RT0n8xloe18LQXX6ts4OOPKZ+FFihuBq7GLgbPfUlnIOZKOYGjAl+zN6JNBzs12
	bnkoOSJJLGl8/5EmV0sfU+RR9mmGSA1OitSYn3Mk35ZArpSEkDTJRRNb2QmW2DyZHHn2qI4l
	t7OHGFLTuZjU2D9TxHSsl12r2ixfqhVjdImifu6y7fLoM97TaF83l+Q0XmCN6JMsDQXwWFiA
	vz5uZ/467/sTzm9GmIavZWQNmxVmYEny0n4HCTOxy5rK+k0LPRzObAv3e7SwDjvNOcN3FAJg
	a0n1sJXCRpxdfvXPfBRuOf+S+f02BEs/3lJpiPd5PC7+wfvHAcJs/NX5hPJbJUzB16tu+Sz3
	rfaGx6mp9/7sORbfKJGYDCSY/8ua/8ua/2XzEV2GlLq4xFiNLmZBaHRynC4pdMfeWBvy/bCi
	w9+22JGndb0DCTxSj1BIMrtOKdMkGpJjHQjztDpIUdRUpVMqtJrkA6J+b5Q+IUY0ONB4nlGP
	UYT179cqhV2aeHGPKO4T9X9PKT5gnBFFnlup6ctdo1xoD/BMHBzpuTd60qnpkT2dgcpDpsvu
	OwOBHYXdJPdoToHV6mwkW4WnhoMJwVGqdbMmH3imjR85gKJWOCyqy0PfIy4tCnu49rlq08TI
	wK0qdR4659ydtXPChs7MF7Em16B21LaI7Svd4c4IVBjee/DukgZrdNfUutVqxhCtmR9C6w2a
	X6OfDq5dAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA03Se0hTcRQHcH737WhyW1aX9Yew6GWoFUXHnv5RdAmMKCiIIEdecuk0tpIZ
	RDOlTHM5H6h3WqZlppY055yvKF2+gh6GcTNzZqaZYZGmTk1zVuR/H77nfM9fh8EVZaSS0USd
	FXRR6kgVJSNkB7bH+29KcGg2POnygdzyMgpKJwxwt8dBgrtsAIPcEjuCUfc7GmbrmxCMOJsp
	GGr8gaDw1hgOuS8SCPhZPolDdc0Agi/Z9yn41NRLQ6k1BFxF/QTUXanCofd6CwUpCVM41LuH
	abjkKJ47XGGkoTGvlYSXdhMJGZN3cKgy9tDwuiaXgu6yWRL6G1IIaBXvEfA904mDyxQMTfnL
	YOzZVwTO8ioMxq7lUdCRU4NBZX0HDent+RR8THAhaG/sJSBzOpECS5wJwdTE3Mnh1FESLE+7
	6eBAPk6SKL7x6zect917i/Fvss0ELz1qw/hq8T3N51vP8RXFfnyS1I7z1pKrFG/9kUbzXW/q
	KL4le4rgqz8E8dWOEYxPiR+mDi47JtsRJkRqYgRd4K5QWXi624zO9NOGNuMdyoi+k0nIi+HY
	zdzNX520xwS7iqtMzZg3xa7hJMmNe+zDruXaCxIpj3F2iObSOnZ6vIQ9xLWJlvkdOQtcQXHV
	vBXsES671PY3X8y15vQRf7p+nDQziCUhZs4ruLszjCf2Ytdz422dmMdL2ZXcY3szlork4oK2
	uKAt/m/nI7wE+WiiYrRqTeSWAH1EeGyUxhBwMlprRXM/VHRh2uxAo6/3NSCWQapFcol0aBSk
	OkYfq21AHIOrfORFTrtGIQ9Tx54XdNEndOciBX0DWsEQquXy/UeFUAV7Sn1WiBCEM4Lu3xRj
	vJRGtDYnec/NWtcr8yXL/aGR6+mK+JBo17GDOtnpx84HfbbQzpata5KVtqzCFKX9pHfyN+XM
	bbvrYuW6YdE3wnfwcMVx8+eZvlqTELzNkhcmR+4ddkHhL9n2PL9yw1cbqE0zHcFqB70HHLtX
	25qzukoM/dzpy+Le8SUdp4L8DQ/F1SpCH67e6Ifr9Orf6sDPED8DAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 966F11C0010
X-Stat-Signature: 15jitfyjun4jphzmh58xszhszzgoajqz
X-Rspam-User: 
X-HE-Tag: 1773700149-964663
X-HE-Meta: U2FsdGVkX184l0zGHIs6zfpWp0JeRzHp72UvPseCnc7S4T4703Rkc+Xn9KPt0SLwpn65Xzi0GSiO4hXvBSf2IQ1nFlgqrEkrw1eRvkeUehz1BBE8Amwi3sGLMBVEoerNHkrfrliy9rnGHaFwWQjgjLB2XXAQ1un2mT5BQtY0fVxADJmM4F2NnOs9GclCQM6IWuvIOqkXD+bCm9RxIV3jEbC0D7XabCumHw18v0alUYB+G5mE01dzybT9Tn8h+k1HUL3aaWWGxKR7PLf2oi2Z4TBpMWzWJbYFrfwimsViArF1Tq6AD/j5ZCZyF487qdLjmzg6AZX5zzfap08F8zqN8M/tr35cd2D/21fvC2UYuieXxX5x7l6tTQkEyyNCfRpZEbZ+9an+w9BkEWK6lk/Fa/LjcLmSInujd+3vlu8jz/2JLdT6bPYT6hfZyrCXLfrb2luAbzFtdExb1fd3M2Fj5L5vrkwGvvSBWzV0cm1DwJv/cVtrBkHcedvBzmO6gxBF3IcK12FUNFQ5UMC0DebXoEK3+UE/z8lyG3DQJv9mTkh7zeG6yb+zx0MUR6mQmWzqOowOaobyhUCpAP98TQV/KC/vTQRVk3fQB2kDHLiQrNr6wptWQe2Oq78/na3w/FgStQq3it+OmsKRzn3RnSH7HEt43lzNgCI6HbE6p4d8qVLiAk41yrNPH3IpiuUxNvGUAU3M7HsmbTzkNZ06k63PxCmzf+2XyBk9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 01:49:49PM -0500, Johannes Weiner wrote:
> On Tue, Feb 24, 2026 at 02:13:47PM +0900, Byungchul Park wrote:
> > @@ -1416,9 +1413,15 @@ __always_inline bool __free_pages_prepare(struct page *page,
> >               mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >               folio->mapping = NULL;
> >       }
> > -     if (unlikely(page_has_type(page)))
> > +     if (unlikely(page_has_type(page))) {
> > +             /* networking expects to clear its page type before releasing */
> > +             if (unlikely(PageNetpp(page))) {
> 
> You can gate that on is_check_pages_enabled(), to avoid a new branch
> in the !debug case.

It's an unlikely condition so behaves already almost no branch.  Do we
need the additional effort?  No objection but I'm just curious.

I'm adding v5 patch with the request applied in this mail thread anyway.

	Byungchul

> Otherwise, the MM bits look good to me!
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

