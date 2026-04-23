Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEC3FDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDB46B008A; Thu, 23 Apr 2026 14:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E936B008C; Thu, 23 Apr 2026 14:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CEC6B0092; Thu, 23 Apr 2026 14:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 245136B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:32:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD0508B922
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:32:12 +0000 (UTC)
X-FDA: 84690665304.18.73AB9EC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2FA7A000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:32:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=icF+MhG+;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776969130; a=rsa-sha256;
	cv=none;
	b=1Qar4LZNQEosOlyU0tMlN52grhnePhWGOEfvlt9gjHny3Lo/nGw21/8Al2xn5OSFRJO+HR
	B5yZYuUYoH+tgaO+QhbxUuELLQ99tL2ej8eT6YaMeOQXwPDXcA4W09xitOLGtTy6Z/XglW
	ocbmUfemE/v3WbXWZVvqc+Xiw9DUm5Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=icF+MhG+;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776969130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQyoJY9m77UqoxHOl5sdrWkrMT6MQhIvt/fArh52SIc=;
	b=EymY20EGVuQzaS+3D0AswuCelMCwNMjd8kZulSI9AK59u1vFTsrYfVvTuC/8kH4N3lhJnS
	9tLEQybFoRu5RmKUHBE3GifKpWlCyFf0G8+YljbYvLbYDywGIO5eLYrVCPLFzz3xLAzr3x
	IsVFfA1aIe8hcwAKetuTw0Zea7RjIoo=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6715006f4f7so10627777a12.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776969129; x=1777573929; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TQyoJY9m77UqoxHOl5sdrWkrMT6MQhIvt/fArh52SIc=;
        b=icF+MhG+Z21YV2VNu52UYrtDNMqfH+U2BAGKnoXM1U8K4Tes2i+MHHWRaIw9z6JHnt
         /eFC8bl2ZoY8TvWFf67eA84sihcRx8DY0l8kiYaDrCWKEdmH8meJANtT8ymfBwAowLOG
         sXxmYKL2S3ce/bRByN9Y6WNvElTCbADQfoe1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776969129; x=1777573929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQyoJY9m77UqoxHOl5sdrWkrMT6MQhIvt/fArh52SIc=;
        b=UG3jv53ENVn6xi+76kWLkoYMHb1Tf+cyG1YAXZE9wj8hKt3gcSEOM43vZvHnTSGn6r
         7qBZux7IPwurroH3E6MeC9QX1Fw2v1BNEl0i30wMci6YOf2XFryNbQU8pS74yIX7rPsD
         pbaNTXiqq2QZqBD86NpEGqDm9l+JcGCJjErjCeIABQTqenJXx9tneHnqhNSNCE3vOVJ1
         dUGp5IpWErv+P2OB5/vLnFg0akCWAJpe/7eaT4vFnvAoHtqZry1a/E5D3qAPoql93Y7s
         AG+4Oxnkem/thniywbyJqWh8crK+neO1u2QhQ31x1LbVnYCgKzVm65Wut01r91kSaLT0
         Bz2A==
X-Forwarded-Encrypted: i=1; AFNElJ8quHe3MBHnDXn28s06BBPq+wlWsrvTiVhLBynpG6KqWnaUMyZFKgNZ15Q806hJ9JSP2GezZXKGhA==@kvack.org
X-Gm-Message-State: AOJu0Yy8U5oDG3B3fVPHm4MXsbLwWJO4d4vM5nQamiFeMVSMYOD7iG1G
	yLjBUbnkPMUkOFLMrp55DCGU8wAbiAp8USdVOjcGuWR/HhRy973tflbbYe13foJvr9zFGmZWsge
	uJQOAqjGDZQ==
X-Gm-Gg: AeBDiesUW1gCNsIrapA4WU/9/aBrWlScMHdkQ4VuAg9zUhv9e6kNMrgFQa07g/t53N+
	w/Ash3XhW2pG4XyQaK6KP6CwSeTI8ae+GvVKEMpaegh1xDlslJSRLPJMOSwnGT2x+YSqP9wLWJU
	Y/4rfPKHpoUnr/un69H0IYPyZWORgl+xfUCmad3loKeKZ8JgkdCeBjhUJCgPRHUWVJpkrJu3ppX
	shpG+aVUrvVkiQP2NMOeBMcPanTHwbQlDgfMNWTIezO3im+TnJuXp87D6/ZUjNql1lde2ocbPG+
	NE0BGvnRarKZw6ojxy3vuDx8u2HPs6opy6y2zWscCTXd0LEk6tfbIO2TWVOP/Kq7wNlKQUxr7BK
	YedkRlHT1hZ9U4Yk6uLR9iw1V5cQ8Df51ktvhUtddZn+zdUoiRzysmKAZMOLSiV1Ym1sN4kDTkN
	AgwH3vjak2630jB6Lkkt8OUWwD+9A6s8SIokTmftAywMd5rx5yTHDBOejRndtQF6tTz0kQL7Mnx
	sFVjkYE1Q==
X-Received: by 2002:a17:907:7b8b:b0:ba6:1412:933c with SMTP id a640c23a62f3a-ba614129552mr1300317466b.45.1776969128822;
        Thu, 23 Apr 2026 11:32:08 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba4512113a3sm706609666b.4.2026.04.23.11.32.06
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 11:32:06 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so9709305a12.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:32:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9BlxTZkrsPzRHSUX/ULOM0ph1mG5amjXRRlV5zdtwjD8Don08xqliZAWPH1L1vQ5Nm4BJ88asGvw==@kvack.org
X-Received: by 2002:a05:6402:21c3:b0:672:c22a:289a with SMTP id
 4fb4d7f45d1cf-672c22a29f2mr9588371a12.9.1776969125828; Thu, 23 Apr 2026
 11:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
 <aepj9_v_1dYJ_tRu@casper.infradead.org>
