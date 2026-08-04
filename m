Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA15C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A591E6B00E4; Tue,  4 Aug 2026 16:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A304E6B00E8; Tue,  4 Aug 2026 16:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D086B00EE; Tue,  4 Aug 2026 16:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 720346B00E4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:02:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 028A51C072A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:02:05 +0000 (UTC)
X-FDA: 85064658252.16.29D8A66
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7701920014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:02:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NcnkUECw;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oOGwlGeQFq4BNoyfaLCzUuzCLAp0LMWDRDBPkRpL9c=;
	b=DAeA7+GwTRLo9+t0FTGSJ4RG6abXxFk5l8dah2cYMZfPVz+kyI/esQN99/pmqEX7rRJ1fJ
	Ab/1LdeDsJ3al4wvH0BBTLUUDzjxUi5SwHdZ6f/TOtiYKN/LmYQcRCvD98A8LUF9KAQu4V
	d5gXuM3e2Qi2VjktlqQifk2vJMe6s8I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785873724;
	b=zwKzATSW9B2cUuWyn6rLDJwyeiJl5CHCTdakoM4SY4C68hc6ndwoChwuXKSzIHBudGpbPq
	lIni1e+mh6HCkWrGZq9u3OOJX73aXHq2Ad9uR1c/WfWZG416EUpXfZP1uFnt2dTlVHv1lR
	76WpApOvUP8edOUTjZgj0xIR0glm4uc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NcnkUECw;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8oOGwlGeQFq4BNoyfaLCzUuzCLAp0LMWDRDBPkRpL9c=; b=NcnkUECwsgk/GFvFXGGMq5VR5/
	u36qBE1f9hwuYUmF+dy+EnGZL6UZT9ivec52KuFbeIhcTEz89W7KVonJlBSxFGfoEQD0xj6E3+A6C
	2TcQfPYMPgk/0rhlcGTkRDoOryb3tXFrL0k3IdoM+J8h3aBbTytI1Wa2f4Kf2sM8ygFk7ab19XvTs
	uP3vSb0Mrbti+Sv3Y8vRZwf1R1/WLMA75gLfIrqmrQjPhb7/FghZDK1ul2bkM4qeQZNW++7iobcEx
	Wis8zmA1iDV5VnEWw9CT8c4oI5+8CY+Otgt1p+55pXgOxbOgcFxnDhM4RJhaY8nGkKJLvioojgZR/
	2ZUx+4gg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrLKR-00000004eig-22vl;
	Tue, 04 Aug 2026 20:01:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EC97830045A; Tue, 04 Aug 2026 22:01:34 +0200 (CEST)
Date: Tue, 4 Aug 2026 22:01:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 0/3] x86/mm: DEBUG_PAGEALLOC musings
Message-ID: <20260804200134.GK776954@noisy.programming.kicks-ass.net>
References: <20260729110807.797920433@infradead.org>
 <2ea2881c-7202-40e7-8fa2-f1c649c0d445@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea2881c-7202-40e7-8fa2-f1c649c0d445@intel.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7701920014
X-Stat-Signature: oxsm368kmgrqg6h94cqfnjx4uxepz7xq
X-Rspam-User: 
X-HE-Tag: 1785873723-658116
X-HE-Meta: U2FsdGVkX1/YqO6PSx1gwDGh4IPq36Nda9I/BPBB+Vxr138ut4iu4A5g8oD5vxl3aN6QtN1lzoG8EpL83ZJtNBbSEOG+IfdCgHWW5ISF98GztaN0JGtdmOF7PWg5XR5q0Zks/4kBeAIgBIBBmWxEw3AOG/73FJ/nvcae5TGQAu6t1MABALOF5i21qP6LDrflgLqfa6DuCyr00iXGDVFxLv/5caktPV8VbbA1tuAP8a62v1gYuutKaBCDRy2+MWPCro7EfHAf5VsHjUPPmgvbhZcJIynrhnyraNo2O5TcWNCVXlrd/PAJ899+W785IbedAxL1Wl+24gcWisRwNmruxzP6MPxPEjYlP6oClBcN2ZUOKULqyds8g0GlqerWSYWNo+dYR2fl+r9xR0B8y1JLXBk22fEALZDX3sdlg5tAOldEiOttWbdTYtE87w5TxUTQ4vBCEYiUT3Be9x4CWCCZ/53CaYmvAyW7/LH4SdthCcqiXQG0zU5WNLDVEVLC0NNAlUY0Cqf4ZUqIgssuJM1FjhmQNrPkRjdeN4o3u3Kv3gzfToJ+QjqCDGZBEsKdIDFovVhcg5VR1JB9Hvnjh4yz0PFfZ30hkXRXPeD4MXqNgX/WBnoDxLPBReG38K0hlkRU9BBlekfINLjq9WVL7Nzr1W8UTSNaQ/aG0Hck2lUJ1f/SnN0XtNVM7Z5SP/OWSe1MtORS3cuYNnZyc4RblKE4/w+rkBXjACziG02m6oYt46beEg0ikk9gZonC+TtWLGvR8Khc0vRmYDaGl10XaQw+foyBLcHGei2Ebr69pOotBUo0vj7+5RsbxN310YRsJhXzDHSnp8tFt3BI+GhgPxZ2Fu6k5JKPDnqq+U9kCeta71+i5aObO6JYgk0YDax3n6e4B78OxM974omyC09gI+iPSTxoj8Hx2jkn1T2hHtJK7PEUmfTx0YX7sqmBjNsq/zpLHfHitlQvMTJsdkaRL3O
 h+4IO1V4
 hP1SK8XwmjoonGxbCh3e4r+dExC3MiarkasvZ/3RjFkVk59meLQRM8RYzICfLeOlFyPHIATZsmTY7mZGBU0VXzq5AAq+ziW89MluV9eRyMSJgfLorkbVRt1qsNVvvwDitQgF6h4jp9/YBupYcLyOt1Xzx16e8yFK8YEV9MVfbnm6I+szSCwV/ZPoWwaMkumjTalm70qwGJuQ5x7j541m128dO84u/DaAYiJectay6UQRGvRCtWf+sErfRpAKOZFlHQw8YSkRr9cfpycUKF66q+zrBTjIB5t5s+XJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:34:36AM -0700, Dave Hansen wrote:
> On 7/29/26 04:08, Peter Zijlstra wrote:
> > my take on how we should be 'fixing' this DEBUG_PAGEALLOC thing. It appears to
> > boot in qemu with debug_pagealloc=on and such things.
> 
> The approach looks fine to me. The only thing we might want to do is add
> a warning of some kind in the split/join paths for CPA_DEBUG_PAGEALLOC.

So if you have lockdep enabled hitting them will scream bloody murder on
cpa_lock and pgd_lock.

But if you want I can sprinkle more explicit warns :-)

