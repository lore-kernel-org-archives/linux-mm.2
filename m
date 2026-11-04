Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B528606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzQFw0Fc
Received: by kanga.kvack.org (Postfix)
	id 7228A6B05B2; Wed,  4 Nov 2026 06:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BABF6B05B3; Wed,  4 Nov 2026 06:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0C56B05B4; Wed,  4 Nov 2026 06:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39DBA6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:22:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BAE812067C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:22:33 +0000 (UTC)
X-FDA: 85397198586.29.98AEAF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C98EC0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:22:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PzQFw0Fc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793791351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhlIWW6g3N+AFu1LsfAztQ3Wt3gvl8nW98AXZASgM/A=;
	b=x2LRYgqHIcgdqbBvUA/QAGZ+4Pow4KH/Ee4RnWDKygH4+/pmCtKdDk+tyRGKngZRhOA/FA
	VlTsb1j1mkPO0/acDbTNFCwZ/VwbLgWKqLz5wYtbPtXoCYCiIe75FQHglpVG0W86k5lmFq
	1PShLzMuyW7tamZq2h/DBuJjwmaWF80=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PzQFw0Fc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793791351;
	b=byXYRISm+X7J/AAfQVWPo7thqDi4cNIhZdq3kNApgjkassvx7Q6A+Au+QDDzS7yW7xJFdH
	7OoR1NfGw1mRtfJODkXORCdbaW+dmBURtSU4XyqF70ITByGotKC3U+KObmoOr6gTtapzIc
	ZtVOxDEH1PaY8Dstr5VZ6hBvqUm31zM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF6FB43558;
	Wed,  4 Nov 2026 11:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC30B1F00A16;
	Wed,  4 Nov 2026 11:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793791350;
	bh=PhlIWW6g3N+AFu1LsfAztQ3Wt3gvl8nW98AXZASgM/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PzQFw0FctCGUG1qHhQ27pa7aqyd7BxJUFvbnrW/uv19RT1NEp+QBsPx9tWUT0MRKZ
	 EP/IgnjNU2qQXaN6ydBSAjnVmbibh1JigkN4pF0k4b4TVFlN6vXgsHaMIv4OLWjbtW
	 9JZAxCVdX8vntYR8F2GsWdf0v+5nIZntQeHoeycoXS6Lh2ud8VSmqn3XOp3F5vl6Gk
	 1UEiBKOXa+yKIeI0dmRVCCjCuoSXB1eQLxtei9hnz4GTO95SjGcSospGRBVSQlJ3qW
	 ekL/wjVM9kPF4GBBy0057j6cy9SYv1Kl52peqE0i5VtsYdAP5nRfejwHQD75bTPkD2
	 5zQx0FPWv/hpg==
Date: Wed, 4 Nov 2026 13:22:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
Message-ID: <ausVbqZd9qgZf4zc@kernel.org>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
 <auo3PzmisfK3br1l@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auo3PzmisfK3br1l@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C98EC0002
