Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D59CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 23:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36946B0005; Tue, 12 May 2026 19:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DC86B008A; Tue, 12 May 2026 19:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924776B008C; Tue, 12 May 2026 19:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83E636B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:09:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20D8A1C04FD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:09:10 +0000 (UTC)
X-FDA: 84760310460.23.39F6303
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FAFC2000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:09:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OClovmg+;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778627348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfYztun+Ckl4TQFSOsYDj/dxDNvMV7VEGy8D7Y98Eog=;
	b=yFlFGSBuGdCRaTKvO43/nK0sUUFTDHXLrCM1ERY4UnwTRx/WEoualOx6NvUnwi4j+mPHBQ
	jTp3tNIz2T4aOoAPJ94+OCu23iPc0e0OIsRIajh4c8VcCN5BYYKW8D5WlQTrId7ukVZtYC
	BDdhmHVvZT1pxGeJdDSGzbMl1kse9CM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OClovmg+;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778627348; a=rsa-sha256;
	cv=none;
	b=Je63Kp4KFcYomGeG4Ipa2q7pz7rj8mEaln8U3FxCfiJcJi73V3P6KQAH3Oql/gPNT43qfY
	wV4XNNKz3d9WZ9SJ0dyOgb1jUvyjLIvdwXbTskJP6fOo7UQe0NHsDsvTwymvR64RGqjPSc
	HfBYpwWOrs2l1HZoN/67aDNib1tFbMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778627345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jfYztun+Ckl4TQFSOsYDj/dxDNvMV7VEGy8D7Y98Eog=;
	b=OClovmg+z//xavFVJGja0KRGZPzjw4TBiKZtyPWlDogZ3/3y0NKd+k8q8cBv3HFUPYukv7
	9FbRmWxcgRoKkCWvqLsRXCnHaAE1bHxwHaGfG8A0GvgbktsDVPw7i8pESe3JICy+IW0ArP
	E9zXSmIpYbutpyBPbPBdR0kdBzRsyBk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-9s6EJDj9Mymcxjqaxq7CZw-1; Tue, 12 May 2026 19:09:04 -0400
X-MC-Unique: 9s6EJDj9Mymcxjqaxq7CZw-1
X-Mimecast-MFC-AGG-ID: 9s6EJDj9Mymcxjqaxq7CZw_1778627343
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44d68ed8f95so4849838f8f.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 16:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778627343; x=1779232143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfYztun+Ckl4TQFSOsYDj/dxDNvMV7VEGy8D7Y98Eog=;
        b=OxbZ/Qk6ozC93G8ydIi5KfdC/y/eFG3vG87K0gm4UWcdVEKX3ODYRsceMuC+QIotOh
         +dSZZWEWekAWhf/1Taa/t44M7M5Fh0W7dkTYIczeB357hVni+gskC0XPWGPOe11wkFDx
         HW1nojML6Bo2kz7AVUaRQYDB2IRBJO6KGCY4o0GkUSiWmP2zRHMoCDFNTD0OixFG6vcW
         IoUV7MQiTarknWoQ71lKXMIIFdNliEXLnvIv+WO0iSt2/dcWvZai5KLn23b73t/ouaw1
         qF35Nf2VePSZeX0ZSvkAdoxqqOVIYmR+1YNIHY5gInrsgoKUx9x9WdMptJdZn5pbobbw
         f/Pg==
X-Forwarded-Encrypted: i=1; AFNElJ+NbPW1tP/qIt6WDDbdMz6yJJlJHd1vmnSnpnBIJwEHn1eNO+jcnD2F2f7Xwq4xZ8QXWHuRmDaHog==@kvack.org
X-Gm-Message-State: AOJu0YzX82pr/MU2aWh4FmqvVEu1aeXAXmSaqMoIIZKnTL2/2TEFF81K
	ajAmr/w8Qjh5sSDA0Cm1bWmPUsAPiHF1uMJeS7R0/i5V9mjlwi8CAsWkBAaAO/Xhm0wgPIgaCcT
	fIyRd+G7J60B7y+luKiSeKwVFMYgddcj5i9P2G5NoewlMpjeMNL3k
