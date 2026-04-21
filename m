Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4C7F8FA6D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A266B0088; Tue, 21 Apr 2026 09:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51636B0089; Tue, 21 Apr 2026 09:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67026B008A; Tue, 21 Apr 2026 09:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C195B6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:17:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6807D160DF3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:17:10 +0000 (UTC)
X-FDA: 84682613820.17.5D2E870
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4C2E180008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:17:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q7T5ho1k;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776777428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCbA5QUc8U2QOBCnKS0mrwkrQW2ZBzuy6UlJpM8eO7s=;
	b=EK7woB95sWFttMqO8vjIMvLtYs8cCM2ngnzpfOIeYNG/FcVnXwT+RefHeXwI4oeYk4slog
	Nn6Wu0tyJwvW5DQUaTbCF6Sczie8E8xHiaRZu2tyELHPt0H/g9C9byAkAGPRY5sAZ5uClb
	78fyUfhXSnL6m53TWrwKh3V0ihHGEyU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q7T5ho1k;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776777428; a=rsa-sha256;
	cv=none;
	b=wWRVW0fvAw2UapV0EmDVOTg95QFxN0U5G5aQ2yBjFqUTYTFw0wJgGVVaDPe3KEM5+PygUv
	jQOh39tyEWnAFRsnr+9r9e3v2TZXOK6SuNb2UWK4rqSMkmB5pwFE+mr/RUsemF8Kqtni0Z
	l1A8adi984SzzppiQr5NUgAo0wcMnsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776777427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bCbA5QUc8U2QOBCnKS0mrwkrQW2ZBzuy6UlJpM8eO7s=;
	b=Q7T5ho1kR1a9dLcFhR/W1QCm4XAEnFfLMAGnTuM12LV155qGAFR4YEyOqCRTu/afeDh6bN
	wa1qIbVdRxV/vSQZ7zjQixb7cWsVUxWZ9J2yBoRl5jDjOpy7Z23BqnHs0s0NU0LL+brwPO
	5etovK4R3JhuY0byvFMy2HEl3cgs9fE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-16wGoEG7OFKw6O7N-dxIXg-1; Tue, 21 Apr 2026 09:17:06 -0400
X-MC-Unique: 16wGoEG7OFKw6O7N-dxIXg-1
X-Mimecast-MFC-AGG-ID: 16wGoEG7OFKw6O7N-dxIXg_1776777424
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38e7ccf2eadso22544201fa.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776777424; x=1777382224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCbA5QUc8U2QOBCnKS0mrwkrQW2ZBzuy6UlJpM8eO7s=;
        b=fCxggD6ETsqdsmtJOCIXO02mROhmjuu16w+4hnkpgN6TLXIgoR7Oa6PAJDiwD7sRl/
         mBszPNWnNWdqvIrAd9aeceZe8lnvAkLSN4jRC43UXQE8F716aIN9b8qdWSPkbBePozdW
         oDtSYW5w/PcjzVlN/UnjdTU3XufsbRWpgOgJbzSy8HaGguKiiYhXqlFr24di/zKsU3DI
         z2qxCkRqlc5LarTp0ApqKfisjqudrLeE+LZL8rab0XsM0ah0/CWwCR1Rze2X8YQwP3Uc
         hke6v6OZpYnWs/rQuAaDCY/CNyn2uq65UdMOa2aTQZchI1pjI5FXnidHVs89VDJs4i5r
         VaGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0imlEJ/7w7fDr1iC7hF4W1/kOlYC4l4Ajf2s0RebAVYrrSkuLprvIu9JIAJDZaQ+CFnHD5l+BvQ==@kvack.org
X-Gm-Message-State: AOJu0YzugiifXpU4GDSix3iwluRGYZdMC3cunsBiuN+KwBBAJUFrH9+A
	tL+NfFwy6EhaIt91dmqbxwoxCNqU1O4U/HpCe7k8EWWgzYJ13XDs/XmJCoiFt4iXpmcGYv1GKGX
	HmMACBM0nEczPjROgO3eCagQHae7VlBNt1kh/uDr1Mo3Br8UCiVbo
X-Gm-Gg: AeBDietlD3qaFIisEi4U+wmcbfarf4S0lx8UlhapDKrkAIz4XIOG9KCWXZH95jg/7c+
	tw4zUcqmPSsO0+W+FO9au88bkwVNZCzFx8f1idkMoLP7XvcrQEnxFxSPxeDPibKpygiAgpglztV
	b7Gb3BUZimCgzNYuPRvZfkMbZd1qVUHFCA3HhbFq8OsUHjLaVF1wPGDnoh3HGd9bFyzmnG8+0bK
	1rdPcWsxIeOYp3Yl31Mz3i0/uFs/SmHonrAf9/888G5R+6VAXkVXeMsBSHKYiF83aKTpTtE16AZ
	XT4SuCHvB6kWPHEoOkz+dpCJcQZU/GMzf05pm2ELvRI4Wxmmd0ITQvcqWCuyx/I2wPaP8efEiYR
	2EDHOeJFclElQtjA7ugsGD4z5viKFAYYhruXZW+075a6gqQ/8lMrYjg==
X-Received: by 2002:a05:651c:1ca:b0:38e:a842:52f1 with SMTP id 38308e7fff4ca-38ec7834d76mr57004991fa.11.1776777424243;
        Tue, 21 Apr 2026 06:17:04 -0700 (PDT)
