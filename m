Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532D2CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12B66B00FE; Fri,  8 May 2026 02:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC33C6B0100; Fri,  8 May 2026 02:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1E26B0101; Fri,  8 May 2026 02:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88DFB6B00FE
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:10:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D0BF16076B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:10:45 +0000 (UTC)
X-FDA: 84743228850.03.7937D57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC91740013
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:10:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkQ74ION;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3FE7cSV3OdBp33Tpylwqyz3x5C7uRSwJlhAfYFOQYY=;
	b=iGKNPN5MHqljKUCdhv7zQ0dXbzjUCmWnixCW1i1KQRHAvAHKY/TaHL8SRsQ8jKgCQWv1//
	uMq5+tu8KwxANDzYMX06qvU+evn64SAyYdcAmH46wdBrSQncxjaq8TpaeXdzMShjDFTJa0
	qAtp8TkI73lavTPYdPqn+6aHBJSMr0w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkQ74ION;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220643; a=rsa-sha256;
	cv=none;
	b=HBs+T49+Ncqv3DJS5/7v/bQlVlqeO+URDXwrKe+p2rCJIh6zu/6Q7PgMdLBM7WTIIL0ih4
	g853Z97zJsu2Ij0PrN4Qwnw6+n6tg4RcludhbbEXuApHI8LdMcxSzeU81rZA483AZYRq9+
	4pU+H99B9Gw8EJXH8vCc4kCFHfhCP04=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778220642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3FE7cSV3OdBp33Tpylwqyz3x5C7uRSwJlhAfYFOQYY=;
	b=dkQ74IONttPLTYsC1YlBUtlKJRO0357unmYt/rMRDIFhvVIkG3+knvbuHy0lEtcooQ2Fjw
	QzO8dzYRV9eT5aulBN4kIFtlW92SilySRGFrVzkajOdyk/psIwyfncClCKVryGsQ7ePuiA
	9w52CZrS8QavI7wm73k+lMiyw5HoDYo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-A-pM_0NgOBCAHw8vHa5pHA-1; Fri, 08 May 2026 02:10:40 -0400
X-MC-Unique: A-pM_0NgOBCAHw8vHa5pHA-1
X-Mimecast-MFC-AGG-ID: A-pM_0NgOBCAHw8vHa5pHA_1778220640
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488c0120047so9562005e9.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220640; x=1778825440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3FE7cSV3OdBp33Tpylwqyz3x5C7uRSwJlhAfYFOQYY=;
        b=TPeszrKNZjCwDNw8XXe0kdbqocbF8O50IGmhut34CBQ1qoUUrtVQhmyapCc+M7av/d
         zrveYMLhmwIwZdbbatY7Y/pX5+Pnl2/OIIwnuzE272kc9LKQygCOWmAb2Qwth7vsumgV
         rLZD8dFS2yHbyKJOr+hrNnChDUnlc36HW03duO5UNXI1j8nua0wyUjukk5Xlpn7Tc6P3
         oZqZia9E2dYY/CX4rVfB5xNz0zxe640rxptC8OwUwww0HYd41zeUqEJ/8O8lORR7hWJ8
         gAXYbqmrIJCjB2swdH7j+Un9qe3Qje1In4EW+rUKBmBNmy+x+uE8tF9v2yXD+drCHhBP
         Bqtg==
X-Forwarded-Encrypted: i=1; AFNElJ8sndySIQ3AX1TgQ1aWHmts6z2DR/UpNU4LjRq8281gpTk+FArZSE25uzIf4Fs+f4fmBi+zrw/ASA==@kvack.org
X-Gm-Message-State: AOJu0YwSjO98YC9lF409EXj9r1Esw2HE+TLoq68GSTzQ+ESzRuPdiS2g
	emaZXp9sm4yjjUFPSuHsbux+G6HBkv9Pe2QTyv+ivYO+c6bEApWJfaihRHDsGOxYnpqrhG9stgY
	YmBSbNkc92ARoj/SfOxXowVkV3wnMEPgkgdtLf9JYG8+tfDUvLPcy
X-Gm-Gg: AeBDiev5cWXSu58ye/j3c0avAE1Jf1Aod138JNu1AcyEONoi9RXKepIxT6HTV3Sq7Zr
	GgdYA/G/VsuLURQ28zWv947PKW1FtGVvd1Yv2/9cukMEp1HAPp6hLrWbAQG0gGr1auqj0nnc2q5
	hMmMuklZktp1Yhd81v+QyU1NpFcRDP9HThvCrMnLvl0eDenglBHDLnvwsQpUCSaAfB4Dsw5pLVv
	XePl58rkcQUvIWxak+5lI6YLMRZXHU4Y0R2SHJFT3I4+TAvJW9VpbBrKWqDFiBUIB5ZukClxYFM
	N4U6zl1l+M4ErkkaWFxkpqljZpjqRMJ5PLUc/SJDfTSHy2y5POHpDz/lTVv4jJtVz6EIBi8B9fU
	YvxFCM9y0BQOKXrzsQODjp+6MepHc2nanZnQgZnfJ
