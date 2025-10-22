Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3520CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE878E0003; Wed, 22 Oct 2025 07:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495CC8E0002; Wed, 22 Oct 2025 07:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2718E0003; Wed, 22 Oct 2025 07:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF2E8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:10:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFE87BB163
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:10:33 +0000 (UTC)
X-FDA: 84025481946.02.3C4CF33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E0754000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:10:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2x9nB+t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761131432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJV7mcDwRnQ/N9m6adp++R7526QHpIu0spjao9Gw8Jc=;
	b=ADdOyc1IHpVD2MCSECdnkynv5ksiAMAMk20eoCfAKRekJO1RkG7jrQMFm5qTSbwY6BhckP
	013lw1IuyMat085V/zlDBgYieQVrbhz0gIcHgusIPSe6dhl/HqT00+K/h7EBJhnwHd4Jeu
	ObLWw+54RWHPluw2dSfXaFSqO86Se1w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2x9nB+t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761131432; a=rsa-sha256;
	cv=none;
	b=jlz1UamyLDcZCT77gpBeWg9rU20aAlTrQhru4zbJMeqTaT4e1GETTAmeFfvm0l4kEmgV9t
	t9SbQ695lEDWi/CFAxv7QpDs7kQLtyAvpYaqHbuLfUH54+++OmhD4Elk7/7Fth8294s3s1
	VFW3t760I1WpRKCJ+2Ew0CshQBmS234=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 242324A482;
	Wed, 22 Oct 2025 11:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5DAC4CEE7;
	Wed, 22 Oct 2025 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761131431;
	bh=giaDzXJ7amEHAt5NKhtODhVh96Dnm7DoUD4EN0sU/+k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=s2x9nB+tMQXedvK2A3nU6LG3ZS3Zwaf9Lhc69LHbXA+sz0XqRD7W4846RILATPcdL
	 c3hd2gGd8XGhz9pEkHOdzPHaE9y1VKHC3hsyj/NKDzCKfYGeHmyHgsViixRFSkWUm0
	 4/1IXFJoFaYn2P4KYwsVZD3tRdhBwmB7xY3ygFeCAtjtSa0zwMojKW9Q+Iz+ti5i7e
	 PHSpqW5McRd/l/pjinSq86xSNDSh2jBCs8INTzgAb+pLYdKfMnwrvQGgmKlGrWQxFe
	 WziF4GRnncev9IXdlEYaov3ZEyGsXh4rEJdtv9JtlYHWierxqAyqU8hVUN3evQPcWr
	 hDn8Ya6YwT4Mg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 4/7] kho: add interfaces to unpreserve folios and page
 ranges
In-Reply-To: <20251022005719.3670224-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 21 Oct 2025 20:57:16 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-5-pasha.tatashin@soleen.com>
Date: Wed, 22 Oct 2025 13:10:27 +0200
Message-ID: <mafs0ecqvfazg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E0754000F
X-Rspamd-Server: rspam03
X-Stat-Signature: qokwnifejuszgoophshrhqsg15d1depx
X-HE-Tag: 1761131431-332221
X-HE-Meta: U2FsdGVkX1/45oBF35Uzlbz5RaBmnDrttsuZJs87me1YxVOlU7qVlmuhUSMEQBVHlmRSdgWNIn62GAHMjKFtNDWkywG4AZ/T5q0Y4LJFdpiil1fKmmriNcd2PDZeqT7qoLp/6Gl81aiF4KuHzdIoUVeHa6HhjbhcERGNj9diYWlj4Vb79h82ejyAuHm0kDFASoHwFLyQuxNiqopic6eio2vT7cm5ugaVi2+NasXfkZ2Pc+x+tESTOWf1bRcdF1R9u2KMuED7P369VoeRAvgqg31DCf8bu/y1/mZ8MPwFcOmPauU+xzuzXZpGqLrZNNq39RQpD0BhahKFRA67ug890rWC2Tdt/t3xpa2vsV+SNMufq6CnLO3Ga8Io7bOTqG9gqKsGQcWUrWjcFTPHRB0KchqCtpMwBrcQwVlNIVEnaF895RECv9KagSI5nq2KudveuwD3WDdfP3p0RV8yS2moZbRdShxSvUIhuvD1229ZemDD4jwZuO0+go9sqbJFKWTXsHxqMz7MtKHPQ1BZoIPPe+M5c5EBpHxe4/EWvL0kl1ZwMj9OauUfD8dB7bgbfG43e4mmQW47mpUQp4FcEoCTIG1C+9zOU+LPGSxXMKjrpTCceCapqZAiIOcnUXdVxRq49YIDw2ScjGxPWCNjMKcBQscQwP/+GERXBREZuqMrRFtqxRbTQiOpkJxJXYDnkyCbmcUIobLlp7zGyX+5wxBjJ3QyiqwtbBYHbuaggYIincOqM93jODAud2dkqd3Ww4e/IHwZ5CzJlBqMNGkzqSIr3uY8R0XVTwJZRDcRer1wpuN2izlndfZSOsR6frD7O1MNu3wkYk+oAl+TtXOqBq+YqQYYqb6SMRitGRX5fj7RVXkva31wRuwrcglonl62PTg5hVDMpFWYAJH1k8wg3vksdG0zovKCgih35h2pxyuaJiHReGmP2zvmGlO5IoX9q3utf3Hgsr2FnCp5Ar5Aywi
 gXS27XFQ
 e94g02uTtJglcOx6BbxhBffx7mwgFVsg+z5s/l8sv0dSiNNdXM5bIk8mHTNZP53tJCr5+tpfjR8XFDgAFfvf/uQn1M8yN3Dh8CA+WmWaP8W/pLzVFsU1L4smalpSOveEMBP5hp4IxIXCo7yigOd9D+i536cvcfxvSgRlGryHkdICHUYgo8wyUi415PLCDLKVs5fY+yu2dUQD1CoFZ2Yaw/RpkV+81dElPck+FLkssy6HC8oI3t1fxyj4wWv6nWJ1vHBUE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21 2025, Pasha Tatashin wrote:

> Allow users of KHO to cancel the previous preservation by adding the
> necessary interfaces to unpreserve folio and pages.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kexec_handover.h | 12 +++++
>  kernel/kexec_handover.c        | 85 ++++++++++++++++++++++++++++------
>  2 files changed, 84 insertions(+), 13 deletions(-)
>
[...]
>  
> +/**
> + * kho_unpreserve_pages - unpreserve contiguous pages.
> + * @page: first page in the list.
> + * @nr_pages: number of pages.
> + *
> + * Instructs KHO to unpreserve @nr_pages contigious  pages starting from @page.

s/contigious/contiguous. Also drop the extra space after it.

> + * This call must exactly match a granularity at which memory was originally
> + * preserved by kho_preserve_pages, call with the same @page and
> + * @nr_pages). Unpreserving arbitrary sub-ranges of larger preserved blocks is

Stray closing parenthesis here. Perhaps a rewording to: "This must be
called with the same @page and @nr_pages as the corresponding
kho_preserve_pages() call. Unpreserving arbitrary..."

Other than this,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> + * not supported.
> + *
> + * Return: 0 on success, error code on failure
> + */
> +int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
> +{
> +	struct kho_mem_track *track = &kho_out.track;
> +	const unsigned long start_pfn = page_to_pfn(page);
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	if (kho_out.finalized)
> +		return -EBUSY;
> +
> +	__kho_unpreserve(track, start_pfn, end_pfn);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
> +
>  struct kho_vmalloc_hdr {
>  	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
>  };

-- 
Regards,
Pratyush Yadav

