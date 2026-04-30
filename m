Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2482FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162E56B0093; Thu, 30 Apr 2026 13:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A8F6B0095; Thu, 30 Apr 2026 13:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0296F6B0096; Thu, 30 Apr 2026 13:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1D696B0093
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:25:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D76E160160
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:25:04 +0000 (UTC)
X-FDA: 84715897728.10.83659FF
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A631A0003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:25:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ATsjGa4C;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777569902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McFX5gNqOvKZ8pnwMW5W5DukXmHwj3b1/6EBkR+5oQk=;
	b=AX9ohsfDNKDO02dcZUIR3EJGePd0kB28uvwoZuVVOt9xQAV7gvx2rxsmsQtPT+6i6cIE3i
	Bv2rnJfekY24e5RbaS88K5b66OtnamlGAlIugi9sAezyguhTtWQOGdEPlJmUuSlq/HtDQZ
	4fAaTeOw2mVNKq1xkXHXy8Gcv2hkCcE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ATsjGa4C;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777569902; a=rsa-sha256;
	cv=pass;
	b=fp8VPYq1u4tZOd3CCE2S2ezJ+ftx8uv5EcelxfCZpvU1CkGepjxLQ/kcVPwaLXVsXHQmgb
	Ncvp9thAN1iiQDNY2qKxSGZeWpnKXzN1rw7177Evz3BrqlDT7X1vP8uyOON9C38caoBUSJ
	/7ggw8GNNtCDU/gl6bARNuZ4rZcg/pI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d6b393d60so39061cf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777569901; cv=none;
        d=google.com; s=arc-20240605;
        b=Ar+Hcsms1tXLLDDNeGUUZic1r9ghNdS3jdv9yPzp9TDqd4Pi8FOepAQlmPl+n+tFnZ
         tq5lnH2Q4e5KHLFZgm9tewPDCvzOn/Fw6ONXtsGdTlFMEpCdGUTQsiaAxtPeH0OOCXJE
         40Dd7aw2/K3DCBfQXZWxqdH3+D/8zwliL+o8WPWB5NExwRi4uCD5wtPEM0M1yVoUOpbG
         3aMax7gPPnRxneeNaJCc2EAXGJT4+lfPUZ9k4zSQyc6cQDlYgh6gf+8djkwt+km00SOj
         PMCM9B1O3R0/JMZR+PYTRdxnYbInFOEQK1aBKW4tYQ55t28gThVu+cF2bKjrVaxbNYNS
         0wGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=McFX5gNqOvKZ8pnwMW5W5DukXmHwj3b1/6EBkR+5oQk=;
        fh=pzxI2AGqkb/UlVv7bWcGmAwdgWfjGT7UyYtAzFs11v4=;
        b=BwLTmgfuJeYhLt0zLbZO+PeXtmHChPGMILrmGK6h2jr0Q3WsL9YJDDMXOOZcwurodX
         iw2lEUBR7RKqn798w+nVp//DaxFojwwxCkVzu5+rFche6FtoaGuo27Y4ItTFDJpTTjFj
         ZaF7XWemUKnLCsR1Sh1HNjuzbMoWK6tS9we0KNwga6Ug0Sx7WXhgFCnE/RsI6O6la1/E
         0EejfAGvmOfhX0hYNXOi+5OQAI0Kx7Ag0J/BZIl9jPhspMlVKD+eptgG8YaWxTP90J81
         7sBkIGA50aaCshXRnjIdwuBXTvg+uwePg/PeFXUk2Tfz2vXWby0iPSccRFHfDXtrU3cx
         2YUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777569901; x=1778174701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McFX5gNqOvKZ8pnwMW5W5DukXmHwj3b1/6EBkR+5oQk=;
        b=ATsjGa4Clg5G1wkcD91mIdOHbXT4/XchUuTU9eHgdFGQxJEZdQ7eMeqXYCJsEEKpWC
         /RrHMDso9ctHyUAUcoyK/isKLz5pLBNUPEevrA4EHlcs+0QPBiIox+Hm6R7W7u0WHcRm
         fmXUmf5L6Ju8v9bpLy42RkXZbqoBr6+5/flRHr1m6luYKT3WP3tnve9UAl8UeuZvW684
         MFnK4gWtEzYGZBwOeAbnLR93gN6IYl5WT2WEkbHszpLtrQfBNlQ/NrMxCi65lEh+VrZz
         YU3K6DDX5GlU0g4kiiIEiA+5Yyzxkb/UNFGd6lw669hCulocTT8KMFpOC4rbF6+muf5W
         y8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777569901; x=1778174701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=McFX5gNqOvKZ8pnwMW5W5DukXmHwj3b1/6EBkR+5oQk=;
        b=KDk2A0XMvYyNjPovrJ8DkScWE14oQkLckT2tV6skFW7kO/YQaNLAqlCT0FOlmfVSd7
         ETJH/Xl2NymBWHTggJcXlJsyyZfYyc76EABij3nkZrSnOj8YYntAQylPwDv+9frfPKxJ
         VnIH2Zpy2CHHAachYQvHRYQ6S9ZAiP1HgqvpfW9XiH6dUPcmLwZyxSNR2swuCqnFM6/h
         2RKGxohm1mcEhv2WsJHQC1A1ogWBngGlCCaBK+sJ+AcfWxD+fV1cTNtoh00J2Ya0QQCf
         du6Z2hxgX2JWPZUyQdjVzQRCvJx9VmThFR9GcWUZOrAyi2extev4JRwbh9kjt6zw5D/L
         j6wg==
