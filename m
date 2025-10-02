Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD91CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 04:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43998E0003; Thu,  2 Oct 2025 00:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CE68E0002; Thu,  2 Oct 2025 00:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B316D8E0003; Thu,  2 Oct 2025 00:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6D08E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 00:17:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38B6F1D449B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:17:17 +0000 (UTC)
X-FDA: 83951864514.26.B116DFB
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 56B6A40006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:17:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv8s3IWG;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759378635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctQddUgZm+88vHmtPzUekOskf2BJsO+AnrtcChvOlmA=;
	b=rCRRpMaqF79dkGzLB/gQQYgno9tWdOOe0pbs1Vh1eYeowAwmC/xTaouBJA49sfmHx5pLDY
	V21ZwkfFd8itHBwAxdBsvzqOOUhoEj4sMpV8AVcM8Dh9INbVPzXKoiAtaHqjiMraaB6gbT
	tz0oTuYt/CTkBZ3yv58EABfHAfQuGow=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv8s3IWG;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759378635; a=rsa-sha256;
	cv=none;
	b=qUHEOMzfb5ftTQXZLIc5gu9p65CArtmjEk1r2/RbnGgNMK2LlOCvDNpMZ6mnwDcgzZEw7a
	vfaXzUX4RUJAtYKMEWqZ6EStLMDX1bz1CzxUJyzfB7m8bvI1WZlX1dkxh28usVXyuw6Nbe
	7Vt64w5XgVmKvg1R5JVS5sIB9f9uz6E=
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-5aa6b7c085aso768899137.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 21:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759378634; x=1759983434; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctQddUgZm+88vHmtPzUekOskf2BJsO+AnrtcChvOlmA=;
        b=Mv8s3IWGYdVZkjzP8vCMR6x/2eSFNmRa99cBXXtdSNffZrPrfORtBntSB4yltszo4Z
         4NRG1JFWmscrR/xKZoQMYcXGKgSJP8kk4PXeG4beojmT8msdWv8UqzuCl4Ttogv86X45
         tsxJASwRNNTtx8Gaj2AGPyCpifsRjtDT0H1p6/hP1bCUP9eirLp1aAoDA70XBzxahIZE
         UdvO6JKJuKJTScPdCsXG0sISqbZ/z0SCXq/dnQkHhe2vdrGgeNKkiy3YmbIq817U7zWQ
         pXmO25rlE+t9vgfBsa7wio0QGOKCFrYiVZS5QvMNmxX+58wKBQcRTocc/QN2YmYRP2gQ
         UKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759378634; x=1759983434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctQddUgZm+88vHmtPzUekOskf2BJsO+AnrtcChvOlmA=;
        b=ZNA+RN4WoUADFCcaLpi4qNkHUHLqtNxp/ivBoq/Mv0WmGhEKmyOIxIYI7yu1VB5UAm
         2lxHVCnddmZRQaQcY2bZzc7muGX/yydgEL5E7jckqbC/N12EI0lpdUmBsMicH6+xDIa2
         imjVsojlfPzvaov/5KbH6ERw0ioyPWMnCCXu3IS4BXwVrakW9Wp2B2xDpqCz4M4/oAqz
         1/17ZnG65EsVhqfvRD6taOTdV7DZ3EJWKroNVWkaeWSIgZ7nfd4i2+yOOx1zdikyKXz6
         41QBB1OuJrnZmKY9aVarrlLjR13IYBcjrAakb3LMFN7kYUibcxQ6e2bfgBP9IVV2teTb
         mlMw==
X-Forwarded-Encrypted: i=1; AJvYcCVA3vQ8Hj3Pi6Fr66WGG2aiaibb23r6dxasCZ+G9Bjq/pB+GLhch5Ln2ljhwcPWghHDB1grbbk4Iw==@kvack.org
X-Gm-Message-State: AOJu0YysJEYRXKc0vxi++qngSMPlwj1CxRBQgj5oJgP5jsCjPytigBM/
	KdxYVFf5BpwBGLoOzGiWcq43y5BShRFsGW/oX4mx87eO+tOSoa8Fe/QMSlf+8XbKi/I6EsvRlrh
	bBrKSsYnYl/DAUho9lrWCQ0B1zLOs+4o=
