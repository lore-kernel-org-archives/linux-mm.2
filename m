Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4534EEE0AE9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 16:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610C26B008A; Sat,  7 Feb 2026 11:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8516B0092; Sat,  7 Feb 2026 11:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F65A6B0093; Sat,  7 Feb 2026 11:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C68F6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 11:22:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D04891B2954
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:22:25 +0000 (UTC)
X-FDA: 84418178250.27.0EBF707
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id C84D1C000D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:22:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V+NakGWK;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770481344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwwWpunZdHWYzN3Xk68ExpdP2afESY8vTDXEBhdG4Dw=;
	b=GSmJTvy9/dF8yJK9kP1ne/x7m6tuTk1ksWJzXNUYe7WUkDJxPQtBB707slrcAmqAmzAXSR
	vJKU73YQDjdhqtktHsRyTl6u3LgW2HYlnOM8hVfQ38n+CprjY6qZdUyCMmSC2PRJjNgaXS
	7W8EBepRfBAU8H1tRhG61J0FAvdPiJg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V+NakGWK;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770481344; a=rsa-sha256;
	cv=pass;
	b=dbQTayZ4p/x5/LPwv8Ma8+gJBC6hyCXxMYMyraD0YFsBzOkf/S4JwOnxMA7FX/ib5rjI6O
	HflzAvUYlmvAVc1W6LRR/pFJhsg9w5wvHyvi5mxQW2droRDs5OnKVJc0zM2tWX4yetjrd1
	94TqoLIsoxZOgfgpBuLUo43z9OMHK9I=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-658034ce0e3so5033743a12.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 08:22:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770481342; cv=none;
        d=google.com; s=arc-20240605;
        b=jZXATEVhUKekeUJjH3FfaI1o5CksKuEdXEwg0/+xJoIONjTix4qLBWxjj3iUgbtMh6
         EYjatlhmqDQO79wugo5F/7eQVpNrhVN/I/A5p4D8cFS3CE56uKiCZ4meryulk/QnEPPv
         dMos44oFknvPmAA3/FBwwzcBeLXT6YlC0IbcDMUUnUEprpusE25L2FQfDSMjeNgK3wGY
         Hb5Yhq8nMsiyAHGQKubd1FUhN3GQ9w2yn1q62vfbm4WomSM4aNZzo+nvA+VUgO1eDAZy
         mmqctpu/9v+zlkMe/Qnf5WUW7CISvEB7oKHcV6grPax/EXGpMOjV0n4hYSS9sKoT3q4+
         phXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SwwWpunZdHWYzN3Xk68ExpdP2afESY8vTDXEBhdG4Dw=;
        fh=+fbCh/FwfF0VLjz3wLAkQh/ucALT5bU4ruJCb6/wzbs=;
        b=PPanlYTKZHiDPtxajDtwKMttPncNym74x74HMEnS4sVCq/BCv6VMnvQlvV2EJPWFDo
         igEfH1Y+asNsFXemXcYxeANNpYsT2a+X6Msmt7mpxKSeV7+sOvHpB4FFxUxTnfnttY1m
         yI6CaYj1e4bACFQ431ak+V0BA6t00LmjXCHBSpb7aZ3W5++GsCP7ukegvOEbcL/OJEDl
         NOOTvtn75Q8N1Y5KYXiyAW7vsGrBLKGq9oNzXtcOLpOcR17Cop9KvZN0bN06dZeshDcK
         sHTF2XKdDFEsJMlVthQu5ik7j7kLPWgP8rJ17HwvqNCynzfsFuBUK5lzaSC6SqGPdQ8K
         3kIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770481342; x=1771086142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwwWpunZdHWYzN3Xk68ExpdP2afESY8vTDXEBhdG4Dw=;
        b=V+NakGWKYURym9g8112csruK8o778pqYvJ0RN6EeWR1lfH8g9rLLkGJ4xCczRHC7wk
         c/EOsc0gGhId2t4RdMQta9siRNLZyo+0VVB1pB+P4/aJVQu8vFUnG9NM/iXcsYkTR2pI
         IhVumwWLcb/lCtU0VHN+gIXNOxxcg1CAFV0Xe6J7Wl4vCWDtY5ZcGMpD0PiV/u0jTA4c
         TiWiFfgp1nNxtFe2mB2m8UGoWFKh7xu+CeMNZ4cgz5hzhQq1sz/MGILSCnb+I+YqiQon
         pdzmHAQRghlpwZxFgSdeleoXGGKdb2YW4c6iMVVwzf51xqvaZofXcHKNM80cPMYvOxql
         EL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770481342; x=1771086142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SwwWpunZdHWYzN3Xk68ExpdP2afESY8vTDXEBhdG4Dw=;
        b=Fz3whr2tz2/liCoNltaay6ffYBU1n7ubRrIADZjkGugns0mdf+EwknA9WPqtM4WuCo
         EVf8fhN5H7b0bbNlhAiRz6t6D6jzd0/Ko9dp9cS3kg8cnnGV4bwkc8qOc1f1A3YT1YGG
         X38vuqhnr575vl+BFP5HDJjwSG5d5Q9g2yoTlaIBLRDhU5oC78bKYqy1YOpiPMeviCD8
         O119Y12jF9G3ZSOGIoHDI0noasnUYe4BvIhW6rGPMHOGZspsCDoeYfyWi19NyCEIqEbk
         3gmrFVf6H37xI//ifPoUHSKTlZdnoct7+ux5O2cznbaMBk1/aKjJuY97MW1eXvyM6H1S
         PlRA==
