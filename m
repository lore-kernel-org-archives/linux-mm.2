Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BDDCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BA46B0005; Mon, 18 May 2026 01:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC1A6B0088; Mon, 18 May 2026 01:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA8E6B008C; Mon, 18 May 2026 01:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 384226B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:22:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4FB41C1D27
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:22:48 +0000 (UTC)
X-FDA: 84779396016.06.961D539
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id C884840003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:22:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bajee52D;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779081766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVrmc1+PV/eXO19oXbXbSS9nJEY6DfKgzD6K9F2BhAc=;
	b=PBmpTDUx8jbDrVbfWNwnF7jJy0b+Cd12mtCvi0epJYc6eG/z2Z3A+JkXHzRzuP2bc8uOH2
	3P1xzGAaocDoQaBXy8VY87Jx3Pq4iru83oXrqx77Rqu49+vcYKR07FyrmwIdqOjwX1WKwM
	nCcM17//t6Xi3l0i/C15EAEeHnXmEZw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bajee52D;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779081766; a=rsa-sha256;
	cv=pass;
	b=sbRuWz0yQ0RAlwLCqfFXDW6efTcsHaD7PUIazCdeDILeT1HpufYJ5jHkgrGIxXgHGnY0ve
	+lhLTd/TJKrDzwgDEoOULKmL4qZfPLmzmM5kuzfbfoGmfgCGOpfhkxgsSOYTh7Xwob2UW1
	flYy5D6b0OVnG8kGyvBtNlBQez8mxOM=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-1331e851faaso773137c88.1
        for <linux-mm@kvack.org>; Sun, 17 May 2026 22:22:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779081765; cv=none;
        d=google.com; s=arc-20240605;
        b=FGLbCycwThHZbtn40ajgrRqEpjxxtMbRHQID77YgVd3dd3ctjDX0iW5zA3WH+W0VZe
         PF37BxCAotkQg1cppD+vp1ejcYOLOC+sNPG0HPY9e/5dvC4a14AxQHUQWU7JKyjRD6Vf
         yegu5F6QrwggKLtT4m3B+7eYvCJNx3o4a6v7A6F39ARYVoJ8K1jBz5z1dcgfaT0ek+8x
         E+DJq7bUEEozVmJkltsIJl8tVFsLYdyBMzhX0ygYWM467EUXrvnEIP9C+kaDrdHZEU9y
         5zC2m8yeAE7b9qIswOmK+QQEJOrI0Hfmg4Ka4G+CjFopO2Q66w9/jMu4YCh1OUbASEmP
         l3gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tVrmc1+PV/eXO19oXbXbSS9nJEY6DfKgzD6K9F2BhAc=;
        fh=SsAf+uc21fZQ0xf+watuUneyQ+4S+cMXaOa59Aqfy0c=;
        b=RsPUKz12DS3FEL2UbhlmYmVPxJ+XKcU0G7Kyw6JF3Olep9roWPUKGtulqf7cY5w/kw
         L+P9azGvflbF+0l2fNoXsvVjgJyR+A5uWS94oRkomAH+hcPivjEtCwdGiWan/w3QK7Kh
         +TljdW0zl0qzylj6qVZBLoMUCrbL2BidigWie9V8F2kWuRl6KHVQ9/ethHL7gDz9dHKS
         wvaqDeqSP5LdgEvaWckKKKmGF4kD02TczKt+3pyPtICR6ZfUArNFbnCCmzSWvbVQe0HY
         nDrS9ek0FeAyrZl011qJDSo8kTVoj6NEYtPF8ef8mwLXpzizWplBTI1UObVKEqQfKA9w
         TGEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779081765; x=1779686565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVrmc1+PV/eXO19oXbXbSS9nJEY6DfKgzD6K9F2BhAc=;
        b=Bajee52DIlqc33FB5+hJ5gwPISas0r1h75Lj1TKU1x8K9IcMiVI62N4JHuJEzYbjJV
         Hj2iRqPKraR7SnJ44XE2cMVKlCFipzTHIk7U1x+7yNBKrtFI7sUiMGtm5DVRX0SXrFP/
         A7XWc0hUvY7+wfs7mJgyGOjVnW4LtcJEIOGWvGhzKo11t3xnJkq2uO30f+H92m1S6UIb
         G/Mx6YJRjYZ1Cr6/18uNrYe/TrY+jcXExYIG48WodxBFMpQj9UAx8cfw3oFf3EguR+ZG
         xswc5EUhBu5A4u9TymQtz6bcc5PWf8zTS7qYgiq1mvMsaE3sDXRuRP2qt49NcwkyvoNM
         34AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779081765; x=1779686565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tVrmc1+PV/eXO19oXbXbSS9nJEY6DfKgzD6K9F2BhAc=;
        b=Q2sPb8N7faTLtacqhiHwTN3oGB042TuLK47kj70MnwdP60eeWsbJLwcW8AJP1Uohhm
         8HxY1fA6kw0TYieWazW0W561Y9i0s29aZLa0GS+8s5n//n0q8AFSbbxGXU3e2dnCl7Ak
         WvNBDdpyHKKBmo5at2qOVagesOF/Uy3yPpzfkZNnozow29TNLzmISeb+vPtRqbnzsLts
         QIQNgfujP+frC26RM7p+ton07WPB9Amj4uIZTuVDiUhPsfOnV2BRJpSF9/78WRM2UMur
         VX8I+2N/yzEfNCdAZa93MkbuttSGxG6ZBKwU5TEhU5xtpgG86ZEt171KWdNZCqxY58Va
         6zMQ==
