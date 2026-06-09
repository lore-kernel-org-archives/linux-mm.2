Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB2ACD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04836B0088; Tue,  9 Jun 2026 00:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4D86B008A; Tue,  9 Jun 2026 00:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAEE6B008C; Tue,  9 Jun 2026 00:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCC846B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:23:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15C5A40401
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:23:58 +0000 (UTC)
X-FDA: 84859081356.13.C29C81E
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 328E38000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:23:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rqwj6kqH;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780979036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIp1fAQDnn86oxS0ZtsIzqUmKzi30Ra2bA1c7IATHpA=;
	b=5I4uv1yPxgtzf95LR09w0dPaEiiPNoY3wqNmrJcejBG+mtCzcSKj+Rtxg8JADKPRZWqaFu
	qURi7XPn4yo8C5+E2SoSavX3RuV3Lmaq3iqgVtMjAXf5pgoblglkuzyE43Wiuft+pBE6lr
	+WcOsJmtWAI6YL9H789HG0VcvmU/9kE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rqwj6kqH;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780979036;
	b=DDhbwMXes3u0uRaN2qtjPyEnrr6H5urKHepf1tq6iCGev5AEB5BOy2RPTpB/dinXq9YC8G
	JfwFdBfRZ/gnaNsh0+4a+X8m3/yteuCptPv7GQtkdBvpuEUxCfx+PoosMc32Nr0a5LSqmF
	UKkDIj7pfPjEOt8bxnrGd22Kmuc8yqQ=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6dcc22cbcso4479875a34.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 21:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780979035; x=1781583835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIp1fAQDnn86oxS0ZtsIzqUmKzi30Ra2bA1c7IATHpA=;
        b=rqwj6kqHFhFWvKTyL1XRy//ylVIb3SCGdOotz/fD5qooioZk5c0bePYkkAePuDEW65
         eXev7lhEEqUfjJ+UhEhRvUuhHNbFuItyRbm3xJIOHYfNmocNX2PelRk16auowLeGjR1R
         FHqesYus2s9Rk9XX4wg89EanYmHcg4DD/ILQkET5rVAT9dIFfwDX3BYayZd3ETQZ3xXz
         Tba6wOmf4/eAAQ1biVTudDljQjVOqPpd0+U4hKyv7mzYdfbQZCU04p32sSLa83H1UqkZ
         QjuTxWunVKMlHbfHqy89QARqSKWgQF9W8rIPGbda+8VKsYapKKE3G/v9xVzjEqU+Cwl9
         CnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780979035; x=1781583835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xIp1fAQDnn86oxS0ZtsIzqUmKzi30Ra2bA1c7IATHpA=;
        b=ns2BKCuDVIo5imGrZ0HfvCAwUG3Yots/YBhcvsfktIjNvB1F0u6ZMsFdJy9srYuESH
         A2BSyWRi7HowKNAJPh8vV8vyz3sDMEE9yf61WRQ7R6XMeWBnCuDxXabM7rMnIGxwgb3m
         cIGEURAvGn/vnEYYYJUDifZW2vXe8WxlAll16070IOlJGWrDVgkx5QfpZooDlf4uLJBn
         6mP4lF7V6hQqwC1QKINwGDKPESbVq37mWpG8rvrw1dH3oSjr2BQjhd/xPJOpnM0zQtpF
         nttcd1qVJnjeet3EccZ6nwXKh60212qGVIQdx7ZlCkZl1A4phkCrI4wp2Xl68RWxMtii
         rV6w==
X-Forwarded-Encrypted: i=1; AFNElJ87P1a1JVQOkUhAkyAwuoOp7Gl/wzf6Iwwq0BCNPOvx4mLMr3tb65q2/Kh2WtfCQuoUkk2PwsMiow==@kvack.org
X-Gm-Message-State: AOJu0YwKn4o/VKqEPAWeFp8by8GSgwv8KFQkCvMG2mzu8UlGZwcOz01X
	HJZ2G0fxSy0k4IraP/XVvAD/FjTjQRtl1yRr3lxVXeDmj4pbcnRKewCi
