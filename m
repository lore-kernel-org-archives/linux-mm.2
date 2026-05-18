Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993B9CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917DB6B0005; Mon, 18 May 2026 18:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9366B0088; Mon, 18 May 2026 18:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B79B6B008C; Mon, 18 May 2026 18:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64BC96B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:19:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0A6440AD2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:19:19 +0000 (UTC)
X-FDA: 84781957638.18.31FE1AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B914C4000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:19:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2DT7leN;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779142757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwPwsIbtmpQIwK98XGhoY5fkgFLxHo2PkgkWS665XEM=;
	b=YhuUZAZJLka9+d2GMZMzgYtu3YIx9PLNYlDjFv4tJW/r6mYP3DoHo8kVlVi5YdZMhqGFgt
	SOdtHM2lqCRdc69uMNdRmJmkdCshDK2yZs0yQF6z9w4sRzmhczW5q7wD5DT+0J+1U52v8f
	aPvZqBEkeVOHNikUUHiCCLMJQwrnHIU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2DT7leN;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779142757; a=rsa-sha256;
	cv=none;
	b=LjgKqtQtkzuS/M7X7/mHUR5GCpJhHXHG0tdLn0VGaFzmtpXq7JqqOvIzeywsdoN5DS9x41
	F7mU13n74XEVo4/s3dBY2glt/y6rQh/6t4RvymIsI2+hmMNH+0twCRJNSU+EHtrb9CPsAj
	SpYP/S/JDVHNla/+oIK3oJt0uT9SqRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76EF9445B7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D28BC2BCC9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779142756;
	bh=QwPwsIbtmpQIwK98XGhoY5fkgFLxHo2PkgkWS665XEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I2DT7leNuntNS4Fb0mktVNPyw8Rbhs+gVWTrg1CstO4ifg9+fbn19Tgwwb5RQu6SJ
	 oVl76IdmVMFtIEEqI2x/Xk3A/Wht7NKh8NtrVe0yXfXVmjnNq8YVf80fCSmSQB/9Sl
	 z6dIrXGO3QMeh0NMXNp52X2Z9+LN7pXlOPxNah+bZ6rTc1cHUpk0as9s2igql3GoOc
	 Nn3oJzn+lUOR2SS9p5bZeS83tU/OhQ+WnZftbPwcS04E1pQZCCdT8Su+w/1iajXGdX
	 Bukvz/pnRIlUSoqf23mMiKaFEZErMrH8ypf7E0ZiSE4XanK5S8CzjuMpKgvtHduVrO
	 pN/VlZ1JtpNSg==
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-636970cf66cso2135835137.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 15:19:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9DoVhVjFW67/hM/0tU5d778dnoL9pPEz8Mjy+nROcvQV6bCeAWxbxRHF1MlMnnaJsYWRcht9veHQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1yBmQ8IVaXAvp6ajJp5XieLovvT3s5RaU8RYWmySWt+NyLTaR
	qQJg9iO8r9tXNW5qdEVHR/bGOKoIFMB+6L1cZgZt4HPU1I2aK7Unc3N0scJEBQJFToJlaGXfVRS
	MaF7DeTqPZTU/zF2p0hJPtY6uw2FTkWQ=
X-Received: by 2002:a05:6102:6:b0:65a:fec7:137b with SMTP id
 ada2fe7eead31-65afec72d9emr1102084137.0.1779142755093; Mon, 18 May 2026
 15:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
 <CABdmKX0gqg309hcXcOHSj_yTg0h1zwDL34GDk8mX3wp4YoyfDg@mail.gmail.com> <CABdmKX3wwgovwS-V8rVC3=+EZcTvPs_cttpQb1w6WemwLAVhsw@mail.gmail.com>
