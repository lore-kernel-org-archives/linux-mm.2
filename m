Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C814CF58CF
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581466B0010; Wed, 19 Nov 2025 13:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532666B0088; Wed, 19 Nov 2025 13:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448376B009B; Wed, 19 Nov 2025 13:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 349FF6B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:55:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D282D89825
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:55:27 +0000 (UTC)
X-FDA: 84128259894.29.931E7A5
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id F13AC100012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:55:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mN01XWqm;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763578526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edQ3lAhPLjZZSk1oSVWuvnsvYz+DEp4d1vNMqDu5ED0=;
	b=GlLV3yrVYTfXonqjBQAgQJd6g0mc3Az2QMoVfXxsoo85Mt/xxHV16O3XjTRtsXizf6IB0F
	WSGTXQUzkmK0HKrLRBGXzkIvjDMAoo03bty5F85Ad+RVvOwuZCdMJV7Tym1WNRutrhE979
	f3EZD8YPbh6YthAmHSKy8yBfdFckJII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763578526; a=rsa-sha256;
	cv=none;
	b=AvU/vef+GXHFc9B2fOvJMhNHcYbySnTC3i8Pg60xSix5u10EALAaL/FIYR2Law0MJnfMjN
	Admvj/JXDs4D0OfjAe9dB5vvjM69qG0ikCWyf7juIKy/0vuqztMGIgn+cA48+94IvB1C8n
	1hwBuXMmRV06kXGXJzqRjSNQeoutjgE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mN01XWqm;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b9387df58cso52109b3a.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763578525; x=1764183325; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edQ3lAhPLjZZSk1oSVWuvnsvYz+DEp4d1vNMqDu5ED0=;
        b=mN01XWqmWgqUT2trl+3K8TkFh1kmQnMREw7nAinEGRYlr22BnW1j0nVHTVUgrRvv8Q
         iqCtP3IZNpUaJpturnzTEQWIrtERnZ93a3j3Qb9dc6MjXr9rOQ4ezn8L5QoXtIYPL4n7
         917Vj7UOIPH12Bsx6iNwEW0HE0e4uOLC2cHDVKNeuIlwZ9S3qOxKjymSAnELOwnMYe3z
         71oTVlnFTUhoPCciKuwZoHAZfhqbmQ3lBqCp54tYfPlASh08wmGCDH7PEr23tqcjG5NU
         TVPgmDbMc4vwDUsAa5ZBIRsNJuyFgFBtj3kQnfss2ZmsKJWDC6Gdu2RbNJoFkU6cJM2h
         YHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763578525; x=1764183325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edQ3lAhPLjZZSk1oSVWuvnsvYz+DEp4d1vNMqDu5ED0=;
        b=Q7J+SLV2JZWKK4Eek/g7GRe8muvs0pSxCUdf4tf1KaaqQciFjgQWRAYkwVQAwtzyPr
         SAE6qmiSD0y0yeS/ODtWLvvuF9apyOTePz+gMpNlk+GmwJB7nwHJwng9H3VCsl537qQk
         sWdX/dL4SCPZoe/IcR2SwOoEQZDoFDPbeuNTSrFLqhWr6w9LFqcJqJtz76P+msZaHENq
         zMVOKZuf9DCWEXqJ8S6Y8SVH2q4Y2xrSF9BmK4tKClouTStiHcLbvd4bpQqYfBDs5ZXm
         qQdwmdwQvFUZR0CeTq9g0YGsylHhL2QoEtfT9VrMAAD58Xs40BJ8A+3JUCRGtO0EJJVC
         GaIg==
X-Forwarded-Encrypted: i=1; AJvYcCVYVve0f4dtzHT27+DgxqXhMOhjyigaMisOy+haKZ2gQCXvfZD7fvrrYzODvREI1lPfnAgrvE0yDg==@kvack.org
X-Gm-Message-State: AOJu0YyZ380RUULhye8LQ6uocQVLMeuPd87Z7MZULqVhbeC48C11wtdh
	SjNznvDyDkT2SR3bVxo7t1fdiGnQvzMnGVAYjvABjTZssgoITfFHwCOQ
X-Gm-Gg: ASbGncthAWfX6Uo1rxa4Q1G6I0wCxgZVAUz7MjYzarhnn7qTTRDmF7jhWy3ndMv70RX
	J6bNk2XqhnA8Y0bgs7pb8IGQZIPojfeWwSfeJBBTzV2zDmHkaDBngjB5OGqioXiz+4uKufT3czJ
	7BPQ8tXtIsm/BF/PmKvIbU8mmAAM6SE1Lze/pjNpH1a3qaKdeTAjXdti8EwcOhL2d4sWuLc5QPL
	uVtIwgYriabWvxY30UYADS/5kdMAAL2UjM+F5laYcwaDTTgOanQP57JGD8Nd9Jgzkp/2W7N0eHc
	0qZ2ePXkpDUnnz/BDU498CmHKbhxa9/BNQQ76ndpcy1AmkzwSL+fcInvbKij560Tw3t5J50R6EP
	euuhdTZjCM8UnsQHkhk+1N/WSx2IqitRBGe02SmmtDYyLUTF1YUW5s5oyhXoXD4bbsNsFiyO+NP
	TrSjRlvOXmblEWTwsrQSrSLQMaO7ISy6bWvYXn61jP+Dg=
