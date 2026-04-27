Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A88FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B2C6B009F; Mon, 27 Apr 2026 11:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A54E6B00A0; Mon, 27 Apr 2026 11:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793DD6B00A1; Mon, 27 Apr 2026 11:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637E16B009F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:25:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CE1C1A0FDE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:18:14 +0000 (UTC)
X-FDA: 84704691708.09.1D58C90
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id BCC894000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:18:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhZi6x0o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777303090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsHOVCUXvaEIYIkpmuMRaDJg98RHwYpOJQfqxhVn1Is=;
	b=Dz6kRdNwomwwfRFVlVTl8mGkLcZCfz8MP9/IFuG1UDJ8wybAHdw3Vj3r3JjR1oi3UixAzj
	lBaMJ2zB4xQmVi3SWxQrzMkyrIHArNIPXgbQo0ozfPNfP+iO8Bz6Ye1CSPaTDdxwn7TmIZ
	VUAIEt8Ct56uHboTikBK7id425v+e+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777303090; a=rsa-sha256;
	cv=none;
	b=0HVW19Kv5n9GEratNR1Z+LHXzbbucQG+3pCPcnwxigPlGgdotwPpCmtIHmIJ4zPpbQXbmk
	nlTI2CdQF5yyjKS2aMTgLdvMr9K4D4/RDqXXUY8mB7BFliJqFP6cjjasAgZNLcwfFiT0JK
	R6nP9NWb5jNaOf697MFVUACOnSbqiL8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhZi6x0o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777303090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wsHOVCUXvaEIYIkpmuMRaDJg98RHwYpOJQfqxhVn1Is=;
	b=BhZi6x0oltj1B3XchqwSnoeh3Ztugx2AklsNsawaQwrKDp0KBitYO/9YMd/YQEO1eb2Wnm
	4uKXe1GJEL4Y0wz+gQCyPwUqIB+uFJ2r0/OXxZe7PVcD5lWhtLHTAVzQDUVRio4gNwN18R
	pSoFJHRJyyzttkHD1NJVZXp4IVw0p1s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-YEbNtdw6MSy5tefayXZG5w-1; Mon, 27 Apr 2026 11:18:06 -0400
X-MC-Unique: YEbNtdw6MSy5tefayXZG5w-1
X-Mimecast-MFC-AGG-ID: YEbNtdw6MSy5tefayXZG5w_1777303086
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d70c27214so7201814f8f.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777303085; x=1777907885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsHOVCUXvaEIYIkpmuMRaDJg98RHwYpOJQfqxhVn1Is=;
        b=VuHol7Brs6sbxWqzYj6JLW6k/SqbJzWyTtSwFPgkjQQpEwhkoqnKuVkitRsLQz0VHZ
         wE+99wTKtJzi42YpYOzB4+reOmjKh0y/uhfae2cL02vp1SPSCZFRAAWPS80nlhWIqz94
         yB2rQpwvhMpBE06HZETwRaI+D5Q2LzU/uD8FxQNDG0kNC2zwVZCBZnzDH2sPPqno/3Jp
         NvW6psp9xvtRtVPzVDomIlXJadvnclYEqhYrz1d5o/Sxr+8Ua3j7RXtxJwpBC+GaOjs2
         Frq64kzMkZL+rOW2UI49WaxOoRUFOzSs4ralxrviLRULVTFJo5UmQmG2Gj9iA3yPn+eS
         kYAg==
X-Forwarded-Encrypted: i=1; AFNElJ8F0BUhz4lDPcsgTct8hKmG6ttCfBRelvIxAKCWvGq5E9ZLIraCep9jCn9MjnUp11S7fhx1SjwW/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx2Y/b/Hs+dieCafVwG4tCrWBHwE2S57rAkGMpHP1AeOMP8RTKF
	YA0wvuzXy3dC08/GaBjggq7/+IvPbud/4lXeKbj41T4hxgUwzuVDqQUpHEqvKVGRasrKGT3YEQu
	1DjP/m8jsU4OhKx5HmPU63qQyDSEVVJL6jFcNyX2fBqtfIfBAFCFP44nzgxi4
