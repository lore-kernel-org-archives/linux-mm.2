Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B44BC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3DDD6B00A4; Thu, 23 Jul 2026 10:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E156E6B00A5; Thu, 23 Jul 2026 10:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07CD6B00AA; Thu, 23 Jul 2026 10:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A75556B00A4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:54:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36343A0518
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:54:14 +0000 (UTC)
X-FDA: 85020336828.03.64AE5FD
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25897A0011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:54:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W2V8AjOm;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784818452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLLxSZLuQjnUsz6lY8chbZ4xGpk55UfyIcJeXwJcjf4=;
	b=bsEUzSbqpsWkKsnk9rmyEVrstNiPuQmSJTqghjsmuZh8Fj18kHBnGpQnMDGUC4f3rF4oYB
	j5LEpRT+ClRvVedxHVobr4X4p/y7wbHiZmt6DDw80ZQl5Pu2z+7VcINC8Q6F62rQihuV7a
	LuJHd5zgI/smLOnuaB8iPlC76fM85rI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784818452;
	b=4otRkJkrguEix6ZbuPFMe5tnQzSlRdPtzZ8YHI6iz1MebfDrUA1jVbLjhdrBpUzur9TIfH
	+JyuojLuvoFme1qjHXqDlrV57U8IQg2m3B4fcXnWzKVGMvJboW7QSs090Eu7gtJfgDL5AV
	N8wG6upQsX1Q1VeWTAGt6UWYSXRqkZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W2V8AjOm;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8eeb4508f29so8074026d6.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784818451; x=1785423251; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dLLxSZLuQjnUsz6lY8chbZ4xGpk55UfyIcJeXwJcjf4=;
        b=W2V8AjOmbr0xbAkMYZaYCI/zyBp29cXeYpV3quQWQpikJhWRPGTfN+WWHLx4pw77Od
         DnfaWOJSlhRX/lGdYYMA6MIibMLLifkg2u6Hryzdg+A5kCS27TyoW/4VaIZq1IQTMrQf
         R6GrLyqVnsQhHysII9izqoh1/8L+x5yiXp58QhjKLeJVZMRxE91yyNdHsz23D3lJfKbv
         C3LJfsBz+Tsz2HTLsydHZvX+b9DfMxuhen7+JTthtLcj6kHQbPrjYTn7OQFUHpv1yFXF
         Hb9QtXUKdRp16hPs36+o9C36ujX7hJJTUjn2EVOO+WZPTZXh7eGz5P/thBoA72gqqrnG
         F3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784818451; x=1785423251;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dLLxSZLuQjnUsz6lY8chbZ4xGpk55UfyIcJeXwJcjf4=;
        b=dzOH4OVn4GDNvIwpISLKej5IVdmNJ+zqIFcHDcQ2qW6JlDRJe7XzaW61lTS47X/U6J
         1qBWvDAG+x10xCuNQ8XJmuxf3ktsfR+gwp3bgwnSNgFZwlGRA4xY3hVKzXmxAdcmm57K
         y6WlWaF8zrtippuN9unX8cgm2Ay/FNFwy1cxnexrDYbqwOvS2QtKLI//tWIQQP8ZZKFW
         BjVGojKu8+giUqwM+x4LtePBKMaozU6BWpi8dbzMUOoquNOjRA7T6bwc0tO+TBoViugR
         Wy1rFBRzoeJRu09Z+aV0zbOGqalo20F1ZaEAxBHCmPrCL4n6jWUQiquHNjb3xI6ozAsq
         9cow==
X-Forwarded-Encrypted: i=1; AHgh+RrXW2lysckGwPwaBaw4wTm3IwEBIkXUV8hfwETKiyMFydbXytxp0EN2MjfHBwZHJDIQhSZvqth5mA==@kvack.org
X-Gm-Message-State: AOJu0Yyx6binQ03W114vdQ/qFDODJNU+HItYjSmKXLoAPb+vRFTRi14R
	E8WrIapMwms+2NwGfvYJ/BypbMcnAxOTvUEgOujjKV4dX0kAp38OyabGYn9Yw45xvME=
