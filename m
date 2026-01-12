Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2766C9EC90
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D486B0088; Mon, 12 Jan 2026 08:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2212C6B0089; Mon, 12 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123F96B008A; Mon, 12 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 044546B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:45:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A08BC1AC4A1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:45:15 +0000 (UTC)
X-FDA: 84323433390.29.F861CBC
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0E501C0015
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:45:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=A9KE1jIP;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768225513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQVWjYpPCtwp4dXF89g7hQK6KDriflVp74tvOjx72Jc=;
	b=j/WGcgVqBiAtUkR8x4rGlVcMYV7Q0IoPNOqW2FYcVOcU8F5MX3lrKv/rkQsA7qKaRzNTCU
	Ih7n1EX8LYsFx1fi1LPBbLo3RROjehsf4Zk6Br7JjPe9hum5kNIJFMvxB0fIQC8DePnWji
	2hGZm46Fw9BNDYxoZ/r1Vr8Hvz1D+4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768225513; a=rsa-sha256;
	cv=none;
	b=saXtICT12gOv5qEbTp/2+MFFIqVGvqBIsCiIDRMJOh4uf7vTYy34jBW3yeNYuiHuDK0IWf
	FSL9xJH0zl4XaqOcavrhfggsfElJGSq16KEbtV4uYvrI3BXCLgHT8wtv/0Gagdelgr5aB9
	KOCrBaz7/6ISHjulJRPTMjZMIFFIArU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=A9KE1jIP;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ffb41c1efaso39446321cf.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768225513; x=1768830313; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oQVWjYpPCtwp4dXF89g7hQK6KDriflVp74tvOjx72Jc=;
        b=A9KE1jIPC09kD6eaX+4xwwgeSxjp0yUAeb/3TLwv5+KH+ziCAb2QIu3FoRtr5IqmL0
         9tz8A5FgR59zz0F6tiaMu+SmHtwOpbgqBb1B+8zJHVdEVBTspdFBIe2MhdLo8IrRcglO
         10G+zPWELUlGgVE0U1YXUTGHetC7k6ion5G6hXVGmoxbPW5BBLzWGn+zfGofRm4aTTwa
         oL3BryN/lm9WaC034G9xMD8YuXIKn+93y7S11wwHMolp32dz2Rh3778ux4exrtCPZJoh
         oSgxIcKOgwWg8IGM0wcLNqCsBwuVjvQfMq+VO11drZYo+6tse1L73OBqT/l6p0g2+opB
         6IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225513; x=1768830313;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQVWjYpPCtwp4dXF89g7hQK6KDriflVp74tvOjx72Jc=;
        b=b3zUJFcUmsKcG1bg3DwepXCFZd2MnUqT8ae2q2iBRIbTiapV1T63lOCEazounb90os
         crOK4ygp0F7Wpp5dtlOoe1dNzZRfkxqReTTzEX8aJIOJeugX2P3kvdehbZpMI1Ix7PXh
         g5wlRhu1/rBOT2TlkfrAPWHedEPzHiho6AHqqr0nE9yB5H+m6TM2OAK43Uu9bVaznsmk
         7fhtL1ZAhO1cZXnY2ChGTUUDrQlVQ3c2Hgbqrk8d3mqQHhtmF/lpguXXXWnJwSmGc1J7
         Kp8mryQpeUNqOjTjJX2ABqy6xCwyq4VYBiXL058U0qK23fwSS1uS1bmhBHh9rTnbQv4E
         FuuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEX4XqWCRyxynK0hpKhEMvsZmKltMYaLUa56LqvBO/ZVmg7fBbl80bUeIG2MNiWTKfbMFH+1LIzA==@kvack.org
X-Gm-Message-State: AOJu0Yy/TeAwr1+DjwnfqGjLVVREzdzgwl6S+SSttSnEVxC83VIR+t//
	pzOv4TBEIWOqkm8+M8C6QTKUe3pDcNc1jy5nv5nr5Bb0tZXpv3QziTY+v0J2UUNv+8g=
