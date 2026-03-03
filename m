Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3536EDA6AE
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159146B00A6; Tue,  3 Mar 2026 11:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D306B00A7; Tue,  3 Mar 2026 11:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FCD6B00A8; Tue,  3 Mar 2026 11:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E73E16B00A6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:59:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C9FE8A9A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:59:14 +0000 (UTC)
X-FDA: 84505362228.13.226D0FD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 74A6640008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:59:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="acA/tXUN";
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772557152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FEv90vReHYT0L9srNroqmwLlfOuALvxi8SW9QHvPXM=;
	b=eKM58ZoZ1soGxBsqMHGOzFY+GDXlDDI45HdTQ8bynWRNYL8s8dyks8kssi3OwByibUwDRc
	kUYGei3IYOYDy+X/uz4utsAWNZWgHUlwlnKZ8/1qs3b2To4kthPb86W2imq0XJX7nBkLI5
	Rx/QjWeRkUMm8HyKt7K6T88OAwbakvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="acA/tXUN";
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772557152; a=rsa-sha256;
	cv=none;
	b=mkDuimdmKuxXNSL/MMVQnk+kbvGRfSyi1uz63W4j3S3cUZf3+cAIfUsV0kvR5E4zBSbbWW
	J6ojRyzuMiTUwJEPBRyB/b7FIP48nF4RzUWJ2TH4YrQxGhJx/TvJTdtJJ0iWLzGmZrHKoE
	ZQkMZ6bAVIWiNz//2jxwOFAWP8H90p8=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb420fbb5dso339691585a.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 08:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772557151; x=1773161951; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6FEv90vReHYT0L9srNroqmwLlfOuALvxi8SW9QHvPXM=;
        b=acA/tXUNSfSLR4/FtSCyTkzsqqOm60OwmkJiKLJqeoi8j2L0cFrPNZ+rt33UtNupiJ
         IyPmz9/Kx/Kk8rD0AAzoaEVc8v1CQ0ZMgN8EUkpCb4ZhDALVEDevaX3ZVKGk4SzXpWbS
         oRdx1O2uaEpjFt63dVUuhqYrjtlkdW/jpjx9UHrSZjV7dSGGrQQHYEpdCN9EKU6oEiXU
         Cj9my7+098MiYL17XFHp/TZCf4XpG/wtysNCIbilcwxDDrDM35Vd0MiYiNmIfncJ7cza
         IJbZtxrvB9aeD4fNzM24/CGIrYTuDBe8P5hJKuMJsErF501W9kdTVAfUCfaG7YW7ViA+
         M9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772557151; x=1773161951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6FEv90vReHYT0L9srNroqmwLlfOuALvxi8SW9QHvPXM=;
        b=V0m3zZknF7p0ilzVi9eWs1L6HBdVLJRH+6Xh+HypO5hNqdc32uo+trLq9/MSuONeS0
         nLDMx7YWRkocnguJIauOzpfVI4naXJqo4sZs1TFVT1KgX+/kfP37+jhXdvh9K/vkF5yA
         YO9pmhOw7FccILmOsw9Vq9eEd0CBqwqnEG9SOZ31hoe6deLgDMfvgtkbn9MzlmIL6CCG
         4/eWTPLrfI7RolkjRQcXVhz5lYKtNyUitc+hgKstFP7/VkwIKUSgvUXUiF/DO30u+79n
         Not7sPFGWJ22+GNnayGwZ+k3L0tUgFMqSbYG8dXv9aMj6jdY+p8J8galY5Sqed7E1ep4
         MqEA==
X-Forwarded-Encrypted: i=1; AJvYcCXr+ziuMvfBvuKA3zUKy4ItrD8LZqZdd4axSK27QXf9CP4Pm+qc17+ENkRlzTbl2yhxSkRSlxCnSg==@kvack.org
X-Gm-Message-State: AOJu0YyieKcbLUOgfDNMfixH0q6Z7A5CiC969HA15k08Rz9pjfNSB4Ou
	1ZPxIkB93d2lne20/H+DGUkL0r2qIYp86DEMX6BsJWewAzX4QPGDF/Th3yPmeGRlfxA=
X-Gm-Gg: ATEYQzyiJfE60T5GkQFLrffQJPvmDxOVD++x7Nyw/fXsXhCnUQq1uMF6z8UFfDHqyyV
	S6NfggTAvretpplReJdFu84eTSzrc5yREt70Xp5Zp44VG8le2gxfeKMb9F9oYpcc80DcQMvYrjs
	Emk7XGfl93lrVmQR7bxQhdUzN0wTW6WkH0Xlbn7MBDzSGTWGm/xejjkZQymtssSF3hx94CC7j+5
	yqyZec2Y4l4VzwAj07ptpG5ovOp7aC0v77vf2/FmdgPAtBmYthJ6SY/ZrtLk74kJqpm7Zor4Cer
	TKeWI239N3/fQAZm+slFcM3ekJGC/LHeyrv5zku19dCrPAcQTnDL/iIJABa/TvOe01RF7J1ffng
	StjU6aoOusYLcSh4FCheLA6RSLFuODwG9mBWBoa3cg5qrko2lryPfODMl3PO1C4lSP4w41aOE65
	yW1IsFI9pFAQk3dxWwk84oWpcScBQg/u5v
