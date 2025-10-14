Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B33CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A5D8E00C5; Tue, 14 Oct 2025 03:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8040B8E0005; Tue, 14 Oct 2025 03:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A43D8E00C5; Tue, 14 Oct 2025 03:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55BE28E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:26:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3D6D11AC16
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:26:53 +0000 (UTC)
X-FDA: 83995887906.10.D30FCE9
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01BD41C0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:26:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkTeIHm7;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760426812; a=rsa-sha256;
	cv=none;
	b=5r0c+02cq/cAwC00xmNdYx/OFGdG7ub27hbTetRulSKN0FUB2Jf0dndZbFBng2EszkXucS
	64ylmxDie+e6aRu5rk6hKpAcQrmD6U16KSaLq1p2i8Ipv3/aZAPBhJwrQ4Mos2FMhKMCTA
	PTCGAspX8YpZtwAjR4De4Sqzm0wv8fg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkTeIHm7;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760426812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1p4OZlxOY+NxPP/FLfk1SUzbR8cdY55J35+/tdhphko=;
	b=lVMAim0CkP8qgUev5kJkkuZ063A/h5EZgFX6GPmSbNggwuCAi22CHkwhRDTaIQpDiaMSo8
	q90yOOr1b4cfEyCFa7ln1bEw6+hF0rcdQ98Qy7Y7zIUItq/TVcIOEyiWtBFDymoZiTmlgu
	5Y7jxzSqoTxvJeftL3JKU8rddbVkNhY=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-426edfffc66so353368f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760426810; x=1761031610; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1p4OZlxOY+NxPP/FLfk1SUzbR8cdY55J35+/tdhphko=;
        b=WkTeIHm7OB/9mWfjrnH8A5P2BOJE5d9Es81KptSEMcTi+nzTwJGz6QwGokcBG382IB
         /caLNWqLiS80uIxG7LeE5bA1zLHf8bN6QrKNRsdqEr4wSmxZNHzhfZHTnwzCdAg5DLOD
         uNknrezdHtNcCL0UptL1t1vXRUkgImgZWLodgTl32G5/3vRlbBgBGYdqEZ6ZRzTcktzD
         Go5prSWfqTYPg0r7DagpOVexOJKPQg3zRMzWwaf6ZpOZ3dx2gjEi9WHvPzekGIN+80yz
         YEEQeoYzGI3cJ3Hd8Nwef232ZzSmb4Dpi1ZDhaYgFxcAFJJemCz4wnQT0Bp7BOIpcfRX
         pQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760426810; x=1761031610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p4OZlxOY+NxPP/FLfk1SUzbR8cdY55J35+/tdhphko=;
        b=dTywtkG1gTn/1uAA+1PGD/Von94hfV6kA59IxrwPBz7Rw0fsNo7VzqAg/erQ5KI/nf
         5sFMTUsoejAmJ/65xgfEkHI6llkQo2vX0cTMm5Zdg4JGoQiyHUmil3pIZaCeK0CpVQvV
         2DE01eSpN50ji9MBLjHxrjaCQswHFkNUIUI6j37UIdICr2ACcgUtncqxKu0DZgsMqsYQ
         YTssVAI7z+ia3qDs7r+bWJN/JjqfvulXeNlf6IHEHImGJc7rrxLmGM1/4u3wuzQft/+l
         ViJO9+R1ivMYqb9o1e3XIYVY+n6eaKyITJq/6nU1m2PAKlJaMa//ixeadWkKPvpjrEDW
         iQKg==
X-Forwarded-Encrypted: i=1; AJvYcCXu5iZyu03odqzSbDeH4Jz+RkgUjInFsh4G1yNeKFa6BVRe4pQHnRXiklyt82Z3zo5hl2dKhW+geQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4zgyEF5+R4t44fcd9ixLxPdNG+1xxJ/F9ANQL0ndTrrOjCeKr
	EuwUB2t8BFAjxGi3bDmzkhg/0AMedNESZmUPvHVmpQN6O6qqnRtAuX8ph7cfqiORx8Q=
X-Gm-Gg: ASbGnctqqaU/EU2chI1UuZALICN9wguYBiNDyzUkqkA43pxekqpgxTB1DnenOzLg6WT
	z6Xdjw1IjGTo5SuBL3sIbLikGyzB1mZFrfogbncCsT4twirN7R/bryNvdQ+YveCO4rETF4Gyp+Q
	q07+AEEbQNHdO3tJnwCkibos1D0Ro9V0n/H0lI/3kDiXUdWltDgha8xxfJ5Leda1ERpD7svWCJT
	0EU39sFAR22qYNgztQHRk8Bs0ordJUQ7WnMpoJZm2U7K63Ec0HSO4A2B9U+SaJfeegQ76dHdqB8
	rwUdR81sMZYoVEjreNadzFO58MaoJnKupHLQxZWc+0MsqJcGpEn+oBKVd8tW4J+wyYCiZvQ8A0u
	uJ9o1yMi7K6uc1nZYGprzUd3YVICP7RFVwD5WfG9Mx+G3mraTiq8XeaprRbupqcg5f25P+yC+Ww
	==
