Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E94111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367BD6B0088; Wed,  1 Apr 2026 23:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3178F6B0089; Wed,  1 Apr 2026 23:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254C96B008A; Wed,  1 Apr 2026 23:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 172796B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:18:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1BE7160389
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:18:06 +0000 (UTC)
X-FDA: 84612156972.10.95768C1
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FD9EC000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:18:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6hjWsug;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775099885; a=rsa-sha256;
	cv=none;
	b=Jx3WihM7q46Q/lAcqJJogNdATyGX2LEeh+wgbrEzkcFhB8B8ki/h9KJJTPhUy8EQUJm4WT
	aL1wJQZyTRLchg63cgO+IlnvTMPJH0I12WoZArqhUa2O4Rg6bQWOLsRGZxIO2tl4sMEPhF
	bSU08bitD/If/nFfmFWQL64CL32XUP4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6hjWsug;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775099885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OedAVzv3pki3zjwyWzevU6Wd3yAWCzqLX9bfFQXON0s=;
	b=xfDjN1CumUNgthyew5FzRc//baLrVUDY7ZGWFedpPLbJ9SsRSHWY1MnItebIQmBS2AzERx
	aTHtSn+lM28nH+WrzPfMUjsvYED0ZxkCx2HM3sAF3aqXM+Z4jqO5H/76A5UxGhGXiwRR/W
	Y8Fn7Au5+qM9GfzSeE6TBCF+2+DieVs=
Date: Wed, 1 Apr 2026 20:17:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775099881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OedAVzv3pki3zjwyWzevU6Wd3yAWCzqLX9bfFQXON0s=;
	b=E6hjWsug1PI27grAK/Tc1n8qBEVC1in18IJCGr/YYmDjZ7Rtm1rWUOvue6H7fjyvTlk0ou
	ggFN+TL+xAtdP5ylKVLAqgAzpukJnyBAW338EAa3j9rohT36YJg3+ih0bKn+HgEY4cU55C
	9sxH07TUWdTsmhoJpPFPsJLXZ+WW5Q0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic
 and throttling
Message-ID: <ac3fg6LpRCKEpoJv@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
 <ac3VV7h1fuDuUOJA@linux.dev>
 <ac3YKAh1Kzmpwhi0@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3YKAh1Kzmpwhi0@KASONG-MC4>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c3tjm9z8gh3jq1wnntijfd19mp5sc3po
X-Rspamd-Queue-Id: 8FD9EC000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775099883-466613
X-HE-Meta: U2FsdGVkX181zW3Hg+4ExDLUa8sMprZ1KHyaMMXIq9F38dF83fimgdYclnZ3g9BFA8RbKEeeuTdHCuQBSlpozxZRV2/cOq0XtGRSvwSICSWOpZ9ENBRtTcWt4ggYhc36BBi/XD4p4w3RdwpjXX0rP89KtaELf1HI58IBra1hqXw81plj/csi6ppMkftJKMTA9+avqyAueaJUO69J14X8i1SpB0glVfrwQqM8yp7LBbLqbeHvOz9WbD0IAU/MNdHdt6CdnmrcpKsGxpQ+QH8DUCAPNy8V5MW4156LUYeqqB5yxyJRhRCOlMq+UrFXT3d4IV/wanDYXy7JC1j0+7WJ/20D1T+BPmVLVRpTRhVKjO7Kcboxj2u2bo72cQ3bSH2uaxFWjp2jrXmev+GQKBt4IHZsM3wOEwCYeqolTOWf9rOsCElc1hW6433xwrb1BEQ/vyhY2/epYRB92x5mH2Lx8bY+ONnJI4pBE8IH9UbQhvJBXkIZS3uYU/ewW7RtYzsTucemDKSnkTcL4sw/3/oVGlQ82dHTzC737dBkhoChBsmfP5lPOZEcSO/5Aa+Bhl3kCWJKpyJDkl0rqeRuWU1JEQbRhHB2Hka/Wky+JhbFvmzNezWgyNGEybql0+6tzI/ltQQ3bv1Vv392teg1Yp2IcTs9cCbSYret3ZEOToygMVfv/5zi+Gxvqk6vxdOA9Bc/EICF0ej4s5MUsCP6Awq4YPLV6Z7bZnMyoaF9byX/c4Pb6KjtEYC5OdCifP+x7dTf5uRwTw5JPX9ASJfl0zMLoUlAL6QAOaxn+GCPsdgXH6mTpBVaNXn2FIlCwu+a+f0k8HQc/R3o4rRs/+xgzwOz+5TXTMAzOp1+w23BCbw2evv3ef3FF8bYm39VPqZhr4KydJDbObRbViE6h0roM8Lmww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 10:56:07AM +0800, Kairui Song wrote:
> On Wed, Apr 01, 2026 at 07:39:03PM +0800, Shakeel Butt wrote:
> > On Sun, Mar 29, 2026 at 03:52:38AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > > 
[...]
> > > 
> > > After this commit, congestion control is now effective and no more
> > 
> > What do you mean by congestion control here?
> 
> This particular case demostrated here is VMSCAN_THROTTLE_CONGESTED so
> I described it as "congestion control", may I'll just say throttling to
> avoid confusion, it's not limited to that.

Yes use throttling or VMSCAN_THROTTLE_CONGESTED directly. Congestion control
gives a networking vibe.

> 
> > 
> > > spin on LRU or premature OOM.
> > > 
> > > Stress test on other workloads also looking good.
> > > 
> > > Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > 
> > There is still differences for global and kswapd reclaim in the shrink_node()
> > like kswapd throttling and congestion state management and throttling. Any plan
> > to unify them?
> 
> Of course. Let fix it step by step,

Fine with me but better to be clear about the destination.

> this series is pretty long already.
> I originally plan to put this patch in a later series, but as Ridong
> pointed out leaving these counter updated but unused looks really
> ugly. And this fix is clean and easily to understand I think.

