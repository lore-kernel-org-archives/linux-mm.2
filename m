Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB54C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA1C6B0095; Fri, 10 Jul 2026 12:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A786B0096; Fri, 10 Jul 2026 12:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BAA6B0098; Fri, 10 Jul 2026 12:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76C46B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:48:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F77B8F21E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:48:34 +0000 (UTC)
X-FDA: 84973450548.05.E3AD0E9
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B48C180005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:48:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=pELsYfDj;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783702112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqcGhN/IqnLY5kn4sQ1A7rwVJCth8mzmpAjiHFK7f+A=;
	b=p0+jQVxh4z9Lq+MQvPr5G2oB1HD58W+1NPczcjedzCHEyXTlYsembukPxU28CEBmWbwXV1
	9e2+rp06HvjLyQMOJka1vJgtGk5fob9R/RE3TyHONMZ7ChcnDHpGdb8eMBNJjFkuIYlWhk
	gDKO1hy2Zf5Yt8TWQvYhPCDjdLJJCiQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=pELsYfDj;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783702112;
	b=ZKlSzkpSnZ+RytSo47wIcYHXjf9jCXdxPyaBojhMor+rahK3aPIUGI0N3Cl+8hw/b9XpW1
	9D4gSyzt2gZ2+WZ8WHu8tBAE7fd87rajdMJ5XUAtdhjzp3PqgG68L1SW1bFUBQ3VXXqv9P
	sImtn8P4zrlkGOjKx5NhEo+r/QGRSPw=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8f0e5e36912so8737686d6.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783702112; x=1784306912; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uqcGhN/IqnLY5kn4sQ1A7rwVJCth8mzmpAjiHFK7f+A=;
        b=pELsYfDj3bP6hfLnvC+zqaxpK+3xzstuAMywoohpSdCZXlp3/jcn6/BUo7xyILK5Qi
         g1X7uL3LtXeS+hIdDt1R6VdfCOIkBbH+OYvWErF9TKS/PouEwTpftl0cMnceX/kqt/c5
         K+g3bQGNknm786KnoRHxrpNztj9tSmWduMd6GESti1z6Lb16dGsLSddYhkYdIOvoOi/o
         JXcQYcibLLINUQrWLV3FKo3vW4HVIazdZXMkAo74acD/6CgfQq6xXzpePJU09JvuG7lr
         4illpbY9OSbwUGjx0eKefbBtWh3zeM1wwozQUk+7m2Tj3MxgrLTtGpwjpAQWiAZXO0Ru
         U7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783702112; x=1784306912;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqcGhN/IqnLY5kn4sQ1A7rwVJCth8mzmpAjiHFK7f+A=;
        b=TeHJWhTOsnrchfHY3QZMV/iYZL0xb4pviIEZsejftyAVWzZ95r5v1xylk2v5rfX5rN
         6dkk+/b5gkezp/1obgA/XY5qDz1Zi1rQC3sXLFYXPenmYEXCEfCg/FwDk2Zyzw+A8+E9
         uwl5PY4kcwYjiA4Lvq+3napGTvRxgzsWkMs5PVgEgzHWnT/yKNHDNKU4F367AkAx4Ckf
         yd5CzIWRvqF7fDjb6jKfRof6qdycCoBklzmeAKRM2nURVnaJO+1j3jnlwvV+APjEnHrz
         CHIR/gSL3VgQ8+PZoY/QMbfGeFxh/aKk8nRHPn/BZFsYhh6Q71UYQoOX6wgPQJBAROJD
         ReQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpdyxcmOgkKepVEsd7QwRZ8oZNpixOBMm50VEUGCCyKM1L+WF5SyVltD81d7wItDFBiSEBOW7goJA==@kvack.org
X-Gm-Message-State: AOJu0Yz36Qu7Y/0hPjJZ75WOPRu+I09rLs9hKDJnBgCahrLLCKaIVzCM
	9aGuyWyEWExZMg+Yxgr/qfle22U5az0Gu+tgFoBrF3kp8ON5RQjN+WhEOWkhgawe4xM=
X-Gm-Gg: AfdE7cnARVoQPrcywJNm2GK6CdKI8sok5iozCBRX7CGskAptuYMXiNJyACXfKh3yTqA
	6hVyQsCq1CNw0Gtnl8aL5BlipD2XaMudiwwCZtQBZaUcUvissGmVbqmCiceQ2aN8k0rm9LMiF+6
	PG6WbMs0UTCGT+zlVrdwmsYtw+l8HyS2XeWoz6x8OkJgyb3N7CHQaKvlzLoJJXtuZrRflwmmZCN
	VHwnWLbwK5d4JzBaoSQGbsHJkkAw6yDuNT8UQ4+EJNMdUclOc2AMrz3MTB1S4og/b/FaLt4YZtt
	dN91GvgDGvSYcX7pwol61zrAKWhDGKpI92Glgx+S11qjFdnsI6qDS1hrJQtgy0+F7DbSIQnhVhn
	Nr4GVx0fPdFvC47UhKnjk8Kb1I/jbr3FUpYPWkl2XkwVpalKVniU6FvXcIQaw
