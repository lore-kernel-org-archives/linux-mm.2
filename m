Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CC3CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BECE6B0005; Tue, 26 May 2026 05:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F846B0088; Tue, 26 May 2026 05:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DE36B008A; Tue, 26 May 2026 05:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11B1D6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:31:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 927FB1C10BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:31:07 +0000 (UTC)
X-FDA: 84809052174.13.C2F32E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CDD240010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:31:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4ck0gYN;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779787866; a=rsa-sha256;
	cv=none;
	b=U8xc4N41PFkgI3MOZaEi+/aFRZ3Fx8RW2gIRQup+6gHdteqNxK+oG/mqTxB1ZEcCvZ5WCJ
	ayEq3E0gd6Oj2rbcCERph6DUsO3SL//goSX9SyVzUkmMCkxOapQEXJ4nWrwKhoDqBRijtc
	TLPCTxZOeqIeg7NvYRO//YLpz+5RxcM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4ck0gYN;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779787866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+6X6r/1L0jGcM2fDpLS+DEmt+oNVnFKDM/qNq2yQ8I=;
	b=xxV0mzO4sZWvMgR+vp4PQTIvxEaY/gJLXOT6Rr+/ZboOJmISgRR0Oc8vcFJS7U9XGdJfHK
	cDp13LlxenE7JGQ5GFvvNkVBtDsDuZrRnOKwg6P36rAL8GUk/FDJS6qAVobtYyoZ2GEWMc
	AIFUjWXMNrUXsTjZEJ0cpsbUHf/KsT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F13660018;
	Tue, 26 May 2026 09:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B41F000E9;
	Tue, 26 May 2026 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779787865;
	bh=x+6X6r/1L0jGcM2fDpLS+DEmt+oNVnFKDM/qNq2yQ8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G4ck0gYNQzlVBtX5REq0snx4wevj5lgHW2jCohjsRdE+xUmUaO4znQ1SSEVSIwWv5
	 GT/Dtjac06qlMfogrulEroKjjk3C8CafBbe6CwebJ54IeS4X1+uOlDSq+OPrnONMlH
	 dd4cpVUiva5sUck8/j6sL2SL0I4/+YEI1bcD8akClIRE0AgnabQmCLeqcl4ML+gaPD
	 m4S+0O5eKD7BsDLm3doqm+J6kSGbkDx0RDdVxBtMmchfodf59o5qbH+q/GUaxlbeML
	 6STo1UJRpd/qkj7cEKtq5d7wGj0otwCZmBW6G32gcAh4JmJEKfoVBp90b3Qz5rZEji
	 186ZUmKjudZGA==
Date: Tue, 26 May 2026 12:30:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: alx@kernel.org, linux-man@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH man-pages v1 0/6] userfaultfd: document read-write
 protect mode
Message-ID: <ahVoUsqYBY642VLS@kernel.org>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CDD240010
X-Stat-Signature: 7xshajpie81s1psukgci93aiizutp1st
X-HE-Tag: 1779787865-616477
X-HE-Meta: U2FsdGVkX1/6+X8Ed19ETzaVWJeLdrHIGAlsGFJ1rEEtejEn9DLit5xFhxRyLVAn+ruAfOe9yE7tyfbOG2nFhyIyvERApzc4kTKi1oqKsDOHlGZhnMKMghoJFN/wHPc0t+0UNm+iOuNwtSs37Yfe6crBSGrBOIeGlzaADfM7GBxMYomgbas4VHzM1kiE0NwhaTmkAl92rI47Fxv1qkRFW5mcbEiKq8dtxWrSJAC/KzAnwcrP8zvWzJxqwHhCLr8Qxw4n5ws849yXu9AnC4yjyDy3sKK0CJZ0xI+U5YTvv9NKTw3QXrZyr0QokP6s8V4Mg7n86CcYy0yXcSmsbdZgFnxbT7p0Lo3pb2IAoxyBVlsLEG9qWCWHs943m8992GVFQbpbdf93C6Ni2og25misuu4Pnp8A1jh7+Y+m1ins9gk0rEnLZgYqrUSe1EB7DWZtEQSqEP8TTssL44wKfy9GjBQJxCxFlvr/QO/Xld6/j75yxlCiXJIemoUWYwzLcUGDqOKMVoBXczYh5aq2SX7luebkWoFQA3JdelKZOkqrpXLl25LYU07blnjMPNUVM+KjKK6i4m25dw5TDyAzQ5wTRDwD656ZNoAuhjG/F42ZEivPo1+CLzKYvXyQl8zJVqRFIKgfh02BIng0p5T+TCJJOjOa2PYPizEFm74rUB0pCXUebyoNvfzYKNxC5T8jtzjvzgYPsXHbyXDxhJSEB9ParoPKfF2pSuR/6m+W20rqlI6DwQD3O6vjjj1fLH857+M+r2LwcpPbEGOpFbIIseVSTxDjCM3g4a0CHJ5bbkiTarj8efZwF+Kn7NPXZgLUh/vpTnrxzR1NGnFnVWdsdQOAUjPR2AATxKjvRhkxLgUbAMzLwMwsve59rClFIJstOOnd4NySIC2eOFD3+CXjhOlWfxWJeqe4wndLHeT7RY0TyuWTo0d/O6G9trVjZZ657UOA1I2R5GKifnN6xkf8oVE
 xtwa4m79
 vjAV5oSmXLH2NO9U+UQOOvXvyMRIWIhwNOThBnWNIcRTH1qfxWoyafW6BzOb96lqPIn7sFtR5TASG0faFQwOoPEKmQmmEookYqzAQDYqvIFQmjPN4K7kKradVzB2hcleSEksfns8O1a3NJsT1zYKP9UGkR+tXFHwnWpJjQHe6pZJG1C6qj4rc9gtc2Xt3Pr6BHh+juFQ2ryw+dWG9KZfl6SkcCcGrDnjgcp/nU1pGk4pVAgJJAUI8P149CsIuW+wxQhB31tPmZyaMBAvlwbjJmxAnkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 01:28:10PM +0100, Kiryl Shutsemau wrote:
> This series documents userfaultfd read-write protection tracking
> (UFFDIO_REGISTER_MODE_RWP), a working-set tracking mechanism for VM
> guest memory landing in Linux 7.2.
> 
> The matching kernel series ("userfaultfd: working set tracking for VM
> guest memory") was sent against the mm tree:
> https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/

The content of the docs looks fine to me.

Leaving groff and organization to Alex :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> == New UAPI documented ==
> 
>   UFFDIO_REGISTER_MODE_RWP    registration-mode bit (UFFDIO_REGISTER.2const)
>   UFFD_FEATURE_RWP            capability bit          (UFFDIO_API.2const)
>   UFFD_FEATURE_RWP_ASYNC      async resolution        (UFFDIO_API.2const)
>   UFFDIO_RWPROTECT            install/remove RWP      (new page)
>   UFFDIO_SET_MODE             runtime mode toggle     (new page)
>   UFFD_PAGEFAULT_FLAG_RWP     new pagefault.flags bit (userfaultfd.2)
>   PAGE_IS_ACCESSED            PAGEMAP_SCAN bit        (kernel docs only)
> 
> == Series layout ==
> 
>   1. userfaultfd.2: overview, registration mode entry, new pagefault
>      flag, VERSIONS line, and an "Userfaultfd read-write protect mode"
>      section.
>   2-3. New UFFDIO_RWPROTECT.2const and UFFDIO_SET_MODE.2const pages.
>   4. UFFDIO_API.2const: UFFD_FEATURE_RWP, UFFD_FEATURE_RWP_ASYNC,
>      and 1 << _UFFDIO_SET_MODE.
>   5. UFFDIO_REGISTER.2const: UFFDIO_REGISTER_MODE_RWP and
>      1 << _UFFDIO_RWPROTECT.
>   6. ioctl_userfaultfd.2: reference the two new ioctls.
> 
> Order: new pages first so the cross-references in patches 4-6 link
> to pages that already exist.
> 
> Kiryl Shutsemau (5):
>   UFFDIO_RWPROTECT.2const: New page
>   UFFDIO_SET_MODE.2const: New page
>   UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 <<
>     _UFFDIO_SET_MODE
>   UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 <<
>     _UFFDIO_RWPROTECT
>   ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE
> 
> Kiryl Shutsemau (Meta) (1):
>   userfaultfd.2: Add read-write protect mode
> 
>  man/man2/ioctl_userfaultfd.2          |   4 +
>  man/man2/userfaultfd.2                | 152 +++++++++++++++++++++++++-
>  man/man2const/UFFDIO_API.2const       |  29 +++++
>  man/man2const/UFFDIO_REGISTER.2const  |  21 ++++
>  man/man2const/UFFDIO_RWPROTECT.2const | 117 ++++++++++++++++++++
>  man/man2const/UFFDIO_SET_MODE.2const  |  95 ++++++++++++++++
>  6 files changed, 414 insertions(+), 4 deletions(-)
>  create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const
>  create mode 100644 man/man2const/UFFDIO_SET_MODE.2const
> 
> 
> base-commit: 9a4bfd0e50745c2649b6291db40b58e37c9c1c6b
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

