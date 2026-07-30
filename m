Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A2DC55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEB56B0092; Thu, 30 Jul 2026 16:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63AD6B0093; Thu, 30 Jul 2026 16:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03FC6B0095; Thu, 30 Jul 2026 16:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31016B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:35:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33C6D140284
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:35:03 +0000 (UTC)
X-FDA: 85046597286.02.84EB1AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9E8D7C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:35:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9Zp8zfa;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785443701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxPQVUUeBFMYjUQxP77IGXtrmE4HtaqYq+gTa7cv8Bw=;
	b=WA6JoE4pZFynlaUnMA2C91ImrZwrQmX+luF8YiixBdwMVgskG3lFRNezmnfePMHX+IkxQE
	s40lL9SO5zCGi6H/5WYZI+goBnvQG4JDr0/O1mBtbI6f0LMudqYvhByFhSMsdzOYSRxnCK
	TVzQtkSZU8Xm9dqgnFfYyqAt/elZmYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785443701;
	b=KKGPe1nnb/UoIBmGV7teD6tlcfBJoyEt6J6FU7GBgtczWWfHpfWui/AkznGx60zH4trjpH
	TU9exhJXnebuofVNAL6g+SfFMZF84zE7ouKKHuRWZfDZuEj4RQBBYgGLu6wsZkhOA2/CkC
	TNQFEikU+sByUFCJvFQguurJLbbHavA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9Zp8zfa;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B035600AF;
	Thu, 30 Jul 2026 20:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA7A1F00ADF;
	Thu, 30 Jul 2026 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785443700;
	bh=kxPQVUUeBFMYjUQxP77IGXtrmE4HtaqYq+gTa7cv8Bw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k9Zp8zfa1ZmOgIw9AvsC0jJ3gGh7VbtLISPNsLrxUqcsBAt9qAuUDY11NK7V0XtTL
	 h3Ada4S50vzVNffn6XMcfann7GJH40vy0tUzoYh9/Q0hc1XuFft1lwOyrAz0W3/2ez
	 C8YPfSzIH0/gzCO5xnHwiICmh2+S/CWP7o69hrz1Xq60SGt4Kek2E2c+40pyotrWLn
	 L++RQ00DlNYtkSMHuABLS1PpMjnlpEwYMjRfAZk75De9n6gifR4xMwwbdx+vY9WgAc
	 xUm597feIzpmo2R7FjKGr8XSpjHqr+S29XtVhlzhif62yJiSHNT+PkiQ54pbf+q5tO
	 3Vkaj6f2LfI1w==
Date: Thu, 30 Jul 2026 20:34:57 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <amu1KN8uJt4aaZAM@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
X-Stat-Signature: 5ri7w9oyqsza6qdaq1zpx5664cmhzf8q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E8D7C0009
X-HE-Tag: 1785443701-733606
X-HE-Meta: U2FsdGVkX1/8idRWXKBmE1q8324QTR1xEJnNvaSN7fDtxr7Pnv1nzl6wVsImV8hnLJgMpJ/unSiIFzFZpG3ZCuEJqPEsXP0GFqXn1Z7YBjTtV0LyfcK+KlmEnPyr3vXbvGThkysGxp3nrV9uvtsxnjvSrYMgiVxy6YDDMfgdcpTUR1xl89zp2wbl1dUbFiYfYywD2pyP0TXk6jBJFcHVTyMshVtcyr4StHkfXP3kFF4+baLhotYekNo6maQphN1bFc2q6NlsDMSxgm5GUO0EBzvm/eJ4/fhrDngW7AMhFHfSaRDwuD7GNdJXcVPYGMWdcV6KbmL3Ie1sCdopXVG+k86g0OGQMNBRVV248tnWe2+7CjiR3GqtTgSTA5/Vko4NG8rwsXtym+gUqOF0UsNBE9r6XvZUv3A3M52Sga2xsMnEj/7gE5phs8TDNvSomI6MHZnu5bm0Eyayz3OsXqpj1gNLRyRDRM2Dk2KDPvCrv5w/5B9b8cfCApD1atvp5FlwokywUG7BDbskCxw7DNDw4iKNvLnrOim3Hld2mGtx5GdfqqjkiGzs6+9KferyPkOmrtrz6ozfIfKiuaKTEF1XxLKwrggsR2/2XSr4rQqPM6YZgiF7/fbTk5VpQwGimVQUPtR60ZW+uRcnd39aIDJIcurcDSAPHd4QAa6kkZvNAV4hz8wQNWFTEUfBja3Lly0EiaEfGh7PETUG1toMcXFGcrvNzNnh+lBCIWvbmNh2OowdghLweSovXrtYX1FKL4kFNotg5GboOLNf2zhvrgSUPkkRwBuDVsfPa6h6tMi4IiLpqS0Rmcp/RUenDx8MkK5PY4ZjQgYpCleFYgkKK4MkdRTY1dMLbeLk6sMzd26kwX9HZyYFG9DCcOZQVzjQXixF3t+67mbcxpwiQRckCjgmFnPMU7xHeYPxIBW31++AbSM1CBdqkNrTX2lVYMDWwPhMTpBreZGeCaJdMckM9Lb
 8cEm2rXW
 a6f5nLvp4ohyAEtyxuIPRjkKVuHje0lmLU2URpnKIxP7n0h6K8BDzDqIpZ7/xb67yhy7OXcqcgVlmShje+fGG5byFvSMnnaz2H3bay+U4HU79zVdNvdzu70kC7picAsXCLUs4XKZRHIiUbZNMOS7lgPAyQk0c29P4XMOD4XRtDpQo9OzCEGfVqEGMJLgJW+PB4zMSlYtxsexagJDegSpkRNKeiiUHSg3EjqEy8Z3YJDKAj0TYZYJtQBYf2SIpAh6oHDza+FPpaCCgpDqtqYdphx1cYVRqF9mKwjLj/5n2IORkPZ7kpi2Aw2otCVCsupGkSXJgjhHom3AP2HMd/1TejGorQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:34PM +0000, Brendan Jackman wrote:
> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> 
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.  On some architectures, there may be a double TLB flush
> issued because set_direct_map_valid_noflush already performs a flush
> internally.
> 
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
> 
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> [Added comment, dropped modified set_direct_map API, added highmem check]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/set_memory.h | 13 +++++++++++++
>  mm/memory.c                | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5ac..1bf2a15bca118 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -40,6 +40,15 @@ static inline int set_direct_map_valid_noflush(struct page *page,
>  	return 0;
>  }
>  
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;

Should this return an error (e.g. -EOPNOTSUPP)? Seems like it would
silently succeed if the arch doesn't actually support removing from the
direct map.

