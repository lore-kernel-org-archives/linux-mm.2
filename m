Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E2FCFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8D16B002F; Thu, 20 Nov 2025 13:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7598A6B0032; Thu, 20 Nov 2025 13:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6210F6B0062; Thu, 20 Nov 2025 13:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1756B002F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:58:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91EDE583E1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:58:35 +0000 (UTC)
X-FDA: 84131896590.19.9C2C081
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7AC2180012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:58:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DyBMzz0W;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763665113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sDTWVNvW4C5xaLY9psncbmGhuM5OmHa6L+fKPOtsIs=;
	b=QeK8hUh5RrH0UiuXBxghboDGuBhQTVhPkEUcoxH53OrFh7we2FQiBwNq0IDvcYpiZ7gsqf
	Ybt+EFNjsnqL39qEifRLKPojQKpDXx39jzwQYXVN/Lfj5vTNDp6gcGyRZzrNfwZJwlD0Ya
	nY9DOHsb8KIJuc9dQt2fFsyKaNqBLgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763665113; a=rsa-sha256;
	cv=none;
	b=gYlfeokd1sXN6CDRA12/v0F+WKdgzBn0492dW1GHJ4F+dsG6BqdYt7On6R9fpmvIVTLTwJ
	FYfwsdqH7n/gof/9XLmGH6sU46YE6UksirI3wzwMkGc/4w9l1sctGgrvi4YEPkalvSByLv
	AOj1qrg1eH+ClXVVxHtFYXJJ0ojr6h8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DyBMzz0W;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7355f6ef12so269397766b.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763665112; x=1764269912; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9sDTWVNvW4C5xaLY9psncbmGhuM5OmHa6L+fKPOtsIs=;
        b=DyBMzz0WrQ2VWDflprihGjWccTmb7uCLMAi9SZ1EgSO2zIzYPq9QVxkWfCF1jhwSTd
         tEVk6V2LmgFVDpD/TUl7mqSUmw9Nyrvc/tbhKjh5CIFsPlyUIKUT1nkreKB6lwTpiPoR
         quJBHbaZZJvzaNJ37+KXOFyWPNQX/c1MFmrrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763665112; x=1764269912;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sDTWVNvW4C5xaLY9psncbmGhuM5OmHa6L+fKPOtsIs=;
        b=QGrdwIqSLC6mpK7SI8G3bm15T7bphbt7rnQlxcs2sWDIahwTLflzgXI48KomnKO9vl
         OBtySWiu1pGl0PtBnIwAL+xao/jWUm4/E9W3sg9BAM2Tu8yKl/yxPQftzqqP1fsb9uMh
         Y2bQ/WtmpQkxMDCjfNKA3+thVKLobsh2zIDy2/b0/uxXCCbjiYuss8C7MVGL054QXUdS
         RI2S/gXrr/2lCwH/oTU66/uzkiqAsWyVl4qzS9Oq4rVvA4+3JYS/s6tblvBHLhMBwF/N
         luLAurBA3KWfUkHv6YzKCk/yJ8ynwqS/1fx27SzPuS0KDpUo9bcJun7nqswthRwGsYt5
         sBPw==
X-Forwarded-Encrypted: i=1; AJvYcCWpa/NOG/UHp6O3Hz9BCa3wAeNHlCa96JhE1oYVBmFL+53CW+g2mbQMQEvZHDk6XbjVTv9CrcZLJg==@kvack.org
X-Gm-Message-State: AOJu0Yy29IhhAOhTIy53pJoegU2D7EJdkO3xNtr3XbJes8nKBarMIs1b
	eZ5oji/QBKeclOhCF4mA1bX5uJn7gKuevNAJUvU+rVBfSGfumLAtHbYugVATrT1Ne/FNcDuP4ao
	7l8QmeRg52Q==
X-Gm-Gg: ASbGncu3SbFVfAaMnSRkphYRzeidnXIBexbJ4zNB+HW4EwicIbgpKeLAnXDBrlP2G9z
	I8hbwHD8ukg4cDauQmx2P+f+FtJZQnFRVETn1V/L7ZpWAV14wMD4mwzqdWyRzqJA+7qypeN6RIG
	TPHA20f7vpGkbH/6nF/J0shbXn32XpHm7n8xoFRvlQMHCSk9t4jund/KWfaHNxPdrY5qUk2wT2q
	JCSlBwToJyjZJws/8r3p/Cv15oJDwHOlgd8QMPorpBgiKvWzdxwuHvFiTzETCM/8i6vyn1u8yRP
	YggRCEd4Rf8wtG10+GpVrEYutCkYaaOOBWCVRfcSjpbvjsBo1yspc62q93lcYRQqpJf6VdbInTK
	jpgrZSIPVPmEe/OVUr8IEMal64loLqxRtdbvO9iv/gFj9n8vpOe8R78/3Ycv5xvaPmHk8iR8Scz
	5CFF8SDFsE21MkjcyJ2VzVHBE4q23zA4Y1yHkNx0qgtyih0c3hjtybvo2tVUEq
X-Google-Smtp-Source: AGHT+IG8uMN8eHel0/N0l16as7aOBbKdUBSaAe2sLC3CwlvPylAbBg//kaalquDB00neJcOb1u7vKg==
X-Received: by 2002:a17:907:7f0a:b0:b6d:4f1d:8c9b with SMTP id a640c23a62f3a-b7654eb12ffmr472256766b.28.1763665111778;
        Thu, 20 Nov 2025 10:58:31 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd4e51sm267862566b.42.2025.11.20.10.58.31
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 10:58:31 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b737cd03d46so180828766b.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:58:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVY/XuVCo19IxtRQCWrXaE3n4WoHj5xd3v2r73V8L9rj0xtgMrDWKz1BRxb/RCoN5Q6VNBkw3CPcw==@kvack.org
X-Received: by 2002:a17:907:3e88:b0:b72:5e2c:9e97 with SMTP id
 a640c23a62f3a-b7654eb7855mr481937666b.36.1763665110822; Thu, 20 Nov 2025
 10:58:30 -0800 (PST)