In-Reply-To: <CABdmKX3wwgovwS-V8rVC3=+EZcTvPs_cttpQb1w6WemwLAVhsw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 19 May 2026 06:19:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y=Gsv=FSUjJ5+99Gg6ULUnv0LRexCGOGetzChR3YA44Q@mail.gmail.com>
X-Gm-Features: AVHnY4I1qEOEZQdYFnOfKNfIzm2SBPuZfZoateaLto4Ne3PZjITQyUeamdYuj98
Message-ID: <CAGsJ_4y=Gsv=FSUjJ5+99Gg6ULUnv0LRexCGOGetzChR3YA44Q@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: "T.J. Mercier" <tjmercier@google.com>
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
X-Stat-Signature: 75cgnn4q94szzq3iyiep7ybsa84hpkw1
X-Rspamd-Queue-Id: B914C4000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779142757-58045
X-HE-Meta: U2FsdGVkX193efbgBTMyGRZDyy0lsKDocWSNz6wgagBBepGLoW9jJ/WKwtQ8HWrzW6loF3Y/Xj93pLX4fm8tVxNpXHJgveb8Y9q3tqIpRvrlJW53p5Zq29kfVnx7G5ZnnDspB7OiWSvpyHgyM7V6g5OXPftFoKfDys5+/m6wnYjuKWaMVcjn7gX7KiKrsUw5OarTV5VZcUImZLiOpRtYnCKklhJuothF5RaOCvIhzrbHLK63g8HArYHpfOqWAHkRc4Z3QSgD1pms23UJS68BzVIaxk1sbNcT5NyNUA/Q6HfvaOZkfTKlY3ZF4tUU0YNrgOa7bc6iBdmA6HtU8PKRzjLDv6z7O9XiBLmtZYChFnuJvnOMMkUHNh6FCgZyTTli4xcqLie+uqqH8+2XYWj4ESt+c04LaexSbn+r8O+tHx5dW8pKe6UivZwqsJrFG/2cMiW9uZhme0MwSEH6RwmqRmHzJ87u/z6Kjgf2h8XJGoCrEounHtPkEr3MeFp0hwf8qJMKVez+vDE/jmnKWOJ+qALVS39SeTJFs9wkda6igbb/a+gVsN3FB9bt1RWqDxFakbpun4jHG0Zx3cbp1ywkRiYOxNYUJj7Q/D938mxJMKS+/w7JnPE0ptov4tL4EeokWFmhzzAk7rbhAejKUrgbnadFejlwSCnCdSXH167At5VGnd65+L/XuVgrCp1y5rsYJDubcA+y7QtRWhCZIfIcGLtcX4R1Q5lCO+ngLdcMDVKq9PuRyQ3OE5rDrUIcCO2wNklxm/a/xrr2CpaakPrKVq+5qfkiP1I8BTv0+swUr+T05Wtvq2759qXVFri+G9y9lG5indvPV7mhtjqATQDGYyHkNjLYq/wZckh9JzBmvg4h3nEht9A7Ud/+WCvZxascjnxLOCtk7FniyXO7jEMeJGBq2VxWBPvZHV4J3WPaX3WWQTjS5ZXUU2cIRjtVNkGy8LLA2rizbpt1nwitAKa
 I7bxYzi0
 qn9jMJRDzd0xuCOwyp20XxAIeRftDT6c6/QTs21qkm5B2dC75D5MGTLaq7WSX9RARTzj1zpVKJRe6un09z9avFD4WYHDdshK5ucTv81fRex1il8fzBeONBxGxd2iF5vwMX+KspLibFDMVONhQyF2qnGLYDAKCOX4AgHk5uF1wzXGjVOepPeajwRezJJqd1uq5CexzXZX6PrLQk1TH3KgXelsxvu2O6al3x8tAjqiASdvFuoVKhayZ3186ahxrZ8rOyCKQRdRU+3+tgQTttTgQn3Ew/MvozG9z5gRbFj4JoX8n8e8kQcpTpkDwvPSX8wPlivoVhLQgGBptVvLX7yLcUvRH1BUxqxr19xDo8DlN8hVo0FQ09+e34i9EfMCLq5lQyJMBd6NhmGMTMSWH97GgLro1Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 5:17=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
[...]
> > > > Yeah I think this might work. I know of 3 cases, and it trivially
> > > > solves the first two. The third requires some work on our end to
> > > > extend our userspace interfaces to include the pidfd but it seems
> > > > doable. I'm checking with our graphics folks.
> > > >
> > > > 1) Direct allocation from user (e.g. app -> allocation ioctl on
> > > > /dev/dma_heap/foo)
> > > > No changes required to userspace. mem_accounting=3D1 charges the ap=
p.
> > > >
> > > > 2) Single hop remote allocation (e.g. app -> AHardwareBuffer_alloca=
te
> > > > -> gralloc)
> > > > gralloc has the caller's pid as described in the commit message. Op=
en
> > > > a pidfd and pass it in the dma_heap_allocation_data.
> > > >
> > > > 3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
> > > > SurfaceFlinger -> gralloc)
> > > > In this case gralloc knows SurfaceFlinger's pid, but not the app's.=
 So
> > > > we need to add the app's pidfd to the SurfaceFlinger -> gralloc
> > > > interface, or transfer the memcg charge from SurfaceFlinger to the =
app
> > > > after the allocation.
> > > > It'd be nice to avoid the charge transfer option entirely, but if w=
e
> > > > need it that doesn't seem so bad in this case because it's a bulk
> > > > charge for the entire dmabuf rather than per-page. So the exporter
> > > > doesn't need to get involved (we wouldn't need a new dma_buf_op) an=
d
> > > > we wouldn't have to worry about looping and locking for each page.
> > > >
> > >
> > > Hi T.J.,
> > >
> > > Your description of the three different cases sounds very interesting=
.
> > > It helps me understand how difficult it can be to correctly charge
> > > dma-buf in the current user scenarios.
> > >
> > > I=E2=80=99m wondering where I can find Android userspace code that tr=
ansfers
> > > the PID of RPC callers. Do we have any existing sample code in Androi=
d
> > > for this?
> >
> > Hi Barry,
> >
> > In Java android.os.Binder.getCallingPid() will provide it. Here
>
> ... let me try again
>
> Here are some examples from the framework code:
>
> https://cs.android.com/search?q=3DgetCallingPid%20f:ActivityManager&sq=3D=
&ss=3Dandroid%2Fplatform%2Fsuperproject
>
> In native code we have AIBinder_getCallingPid and
> android::IPCThreadState::self()->getCallingPid() (or
> android::hardware::IPCThreadState::self()->getCallingPid() for HIDL)
>
> https://cs.android.com/search?q=3DgetCallingPid%20l:cpp%20-f:prebuilt&ss=
=3Dandroid%2Fplatform%2Fsuperproject

Thanks very much, T.J. That is very helpful. I guess
that would require user space to understand the RPC
procedure, including single-hop and two-hop cases, and
make the corresponding changes.

You pointed out the SurfaceFlinger cases, which are
two hops. It seems that AI models are also using
dma_heap, at least from what I have observed on MTK
and Qualcomm phones. Likely, we need to understand
those RPC relationships in userspace and make the
corresponding changes.
I assume AI models are a single-hop case?

Best Regards
Barry

