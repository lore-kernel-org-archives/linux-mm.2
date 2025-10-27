Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB32CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3747780074; Mon, 27 Oct 2025 12:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C788000A; Mon, 27 Oct 2025 12:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE3880074; Mon, 27 Oct 2025 12:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0561A8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:38:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C09EC56C56
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:38:54 +0000 (UTC)
X-FDA: 84044453388.19.44DBD1D
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8A0C180013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:38:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VSIRJ8LZ;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761583133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2HGwzd/4lzqDYF3XkN+FOghRP60HTqO9KJmTXVpNDU=;
	b=CfRpPXpKOSEVu6D5ZGNlEUfwFNymrGODm8YHVY37aXY6z734hJASPu3RHRr4MiQ73cEoRt
	zBc9IU9JgU7HCWYdZP4m3jJZIYPf/pxtR6h2gji8nVDagrLFIZ8G0zR5UWfOJxXtsQWvyn
	6lV/Pn+55Fn72p5t2BxzSTBoMpmmAb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761583133; a=rsa-sha256;
	cv=none;
	b=RbAe/CJId60IQof9mnstLIEmfIlhz+zfQevOotONsGUmlNRwKe13nELOx1YigD/ejki478
	Vc+oGHPashDQC6XZ2gVLhDn5Ulxp+i3/A/2F2n12CaUSD6lBpll53U+cojTQp8md+0Jjc7
	1h/UEZ29J058/gKk3YE/cxGS2zuMjgs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VSIRJ8LZ;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-89ec3d9c773so521581185a.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761583132; x=1762187932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f2HGwzd/4lzqDYF3XkN+FOghRP60HTqO9KJmTXVpNDU=;
        b=VSIRJ8LZJZbuXWmAWAQZRFHjPCq02p8yx1mRsMhrSp76OeWkEifiXM0vFR8wvuQy+D
         zwySwbPPW0XbfN8cpWQAmrYoILKBmHHKZ6sicAwFNkfx1Sy+E9DhquDhkIQHYNXA35hB
         k6YyK38VQ+bhyYLO9hxC0/GSBpGjjfJDYEKbgaNCEXwJTmisE9YYPpesSayZ07bL/UvG
         bcXgFTo2fC9udSCFG0vnP/0LZXpCOjUfWOqZSn/nP+05oiKW4i6mVvo6RKGEkZOpS1tb
         v1Yv/WjinCauXJh2xgIG9BUXbZUFXKnlhfJjX7MoA1fDSamVbhkeJJtVZn2gvk/HoxLH
         3Nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583132; x=1762187932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2HGwzd/4lzqDYF3XkN+FOghRP60HTqO9KJmTXVpNDU=;
        b=qUf/GpCr36CK5uId2ZGliWahoLyskbTcp6wKLgA4MlV174gInJbra8ehDv3eDOeLMZ
         0VKf3O4dKmH1LWjsi9N6fQkF7XClHd+BKyypeTaKup/sDvgygMVt/t6AHY6mjJwlWL3b
         qQsvM2dFG6jai00Qdb9ON3KnT7f9IlsKZ8iteN62fkmDtxTzr9vHi9IqqGzFupigmMSY
         pzl6zKm5rJ4TNSY4BKp8eZCtu2Cz5La74ApUiKVINPqaqJM/cjpiMFdvl6Kgp9pDvS5v
         6lz6nzRddnRW9hS8e9gS9X/b8WJM2sId7Z1hhDTMuUOMjnhOPYH8XOW2S1DQQDn6fraC
         4IKw==
X-Forwarded-Encrypted: i=1; AJvYcCV/nvt/MIfMXdPhKV+rKFNTzAQrCyDy2yNy+IfVz10CSQpVbPd+0/xT+mJ8p8+XFDnTf4lsTHja4Q==@kvack.org
X-Gm-Message-State: AOJu0YwMcpVAKSlpxpJVG6DB2MEEISMTO+Gcpwie5I759LD8+wbbJAo0
	5GCDNs+cZqkzrlrbVZhdLY3E+qKZMu5HXAkWPmDHyTUg3Ss6OXWVDs+xhjn+spzSKPo=
X-Gm-Gg: ASbGncvny2FX29r5VmvylvOmF3OPuEkhxsBt8ECLORmEh2Zc5kgp3PsKVtx+gYnml24
	qSrwOseKabTfzyDA2x+LOFf+bbzSbsCJVIabOMaHt4VG6x8siJAG7Ks6ItRQuUNvZfH+BN7AcjI
	XNGPzFvbS5e+qCkVkHfBNEZFFfbk8WX/88qmTeQRdpyfjQOdg7hWlFKnUr/UW/AStLhTdYxpzp2
	5bqQUUvwfsE8+io/F9gCm3Ccpt0ugClevBjswp19PIMK4uBkCFuBfulNHxm/Rph3MYiCgd/Dy6u
	CZ/UpAl1sDxU/EIwFePR1spLlEYPzqqeM5JD3GP/lZThAqxUuWnVHDW1FklkrUGNK17faQeHJcv
	Du6uGs6MZMYblECMTyCHe47UCT1CLYyuzC7J5HJmXJnmwx3G7ZeyScoPtIWWWYbh3ypw+IBQx80
	1zQe8Vi7oIXwG+SH00CWKfjfNCpeAxf3OX/LzTu1G7k+l53OAyOJG0+NZwjqd6ENH/uAdSfg==
