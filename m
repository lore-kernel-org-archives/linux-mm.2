Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3726FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8091D8E00BD; Fri, 31 Oct 2025 11:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1488E006C; Fri, 31 Oct 2025 11:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DA18E00BD; Fri, 31 Oct 2025 11:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62A688E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:36:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F18E612B45B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:36:06 +0000 (UTC)
X-FDA: 84058810332.09.17815D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 27EA340018
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:36:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgZioyMf;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761924965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7Rlp07E145mjICdfP0fMeKyTSRO79dBuZu7u2IiVMk=;
	b=J9D0io3W/Kry11JsnTSgyNr3jtd56YnaiLFeBivmhuEqifQz1k0mTDqqdqWuYYBjWGa0Ep
	W0ErWaWxZGvSwJQ3a6xz6C640tpoM/ncrblbEGPv3K2ozEWMTLEF5KMHKxUBMZbn+rz7dD
	v+v/TxCWeJ/En4HZqQPu/h23H6DJlvE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgZioyMf;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761924965; a=rsa-sha256;
	cv=none;
	b=U2UFW81+VmTZeQ+nuUVV30pmPFXkM8aoAqEbigGylpWCfpc8oZh2D0e7wln9NulFJXvblc
	Kjj829zg1VhM8gySGsiMMGGKOEBXSL2SgERe07oh6ArJaCFBlyLLq73zZoPD4TsO997o7c
	BThtDzLV7/3H7E4kWRIvBKKAmDcL3s4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EFF2601DC;
	Fri, 31 Oct 2025 15:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3AEC4CEE7;
	Fri, 31 Oct 2025 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761924964;
	bh=f2kdcTzIgflTZpNVJcpB/wXw4Pn7v3oe8LGnD3Ghpv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bgZioyMfejcWWV0MS6C05S2LbsEdxX50diKJLFbw9ByzTss1Ijd602OkOPk5VfJ9K
	 BRKcnvMU8FhGuOYJD6IlhqxkvqA74T7C11v39u1D+WoQbt6yJqS7412XtCYdJe0PHy
	 Ln62jNHD5VjGRqjBBZSBa4jUMaVRdwp5bzP89/ZWKaQCzVlnK86qZsU+w4X0SXlEbI
	 lRkg7pYEBULQLbHiEuqIewp4ucaxmKc3j/liAl9yD7UK/IyLDT6JMbpqc1UA7U21O9
	 xfmguuXRFsOBFWFtnYsZeHmVkddUjMRhYiHjr9QoNL/wS5AGPYJo2404lc9S1uCEeI
	 AAsxziPBgXXWA==
Date: Fri, 31 Oct 2025 16:36:01 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
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
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Message-ID: <aQTXYSyPS65nhkvl@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-6-frederic@kernel.org>
 <xhsmhecqtoc4b.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmhecqtoc4b.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27EA340018
