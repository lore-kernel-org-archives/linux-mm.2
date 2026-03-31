Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E631310F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2002D6B0092; Tue, 31 Mar 2026 17:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0B86B0095; Tue, 31 Mar 2026 17:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6776B0096; Tue, 31 Mar 2026 17:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB8916B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:17:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8636C1A0323
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:17:18 +0000 (UTC)
X-FDA: 84607618956.24.591FDE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D994C14000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:17:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gXIXNSNM;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774991836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7V4fadgPhgRAHbAPI7BFfxB876KsTGQ+IJX9PiRJsM=;
	b=pZaEhxfwn3ixjzREkSEJ0iEEyqWGt9LJHe6YxtAvZnkHWT/gBm7JawPnLRg4H/Qkdmux1v
	lm++/hrKUcoAjhN5uvtsRw3dbd645/d1wce/PCaQeUWpUyTI1a87tUz5aF5ywo2PxyNYFE
	4kVdNURZiVhfNHe6DnylQuvEwGN1GrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774991836; a=rsa-sha256;
	cv=none;
	b=42sBrfNcf1yQMvs5ExbmcQD6kE3bdMj4QS+dRxIRgSFGr47JFmLd6SDjef4SF1lGM33fc6
	l1NYf6zpAC+DNyViclzzssjwhdzrJXvmHdYduSSrnUf6Z1OlV77RP09R9jmkUlIZu1BoBY
	w3ubb2ayPxwU/Pho48glWqezwzLhCkU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gXIXNSNM;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DCD460133;
	Tue, 31 Mar 2026 21:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7EAC2BCB0;
	Tue, 31 Mar 2026 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774991835;
	bh=dXkrTSSnhDWqtHKoSdOUNn0uoqn4H6W1UrZQGBlydUo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gXIXNSNMmkoVNor9lok/efYhi7AraY/lYzc+w0MPepa2npDYVjVfV8csr2TCIpBNv
	 ThjAsNgNiorsLVCRlHHDsuw8K29CLmiv0sUibMV/QXcEEd0zDdYklj3Ia+z9xrqBa4
	 ebjQqsweArLhapmphHovf+Za9Br/fDeMRTOyH6hw=
Date: Tue, 31 Mar 2026 14:17:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot
 be locked
Message-Id: <20260331141714.b2f4e41b494060e55610a5f3@linux-foundation.org>
In-Reply-To: <52bec9ea-5627-4ea2-8f27-f1729957fa47@sirena.org.uk>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
	<20260310155821.17869-2-anthony.yznaga@oracle.com>
	<52bec9ea-5627-4ea2-8f27-f1729957fa47@sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D994C14000A
X-Stat-Signature: hc8ymp6ikkdq11zqor7gh1bxierukec3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774991836-955184
X-HE-Meta: U2FsdGVkX1/ArbI8K5O5QICgjey+1SMLN1mhtv7mCha1K5iFlNxKToYXVF01O/ZE/7lS4ZKel/WejRPNeitthnc6obO0dSWSYj4X4QfuQ3C7n+I3oJX37AaCikRolv2V3KRS9hnzjcn89VHMpGsfyJwUAiu1Qa6EHiUKG7/pFdJYdHnv715ElVrGBnCOHgKlklp2+upVA3pilL6K3sXSIwY6Ha0H5H6Yd1G0OsdTcg3ULF+zQTeCRQxCx/zVXIUuNsQUSLzDYn68ew625aJGanos0qgNWC4OCWzZlNY6fQRujs1xQ+iyud6Lym8+kRdMgt6ud5o50+d4EaHIUeEkeWnKkgvvBxxVxsSP3xDIa4GL4EuM8Bw1vATRmiVgyN3MYzH87SWWiUUxASpClKseTTtivBSlwuXEv18l2oG0nPVo/UzZmjdW7Hu9YTDpezyCwbEPMNNLGnAtbrDpprTki+Qwh46aoQYRfIwErLCGTcD5maGzktEN/VKu6zJGp5YZJ8JYoXMWimZugfSIHCohT6MuEegpBLf5T9LlzkDe3zAur77XWTzEzDcyi1HUdkJ4L2s4DzD5DWj+TkilhADIzYkV6/W5RAXst6USwjTZ+CpnAcqvknQm2m2a87MP/SIB/UCzJuuly55JtohZf+spmv1kQ7S9He59cwaPG98pCEoOS936jys9xwQJ/VXN9ZUKE7tTdTWosSzapk9RA3SlZJkrPWtD/WKIVwoJFhPt7vFWsgKWa5pdx8W8hi+w9F+DK7xiI3R88ih7Ghyyho0MO/M2vmQtuMvr1xJuJl9GRk8NbpGPhaIeJUdoY+mMoHri7IVmZURx0aNE6ABYPrxa5CoNUbf93tfETuxM1VTFmO5XcfkWy1MOlGED+brvRJw6EBqKAfvXv+x4qOL+PdrYpu1DHy6EEbZqLqR7D71goLPLdZkSpSalL81fDkcSLatWUlT2jWJofjvsGBEHHmY
 RqtgvGKK
 7d3ddAmiUDfrPe0ieqVAGLkcLXG2ARL8LpnSj8ft5R3WNTzuC6ZixpExiZB8XH4qVK29UJE2QwAEcDpLc3IiGqi24bRGoz7g1QH7oBRZVqCtMoQ4CgsoIOD3B/9eJ3IpN48j15cPpFyPIpGSo+vznqE2nPh/aOvDVka27L14i1ZIFKWc/fe+FEw0A6aRSQXFoYpbSwM8X5qBM3SrfrcgbntKT1D+LAe89h9PKnjLeWJ4cHw8SIxXSbY5tGoJXnznFxOpA61sgY9cJy6EGf3ZkHMY0fi0AdZWQoZLCJhT1cPBswPSLdbv937ONZi8x6zzcCBFZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 14:17:50 +0100 Mark Brown <broonie@kernel.org> wrote:

> On Tue, Mar 10, 2026 at 08:58:21AM -0700, Anthony Yznaga wrote:
> 
> > Verify that a mapping created with MAP_DROPPABLE cannot be locked
> > via mlock(), and that it will not be locked if it's created after
> > mlockall(MCL_FUTURE).
> 
> I'm seeing a regression in -next on 32 bit arm which bisects to this
> patch:

Cool, thanks.

> ...
>
> All these failures which cause the entire test program to immediately
> die seem exceessively strong...

Well, is the test code incorrect, or is the patch which it's testing
incorrect?  That's 5435ba164b0d ("mm: prevent droppable mappings from
being locked")?

5435ba164b0d is presently in mm-stable, cc:stable@vger.kernel.org.


