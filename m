Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BB1E6BF1F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFCE6B0005; Fri, 30 Jan 2026 11:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7437A6B0089; Fri, 30 Jan 2026 11:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B526B008A; Fri, 30 Jan 2026 11:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFB66B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:13:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E138B13B01E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:13:09 +0000 (UTC)
X-FDA: 84389124498.17.70DB751
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id CAD634000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:13:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lnBhz4LO;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769789588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QG90dLm8lMXI0BfNfS8WSlG5utZKp+E9ek/YEYpHTH0=;
	b=Ka4bEbJRuQbjr5JDRczKj//G3zuzAvfKSRUgqgxZQhQMsFx+FvF//odaJpRmnU5vnxO+Co
	XvFj2jXzl0Q5kyvnho8B5kGDBFBioCwIQUXlLfUhQf2XL2/yYrPhkbbxLD9YSc2CjebnPn
	hITsA2EH7bPtP0rqBJdwioAy58ssDIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769789588; a=rsa-sha256;
	cv=none;
	b=IBv0OCt2XAYgpOySVOHaM9BKdFyUdHeCK1YARVLphNrq+ckpqz4r8V6sWuVUZJ/jWSm9Fb
	V63ybZD8vciDetxd1HjWp4KLzs3C4CwWWHLwTEOVreD5iJcq3q9sXboC/Z62oHGojIqHFQ
	j2HYVPIfA4WvwtKfbRbwtkulOmuGGA4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lnBhz4LO;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c07bc2ad13so177410785a.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769789587; x=1770394387; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QG90dLm8lMXI0BfNfS8WSlG5utZKp+E9ek/YEYpHTH0=;
        b=lnBhz4LOLlciitLio1dBzBlMGM+tie3vymdjY8++lRelcoVSX/XVnaox1Bs9mg/O8K
         DqwaOp+E3pynnnDP7SarjGdVtK4duB8/vNj239d++VQcT8EYaoo/lQfUkRhw/1JFMqkd
         7RVBR17thIdi6olxPwhPg2HlKGEVM4oXyKSG1PG8IFkQUYZ60yBYmID/n2+eSx/nXu9S
         BNnmzQRBKk94/A3BoL3FOI079GI+OwMEiwZiMsWhEIk1++FIRJDNhz0VAqzDgdJ5yiha
         uafESiZCJ+F+cXLjSDwmBb+qMYsXaLmjIj5T47cJ7Ucq14RjdCGkAfchcdZtWVlpjolL
         6jPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769789587; x=1770394387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QG90dLm8lMXI0BfNfS8WSlG5utZKp+E9ek/YEYpHTH0=;
        b=WJuwE2a0dq6lqw3xgPaLtNa5PKI97HG0VuUM4l4f1iykJmpD9fXhu0fxG6cyaUr30N
         nSU2IEYxh5dYLpIedF3zoer2l0GmcJPMC6iT1CNc3Sp6TIikFx3f+DBzjZj4D4jsY8/Z
         vuhlI/fM4m4Ipb6bTZJVUU9d5m7Fg3DOjEbkfKBnavLE4MH09aehkrtz0WpnZTp6y2d8
         BmlZD2rCjDkskJZMSGhOHdYI5mWE2wUUvSwYt4K8l9AzBurNUz0gjxvcqU72zxbfQqrQ
         ChKuAlsfEKHiGvB2V3GF5ukUZ2mXN8MgpnLaz7OPhMtyImxbib8vKj4ZU2t+HZ76bVPu
         CjoA==
X-Forwarded-Encrypted: i=1; AJvYcCU0dP/LEkBmi5GRVy7uMimf+QW6hbXKnAWV9nrrdM8KhLCB4kemI6oGEUEqUHCyeRI6ZQQWixaY5A==@kvack.org
X-Gm-Message-State: AOJu0YyxPWEA1VT69SBQ45kIIIGv5tIxW18SvA+pOVitbX0ciASiWBR/
	SGz+jQMbia+9EUYYCTXVUpLdyrstvw4PgMJeurIT0K3k9DnOYijzoozsm6f774YrsuQ=
X-Gm-Gg: AZuq6aJ1iLDxHbXMLTPLvs9b1UySBFAxnR6h+0eNG3xTMyHfG6Hz2YMFX/1G3QP8idt
	js5CmaIpQUHURHpigkqY8mDBsNBOdn9pzCTMDkGrpQ5dqwRXVSoTOaEnXSjxFwvjgjmrfb0M05n
	CY8oxyRGS+sFjWTttSYl7kiHFq7HrNsuaoAXqOxuDyNYjoJfAwvgZVKiX/K+o1rcCkv4L7GLVBF
	9gJuNX162OB2Kvx7xsgi1I3IgTSCQOc3EN5d9b/EEkIcc64r7MdUR3ugOsOchX1Gqmfi9p5dXb8
	fSdgU4TopCLS/lZAzaHWYm3sikNz2c7fl08ySo5grFFCeUCsHc3PEts9VtTi8bfrxBvr6x8DyHZ
	ZgNYC7NC1P6OyKb2DTr4Q2Zevv9ew1UXhMyoL7sUU7SZmWLTBlda/OyrmHIGrkBVgyzOKYE7w89
	0gDwKbv9o+MQ==