X-Google-Smtp-Source: AGHT+IG56u1B06cKrDgh7gziHnjqzu34szt4cpp5w6eBKrKwAL5+ACYASwYe1mymtdVAayUoB54vVg==
X-Received: by 2002:a05:6000:288f:b0:425:58d0:483a with SMTP id ffacd0b85a97d-425829a5a12mr19773929f8f.3.1760426810474;
        Tue, 14 Oct 2025 00:26:50 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fb55ac08dsm217399135e9.13.2025.10.14.00.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 00:26:50 -0700 (PDT)
Date: Tue, 14 Oct 2025 09:26:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Barry Song <21cnbao@gmail.com>, netdev@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <aO37Od0VxOGmWCjm@tiehlicka>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
X-Rspam-User: 
X-Stat-Signature: pcrje38yib6hmkt3bbs3hgxg975bcyo1
X-Rspamd-Queue-Id: 01BD41C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760426811-210754
X-HE-Meta: U2FsdGVkX1/0T2CRXXyG+MCOHmywHl/H5HHBee4erCbBV/WT2Fg2qXNShrSFTxt4JEBVYxMeoQGvaI87ob6gowswHB6QzqOlBVusQAlPYNKQRCUvYfR1+almdY+cLGp5NB1E8EdY8K0wXfwM/SeUYzQOdrWXXI32fLfJofbM3V67YKYbEj3fNQXuGGEcZOtPVTuevweWpFLyactvCfcSwETJc6rKuIQ8+eSTjCI+JmTyjlaPI0PfZRc2Lc1dMYXbZKWN91NzRufzogeNse0TzJFCvyZy94wzF9R0eAYjvq5EsexDM2fRF9eRTz0wFda/dT0/50lL3u5OLimm2MxLBAiuOIWBBeyVL2zxLeNPkWLWH6NlgEc4WE3/rzB/ZaNn3w0w76seySKBzZ1SpXkdAQJt/8LsqRKLWe10LCY9GXw39lFkacYHP+YGFvzE0ZxTRBkJ34ajAoC8OVBE1Cy+j02Zy0206US1ljx4jJmtsLNbhwagov28B5S4Ko6ww9m4UL0QLEMb8r5+kCZOcZvDGRWM6GxtTUpn+woFtAbqkgqKtxsvvTbsM6WwYZ9gl4quASFjeUDVoHJWvU5IuGJFAjBsmsEbMSiJ6YJYQmgGPGMO3v+B5zp+GgrMuyxeO48kNpbnrQX6SxQf1NENz3Tb5qZ9ZtR8hEXgsIBM7Yvk5m0ErYHkATAI9Qpaire0ufsEJahLKBJwEbyvvPfHRgPII3qOgT2rzqIkkSYqSdkB8/3UgUjAOMuvEQwbFGa6QsPUpk4hbSIEZK2ikzc3oVsi0xVhHoD4036oCMgFOwWJPyp3F9uR63OEDTeXZbf3bVh354gcW9RVU/VcSZzyXZnhc0ne9YSb1Fs1lFqX3EaKuCkhIEYwtRPu2Oj8tRb/V02dq45Gkkgg/cWKLFaY3QBc7oaQjGr4YuEvis5iIRCrOGO1/7LL18xj+uOjo0oajLaA5OWjM2nqSDNiunsUXGS
 3adyNCr8
 Zs1va9OQW84yivE6OUusGXzhZTtECAvDPtTnj42ZMc+EwRCBgsUmgi4hjaWGtGU+5ITzwFEFzoo9e2ARAltDOmLqxH+mbCdURepeIIWm7LzeGrpbm3mkWl5KSHCvg7bhFNPxzO1r8ksvTzNkKJM5IKqvSIsh7oZa4c5VE4ESVZ47sVwa7RFCVPlDo1MXifvePFXFo1cW/xhtksp9UqNkjDqsS+2HKx39Nqg93z2AzqkA85sCQtyrxUOT2S0adcWNh4XrpDEcJCaExRhUFWIq8DxsWqvPFFRJ9sh94acvzKUPJ1WJgRa4YessD5yv8EE53S6H22V7ZKMR5JmyCdXK6xsawbYP8pBb+7eV41KhJWGeTUypLJwLXHhvIwCwafzojGboz+9ZeyJMdr4wOeoCQvdl6qZO4sDNJEOFu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> On 10/13/25 12:16, Barry Song wrote:
> > From: Barry Song <v-songbaohua@oppo.com>
[...]
> I wonder if we should either:
> 
> 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> determine it precisely.

As said in other reply I do not think this is a good fit for this
specific case as it is all or nothing approach. Soon enough we discover
that "no effort to reclaim/compact" hurts other usecases. So I do not
think we need a dedicated flag for this specific case. We need a way to
tell kswapd/kcompactd how much to try instead.
-- 
Michal Hocko
SUSE Labs