X-Forwarded-Encrypted: i=1; AFNElJ98SStFnwSU+jQlkxMdwpXWqLuRUiSyjtW0kcxxAmnXYAECLQ7XM8y3aSgHY6NjbDVqGZDGfMaIAQ==@kvack.org
X-Gm-Message-State: AOJu0Yxq0yuLYApaOocSWAqw/p0Gl+JAhNqhQx39jYRE2qklumPyelu9
	rszyIAWCBjf2OmHILQhrQdw3iksPlNtKoiNRhJPaMgIxeaNKYx2hLurnTDiztvJ20vu6YRwJlE8
	elVcQtaxZrmOfFy7iilD7KH2r4uNSOcZnbWJWUvR2
X-Gm-Gg: AeBDiesz9jUyr1F3s4Wtpz6kms5T1R0lfB5NS1lcSCY6k8m2fzGOBpF4Kk6nvHrW1UV
	jKTzU3Jbe9pdKCma3Q6xp8UMo7z1Z9f/pB1QtrhrN4UeI7RaFs3eYM5sAm2LfUHGP5M8yv2s6EI
	rXjLtTzFqfDgV7EoPmwQEDwzt3RzzL++0bDv/gUeCSCHJDBAXIZKQLq9s0G7y44axWcfePYg7Em
	eEWOcGUbj4Opu/DGLMfViJEJJRUDaLfU7bBnq/vi2pH4+rIqbeAMpZnSQe9MtXUXVPcpY/xlBly
	pPeninV10jays9cSGaFiCMjjRZyx+h9CxWh2I9YZ0pxW0PVm+4kzsKI43pI=
X-Received: by 2002:a05:622a:8d03:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-5103d2bae05mr306371cf.16.1777569900870; Thu, 30 Apr 2026
 10:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260429211359.3829683-1-minchan@kernel.org> <20260430074305.9d3389ed71af040acfe222de@linux-foundation.org>
 <afN2GBAjBSGlTgvA@tiehlicka> <20260430093423.3118ff0f295a9719cdadd91a@linux-foundation.org>
