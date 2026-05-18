Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A92ECD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2AA96B0088; Mon, 18 May 2026 14:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC716B008C; Mon, 18 May 2026 14:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1846B00A2; Mon, 18 May 2026 14:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1636B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:10:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59003937F3
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:10:43 +0000 (UTC)
X-FDA: 84781331166.11.9ABC06A
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 558B520007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:10:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFOG6dvh;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779127841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3wCrNm6GaCIAAw/wLOXqXnfCI0G+Noaf5OWqaDbU0g=;
	b=AD2Ku46F43Zot/tVYL5UW2dDcK2uJ+wGIytbKtzY5s/3ILHvFXdoa48JkTp9J/LSBmzZ9M
	SPkRbz2vD0E8Ot7zuZbXcqczQ6/mGGzwf1e45XN7hftd+lx38OVvpsFYxuG+of9psBxUUY
	+HqIW/4N/IDPS/Zavd8izn+TgKFd45o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFOG6dvh;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779127841; a=rsa-sha256;
	cv=none;
	b=biYRVimjTlp+EM3epFu3Wt+ceXz8lTBlWvEGSksE/+JqrY6VaLW0xLNjVS58EOtQqd/eZU
	wBqNX7FyEdHjg7vaErq9bz9rwIU8HFytAQg/mLy8BROY9SWy4DBwcUIsuA/rdr/Y5+IrmT
	dNHInCH8mXyrog/zSDC9zx0zW7C48pA=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aa1b2327c8so2717372e87.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779127839; x=1779732639; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H3wCrNm6GaCIAAw/wLOXqXnfCI0G+Noaf5OWqaDbU0g=;
        b=cFOG6dvhSErYd/+iKrvSOSKjXRJVyMHxqs/2OfbHVE8jt3HxXnENDZnmX7Eh8L9v/9
         R64Yc/Fetk51d8gT/DHqWsgK+d3EbY22ZNIc/uNRZ5f0pSvC84mhGWxVXTXwDg2h7Y1+
         6DAfW1R2Yw70wnJu9uBm9rb7ohoscBfqr6HZ5c/Pj9bzJgEQlNeLUr8HsPO63kfjjbta
         1nUk6hCK+RXy3PzpADRpiolYlbWYBQQ2Esmi2k5GpbHg1cvss7InPVtEwcEoe8QwDO+w
         HN7FFimzjjcPgP3PDwXJOyUM2SWoYmmPLxvSXNs/YV5BxSSmTSK3FoSkaeabAQz4cc0U
         qfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779127839; x=1779732639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H3wCrNm6GaCIAAw/wLOXqXnfCI0G+Noaf5OWqaDbU0g=;
        b=OA79U6zOHuHuSFUyDgckbsORLjqYl7qfhCnA7z2I8u0xleLPLSP+mOU8i+JRCA6LnB
         b27nWLiPYAgSh4rq8jJH0+6ydJn/d8Z/gzk92paeVoHfh8PMZ8pfFK/B++QReKQdBIMy
         GbCZP8r93WvsEScdXhMaD3yCIrSaN4vuttMjH1bfiLJhGlqJoj6ZOV4kRlX5Wh9ljSxg
         0MS7s1CWp6EdQy/NkCk46bZzzvgrGpmr/u85tYVwScHuZmmNsfzZZuoDgS7n1yXVBL9c
         1NctmvEU6Q71Ndn8A2MixUEgwQ5094pgFHzrzjHOoJKFGkXx5G3Qp+KJiyhDy7jGX6g9
         qxFg==
X-Forwarded-Encrypted: i=1; AFNElJ+JPW4jxBC11YML5gJOVCM2Qcjts50LkZNgt/1p4j9vQzwcOqFz5IJjjNEIJNOvXQQ7RDd/Ke6/jQ==@kvack.org
X-Gm-Message-State: AOJu0YygjtXp1tS6lSQ5u1SC0XMekrvxM9Xvpwwm9cuWv+LBOnTJUPtn
	CkHcXy7sJakUIadu6de4sR0PNgMybXUluq1mlWcjWvjmsTZr2iUkZ/mv
