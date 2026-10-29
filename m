Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA453606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Wvou3VpK
Received: by kanga.kvack.org (Postfix)
	id 00DB86B00EF; Thu, 29 Oct 2026 16:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26B96B05B2; Thu, 29 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E639A6B05B3; Thu, 29 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C41236B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:26:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DC761C3CCD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:26:25 +0000 (UTC)
X-FDA: 85376796330.30.96E0F96
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F1B61A0008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Wvou3VpK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 37qvjagYKCDMZjcXnjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=37qvjagYKCDMZjcXnjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793305583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
	b=CBBjCMhxX7hV4AcHrZoVweJyNnXRA/7GdX6GezPGE4QF4JzYmtX5OJ//avEbXe4vTREkNo
	7D/abAip8mjJ8Zn+zF+aQ5Mds6FbuLG75phkieJxZFOgOBbcKOHbC+FQexblcC+nEQzFjr
	X+tmCOg4+vRpUWIGSm1fMOQk5RvCWd8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Wvou3VpK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 37qvjagYKCDMZjcXnjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=37qvjagYKCDMZjcXnjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793305583;
	b=Jw93PsbMJfyAdiKxd2KqM4UeB8kXIdEq+ruxJJv/3Lkaxqipe335L8US8WM/dNnMecyhy1
	F+UWgZERIja3Oj4dIvkkpzoDMdVkBCulFuzEhciKoZA2lm1nYcaFwucfkHOniWPxa0n3ez
	LLvZtiEictRpiniNlyli2VhNV+awxSw=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso8733a91.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793305582; x=1793910382; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
        b=Wvou3VpKfMqhvvaw5dI4W/lqT96+iLJavbS4x2lxDrRblDUEUgwtEYTMGvYsP+lW5Z
         N84TBcCjUs64+la7lJNUxDZqecGw32Ur8ZaOrrRMeyeSf5AQmrKN762Owk5yoDjJIaIh
         cB46iPw4Gy+p3Brf6tLrRtPaYQkIGQWaCWuxyk5dGbc4Yl2mXij4lh0dWry0Fsrps1dM
         vRqBHavXT80sWENxc29uJz/QsxwoZpckHTFoijGJwcihYUznCIbBXdeJcrf74VIj9aHQ
         Y5FssyVOFugOqzcKf41II0A16wxXEdjzB6homvhr8p+B8Y7dQ3esl0hsVuPPs8C4Z9oU
         RjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305582; x=1793910382;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
        b=rolfHaT4hw9FHKsvOGEQfpauKueFk+3NIFT1rInp1kAsHKsWnTCfSFPcZll0bV5hsm
         Km1r+DRNseZg/4ZtpqiiPNdXZkXc8Xd3+hP+qVdjzLlGn8AS8+HCCvhloOurB9pQhhux
         L/oGxJZ4KIWgCvhOyjx7sfCfU9hk0nhovErCH4EB95e0wMJV3CwcvHJLo0LIHUCpBFlp
         RSo6/8uFxT8UnQDUmu9gdfgHSWod/6ixORKt0/1X6FwRi0GHg1lnW3BdNtaCVpwbBXAR
         gEx/X1uTJgRN6wPTjdhyGpqXsG8bvhTh2p7fVs9iQq5rS2/5MJas+8O4VnHe8Ou04kNF
         R7ig==
X-Forwarded-Encrypted: i=1; AKwUvBwLRuj3f6YL5Kw11J1+XUb6bfLU/g23bAMGUATmMRaO7xHF2cmv+2w1i9nNwpPM/gHDkS0NlCwGZA==@kvack.org
X-Gm-Message-State: AFq9FYJxP4Ws0aLC4JM25OEvoyvzfj7TdciH1pamvzHFsLTptU5khTxl
	RFjZejfXm27c/OMHy8289s6z4ROSTsfc9ZlAm6T6v0C6tr/cWMewnW4hm6zVtgCDrWUE866niG7
	WklwCzQ==
X-Received: from pjblj14.prod.google.com ([2002:a17:90b:344e:b0:3ac:2cdc:a8ca])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b51:b0:3a0:cbe2:9e0c
 with SMTP id 98e67ed59e1d1-3ae897c8800mr87140a91.63.1793305582207; Thu, 29
 Oct 2026 13:26:22 -0700 (PDT)
