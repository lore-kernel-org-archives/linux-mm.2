Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853B1EA3C4C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF4C6B0005; Thu,  9 Apr 2026 06:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7066B0088; Thu,  9 Apr 2026 06:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD426B008A; Thu,  9 Apr 2026 06:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE2696B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:44:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A520140764
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:44:19 +0000 (UTC)
X-FDA: 84638683038.01.54D119C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1BF8518000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:44:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+UXO2Te;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9Lfw49qVFwn8/7T7s5W8rSUWCFn3rVo5/dWn6c2Wwg=;
	b=QQePM46x1uoc76rH+VZBfc6nP9Yrb0xGzKM506tlC6C30YhG2/h2gfy07LYOPTMlCcofe5
	Zg10e3PesNuCv0rgGhtd/L6oDGQoYqATXIvi9cKqxC7HZTXdmKfkIEVFfSVndUaQ+jPgGN
	RwVD7JvdbVZ0Am2pQw5zmEBHjInz66U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+UXO2Te;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731458; a=rsa-sha256;
	cv=none;
	b=W3jxFTHwW7vpeH5Owf/aQQeEdJnhM5sv82v6+NrBAZ7/RHZ1m4nuuHdwM0XDXPeOI0HuTQ
	YXYE/htv6yJfdUEIdAQ+/OO1RPxMB0f8e2yrjgWNLl0MSwGNi72ljO6XOBuGRB9dpU5RTl
	PHHwmu6lTCJxGg/fNsyhSoDbhEngpeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8175160121;
	Thu,  9 Apr 2026 10:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65285C4CEF7;
	Thu,  9 Apr 2026 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775731457;
	bh=4MFRTaxl6iMcBtXLBSVYfuS5O6SXdiJUZpY2SawBjc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N+UXO2TeiTIt2GFrX3ah9Dw/XzmFtWQulTegodX0DtOeZOuE4Zwz0rKKOodMPXVoB
	 tXoECHVST8Lh/mfI4yCT90UGU+vsLJF7yzaE3EVypbWuCWENDAMm/ZTXTqjlwZwOAn
	 ph6As8YUo+OkflICmg0PR5im7kdyI+k4F7/SqXlAhmKXFhiwF0EGU4J82t/NrXeruW
	 hAAWM/6vXPqi3EiwPVTR0LmdsgiUtIRjPmIBXCMnUCAqfRL2SVXKpM6zYNz12Cbnp7
	 8/vVPKs7GkxnW73PBe/H5IviH/fi8r0K1xSwPQnV/MVFjg1+lE7OxvPF3LfnS5eqSA
	 XlMvyxa9ZqFQQ==
Date: Thu, 9 Apr 2026 13:44:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
Message-ID: <adeC--_dkgWHdSPj@kernel.org>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
 <20260404122105.3989557-2-songmuchun@bytedance.com>
 <adIKIhRL6q2NIgnj@kernel.org>
 <D0D4B0DA-56F3-4ECD-8855-96C21A6DE1F0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0D4B0DA-56F3-4ECD-8855-96C21A6DE1F0@linux.dev>
X-Rspam-User: 
X-Stat-Signature: rcmphh14m18h9yzt1bf6zzrikhza6cmp
X-Rspamd-Queue-Id: 1BF8518000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1775731457-983482
X-HE-Meta: U2FsdGVkX1+muurRNOawyDY9cZYype6drgjNg29agGkrjZZiLJKjV/D8uN+UTRDuxFL8C8xWBkBoHFKlvR4+BVwJG2Vw+IremDpkJbn4kUrViYByD4IfEoZxoXI4HXLp1vI8qzk/oXijuotevVTGjXBnN6kvWSupdXQ3nDV5+Viw2dPZ8hw8f+e39VmbwE1FTaF2r351/fmY03J9XhVBRqlwq/z6jawkP+XyuhvA6zloCh3rLBohvzvNjMvgkhuNImU1r+H/1vcrtb12MPTewAn57XOnNE4QDfaPH+R04eBYmdlvy7jXS0vfRlcz6gPk7d3UxNZYMZAjCLeCkHUGMBlBUPy1VMe7dj6T1MODJDSeqcNf8luvGpD06R1ssFiS8rCCgt9S57OaxaIjVfis5tX115unZLmTpw9dr9hbhvjoMpLT8K3p8rG42zjaQPyHSjyMTAuaFkDObkbYgSlI0pgiF0TFPKBVR0gf/9bw52hhgAgagyEmCDF0UnSIAOkUctwyNWNf/K27KmgluAP/NcY1yURbxDCBKOctIcpZTUut01y92BF+0YlzKKRawNDV7ktF8VSEms8CUlrFPN5CEiJOoE9NITkdERHMXbYdSWNBtzTqcuKoP88qbJaVHedjPj2+4FXfWc7k+uDuBSdOuAYWGt/Wj+ANJOQvPROL5AjDsPkpsYrukD3BRHBDI3kZSZ2Gw97WiX/fDIXOKauoYfPANgYAW243imL8xkI6s6LP46gOGbqpMn8no/SinCkHOG5CX6oQSZZ4ol2Pus44EqwqcOwsYAUzKZkr7iGam8EzaV30LMatds6BemC7qUIFQ+IbLl+BobR1ET5iNBu+ZWQRSHtHSmBOWpp6fVfklOR6sYcAIt3nDNbhjttaiioV8q0Rcj1udsI/lFVJiVOgucOXJXnEG4bk+IkYbVWszY5qS3dmt0EaELy44Ue6JB/t4I93P/Ec1pyWUH/tTPb
 ILx/8aGU
 wdiuu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 10:07:36PM +0800, Muchun Song wrote:
> > On Apr 5, 2026, at 15:07, Mike Rapoport <rppt@kernel.org> wrote:
> > On Sat, Apr 04, 2026 at 08:20:54PM +0800, Muchun Song wrote:
> >> The two weak functions are currently no-ops on every architecture,
> >> forcing each platform that needs them to duplicate the same handful
> >> of lines.  Provide a generic implementation:
> >> 
> >> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> >> 
> >> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
> >>  then calls the existing vmemmap_verify() helper.
> >> 
> >> Architectures that need special handling can continue to override the
> >> weak symbols; everyone else gets the standard version for free.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> ---
> >> mm/sparse-vmemmap.c | 7 ++++++-
> >> 1 file changed, 6 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> >> index 6eadb9d116e4..1eb990610d50 100644
> >> --- a/mm/sparse-vmemmap.c
> >> +++ b/mm/sparse-vmemmap.c
> >> @@ -391,12 +391,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
> >> void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> >>       unsigned long addr, unsigned long next)
> >> {
> >> + 	BUG_ON(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
> > 
> > Do we have to crash the kernel here?
> > Wouldn't be better to make vmemmap_set_pmd() return error and make
> > vmemmap_populate_hugepages() fall back to base pages in case
> > vmemmap_set_pmd() errored?
> 
> Hi Mike,
> 
> Thanks for the review. Let me explain my original thought process here.
> 
> My assumption was that pmd_set_huge() for the kernel virtual address space
> should rarely, if ever, fail in this context. Furthermore, if we look at the
> architectures this patch replaces (e.g., arm64 and riscv), they are either
> ignoring the return value of pmd_set_huge() entirely or lacking any graceful
> fallback mechanism anyway.
> 
> So, to keep the initial generic implementation as simple as possible, I used
> BUG_ON() as a strict assertion.

Fair enough, let's just make it VM_BUG_ON().

-- 
Sincerely yours,
Mike.

