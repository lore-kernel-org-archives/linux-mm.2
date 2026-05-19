Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC57FCD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D686B0005; Tue, 19 May 2026 05:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4456B0088; Tue, 19 May 2026 05:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2F66B008C; Tue, 19 May 2026 05:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AA86B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:17:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C46BC14A8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:17:26 +0000 (UTC)
X-FDA: 84783616092.28.28A4BEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 524EC8000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:17:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cM3I3Mnc;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779182244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahxcxmkOaihabfP2WFI6asNswH1uQirOjdb0LjAlcss=;
	b=Fhw79btQkLMZB9idR9FycZEFyPgivNtIME/B4lUAigkJFRBEewF25LyeMHjtS2ulujfoTb
	UI9HfIs7hwdQpOrHKaRCagppuUOmGKw/x5pnyF588/ssKPatA2PtqlAdFVYn72B85/VnM5
	tgvnvJmotHpXw79YnCk9NCe+5tGWZuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cM3I3Mnc;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779182244; a=rsa-sha256;
	cv=none;
	b=zdmToo+TGZVf+xml08qYSodBnjnNyutxXi0TgFr2DC6S4hjfPJxdlR0cp28f/GInOjnWBn
	JBDXrQlmt/+PP5YZ2J0qP/YTo10mUSmmGzqtnaaUv+PfMr1BHUHLi+ewowvJGIwYyojV70
	un20wrh6pH9fUIon1JI22ZWy9bsGodY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779182243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ahxcxmkOaihabfP2WFI6asNswH1uQirOjdb0LjAlcss=;
	b=cM3I3MncDkyLcYz6AJzTdkRXRAP6RNHfCCGRBIC9faN7rr64uQp0UGfln+TeYz54DzYDfR
	4vdLpw3eBCo1xGyA9KwVWpqblaJzqtgwkEWxmgniOhu4dhBVKR+XGqpCSBtcoFHL5ZzE+g
	aRE9HMdLjHsaS617kw/8wQEjVSnb4ow=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-byCPXCOfPzqPOAy24hEc1A-1; Tue, 19 May 2026 05:17:22 -0400
X-MC-Unique: byCPXCOfPzqPOAy24hEc1A-1
X-Mimecast-MFC-AGG-ID: byCPXCOfPzqPOAy24hEc1A_1779182242
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7bd5c421975so42345287b3.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 02:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779182242; x=1779787042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahxcxmkOaihabfP2WFI6asNswH1uQirOjdb0LjAlcss=;
        b=TO3bMgaiucs7cZzK72qXeMYfSdVuZtDpWkUyvQr2YOG7+pzxC25A0L7SIXainz6ZIR
         pSbZJ0hTQy9QJAyw11PEXgoAPzxw/D18jHLT7NaYZubv8BtQYZEUYpEoyyskAQBOoETM
         Dg5epqsgZmtDpgrqE31mivd4K1zJovzBoZr/0cERa3/RNcK9+Ag+9stYXIbDPoW5nPUs
         hnkyMRCmtSNpX4EQHZvXW8EO6QHufi3NdjAgXwxKOw8Vr7ZpCFL6vuhV0XPalOElS4Sb
         zeKzCirfAbnsuc6pt7hfkOkDE4GpLZdkIA3HQDrE7CKd4KZFIf8SNlqxTIpZkk5F1R8B
         8lUw==
X-Forwarded-Encrypted: i=1; AFNElJ9DyyXRe1dHIme7s4g5lEJPhcmbVA8rpal6KkIONO3WZwYQ9OryZmaCmaNiGzAGJtdD2l2G2s9yUg==@kvack.org
X-Gm-Message-State: AOJu0Yz4eF/YTi20zdubag/1oJW/R3EX6af0gGkbUu7iuzApN10eI8Qy
	fMQkwWVh1JL1PwTjtJ3UoCw9UFNR5lFox1aTFLxIWyOI2N/tqm85OOIBA25Zx6/QyMN/BSGQqmU
	BkscTCmh9qkZTWXfOluaVztEs0P18w9jVeqDJfjit7XLWmeqgFEsvSIT+iC2+sUz/R/6+LcWYgx
	s4KePsmAbCLCtP9EvPPxXggm6rKig=
