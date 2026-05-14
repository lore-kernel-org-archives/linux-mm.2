Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8DDCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 15:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBBF96B0095; Thu, 14 May 2026 11:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C356B0098; Thu, 14 May 2026 11:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A6F6B009B; Thu, 14 May 2026 11:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F456B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:47:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 505FC1C149A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:47:31 +0000 (UTC)
X-FDA: 84766455102.24.B4E833C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19D9A18000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:47:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hgzh3q1B;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778773649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqdtv1pQkNj5ZtCXeAHZim6ZUYoMn7Cztcf2yOjIZPA=;
	b=4iwS0S3FBVV8sLt5btobcwLD3Zzz/GzzuNIgYbQaqbEhI8k0WAyQHKBM10dGDJQcN7x6BC
	EnxInS/QwVTHlZ8gnLDXmpPU8D5BRqoYSpG9ZdahctRNn9nDxR/f8vLy067mQip4Nx0xKX
	LSwBWKg+IshNKvmqJGkHTsmGfk+GXGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778773649; a=rsa-sha256;
	cv=none;
	b=vmWK0Mb93JtqL5G6wfLtiQRPC1HaLDDRqASE5u7hbxpA0/ZO1NfZCPH1wLixzvH0Ec2RA1
	7a5nK8MqsS8rkPeXHpdv/ElE8tQ6BVn9hE7Wqohvgv13wN8VBEvlAWbq5IwGoFnQ0pS9cS
	iiYaf/6PXWcuA7BufMhWLhhD1rzG7H0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hgzh3q1B;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778773648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqdtv1pQkNj5ZtCXeAHZim6ZUYoMn7Cztcf2yOjIZPA=;
	b=Hgzh3q1B6on+SeLUhaXlg2qaY3n+0tm+2iP++AHO4wQ3wELAaBXmBh1j7Nno2t4yQMho6I
	dFSlfMezX/n915YPSX+o42HKn/H9f1aVPfcpwqTN24jp+OBSyp2nF/i6T7hPR7qJeE5DjE
	wAIzN985Bz7SRHWiHG1sP6nICEpS3nc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-Kf82tfTTOA2M-LPuVcNAqQ-1; Thu, 14 May 2026 11:47:27 -0400
X-MC-Unique: Kf82tfTTOA2M-LPuVcNAqQ-1
X-Mimecast-MFC-AGG-ID: Kf82tfTTOA2M-LPuVcNAqQ_1778773646
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44b186b715aso5152204f8f.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 08:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778773646; x=1779378446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqdtv1pQkNj5ZtCXeAHZim6ZUYoMn7Cztcf2yOjIZPA=;
        b=I9NHDg9RF3I09fMQYq7BAACuUSQ0kE/2jhhs6iN9iiYCkJjrnMIeoJAxirn2VX4plp
         +M3jyEV8Q+BPi2faBDSa59AUer+tFLKwe519U/MM9AFEDdWUWuxwHryPBRRmowmAVmEj
         gplaEG91cN+XgE4M4M6Qvs/R7ut4lE5Rj6skDKfYkhNtB6Q0AqWesWoJQlr+vafUUNAU
         xJQpoZySw1O+4BYlvzfIOh5iV3GDJO0lYYUsEFfci2ngbcBYYErM/GwaTUT3ZOzyNUIU
         W/zxuOZAa4jHW6pmymlFMRYdccKofCODjHzGEi1v0QP2V8fgxhyWZ89oNAT9tBmlkxsj
         do4A==
X-Forwarded-Encrypted: i=1; AFNElJ86evTQJ4Z0V0llKDMnV6VXLR/n0NY8aL0OypKRppagUzehK5zRof+Z6idBZKwBEX8ebo3wMKMigw==@kvack.org
X-Gm-Message-State: AOJu0YxWuYHnECVUVodJt4f/JwbIMqFGOPehvMn/HkkamvSrzh7R41Ik
	47jg6npHhpz7y4APcy+wxliME+qFXLNdXHRoKVu8Oiqam1zxATs1IuqFZcw5OiYcRYLrtl7LmP1
	DN0KwJQSG6b/xO6WizuIgAfGnuRNxLQdY95AkG248ZFjj8jxijsHH
X-Gm-Gg: Acq92OGr3vRTrZ4NMGM0nj9qL81GyDzXWwofn/Y+VS30R3fn0+MG5YcH7JiPF+pntFg
	FmCFt0dX7WE5rwut8KIkYpnt7m+JVPLL688BbOSFrIvkdHgiJgmF197hne2TE1mYQpXQfUlURXS
	vTicmIiWjAbSdxzDFug+sv5cULpBYdguEUjnrIsnBFSg57poDvPenw193qmVOoIUsVtr/mcVyQg
	FadGkx9VqtXNaMYjQUMZUYoltf00h4HtyyAB9CvFBNQdxagqg8muAnxIsnDsvRLLmfazu0UENJF
	tldevO34EMgpTjmBsSIvMsppbXmMInF9VAIm5UuhT0e36Kr5mvk6zTnbUsINzo+Oxn2mMiFRHP+
	+qOX3eR7j9YpMFfywmYpDEXS9IeaUwruVzybIGrOZ
X-Received: by 2002:a5d:5f45:0:b0:449:a07a:967f with SMTP id ffacd0b85a97d-45c5a1a8e93mr14113734f8f.28.1778773645860;
        Thu, 14 May 2026 08:47:25 -0700 (PDT)
X-Received: by 2002:a5d:5f45:0:b0:449:a07a:967f with SMTP id ffacd0b85a97d-45c5a1a8e93mr14113648f8f.28.1778773645241;
        Thu, 14 May 2026 08:47:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm7555351f8f.16.2026.05.14.08.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 08:47:24 -0700 (PDT)
