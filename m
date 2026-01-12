Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE6BCF45CF
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A88F6B009B; Mon, 12 Jan 2026 16:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5805B6B009D; Mon, 12 Jan 2026 16:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E616B009E; Mon, 12 Jan 2026 16:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36D5B6B009B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:34:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3E8F5D99C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:34:51 +0000 (UTC)
X-FDA: 84324616782.08.9718B17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC4A34000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:34:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qptVqZGT;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768253690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLGJg2qyT7uRUopMP01XCgNTPDLf6aEtTh0/CiVfI5g=;
	b=ouOGfN361nyGQaYm2CFzAhvAZm+CVcEw5I6GungyTp7eqYTPnDNiNGuMj8c7tU+Aq6IoRK
	bTB24DNgPzymkq5YcRDdtbHpjddTpolTl6Hxbc2LiZTtryU28ov2UgmZjORU27svHp5JLN
	gT71ws/RQ+13lwj+ENhayByl1k82lSk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qptVqZGT;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768253690; a=rsa-sha256;
	cv=none;
	b=GHK2WfuFmSUEPV+JbGVXMUqcaheS9VeNMwhXla3SDKgzfvsh52FddNNdQgrV54ZhdI2wqL
	TbeMKcHVpF8jMy9XQ7qOjpNGEY9y/pjSF9NnLjwIkNGEUW2U5aG+Xy8ypfmb4HwReqrHOP
	CSXaIOXPFAdQN7tM07Vz0H7jHTbK9GY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D92B42CEC;
	Mon, 12 Jan 2026 21:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F249CC116D0;
	Mon, 12 Jan 2026 21:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768253688;
	bh=9r8xMa9X/yGGRMfGiUGCl1DnzpxKkGTZr05lhBx3Fuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qptVqZGT+1fDu0cNQxrhf3GZG86xaiN60eR79t5T8VE8+jboA88I9+H4wWs36cDgn
	 WxvxvvzXqOxIPCEr6sQ67QhSGivnZxlPVbnisNAp2Fq2Lx2FOw8jD/GAGl/bjvO6wA
	 6XazLKC2q1ORoXy/dIBsw2qKYEbznnqE5D7prXft0h17ygA48CYGKQ5VUzU03M8PJR
	 nPRoNbTwzdiYvZ09K3eWroErKiVKPpP757Mf3asaHLOHCtf7eTT+iKFzXr7v4NDbwG
	 gCnGFBI+WlVAAippbwzuqtJRjlwHegTnT0EXMx3JG1F2iTuEovYgG0LImYZN60Cu5s
	 GiJXQ+NiC2dlw==
Date: Mon, 12 Jan 2026 22:34:45 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: Simon Horman <horms@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 13/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
Message-ID: <aWVo9em4C3f1TfOQ@pavilion.home>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-14-frederic@kernel.org>
 <20260107115653.GA196631@kernel.org>
 <18ee9089-8a08-44ed-8761-7c9db765cd4e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18ee9089-8a08-44ed-8761-7c9db765cd4e@redhat.com>
X-Stat-Signature: xn3zd5khcsht96aoanqg4g95sfnehfri
X-Rspamd-Queue-Id: EC4A34000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768253689-892778
X-HE-Meta: U2FsdGVkX19giACX/MTUI/higE5x/n82AnJjv5+UGJNivNlepZBwznHml38zIsYDN9vyG8TJwD8mcBygZZpd+fShD5o+J3BZ6j6wqoHqiN+lOQozvYlhpsmHSMwOGtYpagV9KZzZxJ0xDb89A7BqEcmLfh1kewTa85J9gF+AHAVt03m3MLhTtE5eDBUVWWccWQf8RyvcDz72rmKdSwj25cYE6L060kF3aOce7vOLL+PVPv026oE4q6JXdLn3ahKTP+vhtTnsOjF/WSl1bV90Y5rzOF5dCBcb/MoKMZ3gjImuLJPLRZ0QbH+A1AplbrEvlDcfDrr7Tg0gYxTOF8qVQmLyMyHyMBc+f/rdi9AaM1Cu8xq8eJGc5LypTZ+wNjf6IXcWyTkhq6lO3AlAVgKOa+CJwPzOaU9SBOLojLh4adhvt0BPwINs44f0wgLKf2VZ1QuW5/t/JyYN6YAmEspqXBq5D766bDIe7LJ26UZQzM84W4Z2mdVy/YZqRIxP+Q4DKJs5QCWZ7pR5VDs1DhvYTB6EQY9X1MG7bUp28riaIN64JKtU5uCJIDsdLZSWPI15FwyzPiNMEwl68lqPp0R0XjrhbiPZqRUDlkH46PJk2AIS2I5DPdYHSsHVcfclg4tXq0rVjQJ+z7MYrxyAiJnBtcSb8jAQuDv03pLTg+ChTRBNvkJ6OeRnh4CxRZj1dUrX3eIQYnZgaFVQZpLzOZpN0rqdlhQ57JkfSAIrGGh0niwJ6bApEm9l9n7EPk8rZoDK6JLJykYVGFWhnb9J4r7kfhfbkAFS0/OvsNUhVamRITugFEekgcPy91ONcQP7bGgARERMYsUoExhpJu3i+fmVKZXpt36N0eTHeTxOMphe2DaJ7g3sxCFFAaAuQrmz2DGdyJeR6V8n+OsrVcK5p8J2BPLSa5ajLphA79ChG5TVE/kPqrj0csUVTw8yqN/tXTZVs16WNJ5Dd9UEMDcIbnq
 I5HWlfAo
 wBrbbuycL77mCHRvN21K2PWwHacSMbquow9pnI8a/HYvWt0EnkKgSbbdQd9tSUVqFkjT1liDfqiw85aVAe7cfxUqYNyQK/sfvwy3SOD2++dEHBNhm9sRtdjZNXXV6vQgwYMp0we9/1vWuuuWl2nzhu980XoJlJcIlbw953QJWniSY3GEkjC9QH+vM0aSDIfr+LgBGQ4DUEIu9DG1k6Kw9QgKXqcfgZx48ArTP1Hfcvuhv+Nd+IGW9BzpM2lIhGfflMcCDZhB0oc2KKN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sun, Jan 11, 2026 at 09:45:36PM -0500, Waiman Long a écrit :
