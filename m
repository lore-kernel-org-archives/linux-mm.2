Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3570CCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AF78E000C; Mon, 15 Sep 2025 20:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BD98E0001; Mon, 15 Sep 2025 20:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151F68E000C; Mon, 15 Sep 2025 20:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02BC98E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:07:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A875D11AD98
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:07:09 +0000 (UTC)
X-FDA: 83893173378.16.A2D5A73
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5C2CC0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:07:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrfnqQ9W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757981228; a=rsa-sha256;
	cv=none;
	b=HUizj1wFUqe78MU24qxbv5gsr6ASfhbu1MjJVcKlOe9qChiVTc3KORuAriSldqSJitSykN
	WmBaX4fG5DeKkSf+ZVriVnMRCKNvL45PdoetUJvLg7ZOcJLv5bYB900Gn9CbYk9xKXaVZu
	Rr3n7uPYm6Or7phs5olTdI5RJBFMEC8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrfnqQ9W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757981228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0DdPvJAHN5ISH/pdtLfXa5UzPfO/utNQwjegoSkVR0=;
	b=7xbpn4NCB71sG3xqbjublXolhw7zjZq88h1RuVKYhJ6QpbkwfarN+Uf2+uqg2QN2niJ2xa
	ZXdgqLXHnmYIHtPI4p3AJSz+FXbLnr+HGXgCv6XXYo8ewR0i4fsgLJ0pzwrLXG9MWNRavN
	RATRXAZexqhTXwZZgihAUnzgveg8ufw=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b49b56a3f27so2842122a12.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757981227; x=1758586027; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0DdPvJAHN5ISH/pdtLfXa5UzPfO/utNQwjegoSkVR0=;
        b=YrfnqQ9WHHVHzaSKiaOA5Zq6UqjhwnFUph1OlOaaA7wFxnsltNhWvlRAnvUtzOlV43
         yfUOm+egjMM2ExMvbAauLN9QSAnzqAxd5YA/a/Y2MPoTQwFrAxU79eFOkavFk0ZxayYd
         47bHoU4F5XDVLvoYERcZ56K0CWHuDF7gHCXteahbplye8tj8BmI1wNUfVCxjwpjv8ylj
         lpcVTcye8FB4AmPkZZK7tyinrVF3Mmq5+3RiPSa2rxVMjtUrDj3MB4741NfvfAjqdalU
         LGU4yDuPA3tNxgr4haq6QPGcYfXtYcRqX+/MtFxTudsSR2vF3dRkGVXSgQGAD5fvDjJp
         YL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757981227; x=1758586027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0DdPvJAHN5ISH/pdtLfXa5UzPfO/utNQwjegoSkVR0=;
        b=OOy28tV26NaXLjMkCVbM/leLOYPDijE3Go+oKdIXqKENKg4dyoBQ72TwtCn9akTpU3
         OfobA7BoT5Hav7g+yEmvNWT/AH5z6zjzbHezEIK3sGeK+ipb5TZ7NysH3OVNPKhPPAb6
         O0Nsy4G56WEWZjEKSsRrV+Jl34V1Ohnso14/qgmYV6uo091z++LjIEwPBjDH8o/HKAH0
         FPKCUcX2Mx34aqhEZLVf9rgouf9ELqgzLAG/hxPdVJ0QhBeCEr7U6WMyDzkNGbc9gd/B
         aVzBaaq1akcBdZQNjrOBPZgCZYCzOIEiOC3KatxYLc/f7wgyqrOSSTUTJIhGGrLYQTcR
         Mw1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZbViwHdgrfMD9FE0hb+8nOcfYBx6yBhSqFEulXBxOiL6W3xKdnULfhzlrMeEcgUf21M7IVF0ASw==@kvack.org
X-Gm-Message-State: AOJu0YyI7l4EpL0gLTeBiDIsWSDAbibqvH5ozi032izmaE3oY6Hh9PWy
	oHFft+zILOjL+mAWhNe2NBRrfbPGqXIAQKjYlfw2EHX9dSkUiw40JtOd
