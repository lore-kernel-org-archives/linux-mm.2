Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C761CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DAB6B0088; Thu,  2 Apr 2026 02:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E3D6B0089; Thu,  2 Apr 2026 02:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D116B008A; Thu,  2 Apr 2026 02:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82A086B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:01:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B83613AFEB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:01:18 +0000 (UTC)
X-FDA: 84612568236.01.41A6D60
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 063FA160006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:01:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bV4hkm/T";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775109676; a=rsa-sha256;
	cv=pass;
	b=cIuTuQp5JyDfQhDYBSfSG3/Lc9eCOsfAzvrfB9qFa83L1tiWKqnM+PVgKGsX2GGX1AmvwN
	mWqBKAThIOBNsDfcfdMfhTwes8VIYPCaXfaYKuiageB4EAJ3e/voL8H4OryfyBTlG3HYng
	NUlua41qHumFwh3kvbzIBGcqYIDWD0U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775109676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzJtQnLHQpkaFmnuIMzVYDQD7TEcJYSFTyQLE1Uqmr0=;
	b=1mw6fDfc5m36+qRH2cR5EwqjmVi5/rjd4ImhrcMe9Sg0DbheB0FGhOaSd87pj5MuZ23Jn2
	pY0uXmqbTdCZ7QSJ8wUCA0A+dhFIF7CuT2DxGxApsHmbJVYuqoxAwr+AD1XJ7z+lbPAlMT
	+QXx6LgNyrJX/IJY1X7ETHBfCadePv8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bV4hkm/T";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-41708f6aa5fso364701fac.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 23:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775109675; cv=none;
        d=google.com; s=arc-20240605;
        b=bEgWMjzfcZHQMwK7ypKAPerdPWABuAPu7Qv1SjDB8jzKmlZctuvxPLRGgx0mWidAbP
         YSrsJ9yWUst5tkenyUJtYNozlpeRm4WN+m19+0HVhsfM86DRwueN+877GNXiZtNewqrU
         JysKMPTnB+icDISI0T3W2pnamakJaF4D/ecbP7xpP2ONK93s5jpqGILQMQMIxYRIJCIe
         HzN6sHblYEBXiHbHT8svQyA6r+Kb6E/LM8imdc76uroI0F37OMJpLwjXq5yEz+QRCsuZ
         Nao+tPWBn8Z8LNp73Wiyu5YonQdzB2/E4lZQSgyRbMH2S/4gaV+OuTNHcDMa1vYQyIrD
         t61w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JzJtQnLHQpkaFmnuIMzVYDQD7TEcJYSFTyQLE1Uqmr0=;
        fh=z1VpRNg12jzuClUP9gf3jLMHcHGQHUv3hmno4dTLC44=;
        b=eVBJNp7cRDy2z+6prDmxhSKC0ruChEGhbuVQoO2BWgNQlNOjJ2g46NqlN+/KMfjIht
         lkILChmrGodzGcpm8fHMx2FjoAaSVd0jhBnI/ZQvp2mXUjPIu6cREjuGPor8mP9eY4zr
         entA59YK9HamKsW2WK2RHAJObtqFbt+/wOWl/jg1Y9aW/BLf4CfJJ9JyC4lcXYbOJkOu
         DYycnxOww64eGOAOjM4IYUVU26yICSl5Hcs6RqPzIXuoosfB6FVfNSd9YId5KIw8qNYn
         A9fwdeQZkMUFxqfTFA/bPgCFPd8BZERV+OElZb2Tw9sY+3JomWK3bRAwKLvhWPXgpCNp
         /i3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775109675; x=1775714475; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JzJtQnLHQpkaFmnuIMzVYDQD7TEcJYSFTyQLE1Uqmr0=;
        b=bV4hkm/T95vzLy2igHa2MmpdXWLMWNURU2TIbzpjSthdfnfHoVbvZ2UbdmqA27Qv0X
         yYv2DLmseCYkVOBckYsPj9xekBsO+XEVTpO5cvf155hW4CikRrtd9CsHVbnjgPyjDVk5
         gH0Zxl2crp2apgmo7cMq0Ws3+V8YIJxJ2fliOM/Kg3sPpzFZUOXBSxtv4b2ay7hMzkMU
         rhkAhL40d/MeLufW7SCaDues2fwcEamHpcxQ8JUSTCFnQ8LQJyHN7QggNEgHDA69Hxlx
         tp+u6bwJHERJy92XgFQIZZO+lhEybQcksEaZK5SA75s+3y3nOwbcrpP4E9un8Hqn/Dzn
         Iw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775109675; x=1775714475;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzJtQnLHQpkaFmnuIMzVYDQD7TEcJYSFTyQLE1Uqmr0=;
        b=tM7M5xWD4bY+fgB7wJo3JRlHjnYW5ZRwc6kbUNehklGOh/ftm4Q/+paYbTfgMqwCQ1
         ClV698ytJpoK57CUiJ5KVzPFGy4gFnegQ5eIME0rSdKs5jtN2BxPg5vZXEE6o9mGoeQ9
         emg6W8WV9+10A5fV2cZL3yoCHcLqmAtNOCA69oxqEBikmlsZ8TnDVn4fwQ6K6m+lMIRm
         hhg9/3kgAEoh9Lv8hsT4mrvyer1wm2SqYfdKXg2ngbfDMzYvMBmu5wIg3wUKMN7sHWRz
         L0PM8KbsW96Wi5flZVMOlojbXBayiKkGWTIO38nRTQMMJtFa/urN4CYjbibHwwa5YwgD
         RDNw==
