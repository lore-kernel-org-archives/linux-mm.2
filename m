Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD74C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4988B6B06F0; Fri, 14 Aug 2026 12:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DBF6B06F1; Fri, 14 Aug 2026 12:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DD26B06F2; Fri, 14 Aug 2026 12:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3C936B06F0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:50:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E01CC01BB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:50:24 +0000 (UTC)
X-FDA: 85100463168.26.7545E03
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8254A1A000D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:50:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4Ci+fQ0;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786726222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0VhZRE6u79sCsL0i/AfxXvR85jg7kq/ABIGD4dZezY=;
	b=CifTYRLo0BYL61GveMqtT2prS3GNt9X0s9jORKqtRXP8t0bPyUBmYrENGIPF8b43/azAXa
	Om7lVp8F/FvDrAUWdNamNTQ/HBToVeEM5U4cKgWQywHoAyjCVDz9jhQ9kS9X0JGZVcDRb3
	tdRNUcMci17IbsnOJD/WtrbASfZWS6s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786726222;
	b=0fDf+qnq52KVQBV/Cdb1Rn7T+G/KlBo/eqQVQ4q+EL1oCSJ/6BExZjI6vMTZHQDJ2XZXbR
	2gJdY3E6J/Y8uyCh/GYlwXGVjt2JZaK+WeMz5ufdsoJfv890m2t4DoxTxtWXgp1AudnLWY
	RkFPZjbAo3cAr0mVSPzBzrgOHGh4dWU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4Ci+fQ0;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c54dc3a91so165115d50.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786726221; cv=none;
        d=google.com; s=arc-20260327;
        b=kz0W0CwAU8b41Bd/I84STi2JIv6DMr5ldUVuFG8Thf0sSZ4v4vlFF/1gLVgsrLBT1P
         oELkrVymB0m4WFhkH1aYUsyhZoNsk7Wcu6TTy47g2LCKhPwWw5CS6bTI6EGDvb27pwCR
         lKYxf3SudeF0t3VwvM32p4I/ieJ1N8IKDgy/4bM7bY9AZghC5VvUMYcEYHAYf3gbEcZq
         nm+O0C6kxEFsQBkNH3zRnP8jytI0quDNzacPZb/tCGStUiVv12GSxuAWSCBsJa5IPD32
         AhaBTC0QNxKKQs6TQ1Ak1iHjgnSopf7NB0dGDoxKttcpNxGMW5MDpAU1k7OiSTwxvfa+
         rUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i0VhZRE6u79sCsL0i/AfxXvR85jg7kq/ABIGD4dZezY=;
        fh=7Oi1/MK1Ns046Gee3xavr69OAFGp4CLoUllax6uqgeo=;
        b=AoNrKSkJ2rw0y481IljoMYrzeY3d5jx+Yz/pb/z18ngntJhEROLBGpkEXxEgKO5sx4
         Xb7l1dNMKIcQXtHHawHwjuoAYvAmsZBg+QctcNPkjWLEProNXFhQ56DqtkibfHYsMARp
         zL3JfMvfKesd59h6bTSnsuQLDSs7Sbvyfto8Fwhjg6ckJe8dPKPDIrJY0u3QL1iaqeZ7
         2vCMlLCf2EYdS3EyLYJw1PYMZ+IDg7wtU8DDWjgoeY550opS9Pt62uq+DE5Z7rPg+bfL
         DyzD9eAQucoVYmxSantJYltamK15rXt/E2ApJUb/oRNR4p+qrL5G9RDX+Csg49FS9xAu
         7nSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786726221; x=1787331021; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i0VhZRE6u79sCsL0i/AfxXvR85jg7kq/ABIGD4dZezY=;
        b=p4Ci+fQ0+oPgKF9hoLZnYI8+mE2bxLFpAYjY3E33k84bG8Lv5MwJk4s1ZRG006S+Cq
         V5A9ng2lGPIGKYrKIGhdboXpFYNM/yrZncNETT4FG63PnUgJhbBVOkDVVfM7bCqxU7xC
         rw9fIXWLVtlhekre+JBoZpIZaJ/lnFD9N8eHOSp4BIIrCie0wLFuYG8gS81T98FfFQB3
         HpZ1FbG+cWCTMD13ogAnw+hq+LQvw21sV99dDmOF+Vao9cEq3SIx7VDmH7fVJJpxM8Fo
         tRbQ4aHyQ3QP9HyD7vmJc46bNCL6IkKTa2kHfbG0aFeJipeNmoheErJUx1uVJoea9SZg
         f7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786726221; x=1787331021;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0VhZRE6u79sCsL0i/AfxXvR85jg7kq/ABIGD4dZezY=;
        b=koc9utc+JYlvrRM3G2Srfn4KEm/Jk1Jj7SZaDEulHHZEsZvIyP0HSoOWBxXAayYSFW
         prd0jcIqlsQx9Z88ckE7KKpwDT5vTx1JnP8p5gEHmAsXIXZPLRTUiFVl1/2mZqJiIOU5
         yACUxhcxQ/ojMmd9J8Lkn8KTWAHmmxO3mptWI+oA44WdKVvC18AbWRzDx0ZAHBg0Hkjy
         0K/3oW5QcAIvKq9HjlcwWNjdQlMmd+hn8X8WbDb2+lnPCvQ+8uaNvLisT4HnguaPXRfB
         hDInff8GdSijPthAP0eMRFQoxJj5uiTEcl2VfTrS0tIP+em+GZKuhyRMcqyzFYMjkvM8
         i4Qw==
