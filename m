Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67685606A685
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 10:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=SvDGtaoJ
Received: by kanga.kvack.org (Postfix)
	id 30F676B05ED; Fri, 27 Nov 2026 05:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF006B05EE; Fri, 27 Nov 2026 05:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187136B05EF; Fri, 27 Nov 2026 05:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF6426B05ED
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:05:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DE43140271
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:05:05 +0000 (UTC)
X-FDA: 85480465770.13.CE38866
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 514352000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:05:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=SvDGtaoJ;
	spf=pass (imf31.hostedemail.com: domain of hengyul@cs.unc.edu designates 209.85.128.179 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795773903;
	b=ul4okLKOXzvj3XCUQP1HEfWRSrYXhnL2gPfyRoVWuJ/NJwNeYdx4g+ySSK3FCQEMSV90Df
	15vkDcluAFHn/7HuEjKVvrygk0dwRiZDDUjxpVAIgUagzRCx0CyWPLLNVR5qwgDychDAnK
	AgbZcFWGsNXuavSbivI6eB3Z7QGGg7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795773903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LNt6LCYfisU+3PUtDqGPrc6AXpiMExriMvsMZPkWPo=;
	b=jffqUJCyZxQRrHxSF06v/jh9dIAgqz8VBA/ALtOpyr0C5+b4Q20wLL1QcRcd/Vwk9RVcdA
	Ym4mwb84pvqKVmnkAJ6TGDnm7Wdj8/hcZXiqqmbpPcaLZme2xJ4xYFyA+Et1+woERw2ekA
	G4wK+rc8adXiyrls9NMwv/f9TsDO+uE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=SvDGtaoJ;
	spf=pass (imf31.hostedemail.com: domain of hengyul@cs.unc.edu designates 209.85.128.179 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b503e2a87bso80727877b3.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1795773902; x=1796378702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6LNt6LCYfisU+3PUtDqGPrc6AXpiMExriMvsMZPkWPo=;
        b=SvDGtaoJVPXzUFCwfC2qLy7V/9f4qDJSk78RmZt+00GWxzLnZAQxaLQa/TXdsrLkdh
         +FhAhkVU0+fdMpiwRUTeLlNMiElliqYz7eI0hlz8E86MvBT8TgXBTorA5QYkWrck6xlw
         7Ag6hZOeR1y8QM5AZk9AbED/od2J4ydOn73AhVfJjmjSyb8DeD0PIXq28+1xmUywb/M9
         XEgHSHD2qx++0Q1QLTppuvJMheRBmbdUdlHDN0jdHmaAOj0Bo+g2XQeh5bnmY9pf7PWt
         zMFrk90STD+ZhFGtnwdJL/kg2TC9m9TM3qKy29AQgNxpBUOvY7jHLfbPSrNTZkg+/OoG
         UFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795773902; x=1796378702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6LNt6LCYfisU+3PUtDqGPrc6AXpiMExriMvsMZPkWPo=;
        b=SUhAAxYqAAsyhHqPEbdNrRmjp0w1LBNHD5QtgCGTk159w1wS+XDvckLy+25CTutjGI
         6NDI0ZQ+q+qBrklWrdzREIUF5xKJqJm4XzuN4XPbKQ6OOVxBcQ1eS/gLIgut9HPF1m78
         YrUqT3yH0NldyDocDb7aefFQE2L4nG1EPtPthxQ+wpFf8JabXG5P98SQxxacjiRQrbdE
         nMYZbOQR8lMEigLm2F83pDTPqgQjEeyH4ybfwOQ6KaIaCQdoLi6TmM/Y/dqsSEpdMpZh
         ApotfZQ1tf1KDrR/9jHRZxuPGStFNanHaUX+UJlt8eFv4hL5qHcDwvO6f3jzqktqpDiX
         GrNQ==
X-Forwarded-Encrypted: i=1; AL+hErFiFT3SDeitXAj0WH5wGAFga16i9zb4K6VyaEGHcvFNHI8MhizIwhm+M61lMXX3nUk07jQmnGxAsg==@kvack.org
X-Gm-Message-State: APuU4Z8NpaiD3JHieMLkcjg8gMkztObOG9GWffw/tfSedyzZQ72gKfmL
	SB/lK/mykv0YPYZGMuD7qyseEf97csgEHM5U6en7I5YZryzkiZFdNlBhbev+NB0NNA==
X-Gm-Gg: AZFdTZdXKnFy7kBtw+geIQ43kr+SiIOCj3VAAqRp8nPTiHtcER5tCfLOIGc+yPArzrU
	Vky0VHGcVeLsDnixaSwHDY0xZa6dkI3vEwib0eip9431azKKdV6NxA7to/4pEgiTiEEROn6H+lW
	ZzlzVfPdoniT8AB2GYCM8yEh8NbdamOQK5qTUw3PnpLgBDIZPusKG5EmU0URJ6ftyEJeRP/TVLy
	gGTUED20LaXGTPTV2F5fIHtsKQVHQIP344Z7iz3PpIVVy2Li9kS/fbjjFbF/knnYnTEf0Exb6yO
	isiwyTy7QbH6nwf+6Ni6pDZXWP8Qu5LgvvjdkE/eZ7zP91enBM1EvqpPzgosM0I6TXAeJMlE3gb
	Rsy/9t4aWPoXVY7TvFyb9VoWWbORTysOR1zdqpb37ES5v214rWoTiY7HxGLkAV9g0fCB/KJufBM
	2sPWKEjpeWlJRWYjaODVlYVh8NWf0vsUn7o890Evvdm4kSVHIPQjR/fAvieucBFo3PXmHK3GVHF
	+OIVOqa0vpe6qJvO01vu1y9J+EVQ9J4u9AklMMTvUZZhphDKAPUKhiRFLBSGQ8JHfE9stxJAVqo
	GfGoLYiZ2wyNUwNSqfMuAEo5zFnhty+Esxb7OT/MtIVDjQIMIT/J4A1IEo9uZ55Tehjq8aj28w=
	=
X-Received: by 2002:a05:690c:45c5:b0:8b4:d882:49d6 with SMTP id 00721157ae682-8b5201f68edmr98152497b3.0.1795773902358;
        Fri, 27 Nov 2026 02:05:02 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028c802sm94799507b3.11.2026.11.27.02.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 02:05:01 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fault in ranges that start at address 0
Date: Fri, 27 Nov 2026 05:04:57 -0500
Message-ID: <20261127100457.1388226-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f5ff8f43-c75c-4b19-b683-fdff0c6dd7ae@kernel.org>
References: <20261125173202.3636133-1-hengyul@cs.unc.edu> <f5ff8f43-c75c-4b19-b683-fdff0c6dd7ae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 514352000E
X-Rspam-User:
X-Stat-Signature: mw3o48a4uo8fop4eks9mcbirjj1jxx5u
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795773903-616109
X-HE-Meta: U2FsdGVkX1/2e/6YpKRqbXmBgpNmjPXay+cYfU9YnPfvPiQpXttfgfYkw3QDhSvIHsF3m5xYFn6gh7R9tpg9MVpwzs2Sk5wuHdZiEjnRtcv8Umh8eqnKjJsfDwg4kekyWgyOH/FcZkz5Sl+AW1744hZuuBE3XSjVDJQ3wQfh2/+28BYTz5YGXXwodWkgeIytaua1eN6vtVkqSMaE5uFfaGPizB7H2OaHov9ossv294vsRuazG0SAW9vdDzwRvCcxeYlZqLlC+YIfRRq+Frf/1E4Vjot2oeC7iILIMMLIQBGjEaItcR5q8MOqb37p1URXxh48K0uWsmgnHXz9zivU7DOsemtB//852xG0HGVApQ1b0Xk3DLnnt5W6etUZZKh8Bv5huOGarW7HD9klWVuqLCQ0wy7YHpWuT+Hw2RM+hkKLM8wgcu+5KDkRkuAwTBZV58npy94KJoGpRbVpVYy+II4+p8eUOqdf98s3ElTLln14Gz4IghQoGZNacIlcY6711l4ZKkE1wGt2jOYfO2FcsARHrbasA6wzihtLrVgcldP0ZekHzB/EOkiJvXe7XSJwD8TWFMe1ZEk/Owou3piOw4zcmCHFhmQZAIfJ3J3CHzG9oFJtzf7QBezXjo1NSV8RspbnJ0nLbQ2kxpKseKgZc+Gxr6/IOlf4sUpsjoQChgCftJiahUGsG5A7b9rFm9ZkMuqvLKfNhDGpXN4jaP6oT/pgiSW72YrIzselnY3m5M0WHROCNG+LnMWldZ4nLPWvDTHrkqT8yGFCuC1kiAJ+arJKDsHjRLkC+6NZYD9c59CRaCjCj8Jm6V4pDk+UBwMaovNnjr8aCJbY/nCXCwrIZ6ycSNlyOuComdTVqRqTxXNZ5l+I05YoCZIcxTtScvKfNqw/uKfm+P3iDCe55AHWHCil9diacT7QCL83VG7iEJThHX48vQnJlmYPOxapD0aSLJXu3FUJyA1oxy+Dayh
 CxX2oMng
 O5DOW8NiTHeTjRaeEThCI6LZIQ+l7f7u+85x1x4GKDY+lg6n0uYSWYZq5We2hzI+GBji0GTMwr8uQXA0JPXddCoD7vjZOUAmfARntq+ZIN1ZNDZNWf8dMZpNdNaUUyaSO6MjO3wIv6kMV/lub1C75sRDREr+AfaEVR15mgpgJgk96ByrDzVHLVT5AvNMD0+izAikZdwZJfc0q8pX2At92CvbGbHG6Q4rr+UzKfEPuokj+IZ9aavH+3PLuEvfpzyFdDEDza/NJcHbskVDRyqP9+Fk24Mv1e4vYyWIXUqTvm1gmGXqxTBh3FnA9Qhuz4Oekc2THB3bpFv20yUftZeIDVHZbiURwcOkfDXwszU5tdA+1zVuiDFeJSQX3SndJHf+7R7lZoYGvpaKUb2uFB4AOrNistNG5IakgjvWbZnSIYmEazO5UViMzAouUiG98gGXXc7Yx+oOo3Hxqc+QZ/4mvIM4zVc/BiIqwRKfp9mg88PE11U9upERuetAIIitAI3x3MBXWGry2PpSDqSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Wed, 25 Nov 2026 at 23:51, David Hildenbrand (Arm) <david@kernel.org> wrote:
> Okay, but you did not actually run into this yourself, right?

No. I found it while comparing the behavior of different kernel
versions, and I don't know of an application that hits it.

> Likely this is "nobody cares" and we don't need CC stable.

Agreed, I will drop the stable Cc.

>  	/* Stop once we overflow to 0. */
> These comments are not really correct anymore. We don't stop once we overflow to
> 0 anymore.
>
> Likely we want to be more careful when calcualting+handling end instead.

Something like this, in all three functions?

	unsigned long end, cur;
	...
	/* Page-aligned end of the range, 0 if it reaches the top. */
	if (check_add_overflow(start, size, &end))
		end = 0;
	else
		end = PAGE_ALIGN(end);

	for (cur = start; cur != end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
		...

A range at address 0 is then handled like any other, and the loop
still stops at the top of the address space. This is close to what
the code did before a7797e74bd39.

If that is what you had in mind, I will send a v2 like this.

Thanks,
Hengyu

