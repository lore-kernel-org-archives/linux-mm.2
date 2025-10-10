Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC61DCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 07:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446E98E000C; Fri, 10 Oct 2025 03:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9DB8E0002; Fri, 10 Oct 2025 03:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297638E000C; Fri, 10 Oct 2025 03:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126AD8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:47:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BE82139AC0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:47:58 +0000 (UTC)
X-FDA: 83981425836.01.323F67E
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id B83051C0006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:47:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TaZCjIjo;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760082476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7tgKV3i4gBxvB8UJSlpuDPvU/XCbTanFqWCRDwu8uk=;
	b=7EE/spH7h4zL2Ovvseb1D9Cf8wug7ZC/C+6w3mt1UB9sspAbRme+/dMXXMiCnHbGPSK21Q
	HTfLZUNyJlv9VGraBIHQH5BPVa/qo6L9HK0WEZKzj+WI5zthI8Z6jPbuKeD898LxAOLmcz
	oPOVk4T91Ma0jzn7Gtj8unPvSZT8xYo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TaZCjIjo;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760082476; a=rsa-sha256;
	cv=none;
	b=u/yMZRBxRLKJZjBXtlH/tsPJ93fUYKIaB2tnPEqoJay/GvVKHIq6SU/bg/CszrCp6xYgvF
	QZGgWk8MzPNom9sk1myfexPvxt4H3RUVmyaX9MNfINcpt6SA2Spk0qN3s0VH4e5ih+HShC
	yde5+qkd6AkBTsk219vGv1/XrvmcuM4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2697051902fso2765515ad.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760082475; x=1760687275; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7tgKV3i4gBxvB8UJSlpuDPvU/XCbTanFqWCRDwu8uk=;
        b=TaZCjIjo1SUITQ3/vKCpLO1gIgsOOUsqAhB0EZkHGaF8K3W5kUc6yHpgJW0aF0TMl+
         5Ex8rrZ2GtrwMVD/xJh/Zos172AVfUM8YvM4/DubzFj3TPVzWJuEBPXIV1xieV29VvNm
         Exiq9iAj1MDBubTtkjuVyCro4esqMtQJ0oHFyTNMp4UMLF/cSo4NaEAOfXyY9plH03Zs
         iG8wfZQNyINml7eKbxfAGUGFQkdi1Z2B/0C5NSz5ULFOY4k621wFC9VdnIVGM7MHJC5C
         l33rKUYI0EhhO3a64NgcXufUKOur/GgZohYhttjoAReen8q8jWYayruJQ5+aQt0RrrqQ
         u9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760082475; x=1760687275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k7tgKV3i4gBxvB8UJSlpuDPvU/XCbTanFqWCRDwu8uk=;
        b=GzIwJ7xZ6cLINiLleaUOEDjz4MCo91/AVmqUYRNMfZ8Qmuc4t1usAhRUyUFjkF5/TI
         GQGpivIb/UupNhzOQNAA50CRmdSS+EA0jdeArfTtM9T/pZyqck6Xg9895Brvi9QKr2M5
         8gjVCdkhYQBwzWmBf2uLxrzY6M0UE7qFZSDdZAVwvchcH0o5n8a+w0v3VSTKZPIKB8Ln
         o36JRPXN0bA1beu7lyLR0wl57QKl/qqYBN56yNuOMzPCn4vyRvx8CbLqMgEscmKVKiwj
         DicI80E6YsuajJlX/P9Ev3HaSR7BqGBw84OHqpNsZQHkw6dX6+SEPzsHMqELGQv3r8No
         VCmw==
X-Forwarded-Encrypted: i=1; AJvYcCVaOgw+8SnHMzKv5K8XByOn7gO1YJGA37wjhPtoHuBXh2oX+hENn/l2p6ktIZxR1mfrjw7lPcUVYw==@kvack.org
X-Gm-Message-State: AOJu0YzrgbF5U2xeHvTVgNu/reW1QRdmj8ADdc0U3K93M4Z2O7Sju/Q7
	Z/JA90Z9LBcyMZUr7l8ROAd6B19rVOebx0mUSixdczAIbgtP5X9GGE+uv0uebeokoG918wrkTG8
	tdngF8+G61dnN6ls4Ikz9uFajgg54jSo=
X-Gm-Gg: ASbGncto4hJugg58uvej9TZOdaHNOHK9CDR5qNIqml4XNz9pf83BaupOkPpw/+62Cr3
	dQilFhL61gWg4SSiBJ5ACnlObvFrOK6EDas/yYrcuOBqqgIR9+UKqWJWy/fj5sZX/NG9V0CojxP
	OI6OYisuEcM5ic8Tsu8pSrsPaO+UKWkBJX4YBVBksR+//SD6aVTeQChLTYA4CGnTRdjXWTfZ6qG
	bC3wmZ4nhdsaiNBAle9/kfUxM5bp2dnkB/C8i5yq0/X9q3cMxOXY0zoL26jy48YPU6+qVk4MCE+
	QKBJFR/bLgIfSLHDjg4kjFA5ky9ipplmz8O1VlgSUgGh
