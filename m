Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F5ECD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAA76B0096; Tue, 12 May 2026 12:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434DF6B0098; Tue, 12 May 2026 12:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4F36B00A0; Tue, 12 May 2026 12:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 167F16B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:32:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B80491402A8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:32:26 +0000 (UTC)
X-FDA: 84759310692.15.30A8B62
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89D54140007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:32:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nKBkQySM;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778603544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUBFCivNGlkf0q4LVho8uONOLnLA2U/Jo+KB+lWOcJQ=;
	b=AAwvUKeVSY7nY9e0TepsRrCjZrZ8OxRv4VcSV37yWY6GFkK3EZ7aSfbG523pokrCNc+ciE
	9TZMFZkg1HXsL7lql3jQH+307nDVo7fG2xGPXJLoKI6+MlhrrhHa3lTblIbiCmfXkphxbO
	WMUzf/EXj7Zrp5JzYzOULsJHPmG3/jk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nKBkQySM;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778603544; a=rsa-sha256;
	cv=none;
	b=46mb/8LjpyzWkseqcNcGs7YGwielqksHC+eidOOTQOw6cvjD6tyQm0ARX3RXSfCCAMoxsd
	dbBndlCsG+xK4Af70f4k9+CKYNxjE9CljXJ7aUZubKw1/4XowDDGFOVjBd3Y/iWh6/Epwv
	voHGBl6WzxSDMzOoMwA9XgKyhnfxdQs=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8e8c0c2d2bcso743878085a.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 09:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778603543; x=1779208343; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUBFCivNGlkf0q4LVho8uONOLnLA2U/Jo+KB+lWOcJQ=;
        b=nKBkQySMfaSIbrfftDSJD9KbrvfskIYNfducWfJsGmIRsBQ4bLxh6rlDlAz4owBUN+
         Fc/C73eN8TIR8vxTjcZXQGjd0ykOcOK3vUXEvQ6O0n1sQhrJZ29RjI1jUdeybtWbJ9dV
         ErO6x8PS2sHejR0am83E9LI06Aglch0l/Op0zVPFiRvu4mn1dYJYzrSrJNQ7XIsplRKS
         DsFlURSeCua5P4ygFAgcPFjBmK4BbU31vCIcEc3ggKKel6ZWbRmpelYGmzlyFh7URo5h
         it7YfxqKhvBeEuFzsudXJHirw3hXzHORWK1kYAp2oc9cZPeA4sPigGNlKaSEBiyrIP0P
         7XMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778603543; x=1779208343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AUBFCivNGlkf0q4LVho8uONOLnLA2U/Jo+KB+lWOcJQ=;
        b=HbxATO1NAh5/PmDW0UOiCe0vo8ADpBfzXlwC8mM2a5AgBQ+OxpcL4nW9M1Hmjd5Dup
         jtzItxBsVNBbPTVjNLkeMxfZBqY+ZL3RgQzePbdqSIyrP/9Z3QX3264kC5Vw7LOL9mgl
         PzapNPXRj+h2xYXcoyP6IuHdOL+ssjXrK/2mu8e7Yfw+XGKLgPcK9onim+56BIYJqzot
         yYW+ywO2ibgQ6KSkp8ZZ8FRn4EDEBV54v+l4n4SloHiUebO8cOb3HsAPvQ1U7Lg78ViG
         RMJkClABgWFc7f11282BMhIVtq/SjvLKUapNGwK8ffuFnhxM1dlaXg9MSM6ukDHePq5s
         BZcA==
X-Forwarded-Encrypted: i=1; AFNElJ96g7WMZEo8ASUP72/MirN+TO+BhbIqOk/Cxk4vCE1M2xXJyad0dZ4ndpXWAkSrxR9kg/St9f9PWQ==@kvack.org
X-Gm-Message-State: AOJu0YxAFfCdISyIiSNZSbiCm4/li73rLg+zFZX3vgOSO1EZ6ZSra8Po
	B9kFeYJfUfaOHtYHGBttB2ZGwjxq021ftGDvqD8L+I2cIzHvPvxN2mkCj8hMa0ML808=
X-Gm-Gg: Acq92OGjf3Spyh2yypDuBFvQFRJ5WgZfHxfPwGdYy4IUxEQsdjkGpQxCvcKAZv8dZhZ
	2dbA34ddgS9r8RtQ0U+R/bbnpm2z9mwuIAVQW5DkU30FFhEZ1t53rFEpFMLdVxo4eFos9ZKaH0m
	rKGj0u2tcfhH1+7QCMxNxy6bUhwcs5q24JgV25Nb51r0paCicR6FOFlep8nI1YOKoMO7Y/uzC8N
	g4sMbJAXiUGX5774QsqSXsU+1WAjYgkGcd0u2yCG/XducMqcY5JPVJtYYaLo03CylgY2jPVolNK
	A1SAtIEO6EJo7ikgP4CqYlKRCq2HvnytBa5tkuyXEJQWgNyNpmIqav6QO0sqRaHw+PzBtYddR7/
	d3SQLWfOQL6nrzaA9TWKaCy8vuvTvo9QNSwOrAiQeH6cyeCK94KlRurompf83OzZ4ayzzBtJtR7
	x8pVuyTNdgnM1JECeBRrfYEd0qQZSgV0WN/pwSgv0mXH9YuID3tplrF6mIcBvbMZsqeztw9BaR0
	b2IYB1wd1KL
X-Received: by 2002:a05:622a:14e:b0:50e:5e8d:87d2 with SMTP id d75a77b69052e-514d1c1fb5cmr54799371cf.1.1778603543444;
        Tue, 12 May 2026 09:32:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e68a963sm123339831cf.13.2026.05.12.09.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 09:32:22 -0700 (PDT)