Date: Thu, 29 Oct 2026 20:26:21 +0000
In-Reply-To: <auOlmxtQ5-EZTj62@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev> <auKcNvAizn-B92xB@google.com> <auOlmxtQ5-EZTj62@linux.dev>
Message-ID: <auOqQJQUKitt86XJ@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 9F1B61A0008
X-Stat-Signature: gnpg17riqygqa3bwipzut1xsmi9yn7kz
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793305583-508998
X-HE-Meta: U2FsdGVkX1/G8uyvQ+6ucYMcoV9Fv3FTwGmw0IRLFd5Bq20q2zjQTKXuo7Wm21YnVzHrqhS2kzwwFnH+2EZXw+QZfYNDhJukxVzkeSzbLbx6UQbXodIqmWoR3ehEEjm8XTBS/CrP0f7MPg5k/KydRs/UBKCfte2EaOyvhb8dGnE7yl3HJ8qUZnyzklgCYkNwSudBYvNLPd2VtvAKGh8lo4yr1l4tzhW6j8rkQGg45Z5dkjky9BEpfVHtjHRA8+jMOieREP3cjBZY2vztlSkkkpy1WAglsCOvm9KMLPt8wxkK9f2CXwal4hgLXR9E9kDuL/Yq7LaODUvKeHc6Z5WybqVQkBFjJ7CLrWM7qxjA2HnsQYDx/DZVZmlbf1jer54mObaJIUFcihkqRCgCRCglpu+14EHvlXjiJLiotkQ7hw6+Jkt+z3piuUcU3BxLb3gLjdwm1Zhmzz4YUzRgTQAC0BzlOZsu3qelwCvmF3y0Sf9AKkUZuWpUvTvnbh9H1+0ExjTHc/PCOeRXjoDb/vgRoBZCutUkfS5m8z59gcFOkOy/oTHv/bn8Sj5nYUQpYyMEQZI6u4b7l5jjI1LvzyBMGJvVpy3uv2fWm+K72zm1c71zAAGTswqvDopDIuwn01+LZEQgUXiK4uncc6bbM8Tp1EmD6QXjfb3bfDnuQXHmebYq9NjSWO1H5d8mDVFrzKWlcLmQnWborPziKAPMBQqtJKAH6jwA1e79XYE87tWKjfoaRMy9hxRywD8YF5vht8MXThepdg40g8W4GicE/QBhS0E19ZMrXYUz/ivMM2YKCuynEmF/eEB5mdiWskKBtHZEr90gjBQqdhAN9KM7Gb/8R4aXHAxvliy+2QDGb4oCqVXd4ZNdPEGBgsyjVXZLqQ43gFDwCBGXAsQl02CMrzwrxNP8R7c+9L6oeVXqM24SlGE8YBx3PdKsvl4U6NksRGpUCuRPOXA8/C6vIObAkxS
 4qGJBszR
 F88TUAQJWOcSXfkxDsNg5FGjS4nyuaQAB9ZrRUUFRKjC2gKS0ztm42N/ilZoDl+rAVts8rua0UVuqaVEp7o0KGAnm9cJ4f37jtCc/Z5HoLHIcgVH1bP9BxU3jb5tko66x6NyXfBVj0h0HJcHFXC9nrZotKKO6BfTS1kxhPG14k2p5sn3rx0PKs9h41R+xQ7vVLK+uf2kRIW6mzc4M94jqwDqGFt2Dw4CwwUR469Br2/aGmyogkvrEg54BuNfZTzhfu2TP2DUWRhiYn9sVizf8JiM48tfV/Aj06MF468FNpTI9uhFc0tEngm6NrJ8ltLL6gJZsPnuFsbtj0mboc/7yuV+JFREDeXfTam8RqEN5JgI9K+x0F8WbJDjQK35J+dHB2r15kg917HJSqjaxMrTJA7bpqeqyscXn5rgCnYRJlobeVA72/u1fmySL6+tNxNFIm3j9UJQDxjuV5NN65Zxu/iCkbpF+cF5C4BIkw9lVnORGqOhYvNZcs3KKG0lm1VREYKUtsainsKVjODZklA5kPrPr8xo/7cn2EZ6mSMZMv3i3oqYZ7MYnf9rmm+UB264r6XJVx/4vD7WmTpQrfjli3JpEH+EMVGAcQRUhcAItKcCPWNrf8c9sMkehNg2A8ZEOIDByqeWctJQrdjqr3h4qeZsHR3qZc5avkrP5PG17fCJMSv/RjU+fFkKwWp3Cnc+hfyyp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 13:02:08 -0700, Shakeel Butt wrote:
> On Thu, Oct 29, 2026 at 01:35:18AM +0000, Kuniyuki Iwashima wrote:
> > On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> [...]
> > > > 
> > > > For the 4th patch, I would prefer we first try to move the network sockets
> > > > from memcg to objcg path.
> > 
> > sk_forward_alloc is already batched per page, and I think
> > migrating to objcg would just add an indirect layer and some
> > costs for css_tryget() / css_put(), and still inlining
> > __consume_stock() or batching in memcg_stock would be crucial.
> > 
> 
> We are over time moving kernel objects holding direct reference to memcg to the
> objcg infra and the reason is such objects can become source of zombie memcgs.
> There is no urgency for the network sockets but eventually it will happen. We
> will see if indirection is really measurable at that time.

I tried it yesterday and saw ~5% regression w/ tcp_rr 10k/20k flows,
https://github.com/q2ven/linux/commit/7407580c37784bf594fede4d6da6b266d8c7a11d

but optimising stats limited it to ~2%.
https://github.com/q2ven/linux/commit/1ffc01395156b278c3d1c9c5fff7b9484f632be8

Given the perf gain by this series, I guess it's acceptable
and I can post it to net-next once merge window opens.
(rstats patch will be a follow-up after v3)


