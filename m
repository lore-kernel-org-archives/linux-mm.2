Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0507CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49FF6B0005; Mon, 13 Jul 2026 07:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA2E6B0088; Mon, 13 Jul 2026 07:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC1A6B008A; Mon, 13 Jul 2026 07:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 797376B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:04:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 079DEC811E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:04:49 +0000 (UTC)
X-FDA: 84983470698.09.90C5BAB
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDCF4A000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:04:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jXGqOmKp;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783940687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cojcc5VUT628xzASOMK5s3Jnv6iTJKrLxDZeFtLk3P4=;
	b=x/QBE12CD3TXdv07hYhmoG+NtmR2jY5Pl85/229klZqK/KO3tLKx5/OBCtSETyLeyp8BY9
	053qWe/mQl+jVJwId0SIPhFZXssF/q7zcVYmgYMjD2pTq3ctd8VF9jZvzGwbo4rGahg0LR
	5ye+pY0+4HREJ4J5XEQNUsCxEJfk96w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jXGqOmKp;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783940687;
	b=0jdbEqNM4ytF1LQm1NiHTcaaFZFjUUzAuBuLEeIKkU7ukumpZ1cXw5jtNTwWl83Gxh7cAN
	uNhydwJMG0xqa/8lvbbhHEK9bezEodJAh8Rocm6bFRVZe0YjOidkhA98VlurGYk4UKCDMT
	frJC6nTGGPjLJU/SPd6o8Q5sbr3pBTU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493ec555a26so19609975e9.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783940685; x=1784545485; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cojcc5VUT628xzASOMK5s3Jnv6iTJKrLxDZeFtLk3P4=;
        b=jXGqOmKp72+4Mnc4ob59It3MqNt+XpNFBytSHoxBLHF8HvH+REJ9eo0YefIba7SP6X
         AOdwZBqBYsRWA6H3S3yQRtQ1+Tb1sf+8yyMlIEMshedTyDMafG5feJhVolgOLnSwH94G
         c7NOA0DiZDovNdwwzcdj0vaERB3nrF3ZTtTW+wqRvWdCbZ4F23+sEJik+jg2/rDB3mpE
         yFu3z9GYm4bJznZ6KiheW7Vk2M/uKc9OBzDEETH16yTXP6H2WYWELJ7yw8yls9G+b+9c
         hbV/fibj8rJtfydnX3uCzlca8s6fVME9JK7ZAljlEjQS2VnPh0orL4sgAedZmI6Q17VO
         Q3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783940685; x=1784545485;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cojcc5VUT628xzASOMK5s3Jnv6iTJKrLxDZeFtLk3P4=;
        b=TVGRyhJEsqViJVFgjBshYztZqnmBA4+xjSGEllI0NmaFApqcytH53UNjpyFt+MFMEC
         0m/sEOY5Qc+QE3Oinp+YBxXqWqNFRLyEPANmEFCyjGh9VjSikeqfgaz+MEcwS725Q8k8
         pf/vy8m1m6QY7vN0xXqra86Ab7UssfFqqp3C9MiQKp7BBwtv/hJBOztDCkHcClIryf36
         2AOXT//tg4yNHnF2Ur+H6dpJURj057UseY+wkJKS+W72EGtWqsY16zfNUoT5Equ5PUC5
         CIjsMCdiHMYur66iipsL0V5KD29rPdHNTWX6+aQgEwDLOSTgU4Byk5ZiPT6j9oo2gf64
         q44w==
X-Forwarded-Encrypted: i=1; AHgh+RrHG1Z7Yp9WyKCuPgF7k71N7PbLYUS+qNLz5KD6uF+hSVowD1r3XA3ckIwIle6FygQNwCi7hXaU0A==@kvack.org
X-Gm-Message-State: AOJu0Yy/tmwKGgOy/jCR1SNWgRQhW72yRGfN+kJ7FNo5g8Z52cVx3F9/
	6SQg78XpatQbgZnQWRgC8JjUt3Z6sJ9VXFiVsfcXFpA47RQyXNbAsEnBeAZbJFU0Ibo=
X-Gm-Gg: AfdE7ckTsr6A6ShUNbixmmzuZflhGybS72ehM19cL1TQR734vGa5c9jq96UjZ3UC+wM
	GNDXxz0BAjBH18xk9QOpcIRVVKCNRW1aZi3KHlOzehlwTNT9phYH5lxpEqvwzByhDU0Vwjqkbyo
	kizDdnTlHWkjjwoU0rr1p2Yn663zMz3nn77RDR8opZGSbloS/5SZ6NFwZfkRHrXaNBqKlVkikJI
	N/xDbwc5oWuRsynUVq1AZUkscej8nfBSjpnmZFm5KvyIY9grjUTX7sPvgI7+TfwAom1qMmxeFVc
	oi+WHpPBHZAmPW6MZa3LITeJVw8vWgOkJlNFQp+15wxZqmJVqVXhj5ZdwWs6WhrfCbo7Ln+LZ5m
	gA4+5v4/sK1x9QDgE3ikVTsuH4aJ1y4sbJh3D6RgV/9kBIpUMPfpvKqH+2eaKKaqmV571kgAq1A
	emKnLf/nQVAw==
