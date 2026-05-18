Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83495CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3FA6B0099; Mon, 18 May 2026 19:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B5B6B009B; Mon, 18 May 2026 19:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1BC6B009D; Mon, 18 May 2026 19:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C94E66B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:40:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86943C33FC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:40:24 +0000 (UTC)
X-FDA: 84782161968.02.E6D740F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E6595180008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:40:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a+qmVCE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147622; a=rsa-sha256;
	cv=none;
	b=H95NXQ47j+sGXlfRA6LW7hfkoWgaTsoAes5e5izlosyjkfSSEm1B8vTRSmTQXadrlgNZeT
	ezNgXOUqwtj8EXMazZFPhn1Ogh25oir9hmaOgQ2DMeKSeASaE+yLMbh27vHylSegxsUidg
	ttZNjCGeePnTbUelJVMvjWYjyichW8w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a+qmVCE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gx3YB7Lt5/HCCtgvPaArI+imXH3dKZ3BgtyD8Q5CUw=;
	b=35EmQ8+ariTS2JjGGQ69rSUv5IgcntU1PcBOKKfTmcWQ/KQS1FhiB+pdSJydcgiiFPad/G
	oTYrqlT3iBn30D2/A4gajwS/Uy747a/My20378dyljKqI/SVmBSnBXvABg1VqtFqIOAYDp
	K5Kl/NBkpGHnrkTl5K2WOMr6G6Ms1uI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55D6E60120;
	Mon, 18 May 2026 23:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47EC2BCB7;
	Mon, 18 May 2026 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147622;
	bh=C+JMDHUVVD60YcGR5zmrR9UL2s11oEuADwRAF7SCQWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+qmVCE/3+9Znr3QmO2vIumpfiUM6icTB69SyrJ9ZYeM+2i3C/j+CGAFqyhQQwTQs
	 /xY/55qNdEkUeyVVj8FroHP4h2/bbJuJ+J82p8nSNslAZifUst94LkXHdmD03AQBiM
	 RIqMwWoykmJwf5qGtTs3UmkBwaK6xOVDJv1KpbGmKq03E0MWjKLXKoyXbO//NdMub3
	 SrrlVqM+/xZl2cM5NRqdd9PZ79B9wZlB1PQa2myFMucvBw7ed3TbrG7tJx480iY10O
	 Ak3CTyfHHx6KaXiuiM6JmnT1MUEjRWAUsRX7fVwUADqzz5C4u10JtVzLXhIxy1+LXa
	 ySbcTli2Z9Xvw==
Date: Mon, 18 May 2026 13:40:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qing Ming <a0yami@mailbox.org>, Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>, Hao Luo <haoluo@google.com>,
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/rstat: validate cpu before css_rstat_cpu()
 access
Message-ID: <agujZIpmHm8n6-ox@slm.duckdns.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
 <20260516070849.106141-1-a0yami@mailbox.org>
 <64f59b64664f769661a8b8cd587c85f8@kernel.org>
 <agubZePrBmStHxhH@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agubZePrBmStHxhH@linux.dev>
X-Stat-Signature: gms4xbkqfybsbt8pbbw9bdunjwczmh17
X-Rspam-User: 
X-Rspamd-Queue-Id: E6595180008
X-Rspamd-Server: rspam07
X-HE-Tag: 1779147622-27425
X-HE-Meta: U2FsdGVkX1+KgH5olZAGfYzqEIarm5yT//YhaOO/vRBHQXKb0+/A3ek6HFWtpesp+4n7u8NUjCNn4WnMzNLevLr7KugSHltutGh6fvBA1y78mpi7GTJnFzeR36DqW09p97hvM5oZitTiHiWJADce+h/bZvrvxd5TQGuyE/EY1RF0s+5x8SP5kObuS2MmAt2yRQm+CwTpPMAiPqf/IH4u4yf/ai3o/jwI5nTcLJbk7sGaXCGhZUAsbwGBw7ljYzC/cHgwJwLyhf297PHDRdL5QRzmoxmvk/bH7ratfp2BYCf/7sdhAUJI0jSvEdY7F1lNWInEszX0etsvGNshflT0MvZqy7Em7K2JxjNeP3S4qQIcxoeEhKkG1xPFxWYmgSLAcLfTCF3nXtVBsELacYtnSUCWs7Yi96fqzqEiemZqDdGZlRinpMPR9g42DXUD3xTK6n9Ja2n4wNLpr3z4MKvbAwgLVi9HK2c2572hJE55APpfQDAUX7hsLRtl2fI29IGRvc0yLO1K+LRrCwW4DQKlFODF3YwnIDL48RhTu7vFCokewGcatI+UrlIxpDq0tXcNOm/N5SEuWHBKUx2AuenVdJAv/Pu1gZhJEUZYul3oogLqstKOnNnNVIVRFg2g04RZs1Z9e8l0N8+bfRVry99k1bomMBs/Uz6ssWIuRnpqXm44k205Aa80C+G++74HDDNms0qWhzexU2m7f94bkON8CwEuglVopS8DXZDaohfsgzgbmqVDvf3RKJUQ8au4megAMN4pRAofFhbMWI0Y769HD1uAAFrynUpyPKEB91LkgBWrtiGtEahuDAQQAARlsgIkcM43Wa0U/n8YASOYiWehImgyDO97c/+4IMN3MP1Pvcp78nnvDuNuj3fY1TG0dQ20gEdxwut6+++olrAeJyw5SBNx2y+INHE9JsdlHBrXHewl4tujjlP5/fnQImi0IdxGPD+EdNEU5/TAOUDx2A0
 vWC1KKlp
 ElcEp1h3XlHi8qiztSTTsa/1JD6W/RulXGHjybGODzjYzXHt6OpMG1OjX/GDR0AFXHVdGLiXO3egOODXUH6qdptZFvJYTM6NF96jDBMouOFdCbRIEsubUbn0Sh1TbWFttvLwg7hgvyp1M0dWmNxjIH1r48lgbKPrRLKf7VwOdoGZRXQAMfPdeq6pomg/G4C4X0Kcohq65NgPJk+C9sDo4dXtJJAqSdWtAPVyzVrZjJsiZSmHjA4DgzUzyKTKPxlWvz4WSnfBzmyryhdXwqP1TOtqSmhwoeoEJZzsb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, May 18, 2026 at 04:07:44PM -0700, Shakeel Butt wrote:
> On Mon, May 18, 2026 at 09:36:36AM -1000, Tejun Heo wrote:
> > Hello,
> > 
> > > Qing Ming (1):
> > >   cgroup/rstat: validate cpu before css_rstat_cpu() access
> > 
> > Applied to cgroup/for-7.1-fixes.
> > 
> > In hindsight, we should have added a separate kfunc wrapper from the
> > start instead of tagging css_rstat_updated() with __bpf_kfunc directly,
> > which would have avoided the rename. Oh well, it is what it is.
> 
> Is it frown upon to change the kfunc signature or remove __bpf_kfunc from a
> function? I am assuming we can but better not to, correct?

We can. It's just a bit gratuitous and causes unnecessary churn. Let's just
leave it be for now. We can clean up later when e.g. more meaningful
restructuring is necessary.

Thanks.

-- 
tejun

