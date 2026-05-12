Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBCFCD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D441B6B0088; Mon, 11 May 2026 21:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF39C6B008C; Mon, 11 May 2026 21:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE27B6B0092; Mon, 11 May 2026 21:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A84CA6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:01:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41468C17AF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:01:54 +0000 (UTC)
X-FDA: 84756965748.08.9E69239
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 999DC160003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:01:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZ8mRPl6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778547712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYwrDjbwwSuW4v1d3n/yoFZRyhZx0O9fTNkZKO+rF4Y=;
	b=h0S222nOttioBYYuz+Au0QpInUk1m1SFU1Yc6nno4jyh81fnrbfU0pgyJoTqP7h5RJvq8D
	9FPea9wMwy4a7ED8fREZmBEoULsnaO/R2oiHO7pltfh9yS/AhjnZESU3RFpjl/g1xItVBu
	NsLQFEaYuM03fvm5RQ6nj6EyW2WQdMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778547712; a=rsa-sha256;
	cv=none;
	b=pqP6UMnuHYd4pOiqvM2O1nlX0LIPJKiAkzluipzxQXDCc3EOZ3r7CcVLmQwFZsQYh/Mqoq
	/IHyWl3A4hcFqyiuf1nRhQqbF6+Q6IgNmCMpTTnJodPWg/dh071/nDxOrr9hScKGtrE25c
	ggQp15yj8AEBSYY5C+b+rao82XJK3dE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZ8mRPl6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A17624171A;
	Tue, 12 May 2026 01:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCABC2BCB0;
	Tue, 12 May 2026 01:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778547711;
	bh=uOigxamA7HqnQC0MEIlrE3L2zzSIAwK5E7bXe17pjuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ8mRPl6jaBrMYPbTjpx1/PdPe8at4EqJQbmNDOM4fuHw5h2XQ3/Wyj2ZXzik0rfe
	 P9+urSYhg+zHJShmVBgBboyIzzFoI5XiIKOYgZh2I1enr2K7IV7iXgHBJ7RPmd3Gwr
	 PMtzi1HL7QeUc7NHL8GsELE4o3h6S801Z2vsTNiEQh7TPZNNHasqqjjouLfjmPuKhC
	 wgiA8wDWK+IbrwwfGvLONOJm26+5mE96shBOi/ZQjoDQiGGVSEC/uCs6q8sQ2La9ns
	 G6zFvENQD/hgPVXTgGTOhEVTiupaI8KGkT1S6ROg1gl2xtZ3jysBg3XyPQL8/Kju4o
	 NyD+BFrTE6s6A==
From: SeongJae Park <sj@kernel.org>
To: pratmal@google.com
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	yosry@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] selftests/mm: use pattern matching in .gitignore
Date: Mon, 11 May 2026 18:01:48 -0700
Message-ID: <20260512010148.1175-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260511173411.267628-1-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 999DC160003
X-Stat-Signature: q34thdfa41rp9oj3h8m1os3xmd5s61op
X-Rspam-User: 
X-HE-Tag: 1778547712-207635
X-HE-Meta: U2FsdGVkX18vtFiw7nT0Bo3Yg0jZkDq/cl8LXXmAIHKbYi2QGcdGOG6y7N2MTyUgC0aFGifH+dvNfK8cilZjhb/Fys0Rjcrs/DdUgB8K200NDDzkeAjpAKlt78SZwKgY1s1yjkDgPrZ13RLqLLiMf5T//ikFlJQYcZRAavrOIyLZaAy1VF9gGsk3Au72X6XZwzUNzawKwGuIaBARTSK93j0dof9UEm7gnKhCMBhc4Oi4rcpOY/LAnv9SirG/5NYTQc94KMM38sZFT84Wf2TtTLdEzaOtJ79wkVN1ao3kWfTJWcjXRqXEbxqNeKAm7I+1Qn6doXRNtUQYkS9iqFvC6fFWXGPHBnj+OFKrM0Cd1MwSV2nG8FKCEJjlrfcRsW7jP3I/LppotAXx5CvMojR0v0386ubziITRNbQ7o6M6OY1ULMuffRoSNdMWJ7fVHt+ggwhBFB5Ibhjw4VTEBr0uuqE63hnPqGChk/q7//Aod53qOejBRhTA2ufk2RBJawN1io/XRbpUMGEY8WinzfW8rPHym3KtXs7qfax2yZ7soWQeppvaJj9n2wQwmpLsDd/ubNWDbCI9V3BB5aOErC7pZKcBPIXcE+6FXGVRncD84WfqhK5uQiTjQWNECGjKsRHKKw4btio+dIrMoawHIGqiGhhfffPLAX6kvsxiLfyhFidTN8BCjTQuijmH0Z7Osqa+jTGQHgjPRUvrvVVlVMr23dKndnhfsRYSfczCMcaL0/rRvopj3+dHiviU3qpuhOxCWjBMTdvibC+2XYImugWG/tReonn9YZk5WnYm9tJkATWh0EvD9wRUCva2OIXrYmAfvbo+vhRUVb5u5Aw8BwaV8XTQ8QGGnHrf14CLCb95S7mJe1k1diDDYvyIOd6a/XgdvQE2fMiFJLjKKvEc+9/kPi6FqLRr4IwG0ODdxOxa3fjbXta0dMb6ePGzRJ32pPdg19VTgLlnptUCtmpWPnL
 6oUKDkT5
 4yfp29YGPvmwAwS+RdzXI6ReI2QKI54XY6XXXwR1aNWiQ1VB7L6xMImn8JfE26ixW7pISmPTjJlfL/IXjQINtgFCRVZFipKG7g1RhFnelgeo0OdVndwKHOxBUCKrfYD/B3S4yjMzhYgc0BArSSGZZFL+0u9X3CoD21auo93JRM5zZlXZXs3A/EU1oIZ797AzF7CEVO/9vgyeRnfqGz3+OQntIE+K3nXX6s57wFeplnEq1uvEywBU5pDoKz/EYdWYReIrRXWE8bEh2hHhR+Jp5k+lCVG2FXaKX7An0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 17:34:09 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> The current selftests/mm/.gitignore hardcodes each generated test binary
> by name, which requires manual updates every time a new test is added.
> 
> This series switches to a pattern-matching approach (similar to KVM
> selftests), ignoring everything by default and allowing specific source
> extensions. To accommodate this without tracking generated headers,
> local_config.h is renamed to local_config.h_gen.
> 
> Changelog since v2:
> - Split the changes into two separate patches (header rename and
>   .gitignore update)
> - Added Suggested-by for David Hildenbrand for the header rename approach.
> - Dropped David's and Yosry's Reviewed-by tags.
> - Kept Lorenzo Stoakes's Reviewed-by and added Mike Rapoport's Acked-by.
> 
> Changelog since v1 (RFC):
> - Renamed local_config.h to local_config.h_gen to avoid conflict with !*.h.
> - Updated Makefile, check_config.sh, and affected .c files for the rename.
> - Removed *.mod.c as it was unnecessary.

Adding previous revision links together [1] would be helpful for people who
willing to see details of previous discussions.

> 
> Pratyush Mallick (2):
>   selftests/mm: use pattern matching in .gitignore
>   selftests/mm: rename local_config.h to local_config.h_gen

So, after applying the first patch, we may show local_config.h unexpectedly
shown on 'git status' output?  Maybe too trivial thing, but I'm wondering if we
already considered doing the renaming first.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

