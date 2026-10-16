Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19820CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E566B008C; Fri, 16 Oct 2026 09:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FF46B0096; Fri, 16 Oct 2026 09:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245F56B009E; Fri, 16 Oct 2026 09:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFF046B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:22:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 767F8A6571
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:22:59 +0000 (UTC)
X-FDA: 85328554878.11.564DA44
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8721E180002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:22:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uLkw9qnM;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792156977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZ+jg+YnV/4Rx7SNrmGuegpLMiyUs48QsBYMqR/oF7c=;
	b=Hc3fVMpgbV8pBBgF2YL5qv/hfn3JVO5Zmso+WVPS4fJ8NX3TqxU7UdytCJQIZWuMVZO1Hz
	LFoNbMeWq7P3h0+/knsNR8PoxAuV0nygQwmTcrNLF+mYZyksYKm0CiQ2hv73q3DZeJ8iUK
	RFsbd4iI3tXLx9ON3CuQf0+bTVegPxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792156977;
	b=Camyssy1g9LJR4WZIo4waq3fAwmZurdev4wkuIPaYXyHD6VVHavJ+tedbKLvn2iFMwNqRe
	265ccUmBEDCr/kbi3TPTiu7ndHJ13o3vbcxAbfOZv2mlMujlLRTTiV0U0xGBMC1kesrNyR
	CD5RryGbgBtIM1aWEMLSgVt5CEcIFrQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uLkw9qnM;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917a20e9efeso90154336d6.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792156977; x=1792761777; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UZ+jg+YnV/4Rx7SNrmGuegpLMiyUs48QsBYMqR/oF7c=;
        b=uLkw9qnMWz4B0BiK3/7dQME1Ujx0Om+q0g7B/0dni72V0b/H564O4imiTHvsgyJYEP
         1DbQlBR/bV0s1eeAsEf5gPz64ugt492OHB0gLRi+18Fr+LzHhO2Nig1uaZGUjDGk4R23
         HWYFtjhoFuUpMMjOoE1u3o8ElzAFVI3LsD2qX1Fwpig/aUFtHAXZoQ7e96wURalYtBxE
         dJtslZYhrzTXE+nUETnn3xfVVoXInwkuCj1hfVAEmjBbJ4VyIjzb8FeVNEUvsZTRb1LK
         LNu9cm/Z6ixF0e9bW6P47K81FN7V09el2hPxMvVV3SArmXqDvgr9n7l2sYvO6GcX3uU2
         hdiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156977; x=1792761777;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZ+jg+YnV/4Rx7SNrmGuegpLMiyUs48QsBYMqR/oF7c=;
        b=Vj8hFNN8H5I6JttitGLwcGlROwjZwmNA+GjYYrm3/MxloOaR2Tv4CiJXb3RJTnPT/+
         vhJEuc7gIpmwLqRBJlp3RBHPU4Jy9YMOQlBWAU/3C9vsCOlrEZEdeNjhUKMG8ZWlKWzE
         aRzzAJ+4qK3tC9uM6pieVRsh7zjzU95CVIYnY87YFCIAkk4H2g5DQ1ihWDw8T15FkJd2
         Ie7DBRlyJL2TeewYKtoPJCrjyCXEuvsBQpwXzPGwDD5coWIf/UtKkef8cr25snluII+B
         05KARsEoBpwPmydne6ORqGp7aBti332JllXez2jdGou/V5R5HB2Vgpa4yrSmP7sqYEVs
         cWsw==
X-Forwarded-Encrypted: i=1; AKwUvByf8klGkVAMjoslDmb5xu2RUbEsgnkbn+ytrcfs0QrcegJn0pf5PmBsoPP2OgQbgSzI6AW07W0VkQ==@kvack.org
X-Gm-Message-State: AFq9FYJU5nf76bkZJdxB45LvNXCY6F0S4JXaPUcOxHQTfpsVbp9Ga2mn
	EV7X42vPh5T2S+ybhTVI5WFaZBviII9JKv1B3nn2J90GgDX8NMiWM9oD+TC+DP5t644=
X-Gm-Gg: AYBFou0mb6caUHIzzTqWJoFSLtIiYS3sQO67ZLZZQK1v6iomOZEZB3WagKmXErDCeyB
	c1t788TR+QGdxH14IbiZNS7iHRXe63nNc4+D2v/vt13vq8KV8TqH9eF4IDMFaTUgMTof3qfm8W1
	woGmZ4xgN1wB8RfHcRwruXM2wr9BK0EFzNa1JISRZIbpriOr9kzNsH/LLZQ8UmhQsA+Nm1WTmC4
	hebCusnyJdB229OXk4Y2pIXyIDP57BQvUBXu2BaPUuM6kNEk0jIDSx+1++fIz8+kOXlwcxY/ycD
	qC9JZ6vONRdPKx9kxe0OCiP+z3z6MrcpvGkaMVj0BGliERTzjTIKbkYzDuS44v9hP3ML8dCozHt
	v7fk94CJL3eea4yKgMtfwulO7nXmK+n74lH+DGnhslKd7C1LgXXrCnnunKhLDoJVVQFtfhJs9xQ
	SRYxh/0iSNVSVVPXrQrnaJsrFkod93jlGItBMjsIGVvPvS0saoez/3lgZjBgFLi8XvaX82Vl3uf
	3JykRWXBreLHsLb5JUPwkQLaNrcHBwtCgk0EPEfG91E3QfpRNJPYh0=
