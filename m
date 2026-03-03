Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFDDEB3641
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C290C6B00DE; Mon,  2 Mar 2026 20:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6A66B00DF; Mon,  2 Mar 2026 20:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE28C6B00E2; Mon,  2 Mar 2026 20:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAEF6B00DE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:00:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5699160462
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:26 +0000 (UTC)
X-FDA: 84502946052.08.64DD7C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A90880017
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwvIRh2Z;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772499625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Yhcac/MzAUOnVIy3bKFVKRUQk8NTp+5KiTR74RH6Lc=;
	b=FQOXTjij5Mgo+FOiDGiUGiG3/pHzjA+/OB77y+1skfMmDUZIUnnXFG3sPRWVSyKtWbVuLN
	4pgRhYwcoqxnTRYxAQJf4wBMXJWJ2gkSY2VFkg2Q1QCJwQLbD3/Yn6We5C07jiA97G+pdT
	f/fKpU4PhAoCCwd8V8DOAwo+jIPIYdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772499625; a=rsa-sha256;
	cv=none;
	b=ijAeKkPfUuatx96CaDsfiFYrtQ52jdbQFpOzN72xV9beon+VY1zLY1NuAhhcNJXw4gLiCj
	DJlii728HZVtPAqNDi6D6mwbvp4BEE/kWjf4GlGbUwxXY9e498AVFaVA9E74huvgFHmZrx
	Lvlj2makxsZao9zpvSAvbdrZiU9WV+s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwvIRh2Z;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E94314165C;
	Tue,  3 Mar 2026 01:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F7C19423;
	Tue,  3 Mar 2026 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772499623;
	bh=FA9Xb4lwQEivGfXmRhfKeEEjDtqIKvBgLykyMymt25g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwvIRh2Zzbkxr4iz1e9JdpWa/bCw6vZKiSn/aop/rHB9kDNlERFW+KN1910UyNfqC
	 KjpodO1CuHKKpxDQWiAbopuyYiKe2IjjzqM44IstGWybGDu7rym87iIPd5a8UZp4tQ
	 uhxmeo4LyPD/97UMkxT+2nat0zl4HbJ6YRnN0bJOlctcz8gc4ctaMAfmOrnNAofnE1
	 Fgdfrkm1/6NTy8fRXu6B/Gw7cIOhgnePMMaflW07THvjuQpHnpjTRJyg3Mc+618UvV
	 pcpS0JzhR7/v0b5KDa3LKApJKCH7pC31liCRQy5FHhc8aP7vhzf+B4tAWSSJab1zcG
	 +egSCObRte0xw==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Harry Yoo <harry.yoo@oracle.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
Date: Mon,  2 Mar 2026 17:00:15 -0800
Message-ID: <20260303010016.82003-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302101345.36713-2-vbabka@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbi7g6bioiob8ymt4arzw979sjj8g9ed
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A90880017
X-Rspamd-Server: rspam12
X-HE-Tag: 1772499625-347417
X-HE-Meta: U2FsdGVkX1/IBw7mQEcmHpcxh5qDm4fv4uD1xpiaQjGeT+HdgrFzoTLw8vHvVK5S/Q6YO+ZFLzL71GgXWHcn0IWn2Kkc22Joe4iB+AYJoVVJA725xYC06GDr0cFRl3DEcnELCfWtKfUkVrkNLo3saeD66sGDV4tEObwh55on0mUlceE5OR/0GJ3X7kpubf0syNC9L1aLNHHqvZ5I36oJTjWa/ak09feE7L1bRoIJHH3zZwjxcWI9AofW3/Rsr97ixupq+xZ8Y0MVKWv7mzwcJeRMS0ZgQb5VMiFAlx7EcyIs5VXwZArfaFq8T5xbeRNntLlFmFHuLWwMxK/vU3NENi6/IqfBr4tE2lx0A/cywokdAu3JmPN9G4u4PtK57SB9RfsVrmHv1Eeqxi2lTytN/0b4mRZ/S3EQ31cQR4n9ym2qrzy+ocNcqEdcq35mtaTDXiyRGjOz3r7PzY0qCJ2gmmE9ez2OeURaPagjM/GKfpn5sWoCHxffc+EYSm8/au8BYqe6x77DUFoN3YrIODoRSR5dJ/gzAfwfI4wY2t8YU0wRXvv2lqDJaHWEc9EXlwN78Jq3kd4YARmMSNWWqUUI1NahijWu/9EndplQ0AKKe7/InsAK1zn2O0uH0sOdNfMDZH6bfpqKL1yAJiUoDXggTRp2hIvsbtXczId/AehMovPNPONVDdyL+8PLj+zyEMEeQAfckzZgEPkE7XRaUnGJ1baAONBXRTNPsMZ2J8BPpKTDFdqlndMGxLQ7zdcGjLvVytzIAcp49jsZiw6TSbUzhfRE7GPkcvHMIq4v+hsV6Vil/wJJ/BdBB4QPYTCGHqWvEBIupBzUUgl7I5Cxtu7SUGNgDTmllC8cjnZPbopIKm/MYbKRjP6v9iLEBZwX3+N7xfFnoTEo3PO/4A1rdB37mYxVYP2btY/XOABhd06qpN8kfFeFH3rs1R7hBXAXt06ApgtWkXPrQNlYm17GxSk
 sUu1cjYq
 HOz9S0QM0Q2bKM7qHbW5IQiCzsRtVd6D0WVMO5BT8g3hcbAXzGs6tJgtqSVAvGJ/eY8NlaUHCLthNpEh9ISTiSDOGmAZjW8vz7DylqOXp6N8Xnzd1Hbd0J/IHqwjhLwiWnxY565cbfMwl9/90qX2hT7x0ErMwFAq1DDIHiEy8N0qFBN96G0Dul4RqaZWU2OKMr0y2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  2 Mar 2026 11:13:46 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
> slab development for multiple years now and doing a great job.
> 
> Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
> a while now, so make it official and ensure the Cc's.

I cannot agree more about the fact that Harry and Hao are making great
contributions and deserve the roles.

> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