X-Gm-Gg: AY/fxX7VUVC9uKKe+fTf6K9Qb4I0hzQe/x5Tosdj+cGRJC34DQjGw3wjlkBrJu4MiQl
	e7qzemDebPLyPHuwMQI/YVhIuFCQ8ru8T4QJRmLz0yX9T5ukTiRhaiV7UAFDIogULTNel2eAlQh
	CTESpHBQrRZTzRC770sxvnUfjA9KAXXgaaTUSHlwOFt5fAsQme+eZFC/l22Hulq1CSiE1OOWSO2
	rt1sGGklicQ9KHSlP7hEXaJtShOkjR0lxvlg99eMLugLZoueO1xK5bmyvT0cGIub4MzL4cJ1shd
	LJp3T9uLgIRIFGsNY+QpojrYw7SdINlg3alw0wtqi49a7e8zo0Z9833QR5Ws3wsnJBWhyJX1+TA
	owQDroSb68LNFtNDNl9ceG06Xfa5WkLx78fMRHGQ0+lF8tMLpVJTZr4WHEoRNynniby9siuMwnX
	09eZp1xoo1Ptzi1dOAgLxUjKJINpo16Q9lw74zH7MkYDXxnLPlb3oOw4dF/Fjsq808yrnWQplxn
	E53nA==
X-Google-Smtp-Source: AGHT+IG20+wZaR0cdbZzmqo1CbORIU0XkpxQP0kdASvCc3hNxGR2kbLwFGbi9bRoyfQYpJE34s/36Q==
X-Received: by 2002:ac8:7f4e:0:b0:4ed:6803:6189 with SMTP id d75a77b69052e-4ffb49998dfmr285683391cf.53.1768225512643;
        Mon, 12 Jan 2026 05:45:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e36232sm124159891cf.22.2026.01.12.05.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:45:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfIEI-00000003Q1m-3fo1;
	Mon, 12 Jan 2026 09:45:10 -0400
Date: Mon, 12 Jan 2026 09:45:10 -0400
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
Message-ID: <20260112134510.GC745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0E501C0015
X-Rspam-User: 
X-Stat-Signature: s8hs9wz33u1gp5kfwsq88ai46bns1ukp
X-HE-Tag: 1768225513-398280
X-HE-Meta: U2FsdGVkX18SjeRUk09WabsmeH1wr6tG9TTjDKI3WfnSPoreXoTeg/PCk/PbBtTDUDxgZvgpgvqKy5aacTumx6+xtONF2KPqyYWcOm53EmC7esH6WloO4gjkBRtT6xvjGQiR4H/CAwCWnbxyR9lE3dWLmObE+XObJOXUdLtJz3hP6f2rmMZ1l/WcFDssggsjkUcw7REU/jBebMEFiPBZbzzsL5asfSrWXvNc5jjiHXviJWjB/09Vn1vI5xSHj34K6JSKYVRC030rfGRK4IWE94QWDseQ5bU1rf7Fgoc7sJaCoirEVdoMD9839Wyv+7qv1cKjlyT3FT0f4EgR5eMQLMUwskbX7Frkq/MAUR51hzIV59/t89I31vmK09a/nbvBMq+qIcbYMRwyDsYZGYERosqnliKvMS2chBB0ygWi5yiu82BMQwgFAZecKM4AbN3o/BmMZkeau/z1GEByxTYU3HPoec8KgwlilrZXYE3wwt74Y7m5MdhKLzhESzqsWuOOZ77uIukxY/xdFOtT8k+6c6pQIGMPQI2ERN65wgmMLdvNR8ChertQeaO8tCNRSxNkUIV5J+TcmzpFJoPIYkYYnx0DqSnAE8wCChEX10JE3tvn5pDVeNSjNLcRQbrKFW9FcExcNuSHKSyyxSofSH6UviCsMjZ3EgLspPbbaNkwoBha2KgRbts/ljKRN8/sKIHw9T9c+MNkCHEOwKdavyha6ICYe+mAx+cmGeQsf3Zzghn+6ZolzeZU4O3fFvqxhzBYB01yDMdWpIk4OiB/p6XDAZ5OVzISStuOY6jRlfPVdGNJ25J89eUmFegrhfHBIYX5pHoRPt6G585JpRknjP4jf6YSQbfWwNCmrL6TMVDSwAEd+h8ImbKrcsjvvL/rmyWHdTBQdE/u7wol0WKF2vqFu6hdQ7vWBDmVLPdDVPbRqgaSgE+tTaz6bItnNyouTmP0kWKpH/nZaG1+hZnZyMn
 lnvl3A/j
 jECk10QD1Yp6/PXDH16q2K/qzBqSHDz0PdGydSrg4Bzucbl8IE80b3QTxcql3bnHH6EQ1YL5pjoJLIBCvnufFVDepc7IJGm30at+/QBe2W1ZyTmKFiRiNhPOacCs0RT4OuKXtT8iLuzcLjQZP9hHOPInngKdZXsA6etzX2PLfJ9uDLeBPQZwiREnaNBRHcLiI1vXfmnGHFbSXunq1lQbPTlkG9Z0ttScKpAc+VfyOXEvbWO7Cn9SHTBOwuyo4k5QjhHiusov+TOBkyWwdKo62ZctBgqUw3H+K8LhAeB3aRPh2Z2ILpqkkYgXrNFTJ/W+dOjvZ+aMmFH+RT5b16VwCCY5uOUHJW5bOamyOISNXylCriMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 07:51:01PM -0500, Zi Yan wrote:
> On 11 Jan 2026, at 19:19, Balbir Singh wrote:
> 
> > On 1/12/26 08:35, Matthew Wilcox wrote:
> >> On Sun, Jan 11, 2026 at 09:55:40PM +0100, Francois Dugast wrote:
> >>> The core MM splits the folio before calling folio_free, restoring the
> >>> zone pages associated with the folio to an initialized state (e.g.,
> >>> non-compound, pgmap valid, etc...). The order argument represents the
> >>> folio’s order prior to the split which can be used driver side to know
> >>> how many pages are being freed.
> >>
> >> This really feels like the wrong way to fix this problem.
> >>
> 
> Hi Matthew,
> 
> I think the wording is confusing, since the actual issue is that:
> 
> 1. zone_device_page_init() calls prep_compound_page() to form a large folio,
> 2. but free_zone_device_folio() never reverse the course,
> 3. the undo of prep_compound_page() in free_zone_device_folio() needs to
>    be done before driver callback ->folio_free(), since once ->folio_free()
>    is called, the folio can be reallocated immediately,
> 4. after the undo of prep_compound_page(), folio_order() can no longer provide
>    the original order information, thus, folio_free() needs that for proper
>    device side ref manipulation.

There is something wrong with the driver if the "folio can be
reallocated immediately".

The flow generally expects there to be a driver allocator linked to
folio_free()

1) Allocator finds free memory
2) zone_device_page_init() allocates the memory and makes refcount=1
3) __folio_put() knows the recount 0.
4) free_zone_device_folio() calls folio_free(), but it doesn't
   actually need to undo prep_compound_page() because *NOTHING* can
   use the page pointer at this point.
5) Driver puts the memory back into the allocator and now #1 can
   happen. It knows how much memory to put back because folio->order
   is valid from #2
6) #1 happens again, then #2 happens again and the folio is in the
   right state for use. The successor #2 fully undoes the work of the
   predecessor #2.

If you have races where #1 can happen immediately after #3 then the
driver design is fundamentally broken and passing around order isn't
going to help anything.

If the allocator is using the struct page memory then step #5 should
also clean up the struct page with the allocator data before returning
it to the allocator.

I vaugely remember talking about this before in the context of the Xe
driver.. You can't just take an existing VRAM allocator and layer it
on top of the folios and have it broadly ignore the folio_free
callback.

Jsaon

