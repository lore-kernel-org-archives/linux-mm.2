Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F24C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A42A6B0088; Fri, 28 Aug 2026 06:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854B76B008A; Fri, 28 Aug 2026 06:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A3D6B008C; Fri, 28 Aug 2026 06:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562F66B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:04:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D71C91602B1
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:04:46 +0000 (UTC)
X-FDA: 85150244172.23.778F5D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE08512000B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:04:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P0pj3wCI;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787911485;
	b=sv+LikijWTe6EC7HPO0X3L6NN4eUo4hjQutJHfNkDKcoXEuQgX1kuupPNtYPVVLvFr9+En
	ZzXcfegkAUaOsqdvv/sj99YZ0SPdGAc76jXTfoiVXReTJEsxdkI6iIVGVHMx7BX63xeg8r
	WhdmaFQbCXTBxdwpaIxvsOzrnbX7gQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787911485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADD9H5fA9nQxDvVSY1LX4mvih/xdKK7OWLStw/7wa/E=;
	b=H+z4wl/2ydDAOnEBoqgCQUdUn4OO2yr71EetZQ9GDQxAKGKWPTsXcdPsNRzzRh9fWdt9C9
	+uQmTcg9UemToYk3VRkX4X/RXwt9pse0T4RziFJ/2WdOSgirZ/HiE6qSsOuxKtMnLsKoll
	2i9BGP0fnvluaMOQrv2WtZFSWbc0mAI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P0pj3wCI;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB8101595;
	Fri, 28 Aug 2026 03:04:39 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 296B53F85F;
	Fri, 28 Aug 2026 03:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787911483; bh=aumBSDnENz5VHBnc+jg6Re4gRmKjWjReCkyLV/sOPr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P0pj3wCIhsi+UzojrdVHcOu1eEF6Lj5JFlSy0yBfViLLp6P5WyERT4jzhkYA9pKXT
	 ZcGJhuKYlxe3MX+Zafvy1SCiglBGhK+rnuLve3kU3HVmbki9TqcimksfNEDV3Mzk8Y
	 L/Cwgjc5sHUtFnJUvtxp624zelSBigJfXmV/yBs4=
Date: Fri, 28 Aug 2026 11:04:38 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <apFdNhauXl3z7nu4@e129823.arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-1-374022586a4b@arm.com>
 <apFWAppcVKt4xhIT@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apFWAppcVKt4xhIT@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE08512000B
X-Stat-Signature: x74ztdx9u1dck77ic6ba7mxb486owmf1
X-HE-Tag: 1787911484-734585
X-HE-Meta: U2FsdGVkX18vLi905IuhTvYEwXcRVenkwYp3Yk/vxNhmFtNmQ+nZDpCv5LdxYLNk48WuhP8W/G4un5i55Bci1iBgIjHZM+AewK7v9/SeheeKfbKTl+92cWChzXO9NO5WeysCMZMUckQgn9HAjVETp4ZA83ubZx8+82pANvYhNuV00GQ8Ti2yn5MCbhLINH2+VedX2RrjP61JLhdl9b+3R53b667eJ0mZS2MP9svAmJ8cUUH3gzN6br8QcakgVzqFUGJZKPHvm7qt4oI86Ej1NDNXrfPsoI+0KMRKeVXaHgc7djlOfjrAul1I4TgWzcu7IHQEjSslLbGotXCBVf6BOUGcg9jZ3qrtcNeKFEwbWkN96dV7RD6WcKGPWVcARLNGIQtoV6Q/zQTBvXLcADwMmbEZ+EE6WvYjPgKp+MWtoqj6EP9Y6qJpd/IymN5EYZfGgYKJ4FfZRvx0wA+NxxrTTOjxyTkmXbsqHsETgJnbZUVQIt6oSIXrB34shzuSz+Z2cE7VpLG74vyLff91tIxy/e311K0Tkslx+EY+gDt6M5yDZ5W49Ph+Gg17mkIvL+jLeXwtfRuTzlVFczmuUYKYkIYjYX2ghUbp96APIqum3KH260+uZ/MvtzD+E5FIX5TXTogs/uDTGxA23K83JuAlytczpMcqy8HIMiywN41dUiIQQeIx3iZQ55LjFdfg3Q4OTvtRfXCJvV62Yu7cWJK/MftCbFMcOIJ/+eZQdr4u/StM1boSPB2zUQZ74eKwyNtferSoR7QOvZi2C7HES0uQcneuqyG2l0QokKwOmvCPg2+sL4VHCGpx0Ecj/xH1OvWWcj4dyFx6DGX+FbmkcbnMKosfYyDmpckB1PhZGBCwKj03J/Vj7YwR2Rx4ggzZoqScuBpYTzhtZ9R+vzbE00PBycLIF9IPDQTyB1mb4nt9rT0Wpi/R1fBlJZEGIuTYe+QhVG0bDlqrauP5HjTA47l
 3/Svvdyk
 AbX1Zss97fbJSak3KU2yKMbvfSedSVtvP08vE6K92WOAGf9OADz1N4iI2npgr/FXiSVRSozh7O94KbnBSmWb/y3n5xSZaTOJpzaN6TW8qdkNdwsdbDLtZZH+gdGKToGWbbUQIJQJTiWIN9VNVjOhbR+arnf3+2KDI+BwetiMBNvGX2uSNEEhJZ8F00nHswnJz21aIchs9o9qH7YlUI4LM/4HyDcEEqJYSYDrF0ANJPwcyAys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,
> >  	if (!rss_anon_before)
> >  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> > +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> 
> This should probably terminate the test no? There's no reason to expect this to
> fail and it's better to fail then to risk a flake :)

Okay. I thought it was rare, it seemed enough with just message.
I'll change with your suggesttion.

> 
> > +
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		      (uint64_t)one_page + len, 0);
> > @@ -227,6 +231,10 @@ static void split_pmd_thp_to_order(int order)
> >  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
> >  		ksft_exit_fail_msg("No THP is allocated\n");
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> > +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> > +
> 
> Same comment as above, also since this is a repeated pattern, I think it's worth
> abstracting it like:
> 
> 	static void madv_nohuge(char *ptr, size_t len)
> 	{
> 		if (!madvise(ptr, len, MADV_NOHUGEPAGE))
> 			return;
> 
> 		ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
> 	}

Acked.

> 
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		(uint64_t)one_page + len, order);
> > @@ -313,6 +321,10 @@ static void split_pte_mapped_thp(void)
> >  		goto out;
> >  	}
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	if (madvise(thp_area, thp_area_size, MADV_NOHUGEPAGE))
> > +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> > +
> >  	/* Split all THPs through the remapped pages. */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
> >  		      (uint64_t)page_area + page_area_size, 0);
> > @@ -542,6 +554,9 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
> >  		ksft_test_result_skip("Pagecache folio split skipped\n");
> >  		return -2;
> >  	}
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	if (madvise(*addr, fd_size, MADV_NOHUGEPAGE))
> > +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> 
> Obviously same comments re: this and above
> 

Thanks!

[...]

-- 
Sincerely,
Yeoreum Yun

