Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B79CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79486B0088; Mon, 18 May 2026 19:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50036B008C; Mon, 18 May 2026 19:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65766B0092; Mon, 18 May 2026 19:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7D2D6B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:39:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62315A092E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:24 +0000 (UTC)
X-FDA: 84782159448.05.0178DF6
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5ACC120009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WhAUNNlW;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlgWSbw/qDy0FEEgyFzO7eBFoHyyLd7vQDOSYcU9a5s=;
	b=nX3Y35r0mjCp9cnz+RIfAfBzmLg+HUEoiIgkhUelboJaf+qvNXeRTu5OMwREPmNrr1Ree7
	ADYGD7ZkbeJoZPXId/Ngvpth69EB59meuafeuVxG5MRC7OnWWwzpuO7W8cYsliB/R+kg3/
	xwisphJ1LWl9y6JSX/OosLubV0CAnPA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WhAUNNlW;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147562; a=rsa-sha256;
	cv=pass;
	b=WiIvbYTHZNvjWAQax+r01uO62Wmfa8lQ0b2h0L3DZMIvovRswDllH8lTyE4VhHtQu+bkCk
	aUshwtDGt5aX0y3O1K60vNgePTU5rnkI1ojMGuOC839WyjgpdU21ageFP9T4a+n8VD+T5M
	SznTf0Ha6i9bWkQt4LBKnfSbYjJnAas=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so695e9.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147561; cv=none;
        d=google.com; s=arc-20240605;
        b=FtSrutEXbEtPUZUAJbV7fPtSzSZI4oZflosbusvTuRGD+1rT0TEjVpDkDqEjcCBEvn
         2GroOm4ZuBBPL8i/2YzTM19IPnk0jBrjQuvJBGrPvLTomLUQOJi5eymKGywRBMa6VdAX
         vUS2EJvPcAjiIO4eF+BCc+DHM8fU6iAGEYh/lJwanF5oTU6aEmH/Mpe3x+duWqHmv2vE
         8KcpPISRBhvAv5CGWrTod3FXBNI9zJqTlORf7KjhTA9kNNefLs/cbgdusD9rGNa5Q+OW
         nZkUDP2fjk2wIpnF4RuvCbtshpHuQECYt1PxHnzzNehUq6o9x4OykzgzY3oq61nnkKBY
         h4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RlgWSbw/qDy0FEEgyFzO7eBFoHyyLd7vQDOSYcU9a5s=;
        fh=RDQj3V65tYId6YBVSzIPK6Wx1/EWu8os0/tScUiMTDM=;
        b=YoZBbdMJnhNX2Ptl0g4ipV+nCGmNLrVYmx+W62FyRqJoIK8mwmREdkCy8EVuLrm18u
         p/vzkNytw0p5srZUha6NYkZpolFlve1/pCxwhwfFL2Q2l8KppXThHZp38kXQxRN7T/AU
         m0zlH06oW6aHU/hH+XmWhAkHFECpKnhJya8zaykPlCIpm3iQmlQHsSuoGW7DmX2WIfe1
         7fP1+6P/HI8O8s826z0jeHJMpzcSRW4J+3MEknpHrZoCAfA5v5M6aGRsb3K92qndHsTA
         PrQ4+KQzLd5SXtUP6qW4HhDAmmQUWFg1XH8iImVWDHc6rR2mbMnw/lLm6UFeqk50OHnn
         hJgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147561; x=1779752361; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlgWSbw/qDy0FEEgyFzO7eBFoHyyLd7vQDOSYcU9a5s=;
        b=WhAUNNlWOySp25nuzD6PHUuXfgY900QKw9696GdkW/MLVWnB2AVPdhJ6VTjU6Vwwm6
         S2tBbfjSLcTSWG0uXU+QQBkSNsbRggvX/aq0bSaf/50I1i2P47wp7f9in5wSwABVKUV8
         gw6VEGnrE4430YIX0Eae48enTPLhIC/yFfqvYEyGRDiTCeXwUJobkSvJEJBa7VVsSiry
         R4Z6oZcM5ytNDs/n+OWd48rJOx/LQPxYb8/dMNkfBcSbJEBadD4raGjsdB6h4TeCmuOK
         F9ShrSWl5j97NrUuNPI0FiH/lXy6VpbSJV4JfczJYPKPaEekJ4Zvt/dEK64ySDIF4wGk
         EExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147561; x=1779752361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RlgWSbw/qDy0FEEgyFzO7eBFoHyyLd7vQDOSYcU9a5s=;
        b=nUJ+wyP/aiNorOP4KvAtES7FRbqvX+3Obq7YqxwiALt5fmShUFz3I2FQLrMJn5ArbK
         tpKLrj37ol5EgzEFk86iB/hmTK2G4pEpkpXVXpQZ6JyS9urXJzYC7f35/AQ0+h0qgN4J
         u+QkT5GJw93MOTR3HXI+Ekni0eAnb0yQpMg8m5KMe8e+QC2VESMOCacnbu5KcKfi1aGC
         uOWLOJLjQE2ad5tJX4liZJ9RVAmaYoApGDVggt6pDfo43jypYnPIHPLe59MY2tSEOPlD
         Rt85n/P33R1Zo8gOsRHbJ9euR6RmlIHIQn5IN3/oxHG3HpGqEG350TLX0ozDrJRfd4go
         4mTw==
