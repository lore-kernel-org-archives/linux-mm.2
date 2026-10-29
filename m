Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3A9606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RBcAXdVT
Received: by kanga.kvack.org (Postfix)
	id 0C7A96B00EF; Thu, 29 Oct 2026 09:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0786F6B05B5; Thu, 29 Oct 2026 09:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA92E6B05B6; Thu, 29 Oct 2026 09:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAF2B6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:22:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 589F81C3A67
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:22:58 +0000 (UTC)
X-FDA: 85375729236.15.562FB39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C41DF10000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:22:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBcAXdVT;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793280176;
	b=mbORB5pMI3Cc6pHCYF+2CQzTi7sAi7SpoDv5wlpZkk+wirBd6dVe2hJoVMJCT2biIvm2yD
	EaN5o60++AF+8cO4VIU9CUH+RdFus0v5mmvkPsCO3E3usiXpROCVepLrkYk7/Kv9iyn2BR
	FgCDTjrXF/lb2WKv/m4ovVMglgIX1Zk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBcAXdVT;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793280176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gui9u4L/xQbNvRRjjqLlR7DBCWjTZcYwuZrUrCknkHc=;
	b=eeaYOskdQjRl+OUzJdX4soAg4tZFV24IlFRNLEBeT+4kALG5em7fElXyCswL4oY+arE3bS
	Qby3Y0ZebpQ9FF9bC6IR4WMKzg0ItGb4jYsReKoR8IIrVtku1XuhEpj4+pco0Xi29Zi9d8
	76FI1uhEd3DKo/kCBgB6yrRAitRoBe4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50564601FA;
	Thu, 29 Oct 2026 13:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09161F01825;
	Thu, 29 Oct 2026 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280176;
	bh=Gui9u4L/xQbNvRRjjqLlR7DBCWjTZcYwuZrUrCknkHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RBcAXdVTzDlQEdHvHcfy5u8SoDIYRNYoD+l06R5dEr8IiRSt1SUOgl5Ln3W1xQkRJ
	 9LCvLzzfHpYLQdKcNxw+VEwRkSCWnK2rbKwhSJF/OP9srEmBXOU9cpVFjQgZ2KdbvY
	 +4QSQaP3c+8pntVFa6bRe5u7sMIXQwwXCpNoo/BUj/JKLtnZMVuvgmNRoz4SfXLP3r
	 WN07RgB2nY8y6SilloaZLjeVqFfitSLmJzD/FoSlPgrcgfone6fxT1SapYvF9FZ8IJ
	 gREQLWU1DoQzVBwWORiVWI+354MM/fB16oY7FDSXN0u2pRKwtTRGh2uFQvA+SZoOGM
	 77RAC6TMjYTGA==
Date: Thu, 29 Oct 2026 14:22:48 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 3/3] mm/hugetlb: fix NR_HUGETLB accounting for unused
 surplus folios
Message-ID: <auNIqE_Zz5AK6-uj@localhost.localdomain>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-4-kaitao.cheng@linux.dev>
 <auIORHr432BlmbrD@localhost.localdomain>
 <87146009-8E2A-467B-AAFF-8F79E9D5E32F@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87146009-8E2A-467B-AAFF-8F79E9D5E32F@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: C41DF10000E
X-Stat-Signature: 876ibp657f8ix7ejtngaufc98ctf7ejd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793280176-623844
X-HE-Meta: U2FsdGVkX183P298uisVB7R4I9T7vfvJoxHMXNQsxWDsFFB4XsEWiE0AgGd2qL7hPNxgCqMyRp8l0RV/SGZ0NldQawbOtUChzmaSZjr27smGeOc2wIJ1o9ASM55AjPyLvF/K++C68bDYf2g/eLF8DyxLwZEQpLf2Z31UEv+Xs6BiTkgvnaTapK08v9jb39lJeYYD1dRh7Oxp+5UT54VYPbHJA+UqjUxiF8vP9k3fAdATsvsSt69MHRdydhPCG1iHLXCzs38EeTjF0fu9mX2NMmoo9PQCbgz15h+P2wnfM31N4qsJFKTlZIZ54YX+ru9ymipFB9Dp9zcw57ojPmeRXwiEGSwOE22gVUc/WLksZas2GT5tYfxkQvocahSeRlyUHQVFuk/4EaMn8mrSX4SzDhpJ4CjBA99L7Kn/5omhioJ5t/SceTi0ImDqTY2RsgwIxp7LYeIcMnsZep/SJLR2NJvpXBFO4SKqG1vmskitiF8NXXuLDUSv8BmNh3lnobxrUlakH9nlszIAKOsj5pqv7/xXrdkOotTDEddDO0TSYtiP/Zx+FElRWL/VSQ0QJ5BLygvbb1s2J/fO1XzOOjhE8izQrAzyPXRUvi3cRmG8G65122wCPQnYuXTg3P4YpYBrRweoA/gWf9Enf36iErP9KLoyBQVNXumHybqJgFKgyWNY657htWzdx1AbeKW+QdFRu/L4DxRHeF/HqdZpqSWkeUdYM7gRfCpWdF7+ICb2BlvUF2ulXvWKzvSJt9h32vPHKnqEofwiGAr3W71eLyOsiNLzU2q2QHxtOqUQbzW3wqUUx1/Ca86ptbcSB1COzz2b6IR8HEtq2jUV0F+Qc0Sxuu6rT+j4T5kZ3wc1zK0mjwxHKu8+E3LueETf6YIpStNYtSB2owArAoKVyhBjRspzrZe0DgbS1787QMSTFKLou+cfA1DdpCV0Ijm2ua8Xzp04aU1/R/TirHbU/+W4sjz
 NAF4fWNL
 QYJW/jP29SX1Nh8mhRStkWWaIErCPMBc7bha/xr83bwYGElpFQuZSMpS/flE0iu7GRZyxrkUI9vm7zWPUhtXX/LhUZ0bVOKXb9TWEsB99uHqhr/OqFr0sZQ6lAz5/EsbUB7cEsJTlh60lA3qhPGTqjgi5UYK9QUNXOWh0vW6hyWnIODeJ3QARMHyJ5ahKHQtDs+0o23AVhu+/S6BSNaUoHCUFRIoit3nKsnsJypN/qUVmq7xiw5EvCeNGhnpPIxI5S31o4EAVfxRUCRSrf+VBdoLo9S0z7+5yCW067qlWnJYR+aQI4kMx5txFsCcYV5VyBwhjR3EcJKG3QNlv9Jn7gT7jsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:21:47AM +0800, Muchun Song wrote:
> My thinking is that we should not use lruvec_stat_mod_folio(). Instead, we
> should use mod_node_page_state() and mod_memcg_lruvec_state()
> independently. In that case, when a new hugetlb page is allocated, we could
> account for it directly via mod_node_page_state(). The reason is tha
> lruvec_stat_mod_folio() also accounts per-memcg NR_HUGETLB; only by
> splitting the two can we minimize the problems introduced by accounting. For
> callers that need to consider memcg, mod_memcg_lruvec_state() can be used.

Ok, this sounds pretty compeling, and IMHO makes sense.

I mean I get the ideabehind this patch but it feels like papering  over 
the real problem.



> I expect that after some cleanup, there will be only one place that needs to
> handle per-node NR_HUGETLB.
> 
> Thoughts?
> 
> Thanks,
> Muchun
> 
> 
> > I will have another look later on.
> > 
> > 
> > 
> > -- 
> > Oscar Salvador
> > SUSE Labs
> 

-- 
Oscar Salvador
SUSE Labs

