Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741DE606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm3 header.b=gTQv/y+7;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=MJgpk6uJ
Received: by kanga.kvack.org (Postfix)
	id 9786C6B0202; Wed, 21 Oct 2026 06:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9506F6B06A6; Wed, 21 Oct 2026 06:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865F66B06A8; Wed, 21 Oct 2026 06:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1F66B0202
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:32:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58A9CA803C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:32:37 +0000 (UTC)
X-FDA: 85346269554.23.1E934BA
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1C6FC40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:32:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g TQv/y+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=MJgpk6uJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792578755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ao5wRKo7Aqr2EOL/H5SIhA5Ty28X4+tjsBNb2koDVLk=;
	b=44Y9vgCud8qRLJ6+ovVCT2vYB+6cTlmw/iEr8yMNZ057pOHT7FejIUqa7KDER+VvAS20wF
	rzOQHBKBjK2ez99qLp/ecSZwl58kwh3LNO9j0JQGMBaWL0DUSh+mvHaF1u47/32anmpdKd
	mG9S/krmp0sxhF7mk29OXB2Tp4FXfVA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g TQv/y+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=MJgpk6uJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792578755;
	b=XFnM6W9Mv6qs22MUJolzEZAInxEwvcybfpQpAjkA6owfmHbxVZyOieTFJDUOh2zDd8YdUX
	U0Y1XEjQwhHxLHCGciGSt7Ues6eZtAMhNDeH9p7vBpCxE7fn27Fx+aNbnsbaR+tigCfn43
	iCVu6Qw2wN5pQLU0x9/ZNBfrWDaIuJg=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 587E21300F49
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:32:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Oct 2026 06:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792578753; x=
	1792585953; bh=ao5wRKo7Aqr2EOL/H5SIhA5Ty28X4+tjsBNb2koDVLk=; b=g
	TQv/y+70dORm84A9UVOlvuGtZU5F5a6eVyc9ce1ghh5B3pn0Gs0GBHqcb88ZnWUE
	10/z/DrERnxWRJgZmKtEZkKH+ZSur0OSpGN7nkq/RmazT6yep5OrLPFFw/e5CLUb
	3m84BSkGkeq+iZfJKEdsxJZ8F/HDxq853WekJU9SJeMp0d4Wx9fkNwpjOFe8yjqc
	avvI2hkIpMMHXVd1So+RJrjY8I/HFwO4OMiryEq2NlJIzbcdUTN1c0ngGOqR4Tsg
	RL1ErZufY87JziKGMgSeqJtpzvMKznJksCJhuCbur35v09Z32ExWRilIx8TVAOOo
	l/jacfUdJ4Delw0mbOIjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792578753; x=1792585953; bh=ao5wRKo7Aqr2EOL/H5SIhA5Ty28X4+tjsBN
	b2koDVLk=; b=MJgpk6uJafFLWK+gdZFyqyUsQlaTa0QnI5DJA10VyKNB22nHFra
	FCVPB1W5dtzlKcYdCaqTT1mGosqtro480kUsJZ4fE2Cqrvb6aY+R4FqwUGyt/4YP
	5zAId++Y9wjMTdoo9wvvEly+Q0rKCIlcvHLA2uOChmP+Q2oKwFzVjGOQWKDuh39K
	l79BstO0BIbb1Ox39I/b3tAmSFrx0h13hUSLE+09IJXgzPX13mf736vQoUfvGGNy
	GE5J5qVCClgh2KPifcJjL7R1zHuJ3KtqWuo8ht2OVeJIPshiE8VlVVGnpixbP7eG
	8rxOd08G379YiLLAThVa+KLSI3KijqVc0kg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792578753; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:qP6J+YoIw0YOwIcg0HEJBoXcP7pKXc90gw8pkps1C9Gv5bv
	zvEnuG43WoN/eaJv6RGhoxaBiysxRmCuaYS/Dnlh8lHJ9FItSf4BmhCQcxyiYQd8
	GZlpGXtde/75brZg8UGg1/KFHG2XdDNBb/3XShmKYZdQW5GAaPlsML9lnEmuQkaQ
	HqYEO0z2A39VcgEAqUJ+I4REQz11rEa0lEwsvFuwDa7aBNYIsik6q/nGCmCLdVJT
	x5r57UKHPtLUbAu+tK5n/aw3MdHbLJFA51khC0bsGY8PuTNT0xRwP6dMq9zcOEPn
	lXIBACSAFXLo+o1wcNJZLpZoW+xlHuACoCq6x5A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:0iGKCJbhYU0ofzk6Npyui0jqKKmOu7ZXpeh+imW0Z1s=:mab1Cv011TVDlRjbYop1LecBevJxhFR5JHPAi3J8Mhw=;
