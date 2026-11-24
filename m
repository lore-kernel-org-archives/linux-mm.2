Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70497606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8V6LnTx
Received: by kanga.kvack.org (Postfix)
	id 2CA5A6B05DE; Mon, 23 Nov 2026 22:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254956B05DF; Mon, 23 Nov 2026 22:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CBF6B05E0; Mon, 23 Nov 2026 22:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9FC36B05DE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:46:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8DA4120A41
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:46:12 +0000 (UTC)
X-FDA: 85468624584.21.9B016C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 162E920004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:46:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8V6LnTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491971;
	b=DTb6leg5xdhmP257mODets23P6dlp6iOm3lgghWXBlUjmcmte/q9zldQK3ae6jEWVBMC3j
	I3I9T+wdxT6SgfGWEBVRzMKMd7kxpWaf/gSr8os6a0ZAayy/hl9oV1O77d4cbW7dSsKZKS
	PT4DWsQHC1m+qlOV+Sa0qjJMeVoYyx0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491971;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kq/H41uQ13OwheaBebVPCAfDd7qtJXI9TF6Qq1NB4pE=;
	b=C+Ccwmba5lSpz10igF3nVIEUZvHLiL1zVH+GPClKM5TM2ASiB8qXZczBYt8ddadMZd5dbO
	GI2/Y+OJD8lSBah2f+/nspmZs918pUzyiRf7l+LH5SBqmx1IrykK3UNgVwQPoGr6RNJDDZ
	hljc6aWnEjvimbpGm/BmB41za4PNcds=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8V6LnTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 387E46112D;
	Tue, 24 Nov 2026 03:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C21F000C4;
	Tue, 24 Nov 2026 03:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795491969;
	bh=Kq/H41uQ13OwheaBebVPCAfDd7qtJXI9TF6Qq1NB4pE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8V6LnTxRfJtVs/VO1hI2L9wLmifY2313I6fXF7rT/xg9X81/cnrBmfoBpaF461LV
	 8bVIrqy8AnfqQoq4MaEwV5mBcmjJ2yjeaxseHaBmcHAhig8Ouwc3dGRdgCCN55EXAk
	 1BGJneC+J7beEgdWwUr3nEY6WkfC9aAk15TAkDI8XQTiJkK1Kg2qItCZO5uLNrr0qK
	 O87b1RGyxw/NKlOB03yj3T1i4oTUdPsbUwIfoByQPP5QUQryZ6E5HLNDbyLlwFTlp2
	 s8OALaTlmvT/t3TxHASd1ljK3C0iZaK1IbeMYz7RLHC7dYdK6Ds6VaZD92KrP4X3aZ
	 bXKep2+s6sF7w==