MIME-Version: 1.0
References: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
In-Reply-To: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Nov 2025 10:58:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
X-Gm-Features: AWmQ_bnXRJB7OGnPui1Z4ccG7blx19W2ApcIFrrcmWTiLhd4AWJeKZTq1fmdnl4
Message-ID: <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
Subject: Re: [GIT PULL] slab fix for 6.18-rc7
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, 
	David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9iyz1xugk5e6nrgawy1kptzbrm8y8ubm
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AC2180012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763665113-650805
X-HE-Meta: U2FsdGVkX19qIdzz53Z6xOQx+raJE7DWPnQ8rP+NOpYclho06h0kkZwklCk6zaz32n+LtMmVJOFKBLdJyOvolTFbveKNcl4JsV9x3pdkhlzSATJFSCZ0Xyl4UuKb3Bv7iqU5avRXT7Rk1Fzy96pXnATL//JCs6E0uDYyLtfU7Uql/3Q9VKQNGq6woMvbK/Z3w1QC6auHQ+UQfn3JeU3dCRgYb4Of2V1EQHXL1xpT8g9XHHO+Htc+6GuT7WB47tic8ATsjv3uWZzDWuufSRCcZpNq4gWsQBZoNIUgoUTlZDF4tXHJzt8/k21dDaHPYICnl00cSdWIyDf2XKWPBKMfKbYBhKGlpjR8t4HgYmeg5Hs5N+xtS4CEjTXbBc6Kefy23FjeaT7dI5EQkGmQ56H1OSJaZ5sNACwKt5/1cRbTsCktfhXMbk2fBhKy6WNNsNa+aFbds4o83wx79UDYBP1iH4Y/VdBUnv1PikOOMmT1revL7bx2JsK0+CtZ1AXpJz3psQ64WTDbpCZcgL+Xtduba9oidxXCLROVqOgoTmoMthhaUmVs0qm79mGiaAvOc9vYz91fhaOuZL9i+9EAyciEY/evLG/3kjTBcCkWSbZ9/85iSyJ09f5VSC2HYAkOUILyrjYMjC+VPu/WvqUBpamExRFquvpSpMuovNjVih5bB4n8v6ksJvpGv0AFxUPszKzmTwrBnLMyxhV+rJol2KqX2hS3IM42rcZ2OgFxZe5mcg3NZfxL0VcpHrMxUi3HhrvD4kCKfJbzzhJahzvGIvYfIgtcLXgV/9XgbdXZ5/8u+ycQdp2cGWfTsAzKDjpcDnG7/RStVi6yrRs1aJxU2+/9yduoqpIN45w8kDn1AxF+CojWEblUEmV0OjWuZmdaYDWQrZoQU/E37R2QXcM35ZtA+1wVqFP9bnNOqF3m30adJzY4Rp4JAabth2KyTpu2HIw66ri19UnK1qLEvKvZagX
 UDrX3xp/
 kE8cAl3Wy0zSCqcrjP119kcJF2UYcT4VbAoAg1LNG1kRl6OOlVxc2ArKdmq9JWwl8BzAenIwAruheb3oTf+dzcj021E0ql3Qblq3YUhQIKJ30h3O+RJj9yiU2GbDR7ZRbfeNkMIig8WhDy/mRYYD8RTt+9/jwDajmELhJ7MZiI2UZ2/z55bQHQtLRywB6nB+UB6FmeVoTdcGXXawFyI3e3I+M5SbcNQhAUvvdf66OXLXfW3eVKI9M4eB58AnsAvBQDhFTJzQCNU337AT7XeoQqttgZCkJ6SmXbhrnQyPZvbPRqjGsJnm+ZSPaHNuZSvMXC1mO9Y45PnIPIn4jAzebNS5E4xGu6x2gdlCYJQLp8UR8b4YrkQzcIjhvhKV3c0PbNtyMt6BpNAcRYeT4si+V7DppMCVKhJolFmcHhEWGtxBHZIN4KEyyLi0Ko5127cfgJIrgJIZWnRXygCsqMQYstUIqgJJsozb/frWTgd3j1AB/Wuog/GULgTayfJIGF0E1V0rBFBIYKIKeqSvnbIZ5QQA5XatyY+78ohtOYiZZAnSyrC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 at 10:45, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> * Fix mempool poisoning order>0 pages with CONFIG_HIGHMEM (Vlastimil Babka)

I've pulled this, but honestly, CONFIG_HIGHMEM should be considered a
dying breed, and I'd have been happier with just not adding extra code
for that thing.

Seriously, CONFIG_HIGHMEM is legacy x86 computers and embedded - old -
arm stuff. Fixing debug code for this is simply not worth it. Nobody
does actual kernel debugging on those platforms.

It already skips poisoning for *much* more important cases, I really
think the whole CONFIG_SLUB_DEBUG_ON could have been conditional on
!CONFIG_HIGHMEM.

In fact, not just SLUB_DEBUG_ON. I suspect *all* of SLUB_DEBUG could
be disabled for non-highmem cases, but I guess that right now it's
only CONFIG_SLUB_DEBUG_ON that triggers this situation anyway.

We will literally get rid of CONFIG_HIGHMEM entirely at some point,
but before we finally get to that point, I think we might as well at
least limit the pain. Because HIGHMEM has always been just that: pain.
Let's not add to it any more.

            Linus

