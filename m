Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B03CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 01:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19B68E0009; Mon, 20 Oct 2025 21:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1268E0002; Mon, 20 Oct 2025 21:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B065E8E0009; Mon, 20 Oct 2025 21:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0E58E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:25:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4121DFF0A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:25:38 +0000 (UTC)
X-FDA: 84020379156.01.3F83CD3
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 527611C0012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:25:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fW9pQIaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761009936;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BG7SoKS9/O/tcXiBlLtu/WD3ge13Fh8Ow5gh6NGHAQE=;
	b=nl2bjTpTOTewB5UhTv75hP+dGsEQNWud76qksaZm6ig1Zs4mP+Rpugffc2lcvislP4YeZ3
	xJtN58skguwiqcXRs/Wf7I25nbLpTUaD+xN1YNQh3EpsQty5cs4T/OnfApBRNkBGUfXaWW
	qrpdioZW3I7qznRXY4JSCbJzLNGWgQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fW9pQIaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761009936; a=rsa-sha256;
	cv=none;
	b=Am7RS4IfrucaDJExBWHkWaB9u9tdwvGxbd0Fdrurl3CQq8pCL1gBVv5K3atYf8SX+FQZ5Y
	ShDyA/zNlnsA6oRr9uh85/bGolMj4fhNn7i6NVTXF+voyufAIZpuqGxCHHvAIUY7aKVGf/
	uOiEGuj5bArWYIGrwl6HOHDVxbOjfoQ=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fca01f0d9so10212692a12.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761009935; x=1761614735; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG7SoKS9/O/tcXiBlLtu/WD3ge13Fh8Ow5gh6NGHAQE=;
        b=fW9pQIaFxkn/g5LhQCJs7T+bT/eNN5V5ZWSJMWWn6/J+alWzMWLEpuwkcWibRdmcMT
         lNwsjiWFTr9zc4ebtkjb4G0eHKaI3FOYtvdqPV1/m/cmNDgK7BzOesEwOk55dN9lGhZF
         XGob1pNbdMoiOF9S+YUMB1LmKLusk3rM2vgRiscqQ7ZWFkD3aOU8EHaooZQg+eHLiQtg
         yHxAMxZrd96QN/Fi/Ai/SPgOaW7KbnFrY7W6O/1a8IR6W3tOdibByTiU3YzCZrcccdYV
         TESV/chK/tJrzt7x5iiPC/iQ80q/Ygi6zIlnQcOZgGyuVwJ4oHtiLCqYcAyjQaqKA+Ht
         WR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761009935; x=1761614735;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BG7SoKS9/O/tcXiBlLtu/WD3ge13Fh8Ow5gh6NGHAQE=;
        b=ndd2GG8Zioo6Codwm90G1zYoYO6euH6YWLaMQc7g9fhAOzKSoOvONYY2KbQa4SGNEd
         F+0byv6NU+7Cu1UT94OmuuJ5CGHp7NURPgK/bk7+wZW4hGl03osNsDHyjHMkpLK2ZXDh
         TvSirrerQeXNSJApJIcbZYOnLshZf2XjDFOYisuVa8n8TQ8xPcSk1qltH6hWUjVQfjWG
         HHDC0neUe36JWOhymvjd1ViyfEcTPbByNN/un8BuGxB27ftWqmZjZTO+02O4DXjuwiIm
         RBRUAXdDdACB6p4+JvNl7eRgMRscZHikDjaIF1JdmY2DdSRWzzUZxg9rW61JGqHs+TB3
         cobA==
X-Gm-Message-State: AOJu0YzBGpLxBomvO/DYrDE8r2eaQYzazNf6RzP0P74wVkn9glKIAjqn
	s+S441rzNO/InZv57Xojd50hPro88cr+Cu4ogdTjnOIVHHVDjlsTQyNH
X-Gm-Gg: ASbGnctxRxizv6zWp3KLFXq0+mX3lkApI8HGIBHwruU4DM3LoH7APjDDI4hjIvj/Rui
	P6PBwJOK9bxC/aljSGexnuo8IvuTPNBS/dwwGgjbRvkYwpV2HoVhLmIUfkK9ETtlwyKKnE81kvt
	HKgXN0Kw+hqoqPYjy0Wq7ohnHzTqKydSgZjnwQLTk673zo5S5yCcj6m2RXZW8MR6hbz3b4IlPpB
	tUUfH+OR3POtkP3z6JH4KNyL3wNRdX2Yt78rfNNkiL1Pt731thgEA1enxfhfflz4lOsIz3cTZU6
	VeFaUNCcvixLYyRmeK1Mhn1XkPhZSB3UCCEGIRkuCp+rSrixG1vJg/CahvG4mu+PcZjt6Q46feV
	4E1m2GBTonV4ULZeQqI+2zC/FEiglvMw2JS7SWruhuMmgRXTcvOn5FEAx1mXRzuKnYZXQF3Ok1E
	o=
X-Google-Smtp-Source: AGHT+IFM31KPAYyRjDfoD/9D5Nx9v+qFBF8RhgeZUBp3l5o6040IQ9FM7n7kjf4PJLadaE5pzBK6Mg==
X-Received: by 2002:a17:906:fe09:b0:b47:de64:df1b with SMTP id a640c23a62f3a-b6473b5263fmr1916166166b.39.1761009934387;
        Mon, 20 Oct 2025 18:25:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e83958fbsm941504666b.27.2025.10.20.18.25.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Oct 2025 18:25:33 -0700 (PDT)
