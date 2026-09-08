Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4503CC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52ABD6B00AC; Tue,  8 Sep 2026 11:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503216B00AD; Tue,  8 Sep 2026 11:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419906B00AE; Tue,  8 Sep 2026 11:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228236B00AC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:17:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBFCE1A0665
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:17:49 +0000 (UTC)
X-FDA: 85190949858.12.2F62711
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D715F120012
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:17:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880667;
	b=iX1/5GNj8h6N5HR593MZhaomKkeyUKddOb9Aybg+I+u9tHTew744H5G+drqMen4MajL9cb
	lPpGIxhc/dgUA9Aaj9e4Mp7AR0rQdUg76oTsQeF9G6az6m3KayiZB179KWpk4FHdJEp834
	jB7cdJMGrKNJqhkemABPkPZeZLM4BMQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9A5689n/yX4qyo/7QW/AHFbU295vJ1fQFrrRRyzZc68=;
	b=fJEm8UOXK+IerQf8B0WCqLbryQOmJWppFPUn1ow9JBi9iqBfVG/06Ik2N32Iwey4osCYwi
	azz4OgoZk3OmFj8AaTanbX6Oa9s7IszWy1mNpIRo82NrexRWf6HkR7yAZzKpfq7xBxa8LE
	6N98JjnoMJtFXCqIhF/rX9ymgqazgRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 660F0601FF;
	Tue,  8 Sep 2026 15:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648D61F00A3F;
	Tue,  8 Sep 2026 15:17:45 +0000 (UTC)
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id D6DF8198003A;
	Tue,  8 Sep 2026 11:17:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 08 Sep 2026 11:17:14 -0400
X-ME-Sender: <xms:9SagajXg1RB4nxgW4qnXDcoKsra7V2dptsNBql8bDISIv-4-DKur9g>
    <xme:9SagauofoQANoc9VQYWNOS7gmmDlKj9Xyy0f8_qwvrLtjoJi8MYf3gac-U5jR4wL-
    h6PDQWbIfVkYbFkzrjoKuIGPN0QjdenGGPgLWCDZASZs3Eq89f4_IPd>
X-ME-Received: <xmr:9Sagatf2GlJg66_djQc5uurRk_Bb8gb1xzkZjG7avsSX7knEkDbkOueB6B4>
X-ME-Proxy-Cause: dmFkZTFEY+hQ++eX1WT0d18QISpjnqopgTIkTc197fr/D4AEUM/kc9KqJeyRYSclrYcP1c
    XykK6bKruHR9a9Af6TdSDfsRwaG0kuuiFTdbIQxK0fk3sJWTHJ1nfw8FEUmTzotknj71xz
    ml+JfT9VDf5Irx3HsqSaHqWmzJSSZjIFodSXvbmHW47PYVrsUSdZxAvW8G8hgFc6dAjgGg
    hIuIT7YGTr8AEqqpO7ulwGdMeSUijanAbRo6eMC5Bb0mGAR86bsnPNFSQegPUIUlnM/FpD
    e1MjPa5kV1P/j+qJjlVxnW9QC60gKJfVmkd2WdkLUiylOJgEzLMW8q4uD/mz/iHHpkhnkK
    oGS2xZxH+SJdDuw+HJrIlfx1ASD7Li7KrXQlauJuQjpv8nzZs/8GaOEfZk6QRR6CzdnbYq
    slR4AO/Tak030cDixEegZCJtBAn0qwU4u4woTew08cZKE0ioMqC4aLSlTTc3uoL0ECwTXm
    M3jjbkKo7NQRgK9nRF1t6gPwMEJVc2MRxcCbVy2636MonWJ7opVvqy1q/DuZGHL9m2ctCw
    3ew29fDEF2dlS9jG9U55sWrILzyeO/VLxPwn2PNvX1iLvBRZIK1VTtpzCQhhackpig/06h
    TB+rpncREgHvPy7+mR2mghL8eO14/k4SSKR9iziB2m8/dBF+ChENHxJTxL8A
