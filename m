Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EDAC4453D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B776B007B; Thu, 23 Jul 2026 23:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D2D6B0088; Thu, 23 Jul 2026 23:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E336F6B008C; Thu, 23 Jul 2026 23:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A91AB6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:55:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 167AC1C034A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:55:55 +0000 (UTC)
X-FDA: 85022306670.29.D00FCF0
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26AA840002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:55:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fRemXt1Y;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784865353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNJfcC8jn5sdQ+MVI+mQj0PijBIpCe3BsXMVP5pD+So=;
	b=7ytN68PX5ePnztwmPKA3hC8LBUYBRgDdCJ2ulAU5v2bnKHhv12MrvVPUJY/nIE47ZX0dS+
	3jm1pO80ysSgg99iuIF7B56rkpuvhFjeXu/la42JOb8pLNbrJA2DZJonpYMKdpus1ZobW6
	ibgY9wJ/h+PBp/eWCUuloxMvJiy4Ji4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784865353;
	b=lZTn+1ICb+qtb5z6v4Zcp/0QghyMglgEqp5qDD7NwzwRlHWbJmzhd8XMS7jI1LVderXgNO
	0H+7HYilgB6ohML4UheUJunt30vYJwjnEH6/A+xnbkJTl46kE1/yEdErbKKU3LkXe8UnKL
	1fh2JnrVkdybxZobupI5hmhKn4jPeco=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fRemXt1Y;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-930f618435cso135689085a.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784865352; x=1785470152; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HNJfcC8jn5sdQ+MVI+mQj0PijBIpCe3BsXMVP5pD+So=;
        b=fRemXt1YpTGKRdlI/N0QJksiCa9DKY2p07ao4hNKuKBibDpi9FkOmst7jWAmjEnZ0V
         7EcZf1tcO4uASqOHaG3CmR53JnX0KWP0C1tf2Nzu6N5t/eEJpYrVHGVP0F9TA1KmdytL
         cx/YblpzQquekN02wPaUfMjLo2yEXql4/xhPzrWFrjP2XYBWyQw7AdYT4DLk6J824l1+
         MTFmqcdG7km2iu57cWHXoaXG4POJL2lNPkXYIIyHJs58z7djWuWuTGhElLzm0kqdmUVX
         eJlwqcNH8uJE+3Uy1c6BkdTuKDarfzP8TTvdUyWMAyJmU5uDElkaykaxseTY7KgwFTUl
         sDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784865352; x=1785470152;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HNJfcC8jn5sdQ+MVI+mQj0PijBIpCe3BsXMVP5pD+So=;
        b=k22slO+qyyI9NGuANkuVwhvzVORYaXZqOWgw2S8xMjX4FAVHoaSonHAC44xfG1LwhU
         NQfmAu8StEnxrBjttxrGa6yinSzDPCJSTBnolPUF42fT5fEacilMRhBu3uhKJ1D/xQAZ
         LU5GzMc6IsnLbPxe2aHgSxUhCyLNeGGfWSE/1btTiFI2+CD2OfY/qoK1/rtNvDJ5kDvW
         RWoiWI8K5JViqysmngvvtqiImlaTv2z3iC1eS7ZZMPaD8DVDaCGI8XHGeuaZK077LdvG
         GbbqPcPqidwOgl39Db6nh9mqyhOZTbXWrKh9USPoGWhyhLTjP0jLUICmzC5SVLS/fOPC
         SKIg==
X-Forwarded-Encrypted: i=1; AHgh+Rq136CG3/RVLE6M4iabuCX/UcQ24V/eFN9OlEXR2FuM5sZrKYWBbeMCYwtzoufvbpOU9SbJR+7H0g==@kvack.org
X-Gm-Message-State: AOJu0Yz8C19fkiF+G1pOoFjY9kS6r5z0R1nCCwKqCdCGCaOFGD7hq908
	HVS6Z+KcEXQ+KDpk7pqp2hhC5GBGIgoOkHax7dK+Hd3uArbjhPB8wvIdL8oNCjdj6O0=
X-Gm-Gg: AR+sD12C2XfJbPxVraeLAz+hSc85KxKYzhiVjaSRQYIxsWx8J9Tfh+fAFwl0axSsmQX
	Q/4U4xN84Nx4vX9HPF7CjOlr9xN9KuQfRu6yeydDZL2+xMkLJsfkIJiVoKjjb9pNzYE+psbr6Mv
	X/AraH4Ujj9wYx2mM+yXblYx/+wlV/nO2K4pQjgQKoeso0qoFf6cOc0e2JfVQ+WYXag0lW5wfDR
	BevgoO0ll7Z/kqg3YW9bGfqq72n9Vybd6Qd7LJ/g9tQ2b16KDiYcHQiAKwSPOYu4MRmkcN++7Nc
	GQp158BnIt490rqfWFCx/EpAc8bd0gDd2oEYhazAU2fnRyeIi6CAID0NoaeLQ20U1tHbZc3MKF0
	erj6PxMaNNa6V2AkfwhSlFrhe+tKahNoEAt0Oib0tcYKnL0pS8iEmuYhiB3NnchbLicYg8y3TOF
	4ky6h5wJBhmWEnBbDdJ3e1ZauwvokkBBiisrwBQ5IwJHVn1D+4o4pA3HsNbhGFn7mvb9fT