X-Received: by 2002:a05:651c:1ca:b0:38e:a842:52f1 with SMTP id 38308e7fff4ca-38ec7834d76mr57004791fa.11.1776777423636;
        Tue, 21 Apr 2026 06:17:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb716751sm32721331fa.29.2026.04.21.06.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:17:02 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:16:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
Message-ID: <20260421091546-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
 <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
MIME-Version: 1.0
In-Reply-To: <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: arUaN7k6x7lVAgxGoET0bUk6jjgvgebg33OKuf9TP1E_1776777424
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D4C2E180008
X-Stat-Signature: d1fe5bon98jpcjo4864eofr88cfoafyu
X-Rspam-User: 
X-HE-Tag: 1776777427-539986
X-HE-Meta: U2FsdGVkX1/45Mf8kAfzG9X0LK5i1Q51yXuxdwaC6KdjaVISm+SMlH8GBpHaYL6dkMC+Zcp1S0XqaQEElLWxRMNpEiSAN5Xg2yH+WcFCCMHTzKGEjrwN1ITHUJ96SHbARWW4RagEAi14GwVKl+a3M3Nv0xNv2QGF21VZhFK9D2xqw743JE6/cu+2DflA2MxXZaez5+vSQqD92u0gKHYeYm0Ybf3NRRj3dFGODdte1syHB2kP4FrAspHTbpUHqlS4578XiBI0v3jE8Nd1fn5RSBK05MxCL4WrIp3EDzLQDe4w4wazxrgsd6W1++MacE8M/jINSuzvcZ9a0jnaWm/aAZPB5RZOG5lque4FRFQA7aV2FiCg/e2TggtbjmoCy6MltYcNd70YZ4UCS/iTnEMxj/0rWuMbHzHOTtO0+GMmmGf+tyjts7bJYtrc8WFah9vbcFOiKxrWeKaUZHCMs2MmXR2qoS/fzCpUuT59uLR4iyBc75vp7G9MgiR95EhnY8XzD6INWmAsO7e9j4W80T9abgHsj749YcpGYK0v0CJtqSuYr4XSxBUoTxKlxKdFcKfMGKos3ut9GB3TwICwgmA8IFK8JZsI9HId7ysOiKBeIXMCSQ3fPC+Y6w/d8sVRKDrn4sya6ngNAoeHg1yVIGL8cjOH09pUsLaPW+/h4Sz4bhS0G6utDE2yf+BuYPA58vmNSNyqpxi4/r3k+AXxDz4oeKt9IX5hwcLyGRwBEFTPlVVsjGxMjAEVAQHS+vjVQGNc7BYtrA6dONR25Pgc49zZQQBU1snhokEXEH9imiuN3WVeFZgByj6oT5nnZKQOJb+xd6ktx+uTkw5Ggnez4gKsTht7ocUudtPbBNFR4c59/qHSYvkcDtjfkoGa/Bsb8FwRO3Sjv4Exdhm3RHIFgcJp0h8NgKH8lCMgfNEXUtRj6PWsaTvPYTH9FnClZefZSXSLZGsFaQQNHJKC5flWlqa
 zWEDXxYP
 YbzDn9kg7IKrmiKZA9IzO73N3JSl2C3nLOTMWaaw+H1S7UFd+WTiopSeazHLjVSRXHTmn4zP5pKg8uH+H9BtQMdHvdwd/VgbpZhGMlhGuHT5bUwDbchqMl0RE88/NX7+kwIguKa0dPOwtPuJSoLGfwHDeytThPgvd1FEwZXOSrADDIgw+dENImAF8604tiT7wemA0IUOK2VmxDi6k72Dc0c4P3wZJa94SgGXKO5q4sgwsmEVuNloa/oMzzq+u2vtYBoJZDN2nDYojT+N3zZ8V3wgncFpcsMU8tdDvH2yoyKbVUr6fUuOOWz1fNKslZPCJ4wkHHGwxhQHQGuH9nEA6UNWVUtQSNpgSfZXkMAciZaqYYmoEcTtq5l1QPLe4LdymJART
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:56:00PM +0200, David Hildenbrand (Arm) wrote:
> On 4/20/26 14:51, Michael S. Tsirkin wrote:
> > Add free_frozen_pages_hint(page, order, hints) to free a page
> > while marking it as pre-zeroed when PGHINT_ZEROED is set.
> > The PG_zeroed flag is set after __free_pages_prepare so it
> > survives on the free list.
> > 
> > Add __folio_put_hint(), folio_put_hint(), and put_page_hint()
> > wrappers for the put_page path.
> 
> Can we defer that change?

We can - it's a dependency of the balloon deflate, which you asked
me to implement. I'm more interested in reporting, myself.


> Putting a page with a hint, when there might still be other users of the
> page is a weird interface.

The hint is just ignored in this case.

> In the long term, all balloon pages (PG_offline pages) will be frozen
> pages, and definitely not folios.
> 
> Frozen pages don't have a refcount.
> 
> It would then be sufficient to have the single owner of the page call
> something like free_frozen_zeroed_page().
> 
> Now, to convert balloon pages to be frozen requires some more work,
> primarily to balloon migration handling, unfortunately. I have it on my
> todo list, but it will take a while.
> 
> -- 
> Cheers,
> 
> David


