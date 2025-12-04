Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75B9D2A53C
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC406B00B4; Thu,  4 Dec 2025 16:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5596B00B5; Thu,  4 Dec 2025 16:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A46B00CC; Thu,  4 Dec 2025 16:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0FB86B00B4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:15:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 945491A039F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:15:34 +0000 (UTC)
X-FDA: 84183044988.25.E669297
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E77ED20016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:15:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q3wf04Kn;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764882932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4b12iSL93twmi1pftTaGSzkq9YgdEKxM8olmaVvfbU=;
	b=BI3wZhQrcDlXOfISR+LcTVWejuoTWYHIOkj4fVL/lgm+SxEne0i+VyDNiN0kNL+glbxOsz
	tJN2J22qoEqsgphtUDANgQKqbwdY1+wxeeZaF40Pe/xkqDaQhn/jcQFg46pyB15bOH3twl
	tWzssD/+HBfs6ewRT+FsqL2hyt3JZkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764882932; a=rsa-sha256;
	cv=none;
	b=sT6jsobQZPCXdSPkW95X0DDptgEDh0zxXl/opOB9JiqbBAafMVHHhBLga0u0BxOj0cH9z9
	A7md+v5r7Qy8VD2JdfIImIPuPkJhJSutmNaXcD1+CZ1CvYwnyoF++w1XbYAF5JPDMFEJQS
	iIeC98FWl/v3evSFoOWvUJGZ1Ocmfwg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q3wf04Kn;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5745C60200;
	Thu,  4 Dec 2025 21:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83279C4CEFB;
	Thu,  4 Dec 2025 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764882932;
	bh=6k2GRQBqjw6t/2Bq8gihyaMJPqlUwySvgrCW4cFAx6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q3wf04KnbAkEHgWC+A33jjSzlZb8qEPLEkgwP7PI+FQ8KEvhTEw8OYkRJNLwKH18z
	 lgdSCA+EMDz4TY4uqMvcQ8abxPe877MxDXPmHgRAS7vX6tuvvL3QKj4xHoKOz05Gfn
	 Z9d3WL7m+Vv6vZ/LaCCKgPXsnSRbtmWhiM8ASk90zVNcg2Hm97YYCQ6jxe6T0mrPtx
	 ecn5VKBeURBkElVh/va7higgF4X/VGeIyPYsmBhOP2aAzWWkllpzyQFVeWo87hiLIV
	 9HdRRfFd9kEGnr+f8IBkKCe1fNlVZSX4IxlZylExgtC+CKpuFGLVmXfI0HQvE0T9eW
	 zKnmnmjryd/Cw==
Message-ID: <992028c4-dff1-49a5-9cef-42484783da8e@kernel.org>
Date: Thu, 4 Dec 2025 22:15:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, willy@infradead.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: dev.jain@arm.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, janak@mpiricsoftware.com, shardulsb08@gmail.com
References: <7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
 <20251201074540.3576327-1-shardul.b@mpiricsoftware.com>
 <57d5793d-2343-49b3-a30c-cd12dc40460d@kernel.org>
 <78c9b5eeb10051dd9791ed3cb0ce7a18eedc5e7f.camel@mpiricsoftware.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <78c9b5eeb10051dd9791ed3cb0ce7a18eedc5e7f.camel@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E77ED20016
