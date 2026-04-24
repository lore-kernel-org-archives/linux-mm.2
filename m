Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CEEFE51F0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AF06B0092; Fri, 24 Apr 2026 05:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB676B0093; Fri, 24 Apr 2026 05:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8007E6B0095; Fri, 24 Apr 2026 05:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFFF6B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:14:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C8DA1C0C87
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:14:06 +0000 (UTC)
X-FDA: 84692887692.11.975303D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5913E2000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:14:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHgSpMBO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777022044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUHRZLvJYisxL/hSXiXf7w7iIpYypSqKXBk11KQJlk4=;
	b=v7sK4U2YzqdRl1AqT7josasHsf/uBAY7F0AZoIpb3669zJK+WH+K1U1O5+M8DVExHkPE8d
	1G2E+OMCN/zOnxnG2GIB7XynwZU8f4ArKdGrY4IArm6NHteUIJSjVwOBw68Ig4PoVeELfd
	9Ipjh4eYur1DXTxMd6bln6x5Tqg8ZkM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHgSpMBO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777022044; a=rsa-sha256;
	cv=none;
	b=qJsfEqiLjrmGzPcmkfeM2bmsAh2GszaaMLajUiOgXkJtJqur3WATh1MtjT2gWCCAxlf/0+
	83eR6TOzR0MOA/oItV39rak0hL27igRJ6X3N5s3D6Fm2wBFoFPl/XtJm5ctzUOVERgJ9UM
	YZX537vKGO8JAnDu08CkgDN1O67uDZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A2ED43FDA;
	Fri, 24 Apr 2026 09:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27AFC19425;
	Fri, 24 Apr 2026 09:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777022043;
	bh=niop0reY6PituW/Dk1Z2ZYI5VhcmIRP9z/VzEFO68oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BHgSpMBOVOcwn8p0Xm8TP+46ztAmOgjg7Q2X5khW4rxTMNN0LXQZlmq5PLvGXVkWd
	 cymeLh0U5LJBo2TNtCOtZ5yUzR471uRchQgaAY6znwAZwQ2h9mqTlTZfkENhkHFnl/
	 ppUDOP++UwrQyblYcvuKhSIu6bv7UU98TEJeGy0382i1PT63Y5ZvRwT2yRBq7CD2xk
	 Z3KFITUiFIPFqTg9tNlIYtIEXhBvhCYhOFI9zg4uJoW4bIeY85T3PJWYAREZiejl/y
	 2PB0a7qbtYjuIBLl3QChA/QksVLIygq/gfT5k0m/gjYYLNUlRuLUhoqsnjihiP5hNy
	 zo4VXKAXcBCsA==
Date: Fri, 24 Apr 2026 12:13:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
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
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 07/53] selftests/mm: hugetlb-shm: use kselftest
 framework
Message-ID: <aes0TwOonlHVgn67@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-8-rppt@kernel.org>
 <3d154106-1de3-4cd8-9bee-53ef20245d62@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d154106-1de3-4cd8-9bee-53ef20245d62@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5913E2000E