In-Reply-To: <aepj9_v_1dYJ_tRu@casper.infradead.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 23 Apr 2026 11:31:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZzvMSSJYwfbpfSGcf6=e-2VGjtumeanUw4XN_cfYg8Q@mail.gmail.com>
X-Gm-Features: AQROBzBi6dEpoqGVLz_-HuNlg4rrZycrP2qGFql3p6QGPmWrMrM-1T-R_qlGgJI
Message-ID: <CAHk-=whZzvMSSJYwfbpfSGcf6=e-2VGjtumeanUw4XN_cfYg8Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: implement page refcount locking via dedicated bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Gorbunov Ivan <gorbunov.ivan@h-partners.com>, david@kernel.org, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com, kirill@shutemov.name, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, 
	vbabka@suse.cz, yuzhao@google.com, ziy@nvidia.com, artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A2FA7A000C
X-Stat-Signature: 8x8fkauunry8fjx6nef9mokxpsbajxap
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776969130-158254
X-HE-Meta: U2FsdGVkX1/xz/sdv30I6itSrMw3El16vQ34m72XWwz/XIOOBBcB3qgCfgAbK3PQdfscEvfB66uldvuzN9oN5u1QA/ziokFepE4ofpy5nrnqaH8swLrKH/qXb8/Es73DA4l7oY2TvT8qqe/c9npqwtrvivYI+gPcEvKewgyvzOnTppV0LcH4xPBil+jn7EohImytHJFjYgq6k3mxWgBMJ+R4oCRIMzrARJS7Gt+OFwC9UXB81xVNVagUjv3kW6NSA9h0vR1Ah/1Xskmmnt2Bw2ewR7DFTERht9gZTRaJ9X72m5nbsNeq52IO2I9Mj9m6gPGmy7/5BVqgi0jEQYywenowes6Y6dlmm0ZJIZD0HU1z6T8+IlBLyTuNQCeFQLcSYbFI0CONfF0I29A/cP0HK3gFuy9txE7eb+wWOEw/fFnBbRjR1yQutXQL+TK+G307gaBBlBYwKmUqQBCdTymQj4HeqkYUGgLpoxMGFT4BRzkEaWPVJBg5FOLlg0tZb8rOg/idz5yYBqdmuj+7abrdvF2iocEvxWQYydiSm7gBKnohvwZZnVyP93y6o/qLpvgTGFX5PvQAm/2kQ+Q5t6qfv0fafROkbKrklkGzQSa6md8LNBBE67RIXHPqxKK7A6zimWlxD4LVn1Xyy1gIePJaCakD0oabHCxvBnlPaPVO8hiePzfqd/KXkVEj9CdyEKT9EqDSj9juweZMT6c/A3NnP2LUFeuhMFd9m5nZ9U1qrGidJcpauaqkfmGRE1ELRianeZkV1GdjeBz4aUpjsuRl5p1C5MZ3jg0MeurkCYeCpka+VhDz+LlsMQZzRlE2ZplIxBCyMlswanikhL+ORx9FWU1GImwYrBdTAagaoc015V2GUg2o0EkkR+y5BqJfOEBl7AFyTmPpV5iLi3w+FaI9ODStULr7w+yq8G2hQwalJFkpGLmEplBXTtQB29sg4ecplVlLSh9TOuIurtPs2pl
 FID2hcWa
 wMc1ZciHLxxGCihodfpZo82zG9WnPD5moKkqJ4gCP/EWrnk+ktckl2mVVEApysEAHo9EDnWXiHYAzdnus7EwMv5+KIJ+6P09cDvOKC9ofybOpzhSyAu+MaOLi0N4EcDzsB495RaAgZs/O9IelUAXapKTrPJrnRZnb6ULPzZ0//n0LGxactAnvPLdwfvdWzPJDASp+K0v5pcuOPXDF47nI1SIxVd6B5L713yntWSPryw+/CoAsfV/HbVhMChowRIW5RWJwjs0tOnSqiHQhrayhn18pG9ewvkA4sWqu2mofxS4mMPa0tNT+wfKsB8DAKLJYeVhVQOWyiTazAUV0Vqw1eEVF1Fe7uQQOTQod7nlBRpa8BdVzT79ZdDAyxZuQurYEMkW6gZaSrILFaIe4MfEnUViwAIIN3QSPlVu3NceMKIvtGrE+/XEtqrxPKTABsSt4Ov16As+1MWX+pA9sQ88TLdp8B/SWOvm98XmJunGOzSFc3L0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 at 11:25, Matthew Wilcox <willy@infradead.org> wrote:
>
> If the file read is high-frequency, then for the page refcount to be
> the bottleneck, they must be small reads?  Have you looked at this
> patch?
>
> https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/

I htink the impetus for this was partly that, see the original cover letter at

    https://lore.kernel.org/all/cover.1766145604.git.gladyshev.ilya1@h-partners.com/

quoting:

>> This patch optimizes small file read performance and overall folio refcount
>> scalability by refactoring page_ref_add_unless [core of folio_try_get].
>> This is alternative approach to previous attempts to fix small read
>> performance by avoiding refcount bumps [1][2].

where that [2] is that link to Kirill's patch.

             Linus

