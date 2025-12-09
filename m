Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2196CD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797DA6B0007; Tue,  9 Dec 2025 09:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748986B0008; Tue,  9 Dec 2025 09:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E5E6B000A; Tue,  9 Dec 2025 09:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54EE46B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:48:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03309968C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:48:24 +0000 (UTC)
X-FDA: 84200213370.04.E9D839A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0626320005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:48:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3ehoGT8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765291703; a=rsa-sha256;
	cv=none;
	b=a+lehSGm9zn7Oh6Qb8HLzRQKbL2P/5RzOfOUF7Rujb/is2nT/mbPuzSTut7WDbsmc9ObAs
	H+Sd0MBa5RgeN1zkI+Ij7+l8wjpT6uFMPJFIG9oDalsm2d5366z1eLtbfyANFUMS8trcRU
	XMEKLn+Zy9FFftkzrdv7DK0EnOQWoBQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3ehoGT8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765291703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJh7H5GiF2qQLzN/OqZxU2ve8RhVtZeC3ROh/2CUAvo=;
	b=TXxXvrqgDw1Fm2T8N9xO+0BdFXSjAC3a/EIKJ7LMhei1Ji4/CZ3wzj5Xzt8ZrKEJHyWO9e
	9opKsmGZhDWazfyMs2HBmtgH7s0fOHA5wptz51x79U68NWXmPQxCvmoydyzsIOFVWQGxRB
	BG1h22uyRJ6L2eYBeWsshO9P20brX24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765291702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJh7H5GiF2qQLzN/OqZxU2ve8RhVtZeC3ROh/2CUAvo=;
	b=Q3ehoGT8ySB4JixOR+la0kkiq0snTBYo+hBdVm83P1hLYctyLemWwbqF1E7ZF0L2DDHm71
	w80oilOAdqjcyQSapaYX1ZtodOyShsCR2ja6Z0eOXgWLLA8MorEHa8TwAcxyN0p7f9lgON
	dTxGUSnkLsJJN4xjGRWYcofy6Q4kuOo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-U8a79uIlOLi4R1dHwdGDSQ-1; Tue,
 09 Dec 2025 09:48:16 -0500
X-MC-Unique: U8a79uIlOLi4R1dHwdGDSQ-1
X-Mimecast-MFC-AGG-ID: U8a79uIlOLi4R1dHwdGDSQ_1765291694
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB8DB1956080;
	Tue,  9 Dec 2025 14:48:13 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9843419560AD;
	Tue,  9 Dec 2025 14:48:00 +0000 (UTC)
Date: Tue, 9 Dec 2025 22:47:52 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v1 2/3] selftests/mm: allocate 6 hugepages in
 va_high_addr_switch.sh
Message-ID: <aTg2mKHKyq9ibFoU@gmail.com>
References: <20251207122239.3228920-1-chuhu@redhat.com>
 <20251207122239.3228920-2-chuhu@redhat.com>
 <efdd610d-a56f-4f3f-ab5c-9b0da1762ab6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efdd610d-a56f-4f3f-ab5c-9b0da1762ab6@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0626320005
