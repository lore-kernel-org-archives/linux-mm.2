Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64BFCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287E36B0100; Fri,  8 May 2026 02:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238E26B0102; Fri,  8 May 2026 02:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14EB06B0103; Fri,  8 May 2026 02:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0053D6B0100
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:11:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8067FA072C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:11:10 +0000 (UTC)
X-FDA: 84743229900.24.46F1301
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 65B9B1A0008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:11:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYUBTcTl;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMw78U+KcjIbysPwtZ/7htqjqMyNXQOiwSpYBpxoKM0=;
	b=4kiBPJN+JaPEvSlb3ZKISy51HSKGtuatAy9jBQoMYz4cxML9tzwyCpr6ylNfxt9mpU/djy
	bFoLUxiC9LPhegR9uIctA0HmEM1njZ5PAz4jIVnIcmedQfULyjwsU+N4wDQ91UCQeoiHn5
	YnO7vjJQGeG/3mzi25xyMk11iQlUnBM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYUBTcTl;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220668; a=rsa-sha256;
	cv=none;
	b=emiDOq9jyVp9aF6cMAdyOmSiHroCHr2rNaPxhnlC0DbA4b52n7B7YiAEzh2Dh78gmeE+On
	p1BhjYsHCXtkd6zhtdMR0PG5lMeDVBUD9Mo9dh0zM5urUYgm9ZsjsgoglPPeR78y46nzl0
	FnV8uIEJocYecDqBIdrCqqOJ7M9ErsE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778220667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IMw78U+KcjIbysPwtZ/7htqjqMyNXQOiwSpYBpxoKM0=;
	b=IYUBTcTlwwIqzqdN8AGZLFTK+h8gAHWE+D6glJXB5GUS/ABf8ZU5rokNxbckCJ/SQZp8al
	iUfwAF9lNGDmRkUNMaVO8WaDQYGnKEhdeZQ3x+khA76GBc39JMHQPNScf7QGb9MufQ5aI3
	d1NbpOuD2HQ8h0gDc1WfkjXSSL8uAyo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-EirGMcjhP8W52Q7fWqi8IQ-1; Fri, 08 May 2026 02:11:06 -0400
X-MC-Unique: EirGMcjhP8W52Q7fWqi8IQ-1
X-Mimecast-MFC-AGG-ID: EirGMcjhP8W52Q7fWqi8IQ_1778220665
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48d0889c1ecso10861725e9.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220665; x=1778825465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IMw78U+KcjIbysPwtZ/7htqjqMyNXQOiwSpYBpxoKM0=;
        b=B8NtCvVdJjlA+FPf8EiFo/4pad0wTY9glJ+WBKWCS3zxvnQCHILqGikK2w1XXqr32m
         t7luzwudqkIMV19W377M6ZDfs/1cIp6CMEVUcLm5vGi5BhasM3FsWRUs9R5g5S2PpqXa
         KLGXh4EZIOagMxn+ZFVQP5Px8WyuRJHGuwcVvknZDQ56HY4u2R9+jX6ZlP67fJfKY9hJ
         G74W4M/JfJkDGV/n33Vz/BIy1JTcrzZnrdBPYSFoX6C0ncHhiXXp3EgQa+BxUOvkkCv/
         DHt93bVkWoA1gQJXmogCUmQUAV9r1e6p+l246eYumX86ib1La/fO5yZyh8KSoQigYBc2
         64CQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wyDgJVNzP99gCA8zLBOpMpjw94kaoDYyXGGPRMV7p+ICDhXu4X/3XBGnE3zN/D3GMQTpY2GHqLQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8SBed6AjOVBvhJLA4J3LXbYcNpawn90Un5Cr6h1HWpqXHENNX
	cTfhNpKm6mcb9sfgabuHyOC5RWl9hlmIuu1ZYlEpYXunWWEcxFXSuJkJ2MclR9tBgGwAG+EWUBK
	JnMTeZa19RcQ/YHv4q99WEBGhaCUk/lFutvt2UBIvfDBjJaiBXTFUaOF5RLT5
X-Gm-Gg: AeBDietuXWxdzC4+Q3i1/HNKjlxFZXAGWjRmgFdvgmbHC027OhHPPOQDctcBySZlU9Z
	jzV/yDQK9thudqSKsGKdwmbqABMqLrTxdIdTwOMaHTbw0zky2S+IJSDKKteVW/QCT9dHDUFCZvq
	pdEP8/0JjPKy6J+7xKwZ4fdooLG9JFQfPfDAaCqvyL0A72fvZTF2nj/GGkcfwLtkdvP6nYcTyd+
	bXic6glE6Rf7PtAEoQ/6jShTFa/lw8/HHl+mut24nTK8/pCywKacol1aSW60Y8FJMQD1tfAZjNP
	IXeq4Qd/CycvBa0V0mV7YQzfnpwXOIlu3OzLnSGmliOvuGZHSSyJzbFKUxPdoydGm57UP2bpGDS
	gYqo3NRnbuWN3RyW3cE7eulUucZLfK4i/J+aVOT7b
