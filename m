Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68675E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFAF6B0096; Tue, 24 Feb 2026 06:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9868C6B0098; Tue, 24 Feb 2026 06:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD216B0099; Tue, 24 Feb 2026 06:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77AB46B0096
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:30:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29D938BD83
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:30:18 +0000 (UTC)
X-FDA: 84479131716.09.A2F5DF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5DE82160003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:30:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qdxfz4Kt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932616; a=rsa-sha256;
	cv=none;
	b=Yp4TRXgIoNpSBK+WwFI+Ijrz2Kt8n04/9CqGlpEMhctWoemWsbOGPJA1s8/Iy6JZDT//8E
	xEWnsh84DKdCdftWmBizfICSD7hBC7TC7+OmBtOn7sP2cLzOQPQOxhN32CXKOd8jmr7VRE
	5pzB/EUT9HyJ9KzYkyWEml/FPU+1Ojk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qdxfz4Kt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GB3+xBvOOg1l3yg98xJ8Y7Nymvj0lveP+lcH6I5dWqs=;
	b=uwL5HTiD/WakqC5H2OhDh2HplVXr6WO3dlZn0lhguHa50nQN8WlMUel1F36V/NuortEetD
	XjSHZkpzb4Ot6jsXmAb+qlDcLTPZsuIQBEp3Ab1wE4+mWquz3Hgm2BRX8u4dA0ZHVk2QuM
	ywmxeGueKKgYrH6XI6TgHe3t3R+Ci9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2736440749;
	Tue, 24 Feb 2026 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331E9C116D0;
	Tue, 24 Feb 2026 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771932615;
	bh=9ttI2emmKns4z1X5WxIR8b0sfR9NkHxRS1s9+gKFrYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qdxfz4Kt2XsF/0GMszHnzYd7guNZKIJ6BNgFV3yYQuLu3wxiUKTrn6LfIUc+7E7jj
	 OxG/VASRiWRNCP7s4RPLN40ME9/bKcMHa0THR0Cg6aiCCtU8tApbVBJQBDK9F75qi/
	 UR/AhqgAtlMks6jlkDXwY6lI5diHP0/ZtEWsVul93qpT4drAhAmdQRX0a/C4oExcAG
	 8hRjYUW2g0gN5Uv3SLLV+ocvEuJAahcwzwXlXjyMyIA2bkmMuULSJRPmdeS6f220kP
	 v+3AyKEwqqoZoPE4R1ub81xD2rvBSr+c+x2RUK3WbfUXux2PWIvkboqc/z/0vzSVkd
	 n3qVrsi9fZUpw==
Message-ID: <5e767065-5536-4b95-8a42-c4be5d31c77f@kernel.org>
Date: Tue, 24 Feb 2026 12:30:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback
 is available
Content-Language: en-US
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <20260223133322.16705-1-harry.yoo@oracle.com>
 <e4f3b873-7825-46e3-831c-d0f5d3761ce4@kernel.org>
 <aZyur67rmiOT9zY7@debian.local>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <aZyur67rmiOT9zY7@debian.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DE82160003