X-Stat-Signature: ihdoqb7fuimxw1g14733k9omw9k18c77
X-Rspam-User: 
X-HE-Tag: 1761924964-563433
X-HE-Meta: U2FsdGVkX1+d4fWIsia3Q7B47wyRrn/CgF88nJ0Ok3mUmbxgV8HbSjQ8venjcMTatTP1BmqhtiEV7yag30OIh642esUBEbs2vDfAjpkRVI84xouqSWhcufJ3tnBymYCvbpkfrbWUDTu8fC94fzdBc3KYS9qR60Vv+jy824I4fN/NTu8mmbGGcB58ixs/9j1guTYuoIApQ+zUoJrgzJuW5cUPEF6psjM/vA7i6ukqhxFdSIzph3DPIunM/G6prpparpF1RQH535Z4i5SAII2CLo3/+d7wZzPdPCFaKULPLBbF1HZDMRFVGv4OWdO/0hnP8vubn0S4b77JGtpV6lbxbslUmU3PLYRHiOup6SwikziJnppy3Fid5JOdGQzI5SOziumkzWZqUVqiSNq5RgrLURLqsSkRi8rIworezWIxcCLzmVJW8O5pcvD+VSdvGcflHpfnZHpaAJooz0GDse9aD8vJ/zKjgckuAMZY3PPtqD+qSBp1xIOzdxhRFaD39eTRMyRIefNyGXYoGGk9RiKR6oeRKZvozFUC5FgeMrwhmA7lDpXTFVdzz7eRUkGIg3+pOrqLOMb/HOp0GMgNZ9CpX+GZQ1dhJLzXd6OWYfDewMSHAsDbTC4BI/PcHCXbbRogwa2XRCHG0xgwgVyaqC9r+4l+0F2v/vyp79L/WnnojbSi7y3fRjMQEpXtCpRM2w5EG8z3T25JwlPeQ4RqeAigRZ/b+cCF6U1hAEZWnVRniudnD4vOeYM9JMy712COKhoJCjlD1r6oJlkSVrwGv7ZjT3XEIhZrVjv3sSa/kYskVKD51b+0509Gph1E/CP3C7GjjXEKTtqx4OHxZ4fJvX2nDgMKN5mchBj3oWpAeVdLCVEpGCDS7woqR7ZaO6oSIUldR3bqSriugpkDyWZx014PX1/wkZzCf48VzFPm+nDIbhTPOR0iUTkoxeEbqIdplYg4E+2m5f6bd4f4uTO61FI
 yB/weMEf
 AQkVQQTrYtxyf/CbxSvUA5Sf4lgYVR6gAQtpomEypsUT4iX97gZQn/XxKGdDd7+020h5OhyoMY+Jccg1x7mOeRzOUCJKtwY0uGoOl92g3xgmSyn3EHJlQ8UKU/q65pKKTJW0fb9Khm5vlEyx+bKhhsxYnSeIvPFNVSMZAwKsUHn12zabyMC0+1Q/y4Et8NIk/2km8+xmegY4/XlO6TR+cs3MOb8AXwiURdBbQe9c2DHGvDLohXQd6q6Nyh8k32K3VQIMMH3+wGwmTaDn8LvqLeVr0sXqrdKrMTfl5cDUrkTU9iXqtNC3dKAhojjxnzGuKf8EA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Oct 23, 2025 at 05:45:40PM +0200, Valentin Schneider a écrit :
> On 13/10/25 22:31, Frederic Weisbecker wrote:
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
> >  include/linux/sched/isolation.h | 1 +
> >  kernel/sched/isolation.c        | 5 +++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> > index d8501f4709b5..da22b038942a 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/tick.h>
> >
> >  enum hk_type {
> > +	HK_TYPE_DOMAIN_BOOT,
> >       HK_TYPE_DOMAIN,
> >       HK_TYPE_MANAGED_IRQ,
> >       HK_TYPE_KERNEL_NOISE,
> > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > index a4cf17b1fab0..8690fb705089 100644
> > --- a/kernel/sched/isolation.c
> > +++ b/kernel/sched/isolation.c
> > @@ -11,6 +11,7 @@
> >  #include "sched.h"
> >
> >  enum hk_flags {
> > +	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
> >       HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
> >       HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
> >       HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
> > @@ -216,7 +217,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
> >
> >               if (!strncmp(str, "domain,", 7)) {
> >                       str += 7;
> > -			flags |= HK_FLAG_DOMAIN;
> > +			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
> >                       continue;
> >               }
> >
> > @@ -246,7 +247,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
> >
> >       /* Default behaviour for isolcpus without flags */
> >       if (!flags)
> > -		flags |= HK_FLAG_DOMAIN;
> > +		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
> 
> I got stupidly confused by the cpumask_andnot() used later on since these
> are housekeeping cpumasks and not isolated ones; AFAICT HK_FLAG_DOMAIN_BOOT
> is meant to be a superset of HK_FLAG_DOMAIN - or, put in a way my brain
> comprehends, NOT(HK_FLAG_DOMAIN) (i.e. runtime isolated cpumask) is a
> superset of NOT(HK_FLAG_DOMAIN_BOOT) (i.e. boottime isolated cpumask),
> thus the final shape of cpu_is_isolated() makes sense:
> 
>   static inline bool cpu_is_isolated(int cpu)
>   {
>           return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
>   }

Right, I get confused myself as well. I've been thinking several times about
inverting those housekeeping masks to work instead with isolated masks. But I'm
not sure that would make the APIs easier to use.

> Could we document that to make it a bit more explicit? Maybe something like
> 
>   enum hk_type {
>         /* Set at boot-time via the isolcpus= cmdline argument */
>         HK_TYPE_DOMAIN_BOOT,
>         /*
>          * Updated at runtime via isolated cpusets; strict subset of
>          * HK_TYPE_DOMAIN_BOOT as it accounts for boot-time isolated CPUs.
>          */
>         HK_TYPE_DOMAIN,
>         ...
>   }

I thought I did already but obviously not. Let me fix that...

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

