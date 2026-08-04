Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791DCC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4CF6B00E2; Tue,  4 Aug 2026 10:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCCF6B00E3; Tue,  4 Aug 2026 10:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A486B00E4; Tue,  4 Aug 2026 10:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628486B00E2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:21:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E49211601D3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:21:35 +0000 (UTC)
X-FDA: 85063800150.22.D527EC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4336F1C0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:21:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MxMkUlSE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785853294;
	b=IMquA4JyvBvL0M4SYsKKaTzzkqzLqejie+Bh0qb202KMSVcuuq5z85ZDWd53qLUDQY9sOL
	cYRzZIM4X0aW5BToK56OCVOz4X86FV+m0dYbQJG158GO4plSvQGGaUG3FenyUAqYlPg4EX
	DR8Ni6wn6hNyoobTugqnpth91M+cH5w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MxMkUlSE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785853294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXuWvCMPHuA58AjXtFE+LgWsCi3knhvI6g6+wWexqKo=;
	b=2nWLgXojn7LeD7SzS7KQhgxH8UgxWf4lO8MZIsgSqHgwHL5iRRa0+0E+5lWTmrWWdtry0h
	HXTQJqX8vWdEtgbFXGM3fKM5YlsB4busRMJ1Mbuv3DFsmdh1taVxbBH2f7UMCIdmzzQIJy
	VUQpvwPHc2LpVEBEb4uBbg8Q1zxum5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE3A560A83;
	Tue,  4 Aug 2026 14:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B384E1F000E9;
	Tue,  4 Aug 2026 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785853293;
	bh=SXuWvCMPHuA58AjXtFE+LgWsCi3knhvI6g6+wWexqKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MxMkUlSEMSyl400fcanujca9MerVDMrD+X4oLiAd/6QakFTQntELana5HEO7gRi5t
	 XPEM85RdN1R3ZTnD/xvim7V6SOf2UZqnnggSVctyn4EfUhZzpcfNfStR3eD3uDNTo8
	 zMkbXlqd0+y59qG8qIzuHUI3csXqxDbSUIxGMUISLjL5ypbS7U0qJYx/hWBt6tcl9F
	 ulIR9jO+8mNGR9T1zgyBFYI0PJA8q6N6vzOrhfDLY9YhGXFv5LFCK82qWijBGNJ67L
	 fwuAB44t/3WlDi1dO/cxpa3c87H044QW4vqNNJyx1/Gy9bQC24JrJ1nkmHOJt188el
	 jjGOjgbxXcdGw==
Date: Tue, 4 Aug 2026 15:21:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, 
	Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anH1CgpwS3PHeDRq@lucifer>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHuLy52o5S9Nlwp@lucifer>
X-Rspam-User: 
X-Stat-Signature: 58zpr6k6ddquq1nez4r1agakmifhbdyx
X-Rspamd-Queue-Id: 4336F1C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1785853294-738927
X-HE-Meta: U2FsdGVkX180Z0hBnWWTpY0E9qGDY99jqKrJNuko/6pRot7n/auwxyWxtoVh+KxCv+rcxRI5Y2mDLJo8+V8IXLPzTZqa4FH59a2T65mqDNkc+1nRlB958EAa5UdxWealVz2rYPsUIj3zqh1f97pM/07JEs+GoJJ5kygQdADTkNELa9qwJIypy+Xr+8pu97p0DOF2SmALln53l94IIITk7Ll9qmREwlhwGJBnwQ/HgmRK9RpI+JYJBtHUDkoMAUqrV3UcXD8rgFEMPVtH70Dv2xKVeXB2Ki/kB9vBxEO7hIEU36XrESSu0MGS++fhDlehmgFjRrLhqe1w0thcksDX7TDRF8UMhp3llFZJlPMF0MRKOK1BG5bdsFT0xrphCRfVTd6neyGTIlv0gaiF47dkG12iR6lDQyIohRel0lUQoNoUyiL1SQ9LqIuq7aovBJdT/qoXlJwdvh4gLfrZ1DOxTXa9ucQmhKFPgAGHSN/FO1sbRw9U0D0GJPvhFzzsZU029a7CMIhN+y72PGDAQsbUZ+lAIQ2pengn6+0uXhtivbABfrbU892wbHtLKaGGx2/O3MCJQhTTQMvPhpq68rooxB9E/tm/Jtxl6TMM13PyyK4J+aVnr0f4nh3iLobm61wTDM3o7noF3oUvelHbDJIqjQwlurhFeCwiDdXPnzImX1yIS7j+jqkf/cqBHJRvm/8O0Ku4wLU+qlYqH8MXMEleeeW2TxCTM05RdmsffVEGsjbsyZGumG9oRN2jtUxlN0n2IiLkPlJqQYWZ1Ge1VgH4tP4Mfp4cKx6ulwuznxmwx5Jq3oRFVGQi8CVJMXPFhCZVJjcjwtgF0uAk7S6B5N7Fc4ep8M/NPUnRoZjjOOZ42V8N8/IKciTxHkp/4Y41lBp/592fD/FVO9Fp8KI4uPFnZKYc05GiEhWBMXr5JKSZEYx6S6v/BJA1ViN4bl/QXqSxoKF+o/ng0/4i5vMkx66
 pclW2Ez9
 5seF5VgzcfozqwENZTH4wvuhgeHq0Q5sI48gJUMxt88lz5Z9OdsuyJfIX68h3NiETFU+9YQ+phCALEKphLykddlqFSjKEaopzo8f+4r9Xe5nqc3C96W50/ZdZzMbeZNf+o9n85thwkSxPbd+oV65GkYFRe+eJI2J9OaFpNClsJJW8c0id9zuz3pc/Qtm/ejK1lL/YJUeD9a5bKZIj0MYXoFIPy7Q+l+82hnHD9Y+vBziKo6bflAeNz4+znj+FO7IWENAUbhEt+zPV2J/JtGNuqT1NrzKQmN9ejOiPxxcRoGsrrhAK9rdAAWTUmvVONrTDxgycLWrPeHK9awkkB53h9rj6nvmRpPSg3jSuXe7qj3wVfm38AE1ZnZik6uoqYVSHTXv6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:15:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> Since this work seems to be very much arm64-focused, perhaps it's therefore
> worth looking at an alterative solution that's specific to the arch, like the
> one suggested by Mark ([1])?

Oh I hadn't realised Mark had already posted the series here:

https://lore.kernel.org/all/20260728123859.2911495-1-mark.rutland@arm.com/

> [1]:https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/

--
Cheers, Lorenzo