X-Received: by 2002:a05:620a:4103:b0:8c6:e37f:ec2c with SMTP id af79cd13be357-8c9eb227cf2mr476327685a.1.1769789586691;
        Fri, 30 Jan 2026 08:13:06 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d3740c86sm59598226d6.34.2026.01.30.08.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 08:13:05 -0800 (PST)
Date: Fri, 30 Jan 2026 11:13:05 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>, Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
Message-ID: <aXzYkeJWUvEzp7oU@cmpxchg.org>
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: CAD634000A
X-Stat-Signature: 88x86noph5fcsm4dkmpjtuair4d6ur19
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769789587-385385
X-HE-Meta: U2FsdGVkX1+BnttvsLUvnDtylO5AKdT24IF9Jaaet71Uxg/Y+wED3hlmxSPCdYUC5uTfGh94wADo5BZ6FK31eSl2BhJQQpNf6/xgH9w4hSX0yUU1cq+61l7hhqmVVngjq4fVaT6TbT2V/UIphDbZeotT24wpaxFfXIQFYmCtggdHDKKkGJ+9STWssGKM81ySelaU5PpBzTJMb6WgrbDdsYvQ/y7rpDmAfgE6SZhUfrgZ1jyCbPiqMDXf9/GAMrfGTc6Wy3pMtmWwQoWpSg+erseQgdFrmxVJcAhau4w3Yp/+msZuWGi8AosHdunn47gqikdpjliHBMS7JX3PVHPpiyzmkvbB3MXVDaHyUvFYghZwiKJaENscOkE76ShIgzu1/JaSDV3OLwsLPHfoFTkwhLi4DCvFCeJwkJN82oz7B7Uor062nl43uAfn080R2egj/LrkHd6DqRaMddFjNOsIvoWpInsBVYS+mZNpr+R9JfvEGAYBmZhu00YxDyNUaQF1bScI86CgVoCa0jcSLlc2rpdunAdf/2ChJuT63ztenuChHukMoRV+2rVExFkNM3hB+TNLX2TZhN1dHfDtet7lKKpdeXTCukUmc/1RNAO+0MhrhkGsl1FV9THcr8TKNS7NYEiqsQpQFQN5pY20dW/xKUvDOFCRPjJJQ7o9Xos3YFH8hp6k9TGxfbBFpUckSvdoMYOmrQTSvDELyuLx8pT7vSwBdQLEbp8/iZ5zT3sNYlvlEmYjpX6dQ9q1ujqLlT3fqy0Chk813SMQaK5fFfByJGMpOeZKCTAd5nK+TJgVAk630hq9wzhAwfFhg6hiUHyUMDpL03PgR2OU7V5cqyiu6xx429LGs6LqPkzezdlhfxkXdndCisXcAZa7/2p64WBLyi8FUEpEfVqx6E1LKN8wMjVCPyDqI696LqgJJAfeM0KPLi/JpVAEW16bDcgTOYZX5aFBaXcLy3EtRa0uUhb
 U0of1+jX
 EvNqjEs84YBVcyQRC+tf4VUV3rlHHdlL0gtRpHm4JBgtIX7jPodGHpFo5e6RO60PkPuJcTwaWD0wu0YvD6nwETzvzXEtBa31SRb+1oF81w+pd1BmdNaczoCkK8rFPIxL8zl8BqLKIF0D2KN0IjsJnrKfs4pJRvT+9RMelwwR3u9s7CWlT9/bbZEfJr7ypM0ad50+iUY3RwN9hGhIi96iWjisuhwTiYz7EaSr5owEHKSsnWOUo3rwRLpUBD0MxxCSGA5rpSkowxIXbrFuiDFc3hPUc6blpg9kzhlmTSjlg30rHSVGnxj0irEeTOE6QEFmFM8cUKkEh/NEcRbyWubgPMxIFJm6gMjgV1tBpe9ujaDd5yrYRsCyoG3kJyucffYKusX/QJaLI78NX3TQvB7sXMnahjrOaw4M7EkJfdNmhMxCTOX7IrWqXe+X3gjKQ+Vx4AWGqaJ5B0QGj7GufbXNPuHIvpf07iU71vEFoMyceaTMFLxEc/Da34Wm3Da4m5z5AJG5X/Isqv5p25agDXYYfiobUKzHDryngW9KKeYa9V/B+Y5oKkjWVCK/T9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 08:29:25PM -0800, Shakeel Butt wrote:
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
> 
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
> 
> The assumption breaks in scenarios such as:
> 
> 1. Small folios allocated on one node while the THP gets allocated on a
>    different node.
> 
> 2. A package downloader running in one cgroup populates the page cache,
>    while a job in a different cgroup executes the downloaded binary.
> 
> 3. A file shared between processes in different cgroups, where one
>    process faults in the pages and khugepaged (or madvise(COLLAPSE))
>    collapses them on behalf of the other.
> 
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
> 
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