Date: Thu, 14 May 2026 11:47:19 -0400
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
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <20260514114637-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
 <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
 <20260514113337-mutt-send-email-mst@kernel.org>
 <agXtOeuYNin9nYN8@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agXtOeuYNin9nYN8@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rvSMb44-P7Y3JjqfP__5qo4L4m0fWYpLSovSm2pGO-4_1778773646
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19D9A18000B
X-Rspam-User: 
X-Stat-Signature: 4h9k9dogcu6wbsteyoq9xn3zyai7osyy
X-HE-Tag: 1778773648-401703
X-HE-Meta: U2FsdGVkX1/reMggUoS+UCvPvyao06046Xp/A9YYTcvNIJxalpoONJuwBKXZobTl7O01cWxVnabq+AqcjPvXi/8sX/PvxFFJNRyaSCYD9xwywxNS3VX15mQmPPVad6buzRUi0Nph2rgUef4FfRRDPd702rKBtElBxYXUVneX8FD6iwOBTdEEhBl/1DsSlROnrh4aLddMJ0RKqyiysopsZM3KX02Pp9bEZuDNfiQG0Q9M01YaGh8O5Y7G/NvlLfxbB2uLJGYZCAeUmty+LcJX8eO03QFCY6aI+kVb0xNwYBl72Z4ySrq0XPv0NQl2z6l/58gtP8BJJfQaAUXSU1SbABcmkC9nWEEBR9tsknA7z4p4pQlrb5sZcaywVBSFWHuphDpyvs8YLCg0eXUboko0FhdbbNerKPQ3/+wXq2Co2klhXD52i8JImU/ZInJMK4qV0oJ1bNt2+AxQT5dKOy1k4NJXubh5hbxIRzFXbeHD+ZXZ9m+5yNRjteqZxvyhv7P+NZlgzE0W7IB7wgSiwJ3SnmAcb1//2qy3KSdXhVhQD6dG4Fir2lcdJ9P6IIj5s0TsiAC5AQC9bvZLa7hdfOVeVSi3B89UpaFquhNmxB1ztoB4qIT/AV2iX62nOz0SrhAhtWB+fCwqwngkpkeKyTgdeprYrIC2XVjvRnyqUstaxk5Vfv5fdked3oLMmCrMiJsgcGiU81P5b2uD1FKmDVyx+cNI3FgVC6M/XntmujIMryZhrjJmRcfqB2bmQU2H8j2qd+T0uqvfFeQzmBj3k8BvKzuBfUFvNw3wB7qSRK/5UGYDJgam8Sa9HrdE2M4wSXfaecwEIue3x7zn2wV9I3likk+sQEkdi0zGKjgoGaVICh0T9cXx4FLgwkRQMjulRRjMl89vvBUlxki/aGPVDYMhYGBbG+j8NJipcLoaTq6EKVWULCMdJ3kOkLxTkUa+eUqCqzmsHxK8bWUwOAdNq6j
 0HeHf6QB
 8h6oToYKCEDM7K6msq7LK1pubEHrKRu5EfwgNJQdJYG1b8yxDSOHYE5vYuGkpsEewcI+jvqyjblo4nW3FjjYW1gGthjoRpL0shYoil8yIwDbI+VXHeADxtmEJy3h4waZN0lsrhEqzAarfkUIEHAqyVUkqWNB2G541GSL13l+1gP5v+i0a4MCyB/Stgosj6Lc+s0pgXn9kKhoxQSiG9ETRxMbjQR1P2gTN57WsirTmQBxlh7/qBFG92I9m6HObTGfAvroc5L7XCH9Kdsg6nET0Ud5umWnrSyt7d5456TGISK1VT7+tn019Bt5fvlRZUAkISajkGERWuIubHK84/2rFi9d3ldaymcWvX0kiIemPL0iqA0aYnrK/DWHLENTLAkRS1vN7vvDrFa1mhyxu2V5dRch9zP9zFomLBJSF7dU6PZ9XxVBlCIZ2jRRiyePMpp/ts1baWdBXpfMeZfrm6eaoQxJM3nIaeA/PRH6hQhSkywNU5eVa/fCqPnXqaAg8f8Bnm+BQYnHEXrKefOqXEU7c4RgxvpfDc9VpjJbBrKRcz9ededQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:41:45AM -0400, Gregory Price wrote:
> On Thu, May 14, 2026 at 11:34:14AM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 14, 2026 at 11:32:26AM -0400, Gregory Price wrote:
> > > > > 
> > > > > Maybe mildly out of scope but worth asking:  Are there other flags that
> > > > > should be retained/propogated on a split?  If so, rather than pass
> > > > > was_reported, should we just take a temporary copy of the page flags and
> > > > > pass them all in?
> > > > > 
> > > > > ~Gregory
> > > > 
> > > > 
> > > > Not that I can see, no.
> > > > 
> > > 
> > > You do this exact thing again later :]
> > > 
> > > https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/
> > > 
> > > ~Gregory
> > 
> > I mean yes, reported and zeroed) Just zeroed does not exist at this
> > stage in the series.
> >
> 
> More of a forward looking question: if we already know we're adding
> was_reported and was_zeroed, maybe we should just pass the page flags
> through entirely and let expand() check them instead of passing it
> through individually.
> 
> We end up doing something similar with post_alloc_hook later as well, so
> I'm wondering if there's a general improvement that can be made here.
> 
> ~Gregory

sure, will do. do you want a bitwise thing for type safety? or just a
long?