X-Stat-Signature: m78gdjxsdautgw7hjxb8kts3xa8gsm8m
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793791351-212373
X-HE-Meta: U2FsdGVkX1/GBB++RdFw/CXe+dYBhbB6H7jDIQN8dOXRjT8VdRpngKg1FOtDqQDK5i4OtEIbLJjh128DCIwFyBfTfwIyyI3Sx+5pcnVBW5c+OdQpQVk5NHeXCNsr3GjrggNnThLZcJK2PGhYnmEDaihisnkM1I/PZWBHCaJk2JTFX2k71RJ6oW1yqRJuqofPbbZYt8Dc4U5A2yGFXopgC11HluqdrBzH1H+UsVjXx+/Op91i4VfdVUxAfM5vx/Rg6RBkBVuowtgwKqMsJpp5RDFmC00WsiQerqPJ/ZsU1rzCrGqBqX0y/zZMXEvLEQoMnNg0wFUguj7wFqzne5yucWLZI0cjKlNCv4Glivut9H7Uuyqlf1yzcDd3Gke+coGcneh65xCvZFZDzUHFy94VnxcczKZRx4TcIr/sVl5EKTZDUf8dqO5LkIeKrtka0Xq/x1G7uIUr2UjY3jfqdSbdYq9rk+eCGeYhuxD1VaZYVgzO7skeYmhhh2HNgSpypKf4huGPDWuKGZpBFgmISKd2JZRk7M8znbYQQnDSGJxisT0YR50iXFSSwCay5rTrl5i1KVM+tF5JYY7xWRWq6MIiHrDpKUi9VtJwHGU37CPfR8OKcCAlTNW6HdvJWKvvsoP40EcbILIE+kdvW8emqj/8PS8/uOhz+UmN6yFvTjajiOcp6Mk+eOassT/YvibCovDGJPXlgFTP/NQqSwq4pw74htZ5dwugcFkApxBuU0d7nk06luX9avPelCpZuQv9oV/JMJzenPiJPdSTx5/5RM1LkTvHNnt/CDaXjr6IKASqjILWDexz9zi5JG7k29FbFERBFBx2ATZwyaR2yzQlQByxDH/zg/rkPsohBRwWH/qSTsKlsso0MlHW1+mIrSWt6uJZzjYrP1CNv2nwxTv4rIv73cRSDkbPUMIa5f4lqE111D97ZcjVCLNfl0dyrIY9dLC0Nwm/T7SWERZcGSn3F1X
 LLH3zHRX
 qALhIVLL0BzsAm/tkIH2qkUmjOy2KPxmOCcGDO302oDwmoZ0BjMi4NQlcJSBgqdulqZ0ID7cVUre2QQ+vLgFM9pA+fuIOdNl1o44xSI82WtSCyCrhd3FubHQaLlHpNWO1jbuFB/KCueGTWy8W0S0LK7UY9reEbVCpS6zzj/tukHTDoR68gJ/PNxGps5JZPU/71U6oG/WlGWRTX13rDCS4Pv2oTdFo4M0piDNF86Zz4AZ3dGKN9fA282BkMmdtzD5+yYEfPoaIo/Z74+SMu2PyD+0D2LUfDHndkIksTklGF5Tpi3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:36PM -0500, Pasha Tatashin wrote:
> On 11-03 13:49, Mike Rapoport (Microsoft) wrote:
> > The lowmem and the global bootmem areas can have zero size, for example
> > when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> > either of those areas is explicitly set to zero with kho_bootmem=.
> > 
> > For a zero-sized allocation memblock returns an address without reserving
> > anything, and that empty area is recorded in kho_bootmem. If there is no
> > memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> > fails and KHO gets disabled.
> > 
> > Extract a helper that checks for zero size and allocates memory from
> > memblock, and use it to skip empty areas the same way as empty per-node
> > areas are skipped.
> > 
> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> > Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> > Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
> >  1 file changed, 29 insertions(+), 32 deletions(-)
> > 
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 6f1f55fe31819..f268c57413a7e 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> >  	return false;
> >  }
> >  
> > +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
> > +					   phys_addr_t end, int nid)
> > +{
> > +	phys_addr_t addr;
> > +	int i = *idx;
> > +
> > +	if (!size)
> > +		return 0;
> > +
> > +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> > +					nid, true);
> > +	if (!addr)
> > +		return -ENOMEM;
> > +
> > +	kho_bootmem[i].addr = addr;
> > +	kho_bootmem[i].size = size;
> > +	*idx = i + 1;
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
> >   *
> > @@ -832,7 +853,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> >  static void __init kho_reserve_bootmem(void)
> >  {
> >  	int nid, i = 0, max_nr_bootmem;
> > -	phys_addr_t addr, size;
> > +	phys_addr_t size;
> >  
> >  	if (!kho_enable)
> >  		return;
> > @@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
> >  	 * reserve bootmem area in low memory for lowmem allocations in the
> >  	 * next kernel
> >  	 */
> > -	size = bootmem_size_lowmem;
> > -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> > -					 ARCH_LOW_ADDRESS_LIMIT);
> > -	if (!addr) {
> > +	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
> > +				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
> >  		pr_err("Failed to reserve lowmem bootmem\n");
> 
> You are adding a helper that returns an error code and then ignoring it 
> at all call sites. Even though it can only return -ENOMEM right now, 
> dropping the return value is not good practice.

I don't think error code is important here.
Even if some theoretical future update will change
kho_reserve_bootmem_area() to return anything but -ENOMEM I don't see why
the error code should be printed at all.

And anyway, that would be the part of that change.

-- 
Sincerely yours,
Mike.

