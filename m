Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AC3106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9626B0005; Wed, 25 Mar 2026 09:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0EC6B008A; Wed, 25 Mar 2026 09:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDE56B008C; Wed, 25 Mar 2026 09:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F08FE6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:58:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91AAE1B8B64
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:58:30 +0000 (UTC)
X-FDA: 84584740380.09.6712A1B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C817140008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:58:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JR3OsthR;
	spf=none (imf23.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Wh5nuRIVjmmR3h1DHbl/7y/dEHsy8Ic5tYZGLWZU9U=;
	b=cnNLT3JrFBYZgVhOvF0DRV3yohYCvGhoGzWuyFOZL2xlPBHep6/NdZcxqNaKLQBLDo/DFo
	E39nS3Xa9QIUOvGn3qi6VYPGpC/IRzLxOKOOSd1lWfVo7WEPdbj1gzoLBgQCF6KTBeO1W0
	VWIAWz/fAjCCrpxlyjcBOyZEubEPbMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447109; a=rsa-sha256;
	cv=none;
	b=x3aISJ4OWWyPUXiDujnBsGhBrjsGJ9H+umbnJF6NydwKW/t34Yi5UPcREEDNmzYZnBHoH1
	n/Qc48h3mTYrWMG2KEoEJneizVbpsOtVzJEx+wTUUcSBBcyu4xswggsqpg7sV1kNb1CzXm
	klTSjm90P7Ggw2icokvh0Dsgp9t8Gvs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JR3OsthR;
	spf=none (imf23.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0Wh5nuRIVjmmR3h1DHbl/7y/dEHsy8Ic5tYZGLWZU9U=; b=JR3OsthRB0FWUAQKcRzH6GOUYD
	G0lJgZ6r49/3yIaaPiy0bfMepMP+55l5tq1iETprIi/AociiRYj0JfsoypiQx3Tg26VUcFGELYHHS
	ILSSQoxQaRwl9QkCPKJrSYPQp2ttw+Q+8kEyum2trVSUYWs5Pfu84pm4VP5Ab/EpNNEn+ikvsgomU
	CH/xmi7rSzUQyoaKTRDsIE7gYzYiu7XcOtLY1oAVwLv6fQO4vMmsOBNNQXyhPlKHMsx3rcyM74MWM
	7T3s03vGBYY1zVxVPvSjn9SpMc4jFxqbYa1g2+Klc7hHBqXO1uUB7CoeXfOUSrCx6cJ2wfHMk7S1j
	v8BKDhIQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5OkY-00000006Hv5-1bO9;
	Wed, 25 Mar 2026 13:58:22 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D1C15300400; Wed, 25 Mar 2026 14:58:21 +0100 (CET)
Date: Wed, 25 Mar 2026 14:58:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 02/15] sched/isolation: Introduce housekeeping notifier
 infrastructure
Message-ID: <20260325135821.GA3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-2-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-2-919cca23cadf@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: rayxxxyqkgh9fd68pb3otgue9tepbyub
X-Rspamd-Queue-Id: 8C817140008
X-Rspam-User: 
X-HE-Tag: 1774447108-217999
X-HE-Meta: U2FsdGVkX19CughnXFX12PMpp2X9+n2mhAFdhyo7Ez2rzgLbIe9V1Uf3rx/BVufNVpRuBJSe5kHIKK2LcBSOP0/BZEN2d0bcQKl3OBJikK8RVzdhAlxVngA2zsh3GhzLSbHee6TTLRuArRRep9oY/aRbUmKNHE+LNii1XoWLguHcXI59tyCrqZz3yARoqNiUyr7jwCuez/7AmmbgaAveAfcc0mytmNVI86o1SC/r7mc+Sv8ep3Tyw9GyGBHG3mu4YuID0VrrRjQ3rZztouJNFD5+z0623I0Kd6JhcpKMZ/YI4hqB6nQ3fz06xtSwflUZRFgBq9tRHo41N8LigLDr5wj4Fwp3vUxTqApqcMKZRjWLf6uxvuK1mOfyPYQCPVe1irnPD2wXrTxwpgHMHQopnW65QLZOm1qTpY9nJ6w+z9CQICIBX5h0Iwh4dB/Y+kZTmFjCZFrkq6ki15ItnyZpl4ysRhe/hO5/NatVaBcoYGMwjDX65AjKQ4hkSmnSKOuradfYZJ0V4rSdl9iLVEWMEjt0k6tync35NRBEl4V3OAD+GEQDo+1HUfQ8iKki0PVHz6329VsfMwUvTt8t79sSSAp+v7gVwlLWnFT6K/elrHYGshKLchjEmf0+OA85kw5hZKG2FG9eLMSU97HotqAvuUR4OxKFxMQvioLlKtoAPPlWGmj6eWOfc9JmfFfyANYkG2eT6BpvjZyBDBQOZSDneToCB30P/BAgQyyVBTgGE8+Z8BSAM7LrkjVXKBNzXVZhvKkcmn8yJU+fHtYrLiTq8vqWLqeA7hOQJyQH3Cye2LtHXFI7HLdIxthadYj0SkQIVCdX23wlmcXNEqQmESDrOD7+Gao0GZE5n79LFzl9ga1Wfjmse/tX/W/FS8Tk54nCpiesD40VSDcrplQN3E0fVxUEARXMyfZ0hIPTH4tbBL1SHkT0K9ya3Q0mwe5jUnspuYdai9Gp8e5wE6sL0fS
 t5fjryLG
 HwyufIflBC3plVx1B7Z5o7IKd41zmQTe75tEd0wu3gmaK39pDH7MCiB4Rife3lBWhvqGSycjXrhqKyw8XHaBKpYDj1BjLFvKjt4sIx6QL6B1nHh3ZWFuQJx64jM18okWILAePSQ5F/NhfV3avsc6PxUjfHiWpQM3TJHNdZ7yCZsXQKSDWK4LZqt6t+Xhsh7yhyd9q8t7TiWj/AZ8lB2gMK7lZ4p9RuRL7uKr7hPA+Qqc++B/l+NfP/T2JZJdg92lrChF2cK7msVFWCDw/GjNpebZIUhpMmYlUYPwd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:33PM +0800, Qiliang Yuan wrote:
> Subsystems currently rely on static housekeeping masks determined at
> boot. Supporting runtime reconfiguration (DHEI) requires a mechanism
> to broadcast mask changes to affected kernel components.

Can we eradicate the whole DHEI naming please? It makes no sense.

