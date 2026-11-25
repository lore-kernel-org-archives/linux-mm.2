Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B80606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SPVQka5q
Received: by kanga.kvack.org (Postfix)
	id 07BAF6B0A2F; Wed, 25 Nov 2026 09:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF95B6B0A31; Wed, 25 Nov 2026 09:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7FE6B0A32; Wed, 25 Nov 2026 09:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3C926B0A2F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:25:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48220160E6E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:25:57 +0000 (UTC)
X-FDA: 85473865554.23.29BA83D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 05417180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:25:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SPVQka5q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795616755;
	b=JFXTLttTb6tGsiD4XQtoMDqWi+tKHNnHEYMEvHiG6kw8LNCUZmfySyiJDPgyF0jyAuH/A+
	sG/kgQMrIb0gpT8YmIpIWfy7E/5OJE3LzDW669nXJXqwTulH++AdKTuZo8XS0iGCPijc/z
	DqnPEu/vXmWuopga8NsOlwCtpUKMzSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795616755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUuiYfPMGF1dYU/3s8nfXtw2BbGEHy61uU94+Ks01XY=;
	b=kYo4vRdgoCFMhJ0tsw/bFGJzqCb7lCG2F3FcA5sQMfkMsrVb+Fycd/3BvIQOVPcm7v4cZd
	QypMNG4Ng9UOoUBxO7bhFkXwfn4tGfS3AIf0whjkerNClKNgeQLHtTvZYT8Vd3XABeC4ot
	1GXgk0Ewxbs+ufzKWdoQ0F+94PDwcVI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SPVQka5q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qUuiYfPMGF1dYU/3s8nfXtw2BbGEHy61uU94+Ks01XY=; b=SPVQka5q6b+Q1YM0gqBdrJp3y3
	UUUokphX0g5eOWTiYvKvIDnraP8DhH9YtPY1ZVZmsYKhEi7+gXw3fYCn4rPNoFx2DLd55U804oNgy
	BpAC/5lODMecYTLyeGz5nCdxDEtSTYfIvUTVe8FbTHsbr0cIOgfgv0jPn+sHtL6DMlT8tuSRuUd6v
	32FH4VYNd9i9qBT2ZAx4KCl5vVK5/EmscHlH4AaNOdMwQCsBZIDp6aSZpqVQ4A5WpNM8a/Uxl+XzR
	DKPxKHf0vYby5fO+XwYhJ+FBMHHCrLpsCuR4fOwgm09h/UIcEa50ozW2eGgy3J1Rf3BkAR21O08IJ
	cQO/zxyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWDwO-0000000A9gO-01yg;
	Wed, 25 Nov 2026 14:25:44 +0000
