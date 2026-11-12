Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F15606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jIyJXJHC
Received: by kanga.kvack.org (Postfix)
	id BDD136B05B1; Thu, 12 Nov 2026 13:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E176B05B3; Thu, 12 Nov 2026 13:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4BB6B05B4; Thu, 12 Nov 2026 13:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 766346B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC325A072D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:28 +0000 (UTC)
X-FDA: 85427272056.19.EEEE0C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A105180008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIyJXJHC;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507387;
	b=U83P5baeDHDDYDCIFDf7E+v9pSQBdyqauSqAU47iHLKSBwiD0RBH4vOVwn85c2kyvNTlZo
	cmWOogaK7+j6F2DA4j+QhIcyfkNhrcNyPJyuX76Oh23r7T1gP4wIvqISAwITkmi6Az9BY7
	IDAh/AJezRFCXNvpcrYR0i2CupXrHao=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIyJXJHC;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507387;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjjBfepTHESBzybKek48HWdLoC2qHVxXikPtLv9Tp1I=;
	b=oEiRJ58x4kQB039SfiNhwT5v5lNP2NmAZHhlrBDjNnF3kuAJl4l1rnnYKYboryKpOWXyNq
	uwp1racAtot2nSJpQmQ6Acp4eCJRacyV5kbXhsjwOQYeTHqRM6oZVgfgJJCz4Bn8MSzkGV
	uGrpHUTYRf3JuIjXYr3NqFCxRE+ZL3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D77D448DB;
	Thu, 12 Nov 2026 18:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EE31F000C5;
	Thu, 12 Nov 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507386;
	bh=IjjBfepTHESBzybKek48HWdLoC2qHVxXikPtLv9Tp1I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jIyJXJHCqbOqmG+izvjlOBnXlE7wOm1n8z5PhVlSeO4vWUGat4EtZBY6jVaUafyuU
	 J3Iu3moi1JxstdxBWLplr2o1UKn/gvwBVUAeeOk34mSykefqHj/6+Xik1wjXo9TiFW
	 WPRM3rc8TN49IV8dyc0x6nuarOtdJUrTSyexIEUXcfX2e5aF03pb2+oy+zBI1LF7pr
	 hVLj8v3nZLMeaRHBE+wMT4CtgfS7dUMPKIy8LO0d4XWsSBuhIno68rJ2Xqc1BwK/f+
	 LK+YvBeHVhWFhk7K5ffg+lwn+TRAcvZvgibJjGJvu89QX+ekYKgM/+0cFR3R+QLua9
	 nNgT7QRDhbcvA==
Message-ID: <sashiko-outbox-211675@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/13] mm/migrate_device: allocate THP deferred split
 heads
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "David
 Rientjes" <rientjes@google.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Balbir Singh" <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu-cheng
 Yu" <yu-cheng.yu@intel.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Peng
 Fan" <peng.fan@nxp.com>, "Josef Bacik" <jbacik@fb.com>, "Chris Mason" <mason@kernel.org>
Cc: linux-mm@kvack.org, =?utf-8?b?Qm9yaXNsYXYgUGV0a292IChBTUQp?= <bp@alien8.de>, "Mark
 Brown" <broonie@kernel.org>, =?utf-8?b?RGVubmlzIFpob3UgKEZhY2Vib29rKQ==?= <dennisszhou@gmail.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Josef Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 18:16:24 +0000
