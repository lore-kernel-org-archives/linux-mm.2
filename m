Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6491BF4BB77
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70776B0089; Tue, 24 Feb 2026 14:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51D56B008A; Tue, 24 Feb 2026 14:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67716B008C; Tue, 24 Feb 2026 14:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2D936B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:03:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C3D51C1F3
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:03:20 +0000 (UTC)
X-FDA: 84480273360.06.D1DAB9C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2489B40003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:03:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WWTp0uid;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771959798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dVBeJ+Qt9DB0d6jjabtcjm7Ck09D2CLqlPHoylpiSI=;
	b=IQnzkU7nZmAdkQQFLCUW+UIMrmY4ExOc1a0fDFTN6r1VcT8SoR61gA3Tlg1x/bRm57ljvx
	QKaJ19Mop+iVb0lVql77xnAzxR+x8oIsR2yeH+DVXVAczw1N7SIAJHqCX/MxeLKx4MBfoL
	qpocoPnb547nywQDj+ppeoi7hLauFPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771959798; a=rsa-sha256;
	cv=none;
	b=5mYA+XkP0R3G6PBjx3mNJWiMLMhealWMdy7AkrTJsGmQWVcPLr9sNgmltb7v3f30RVOMic
	xjVQJjlgUdWfC3RxIXkkL0kbao6CfIZ+m0gLwCZImDsG1KSFKjiUiEwAYklDXbsyxXGex+
	RXn+BVAGajeXVC2IeAMgXLl6GxD/rDs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WWTp0uid;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5069df1d711so54307191cf.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771959797; x=1772564597; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7dVBeJ+Qt9DB0d6jjabtcjm7Ck09D2CLqlPHoylpiSI=;
        b=WWTp0uid2S458sC1KkW2uCPKvFldOyOC4hwmAEiZbVvEkHUMCioUISWPZCYjfFJUum
         t2SBA5VsWW4ziS9te25zXnuwxq1zjOpFOfB7C8NCUW2GwozYvbNtuQHiAyGSJtz+YTSL
         PwH5wYWBE+V7gjyXLfzhRXcf0AzXIl8bFr9hoCCmvJDjcnFQZgwW39cC7/w1Pok3BM+P
         /qGKFM9lNJTD4UChuVWqekJS1Ez4gbtozeq15tesqNxqq0QH1lgJKSzR+ISKhe1Wv0K+
         xumIAa74awcRnvk5qmb23KcoYbpJtqamTYWkoaprP7p8v9XoTxQFC9ZSyYoCEREGoSCq
         B9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959797; x=1772564597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dVBeJ+Qt9DB0d6jjabtcjm7Ck09D2CLqlPHoylpiSI=;
        b=FR1rUKYl1df+iMg28rT5oEuKaOVjHIEfYZs6W9o5O3FABlpWUU8Oj1Ni7KuyoPqfzK
         QxuvXvUT3TdDDBnlKhrWQUxuqY//6i4f+JYDeNw2Z7OWCqrXuHj/zPot09TpZFPl1Hkb
         ce4GRC4GsyKj7pBXxKtiV5ooPVUkkkUk7TrS4DZkZvyt/rZlHWrEdPnk/6rI3hW+RNDX
         ak2/YnwK+qqjKvC1DXAxYcz+vNCDLwrd/S/T727jiGF3OjyLaT8OpVKWXOMLvESSQUO2
         ZzpPOgEWDlZyBEiuQE+k7hM8drb4hi6NT2AgmQMDUBA6xAcBp3a1DRp7e5vrqGEJo8AF
         flsg==
X-Forwarded-Encrypted: i=1; AJvYcCVtgg/zNpBUmqqXVPnT4I88LYIwPzRv2l7kDgX1HN9JY2Myctq+0S0SAoAh0ymqBExj3iG4VBUflw==@kvack.org
X-Gm-Message-State: AOJu0Yz7LQjjFEzflpYBvlndwnuk8B1gMAAPtr0Z5KwUKfzhZfhPmbKP
	jaFF7vQvRjl9yPFbDna+Uyw3XeR3ViLwFiA3+VtH7cRpi4ANIRfd9n+v9GMldtLnPzk=
X-Gm-Gg: AZuq6aKO4yzstWMx3LsrHqVpN3KccxkYdkrSsZdGISxd/PwsYzH62C6DtEdejhZh+jg
	RZlLNDYa0YGD2wOcpWHk1VJ3ZWyUJifMvrLGI/XzIK5o4vxPggbugGYaH/erbqLwL4YRWw7VI44
	bFRwQNhEEo3lkmGC7Jfhx7d6/sbncjLmpvFR+PBkpwqsUAGFpdSUsvSw8giOV97LG0UC+Z7QEY6
	PyCibb2ON9+XLTDrPcYkBDzZJVDg+ectl0oK6VdLpeORVYC4UVua4x1p2pgSqlLlxdKRSWWZ57T
	vc3bPngkA4MGuIfahyCIAakW8NIwnlT2DkzBoktVmMwjVuPXDJ6Th8XauGu3hLjqT8OLcHuiE54
	QqOozFpbPPIsEJh/cjX2MY6KKYPqw3D7v2tH3fydHJ0deAMdNW2AFgAMsrAeMzp5kTUaG2KqTv+
	nKZn3WZg5HBj43dhYpjxbtTQ==
