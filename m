Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A2DC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1425B6B0005; Tue, 14 Jul 2026 05:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F37C6B0088; Tue, 14 Jul 2026 05:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD476B008A; Tue, 14 Jul 2026 05:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA3826B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:49:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65FF51C02B4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:49:58 +0000 (UTC)
X-FDA: 84986910876.18.DF1F730
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B39E140008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:49:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVZmAc6Q;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022596;
	b=1DhUPz4JGb2lsvPZ1DFyl4HBOJ6Zn0enbgZlFbU04C0fyUNyXelvGLcC6F3NkrzCWYzvvx
	c+D6AWSpv2XuRupESCtHTUsi+xm6D4GrAG7LTHT99OPrTXWnPDEdpCBLgV8HkcegyxsIOb
	SKwf8eaVbPuY7jZdMZkzRtmCNKHT8G0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVZmAc6Q;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HctaYC25xmi723t9mpPbmCLQP3IBod29aBYdTrLa6xA=;
	b=wx7LtGTg4WwzctAQkkbY/F74C2OE7m++LaUYR2y5T14+3ObjTd/spYP1w8nevaejgFt41N
	7u9DERFcEpa1htDBkqKzZhlq/PkdPrxXcwrEDLB2vYtn6rYgW8aYrOE2YJXgirJK08RCfZ
	76OgoqxBUTmSNwtUD9VVyR5vt1S/KK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53BB8417F4;
	Tue, 14 Jul 2026 09:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F87B1F000E9;
	Tue, 14 Jul 2026 09:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022595;
	bh=HctaYC25xmi723t9mpPbmCLQP3IBod29aBYdTrLa6xA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZVZmAc6QGPyLQjp4Kd7I0ZXRjuVkK/fsGkjzg7Dr9mX68oMKo9p3bz+tPlc9xds1y
	 UL5BGrb2JOckIQ3juGIhe7VJK+QkjeM6nnsuJYMzZXYtJXKNQ99wMk/eiz7pupxkAQ
	 jIWNA6wpCcUeZdhpNzb3kZeMeNa6FQp7AsWpRzMLvYH+0NX5EVmxxAD3VIaqycp5n/
	 fR8iCRtltXt5S3iLSXOf/lOTBdD8B0DVWq/fclNd47VRzfLxNulbsMTZnWwsk9qtQI
	 MksoMVOSqDFAVPPTUlB7Tza6Oua913SFqFJWY+RR5/0oikgUyWkmQy2X++jb9LUBXd
	 pI9mgDHReg4Zw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH mm-hotfixes v2 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
In-Reply-To: <alUdUKk0zGmskSib@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-3-ad134cc3a12a@kernel.org>
 <alUdUKk0zGmskSib@thinkstation>
Date: Tue, 14 Jul 2026 10:49:39 +0100
Message-Id: <178402257936.69739.4642059153515341814.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1203; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ZepVuhzW21/hUCaWiKuOK4e1luh7TWvi44wNV50RL3I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLC2Exfud25crSsetf8mCsrnNnW9nV/7tLPT5/09cimd
 V/3ln6W6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEfG8w/Heo1PuZ62TUtlIh
 9PHGKMH9iscZlofvkWJ9l3JPsbM15D4jw7rfdXP/RV1/G7ynQ8DgSIePeCH/0w8C349m1Jy4KKe
 pxQsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B39E140008
X-Stat-Signature: bj5mnd8s5ebmmc653u6zrakgcmkcpk1c
X-HE-Tag: 1784022596-993690
X-HE-Meta: U2FsdGVkX19FZU/nMssiuJb6RLb1VSkK7HGr+zzNmIzskvsp6yTF9cW/lev/UPFpp//vIuke9lyq2y2K8WE0v/sHmo0d+aA7YHYmA3GwDH0UStJzR6+tNR7KmgI5nnj8YjMIPl87x/INQ2yZILPS1ytYPpSr33oOezVnNvTLcVNBEKOGS8g2JLkAA5KEYvR8rR7LnDDE5LJqORxIfE43iz/BrJTH4opSFz8fpa1M1p72wbO8yn2+nUgArOHY5qXrdzAAmBS5PjubXhHikTTKvk0m342e8W5v2nZzbhhSMyWYZt70sj6RKcp7O1C/6eGdPlMjpJ9Fkk6RZzfCW2jtF+N21qbLG19GmITXmojdf75F7GxIFleXXK6X4D8Rfakq4U593LSAqNhFHqX7rD956+OWB/JWiXWLcq1DgKClh9WzcymVZRXmLpjsmSfHiTtmBNlqN7TbTnhbCTa5phAI+XVBxPmqGKRTcrYlyB5Ki9PVt1dn5meHLUhr9RWaqJVjIeurPDc2/4Z6uWKq84714skIxBqKvKfvmwvZsjR5TEeB+Xaym/pgq5+vDOtck0L4TIcI5i0tO7gDRemrSd5Zwkqa18h5nZEfWGHgQD71H6Gi14c4azfKNtXr6Jk7Xi0ItyzGVGQe29cZksMItmgj1Cgy1vaYOOJOZwEiVu8YyM6uuAoZYkoimBe5QwsdyWf8ThTxHBWnzsJZRrT5JhZBewRxuaXch5UmpjqHLxBtXARUqwyJKr6XU49XeE1cAb4QoOrS7K+BMrcMklyQ6bm8HCqpumROSyIQyQM1VMSWTUuq1A8iqfNUM/8uXxcMC5cAFjFuatOIyA8kS2oFCEk/SB8h99EUQnRRucxiel+y4pHQjQPQ53t/RhJ/sehO6NdB3Rn2zMUUSZFliuHQ+k3E4ou+zdQctnX2NAB4U803B99JEQKxef7HvrzOjzL3H4LI7F5bJnxa5TO+7P3TMIT
 W5WZQG5m
 +j0z8jqBe5vaofFfIrDnOAgsu+wHBgyOWeqPMGECudpiuOgytvarVjqUYm0sXyVT+gR9cu7X0DnCfNExSJKkTV8qWxgKuONeCDUN1OemflJ5eHSF59T/55K6C0XUuhFz+yZOCxsco2TDegr9h2rEk9ZRUqQU/Drc6jN7OzZ1AQ0H4ZBagXDQFzTVh2+tFFKC9jcRpP+ljEpui7oM54ZqMAHVDapmHtbfZuKy8w5GI8WQMik+meke7/kzGClm3gnmXSE95r5o5F97hsN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-13 18:19 +0100, Kiryl Shutsemau wrote:
> On Sun, Jul 12, 2026 at 11:42:26AM +0100, Lorenzo Stoakes wrote:
> > x86 and arm64 invoke ptdump_walk_pgd() with non-init_mm mm whilst still
> > walking kernel page table ranges.
>
> The code looks good to me.

Thanks!

>
> Same comment as on patch 1 about the commit message structure, only
> more so: the race itself is never actually stated -- that these walks
> hold only the walked mm's lock, while the freeing exclusion built by
> patches 1 and 2 hangs off the init_mm lock. The fact that makes it
> possible (x86 shares kernel pgd entries with every mm) is hidden in a
> parenthesis. And the last three paragraphs read like v2 changelog
> rather than commit message material.

OK, will reword.

>
> > We take this after mmap write locking the non-init_mm mm. Nothing acquires
> > the init_mm lock first before locking an arbitrary mm, so no deadlock is
> > possible.
>
> Do we want to document this locking order somewhere?

I guess Documentation/mm/process_addrs.rst is the best place, I'll send that as
a follow-up separately. todo++; :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
>

Thanks, Lorenzo