X-Google-Smtp-Source: AGHT+IGBQeqSMvGoivhKypewRSEuuSGzQM6EQybj3ad+ID5hnktZP2Z/3EF+i6z/IdXkB6hPA0OLmA==
X-Received: by 2002:a05:7022:1e11:b0:119:e56b:c754 with SMTP id a92af1059eb24-11c9387cf19mr128055c88.25.1763578524596;
        Wed, 19 Nov 2025 10:55:24 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e3e945sm323775c88.6.2025.11.19.10.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 10:55:23 -0800 (PST)
Date: Wed, 19 Nov 2025 10:55:21 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"urezki@gmail.com" <urezki@gmail.com>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aR4SmclGax8584IJ@fedora>
References: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <aRyn7Ibaqa5rlHHx@fedora>
 <aRzPqYfXc6mtR1U9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRzPqYfXc6mtR1U9@casper.infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F13AC100012
X-Stat-Signature: 1m1t9w83mhuz95ehyk86nnmz55cspjse
X-Rspam-User: 
X-HE-Tag: 1763578525-780722
X-HE-Meta: U2FsdGVkX1/6oMMYdyTFJwwHMKpqvvNCJAXzyWmQ3IPdkA0ngarl8qMOiyvNH/eWWB7J0en8WKpJzsuzce840XrRffJjHmLkDpsvTUrm3SLwBajkgW0hnG7jP0bGAkANfcYtHXmumUpJl8dYsrzvYnrs8EapLomZK3u5eIqoLJxqODrXod+Wtp7PrvVysVVmUOnwDUlPElE4HNhkPE8ILrOzZJowpzv1+0CffXqr45oY2bWwYv3sztHYw2r4nfSvtF/yPuUWi0vlUPBTCL4QyuiKxw3UTnS04jJi+9AbsXCgFPnOgPiwTLxTkFdSBJCWupAxyp2hd9lZjBZqnvOeECaxIiYelKWyb1XHn0002u3YDnUI9WBVakgbsoapRftuNS0HFMczhqHB/Tj9IB9GxmF2knlVtwbi9vGN2yccXwgTwutJgxwgl9g15zDTXGM2GgAhALsBm3715bKsYt9U3G+ucsRzQH0YsZdo9MDiqNNjcr4LU9/Hf5Lfqk1bt5SxY6I+PIevW1bU3+rSVx2XPnB+DKi2Wh8g5gRNXR5Yun+aNOPtdtzno5X6v6r9wx8/m9h4dlReEhaJNLwwOzLOWQc8h8w1vl4Ej++Zwdv+CH0/qxE1HJdRiRPUmma5zCgLmIRsGknS1zzCiFgLl76vr5F9IuI4j+1oNb9Qwg1u8sUrNeQUv3Unw2IHUdrTqP4JwPZkFVD5UQpYmiQctYS/W3vEV/dr9BWHN/5py+RR83L/YGhr7AV4pUfu3vjvryMS9olfQY8j6I6fE6EuPvoqXJxGkaWoJiuwu2OyFPGrP5G1EuxXLeg9mBLQ/BlrKjK2lWL7gf2s6nRm3RYh9YxwqSIDPKpeXFM6W9pFcH56YvubMg9izVo0uWoeE7oH1M7HP7DdttSpm99MzD6knGxEZ4NM9AoJSWkdNi86Hg8vaeB9nCP8tKoTAuFf9b1V84zJaN+U9f+2GKLTSGR4gWn
 M9ZYCKvS
 3rQj56Im9EODULIr2nyC/G90d5Fc1EGw5rgpyEGoHdiZBLo6vzKrRS8Wmld/iNxWWv9uq3XTFHDpMUQZ7LdyvQ48LAPJThegrqLRxS+dMFUtICUZAKnKDMsJb1lAryq3ch19P6V78L9ZQrTUG3jlozMa1OwcPAcNNJ7WAQicx0Ll2xGm6AkuuScZnhCtNoTP7qCkPNR9t4ekLsvODYaJZ7qKJholaO2io68OvxUlOxnJYvXlmAqBLoSz++vxIte3Nr3HnYifziRG3fv+JhKQmPfLodQU5wlhcELE2pSJViu0tcimrKB8dJfwHJK9gjpF+VefJ7RZtf6XLBCp8+mF9LDk8Hfdkf7WRlbEtgRFWJehqymsUgFqgvfbRzepiiHApLXJXrsc/1m/B4QMH4fYglI6EP+ZSXpyVLFWLClOFNlGkJF+gV3EeNQgYoXy3BGjq7fyLwp+JH4RRfIzHpPT4pgZgaLAauUx4KaTxgPNzBMuWfe0TdWMF6EJW3yBxGJhBzPOZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:57:29PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 18, 2025 at 09:07:56AM -0800, Vishal Moola (Oracle) wrote:
> > On Tue, Nov 18, 2025 at 04:14:01PM +0000, Biju Das wrote:
> > > Hi All,
> > > 
> > > I get below warning with today's next. Can you please suggest how to fix this warning?
> > 
> > Thanks Biju. This has been fixed and will be in whenever Andrews tree
> > gets merged again.
> 
> I see:
> 
> Unexpected gfp: 0x1000000 (__GFP_NOLOCKDEP). Fixing up to gfp: 0x2dc0 (GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN). Fix your code!
> 
> I suspect __GFP_NOLOCKDEP should also be permitted by vmalloc.

As far as I can tell, theres only 1 caller of this.
Christoph started using vmalloc for this xfs call in commit
e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory").

Looks like xfs uses the flag to prevent false positives. Do
we want to continue this? If so, I'll send a patch adding the flag to
the whitelist.

