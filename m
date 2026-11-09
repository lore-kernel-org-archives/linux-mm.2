Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D806A606D808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkD0ZTkK
Received: by kanga.kvack.org (Postfix)
	id 084046B05D2; Mon,  9 Nov 2026 05:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D006B05D5; Mon,  9 Nov 2026 05:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7F66B05E2; Mon,  9 Nov 2026 05:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA3686B05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:09:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E741C0615
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:09:38 +0000 (UTC)
X-FDA: 85415158836.09.7F12658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE51B160005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:09:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkD0ZTkK;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVDZpxqqtGXanXSa85zXaSGNSgk4+pujulEU5rVUYrI=;
	b=lWiFE78zLdCxJm8e70OxpQ8UO1r9TVKkZpJrsdY7VvZe7+UvV59PPgPClpn4sYgsSr5aJZ
	BRxFZqFS1wcvE9+Z6TN3U6uI+KX2qWGO47ziCsJnmY6S0wVYGUZ7kUBgCu6OC+Bx19475h
	Rc+c4cuYzyf/nHQD1hk/S6M/wLGRo1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218977;
	b=lDSgF1Z9IyQAVmQJXojYi8NtfXFvK4qxW3VoXQwEgPC/mtfOyZKMZXqiD+Gwdbjsyrpe4g
	IzaJVGoWmdCOQgMAOEiT+8Cuzon6U1qPFPJ6EvqxYX200kDD0/7PZtxNhVec0237hxR84N
	c+UOvAtyNnm2IGpvK28e5ChQ1Wi0eGI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkD0ZTkK;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 898836306D;
	Mon,  9 Nov 2026 10:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA01F0089F;
	Mon,  9 Nov 2026 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794218976;
	bh=cVDZpxqqtGXanXSa85zXaSGNSgk4+pujulEU5rVUYrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RkD0ZTkK4UPON4c35h81yShsugX7KG37JtcxD2aUF6JUC30zWJqFhbDGyKqUah9ae
	 fP2maAVrCgbTCNnhOWJVTJhjX79zLJ/0RE7a7icltlw54oqi2yDeZ2WhBVR4ulKCT2
	 swE1tBlCR8QmzwQs3Tm3msHIU6pou/hNuz26EdKD3d+L0lrIbcRdJcLxUFT0dGV7A2
	 T4+0CI8h+D2boYeyH/j/gl6VVoSMgqf/fas9k5ObVWEF/08LvOecImOd6GEnB+Vvv9
	 TKnxk59d9A/Keuth0/lDlaE1ixFwS/OTMmkPcerP53RJx8DGnJL0EkgK2mC53fElRk
	 2xZZqsrVZFqkw==
Date: Mon, 9 Nov 2026 12:09:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: Don't release incoming bootmem areas when
 kho_init() fails
