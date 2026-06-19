Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0041ACDB46B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B300D6B0088; Fri, 19 Jun 2026 11:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE12E6B008A; Fri, 19 Jun 2026 11:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0DD6B008C; Fri, 19 Jun 2026 11:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5497F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:29:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9B141C4F2B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:29:29 +0000 (UTC)
X-FDA: 84897046458.20.1735369
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id C79DC100004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:29:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k0s2v7nt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781882967;
	b=OVxLeVLsL4fuNkqgaH/J+MZfXDniYxZSIzQGtrBlFH6LoZy4PihJVDMwJ+/dvIp4m319l8
	bWRaDd9cL5I6S1O7DPWOB8h8OpWqyK29yrotQDgKfQJhgsXPz8p8PIv3EpD3xaGE4wn650
	nnWtThci1F0/Hu2kaM/0mbIDATAONrA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k0s2v7nt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781882967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dULTLRE6f8vtBip1INjm35ttJ1pitKtvcCZ3p4j8QbM=;
	b=jb///yE3hB1mBbLb10V5gRcizGXtKPQrxCrmhFpppzJH7a9cw/5ZCpYgVIp2A/RRZSMKVv
	jVajAWpqVyNNyrQpeR5uCb/VkA0Bb1JVGBQUhq21JGxMloSsRIMJsxMSa1KTn/oOXKW66N
	Ju6dY+ZrXGgU7KPAKOQdV95Vc9nz4TU=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c07ea058c0cso337403366b.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781882966; cv=none;
        d=google.com; s=arc-20240605;
        b=fnIcU6POmXJdF1nNUpzXCZdc8MpWcl7NWzDwA7aksLq8n/RwlCWfwmHvPmoQDO+CS0
         tM8uma6O9PLvhKjIT7bd1XbYAJU0JmmALRaw1cHiJx5l6OTDeCbIa6Wds3yEDxdGnBpz
         2maaGKnb9JZ+4tqpoPO+z+Jh+G6sTvxTRex5WaQYZjTMFTc2XRqfB67Kc7yHvY2l1jdu
         scZm3BfUIb4sfFvwdt2YVZk6+TnYWUvCx3ZHSXdxJe9PVf+/GX4WGyYVNYd55/rGNLXk
         bSdzuUewthtZqa2rbzOSp3tDKXb+rhnL6apTyhXweXSJuMJDKF49Ow5pk+TSmk41pP/6
         IW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dULTLRE6f8vtBip1INjm35ttJ1pitKtvcCZ3p4j8QbM=;
        fh=lb+ZcJHZBFbslrWrDjmqRjItHGZHx5EIgUR7ACxQp8c=;
        b=KbIdaAc2QVztI/M4osvSzBPjJC1E80aGxronxexIS/mvR1uI9XtfmFCFcU24E4CGW1
         NcA/nGdoemR2Hnb9gWte933TVkclrJJ0BSYYcfFrVJfhYz8suWt26Cw2wCOKviNtg7vF
         05XISxarLwhFQoBT1A0mxGUt2rHeZBYRfM+PqGpHo3b8iD/ACBpQifEatpMGxAQcF9QZ
         ZkLK7y1RIJ9IPogFRpXiCoZRy45kmRNG2fpUyB0ywX9pCmKuAmf61BTdxqzuoEwwhwaS
         OnLEonJOnv5Cpi9K6bgxoysL1reCz2ISidi4gPE4fSwIDkk9E+9qNqCDTxe51LBnHeED
         KdHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781882966; x=1782487766; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dULTLRE6f8vtBip1INjm35ttJ1pitKtvcCZ3p4j8QbM=;
        b=k0s2v7nth/wYGed6rAm88/vpBIZqBboSy4+BOUWHfqWXZoF2rkjZqryUDgsZCbzsis
         aJlpB67wHbaDPiZ6uLvkM6jgh/1Or3f6BHpRFHx8KLMWm2lyxUg8KaIJHIW+N4UBM4gU
         zFwMITQJhRTmdnqGc60IDe/4qD3Xg5Hseo/4tusWDWMGBZJHKtxz4JHMgMHThATcwIN6
         Kne+2y6W1EfP+/dR5ob6WKTleRhaGAiJUlaosu3p3vmgglKatZbuYhC4/s2vSEqR4a/X
         bA/nIwiZbqwodeqGlAo4FrHjuudi/Ge2upUaXjqmdc6SuM7daJBsuzQmQ1nR258I/lgg
         9phA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781882966; x=1782487766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dULTLRE6f8vtBip1INjm35ttJ1pitKtvcCZ3p4j8QbM=;
        b=j91xKSg1qziErgZW1IwARqquw1EoU0W7iNi5Ev+4m9aS0d7JCfv0XaRIKHuKw62cka
         oKG/4qHI6cQVGqeQja7sVsLUUIeT8T38sn7yuBvTUqT7dmgxCT5CXmSmUvE4Psmz0pEB
         jcifKxieKoOKdIQ/6fZ3N5pe3SteM3JhopleyYXdbxVXpjs91Kj8QhNg4px2Y+oayhyw
         j6YsuivbD4uVrQNGY6gKIFBq0qiwWUoIe8+PRpVHYCqWFyjJnPCT055zYx94sH+O2549
         tpMnRaC2RJ9dAYiz6vOe10P8kWdAC3HsEfwpL1ghsmr9yW7U6H7hPF1gp+qh0v7PJ/lz
         zdGw==