X-Received: by 2002:a05:600c:c08b:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-48e51e204b5mr128573035e9.12.1778220639584;
        Thu, 07 May 2026 23:10:39 -0700 (PDT)
X-Received: by 2002:a05:600c:c08b:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-48e51e204b5mr128572735e9.12.1778220639067;
        Thu, 07 May 2026 23:10:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e642e5f26sm16991475e9.1.2026.05.07.23.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:10:38 -0700 (PDT)
Date: Fri, 8 May 2026 02:10:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dev Jain <dev.jain@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260508020947-mutt-send-email-mst@kernel.org>
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
 <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
MIME-Version: 1.0
In-Reply-To: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zTQRzVi8Xp1TPFKWYemEkD4wDuM5R9Iv1cCMNAnbeJ8_1778220640
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC91740013
X-Stat-Signature: jgnzxxrmusw8swskctmobtctdhny3mxg
X-HE-Tag: 1778220642-933278
X-HE-Meta: U2FsdGVkX18ddaebi0z6Lcm+AIJuk/TZe8bFGr5RHgVB2qQVnFzqkd3uPep5G5thiXi/O4CUVTQJz9OoPjOhbR0i1m1hub6ND2BgRlszCJO2iM1Flxnx23W9RBOnmSf3wR/Pplv5t3SvgeLKR/ydHngdwxy8ls1x1KQyoqBRJa1p9abAgXnsmvqh24BGdpiR/XvSgg3rBr6dj0taSwaTilcufVXrbh24RlNDwmz+pFBxcO3OoHvrF1mMmAaFIScn9rheYt1Jp1sM4BGmzxqMHKvZDmPBTUoPx5xt9iB20Za98cwF7CWEZLE39yiBih8tMQr3avcZiwaVQl+pkRD8doz0M2ZnXdd5DwIsFf8SfSRplD5GEAUDSGpVfXOreiG4DEmmifMLyHKQwwbBEspl4PDWXC0s5TLXbhVkFMDzd+Ewg18c1LwT8zAQ2tbkPQMvFrF1FsmjBuesAo5l5lo7vLPRDWTizb9HQJAy2N/MbIGa1RDhkq4sq2kBHbu4W+ikAg4PsoZC9m+L6IJOohQUOREZffGlG4EtZw2lnuFvfQhBRcNnX+p8WOZ9VUXOH/wWDm+4J0EzVJC3FNr5oZIEUpQd8UG83UIEDzUu18NkzT4qrgfsCRFe2wbkdM+pysXi72U8W5AsgzEa7f2QTOG3i+dwLBFhQuCGNbaq1MxwgAyzof289FJOQsHChvBXTl4+wFlRzhdeJHZ5cuJGUfXuqB/ld6X7NhUASqDPeD/7N50je4+QjMVr/f29hx4Qk1IQKPU9JtOTjBQbBsGl12ZfQ62ERLvgy4Y+brgK9/QFPyGSIv1YwYsbQxJinqjDkjTKkvzXw8nmux4zYZcNQ+qeuk36oI0aSBLyxf1qZwZndIssOrHMQhIZaX5ALDDCLLB6UCJBGpvQ6cJOSVqXk+/0KydqVwjtGMFeHyRbdn5bN6QL8xtSjxJtBo9mWSUa1iFCSfx1BkT7J2HAKsMfUAS
 9s8ZPfDT
 h/+2sgIS2s1KO4l58SdSweTc6IaOMoIE6/QcjYCcx64MKdBg1HGSx8or5HIAGNOxj3GxSbt/CeD7TNt1SXyV0qwNaOsN2lDOVeydDCWSc2bxGBHyDm7XOMLez9aahGIDFy0+NsoYC0/15/l5Miq1MpMcsx1UjfPfFTrLnsjkZjpfNJvxWQ6HsXrmfNcPDdZo/4NIhkVxa4tTIUKyC9M1Mb0Or+iYeNfWN/qA7hiE1FBzU75ElB7aRQDaIKkML417lVHXwCdbWJhEFczqTKBY+Eemsg6524BMnYxQVWQPwcCfy7GRGaIQmGAhuKEm9/K7Nw8BhlsuZXBy6TSVw3K+73xuDtvdVmKxb9MBuI3jw1Hus09Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
> 
> 
> On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> > Now that vma_alloc_folio aligns the address internally, drop the
> > redundant HPAGE_PMD_MASK alignment at the callsite.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> 
> Hello Michael,
> 
> Could you please send the whole patchset or at least the cover letter
> too, to everyone CCed on at least one patch? I only got two patches
> from the patchset in my inbox so I have no context :)

Will do, for now I bounced the cover letter to you.

> >  mm/huge_memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 8e2746ea74ad..f51c0841ce91 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1260,7 +1260,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
> >  	const int order = HPAGE_PMD_ORDER;
> >  	struct folio *folio;
> >  
> > -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> > +	folio = vma_alloc_folio(gfp, order, vma, addr);
> >  
> >  	if (unlikely(!folio)) {
> >  		count_vm_event(THP_FAULT_FALLBACK);


