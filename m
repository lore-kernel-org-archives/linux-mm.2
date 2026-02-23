Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A9BEA4FD0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638256B0089; Mon, 23 Feb 2026 10:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBC26B008A; Mon, 23 Feb 2026 10:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7DB6B008C; Mon, 23 Feb 2026 10:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 345BA6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:18:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E51C413953E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:18:53 +0000 (UTC)
X-FDA: 84476078946.19.90EBDA8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 473ACC0008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:18:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gA3K3dpb;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771859932; a=rsa-sha256;
	cv=none;
	b=8OmcZDZLQU+P8CdKnMddlIadhrAcjdhFMTZ1/hJ6TkT/EI1OIBeFCX/KUynOuj6cu8IYJV
	GavUXjbR39oKJYL16SV/ghHcIUjq70Vz1132Dlig0LKgArc3yGixeuWrc9NM5qeDSmcnP3
	CL7I4cPMUb/ea/DsmE4noHQCZ1JiqbM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gA3K3dpb;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771859932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1Pyr+PuAUEvSin3Lid3+3iEaebJRuWaK1nzHUHfvJU=;
	b=i/fmNtQgWcInFkvAYZKV8AMDTkSZVk9nV4t4ZLZcgsdE5yLJfWG5aY94nCIjsOQzgiIayn
	bYtDH+9kcNgwaeFKDKtBSg0TXrXYLqgHhtbNAb+FO1tW2Fq+UFYwxwCrLo7JBJkZ6RcUkq
	Mjd3PObiCh4757N1X7gqsv6LxwLB3jg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J1Pyr+PuAUEvSin3Lid3+3iEaebJRuWaK1nzHUHfvJU=; b=gA3K3dpbvNeInnLOTbSUFfNzCk
	vPBhNWwpfU9pwz3ungRZAi+0kDBTW7+HlajkgAuzelgB35eHW4qJMZ/XT7NMJwhh6i4aEEG86hLDC
	wphXKrrK/pCSZ3FGitimdei46DCTcVXjuaJJ3B1dINPRgs4o89lseU5XRUeOW2FNXUk5XiRw0iy0k
	3qAYDbQOJU/9hWwa0Lev89Ab88AFMCS50dPGzo/vizsHkxdlae4U83TaISx8Jmbf/oGOcIMmV2K+v
	i/VqdKip2dCvMGB9HwAtFHPgXybj/HsfEiIfN6AXECswAAQSzFa7ImnmQGi1fV2dmaXf4purfk2Yf
	EQcUmUng==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuXhq-0000000Ef0a-351E;
	Mon, 23 Feb 2026 15:18:42 +0000
Date: Mon, 23 Feb 2026 15:18:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Pedro Falcato <pfalcato@suse.de>, lsf-pc@lists.linux-foundation.org,
	ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
	ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <aZxv0mEd2BA3Mq-N@casper.infradead.org>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
 <a778d249-afea-4488-b045-beff3492a48a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a778d249-afea-4488-b045-beff3492a48a@arm.com>
X-Rspamd-Queue-Id: 473ACC0008
X-Stat-Signature: j3k8nx5jwwy9aozez9hz3fjdxkbrhq3s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771859932-60194
X-HE-Meta: U2FsdGVkX1/QRog7ygnZ0ZwQVfEvJ9hv5/xQxXVem6jB4JsuNKvuBUKAi8SOXpKSlQbN+1K8Iah0FoKSR9JevU2MVljNK11EKyikGEIZe0pkl5O2OK3J6LMFtZ9ZQW3TOrIrI1psXReNI3Gcb4n5vNNNPjs3YjpP0E2AJWkVifZAnXE/GfWn6SN5NFlauiiVGbq3RWJtFv57PuucqyarwW+eVgqU4TF62wQdqUtJBtXj3fcoqJyqT9NeTUv0Dw9qWhaYIMlJfvo2RwYwatDiPzYlHj4JfTgp4RTMScSkFNJrjsdeDhzKdmUEx2M0rUTJkN/XXqzI+xzILEK74k1jd2xSZMxloJvXCJ2NTH7G/IEHokWIuU/mLlrScWoyMIKn/h3vasSEGznVA0mfem5dOSWfezhV3JWQZ8x1nse/B8MIUNWTSeWohAOY+6gnnzhfUDx/Ym8tJaLCMWPwuV/yyBlalyPT6NCNaaNP36Bmuokx4vDmO6v9LDMdc/+HKj2GXKnorP0M6lFg0q6XuUVNYSBp1QOlLOkt++fvVuG8GM4ZpVi1VOS0az2eTnDf6V7c9JUaDvyLeJnUGofvzrgV4ndIIiDEj9FkjT2OIrqs17EzdLdqoY+1TdNrARuXFm8UxhPTxIN6rTVOTDiiizShe1QhZ9BOCEkUVCYxpgSm0CqIQsau3umaVtadNfcagvSY69nB4fynLPA1AIjsPKsLhjExb/XqzPUYqod0Px4Oqa63NeqQ+6gSdTG123MPDOPA/pfgIltzucdroLeV7iay1hWkQmm/Q+g1iwe0+gn+hdGdjG2XWLNG23RgXZ8vK/c1T1vVY/uzmhVE55azvJXjhmRJnJnkwAkaDCK1/gBfZOf7GWvy7CjPv1yVqcpVhCE149d19g+O9BXbs8FUj1irvqIowM0vJfnWLPp4Ed+Yk22HyOJ1hkEGOEpjdDJkT/JpPTBTMy9U4yDaeatq4/t
 1iHuJP77
 UPHCmWNc3VYk7hpbD154MRIOhBUrRq9xvq/Sq19sUxWNebrixz2WUUCt6OfGEwiJrWjhm777HXllOM4ZgqTphw71vzCaJES3hPGsg8M6reKBkRR4r58u4h9LAXtzX/3Mhi0NCqT0QO/FYi6E9JRD0PMd2XwNTbjdu/aPNLNc/etYQrCWCwQo2O0LvzDJUdz/Vfb01yjBLRRTeIN1uzGyn+UFC5lArYCjcaLjaIRqmDPBLL7dBX5rq1hxrtSITHx4YTnZ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:37:55AM +0530, Dev Jain wrote:
> I didn't understand the reclaimable reference, but yes we need to make this efficient.

this goes over 80 columns so much and so often, it's painful to read.
so i didn't.

> So for the above example I gave, native_set_ptes knows the virtual address to set -
> walking the native hierarchy from native_pgd->native_pmd->native_pte (in case of 64K native
> geometry) is inefficient. So we need to maintain a lookup mechanism from a linux pgtable
> pointer to the native pgtable pointer.
> The idea we have currently is to store such lookup in the struct ptdesc of the pagetable page.
> For 4K Linux pagetable and 64K native pagetable, 512M/2M = 256 Linux PTE tables correspond
> to different sections of the native PTE table. We will maintain the pointer to the relevant
> section in the native PTE table, in the struct ptdesc of the pagetable page of the Linux
> PTE table.
> The other case is that a single Linux pgtable leaf entry corresponds to multiple native
> leaf entries - take the case of a Linux PMD table which maps 1G of memory, this corresponds
> to 2 native PTE tables (2 x 512M). We will have to store a list of pointers here.
> 
> >
> 

