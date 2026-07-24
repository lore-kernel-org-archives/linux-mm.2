Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB3BC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512DB6B0088; Fri, 24 Jul 2026 11:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3D26B008A; Fri, 24 Jul 2026 11:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401296B0098; Fri, 24 Jul 2026 11:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1967A6B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:10:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8575680404
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:10:16 +0000 (UTC)
X-FDA: 85024006032.25.93989A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0088C000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:10:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clXeYOxQ;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784905814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tb5O8wjKcs1Pw/yvf0gMKaayemz7IuqUU9nVaaWlvg8=;
	b=N7mMjqac6pAgUuz/Hqd3Zqlzem8FIOdHZaLST7jyTIZiogVeNZRYQXWvzxHtFhb2bwm8qM
	QX/hKGmZHa8rodSNXUIKq8RCVXMaN1m3+y/LAGsdc1NE6DRjTOQgzVHplMCAm6dKAADfKA
	W1U4LsRX7sc5SLR+yzde8zvEwojCpgI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clXeYOxQ;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784905814;
	b=6jIgBn4Wazg7Mtbrv6PhcNzCl9iarKszwZGSlRTa05AbG4wBnqYfTHxrCbLy5T9BkGNsje
	Y92CkqB3MiisXy/nAHehmHchJfwVn4ohIctXhGimPYciDrqWcaVM9feegHrf6lknCT09AV
	wB1KBiN2BKCjGMLGTV7O68m5kchy2Tc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 282A24323D;
	Fri, 24 Jul 2026 15:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADC81F000E9;
	Fri, 24 Jul 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784905814;
	bh=tb5O8wjKcs1Pw/yvf0gMKaayemz7IuqUU9nVaaWlvg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=clXeYOxQXDLXpoAFDrENkwTGS7dui0fvsU/h7Ajf1ew3+S1zHO/VInmDubBEe3KWJ
	 JX6jw8hkeIkNGGu6MY3CNkRCy3HysYs8Nb1uimnA1D4lSbUVRwffoZHRkJC3MpQAuL
	 Z2MKlVbWshUBo2CLTVtcgzh9vLEcvQCh1dCSo2VQvftbC9Fv41taVeNEu9puIqTQQT
	 fx5k1OoQV4j+3oVp7dQXtTWzQb0HpQWJfKB/UC0e9LAAJYVebm2TTU0e49BOMnI8WG
	 BNvgUvp4of6vGbUSykKTAFl/EXryoPxo8uD4ojxLNdMP6+36VCT5lSZ1apZFEeCgdU
	 Dvo0Dg6q+d4IA==
Date: Fri, 24 Jul 2026 16:09:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	"Denis V. Lunev" <den@virtuozzo.com>, "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
	stable@vger.kernel.org, syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v6 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-ID: <amOANEMRAsJsTBR3@lucifer>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
 <20260723162646.350cf3bf415a0855140d139b@linux-foundation.org>
 <20260723163233.54b38cfc682a25eb6edf7cc7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723163233.54b38cfc682a25eb6edf7cc7@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0088C000E