X-Google-Smtp-Source: AGHT+IF+PAy5+0R9xjwAdCX870LznTDZ75a10wuLP3ZbEbiT5C6LExmHWXb24zDjqzKozZ/dOKHCNkmycyxUZF7jcyI=
X-Received: by 2002:a17:902:d2ca:b0:288:8c30:f08c with SMTP id
 d9443c01a7336-2902723c5f1mr82403495ad.2.1760082475519; Fri, 10 Oct 2025
 00:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
 <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com> <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
In-Reply-To: <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Oct 2025 09:47:43 +0200
X-Gm-Features: AS18NWCk8eQuqVKsTgaADHERDP4d4Ljx9EM9bs-HZednvRDMU1KzwVAaxbIbeeQ
Message-ID: <CANiq72=bMmDdVMgTAtThciUNQND4cqW42+Udzk6s_X7XZZZpVw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B83051C0006
X-Stat-Signature: hkoaradgaioqxfzrnxtfcb6db81wg7zs
X-Rspam-User: 
X-HE-Tag: 1760082476-853978
X-HE-Meta: U2FsdGVkX1+ucShtrpE3bDUqVlgGJCFE32J72v2AZsPvZ/eNUW8DSbagyXe+Pff20QhCFshYDK/W23EE7ivv7XooWXrjrnmAFpBgFnjgeWCR0eU2LeABXyUlIh8n5OmbnPaOBaf93s7OOmN21hz1M7jL7PNQCpOwVFcemfhH7hQTryDrVusm1pXphvzU3aL6UbgIf73eOee2wF2iyjqy/CNpygAqKJ8HsIpZBoRvlkZtwp8AVe//y0ukuaDDz36110d2LQ2hvjOIqQwMcIzYKT0qCM0wtXagWOldNVaWxrkRmwZ2FBiXpqIYZO1nT/2b5nAjDZ57mM+i5kwLmNxUwGcA3UcB/8PfS6c5qKITQlSOV9/xsVzCnN17yE5ktfOwgP3fWKoH0d/ELhz/GRqZQmq9Bl2U9rarARVxkGQ4a/Ofi8jUmzLScA0QGPbMaLGwAIwgsVbJA0xrfPojCFwqBFTb45htajAHdKL+BHOhWzMcNZozVPQr0cPe92LBSTJpyjVqRcitjzNzgq0NplXo5yGd718uNDyjvLBALmqw3ZFMWAJwGYPkQ8TG02rauFWHKWPhLuv1kIcjX28JTgtmLbSh2alaUTaQ5y11MsJcYLIqVwT8wqcW7nqnh6BX02eXrKqn3Au5GsuG4c8W/VbVqx59S2vvOUsHOH/LGBRjC+y2pPpD7/dr4LbrvqC0l7RmAnz/w+s0NQNqFmjc8r9s0Crs7UWWpPlUc+hQN3QduprKk/1lzXgctaRDtpKkd3JCowErwW4ilTU1DATXkansdLrlZdyge6T3atl5K/xdUpshAfNCSR1n1Cdgq5PToUpbnKqK+mwEBtUYxRq8JiCokvp9fjEziEodygF8yZ8HDNFzzEq5+SQWEcNDVDzvtCPeTwFXklpJXflBreerc7Afyi131jm4FmR8ezLxQTxQhiZeCZ4ZvzFoXrxSwIOY6tyUIZt4yT8aDw18Mj4flDZ
 +4spyXZ8
 Hb0DByvmrRp5+ihH1xaOJZY5dgePTfhwsYV8AMECxLu7u1L1i76kPoANbPUH/l4C7ZSCKi6J+MQtMf5SffqyasT+FVnN9KDhwlat+aT+hufKQMyfP0HhsZNNapspljLLIunM7a+gxUsDTNUSGBa3/Ua/RI7Huz3MByLjHm21Bg6SIjFH6gT1rXJa7l+Grw2U3xGSCyd5jkE85GsVxEezolO3IYxDFliqztF3/o6tKB1QwL7ZwyLUAZ9x8C8glPomabQfMzlLxVJbxh3UmbnhzQaMenl+LVWgtehnCeRYWVD8ATM0wH9Ofrp97LPjihqxJt+eCmm8ljq+dXF5d8wdiHJW/xChf1U/FQH4+eePTU+zw/LRQDP9ypPDuJ0xBDuh62JLuI1RcJYgi+6sqcvwRCn5Jk2U1ys0xw3d+vZBxAeArHT0iYqPV4UJ0zT5i+LuWK5yHA2Zl14TyTcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 8:59=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> The best would be to use C23-like `enum : unsigned long { ... }`, but
> sadly we don't have a recent enough GCC as a minimum in the kernel
> (GCC 13).

The `mode` attribute also influences the `enum` constants -- doing
something like:

    enum { ... } __mode(pointer);

will make `VM_MERGEABLE` either `long` or `unsigned long` depending on
the compiler and version.

So with:

    #ifdef __clang__
        #define __unsigned_long_enum : unsigned long
    #else
        #define __unsigned_long_enum __mode(pointer)
    #endif

And then using it like:

    enum __unsigned_long_enum { ... };

I can get quite close: old GCC will use `int` for smaller constants
and `unsigned long` for the bigger ones, and everything else (new GCC
and all Clangs) will use `unsigned long` for everything.

Perhaps this may be useful on its own for C in some cases.

Cheers,
Miguel

