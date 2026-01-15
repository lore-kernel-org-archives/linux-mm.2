Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F165D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A096B00BF; Thu, 15 Jan 2026 17:04:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE5D6B00C0; Thu, 15 Jan 2026 17:04:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0856B00C2; Thu, 15 Jan 2026 17:04:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9E356B00BF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:04:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E2621A0376
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:04:21 +0000 (UTC)
X-FDA: 84335577522.17.E70CE03
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9AF9A80005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:04:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RGMXfRz+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768514659; a=rsa-sha256;
	cv=none;
	b=PRXZfbaMKXa9CQ8Vmt4Eh9zDd9MI62oq1Q659tLGQRLPpMnEOKjOFdqx13UxAjj9eO3LzS
	E3e8KxYoqUZA1ZblnGlhQ1t/L7MhUb0/pH+6JIWKeNDZp9JyNXoY3yTGsI0Bgj2pUpp4/9
	RnvefDgsO3E7FgNtC/NKl6RHSo6PZdQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RGMXfRz+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768514659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+9teuZrdc+h3p8sfeWroQ6OaORAFW0bgvjwel3oUcI=;
	b=YNG90YXaD5ZalDGY5ILGx55Z+7An3HR7A6VrIJn2UUsHduzB9ApDCM8uPIezLPbUxRr+n5
	3VWKp9hgoEEm5wJYJGGto1WorDVis2PUrSK4KElgxC+fbznSL5K2pLdEjhZmi5UEmENKni
	cCmk9x33bCL3vOQCGE1EGl2+E5Q++Ds=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-790ac42fd00so13599917b3.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768514658; x=1769119458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+9teuZrdc+h3p8sfeWroQ6OaORAFW0bgvjwel3oUcI=;
        b=RGMXfRz+hqV37DDB38x+BK12lOijnuTIufG5l5a5RNmnsvRVOy0HQPVRvdcubJ5jPf
         LCXyLopvjZBBLiOWYBWrR+2lvLaQJtaOerETLr61e52SfsFMKirIYLuUPKR2tmRIq8iQ
         4YzmtTb6eMrgJlmJyyD2Tf0+jAfB116l/BiAMGpkDfNbaXSN5JHow8hZYUYz/4YSKWJS
         Ckp+IMsib+ePYMRJ5+QN2AyPOiso3kDTQ22IPoxf8sQYbt8ByFANX3XgQm5z9A2WEgsr
         H9/iWHjAaSQS1YHNqhxW5O3gqJeKjfbwPtK8hZn5SJiJXMxeRvB2SwQ1tDPXrPm2M0ta
         tsrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768514658; x=1769119458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t+9teuZrdc+h3p8sfeWroQ6OaORAFW0bgvjwel3oUcI=;
        b=H/6gKjDlAD/TMWzJNXIDjmDeR3PJOQghcCsqGrY44eZhoEvG7y37c7/RYurj/Sj7j+
         WrsML8ch8gISBtEn+vaJwTuPtTWOX0IIEm/NtgvXtHRuuFmzK0kmmLdximIirbFUxuew
         qe8DIu6yRcYNAb27ORJGGzJR8Q1RDaBalHQtVpixoRO93+S0OTo/VVFA1HvsJT2vvwOO
         P+bUZoek0074CEKx4utA3aZhMMqLLrAei3B+VIBa/n8YnSjpJEcXx6bF3pi6MRa5watH
         oPn3lzYdKpQ5K47IRRh8Y1pOxyHpF6+Rqsx6LV/IsoJYAFoHoR9wqzTGKsCAfpXkgnQx
         EmuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWG+LXrUyT0acL/zn77ye7BCtIbgwP/r2JYjznGTQPAoTP2iKqxNfC3WdLGNIzfEkbHiHue8QteaA==@kvack.org
X-Gm-Message-State: AOJu0YyIMQLEcTbjX0Xp4vw2j8WvPq/n0ZVr36pSZTGvPE5fKJD2Udjk
	CWu59jTFb2esblPMMv/xO0crZlhdfpy0v3d6GUDVu8X1gsVUleiRuavv
X-Gm-Gg: AY/fxX7NoITvjNRne2bVBRbPcOkg5KQuYHg7Qm9dpjSbU9YWuKoOIeQO3W4g+68fQA+
	qgT0hjaGf9G4hAbptyNe4yyz2OuQ4S28YOwstqGSz4AAUCUW1mNGJ+3UJVRrPtO6CJHtG8wWE68
	Rn1BlCGK6tyKQeErApwWhU9KHTzn88vLHU0ML4/faXAAokHm0DP1ls2P0HhWzwnR9ZaHM23LHiA
	uCEH/I5Aja0E25vnlHZkc3CRSZRKWkNrZ4RPfAuBMnIgeCGDOA19nvI9mwMTsrl5jKrWipTlQpJ
	nz3yW4x+xKxK6XnkNpEO2E4xp+rYl/hihtK3wDfJr+fOywKWH6uaRRZeXu3SdxgK16Ve+g1kK9P
	HEyJ9DtLJUGGvhXg7yPw3j8Q5Ued8GoKnBFmYvFgyoHdITHzhsxPkqOAJQvMzCNz0UIx89IRzqo
	PjODySLQ==
X-Received: by 2002:a05:690c:13:b0:786:7a54:4624 with SMTP id 00721157ae682-793c523d4eamr22873687b3.7.1768514658560;
        Thu, 15 Jan 2026 14:04:18 -0800 (PST)