X-Stat-Signature: qbr1zjpkea4ibtjbadq8q5c55cntzz91
X-HE-Tag: 1784905814-71567
X-HE-Meta: U2FsdGVkX1/l2OecxWwsUNSg00Y6FLSn7bv85lEAVYvmFb7VnDUClII+jLwu/ninHbXwDM+XkQ0oZlEYXErGxvmrAysKIvRVvh5Z12/loZhzpL1PxVvakhZ88+Fx/pt/7MQ2RxaftC1c9GITGWcpJV1/HYINfuLo9GDixrDTKrPvx5VGzq66DtL5e1RZboZ3t8bz/i3csBTlvfjCGANaLr8guYqKzZEjCbRj2jhfr/0fG17KqQWMX+bi2UdzWWdVF5jSAvzvTWvxafnY5PAiCmRWp5YIgd7gQgZVxA8S1qK6a3CDS4GueAB8V/agzGbV/Nai6ynbU9S4KkEboLS5rIkaSkn1glsuS7KeMUaNsuuflyrfjVM9T+RVSxV3iiBNRAnznFvKg/LKkZ0KP8dNQ7eO69opaZ7GW0PdSBRZyAuawclBS4g/NAgnd+xOK74bsJAGj/ducFYoEFFdAh3/x0l9LVLOh/hxPNhZurSlOzMqVklMhFICiYmMaVtm1TWzLIiZstpEo6A6ORxzofShIT8dYRN5/HT5TwSynQV8mfniSDSnWdBk4vrmw6D8+R+DWPvxl8QBWQSED7J/9h/XVk7dcRA3t1+70olT2WYHxhzb/q0buqLitk/wqtIIMwUqhfoVLWM9dWkvNJD3BP7PifBC2+oGQ7haFpqoC202CxTc8E3e99h0bIlpejHH58hCNYeByQRCzNrFWi08y1eB8DKdbW7ug40RbS0x+Hf1Xt01B5fwSmvMmumiwYRBb1ppZ3BpuPNgGFVZHD7+hhoxMgCWKx1WxOK2VcLfL6Od+M/HMSaOHFadin+kKHoJYq0AOhDVI9bsuYYsYZxGCxyY5d4D9t3R18EyWp7gn0cmmH/t6vO6JIobxRwkMaL4x9xxWVDzVKOK4puTj+vS32z0kZpTroA3tXS16KLAhkmQu1xcGq1PYwNBW9NYJV11wmH/EIwLLX9qviZFlE5yxrz
 TD8KZCYP
 nbIieNoz5tvTP396S3oBH8TQhs4xtWXYJpkQ8lMcrcKkP8MumUm3S8bOp7nGQgZXyejgLUz5OyBuqXYJORqw94YAjRSmG8Edgo1b4nZMLR89Ez62AlCU9C5tBWUZwgOEpEWhsrG5uP+8KGoNdl686L7xNpmqQ+wSk+Zri5F2rv80RqXcIhI6XCcIoH1vq9Mrl6fl30UNDxFQKj03v47qM3vR6Qu+L6s6oFbkTzlrpuQin70HtzDHskL43xr7vXuIfBvXi38H0Ts9c9Wb21+vYOprJJRZ/0HbtwibcdyU1MycUpD1flD0vFejXQ/n+TcY1mWR1PwfNJQUxqyCUfvYuH0uXu/8zjjCfnGRzHF9ljuKAZ6BlD8PqNZvBLAiCrZc1LzaZUnf9Po3qN+dlJJGj4Cp7I0wFAstK+qVSiyk9LouQdxhSjMctFN43fBxKMkOx+/hl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 04:32:33PM -0700, Andrew Morton wrote:
> On Thu, 23 Jul 2026 16:26:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > @@ -1250,7 +1251,11 @@ static int split_large_page(struct cpa_d
> >
> >  	if (!debug_pagealloc_enabled())
> >  		spin_unlock(&cpa_lock);
> > +	if (cpa->init_mm_read_locked)
> > +		mmap_read_unlock(&init_mm);
> >  	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
> > +	if (cpa->init_mm_read_locked)
> > +		mmap_read_lock(&init_mm);
> >  	if (!debug_pagealloc_enabled())
> >  		spin_lock(&cpa_lock);
> >  	if (!ptdesc)
>
> btw, this affects your later "x86/mm/pat: allocate split page tables as
> kernel page tables".  Which I resolved thusly:
>
> static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
> 			    unsigned long address)
> {
> 	pte_t *pte;
>
> 	if (!debug_pagealloc_enabled())
> 		spin_unlock(&cpa_lock);
> 	if (cpa->init_mm_read_locked)
> 		mmap_read_unlock(&init_mm);
> 	pte = pte_alloc_one_kernel(&init_mm);
> 	if (cpa->init_mm_read_locked)
> 		mmap_read_lock(&init_mm);
> 	if (!debug_pagealloc_enabled())
> 		spin_lock(&cpa_lock);
> 	if (!pte)
> 		return -ENOMEM;
>
> 	if (__split_large_page(cpa, kpte, address, pte))
> 		pte_free_kernel(&init_mm, pte);
>
> 	return 0;
> }
>
>

Thanks that's correct!

Cheers, Lorenzo

