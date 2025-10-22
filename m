Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6369DCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B318E000D; Wed, 22 Oct 2025 03:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BBD8E0002; Wed, 22 Oct 2025 03:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9687A8E000D; Wed, 22 Oct 2025 03:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B728E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:36:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B38F8865E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:36:03 +0000 (UTC)
X-FDA: 84024941406.20.63A505E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D698F1C000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:36:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rxtTJvaC;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oldKmoUhl57kDL3iXqTExYjKIke+virT4Li29A3sRk=;
	b=7LvyS28wYcWIi9JWKvywcmls9oWECnW8rjLZcauqUAABsl7pQpB69DbCPDJpfzU/pbk6OV
	AnJPaqalRXorYrV/AVesMhkpN+TKMVNJuCTBtWQjMj4hH8zEjfDhANMzCZjR6JPo4b73at
	wqGS9OW5cqIzt0KDuqSZpox5Fdaxt7Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rxtTJvaC;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118561; a=rsa-sha256;
	cv=none;
	b=nyv7DeuJtxvBQ8s7kEhD7wKYIsUOWIQi66EDhqlAZHo7G/BbcXKMM7c52aocNEvKP9LUqS
	GVF6RewbdjuIGZ7yCj7DcVqkPN9gmJOSOI7Bdp6mJWOAfbqInrOSLU5TJ1k1HNizirAuKq
	a+g4Dnl0Zl7yQCnacFFCd9qDzfM7kF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD1FE60362;
	Wed, 22 Oct 2025 07:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42432C4CEE7;
	Wed, 22 Oct 2025 07:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761118560;
	bh=zsndchJOPqaYYKkkXyTd1ldUAO9IBYagYpJiLPpm+Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rxtTJvaCvcWu5yS0t2wcS96hIPCq3xbTohSIMFJ4Vc1o+B6KW7G3qA7ZoGId1mrqM
	 fcPmQdUDPx7LTVBf3DrZAXNLx+9SLiq1ARZCqZtf9fAB1OONfjmWZj10ip7U4QAt+E
	 aIuSeU06HDDNFKQ6OIljMkl4fAJM52QPdKyfDGcA=
Date: Wed, 22 Oct 2025 09:35:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Message-ID: <2025102236-dismiss-liability-4e6a@gregkh>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <49bfd367-bb7e-4680-a859-d6ac500d1334@linux.dev>
 <2025102245-backstage-sprain-76fe@gregkh>
 <ab0c5257-bbb3-4202-bac8-3e74176fe34c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0c5257-bbb3-4202-bac8-3e74176fe34c@linux.dev>
X-Stat-Signature: da75qcdtr674hz6rezmobkt4wq8do5o9
X-Rspamd-Queue-Id: D698F1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761118561-490085
X-HE-Meta: U2FsdGVkX19vvAGdHWKHP9f2ws82qB7ubU5u1GXzUiMJsf3aKv6AGdhvYxz2Qopx8oI3rRsGNCZ/GJf7D+NLuqgFAQ25Z7d2xKULzFSnm1ttnpTt6VmZ2IY7+aXBLqK9hhaI7Xi0lwHvUiIc8NS4gJggymZXzaFWKdtHkDof7txdFoH6te0OWSJpD7ThC487nT+jimSjwFEfNLcAX6AQTlQ3dTVaf7wUR8GCDlEpng4wOsDQstHM1qn5H6Tp1YC7L6kokWdo2Q9VDcQdc8SdpJr8RtKVZR5WnTh8ipstLJqMilvkYnhVhcJgAJMtJSr0a3hFt0kwrTkJoedxy65HfJ8AjtjW9g62fYF+M57QXCSbEnklhs6AHi+bRjaxiLtkNBMNE5BkL0uVVzZ3sCKmZuH1Xo8myqJltfXTjNinP2X+ML6dN2FwZ68oQtv4ejbFpm0pzE2rzCBadf/if2JRzJ5MXwhS0/sxzxsTypi2WmucVB/sVwtYqQJQghkm9/UkzVhzQYS/OkPtB94/EczRIocMjcfw0vdH/12PLY3jFWmhmKIQM87/kr1Hg5E/k29IuUjR8gG8EI0NuyUQXPQ2ByTjDdGqoevA7AS0X+gv0OTTLj5yj8hs4YT18PjkXi8grfDV++GnupXyEpg/0G8Dzx/rG9HnzjCjyVMPcN6qVP5TN6lK4mYxUaqU5c/kSwDC2WgnOPJ2TKMh0rrLx4egb0hA3voxVi1Xn9d0pMPkwYRp7yWHYJFuU7VAlcxjo2d2lakB8a93uHxpXjoy3miNkfM9yVFRKUHnGAPhEnsXEfnAsLTkUDkg6x300TkayBCxC2otbGSjmbfUWwS/GMZ90Mv3WKAarSeNJj5AkcFj+8lFOKf2wVaozoMqQ4q7VXFI1zHgd79b9vRJ4gGdO/JTQSlIWs1wkDE+kLiOxioWwKieBrkY8EKrFj3rUMrU3+/kr17XZgUnUvoGAzrHmII
 n3Dpv95H
 tbvG+WE1gwzutSdwssABVzYUbGvmehtEGJQiX8NhpDl/8NXYY+OfamDaM1/V9uGYGkkT0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 02:20:26PM +0800, Leon Hwang wrote:
> 
> 
> On 22/10/25 14:07, Greg KH wrote:
> > On Wed, Oct 22, 2025 at 02:01:26PM +0800, Lance Yang wrote:
> >> +Cc: Greg
> > 
> > I have no context here at all :(
> 
> Hi Greg,
> 
> This patch fixes a build error in the 6.1.y tree.
> 
> The mm selftests failed to build, likely because some patches were
> missed during backporting. I believe it's better to fix it directly here.

Why not take the original patches instead?  That's almost always the
proper thing to do.

thanks,

greg k-h

