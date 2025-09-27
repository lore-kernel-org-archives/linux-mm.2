Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE9FCAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 19:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DBF8E0003; Sat, 27 Sep 2025 15:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E838E0001; Sat, 27 Sep 2025 15:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864238E0003; Sat, 27 Sep 2025 15:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F47B8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 15:42:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1776E5BA5F
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:42:38 +0000 (UTC)
X-FDA: 83936052396.19.8446B1F
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E66118000B
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:42:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BQxHLX6G;
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759002156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xQ9bzFk69iukmKUY25ufCAqjrKMzVtKfHbiTqiaUsA=;
	b=X2fGMaXKcumfRqrQrHFJjkW0QrAS6XzGtiCxugaBWqeyqmPRx7QjhO1C583L0+dY9nD6YT
	CSWT0GbDgc5LicME7S+JC0ThRvaw/W4mzd19aXH/b6w6PT8vbHYwEz1xR3Z8V2QpNE5jRJ
	TalVvw3k8KlpeY0RRsG/0U1bL6ekL9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759002156; a=rsa-sha256;
	cv=none;
	b=HgJQO4lW5Ep7IEP9obeaQB38he3vmXhY6/AlKvE697quXI/35Zhn/vFs8ZkLIbZzcWm0k6
	giH6LCfy5KoaHQ6KnBkkUmUPOwuRDTovUmi2UY0g5Hq/4kfGq+r7eoyAC8gJ6TIDOK8Mv6
	ycyKKAib7Na7k9LRZJmeAewHML1gv9A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BQxHLX6G;
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-583a520bd81so1445333137.2
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 12:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759002155; x=1759606955; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xQ9bzFk69iukmKUY25ufCAqjrKMzVtKfHbiTqiaUsA=;
        b=BQxHLX6Ga5S1hova0/VfE6YFdQg6kFr4Mmn2EnQcw1rwoOUwnrpuTCe7bS4QPqLJ2l
         Agy5WFDeWp36XESIfthTbShDSV21rXmOuVMzFabXFLkdOnWuPMMijQKhHDlJcxrbUCUV
         sARpYwILiqGE/CP/OPy31oL/g/+Frf8UQE15IZ5o9anOzaEYTU7XCTRAjXbmbc8lIpum
         aSET3iVgwY74zE1e13mmUAIsq4M+WwMLVyyJyih22WbWwMPrX4+YUrkCafrJBw/bvQrO
         QBr5oxlGcJJw5F2UQ/9JV4kPHxuqZ4ChrayfLoU6uCxI4ANIXNCnwhzkCfzcmFQNdZTu
         ilMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759002155; x=1759606955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xQ9bzFk69iukmKUY25ufCAqjrKMzVtKfHbiTqiaUsA=;
        b=Om8wvzlXJalQ9rSQaR4wsDMUby24Gc3w825cnZu96L/66ebCtephO7RjAo94BSSBoz
         1GqqH/xqHnyxoqjfSVl23njwbv8CJJFTX9VlYoaoaDg6l0yf7AxqhjlAgv/e0xg7dvbo
         HXR2rHrPy0ioweZf3Tm4fBpgifxywRHAFJ7r/CFbxb0Jn+n9MR7v+U0zyZga5lIdUQT4
         Zr/nGrJwTibaLrjeLrU/Pp9MsY+t2vG+q5Y+55k4Wm93f3U5yrzXS+2264kZVcVDLBsX
         U4Lc4HnxhVWr2QouinVjh1in36wENvGZ+Yt+c2w6wDNG2Yub49AvNFaG8FRqRhE1gyo4
         zbnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsY/bMc5BNKyVtEtG28ZiGPW/DNMncFb4+4ELsqqujTqnfJfOFtnpDy73w/eB5Rvrgzo/OSIm+kA==@kvack.org
X-Gm-Message-State: AOJu0YypQpelaPdrBuw0TSZDhAgV4RPd4YpZ8AiaEOCFKz73rATXDtoD
	IqCsJ4otjnN4cZEfLMvFs4Cr5BROmUauLAO/gG+pm220mytzpjGJ7UWaBceCg0joj+i6hnAtgL0
	j2nivFMvvUSp5bW/8yjCh8HHaGzZDMg8=
X-Gm-Gg: ASbGnctNSOHwhiHfhMI0BY5JxmOSMIv/fWpOxDLJZ0LEUHKGrH+mB2xOcQuxZ2GVYwW
	8s1TLM+gTSbstJg4iaNKl5YS8vVX2uLLhwatU7vjYJtvt0Kqe2rVstOVYkDsX4VjsSaHhGLalNV
	PEqMSKuNcOw3L6YP90cKqLnrzNa0S7Oz4fP77p5HI4pNnwJnW9gKIBq0APalNZM/I2uu5jTLxmP
	UhbOdCTI2YyrGVAxn5M5CmHslZkjHNM4maAbmW7aICOxEVh11Q=
