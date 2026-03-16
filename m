Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2F2F3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0446B0128; Mon, 16 Mar 2026 02:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E3C6B0129; Mon, 16 Mar 2026 02:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FBC6B012A; Mon, 16 Mar 2026 02:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26B2E6B0128
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:19:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6359BD3BD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:19:08 +0000 (UTC)
X-FDA: 84550923576.10.7B1F496
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E208180002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:19:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qsyHuQuK;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773641947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVQ0xdl+kfCBoUzUX1NqV1kjQUfV27cdwquH5nJxV24=;
	b=xQ45NaGgH7Ey+Ksd0lpPnaAV7BroMJsac7uXWA2TyDFI+ekqR7dVYYZUdXNhebPic1eju9
	S+BvwvGFLGSkDg3exalseQ6i4gl/2b6X4xNYMRNvc0ngWQWOsBPfW5XDzxXzaHOBlt+08S
	grtdRRRfuau4Yu/Ca+Slpd0/J7clvgY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qsyHuQuK;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773641947; a=rsa-sha256;
	cv=none;
	b=YwUUIuRaR5hNLI43a34ZkgF0v5dStG6MmphtxRJ70ZkbGxI0AC0RoIwvOwgObs03etvanF
	bbY4W6HeCd09qJsRNceMhIZ0iKQXX1x+T9T3Zmei+1Ekji6T9zHHxpXwvww8nUqy+WqK1U
	gMJbtpgCwude0dpkPeGi2V8rqBTVJwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CC3B60008;
	Mon, 16 Mar 2026 06:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868BBC19421;
	Mon, 16 Mar 2026 06:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773641931;
	bh=mV2Bu+6pDC/dmjcbpEZFd1LBe7AtpHPzl2EX2ejAXA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qsyHuQuK/fDs6nCxEINWEtuCbLJ7v6ffmoWRBRAREq3EVn0ZQ+fnvL4VmRoKjG8NS
	 xmfgqzRRuIEqSXf4bYMB/NVioYiV3HSRLus3TgCuPqyBkWMPnno8FLWun8p8mvI65B
	 bOJoqeJJtorgkijv87w/aVc2QAawYw18eOhxO+b2I7/aCg9/dFidrTlJ9ARVQjXjxD
	 ZUoawcJl/UdiDDdw2iuMqg+HvxY0o183K4Ocw2Wm6ACyFbVSt7iTPYSTYyuNkMTE2X
	 NopKEFWhoQfHsnHvJeIZijcbs8geB1Qu2b30YGBhwasFhdt9tiMNYaya1XX2zp7syU
	 Dy/yByI2fZgmA==
Date: Mon, 16 Mar 2026 08:18:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Message-ID: <abegwBHT_2nlmWKM@kernel.org>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316044335.1390608-2-chuhu@redhat.com>
X-Rspamd-Queue-Id: 1E208180002
X-Stat-Signature: 8s6w8xu5g81bdqkccgsw4j53pdz16szd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773641946-353267
X-HE-Meta: U2FsdGVkX18fpBUm6SPsJzvcmYXbg+oBsafuii/JmI0fwKWmETohBlqt4RAsrxId5GpIaOQy8TZqKJ5ghwEUD3eU5dSx7aRiVW8DIwubYfshJKdNAXO4JBUFljdHu6yvl8lpSPw8spYEPfkVO0pG4elEx0KxokbtWqWIpvV0RkKm5RaXDk5q9NDarroR8pqbUcAa7JHJd2NzSiDNFMwsx0l/+z3oJpEVa5k5zYYK5eyKEX5qXYSKvO9VXNjZzue2KesWBfQp++Rv+f0QUBqrL1GTOUZtva6u2DGibhJbGok7l3Tgxu9kM55SbNPCsnU4m7ibxKaS6sOvk0pNmLeeJLBiRToiOVHfWpKJK+gN9uX0NH4VasIUjhOLW7cIrBO6PRABjDMIP49CQQWRHMDe5L3m0MnAe6IuYct/Tsa9ObXu2Bt0VEiTRSGPrNbuGwX+CoCYacaSkmd2z5DGtxFDJO8Og0eZTwmynnie5Ec18A0qmLvAZj8eSBuDXbwRLI52+Kno9f31D7XTHPfOvLYbZe96DNzvn8JsjCJIr2byr1pIX9Rox872vBXOG/V6Ye9f7nkRHvgc7/IfBWYGcuPZ8G73Tml8LzID5YYVWjHcf70IpMiB3WzHItwE6tTXbu6DVQVouF0b37SMYTNpeankijrwE25vFdSx87TIyyWwJzsPlUOA0/EfLIsL4l3SdbNEfsbPDAvCHSwyk//pC+NVXmCU8sdPtYdDJVi/2wRi3016evHNzSyA/C4V5NP9xZl3gwM5bWSDWK47QcZzaa9l8Ijr6nxMCfo+3vWWqMhloiE5EicZt4tuxruVF7743xFFPiBG8lJDfYor1ChJr2Fx/gah+9lu6xRE2y+kY/fNnIElXMvFjZVWdkrUtl2nL6r0b0WVc2409eRCg3h9kq2MNAFbLwsuPSys8jaiO5cah40TozhCG5eRZrSgP72RAnVMRMLIjnUo0mGAI7MCpM7
 x+u1p0+1
 rzkLnie7OV/bwnMv/izFt9wc0/I/p+T1XnDWQipFrlZ160ztmoAsNbTkhqZD0YMdSgAGCC3Cayquhz+sgw5+k3jLFvWorYWl3TMR6JKA0FelqGkP/Fr7WlXbSVW7JBzM+cqNolHlLhQNaT7nxT3PYNG9ok7F8lG+D7prUoaeL4oxMVcSMPD1s8IXXT3HhZAY4DTG1COBHHBQHbC/lGbq1Nbe5L4vjfzXxF1M22Qb/qQ8usIECSd5DBTay5/6/S90RqDtEyl/wWK4f7d4nr+vody220v0jYroVQV/MCaSP053z3Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:43:31PM +0800, Chunyu Hu wrote:
> When thp is not available, just skip the collape tests to avoid the false
> positive.

... to avoid the false negative

> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard
>   <snip/>
>   # #  RUN           guard_regions.file.multi_vma ...
>   # #            OK  guard_regions.file.multi_vma
>   # ok 89 guard_regions.file.multi_vma
>   # #  RUN           guard_regions.file.basic ...
>   # #            OK  guard_regions.file.basic
>   # ok 90 guard_regions.file.basic

It would be useful to include output of two failing THP tests rather
then just the output of the last two test.
You can also add '-n' option to run_vmtest.sh to reduce amount of leading
#, but for that I don't feel strongly.

With that updated

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

