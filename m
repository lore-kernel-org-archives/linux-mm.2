Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E39CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025396B0093; Wed,  3 Jun 2026 05:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F182A6B0095; Wed,  3 Jun 2026 05:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D8F6B0096; Wed,  3 Jun 2026 05:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D088B6B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:57:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8158E1A029D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:57:26 +0000 (UTC)
X-FDA: 84838148892.29.A78546A
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7CEC91C0008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:57:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=EzFDaVZw;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.170 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
	b=XFlVZr8wHQgysUak99oq1kQbr1Uy4qfkEZvaO3s98AwElbMUe8AsKULWAK2BCN/yXrJ0Ik
	KEb2g9HZ/9SsaeysOxV+6nkrDhnDqvitbmXSoW1S2a770JHcYFvSljt2vAy/03kj9d0RDF
	yQyEFZRN0frjYZDRRyGPe2wB3atXFU4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=EzFDaVZw;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.170 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780480644;
	b=Avd/kEQ3HFzhbLOPEJJGk1POGKUCXFloHq8OWYH053bBCDHe5yBoI74O+qoaGRbc0nZyOG
	IyVUpTD6p8NYj6r4qDUu3K4b9VRjXfjbo52rG/+ppq/UM3x8J2TWPVOcxbZQinBiKM6mCX
	Ok0tOEHLJ1nHDH/YvQBabKHZmoEpHB4=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-914bfa75911so57184085a.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 02:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780480643; cv=none;
        d=google.com; s=arc-20240605;
        b=JBUCG0sIzYoY9cubvPuhgEQIshNe4jV1U2mApC8J/VvqqlayNEu/tM+c32aTPbN0KQ
         rm1rk5A+T/aN698tugm0haE0eR2TT0VXaTRI88gf6tPhfVHY8Mr/w9jaUcfPQaEuHqrf
         NDXKEtDCS9FI5BXd8cKjA/f+SZ+d7vHFS9kKP5x16Fb8Ayh/v7nzC6bJnCWO3mN5Nukt
         W4v7Gb7WxpcyVAF8flvh+SPMYpKs4lc9UsOjgJxRG7Tutgw21a6xwHsXmvhAt2lQgSDp
         T6+24n2nskog69Xa4lgWbzJjpPpK0NZAz5ErMnaxOA4OxeuMn4vV8PuKQmUzZso/rErg
         UHKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        fh=UbOQ1WLRWuKeQxk75KHaguS77M0276T7siADj9+l6jU=;
        b=jNvfNRfGJRxrU/2z30DmqkQraPi20FJqfrqRE7vcJhVBepkTZ7Z+aiypUJ0nPEqsGO
         M0qpuwKEGbjhdGXJoICio9QwiVPekoHrGMg74Tn9QwCif8JEbc2IZN6/nGSuIr1OmGPQ
         SQaJAVeCEHecbYOvw3v2O0x1+EY5hUMM7tYH2nC07Qoyrs+YAsdeWrHTGx4fbzLEHRl1
         uGkZ8IAchfZJlPxiOpFsj1ov9Bq9xFIyPoQjWtLs01rkNDHsAA1dfUtZBd46AiIo6cFR
         lBqx4icsvdrpIYeVHFQhZUvnJkr8bvIWJvz/lrBWsRwFXlt1iaTMroG8Tmmx00zCc4ve
         ZWRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1780480643; x=1781085443; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        b=EzFDaVZwEX8C0eYV8B5vtnbCLmE/D1pFEyxvAZqeOU1bgTu18kG3bqzYID4bzTRZFz
         hcu1yoUWvRHg/fhB39TAkfwcZtf++4tebgJzt9niTXqFt+5mXU2H4Kds+8lznQ+AoJ9x
         jjPB3THI/OXRdMB2W06ri4Xegp44WR+OKBtrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780480643; x=1781085443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        b=LaqmrSof8NXXKSYL8CfXinUjNUOdNdQZ0iz3q+lZH6ISm648ef/9DwUWyKPAp75Eud
         kGzBXnYXEYHctEqBKTV77B65WSePD/qDZ9EcMARX8BvHxZhyBpvbokNB6RBIZmKCyLT9
         BIGp+ukiO97UQbSa+upZh3bsMG6taNeaE98lBmxC+ngn8qq/raJBWOgAIl4BZwR6q6ea
         4Q4ffCHn7k96nDwPLX+DIhwZMDoEJrkQZX8tIVZ9XHcUfRNtpdNrypHXOTKPTAZG79G0
         frLY9ZuVhznEfEnFh4wxOAwAnGaUd121YHMv5u2s0NrddG3K2grFxgT4TbRnlTwHzhvA
         kt9A==
X-Forwarded-Encrypted: i=1; AFNElJ+Ma0kRTtSMftgSSMXgfjMchlWQ0xgHX4X1sZdh0wVUQh567NH4BtJoQ8id8Wh6Ti+C/E2uaZB7CQ==@kvack.org
X-Gm-Message-State: AOJu0YzbWTa8oXFjkZi2T6FWNe3kY7KT1CY9g5HkhXoBKu5mclITLpd9
	x03bZvrLvR/7QbRKa5yKVj6gW2NUGR3CTzO+7roFgPaVwRDeeEwEC3VyL+ogmHNgF3niVdB1CiD
	UgFSn3ccB8JzUBroop+GnIYJmp2KBtejbVmuQHgX4iw==