X-Gm-Gg: AeBDiesiO+QUeKMgML5cuoo9wPhqCCHVg8lTRVYt8CRMEQ4dXautXwrsUe36W9nBzpw
	QfdeGESSYnY9WQFiLvzHUEgzwC1+4mS2Ic/5Y3UBzbfUXXAYnWntDRCkS39MXFaxeD9otNVCIWK
	sb0Oc/Y4THRSFoNW2kEgfinEfifXqqFe2lQiqiEPCRia5ALf/D3RcK5johpUGNnfYdxtbW702k7
	g+pMoMsZsAboOSOhtO+QAuullAMGRf9WV8k0VbOYffrV7X7AYzeDmCd593B3vY0NgQfGuihEY1E
	tU7T40kCtIQGS1CiszMTcvNNaab5UhYUcaiKUpyS9I30KcDcZd7n700XJwYgvcCyYcwA5NZIXVF
	PGub2rWgTVjq8qjgM8p9lBHRcYaMWuS6j7DCqiq4628ir44CR2YgEsEjp
X-Received: by 2002:a05:6000:40de:b0:43d:7946:badc with SMTP id ffacd0b85a97d-43fe3e073dcmr66488019f8f.26.1777303085259;
        Mon, 27 Apr 2026 08:18:05 -0700 (PDT)
X-Received: by 2002:a05:6000:40de:b0:43d:7946:badc with SMTP id ffacd0b85a97d-43fe3e073dcmr66487949f8f.26.1777303084696;
        Mon, 27 Apr 2026 08:18:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e44f69sm85358069f8f.25.2026.04.27.08.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 08:18:04 -0700 (PDT)
Date: Mon, 27 Apr 2026 11:18:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC v4 14/22] mm: page_reporting: skip redundant zeroing
 of host-zeroed reported pages
Message-ID: <20260427111724-mutt-send-email-mst@kernel.org>
References: <cover.1777223007.git.mst@redhat.com>
 <788d5a09394ed1456beaab23f75d91846ceeb611.1777223007.git.mst@redhat.com>
 <DI419PSP5050.15VGMJFDMWBQU@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <DI419PSP5050.15VGMJFDMWBQU@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ck_EPgKAR0b46p_hwlEUgFOJaAdmN_gw-pQ7Dxx5b6I_1777303086
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCC894000D
X-Stat-Signature: so4qg488jw3nmmky4dp44q7mbx5kk17a
X-Rspam-User: 
X-HE-Tag: 1777303090-952004
X-HE-Meta: U2FsdGVkX1/tr7mi8sYp8TAloa2FsGkBkIE9ui6oLzt5m0skS2/+x3SmotGxu6ZPat1s01/VVthBO8Pdg2g7KQqHwjV3lANc3pP4m5n3sAk2LseFXv+ztJsD1Z22yShe7o/oDvFr0RQ1mIH9wjudJdChRZrn07FFBBQukedZErhQRykp0CaJ1/pxkaMaGOr4E5dIhPWMv3HR+FEheyJ/awLGz1T3kCLuYvH3agjqoMVda6nef96aFC3oc4OdES+n88I+DxBXAtBZSe6wTSem9+m7cmYFMiYRBG3Bt8IB2a65dVAfIYoYns+QUbBS8P1s7JVV1Yyv6GmTEJfX/klCxcetC2v079gsdNA4sFcmNCkY4qihsqGR8c70YVBoRkuh8729gUGOxHlC+R8L+NMqmGHnhIrVAIkaDR2zvWEQzUs1IMHntt2vtvONhnLr4M2Wg9x8QDjXPcAyTrE8m/UXb4LJZ/EMKedBOkeEXqM2pEsPDTxlcf7s0r9O40L5xzChNzAvg2i6uu0THccRK6nezjD5C4lX/hVgq5t/h8N4cx1xhU2ikL9Vo48H2Mv67i4dMvHCgefZRDOZOOI93ay4SlNXI+QCDh1f2GrT1BuxBBvQ95/1tFpeMYMWvOQuxS0VWlgU78bhaGcd95YyHrwTOR6IYrXAdVXtg4XE0o2SgjVFQdLDYzJgQz2BrhOZJnCXxLhAx9S3nI9LhbEjB3ghs8RJbisANr5cD8nBwaynfDWNVVs7j5c7CcjtyKtgD8i+BKib3KTvag7TOF2u9R7cNnkBnEVryWTNBXOjuLpyMuuVOVgs/9If9SEJk3v0H8KxC2FyPdX28vyU7U70/DqKnqhvjWsdOT8iIWwi7em2viuMLGahAIVxE3qn9ASnIENYPY92kL6AmbkQm+FHGY3PPIayc2+9WUfJA9LiO0lPUa/6+oXnKpi++SLFHgteG/C31OyBtwMFhJcD42ymzLV
 RyDj+QAq
 sLBN6ibdGQfA7v4/IHQFjyi+lumAtRo0a9t8QCAbwPYeFp5c2Zxtmz0geLV8zcpRqU3F9KalJ1jDFL+M+MiglNHTz2rwuV5ZEAIQi5CH99sGXwKpF9eB00MX0UN7LSsdYplC4W0hHXEf+6xSsVywJQaoE9LO7oGncDdWNaqKQmDUZT5nKCC7rT4t/7aq4wdeuS+7h81i21COeknqrL9EKRuRZ3hFBJTZzQSEN9Y1ZKhi5wl9uN3ySgXAyvttRXQ2eLdja1j3O2f7mgMOTAhPCH7UikSFn847V7Kx3+ZxqntZ+5IZybJBRoX5qZ/maEd2Cw9zLYSxJHP3SZDgG22rofbBBZ0uHDRZEgsA7Se42ZDv763w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:13:44AM -0400, Zi Yan wrote:
> On Sun Apr 26, 2026 at 5:48 PM EDT, Michael S. Tsirkin wrote:
> > When a guest reports free pages to the hypervisor via the page reporting
> > framework (used by virtio-balloon and hv_balloon), the host typically
> > zeros those pages when reclaiming their backing memory.  However, when
> > those pages are later allocated in the guest, post_alloc_hook()
> > unconditionally zeros them again if __GFP_ZERO is set.  This
> > double-zeroing is wasteful, especially for large pages.
> >
> > Avoid redundant zeroing:
> >
> > - Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
> >   drivers to declare that their host zeros reported pages on reclaim.
> >   A static key (page_reporting_host_zeroes) gates the fast path.
> >
> > - Add PG_zeroed page flag (sharing PG_private bit) to mark pages
> >   that have been zeroed by the host.  Set it on reported pages during
> >   allocation from the buddy in page_del_and_expand().
> >
> > - Thread the zeroed bool through rmqueue -> prep_new_page ->
> >   post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
> >   allocations.
> >
> > No driver sets host_zeroes_pages yet; a follow-up patch to
> > virtio_balloon is needed to opt in.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > ---
> >  include/linux/page-flags.h     |  9 +++++
> >  include/linux/page_reporting.h |  3 ++
> >  mm/compaction.c                |  6 ++--
> >  mm/internal.h                  |  2 +-
> >  mm/page_alloc.c                | 66 +++++++++++++++++++++++-----------
> >  mm/page_reporting.c            | 14 +++++++-
> >  mm/page_reporting.h            | 12 +++++++
> >  7 files changed, 87 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index f7a0e4af0c73..eef2499cba8b 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -135,6 +135,8 @@ enum pageflags {
> >  	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
> >  	/* Some filesystems */
> >  	PG_checked = PG_owner_priv_1,
> > +	/* Page contents are known to be zero */
> > +	PG_zeroed = PG_private,
> 
> +willy,
> 
> I was discussing with willy and David about removing PG_private and
> repurposing it to PG_folio to identify folios. IIUC, PG_zeroed is only
> set for PageBuddy, so it should not be an issue to set it for allocated
> pages for folio identification. Let me know if I get it wrong.
> 
> Thanks.
> 
> -- 
> Best Regards,
> Yan, Zi


Exactly. Trivial to switch to another bit, of course - most are
unused in the buddy.

-- 
MST


