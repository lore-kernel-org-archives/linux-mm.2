Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC463606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITUoFWnm
Received: by kanga.kvack.org (Postfix)
	id 091C46B020A; Wed, 21 Oct 2026 06:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069CC6B020B; Wed, 21 Oct 2026 06:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0EF6B020D; Wed, 21 Oct 2026 06:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0D436B020A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:45:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F55A805A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:45:39 +0000 (UTC)
X-FDA: 85346302398.26.9B2266D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54999C0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:45:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITUoFWnm;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zsif3MYLSFHQaVAeajAin29JnyY4ARKYrABwitLB9Rk=;
	b=QRPhsMPmO8wxwylZDhKzalkWDm+nLtl78R8b2gX+BfPEWY4xF6mxXFcyWyb1J+ccvO4ACf
	ZGLizdGTgeaVOCNXaPnvhthHmn8t14lv0qPjFdEyIgKCUV/eLUdfcJWt4WaYmhv9QP+7tN
	bxwXVmSfhaA/Xx1nQ7kaSxaGeQ9VMnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579537;
	b=yVwb7v7XsZUPLmC7EoOCzJALphdIt4P3iQN2Vyo7lMh2Kx6nidIU5h4iFQYXob0G+3X0MK
	G0KFguTlOotDsR8nFlI6+T1POzmsZu93cL0DsyUz5pDUkizuEOqJ5hkKqa/UOt7JnF0H78
	c/JC72fD1S3rWFt4KqplTvpLsEg9jkg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITUoFWnm;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87DBB43D60;
	Wed, 21 Oct 2026 10:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA671F000CB;
	Wed, 21 Oct 2026 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579536;
	bh=Zsif3MYLSFHQaVAeajAin29JnyY4ARKYrABwitLB9Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ITUoFWnmtKQkesrydomGXhgVh6suxMt9U+eAPECm2bS6NIWx0OnvPgp9Ci8bzz5o6
	 Iw4Ta3oHfnBrpKhlThbz7Z+HS7vq88EiXKxUfLyiD2ijaCgNsKIhI/UDwYAUo7u2qe
	 oTOGCK44SOPftpzd89v+sYaI+GzO4C4TfHgsGc4lGIni6CwBrLfy3iFAUysMwAGhcn
	 hnTDFjkcAfrORGDAwClR3Z1a+sa6hu1UItqQdyCko4uXm3UN1g3QJECatsA6HKwygZ
	 zc+XUedibMaf7MSN2FOX/oXPlMUK8GlykhWPJprupCQHp92dFJPilNeY5pALSwobUT
	 zZD/tBhLzhnQQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3CC6E198004A;
	Wed, 21 Oct 2026 06:45:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 21 Oct 2026 06:45:33 -0400
X-ME-Sender: <xms:yZfYajk1SVwZJL2etJoKFZN-C4ohiZpbZg6EAmmaN_g5NuGrTYGYFw>
    <xme:yZfYareAtwR4eZ90nH3KOh4AXJMscwAu6JuENUOcilG46IIS2Uj8g_2T3FJ_h36Sk
    JBEyayXhq0nLsBqTf3T09M0SlavfTuRFAnif9mHAR6MF6l-rCL5qV1c>
X-ME-Received: <xmr:yZfYahzPCvaDuZUacNeT2K55W13M1htWPgwTKP9YN-qioxTqJG7W8T-32os>
X-ME-Proxy-Cause: dmFkZTGjd0a96U9V2vCQJLOMnRP+wBw1u1T1zryEKh7wa0310J6MaOgUiIze5CmLw2GV9H
    W7t6mlprVd+kvbSxqwnutYrDRHFq9thzgxnKvzoOneg/m+7lBF9h6ytrT+iKjxIUuf+vvN
    y9Cq7W4xWk7YVHBR3ir9mF0JQz+UsddF9RY9ecD9IhTffHR77HlcEV22e07OPYPqpykR1c
    Wbn4lcV/ZHNQlUrw+hxoN3dRq3FexhKkQBbUB2wMoaOQaVWFZvvUIADdR6OZTcM2mOgGbt
    Bk1nFt8UG7lG7K1JW9O5KIcUOduE5+An5YPc7EUyj56sUKNTOHdIARZs+z4z7vm38NyPkO
    wmSUXNPpxjcQFp7/JkJjUwG76pPAgcYBdQxvJ6P4aqeaJTbZM844gkr22S/ig48+kIad7U
    Djp1LfHzH3bPcjoFPQwRqL8I8jmrSMut7I64r3tTqNHUcas8SMKa5FnnfSxdJVyRdqBTSl
    vVoDVVid5tQMWpVWKGQYCcrdnpu7vGKgsS42F8BMXd7gKOroHVPpFDeswMEnjQSZA+yLvI
    HfWbQgiVG+kr8vmS0PrCdjOFK0y7wfS6DGhJFEjaRI953nvts016DGEPQevp3NpVH6Jkeg
    T228p1VaGhC1FU4fpGyxJy4addfW2sr1D6fUdC0yVGrxWHqoJ1vIwohGDkkA