X-Stat-Signature: e7qy4oso4nns7mu1yrr9ny4xzfjgyb1r
X-HE-Tag: 1771932616-560247
X-HE-Meta: U2FsdGVkX19k43fi7fHMN5nUwahORv3yDvrNLfLoRhtVmltds8Gmy/OvcC/mapk+ze3PG4WoHbsbaM+SdtzSXakZsbzpDiVjN7PSzdX6WFI50t8Sn0oP/eSVGItJUd3v/5ehwFhhJWpqsK5pNZKPXACl6OoNC/UlTyhkRaQIh6ju7ehNrUo+U27IlLYEoxHkTHn2jflX8O6wZPBFPCRtisPMBWMQ54TR2pfw8OHCeTEskpvRKetDCTKrgy5TbStwKmEFTXLl/PccPdcifYEV/BcHirrnjVnscQ3GDtJXf1QE37wbyvpMJFj6F1jc0NiDwl5FbvVKFWxj5Xjp4sptwr5MlBqCf0MmI7zwwgh7AtTh3vaz3wQ4qtc8viEj6TnGFfqsh26aB3OvL2mt7Clv1ZVOgkpPiW87FYQnACwjZiLaN350eEZUZ0GsGxww1odK4EFhuyVr/ZSi6OfWBfdXHGgRHevshSWn/U/vJsWQ199to8TIGeL7iBJlTrynQfjzXoGL839BKZAiIJRa2e0axzlkd/MPTgcXQ4BN+e+LKmwj5sj3ttcZ+WM5vLoJLFzklhTPIGlK7JBp4I/hkS5GF6sd+TPKzeusqTCvt0qLc0ExyV3aEOgulJT0XlknPtY4Pw1WXkcDrQejgbOUFEHisej9BVyk5XKVDTWAPKybd2QbZUpBLLsw1o4jAqAnDPSpOcvokt+3kjSZtNQu2Z5qUzn7zPqnHiIywofdaf12x3lTBxzvwTeN0oXt9NiUod5xTJsSQXtHNQIPvJEknvAsChnfCohX0ED+Z0hm7RdOkN8WBSPhSPDLXmeY91qT9nPXKBxfL6V5zZKezRTKZCwLckyz1q22p0FM4Bsmh3YmQwoZmcBqb5YlbmG9GInfWNxEaOL5f3fSfE75c6Nv6R8qwuLj32t9Xju+VVKmrszx29kURS4c34J4i44yUGfOGOa/cbQ4r50oepLNxUw0Ful
 KpXYg63p
 Y6+JaunE3O9e+VQWI2F+deNYu9lqNF4zpWiJNyLjx9grJC21nS+RgaI6eV9kfo9xE6Cwc/ighyKRE42Edv3KiPXx35B/B6plnv54wFSGF6Aus/IUfNhtbDkdoc8YeTPVvlZccwq7nfG9I6qbhrMbd757tmcSZMhaZ/1jEvz7FREC/oFFDp/CnqCizmMZUn+Mgf7yvxAxyIfeVkNKkSs2a6zZQgRvK1AjxD6Ui2Qb2ofU0q8locdWJVb81LTYDfPuoib/b5bmtIbFgNNPfKc+YEV/CRpyVOstBhloRiSrgvSNfEcE3slAH2zYUqCYr1lWHpylVc4cJpGlxb99GV+9qA+NcN1voKwfVVLQfoYl34krIB4w6ihiEDKTnov3UaOn8K9VZsf4HqN+BrC3SEPZjjuSaixY53h+4E0B2fC+LIU50ikDcdfVShaHaDlP8eQ6Xgfob
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 20:46, Chris Bainbridge wrote:
> On Mon, Feb 23, 2026 at 05:48:25PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 2/23/26 14:33, Harry Yoo wrote:
>> > When refill_sheaf() is called, failing to refill the sheaf doesn't
>> > necessarily mean the allocation will fail because a fallback path
>> > might be available and serve the allocation request.
>> > 
>> > Suppress spurious warnings by passing __GFP_NOWARN along with
>> > __GFP_NOMEMALLOC whenever a fallback path is available.
>> > 
>> > When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
>> > the kernel always falls back to the slowpath (__slab_alloc_node()).
>> > For __prefill_sheaf_pfmemalloc(), the fallback path is available
>> > only when gfp_pfmemalloc_allowed() returns true.
>> > 
>> > Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
>> > Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
>> > Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
>> > Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
>> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> 
>> Thanks, added to slab/for-next-fixes.
>> Hopefully Chris can confirm it works (without adding the __NOWARN to btrfs code)
> 
> Yes, it works for my test case.

Great, can we add your Tested-by:  then?
Thanks!

