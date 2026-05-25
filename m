Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF7FCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60BF6B0096; Mon, 25 May 2026 03:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A166B0098; Mon, 25 May 2026 03:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EBA6B0099; Mon, 25 May 2026 03:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 844696B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:16:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C09B161A16
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:16:27 +0000 (UTC)
X-FDA: 84805084014.14.175F089
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 912BD1C0010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:16:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=orbBgvPD;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779693385; a=rsa-sha256;
	cv=none;
	b=vNhrwpm9ClDLjtRjBjs0ikrmYjGC9Au+Dvkzlf0eeRMTdPzM977JR32KikuYSf+qBrISI3
	6t5cCs84mhdyiXfnU3QqXKks07eLeldzAgVBN1ftvig5DDloTfH2wmC0jqjaluqmc0qMw/
	Wi8GuUyqyHZ9aocRmQsjcaRDxccQTvk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=orbBgvPD;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779693385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlgskWC4o5Qm0DMaNhMfLNKI2AtdeS9nvBrbJtwACp4=;
	b=oCc3rEDc6jtu0GJF6cOPjDaX0YVLyTfmjTBUI663Kii1W81t0PpT3Ha/wpVWU58k2TR6T5
	cMPQ3YUMk0O4MVzpfGp1KSvS2eZ+Gbun8m8IiB4SAiqYnf1PKDEcZ/udFZ51Cy8TWZnPI0
	yEECWtQdcDzbEGDa1ziSXiTXcqZDr4Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BlgskWC4o5Qm0DMaNhMfLNKI2AtdeS9nvBrbJtwACp4=; b=orbBgvPDaxmqagpne2detWrEEp
	u3RL+AZpBb3xQQH/2ZQrAY+P1ADM4Z8zcgBuJVsIZJoY9OJKcERabXlGyjePihqKXYixveQ+D4GOy
	eoY9katUbX6HiGom0p/dcIBdDXr3bhwU64i5AhjJ+v+v8XNYh6eDjzB9+kVyZHHoYWr0RGqKpN9Qu
	7wuxU+dAkV+z8KPkBkkHxXoqiTvp59JSsrG0F/aZqe3hfknPlJx0TpWVAVqqdM2ybKK+BlhqMoeDA
	LDWGMt+8ac+Rz9BT0CddOWkt5/Jh4yqbgvqTXRZfhcYt3r3dxCElCSyDqNfYrE4WXVNrldHn8zkyL
	umMMl9GA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPXz-0000000GVcp-3QkF;
	Mon, 25 May 2026 07:16:23 +0000
Date: Mon, 25 May 2026 00:16:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahP3R2nH8-bHMVf0@infradead.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
 <ahPxmSqT4Y4jcAbQ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPxmSqT4Y4jcAbQ@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 912BD1C0010