X-Stat-Signature: fjq391ocjoczne1sx9bkfhoyzi3r19op
X-Rspam-User: 
X-HE-Tag: 1765291702-919691
X-HE-Meta: U2FsdGVkX18d74Wwbe5whjE06iDXlu0YQ/6Dci9aaxvOXw65KNsAt+I3GXu2AucfQlYBombGu0y+jKL/agDKq48iCpDdur7/k6qJEHLu/fOeHlu3mZyo5DhHMncqC+Q6lwo/+whXJp3S1kG4QJCZPMCmxDk5f0yBxcy5SgoRIcc2nJ6D0ANU2QATJd/ySqoxhGdfnif2NsjtRDwfsSX2fiFo4IKFSgFjFxL0WRxMfWy4QSl+jga5CmvQK7DN5d0TARUWSO1p6SSSr3Dy6yyXC+YGjAtIjBpFjuHCIbfB4FXdDwgN4s2sy2JyOtIWDHdCxHEEFsDrJ1H0+fNK09/XpNcPFt+Kbd9bVfCL2ccQDERMzFjs15LANADkGCkKWIJbpNPbOU3mtDAkYEORkDEZPLgQPrVZ6lofE3bLh0u4ZV4caTyWQnVkvFM6TQAq/Mei8MUgZhylbJ4ZKxXH2fxLA/jIrKoP25eZ0O57GZSbgrisUXImedm0X/SD+FwcHiNuKmVaGKFOGtsJ+yWY42bE4UhLGTjD7/j84s7a1CxqH4N1eUbqT3DLgLt+mRDvNZGNjUNeU7Ud5hYYXWyI6iWqARKmnhfYDbTbXVz5IrTOcUiHpiT15+QU86H2f7o1UCrLO1PrQHXeauSnLXzutArdeGKldEs75VBwVwHn1am5IJ7gPiJH6UboXHFj0PckYtwlydAikl39UW2cga+oOgIrZt7lb8LgCOYI3GluVyBs7AE8OxruEe36rGQtWtUeptAzOz7VzmGcdOVEyF2K6laemH1mwaTeVUv98NcM2SuBO3KJDe7ncK1GjMwxTmj4D33NWiFL9lV4qc/3g+XM7SC8v+KKwqIi+92nnmAVTR0OYdhcrIRfTN9Q4XPUfkNTm0fGVXnpGP5p8BGathFxO56lDhNL+0/h+Z/aFKBNm1NE5UcEgyb9q3o+TmTNGhIqUqltYWaipIG6iV43U5EmFEC
 2IM5mOnq
 5iXQ2ZZ/Bi33NuTUatoYo49fIFpZ8xzabnZ0g1Y/tVnbEpOJNTMWEbT+YgE8CpoXCj9sIfYZEZEwK+5+FYJ7VW7jZKgHnNG1dlbPc2347Slu+QIbOULAKbgPpU0yfv2TOud57oalqqjUlVbl3CUVgLr2lIRqv+AWn3zwE1pvBvTt10S5RtDyJ+gUsYFAtF/M0dwD2jfgAvGIxqEbivBCPE+O/cRDsffJVlFIyEQauAXnLfAkHptkTp6pZuFjYL1c/x+y5o/txEhTWbjuU4FU+LUc2z+f/G/5hYGA7EFvqtKnqp57ZI9GPgUJ3KGD7WMXZrH1yujR2zJjLV9mi3yOyGJ2uy38/Xzma0XAy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 10:47:19AM -0500, Luiz Capitulino wrote:
> On 2025-12-07 07:22, Chunyu Hu wrote:
> > The va_high_addr_switch test requires 6 hugepages, not 5. If running the
> > test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
> > caused by not enough hugepages:
> >    ```
> >    mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
> >    mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED
> >    ```
> > The failure can't be hit if run the tests by running 'run_vmtests.sh -t
> > hugevm' because the nr_hugepages is set to 128 at the beginning of
> > run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
> > because already enough.
> > 
> > CC: Luiz Capitulino <luizcap@redhat.com>
> > Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/va_high_addr_switch.sh | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> > index f89fe078a8e6..98f3dfab62c5 100755
> > --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> > +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> > @@ -111,8 +111,10 @@ setup_nr_hugepages()
> >   check_test_requirements
> >   save_nr_hugepages
> > -# 4 keep_mapped pages, and one for tmp usage
> > -setup_nr_hugepages 5
> > +# 5 keep_mapped hugepages are reserved in the first testings, and the last test
> > +# requires two hugepages, with one verlaped with the last second test, so one
> > +# extra, totally 6 hugepages
> 
> IMHO, I'd just say "The HugeTLB tests require 6 pages", otherwise the
> fix look good to me.

Thank you for the review. Let me update a v2 to shorten this comment as
your suggested. And change the title to 'require 6 hugepages in
va_high_addr_switch hugetlb test.

> 
> > +setup_nr_hugepages 6
> >   ./va_high_addr_switch --run-hugetlb
> >   retcode=$?
> >   restore_nr_hugepages
> 