> On 1/7/26 6:56 AM, Simon Horman wrote:
> > On Thu, Jan 01, 2026 at 11:13:38PM +0100, Frederic Weisbecker wrote:
> > > HK_TYPE_DOMAIN's cpumask will soon be made modifiable by cpuset.
> > > A synchronization mechanism is then needed to synchronize the updates
> > > with the housekeeping cpumask readers.
> > > 
> > > Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
> > > cpumask will be modified, the update side will wait for an RCU grace
> > > period and propagate the change to interested subsystem when deemed
> > > necessary.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > ---
> > >   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
> > >   kernel/sched/sched.h     |  1 +
> > >   2 files changed, 37 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > > index 11a623fa6320..83be49ec2b06 100644
> > > --- a/kernel/sched/isolation.c
> > > +++ b/kernel/sched/isolation.c
> > > @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
> > >   EXPORT_SYMBOL_GPL(housekeeping_overridden);
> > >   struct housekeeping {
> > > -	cpumask_var_t cpumasks[HK_TYPE_MAX];
> > > +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
> > >   	unsigned long flags;
> > >   };
> > > @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
> > >   }
> > >   EXPORT_SYMBOL_GPL(housekeeping_enabled);
> > > +const struct cpumask *housekeeping_cpumask(enum hk_type type)
> > > +{
> > > +	if (static_branch_unlikely(&housekeeping_overridden)) {
> > > +		if (housekeeping.flags & BIT(type)) {
> > > +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
> > > +		}
> > > +	}
> > > +	return cpu_possible_mask;
> > > +}
> > > +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> > > +
> > Hi Frederic,
> > 
> > I think this patch should also update the access to housekeeping.cpumasks
> > in housekeeping_setup(), on line 200, to use housekeeping_cpumask().
> > 
> > As is, sparse flags __rcu a annotation miss match there.
> > 
> >    kernel/sched/isolation.c:200:80: warning: incorrect type in argument 3 (different address spaces)
> >    kernel/sched/isolation.c:200:80:    expected struct cpumask const *srcp3
> >    kernel/sched/isolation.c:200:80:    got struct cpumask [noderef] __rcu *
> > 
> > ...
> > 
> The direct housekeeping.cpumasks[type] reference is in the newly merged
> check after Federic's initial patch series.
> 
>                 iter_flags = housekeeping.flags & (HK_FLAG_KERNEL_NOISE |
> HK_FLAG_DOMAIN);
>                 type = find_first_bit(&iter_flags, HK_TYPE_MAX);
>                 /*
>                  * Pass the check if none of these flags were previously set
> or
>                  * are not in the current selection.
>                  */
>                 iter_flags = flags & (HK_FLAG_KERNEL_NOISE |
> HK_FLAG_DOMAIN);
>                 first_cpu = (type == HK_TYPE_MAX || !iter_flags) ? 0 :
> cpumask_first_and_and(cpu_present_mask,
>                                     housekeeping_staging,
> housekeeping.cpumasks[type]);
> 
> Maybe that is why it is missed.

Good catch guys! Fixing this.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

