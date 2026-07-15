Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04ABC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44816B0088; Wed, 15 Jul 2026 10:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D3D6B0092; Wed, 15 Jul 2026 10:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DA56B0095; Wed, 15 Jul 2026 10:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63F0B6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:12:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97BCC1C0022
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:36:31 +0000 (UTC)
X-FDA: 84990656982.16.FA549E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A563020002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:36:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnZ19469;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784111789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGc4wLtrcKFcbhoINTj74T+3qOdK6ANKsLr4fj0Hk3A=;
	b=I14C39T72KDqoiHPxTugrrdzyRlIOtGQz2V6keg2ES1JmTLm/OAMAXWLMaZ7t0OB2XUmFV
	ZstRiRmuqwhWJ7cWrkFVFrbS0DlmeFV2xgqmWpvlEl8uTL5lsUgu0rMYUVS1gzdt0Gl4Mt
	Ae0eoOaHHebBmS0yPF0Y7P9vIZKrzDI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnZ19469;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784111789;
	b=qmeV7iQwued+4Vzx5v7XM5UFC4Fvk2koWc2shofhXaFpKosAZlj49R0Iau1jhNPgK1Xde9
	uj7QmD62ezAsQnNozShuhNnp/ahl+fKwnQXE+znXIS0IzxCml2hBBT4pFTs3b/SmxPIC5/
	nIbPkFR1eKwNLcM1sCkOhKXvSxzXPBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAE98410A0;
	Wed, 15 Jul 2026 10:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C89F1F00A3D;
	Wed, 15 Jul 2026 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784111788;
	bh=SGc4wLtrcKFcbhoINTj74T+3qOdK6ANKsLr4fj0Hk3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bnZ19469YhZeYDpeyL6D0njcuIEVUlNV8xaZPdx4Wv2g2llZ6KtIs3UIIygTumOUb
	 l+cwxB2A7PICphDlPyE6wZMdhDFkKKg9q3moF6U2KyrAKXqsJOj1Flv6eRw9MyEwIH
	 tJhhbkMpCk/YNyTzBBc4IpTn5DdrSJkLQkQumDOOtPhXPcynGpZzHE102rOWo7LD5N
	 56o74i5t2pPRwvzSNAe2e1169ofKYjMwkuSx1lceloXmCtqpot1iqEGOPw4IIqQs4/
	 1uXVxKHAcXoKlqg7CbUCFymnbWnw6NeGNkQC/idZnGatxcK3lT1HA9DEFeX3/sgL0e
	 pluXygxbaYEIg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66559F40066;
	Wed, 15 Jul 2026 06:36:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 15 Jul 2026 06:36:27 -0400
X-ME-Sender: <xms:q2JXasIcTK87tj0M0Ic5UFNoiOPAF3NQ_Dk0NQ4OKwV6DbMdgZB89g>
    <xme:q2JXapsfnLe82cce_X9YNZ32UrazxLJ7ljJyH0VqgC0vnzqBoF0dHsCxavnczcawL
    jFuMR93yj_XY2XQaeP326wrnJhbGuq3ok_pqQmiW88iRMuljNFRwm0>
X-ME-Received: <xmr:q2JXaluvJMyCEaUSGr9WrIdcYatWNe0w3oVo2l1GGmGg4Bv0sxlCqr6a50qEkg>
X-ME-Proxy-Cause: dmFkZTFoH2pQZa2MB7F8P1KNkzYrZ2FYupTRLNJuIuUdKMkzQz8rOl/YdOFBjeV64/eFiz
    grneVbhOZ/mzsgLWmb97Z2MXlENOxDXRl0cjegtXKlxj7YYlu4P2rypydA+jQG17m5ZjrR
    uLA1BH2IYxm64puaRDdrEUMLMhexkcckKs1sEKyml2zpBfIOSacHHPCSa4mrPwXtsA2S2d
    n0AJWgO4Aw1zfMMWmrVVxIux3bA1rGhvs7yymGF6naIGts5DplcBRYFDrF2cdeaP8bZG8h
    uqCwtISn/RjBCphxWoCiq60O2Gpp2nzA6uqQaHx3NgXSiS8IQjohJzFr1kWpEVdFieI5W+
    zSj+F2tRIKbdZ2G88GOn9AR08ypKHMcQnabYwnXiXOn5vdgj+TTtPEjU77Mr2BjBI6Urjw
    1vmC7n/u6OnMBgowj8zJPICTT4s5l+RuxGFGLXG0NLSHoz4timfc4hGSlksoUVvKCK3QUn
    RativehZ1FvH6M7cZDGxQzTgn3rOMiMnL7PWTwdxApBc83z7CgVqOahJ9cYkPoN2O0N7no
    Uk56UlfKVpn5B5rZ9K92JX11zIjWvcbS3QkUU2KCY1FkHuzb23XDwrGqdb2unwf6VuN9av
    S+AKROKDhvXXTxODKw/rsrmVUYvXwVOH78t1sU2BP4CBslU/925LAlXUL9+w
