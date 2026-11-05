Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F913606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWPhHi63
Received: by kanga.kvack.org (Postfix)
	id 860856B05B0; Wed,  4 Nov 2026 20:15:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811A36B05B1; Wed,  4 Nov 2026 20:15:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E966B05B2; Wed,  4 Nov 2026 20:15:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1CC6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:15:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE92A408F2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:15:51 +0000 (UTC)
X-FDA: 85399298502.06.B93373D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55BBFC0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:15:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWPhHi63;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793841350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rko/oVa5FlJMWt6lgI18FJfDtxQ0qN5STtLR6l6SJiM=;
	b=0zaUekc6UvHkLS6anGm2alOWRXlQ9KrjM0kVke+OJEgHMGrJTRfP7RPUb+shnB7z0NCutL
	lO87y3zYUo0qcFqV7WIBNILLtoc1O424NIwZlLjWZ7ZM/X94Iwdkyup8x/yJcVUOtjM2fq
	4oqYilTxhIoryjKsXzS3kerH2lewfK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793841350;
	b=1mdgUw7kTrVk/8ceapxbH8SPEUZUYmSWVR+DMQ3LUYE9y1c+rAIVKVnOV2yMJ4olgbjeT9
	u1O1k3D+6RRkgI00Q75DA+Pjn3HCrrHI1KjaJoey4hijQZahcVBUPlTlGMVAR9fiSWeIUg
	cIsdHpH1Bquu2uJirp7rjk1LZk1pJtc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWPhHi63;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7784D42AB2;
	Thu,  5 Nov 2026 01:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8A21F000C1;
	Thu,  5 Nov 2026 01:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793841349;
	bh=Rko/oVa5FlJMWt6lgI18FJfDtxQ0qN5STtLR6l6SJiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWPhHi63xBWIe8w49sI1jemg42UKII7ysuNMr8mEs0I76GTzAMMS9I+OkKbonZvZ4
	 QSWOmxA1dYXxbaWc7H8ZMlJnQxTs+shIg0AmbKdZqNwjJ+2o8QIG/hbnkvPZA9PYbu
	 5fJXuOoDTeqnzgcwuV5v3gk+gGYspxsQdKXa6NrDE5lTxwbVc3wA5Mw7DmWXbijYrQ
	 5T9EFbM/hgxEX3nWa0Z7efOyzGquX3Caepdl1yyInswDFRChZjikU5uuRQF6HYcO5M
	 jH7X1ABapKmgbn0eTYj1lL4JbkR/mPJMCmTCoIhAdL91yeJsZ1h2nl0MfvmjzLjeri
	 iHnb62PFUYiWA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/4] DAMOS access pattern supports selecting regions to apply a given
