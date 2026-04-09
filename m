Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9169EA3C23
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501856B0088; Thu,  9 Apr 2026 06:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D98F6B008A; Thu,  9 Apr 2026 06:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF486B008C; Thu,  9 Apr 2026 06:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8C06B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:52:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D952113B7E7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:52:57 +0000 (UTC)
X-FDA: 84638704794.10.D787434
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 86F2C14000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:52:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SfoJFDAP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731975; a=rsa-sha256;
	cv=none;
	b=WlWbTe7yeQ+aheDeRDj/pdgbClP7qa09S0cJJjxKOLw/CnvSFlWLyzWouPYOYriuKsOQU0
	+u8b/ZGpb+bXCfNiiCPTbsoImg0hbEiakZ4yJ6UL+2cG1R86mvBDMXl1uhJNpsG09RMZOs
	yUR9a1ElvPavlgQN3jqH8cvGMH4e/NY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SfoJFDAP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCNnjCDtLuHr5UHP7kVukL4KIBHk7Q20HqZoqNmaLow=;
	b=T1RkMHuefZvCffl2pgBIOJwOdGxFrJA11tH7T3coqUBWdsUp4T9btX/TfejDh6WNHIO5WG
	tbPNm4q+udiHmDogo3FVzs6PaUiyz1EWAPrRY0OrdwCHLAiiYW8JDMZrDeaKj7e1R95Pga
	PkyMQL/YazZLcJK9qw4ylotr32REUXw=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so10770175e9.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 03:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775731974; x=1776336774; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eCNnjCDtLuHr5UHP7kVukL4KIBHk7Q20HqZoqNmaLow=;
        b=SfoJFDAPeYP7PmB7kJ+t150+G9pXB+JJqpIcZ2Ii8KtJ9DySTA1SQA+UnMTV7oSRpQ
         pn4hw4BjQHsjW1jA88FL2T+3W9WPjisR96W/nvKlGAMlatdJmi6J2joou5SxBsZ8mfJp
         MJy0iL98HYW4+LeVmShx8YkJyM38TgHxFki6OTIQIKoPjiQDPH9jxvP68YjBUt2zC0DM
         WoPLIsxxy5DeHWTOTS1IfP21xM9r55Tw0qlL4b+Y30wQK/6JJUh7HbfEo3d6vGEM1CIF
         vohjY2mPrn5476XspcTFvKLozI9Uk0raRMP4jw97HcAMMJGZlWq9e3DcioFKbTkSKC24
         1NQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775731974; x=1776336774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCNnjCDtLuHr5UHP7kVukL4KIBHk7Q20HqZoqNmaLow=;
        b=gd86JsRatHLmKUGVmrCD+e0cir/Gl2KvKCr1sL7dUYgBTsK5PM0h7Ui+dvh00b9d0x
         TyH9P1vS8/Rgd5MiLUYLwBgWiw1FVT3dOllyahi98/weA4sHX175TpDLIiQLTokm4mbA
         e5x0AFcfPGsNjN6alqwJY8QaOjTk+322znAOd+3xNRdJVwc79xCJSB5KlAn9Ypbn2CeW
         wQMWJ7AOLA4APjOf5U70QuMHennM0dF3L/IpX4Kfkb7NH+JogMRZWLc6szd0JNn/vz+l
         K7w53fTqJBefy00YaGP4D3uC0iRnfZ0GZfZo24Vuvf5eHwVMkn0aY4UMJo6F5d1v7JSe
         V2Og==
X-Forwarded-Encrypted: i=1; AJvYcCWwNk41lC6V8ewDtpyUrwTBjCzJ+9r4BG9qtvoqWUc2W55nC87nla40QqB1hB8BeVD8MW07q6iuEg==@kvack.org
X-Gm-Message-State: AOJu0Yxnjk3XWeBLD/XicLQqL+RS212E/t/ypwyc/uzmdt4vughPMeWS
	iHBA2F3iYX+e65go0PMsOCIEaN3O4S0la+rPOK+a97TxSjXZNzs1SgVv37jtGNNY2ZA=
X-Gm-Gg: AeBDieuO24t5rYEyyFk4ZuZZSqv+I4y7Rk+EBAIzXpaDuqeSB70bJpnJ2LTAc6COrH4
	nlmekwO8Z8Coo9yJ8RqIjpvWj5ILWhbWsH5+L+S2B/0D92CeGI7syKq22Xt4i+agS0kcbDLLYb7
	AQgrt9r1RO484dtM6coKpDPWHKE3yqPadvU4uwM5fwz67kmk6WaxMjCM53dRibJlTl21OJWeaFK
	PePenqwKHFHEMLBhHfIo7nALqlhejUz35KdWf4uGZDHyySd4z0OJvMDZOR17ADdfaJfpeJd+WuQ
	Ow2pJfvqNFIwU7hrt+pEgaTwucvLQ8kiBk0teztQYwmk1/b8bHEp8S8GwaVnoyMtMWFZFl1GyiC
	qvSpmNrAU5ak15/EBIgVujV34XbRKu/eZoGbMY/qBFdOMGO90Bza5xqJ+EeZiampJkD+shRhFTE
	0aj6IbBzqLp3R0Ua7SJgyh4z/0YX7neuy1NA==