X-ME-Proxy: <xmx:9SagahyEvNX02bBCrGheIE6-kFIGZCXlIAQuY22KDBx4kdWXXpW4aA>
    <xmx:9SagajuUTuOakc1CAB_HY9rMxpwX4utANbMf1334Yp9T0XbpFEQ8Qw>
    <xmx:9SagapAAOz-z1mLcYXrvHV7IJ2t58G_E3VqPvjDKGoKEZNLkK3xF6Q>
    <xmx:9SagaiqOR8ooOREIhyv9zVoxPchDstdzbCBdlmjl_2-a2vymCax4ng>
    <xmx:9Sagau5zXbyaqImztS9EjNCScpYqM2T8u0zP_HXzW2kseOqFMAlYr-6f>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:17:08 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:17:07 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 09/17] mm/huge_memory: rename remap_page() to
 remap_folio()
Message-ID: <aqAmezgS34JdeTVX@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D715F120012
X-Stat-Signature: 3a6dubz6dos5o9bxadrmbwqrtm5zdzfr
X-HE-Tag: 1788880667-589492
X-HE-Meta: U2FsdGVkX1/xxGtcAxXxD83xHMuLkn54d72VNT/64V4tIko1s7Jqmr552Bu1HvLX+I+Qi6Ho/wiLtA0uMhAWKiJrt2Yor2nm1EriLlPXCoO7kGJ7pcoh0bFDp/aRVi2YasNlVQLIhSnDdE5BaUbYWLkwMCENl/qMfMBcoafb1nK1OqWhvT7PoKcImUSafiFTUfuKc+iR5F0seGOgkL+kxbVfe54ZViEpAFHpwgvOGAeUMhXBFbQZrlXg5l2h+k6rFqjZwaNWMEYVy1lvpdXhOmU71gZ9VXwm174JBkFgAmyWgTFX9lZDcPyhNKoanQE5nqdNdLOoVjjH8+GDb2vBmv6ApF8wdoh40prMI9+M8Zu2vKnVICef+tahvEUR+CGiZr4SkFRtzNyTe6iq3v6fyFux/nAHLlp7h6x+5UNOikzYmZajx89Q8IcrzLrdgbyDGvw6/jpjyd3MNV1K3uTC2fwcAWUpv/kZFNq/3XZKFitGD2xCiL3VOP9SvUnkM2ooOs5+jzxB7uQzRj7a4/9QanenWsSs2r94VOPl1QcVSBiptjLFoXHiXWEp6j9oeF0J258Zx9b5T98pVMkcnvycGmK1OAef9X2MVabhpJGKZIYqzswiqOXjqFqBU/5a/D2pxWQigbylE7ZrDlMBTm999Y9xo6LxajTLxM9ciULCfqSY+MbSi9Cc/P4tchGk5aJeDC/hsxu7Afe6Ifl6vY2sSCwrVemv6NTuhaFEBodk3EHjmd0E8n5csGqGqifR6L+8W/SzjPlbbBCQ1LilI98ivBH6+kk8B0fY7ZhgX//vbY5vtZ2Ch4OhwvLqMXRGjkAmCxWvrhlxNJdi0DH2FFv0kU5kDYHE37hxBdkYU/GZQ4Fpyz9/L6M3I1jWLB3MXobwYhs8gljibdwe5OEVvRQoEMf7J8Tf6K2x+rgr78GrqD8jozQea2RuJ2FxQlp2GEiKQc7L7849VVcGaJ7dGCi
 vHsXV6kM
 pHf1yE/Uuf7PWx/0Frn4wEGh4pqe14h8NlIC8Kyi+OHWtOhs+0/JODMiPM4E++tIQTDzVuQJeFhoHc+QlR2SGiOcRggvbLt1nNbyWvrWTYWDwlwoIvCUPBxhCnHpwnAckGFJhtj6o2UzVt0Dpix39VfML63O7rV42s+cVC8i4wp6Y2RSFXx6eyH128jC4zRM9ADprHLeSahCQSi81sDGU962BtlqokmKtPbn4deu5Sk/Pi6ggBcQC9BeLpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:13AM +0800, Kairui Song via B4 Relay wrote:
> @@ -3636,10 +3636,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>  
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_folio(struct folio *folio, unsigned long nr, int flags)

You opted out of indicating that the function target anon pages as David
suggested? remap_anon_folio() seems to be fitting better.

But I don't care too much:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

