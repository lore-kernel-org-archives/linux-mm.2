Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E572DEE6440
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 13:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE5A6B0088; Wed, 31 Dec 2025 08:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CB36B0089; Wed, 31 Dec 2025 08:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3887B6B008A; Wed, 31 Dec 2025 08:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24ED56B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 08:45:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B913216011B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:45:35 +0000 (UTC)
X-FDA: 84279888630.30.4654D03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26556C0002
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:45:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vx1P2FfS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767188734; a=rsa-sha256;
	cv=none;
	b=dQRowRrVEeBjNfXOGvHaFppQ5qTmCFOqO4Hj49isGaz8JblK0WkSfpUmTB8WNCYuiIJcfX
	GHMTDtxcJxHGq2RS9/8KVVurPfOrhF1+H0OAxl4s1P/k1bGxXg3Y2VHDLwozophVbqTanH
	fMyEL43TfxRsJzy9qIImay++mWnIkbk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vx1P2FfS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767188734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi5I+SfKE4aINlKxAmgMaZAdY1SDU/JEFetaMG2dxZE=;
	b=ZRUJvjhpR0Hl9PLRKF3u5Q5vwKNxK4QLweS0D64vgmH1YkwKjDiUvpA+bP+Q1DtRTxG6Zm
	f77sfNC/v/+GhRbXZTCZCY+l5Ur3sESJ8MRDMtkJ87vNtZoX/2zbqyvKU7XhbezspJrGRQ
	k5wS5Q/oRIMb5OLM3CRL1/mjO1Ps8cM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 175B860008;
	Wed, 31 Dec 2025 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F4C113D0;
	Wed, 31 Dec 2025 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767188732;
	bh=Y5lTmiVqic6uOses6/RBPW3lvTquV7zqhHPq8aQw34M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vx1P2FfSkiM9kppodGYA35GpPxHALVz4tqlXMJw7IRuRoyhQc3Qx9tILc+uax6TC7
	 E9oNlkBRd2Rs1GjCPqIEDj2UtwboDm+nyiXhVS4cpKvGjduLnDZUAkhmBouab0kgAE
	 9iFHz545GjGqBURbPFBcct+xIbjqRKoEQGe2nWxgG+6p4IO8R8Au9Jm7Y9Krmwprxc
	 HS8s1ug8q6nJc7bHQCVkjEoCysFcYtunXpn0pt+/iwuaDQ6zXF+kyUJavHNXJgl7UT
	 Y4URPh1rDmzsjeYecL3DpbBHbSEjLZfzNZGbTbp/0Hdxg9F9Won6RzlhHNOiKEJBL1
	 sy0xjelFd82aw==
Date: Wed, 31 Dec 2025 14:45:29 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Message-ID: <aVUo-csI1gqZL89O@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-6-frederic@kernel.org>
 <04708b57-7ffe-4a97-925f-926d577061a6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04708b57-7ffe-4a97-925f-926d577061a6@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 26556C0002