X-Forwarded-Encrypted: i=1; AJvYcCWilY/1932pLBC902MJ8C3Ua0/2n35tkG8HJCItdFzdOeOm1807zWiX7yqQ7t/7JvH7IHYkz7zaMw==@kvack.org
X-Gm-Message-State: AOJu0YzbNk43kBfBxKC6S1DZ+rTH3EoHyN9hZ3a7ZIrjc+wzIMyR9TKW
	qfMkkuqreF963l3opoSkCZq+d97VIL4HIlLFvNtOQfCUk9Wrd7EhC0qTYcPeYRlI9oQUMZibJY6
	jQ0MdZ7NfMzZ+x2Uohs4eZFZkAFv2luBQSj+OE2OV+Q==
X-Gm-Gg: ATEYQzz+WCkn1J1ds7rKOk2Hcu9QtvxviIqR4G3MnnhVtClCfNw0i77eFBPwU18ewdl
	vpX+cow9LB/SXsPqDcKnSX1Xd0nPggwqBPJWzZo5DX/Ibq5U2Js1vgz7V5csKhwKutc9r6gLgdF
	PiaxKbVnzIZ5zFyEDq/j137BiEKs54JjIpRSfRwONjMxro4DZgSHs3IJ8G/Ze6847lS3VrlYb2C
	fen41vDqwwDHyNPPKltOJF2EMuOUtWwvQ+ma8BWGm5VE0lJdew6JbBBee8YLOQCgt8p6Wzy3F05
	wdWzPu/KLldldnj+22fHu30yLo2QdGBNf0EYXQ==
X-Received: by 2002:a05:6870:658b:b0:417:548d:67c2 with SMTP id
 586e51a60fabf-422ec9aec58mr1440972fac.44.1775109674865; Wed, 01 Apr 2026
 23:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <20260401074753.238053-1-devnexen@gmail.com>
 <ac3sa2GB79LGADpY@casper.infradead.org>