X-Rspamd-Server: rspam03
X-Stat-Signature: qx1jx46wm9x3jro6ij9oo9nnqqecdwin
X-HE-Tag: 1779693385-201889
X-HE-Meta: U2FsdGVkX19VtV8a2qPR10/R56pvEEttuVQMMFUZ76LjuseAHQweQ8BKOCeZadTRPUbQmxRd30xd+9UivHyiUlrPG8eMPMe+VHPe0n+Vm6KeUTa/urC818wthLPLOSPl1IyfsJ44Cg8f3O6yQWetWofLSlgcg5c0yPiM0m0BQXQKnhYLYfHjD2v4AOshe440fSqMrzFFZXK3HZHr6ev9a1ath+MuTrRlZ2NWJLUuIiTI6qEAqw0yaQnrNuSSmWGEZlZy2ldD7YhAypA0dAaCfTvvxbyPIYjyrRdQyOgtHsVGkIeKr6CXiO4W/Z2uySrRPp9GjwApUCw7X2dYOIFB6bI/4ym5tcUo1DQ33Gta8ZbatgBJ2SSXiPWz99BqM3dJBjkFoWJxXLh4eNfKnPJrrsMmWeiqKKMouKE8DkHEhy/icGPRWj2JHYQBXXtPuTljkRqSk9fZGDRyzzEizeSu8E7dUxLP4kjlaQmPDvzIwGRGY48yCvljLdHpXp8SlLILlklHSz5Q4VZMeEmixaDxTl8tXxprDGtztNbP3gTiSp9LfiqUrD8TwnLnP/HwOIc4fiAMa4Bcs8wCcQqwdJO6A0VvgZ00KdbdDRqD3aFGkaq9JvWq7SwyFnuWi4MrSzIGzcLqzZabHy5Pend2rlbMeI4Af02Inbh9BYZQ+uSzobtjrhjRvaWY9jOo6OyM4+7vPyZ2HFk5Fhdd2xC4rel/oeJDZ6w0Dj0584H7VAabuFVFRkGxHX7Xnu0tbXGLy1Y9ydUj0qL4oTyVKlggS69jTrzg2PxfqzBtVQ94F64//kVMUnQZZvebRiFGl6ZT7DRtM9zMgZr1k6PFto8Y49CBt8rd5JXRREyyPApIxAhToU1aLcwJRPQRceSA9xW9VEI1k+6tuXVloxUiQh0LaqNGMSQpXK6uVeb45YrNxNjB6O6zWObz9cpch00rgKbwmQnylE5VixNTYdbcG1E9Y0r
 04F11DKN
 22/90q92BZgz9ggv5jnd89/rZI1Dr4b1/9eIu4NtNjEBRaOLUdApDYnGnP468COC//bvlZQ1N3z6LLrfHU6FcQcZoL7HFkwYHcSAdIQXWPaJZMmu1k2SXfirwcLinFx1wjlg9Gh76xFYOd3qBIgAPZfqaU7ZOZebGb75nLjzhTerXHo1NC68QE/nZGwXPpYu+8x5PbnUDIC0BIWmkQKhxvHTRQ0Yw7t1GclfuZoe7Bx8AbKvN6X0YEReevGG8H3VaxP+d5lzNrMf4InBqzq+arydc28m+CL92mMbyoQ8peGZTX7eOwFAShSbgPuMaCA6myR5OifydD3IdW1ZYWV89BaqYFRwDwtgSm1qLTPvwj7YnaWEWt6ppJO84m2jW4vJwTbsI0qasXRDU8xxkqieEZMPkoI9ZRbxkG4LMhtL1O/qJh5NF0dwUDjfyJq0MwHuyidpUq3qceBsRls+rz5MRFQpB6QmGrpo2uNxV8GlOqclXOoz0MOIOHKXbBzUm9DdSjlXzNZdQ/m1bqdZCOPYTcCATaJFw/Wu6ShybvJSXeUdlB/Md9eMWmR6NvQtmlP5XzmFoa6VZQf193gIGL5yHkLrqGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 09:52:09AM +0300, Mike Rapoport wrote:
> On Sun, May 24, 2026 at 11:08:31PM -0700, Christoph Hellwig wrote:
> > On Wed, May 20, 2026 at 11:15:52AM +0300, Mike Rapoport (Microsoft) wrote:
> > > check_partition() allocates a buffer to use as backing buffer for
> > > seq_buf.
> > > 
> > > This buffer can be allocated with kmalloc() as there's nothing special
> > > about it to go directly to the page allocator.
> > > 
> > > Replace use of __get_free_page() with kmalloc() and free_page() with
> > > kfree().
> > 
> > So I heard various vague references that we should replace
> > __get_free_page with kmalloc, but nothing definitive.  Can you please
> > point to a good resource for that?
> 
> There was quite recent discussion when I posted patches that change
> __get_free_page to return void *:
> 
> https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/

This doesn't tell much more.

> And an old thread when Al posted similar patches:
> 
> https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/T/#u<S-Del>

This does, but it still fails to explain why kmalloc performs just as
well as __get_free_page(s) these days.

And such an explanation or link to it should go into every patch doing
this switch.


