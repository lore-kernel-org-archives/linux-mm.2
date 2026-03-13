Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A80107BCD5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 18:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631806B0089; Fri, 13 Mar 2026 14:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBAD6B008A; Fri, 13 Mar 2026 14:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5089D6B008C; Fri, 13 Mar 2026 14:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE416B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:01:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF86A1A029D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:01:22 +0000 (UTC)
X-FDA: 84541806804.20.0D30236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD41820018
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:01:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTB3aETE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773424880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+FEMvEiNfD5fuHhmuOxnOQzrqWlcUgZqRT655Uz6o0=;
	b=RubzytAnPVRpnLOVAJ1NWv6yKZuUW9RSF8KdgjbsmX65L+rdBqm9AgD0JECYHH845TowJa
	7rwtPjlKFg2zj8NOmYNi97cTi+H1o+0DZ1WUbp2tSxyAss+QZyAv5RIAQxlEd4DrpxTlLV
	rVyW24bBoQvSVk7F8tywQL8EdGbgr4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773424880; a=rsa-sha256;
	cv=none;
	b=Do0/T3fKqafZbTo+TC5dSIjmJMmvbw9yLu7lFjEN7Vsfv5yvCCQKvANkKYMGlhJgUMAu6K
	HfvkanHpZkqQqxNKG3OlPLdwHL70316mBks64PtkSm3U/9wSfHqOKVfVRihHD5JeV6OpDE
	VqflZmp6gVhACvlMrZff50mD9nB2/EY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTB3aETE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 878CE44361;
	Fri, 13 Mar 2026 18:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79BEC19424;
	Fri, 13 Mar 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773424879;
	bh=MRzGhrN9hVB2ZGyVFh5yWabHT/MNGX9ojKRdz5/Xkvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oTB3aETEPFbMFd1V2117aVAW9Pg22Xn73fZp3/WCMkLiJnEkurTHr93HA0Zkj+m6h
	 L9khE7FeruWr9tfW/SPZgWtKrrglrpa3x2CT91Mjewrw2EreQ/dr6eB6BedfqfcxQ/
	 kYa3anCs35ma72duwKhUmsH/mPriCCXIFRm2NlLUr1FOYtQrdR66obbCkb0ZGnlv7F
	 +wVSWPAa81bjcPcKLXB5daOLsOTt3srjLSA5EIWqFnB7hHMC9Ea637oKqpWsAhFeNb
	 Sx2sjr5a4nEg3oO+WymUK4S8i4VAiQE9nup7ZpSV//ORiSK4ihRMfMsvmq+op8PTV6
	 6ietsbRCeYc3A==
Date: Fri, 13 Mar 2026 18:01:12 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 4/4] selftests/mm: transhuge_stress: skip the test
 when thp not available
Message-ID: <121d35f0-c46f-4c03-a470-8e8969181fe4@lucifer.local>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-5-chuhu@redhat.com>
 <708647e9-fc49-430c-a12c-f2b44caa273d@kernel.org>
 <abN5z5jpKL2GOWc3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abN5z5jpKL2GOWc3@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD41820018
