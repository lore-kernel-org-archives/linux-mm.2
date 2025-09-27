Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4729BCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 20:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B66C8E0005; Sat, 27 Sep 2025 16:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566D68E0001; Sat, 27 Sep 2025 16:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455D98E0005; Sat, 27 Sep 2025 16:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0E58E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 16:07:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC39011AF11
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:07:03 +0000 (UTC)
X-FDA: 83936113926.14.6827C04
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id CC9A218000C
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:07:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BVs88psp;
	spf=pass (imf06.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759003621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HL8OHm/tOdgmn/uUV1BO+N8G/bzT1Rw1z+XhcpcLJZU=;
	b=3sHnYZua9qGyrWfkbktXSLAI+i9WQkpZbY40TpbOmYGxIelT7d6eCT5qinUuvV9HhP+0al
	mB75matUtUsJw9DKgpzQOPPXa3Nse1JwiZeg+dOx+Dpq3twPYAfjpk2qoZ/Pw7zSAh5Sq7
	gKqvk9Ckh9305RMVpNLAd0H1EPlRmuc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BVs88psp;
	spf=pass (imf06.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759003621; a=rsa-sha256;
	cv=none;
	b=bMaRCWMQcTjsn+uD1Kjh3UyuN8BZMVQRQG/UVsMoRE7yR/pXzN/dLhmhgmrBFJvKBcxoup
	YaWhZvWBrPGjXyDsJ/RP43KClJkjTqTjmZjgPzaQ00QscBudaClKdNMb956MSG6zsFXTkF
	WEF6xs9ZRABLq7/oOiv4Cbzq9cTzdjk=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5b59694136bso1106463137.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759003621; x=1759608421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HL8OHm/tOdgmn/uUV1BO+N8G/bzT1Rw1z+XhcpcLJZU=;
        b=BVs88pspxap4CtWVPnwsa9uo/fjSIHEr+Lk162R3jehvbpHWzAnGt4utElHt5gNFBN
         7nN2aDq1SfJ651YI/N0RnhKTbXVb6PDTN435f13ZzED1eSBCgIZNglpBN0qfoo6X8KUO
         5lHDlANy/cJbcu8K+m5/h82KLN3UqFEiamu1LcgCMELOTptrU+EyDYwCcAT9IplzdD7Q
         xSAqtELpNXjIC7g1lmiA1h8TIq47UcrxU+jgqyT9Gfy0rRfseScJYyw06fKhfR61LxPe
         7XSDd7zqbeX6i2rh9JNSb7kWQqjqvmqTdruKmUf6ql0sZkJppHADDbYGaMdTA1onksdk
         XAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759003621; x=1759608421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HL8OHm/tOdgmn/uUV1BO+N8G/bzT1Rw1z+XhcpcLJZU=;
        b=NbRY0m9fN9y0B35JGvaAodAVwbpVEvSQqQr5YHgkvyhfEnicWtJ8ihOzxv4csbGfvS
         m8CiI3Gjbqma+HV1kSaHm3Me2NWBnp6sCSa4AXDpcEV18PjZRZwW50sqeFiey5W6U1aY
         eJu7xM7RD822mBXnZ99M1FgMUgP3CA9pNLpxxKFWFOtVmxkr9U5yhv/vc8ILIPBayJzI
         4m5VrCkkD+b0zPtZaGsHbycFXTmBPri3cAa79ykWpNQq5RjEd9CWj/YTuXBBjVIv7VgX
         /e49SJ8YO0qPixbe07g8iaCSkXTigQemgWFdc1wiCZnhoOchWKuaXMUXL6eS68fnc6ae
         5NtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIqyRPSMrks9mw2gmgQP/VET/CRwF5IfzajVoOyUgWiDYF5IIbDN4Bty/jOr71bWbxqLg+NCXI9Q==@kvack.org
X-Gm-Message-State: AOJu0YyUs5n0hR14HGFMXkqUifhC32Y22MfYBuh8sIBp5OxRWC9KqJBK
	l83tqK9nhf3OWHUBDHkxTwWKGsWYRfeI7XuhUeuZ5hY9AZsWONIsy90qeXbKGg6fVitpXb3AoOa
	hBwpANyDBt/+G9JE/eJ2LGUEFJHbYeOI=
X-Gm-Gg: ASbGncuVJnC6R+OUtX2X+LursfozsFbqiDqQ6xZcYWdB2ksDI8SW1ZFpyRJJRmwNsON
	xgI8a5LFNuuph1ERTBNQ8i8db5AzA8cbz4P7RhlXQbHttw2l+auiz0ET7Ag2LmpcMOi0wWvevFU
	HGo69O22yRhDMV1NjcP3sMyKNKVnL+Bcf3lab7IWNkDqgRyOzrLiU3MCuFLEf31n+RUE9kEak21
	3WH8W85OwYagNitkbNFVZPVOtz1noTcnauXFV/aSAAlvswoK0U=
X-Google-Smtp-Source: AGHT+IFavD4z1GGoEGlY5lI3JUX612+I+UAMojZazeqkDP6BSDuGvbpnL+RUoY1IBixIMQhPSpIruVr/5IWa60JA5b4=
X-Received: by 2002:a05:6102:304c:b0:55d:b35e:7a58 with SMTP id
 ada2fe7eead31-5acce758205mr4579967137.23.1759003620680; Sat, 27 Sep 2025
 13:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <BC25CE95-75A1-48E7-86E7-4E5E933761B8@flygoat.com>
In-Reply-To: <BC25CE95-75A1-48E7-86E7-4E5E933761B8@flygoat.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 27 Sep 2025 13:06:49 -0700
X-Gm-Features: AS18NWBOT7tF0SL4tkvmWuhGCT6OBGfRbzY0O05dFjAR0c0T2kS4_McGk5cJnbk
Message-ID: <CAM_iQpWB1Jq88qDd+z7j+y1fEBRtV86LVHneLemHdvq28g5Dag@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CC9A218000C
X-Rspamd-Server: rspam05
X-Stat-Signature: ebbw7czafuxkbxommi5gqj1n3f3kzmyd
X-Rspam-User: 
X-HE-Tag: 1759003621-781087
X-HE-Meta: U2FsdGVkX1+S3v87Q2vZ/iaDfm4PCVsCSkbmqYPII6oGWLMQtH/q2leAR21hH85YZfWwX13lZ5SB/YwuPQ63FX/oApJ+dPcafQtESbBd8Ly407bzZcSNSKIKaQEKLtfc1TPwuo9XibcI9L7UGxiQGFO2vcfzH2go3aJiAWT4qEIPFrIbVVLQQiHpq8okilNpuHwKD7PRc3ZrPJCsCRGfKjkN+Nw9qxa7Ux5Raz8VaaYF5/it6UMNgJExFpwWnZHTFqROLVdBZZQ6+00ap8/e7a7QK7bSCBDOjrlENnfVZ0/epy3Bi3ue/bv6bJehF/asOy589yvFiPQLd+ylrPoNtBAtkajXqnuWgzRQrHUlqjtzvYWg0WjPm/6cy0ThILaAmdZ2XvlgV2NVa1F2TmGQfvbcFEsuGEvu//hP5kDyM6+iQto/5vMQplYKg1tMvvQkQIO+Uuc7UQ53zOfpNcOLLpc2+drig5lPNytOyJAlpy1eLxonMdaXyQe2xPlXOU2cwnBCzZds14AlWZExqrBeLn5He9aw7WQJW4BEgHrg5YxuE9hqSpxYoI8cuG2QnL9oFI6k0PftAIcqvuyAqQJH0Hd/2H/I1Gi7Hy6nctIGvZTuCbBjyqRFdfwAfzPxuxYDAqO7gJmWsE7NL+C/1vse4sVsjUL0GJilaieYRuJkhS+Rsw3I39bbQSXCGSJsigjj8Q5zuojp4EKtYkB2UUHGQiwHk9zYyoJfgMtZRyzQvId6FBAkOWDLOhEhEo/55jfwjqmId31IXunT4x03qIY8xWyFmphgfK3N8EmU/qRZsSFI9NMjejEijAUk15aixYn5kqKxcm0KUwPjUr0SspqOFJDWiDNt7lJZbM3RjY1qoy6A0Za3xf7oZ9ZM4qB+35AN4aW4Y2Y36whoxQdM8oK6d/JGvfzt+Gg/w/jiHc7pLDJLlaubHpu01NEfKd5/6692gZlTAav/IH4Whpn08PE
 GaJb5pVG
 8ViNn9ef2HhWobLTxSAuBBKxW1sI9kwFJcp3e5sYeTPhaY8OoAfbNKDnjCG/rlWTkm9+HA88YgWdhZtmqA3jxh1dLxIJVzcp/HFIA7Gv5QlLBM6n0rx4a2dc6Cm4kGazi19bOc+Wg9qAQGRGeFeQ/Yza68shvuaPp1fckorR5kfv2Bkp9r51v7mGKP7E56Atve6y7MtOk1CFfFOQqgecbq2zLQuHfKBJU4Svg6LFG5LeHTVKasnBF3Htk8AnOHsVLTU3D3LRQhea3Joajsh66oEYKyhT+GFa/CXCvZwNknT2xgsc+0E+OUYE84jLX+sWw1zEgP2IMpeLJZ1xilUS5uCVusPkyHTwyG3O+Ket+gXPPpVFhlfGYiPc+EO/2VK385WtNWFJgJqPbiolPcWq+zb8ZWAb1HEXecCha3lnhJqubBZO/bJM80VOFsDQ5fwe6pWxw2001w/auglA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiaxun,

On Thu, Sep 25, 2025 at 8:48=E2=80=AFAM Jiaxun Yang <jiaxun.yang@flygoat.co=
m> wrote:
>
>
>
> > 2025=E5=B9=B49=E6=9C=8819=E6=97=A5 06:25=EF=BC=8CCong Wang <xiyou.wangc=
ong@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > This patch series introduces multikernel architecture support, enabling
> > multiple independent kernel instances to coexist and communicate on a
> > single physical machine. Each kernel instance can run on dedicated CPU
> > cores while sharing the underlying hardware resources.
>
> Hi Cong,
>
> Sorry for chime in here, and thanks for brining replicated-kernel back to=
 the life.

I have to clarify: in my design, kernel is not replicated. It is the opposi=
te,
I intend to have diversified kernels for highly customization for each
application.

>
> I have some experience on original Popcorn Linux [1] [2], which seems to =
be the
> root of most code in this series, please see my comments below.
>
> >
> > The multikernel architecture provides several key benefits:
> > - Improved fault isolation between different workloads
> > - Enhanced security through kernel-level separation
>
> I=E2=80=99d agree with Stefen=E2=80=99s comments [3], an "isolation=E2=80=
=9D solution is critical for adaptation
> of multikernel OS, given that multi-tenant system is almost everywhere.
>
> Also allowing other kernel to inject IPI without any restriction can impo=
se DOS attack
> risk.

This is true. Like I mentioned, this is also a good opportunity to invite
hardware (CPU) vendors to catch up with software, for example, they
could provide hardware-filtering for IPI via MSR.

If we look at how virtualization evolves, it is the hardware follows softwa=
re.
VMCS comes after Xen or KVM, VPDA comes after virtio.

>
> > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> >
> > Architecture Overview:
> > The implementation leverages kexec infrastructure to load and manage
> > multiple kernel images, with each kernel instance assigned to specific
> > CPU cores. Inter-kernel communication is facilitated through a dedicate=
d
> > IPI framework that allows kernels to coordinate and share information
> > when necessary.
> >
> > Key Components:
> > 1. Enhanced kexec subsystem with dynamic kimage tracking
> > 2. Generic IPI communication framework for inter-kernel messaging
>
> I actually have concerns over inter-kernel communication. The origin Popc=
orn
> IPI protocol, which seems to be inherited here, was designed as a prototy=
pe,
> without much consideration on the ecosystem. It would be nice if we can r=
eused
> existing infra design for inter kernel communication.

Popcorn does the opposite: it still stays with a single image which is
essentially against isolation. In fact, I also read its latest paper this y=
ear,
I don't see any essential change on this big direction:
https://www.ssrg.ece.vt.edu/papers/asplos25.pdf

This is why fundamentally Popcorn is not suitable for isolation. Please
don't get me wrong: I am not questioning its usefulness, it is just simply
two opposite directions. I wish people best luck on the heterogeneous
ISA design, and I hope major CPU vendors will catch up with you too. :)

>
> I would suggest look into OpenAMP [4] and remoteproc subsystem in kernel.=
 They
> already have mature solutions on communication between different kernels =
over coherent
> memory and mailboxes (rpmsg [5] co). They also defined ELF extensions to =
pass side band
> information for other kernel images.

Thanks for the pointers. Jim Huang also shared his idea on remoteproc
at LinuxCon this year. After evaluations, I found remoteproc may not be
as good as IPI. Remoteproc is designed for heterogeneous systems with
different architectures, adding unnecessary abstraction layers.

>
> Linaro folks are also working on a new VirtIO transport called virtio-msg=
 [6], [7], which is designed
> with Linux-Linux hardware partitioning scenario in mind.

I think there is still a fundamental difference between static partitioning=
.
and elastic resource allocation.

Static partitioning can be achieved as a default case of dynamic allocation
when resources remain unchanged, but the reverse is not possible.

Hope this makes sense to you.

Regards,
Cong Wang

