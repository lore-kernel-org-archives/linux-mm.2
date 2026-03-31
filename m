Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B17FF60F1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722166B008C; Tue, 31 Mar 2026 05:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA196B0096; Tue, 31 Mar 2026 05:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B7F6B008C; Tue, 31 Mar 2026 05:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 522E56B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:23:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0BEC160BD5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:23:35 +0000 (UTC)
X-FDA: 84605820390.24.6F431AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47A3740011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:23:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWXHPvWT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949014; a=rsa-sha256;
	cv=none;
	b=VYcLadPSLoGL/67JjvMt4eBlLhr2lW7q87ujNEfAKDDGQuUiKubv7y1USUYGQFIQTRPN1w
	WnH8lo3I+5sK3JyvIIt9wCboTYTJCeP8Gou2/SSJuN42YLvrKlqzYH0mB6NgSs/e+YKOCl
	miZJMYHYov/W5k28bW4v3PNFGGXLXfg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWXHPvWT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Fa64KzSr6mJ0FOgsQvQKb4ZlP0+jTmA3Xxm9Yi2n4Q=;
	b=DgTeZZSHX63yHYDIOSVQ8e0Q9sanrEfICE45TxSZDmgLUj5W7DLxdVNYD+gI4Te0WQWs2T
	2swaPAh1hNVUcloXxwMFsZjdCXoEHBddzwtOe9NkPwjID3o892AUqogvIXOm1iFAtR6Hav
	zZIc1/z8Pjkb6LFfMvIEfGEEf1NKsEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3634B43F0D;
	Tue, 31 Mar 2026 09:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B8EC2BCB0;
	Tue, 31 Mar 2026 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949013;
	bh=DZoalaXDsEVeM0Ax8G7Y4p1iyVXciubggMHPstxJdjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VWXHPvWTOsXVqPgKgqy/3aAuIYHbb34PxPrQWaDkov23mCpqJs6NlSRh+dph649hd
	 e+8MWiREWOuaVmDH4IiVTzViJCfMWPn0vRaCHcVLhNyd71rWE+oGzmtHxpndEjfaGJ
	 ib94XthMSGL/K9/f45oGTA0BJ+CZilG4W+CMBVhmEqpWYD7iyt+Z8znthOg9rQQtBi
	 PwBkYAMs0fKRCgPUiACMThrOPBUCtLx+NLZhBExu8TG+DLqi3NZKaTLn2wJN+rsQJ0
	 /oeXzSpdaZsbKUZSOX7GNIEkw6ZnazXlfbZ/+YIHyb+weE4txyZ4HZ6DOrzJi5x33I
	 g1n84rD80/QTA==
Date: Tue, 31 Mar 2026 11:23:30 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: peterz@infradead.org, longman@redhat.com, cgroups@vger.kernel.org,
	akpm@linux-foundation.org, anna-maria@linutronix.de,
	boqun.feng@gmail.com, bsegall@google.com, dietmar.eggemann@arm.com,
	hannes@cmpxchg.org, jackmanb@google.com, jiangshanlai@gmail.com,
	joelagnelf@nvidia.com, josh@joshtriplett.org, juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, mathieu.desnoyers@efficios.com, mgorman@suse.de,
	mhocko@suse.com, mingo@kernel.org, mingo@redhat.com,
	neeraj.upadhyay@kernel.org, paulmck@kernel.org,
	qiang.zhang@linux.dev, rcu@vger.kernel.org, rostedt@goodmis.org,
	shuah@kernel.org, surenb@google.com, tglx@kernel.org, tj@kernel.org,
	urezki@gmail.com, vbabka@suse.cz, vincent.guittot@linaro.org,
	vschneid@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH 01/15] sched/isolation: Support dynamic allocation for
 housekeeping masks
Message-ID: <acuSklmoiS6veo-i@pavilion.home>
References: <20260325135707.GZ3738786@noisy.programming.kicks-ass.net>
 <20260330114348.102265-1-realwujing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330114348.102265-1-realwujing@gmail.com>
