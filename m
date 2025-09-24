Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84404CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7818E000E; Wed, 24 Sep 2025 05:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE6E8E0001; Wed, 24 Sep 2025 05:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4A28E000E; Wed, 24 Sep 2025 05:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAE4C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:36:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52D27436BA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:36:08 +0000 (UTC)
X-FDA: 83923637616.10.71ACBBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87ED740008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:36:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AjCeAO14p3zmD9+iEqpOsVWSf1uUTsFnLPszehJC8mM=;
	b=JhvQuYgpgH6a8iOB2zOIz7CXBygcoT/Do5MqPkVFN7utooxaTkZdHeu5nvlVP4qqpbbrpD
	5YqBS7fZ0ZIx4AYoyifVQPgVdc4hxKMuyi9Q7cs1SwF5xZjI3uwJTDiw9LvnOhoHzsRQlN
	yRSRuzXOwcIkeDP4tTwbxhYzUSUYqO4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706566; a=rsa-sha256;
	cv=none;
	b=e6o+PDoymB4NC4Kq0KFmCh4O+aLjX88LL7oYRMfBQJgEYAKCmWD6ZxRZZCWsDopbcPmkO1
	ef1g0onzs981fafVQL0ekTv5wr+lcCjaRu5+GvIrNpmKWP4qcMkISMTB/fnyxBmb+UJBAS
	67jg8AJQW43+FZlhiXx/d4TosgvF8p8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A8B43B27;
	Wed, 24 Sep 2025 09:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551F0C116B1;
	Wed, 24 Sep 2025 09:34:55 +0000 (UTC)
Date: Wed, 24 Sep 2025 10:34:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNO7MrQt9oPT8Hic@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
 <aNLHexcNI53HQ46A@arm.com>
 <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev>
 <aNOwuKmbAaMaEMb7@arm.com>
 <17dabd83-0849-44c9-b4a2-196af60d9676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17dabd83-0849-44c9-b4a2-196af60d9676@redhat.com>
X-Rspamd-Queue-Id: 87ED740008
X-Stat-Signature: ebdo4p8wksnkeqig136n36njjjnxj39h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758706566-416769
X-HE-Meta: U2FsdGVkX190xtatYVK7bHUZe6SL7dA91mTzaGSeqlvvhEwyBlYJKzQNFI6/sbxJbWAgQoy3V7mku64MITdmrNj+W3TFACOkKb6yrX4cx1IrfW6dy4HsJdmsfKnqQDlhIF+mRjI45xb3MBgR9wBQ9/nnvCR2tbo2m2r7IDRawj9H3IfbtIl7wmcRez7Xn2R+B4G7CUXIHBUDX2ObEQ/k1Z8PE+RB/+yWtMNDAcAUKcJ3u8h9MJLCnoj2yuDxHsWNPqPxq34MOm1hdQC1CpfRVroSUBMuVjqwpz4VAHLL0xt6Pq6zS1ZzJ2+P4k98RIpf8vpVNxwVkKP3xT57EbFiniiVTc8OhpHnASjl+ocDrWu1u5LI7+v7CtLndgYjCGqT5b6GbtYDca0AbxtuklACQ/S/NSunw+7r//6cUMbuZfHNxRbPKRzeFSorqux7W9vter9KyZ6Ho3aHEkvEDw+IZJjOBmDPU7wp96vvvhpzycBaaCAU4abe8JYNZFYAXa49UvvKNyrl0wofvIydQMTIaMfrJlwpHGquQpEY7Cl4zJfIjp3ZJYbZ7kRvdo0sCAwgTi/SWYF+ERN6rldSfhhbG82QObkH2kLM09qpbkpEAXlM5Y8cV/sQrt9zoyqiAwpadR/duMdSzGmYQNRZ2Rfz4T0NAJZVHGeh01v6iunp0O0jR7D6h2bv+jNTtiWfIFAS8ydsQ+8wZkXQFH0i+K64VyD/RFuHLPzfWO2oDQnRcaCN1IwjGmkIXX67I2ymevJwesbSYR2a3gK9ezkwoaIpSdVEYfoD8Yx7W6vpDvtrEjG9UH61IzkSmpeE0LNNHokI9Ts/q3VO3yLjIREMPKH/EPE+j1f0Ls83/A9jIKnUBRJovk+KPTmU6r8xZ13VpRM9qwyV7TqiLHZ2oDFbLkZHJIMnR4KZlryp4NEWbpW61EZ1/ZhjpRSnYEX26C1TYc+uD/07BOrT7mhXZeQwFSI
 T2n4WFgy
 rsb0fzAaHK19FUXD9jBIv+NDRH/qdP1b2i/xJkZPfW9Lyd3zZViFquZC/Y11ZOkwI0KYlKm0FNSMM2FHRIIxPHotm5MeL6bs+Aqz1/R6jbKSJ6ItEr68pv28m9BXcRDqA3v9xVm9yXzFnax72JqWdi6qX2qUclYndyaMrWZntVUcsAwnQuSff9lUYnDFxKgVxeoo5wvmhK+VV/DV4mSeXAOVzpPyAWw7OygCKWdw2NYZR4Xp9VaBVDB4MfZhiMquC4QQ1vLes0qpcJ12oZxuWMf08D9eGxt/n17GxIElcMZTeQpkOWgRStKT5jWmY+baAQK7wTaY+RfLIjufZoRganpsTGJm1uo7usDJwgG9bGA7h9iXP3NwD6vnOLJrcKwOQcLjO1FRjHVo4LUGgCw6A9n98TBh3aeCV/x8P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 11:13:18AM +0200, David Hildenbrand wrote:
> On 24.09.25 10:50, Catalin Marinas wrote:
> > On Wed, Sep 24, 2025 at 10:49:27AM +0800, Lance Yang wrote:
> > > On 2025/9/24 00:14, Catalin Marinas wrote:
> > > > So alternative patch that also fixes the deferred struct page init (on
> > > > the assumptions that the zero page is always mapped as pte_special():
> > > 
> > > I can confirm that this alternative patch also works correctly; my tests
> > > for MTE all pass ;)
> > 
> > Thanks Lance for testing. I'll post one of the variants today.
> > 
> > > This looks like a better fix since it solves the boot hang issue too.
> > 
> > In principle, yes, until I tracked down why I changed it in the first
> > place - 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to
> > the zero page"). ptrace() can read tags from PROT_MTE mappings and we
> > want to allow reading zeroes as well if the page points to the zero
> > page. Not flagging the page as PG_mte_tagged caused issues.
> > 
> > I can change the logic in the ptrace() code, I just need to figure out
> > what happens to the huge zero page. Ideally we should treat both in the
> > same way but, AFAICT, we don't use pmd_mkspecial() on the huge zero
> > page, so it gets flagged with PG_mte_tagged.
> 
> I changed that recently :) The huge zero folio will now always have
> pmd_special() set.

Oh, which commit was this? It means that we can end up with
uninitialised tags if we have a PROT_MTE huge zero page since
set_pmd_at/set_pte_at() skips mte_sync_tags().

-- 
Catalin

