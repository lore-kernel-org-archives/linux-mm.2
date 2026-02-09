Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DAFDE94605
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 20:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E556B0089; Mon,  9 Feb 2026 15:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6066B008A; Mon,  9 Feb 2026 15:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D176B008C; Mon,  9 Feb 2026 15:57:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A12FA6B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:57:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20A52C1676
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:57:01 +0000 (UTC)
X-FDA: 84426127842.19.8F2224B
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 573D820009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:56:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uTbSvApD;
	spf=pass (imf13.hostedemail.com: domain of 3GUqKaQ4KCCoPUXJGTXOINGXJYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3GUqKaQ4KCCoPUXJGTXOINGXJYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770670619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fl9o+jgbnaLJ4/LYSzpCmFtZ2ZK5bIMEd9yGhaWj+Sc=;
	b=uV6YTuP4s0wg/dJRu1F8LQEn2PBT+FikLo6h8M7B1Ik9nzTEdyjyYULhSzodRmMYfDdthv
	/LYxToMv+RqwknaZ9sA695jLFjAvD68u+OndheJdFN6wvpx/bnE4byeQ0Xxvrtx/FHPeAS
	DuG7FgdmTu3gOc2U46eHaOWELYmXJxs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uTbSvApD;
	spf=pass (imf13.hostedemail.com: domain of 3GUqKaQ4KCCoPUXJGTXOINGXJYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3GUqKaQ4KCCoPUXJGTXOINGXJYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770670619; a=rsa-sha256;
	cv=none;
	b=RelV4lRP99WV0+hbDBAVb3VtiE/BY7ke95dphooXXqIT8aMfYHkZLpsx8yEOzL8lAsMWun
	LrYSKHN797QO4bA5JBRmtw6O/EtZypamZWMWc5e49OHeYjTVShWLXBI9b9Gf50SsySIfZG
	oa2pfTpSLkvuUIL5noxdb6GcuyqwCvk=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b86addb8b1so97195eec.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 12:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770670618; x=1771275418; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fl9o+jgbnaLJ4/LYSzpCmFtZ2ZK5bIMEd9yGhaWj+Sc=;
        b=uTbSvApD8SxgSTKPRAPjsnLXX8ms5CZJQqHny5lqtz7Afw5XCbV+xSnqgHJp536IFp
         nd2vd0s0734x30qP3XcRhpmde994bAWDY8LS6P4B37yDbKzADwOQ4+nSNo0mPUMuBDUM
         JzTWTmJub1YIMk21LD3PjDO5ua7NE8uxOYpH+z5JFf/SeGDmvOrrrPOijpa+pVfasKnl
         RDtfyBUUtPDzqYZ0m1GkLdn552GiMM7TatQ7OPSaRIXZuRul+Ox052S6jCJAkaLS/xrc
         eJaWVnTtnYyxP1BG0Bbd/VorMgl7TCSPFNUGO/ckE99a1eREae3ONvvvCi6rh0+ziHfb
         3IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770670618; x=1771275418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fl9o+jgbnaLJ4/LYSzpCmFtZ2ZK5bIMEd9yGhaWj+Sc=;
        b=Gk5vva12LZ16v8IWQUPg8NVDtH7eOgpi0oKR/z7hrwEOyI6yqfAUqrPdVVfqrXd3Bd
         YpvpYXyU83kK7PF6Nn4JujYkYc9mRmDzrgCV/WsY/Nh9glPzQ04oo8KbHkjVnQOt3r12
         W1297Tnx+9vEfTcbmtqe90ZVdEPIKv+SWWvV/9Xh6nY8GdUlFHTxUUM2GJlAv9D9x2mg
         c14z0NRUiN3UAZ/phYav+PzKcEUGFz+rIithxmzkwlPOblWNx9hWDeTY8XESi4DZx1eA
         uQ4/nHK/8Dz5iIcDyMlOzfdRpOpKPLnxzb/CsQltMyTfCDgFjHFDb0FpCyQoi5I4c04S
         tMcA==
X-Forwarded-Encrypted: i=1; AJvYcCXtXLeBM3KH4m9IWqeOKnacehSL9BKhHQdWf9g1B2JT+6/RaWOu/R26rffZlWr20AbRA1U84zc2dQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0sqHo6b0PCCQ1+8BMSY3DQOaAiQBDqEY6t3O0VD8jrvk0Q1Ac
	sDboQ3VfIbzWZ4+wlPcFMCtyfvx2yIlmjQyQ7fI2ehHtzQ8ctQN9xKGpnc62eDqhTrhtSUhOiUg
	BbZwTxCzHKefgkBXIzY80thtVhPYotCw0r0GUmg==
X-Received: from dygg5.prod.google.com ([2002:a05:693c:80c5:b0:2ba:817b:8bec])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:2383:b0:2a4:3593:466c with SMTP id 5a478bee46e88-2b85642c7demr4739454eec.8.1770670617874;
 Mon, 09 Feb 2026 12:56:57 -0800 (PST)
Date: Mon,  9 Feb 2026 20:56:55 +0000
In-Reply-To: <98e953ed-616c-4684-a8e1-87195349ef4c@t-8ch.de>
Mime-Version: 1.0
References: <98e953ed-616c-4684-a8e1-87195349ef4c@t-8ch.de>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209205655.119562-1-jordanrichards@google.com>
Subject: Re: [PATCH v2 2/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
From: Jordan Richards <jordanrichards@google.com>
To: linux@weissschuh.net
Cc: dmatlack@google.com, jasonmiu@google.com, jordanrichards@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	rppt@kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ujf1tdrhkmcjafqfqgnxo55epi8i3h5j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 573D820009
X-HE-Tag: 1770670619-850322
X-HE-Meta: U2FsdGVkX1/j2nsMfJuxkWKJUTQgH0tbaEB9IsV2OMrpRq4RfVqYVvhuJ4PSecPh6lj4KFstrR3nbrqS8rsZ7l1u0Rr2VZs5hGxQe8X/nXIHfbLZfR7lqLX0tBHMHHr1tpmmhMQVXM2d1/ylaLTzCA+b6OmpxLOFEs8UK1Wb3rkF3AMcnFhI5wEmkfBE1VKWV9WhoXhiZjApad7/Bw0xTf99r2YWUHnHQvXqpzJI0lXEL7P8IiHzgEKD3tnU2qQ6NbJWKBU6S5WBslkrx4zAdiJRGtsSWaX1lyUr0rdD10ibmQOh012wHRMV8qOTFxHCDwsJZc/QRx/h9lin7zC5HW5+h8f+icNr1JsnrkmUXf0Y+5zrpMH8kSjHpq1JcT+3IUqTwOCuQTSywrFPO3BotrqWEySnOjJXKlsTFxebHbcq1WDukItTuy9KlgRUYfxdfPorfrJ8f0GKikIMPPbTZVTtXUNPbfJeyDdAFGH3jut2vdxvGcfMOnGy89Y9RzcQg5xCMHTenIp+TJAKVeSDuiOmWesDH1KSi1wpCMGxJPYa+zd/I0fsEM3rfyWyUUb8COU0v2qt+1cCCARpA5BvO1apQ49GImERCt+8JPy9Gu8ZXVPgL4I+9f+MH33pPVPAm9n6uPRq6gSY4GsVzxKuhFPYGD0XL0KOYsUvvm/mu2WgOm2NLnWJqqTijSnGc1r4clH5cwLFk0dkrTAN0iKyFNhHVtO9Dpmexr4r8KQ1Amr6k7L9+aEGvknBy1ZYMn4lq40UHEHO/l3fqoHyHm1qNp/R9l62t4Ew3vhuqFd1dksmpCUaVE8pYj2Z1Rsz0mxZmnDZqZlug53SYlNGozA+f/NpRELnKBV0HFbBJBvbQyyqJ9YDXT4rewCOavMBJaqpZ5k7rjf2Dz6Pxq7pDTiOfucSCbpshoGaLZ7FURr0w6HgqdOUkXOrRCdrheEx/BTofi3+lFDWh/MaboZi7fY
 ajJDP75c
 PUPrlJYORvW8AAG54ZmII4N29PEI40nJ3EyV1hwbAglY9DjpaydnNeeNGXIDEh5/w9qtI/U7cGF761BdSIMsfBWzZOrVTWO297ita1hoKY4Mouhp3WIAgIs+HbtOzvKCnS1+zQHieyL1/HAL7hZNSPuEvjYdjb/MKwgWe2m9as77EKhV9iba8NX5iRemBeknBR+0Qtc9iKDJX/FW4dFibscQ5jsx5V3BdDoxNQpTJJnKf44N1ERoBQxhC5GG/Gaf+wn+mDMKYhTyy/L3mLpI3UH2aMlbxrLTEJzZCqa9Xugubc8v1NXEW1ZJwg7xK28M1a4UemW6LF72sKfaTtmRPKn5Z6k6YzMuFNVhUykAnNUANgcHMcG7XEzIYPleH+1Ev1WosLPube9IhLWM4Al62HEKi1qWFj/9ponAf8zTC0OPctV0k34Df1PhSlMmL+vQ9CVF60CNdEUrzq5SFcJ1OhRM4+sxwBiskhjIc+n6kAxE3inLZUdsnM8mLJ+DI6mKFE/FwF3/4nQPdkN6ME7lgEsSwEn9s0u235YteqY2kIsqMfg+AmLsayHcrbW38TwaV2e16JBY2HKzYvEzldtWEUPma418jqP+Yi2CqGhKW5AzMgNCETD43IpkpLNVyM7jEgg/zVeEAMtKnxH1Qwk/iL1Fy3KHaeP5OPoRk2WgaBR8v1CzMQXpsxKJDNc+pyvMb56mu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +#ifdef NOLIBC
>> +#include <sys.h>
>> +#endif
>
> This should not be necessary.
> I am actively trying to get rid of the checks for the NOLIBC macro.

Oops, that's no longer used directly. Will remove in v3.