X-Google-Smtp-Source: AGHT+IGglDo1/gdOcNhsuSzZl7FEO053NNm+ZSGFGErw4ULSPn8POBz7Kmhwj8faLx+8S9aP6qgFUy5HNQzHFDYGmS0=
X-Received: by 2002:a05:6102:6499:10b0:5b9:c38a:c4f9 with SMTP id
 ada2fe7eead31-5b9c3a94dcbmr1525519137.31.1759002155340; Sat, 27 Sep 2025
 12:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora> <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora> <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora> <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
 <20250924125101.GA562097@fedora> <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
 <20250924190316.GA8709@fedora>
In-Reply-To: <20250924190316.GA8709@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 27 Sep 2025 12:42:23 -0700
X-Gm-Features: AS18NWCeP2cGzDoATwSVHNUS5qX7kDmrKwGEMa7Qt3ofJhYYTiaA4U-AxyJEbYo
Message-ID: <CAM_iQpXnvyZWrv4W45SBTDV-tCXU4Fz1=S8z_0s5en+U29vSZQ@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4gr1u5t8sjggf5f7ut5x373sf7pueng6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E66118000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759002156-39364
X-HE-Meta: U2FsdGVkX1/0dOefG/f+T6VdBCVkP7q6N+69F79gRCOqNfwLDPXG+UnbSBiHphN5/20aCi2F0cgLglYSHi+HU2EbrBpeuWkbiqhSnYoZiPnbomV3lR1ktg6cdDSvXyE0hmIk3R9OaLwQyi6Aqx5yzsaxlitGv79CT9fxT8Ppikr0NquONt8Hkl7nqFlqpVejmKPsfefDIukDajtVAPBmwBl2wFsgKNizsLAabnT26Ox5SxaeB0c40yLDfqrM41/N9rPWBHIJ4ce1Fpma809zQYuoF4AMjU4LLZYm2OdHRZQdAw72WAfwQ0mnQazfrgkRu5kl/KnkPvvaY12L8Mem+o/FHi4+IZHX6cocYnJHzRi5dendMLifGEn/XyqS1Khff0h7QkYy8VVTt504ZbvoPWE6i8Ph6SN1jpfgoQ6d2mLjxKqnAMG+mj1320u8Ny2ocGgEvZx1Yhv7B588uMT2ks+FV2YvDMAcWP2Bk/HpMYUEFk9IJ8JY2KealNLRfTv5fXQn/VfeyfX9cbTAx4H3bgb+86TR9YiLtc102sJJBpjKXibyiLq8UxM4pPzCviRDGtY0nxXUcK+JApcpkO/mjXbLxOmE1wr6KoMItDQh7njrbHDGCh6M57wKbnjW5BBUzUXL7aWICBYtwKNM5vbaIcgEosmZ2ytF1Ym1KknInLnhUFvKQDwn7gxNLIr5PrJRYDUdUQx1XQiOxYYKfq1fs7YgX266KHWaKKA9FJoyfDE303YDFWFJJy0yI0yNbvE0DcKiCjvbw/YisKpdS16MMAyo6nALwzfzA8g3UIGIDAEVPuZqIwoLHxU21+v1BpxvZmrMHsKXwvw5+6Ytjb3MGF9rKrPUz8QSHFUBPpZpw2BAF9QDadTqlkJHB44CR9woB7RYXGTi74AlLnHszPYty51VN7697J7TkvUPUKnztPcm8luLRuf102HbhNlH7IlMZvOUqSSSHMKbzuMt0E1
 9pBeTbaZ
 V7BW6Bk2W9Y+vocFlzLI0qALBMS3gcdQtIDfdd1k2J6mQPBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:03=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> Thanks, that gives a nice overview!
>
> I/O Resource Allocation part will be interesting. Restructuring existing
> device drivers to allow spawned kernels to use specific hardware queues
> could be a lot of work and very device-specific. I guess a small set of
> devices can be supported initially and then it can grow over time.

My idea is to leverage existing technologies like XDP, which
offers huge benefits here:

1) It is based on shared memory (although it is virtual)

2) Its API's are user-space API's, which is even stronger for
kernel-to-kernel sharing, this possibly avoids re-inventing
another protocol.

3) It provides eBPF.

4) The spawned kernel does not require any hardware knowledge,
just pure XDP-ringbuffer-based software logic.

But it also has limitations:

1) xdp_md is too specific for networking, extending it to storage
could be very challenging. But we could introduce a SDP for
storage to just mimic XDP.

2) Regardless, we need a doorbell anyway. IPI is handy, but
I hope we could have an even lighter one. Or more ideally,
redirecting the hardware queue IRQ into each target CPU.

>
> This also reminds me of VFIO/mdev devices, which would be another
> solution to the same problem, but equally device-specific and also a lot
> of work to implement the devices that spawned kernels see.

Right.

I prototyped VFIO on my side with AI, but failed with its complex PCI
interface. And the spawn kernel still requires hardware knowledge
to interpret PCI BAR etc..

Regards,
Cong Wang

