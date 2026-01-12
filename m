Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705A3CF45C2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2F06B0005; Mon, 12 Jan 2026 13:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60E96B0088; Mon, 12 Jan 2026 13:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F746B0089; Mon, 12 Jan 2026 13:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 943D46B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:25:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D04C13BFCC
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:25:04 +0000 (UTC)
X-FDA: 84324138528.03.52B6C8B
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F7F24000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:25:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OSdTik5r;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242302; a=rsa-sha256;
	cv=none;
	b=42hIm9C1Xg0x6atGhrXCWZ2J8KQPLG2cM8ibT4yftAz5lYWqjiPZ9Ylwh1ncyIuYDJpMoX
	E96lVnC0HARsXqu+WyQDJSFGuW7xLtbLOCkrV6eOm5N8lOuJFLAri150G2EheNkqSKCiwp
	PhIGEVas7m3H9S/CrzrXG6r9/6xCC+c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OSdTik5r;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdD8MqriJAO2uyiGLSo7KkiIHx3VWLqLd6aNoF+yCm8=;
	b=zqA2CbJQC2H8ziDOqilb0m1/F3GAglSDkKtCqDhYVtK03KU2nqjU9ec7iBspwan//LGiVB
	bR5HPQX82YgO2v/KEOrmA124+/z5raElkJDQwp/gq9Y0+NzQjMsbf68Iajqmsq2zqEd+E8
	ebxnmrDMbyTE8yQn42eu23sp4AMGW0M=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a379ca088so73962656d6.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768242301; x=1768847101; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jdD8MqriJAO2uyiGLSo7KkiIHx3VWLqLd6aNoF+yCm8=;
        b=OSdTik5rBigSOnogOEWCzDlUkuM1fgb9ghkGgiLpNZ8+QmTnZbFapH2A+X6MZCdJOS
         g2SqTtiCrpABbnZ8lNXX3trkV2/JU+OoEeAO1WadM47ldGhGXlCToKKVjUtzznmoCge6
         kw3ly1q9ilaywR8pO72OdTRbhXHVUs365uVmH1eA+jbms3MM/XXEuTWLVj1P4o5I/ohk
         mSmJHZOPYSnGCodgznysp5plHPyv8MugY24kjGYX0vX3e8W/xl8yzmgXMwMYK7eA/lHk
         htFY57iIr4u/D+BDFeSx6EAr996jNnTbpiJ/d0zeRu3OJqNq5DAuTrZY0MJ+ACwdEi2t
         RtWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242301; x=1768847101;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdD8MqriJAO2uyiGLSo7KkiIHx3VWLqLd6aNoF+yCm8=;
        b=mGHqFpmaqG6f1EiSbhL3CUqG3RhfsvgWPINrwRp3cCadtQdRGU61yFO7+BO/fZaoeu
         LdiGLevEHeTyJoeSZdC0Cdzz4Ho0lCmGJRyytyFylLM2FtBT4WlcvWeOWhHkner5RCSp
         VKVgm9OGylb/t7c+87uklmCffTZiAw7RCJ7K63cYW8mDHdxgx/j+66Nj9uLkufa+V8T4
         Ij7DX++uLKcbLEclq7q2xw1/n4OZqThon08lceG3B6GCSs8fDxUjadg1YTnrztLbMcHe
         VqeR2KE8HaXfRpxCpUpvT+GxO7nC+HAHvjT/pcNdj8HcYaszFtWMaHp/xMpM69xy6X3Y
         TOzA==
X-Forwarded-Encrypted: i=1; AJvYcCV/Cn9WfZ71FKRq2O/16M8KNbUJRxuCkQD/zic46s3jYX/1xxiPrl7uShUStiybXONV/V722EQqFQ==@kvack.org
X-Gm-Message-State: AOJu0YwkBcNYyBI6rlWPtUyFpaHn3WyWDScCWddBOA6GOnuHszvlLErC
	m+JyEzL8z4ydeIdNAFE2SHMuiy3piPMwDyUcWFKLjw9KzH51eliQdIc1I0V3VPFaFjQ=
