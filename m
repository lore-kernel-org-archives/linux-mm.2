Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73CFC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3096B0088; Mon, 31 Aug 2026 20:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4F76B008A; Mon, 31 Aug 2026 20:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA3E6B008C; Mon, 31 Aug 2026 20:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 977656B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:02:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 253DAA0346
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:02:37 +0000 (UTC)
X-FDA: 85163241954.12.57874EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76F6B40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:02:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKaH01if;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788220955;
	b=8ZOAq1sz6i4JHHiMzH07glxGKEDksLGGbSP4xCK2Wk/6dxKxTG1gIU0nxr74fCU1Nx+mdl
	+GAuNE4S9Ey/LVXM++5uNgaw91OwwK2wI4ouLSPtoE9bEDwB2JSR7znAV3oWsDF86gAd6p
	YsVgOYtyX3VvaHWOuBz2tXYeaFH/Sus=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKaH01if;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788220955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTlrpQWzxbwCPPSf4vM9BxkALA4WAiGAhLpXzsRVP00=;
	b=8Pmd4NdOPnHxqtbciVNMPkSouchWxbgWF4ccq1I/joIRnRdSbNEGfUxZeIbZgYPgQV9rnv
	6jqtcBrzfmQnIJkvaDJ9K9jSrSPgWzZ3RACe2hwGhjEF9tuPSK3K10JCLLpp2dvHc7ndT8
	O4k95gnacZCWP1ZuVykD0ZkxHpOjtEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0003602C3;
	Tue,  1 Sep 2026 00:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF9C1F000E9;
	Tue,  1 Sep 2026 00:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788220954;
	bh=eTlrpQWzxbwCPPSf4vM9BxkALA4WAiGAhLpXzsRVP00=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZKaH01ifMY4i78+8eAJ7lZTV+LQIL/XWqKn44DS2+UVEgj25WFu316wKVzIXqwzp+
	 ERdY7Kwmp8rOrSujjnTZMfaihqx/JI14pn3lMBoRB2mUgcJiPAz5BbHJZh57N1phlh
	 hKjaODtluC+q6YbbehddLGUqISmTYpG4v33r1L4E=
Date: Mon, 31 Aug 2026 17:02:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-Id: <20260831170233.e3deb2a546722a3c664bcd98@linux-foundation.org>
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>
References: <20260831234339.280376-1-stevensd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yi46oss1rqbao1x55d96m3kw5xe6p59q
X-Rspamd-Queue-Id: 76F6B40003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788220955-457247
X-HE-Meta: U2FsdGVkX1/jgD7u50fLwBk5cOH2jGm0QbKIVqLCiRYTC3c5nOrVRgCuFegpGtsMJKtiidJPqXc+Svk0O+VXqh4+QFmEV7tU4vcxx0qtoT8bQKWjSn65CysKBHKU7doPKYeihXLMigoE0zuSYDh7pHZM31Cjo9vkQ1xJO3V7WdtXfBRzZ+ibQcn+egukAFglyTnjhf5Q2DGxLSoqBNhQupY8Vu01NY8bjuihiluvrj/rMieA3vcR6XCgId2J8tYcrXDkNjV1ei1YN7+5Z8oGewQbICFHnx7fR3wqCuf63n7yAglMMXbO/CIXfVxFEpBuZ1QzZVGHymH2P7Gkvd3xZP6jUMxzOAk5E050XTcSeXSMuXWDTgiT3s3+hkvJTcX6HReMPRfTwaDjKpCjhtIH3wlburpQVuFxaPo6KpJd5IZhx/KNmvW1DKNa1dIMYjJqpZ6cDE/sAoKp3Qq3NvoRmVz6G8G3eXrTtk0/y7L94qcA7AYRnvVeWMCA+ZEF5PAAcHBdhwzV6WWkgKSedpkuvYAvI3CpGKbvuRuwDKzSfP+Y17pZM1yFo3WjZDET1txob1JlqRhjH0mWPnJEY7Eh6RCnWWBpnljE8s6ztfWRr/NA4KtKR1Dz43ndnaqmiLkqyT0Fl3nghyu/BzDv69DRQON8pre8ykYV/IK3qmcZO7n+mAE4EuSB+z5KDwoERHYtb9Gf/DB2LY/lAOa8F6NPBHwjWpoahulqDnEma44YTVTxztToKlNO7tzyeYnMWPkcivzMyeWZdWxFjNEXTobWSEhwwIH3uxVhMm9//VmW3RWJHywKpLAsbomfqELDmFPqGcqrGRdPIvBaR6cdof7ZsAtZttz/pCYc6Flif8H/3sR1o00VyLL8wOXc27PS7iewL5I9YVjXV8by1c0Bab9rUdduSvNZO4+VsyK7MtFdGT8+saSIQARSuK09I3+y9M2gi9EJzGol/nED+Wmg1ZF
 Tkms25LR
 bVUxYrz1qDBl8kArMuTtP+euQsNJoKv1s8g7hNU5Ya1VbBtO8c+mMYaRB5RhJJoQyX5s9WKIrjKHL1ENSoNh0RrltLM8c2oYlirUmmKcLVoBzYbkZFXZ53+BNdGwGECOAT5mlDN6Tp1h1Vndxp0dhKDPeMgN0x4ooICJi+CA2iUTTfpjy6+oW9IlgqS/+QIQMOl+sXtLyei4jc6O3ChHe+q7j5P6r25YMWLIbW5L6xTvGBql2Kj2PPtyEuVhIpYRvP1+Cc02I+QGwENb6uLsHAKeOr5Mx4frBJWvOJLIHOK+ETfJVhUy59W+4z3hKyUy/oRru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 16:43:39 -0700 David Stevens <stevensd@google.com> wrote:

> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI.

Who does that.  bpf, IIRC?

> If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")

Can anything actually hit this?  IOW, should we backport it?

> Signed-off-by: David Stevens <stevensd@google.com>