X-Stat-Signature: rkg6gw7h3utg9y4tme6yaitmp3dyzmus
X-Rspamd-Queue-Id: 47A3740011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774949014-587680
X-HE-Meta: U2FsdGVkX1/1LCfx7Ft//NwvnuHQkxNA2GkK1i3F5PAora0xMaulu0+yUD+MUAPGUueyeoeFup0DDgxQI/+uTJmKUeaD4Zr5KLkPhzwB0DijEUCtit0c02Om5Epww15SiUMe/ngGg94ONWC8oFeFuFLu0xwPKCBs91eZaENokUfb5O4rKJIKGH1ifFJGV6QtPBdYPLVn2y0f+vrFOm3U23zbIwiLtydEPeY0leemGFkR0/MG4wTCZBgdTw1ORsi9fQCkpjKwWfbiEydGOfG1PSYfVYLkc5SKyw2oTiAlgwV0JdzNGo9Ua6Pu6HeMJ1X8GvXJ1ugZkTk2AIy6Dd14LNcuQbvNYxSjKsvIM7Bd0/Zo5Potscdu9ut3Y9+57bz+/wj+QsulwejUg1b6fZNVSHbA65GsLdq7o2SkfD4mVbrmQo+an1EsoezcMP2OLa5La9gLG8ojTF4Z5KDCdGAD7VKhPSdgxzqtSGs39QeFacXx4ibgTB4alAXfEJZgnrT6u0PPcvxpR4w+0aXprkorZO27v0Vz+Lhcf9OqBpusOS519xmyTvnNFR6pnBvbwWjn36g+SAP+6V7biaK7Q1/Ey7gJKqUK22P6fwERK/2JrPPKUaC01QlKwo6xi2PKi0x8QmEGrAFkQUBFA0uGpDVg379fSUdNO59LQDIA4mfWMRxRsH96PjUJ7Sp+ZeOoph8waz6oKIvnqE9KmV9UA0TDEtO3G+7tJX8C7F7zohYXn/G0TZavDewTPPMWfkdB1a0xPAWgPcLJc24beoBBpo1J2WfFz4y+mf2zbV8X/bULLX+bJQqy4N3eGOpCgfE42BTvqw9eWMapFf8WBpvB+ShILkYy4HSn5LRjySWf//DCKCoSr0DcMk3hchu2emzznb5B7a0k+zpDAC/arUZs5bbHUT8ICl0UwtyEvIUU8f7gID56dlmL6zrXL/XX1ldB8GEdj5P19Ps1S5C2VP+ru61
 M9ZQHa8q
 RFNeMRemfnT2vZrvDj5tucqujmrCCf4PWOMjcl6VR8Un7DlQEfDkDMIczibWpa13Gl4aS8ak2NWaipVQZJoFKrHKiDMyJtmp9ypGqnKV5MeOr3/c/pCbuPrlJk+DudIhBIdTAPwo+gfftMT99xavPTGnTR+7VUoOxFVQAYWMoDctHZFswHsFx5o1pzN8Ss7U3lea/dnYaz3WNK1/zqFMV910sAMHycdq1+g2s+8dLiZxG3jCg65EbvAzOn/CLpv1QqapxMYY8uQqX1KzWOggMgxLGNhJGwfHCGlJWt82EtgLqJpVyYqdAY20Ghg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 30, 2026 at 07:43:21PM +0800, Qiliang Yuan a écrit :
11;rgb:2e2e/3434/3636> Hi Peter,
> 
> On Wed, Mar 25, 2026 at 02:57:07PM +0100, Peter Zijlstra wrote:
> > I think I asked this a while ago; why do we have more than one mask? 
> > What is the actual purpose of being able to separate RCU from Timers?
> 
> That's a fair point. For the vast majority of use cases (like NOHZ_FULL), 
> these masks are indeed identical and should be updated as a single unit. 
> 
> The original motivation for separation was to allow extreme fine-tuning in 
> HFT environments—for example, offloading RCU callbacks to keep a core 
> mostly clean but allowing pinned timers for specific localized 
> telemetry/monitoring. 
> 
> However, I acknowledge this adds significant complexity. In V13, I will 
> unify these into a single "Global Housekeeping Mask" by default to 
> simplify the configuration space, while keeping the underlying notifier 
> infrastructure flexible enough for future specialized needs.

More precisely we only need four flags:

HK_TYPE_DOMAIN_BOOT (isolcpus=)
HK_TYPE_DOMAIN (cgroup v2 isolated partition + isolcpus=)
HK_TYPE_KERNEL_NOISE (nohz_full=)
HK_TYPE_MANAGED_IRQ (isolcpus=managed_irq)

All the aliases of HK_TYPE_KERNEL_NOISE need to be renamed to
HK_TYPE_KERNEL_NOISE.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