X-Forwarded-Encrypted: i=1; AHgh+Rp6TLI0BrBcMJGZSygJGxwWU9AHejt1dPUmfX0cWBxH163xTtTc4sfeKCpfOIzcPFwtHsTePJOitQ==@kvack.org
X-Gm-Message-State: AOJu0YwZv12Hft0iNdFpDbaIsEmMFyykCNgL45O8vYkGe81VnzltAjWt
	v4POCm5vfjayRN51gnqskvoY5swwdEAII7lFBUpsqvhWTeXZ5LEBlja42HYr02FcWmhdhRqhWFU
	epNEkiE8RuxJ9fLN88B0dYC/gKIdiVRo=
X-Gm-Gg: AR+sD13gR1pkUYAzoJXHnNbl6S/V1TldodjlCOSklreS7a0fszyZfF+PskfFGLUJRXH
	+tKtpaHAOMeph4xTEouzAT85k2LlvKNaLZFRqbIY4Tmh+JTBQxWGXyOC2gyhjJAqSTsnGO7wPh/
	h5iYDJsYdddrv01BIo/aRa8OGupiur8rtxJtZQ98RW0J8c0rwE8yPcTF3t7/Bp5Sy0VOh49SSr3
	pzxMX2mMyrwt96qasxcn6ZAmAl8Fp7CZGleATBPntXAIPfHRbQf5vfGkFrYeyMoUJj5H6Z0V5he
	Mz7Daa/wLPlwIi6GbsJ7vRY1RRGIMIoErFWYRiHaeJNMTV6TXm+3beL/BPr9Py0Z5C2a8GBDwhv
	9YUWeNeaTO9jlRU321GtDARaZIL5mFCbLLDlyW9CjFBaOVX/SmbqWzuerI6yQb8Hw
X-Received: by 2002:a05:690c:30a:b0:81d:bb95:9f84 with SMTP id
 00721157ae682-83712abf604mr33335137b3.3.1786726221235; Fri, 14 Aug 2026
 09:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <7b83c51a-1777-45e3-ba38-89e12dc87b5a@vivo.com> <CAKEwX=N0Ocxa3o7A+F+2_iwEPtyvXzunfNXOsq7UaPEKWSB-gA@mail.gmail.com>
