Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16750E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592966B0005; Fri,  3 Apr 2026 13:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5444A6B0088; Fri,  3 Apr 2026 13:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459116B008A; Fri,  3 Apr 2026 13:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360986B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:37:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DADB358751
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:37:19 +0000 (UTC)
X-FDA: 84617950998.01.16A52C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1103CC0009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:37:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y5uKcWX8;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775237838; a=rsa-sha256;
	cv=none;
	b=c3TXjjMVdCBAA7pYhN1886AAMmr8KPda/AyBMsSLlcre4Z4QBXFD00C/1H5IDN7JeC284f
	pjVp3E06FzTCwICuKcWn5sxbubwxA1Q/0QCgRLsN0XTf9wFraRBGJSN7OmT3A9IM+o1pF1
	mgw18vXWgpGqn6oyttaC56e6ojP5+Ac=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y5uKcWX8;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775237838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMbGsk3aiSwf9BcnYUM5SHLF1aoyNT+cDGWTQXA6fcI=;
	b=LT+CHmafv4gf9cXdH3I+mnkcRNbjcDQGzIebtOcW0Ik3uWW9LIqcWYD+S4Aiz3RCSsqfpt
	S/++h2PliOOaXFFSP8nye8K07mzfh1tQLjw8X+RgeMzQHsYOF8EXF8E+ggWGbX13uH5xV/
	SPyRFHUMKpTPL421eVnGU2A3FFV54WU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1642B43C3F;
	Fri,  3 Apr 2026 17:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617ABC19421;
	Fri,  3 Apr 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237836;
	bh=5wivT/1CHuKGSFxPIsOl2/Bj9TfQNtwwD7V/KfbZO9U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=y5uKcWX8kD48kqz0cp/5ZVIWIwf5/lCY5Yp+T4vXaP15g2yMe9Vj3qPLTqkUoyvV2
	 XiLcCOnVhZT6oCoXdQncRVCdxKx7QqFb+7xqG2PSIvdEQm9F0M7d7IJFu1gCZczzth
	 gxVOv1zcI6j6rUJeawSxa5WCeXllxWeYr8clXsPE=
Date: Fri, 3 Apr 2026 10:37:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com, shuah@kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 0/2] fix MAP_DROPPABLE not supported errno
Message-Id: <20260403103715.0f61fa1d0991a90d85bedaf5@linux-foundation.org>
In-Reply-To: <20260402235933.10588-1-anthony.yznaga@oracle.com>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aspm9umrd7zdmet754ygpqqwtqoq6ca8
X-Rspamd-Queue-Id: 1103CC0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775237837-204282
X-HE-Meta: U2FsdGVkX19YOs5kRPfpq4/tPx64XDKan2G+xfYzTEyckRukmo3GSd5mxNAgw//xiWHQyWcLY3m8OQMuIn+/wKMAnPz5RmRcpElF5rJOM4DK+0jcSex8FWbgO+ENnvbEQZZoVq+E8bv5Fpzo+rAP5sB5kKgjtZum6EFstAFZP9ufn94rmpA8eb3Fc8C56u+HDIAV57KyeRt7N+HZRajiwkj9uYAL/+gbSE7WhQ7cA0RKJ3jobtPysdpAq5G/N3N6Q9/BFZEU9KxPHboslc2f10Wqn2hR7IdMEpx4dGBmDnK4tmOWKdSjxnFWeLG9cnkui40Mknzy2u7dzni9QoL8393+jr3qGNlc/SOn3kkmqjP4nr2nZlkRknKwTX+liK3wNeYBDUL3F1wzAKnNe+AtwiqDbC3Wl+0cqj/rnobzKMBmcj2QrXysP4tVwBM6eF8QFrcuS6QVsjsYvNx3hEJSf03oXmfa0PAYO0276tOoyqeLc8mXILEzoE0+Zn0dY/wp5hBvPFRJXYc9/DUF3bsanRlgbPbceuUtzVATqKb2PHLLqBoNj2pLi6+gQLxCCiKXW7woynt6Q/AQC2Zo2MIx+aLCf640AoCSKabf/R1DEGkz0SrzI5+soMyN7LLppymchgd9KDJ1LyLXhz5hS/Lx4tO3pf1vhatriv+VugNEKyZbayPtFxPVOPauucyrchaVgmdvoOQcEKoH2n1c0jtjy15g5JtIkLKhj1yKetHnAZ5x+YX3xCxs4H+Q0u5jh+t3nXi3ZH+k/4zEM5/p4YtWFB9Do8qpE3/TelWnWhgIvftjANM3VIFjz2eQCiuGYyUJH4Ihr8laG0Tvlye7k3OfaQJu9efYVSaxnaPZHeIIfqCT6sJluE3d+W2AP3LVfNv2pwQOf6en0faONL0qMebSqMLdcxdJ4l2AogmdPOQXI4O3yPLvK7YiZbEgcEC+NsjlHGwZsulllD71k/0zhtA
 0nrS2oOT
 Mc1xeUAthDZ6ueYrF1psA8qZeNMk0DqPiGZotJvYJmz1g5WTrAC9NjLRE/VaqRLogZAmVV8kBlYm5Rg/FrChytta8DnOwMd5cnM0/MU75OtCkuLLTNRO+/Y9VqtmhdoFaByucLwA5hIoKH8q+pXiVbNjtY6UGZE4+a5lYqdwG+3lpKbkvQj2PywCzg48afli7SN5gBkBLCoN5rqqx4PStEhZ2cmqqTUuq1ppbO+8VLBNXEgCDtayVf3NPCfx6sguHVFeFEoGiSy1MYfT2Ew924BDR5vED72BExnQtx1CO0NxEBFOYOmt43sQDpkjvXraEXbW5ZY5Mhe2G+gbsUXRZhx5tPXbziZ7T9EqfFq/zd1tB70QMmB0KIyM71A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 16:59:31 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> Mark Brown reported seeing a regression in -next on 32 bit arm with the
> mlock selftests. Before exiting and marking the tests failed, the following
> message was logged after an attempt to create a MAP_DROPPABLE mapping:
> 
> Bail out! mmap error: Unknown error 524
> 
> It turns out error 524 is ENOTSUPP which is an error that userspace is not
> supposed to see, but it indicates in this instance that MAP_DROPPABLE is
> not supported.
> 
> The first patch changes the errno returned to EOPNOTSUPP. The second patch
> is a second version of a prior patch to introduce selftests to verify
> locking behavior with droppable mappings with the additonal change to skip
> the tests when MAP_DROPPABLE is not supported.

Thanks, I updated mm.git's mm-unstable branch to this version.

In [1/2] I added Mark's Reported.by:.  We had David's Acked-by: on v1's
[1/2] patch so I reinstated that.



