Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F6D10D14B4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47DFA6B008C; Mon, 30 Mar 2026 09:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C506B0095; Mon, 30 Mar 2026 09:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D826B0096; Mon, 30 Mar 2026 09:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCB76B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:45:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAAFB16060A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:45:34 +0000 (UTC)
X-FDA: 84602851788.17.A532993
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED3264000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rxgfIOcX
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rxgfIOcX;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774878333; a=rsa-sha256;
	cv=none;
	b=L2G4RCOKrXPwy7ORJjEzCnMLdjfWpNdwd7uRLo7JMcT0Zz/SIBDj3h51Y0dD9Ap5+2mK6P
	xZsatA3QEcW5bV8qP1/m+6xj73M/BdSqXG/rpNTyGibVUzvqmsvcAKXLaok7eKsI26UE25
	uU3/Zl6Km9cnN+NQRbBJK7gcoLihpmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774878333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/9KOg+FUezNUc5b2A1UkvHRKClpiuB0wSxuomQh7PQ=;
	b=3svcAZXsyKbMWtUf0UyfVofhNnWf6O9lYqEIFhau2dp+r48RdaaJnJka3iynz2Rxdi/qTU
	g7Q+qa06xKKaA85o5EHQJxV1EBJTf8EaG16nnZDIPFrHCC2TJq1e2ioIGGslYcmZf7oHnw
	YangE4Nlle9rGN21WVDSsFjJxlVxOlw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0/9KOg+FUezNUc5b2A1UkvHRKClpiuB0wSxuomQh7PQ=; b=rxgfIOcXW2uGO6FG+cl1uANevR
	LmT/g4+LAMvmNA+HyxD7DRYA+vX4AlvMQdjepsRkfb4SbO8V5S5WyrQCfGF2//mnVoalX6wvPl70q
	DoeDrca5dZzxJEdeL335SVcX2F1DeXXQAP11kNtTKL6IrV9QaBDRP5e4dxRfiYFhLMkmRKuLDrF5k
	Dhg8Vn2PgUJxLj/98swn3w3Hzznf6SLl2x4aEYAcnURDk4/6aflrNliE8YpUkV1HIeJJyakLESgdV
	rRpkFqCJAUG6mWTgS9UJ22WD8m25lfqC2pCYXqLc3gZ36/mkmk6x/z4ESyI09irPXAiBmrAQo5HAp
	+8CJaSfg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7Cvn-001UJL-0a;
	Mon, 30 Mar 2026 13:45:26 +0000
Date: Mon, 30 Mar 2026 06:45:21 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/2] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <acp8wYLHDGAfhzI5@gmail.com>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
 <a88d62ee-530c-1a6e-c05f-de324f940b8f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a88d62ee-530c-1a6e-c05f-de324f940b8f@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED3264000C
X-Stat-Signature: zyw8j1579r43sah9wzcc43rcaken4z57
X-Rspam-User: 
X-HE-Tag: 1774878332-737017
X-HE-Meta: U2FsdGVkX180FTD1rz6PXhuRnq9WLLm8G04TtZO+J+JlnbjvuQWhdxLDVK386QH2R6wkbrHQdhXQzv6gDujBkQNozM07+j3+x0pWZgc+P6pF37M5+PKMrTgvkb+Bv8RaZMSO/CVNEOOuoH6mgbJNeXI69HZYb4HFzbT51dg3m01B3otA+mH8wbrrWJZIjvtGE7WFuQGI5QyZLf4trkLvZpjCYQ/2tibV7wSgUL6fChCokOGAuhiOybmwmiphprmPl3tqwl+8U3XcE6cA6OJjJuQz/+BJCz+4Y0vUzKXiJrZScKp6K3FszX0G5f27aVx2rEAZtRSkMq7q1Tza4agdxpvM5kG5+tUPFo72vvOTEeQNpv14FTKyTIOQAH8J0ygB6fbCOjd31ClILDTz/bBEf1f/F8TDVgROXFILXqrD87tIv7A20wkdQ6ByFlZng+CL+2JwmVqnaFEfAm8eLQfn+16+8T/xlYsLVj+gc6Uj+iuwrxOXFstZzrn2nFRpwwIYt6GxZvRX790FhIVdYFc11XbATFPfoYLd0nJbsoOH1aaZfnl6HVGCHGnPOqr+imyqps63v4yuXRikAtnB6pyK6myYdjYGE2XSEtzhfDcSVDpiJFgRnen6mqeBkabjmS4OeD6XtgNwF01hhHQKPv2rkpivbFWih857eYXoWbG4otX67REw6gSQXFhpkKmZx/QM2fZMzgMc0qGugjvkuhjIXjAp2ljvyVfq4g7TpP9TksZ5Zsj88KuJpXA491Ijm2NdT+5/bKNPpNjjKftbQF8ncqLk0474D8YoumSnm9lXL3Nwy76ZFSt9LtsJj3aGgYlqZ/v6puTDSWTUio9aNtG3VF/lOuQqVCichnQ9gL/E8XjjXTutn3HMDHzprucpyNWu2JMZW7E+f7djsMqdRFtitcEPG/E+dlt1m3/Iw3xqp/Ax9lpIEcgpOnzE9/FgnKaT2qQvEUJ4ohefOmmPwrY
 9brp/YKA
 TLPH06FBBXIqp+JY9bmh3w8ekOUtD2GW9HLh09o44vWD5JzSRwV6HDJ3L7mo9rXeKvkZK3KzlJqRD3bm8c2sroNeEl0VcNO0t7APCQK3qtFSqW5dUahOl+9M92vBgmKhzbZy3IqoXrUGYI6GBGhV5G1eseJl/+owoiUWicz9K15xPQyanLQ9jCSiVfeMSsHir+z9qwh55BmOPlm5+ocKfRLeWNuKZtkoIPmWf9bFr91GDaecT77Y1kIQhmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 03:55:00PM +0800, Miaohe Lin wrote:
> On 2026/3/23 23:29, Breno Leitao wrote:
>
> > @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
> >  	pr_err("%#lx: recovery action for %s: %s\n",
> >  		pfn, action_page_types[type], action_name[result]);
> >  
> > +	if (sysctl_panic_on_unrecoverable_mf &&
> > +	    type == MF_MSG_GET_HWPOISON && result == MF_IGNORED)
> > +		panic("Memory failure: %#lx: unrecoverable page", pfn);
> 
> MF_MSG_GET_HWPOISON contains some other scenarios. For example, an isolated folio will
> make get_hwpoison_page return -EIO so we will see MF_MSG_GET_HWPOISON and MF_IGNORED in
> action_result. But that's recoverable if folio is used by userspace thus panic will be
> unacceptable.
> Will it better to check type against MF_MSG_KERNEL_HIGH_ORDER?

Yes, I was discussing this with akpm, and maybe the better
approach would be to panic for types MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_KERNEL.

In both cases, it seems that, the page would not be able to migrate. What do
you think about a change like this:


@@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
        pr_err("%#lx: recovery action for %s: %s\n",
                pfn, action_page_types[type], action_name[result]);

+       if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
+           (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER))
+               panic("Memory failure: %#lx: unrecoverable page", pfn);
+
        return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }


