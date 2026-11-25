Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731CB606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gyDWkw3Q
Received: by kanga.kvack.org (Postfix)
	id 6B0CB6B0A99; Wed, 25 Nov 2026 13:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688B26B0A9B; Wed, 25 Nov 2026 13:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5777E6B0A9C; Wed, 25 Nov 2026 13:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 341DE6B0A99
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:06:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EEA6120F71
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:06:08 +0000 (UTC)
X-FDA: 85474420416.21.29506FA
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 191B91C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:06:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gyDWkw3Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795629966;
	b=BNS6qADax0UlYICyeoM8/iRsK0wiy89O9KxT0kAb9FVfNvTScwCib8Ph8+bu/6fjR+LK5d
	P6Raqu04zv247pPTSHmSrrXQ/4jbysjYopP+NdNIiwgLneRelnFKqIyOwq/s8B/vJ+BTt5
	pSZbRZfFZStTPxcYSAbI8mmu7foJE5A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795629966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
	b=H+X7R4MID0VxMrdjbUwC8Vu2RcmyJTwGthwRfB5b1c449rOOC4lskW4EY9bkfGTqAtdO0Z
	rNmjje301J1ovgSJOOG+ht6qNmP1KIOnS7L1Q0VdYs9BFxS7pOMxw1NWAQgBkoko0v/SqK
	F4vaEbWB73PEjyFowvFyHgoKhNBO/JI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gyDWkw3Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be4fea434bso6312285e87.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:06:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795629964; cv=none;
        d=google.com; s=arc-20260327;
        b=Uaw0zMK205r7CLTo3Xu3rXi6PPwuoNiXUfbsbJ9Wc5Y/1DHkBmFAK5NSSi3rAyeY0/
         /OE723//mfTqMa8ZVC3EeBH3cSynXlh9cdpyDt144HnM4hnztz8PGcGO84dmddX8KIqF
         +5hgN4orXe6rFSJptvl9aIqLX9RtW2lqfn0//D/lLAF7FQqAW4Z6S5ipsuIoMGS3H6+B
         251am3QploiMDqM6/AQzNNCDoUFxKz/P58ENEIXQWEfvUZf8dOXoqPESfxRYHOJz9gZL
         LZpOwCMmpxxr8Dtv2gGX/LAhog8FCBgm+dMXIbNERyjCW6fR5zm4XQC3iwpjHn90a+W0
         YZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        fh=dtv2tdcCxV3RZUVlwV/xJ5CdvpzqrTUpgVxRnHDWlbM=;
        b=Cl2Sodfs8rk2it1Kk0A1mMRmN55RCPUvydbyCXC5bx3Vb8o1YBweklnOIxcZC6JHvN
         aQZUfo2lb93JLXKEEZAG0y/fe5tEY28qduORbyYuoODUDXz/KCtsyCY4/tTpG2KjTiJw
         ljOnsrTyPA29BQFfLUz64MeJlaOP88GsHZaQoHsG3dLUSvIi+9/oFUPEtzWlVkXSHvzz
         mrP2lR2zSoQvaHXtop5xDkntW1QQhX3/DdIJrhB470lNGEn5x0ONN4MhsNE2HgAumNNe
         nTLGYr1+Ga31D05yKjJqWVMp7zJZq7eRuLBZh0XJwV3yaZsTFQsf7obyjWlZkEg/iLb2
         HpNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795629964; x=1796234764; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        b=gyDWkw3Q3+3zCqemO67KCD1VybTJw0sIcD/m6dXI+hq2yDBlHcoo05Rl7aC6kymtoJ
         jSwkv71PBjyYVs7uj3F4wlo1d34j4j4epc0beNRbBwDKezGmMkX8RZbxBwawbBCVR6DU
         I9X1a4hIlkzWG3a1Crmk2hkf58GBP4vRiK71haJuxj2udnhh3kQDAkqzXiDaBJsNACFE
         CD01TRBvOtQRgRvevfrRuE8uIYqRWPI9H9aexl0uRSDVKbLwpM9VzwSIu89tUf362RHu
         KjVAxeiqdQPXa/gNWR1hrhuHC6xjzsfIBwDPL1SE6w2XShKdRKjwn7wgsoNr0FW7Ol8R
         H+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629964; x=1796234764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        b=Df2XAY3/klYmhr/FpTaRUglliF+fRV+6G/GutCiod9rM4evnL1XLMBR39MFJgmZ6ns
         U64Q8tGTFK5i0PKjrW1tcj0+iude/uK5pkHU62pRD2TdpltPFUclXtnb5BsmR4+zGWoI
         OwnjqE/NVDWgZfgW+4aDqsr9j/BJGYSDSiC416JpANM4mTzA9vj8pqVAla+ScnR9e8Lj
         bWiT1yxtlPLUQoQlJtFacX1hFZFqpLHz4vx3dTkokQPCuPunJrhzrS2ytWCFYp7mOpqI
         dcrA/cqbih1AcgdrUQfuEzszhzJd+WBn68lhAp0yxfIh84yUxE86jDDOzEDk+g2O1bla
         22CQ==