X-Gm-Gg: Acq92OEtN7pUW313c+qnrGcH3PcJRi+79Oa4gvE2aV1ALk40YRAaBLcjk5/XEi34Bev
	kT4+5v3FMXfgrxw88F/ve3yzOeA+Ax/L7RsoySM7CSdvm+v/Bg1FGG7WNKY0sLUXVXIk4Efed2T
	OkVZvB/py5a4AU9WLLpZioJRrXMDRv6XJZe/qp3pTAq2My34MibPFK4eRHP06ADpCkDF4iIswUN
	EZnwNhELGrARFiXTP/cQ86nrZE723uxZF7UeuPJKW4+jmVSEFMP0DyItVyJTCfIHdZ518gnbdVz
	vPd48stAaNuTbdyKbw/bnvEpFlmHikjmNQ4JrnqKyYZPfPeo88agPB+2SYv29qfTwVIkRPHmCiI
	Gr8z2Yc52VFEtkPdM2U1IT76PeSsh6/Xzm/HCrgq4dqwJLjT+XO3cqr+90PejC+RPLGtroReivq
	1HvRXW1us69z7xCQjs1+mD6QNmPU4/x0FHczzVmAJ5OszTPbHE3CH6i3dj19IjaTWuy3hPryNt0
	uw=
X-Received: by 2002:a05:6830:3883:b0:7e6:e385:4c1e with SMTP id 46e09a7af769-7e70c60dec8mr11089234a34.4.1780979035155;
        Mon, 08 Jun 2026 21:23:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e745fea5sm12954375a34.5.2026.06.08.21.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 21:23:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Charles Haithcock <chaithco@redhat.com>
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Respect mempolicy when calculating surplus huge pages.
Date: Mon,  8 Jun 2026 21:23:49 -0700
Message-ID: <20260609042351.143573-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAMcbwu5=TK_EjZ=wN5fqLC-DVUendE+CBWX0pN7KBF+1ZwD7Vw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 328E38000B
X-Stat-Signature: knrxdoxspozadnsmfptgkotkagc84gat
X-Rspam-User: 
X-HE-Tag: 1780979036-710528
X-HE-Meta: U2FsdGVkX18hjmdp3ZPAxOKf2sNg6lwsBBrwEyRecesBbWMWTL58zxI+3zbsCAnAAkukbF//B0Ax32bGng+eQWl3Zp5xy8VslHp2i2DWxWWNX315OO1qoiIvIToYX6sC8EWt/fFDLQ465IGVK+SO+vo23WVznrhdcO/HU9BAoqNlK7qFYUBVbROs36IjD5P6eGGCOekrj1uEQ3k2QWpWQPmjiUVNpUFf5fuOF2UMaQe4Z4zJBE72lWnSswIJvJ2jBXFwpX/Y4aqz23NfjZs1rYn2WkNnR8JFGrC6K3o2ZV8iP3q0f9P2hGTwcwG7RMrY0db03QSDAqJMKA2mqIG4xuyWKyD5e7Q8ldXiyr3AyGNITZUe/8DLzeidZZE6VfTTmIAkCOueGcMsUsoZMLuyzqYr74qKi92/zINxWAV1f2XLqLTXTQk1BDxIDuQI7MbE81pcozrnayQOjsxlzG4qhEgHuPP+bDeyW1rqw7TqMwktN0wJY2xJZe9GoVoNdqVKfmTRZ2W56rNDSYjmPx3X4yZEWMUFCiVtNj1JhvQVP2WPQuGv8OjJqlaY0bIPW+gEKbCJw4KUlyVrCihGZfEsGMm6lrULOfcWwFYB6o36YM6sra7R++uSGeqTAteNjTXqnMERhpbCJEVV9hKH1AKbM54bkKCoUuNVx5oZ0UJf3CbE87hd7OruhkFKJQFV9zC7i9LiUr5v6eVvXYnfwXN7CBPC6MrCgQw3jsISTuT3LGrzRcQ+p8nAb5yxmHT4obOxRx5UZrF9vo1vHI5TIqJM1c1enjzJXRPFouri3RY8TTAUwzncoOBtYXZUsZD623Dd5ZwSoIGuuj0JRkA70Nqj9lw9Eyn3ky2Voz74W5mTuyaD9JCd3TPe/KPNdCBm0tqATTVUMBgh2wwBtOIs49jM/sLXTxHTf3zWkiFyCuH5N4rUH8/VgF+8OJHOskWjJ5XTeeAokcAU1nrxoZngZ2X
 2qYDLhNd
 0alkL72wyHoI6Wzn+h/NGWktVwYjl4Ij/FP6da7uC8LoI1RB8jyrEMiF5h51jdavziCd4YN8hF29CPSn7RnjmuZ/Ae4TwzlxXAqvCJnhGE5BZQmHKjoukVQkAv86R3khIWhk0y7/3k7EB0cW6E/XVj/+7Kq+dRokUas++9+QiCtztFqNOXBmawE+JVGXjXfxCRgFm481VJOETF1FvfT0pddEOI3ecY5/j4RYpsAVLQ9IeaNod3uyieLjkbRHSEHIZoNj+rDK8qtrVC1OigV45SBjBrJ4Rd8XTkgaFveY15peswc2zu+Y3A3mh5zcOIpw7AsBOw6dYgl1Aw3otsLnfc3dYy4QLnY12qw5TRL4dTKc5Js5WWEM7/kwMloPP/WVHUfBe3Ivg5qRw3GOlxIgzDS13aAyt6yr0hd33beQfGVtFiPNA9IUTg1auWUp3lYBqSrCVUT2/owJXk0BxzM8IqM88f0rFlpm7aOS55cXmJsLubi7Kbze5bXf+JL0KQGK7bdl1bLUJZMsBiyshAVYLGiEwcTnfTy4FjfuDF1tGri9QUgihETltczZNdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 10:21:22 -0600 Charles Haithcock <chaithco@redhat.com> wrote:

> On Tue, Jun 2, 2026, 9:20 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > Hello Charles, thank you for the patch!
> 
> You are so welcome, and thank you! I'm newer to contributing to upstream so
> I welcome any and all feedback!

Hello Charles, welcome!! : -)

> > I just wanted to add that it seems like this is a known issue. From the
> > comment in hugetlb_acct_memory (the only caller of gather_surplus_pages)
> > we have the following comment block:
> > [...]
> > So it would appear that getting an exact number of pages to allocate,
> > and ensure that there are no changes with the reservation or which nodes
> > those reservations actually go to is a lot more difficult. But I think
> > we can do a bit better.
> 
> Agreed; actually, after submitting the initial version, I went back and
> have been working on adding per-node reserve hugepage counts to the hstates
> and adding some selftests for them. It's going well so far, but I'm
> hitting an issue in accounting where, after reserving a static hugetlb page
> on node0, reserving and then freeing a surplus hugetlb page on node1, and
> then freeing the static hugetlb page on node0, followup reservations on
> node0 additionally count towards surplus pages even when there are free
> static hugetlb pages on that node. Trace-cmd revealed allowed_mems_nr_free
> is returning more than what was requested resulting in the over-allocated
> surplus pages to stick around rather than be freed back.

I see. So from the perspective of the system, even though you free the
static hugetlb page, the system views that as unavailable to other
reservations and so future allocations go towards surplus pages?
How exactly are you freeing the page in this case? And how long do you
wait between freeing the static page and allocating the next page?

I wonder if you are seeing this issue without your per-node
hugetlb page situation as well. I have seen quite a few hugetlb folio
reservation restoration accounting bugs recently, including some that
I think are still in mm-new. If you're developing against anything
other than mm-new, I'd suggest trying to build on top of that to see
if your bug still persists. 

> I plan to dig into
> what's causing that, however, if doing so leads down a nasty path of adding
> per-node accounting, I may need to fall back to the first version of this
> patch (but with selftests) and be ok with simply doing "a bit better" like
> you mention.

Sounds good! I wonder if it would be a good exercise to measure how
much we typically over-allocate by when using the simplified calculation
I noted in my previously reply.

> > FWIW, I think over-allocating is actually not fatal (although
> > overallocating
> > by a lot is obviously not desirable) since we free all the unused hugetlb
> > pages at the end of gather_surplus_pages.
> 
> Agreed on this point as well; afaik, surplus hugetlb pages are viewed quite
> differently from static hugetlb pages where surplus hugetlb pages are "best
> effort." Obviously we should try to reserve the requested amount, true
> users of large quantities of hugetlb pages should tend towards setting them
> on boot rather than dynamically.

Yup, totally agree here.

> > [...] I wonder if an approach like this
> > could work:
> > [...]
> > So we compare the mempolicy-perspective "needed" and compare it to the
> > global "needed" and take whatever. Since we are taking a max it should
> > only ever make it more likely to actually succeed with the mempolicy-bound
> > hugetlb page usage, even though we still can't make guarantees since
> > a free page on our node may be taken by a different reservation later.
> 
> This is considerably simpler than a per-node reserved hugetlb page count!
> If I end up falling back to my initial patch, I will absolutely be adding
> this and attributing you. Thank you!

Sounds good with me : -) Good luck and have a great day!
Joshua

