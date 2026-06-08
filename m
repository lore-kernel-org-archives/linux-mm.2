Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C9F2CD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7A86B0005; Mon,  8 Jun 2026 16:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F726B0088; Mon,  8 Jun 2026 16:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96546B008A; Mon,  8 Jun 2026 16:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B98756B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:25:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F8951202E2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:25:14 +0000 (UTC)
X-FDA: 84857874948.08.457076A
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9357040002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:25:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FWahhTTd;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780950312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CLdOd3zAkOhu7t1Gmww+B7T7VImh1oQ+8y8VHy5V/0=;
	b=LCNYyRkcvRlg2tWkrjyIAlMY3dTEsM2TyHJ58KFyOAgeSuW1bjhI7OtVkt4ywjoRLVMxpG
	9WTB6xGm00g6dDtrgsjGevFDRU1lJdI1CuErVj6P3UtooKGKcO3+bezTkcV+F7z0++ru7H
	s3QiSt52w3OKpyGunniXhNxnWja/TXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780950312;
	b=E92H2jgViINiGm8Gen+/dDounbWb/4kf8JtnpP9mvyCnD34jz00q/f6QUYog4Cga/BD0gN
	jr/4uOWW355xDciTCwRX5tzS0b1dcE6dRDywXQZ7IaBKi2VTEXhivPoByOHvV8/u9OMpy6
	oFYYSkFsI7WNuPQ5h9fP+xzgYooJasM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FWahhTTd;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so60380856d6.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780950312; x=1781555112; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7CLdOd3zAkOhu7t1Gmww+B7T7VImh1oQ+8y8VHy5V/0=;
        b=FWahhTTdRuJ5NQZx0VBQSIZjrXa7EtwBzgnNybIE7k07Q8MupqdAamGEVzymZbijq8
         W1ktCXe7MzBP4Or62A1NcmVRLXFVD7QkCNNGBRWMENHN06S+eulcRrl4msXgpVqvs76v
         dWZY7flS16OsGsokjEy7mTqz1FycYcuZpW1QYljS3zV98B2zn2TPMj/h9nzrG0dyebZs
         6eNvE5pQi61WkpACX2EvItAJqsJAvIC30eu8xh+fzhWXglZxvMOK8vUye0Qetap/gTlD
         knr3/9/xd4pD7teInmS+FCUN2PReRlfYiOEbmOJ9DZ8VxTI3oc1ViwVFpAmYOAz2ya4o
         vWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780950312; x=1781555112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7CLdOd3zAkOhu7t1Gmww+B7T7VImh1oQ+8y8VHy5V/0=;
        b=HcRPiugMEMvqx6xYWcjCtsTNhXUIEFcLseesd6y/mbuvunmV3cF2YKngvjlXK92PUQ
         U4DYc/yX+wP07S2ZLsz9puUBrucKcyuxusDpAPfo6BU7VsdP29l/t14tdN5MAxfsu3Cf
         fjKfqmQkTIkqo44FLtLanno6WP45Swy9C/kAEBhH7ZddEGnHe6INcGhCSsY1N8fYSGRu
         NIgIol/ePBM3L7jIM/xHogVtT2MohIii6k7D0tZoDYleicUvmIrgHaEktoNG8oXWB3gD
         FupvTIXjIpalAGhOS87N74JRnLhBdrhndgRRhKB61m3omukgl91p3bXVJ9f7Jny2SXTD
         613w==
X-Forwarded-Encrypted: i=1; AFNElJ/vtN8mIJG75pre1PDmoTM7+8IlE/x8ak4fcBalXtnZZSMRJoiQ90898EF7bngkpidKSZFNdiPuhQ==@kvack.org
X-Gm-Message-State: AOJu0YyQ5kfR6WfIKun+/sCLa2FAVylhPHNHu2ws4i0OHiGMHIw6BEfa
	2Lb2aQL6RkYQxLLF4I+QNoQktJyNmGMv+FQ82p5ubULlTv0U90otw1HLia1lNMjKQXM=