X-Forwarded-Encrypted: i=1; AL+hErE4gdXv+WjWZMZ+dMAv4crsSeA3pjqRc8Ibt9xtWzgTS0WDt5GLaO+7Bcp21RmfRW2+HFaj/vzFHQ==@kvack.org
X-Gm-Message-State: APuU4Z+mSo1UL7kUU9hIOf5lacxF5EkAPdj2OatRnBDPNxvMvsBHNSbH
	2844XtygqGuT6UaePwn3MZJJMI4YgqUTPxVX7s0HHtgCANM/hSOTjAs3c7kVt6pv+ANRvmY/aOo
	aChB/uffv0SfJ15FQBMyatxHnxDUV/TU=
X-Gm-Gg: AZFdTZc+VEJVDhm7gvgPnacltdmeE3adcuzTAZo6vG0/rKWTls8GgPACv5/lmGTu54X
	PFpN42RdDScWfPU7elrGvNbO0vEx/lylwFrBlNw5o6kibNUT9XNTYUP3sfLpAqn3JstUjPaFxpb
	gt3IAQ1A2buU5fI645vixBMvVyYDxyvbhTb+Dweyjnood68meWsUYZMMxVZeKOWXKx3wno0Rned
	++1DpGjtIzCrZQseuB/VLsDswhm+9FhWDFGsEJP1mq3/AKDu1GVlAo/kBVAw2yuTHX7yLXKOmot
	DHQdLkc0Rrz4MXFo6jEiTvQA3TO2qFHi/H3Wnx4yLQrnx64331Qi99et4LhvfQJK1WRbmOJ8oEf
	ha53phTGLTIrYog/VeWw34QXwZ/UbjKCMExvE
X-Received: by 2002:a05:6512:33d1:b0:5c1:4aa3:cf96 with SMTP id
 2adb3069b0e04-5c1bc86cfdcmr4235686e87.14.1795629963996; Wed, 25 Nov 2026
 10:06:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com> <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
 <awcK9oNDbc1QFJr6@google.com>
