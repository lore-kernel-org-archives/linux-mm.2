Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043A9D3EE6C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A1A6B01FF; Thu, 22 Jan 2026 09:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441B36B0200; Thu, 22 Jan 2026 09:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B046B0201; Thu, 22 Jan 2026 09:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24B736B01FF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:25:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFC8913AB87
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:25:55 +0000 (UTC)
X-FDA: 84359823870.17.77168D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5973E140002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:25:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgksenNL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769091954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7mVwEd6fwIbimNEJlQo8+vfAVD2+XS/xZOfgS1b43M=;
	b=Ullme2uXTxvREx0Y3Mv26b2lBHFxJHJQGIJ2IqlIvM+Dpdqh8xiXz1TWPAm9dLZyXUlSlj
	h4FzfFviW6xwXCSWEUucvK8YUJ1ws4KDMY1sav2L8HNctnfkBdKlP/NQZ9fWyy17MOCpQO
	FYiRkYQNi+M+UvOS8QC7eeEXk0Bkxbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769091954; a=rsa-sha256;
	cv=none;
	b=GpRblPVFvMUdh0uVIoqEpV5jnkM/DKSqoffq2GFiJ1kZjwLrqJWPFUIN/wMa1TSnHk7N9e
	ZTqhbW1sxfefjpfDOZ04bWEIE7UxXliQ1CAVIDvVugNpvIytphbaw2g/oCedXvjUDBq7ZW
	xchiNtlkKhzeiEi6Tpez1Ny/tS2ygms=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgksenNL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94D6E600C3;
	Thu, 22 Jan 2026 14:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3070C116C6;
	Thu, 22 Jan 2026 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769091953;
	bh=Yl2qHTWE9Fz/7zZDgzhuQhCUpz24c+UW8s5oFbDoqv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dgksenNLm8vVcFnylVsW42Tv+ZdtC5W29o1qOctfuLKEDknRSTgAq8uzfYssEItmI
	 1/wOROGwmmKK4A6J0Uf0YffnAOAuPW+Z6RN9LrRJxi0cMAMDPJW+sHCCBqhwnraKRy
	 kJJ07EzgsYxVOO45tD2+zF7iBGbuIZkGKgSP05MJZvD+tcbKYbrvLKNW11VeHgFWi+
	 VU9GuE9ZZl3qbAvIeLSbzdH7Yue/O7ulWuBcayymCEG/yFqi3DTV/nqppK2pyvu/Jm
	 wh4/199cda1IpN1SL0mJt6msWh7JYksIQOb9a5HPcwS51wHfuEWcY3g1/EH2SLxa1V
	 CSmkUrJoC7XpQ==
Date: Thu, 22 Jan 2026 15:25:50 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Will Deacon <will@kernel.org>
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
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/33] sched/arm64: Move fallback task cpumask to
 HK_TYPE_DOMAIN
Message-ID: <aXIzbmitdoJIMFCP@localhost.localdomain>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
 <aXEHf5nbZMI8LT4b@localhost.localdomain>
 <aXH0TZU7UNowTmwc@willie-the-truck>
 <aXIKDduX5qUXvOUX@localhost.localdomain>
 <aXILtazyRtpb3Yjy@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXILtazyRtpb3Yjy@willie-the-truck>
