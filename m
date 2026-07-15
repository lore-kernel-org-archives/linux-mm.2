Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3043C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE926B00AA; Wed, 15 Jul 2026 11:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6646B00AB; Wed, 15 Jul 2026 11:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBA56B00AC; Wed, 15 Jul 2026 11:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 749606B00AA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:01:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA57AC01B8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:01:39 +0000 (UTC)
X-FDA: 84991325118.25.7F6E58F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FB1810000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:01:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPiuISMO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784127697;
	b=SKlTKLOBWt4gIHtucPo2BVOGBQFeLLDa9RQaWCx/qq3bUfj8MT0efEL3cMJMKICjd9k61L
	0WN+QDLNIRsA1mSNg3YbR1iNGLgCjkGVeTBGNPvg4mI9+vEPnS1jchLPPlUFkjZgeM+ZUR
	pnJVdjaTcUP1iw+X+ZkU4uAjTbOJmv0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPiuISMO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784127697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Z2zNKjRbgDz18AB/OdbEQN5wpqYTgFBDPBnDwJEk2E=;
	b=eOSMwkDgC/k50/5iYCGIZAIarIDE68BDEGxSYEAaTJ/g5ThTJABNMQ2oopxElCY78vfsA2
	mZdDhr7Lr6KfLd8EtTFf8R3JBtj9Z00dXXlaBKzUiLIYE6Vyk1IwuiteYdxmZntj/zYQzt
	nKCzYnmfhN1Xsm4yP4y75zQQg++lO0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29ACC6001D;
	Wed, 15 Jul 2026 15:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95521F000E9;
	Wed, 15 Jul 2026 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127696;
	bh=9Z2zNKjRbgDz18AB/OdbEQN5wpqYTgFBDPBnDwJEk2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cPiuISMOHZKbNJ/q+U6zBqKZl6i/54DB+RZCuayF6sI/kqfwtjdaALQ69uJ88Y9Tb
	 t9oj0Gwrjx61elraU/lF3M+8XrCqQFajfZU2mv8YfRrP78r/Wx340y3KQ4iUlEGzM5
	 eE16z35L/cQdoa8olim+hEXZt4VTFLQlzUnuc/usVzrf89juTGp0WUhVkaElN3dhQx
	 LbUCrcNvso4ErQy0XseZ4PxpaGqrP2jfw6djWjwKyuHqNf1PD0jPkdNqnYsTErA07p
	 qx9E+rQb+xIH6dJ9sMrZ7/kfrX+NQDC/1YbeWlscd9NRHmuuwccHGiNexKkLt5Onau
	 bl+psB0aDqyCw==
Date: Wed, 15 Jul 2026 16:01:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH mm-hotfixes v2 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-ID: <aleYrvnf4nVUCu-f@lucifer>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <alTn7NguEW_4bodu@thinkstation>
 <alTq4V50767L-s5H@lucifer>
 <alUNiWcygLd4rqBo@thinkstation>
 <178404602957.85099.8935151447302412515.b4-reply@b4>
 <alZm0tBf8DpMXimM@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alZm0tBf8DpMXimM@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FB1810000D
