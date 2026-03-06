Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48316F01829
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8886B0005; Fri,  6 Mar 2026 06:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95086B0089; Fri,  6 Mar 2026 06:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987F86B008A; Fri,  6 Mar 2026 06:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 866116B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:21:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16BB88BD9D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:21:08 +0000 (UTC)
X-FDA: 84515396616.21.E0509C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7ECBCA000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:21:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nnl1cyFK;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0cUyBLVnnKO9NDoodcVvMwgb8JezlZzkHvJBlzEEOc=;
	b=CCR7GK+XZKzI7k73Y02vYr09Iel8NIOue7ioLT95BmarsEfjtiUZ+NV1cJMgIRxJHXO4dX
	UlxkI4Ajjbt6lQOvPeWb50ljIpZtNTjWA6IOSd1t1EwiQPT7o/Z6q70tppzuBcwV1zmEXa
	wfjFVLvwTtlG3lSuSEpasCuDDGK7Mg4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nnl1cyFK;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796066; a=rsa-sha256;
	cv=none;
	b=0GmmSHKKDCxdq1PlHHJD8HWq2KiQiPYRYXDUcWbuWpKiug5Q1ubVRNRFpD+Wx6s/4vNdBG
	s6f4cnS3wjNUaIdXq7u2MLQGSmq93CCbRiHWYhM29QizPkOqBmEy1XmADIiI/t8V3RuaZO
	54GYJbRO6MRpa+Opaz/wxaZ1vuGUb14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F413F60018;
	Fri,  6 Mar 2026 11:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D13C4CEF7;
	Fri,  6 Mar 2026 11:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796065;
	bh=u02aeqnFXRclw/eR039yZCHAqdr9WhcpaZ5pLVtd+b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nnl1cyFKfzBOWRn3cbJVyFNLclM4zq/UHgOtxCrm1I/fWDBO75scs07xLl5wOjDLM
	 hU52zGcpAwWbPAeQrvxuegNjMYo2gTUzDNkE48udWl7dbPlLFZeL3BTNbF5h0LW0nH
	 QWUoPwZRgBXUpJtJr1+UvBoPICimg0Jhxv7JlAj5AGkvG14h7e/nb2x0To3YNxvT3a
	 MNuyiL0TjwKNIgxnVqypfTN8Emx8QaivXs/xfvEwwYoKdt5z4wXRzzUlu+7I1DPWgC
	 xOSZ7F+uYvzbWyg+8dBdZKQHHpJpKH/vivHCDvmMRbFjVT40app3B+ZycTrO2Mc9L4
	 QCtP4jP7KvgcQ==
Date: Fri, 6 Mar 2026 11:20:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: khugepaged: export
 set_recommended_min_free_kbytes()
Message-ID: <043071c6-08d0-4618-9a9d-196ccf1caab1@lucifer.local>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-1-96b3ad795894@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305-thp_logs-v2-1-96b3ad795894@debian.org>
X-Stat-Signature: qmewexh78prhc33j44rsbzmjpj7rwx13
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7ECBCA000E
X-HE-Tag: 1772796066-185796
X-HE-Meta: U2FsdGVkX1+oI0ofhbG8ayuAp8inko/iGyMb1rZb1pbL9Bg5OQZAv67fnhtw3nRjGvGz5+jmDG1+pfrdxfhAqZx957aFoTVK1JedvhEoE085zf2C+puF/uuU71e4QtvQPppR/3uixH9WF+CKII0MDcIkvMzOT14WWnpY6230BNHRIbBceOdgGPfhW04Ifsdt+aY6nAvEoyM/Fw3uQ+ScUcVU8BjPusibunD6sXZYsiNKt7D90FKPGPvSU/+P4rbP+DDalEFLAcFSYBQUltGOHCRm8lra/rXaqV+LA7iRxwdRB/gYbrhS9JlxCxrb3XPgs9TG1ejKGMMN34osbL2mkvWhqVIjnN7cx2kMXAFJ0x6R4AcgIL/cVPxXOBn2wqz0U5TC8uClRgYPAg00QgbsAFBQt7Oy+RiEE25VTZFguk/GweJgLJPFcOiaghRkUKjP51hLRJISkiiSEJOZUDsE0JNLYibQpxcTke2i3vgaCtHKvJw8RDACSWAY1zQYpMnoTOyByRkS6jrvlGuD8pnwikfsXU53WMaRZMtPA273P+iZqUwcoSGKkYHtlRY34Df+oFa/4ztleG6MnCwdmK9D1mHVMQY3jNNdRnVmE0uFIo9up8JWdP1BQgljL346AzLqr+F/jUHzBGq+a1TpDD6yQ3dXKfZfCAfhpNFGRFG0i/pAXfF82YO0ZdNHOSHAc3XRHg0zIco/CAIYVijA5HQDMcWk1ggRemfFF0LXYPmePKZZF63Q6fLS0Elu9pxHzyDJ601C9qIyapGqNVoQCCd8owVJW9hp1+CaQpbYkIl+iSLkD9EOEFfRfij2JNha8mpNycnLFzMGb/nJ738iTb/D3YOlgNx7aJ9Z9QYVLK1uqvIqslasBMlRhjPx97rnAxZyXArgStowHMeHVXqvZBHCok8+oEdBP9sucERGHT+sl/o8wA0tDmdcbTWMZtqwX5f4hS/oqo/dUAq3hOfvohE
 7jBcJpug
 bNkzHEoGJgfe5LYrGeAKLiJTGVafzbEopymxHz8ujTE9zsNeqEBBaVz2/ZgQR7NbmuMpJBy3xBulXuznCgMCJAAA/YrV0IobqWJ1ziOax6QSuMrcJ96ZEiiR2c31Jqt0blD7AKKe2A9GlN6te35fxX+wgFU6+UuM754ekjHnbWqDK6ctTgMw3IPB43AhKy6nrp8gtJalcuHNsmOBlGvE5CtlloGzhQtXKa1tU35aXwnC6+6Dinizuh+ZrLmhEdqA+aF/TftkL+6QHLRtAXJJH0A9ll2VClw+j3WDGGY8erqkV9pSrKZTNwYEodu2XNDFAMQgqEsA+ufsQaGNn+RjwDUKi5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 06:04:53AM -0800, Breno Leitao wrote:
> Make set_recommended_min_free_kbytes() callable from outside
> khugepaged.c by removing the static qualifier and adding a
> declaration in include/linux/khugepaged.h.
>
> This allows callers that change THP settings to recalculate
> watermarks without going through start_stop_khugepaged().
>
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

> ---
>  include/linux/khugepaged.h | 1 +
>  mm/khugepaged.c            | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index d7a9053ff4fed..76252865fca4b 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -16,6 +16,7 @@ extern void __khugepaged_exit(struct mm_struct *mm);
>  extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>  				 vm_flags_t vm_flags);
>  extern void khugepaged_min_free_kbytes_update(void);
> +extern void set_recommended_min_free_kbytes(void);

Please drop the extern, it's a historic artifact that we clean up when we add
new entries (I don't blame you for including it, it's a sort of 'unwritten'
convention :P)

Also, can we put this in mm/internal.h please? As we want to limit who can call
this even in-kernel.

>  extern bool current_is_khugepaged(void);
>  void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  		bool install_pmd);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1dd3cfca610db..56a41c21b44c9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
>  	return 0;
>  }
>
> -static void set_recommended_min_free_kbytes(void)
> +void set_recommended_min_free_kbytes(void)
>  {
>  	struct zone *zone;
>  	int nr_zones = 0;
>
> --
> 2.47.3
>

THanks, Lorenzo