In-Reply-To: <20260430093423.3118ff0f295a9719cdadd91a@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 30 Apr 2026 10:24:49 -0700
X-Gm-Features: AVHnY4KtYPqXaxorbLC2XxEQGKcXLI2PBWMWnecC4yRS76p9u238IBXgkQazEmU
Message-ID: <CAJuCfpEwn-q6j3UFnB+OZAWm2CRo0uCyjXJSNiZpQDFgE7vZgA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, hca@linux.ibm.com, 
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A631A0003
X-Stat-Signature: fkp5hc44rbpeczd9ecn3deaqgotfypiq
X-HE-Tag: 1777569902-914484
X-HE-Meta: U2FsdGVkX1+4RXVmIS61a5CH5O36Tgi0UqwuNPDH1ZsQ+ZMkMcWiM2oMeW5bL/EbymCj5tmlOOzX+kh53dL7sXRGR/nY7OHUsZO5tbMOvFVDlcpxKMzLc6LRr9N3utgPt+Ki17oNVTJJ/H740lIJHoSvPwNsKfEDD4H9czTnX1vtz1wPobhOJ9RHE2Xb5IMUbr8QQqYIeaSIludc7inuT2RUiKl9sLC8KQUY956dn4mSZeLVaTrfB4RH7yR+DMTpbtTSy/8xNIOSXsLbs+FAGtWUIKWRUVHi67z4qsaXgOtpZjNqo3uPbvP/Tg/KVQWpkNiwp2Wt/npdWTul/2Uh206fqnyzh4JNdhLlkyg/DkPUlwshtQpcHPRUawlfUZIGxG2WDWRc8K5jgEPGtu/WOKmOADf2g6+Qw7VWfvPO53axsZuEQVt69CpYXq4uVNFLTl+TW/sm+fEeZlCXByrSG+cTO5ydgCGu/DkMvefHjcyAI+Q2/8FksgGyizRbDdlgzLQiJ1BL473bJlWpzp9CatV0NsqfMuH7g4pNtZW+JRM5p6HBP35hTwx0UWI7JtfFIHiW+zfrkohB61o3VM+NlBnx5ryr4OqboeZXKpLsYYX7V5s+nrkBjAeTuUFKW2uK4JBxTGW7QdkIvBc3hE4NXjCgYafXDujlHfGEbuvzLqdOIyraAcaZvVtXRbjyAp5POfllBVtVzs9AGeoSSpsO5A0G5ugRr7H1VXFcHdcSQQSBoY/qTnKdE4ETtH3/ECK3uD3NQtXJ6eudiw0OFrIeUOHFGCaRVUDjN3JcDuVnnhBBuCJtP5K5xcAoKNwlkLqDhpwOz6T59Z0AGRGpm6Tcl+Jg59DfyQnYS76x8cdWd98xwKL6AdkLBFG7gci4w+VdEAEqGeV5iA0xokegAEsBAV1/jYyWVcMD2flMhvJwuErSHKl8pOEjmonST1sZP2hFGPXNWvIMEVbSiXIaEV8
 JSl2NsJX
 xEYnf5/W4zcMzcvTmxsv9J8Ee8u76VZuIsZRQzIMBh4cvmy4sUMhGCmdaAFFf9G53ioYJb0HxJgOAsyrvs3SOi9sMsyaAIoH2tZKcUke8985fSkR7mUMnCQEHkcWzk/PgcWFpY44BSRu5OCYc8eNnYUzVg+DqdfMPMml5tnB2WzGxNfB5QpLDCmFklVowED8NSqoveBxc3KJOwL2wJhto5EqzgUc3Ds383qDNpn85sAW11zweO+gF/bmcI2RVGz8Hh+uqrjlWgd1wTtxMTK8FREsdFmLFjWGG0R5k17RduhUeB5W5ilOEhSOSjt0y1lo1w2+fJo6D4BQld04l1vVOIWZ6LZKL+6jeOF+rlY2V6w8/X4ZXjPXdIVFTcg294vpDR/OMqYMUBWy/AdgFOD5FP8NIRa1RlKH5ml4AipZZbZhRI7ORldN0Rthk8S64frJ7q3Kfh5JxhsPf8xNzHBEZX6GC9QdlaPDywQXYHqy4ri8EDQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 9:34=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 30 Apr 2026 17:32:40 +0200 Michal Hocko <mhocko@suse.com> wrote:
>
> > On Thu 30-04-26 07:43:05, Andrew Morton wrote:
> > > On Wed, 29 Apr 2026 14:13:59 -0700 Minchan Kim <minchan@kernel.org> w=
rote:
> > >
> > > > Currently, process_mrelease() requires userspace to send a SIGKILL =
signal
> > > > prior to invocation. This separation introduces a scheduling race w=
indow
> > > > where the victim task may receive the signal and enter the exit pat=
h
> > > > before the reaper can invoke process_mrelease().
> > >
> > > Does process_mrelease() have a manpage?  My googling was a fail.
> >
> > It does. Very well hidden in 884a7e5964e06
>
>
> Well, that didn't appear to make it into the manpages project and it
> doesn't describe the expected usage: need to kill the process first.
> But I guess all the needed info is in
> tools/testing/selftests/mm/mrelease_test.c.
>
> https://lwn.net/Articles/864184/ is useful.

I'll try to carve out some time to post a proper manpage for it.
Thanks for pointing this out!