Message-ID: <sashiko-outbox-230483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] selftests/mm: fix false-positive and racy KSM
 fork test
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, david@kernel.org, donettom@linux.ibm.com, linux-mm@kvack.org
In-Reply-To: <20261123034517.236914-1-xu.xin@linux.dev>
References: <20261123034136.209410-1-xu.xin@linux.dev>
 <20261123034517.236914-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 03:46:08 +0000
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 162E920004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 97acso75r8x1yrk76m3p7oxwose9hqw1
X-HE-Tag: 1795491970-702197
X-HE-Meta: U2FsdGVkX1/b1HVdMzgYTkmst8sEsvj4u54YEV03BDHxayqUzSRQx47oSKsFIgQgDvDXcC3IEAD3gO0HD7Z+YGnYc54hkPicmCVp3DeAoFAKDjcGAYeb3ywT45OHQtYtJeE4bCzH+bBUuGgKDSJF12qAiARhOyCuoKKZDtjC3MQH8EH/VpxVB28bOorBb633jHOZd34qW98EEd+Crl+t1MDYlEWWOWNqPbFz+wa4Fs4EWpLpM3GSx/gCvJwWj5GmSLBZ+Q0cJwK1u37825B9KEmzkMmqKk/xN3m6t3NPcrqMh52pjBQyBHl/ISX2eQqipbU/io0vVUjxBoWinDDGTUl2n3zD3e+m0LT8q3z3Hm72doOm83pHbCbHNyivoD4++7n9ThficcRE8eoHcObaaV98hDf6xwBjzageI56JYeR8LXl8jqNMHBLfn17yM89aPYNpmEUYqVY5uII14Y4zb5nkrlQq5SRuXlLiEXHkV41vvec4yFZcwHMJhu7F6/5JnXJq3KpUNpxKy/jzceBLpISt6PiEdlPMAbU8Fe5AdwuMat2F8lFS+3fApt3Slfe3s0ppXXQuhfq4CH9SmSn+tpHb7JKaJivfcJHyFSiDGxOHvauYln0rdkVFW4hGCbPBacQ+c370+dfmqsT3vl7ZEZcf3oQOXJukMjYEi0QRAgP3pKwxFhxed/1GcgKceEnyUkFOQDdbkNPjufKPWoGm9ndEST7pvCTJrvVln1Sf7JlUCSFtqqLM2atXTcPybYooTRr3IUTYTVW+LOl+UFOUTrMvhU/2VsL3+jA3LMvgBWLAZVRgV9uao41RnulEEvMiieEd+uX/toGdobS4FlOZkjUbNOoqIWf3aCBQ0yZPYLYKwDFdItx/dyuEb1db+QiIdF1ZANCFsGtkeQdHV7L6kaFzTf5UkJ60SoRSDvc9NvyN0AQNzE0sbs2suyQmFoLwKH2Fy7XL9msJVZUlRbT
 h45mQv0n
 5t2YM09XJ19uxaYGAi5Tfn7qzkNP7Z2jqax8msmBPUTZu2t0at0TJES24pOWPtB5sUY1CHXcO/92ravy8Vz/is3xIY9fn0gDI4lsohOdgukVL2ip4Xgc3raFa40IEbKKEhL62hvIXRsOQFxJ91coSLpuceH0Ip5xPbme/cfMHLa3qlAWtODBEAY3uSBjP57kd59MMOM9B+/G/AAhC+J3i/y4fkFYLMxlK9whppMfa2oNmkG0vXATx13P/9CWHPuN7IIiAmSk9qfrnWYR6iEN+iMLy3kAWsiqM4hz2ysvnmnZgnXiI3C2/qi+GPaDmBM9p3FGOWp1y583YD9SjU8Xe+juQDZ8lhDfBcmiFCO6pTFkIYiQ8lnKcerojTmqMhjOrONnxpEzqx0Fvpe8bQjDIDRQyLe5grq2ACEREiTIKmaC5qXbCOENYserp09wrJzxRgR3az5f6eeL/BV96RrM3iNJP78dN1P7cqHy0Bw5OjNH4u15+eU6vzOL1rSyBHFK8GRaegvzH1n7V7fHtEkXxVgCEOf7esCigwTY+UudFgqnGoutOfoaTJyBXzMtyGXeVlJizR2zH2uGFCH5SopgCdIb7Apy2uy6UjffnKiHm6uwSMZAY1onec2Ci2UeXwetdyVdqetGDcnT2JQ+OD7QqwtL2HfkEXHQ9KKTWIkZJdlNnoC+g82mtVX9KdlWLH27vRBo5rSsS2jFc3mSV9mcig/1zBNupm79jMFK1sZJ/fcAeYRlG/Dw74RhfioAgw/H0UXrm/d5XIZYKa18ngqXnGbhsS6gzN/OGxi0VkPGQxTEWwyjdUKngfABZzLa2EkJNFO2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/mm: missing Fixes trailer for
  test_fork_ksm_merging_page_count() fix
--

commit 083e2e9d04935c2fa0f5fe274b48231b2239b2c4
Author: Xu Xin (vivo) <xu.xin@linux.dev>

> selftests/mm: fix false-positive and racy KSM fork test
>
> Currently, test_fork_ksm_merging_page_count() passes wrongly even if
> fork() fails to reset mm->ksm_merging_pages, because the child process
> calls init_global_file_handles() -> ksm_stop(), which unmerges all KSM
> pages across the system before reading its counters.
>
> Fix three issues in test_fork_ksm_merging_page_count():
>
> - Drop init_global_file_handles() in the child process so it does not
>   call ksm_stop() and mutate global KSM sysfs state (unmerging all KSM
>   pages across the system) before reading its counters.
>
> - Use '!!' in exit(!!ksm_get_self_merging_pages()) to avoid 8-bit exit
>   status truncation (e.g., 512 pages on 4 KiB systems truncating to 0).
>
> - Introduce ksm_pause() to pause ksmd (write "0" to /sys/kernel/mm/ksm/ru=
n)
>   before fork(), preventing ksmd from scanning the child and incrementing
>   its counter before it is read.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>

[Severity: Low]
This fixes defects in test_fork_ksm_merging_page_count().  Should the commit
message include:

  Fixes: 08ff89b5659d ("selftests/mm: add fork inheritance test for ksm_mer=
ging_pages counter")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123034136.2094=
10-1-xu.xin@linux.dev?part=3D2

