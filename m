Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F1DCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 19:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D586B0005; Thu, 14 May 2026 15:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497166B0088; Thu, 14 May 2026 15:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336DE6B008A; Thu, 14 May 2026 15:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5D26B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:08:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9157C19DD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 19:08:26 +0000 (UTC)
X-FDA: 84766961412.01.FA45091
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3EE6C40005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 19:08:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WmO7DKJb;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778785704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xKMY0TqKrMt3bc3tXaYFIaskKaQVgiNDhgsdldGKxw=;
	b=I8WKIhTkU2XtSp2UlXGrepPJH/EpTVjlK+2ZCMaAaGQ1CieUIJmLXp4pG3ji5V/AaRUTQ/
	7iYvrzBp1bPjBt0U+oKskH+4XgwV6nmJ/jEowNBnUeTG245RS/Dz08HjRDJaxP1+O6lnhy
	KKvj+6QXb9iAoaEngsHt9HhtRifZAXk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WmO7DKJb;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778785704; a=rsa-sha256;
	cv=none;
	b=o5rvMXWtsVd8MMBxGlLk0w2lwTmzjUSIWt7sH+aTfq7vFTJZJPgsZilOcZz9VHaPuCFkaz
	zfcXU6oBft5MMglcIA+1nZgvIlQD6m21ow0upMeg+zwraX4ELfu+2yNn823YTAB/+Ep3l+
	sVwYpqOq62txjhcI9NWrO/FlQf35OGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778785703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2xKMY0TqKrMt3bc3tXaYFIaskKaQVgiNDhgsdldGKxw=;
	b=WmO7DKJbfZSfnQYgFHcA3+qhIw1DDUbW8NtKkl19akqL05uzeX0G7j/UneI8CY9TI6AIOz
	AICaJH+mFxI4VJHXZcQrE+NlcfdMspnIOV5xo+e2g4xrcr3xhzcET6UfZqCEDijkCw/gJV
	CuBmKTCV8hIm1V7xpdjG9a26ipmLh9Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-3USD7cs_OpKdd9XCqh3dpA-1; Thu, 14 May 2026 15:08:22 -0400
X-MC-Unique: 3USD7cs_OpKdd9XCqh3dpA-1
X-Mimecast-MFC-AGG-ID: 3USD7cs_OpKdd9XCqh3dpA_1778785701
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45aeac88af4so2773601f8f.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 12:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778785701; x=1779390501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2xKMY0TqKrMt3bc3tXaYFIaskKaQVgiNDhgsdldGKxw=;
        b=EtMrDiT9Jkcw/ZkzS+6R+HaUXjd1i/xctvpt7jAUBdKUhSJyl8Islj9KdOkRWmQ2AA
         0NPCoIEAEYUi8HR8Gy75il2YxW9xnxTZTKOJHUBAjt4K3hJXBS+L4yV0XxhlIw1IPc+T
         pAEzif+Tnqk+MHIXxMp2j5sOEROtDcN6A0MjERUhsDsW/K9cbJFg/+TJW3rPv6LOw4Rr
         U41mncEAd8wfnNhm39JzS7GMgSga1uGRKxo3nVXt+uqVnq5haYrAbTKDNjtA6Ekrk0/6
         iChwqoiurK0Y9hvisJryxJexr4f5vGKuAznnfrI7hCcNLUWnog9w0EakanxkuhkwJdef
         6jpw==
X-Forwarded-Encrypted: i=1; AFNElJ9FZNBCdMGqywV1s8XrbY8JYdHnAdIDadYKkiudo4WLPOXyvFWfvhsCsImSAE0JONJsUEc5zGD/Gg==@kvack.org
X-Gm-Message-State: AOJu0YxMfmKqQ86wE1g/7w4QSsPTsqN1Sqg+4CeYdPdD/OJZ0rcYF9nD
	wZ6oRbZoHosZqP7THEGr8Mf0j3NtM7BpDDAa9VOulv+3jOKku4T4677BYD5vL721YTcFR5REu0m
	/ybfHYX3HyehY3ZKlURIyT2kxU7YS3GyIYnHGKIItzyVT26DOzPd+
