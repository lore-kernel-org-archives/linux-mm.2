Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CB6EBFD26
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3416B0089; Mon, 13 Apr 2026 06:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB1E6B008A; Mon, 13 Apr 2026 06:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807AC6B0092; Mon, 13 Apr 2026 06:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD0D6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:19:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 124E01B5248
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:19:07 +0000 (UTC)
X-FDA: 84653134734.29.49C0A25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6435C40003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:19:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZjt1T1k;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776075545; a=rsa-sha256;
	cv=none;
	b=eqmHkQ5O9T/M3RojKsuB+bPmISWU4dtqVspVWF+vXa7lVDXuigA0wT7oCHvpPkCYKaPuLO
	IHjOEaMOOCz63/aIGfZInPKlNR+cb9D+673dQuEtOvP6YLFegRG2gjHoUiFci1xX0BJXZo
	7sumNL9R0Wga6rhJs2sTKtjvoZQWgDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776075545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjnIqVm2L01lbFxcE0NNWqMouKri+s7fTQbka8x8kdU=;
	b=Lxmltp+PCpEMdmwCKAPvV2Lsz9AChZA9S2GqBgSarTOvxwAul5CJE6URXMB6sYIrzMHq2t
	ZBlSTqLopUmJyHDTonbzD/ZFsW2DZDxngQx3vhKxqUt2LbTt6XjW7uXrd3D1Ow1Co+MgWy
	tsyqrezM/C6huJH9dlr/x4xbyHHEIYs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZjt1T1k;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AB7341908;
	Mon, 13 Apr 2026 10:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0C2C116C6;
	Mon, 13 Apr 2026 10:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776075544;
	bh=BWbYD3cLb+vBXi+E7k34tpbxGLI+DgWOQtcD0coM1VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZjt1T1krDt5iioNTVtJGx4LmUIpyTNvmoYHiFixtdCjPwa3UPk7DDZDSmDYnKuqr
	 cJQC1acBh7in32jRT4qAQ06pQE+10fdLYc6VF2eefckvu7fzC0lkArVBanSBgbUj1+
	 c4IDPI4uzNb1U+mzJvEMdWpvjzYS9gnVlvcNy0ZVF4Oe+KMfnaDxKORrA4ntlbeb0d
	 UXXNbuPbDhauWFRyYv1e/4gSVJwagVZzoc/dPBmCee7ayt90KKPOyYCLupWy048Tgy
	 eh6HbdG8ZqJC0lGKH3I6S4/3Bhu5g4mT2OhkxLVh1h54+eT4r1GYVndetFJwargjny
	 KDoz7zWhRPr7w==
Date: Mon, 13 Apr 2026 13:18:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 07/53] selftests/mm: hugetlb-shm: use kselftest framework
Message-ID: <adzDDS1C3Dc81sk0@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-8-rppt@kernel.org>
 <eb94ebf2-cc19-4a1b-962a-98346d7b7b6c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb94ebf2-cc19-4a1b-962a-98346d7b7b6c@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6435C40003
X-Stat-Signature: juia7x1j5onqi4kjqrqrtsrojqaz8tci
X-HE-Tag: 1776075545-855839
X-HE-Meta: U2FsdGVkX18mmn6/3maxxG+m0ojLb0LVas6REPsv9cxprzqHhD7f4wr88OnY3VIvUKE5Ln3DmrawPf/21wnRjcVYgYlit7BRtAZjHf6pl+iA5dz31p1sX9rfcT05xp8fRYA8R+CgLhJ3g97BQth10MNvkl0NAOpE93viF+sgddHn3Mq7S/e2avHu7bjsE1To3eNJjTd5OuSyp3O9rkeX03mi+PzPEMFqtKCBtfXzNUlUag/rGME3940I6i9O2kIRcEPQ0JcfiJAuwyJhGw26Or6s+k7JpxBEl0scZa7vbh98sblysyc+ayiVqn36lP5F8fZjJAOaJk6MheCHsK4vuSbHZj2MFKTBcGBX17sxLaYOUJrc7atdxLVREZ76r/RVu559e/KD/m8dFPzej0xUyLChsy839FO7+gWackt9XCfJsuV+r9JqDvLdCxP81LQgAqc029zZIqIuO08gzbIZvIyQbiq8bbiGTG9m9CKVYTWE1Zc28Ji5GgCr0h/RXES8K/BHt2M0NCWaFdt5bH+11hOdGtdjF55ac+j+m53wJykZoXvOCZ+fdwNa0cXKEuODDyiGG3pzCO+ic/SWpHh0B7RHD17eOaHefdySapM/6d2yTRswt5IP4ZO0206qlpbFV0ZAoDp8DwD6SV74taCtFrjAAOJT3nxb237xDxXnuTPWi0J/kZpYQdZGyX1nD5/iHALmJDBV230sY/+xIMBfD/yoUOVTWAM+lDxFrt3NqJt4bNREi5PVOsh1tnOnKORs5dnaEQhcLEvEDxt9e1AeBv+BnSEo7oX4be20i0w1tSyjQBQUdYVnX93kihORhWMvejxDZIcMLPlIe3HYwHnSXSH89vn6FaRvgDr6o7hINYiGmTvsSUYsOK9GgL+vDLvLoQEAn3iKZpZPxHA79o0g1hFnEHNnns3fwsix586AHE/UGfQd8YbbP+VKC2xEkK3v26PXFBAr+Ek4z+RoBWJ
 Z3BY/Dtl
 o02Vonc17bw3L2TZVJIhmnd00nB37Iu2lloSnoyM/YkJlECMy9P3to+3iY6tMq6Hr1A5p/F24wp22xLwjJCN+E0Tusv75cph7UiVGsxBVeDNQrlq025EH++blIcu9vRcVYe6Cd8FxeBE6Qu6gVNb9AM3tCgmEvm2QxfLPh/eXAqwPiPW+aw8e1uflxPYAY9/OeWYoPkh4BYAjNtA+EASklFk78yQusnFOHSj2+wvml/oDfcq5O3I06E/Do+l0Hh4+cZ3l00Ywa2dbN3Q9rlNI5zqaE69QjuD8wyBZ5XS6lHefbQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 09, 2026 at 03:19:45PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Convert hugetlb-shm test to use kselftest framework for reporting and
> > tracking successful and failing runs.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/hugetlb-shm.c | 46 ++++++++++++------------
> >   1 file changed, 23 insertions(+), 23 deletions(-)

...
 
> > -	dprintf("\n");
> > -	dprintf("Starting the Check...");
> > +	ksft_print_msg("Starting the Check...");
> 
> 
> Do we need to add a newline (\n) here? The output is currently printed as:
> # Starting the Check...# Done.
> If this is intentional, please ignore this comment. Otherwise, it looks good
> to me.
 
The original would print

# Starting the Check...Done

I don't think the extra # is important enough to change something here.
 
> ./hugetlb-shm
> TAP version 13
> 1..1
> # shmid: 0x1
> # shmaddr: 0x7ffface00000
> # Starting the writes:
> # Starting the Check...# Done.
> ok 1 hugepage using SysV shmget/shmat
> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> 
> -Donet

-- 
Sincerely yours,
Mike.