X-Forwarded-Encrypted: i=1; AFNElJ/ecoi/0OMDVNMtBgSUq2L5hAeGR86VHk1qTv1AVTNBfgY6Pu8koG/FwGQIYiKITTzBM5Yin03RyQ==@kvack.org
X-Gm-Message-State: AOJu0YwpcUD+wuFQHAvK4qD+c1b/fIiMBZTCGC2rQyA50Xt5nQO0kAr+
	w23B6u66FTlk98kJeW8JGpzOJ+m+OqL5WzQna691VhYkESzwjqsleJIi3X9SYbfS1QIgi3gP7ye
	APN+XA5N7el40Os1Rg8KLdKrDdCvGglk=
X-Gm-Gg: AfdE7ckCpR7z+p5R68RgxZEcKRd8OCzTPqvwoyZPZimgG+iMndZmXdsk7nvdFSH8lUJ
	NwUIPhBJpqni79l81iy/g0cwf7/j6kvwkU7iOED22IFJg65ZIJzh2YaTY9bGobZrp16rdy04pGM
	yruu9eBai72siN/26x5fZtsTOcRUU/VI9PdpeBZOCHKhjAj472poO9TLocV/GtyHDAaWtya2NFm
	DeYJZ9en837VhCOyBXVIRwyif84wb1oQBATpt4kbGwCU7tUM9n93HhkPxQQ/8qYBc17FNRXtpI9
	v5lZnE3tLA==
X-Received: by 2002:a17:907:3f08:b0:c05:a987:6818 with SMTP id
 a640c23a62f3a-c0b74791ec7mr160512166b.45.1781882965830; Fri, 19 Jun 2026
 08:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260515124218.151966-2-elaidya225@gmail.com> <2026061632-papaya-handwoven-d010@gregkh>
In-Reply-To: <2026061632-papaya-handwoven-d010@gregkh>
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 19 Jun 2026 18:29:14 +0300
X-Gm-Features: AVVi8CclmblgOHLTebR1IvQr0GdtabbyWwRGzxpmUmyAO7FztZWfvJDgibSTRt4
Message-ID: <CAP48DwbYt3-3c+awg_s-=uHjKq3aE1J0Yx_XvR+v=hhsVMOSqA@mail.gmail.com>
Subject: Re: [PATCH 6.18.y v4 0/9] mm: backport sticky VMA flags and
 soft-dirty fix
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	ljs@kernel.org, avagin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x88hht1sgsk3obgh4bsab8uihpc1e9e6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C79DC100004
X-Rspam-User: 
X-HE-Tag: 1781882967-863971
X-HE-Meta: U2FsdGVkX19rz78We8SlRltwKKUdmjrATxaVzR4rSCrBlAUCVvF4zqaSGKJQr6MpLCVaSJ3GS+Qyg6ivOObixMKtQWauTU34ehi+3TmGS8y2iVjU5GBBQvKvwQdngRIFVphFXccd+MZQZeZQ5b9kZQfCR+y35YeKz2RaprQnCa9pnYgpph3ODDSb/8fnesQiS5BikvFcD88BkS29ca3NGVaGE0M8jRwySUSjcDDDlPttukKCLwEdkzRU6y2tQVgLm7SnjPKVvjCs/FM0HPHvvZ4iitVt31mqqj171C8tnvRbsiaUeDcJ3BeINX3OVnHc9FbOPAp79A0qLxPAYgiemESMWE4/xFtwjhAnua+0TPHj1BiCM4tM9aCStpmAtFEqT4ibX1bzMn3B1el09MsN2+Ef8mXGR426eUARCI6R83QmBnCJ7VBSpmki2ydTKXdFdQtyz3DfW/wBgwLgfkQEdcYxxOBgX/6tZ1ATY8kD9poSAlkHR6dC8yOip3UBBXGwllRkM4GcR1CkGg0Qy5Oes5FUzLG9+wPv9Emurtxjt6DpMjUN3RBNLjmjODfA0XwCvG4rRdTIoA2VcUrOoI0m7WELyH5aA57edGBNXkR3441wOGXynpb79pnajqp/sKGfiLloQx4uU1Ukf0oWjUvxeCfIoAGAlCBDwluwl8jQ7moWtU5fPouXeIwai5AJr401iAmhYEnVXZN5iYnicnV30gYKGJp+FQOboWE0c2q5MXH6m9wRs3F7xAn9YXD3LauVi6K4dUnZaIMrpUme1APpRAy1eE67fU0gbw1xUsh34ZdtPaX5uDA+lqL2WsrPJ1+zgOXdfuG4qxLQgerkXsNx9lDl1Pq5m+M7uxdoTt6oNl782GGa1tEHFH94wS/ws6RGgRcObwnFvGvyizc2KPMRA6y+42/0B83YMPa91HpkZJE1CF0v+kZV4Kfl5u17Ngz5fmpqOs0WBg2kTfNCkkh
 NcmUG6ij
 07YZRXgh70opg5KiFrzGetjQgyqZtmqmmeEB2O1+2gs8I4+hOucnKe70hf4pzUIl1T6bqQZwSJKw4zfA9Mx2E/OZcUG3ef1G3549oijavZ8CpYbzD4h39/odmMqiyXk5OoiHb7tZUb/DxGFTfyFGyMn1HeSXHrCFpI9sC9jZP6Iog3+EhWuxw1uzPNCPhEMdGWc2wGUtNSx6CnJ4q0Yx1gaUXHfh/kAkyYOMGpOc7vfRuXAPfMNR31fDCQElW9egPCygykWyA4hGLSTLNXrMhWgyQa9ZEcdq50Gyay8+Pbt6fPLS8ZMxHcdkxPUDi9Q0qR06eA17zZsmntyVNU/Ntn0Vh9rRao5ZLMVyHpLUgHyOmVtRzUOJ6ftkpI5rz06d2FM1bZonSZeaOEm1Cl9+q8Q1+GZLkU46KIAPp5Gl/znbKDFysPFP3svuwdf7aYQ/PAFZpgqSFJmDjmvzOgTkWCfkLrmAoCOCJhU8/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

> Ok, but what does that actually mean?  A crash?  Normal user
> triggerable or something else?

The issue causes CRIU incremental dump/restore to fail when
VM_SOFTDIRTY is lost during VMA merge,
CRIU incorrectly treats pages as unmodified, leading to data loss in
incremental checkpoints.

> We need acks from the maintainers here before we can take these...

Lorenzo has reviewed the series and given his ack:
https://lore.kernel.org/stable/agcK1mzmGbB5KSpP@lucifer/

Thanks,
Ahmed


On Tue, Jun 16, 2026 at 6:39=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Fri, May 15, 2026 at 03:42:10PM +0300, Ahmed Elaidy wrote:
> > This series backports the sticky VMA flags infrastructure and the
> > VM_SOFTDIRTY-on-merge fix to linux-6.18.y.
> >
> > Motivation: CRIU incremental dump/restore can hit a missing-parent-page=
map
> > failure when VM_SOFTDIRTY is lost during VMA merge operations.
>
> Ok, but what does that actually mean?  A crash?  Normal user
> triggerable or something else?
>
> > Patch 8 is the target fix:
> >   mm: propagate VM_SOFTDIRTY on merge
> >
> > The preceding patches provide required dependencies on 6.18.y and are i=
ncluded
> > to preserve upstream behavior, as requested by maintainers for stable b=
ackports.
> >
> > Changes since v3:
> >   - Reverted to sending the full 9-patch series as requested by Greg KH=
 and Lorenzo.
> >   - Updated Lorenzo's email to ljs@kernel.org across all patches.
> >   - Added Cc: stable@vger.kernel.org # 6.18.x to all patches.
> >   - Added Fixes tag for soft-dirty merging in Patch 8.
>
> We need acks from the maintainers here before we can take these...
>
> thanks,
>
> greg k-h