X-Received: by 2002:a05:600c:8285:b0:492:41c9:886b with SMTP id 5b1f17b1804b1-493f87e5a53mr89975585e9.14.1783940685235;
        Mon, 13 Jul 2026 04:04:45 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d4f9fsm364070595e9.4.2026.07.13.04.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:04:44 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:04:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Petr Tesarik <ptesarik@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] mm: let node_reclaim() return the number of pages
 reclaimed
Message-ID: <20260713110443.GD276793@cmpxchg.org>
References: <20260710152320.2024283-1-ptesarik@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710152320.2024283-1-ptesarik@suse.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDCF4A000E
X-Stat-Signature: pqbgdjb5wc41tknac95apqu5armbcnb9
X-HE-Tag: 1783940686-257592
X-HE-Meta: U2FsdGVkX19CUCWz22M9EGBhs3go2/bh1TIglXM3a6JO7YKzBmR4uD2O1fzV4pF9yEF6uHif1a37+ODzI5hW6WE/4pCDZmY+I7m9qdM+g2XqLcwAd4XI55ItOZz3U2nLHE/qPQlzVG86VB6gSA+w6mvpr4Dz5tGf676Q1A34bZtP/PiFKH6DVzkX4c3X1Xem0jfhdrZsckjoT9QNgCOTPc4VoMz397G+BvavRop8X0hoGeXDGztUIZOt5Uxaj6t/H8Wu0BqPppDWzCgBDVyaG/8TlqQT3U40PcNYSQk6tunt9+lzIDpOHrR+XoISj8tHI/NgS34StmUB9obmoys1yEgcfxP50Prlvtn47855zmNleI2renWRacK5depouko83xfS7hKnIn4tnP2w0fh/Nr3hpcDOWbRBmVVM/p8uDVG8l3aVLrcI8KTa6YAB/Gn1HpSKRuXZ9eZ8YwZsQ4upKU6wa6+QJ44NmRqD4A6ITNw4WX1AqEXWhoH1uds5rWyztQdU3McOr9dkHK1Z0ReSTEhAJ12NOFLdy7yrdxYsYGoh1NanbAHZxFTQc42x7l5sEdgAsDaK6jlp3/68aXa56H0j6j3ygrcDhiFSvKHFY5UnsyIBkLlu6U0eR0rZF7pci4ncxbB/zGm1b2o1oaIURfpfRFlfPp0o3Qr+Bc2nnPhVEf5e4ZoxjScJZIuzq9Y8ubeMQiIS9uKHtpGDsgbjgpt+L+hgOo5tJzePC/nyvHT0m6X7Y37Nf3GsPVxlcazVwxC4ik1L6+BAtDs9ddYtfXzlFBg0/lmWBGWiSFV0CLhNemsunLCC41nHmScbDyEAn/Zh9yUWrGjcvB32dDltBj3aqIG47lllweRpHwdyOpU59opSAqbxjwbhV1t7DD5fp1OcPyRKuLpQuaQ294mVBF7hpknINtngHsrr84FwsOb894rkFTXrrpG+PNxQneqcLt8DifF2t3Aur6NlcwJ
 7YTk3BrO
 TJC2etiW2USG4cDtei4UBiAOAR7FJGUxrdneBswJPUe9tLW40237/yI617nMEqh5IAvNZ64Lt5A2KfgRELlJ/Hs/pEWwXEXW4FVCltmhxNR/TDp8Sv2FMKqg7yEEq4KAC22y4+HJHgpkvMKTR9dBc2FXKqqeANG63nk4cRapbdN7vBRs4sK5GR8pCPhIbyTJ5To+XeFZniwhK19lMWPPN1C9eBPqXVKHy2hzMpysNJ0WBDdBwFqJ8FIEndoARKWQXZsrnQJpwYkxp0foJnq/iwtm/v8LXyyszf4Gxnqq7PJvwyGJcUOOF1jK/t5yyVxZ7DV2t+OCBMGcGQIQcxuOjKTL2dyddGTCm8UhT1duyV81iaTzqzaYOvK95px8vYDFD2pfnTF5b0CwIJ3P9yozj/Dt+G7+I6BRmSE1/KS3/q8MbPa0q0vphNv+BEZEBoAHhMVukJuUOUCurcXn/0jZKwUW2lwqDe8DGKHPvICfu9UJcfWvQutY+iT1a9PfKPSlWSZXPLG6SxIiedvKqdQ89B/EJrf+c1RaHQT6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 05:23:20PM +0200, Petr Tesarik wrote:
> There is only one caller, get_page_from_freelist(), and it does not make
> any use of the reason for skipping the reclaim, nor does it make any
> distinction between a full and partially successful reclaim.
> 
> Therefore, node_reclaim() can simply return the number of pages that have
> been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
> can be removed.
> 
> There is one small change of behavior when __node_reclaim() was attempted
> but returned zero. The allocation now skips the zone immediately; before
> this patch, the zone watermarks were checked first. I believe it was an
> oversight rather than intention, because the chances that zone watermark is
> OK after __node_reclaim() did not reclaim any pages are very close to zero.
> 
> Originally, I was looking for occurences of NODE_RECLAIM_SOME and
> NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because they are
> typecast from the result of a relational operator. This seemed a bit
> fragile, so I dug a bit deeper and came up with this proposed cleanup.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.com>

Looks good to me, and agree with the minor change in behavior being
acceptable. With the macros actually removed,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