X-Received: by 2002:ac8:7f82:0:b0:4ed:b06b:d67d with SMTP id d75a77b69052e-5070bc4c219mr182745301cf.45.1771959796861;
        Tue, 24 Feb 2026 11:03:16 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6a1ddasm104697141cf.21.2026.02.24.11.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:03:16 -0800 (PST)
Date: Tue, 24 Feb 2026 14:03:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	lsf-pc@lists.linux-foundation.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"riel@surriel.com" <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Message-ID: <aZ318PoxdAZjqnLX@cmpxchg.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
X-Rspamd-Server: rspam09
X-Stat-Signature: 89bp4ym14gmyqy4wjte7ryd5xip9acxj
X-Rspamd-Queue-Id: 2489B40003
X-Rspam-User: 
X-HE-Tag: 1771959797-755729
X-HE-Meta: U2FsdGVkX18PFC04+RGn+ySKgwUUCygnuo1KQVrbH/Kwfky+N8Qx1sOsIflGCwupEAF4294EmF7WSwPjXoHig7UaErSAEuRdi8hf4AbUVm2SbqqgLAJjdx3ot65x1pZc9QaflcYm9bWyOSXWjFbwSEf/Auo9mKotPH+kOFZCOW/uXgiqRnMu51h/ACFUqK2uEvPjnIhoBUVhMjOL/m23/lyLHDNE5Y4herkn7JK6XIA66e1svgBURD3BN8GDRJha2v0fpX+6wfQtSGD7m+ClLtW8ZmMeEwuPbcLgNgOsb31vV1XS4kP72+892372hvO7ZFoqVQu+WJxDsHUAflardTDvk4cD0WgHYgD0iWvitGHHrJq3+0Aupa72Jqqt4D6GtJoeSJohy/H5DkD2EUxAu5R09JUvyOwxlgbwAicAWOH3NBchopIZft8eQijQ17BstiCl8cwlTewfhi6ykCmivMqgiNKr0L7uYIXdcnVB59OeSsXLOacyZdxWlPQQqm7a6l9tVIC9NOe0cXuShFZQFuuLqcSCpgzAE4HEwy1uZBwDvd06T9lL/+WbYc/69+HWbEsFO5oQziKtz0/mvyicKkxbrrIrTbguc4MG+KxaJlp7pT1jCF9mEjdBdgIb6lwOAfrMAw9agfoSKRiw+Q3PYYAZg6rsTkc+bIQw7AyN2jW2QbqijZ5Dv4cqmX59Ce3eAJ+JulGJnmGNH+aeRCbLxaC3dqcm582rVCrfsr/i7btb8tE7btgfXPW49bx8gWvd76AWOcdAJnxoiXQIdeNqpum/JvUlScI6UN2wMknefXfk6Wmlbph+zgwUEjVvVZsLFDFR9Vuy35lobCEf30yUs839qwib1twGGwGN5/s0c4P5k0kgsAkyhXigESnEFZaVZevYTu1eiW0iqC3t72uGfWJk5ullXjQTKSMja/0p+3zcTASCZG1IfMgxQvrp52CsYyxZo7XWrMsa50slyrP
 Il4zJ+Jh
 XUvXINKgzB+54Rbl7SfiIvQ/ngAgZxZGS5eMoOskqDgUOLJp31FVQJOZS51/G6H5xcPFf3TVZxSXI21WQtcJ7Rj0zZnEhnyIVO+uHVbiVve5drpqjzhM+va3Ri7Dzx1nnfvTLeg0AXu1z/Grc5TJNS6U9zn3Lk/roY6M2KRGvMHWRjmAKgt9ZOyAhecd1vVviEKQZrolwvr4ALDpkdpayMF2ztk4zu+KCyqBG5W6j4NMBiqa+aBDDQUwO90dNZ0fUc3juTNd5y+Ehf6vwEWA3nHuCkSNoE02qdGVCXGAl+NFhgTi5jHL+EQdZAGYzZ9VLeHG4VPoSZGS454Tze9FTKtBSevJA1O9d3rgLtLnpSJL065zmOSF4wi4+9/BABJU6K4w8Y1R4VLP7ABI7l2ZaytQISZCUOkLuUQaj0IkUdhixp6SF5EVWcCjs3Me6syqi1YS2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:53:35PM +0000, Usama Arif wrote:
> Why 1G THP over hugetlbfs?
> ==========================

I know this isn't your intention, but one interesting aspect of
supporting PUD mapped folios natively is that it could open the door
to simplifying hugetlb as well.

We currently have all kinds of huge_vma checks scattered over the page
table code, and entirely parallel paths for unmapping etc. With native
PUD mappings, this could allow pushing the special casing out of the
virtual memory layer and into where we deal with the page objects.

You might be able to take it as far as the only thing left of hugetlb
is the reservation pool. Such that a naive application does mmap() as
per usual, and it comes down to a separate allocation policy how the
backing pages are served (buddy, CMA, boot-time reservations, ...)

Approaching it this way could help separate out the discussion on code
impact and tech debt of PUD mappings, from the allocation technique
question, which in itself is a fairly large topic.