X-Gm-Gg: AR+sD12PsISSi6OGzbCcASSjkx75S1mNjeBMCHrlUNEnQIRx2SlYJXtLCnbMk6+y4WW
	SX3wNZy7ZYsYrIQAIniYLz+m0mkW7aQeaqr2PkdB7BVn0hPDag3HaiYWPyI7O8cunVNFLnPog6Q
	iEEsFqbZ0coqw/MT1VQh3BCDQdNusqqvWLNaJTGES73cMPLIsdlnOiDWeew5GLksnZyDqnNRgsB
	xgTYgGrYMEtCWWY1zJkzh92Arcz+t0/b+xL02NVa+zvC1fpPd8VFXlv07sWkKKaLqXHDm5Nbge7
	uGu/7IKBzVoWvhExj84ZS5OaioGjuRhqsiphf/rWbMlBoF7WC374k0UE7BSDJfz3Pnrf9DfgDQb
	JJH0kpChv+U7ZHNEGCQ6uGEUavsLxgya2jVNjsuCp3Nm4hTBL5WTGEWkkniMyQ7fvb5ydofxd3H
	XK
X-Received: by 2002:a05:6214:19ed:b0:8f0:779a:d2e9 with SMTP id 6a1803df08f44-907ca5524f4mr46157826d6.46.1784818450912;
        Thu, 23 Jul 2026 07:54:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8d5434sm46798176d6.13.2026.07.23.07.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:54:09 -0700 (PDT)
Date: Thu, 23 Jul 2026 10:54:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>,
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
	vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amIrDncrL4K-JRBO@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIcXrS7nGX-adpG@google.com>
X-Stat-Signature: rb6tkm5k9qdmu5y55ywe99sba6kpjqba
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25897A0011
X-HE-Tag: 1784818451-68524
X-HE-Meta: U2FsdGVkX1/GpRy3puB939J+XMnFLPqG+D/dps9CFmnrrSOnjmeOaiNt4k2QrRghrH7RPfAHLF6pqEyb6NLctjraHfFOEB/fC5+4KkFPAylwez32oJlsX2HRCGlZ2D5XYE4yq3snV7EBfKnab0ivOM+9pVHZbAK8Qgm8CvNknunWPVyOANCQI4YAnYi6N2Uo8sQZ5T8kBL8pne/5hVPfit6OrAgg6z+mLVeCHcHPVN4P1gU9WozLKiJeBdCu0kT6gz+NmHqFf/gwhsYYBDn+bgNY6q16uqhHXBaJhkOvF+S+lHuIBjOzK7oJsTSZMOH+WZ1456AJnPXXte8fdlTj6rjaTGiUCwTtDNCnDz7wXED07Q0orkApe8c3t1vCr/YPplXmpeAEYYTkKDDg23fBndR/Gnl5lWlAmB3r3x8JcVZ8kPigagQXbPTClJAuijEKbiUKx3RQg4CuoZ/X3OdA5t+VRRCu8v9phl3/3oB9WQDKJxLo0FD5SnWsgo+6TBMyDLESddNmcw/7mTmP05nCrzOx7Z8P29VOWawDh5+JeDs4sWZCB3zgdxk6E4yXFEjhSNC4UYdaVer3etru23dP4VkbYiyJFerb1UAzgMIyZrSguSc5z9LRNAU3qjhEmTB2qseafC9Ttc6HIR0P2csfA5oiuF5uhf82GX/WB4I4P+k3izNBsrNNCpWmDzSFRDatyr/Aoyo28/sqZW3eK4JNvuEQpuUqVA/G+eUNYIzjaLU/Z6RZvRp8WozK/fI8ArARXVmTHRjyguoJ82a+XFfSouDwcqXgJO3ph3viQz/2DFSQ7xt/GshiuiSWbm2HhK1f2+3ofgdycExu3SUuNeX9EAYhdthLCIIr56jy3HU0QAQ/kHRFroWpfGtXUF6JT0SIEJL9BnGRPLmxvuEGPQZ3u/r7Wnic7+/S4Fv5CgnIhHsrnHOgOfyZ5GV/Zsu4Q/zS9XC6vZyd6qPouOkpMiM
 xbcpk43X
 eVhA/XqL09wiwDg+6riRournps/YKiqNLzcl39wVLyKIttpTN1sv4wZIJCnsoFyzMC7oxYVNymDLpP2uLgB3Rh86kIvrjztooPzDWhJjYApfSp5co3u/u1turuToY2qucFMhLYjV135aj+We3EqRyGUp5AkPsiEFEBWxUADlqu8pHij3LDBNf/rBa2Nywcc+RR1oN6lXsYBCGe6BEYoOVtBfakXVUQAAvcAO4ryHdsKprQAXDr4EIwpTyTzndSbawZpvidQ34/TMoH1X6psMKrSPOTSyorMZuia81/amQZ994FB55rjSZXp3LxAoI++EcC/6Qon/VpWB/YY/diLJPaT6Uw9OEywugyvqmAZ8Lyx4yxaMj7dLBCzVCpIr6ak2cSUewMWO/W4re7+rWyBnR3K/ki499yykc9wrq5ldPZPAyfTheNDK4EuvwjLGZ8XfE/HvPgXNlNbfN34EyahmOvK7YHw7IjbTwXWbFe3Ujg2PTPjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 06:51:26AM -0700, Sean Christopherson wrote:
> On Thu, Jul 23, 2026, Yan Zhao wrote:
> > On Mon, Jun 29, 2026 at 12:33:37PM -0400, Johannes Weiner wrote:
> > > Neha reports that mapped shmem aren't considered for NUMA balancing,
> > > noting convergence problems and bandwidth bottlenecking for cachelib
> > > based workloads on tiered memory systems.
> > > 
> > > Looking at the code and going through the git history, this doesn't
> > > actually seem intentional:
> > > 
> > > Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> > > VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> > > policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> > > motivation was a real usecase: Oracle was pinning shared segments with
> > > mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> > > 
> > > The handling of NULL from vm_ops->get_policy, however, treated "user
> > > explicitly opted out" the same as "user never specified anything." For
> > > VMAs whose shared policy is absent - the common case for shmem - the
> > > scan was disabled too.
> > > 
> > > This issue is old. It probably hurts less in conventional NUMA. But it's
> > > very noticable on tiered systems, where entire tmpfs workingsets can get
> > > stuck on lower-bandwidth memory.
> > > 
> > > Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> > > thereby handle the fallback to task policy (-> preferred_node_policy()
> > > has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> > > already handles it this way, the scan-eligibility check was the outlier.
> > > 
> > > This preserves Mel's intended fix: don't scan stuff the user explicitly
> > > pinned. But allow default policy vmas to participate in balancing.
> > Hi,
> > 
> > This patch introduces a performance regression of a KVM stress test, which I
> > addressed in the KVM selftest itself (see the analysis in the patch log).
> > Could you share your thoughts on whether the userspace fix is the appropriate
> > approach?
> 
> Yikes.  This could have meaningful "real world" impact on VMs backed with shmem,
> not just on KVM's convoluted stress test.  NUMA balancing generally performs
> poorly for VMs due to the higher costs of VM-Exits versus page faults, and due
> to inefficiencies in the mmu_notifier interface (KVM does a full TLB shootdown
> of the affected VM on every MMU_NOTIFY_PROTECTION_VMA event).
> 
> My stance is that using NUMA balancing with KVM guests is a terrible idea, and
> that anyone that insists on using such a setup gets to suffer the consequences.

I agree. Surely we cannot leave shmem balancing broken due to
that. It's also not clear to me how many people even enable numa
balancing.

> But in this case, IIUC, this change will "silently" enable NUMA balancing for
> shmem-based KVM setups where it was previously disabled (albeit unintentionally).
> 
> I'm not fundamentally opposed to the change, but I do worry that downstream KVM
> users could be in for a nasty surprise.

This should be very visible in early kernel validation after an
upgrade. VM hosts tend to not do much else, with VM memory dominating
the host. You'd expect a significant uptick in numa_pte_updates,
numa_hint_faults, and a change in per-node nr_shmem stats. And the
patch subject makes it trivial to find in a commit delta scan.

