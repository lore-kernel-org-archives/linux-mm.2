Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FFF3CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F796B0200; Sun, 31 May 2026 23:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6109A6B0201; Sun, 31 May 2026 23:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF6B6B0202; Sun, 31 May 2026 23:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEA16B0200
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:11:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C27571C1B22
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:11:50 +0000 (UTC)
X-FDA: 84829869180.26.28EAE39
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAE37180006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:11:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=RzdfUrtR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.47 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780283508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
	b=Nl2BdRggffTHQJDrKiLnNpN5qeTK3Bu5l+ncY6V8rILvk0k2ucBO7RP6ju6OJb3Kvxyifb
	Fhjhfy4UitFdmMg7x5MwC85xThjAC4ieQ6TXiw7yYweHgV9qONEhAG2YMFVo0IjV8tTu7/
	K3Gbao6Jk3J/zrT9D8TYd8WJnAo/0nc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780283508; a=rsa-sha256;
	cv=pass;
	b=r0Aa+aVMEiShBCZDn043MusNQKxKBkfw9LNT8RF5ZSQPUdy4nqQ49H0JZUm4pmaH24Tc6C
	nCFTUwACimzY3/W/CTENLb9eXsHHTjcPvnLj1FBLTNlAc6cnZ2QOU4mIl+t3+x2edVKnc1
	O6NcX50QnbLo8Dvdq05LSGbGoDfUqdc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=RzdfUrtR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.47 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aa66893e9fso1043162e87.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 20:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780283507; cv=none;
        d=google.com; s=arc-20240605;
        b=ZX9XyKrqrBkJAG3PdRgQQkSK4dGQYjSU8y2z/zH6fvnMELCkO/8Eak5RheZnvqnyOa
         oUk6sqlkNSPtKnB3QxvEEUvnZ4xp8p7d7mtlBONi3tuDjwRaOCLxJs3ZLYU3QOZIprEV
         4ARATEjQ6xMyB0ex3s+Yo3bxN4RoF3tnZCfbKH8WAS5neV0DFFjNaRePpVQVdY2EZGo7
         kX7yLfx7ThY5VVqcFzQGgEIX32Pacvob70tE5RyYfHDXhR3+GjaP7r5FYYr5885B289P
         UMrFEz6Jxt87n+rXb4WriGulOWYW4vYvGeTwd500cj8V4CDHVQMJxVAmslcofH5dUfVn
         rnwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        fh=6FBr3aFYIHlghx7r1czLZclbj7ZxsdlcCaB4SlShQ0M=;
        b=PII0CSaO6HQWQzTidtkD/ip2LQcMCWAw63TTU9DFbKM8tZ23G2SbhnhsxSsqDR9cIx
         5Dy6+os8Q5yoFtTxMcxv9h8Q+Ku5wVtiuVm8pnfRg6Hk9nLaHEXbKwJTlpa5lAkUaHt5
         PEVF2L0JV/xGhossSjwJnnDBIkMFqDEdwiZr5a0UsR8CalrodavX5X+O7XvxjSQrrVRa
         GvZfmd9QPaN5UTlJ8ym6IZdPv3t7yo/4CfqnimvByJh5AF0JECvVHJgTEwqNJlHAvBck
         pH6DwNklsZUVWyKmpg+GVF7jwKk7Yp0GQDgc9dZVWn+f5MJpe+A2MItiP2SQjNRaOCQy
         pPmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780283507; x=1780888307; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        b=RzdfUrtR2sspHNQt2sgRU03KigAu+BxrMRxoiCqzXE+0ZWmY5KKR19ccHTPb9lDcIA
         h0VMbPSr/VgLsXNkwEMqo8WMRaCRpyPiS6BHoqI9mfPq8q3auTzKZpzwyxMn4oU2kns3
         +Bs40Hc/M4tosiAvtRpGm7hnurcTt2nAVciSxCf04+2Wop4t/nsLp0/LxwLe0Fbpprs0
         /oLrFwyYN2/ESpgH7+ocU4GvnOyA+JwhGIgrJSvzCHtSn3eRqS6taGhDoCPMrmZHGDFq
         tK6xKCZ3IulNtniXTqoePESXo9bgzyoR6JTSInnaOeAgBRyFXSWTXZwaUmZtmUqj2MEG
         r4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780283507; x=1780888307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        b=Z/AGLSbw8fSpkFfSsydPI0jW9FTBOrtBzlRuzC+s6L0Bu4pxxPV9vIOn6suEoS2S4Z
         UDT0KgZlRA2VOu0WvhqHaoqaNwzTQlrzImN0VG9I2I3cw0mN51NunJscuv9K1bHRJolb
         jDBMHw1dSR2qd5fWxsYB99JVR+YhOIwihrFpoFu78jcfjVRUTUb2c82DThai8rhwCfaA
         i3jRlmWJed0ue3wYOcK6vvaUuWTsq8nP/EL7ZHNcFTRqLrAI5TDH6iqvNiSDtVr9TfEn
         tGneeOSKGMrBF92ewYaO7/CCrhWeMls+4ahzJRd6UZoOv1vWcqY9T1m/X6Sv88P/H7x6
         d1xg==
X-Forwarded-Encrypted: i=1; AFNElJ/YokcAdFaaFwdpPODyX6TOymGXmDsQeWJCkI1nHo26Y7B8qLFZ0jSjS6B0z9ZKsDSTCWMu0S7PXg==@kvack.org
X-Gm-Message-State: AOJu0YzxK1Y25YWUPzOP4dQNs5GYDkp80mYvp/+vphL4Qya4Lf2dyqQW
	hYabgrHwHbVjAD4JZK3F7b01xIWfu8woEYT6GIlOXGBibKNss4dnwBBVsD1hG8aXmLCrDmwfatN
	lq48oI1TvfDztNnqPYzbE33GHqu2xEjxUPg8zMDRe
