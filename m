Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11320D1D870
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A226B0024; Thu,  4 Dec 2025 01:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39946B0027; Thu,  4 Dec 2025 01:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02286B0028; Thu,  4 Dec 2025 01:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAFB06B0024
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:35:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 698FBC08C9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:35:41 +0000 (UTC)
X-FDA: 84180827682.02.F435A5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD645C0003
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:35:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+ldRRBi;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764830139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMNWtiG2wLZCiiTb8hWON6DA6cKjLvUOMbNv7bwc9vg=;
	b=1uqGXnir7ne5OjXpyY0eLPC0nRvfXFPSVVkE+UicvNYDtTDzNV32XUQwJfVTKhTEUnz138
	eAvSqZeYEtp0/7+Iu86Z8OCPWjt5m1PzZRyPqXbYC+yH1idxmTUcb6NYx39GNpmYBM3kvc
	yh9e6TtMishS7vS/qAnenpKMstZega8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+ldRRBi;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764830139; a=rsa-sha256;
	cv=none;
	b=cNNTwQJrkdeTlHlcoktNTbre2h4ZniTtX3JGh8J/g2rfctiYY2PjrOdpDgsEejErHl3r34
	Gg7nfcigt8Iw6sNBNrpFqX8X/yT9NMc+u9Cc0tZuD8ahhk5UW9+6zZ/UOabtN0QfGcqV0J
	MGvoRQA8Ibqh9xePo2KlRujUnRlwVvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7596440C8;
	Thu,  4 Dec 2025 06:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D98AC116B1;
	Thu,  4 Dec 2025 06:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764830138;
	bh=qq3I0S0VU3J5LrRdFM+Ka9HFuuLq+p5MynEaJa1wcxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+ldRRBi6aiMJPPSDQZU9HBz0zY9HhoA71Pc9+FYL+UMbj5AI8j89CjK9UWMCqU5O
	 1Uunf3lmic+ZUt8pEkCXfUyQQwXMVGWNrp0AfLUv/YYd2HarhxyP3pPfirJ+TdegG/
	 P/u4g6mTJ2sG2nBTonoGHuwwsEWXWRdfsxeEG8XVkhdvUfngY2EMcav0A67BYFWXtz
	 +S7NaS1uT3fF0BDvECrj6CKUj7Ty16yHcv4HVgiCcitWEmb45pVUsEQTqdKzbiGJmr
	 nz1Mr7AYPjXr0d8Ck5IPPH72P5qqpggCBKVd4MP6tekBbWBHhOsjAETnKvAQjEfWdp
	 qGTUFJX85CPxw==
