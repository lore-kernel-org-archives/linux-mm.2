Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E281CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 04:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20A28E015C; Sun, 26 Oct 2025 00:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9728E0150; Sun, 26 Oct 2025 00:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C986B8E015C; Sun, 26 Oct 2025 00:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3CA28E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:46:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63C67B77F8
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:46:50 +0000 (UTC)
X-FDA: 84039030180.06.C9A11CE
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 987221C000C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:46:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sedpvjBd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761454008; a=rsa-sha256;
	cv=none;
	b=j6b9HYy/FBM+vQ3Hm/z6Lkm/w5hYwTMHX483k1e0FFxTGUne/OohFUZoq4QoHh1nOxoV90
	+1EwXwt2kbl5V2/fieiIzFxccLoOqChBqkpUZQ66WRUk6esitw6QOIzABI55iyDGX0lLTJ
	gVAfrUaDzQ0rhuBtDr0Pnm7lNo8HtK8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sedpvjBd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761454008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jk56zMULVnvV5vOe2VW536n7g9TcNK0rT/QUET2KO6I=;
	b=q7rcvOeb0d7ZTJRvwUxnUE0+q+z0MAyQZYMjzt741aLPGaBM5DzzfMinUQ/xrTiTJxzuyZ
	IWZrdFQ2Y4hPZeM3ztlROZfDf2DFK6XDL8WGnfFVb2ODBHrIRjkJYgn4ValbU3aAMP2e9E
	k8aJ5bQ1LQb+RcF7vrPDS9N5dMf3yDE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-290da96b37fso149015ad.1
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 21:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761454007; x=1762058807; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jk56zMULVnvV5vOe2VW536n7g9TcNK0rT/QUET2KO6I=;
        b=sedpvjBdqpJtfAL/ZU0ndXx1sBbooimCz1Fn6JEfCSUw9GbhHkEozq6YkNOcbTIUZE
         qWfnPI0VM2NkyAWD08gcvI3M0T+XDCy04jes5GVZigL8t0I1SZlJ2mvIl+Vi1bwHMEF2
         3ADVq7+iuwAqX927EJ+8cgRd6/UqZa4xCCA9SmesjkAYthVZ4YUsE2jtWN088uO4DpV4
         a1TJ82CPqTtI87TlJbzrtIO0xWS3wGEeKpqyCJ9R0zXzggyE5SFyYPu5JYMvpT7nhFza
         xU1j+MA2GlJBflKwFPfUvT/dLhT3O7BXUcTz0sU4gZzwXuRPKHthEzs64YtYbHsv6u72
         arWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761454007; x=1762058807;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jk56zMULVnvV5vOe2VW536n7g9TcNK0rT/QUET2KO6I=;
        b=Y3B9R8Vuze8qFz1ocj6Cqs9qAbdkgexjOrEn+SAizZ7ozjBN6MNV1SxTSsZ6dvogSH
         Ir86aegklv4/HdlUhrMnRPfjcf0njx8G8qbz6x518q7x+2yEvK9Sl/JYowTtdZ0N2pxh
         3G7J/XxAUkpMGVLn7LnWnrkEeAFZcZXRHueKs5yDKbC6OokMaJRUstBtXPmZWCliutcK
         jwtltu8thPrk7QYoAuRBZViLJHcEwqV9PKbeu6/lkHv2PqR1//SyWr6YW+2dP+uLFFdH
         FJp5qZatNP+vV0QY3DmI7Pl3MTu0+aAKaaZwQxoR8rSjcSEZW7krMgXSHvDLgZ2fIcg5
         i8eA==
X-Gm-Message-State: AOJu0Yxj6jsVbaW1a+kT5DLuLDcuY00TnyJOVilGGmDr1C3RJocF3qi+
	iRQOd7RhlqlgnQokomrARm+5uU2nKTCI7JXGYBRaEnJ35uVuPb5DTvWDIucZsXFBMBas2723tDQ
	90Pi5Jg0N
X-Gm-Gg: ASbGncsU3V19ZZMUxBRpslsSFyeDJecCHLn1dk4GtCkrTwKv+038XNBlI4O6RMoUui4
	iW+qWsVUQ7zK8Ejvi2NYB/HEY4iDnRGdOxbNfod67tIb4rW/IF5QDrJL5u6JRnn3n50x1m0iYDj
	OILxhO5OxL2IIVXQhvG1/0XlPLOVmdsrC5rsQ6heUQZerIv9h9ODvjQJdCJz6Momx4is+bbsUqB
	tBrNJsU6d8mX9sURBE42HIy4tR3RWr2XJGFWHsOAtBfNml/etmPneAe5yHcvzN0HzEiXJR7oFHE
	ji01HJOyZ/Ik2OdHWC014lSqJXrdmfi5jNBzk6QOfLFvRiGFm34i1mwV9VorhO02BSIxmS2h+Gh
	oMXOW/Aj0JLGAp9dL5LSYnlRA9Zpe5O53RTi1xfUtyVgq9h/qHHRSO5IjArDGLnp79qrxrTmEZz
	vWiefVOMJ43Fk5I7oBRhCG9iqGv53EsRchgm2AVo0FHrqdCVGDPfq64h0GoPxtmar55t/ixUssP
	jn/R8AITz4tfrbpTfYD5dyke7zE5Fg=
