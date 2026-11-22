Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49434606A33C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OeKs4h20
Received: by kanga.kvack.org (Postfix)
	id 490E36B05B0; Sun, 22 Nov 2026 15:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4412F6B05B1; Sun, 22 Nov 2026 15:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A056B05B7; Sun, 22 Nov 2026 15:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E968F6B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:10:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56882A079E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:10:25 +0000 (UTC)
X-FDA: 85463847210.07.A36014C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81701A000E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:10:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OeKs4h20;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795378223;
	b=VnMY9/Zz/b25jZcUogORD2ZYE+mcbuE7JEAgX1JD+OnH66kQEVwdlzoWP3r4yHNFtpVVOV
	j6sWghm4VCFpqoK7FHRDrw7AZ0jyBxxc5sadx76nnqeNHLz4Zyr997jgAQHrWGPE66XR6P
	v4FUCyk3bjfFZEm6mOver69sO8fZm1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795378223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FsNSHYaB061hlu2KABqxgrNYuq8vEgF2fs6tSZjLEU=;
	b=q0E1v8BpM5nOUKBEbYkJzSKl9n9dxZfWx0G9FnHcfmLWuBCxKppaCu6NOptSkiUI1XQMPt
	StbFNe22QhWiNbfq22x9UM/hs1sp/rL5++fQxTfGhA3nzuBsKpBrktCsZfP7ITTcDWT/j6
	Ttm8kLBWllFOQHMU1rbStEyq3tokxLg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OeKs4h20;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC8BC61B77;
	Sun, 22 Nov 2026 20:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EB11F000D8;
	Sun, 22 Nov 2026 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795378222;
	bh=+FsNSHYaB061hlu2KABqxgrNYuq8vEgF2fs6tSZjLEU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OeKs4h20pS30oNZ1IR6GnomWw5DqimBeyeF3s3kvf9vG6T6et1HFpXwu+3RUD3kAl
	 VTBl8DZ7dNxpuLlaF0l10G+XbXn4Bh8/advm28c8V+2c9NNnSdrLUBtzuJz1FfZvob
	 aI+udgeSDGFiJYNYNYYS0x1Dy9+r3s2cQyGX418c=
Date: Sun, 22 Nov 2026 12:10:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Dave Airlie
 <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Peter Xu
 <peterx@redhat.com>, Breno Leitao <leitao@debian.org>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Arnd
 Bergmann <arnd@arndb.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org,
 Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 04/15] mm/hugetlb: account temporary folios
 separately