X-Stat-Signature: zbqhjpdg5xw3x964y7fw7i3o8e65nzso
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A105180008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794507387-206598
X-HE-Meta: U2FsdGVkX19BYxkAok6XUol/9iWP3Svq7kwq53352dtXPyll80UWMA4gWIDPQ9sIvjklhs/vJVgo9I5nZ6L601h0/fb9zqrRbiGz69T+Be03QUDedbkdRwkcEmuPOFP+PQWTF9Lq2HeEcDVZ805A8ws1zokSgU1To83fSv0ucpRnykooFXiJZ+JKds8maXUhMBqKINMjoD7NS/58M8izsuF6FZYzXqSJj2IBslLFOKPnNRBGgJPTdSaqcX9lOqJS5LDPsAml8ZMqmA8qekQeoQxQYJyOahpPfMMcbU9eTKXrozPIv2DErRcAXyfmEk5QaGAWabBqVgNy8AHBk2GTykODnZlseRCnOCTDx5jcnRM3YKJrcck5AD/fKJqKu5pktdgc2CB+O1ZCTEGLb54MPUurRrYYtjnF9v57GeNKkq+WdNUvsmlarlUInHkK7pnt3SjNOdnNzasGCTLTrB6S0JKo8Hg+O2TAyhk+SZVEcXxuNB2h1b/ZYjGu4F+/7pW5bE9+uwh6s7KvvB9eJk6hUpcQwN1QZHyQ5gY31J4/UHLk/ZhtZBhspqSmJjq7IoM0RLmrH+eY9dSX2J+UcMx7lzYP0aNoXs6HtUzODMa21giE0S4oWLe6l5JngL+BQrtTt3+lvKgUWPLYk4KnQDlDZKFahyuDIxM5nSKvJKCUCgllDU6mbgj+mzD8Gtua3Eqmx38fMYRZSgg/zDifm5t8yi37GhSXGqLjp1/KO63YUQG6JQ4CVNYHUDg2y79Hg0QXWmt+XSJI8S4e451/GJZJQSRpQYXJzNzTyMAqw6gE1DZJIWw1jd2E8o1UMWogR4WOM91cYkgN9anHppiqsdkSigqyxSyKF1/QcBEwOnhFpCfMyBBRBf3a5X/O/gehsxjcbDZtTt++STkupcozXVHgcOaqgpuv7kBdB9uMEUZSrS2DYKPLgug5jMt0AEN4K9GHEFraytiq3U9a3gvLQd/
 ZjyitXaK
 VJmuhys6FmqBVQpcr32PZOWgZosi4u82TfaAJHuwQ3qdCprU60YKlHXYV1obfksChztgyNLPj2nm4Sp0t98mv/95GihyzdEHXCdKdGiCM4X2oKZXqz7EkoesgxMyxyfYqcmVwEotjYgiTm87Hd/bc1bCjAuB0Kbq1Kh26TEEWFlIJcqO/JW6XDnx4L0SCg1apDmC0CjnR0XXP4kMbikFyWqzYrhPwpfnk41dev1Gv99jNuwQgBNbKun4Stzl2RV6fmcuSOlEo6Jp3zmnRzKhEMqsF01gAuW+RM5C9h7t24kQTRzT43wKDETDEdDl79+1/9/kJHZNVESBoonScFaAJZp1CWekkmF7AjgkKW2rxlTPacJJ94JcU+yBxE57Mzh+HcrjnP5rgCyukGzZCJaeoHa4+oj8y/bBH5J8ZvrELWL8YLpmlP3ZN2iVzAE1LRcIGhc0xswyNxVpGRlNvCuz41kIHpkwa5NBBsYYFnZBUahTI6IoUiU8PNr30f8rtmriIA7LSfb5MsD51Kn096o88IO3rnpMvXMZ33PuS+8nVccMdcSepaZDVGwf81ocKSh8nrOFSdZ5e09S8WCSXyUXH41sOyN32onKbIAIw7PY7AvmjptAFmVhD0yR9MQnWVydi8uADd/1LE6Prufwejc3v3BATJdeCYN4XAGr6K30w2KpbLlV0LF6ghHrLflLDMaVt36Xt+j3vjPJk+fl9SXRfhRSvOPmTkt6KjpBmBnhkL3hM1irxHkwhzQ3HEON/GVosKyqrioxrbIwK2XQpl62qolivhGi+qtB7TXGr2d0HwjjYNQuId+NaZl/x9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/migrate_device: duplicate folio_memcg_alloc_deferred() call
  and dead store
--

commit fe6e0150a0f9ab0dcf43e8c18734d603b5d63191
Author: Josef Bacik <josef@toxicpanda.com>

mm/migrate_device: allocate THP deferred split heads

This commit calls folio_memcg_alloc_deferred() after charging the folio in
migrate_vma_insert_huge_pmd_page() and falls back if the allocation fails.

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 7919e04abc1c5..edcc13edbf6af 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -840,6 +840,13 @@ static int migrate_vma_insert_huge_pmd_page(struct m=
igrate_vma *migrate,
>  		goto abort;
>  	}
> =20
> +	if (folio_memcg_alloc_deferred(folio)) {
> +		count_vm_event(THP_FAULT_FALLBACK);
> +		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
> +		ret =3D -ENOMEM;
> +		goto abort;
> +	}
> +
>  	__folio_mark_uptodate(folio);
> =20
>  	pgtable =3D pte_alloc_one(vma->vm_mm);

[Severity: Low]
Does this duplicate the folio_memcg_alloc_deferred() check that commit
ccb36031e6c7 ("mm/migrate_device: allocate deferred split sublists for new
huge folios") already added immediately above?

mm/migrate_device.c:migrate_vma_insert_huge_pmd_page() {
    ...
	/* The charged memcg needs its own sublist before deferred splitting. */
	if (folio_memcg_alloc_deferred(folio)) {
		count_vm_event(THP_FAULT_FALLBACK);
		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
		goto abort;
	}

	if (folio_memcg_alloc_deferred(folio)) {
    ...
}

This calls folio_memcg_alloc_deferred() twice in a row.  In addition,
setting ret =3D -ENOMEM before jumping to abort is a dead store because the
abort label clears MIGRATE_PFN_MIGRATE and returns 0 without reading ret.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-mason-migr=
ate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=3D4