In-Reply-To: <awcK9oNDbc1QFJr6@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 25 Nov 2026 10:05:51 -0800
X-Gm-Features: Aa3M54rQYU3bIxvHpI5Dlfnhm6qCWUiCqJ7E9nlnUc215LhQmCibH9zYugGNAEE
Message-ID: <CACpmpoenPZ_SqhxL70r8q09WBfrnqvPu3H+F8Tz3nVwO=rvUTw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 191B91C0004
X-Rspam-User:
X-Stat-Signature: uwyaqgqk5wgfbxjp49rf59rsmpsuu864
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795629965-434666
X-HE-Meta: U2FsdGVkX1/ngQwWC2jrFA0UwbIrYK7ZaWbNSPwdBCTc+MsQgSS/o7pjyYxWPA+xnjihWHQLy+jUTcWGrmx99fKBlyb560BbEnVJOC+ZqcRQfSAWWmuJwZ1QfSqv1O5SrMwn3tuJQk/F0vAOhzv9qD/2X/FucE5LAS+isU+E8o8EnqIJCwkzWm4X1y23Q7FBLhYB8UNtXaN6uS+MvT1TSFwmnH79VMTLUXnsk6JolWiAPzcOXsB8vu+Ya7swHkVXZ9CSf0X0bG3FZkAGBDNmNL0Gu7cZh6irq1rrXu22qxfzyq35yK/n+PDgoJm9mdjn/fJPbCz+nyzWA9hbs7JSApWFJWcFFizlmUEeEJI57X+aBiiUnfxwNIH+/aQQH2kzlT+sMI5z2BeaHFLloTwsEZBQuSwG3Yet4KGxsAatWStHy7e4cuItKaoWBE9JwJtD/dpGyOmhmJEBOZje++EAm28nRR1vzh7yGoNKzQJo8EyBe8bfGtryn+UJZ7cidz2mpInch/bz3lFXuXndhaccFJYoLUwEe0KMmFdusVC5gPzqO2rtftGf1Bj/Csd1rbE4jvrfJkWwf7maMl1XzHW/bGb3II76cRYOAPNsGf24meBgWibgcjcVuPZTwlR7zsoL4d5wD5XvDlzwKP9F8sV1yI3tudhOudrak2oKMq33lYuxXWbiVYu64LrTaOWB352MJ0w0ajTA1CEdQc1Uac7Mt2FrsRgN4OprjN9qCLGOZKWQvZLDFOYzFPbgDr58zJy0QPmN+rh2vtBlCgr6zSxgshzUKK0RMVyqGwiDpgRAduosZKGF9mpI+hcuzjeDpKHa0lHgtzl5N4kTdlMy2uCCBbgveNDhBBRRyvWTqin7VWvbKDkDFtqakr5XPWQQMqC77Y1ntcRYXiD3rm4keO/nzoac3IaKUISs4UgGotVdYNLhPJD5px2tPitNouYFYdqGN5NVAifRlcaf4EL4V3L
 KQITZk1w
 lglYD0l2km9+wYDXn5mL4J2spi+A98yccrXaCi8Ydv3KFW5uyQ9wMeTNOVOkcvYM0e++XyCCAl+VjBd2mLCXdNnuwCpCwgxtrKwY/5m6gLfNrzVl/JVHk1zFguKBuzT9zJM5blP/lLJmpHEREOWKE2vvbPXFfgSp9baZkEYVfrsXuELco3KWv70MF9St1hRRNd0LjROt/pJ2QrC0kzGBDTdrh4B/UqCswRXdbcgZurMF/Uo8GzmCdvowdBwso8ieRmlHtfe8fOxrU2sXRCtfyGpbveZ44D9SPOq6jyG9ILBPcN+qS9wmNygp2ioM9ADxA9j7RJKfDzsjJDyw69xetI+tdHFGkjhVG8F77F/k6FPWoMaX3hHvE4/IXnJb+iChRxfuqVtVMpnlFRtcDL7ZqEz/hPbAF3unqogz57srEApVt/u7KgRGWI1T/aK1q29b4Q14qu6eQCJLN5E2p+V6O5lUPXMycjzOiiI+cYA8eDYGmdB6OcEtBZj24IpPhFKbYpb5BPy6jG0sXQ0WDxm6B3SriqcK9Op9Gz1UaH+6+U0aHEW/KNLCr3ZgrtvSppHSOZXf7KLqiG7BA1kcwVew/GcrQFfh4q1do/7Aar/XeauZ3adMqlQzQ4WO1+dAKDIzIOGXYSsNFN+0Km0OrSRmE6CYf9JqPftH7kAU6XUlxudR/CXZbfkuwDVh0OWqX6p/W4eak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 8:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> [..]
