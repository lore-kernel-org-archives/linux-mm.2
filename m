Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2049BCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FE76B0005; Tue, 12 May 2026 14:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7616B008A; Tue, 12 May 2026 14:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534AB6B008C; Tue, 12 May 2026 14:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4011D6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5F2F12058A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:06:02 +0000 (UTC)
X-FDA: 84759546564.12.BFFA2AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 43F2A1A000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:06:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2hOsi3q;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778609161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKQ/l17HgJaEG2ofbRBc0FyMbZUsPwl4nH8XIHWgqrI=;
	b=dXnetFfr576J2rGg5oP8pK4G15hXfgMsaDEp5b1laWmiU5SmaCjQr4rAzTUh2YPvGqa9qE
	OnYhUZB4Ki9p2IF8HNMvwnXlSCZr+G608zuKdu8LByPkl8OgUj6LQ1h4B9weP/1VsSmRHg
	qlsag48MwSUWSnu4OkgRh4gEkgztJ9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778609161; a=rsa-sha256;
	cv=none;
	b=KfybNTzOw3Kao4Ah0QvukE53EIm7Ou3eQquxL2SGrT64OZXTK1vhMg2bBRJr1ENI0XljDG
	WluaOWTbEx2UXJ68gTlpvDtKGEkODGxhdvUaL4meW11A7agBQBEy3c9Dn0DAGPm0cJVRDk
	AU7Y1hQyD+FJ3ayVxSNkSoerm3qzu84=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2hOsi3q;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BBA660128;
	Tue, 12 May 2026 18:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1B2C2BCB0;
	Tue, 12 May 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778609160;
	bh=AYu98W2noPGRCAXmjPXNfD4nbNYQUNSkC3qget5y6aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2hOsi3q4965f7axog9kWMtNo0/m+PWVhj0F4F7Uasmfkhj891Xl17nrDooQtvb2Z
	 UV71TvtXUrVJHe98zWTjvueoEwao2vuZvuw03uwWIgtXjQR4gHoyuI14DMx0M2ZC9J
	 h2V1tuyqApv45WHiQ2P9ow2rELQ05Bs0eSdAZuvQg587efpiPHqMmmkUXFwRcxfYYp
	 oyoFO5nAFOJdQr3XO2ghNQsWl4Qu9S8v9nnM9kIaZFCkGKRBnn/P0CtSLal4n1zO56
	 zRYnmM0m+SReIJSpESAz5KORlu2zmbD6ppHNcz8SJoZ2bTBlff1kpqetZa2vkMjXvO
	 LWCUubSAx5Dkg==
Date: Tue, 12 May 2026 21:05:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 11/14] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for
 async fault resolution
Message-ID: <agNr_cS0DygX9ksq@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <65492c7b535080c7e85e90cb7ca962a52871e8b9.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65492c7b535080c7e85e90cb7ca962a52871e8b9.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43F2A1A000C
X-Rspam-User: 
X-Stat-Signature: arfwddi4wd7ewpiqk1bzkposgmhiwguf
X-HE-Tag: 1778609161-640035
X-HE-Meta: U2FsdGVkX1/BoLiAvEQfmy9XbIYyc2143Wy+UYgMnSc8jNn+a1Pkl7RXXvOlyvVjgx80nUAW8tRZnlgLGYFX1l6aeHksabBPEGjHMh5Y19/oWzAcBoaGI+D8pzh/dGloLEp1lZx7r5ZasbVWIepdDrc8p2eTPxbUoEJ379mzFIJJHUGmwhYyXoAjYgJW0wyLXRnItDBvOOXKtDSf9oZ5zE+SeeChq8AOg+CG+BvCfnhVcL0tKfl0iFRXLbi0ugkGn0vCz7Fa7yzNpz7UG+Ws3bio5y13yCBCK1GqlRyuxxBhDY+oQEzrjrgdak4qteEMSWou9CrjksK6HbYdL+fJ60Ocy84wZKRK4UE1CbGgOvmti2r2L5Jk/w3gpkJlPN8+V/fmkOU4tzVK4KjFkHkRQsus0U8UmbRQbFX/Oc0KEu43sINe7apFkWJ/FwfsH09lEVddVcy/sgAHOrYBbB7+BG9aXAJSlyld+7ZCn6nax1ij7ZWy2k63/j4kCGNF2DsNlDcRl6RbVmp6VEH6LxSaPU2/iMUcOAdiau0B22yhmUkpheDAZW+ndUeheSsBdi2MeWCeGaC8wa/wRe/h8knl54kT46LPddBspm+5sTO6CY+6Q/lAkk+d0vgS1ifPEAo+hEh2epYRrajkhIz5g9b0Zl2Tm3A1JewZ+0hIR36NPQBRSyKGgx+ReJd2ah3qlFuSgbcIoGR4g9ZqzS4Ug5SVn3olcLhTDPpWrl8KVh4xuFD9zrprpffZnajsfaQHHn3CEak6lpFdW2Q86vNdpvR73It52p9QZmkXg3etUFQo/BwPNOYT8wszFf/vg6ZuU5Xzls6KcCX9PZPPn2rqV3Z2G2lzvWyNvlnfyxZ2q8Ea1cmrHYXltdg9JwHBQOkvzLGe/2dJ7eUwgX7ZK2bchGtWQO+83wBfTfg2kXWOWsUKUc6mkvWGKWbIMKtdNCzOAx7EQ+vcQ0TiQTfb/ogwm50
 83oU0IPW
 pMIy4YY6ZcX3LRwWKYxhbvQZ0/DuIH+19zKOpoBvj5xTvSKgQu/GfjWd+bmN+gV3PkY9y+zO5muLm7NJoW5CDUFb2fYZYz/FL0IqOuLbHhFU9SywOgOl2pyn3BiG6NCS6L1FFzsKhUIzIduVvfwEsT82psFBvKQPXBqjiCK77rMH1t0o1Do0HWaortwvVC9lUEWVFipP58NJ9zPv+8zuMraaBg8IDu8l5Rq/v8F8Guij6EZpdiJqH3be9/9B867FEy744E0Y03Ct45nCvEPwH1bOhpRuI3nS4aT9EWyqqiXatEOkErP2Ns4adWngTpmsR3Rg+0oCf75OCAWp3Tx8hplHonLCtGiwklw/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:23PM +0100, Kiryl Shutsemau (Meta) wrote:
> Sync RWP delivers a message and blocks the faulting thread until the
> handler resolves the fault. For working-set tracking the VMM does not
> need the message: it just needs to know, at scan time, which pages
> were touched. Async RWP serves that use case — the kernel restores
> access in-place and the faulting thread continues without blocking.
> 
> The VMM reconstructs the access pattern after the fact via
> PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
> PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.
> 
> Worth calling out: async resolution upgrades writable private anon
> PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
> do_numa_page(). Without it, every re-access of an RWP'd writable page
> would COW-fault a second time.
> 
> UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/userfaultfd.c                 | 19 ++++++++++++++++++-
>  include/linux/userfaultfd_k.h    |  6 ++++++
>  include/uapi/linux/userfaultfd.h | 11 ++++++++++-
>  mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
>  mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
>  mm/memory.c                      | 27 +++++++++++++++++++++++++--
>  6 files changed, 114 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

