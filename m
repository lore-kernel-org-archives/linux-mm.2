Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B1DCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A799F8E0010; Thu, 23 Oct 2025 07:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28F88E0002; Thu, 23 Oct 2025 07:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0138E0010; Thu, 23 Oct 2025 07:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F47C8E0013
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:38:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13D71160B1A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:38:50 +0000 (UTC)
X-FDA: 84029182020.23.99B48E2
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1505E18000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:38:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=2A0hp4F3;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf24.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219528; a=rsa-sha256;
	cv=none;
	b=ICmAjq4pozUvUx4W2fA9dptM3zPtmJj9bkgqEpOkjmz+IzIrsDao5LMsjFkGmxrWKiElE7
	YcoNvauYuRcCN6LH4dYdtdkCNoegPObTphqd1lqcJuu0gemyJ8OYkKMw1lPh4APjerKKWE
	sboA1VrqVdvkxYAT2FcIeUtu/tSW7Fk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=2A0hp4F3;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf24.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OfFvZSBGvefp2IlhmMNRYw7kz1hyuz0xjUoRSAHeZw=;
	b=FBmxieMDxk+pUWBOxMBUWNLJVS3ZYha+lBmqdA88jHvl+eSgCG/pTKYXRBec6XySb+7L8g
	lFLZj7S3trP21JmbqXwHQRQiDxyUomdjjRv1huPRQHki1cSRggZR1vxDSMZZVMnNtpCQFx
	8zrGnM+5M40IbIAn/h9pFOr8xvdgAuk=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7835321bc98so610623b3a.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761219527; x=1761824327; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7OfFvZSBGvefp2IlhmMNRYw7kz1hyuz0xjUoRSAHeZw=;
        b=2A0hp4F3koFTEJHntxXP6Yme7fL3AmQ6vNzrVl32llkjZvDGGDip/m9UO/vKrEwfwi
         85edB6G3WYm4vW5wbavOl9arfxvRtjrx8h/SZa4hVbEBn01pfKQ6QXKGduGtsRYbLCsr
         3IAANCR2SIxK2CO/k+A18s0DPyDfBMoJwuE8aPtmhcu5nC+HRQzBIFk1xOMTjnVMPlc2
         tdVTchRapgGax4s4MKIkQeJLoTrUqepABYwRxgfoNSeS8PydurTapA70idh2TQem18uQ
         MMp9e6/YiP4oEOAyOevRGtNbn0MkMRAT61R2uTc9NjfMy8xEmgyqvGZj3s8+X5u2Qis9
         /sIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761219527; x=1761824327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OfFvZSBGvefp2IlhmMNRYw7kz1hyuz0xjUoRSAHeZw=;
        b=BWvmmH7ETt+3aA6QyWSOxOn0oH+jbHr4CA3TGo6TQTwDMIcr6DkTz+omS/JG0xyeL3
         hMYMsnJErg/5izSPtbov3mfkILyabZtNeNouLm/9cuiUBflz9LXzsWZxx80EUPOtcOxJ
         1t9cMM8nBtw+LSM3iBdeEp1G4IDV7jCw7bTqWneC/VNu4IgnbrAXKDAbG/UtrGUmdk9B
         3yeEpkDTjMQjsIEg0sy0xcRFU5zPBSy91ATjAwkM1gfasH/QMvg0qD3Fp4VJDKJZwSMl
         1NtAL9DGNlE+Tpo8L0IqTlYkHVOyi+9PFzbZc+TOvvfp0nxZCXigwU+qYDRQBj3Fb8wc
         xKyw==
X-Forwarded-Encrypted: i=1; AJvYcCV9Ae//vWe0F23KWg2psWJWcp2Pf98fhTCE4NZGWuL92ZDaZ3IrN/kvps3CiP2DK3g/BviCrg2AMQ==@kvack.org
X-Gm-Message-State: AOJu0YwBUDBuNJtrJ/1qFB0Do/IdamLvaiP7flatZoU5xjkFt6dkb++H
	8jSvEpXr7CAWJfHR3PeQt6MI+JdgeOD4bYQazo0V7qfiFgvsDs23iL+JOHH/H1Rs0tQ=
