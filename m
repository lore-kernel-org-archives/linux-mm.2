Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81377C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 23:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701EF6B008A; Mon,  3 Aug 2026 19:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1C26B0092; Mon,  3 Aug 2026 19:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8AD6B0093; Mon,  3 Aug 2026 19:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5586B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:57:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9B39160854
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:57:53 +0000 (UTC)
X-FDA: 85061623626.15.486C85A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 35CB940007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:57:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcD4DoDJ;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785801472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZmYc75+xUIj1m8RE7awP8Cx8x9wPSvBtIIHehJ0UPw=;
	b=OFPuO6tshNDXGYL9i0nc2/kWyGV3awt2rnweGs5W/y39doJ5rCxHZrj4Q/2QCN2fsrk1nQ
	EW9jlesIRTqElkNc6IJk22unqW33eKIsgEbgaUo9VLLXI4lFWvXQaef4Werd9TBticKjvK
	Ts5gAHQhB3cNVgo70FsjJ3z+DcmA4k8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcD4DoDJ;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785801472;
	b=WOS1tj137zpIJvqMDzSTstFjMEFuql+EGzFc9Oqwu+f95FF8pj1vTwKGL+ItCJQFDHuoYJ
	mhpieho+yJLMJZExwsIsM0YwZIW7D6f0f1g9B6in3dpueO3c+TK8zMQeNybXG3YaG0daEm
	amfwlmVx344Fa+SSdm2I1ZaaSxmp21g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4068843F53;
	Mon,  3 Aug 2026 23:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F751F000E9;
	Mon,  3 Aug 2026 23:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801471;
	bh=XZmYc75+xUIj1m8RE7awP8Cx8x9wPSvBtIIHehJ0UPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcD4DoDJ/afmjHhO9gRYV15U96Xfhh/5gguJGfPtTRA4iznd979IRwH3Hx7OeCucr
	 ldSt26dtSUl6O8cY39bU/XRe6Vm9L5xDcstWGUxWOKQlwFh3M3s6kpU2saae7edste
	 LHu99zPrhWrVQXEcfJaFpHz6OYNXCESV+4TAOvrlf6WKb1v9TQOL8K8FfwpKX7xjOH
	 AMNvPY7Da8Dj+dNgC3FUjPJpPsonSrDm4mNq625X/BtZajNVqMKhXcCbL530B3yVGk
	 pSxq8PcesGxXRXPPnbYdBrnoxLWUyQk2KagZHHlKEJm80fkLkshUTQaZRaQneem2JK
	 SPuDAeqiHDPCg==
From: SJ Park <sj@kernel.org>
To: pratmal@google.com
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v4 1/2] selftests/mm: rename local_config.h to local_config.h_gen
Date: Mon,  3 Aug 2026 16:57:42 -0700
Message-ID: <20260803235743.87939-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803221732.3651981-2-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35CB940007
X-Stat-Signature: thn1e8km5j3kp34fo9s7tz5ygzzdssd5
X-HE-Tag: 1785801472-293667
X-HE-Meta: U2FsdGVkX18fVmm64rnK1wHPpYOXeahqZF4yPAd0xmo1njJVEVWloo/svewNC/Dg+LC2wS+AoQuHj68GKIIrehergZUoDmTlDGzKpVHGGwB6CsMGNVNBrxh4dF93UDMVsQLFWCrVD3Vgbiog94kOMf1vIZ/5eEoeTHZW1eaFCqlUH3K52TqFJd5Z3Ab52PsZVckLYSChQcRsPArDRpHFAjzaLNxgkmS7c6UHzeXEoMaKEq0dp4hhqIT/jINRK93SQIGJm3+wqrZuwcyMR72f363PkE5EvX1aXl/WMTIF3I73J8bUPXav5pI/d/Itm4fJGap5Y8IRry7hbRBxR+RS5QMXUotSyVjYSuCL1oJOWS7wM8cu8jT723mDfhqAxKjwfPG34/lzyhoWsGxedRkYOfluUGhr8Dz0U5hc+bLnCftzoO62iZGk0NZrsX5uFqvWTqFbjkPqjHcaa6ct5KDDti7p272vIHaUpMWMyP8/FpG/resh71umpsmmaRf6pgCwnk+zftpY5kbnZt7s0kBZ8xum8iqHm0tzrPyxfU9I87gRPBJUeKGGGEec8+VAX8gzN1bKgYOZbrQ44R0qpcDwIC504V3DQoSqGDqf62vPtckEeaCPdvF2bjT6N1kHPlqTKQiqeDGAaQam4urYegk3ZhM16cSEMNzYtXnBo6e1Jh4Rg029tQ28+I0vnEpiQd1HvFwllV4sNyRnS8Lmj/KZv7kB66ygR2T7xH3dxQfFK3nAq0WIzO36WBUbFjrJyviFqZxOI1E11M2Y9biDtujb1ncOpWb47HUfKGBcfy/dUr/tMcF9vU3AN4pMha8nGebEQNqN064FPrzhQmgQwOvKlOIrTPkkoPlmLONLaommx9T2mJYhocsk1r9NAe0408vPUxGe8TMaBPXdQ2uz7Ef9Ptopn7lhKfg4gtRRofMo8JEUpqu5S1yBNdz2rIvrAw5fMT7rymCIjIdjz0eB1sF
 Onwz0Pam
 upBTzB5Pn+9XpGjjSrtu0jtsdx7KabgKZb4JibsvORF+6M2L1STezMqNW2rmCUIel4qO9JLkyT6Ieo0CAlr5MDHb3IhFn4f+nKaWFEdC4lt1ASSp1uSxQ5cykeZHBAxhJmSQN5Sdl9aNhrY/4TNUtRzEw+27cERwBRNXJh6d0Q6eYR8NfLxM1MgwYC2AJ51fFznAmSC0zGih5n13PSx06NHhhgqkdBwGqmQm1rv0i1oix8OcJDJr9uKC240CMTUVcOeCvr99wnKEzhKnt9lh2cDKGD1PowNojZw612EjWbwMCyMumu9wuQkTUvGNVRjseKCwMA11Hwyc8RVml6B+xuxlsc25dL/4vWPiVEfrMBfq1o9SHsDWmRPdnKYpIN9JTRCMU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hell Pratyush,


My recipients checker found you are using the old email address of Liam, so
added Liam's updated email to the recipients list.

On Mon,  3 Aug 2026 22:17:31 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Because local_config.h is a generated build artifact, un-ignoring all
> .h files in .gitignore causes it to incorrectly show up as an untracked
> file in git status.
> 
> Rename it to local_config.h_gen so it no longer matches the !*.h
> inclusion rule, preparing for a subsequent patch that switches
> .gitignore to a pattern-matching approach.
> 
> Update Makefile, check_config.sh, and affected test sources (cow.c,
> gup_longterm.c) accordingly.

Looks good to me.  Thank you for accepting my humble suggestion or reordering.

I found this patch cannot cleanly 'git am'-ed on mm-new, mm-unstable and even
mm-stable.  Maybe rebasing will be nice?

> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