X-Gm-Gg: AY/fxX6TuVLyrynGzushWALRD5EgQaBTxLJtWmlbN7I39LYnGNrnfVL/Pi6c3Ogp3a+
	xWyIAvPKTlvVFBjBnwuWjrTdnp8EXAPjlE4cnU3DhjVWLdqV99pRcHi/2hYFRR9VtQ2AuYhK5zz
	xakARfXDuz7fXYw14cKpJRjxPYcTqTCdDtELlIY/k71My4HhWiADLCOmuIaXyvVLD58CAwFXIZc
	3oCQpyjNLk+109S9/zefi6UQv1zHQFeOm0xqMKORgwB//oAl83gxxx0rHpyf3TBkYJQloKxafuq
	ztN8a4qJ5FJjj4R0+UnWkrHvLbZwiCLv7cEs3TeorBOEH+xXrjRySEjyE3Tiymp47WTLu8YIjkZ
	y04GjRQpzhxlJrwVkS/qF3PeNe0xUc2rKzDCZfu3E1O3iPHhoskMccVu20aAWC2rFMfm+HOYih8
	GAxGhc+SCSOMMp71SgKkp/7UCVOFl4eXTM0CpNnEMDEf7Xcmawj5I52bFz7/GAJ9uYMPM=
X-Google-Smtp-Source: AGHT+IGn2SBiEVfPnYP4nrga1XlmOOc9x/h3J7lqU+usVoOUoaNofJJs2v26tTONjDwmwZ1AsmIeFg==
X-Received: by 2002:a05:6214:428e:b0:88e:9f73:2c08 with SMTP id 6a1803df08f44-89084179da3mr258471116d6.5.1768242300986;
        Mon, 12 Jan 2026 10:25:00 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce985sm138366276d6.11.2026.01.12.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:25:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfMb6-00000003SfZ-05E0;
	Mon, 12 Jan 2026 14:25:00 -0400
Date: Mon, 12 Jan 2026 14:25:00 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112182500.GI745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
 <20260112165001.GG745888@ziepe.ca>
 <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
X-Rspamd-Queue-Id: 1F7F24000A
X-Rspamd-Server: rspam06
X-Stat-Signature: hzosbfkhc9tzi5ijcy8tq6a183wm9bqo
X-Rspam-User: 
X-HE-Tag: 1768242301-846202
X-HE-Meta: U2FsdGVkX1/cwpn1hHn1c28mprnmdoly10hg2ODuxcu+BgddC1cJN+BL9w88kEsJM+QeshTcOTi+g5gAg2iWzlTKfi2e2bCPLY5LaOIU52de+q0lUhv8+DmOpgP3MzR9h4p/7QXrLwo8vN2xB4VwxsJMkAqqLHGguKcAoYW7Nw6htKC65MS66Irgff/KEupHjM/OW4mf9UZ57br2JoKmQ66skgLuFPppUdgmSISAjUp6EsEGXcNDJGtuh/RAkGz12glLSpsZeqcKgTqkox30NRz3/FDsvw8THWSqGW/cER5qgFGDcZyDg0rKg9VMoFZAMmgIZUgKNgYL+bhlAyolfCjbY0YChJTrzJKAquYAPjuvv+ElL2huLRoBvKayzWE1tu6SjJqdGD3ta1yejgJ/nyfDn6oFqHSQ5Y342Yuw5l8GSEij+BWByr5c3s0VSydMYjaD++5s75lvESAqm6y5K3i/kbUzXM+nNTLnIsmcd2Ev7TV3N44A3+IgrFgeWDN2cQzRfIzv0dHEG3EvSskeMIQ8GgM7C04fEbXf99NYmrjWBVB1JONFXB9HnzU8bPQC6R/iH7p0eG6eCys0cuzr7epb3mnxXJCNZnIwq1rfdA+LU+7GYZ98nT14NOvFu+vhLAwTsrKrOcttUwc5/n8ehWEBjGNL+v7xsfTVFTVGF2uZsZHjAt4jMzXVtbhV3XYVZRAgGBTMh8/TwFkpatg7R4AQDCWB1XoeHo38Yk3z/UithYibaPfChD5M0dUgGZlbNVt3PPdld3eHwSqfmStplEvihYPN0HrLmPGi5HUuvJZ2qBbGEfYUQuTqPmiStctyNKo9uVvqP/VL9iX7uvIPYHBnxO+nyiLWOGlS+LE2J9aV34sPwpwtcN3eOgGJ35KuFtBEc3THmcBNhmg29EneQTlP5Groa6CCMX835K1iDK3/PVY3SJgxe4zoxSr7HeRYqKXkCWiiW7wvdEbQnNN
 LcWl6rlM
 8UyzNQozdh5a1T4ts/jX9PXIiJ1tUSSYjppXDaM1/LDFDm3Mj7E/FK3qkkBp7Zyzq8MG/XBoWR0a+mAf2EOKBF1KA8aOvmMONMjFUwdFQ3UO1jpHF7406YQVIOJ8K3fmXOtCQ1PaeUgSo8rhZYd1WNrsYGpYVqrBKL1+/AunTdKD7onLa9h6iEDHg1qCKrPOVb5k7/b78WRllVDP7Lf/SGVVdqZqy2oep0qmiDc7hDatPMaDmFRX1pRRJirM1/iXY8yqxHK2ZTrPCQZ2zcBGqRnYJJGs0M+oxWUgSGrVeS52ndJPk/6YzqicF2HIaw1tZuIySn5G6rGaSbWb++hVC0xlP0OMEKHLvxCvG3ExJH5kqxo1NMyJr/HTzi2JOl6JmRlQd95YZ0sTEM2mDtQbRQ9Qg7m0/jjx1rQmeF6+si4VUXbeh/Mu+YCkyb2mP1qoXgoQ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 12:46:57PM -0500, Zi Yan wrote:
> On 12 Jan 2026, at 11:50, Jason Gunthorpe wrote:
> 
> > On Mon, Jan 12, 2026 at 11:31:04AM -0500, Zi Yan wrote:
> >>> folio_free()
> >>>
> >>> 1) Allocator finds free memory
> >>> 2) zone_device_page_init() allocates the memory and makes refcount=1
> >>> 3) __folio_put() knows the recount 0.
> >>> 4) free_zone_device_folio() calls folio_free(), but it doesn't
> >>>    actually need to undo prep_compound_page() because *NOTHING* can
> >>>    use the page pointer at this point.
> >>> 5) Driver puts the memory back into the allocator and now #1 can
> >>>    happen. It knows how much memory to put back because folio->order
> >>>    is valid from #2
> >>> 6) #1 happens again, then #2 happens again and the folio is in the
> >>>    right state for use. The successor #2 fully undoes the work of the
> >>>    predecessor #2.
> >>
> >> But how can a successor #2 undo the work if the second #1 only allocates
> >> half of the original folio? For example, an order-9 at PFN 0 is
> >> allocated and freed, then an order-8 at PFN 0 is allocated and another
> >> order-8 at PFN 256 is allocated. How can two #2s undo the same order-9
> >> without corrupting each other’s data?
> >
> > What do you mean? The fundamental rule is you can't read the folio or
> > the order outside folio_free once it's refcount reaches 0.
> 
> There is no such a rule. In core MM, folio_split(), which splits a high
> order folio to low order ones, freezes the folio (turning refcount to 0)
> and manipulates the folio order and all tail pages compound_head to
> restructure the folio.

That's different, I am talking about reaching 0 because it has been
freed, meaning there are no external pointers to it.

Further, when a page is frozen page_ref_freeze() takes in the number
of references the caller has ownership over and it doesn't succeed if
there are stray references elsewhere.

This is very important because the entire operating model of split
only works if it has exclusive locks over all the valid pointers into
that page.

Spurious refcount failures concurrent with split cannot be allowed.

I don't see how pointing at __folio_freeze_and_split_unmapped() can
justify this series.

> Your fundamental rule breaks this.  Allowing compound information
> to stay after a folio is freed means you cannot tell whether a folio
> is under split or freed.

You can't refcount a folio out of nothing. It has to come from a
memory location that already is holding a refcount, and then you can
incr it.

For example lockless GUP fast will read the PTE, adjust to the head
page, attempt to incr it, then recheck the PTE.

If there are races then sure maybe the PTE will point to a stray tail
page that refers to an already allocated head page, but the re-check
of the PTE wille exclude this. The refcount system already has to
tolerate spurious refcount incrs because of GUP fast.

Nothing should be looking at order and refcount to try to guess if
concurrent split is happening!!

Jason

