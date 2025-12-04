Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC3DBD1CDC6
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 03:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55C06B0008; Wed,  3 Dec 2025 22:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D356B000A; Wed,  3 Dec 2025 22:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969D46B000E; Wed,  3 Dec 2025 22:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 851BB6B0008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:37:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 329BF52028
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 03:37:12 +0000 (UTC)
X-FDA: 84180377904.07.EBE3DDB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A81BA000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 03:37:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764819430; a=rsa-sha256;
	cv=none;
	b=uzwA4bkxFVkxTDtF463eDnK1shrd8M+h6lpP49S7kdCzHN/zH+I9hT0f30oEePexGSeY3Q
	4UGfs9Sh84WzxLHBkpJw67e3zL4nMTnY0YAFarDaK5ufzbgBM4I/IQp0/ReI+qdjIoLmsK
	04VIjeMEDe6jruqD5EDmZsTk2TIVH0I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764819430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dVecSCDZ4D/iA2ATENTvjoFCAr/DQefu4KL07xBdnlY=;
	b=2vaIYuRw6x+Ir1Sc5qlvBI/961oE469aAEQvAqkpQACA4gCwUINPN5rrCddxuxXsUCtK8K
	kpMXm09ySC/qbQQJ4ZKzIyy/pJ5RxYla5EQ4MluVdCeOM2GD1LkfnJVX12gcv3QZFIqQUs
	PDqk+qgNlTnTq6DX1O1qOzdCjaoxBnY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63087339;
	Wed,  3 Dec 2025 19:37:01 -0800 (PST)
Received: from [10.164.18.78] (unknown [10.164.18.78])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBB883F59E;
	Wed,  3 Dec 2025 19:36:58 -0800 (PST)
Message-ID: <15cc652c-937b-4d5b-98f3-7cdcecf28e27@arm.com>
Date: Thu, 4 Dec 2025 09:06:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v5 02/12] x86/xen: simplify flush_lazy_mmu()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20251124132228.622678-3-kevin.brodsky@arm.com>
Content-Language: en-US
In-Reply-To: <20251124132228.622678-3-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A81BA000C
X-Stat-Signature: ujzawqdinza4mhcpdagdzc5cd49ew949
X-Rspam-User: 
X-HE-Tag: 1764819429-559922
X-HE-Meta: U2FsdGVkX18p8usFouryfokhTnJ7SJ2M2nxjjW4adErzPHl1ppuF9fpgzpqPOYvwRnkq9CUE7bZhwdZNKEC2lubbwuGcJAxJvzm+2jxREhYT321G3aSbvDoV27cbQsYlpdWDkn8M3uwBhrPOIlpOVlbjjzUHELqlyk4FjZdDeaoUjgwOMQpse9Y7N43g0uFKLXZ/iQdricrbRs+mRRdt2Mb0idpgt3JI55QMnyAqj0y0BETsDC65b1IE/yCRlL98NkejhHwIzdLBbIFBEdNaJ75EVopLZYnTF5EbxrnW0fKQoyY5vbV421hYQQlh0XAW+TEDil4OVfHSeVY6uXHgvi6I+QTkMJdKWOQBzKZSDJAAvxCg5jdUUHTIkmH6vWecTh/en3ckWCU/e7ZnLbvj2KNmlyMcXRMnjz6vjR4hFcGOEaxaUckGbrI/37/kJCkYdVBVD57M710ejA9GoueXZlpZpUbxhWkIbAdWpTC7UJkxasftrfyjfGT9D3gct7Y3e++BdxycmAJKRUs4IEUm3192IUzv4CW0jscbx5p5kNskr3Iq7lB9FqxNJJPkKDXkX3Se+4Xoifl3xagGppA1UYDjrRrEfMGXT2IZSWSJeat7B3Me9iWcEvTmVIfAUv0QVdCHlWxVsUNB3SXhUC55PJ+NJK9CVwsncSVpTRdmBlR/bC+DviLxtaEKo0HduU25W0ri3JEULB/EjT3LbDuhrx7lVTr2r3GjZywS6sQlP0UN57pvYijZVJLWhE4BKPemoeXZ7VqeZ2LvDkg2kXoEjiB6Mb9rsZAv+xhUmW5dMy54YKSlQcqbwZWQEWcZ4Yu8s94Me3IMJLTiAIRlt5lQMyQgMAaK1ebftcJTMsR0jzM4PczlfePJ9cRuEiDmYiNyCfz+wvzOCdvorsJgBDw7xl+NWJr/Eze04gTucEUpxIUEtqjoI0qAdjZfkaC/Us16MhTlnlZIPcMP5swuSW6
 6IC+1AE7
 6N8wzMzKEEqZngmA/aqkgZ/+4FFSAdzWsT7Cm098rzbHSts3T8K3S5Ew6XajEy9I6Ph7ZDLo7qnTuurHp7cWYjhLu11VwC8LQOma2GnqjhltaAnxmba9AgX3dGMFwX0z8Wkqc13tDPXflnHKbdbcbec8J9ipUtmEWEe3dtZEhuHoUqyhLUGu5kefBA/qNw/232RH7QqBEtR4x6PW7i4529Wr8mU7u6U1nBB3gL/TbgWFyp4TsuUfQ4LutmtOhpV1YjJnILy3ueJ4SNqHEIOtyUf7npI2aTF0Wts1WmF/ilGk8j8uq0HZSv/XN3g2GOwgBskQfQjfGyuQ+gByz2XSbFH/vrHgGCFuBj9HPSOg96aa2GCorzd6QwGGqeNYZiZASPthKy1P4uxSZjtD0ubqTyW1eGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/11/25 6:52 PM, Kevin Brodsky wrote:
> arch_flush_lazy_mmu_mode() is called when outstanding batched
> pgtable operations must be completed immediately. There should
> however be no need to leave and re-enter lazy MMU completely. The
> only part of that sequence that we really need is xen_mc_flush();
> call it directly.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

>  arch/x86/xen/mmu_pv.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
> index 2a4a8deaf612..7a35c3393df4 100644
> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
>  {
>  	preempt_disable();
>  
> -	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
> -		arch_leave_lazy_mmu_mode();
> -		arch_enter_lazy_mmu_mode();
> -	}
> +	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
> +		xen_mc_flush();
>  
>  	preempt_enable();
>  }


