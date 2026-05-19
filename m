Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80A1CD4F5E
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207ED6B0005; Tue, 19 May 2026 14:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8B76B008C; Tue, 19 May 2026 14:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A6B6B0092; Tue, 19 May 2026 14:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC7CE6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:07:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9164C160691
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:52 +0000 (UTC)
X-FDA: 84784952784.02.10422BC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 65F2120005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OicAQ/6D";
	spf=pass (imf03.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xssGkiKE0NLLgIm8hq0sx4z1JVWvwtNlxiDz+CYQuyY=;
	b=oG435UN8N8XePcPf/vXq5iBmV5Y+aB31kBlmvafW8tzCR59+VKDC9Kwhyf76AjqbPWEBpc
	5DTCTh/yiQL6SSeGmCjqJo83OQ1OjKEl0L3qhCKVXBFDIbJDOJSlLyVVxpAPPcMmta+GH1
	hQ9KkufaXnWQ3lHvg0rS265WadAM7Ng=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OicAQ/6D";
	spf=pass (imf03.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779214070; a=rsa-sha256;
	cv=pass;
	b=O3XL1ESpKKMpUcu4m+nYFn04sJfpIPY7f991mnu6z8QrcXqtzrcpzJ200TQsCqkD7LiOYF
	UiNdJ3Etqqx2jvXxESvNGUGRyjUS5HHH2BzpzCk8joYbJeKOgKSgiFfWzK2FinpveR09ju
	/BxF/Rg8wOBB50xmpGK640V03lrfG20=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso2185e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:07:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779214069; cv=none;
        d=google.com; s=arc-20240605;
        b=QMkrgl+sPwBnBMIkgL0Amk91N2aKAdT4w5/hP4yVGPcy10k/aOHkKA7qaxl80hsTp5
         Tt+FQ+G0Inv1qTg1OWeP+ljRI+EUFcO2C6I4jvnFP4862yv+2U6R0o/fg1s2ht45xUzB
         UF1kqSwqWRYX47LVsJea4NW91nBkt4XTviOQVKUM2HljvY5CcDH2XHvP2v+E90zNYaDa
         qyK1qavahX2+AnhHwTIL+YrQVcGRejpv/fLQntlkNpbJxgY9sZczkeB7J6lbBYPPdrXl
         GGuwGgt8iXvlcuT/Vm1NRrLCEaVFASSFsSWiCcW6wmN4j2ASYolzaDhG89Oh8YAYTATw
         MK7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xssGkiKE0NLLgIm8hq0sx4z1JVWvwtNlxiDz+CYQuyY=;
        fh=X/dcK3gMBLheVxmimqKezrL/+ssJyfm10vm1mUNRDyU=;
        b=BIE8gnQcDzng4zo2Ggug5gmFHMye2/5p1cC/561hCTgkALln1Axi+y8+8RIiNC0a1g
         Gk8bg5TeGRd54XuG4sXcjuEaJNMu6Q8sf/jUVp2Nu9UptkPanXcxDZ9L1vI++y9lElFu
         zqtVKX0Y9HVzHExlcFOzM/4Vh9/ACWVqI1wnjcqPd8xHAnxJJSiKFQ9hvAXOP+gDr89P
         XnoHmG/JItDYwVqb1iXLYjGusBjbF/Lj0eeh4//hJ/XpSsYDgN7MmsAGBfihPshupdlz
         KTuHSNFGHVV3Y/vQ++VGcQC4Yk5tACVHfUE14euQvK8DGoV+1qkZuyQIVbkQCpm4jvle
         8xjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779214069; x=1779818869; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xssGkiKE0NLLgIm8hq0sx4z1JVWvwtNlxiDz+CYQuyY=;
        b=OicAQ/6DBv+3dY2rCuc6bMYbXTyHdqzycYLMCKXvM9fNQY4//yCOdhaji/AkNgGt15
         Hf1SgarqzzOZxp5ySXbuEq9HyQENhyfbKSeARF2RD98DdfckVEMT0Wonce6lGqrUhAgD
         0P65pRH7oktzRhOsOwQs2uFIYwr5tWvFKsqQscH5ulpWgSaZSXaW1kZTPt3CzTD/slCU
         poQwk/ntf+109v+mBoLaRav+tSS9Gxd8ncyzQCSJ17cwVkGUJa1gy/NST4MgO1KJfNJ+
         imVdeq9Je6BzGRZem0BYoAZaS+FanLozuuuaZYZoLZ/XaD4bEkgpb/QhVwGMZSdPHY74
         of0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779214069; x=1779818869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xssGkiKE0NLLgIm8hq0sx4z1JVWvwtNlxiDz+CYQuyY=;
        b=eakKP/QNyt7zCg5aaIV2BWi7ZoJIcU6E4kmJDeXd0608hXvQPnTygLaTuYWCqtoxd4
         0peeujHbXSQdifsbxae8y0PfZxEj/Nc+UryrRUP1PNwBCtVssRk+095mzAmYQmPp2bLF
         JHVMwryZASxHu2oP5Ma822RKhxClcV03mTlg0lM+XKrRpmv0UNCQqRgd9jREL2e/HwDh
         nd+4oxNcESx+yQ5/iEK21vpYrwSAQcud94jeuzOu4mzY6ZdCYTVzkuGvyKx4cwmnT+T1
         P8eX4ZuqTNpy23lNjIyHxl1HKQu3nAjUCZkMSFNFVsj9I90I1jyOaUgGIDb4MEOsfKpS
         QAVg==
X-Forwarded-Encrypted: i=1; AFNElJ994PUNBDPw4sn1e4tuaG68/FojP3GzrC/uMZCzsm4l9ODIs+D1G5PThdktRfslmgHlsZh/uL9jLg==@kvack.org
X-Gm-Message-State: AOJu0Yw4CKLgJj4Br5tEf9BHA9fXNEMu1YGPSEY/ZVrap1YGwozg19Nw
	/PZPizOc2ulal9Jt0ffRSMgp5XjShIVLPxnIokRThiuBsqrMSWRP/lnUpc37YSGlpwcz6hYZ55V
	zCp+xAus4B+VHfloVH3wlp5pYlOtHYDjJzO9e5y2L
X-Gm-Gg: Acq92OHSEzzoOorfTcsh+FYkEWyMORCYa/dZo6wvz5JrxNT1/Hpp6VOASSvx283NtTB
	Te7MYLSDhopXgFaS2SC03hj9Mn3VQ0EcSQ3h437Xc0rg2q5404Tokf+SIi8AS+SITlf9WCRJifN
	IqK5MRjCPXuIVGbSG3hvg+Ifb4008c4xqGaOfN5la2HLis0y9eiZaxaGlENpKcDUjzkHCicq82l
	Ta1O9NmytcC4+LgsY8yRLqXVadgpJt3JNRxJQA8gotdMfj0bq5gTmBE4Sf30tIav/kCeUpgjGES
	H1R2Cm5foprahtvUfTfiH4h9d8FZWLDDOMT6zvejKkiLMIkr
X-Received: by 2002:a7b:cc8b:0:b0:48f:de33:777a with SMTP id
 5b1f17b1804b1-48ffd857abfmr3637845e9.11.1779214068422; Tue, 19 May 2026
 11:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <20260515-hinschauen-effizient-9e3a05a94f2e@brauner> <CABdmKX0d6Zsg+_TxXjB80UZR23ZvXzxYoWzORgwmx=ZiuE+Nzw@mail.gmail.com>
 <208fb820-d8eb-4832-a343-ef8b360e8120@amd.com> <CADSE00Lh95ygoXGKJGsYvQGEsFV8sVmwEC3uvh8M6r3ERzaJwg@mail.gmail.com>
 <88efe10a-8b93-4a81-8279-4a5559d0f17c@amd.com> <CABdmKX3yZubjDKbVqwrjHAiKyj_ioHzOoxd0wzFbJK=PAGOqcQ@mail.gmail.com>
 <01b6eefc-c107-4f8c-9d7c-3b86f54cabaa@amd.com>
In-Reply-To: <01b6eefc-c107-4f8c-9d7c-3b86f54cabaa@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 19 May 2026 11:07:36 -0700
X-Gm-Features: AVHnY4JsuFzXOj8AzAQ7jEDe53JgzbJyOG548qhgZV3zTdsbu0QldI49eMqYz9w
Message-ID: <CABdmKX1wLoLuWPUEY3D7afQhO0AUnOE7c3iE-VkPuKdeQixBxA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Albert Esteve <aesteve@redhat.com>, Christian Brauner <brauner@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65F2120005
X-Stat-Signature: gczknjtfbn3nwoctx7ufrwccu41ox5ij
X-HE-Tag: 1779214070-334822
X-HE-Meta: U2FsdGVkX1/nadBX/obUPLsOpzlsnFYpGTQbKABEQoRXZnYHwM+Q7TbbDhsP94gUy4Nn82SfvarTkowdS/rLZwQ/8+ljPYYS2UEaH1m/n0q/s0uUSk0t2NFawG6i/u8tJJChbMi3BLojXIAd7V3oqK4TATBdw+GeAzaFxwuXofMiGk+k5ut/+/kZgjpryahKC/Kkr6sVpKEqpKWBgMrAqkJqV2ROB/rUIywfnVR68J68eeTGULrEWeVXn+8LzmiF3jnKXEa/gE2HTQb6iHoSuQjAovIY1UGJjO0xNKJyk8f5FibQj5Bf0Sn5932fAzWNaeoL1NYkuRCNDq5Ct6RB+4lL7oOzvIP0VvCMVkg2C6bO0s+E0TjM+4qR5ypZn+odH8E4eJf9pBRPGCAUujuW1V5YjYjVjHLZTUR5/GpMWOxrKy8RYK8QGSP0Yg8H4ou/X94pwCoifIoUxoAZDKCWKSKkd8h2HtYm7Jx09or8mwVxjUXf6EYynoppA7LvKyHvevMp7uGmhv9nHf5aZ1ygaLr2wXBnqgMLoM8Dpu6f7c75onbrVW6JU9r9Vb/yzm+cM5jOJJFcPsmAiZeSZEZSISjYc6C1+cqkvQ9YpFa7KANVHsHFDllmPJDuRMV4SL2iyAdKM33J+KK0nNWjjFcCzuakc8zKc18T+i1wbdMFjEPMbACld+gd5hlLp/UK/W+ghdiC+pLD7eewkX2S//EvrWeVdAyK4jWO3UGDw/f7nfX9xn2ftgZvhYtpDb8fdTG8CELdQbP5BG9QJOPdUHo00JDXqBNjOwm4CsIJRBNI6Yflsrkux071XoG4WRZlqhFdgy51I7iAfPOdVr18aKWiVIrMx6swchoNGiQwR+I4uiNxAjPSUirSJemygEwiSWtRhJGQOfU7Oc2rUeRWjSNssBrbb+vc/C7hIBh2Hzudk4Yom8v46T+se5zfuQh+v9kBKitO81JipoCpWsNl+gc
 sQpgskzt
 315hZYZNvgK4CfRfhSLcCEfoN7dJTczA5HCPLJvX2cLLdL9r7Wx1HSGe05/0sSf2j1+4BBhqyoKTdiveI23YKNYjERvic3SJnz5CwODWvQVJrXY3Srii9PfK/SoOyyqW6npSm1Qfis5QQnJdR2BZ6DcYZWNvc3S1VFITdpbMBeqqT4ea1s2m4jzaE7I9ZLVIcH4aALlLemtmU7y0xLSaqWkKNnbaN44bdGvdJb8iZQK8hyrzrAw04E6Ac7d3J9XJXYfqZgQebQ7/bnaKh1GisVw3GBuHPkVHMOIx94lRoMKW64h1RofTx3ZUx7GNp/tpo/l8Y/BRRibokyHD/K5I1D+rGulLYbO1kMb81IGGmsWUBxnrPm4MEYTdB7kt6QcuZglZC+XzGhdrQP0bJJ3FpBM7jKyYNnToMSfySMbGvQo0Edm7F5nLhmpt2z5HCbnIqYUuv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:19=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/19/26 01:39, T.J. Mercier wrote:
> > On Mon, May 18, 2026 at 7:07=E2=80=AFAM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> >>
> >> On 5/18/26 14:50, Albert Esteve wrote:
> >>> On Mon, May 18, 2026 at 9:20=E2=80=AFAM Christian K=C3=B6nig
> >>> <christian.koenig@amd.com> wrote:
> >>>>
> >>>> On 5/15/26 19:06, T.J. Mercier wrote:
> >>>>> On Fri, May 15, 2026 at 6:53=E2=80=AFAM Christian Brauner <brauner@=
kernel.org> wrote:
> >>>>>>
> >>>>>> On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
> >>>>>>> On embedded platforms a central process often allocates dma-buf
> >>>>>>> memory on behalf of client applications. Without a way to
> >>>>>>> attribute the charge to the requesting client's cgroup, the
> >>>>>>> cost lands on the allocator, making per-cgroup memory limits
> >>>>>>> ineffective for the actual consumers.
> >>>>>>>
> >>>>>>> Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> >>>>>>
> >>>>>> Please be aware that pidfds come in two flavors:
> >>>>>>
> >>>>>> thread-group pidfds and thread-specific pidfds. Make sure that you=
r API
> >>>>>> doesn't implicitly depend on this distinction not existing.
> >>>>>
> >>>>> Hi Christian,
> >>>>>
> >>>>> Memcg is not a controller that supports "thread mode" so all thread=
s
> >>>>> in a group should belong to the same memcg.
> >>>>
> >>>> BTW: Exactly that is the requirement automotive has with their nativ=
e context use case.
> >>>>
> >>>> The use case is that you have a deamon which has multiple threads we=
re each one is acting on behalve of some other process.
> >>>>
> >>>> At the moment we basically say they are simply not using cgroups for=
 that use case, but it would be really nice if we could handle that as well=
.
> >>>>
> >>>> Summarizing the requirement of that use case: You need a different c=
group for each thread of a process.
> >>>
> >>> Hi Christian,
> >>>
> >>> Thanks for sharing this atuomotive usecase. If I understand correctly=
,
> >>> the actual requirement is attributing dma-buf charges to the right
> >>> client, not putting each daemon thread in a different cgroup?
> >>
> >> Nope, exactly that's the difference.
> >>
> >> The thread acts as a filtering agent for both memory allocation and co=
mmand submission for somebody else, the process on which behalve the daemon=
 does things can even be in a client VM, completely remote over some networ=
k or even something like a microcontroller.
> >>
> >> Everything the thread does regarding CPU time, GPU driver memory alloc=
ation as well as resources like GPU processing and I/O time etc.. needs to =
be accounted to one client which can be different for each thread of the pr=
ocess.
> >>
> >> The only thing which is shared with the main process thread is CPU mem=
ory resources, e.g. malloc() because that is basically just needed for hous=
ekeeping and pretty much irrelevant for this kind of use case.
> >>
> >> The problem is now you can't do that with cgroups at the moment but un=
fortunately only the kernel has the information you need to know to do this=
.
> >>
> >> So what you end up with is to define tons of interfaces just to get th=
e necessary information from the kernel into userspace and then essentially=
 duplicate the same infrastructure cgroup provides in the kernel in userspa=
ce again.
> >>
> >>> If so,
> >>> the `charge_pid_fd` approach achieves this directly by passing the
> >>> client's `pid_fd`, without needing to add per-thread cgroup
> >>> infrastructure.
> >>
> >> Well it's already a massive improvemt, we could basically stop doing t=
he whole duplication part for the GPU driver stack and just use cgroups for=
 this part.
> >>
> >> Doing that automatically for CPU and I/O time would just be nice to ha=
ve additionally.
> >>
> >> Regards,
> >> Christian.
> >
> > Hopefully I'm following correctly here.... So you are duplicating the
> > GPU driver stack to achieve remote accounting on a per-thread basis?
>
> Not quite, we are duplicating the handling cgroup provides in the kernel =
in userspace.
>
> For this memory usage information as well as execution times of the GPU k=
ernel driver is exposed in fdinfo for example.

Oh I see, thanks.

> > Does this mean for GPU allocations you currently have some GFP_ACCOUNT
> > magic in your driver to attribute GPU memory to the correct remote
> > client?
>
> No, we just expose what the kernel driver has allocated for itself. E.g. =
page tables, buffers etc...
>
> When userspace allocates something using memfd_create() for example we ju=
st ignore that.
>
> > So this series would close the gap for dma-buf allocations,
> > but what about private GPU driver memory allocated on behalf of a
> > client?
>
> Well we would need a cgroup which isn't associated with any process were =
we could charge the GPU driver allocations against.
>
> But good point, charging against a pid wouldn't work in this use case.

It would be pretty low overhead to put a process doing while(1)
pause(); in a separate cgroup for this purpose, but I guess a fd for
the actual cgroup would be a little cleaner in this case.

> Regards,
> Christian.

