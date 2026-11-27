Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80D8606A684
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YAZn7BJi
Received: by kanga.kvack.org (Postfix)
	id C1A0A6B05C5; Fri, 27 Nov 2026 04:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF16C6B05C7; Fri, 27 Nov 2026 04:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06FF6B05CA; Fri, 27 Nov 2026 04:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90EDF6B05C5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:52:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5654C1A0233
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:52:04 +0000 (UTC)
X-FDA: 85480432968.28.F9CCEC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B12A51C0005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:52:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAZn7BJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795773122;
	b=td2oPL4vE/eUaA1Eev3PsTSiC6klDJetEbpKN53XNassfyg1dwkypzjuq3nVVfrwK7xfUj
	y/bqmT/FJY5AZaLPdxvDgQzECObrwNMGJErqYaKnfICLO6QaXCfb148VjCe/zYq59D/VVS
	3hCiqNFSGggEBcyql1lkBkRzvYUjpQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795773122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6L939f9X0Bf0f8CrwpPeKq7uGGEz23ogLG/rkd1zBs=;
	b=ZF1bONFQce1dzv+CxfcnyGbj1Ts4LCEJpJgacBLv0+CPsY2Un9eAq7127pBpQiKPo+e07R
	Jb2ZHCsXyR2BIkDBk0WY49Zq4TQ/Wt3D3IOCkQthS0oSKh7i1UiJIa58Q1kKD1uhnlstB6
	h3OFD71kA/5u//LUZtnTeD4Ap6gYdbc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAZn7BJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD2BB62646;
	Fri, 27 Nov 2026 09:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE861F000C1;
	Fri, 27 Nov 2026 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795773121;
	bh=O6L939f9X0Bf0f8CrwpPeKq7uGGEz23ogLG/rkd1zBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YAZn7BJiJI427OpNFSlP+H/uM4G1EUDdaY4bRj71kLl3+iPW3mj4xQ/Dpe66mT8/M
	 q7ELSN9Dqf+RgZIEcokTnUvqDANZagzcCIYraEjdLaO+YaWrFVXlvoRs9VDymmYCPf
	 L6UeE/+WM7412/FvIhViKQuGE+hOARvjofUO76YvcKrdxYbBoo8/ewgwVymZkmLUTM
	 gvT4pfQa0N6k5B/FNqK9RBdwPuPiXiBejCDcxjiCpRHgxvqpiZT9JPwt5vGlUeqMyb
	 SE3jSrcDDs9kwh6JEMC87djW6rXSeVSVj5bnKwyDoSQKB/YKI26xpQjZXYYa73L7Ig
	 ysM7h+VbK2SEw==
