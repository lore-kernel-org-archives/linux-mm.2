Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3FE7CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 21:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFF28E000B; Mon,  8 Sep 2025 17:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37FC68E0001; Mon,  8 Sep 2025 17:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EF18E000B; Mon,  8 Sep 2025 17:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13B078E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:25:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B72911DD656
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:25:36 +0000 (UTC)
X-FDA: 83867364672.15.532ADA1
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0E4214000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:25:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NDrfiAib;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757366734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1fR/K77OldD29VtGR39tppnVK48Jalsfb4EWbOH9OA=;
	b=uRSGDS7iMrERVnpgRPhNoys3Ke0HD17/ABCJ+CQijOXrHkyTx3Lxq+IetSWBUIAs8E85U3
	pJzGe4T0FO2i9NGH9YXSjNUiPDeDQuFcrX96WnAKb2X/XyU8e+mCB8U2TpuePH0qnnPkBU
	6HvMRZHw9bFu2o/eVAdJSwqXxEkeoxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757366734; a=rsa-sha256;
	cv=none;
	b=pJEbpWZI8fnPYIj7Yrkvp8I7i5EGgSprVB5QrCGg0vXMl9awmAoZLWK5fzwwkJce2qivo1
	K4LKOV4hNYT1uAX4ZOlu2qXTyQJC6V+upAU+G64aUPza9aJN8JDcUg5m1nctDyDgjBSAyV
	z2SgRW2h7N303suJdgWMHKvUdBeMEG0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NDrfiAib;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b58b1b17d7so42504091cf.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 14:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1757366734; x=1757971534; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1fR/K77OldD29VtGR39tppnVK48Jalsfb4EWbOH9OA=;
        b=NDrfiAib4P0mk+j0XTgfE6A9QYESCm9SbPeSZdhcV0uTcBA/pbZ8ZGglqp5TIIefMa
         VFnY1BQdv9yx0YkzPcNVU62GD5t7sryYbndB2FomiIGlyZGSd8gK2yRbOwXZ4aPH5Xsu
         8VBIgviLYH0Xc10xxHRnZ6aYIaYeJErti7Qd3LLFd91QIgHSgunAIi0J3WzxQXyozpwH
         bk+/ARtrZHBagMb6l9Cny3L+PYdZoXxmA7LW+BONvjuZc3DtXm27l1gxvCJfwWlNoUxI
         I+s7TK6umWVMbdN5+BjQ8aCV52DTezZ30DfVg9mWbpcBD95Ob+mdrY8mNPOh0U3YVINF
         2MvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757366734; x=1757971534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1fR/K77OldD29VtGR39tppnVK48Jalsfb4EWbOH9OA=;
        b=lSSvwl5r+ZEIPTLRjarzudjnMSbUgxG9qVZtl2lBiI+sXe4zD+yq4dMJ/fGY3wZw1u
         MmJHP+QQuWiBOXufJhelcMOo55Zd3gWZl/hHQpndQDM4hmrIlcHj1hsTjxlARukKiyTX
         05GH/ZVq+aeamJI9gMKaXUzOP2e3Pk8RWFyWQLufttUbhKEVo15VAFYIH2i6fj/lcxM2
         34dPbqHCcbxNVepA0ZrMx+awqCrrpMo9e+S9IyMXJkBCMtZZt0vAFPn/6n+EKDL8VDmJ
         m+p36vDHSwKltEet37svcLEcoI0iMIGL+eSxbMn/KFeCYeYNslX0VLJgZ/NRVnwIhu71
         UjFw==
X-Forwarded-Encrypted: i=1; AJvYcCVzjStTOn/k7ylSYqVL1kzJdSZ4p/sDITy8LFWROPpkvG72vu/Oe2AzJoK7gYwtqbGuz9/d29HA7w==@kvack.org
X-Gm-Message-State: AOJu0YxqXO1oSdjP5MPrBma4mssgJPcjPI0rzhrGHUaWKBDvZsbHs0rg
	HhNSvZtyrpHkQO9gM7nc5waWnzTlpDxXjBEGBrlkeRwyI/hXIM3pfOSZQrFgOvCDWXA=
