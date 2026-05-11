Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6242FCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BEFE6B00AD; Mon, 11 May 2026 17:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96ED16B00AE; Mon, 11 May 2026 17:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DBA6B00AF; Mon, 11 May 2026 17:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 747446B00AD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:59:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15BF6401D0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:59:36 +0000 (UTC)
X-FDA: 84756506352.07.44EA8BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D66DF40013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:59:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PtM/7CFg";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjGUst/RnjF+SV00Nscm4z96ojlmIg7JTTzXC6ZQiZA=;
	b=HFmNhJVCNdQcZQBhpTlR97NATTmU4btHjagxhn4aSDDkDpA3L6pIeFDcY9MoxCS87xWZH0
	dMOoEELHdxuAnBEhZ3ofn43uys87xq+n8MvaLWl/H1SaBX45m3sh8x8dGva/KLVHl+VA2Z
	WWAZdx1upqV0zdB7yDS4Yb+ke5SMw+k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PtM/7CFg";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536774; a=rsa-sha256;
	cv=none;
	b=HhwVddnLc1dUd91lbQxV3btkzguVRhbq6Kkb4Rc2D+u2sxTZGqKEUa7SnOwcuCQrPTsHdS
	QP2GQjE1Pt4bhOZI+zoFIk/f7U1xAcezhS96WYs4p/UlZAXQYiNSYT5YVvNmHCOMn17/Ox
	FuZHyylblZCUa+P4x8Sn0FVKaVKWV2M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778536773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PjGUst/RnjF+SV00Nscm4z96ojlmIg7JTTzXC6ZQiZA=;
	b=PtM/7CFgbWnQmf9ArgeQ51jfRU9WYoNLD7N0LVFgKLuFxm+EISUxChXpNLYuD2nb86cqiu
	yQiKBfgEidZiLnYrE0NCoQsWnH9cZvBeBeGy2jAZ+ZMCRoJrnAmfxW/dklYALLvOHfJsO0
	/OnZGKrnKMISfEw1TgSNdMzCxafw7o4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-M2nUfGAzNrmEHMecFAZcjQ-1; Mon, 11 May 2026 17:59:31 -0400
X-MC-Unique: M2nUfGAzNrmEHMecFAZcjQ-1
X-Mimecast-MFC-AGG-ID: M2nUfGAzNrmEHMecFAZcjQ_1778536771
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso3035820f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778536771; x=1779141571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjGUst/RnjF+SV00Nscm4z96ojlmIg7JTTzXC6ZQiZA=;
        b=Eop7TDFcCzKRUgPTyu/yYJL4sH6tYDDoDLQJAF+eQjJgS5toyH/+079j+C9xMbf93N
         2eIjyz7zRVQ87F3x49yf0wd5pVPImvGmSTa01bJK27a/qT2yPSLOycwp0XJmRejZDZM4
         nnW9ASgcGYYzT3h3wAEY9+pFP56h67TTkVwdRsl+ys9A4X+MqAOxi45Cp2zWbi2R5UMc
         B9cmjNduW213Uv1VTZ7xJzOtWcM1evy9FG1quZR6q4BF5dogsM3vFXYhtf4M3/rAp1E7
         gWHoYg+H9SAKD/O10+4B+/Mwed3eSdmRpF9U51SsVkT0G+YRZd55YcrhDX6v2sm+Plmu
         jvjA==
X-Forwarded-Encrypted: i=1; AFNElJ8+PuQTRpZjHQE+/P1/lAHc2yw85t9uopI0Z+/KxRTWEbp2gR0IcnJG36RmuXFiItYzW8ujU3/sLA==@kvack.org
X-Gm-Message-State: AOJu0Yya0Se+cAQTjWkyDOHnxfqbF/7feLQPj09LAuTEDuL5Jloo9b+m
	35v5DwwFU9RfvBq7omaiMeHaqAMHH/eYF9eO9bE40UfVcgYaWVEfJGPblqQ75VKHL+lf7N85HU6
	tk/8hEVpOs4KsLluNlzIIlUvBTiaj5rDiMNGNLVIBwPVPDchsdGb+
X-Gm-Gg: Acq92OF/irP6qfxdvt0MeDqh6k5m4nUfTxYl8qFAnjGNlm7DslNlrP49nG0GQ5xD/tE
	VPk5gCAnFLZe3EP4zy3JvWjzPXJERczXFpc5jmen4asdgh1OMHTDiI+EbvK2PtBD04sj3Fit4s4
	Wiltj/wJLo7510tQyPUlmLf/V/O4VcimAQ/x6wdLuyGc2j0Bx/nDrOjTCONf9fE1croktpLG7yn
	AJheYWCuR1PBCaIPIpsbWyjOUjKAe5PzazsTy9GSGpe3tIcaarHiec/AJ86wkpLqGIcB0wjJdG1
	7Zt4/eKly8Xt7FoLXG4hioaYeZaC7CuL+hRRI7RbF/DbeFW3MP79mv42yBeZLgFKEhHYC/nfbmK
	0fupeQR0F7hfvKwotZIRakKtA1LIuVss6HSNUMIFz
X-Received: by 2002:a05:6000:310a:b0:43b:4f86:e985 with SMTP id ffacd0b85a97d-4515d3dcac9mr40872501f8f.33.1778536770535;
        Mon, 11 May 2026 14:59:30 -0700 (PDT)
X-Received: by 2002:a05:6000:310a:b0:43b:4f86:e985 with SMTP id ffacd0b85a97d-4515d3dcac9mr40872434f8f.33.1778536770030;
        Mon, 11 May 2026 14:59:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6cd75sm26961587f8f.16.2026.05.11.14.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:59:29 -0700 (PDT)
