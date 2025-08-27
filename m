Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CED2CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39A98E0005; Wed, 27 Aug 2025 14:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAA78E0001; Wed, 27 Aug 2025 14:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00B98E0005; Wed, 27 Aug 2025 14:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4528E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:29:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 478801A0765
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:29:29 +0000 (UTC)
X-FDA: 83823375258.24.3077AD4
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C4C3100013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:29:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z4Oeob/q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319367; a=rsa-sha256;
	cv=none;
	b=E7nlj4g23v/hX6Pp6Iw9xb729CkwS1tmbRS2a1F+b4SVTdnYU9RzC92Pq36/vKlnPJnQYm
	JJuuTH6x6TpPonSBG42+8aaPeLELw/uUGCYvatRNpGDHLgB0Zcf4+EqGKf+T9QeS6C/Tap
	3aE1Qd93XvY6OBumkfuJVycJlPryIoc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z4Oeob/q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/V1ASIrDSi0g28DFi0KZDWfzgadLb4GaGK114cw4Lvg=;
	b=zDgYEnfL6OfxHxOjLZlZgV7YPectnfAftXdRvMME2v1oK0Ew2DsMacOqjZ3unqjY3uxCc7
	VVtBnpwK/tmPMqfGUnwUjFa7UmE8+NSTqUAh+wJSrMr4JuiH8ZnAPbTi+eFAP1RT9N7y6K
	ol6b4VYVmf1PxzivVjJUTSuscqBIKNY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2487a60d649so1549805ad.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756319366; x=1756924166; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/V1ASIrDSi0g28DFi0KZDWfzgadLb4GaGK114cw4Lvg=;
        b=Z4Oeob/qSACt9mGsgaKkqB+jmjSkBXY5pN3/D1ZmktjJDoetOAdOfHlTf9YJc1XVp3
         oTzwfd23nAD+MJ9/7xliL4btRRV49tXWuv8DXoIMjpkt938IvrxpFpZZsEI8bnF6zfkt
         2gkLJE49SUY+OgjeC8fBU04YfiFvMGa1O50sbAYNfqYJOaqfYuNt4qm+Q/H7oxlf83aR
         E/07pd/GqvFAg1OPK/vpez0H8aFwkxJHvMoPvAxGpzJQo4uQbT830wmIH5vRIJQbySMC
         n6HSFXMWiy6YfVQnlGZkTUlYe5pLbZNZ9bshvEY56fRogInJsUQO3x7JL5rux4++BFWE
         K6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756319366; x=1756924166;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/V1ASIrDSi0g28DFi0KZDWfzgadLb4GaGK114cw4Lvg=;
        b=Mrjvgh3wu9ctm1lbgah+t3CVpSp8B+WDOVYIVrcpPpf39Z+8vh6B4zGHeHU8QRVAER
         k615QhbRSSnAuIKoDrXFNOsOsq64W17h1fGMYze0cs7j/lmFI+ENyzKix8OeQmwh6JhM
         BGheHl0+0P0pNyo6xZtyT/QV8NrNC5REe48fd70n55uGUtMDsG7vqyt6g51Da7dHVOjG
         rIVow+6eFkOGPXMeVYv/1NthIL6ejS43HMw0GsoDn/CGkUmQ2VZ2lscQ103EEh/IhWa9
         1rCh0cASDILA6PP+XcjjUmQ/16QO2VSnmLWp7gOa0F5CGtG4n1cO4wM/CvsEDGejq9XY
         ZB/Q==
X-Gm-Message-State: AOJu0YySmlGtgiiHv84McFwpTe1dEawBJ5ICyQfqMCBViBTov/m8wQtc
	Q77fynzzpLQeFwlm6063kdsYxkVj0IW57oQ4GuOE4HxNvL5w3cc5D5XMxk6XPA==
X-Gm-Gg: ASbGncsbRot1slTpCzzd4WhhHXNznK0srDoFZQ6yLyLi8DAnpryJ8W8Dipfs270/qCg
	v9CBnjtZnli0ffBHl6hccBcfRLB7TECFrVYA8P2r48BAnkeOk9Fjqrcv+N7XKTFQm8Wd8VmuVqg
	PmrdEJ5mZ0J2NDZFWGAu/rPGK8kD/F2rLIrfeLWLSE7bp09KVL4zMv2lkUukloRJ331L8M6qMPr
	oAmR8XZrJ7UzPvJ4kF4GF8uDSGhE0c1gi6zY6Zk8MF50JCi1W0eG5TN0uadC01b1+njb1jpypxv
	RgG3TGo6FsRkvWWlD21Py0YSVdeMKGt5XfmChEKFtQJ7wmPDxLsDYjuj0hWMlpqJl5diomJYpxW
	M7TdrDGkYjd2WhmHagEZjKMrwen2q+1NN3Pu5cTkCW3UzhdY8Cq2Qeg==
X-Google-Smtp-Source: AGHT+IF31+xUc8XH5FHaWxMDYwQHY6yAzaY35BNdjs0sugkpO8may1dby73rGFQR/wb+8akqXlbySQ==
X-Received: by 2002:a17:903:19ec:b0:248:9e56:e806 with SMTP id d9443c01a7336-2489e56ea30mr41835015ad.12.1756319365980;
        Wed, 27 Aug 2025 11:29:25 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2468f5de849sm112338435ad.141.2025.08.27.11.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:29:24 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:29:22 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <aK9Ogjn71JoOM3w3@fedora>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com>
 <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vepaSp8giM4exkxF"
Content-Disposition: inline
In-Reply-To: <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
X-Rspamd-Queue-Id: 5C4C3100013
X-Stat-Signature: nxnjwwy9tgjffmxt1oaqauq5r8ufqjex
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756319367-883364
X-HE-Meta: U2FsdGVkX1/w/NAIhWnBnGDqDBsziaDdIM+y4Pa+OIGNoo0ErRA/2D8oZYq/bd+bSbpq27j8F/4tBTMW8wiLF5EqMRoZq5idUnjDPkz1Ry+7YkeJ4GeiRCdvmSCPOtq+ubC+Zp4wlgkyz0nX0SItIEYkcpFcWzC/SWhcOOuhSzgsafEem0CgIWN1pFTe/8v744+uPOy7ZE72Bsp/qjsYj++hDLudJ0+0yXWf9SACM/SBCvqPTz93EBcvG2fr9RgZmy1Gn7g2vAp3Yz/4tVjc1KWhnMG+AOZOq3l5JL/Ft8qpaqfRtMpldBFZdY0mmDOAhZGTPE5+mHu7L6rQx8pUGCaK9GTOPXWTlBwiExqkz7+yOJVYVyTZJ+yDM8sXNk7WY3nS7+hkAVvwDCTMt/wt99Vd3oSU4p+1+Y1MVPrMUBUZsfhm9zYLe5QvM757BHarO+tCosOTYsNhaswp3yhcfQZ0TytE0WL/PEwtEb5fK55zd++1tP9R88qJbMgDd9x/bDdyY1kfI7cwtoTkTDcyKXPWuQ7Fm7h4AakZyy/pA97qouJmQo3gVsHPsccX9uOF8gezM910Utftuy3Bya3lDMKnVUoMd3pz2yYeplSiDk8Lifc1yN91xra0pzAIj4DCBN3TTMCcEk24FOfBbkQoRDCtDqSPCA/+F4mmeQ6KGiTi4rKAALdjYPal39iRYv0kTWSD8kgVUK2FYy4JzqevW2nFtDBKLTqj0J1hnx5IPENQLqF5XlcE2AY0/x/k5ZWBnSJFK6k/UrImc6XXqEOWJ5Q2W+nLYAadSdhRGsoDGt9KAFABqBIaBfBAeR7lYmVBaLWIipiTChEAzN7/iuQzLzuRfGKeujHy+lWUTRBiaNI9HdncOHRT3yAlZPF3lM98B2rOZXWEGYiHhZ5mKgssR5iiLS1DUrfapDA0nlqvm9YAc8e5GmFsu00gkhQ4GK1gmWTYeDZY8JYHgQ9Uofb
 iT34e54w
 BRvyZmK6Zz+WhSIPY9UxNLsxHNYHlYOy4y6VD9pnN7qq68iFChWf1sJKXHnt8zCfWpK2iXibF0KLYVb05B9Ik18rZ+FEkFt9vB3i8EMx76i3UhOBmSDYaofi7brdVbxBpKbYNr+8CJxfSZx0BUSWNgR2CLjkYy/yJ8J+55wnUwpbpMqmlD3x5f2whiBwjcFDgQphhM0EAu+ZoOvdort/6OLPHVkpWXU9yITgHeFW9mUhlPE8VkQfA6agxUjfZ3gB8f9omkmuVo2cv9tqeh6J8QJIUlW5/yYBGEjudzl+Xwkfo3bGcYBXP5GJIt7yTDGX9jtSYbeUAR2Wh2MwtsoPDCKkOcjtznGuk8LVbL7bmbQLATf0l5un4e+8ijJ07Af3ZthX9Lfqrt0WN71GuDvhDYfROdl1bzEIk6f2CFrVBFO2mRMc4iCsiqZN+lzknGpW4HtaytoH2r0+7dN/21qe7IawvJQHMnRzcmm60lEJcYhXLaUxFNV7+STmvHKbC7+kObezlmTBTfnvi0P+gUYTwfo/abJ7poRe7X94Kltik1Ph8b3k5wTPFv4JH0OHjA1lRGZjkND7UoaqcFj/LsE3n3GWU6q2tl7ySKzt8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vepaSp8giM4exkxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2025 at 02:01:01PM +0200, David Hildenbrand wrote:
> On 26.08.25 22:56, Vishal Moola (Oracle) wrote:
> > free_pages() should be used when we only have a virtual address. We
> > should call __free_pages() directly on our page instead.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >   drivers/virtio/virtio_balloon.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index eae65136cdfb..d4e6865ce355 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
> >   		page = balloon_page_pop(&vb->free_page_list);
> >   		if (!page)
> >   			break;
> > -		free_pages((unsigned long)page_address(page),
> > -			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> >   	}
> >   	vb->num_free_page_blocks -= num_returned;
> >   	spin_unlock_irq(&vb->free_page_list_lock);
> 
> I think you missed another nastiness of similar kind in
> get_free_page_and_send() where we do
> 
> 	p = page_address(page);
> 
> Just to call
> 
> 	free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);

Thanks for catching that. Andrew can you fold the attached patch into
this one please? It looks like the page_address() call is needed for other
things, but since we're changing the file we might as well clean these
up as well.

I imagine theres more of these lingering in the kernel, but theres so
many callers and I only looked for the ones that were calling
page_address() inline :(.

--vepaSp8giM4exkxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-virtio_ballon-Call-__free_pages-in-get_free_page_and.patch

From a7d439154c7990418da976e5864b91fce9d49d58 Mon Sep 17 00:00:00 2001
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Date: Wed, 27 Aug 2025 11:10:22 -0700
Subject: [PATCH] virtio_ballon: Call __free_pages() in
 get_free_page_and_send()

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 drivers/virtio/virtio_balloon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d4e6865ce355..7f3fd72678eb 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -718,8 +718,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 	if (vq->num_free > 1) {
 		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
 		if (unlikely(err)) {
-			free_pages((unsigned long)p,
-				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 			return err;
 		}
 		virtqueue_kick(vq);
@@ -732,7 +731,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 		 * The vq has no available entry to add this page block, so
 		 * just free it.
 		 */
-		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 
 	return 0;
-- 
2.51.0


--vepaSp8giM4exkxF--

