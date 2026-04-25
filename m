Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6967FF885D
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DBC6B0005; Sat, 25 Apr 2026 05:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8856B008A; Sat, 25 Apr 2026 05:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EF16B008C; Sat, 25 Apr 2026 05:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A231E6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:20:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 302521602D7
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:20:10 +0000 (UTC)
X-FDA: 84696531780.01.04BC105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E29240006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppJESJUT;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777108808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRPoJc/f5jPzCB/9uV71kcICbEvqEdIYan1fyiLZQE0=;
	b=8O8LbOUlZDk/RHEXje6jDV4qh4hwCGbQE0ucAb5mj2qHsW3eknCYZmlOvrTiuNTfqE8BHy
	bYJ+soWhG1lyowVYmjZjSFD5WInX+pRc1jlzh+Kx6aANdzowJaA00/Z39rMScu6O1nBodP
	cpfylmlzH83G4a7bpFGsFO1WF0oO7Fo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppJESJUT;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777108808; a=rsa-sha256;
	cv=none;
	b=6YP5p2gJbcWh+KJFd2BnxfJE4oHr4ifSCNR6Fl2Nf2a2MlA/EnUW+M5X3OrHrEDHn5Yr15
	LmtEqwIrNJNOHbrxm1lCgo/zQfyF0uWJyMQW3okWsHussxSthS2E1v4C9lS+KmZhwgAisM
	dcemuxA+IrmU04wPbxw3zlxLkPh3kLM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF03060052;
	Sat, 25 Apr 2026 09:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06160C2BCB0;
	Sat, 25 Apr 2026 09:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777108807;
	bh=UpHIvSShmli0yvarMS8zFU7rWyK9POcDK0gwCighl1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ppJESJUTnMlIchUddBtrKRhcr7r+Qgy6mLfBp5t3RFZe4nWSyeowsFGg62sSKPTD8
	 IA3aIzpjB/q6yglJ8grs+J3qIhOSRpOGXK/PNwup7Cwr5dPirwVyKMn7rNbtyyybVf
	 POkt1sD4/mtUOgWLhYI1MgptaUIsSxhqR4pByNgXmglzMIsttGt1eIuabZJHOf/nM6
	 +nuPUSO/myAaAIbkJy1alH0o+NExCuD150U2Jq4Qiej/IVM6BiBLXSR54W0mwjwZ1k
	 SSB8GfbYATdr72GJhcqxGH++88tYSE/pgGKov5x0axX30S8G3PsLCtjQTcXxw7rvDB
	 XtYJWbjZYl7Fw==
Date: Sat, 25 Apr 2026 11:19:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 03/53] selftests/mm: migration: don't assume hupe page
 is TWOMEG
Message-ID: <aeyHO4PJoWk9siqB@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-4-rppt@kernel.org>
 <c1e9cc74-e831-4068-9d34-1f3a665b3fd6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1e9cc74-e831-4068-9d34-1f3a665b3fd6@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E29240006
X-Stat-Signature: jxnz8fssycnxrwog58kwyuhxh85fbne8
X-HE-Tag: 1777108808-553236
X-HE-Meta: U2FsdGVkX196BPdSXTueD1a9QBd9THbTsdlgxvgkRIWLGT5myBEgaN4GqEPZv6HtpfCWwiay0hikaoCoOBAY2r9tBFNEjoXgciEuyF7mM87XLu1QknSGw/vblcav3OMKFkayYTC8/g3ohEmsHdoJOskWzQbVMrMDCEWaAVorQdftrmMSeImI7hWNsuuYds+l08xJyA6+WQ8NbXHX4MvOScs+LzaloQGJa4p453PzniTquGFIEPDmIYRswxtEgDUnJoU3dKW8Lln8bSmu2gU7XPyMBiSVF57G6phwAkHM1YlIxrxg0wmOGOXGsW9rXMECywyHO+5PU3w5t5UPG5mbl7IXAgitIz3+HDxSHWyb7CoJ9mB2OkMSSidm5wiFQcs7pvPFZfh/R5VcZ1+LqwzG/Jon7eqbIBCYr+8akxJ9hVp7kN8CGaRC11uKt5fioxzbLjv4DQfCmQuBOpHUJpdV+qR6ZP4dsmZWHbdSiboKrKMGQt8ydmmEaW0xDIvkl0lC4etSmrxsdhlN40entok2CaOcMPjkXfD1xpTTGTYV2abEkJTlHaJKZBGCPEUOTBoIUGDwOPLGZJrCZTsVO9RS3WinM2KhshdbSQZifrFYJ2noDIpwpbi8wqBMIaTJrwoVps1ae0MIuHXEDyIUucbqYrHQ0li2C92eR5L1PzmgbSXd+RE9uLVDU+O8mudjJC0XxdChJMf1w+kLv/6LHx/twxC6fWB2eUUhM1UbYFzQwKQHKml6KlyLvhaUSb619Ag9GZPuydTvcBUGmeOvRvO3otclf4zkphj9oTlbANPpIy2CZor/7EdzU196IyLYPAOl7E4sgz+RAcVGYg+Qn/GEczFr70OmtBVIX9thqOgzf8w6V7IMgrfkLPdtjXb5zhnYahRDn0hSnJ0+XaPANmiWuMxzSBpAUx7tDSkAd/9/+ny1HqnaGe3dy0sgj8/bAf8l5oHWcny05CdBWW0Y1o9
 /9lKz+tD
 77oDwPaR4kqPHpX13DzLQe62Zg3vYOr4ptW9pdUiCil9WvOgA+gI8IpdAw/30NVuQetAFSl4oL1TjXv9Bi1AP8Ky6RuJoSKG7zhodPRpLmnw4f2RK88np6LecgBvc7wsOLTcHJLacG5v7GBjhP+vd0ZACjzeHzKSjf+6MsBmmdI4AlZOnxAEt7ukkzsc7mBhIyU/5407fsaEUJ3DoQHsg+FjRgJqnlqt28Nz2fZB9AHQ0Pzh10C5i1p6QgibsnUZjslcyfyvgPNETSwDoJQu8yHYUxv0QaMNwHXBhPYOcb+HTUIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 01:14:44PM -0400, Luiz Capitulino wrote:
> On 2026-04-18 06:54, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > migration tests presume that both THP and HugeTLB huge pages are 2MB.
> > 
> > Add dynamic detection of huge page size with read_pmd_pagesize() for THP
> > and with default_huge_page_size() for HugeTLB.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Reviewed by: Donet Tom <donettom@linux.ibm.com>
> > ---
> >   tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
> >   1 file changed, 32 insertions(+), 12 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> > index 60e78bbfc0e3..e3c2f831e15a 100644
> > --- a/tools/testing/selftests/mm/migration.c
> > +++ b/tools/testing/selftests/mm/migration.c
> > @@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
> >    */
> >   TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
> >   {
> > +	unsigned long pmdsize;
> >   	uint64_t *ptr;
> >   	int i;
> >   	if (!thp_is_enabled())
> >   		SKIP(return, "Transparent Hugepages not available");
> > +	pmdsize = read_pmd_pagesize();
> 
> This is really minor, but I'd match read_pmd_pagesize()'s uint64_t
> return type.

Ack.

-- 
Sincerely yours,
Mike.