X-Gm-Gg: Acq92OHu0PLncq05ggMHKq3omRcozQj4X+xw22GYPKOcCHYoZEeGkydUcFLIk1pxAYm
	Ijs8KCYekmYFj39dDMgQDhkyT6elK+ij8yJxOLQ/QI+1FTfFuCWqg0r8OvZrzkwJb5/t1g2fhaf
	eo3xXFHdRKjOgvGWSIZDQHeM8IL7suajxSU+Ng18Jx8bfAq6pyur2+ZdbxgSZfqRZf57lnX9AoV
	bUKt96dZ1Ctp599BK5M/LY9Ce659+0dELdP/FQ17n03PCBXibTg8Iivd1IpPowYPwl+/dOG/Cos
	7OhwvfbAh4RiZNd6O6xt/dSMjvbWuPzM1lOioit3QRAWJQqcJX9gYhCOkA==
X-Received: by 2002:a05:620a:31a8:b0:915:422c:a0 with SMTP id
 af79cd13be357-9158b6e2074mr292177985a.22.1780480643420; Wed, 03 Jun 2026
 02:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com> <20260601173325.GH2636677@ZenIV>
In-Reply-To: <20260601173325.GH2636677@ZenIV>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 3 Jun 2026 11:57:11 +0200
X-Gm-Features: AVHnY4IqQCqMS4qklUMIqRUT1Fpv-SuCQDkhxYBkM9m1uTwHwBhUln17rZFWNU4
Message-ID: <CAJfpegtH-E79D-3UL=pPv-QqJk6C4ODXLLZSAjzQJwSSeqqS-A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Joanne Koong <joannelkoong@gmail.com>, fuse-devel <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CEC91C0008
X-Stat-Signature: ggzio38tawbn7pk9jyntprxadmn1ipxt
X-Rspam-User: 
X-HE-Tag: 1780480644-395041
X-HE-Meta: U2FsdGVkX199f1ogMNHpj4oUowBnAq5etmn4nVDPIXZISMyWCTYBnkKLnntk3URPLlfIubP9DEPDdb31XpgpGrgOrLNn2oRSn0xFRgOIo+ky/ucCsKmw4nbbsfCb+NPUHIkv71xzK8AYA1jOipRdsqfZzmZu0rdjUzzK/ByA3RI66w1brgU7ubHrQrePQ2TeT526MQ6hLZwoY11b3q0tUR6vgTQuMqMmRABLa5MssMn9qEXnRHN/QuF6asyHaWaLBtX+JW8VbhPY68cA5wcIYee96yehVn70aPJ34Z9D7d6VKHWglX+7vPpEY5YGV7M0jAVbGrL4S8Tt/rLcT+/LbaaqdBkrGpfifgemwcKVTxHZLqxxWateTqWTtJtHyJz47YyomLDXHLVmmweFdmjueWL1vjCYFoCltRh6lS2rmAcT1O4g94Kzgl+TdmBg/n4nWf3ivj2aAk06Ze/Q2zv/ECqPf49XGXUTyisfi9S2PrFXpJLnti8vT/3tQXXNIdhd28UYZ4gp1De18xz8Vi398Mnumbt+k+wXP6vtT+H23VNDXt7yGwAO79VxNMqCQbEqrv8cL/A+r985LV2AyjX8CFoocMfKzTP07FyJH07jTufgFXlQsHhJTiE45fQYe/DmoevzSU8SWzbdcJzoiXKzh413aqmCzIm0QfLoYyijR4owSruemE8Cg4b8w/Wnk7H/Aqc/hvQB1Wy0XSF1TuJx7sjH2QFSML0m7M2GpQ8tM2dJDY9O/XCgs6J1mAcPCRdb5AxRj8FO4XI3B4pJSoajKjIyilE5+L8aQT/vPZ5T+jb3AAWfZbx9ehoos0LNJeCsG7v7kDWU7jvIOUf4RG8rTbTTJYDa/Woiog4DMmIHna5AUQqiy4gc7SHPsIAKLjdY+C4SXNBrchHovqJDF0h2rMGZVCKSD+2HHxrc8WxO1dDvrOzSA1+2WVrDxhytVCHFqTP7ZmTKKR4LvuIBMRi
 4lf1i5HJ
 lT74QEqpkdIWmsM6eZnOzTNudmvaBA8J/3hb/Mdd6lJWQ1DCodp6+5TbpwqKaP1fEIfYBRH/c57Ybwm7dvHndZj/ppv7rrAYxOZNMuatF7FEsmfOzImBbfdeBq7kunLxwftAjD9Tz6UvD9We6DS+Ry9ixVIvisqieTEtzcqV0AXet8NzhJul4JG2BXNeOAZk2LqXpVD+T6Rx5Z0Q1bSNdTXFAlBXHsr87dLgBz1mlTN8tc30om/MS0pHMIMjrMF/KFn+k+50wdybTvKfmM9YueLHBEvjWsxWQ3JugHzIxwnBVW4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 at 19:33, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
>
> > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > a big simplification.
>
> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> Communications between the kernel and fuse server at least used to
> seriously want that, so that would be one place to look for unhappy
> userland...
>
> splice-related logics in fs/fuse/dev.c is interesting; another place
> like this is kernel/trace/, but I'm less familiar with that one.

[Cc: Joanne, fuse-devel]

I'd favor simplification, but care is needed to not regress performance.

Joanne might be in a better position to say something about relative
performance of various transport modes in fuse.

Thanks,
Miklos

