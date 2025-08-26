Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9596CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1916B024B; Tue, 26 Aug 2025 12:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079916B024C; Tue, 26 Aug 2025 12:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF87A6B024E; Tue, 26 Aug 2025 12:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF6D76B024B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:37:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB16D117EA3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:37:43 +0000 (UTC)
X-FDA: 83819464806.10.97C28CE
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2F4A14000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:37:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g2MzDW4X;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756226261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyPF/dL+2YqZRv98PVCshXGneATY8Fvhth5O4vhMkWc=;
	b=hmns6j6D8GDbW93+BXyHfLL+fCqPSZSC6yui4ILEMy8ps18HT9jQLez0Q7viNsRmovmahw
	gKRekyKJvp2TnfovCXZS1FYBv3+kqFEf1J/M2jbvtDxxswXdQLx6SlpfwcyCrcsu13PubT
	5AJPFNj9lCeoOo2Uh9f2/niSMJxc4h0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g2MzDW4X;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756226261; a=rsa-sha256;
	cv=none;
	b=IBe3JK58/HTKgXBAcfUk8JOH3hRyeIVIDLEQxtjYPGiIHaUR5MB3XDci2sld4XjmBk88FB
	gRdljwTYeHiImKmwOhUKjHV/6vVHrm6yDz5Kb+c132SDJ2o5vQ22m/bCT28nifYOk8l4Zr
	fhIs+RaupNN/tBNvH8grqLdjLtXk50E=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2445826fd9dso73328745ad.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756226260; x=1756831060; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jyPF/dL+2YqZRv98PVCshXGneATY8Fvhth5O4vhMkWc=;
        b=g2MzDW4XhGJjDbsohg4g7ZWNkoHxQCzmzQZZyQfxLDCMY6xKyT8jJvMtR8qlqplOIw
         QKceHoSb5kNhN2odFkGEB/PMp2X3cvsqDHog4SDRQf1cXVlqjIO76WqyeOKctB2cuCJG
         q6CXgfM9IS1ljUoTnbbVGpxIVOu5t28Nfd18d3OYeXG/4bs/8tXC0FxLaIeNVP8rgm7G
         2FXDwfvZbhdQ750CSIFTXBDeQ11YxUCSh+cNGe3KLVCY7U4h47nugp1kMuEpqtwBT6lK
         Pl9yGG5dASiQbes0yEjKGhTkxSHKvf7EfdTO5/4r1u04H2FfJOJkajpDOetV5G28unD0
         2iUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756226260; x=1756831060;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jyPF/dL+2YqZRv98PVCshXGneATY8Fvhth5O4vhMkWc=;
        b=gtWe+0ks6vGe1rYhd1omIq+FiERigY1gA8kTk57mMUW3Ro7JK3j+EyIYH6hf8dbcOL
         xHp/VX3qSQ4nQ2CH4f5iPOCdAGm4N489xwb8NNziMywhLVFbFmYJonYpk0RMk2ooEFYN
         tZKZ9eAedNcb91xuA4yUsUXeMTZJ01PDcm+F8gvWFTT0jgggW7F7uF2IcOjqkP0Zc6iu
         0CIhzoA51ZpAFUqyaW/KTFZhuSd2Y3HNThmp+a9uTXCRH4UEw0m1PNZEmQUC6ItGFOEN
         8UBI8lgD/u4vG888wsLZ2CraBE3H0zhr531PsEHaKZt7WGTovcjOdJXvibN4ke2O7H/p
         7KtA==
X-Gm-Message-State: AOJu0YxN0PcK6G1er7jIP1VKqWpiqtBmI7wr+/avwI13rmoQnYeztiC8
	rt5W/4daNZQBTgNluctCdudrs6YGuvebEZjZN2uN/n4IZkO98iksyU3i