X-Stat-Signature: he8r3f7a6dfs7e44pgf4jyhr7j7su75w
X-Rspam-User: 
X-HE-Tag: 1764882932-767512
X-HE-Meta: U2FsdGVkX18IqI3CacEDWYSZbBuhIrBjYftXZQHaUPeh/dayyRj1go0U5xITYRpFM0HgpEksnHho2DIr84Fh7uJHGIPwDlcoogPj4TkNVe1qs0v6//mxjRmLGRBWp6G+OcIW/qwkYDFpBeH6L8z9AoslICtdDA4eM1nkXPJW566wiwt+7iXwqHB2jwutMPxKcuXizDnODT8wHq3p04vgWb9K0KEVwNeZtKfFgnnAYQJHHXi7qCemNGng3MmetunaKu1Ao/xRwTqPmiGo2Sk8D2fL56jk18cUhI1/KPcBJUko4O0hqvKtnWdUR+h4Lj4/McvRaSC3xZKBgW0wwH4lG5H1RvfVxBixlTqgNGbKXjAE7UXoUffCd1dQM8U/zMDr+JNtTIKbNdfgSSxr5hLQrauSvyKjFV+LrwNK7szr+pZa0dfbyGxLORlVLlOf6O52oikgES16tyThOzLJtGK/NgKZxv4dkGuiNAri35X0orFKAmICbpfjbQH7X6MwcGMTnYIEAgwDB9IKeWyYI0QICBkTXxHUPAcIyJegdI8u0pBD8UQpQ4QeHekj0UaaJHT4T8PrjYkHqwnp/tJg+XxTJ/4WcxufPqzU6qyADqzQFJ/M81VRFCDmq6UayKfB4YUJ2nKOY6HHlI1RWJaWeeSzWpBdHRDXQGlx7lT9U7IRaBghrmA22RmM2NPVYmrUhzsG7mBHP9e1Pp80WvvCvr0olW+g0ZPt5J1sS4SoO5PVF37aX/JlaJX0eKtjcewh6ePqGCXzQ85FsnlP9nQV/W+6MDPGStKknSqISl+nQVMwST2H7akKWcGewz6cEEPlD+KY4mZxJ5nc9phJx9HM2YFG46HvNQ8Oj3ggeEXDxk1lurcZhUASYvp4fOOz01N6LFVbnI7rVlKY3Pm26h8U7ieYIG/44lekXGwrTFmr5h+8nBPwvtCLXLyI2lC4dXzz+MEhFOSaTAoIHOvWdPJvxI5
 kLMBi3UX
 rAmbllF3cYmEBh+AJsP97Lb1xGVRdPAjdMKO8FfGIwl6JOM/Aoa/U9goKn0cBerlF9AHf3nPHCt/DbSflZarHEHhS1275WSOogNoJPTw/8EJ58Nfg75eglLUDDFMv2O5j8aJSFAD8dXGJ3lxkve4OQ0KqvfWfqeIqUujUZlyvHsEoyrozeF/ytkghgDfPqMAoK3hT64m1DwcPgUh9DOsiEbtaBB2Wd2xnjEGROPy7PVUKDyuEEHCOaL+1Ro5aXKssFd16zyN9J2PLj+qtDkTWXBAgFCNq7wyFjSw94kH1e+rcwbSlS9L0m/OKhAy5eThdBQ2wWlzC5lkzuKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 15:15, Shardul Bankar wrote:
> On Mon, 2025-12-01 at 09:39 +0100, David Hildenbrand (Red Hat) wrote:
>> Please don't post new versions as reply to old versions.
>> ...
>>
>> ...
>> The first thing xas_destroy() does is check whether xa_alloc is set.
>>
>> I'd assume that the compiler is smart enough to inline xas_destroy()
>> completely here, so likely the xa_alloc check here can just be
>> dropped.
> 
> Got it, will share a v4 of the patch on a new chain with redundant
> xas_destroy() removed.
> 
>> Staring at xas_destroy() callers, we only have a single one outside
>> of
>> lib: mm/huge_memory.c:__folio_split()
>>
>> Is that one still required?
> 
> I checked the callers of xas_destroy(). Apart from the internal uses in
> lib/xarray.c and the unit tests in lib/test_xarray.c, the only external
> user is indeed mm/huge_memory.c:__folio_split().
> 
> That path is slightly different from the xas_nomem() retry loop I fixed
> in xas_create_range():
> 
> 	__folio_split() goes through xas_split_alloc() and then
> xas_split() / xas_try_split(), which allocate and consume nodes via
> xas->xa_alloc.
> 
> 	The final xas_destroy(&xas) in __folio_split() is there to
> drop any leftover split-allocation nodes, not the xas_nomem() spare
> node I handled in xas_create_range().
> 
> So with the current code I don’t think I can safely declare that
> xas_destroy() in __folio_split() is redundant- it still acts as the
> last cleanup for the split helpers.
> 
> For v4 I’d therefore like to keep the scope focused on the syzkaller
> leak and just drop the redundant "if (xa_alloc)" around xas_destroy()
> in xas_create_range() as you suggested.
> 
> Separately, I agree it would be cleaner if the split helpers guaranteed
> that xa_alloc is always cleared on return, so callers never have to
> think about xas_destroy(). I can take a closer look at xas_split() /
> xas_try_split() and, if it looks sound, propose a small follow-up
> series that makes their cleanup behaviour explicit and then removes the
> xas_destroy() from __folio_split().

That makes sense, thanks. Handling it internally is certainly harder to 
mess up by callers ...

-- 
Cheers

David

