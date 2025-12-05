Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F66D2E008
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6508D6B00C9; Fri,  5 Dec 2025 02:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6274A6B00CA; Fri,  5 Dec 2025 02:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5647C6B00CB; Fri,  5 Dec 2025 02:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42BFF6B00C9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:01:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B91C213B0DF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:01:36 +0000 (UTC)
X-FDA: 84184521792.22.3171044
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0EFC1A0005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:01:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgPY+DoN;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764918095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPMD4sKHMKOjTUKItqivPia5Qzs6WBPRbvF5ORDkKa0=;
	b=j6jLAUtMe4a7oKNZTKZakY5DZ165xzhaprSFUANkOWufAbXAZLUT/a0Bl3TBQuaQtDRskc
	mI7kEQTzEnZrUUJBb6K2bArx/HPAPm3c48SZRf7GRN31Z2M1/pvHb2ii1pxw5lg6j2HJRq
	5gPg7PK347Vkm3EjHLzDtvfIrtyr9Ro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764918095; a=rsa-sha256;
	cv=none;
	b=Oe1uWTwOLHUm21z1veIlwGduODbOmQjBgjHaPk7H7v+d84dnwCSB4EyQLjNEysO2fMEskR
	qkc1h8uoY/DaT00BiMwPLYyn9xxnamPtzwMVGl5ycm25sNzAFHfYN+MrtBBkyP1oWFKOUj
	kKpm+ivCDKBoo0FfEYOlzY5QT43f6JA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgPY+DoN;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8DEF41688;
	Fri,  5 Dec 2025 07:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C5C4CEF1;
	Fri,  5 Dec 2025 07:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764918093;
	bh=fBB52+FpmiRjld7TBCQI6MHpA8C2/HNb3RkNEkzbihM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GgPY+DoNZhiHH3jItOJ3AYgP5WTSiMtpLCZSWOmEK7RicGrrRqMeWPT8B4Vl1nQCx
	 JYntcXZRE3K6JabczWDsVjntVOkYV8FEdRNFsepd3p56NPUo7JqQMmI582XOmaBMpJ
	 87Y3iQUR+WG5fLuEHFeLat/QHKBLHKVuRS/ElFoCFupAhWni4rxoIHbZ93xDq5Y2yA
	 89Gm9E2xFp/Y5EnWo0Jv26IpBbCweuq/Cl/aZv2HztATkK5E5lCifF+oU9qvZO0/qo
	 JYHrYFMDtgc5Ytnto1g8r6P3+PtBC0ECvHdcFkCsnFMi0wRKVodMizWY0Y2vj09Je6
	 XKldPNeaY+qgQ==
