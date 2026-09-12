Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD25BC88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DEF6B0088; Fri, 11 Sep 2026 21:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E06C6B008C; Fri, 11 Sep 2026 21:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDBA6B0092; Fri, 11 Sep 2026 21:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12C8C6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:05:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42716A4912
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:05:27 +0000 (UTC)
X-FDA: 85203317094.05.88A109D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B5151A0002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:05:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VFlA/pnd";
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789175125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoQ5u4lcyLVs7Z9JVban8aUncHWvoCiIb4xZrCigtXc=;
	b=MMUUZjtNEmX4thSNsBrQZSX/28KZTAbCAxur6alUICxoJ8SxnPoMXpV1F9fX8KJwrEGmnH
	GSgdy+yYVYDUzUlrh0ghBa3bMfoS7LRxEq2KS8VeWj8iwQHmnhTVTDHOkWJpy7SJxVufj4
	GLBPRMVI6fNm+MvxdKQnwQ83zM6mwzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789175125;
	b=HQVGQsIDV96xBTKMLxIVtGWckCLWIKS2H1fFhpJVYRZHSVaae8ITZCKgRXJhtAtKcrUBLo
	sOnZV99rQbDuTxI4KbNHkyZHrXbwH4Ih5y6Fr+g85Uv7GOL6G0dKBf1dNP0NOec+Shy1hr
	b89wFXLWX3Oca7gjL6oJg/NTmNXzU1k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VFlA/pnd";
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so16715ad.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789175124; x=1789779924; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yoQ5u4lcyLVs7Z9JVban8aUncHWvoCiIb4xZrCigtXc=;
        b=VFlA/pndPlhJ742Asig0d97KU0BuhIQiuJOyXyeDtuBvKnxFgV2Ga8gpzOeSS87WJc
         7jRpjpMafOZVrcd4MPOdAI0HUvmPJaGcVlvfWjAW2EsGBB0JPLiNNvKKJOE0cvA5p/UI
         GXGarHeOvP/iJ+OJC55P6nED7BP3dGtgrWC3G+V0unA3HN9K0t5M/QMXgCNtfgo5wvTU
         vW9cR6G+yYanatkoDEO8m6p8YAKI/siLghJBiV3z8uoIyPrLBl0e8dpbFcktCu41moZo
         kNd/ZAn/OcnpSTRyGTw6x0eBhsJ9w+msFGOuzUEENY6OtzwEyRGjhWXknZYYorCUiX5W
         s96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789175124; x=1789779924;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yoQ5u4lcyLVs7Z9JVban8aUncHWvoCiIb4xZrCigtXc=;
        b=WGOYLq3+v+sOxk3cbQYfOHx7PvbL8S91oUe8CyfudQhdbtS68d6gdxQDTz8vuIo+EV
         AI8qcxBCGiZ+ktFjeL7nIhhOJCeUeMMtz/w70ua2r9t25cVWn5mrc2oIZjnRBqU5+f2B
         3k41wgZ56nkKzXVQ9f/DMTNberQ8srVhCf85swv+L0BIXWnqH7bAgA34LzZZ1uJrHuhg
         KJ/jFgWwKDImBAiY7iBbgtOK1FNXtIy4p5gsxyRW4SUfj1g0YwUOlA14NoPLqO87EVRF
         SPxmEi/tipcJ3QZnOjl+vsBGVIC4vMEbuPNdXicXYmRRnLLmOlHgAA18f+/Fm48BSrwQ
         ARCg==
X-Forwarded-Encrypted: i=1; AKwUvByUZ3xHUSDvEvehEX02eEnC7ARveRMAFxpRvOLrFvagzKncDVvdktHSTGebQjm5lJ8UecoIyPhSdg==@kvack.org
X-Gm-Message-State: AFuF++m5u/VivRQo1KQbCdibb4AsuBXnGzvKo2WTvORtXOSibAqvFESE
	9LMjjQjavpxuTj/iDUEF3BAz3zuoVi6EpzBtzwHE626v2wZTCLRjUE5LSL3tuhTIbw==
X-Gm-Gg: AYBFou3nOeDR1TMnAZYNwQA0E0esyAqPMID1lscbvX7v6sVZsdbTglu1dyweitH2316
	qPixIJY5Genjn5uL2Sdm5EvuOfkJIaxJ6xTvHOz/25ErtWhf4PFzeIIFZ/CpvIoYSirtfFJuxV+
	0B3N/CodejSmwQMH+A27NyoBrLw29yY1l0v+qkbPUMZIlb/QRL3bpaesNTIIuU8mHHCaRaqM3fY
	vEAVUGZPqkPXt7tHhpF796y/1LiPUl2cEAP2y1jb3rXD8ZsFwR08Trb0D/zKrCXPcDOCIDmdqWO
	Cb1VZE3Wr2rM42UkOnfuYmV7SA98Hqsxx+R+jvCP1VNCDV/zmQHytG1OdLr8mDjZJpWeIyk4+AY
	BrJw0yWJRjbQYzeQytvId6AyGuZjxZn2ZmIKKwhww+jKHsIjqEttbfAxqFOh8ys7AapmDhYDpJc
	3NQUIHpW7zcnEMk0LEdVd55zTMT5BRIrZG7u6fkBS4vZzEsZ8yjkP3BRr6NSa9l4dn3EqM/Iok+
	k/s4Vw8PDRi+MiI/0hXNhU9AD+C8Zpcp1lGO/fFzYUqETt7kdVyifQZ+DZhATaQMRi4XkQJuFyl
	+yUcgNSpkvAQFospE/Re/bZDNua9WAUR7EQctQyoMyNcv2+I+U++O0cBOnCyF15D1RjZ9wbDbjY
	XdhLGUNM=
