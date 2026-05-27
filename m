Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB077CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189EB6B0088; Wed, 27 May 2026 16:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123B46B008A; Wed, 27 May 2026 16:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038296B008C; Wed, 27 May 2026 16:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4B376B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:39:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2EE01C05BD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:39:30 +0000 (UTC)
X-FDA: 84814365300.27.1A541A7
Received: from quickstop.soohrt.org (soohrt.org [85.131.130.220])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA96B40016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:39:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of kdesler@soohrt.org designates 85.131.130.220 as permitted sender) smtp.mailfrom=kdesler@soohrt.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2DCwz+S84pYPE9X9oC9MRXrolGSMvUEwVSw9GBoYXYI=;
	b=70uw+viffvRk7Ny8ObwanJRvrUcYJHSmT8H1KMnxzP9nyeduf0AuvK284TamlvHSrdYS2E
	Rk2AE/BciDf3XZ0FL4Hdcxabk/qN4oLeYFKPeq++aqJkI6wjd8+lX2JZQ9JBNdQYG9M8Cg
	GtR8cPXZTsljVNAZBOz6icNSLXJ0lo8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kdesler@soohrt.org designates 85.131.130.220 as permitted sender) smtp.mailfrom=kdesler@soohrt.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914369; a=rsa-sha256;
	cv=none;
	b=D45Sm72jwv4m1bAfCYV1a1OttTHkzf6Xr72Hwejan83BRZv5qVPfMoP+Eh+rTyaHI15Dv8
	RpmTI1971Bleqb6UG8QHMT2mPLGbVDUqAG/g5pN+d2+l0N9VsOt+YGQEbmaiWoPRNorm+m
	QAUIL+ZtJT+6WNuBgIfASuJR+0wMdhg=
Received: (qmail 28582 invoked by uid 1000); 27 May 2026 20:39:26 -0000
Date: Wed, 27 May 2026 22:39:26 +0200
From: Karsten Desler <kdesler@soohrt.org>
To: "Oscar Salvador \(SUSE\)" <osalvador@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
  Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
  "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <20260527203926.GP31091@soohrt.org>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ahc31AChKqnfItHW@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA96B40016
X-Stat-Signature: tmu1aad8r34eb51bmuhpc1dxip1hxpgb
X-HE-Tag: 1779914368-413274
X-HE-Meta: U2FsdGVkX18oLHvM2PES7MrNpO/yrkdeyD69Lp9T8DEM5zFd7uhv1LIzLIuZV2qBhnN/OXEIIlCZURwesKvVBAIwwUZph+nzTlvPfz1htOAs+35JJTZYasyvsuQhxN2t2g0mEKO8g3iuOovN4JzA2QZ1a10w34KUsHKZZbWvyMwL/FwG0wRxqFK4C9VI4/L1jc44CQ4n4bHahLGfqrXPnFzG1TxcrYk681QltILhhZrjMBdqnFHCR+qmt2YFczcc+besxGvpYS1MubIrWXz80Qrwxu4BfsKSI56+5yFLBUlz5sQmO9Yq3Iz6ky6AbRvtX3+MQuG5KIbIoBm78Ba8Bd4bUP/VgAV6l1LLsOLRwTNj7SwTHGBC+hh/6Xx/0ZvLYtMyY7DsvBN5SsDvf/p1UDIjtcHee+ij0vwAYL4FZhF7EsmtWe0U0J0EKykRPO/E1kU38SWatxpN1djWDOBS8q9jPcOK1midYpSUPsKpqF0wKMOnK4yLNTskcuwhOxkqP4Z9zsU39p3aC30qUC4EhZUBf88J+djDT7I9wUh31BKkD3ByRONgVccJsd9ItyzaZYDdIXAroPjiocOL4ZJzOMSj9J45EnqKYRsdRIpu6yn/N9GU6KnaHkl2C/D2FvqWUeVeaID1J7xI7fvdfU7DHpNTtUNMbBFWv+ralFNCEVf6xzsPEtYXPSCdjT6M90LYztoNG1GVeceF4+7lSeR+MJZPjl1toGiazuAnUCwUJqDxfEpMHu50Jenph8SpsD9nTBEBuuAUlZ0iABk+ndTYft/GcGJZITWmw1JDCeIgbf6K/5tRntfhn78NvwkrdObRfmyxVu0WZ5NOTgSZERCqDMF00wiXzuItrVF+7VjgG1pFTdzBBb2KdTiDompxWpnel+tQUmdZ6Zex1MRw+k53RKlCNIyof5FohV7QYj8KbAN94nt8m/OS5SfB53/iQE7hD0gvBqzJnNq7PKFlIZZ
 wFz18XPR
 0nfwoc9ver63n4jZ84Y6kOqn23CSXfuJs1+pQ1D6S/X6BXR+chkAFebiKLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Oscar Salvador (SUSE) wrote:
> Maybe this? Can you give it a shot?

Thanks, applied and tested across 5 reboots.
All mmaps return properly aligned hugepages, don't cause kernelBUGs
on exit and show the expected munmap behavior.

mmap(NULL, 1229824, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE|MAP_HUGETLB, -1, 0) = 0x7f7e49a00000
munmap(0x7f7e49a00000, 1229824)         = -1 EINVAL (Invalid argument)
munmap(0x7f7e49a00000, 2097152)         = 0

Best regards,
 Karsten