X-Received: by 2002:a05:620a:4509:b0:931:7b8:eb8a with SMTP id af79cd13be357-93107b8ec3amr455545085a.15.1784865352170;
        Thu, 23 Jul 2026 20:55:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f687466esm570122185a.4.2026.07.23.20.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 20:55:51 -0700 (PDT)
Date: Thu, 23 Jul 2026 23:55:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amLhu07IpWfBbWC0@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
 <20260723171515.b5ddbc59c5c36ad01ef8f7fb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723171515.b5ddbc59c5c36ad01ef8f7fb@linux-foundation.org>
X-Stat-Signature: qpowyataaepbsgcz5tbztmjcibpt1g4n
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26AA840002
X-HE-Tag: 1784865353-253663
X-HE-Meta: U2FsdGVkX1/+OlLaEOxZdFstjsVVy5bafeU2AehheovgtGoYAFyypYhrEm8Bt0kQuZejkEgeWRKYu2e3yTEQo3oMzOjX7kezuuS4PBYL0IeGe5UIyMG3OSdPwEu+uKKQm128MArrsQO6NQ3JUcqQf/iF8qmgtkNRG8d+hpFNiPIBPKcY8qW2XJYZ4anpLFqrMVtaYEpt1mvwCnewAPZmWqGwifINAJ5iELRBqXU6gXyBOLuYX4Jea0arFkJoSeMVIkmdI65m07T/P7unAhwYiMZOKkzVwKODwuOIWtrVEZypuvkRN0ftAIyRAGbp/+IDK8e9Sb3Ca0t3x5/ZEuIiXVth4q57cb6mghmuZFLnp87INzPFKo8p/yu922Sq1SD8wbpFMXksEUB4iQl3/1m9JMvvumCDZzZGQkC3v9ZahE6UIUQtex24BH2p0H9VtaWOUrc4vjIOmIoIfdJdnQh4f0koIL8SM28jMB35stuZePQuBURoAx0uFjORohuIXiG8F5AZ1Ai+sI3zlNI2vOH3gMJWh8uQJ+V3OOeMu5YooGySwjehqns22cimz7YkWEBKX7ImNPAYbW0Zls9GDspXSFvkabbEwzsuaMCE25HqSWVjdu9NGpjKw5M56QcYdCCv3JzNsYRUaYGiA/Jq943vSLrNOSly4cwvzDVBUYJW46yhydN/x1Q8/lB9M7hebOJLPZs4pbbH6aNKxc7DJCubzf9r8KGkFappDxm93cpM93Mln+HEwanoerwY2FHjTpOmV50KEIHI1Lai+X+s6W2UCNhoWX+cHPCZxRLmhZa0o+hApytBiB5IBt3ZXhavrE6lDqboclXt2UIRETdHZCHhKr9fMybKaxqBgR6yLtgP0YeHW7ychkmbDOEKFqjZh2iPlCSO/kTeOZT3vWJx/fXdNqhYVOqbVShnq2HPqgayruA+yyKiqTASdczmydxBl34mnVNxcVQUGrWpDuY7HTk
 I2gTJpgD
 2tyjAOUe0f7zquFPX0By8DscZRI+/v3MTxA4oUB40LcHiuKACmNsLBe+PUbZQmkmP6RIaBepyrxs34YCntOZn6MKnzA+RYUFi+7lUTjcwGIvxhvbw16GznnZaY1OHOXg1flvkMd976AeDc+cWg0Fkl4B4PdK5Vset2/rgW1R1SFG8JSpyYE0brdo/LF0p8WSkwIi1tPb5yYfx7KU9GP/pqXVmg6Zz763RaDkOfQpt/q8X08v+jdYv0Kt1KlIYfZ6YbCIBVY38vEYFqMtRqG+5f4uef5wzmoSHX9LztssODwoMbdmwAphwdADMaMX4Y8N7nP5utjF0nBMTTcbVmP06xjC66Fbd4Sdfvck9zq4Cfe9KH6q11A70AUMoUSmNiL1iiKZh5a6pQNX4abPc26mGfzDSywwnf61+v1ufv0tzPkgke+xpsK/Y4NvmzWqcA8IWkSkgFq4mVfEgnaoa0Rsrx7EyjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 05:15:15PM -0700, Andrew Morton wrote:
> On Thu, 23 Jul 2026 10:54:06 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > But in this case, IIUC, this change will "silently" enable NUMA balancing for
> > > shmem-based KVM setups where it was previously disabled (albeit unintentionally).
> > > 
> > > I'm not fundamentally opposed to the change, but I do worry that downstream KVM
> > > users could be in for a nasty surprise.
> 
> It is a bit concerning.
> 
> > This should be very visible in early kernel validation after an
> > upgrade. VM hosts tend to not do much else, with VM memory dominating
> > the host. You'd expect a significant uptick in numa_pte_updates,
> > numa_hint_faults, and a change in per-node nr_shmem stats. And the
> > patch subject makes it trivial to find in a commit delta scan.
> 
> Is there anything we can do to make this process less painful? 
> Documentation of course, but what about detecting the situation and
> emitting a once-off warning?

Maybe a rate-limited or one-time pr_info/warn on the first PROT_NONE
fault affecting KVM in the painful zap path?

Non-invasive, targeted, and helpful.

~Gregory