X-Stat-Signature: sto6i1x3rcskub6wsi1qd4bdg9bzwqsz
X-HE-Tag: 1784127697-126319
X-HE-Meta: U2FsdGVkX1929Fdp0r9CakIPqYxwf1LsPkuvDUNVOHAu7NSnTfdJbYpl5bhs4N0LeBcfG+nuaUPztQdRERcIU39oTUE9JnPUKeD1TO4HsPVC0fVSeoiKL4FdYqOx45Qla/frxszpANdmPTt/wiqPgtWxm/PQ2ZZ8y/UP/RVrJji7TkTLbB1XbgIcqwZTzV8s2rTuqQJdKtcumz3J5DI9QxfOk4cYgolsqFhJ8eW90wyys7t6k7zFpjOptEDQPl1mPtnPHbCHnsl8So9FXiqwEvNxnCUzvfewrKXxR+sno0Mnh6bplONjk3hbkZP9qVADuONbbtSvgunaRPyypVA0mZwd5O3iJcwtGsqJ8TiJqCpH3i/dsYsfS3QbfJ3Vf+qrheNU2mQRLPB4iyfmT4UFx79KApOeBPWKHIpC6kur+wU2vRsSLryi9iVUDXEHV521+jaDPCQe0gt6ANfLh3t/CtEewoLW7Vwxpc7/yLLKbTNatqXrGIw59KuuNab0oS9X3V4XHEDWydE6VJJi5wpDS+Q+3cJ9MfGZvtx0alt2xlAF7eV9Jva8oPI1J2t0z/BP7MhYwPzvFF+RQ36q1Ob8L0drWjd+izYvvJPh+lIuu7h0/t+fUXVB9q0KihWKGfyEcivho7deiI7otP0vkAujybWi7GebPwkQTKIuMVmufd1DcixIegJ7aM7A+Y3f3+WM+NYq3qkNHpeLmSUGc7g2O/CWLOHDQ2d2+CyKRqoLHX0BbxUautT8ian9yxMvUT01+I3b7qhrT73hZw0frVrIURMaJwwxANufN+cMlKtMr0ikZmZrB1lVNLGromAYZOHWpQ7OP5+EcrlwBlELmMixV/v6445/kZEFQuekP+yh0t1aRhNhBRMpPxHMVfvI2VF7k3L+okqQc4s4QX9YpP4S0iDzTZ3ZZXly4z0anmPuo5jtTwbeG/kGbI9YCo53pMzG8OVQ6hWcH3XI1Xc02nZ
 grl3mZ1P
 2PcR0hwReS4LYeO3mIUbvIXr6kIQp8gNEsY0gPixdz+RrpRLp0zOv4TrpBgTixWjPGeknO6e1VUV0HZMBog5ifp0F2fie/rd+R6UFzu9nwXzLVOmYH8T4U5s7NEYCLuA2Ky5BXKPReynxRY7rOSvLDNh6f13jjp57w9WMSo/hBcfjgAVdCJshcEclrmWj7HPzRkNqqhvZfDDag036C08mrWM8s9HmrPKN/7mxZChSjs2JLxxjIkuULSIjOSkz78z6b4SR+4JXL3IqMv42G2kEUbeZ/J8DTAU/o1xoZdvJ+7A5M8m1iznbUOJFC9Gj0P8383GfYD9r2KgCdWNyrGk9z7O8XAD/AYcvMIPbFrMDgef0Y8vd0LnFZK2eI9t3MWXQUf0A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Lance for thanks :)

On Tue, Jul 14, 2026 at 06:05:01PM +0100, Kiryl Shutsemau wrote:
> On Tue, Jul 14, 2026 at 05:20:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Basically you need the IRQs disabled to get the semi-RCU behaviour and to
> > be able to safely traverse page tables that way.
> >
> > So with CONFIG_PT_RECLAIM you're safe to RCU traverse PTEs only.
>
> I think this is stale. Since 1fb3d8c20bfa ("mm/mmu_gather: replace IPI
> with synchronize_rcu() when batch allocation fails") the !PT_RECLAIM
> fallback is a real grace period -- note your own quote of
> __tlb_remove_table_one() calls tlb_remove_table_sync_rcu(), which is
> synchronize_rcu() nowadays, not the IPI broadcast. The name invites
> the confusion.

Ahhh, nice thank you Lance :)


>
> Together with a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
> unconditional") that means every freeing path through the generic
> mmu_gather is genuine RCU, batched or not, all levels. A plain
> rcu_read_lock() walker is protected; IRQs disabled is not required.

Lovely. I'll probably send a patch to fix the comment then :)

>
> > HAVE_ARCH_TLB_REMOVE_TABLE is set for powerpc, which also enables PTDUMP :)
> > and that's because it actually tracks multiple PTE page tables together as
> > a fragment.
>
> sparc also sets it with SMP. So the audit list for custom
> tlb_remove_table() implementations is powerpc and sparc -- everything
> else gets the generic behaviour above.

Yeah.

>
> No disagreement on the rest: the walker needs
> ptep_get_lockless()/pmdp_get_lockless(), and the ppc kernel-side
> fragments need a look.

Indeed.

I know Suren's been taken a look at this, pinged him off-list (he's also
cc'd) to see where he's at but I'm going to take a general look at this.

I feel that RCU page table freeing is likely to be a requirement for
scalable CoW, so directly impacts me :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

