Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CB4606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oN7Ha8DJ
Received: by kanga.kvack.org (Postfix)
	id DBFAC6B05BD; Thu, 19 Nov 2026 03:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96996B05BE; Thu, 19 Nov 2026 03:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3126B05BF; Thu, 19 Nov 2026 03:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9ECC6B05BD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:02:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40FDA160999
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:02:15 +0000 (UTC)
X-FDA: 85451125830.04.9348B55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6409B20005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:02:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oN7Ha8DJ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795075333;
	b=LIED/SVMo77J1NnMK9oYD80ilhhWnoqLzw8DKrH+bdCEDw0mZKKesen35dM+T0SXa/hY0u
	AAxJGHCQwU2zGChxn5Kvy970HwtCJXtyBPw0XU1id8+kW+WAxFzWkjk3+gpBoqxt0g8ViA
	Z3IABtHBqdaAqPXmCRXTBbWRHAqawH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795075333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6oOEv+Tjq5YWa7Zf2SdEWKRBCiHj3xUkS266+audDg=;
	b=ZY91xgHMVp3feQpQtZt+uTiVhGbtsIJSHnD8obVUOPpATW0u5CNrAAMRt7CP7mLlasLJyU
	V20IvlybZowfqSvJaZd8JVecqI/fJ5aJjfbt0biZmufAaRH6PTXcpVi4rEIfbYGm9GesRt
	OdWczKcSrVCZ+0yfxwV9h0fa9EJeJDU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oN7Ha8DJ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6413540E22;
	Thu, 19 Nov 2026 08:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A75D1F000C4;
	Thu, 19 Nov 2026 08:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795075332;
	bh=c6oOEv+Tjq5YWa7Zf2SdEWKRBCiHj3xUkS266+audDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oN7Ha8DJSsdUxtVJFgFZxwugdB/o56a4l7Ow26Xm2YedAAKbBHRaGhykAT5zCA0b8
	 1t2PJmRtRMfknWwa0iXYclw3wMzgQo8FcKSqLxHbNKFC6ZakP7f5rRddqtRHwfQ3gi
	 Y7oFT4/lZAJ9QgZarkxFfMmK5VUL8eCDPviozuaWOsi3oDIV00bblqlBC1BS4PcpHa
	 lWM4DgkutWoPq+Tv88XZNr4nGEumM47f2qtnzZJ7TG3GfT4QVRfFdb1Dp/WnDN1/UC
	 1UkRE/bJeCE5pU/EiP2tOtYzjaDpvlXItlqoblfS8hTjxKTjsSMN5wh9DvVMzYRTGW
	 oco5jspivkEsA==
Message-ID: <9561c9da-f0ac-4e01-a6fa-5b5dcb6b60f9@kernel.org>
Date: Thu, 19 Nov 2026 09:02:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/userfaultfd: check exclusivity of the page being
 moved
