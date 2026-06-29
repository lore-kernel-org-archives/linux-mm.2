Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FAFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F5E6B00B7; Mon, 29 Jun 2026 19:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F9E6B00B8; Mon, 29 Jun 2026 19:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A6D6B00BA; Mon, 29 Jun 2026 19:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C12E66B00B7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:42:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30D041666EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:42:28 +0000 (UTC)
X-FDA: 84934576776.26.6F0CCBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DCBF40003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:42:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pqMC9wV/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782776546;
	b=nrhaLF/6pYtMUKM1OvA/S+TSeNHlXIO3eWMb8gpCq8yxee9ktRAgIyA6M30dVNcnRSbeY1
	hlCUEgfn/6hTigrBhzsgsu3SURHZ5ujTaSP6iKTjyleQysZhZxxCjrK2Cr7bxjwAAym81d
	LncuA1KV9IvGsAG4Yn5DPHu/PKk1oeM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782776546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvOP6KyTa1cQF7RqDicaH/PT+XmQi8wUo+CgFxHTDUk=;
	b=qzFe1H3JWK/c+Q9qNtbi42Yr6F/AyAfHpTVN/3e2MWAM+9IcCMK46xE1PVOXsJALGW+Nfz
	d4vVwLFYJEmlw84c7Hz2gWCIoWPXk8RJaC8p1VVXYLM5PLZlwNa+1CxPuj0wxrAkrdxh76
	BnNDhGBhjYSkx0+2OFbik/kOqvnNmH8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pqMC9wV/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E61243D04;
	Mon, 29 Jun 2026 23:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51601F000E9;
	Mon, 29 Jun 2026 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782776545;
	bh=LvOP6KyTa1cQF7RqDicaH/PT+XmQi8wUo+CgFxHTDUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pqMC9wV/3Vm7XRL0AP/0vXNIhfNVVwi+hiUC33rtZT0VnJByFxdPl7sGZ85pHKE1f
	 sbDErgIokbNUmPq92rH1vgCFRAbBzT8ZHcmxazXBAwc+YjbN2suKMYexFXhYEWc83Z
	 2x8UPPTvrzQ6mQNwafNncEx7E1EXMK/Ad5WyaIMQ=
Date: Mon, 29 Jun 2026 16:42:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev
Subject: Re: [PATCH v7 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-Id: <20260629164224.ba45dc18cdef2848950631e4@linux-foundation.org>
In-Reply-To: <20260629103234.3240178-1-lihongfu@kylinos.cn>
References: <20260629103234.3240178-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DCBF40003
X-Rspam-User: 
X-Stat-Signature: ci7oxso75yxjfa86q5ybq6qh8kfpg4r9
X-HE-Tag: 1782776546-881509
X-HE-Meta: U2FsdGVkX19pNWES3zENR8eLoDg9QbhNheZRlHhwbjkV1cDcz9UdzaQv3UQNlhKTw+CkgXAs9uyeYFKCgepyENaqgvlizXY15Qc+2iZzOPXBuI1jmm2Qu5z/WdaVLhAvp/LC888P+EwHP2/x+iI+tDBxP98BfAZAzbdTcWTdldb3qn92xomnXjifYwR6f/bxzQ15PYigZdNaN/AjtoKlgdB9md2FV9a+AwbsFl7BBW8/7crKMlgu4/hNHAyYQSo76Jbg9Wb575e1/3eJ5zQHX8InSZSTNjaBetwrwLkOdPkgPVFtwSZc8F5/q2sXKwh6r9tg2Hu24iraHR9Us0hd1qq44InlpPsIBMsQhNCLAJKE8It8Uh3orJJBDlapVX3IFAQt++gjA+Jos1S4H0Y+mzMtseKLx52AM3ebMf9U8N/Auajl1aug/z0moKKEk0QSW2IMVdRW85j7Q0vmyqxKscX/fA3hsOac/GhPhL6tBb80Wmi9OZl7s7ON9TCXoVOVor3yYY+Bk5O58tAN5iCLdwAVbDyCmJd5/Rzmj1ypjEU7idaEPHrG2FmfIzQMbC4qWxjEgLWmEFSH5W0K8gZqolLQmgw2KGcxv/Uqft8wn2hzd6VftDeIb+ieKRLPSOHbT2L3xQpKsV/tsIdxeNV2XrE0DRAZDxkUEWyTkKv31D0lzB7d/32LNTbzAmW4EZhYYWGFVXHEmZGcSLKFK8/JDuj6U4u1xCwTrMY8MHWz7ldVVkN3pfsvXETL4X0oJGuAb9wTpSzTM0anPYM/W9kfMcGkFuR1O9lTtjUVs3/9mXIy2vqpMCn0PZpQcIMFghQ3O7FYbaw55d219wHrKa4zX0qKVA07T3xNR+14+OPS3fT3C7P2H2crC1EV/rwubKwaWi023F+0o0buVYpoUBKbhLx7prL4Zcd8b88hvT+J3BO22gMUZD5nkIRfQqQG+2YLUprBt2G28w8tCq8A6IJ
 ZsZdjIBa
 BvB1tNzNwgnKvJVGrwmyb4j448sIt8c/oGgv9IPYGueIXSQj8Wj1CicejOhmIv3znuNJp3XYF9FHx80+uKQaGCw+OEplm7hpsauuLwbtzmHL4a3gv2kAu9GUov3Zf5uT71a5b2pjv5QILbKorLum5OzFccfHC34Ss4d6i/wW+wdYJPPruFUZmlQZcVKUgHZU0OFK8kDwD3OVcuJ3WSBX4VP8fqnIc1LE/CbEezQNb2pYiitqhU9DJJZJa+XIYZFg+62MS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 18:32:29 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.

Thanks.

>
> ...
> 
>  tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
>  tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
>  .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
>  tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
>  tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
>  5 files changed, 141 insertions(+), 127 deletions(-)

Unfortunately MAINTAINERS and get_maintainer are often useless in
selftests.  In this case, I expect the people who wrote and work on the
pkey tests don't know that this patchset exists!

Poking around with git-blame or git-log
tools/testing/selftests/mm/pkey* will show who should be cc'ed.

So can I ask that you figure that out and send out a v8?

(Sashiko likes the patchset, btw)