X-Forwarded-Encrypted: i=1; AFNElJ/Hm+Sw+rlsGS2xfhdfC1s96yXB/eJO5s3nc/Oufv9hZ/N6OJz8C/Sw946MjtvexUZCbbEmM1exmA==@kvack.org
X-Gm-Message-State: AOJu0YzNbuEGgmHogbGi2Fm2TmTWL43K/O1rqVSx9dsbswr8O/u59Abh
	rWsu+e4Qumd69ZmruQzIz1m3+h+J1AHjpT1yWEvLDDhvdXW5NrmyAnIuwJXiHZFHPb+azkZ1tDy
	Q6OxGa/y3IgktWIbQn4z07Cnc/9te8f0gkMvC3gjr
X-Gm-Gg: Acq92OFkxpYwrMP4Ws68ueyGmbkUhsmf/FcNclBWgveg+fs0bbCgWyJ9xvw9i+VS+kd
	WcNEl59T+DOVOR4IDEX1rD3q6rqdNA24IRClgAVgAPWDj3ljYcrsLlYD/hLBNhAdUM1s/k3ALrV
	0UFksw9gmHFq0PR2UzyoTJYXr27P8CqiGPZWOkMKqPBzr/bMXeYQQ7TIkmksvgfFogZiZm1Sh+U
	yn0yH0NjNpIrqk6kqk1Rf7wSA1MBrEU4A0bM1ao8rIsa3zvdTKVfPrmRnusxjTFg4HdrA1VgbOY
	3WZqim5pkLz9hfI6LYjUTk7ZOrDgwyaeDvft1R4UrH0xuxKz
X-Received: by 2002:a05:600c:534b:b0:48f:d634:b18d with SMTP id
 5b1f17b1804b1-48ffa5e1260mr1775015e9.8.1779147560622; Mon, 18 May 2026
 16:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
 <CABdmKX0gqg309hcXcOHSj_yTg0h1zwDL34GDk8mX3wp4YoyfDg@mail.gmail.com>
 <CABdmKX3wwgovwS-V8rVC3=+EZcTvPs_cttpQb1w6WemwLAVhsw@mail.gmail.com> <CAGsJ_4y=Gsv=FSUjJ5+99Gg6ULUnv0LRexCGOGetzChR3YA44Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4y=Gsv=FSUjJ5+99Gg6ULUnv0LRexCGOGetzChR3YA44Q@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 16:39:07 -0700
