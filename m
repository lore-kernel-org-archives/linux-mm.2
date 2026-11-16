Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B95606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MW4jEOMd
Received: by kanga.kvack.org (Postfix)
	id 88AE66B05BF; Mon, 16 Nov 2026 10:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814B46B05C0; Mon, 16 Nov 2026 10:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7043B6B05C1; Mon, 16 Nov 2026 10:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50DE66B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:22:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2FE71A0146
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:22:13 +0000 (UTC)
X-FDA: 85441348146.19.7988C4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 239B140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:22:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW4jEOMd;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vY0UbG0C3Stc7c0qISbj4M381KaRmNfpfTlZNvZJ4gg=;
	b=kFitwHpLAVjSQkp0Ii9vRkso5YpffB6KOm6ydW31Ewiw8DqP2TzBw/XpS0ecXPlQi7zerE
	BVq3vCIr+HbyGFSBGIEQdOUX8jENix+fFyVowlFG6XgMdmNIXYRLaqq0D3N/uml0A8BF/D
	VxjFV3q0GXPTSkFDorI0sN7vxSZLcEQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW4jEOMd;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842532;
	b=Gdkwq9x9UXJQDFsyD4DYXaNvmu+wc90taRDSKijkcAYuS+ljHyqS57GSF4T0v5XiPdSgvP
	gCGLcapj5RIy5ksF1R6DjdxWys59Gy9GmRzmtRbWhA4XdXGSadXOSMpSUXWmtQfyYUk3/9
	WsedMK8SWnOAXGGInBBshwGw4ayMINI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6129F43DA1;
	Mon, 16 Nov 2026 15:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168291F000C4;
	Mon, 16 Nov 2026 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842531;
	bh=vY0UbG0C3Stc7c0qISbj4M381KaRmNfpfTlZNvZJ4gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MW4jEOMdnWGPvEz5CGqm/KorZii8WlayfaxYQOGWixb9ToQDNIwgGyTyDOi+IurvI
	 ErG/UbUJCeqHZInLB5+s/pUew5wgPeKvlq0VS/EJNtJ3UNQKUN8hax/CmCib2GDERa
	 Jwi7WW0dWg7El81CKKt+cFHlJHRGDtBRMl9aIvWKZYksT+8W3NR6mo9o9DFZvKn3Yi
	 XqZPbfOVbnewWYxzJgobgZiF5p3encmi58k8O7CA9bV3IAnGykhjxxre7lAB31dh71
	 aEVQx2Tc0v4ZHI4Ey/AqaXeuNqjauz69ZoDp3bfjYCR9ooCfNpcWlUeY0kZNuZtMiM
	 0bx/CtQJtyhKQ==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes
Date: Mon, 16 Nov 2026 07:22:03 -0800
Message-ID: <20261116152204.82241-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-test-age-ms-filter-v2-3-3b265d59ec98@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 239B140006
X-Rspam-User: 
X-Stat-Signature: tsa5o1y7bawgr43rbq7nmah4p781o6dq
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794842532-189665
X-HE-Meta: U2FsdGVkX18V/rSFWOH/RAHk+nCoumcJhIGfKkRDyefKq27aIBNs+xd5wuqIxaDbkg1+2R8hkFf1rBkky9LOSGs2RTEwQW93BIspj/KsNb4ixz5BF0OCx6/LTh0xnUqq4zQYpkrGHRKAHoDpTeEEmrC8PIvQ53Ax32f/1KQRSzwVuvLpQyGuaDJnB4stSpZHQ3kl+N2pf6xO+WytbJLwxgvToijBfKRCCZoZ3Ihb+rhIdMg+yN+WNzMBo/fOnLXKaNdmb/DDVHyBrexYVq5WCLCUfrhBZDfbbZCJWH1qQdP/H9AS+5yIepFDwojdbF/Hv/+3KiKqbx2HbJLF/pfIGQaGp2xEIfXaC3xIYWHx0rTp+hkl/ePSMm0EitaYhhwoS00N8ceZ6BgRUN5VkAUFqDfM9pDS4WlHQGKjrTtX/fJmYgZ9aarHxafNNAp7nqSt8Vk7HlrtyeZiFqFNYEAW0EjH3dbjuAUdI4rOBR17D3S44XBuh/cuiaakkiKxuCjbJha1oJFZDY314nxV9dTPiquKzVIywnSFLQ3WOajvuRjQdgYkki0JjWds06eoZpJMOz7XP2RNFMBeD01Qi4btZdjVPpB32gyVjFfPgIyWPjJ7syR5pOfdyicmg3BoplNFJXwjF1sDA7ifjg9E2BqUlp2LeGgMuQYrVQx+JqCmpq/tJW1VQYPc/ZU1EBHfcB982J4v7q8GPxeZrnHgUrWRS9mEAdPBxMhtN3HpOb8EX+m3ig2RLkg7h/XQ+KXcjbrbqsTZaF3Awn2gFoyEdBswZ8VOGHKkgF8gNYhYe2uOsmkE6+KfuAKKTf5g0MqnbGdeUKFY06B6PCw8weOGs+wCPoIoMIC7LwIPXSPXPHjYDuzM6m296A8J7pioW0BG+p60S46dZmrYGruVq2rsEw01SoqAw2NRwzkg+4ceDmR9qAw/GIPVOF62GKwnxnzAc9ghS+Nwkd0Jo7yvOWRTkti
 8Gd17Iy2
 pME9kjDUE1CdeDGUD6HyrkDjgs1MuX6UyLiY+wacLgb5WASst0a4VbZQUudvTGA/9ETG1X70L6stvNoUzwRhPFgrnZEYaod7MibZchkQ2JkKXHLkTsYPN1fNT1ghJ8sZ+KB3gjb0DdAjZVWUWnxsRexQkn1QvBI9FfgAZMu8Ym/AZZltYMdaxScLCpomuAILo3+0ytnx3TCz5UAs6rVlNd31EZ/zNRTvMmdXFSaxDR4bwM7bbQ5RkXgmAyZDl3+YxJx3UDCKKS6sZhfGMvxaw6Dz7KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jason,

On Mon, 16 Nov 2026 03:06:23 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
> milliseconds to filter for target regions. Aggregation interval can be
> changed by users or intervals auto-tuning features.
> 
> Add a kunit test for each:
> 
> - convert region age to milliseconds, correct behavior at boundaries
>   for defined filter range
> - DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
>   aggregation interval changes

Looks good to me.

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