> > > write_s would be calculated averaging the time in the ".. bytes / ..
> > > usecs" lines, and free_s by averaging the time from the ".. usecs to =
free
> > > memory" lines.
> > >
> > > In this run:
> > > write_s =3D 37.31 s
> > > free_s =3D 23.39 s
> > >
> > > With your patches, I got:
> > > write_s =3D 37.03 s
> > > free_s =3D 18.86 s
> >
> > I am not sure how useful it is to apply user-space gettimeofday()
> > results that time many higher level C code API, as an indicator of
> > zswap_store() performance.
>
> It is useful to see where the time is being spent, and it is consistent
> with the perf profiles.
>
> [..]
> > > You can see that the cycles spent on zswap_store() are almost the sam=
e,
> > > and the cycle reduction happens in zswap_invalidate().
> >
> > The cycles spent in zswap_store() should be normalized to the # of
> > zswpout events that these CPU cycles represent, for this to be a
> > reliable measure of latency improvement. There could be an increase in
> > reclaimed folios for any number of reasons, all of which are not
> > necessarily due to performance-improvement/degradation of
> > zswap_store() itself. IOW, more work for less latency per unit of work
> > is not always indicative of a performance degradation in this case.
> >
> > A realistic scenario would be that with zswap_store() becoming more
> > efficient, the 30 allocating threads cause more memory.high breaches,
> > that causes more zswpout..
> > This would cause more CPU cycles in zswap_store(), but the fact
> > remains that zswap_store() efficiency has improved due to batching.
>
> The zswpout number is almost identical: 45,796,107 vs 45,796,089.

Can you also share these vmstat/zswap stats for this run (baseline and
with patches):

 pswpin
 pswpout
 thp_swpout
 thp_swpout_fallback
 zswpin
 zswpout
 zswpwb
 pgmajfault
 2048kB-alloc
 2048kB-zswpout
 2048kB-swpout
 2048kB-swpout-fallback
 zswap_pool_total_size
 zswap_pool_limit_hit
 zswap_written_back_pages

Thanks.

>
> [..]
> > > > > If we want to address lock contention in zsmalloc freeing we shou=
ld address it as
> > > > > such, not by batching compression.
> > > >
> > > > Lock contention in zsmalloc seems like an independent optimization
> > > > that is good to solve. What I don't see is a way of explaining the
> > > > gains in this series based on zs_free() lock contention, and hence
> > > > drawing a questionable conclusion that this series does not optimiz=
e
> > > > zswap_store(), and further that batch compression is not attributin=
g
> > > > to the gains. I have provided ~10 reasons as to why the combined
> > > > zswap_store_pages() batching and zswap_compress() batching improves
> > > > zswap_store() performance in [2].
> > >
> > > See above. I think the performance improvement is a side effect of
> > > calling zs_store() in rapid succession for pages in the same folio, a=
nd
> > > more pages in the same folio ending up in the same zspage. As I
> > > previously mentioned, this happens because all pages in usemem end up=
 in
> > > the same size class.
> > >
> > > The right thing to do would be optimize the zs_free() path. I am look=
ing
> > > into batching zswap entries freeing, which I believe is the right pat=
h
> > > to optimize given those results.
> >
> > If I can restate what you are suggesting, and please correct me if I am=
 wrong:
> >
> > 1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
> > vmstat events in baseline and patched.
> >
> > 2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_=
free().
> >
> > 3) If (2) confirms that zs_free() has become faster, then that is a
> > beneficial side effect of batching, per your analysis above.
>
> The number of zswap_store() and zs_free() calls is almost the same. So
> storing doesn't get faster, freeing does.
>
> > 4) Why are you suggesting that *instead* of acknowledging the
> > beneficial side-effects of zswap store/compress batching, you would
> > want to find another way to improve zs_free() latency by batching of
> > zswap entries freeing? I would imagine both need to happen. The zspage
> > locality side-effect isn't a contra-indicator to zswap compress
> > batching.
>
> 1. It is unlikely for realistic workloads to have folio where all pages
> compress to the same class.
>
> 2. Even if it happens in practice, we'd optimizing the wrong thing.
> Consecutive calls to zs_store() landing in the same zspage is an
> implementation detail of zsmalloc, and if it is something we want to
> enforce, we can do so in the correct layer (e.g. by adding per-CPU
> partial zspages like SLUB). The gains also depend on how different
> threads race, and the effect of cache locality on the specific CPU.
>
> You are basically proposing optimizing zs_free() for this scenario by
> batching zs_store() calls in hopes of landing compressed pages from a
> folio in the same zspage so that freeing gets faster. That's definitely
> not the way to do it.
>
> If the zsmalloc class lock is a bottleneck on the freeing side, we
> should address that problem directly.
>
> > I will run some experiments to quantify zswap_store() improvements
> > better, with compress batching.
>
> Feel free to, but we have been going back-and-forth on this a lot, and I
> am trying to make it clear that your time is better spent elsewhere.