X-Forwarded-Encrypted: i=1; AFNElJ86Qm3yeeZpG6cilm9WB0QMZKDjeyeKcY46zo6Y8TaLeieVdzUZpDXJ8/JbK1Ml/GD69LGAN/m+Vg==@kvack.org
X-Gm-Message-State: AOJu0Yy4EwAJ5tBcwh4JI8Rx0XDXJzQ+iQllu62ILVNsAdnKZcvyZIwv
	3k3x0VscUXKUEn4tVtfv/uzdIVgUBPZ3RTIn2GuA5DiCvOvU10jwuHf14DosAQOW3GMVj+yvuRb
	DzFj+/XYMmgYYQzRtg89uFcacYUjxIQ==
X-Gm-Gg: Acq92OGcpRgiwR8gl7ziN/59C5A43Qd8Xm1MJPfI6rqTiaa+RcWBOQmJfnmV/Rd+HWk
	Csjeh+zT9q4ro+AkpDjecRZhHWftOGlbrSiRm86SwusfaWTwktUy4e1twMKHS9yKmGScNzgkjkc
	CItuRyd8uuYWCEUu7ZL4SK4Ry6r2fBYie+5OLEkyHiBDymZG1yxupMvreniemkVFZ5teNluUpP4
	3gt6dfkDKYB0STyZKEnrN6BWItGLrBgHtDGnqYlE4omcZunuZsfGDPAKYiOalt/MZXXMEeEzaYu
	Aw5tflY=
X-Received: by 2002:a05:7022:301:b0:12a:6d05:3938 with SMTP id
 a92af1059eb24-134ffc6a83fmr5895472c88.7.1779081765523; Sun, 17 May 2026
 22:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260516210357.2247-3-ravis.opensrc@gmail.com> <20260517183658.4510-1-sj@kernel.org>
