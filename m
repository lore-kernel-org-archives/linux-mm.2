Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16674CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E958E000D; Wed,  5 Nov 2025 11:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6888E0005; Wed,  5 Nov 2025 11:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224228E000D; Wed,  5 Nov 2025 11:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1071F8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:17:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE0B81403AA
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:17:22 +0000 (UTC)
X-FDA: 84077058324.26.ACA7153
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E399012000D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:17:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0hjf0Ui;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762359440; a=rsa-sha256;
	cv=none;
	b=Ofgejmu6vk/OGyaPpWl/56uEPBP0/iYJ/yxBU6A9RNwR4EzWiwMvzwmGUj5OY9VGcqLovf
	+8Um0BsHg8rl6fKCKcUiLxtrOys1ISjGYN4MlgUm0txC0l7eXjaIc3954XkP3slUn5aHLo
	fUA/xMDkj1cttMApRPqBwwLim6ITTwY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0hjf0Ui;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762359440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COWxrb9LS0V/QZx9QvRUsCiIJ0iMKWVcJzYfBuUtJQ0=;
	b=EFmGWV73K25tHV3NUp2/EwFlRq2ECBYIlVAk9+yK5jGMuSg3GKi8ISQTsAaziCLIve+WHA
	+azaiu2iNTDKQ7mTSib3R1S2OgATrrdkuoMfaXvcRRx4bx6Sksj2slAtqqJxIZtFEqTnO7
	Ihbter/URqw+Wk1jQuGekcf+NanR0xE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44311601DD;
	Wed,  5 Nov 2025 16:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA00C4CEF5;
	Wed,  5 Nov 2025 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762359439;
	bh=m0WmoCYyOXZpK7uUlcvblqPFNrYVzKYbQ3i1eOPl5Zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l0hjf0UiodG9bvlzR0teTF7/EOA6sdH3lJdRLlau9I8A/DseQMnymKV6dDPaF700i
	 /GM4BkXlPH1RycuSsw1W8H9JlsG+Bpucpt9ON/Yb5Lp8BhsF0xHuIPaLrfAj2uEL5x
	 FGHRWbLzd0GHQgdJxbcv9AuCCM02jjoLln2tMRrhAU4O51K57/fzGeuubEOv9trZh9
	 vwOscUOROGk2lS5YeTqltie7TWPT1TVeiQnqH89qkQQHLnjKNmuhBQSCx2JZFrhqQw
	 s6AEiUIsphHx7/SDFAYdbTpJoHq3d0onR71up8dRK9b/ZyB8C1jktq8jhvlYW0LWY/
	 sPiObTTJWLXrA==
Date: Wed, 5 Nov 2025 17:17:17 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: Re: [PATCH 14/33] sched/isolation: Flush memcg workqueues on cpuset
 isolated partition change
Message-ID: <aQt4jT9qqP_l_ZSF@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-15-frederic@kernel.org>
 <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
X-Rspamd-Queue-Id: E399012000D
X-Rspamd-Server: rspam07
X-Stat-Signature: zzaspef5a5habnz6b18eeb31hhghxdxm
X-Rspam-User: 
X-HE-Tag: 1762359440-4983
X-HE-Meta: U2FsdGVkX18dcAM6ggWqI3V2w/bzfSACsF2bdntB5Ec2G1tR6/KQSz/zafJQPnHpN3wtUtCKoKhJh0/J93Zk0chEIfAZWppMjG/KAcoYuQY8ZOg47GLVozpTm6jS7dDTtmJn/Xi8BTbwAaRiTPAaoAXLJlgsJyCEiR/YjfOY3FDcWfBnKxHssfEvxr4mUPTNyDSvu/EG3g2O2cqM93JydJa+5/738Srd6UsnCFwreCeDI1d8F59UUCEoDEYvmU1DQ9jSjmKbyQRXUSJDgL/4YfEyXr+mircjSCOmPD0rrXJsBul/MXQrNwmrVVfPk2fohi/Eocx+gqnQZMTIIwVRHgtbLIUkFJSIdqkerjItnMZSbCGq70G4shEcRf6ZD4QDmUqppLLoPH/yXQv5j1Bo6pHVkPOqhlFlOhiMLHKd5Hyh82hZ9d0QvTf5rF8aaNq9g6tYJFV8FqPADZEaEmb4NiC8gITtZCWvp2rl9EAEO6hjL4tWufO+GufOI4toa9Ojc8tcU9kgfhTspN7zG6HZZ/4KbbwOd0EMr2hG5+BOnxdetnuBpH6ktCPvBMlYcjXiRXR3h8TvDlnFs5RncLDkqf9GgoZPV7/6K6xOFPP72NoUva8eUaAoXfPB/dGG1SFJOXvhrSPHvWueVvyReMc/MDym/FGFasdwX5JlD7lgc3ByKVNK4MBAFP2Xcniyl+q7OOhnGYoL8XFZkgjNTnS6JKw5gPiocl16YTWkDPamOXVMRlOAyjxCbyadiodv4XA252iSvZ7GjsmRXgVrGO3lFIS6izNIfoSzo1OY7Lyxk1VksFe03jJst8UN9XMZbGcO1UTWa2AG0uJp0ot5K3z1yNC6+HlqQIohSCkPSOW69z+Y4qFohMkTquUJdPbgiztG3aAVJQJTF7DtoUNK1LcH4er5Rtq+5BH7kB82s9XHvR0xAu10Qse97kzWQbjMqmd49OgpprnbIJaqiIWVJdb
 zKPPCWep
 cN+L2RUtdAPazSZPF5QdBM/bR9lJWDnpsCSRxvvuhcyG4UHRhY0+SKR5Fo/pBXPEpOUe8oZSPcKPVVSEYAWY6QPbIDvEhoKN86JpDUhGscUT4gJc5gLbjSI5qDjE9FObZTD0qe6sV+Mw5gJxxAhaI8SxiAWCktjhuPFU1E+qSYHxX4UXQcFgLzqwerpdAJRudTLCMrHJoOP3ZzfP3O3+3phX1XcmLnQmzMGCyTfxI/0NM8uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 21, 2025 at 03:16:45PM -0400, Waiman Long a écrit :
> > @@ -5134,6 +5141,9 @@ int __init mem_cgroup_init(void)
> >   	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
> >   				  memcg_hotplug_cpu_dead);
> > +	memcg_wq = alloc_workqueue("memcg", 0, 0);
> 
> Should we explicitly mark the memcg_wq as WQ_PERCPU even though I think
> percpu is the default. The schedule_work_on() schedules work on the
> system_percpu_wq.

Good catch, percpu is the default but that behaviour is scheduled for
deprecation. I'm adding WQ_PERCPU.

Thanks!

-- 
Frederic Weisbecker
SUSE Labs

