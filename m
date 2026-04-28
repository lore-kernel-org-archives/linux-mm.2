Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE698FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 05:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218C46B0088; Tue, 28 Apr 2026 01:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9A46B008A; Tue, 28 Apr 2026 01:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B83E6B008C; Tue, 28 Apr 2026 01:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC7F66B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:49:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79257404DC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:48:38 +0000 (UTC)
X-FDA: 84706885116.11.9C23050
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4C5B140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:48:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGKCutFN;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777355316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kks17SaShzhfVhgeIFmmLTLAl/hG89eok1++AuLAEV8=;
	b=nFaJmKftnVWa5qDJtMUxY5HvkxI9gN8lcXPCoIiv88bkF+YvGe0hEbvK7zj8NSxvONGA1G
	WzvWDqNdKGSz4k0BDxgc4PONze0ilbVmMw0uIKTOk7Q68PPTxFI4U92xPQ6WVQIfo43q8k
	Ab8kDWgNcQlBQWzQK+c0zTEINHBesdc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGKCutFN;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777355316; a=rsa-sha256;
	cv=none;
	b=ZqbUewmHbzBnaBbQGIytcdYMNHYrWIUyfWhgG2Hfampc+XIm7ujyPuPWx5L3KAVItbjwEp
	zTwQdS/CYNNb88DNWNZ2ATUa8IJ1Wk3ge7T19cdkZnkzjIYAcOyHG9jYMwOidWqfz+DD3p
	AhFtcRyvxXzlxWRGleOdzBbgwfT7bfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B68934060B;
	Tue, 28 Apr 2026 05:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C0C2BCAF;
	Tue, 28 Apr 2026 05:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777355315;
	bh=EdPSc+WMWGhg4RFoHQwwCJBiIBgm1vzCd/Q0/u0vbUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGKCutFN123k6dj8oOb6F2qm17O+ZlRbm1g65QIeeCO3Ixd8+EVkVtAssaRwGiOus
	 6T7sWrkcxTMlJu4A/QzzpKRyCtNUJv5om7B2hVfPiK34BIjbF4TFkN+22fMq/ySom5
	 P/xLChAnY/KUe/j1/vhoEtS/ee6No9lsk3bgrEOoexoLa8t39gv98kuDCv94MZaOAs
	 VTILVWtfyGoOxwCIeeYEV7QLUycalFi4AaJaj5g5dtCtXyz5lRqrFP0bVyRsYpeRNx
	 IbLELRLF0nK4uBIppwCdwGlOfi7NuXXDkYx6/WoFArpjXinNUylIzHwFHVApKdfkv8
	 kMDx4njkrvp0w==
Date: Tue, 28 Apr 2026 07:48:22 +0200
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
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
Message-ID: <afBKJn_EjaTAe4A-@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
 <ae3v1cyMLbcvJtYW@kernel.org>
 <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
 <ae-UCVba16jg3-gR@kernel.org>
 <0e2ef2c0-d74e-4aff-bba0-6dd91dbd4e41@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e2ef2c0-d74e-4aff-bba0-6dd91dbd4e41@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C5B140002
