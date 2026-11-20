Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85A260A260E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j22ljchu
Received: by kanga.kvack.org (Postfix)
	id 041C36B05BB; Fri, 20 Nov 2026 09:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35196B05BC; Fri, 20 Nov 2026 09:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBC56B05BD; Fri, 20 Nov 2026 09:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4FF96B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:20:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BE42A88AD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:20:15 +0000 (UTC)
X-FDA: 85455707190.09.45E35B4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B2BC2000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:20:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j22ljchu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795184413;
	b=Omvm2bafILuhkz3OgzqA0zilDy3L1TBIpweQ5RHfwEiGQ4nh1/31fW13uaboiwc5KbugTE
	4BuefM62pouIZYiENTY1p84SqG1cGcxHaM8D8JqOodtjZRwROzStLLz1jV2T+LZn/2R/pj
	mostfENEDZURgM5BplaHY0QwFlGW4Iw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795184413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZKnDY3fzlC6VsJ3+sJIUV4LE2tQFmEUFN5SVkPY8Lk=;
	b=Vh3yv4PdHx2+yobDlpq4DFj76tr1JIYlZCxzrRtAmPQ5F0/MaS77NtSJyGmm/KP6udsm2h
	eyp4xeROSAcs4k5+hMHr9BpEZQimKLrDW9fHxqytZu7HSr85YmDLZeyD8aMZoSl3HQuWxq
	MRWwhsr+kAd3p9+uwuFKMfhZowCi1jc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j22ljchu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-54492d8a988so289171cf.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795184412; cv=none;
        d=google.com; s=arc-20260327;
        b=dJEgaPDFQTAzrB7Jna4IaO4n+8Ox4LlRYvxc1Rp5y8u8fhDEsWw69qAE18DA6Yy7X+
         V9RhkrUjDO3hgTyr/jlbXTtPn1e9AFORKlhl9iTeLAtuymZvsj6YWDdIZLq3b7Z+86fM
         KhVGMYWa30MT5TuPBwKrZfjHXVzcIICm4fTRq4cntFpa9XPrBF+sbXfsHv7hb4EeRvk+
         b6vJh9CNJsz9Epu7z6lbEtSD05t4j7AUxUoRhVuuoACV4PI7OvO61OSjzxYMtb9ySwPC
         mGqy9g8I+zlLc7oxMNBDkKZoLsGw2FWEFboEnn9uQeeMOAFxHjwdNI3BT0qwFN17Tq0Q
         NM0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZZKnDY3fzlC6VsJ3+sJIUV4LE2tQFmEUFN5SVkPY8Lk=;
        fh=FnaJIZry9L5srKXyYlPt+qQ9P6s5a5Gqmxg5oWtHzys=;
        b=S/hwMNvh8mhJuDs+SFCv0AyIaInkk9/yiYds2dwkfSG0oz4ZstYlrfCrXqXXxPR2vm
         KOWUsz6XVZDsS8wLh2LOkiS1/UfPjyEJ223ghOg5R7yEtVTi0K8y+uNfmpYMgCarZB3a
         g+GKY0k4mahZtqfSSEY0vSAxl9mCkwMOmJx+gVg6i2s8f9hHHYPw2BByhZSgRF4/K4uT
         I7W2ia7jNeEuE0kEL9AEl7N4akRZmFI0TJVV8VYfDYrYRD4Wy/27CS+p4kTYYsS2NnfO
         TI5RZ0+O57XHmbHj53f10JADQdzhbpLNW+62lY8nMBxOhXt8AaObMolUtL3MLvnVwREd
         KysQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795184412; x=1795789212; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZKnDY3fzlC6VsJ3+sJIUV4LE2tQFmEUFN5SVkPY8Lk=;
        b=j22ljchuiWY7EVwLL8YCsy6a4WqP3jL9qMqo/q3Z2rHR+7HdmJfXkYDP6gZq3n9pJr
         rPHahRU56mTlhCem/C15o0i95dzs3ujmYe8IryY/oV5nFOQDxM4rPYkuSFn6zmQHww2N
         lcSxWdzpnlXbimRE9fDVO/E7j/I0t5NnRKe1wAr+5qH+JmDj2QT0DGSp1zlUURLGjB4G
         xEDeOyQj19e7Eq7/fIfI9Z2RHzTluT/0DiPVo9+r6kfwyhJ9gu2mvF2AB+tpiwmTZXWo
         JI8jRJckhL1hFUtwt2PE5JWod2lV6eca8SoQhm/yj0i/WI6psT75JIX8Qw8Oe398Ls5L
         FQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795184412; x=1795789212;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZKnDY3fzlC6VsJ3+sJIUV4LE2tQFmEUFN5SVkPY8Lk=;
        b=vjfrOuRmOLfosMntHcF3NDjTrP+Oh1/qe94CNitKdIl9+7h/1jPt6e4/kHX3JErawS
         z1GP8bCkYEjh5Bf8+ndFo6tSt0aDUIsIKNGqkriSGwewr/Z90IyuNpvQgI1uhDElOLyL
         TUe8Nyci3Q7d5c/MqfjYEoH871+wq5GhymuM7mIdjB+KQ2epDkMiKCQq/ImeoyIg4KPl
         P4L+Xq4oThkhvePqpR5Q7FiF8isyy1GKMzIzDWgz+wjaCUGdGlr5y1fWyli0URnJkeBA
         qrl0lFwn9oMBL4pQvY2iz2Do8sdRxRXuTI2XNaIZxEOcoNkMwRSvu558rBSBvSI0dinW
         5X4Q==