X-Rspamd-Queue-Id: 5973E140002
X-Stat-Signature: j8zygj75tyjfrxz4zyctqsffebwxrj1d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769091954-262438
X-HE-Meta: U2FsdGVkX1/CtPtYbEcSWc/jjTvGVoPevip2Q7Y9unv0XO76e+OLA/pOG6oG09/MgIJwG+SElzyQEG5pmjUVfi0diFqi3JygzLgNCKbYm8rvS1lHdj4pFrcjTxHAibxrT6lYmCJEqnv82cCJZxNA513kqq1LiHzbCxIO7ibhcn3Gm3eSx3+piDL1HjF77Wbv66KNrGAVyesQA0P4/Jyn1ptn02CyVrIZOAriDGxmf3D65CfNIbEjTcDgvNkXsN0SNHdQBqRWK8NCM0gh/pwBLJOUmsRwimLR9UtPArm89EpDwqXrLmN4dUEK4RXzqV/wUap7XldGOxOXXXmHQEG8Plu69qFlxDrCognUJ7AKw2fCu0BV+/mVfehdEDFdPHJWLNUNXZJC7wf4AE0LewPlX2rL4on9YxYOEWrGVKXgRtICz0N35ysKakY7IYpiN/8aU4ZqpPS/CsnJ7x8npDcllG3FxcAwzK/5E3MyUcX1IXN2qJK9jnwuQqfPHT5fsCvH+GttDpiczBSWqKIiWcanH3fGqYQs18JG0m4IH/wCKxat0WjSbGloSEjFvKpsyeADQem3Z12LqbI0I2fufhykYPykjnnuVKgk9h3tEq1Y5Bd15qhycSIZ8lwah6EZesfvO0vOIajuHaDltG0whT9i+rNL1NdIQms9fqQVccxaYX5uTjq3yhkbkfBPEft0PkDMpXHtYaEIkBb0OEQ5NOFg648OoMq1fmLV1dBd9jrf8j+/GwoeCQhdO/M87R4K1CqTiAeI8NaZRO97tkDg6oAo69vKlsLgLayg8CydODIm300nWo5+nq3U/F3L7EP3Uapm+jRMq9SC3dm88f6iqq6zgCoJIoFYAWFBVMa5itL/3zwQfx/5nhApAR71zoe57Z6b9V4/IIGRi9s6ENW+iZB98pUzTGCHIRMtCgPkfwqx6K91Vmu/7AGB85y+jrtBJFXBJRF3c79K33UtFxBQH/C
 3vYMvb9X
 DzOpn4ZahfIE/kJ6f205Ikef8+p+ok4eGauJTnhTDC32LbsNc2HW+DiXOg4iDrDUv90hsX+IQqAfRZSQXMpfV8qHa4sUgwz9EvBQe/82YdkjxKZzmjJRG823DbZmB0mw8V+iN1JDZKk+AAY8i9n6ZdPQMlMVWm+vWOLRYVvYmW4B8z8W/Q1ORYnitO/Xx74xPSqYJ+QiK/oNwV7C305ZHT+wt+JjleyA6pdTmkiFwg39b/X5qR8kFG2fiGy7NGbURwraXUNdjum8uMWlVsjPV6kO2gBjzM68sAj2+OxPHyVsFDkaCvkYwZuio9qZyNLy4Y0fJWJ52ikoMgNevfwm6epjzu2duYKTicug7hvdEnPFr7Pwvf1t4gp2pvnaAZUpkLNXxypp8uY9z168iNynwb3HOfbURBPdHAEvolHJPVt943e7W+x+Nye5cXduBeBatGScSHllkqYw8njtynOKPQcPnC+MrGGV4BqoWQSZRG3LA/bLF3ehAbdV2txJUsMJnPhoA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Jan 22, 2026 at 11:36:21AM +0000, Will Deacon a écrit :
> On Thu, Jan 22, 2026 at 12:29:17PM +0100, Frederic Weisbecker wrote:
> > Le Thu, Jan 22, 2026 at 09:56:29AM +0000, Will Deacon a écrit :
> > > On Wed, Jan 21, 2026 at 06:06:07PM +0100, Frederic Weisbecker wrote:
> > > > Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> > > > > Hi Frederic,
> > > > > 
> > > > > On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > > > > > When none of the allowed CPUs of a task are online, it gets migrated
> > > > > > to the fallback cpumask which is all the non nohz_full CPUs.
> > > > > > 
> > > > > > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > > > > > disturbed by tasks that have lost their CPU affinities.
> > > > > > 
> > > > > > And since nohz_full rely on domain isolation to work correctly, the
> > > > > > housekeeping mask of domain isolated CPUs should always be a superset of
> > > > > > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > > > > > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > > > > > CPUs that are not domain isolated):
> > > > > > 
> > > > > > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > > > > > 
> > > > > > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > > > > > tasks and since this cpumask can be modified at runtime, make sure
> > > > > > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > > > > > by cpusets.
> > > > > > 
> > > > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > > > Reviewed-by: Waiman Long <longman@redhat.com>
> > > > > > ---
> > > > > >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> > > > > >  include/linux/cpu.h            |  4 ++++
> > > > > >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> > > > > >  3 files changed, 33 insertions(+), 6 deletions(-)
> > > > > 
> > > > > tbh, I'd also be fine just saying that isolation isn't reliable on these
> > > > > systems and then you don't need to add the extra arch hook.
> > > > 
> > > > Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
> > > > And I usually expect isolcpus or cpuset isolated partitions to be even
> > > > more broadly used, it's lighter isolation with less constraints.
> > > > 
> > > > Anyway you're probably right that we could remove isolation support here
> > > > but I don't want to break any existing user.
> > > 
> > > fwiw, I think it's only some Android markets using the mismatched 32-bit
> > > support and we're definitely not using nohz_full there.
> > 
> > Now that removal becomes appealing. And what about isolcpus= / isolated cpuset
> > which only consist in scheduler domain isolation? Probably not used by android
> > either.
> > 
> > Ok but is there a way to detect on early boot that the system has mismatched
> > 32 bits support? Because I need to fail nohz_full= and isolcpus= boot parameters
> > early on top of this information without waiting for secondary CPUs boot.
> 
> Honestly, I'm not sure I'd bother trying to be smart here. Even if the
> system has enabled support for mismatched 32-bit CPUs, things should
> still work properly with nohz_full/isolcpus if all the tasks are 64-bit,
> right?
> 
> In which case, I'd just document whatever weird behaviour you get if
> somebody throws 32-bit tasks into the mix. Adding hooks to the generic
> code for this use-case just seems like a waste, as they're not going to
> be used in practice and it increases the maintenance burden.