X-Stat-Signature: 7w4tcfuy3z7jtmr11fyzhupg1rqb8gae
X-Rspam-User: 
X-HE-Tag: 1777022044-962676
X-HE-Meta: U2FsdGVkX18R07+PjtzKi1Du/ipnFphjp5g0rkbk6Pj2HmRM7vl5AptSMoCHE3VqvuhRTiMePYtMZTWO5DOUCwSXItDQKuxxPnJidQDwfRnZ3h7572Wk5DPHhqJ7Bd540zoz3hqiDm9QsReV2yyz6tDqqGK8TH4dNwLhIsGzuD04TtHUxPbqYXIcdQo7ZDGlMavjdhebQ5/LKteMYMwLw97y4PkMBNWWCbvxt6EAV39jbGWIRPfIEfTaFTSH3kqZJ8S2W5A2ufXU24Z3q0t24cdc8JjP2XrQ+NoTD8rDCJ6xpHs/w0+66JRr1lcNMPAkz3rre59HQ4U4ecgIZhD0SuGv/nlHJqxQIcG+1NM8HBPUFty9SPIHGCHF67bdB5TKXdCa7AqjonPvWZ1XsU5u92unWosEHsrJNKDD496xXO3snnwePv4xeEwIYQgtfkF+tNGNuni6UOZPARrHW0ZQ49wY3J7x60nSWfMuZr0UUZCdTG3pDF3HDvyTYiB2JQSP1yJ/eysI6jTjJXUieNaKSDtDlfLuUFpvpcJLqrsnNQpCgpI2iaUET94LKbmPHxDeGtdFG4BkL47d8Wx36hnsEu080zu8PmDDBevUPE6vYQjWrhAB7X6YYqLoex2T9AFDPePTMWI3w4u3YnLIXvTy/PZBmvlxN4OdhNH+w0EGRwYf8fCkzOGY7N33TnJk9DMr3SUlDBgLo60zsR8lIn0U0IiSXuNdhFdNPPwqLx+ifsXz61VkkdATQsYtkpQ5YTLYPnBs5X0wNdrWt+EnCpihdU9FhJovVlh88BQYP2vzplFBeKl8314iS8fWL2Iv8BOIAYkkU21tOTRIPOAlrJGWnMOJ1hOHmlXB3hfv6QjwvdrML+g6qD5tgszZvoHW4ZaspNFa/b5JolLfcN01jeDKaGLtHb9lVjKkJxI6U1Z+1u+mFVtSC5Aw2u0b/LTxTrOh/PCoLB6z0IdbVS0U8W/
 6jYnYlor
 ASY014YY1Ej54yjNA9VPLQJzuLW5zz6N4VmxL8Y9RKBnSKAm8kpqFCntnabIR7/Z5Cr0pWwmHaX5C6cN8a62cCt9n5FLyTAQ35Dz0h+cH0rbTyT5R3m/ZsfI9t0EIuON/uPoTdKIboH5Cu7mlhoBmC3x26mw3SRlfGJSKtSnyvQXbmT+BFTFAFVZ2aIXm/aTnqq4wwMO/836vtqAukFCWPaXBFalDW1L4DKO07jh/BwHuLEVWRS+QlGbZOQlHZL3/3QldtGmqnlKBSw8SGmVU3VbjRcC6cI9FZO7kukRA68m+MwEaeCX7pAGyT2jHWnMvAkPZ5D94w5rr7k7aNk3HOrhPZmd1zZwQ7kbzCdOpiuQTgjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Wed, Apr 22, 2026 at 04:50:20PM +0530, Sarthak Sharma wrote:
> Hi Mike!
> 
> On 4/18/26 4:24 PM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Convert hugetlb-shm test to use kselftest framework for reporting and
> > tracking successful and failing runs.
> > 
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Reviewed by: Donet Tom <donettom@linux.ibm.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  tools/testing/selftests/mm/hugetlb-shm.c | 46 ++++++++++++------------
> >  1 file changed, 23 insertions(+), 23 deletions(-)
> > 
> >  
> > -	dprintf("Starting the Check...");
> > +	ksft_print_msg("Starting the Check...");
> >  	for (i = 0; i < LENGTH; i++)
> >  		if (shmaddr[i] != (char)i) {
> > -			printf("\nIndex %lu mismatched\n", i);
> > -			exit(3);
> > +			ksft_print_msg("Index %lu mismatched\n", i);
> > +			shmctl(shmid, IPC_RMID, NULL);
> > +			ksft_exit_fail_msg("Data mismatch at index %lu\n", i);
> 
> ksft_print_msg() and ksft_exit_fail_msg() are printing the same thing
> here. Should we remove the ksft_print_msg() to avoid redundancy?

Yes, I'll drop the first print.
 
> I've run the test before and after applying the patch. The output has
> been correctly formatted into KTAP format with no change in results.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

Thanks!
 
-- 
Sincerely yours,
Mike.

