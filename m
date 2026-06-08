Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7CECD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965D76B0005; Mon,  8 Jun 2026 17:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916CC6B0088; Mon,  8 Jun 2026 17:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEA76B008A; Mon,  8 Jun 2026 17:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D58E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:46:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06FEBA02FA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:46:39 +0000 (UTC)
X-FDA: 84858080118.10.EB09DDF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id A83F520002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:46:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VgBb/HTH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkj4BDKvd6RLxlrEHJrrkFJg5KJS8ZlmkKTYtWUT7OA=;
	b=2VOqF8O5t/mB8i7MAz5WPMjX7HjcUxQVAJ3JhsF5dn6RQqMuu/UsOlFTnQ1//xzOPDaTdI
	g3u2KOHkKT09466xVgE7u/4qyFZYhj2ABmCprLa3N2X+nPbkuC2xpsGY2Ou1EOzZpZKxCv
	trQUOfo5ZEeQ3E2G3MbGltgwjNQnq9E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VgBb/HTH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955196;
	b=k+RZnjyOAUoojsPvEhufM2Fc16DfE3PNg6duY2gy+xAu3fPwKjJLplnEzqA/ka0GKzGsAl
	rBpmkB+c9MlL9KwfIpFPw5sGpCoGG2MKyf1k+vZMvY0Kh4bxazu+f8D03w1GgAigGYrNHJ
	u2/3tcRbQ9Jd4jg/piECPuNrl63Xjak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780955196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkj4BDKvd6RLxlrEHJrrkFJg5KJS8ZlmkKTYtWUT7OA=;
	b=VgBb/HTHN8nunwQMupt8R1zdCWbgkoU5fAqwl6lqE/uY3D7GnWn9NcQDxw/dQajdjDFZmI
	GrZU5r7OBqKENe0AbndTEFRh0MmwY2xUjPTzcsBkASNBPxhdRH/vz8jNsSlOBds1LZQsCS
	NzZ0X+3k2uzUEwpp6r8r6xU/8Wc4uZc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-aajE1oruP9SgqHHl02LDXw-1; Mon, 08 Jun 2026 17:46:34 -0400
X-MC-Unique: aajE1oruP9SgqHHl02LDXw-1
X-Mimecast-MFC-AGG-ID: aajE1oruP9SgqHHl02LDXw_1780955194
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-46010392f89so4379559f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955194; x=1781559994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkj4BDKvd6RLxlrEHJrrkFJg5KJS8ZlmkKTYtWUT7OA=;
        b=cyjRzo6dBw/PqpfAfW4x6Z0vE9o0jzu8e/5Sk7HwyuzdO1KxkqCBR+7mCy1xgCMusq
         fXbYBSruh7xxV3CbvU45GvfLjrjCo1QbRh77JY+o9QGuJKMmv40XSrHL7kngqsjDChH6
         zrx8t0I2ITO2BvAcfCPRRMy5YkPLfnDUucnj+44WwF1ToNXTuewzrvaX9spZWHT0XijK
         PIRWJaWHTIFoMY7hQbUcGHeJiwHaKeOxb1iYYp/9w2QsUNiGwPVSm/qRNeDLug/uvgQN
         FaVITQpom2qGHcQBLryGSmSAxbVvh61EDkQqds6fe8AB0IaT8z/ClZiZx4yU+3jghgGu
         ykKg==
X-Forwarded-Encrypted: i=1; AFNElJ/k6rPQ+04rYK3VQ9uegFVyB/EWX49016ckEZfoAlvEDSeQAEYa6LzUudZrX0PqJtyReKyVC+MYpg==@kvack.org
X-Gm-Message-State: AOJu0Yy13EW5NBnHQ4k8rbkB3Dif7og4WH4uvMkPwT50W/a05Zxh4A7o
	pDdCEwGOBClnJfh5DEJA4IUtNPoKoAoVjqMbM5IoYKePLYyJ8QfVSc7zCxgz72LijPa2Z04aamR
	8NQ7vs6PSGDiGws4OGr0s2bovEe/g/et8DyruDV++bCqCpb8FXsJv
X-Gm-Gg: Acq92OH1rsEAdYVdX/7DDgXhY02Xqge7x23pDZCE0UOvV81EJ7BLj1qyx4QPLRtJ7kQ
	NWtaGjpQ1n+VIz9n37Bg/liTNOlj2W8HESztzxkMj6SVNVgDT4vxLQCha9ALKGTIYaAm0c3FNWo
	J19kSVwzJGHzmnK/O7PEaspYXZMgaVNP/5558RdJuLDSSfNJzWLLn/tq5hb/NtuYrW0yHWuOaF1
	H89PneAAee04L0B6FnSMDyut6K/yA3n2q+iCgEz6kiZEEs+l6SanQNqdiEjoyqEJnYwWCwvPwOt
	OaIa83rukQ+kQOrgr+h9gZKCj8hOGrQqOragNbTagSpPrcTRwqpb88FcxTK2Sg6t6ccf4j1TEGp
	nidQMISq/IrbZncnAVf68B0nbGWolxtWRjvbB+OQypeCCQ2KIAdm33Q==
X-Received: by 2002:adf:f911:0:b0:460:24c1:db8 with SMTP id ffacd0b85a97d-46030777545mr22264713f8f.38.1780955193530;
        Mon, 08 Jun 2026 14:46:33 -0700 (PDT)