X-Gm-Gg: Acq92OFu60L20FA2nQxkSzBlfK0ZV92aHu0asjrIPdsef2KfCKxJHYMKVrqIiiWGwm7
	OTMGTr2NNfQhomlXTJUxuGeZQaNyAq5iwESnUhUyeaHEZsKPqa3qnnFbPpkaM/Sp7fc1v3hy6xQ
	ZBXtXsWru93tWIgWNx3Qn/ZolWvEGQYoKryaHB8ZIoPIawJB0yTAfetsge7d3hQsi7QZM34fGWD
	MObMmLI9oMe4TiGd2PgjdK9HNS/Ri6tRrQU2dwMKVxAfI3K6XTmBa+4xxZR6YsaZkbi+IFR5r3j
	lrCC4iLbcvLbOa69gph2UTrPP2loGyFkvAhtggQ2LvhvrRMUrburjhXbKv9ea8Lmpd0JTa0XDvU
	WzS0ql5Amku0jQu0s+rKlnEJy/CwsfGqon2zMlp6AFdEu3UW/oZFeiH4p7o7OTfyQ
X-Received: by 2002:a05:6512:3a92:b0:5a4:194c:d897 with SMTP id 2adb3069b0e04-5aa0e60aeb2mr4105100e87.12.1779127839075;
        Mon, 18 May 2026 11:10:39 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164cf003sm3427067e87.73.2026.05.18.11.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 11:10:38 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 18 May 2026 20:10:37 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v13 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-ID: <agtWHSdOiJ0hwsdE@milan>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
 <20260512150109.1a7939bb15f3d48ad866c540@linux-foundation.org>
 <8d678cb6-9f96-47b8-a25a-b3a969976630@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d678cb6-9f96-47b8-a25a-b3a969976630@zohomail.in>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 558B520007
X-Rspam-User: 
X-Stat-Signature: aiw4p5qm3j8qhu7w735un1ewhxygm7ee
X-HE-Tag: 1779127841-512958
X-HE-Meta: U2FsdGVkX19iszgOV7RHMKMs1Mjfyq6APNep2QoJWk0/46l8GB+pBDao4LUgNV91cX6OmNge5CwcK1g55rbmCgtWRFDXWFEhs4ZArH+1yOKYFCw5YqFpExZFG46T4trRcgd1lDm9bxtuD9yrR+7o0Xa2bRGuRiz9fERN9F/M19ny4JWd5DKMrBC0BLStClZBKSZHfRHBBWtbQmcuizrwiIoS6dlSHAUUb4F1tj9M4gZYG4VHavrgYU0GeO5I1250HSufcOviLIDxmQVvezwFrMMyG4LPWiuekc1vLi8CCkSVNzcWAThdZBiGL4dufJOd8mNwJ+MweyJhJzk+qOi80Dwbhjj9x3xNu3Rxm9alG+9i7Y6zY0teinOmRDvIl2H3GAnjc3q0QZlj+wCOgV6PPBG4aKKram1Q23FCC+2J1VTFQUjJ3TgZXGGietnmZs/nBqaXo1/NKgaIYuldyccjLpF0crXD2UzHR8rnv9+MSM7ImD5/ZMEpBDn11Yd95mvAxkyvXyoSVpe5B3JXl5Pb3y7sMbCx9GB8VbBJQrAU3/s95j01PCoFbvr8xJqJ6gVNCl3H8iekDAhqA4ezRjFR3tPm5tz67hZAosPc29tdDlck5733UifhFJ3DA0UnsyL6mhtPj9yCrv/ihxh3CvjWRN7icOvYrwYoz6na62giK2HLxza8qUR9b+V38vHhhnB0hLBwFK6aftj8NatbtoT3q3NPZt3KxmvLN3co4Iv/qen3HoOX/TZrPyaQt2XffLbY6MsbTiMloNlENIcVPRIHiJU0kuzZ4X8z56u/zy7HfydCk51yHXq8mVsLN8XlbDwM2Vd09c3IR+f6Ae+wwui75kx931oDbzXO8ghe6VTVGgmOF/1B7n1Z625D1SVlHVPjM6Yt7cuYQOf+9N8S8KOvzxZ+w7CiixuJ4qB/9vbYqkmUVQlXbC2M9nWSJMPLufaYmRHYpkhfXrQ+3AfCX3+
 e4id3nyr
 C+uMYUomMXnWh7/AK30zNp6RLtrB54dzqIZVZTgFZ7MK9IB0wh8jLUm8Fc3sG9XTgSw5Ia1SYlFDsO82YfIAXln6/GFQWgJK7RwTN/T55gnmZGdEL5pZd3dM7IsgIuskT0zY0Snn8yz+xav3iG5kXutTY3GlC6BpUokwW6FU0z8UYAUQgASIoVVRtwqhTSR8f4AQGqDiNjqgqnogEa4zp9A9BzpY1o9hj1/3VW/vwu7XziwXuMLrP9u0N2qVptn8JT+bH4dHNGhMNaorUem1tov5legee1Ipa1AbyWPxa+MRx0Xgt/iSEnu01rtH+RSNpsda9APJNrviS8NKyykM0kDJf/w372nHGLQz3tH3xrIbH+89A4EqsFIJQKB30WtbrqnNrNorOfZrZPFs2Ce66JRGR7pdeO1Hoctrz/yp1viEzEJ/H/Gp45LO5G8ECj0WKmilLClLZRyKRqZCBri4g4S8+YxruZ46wVDFJxkL0m6w5Vy8P87jF/5U3iFxUeNp+FL2Qt8GZfkJqfqtmNMy12tvPfa2j8Wr/0atAovVjwosQpGVoRel9m4JQCKKERhl1Wgnsk8q/fL/xD2iJgnLl6BujDicmBt11WPgpMvXZPe/dleyrvsZz2zNyy79ri2q0Edt1zUK6dxL35i3VSmFqojc9NkxByIaYeTLd+hYn35VwKsp9QuM7IkEH8kAQV1FkQMTcL3kgO5Nc/9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 04:29:11AM +0530, Shivam Kalra wrote:
> On 13/05/26 03:31, Andrew Morton wrote:
> > On Mon, 11 May 2026 13:47:28 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> > 
> >> This series implements the TODO in vrealloc() to unmap and free unused
> >> pages when shrinking across a page boundary.
> > 
> > Thanks.  AI review asked a few questions.  Does anything here look
> > legitimate?
> > 
> > 	https://sashiko.dev/#/patchset/20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in
> 
> Thanks for flagging this. I went through the Sashiko review, and,
> one of the findings is legitimate and needs a fix.
> 
> 1) Patch 3 - vmap() mappings with nr_pages == 0 (LEGITIMATE)
> This is correct. For vmap() areas created without VM_MAP_PUT_PAGES,
> nr_pages is never set and stays 0 (vm_struct is kzalloc'd). With the
> current patch, vread_iter() would compute size = 0 for these areas,
> skip them entirely, and zero-fill the region in /proc/kcore.
> 
> Ulad, this is the approach you suggested during v10 review [1]; we
> both checked whether nr_pages could be 0 and concluded it couldn't,
> but we only considered the VM_ALLOC (vmalloc) path. vmap() areas also
> have vm != NULL but never set nr_pages unless VM_MAP_PUT_PAGES is
> passed, which most callers don't use.
> 
> Since vrealloc() only operates on VM_ALLOC areas, I think we can
> scope the nr_pages path to just that:
> 	if (vm)
> 		/*
> 		 * For VM_ALLOC areas, use nr_pages rather than
> 		 * get_vm_area_size() because vrealloc() may shrink
> 		 * the mapping without updating area->size. Other
> 		 * mapping types (vmap, ioremap) don't set nr_pages.
> 		 */
> 		size = (vm->flags & VM_ALLOC) ?
> 			(vm->nr_pages << PAGE_SHIFT) :
> 			get_vm_area_size(vm);
> 	else
> 		size = va_size(va);
> Ulad, does this approach look right to you, or would you prefer to
> initialize nr_pages unconditionally in vmap() instead?
> 
> [1] https://lore.kernel.org/lkml/aeYBYqPSEJRC8mjh@milan/
>
Indeed, we missed that point regarding vmap() code. Checking VM_ALLOC
sounds correct to me.

--
Uladzislau Rezki

