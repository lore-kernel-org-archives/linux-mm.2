Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118E6C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F8F6B009E; Thu, 24 Sep 2026 09:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009DD6B00A0; Thu, 24 Sep 2026 09:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A426B00A2; Thu, 24 Sep 2026 09:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB80D6B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:26:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F4D6C0359
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:26:31 +0000 (UTC)
X-FDA: 85248730182.04.8A4A500
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA6D38000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:26:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXoEyJpb;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790256389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjlo8XBtE9TxB1LKTX/vUG/maDWdF6slESEL4axLxF0=;
	b=yjETWIgdMSaV/1/TdR4M/+e49O0rKBj9U5/+n/YaMzp9aOCHOlKzt9sD7aRtF6w3v43Nq3
	Nuel87KqXNo7HKZowNfCq1Onb0vdZcLIUmueApFFEeO9e2cXeS3oZTFrYS3E/zV2PuIOR0
	i1kIzcc/XQ1sN8GOXgHeePX6xCkvIIw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXoEyJpb;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790256389;
	b=aH1cfkxXF+06Ib8u7r3Y/HhwFdB2Er2aWwhcIg6TvN2EHA7dl4AxJ1GlX84X8gWz/KEdao
	fIOVBltFAgymvHHI5H/txpCMJiSgUgWUPNakFbdUj0SdbdPm80FyeMJ1S/+5qySyERjfIT
	Xh0eru6vKGgBLAMfxZQIkzhPSZlVA+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFA2F601FE;
	Thu, 24 Sep 2026 13:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15541F000FF;
	Thu, 24 Sep 2026 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790256388;
	bh=kjlo8XBtE9TxB1LKTX/vUG/maDWdF6slESEL4axLxF0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EXoEyJpbObkYPw/DP1BT2piCT31gRKuurm0smBCDhbkQwG4a2mfShKuql3FVVLIjm
	 +yA/famYpOLn89tGaZGE+MzXDC1ESpo5SncCDOsPksbiM3Bvm3pVL55WPEW2ZEFrTS
	 PJe6teyjuYG0jkQsqYCFIhZon1XF4icI4W44CDhYIwY7CHPbsaGFygYPIsCv8RvtW8
	 8HlnJpEghYdF0tIp4r24+iUYmRjjr/Np/xzuf8gTk6o+gyERUXhEtTdy9J/qN7F7hr
	 tbZlHPvZtTXvrpoq1AhVWxM6YNeYJTZ9D0iFATWWZqb8GNhSvZp7In4Qz+IfdXphnC
	 ffIWYWAo54S0A==
From: Pratyush Yadav <pratyush@kernel.org>
To: sashiko-bot@kernel.org
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>,  "Andrew Morton"
 <akpm@linux-foundation.org>,  "Samiullah Khawaja" <skhawaja@google.com>,
  "Pratyush Yadav" <pratyush@kernel.org>,  "David Hildenbrand"
 <david@kernel.org>,  "Alexander Graf" <graf@amazon.com>,  "Baolin Wang"
 <baolin.wang@linux.alibaba.com>,  "Mike Rapoport" <rppt@kernel.org>,
  "David Matlack" <dmatlack@google.com>,  "Hugh Dickins"
 <hughd@google.com>,  "Lorenzo Stoakes" <ljs@kernel.org>,
  sashiko-reviews@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] liveupdate: luo_file: look up outgoing tokens
 by id
In-Reply-To: <20260923225550.32AC21F00898@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Wed, 23 Sep 2026 22:55:49 +0000")
References: <20260923224408.3745689-1-pratyush@kernel.org>
	<20260923224408.3745689-2-pratyush@kernel.org>
	<20260923225550.32AC21F00898@smtp.kernel.org>
Date: Thu, 24 Sep 2026 15:26:24 +0200
Message-ID: <2vxzwlsa4w73.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA6D38000C
X-Stat-Signature: pc98fogqed6w1gjdj4ywenrn1png9bh4
X-Rspam-User: 
X-HE-Tag: 1790256389-638177
X-HE-Meta: U2FsdGVkX19ev0g5qzUW3QoiKZp6rS0XrLB81dEKKeNeNXs7vg9IMcEOWCJDhmu4AelXlJWnU55sdX5NkeEoGJaWLcfVcuzLL9attYVQNWeM+c7XgMw4IyEzXmrVyMKR1QMk7AyVHrQ6Cbig5uxL9vG8PFNoEObng4bhokE/N5XampXcR4lgdz1sQZF8kOCGkob5OK/hz5zdelsuLZZbHi8IZMYmVxCyEMNXSOoWYuVxfwTw/PISBrbWzGk3fUI1oqVUEOjHy66v/LMZbvkW+F4hTVhv76PEHOD1t0GsFEmpjUt+ctkKQndeFZ+J4Y7bMIoiG65oKZJ9v8xVivNXQ46bLGmGt0+HQSQfH3nxQaS0uJQh7W9AB7aoOpqCPQIpClbaaun/WbqvazZR8U0P/H2Rf1u6A4f498I5XscWvbahM6EYq41IreTJx6yuR6EsvSeOclrCR8v8//8n4xZWU9RnKioNhCYXGtPKX4Qh+/Zmg23W+EXDcBlgy4JsXe6IooHBM7JzR7Dte2BGuc3Q6eLNI+RKtfCPGxNWYrTjhYdk5L2c9Vt5VMsqAoSjRl2J7vh8PserjAGCxc50Y26Yxw8yIKsjFWyIjTjwd8XMwXvjxfAw7jMmtAXcqtL6lTjpQtalMl78dxcQcndPjsaHCl8ZCff4sLYAcXzbc59W7w+ZGkq54YD4/MVb1Z+qF0H03NiHa7dFRwNX/Uo1OSUkXDDa1Z6Krk+De6b0TzHz60m0z+vQYHooY18GpcHRWsa901jXqoCXanxS+rjsy6xuUB9ruBHxbnvwIaC4v0nbME206jph/5Rg1GJ4y2evIiHJf9ijMIf8dLLfhyvqyG+G27je6YCs1OurXcnBGbykIbNSpt0JFmduW2qsmfKFfYKnAYa5RM6XB2AXcYwRfCoaFwsdFOl2Splzw7FKg+ui7F2+d/3zt7efPOSc2OEBzZ8vV1OTeAFxVvzvJmRAQxj
 tNvdhrCM
 hA+eY0mTBnc6s/dSDWJUYIu+BVUmAiHJS+m1ln139QT62QxUH6xQ1cikTrSJjkRJ8r40JXVUqaFO6lpdcAxesXA/jNyppn/0AT/IhpxRpPdwRwIUMOzNaWwVFTajhYBz4mi5i7G8HX5vApxOzq9pKpYdG31CSINFf9b/L/cPB0GiGhCO+LFBRVxoKXVbRhffjQV9oMc7o8s8M/euzg/85F+BUg0V1b8KxiRCEARCdfkTCQ6X3V0W063OzLqi/cUzjDfMBp7vxz3g+WD1pgDEkTcwfT6MTgoj3uQMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] liveupdate: NULL pointer dereference in liveupdate_get_token_outgoing() on incoming sessions
