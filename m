Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D1BEC111D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EA06B0005; Mon, 23 Feb 2026 13:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EF96B0089; Mon, 23 Feb 2026 13:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF01A6B008A; Mon, 23 Feb 2026 13:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6A86B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:38:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FC51139AC0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:38:51 +0000 (UTC)
X-FDA: 84476582862.24.FADDCF7
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E327100003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:38:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mADurvG8;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771871929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaaliuusWdg5dGb0oJesFHGG/4pSEnOgdp3cNJBGzcg=;
	b=5K2Yeiqy9p+Sdnqh8LneAn6suJcjq9BnN/pMIgxzHuXXtkxIvNxYh47Ad/Z1hUlhaDXBOQ
	W4kOTbtlfidVjP8080Pt4xl05w9KSYODGMI8TFOim63qMHOcf5AYovVFkChuEigUena7jQ
	6dIo0W9/cISD9pvD/R5XHzHSqN0CgPc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mADurvG8;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771871929; a=rsa-sha256;
	cv=pass;
	b=vTWs07S6c3rbjif73waHk2ta6oWmKTAkg1kmOd/FlHsQvDFmPjJPSggTNYgSHAJsJ44wc/
	6LdTTuw/3HQdrLwsI61Pqcmddvv6mXYz4bMLpSkfZ9bl02HQPy/lAJsT0RdR59mJI2BvN2
	R7YFjmS62hg3OrGK3w6iHzxDxBuD840=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4359a302794so3473903f8f.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:38:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771871928; cv=none;
        d=google.com; s=arc-20240605;
        b=OC0psACx2JHMolp6pELORU0A3X9cW73/GaKRBLS2K9zBqeV74GByljdsvNEspYKMvp
         5LCvFpu8Ii/+nk0L+uL/nJL8q6i5OQPMQ9dL1N1KpbpN83rALZqGHy0/msgDCJO764wR
         6AezkxLfWTrVqhjNLujSp9BTma3cl+zUGslBhoJ4sbzBcetB09BAt3geZC7cTR/kRNVl
         4J1BK57DEZq0ZMvW1YnHSs9PcImXtkFAwIM0CyLVqQaG6PZ50LsO8bPoRI78CzlnI5F1
         lCkOrsrBN7xefZrWANKdgoiNJKbT3qnBINGVDxDjpW3+lj96D96C5R8ZSXrvJeUCAhQn
         KMaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LaaliuusWdg5dGb0oJesFHGG/4pSEnOgdp3cNJBGzcg=;
        fh=XmOmc4BjF0BPH3UjESN+aZ8Ta70+JZkPw3FGAjLBHSc=;
        b=Zf9toh/edcuMTGMy2VS5jjOacYA9FThjQeZCHV8qgqGMDZgNyI3qt4xxiMjvy68bCQ
         vJwUxruBqHEdZDxIlqqLMyC9ShBNdlZPzd4h8Y8W5oE/X0uF/6BKv60uur7NBa6/yT9P
         nhR3T0pqSW8MXV39BlHj/9qjB/JMFQat8DmS3Q7kEf5jdcL186FlAw3D5pQ1P4WEL5Hi
         c0t76mFqgcnWNDqAfc57VOH9QzWjr8SPmZUgYIcj8C0EdlaLAg6lJb3KBA+adFsIAjJ9
         mgSMBhf0FTNwvxH3Tsgo/V6ODmCfwtnMY91U2tMoshJLJXX91icN3UgvfsNr6rXiu4h4
         8p+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771871928; x=1772476728; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaaliuusWdg5dGb0oJesFHGG/4pSEnOgdp3cNJBGzcg=;
        b=mADurvG8mjeLnloOCRLZRSizOqHuNp+o2IRerp7seKL0+dEMci1jlJU50gtSX4R6tV
         wrziVep2NEsTpJDS9xydGSPc1OzXCCoMAylgqfn6khA7u4SCcWo7gEKn/oggv+TGw5dW
         LciDcl2scLAXps0yNGrcC86XZTBJS7+uVCISOhkxQE58m0FXv2ZJcRn6kel2+edqA28l
         pmxB7MZycw97lA7DhqOIsZ8sjE4XbInJl3aUjsOZzmO2zcXu9lcUvLbVHp2sx3AB6iQg
         XyVT2SqKUpZqlK3JkSXbHsIRvUF/kZYy7i6cvGAuRkcYtAm4rlp9KDrzdzZcLB1/gaU4
         2Ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771871928; x=1772476728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LaaliuusWdg5dGb0oJesFHGG/4pSEnOgdp3cNJBGzcg=;
        b=WKzTQSOnrJi+6hOd5veR6xkFRdECc64KAGRrqB0l2mXTkOV8eL5qYlxWVJxQh0TWoW
         mpUp8EWl5g4LCI5ozwH0lTP9u3BzydyKRalzqgS9cEGrmBQF2xIGTdwdppjAfoejq0g1
         UwKX+LDJKebqOkpdNXJzxitDB082BWcHzr6LS8OPozQTijzPo3TTVlwO2fSPrjdUKpG2
         OX1RCxweI6L/IbXG8EWQuFn6OUwKjfBZQu2yn64IZw1Cv8G6BH4foRPNEX9UFfxBjk7r
         aPZGGzlaCW1pBUaov29lLkrP9w5yewrs4s4F7KsTQRMIQcRQOoC+OKtuJXRwK0Min/wI
         +8wA==
X-Forwarded-Encrypted: i=1; AJvYcCUl0J9pCvf/pQJLPcIyvUlV003XAqB3DWKHx4GIZsHwjCiLpKQzPEqGIDxNXauxBEjKCCtyUuDS4w==@kvack.org
X-Gm-Message-State: AOJu0YyBvVpjeK+mdqO0bprlOD6KtlCEoQpN0W78EqHLta9sRrnK7+DX
	miKOb/TIJIeyI9TCKqXM1me2I2KNcB0uaj49ltidXdah94xCbeDAbQ4ZTBx8B/xD2cKBRvSmzz2
	7tsYca4OtrRTHqZYYXLzFEX6B0qzJPBw=
X-Gm-Gg: ATEYQzyuRWbwtSBXFZOqgo2NrD9Tn/DKXTHrl/BYgcsdHJB2y9kIMJeal6k+emvXhxU
	bQOyqrJtw0npNpRU0FCrie0fOGA8kAU//rcqikBYQjHIQsSE1Dw/jMGm7eZFvMAE/PVkV1ceV2l
	j9TqBGvniCzjXzFPo1EbFnYusMQIvmC3PMXX0yRfSXccIIVK142e9pTbvhqcFMeHZnMvWUtS1BU
	uC6N/zZ+mWvi1g6Es+XsfBo25ZEd/tzw8ulzXtEV9LUVZQRG+2E6cHs4JrFjiJCOMobMWi9SQEs
	YpT0zuabW/f7uGCFPjUAMcHvNzv2XMHzz0XR6Gf1aYk=
X-Received: by 2002:a05:6000:24c2:b0:432:8504:a383 with SMTP id
 ffacd0b85a97d-4396f18554cmr16773573f8f.45.1771871927792; Mon, 23 Feb 2026
 10:38:47 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
In-Reply-To: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Feb 2026 10:38:36 -0800
X-Gm-Features: AaiRm52BrOX5FkdUTKkFSaNZU9Fc3hbGVmVN5ljf1PhDa-_YtGWaVpDwsRlHQGQ
Message-ID: <CAKEwX=O4ishgvhhZ1ssgbDUQewFamkyFT-uCpEWecWfe8SzwGg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Swap status and roadmap discussion
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Kairui Song <kasong@tencent.com>, 
	Chris Li <chrisl@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, linux-mm <linux-mm@kvack.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E327100003
X-Stat-Signature: dcwqqn8w6rz3wgw8fsqjkedajk6s6m7r
X-Rspam-User: 
X-HE-Tag: 1771871929-794208
X-HE-Meta: U2FsdGVkX1+yRJSkpU0GWAcB1YP5qrgQsFVPWRkDxxyQoS7UrTkOzoHEkok4SLkcbTogP8kLCLovaRe5txIqNKyGU4F+OvMBnFkvjlQJCObhFptwCTeRO6lV3RXI1TZWtIYfCoDdfxR3TGeF1bo6DseK1vIpMmOGEGcp7tqwYa0K3NBz6oMAXYFBEjWJMDuM2CVfCd9xgSNCgaIpUeGDziAJYYeyJF6d2HlUba3Ed2kjo3myvbCeoRFp1/cTX/stpgxH+u0hFlRhydAr6v2z8NsZoPLzNfqZFM6cp3NvZyhNPbQs2qdKgSnWlWagFTE5b+yZ7Cnc14Y/FpGCX2cQDWuy0IF1tGx6zSsg7UfNOru3kkuc0fqYflltHgESt2yZ3/H4WXrjYv3s7ZJCkc+s7oNKUzb/kfo2LhtBprKTWNHxjWv2cjDq2SZobijzRlcj6bCItM6WXjmBF7HMS2s7rkWFse5Eh3NU5Q2qQXlvY7pse1b25kmLrYAzXQMVNjbaS1Hdd0oaBLtDl9zpQqJ/R5CQDqOze+xiNTXmT2kMaHk3+hOs7a/UnwAje+MRYMAY1A5wJ3dEotspFf5qZT0TaucMRNpcBY/G3xynytLCCKHD/lS484fIoHzn0DU+9jRwDhy/ulMFqzE5ZGKTBNLyzcCWm0PwPWQ+jPp9Pnrt05mMxxvR41jr8HGLdyQPDzOaPfOy510L1xh9dJ0wK6sgP9XkpuwwawlgUFOHTvccZGPSBOTGNyTQ5uYthBkn3IHswhxyhpvatEpQGLsDcJfmP/O/HPLxGMqRwAd3G3+XiH1QHRNTCO/vHvunaYHpc1/qt8IiRCvl1AD3BGkd1of+UOM4o3xiUGfSkzcn8lHkSCyTw40ke9/0Q6L6xBFaxYItyD3QvIknAeo80wzWYMduMVsMu2BZ+McHMF+dAqFgHtrejwurxJaxyctTK8jwaioTJKwcfdiUVg9X5ZqHh5X
 ucvp8KEf
 RXNbkpqvo/XZ/YNZRi58qijBjxJkvFT3SwAB1r8Scju7OdAg50ySOYhesLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 2:50=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Last year, we successfully cleaned up the swap subsystem using the swap