Message-ID: <avGb2Trm-C3_YC-7@kernel.org>
References: <au_vQhHAcJbkryXN@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au_vQhHAcJbkryXN@chrisdown.name>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE51B160005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: tufakd8g4gx6do69d1fscfukkai76qdu
X-Rspam-User: 
X-HE-Tag: 1794218976-470764
X-HE-Meta: U2FsdGVkX1/GuksIIAYoAHCwVARCuyXkP1iGp9qmgMIPY9+tmlSN78zRGRELGzViKV1r2x1NDqmYxBgayg+Bu8G3Oa3w485nagEq78Kx8Gcbaprv1yavy82CBX4eHyuNjSbNXrI9hJGLcLRcWtWcfdlXUrack+nR3/YmwCQWK08BS42XtAnFVnOMAkJxEKRreuQOTMG3RZhuPwcV+44pAAMBousV50ItONMMJuA0KhlY2sA0dn5doOvrA8ExtrTRCUs6u9Ar/SLFDn+zoTcoLB4MGc/+ApmG7apqcUa2eGpmscXgdfx8ABBDSBfWH6iTNF73xMcCexnudgKtQPdhXjsyhuDrM1Vfhrh/MEXKmDjLw9aTGrNeM21d6/+u8ZE4zGIBQQafH5ulvN1Q4EbY03nWKOwR3auLgT1aEz26DOSGdZxH4P/Cw64zKTrs0NcZs0CCj4mfN7vvAgP3JQlv4RmRH5bUwtsfHOQEyYY7FTrT0Bwugtx+KW4rG2Wld/OxH7dEMLJiR3WNn6HUs9mawnV0h0yzJTpGfVXNGivMfenEwUbwLYvtUHFG+Yeuxmw56CC7yJK8wU1fmpccUN6R4jRo5zlmBvhOVFxOC2kO5YWnW2GnUqbpHzavAct2145HOUrRSGQsVtX8bc+AQN6bCk5YQiLCjswcBrPMkJImWf55to8i+3ak70MoP6foYbc2nxPO5VlQCeI6UPrpRpuUM62oDNww0MLuXOd9bOuP+mXVJ3vPr+kUc6eMXky8Svo++Ud9AAYhss8P+eUkFwQCNPyU9pePldrLQlLj2tzzPL1V0Aduhf/INuQvZJiSSNsO8uG8sw+Qa+lRFR/froB97FnVjfDZTLI0bPNEOKqTD/Y9muuq+xJqBPdNwnRzmgi4h1QRR/pDUklRWgNsK2ozw/5XerDCHaJ/i6GnMlH9j+qZVu3rjZwF9BzhvezqxCOrn5T/ckFKj66k/l+qHgZ
 FVA/yWzq
 0K3q6d8rrpmazXUEGiveAvJ+lgddyo6JiB9KKlICTk3Q2/9KaURENW72y85r7jAx2XKcOs645WEU7vzWeOO30rlQl6vIQK2c4Ws1/+BbwlwVQXg9frGfUqSSuzOHqQovgjIYxwu0d+Yi0TEuYIoTJJXlMgRSAKplYOwU3d/Pvi/Tux7cG+XHl4l1Z+7GXVqUAI1AFRSaZzWz9zpXmn6jHQfEaS9EQshXY0FaVMOvN92wZkurtS7wvbnsAfapPlJQm1h+3IsbP2anL75WLI49aD3gWzTLYGRJ8q/nKOQ7kfJ2PqGPTUR5JmWS11ocjNiLI0P87FncIko5UaL2V/JJtRbYRxtk2/uVbRyTJ+gR64xXZc6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Sat, Nov 07, 2026 at 07:40:50PM -0800, Chris Down wrote:
> kho_populate() adds the incoming bootmem areas without reserving
> them. memblock_free_all() then hands the remainder to the buddy
> allocator.

This paragraph is confusing.
It reads like kho_populate() should have reserved bootmem areas, but it
didn't.
 
> Unfortunately however, if kho_init() fails, err_free_bootmem
> currently frees every area with free_reserved_area(). This can free
> pages still backing early allocations or free buddy pages a second
> time.

Is this an issue you hit in practice or it was reported by a code analysis?

> To fix this, let's only free the areas on a cold boot when
> kho_reserve_bootmem() reserved them.
> 
> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..a566ad6634d8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1899,11 +1899,13 @@ static __init int kho_init(void)
>  	kho_radix_destroy_tree(tree);
>  err_free_bootmem:
>  	kho_out.fdt = NULL;
> -	for (int i = 0; i < kho_bootmem_cnt; i++) {
> -		void *start = __va(kho_bootmem[i].addr);
> -		void *end = start + kho_bootmem[i].size;
> +	if (!fdt) {

I think using !is_kho_boot() makes this clearer.

> +		for (int i = 0; i < kho_bootmem_cnt; i++) {
> +			void *start = __va(kho_bootmem[i].addr);
> +			void *end = start + kho_bootmem[i].size;
>  
> -		free_reserved_area(start, end, -1, "");
> +			free_reserved_area(start, end, -1, "");
> +		}
>  	}
>  	kho_enable = false;
>  	return err;
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