Date: Wed,  4 Nov 2026 17:15:41 -0800
Message-ID: <20261105011542.87865-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104153645.82945-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55BBFC0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4unrnuhu81tocxup9j7bk8iyjc95wdkr
X-Rspam-User: 
X-HE-Tag: 1793841350-931990
X-HE-Meta: U2FsdGVkX1/tsY7QXsz132OKXxrNtjmkpFOFEuZQqx8W55jpLl9acuxllgPX+mlLoTThHbeyigfjfDs2Qd+5J/J0NzAb0EdzPc2jxTu2buRFXk/x5DyQ3Ho/LmDcfmxvjNCK5gaQs1hSP6MnJAfTsWftZ1zh707JSZzoBlY8pk5w+OD+JDCde3+nAu2eTlAvpf8TK4VAsMbqZgz2R255F17WrPbkf0DvSlDPTJRnC9wkQFYb6BSwO/Vo520n6DcEHxf7onilQbApojJ5B3IbdOby32VQt/r1qnIb4tjOGAJyEHdd/ols/C8bIuiEvQh8PsF8qjHIqWcQJjryTpGQ5WjSu9k8H6/njK/yVSNpFb/s7V4oBsYu3LEqQ30QwC2ZPkLgv+lqUXug6qxdP3i6CAV+/Dfb2aiIJEJHWY6dHQHT1IsMGA0QXtAWhvQ4jJIV4uacSkeParuzl/JZS64gzF94v7y0ttXdQrWT+QarU8zjHCTEZqQs6EzxpT/6MFUijS+cr6EM0W59S8ZrGkKh/hC9sfcbvLP/OtLNHds0GsCIFPpCePcNKpxTZuOx4a0VkdH8Rc/g3sqV1tzRDJgNH/RJ4v3/fK5dN8IXgwvFw/sGg2cF2BEu+68FPMElH06RI6GzXIq2rzCr9glPj55hF8gPBSTfP11gefvRpnwXJ8+g0+fbiejavX29ErDVWAPtL2dbctt0TxLNsoEZDtbpIUops3ZJOwZ0LkmgyKhcz8QrP2gHcVeQFtvjC624K897/r041g1hT8eU74m9OPzcwecgjY9l8AxbIYLZkrNG1lvIMdDkxMwBXTv/koMCqlrN+Po2egRA1EdS/w7Vntg+Z+HRnvwjN4nPIgmzqg6y0qY43IycHsq03CEx0LIij0yJbB7/zxMJeoumA+u9ktGf+hqJawjV6DcpnNVL1B/BzL1DcY77p9U/tfmIIFscn32rNDtzx64C7IhjU5W55DG
 8qOxu4tL
 MxMQPeceSheV0TsOOegXJIc8pQJUPcSeCdkz+EW5OCI/Iq7dkO7ssgyex5AvH8owNXHAS2sBvFP8GgoR/ooe6apT9QDmLpD7/mY2GNNpVPAj1OVGaEaquri5HNzDCOL6kZUxSnWod/KrE47pL/ga1RrT1fDecccKR4V4iIExFrZJGBx8R6AYUcx98HlS8sHUODkpIRA6rYf+co5+levUTfpeVnTltyT/xJpUOLMsShCA1+Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed,  4 Nov 2026 07:36:39 -0800 SJ Park <sj@kernel.org> wrote:

I forgot adding a subject line.  As a result, first part of below paragraph was
added to the subject.  Sorry for inconvenience.  So, please read below
paragraph before the quoted followup paragraph to read the full intentional
cover letter message.

    DAMOS access pattern supports selecting regions to apply a given
    operation to, based on their age (access frequency stability).  The age
    is specified in the aggregation intervals unit.  The aggregation
    interval can be changed by users or intervals auto-tuning features.  If
    the intention is to specify the age in a deterministic way (e.g., 2
    minutes), it should be updated for each aggregation interval update.
    Doing so is cumbersome and challenging, particularly in the interval
    auto-tuning case.

> One straightforward solution is extending the DAMOS access pattern for
> specific deterministic time based age specification.  However, DAMOS
> core filter is a better option.  It is playing a similar role in a more
> flexible way.  It can be used for both accepting and rejecting regions
> based on if they matched or unmatched to a given criteria.  Multiple
> filters can also be combined for more flexible and detailed rules.
> 
> Extend DAMOS core filter to support milliseconds unit based age
> criteria.
> 
> Implement a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS, in
> core layer and expose to DAMON API, via patch 1.  Add the support of the
> feature on DAMON sysfs ABI with patch 2.  Update the design and usage
> documents to explain the new features with patches 3 and 4,
> respectively.
> 
> SJ Park (4):
>   mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
>   mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
>   Docs/mm/damon/design: update for age_ms damos core filter type
>   Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
> 
>  Documentation/admin-guide/mm/damon/usage.rst |  3 +++
>  Documentation/mm/damon/design.rst            |  3 +++
>  include/linux/damon.h                        | 16 ++++++++++------
>  mm/damon/core.c                              |  9 ++++++++-
>  mm/damon/sysfs-schemes.c                     |  5 +++++
>  5 files changed, 29 insertions(+), 7 deletions(-)
> 
> 
> base-commit: 32e967f279b24f952a5482e2c427894787848ee0
> -- 
> 2.47.3
> 
> 


Thanks,
SJ

