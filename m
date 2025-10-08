Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E31ACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750268E0045; Wed,  8 Oct 2025 12:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7278C8E0002; Wed,  8 Oct 2025 12:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E8A8E0045; Wed,  8 Oct 2025 12:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA988E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:24:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFE0559EA0
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:24:30 +0000 (UTC)
X-FDA: 83975469900.08.7C2C1D3
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E8D01A0014
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:24:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="VD+mXCx/";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759940668; a=rsa-sha256;
	cv=none;
	b=Nc+dZ1OrUEaXP+61Hrlz4LqF1pyRfH04kRy0PZN0hYLOprZHCUGnkngC5VVVotiCqIfe9I
	AqgH5y/FKP5O4o0j27XiJNR2Chj+cvU79V1Xeho7rPf6fNWRRD7EPQb+bE+UZCHnWIxfEP
	V3cIMgzp5gr2zckOUg/uoDKQCI6B7iE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="VD+mXCx/";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759940668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGv8gU8Wgrbxfvqd2t7G8Us4a0ybRRasjTDl8ZOYS+I=;
	b=Vt6zbV07ZrVYU7cmFzABPw57+mcfl+udm3XtoOnKOfICtRbuXSGDIEodAn89NMQlFyGYLb
	5MVs/dc4k4CyCxFoCKNLL6CSYU3Y20VJpRV8En5Q/XWpuUpeJ+qNDN/bkNHIczXn6yn1hn
	Dj0IvDVJ5GsWJkPPU6aHOA+aqQjbkIo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6318855a83fso183188a12.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759940667; x=1760545467; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gGv8gU8Wgrbxfvqd2t7G8Us4a0ybRRasjTDl8ZOYS+I=;
        b=VD+mXCx/g/5BvmPRhsMCjiakWdL8GYPdPXPsqL70VHX75rL/j3jZj0jDIwXjSGeYpB
         AOmxjKCe0Cl5BZqWbj7I+7ep6wh2xNhSK693gv0sW9862VWEPeA4MR/WCJMCPzEkXDq0
         5j1+eZ2sm7Hpi2KliZv1aAjgBfd1MIZ6tG39Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759940667; x=1760545467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGv8gU8Wgrbxfvqd2t7G8Us4a0ybRRasjTDl8ZOYS+I=;
        b=AAX0MBuaC8hVlGQzocXCCcPiqs2Vs+4E+dY4dyE+zjpvssd/V8EU+gV2JQRVrgFNxL
         AWCBnoL4+0KlANNmu4/6yiGx9dmKXboEaU1qWO9nHLzNmcL+e/+sOZjiWSar2boaGGAy
         1mn7TvnCLndcHcqvA2FAH6JNJ/Wq0ikBm0QcW/ohBtO9VRdT6h6E3bjNn2YJM4a4ZNFC
         PzXKORhrgjEvhIzhQYcPQaxjTGxyzJ8hMB5dqCOwpsZhjn7rM67M1q4DNQaPlr3Rrw2r
         iDLY7C5sPwoJ4apwEq0WUj3vTmvkLTN8Uq+bgvC6NcoA+cTiZRutMx5qDAeRthYxtkvv
         dJ2w==
X-Forwarded-Encrypted: i=1; AJvYcCUiUll/+CW1C0fOiGh0mV4LJ3GMHGGCTlp8kVtNtdh/w7tpZeQptWroMOkDnk6j9H2d0BiK/aiCLQ==@kvack.org
X-Gm-Message-State: AOJu0YxFycxb1axlYApZ1nv+O1j6RZcrlL6mcViqg8Xedq+Hlv2lt4E8
	60up38kLCUXCC/waoxwUuRrp14ZIjf9TO9n2ACovSEmazWpPx+LrwU8REByiismSIKhB8+sB2g8
	10l1wHCE=
X-Gm-Gg: ASbGnct0322lQ8mOwYbmnI03X1B1QSPBOZAsi1ynw7MKyvTQKxaiiTYnBYrfa1FrGAo
	LfSeUCp8cA9eZ4vkxTML9TrZXOzuQQ+oOHlb0Qhej4DKJ06qCJ3LKy/NdecdIwSh68kprOvKBxV
	1bPsT8s5tRodfdzup1t9QNmoMs2HiaelBQemOKDBzs+ElHYLY/zQlEcVtt6795OzMX3Qacjkxtt
	pcNfdNSGoJbTFj1A27gRbqOG/gjfWuwF3OwZAH9Q7iSiQYdMGg+qDVZrCbxy8uCs2Hlgv8WYJFK
	pGXv9Rfazcynw5PkKxVCh16Wih8Q0zDGH+yJKmDL/H2dIwMBTY7FxwGHuFeFQvuVgt3gxgVKPPy
	1EY+tIKtRcZvdLkI/oLySMZet5dkgy23z1TPm0ZEorujAKJqg/+5LvSnn3M8q8s8QVdJvYmIRk5
	ovoA3I7hhMn4P2XGznNkQXOiQJ+d6Ogo4=
X-Google-Smtp-Source: AGHT+IHK5VcQyu35jqEev4Rodb4l9u78NBAW576siMZGOdifu6DZiSafV7rpkRFGUGhy6AqDSjkLhg==
X-Received: by 2002:a05:6402:1e8a:b0:638:1599:6c34 with SMTP id 4fb4d7f45d1cf-639d5c38143mr3494340a12.21.1759940666581;
        Wed, 08 Oct 2025 09:24:26 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-639f30fb7dfsm342354a12.19.2025.10.08.09.24.25
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 09:24:25 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63963066fb0so1235777a12.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:24:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWAzbti1d6Y2Lmc1yLmnmWdEijmQcpOZb48yj8li8hwWKzeRBztvHDCScnCAUfa/0D1RYmcLRnM4Q==@kvack.org
X-Received: by 2002:a05:6402:5193:b0:634:c1a5:3106 with SMTP id
 4fb4d7f45d1cf-639d5c5a3dfmr3717885a12.31.1759940665182; Wed, 08 Oct 2025
 09:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com> <bbagpeesjg73emxpwkxnvaepcn5hjrsrabaamtth2m26khhppa@7hpwl2mk3mlc>
