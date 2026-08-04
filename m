Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5783BC561E6
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1DB6B00C1; Tue,  4 Aug 2026 17:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492636B00C7; Tue,  4 Aug 2026 17:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381D56B00CB; Tue,  4 Aug 2026 17:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC28D6B00C1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:50:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52A0EA0315
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:50:55 +0000 (UTC)
X-FDA: 85064932470.24.44DF572
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BC4DC80002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:50:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5dCshPa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785880253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNab1TMTXj2tF2QYo5aLHrQ52ijXroClG44vJawLUIA=;
	b=zJEFNh8nNbn5YEd0OkJBaWHHjEIBJuzJnIrJkKLtyKm8IcQuSyTEvcbUVlrnFUPmpqt3f2
	Cav1G3RXhglpgGBkH86JUKWBnZKM+ipInrCVYQuSf/7Nw7nlUoxudTNZn1gn64vGgWwd+W
	XVOybwHtUhMHLBLfhJI7dNY1ZPRP5QE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5dCshPa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785880253;
	b=XAS36TzgUvmy8lseNPBg1XBnd3Uq9vdf6exb3bRkqj5AeenXOr3L/1uaaUoV3rRFQsJKo1
	xUllr3ml2tTMZQironaoq5w/dtmHc8Mjtcjws0YVPOL+g5wwycWDb/EGApSJ1iT6dkv12D
	2BLFsRxr5EcDYm2ThyZ90m9rPROIrTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33929600B1;
	Tue,  4 Aug 2026 21:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D791F000E9;
	Tue,  4 Aug 2026 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880252;
	bh=wNab1TMTXj2tF2QYo5aLHrQ52ijXroClG44vJawLUIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V5dCshPaL54uf39QVRVNzhtRdjaL3A5+N0uTPkmYLKvUY7qjSBfOWdQCCOlsY1rCr
	 7bbJME5plInKvwecbvPBYNAUkMlxC374eKYuWbOIP+PTlS2JcNh0su3uUY1KsBAKzH
	 zj8GY3MUqT2Wc8mimnl+E8J1hEfnqrTUCeyxA1Jlnr6xQTA0MLwKnnO5BKagPO+dTp
	 v/+zldvzIj8sXoT4EMZDcD03UeU+WJ2Xu6TRk9lI/csvdmnFCF1ICOwMYm+x0RUgxQ
	 7+YVq2PehLL91mwMhipLifw0TTlZvnS+nDFOFlkrmwC2GtJsskaWcxkN5bFAtuZJph
	 vsjH+6F6NaDyA==
Date: Tue, 4 Aug 2026 21:50:50 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
Message-ID: <anJc8Ansf-QWFfFo@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
 <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: r8rtn85cdhnqqswxii6yznuee14dchjy
