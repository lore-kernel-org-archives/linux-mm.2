Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F3D105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0146B0089; Fri, 13 Mar 2026 11:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DC66B0092; Fri, 13 Mar 2026 11:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4146B0093; Fri, 13 Mar 2026 11:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5F06B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:19:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E04141399E7
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:19:32 +0000 (UTC)
X-FDA: 84541398984.11.92511BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 389E1140008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:19:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ej3fenwU;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773415171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7KxPJorKCX7mFY1hNww4Jwnl46BNHRnS7/CCe11wvI=;
	b=e/PzRZqRjgiSsQ5q1/xaqnIFUe1UbQ8nWDuvVILo4Dor8uBKbBhlBkD0UDRgbtfbljQTJa
	aMoMYTVd4Da9ko7eN0qMrPcfl60UtJMXbW8tvQutUCItKtV3TNB6erTE/KPJxmBMUGz3zx
	CdjLg3f+2W+rKVWCbSb1BqIDh+f/n48=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ej3fenwU;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773415171; a=rsa-sha256;
	cv=none;
	b=XN/eon3aTenjjc63G4bWXrS5PVSJtAbMdwoCYjsFxmshYApbldRcFyS++X6Hc0LrzFFPsU
	gdugxMxVvjJsKx7mbUDFNZ9aPqCDPXbKavEEnbR4BA9ajobfIZg/ngR/DL6nr8SdCaddoa
	y7KazpQBe/MPLysj4R4bjAa6tpOmViM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 782D561843;
	Fri, 13 Mar 2026 15:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E268C19421;
	Fri, 13 Mar 2026 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773415170;
	bh=upgXH5FQcgGip5m+WEM2EL5BEmevnHCGmPvU2Fnkj+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ej3fenwU7ZNxV+t8CeOoTK4z/PpDPzKZ2CWbxzdLP9h6tNFm0kvHP4tsQJTZ7eiqP
	 tksjxO2fZew7oWFELdX+xngRg9cVlsqinaiD9zRwBBSDq3mC/RIFG+OzXsP0fdcI6B
	 bDrdJWwspTjUDePvf+hbAfYUqT84CQ841Xhea0gA1n4zQPduJjWok+KVDJ2DAgRBTu
	 q7/MWBaxIx9teU4VNzGwYuXE5duGq/tAn8O1wEXPC2PglMw3kFvp4jq4/2VMm39zhI
	 eG2C0mgrRSvZqyBxqizbILdhryeIMHrruyob2NzwYCuLyCNJGKXkXcvLV2n0npPibJ
	 NI+UgubaEer2w==
Date: Fri, 13 Mar 2026 17:19:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abQq-Mt0p3vz5rQm@kernel.org>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <abLHz2qjdeNqdFaZ@kernel.org>
 <abNZmiL2C7KMQM1t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abNZmiL2C7KMQM1t@gmail.com>
X-Stat-Signature: 87djj3xkyz3ddd3fo3rettxb3ptnukrz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 389E1140008
X-HE-Tag: 1773415171-369033
X-HE-Meta: U2FsdGVkX1/51B4ESAEWahQn2z8eNbKmI3sSSTsiLaWn0qSkMEXD3BJtU2BPLKp7EaOIwOyT5gE2AxsdzgAgJRKCJ+MhtejWmbQEyRRv1z6XmtmIpoWyDMJlCTTywslyiHAhmOG8hck80xNGLJoO3y4D/eEkI+O60pNz2yC5FY3avy2w28tWBqWefW38w8pBlFD52MGqT7NcdrNJer57ldJfp8aRggs4zuulb1zs1y525nqsr4WoMS1sLxGaU9KQ/JOBAfqGikzN+z0/MaVxWYKdneg12mXTNNO3siWfQadBHh1MLCAZOyaxtrXziAZA0HvWre2gC6e1od/Cu/ZitVoamqAfl2ile5YPCccAYX5tRKrzxq1Xf9EOYyPMeLf2IwJEi8TIOOY7GsJCOK/0r7mw++idNUo4aNveYhPO38t1AbUCJ4Kk1yYFA30Jru2IesAZu+hdDHXQolsdge43r07QKNHCB0mHHxGjeIncSh4XwtSJY5y9/gc6WGbHLrKF2lLN8f+Jsd3wbSzaorXzOsaGSfhyo6HSD+lZiHEl2VIMoc2fk22NjnGSGs2EmGwdwZUqVC1QiVVQdUkWgAl+O3uODPofUxNplfMGPHDelYdc6UE7Yy/2N8RW9ZiuU+oVVBUmMCf4u1ynTYMqfF8kz0ElQOzLPGOzNVydApA0wLQ83gKlCyjOsJf0vMtTDCNMRWRAWyM5gidQZoqMD4ceQUk6UhIVLRwem4UgbGIINar3/pa4inzWGHWrOLFA2cL99ASUZMZwrw5CXhX2tnXqa5TX7cE6lYOTvJ4muAac+yrEyDISfZhJ0fq3JeyP10d+EmYaXQl83dOVQN7d0DnF8gHW5B0KGaGqwMqezjIWVCnUbqAZfhtSlZ/AJvlazYZh0KjmEBpjMW7+tFnVJmH3y7GfFSfbOK5Z61x0E6wgmHQtzMwW9UdqFTTrMv0T0C9nRDb+6QWBBj5kxCDSAtV
 8UwU/3zQ
 Zvwy15DKAcHa6M3aHm6IqLfcdlWQU5BYJDZULFpBb+zw7Ip5s+DU1CXzatpp1GoYC4Cb6cqzRQOr0WbRxSdRcrnFZaCcZmBOqMPxfacfivEqATJI0YqPkORvUifgf0sCnhTghtKc2SU1Bv8prhwBIN7Ek6ffwjoQOr+LXrhArEt/Oe4O6WsbeiNiFFZmCJ0dLCVkjvjJ9czPxv5ovKPueeURAa1TlzhxeIY0G4tQgte4EiZqBe/brUo1IQhdLDcuQIuQT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 08:26:02AM +0800, Chunyu Hu wrote:
> On Thu, Mar 12, 2026 at 04:03:59PM +0200, Mike Rapoport wrote:
> > On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> > > There are several tests requires transprarent hugepages, when run on thp
> > > disabled kernel such as realtime kernel, there will be false positve.
> > 
> > I presume that when THP tests run on kernels with THP disabled they fail
> > and it would be a false negative rather than false positive.
> 
> This is an interesting point. I'm not naitive speaker. I just learned
> from AI. It really matters what we define as 'postive'. I presume 'postive'
> is we run selftest and got a failure report, that's postive, not thinking
> as it's thp disabled kernel and a 'pass' is postive.

I think that a passing test is "positive" and a failing test is "negative".
So a test that fails because of misconfiguration is a false negative to me.
 
> I'll add statement about 'postive' in v2 like "a test failure is
> defiend as postive"
> 
> > 
> > > Mark those tests as skip when thp is not available.
> > > 
> > > Chunye Hu (4):
> > >   selftests/mm/guard-regions: skip collapse test when thp not enabled
> > >   selftests/mm: soft-dirty: skip two tests when thp not available
> > >   selftests/mm: split_huge_page_test: skip the test when thp not
> > >     available
> > >   selftests/mm: transhuge_stress: skip the test when thp not available
> > > 
> > >  tools/testing/selftests/mm/guard-regions.c        | 4 ++++
> > >  tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
> > >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> > >  tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
> > >  4 files changed, 18 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
> > > -- 
> > > 2.53.0
> > > 
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> > 
> 

-- 
Sincerely yours,
Mike.

