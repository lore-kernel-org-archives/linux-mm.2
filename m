Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8A2FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23516B008A; Tue,  5 May 2026 06:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4136B0092; Tue,  5 May 2026 06:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11376B0093; Tue,  5 May 2026 06:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A09C06B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:56:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A8F61C02F3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:56:07 +0000 (UTC)
X-FDA: 84733061574.24.8353E88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8384D40004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:56:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfqBiB5L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777978565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1OddjJBAXRXU7+BPsNN2Tu2s2DE12gQ7FWskjGftbQ=;
	b=BiySgx+ov9Nl3gaTAu07xddbgVyjIvvCKn8W/Uq32kefD4EyvnTZf7GdkXXDNJfhmty7Dk
	byuGN3DfyetsVPXFDCslYZNSHL+6tKkykjbiyDRYuZayQoK2HATzBKMBZjh0LhvQLKYgW2
	5IsqW4ti00JTqwj+ACj3ti+J9sgJ6b4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777978565; a=rsa-sha256;
	cv=none;
	b=xFAoHg9oIxPZnqxRaxyubHqjxrv1IOin+MA7JTzn4JVKz+yreTq0M3DmjHFCgyV3CATlfl
	lAAfPCLp9SDAuVp5Qnm2i3PVwi1sCf/DsLdqRuJcEju5g0wG7mkoyZhEwo2ORCKzfpQmnv
	LhUytnKBZRL/kQSgsJj3h5v/zE2SkEg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfqBiB5L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DC644146;
	Tue,  5 May 2026 10:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0AEC2BCC9;
	Tue,  5 May 2026 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777978564;
	bh=G5Z7C/0UebdmXXcgO3B3zWB2JQ5mQrNcwE5DxEYbTIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UfqBiB5LvvHkUzuox+lmYN2WbX+v80Lgqg0evNco/LAKeWqHc1Ek2eIyBO9sTyPYv
	 mHfE7DkPAB0UuvHm6mgWJ4P3+BMq/u+GSYajU7BIHiHg+leIYVCp3PxlmCbrRc0Grw
	 azC2sMo/mmlwfsg3iVbwpuOBOLP44gWmFnfT1qLeUj2+gmL7uIGNrjf6RWMQFOt9VF
	 k5D5XNAx3TxhxgdxxvI2NWhHrvvif3or7khY8rSEUIXYs7MeCGSGgXcuP5jhTUT7Un
	 Om6n2GTKAcVIGVzTLdD0OCnsA0xYCHuPqjQnQ6uC+58ISUTTZelS3k2ne/nraNixrb
	 ABGlLOnWYNSZw==
Date: Tue, 5 May 2026 11:56:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Message-ID: <afnMoCtnLA4CTqR2@lucifer>
References: <20260422123726.517220-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422123726.517220-1-pfalcato@suse.de>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8384D40004
X-Stat-Signature: p8mfgkphzjsx7dsfrzdd4ym53g44hb5o
X-Rspam-User: 
X-HE-Tag: 1777978565-817509
X-HE-Meta: U2FsdGVkX19lW8JAQVy0iwqd2n0fgcUOfCPTcp9hdxr2I2Q//+rY8swqSHOj8cafx/J3CgAbbeFxfy6M45KD5YMqWcGbWCx9Mi2rW5pGyCxHOf0Y9en7Zt90j27KM+/XA9azsIys84Vq/+2YWI81b1vQ4LKwvkMNectBDc6oPPXDBVTUwnluah6Qk3OAteVJBV+BHiv3rER9um6xIp2/i0YRcYwH+Yz0ZTwTmmRhjCMLPHuCH90Yg8n1l1Pvj2+1vPQJDu48q31AfopGsGthnp+W33hj9tnXE17WdmkHLLyAoJ/24yso3sDWJkjSs/ahLMPL03l7C4UoNP4LXypXLzAjesChd2FooAcp+C4mACxqQO8wSC1VHvCUnpHatD6QTk4MTV0We9Ogt35vF8CqHfhknuYkD9uw/c1Gnh2/CKqnnfyFbz1kuPrvomq45MpdBuAu5eZBqlTFrVh1c/Ir4gDlr9PvOsYC5K0qgJH/YpZoVQCiNDocEbazAkv84zjx8ZwZNA9/cs7sgCsTrSjIybCLmF67FyQA9rOHtVI1o1ESoGa/dZNQzGPNHTLOK8HRWuqBOyyIuH8lE4tUEfOqbhWKG1aiCsgSsZ4moNC8+cTfCKsTrVYZHqBr1HXBd4ksIl6aqg1gmX3tHnBlFt3NRCA0tMAkaLdht2IsW8+2VJkxXKpt14DFwetbVKiKlYJx1qVSz93vvEg18X5mpNf2RngWMp9bnE4PS8G/rMAajPrkWHDL8dSDe6DIXFB4gxGnRt0ipkjmfCBocU56gKAi6y8Cb7pjglNZtfEmQxOBVRqeUKMBsMaqzhO70N6nKNC/IZpCijMkHhPK0R2O4a/MOC86chjOccYJjD8ODQnNdqBSve0F6o4cMreJdW+zDW/EBRXKK9A9kQ27OaVtu65vEAN1DyeQ8S1W3QiHcNT4n3jGRfdumkxws22RoYYc+fYJB/gwZeoBPNr7OBclhpe
 LCx+Oz7h
 us3p0nJRT7wOF1reHw+QP7VwAk/jbz0j2vbI1flisDB2WkSIOXtUSXMzcp/7NwY2s5eP2QDZvcMZZV50elZPrGSpb83wBLDzWOlIxgMXdAN8LsV8kuuRVJ21qq5gz9JgPS1trhsEXsvL7vYJWH2qUkEl4wPG3sKFC5HX10Kr8F69sP677Voc8bzIfuwT7Fu4xiPxLqNWYTuu6bcB2oIlz3VmL1wBLR38A0Mdq27+qOFnXIcIZHJrlS05oeH8pGR/ttAik7R+m+NN21cRsSgR38CgGIAPHKqofwNpvvG+2BV2tkwCgRM1XQDlUOOc5URj+MIZOMURLjQIQgyztdSFOrsImXerZNX4vSJMtszRGRBiuNag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:37:26PM +0100, Pedro Falcato wrote:
> The pattern "include/linux/page[-_]*" matches every file that starts with
> "page", because it's a regex and not a glob (so it has the meaning of
> include/linux/page + match [-_] 0+ times).
>
> Fix it up into a more regex-correct expression. Doing so reduces CC's
> drastically in patches that touch pagemap.h (which is maintained as part of
> PAGE CACHE).
>
> As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> ALLOCATOR.
>
> Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

If I didn't already say,

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

:)

Cheers, Lorenzo

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d25342ca8aa1..224c15299acc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16804,7 +16804,7 @@ F:	mm/sparse.c
>  F:	mm/util.c
>  F:	mm/vmpressure.c
>  F:	mm/vmstat.c
> -N:	include/linux/page[-_]*
> +N:	include\/linux\/page[-_][a-zA-Z]*
>
>  MEMORY MANAGEMENT - EXECMEM
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -16961,6 +16961,7 @@ S:	Maintained
>  F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
> +F:	include/linux/pageblock-flags.h
>  F:	mm/compaction.c
>  F:	mm/debug_page_alloc.c
>  F:	mm/debug_page_ref.c
> --
> 2.53.0
>