X-Forwarded-Encrypted: i=1; AL+hErFdvl8ITbaFeKdUU6Z5w6LjkRW1S1U7zRigFyMSXQ67cNZpeVWlYDf+eeTlvYKwP1B8vkuNTf26ZA==@kvack.org
X-Gm-Message-State: APuU4Z8dE7B5Nz485DIP2tbI2HN8LluaXHn9AI17IMZEIZCPdm51/db5
	Msf9NVftsSlTWbSzy//Dzrc72TO1IR6Zg4EmboKAOtwXV44lb/L8qWfy5p8EQZbC2Aj+VItAWVt
	kqLTt9aKzodDJIpt8SAhGqCP/ThDuqrv6NNRxnnRi
X-Gm-Gg: AYBFou3Xi5ZQcJYeEyb968LXsibg4pNzAtOkFIeYUAVsFNhtY6xSAk1OHxDOUT1wlzu
	NaX2HOx2/qkR1Xpec5pMGSbjMxBE+MMc+SDYJPHmhipBzC+VvVSrQnJNI2cwwd8I/PsCIjnXwsz
	nDUgXO3kXGM9unW7EjTF5fADQ4sS9sM7s2h5cUn0bx1L/dcf/kas3ENEFBsSeF6MljsviszEIa6
	5Z2yxRQvsR5zrAzK/C74YMRqo/R7BxfypbuJJ82MhAGJl+cQelU4Te5OTTTJ00mjB4evZ/iUKKu
	Q7eM78Jqv8a/Fur4X78v2JCWp6Uhug8UYkj6EoyneyaYjUlP4PG/T525YsqpKi7L3XJoU0duaHY
	b5WqpilFSsNzO+wTbfwQUnYogNEkKnvVjcS22Ag==
X-Received: by 2002:a05:622a:8c8:b0:55b:ce7e:e65 with SMTP id
 d75a77b69052e-55d7a37902amr16973301cf.12.1795184411359; Fri, 20 Nov 2026
 06:20:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca>
