Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9211606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bVLFw/pv
Received: by kanga.kvack.org (Postfix)
	id EF41F6B05B0; Fri,  6 Nov 2026 08:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB746B05B2; Fri,  6 Nov 2026 08:15:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08B96B05B4; Fri,  6 Nov 2026 08:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEAA36B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:15:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52697C0D75
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:15:33 +0000 (UTC)
X-FDA: 85404740946.20.BBCC2A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 62C921C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:15:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bVLFw/pv";
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793970931;
	b=fD6oeLk9BN6nbmG4lbayKOs58qS/drB3aBBivg5Lv7RXGplAfTZ4VYxQobD6hsYP+AbqTb
	hZopgg+rGnVxVJDGY9Lp8FNpvfjlgc+Ki6NuC8SqPo/h89RTA7OwmnrOeCLPHQXrVeRMr+
	ePLamgGBsaZvXS01h3Z8M06KokW28Aw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bVLFw/pv";
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793970931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TXkLHscwSMqxJsLbmecxFsJw68c+CWaCGWTtaOz1TU=;
	b=XwDo4k1iehVd7FXpP68ryEVU2owximscauuEbOvHTiR4URGATbj+3hIZKO/okZVKM2qqTQ
	kt+3O1c4i7oDrcK3aTuMcLmajeE8euI3PO7J0t/2bdmHbGAXeMTVSe1lTH5SAW1NZMJ1e8
	OCEGc4W3Co8zD0Q5+flNdq8e4frLNh0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054A21596;
	Fri,  6 Nov 2026 05:15:27 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 232E33F628;
	Fri,  6 Nov 2026 05:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793970930; bh=Oc8nVxfpMQKJNDpsFeRnkG5aGJsyD4jQTTT2hvVB/ZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bVLFw/pvUgSmVuQ7mtMONAlEQZ+X/4aGTifq/SNv8S6MB50rGt0Vk2B8CRnaXOs65
	 GKcIegd54xg0BNbFjSGPQufYPOjDAO+o12gJLw758dv8nUiDkOgPXYCQZGUGQ21IGY
	 JvtOPLCYOUTxMc1ypMdmW1SvBRiOxbUf55/sKNyg=
Date: Fri, 6 Nov 2026 13:15:25 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
Message-ID: <au3S7XlzNi1FktdA@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
 <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
 <auiZFJ7Bb6cQnqtX@e129823.arm.com>
 <d70b6ac2-a8b2-4c34-acc4-ee421eb70aac@kernel.org>
 <au2cKP0SWaaHQPrg@e129823.arm.com>
 <5521e876-3edb-4862-8b45-96118a21ab6a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5521e876-3edb-4862-8b45-96118a21ab6a@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62C921C0005
X-Stat-Signature: zk91mjwqkdtut9fzb4aqt4qf1sp86wpd
X-Rspam-User: 
X-HE-Tag: 1793970931-37215
X-HE-Meta: U2FsdGVkX18GLXkCvyid01xvqrUH1EtLvnbU9+bfG2gNgpTD8EAQM9i7y7lAJddB8IdUpjTiLeDZV/zoBECXHpIhmPWTm3A/kUyPs/ijBBcLFZqP76q0rdSa2YCPMHi+UrvH5q6KgQ1O4Qf9e/gCihRZznofVIBO4xp4KZ/npeGCi8FSR9/+P/sdgzSk5kdtHCnpPuW+aFZQ3vkEHk8BJoiufum08sMSJ4kqAcY3HDTh1IpWrbelu7sthA2v2WDsgxg9Lk+fYfwnmapkTTCXzIUPvwzgCrBg2iD9XcZGClA4RvticbYSrpmPJDQZx5xB0mnW7MVRNPVxEDqCD+z+e0kchFSZgMjNZBrtwA9HQCZvI2GIjUj6XGKPfaAnfvSy+3tloVzvKykuNAZdxVz/b1G+k6oXPSN/vwl8cgi9WdNysPycu2E1J4wGfxsTbGiBUnnvXE5FQTauHWSv+Rfjh5M0+/VJIIW7j3xfJWLmALFw4RxJ3fG3UnRNb3JVg2auJDc2Ru6Wpam0V9rdbh3Zc5S3No/gRHNel80QLe5fAIgqeVStkEWq5HkUOmrmGWfJbJbY2xjq9ofnVJY21caIuOQyzchQsPLH3yIJ8GEw+Vx7YnASpfBvuVyo2uIgNpL/WY6aW6Hx0RWjxRHcLfdIQbT4CHMMFIWnO7aMczg36a+HhaGpZrTnXwXCNLCRXzEohhKpvW8vFgV4p+3Dj9z2cpWQc7uLJBuw6NdrA9pw4jKwtegJ64XfbbzXcKRHIRexRmXgFjO8s+Blgp3MiKlt5S+JCu2UiJ1uXnXNQxUaypsqtke1eekCYbwOlo3EHxbbTjZoDswo9PAUpWVTvwVDxC7eDae7nTNpV+kPh7GSAtP8RPAOZ3lIx8PcT/+AVCFY8gzQXWVnIY+LZ+CIbfVgK3ofeRwPTJn2l1jjc3OOzg8m2Kww9Cg3iBX6NAC787jElWKsT4PgLHyxR/Zxave
 G/ycE+NM
 nkI14yVr4uZfREZcwaRKDEA5DbgDdb48npf4/auwGjfFnWXFjX59atu2sLYv4Tf1dk9x/tIcxSBbG2JdnXYdVQk3IFGCybroAe+4eFV/XZx0H3LHAB1e2kGggumCYs84n0fuceQ91XEv1GOGobAHVDPToF4LIrmvsp9zk6fLTVqeg+WRAh+pDpzvSi9gcJ05EE5FTIvQZIsZOxDH4KJ+Dlw9zkWKNKAdszfktujUqZT4P8v7mxSp73+O7fzrDYEOkaEwtY2cp433z+qOOyK2cNOhTxcg2luNWNfLN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 01:43:11PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 10:21, Yeoreum Yun wrote:
> >> On 11/2/26 15:07, Yeoreum Yun wrote:
> >>>
> >>> That's my preference too and we've discussed :)
> >>> I'll repost with below unless anyone has any strong comment.
> >>
> >> Yes, best to wait a couple of days for people to catch up.
> > 
> > If there is no comments for prohibiting to set VM_HUGEPAGE for
> > shadow stack as David's suggestion, I'll post with this on early next
> > week.
> 
> Yes. Can you do me a favor and move the fix to #1
> Also, I think we'll CC stable.

Acked. Thanks!

-- 
Sincerely,
Yeoreum Yun

