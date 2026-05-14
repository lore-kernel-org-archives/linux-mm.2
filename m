Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF21CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 18:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410A36B0005; Thu, 14 May 2026 14:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C18C6B0088; Thu, 14 May 2026 14:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B08F6B008A; Thu, 14 May 2026 14:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 189966B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:57:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FD0E120246
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:57:00 +0000 (UTC)
X-FDA: 84766932600.02.B608BE1
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97F811C0011
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:56:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Xo4vYNfa;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778785018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8Dmb/0xFR5yj63uM1EuYrYGpP68khCa5e0rkyGQMeU=;
	b=70Mf4jrqvvBxjnk0xIH4/Lxa3Ue5z2pMH/AZItrA4pnCkgctaNQTa+pFeqnD+1OgVG7FmZ
	5gm0JJsXMB5xbPGdySX6wVwr810lMhwjUyQq9O5wLUnqsXP90fxlQ6Jh8sJt+BmkTjh4Ah
	gYEuTgwwMTFqLJsEP+9k6G+5zOxZ/Nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778785018; a=rsa-sha256;
	cv=none;
	b=ed2pdrFwZwvEJpLmc5zpkqvscZdToTdHA7GA4yelnfX26axJ5TeBJccOuHYbLaWIPyD0m8
	mrkeWzHwo3L1gW99f1b11GRCjnq2mTQ6lLcB5rOvNnpJ4L2dxlL0KfMch2FlsBY5205ctX
	yEJs65BFJ/PgJej3p7mVMVqihqu3PD4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Xo4vYNfa;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-90b2fcf90a0so23513185a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 11:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778785018; x=1779389818; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V8Dmb/0xFR5yj63uM1EuYrYGpP68khCa5e0rkyGQMeU=;
        b=Xo4vYNfauigAdzL8IecArAJYqaeLsJD6gpB6MIKV1684pq026rf4zlm/+3CaBNX8mW
         kc23j+N857lHE3xLA7NqebFGyBpLs6iv0oAFtjvgRCvuPtayEyP9UgE0Z8nx0o3vPGkd
         IKdaUV/4MI1GFl0tlEuEo1i3ccCM1v6u1DWeHh9vhIi7pn3cng4Lki7So39pc/xDWk2l
         5+Us4F5claGR7gY/rJwTpHgsNXPnQ9xqm+XA1Z7IflLtBIj0+ohWXzVjuroT6Jx9LwUO
         8LxeEcVJKKfHrcgo+9VDx+SsZT9NlBN5yzzvSMKyOoATZlXwt1PT4s5jiZIi3r9PfRNx
         5b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778785018; x=1779389818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8Dmb/0xFR5yj63uM1EuYrYGpP68khCa5e0rkyGQMeU=;
        b=H+cd0lfNekc3FtnU3x2JPkTciXsS/cr35AkCjBPfOgESktXTZ/Rxq5gBnk3S9rzxN9
         mUJFgs+BQKAykCs0wZFHZYhQ3K5/4+r7j94n70Nu7BqVqmeeC6OPa3DY/gIVYEcEVlWp
         7tgMYfrYVzCn8vloTgttWrneHSYALm3tbIES0kn5FwtWqAvrBzFc0WMZ6khwAnIekT1N
         fhX3KOfnoUC7VORVlXsy/EpytCRsIqyxCNN1yqPkQfLgAGbFIOEy3k4MF2psM+RvDRPp
         P9e9EPwQU1cPXad6xb/fMbBiGK/Rxiy7bKBf+ZB/HZOj8HczCXkGD15gx+cVNEm5WVuE
         vDqA==
X-Forwarded-Encrypted: i=1; AFNElJ+RVxK0DVEwv93H8hrhGkuVro3ekgTtnCvY14dPeD5vIBSPUs2t6XYS2Ew7HcvFHM0k9jFwY+Hraw==@kvack.org
X-Gm-Message-State: AOJu0Yw6MVEp0dCou/Y8TAQ9ANLN9cXqpnrn9YTjAeLEwGDteK+T1QHq
	cPI5tOtWAk/TCskm8zL4NJ7vK0x5jssAuUHJkSSSpJCz+VUkShQo8I+P7jtv6cUVOFw=
X-Gm-Gg: Acq92OE7r/pFPiYysUbs8o11ruiGzsKapVhaWDAKkZxdFbRdNggDE8mEknWh5GpLPzT
	pTqXaGsUhmMUJsWy/C5HWpoDPKjXU/DC+kQ3/m+8C/elYB7UgMyTBYE865QWQ7TQzL7gJv2cGUY
	BHT61pccSY0ESpJz1GQrlxaLccrQ+Jy21+G4e5kvYOKz5Dv+lezdBIa8cT6eV5T7hgbm2i5I5og
	gHYFX4U7sQLGBkr21Onjzm+5bR6fYtM5iU6ZI7uUyqPQ3qpgvnTrAspEOaWCRVSvfhQoxsEF8gi
	AYcXQ9Kn16+c/DD2hGxwmSkhtG/+wojP+kBmYImxUXbbYxIZqYcW3rw5zxoT4g8RSKQHRfLiRJ5
	gM1xGZytzGucwtnRR/7xSOMYj72pKHbquHix++k1yKxfGfte44BS7YzIiOsMEYYihIuPsoX3JvY
	IQsz8BrhuVkfJ3tbx6wuK+1Nd72ERUE/qQ1VEW2eBTzJ8+GxrZ6UTaINp7uG/fEpFpIXN3eqaq4
	A2PH5m70xh+