X-Gm-Message-State: AOJu0Yxu+HHHPgw8TYe99Xu44woefl5VwxX+eS9C6pIIkw8s/Qaa6XWy
	jQhuByaEwXFgTfW842hEkpBscfinJ2gOOoGvZri2teOCyWwNGrtZeNgqanryvFHwJC8VcR0XRLF
	oeIgq1vyq/P2+Q9/h4Ef1n7vEKb4kQ2l6VLuMbTRWGw==
X-Gm-Gg: AZuq6aKDF/phNd/rLfIweBybkRkbhmVB4mMPbHBkvPg8G8OvdBHOaHfYhejOM0kOMpr
	d/bFB15myGZWk7wLyhGqSlyhpCRgeUSjpJQR8xfVeqaMcz2mVOFj36zSFSsBtNAEVYB/eV6PWY5
	+fG3o/Kq7EeoDvSsxZShdHciZRkmchymVEZhGewuvLvXtzjxmaFoIfvDCy0GuXtylQBND2hPSpL
	HSKIX2QfJPXPwzdieb44IXlq9eMGBKXYI2A6ViDSQrjqoXl1/rlEOhWvBjmC+8NCaRydKBMNjLC
	uyyuAAUXMmvaZJUVCS7PoYjGlMpE6c5xrQn2aA==
X-Received: by 2002:a05:6402:2790:b0:659:4d41:9f6f with SMTP id
 4fb4d7f45d1cf-6598417ffeemr2801007a12.30.1770481342025; Sat, 07 Feb 2026
 08:22:22 -0800 (PST)
MIME-Version: 1.0
References: <2vxz1pixvk4m.fsf@kernel.org>
In-Reply-To: <2vxz1pixvk4m.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 7 Feb 2026 11:21:45 -0500
X-Gm-Features: AZwV_Qht3zZbep386bW-1KaiZcZERZVy19RJjY4UcBBooi6ZQsXGP2uthzMhXJg
Message-ID: <CA+CK2bCkLKrP6yvS=qpao1krfCbxUbj73bq8m8JnmKqtjp3tKQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] HugeTLB file preservation across live update
To: Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, 
	Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C84D1C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: d6hgipwxf9qfjg3migk5wif6abn89xky
