Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA0EE8B397
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405066B0089; Tue,  3 Feb 2026 22:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3817D6B008A; Tue,  3 Feb 2026 22:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280F26B0092; Tue,  3 Feb 2026 22:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125EE6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:40:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A84F13AA3A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:40:35 +0000 (UTC)
X-FDA: 84405372030.22.D684A5C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FE8140002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:40:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usqKfjbj;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770176434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Onih74rKhXQNkfzkcTR+Zq0Kg1PNfu8onD0zt1Z+qOs=;
	b=S7DNyzrPLy9oOubvxuR9m9i8nFXJvIvFT1kh8LsOkYEj/pq8f+DbIshc2TvdsHohyof7gQ
	O1aI/1pjNSJwEjw2j6VnkaGqtnZJKRfcrTjIwJ8c3udB/MWoNpYa0wH99R/Fm7XC3D3+dD
	Vg7BhsRNoxHTlxvZoyQPqJdpFMCdCz4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usqKfjbj;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770176434; a=rsa-sha256;
	cv=none;
	b=4hvbVN5qa1ztGGIpF94wMLlHcg8Xcedqh62Tpk0ag63PmHh+YtwuwsXcjwEZVpkU1ogcND
	8FS5cKya6OFl+Mj+BWiF/zkr1+Mwudtd9c9WTPidAQNI6eH2RT6ssiG2wCW3Qc5bk8E56w
	RYdZDwVSzOtj2Gx/VjCQrAYj+GcaBXE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770176430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Onih74rKhXQNkfzkcTR+Zq0Kg1PNfu8onD0zt1Z+qOs=;
	b=usqKfjbjQqGhGMX7b2myIEJwHkIgCA2hiWToeEcUL8WqIF6QvZMpKyiHrZTCEotjc/XuU5
	hrDYwyyf/mkZYKRDIdwxGzjQqypNpRQ2ezxi2dWRzE5gQ301xxUaeKxtXnz1t8CvaMPyEY
	CPkmIkZoqEon51/SAo3Y3y1+pjFyNM0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv6 17/17] mm/slab: Use compound_head() in page_slab()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260202155634.650837-18-kas@kernel.org>
Date: Wed, 4 Feb 2026 11:39:42 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <69CF3AD0-F761-48FE-A7A9-20061ADA1A5C@linux.dev>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-18-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: kt9y5aeqjqcjfgsgk51u5o3gr4ip96nj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FE8140002
X-HE-Tag: 1770176432-610624
X-HE-Meta: U2FsdGVkX191HGmXJIHaVQ1Bsmp3x7+wTFaBbtsZRGzXCaNdv8CUtuRuU76exO7HiFe8Asttrx8Cz5PGcMfMW5YnigLsM/i2bZeIaauDZBT4JYAUPX8EP8xGmfjq7HtG5ElBJ5A10TJLXaHCN3eyRlPy9awle562p4w8QbLxsex7dvgYxgGLv7NvbnHwWdOn+CYyBhjB1ltxr6yzuFq+nJaj2HxQtR5+MAS+NOamU6vZb25wWGWyFuz9gGd/3tGq6hnfbK90mKB2UjY+RNXk6HCAwtqF7HpQAWnMZFhQXwc7btg3IiIs0uq35O3bEPwWWB0vlvsHuNsGQx6ERPpp1naYqumFjtgdncOsgvrlCPWW8ujRMZGnMyptwfN7gds9uYAG76WiULE7j6yRXBiO5tKhE4xxLD6JJ4PKNkHA4HzTrB13LnvD0Fs+jtYP/SPCBDS19G/eXxVMA1sBSb48WFjCjleAf9KT0gO0itVMoNe0ds1KPhUOHaCaIbqRlUBf50mNWODgtKF6bFXQIfbVx07gvXXGd522KzJW9uz3l3RZ6JG3AN2eQzavkf00xPnxqmPQt8OO3TeDNljWIzVRS/NZRHK7zburiuLuL4TaAJQRfuoXSR7YHP4eeqHu3B5h1YGnnZmbLs+75ZstmwLccnivRZrW4mCoL9+R/L/17Ir94eP+uczPAbhTEJ4+Gpr32g+i1ziwU9P/gNexP+kUeNZTLPmnmP1T/AAFuxXHbPpjR7mz81QzSRZsU99EZTkB/Huj2paYsh7VvTXia+osl5XDtl3ITXxJtxG4iRIMdTc8fG094+844s+lQrVhpKNpi0jH+1nSTKqoinsgky/PEoRt1hwLRtp1GZnYHVdE1Cf2WLAi8I9V09V3WSbC1VqHoVtKHM2NR4La8l0yuE0cemBu5Nqa5EUeOVbIEDUrymXUnCPECpcovQGoAqJFDM1o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 2, 2026, at 23:56, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> page_slab() contained an open-coded implementation of compound_head().
> 
> Replace the duplicated code with a direct call to compound_head().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>


