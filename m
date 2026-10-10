Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C930CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AFC6B008A; Sat, 10 Oct 2026 05:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBD76B008C; Sat, 10 Oct 2026 05:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB306B0092; Sat, 10 Oct 2026 05:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEC886B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:26:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B6CC1C41F3
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:26:59 +0000 (UTC)
X-FDA: 85306187358.14.ADA6F2E
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3005E140002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:26:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t7Q/9/Eu";
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791624417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAY8w7Fxx7vNlpu29MzUbSI64RqAfpQpHP0bChfSjTI=;
	b=0dha34xxtJtHDNVRichrZm5B6vgGtedEqp/AHZe/DiCYVduhlxpVznNtMmXwrJRoQZ+6NH
	mTrai8gBjhK7cXqxUwtoWqzGx5wvikOAU3AONVcMNPPX7HNQS0cXlL5F0YhKg5UvWhX6p7
	2SD7TIJ4rQhC9V5VgI5XuAyGCCKQ+V8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t7Q/9/Eu";
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791624417;
	b=12HbaVHgiKCMERnjSzwz674j+yhhvydu5E1GWVcKu7F1RvyV5+d1+xTA7KVAy5hPQ6IxRB
	Bcv7vXocLl4O0QDIKMOotQPGKRbZACu6oSXmc8SvemJg4ar+PtEwy+nQH4dUYsr1SLgQta
	XKvMxr5Ox7tN/6pb9ZCU0AhQaFOTva0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ec4Wn9bUxUfjLNTm9yldek+eQYXbe1h31j3QEEiJJPA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791624415; v=1; x=1792229215;
 b=t7Q/9/EukCc0c9RQtoTK85n2VfWBLEqNlAAz8kmpbU3/sA7Wgf4NzntsPzBuoNnWQTUIZKRV
 I20+LWoelv+Dl6lgYAQUloBy1oIqzKP30jRqlrRVPEiedmkWQNC1D5fDp729BiYpE1NfpLSlJo4
 5jxkdON+ZVGUQMqeIphg28cE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa378c6c1bb25917;
	Sat, 10 Oct 2026 09:26:55 +0000
X-Mizu-Trace-ID: fa378c6c1bb25917
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: prefix log messages via pr_fmt
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261010092333.137126-1-lienze@kylinos.cn>
Date: Sat, 10 Oct 2026 17:26:42 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 enze.li@gmx.com
Content-Transfer-Encoding: 7bit
Message-Id: <13D572FF-FADB-4C51-ADF8-0504D03CEF34@linux.dev>
References: <20261010092333.137126-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3005E140002
X-Rspam-User: 
X-Stat-Signature: dgek6ptryq9tsuxjiyfh9jm51dmxqssx
X-HE-Tag: 1791624416-437060
X-HE-Meta: U2FsdGVkX19NtipBzoscFBDO2qMulUooPi4BFuSW6gNoNRZy0SbCfazWZIAemsOuFYV7sBWcOwXEJc6ueQduQedjdDOGD7IMpM6F4RhOM0vil/0SYGaeOhF+bvK6Jt8aQVuLhKeP11cim2+2IdyRhRxsCC/jlOn+nhC8baWk9MrKvzLmEpeWqiy2Dzz+UUmqa/LfGvwq7w3NYQ4q+9mdgzfCzHbN1WqzNJI/FyFYa2qiXZw+t3OWCqhwyjnXRC/+9N/vziWjcZNCUtzjw/tEylWt3q9/R+CKNqZmgTVrj5VNKtXTttoNMefLlnpuHMxwfARty0ZsHIVuOLZ2PFmMzAu0PvYMM5ra8KmkoCeFLAnZfLlF3j22YyXB287P7o8LxYuLk4TYVQSabQz9ji3AiLfMb6oeC25piiSQPS9Txzk3IwY87T2gH16nfJwX+lR4Z+k/OdHoFu5IT3tmL2B1Siot54p0Gjxmkt3Ma+zQcD1Psv8qqwM/7HSbYorPsYFBjcnGzJKoGCvGFZppzCPF5P6f9FDA93h9XATrptk+atdF/+p/xl1qWo2sojsDZKFP44SBVhOE6ie1K2Ik4Ogeb0i9Ji8qYW6J0UCky+o5Q7NeiMPNtiEuj7ZWswqFjGQHOvmK/cbMOtjfpCbHcYSVNCGjgmFtVKm+TvdeE8V+bP/4xlUa4tSdK6n2a637+WK3zVMnSioovMHQxVrxRJ1rA3MzPQf6/bsaQi72IHmbsqRgPueS97fyVOflXy2AtMVdBTIE87I6QL4pU6E+xNpN08CIPzfSoqp3BlSNk7nGNYw5pXPgWALwsHuNGFIdONc/rsHP3ocexg7ttw0/ANXuIUg/J/DpavfOvJYEz7pB/w+Rye3D7YVsk4zBQA84MCZJYacN1GzK7+0iGBSFoEEEPXvAc1R6w0pL9lj9slwZ000uKnYDmjXhF/5Xtq4bKq/0PRwIKIeS+zO7whmcI4Q
 w8SZ/T6c
 mSVCBbAvyuEzM0N6rbSnsyNwx1AAPlP7hufH7f2z4ea1AEj3GcDnlqUF4dzNaUFH6RauRms3xjOz/ObG4pJq2aSU7DS2iFCgEJ9FeQgQ6Mg8x2KO/uikit79YFIp43NX5ISWuZ2asD4fykGiJc9EaODCaRvB9jHOxbC2BlI0Pz/czKpTfu6xx66xoEF2vzN5epT7+Q+3gr529uoArCVbUb6Co6v7jhAnFy0m+Td+/mTtp6fBumLnM3jMDY5jA4YAyvVkNNK1x69xR75B4OLcl1ashq+jP02HC68/QCNvF8d0V1dyAxWMmOIpHNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 17:23, Enze Li <lienze@kylinos.cn> wrote:
> 
> Pretty much every pr_* message in this file starts with "HugeTLB: ",
> typed out by hand, and one of them even drifted to lowercase ("hugetlb:").
> hugetlb_vmemmap.c already handles this with pr_fmt, so let's do the same
> here instead of repeating the prefix over and over.
> 
> The output stays the same for almost everything; the only tweaks are that
> the lowercase message now matches the others, and the ratelimited "killed
> due to inadequate hugepage pool" warning picks up the prefix like
> everything else.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

I wanted to do this a long time ago, but I never got around to it.
Thanks for your work.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

