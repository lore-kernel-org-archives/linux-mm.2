Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C0B606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qec53LB/
Received: by kanga.kvack.org (Postfix)
	id D5CEA6B033A; Fri, 23 Oct 2026 03:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32EA6B0B0E; Fri, 23 Oct 2026 03:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F516B0B10; Fri, 23 Oct 2026 03:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A67F86B033A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:30:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10BEB40366
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:30:15 +0000 (UTC)
X-FDA: 85353067590.02.1354E77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78C7A120010
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:30:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qec53LB/";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792740613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4wmPWcRwAYNvROfFkIzQ3+TvTf3iBKeJ+QLx3ENVDU=;
	b=iwe6JtKoxTECcx4+WL9FYGTgfwU4LaoECluOF4yY5b1nvU8GOlrioFlD6KH59SxNtOwe+F
	PkiG7pFZo36I4ekmKL+ID/zPW098gWyIY2fbT3d370cKfMYufG/878PTorCyr8VUQ1ox++
	yjUG3g6fpeDBlJ5ZdAdqgz5KBpZimo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792740613;
	b=a+4nPZyrP4TPdMhTsxFe3K0+/zt8XIekX5kIruHFGR6NoeybC9cCRdt7f76MHBIl6K4KCb
	AdzWye8LNH30drnagj7bLF/PPYPkEx8wIqTcAp1DaTrLyWybgo7ZTpiHLndhb9FxjQO97E
	mHjbWxEqLwm8ThO3xqtB0RoknAwFQJc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qec53LB/";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 508FA424B6;
	Fri, 23 Oct 2026 07:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFBD1F01828;
	Fri, 23 Oct 2026 07:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792740612;
	bh=r4wmPWcRwAYNvROfFkIzQ3+TvTf3iBKeJ+QLx3ENVDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qec53LB/A1eayaCEjYLDFL9z+iuJE7bAuXTc06fl/8KJFTDdrImX2I5Dt6mpPtgZi
	 J4YK9HrpfUneKeQyozUR739UvzP0CwZeRE3vf8si30GCWKbiNowKUqUECkKz/c++GY
	 VFKz57zcN5q/l0HebM2mGTVbJffz17gB2dS3/A93a45UKO70+FZDsOixTXd6bqqXvy
	 y3LiPc1ShAWQty+3eIo8ATnpQcJL7zoHv3Om65qullG30F91UT0l+nvNAj35DUdXc8
	 UrpvYCVdiiZfgsTMn3ipa0c/FgKnYXK7Q8hdXNnA0d5M1FLkfZotYY+NoVjdbNgD5B
	 sgtH2DdeBTRXw==
Date: Fri, 23 Oct 2026 10:30:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v2 2/2] selftests: liveupdate: Add tests for
 LIVEUPDATE_SESSION_FREEZE
Message-ID: <atsM_WTjuZNl1EGG@kernel.org>
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
 <20261020144710.4154339-3-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020144710.4154339-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78C7A120010
X-Stat-Signature: 5pg7q51gi5wyoffw6f1foupbi1hiyse4
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792740613-281952
X-HE-Meta: U2FsdGVkX1+mO/NkaBJ9ziQHI5wOERZjjB+W3/aLVAFpz915pxDWajbFyuXvWmPRyafGJjqNXdeQ7ajMGxuRiKVE9t6uwXpPpbRZksO7OvnQVYex+4OWj06jEEXPwkYK995NI97V9WAFAi+w4PU6WRkI091Im3rkAwW3AjOEQNJmv6tgXr4sbleHUTmEhOcwZocJK1p0OZfq02ArPV904flXk4G0/hlFFJmb8778Y7UQ//5Yye0dplNHmXqfDBChsEkf/2J15mnOtSGLEKtWp7UmtaZql9t6cSmLcOjUiSRVEbJBlDA+KvTmxWrCT+BL7uqgAbFSktgEenekU541+dAR7CIJDwd2UBpudMI7WvwQTgfgisfjLWc+qVV9YQoXX6oekfpStSpkwQyW02FI34blN5NUK2ZXGtGaX+Jqev/fsElli8slqLsxfUgBDs8Fr7VXzuE6Udg8yZ5gfh0rU8mY50O5iiUV5j3lev7VFzX3mzsdZMfzlcVyLmvABCGk+Ot0bbx90cJFK1w7olUVrsJFslREbPBbnNyNrrzC5B4I/cSdTadsZWVkt3yF1t6wvwzVa4qsjAZpJg5LHtKb7/dkPhSYRADYkPWicm3ndf5iF9lp0FFyf8LDL0MgiNyxFBg9cuv7beEAqumoacF5m6Oq18VMMnVhs43lYG9gnbjVPHgMoXcejbEfnPditT654HyEtJQHz4N6A1n+A8Qn+quIStW/tPxUoV5q6tCuCUoAHf7k9ka3GtcziOkq8PAQ0cTrxrnRktqNHUHN67wGKYqEX269e2m+Fo3lb+3rrmcSdVGl+GAH+n6PKa7VwEe95tPlCNP4wtDmeK9UJ0zKwn6VP+G0OuUzYbW5fj7x2RXMZsNqcRemAiiQiOalV2zU0kWHRQmcfxyLBKWXW2GmVAHjCj0g/faMeBMwyIP71TxKubBXGamClBeLlE6q2YH0kbIKzdoE76B++sBsFlf
 TyQSrNxn
 Ox5ta8WAQU8IgOH8QjOcn2pWFczqNYIZa2ZHXkQPBRabmXIqvTa+i9uHVL1vMuFldqS1i20JvJ45rH12pvKkFYLz4qNzLnUeeMIt7G0f4WZ3fbhk8d4k652+R+04c7s9WiLAwLwL16Nsad+vH3CSUHiEvn43f1L9MYO52xtvn7c3BaIjYoFufqBFldAYpageuUcL+hwkT4AzVZQKt4Gxffs7yzqH3V3so9DwFf4mMbfAASC7pWiN7QSUYkn8gjAynB6Lm/gqy+BEcjqTbDwvvB1mJQFLKWRb0S4GpsB6igCHrOqkrpGqToe9aQL2WuMAuvK0/fKStevA36kG/NJMy7f4HwjDb3ZkfGupUcFIOAi4wcY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:47:04AM -0400, Pasha Tatashin wrote:
> Provide luo_session_freeze() in the liveupdate test library and add unit
> tests in liveupdate.c covering the LIVEUPDATE_SESSION_FREEZE ioctl. The
> tests verify that non-zero reserved bits are rejected with -EINVAL, an
> outgoing session with preserved files can be frozen early, freezing an
> already frozen session returns -EBUSY, and attempting to preserve an
> additional file descriptor into a frozen session fails with -EBUSY.

Please teach your LLM to use shorter paragraphs :)

Do we need the entire list of what the test checks in the changelog?
 
> Also freeze the test session early in luo_kexec_simple.c to exercise
> LIVEUPDATE_SESSION_FREEZE across a kexec reboot, and verify that
> attempting to freeze a retrieved incoming session returns -EINVAL.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  .../liveupdate/lib/include/libliveupdate.h    |  1 +
>  .../selftests/liveupdate/lib/lu_utils.c       | 10 ++++
>  .../testing/selftests/liveupdate/liveupdate.c | 49 +++++++++++++++++++
>  .../selftests/liveupdate/luo_kexec_simple.c   |  8 +++
>  4 files changed, 68 insertions(+)

-- 
Sincerely yours,
Mike.

