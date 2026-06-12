Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26335CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355ED6B009D; Fri, 12 Jun 2026 03:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306A46B009E; Fri, 12 Jun 2026 03:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F54F6B009F; Fri, 12 Jun 2026 03:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09E136B009D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:02:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96EE78F2EE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:02:53 +0000 (UTC)
X-FDA: 84870368226.22.643EBFA
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85E4D40004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:02:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TzpoOsl2+zNb2bgkj6flpXtfYo8DBbSEoFEqqFljUyQ=;
	b=O/ClBS/z6LNWU/0Htw9aB37nmb8ahikqfqPyOoFuHghKGDmRuctv6FcGqYv2MIpMhGEhAS
	0hb/m5XZGb4Vl+1ADjnvZDPppBKsLUJG/oLbmCL0+R/dye8gdLoixp6f+FgWsmWB5vGkAS
	oAxbGQvKmTMdVMIYZWTHabyoWg/qIkU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781247771;
	b=H9l1h6DCr43f6sJBkrSL8DW0FjbN6EL8Rk6XnBorUHITYTIiINwARD2/vUPVRLh1d0zvme
	pmKsWfBNp7aHNIji1OAEFYM6f3syh/9OFoZSPpH2DvyF7H1FCauFrmf8ZL5ssQEbqto4iQ
	PE8vJYpzDvlDyLGaVVL/WM9Ne94NPOA=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc9Sh1Mmtz1dd8V;
	Fri, 12 Jun 2026 15:02:44 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc9Sd6rbMz1dd8V;
	Fri, 12 Jun 2026 15:02:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id F286434C3EC5;
	Fri, 12 Jun 2026 15:01:14 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Jun
 2026 15:02:35 +0800
