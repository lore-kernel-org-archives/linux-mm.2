Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F50C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69816B008A; Thu,  9 Jul 2026 09:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB046B008C; Thu,  9 Jul 2026 09:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993A96B0093; Thu,  9 Jul 2026 09:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 730426B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:51:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D3304016A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:51:04 +0000 (UTC)
X-FDA: 84969374448.01.3B78A8C
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 29873140006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:51:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qj3MKYul;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605062;
	b=Jx2cQl8+x/qHfmhZ/2XM9I3S4opx/ma9rmqCgG7i6Dj8iTc2II46HroHb2NWFKeH3a+HAh
	gVOSJ357ismK4lrSzoxcwMYgM945JjxvQRDk3DGh18BgH+EfXOEhSvNeRoxqEHjoX0doPA
	syZcpMVqywkLBBQHGcseAM5EyNK8hok=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qj3MKYul;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8FqW5eq3Uh1W5agsXYXom0eXyZ/LkbEOhFOOkLyqNU=;
	b=vL/ZRLkQuUtpYBgDO3szVfrObA+vgWgERmJJADAXs1SpEYJGpLQNNMwembVb60/z9rhx75
	CjA/3x23/oudYn2fbCasZH4zig+cjViompuSNgmiqfWO10LFtc9XBeeBmkv3x7N/xWc42x
	C1y3u/4yXwnfMn6coBaeyU3OrAzksdc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783605060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8FqW5eq3Uh1W5agsXYXom0eXyZ/LkbEOhFOOkLyqNU=;
	b=qj3MKYulS0/NJ/Qjk8zhEIgCr9AW0b51sFXof////YFtj5/yXTLY4yyzdVD1+/8HM/hfFX
	3KOoV5n2sVnAjg3GVW2moiIW/UcY/2XiWIKzaUzuBzVYyPCsOS8yDqeFxjEiYGcGgV66ta
	CLG9sXAFewOyZ2U5Vgpi+8YvYKSCbX4=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	"Liam R . Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 01/11] mm: add PMD swap entry detection support
Date: Thu,  9 Jul 2026 06:50:49 -0700
Message-ID: <20260709135050.2910286-1-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-2-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29873140006
X-Stat-Signature: gmntci4ykrpbiupf1qdry7twme8ejndt
X-HE-Tag: 1783605062-724020
X-HE-Meta: U2FsdGVkX19As8603hcLCVE2IhmV+hJ+IZ5YSRcVsFNJeIIsR1bsHnapFhtwSzIq/ef0VTj4SQYUjpMP+qxoB63FBBpVQlfQgQYuHbzF0LV735vR6HSHk9va50phDdDtUwV9Dbio7jOde6OHKbGTD0PUEWpto0SkfSm17rPOY51ORUgxKLOSkbl63213xUwcDryt0xhuFKxZN9MJg89hriE6GKAUIVosVtv1RsMghUdBKUyAwbkGjB26VFvduscQQfBmEyYGlK15eaFUFx/0hiDBAiyQzrcNgEjYvfTojBEmkKWm06UkKS7KIhnH2xsyKDM3B8ZcewLej9k3aa8pMADB+h0+/2o9agLRnq6GuuFr+4Zi5pJ3uGdea7jU131jWBbMe3k8JuNSRHsFltZg8YT42d5RC4q+vWUbSy+AAw7nOa810d6Fg8yw1Ekh4vuKLDZPYI6vImjOIBM4RsdU3zguWLbPAs00V02gxbbaii2WBa0FXiefTb3FYFfQ+rfp9XlXkCs28tjcos+ZiaNPgZJywUcBjlfMqrx/fkYy81dxIemxkvq2Gpj50SS2DOP2Y3AJk/jNNuchIuFgW06N+3wd8S0M1BwVVDvn2/zJH6MTrTsf0ktLiZzC0hjLofSvQwVQaVFRC/cwgzELGiUsPKDcfj4XTbRoCebPVPzTptelHEA/oyGE0dQV5/YYQckSeaNy7yNHDAMtMyr9dsKha9039MFvSoYl74nFNqj1z2u+zwu/We6QkckvG9OWdCmVqrNvGKeGarEAg0KGuXCMrYNjgfaAQfNtlxkmKNOa0yc0AXeAUgy0AlbSV1T3TfExLpcnIYI+45bQ8XtgIPtj5+v+KbOHivAdH9/eCmbDxBk9bT/2LUyAwUxSB2ErkUOd6hwLBqQBUMejw4RRcwF1VKsj8+hj/6o7xsI+SxQzBek2BvresbOGe++8oqMkQV8XCiM3qIzV2o+urfxavdW
 Zb93/9iF
 GaSUCfKHxZCtWPyx7atpIXtNyAocENkOzmhnF2ucpjybvG0wLVJJk2GppM/8jHxckXWPahSmXvuVuonYyDwMqlXIpDIY3uEZEX9PRPtkKlhOfFv03l6ugxn2qmntt21QKh4HdKvROaP4bnQmKtuer3dyfreTPhI7ZprYkna8pPo+8Hva6TXB+fQqY0Do0/+VZOtAt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 10:38:18 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Currently when a PMD-mapped THP is swapped out, the PMD is always split into 512 PTE-level swap entries.  To preserve huge page information across swap cycles, later patches will install a single PMD-level swap entry instead.  This patch adds the infrastructure to detect those entries.
> 
> Teach the softleaf layer to recognise PMD swap entries: pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry() accepts them as a valid non-present type.  Clear the exclusive overlay bit in softleaf_from_pmd() before decoding, matching how soft_dirty and uffd_wp bits are already stripped.
> 
> Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and pmd_swp_clear_exclusive() helpers to each architecture that supports PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc), mirroring the existing PTE swap exclusive helpers in each arch's pgtable.h.  Provide generic no-op PMD swap exclusive fallbacks for architectures without PMD softleaf support, matching the generic PMD swap soft-dirty fallbacks.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I forgot to format the commit message before sending this patch,
sorry about this, will fix in the next revision. 