X-Received: by 2002:a05:6214:2a8f:b0:8df:10fd:93f with SMTP id 6a1803df08f44-8fec14a93a2mr150121766d6.12.1783702111533;
        Fri, 10 Jul 2026 09:48:31 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c8d4csm47446776d6.44.2026.07.10.09.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:48:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEOs-00000007ZF5-0qyR;
	Fri, 10 Jul 2026 13:48:30 -0300
Date: Fri, 10 Jul 2026 13:48:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dave Chinner <dgc@kernel.org>
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <20260710164830.GA1803712@ziepe.ca>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
 <akPaPaCJdYINBEEV@kernel.org>
 <20260630153638.GG7525@ziepe.ca>
 <9cc11eeb-372a-49fb-ba89-486333ac71c4@kernel.org>
 <20260702125516.GO7525@ziepe.ca>
 <aka9vZSViFlzBrwW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aka9vZSViFlzBrwW@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B48C180005
X-Stat-Signature: wbg7j8mfqc4wanhi5bexrxjuxzzpo5aj
X-HE-Tag: 1783702112-274975
X-HE-Meta: U2FsdGVkX183B+CmHy4v7GG+KdsZD0nwsdbAtURKEoXRVKVvoxOiSxcY8EokXoL7dscksAl5qH3N0II6Mg6ACA4E/iXmR9mNhcZCwTVoK9GeJAxyFufsatmkUYwXP/rMq4PmdQultdsmlMTaWRkc8cb4JTCxoytVCY9ynZ7nWoiICsoMiCCuBBH8iKKrovrdXX3lE0wRF1OYo9pnMai9QK/Ajb1XTGTpVGBP60uCGHJjhX7eGhUuSBn70HmtdSb/aZLGMv1AlMpt1wpEOWugyfMQP9sFc3r40W0ZW8Dw8jl8TKBhJsYYGJUWVXhSeehYFJPEaI7W6KCu9G9SSvVxM30cXlsrfHYHA0XIrzF9KFjum4yVuMVBey9VEM5aZuE6FlmUWbYb9aLXhWIp1WGD5NFFRWFqfxhNCnJ2uXkZZlHMts/4RgB+6RIO4cYGcYRxu1ECgrLrq3P/JcmvpMpTTqhP4Gl9PSGea+TWItnmrtaQNSE+32/ZMUgmkRGkfuWFLpbFHIwq+jkml58X+CdCoW3dASex3TN8nRhA69mwIfh7I4VBLbiVdATjO3cccgVsS3n28hzMDGNNrQ1Qic7u+JlUhIGo91//qqDeN2qhhmO3Dp8NrKKDkhEUjcTjImUmy7zQHU6vfUvZPyU0F/7ZXq4yxgi33YILVbN5jo1NnRjxoktRnXxlyiotjgSaZxds2MIcs8qI3NzsP7MNmAwUaGCKVk+pezZJa7ZhnJwKp9Y3QqJytqdDG7rLHooPam4fzHBVCMCg9pYW6Fs8vsGzVqQKew//3CNmcDsLqKp4r6gtvmavPgx636e98F98i4eGYOVwyoyx0lrHsgueYaEcCwNpUOcaO3PSCsA2PJatiu4FxNYfLBMDrHaQ+o3l4YLO44MjSP37bJavukcEBUE5U8OFBFS1YyszwOQg6m2MUs5AViAaciR2D2wuJio4DYzx6U5SQjXRw3UrLwXIkNB
 F782qoks
 tfpjGeuosh8uqnpi8fguIt5BlJUopXcs+eSgJ291CbqEIcAjkVyScMnBU8lIFQXl2Acx2/BGeXjoNxD3HQRmHku8y/R6h9HeVJUabJ2aSKWzFplxh2p/IuYkl0NkRuDkVvtrKf6bEI7z/Gn64CEcDJ3PT73ItJvP7LEzG/7n9fbn2dcm6hIz1L+zKhPRqMIYngoVhjJTJW0lgz1p541DNWFftNSmnUcNmXcLrxLy52Jty3PhUbnO++brbdRs4AJQhT8MQmp+t1TD7GEDCvA9IrZucHAWscDjDWC/qOToAdQSYDWlowlomNxIbWtbeT26PCgtzNgPxudlKIwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 10:36:29PM +0300, Mike Rapoport wrote:
> On Thu, Jul 02, 2026 at 09:55:16AM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 02, 2026 at 02:46:46PM +0200, Vlastimil Babka (SUSE) wrote:
> > > I think this should be discussed more broadly and not block this
> > > change.
> > 
> > Currently all of these get_free_pages ones in this series are this
> > special need, so I'd like to not loose that marking somehow. Maybe a
> > comment or maybe a inline wrapper function.
> 
> Comment is easy :)
> 
> As for an inline wrapper, is there an appropriate rdma header to put it?
> I don't think it belongs to slab.h.

Well, lets go with a comment

Jason

