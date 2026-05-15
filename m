Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057D2CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678D56B008C; Fri, 15 May 2026 11:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650AD6B0092; Fri, 15 May 2026 11:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5678D6B0093; Fri, 15 May 2026 11:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D696B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:39:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0636D885B8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:39:27 +0000 (UTC)
X-FDA: 84770063574.19.5CFF55D
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBD771A0002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:39:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QSRRNf+T;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778859564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcnoZCj9StmYM28UVGL5OD3x4745ox3PgFdBX56PHJ8=;
	b=f3FLn2QGhWKwIDcOZh+9mu+7E4s2PWotWTuR3EjN6PJBfW0CTN31+C/4GDlgoSlvI2Wph5
	rAXTlyLVA2HK/2JshPNLoMcWoovqId2ARmT4JAWDrMLNhoLWDBDCLCvhHrLjSRIT6vrUl6
	x/L5jP/H6zeWIfW3sF19ao5vQdNbriM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778859564; a=rsa-sha256;
	cv=none;
	b=R5UJnNem1LaAM7wfvzez8tyyZTAxe17FLa+xZ4ErsdAhEvO8IF2bQ0Lf/yKHwmHBjkcMYc
	egCAD/wMkfXTssRJFxQseqt5MDxEDueeMV/7LpuSrkNGl/DY2lwT+h2SyoGYCkFdEtIZF4
	B3EPPoyZCDNokPGnDfjzK9Ku2Ha5doI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QSRRNf+T;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-911449d9d03so200525185a.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 08:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778859564; x=1779464364; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vcnoZCj9StmYM28UVGL5OD3x4745ox3PgFdBX56PHJ8=;
        b=QSRRNf+THPDuCyXMqGrnzAlS4gMCn/1LrfnsYWpJN8txaLm9DD8hpddOIntI2tRvAJ
         vEqIUh0My/xWd5s+i7kjCgm5kPElFum1UKRQ6lSLBIYZuGW9sST6nhUsQ1IvsALgdTz/
         gF8kepc6NY/6tEMeKT7GdU/kgEhs9+52erPQAStFEaKJD4SNqdF2zjKaotJdchPSC/Bo
         I+X785pNAzh5g8zR45sBNLRxNl0b//yHX5wnKJjWOSIhKmZadkt8gIwaUSIoypZPP/AT
         C+nbwH+Ufd5iaB7J7/33W6nL/2cgoLgs5QI8zbGrThxnxYBjnuOVKPOTXbNQvIQs1nCM
         vSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778859564; x=1779464364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vcnoZCj9StmYM28UVGL5OD3x4745ox3PgFdBX56PHJ8=;
        b=DFHLa1KH5uNFmn6ZLkXOkk4rRnnP/P2uLYU8bH0Xi03l2O2VbH/EE6hRqL7pZo19n5
         UXrHLiveIeRsIcipQn8UwCZZ0k4W4Jw+SSEToqA9Dl32koJKejTa3qn126VpHB2BjLKT
         p9l2rcf2fVHeU8i1oaE5K9bWFpeCubwn9iMLgeOWO+MiSzf4Ytn/RvnD3+xDRxr0PdgH
         i8/Q0anXP9z3wH60XjXejxK+JVOuGfzySozjyhF9I/Q0nYDx6IcdrzX1bPPaLNlMZgc4
         hOUcQFlSmRGnxw+SxOqW3Bpypaz2mN3IK6+OYtVasIEEoo2zk8dViTP8Qrs7vPWisqPH
         PqDA==
X-Forwarded-Encrypted: i=1; AFNElJ8UV/NtpFbQICBb6buubM7No7qNbMN8xyOZg556eVVtmYYIUXAagfAOaiFESkgwKxsBHqblfgGQAg==@kvack.org
X-Gm-Message-State: AOJu0Yxc8YxX5RfNPFiNhqVj6m1fvBiLIZlQwmuTCdKxhW3/8x0BpjTx
	Sy1SdzEq5EzzOodyLxEq0cqvvogp4nfX7MIaudVNGpibh3StfdtIBlx6HJolWmlFCMU=
