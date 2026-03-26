Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C6510AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642526B00BC; Thu, 26 Mar 2026 19:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB676B00BD; Thu, 26 Mar 2026 19:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9FA6B00C0; Thu, 26 Mar 2026 19:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36A6E6B00BC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:10:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CB7C160DD8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:10:57 +0000 (UTC)
X-FDA: 84589761354.24.515EE5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B59D710000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:10:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnrICnDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774566655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQNdt59Y0rQg1C/DWmXymlTQ84oO0Alz6JYf4JGU5p4=;
	b=ujMihYGvpxlLCSCT/VMQ30ZwWfH3gnIC6vW9pVpN0lfbd/nMgUgtMYFKtCDtrdT/QGg2m0
	dzo795MUYmch9vskLG7ITB4c12MjhfrB6LnX9kAc194ijYFuPvvdei46vAlaSElzRCzxjd
	56r2wXNmf6FrQqnrBU58WNqRr61upRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774566655; a=rsa-sha256;
	cv=none;
	b=qdPijhRmvbNTpMkXr3hZP5x/JNrERSO0JnL65SQhduNr5JzhvfNFJxogXm3y2UPQY8joWN
	H/+IxiuUH528BJIEhzkaJNSeQzS1qixoGSS7HRIvNm3KV8fvulEjVeDPH81fDwHy48K2e8
	E9R/8rmzFOUJjCd5TKUSWzrI2X2R7UA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnrICnDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06C6A6011F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D96C2BCB7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774566654;
	bh=HEabCAS3j7mMDHObZy/GRmEkWbvvgyE9mlPkTC/rKtw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qnrICnDF8v0HcsQijsGqRez19f5CS3Muzmxh1YWTHJKpxImprw1BtALFpZD0GAgft
	 Sf5hOYxQzHAatwH2U32mus4XCVWRStfZN8hxrWctFJ7dCFW4Z1JN/DIcKb3hecevc+
	 Ck6AFb2GSfYDIqeBXXYgTjMUir0EJ5u800H5BNP9PO3BbYgRn9Qqm4WnEfnergSv01
	 AogoQFKvEI2cWQr07e6mdpvqTFRQGOotWV4AoOpYHaLdnUDKphGYfpBoRSHah3MPu8
	 nmwjj8H2vWpTDcdc+BvFQWyhHYw1cofN5G/5aKBhfrdimRpxu58ATD/2RttoWCzmRb
	 LUQF30CshAcsA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b941762394aso210427066b.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:10:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWB0MkiTolPV4jTgskDyGxFKf+4q7KmDbpA16xd1+CpZ3a2SShWTnxReo3Pm5rOymjOkH8pdhitHA==@kvack.org
X-Gm-Message-State: AOJu0YyZ6UiCfALT+zPAJvaHdjJhz3tYOmKA7Bu6DCa+DnSr+Fy56zDE
	qVivl+CO2/s1Scu04nQWWoYuUhmltNLT7Bxhq4lWky1qpfJKMrUJUDd92E9+/aTgSVwuOFZ1rM0
	g8c/lFj0buk1FUYVrBz4LGDBJ3K9z/q0=
X-Received: by 2002:a17:907:a0d5:b0:b84:40d3:43e7 with SMTP id
 a640c23a62f3a-b9b502c082emr17431066b.6.1774566653369; Thu, 26 Mar 2026
 16:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260326032658.96819-1-liwang@redhat.com> <acTSQFxTs4-t7P5t@redhat.com>
 <20260326160618.18a20227b606bc95f3c3cfa6@linux-foundation.org>