X-Gm-Gg: Acq92OFKO7UZ0quV6fDbKgeTtsoZAhz6MvLYx6b+0mC+tn7HjnipMNNAksQFmpdZI9I
	BFvqBooVwUC2y0KxgTp6sUN+Q3iPgtA7pebaXEilodpuiBIAG6swqfZjzK1Bqd3XTmc9OkegDp3
	RuGEeaIjuupXdNYYxJ/q2imiqeiCjxGd5y9JL3qDiCLmYfmhJYtqt1vqmn1TjdqOsgZ62IBvv2j
	8r7BIgtZyTHcA/jXgv9X7I+4YjKxxuIUYWl7Fy9U3x0xSThgPDRJvSGylZ8rBhkW9Wvrkvog8h0
	OINgoLDGLzYAhQg=
X-Received: by 2002:a05:6512:158e:b0:5aa:690c:662f with SMTP id
 2adb3069b0e04-5aa690c66e9mr1347657e87.23.1780283506595; Sun, 31 May 2026
 20:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 31 May 2026 20:11:34 -0700
X-Gm-Features: AVHnY4JXGlP1eBaFLieX9GEu2QC7fa8YTkX6sK3P-yG-Mx-u9DLHduWiKUrWdA8
Message-ID: <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 4zxxf1gbx53ef5akxhyex7zg6o1mipe1
X-Rspamd-Queue-Id: AAE37180006
X-Rspam-User: 
X-HE-Tag: 1780283508-475984
X-HE-Meta: U2FsdGVkX1/xpbDivvvQkCyhmX9IGGZjlSH4vgZpZKRsseTEjW/zpS98ARJqziE//NtXwb3YJkxPj78EKyruJYLk33TPnRvahou4ITyBYpGYSSi/DN/+uFrLaWJ0vntE0mDptj5wFK95PRRtywCim9ZRaQz7cdGHztx9R2lTyJ196YNx9gqf8MLf6DauQntD603ovG0KyklzgZUuPwzKXGaEucF3C0ZMKLO8uANgz/xF4BtD50jhVnE/e/uVelW2nkP7R1eC2wjvWITqU6zeopEp+v9mxsjm6Ave3O1wZmezzg+/A17oDvy8RJCwjRMADqtyWBhnqSTEO2c/e4wE6kVI7g7lbb+ae3hxizAcHgDKlPwU4C7Mhz6GYmIevFWekoqmjPoE6C4ZTSPF4M7G8H+A/mytU45s9Phzk5OAIb/SZPYl/2PTxH7nme0ideW0Tst9duibYG9qPA8NNK0ZfgcgGG0XEK0WFeZ60gtgWcllaJynRDvkM4BYz+AnAoGQXC0WTHcT4aDoKe2QsqidnL5Kj8zMj0Bertch5WAmT1kbu/nkMCwp9PoEFi8I6XFlfVjxCGYEyv2S2zuzZAev+TQ0ZTCLnaGR1ixMs9Z9Uk0zfQEEIFFUvCRRWdXW3DsH2rDL4jHTLq3Z+rIEYRSZVv4vtYYIJtE5RA+TzarLa9NeFFu/f18aGYCyImTimRrfYTtONjdBvcg85rqq90lUYSPYk09n2WwRNWVFpKU7hK9g0n6FoIqFPnwYjgGmOWos2t5IcUQKz7UVULD+Eah5WGBCSxqiLdJNis2i16XN/zbNHEdxvV1zZg4qSsyr6mRzvqis+TbHu3CtuypD6s5Bpv71EvE9QwxMxaLIT0ijr5UC0+yrkz3Xh/MI+lLAyUMkfRAmnLAvcs/L7gKgw7APJDOdaY7K5oYKYdWWJAMTowJ+YfWTl0EeHzMHrpnoqrOI8/vx86Ry9w1hbFdEKzX
 sDkTm6v+
 3elySsWbZGcDJ217zaPusKYMck/1/pqOrKNHQ9NuQiEU1AQwpN8ofRlRw0WAPrDavr2fzLPpgoe6fPqfclgVGlP9VkIVBKoEzC/Vwoenuz/GjfS6Z7DkwfamU9RK5bTJWSUETWqtaCsv9VnfvLWuFHfborqLaSy/BfSqeaox1PMq3/irpFNztx6htmGA1Sg/WX21VNhCzI7gXbVusyq+c7j9/PL81biOf//txAU8FMtLlbqFPHEISRlZulQ1Vkj1xvnBpT1nKGSh1HsgzJzyLKnmnBv7WdEsBbeHKpchZqJi479mn/Ctexx+FvhJxRQFniudQ2IvtdvLPPdGPYJd6dOczi4vtfmZbIcGnICeWAm+Uzw5mdi8JvVYl6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 6:03=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> See recent discussion here:
> https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
>
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.
>

I have no comment on the code or the history.  But I'm 100% in favor
of the solution.  vmsplice is a crappy API, and would be incredibly
complex to get the implementation right,  and it should be removed.
But it has users, and the approach of just mapping them straight to
pread/pwrite makes perfect sense.

(If anyone wants to contemplate how bad the API is, contemplate gift
mode.  Or contemplate that, if you want correct results, you need to
avoid modifying the memory until the recipient is done reading or you
need to avoid reading the memory until the writer is done writing, and
vmsplice *does not tell you when it's done*.  And there isn't even a
caller specification of whether they want to read or write.  It's ...
crap.)

--Andy