Ok, how does this updated version look now?

---
From: Frederic Weisbecker <frederic@kernel.org>
Date: Thu, 24 Jul 2025 23:38:48 +0200
Subject: [PATCH] sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN

When none of the allowed CPUs of a task are online, it gets migrated
to the fallback cpumask which is all the non nohz_full CPUs.

However just like nohz_full CPUs, domain isolated CPUs don't want to be
disturbed by tasks that have lost their CPU affinities.

And since nohz_full rely on domain isolation to work correctly, the
housekeeping mask of domain isolated CPUs should always be a subset of
the housekeeping mask of nohz_full CPUs (there can be CPUs that are
domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
CPUs that are not domain isolated):

	HK_TYPE_DOMAIN & HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN

Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
tasks. Note that cpuset isolated partitions are not supported on those
systems and may result in undefined behaviour.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Crivellari <marco.crivellari@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 Documentation/arch/arm64/asymmetric-32bit.rst | 12 ++++++++----
 arch/arm64/kernel/cpufeature.c                |  6 +++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/arch/arm64/asymmetric-32bit.rst b/Documentation/arch/arm64/asymmetric-32bit.rst
index 57b8d7476f71..fc0c350c5e00 100644
--- a/Documentation/arch/arm64/asymmetric-32bit.rst
+++ b/Documentation/arch/arm64/asymmetric-32bit.rst
@@ -154,10 +154,14 @@ mode will return to host userspace with an ``exit_reason`` of
 ``KVM_EXIT_FAIL_ENTRY`` and will remain non-runnable until successfully
 re-initialised by a subsequent ``KVM_ARM_VCPU_INIT`` operation.
 
-NOHZ FULL
----------
+SCHEDULER DOMAIN ISOLATION
+--------------------------
 
-To avoid perturbing an adaptive-ticks CPU (specified using
-``nohz_full=``) when a 32-bit task is forcefully migrated, these CPUs
+To avoid perturbing a boot-defined domain isolated CPU (specified using
+``isolcpus=[domain]``) when a 32-bit task is forcefully migrated, these CPUs
 are treated as 64-bit-only when support for asymmetric 32-bit systems
 is enabled.
+
+However as opposed to boot-defined domain isolation, runtime-defined domain
+isolation using cpuset isolated partition is not advised on asymmetric
+32-bit systems and will result in undefined behaviour.
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..f0e66cb27d17 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1669,7 +1669,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
 
 const struct cpumask *task_cpu_fallback_mask(struct task_struct *p)
 {
-	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_TICK));
+	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static int __init parse_32bit_el0_param(char *str)
@@ -3987,8 +3987,8 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 	bool cpu_32bit = false;
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
-		if (!housekeeping_cpu(cpu, HK_TYPE_TICK))
-			pr_info("Treating adaptive-ticks CPU %u as 64-bit only\n", cpu);
+		if (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN))
+			pr_info("Treating domain isolated CPU %u as 64-bit only\n", cpu);
 		else
 			cpu_32bit = true;
 	}
-- 
2.51.1