X-Received: by 2002:a05:620a:2587:b0:911:c5c0:d5f8 with SMTP id af79cd13be357-911c5c0ddbfmr149858785a.9.1778785017499;
        Thu, 14 May 2026 11:56:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90874e4besm30437366d6.2.2026.05.14.11.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:56:57 -0700 (PDT)
Date: Thu, 14 May 2026 14:56:54 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 09/31] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <agYa9s5B7OWG-kjR@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
 <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
 <20260514135214-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514135214-mutt-send-email-mst@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97F811C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: yw53y6gcf3w1iikczm5311h4ikb6ezmr
X-HE-Tag: 1778785018-363371
X-HE-Meta: U2FsdGVkX19Z9m6kLQKKGn9fRPbCzfw2x3PnNgik97AneUSOn15kH1ssPODMBPr1NDXs4g9a94y2/8S2nOjSe7ruPdgpdJOyHCB4VwXJt7imSt0eCh60zEe0b1eh+xds5MFs2jmO9QNI1bZaDOSIBUnjkVt7d3TXa2kDwj9IexP52FpR1PtmrbYajIf/gvosB4BLOtRl0ggPWvJQnO5UWg2wIDOSGsXrNJGSUUKlTD8p0d3R4LA4gK1WbiEk9PChP0p/+cYS7lGd7fDCB0Mwi1oZIQVK9m/N0bEXyGVrBysU9Vb2FeVgB34GwccueZ07xgBZ87Se/Tb6w54+Ld1pUvjxHvrDUrHci7pGaA2rYY7KSKqRWLy3y8vjRwnl35NzfeTiwi40sVnXdg22gIXwx1wSNoh7tZaepOVn/V5XnZijxEGKXPXts7IwnJBoA/fFTLcvQS1N/lmayBmgk3JBYX8fM3hDQXUq/M0mUiTpzX/bDovXrUfxM0da2w1O95TcZuv56Dt95w6qsgrx5PN5rbpRlCExm0V1ZexbZJbLaFg+C0BeX5PgarP73jZocjkj4vmZTW/wUYWZADm8lMsH4WZYBB8YRdZyKwDrxL/OnGTy0kgmJWppwxwTWBYX4fjdF/yFfO6V3TV8AfrvEUluiw1ecsXIW2k9jgw8OJ5zHTxG2N2/7CKI8zJ4tCiAu44Cn272v2z53mfSWNtfrp3p2WcWJ4ow2QZh09rzHVmVILUklGQpQMOdYLE+2fq/Nd8MXC1Kyvcrgk3vRWMvVxpI2nUJqdbvy9tOCUvbabipUNHcU2sGPMt98KxActX+gY0PfGiI/M/lWvyIjhMBvPXRsH/7w56WhZOpmWOn+wJuoJPh+4tSID4lvXBpVKgOPaigEwY+ISP0M3H/pfrAPdeqaWnHggEsmzI72oL8MZb96/+Q+hteJR4imnaOxVXuVAeRvuJt6867ZMJ+vZYypGa
 Crdh3Hf7
 ddcseawf+O3JPqiTn0Hn+reZzY0w5BI4xj53ZsyYMEqHbMMW/SZmUMnDsE+VMgl68Os13SSmviG3iaUavVvRGhTGktFuA7IGJqtgjx7BwZxc3uUhE58pnQwIoQb5bea6Cra8cntK2oOGt1C7FyP6r4XqzHDo5lyjcGP26KiqEpdPZ04PVpSbwLSkF+G/4Kn2m9rJsM+su0gLA6eaJ60CGQQu1M1Mm8HkgMNJQWfLVEQYWbTlEGjKeMa7tnkAreuWRRky3D+uWcMxUd0pKFcWTdWFQXhcO8wiRZ8CS+v5x3+HVNKKv/uSFwfWSr4C+bsn5YvCxstzrCyDUULkvaHugCcnRtHy4osrO7fF+VBWnFuTQImpHyNCb5LlGclTQWLaQ3jNqgNxcdTfPGCIeW9C9l8X7XVXBc0SrBTakWU2hpXaCZXAjLAGXeqmjNnxWDCkrM9Iy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 02:00:31PM -0400, Michael S. Tsirkin wrote:
> On Thu, May 14, 2026 at 09:49:33AM -0400, Gregory Price wrote:
> 
> There are calls with no __GFP_ZERO but they do not allocate userspace pages.
> 
>   - drm_pagemap.c: GFP_HIGHUSER -- no zero. But this is a DRM device
>     page migration, the page content is preserved from the source.
> 
>   - test_hmm.c: GFP_HIGHUSER_MOVABLE -- no zero. Test driver, pages get
>     content from device.
> 
>   - mm/ksm.c: GFP_HIGHUSER_MOVABLE -- no zero. KSM merges identical
>     pages, content comes from the source page (copy).
> 
>   - mm/memory.c new_folio = GFP_HIGHUSER_MOVABLE
>     - no zero. This is CoW, content is copied from old page.
> 
>   - mm/userfaultfd.c: GFP_HIGHUSER_MOVABLE - no zero. Content comes from userspace via userfaultfd.
> 
>   - arm64/fault.c: __GFP_ZEROTAGS not __GFP_ZERO. MTE tag zeroing, not page zeroing. Page is zeroed separately.
> 

Right, so in all of these cases, it would be just as correct to pass
USER_ADDR_NONE I imagine :]

i.e. the user address is irrelevant, and the caller is responsible for
     sanitization before return if it's relevant.

Otherwise, passing (user_addr != -1) the buddy takes care of it for you.

Just an obvious security bonus to all of this, but by no means a
requirement for your set.  Just an observation.

> 
> I'd do this on top if possible.
>

Yeah reasonable.

~Gregory

