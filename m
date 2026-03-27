Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4470010F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E956B0095; Fri, 27 Mar 2026 14:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A165D6B0096; Fri, 27 Mar 2026 14:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953D06B0098; Fri, 27 Mar 2026 14:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 85E826B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:22:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 194CAC7A37
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:22:08 +0000 (UTC)
X-FDA: 84592662336.21.A9B05A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 553D220002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:22:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d0yJnwHy;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774635726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5eHeL2nP+mCgV61ZRWX/EBtMTAWn0v39dy0OQMl/UQ=;
	b=CfK8QxY2p8bp356j3oT60yzBM8jdsCeIMLAG+431wTosmR7JYKAS/CSAeBetk6x2F/V1+p
	r3r+aQ0zKrLWegxx+VkgAPfzJrC1SFmvkh0eDn4qp2kw3k4ZLaDx5hfig3n/ZqJpP5cy6j
	+Nc5aAPl0CuXxWqNNN14rkaeX3xCn0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774635726; a=rsa-sha256;
	cv=none;
	b=nXZywV7lwTpFtjF3y7um63Vhm8t2Gs2CEnQ5oFP8coMSY2UFNzVongxtNN91biWPtV5ZxA
	rop+W25BEKtLRHWGM7hW/6ZJA6Zvfw06WQigTz3N6O+71/KIr9Zxof8vwRGZWsIRuwn8Lg
	JzPp3nBIi0tIpf6WEf9xeyskhSDYPQo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d0yJnwHy;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAB0E44216;
	Fri, 27 Mar 2026 18:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398AC19423;
	Fri, 27 Mar 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774635724;
	bh=9nrzjX+RfZq2NXx9Z701F13ljmtIrJ8sgnxURhGXCF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d0yJnwHyvkASWO5RvqvKD5X0aSWKVub4PWo6NocFTvFwesHiWVo6zhzjku+EYUxbW
	 CQplrWiH+QYK4mG6vG+I7hqIhNwSVTF3KbRMy3udR/6xdvkVHNyYcHOKldhz3JNOvT
	 GxWY/v/7drvJghEE3gUZfBmP8YHPxVzHhfRd5jjU=
Date: Fri, 27 Mar 2026 11:22:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hugetlb_dio tests when DIO alignment
 is incompatible
Message-Id: <20260327112203.d168f23504a998b2febe150b@linux-foundation.org>
In-Reply-To: <20260327031243.15903-1-liwang@redhat.com>
References: <20260327031243.15903-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 553D220002
X-Stat-Signature: 4o4e336xr3gph4srjwdm7myyqioo4gt4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774635726-107176
X-HE-Meta: U2FsdGVkX19mXbVzmmBzkYbDojRIQPNOGx4HRGHXUT7Bl1FORpAi8AuXEk4+F0PhXQfjv4dxtctl6VL2evo/YQ/cgtO/moA2aZKlvdFjlUrcsTrG+jidi6vknq2YD7nwAfsfDtPC0ZA5rCMhfs2XDxf00bursJDGQ7hoxEeN4uLr1Cff0iAFRPhEGC+iOVmyUQNsrkMIK8t/QCmRnypv5b/XJhFcrxidoJA8Hx3lxrmYCS1yUqtiij2ysdtJE/asNdlD8jlu6zMfes7sMyq3fArfu/+k2F/Y+ivHJ4Su+xQBmTLJ1Oa/ZR8jILjQifkSB3MEvDXS9vjowlodI5bYWbDlfyXepc6Tj78/KOnJaN6hO3F/ctyQ9zAPJEgLpG1lKlX2Efzaytj52fsYFIhRxKmabD3Xy9gXdmpmGp7uoR1/bOS3TPgR3+/Jhgjw/uElqV+sSF2+sbGoB0qd4r0xrd02qK3HHApF1b3z3w8af7WsSPzF6nQVPqiJbL9Wf28BrZbWb5/niR31XcKGljGVUTMiEq7nizKgYe72gQU6Yj56uGwBrYxgfa8+8XVs7UzyGOOdlQyhOCw7C3OVY3aVd/g9F6KjQtLP2ilTc/Pyd8c7NKKRVPBOKZM6QJYNcvnvh/Xrync3Is4Oh/yyJCbn+v8XjVQnqGTv7AChm7QlrY/L9tDnE1xftTuRYytS580Q4zDxoP81CEeIzrbuqLg08UuxMzneQ/QVoY6ljK2vlCeQx/6NSrAYqlyUuBV8bra1CSdpE/b+v5p+doUXYGpjfHnmvGB/hAo2L3kOX6lQ88VUdN12uAAUk6c7OuaZTOm76bPItXg7sRyhstV8GUXaxTpZxn8ctVYtcxaGsWsd1gORC4aUpA55MQsT9hI4tYxAqxTWxQ5wTF00thpeTSbvSdfYLO3gyAIkfAmxSG8Bw7hpON0GQUhAqja6+pZ1wSaa7fzJ2zucVYngyp/sCsQ
 t6qXt1S/
 K2Qij+wXhRO6NVC4q5TMhWYqVZ3c8GBahrm2BWQza+Z/QfggJ5oIvs6dvj+3I0rEVpStMkPG9jjQwXoICt4m9BYEhe6+fFZx1t0qAH1lVhCJMhPfunxfyx6hcYJ2K+X8PJZ9+Oc3CDq8i+GraLp3CL6V0S2AK1b2YvdqroGBbrBqy1nUFWIdDSkcosmuUOpn34I5kOxsFueXkP1Mxx1UJABiab9FTr7RNeil5b4JgG4ngMsHFzGbCFVp3SFOIbT8dVRMr9HG4lf2hhAsVESf3faGjjawxGAMZ5bUryzsBbnds+QZ82of/aMLRcPh7mi5Ut6VrVG2HnYkrM+WGXv1W0tG0Nq/E5glaw13DmNDfOQAtcc0nuDnEVQmvmZeUfKUjKtKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 11:12:43 +0800 Li Wang <liwang@redhat.com> wrote:

> hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> hugepages used as DIO user buffers are correctly unpinned at completion.
> 
> However, on filesystems with a logical block size larger than half the
> page size (e.g., 4K-sector block devices), these unaligned DIO writes
> are rejected with -EINVAL, causing the test to fail unexpectedly.
> 
> Add check_dio_alignment() which queries the filesystem's DIO alignment
> requirement via statx(STATX_DIOALIGN) and skips the test early if the
> sub-page offset used by the test is not compatible with the alignment
> constraint.

AI review askes questions:
	https://sashiko.dev/#/patchset/20260327031243.15903-1-liwang@redhat.com

The glibc one is worthwhile, I suppose.  glibc-2.37 was released Feb
2023.

I'd ignore the filesystem-doesn't-support-directio ones.  If someone's
running a dio test against such a filesystem then Don't Do That.

And yes please, %zu.