X-Gm-Gg: ASbGncuAZNYg+EN8LI0WNMcKoHBA5jWbqiIgogZVPCgiKOUxdhZZyg+VY4Z9ClqkYeF
	5YbpU7zprLm9lgxB3c9JN8SyAfjyZUvAWDvX2DVW1FCG4Q+UHynhvoTId2VW/U80iMG02mHcJex
	swCsdIBUWEygKa3qW4dSkifanHhc81v1lEz+LgrpW9bpZqvpQijXsOLZPDIDQA+X7UAhLPIhJ8T
	Vk3jgOJs8IeeFD6Rmyt2/QTp3c3/ftveDL28Y8UmmZC55I9Y6Qw01JasZAfioew1MBXNtuR8iVB
	g7dRDDIYpbOs/LY7aclX8aQvxHSGad2gmdp/OajH5FYmL/aNrQcVa5xsPVo0AmDOy8P+i2gOpQH
	jpQjQFIy0Z6xSruPbVcSPwyUyapywOR3Tjhq5wBuDoKFDNjX9jiIg01tRd6PftAmt
X-Google-Smtp-Source: AGHT+IFqBn3aPuuGIwsNUKiW5043CHGfJxBjK7/JYETlzi1z3QlkzRgLa+sscFn02uU8Sj4jKSkSIw==
X-Received: by 2002:a17:902:f64f:b0:250:999f:31c6 with SMTP id d9443c01a7336-25d26d4d96emr158911255ad.32.1757981226722;
        Mon, 15 Sep 2025 17:07:06 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26124cb9460sm83251345ad.106.2025.09.15.17.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 17:07:06 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:07:03 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <aMiqJ4UcAfU3W107@fedora>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com>
 <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
 <aK9Ogjn71JoOM3w3@fedora>
 <20250915184514-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915184514-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5C2CC0005
X-Stat-Signature: a69i6y4ot88yf7hjjywjnwq4nymyyy6a
X-Rspam-User: 
X-HE-Tag: 1757981227-241626
X-HE-Meta: U2FsdGVkX1/9x6UfwvQwI3oQR4rQxkIKxfVJ60Kjk0jFpIo0VtxNYk6/j5b2372flrG9Mr3luVAMrsGKJOLee/+qbbpU6b55A1DhDLvOHmSVQgjzSzVukjhgT1LG6wSyBX0oQGMxtgmXnYoqI9OK3ldEQvidFIuRN/z/HetOVEYLxlQLxz+WOzlVBYKLb2Qlv4aUwquEq4Nc6PKHVOB7ZAWqvpNci3BYl4FtU8S/2XFMfJPa1t+my5As/QgoxAS/pNnngBSD9JVSK8T6r8bGAyNFtuD4ajH/8nh/pg5k9+ROmyWfmvu1pBqy2BcCHw6zgaLBVlBmA289Sx7SEy662nGhk4U+wid21ydIaF1N761NIt452HQLFwdqQZ8AU8bGaetqJrujXtxL+HeoyfH2OnM3pbn0ytujATT/K7nmz6UbFAJl0h745P5s6aHepJaBG5Su6jPqLjAWiOEZBy89ZS3G8yss499uGvwQVXHuMkBltdvbF1ZhrMgN/45kfzr6XN1xZ5CIOqibbe3J3RQfjQT6v6zs0ci83WqVyLf7sz9z9KYfCIVhHRZ+/mjMzsGfdg/yoVF5xbTt3DWuSxppdTGHdvGQQFI8z/Sqm0k1qBY5vMvc0Xo5EZYIPn2n4eJFj+vyYMGl2x6vDmA9/lq0dVhZAVpVIE3V1UT9EyhRC2lAsYjW/QbRJlAtxNlGnQAreF1O6c3o1g2Z4WteGFMM4NFF0hUG0/g57UMkOk8fU18Y0tX4EChUA24iOUoiB+YXcWnJAGwic8gQB9JKVEXkWe/IWJn+u1WovJjD9PegRsw8tHw7XYPmCtqDjLiTGKI5WpoHh4p2/NFThep3AeqALwXpP/FBnmU1ITQs3ULxdFioKk+m7uYu1ZZPKtvcos7HA26kQYb1u4oZxO2WolebGDOJPZ4xPJmPB8iMlHxFGpYs68jeZ/2v+/pqP0XJCCowZ/N64RUbz7SX1l5QpwL
 LJx64l8/
 6YzeCgVJ/BMGUXJvzbTR/5gHm6A6dGOmewrp04DEMiapfbFXpPy/o9+AJGAlx9EJO+mCfTAXeijYVfoxrHl+l+X9T68QHxp5btImkA20aBNlDiOPDz1QiSTP2NLSVIapef1rw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 06:45:51PM -0400, Michael S. Tsirkin wrote:
> On Wed, Aug 27, 2025 at 11:29:22AM -0700, Vishal Moola (Oracle) wrote:
> > On Wed, Aug 27, 2025 at 02:01:01PM +0200, David Hildenbrand wrote:
> > > On 26.08.25 22:56, Vishal Moola (Oracle) wrote:
> > > > free_pages() should be used when we only have a virtual address. We
> > > > should call __free_pages() directly on our page instead.
> > > > 
> > > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > > ---
> > > >   drivers/virtio/virtio_balloon.c | 3 +--
> > > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > index eae65136cdfb..d4e6865ce355 100644
> > > > --- a/drivers/virtio/virtio_balloon.c
> > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > @@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
> > > >   		page = balloon_page_pop(&vb->free_page_list);
> > > >   		if (!page)
> > > >   			break;
> > > > -		free_pages((unsigned long)page_address(page),
> > > > -			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > > > +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > > >   	}
> > > >   	vb->num_free_page_blocks -= num_returned;
> > > >   	spin_unlock_irq(&vb->free_page_list_lock);
> > > 
> > > I think you missed another nastiness of similar kind in
> > > get_free_page_and_send() where we do
> > > 
> > > 	p = page_address(page);
> > > 
> > > Just to call
> > > 
> > > 	free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > 
> > Thanks for catching that. Andrew can you fold the attached patch into
> > this one please? It looks like the page_address() call is needed for other
> > things, but since we're changing the file we might as well clean these
> > up as well.
> > 
> > I imagine theres more of these lingering in the kernel, but theres so
> > many callers and I only looked for the ones that were calling
> > page_address() inline :(.
> 
> Confused what is folded where.
> If you want me to apply these things please just fold whatever
> you want folded and post.
> Thanks!

Hi Michael, you shouldn't need to worry about this as Andrew will take
all patches in the patchset through the mm tree. See v3 for the updated
version that will be merged:
https://lore.kernel.org/linux-mm/20250903185921.1785167-8-vishal.moola@gmail.com/

I get why you might've gotten confused. The 'fold' patch I was referencing
was included as an attachment rather than inline (but I've figured out a
way to inline things for the future).

> 
> > >From a7d439154c7990418da976e5864b91fce9d49d58 Mon Sep 17 00:00:00 2001
> > From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
> > Date: Wed, 27 Aug 2025 11:10:22 -0700
> > Subject: [PATCH] virtio_ballon: Call __free_pages() in
> >  get_free_page_and_send()
> > 
> > free_pages() should be used when we only have a virtual address. We
> > should call __free_pages() directly on our page instead.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  drivers/virtio/virtio_balloon.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index d4e6865ce355..7f3fd72678eb 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -718,8 +718,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
> >  	if (vq->num_free > 1) {
> >  		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
> >  		if (unlikely(err)) {
> > -			free_pages((unsigned long)p,
> > -				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > +			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> >  			return err;
> >  		}
> >  		virtqueue_kick(vq);
> > @@ -732,7 +731,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
> >  		 * The vq has no available entry to add this page block, so
> >  		 * just free it.
> >  		 */
> > -		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> >  	}
> >  
> >  	return 0;
> > -- 
> > 2.51.0
> > 
> 