Date: Fri, 5 Dec 2025 09:01:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>, david@kernel.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
Message-ID: <aTKDRF2sMdM_5aRB@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EFC1A0005
X-Stat-Signature: 5q6f5p73k4d7dfuwxys41m4sz1qcz8zi
X-Rspam-User: 
X-HE-Tag: 1764918094-940406
X-HE-Meta: U2FsdGVkX1/F4nbjT9yk9a+XrOJHio9VYQsu3jQUnm40NtRLbllPAEBxdkRdWNC9zOIV6UY7+I9M39BLT3q5c/DVRXL5vxPyg4BxcVQXQ4lc1v9I48ubvLZwVlXuLhgW2GZQ5sBIDNrj8HZCWD4rMrPBRWQFdkIkiZ53ND/lX1JFvX3mcmUj3eVGP5jES6n1UX9yUYgah4Q/59YymypRBDk51+iPijHX4rfh5Rknzkqerd5VRhuDAXKuAyaQruUKv9OxNQRmKsdBYByXinnzEH81wdO169pGoK82vNF2LSrLCu60PKrKrxu7kNPcvKJA2NUEYSil84lNrA+C09wrNe+6KuRt9eqzI8EkmDugaGru7tYX16IvM2XILU0yex4kx0DGKg/UkRcZJw0r737eOzZldGYIypo1qFf3xhWOeHNiFxiDlXrlq/ODI4O+w+BqYpdfXgGG3uugK9ABRv+yAxUMrLR2fb3TzjCopvAoZN/9coXHG3SfYdUTzfJHJ1hZH9/6KIsqktqMV5YtP/bxRDRe08EsVFw5Wm33bSq/VWoxmuudfQPGLvqCT8lgd2c/aZKreKOK+QE5o2R0zMnHKYcIKb2Ok4rWJmSbym16s0TlStNATVNtihih1VvqqIDisdt3TqnptLFemtzsRubXJ/xB83EWlm6xLVVAbkCYpH7U+ftPDwSkHqHZF+MtaUAZZ1PqCOPflLcAodWUv39mHzQcxgUcR4ir+ymwGQKi0gnJtD5Fuw3a8L+NSuPcL5QNZsZXN7dgiqxl+W7F+t/yMpydisZbEbRG4N5cxqrCO1b2Aai7EdbMt4NSNLmqe3tA4y5PH0BAzX224PIbt4rgiDyEddYwAzuP6W+JAgvbxJCE44HGW7dci4/IVaIwb4/YIdSNgKoDuxw6d3HxwytmTUSb7pwPOdov4XeWqDI7Q7h8rW3KpLkdA+NoHq+U6XCGIRGG2UFz8KykKyheB70
 5VLfRmwQ
 glfQkrbxpy2iTSki/nFQPybs+eVgqz2fi+Eqtq+HMQQab2DTea5hbzrhg5qBqPV0dYSjyuxw9umyTHQO81l356yJIM+ajv0kJ3ITEqvwCp831d/isFUhJIMJhbqkcAL8EG9MjTo8XcmZRx2dGjjwfguq0zTYVoNfJVYkeVLhhNP4tp8F+VdvC8VcRKygI4tucT7rTRQcmvscJPb/wGGfGkx0gA4FGvhbhOKQ2ofm1paoaVNISMc+z0glI7azOwh39nARk46r+7yY+QmaREgAqfkOb7GF1lAfHaXLUI6xIIzprKl9k62ufUU7P9wnP+bHeufDkDwbmWvwm4Zk3W7g4l3+RLtcOuW2C9YjzYlc2omdzuzeuynv0GaaoX3Iw3cb3bY51
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 01:57:46PM -0800, Andrew Morton wrote:
> On Wed,  3 Dec 2025 19:33:56 -0700 Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
> > This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> > 
> > Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> > systems. git fetch-pack fails when cloning large repos and make hangs
> > or errors out of Makefile.build with Error: 139. These failures are
> > random with git clone failing after fetching 1% of the objects, and
> > make hangs while compiling random files.
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
> 39231e8d6ba7 simply shuffles ifdefs and Kconfig items, so I assume it
> exposed a pre-existing bug.
> 
> Reverting 39231e8d6ba7 will re-hide that bug.

Shuah confirmed that the bugs were on v6.18-rc6 and they were fixed in
6.18 [1].

I verified that reverting 39231e8d6ba7 from v6.18-rc6 does not solve
anything, but applying 5bebe8de19264 does [2].

So reverting 39231e8d6ba7 does not change anything and there is no bug it
hides. The bug was introduced by adfb6609c680 ("mm/huge_memory: initialise
the tags of the huge zero folio"), was fixed by 5bebe8de1926
("mm/huge_memory: Fix initialization of huge zero folio") ...

> And that isn't a bad thing.  If we re-hide the bug in 6.18.x and in
> mainline then that relieves the people who are hitting this and it
> takes the pressure off David, Mike and yourself to get the underlying
> bug fixed in a hurry.
> 
> So I think I'll queue this as a hotfix, plan to send it Linuswards in a
> couple of days.
> 
> Or Linus may choose to apply it directly or to do a local revert of
> 39231e8d6ba7.  But I don't see how a local revert will get communicated
> to the 6.18.x maintainers.
> 
> David, Linus, opinions please?
> 
> > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Let's have a cc:stable here, just to be sure.

... and we can skip all this hassle.

[1] https://lore.kernel.org/all/317deba2-e560-44ed-a9f7-3c6fdc446b6d@linuxfoundation.org
[2] https://lore.kernel.org/linux-mm/aTKAo7JgBX0X_pBl@kernel.org

-- 
Sincerely yours,
Mike.