In-Reply-To: <ac3sa2GB79LGADpY@casper.infradead.org>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 2 Apr 2026 07:01:02 +0100
X-Gm-Features: AQROBzBYHYs_onPvLCFlzCg1BeG3F44rOL2eCnr17RSP-4npYYAdMvyZYiz8pUg
Message-ID: <CA+XhMqxvg7KuAn1_+9XtQex-JVwbJvxfA4MhbCKvF1ewRQDv=Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 063FA160006
X-Stat-Signature: 4tiec4nrocorrrhjm6ronk8b3ueo38yy
X-HE-Tag: 1775109675-126767
X-HE-Meta: U2FsdGVkX1+LjPO7IqyvDkWHQN7VIc4iF0ahFnyrzd1uU2XU83dnUu8AILr6tHs9u8N+zm9MgoiQaoraIj2e7E2WWYagZfB7TalnaVnmV/YRX+SnFbSD0A4uIlEbNrNHFgfOZ+9JZpSArXClqp4jeFstp4EUF3lm2G97jfo78WCkV6/x8JHBt/J6oMGNmTVbhPgsyqBTV+nKgXjeLnlYwZMd5z2oGwYjhU4eD1Dt7FJo47TtH9m5enTno7GQS3xwB4TgPkXSE1cItklLLyrbI9GBfndv3kP75/CCWKGfFOuXaGFLumZMR0B7nihV45nIYuqtxN8aGzydZQbis9kRpKZfIjrIpBFFP7aHz5PZnhBECEWFEMHHH9HXtlDKuGGH0Xafot3D4jqVHLIr4IsOqjF9ofpXDIsuueVqsK3T25CBWy0HtSiriApNtuCTw/YabYre6PJ1neiE5cIpZZaARucu6q/4KMXVgO+L7ef5qRt8duUhznzYQZQoR7JYuqKawG2qbnwDfFioG/cybUx7EYjJyNabOScypF1DogdyV6ZpcL8nEvtbQmcnILr4P2IvQd4ecpXDcxTY8/PqlUM3Qpv3R4Nm0Se4v4KlRReBF/0SXgaILZPxqGe5fQSQRLA4IeN23FjQ4p3BYF1PkFtXlG40c6fVVfLpM8kLbZXai+Aps0fo9LbzOzACvb+TqTX9veNzD4OwOAO5Aa8desyktX59A6xujqj9DtPfIS+tNUL0ozods4DTLfuuDyZKb2YwWF34nbDc5g2k9Fyp3iKYjPDTqlYJ/OdU4uVx2vF8XhR4aqGTErFDZzDIwQYjdQjX4zXZ9AlzRbX1KwDaUqU6PBQLxLs+VvUki180Yd1/8EvEFQOdyR2+h0tvjQvMMpI7K3p45NO5o/3o42yv7bcdZSadZ6rh0jmYi0/0mUh0kXx/pLs3bpWkADWLIILD55coOHM/uXYDfvssOjLT3dh
 gEB5gAGG
 wVOAGfsPU4k04IPPeebwn1+cQP3vkJSnj/7iTnMQnsBpTQ/DcHWhrSx9PY+bhO/kekhgbY59O5QUFCyyfnAWYJyycqTYX/JGAb8WTsR5sQwr7XNJuWaVoxfCVGMAtXu5JF3sojB7vYooN+RelxKkqmb1YtaDO+mJkDhfgjnBNMMrIe0NKwJGrVvDc8Sw8lUixhnuXQCjfBVwZggg+0D8mmiErIgyB70RJfT9KJXQY0j+yT8Ci8nm41gkyp53UUGLx3pycxcLcnbaxW955OWjvIB+tq+orFBOKnpSDDjuwyJmKYL/enft8JeNZIXB5Y61tVeeH2mKqusmfniwNBXptlKX+zOAuMQh6+KadQqyAh9YVHbxfCGcZSTLwVb0sH8nKRYL9EQZ0bnZvtN7e27VT3eWl80LgH+JoMPEvR9t80TjWRtGhwhPQaoG3+kWhO3kKdD7uqfGeo/TdK83DZydHte1WDcOtl3eSulRhyXgHsDJ8IClpprCX0fA8nz38k0z6MMgVdVc9SeR3nFigU8ThnCoNLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sure, will send as a follow-up patch.

Cheers.

On Thu, 2 Apr 2026 at 05:11, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Apr 01, 2026 at 08:47:53AM +0100, David Carlier wrote:
> > sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> > but sio->pages tracks the number of bvec entries (folios), not base
> > pages.
>
> Since you're messing with this file anyway, do you want to submit a
> third patch to rename swap_iocb->pages to ->bvecs?