Message-Id: <20261122121020.4c0964fa03c2255e29fd43d7@linux-foundation.org>
In-Reply-To: <5f477c4f-9874-4f51-ab84-5b044a3ea568@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
	<20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
	<45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org>
	<5f477c4f-9874-4f51-ab84-5b044a3ea568@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81701A000E
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y3ydoq8grfk3zx4igpcinu6eamnqqamm
X-HE-Tag: 1795378223-977478
X-HE-Meta: U2FsdGVkX18hhevkT+HyqdcD7iWD3NZNLZLrnT+IFIAnEqImUK3RsXY+3SqWcZhg2QXRLHjwYw+m27M1cV6SmFAcbqmcDMeGdSJOk9ilndc8YhnWOWqdyvYVvQTwJKHYMxTC2vkL/5iNByFosoHBXfIM/6LlKnUcx3QfgaC2ugRmnbaYcAKyU6Z+cdpZanuV2zH20BGBx5qUihE5UlKm9X52uZmvMwf9Ci3OOiXDN1g/0QE1BqxcNqQbkYQ0nlmm78Cz0BOaIJl+Sx6ThRd5owZuAtZdAUEtKpFDpN6dtERk4yUIicYQA0QL3dzwhhsATP+sXw8s5qO0Rylo+9v2qZCoIQKJ1z1BVfaqP8BVEG7Hu0N/OgDFFJJKADf8jtL/Zf5RpUJe1Z3V8SfLXHe3vMMzofmROhXBLLUm7YhMwSYyAF1vSsGCT5FK6RcyTuN2zsAXguooMfJyoAXTYKcvwXyVgJ+JWD6ZnMMKE2ANU5Oz/5/1Lc33YAmUlbp1SjqAcWzSBjRT9JK0WBxAXpqnUIC8NIas5SNupLIof9KiEXbwCGVM8o0MObWCkEv1QRmsjDJDl9zc83GtbHap+tpv00F42hosGm4y2rZRUXVTP6HnCrexUR0aZNQApYvLbDBfn5fX6mz2Csndga5y/oZPpWg7nfisr9CeHJ8Q1tl4jcd7n58ogGc09KooUB6YdjODnFqUawNKFpnqVHdwEY5dCG58EhiYxRLUcGi2dpNHcgRuoeubWRnwZ3+CG8p7aIIsWGwhLxXydUY7BDUrhuRqlZ9Ykitwtcda+vNYSTlwqU25dFut3EzveHXZ8pkQD9IrE5mTR8tZ30+LigctQp1e0jHF9M3SXAkaFtzV5w5QyBxOjy0ImBjkCo82J0LdlOGlVxDvS3X9TiaYolpG1G4PjULDdYy8jEA5zxiXVkFWATtCikscVtINohzl/VBRadnCyNPiGcqn+CLJ9MyCCKa
 +FIVQ3M+
 wa0ori3rSmaCcyD31Kw/JZ+QzZBgVgwYpsO8fDaSsPyuROusrMgdBtQfD2hmwe9pE21JFwWZD7du9ZoafnHGkiTuwKvFYrFiHcwLheQbo2Ij+1VOS4AqKb4jtHugl+d2wKRf3zoikL3u96ggt0JtwRLf4gvWzWWBzuGnMM5ednyCZpNCdUe94fd03DRM8QGiB/RuoKvasYSJ25tfnet1jNZwS5v96rR5me2bKxu4kjwXCZLdPWD/kkEGfBB7zVJGQbg0P2hkpoJ1oyfgmNwJz3JkjKMC9kysXRIlwZAu+Qlk/9edODtz1vzuRPAP0/8MhBAK+upO+9iuBG7Ri9HXaeKRX+8BQ9HXqkeeeN0pra34v4FCbwpxS/rsuZRZCOgkDUWT2iSHBItqrwEPLFDI+0RadZE/csN5u7XvvhGfguJlqu3un57HTcXuhyXdu6oxkezGEgVYb6gGA6rInI7EgrfiwxwS3vb9lIXxpYucczF1n/EjocU8QuiEY7CcW88cS6ABHFQIcFxFRN38nrWxwLKFiihtiYs3bPQyzf4QjYiodM02f1X4WiJoXy7SUteFzfq5v+vW7L+tlyZSMxVIEuAXjpGjTj6zxWktFycOVq0G5hMvol+0EDYZYfxLcsVW2GfTFKLuGPbaBDktf4E6ulqRXd2pZA+4fvIiofGaQ2PPOGN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 19:44:35 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > In combination with
> > 
> > 	mm/hugetlb: preserve persistent flags when returning folios to the pool
> > 
> > This results in an issue during boot.
> > 
> > I think the following is required:
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index bfc88d42ef0d..aa6ad8d93266 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1804,8 +1804,8 @@ void free_huge_folio(struct folio *folio)
> >                 h->resv_huge_pages++;
> > 
> >         if (folio_test_hugetlb_temporary(folio)) {
> > -               folio_clear_hugetlb_temporary(folio);
> >                 remove_hugetlb_folio(h, folio, false);
> > +               folio_clear_hugetlb_temporary(folio);
> >                 spin_unlock_irqrestore(&hugetlb_lock, flags);
> >                 update_and_free_hugetlb_folio(h, folio, true);
> >         } else if (h->surplus_huge_pages_node[nid] &&
> > 
> > I'll test real quick whether that resolves CI issues ...
> > 
> 
> Yes, that makes it work. @Andrew, can you fix that up?

np.

From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-hugetlb-account-temporary-folios-separately-fix
Date: Sun, 22 Nov 2026 19:21:43 +0100

In combination with

	mm/hugetlb: preserve persistent flags when returning folios to the pool

This results in an issue during boot.

This fix is required.

Link: https://patch.msgid.link/45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org
Signed-off-by: "David Hildenbrand (Arm)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-account-temporary-folios-separately-fix
+++ a/mm/hugetlb.c
@@ -1792,8 +1792,8 @@ void free_huge_folio(struct folio *folio
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
-		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
+		folio_clear_hugetlb_temporary(folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
_