X-Received: by 2002:a05:600c:33a9:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48e51e0bb9amr110824625e9.1.1778220664760;
        Thu, 07 May 2026 23:11:04 -0700 (PDT)
X-Received: by 2002:a05:600c:33a9:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48e51e0bb9amr110824265e9.1.1778220664137;
        Thu, 07 May 2026 23:11:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65bffa27sm14204595e9.7.2026.05.07.23.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:11:03 -0700 (PDT)
Date: Fri, 8 May 2026 02:11:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: dev.jain@arm.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260508021042-mutt-send-email-mst@kernel.org>
References: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
 <20260508050140.49010-1-lance.yang@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260508050140.49010-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3MUM1nMqiHOxPsvLu8WIcemVMrsjQaYrxOSe8D0nDhc_1778220665
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65B9B1A0008
X-Rspam-User: 
X-Stat-Signature: umjw84turqc9pyq1yh5cfxteeb319h3t
X-HE-Tag: 1778220668-950309
X-HE-Meta: U2FsdGVkX19qHHXJuPbJq+etY5T6Gjny/zrlPdl/7t5VcNyuORGDHwOUHzmDhJhKkMEOHi3xBWhmUfGvXxEOV7/KrIJc502I0VlvMhobsjSlzR3s8sQ/ER8vGHINP6AOq4IO3CHwPMmiU+pI5k+QXZr6QkTG42oHvKeAuOHjT0AlYQbPs56rlqD5jxTg3cVA3Gx7pIDE5nxiQdXgb2aGu+WKU9yrAr9B5jQCWPNuwtci2ziohOIj6whvpz7kiL9UCp/rlyEI/gDvnVo+YuS0xJK/jCbGrmz9YE09BLusX3uuhJUX9IwoUK2Gv4yyG13R6TjJyTk5T9a69n2C5yzGI6tMcPpjByzRkjCjAEciqweITSgjCiu8nl2z0EU4rMrfIh3ApYq/RSQcsgEY6rExHQb1m4O9/LAf641LZAkusC6vBuC+xVZF1cJSxqZLTmEN/e1oqo4zW5Jhq0KOxEWrsZWRYitKN+F9HeqldyVjbYsN2pAAie20fL572dVvyEEuQSGaqINBivYuR03go62c86+XQsV2HMNSQOtsutEtWpykKgECDsjk86lfYIVjhzJLKVS7pMy3P6ij5i0E5vCyaDBkaCNXq3gUKGkZAiJwQB/7xsnOeRhfar9oV/+ThELaWVN3dZXvX81o8HhxVG8FqoC6FhblPR6mahociyG0MQaaFmtiCZDHLB9WEQLyBfKJetXpBOBRtALjMDe1S7VummvS9nGwqcRHbFz/mU8odBWStLITmjhgHatI6p6ypRjQPdvIMETl/YMfFbZGtey19q/wEV9sz1vi2kqfYOPYpUaxUK5+DR59oUpLxVgwRC1ThSek0ohuHB0rl7lLQpd6HrmSrkw+RF/DVQ+hrbcH4yy5sgxABZihUifvD+kkoUcFAGNQxOoeyX/U6RYZOhzdZL7QCBl7k9O/xu/iWtCA6K57HCHFXrbveMJDYJzB6/d6xhdyCOaOQ2pZM2anf8w
 NbLp1sGz
 zmdI5sPnZAV44TSLhfYhQtTtbZRSkAM1od4esBIEhBvxtQcWf7j4g3znb5/Gvp52BJgl6zWj10IAj8DsGDIMsVUqIqeRPD67eX+iYcLDF4f5pvKLXJYCk5qPm+IUpX+TvR3x3ckdFX41mbE4spwW/xjNfLLGuOvhgq8W0pO0Yjd25+NJtCs3vxjfadz7HNT8jDnSgfrdh661IqH2FIAMhzMWgp2D7gOSMknr3nO9s9kmLJjUzR8dLNHxUAOI+nlH5FozL3h7FzXttibO+9ScNRG8ms2IU172Pwp4zgH9slzD2aR5yvCXhPNxLZiqiq+R5tEqk6x7eLw31EkB6YDwCwqzEBq5+ITWMv/llWUTQKNerKhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 01:01:40PM +0800, Lance Yang wrote:
> 
> On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
> >
> >
> >On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> >> Now that vma_alloc_folio aligns the address internally, drop the
> >> redundant HPAGE_PMD_MASK alignment at the callsite.
> >> 
> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> ---
> >
> >Hello Michael,
> >
> >Could you please send the whole patchset or at least the cover letter
> >too, to everyone CCed on at least one patch? I only got two patches
> >from the patchset in my inbox so I have no context :)
> 
> Agreed.
> 
> The missing context makes it a bit hard to review the individual patches.
> Having at least the cover letter CCed would help :D
> 
> Cheers, Lance

will do, for now i bounced the cover to you.