X-Received: by 2002:adf:f911:0:b0:460:24c1:db8 with SMTP id ffacd0b85a97d-46030777545mr22264681f8f.38.1780955193058;
        Mon, 08 Jun 2026 14:46:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f5612sm53618998f8f.15.2026.06.08.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:46:32 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:46:27 -0400
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
Message-ID: <20260608174430-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
 <20260608161810-mutt-send-email-mst@kernel.org>
 <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
 <20260608170646-mutt-send-email-mst@kernel.org>
 <aic1PoxSiHzZ40Jr@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aic1PoxSiHzZ40Jr@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 23qP4J1V2ojYdiXqNApSvvBjYDBMJYn2okYt0VsK4g8_1780955194
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ixbb731j1x9spfjjw1zggthhbmm7bjto
X-Rspamd-Queue-Id: A83F520002
X-HE-Tag: 1780955196-651336
X-HE-Meta: U2FsdGVkX1+kj881927vAtDJyzaLPO8Pbm88rlZwx38oC5gJfUWkiY6ENyd/alc7wDq9sffRsbnNP95Y7zAwo5611rwXY6FDHQvd/R9UVGobJbaTnjMZaoEPtgsnsGzqHVleJdYpchaS5iUB4tXWyAYWJrLLn/yuZ/kPxLctPYeAgjvf55gAk0g3jU7MCqRaLaSiPSRp3C498sNKeqbsrXb6tA+dd4eeo+ue+qgWfCB1SE632vr7hc6K+uAu4Gq8JW0YPTLBYh4byfP9VXev+XRduvklwuvuG/nz2Lv7uHTq6hD1JQY2E11ViXdgjdmGIVeHbtDo4CLQB98nwJx8JCLjso8BgH1X/BqvNYcaPqDOL3d2MeZIiNa5o8IVSKe+LvwdZCZkGZFc8Ycv9PsElICXh62bImSYhgKraVNstuFzfgujxTxDj1y2bBziZbL2JxqVO4G24hrAoQTQ/YYQXWmEbKlht+YC/+3Z2Y7ppyrWnPj1J6gqtWwuXvrcZR0abBt28QUvnqWBpf6/qTXx4KiPZ7dejGA70h8rM0ONmM9MZK0O29hGJCSFPvqYw+upWh2gnVWk1IBXEwHTAbr8aRbCQ9/nwaEBRH59vM8ru4m6Po6DWAfyKzBcuF1ygnzZV3ndNQZDRaMCazrhDCf+shV5ET4EZtYIe9oqLPZujYIYSxpczI7Gu5RqbvHzjYxY79LJF3aDp0JmB9A2VUu9F8Z4iiFaxwrTTUuSaI3ohjJH7dDlGLloYrC2Xyl+KhiBEU7DRdnjyGfnZxdRCunc0l1VB/dl1ujsC6OpX3TqYaIoqE2qhjnVkvxrKCOqj8hhgorspU3Glh5WDHfSOhTTGlxeEuBo7MEMGyQIV8bO5eq/NspJhtzOQsMcL6bW/QZUuFiMo7Z0pHZFoTe2Zc9pAbZwDNDGZkpy2YB6xZZW4rvrGUFfU64aYnIj7N+DJhNoC1FwTOS9mCiyv66J0qp
 WhaxEkIa
 LPeFNf6ENbpEeoWJFZ1x1Q1KEMeVEoA6PmVbLmqtdEvATgbhKDPLSY6vowwfJxK9N/Y4HWt7OgvVNqCMLlGDetvrg/OXxXELc9nr/M35hCicU5kAnsd44ss1xaYO5Uo4JH6yaPZRB56ZH6EPa/dhuWEa7q1NPxwxydUtZYz8f+NM70zi2DNcV8t/mFlrFA79m8f3y7PC5XTiSCqHC7qUCEWtg4bmH5Fd+75gU5dDXJJuXQCcyg2OmbKANDNv5Pe3smUvTyR+PsrhhWbNbnyGybXM2d4W7p/80M/07fjAxvbqolZef57SHQCxY+5hnlcWguu6VKQVemB6heZHmBrYYiDHthKN2+ltOPKP6ebLXxrI2dU1/qdOIK4oQVP44nw8STAU1JbxLanwerYAn//VbFvum6HZq2jn+wOBY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 05:33:50PM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 05:16:53PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2026 at 04:53:14PM -0400, Gregory Price wrote:
> > > 
> > > As a start:
> > > 
> > >   1) the user_addr and zeroing piece seems like a discrete
> > >      improvement worthy of its own set - aside from end goal.
> > > 
> > >      This is needed by your patch set, but was requested to
> > >      try to push us towards a more reasonable pattern for
> > >      folio_zero_user().
> > 
> > What I worry about is people can't agree what api they want.
> >
> 
> Oh that's just our base state of existence.  We mostly agree that
> all APIs are bad in some way and we don't want any of them :P
> 
> What you're looking for is to get people to agree to the
> least-offensive, least-worst option :]
> 
> I don't think we're far off from that.  I suggest doing as Zi said and
> start a [DISCUSSION] thread on specifically this and lay out the needs
> and wants and design issues that you've learned from the past set of
> versions and continue the discussion there.
> 
> It helps to take some snippets from your set to lay out what you've
> learned and explain why you need the folio_user_zero() stuff to get from
> A->Z, and then let maintainers hash out whether that should live in
> post_alloc_hook or new interfaces (or outside page_alloc.c altogether).
> 
> > I don't mind trying all kind of approaches, but it seems to
> > be past the point where people feel it's costing too much of
> > their time with all of these revisions.
> > 
> 
> People are still commenting, so I don't think you've gotten there yet.
> I think the rate of revision is what's costing too much attention.
> 
> You'd save yourself some revisions by taking the attention you have
> right now and starting the discussion thread (and consider submitting
> the topic to LPC if that's something interests you!).

Well it's in october, is it not? I don't think I have the patience to
keep fiddling with that for half a year.

> All this is to say you're doing fine, just keep on keepin' on. Maybe
> pivot your approach from iterations to discussion for a bit until the
> opinions settle.
> 
> ~Gregory


