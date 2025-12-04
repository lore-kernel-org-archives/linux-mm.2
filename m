Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C779D2A54F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1864D6B00A3; Thu,  4 Dec 2025 16:57:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15DF36B00A4; Thu,  4 Dec 2025 16:57:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B7E6B00CE; Thu,  4 Dec 2025 16:57:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF44F6B00A3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:57:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A31BE1A026D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:57:50 +0000 (UTC)
X-FDA: 84183151500.06.8EFFA08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B0AF180008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:57:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k9q35YFw;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764885469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+UR/Bh5+3hB8Nh74pUKsNs06AZ2/n3PTN5NT1oU0pw=;
	b=kHFidScpC/uCdX2Bk1kTY7ypLVgqjM4acn4vErDsuqBFRPPxyKP1bnLp2SVQDOBrfWhWi5
	zqR+n8G0xj/SO7cge58JaNc3+wnrdMZo0CfqsvovTOzOf2WYVjJ2NjqELU3+b6pS9ZZ/81
	6wqe9RsDJEhujxyLICJTKhoiwZNVjDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764885469; a=rsa-sha256;
	cv=none;
	b=OrlQbjKM2URaxckV6e8VfsyNEq2XP+7Hv+TRWVI/GIg7Rsj0X/3ULesWav+olgBoJkAP89
	PjlVNEUXaTp1+kL5FfnwhyNvprHsmt7wo07+mxyo4lprgBEv0/09H265MJ4laFyLDuld/e
	4HNzXhJ9gHNX0l1GHnfynqsNCMGswyo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k9q35YFw;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C38460202;
	Thu,  4 Dec 2025 21:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8EFC4CEFB;
	Thu,  4 Dec 2025 21:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764885468;
	bh=X9n/SI6IKvE+F0NdeSHaFU7vcgdgXOCeq4cTbmL1cFw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k9q35YFw4ap/XLACqc1kqO+8+Ix4RJb9p5Wre06HB3UZOOw6lkzrZFHB/kRL5DRvS
	 9jYimUKT7EXuHJx89pikNeF1l9K/ZdtSDsNHRFZOgqkT47Wblto8ZYyM9jyIP5tyxf
	 rMM48sJsTXyDerFSED8Eaa2bIRcDIGTfhpX8ibAE=
Date: Thu, 4 Dec 2025 13:57:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: david@kernel.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert
 "mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb"
Message-Id: <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
In-Reply-To: <20251204023358.54107-1-skhan@linuxfoundation.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B0AF180008
X-Stat-Signature: eyw1z93diwqg1z6srfa976ay87qagooj
X-Rspam-User: 
X-HE-Tag: 1764885468-290654
X-HE-Meta: U2FsdGVkX18AhlhNWrvI1v4NHIfiXpnebQN6LBbQCFX5NjsKOULBVDnDjHC171jhku5Ix5B7euvjDv6UHGAcJPAmzaaGjAGD7yCM0pMs6j1btbEUycvGBu4yXzIeu9Wg+yyI1lHcwQ/0tpi2HMBGTOEdSuIdCxstlaxPQmPh8nz9haKcU4MKs06svhwfjRPfEtCbFwiwqVU3c6Rayt7ukZch+4GYnhZVj+f3CPks/U1kanaN0VhOwYSakxvhSh+t3whRqnhby0WvjPXYmlF4Qm1g0Xy1sw1qVcbuMlsJonyLQ/9GmsZ0NFxoBdGhb9wZAKg1PF5ZeNRHB+jvNMWu8Om26w//P6pA3JDlo8jDo7X+jZG232uloaNHt79GgGyorj26TloaPopOJyL9bvW32KCnRyCxjDnGP/8Mos90uriGp4s8M2uRjTqsO79q+voDRI9KimIOl1qyaOxBFFMKnUHODZFPmOcpuxKeKm5D/NoKqJvxriUjrumhHw6ojTB46pXVVP/kTCNysnc0/yIgbJccVI2xpT7bK8xWHuRfMTKt3ocQsa8u0htVY+POCw6hsKsAHST+iuKKM5PSJ+0atuwnuXvKIzUVuEXBwVQAJ4n79z6wRe3krFmvOe2x1g5B/iFWJ76y5Kv04upxjMTfTj5t+8ZPMOA/QRjEZ52A9Un9x19LZACR4AlDEZ4rAI3uvb0lgOR8J0mdXxXQ+Oi/SyvRGj3mPGimRf8IT4veTsSYE6aAsc6xpC7bcDTaogaiAdlQ2vSk0Aej0/o0NUpIuOb8mxEbZCIUVJWe1LV95giJfmvp9Cd7q/jYsdlHOR9TOdi2WaVqEUpSt4tksbELDfg+VuChiPg3a7T4W8EKvWjNN9JGcPvU9mEI1wY9x24L1pDHkouWOEVe+cN5KBXBHC7rzS+MIHj5dSW6D9onczjFT4ZtLLDxtkPFpZtR30X69o6aoeTuXihZTb39qx4
 aKwYfwgq
 bDUQQ5O1fNwXNiwOA2zI2wsu0MbF+gKG7qVDbtstwV6XZclIQ6WF54zLVmf93NS1gRLR1RBoYLXO9Z3RizScC0CmeA4pZheIBYFVHtBQplegODNgSBhhv3WlyUWB6pdphDdaL78p/Nmkq1EubGc/gBKvqSxPqoBaSK5QQEn4T6sBplCkYdphGwENHhUgP/ObHlpN1Gz23tQnPr3+C2qpOqWJDYnclXrupc6037U1mPiTv6sOocS2Xe++qpbeE14kqV+Qd/j7BaswRQKsVYivV4PCHB9Wx6ja4zeTmJrgp/tXm+VufCtWlO+A5/g2Ra3a1fhKMt0D0UtiaWfAmZ4+d2/1sLf6y0dhR5kXGW3iGKPIQe4rGBxz28pskDkUtuvOrj4Jk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  3 Dec 2025 19:33:56 -0700 Shuah Khan <skhan@linuxfoundation.org> wrote:

> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> 
> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> systems. git fetch-pack fails when cloning large repos and make hangs
> or errors out of Makefile.build with Error: 139. These failures are
> random with git clone failing after fetching 1% of the objects, and
> make hangs while compiling random files.
> 
> The blow is is one of the git clone failures:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
> Cloning into 'linux_6.19'...
> remote: Enumerating objects: 11173575, done.
> remote: Counting objects: 100% (785/785), done.
> remote: Compressing objects: 100% (373/373), done.
> remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
> Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
> Resolving deltas: 100% (9195212/9195212), done.
> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
> fatal: fetch-pack: invalid index-pack output

39231e8d6ba7 simply shuffles ifdefs and Kconfig items, so I assume it
exposed a pre-existing bug.

Reverting 39231e8d6ba7 will re-hide that bug.

And that isn't a bad thing.  If we re-hide the bug in 6.18.x and in
mainline then that relieves the people who are hitting this and it
takes the pressure off David, Mike and yourself to get the underlying
bug fixed in a hurry.

So I think I'll queue this as a hotfix, plan to send it Linuswards in a
couple of days.

Or Linus may choose to apply it directly or to do a local revert of
39231e8d6ba7.  But I don't see how a local revert will get communicated
to the 6.18.x maintainers.

David, Linus, opinions please?

> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

Let's have a cc:stable here, just to be sure.

