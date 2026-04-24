Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2FAFB44D8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D766B009D; Fri, 24 Apr 2026 08:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E8D6B009E; Fri, 24 Apr 2026 08:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0116B009F; Fri, 24 Apr 2026 08:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE326B009D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:33:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D48971C0044
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:33:16 +0000 (UTC)
X-FDA: 84693389592.05.C592C34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8550140007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:33:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMmTp+r6;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iU5HGQMMAHkFsOD8j+WiLpo76Kie/jMXtxjrTFTeJas=;
	b=aaZAE859i+oNbtG8b0D06xz4WBYu1EoS2Gwi/6ZUcNjrUJE4JZmIab5RLpiYAI8sCyF7ib
	gWyt8OESdXQ6+fnjtIFF3/cp59TQ4qlGdTOtIac3HK3owZQnScUpE37ALQ16RC3QC5LaKN
	CsbxCepkjBby5VU5SvfCgAeq5iT7cDY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMmTp+r6;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033994; a=rsa-sha256;
	cv=none;
	b=gsdAkTBNYzK7fmFMd4gPyxprpmSxcuEaPmiPirPJwYGZG3n1/aDl9oyZ1mhfcHg9qHhCh2
	Xo8wqKJ1bDiCQZEtMdoUug7rpsbs3KlGBV2UEdbykVWeSUKWj8Shnek0lTY2NYHkEr5duv
	OZLNjsEetqJ+3GtBmqyEQrgI0Kt42p8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777033993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iU5HGQMMAHkFsOD8j+WiLpo76Kie/jMXtxjrTFTeJas=;
	b=NMmTp+r6aQk+IZjY5mBWeiK4FmZmkPNj/Eac+HM6tSywTy/esUBNHkIJ3prjWg3ddaS7Wz
	40cbMlLFXQQkpI9bGuF6JUS7ttNTw+vRiEuWxqEGPse6FSsaWTuRDKJiEBVPuacWi4+sRq
	xSLkG8hRf2/LJZwl0hokA9RHxi5xlM4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-FNq3i7hQMWeQH0VLDw6wSw-1; Fri, 24 Apr 2026 08:33:12 -0400
X-MC-Unique: FNq3i7hQMWeQH0VLDw6wSw-1
X-Mimecast-MFC-AGG-ID: FNq3i7hQMWeQH0VLDw6wSw_1777033991
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso5623810f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777033991; x=1777638791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU5HGQMMAHkFsOD8j+WiLpo76Kie/jMXtxjrTFTeJas=;
        b=O96C7dvGm/ygKnw5FJwJMRqJ2XS7NohqXgAsTK8OE033nBmcVISYzIbPbMTzw2QCyw
         iskx5tuAN3yrHGNWAkQo7Ua0nHUGIrJgUnIWXVUBixCXpfNLCyrIhF0ECs69gH2pWxa1
         8ChIryiaqLY4kLhNRxG89Y6xBoiKay8cpl+5xPHMJJFkb6ealsTrYjKUVmQZ5JQcUR/Q
         nAPvnRDffQF2VjH7SR8VYna/f+vHD7Xrf4WRIFEt7yoytLYH/V6AdeyJdLM2mPdf1ADV
         40dPZrqBTC1la+pjX27/Rm28ZAqnzjCpX0YimG16hmhl0aXENoYrGzbecmcwYlYqr9y3
         0jhw==
X-Forwarded-Encrypted: i=1; AFNElJ+UDIxuGEFPkvKkxYt6VROUJ9CJxDj12iv5ZuZHOLQZllJJnGCmU+YxUzne8qMqmwM9DgLuigdj1g==@kvack.org
X-Gm-Message-State: AOJu0YzMzL3NdbdGcK88qFN93YmgFhLEouoR15FoXI7isry6+2H3mLNR
	NXj/L4LLe/MMaQZfF+QB5qYAinBp2rmFldFuQ5xE+YglpH79Kkhkj8/cBck8wf6I5fP8sv0Eu5r
	huBBSMoXYjTEHuNOtOqWxP7TwV/jZwUGisfZ1TOaHMEp65l9OUC5f
X-Gm-Gg: AeBDietl2XHSOHkhjZ+i2e0xiCtb0zxvL4abvY0vPUy2qLC9ewR8kDGh+tmHbXuNnH5
	NX1LlzRvaRoGDsUkgYAio1s2qmo8acZFANZDi4HnNfVraQ2Bu1lmljMzuhcJyeR+7HWIG2Cty5b
	nweRaRn92Nl7IFkOgLGBq0Q73LOfrvlFH4pjqj3iUCvRbhdwPg2wCco9+lQd+Xta9EzX5XX14uT
	qYHKMEs4lvtPWDz8f3P8V4s1wR/vsJrCEjWuXpv/SfFAVyPU5NOsXIHOkfEWGTwv79XWq14VJ/t
	paHIYBQFIcm8p2Af8Elp/h7xALzmqyPNK7tfUGpi+VHEkR8rDpyXsiP3auF8SJGP9RUMUyNdw1D
	cf9NAo9JEIxx5sO2HYZG2cmkqp1JhhnJefvbEH1pTkCgLCE/kbWsOlw==
X-Received: by 2002:a05:600c:3e1a:b0:489:1ca2:eafd with SMTP id 5b1f17b1804b1-4891ca2ee65mr307985475e9.11.1777033991109;
        Fri, 24 Apr 2026 05:33:11 -0700 (PDT)