Received: from localhost ([2a03:2880:25ff::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68312adsm2198147b3.33.2026.01.15.14.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 14:04:18 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Date: Thu, 15 Jan 2026 17:04:16 -0500
Message-ID: <20260115220416.1749150-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115135942.843342c483b44232b599a61f@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: okuawjdkde3dfhawrsaiashyn9frecxs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9AF9A80005
X-HE-Tag: 1768514659-170260
X-HE-Meta: U2FsdGVkX1/2WaA6O7jbP3PqbXhw/eYvXNblH82spJB0weqCtQy6ENDTldCn3w+s3lm340bxzrsAVJT0bgytthZRTtkW/Pl0/8NeePJ0ZAlbYA83vBHk6eX5hlrD3UBBpunIfgi8gdHFaJueaY/r19cCjyOvjuT/9tThS2/9iNZvZrSl/DaUYubMaIcf9dACUUmyrVgxc0eWvyD0+NbbAQQT4gyvNp3jU0wa0iD0/9EVo/I3ZtIfUTWNaeDe6FaEq7i321a1ogmG5ZgnXzUdc9dNSZmjV7pgebrd7A2L3/ORASDpCJ+wMW4mOyIyndY1fSUWe92C3MSah4A7x27UrIOW7YqxQL61IHnKAawsXPNupxlOku6viBCrxP0XNx42uS+u9alu2zVK2AgWa65u3Ilfurz60eWLmVgfUQm2UGfsaVHrCrGRpEl6bekOXl87YmNCXiLKqjTEldNn44Lb47FtFJERWqrAfQw7XqTKohp1okwU/+jUN+Ezq+yVKLlcR08aCW8JIz10/K7pKOqV4n9sGl3n0lqat0GKeQm4C6zK5TGb8aouW14he6Pb7DmRA8wuC0ZN15IVYAeK3XfMdk1osWqyErzPCQTxFqiaIWGcwM28a9X8VM0uFUy2vH5efPcWWeUnSp1IPet3VyHITujCTCiXL70gyYiLqeTZVPwvRjA26b5V1y9In6zRB7H/wrOQ1Tje7+uVSFirZr3U7ZVGr0FbePq/JBdX4lP/exoDzf2rn9K3CBgGxi0OCq4Z0QQLikKVAM4XmafdefsrrcUHkbd1r3pJGDxrJR4HYY9dz4BFDQKqf6hmOTriyhbFF0sKeN0c0+nb2TOqNHNN+tdpN3Iz28DZ81BKfg+h43xRwhs5rq7omF0mzUcPrUv9aYh+6GAL7vcOlxTC4XqwTtR0aJhfNKAi3wZ0cq8wrfrHNMkcfx1CZxcpEF2VIEYvDDsOeYjHFUkdOzmrCNw
 UfWEmwcE
 Y/T/Pm+G3Md9QD8+tmAHZqTIAv5MkPSaPj8ZaGGt3DrD4WroIqYABSyNunHK6MFF58/uaxBb9biPbwspTBRUZ1Mmu5kbNz61ye6xxV3Ti/h0F7R8dxLJT4TkA8Ll1nCOkV+vY0rHmYyYSxVpFzHC28/v0thIQ1FiP1GeOF4iv8zhaArG8qt6xZvk7yVAF1xufoTbDtB+KaEl0NZjH+WIcpq8fYFjFpACJ3PGBd3sZjkGHyQXMaChRlc0+qlbMV4gTHnI0o6cw0zJrgCUsXlJ+7nTQhcOn45D8rYdMuauUmnnxvQFeiq6p7azC46b1Ue3ZKSVwsKxwBrkPqvnbf8wmZY+I5Udxu84dqIe17ORAwYMco041ru6tVAffyiD7ol1Fdsqs51r1v7kPuG446OrMdwg7512lG2DNaAfF1k5Y1DV0xgAR7IIO7NVlVc6nqNp7t2Kim7xULS4wABPGyc67x+hWqM6rLPK7uIh16ajKbC076i942R90RmQRd9aOsYOX4BhzLMhlv1QwNXyyTTVV9KE8l2EpPPyqfFgZzg7D3FYeFT3u0+2YFfcusQZw8dd3dvaq6m/2uefHj6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 13:59:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Jan 2026 16:10:51 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > > > -				spin_unlock_irq(&hugetlb_lock);
> > > > -			}
> > > > +			spin_lock_irq(&hugetlb_lock);
> > > > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > > > +			    hstate_index(h), pages_per_huge_page(h),
> > > > +			    folio);
> > > > +			spin_unlock_irq(&hugetlb_lock);
> > > >   		}
> > > >   	}
> > > >   
> > > 
> > > MAP_CHG_NEEDED = 1
> > > 
> > > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > 
> > Thank you David, I agree it's helpful to include MAP_CHG_NEEDED != 0.
> 
> Oh.
> 
> > Will add in the v2! Have a great day : -)
> 
> While in there, this:
> 
> > > > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > > > +			    hstate_index(h), pages_per_huge_page(h),
> > > > +			    folio);
> 
> contains now-less-needed 80-column party tricks.

Ah, that's a nice catch as well. I'll be sure to include it as well!

My bigger motivation for sending a v2 was mostly to separate out the
fix from the cleanup patches. Since they are separate now, I'll send out a
v2 for 2/3 and 3/3, while I wait for reviews for 1/3 and send out a v2 for
that one at a later point. For what it's worth, I don't think the fix is
super urgent : -)

Thanks again, Andrew!
Joshua

