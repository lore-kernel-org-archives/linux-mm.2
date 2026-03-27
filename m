Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD5810AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAD26B00AB; Thu, 26 Mar 2026 22:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAA66B00AD; Thu, 26 Mar 2026 22:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7BE6B00AE; Thu, 26 Mar 2026 22:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC9F66B00AB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69650160FAA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:14 +0000 (UTC)
X-FDA: 84590225748.08.1536BEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0DB3140004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w7Hi+7qA;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X2pCWBasus16ui+FVXT0F/b66xxWz/JgQNeJO8UKAY=;
	b=34wQaskslZCkWDakdeJjKFigS4AKPkeVMAOXr8A2iohX3I0FWSZ0jm1an7xPT+s549ux0+
	915fJgHK18PHxCm4gzYmv/SxTq2ugGaFLMdHaYZjuiBLlNbV549UCZpNFF4hJeO46MsVop
	PWFUmaHM0f5ovfsQRHkU7Vr1A1qjmC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577712; a=rsa-sha256;
	cv=none;
	b=flkjoZxvL/nnWfbEllSobRpKwH9PoaEKVw9nm46Uajf6eeoXMPNFCNx6jgYifst3IxeQ2z
	RQSGgp6vyVi5WijRa9CSgF+900myrRlFGDGCU/nTTSdq+S99urj8c1fteQpJXmoD5jz6gB
	QQfOhW8YaJubXUyqoS84INoHmZvdHa4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w7Hi+7qA;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01362600AC;
	Fri, 27 Mar 2026 02:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED527C116C6;
	Fri, 27 Mar 2026 02:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774577711;
	bh=BHxhXRjS1tMbmoYRWWjDkH7nhTRR2Z3aOfr2xP1RU0U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w7Hi+7qArGNlgHXSRxaBfya7B2i7/oIuumZ/fcLv67qj7g4tbFZfOUR+D2UFlmcw0
	 wzywJ+r5MtK6tJjDFLxdZarWoa32yHo+ZmKlbM6s+rsNIr+FLHrPJD0FK57Ie/Kr7S
	 5jkStq8ANjWIPVfCLVbP9Yvt5MsY70yTZ/RwI+PQ=
Date: Thu, 26 Mar 2026 19:15:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>, Arnd Bergmann <arnd@arndb.de>, Arnd
 Bergmann <arnd@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Wei Xu
 <weixugc@google.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Kairui Song <kasong@tencent.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Koichiro Den <koichiro.den@canonical.com>, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Bertrand Wlodarczyk
 <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
Message-Id: <20260326191510.31210c752099a708fe445d80@linux-foundation.org>
In-Reply-To: <CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com>
References: <20260213123902.3466040-1-arnd@kernel.org>
	<20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
	<b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com>
	<20260213092336.c2b0f2d1be17f1e2e9856f11@linux-foundation.org>
	<CAJj2-QFbx0iRMWQThPDfDJ04hNuZL0Xu-bGGRqGO4b3KgumGSA@mail.gmail.com>
	<CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wfypdtmy77iz643hgt56x74isq884pxs
X-Rspamd-Queue-Id: B0DB3140004
X-Rspam-User: 
X-HE-Tag: 1774577712-84760
X-HE-Meta: U2FsdGVkX181VhnhmkVXxBW4RggwYQKzfmZyD0KWkHR0vY1DhcBXnnnQ9TC8CLKy7FkyPPCl/FXe3AjzilMGPkTg/NK1Pl52p6HKPYUWnJBiXS/kEh30NfgUVwsS6eOUgznaq7emLkiMpkTswSjZOjXGjQYxoarvCMQNbtQbrrQUL2+XW0Ww1eNaPS57vKZ6slfQ440PAkshuu5agBQhjc05I2IDqSZZqe2KTHg8ekBgmu5MdpVTkbUR1hCDF+//bawVcxa5dL6xmsL04kP8iiekoqu+yz1PVRPqIe5wtCimXRZrs1tcAysRZ7RC81395H3d0S2fsN5rNDw8jh+FthWQK4WWHGjJp5xGBGEIn+M+tSeiKnc7ZdFNdnQex+Qj9azHTSkvcoIMjLcw3SZFEOBnbyH1DyjINFrYd4LeQ9TzirRV84P7WqwTDM0HZHsvUVI9fPSeVaKb4VhrGGCTSpdO7eo34mOzER7vWwa5loWHD37Upq6wTfFVIAzoKJdSU/FsWJvarIl85HzkwhlFFS/W0XLAS8AEX+m7VvSQ07WuoJKNSAS11ts1tAROvIqAThwogglZ9LJIV3gPAeU2zjNXCqQcs8VtfByOBT45VJGLjo5S4mnWZCToedDHvZ2jWUe5H3GDNMUNAnEoL81Se7UKmQfGE5say/TSnfhvU5lKoXdl0wHxK50pqtFc3ZyXBXIxx1Ks0/z0Uu+/6TVOCFgrwf9dAYWVexRARu+K9mWs4GiP9/7wKx88jUGPl6dK3k+H+4MjRuR6fZ8rNpFNI8MfpJ42SXbvlJwz3XFOqEGWOJT6DYU8uwmUscEsdbvB8MJuT2w9Ji0hwBfm94ZRWWi8yZPPcl40HnPweiUND3PJNHOTytvDuzQYa+sBY+bBvQRDf5JjJqEQfbDPbTauTVHwRDO87ZHMViU4JQUq2mUlz6vqh9zZ7B5NabKnibTHqe4EqIWlZkKEWP+V4Wx
 jiq1+ScP
 ry7Xe0X/b/0hLNqW+Ge/5ILk7SozZOjE5CQZML0293PgZT1SPXMiybvoAeU4rzkrhhhylA/XiLPJr+Ak/bvFAVh4KXYG+HNk02Rb4L50qiT3uQCxLqVkLHuKd2u0yjvCYI4x136Qb4FNaaGevOgUlNFERz7e/QNmC8n4IhtN3jHAD2MBTDjM1fIK9BenyVkqtwg5ypFar3GNqmr6ONwvqzaSJA4E1VvNCq68h4e3o1Y17NKRzlMFs0Lj4uCtYDXCsseJVI1BtspFffkWnumY3+lPnFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Feb 2026 13:22:01 -0800 Axel Rasmussen <axelrasmussen@google.com> wrote:

> > > Let's see what the MGLRU maintainers have to say.
> >
> > I went over the various cases of read_ctrl_pos and couldn't find
> > anything wrong (let me know if I'm mistaken), so this seems like a
> > mild compiler bug we're trying to work around. Given it's one single
> > version of gcc, I'm a fan of the simple `struct ctrl_pos sp, pv = {};`
> > with a comment.
> 
> Agreed, that simpler change with a comment seems better to me.
> 
> I don't necessarily hate the refactor to split up the single /
> aggregate cases, but if we were going to do that I'd probably have
> aggregate_ctrl_pos call read_ctrl_pos to avoid duplicating the code,
> and I'd want to consider marking read_ctrl_pos inline.
> 
> But, it does seem like a large delta just to work around a false
> positive warning. The simpler change would be easier to backport to
> stable too for example. So on balance I'd prefer that.

Thanks.   Did anyone send a v2?  If so, I misplaced it!

