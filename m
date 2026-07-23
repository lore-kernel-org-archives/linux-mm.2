Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1E3C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE3C6B00E3; Thu, 23 Jul 2026 05:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5F06B00E4; Thu, 23 Jul 2026 05:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E4F6B00E6; Thu, 23 Jul 2026 05:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBECE6B00E3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:15:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 234B98041A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:15:32 +0000 (UTC)
X-FDA: 85019483304.09.28D7FEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 84EC44000F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:15:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VN8l4I8x;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFDQsWaV4YVMqaytcd/qULKOMwPiXTV9I3KQpj/1PB4=;
	b=yngq639XYy7lm6ndA3RbyZnaZBl+F+BGtt0GDBv1dakCzvqzYnUzY34czaBNwEzjLhqsNX
	NTrujm+6Opn20RYb6VQelBqteXPBmDmmEDXfVmK4LsIC6NkoIP0WFKB2uTFQ1l0gM7uUGp
	S6592q8jpGa0PZuTnsH6v+XQoyfu4Fg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798129;
	b=K+tVrwWGZEnW6tvJK9sC67N4UdJwgwoIMICj65WDYzEtMOPagPL8sb01oyJEJCw/GN0XfR
	meZzA5pSnQVVV/8iY3KAeiGcjBXLIIA2Dh8eqvp3H7pl4IcnLXDzbmZP2EuxsJnRASHc1M
	5y7eT5Wlnq7tjIJ2SYVJC5PuIhNwwMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VN8l4I8x;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784798128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HFDQsWaV4YVMqaytcd/qULKOMwPiXTV9I3KQpj/1PB4=;
	b=VN8l4I8x96+KOSYruHJdo9bkEjjmbjUDOcl8pwDyBrgTDzsOlKcVagcNLX2CyM0jZWDPOM
	8EttGd8n713pvl61eXkW3eYWpz5n8qxE3gOminVy3IuVTGle0bxzZo2A3bon2bvS0yJxFT
	LVNwQ1YmsZw+xqD55gGrIEttTn0+myA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247--BvzslgUN6KW7iNBoe_SFQ-1; Thu, 23 Jul 2026 05:15:27 -0400
X-MC-Unique: -BvzslgUN6KW7iNBoe_SFQ-1
X-Mimecast-MFC-AGG-ID: -BvzslgUN6KW7iNBoe_SFQ_1784798126
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f6e8b5996so430269f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798126; x=1785402926;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HFDQsWaV4YVMqaytcd/qULKOMwPiXTV9I3KQpj/1PB4=;
        b=G+grqHtz+4HQrPkoYz0p5IkTlF1KEz8KAKPGm+J2/e9PMEuDDajJWGyBkprz06XVD7
         rGfnnpJ9v7VgyWBuedRNyLMaivZEQoyMueq6Y/y4i43OBjSporLB3oxug8t4LuWsS6l9
         agaa685kwCEaPmuN+/Q7Cw4RkD6aK2T6Q4SxVRXB/j5rZk2hoy0C0OOhlEAQA2+3naEi
         RXL/LaNOY48gsjnYM8/8YEEFShpzHKaU7hj0bFljLxzzs5AxcFaSTRtdEhFCWRJ5TGHr
         B+MGSzIgAMrUOIR/OZMooCUZwAa0qy5hyPgEBdPfcpet1HSDR+qCyUgdGUD33N1lsURa
         Zt2Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqvn2ZgEArAjRGLj93lc9ZJOjuh517kcKOuezIZtOQIHsI1SBFsCi8R1lnORdc37DpuoOOPvOLyOA==@kvack.org
X-Gm-Message-State: AOJu0Yzq8+TE87litWAiKOpxBlrY/+HOL5ciPtlnfSQ8qoCVG12a+L/i
	AB4k0pht7ud2TF75Ki/uDMBR6OtC6GF8AZBrSqz247KPL+/ja36wCT2CecxGJF5jW8v2NWNk5sN
	iZ6asRMtR48LeBs2TSg6+zcZ9HqEJdRkrbUv9bJpt55dXBCzJTIMx