In-Reply-To: <20260517183658.4510-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 17 May 2026 22:22:34 -0700
X-Gm-Features: AVHnY4LE0W1Cr7WTCe0QcWx8Sq82GcO7UNuwTXn-H1Hzh7EXFfcqQ3AqG5J0WCk
Message-ID: <CALa+Y14PXA_anNdvJCzx4RfKoKj6hNmEG39KUvMALtOBznprkw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] mm/damon/core: cap effective quota size to total
 monitored memory
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C884840003
X-Rspam-User: 
X-Stat-Signature: zikf7kux8wzb83mgxazq9fukw77nc1do
X-HE-Tag: 1779081766-540939
X-HE-Meta: U2FsdGVkX192D/FcHtudPOeU+muVN6+MsUMmocLAS5kfpwsJE4GbniWAVfqwX9s2pSO2/U0yJ9dReaJ2r9/6jTO+TfWcc48OghcsJ4gq/0dbvgAnWQvbddzjGcTAkLIE8oc/MtulKHDoVvcZO7ya51Sa96XEs5sCYagfmzXv7x8Tf1sctKROUohnc2djt+NXQQd1ghzFACJFsnk3fERBhTYjEsJK5pM4LuAmJq+AnVHdKHL6PJGlAQWrTWlqIGJEOmVX57MBlyIRfN8CUDHMxj2oPcWvIecqsOuye7LJAVTkp1zI/ZKAc/IcRoXscE9tKeEvty1JUzURY+JtiApcW6gJvyIztE/6yrIk49eYEFGqbt+k/ugZwNeOBwhrxgBGdM0vmCSPxkfesQrz+mSHQl5I4uNIU4/gS3+LafQmrzBOnBhTTyQxFIOH5j9v/3k2U10ehs6wLaLfkmYu06ydl/EoCpC4V0XZ7x/0WcQGvXzweqmnwTZw74Udr2N+d/DyZt+SzREb1iP7bV4jVwqbckRGvrGyBiBaWIqBUkexGFOMp0nOmtBWqC/8Mn6Eqw1Bkr8IYE9q16tj3w9QvlzWUn88uqeOoVX/nQeVOT2K/e87RUxVopOQdP+MxMZ3UerbsolXmYaMMbScB8asfGLxY/RVlIXhGQF3F9HWx+5x9OfVzQJew4+3ozyuspXu1Hk2trHD9dmbsGmr4boimHR3RGIeS9/ydutaFBen/euYRDgHtKSM7xMlVBPvjNR0rHX5vtZhL0ri68pKrKFXApsYRd2nsql7scAtjgaH4zvgQJYStIU3+NB4Ang5cLEeYZKVdI7U2C4wAExLcYLG8McJpTxgmUo6Ssln+gdrWw6KD+9OJi1BCsM3hfsI060cCmPAJ0KUCzNyaXLi69D2JNPGYqEn8c2RmrIUFQdFkIBUujHBrdifO2z4HZAshn8U3mTbaHWI+vXhLqqH96W0X+G
 62MCFPqb
 f9iLua4KDEn7JqA/l3gF//gbSh7rtl7RLQxEEvleb9/GFdCrHndc2kxeM5DijZAyFy1adLsVP303n28NzT9eT+UAipYfRjdXOasgzSZ7Vx60RQQ8pWr3WqkHe4Z0HiRhvv0eKE+65G89cQrIrYZiZ9ekOhzEuLpm9oQwSUMdffV3DKDg5Q3r4aX0ybq+gBEvZ0oiJ8qIDsGJYMoLLPxzWRT4TolDQarHIMytIKCbPiUzkDqnhTFW5L2FAJP7vxW0qugAQMNpdgvclhioipZr+01BZj5duH0ouHjnWm0TkVDUw2VOPgACv8Ov/vdJ9wFRZ3AcErqKmdxHBVbR5P8Yz2aoyoQK0MslD3uj3GbX6qZby+K5njBcX80l0bcnEV/fEvIpRSy1ANjq+v5wUGBTEpMz3GgYpvZWuqqD6WCB0kKWc6NNe7YqmdcoaSDUm2bdeKJquS2NBvTvQsvrdDzN2Rm8ANLwxEkplYPGlb9B0hLKLVfz3WpD9HaMk0ZU1BQYv7DhvhBduVxnTRRIPVnV2TENKsOSpG3L8+s7WbcTNjWXqxPx4BB/FiD11OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:37=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Hello Ravi,
>
> On Sat, 16 May 2026 14:03:54 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > The DAMOS quota goal tuner can compute an effective size (esz) larger
> > than the total monitored memory because it integrates over cumulative
> > deltas without bounding by the actual workload size.  Once esz exceeds
> > total monitored memory, the per-tick "remaining quota" arithmetic
> > stops being meaningful: any scheme can apply to the entire monitored
> > space and "remaining" stays positive indefinitely.
>
> Nice finding!
>
> >
> > Cap esz to the total size of all currently monitored regions as a
> > final bound after all other quota calculations.  Add
> > damon_ctx_total_monitored_sz() helper that sums region sizes across
> > all targets.
>
> You could also make an arbitrary cap by setting the static size quota.  T=
hat
> is, if there are not only quota goal but also the size quota and/or time =
quota,
> and the different types of quotas disagree about the real quota, DAMOS us=
es
> smallest quota.  You could read damos_set_effective_quota() code and kern=
el-doc
> comment of 'struct damos_quota' for more details.
>
> So you could apply the total monitoring region size cap by setting the si=
ze
> quota of the total monitoring region size.  Could that work for you?
>
> Adding the total monitoring region size cap makes sense to me, and I thin=
k that
> will make user experience better.  But, if the size quota based cap works=
, that
> could also be handled on user space in an easier and even a betetr way.  =
If so,
> I'd prefer the direction, to reduce kernel code complexity.  What do you =
think?

Hello SJ,

Agreed.  quota->sz combined with the smallest-quota-wins rule in
damos_set_effective_quota does express this cap from userspace
without kernel changes, and keeping the kernel side clean is the
right call.

If the UX argument carries weight later, I'm happy to respin v2
with sashiko fixes addressed.

Thanks,
Ravi

>
>
> Thanks,
> SJ
>
> [...]