X-Gm-Gg: ASbGncseeNyIZr+1h1IF2bqsRCyPydBNy8EGf7zPzn34MBb2YggY2KS6KgATrBiQuVr
	NZtGmzWKiC8ylQZ4WZldDh27C0fFlsEkrRF86bNlYrNgK27peCi/CqlV27FmcQHeAxE8UiAwM5J
	lODyfVz+fdDmdVCWo+S2RFhtwkfUrWJUw9X5wVzk1iRO4sn8hCMUiSJsxgZHJmqUM/oqwSgbLRD
	kfOlUkIRIUn4Hmo5vsvCgatpaWNsXnkh7Wsd5uEKvl51zYwSakDjpHEzs75RQG3qpkzub1YNM4=
X-Google-Smtp-Source: AGHT+IHtvWQt8jonztmIlXZVLrosCzlBFZCwfKRU9/rXACxnEYGw3JcofNOIt435bpI1Zm7zqg5PCoJh2gMscknY7Rc=
X-Received: by 2002:a05:6102:41a1:b0:59d:b0f7:664c with SMTP id
 ada2fe7eead31-5d3fe7043d6mr3036274137.35.1759378634290; Wed, 01 Oct 2025
 21:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250919212650.GA275426@fedora> <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora> <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora> <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
 <20250924125101.GA562097@fedora> <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
 <20250924190316.GA8709@fedora> <CAM_iQpXnvyZWrv4W45SBTDV-tCXU4Fz1=S8z_0s5en+U29vSZQ@mail.gmail.com>
 <20250929151149.GB81824@fedora>
In-Reply-To: <20250929151149.GB81824@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 1 Oct 2025 21:17:02 -0700
X-Gm-Features: AS18NWBSFERQychThKDKhC7xP4aDfnWKA8U5c5GLpDIk74WF-1WcxMsDvgDcjOU
Message-ID: <CAM_iQpVRruWNnMtP2BKfQJrHnA_B+ea84GbO_C2rF6cuJcj5_Q@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, multikernel@lists.linux.dev, 
	jasowang@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56B6A40006
X-Rspamd-Server: rspam05
X-Stat-Signature: n4hwgbautx8ccxah66hu9f7xs6u5xbxb
X-Rspam-User: 
X-HE-Tag: 1759378635-372988
X-HE-Meta: U2FsdGVkX1+nfMjPz//uJyXddPbeQ0I2YT2efVU4zIHlEUa2kBANQFVtAP+gs2SvoUyZq3ci/XojFMFmwZHjPtSlSw6Lu/laOBCNXUy4YmAWZIo/VSSsZyAXIM2QUVC+HoTCJ2KmLlqFUxxGdmQ9YMiGWLWn0GOsJZmD5TdgTVXTl6HwzuqSVvH2yfPG8lEWHvUanQ8FSfDpvsBrKFc0lLavQjqr+cCfVmGnrITbp4GEFP6kITgK/wqASO1v9fw3q8P7iykTu2hni7NdxX7468AdE+rx6EeRkX/BttNdn9nkAGJFRe8lVWuneV5hLqD2mP1SdTx16nK5oQzR25J5Fa15Y+N/HNId3IlN5HGCqKsRyWEa6/nNrbHQVoYHSd62c7BWJti7wLc15iJ67rcQI+yWDzWVIxMudUaIleMzA0RFf19LDB17s5BkLBNJGdxyJB1QjxoiPhy+U2OFYb+ND5wbsWcszNqH/rdjA3CWwGsRR+aJL0zezSOXU0K4anwLWnYg0cS0+HfB/qZr6rIb+i/TYJxqlvwgh19Z81pgOVWGN2LWw59lVR/uvvCfKLTGvR2ic//oNh7455VOdir6F8OEH/Zijzva4ADZkEE9XGdn8Ls2mJUQi6tNhvNoju51ZgQJqWJpcnTM9QTzgbJ+Bfw+c/001EiyfrffFzeryH9RtWD3EmY8VlG8PCizqve3nqAch9sYZZNBNG77iUgmMlqFlf+IWoaGHCmnh4IGLi+j9Z+7WRyMh3zZQg9ht4T9tpxiaCTPa+92Rc6duymVD90J67rG2VJ66ID2LlOLrLY4KM08u4CjKyjJielSApwHEklQ4ontoqK/KExYjlAklOiyvGXZSMCAKQHg7AphlMr8ZQEibr0dO4qmbC5SG8H3j1XjsOOGhJEwX2gLi6M8UjeAHPxf4mhs1GgJoRYzZsNTXAxUdU1q1y8ovRey7wUGNTx67mi2aw2Hiawkf9r
 hsal3LK6
 C1tenNve2nm2aD5bZ7SDbiz3eE9XKMnZCRYH8/QR3JLXj7HUHeKgQXJ3M8vvljWgbKeKNkpCgjJ9z43Jg1vRuo/aUWfOuAni3QuGyXtbhYqb/3zx2gauAQ018BAgUejNcGxqBV4JzG4b14QpArVkcjDqU0hjZC+RQsJOb7+mQkpTWIFZhDQWZhk21TsYLIPHdVgIlOc7EgSBfHqgTeVqC6ubIZhn5C1ZrF5LXW1+4AkXy7HcQJZaWXx3liPkBVCf3ZmGFNefyqteq67i9wIXg6wWEUBiaY/YdvA+gcv4sjB5UfiYlFriepp0/TuYIbEtsxs0tMFtjdKC+ivKsln9+hmbp1q295ddDHeGeMWSidZ5QcA2VCiLoiqKSmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 8:12=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Sat, Sep 27, 2025 at 12:42:23PM -0700, Cong Wang wrote:
> > On Wed, Sep 24, 2025 at 12:03=E2=80=AFPM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> > >
> > > Thanks, that gives a nice overview!
> > >
> > > I/O Resource Allocation part will be interesting. Restructuring exist=
ing
> > > device drivers to allow spawned kernels to use specific hardware queu=
es
> > > could be a lot of work and very device-specific. I guess a small set =
of
> > > devices can be supported initially and then it can grow over time.
> >
> > My idea is to leverage existing technologies like XDP, which
> > offers huge benefits here:
> >
> > 1) It is based on shared memory (although it is virtual)
> >
> > 2) Its API's are user-space API's, which is even stronger for
> > kernel-to-kernel sharing, this possibly avoids re-inventing
> > another protocol.
> >
> > 3) It provides eBPF.
> >
> > 4) The spawned kernel does not require any hardware knowledge,
> > just pure XDP-ringbuffer-based software logic.
> >
> > But it also has limitations:
> >
> > 1) xdp_md is too specific for networking, extending it to storage
> > could be very challenging. But we could introduce a SDP for
> > storage to just mimic XDP.
> >
> > 2) Regardless, we need a doorbell anyway. IPI is handy, but
> > I hope we could have an even lighter one. Or more ideally,
> > redirecting the hardware queue IRQ into each target CPU.
>
> I see. I was thinking that spawned kernels would talk directly to the
> hardware. Your idea of using a software interface is less invasive but
> has an overhead similar to paravirtualized devices.

When we have sufficient hardware resources or prefer to use
SR IOV, the multikernel could indeed access hardware directly.
Queues are an alternative choice for elasticity.

>
> A software approach that supports a wider range of devices is
> virtio_vdpa (drivers/vdpa/). The current virtio_vdpa implementation
> assumes that the device is located in the same kernel. A
> kernel-to-kernel bridge would be needed so that the spawned kernel
> forwards the vDPA operations to the other kernel. The other kernel
> provides the virtio-net, virtio-blk, etc device functionality by passing
> requests to a netdev, blkdev, etc.

I think that is the major blocker. VDPA looks more complex than
queue-based solutions (including Soft Functions provided by mlx),
from my naive understanding, but I will take a deep look at VDPA.

>
> There are in-kernel simulator devices for virtio-net and virtio-blk in
> drivers/vdpa/vdpa_sim/ which can be used as a starting point. These
> devices are just for testing and would need to be fleshed out to become
> useful for real workloads.
>
> I have CCed Jason Wang, who maintains vDPA, in case you want to discuss
> it more.

Appreciate it.

Regards,
Cong Wang