In-Reply-To: <20261120135013.GO3115493@ziepe.ca>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 20 Nov 2026 15:19:34 +0100
X-Gm-Features: Aa3M54r79-wonm4abHk_49DjjJPxLMhPkMzG33LcM6yDH6fwirGgzaIY398cqTc
Message-ID: <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: d513knm5gocngjgg3e536fkes3wwh37u
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B2BC2000A
X-HE-Tag: 1795184413-768943
X-HE-Meta: U2FsdGVkX1859uvhbWmqgqrczlepp96KilbJPoYp06YkAJ1V9RNcX86wewIE8YniCI1YbR+A4/18+g/vGyby90aOpjj79JOaFpTyzg1Z9nU3GSOyIkXMLZtPEtfO4PeEVF2uZRatW9lyMRE0iXBaSWkMfvbuxcGRCQup6zEoi4Lo+DhjCUtZwYcv1JfngufuwOjv4tf9u7J+iplAU+SnyWbmwcd9249Q0CxQj0OgbEjm9eUqGnI+Vc46yZEKYYj1f4pY+tbQC543zuAcl1VQxxmh/hkXz422BTLz6pBbgyIjRfMtVJ1ooi/VYBOm2pUWN/gJfdaaB7MWJiKIqnrEUkKwV2L9At5d3ymwP2YBJotQdmxnmirXH/YWiDfveSlWj70ZhZAI/UKC9O5riEBNW4Ecg+DIus7MQX8tANIGewFZa57ZGHL28ZTq8SeAQPXQzdIGEmR+wrH9tI9YZzaMyDO4fVEo2dwFzdPxvKzVz5ol3uvpUCDYZ6W/p54AzHtWcOZdcr1MgTPMtINWJuiaU1PRnVc5Pz1jwcKAPJozo1PlBpfIBnR8bLQZrvT7cDWwdZdmEjEurPaZpZDOjdotk6C53aRnMF1yLE2kXNTm2O5xYi7J/DFDHacHfM/Lz93wf8RXI614Yq9oFHouA+jYkzgM5o2LmWcvmra53vcsc+8Ia24LsgviBV+eRZii49j1XKNg3iqmDR9y9Rc1CoC/ykDiunFTjtMOO35IMmCM92mypHIVcrLxIuRvQgCcxS1ZJfk/NoCIrDoL9eo4/tcMHb0FIQXY+r/gI7FR/m+MAvD/PUCBT515XEPh8stKwcyaZddBWaak/2j6lyiBDF+t365ebeC57kDKq+1lxPM0f9N1Wx8gYc7Xry7/M8WCvqJAyi5i8Msvo3UcC2SakRxjXhD9lQbJHuBWv65v/KGUDIMAYMeb76PcPeaVh9y/Cthl7qV5ytskZYoq7oIDc0z
 t21ZCDSa
 g7Lhei2DBtchZXwREz9CANdrS6oqGKlKlmKgbj/T3vmNjG3jzSpy5eclx+LZDWyO1WUsblPAIzlsQVpJshmBZ0JtomZMNLCRxpdXEdkNGcFJ3ISa6w+7X9BGJjstYGE58MvztWAnCSj5RqKg36+rGA+DJL1gZwuBg6jTFERKZm7+sBnoudWhblYSzR6uJItHHYvNdeC80rxkbvxJpbGR8huEQRZm2c+Z0c9G4PWVXoLqHgVit2pxn6lNiTK03k7YK7XFQ+j8rw2IuaCAgSSo9tgqVDYguYgxqhy68FCY71Bkoi/TBI9kki8X/e4TuOtAJSndtkdJtgNk9hmQzUFNnLpLYbt1/cOIcwMR9Nfozt8VQXKxgRri1naD6S9UjdUlnG+i+6Xs3R/u8lONHMFvKk0zR55iVHwE4eNkfoHYbNzUvl8R09cwAbph4iLF2MiA1yb1dplJFsHE5UlVFQYcHsyGP6w6+R1ltTebc4a7qwpXiHzn5WAx4ydUkJD6TzZqOGD+nbXlRcin8JEG54r6543AIb9McHpe4eIDjKqRXmhp3SvMij2Cx7vYB0+53D9bI8xcZBc9cC+XAbv50ZeRMxLq18w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PIS=
A
> > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
>
> I thought the conclusion was to just do this stuff in netdev pagepool,
> now you come with an enormous AI series spread across the entire
> kernel?

There were surely comments claiming nothing outside net/ cares or needs thi=
s.

I respectfully disagree, witness is the fact that e.g. there was already an
io_uring proposal which is smaller, but does not address applications
that want to use the standard disk I/O paths (libaio, buffer cache etc)

Nothing has changed from the initial series in terms of size, use cases or
subsystems involved. Large files are placed where they should,
the series covers the same three use cases (disk, network, CoCo), and
touches three parts which it has to touch: mm (most of it; it is a
memory allocator
extension after all), dma (it hooks into map and unmap, not a large change)
and net (the pagepool change is a couple of lines; the tx path needs to
touch more places because the current stack assumes all paths have
the same I/O requirements).

For CoCo, there are very fine grained controls so the bounce buffers
can be enabled only when they don't pose a risk, which in turn
depends on the threat model.

Specifically, for network tx buffers or disk writes, the user-to-kernel cop=
y
is basically a bounce buffer provided it is used correctly and not leaked
elsewhere (which is the design; of course the implementation
needs to be verified and possibly fixed so that it matches the design).

cheers
luigi

> > - Needs bounce buffers: in Confidential Computing VMs, PISA allocators
> >   pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies=
.
>
> It seems this was ignored too. We want the bounce buffers in CC. They
> serve a security purpose. You cannot loose control of the shared
> memory buffers have have them leak into SKBs, user mappings and so
> on. It is not secure.
>
> I don't see how any of this is valuable or necessary for CC,
> especially when we really don't even expect to have an vIOMMU for CC
> very often..
>
> Jason

