Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236E1F8A148
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608956B0005; Thu, 16 Apr 2026 04:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C83C6B0092; Thu, 16 Apr 2026 04:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEE56B0093; Thu, 16 Apr 2026 04:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0E16B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:45:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE76EE47A0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:45:16 +0000 (UTC)
X-FDA: 84663784632.02.303096A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A0B6C000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:45:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E9dCTz1C;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776329114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/k5i8b178evugSrRqD2BM3wAHP5mDLkDXVGvrRPlfc=;
	b=PHb8UZNkRjr6YRh0xebLFsJtOdCO0L2hksAzsWB+GNb1nDK6AxUlUySTZz2do+XKe43cfT
	gi1kd8aOxknYed+BW368xSjk8gcRfDp4uN5QiTr1cMBTQ3P9bZLpqnby2WGJ8++PewHvQe
	4ImMv3IstcxMlRTbUbGXMLbQivfL9Mk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E9dCTz1C;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776329114; a=rsa-sha256;
	cv=none;
	b=hmeJR7TSROHWxdYnmaTcd4lklJ/1i2vgHxVM59WaSMGpTdRtx4lEtCXwx9X+olqCrRsvha
	6fBLW8ViRJDm5pb/WJEQ2QFdoXaN/ff8e75INQKVoS8uXFxA/JdQ/TB0mqIoOmRYboxC6V
	Q/gyLRZjehFbOHAkvQCnp17OnRmHbw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776329113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/k5i8b178evugSrRqD2BM3wAHP5mDLkDXVGvrRPlfc=;
	b=E9dCTz1CeDxwmgHb/VCycrJTLFeaCmJbI+urd27c4c3ee5/D7Y/qApvBrXNukepugUL7pA
	arl4vFYXA/RILAP0NqeSMEiow7XgoU6uwxVSkD9hgwrHm+Y3xB7weyQcNkVjpwoLvRAdix
	pBYdmuymMJgHWhNgnqs85YzcHx7jizE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-q1jl77SpOmWpR6qfbynMGA-1; Thu, 16 Apr 2026 04:45:12 -0400
X-MC-Unique: q1jl77SpOmWpR6qfbynMGA-1
X-Mimecast-MFC-AGG-ID: q1jl77SpOmWpR6qfbynMGA_1776329111
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43ea8161c3aso2685419f8f.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776329111; x=1776933911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/k5i8b178evugSrRqD2BM3wAHP5mDLkDXVGvrRPlfc=;
        b=a0exnHjsnuqOZs6cl6WTGqT6oD5dRdEJ8KorOMhbZodnMXFuiAXO11r5y78181fFEQ
         d2zHFvS3r0EkhA4ecZ/SAROwFfvmoOJdlgUxtsWyyBEg7JJDwzeGpkQINiqgU4whLS0l
         4xD7mMi+/6f++FGk/TuDtsy6gAASQZDjLj4YwCGkiJeD9QXh0wAKQ6Pj6zLxF91s2bw/
         DivSGPjHlJC8Juc+wp+kjSacwzakVZKLrHvQ/Qc80H/Pt+3HAhRQ/XhQpPh6eja7Ahag
         b0tQBlTuK6zr0fhPiykE55ExCmK6qNJj8dIdg4Bq3f+aqJnbgWIHwpF5ahIcpMTHtFHU
         Ivsw==
X-Forwarded-Encrypted: i=1; AFNElJ+HBCdYKvS3GGOBaUvapUZK36QwFLE0YicVcgN40tBn9k8/Y6EKTvqIAFwMz9vLUmgQg1HbHvlHqg==@kvack.org
X-Gm-Message-State: AOJu0YzE5WdaSQkBwGY2Kvuw5HKd26crizvfcsWPnXpE1xRHldLEZw+Z
	ZT/GXjAJXN6Br8Hui6Q+MYgLy2Yr0UDBXnSGm6a7cv1Kjgh03A3OXsLTBK/KH3P4XEh3dTXc8MV
	jaDv5aCUSJTxgWbWkjw7KZHGRg4ybXA4NTjsfvlOTDCZ9bV/LfttO
X-Gm-Gg: AeBDiet6acSx1o2WJIMnU2SVm4/fJ7yR1yWc7Tnixe7GHluHkE3m1/tYJY8H3ba29n7
	DLYwAAXv0Taa1Ao8eiSOpUrIcP7fF8gDzyuyPWO1ANBzpPwy+mylvkCx+2lHGPQj16Q+pkA2to1
	G5yd1Tv5JwoMJiMcf9TbCKi55Vx/PapEN+1MPGheU40U1A7TsKfgcghTLnC8C8GNlQkPOMmE5h5
	fPF55H8Oxi2CFkuwaDZS4EgXFVCPebLgray1YbpRsv8W+CVEEXGp5r3ocVzI6IabGY0vfVdfVGV
	GtHhKxdSF4ZyOoq162u6CljqgVPEilH3tBK46ctu3UkZKVbhchhiitPgjVG2BHfChZe4pNPa4Yq
	76LzYNAHfBKNnPe4ml/gib+uCNn8AC28NrmYCITKQymU=
X-Received: by 2002:a5d:5f53:0:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-43d642711ffmr37714715f8f.18.1776329110884;
        Thu, 16 Apr 2026 01:45:10 -0700 (PDT)
X-Received: by 2002:a5d:5f53:0:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-43d642711ffmr37714647f8f.18.1776329110312;
        Thu, 16 Apr 2026 01:45:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead33d65asm11893147f8f.4.2026.04.16.01.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 01:45:09 -0700 (PDT)
