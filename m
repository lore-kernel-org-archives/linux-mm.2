Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBBD606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pa9hoOtM
Received: by kanga.kvack.org (Postfix)
	id B1C5E6B05B2; Tue, 17 Nov 2026 05:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC946B05B3; Tue, 17 Nov 2026 05:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2616B05B4; Tue, 17 Nov 2026 05:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4CE6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:01:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15BEBA7B73
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:20 +0000 (UTC)
X-FDA: 85444168320.17.2607C6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6860B14000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pa9hoOtM;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909678;
	b=AEL4/9ZA3/2nhwvL1CBFPtJr0JevRIyN5pYHDN/5uXeatbTfb2NxzRf2Ik2cnai8BEN36Y
	mkVXxbnx2xrUKMUi72s+xWdwUikA7izNKrGiIq+cFpB1pFH6Ey2SFVS0xxknLtEGe+qB+o
	8kzhSeaV8IZ4hd3hOit74ZifqIm2wd4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MoWySit5fRy24rju7FbHteJ/SZvP6jKvjXiSW4xhXrk=;
	b=KFLzf6fqE1fSoUzdi2JhG9nll0RBmw+yON6svmI6+lv9k/C9LZX8fv6bTvEAjn0NfRbrL0
	39hbceBpW1WlOg1sRAwnUPNGvEwm/8Zqzvvbmi5B51bd2gLDlF4fBgLQp8pP+TMoLFOmD+
	gp1vDYvQPE8Qf2B092Jk/stc3fCzV4s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pa9hoOtM;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99BC43774;
	Tue, 17 Nov 2026 10:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B361F000C5;
	Tue, 17 Nov 2026 10:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909677;
	bh=MoWySit5fRy24rju7FbHteJ/SZvP6jKvjXiSW4xhXrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pa9hoOtMtdGt02LYiqy0CGvlJcsoMD/NB+0fsjT46VMDBIhXgCYFh1PNLpjCHzKsY
	 MUnA5JEbcHctB6VIoiUs0zjUCl/C0FgH0WMs6EgGCS2+30YSp1g3f+j/0Am9Y9ODMg
	 D5LyPNW1mwrsazFZCgFS7bZp3MNKHatbL6lDDEZoE0RR+QUE0HocjCnhUDCCJDzo02
	 4sYsy5tHwrQPPH+auPF2V9gxb8JTVyGm2CjVQRYheJCu7kfeMeD3Uvnh9txNrg9HnL
	 QNcoq25BmmSgXDAET6rsyL5m8LwpoSLWicfwGM5ew+U9hxwMpJ5giKY37io4zubk6X
	 3zxo6dqsFjdKQ==
Date: Tue, 17 Nov 2026 10:01:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: junho.cha@xcena.com, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Alistair Popple <apopple@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: drop the fault lock and wait killably for
 migration entries
Message-ID: <avwj171O8QMg9Akg@gremlin>
References: <20261117-junhomax-fix-mm-migrate-killable-v1-1-f6e7b135a159@xcena.com>
 <d463af46-13c3-47f7-8b26-702a8edcd140@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d463af46-13c3-47f7-8b26-702a8edcd140@kernel.org>
X-Rspamd-Queue-Id: 6860B14000A
X-Rspam-User:
X-Stat-Signature: hw38d9447q1f94yw1gmpysb4rpd6cxjr
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794909678-678713
X-HE-Meta: U2FsdGVkX19NY+tcRpKVVNCCpgGeb2t2u1/C7JFnJcslWbTp/7lX9xI2vI7FyfmUHzB5JUtr3vJCHFye8i10pIR3gZ61wgQ1tOCaUidcL2AOl5zZo+8QYutNWhqZhozWNF8ucVwkG5tLDaEPcNqUtpI5UHwvAyFyLOEK7Y2C5J8VQJ0PXuQawHrScPea3svxD2z2rdbpx2/Vg76s43I7Mgbkn1USlnesIqVdOvSUhJWLzq7KyyX/Qq4r/mHIxWKKmJh+xguLjTv1SBcMUEQ7iTSqtJc81b9UBtQrGUmpK/hu3tY3IsAwyJKljzNBosmZg8YWpdladr2ECgfqM06TpV3QV2Yi98gtPVEXk37MqsmMycKrHg5oM8uryViaqFIWuyuDgAzoy+AdorOR91iSqf/ZFFVOFva+QbWb5Mlw/cBNhx8mEM1i4irSee+10CeMe/ffd6KXj42PtqA+9zrPR0eGSbHAX2+GvBwHroxtjWpffe5l4Fqec3rhiR3FIPFIGFnHZH43wX19jqGasSp0r2yPhuCqtUxd2Jr/maRTPFyox8LGbSdc59xoH3PcJr389xDzomrmK8vct7iuBiaJXCw7sBPbI7oJ8+P6hB04YpOamx9gB0FbespW+xTRxDUtdhCBgOfVbvcbeJqfFmtKOclO4NyxR4Z2xKgHJZyYjK6GLT2B18hwK9BIwUCFl+ZpgflD+JV6clT6szCD22wh99rEQi7ULWKt9vOLzr5R6JVpCV3GNxLT/I2wmPnvU2BPbPbcne1qyS3i3GzF9DYzv89oQ+Bodo1s2L1zgI+jyFFXMJ61Jjm4pO9g4zFgEceMGRtfBEfTzydtdQWh3zBDtqhhgMg3gO7icN/KspSE9G5Zgq3jdzzokp3/M6+gE4oeo/ZgffCHPgP+4MPg/NDOxXogxNu7ADUUROFPdO+e2xzKF6LC9OtL2qK/gr2KzCYU9vsdgD6DkHDDINpDCtJ
 dW/8GBLZ
 hhwZeEjmGgFmAshTiHU+wZExG/0lV/k2HCdAIejEOOYEGX7IyMUdeYlfseVYOJd5SLGZcLcYoUPy+3kxhluXXFvlS8vEBCTxkEw3wgk82AYIdgOpXiYXD3cjVMREh9fjSgAdp3d0uLKiqgUnpEpHriym9b6qL0lVlACMnNLttgdVj2bYbnOsnS0o2FKB49925BpmMz+O80K0PWfrv4QZhrLVmk36e9/fNK4PY2j5qfRlUcTF/q3zFrztDYBMzzqGbCy3Fn3MSlzoC+VDY1gk1iQ+P9Ppq0ac6XhttXfjJB1WX4nu3vrbXTQF1HcSWF4gScD6YZVkhHFTRVT4v9GBwlPIS44U6W1cK0VRtNWXQn4HnSJ+w6Auh35gIvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:46:24AM +0100, David Hildenbrand (Arm) wrote:
>
> Hi,
>
> I assume
>
> * this was not hit in the wild but found with an LLM.
> * Most of the code and patch description were written with an LLM.
>
> Correct?

Clearly. Their 2nd patch ever *eye roll*.

The patch itself adds FAR too much complexity, and clearly there is no
understanding.

This code path needs simplifying, and I will be making significant changes to
migration for scaleable CoW anyway. So absolutely no to this patch or any
variant of it.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