X-Received: by 2002:a05:600c:6305:b0:488:80b6:873a with SMTP id 5b1f17b1804b1-488997a4679mr330822135e9.21.1775731973787;
        Thu, 09 Apr 2026 03:52:53 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e1c27sm63954645f8f.26.2026.04.09.03.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:52:53 -0700 (PDT)
Date: Thu, 9 Apr 2026 12:52:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <adeFBKzNq9rNzbHk@tiehlicka>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
 <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
X-Rspamd-Queue-Id: 86F2C14000E
X-Stat-Signature: 8esoyw4x9mh4tozd8gi97opzoh164sst
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775731975-155843
X-HE-Meta: U2FsdGVkX1+vhOOLyFIj5go14D0bpXR5259TSW923xGBZ3aWK3eu+2UQBahQbrFXoUb0/Gn9r96H7RpWWyqn94T4aFDVRdHSFB/lQwQsXJ07e6yAuMbNUf/TJ2BMlLOASxQWzx/Y94JuNvl/uch89XDnmzirqsHafK7TZ+UqXZzueabiiTFBYEWkYpVtN02nLCgbabRPVSRK/y6iHt5IsLuc7m7L06TBQWQTn05U8i5PzYieEX6mi7c7eUT+qyJErsLcWA8RdK1WWICnimAJSZTKZHl5OtOOf9FCUhs0Tgsfc05BxjuXI3dq34xz3v8HalnCf1KukHXkM+40GC695tMQGFSX6rMYiHIRffZ7CIrMyFjrQwofpIk32LwgYkZ8OzNVjQjg9utjKgzFvrEcKCWbo0L24in1YCoKA1i48RA7UHeHi8OdNAqfs86gFIv7E+CkZXBg3RqeRmmnu0+clwgdCyHF1Hi0IuDKuv0Q4kPf9n9HOxJhTuVicq6FPO5KOYKuHvFh9AIOYdyip16KH5uFsUmR9bFT1pwfd4QiKd+EvkiNJLZjIpQ7jMrHTpmeGa6SNRmmjnYJms+9CxVUaLzu/Jmb1X3CKpMyNL03AzVg9f8LB4TnJCP3POKMrZKf+Rk9YCWrJ5IUp/mxMLB9oLivfb6jIzFP2WxDGHiQ0JC1quAc1bl1r2aOuOJras+/rweNqTUZt1DRoEDYPdU2YVhQ1CUmueXnF1F+/qJt6UTY9UnXwF5rAs4kwuaRe1fZht5iakfYvIUPucwZoQcGljVg9oXV0k91M1gXrIhfBFrcO6yAz4jliWXuXi82vnZPnNiYtfrek/NGTKe2yuJ8yNXQuUdviIhVOPCBAdKkofy7z9VhZEb9NmrBHNt5R0dxb4sTtUMPcYWRq6x5qN8LQwMERTiLA8jMYYXXRmm63ccE98HGgSG1O+js6Xfe6djWQNrdasGPwRaoKOXMrvK
 g2FDFjgN
 yMEBE+u7BxzzkMd10Peq+di6cDYS/a5tRzyEtsJ6u6uhgkvR8+/Qm8slXjYeItyudeRRUEfAZL9U6bhw8wYfa3WNOKyxwu5CsTtfgQc3yJaQ4eKdQvmxjfqetlV0QLMg57ei0UNjxqbS/ZdqJg0qrWZFM0NPZXssMJwWxs5FErwrbGInS7MRIatCVK0+0uO8yDJqWF+nYHBpoyzFsWfUePtIhGTd1/eW5igSiMasd1AXr0JN4+tBgdxUwjyJ2cFjZgflo99oIqF5oWxtTI+smyFMvF03tp/Hgnrxxfv7cBynIKtrOqkS1fAsQeaRurkVaJyHbZpnsKrItRgYlhZg1sHfHWmQ7f6AGLRgUkDSYy4VSvR8bqyy42yT2Kg1aBKHg5gN8bdWJAs1Wc29MBlmjTmgWSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 16:54:48, Kefeng Wang wrote:
> 
> 
> On 4/9/2026 4:22 PM, Michal Hocko wrote:
> > On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
> > [...]
> > > To use the reclaim interface, there are two differences,
> > > 
> > > 1) we need to input the reclaim numbers and swappiness, this is not a big
> > > problem
> > > 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
> > > but cannot only reclaim file pages,
> > 
> > Why is 2) a real constrain?
> 
> This should not be a restriction, but a strategy. Our product wants to
> migrate anonymous pages to the local instead of swapping them out. However,
> the current per-node-reclaim interface does not support reclaiming only file
> pages.

Yes, I do understand that you want to keep your hot anonymous pages
resident on some node. Those shouldn't be reclaimed by the user space
triggered reclaim anyway, right? Migration will then happen during the
memory offlining.

This will certainly require some fine tuning but I do not see any reason
this should be completely impossible. Certainly a more robust way (from
API POV) than the suggested drop_caches. I am also not convinced we need
page-cache-only reclaim for the existing reclaim interface. I believe it
makes more sense to look at the reclaim from hotness POV rather than
anon vs. file.
-- 
Michal Hocko
SUSE Labs