X-Gm-Gg: Acq92OHz1ksXDacBvyt8V7RP7qgEkdTJ83f/SEa/sI/UhzFHe/2bLtgBeJir0QeWrf7
	ZMTUnZZmc923KAKfTWC5otOelX8vYMt3IxQhhj+yB+5ICmhouXi/jV0A06VBS4tIojTxWWQcAMJ
	qU5tW7o2+gqd/maHll/LORRYF61njfFFVtgN+R/bBmD14L7qY/v0xwWMr0A5qWRYImCtXGxYeHO
	15s6w==
X-Received: by 2002:a05:690c:c513:b0:7b4:f43f:1a23 with SMTP id 00721157ae682-7c95d1d5de1mr201683207b3.34.1779182241799;
        Tue, 19 May 2026 02:17:21 -0700 (PDT)
X-Received: by 2002:a05:690c:c513:b0:7b4:f43f:1a23 with SMTP id
 00721157ae682-7c95d1d5de1mr201682637b3.34.1779182241263; Tue, 19 May 2026
 02:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
 <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com> <CADSE00Lc42s2bzXzV5D7t1Enf56u4BVj-yXLp3Yxhm0=qMPvuw@mail.gmail.com>
 <9cc79977-9a42-40eb-bfa7-460881c1e10f@amd.com>
In-Reply-To: <9cc79977-9a42-40eb-bfa7-460881c1e10f@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 19 May 2026 11:17:09 +0200
X-Gm-Features: AVHnY4IPueDokk-vXqsRnZz3u8JK7NQGe3IxviX_AiFOJ3NwW-K39W0igYKchDQ
Message-ID: <CADSE00Lxti-MabrZq9KWijRxTHX49NOAV=hMdfLdqKrj-C=Jug@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Barry Song <baohua@kernel.org>, "T.J. Mercier" <tjmercier@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
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
	linux-media@vger.kernel.org, dri- <devel@lists.freedesktop.org>, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mripard@kernel.org, echanude@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0TGgsScE3AnWLV7eEMicQOZv78-KnNT7gThcgncZIn4_1779182242
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 524EC8000A
X-Rspamd-Server: rspam06
X-Stat-Signature: ua63ycypyensm1k3axp54amcciwwoxmk
X-HE-Tag: 1779182244-898087
X-HE-Meta: U2FsdGVkX194y6DgoAjVtghk1ZyWl4pgkmQ24hiG0PuiY/kyDY11apT5oaeguDDPvsco1cfiZuJCxF7KVw0nQApI7NevikRKnaNzp6sVzslLsTDy4kr7IFTGzMLyEvG2CVXWCqL16q74yPHdai2jy71WbtYUdPVklEUt6obzHugfQ0ZNNeCDp7mk14F/ElgelunjbpazMDJl0/2dF19BukV14nt5m80gf/flccb/dz19p/EiGr6KksA+9ZovAEwyP9V1EmhJH+hBXnG5yhjrQU01cvTOhf5IvhWw0QA3iYRBVPFUrkM/j8/hijt0gU/Gt5a63/ZGCBOtZTSQoKuDrv3yxop7YSprl0Tv9zXNFTCq5g4XB0TJymYiTLC/kHyrBXqrjIpZQ+JDSR4ioXB9ZksGprmFZVzXm7PPDhLiC8+rzcYFNej5dMrD3uMLUbi0DAMYDj2B2jjo/C4gbWIxkVA5ZqHrSk62el8OirZxdJ+3cyKZtMfX+tM3GvGrVy2R/M1fAout27yFogB1LIhIArTRYAuCaQM4wH1RMR33DW9VrD8fcHPoFxms65I+v0Jsh0q5uYMWqySxVAPe+JHstSp0CHRTnVpKGdIRAoRkTMlNYDbL259hAVGN3eJ76l5K9UE6Ti2qn5JvrC8+654wrBRifKUluD2rv05UMYaSwQ1xMLlfX0dQvKzLPvdPYVKJCtNjqb9R0GwbDA86v7W55pNVYpnM/FfRg19hCfPDI+DefpkifhFs6yMy569cDnG2qsbW7P5xZbbVfManHSKiG0tB9hKPv3wgv5u9m3pPo26QR9CuQJ5vnVUCPfteJxtXdFI1wmZBH9sqFyUcocrmzgQp8lLEVnzmcJGGh2O4Xro02j/fXt9FD+FS/d5E4/Fm+YsKCcUWhXtMQiZM5QTDWWIKz3syO7Q+K7I4VBwF+uo0jU5UwGO96kR+o0nC5Ps43TuZ0FMIjTXEhLT61ZV
 VEGhr7cz
 a0bA5vY9CRzCrT5cX6ZY5gDVVEWzLg1uopQH8dTIDNLl7duFkFqzcIo0+OoZrUBNZciC9+0cSytThnEtmw2n6vxHkh/pV0R6vGd1dbsviMZMx9KcYnpgRydkauPugCcV90xN4LtQWh3cbvvCh3ymtJIcqJcGgz9hxRWgeHfm/XYiypcf3PdHhWaCANHihGVXEb3tXVwrEGN13KGJ8BGcL4PxTdxEGgAKLBctRagwBw2Y3MSCP8eDrIdlbK8tHl5YbpMZpIgoe0T18oKah0baguu90ZfpJcKfwVj5viBXIQEu5FfsxhTQamxjy9/LlDYiCwL52HbAhJT15Bni9AM0XzWI/9H7zdAABmymMe0fQwateWYg681rOFbCpC07P3MO566L6lAjo8BdUhW9RQhkpLjQDuQSw4SOv27qlMRjdoL4+9ebg1OdGyEOZ4ckxAdt60fIh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 9:53=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/18/26 14:06, Albert Esteve wrote:
> >>>>> udmabufs are already
> >>>>> memcg-charged, so adding a separate MEMCG_DMABUF would double count=
.
> >>>>> Are there any other exporters you had in mind that would benefit fr=
om
> >>>>> this approach?
> >>
> >> Well apart from DMA-buf memfd_create() is one of the things which as b=
roken our neck in the past a couple of times.
> >>
> >> But thinking more about it what if instead of making this DMA-buf heap=
s specific what if we have a general cgroups function which allows to chang=
e accounting of a buffer referenced by a file descriptor to a different pro=
cess?
> >>
> >> That would cover not only the DMA-buf heaps use case, but also all oth=
er DMA-buf with dmem and whatever we come up in the future as well.
> >
> > I removed a draft adding an ioctl for charge transfer from the series
> > before sending because I wanted to focus on the charge_pid_fd approach
> > and keep things simple, deferring the recharge path to a follow-up
> > depending on feedback.
> >
> > The main difference between my removed draft and what you're
> > describing, iiuc, is scope and layer: my draft was an explicit ioctl
> > on the dma-buf fd that the consumer calls to claim the charge (see
> > below), while you seem to be suggesting a more general kernel-internal
> > function that could work across buffer types and cgroup controllers,
> > so not necessarily userspace-initiated? A kernel-internal function
> > will need a way to identify the target process, which sounds similar
> > to the binder-backed approach from TJ [1]. For everything else, the
> > receiver still needs to declare itself, which the ioctl accomplishes.
> >
> > ```
> > # When an app imports a daemon-allocated buffer, it can transfer the
> > charge to itself:
> > int buf_fd =3D receive_dmabuf_from_daemon();
> > ioctl(buf_fd, DMA_BUF_IOCTL_XFER_CHARGE); /* charge now attributed to
> > apps's cgroup */
>
> Well that thinking goes into the right direction, but the requirements ar=
e still not completely covered as far as I can see.
>
> Let me explain below a bit more.
>
> >
> > [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@g=
oogle.com/
> >
> >>
> >> The only drawback I can see is that DMA-buf heap allocations would be =
temporarily accounted to the memory allocation daemon, but I don't think th=
at this would be a problem.
> >
> > The main reasons we moved away from TJ's transfer-based approach
> > toward `charge_pid_fd` are: avoid the transient charge window on the
> > daemon's cgroup; and to decouple from Binder, allowing any allocator
> > to use it.
>
> Yeah those concerns are completely correct.
>
> The application should not volunteering says 'Charge that buffer to me.',=
 but rather that the daemon says force charge that buffer to this applicati=
on and tell me when the application is over its limit.
>
> >
> > Technically, both approaches could coexist, though. Of the three
> > scenarios TJ described:
> > - Scenario 2 is directly addressed by charge_pid_fd approach without
> > any transient charge on the daemon at the cost of one extra field in
> > the heap ioctl uAPI struct.
>
> Yeah extending the uAPI to pass in the pid on allocation time is not much=
 of a problem, but you also need to modify the whole stack above it and tha=
t is a bit more trickier.
>
> > - Scenario 3 can be handled by the charge transfer function without
> > changes to SurfaceFlinger. The app or dequeueBuffer claims the charge
> > for itself or the app, respectively (depending on whether we include a
> > pid_fd field in the transfer ioctl). It also covers non-heap
> > exporters. The con in both variants is the transient charge window on
> > the daemon.
>
> It should be trivial for the deamon to charge the buffer to an applicatio=
n before handing it out.

Yeah, true.

>
> > Both approaches shift the responsibility for correct charging
> > attribution to userspace: first, 'charge_pid_fd` on the allocator's
> > side, and the transfer charge on the consumer's side.
>
> Yeah that's why I said it would be better if we do that without any uAPI =
change, but with all the uAPI we have to transfer file descriptors (dup(), =
fork(), passing FDs over sockets etc...) it could be really tricky to imple=
ment that.
>
> > Deciding on one, the other or both depends on how much we value
> > avoiding transient attribution, and how much we need a non-heap
> > generic solution. With the XFER_CHARGE we can cover both. Thus, the
> > `charge_pid_fd` approach in this RFC can be seen as a
> > performance/strictness optimisation, eliminating transient charges to
> > the daemon at the cost of a permanent uAPI addition to the heap ioctl
> > struct, but not strictly required for correctness.
>
> Well all we need is a uAPI which says charge this buffer (file descriptor=
) to that cgroup (pidfd).

So you favor having only the XFER_CHARGE variant. That is fine with me.
If that is fine for others also that could be the way forward. If we
extend it to accept either a pidfd or a cgroup fd (as commented
previously), we can cover all dma-buf use cases with a single
primitive:
```
ioctl(buf_fd, DMA_BUF_IOCTL_XFER_CHARGE, charge_fd);
```
With the daemon invoking this ioctl before handing out the buf_fd.

This should cover most usecases? Except for the memfd case, which
requires a separate mechanism. That would be follow-up work.

>
> With this at hand we should be able to handle all use cases at the same t=
ime.
>
> > On the other hand,
> > if we agree on the end goal of migrating other exporters to use
> > dma-buf heaps
>
> That won't work. DMA-buf heaps is actually only a rather small and Anroid=
 specific use case.
>
> We have tons of other interfaces to allocate DMA-bufs which need to stay =
around because of HW restrictions and we do need a solution for them as wel=
l.
>
> Regards,
> Christian.
>
> >, and scenario 3 is addressed by adding the app's pid_fd
> > to SurfaceFlinger, then `charge_pid_fd` alone is a coherent/sufficient
> > approach despite the uAPI change.
> >
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> Thanks
> >>> Barry
> >>
> >
>


