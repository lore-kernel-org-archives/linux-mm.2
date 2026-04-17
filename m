Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C816F99C67
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC1D6B0145; Fri, 17 Apr 2026 16:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C43D6B0147; Fri, 17 Apr 2026 16:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9B26B0148; Fri, 17 Apr 2026 16:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6D86B0145
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:59:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08AB01A02E6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:59:40 +0000 (UTC)
X-FDA: 84669264120.01.1EE1CDB
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 18E4F40008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:59:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OFfjGIH0;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZufiGMBiodERE5FIiMZDUSkBmcYz2+uUaKg2n/08duc=;
	b=oC3+snltPSywS8estCTdjj3NVjR228WHnrKJ4T2qVf5h0tzFKA5KW1b4RCmmwwoogqzinq
	HzS04dDz6p37ngFrxxT+sT4RqyXzQUcAqxlqvcDLaXhw24EpD7tD9hreqXVeFoxMek/s1s
	OOzBFSyjxMf5KmN/ZhW4JI+Nat7Pu/M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776459578; a=rsa-sha256;
	cv=pass;
	b=N6DhOOtdz1OGk/Vx9haynHpzlkSHVjdtDrzbsjsj30PTSZtLGzgYh47RuN5QsLax5KWY8c
	zim5oCSS5wdFonszEEt/hD8UWn2OKZddX08T0MU8OyUHKzXhoeO6UwQETy58v1Q0FkVrbS
	v3m8otiLCzOyRF+SxJYzDPmEKnfMnck=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OFfjGIH0;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64d5a7926cfso1220460d50.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776459577; cv=none;
        d=google.com; s=arc-20240605;
        b=KQiHY3phMbu8/+n2tRbQFZqPDBt9LmeCChrV6GlR6ZjgtrAwWFa/5PKe/4Uy09M2NX
         doucJ59IKh2/XdDvvUz96WgSJPPiay5nMuSkfMf2gVwALCjq+YC4JECtwpiaJ5CoPY6j
         ygjK+CRrsRWdk+pa6D//U7DXcY+vtLKe0nqkWOOpfL32I4hTqgMWmfeMd2ggiyTW7/Pg
         fbVC2Hws5VHg8Zcwj3fxwFxzpFhr5DooUny7sbypc7QMNTR85FnNWaQBvS9KCXkAv5Ww
         CsyoV0u9n78loM3oSZ62pTlr/5HCr96zMyu8R+gp6DoPS9xxlIuzsoPpxU/6qvJSSJdz
         cxng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZufiGMBiodERE5FIiMZDUSkBmcYz2+uUaKg2n/08duc=;
        fh=qdLaWomHrkDuzqGsM0z8Kama7LLth0EqnGd8NwQEzA8=;
        b=Bo+Ax85n38/AE2hBerN4VhpPBAex1pCxd+Q1zTiz3mt/PFU2d6ljZeoxKpdS+DsHph
         VIofFTO/HH33nfzPi8/e3pJPbL1CxYQBiqiQmZR7pagbZhnMaxo3VkTHRm2D98by5y9g
         KBZ67ZikutXH+UDgMmG7/ap5Gb6o9kUgQ0NM3fVS3aaZcsccU7L03aJmxOToLeaWjBPp
         9q4e/c2oEwaVF+cT4EEfp2uCP89PsLqAp3JG9lfb246hlRFvoZVAjavoJ81aXsfg8gWX
         ZrF8UY7q8kyZJOatY/PkD13z8D6t0KUVMQEpw0p/VcM7kh6FsG7pzyvAK+VwjWK929O2
         nPow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776459577; x=1777064377; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZufiGMBiodERE5FIiMZDUSkBmcYz2+uUaKg2n/08duc=;
        b=OFfjGIH0gCKmUzAu4RkhyAbLUcE+ZRvyJB7GVN4AriBEOJWghFWVuWFmVna2McVB4/
         OxdTFC/woPnk74JEjC0Oxthyp6O09dBrBD+6Eg8sc3F++oQRTPKspKr0+4aHWfj9TbIt
         Gc3zOxFDCbkPH7x2nE7MeFw9ERYQgQgKTy055djS0QHYJLVXyz76i8xTeck5UlX0mXc2
         J9aRd5OpZsnrtFNG90PsmXVWOadM1kTc03hWXhv6KQhjg9gpiGcMzZVn98jwnx6EYRjK
         cgAmOyOPJDJuwEZg48RYDkTtKIGQdAnmhWZ3uhQM7UgWNdvon+xjwPOgj6VJz9O+PsGN
         yz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459577; x=1777064377;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZufiGMBiodERE5FIiMZDUSkBmcYz2+uUaKg2n/08duc=;
        b=cDl9GTjfoeTXqVAJmc20CZfXyDbrKTjBkTZ0Jo2IGF1eGfpVbbarrPaQgckC1z5HFm
         JnVNP4rcp7KsfM4N+SrayKrAuY/4tgxElOUS7djO78wih8Whd4WHRs+XuvntyDAM2O5B
         p7pvG6nZ9nBkzE2mNgUtkBbn+HT+kWWWeo/WeBNHySglZyndVKRwCh2haHkDNGBbInmK
         n/lhZd22MRbfO+aR3EPL2XrlltvgaGz+bGNgMyGk034LixsbaGIDxQAmps9ASOzntyBt
         79N9ongYwIemXApog2eyLCTpI/nsJmkLcBgeVgD05YyRTKyidVx9Clz4NAkCB6OkAriv
         T8Bw==
X-Forwarded-Encrypted: i=1; AFNElJ+IeO4Lz+qmIlUX6JPqFyvwFFheibd7HO2dUCVOIfbKUdvxtQuoAEztPt5B3prgvgF3TATGc/HSaA==@kvack.org
X-Gm-Message-State: AOJu0YysNN4Fyw/WaYLVV4tLUSj5OoyMluT8ciqnlplhv4vN4VGopyR7
	7kccAncx3hBYPPagGpxneYasfl2SGryQhtCRYePm+aNkfEBUSz2OfY1aYD2dSAkbFoip1UWNbXP
	Q7jMSRLpKMf9wDSzWy1PMDSGLQ5oVhfQ=
X-Gm-Gg: AeBDieuQN2HImXqzkjOHa10iKKAINKUysp/rwy+A6Q2Axa+jvLagRJasrFnBkCZPWZ9
	md11rJeBegN59t2rvrkL0BBMohUxmleonL5DWkKo0+blPAbd0iO5pLend8x4n17B3DALLZcbkQN
	KR4HK37xK/EmDWdego5Gcz3IMRCzI2nkZbXSAON8HeYnTZtex0Lw8J302Bm5kkz9brwUpf5Egje
	HgUYmzFnRIARckgHNGHUwsGrK9O56Xb7zsO++x87athCIJW4/cLJ58en2hMn6OOB6jr48DRQu1e
	OU8YmaO/s9yRj3vmigLHKT2OncT2bLSDq66X507+Vp5uvESY6c6whkZQM62XRMQ=
X-Received: by 2002:a05:690e:128c:b0:653:61a:2cd with SMTP id
 956f58d0204a3-6531080839amr4343211d50.16.1776459577133; Fri, 17 Apr 2026
 13:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260417204039.1827319-1-luca.boccassi@gmail.com> <547dc4f7xmafywo7jfeuordj5uwaq5lq4zfdupvswxy5yn5osj@v67ia535jnfw>