X-Gm-Features: AVHnY4LTFYlENC6xQVXK8AijxUAKUMiH_YZR8cEYxhyMaKCwg0sVArYGdEg8UAo
Message-ID: <CABdmKX3GgCogr9pQFybnV1p_zuo1V9fqJLCXvk-HAnk1gwLoDw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Barry Song <baohua@kernel.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mripard@kernel.org, echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5ACC120009
X-Stat-Signature: ds1u3mdn6dhza1nxo9jgggrcnxdn4baf
X-HE-Tag: 1779147562-888482
X-HE-Meta: U2FsdGVkX18k1ZcaX689vEGkvFbMZ6p92EwIW2sN/fc/di5y95Y3ZO4EuO5yX9LUWTLlhfyb96/7F7NgWuQx9VwfevCxZTP4yqDlEjK+5C4v7ud6aVyTX/qoGdS/dvhtcYAIUoO55UKBRnU6FG2sVV2gYseWT78MpZ24Ynkq3FP6rLoRQYC6KNzqI0ChjhDbrqMygttPSCNGZDzYBkSZpqn8P3HZ+DnSorOy9WKRxP1/odlohCJq6MzxlSuFUO2PSBFCARGXkxJXg7yIvjXS91c8qtoQHmvsG7i/bBMu7EuqTiFLKhio8Y5SD6A4i+1KC2wfch9PxYiLs8OjBNCSVQpxRWuz7k3GSWmZNfgJAbnZuYV60UNNGOdYzLJ7IGi60Roh2gjwZzTt82MMIdyO32aKIsuDDBu+gJto3mAuNqVRIAg6huzerzNHKwp1DVqvAHebmhOYhGOBpNjWc3pSCs/VfCKTF4+L/862ahqsyLUSWTvB4ba2jshkOLwb8XOEYII5MdWoyUNJcBBks/qvzYvqR8Kzirvq2gISOhwPCzArIx4LqK40xa/c4WwP5JSyUTKHOq1jZ/Nu3GCtWZD9GbouskDdXYBKfH/e4Au3ZLc1JKUX/zyF5OefEgMYsyU8t/iO2TgxSyIIvbTvpvvLMPlYn7VcTrna8b7Md+Pb7D4xIP66XYrCYZ2SO/Y9dUcICu7J9NJmolg3NIPQueeXC0xmWzSkXNW0btz04gzJM3Dt132HXes9a0VDewmaIli9Fw/ek+YofuH8VoNbzNPUMHUlFAsacqyDnouFjDyUmUovtbwK+lMhU+OgQeS28tVccCTvSsIwbCIj5gTqxWmznwdUQpE1dxf8NZMFq8X+/uP27OuN0ve1Dz2/1pvxO6nVlLHiuT3TGXw6HPoORPTfIJ0BIvDBC4+auEpQ2i9RLR0tPvW4CfwVWZF3matslmUaVUhGU2oumZSkcNMskfQ
 SalYESv7
 exX5byH0ksinSJSJHaTLJV0samnTroJwDajMW47sfeX7DPzY6VRUVkzH1qk6vJp9905KTbbmF/PxQ8cKjfg+pdMq/UsqIfmW6RTSZvSBHqjF1Cb2HdLo+hAdOSPULHgn/4iPAPgBehl3lDq2KuyAKVL79s3Z7+H42h7XlieYdgq4iv8JRvilEd1MiJ5xNdzrQJDOoMBy6Xu3n+qGUOc9EtVI3sEEfY4XexY9TY4F7em4Z18iqBc7utVRIrTar3BpgnvyP0QrD+O2UpSdKb4W2/uEp8+faWbnaIkfmYJjwDp8TfsDR3p2c0OEIOmFq548q3JQnJEYdBCuC3HFzwI/c8XGydvQiFMEWb14SYl2E9Rpzz8BAtJr54LV2hZzwqXlilDe5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 3:19=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, May 19, 2026 at 5:17=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> [...]