Date: Thu, 4 Dec 2025 08:35:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>, akpm@linux-foundation.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
Message-ID: <aTErsX-wfnxkNJ1G@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <0b007374-1058-487c-8033-4f0d2830dc89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b007374-1058-487c-8033-4f0d2830dc89@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD645C0003
X-Stat-Signature: oszutm7g9iwhpr4d1kdg93bwmqfp7ktq
X-Rspam-User: 
X-HE-Tag: 1764830139-554668
X-HE-Meta: U2FsdGVkX18Pm0pWhFl1ZRCZfdQexdr7dC7tKPxwiWviJ/EQpRTRCLgZmBSIK43eJp7I9MikT4ajIRkDz4tD+UUD26DM0WvACNYIO/SlsKJ7uI6Omc29Wn1lHAXxtgFFy4i6lf0qiMl2Ie9XoQjKYuRsB3UZkdpy8tnoKm4bsX+qcghjJeHfe5H+M8qFLTtNTM+E6ESKvWk9FvFClryXuNNoURg6kLM+iZd1EuaqJ4aLaGbakzBDqhLztKj6BBnF46Ja94i1Dl59flBHNQxYiJzKalpLS3Birl5yDL1sEjxGva0EC2X4pz0JZqAENpl/5dGwGLhY3P00elPRgnofbgqFWQ5OhVDI2Shpmpo33f/UxavotWWSESQ6W5c1MWZSjzbBwTV1yLJy3iulNfKjpZ7zVunHNEhBjlf+Z3hbAN9s03CdBVv+l1a4VIjTng9Iaa0V7L3MCBXREwTPlKFi0f3nR7FnBK3i7Yzj+FJ+gKwuPsjfw+4yxcTZUsJj+5SolVQkHesgHpZpZiUGsr19yCQP6Vkva2cLimnImfWCox680UiM4hS0gaA7XLK9IIKdBp1sGdJCLcpMXCePZUKgkG6J3bWSys+izz3vuFnoVOJtQgZt/4MaDSuZybZrbk5w9j/xL0Vg2hoUrYtH0PgXnujj/UKyoPyVK43LbkFVIKmxr/ZaivDwcLNehSnCLqB302GSK10iwosP2vuLHzBNHBObBQrXhTtkv80+6+fQyemt+abt/kAo3T/xINnhdKhfjuznu56ck8XHKIYP+i7wgFR2T/8RRhYPRXvRHUdvVRhMwMBFfUf95Je5WyBRUahhHfHKQ/15aF8PZqprEUJVDcTDB1OeE57VFCWkNFiTtjEwm2IzuLckSByzU6ejnG+ThloEgV3DgOVB1hqUm7fBAxCQFqDO+pGlc+dBu7M+2Vd2lajU6ESNVq3z67fw21HIL+a4HbKcrV0hKU3GzCN
 vPSOqHgx
 iOHCn4qsKb+LJv6k26YFiuuO0txJK4Qz8EFpDQ//kBQbP03433wFw3Qdt5Lg2YYRfcLyRIJ2IF1ASEJktutCl8CWgTW8F0dGxbIftiDlCSYIc8ta3ENDZx8e/Qi4RIN5ND+iTnFPWkHYB2UhM0d5H1udVV12rXdIPb7uGHz47kzs8gTJXSh7T5J84aYUk7fO85yAavXj8ytQZhEcanntMhG9IxrvB547ZH18DEpK+V+XnrG40uWoVrpxhnsqWBJfi6+7aNiAI80eoS5tqKuvr0RrDbIJmAJa5jbXBqHid1BEs7UU8JGbngICTdCIPKfUxLBWt+2YPeR72w3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 07:17:06AM +0100, David Hildenbrand (Red Hat) wrote:
> Hi,
> 
> On 12/4/25 03:33, Shuah Khan wrote:
> > This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> 
> That was supposed to fix powerpc handling though. So I think we have to
> understand what is happening here.
> 
> > 
> > Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> > systems. git fetch-pack fails when cloning large repos and make hangs
> > or errors out of Makefile.build with Error: 139. These failures are
> > random with git clone failing after fetching 1% of the objects, and
> > make hangs while compiling random files.
> 
> On which architecture do we see these issues and with which kernel configs?
> Can you share one?
> 
> > 
> > The blow is is one of the git clone failures:
> > 
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
> > Cloning into 'linux_6.19'...
> > remote: Enumerating objects: 11173575, done.
> > remote: Counting objects: 100% (785/785), done.
> > remote: Compressing objects: 100% (373/373), done.
> > remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
> > Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
> > Resolving deltas: 100% (9195212/9195212), done.
> > fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
> > fatal: fetch-pack: invalid index-pack output
> 
> If I would have to guess, these symptoms match what we saw between commit
> adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
> and commit 5bebe8de1926 ("mm/huge_memory: Fix initialization of huge zero folio").
> 
> 5bebe8de1926 went into v6.18-rc7.
> 
> Just to be sure, are you sure we were able to reproduce this issue with a
> v6.18-rc7 or even v6.18 that contains 5bebe8de1926?
> 
> Bisecting might give you wrong results, as the problems of adfb6609c680 do not
> reproduce reliably.
 
I can confirm that bisecting gives odd results between v6.18-rc5 and
v6.18-rc6. I was seeing failures in some tests, bisected a few times and
got a bunch of bogus commits including 3470715e5c22 ("MAINTAINERS: update
David Hildenbrand's email address") :)

And 5bebe8de1926 actually solved the issue for me.

-- 
Sincerely yours,
Mike.