Date: Thu, 16 Apr 2026 04:45:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260416022758-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413163644-mutt-send-email-mst@kernel.org>
 <da935245-9c75-4cf4-8a42-2c6328bd93f9@kernel.org>
 <20260414062524-mutt-send-email-mst@kernel.org>
 <6fc307da-72b4-4d07-9e34-5e6c0563124c@kernel.org>
MIME-Version: 1.0
In-Reply-To: <6fc307da-72b4-4d07-9e34-5e6c0563124c@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x-Ra2mUGh9jq2F9y2350MA7_pTnklkq3dKqHZJebYts_1776329111
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A0B6C000B
X-Stat-Signature: rzcrimb133ys4dcjhrxu4sabuc561h5z
X-Rspam-User: 
X-HE-Tag: 1776329114-660795
X-HE-Meta: U2FsdGVkX18Yda9yvpFroFiVJpDO6UldClOv4zgXKC3rMV4ULRmvbj7xG7YVcnOXjpO1OfV6knvxkFgOi0GWRBQvDCfV7SuoxTzGnxuZZW3WcznmnBTP7LScTnx74xQR3sEki4bJKPckd/r/xEIiCHEFbZrSkAuR041QrFE3yinUyXDDLDUpWN+LIZOm9DF0Ys+dhnmd633yBn+HJwR/nkJ1GE4HuReYohm3NXTG0Ogv8TOmFpb8VfYij+UlHW7UVzQ2UJ23xyqoRAmHUjvHKLuMvJSC5dhQ1YMAe7dMEriZJC9h9zIaU76zVx1g68AgRsxYQT8AAPh4OFMXwHGkgT4XuzUhPwVe5GdtKKZfHKmdJFnliPkhDQ13plmAvMD4EBYEsodUseq/HWwNkZ9o/OM6RxFA98651fE2fU0PiFb6pl1tXTi9WVFZi1cvxhA8sKExrE/ide81Kc5wvlfLZdfbiWmMpkjXxYYQiLetUA3bUrVbz8kJouTFIGFV65pkDv7u9ABQ8hoiNJ/taLFI071PqGwFCOVXWAPCathJCGHhqB7L4A2BwygI5JMBOVarh9J2fiWueZKP9WqWfy4Vbqj0OIHUTi0uOTrgmI7cCR6sx9d+8Ojr1JoK7OF0PjxZBXkarTDLpyldqrqHbFRTFAcTgiQ8gPU7KM/FGuYUeqt1zfxVCdIhoSswIWc+ScWGS0Xtk9hD7i4MxJfj5PfEXOO4KPiP6jOEwqV8CwMLWS3MvunSLhMqcZtodgxO0GdH1OrwoTw9t9r8ap0RUqoBajnj68t2hdej1moIrFhdSk4kBpQeg08ZXgD+SvtE7jpwBGgzNbXAbX90b1F0aXvykM8WKFRQdl5x4dsMLxhdGgRFXvg0HM0Z5bHscR1FJJ/eDpfWxEmU0uG0Qpj+JljMaDlsxSe8XIujFFXbYp/qNXHC/jMTapYoxGUzfou2xXkzh1RsMYwd4DRyXeBxWv8
 JVRf6APi
 Yp12FoHjY6pbphkAhXpWZw8NcWn3AeJIabMgPLEmtMwVjEI7zTCxYD9D1cF3SY5lnTDVIrm/SvXn+o41drvSLmxcsWO6C7k8pDhy3ccNldqopmeLxPkKQFZ4zjI9GMZ98bCXxzmTxJel+GceTpEEXGErc+ILzfjWQu3FBuq7Sy19kq0Zb+4xeqlUm7416TIk5xifK/Tj+4lNpJBv8FMJIAkudVT2jF8B78UPnUx3rG716D8kST08WC/TPnTfLmntP5YMa4vAlsxx7qZyqwt5FJfbbROU2/Gw+/ESqz74B58ekaKFyyHXq2ngnzjkyWdalsZ1ICiee6JhzwFhUpv5YUGv6l2LIPgH3ZhsyQEQMz4NOM1H38EdD9u7BmN8FDCHdrd82
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:46:58PM +0200, David Hildenbrand (Arm) wrote:
> On 4/14/26 12:29, Michael S. Tsirkin wrote:
> > On Tue, Apr 14, 2026 at 11:04:04AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/13/26 22:37, Michael S. Tsirkin wrote:
> >>>
> >>> I admit I only vaguely understand the core mm refactoring you are suggesting.
> >>>
> >>
> >> Oh, I was hoping claude would figure that out for you.
> > 
> > We figured it out together)
> 
> :)
> 
> [...]
> 
> > 
> > 
> > Pretty much what I did, except I felt it is better to change the
> > existing APIs. A bit more churn, but in return there's less of a chance
> > we forget to pass the user address.
> > 
> > Because, if we do, the result works fine on x86 but corrupts memory
> > on other arches.
> 
> Converting everything is probably cleaner long term, But there are many
> instances where we just don't really have an address, or the address is
> irrelevant, because we wouldn't care about the difference when zeroing.
> 
> vma_alloc_folio() is the API to use when we have a VMA + address.
> 
> But yeah, something that is harder to mess up would be nice.

Well ... I am making progress on this but it is very intrusive.

Are we sure we do not want simply this, just maybe renaming
the flags?



For example:
__GFP_PREZERO -> __GFP_ZERO_HINT   -  request a hint that the allocated page is zero

And an API hiding the fact that the hint is in page->private.



Hmm?




> -- 
> Cheers,
> 
> David