X-Gm-Gg: ASbGncuWee5VwaD/OB/e/dQWHXBnBtOe9uW3Zpl2uwjrvZ3/p8aOYoiQWKtS47Z65Vr
	2ck3RzK2bSt+HvM6YYou/lx/pC47zJTf8wJBYkfUnX/WdDxNBxqqMkTIQvMxy9OK3ozCJBB5rPq
	Cz/JfLsNxoI8syU+AIPpYc0pKgi5zqIhCVwBSZevKQU0DuAU96k9dBM8eL6ZsN3YqeHYEztFbxW
	Fhl+5eWr/AHBKrpsH3SFNQ7Lca2Tsv59Hooai7a0n8WkjIEbzg+rMgy8oJnh+qY4HSd5fS/0qTN
	IavHOO1nIrfF/xgff5s+eDHfjUNrorxNbJQrGr83ePfN6FFJKde/mSlI5kTY57KFd+DlZUIhhtd
	Q+wGZCua4Q6pQVw==
X-Google-Smtp-Source: AGHT+IHkpBzdMdA7eE7qfwfc1lxqW0m87+LkJnM6/YhAHtUnIYSPMtiSiZLKGMu2nLQJcFkeNv4YGw==
X-Received: by 2002:a17:903:32c8:b0:248:79d4:939b with SMTP id d9443c01a7336-24879d4978cmr26372675ad.54.1756226260428;
        Tue, 26 Aug 2025 09:37:40 -0700 (PDT)
