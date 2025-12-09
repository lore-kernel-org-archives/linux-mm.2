Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D979D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 12:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FD06B0008; Tue,  9 Dec 2025 07:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600A96B000A; Tue,  9 Dec 2025 07:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF946B000C; Tue,  9 Dec 2025 07:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8BD6B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:20:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCEF31604FC
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:20:56 +0000 (UTC)
X-FDA: 84199841712.14.D8D4490
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0DC6A1C0012
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:20:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Df386ezK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765282855; a=rsa-sha256;
	cv=none;
	b=vB1/KUD5AuJMdTSUwFyaAjVcsEeleGu3oVN3IFgcJs/dG3r06H92Yu7MGvo2Zt/mZoR7by
	PgeO54B5ACKRyJJO4dYMSqi1YimouM9+26WWJgYEaj3q3Z4mIQOKpd4hE6arIVhuiQY4xl
	sqfiaGxaolM1cDmT5YQXjySEPRTpGCI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Df386ezK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765282855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZJ/q2HbA4FuEYRTrl5RlRoMHzWJPZwJ2pv4mVX9pX8=;
	b=BxafVYHUYVXjjFnEo0+iNo2kT1sGJPTPOXNQHdzxrkxbtvnCIo6WFCGaDnWTWsI0Y0RkrA
	V+UYifJ7rG48FLhYF1IRWJq1zKE4a8oBH2wzv/PnfPqqdx1vVd4WN0wKYXLI8u1f+euPRa
	X+ZvGFAZWHeHk01yRcl9n0WaMdQ5Z4Q=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78c38149f9fso23444877b3.2
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 04:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765282854; x=1765887654; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XZJ/q2HbA4FuEYRTrl5RlRoMHzWJPZwJ2pv4mVX9pX8=;
        b=Df386ezKStGRokbG8if01phia7kgYGSRV2cg+hrgupZMJck+0Jd/xrD8Quz+va7HKm
         FT4uz9Qd8bt8lcawFwOCpWWH/WdojuT4R1Jaa5RgxCd8NEXLKvVKIjhp2k4H57t1SUee
         V9D8yEsoPALmloyOpTymvRxLlxTWCCgRdWI4rPmU1mHsMcjWcWZn7jEt3711MGwouR96
         EV2yogO0Gsn0bfr9MBaiY5IezWZT8aw4l62KDlaXJrlmPD5jQfv5oHo+UJgojXtb7hiQ
         /fKwATzZ5NiUx7cD2aNndbrq6jbSd7c7Uz2vDPLWTVlCbjWPf0W/vWl5boU/PVHNFRmL
         fipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765282854; x=1765887654;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZJ/q2HbA4FuEYRTrl5RlRoMHzWJPZwJ2pv4mVX9pX8=;
        b=q70MGlsj4c5l8utZ/olK4LaxBnGUm0Wv1lwGqAoQnb3AKMR9YxSFug5vziH7ycWd0l
         TEGaH03upXVylp0yGS5lA1UcBmHlyfdqDlkzMwAG5kTfQllDzlQeit+1RU2io+XOogiI
         K0UAAxxBUC2qdF5Vwvej++N2GzjkAEmo14IwiVyQ4RVCW6STSV2W+zeg6qSfTBuAeU7Q
         qvuBsmc0nv4xvmPfcioGSN1k0wkIG85/ke1D2Z6d39wk7f+QyOfLYe1tnBdMFKgfGJVV
         fHKRXR9bOEEEqleuuBs3ao8RQPiKyL9aAH526T67cKPVnpGAaKmPpe1Wf+Gb2D+rc/oY
         9SvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTM49NhlIKW/GgL3WNkSLp7YS70O92n0nuepBMevgUESev/3hgDpRNdNIM88uHjU7lQoRBSwj9rw==@kvack.org
X-Gm-Message-State: AOJu0YzTm1r1/iFXqyQ4MEAHappNZdQITGg4/DpmRpYKh2g4GkIj+qza
	4Vyhk84DmGoWEQq9/IMLElGYVXSfhluFZcPDcJVjhILBnbZEKsOS7F98HOMPPJpqWQEPStjPv7J
	QxNglbnH9H8lPD6PYvtoWo/rTRzPMeemhqFe4rFU=
X-Gm-Gg: AY/fxX6YkGvH/fsv0q6U2PvsJXS7btE4YPGvZS8xbpx1xjzj8pgG4uzP+TaxcEDNFOL
	4utL1Sjxt7HpHH4pPLN4FNBmErlnludAwkjwKibr0GaPJN0yRTVsWGwYrXTxH6xjfIJyXYfrlij
	FDad58sRGdyJlYrgh/JPqx2QSHx6QSpJHl1V+0OGNKDAJ2Saf2AuxLOK64FguwI/Ys7Eq7X3RBb
	cPPFd1rIyltaBp1zr1tjQ936OM3W02aEH2aT899HKntN6yr+jgfUDufwFJgjuhuBqj+p2Ao
X-Google-Smtp-Source: AGHT+IF4qVNyyFQhAQ44HrKZTO+BDYWue2tjOtQ0ldbioOqiAYBKibcU6XKIYYlyd1/TpiMhH9iPXpGu0w3y1arhMa0=
X-Received: by 2002:a05:690c:22c2:b0:788:bd8:673 with SMTP id
 00721157ae682-78c33c16394mr103464237b3.44.1765282854027; Tue, 09 Dec 2025
 04:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20251206224724.13832-1-rgbi3307@gmail.com> <20251207023625.44177-1-sj@kernel.org>
In-Reply-To: <20251207023625.44177-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Tue, 9 Dec 2025 21:20:42 +0900
X-Gm-Features: AQt7F2q9hsT8FOu7rr45aQ_Azbmj4EMMy0e-8Rt-6hhhTyywnYIFfVlP3APSEdA
Message-ID: <CAHOvCC6_-h1jQkZMbtYDC_jrB490jzp1t1Fx-_mhYnE7tqvzbw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tu9g6yu1atzryp8q5zcso3ogmeff7jin
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DC6A1C0012
X-Rspamd-Server: rspam01
X-HE-Tag: 1765282854-278360
X-HE-Meta: U2FsdGVkX1+jXvyEwswbAGlZxIjpDv55fPIIRthvvNRQX2CrlACXKsVtpdfhEsbMK6ruuddmDJ7uNF5wr1VFbbBuMcc45av4wvpEeTOYsNdeLgmWJDamhGDbD/KtbVCpdkhKXvbfW4CXUOLkReTXcn7d4MjHx7E0sICP3Iqhhvld/To6s18f6jIMpCUZdEnVa/kn9JJNvMBk1uLpY4S7cXVjBKXHZU3vzdrkCpVKuFbvGEpE2VfaEXSjB9DjCkielsbp+RfhsLBEAoBpDp61mg1NI7pvtB+JlNQZ29Wqf/OF/DClN8WUCAcg4JRV9rowoopgKkaEtno3plfeqHqTuAD0aziOXwjO755N0oF/RjZGr7qT0U7jy70b48r9/EUfPmuy9PXzzRgVTqUQKiU6JjrkrKPrR3bW6s8g4SaEdKnvegvkm20PpjdKUTJIRH3nfSad+G1Rm6horocz4JhKlPxGaExtssqHLD30FCs10HRQHTOELFE+HXDF+WGXGBejR0JbgUW5zyBa1Vym5cB2e0k6mpWu8y9DgYnUi62CA1EzsjrJ9qe+h9lA80gN9haV1Hp57OHpxnrbP2GxRjxlD0GMLDo1MAbBOwc7MTgLD/0AcCOBNyT2lkHZrawFcmnF4Vk7wYCfK5/ACzfzvSzKiufQUO8tWwADcruTkwaPoyeENXzGdgA1ztZsnm7wpgMAqZatVJTVJFC/Z42ZjWuHH8S0vsTIugv+ttRwkcQBKaiBrIkLAjsBSYQ4iwxBp7prUDU+Of62ZE9coK8Ti3VMd1R/kyA2dXoHUfBecu1lsCaPV4Xxc/mjramkeO1Cbn/scN/WsabH31cLlWKAmfOjbAynNEV+RweE2xRYVF+smhcTjC3FpUmCwE3Gy8Mib1f4mBlI5wPepVcza0mxnPkzW1/Uc/ogJ3WiBJGWGi5KL+gjr8UqlOfRNd8Kxfw+XG4l9gDur4qg4So1wDoQtNI
 iJts9NPJ
 O84fiZGV34UOGH8lw20J7Cbs7p2rkjMlSZZKewe60KeSctSXAt7lS6c0vVESUf9obSIaKqZY12+NxFsNG+5rI2v2gSkcILov83X7um6OMlY1bzID3ZBxrNhQLYgAmu946f0UNkXnXPMHFYRGyHuZzUgMOYBntZUpZYvoX8zywXidh5bzjvvubolOTz6wA59c6MSuj5q1E1PCQ6IyyiB2aIoxJCjnDeSNOLAGgXiZkxK622SnxQBxZFh2Wn8PYwRA6TEcCrE5qx+aRTRIwOw14HGosdDxnQX9x3aAoeMHvrWQzEw/hFSM633mLdhFmrcvdRSl7K0kohNeKjQS5D8iZGiu9dCuO18SGnCrf2jLbMYSCD+eZKI/cyxx3D60UV9dmSc0KQj6Lv/Dc3AGLOb3FESZNJtLelvLI5D8BG8kJ3iQixDVC778dmHYmqcfbx3zN+BVb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000127, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, SeongJae,

Thank you for your detailed feedback.
My patch has the advantage of removing the use of
the damon_call_control.dealloc_on_cancel variable.
Other than that, I agree with you pointed out.
It's not a patch that significantly improves functionality,
so I'm fine with doing whatever you decide.

Thanks,
JaeJoon

On Sun, 7 Dec 2025 at 11:36, SeongJae Park <sj@kernel.org> wrote:
>
> On Sun,  7 Dec 2025 07:47:23 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > The damon_call_control structure is used by all damon modules.
> > In mm/damon/sysfs.c, it is dynamically allocated with kmalloc(),
>
> It is only for refresh_ms handling damon_call_control.
> damon_sysfs_damon_call() doesn't use kmalloc().
>
> > and in
> > the remaining modules, it is statically coded.
>
> I try not to use dynamic allocation when possible and *reasonable*, since doing
> so eliminates the chances of bugs from dynamic allocation handling mistakes.
>
> > There are many daemon
> > modules and they are designed to be used only when needed.  It is more
> > efficient to use kmalloc dynamically whenever needed as in damon/sysfs.c.
>
> I agree that is more efficient in terms of kernel size.  Nevertheless, I don't
> think it is a significant improvement, since it is only single data structure
> per the DAMON module.  The total number of DAMON modules is only five.  Two
> among those are samples.
>
> > Using damon_call_control dynamically and consistently has the advantage of
> > eliminating the dealloc_on_cancel member variable condition and reducing
> > code size.
>
> Disadvantage of this change is that it is adding four more dynamic allocations
> that we need to cautiously maintain.  It is not significantly increasing the
> maintenance overhead.  But, the advantage (kernel size reduction) also seems
> only modest, if I'm not wrong.
>
> So I'm sadly have to say I don't think this change is really needed.
>
> Please let me know if I'm missing something, though.
>
>
> Thanks,
> SJ
>
> [...]

