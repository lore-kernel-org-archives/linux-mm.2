Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBD4CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE036B00A5; Thu, 11 Jun 2026 12:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5DB6B00A8; Thu, 11 Jun 2026 12:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2A86B00AE; Thu, 11 Jun 2026 12:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 821716B00A5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:39:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EB69C2836
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:39:24 +0000 (UTC)
X-FDA: 84868192248.24.7DC61BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DF7AA0006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:39:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJECdmOl;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781195962;
	b=NsmgUJt9C5BGCMF+rZb2wgXVtfeS9DmpBJXvlFojp5zsIGj14Qkx/VlKF/8VwZf3eBpsXu
	GskbxZxfXsVXC+kDq4vJqrbuNsuExgM4LSMcpeEvEKVAV7gsWlRJkmN79NNUTb8czd91qT
	ODmTKfw4XNgVety1jEiSrA5sRNR35Ag=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJECdmOl;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781195962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8j+1zlC7hMJNqYIVOq0PFbMVTaou4UfvLB7ez4lCWk=;
	b=2R2DTotTkzjGSzqrrgXDtMAC8lIRJvu0WFugvdQBBoj7NOmf2Gs1uQTijLQopGtxM83Cw6
	Auka9fHN+pm8GWwm3yOX4CYAzz0PqL7wEDp3lGPdh8LbL6pW8cqZHWmcLkL3YUzAG5NBLT
	tlK7mRMLRdGww2uWIuqddjr/Q0wVb4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 506FF43391;
	Thu, 11 Jun 2026 16:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DC21F00893;
	Thu, 11 Jun 2026 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781195961;
	bh=i8j+1zlC7hMJNqYIVOq0PFbMVTaou4UfvLB7ez4lCWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XJECdmOlaPRVHdUcTH+MqiDeBXH/ihHo1yWSAp7cQRCxWOovqzrvRf41RfpspPUgO
	 4wDZoi3b/ZhMzO8cwj6w/FW3gABWTyRKiM+C5wfdckRCLVkCI9Tgl8cKHCS6gGjq5d
	 hFQfnj7KCq9gFrqEcZB7dCBhNoLa9eyZxkzmT0tPwTZIWc0Jo5EmJiB7YoFhdl1jRK
	 Q84Qrs82Eg2nuSaN+8fdQ6fW4qgf5qOS4tHRnEtmWBalpzjcBmTQn1yefVKNB3JcQq
	 BzQlqEBOe5z+JtdJljfcdsMJdcJT2br/ExmR7cTqgp1cmgB32EROIOGG7V7tm4lFWu
	 PPraFMdpLYt3A==
Date: Thu, 11 Jun 2026 17:39:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [Bug Report] Elevated PMD nr_anon after running selftests
Message-ID: <aireq_jrgKH0zsNy@lucifer>
References: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com>
X-Rspamd-Queue-Id: 5DF7AA0006
X-Stat-Signature: p9qp6r9tcpurj5kq71nynuw33ykgcoy1
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781195962-73282
X-HE-Meta: U2FsdGVkX1843rwiLt0hJNFZVhpzNF0OprWOcw6/VfDjfCcCDbsaCQzad820aXHgxGsw+8vNhwOnPsYo0RN7ljHF6+uRSS+Xr8ikvPP4VnPr6EqlwKDNayJTpOp9O1I4zhFRVTJ8JDDHvgV+S5ku4AQEiG9KkfPO7Rsx1PEFqTdgpV5ABuIAm+l9OoRRl1gP3+bJc2+T/a6KheV2lMt/dajzdK74jfwhwYyiYmSkeCddugwyZ7JUUWjIH4VnAiIpoopGa2lgWdegRNpRU7kQRkDZe8CemDhWMRbf/RRzJ2kXkj0mO5/NbsvY+EGErwZUuZDMbrn6KxBaOBBQnvJyWk+OOlcgzYAwU8dUvJpoNwgPnAKqVFA0zgqLnHtM5XmU7N8ZrqGonaY/TNHL+qQnhi5rqq7TOuPj9dsDJPawN0sD7d1kQSqnL7XIqB3VvY7ftbD+DpO1k9K5p0LROvDsYCyE80Qgt6xHhMGayWcsn6ITBpKCQVxK4uuOpzg9TM6CYn9o95leV2ijpkXm0lc6IAUdDrwuQqawmNsLJfdoNEBvQctfKDmBcpbVge7yXrBzbwXIu+eZg7g9o3DrcN1pQRMjFpn1ZEAI0andBiBJTBkTFE4ym6DC+kDL3pdjtQ24WoIWfBJ2iqWym8S12p0P5xkBNEEvawUyz1RAAWpGtONMVnEY46lXCtrNnmUaFTXfo8W0twibCgrvtNz9J4Z+ICbrH6Yn3HVf7U2dns7wJKZ8EAmZ9X9lByjK6kTdW5bR1P9DVSwUpXu30GI8yALHcGiQUDNJlHeAYDeFmApNlvJtxz9AC4yT29www/zaO1rVp022DrTEU0p+ETICjQG2e4GQHZ3hnzm9LKHFOzVLk3/xInNjJy9la30071CemYY0neuqN/2TNr+WlVqCg10D5KhzXoi/dhgECX5SIWSRNbpjKF90U7U8uCzxJ+oEf1VyyIGDf4wpOn7BpJefD/2
 sPudjAKU
 rYrHzeoA6wiTB1IwtwAeOFi62WIz+ELj9kwfkcA4mI4jldr4cAr2JvBU6dQNWTRQ6881rPhnZZ7pVkAmLaczNj5OoQDqV5oOjOHFf0Q4B1u+yNuu8ErN96eMrBzcmdIHdTkZcZibIW1MKQl1lNgfZP081VYLccQp4+8YNUcIZc6q55LGrwcU784chomW3Duppj1G2rcBZIv1hQjV7BhN5iktFcf2oHBDhb6ChduHHilrsHB2dUIl1y7bsBUsU1NpWoShpCEJahdW2GHW1C3UEFNsL5GdHES0m+Dfk7wiJ69qJutXzh+WYCEsS1Oxn+H0WOthdh9P9mmW8qzbkePTZ3xb+OJVVnBgLn59HtpibOwZinWCmMfHyklHBhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 09:58:55AM -0600, Nico Pache wrote:
> Hi,
>
> While testing my mTHP code I noticed that mm selftests caused an accounting error in
> /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon

You're not giving any details? how does this manifest? How did you detect?
Output? Etc.

>
> At first I thought I might have caused a regression, but when retesting with 7.1-rc5 (without my code), the issue was still present.

Seems to be a regression in your editor's line wrapping... ;)

>
> This issue occurs in two mm selftests:
> 1) hmm test
> 2) migration - private_anon_htlb test

OK that's useful, but what exactly happened? Any test output?

>
> I spoke to David about this and he suggested the following diff which seems to have solved both issues.

Whilst speaking to people off-list/elsewhere etc. is totally fine, I'd suggest
engaging with the community as the first course of action is often a good way of
resolving things.

Even if things arise from private discussions, which is also totally fine,
please do give sufficient context so that the community can engage with it.

And I would suggest that ideally you phrase things such that you are asking the
community as a whole :)

>
> David would you like to send a formal patch or patches?

So on that point, I understand you're asking David specifically because he
suggested the patch, but I feel that you'd get better results making it clear
that you want community input :)

As one might misread this, and perhaps other such occasions, as you feeling THP
== 1 person, which I am absolutely sure is not how you feel, but phrasing things
a little differently would help underline that :)

Kernel review and maintainership can be rather a thankless task, so details like
this matter I feel! [and I realise I probably screw up on this regularly too so
we're all constantly learning :)]

>
> Cheers,
> -- Nico

Thanks, Lorenzo

>
> Diff for (1)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 053842d45cb1..683a77dd679d 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
>         mem_cgroup_uncharge(folio);
>
>         if (folio_test_anon(folio)) {
> +               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
>                 for (i = 0; i < nr; i++)
>                         __ClearPageAnonExclusive(folio_page(folio, i));
>         }
> --
> 2.54.0
>
> For (2) he suggested
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d9b23909d716..9fd50ea25d2d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>                 /* No turning back from here */
>                 newfolio->index = folio->index;
>                 newfolio->mapping = folio->mapping;
> -               if (folio_test_anon(folio) && folio_test_large(folio))
> +               if (folio_test_anon(folio) && folio_test_large(folio) &&
> +                   !folio_test_hugetlb(folio))
>                         mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
>                 if (folio_test_swapbacked(folio))
>                         __folio_set_swapbacked(newfolio);
> @@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>          */
>         newfolio->index = folio->index;
>         newfolio->mapping = folio->mapping;
> -       if (folio_test_anon(folio) && folio_test_large(folio))
> +       if (folio_test_anon(folio) && folio_test_large(folio) &&
> +           !folio_test_hugetlb(folio))
>                 mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
>         folio_ref_add(newfolio, nr); /* add cache reference */
>         if (folio_test_swapbacked(folio))
> --
> 2.54.0
>

