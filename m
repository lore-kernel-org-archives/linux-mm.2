Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31673CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA386B0012; Mon, 24 Nov 2025 09:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591D06B0022; Mon, 24 Nov 2025 09:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE1C6B0024; Mon, 24 Nov 2025 09:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9AF6B0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:10:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77379C0408
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:10:02 +0000 (UTC)
X-FDA: 84145684644.30.3F4FB35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 852BC10000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:10:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fn+KCCRj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763993400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8G5fnunS4XtYzsuHwEAt2+VrWQNWQA1EjOphxoaxaK0=;
	b=xmgU6QbctOmFqGNN2diXca6/x5iWsgq+9MMVdxQHQuq4zTfuN1vANV/uHSnMeoIFZUYUcF
	hlq5en4atrmT0xvNelJrXnhcsbDqlaZtbLNMMMwGVQd4btUFpcMH25HsSLYxUySLwZvm1L
	ls4goB4ZkXSAQRjC0N5vlqscuo+aBzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763993400; a=rsa-sha256;
	cv=none;
	b=uuEejvuQ7Zc+nvyGUMinoWsqDdgJVjeChgn3c+BPFcsF6bOqhx9RvO6zhhFRgxb2eZePvI
	Nbcyv+BWlif7GfseJWS6d+1OgKCJjcy3ZKTdLQH5E2RPtuizjzrJKl9w99igGd/vZ1dRfP
	0YdZqeINPrLLB7umD4Z3dX0XhwyRako=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fn+KCCRj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8396A4195B;
	Mon, 24 Nov 2025 14:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1F8C116C6;
	Mon, 24 Nov 2025 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763993399;
	bh=TWEkufK+gYKT1sSMXcHmAUd4hn/Rf+NblbWiRzqjYXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fn+KCCRjb50rns8DRSbP5eHwsxgoY/Kml4PeEgcCJeD26M9vYXui7/aT7inSMbIxf
	 YzKx3Oxi12/SHccP4zqiAZBpkawAjBIrdIq6ojtNJ3MqzZIZs/6LWUcWZiW8b0FuJE
	 Ml+dVSCPPiz4nA0kHauPvd8caafMtHO4bKeEncACk6GoCcx0j21HPCEQRfm6P0giCM
	 Ly/blKcvqn2emQo6jii0GCNdl30wtJ7h2LuC/4FBTV86yMpoaQeq2/Vb5EVoAwqxwk
	 Ook4PMLPReVXf+dc0dSemeN/A7u7VMwVtjwjGYoNs7r8xWNS2kh156oqM6wjxrgdtJ
	 4TjfjsfNIahLg==
Message-ID: <886f8f49-f113-445f-8f1e-3cdaabf7b38d@kernel.org>
Date: Mon, 24 Nov 2025 15:09:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251124132228.622678-9-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 852BC10000C
X-Stat-Signature: fqii78cbfrceb49ee3nmyiburj77g1i5
X-HE-Tag: 1763993400-570545
X-HE-Meta: U2FsdGVkX1/e5N+lsqIOKA/5w7dJZSMnrEHKSexs6GkfyvQqzxHV1r6yWPz8MRwusRYkzKTJCKYn0klwkxsByMdjVyAcXFVKRA4hAxv7cz+0/OmDeBXlM/abRlnOOXw+66IrK89f8fU7cx70Qw5yxXYNEJ5fxutuyU05Be+gyJ1K6cbgDz/Fs/qnDA7RhloRe148Tfc6JR60qgn4u072InshoRzO7Yilt4Cvq+GvKkUKlfnBMHDZoEkcpWetmFDjx9bVj8ZNKwg9GYrpQHjwmIMUsL/Qvt1D75UYHk2MHoiGWFTVcVaoBwBg059lZFW3TTioWubBai1cxXMdo8zuVF6apBqBEEE4G7fjEodmsYJoE0WuRu/ba+smkBJ1jjYKcYPCGinADo9xgHu3Z7HXTFEkljFfNZBaOsdLgUpyC3adRocmfVJSbgufE3zZ7vuAsWA4rfqxMKsy3CxWJe7dyUL0bSeZ7gRbgbNkKjcWTpSHZXGsHOBPulTYO7UMNED0sWdcL4A6uC9AMpsFxzhXRHlEMIeEs+XBYR9iszYGXFYFFjuNdIq2gm9Al55LvhfNH3Csk3UN3Wo2HXwHsg2a7/OnU5+FIxY7xDDzj5KR+gGbnAfHuT+GWmDhAwgmCExw2dlx3DeGhAlEwxUeGxz8v+NHiKdQpjcRDWhF4qh57s8Vei2rddOQNbhvmeXkjY1R9NkLYLs3h8m8UO43QC0J/1dwDim/ENRn7vU5PJ9qzISo6kCQI1/HdHnj8MTlPv7dBIwyq4EmhBiN4vfPBeqzGCH3BpebXoG6OTpYc0zB6GabDJl5dH2HmVhE3sDc/ms/VjL7dLqS/OBuMBEDGpDGDcyqkqx+JnP2Nju4uzaihgSa5kp/RO356TQGhc3I+ZBaAtw0fBZjAzpfi3wqsGUnnD9ZqaHieiTtYooT+HAD06Lj3SQwZdpjU53IrXO6tjazjavylzQNUbX5TuQe82q
 ck7veKch
 ch4AOFjEb/W4xGdAQeithN7Bd+b5dgsrBwR1Vy4YqyaXhAPzVQAzs/LP/s9CHVjJi1QdqaSAvLHRlGvu8dHgQ7Hjq3DiDTfWxfdSh6c2gmOBG3hAYmsVBqez0kAvz25V7AfsFux4jgrqNDZOEtewDb4mZh1IOF2O6M2Fom243lME/rVknq7rzEtmyMRsyU/G5nt34TEsMzzCyapwYP+Hp9/a5i0A0dqSFztvEax5eLjpni9wnWlpYgduUnCvfoCFJqMRLNpFh4BL6qWpiIQStAscveNs6/JGt907l8Xs2VufaKpyXcRd5m2aYSCetwUQXaKGHgUxfZrUe2R+aVPWblLCJ+vQ9m3iwTyK5jxmRG1Vv9Ke7HmXi+erIdp6kvbF60yEycZiBmi8mQcqWtXaWq4Z0TdEbrFbUCYU9btAS9pFxC317MVPocOuTAHHkmuloslFcIlKfDF1W3fG24nZVELmQRsMWAr5lQ8vpiW2nx9Ds7gg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 14:22, Kevin Brodsky wrote:
> Despite recent efforts to prevent lazy_mmu sections from nesting, it
> remains difficult to ensure that it never occurs - and in fact it
> does occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).
> Commit 1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested")
> made nesting tolerable on arm64, but without truly supporting it:
> the inner call to leave() disables the batching optimisation before
> the outer section ends.
> 
> This patch actually enables lazy_mmu sections to nest by tracking
> the nesting level in task_struct, in a similar fashion to e.g.
> pagefault_{enable,disable}(). This is fully handled by the generic
> lazy_mmu helpers that were recently introduced.
> 
> lazy_mmu sections were not initially intended to nest, so we need to
> clarify the semantics w.r.t. the arch_*_lazy_mmu_mode() callbacks.
> This patch takes the following approach:
> 
> * The outermost calls to lazy_mmu_mode_{enable,disable}() trigger
>    calls to arch_{enter,leave}_lazy_mmu_mode() - this is unchanged.
> 
> * Nested calls to lazy_mmu_mode_{enable,disable}() are not forwarded
>    to the arch via arch_{enter,leave} - lazy MMU remains enabled so
>    the assumption is that these callbacks are not relevant. However,
>    existing code may rely on a call to disable() to flush any batched
>    state, regardless of nesting. arch_flush_lazy_mmu_mode() is
>    therefore called in that situation.
> 
> A separate interface was recently introduced to temporarily pause
> the lazy MMU mode: lazy_mmu_mode_{pause,resume}(). pause() fully
> exits the mode *regardless of the nesting level*, and resume()
> restores the mode at the same nesting level.
> 
> pause()/resume() are themselves allowed to nest, so we actually
> store two nesting levels in task_struct: enable_count and
> pause_count. A new helper in_lazy_mmu_mode() is introduced to
> determine whether we are currently in lazy MMU mode; this will be
> used in subsequent patches to replace the various ways arch's
> currently track whether the mode is enabled.
> 
> In summary (enable/pause represent the values *after* the call):
> 
> lazy_mmu_mode_enable()		-> arch_enter()	    enable=1 pause=0
>      lazy_mmu_mode_enable()	-> ø		    enable=2 pause=0
> 	lazy_mmu_mode_pause()	-> arch_leave()     enable=2 pause=1
> 	lazy_mmu_mode_resume()	-> arch_enter()     enable=2 pause=0
>      lazy_mmu_mode_disable()	-> arch_flush()     enable=1 pause=0
> lazy_mmu_mode_disable()		-> arch_leave()     enable=0 pause=0
> 
> Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
> headers included by <linux/pgtable.h> to use it.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Nothing jumped at me, so

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Hoping we can get some more eyes to have a look.

-- 
Cheers

David