Date: Tue, 21 Oct 2025 01:25:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <20251021012533.56rdl6v76plkw4nl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251020210816.1089910-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020210816.1089910-1-gourry@gourry.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 527611C0012
X-Rspamd-Server: rspam03
X-Stat-Signature: u17pymgoznq6ohsy7oshuyh733prfem5
X-HE-Tag: 1761009936-430858
X-HE-Meta: U2FsdGVkX18nN2J0GBvNwZV0k5uiTZOzUWFiV50LyKkKvV1SbRuBSTjYy8jdmbF43TVb2+hXLDWQW/+al5rjOw0rC4gFP2CAqQg9Ux05Ba/ofChxaEG0a4OrjbhGXM3DtijRZm2akP1d/omwQiJKKu0pJrPXridycT+1dfZDIcI83hW0C1XRNkQyaWunGpzxUDBs6gWOgYEAfBaESIE8z40r64JS4l2/eGLT0WfGK/FMyrjW1bxmHymSMGJ5Csk0+Y0H28ZbYmSOE9l0eM0ql7z8D9t7znIzgbUv2FCWsNJdb7YDVeXLYYp9XrN+BTxmnhbwic8ksbBmUMMCMJ22Lvarqs0Y36Suy/iXUOQ/k94Jj4Rw4ZzuWQUQsiUzm3epiGyNAMKB9Ho0JKIwwvG8aVddBIajRakB6A2anIDWVILp6hB/IfewbTVarCzsNGOQLYLAVAuMg9dThBAz/kcKURNfrlNaQd/IbIYnsO/eWEqZheR1p2IOjg81MMeSLvG/0NwmHFlRs5FL40PPs3sE4zxw30An5vEIbCMzJ1c/zjiUdPww4UIHpC7w1Q7c7cqe3RdxKScbZMuWCI61fCIxOcxnwyr4X1SL4kmu3DRYE09mlBb31Z+Ad5txBO+aUYCDxzblitZc+QxYAb/Jbc4qf/eq28u93E8H8mSJV0Wp9YC5hxgL8XITuq4Ost9Che/1cEMklMjCRWABM/feoqr1+jY5uphroTpYIzWpCOX9+DoJs0bimZMwwBhR10vEMsTttVMzodWSVaIxU1VzwuPZcRBg0pFz4+RxJsAiDSSq0ie+Jlm7bT1A9+Mm8XNGAiA2to2h6X5rW3gMoagy3jworcolcB9QYH0SQFTS8+OKO3DUMlYiVC+NQhbpNZ5j8ZZq+8tYtM/ozHZVLqX6fXC7ASfZh9nZk3Ay5SA2DnfVpgWVQN3ewvHAiOb2ralRI5dI2+U9s96haaRdCx36g0y
 l+2nxZJU
 enph7WtRkXm96/6iq2EHJfDYhPlQL7RBqnPPchwk0/YyVGv7lyv+Bcf3jhVUAW3ZFxTStxPcFuCZX9TKkOBlP+xFH4jGBFbO22fWXusBnhcad/8qle8HpF5YGmYaKEaCGLczEbnYbOkyNoGNu1iTPdDzDId7EOVINUNyq2sh/CyMIUymQtmf7/2jlQkPnTMPsybEKGojoXgIgNOWJQU3x2ku9JfrXWW/TOoHyNbwoUImdRwaMS54oyCCt+VWiiyvgpzmxs1SqlhfHlAQMRuj21AFPVy3vWepc6QPQB67FH7xt95daYQZboFc2neOLFuDtoRDnI9W4wwma7+B8pALJ8VQe7EjVhduXbI286Y6B90RZOXxwO6E476zYHnbrXjV07LxY/0nJ49Ikx1+kPshsvPJih1+ZDasiWWybb5r0Tfq8rSguCZqoYQQavN0v+V3U8cHPRDo9m7DV8WUCqUk5nFWPOMmdnaHFmiTMYrq8m1EfAxR/gLOqUuKkEcjvFibbTNdK4hxiZG++z9dakLKxkyCOjiuw/2jp8ABYGgdznZJS6TFlqH6rKGdj84wsiQUp5XM9Ky+VCKbibVPKa3F55WY9Si0bC9wdxbqHBUtR8dNQ5aXSJTn0EL7Gr/lDwT//89dq+nwlQIbc3vhnTQDsavgt2KsDOCDmzipfBUHluTLUDn/fNLusi9F17YvzCNtcPXRj1iLV+E8TfslZvXKyP1C4ZHTJnXhZP1igaSCfsxIWjkdXCDG14534YklNHNdhEao0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:08:16PM -0400, Gregory Price wrote:
>We presently skip regions with hugepages entirely when trying to do
>contiguous page allocation.  Instead, if hugepage migration is enabled,
>consider regions with hugepages smaller than the requested allocation.
>
>Compaction `isolate_migrate_pages_block()` already expects requests

isolate_migratepages_block() ?

>with hugepages to originate from alloc_contig, and hugetlb code also
>does a migratable check when isolating in `folio_isolate_hugetlb()`.
>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Gregory Price <gourry@gourry.net>
>---
> mm/page_alloc.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>index 600d9e981c23..da2e65bf63e3 100644
>--- a/mm/page_alloc.c
>+++ b/mm/page_alloc.c
>@@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
> 		if (PageReserved(page))
> 			return false;
> 
>-		if (PageHuge(page))
>-			return false;
>+		if (PageHuge(page)) {
>+			unsigned int order;
>+
>+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>+				return false;
>+
>+			/* Don't consider moving same size/larger pages */
>+			page = compound_head(page);
>+			order = compound_order(page);

How about using folio_large_order(page_folio(page)) ?

>+			if ((order >= MAX_PAGE_ORDER) ||
>+			    (nr_pages < (1 << order)))
>+				return false;
>+		}
> 	}
> 	return true;
> }
>-- 
>2.51.0
>

Generally LGTM

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