X-Received: by 2002:a05:6214:4808:b0:917:8b5a:8e81 with SMTP id 6a1803df08f44-91b55564619mr403547436d6.29.1792156976561;
        Fri, 16 Oct 2026 06:22:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb756fcsm22569936d6.42.2026.10.16.06.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:22:56 -0700 (PDT)
Date: Fri, 16 Oct 2026 09:22:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 3/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT range
 handling
Message-ID: <atIkDw9r6CVDJaG7@gourry-fedora-PF4VCD3F>
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-4-gourry@gourry.net>
 <73c55ce6-67a5-471d-811c-facf712b2fe9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c55ce6-67a5-471d-811c-facf712b2fe9@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8721E180002
X-Stat-Signature: ubi58o6s8gbh4kumeqcysmai8ikpqc6c
X-HE-Tag: 1792156977-744057
X-HE-Meta: U2FsdGVkX1+tb6G3orNGWsKDUCrNXUQyrRVs+20aPM6IkHunafkfFZqxonjz9fKl395JCt4Yy1pUTADljGDp4zJRwAuR1lrdw2wMnSYBW4KmeZ3rbd+kBLePfPxa7Kq464w2JCkZNBUzbd0reiVdY/PR1pzm4K9uEpq2bt6CSESVNc4hbtlhGBXdqUS8tmYTIjwdu+DNxjDyTw/YTgXVov6o+Wch5z8VgKaPi5O4AUnabRAZ4fHydAKQU01KZastpwWt7sjdc3SVdjiNYs9oFRFjSk29NJslTJronbsKlnlpJWj8QdW+FD32MvpDWHdsHE4PuOKDoCAGrFmr/kHlu/YUP7Nd7rV5ieeczP2+V35CaARG5kXxCR48+2gSCyCIeUlzVvi3qqyhEFQOCjZC6ZyMmeKrZtmsc1WddHkg49evlVu2HhygtHTR0yPFR8f5AHzyNbXb7d9TOfwBV0bpmMteL9vdOHX+zWSvkxkEiiGldMwWyUj2L6BW5OoZlRr+b1NjEwDbptusY20Is6+DvIsHWAt0jjVHK/PyqMhcXfhVNA529VtQqqpJ0hhjxN8HYg8mFvnzUyf5D2iNdVpYncd1jsYozsknYM9DTbFcCKcMH6xa9HzsRhANWLzmhGUHp5tFdUUsk2Oto+5UsE6Z/PzZ7Ci/J+/BmaRVWeXuwZuzwZ9xj6yIgMJSUahCTLUeKoFRjBcXBZnyr/rLu//tmVLb1SpagUQAKGHVo8VeE9dMedheR/oBmDfEYXzQPG4vfjPpi/5IG8jLKU9a0IzcVcmPyuX6UCuh3SdxBmOlOSkHMtEZLqWJDJ1+N6WQ3EZzPPLZ1Q6Y/cnvzlzoa97uI4FuGbvo2lKF7G+MLnxO0WC2A0wIRtraJ0yK8ZNaAhBdjIdSuJ1P3kcupU1R1Yj/U1+dxHuFZoM9BYO9ksyd3JWYePZHgUc5GQi1Y0CSKiR7h+MeAIzUg4f8o94hkw5
 ezue5AIA
 jhnT7n/4R+uvri3etKt2l4Qg7mZ9wASc1/syWMQqv7F1/p6QeAMES86ZDA65fzs1cTirsK2Qohio7HbDpF6nT40bonTG354I/H/JyW4HAxeflopouWBdUHK4xy32gUaXJxIFPqdgF9n1Q98nILoW46llVg6EvV7kXZLn5kJ0UBFh9FnYtsZBYA9B9+ctyO/IgsXtDfiu7BZPKjWW8aGbw3gpMlA4vgCjvoBVdcACwCkyib24fNOQYC/hWHgSCboCV4AO1KRmxukWoJlxwUMY6pWgP0Bk+wHM1YXi4c28pHEmGPhCoqd5qgmBqenp1srUtuNc9KOQbqEKcv5z5gDzn91btgyg6693TMdBjUglcPEi4JnRuNtPzpQyf0Kjqq1WWdtDh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 05:47:57PM +0530, Sarthak Sharma wrote:
> > +/*
> > + * An unmapped gap in the range makes either hint fail with ENOMEM, after
> > + * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
> > + * an effect on those pages that the test can observe.
> > + */
> > +TEST_F(madvise, unmapped_gap_fails_after_advising)
> > +{
> > +	char *mapping, *control;
> > +	bool swapped = false;
> > +	int retry;
> > +
> > +	pin_to_current_cpu(_metadata);
> > +
> > +	/* Make sure MADV_PAGEOUT can swap at all before relying on it. */
> > +	control = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> > +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > +	ASSERT_NE(control, MAP_FAILED);
> > +	control[0] = 1;
> > +	if (!pageout_until_swapped(_metadata, control, page_size,
> > +				   self->pagemap_fd))
> > +		SKIP(return, "MADV_PAGEOUT did not swap the page");
> 
> This test is checking for both MADV_COLD and MADV_PAGEOUT. So if we skip
> here because we couldn't pageout, then we don't test for MADV_COLD
> behaviour at all. Do we want it this way, or should the tests for both
> of these be separate?
> 

If swap is off, the behavior of COLD and PAGEOUT look pretty much the
same, and we can't actually test them meaningfully.

We check that madvise(COLD) returns -1, but that's also largely
meaningless if this initial pageout_until_swapped() call fails.

At least that's my thought.  If you think I should split it, I can.

~Gregory