X-Gm-Gg: AR+sD13qr5YhK1yxZ/SH5AKzylG5WG7SoYWgIrP13UP1hCN+7okBifUBip/Ds/p6srG
	58Twkmn7491AuRg8ObZ/RQdpcCLT1kz0AGZFx1tSq+l1rSv3EWfc/8AtYliYblazybudWutkvyc
	Xtr5lF8lK6ErFQ0/cfIcM0zj2LdAKXwWGGLjb9gnFU5p8V6S/HeqEd+6hJBRLSQPqLoO2FtIY6W
	y/Qi9Imnytvop5y8A4UW0NUgwOKbEEQbpuw4/n6YoQjM9QrRq23WPaTNtThf/wM+6Ltj0xncUt4
	cHMCGBGg5CoGbSJbZZgOx3vi0CjbfPGayAhd/1lwiu2U92pjqwND8vlZl21cHvY6mAnaRhxMwSL
	yU3/hANwVzT+52HsZ1y/Obw==
X-Received: by 2002:a05:600c:548a:b0:493:eb71:5cc6 with SMTP id 5b1f17b1804b1-49573d0eac1mr23927635e9.27.1784798126322;
        Thu, 23 Jul 2026 02:15:26 -0700 (PDT)
X-Received: by 2002:a05:600c:548a:b0:493:eb71:5cc6 with SMTP id 5b1f17b1804b1-49573d0eac1mr23927055e9.27.1784798125726;
        Thu, 23 Jul 2026 02:15:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-37-66.inter.net.il. [80.230.37.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b72fac1sm108575995e9.1.2026.07.23.02.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:15:24 -0700 (PDT)
Date: Thu, 23 Jul 2026 05:15:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Link Lin <linkl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, prasin@google.com,
	rientjes@google.com, duenwen@google.com, jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com, Ammar Faizi <ammarfaizi2@openresty.com>,
	jiaqiyan@google.com, ahwilkins@google.com,
	Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
Message-ID: <20260723051327-mutt-send-email-mst@kernel.org>
References: <20260721005603.1710551-1-linkl@google.com>
 <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
 <CALUx4KSfUUud86k4SLwETJAciRc8kZ9QocvBj39KmzXDiQ7J1g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALUx4KSfUUud86k4SLwETJAciRc8kZ9QocvBj39KmzXDiQ7J1g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RhZiPcaeU2yoFvYIQVjazLaE3EJG2VOZLNxpqXEKQFs_1784798126
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84EC44000F
X-Stat-Signature: qxkcr89nom953ymymt6yq7g711yoneo5
X-Rspam-User: 
X-HE-Tag: 1784798129-169419
X-HE-Meta: U2FsdGVkX186BkU6r+sxLSafkdSa2mJOC0yFus16HjSv5GEsE7RqOTYzQJ6IKJ1T86JvOT8WXff1qFe3qv4Iaq/IuvOwSCljvD/AvfD1I8oSKGHA0ByaScl3qWaM/L38PQ5q+S9vdbueP+aqO8A4Z3jhtUlmOAGjYqgbLF0wl778znoUlrNcb6SWPc/nzp/J3GcintFlXL/oGmwAsk1FS+gqIpF/4QNbH+s/+/HuPtwK9QRPqncQ6GthUmShQpIc8C8Ye6wMXJTl9qXaVvr+YrRFWQchIqfmeibHnNGwFXFP7ETyii5OTOzLmc7aYCmbd9ervzjO7Z6fHOefX0XkTLKX1PUAxRLU4ZkzIqa2lY4aktmjawHcmMpAE+fNp+iucJbi0W3WeDaaIJsq00nv/UlRaPlRahmy513O+opuRQoQXBcab+xfjiRZP7G8fB7UmWAwJR74FAFx/pI9ThZ6fhkHIf8VV25pp/H/Is2d7ai4KtqRc59gy2N+lKDNMuiKBXqn3FRpghhZCYzsR10eEGjkwZZ3kBRuRx8WKxmBOpjvleyDTXSifsfFY8tcCg69XqVDv3RqEj3WS2PRfPGNbi8zf0XEokajp5uAjtqqDQImgNXFBj3cZaFMjKK6G00+EriOsGTovvk0M1AQoUkBVj+C6rCpylQX8fs57hICvJYaKofYNT/b7AHQt/395JPJpzcm2g/uij7kxgUucP7maKJnqqLl3WIoITBe2LQ6vJOY7t2hADhtgvUFrVub6njrwaHyee2piPY88Evjdkj3vFPji13A3c1N1dX4QLmQHLtzn+yi9B/u4r78vSI/JqhYGja1mpNOvUrCteZVIiPcA3eMFNMis8tkTmgxAPB9QM4G6iiosUfyQxfcUWslk8ovu9nxQvAv/I6DHqv2COjSGY9ZlI7QdeBLAgAW/Twh+e1Kge2kdhzPswmOo69d7JrCGrkIt0ZwPkFJHynUTQS
 hYckRCyB
 V3dtle+6Tkp9ghdBzHRpBoepIEvA2/bSatG67WpDvnhMBEwaw/Tt7JHNr1DYMq9y/aFGj0FJq67dECOX1M+1AjViluQCR4IvvkKS8W+3PgBZ+bEAejL1FEnMDKJAI5FZlL0GiFSyvSANet41L+0i+KXr+/BYxk4kd7P9rUcHa+lLV6iE80LtFRi2UUnYuzqVyF7UVyQVasEZ2SxZsC6OlTLNMzt7eCWsPYGl+E2Nl1UZUmDv0uc8rbk6hwmxhQP9CLNSW9CzAarGLlzspPhQ+5zD/dW560Sk0Yo+F4YlfSWziBxO2mzIY/ma8lkLtRyI5hniEmqaxnURTEXsdGH0FU4hFWAGxAJ6UoA66muFA8R6V1r4T51Ihm4CXc2LO7/ALF2TR4hE3Mct28GZkTQU9cxofZo2T9twI9bgdNsoJxyA25wAXNeD5LVMfXlrPgnCSgWByUzENifmo+XEuXTN9vAEBmG0sBDGR7ET747ylhv5pQHO7xiMhGKhnkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:07:04PM -0700, Link Lin wrote:
> On Tue, Jul 21, 2026 at 5:36 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > hm, now where did that come from. I can find no such commit and that's
> > the second time this very unusual thing has happened in 30 minutes! I
> > wonder what's going on.
> >
> > I'll use
> > 36e66c554b5c ("mm: introduce Reported pages")
> > OK?
> 
> Yes, that Fixes tag is perfectly OK. I pulled the previous hash from
> an internal downstream tree by mistake. Thank you for catching that
> and correcting it!
> 
> > The bug is very old so I won't fast-track this fix into 7.2-rcX.
> 
> Completely understood and agreed.
> 
> > AI review pointed at a possible pre-existing use-after-free issue,
> > related to virtio-balloon. But I think this is a rephrasing of the
> > issue it flagged against your v2 patch.
> 
> I actually looked closely at Sashiko's flag, and to my surprise, it is not a
> rephrasing—it caught a completely separate, valid edge case.
> 
> My patch fixes the UAF on the PM suspend/teardown path. However, Sashiko noticed
> a UAF on the PM *restore* error path. If virtballoon_restore() fails during
> init_vqs(), it aborts without unregistering the page reporting worker. When
> system_freezable_wq thaws, the reporting worker wakes up and dereferences the
> now-dangling vb->reporting_vq pointer.
> 
> Since it's a driver-specific lifecycle bug rather than a core MM workqueue
> issue, I will write up a separate follow-up patch to address it in
> virtio_balloon.c
> shortly.
> 
> Thank you again for shepherding this fix into -mm!
> 
> Best,
> Link


I suspect rest of work items we have, e.g. update_balloon_stats_work/update_balloon_size_work
all have issues around freeze/restore and error handling.

-- 
MST