X-Received: by 2002:a05:600c:3e1a:b0:489:1ca2:eafd with SMTP id 5b1f17b1804b1-4891ca2ee65mr307984885e9.11.1777033990672;
        Fri, 24 Apr 2026 05:33:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5a579bd3sm226459065e9.6.2026.04.24.05.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 05:33:10 -0700 (PDT)
Date: Fri, 24 Apr 2026 08:33:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260424083228-mutt-send-email-mst@kernel.org>
References: <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F>
 <016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org>
 <aeticBh5XlAlD1vn@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aeticBh5XlAlD1vn@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MfdA9_8BeKjwRxrZAjfuJ1OjofIxxPNRU9EC11R9CFQ_1777033991
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: c4dbi533mjou3st8waiznnhtumj66m5h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8550140007
X-HE-Tag: 1777033994-675359
X-HE-Meta: U2FsdGVkX19HnqcennD77hmJ25WwMTOoyiEa7pTm1CvwNaDHuAPyY5rDV3dX1BTNgq6S1n1tB3DX3Rpm8oMsliAERuhl/zPrf4EsMQWzxbdCXFqlWwLX5Lt6zzgL41bKUu0RJx7HmF5eMT2TA4xy515p2dMCt0g20SYMqPHDxyQhnpxc3fXEDSCaVYmDs0UXbPaSfYyjpBewSgGvklNmLpVyfCnex6Vme0IA8UOQJ3i63LEv+Ad0HZOsQEW1v4ucSX77ReV1apc51zItJbYsBgaI0+viXg7rqh3PgcdKR0S2dlkXAh+SFitMnE/3oBWpxQo8MSs595OXPiCkpAgTGIe/ovia26RrfSWXW/B0s6WP0CJWwR28atRpANhKiWliSVRwobdpWPxFqm43oHGgieLYkSxFuL5KFtyBxVcJDDrt0JPQykRZ0ih30YpuQ7yBEAmrecFD9zncbznaggaPAikSK0J4VlP7G0N29YqBXz8bNQImrBEyeIvQVBRB4fI9vibe+7vNOyZkvlSGa5L1fvHiU3ExHivrQrUrP/qXjH+Kn3WzlK+3lrS51mM68ckHDP2m7phi/G65BbttrNMNRkxnG8rFPpHO8Rt6fx6iBshHdntOjmOmelvpDNzYqFZRvTpx0lrfpm/rXJDmI//ReXr8XeLqoHhaBM3jpeL5n/rJUMY8XVaRYg7kGxi7SHcLpdmVV7LUORwBlbj5jEyWgETsTBEroOvR6eenyWNQTw9h4viZ2kabK2r8GG6NSe5JEaVtXWu7QD01t2BGSaPORZAG1e236s7+eh7xzAmkYFwQCXfMzjWR241IGXucVeLSpcxwnZIlE6OBOFmkD2EosqgE+kqOdTGsQ6ketiglr9u8N/C7pBAcQWuzMRanE+oqv4NuPBloZzDkymjpVYmcniw7bE1tDnT86r4H0UE3GXlLnuVpMe26cXh2Ze1nAmB1CNeo/NQKjMffbpSF+9q
 vq0GXHOI
 +OJTucbEBEUcy/5LztVkoH3RNQLoIYHBsrUDhA7NoQw+IvWO85XxBDwi9bjOH2Q7FmQ8tUJm8EaneYfeVrgRjlHd1n80n8zy+N1emJ16VEm5103BAUy5l7oIWOvqH7cR7kl/atYiNZwsFiByoLpmarbBsDL3TMgff5y49NzbilJ/GrTKo0O5XrprfsjSBO2YdtF0seX5tetG6dZMyOqPMcr/0pAVEAhT+G6osM746waMOKZn6i9uGqpiZ+PxGZ7w62tX1jVS493QZHN9BNR4J83Yzo8ammG6k/uDVYXEs00mAB4XOXWuLI4i1R1+rz0q7UhgOmrm1zuQj510Q1asrCuXQZY1I8KzrbrwGUYOEIPE3G3XaVGQAIio4hw0Ng13DR3/r2MT2DI/87syoqk/Vz+uNKodmv2wg00Ny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:30:40AM -0400, Gregory Price wrote:
> On Fri, Apr 24, 2026 at 09:28:36AM +0200, David Hildenbrand (Arm) wrote:
> > On 4/23/26 16:57, Gregory Price wrote:
> > > On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 4/23/26 15:42, Gregory Price wrote:
> > >>
> > >> Maybe we could forward the vma+addr here and call a vma_alloc_froze_folio() if
> > >> we have a VMA+addr to have a clean interface.
> > >>
> > >> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
> > >> alone on a v1, and focusing on non-hugetlb first.
> > >>
> > > 
> > > If we're ok increasing the buddy surface this way, then I'd vote for
> > > only updating the exact interfaces that MST needs to update for his use
> > > case in a base set of patches, and then have each additional updated
> > > location (or logical set of locations) updated in follow-ups.
> > > 
> > > My initial go around with this - the patch was hard to read at best.
> > > 
> > > But I also think we should also seriously consider not increasing the
> > > surface of the buddy. 
> > 
> > Exactly, that's why I am saying that vma_alloc_folio() is the only external
> > interface people should be using with a user address. all other _noprof helpers
> > are supposed to be internal.
> > 
> > For hugetlb, we might need another interface for frozen folios later, which is
> > why I suggest to defer that.
> > 
> 
> Yeah I follow now - we're of the same mind on all this then.
> 
> ~Gregory


OK v4 incoming, thanks.