X-Stat-Signature: q67498iy434a9je1hqyyoy68e5wzszjx
X-Rspam-User: 
X-HE-Tag: 1773424880-273381
X-HE-Meta: U2FsdGVkX1/B6wRMznliCFGbPfSHMk1kayzEP9XsAtYCpeDaNVLKW4KdXelOrQM9p6iKtWx5NJ7MxNMm14YKQFDXpIICX22Aui1U0xcVP1rPncTJBNI18CWHGe52WouXSeEUqCwjUuKOGBC8d2bTT14+AqK4fvAuA2P3XPQwnC9rKMxOC67INFVQHV6T1p4PLRXwwLM2sS192b3lJE+q0u57vSgAbJJ32e7BMCrBBu/p/E1E8loU5vTHE5xmMunk2b5tupN4C+s9uGMT3FrxTK1SeDLn0tnL3kN61DyOgtxF5rG7ZJu849fFAR1yL5FUVZqsozLNKtuwJxDvE/FeKewXeA9EupcYb+XwarLouDrq1iWnw9DVyMLLMTuq9Fr8Ebt/9Dd231br3VtEksYilIv5O6zSVT0DnpSCMo7E7DLVZ9nl2SMSWKFgoqvfmDf5C3eTbqBow1mk+fw1i87J9GySq5i4/FYl6UNkpKQlIZZc03WH0xqD4nYWBIcphPLHOHZQDW0Ox1xbypl+3uUHbr332SU0HHF3nbkvLQ+6XlVJ/cz+K//P2YoAf7GPf9RbfZMh1BA20nN0UQbsBKxxdtbYZeVDJ01bky4qCnEQQlZtgwIdzXDWm06Bu96RKb4jXh2z1zDyTdIWstzQhA56GvcYvfEZXA+BoE3hdrUY2SHYGWXhotgD4CgKg9Km7IEcoR0dzjCXLPrOcbT0NiCO/zc6HuLurZZ8cChDALkTPP9ZMCuDVuN8qw7SAQ+BFnnY5x+kh85vWCO+McVTrabGkdNCxjpaTk0Ho4/BwMsywZYsAF5uQoCjHpSO+fMgNwwRXMzb2wUQxfL8W5w0Pg00+dv2WL2FQuubXtp92oWaqkKX07PYR+xEAAzmt2dx0H6og13GHu8/qAszrNf+JzsvP/DIiclqFTymOoEWNj521W++k1r13rhPbvuHSWuJKk86MYlEpYMNO8/SvXtbYeN
 W1MK3WL4
 c9NnGxnEjkPu2+BwDYbJgVn4nJIfKoGwGm54DH1eKMc2e+ITWnWl9K2CqaTga8q9uJz+Dn+e2exPoHgUuhZ9etr2CS02s2F5KaQyXDfPIObTFOStxi04Gb4O/jDNAu0b0SzaCD5XAaZ02HeEfI8EYKEP3m2DSABI9cwaH27CQiwkI9y9uxdQZ9DOyTHVDeQEYlaHCnKXfVqMCS2GPIA5s1czWKRiosm3n3JgYvtNk1JPSN10maeC9L5/PUjR/CTYpk+gRs5qGjIaDZPa+0EI+F9H1Mq9V1w2pTnsLFmyMJa5Hqs3mGNkPI+Y86Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:43:27AM +0800, Chunyu Hu wrote:
> On Thu, Mar 12, 2026 at 08:46:23PM +0100, David Hildenbrand (Arm) wrote:
> > On 3/12/26 12:40, Chunyu Hu wrote:
> > > The test requires thp, skip the test when thp is not available to avoid
> > > false positive.
> > >
> > > Tested with thp disabled kernel.
> > > Before the fix:
> > >   # --------------------------------
> > >   # running ./transhuge-stress -d 20
> > >   # --------------------------------
> > >   # TAP version 13
> > >   # 1..1
> > >   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
> > >   # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
> > >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> > >   # [FAIL]
> > >   not ok 60 transhuge-stress -d 20 # exit=1
> > >
> > > After the fix:
> > >   # --------------------------------
> > >   # running ./transhuge-stress -d 20
> > >   # --------------------------------
> > >   # 1..0 # SKIP Transparent Hugepages not available
> > >   # [SKIP]
> > >   ok 5 transhuge-stress -d 20 # SKIP
> > >
> > > CC: Li Wang <liwang@redhat.com>
> > > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > > ---
> > >  tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> > > index bcad47c09518..76316696426d 100644
> > > --- a/tools/testing/selftests/mm/transhuge-stress.c
> > > +++ b/tools/testing/selftests/mm/transhuge-stress.c
> > > @@ -17,6 +17,7 @@
> > >  #include <sys/mman.h>
> > >  #include "vm_util.h"
> > >  #include "kselftest.h"
> > > +#include "thp_settings.h"
> > >
> > >  int backing_fd = -1;
> > >  int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
> > > @@ -35,6 +36,9 @@ int main(int argc, char **argv)
> > >  	int pagemap_fd;
> > >  	int duration = 0;
> > >
> > > +	if (!thp_is_enabled())
> > > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > > +
> > >  	ksft_print_header();
> >
> > Shouldn't that go under the ksft_print_header(), like you did in patch #3?
>
> It will print the TAP version. I'll change in v2 as you suggested. Thanks!

With that done, LGTM and:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

>
> >
> > --
> > Cheers,
> >
> > David
> >
>

Cheers, Lorenzo