X-Rspamd-Server: rspam10
X-Stat-Signature: tqjtmeh9dp8d6xppuu8mhnbppx358ktc
X-HE-Tag: 1767188733-379437
X-HE-Meta: U2FsdGVkX18l1MGPClikV3tMgQizJ8vpdzapPbwXcNDUj2kyhW+HOiXkb4CgYRBa6HcZU84n4MkvJUN5+lxnhzt8XGLxflC21hSUnnkYIs52gNN+jBjjv8vlINLsxr+XKu9Vup7e4ZMon6EJaOsjEcayvLlePmttJUtw/z29HG8w39apGjpOfQWCOd+4vyHAltNQTloyXJeEKFY0Yv4kk6rEcZ8zsUciFUV2l0vxBvQTslUM76SwW+BD/YWP6ZV0HLYSMgJFINKGFUTZOJVS+leo/lrSY3le8/NboO2YVm0jzTCa3UipaIxMhp33bsNmYjNEXKoaMrGuEtELGSFDlpwhV8Z718ySXq/d2ZQYv9g0pGecfo9/xgIibNUpNgOAViUOZb2+QRVtszR8rA6GetS7nzQaK3hcgYKA80S6AOLRmxs3oKg+IFF/V82nY6sHYcZxkKfwLw/Ups/9PZ7o6gydZAcI9ISzOwQ5/1yq8grY4Rg5/jlhxaWN0uof0GDxk6bvyJeO1PASZ6VvQWs+7gbcA+Bf0tXxcQwEO/lReGHbIL+K0FRzGi7XDYsHxAEXmHEc3neUwCDPRFupXJwVYFjINQY3LRuFuhLTqr/ggIdxWehR6/N3OCsgeAgDyX9ngjiQEaLpJn7HFAfIq6blB9e7xy9wOCaogD4AYBqngg8qwwFs7hkHccuuFM0IYebN/SRWHURKT40XySU8o50Cks0ZoMygY4Mos5ZyzprVZcj8/2GBBAMaHdvWcQCDfC2D4Y6pzvu+vgcDXlVZwn76zjX487nlN7PFvE3hsCaFBxsvx6b6DXC7ph//8SXUkn1EtZ64XLZhpwBjzzodJzGfMFQ5FfQO6IPNG5nKZrmXOo+tmpbEezoBvvY2CQInY0wYTeLlmbTm9An61Q9I6emzI24s4wo13waq0uFHeq+6sN+/lX7JNrQxz2l+T0PoX7x2ycDLSL9FwlpOxFUPhzO
 ktsz2pyf
 zM3LDrLEbBgbf4DuIFNYaHaVhJXUQcYzABpxUlSnK7prPjCv36+aE0bxOcSZqjcDdSxVXPeC0C90yVXObyXKX2KLTJsVZiNOgrv9nugFnC+KUI0ahc/8l4tBPGii+WP3yiIJFxuaK3XvLiN2Hs/TFbpAIr/krrAdHml7yfi6Sj2uTMNivwECROT08YqXI/DUR2jsM3hc0yGt5SxwI5uc+Nk3IjRGfLEJyTKK8tGRnqENXGxWLkjPYQ1v6ErADVqs4BUD0bycXWw/OXs3ynbNi2ybEEUqW3aU8Md2SCUxAPXoNBLeNwBdttdFWn2xwj4WVn9Da
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Dec 25, 2025 at 05:27:54PM -0500, Waiman Long a écrit :
> On 12/24/25 8:44 AM, Frederic Weisbecker wrote:
> > HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
> > but also cpuset isolated partitions.
> > 
> > Housekeeping still needs a way to record what was initially passed
> > to isolcpus= in order to keep these CPUs isolated after a cpuset
> > isolated partition is modified or destroyed while containing some of
> > them.
> > 
> > Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Reviewed-by: Phil Auld <pauld@redhat.com>
> > ---
> >   include/linux/sched/isolation.h | 4 ++++
> >   kernel/sched/isolation.c        | 5 +++--
> >   2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> > index d8501f4709b5..109a2149e21a 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -7,8 +7,12 @@
> >   #include <linux/tick.h>
> >   enum hk_type {
> > +	/* Revert of boot-time isolcpus= argument */
> > +	HK_TYPE_DOMAIN_BOOT,
> >   	HK_TYPE_DOMAIN,
> > +	/* Revert of boot-time isolcpus=managed_irq argument */
> >   	HK_TYPE_MANAGED_IRQ,
> > +	/* Revert of boot-time nohz_full= or isolcpus=nohz arguments */
> >   	HK_TYPE_KERNEL_NOISE,
> >   	HK_TYPE_MAX,
> 
> "Revert" is a verb. The term "Revert of" sound strange to me. I think using
> "Inverse of" will sound better.

Somehow I thought it could be a noun as well. At least I wouldn't mind if
it ever turns that way.

Fixing that, thanks.

> 
> Cheers,
> Longman
> 

-- 
Frederic Weisbecker
SUSE Labs