X-Gm-Gg: Acq92OHF3vXToSqjFTHbUGh71VUjdhLnriXYt9DDw6mhtFtPZ+aUsdsD0tS0ta1NKQf
	a841Jcd065l9wAzofmGcsbU3CyhVN3YmkhmXkwRq6LZZOeom8z9eTpilgmMZi+Mze454I2vMDkC
	9hz97FcZPcCkEwKkgDGrtJCRg6v1Rbr2r6107ftuHX1MVmwnkrDD/JT3NKea6BTj3XdRPU2fJCK
	V4zBiNg7PWBpS29Vu5d3Xplo4I6xhL7Vcf2RYgPk4+VqfP2pQgn62ZxG2xULVBrU6h5P2DtkbE0
	IFe8zJKoV3eVeWc0gYRQzQaXsr8+C4ls2DylO6/GfIWO1gIWjO9TEN1b1lC9yZ+NVFkg9i06BAc
	t141s8j+22+JKsBD4JECBptt4wpauWoK8+M+iW9K44ICIRWYqwWVnlr93kr/O3rLNqlB9KnIFhv
	Z7H5ftMInwsCcUaovmJtd5Lj2fBY+ES/H2vfnwwQ9w0q87fvLWdJHE+eiFC46pcf0krKJL+KCIE
	bBdIKxyxP5ham6CEuBFCx27IErwmrpM0Q==
X-Received: by 2002:a05:620a:12da:b0:912:67ca:bab7 with SMTP id af79cd13be357-91267cac05amr271493385a.2.1778859563525;
        Fri, 15 May 2026 08:39:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36d137sm564275585a.1.2026.05.15.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:39:22 -0700 (PDT)
Date: Fri, 15 May 2026 11:39:20 -0400
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
Message-ID: <agc-KFwvSDxEImVt@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
 <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
 <20260514135214-mutt-send-email-mst@kernel.org>
 <agYa9s5B7OWG-kjR@gourry-fedora-PF4VCD3F>
 <20260514150750-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514150750-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBD771A0002
