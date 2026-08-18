Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596D7C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6A96B018F; Tue, 18 Aug 2026 12:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE376B0190; Tue, 18 Aug 2026 12:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A09E6B0191; Tue, 18 Aug 2026 12:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34BE56B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:50:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9FB5160203
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:50:42 +0000 (UTC)
X-FDA: 85114979124.23.0B1FF84
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00FBDC0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:50:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SnyVy9/L";
	spf=pass (imf22.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787071841;
	b=8PRAN1VpQb8R6UOgqHkWnqWk7d+O5VoCR8AjlPYNlnc/j1z9a1Id0VCGIab1+FGuz7bHNa
	xqJ4r5Ks/wUzVObkrfAFzmMZKACit1fiWWSHUhjP1OtoZmXMFhXV2pTrYqDd8f72YWESCb
	yH0xCP3X9MMNRyerP0Kgari7t9KxrJY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SnyVy9/L";
	spf=pass (imf22.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787071841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTU8H2u+NkWTFqoqcUCVCeMhgZCEgOsNJ/Edfa+Cbgk=;
	b=yxmtkqP3O8toTfAdmtnEUwmlzds8sQyDtG9WvFoEm4TbV3zWJHf6yRWuqlcCQz08BxYLbX
	lF4u9TvtzTCLFW4qfyFX/1RVCSylYhuGQudh5Nu745hQGm/fz1wB/Oyl1rm0B5e/JV3ZCk
	I2QOZahJ1/DyN5CFVFhtHRGprLsWpko=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38de693676dso106492a91.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787071840; x=1787676640; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jTU8H2u+NkWTFqoqcUCVCeMhgZCEgOsNJ/Edfa+Cbgk=;
        b=SnyVy9/Lp7ALfEjM9q4a5wSLEuvWTA1WQiUcwc4iHKEfeFngh1lZ/7tnmLUGS+cPSw
         z+LwPmUHeHTPgoqJ/SlNcaldiii+/zTJJtc0zfd842SY+b1wMN4YRiGLVw1Y9w8qyeBy
         wvnwXdWLdLV9xn4bwQzFEkXHq86pMLJAGaKDxVVrDK31HKj2b+T46Rc7Lb6mMHB0ruAL
         MRdyzmd+WQ5cMBCP2mFPdOJ9ACQDrWbKIdXoiAHjktT/9oMGpVruFwfAv2l0TInnT9eQ
         mPYY0zxot4wNBsXVVqXOewotYyOvU9erJyNemAhZWEi/31E3TtC5XtwlVQOylfSvHoF4
         mVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787071840; x=1787676640;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jTU8H2u+NkWTFqoqcUCVCeMhgZCEgOsNJ/Edfa+Cbgk=;
        b=ef2Xj0G1PbnIsdUIUiGSyItPkZ2ySKGJW1fsKQ0sRzNV3cL2qPlRQD4lpOkz6Mbfuz
         QB0Ci68uUoSi1Xm+lyLXz6FmyBu0qXlt1DhBVDR93UffwCKUAUrWkj/10v4++IbEcTr1
         gr2mRWnut5vMJVQpSG5n3cAWWwREIWgIRdZ3bpS2kGGcTv/muT1HhhgLRH0SVaPU0xEE
         eUwSCCOeUt514uGYrUQjGCF5kTVyBE+UWmjaHz64Os32G07qOO1TS8+BBm34zjyT8vDo
         xwEsisgVqSd2dpERiYvmWsOuWE6mzOhcEqsTjNwlHBqLNm4IQIXHhadJDaXuAEwIS6tZ
         RncA==
X-Forwarded-Encrypted: i=1; AHgh+RrZv+Ol6UUW1BmNIwFmWJnRHDgFqL2/rHJ1EQlZyKT/yGBZ/atIry33dgUKZJh8y6Lc0RpI3EfFhQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9c9M9cs+LeFbEWeMA19ASFMa4eZk7Wqq2Q6qihQvZ0LB/sdxj
	behWcgBywZ2QOqz3cdJVVAX8qQyLqA8U6O3njk2396r71s+Fzf0DDOcuy9UN3K7F
X-Gm-Gg: AR+sD133rcogWK04tZza0SvjUhoGjJduNkHiEraoBIeenvf0/b13PwLvqBh6vI8bHq0
	Vb/jzgAiHj98xTmtpjGImUiPnLMi8jGha5OpDDu3v0rqiFMZSMQJTioJ2YVf3ZyLDPs+xfe2mmx
	FpFTka82ENocvIH4Gs3gyKC/QnoCHPOEtPmquQf20xKjHgzSOBWeeh6GJ/UVnOZpxrBXCJ2hc+M
	VS1tP8TjGMnShaG33HHhUZqK/MQbGTk87PLHf5vzbV33ZUn41ADjkQTmb628iuP2uhCS30BZYEz
	985rUgegLxE5fHf4mq+kDV6Z8v+oNfFWvrO+J5wmv9+pFhhsdeoKq2cCPYPpmiQAHvfww7bMsBf
	9IXfQSkmS8Yguyg3k/XRw1uszEpD+YptXW39Pz9iwQfael6ymGHci6txOMpK8gPEWbSpjTXpWQF
	zCtHmAW9veIw+sH4Nz6j/ccZdaJ5LNreaR5YKDWa5oMzpcuRM0fHNuEDn6
X-Received: by 2002:a17:90b:2e42:b0:38e:6d4c:14e6 with SMTP id 98e67ed59e1d1-3955a5e114cmr14548088a91.3.1787071839720;
        Tue, 18 Aug 2026 09:50:39 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14157e53079sm9907526c88.1.2026.08.18.09.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 09:50:39 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Tue, 18 Aug 2026 23:50:34 +0700 (WIB)
To: Suren Baghdasaryan <surenb@google.com>
cc: Foxie Flakey <foxieflakey@gmail.com>, 
    Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org, 
    peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <CAJuCfpEOF3=Uu3cvoiH0tJoJhhRmwR0YLy34tyPC-2EE09xWMg@mail.gmail.com>
Message-ID: <b248cc12-e083-ec37-e6f6-2a57e8cccd3b@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org> <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com> <CAJuCfpEOF3=Uu3cvoiH0tJoJhhRmwR0YLy34tyPC-2EE09xWMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-770231571-1787071839=:6306"
X-Rspamd-Queue-Id: 00FBDC0004
X-Rspam-User: 
X-Stat-Signature: uewnsq6srhtz3y5utbtgi3e64id6guu3
X-Rspamd-Server: rspam06
X-HE-Tag: 1787071840-627744
X-HE-Meta: U2FsdGVkX18IDChwW1suxuwfMAOLpiOg0tfnjrqxCl1PW1D1Ocz3vWmdVfA1qHzjkYPC/n5LZ6QmC84pxiuWPHsWc/5uWJ/o5+L5JipiPLt3BdFsZTLhQvr3Eqvf2/7xTh8PpmrR17HV85VH+82bbSkUtnUcFp06QfSCaiYYjRB8tlhbyMAOp7Tnm4oY4SKW24TptBhmt3eQTu3MaDVAHOoRiPyBK2OWTZ3bFCUL/VlpcmbsZQ4vWVFNoy+iWV+AWFvnHtn7Q52MI9ri9vZv0uywaFJLQzg+U0iriwLS+A+nFsOV1bECAwlnapNLsm7yglZ0P7dyiIGJ2vX8jCBp68QnOspWl/yV1f/UIYjTDycqQ8x9kgFhoSzFwslBKg8QTdwrCkTtYzo9wUfvVqFLrgrOon7w367OOUlbtS5e6iPvFe+54MpAxBWvesDZZR0AeGfWLg8gG5MU1gS1yPocy8D9SvRyJcverkQFbEbuBC8zu621LnhyeRuXzIXmu3ABm+ftEmBPkS922uMJiSfPrCeB/vHSjpf/AB9FC1I3f8e3z15s5juJJrWePe1yPoE4bnwGdoxFC2/QLQrUwQXvoaJh5ZtK5xZg3esf1RvVRypAc6/TuFi88LIBZvaDvkw3b3RhX9qSOjXrCl5tDtFepR5gTbtnVuoyAp8AQZDJDPYgsO8qos6KznkO8M32KVneme/KR5q2pugNnU86i7swTIjSnrUmQ+ihLnowDb2uqqfwV6DI6W1Mvy5AjVnHUF9Nownw4E2j3bqGgRt0RO2h6Um3rb9w3oEMMCdp2ntsrae/niB38Ikp3nWsPTclFl7gw5KBixYrJiP2Yv0wy5NxXHCLNvw/MhYC9GWWrbaaVBpd5UjvBu23hmQDlMbmr4df0p0BjGkMz5QTjiRrUE7HcUmhhK9tUujxQoJDwvIRjHWl1G0DIBjdGM1ffEO02qwPAtZs2w5zbfEoiXoEpaG
 fo9Hu8SB
 qQ+ZYPcLVmpQmwqspkpwiADoiH2RH8sqTm6s8aWDGuuh9v6zw2EwCQSBgBmCr+PM8tAZcjma6XkpXXmpn8dR8sztJPcQJK1i3bilVPKQCfezTYllRJUIVAiAv2OCaFkBesDe/HHFwQlESgDwH/DbIcZQOi9GVPy/Z5DEaH0IE/pRHL/pdinenJ/BNdKRLBgy+OgrE1k7HsAR5A0wJTmzUH61STHQh+cD3W96trB8rAXpe/3bC1aO2QQGyj/a+TWh7Mdl1ijaa10cu4PGpCf1LHp+NrKCvl9fi/0OG2wQ7vROwzJqluPRU4xhw4V0Yd3Ru5k9wNc4yxao5Z7eTq92fC5QgksSHHra9kCxbyieeKjOHaymGeWx17DUFnNkgwcLS6eTF80jQWINXWe3kEik2zJeAuez+sM/nz2FrrVhkVHS1Xs0/YV6wEH/A6oUKYzE52XkXzV8wrx6Zgf0ubyFvfGUH65JXoztkN4PpUraVHkZt2P4lI0NQHVKBV3L6lyUOvtxPAxqSKlyrnhC8ggo1hnhJ3C9dcN2PzBqwYJENv9C7ULwjReSgqCKSk71E6dUSPozSVHXwdfjPt3wy5fGcb0jxWUzTVIi+EtPnXREMnW80QCSpbppcqIqq76SOeay80cg513+9TR7SlEI92Ryz4GfSb7vB6tA9HSB1BjbnbRscdO7YrfKDLVnNamPSujlK2Mfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-770231571-1787071839=:6306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 18 Aug 2026, Suren Baghdasaryan wrote:

> On Mon, Aug 17, 2026 at 6:13 PM Foxie Flakey <foxieflakey@gmail.com> wrote:
> >
> > On Mon, 17 Aug 2026, Andrew Morton wrote:
> >
> > > On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:
> > >
> > > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> > >
> > > Yes, the pseudonym is problematic - it is contrary to our written
> > > rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else were
> > > to send me your patch with their signoff also, the rules would be less
> > > offended.
> >
> > I see, I'll post the updated patch and work on signoff issue later (there
> > has been updates, I haven't posted v2 which updates the patch and
> > description following a feedback. Why I didn't? mainly I'm not sure with
> > answer for signoff)
>
> Yeah, please follow Mike's advise.

Okay, thank you! I'll re-ask Mike again due I'm not receiving sufficient
answer.
--0-770231571-1787071839=:6306--