In-Reply-To: <CAKEwX=N0Ocxa3o7A+F+2_iwEPtyvXzunfNXOsq7UaPEKWSB-gA@mail.gmail.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Sat, 15 Aug 2026 00:50:07 +0800
X-Gm-Features: AUfX_mzxd1oGzYe8LZ7kyCw_cezhkNiATCuAsZtgRCXYw9mXV6jAatcfGd_DfOg
Message-ID: <CA+qSx6y_uTUf6MT-QTWCcdTY7AcfzPJ45TjvN7X0aoFkOfWRFw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen@vivo.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: eip6u8baqx451p83czwgntuhe3gfqgrc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8254A1A000D
X-HE-Tag: 1786726222-424247
X-HE-Meta: U2FsdGVkX19gooeW4fo+FDWYE7dw3eA4aWX87Bcy/xYqEI/IcWIOvYtpVZ1G1MOOEJvwWzUFFSiQ6bicPT92KwtE825TNf3HRdEFcIFT/uRiMybbuw5LwApToJaUfiv6YFzR6Ur5agVkYEfrJrhUaj/WIC+o81oClxFdHMOhbBg1v2kvBnJwuu1xIQMZqKwjt7+O3xsYjImwk7Y/OO73woE07Gh0Uxb3+1V1mMDCtGdKACePdPfSQEuIGQWasPfb1L5sFN/LCBJtYaHy7UshmzjDHXzbqTO/nMzCPUjcuHHUun89acyeLeIETmtxVgOdkehtzF4RAxvcxf6jPrcOsqt9MphQg6RP/B3uOQ6N9eHOMKk+pUPOVlYxPHcLXQ8ry4xpkzq4LJhkxuNpRORrP1/Zla+ZLfxlcztGpUPZfQSu9Mpl9JD5AL0vVJ25+OAy3FU6zPNfb0NIEjVpXDviN4kXmqhDSow6JmLsz4i7UvgselAGkdZISnVrjrMhv/eroyE32dZgxFviizBSWKyTJT65JJAXw+1TGirGpZxozQ0UXys8xF8x7HZDk4JpWLtSOhaGdGSgauVanpEBgoxkm8GxjuRtLc5GaXZSWNLgtC5k2JUANg7SHv6T6kMIlgihKh7l+NwcV4iCtKhXhvko7n34aTPwTx4Mu2Fb0PLFDXjpg7YUVVyu0ViaRyrNMGIw9uiLh0fd0i+F+YGj+gGN65AghyQ5dAo0a28pr4ebVQarU+zqilHjrrfRbsHzMYtVhr8qlKa/RavB8iM5oyvjUPaDIEbTO2w/30q+e0VNquCb+a8hz7DUmSWE0XI+l/obgsOArlNsMScwOY0q3x8dfHO3RhOmNWPuoLqt995P6rI0PSsOgApCFh2SG14DK4qrV2zpBJRqbVxzNiFnKUjAYVp751DSVS/+Wl2REFtrfMtnv2k02Fa4tTlOW/ihIJ4TMcz5eiGckBkRXePms8s
 o/fWN276
 o5ipTWoLb3VOE5ZhRxzgqWQBXyU8XNCiV8WXdjjnStMv6njT39XAcR5ak/mVlBmY0BdCq+MQy/H0OCVjZ0LhHd/JnmLjZcVw0jKzE8hkQEnCc9uW3NsbFcc+xQOq17wdjD1kUdHa995t4ELKm85v8QE1yn8qzIcpwPhykhv6CABnQPBMowymCQ0xrFrzqJ51sGt+DagCX+cCPds4alSOHuK2hrcWruWnLmx6WOSmm+/SBBajPaqvulU0QqBghGdtFAGupVIgVczcWgVfG9zeJ8JpjgLMTIVN4uBUsHBpN6wE/dflv4aRxgze2j18MyiiDNQ4L/k3qhwDVuqQCYm5TTjN/Dqtsfhj8Rix5VS06AejC1b9Ph5YWoV/CYWk2ASLIJeWBcddjoSTWWsvSNCvQ0RNqSKTWYC0E7GXwhXRYUI0N3gX+GqkMzQ5FrGmgimLeQiLckyNiczeMBWGmCTQAZUd5IQELa/aROWrKxwI9z0s003avPhEcbdFyX2UApU7V+D+s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:25=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Aug 11, 2026 at 2:04=E2=80=AFAM Xueyuan Chen <xueyuan.chen@vivo.c=
