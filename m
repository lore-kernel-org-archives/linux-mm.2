Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD4FCD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B365E6B008C; Mon,  8 Jun 2026 17:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D8B6B0092; Mon,  8 Jun 2026 17:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC9C6B0093; Mon,  8 Jun 2026 17:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 915026B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:17:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 335F3402FE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:17:10 +0000 (UTC)
X-FDA: 84858005820.26.B213900
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9551D120005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:17:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMH0fTDa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRdTTt1HwOOV0JRgBtySsMs51PNp1j0cJ53zgwnOjpA=;
	b=dOjOi/3K++qSyB4nQztpXHvwCDWbAiU2f1CQMVUES9XlN3HklJgO9kvXjU7c4mC/4KFK1R
	OIDht+DM61TZabLnpIRP3Ce53kbNUQUx9D5oQvNq7MQjQOrxJS86kGmFA/8N+9F7vUv2ZC
	N9IdZqTAAaN4J9L9Qav3OxgZ4HoMRe4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMH0fTDa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780953428;
	b=rnzay4LWqNfTE6E25HHycgmbjqZ5kHL9N2fA0rp3iMm+9KNUEgy5cFBVYG+yfVWYCSldTQ
	4ychNNDIziLqmuQaSMdmhAkJAULEESRXwD9bvDnv7pZil+IAb7hHZpwOVhHZAt75qQIttJ
	I5WXGQo8Ks+sCqA4qzImn9YOj+UQ+1o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780953426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lRdTTt1HwOOV0JRgBtySsMs51PNp1j0cJ53zgwnOjpA=;
	b=GMH0fTDaJwktL+XTXVlC94YFXcJjnReuJRz5sFKVIwpJxikQbEKK4WNCV4Fyi9xV8/Avhx
	vQkbKxgc9SZl7/2pRC7c0z2HhzzTZC+PrskG7Pxj3rU7vAmDFf/ozvaWeWb61qbsAKkb1t
	zLk5IE/dy6SPXgF9eNw3JWsNjKTIxC0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-HGv6HH86NSaHHYrsqSAvng-1; Mon, 08 Jun 2026 17:17:00 -0400
X-MC-Unique: HGv6HH86NSaHHYrsqSAvng-1
X-Mimecast-MFC-AGG-ID: HGv6HH86NSaHHYrsqSAvng_1780953420
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45ef5e38a18so2171381f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780953419; x=1781558219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRdTTt1HwOOV0JRgBtySsMs51PNp1j0cJ53zgwnOjpA=;
        b=OYL53FBv55EHBcLDwkA6iqKdcDJNvDmIoNdVJW1w8igNtDsa3JYpf3kN2kmyTDIHKl
         wzMv9zfW9r69m1LiorqnNIHmNV3jDcF27ZP02zW6XvP88Q1LO0VjC8sgiyRQaA0pAVRr
         1dqUJX/E4PPvR37pCH2zC+OFkaXVe7EOHeI0dGP0y5SFaw1m9yhxJl0S5FER/7qzTh48
         7ial6lTS/+u4vtG1kadkGQXmxmpVvaMfAL3s9Aku2M1dd+kTOq3Q5dUj0v9ObFavHyeu
         9A1OdSuJvGMU58oIIS/dVo25YWZbGzM+UnIxy/L+YhV1HLvC/cQTbjSUTbxaz1YwvEwp
         A84w==
X-Forwarded-Encrypted: i=1; AFNElJ9i8U8ZKVmB7QgcXYTrZJb01yRiZdSIs5pG4mh06HLZqw4Q/F9H52ZAiJX2vcP0mceZI+zSJpv7DA==@kvack.org
X-Gm-Message-State: AOJu0Yx+p6NtpZmJBUMWbUcUFlvxD1kSpORdLiVKOLgTwNtu/CNlP+qe
	qUtqw8eRmyWGsFGpxX5qVkNdkSkIaUTJLgiyIC4ua5T0vOWgaOp4Xl1gFHCaCnKlv7fRivzZwBK
	z7DNM9PxDgMk0bYM2q1jAOfdCRwhlYmpDzsN/HC4ZOqaoV26UdD8Y