X-Google-Smtp-Source: AGHT+IE8OFT35MTx0jxBdZigqHGpIP25NqCfl0+l6c8fCefLdIH0hfSup7UdNhOGnYzqPJc4qxyLmA==
X-Received: by 2002:a05:620a:711c:b0:892:636a:5675 with SMTP id af79cd13be357-8a6f704a25amr58519385a.58.1761583131221;
        Mon, 27 Oct 2025 09:38:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25798afesm626595985a.37.2025.10.27.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 09:38:50 -0700 (PDT)
Date: Mon, 27 Oct 2025 12:38:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aP-gGKMa6Rcw6ZWH@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
X-Rspamd-Server: rspam05
X-Stat-Signature: h84h1hfgejhpcrmccc3w5ss753dm4n5k
X-Rspam-User: 
X-Rspamd-Queue-Id: D8A0C180013
X-HE-Tag: 1761583132-114686
X-HE-Meta: U2FsdGVkX1885JS6ME0cl/402cojeHFTsoNS8ptApZFH8Lj0Du8Qc7X9BdPNn8DlGRRrjonFKFJxYBSjIQRz4Kx3vWA9hjzKtdl3ZxQM2j7NDPLmwbl9ALlU9G84SHIkHjriKtp9m0u8ynNc0Vl0Zu78Ubqkvo+a+nQbcRathOehp5VASScrb9GRIXyohSsr/NYbJ23dKTjJsJCLu3D16nuK3qz5VINMd75KP9+nR5y9AxgER7Did4OFAdSp2dygMGQ6/3HWc55cgK1XZIE8oX1/FVssbFs0PkMXpiExkWEVqXPYtZ1RbDimQ/WhE6Nd2vYcf6W5/G921RXcrwc3Un64KhC3jspzq4GFIBa/Y9vlmp/LECXFM30xI7A6uiytRMv2vdEhvoXbFlmBBy6b+LZw/vUtfxDW6sjEMGhYRDScg5M773UjdAyJCCUF4b7CIK28q5WricxpGwi5Fw03hNJja2k0oqtJpF1IsG1cizSdFc+lGdxIjMqkHtpCcsHoEQt3EU2hd6oRvhCCqfDweYUnBB5mKfacEjHhd41bsXpVQiTIcDLogM99u4nDV3w+65Jms/3+SLtPf5ggzWs15b+hEULwfHy+LUb3o5bldNV5jHc1v3a0/X4wAdc4pCpUQELt3HtjjxZDPYhizpCEojVjL6l01YoRdBdxTkvRwofL4JCALw5whIqInf+Qo6M4NMagelwIUQZiSPK0ltk83ccLdr3Jb7CMGGp804wmYd3G46hUKmK0VZsjA97j3U10kd6WOfiXKP8nOOHVqkuvPiSq64tKWyj4drhxhkfHAnGwH5ZSfNINskuTJajDLANwllzvU45xOUpTqY5SFDpGQK61qTH4L91t3r+Wadzu9LGXGlA1IaltZdKrc74LKTSbyAUu30i+sJbfacBcsn+5N6bTDu53WutAt2BV67ySXZeeLUL5QE5RmXqvLkhO4PpGvLxrcXpRjxqHJfH1IKY
 Yt/2vmG0
 DXiYpKlu6YVa+cenHikRfkf2+qjuY7TRL/yLiKr2RtlYiA6dv0xeRJPDcOQ+9h1qjHAP0xtTcckQjiVDEoZ74M937V+LjwQrUG9ElLuhJAwsKJpDU4DUcFJJcRuIJ0y2ds2pn8oBNjJPrtj3tJ3hxBXpCRKxoEVWYLr/Ha+l1jW640SDmK7aJP3r9tkQcUQFXh4CUxiORf8N79nFw6nkOIQovC77nSsLldm5bgYwZomFeLV82QNJxU8TmXaR0AfzkC4SNMOGr25rbWNPAoVSMpO7aBomUcNqSScNuvZJTNNxVPLJPdTx8LzvB/QkDvGp3d9t4eQv4ArLInyhhirlVk9fSSC6qy4onO3r4MC9xGWMkDLJ6DSlSx/YGcrqi2ArT5JaPR24KHYKJAFEgZ/hAIQrPsl2bhzpaIceRWJOiVtHTfierms63oLp8hHEXmyISzlzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:26:54PM +0000, Lorenzo Stoakes wrote:
> On Mon, Oct 27, 2025 at 01:11:46PM -0300, Jason Gunthorpe wrote:
> > On Fri, Oct 24, 2025 at 04:37:18PM -0400, Gregory Price wrote:
> > > On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
> > > > On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
> > > >
> > > > So maybe actually that isn't too bad of an idea...
> > > >
> > > > Could also be
> > > >
> > > > nonpresent_or_swap_t but that's kinda icky...
> > >
> > > clearly we need:
> > >
> > > union {
> > > 	swp_entry_t swap;
> > > 	nonpresent_entry_t np;
> > > 	pony_entry_t pony;
> > > 	plum_emtry_t beer;
> > > } leaf_entry_t;
> 
> I think Greg meant this as a joke [correct me if wrong] :) that was my
> impression anyway (see original end of email...)
>
> I like leaf_entry_t name-wise.
> 
> I don't love the union.
>

The union was definitely a joke - see `plum_entry_t beer`

There definitely shouldn't be enough extensions to warrant a union here,
that seems like negative value.

leaf_entry_t naming replacing swp_entry_t seems reasonable since that's
basically all swp_entry_t is in its current form - even according to the
this set's cover letter:

```
  There's an established convention in the kernel that we treat leaf page
  tables (so far at the PTE, PMD level) as containing 'swap entries' should
  they be neither empty (i.e. p**_none() evaluating true) nor present
  (i.e. p**_present() evaluating true).
```

~Gregory

