Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870A0CFD641
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E986B0005; Wed,  7 Jan 2026 09:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C486B0095; Wed,  7 Jan 2026 09:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45906B0096; Wed,  7 Jan 2026 09:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5F976B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:49:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FFDB1403E3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:49:59 +0000 (UTC)
X-FDA: 84305452518.19.AFCD908
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A916C140010
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:49:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QisCsLOD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767797397; a=rsa-sha256;
	cv=none;
	b=6kDYN/pOe63yTFmJmU4XiES9KKd1uTMq4o/6fOHSjRG+ht9vaO/LA0VyV8YbR51jh9qorS
	RAjRupReza+TwxlYWDicrA8mif6Fkjea7FUACwJeOGhVf/BJMMSfitIh5vj26ad9TW1CKj
	zfQW2JMW8Wu4avkrj3bPr4Y3yMUBrpw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QisCsLOD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767797397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JMmNWmMHBBTwh/RdlLu4xg38+1vNB2/LngywvTsD10=;
	b=TETO+lVpsN28EkzgRFG+IBMcjluh/LC66qZn2u/JzcXRCJ5CmAmOoQxUuDiDw+48ov5bvy
	J2yEHwKjMA1k1u2YTPxtsVa9vT/Tu5K7fPek6p04edGFnKQIkrXxoCYA+0AuBHQkZyq3A0
	f33X5x1N7dt6z41pXKE4NeEYvziA/kA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 100F56000A;
	Wed,  7 Jan 2026 14:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46865C4CEF1;
	Wed,  7 Jan 2026 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767797396;
	bh=j66lzEexSpPcC3oYyLMGHNA0REWDjVJjs19BKH4bbz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QisCsLODlmD8mwR9w0lTKYfsJJEsJtkfdC8i0SRZi8A4FyOzSL1LJaOfX164++05k
	 eKxgdgbdRCvJYZu+jVHkK1beRfYXDyKmoRRCmYduZAl/SEUltttxQreUT7kXZPRUtQ
	 Hmh4bnwFxOAVp1fie2HBHnhtF2rEBb5ol40wlSQDNt4I1uI9/ZUTsDrrpk37QZOXaJ
	 zPl1B8lXa/X63dUXfxICcCkGwvR+AExXfQw1RHxHPmq7/QbfwOon7i2q8ZNAJAG7Sx
	 EMrSTTOs7nTbbMrrG3iQWoHDvmEV/IvVklV2PMEu/5vcnaN2M15RviZLWIjb2GqJj1
	 30lvLfERPC0HQ==
Message-ID: <02acb8f9-e60b-413c-a0d3-f1f8dda00ca3@kernel.org>
Date: Wed, 7 Jan 2026 09:49:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] NFSD: Add aggressive write throttling control
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, linux-nfs@vger.kernel.org,
 Chuck Lever <chuck.lever@oracle.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20251219141105.1247093-1-cel@kernel.org>
 <20251219141105.1247093-2-cel@kernel.org> <20260107075501.GA19005@lst.de>
 <cb269767-688d-46f1-8d82-1fd6dc32e94d@kernel.org>
 <20260107144243.GA15228@lst.de>
Content-Language: en-US
From: Chuck Lever <cel@kernel.org>
Organization: kernel.org
In-Reply-To: <20260107144243.GA15228@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A916C140010
X-Rspamd-Server: rspam10
X-Stat-Signature: cmgu98xtphp8i8y36odz84zty61kdktt
X-HE-Tag: 1767797397-857016
X-HE-Meta: U2FsdGVkX19GhzhqJWRZ8a3I3P/aeKMxhvAf5pWZJRACjODlA49Lp5pKWL5lW/7QKQcrIxF/O856FG4S7m7JvAGPjvdA6wp3kixIx7uu/SpoMQBDe3ZIwK52fwBA7XCTKkjlNDAUEr2rQb+2x0uYoZd7nC4gcz391VFgZZqAutqE7UQ8p3hU1PJTBi+M4NZNnPuIKlHIjusTK5T8V3aaNO8GRdoaPxCZydAClBlcGBU/EAmQPyujRneu1LBz3eKcniamPvm9mUcSYwDfJlV0IrjPoFhGKlrDZB5t/FPC1s5PyEcBt2QMlWQD3dh97nAGImQiYV0wa7OuYA2H7sVereQLzHe1Idwk4wpl2ObYmX+sYfeC5iQ83WCO7W3voPFA9/U+JzWakmbcFiZSXZZdW+R1N3EB2grv0SkFxvetdbUVm9t+F7Sq1rOQRFfomdBhyms/q2BHhCFPLUWADHPPe1lcIDPswgrc6If1iTwgJIXvI8DgJCpol3vJwLs8wslKkPKa4OuZv9VVKJ+HSRjP6LheLo2KeiLZFvTqFrK69VJOB9ggXJ2DnkqfUtQ3y/rZbAiQABbcDBk1u3fYqLawHl0Dqd9/DsSKdbvOMT93lo/W6twP79IhkA3xAU1bDixZgouJb3Te9V9CsihN0001YrAPWxNB6tFYSZ+xGTR5d0QrHXl2jAjG1OGngJbQ7lvsU5mKALMxwLuvikfQ393985ZuzsuJ++QPezxfqWMf382QbuR/EFpqTULBcNRt1MeWhmk65wSqDKL4yO9nY0HaaNz7aC8W8DbctjllPNcP2b/MlIQN90Grd0pIUBzg01dG3KjZ99/9qmPab7Uwh8st7D3eG+y8HByZZJ4LnLJV+axB7COK+CXGdhs4b5LDtPl/JGlCK6YJURMXh/ZQtHPOEcgN88fiDC/GKGqH5Rw6zGZkCpP1MOAqCnRQsdF0evGiuMPbG9KwAVT5+/hZS9e
 DoKrbm4Z
 A9hf4N9Yun6XH7szI8a+uLrYe+yQ/8L+egB5l6EZSrvBYEToKqDGO+Ls6MZYdbkY+lQglFg5nwlO+79i3V0G5tzmYrF6tklGO+KQbu1nXjE31/zwISSdYpo8NqqIl5KhAfpwTPCCetBR3m2Go4/g553h1DsliXaDEvR3/Z52dKh1v+RYcZ3vZTKzQeQ6BeEzHOSRnu+jVduMEgNkNakAdbdVkPcxOSjGwGT8+pfgEdybMcscPUSYLwiEK6N7+8xYpjKFXOIugTBmHnaShVOM1PyS+l1PiwComcbLC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 9:42 AM, Christoph Hellwig wrote:
> On Wed, Jan 07, 2026 at 09:36:39AM -0500, Chuck Lever wrote:
>>> What makes NFSD so special here vs say a userspace process with a bunch
>>> of threads?  Also what is the actual problem we're trying to solve?
>>
>> The problem, as I see it, is that the system is not providing enough
>> backpressure to slow down noisy clients, allowing them to overwhelm
>> the server's memory with UNSTABLE WRITE traffic.
>>
>> This is the same issue, IMO, that Mike's direct I/O is attempting to
>> address. Our implementation of UNSTABLE WRITE is a denial-of-service
>> vector.
> 
> But how is this different from Samba or a userspace NFS server?
Well it might not be different. But at this point I don't think we know
enough about the problem to say one way or another. I'm just trying to
gather more experimental evidence about what is happening.


-- 
Chuck Lever

