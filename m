Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FE1F531DB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E34F6B0092; Mon, 13 Apr 2026 18:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CEC6B0095; Mon, 13 Apr 2026 18:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1615A6B0092; Mon, 13 Apr 2026 18:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006FE6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 805D31B6F65
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:29:15 +0000 (UTC)
X-FDA: 84654974670.02.720780D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A2EE140008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:29:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZmWg/RE7";
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776119353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTwBXrFpNi4Fseaq8Sky7pLzRp0mlA1ksSlPEqI0JKk=;
	b=2ZsvzGnls7I0V9Wz/s1lf0RvQT6tdTwXauop03Do6Ou2igPyFcB7Dsqxc2UjpRjHfKF+H4
	UZH4KU8Ka8wpx02FQoSEy9XVwL3odkzOy0n3cf6ufVRMKt9rCxEuLBq/oHBWJgEuk7wG9E
	kmpQ7FjpTugQymXQHp2erFSXesPWIKI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZmWg/RE7";
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776119353; a=rsa-sha256;
	cv=none;
	b=ijC5Kj2bb63aXXlf05wEJymJ6LW+URr1NkEB3wAnoluG06vk5EJgcqtWeTJEMW4AT7xOfg
	5CRcCeijEK3OhDoNURrPuUUmyDh+qs0U7mt9Hp8dQXete9VrH/XPG9caFqJx5ZEr0sg9CJ
	4uf92zf30Rtee6A8uxRJzB77xaQ8htE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NTwBXrFpNi4Fseaq8Sky7pLzRp0mlA1ksSlPEqI0JKk=; b=ZmWg/RE7pdRpXKI55S8cbSa8gw
	Wjv5sTE0WbQzhn8CDWWUinuH2sjpRwR/arldGQVvp9Ra7GtijGUvaSE3/iP/y4vXKYlxAfLog97NV
	LbRjs5e/P3yEPbFYnAC+qP4JFhZves3bYyPL+lSIlhsI6Z/fEIUPloZDi6gsheeUIfbr/snXATm9m
	2D1Ykc9DMdIJE9vnCflifaF7szT4YN+e2+8cwyWUsWvGylUHJTs3Gvn7SUY7kQuMOBsISsJ+KID92
	sxg648RqlrvaJKmdhjNXNXUaNVNc4TyMjhrvxYBO2uKgWDH6LjtI8A9dkQXWsdLJ7N+NdYnV0ltXA
	7nIexsqA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCPm8-0000000Ecwc-0D5J;
	Mon, 13 Apr 2026 22:29:00 +0000
Date: Mon, 13 Apr 2026 23:28:59 +0100
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
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad1uK11f_J8sFN0e@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
X-Rspamd-Queue-Id: 5A2EE140008
X-Stat-Signature: h7y3ezh3xmy868mwpn9i5axu6dxc8tsh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776119353-761898
X-HE-Meta: U2FsdGVkX19sn4zak3/6BFicnlkAeVZdW5al8IAu43RSmnI41BTqQoQz8itsSgtFWWSHIGF090R35catSnL7z5dtrvAFABF6KOTxcAAnUWflRKXgxu1pCyXIHx2E1ICU5h3NIYv2CuUCu+J736lHdeMHxp7FAiV+Xth3ZcCesGrUALe9WylgEcKt8cWoeHhK99mmYtPR4lKIHB2SNqBDPz/nUe3kHK6r5Pl6GD+9rlePxhtdz7+eeQ95ReNxjivlBICBnwunElKexnv+quwRwjAH3aUBIFzRXOEghdgsKtKoY7b/mE3ClN7VkdgMqD2qtlBRu15eBOr+nC2bacMk/+y3O9VTa6CusJgg8Bt2Lnj/6L8xMdAhJWp0mos26LNa9K2gsfd0X5XF9MmdZjaesWlHINVch3uzJGr8Oy5HZCfKiOnqrxu35n6VBg6vnO7PuMfPbA8yopLY4KKnFPUKo6T/U4Tbewzh7Iau/XyqMCsudjaG4qZit54VkSzsBlDKUlPTCWKCdZcnl+SHL2w/gDhp/EAn2IXgtsIRVSzReWXJkicybr+ATVxlyKmMYsBvdO4vTKeqvchCnqKFn6V0teOYGIG2/ihFSuEljyqGPYRDXfQRpUeziLVX5QqvmETiU1e/Rfkrh8beGmTAmiEvuSMdj6iwZUE1EB1uEcbnC7d41V85e5lHjqkkTUhl6ju12+QdlKmM1OAXKHOek2EKQZdB5FZZCvizlKeg8ac1ZYhHyiwlH0vCEjrW1XkVGX9aD88ZBhq4h/jHxE95s9l3kPGoFJtOea4N6NyiSfyjSN+5v9Q9LJkKvtORhMC961P1x3USQqHqSDLRNsKME+bDb4ZoaufS9QuM7AItM/ma0bcpnhg9ZkKBw9b2iewKbclYmo8Bh/1zNg2GOcKEbiqf+svM4RFpCD+r6neYpRCOV+9YRCCZvbykFKEwtI++7OKBv/nIM+Q5Kn+bhUlz2gL
 OXoAOTWv
 +foorH4qOPcGRCMxupVPwwvcVFjdx0iGc1xyE5IxJKo05aQC+uYP27/ux1FoOIi7Odsp72KaIjCeXiRjgNd5VvjIrg7Oblb73ythvEL/0wNzWWnYRtRdfTrnNZ9btyy33nqdTrzhd5ym5NztELpSOKEHKG1p/A9cXJgNcnbowbFl9shgT6E/wJO4Cjlq+izOZnC7CP6+9YKkTdP+FRjfV3WyTAOB0J6JzJ5GYmPZY6mL67ptagSIropJIuKkBs3jXgsQjIeh6eRSw7WwAme5t3lHMenGxIrpRAuPk9wA7xPkG0Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 04:51:28PM -0400, Zi Yan wrote:
> On 13 Apr 2026, at 16:47, Matthew Wilcox wrote:
> 
> > On Mon, Apr 13, 2026 at 03:20:30PM -0400, Zi Yan wrote:
> >> +++ b/tools/testing/selftests/mm/guard-regions.c
> >> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
> >>
> >>  	/*
> >>  	 * We must close and re-open local-file backed as read-only for
> >> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> >> +	 * MADV_COLLAPSE to work.
> >
> > Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
> > Should we delete some code here as well as fix the comment?  ;-)
> 
> file_thp_enabled() used by __thp_vma_allowable_orders() refuses
> writable files with inode_is_open_for_write(). That should prevent
> MADV_COLLAPSE from working on writable files.

That sounds like more code that was added for RO_THP and should be
deleted?  See commit e6be37b2e7bd