X-HE-Tag: 1770481343-772765
X-HE-Meta: U2FsdGVkX19R+e6LErE7YBvsNzNaZ4irLQqAOpKlHc7Y9FZa4qjMANCMid03oJBjpRN/1whim33fc0o4kymB4DXchqxdpy7XUeWBO8iy/bd//SOe+dZa9CccZ0VW6AJ9D21QkHUvlgouJh6sBKlK3Z0vRujBrShhg+QY9T7D150q3yKdnmWzOUTXEB7/0aBZIVhSHZjN4cLjzf3+9m04+qli8l0+nuRFkH3lQPgwahNXEbYK/6r+GriQf+rUOHCz3h8B31xNmQOIggZN7B9MDgHnxSeplsvi2i0NamYrffwZIA4CHH9+AtrTQypSZx8nLm6Ek7+9n4giDm9dBoxWTmrgL05kQYpITK8JLRRyOt2XOW6D8v8fTxdM+0t2mz2BxBAQ6NWJTd4vr3GY223KUuygdectRdRlJt2+f97pzB0HUeUgJl48KG35+PQxTBTexjXPvxEjyB3g/8vdbpvMejpFnQdPl+VQrQ5s83F3eq5eBHi7xJy0ceAcamr4ZcCSnROflz6mdVmsaODvTtE88Dose1uXP2VD7NcM07XsnHxmFb9TT4yz1rxk+i6EUZcFmWXyC9jO/m7vKFrfRKDbc2H6uwM44D6Y86FxWW613kMymnl7YFjtRN3QbTS2V9SG8x65ncWovL6YrD+MB+rfoaZCkfISf9p0fz03PS3Rlp3k40eBxb1kEurTzeESjLXc96MqiaRvi/gOE2Pgug4CHTHP4stixR6yMI1Qdh/Qcnx9JaDHNFpFnJa0Z+DsKmdqn/qwxbafmRKe6WAETPswOVRCxh9L6EW41PF96uRZ4b9jDU54GKQwrzQXIvGEoM6BihXw4+2PhRhFRl0ts5OPS2JM8B9y8TmZZND9tDS7VG43CYXt1GY05ac8JkLHVYeRMwFebLCaFqfCYpVEKEfZHJoBknbWdZxwJ6Nm7m4PkWNW+XkOVV3uaGPCG64XIeEKhhn2x9NhBktl84DYgHK
 MuzyxT6l
 ueZFn1RnDu+vzKbbDUftB11L2e7UMqNpxyvqNxXTAKxwzg/Z27G+Vn5NQO3FsGKgZ9AulOxuFpfn1UzUPgn2313Af0GC+ZclAw3KfUWoRgQ06MzLo9AM/YlDqqR4gr1O5JD0/Kg7ZI7VkpYBpZnfmCfm/gzVxhZT5mOR4ykuXmWGkeaQOVbs4x9Mv72Qzsfu6bAkG+L6u2MICRJ/WuuUcrUKQHRf/HqwkZOPftfqQyZscbv60kv/FNB9zcVZyNc37qno5Wwo7q/bR6ZC01Bz7bs3VRE1wfN3C7Ow2uAHYMQI4sS/mBi7E2soxsYMTwEMkRW4/yPtShLZ9+bSJWIB8Uc6Ag6ZUq7TzLhiITBmy6+8M2uwmT3BBbJxzFr8eLnCsgFi7f08RX3zXHaLiJ93muqd6WwTBrEsYbdvsLdMJsiYt21ZWsqWssaPw88mymbNIDp5NBc/lPJIXp/RByRstGkTEDNOWJBiWvDwh6YRqQoSA5HxjRibt5WMcclfWfWOeSVPO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 12:48=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi all,
>
> I would like to propose the topic of HugeTLB file preservation across

+1

> live update for discussion at the upcoming LSF/MM/BPF summit.
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Support for performing a live update was recently added to the kernel
> via the Live Update Orchestrator (LUO) subsystem [0]. Live update allows
> a full kernel update over kexec without terminating running workloads.
> The main target is live updating the hypervisor without terminating VMs.
>
> For more information on live update and LUO, see its kernel
> documentation [1], the LUO patchset [0], or this LPC 2025 presentation
> [2].
>
> MEMFD preservation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> MEMFD is the first file type that added support for live update. This
> support was merged with the LUO series. The memfd preservation code can
> be found in mm/memfd_luo.c [3].
>
> MEMFD can use pages backed by shmem or HugeTLB. The live update support
> in mainline currently only works with shmem-backed MEMFDs.
>
> HugeTLB preservation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> While shmem support for live update is useful for many things, using it
> for VM memory (and other memory-intensive workloads) is inefficient. The
> next step for MEMFD support for live update is to allow preserving
> HugeTLB-backed files.
>
> Note that we do not attempt to preserve the whole HugeTLB file system.
> We only preserve the memory pages for the files specified by userspace.
> The HugeTLB file is re-created fresh on the next kernel and the pages
> are inserted back in. This lets us keep the maintenance footprint
> smaller.
>
> Current status
> --------------
>
> This support was sent out on the list as an RFC [4] in December 2025,
> and was also presented at LPC 2025 [5] in the Live Update
> microconference.
>
> While the patchset has got some initial reviews from live update
> maintainers, it has not yet had any review from HugeTLB developers or
> maintainers.
>
> Goals of the discussion
> -----------------------
>
> This session will aim to present the topic, explain why it is needed,
> show how the support works, and most importantly, collect feedback on
> how to proceed with this work.
>
> PS: if any HugeTLB developers or maintainers are reading this, it would
> be great to have your initial thoughts on the RFC [4] so I can present a
> more polished patchset at the conference and make the most of the
> discussion.

Thank you Pratyush for proposing this topic. A few more thoughts:
While the discussion should be about memfd+hugetlb support, the long
term goal is to make this work as an enabler for guestmemfd+hugetlb
preservation support.

Pasha

>
> Key attendees
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Live update:
>   - Alexander Graf
>   - David Matlack
>   - Jason Gunthorpe
>   - Mike Rapoport
>   - Pasha Tatashin
>
> HugeTLB:
>   - David Hildenbrand
>   - Muchun Song
>   - Oscar Salvador
>
> References
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [0] https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatas=
hin@soleen.com/T/#u
> [1] https://docs.kernel.org/core-api/liveupdate.html
> [2] https://lpc.events/event/19/contributions/2052/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/mm/memfd_luo.c
> [4] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@ker=
nel.org/T/#u
> [5] https://lpc.events/event/19/contributions/2044/
>
> --
> Regards,
> Pratyush Yadav

