Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801DBC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C046B008A; Wed, 23 Sep 2026 13:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBED6B008C; Wed, 23 Sep 2026 13:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9F86B0095; Wed, 23 Sep 2026 13:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1856B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:20:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADA64A08CD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:20:07 +0000 (UTC)
X-FDA: 85245690054.16.F869E28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA04540004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:20:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9ikKe5M;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IKIebDSAi0EpVNQOnavA/xUruPOvaI5w9nTcWcEOKI=;
	b=69C5FJ7bhx+7tnSLI2flqbbrFRZF1FuXKBWncA4QEQ8t9/+DiABbhb4p2/1Li6NEyx1jxE
	QjTuNKfpmdvvIc9cKd6jrc/cL5UMYu7VLN7L+H2MkUs3bIAggppajj8p1gSBX9qxlRqb2B
	5pe8w3xp5b+tdfEAyGqJOD5x0t5/0iI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184006;
	b=JsFNnkm5rWHGg6j8bBR+uNZL9L8nvjBrCVhKGj6rEYwMKJ7Nws5mB0jDuKVBBCQ98oXJ/e
	xgGcgzMOs6nqneJVE3rTulY4vswz3c1YIciTd3sqnqrxYgm0b0oalDkw8l/VMu5K7seHj/
	aWd6y9cJqIGnHX/My+CUaYGkEVcMwwI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9ikKe5M;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 177184064C;
	Wed, 23 Sep 2026 17:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68F01F00893;
	Wed, 23 Sep 2026 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184005;
	bh=7IKIebDSAi0EpVNQOnavA/xUruPOvaI5w9nTcWcEOKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P9ikKe5M0p256JAWOmy5NpxEFMkd1pZJL5H1ErHaarxIVJt89Rx0Z7mrmEOcaP9bj
	 OP0r9+Bq0mAi5xwOgvsk5wy05AHM0WC1nypEPbID7g0sA05crXE/HQ9vlK7XDdQMEZ
	 nd0FhGT+RyLVFSLWdgoyRDFAYUgvnAo8n/uKLaQeY/xJYsV65hPL4y/AdCrV3Um6jF
	 Q2gZznSezWmB6iQv9Ig1af65X6giq/al/H788jIiLeAsh2jvtTLt8D9738g9Ci75xQ
	 n16q4pY8ss8GHXoozBP3AzV7JAlNULy4Emt0rLmlrUxBGssS8TTyDEptRGMYTr9v1b
	 mrDIOXVgEjj4Q==
Message-ID: <141d58e1-5663-482b-ab61-956f3b08081b@kernel.org>
Date: Wed, 23 Sep 2026 19:19:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260914155115.439742-1-gourry@gourry.net>
 <20260922130558.48402-1-lance.yang@linux.dev>
 <arMxm4ia5Md-Zt4R@gourry-fedora-PF4VCD3F>
 <80206444-d0c3-4dab-a5e3-a2909e58ea33@kernel.org>
 <arPut2xL8oU6Hr3F@gourry-fedora-PF4VCD3F>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arPut2xL8oU6Hr3F@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA04540004
X-Stat-Signature: yghck1ccciift8drry7k89czajdjh3fc
X-Rspam-User: 
X-HE-Tag: 1790184005-964537
X-HE-Meta: U2FsdGVkX1+odwGZ/My5xMOSFSbWhmbcsuKnc3mrbpA5GPneFy0TjQe+5y9DUplBwCUqdZJoshiHmnjeZwWI73tD477yxG1TZVLj2rSVy45g7RxTVRYg3MTC9oef1ZfbV7BKB9912k/a1lF1Fgfw7GWDp84I0PLkTBUVwSpuCtecVGs+jEo9NsihtVkNvJ3nfkeOuRtN1ZPPDqeTDN6qUTWTJ3euVqe7uK66diikzWCTCnbCOIkqsmBiGi6OYYX82Lh3iYGTkJ5qBCxaO8O0W/Y3qWKiMwvtR8Cfnu3bMvc6l+kdP/WpJdcbnKsq8ElNYZgQbSINK02Ym0PQMMflC6WeW77mPvNFPAQp2cnygiGcM5A7nO2jZjxPYx7ivcp25nTnlxh4E6Tf7d3u5wL0qyyfR8JeSmdErbMqq0oMS/tBWVPMlzV6mWDX2jFLQ+68xDydyxnKv4DzzsqYVQis453VBI7UutVqZUCi/+vnA5CHh0/cTIqVypiSwlZmE45RP4kZQH2MBBl3iTTcOOzautqU80BlV79hm3QjzJYn9lt4X9NWzJmHhFLMrWCsWl1J83gnHStLlm236z9/bpSe2w/41j+Y5ryCslnuKrViVzl5NbY/pEMLAqPiUYSiNNB9v4xRwy0Aj4YG9+2j6UFgRNCF/GprwzKFcMc+7BbEvWmcm/gLvdkrO8z5eD7hY1rTZ5TMKMJw+df5l5weA4PUw+1Fxj/sV4Ry9IGqau80iZoukxZs6malnytDxKRnzZZjhtNCAnXLgvbBIWM5FaZSwo/xfuJxwkLaTA0dErUaeS91XJy8Xk6WGGMY4LZFmzeAPFs+QEE1rXmgzeRCLNkKL4JqNmOBID5YBFp/eQkLV8pvZz11ark8rmYeBmCMGYSCbOT/fb8Q4sFu4lN3qQSejUjjmet1rCu3xohuCIiyhnkKVmOBkgzRhXXKxTDcjJ+1lc9kWC4zkQ4fVmEMQf1
 4CtzcIRs
 WHT5i2F7Ucj+FM8o8vurQnrrtBx4cRZibyJUcUMuAHzQbjwRURwoEh4FKHyO/+jqc+I4baxZ2W3eFLwyJ28GoNJZEPEFW3BIAfrQK8dFG+oHprKMfQGM9OFGXtyYlQXxeKfoUyWYh85MBf3cRL46FYdDyqayt5cpHJJEW0jJ+sDWGf/QZyqOz+SZ8f/4488+ImKOLQ/ZePQil1FFaR/szQ0W17caECp83YbAJUk8ybmkopfj73Z9oOBeMVJqkyoP5yhhIbD2gMoeGFRzg44XYyXWRJLqf2+h6Vvym+m9LGe6JG7D6I/NIu65bOWbgcEnjj4xj6+H8aF4fY5JUBBJa2LJTKsI8da2I0DIOC0ybXviWVB5g0r+OIv51htIAu4UEJQrk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 17:24, Gregory Price wrote:
> On Wed, Sep 23, 2026 at 08:32:29AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 9/23/26 03:59, Gregory Price wrote:
>> > On Tue, Sep 22, 2026 at 09:05:58PM +0800, Lance Yang wrote:
>> > 
>> > There is some concern around NOLOCK here yes, in fact sashiko picked
>> > this issue up and I've been poking at it.
>> 
>> It's possible to document it as unsupported, add a VM_WARN_ON_ONCE etc.
>> It's not necessary for bulk alloc to support ALLOC_NOLOCK just because it
>> takes flags. e.g. kmalloc_nolock() supports a subset of gfp flags as well.
>> 
> 
> It seemed simpler to just support it than to create more future
> footguns.  I can RFC my current rework if you like, i attempted
> to deduplicate the logic via a prepare_alloc_flags() called from
> both the bulk and non-bulk contexts.

Ok if it's simple enough, lets see :) Thanks

> But if we prefer the WARNs over adding the new semantics to the bulk
> allocator, that also doesn't seem unreasonable.
> 
> ~Gregory


