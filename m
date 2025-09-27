Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C90CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 20:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98F78E0006; Sat, 27 Sep 2025 16:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70458E0001; Sat, 27 Sep 2025 16:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACF68E0006; Sat, 27 Sep 2025 16:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A65B68E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 16:43:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7149643B3F
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:43:38 +0000 (UTC)
X-FDA: 83936206116.26.F5AB55D
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CFF0C0004
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cV9AXyMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759005816; a=rsa-sha256;
	cv=none;
	b=UkmPkvZxU9KE4zwhJbS7KZO4gf3EoqpwwHptOmKA2h3biN/cWzRqQR0/qA71g7UeCqB9kT
	qfi2NBr9FQUBJUE0up0WVVnby+MlDuzasyD0MNO8xHpruiA5ZtgrPhN8AKLUCSvjc4z0SP
	HbzMmw8PYHIHFrDHNxKcP1hJ6w4RamM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cV9AXyMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759005816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvNClLKNNn9rK6Vik019kICWDMo2uNNhdQgjV8A+LJY=;
	b=AN4Db24MKdwQMLycXfa78ZWo73QIIVtgP91AsiE8Dxi1XotWN+s4dmQpJlKjatBkp/Gg/S
	zX8cJVuQkIH2Ri4ULGZq0B6A6D5v0cHzMFKIPOVVBPf4AT5WnOz8CTf3i1Nkofq3bSCrRt
	d2KRshT/Yd/X3lkkiDSt98+CClPgLbc=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-55716f2d3b9so2704340137.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759005815; x=1759610615; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvNClLKNNn9rK6Vik019kICWDMo2uNNhdQgjV8A+LJY=;
        b=cV9AXyMDUW6cSnOAllknrsXcrmKFbxTyrfuKjmyRmNmdQkkmURWkJwtjVQm4uiygVq
         5Itks2ZU1wbdP4zgWjgYd2rnvH+/QfvOtMqYGApgrLDFUt9lV8+U1XRrvSiqqAovgETX
         5F/AvggoTxDHk4pOjFUlC4+iL7qHNmZ6euw8IA1DxUr7mTN4ETnrI+vNILnVmnSyYK1+
         wseetdduuXKpCaxU6wlm0bu1H00KahpXkfe8NsJ1SmMxDBg2hXbdkHz0k8ccMl08dUdx
         Uq6l80wujjIDNC5NNFGS826E11lD+2vGh+M2cnC8nlCiK/EH50YM/elJkZ0Habiy2ZA7
         tXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759005815; x=1759610615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvNClLKNNn9rK6Vik019kICWDMo2uNNhdQgjV8A+LJY=;
        b=kumYYZ9b7vf7wU7uqj+cKtwFXO3LUrzy87IY9YpPhQaNZvZIEwRu5KAKRF84+KjLRf
         oEd3Wb6CezuF8IZM58kgvSdnnD7LGQS/cYLUqvb0amlDGy3OIZ+iwTPFOJSbAA9L8XUO
         bCADMMrRKG76gWzlBOyQIJNM9QPTTvnSeOijjYbgMIZfVvWcp2iC+i1bF4xY6aEd1oEN
         lXFQOPq3rRsjnY8nPCt2NvV95fuSUg6I7rXnSWUAnOBmeaU6FlEfOqGYMQKu5rQDNCG1
         2+hLE7wLBmOipY3gZm9832J0xpcWx6XubSDWPoVq19S3clhBQ9VDHk4eTKGGi0zTsaM2
         ai4A==
X-Forwarded-Encrypted: i=1; AJvYcCUJQCQTeJwMxs+DCaqseXZF2s3He6DZP9BtQsqhnVsCV1f6T7Rf2iVwikaJhkMvo2q90tC9Juf8iw==@kvack.org
X-Gm-Message-State: AOJu0YzA1HVdYz1dufObSwH/yIxkoJAIpuoJo623SP0a9hjjjcYHBAX/
	XhqCMdm1ntD0Y3taPS2nxev+Qz5Vj0pJCEAICNvMzILM3Is1BtJuep9P1IE/hdGwO/8cIDDrWA5
	tS7yZ9Fjj4SBgvSlRkj9UamMUR6R9kNM=