X-Gm-Gg: Acq92OGucKXJ9heot6OI2I/tSxC+3qWM3m6/T+/oPEndcpc6cRQPY00Li0C/3QBOUiU
	nu8s/mvTmfWUuma/3MdoQeMiBwAqNLMlzw5ukoslF1iiP3wGJU1mEYx+QH4qIZOs/VF4ebQ40d0
	Q/HBGTsIT+hM5ZzSPMoHk0qvwI/wg1uJyB6DkdGhIKOviAWt9wQmvfTl1alnAa1yE7tnZ28yQkO
	9TkBlFGiDgHhg1kwftwRThzjR61eegU6C3iYPie0iqcSS4kaAJgeu/Dg/lqpSp6VO/K9hykVro3
	9xaN5oBW0EgpKTHdSsCy94YcCjiuY4sCFEQdIzW7dRXaXZegP0MKx8zK25m6Yz+tm6asLHv/nxL
	UWz/fowEZ3uOoDtrNv+g+3ujW/ij0fXWWtPY70YZ1
X-Received: by 2002:a05:6000:100e:b0:454:353e:3f4b with SMTP id ffacd0b85a97d-45ac0b2d931mr6693692f8f.3.1778627343082;
        Tue, 12 May 2026 16:09:03 -0700 (PDT)
X-Received: by 2002:a05:6000:100e:b0:454:353e:3f4b with SMTP id ffacd0b85a97d-45ac0b2d931mr6693637f8f.3.1778627342575;
        Tue, 12 May 2026 16:09:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45492271510sm42875375f8f.37.2026.05.12.16.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 16:09:01 -0700 (PDT)
Date: Tue, 12 May 2026 19:08:56 -0400
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
Subject: Re: [PATCH v7 17/31] mm: hugetlb: add gfp parameter and skip zeroing
 for zeroed pages
Message-ID: <20260512190250-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <4039b0b96594b69b15ad4bcd64cbb33de3cec350.1778616612.git.mst@redhat.com>
 <agOju4MRXyS7Wp8E@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agOju4MRXyS7Wp8E@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZKTLLilGo2J_-E4ljbU_-ftGvPNu41lq4CkrIggvX90_1778627343
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: uidr87tkh1a88ise877wwp358kqt6uc4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FAFC2000D
X-Rspam-User: 
X-HE-Tag: 1778627346-309843
X-HE-Meta: U2FsdGVkX1+mPqqVSx4GvHH4TqAEkaBlbg2h88vIZnl28zeCtdCg9gHKyune0uZCTp7ND/QjevFQSPjMwz+6hFYDxetxmcbTzAF/p8iaGhJXkyfRv3NaX/whEpuk1Bn1Cp9KuSiOrD8W4sZsjTN5sZiQae3MMq5rB2XJT4LFrQTsv+LeHKt+n5d2hwbCp44T3RhLx9u4an0MTfqO7SVhOsXQ11fQy2ZAKNTQf+nOkh+fYg7Q0Hj2OsJrcqCvueL2YK2vLpkUJGXe6xA1fbFpj84uLpV5AqifqUOk9KasfqWTRqz3BI/Zx0mbVBWlBNQqYQbOtyt42MP+vX6iWU63F0QwFy4my6UxAdTKsNocJ9AjgyP7XJQ9BMImOlks2XwAyz/c2ZJQXgBhK6tD84qo3ek/q92+4a4WihpWwpvcz4rphq6tcOiOQKw16TH4MH1nQQFNPa0ug731ftZqxXRu8BWAns+1IB29XKzD0YwG/We2UXWzGRyeEAnHsvVMyrm/aF4fYACP1qeFhfxFEipa9a+WiZfaKPeBmqrdBGFNQlKQe7dB6HY9GKLAwdO0S6HtBJDEOGGnModGWjobwRf02kaHhAI68qG/GVeAWOl0t2LhCwCKVh5VRPaReeSMnJYsJuexDmz8KfO4ByhGWros1AV8VX7ccYi4cFhfUpc8JgSmVawW6hG7XeZ7D4Zbim4rq22sej67xAshraXk06Kponj5wcty59VkMRrjK/cEGEfFCjb5OIpLWqj0iTzwsMMLazGVAmf3Em87kxNHKJtt4s7phVcd5J/wWL5PYLg7VS6qpAWMmnesWwG/DGAefoz94IZMKG53GwoUgv8C835+9avCSo0ENlqAg9gx1d9i3V1KhBjgsT59bGh/legkgc8XQvkRwEHs7ih/xKiwjw6LrxiU4BNHuOnBg2mmgooyUMaJHXCq0eeApkNH2VJmqDuSnzvTcpui+P4fIOYZoGS
 19cPdlgt
 oXJSDNbKwNyRj6lGyklpEUp+10AlBQwPFFqy9xEa1VStMYplyyCzp+RnmALbWch5X/370WRBeCTr9auTKUqS5F32hTbFK1ddS9TVHrfCDvDD6VzkL4KEuRdY7AMXz7kCrqkCrXpNu44XsRUjy3CcLWO3KlFBPJr0MGy5QSPXKhZ6/9ZZfQ6U6Ik+SE9v5pAK1jiT5TbNw05vY6GXjsqEmlqOHRMJdEtp9jko+QTBCCLZchUfFXu4gl/N080clB0sKJQCVpHajC03UTPGiMMzMG9jK4I8h09v3w4ucWzkdes2le/q7CSoYpndI8rIcqefoH8e3I3FiUpL4mniy5SkHv0c6smN+O0EtKdKPr4hAAu0QE9G6SYz6JEWZMQXcVOSdTpj/evC53jMjS4DPM154eS2odQX2Oci1TftuaZCevUfIPtpO3LiLDGqi8+AsBeo815d0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:03:39PM -0400, Gregory Price wrote:
> On Tue, May 12, 2026 at 05:06:37PM -0400, Michael S. Tsirkin wrote:
> > Add a gfp_t parameter to alloc_hugetlb_folio(). When __GFP_ZERO
> > is set, the function guarantees the returned folio is zeroed:
> > - Fresh allocations (buddy or gigantic): zeroed by
> >   post_alloc_hook via __GFP_ZERO.
> > - Pool pages with HPG_zeroed set: already zeroed, skip.
> > - Pool pages without HPG_zeroed: zeroed via folio_zero_user().
> > 
> > The address parameter is renamed to user_addr; the function
> > aligns it internally for reservation and NUMA policy lookups.
> > For pool pages that need zeroing, user_addr is passed to
> > folio_zero_user() for cache-friendly zeroing near the faulting
> > subpage.  All callers pass a page-aligned address; the
> > hugetlb_no_page caller passes vmf->real_address & PAGE_MASK
> > for consistency.
> > 
> > HPG_zeroed (stored in hugetlb folio->private bits) tracks
> > known-zero pool pages. It is set when alloc_surplus_hugetlb_folio
> > allocates with __GFP_ZERO, and cleared in free_huge_folio when
> > the page returns to the pool after userspace use.
> > 
> > Suggested-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > ---
> >  fs/hugetlbfs/inode.c    |  3 +--
> >  include/linux/hugetlb.h |  5 ++++-
> >  mm/hugetlb.c            | 47 ++++++++++++++++++++++++++++++-----------
> >  3 files changed, 40 insertions(+), 15 deletions(-)
> > 
> 
> This seems much much cleaner this way.  One nit, doesn't need a respin
> unless you feel like it.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> 
> 
> > @@ -2980,6 +2993,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> >  
> >  	spin_unlock_irq(&hugetlb_lock);
> >  
> > +	if ((gfp & __GFP_ZERO) && from_pool &&
> > +	    !folio_test_hugetlb_zeroed(folio))
> 
> stupid question:
> 
>    if (!from_pool) - wouldn't folio_test_hugetlb_zeroed(folio) be true
>    because __GFP_ZERO is passed?
> 
>    If not, SHOULD it be true (i.e. should we be setting that in the
>    non-pool allocation path when __GFP_ZERO is passed and allocation
>    succeeds?)
> 
> If so, can this just be simplified to:
> 
> if ((gfp & __GFP_ZERO) && !folio_test_hugetlb_zeroed(folio))
> 
> Maybe that lets you eliminate the bool entirely?
> 
> ~Gregory

Agreed. I will include this if I need to respin.

-- 
MST