Date: Fri, 27 Nov 2026 15:17:51 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, mhocko@suse.com, kas@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
Message-ID: <awlDUT0n3Uo4mjld@blrnaveerao1>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <8e8bda1f-dbcc-4f24-bc75-0b68bcc1a40c@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e8bda1f-dbcc-4f24-bc75-0b68bcc1a40c@suse.com>
X-Stat-Signature: 64c39b1ak6o8a7f7x79czca4cxxn1gn4
X-Rspamd-Queue-Id: B12A51C0005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795773122-583694
X-HE-Meta: U2FsdGVkX180hoCBMtYA0xO9BEVipe0fiq7IpcGKyk3jiN0sHftacyVWuvYNY2mcAcRYyXMLMFHikzLao4KlnLTJoIAgVwybfO7r9SNx4QTbdDnK2Aa4tMCy4ZHc6JW/fvWJ9jq6mXLqa3qseuwYxGQyLHhTE93z9mEL4qLEU6r763poJJfXqcx9FY05EybpeYiIED/sVQBWMl/rfoLJFqlM9gvllCz8jpRgwvIjK+ofKp1aIIc6H2rlTHLBXm24MGr/CdsYszOPiutAwkmQJgNaYATpa99NQ72tfbOQk+om2TZa3TFMg+5SBBzSn/8WG27ZfBlJWG0dOZB+dDeOTYeFWbcxPuLDynDz2jOl1GG+deICRdfdSZVf/Q99hZDmivuNyBVSUdD6w/amAH4Ssyldg8+cmi/1nTseVEajENpcdoJJL80U9SByyfYOt6u+sQR0rrkUFweCksCNnLPenN3KMqKwzU3GPQK87CvyKg16wx0rwKw278qpmkV7SGOpnXoymH/MncXVh7zG8J86pOgRPmpUOYeECR1dk2xxrCDuKfWKpiaP6ikUa4RmXu4wOFD0GoNLlb9/MrrgNi5WFtxpsPVcAOH14lbq3qLq2DYvfzFtGOvIIKmnbu0ufaHM2eDNgrYFzuTtTrTmJLjAwXqHS0SWUEXNACtjdM+8bXfLux6l1Vlu6M8qrkUCi5+ZvUgpiIzCaWgIX8ZSQbkXJKPNoVqe5jlmqbDIo9mpi7eHOO62fZeVWvdExvRt2ktdBK7iDQ2kM77FQqmWu5ty3ImpvNufSClq8vzLU+CDH8CFEAxfu+AS5w3Gh/nYBtEDqbhcZSGTUCSFkQiMg6Dq62z28HriwunzoZlXXlTcoyDzs0/SJpLXGVBKZSydsLMf1VAMUHWfVKF+l2eWr2l52G2v/zpU6KWKxMbwDelo2fD4hc6h0nGrwz1VrV8YS9vt8oqhHmGozEzmL4j5bzj
 36jj3our
 TgMJR/anYkv0QiKcqoTuO9Kp4CIoKwn4Ks4PEuwRs0kE+q/jtVOoHW5zZ4a6Ebx4qaFzkNVEzy8/c1aKAjGQV7iPK9z9nM5Qby8TQsO01DLuk/cZ/8F6GeGoVmKB+M/5EfUTZwrm6v7VHUf4nFiQDkTU+GXMfU1wtXGGaYS7cqCqbI/fp3DBbb7hmpoIOlaZZRXrYzlN8cSLK58ckVuLFLodL8dmCNLc5mt2hYqC9z4W2YImrOJePtLQ+30HCxc5Z3o6/dmqtcOiI0hWyFxiX/kMo3vkQONVx+N3VgIkIwKcvG2NoYiuCZUvW56MFio5tLokFu74cqkKv6bX9dCA6rcFvSpnWHY5mV2fLW4TXEseSYhUBVrFhdjwQ6VeQoN93DIBqXLNvUsk1w7xuTGAjHVT6a3U+G2C3n03AhyxLPh5DaGUVUpsnRyoXs2aG0KVtAMIUATEGp2XksXV2Zf6uheepZkNXr21DiPcj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 10:28:02AM +0200, Nikolay Borisov wrote:
> 
> > diff --git a/mm/char-mem.c b/mm/char-mem.c
> > index c5761ddedbd7..5d383befd87d 100644
> > --- a/mm/char-mem.c
> > +++ b/mm/char-mem.c
> > @@ -30,6 +30,7 @@
> >   #include <linux/uio.h>
> >   #include <linux/uaccess.h>
> >   #include <linux/security.h>
> > +#include <linux/cc_platform.h>
> >   #include "internal.h"
> > @@ -609,6 +610,15 @@ static int open_port(struct inode *inode, struct file *filp)
> >   	if (rc)
> >   		return rc;
> > +	/*
> > +	 * Enforce encrypted mapping consistency and avoid unaccepted
> > +	 * memory conflicts, "lockdown" /dev/mem for confidential
> > +	 * guests.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_STRICT_DEVMEM) &&
> > +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> > +		return -EPERM;
> > +
> >   	if (iminor(inode) != DEVMEM_MINOR)
> >   		return 0;
> 
> Having taken a 2nd look I think a consensus solution would be if this check
> is moved inside devmem_is_allowed() for x86. That way /dev/mem could be
> opened but reads will simply return -EPERM. That way x86-specific checks
> don't leak into the generic mm code.

I arrived at the same conclusion. I believe the reason Dan chose to do 
it in open_port() is to mimic lockdown-style semantics so that userspace 
could detect and fall back (to using /sys/firmware/dmi/tables, for 
instance).

But, as far as I can tell:
(a) userspace should be able to deal with -EPERM from read()/mmap() too,
(b) and the tool failing is better than it crashing, or worse crashing 
the guest.

So, I think we can move the check to devmem_is_allowed() and reject all 
accesses for CoCo guests.


- Naveen


