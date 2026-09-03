Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8B2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656AB6B0088; Thu,  3 Sep 2026 10:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607F46B008A; Thu,  3 Sep 2026 10:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F916B0096; Thu,  3 Sep 2026 10:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D79F6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:48:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B41EA40551
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:48:08 +0000 (UTC)
X-FDA: 85172731056.16.497A2E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 049CBC0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:48:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9zILBjJ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788446887;
	b=nLCTm/z2HL1e0H7DafoF30KaAzEB+kayuuy1LObT/xV22Fp7VtZ02mBnEwDXi0WKpAasw3
	JytSGq/139O4g5ukpE1zcUZBGP61IaQqKHDopX9rwxZ0Zimr3kZa7buieRwoO84bdVgLjg
	FLyEsuWAZBDJUvffV0wffFZgPp7SVns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788446887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISrEx0BSVBWyWukW0eR4OzeJE1oiiH266P39phBJYW4=;
	b=mtBBSeFqy1c4YcCZQVcSbH+rfGjltVofzsxIpOuK+OaQhB+WGtDKX6BXo6CG8fcvRz4M49
	lMco3yXvRkquUZangJQKSPXa8dLA3Dz/wuQxWrJAPibAR2BjNAxGwyV856LkXCY4rmJ6HI
	WZyLTf9tT/hBG33HcjWPFNVwTtOT+IQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9zILBjJ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F1F6414B4;
	Thu,  3 Sep 2026 14:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5C1F000E9;
	Thu,  3 Sep 2026 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788446886;
	bh=ISrEx0BSVBWyWukW0eR4OzeJE1oiiH266P39phBJYW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T9zILBjJvlXqgZnbl+t/5TzLTNPaRoMdSRwbPPU3Y3krCQy9j8Sz+O0SAna9P4k+1
	 0HTyvWd33XIJ0VYCXB/sBt0bJ1aoWcQ5vyDIegD9H1fRbGSK5bJkgqWli3lJ7ztNsI
	 diGsGwWTrIVseGFQcsUAabfpyxdEaFZudgcPxU8nvZYanuWQxVYnfUrikSl5nI8kP1
	 hYppWhY0fdZR0k7bqZaaAGzTZ6fWy3CbjShYGD1belX5Bj+kVhg9xCFNDFwA7dQgxE
	 6S1IRTSPPpmw7mfzQk+X9WlotxluioJw0Eli48tlYpuM3Tx9dBxyanbguNB3cMjlFR
	 8vesLPeAq5G+A==
Date: Thu, 3 Sep 2026 15:47:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <apmIlI3Ooe8b95Ro@gremlin>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
 <apk1WVEDYtQhRxWR@gremlin>
 <aplcf7sDnfKQTYo0@e129823.arm.com>
 <apmIPJKj7JGwF7nz@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apmIPJKj7JGwF7nz@e129823.arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 049CBC0003
X-Stat-Signature: zy8ixym9wqco16bzcmpeihmgprpzxzxi
X-HE-Tag: 1788446886-237966
X-HE-Meta: U2FsdGVkX18dGLodbNlckxV76Wbf2rp5+UnT+FpG8s1twKPWLo/XTiVcllvMWkF92MauOZag8c+ydtD540FJn3EKrfwAMM0qHNbOE9y5kftf8oxx40FRPbDrQEDnss84LS58JV0Io18rnL7vxxy+WvoQbJmlvUNsv5XdOcYVEVDdWW92K8Onf7QA3ttMBMPp47YZsU+TmF3YY1gDobMVv08c65mkzlwBSNf1V1f4oVqV24PwYFJ6kWeNDsAPvgGtYegVHphn8HQAW6Zf2XyI39cIQGJMJv34WlhNYkvBKpB7Q4PgIeO0U08pbHeZzNsAU3GNIA8Y91pyF62AeG3HIQv0KDK8BPFnjRFiLdxOOWsEI164izEAC86mXTpLBM8QSVhBKqeULUfb4PHgAdDSf2RxvavjFlfIu1Tb750XT76NP0Jhfk0Fk+kWqgzmc96adNe0cNQOYX8oiteLapu4PezTTIBRzBVDmXtLe08IJkcR2O9ZBUpGOmokBDKBfJijUoa0lZyGLKK+sO8ReYVCmgwiJK9/ddWw1Gzkpg+WxwQZ3JivDYflTJM4kgnwNRpej8psa9InMv9Q4cVFWIgLgdNsQDJ6yY1AH7Q27mdbrLxZ75MyJcYhntKKqtQFiSzsWbJLXDYbhh5eA6JAYV8nMSBP4yU56d1b97s8yxfKxDUpe5X69U08jIEnj5sXk1qvhtgh4H8eVxTKNcIYtPmPsZXpmKXY2d1JrBoi6ytc03Z6dJ2YKAO41VJDaaa2Qj13vsjLBrrtyE+uA0cKrebPzpXA7TNUKcoMRcGK+19j+HGdWU4jGQ2W8wc/s6PkcZQvAKg/m0veh0HBP9gQSrczKAAyBNOZIrfpAePLDpID0jwygWkS1QLeOIJtR0Wd4VMw/rHsNFuoy/jRGBzIUn6qLESsmTKPs14dhtLGWORI42f4OwVzUzcubxKyobB383PV8bVDZkVintL+7XWhxuK
 FTDxF+yp
 MnFEMzoAWYbbcvx3JoIVT952+BC2EOa/b9NqkyBaKoUDgNV1QwvSyjTj2pQjh7L84bIFLpLsXAthWRTX4jn/KgNPcTivxWxeBrmM/gizSDCB/MxAKiQND44/9G7yZMw9nJP3nj5nNVaUO4AIKkaU5dOFSeApw1cVPCLnw/bOBDdLN9VedYoTqYpQFW+2zLf6EGKb/pnPJdsJfbwat5zoiPtPX1/zb3S5e3bTwGYc3asNu0p2i0oW1Rab4GZo3uCPvz+8DGg35yV2UBIFQbqDkBEoyoXFRJYnQ7CU9BaUCBw6CuII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 03:46:20PM +0100, Yeoreum Yun wrote:
> > > On Wed, Sep 02, 2026 at 06:56:11PM +0100, Yeoreum Yun wrote:
> > > > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > > > When this macro is used in some test, test result would be strange in
> > > > the system where PAGE_SIZE is more than 4KB.
> > > >
> > > > Here is example with transhuge-stress test with 16KB PAGE_SIZE:
> > > >
> > > >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> > > >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> > > >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > > >     ...
> > > >   ok 1 Completed
> > > >
> > > > Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> > > > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> > > > helper, read_pmd_pagesize().
> > > >
> > > > Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> > > > is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
> > >
> > > Probably worth spelling out Least Common Denominator for those who might
> > > mistaken this for a kind of display panel :P
> >
> > Bad typo :( LCM (least common multiple) :(
> >
> > >
> > > I also wonder if it's worth pulling that out as a separate patch in a series for
> > > better bisectability?
> >
> > Okay. I'll separate it.
>
> Hmm, I think it would be better to keep the change as is, including the
> updated ksm_tests parameter. Although allocate_transhuge() correctly
> allocates mappings aligned to the PMD page size, `ksm_tests -H -s 100`
> would otherwise fail because 100 MiB is not a multiple of the PMD page
> size.

OK, just add a note about it in the commit msg :)

>
> [...]
>
> --
> Sincerely,
> Yeoreum Yun

--
Cheers, Lorenzo