> table design [1], and that's not the end of the story. Combined with
> layered swap table, ghost swap as posted by Chris, YoungJun's swap tierin=
g
> [2] [3], and Nhat's idea of having a dynamic swap size [4], we can have a
> flexible, feature-rich swap. And importantly, the overhead of both CPU an=
d
> memory will be minimal for all users in all scenarios, lower than the old
> swap system. And every component is runtime optional, configurable, and
> highly compatible with future features (e.g. I just noticed Baoquan's
> swapops [5] which should fit well here. Swap table compaction based
> on full list too).

I'd love to chat more about this too :)

>
> We should be able to achieve a solution that users ranging from sub-GB
> devices to TB-level servers will all benefit from.
>
> Based on the swap table P4 RFC [6], we will achieve (see detail in that
> series):
> - 8 bytes per slot memory usage for plain swap.
>   - And can be reduced to 3 or only 1 byte.
> - 16 bytes per slot memory usage, when using ghost / virtual zswap.
>   - 24 bytes at most for multi-layer.
>   - And can be reduced too by simply using the same infrastructure above.
> - Minimal code review or maintenance burden. All layers are using the sam=
e
>   infrastructure to manage the metadata/allocation/synchronization, makin=
g
>   all APIs and conventions consistent and easy to maintain.
> - Every component is minimal, runtime optional and high-performance so
>   existing users of ZRAM or high performance devices have literally zero
>   overhead.
> - The ghost / virtual swapfile has a dynamic or infinite size with no
>   static data overhead.
> - Migration and compaction are also easily supportable as both reverse
>   mapping and reallocation are prepared.
> - Highly compatible with YoungJun's swap tier, because everything is just=
 a
>   device [2] [3].
> - Solves large-order swapout and minimum swap order requirements.
> - The fast swapoff feature is also supported by just reading the swap ent=
ry
>   into the ghost / vswap's swap cache.
>
> And besides these, swap now has the opportunity for even further
> optimizations, e.g. PG_drop for anon reclaim since swap now has a unified
> convention; Reducing rmap lock contention as was once suggested by Barry
> Song [7]. Growth of the static swap file can also be added later, so plai=
n
> swap on top of things like LVM can finally grow without causing memory
> pressure.
>
> And there are unsolved design decisions that need discussion, such as:
> - Should we use swapon / swapoff on the virtual / ghost device? Or expose
>   it in other ways, or make it on by default? Using the classical swapon =
/
>   off provides huge flexibility; on by default is also doable and hides
>   complexity.

I don't think we should put limit in virtual swap space per se, as we
are not consuming a real, physical, scarce resource.

We should put limit on the physical backend itself, where appropriate (see =
[1])/

> - Should we expose special devices like /dev/xswap, or just use a dummy
>   swap header file?
> - How to, or should we report the usage of ghost / virtual swap devices a=
s
>   ordinary swap under /proc/swaps? We definitely need some way to report
>   that.

Honestly, just a couple of sysfs counters? :)

> - Is 64 bits really needed for reverse mapping? For the context, reverse
>   mapping here is a swap entry recorded in a lower / physical device
>   pointing to the ghost / virtual device.

I think you can compact this a bit. Swap space itself is not fully 64
bits right?

Just not sure if the juice is worth the squeeze to save a couple of
bits here and there, especially if the reverse mapping is already
dynamic :)

> - The swap device size is now just a number, to adjust that, we need an
>   interface, and what kind of interface is the best choice? Or just
>   make it dynamic (e.g. increase by 2M for every cluster allocated)?

This is very type dependent.

For physical swapfile, it's consuming a limited physical resource
(disk space), so it should be userspace decided. It would be nice to
make swapfile extensible at runtime tho :)

For zswap then I think it really should be dynamic. You can read my
arguments in my virtual swap cover letter (see section I of [1]).

[1]: https://lore.kernel.org/linux-mm/20260208222652.328284-1-nphamcs@gmail=
.com/

