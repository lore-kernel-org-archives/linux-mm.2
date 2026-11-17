Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC988606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dtQ3W2NP
Received: by kanga.kvack.org (Postfix)
	id E3ED06B05B3; Tue, 17 Nov 2026 01:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0A86B05B4; Tue, 17 Nov 2026 01:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06726B05B5; Tue, 17 Nov 2026 01:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55136B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:05:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5485914032F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:05:37 +0000 (UTC)
X-FDA: 85443574314.28.07B46E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7457320005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:05:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dtQ3W2NP;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794895535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KFUwb7S38PDGJnYKL636C5VeONl95jXTsgqB82LNu4=;
	b=gYrSMGRbRZwK33eEBs/GQArsc1J4pPUJbf6gIgOThwewAH/w74z4TjMsEn66uzfhdXbEKz
	WoAC09AKxDV7eDu4iA3pNcgvvtyVGpNxMgomjLtMv8bvP8XzoMB2SsuaccTWGL0sDxs0SR
	0OtN4GHuXhYfX4Wskzm3tTQ0MqRTX+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794895535;
	b=zzEqG0LygmMxcPyKLrWo3wMsIi/Ldu53htGp2Z7mDGV7W0tYQwI6JOp/uGHql3qGlhfH+E
	ZVSW/xxNoyzz0X0TFHM++1yvmPqKxMFeBVxI6P5HyFlKoMbc7+M7RMYnL5Ftp5TbUTQubu
	t8ZfSBPWX1CFbxZbHaq/95Pup1wAVPE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dtQ3W2NP;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FA551682;
	Mon, 16 Nov 2026 22:05:31 -0800 (PST)
Received: from [10.163.156.60] (unknown [10.163.156.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 949E13F763;
	Mon, 16 Nov 2026 22:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794895534; bh=9u1GHEq8hMnaJQY05Ky1xgqDtbgYPoZC4iyaip7LWL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dtQ3W2NP24PUe63hKoX4bbI8JEiTSsSWWQu9D7DyMy/pHZNUmqrIFmfAnGaZ8kXON
	 89dH4GviqDm13Qaqsx+/h2/y6OdcvX3TjsDcl8TDib3gTh9PbrGtda/fRVDobnGWO/
	 /vF0mbRpZFiOxKGkNycP1YCeYW4+Xb8SRDAd2Wqw=
Message-ID: <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
Date: Tue, 17 Nov 2026 11:35:24 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/11] mm/vmalloc: reject an unaligned range in
 __vunmap_range_noflush()
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-5-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116071325.263682-5-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7457320005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: cwcj6in889h6sgsx7xq6nd4hksbyuyr5
X-HE-Tag: 1794895535-527279
X-HE-Meta: U2FsdGVkX18m2Kb6E+MUL+Ngd7t8ehNE7tWNGjYtMll6n0HCrhGjC7GVPVTL6rt5cATL7C5clgqJcjKNYa0Wu1zNAGudFSxhuR+dw/YU53dzNTRmwfzIoq/joSmsw3I2Iedb2/I6s8ZSq6EMg5fdpyqnRdyYF1c6j6Bf33EFHRkGjEtyJ3fPU3qtvDbMUHkeGv3azkds/4L0QObnLPW9mmbaiUzqFihN/W7jU3uOAPGYTfYF5aMoPaJuuM/hwl1ofhLyC2cG1Tdnr9N5CJBAJLE2vJgGigZD0JIDcq4FFm+XJotovwKuvstMsTlLonVV36HRbeX1vm4euzRqj5SYwwcTdnvvIry1ttYOn+M3iVvNZZm0b4L0qgbrYTxz03m2GZN60rpeCzNpfymbxtFox2kEFRI+VgfyUBJZDwljVpyc1YttmRQSICmh0EEvh2N9s2SpUpkMa2iwvnTa2ifCqfROlHHBAmhFreFD9HvVA2SJZcsmo27xcZoKk2tXJeF90qS8kHCnImAtlQTGXqS/Ch+IllEloNBp2r2dJ84om/Ze6z17LXj9i888WP+5MBvmRoNhEJlDX96XJjTaXTGAlE9WFX/LjSgIIe4KuEa2+yVCgLmxqmn2NiLj9F+3uzegtozGVD+xFUAlYTWjpwD5yAF/D+r5MmaTZoFMeFpe4m/1L9QKQYcC9gLbr9wLG7BvRxXKUBQHiLyZJkR9Hrs+dCHugtYI7NwdMGGmzCFLxokbAwbsuyvbgjiQB/yTGfPk9phcpLIprRDVapmm4votpM1ZvxyX9hULDM/VjUwxzxdkmF0rJxxJ6MyhHLMh7RAwOq1ZsMzXoh8QeX2U5h8J8H/WZShV1sa8CYr69BJcsBnDDEAF1wNjLDGUyMcbcfhuhcjsvFW338D1y/bdF1y1+A+G6lCZKVgceA2GoMQgOygxiPpAfDDNBujsos3E1epIyqgxhxyKInSLRh3geuv
 nWUofyLA
 FG737HWRvKvr3Lxrci47QE+GVorNHEtrVzQ6qD/epS92Zx5aPWbmA4KF/vfr1XhWZaU5+oinmKjFlEv8QBro7IOipPPbrJCy6jv/OCBkHyClF2K6V6mjvnXa2SMS1jw32h5SAOsRii94bFQBaE/u8y7Go77ZEKYKTGPtW0Yqk7egtbwghPVNFUqaXNaXZ530tV/5N7AlNO0rIjG6wLzf7zPISsllkrVmth2/eJe/OGRyPPAg+gFm/k6Rnx2amSVKN0NM5BnNPG+RJ1rNa038CfZ8CCFFK/BDeT+BalJk6gkvNDLOnuIrT4OpmsQYt8uNtPhidS8OiXdRXbEAtyMJjzmSG7HHld4/POdqJX/pzFpasv1Pexis2Fx3T9PbbjDPGxDueZFeD4SqVwUtSJmgM+gM3d8MFblJrOQDHAocAN7j81BQefOCVqXmZM73K3lUHW5ns
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 16/11/26 12:43 pm, Hao Ge wrote:
> The PTE loop stops only at addr == end. An unaligned end is never
> reached, so the loop keeps clearing past the range. An unaligned
> start clears the page below the range first. Both are caller bugs,
> and the damage is hard to attribute afterwards.
> 
> vmap only installs page aligned mappings, so an unaligned unmap
> request is never a legitimate teardown. Warn and bail out at the
> entry of __vunmap_range_noflush(), before any PTE is cleared.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a168f6f20f4f..e2b63cb1592b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -523,6 +523,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end,
>  	pgtbl_mod_mask mask = 0;
>  
>  	BUG_ON(addr >= end);

Nit: It is usually a practice to change the existing BUG_ON's to
WARN_ON's too, if you are changing around that part.


> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> +		return;

Reviewed-by: Dev Jain <dev.jain@arm.com>

> +
>  	pgd = pgd_offset_k(addr);
>  	do {
>  		next = pgd_addr_end(addr, end);