> > > > > Yeah I think this might work. I know of 3 cases, and it trivially
> > > > > solves the first two. The third requires some work on our end to
> > > > > extend our userspace interfaces to include the pidfd but it seems
> > > > > doable. I'm checking with our graphics folks.
> > > > >
> > > > > 1) Direct allocation from user (e.g. app -> allocation ioctl on
> > > > > /dev/dma_heap/foo)
> > > > > No changes required to userspace. mem_accounting=3D1 charges the =
app.
> > > > >
> > > > > 2) Single hop remote allocation (e.g. app -> AHardwareBuffer_allo=
cate
> > > > > -> gralloc)
> > > > > gralloc has the caller's pid as described in the commit message. =
Open
> > > > > a pidfd and pass it in the dma_heap_allocation_data.
> > > > >
> > > > > 3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
> > > > > SurfaceFlinger -> gralloc)
> > > > > In this case gralloc knows SurfaceFlinger's pid, but not the app'=
s. So
> > > > > we need to add the app's pidfd to the SurfaceFlinger -> gralloc
> > > > > interface, or transfer the memcg charge from SurfaceFlinger to th=
e app
> > > > > after the allocation.
> > > > > It'd be nice to avoid the charge transfer option entirely, but if=
 we
> > > > > need it that doesn't seem so bad in this case because it's a bulk
> > > > > charge for the entire dmabuf rather than per-page. So the exporte=
r
> > > > > doesn't need to get involved (we wouldn't need a new dma_buf_op) =
and
> > > > > we wouldn't have to worry about looping and locking for each page=
.
> > > > >
> > > >
> > > > Hi T.J.,
> > > >
> > > > Your description of the three different cases sounds very interesti=
ng.
> > > > It helps me understand how difficult it can be to correctly charge
> > > > dma-buf in the current user scenarios.
> > > >
> > > > I=E2=80=99m wondering where I can find Android userspace code that =
transfers
> > > > the PID of RPC callers. Do we have any existing sample code in Andr=
oid
> > > > for this?
> > >
> > > Hi Barry,
> > >
> > > In Java android.os.Binder.getCallingPid() will provide it. Here
> >
> > ... let me try again
> >
> > Here are some examples from the framework code:
> >
> > https://cs.android.com/search?q=3DgetCallingPid%20f:ActivityManager&sq=
=3D&ss=3Dandroid%2Fplatform%2Fsuperproject
> >
> > In native code we have AIBinder_getCallingPid and
> > android::IPCThreadState::self()->getCallingPid() (or
> > android::hardware::IPCThreadState::self()->getCallingPid() for HIDL)
> >
> > https://cs.android.com/search?q=3DgetCallingPid%20l:cpp%20-f:prebuilt&s=
s=3Dandroid%2Fplatform%2Fsuperproject
>
> Thanks very much, T.J. That is very helpful. I guess
> that would require user space to understand the RPC
> procedure, including single-hop and two-hop cases, and
> make the corresponding changes.

Yes, this is solvable by having a policy in allocator services where
the caller is implicitly charged, while also supporting cases where
the RPC includes additional explicit information about who to charge.
This needs security checks to prevent arbitrary remote charges at both
the ioctl() level (selinux charge_to from patch 4), and at the RPC
level (not sure yet but maybe a private interface between system
components and gralloc), so that only privileged components can
initiate remote charges.

> You pointed out the SurfaceFlinger cases, which are
> two hops. It seems that AI models are also using
> dma_heap, at least from what I have observed on MTK
> and Qualcomm phones. Likely, we need to understand
> those RPC relationships in userspace and make the
> corresponding changes.
> I assume AI models are a single-hop case?

It's currently a mix because AI model loading is largely controlled by
vendor code right now. Some implementations use
AHardwareBuffer_allocate, but that comes with unnecessary RPC overhead
for the AI use case. So I think we should be trending towards direct
allocations from dma-buf heaps because model loading time is
important.

