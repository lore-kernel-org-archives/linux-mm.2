Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF3EC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F446B0092; Wed, 19 Aug 2026 04:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07686B0093; Wed, 19 Aug 2026 04:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C836B0095; Wed, 19 Aug 2026 04:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B18C96B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:50:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05AE340310
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:50:18 +0000 (UTC)
X-FDA: 85117397316.13.2DB4557
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E16340008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:50:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D73WKXa6;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787129416;
	b=otDzIxT/Qlhfocs9TkC/KDokTTxw9HRAf93ydQxeh9hBtUm8L+QL5hd+YvTcYapSj/dK+/
	PnpSiVhx7tFjV5/53z2WrC2jiLpS0Nm3EGt4shG7tea+n1sG0v5D/I5J8KiasHqJSSfdMc
	vmTbc21Yiz5R0eSCN/nmxNHC+amuEx0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D73WKXa6;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787129416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTzmg2ieqrLJypukoGbQLPi6RJNbuGf+by+2EUR/RFc=;
	b=F9gV8pETDIqDvQKmu729/P1C8ijcMMaRtIZFlYpmDvbk7SRlmLAYe+uFr6Vm8JHorugZM1
	+0bPAsoqvfh+G5nK9Ea+av5pdMZLri54dy+lZ2k6YDcvq70oBzMa3sVSSdZD4DiKyL7joQ
	wLoTj/nwplWAw+4xtIuz2M94w0zqV0A=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-482938466a7so599938f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787129414; x=1787734214; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JTzmg2ieqrLJypukoGbQLPi6RJNbuGf+by+2EUR/RFc=;
        b=D73WKXa67U9xB5FF32aqVFQSdA/OfGpqIOF3Sl67BWKb2jd3WuReCfxr/bZFcxWiUs
         nvw8lMIRZdrlp+SvuSIppN6AohZLopPpBE7bqTY/Z8u1L+9kkrG9PYWKT8ubrpiEr05o
         VgadyQ1DrFDA/+GPiSQ4ktWDkp/GARdSppVzOwoaIt0PI+E6OCPmBHuJoxoH4C5SYEwa
         DwEc+lfWSP6n4wTEu815WgPiRGqKRMmYMa6erikyFQgcUFmde/Gl/GsrpQJgdCmKDjwT
         3HjHswGg0l8UGi7zaBLl7N8fjp9VtC6CW3mQfevhy9eH+SA2mrLds+G77psKJp+/1em0
         FWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787129414; x=1787734214;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JTzmg2ieqrLJypukoGbQLPi6RJNbuGf+by+2EUR/RFc=;
        b=N50WN4XhL+ui+dx+wHup037jQnE0a1dkBMzsmqk5IRchh6JuaBegPPBsd3uVBUFIFj
         BLdesBLBA8SL2Z5L3PeW2iA9j/OrSbD3JIiizs1qTNd7iuwRa0KDqHU95yWJjBJFEzIw
         K16f7FpyEibexY0FBu2v9QNHOocKN0JHnXL5oFayVjdtZGsEu+ALJ65/Iff8seBLaDuI
         QNzFM5tcejqHKcmR0Wpo7LGrK8KuCZZtSb82ZxWRSR2OXXEKqEEsoWkeJ+6ipSO/kIAU
         cX1ISpE9kLSeKFOP0UG84y8E9oMrfmtF+4JdIRQD9HprG63y/QKqoeMufwCOVdRZAWl0
         OWZw==
X-Forwarded-Encrypted: i=1; AHgh+Rob5ubAILmcu6pjQSt5rPizf7u5lGp2eqw2dvKzZ1/H/78N7ztfPQZ72qFWnyce7rjFKCJRD0xNKw==@kvack.org
X-Gm-Message-State: AOJu0YwU9Hs3zDZDtDzbfGNFEvSD1MELOeF4arVgnk/21L9SbM/HHA99
	3CHCRgiOgA9ksoDxOsUYkulpaafXFVOYW7DCdXUnEWFhKeYCEDsvo906NQJCHvxTgrk=
X-Gm-Gg: AR+sD11J9kaEpg7FU2P/e3fSF31sLjUGxIcDjHB27P8d2PO8Zj+ZO+0QhDOgE0LRckY
	iFMcWcoknw4bcc1ZClGkK8t8j8BnMw13U2bQ7maLUwMYYwUO64UjO1P5LXyGlRi8ESsm3iGx9dY
	44QfqIQprBbklr50SJv53j+XkFcTY6vw9Tt9QaLD80xYsdUzOMroU4tv9rF2U3RMj3zx4kmCiJp
	uxojY3cTHq5hWiYZ0PzYIKwh0OHFCez3ChLu1dPYS+yUZH6L8AFKDtcTl7U0ygG0ZcVGN/GX7uH
	HMjAfHZC56DV3flALrge04eKbkE4ugZnVaEM1GE/yn0WZ5guIOHfa+sPBm9pptiPMtOOaxsqWls
	+qh5lv070FyTcy4QgbofMcw5XdRg3hulrcac3AqCCjR2pc6xRnrK9dnmUk/oD43gLAYLe1QUqeV
	gqRepywZO5hrLGVVfhEjMAMi1AtTjJWpTj0WvSQJjl//3LYwEhhKw6st/E4qxACJmj4PMMZ0YCn
	A==
