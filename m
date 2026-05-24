Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AD8CD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 06:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9826B0092; Sun, 24 May 2026 02:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A3B6B0095; Sun, 24 May 2026 02:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FFF6B0096; Sun, 24 May 2026 02:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 193B36B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 02:32:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47C7A40CE7
	for <linux-mm@kvack.org>; Sun, 24 May 2026 06:32:29 +0000 (UTC)
X-FDA: 84801344418.05.2ECFB59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98E0AC0004
	for <linux-mm@kvack.org>; Sun, 24 May 2026 06:32:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AkW/BTsR";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779604347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWtOiJuxeH/+e3Jcsrdi7jNThcpdTxQXGumirxf15nc=;
	b=CSEoryTTJ8tEFNX8kBACFY/qdvCsmEUTADoI2Xq0xuBkhByt1dxr2TivE8EN7fC7sl6Oos
	SXFpfOZKPau3YqBaDy13js8N5q3ITp8jCasWHQBkxcLiA3yLwMq5pbOnePkV8W3mxu3JuK
	3/RZUfOsEaxchfERWnR/iO6brVN9ctg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AkW/BTsR";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779604347; a=rsa-sha256;
	cv=none;
	b=QVX290GhwiyQa+Tx6pvTFahiRjt/VvyLxbC6h8Hzs7PolsVQCIqRHZUyComBfIZXxYrTeX
	ykCbyO78ElV61n8NRNTOuavyXPh3vLU/41R050vEfChLeUbHjVplMMozssnQz2riALhI7E
	6rGRxQ8d7Z0EDGPB+YOQWtUqxEw0Fac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74D794075B;
	Sun, 24 May 2026 06:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4051F000E9;
	Sun, 24 May 2026 06:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779604346;
	bh=zWtOiJuxeH/+e3Jcsrdi7jNThcpdTxQXGumirxf15nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkW/BTsRTiW5BVztshGqfK2t9rvxsAhno2rDSZ5CYNkjBgUKrrfI2ksfLydAEU0Bh
	 wduSw40cQWzS5nMx5Ne70i7Xs9yQug7APGkOzA7ABYptytJj7abghd+U5yI9ntngup
	 pr62clcslNBKiSS4FCrYaLWOhZnbtIQHDaNFJRQjncpuiYh9JaQRvHBbQJM+hfn7r9
	 RA3N3pUcAdJdtRIpP4/HYaUe0ntYSL7y5RGzUT+FfHhLy+fAKUyZuVLRKr6KAvihkY
	 NHP9eircNJ8gaM1F541+LA/8qE16l6yt8O0WJlG4Js7f14/CmhRq7qxPtzkPf4oyrl
	 6mGwZbiWmtkYg==
Date: Sun, 24 May 2026 09:32:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org
Subject: Re: [PATCH v3 15/16] userfaultfd.2: Add read-write protect mode
Message-ID: <ahKbb3QGHaqmeL5W@kernel.org>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-16-kirill@shutemov.name>
 <ahGDbKr2u6sqoc3f@kernel.org>
 <ahJBTaobKD9XdT33@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahJBTaobKD9XdT33@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98E0AC0004