X-Gm-Gg: ASbGnctqb7rAlDZBgv0Y6tXckSPMoF7ZtPIq7qO/tgQLV4Gg50b61rCYWuQEMTh/M10
	+vCG3Il8yuh0uSNmbZqGzWumBj31kOrPVGq7SrukrfQrjOfTwUNJ3KGHchlMSoE7p7cfRunchhK
	U+QlTPUaUNd8nSzYB7nzBMuW1eJZvQj9esdzf9idZ6H43ETyPmp14Wl2j0NqOURyMpzv8AOOjN8
	vmSL9Cajh3+13vbNtNedPZZf2Z7UX8zTWJmCyyZT02OV6mlOTzoo/30xf4CgZc9unXqRaGK9Hh9
	uf4Sgavc3GiQsErZRRJGpScinUSyfQmHwhNyDq0XQ/adWv50II0KQotiK/c4oTAqi+NVN0oUwmI
	opqonSKkh3r+LJUcAq0mRAoWEHT1Om0/xqRqsUkQfrQNJ+710k+SsqIunYQ2tQY4IDrIDds3lJV
	R8f20cw/WimQpSvmw1dwR3LtRncHiyNGCdXRIXRMxNNATdnTH6+q6CPp1TMyU1/w==
X-Google-Smtp-Source: AGHT+IFGvY2Pdi6Kzm9/7JRxOvRXqUtuxuo/ixSX3c7klUnIdzpgEtIPhjSJGnNNJmvDxy7KykQvkA==
X-Received: by 2002:a05:6a00:9509:b0:7a2:7256:ffb4 with SMTP id d2e1a72fcca58-7a272570178mr3763899b3a.26.1761219526650;
        Thu, 23 Oct 2025 04:38:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12bdsm2225482b3a.72.2025.10.23.04.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 04:38:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vBteV-000000011nJ-0x06;
	Thu, 23 Oct 2025 22:38:43 +1100