X-ME-Sender: <xms:vpTYai6ULHsFAu42jW498bwd6049ted7JtILPFXi9lYmxuk0U19jfw>
    <xme:vpTYaqaVGYsnsptwmD18SuFUP5TxvXfRTN1sbL5CArHrpNy4O5v802sS64-OZ1Tay
    5ccGLinrpbuzWeUPKFRG-bCOfFtGlXyTXjSprJj_3cI7jKIyY62qpQ>
X-ME-Received: <xmr:vpTYasQC0CIXhNEIntXyHcCwBuEQ77dfXpDNjz57lXnVj3m3qeOqzYJosBQ>
X-ME-Proxy-Cause: dmFkZTGnhrpawq32AodX1hclL8yoAmMZid0tB7OC5CEHocuh1cymOwJ/kQUvMQgGQBVneN
    fn8CQg4VkpXP52MPdVTziNPQNJDcNRcCzcA2XkYozz8Co44DHKT0iojkng6oG6FZQPyeVf
    BuHkztAvyKVOK70eSgjlNcQ1X5qCyAOLTNgi6uIWn6ugxfP2yjp+nn9XkM2Ob0etdtfI3U
    /4ZOai2ZCpmogZJNmjgkqW6zBtui9lcmEVCtmyVG7Yd8+BYH3ldpiGfPnNBWVht3EVBxTI
    EKI7KJaz5TnGAEPE+KhN1SRn4FjeHqOcRrH3Q4kQjYUDRgF0j+C1/wppVqIurAQNRysQbo
    lKkElDR2XjPF92/HwwcyPJZ/uI/Xk+ipBJbxpFveG9enESiTU6AmhcIhg/5iSX03xjrA5A
    RoWHvF4GHpHXuGVZWO0l/UwDjFLYUExUnyRls5uJpu3ktDw/ly6xGie836xV0vmAOcqQGY
    mm0w1xkMTvxiCoygk7Kml4uouDmn7PsmDgirrXZ/c0ClvHpK0aLmB/OEGUenwYQ4r3ATvb
    AAhCvG44jf7L3OFZ8+/vBcKB9aA6MoZvBGnS3D34OPsU+YQxTSsYJHOgnSr9RzRaJjrKS5
    kHN5SATJPs13eTr/9agmzcnG0slflFQFjvRlUlMDEEPW455Am3Cpy8evEslA
X-ME-Proxy: <xmx:vpTYalXRMx9bq4HmCdqouGvgUZwGcn382lcgaR4ziZNzWin0NwO20w>
    <xmx:vpTYahqIw7KlUNZuVtCzIk1pS660kj_MXpzeYUE-8UGfH6eF6MXz4Q>
    <xmx:vpTYanUJH2RoHRR8kiduC9R8zG4MZfWSxarW7upO46YsDq9z5T_-Mw>
    <xmx:vpTYapQy5KclNGY066cOMw7t9255muo-ve4Pyrqulm6Qsqvjmz3D7w>
    <xmx:wZTYav7C_aV_drMgYUoF5iXAbmfYqY0GnH0Hxy8k-fmPodU3tviYko3->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 06:32:30 -0400 (EDT)
Date: Wed, 21 Oct 2026 11:32:29 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v6 02/19] selftests/mm: skip collapse_compound_extreme()
 where the PMD is too large
Message-ID: <atiQmWnz8zx2AKI7@thinkstation>
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-3-kirill@shutemov.name>
 <5862cddb-a78f-419f-a5a1-15e16a422bf5@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5862cddb-a78f-419f-a5a1-15e16a422bf5@linux.dev>
