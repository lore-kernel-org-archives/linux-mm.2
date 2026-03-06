Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7F2F01822
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1629B6B0005; Fri,  6 Mar 2026 05:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6456B0089; Fri,  6 Mar 2026 05:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33FC6B008A; Fri,  6 Mar 2026 05:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2CD66B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:16:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 867201A0466
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:14 +0000 (UTC)
X-FDA: 84515233068.14.E0BD86B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E31E40010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHBI0MPc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kYk0svydTKp3HQQf4hdshMPBR2IVsFSBSSEtZBR6GWY=;
	b=MBzB+lGs5PF4e7lbFghGJR/LW+SWBuGeXgeSUKyixaHnY5Nkj0o952ErdLMq0a1Slf0gRY
	+yXYIbLBB2S/s3gKunAHm++jjqMdCvheTTIxfmAbtqPaoStQjC9SKORv/RCAH6GEsb0wjN
	W13l3iC+fVlmMeJogMaNRwP69WDkBAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792173; a=rsa-sha256;
	cv=none;
	b=lrD0TH2nF4Vk6buHj4bsm1gb4TCSZPB6KpdZqMXAXlrWin7dNKkAGD6RGwX3OCbFbrZGeE
	cetosFXEzlOQ49Sw6h2CBqsTa6qulQUp22RD0E3CRS2cS19rMPFDXuVufIsjVs7oZw82vQ
	FyAjMO/eQ0jh4zbK1a1kF0RtOhnHVy8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHBI0MPc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47A5B60127;
	Fri,  6 Mar 2026 10:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A777C4CEF7;
	Fri,  6 Mar 2026 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792172;
	bh=aN1f11VNXm8TEP7a6s26GhJ/SMe/0NluR98vebxUP6U=;
	h=From:To:Cc:Subject:Date:From;
	b=CHBI0MPcs3WqAo1RU5sZKFW8fwe2JFRLkXD2gEBfA05SDEdafzPVDHMH8aw0ejrD1
	 crqje38RReq5vJVpM1YI1zNvWsClMXXuzPbjwWw2W0Br0k8sZvXTCojMTKdsEYTBoF
	 TQZEpdbvWip2ZmFiT0To1T7WuSrRK/oAtsAHSsmxayfcl3ww60vjF9VLaepfe0bLPX
	 d9L6oZeF8Ol+LMb77zqQx3p9ZtaiJ7pb9/WGw38ryflhSGSDKO4NV7WRWCCrWtG+lG
	 kpXRz5yWs5U5TkzVWGjSi37i/3Xtj+xBxmdbgu53ij+gVc0IPtQbMLSP9cYAJC/xSl
	 sb3JchfU6+kZw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c
Date: Fri,  6 Mar 2026 11:15:56 +0100
Message-ID: <20260306101600.57355-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E31E40010
X-Stat-Signature: bdgrgqygagdbyaxb85ko7j7hnj3buir4
X-Rspam-User: 
X-HE-Tag: 1772792172-387453
X-HE-Meta: U2FsdGVkX1/d6CesbylghHBvfwZH2EA6yWsz0/hRjTD3UCzkO/i8gFpVlROlJmSIR9R4VfjHDSIuw717mfGoufkDbzqBv3FyJtRytn6eY4hC0thVZOWX4KzLXcqg+MWxBcazjYNnaQiZCgL5EyuAuizBOrYdt9udNEaZOiNi6fC4NNdpJd43VVpClgVRxuyyyBQ+QWCJpalSpfsI06u+skKsrD3uw6QsqRDoqb+71XFa65RbnHoXj5rXO3V8UsDyFyse93FXvkuioIpTUGM6/LuvD72rRZMUefQ5wnanCkpNkAs4OV5In8nvQXUNh/KAh8Eh9Xk23hdL/FEXJu871gmKRq0raDdi/+xkyQxplE7BfEusdb0+uuqYG42uMsL8J3QHPl6QIL99aGFYYUlRtnA6lB0nM1q9Ci7xVmZfI+1WfmnKiz3o8OM8CimPbXbaP7V0IJvmC6NcT1Us+0tR7VyMpo5rLeVNGirloaUsc5RwXO8uf3p4Zf8gPkPYYpukPNhe56OyA0pdmq8Ph/I9Sl19N+IgR2w0+yEjBycwRS40ai5DsRv5aRcdvycY5bWnbDEWpPKA8G5alEnrRLWIHnEzhNgLLG2wSVBM6dYsIyBA1EAeUX2SHQrF52gFfU+IotEBP84eugBxyOanjCKd0RUWYK/Yc8RlnBDjh50ilsrOK2CV6dK3EYEDmWyDffIzcEa0yIW6aOYnXhT5QlY7EO0MQGmcCk2CvptJIFsiBi4/qczrnsgUjGPegfW1Y/UDGn3tcx6lZXZMFVlUfA4iWxx8MD7IcJ3/FfpQsWBcWVKbBKec6TzBW86Dqh74JgEmUoUP58tnuW6HKkTU7C9cSNDTZ3PJhlYC5qHQ5ciaJrI5qw9aDQdgf5uz/QmWOwuhMlF3X2sm8A2gG3JEPtSNdK2yiJfgypZZJqUmqYIJIqXOl0LX16hZQbZssM9xTud+m44sjEumNBi9z1hSlRp
 qh0jzi79
 lZk/A/xwjeZ8ow6B2jhdF9jsJvn61GlwHpSV84Zzo6yMEdGdcWoAZpd6GjtykKYnhUzmmofNIDduWY5y6DDXEqTNLYBsCTRkI9IDoJJLIHPdEHm36o8yOcKARTfneZ9tR4XUx9bwIZoYsSyKVS5R8O+HbdOpqbgur9nvBFvQfMT43zftFzrrM6M0FNHASOuClhArDvA3Y9OP80igU2jjmiUD/7Ho3G/Tk4Eh+EPq9VVyHtwM+wUbUkoBxll2kneYbTy46sp4SZMmKrYr/wLFt1TvlJxZd71aZS2qXysUBkAROBLwY2VsKR1SS4YdpRCClsEyxwE4q/DpPBMzmKcnwvOyPngs4JqBqk82oW2JThRp2QU0WI8NGipA4LpUsK+ia4JiaYNVv591+VfxEF00uTLkUPtPbcbRoRbBv+K0YGNt7WT9+LzptN2Oaq9nPMtnrk/ipQnoxzBBYVDSiY85hlUeUg+KUM5ZZXxJBW2MZmv6LUXtDZQdAyxttJvr3FqGEVXflOKVMKMjg3hDFETLbOjspA8+3luYfsY/7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is
not compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
inclusion from KVM code.

Cross-compiled heavily.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>

David Hildenbrand (Arm) (4):
  mm: move vma_kernel_pagesize() from hugetlb to mm.h
  mm: move vma_mmu_pagesize() from hugetlb to vma.c
  KVM: remove hugetlb.h inclusion
  KVM: PPC: remove hugetlb.h inclusion

 arch/powerpc/kvm/book3s_hv.c |  1 -
 include/linux/hugetlb.h      | 14 --------------
 include/linux/mm.h           | 22 ++++++++++++++++++++++
 mm/hugetlb.c                 | 28 ----------------------------
 mm/vma.c                     | 21 +++++++++++++++++++++
 virt/kvm/kvm_main.c          |  1 -
 6 files changed, 43 insertions(+), 44 deletions(-)


base-commit: f75825cdfc4c5477cffcfd2cafa4e5ce5aa67f13
-- 
2.43.0


