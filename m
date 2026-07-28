Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4EEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 11:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3CC6B007B; Tue, 28 Jul 2026 07:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274706B0088; Tue, 28 Jul 2026 07:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D116B008A; Tue, 28 Jul 2026 07:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D90806B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:53:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DEDBA1419
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:53:47 +0000 (UTC)
X-FDA: 85038026094.30.D247523
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5376B1C000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:53:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DHaYCz3x;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785239625;
	b=tVYiQg9fLz4IAKG07T5oLbsec5FgdZYvRvX47/bqxcPDXObcfIx9FjZpPZGb3V+khpaCZU
	fMlRfmL7V9MuLbh7pfTtXrysCFlrISTnQnCWrxK080G4wO87OCJ3M8SCempWNRIoWGX0J+
	xIQsgipkQWOU/BheVZwMQuILFljc7oQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DHaYCz3x;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785239625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFp6N2zfH60/bgfMWrmPhFkOYqdLpff1TB0x3io2THk=;
	b=3eHX5FcZtYZ4saVdAX3Pgc4EnKdthQhcybMVdR0AaSApNungvMFQTR3KGjdjeVrjGAiXat
	EkoXVgxnLX9KAnIWXjiWex3vU9UJD6OuoJbCNDZVy33hVqDFvyetfWcH/jKGFFmVrl1gNz
	0LyYECZ8H8m2m6IEy8sAUwAO0fnQVvY=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954d29264cso18868405e9.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785239624; x=1785844424; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZFp6N2zfH60/bgfMWrmPhFkOYqdLpff1TB0x3io2THk=;
        b=DHaYCz3xLyRKgBwYmLwSyiiJZbPfTdsXxL88NRJsyMhpGtFcKWsvkT5rLFhnJAx7Yg
         R3mrDJJF6kt5imUfDV8ns6EDwCvllRdVpqg4frXB26rRzrn4bmJso6y0m9Lh2BaOyL/9
         lnEwQfaGg+grPaNNJq4h0w4oNxtcd0s9eROvkgHbpdaz/avh+vmygZQ3CbVjZtQG+Jlg
         3JY53mMstjVZK9I+Lx1PiY8Lrjaa6aATpOiAMUtE2pkeu2GoaOySZTcP0skBB6w7lZ/x
         qlk7eeh85A21WPX5mjizqByV95XOgJFN6uVoZ7ulZQA6BWRqLRbBSBUIg9Z7un71mmy/
         4/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785239624; x=1785844424;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFp6N2zfH60/bgfMWrmPhFkOYqdLpff1TB0x3io2THk=;
        b=CUemVTcgXJe5p8Jw7DQ04TTCGyyfDXFlIc/OC9VS7ZFsIc6F73aqs9xaAyGPP4reJb
         MQ3YOWRjmU+Iy9CzPGwyioknKLEt2sUORcXQmHr+O43B9LCr3sC2LT+8CpJmcttSbYDI
         QlVPB4av9gpoAJxW8YjJ2q3dnRefywLc/xLNr6wUVLdtv+mQbipWCXJPOVeqbXlAW8Od
         EXHkJ35E03bDITSDrlWBwmuF3pAoBQOcJVcOhR/Ly+CiB82tpKUebdQAjAolKURrS6he
         n/9rT601oIktw/avCUYq9PELzfIuKdEyZgDLoMigNIyBUr/JNy42Z0bDN6C+MBA7e4TP
         /hpg==
X-Forwarded-Encrypted: i=1; AHgh+RoThvKSVXKRRv+LDGmhPkUv0p0VeKqdmGVo7F6vYADnJou6UHP9pFDHUk5AN3qH1QrT6xLoL1IyFA==@kvack.org
X-Gm-Message-State: AOJu0YyoPlRM6yejZc22g0g9M0lV/c+/HIIBsdKPVjTECG3loTihJ2WO
	QmdOQoVfwGesVsaMcMifS++03fKHAGMeOX9Nw3YHjRxJyLBke+ifz4QizZRd28ZX83c=
X-Gm-Gg: AR+sD12pLw4KcozJIT8HePoDhG1/3EUL+/STJ284uLtDj7lMxyVCcN1Df4WbCKz+tSn
	BD92dECxRP8MYR0BrqRiW66OgUkMdsKN0ZIiUqRALTG5ikejDkrZ+bZiYglW4uzrmD3u6JOKcQH
	q6Kq71fLAbT8rQI03Nj3RNPnCGpsugQIKsQY/XdWPpFPDslmGWY5ddA/TlIYZPEcENcloGqqaQI
	IWnjLH4sAqqCV5rbKrSgJbCQog/P64fQ1oWE8W3vJ/oE5dVl9tYxi3NZ9gkEnarGG/I10Br2bDj
	f+ElszqYMFpe691Sck2hh9LLyMBtTdytsvUiWf6PBG+mrDu1QJSRUu02PyJpDEmIXnKPH62Q/s4
	5c9lTil9gZQsds1im+0kyLbtlHKVuOifvSC5XnQ/Fnzttnb7RchSeKecrIpfKFb7PYQ4YzorO5e
	YKhrlhDTzQJ4jQGHQV1UcS