X-Received: by 2002:a05:620a:3707:b0:8b2:6606:edaf with SMTP id af79cd13be357-8cbc8f16224mr2082525085a.37.1772557151379;
        Tue, 03 Mar 2026 08:59:11 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf7161fcsm1414410985a.33.2026.03.03.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 08:59:10 -0800 (PST)
Date: Tue, 3 Mar 2026 11:59:07 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [RFC PATCH 1/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <aacTW_FEp6c1coDf@cmpxchg.org>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <20260303115358.1323188-2-matt@readmodwrite.com>
 <aabrv_xrsKPx9jZf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabrv_xrsKPx9jZf@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 74A6640008
X-Rspamd-Server: rspam08
X-Stat-Signature: 1ez7s54iskk3emu7oehag6z379aopzak
X-HE-Tag: 1772557152-361151
X-HE-Meta: U2FsdGVkX19rDJ0PjfEmdW4ueMC7pdUWAKdpSEn/6O7+iXc192PVWcbjzyVArQ+J0YnsjHs+QbLxE6ainHQx6MxwZViCdsKHUJLydhMhvbAPRZuF44HobSH3gLRbLmpIi7zsvAwnodirV5HkB7P0t47LLUgYeEyvrIVf31Jt1jeFdioh2eVLmb4TNvVggJeZkywklZNPKy/No9/a/h4RnYSvHdWapG+UEwrFpDIvU3JQNe45aQtIKtf+dBopser9e0LHeyWz608IFLlE6hAKkl26KFdcwVQSnCxE0ifwUzjdoxD7mcSBFdAtrULpL177dfhh2KsmoZOTARHsXzbEm0imP/nS5GMN1nxxm9BpCEW0gXVDHwzIH8i3tu+va1+DJWBs+bJVIdKTmNrDOFtgS6j5wv8UZgzQxpgHyeuJ2muQF3jI9NVraHkFBEklCSLHZTBASeafy0PSXlKykRj6695aUjgHun/GrfYCsvnC9KIFPFXXwmjgjtMiXfhS/lTGUSNdJgPDeoS3KrjRHQwjtxVTXrgbx1GkdLU2mBx22ENzgjIYSPwU1j0fzLlGy5zzqfXheVaaLCIoqsQWBqtorSdCcKN6MQUAhocoV7xbUS7r7IyYXT5IqOPWRnbSXATnTOThor+ATOtHqQXWkabVQ+4FG0XdfgL5hfzOPV/xkBwDy7NMO24BNUGTykmswqtRh1H5pCBeSRWmQyR7Ug7san3VPUreJH1NjhMqNu/5hvFK/XR3Z3gJg+lQS7Nuk63vTc5pYhatKwozoNez20289fG39D66R+D2asEzgN2cLGwGpfJHIiCzqZkMTHxk1rNhgvTFvq6+WbpLBmCIHybK6aEg39+hZiW8Dnz20lU276G/Xd33XBU5Ttnx8PT1sG1AfTaOFyVerIOtgUPqajj4JoLJFS7xGZ416QK6dZOXK7DTeWDqDqBpo2o4ak6+DH6bhPDs0/10QarvKL8uR9+
 v5wsKWr7
 9OjEEvfxIVnUe24dB3NkL4CDpDe6uHR7J+4AFjyTv3poN0OVvA6/9Bs42otVgGULT2fkRTKJJkcSf2vipr+xALR4m8wkzjJF+q7btTa567flJKZTkPt0KXgUbAno1EBlT6V5H6rA+mZRQ55Y/lhmKfneVppG72I09jmTmb/g8aPouKzOq9CORnwXWTab7raSuOoPZmdGezw1rQtODCKPycvkrs28pCQny3KNkGp+VLQOqujVgH7vfCFNFGCMcpsBVBs6NhSBK2b+Q5DuSbx89qQLFndIwGmIFUG75HWuUdPdrmd0IwuglbUmf26Q6r8RFIg0ZTqHz45gVvRulQ7+j8BQLsoBLHG7N3aVE1MNY9y6WDySRdPO0nM9jRMAhzWBx9BvO260XvH8+z+vINbw+Lq/n5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 06:10:07AM -0800, Christoph Hellwig wrote:
> No way.  Stop adding hacks to the block layer just because you're
> abusing a block driver for compressed swap.  Please everyone direct
> their enegery to pluggable zwap backends and backing store less zswap
> now instead of making the zram mess even worse.

+1

The virtual block device idea seems simple and attractive at first
because, hey it looks just like any other swap device, and the block
surface is so much smaller than the MM surface.

But compression is a *memory* consumer. A big one. And with swap it
sits in the reclaim path. So now you have to solve intricate MM
problems with the block layer in between.

The effectiveness of compression as a reclaim strategy is also highly
variable and dependent on page contents, so the static properties of
the block device abstraction are a poor fit for the problem space.

I'd propose the following:

What keeps users in the zram camp is disk-less setups.

What keeps users in the zswap camp is reclaim-writeback, cgroup
accounting & control, and the prospect of fully dynamic sizing.

There are ongoing efforts to solve zswap's disk requirement and with
it its dependency on static address spacing.

The gap on the zram side looks wider, and more awkward to solve given
the block layer intermediary. And it's already 2.6x the SLOC of zswap.

So I fully agree. We should try to make zswap the single compressed
swap implementation. It would simplify things dramatically for kernel
developers working on MM and the swap subsystem. It would make things
better for users too.