X-Received: by 2002:a17:903:98d:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2dd47ed79e3mr3343665ad.2.1789175123807;
        Fri, 11 Sep 2026 18:05:23 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:add7:30d3:d3cf:4f91] ([2a00:79e0:2eb4:9:add7:30d3:d3cf:4f91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cffb5c5sm17522605ad.80.2026.09.11.18.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 18:05:23 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:05:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Usama Anjum <usama.anjum@arm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
In-Reply-To: <8936784e-9ccb-4c33-9b30-f99552e10f87@arm.com>
Message-ID: <1af513dc-a33b-9c7c-2827-097e16eac077@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com> <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org> <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com> <707b26ac-7f73-430a-a473-cd3409c4505c@kernel.org>
 <8936784e-9ccb-4c33-9b30-f99552e10f87@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B5151A0002
X-Stat-Signature: 3itz8awsdr9oaq7jdumskj8jxp5wnj5o
X-Rspam-User: 
X-HE-Tag: 1789175125-660700
X-HE-Meta: U2FsdGVkX1/tUgvktMSq+KeuQ6geZFEKdHin9GM+wLoOTyxXE3j59LqzjDmXKk4nUlVZFl2khLAvIlN/QwIpnQPkY/8gLV6+vxy/z5/qXBBdZrmPfqJYC5+WyRCBa6BJHr/+0+fOEbuzlnv36tZa8WEMg7/f9rKDnbyAOPPmTBhmFcgalhZMY4HDOM55K0EkBVj16kFlNZLardiIrRCaHeKvEPfR8O1SXU3lvbemMvIdDdLSvQxH88R3KVWJzzwzhmMx51pnzmH+vnp79fDkZRXje5yukhyYrrrHDYmwJp34rM1BiJhGXZJymIhRRWqie3a/GIAsnTror1M6dp8GyP9PmF2FteYPguGWlVRuHhVd0/+dpN1iJVermjxFdKvbxp0m84WF5gbVK+cJp4eWrven1vgJS0Pyj68H/QfO35XVi5vUZzlfYnWieVZQBiWB+hom7+jNDkpevWemhU7Do0hNkFwRHfAEWPLvxUZ2hRyLeGp9EVOt0L/HfD1h1YE0jgeJHLJ+SJt5wQr5I1k5L25yUh7olPjQ1LTf31p9D+TVjnIPkw10zNqgMfpAFUYf/QdMfHdtBLcYqOwf2LYEi+/8XOhX1NiaXt/eSpNre5MjIKK76mlxPufRROlKHaSh3Ea4VavTbCKUWQbZY9EnozE0LfDnRIy+ULlV+NnT1DCIlNhFz7x7BHUbinDS9CUottk/aI4kPJgKMoVXoBItWQ3WocIDraoqJxu3Awg5EGrNAW026urQJpEyEDNFWvTuFiUbIrjNnXpPtv2uOKlFEcCK/w4uD+7HY2Aqpbnk62DHbGDINkAc4uogpdyQHR3qYaQgKeCoMw9ECB0e1q0RS2R3kHuZkGUjtDmnzt/IV+VVXc/RVRsdQaZ4ql2Fi1cLOWezg7JvFbYPo8pzfeqBg90ot2nICfNfRtiwjyCqUE4Iwn28yOPZZRNYBRkXt3WFV9ZadaxDScyPQbMcfaV
 H6BxLoL/
 zJKjwVEXoh/+BnxKKxnyhwR4s+thb0YOaiPigy9mWNAjyg9ZB0miuyYl6rY4PGaG05ZDOaNnXBzITjSpq31QRb/9mfcaZZxGsWd6qif5p5BoEMAr2S+x2zrL58mfAVBsvrFvrAKTXmMd59Gr/iQcwnl44EpaSpb6lrpqW8wDfm+TVVk4szZ7Q14KWYR21JdGigkTgszgeDmUAntjIa0Meh/VOD5fAdA8EBkrDANBSNJtFhy7mFqOWUtABDPs8CH+AiucuM+qxKRUzflaZbmicSEobbnM3Sd2LUrgzy/xbuMHOOZBmwvm6VZnDULPhslQeetWP69dza5tFpnAsGeUoZi9Fxvo4fn9UqO7cOauRPwE6rCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026, Usama Anjum wrote:

> >> I thought about the same and just followed what appears to be the standard 
> >> convention (like test_vmalloc above) for lib/ for now.  If they should all 
> >> be moved under tools/ somewhere, perhaps we handle that in a separate 
> >> series?
> > 
> > Yes. lib/ is just absolutely the wrong place for that.
> > 
> > Maybe lib/tests/mm
> > 
> > But then, I wonder if they could just be somewhere in tests/ directly ...
> > 
> > Anyhow, it was also raised whether some of these could be written as kunit
> > tests. It's been a long time since I worked on these, so just mentioning it.
> 
> I also think it would be best to try to add them as kunit. I'm not exactly sure if
> kunit would accept such benchmark kind of code. Some research is required there.
> 

Sounds good, I'll transition these to kunit tests, move to mm/tests/ 
alongside the other MM kunit test, and send a v3 for just the vmstat test 
as a separate thread.  If all looks good, I can do this for slab and 
pgalloc as well as a follow-up step.