Received: from dw-tp ([171.76.82.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-248681adacdsm21450705ad.10.2025.08.26.09.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 09:37:39 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
In-Reply-To: <20250811112631.759341-7-david@redhat.com>
Date: Tue, 26 Aug 2025 21:58:09 +0530
Message-ID: <87a53mqc86.fsf@gmail.com>
References: <20250811112631.759341-1-david@redhat.com> <20250811112631.759341-7-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 5rhwbmqqt1fewdtcynz3kjr9qganyqr1
X-Rspam-User: 
X-Rspamd-Queue-Id: D2F4A14000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756226261-268004
X-HE-Meta: U2FsdGVkX18ok34YksWfaqkUxR53O10LW+ioVvoRC4XoFQvWnByc3s/wEmyO5m1XGhG3eb/Reu/pruprNCAYGmf45IdW6cq/cvoHvgXrHmxpM3yxceTdCW1KX6y4wqr1vX9tALO+xUhizwiDRLF2UwulR87CsGuV67ERQMNt7CecZJ1W2XQD2I0oSrkuOtTKROO7nHqHwgcvwGUF+wWodkImK87AmTSK725aXVoRLi2xE8p4aHFV1Agkn3ARDwQ67vDyw0eZGvqMqdC2r5qFmPx/WC6Fec7ieW/G0JhnJMJaTvLGLrj0PnHK3UU1gfDhLHLsqABZmj1WFm6QldDB9Vc//dxl/iumZPKN2wWFiY2539iu5/qEEUiNwbLa7WcJ0CjrIR0gNAK42Sk1CFO0oyk0ltMYo66eME33s3HzpzdI9t8T2SCO/vp0VzmjuvaKw6qlC2gFL1exGLNzePlXjNvis+BiDM7DcDP5emfp7f549qmpC8N29bFyut574fKEz9On2gUAqLqzo7Tnd+QGXUftIhdFCTEOcBOKqDBFPyOBj+l9fh/ruftN6Po8lZAXqYl5GX+4uv1Ag2ZmPg+d2wDH1m+Fe+UCbc9xrL/3AQuFgrmWQX1SBlCa8JCbC7fvEfkyiYIfZTiqEiuwQZVbgpDP5FKjOScUixHYxZZQeRfc3FAwKo3u4yoPgGy78At+G+y0L5Sbant45ZRsf07ivJR/OBQC4JtYKKixXMvWJn/Cn0ikiRVP9h5qCY4RIrP6wUuvFNAI75lbqKgdRBV7QN2xJN9dWL9PGC40uEQ/w4SmZljHbnHS77GbghAM+FoXm5116+ZOmY54sAM2iAE8gdN1AK/j4cuLCmjEnyx3hoUguGqZObylhPQsU8alfULQrkolQdAvckSeQ9J350MpM8M96pRby/sHgQCtFLWtV9WA0V++AcET66iSU3tOP0mkww95dP6xlaBr4pX+2r0
 dXFJugSY
 DXf2JTvjDadN0bRm32qqljeO0smc+l474i8LiCGUvh72hTEAvKL6pN1m5WFNd4SNS64wddhLZ5l6NNA/E7DJU9/v1lQaf1J587+9qzpbkz+RPK9OmSf3g6j36KA/97IK5aHe2jI7isoGRbhzUaT2vU4EJUrGGU+xKPMMh0lY7LHfg00WtknFUqhDLbfky9kX1xfIlNy7GQF5RJgaSTx+XhbvSPsDYWt7+csdxyTXewwAqC+D+Zm7X8EwmJU0AVFX1wakBHPhSSekEOE2JTFK46Fjpait0TIg6LUycJx8XVxKPEyf1vv9dtt26DDPUF6CdR45P0hK4bezKtvb5YV3dTcv8mRWHYpykGpjG4Joc4xmCMbwh+2NIsjutWiDYWZeuFp+wlrtOzOs/VnezmeBsoARSnypy40wVLLO/imIE93Axn4SJrCSuQZZ6xG5z+zfi0x47NWgiQtyGO+6Gxtm9wDzdQelGCywxqvCvbpk8XHQWYC/PHzRSV0JjiVhplsWWlD1dUsatiH7MZAUV+DkL0sPxLWs5tjoxECxpkZwHiruQ+oA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> We want to make use of "pgtable_level" for an enum in core-mm. Other
> architectures seem to call "struct pgtable_level" either:
> * "struct pg_level" when not exposed in a header (riscv, arm)
> * "struct ptdump_pg_level" when expose in a header (arm64)
>
> So let's follow what arm64 does.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/mm/ptdump/8xx.c      | 2 +-
>  arch/powerpc/mm/ptdump/book3s64.c | 2 +-
>  arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
>  arch/powerpc/mm/ptdump/shared.c   | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)


As mentioned in commit msg mostly a mechanical change to convert 
"struct pgtable_level" to "struct ptdump_pg_level" for aforementioned purpose.. 

The patch looks ok and compiles fine on my book3s64 and ppc32 platform. 

I think we should fix the subject line.. s/ptdump_pglevel/ptdump_pg_level

Otherwise the changes looks good to me. So please feel free to add - 
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>



>
> diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
> index b5c79b11ea3c2..4ca9cf7a90c9e 100644
> --- a/arch/powerpc/mm/ptdump/8xx.c
> +++ b/arch/powerpc/mm/ptdump/8xx.c
> @@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
> index 5ad92d9dc5d10..6b2da9241d4c4 100644
> --- a/arch/powerpc/mm/ptdump/book3s64.c
> +++ b/arch/powerpc/mm/ptdump/book3s64.c
> @@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
> index 154efae96ae09..4232aa4b57eae 100644
> --- a/arch/powerpc/mm/ptdump/ptdump.h
> +++ b/arch/powerpc/mm/ptdump/ptdump.h
> @@ -11,12 +11,12 @@ struct flag_info {
>  	int		shift;
>  };
>  
> -struct pgtable_level {
> +struct ptdump_pg_level {
>  	const struct flag_info *flag;
>  	size_t num;
>  	u64 mask;
>  };
>  
> -extern struct pgtable_level pg_level[5];
> +extern struct ptdump_pg_level pg_level[5];
>  
>  void pt_dump_size(struct seq_file *m, unsigned long delta);
> diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
> index 39c30c62b7ea7..58998960eb9a4 100644
> --- a/arch/powerpc/mm/ptdump/shared.c
> +++ b/arch/powerpc/mm/ptdump/shared.c
> @@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> -- 
> 2.50.1