In-Reply-To: <20260326160618.18a20227b606bc95f3c3cfa6@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 26 Mar 2026 16:10:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPMtNaRuGSrHnfh6AX3DKVoR6d90X7O9UTjxbushssyuA@mail.gmail.com>
X-Gm-Features: AQROBzBwjNh8DYJY5cdGsMAUqkIBhiDt_G1kN7qGVt8vQO-IEBhvuwlMiehhNfE
Message-ID: <CAO9r8zPMtNaRuGSrHnfh6AX3DKVoR6d90X7O9UTjxbushssyuA@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Wang <liwang@redhat.com>, nphamcs@gmail.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, tj@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, longman@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B59D710000C
X-Stat-Signature: 1yf1b7r9qibdjmoscbo3yy47fjecp9qx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774566655-664850
X-HE-Meta: U2FsdGVkX1+JFbgzog4N3Zb0V/NqguEpZdFI/+WMReVZk3WKzsjLyxdWDNc2S8ShyxXAPMqCfB7ZLbyU6bPAd0jWyhtmNjeDIPYRs84wDUcz/TLN8Wttf7FCjJvrklS3/XnScclwjWtTJet3HNiWqVNPAXZMDP+HNHerN679g6dB5BL2SDuIJ0YY/8QTYLVnWwvJ3sBv00FWUubCwPIOFTSyyQ09xphgyEyKqH7I6tRO0tuY3ZtbQ/iLwEQbLCpn00sD8pP615e59ZiaNYt+zqvOm4ZlYrPzp2CpWrWmwgV4QhGUCpXzhU6R3hgEdGtylikER7Ii6xs49Dr1R6pl8+VeClp2GDmzvWy/W/zHG2uduWpIG10xTXzAJOtwHyG/uheOba0N8jTsomFRbv9mwcRTyDG3l4E5hcwxKwyeLuDeT3Pb33iUgkEHw9LZosk8lx3x2ACv5iYyKgnQOtBLeH27u9cDieiyMFWMit3q4aovVCrvfreYHKhBassxudZvNkebQz7lVW0df3AlMWuGkqcW8dYfSR3zWIkR0TPUVOD0G8Q+DTxXUhMCC4PgGLnOSO/aLLMb2+U8RCybtHR0P0QRSe5BapunfateO8I0NQQpOWiyGmxZtSlGvBNZ9FnCMdlw2K2aLVu2BTQLpPdbWGtL5JllG/vbJGJCG9OxL0ZO0I+maUFgp6lhUgdlLov1W2h8vIIlz+qTOomiXSJe0SB4zzTnnqMH6PUfxCf4S4Nd8hPbN8wxTOVl4lLFUfNNFsnCxs24h0lWp6WxDu1k8sNYjcMeFbBmZfyuxl2HgoIxycrCvbdGoiK6UbZwXJF6MpMjbJ/2Xtw0gcwKncsVSCd4I6C/oEwCGAhLBFBBdSjgYs2A72GvWY/1aepzMmyIm042erewec9MmguQiSmsn9sZl6cva0f/u4ZcbHtNf0oUhFCF+N24dtxdr0fpRdEo1wxCIgEHpDdEmw2+vl8
 KtSNRg18
 gwcrGbFiH+XUAxqgYh1+G4oDgefKbeXsZTGvXKEXjiBtbd3PGakz/698/sGRUcXN3PBQxGt4bKxKCJWbuaAH+MH1IcHTlELq6BJhPma4YuX6fKq2DLG35PHL3fPxES4KINj6DwR2iZ7Cy7t7yD5IRh/D55a4quT28Dhm0VVsbubuHlTW48KkH491+1EFvC98T3Q+ZqmSei4oh/uLsn6jEHIoam9l6S36EDGimT8sDL9LoWtLf9g8rzTc55nSk7FvW6UPI+s1F0WNfqs33ZLn3gNdzOutPW85ytX8pS+UQXnCQddBOv5EP+oYcfPX4fAuLSuI+7r2EWC++mj2HjOA0LtDFxmXR1KZi8OSvGR4UQVf7XLatoXngS85BeF0eqvg0ALZ0qw0Ib1fT2PQKmd0xnPvSNxY/oAHS8luX5DBp/91cDVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:06=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 26 Mar 2026 14:29:20 +0800 Li Wang <liwang@redhat.com> wrote:
>
> > > Test all passed on:
> > >   x86_64(4k), aarch64(4K, 64K), ppc64le(64K).
> >
> > Hi Andrew, All,
> >
> > I see that Sashiko still points out minor issues in this patchset,
> > That seems very tiny in selftest programming.
> >
> > I can correct all that in a new version if you'd like a perfect patchse=
t.
> >
> > Sashiko comments:
> >   https://sashiko.dev/#/patchset/20260326032658.96819-1-liwang%40redhat=
.com
>
> Ah, OK, you already looked.
>
> If you say they're too minor then I'm OK with that.  If there are any
> you feel you'd like to address then go for it.  That's my opinion,
> others might differ!
>
> I suggest you leave things as-is for a while (a week?), give the memcg
> maintainers time to take a look (please).

I think some of the comments are worth addressing, especially:

Patch 4:
Using BUF_SIZE in the allocation helpers is wrong, we should use the
actual page size.

Patch 6:
Zero initialization of zw_allocation.

But yeah as Andrew said, it may be worth waiting for memcg maintainers
to take a look before sending a new version.