X-Rspamd-Queue-Id: 1C6FC40002
X-Rspam-User: 
X-Stat-Signature: 1sig5uh8sht4eepzige6ad4n971hwphc
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792578754-76068
X-HE-Meta: U2FsdGVkX19eKClo2QeJgeyV4Aqin9Tte3MFJk+gUtcJa97Dpyl6oMBT9DX5piaUzLnHhnKR2K8V4p0gT0g7wmtbr5WCT58YoHQ/bGTkocvCALbIcxxW0CznK2fvXELkE9oJowoTUB0CyZkbcffmLS7DY2WYa8rtnKURreX9pFp8VDdLJDSOxBRehJD9vp3D/YLHK46jWFIphePKDvwTaazzSjJPbfWPnW6qSC9MX4PUjvbMPPMOjqVY4Ge6HQfyKcysSRYozS+rr8J5GRVHaCQGnWLc2YsEMuGUU6p9eSJHeXPkUf8EGZw8RWbuu6NBzICjDpNezDaM40HC1+rZTawXWolfroLymCp9bzWkN3PiNZSBTH1XwA7DGdEx+JUb7qapQHdCQrmmn4EDLRgK0bsPOYrVbHT5jLbqQHAnOA8HikcfuC71LIJwp8cQyeTnCBD82YHOfW3fuUpVFaHn68dAYouGLVEL8lJ0/2hLCiAhJbTsyBa+EhaVPUPDYEr+GASJnGEsv2AHMW15NnNUueU59tPQQaONzfBZxjaTEtwcS77W2EiggSi0W/EqMUJ1RbLEt1Vauo8BbMYwS/yMH+5N/JUtlSeQZvQh9TKQUh0jFSUkmpvAR6CzYqdSGsWCLo02HgYgR0qo/SXr/fGTK/X/EAQnjSGj7H5tfeERZgfVgzzEVb7MM6UPOr0nCuqlIJfRIvAcNkFhm6q9CTfl8PZs+l6Xj4MajViXp5kzH61OzbK9fiFKgDj0O3eDEicmzMAqi6VBkhhEaNHfFA7C8Hgwqu6GYDrXgPspq++x0XOWfQuU6d/0WMi0flv5ioBWighkzK96iEHM8fqwRm5EMXQsLXTCyggFTePQ2xCKbG9AFTIAfjTwEerHGsv6ngoMqpIh2Ixf5pfIkYFBOx9vJIdmzw4FPOz3OIUyxEHIExnuAgUjW+pg/42lhvNjqJ6vpG9la9DaxssaArUxP/i
 XeVSrknz
 x+bvM0DmCPXgi24sYreE3rA9h9m2E2ccNY1nmS5/Y+zOTsQNeqrSZdz+Ps7C4Iod99ahRf+DdPxyc7wnyAuuyG/XncCmCceVXtHsojo7IKpw7rR6423+FQZ+EI+R7d9ubS5/6OgyUA1cAbPT3ib2EfeCB6g2GVbE7BX6RVTjm35F75yBYyPEM+sq5ImY1Gmowx4YN34gzJOsC+TJy3B2i9w4toiPflbmf1JPlQlBRJlI8FcJ7oI8uKxakBj8MuX5XeyynYAKX2lm8b0Q84mgZ8+j/qwfhA49eeL138yBwiJwR2WRGrHBzI2gEw6UavsU31UkMQlqn6cHclhUhNqnAwGvhPiJa+J5a3RojkwuKHg1qdXqvnVxLEtf7naVEMe3BKW7w4IAJwjW5pBEUW94FDAAQn5lJ0orzFZXWemPYZl+alar3mb4pV8Ynh39L3S6VW14Jmet4Ico3xakFa3K/BjWgTfF9ih+gnor0UaffPRCeDhFMtFQ57fvON9jgytWUJzzveeoESxU6IIs9VDAfQ2GO4j0HM0E9esvGz0RLzldJbos4aIhIgEBALkgIiOMa/qBPLLSYcUZ9zNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 08, 2026 at 07:52:18PM +0800, Zenghui Yu wrote:
> Hi Kiryl,
> 
> On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
> > compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> > therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> > at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
> > 64K base pages -- makes each of those an order-13 allocation, which the
> > allocator cannot reliably hand out even once, let alone 8192 times.
> > 
> > The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> > whole binary stops and every case after it is lost.
> > 
> > Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> > still cover PMD-order collapse on those configurations, and 4K and 16K
> > PMDs are unaffected.
> 
> collapse_compound_extreme() failed on an arm64 virtual machines with 16k
> pages.  The VM has 8GB of memory.  Not sure if this is the same issue that
> this patch attempts to address.

It is the same issue.

Memory usage for the test case, assuming 64-bit page table entries:

         4K pages:  512 x   2M =  1G
        16K pages: 2048 x  32M = 64G
        64K pages: 8192 x 512M =  4T

64G is a lot, but I don't think we want to give up on this test case
on 16k machines completely.

Maybe we should treat a failure to allocate a huge page here as a skip,
not a fail? And remove the PMD-size gating.

Zenghui, do you want to experiment with this?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