om> wrote:
> >
> >
> > On 8/8/2026 12:25 AM, Nhat Pham wrote:
> > > On Fri, Aug 7, 2026 at 5:12=E2=80=AFAM Sergey Senozhatsky
> > > <senozhatsky@chromium.org> wrote:
> > >> On (26/08/07 18:57), Xueyuan Chen wrote:
> > >>> Hi Sergey,
> > >>>
> > >>> Here is some additional data:
> > >>>
> > >>> I used the following definitions:
> > >>>    compactable ratio =3D freeable_pages / total_pages
> > >>>    memory reclaimed  =3D pages_freed * PAGE_SIZE
> > >>>
> > >>> freeable_pages is the estimate before compaction, based on the same
> > >>> calculation as zs_shrinker_count(), while pages_freed is the actual
> > >>> number of backing pages released.
> > >>>
> > >>> There were 264 callbacks in the trace:
> > >>>    callback elapsed time:
> > >>>      median:    5.77 ms
> > >>>      p95:      55.82 ms
> > >>>      maximum: 271.36 ms
> > >>>
> > >>>    compactable ratio before compaction:
> > >>>      median:   0.32%
> > >>>      p95:      2.86%
> > >>>      maximum:  8.33%
> > >>>
> > >>>    memory reclaimed per callback:
> > >>>      median:    3.80 MiB
> > >>>      p95:      30.45 MiB
> > >>>      maximum:  92.73 MiB
> > >>>
> > >>> The longest callback took 271.36 ms. Its compactable ratio was 3.25=
%,
> > >>> and it released 7,650 pages, or about 29.88 MiB.
> > >>>
> > >>> There was also a 241.91 ms callback (with 30 schedule-outs) with a
> > >>> compactable ratio of 0.44%. It released 1,019 pages, or about
> > >>> 3.98 MiB.
> > >>>
> > >>> Based on this data, it seems better to remove the shrinker.
> > >>>
> > >>> Would you prefer that I change v2 to remove the zsmalloc shrinker
> > >>> callbacks directly?
> > >> Let's bring in heavy artillery to this discussion, in addition to An=
drew
> > >> and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random orde=
r).
> > >>
> > >> Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
> > >> I don't think those buy us much apart from memcpy-s and lock
> > >> contention.  Systems that want to compact zsmalloc have a sysfs
> > >> knob (and API) to do so (based on zram mm_stat numbers).
> > > Hmm we'd need to collect more data in our workloads to determine, but
> > > if we can compute compactable ratio (freeable_pages / total_pages) on
> > > a per size class basis, can we just skip the size class whose ratio i=
s
> > > too bad? Would that at least cut down on the vast majority of
> > > fruitless memcpys and lock acquisitions etc?
> > >
> > > I'm always a bit hesitant to over-rely on userspace, especially when
> > > kernel has information to do something smart about it. It might not
> > > react in time, and many proactive reclaiming schemes back off under
> > > heavy memory pressure.
> >
> > Hi Nhat,
> >
> > I collected per size-class data. 53.7% of size classes have freeable=3D=
=3D0,
> > so skipping them saves some time. However, 94.7% of zs_compact() time i=
s
> > spent on classes where freeable > 0 =E2=80=94 meaning the cost is domin=
ated by
> > the actual compaction work, not by scanning empty classes.
>

Hi Nhat,

Sorry for the late reply.

> What's the distribution of these? Say if I were to skip all size class
> with compactable ratio below 20%, or those where we can free at least
> one full zspage? (IIUC, we only free any memory at all if a zspage got
> freed up from our internal compaction, correct?).

You are right, we only free the backing pages when a full zspage is emptied
by compaction.

My test device had some problems, I need some time to collect new data.
The good news is the per-size-class distribution should be ready next week.

Thanks

