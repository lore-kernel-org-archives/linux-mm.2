Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC290C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D2D6B011C; Mon, 17 Aug 2026 18:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44226B011D; Mon, 17 Aug 2026 18:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A841C6B011E; Mon, 17 Aug 2026 18:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8289C6B011C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:30:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1201CA09B9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:30:53 +0000 (UTC)
X-FDA: 85112207586.03.6869F7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EBB6120003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:30:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eTW8Odno;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787005851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL7juVfbUl+m0ZvSLQeExvxWsKmILyS9r2lR3m5Mto8=;
	b=VLurHPdWXPld0hrVoPVq9XviO+LU6rxMADSX/BBlPPb/3yufT0a1EtJlZTNlMtJIFUerxe
	7XWETQVkah5zzPEzZGJvJC6REXsJucExA898qvJOscpl/Ulr4hwlweviPyzoJNO/5PNz5n
	PxkMFYD16O8Kb5jutV2etqpXyJEgziY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787005851;
	b=DtrSgdffWrfRVlNL2x46cZ1i+bYI3DH0x0QegDLyOrHitllyzGJF5ho2ij2RaN+4QTdwgR
	oycjrYotEZAy2SSJW7cCJpr2wGUqrw5JQMcNVF4hnpesVbFMSEWH2P6puKtRE9IA4Tz1RT
	GYA3nbn/Xq2LQpHjODjvSmbG1Dmg8EA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eTW8Odno;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C6B041FAE;
	Mon, 17 Aug 2026 22:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94731F000E9;
	Mon, 17 Aug 2026 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787005850;
	bh=TL7juVfbUl+m0ZvSLQeExvxWsKmILyS9r2lR3m5Mto8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eTW8Odno+P99BcU1Q2Z9rnhOHszjurKW/v/MOKKEepwOaUISyX5nJovEcwXI0C2dR
	 p4QOVSwpDjdIkB8kIa/tHl+d0QIEFzo1BqRdAKXxu0b6SG4/2r67o16xPLAFB7ZFPz
	 49TtX9yd/Qy56hNQe/WRdO/lGxNt20k7KHexs1RY=
Date: Mon, 17 Aug 2026 15:30:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: baolin.wang@linux.alibaba.com, vernon2gm@gmail.com, david@kernel.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
Message-Id: <20260817153049.120e224cc303f1c2292cd768@linux-foundation.org>
In-Reply-To: <20260815181632.21453-1-lance.yang@linux.dev>
References: <20260815174444.4164-1-lance.yang@linux.dev>
	<20260815181632.21453-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dpokefyh4b456i1ash9tw6tafm1cbmoa
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EBB6120003
X-HE-Tag: 1787005851-715733
X-HE-Meta: U2FsdGVkX1+e3ABw1OfKo9Bh0W9T+OT3PDrGFxWNS85cTuy1JOkUgCUY5rgjh73WGRMgJP4n0I2BHhyYayxG5PTVd9wMkSJZnur96W79MwAWydNPIHaBWEH0COpJ/5G985E6+bqJ2EnkVvJuPc03PHDnU5HZu/zFuT+JRltPsy0yy/S58O/gGl9Nne9urmrPdPG8YBj9gid1bleDNcdmY3ZKWPx3WLjcLnuM2XuM8wcrmRQC1icDZyqABO71RCbvmX6AEUvtt4SXFle9IK0fD3x1ploIibOp3l4t/iC+S6wuSkgh48ZvdNbtLaxM/iXIDw4oYkxXrNAN0H4Gw6c78JLj57DQPzOEnl2nG6fXYbRVg91qRHGnkudM+RWWWUpV1Y2Le+vOc2zehcMQx3Z1msI4SZcLanKxD84H9R3UXXUnbNz7LSW+KOTmP8K0MgBryPTWLlEf3EED3vz32f/8IwqNlAXYVAu7K2Bva1zlmn25bXD6yfJWKZ2YhCjfyLWkfGMZ3+qF+QxV+B8+9hZV7RhyNFNEumxjGT2jYnPvkL5Z6xwy3zdXYESjGVwPGdcU9QEu8LaZrfKsz3VnqQhAYrHf4axIiY7J47uaJFvb3iIfYyRwL1ItMuGtdR1abbc2o1WEqAJQmh/WD0PCj1LYNLpqlFqfwMD8yRo6tqA3uJT9fmS2bfRYtj/cDDCVLTETYjdaaXDEoQNhJxbki9/8s5iyFnIz8s8sj45hoJw1mJAPjpf+MMOvUAt05lQXPBE0IG3XOkrlla4smuDPq6oIKWRDdpnisCaiwO4Y8frZR0VpzzNYewUnhGyAWqNWLx9lu5ab4ScfENbeysTxX1JM2sVDferSlkbFKfkG0cWp91o65M/oOltNqk2LQ5/Da/18a60RSq1dPAzP9jUw5xxYJQI7PlrlBIlqbn9TpXw34d+LNau7Uds4GwB0xKMyCDa2owRQyoQ7+9uq0Xz1jlW
 yEOzhMt5
 NayBJ0RRhCjXa5DJp9JwfjzRAxmweFkoJwNaUGDBCMCtWgo0oXUuYSjNrBFJkqgMcMozH6zl911nnlRtK19Xrhguk73IGqLL41mhNUitfagEEhBr8D3Z8l1TKQgq7U1CF0GccVG0q2LyEAPzVU0Qr//2NXXHkiqeaq07zC8FAhNfPbMllMizOo867oFN/xUfri7d0JOCgF4ctg0fmM7TLW6q8hvj7WzuPF+ouIYMpkf7umoIRUd5uPJF5J7V/RaY0caTaCuHgc54krd8x+CIfaMth4Ro5y7Xl6uYXzo20KVzSaBTUWcdbh687NFWUwT4mSePdNcnjwqvOW+8obNpt5ByLOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 02:16:32 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> >>Pass the pfn to the tracepoints directly, captured while the folio is
> >>still pinned, closing the use-after-free windows in
> >>mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
> >>mm_khugepaged_collapse_file().
> >
> >Well spotted!
> >
> >Gave the series a run on x86_64 (KVM), all good (only classic SPARSEMEM
> >untested) :)
> 
> Hmm ... stumbled over something else while testing this ...

Sashiko might have found a couple of pre-existing things.
	https://sashiko.dev/#/patchset/20260815051924.194810-1-vernon2gm@gmail.com

Vernon, you may decide that the second one is on-topic for this patchset?


