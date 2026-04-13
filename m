Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE72F531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758A36B00B0; Mon, 13 Apr 2026 16:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709796B00B1; Mon, 13 Apr 2026 16:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7C56B00B2; Mon, 13 Apr 2026 16:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF416B00B0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:23:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA758B7A19
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:23:54 +0000 (UTC)
X-FDA: 84654658788.09.746290E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5724F20009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:23:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SzIDPrSX;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776111833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Go3KR/GxnDhS1WvRjFzC5JY4mv9JDOpGHOi+xw7ZijQ=;
	b=3065+VrLnHTbgQTYJOODgzYTOd/HMGTRy2olYwp5qAI9wLlfzL2sQnWf1JsMf+eF19FfzV
	Atq5F2IwIYJ6vh/xODxStFBw5cMyy4OzvIvVg2icfsTOc6/Ns1JPanXfpXP6iWO0Xv1Y/G
	Rue5UZPEh7WgMG0aaR+sEIV8gKQ/J0s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SzIDPrSX;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776111833; a=rsa-sha256;
	cv=none;
	b=q2VTIJBlq4wIuxZpuUGX6ju9R7HthmUdn2n7QicNALL0Er66cqakEsTb6/9RsFCLI19wbK
	mVov7DhEZy7U7T9gkr/ceyi5Fi7JKcYs2RVIe1TFaiTWdkU7ZyG+TPaN3AJiqTuxN/jNou
	paJ5nzXTl4T5ZERmRGueIZohb/Qx1oA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Go3KR/GxnDhS1WvRjFzC5JY4mv9JDOpGHOi+xw7ZijQ=; b=SzIDPrSXF57/cO6VKzxPi/iAs3
	cYuprt6Bgod9wvN6JE4aFQK1TxBqvZaNiOGYtVpaIFL1sblvslueuM0+CvnSqokGtHVgvoy7ZVtZl
	gPCoVPyYfw/eB8bIgp1ZXUpjqosuYmdEh6nMYrFemmGDTgWsdHg5bZ8iy08NNk4fIA3QJ6BmiI/zr
	QcKn45zWo5LwySVJgr0WDxbxUcoI7t1czaYn7ha94qec/l8T4so9413TPJefem8L5o6Fy9mPGMqtn
	jqd0Q8gTAdnstA0crwWESqCc5k/ZYbQk1Dak79V2UGMtIHjK0fnN53VjTR6AOLrXtcnaShJxY4ZuZ
	GUfF/fhA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNot-0000000ETYR-2MUu;
	Mon, 13 Apr 2026 20:23:43 +0000
Date: Mon, 13 Apr 2026 21:23:43 +0100
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
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Message-ID: <ad1Qz7SClkF1CqWs@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-3-ziy@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5724F20009
X-Stat-Signature: jqi8f71ikfkbc5cwwaz6xkewr447ckre
X-Rspamd-Server: rspam06
X-HE-Tag: 1776111833-598188
X-HE-Meta: U2FsdGVkX1/qsMJd4bKueZQedpzPHwUIXr1F33nEHZreaSsKqSXRyTx+A2RDKOISIDX7jeMLJEhpk7U79zB15+12Ou/q8MElJ4TLnjMk96lrG0U/Ub3iRyqAKOZ6HM1nPAEfnGrxWM196cu5al9fbDKcv8iXYTWbIHfyPHi6f72CrJsPmFDxwDNkXPSa4gI6AWvDK3po6Zo37ZUtz25827vKMDMGoT9Pcsvp3yuQ3Wo55mlYUTsQOBluPtVTpxLC6tF+xZ4lxriGOwsmUTPTU5w5yA0pPkUjsbZVNjpxqTrdVgUyMqg+uCTDm9BDlM4BTK6ekYcggunYAIWBDSTi1CjyKXeLzxbfd9zpVDdH2ILfS9sIGPMCkLzqnPFYOZlVToSJztvYx2XujKL/TffiYyyU6hkLRgM3u4Kxfts1XoPpB5R/SrTNRNsTkuVH8y9//3D6Vc2W+mTV13WOjxQnFH68TbSTqAv05H+K67PFyA2+S66Dau8Pfvmuo7SvvzXLkLOjG1otHR9XRah47WROEyymZ1XMOUS7FDRQtmgnPFzePdVCxPa/8aAJL8L544CiG0Pza+XR4hXXAaFVxmPtHTwepHoyQuv/y6uh6jn9SnF+pCWUENzXsF09sYDG24qHDcbmFmDqKiQ3x4tCMnqsNO3w/prCu6nJs+dXsElwSh3GvqK0OQHFvdziLzIDoGtyCly5vvhQXLL1I2tAxh3u95X/cQABZA08lwBLTu9J/x93oS+AFj2aCymj+9gTfJzaen4ajhxhV/DaqlQ5Ht2iUp7OIzjGKLeFHMyr+5N4she8/7dKaqORBrfGL0NJUnmLEny8p2LRxwsPCh5ub7yXUPsAmOpD20bMJXPVxdm0RtW5RlhhewnRGfTSMGO+sc+dyQy89vCJ7E+PDzERxvldKS6hI3dHKriam+GOf6ujU3+HDJfwXdsT3SKMCIawgsUiDgev2pr61uVggTOAYpD
 B8nOGi0e
 VgXwYGsafjBsyYKLxSR0f3jpLs1qbTy8c++AVWtNQnCgAM3cQe7sEG+4hC5AaJZyuovLhsirXHcGNaVZuMV0oQfXuWpSBKdxhV+rlwiOx3RGIt4keIcduYSnF0D1t7tsZTj0NZbL4ckeUumEpDbr0TmKkwa5gqSmslJcBRhnx6XM+m8K5p4buo8YPjd8g7KnrYl6chnEGQnkyWO8Uf8iH770Y104GGQbnhEN8voe22ltsaxQZMwtJ6h+osHdkcrS9v9qMAaC4rJ5sNlSJ0M7ytv2d6N0kvU0YbvXwutVFDmCGzSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:20PM -0400, Zi Yan wrote:
> +		if (!is_shmem && (folio_test_dirty(folio))) {

seems like a spurious pair of brackets?

		if (!is_shmem && folio_test_dirty(folio)) {

should be fine