Date: Mon, 11 May 2026 17:59:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <20260511175032-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
 <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
 <20260511114853-mutt-send-email-mst@kernel.org>
 <agIJOkLhTOsvJs1-@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agIJOkLhTOsvJs1-@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NB2oKUWVMa53OkxW2SS6SduyTt82YOrtLrjbU32zNGs_1778536771
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D66DF40013
X-Rspam-User: 
X-Stat-Signature: c6a9i97mm98y8sr9tgm43o4x4669uz5e
X-HE-Tag: 1778536773-770011
X-HE-Meta: U2FsdGVkX1/NqXnr64dvO3fG81P0iA9T/1ALi2Wbbqm0mAUzGUyz4nxKdrqqe5bjQHD5Bjr30iFcQcxMTxKQXXUyiNZfftJYUIhW78aNXYGbjUlfw4UrtbEMG1XoIhRExxG+8H6Ne5K2Z8B+wkSJOsJ3gJaijXJrXbTOouqoBk432pLpACJnqKV+IZ8ScVlmqLQTgDBb42WHjVeU61TD+m0O5az6rnorbwQ3Wi3oehmAnlVrgufdOi4jHosSyAqDakD6R8yR9Yprm78SphkZnhoMcRGe1fvyoygNjLsFjQwUEYChZKxo9kFL3uXFgZXnVsXqDmztr85vjMFVs+JyVRpeA27gQj6FeVYdIx4yth9iW4VIw7t/Td9qAF44dBf68w/1BavDrD1LvDRzANIck5pWGOWznSOIKa6pqiA+lNx1Pz7Q7sbMz2+4JzUGKljm3v6NUjslw13O2G6TW5FDdFfT65346UtS78Rd6V8gPQLEhYx0Za6zz2gXEYp4swlzzSP7geetZz1ek9juByPh80L6qKiTSjtiKHsabBjRJEJZNX4Au0upRtJ7TipMqsmsvbz6xe1NwlJVcdt1OG4317EZUAPfrunCHO4EUjnDjPKCxIzz7eRWZZJLmvR8O6+3+faGmIJ8Lxyeqy/+MoFtXpQT3icvYVOE6C7p+BHOUKgq1f/foVtLW66V7FbykcS5z9jdlrOInFSUdkn1E5zFxp/rjTQ45ES4C+BnqX2xjP2714StlVtjacSBodTsn1SEabAVoHoiruL3LNR+JV5/zoAxo4+gQRpKNMUi5LKsfjYkzMAIINUVJ+htiS01AqQJ55nrf6P7Itx1rHUF9yeyXFf2tCZsLLNVWe4YLTvaQWzIbWu8EO/FA0i0Vspguc7W3K3kEl8FrJaIamH6TdOuQAHMbeRRNRKPTopCkOeyg6X4o5Z+PVqFkH5KzbAAXGgcUDeH6yTZP+1KNlgzu4v
 TURmQLhj
 c69EHgQqdcHPZ1JmWq/nRDpfADBCex3hM9XI171VZdIDJfIj4XSczUOaAwtB7saRQC3nZOBmbOQMVYqOQEvJCcRXmAFT28lx/eU2brWer03IW7o8tSjyS7xU8qoObiPHIvQA2/YcYXBubwtzVDmdO0LdeLAhYaKriQ8VRhwToC7zLeDvU4tNeKmC2gck7c/Mxw/T9tODiwVy4hHTg+W2hHOA7qE7c9Z4AS0x3+3w1DH3UNoQn92X4XC6PmMcbrHzDrAu8NCH7da+z+AUj22Mbd5QcqGZ2TdlI2qZgYMKoabWzkufewLwx2Ddv01JOeOIc6FKvpdTeJBg+m8WTgWzjVxhj96zLTKfsrzTcVrGYFig5Rn/DxmljonZa3XoRi3GCv2h5BQhFg4/cAJgUjRBaVeX0fSp1mfMiEXCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:52:10PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 11:55:40AM -0400, Michael S. Tsirkin wrote:
> > On Mon, May 11, 2026 at 11:37:37AM -0400, Gregory Price wrote:
> > > On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> > > 
> > > > +/*
> > > > + * Sentinel for user_addr: indicates a non-user allocation.
> > > > + * Cannot use 0 because address 0 is a valid userspace mapping.
> > > > + */
> > > > +#define USER_ADDR_NONE	((unsigned long)-1)
> > > 
> > > Ehm, hm.  Does -1 hold as a non-user address across all architectures?
> > > 
> > > What about in linear addressing / no VM mode?
> > 
> > this is used on a fault. I don't think there are any faults then?
> > But maybe FAULT_ADDR_NONE would be clearer.
> >
> 
> Meh, naming here is less relevant than the sentinel correctness.
> 
> My only concern is really whether -1 could end up being a valid address
> in some horrid future timeline and this all going belly up.
> 
> Is why I asked about whether this is correct on all architectures.

I think the answer is yes: on all architectures Linux supports, the last
page of the address space is never a valid user mapping. The kernel
enforces this -- mmap will not create a mapping whose end wraps past -1.

  if (addr > TASK_SIZE - len)
      return -ENOMEM;


So the maximum vm_end = addr + len <= TASK_SIZE.
On every architecture TASK_SIZE <= (unsigned long)-1, so vm_end can
never wrap around to 0 and address -1 can never be within any
VMA.


> > > So the trade off is:
> > >    a) churn the current interface for everyone
> > >    b) add a user_ variant and know people will just get it wrong
> > 
> > I was also explicitly asked not to proliferate too many new APIs.
> >
> 
> Yeah simply spelling it out, not asking for a change.  Probably no
> better way to go about it.
> 
> ~Gregory