X-Stat-Signature: zsixwoecakeyjwfdijp9oc9poto77ngf
X-Rspam-User: 
X-HE-Tag: 1778859564-9339
X-HE-Meta: U2FsdGVkX19gRymS8p+fZ8QZ0iyox3TnCYHvjNNXAZQitzbk7nDQJEiYTUcRXMSEscXSmKNoXyF/AQNFoqCDMU89kWb9nd4Tutl6Tcu4aBDwYgkEdGb67G542iKE4ez0s6CQI+l80s2lnq9ffem2jsux92ErfvNHXQlwRFm5u1536RR5xOgfAL5uIAxFmgLxVECfWs9SvbD7o/5rvhpuu/FdwLiFMT6X1fCrYL0eEtIIpMiwSwDcWwd73jsm+BKyPMoGRlJ1zSFdLFqtpXL7qoGodtRZjuOGFZYO1DdBGAB32uP0vakNHzSh5qlyGZvOqb9weRsL19ADOcCeJ0GPiSPaUekH9Ab0qf8JGErs2x9ejAPezvEzZwd504aYkd6MrBAdvcUy3WmO3tXw7PZW1evh351cA+dwLYs8sujt7eIEkRBNIbg4bZgzWjFp2OjvNCk/g77//pUjq0gUuSogrHYFSgXz49dtR4aYVTplvUn/EzxvAMOHicia9OS4ehIOI+uLMrpjlGJtibSEMqaYF4aLJJdAsDUC1RBpnCvHSqDVijF+AYeO9xdi0Z/R3FV3amZO+O0grEHXPwOwQPiwaANUp5nbdzOdovQAJvKUHz9obLHgQXsnI6U+3RhNG9Kh8PK23o9xyuYunf60WwAtREx9vDv+PjRl1KuT05lrfsAYB59WamtE3T19V1ENzKARBbYgh7vDDpm2mzZ/15/t6yF0EOcnY2/KVBlSsbKb5odY77+Q5WlB8WI/Zd14R5StpjA9aCBoQbdyOZq4I7lTMfBOS9JbfEDLLtvyoiH/jQK1rqRsPz8fonwM8MyTjNE7xw0gJdumlxJ6Y4FEqZbtVaAscjDU1bav3tP4CLtqkpg59cvJSBgFCLj7ki5/6oXw6E/+Z1tpOjCFLZ6BROZdCSa6HDm9Ug+n3501XH5FZfWnd1eOM+d8KPBolwuYWjMsY9Y+c0hMlnfQfzHbI7r
 jUwjuvbS
 zX1E2qfNGfXD4meDkwi6rX9oYd6Yy3BMSKCiG07Xamn10LzeVMdwJzBpISCoksI9f1oYRL6qZ1lwcxkifwYDb7y/vI3T7or/MT8IQv8dtDnx5o5iIHMmjEQpbl/1aPJUwHetOysYB/yoz1BdQdotLJjUHcVR4G5Hglczw5JrEP/oLhj26IM/Nh4SgVa1jRsTe1SXlOO02cn4tkVYTMTF9xo6R4gtqU6hXTNd9p+G8yU0hWC08eWYBurYKIWMWIhh00xV97J6IeHoSeSvK8ct7hkBU//nY3y+HEPRwfBhCK07PGPDxo9aX/kUumFiBp7zOMquDzKK6jh53FAiVasvPpkVXAN1oSR2EJgyb1FTqx0LkkmwCno8frRwi8hJvtQ6KTh4zspwOsysACvztQ9p2r4dE3BpFd6kpgp6sjAbItUoFnhWWLONrgIBwnrgPjVDcdxWp2lWu/gkVe1tWa4vooRrmaNuJ6MsK5gcaKZ5yr9PcGUekHmr8kbSBhjxjoD9MKxUGXYfgccGbJ/j1wG5KvJS8/QAJlkeTIVSM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 03:08:13PM -0400, Michael S. Tsirkin wrote:
> On Thu, May 14, 2026 at 02:56:54PM -0400, Gregory Price wrote:
> > On Thu, May 14, 2026 at 02:00:31PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, May 14, 2026 at 09:49:33AM -0400, Gregory Price wrote:
> > > 
> > > There are calls with no __GFP_ZERO but they do not allocate userspace pages.
> > > 
> > >   - drm_pagemap.c: GFP_HIGHUSER -- no zero. But this is a DRM device
> > >     page migration, the page content is preserved from the source.
> > > 
> > >   - test_hmm.c: GFP_HIGHUSER_MOVABLE -- no zero. Test driver, pages get
> > >     content from device.
> > > 
> > >   - mm/ksm.c: GFP_HIGHUSER_MOVABLE -- no zero. KSM merges identical
> > >     pages, content comes from the source page (copy).
> > > 
> > >   - mm/memory.c new_folio = GFP_HIGHUSER_MOVABLE
> > >     - no zero. This is CoW, content is copied from old page.
> > > 
> > >   - mm/userfaultfd.c: GFP_HIGHUSER_MOVABLE - no zero. Content comes from userspace via userfaultfd.
> > > 
> > >   - arm64/fault.c: __GFP_ZEROTAGS not __GFP_ZERO. MTE tag zeroing, not page zeroing. Page is zeroed separately.
> > > 
> > 
> > Right, so in all of these cases, it would be just as correct to pass
> > USER_ADDR_NONE I imagine :]
> 
> Hmm. Are you sure? Isn't the address used for numa policy?
> 

You said "They do not allocate userspace pages" - so wouldn't uaddr be
USER_ADDR_NONE anyway?

Even if they do allocate userspace pages, they weren't passing
__GFP_ZERO before, so either:

  1) They did not depend on the buddy to do zeroing before, and
     user_addr is just a dead variable in those cases anyway.

     or

  2) There is a bug, and they should be zeroing the page.

I just see an interesting hardening opportunity.

Not suggesting you actually implement this, to be clear, maybe just
documenting the idea on the thread as a potential follow up.

~Gregory