X-Stat-Signature: 534sybebssk5fp6tw1abkf4nt51gnwio
X-HE-Tag: 1779604347-297963
X-HE-Meta: U2FsdGVkX18vIYYFE6eDnRRftQBniyB3v8dyp67QaENo/Dy7nuwr2DuFPzrtO/w31KZRbjATXcitBm2mIPYqCXpguAs5EuMchKqPj0H2fQG0ZL9wgOhwOUa8HnNpj25ArXB7cLbS5r+/WccSN/s5N9g5qPZ3W/YCtxPafR+LIZO43lT4UgAhbkPQMQJsn4o5wN7/ZDF+jbqP6LUrQgEo0AUm9iM73LxYQPpwnIZuxh1XzGLIODTgdj4Y7RWJInbj76/dX0hTMUxnL90R1DGr2Ybx3XgA7I0PbGe6FiojPMQ55KN71ymrQLxgG2CZhqO6wieSrWte/RvbIn2F/a5s9D1qtMh14gNEbRiOFg6Rq/CeM2yuuMMbhql+t2u6zNqTnfONuHlYwwLe1DJwIx0r40g8Zx0FIMqR8Z+oWOzDOUXyWz2hXCcWKeANJTq3ypfHt0RNVye+0uNE6XNzABjYmbtMXAikg5LvXKKaF/PC4EUiHfrt8uv5IhOLne7FpAlEwyolCoHiWGLPY5SJ0DWSCsR0QXv6QyBRr7CM/Hfx+LckS0pszsrRN84YGwKPqHaSUY6/EH5TjQsR+N6KDAght3/g8OVJFRZmQG8GKmMPX2hycZmlUzZ7W5iE0RxY6+qzk8A5CF6h4yda7J8FLVZslUDkm06iIjjZ5SAJFlKxp/zoaIOSpOend5Fgr7JeDxXiG4HLvaTvyrdkR6l0ht5X/9Ydyg47S5nAdxcnGp/t/Se08wKR1JgGM1+CPwzpFk60rCw4oxuIkVpvRJHrI/ouXNTdlS8afjZeGm4HIGbekup0+xFXuxuQAN8ytbr50k9/H5Ar6ubJwIB1bfUmttbqbcmcx8bGkrjpvF7gRzMPYCeLdwm5U0otmf4P1m88yh7XmtD2E+3w5skqzHVPB2j9KH9PjGAIvi1WJtVF/EMNy2b4CYIG38HAYN9xVw7C9iMJlkXs4vjGOL0sgz/z9J9
 td2fwsGE
 KoDdbkWE+0U39VUC8Zmm4fi9mEnE/3PUE/uwhgmHVkq7DIni8CzmB1ExcfFqNY7EcRj/kAmFjCz8seRr62h+1hcmC9lxgvx1J3poB5gDNX2QswboB2cash9Or2m7gG9v0ODoVH0u5IqhH/RcF0m3njyvqg/kyBrecJTe5pg2Udb+IUd3tkXW6WpSiEbYWhyE9pRPgU4wCzbyvqf1YutR8+d8GYMmv2n+zuxc/66V5mwgtPdNS0P0qLbLr5iLQMCMzJozXYTn+z2nzkLkrzC858BJ5sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 01:08:11AM +0100, Kiryl Shutsemau wrote:
> On Sat, May 23, 2026 at 01:37:32PM +0300, Mike Rapoport wrote:
> > On Fri, May 22, 2026 at 02:38:56PM +0100, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > 
> > > Read-write protect mode (UFFDIO_REGISTER_MODE_RWP) is supported starting
> > > from Linux 7.2. It traps every access -- read or write -- to a present
> > > page within a registered range. The matching UAPI consists of:
> > > 
> > >   - UFFDIO_REGISTER_MODE_RWP   registration-mode bit
> > >   - UFFD_FEATURE_RWP           capability bit
> > >   - UFFD_FEATURE_RWP_ASYNC     async (in-kernel) fault resolution
> > >   - UFFDIO_RWPROTECT           install / remove RWP on a range
> > >   - UFFDIO_SET_MODE            runtime sync/async toggle
> > >   - UFFD_PAGEFAULT_FLAG_RWP    new pagefault.flags bit
> > > 
> > > Document the new registration-mode entry, the "Userfaultfd read-write
> > > protect mode" section, the new pagefault flag, and a VERSIONS line.
> > > 
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > ---
> > >  man2/userfaultfd.2 | 147 ++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 146 insertions(+), 1 deletion(-)
> > 
> > This doesn't apply to the current man-pages tree
> > https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
> > 
> > and reading raw groff hurts eyes too much.
> > 
> > What linux-man tree did you use to generate those?
> 
> Ughh.. Used old github mirror. Will rebase.

I found that the man patches in the same thread confuse b4 review, I
suppose sashiko also failed to apply because of them.

Can you send them as a separate thread please?
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