In-Reply-To: <bbagpeesjg73emxpwkxnvaepcn5hjrsrabaamtth2m26khhppa@7hpwl2mk3mlc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Oct 2025 09:24:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZvzPZbzWt2Cuww3myOjQmvoaRtqme0jRawoUQnvWCrA@mail.gmail.com>
X-Gm-Features: AS18NWB5H0D_6NxOrszgcVIeZjT3XVd-PPCC5ZrYzJUv77q1XMrMBBR0-VbvhII
Message-ID: <CAHk-=wiZvzPZbzWt2Cuww3myOjQmvoaRtqme0jRawoUQnvWCrA@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qe8pwhik3i6prrzmw37xc4syuowwt335
X-Rspamd-Queue-Id: 8E8D01A0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759940668-234293
X-HE-Meta: U2FsdGVkX1/vVuh5UUmcVcPg4tZhtbPe13cf9GJbglw51xsXDgWseUErap68GAaVTBTdGaCu8AqavWEoa5C7IHv0btI+4ZKRWcqbpa07XTLwppk7F0dIW+PFE//UElgr7rOlLaY4WXhuVlUKRmSVKygX8r3kgHCZ9rXjV1lLGnRjJMkejKJpOX9VliybGVdrCwge/VVV5UOM0idJ/BptjxCRY+z0rOuK07gcVxNrM3QDYS+ohSpdH37VOy5Zp5AAghm9pfAFUJ0Z3XgQ85iNGGE5LMhBnGNWWZhtqg0InnRyPlWlAiW1qExQGpZFoGCHTE7wpbq3j/7DS3CRRwGmYOU9WeJoGtI4OopqZc+vAH6MTh+bwRtMr6LBcg4dS7GhQAFw8vG1QAUtZfDFLF541d/7hY7pibF221bH8weTUZ04LIm/FxV8pzA9Er1jAc0k0JD5+ogWZmW/TUia8uU9ezCuVrO4uj82gcflotq6ECq4DJ6ay4AgkBQRrEH8E9xfXy2/oP+8YXY8ArI0gSBjUZJi7rvejQSW97/gtXi9R0hb9vnvAP7KI3QWus2WITcpKeeSTawnovTJZrbRWCSaWymOtpiijCnMSTq3HDtUTbCjmZDIRmAbxXDKEEz5lpznHjpMEZFP5LUch6l0cGsKRZAiKrcKWgKvMG4PyjuadJTL/tNGRi3vs6WbDj29NyAdNfZ+quvLzi0ZSBIZigDnvPbfqgoFjeu749W9MybKkitflBlmjG5fPCClDcGaE+p/M0UNQiBPtQKr4nwcfRMsudEZ4rmvMOk+g8mXVnGiOtcDtffaVSCzJ+el8VgeUKBincxhbaCveQ6uyNyMDZkmHxW4P0wAwpjq3KBNKXLaaSiCp6+b8u8BXhsZVf8CIuG+wD6BqaxXn5F+asgG1OqnNokMFziJQgyshynhNKN7STgkKfbUV9yZUDW/D2eNm+9NGSXNRBxZt19ohhlwFll
 DMkZ82zo
 4Qshf0ukYTcoo+TtXloHUCj22G4h1TK5kCHs7tVC8n+cIk8HdFb0IF00qUXWbbNi41NZ9EcUu7eLUg3AlAcw9edvV0F7+2p3dxTXnnZeGldl9W3LLLWwEiZggp652JRZt3folS1i+1gid1n1EoDE3zuu4VUXMy7O61aZUBdfAcHJXajQTvmEEs8+B1BLwtMm5tm8AzkcRGXs9D2vd2qzjkxHDTQW8/Wo3oeFfWU0/ylBeKBT+DVyW5Jg6CIeyMH+WoxkYQIyKDYWuaqD6Xh/EidjZMkN1y12ijNmc+pzmf2wlcDNv46yLxVS2a0r3Hui2jutTVExLEy5DIWkKAWeVDiEahCPHf6P8pWy+TgEKWGoVk8l91ZlMpPNGIM2frYn2POln1iCGz0K4opLtUfz8j41uwsC7GUt85Ob1ME7Kpz9weDJrZ/rxfJRONOxSYXNV6pOAuWxLJIi6UdxTTe0/a0oCk9fQlOGH/eHX/mN7BWnS2faLCPAVXUJho3xj+oBOa1Ek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 at 03:28, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> PAGE_SIZE is somewhat arbitrary here. We might want to see if we can do
> full length (or until the first failure). But holding RCU read lock whole
> time might not be a good idea in this case.

There are other considerations too. If you do large reads, then you
might want to do the gang lookup of pages etc.

This low-latency path is unlikely to be the best one for big reads, in
other words.

I agree that the exact point where you do that is pretty arbitrary.

> filemap_fast_read() will only read short on EOF. So if it reads short we
> don't need additional iterations.

That's only true in the current stupid implementation.

If we actualyl do page crossing reads etc, then filemap_fast_read()
will return partial reads for when it hits a folio end etc.

Right now it does that

                /* No partial reads */
                return 0;

but that's a *current* limitation and only makes sense in the "oh,
we're going to have to fall back to the slow case anyway" model.

In the "we'll try again" model it's actually not a sensible thing.

            Linus