X-Received: by 2002:a05:600c:6304:b0:493:cfe8:5b36 with SMTP id 5b1f17b1804b1-496c641069fmr26877345e9.8.1785239623866;
        Tue, 28 Jul 2026 04:53:43 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44a873csm76207195e9.2.2026.07.28.04.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 04:53:42 -0700 (PDT)
Date: Tue, 28 Jul 2026 13:53:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Barry Song <baohua@kernel.org>
Cc: Ridong <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
Message-ID: <amiYRZLAMwMjb0fy@tiehlicka>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev>
 <amdC_-OvG1ZUjmot@tiehlicka>
 <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
 <amhXvAdmDxX71uxd@tiehlicka>
 <CAGsJ_4xLPpf82CoS=ZNNP6nZoU+k=69oJFL3-YT9zibop78TnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xLPpf82CoS=ZNNP6nZoU+k=69oJFL3-YT9zibop78TnA@mail.gmail.com>
X-Stat-Signature: g4x8ho8iafm96e6a98ms1afki36ib6xa
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5376B1C000C
X-Rspam-User: 
X-HE-Tag: 1785239625-688440
X-HE-Meta: U2FsdGVkX1828ordE3R/pTpHhTuIYOF9FjEMvR0pDcTSw/3DQXkiyGsmNXJLwz8uSQ1QGG4MvX6rF3JLJtNTb1/XDHqGvYeAp/4XC6nscOi9JfGmQay3CWGDVeJOMOiNHBCxOKWNRF/5SYKh5TbtwrWygqQsgrSjz4k2mxqC8+34KD2tPS8b2s57H/OWbcjIk1qiHfjWt2aJdjXyx+vtwBn1nmHNYYd3glUp5Gd+7y/ZSRG1GoTZnofSacdu+NaBGagRvuma+Q9ZTJkSm2llq120Be3y3Fj3PCUM1YVqEqCypzLE1QnZa6gA+PSrIw8MMJHHIKfX7HiccJIXY51/ryhbYjfm4R8FbjXWojTVThyWWFO54/zcguVXMVxL7QJJBaPOXyK2zxIhKgyt87v+ImgJdlQCIt95THBiSdPFJ9R7vGhxGvsslYL9SjNlu2BIBbLdoZrezKh4k3VlT9X+S3nkOsuOgONnuKFqVkO3C0bE5MOhh8uJkijzAqwwHqGnSJrS7NBD4ceDlrbn/V5fB61aDwRR+kgZKLSB057AS7xmYLWgoH06Od9/YfODnzuNu/UGJ+qdEssM4Bqa0313KeEJDzA/UevEFIDyNf7AgJYZoKkoVNXWhiREZiYCN1R0ItraWqUTNL2+8hw5L4ySa74P1I1RFElecBTILOtL3BJgD+/IkABRzMQWMC/CwfMUQfmQG5n1YK8C9apjNc5eaJxE0RfOnEu2cjCPMcDdFxctTHBQF/QB/3E36tmY3mBLQvfsNkjITBIPhzV3oeNX/qM2WTgCNKA0w+QbFXi+poZnanlM20eIy33feA91JwVKmnktRQi3WW5jcgUTuS3M+cbSHD5TKX5gKRi0+bu7VIAjQix0VrfN0ZgeFr+xTyKME5zYOw+Lq8emyQKRwjyf42aJttU5p0rrTvdYi68fsDGJSosOXKsrvMx/XaP/eQY0EQJZu3U7I4BhwbljnfK
 PAXnVVID
 gsmk1eJ9DrvkxiPbFUrXx+6+qpOfopuhdyBoZiNflX6vd/+0yDK60NxUFpmmK2aF6/2che/YqyrTIH14DXYrA7Fe+LAYh4m00LbBZkptgvBWBcpSFyIfRSqb4G5yTlCyxg1SR4oDlGWvCB/3f85MK81Ve/zmZVHMKiKM/qzkNgufQZXPnd6mQJLQd2XpA5DulxwnQCKJc9DmV9s/PyHkXk8dV2R6AsmqqyZkGcLxawAm1Ayky1LozSo7/vvVSscAnf7LIukRbm+7wPH3BtPuXMrg+qQHzz+BLhpcLRR9cSZYmJy7eexBRRoPtBglfrpdqTlJ/OAkCxa9OhIeKLulcXqJJOxFuHXXm8wsSxRikuea4pxzm/l0Hn65/VJjmlxTRXzlp+FTOUWP6RYp36jSDc7Iyj6exluWbbF+uEM4ZNVbpQbI88BdHvJ35VDXTvIxRdNGj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-07-26 18:03:24, Barry Song wrote:
[...]
> I understand your point. I just find
> 
>     if (swappiness == SWAPPINESS_ANON_ONLY && sc->proactive)
> 
> a bit odd, since `swappiness == SWAPPINESS_ANON_ONLY`
> already implies `sc->proactive`.

It does so very implicitely and you need to look around to learn about
that. That is my biggest concen here. WARN on is just a very poor
annotation to remind us about that assumption.

I would much rather have get_scan_count more self explanatory as it is
quite heavy already.

-- 
Michal Hocko
SUSE Labs