X-Rspamd-Server: rspam06
X-Stat-Signature: dyw5ngqghdi6qfp381hhtcb9jdbn5nfu
X-HE-Tag: 1777355316-283929
X-HE-Meta: U2FsdGVkX1/0ILqc66CNnPKJu7eJPOAqByxZHQVCANxYLMiEqsK41ARnFRVDBzm5jxFxzG5P5rgi3g2qiwnUVHDH/T2amHJEwgi+eCuLqOalpSM9HryB1Z2U86lTPneKCGnlcTreRz6dUC72W9C3sg/nIPC1yr9VZAJKFq8X5axXdxpIhnAXgU53eJYKfwXHNAuCFfb2XM7vc+AV1HW/rXsCvvOEFmMsQgh/M207FW5/mbsOu1aAaAq1VOQKFs2vD1mLZjOlirO/7rr0XA3sk4ijWudZjWRgjIr5mrTtAgwqLcSGhVvV5vR9f+GVWD8o0p+FoWfx1+Rp1KLE2dZ0XmBOmL82GuFRUBsl3R2Lka7Qx20Su2+7roMcXx9aFCcdiK3mzjwnbKbSsBP01pKi7GxazaALD4lZdoh0VQSBh/7M0JtydiY/BRWqE6AehR1zkY6AU360bJmuJHrx1D0ZBUGEsxKuQSBi4YayeqSZzXhTplRyEz24Vkis3eRYXfjrIMAvG21PmIi7Z1KyJipGqiOKrpOzEXZ3FUeYxgtI3Dm/7pmntS27i9sDfeXL7UOxkx8qCPSjH0bATDAKi8ABdu+dEI2rO8ekXJXp0oePberOor+BPhyYEsqbLV+Olxc0p3yTeWLxLHGvFFO9UUQaBqovy3afM0NqElOtfv1+GeNtQ1Ld1HTfg4dlpdqbMw7raYERD5FIPxlYLJSOCzeysvA5HsPaukyyXBA3INvNx/SN4+ryOQlZGXJyeWNTV/J1fDOzMfmEhJyUtY0+XI4dEx7bClNZqHS6PxJfLJtirf+VnyszgiMNlhTYvSS2dKenwP6LkV8FY325gjJ8w42OUKVjRFUQ1w6ALxvQht2FSwbEZmAbN0ooFW6q9+SiDQ29lYE0oQ6JWT7+/DOu6fm3+76I0tn+htd99tHhuQccNbBaU6oOwSzFAcnLaUmK1HHzn78TSB57JI26OkX4Iie
 tK15smvD
 Ua8wuja0/FwQscSlArUF0h+iJiZKAfHVIzTc8jpxY2QyWL5/nP5io7UyUysJkQJ/09bqmTUvQCqKUglaxl1RNQvSvObKtRDTa+R8a/ucA2umpTzHfpG5zKr6XNrg4Xy6XaMEGUyfDJYSqw6FnjXWbXCu6TmcXDThvTe61ytDr4hpMQngcZ+qsQEkXXeG7ZXNDpBkvlY8iHChL1liKvIK+Ze4nxFxFIZia15QYwRh+5ovGdQxMzXso0rG8Wd3zVLvlNo4thg3B+lbfEjvx4PXb6VHhGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:19:07PM -0400, Luiz Capitulino wrote:
> On 2026-04-27 12:51, Mike Rapoport wrote:
> > On Mon, Apr 27, 2026 at 08:56:27AM -0400, Luiz Capitulino wrote:
> > > On 2026-04-26 06:58, Mike Rapoport wrote:
> > > > > And there's another issue: when running the migration test individually,
> > > > > private_anon_htlb gets skipped. I guess it's because the previous test
> > > > > is restoring the HugeTLB state:
> > > > 
> > > > It could be.
> > > > 
> > > > I pushed the updated version that has the fixes for both zombie and
> > > > signal issues:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3
> > > > 
> > > > Would be great if you can test it in your setup.
> > > 
> > > This works! Both issues are fixed: the migration test completes w/o
> > > hanging and when I run it individually all tests run.
> > 
> > Thanks for confirming!
> > > One last question: should we munmap() the mappings in this test? Though
> > > I understand this goes beyond your series goal.
> > 
> > We could, but the tests _exit() anyway as a part of kselftest_harness, so
> > it does not really matter.
> 
> OK. Just to clarify that I meant exercising the munmap() path, not that
> we're not freeing resources. But if we know that _exit() is sufficient
> for this, then it's fine.

exit tears down all the mappings, but the code path is slightly different
than calling munmap().

We can add munmap() calls there, but let's do it separately from this
series. 

-- 
Sincerely yours,
Mike.