X-Gm-Gg: ASbGncvqJSo/adkKfZxlXRKXrPGTvzXJLyLIAyv/pYSow65nhAsqpnroZMGjlE0c/Iv
	I9QFYL5tv7xuVlnSs6+a7LIc41uist+A9e9Ne5x48DAURyTZbzgSnGNQe1g4ojtyHakomybYvZI
	+3VgIy0H3DhEGtaqWnt8TwY0Z4EPiZO+ZM3O/1ZwMUeBRI4B4JVzVcvMQXqUbvxKX6mLsq6Qhrb
	Yvth9wZF2B8jXriL7qcQYgQGjtdx3HGUAUa/8T4GvzoU7+JvaQf8Y0ad3pntIIufeyLZpizwWGi
	njU1tecDSLHepX2AxquGHn9GT6sdJZ9GgPRY5omzXOgVtdmBrYbu41G5r9bpHKA6SrO3fk8NbNH
	pCnmBBf7swvlkLOhUzqNf6FY9GaahcrKie51KoL38UZSAdCJn7AE8T6BlJoq2L5DMK0t+1A==
X-Google-Smtp-Source: AGHT+IHm8e6z09R+bZgKAO2X1ZRQv9LExVjZ3o4a0v6Gt9tLltiymfLjHUw7t6RFT4Iby/UqXZYdxg==
X-Received: by 2002:ac8:5a51:0:b0:4b3:4fa9:4cc3 with SMTP id d75a77b69052e-4b5f84bb21emr92920551cf.42.1757366733811;
        Mon, 08 Sep 2025 14:25:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (ip-185-104-139-70.ptr.icomera.net. [185.104.139.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b61ba871efsm740161cf.16.2025.09.08.14.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 14:25:33 -0700 (PDT)
Date: Mon, 8 Sep 2025 17:25:26 -0400
From: Gregory Price <gourry@gourry.net>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, joshua.hahnjy@gmail.com,
	ziy@nvidia.com, ying.huang@linux.alibaba.com, rakie.kim@sk.com,
	byungchul@sk.com, apopple@nvidia.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: prevent the risk of division by 0
Message-ID: <aL9Jxs3r423xhat3@gourry-fedora-PF4VCD3F>
References: <20250907160829.91628-1-chelsyratnawat2001@gmail.com>
 <aL8cjd1mIAamBzXo@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL8cjd1mIAamBzXo@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 9aoty6oj8owcssnqxkfwtgo9t31dnqsf
X-Rspamd-Queue-Id: C0E4214000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757366734-315605
X-HE-Meta: U2FsdGVkX1/tPXKvuTtKlh7LpSZ29b+6AYog3uRy3io8/LaVrsIDYc4zc9Zn1B5U7iDdav5ojQNBR2Smz0xy4RR8L4Z3JyuxVptZU2zvAGwQvCZAxkvdcorGcRbGJBlTPfiPYJANktPgaRyoE3lqgzKsGIiR26BWQoraebGcIRfJ6nKmpS47Md8IMRLuG+8+aNHKiaundceHtuPBSFWc78ej/dbA+008gnOyXXQjEyPSqQFylAo84ytD+xz4Q548aiLtG/NOro/TrwCZ/ufiD6sZ1uEGMEHoMdVvjUdCtfTy5YoFGQQp24m/rei2mWww5Y3JiyYXlxshuVRs6XBpadeswLQH9eC2eRyTbgodlSlcXTIKzc6p0jupNHkELhJY44pULTCCFRDMPPxKsTASzvMk/edmb6HHOEiiCe9xS4gj/THeLZ/CPBpABhGgDwu81oDbccypMcvFuXqbUPcAU28A+pV3L8j88jY9z8JQ3HL1U5nn3FIgT5y8DQz/MDmkJM2UKcL9W4zwfJegJ/F9Rkaa7IkxlHGuB47eXR1gw5rvM53+pG1b08QVBnwuHq7CONMhRqNayqkTCVMBV/EnhV9s+4wvv2KBbOp4asV+gHDUU6SpwUUjbSsEBOoIFX3xiMqTi+drFM/jDhZ2Csk+Rl7aSncg6INBYCPghFeN7X8cCgYFwK6h0Oogaka0MifkHZ3athlZaOK4VmSmOZkvAmWODMbW86RRbWHwCfR/FDciBY21S3Rq5sCS4lV+GH+zwldCDnq26NzMjCrIu9wXPMo6xOGVEflpAD0mXwF/FCkcklXCqztlITlwhXGbUVJ6wY/ycCPaEyBYTl3xs0sPQ0WpydfnlTTrXbPHzcTeEoA3yBZgrnrH3OKtxRKnsj3uFQvW4gqOh17A4nudyulWhG8tNItIt4tsc+I8V8+DTKKBMSGmALMwsP6JhAQC2Hlt4VM3oGDii3nMRngLGDU
 96tDc7Zu
 yn9ofRYw5diNwwrQT5GBR8mASt8IzpeSWdfG1lLkm8/GXe1TkxSK9S/+Nv+QRe3t34DmDuhnmQWFqSytRibl/3NsYvuNryUQwk0KUBVwMcillc6/qEbFqJ72qyd3U5MXixehrWi1G9y83meyYNjO0whsBgV2CoE1DXamHxjAtcU22dAXjqZV60KECY3fDOZGBb7kvWGUfP8tYG/Kjd7UWP21Dm9O2Uj3a1/8tJaF7+rDRFxPczJM06VQQO0PGOiRWs3jWIDZi4DKa96yLE/6nSuMUIYnfLBErJmX/fmB2AHnfoLm9ycwc/mjHmqsS7m09OrYrru2DJ/Dil9PDKWy72/FAKaBF+zd7HVIg2GRviL4dMjJJBKRq4haql0pDY2Mse9jvJwSLwj5375aoB41ePZXPRo/f5cUR5I6T4y4mg48yIgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:12:29PM -0400, Gregory Price wrote:
> On Sun, Sep 07, 2025 at 09:08:29AM -0700, Chelsy Ratnawat wrote:
> > If no bits are set in the policy's node mask, then nodes will be 0.
> > This patch adds a check if nodes == 0 before dividing.
> > 
> > Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> > ---
> >  mm/mempolicy.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index eb83cff7db8c..faacc604fc16 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2530,6 +2530,8 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
> >  	unsigned long total_allocated = 0;
> >  
> >  	nodes = nodes_weight(pol->nodes);
> > +	if (nodes == 0)
> > +		return 0;
> 
> 3 second look at this code would tell you the only way this can happen
> is a mempolicy where MPOL_INTERLEAVE is set and the nodemask is empty
>

after some more thought... there is actually a race condition here that
is non-obvious

in some places we take a cpusets cookie to prevent pol->nodes from ever
showing up empty while iterating over the policy nodes.

Excerpt from: alloc_pages_bulk_weighted_interleave

```
        /* read the nodes onto the stack, retry if done during rebind */
        do {
                cpuset_mems_cookie = read_mems_allowed_begin();
                nnodes = read_once_policy_nodemask(pol, &nodes);
        } while (read_mems_allowed_retry(cpuset_mems_cookie));

        /* if the nodemask has become invalid, we cannot do anything */
        if (!nnodes)
                return 0;
```

So this actually can happen - otherwise I wouldn't have bothered with
the stack read in this code chunk anyway.

So now i've argued with and against myself, i think this patch
as-written is not sufficient - and in fact there's a very subtle bug in
the normal interleave that isn't present in the weighted interleave
because we take a copy of the nodes.

So mea culpa for the snap read and response.  But could you please
take a look at the weighted interleave code and model the fix off
of that?

~Gregory