> - [Medium] liveupdate: flat ID namespace in liveupdate_get_token_outgoing() risks cross-handler collisions
> - [Low] liveupdate: O(N) indirect function calls in liveupdate_get_token_outgoing() list traversal
> --

Let me reply to Sashiko for this patch since I think we should take this
regardless of where this series goes. I think struct file is the wrong
primitive for liveupdate_get_token_outgoing().

I'll ignore Sashiko on other patches. It does raise some good points,
but code correctness isn't the main point of the series. I'll fix them
up on the main posting if we agree to go in this direction.

>
> commit 17b042e4901cfc25a86dec1038092fbe1eb5d060
> Author: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> liveupdate: luo_file: look up outgoing tokens by id
>
> liveupdate_get_token_outgoing() is used to look up tokens of dependencies.
> It does the search based on struct file. LUO provides file handlers a
> get_id callback that can return the unique identifier of a resource. This
> patch uses ID to look up dependencies in liveupdate_get_token_outgoing()
> instead of struct file.
>
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index a39992da504fb..51817d202ce26 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
> [ ... ]
>>  int liveupdate_get_token_outgoing(struct liveupdate_session *s,
>> -				  struct file *file, u64 *tokenp)
>> +				  unsigned long id, u64 *tokenp)
>
> [Severity: Medium]
> Will this flat ID namespace risk cross-handler collisions?
>
> Because liveupdate_get_token_outgoing() searches across all preserved files
> using just an unsigned long id, it loses the context of which file handler
> the ID belongs to.
>
> If different handlers use overlapping namespaces, such as IDR indices or
> pointers that might alias depending on object lifetime, a lookup intended
> for one handler's object could incorrectly match an object from a different
> handler that happens to appear earlier in the list.

The IDs are supposed to be unique in the whole session. That's the whole
point of the ID mechanism. If handlers use overlapping IDs, the handlers
are broken and should be fixed.

>
> Could the API require the expected file handler context to scope the search
> safely?

This can be done but only when there is a need for it, which we have not
seen so far. Without a use-case, namespacing the IDs per-file-handler is
overengineering.

>
>>  {
>>  	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
>>  	struct luo_file *luo_file;
>>  	int err = -ENOENT;
>>  
>>  	list_for_each_entry(luo_file, &file_set->files_list, list) {
>> -		if (luo_file->file == file) {
>> +		if (luo_get_id(luo_file->fh, luo_file->file) == id) {
>
> [Severity: High]
> Can this cause a NULL pointer dereference on incoming sessions?
>
> In an incoming session after deserialization, luo_file->file is initialized
> to NULL and remains NULL until the file is explicitly retrieved.
>
> Because liveupdate_get_token_outgoing() is an exported API that accepts a
> generic struct liveupdate_session, an in-kernel caller could mistakenly pass
> an incoming session.

That's a broken caller and should be fixed.

>
> Prior to this patch, doing so would safely return -ENOENT because NULL == file
> is false. With this patch, luo_get_id() will blindly pass the NULL file
> pointer to the handler's get_id callback.
>
> Handlers like memfd_luo call file_inode(file), which would cause an
> immediate NULL pointer dereference and kernel crash.
>
> [Severity: Low]
> Are these indirect function calls necessary during the list traversal?
>
> Replacing the direct pointer comparison with luo_get_id() performs an indirect
> function call (fh->ops->get_id) if defined, on every iteration of the
> files_list traversal.
>
> Because this function is used to look up tokens for dependencies, it can be
> called for every dependency of every preserved object, resulting in O(N * M)
> indirect calls.

A very large number of files with dependencies need to be preserved for
this to be a problem. We haven't hit this bottleneck so far and don't
think will hit it at least in the near future.

>
> Since the ID is a constant property of the preserved file, could it be
> evaluated exactly once during luo_preserve_file() and cached directly in
> struct luo_file?

Not a bad idea to be fair. But that's an independent fixup.

>
>>  			if (tokenp)
>>  				*tokenp = luo_file->token;
>>  			err = 0;

-- 
Regards,
Pratyush Yadav