Date: Tue, 12 May 2026 12:32:20 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH resend v6 20/30] mm: page_alloc: clear PG_zeroed on buddy
 merge if not both zero
Message-ID: <agNWFPBTBszcq5GP@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
 <agNNkvRK128bYhrf@gourry-fedora-PF4VCD3F>
 <20260512115805-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512115805-mutt-send-email-mst@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 89D54140007
X-Rspamd-Server: rspam06
X-Stat-Signature: ojsmbtt6i8hmdecihgkbgcq4qdy9py9a
X-HE-Tag: 1778603544-439847
X-HE-Meta: U2FsdGVkX18ajEjW7i3s9abpye6RudP6odSd+4c30B1+9U0rU+95YD/10x+ZQds/EtLwHfZOVKToSYcU91x/7w7+bouSMdSFqbXG0HbwA77PR21+VogchIQHF7Tv7UakpVsQhDVSBenJOnJrdIPy3QxslGk/S5wWI1Wq/X9r+E8j/uHlNFFFlaM1NxrQuSAg8iuI46viuMFKQoT66DUHHH+2TyIO3ZA1oNuNU3lbqQ2+jin480Fe7F0iUfCcdKCBqwPo4kT7cN3DNvfw4ecaVJylSf93gTh3qcNCPGkxm2sEEVudzdRmkyugGRgOQlzThCLzKwXqvp/jq+vHQee9LWHxifgaHfAfn0bTMkS9G8VNX5teD4mzp/5qWdGDTaFdJCXdNOCaGWCPKXStAsG4QHk+35x4rcRiWKdb9UXAwd0nlMcQ3UbQZYmzDfrLx4oDWi2xfUTrfiBIjSiHhAwA5YjGrE+TG2m3KF4anAn7E4UCyeA52bROVOdGpeUQtim2AnK0WK7u8eR98+q/8wBwS6mQJtyNMsvsUXMt8smni9y0qGZW5JZzHMmjK1CxTwZdVG88OGj8ByX0RwkG5pV6ZHwN/A0RM1RXGp3S3SkPKubeOVacqefl+eVm07AOf0un7eEjAahGDJKyyT4bQPfUV+jTuDN3qDGXETo6dFY1aJVi+SybSrNTBRl95KBEmZUeLYrk8cGm1gEKIrXcmaSrdRGUYIjModBEykPSqiTqNUVpfhKu/XX3U3FfL1lVXxpV17wo8wXv6LvZ0sSj0Q5aEEOEVf8NSLmfreyfnO0POxWcfTANDENIDBo2v2SjbRhQN3tLDmpsa/6rpZg0fB+IcKgDxfkaCWtWFfLbqKFQFBXVqK1OSFy3vT9WZiB1oshbRGeWL0w68wsgs1AviUAOcJ7/MdbtjDFprdi6vPDErKbd24RCkCKnmnSpVaMtcrh9MnLccsCu8GdxO1L1wa2
 jWPfqcVm
 NuxVnXueR6s2yCk9OfD6f2pDfwY7xuEtERWSCu1V+GtQ515Hn2EPNQYLWZ0J03im9QSLTP0vq06guCbhhgzml1liCYYiOtvbF7ylXLc1AP+W9I7G5k+2/rShBCkC6vpCOcP9uZY2nLXJS5YqLRrK7wQWACBcnSZNKEUHwyP4wo+tBX3llxRoyeUVjX363R7MgXLdvwWbeCDwnWi0YGcD89po2/W8QpQCoWlxbn4vF4B83UCBuj/OhHMZHEkECGLrbh0LFjCNpUUMvk4xQ/JofI/Ijyr0cHHtoq0Xs4yiGd0OzGhhnDJVL382WO/iiTN685CdBhFicMgOPFLEDnEfIZptMTDUQih2f/5oMijaNtkp1fkwWjMJGIvVPMjd3yKIuUVoXoNE68//fJvXxv5XixeRKBUIlcqpFMUfVnnkDD/g/5qWmWl9TLeGuPAlt+iDkLjz7SsJVTK6E+yazaPPZX5mm82qoPI/HEh72LRYqNtN/TBxAANeLIbl5lY3MxC8ZQfakG+08WrDaYDQJw6Fzdor/XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 11:58:27AM -0400, Michael S. Tsirkin wrote:
> On Tue, May 12, 2026 at 11:56:02AM -0400, Gregory Price wrote:
> > On Mon, May 11, 2026 at 05:03:35AM -0400, Michael S. Tsirkin wrote:
> > > When two buddy pages merge in __free_one_page(), preserve
> > > PG_zeroed on the merged page only if both buddies have the
> > > flag set.  Otherwise clear it.
> > > 
> > > The merged page would inherit PG_zeroed, and a later __GFP_ZERO
> > > allocation would skip zeroing stale data in the non-zero half.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Assisted-by: Claude:claude-opus-4-6
> > > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > > ---
> > >  mm/page_alloc.c | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index bd3b909cacdf..d70c9ba6b329 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
> > >  	unsigned long buddy_pfn = 0;
> > >  	unsigned long combined_pfn;
> > >  	struct page *buddy;
> > > +	bool buddy_zeroed;
> > > +	bool page_zeroed;
> > 
> > If you want to play some code golf, i think you can get away with a
> > single bool here:
> > 
> >     bool zeroed;
> >     zeroed = PageZeroed(buddy);
> >     zeroed &= PageZeroed(page);
> > 
> >     if (zeroed)
> >         __SetPageZeroed(page);
> > 
> > ~Gregory
> 
> Does it matter? It makes my head hurt.
>

Less code generally means less bugs, but this is more style nits than
anything.  Either way

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