Date: Thu, 23 Oct 2025 22:38:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <aPoTw1qaEhU5CYmI@dread.disaster.area>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
X-Stat-Signature: pnxihmaj16khpgqyoptqx9cbbj7z61fp
X-Rspamd-Queue-Id: 1505E18000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761219527-508958
X-HE-Meta: U2FsdGVkX1/yU7J8d/b5CDVJrLHAJO4BL6KHwpq9zXLg8YlvbJUL18wexjJWRgWe4/NAnc9Re5whr6yQGwdSJRRqtIlmA5feQkvF6WX8w2GjBC6egyskWXf94mtghGYdVStWFZebNue3rd70sD2gW5JGkLuTceBolAHsmnlQcQ+9hKFLm3IxmU8HhkuCXxuDVEXx8quCOCxQrnWetD9vjKNFi6ty7N2xQz7oZPkCs46pC2OKJvneQ3034BXZMjMmOrw39KdvN5voLhtoCc/t5jmbNz2Sn7OMt8obvQBs0jBHMPuQcWNKs9LXaKJts+BLlxxKegPrTI0mxlOXuP3+qNz2uNajA9AzkNH+fhPB73ml15fSF1v7JxGtgnRv0g1TukqsF+wfnGuuYu+POuFvvaZtll0Aoah6YO5dy6LUPpz+iFeccnLy90W/HQ09ZCzRWoG1bjFWMTN2s9usmY2DFEljtG7yP3l6XwJaZK5LrqiGvdhg3ktluyEafK30SX7UMJaCpNuRtZX9UYNwz5YkPu1nZlcHtcW1RBJ5lneVq5p+jIyoEFAdp5H7Ck37nmWNKoFS9PHuLCLZJ1cJcbt+aHzhMlRmjXU2vfyJnYdlWMEZqtU8x07su2MgJYz9rP8LbujsYBUoI+GmC/F5TEZbaHZDn+Br/fXAM7OH02NnjcvJITCeNYnlTnQ67AiAh54jurPKSyqsa4KMmbjLuydUSd+ir4cCrdqi1hOVS9O4//twHPkaX9y6riiDiW6PnPDIZVZLD+y7ibmOQ9a3wO06/m7Dw9AgUuQIxaLbesOdEcJRzwes15o6aMN/sUz/uLnjEp/Si2qcoFG3gWMg+HTcRYkwdf3/TljyafOkGWZ9sTweBFY013JiXFtiv97gwVHNBs7jvgGIwM0nb59JpIyFim1GWMjUZ2d7bzuRZUeP8n8rvzkfcx5uuiE2Gtx4PC8NEufpMQvl3tDZUV0EJq0
 UlNmjlRO
 As2kVU6NY0bBT31mSMFwrn8G9EO034PsvbaSY3IKaI+xkZkX9pilJ/ozpNOqTSUowa2uP/y22cAmwxpi2i3rDfIIjyYEN2PIRDIURtyIP+1ifgnEoj4W925ATJWacMZn7NV88bSQ9H4RmTw2qZINIcTs69gZAkgrK5sxTlDYnjNpZ2g5uYoMAbGNkMsPn8aWlOmx1ObqEtsm2N3pQIiLnqSlpZEL7Hom2ey0TEVcZgo4mNGmxvxXCsvXW2FvK1cFS3ui8k7ZPM88O5APTjCZ2fTywzGYnsyo5YPyDxaOMzTGIIfG7wUZ6kTgT+2/wOf/X/pIhbK2tmPWSySiHscSzAUvty+pWMFl/S4upS13k/iiM0FWXgflLjvhng/7Oqo6sT0B5g2aSvlPRq2zhVxn1ifePOP6KkFm2g0C7v11lmy4pt4DIQMYiZq+K2vtoNopsZ6xTf6MgnDQ3ySM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 07:16:26AM +0100, Kiryl Shutsemau wrote:
> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> > In critical paths like truncate, correctness and safety come first.
> > Performance is only a secondary consideration.  The overlap of
> > mmap() and truncate() is an area where we have had many, many bugs
> > and, at minimum, the current POSIX behaviour largely shields us from
> > serious stale data exposure events when those bugs (inevitably)
> > occur.
> 
> How do you prevent writes via GUP racing with truncate()?
> 
> Something like this:
> 
> 	CPU0				CPU1
> fd = open("file")
> p = mmap(fd)
> whatever_syscall(p)
>   get_user_pages(p, &page)
>   				truncate("file");
>   <write to page>
>   put_page(page);

Forget about truncate, go look at the comment above
writable_file_mapping_allowed() about using GUP this way.

i.e. file-backed mmap/GUP is a known broken anti-pattern. We've
spent the past 15+ years telling people that it is unfixably broken
and they will crash their kernel or corrupt there data if they do
this.

This is not supported functionality because real world production
use ends up exposing problems with sync and background writeback
races, truncate races, fallocate() races, writes into holes, writes
into preallocated regions, writes over shared extents that require
copy-on-write, etc, etc, ad nausiem.

If anyone is using filebacked mappings like this, then when it
breaks they get to keep all the broken pieces to themselves.

> The GUP can pin a page in the middle of a large folio well beyond the
> truncation point. The folio will not be split on truncation due to the
> elevated pin.
> 
> I don't think this issue can be fundamentally fixed as long as we allow
> GUP for file-backed memory.

Yup, but that's the least of the problems with GUP on file-backed
pages...

> If the filesystem side cannot handle a non-zeroed tail of a large folio,
> this SIGBUS semantics only hides the issue instead of addressing it.

The objections raised have not related to whether a filesystem
"cannot handle" this case or not. The concerns are about a change of
behaviour in a well known, widely documented API, as well as the
significant increase in surface area of potential data exposure it
would enable should there be Yet Another Truncate Bug Again Once
More.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