Date: Fri, 12 Jun 2026 15:02:32 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <surenb@google.com>,
	<mjguzik@gmail.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<shakeel.butt@linux.dev>, <rppt@kernel.org>, <mhocko@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<dinguyen@kernel.org>, <schuster.simon@siemens-energy.com>,
	<James.Bottomley@hansenpartnership.com>, <deller@gmx.de>, <djbw@kernel.org>,
	<willy@infradead.org>, <peterz@infradead.org>, <mingo@redhat.com>,
	<acme@kernel.org>, <namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Message-ID: <aiuvCHI32bfz6j20@hsj-2U-Workstation>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <airY5q_SspdbQDbi@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <airY5q_SspdbQDbi@lucifer>
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 85E4D40004
X-Stat-Signature: jw39c3i9tm8zi5cyoexwy7irrjkxeego
X-Rspam-User: 
X-HE-Tag: 1781247768-625632
X-HE-Meta: U2FsdGVkX18EBdHZot9RvcLwFjABQ8MwAIHaAVXkv2861YmBjKDPUwN5rnTWHu9ijGyiJ3PF3+jRJ7qsPKFob76d2UTJPlItSC0Gsiygkxgp7gS024W8Ircd1UFWhtJtS77ZuRRItDUC9mIiXPoHqyXzUt4tKHuJOzTNbAodxuTLNtFCI7IcLhcMadzjHg1BAeUEfRPOHsUFf4ytaPGOfx82yWtDVajcf64/dsont2j8bLZ1s/05S0QiF+CvTa2elLFFlD0XARRlcupm4Gd3N1z1vL3WFqeUHpyLg95rTuBxwDr275CT9I1k/LKK7KNowzEOacXtSbv+H2p6hgGVpM4LbRPL9RHa3l/o8vAD+PDrIPcuuhSOIhOLbD05J/Pf8B44dyss7icMRfrJQR0e9q32/ZfExXHHXwnA60RdeQtyF2LJhcolsxv0KXk9tjX87iKIbnT7a1svnMLd1GPZQ+l60JZ5wU7kHRUlTkma0SgGWA5f35l1L9TxFmmjEjkfZeu4lG2drV5SjouMMjLfJBYXokA1UFmgyvDojSeSJcNxERC7LHZpp20yozsYtPL0Uki+P8iMTVpSFIhkd8x4Kb4kD0eKEa5SRpa57LcInAhTELsAAgsZSXs1JjDRkGhzLlfqXT0uf3Ny5FnbUaW3LL7qVCsTJgzRKmq+DFpOhaLBt1UUso9nGpLJq5Xn5NHd5QpdeBgKm/YZRYibtf1jEv3Fg8aQtH/58F68aVJli+hEszD/pbglYY1wnfsS8xZPqFc8UmUNgBtIkUJWzqT8cYIA+jh4PKpBJKXlH8+mrqk2lZ1TwDQqtzi06SbAU15bzLuPLB3izmAJL3DhdRfrPpjI/eJ9RMlEMLhXoc3nhkBA4NWQDg+GRSWJGcqo9AoybMcCQ0G2pVjfzE4T/aitcle9/WgM15B1bPMg3BR/AQOekGAIxozOD0XwAwWvSE5jJ2Iw2Rs8R8tBJBvJsBD
 e9iyF+Fy
 obze5eZSpeXZUhxWGfak7Q+DJSUIiTf4S06d936hplmaYFpaKC+yNT7PWlIVfky0Aja0Ti3gKGMpGvEba0ob73xFe4ajNUfdwCKkx+iTRUk7JN6jtrx1ULrFrddj4m84HoXLpnkDlBgpjbBz3rRCM21lXPmpt0yIra3z1NUc9wTzJz1DlKZrZHdXqQOln2jOdHxMZOiOBq/suOcTQ+l0ft7sDD/vVXjM2eCucLwoSRWSCDiEQOFc3F9+JaxPUzoo5HdaIoBx08cRB2nNtj7nuWwRVpLD77d+rjCmtrbU/vcMRZ+hEaiuKEWE8pIO1Ysonst7bpaD7zES8tlqjhE1QQQWtOotCafmH8n4y1NGoejA3a8GBB8bDTEKCbSL+M7yOdDcs61L3U08Ji2fgVGhWlV7Kh1wsBnn9e+n9+3dA+JCahs2NqRTbwK29vILghUX7VC1mFiNXtUJGIJpVA/0l031uhz/vFNczuhm6i1BfJJyrGoidX/X4QRbR3Z7vf/XkkZCG7e2u5z64Jx4pWmzOH7kurQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 05:00:49PM +0100, Lorenzo Stoakes wrote:
> Hi Huang,
> 
> You seem to be replacing the file rmap altogether here, so you really ought
> to have sent this as an RFC so we could discuss it as a community first.
No problem.

> 
> Especially so as Pedro had publicly mentioned his plans to implement
> something similar here, so coordination would have been appreciated.
Yes. I am very happy to work with Pedro.

> 
> Anyway, as Pedro has pointed out, the code is overly complicated, it's far
> too configurable (not always a good thing), and the locking implementation
> is questionable.
I can make the code more simple. :)

> 
> You seem to be adding a whole bunch of open-coded complexity too, which is
> not something we want. Abstraction is key for the rmap.
> 
> You're also not adding any kdoc comments or really many comments at all,
> and you've not added any tests (though perhaps it's difficult given how
> core this is).
Got it.

> 
> So I would suggest that perhaps any respin should be sent as an RFC so we
> can engage in that conversation and ensure we're all on the same page?
> 
> Especially since Pedro plans to send an alternative, simpler, solution I
> believe.
> 
> It's also not helpful that you haven't examined the non-NUMA case :)
> perhaps your particular server behaves a certain way that this approach
> aids, but regresses other NUMA configurations?

emm. I ever hoped someone can help me to test this patch set on the non-NUMA
server.

It seems I should find some non-NUMA server before I send out the patch set. :)

> 
> We'd really need to be sure of this before accepting invasive changes like
> this.
Okay.

Thanks
Huang Shijie