X-Gm-Gg: Acq92OEBiywTFf0rdBhJTv5ZxMTkO49sHhhD7dXMtGPq1LtcHMFbdIQI2O7J4eTtdBF
	Voc9JNDtcV5wLPOg+f3VnDCJ7ZS0VSBiZAc6P9VQmLckW0dVtu6/xLrvnu1M+UaqI6B+BV0PxkA
	I8Q5NBn/w0ma6gcxiuQi3vuB2iFtiLuAXWCbV/YRbhsNrFtNJlMwdh4xjKFw1I04zyWg4fT67hM
	nt6W8ay9vYLfTkohdstBOnXeSwmyXyJQvj3XQt1G+SxFFTY5PTRzdTtsHjYDGM/BQrnUD4XOz/M
	DDwNje1HXRa3v4BKFTXLHpHlApYUvtp2dvdjD+9lQU+ZSghytCmh164287d/jnlxcO2e5HKYTbF
	B9beFhvlTSd8P8NRLoDLfGW3rU/sUrI3uzCO+DVFP
X-Received: by 2002:a05:600c:1512:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-48fe60ecd67mr4945855e9.9.1778785700672;
        Thu, 14 May 2026 12:08:20 -0700 (PDT)
X-Received: by 2002:a05:600c:1512:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-48fe60ecd67mr4945575e9.9.1778785700166;
        Thu, 14 May 2026 12:08:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm8558986f8f.16.2026.05.14.12.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 12:08:19 -0700 (PDT)
Date: Thu, 14 May 2026 15:08:13 -0400
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
Subject: Re: [PATCH v7 09/31] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260514150750-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
 <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
 <20260514135214-mutt-send-email-mst@kernel.org>
 <agYa9s5B7OWG-kjR@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agYa9s5B7OWG-kjR@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7kj4R3Wus_ZORcldSpiiH5OHwJ_yFA0q4_JezU6Uptg_1778785701
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EE6C40005
X-Stat-Signature: da335c6pw8o9n4wjsse57xhwsdyokpqi
X-HE-Tag: 1778785704-943690
X-HE-Meta: U2FsdGVkX1+/Plmg5y1jqt76eHQz7xhmMtVoSuzi3hiCR4i5KufDKO6IDr20d9TofWYIorbrVkZ2GuSr27XYQ7bYRNJOjh5L6npc4paKUQo7mA0z3cCprYqkpnyoSyynXBdAanCnZhXzgdBSvEj/M4bbSbIwhDemj8w4T28Jfx7JUwKbwpF+fpWvQcmVTAQhAHattLkA3KOfUiL3bPZpQuvYey5p7XpYM7UWPLvdxkrY2g16zMNaic/TVyj6tJuPg+ueZ7N8s7XUs0KnX6oMXbCBb0s/PMfZBeO1RwigVAndnUuoU/Xki7HGg/xUwbrFT2tSNgmNzIuS1P+gcHrxQx24L/KVhg7n7c6++svNjNhagdqdn/I3E2Tg+xntXTUV+4X18MizcgtG9/DtLY4ZXGmTk7ffNeXDTHKwEOa712pmNxDeYh6I4dIvyhRzd9EHq6n87hZIsLAZPXAalKHqeKVbgyiDT3FH6QebFWYeI2GGCDaOr7JEXcYlFY8EdylQLqY7rEw477jqcvncQH8Xt+chrWOiWhqcPflpZqt5yZrI7Wx4zhqGrDlNnfWajp9XbUa7UGqgFuy1t4W0CD4p9dx3Qm0N5VAFdFVcvoLFgKZaNGc9zS1eKcLOOTEfViQZOfzCKy9w7+hPm/rWWfcTBuJWzefpIPug4Q3rMnGs7XC9gpP9ZHjNteybxuDQNxXKpV8fBoY4Pk4qSjSZVvVYDHN4E6lsJA4+x+aQpo8c3F3usNfQrB4rcYryG7myQdo0rFEI8VHEK55ttrF71xSWiSpM0HfDtcOqNrvJB71DRjfbnve2deC4Ms4K2/DVz9I3Yz75DhtT692IiWvvuyVTaM1CZeKvb+y8y70scYFldOxIwW63TGODXlw6nM4tWpUHO+5s08bErHlWvhGDf0/He19AlXpKf+16UFHFMohA5k1vSzPBgyM0xvnBvwiH5/ObRBms+Cio+5sdC0InyfN
 98ME3R3I
 l+CDTJUaBZabbc9WVnoscrDL/SHFVZ6uEF0y8hHFKemmYZK5WLXe9sEFBgpqzj1wPhMnh8BW1yljTzJ4b9DCzzA69AhjIyp4bK9BLWySMcNp6W+oTDIn7uohEMMih0zUt4KGwn8QGbfatZw5D//cvtEYNl4V70W14W91F/IQ1lVHJbUTjCc+fcBkUi0vEn9WlW+qq/tFPAZQQ8iwW/SdmieRuGX9sPFdDxoG9Ww+lDenmV8lcx5yeRCpc1LPguoeJ37QsBp0Y/EenYYGbq0d24SbO1+ztH6+QpzvFCdJCUKfG5ghcFUj4o4VKggBBQs3fSvg2eqRYzI+kUg3IRu8DtM9eAqjv/YVY3YbvBSXj3qwRlu4MOp+LoNVLLwZZHZYm3mHO1fKBvpx8n4O6a1adqS1ilvxVQ2qZaZSQeDc1ghIQQTLCnaXVPi3anYIhWL4ACrAHMOtpJPrkj6pgxzqywuty//QzWc3zjfcoh1eyYjN5x4KCvPScE/CsKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 02:56:54PM -0400, Gregory Price wrote:
> On Thu, May 14, 2026 at 02:00:31PM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 14, 2026 at 09:49:33AM -0400, Gregory Price wrote:
> > 
> > There are calls with no __GFP_ZERO but they do not allocate userspace pages.
> > 
> >   - drm_pagemap.c: GFP_HIGHUSER -- no zero. But this is a DRM device
> >     page migration, the page content is preserved from the source.
> > 
> >   - test_hmm.c: GFP_HIGHUSER_MOVABLE -- no zero. Test driver, pages get
> >     content from device.
> > 
> >   - mm/ksm.c: GFP_HIGHUSER_MOVABLE -- no zero. KSM merges identical
> >     pages, content comes from the source page (copy).
> > 
> >   - mm/memory.c new_folio = GFP_HIGHUSER_MOVABLE
> >     - no zero. This is CoW, content is copied from old page.
> > 
> >   - mm/userfaultfd.c: GFP_HIGHUSER_MOVABLE - no zero. Content comes from userspace via userfaultfd.
> > 
> >   - arm64/fault.c: __GFP_ZEROTAGS not __GFP_ZERO. MTE tag zeroing, not page zeroing. Page is zeroed separately.
> > 
> 
> Right, so in all of these cases, it would be just as correct to pass
> USER_ADDR_NONE I imagine :]

Hmm. Are you sure? Isn't the address used for numa policy?

> i.e. the user address is irrelevant, and the caller is responsible for
>      sanitization before return if it's relevant.
> 
> Otherwise, passing (user_addr != -1) the buddy takes care of it for you.
> 
> Just an obvious security bonus to all of this, but by no means a
> requirement for your set.  Just an observation.
> 
> > 
> > I'd do this on top if possible.
> >
> 
> Yeah reasonable.
> 
> ~Gregory