X-Rspamd-Queue-Id: BC4DC80002
X-HE-Tag: 1785880253-206356
X-HE-Meta: U2FsdGVkX18rLCI/yIzgUiHUGh+j2DpR54L3OTyGOGoGEsNr8gy+N3TYnAakXBzse0KUncAzBD7i5VguTB0Luo9csOwqR+M+vGdmgcbHzuhzFoqoYHKtYGNEHt5CwCmCwpdL5R4jhYwi+TPh2Q5fxcg56Nf5iRvWe4LPZn6fKN0V8cV7Wzk5u7/X9Qhuf/TV82qUyy6ihPgQgd26/Hg/Y+M2mWDV9/JNYtFafRYGt7Vw5wyEthRkfoplFcs3I8uLVpXuxWd15brhKEaD7/9yNKQs6QTAUs/ioCbXIEtzJYRJUcydeJGtc1M8LK942DOpGpDhmOb7GUkbEmmbOCMU7g4V8ItQZYTFhDgpbyWJJNTMWP7Kz4g2SN9TSNtGmDr6pWMFuqlYrxTY9n7zgsZnYtn9y1+wcTyTEAz7qE0qGOsqiXpkc+Z7OYIUwzvkM9IxGCBoIBZvVqDNRtCW0Ly9bpD9UaNM8IM79TnPiC1knn3JFzrG2Ahjyc9m1Yge3k46mbGPkjYDJhM25YIt6qMmU216XoyG5hUxF6/DJoFfgvbPfcCMl4rq1O7llBrYJIMDypP3vHTF/c117GQcL6o+hI5u0Uj8Img9dXvG1j81XxeesY2Z1Y0EsyIAHZ1LPfAXLpixRVUNFzvY9omrgyDW4MUZHi6aYyAzFck4vnLnUVlGkT7C8IGx8f9iLK0OQrLTjYT9hSTMR2DStlELiVOXvx/eOnRz03a79sPBiHlMfGjDhgW3xq594742Om2BqbFVz76q5gFEypK5E5uOlJsM4K/K+kQBvFIn7gllM70PZHOasmB758D67dGkx+MbV/Qd2e/p3Yc7Nogy622sGSEK2W+HzDmaAB20Chl1CYmpa32GHFVMr/0w2Sr+JX5fRgdlaBo8DqUWJeddHVijgctLtiZuGfclcmxJIpOOTAsKKMin+ID3sFZLfOjdgyBRK0AqaC00ekitV4vo26pLSDh
 H8tS665d
 XINHo+XdCWuw95UUbDoqO0mvzVUJr2WSW1OM0Q5I1C1fyTXWK86S5hq+DBwuyKTH9zVFJApYwHkAViclUgAA0WWEs8zzSP27LNT9EnVzYU481aRAk7n3KNpPxtZinehdq/H5ctbHAsBNWINanZoBF7BUvE4M99i+PnbuksltdNRhuiGgFHe/hzKZqJA0BxnSrjBHeX7M9rXkqTOyxnU2ksKdFYezHoKOaHUMh4yJi4nVPB8H8hfXJLz22HcsoK6B11c6UccHY4ibRfekUqkOtbMWCZlV68TU+9mpz7FiaV4wLSKNw9huopczorSBIxOSB/0t+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 04:52:59PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 00:22, Brendan Jackman wrote:
> > Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> > non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
> > ALLOC_NON_BLOCK because the former is "a vague description".
> > 
> > However, vagueness is accurate here, this is a vague flag. It is not set
> > for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
> > but rather "allow dipping into atomic reserves, _because_ of the need
> > not to block".
> > 
> > A later commit will need an alloc flag that really means "don't block
> > here", so go back to the flag's old name and update the commentary
> > to try and give it a slightly clearer meaning.
> > 
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> I wonder if we need to do this, and instead we could repurpose
> ALLOC_NON_BLOCK directly. AFAIU it's about removing the side-effect of
> gfp_allowed_mask in the next patch. But what would happen if we did that
> using the existing ALLOC_NON_BLOCK (or maybe just renamed to ALLOC_NOBLOCK?).
> 
> - in __zone_watermark_ok(), ALLOC_NON_BLOCK could now be *not* set in
> situations where previously it was set due to gfp_allowed_mask masking out
> __GFP_DIRECT_RECLAIM. But it only has an effect on top of __GFP_HIGH (thus
> ALLOC_MIN_RESERVE... which seems contradicting the ALLOC_NON_BLOCK
> description comment btw). Also __GFP_DIRECT_RECLAIM is only masked out by
> GFP_BOOT_MASK when all memory is free, so it's kinda moot?
> 
> - in rmqueue_buddy() we allow access to highatomic reserves since
> 281dd25c1a018. That commit describes GFP_ATOMIC so we could have been
> checking ALLOC_MIN_RESERVE. But we can also leave this alone because it
> doesn't actually matter when GFP_BOOT_MASK is set, as above.

IIUC we are trying to find out if the callers either has interrupts
disabled or is holding a lock, and using __GFP_DIRECT_RECLAIM as an
indicator. As you mention, it seems like __GFP_DIRECT_RECLAIM is only
masked during boot, presumably before we can allocate any unmapped
memory (should always be user memory?).

So maybe we should just use gfpflags_allow_blocking()?

I also wonder if restricing to callers __GFP_DIRECT_RECLAIM is too
restrictive, we can probably key off __GFP_ATOMIC as I assume any
callers with IRQs disabled or wiht a lock have to set it.

Maybe we can also use preemptible(), but that creates a dependency on
CONFIG_PREEMPT_COUNT as far as I can tell.

