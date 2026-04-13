Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E25F531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DBE6B0089; Mon, 13 Apr 2026 16:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7647E6B0093; Mon, 13 Apr 2026 16:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1236B0095; Mon, 13 Apr 2026 16:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59A036B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:34:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED03B1A031F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:34:07 +0000 (UTC)
X-FDA: 84654684534.21.D69FD0C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5110DA0011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:34:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nndHwHFa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w905OpVwDJNK2AclWlr7lRjsU2T+d2Nuu2dnfXPIdOc=;
	b=oubPkr8zduUXKk8eyPeQo2JBNGQKBAqET4VrABaVjqWyoHs04snCpyByzkvH7ygZRXIGvE
	ub5W/bzIg7wbFPImeSEf1QNgR086ZKHjOXzqAm7sE7dg0iv7g6y04zhplsdN8sIbfr/1Jq
	4MX3q5S9bI4gIIPQPNNQWraBzIf8/RE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112446; a=rsa-sha256;
	cv=none;
	b=Goj0O5t+dQDSqGnSKiHmbTNSSWtjK5Nmw5k15xXDpHWk7oYg/4R5rXQSqmhfo0JlAdtFcW
	hLwgs0X2rZAlPXaZ2FvpGrhD/csyqA/n9SKdWCF6oeSSIzZKXthBgLuRA/5bpum9T1Oqci
	rwIoUiVCx+wBZQ0nohe0FWUZRMMv4aY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nndHwHFa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w905OpVwDJNK2AclWlr7lRjsU2T+d2Nuu2dnfXPIdOc=; b=nndHwHFar4XXsb4K79GwTmv8aW
	WAhaU28xU7z1SQx418EOM3NLDQ/WHDY2UjqSPtX5YClQeBVF/0Moiq+LM8FkzN1ZIsZTt72hbTTKn
	8v6APgVYC/9DUkK/NpmZUbTTKWxMM4lPCfFy8lfKfrB1+MtWNRq4NjMOS0zpu7IkE983w5VwSC7iU
	5FgYRSjt+/zwmhwRcPLFdr/T19HBOSq0IN92qtFwWMc/nLUIhUIpRThsDRPvTkRxhoVdbruPffLwb
	+xNS0tUdM9WDp84+Uu0Dq0AsjWPap0AlzTBebyCm80gN5M7YQzYDzLTPVk6BcZ6hYSg5CApG14Id7
	+9ozj1Aw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNyk-0000000EUGp-31Lo;
	Mon, 13 Apr 2026 20:33:54 +0000
Date: Mon, 13 Apr 2026 21:33:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Message-ID: <ad1TMjF1L3usYIC5@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-6-ziy@nvidia.com>
X-Rspamd-Queue-Id: 5110DA0011
X-Stat-Signature: rjx3go1x7w8efc8anhfg3dd65hnioafj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776112446-504288
X-HE-Meta: U2FsdGVkX1/YnR++7z27lMNAwg9Vuy/WKB8p5pICjaQutMbb/YRwvxKnYQD29hYq/0OT1Ic0BnFlm3mcNEthcX1JycIEkbUFWVwj9RZagTbTK3X9LL6pz5vQg/KssZVo8NzSyGWxhigHve83manXBWskadkAQ6qOW0cQ+T2fR7JeoZZFLqaZdZjbZh+aOCtjQ/epp905f7zDVtrg1a1loXKo9RYKyRNz8pPVU4k9yR5FHm1JoQzVde4rKZ77Vi1Q/zflml911S8SU2iFE0kZnkZhEfrdh9Bs1asLI4hdVx9PaG8SYPg1Q/JFck+6hmUx2DEYeu0hk74dVkuFTIzh0Nci+CQ9vhRswwl/6p56EV9wrKPhBCpPhHfjrwnbUxNgYQn+7rvHnc6WDczjnxxZNv6Z1sO0TpuFZ7YltfrSKz6p+7Mr7/S6RLKhLWAwvlgVJTv7h2gersyoXfTdYVRJEFT+5bFHykmxRVh4/ZXtEd3aztmgIx+aG30y3Z+QbUy6B9hok22WmuhedLlIKXWTEhO15P7b/lptMTpVP1+8FAcgiOsn4CUQtHhsxSKQ5GfQgrPfCmKMignMBOQ27pVI5/ZfEtHgzJGYlarjK1LKtaryPLDL37ynMebuDVSeq1wxg7EK/VLNdCpN+Msz0A5bJSoyv7ZkoIIqsdqPE+HSCG6hYF/Q6J+19IFw0TBJgWPvi9wn4PyOkuDUzNIcszKBoyely3JatAbcqx+Hqa8hgiRfZptY52vFJQYwAOX10u1paoSrcYvzecJ49MP+sAj+ukw5W0Ha3M4iPIQoyHrxlhw/lPpERhKoPAHQQmNgRkaIsS8wyzywQvL5AAvLkW62wQjKb0cOsGMRNo6BC9pk0NghStMcpn+Ol71fKFIsRoefMrt5MS2i7WQWCXwHZ/iZYrpKuF3A0NMxBbGZT1D10WmyTj9pIp+47X5LpBV5Dvg9PNua+apnKVBp0B3gQMC
 qRl/Zlox
 cfun3Fpf6fA80AeYT1XaXCbksyjkdES8mo7eWVSXmpbh2DD41m/1fVhGlESCThOM86yUjsypNcn8Afo9WErjRYZT+hTmkS6CCnxBdxTjujfVvuciGp3pI4Bi/jO63M6T9dn0ZP6yko/eyNnJcGfUOOlLkRmVLkhtGw9DE0tDqiqParQlagVpX6I57sbwtWmt/lwDUQ50d6PrFdT6ha182Vhc8GP4xpNdlms8ieRVUZIE452vQ7qbZ+QpNomHBlm4VV6gFZH2EAWJzAPZEU+fMeqrxszAfdfjyMKy5E2NMXwfnrRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
> code.
> 
> This changes hugepage_pmd_enabled() semantics. Previously, with
> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
> "madvise".
> 
> After this change, hugepage_pmd_enabled() is governed only by the anon and
> shmem PMD THP controls. As a result, khugepaged collapse for file-backed
> folios no longer runs unconditionally under the top-level THP setting, and
> now depends on the anon/shmem PMD configuration.

This seems like it'll turn off khugepaged too easily.  I would have
thought we'd want:

-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
+	if (hugepage_global_enabled())
 		return true;

... or maybe this whole thing could be simplified?