X-ME-Proxy: <xmx:q2JXakRIMffs8qDUs1mdoH-Go4g25NPKMZ_CN2_PaPuJC3KlAtmQqA>
    <xmx:q2JXat3vrR8eDZNO3tneFiN4zykuaM5Xu5mh8hrWNr55hWX2ztia6Q>
    <xmx:q2JXarO16LV0vMtw1_LPC551Fv11Wz-CIgkMvyOHqYsQFcK4IsisiQ>
    <xmx:q2JXagMG8AUv0D_wEPFu-w5uJ9gEPBmFmz4nKLWwwieLVmfSPPO5kA>
    <xmx:q2JXajnknuqqU4lS55abKbdlbfEbUvoPKP6YacJirxQNOwdPPCl1Zs4U>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jul 2026 06:36:26 -0400 (EDT)
Date: Wed, 15 Jul 2026 11:36:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
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
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v3 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
Message-ID: <aldim43Nu5sREkDP@thinkstation>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-3-b812eccfa0f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-series-vmap-race-fix-v3-3-b812eccfa0f9@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A563020002
X-Stat-Signature: hspio3nefmfiri4td6ns4ph38yeikfkf
X-Rspam-User: 
X-HE-Tag: 1784111789-708436
X-HE-Meta: U2FsdGVkX18jRqZRKmX/o7DNiNyL7jRE7AmZ7G4ivAVxwcQIQ4eF8mN5O/8iCEmn2/FRxm/OKpKwMro63JJvizvfodlGPnNnbXV8qdILo0Jvdz+YwAzJmT4G+EDJe4Dezyg56XSvGWCwfjTgd8Pj1+YGGbHDFSwwhJo9Fnw42GruVn1Hxc5JrMXRXdt4Io69UnQrox6ZIfcDMNb2Ocrm7miMheenwzOsULa9w9ULphTHbImZmam+B5ZWYhG2WOL26fv3W/MzkCHwrz3UUkZntc/JSCq15OxJq6Iz228wFE1dW7hOQwgj5aAWcacW6qzR7Rp1vJd6rlXWJJcpWthWjIoHwKU6XJaArMa+aiG5NqKJg2XjgarlWDhyOL+t5GEwP/D4zlvuv6SgmcClJQ3q3vf8VvyhCDfJebvi7rwfmi9UtA6P+5fYA8kSoyngPwB68DAq9Wq0o2+FccTq2PVjfzjj9Fbchgc5zfL5y3xkv+xxJHWH9epwq7Oz7Hf6o7bBBnsR2uIItkMzafEWEOwoon1EFRl8xH84JDcn46vG/bapxhTTW37MrcKVShX0MAgztbXw85KxO6hPulxJBoK197qc7wi0Sda+hD/wIjj1CtZjr2V7l9rlaP37Re5d0uWyHplgTLx0LDJEx49VeXhE7w+gf7lvfIXln1pr7EQdPVIeDQR8KeA2YCEe6oNknYqXFLunizUylOKcehqpG+vJ598XPwMDqZnX46YnoMAF2GeHbsu/rFQWqrLmEiQ/h/G8w6ZFGrEqpVbVvZtIQJhajLOq1miYuKWCu39eJFeV3UuXcA9iKbynm9XSyxQRdOQ+9zmEOFCzI+p2oQmekWJCKytjU4LtF6KxrnBoSKstQfbRKYzghBCLskz+MeFiBCPE2mefkWuw81I1z6yyNM92ZhcE3dbz+BH+Xb9IoQvJoGb5uhpN+OHwx6yviD8zVId863DPe+W5qItSuqR55o/
 lev5tH1E
 5Z0ZXpoyoUl5GRfJKCXOVbbB61t6cUvIMYed7SzXEx+XWmLPe/aZzDnlWcObBxG4Cgr5dgxUdlx0CktUDYr6L6pDbzjoKIWfP4PC/VwshmXill4cYHj6ZCW07uc9kEVhQEmMh28c0jhdAb0valkqL4neEuOBCwdmXKVHi6TJ68QeVUtCuru9awXXpN5BHbIeO191mbDlPZwhZP1Y5GXm1t9YLHSF4Ls9oy2zQsseggRgsdCqvFRtEw/pJDcPgUxPpIT/brsbR4bfkPTGSjp7olrwkI/exZOsY8TBhQM+jxjG9OBEyZ/sxcYnx6C+znpXR72vyFcsh7bwUkxP40ZyQpiBgmmfUbtvq1aR0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 06:24:25PM +0100, Lorenzo Stoakes wrote:
> Previous commits have established the invariant that kernel page table
> freeing is performed while an mmap read lock on init_mm is held, which
> fixes races between ptdump and kernel page table freeing over init_mm.
> 
> However, x86 and arm64 can perform a ptdump over an mm other than init_mm
> via ptdump_walk_pgd() and since kernel memory ranges are shared across
> non-kernel mm's, this means that the race still exists for these cases.
> 
> Fix this by acquiring a nested mmap write lock for init_mm in
> ptdump_walk_pgd().
> 
> This is safe as we take this after mmap write locking the mm, and nothing
> acquires the init_mm lock first before locking an arbitrary mm, so no
> deadlock is possible.
> 
> Also update walk_page_range_debug() to assert that init_mm is write locked,
> add a comment explaining why and remove some redundant code, and eliminate
> the unnecessary and confusing invocation of walk_kernel_page_table_range().
> 
> We can safely remove the non-NULL check for walk.mm, as the mmap lock
> asserts would NULL pointer deref if it was (and of course no callers do
> this).
> 
> The first point at which ptdump can race kernel page table freeing is
> commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> table"), so we target this in the Fixes tag.
> 
> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