X-Gm-Gg: Acq92OHfcUvEsg4xqpGfvoeos2WUR0pCHq5u+dzzzE/EA5M64y2qWxXHFoMspV+5n8B
	QZm0oe5dNWvM4z6koQEGag3Gla8bdkrwHerg3q8Cxqpyb1AnhiUnzs+4wB6b2udr/Xm50pJaYct
	62g/3aUrh4bNS6oEzdvYNm7NtGf3FvutiBXeSWFBrsEuIEYYN1cbM9fCF5TkHZBORUQhHjKgb80
	8Il2N4kn23CcX2CjLfgUpan9l900kv5x0JErL1wO4BGHstmZnpIa+voZb1UFEHjMhgCJ9tI2K+0
	k2yo8lPZYc3+/k7QnLOHBajHPlG8T+i9mldJt8+upBug4+0TyW5zbf1e2sERAIp4Es1Q7PjEaAi
	Mf+DGqcKXFJFFkOR0AwEbHehpodUNFqFxnExpToHV93aXX69GwvETuA==
X-Received: by 2002:a05:600c:4e09:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-490c259a003mr317354345e9.6.1780953419418;
        Mon, 08 Jun 2026 14:16:59 -0700 (PDT)
X-Received: by 2002:a05:600c:4e09:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-490c259a003mr317353935e9.6.1780953418919;
        Mon, 08 Jun 2026 14:16:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm505952095e9.9.2026.06.08.14.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:16:58 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:16:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260608170646-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
 <20260608161810-mutt-send-email-mst@kernel.org>
 <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wsna51HcyThFG1mUpXcHGI-jIesHQw6maRvA38u_sBI_1780953420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9551D120005
X-Stat-Signature: kcntjod5uhhefnzcjfpjhs9iicsxt9cg
X-HE-Tag: 1780953427-558846
X-HE-Meta: U2FsdGVkX18AK4ba7zwD4oXxVrreIRJKCALwrafKbBh5mAsGqF5o4bU7+x6jyI/D2XB1hqqxl6BJU+X5Qc55maB7BdHrpGMmOpuUSNCZzPZ1PgCn6OSJHB2xsKWBcgNMuGA1nkSeThDfx/Fuw852UoPPf8BIyirpayGVKbR7dTbVfDpbeai9MpXz2iSEfI7Jv07/5kuBjlPwGabmDVsQ2TiawCq6flmUqgZ5Y6cdQjS4ppPclXRvnHNfsfiTInHbPzhRQclo55FdtP5fWK1wmRc/dn5gUQof/Pn+XmgVhzIfaQ2H5PCLskaR+QbLnvknXcRIrEwzVcjGgTC65mvQaqJKh/+hWBzeEuKV3jjkk5YENZcHQMN2nYnC1EaL8PSWCFYu8RmzrX/NlQAZy3vOY27VClXABxiwldvBEfAfOG9R0RaZb1Omq+M8KvU4OFNcY6MfJjHUHvrPZbwjqT/YU2lxNqdCau5eezbOIoO5fOTmppDZEpyLzpm9Waz5q860T67gqFbAc+iqvX/JzBh0BQcTT8HdeIE96p0VnJpShHR0eCSNu3W0+PouZpDrUOixOci21ERqbRDWUhzKATxFMF8bJcbswC/kiRpiImAlEi9x5paxijF4hk2lvNxJPmt6OLQjY2XFRCidaZePnkELSeWWcXeWRfk5sadHQajoiLmUHLDrkmPxymNjEoyqqDijI+Tuw2FmGNYDGorU+gmpCUthXiFMODhbY1PoWWyCnEk3MFpl1qXqzwVUrVLgkOgYP9LZ5HlA52o3wl6VZfhw6jJ/ZSif4/5r4d8eUD56haf8QKFaI9fLnqfWSQwqhD0akvyJqW23TbT9+EKZLWRnhNcNdANR3hNmy6s1QE/P91kwyywKBj0cnD/tnBLLWtboVr5vuzcTmj+fLRgc95N2ceLewiAVh2Q2P4qY3ZOIABE1mvuSCZtCkSrO3HXY0watMtYspQfpLPXh+6cSSbV
 OUbszC2N
 rmAz/2+GOzJcO1cJJTDklvs+qjMQUSNJt4f5W3nnDkdTs+LyN/SzpwbsVgg2g2+dwLQUGg9McCPyWjuepy+H/dELbyynvd9GQeahZCcaEzncxNw3+UNIso4anljypCfCJYOQjNYDg9iVoNXWY/ajsD92V5/dD9aEaiO/igMfsgsXEG6iRA3eu+OnfjXzDA47q9xzMPdnTua/hkvjDTpkik0aerIF6Ic9DSONPZwxoup04Xwb24x4K2rFWq5mpUPPgY/M6I6TxmJ0u7jiI5wEyuLonFFYrYqTlzG7fgC0XdM2sfIMHead/Ph/tvWePrvcafp942uuCuZTOdFPFKSKSOTkn1MSMEoW/30X+ZhTzJZRmdcORN7QDA9bMhJlWHS+tDCJR7V0MUCfmAvag9fRMwodFcQ89NQSCFe/i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:53:14PM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 04:30:46PM -0400, Michael S. Tsirkin wrote:
> > > 
> > > Please consider that this is arguably the most fundamental interface in
> > > in all of mm/.  All we're doing is going through the process of figuring
> > > out what changes here are reasonable while trying to meet your goal.
> > > 
> > > ~Gregory
> > 
> > I don't mind discarding all of this and doing something else completely,
> > but I dislike it that multiple people are apparently now angry that I
> 
> I wouldn't say anyone is angry, I think most folks are tripping on the
> complexity of the set - which has increased (at the request of others).
> 
> > don't address all the contradictory comments at the same time.
> 
> Such is life in mm/ :] - it's hard to known the entire state machine,
> and sometimes the contradictions aren't even wrong.
> 
> > I thought just sending a patchset to show how the result looks like
> > is easier than arguing about architecture, and would be helpful.
> > 
> 
> Notice: When folks argue implementation, they largely agree the
> end goal is useful.  I haven't seen anyone say your problem isn't
> real or that it shouldn't be addressed - just opinions on a particular
> path forward (which is utterly normal here).
> 
> Getting the right incantation of an API is really hard when the
> API being changes is something that underpins the entire kernel.
> 
> > I'm not pushing any of the mm rework, I was asked to do it,
> > myself I just want the ridiculously effective optimization in there.
> > 
> 
> As Lorenzo, David, and Matthew have said, the focus of the patch set
> does seem to have become unweildy (in part at the request of folks
> asking something be done differently).
> 
> What needs to be done now is to break it up into some pull-ahead 
> sets that are easier to review.  Having a brief RFC doc that lays out
> the set of patches might help clarify the confusion going on here,
> especially as new folks come in to ask "What's all this about?".
> 
> As a start:
> 
>   1) the user_addr and zeroing piece seems like a discrete
>      improvement worthy of its own set - aside from end goal.
> 
>      This is needed by your patch set, but was requested to
>      try to push us towards a more reasonable pattern for
>      folio_zero_user().

What I worry about is people can't agree what api they want.

Simply not being an mm maintainer, I don't really have the
perspective of what changes are envisioned down the road
and so what api makes sense for you guys.

I don't mind trying all kind of approaches, but it seems to
be past the point where people feel it's costing too much of
their time with all of these revisions.


>   2) There are a handful of patches that seem able to pull-ahead
>      (some of the mempolicy stuff), either as prep work for #1 or
>      just on their own.
> 
>      Some of these patches seem like latent bugs that aren't hit by
>      current users, but do seem to be doing something subtly wrong?

Right.

>   3) the final virtio piece seems like it should be entirely separate
>      once the core pieces are done.
> 
> It's not uncommon for core changes like this to take multiple prepatory
> sets over many major versions before the final feature lands.
> 
> ~Gregory