To: Eric Li <nakixii@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117212400.1890820-1-nakixii@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117212400.1890820-1-nakixii@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ya774b8b8hxzx7ykq54bca7u7gwibu1w
X-Rspamd-Queue-Id: 6409B20005
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795075333-681444
X-HE-Meta: U2FsdGVkX18PCcbyKnWOEdcHdjucYNpEiDyvtdq9sJLxxwwj3fe41TaFCTJNPHA8co+MFpP5sloqDCRwbyW/VK+xQa+mnyb0zsbHoesJZg+UPT45rjP8OM7nveKYRDDAFM535g4xvOFZdNz/IPnKaLGBj+f5m8S9T+sf4t0D3Gd1OXBZ9IHuIMOUMWZPknE3cy3fZbDBIxUsD+udWvx/gdw9E0IXgeNlmp6UIdMe2j3Zc/eD9iRGbEvAIHWAYl2sRPC8EDxi/F5TUzO66rrjQXF+33P8yl35byNnA8wtmsrrGV5cWkq+LcdZNt6pufueZwBYe2wdkS+KmvW/IW6U6t2HvZktRfwQN/KB2yLOs8/sKrNhG1gWmwrkD2nt0CIlRBKSkTNnZoINFZkMcPUzNgO1+2Z3i+QgcMjjS2JHaDSIBv5I7U4fw04tlxvFxnvGCENqtidE5vH0IiJUEmHcUlHdtSvU4t/WHvGXUVjzmkqfWA3/IO/9IHWJuRuxcHE26DQkppXOJQghCT9twq27USOYkTdR31pwB203rAtLJhIGISMzxuA4PjJtmllSeW5Af6ODmK36DwiGsYdkhuiAf2tpxDD+UUtRz/pxluElGDAyF6BtjMb7qAf6lsj1MuV0BjZEffW0GN1jAz3MbCvSNkFmHdJC0oKXVf09nC0H1SjGschzAyba227T8Za6CUZkFbz6bku6Ile2YVM3Ng5rb1K/9t4OGiejKMrfrs69JchiLoOhDo1TJu0tEbBxzrUqQ4HrZVMPHAuFmWHtYpHvJzNsyjO0RNa/cZpfKoVKdqhg3OEE9qYGAgEZtBHQdlAViCF9www1KOfIe38kFUfLTh2FB1gV7TKnJmIEHdXkHd+wOb/gXzNSBcZQv4bA8C1oIP+BvPaoGjfvSCvscHYIMmjRURqGQf9wGCGXU+CwnMM/Cs8/X+8wLvNXzdL18o3z9LnRphcS08+F7ZLyW/f
 SQNtDrAP
 UTo04U1fZLly7E1PQU9gFIzrcsxd2Hhzhp1yf9gjMPH3pOQch79jpiNrC0vF5zwbedYpLwrxeI0WH86iPeIFTjR277/5WOrrOl9COi/owSsVO070eDc2qPnTfisqy8m6z1C8wNPZ0cy/6IxrAVseSUV1pCvt2TxHTqaoZURO+z0RTM9FG0XmImzHDmYqWawSc/ZmMh5RKviX+ESu6qYk/Yp3E9ZJrSthWtoRySp9Vpmv7Mc9f2WAiHltWD6ltisI7FsMkvl0Afn6AzxjaV/7JlHtO0KrXWBlC+/K/u7xbfIxUolvRbQxFg1lLM/7Ufi4YkWGOAJqjrkQ9eGnymYrGdHKeMZDs+7CdkiMv76UinceJZZ0GaWPpSYopAAhVwb9G38tIZ62vLan03xDeixMe6JsSGTttZTUB2uSKjWGwfrbCf24uqlWGLjrP/jXErHe9IYiR1GKFzZg/Hsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 22:24, Eric Li wrote:
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
> 
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.  This case only exists since commit 1da190f4d0a6 ("mm:
> Copy-on-Write (COW) reuse support for PTE-mapped THP").  Before that,
> the same state could already come from fork() after MADV_DONTFORK on
> part of the folio, or from reclaim when try_to_unmap() replaces the
> earlier pages with swap entries and then fails on a later one.
> 
> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.  It also goes wrong the
> other way: if the first page is exclusive and the page being moved is
> not, the folio is split for nothing before the retry sees the shared
> page and returns -EBUSY.
> 
> Check the flag on the page mapped by the source PTE and get the folio
> from that page.  Locking, refcounting and the split-and-retry path stay
> the same.  The batched path only handles small folios and the PMD path
> already checks the page the PMD maps, so they don't need this.
> 
> Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
> mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
> let the child exit, write to the sixth page and move it.  Without this
> patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
> data was correct.  Moving the first page right after fork() still fails
> with -EBUSY, as it should.  Writing to the first page instead and moving
> the sixth fails with -EBUSY either way, but without this patch the folio
> was also split all 20 times.  The move tests in uffd-unit-tests pass
> with and without the patch (the two swap tests were skipped, there is
> no swap in the guest).  I didn't reproduce the MADV_DONTFORK or reclaim
> cases and didn't test arm64.
> 
> I found this with Claude Code while debugging an out-of-tree swap
> backend, and it wrote the first version of the fix.  This version, the
> changelog and the reproducer were also done with AI help.  I've reviewed
> all of it.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Eric Li <nakixii@gmail.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