X-Gm-Gg: Acq92OH35sVJ4jZc//v3P5NMuaM6Odo5Vc31o2N6n8ASA0gz71tfb6buIlzw9mXhsMc
	63DJRKjN55Yc5bSKA732mHVjTmiZQ0FRfy4EqYTGDc8WXnF7wWNJQT6egncCW9h5Lf2cDtXveUh
	Xa0kp40kM5zoNmiKtxt73zBJYhW3uB3t4Sja7ijNa4xwl1GjJgTVZlmdkCkMkr8dokqicqDP/xa
	O0+QdBMSOx5uvKnZ3Mn/gLSltvloW7QCqgwJ0atqFRo19rIqTszdZ/yISFcBOCcavqihLvLsGKz
	QcBhXWCHIni+a8BMtW+u08x3axdbnqZ9mooPbi28v4UBWhui3sUD1vm7t/bgLnkWrm+xyfqXFr/
	CvP+/NA4OHsKB4LSwUDv2hDAERAGWvcj6P20iY6bnTWyuYPfeG2UmWWZ8XO3NHsY81q5A2jQhNX
	cYqdqHkq39/xsDI6Kamay9OoJeQJMgon4oNXvjBpEDS5zf798FoqDKVRiE3/ML+VrXpc9ZiyqBA
	/Kvq4nYvbDXvcy7LA==
X-Received: by 2002:a05:6214:2aa4:b0:8c4:edb4:a44a with SMTP id 6a1803df08f44-8cee62657aamr283094386d6.23.1780950311379;
        Mon, 08 Jun 2026 13:25:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd0520d3sm177019896d6.27.2026.06.08.13.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:25:10 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:25:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
	Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aiclJGgB07L3rV-P@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
 <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
 <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9357040002
X-Stat-Signature: 8ucuu3ojbjxohwt19hp98cj79wqcti6h
X-HE-Tag: 1780950312-235896
X-HE-Meta: U2FsdGVkX18lw1WcJJumLUGkCLnCWqoM1cwfmbXldqgM4GLeyB7ar9rDYpFD9oEqPu6jTVMIPtftrUgLUi+5LRlWJHMC6u35aQUgb4UUN41RLQ3F7BkbfVlpl+5We0d0LHgoXA2H16q9GbWZwZL/XKlOq2aQBaPccWy9hURiiMUcD05EzSujQ2uDcwPtr3S71ZzC633HQRsUZyQEvwaZTTgY51Mex6aogRRCN5oQIn/x35rwJN3lZ2RcsJigNGaB4rVqr1pyXCxbOY98icC/Uhh14n1lb6IAePOMv653YmdZkeA9M2x/8hoJRHa274FYsO+qXd2WUCqx5osKEd25ScXs8+hz+QjPThj9cWriB83s6a+3lbJj0WjdiuBNNXnDx2R+PFZAaEBpmIvuF/zZYK5n7z7gtSjE7UXOWNf82A3IpHGO0Or8RRXKXSEi6HwEw/gw6GE4dg/+cQy0zyViQrSx6AFt6aXDwMrvdRZrzkDjGkbWOrEiHw77S3LF5ttaLJsKRG4Rnfi9C//aXfM16g1ULek9q7wf31OXncZGWq6jsl1fscNUbfTC5dSf2FetnPynIvVM1z1vEIBSEiMre1TD7TynFOiMls9hwI6X2TZkk0rAfZGx1Q+Hv8a8J9YZg/7muJODe0oxAf35100XsLeSCi4e/z2tC+0kee8HguSv2kpojs0C2UKoBea7XQVKak4MgXslHKSNh5ms4ZsXfXwUamQfnrWiqx4IVmvNC4isq5mHpH03b3a+tb0r8fy681DOjP8N3o7hnaGC7R0/9TMbJShXLptPxsOk7BCRWXXjaxGCKMs/fFCDywEjfdnRXpCi00y/f5HWE4i/nHA4+iVTjCTTikrDkUROdBCvtzOIYAgCgUSp0jorFsthEBmejW3HtrT0CY4nbhbhhVqUrOhmqo6KPhdB3NvWWBp78Itg7iUOh4NbNPiUQoLvQiQFSM1VniDzeUP0zSpbni3
 6D0NwdTc
 0vUyt2huAtzDPtd/hooZZse8nCdxz1mIOtSaNBNIbe3KBCALw8lhvKrtyLEYrdPkm8VWrcjZwDptgX5aFSmbqXSQhi4CqWOy5fwXn/u9YveB/QSrcKBcfvd6/WqHVg4NadThNBLlPrzFQhKvUMv2C0aS+MQQMO5AlRFl4+h3oPsbWijh+RdQfCdc6Fe6E0BoDweeHSCrKmMSParVt62D4hjzve7dnDFAeTC1GW1JyKzJf0TkD5X5kfo0Ock9Vyf+m7TF4fjB7C0ssc0ZN6tpHmn7ApI3LojxFFC2+XNmDcfLIY9W6S7oyEmhThC6nlmXcMN2OpcUW20u9n8BAqhbI7625Dmpi526DBPrY7uJVSfekbAG3+x9xYamXqWMsnrFxv+P0zhHW1neVnpVa4Dg0XI4eex3VDCqZs5Eoi3YUK+2AdEOsM7sb3puADWywA7MfgqppkRk4GbV0YmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:52:20PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 15:43, Gregory Price wrote:
> 
> > On Mon, Jun 08, 2026 at 08:39:10PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/8/26 17:27, Zi Yan wrote:
> >>> On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
> >>>
> >>> Or should we defer zeroing after a page is returned from allocator? So that
> >>> user_addr does not need to be passed through irrelevant allocation APIs.
> >>> Something like:
> >>>
> >>> alloc_page_wrapper(gfp, order, user_addr)
> >>> {
> >>> 	page = alloc_pages();
> >>> 	if (gfp & __GFP_ZERO)
> >>> 		clear_page(page);
> >>> }
> >>>
> >>
> >> Not really sure what's best here. I think we'd want to limit the lifting to some
> >> internal API, so it cannot easily be messed up by random kernel code calling
> >> into the wrong API and not getting pages cleared.
> >>
> >
> > We're a bit in circles on this.  We discussed explicit interfaces a few
> > months back and the trade off was:
> >
> > a) add user_addr to the existing API and cause churn
> >
> > or
> >
> > b) add special interface like above
> >    increase the buddy surface
> >    leaves open the ability for users to get it wrong easily
> >
> > If we forget VMs for a moment and break this step out separately, the
> > core question is whether page_alloc.c is the right place to be calling
> > the folio_user_zero() or whatever it is.
> 
> page_alloc.c calling folio_user_zero() is fine, but my question is
> whether we should do the zeroing inside post_alloc_hook(), part of
> allocation.
> 
> What I propose is to lift __GFP_ZERO up as much as possible,
> so that most of allocation code does not need to care about it.
> We do the zeroing right before the page is returned to callers.
>

essentially we end up with something like

alloc_frozen_...(..., gfp)
{
  folio = whatever(..., gfp);
  if (gfp & __GFP_ZERO)
    folio_zero(folio, -1); /* don't do cache flush part */
}

alloc_frozen_user_...(..., gfp, user_addr)
{
  folio = whatever(..., gfp);
  if (gfp & __GFP_ZERO)
    folio_zero(folio, user_addr); /* do cache flush part */
}

The downside of this is obvious: it's easy for developers to get this
wrong and call the non-user interface for user-bound allocations and
miss the cache flush (that is only needed on some archs).

Not saying that's a deal breaker, but it's something to chew on.

~Gregory

