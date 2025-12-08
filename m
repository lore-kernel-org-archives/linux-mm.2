Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EA2D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C376B0005; Mon,  8 Dec 2025 01:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BED26B0027; Mon,  8 Dec 2025 01:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F7F6B0028; Mon,  8 Dec 2025 01:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2167B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D99451A095C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:13 +0000 (UTC)
X-FDA: 84195329106.11.FA6D090
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 341288000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pATG9OqS;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175412; a=rsa-sha256;
	cv=none;
	b=rR/dgBuCgRly/mEPaIRA/p7SolOWL+28Ioxpyp5Rzu1vQrUwchcU8cxNk23x4KELjqQL65
	26CoLKZOHFbwPMSNvk1IETN6/c9CEC+m07C1CQRnlZh7m4wCjZdX9o6n3cRDPnKiTyt+qC
	SuOLTIWCyew0ezAt4MD1MP5qkydchbQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pATG9OqS;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zu737/4dDOLh8+sLcrhj7haeT7YfinocaOoI/IVjjpA=;
	b=5tJalbwqxOcLt3vMKxgbKVv4AR2MdvNbAlFUFpBzmf2v3FibTca+/6SlEZQ26jC742CrFf
	SobY7fu638p/B8iZgYjnXZyVghBrcXhKN1sXUg066C45i6Q98inqQYMnGIhIfngjuUSm6u
	OL6VEkeq9OW9NquYj7ry7aiMrAOymtg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6436740320;
	Mon,  8 Dec 2025 06:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA33C113D0;
	Mon,  8 Dec 2025 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175411;
	bh=55qSAyG5lbRxWMFpgyshAGzR1uB1VLHtbYjVj1MXVYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pATG9OqSqP99RXBWGY7fJfLyZtQHGWBxHulVCPM+ydODfXlD5TnhqK+S5lzerqbZp
	 ekZhX9dMxDZRFfUaHT5/AvN0sqkS6YKZcSOE0NvI5G68DU6bsdO/BIMidyCJY5f5uD
	 7Vk+6Q1+zj24SDQCehMBMTSI5cwHPpdF896WJoTaJl0qTwmmI0QgVvTKPuzlG2xCn0
	 ziYlMA33EZHcUSw0rkmrwUQHl+DvAYvJdYA1LgqQtpp7+g2Bk8Z30yh6aCrZ5aB4dQ
	 PxFDxYAGQxvIu08k+g0FHN14/31RkH8JClxSmy8if7CD2SAFIcNFLbMAxaYadwxx9A
	 H0blcK8k17xZw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 14/37] mm/damon/core: report access origin cpu of page faults
Date: Sun,  7 Dec 2025 22:29:18 -0800
Message-ID: <20251208062943.68824-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 341288000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gofsunnnae8fty6t89fuuxani74jp1g5
X-HE-Tag: 1765175411-431451
X-HE-Meta: U2FsdGVkX1/RsGuc+ztWTKt/0TiWauxJ1QaPpbdvCUDCm+6MkMFhSawNHIipg+Xqg5w/wXoxpwDmWMFZJR8tc/lo20dt5bWaw2lFDZsX6tpt+O1yVzs2QFT5CwxGpRtmIAclM9Ao2U1/MrihZXIl0p37hUD4DTQIM1yVCiF97ii3OweGfsWz7M/RR+n1PUX4YzK5M8A2AnqDCJWNDFvM0avULYVKsvjA0SOoEZyCyZGffIazcw+NGjDQDOPVQqKP6bVuDsZZUp5/SYzfop22GkZUDhTuU+X0TkFMw/ec7VsiSJ5MHXGvo2kYNWwPR81ZHHTpnRC+rx5bwXPNKd9EjdRqtKf9fxVqxzxgs0zfuNK2ZGaC+fzxb9y0cbFMJK5+9PO2lCG2JKtQAWBHXKIrp3x1Qb2TnMyUw4PjhGNGYvVh4JW5GunAVLR8PVZfDtdUdA87IFcGx2Tkcm2KjB7LpaqXTgC5FBuhLjD6PWjFX0kVa2vi3x4iH0yTr7kus6q+RkCPC7hwZE07qWM7e9k0M+SIBAbKwU3TUDkf3iUFiz8l1Gm+xwwYGvGhbJuxCNZwSaeC9Z4z4Uyu79LMvLGcdWQ7ZjWj4RxqD5eb9PsNo8E+AaUUHR2KFeqgB/E3SCITt9aiD7a+n1MeCX3UC32LGhQCCTCk5W3H1YyRlLw5RciKrMG77krsrj555t5mdHRxf98YGCKL6v4L+FaJE5jd+ylR/PC21jRgi2O8SIXzjkSs5Veyj+zJDe1l+RCHxDVsJ9QJGMaN93J0Dhn/WKTNvvp2RE2LZu4TuYm2/LPN7FR7zazwW3xXj6My8NLVKCiYvgn5VXG8L/pEQnAaggOkSqAQStRbk5RZAbIAKaPQW4Z7hLzmkXAY6a2ASGDOjl1/HWAX4NsKzmxAG6uypz3+v97rTWBbN6zTgkAp2hvMrPecJ9MkT+fngAvz4/rSZE1bYwb7S+zLldASaHwfu5P
 Kfz937Y8
 Gp3a52kDn8nHggbIwqhJrmqfSHfrqCt7TZi2137AX0ImOOvUp2mCy2GVh7xLx30vGCBw9PbHIsthm3ttfUlqXYzZqTM3XNHsRCJi4BliWVSBAuyGFLnWi+julPx98tUmGwZi73PCCNpo1JwUofuX/ctuobTlF/sYp+5q0e0OQ9NwwoBuOy2S0zP2x/kbPq0qu4tUqPqenN935+cME9V0nYfHzDOeupRnOFZTSBTfEJCE7hsAMZzFZcJag2auddsBIQhKT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CPU that executes the page fault event reporting function is the CPU
that made the access.  Report the origin CPU of the access.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a14754a47c7f..d2f842d8afd2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1585,6 +1585,7 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 {
 	struct damon_access_report access_report = {
 		.size = 1,	/* todo: set appripriately */
+		.cpu = smp_processor_id(),
 	};
 
 	if (huge_pmd)
-- 
2.47.3

