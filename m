Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58163E6B26C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2766B0088; Mon, 22 Dec 2025 21:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90746B0089; Mon, 22 Dec 2025 21:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D406B008A; Mon, 22 Dec 2025 21:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82F0C6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:00:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E65E6013D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:00:00 +0000 (UTC)
X-FDA: 84249080160.08.314E2C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DC95A0009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:59:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ULctXWJb;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766455198; a=rsa-sha256;
	cv=none;
	b=W6bk2iyRmCJBQFvWdK//Wk7kR4UCvrOe8RpIzVYbEL7NgyMt/sY1uRD+c7wiOQ6xt4BWVr
	WSWZ/jNeAnT6Pcwpqzc4kKw0LZGGvQrBPndy51oYjGpNutC3iCKkRUNqP0IZf33nJbFqA5
	vMe85xggQgglFPIlTBvVwvxQ0w2FoBA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ULctXWJb;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766455198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64cs06UvJq345mZiYfsu+sApGEUy0vygyalXeAPFSIM=;
	b=0IEAUK7PyOQuTVXIjxVZipQdUJiJYjnMoTHMt40a/i8+etP5R5SkugHtF++DPCb86KeVv0
	PY0aakdjzmKSHZ98RmWH5nyKuSsPB2SUBjF9Nv6pMuahwJb/KMwXkLtlB2wrF9NHB4bGYz
	UHNhaUjexkyB08FNepjK6LJ/3wKmFs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1651C60136;
	Tue, 23 Dec 2025 01:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767FC4CEF1;
	Tue, 23 Dec 2025 01:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455197;
	bh=yV8XQYnghuYhjxnB+j4OdCi0iKmCmzJq8LuQA5bIn6I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ULctXWJbVUAAGZMDutAkeqpU+T2GHmh030Kod3ExAXEDCQ2yJYeilyS7QEbN3n93A
	 YSRVTqHXXfyriW3g118ZEH19wtan0CBV5iVm1AiGre09wqhmbNMSADIKXeaIxId7h3
	 35EHAcV9dF9BVmHBLlOQgHT09WZ/XfcDxzEBHOM8=
Date: Mon, 22 Dec 2025 17:59:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v1 0/5] MM_CID and HPCC mm_struct static init fixes
Message-Id: <20251222175957.bfc9cf8b25e587f3f5e304bc@linux-foundation.org>
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DC95A0009
X-Stat-Signature: 8go5zo4qcc64j8tj7h3htsypzgqu4m3o
X-HE-Tag: 1766455198-870090
X-HE-Meta: U2FsdGVkX1+GIq2epQzHkCQUfu6ZOz+ATF3U4O786CfvVyISSx8q+3IDUADAsF79Ipid4dg7KJDoJnVEXb9qH8fHpoSqKquRcXKtQfABCTn0YMYRXQuo5G9KWVIPE2ylxqPFpKVGfW8X+Poz41ahieQye3y20XowMFwQ8+/loEQWWFK58ogLAMNxMVMbKKOstMmhrYkQuhJgjQd/VF7Pw0KSmZG9a5D3TICXDP11p8m/++o/8EiTLMWWcQzyQ6dUiIlwciIqrKF6Iy1+/W8zIx93mR4NMI7ZZ5QJrwOnN5re4XhcONZPsbN86dPg96KXYghDiliRFRexwIUFnRTPFKc6kzK2YWcfqz79J1JQ07F1qCG3gZ55nsShW8Wq8NlwrnPMWYpcief58cyVONHC+te70sdr00Hr+2syGERewUnTC0eG+CfpPCLc3L3RA7NPlP/AE+5zajDFDFSexxBkiGzrdVJv6a3KEuTZKJejWXySHmAjz8gbycEam3T7FPEr5JZ/dQP/s0JjIYgg/CxoQz4a6woWHQB+ffaHRl7MykF/QMLci9RsT1d50jbKfDzedrrAEYfuo/zNDh2F6iiI8K/3kuSOKryaN4jlBX80ViHyPeQR/pE20cqGsdejk014r4vxLYACsVjowwidcypfN8htrUzYZA3u9knVFU68sc+YYnQvRU8tOyCcG62gQw9zr3yhp8+ufV0UXsUJqjqsMA+ML9M68fCLpNmHzcABXdtnwo88M8l61LXBSzhBDvgD/G0j28pX1qpMs2yRgUF/92AKUtmrost77LQT4lRiG43+6gN2MZbVjIyOOIYlt/niTovgcHJRAVYcatrD0hW4WMt3S5p0TFYG/r9xHdYaMjjm6YhuO0HoCUKJL9mBYz89MW8KCmlqQHM6DWhD5HM2nsU7lagNSR4IOd4qGbP9/EITfGRYhV3A5/jng91TF9IspkU1FRCnWWYb25Hikmi
 3iFCxB2r
 hjmZ5tqB3HGe4U1cFciflPuu/QtneJzwVPVqV229kyieZUPhgkT3YPBBkVJ6RYN5qgtGFktJDo1PcWPOKH1r+e1nDWeQskjjDf7lZyc1JaFpV5x6B7YR+/wx5x5Xe/Tf0OUn+7xJT9ZJoqXQbcrdCEymycqMAIkF6NwFH2NFR41fdw8luGSihxu+3e81dQGxSr3sXOUu5eVzfu1ipFjlR2F0a7nYAACXBcE5svrZjYlzCuNYcntIvOhjKsLUuvSigYeDV+oiqzrMPuuyB3sqggoCtp544jfVUTncq+mTAJ+o1EZ7LJf3OGmkx01mqGDVTq2oX8+KJScLyydxfyhxTGZLC35oOcN3bNUUkWciy2/8+bXhxfYi1mjPciV52TQqJ9J4x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 18:29:21 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Mark Brown reported a regression [1] on linux next due to the
> hierarchical percpu counters (HPCC). You mentioned they were only in
> mm-new (and therefore not pulled into -next) [2], but it looks like they
> got more exposure that we expected. :)

We try to please ;)

Mark's report is why this series remains in mm-new and didn't get
promoted to mm-unstable (and hence linux-next).

Also, I anticipate a new version of this series thanks to
https://lkml.kernel.org/r/2fb78e41-5e56-425f-925f-a29524355d2c@efficios.com

> This bug hunting got me to fix static initialization issues in both
> MM_CID (for upstream) and HPCC (mm-new). Mark tested my series and
> confirmed that it fixes his issues.
> 
> Please consider the HPCC fixes for mm-new, and the MM_CID fixes for
> upstream.
> 
> This series is based on mm-new
> commit 287373d0b6ee ("selftests/mm: fix comment for check_test_requirements")

Well, simply appending this series to your "mm: Fix OOM killer
inaccuracy on large many-core systems, v10" will create an annoying
bisection hole.

Also, there are some cc:stable fixes in here which depend upon the
presence of "mm: Fix OOM killer inaccuracy on large many-core systems"
series, which is all backwards.


So for now I'll toss this series in there for testing but I'll ask for
a redo, please.

- All cc:stable patches prepared in a standalone fashion against
  latest mainline.

- Any non-cc:stable patches which fix things in current mm-new come
  next.  Perhaps view these as preparation for "mm: Fix OOM killer
  inaccuracy on large many-core systems".

- Then "mm: Fix OOM killer inaccuracy on large many-core systems,
  v11" which incorporates anything which didn't make it into the above
  two categories.

That could be as many as three patch series. Thanks.