Date: Wed, 25 Nov 2026 06:25:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Pedro Falcato <pfalcato@suse.de>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awbv55FryMamHvVP@infradead.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 05417180006
X-Stat-Signature: ihnh98r8tux4b6zq3c6jza83r4yqrpy8
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795616754-8553
X-HE-Meta: U2FsdGVkX18STEOuNPAekR9Vq2wCqGVNhoIEMTPfd6/KILUy/yz7rW+Czgh+Dwp2ws/mhRmcW86ngomNhawp0+npJJJ90hQS3SJxOAmvziIpxTtjI6HQb1hCRm1+OUboqk99ovfrzFI8UroLRXMeYJjEDjW1FviSD3DBTjoJ7Ddy8ndBQC7VYJNYNvqAyiDsUaSVwXaadBwQP/Pu1r8DyzDSrMxfzkKdcwjv8HajJJHTx0nTmajpaODMX2sMbeTEpq8dp1HEz9h6feZVdPwY+vC2kKMZJ6YQTYth2NuEJuRisGx7lxcQGR3vIk1JIHplPrdWXCkRhwdoyiI5X2JtmZFt8tgwG6p1UVuU6t054hWflutXbLTMJErSZRieH1iDqra8T5fWPhDTjD8OYhtdEvVZvR2zfLxexBZOvxXUlvdrau1hCWeZ53f/RdUc0Zjn34nq8C8Zw+ntSZnak0uL9xnMfMRubdiLFz37gsDjQOapFirIzZMYarAw39SdXIATCICq1PgZrQ/DL8tuqu7kgJneODpGGDDH6G4vJ1OVz7mh6v743e9+WzmPSGoo4SpimzzAKW68eEefcnvygvxDhMf1PDz/n8JhwkeT9LJlBSjL3WsrTMnutF30lrLoxfcgloIuZUwloXt99MgWaojXfD4mJTcFkGOgOx/1GErP30DlOVrhYWFnGXGLaJHyKo9Zl/z4DUVON2sDj4fLiq89AAPFqee7ictdVEVthczBWzlsWV4icyQMTF4k4dcuzs+2WkRyg1WC/3fvZcAeb0XkG7fAKLL3sOq8M/dARi6zG0nwrEZT1lgLWQ2sF9lVdYvreeTcs3LvhuZki2ZJII8eoTvZMS+0D1/jTHsy5rV9Jf6f+Iw4qcxDCXKsyrr9WxVsYtZ/obiP0kgJh1axKZ4PO8Oiow7yOnqZx3zypL1u3G1vEi0kpqGLybK8KOUvkcdejIfYN0aDX0f7A7pfJSq
 MDL57xQ9
 tj3v5vsIhrK9Y4BPIF6yvqSIK6ZOeKNF989ao8Z1n1nx8nSYB2ePl45nHJu+p+aqK7uk2Y5d6/80M2I3Gw3H6UVjT2Z/CsIm5lfg5stw6AzweU+i62r/jTpdh1tsezXy31/z8iVWGA5G812RHUKrxdlkmVTbOeaDn65YuZ+4QUfSkN0eXp0PFtKmiRXv32L2OpX5Lar6TLeiJNG43CTWWbAetYFmd6J3zwYfl7NB1WB+gitqkyfXerNXRThXxY/XFRt/wkGibKz9BcvUVEqe/WPdNGZvUG7gmLuw1lqooRLjj6oQvy/CMAs7dGPLGt6PGNqVxlJWPIPIdqY/pCKxFoCCZJ90FuRKyoqLQWR6Kdbo7wHybOogRorMSADF+Py3rA8CtELBUlp8w7nH+wos22KGsRXNa8Sc9LGqN9JBl0qAqJETf6Lcltv/b2z2EpMvlSrOL/2+Y9WA5NTxKUXdnHMwJxCLHZjugGkmd1KuMn62xBE8we1NEasTORstwYkwKQBy9wwgCwEyKPTjlabpamfIxQTIEqrXhFNFZaa1DklnHKHo+xyElIUTs4pUSHg8dm2nHodmyF/eofqN276QxI/HHdNlQ1CetbdPJHBRUqF/kORjY4S6iSDl+xE/6B7XeNmr/A4VWcUNxHkCefXUOAT4Q/K8qffXlaNsCtC7Hnl8FrBwuFfAHlQ5ozpp+jv6dAhwq4SnmFxMGxrKdDqdHAsNrYZndUPCgcXipxRZXzVIqTnzJlo0e1lh3ZvsPPSNm+vTlHhq5URPoReRneUc/9cLPvEmbEJUAIqOOqc2vMDItQiXLtJco03/51lYPYdkFBJuhLnIqPa5CbkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:19:18AM +0100, David Hildenbrand (Arm) wrote:
> > I don't think that is a good reason.  For file system backed VMAs we
> > really need the pin to be able to do someting sane, DMA or not.
> > 
> >> 1) We fix all such cases now where unprivileged users can trigger this,
> >>    converting to FOLL_PIN.
> > 
> > We need to, if not for this series then for all the other outstanding
> > issues with GUP writes.
> 
> Cool, and I agree (that's why I placed it at 1).
> 
> But who is "we"? Because I recall that "we" wanted to do that a while ago.
> 
> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
> be the harder nut to crack)

The collective of MM/FS integrity interested people (for which the
recipient list is a good proxy) plus the maintainers of the code
still writing through FOLL_GET.