X-ME-Proxy: <xmx:yZfYaltlWgJH0iQ_XyQYetAnpv1cS9Flskc6TVHt2Fm5HIUvXyQvyA>
    <xmx:yZfYamr-qW0eQ-X6lNXhK-8yGIC-YpTuJJ7qYGqeXvy0jPyt4c-Z_Q>
    <xmx:yZfYag07UcTns2rUJW6IaMSRlce-bFbGeqbDrUkmNwT3jtZFMerA0A>
    <xmx:yZfYaiU5cEwtulAkG0_t8jDRrXHGQ02KtO60MALEosyCFJ4hl88xHQ>
    <xmx:yZfYahf1xhEj98DBGsJaU0kLdz-iJVOf38BnjH6MqJBIFWtMqT9vyRO7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 06:45:29 -0400 (EDT)
Date: Wed, 21 Oct 2026 11:45:28 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 09/10] mm/hugetlb: don't leave a uffd-wp marker when
 zapping an RWP entry
Message-ID: <atiXpldwe6HbI-aV@thinkstation>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54999C0009
X-Stat-Signature: sf34dnxq5x3w555xxfo1x5mmani9zmog
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792579537-422057
X-HE-Meta: U2FsdGVkX19u/eN3Uu1Y11yihNOQhPwkk40+sYzvHXiCbpMIuOF+X62jbp96fGSfzibrVeGjE2fRgdUEe7zkAZnYogfVXIVJQpnE1FgVHqDemMRWT05P3tU9bitqOh+sXSXYXMTFWmNxvVLC7LryG3870rz4w37vVoa823wft20ey8fVPZnHz8XGzrdw7hrNtrIZ43Axt6zAXtbukubfDl+VumZpqfbtgkCZKEgsB8JZuCFhOlx6BgqvHrrTNxc2a/yyzOpQkbBdoe1wGhl4lCymgsuV+C5hW638flj7atM9j7COUR8fZkzl3RJqG9sENhtZ/7EPJcZLEGzLpt29SG8Hb21Z0QJReW0JjpHU1Y8QfdxGNag44FPfxfdaui+xFF5QT4ApyoogqVDtEOsbnqTm/mtnkJ1ZNUMeYAhx8JlVb+hHGRWzHgWYJMba9O3jLwjaIjzBAwaLQixjA2aVfpjEETSJR/2nvFIHpNVmHoiOq9uVa+JNa1RY6FQUqYPfYSNPptuyPBgFBgQtSULbCxnpmHZ2j7qgIDKoLXvnSALG85Kgs6q5m4jI/W7TnZSu7Z+dh3vpk8RJiT5BQpoy6dXJfTvy2UVIRBVbUxcfSbs6vB5bgvMWWhT6+4wRi41LvInUQ+aM7PYUfmQNlPpLmbNTbO2e4rB+c6JcOjMko/iCh2g2rMyF4RCp+IJQ6ee6zqBJV3iOp/Vfz+D8Pq4uUI5QB6tErH+4T5iGoD8ymz6QHD0TuWU3RmSzCeU/kfr7CguXPbta8G1sLlmcpXQUuE7C0/CIg3vDdUs5ElmgxsCWEoJl9rV4HfbOrpI3pUGQ35iO8UlHT6zEBbj8Lhbsf2l4HThwrLQeHYWZYS+gD39M2Z3zV0rhoAvXwdAO1jZWUhWQPtSMjisSH54op0zR6EzF29LhdtfCCsrdP5NaMZr2BA/88GXlX84SgaQ5XJ5uve+xmqvmW3xMNcqMmEj
 HuHYiD+R
 yQdi+Xg7V0S3jy/POPbjIPxOTb7M8ejD6vPOvm8ildYVHfLDwJCN39RYBjEAcvj5PSgkrqmFEkuqU+Rq3tYaXOd3HetBjW6qFG1g7QZHs3C6Ef+zDCaGKhNo3kBziYBbNXohJVOn/KCMJVXjzoXbR3GsoAPCmBcHJj7ZY6Q0Azg83ZcJy5Epz3u4Vvbaia9UJULy2WO6IlraHm3KI6j/u9dnNKsfgcK9O47To7cPxqEu2RY4/Qf96nf1YWNNyedbsn9iyE7xxvPeoiV0IYrFMOCZl2ytj+dcO4xto+fF/I5Gn+N8N4CQIrql4O91ZM3KSzpdLY//XTA8dJceYHr1aMnHciE+V8Vn8zyv5XNBtJTkIXHmPtQ4iy66Qu8DgkFWPLotthmCa4EIT4WZtpTrgrH/M5zWGmR05M9Pz6Y4+EaqEyXcarb8U7A41iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 06:07:15PM +0200, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
> uffd bit set, the bit that userfaultfd write protection uses too.  When
> __unmap_hugepage_range() zaps an entry with that bit it leaves a
> PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.
> 
> In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
> nothing.  The next fault has hugetlb_no_page() turn it into a present,
> read-only entry with the uffd bit.  That is not an RWP entry, since it is
> not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
> registered together).  An earlier fix solved some side effects, now just
> stop the zap from wrongly installing a marker.
> 
> Leave a marker only if the VMA is registered for write protection, both
> for present and for non-present entries.  The zap of ordinary page
> tables has the same test, in cond_install_uffd_wp_ptes(), and
> hugetlb_change_protection() says that "uffd_rwp does not install markers".
> 
> After a zap the range of an RWP VMA is simply empty, as it is for
> anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
> a VMA that is not registered at all a leftover uffd bit or marker is now
> dropped by the zap and no longer kept alive.
> 
> Original fix generated by an LLM and sent in private by Josef.
> 
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: a bit of description overhaul+simplification ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