In-Reply-To: <547dc4f7xmafywo7jfeuordj5uwaq5lq4zfdupvswxy5yn5osj@v67ia535jnfw>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Fri, 17 Apr 2026 21:59:23 +0100
X-Gm-Features: AQROBzDPb8w6RKJJ7naC7qwRolTzXugdDA1zS20bjZ619PpPhYtV0_RCHxk_70M
Message-ID: <CAMw=ZnRX2eLzdWG+DDsPA-MebkARg7rOWx2ZP0W5T2AgPd-7VA@mail.gmail.com>
Subject: Re: [PATCH v3] liveupdate: add LUO_SESSION_MAGIC magic inode type
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 18E4F40008
X-Rspamd-Server: rspam07
X-Stat-Signature: u6dicbbmynwrhhy9io9qdwnyuh864cgk
X-Rspam-User: 
X-HE-Tag: 1776459577-613670
X-HE-Meta: U2FsdGVkX18zsk8i7qAI8IRffN+FfD4jnWna1rP5Qo9pw/5EomgcwMb9Yv3i6aYII0TeVzrgqycR79TliUj4S4BwlfH1Y8K7ebJP5RcGBplGuuNZWBHijDweVynfRyvtdNz+Sw+aj1nW44ml1bd1MnzkBJHJUUI0/y5g4Hh5gsMTVhjtOOwOrZtvAcUOG5VPbGqWouIkrsSFwUpGUvfh/i8jsYJg7rSZzh2jEJBnaGwEBbkTBZC0z5JE22Zh5V8Gg0woklzxfwE1jfbD61NXJaCNRkEm5weG60+2LwSxeixmRBCIC051gLpnhvIwjipbNAZlDKd2MY33AY6Co+xgTskf9gw/YuVy0uEROEHLN660sYVuQEOOe6uuw7k24OqY/Khz7/9HdcdziSwmaRaZwsZ+p/y+oIpsgQOoaWYbOUN9tSnkPgR9/j7IHz+lr/iB5J2HS2UGOPdEFBzDjc21XmIuwDW/K/4q8kac8xK8KGziqYsZTbB2WxHxuqgMEqCxldODI0WTQknPh45966yhAATtA1EoCF7l653+WOAQmNcTcF6I7SkWcv4nTqM03/6Ebn4xDGtZvd2v+T7LRtehMlF+hDCbblYh2KXHVzw694VyRyZaPx0WY1aKrSWfy8u3BRs3Za/ZhJo48X4WWKMBC70XU9DJwaLsR3GfbhqAlwGSZzPUaSymnYzoTuGc9rWeUByWIJ3+bOCH+dZvlBnvykpCCLHDfuYl4gNEz/mCVIARTIMUehckOb1IZ8g+J3Ioze2r90bp/z84HnuXskZrUvFwYdtUwtGPjVcerwJLLax/XFxjwmV4++uuqf8SBfJ9KiH2rF/alzQOCWISzZGgqResql1CAI0gi4JIwWsQdJgBcUslt9BUDpYZp+C3Tg6H/k/Io/lq3dlSEQl9q2u7Tz20DaAjszLB//iX/jevXnHaP2Y2FfmdqBOkti0U5+B3yiZSQ4byNmi4gG8+5bi
 0idbru7u
 KRvBlRKpLWli/PCA0BKAnw4yDbF9Au63/V6e8yajJ9D08XzsMFwWDEmUZhzawH+TdqLcJlIIbFIl7KI2IP2KQl8IgsGpUYqXVMR+dTprQjA8Yxxusa9MkOOf9WIZhVFsE+pe3nflVwUlsZnK4SVGekh4SVrMwc9uqxzmt8CWGPLKUrzS6D6FdcBd+RBuYAtxf4w7pBUT3ddSiVMR6RD0ZwWwPWCCUF+i3FMfld3l2vzmTqJejitgcu9PFhaDBf8gmrmXtRR5roXdMkNQUDjh9dL3e65NSuQ3PLqp1D8wT7aEIN4m3EvBwqFJfRVpsU/ghDs3f2RIA56+KNUJACDhjmebBdLhJJrEOX+WSOhxqAwPXgKf+5z7NDHkg4tYJ57eRtJxyrdteuZtMe8obpW7oi+I3BfRNvBhsZt7H2nebZmUCErv+3+DcjDGlHhYyP2djXCDGjbiJvnRdOUKHGBEV2AiCNTxq4WIwQszRp3gWF/sygJYxgU0476+OJzjbJ0iRyxqGLtnHub0xNlHly30rFLz9ISLwlUML+ERw7WFF5J6rundrtV6ydO2qcN708Vq/P52uixtaBK7ycUymtVT7yuRvUF6xDFmCKxSoJRqg7HNGifUo5ZS2iKng5lvgMX6N7yoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 at 21:53, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-17 21:40, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > In userspace when managing LUO sessions we want to be able to identify
> > a FD as a LUO session, in order to be able to do the special handling
> > that they require in order to function as intended on kexec.
> >
> > Currently this requires scraping procfs and doing string matching on
> > the prefix of the dname, which is not an ideal interface.
> >
> > Add a singleton inode type with a magic value, so that we can
> > programmatically identify a fd as a LUO session via fstat().
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > ---
> > This was requested by Lennart and Christian when discussing integration
> > with systemd for LUO management.
> >
> > v2: apply one fix from bot review about cleanup on error path:
> >     https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
> >     the other comments are invalid: luo is not a kmod, and the write hooks are not set up
> > v3: add test case to liveupdate selftest
>
> This should be split into two patches, also please CC:
> linux-kernel@vger.kernel.org

...

> Reverse-christmast-tree order please.

Done with v4, thanks

