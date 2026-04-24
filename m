Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C12FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7929F6B008C; Fri, 24 Apr 2026 19:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769B66B0092; Fri, 24 Apr 2026 19:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6C16B0093; Fri, 24 Apr 2026 19:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFDC6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:34:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08BA0120174
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:34:42 +0000 (UTC)
X-FDA: 84695056404.20.09B47C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B0D7120003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:34:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QXAoIme3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777073680; a=rsa-sha256;
	cv=none;
	b=eEwO4ti8plwtt6j0jR2d++eFxnSFJXLer4JbMY4QZmpuHFGz2jKrpwkLxuNusrMmZgBChe
	kb8qrASTDzQXPK/w2a2/D1IHmITumWLBQ2A0JvASNscUNBcTRzFHSyxnf/ZoNqAXuI/c7f
	dB9e6DIPyxINi0NLJkjO1R0FQ7aVKos=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QXAoIme3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777073680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nEpBAu+5Rqz3lxOX92+fEqLUBDYkHT0u3zdmFxooyc=;
	b=esv4sLhzmuS7iAVqG7qwQL5qW/kY6WXkc3SeumXczKxRQMsciFxu+SH8KhygAqVzSK3txl
	YwWu6Rdz2OWTugTUu6qx80X/Z6tEzVNA5nXgYgqbi6EIZ/OzTMGKdGYhorF80l8IQxtALk
	llZMWTAbdjqamZ7M9k7RQ+VuKPXplZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 894A7600AE;
	Fri, 24 Apr 2026 23:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07202C19425;
	Fri, 24 Apr 2026 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777073679;
	bh=1jfIqbSPLq0qNuZBiP9OXbiRWtkR9TZEqZHMCmgXsmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QXAoIme3BN9MOWbMmkOHbwVnKRUFLR6VA0Nnquc++LvdF7S1NRFA0R/KtjF3T31fR
	 svONuj93lYFCzC7uf/K9bL9As8LSUJ4ooDs+dLm5ykPwNbmO+aPeKS9XN1T4BihfV6
	 8qooFBLCoBDVpWEUjy1/yEYa/rgElMvoQbOEh5n9QxsAd0dbhIEJ/RPZs0rHYOM79T
	 +t4nxZTZVaUG/WWE7s8E7hagyKZ0zd6Ro4nFwG9qimjeLy6VAWynfbBP4efTy1/ZUm
	 WR+4oOxM1gjDxhzL6WLX534MH1AegOHN6c3AcOa811gzfzQ3ai+99KCFjCfItg8EOU
	 evbLewer0CmVA==
Date: Fri, 24 Apr 2026 19:34:37 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, skhan@linuxfoundation.org, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <aev-DS4YTp5soVPd@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
 <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
X-Stat-Signature: e78yzita7ojdiamr6mpyb5g7arxbna4q
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B0D7120003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777073680-76032
X-HE-Meta: U2FsdGVkX18uTIpoFOU/1pr9sIWhk99/OFBfkf7GOecFOItuLjWbTjgySK3EPGNQb+NuK4zJPTq5Y5oqEfr5b5ymAWnLcIfh3AxkUQqVSV6X48kbJ6zMck+/JWTAi9xWhjUhEz/fyJzgDAG/9OPllHqaKvzvfwXrGylm0LRo0HitKj7O3kNeq16D7EK5p1VMmstGf/UxJ/JY9veiApfiIgoex5E0B+paipInMsKhb32p27ugvcCvpXDUdtZ+fldaBSo+vUTPyrSmg77IZr8QN5r2RBr2in41P+xUZAbfmBKpkon+j2HSyHasdiGVR/f/v/6JamiuYsDuaytYAFXo3+pk2S4mKjZgj/79cI9kQoS+i3YklFUVDsneDIza+sehoN+8EexfomgFTIpIc9S+h9kklHEorM6rTY+/WdFWCx7u5wv6rci60erR+aGkzeBUABcPlND9gt0SLhJ0eNjO6GyP4Qdpi54MH579+XKtohrYgLghEJcXiyD1fPCd9ubvjkucNP3XQF2VLttjuUMe5jL/X4fgiWVHmUaEitchYzJN+uw9vy6VLLiLgDo3uGv9Yj/sMLJNQeDifq8J2geT+CORJZeDEVzpcpF66PsZ6TtrRFs5qR9qsZ793GWN5P+Sw1C4f+HpkGP8cA4T7gGppWXrghBLgIDdbwCPLI50PHB4ffMzQrcHNVF2J9VESohD8/FAyXVPpxFNuUK8mhO3q9pY+UpsIeMdQWNboQRgCAaeSw2QfMYGlnFJNVqBXiiSrYmg47UWjYQ7YIlymLo8fjFI642SevfZaHXRW4O6ajYNwJCKzNXkNp++zIwildFy1RCZrajeNicil7kU3MwtokpbOk3dgx6/hA1Q9yxYyw6J9KduyJMdeTecEhlOa0kXczPgoWoY9+TZuWVu8aR/ikuUHH8aMViVD2zgGQcUheuKR5h8MWlq3EDLgeuW8iVqo+K+FsXHQsZQIsXRNOd
 OjF2ZtFz
 S6YCHO0f4oKmiIXGSuvH2+CDsB9MRqT7GxbHCLuqY8lp3+oQf46utiscD7MK8jsZuDrec2/2n5p6MHiIPHkmpihsgLCBBx3UC4GjMjL0jOKDjfKT3AnUTTxU7+GejwYiwmBiVFEBIh9OPURkQFlQUav1Dcrfj8gQJyZDA4xLj7i12aet6ajl10GIAsqgHv4wdPiI+YaZVFINtLy0YQd3q+UDyXtbPSmcFSOAbpr3+WWZG1ChSHE8EyiyFnBu44NWkY+eP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:28:14PM +0200, David Hildenbrand (Arm) wrote:
>On 4/24/26 17:06, Pasha Tatashin wrote:
>> On 04-24 10:49, Sasha Levin wrote:
>>> On Fri, Apr 24, 2026 at 04:25:41PM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> One bitmap that covers all sparse memory available at boot.
>>>>
>>>> Conclusion: Just horrible.
>>>
>>> Depends on who's looking at the code :)
>>>
>>> I picked it for auditability: covering the whole range with two
>>> memblock_alloc'd arrays means the only thing on the lookup path is the bitmap
>>> words themselves, which is what the dual-bitmap invariant already checks.
>>
>> The issue is that we are going back in time to a flat memory,
>> without NUMA or hotplug support. We need an abstraction that avoids
>> allocating this memory in enormous contiguous chunks, as thit approach
>> will not work on modern hardware.
>>
>>>
>>> We could go with per-section bitmaps which will fix the waste but pull
>>> mem_section[] into the trust boundary, so we'd have to start validating it too.
>>
>> Page-ext provides all of these capabilities, but as you described in the
>> cover letter, it does not meet your requirements. Therefore, I believe
>> a new abstraction layer is needed.
>
>If we decided that we want this (and I am not convinced), we definitely want
>something that supports sparsity and, in particular, something that support
>memory hotplug.

Makes sense. Let me take a few days and see if I can find some middle ground
here.

-- 
Thanks,
Sasha

