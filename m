Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B85D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Trrmgr1B
Received: by kanga.kvack.org (Postfix)
	id 5149B6B05B1; Thu, 26 Nov 2026 08:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C51A6B05B2; Thu, 26 Nov 2026 08:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9F86B05B5; Thu, 26 Nov 2026 08:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBF26B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:14:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A06E11A0FAE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:14:44 +0000 (UTC)
X-FDA: 85477314888.01.4A85C50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D08511C0010
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:14:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Trrmgr1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795698883;
	b=rRGlly9dp39vJbehWo/YjQ8KRxLBIT69rm7KitL1sZ7c8OIDWqMfdVh7OyDoMxF2rCAGPD
	jwnSxNMp03AuBraE8741neWfVv1E0LeovtdDNipkC5UMxecAfOUv0JqxYMmaagWRwemfhw
	I5PdcElqSZNCf6oAXikKvX6UHDq0vEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795698883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzrFaLrOdtynZ+YqTrHBgX0gJsOg0q5WJ1+yf3sSxY8=;
	b=oXgwS1W5guVwfFNpVKhux6gXNheZyzw3NIyJDCMLcSJUiGAgEX0QCauiVuaqY4a3nzkb+a
	O6t4+mnN+jIymLkgh7k/qSeXG4kCQ+gRjhDG1Mv+nfwE58Tpr3YDbeQJELPm8Xx26UDT4f
	L2/WtklusM2rpSaj+7drpL/YFD+V5lQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Trrmgr1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F34C4358F;
	Thu, 26 Nov 2026 13:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C6E1F000C0;
	Thu, 26 Nov 2026 13:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795698881;
	bh=LzrFaLrOdtynZ+YqTrHBgX0gJsOg0q5WJ1+yf3sSxY8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Trrmgr1BPEBD9qbna5U/e+HQli0WAAkfjJQlX+f2zwRKDn03tMFWTGigBk0QHEjuA
	 lY2gf84DYquCkVAod+yg2DyeQZhKmfSMqfravwMV1Qze5Kcx4HEi6bczuJt1GkAoJr
	 TvXbOqrghBtkKSgP3fLzN7xXWtcRFW6gEJdXhtwp/BHEgCrpK/xZiPrlqZDJqIKNuH
	 5AMWWCllTODXNr7+DP376agowqlSXVp+ycMgapV64BCHcHZAOS/FemIDCNdELAo4tt
	 rhmQy5QLzZml2MX55ofVcbi9UtxVnavgoZuOCvd0YunXyYd/xlbJ53BxKFVBg34Nuh
	 W8LHmKCPJdA+g==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org
In-Reply-To: <20261123-fix-rmap-lock-ordering-vma-locks-v2-1-11b04646abe4@kernel.org>
References: <20261123-fix-rmap-lock-ordering-vma-locks-v2-1-11b04646abe4@kernel.org>
Subject: Re: [PATCH v2] mm/rmap: correct VMA write lock position in lock
 ordering
Message-Id: <179569887717.7709.10576258083946748966.b4-ty@b4>
Date: Thu, 26 Nov 2026 14:14:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: c6ebzukpqkawdiac6i8rcpuukpk3pcrf
X-Rspamd-Queue-Id: D08511C0010
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795698882-668492
X-HE-Meta: U2FsdGVkX1/H68vLm0YjaYPOWctsdpmrQdk90pBaD2Sz56bk5QaOktURWWgw1uWNwbqQG7cmrhGMrods323pc59cJ2jz+o2iq8aWeIH3Y6SBN5oRg5UHk7LTvVZHwDg6yT1wrwHgjk8EZwprykJHg1Frokps58pZHhrPnQBEPPl0EMHcMqLZ48AbjMNexxVx7PYPDCVqFK69jZ2rieKS8LhfGCcpdfJpUnN4Rp28fx7F3m3RZOIWkVvoJLq0EKVUfAS7SBOaw/LYhCq3YI/0xY240vRNolt/aaAPDEh4k0APntZ0goKhHW41Kso5lk3zvQGbBWN49EFng6L6FXotOf88Kj+UbEPYjiTg3qUzEU5vBYiDCpHmx0HlF9BVNWT0OT+av929Jx2ocbNFV0TIcOYPG5bOT66x7Eq8noSsCZpR7rWuvQQK+Q5TNHX2bNsHmrMeIS+b0tyS/Mnd/Py7BWbLFuu4Kk1Lbk63wtLGXMZ4i4BgE2Ccaa4wDt+cblu+cJqzE2PvtQHChQ0qmfcRU/XmlvbUpnWLUJBpA+kq6yXpigsjbPcO0mRWA8LOvelgzQPgCVRFWvy/aG8tLa7w1+3W20wPPRY6VSFFhCtMAo6huFF4MgsEoP7V7iPJT7WjgXmjCIHRm7seTM5i2l62zbhsCNv1nASX1uZ6vch1xvegAGARf0i6PpB3rD3SaO58CykzGkAClLJDAYZD2msJ8MW7viZMkPSA2YsysnymV1zNUl61slQCCy7bm3WMjxjoukTESC+4CLzB8ZY01klLbFJn9YBg3kc1htT+mXQiYEAfEsjzmXoLqKEbrDKPkJM+Xs+Zu/L4dQTI45TDZ6a8bMSNGfhujwv32NFqkKYuslXFAPMcSpf/GNLHFi2L02nhnwTxJ6Jlxy4psEtkIi9ObkFRQbiGQebdOTxouMqvtqmbjS+t9h9uP59j8ug7soUdldXP05FQ3MJqLk2JK+l
 JWLfbe8z
 tdFSsB02LM37BrP5gFRzpZooW+ddDvavxdcuDWDxjwH5qEnyFM+uzxFS7g+59pZBpnMytVihSFX2UQ1Pl49vShEWBNUF+SxvhxwHceehASV/BYnwRo+RIzq+oaFRH0rgz/fWYIsJvnn3KZWeVJQj0KjUyqc+SWGXZ93a8IYWTfwt5ixoMrGFH+oUlt91qLlTi44l8ExFlgVXvzzpSR6AW6MYn1tluL8H9kh/JqeHJ7AjdmId/4F0BzPR9N7CI+q5X1IVtENQo2jNeRQDoiCneQWRJrlyZl1inHqo2PpWuR9aVbUA21f8YOwo6RiKs8zbAnU0ytXCxXbbTle7EWl86uGRtlqczM5mdxOE22Uks1VD0mNtWE+gNKqdA/Pt8lgpt9/GV8aqoubeTWDba+iQTGbqqLK/tx1Z1NV1vxomZt0mNDXH+tI+HL0c3RNp7UOO+jiW3w1OPocWpV0eV8nXvurAsQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 16:10:15 +0000, Lorenzo Stoakes (ARM) wrote:
> The list at the top of mm/rmap.c is taken to be the canonical order in
> which locks must be taken in mm to avoid lock inversion.
> 
> However, VMA write locks appear to be misplaced. These were added there by
> commit 55fd6fccad31 ("mm/khugepaged: write-lock VMA while collapsing a huge
> page"), which was focused on expressing the dependency of locks after VMA
> locks in the ordering on them, disregarding those prior to it.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: rmap-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/rmap: correct VMA write lock position in lock ordering
      https://git.kernel.org/mm/core/c/ddd689d1

-- 
Cheers,

David