X-Google-Smtp-Source: AGHT+IFl64t4lXUYbfcSm4H8ba3t+zSzA5qD8iJDW5UyzavC2m1yzO8TojKTuIllnPQCuYLL/luJeg==
X-Received: by 2002:a17:902:e892:b0:290:c639:1897 with SMTP id d9443c01a7336-29497baa523mr4171425ad.2.1761454006915;
        Sat, 25 Oct 2025 21:46:46 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:2c09:d2bb:f03c:a13c] ([2a00:79e0:2eb0:8:2c09:d2bb:f03c:a13c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf4aa5sm39074375ad.13.2025.10.25.21.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 21:46:45 -0700 (PDT)
Date: Sat, 25 Oct 2025 21:46:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Gregory Price <gourry@gourry.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
    akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
    mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
    David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
In-Reply-To: <20251024192849.2765667-1-gourry@gourry.net>
Message-ID: <6dad209a-5dd5-546e-a8ad-e8b720955e77@google.com>
References: <20251024192849.2765667-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 987221C000C
X-Stat-Signature: obj47ue6ryapdhn4n67p9cw6rfn4imjf
X-HE-Tag: 1761454008-640990
X-HE-Meta: U2FsdGVkX19gPBnO5mDP9bzlSBjCElJaN1TXetKgMn+xuitwgMgqLECnPh2Da/kqXxo0nbqOCVjCT060DaBAM2egzVPZsprCDVdt8plvbdZAs9TZAJMSYQ88UABBTwWRpbIkxbJb+9+I8ssKt0SM+jV5oyZSRkEIGrSwVD5uJhuRqdIrGj6DmJ/syXLttU0dKRGewRAyrFxfiJ0QdpM5zTt4zsiRWIn2ImwC8wr/FZlx8rPBM5CKar9/VhRy59oIUYtuYOV236FEGY7+nmr5nQLI8zA8m4N+SxsEi7d9uDZQssuYZEe2TV/JSyjG1SJd1Soq+cgHuCt2vjqDSVOYsliVem2LsZmLPO6Jj6afq6hvSv4iWy8n8bJhGiF+GdDe2VCZ04gF2lsLomUgdF09ue0h+EkPS7IAYEIo05dF7inoI1XNG7cMLdAEm0U0A0VCwCf+XNH4NuyKGTSazIn4m5r0EpDwlcZe8gOuFdzXzXkCxDAGhnlTvEKh5VHvbgUN6NL380XUHneqBs68zNs+SbMFSBUBsVmmamLsDz0Ewr88oUfzXsTmvDjCtsDq6ymlexTxmk3IaKwfaPeyG/cNk/PhkN09OzsDBtUUOqEMlUKkOWFa/t85RoF6S6MfJd33x2jxdiPlOLgJhX+ksa2ZyWbhejxdmC8JYI7cwe2zunamT7dDV5GetPcCup3NSWP787Z/KUU6FcJ4mof5UTTDv42fV3vQnnYvdLC8rQX6M5MHMRvARBrQeJNe8mI2Fzctu96Pm3g08bifLr2iS5hVbSimIZFcQ+gLrhtPfY1lnXAbqjv2JeK5+VIvfQxJsDI8xt8xaKgmIAtEGWaBWG4XE6t+pnr1uJVdhQfcZuOuXQ4jPOOqACzrNpvcwlkwQGqq8HygjJsG6YkyUlRMKqLDolV9RegnPWfIhA7PYWcnwtyXbL7QykZUA4Ofzqz++pLlzW8hlgUOcj4TiVf+eTn
 peZ0qZyv
 bhvGhffAawKdjr+RDlVewBX53hKhotuCJSrB9lNwKr4cjgtf0kSv+cUWOHjfFEHnQC4PesHTN4CSymOjzG/4hL+msq5cIzOuFVsIRZBo6cfT2RuUixIXkxYn538m0uJksJsZQH1Rg5qkA706c9mN6WBk4X58hzzvST+QBWs2SE9Hfj+ghj0L1eMU+htrsHj4/MwWPfgZS3F5wMziuSVYitUSvjqOAIpW47jTOgemSUJGXZmvd+SvCrL856ATivhrDgrqeqd75ynDgPknhsfHLo7chkHJQ+JZvUAwf586oGDl63iQOYocy7y3vq9Hykys7ipLOfZC7oavUKLazJXYvaVuJ7tns99hKnFdP4xfIXpO3VngSPh+I6Bljh9A1PJMDshfMcOgmiKmoUP2RqE9CjjLpzTBr+byf7mK4Fp1CuuvnTQ2I4ilCcpGngQPdy3HkBR3EZcw8kHcbZEbamdcT/Upz7HORQOTYZWAJXDCISszJy6BHVces0e/ClPgFxCjSplEAwcVHP5/Q+S5domKYOuQJVBDv7bMO1D1Nemd1n1stxKCo81NvGCbb3UMDATOOgKhbEhXvlUbJMbl487Yu4vI2yZBgGUsPUhJA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025, Gregory Price wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.
> 
> isolate_migrate_pages_block() already expects requests with hugepages
> to originate from alloc_contig, and hugetlb code also does a migratable
> check when isolating in folio_isolate_hugetlb().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

