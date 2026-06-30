Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A19C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827C96B0106; Tue, 30 Jun 2026 05:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF846B0107; Tue, 30 Jun 2026 05:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D816B0108; Tue, 30 Jun 2026 05:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 481BE6B0106
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:23:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBBB61C332A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:23:04 +0000 (UTC)
X-FDA: 84936039888.01.8D98FC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29AC4160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:23:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b6h/m4OY";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811383;
	b=cG+2Jvo6sRZqO5G00sYFPo7KnU8gMXxcmDHRtYFWTfoRlAzvBmV7fdvy5Gep0MiGDh5TA8
	ylLzciY9QPZCNkz/nVyHpSBJyaKE4LqB57wmXZE78YZiDYdX6+xR+0QV9aUpIpG6WUWsR0
	zs1R7TQIYU1fGLJJ2oJKPePIxfa/0aE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdwm8I3YE+DnFwwl5cUNzE7lZIxBJZQXCTSM5z82LZs=;
	b=ueSoKjr5UvO8jWomnmDSr/7QIzWtLy+7edt+ywQ1m9L4IXVI7me/x+BdXmBP3pzd85GPQK
	HEYE8ex5OWfxbtf7JmKICWCaZvdW6P4ixIkPt/n5UJDmuJvLGrHHz9ceijICFuE9u0sldk
	b83O3Id7NTwHEKC+NpjTRbngNQDrIC8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b6h/m4OY";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 115E740E41;
	Tue, 30 Jun 2026 09:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37301F00A3A;
	Tue, 30 Jun 2026 09:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782811382;
	bh=wdwm8I3YE+DnFwwl5cUNzE7lZIxBJZQXCTSM5z82LZs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=b6h/m4OY6/t6gJjmh5PQSwzpR85KKZT+54iJ6Tdc7YHQk8EscQT9xVMoFKPeKNN4c
	 uGpWfQEkOfdqMj4IWlDv2mu6EyWwCwTxyMjnZi/iRst0rVXkpsoI7CdsUVgM8j9mm7
	 EOoRnO9Pip9KvRuuFZW1eK5Hw5bDDnNcCMtGhAaKO6ehmjM5v89fck6WcqkgvFJ210
	 yBApH1nY+nr5J8rlfn+wcYKMCx4GSZQcGdSTM+AI21O3G3wPSXuL7uVOerSfRSCjps
	 MRmInCiQWYX0OoIg+8KHwdNJk5yN0yzwZbStW1KICn2RpYQlASHVCAI4kWAJkKc5oj
	 9gtAVyULcZoNw==
From: Mike Rapoport <rppt@kernel.org>
To: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com, 
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yuan Liu <yuan1.liu@intel.com>
In-Reply-To: <20260622022403.16375-1-richard.weiyang@gmail.com>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-Id: <178281136320.625070.11348447938097081355.b4-ty@b4>
Date: Tue, 30 Jun 2026 12:22:43 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 29AC4160003
X-Rspam-User: 
X-Stat-Signature: m5dhezqhyfwpaixq93mqpuj5au464rd7
X-HE-Tag: 1782811383-222559
X-HE-Meta: U2FsdGVkX18GxZb1sU16+H7hAGzztThXW7GcsHhmjNW1as6Td4ZgWJHrBx5Huj/Rr1fHpbm5ihI1wGLZEKH1gZTWU8zNQqw1zyTZb+yC6pRxwKBf+qZGa6cNF/bCmgOGVRu9wFqLQKPhTxpqb36sf4XSSv8D+Dcc9xdynByWyuOmjNW4BqJRcLsFGXFJjFuID6ahvxxxMsPPW8Je35ghnnLK+X8ilR9VxDjoaQx3uMacBfNqAVNd7zwWO57i1v5e30KcmU60ef/DxDWh2GmIP9ou1I1SMFzRmyI0YPqrmw0QftDuodnGCkU4M5HuLT4Zti+LZ6luSq1jizfaPDoVdyfo0YVM1+r8wAZTYB/8F2Ga5iHcLYD15TTnPR3SjBz4y06cy9yh+Bm0AGgC4h6yMumFKbBigLT++k8RQ3uSRH49hiMWoU1a+JMg6B9O4npKwZe/c606QifBsDTOedUyaftr2JubdPbdHFsgziBfO4pfQljOW8cpUpbENNhukIIyluh8Q7nbjB3CZgaA9vU++vw3QpBrzf0N8r75mWIp+vRAQa8RHJVeJfr3LR0TFCjPHpsW0QuSPd26az8cebIMxDJkaOeq+IBcVIt65w/ToeT34uyVz4yTuFCFlgEtrl3l3ghXDHt5CmBAckFYKExbLVxQTmaPiIEWva1p+n5GD3Ca+QmSTsCgpQ9I5Vr/6BOt4Qi01jncKBJjTwTwSxj9TIS7Xerb1V96Wk2CW+jdPJoRx1ZqrpoVRWWXA7klKx3IA5mFuaukfz3JQStZPnHj1NfE7h7QEls7RXRkL1i44dmAQ0cYbR/b5g5oRsg9w3u1MUiRACZv952mPMRnmIFxS8IjsP7LK3IBcTjYqdzqwQY2sex/3J0kRs3GPCYn6jpGVeWu9f/lrNk5Ej3mZbpSwi935aIvTnN0pFac8h6WphsybZCvZutZIJmwQebV6ktLwakAm64OZfE1kWMBmdD
 uZwJYh3q
 NDZItOQGSsfosgGN+SQA+0ZBaCmc9s1Tk/x9Yk9SdUBTvnxoiyAojviF4O4WQ3hosU1grSYbHiRy9pprRROPc1xsDyzn7DGrQzeMuKllt1daEUmhjCofnRZdz7PjMlf0glwfIfXpuGr9GG8k1+Fp1Pgg7FvFMcneFZGOadH0SYL1+VS84r7A5w6SdDhgQM0v/gCyM+k1KSIl9siQSqXjkllOqt4chaEEz7JwfCvKwVrXCa/6jiYtNzOSgalmkQ+sdwva1ip2r8OoBq0UJtry3fSPG3ueNmGpbxdwSgsEyuHt6V8T13DHgWEWkIxaAhEh1E1tK308f+30UFLtQ/zjbDutMYLkIluVtk33V3AC7nBmABs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 02:24:03 +0000, Wei Yang wrote:
> mm/mm_init: fix incorrect node_spanned_pages

Applied to kernelcore-mirror branch of memblock.git tree, thanks!

[1/1] mm/mm_init: fix incorrect node_spanned_pages
      commit: 7783dcd79ae9c4aa48bc47bd4275772445dc4b2a

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: kernelcore-mirror

--
Sincerely yours,
Mike.