X-Gm-Gg: ASbGncs9jJ5iA7YZevxkMHZhNkBl3RjDorjGdpIACNeMT0+GsewKHn50Q6kLkDsXRJs
	Ko3Ngl7wo+N7LumgZU0LX4wRbkH8+F2HyjB/qUJIHcKnnWeSaGYw1e3guC1ZLVb0+Dzv3Qjfyay
	i13sYCuD7m+ckKa5osnid/CCdOh3ATHfJOlBdfzEdn3fYtCJnZrJJs8+Li3ijQ6lIsvDRJjG9AC
	tdU3+cBPeZpcvOHpw+6q77abJNExxmii34YpTXv
X-Google-Smtp-Source: AGHT+IGYQ8cZXq6p06Ik0TDBdufn7B3v54OBWxKvQ9AFYTgNeyye8BPJ3qw2CKkk7AUAcaDd0Kb3KEG7ImktB5zLhBw=
X-Received: by 2002:a05:6102:2924:b0:52d:1b06:5e34 with SMTP id
 ada2fe7eead31-5b2826795b7mr3196814137.10.1759005815440; Sat, 27 Sep 2025
 13:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org> <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
 <aNZh3uDdORZ5mfSD@kernel.org>
In-Reply-To: <aNZh3uDdORZ5mfSD@kernel.org>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 27 Sep 2025 13:43:23 -0700
X-Gm-Features: AS18NWBZ4NYpS8oIgxtkL6K4jFZHcC-C1DNvJN4aikZTVbjqp7kQjMuXYe8nY8M
Message-ID: <CAM_iQpWXFQwtayT7Zv7iJd7zQZ=rX_P1ZK2P11-6ohRhLpg7Xw@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CFF0C0004
X-Stat-Signature: s6juxqwsj456woqaqazhhmt7bd8r5fbr
X-Rspam-User: 
X-HE-Tag: 1759005816-670407
X-HE-Meta: U2FsdGVkX19D7ZByfN+VLolximwrMBtjB4S4DXStDrGWB32ZGJ2++G77DtF/x8ptjaHHSMkPbqMy8N1zC6FnOckD37eb8W2AoaPpyVvCeLFBYgWMxHo8GMB6x9nXq+GC+qFdtyUGPnxDRGo2j00I2YVZZqG4lxupXMG9HGUC7tWTTGoWpbqneTPmfPi5F7jgPPqbxG1hN0p6L77WU/TOzvhbqAbk36zg1xIOzm2sLZFis/LzBmIbPrk7dq/S5/XpcbE220tQ2iTgJxzfLZkS50FP0uLnjft8RoLPzmmwqQ9EDDv30rlfagA4kXOGdcPRmwoWVoNLMASI2+45eI9H19YGV1VlRgCVS7i/vozKM4IcF/HKHNn00ZDwZYMUao+TZ8ffLWWItBgfv5tzIypy6/n4dqHmlPCn/2wpTO9s8o1hu4xSE2jTqT2ZVfgjm5Vt/TKcZgFC7btL7BvyBrRUMs0nKm37QOiuHjVVV34sK9uWrJzp2Ij2A1fecVWmjUzz0w700eCl/zRJ+Gb9mrtunG4JUC+NJkmsponeK6a3G2udH6LuwX8RA7PtTlPLa+qdUE22bWswUXFYW70ab3jrXskHpuQvAbbnExcI76aI12CUSgw0XOc9uJZKdhpkjtFWe+g/HVsCTATX+M+oH5F2PjDKBugGe3jTL6kZ7aKm9vw+7GBbA1FvPoLeaPU/YkLwBoavkH0j74sb9buZGzQgBp523j1o/8KoMxx3KFT1fDz7Q9mkyXk8Dlwv1xxVuAs0RF3v+a56V9x/wFtxHzTh6en0EmQ8qkGIE9vs8caX4Fa1vM8jMlFE3WF5zEyjI2kuGRM8VWroyG3duETaqeqyf43DZPa3zKDVIeEKfK+HudIdE9VoWW5f4LOlCdVzzHzIFaofVYUZgw8LQ9socJAgsUAokI6sj8dbY2RTZL8+IdSyQnvmF5gPD/Ed+o/h7aI92VegSCIxSXVB2u/9FuT
 GqKM6vNK
 HCblV53n7Lth8UoQhK7uwbNHn+7XDJPxqu3145t2E2RqUBbkc2SahVcwaiP6bYmGHTsEydvCnWMzMIqA52EnpEuoG+PZbRd7+Cwgpdj04byhI5PVuNLAMM3g37yH3II/K3fnJeFeBZOVk1P/AIAH+dJkbBF3j5I7lmhAXRP0Nr2LFFkXSJX0fR4OqPBk814w0vzf/RKYtdP/OAN4XupymltpkzpMXUW8Y9+ZztnSVyqQ7AYSuCoBA4BFfXmzDlHzNc6qds4OMMBeEhiqzhGulPGk1AoksdbETP7h8hq70Jb6vbBz8PXPrqEQ7KuJ+UBRbLJDGJvqoxcp6fdo+Rb9YlObRdrH5guAFxjZb7h3Wl6OnS9eXB/F4zb7xsNNl7OxdMlqElMSeGSOV6wgf8Q+UhsdFP8LJivzwWHoURbpfP3oMk9RPyRddYPBhs10T8LhrasIE5jMHTQU/5CABcgccbiMT0dP3GzYT43rb+od7nIyKktFv7hyLnRZ/6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 2:50=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Wed, Sep 24, 2025 at 11:39:44AM -0700, Cong Wang wrote:
> > On Wed, Sep 24, 2025 at 10:51=E2=80=AFAM Christoph Lameter (Ampere)
> > <cl@gentwo.org> wrote:
> > > AFAICT various contemporary Android deployments do the multiple kerne=
l
> > > approach in one way or another already for security purposes and for
> > > specialized controllers. However, the multi kernel approaches are oft=
en
> > > depending on specialized and dedicated hardware. It may be difficult =
to
> > > support with a generic approach developed here.
> >
> > You are right, the multikernel concept is indeed pretty old, the Barrel=
Fish
> > OS was invented in around 2009. Jailhouse was released 12 years ago.
> > There are tons of papers in this area too.
>
> Jailhouse is quite nice actually. Perhaps you should pick that up
> instead, and start refining and improving it? I'd be interested to test
> refined jailhouse patches. It's also easy build test images having the
> feature both with BuildRoot and Yocto.

Static partitioning is not a bad choice, except it is less flexible. We can=
't
get dynamic resource allocation with just static partitioning, but we can
easily get static partitioning with dynamic allocation, in fact, it should =
be
the default case.

In my own opinion, the reason why containers today are more popular
than VM's is not just performance, it is elasticity too. Static partitionin=
g
is essentially against elasticity.

More fundamentally, it is based on VMCS, which essentially requires
a hypervisor:
https://github.com/siemens/jailhouse/blob/master/hypervisor/control.c

>
> It would take me like half'ish day to create build target for it.
>
> > Dual-kernel systems, whether using virtualization or firmware, are inde=
ed
> > common at least for automotives today. This is a solid justification of=
 its
> > usefulness and real-world practice.
>
> OK so neither virtualization nor firmware are well defined here.
> Firmware e.g. can mean anything fro pre-bootloader to full operating
> system depending on context or who you ask.
>
> It's also pretty hard to project why VMs are bad for cars, and
> despite lacking experience with building operating systems for
> cars, I'd like to believe that the hardware enforcement that VT-x
> and VT-d type of technologies bring is actually great for cars.
>
> It's like every other infosec con where someone is hacking a car,
> and I seen even people who've participated to hackatons by car
> manufacturers. That industry is improving gradually and the
> challenge would be to create hard evidence that this brings
> better isolation than VM based solutions..

In case it is still not clear: No one wants to stop you from using a
VM. In fact, at least in theory, you could use a VM inside a multikernel.
Just like today we can still run a container in a VM (Kata Container).

Your choice is always on the table.

I hope this helps.

Regards,
Cong Wang