X-Received: by 2002:a05:6000:2311:b0:47f:96e3:530e with SMTP id ffacd0b85a97d-482b1e91cb3mr4888919f8f.8.1787129414454;
        Wed, 19 Aug 2026 01:50:14 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450fb9sm4258529f8f.14.2026.08.19.01.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 01:50:14 -0700 (PDT)
Date: Wed, 19 Aug 2026 10:50:13 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-ID: <aoVuRWz0VkKiJPzd@tiehlicka>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
 <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
 <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
 <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
 <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
 <35cca76a-4d3a-451a-b492-dd4423ac3e63@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35cca76a-4d3a-451a-b492-dd4423ac3e63@kernel.org>
X-Rspamd-Queue-Id: 0E16340008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 591t13gqs4inhkqp6n57x5usjmquu17j
X-HE-Tag: 1787129415-535188
X-HE-Meta: U2FsdGVkX19Jyl+28aG45vhyQF3i/CMBI69vrLfKaOjYEPE/W+eCYCyXJLIa5h/f2+2pF/hXBfwt1FwajP7ewJhfMnGZCq1NeZ84KOHKntbI47PyZtrVWR+wT8yYdp3kxXzgaQmpv/aKkqSImWfNA2atfc1q6VFF4KMQe2+eb51XIM5b6A5djnPQMPsmTAMLQaJtzQ0/GvbDwkL8SpFuqlsP5sfS1yJBJoYdNchHGb5Jf0DEbawSa4Cp6GXABk9Za3UKIXTUlyuYrU7gtSSsXB7CQMdQAZqBISbf1x+LHDcW73LtI+Ht4ibo9BFTf2k3lkAn3geIIF/Wii2J5ojOJddBcFHr+BJM//UvRiYrdoqbTG17MK/yVFrAKYoxlpWdDCZT2t0VYMkx1lAh49lqIQ+wFI4rnKOGH5c70Wy5d7t7WTdTP5U6YBNfKdKeLUdOwiVg3Fd7bh8qaV4nZVQ9K3PEysDqRHtmy4TusIhzm6FQJDkADBqHRdbhnHiABpmtRndnYXUMac6FT8vSPWSVWJjYyY8owkvmf2AoD1aJqNHQIKOY+0M38sfdeNo6ZLw1ykehfDZQAl9pc9P0TlqKQWPBeXYxcnKtbsFBKDdlesZfjJPPJvDf1mgO5hQJ11KH39bz5Z8q/N5yazG8ltdnVsffI3GnDh20pe9/R53llysX3orkMaybOmckJUOBCQ+ly4CtcJYPJA6T0ttpmaQ9jdn88/Crih0fjDl86nOV8X0N6MFtZBsS8J6i6H8Ye8GTwdDGwv1hpx0X8ieFOdCdlAF1Fj4nql6n5H1iAAcs4lAjo/7lhaaRNPXRIt+GfQ0Tdqa78nkkOavskVM+cS58IwYaXftJDccndSKmC+4O41Dt0j9EdfEtFt9+hgda7mJ2qJee1erJtHzu1L49KzhALNu+3mb70Lu99U0pRGjHytpWIdwQNzctR4/nkX5w+XgzPTss68FHsNmejWVK9S4
 pW9XtAb+
 sSMEX0+53CL1tWDOYczyh9cPOGPCMk/4bxoBUQAWhJ3EYZXPryS+7E6v0bZOppHlUQriskEzN6qCuziU94zdWh8zD2of68AXy7t96IFiCflxiwNTG3w2ohanshkKZXg9ZNb/5WPzVgdpwUjpZ4Q8uV92fLBPoVO3kolrAWC3T+RLG66wxGOZLdpjHzD9jLkBGKxpiinS7bC3AF1EiD1JqJ0bM1UlyFZ/uz5VCLDd61EfzYaQEWvrkesb/0ZHuMN5akiyHSG8h4wirbnWxSnSVeB7uAqiCMcgL/DyPr422WcQ0ygZ/tQcebhycGIhYb6IIQiDR6xJBgrxoFwjXPx041KPKD2vyhhB/WoFI7dI9FDlpH5+5t7g/N2saxtYJtHWJO/A6Nll9QevcvnHqmVzetFSjfZXAlwU/yPIYnmEVe5wymQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 09:53:25, David Hildenbrand wrote:
> On 8/18/26 20:55, Andrew Morton wrote:
> > On Tue, 18 Aug 2026 20:21:37 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> >>>
> >>> That's pretty bad behavior and we might want to fix it in earlier
> >>> kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> >>> existing users?
> >>>
> >>> If yes, we do want to fix older kernels then we should merge this.
> >>>
> >>
> >> Okay, but that would be stable-only fixes?
> > 
> > Not understanding.
> > 
> > Maybe you refer to adding a patch to -stable but not to -linus?  That's
> > against the -stable rules
> > (Documentation/process/stable-kernel-rules.rst).
> 
> It's tricky: if a problem only exists in stable (there is nothing to fix in
> Linus' tree), then a stable-only fix is acceptable.

The crucial quiestion is whether this is something that needs a code fix
or a configuration fix. Really fighting for low latencies with
PREEMPT_NONE is a kinda lost battle. You might want to play whack a
mole...

-- 
Michal Hocko
SUSE Labs

