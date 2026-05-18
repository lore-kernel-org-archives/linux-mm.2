Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A48CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EA36B0005; Mon, 18 May 2026 19:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B654E6B0088; Mon, 18 May 2026 19:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BD96B008C; Mon, 18 May 2026 19:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 977B76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:39:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29D7C1A0A79
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:18 +0000 (UTC)
X-FDA: 84782159196.14.3E3E858
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 233CB1A0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5dQlnYD;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mcq8G65erSH6P+qgAE9z4eUjbK8B0zwTDtFgfrR4hAQ=;
	b=7f3C1P9FzOB6k6Ohwcu2By4oZP2ab1lnRdANn6AzgSgBzgUBctgYz9TL9sAGSizSWepNf8
	zOAOrtNbUZx4swC90kqGLGC0A01eVUBTdW2+uL0g7HbmSOegrjieEgbr2pcO9fqfz1jgOZ
	HPP0KWR0lSR16VxEBWyquJAHZTXOEmk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147556; a=rsa-sha256;
	cv=pass;
	b=DtmmJZrp0SscAlzK11WfE+z5uT+Wr+bF4GuV73QUKagWc5nST728D18R4nk9xdGrV7jaVS
	mpfw3HlT6qDbrzqT6S+95w8iAxBXQypvTHoVg3CAmULgHriWN53bJeLnJI49t/nh6hN8L7
	iXdaJaStvaqYE0LHjo1J4UFJ+Qln1Gs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5dQlnYD;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so615e9.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147555; cv=none;
        d=google.com; s=arc-20240605;
        b=LImlkHJmze0lql6FuYEY7+9jZ2SPvML8ZU2L09FzsudV6RGxjs2bjo6DXLPWOAoqxi
         3Ceah1EbJEotqmEtrteg+uIlfc/YocXDWm+DdsaBDAPsvMiNnFS/U9+PLdBMsV69aSiL
         pzE+qjmP3yNsq/CqzvJ2UwK4jT+1ncADZ0xWMFaoVBNNjbjNa0g7T8NnLRmP7VkL0cb+
         ixZNidZiIWoCaClEcm+VGI6jOYlYCPMfQMwczqwVbdYohmlL1n6FbT9KD8W4Ic6EWbd7
         rel8vl5ip2MM0Gr8N6iJE0BkgsWkT+WN3FQYGI6L/jiQ/mWonUbr8uI7AA1nLRilg0I6
         roog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mcq8G65erSH6P+qgAE9z4eUjbK8B0zwTDtFgfrR4hAQ=;
        fh=nJ6TXYfA8XRwpwn47aNHR7sjFL9k7gTNw+aS37Y9Uw0=;
        b=fUXos0LaZ61zCPyBPYtli4oZYAc6ezGV88WyAh7LbtXmdrB+gO4bnNJ0WBLb5f+8PS
         XMxmHAqNuF9JI7pKMC+i5I6vIQ1iUJR8pS0XUMNK+VvQkBmJNJgrsQVMudwjdVItqkfh
         phed5ESP18sy8nt7vK/6m6F3raz6THmsq3EZ6cFlZM8fbPndt/i9FDRLPIUJfSkN5ng/
         IPQb1i3pId2lbOmrKTWK4nguggprMTfUn5InsKPTurEFZ7vcSDVWPDmVWImfm7hkJI1M
         MmV5GqJxXv18JD4eA+LgfGqZAxbtJeXPA8QPaLqdfY5RXRLWgBwe6BQ/EaFnI8tAzaZX
         /ONg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147555; x=1779752355; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mcq8G65erSH6P+qgAE9z4eUjbK8B0zwTDtFgfrR4hAQ=;
        b=L5dQlnYDlItv04dxrG4r4DPj+E0eS6vogdwvbrgUFbvMki8/XhPnaHekAqd2npiV2W
         7jPdcHfPBkePCDd+NczEmz2DbA8L/IdEKjpdIpe7twY+m1trOtt/sUJPd1qQB+kSn6Bf
         VUgxq3XYwwmCvn0iaz8jt6cRIWAypy+znVvmWsaSuqEblUp38JETgdMKPs35tli0zMuf
         ehbFeCGqbqWIUDzwkm/IFJw+Mj3uiJnjBre06CzpUbIgCXG5m/2OSpvmIjjXCA9bSP5I
         NXXOOurGPeJ1WGjncU/ygNaZESUOYfMY7ANYHJTaAJnIvwUfQ6plFcstlVJ/5u8dX7y7
         m+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147555; x=1779752355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mcq8G65erSH6P+qgAE9z4eUjbK8B0zwTDtFgfrR4hAQ=;
        b=H3zWo+NO5z/W5qgz2wuV63vXi0aqekmgdXryME4mBWmWxb6zTrTV2/x1YE6e7uQeH6
         /xxZotWF+hSz88RWhlsBbP/7KPSQFd8GmK3ZKeBQVxXuY0dKimfrO9d/+CZx2/YoKv2k
         o8sIPmQ1KSqN2JeTUuOZf7Yk1VjBV5knWbL7mSlyCrt58vuli4tjeJ4ycuDBNeK6d6gv
         ARphEY6PMMgvd6uFNLCgveAbFunnPTUk06MBq/Z7lKWF62Co8SpF33Lx2O5IIDG7q7eq
         ZKECqOcZhdOqEkjMVrdHUBiwg7EEtwBi2DVU66VvsfHIl70BwMKS6Kno9h0EY6WN78Vg
         Npgw==
X-Forwarded-Encrypted: i=1; AFNElJ97M/0vJnYtqNdANGSkJEOGRj39FZw9Y0yf73EUBtfNr5+7vDrNBrm8KD+H9ZW56kzFz8tbB/IZEg==@kvack.org
X-Gm-Message-State: AOJu0YwdxLt2hA5nAeUkDDllQcfOXXaImfyVjPHAapXmEV5DLxDXbQve
	Miy5TaCZFbf+EhBPdbA8cXOAXJ0v884cVWagaxfRiR/tfbQh3mc5w/Cdz3C4ddBRhebThMKNZAA
	jkBeloFSiSHPekwoRwzp+456oA9g/LO6aokeO4b90
X-Gm-Gg: Acq92OGiRK1/C0zKeoR3GlnqIGxNdsZAFUa2X1FpCoM0PpqJ+mOlpHew+j7a5t5M7lu
	OJA8sW5xQeLykzeC4PnPcDkQXG5FL35ywuWHsOQ9bb8VcGT3rPTGou7VKF/dMgbAWCItvoaSl11
	2drY9HL+xzwfRdgPYY3oEsi1bwN9LnJP/wf/uczz5ZYRL/8vDjTTRTQlpx8hJiUkyJItIHGeTj2
	VXOT0Qgmc2v6tf8c3Sz546ssmLFsdrdeQFatkeibI7637TTD2pkHpry+zmUvSmA45K2g7ePGJZr
	P7WRsHoSYafvutx38W3FePtoHh6ZZwv3nzfZiMd20psI4BJ0
X-Received: by 2002:a05:600c:83c4:b0:48a:56fa:36dd with SMTP id
 5b1f17b1804b1-48ffd85790amr3271995e9.11.1779147554173; Mon, 18 May 2026
 16:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <20260515-hinschauen-effizient-9e3a05a94f2e@brauner> <CABdmKX0d6Zsg+_TxXjB80UZR23ZvXzxYoWzORgwmx=ZiuE+Nzw@mail.gmail.com>
 <208fb820-d8eb-4832-a343-ef8b360e8120@amd.com> <CADSE00Lh95ygoXGKJGsYvQGEsFV8sVmwEC3uvh8M6r3ERzaJwg@mail.gmail.com>
 <88efe10a-8b93-4a81-8279-4a5559d0f17c@amd.com>
In-Reply-To: <88efe10a-8b93-4a81-8279-4a5559d0f17c@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 16:39:02 -0700
X-Gm-Features: AVHnY4K5WzHxjnmBKK1J4Ij9G3s1JmujGOC18rtfp3AXYH6mFeA4fkV1W-efX6I
Message-ID: <CABdmKX3yZubjDKbVqwrjHAiKyj_ioHzOoxd0wzFbJK=PAGOqcQ@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 233CB1A0002
X-Stat-Signature: et6xrzn8i6dskjx1gdqjg6t1gpj1sqfo
X-Rspam-User: 
X-HE-Tag: 1779147555-436060
X-HE-Meta: U2FsdGVkX18lPLqNXMDQ/qXSk9b2ORiOYzbkubFyI/Zrc1sjRoGUve/MTkZkbpGryR3XT/XizEU5Nsl5haqqGtouiJ4JlLgAh8gQcr9DkpoNNQUH8g1Vhw/JYcqVxQGLG1vthOgRdnOJNzOJZQG9taVGXzRLsgTjIk9PftyeLrtaNtgu9lVDyExJdkNpss0okr+dZEauuglv5TkcEFAy3SQiAdspeepYOCYbW3iof3hjRypVpnuj/onrm+/ZHodogK+lFAlkdCzt16ThjRVA61s9HldvuqNwvxKSkhWvIDwIlGlVNgVaMxy31c0gy+2gO06/BPlIOoiKI5AajPduD//dZx45wxRY9qB9+kexnkcnaovYE0oY0+Ef7FhR8T9i7FwrKXAVFWR3VZK5QQrxUgeSRUbkVQ565KMEXRhmMVTVTtdMLAYYlzzW2++IQJLuID5xEL+caVdf+vCmkgQU8gOG6SC78/Bvf/3hrsn4aZEWqajoIUfTOSTD0IVKb9EcMlD4HMa305bFhm7rg3GShr4AgHjCqZoEP+nYiEk7pykSUWm4KjA41mQeQT83o1iZ3Gzyr8bmHa0RUGx2wClfMjaULxPgxlHFq1DPi7hPYtzETOtO24l6iAIJpJVDtle2qvvZoVf/nXNL92gvhmel8XN3y7UCon1M8XXQMxiTqP+DahL4O8ymx3x/cqFOXWP6Eoovs++9Dbmt+/wJaeRnFzRIcwpAvHBQjTTRsUHE2kYvH3WkORj3sqTu145iugmSPm7jDQLVdf5bfXWoHVQvitj+Nio7bh9agymbK0qv1hBQLANKSreLDJ39PbvX74uP9meMTaH1gJRiXtjd0l5Ghx1B6A+TCyYj6qNjYkKEKknSUammuKUMPv1Gk5kBTXYLHxORId93UdjghQT+zao+Z7Ncr3V3/zcChs/IJGy2k1u43j9FtcItbPkh5qdESPgj5AKPb6BUCS7OImwQcL+
 oYL6MXUy
 KDcSbki2pbV9fISIV8UU8ttbcyWnNgmHN3abVEPILVw8NZoMsQNJiN6oH+fhGG9msilBPS2fS/4PjSlE861sjCKL/g/YFCr8dOK3i/8ijXrg/yYAZ6GS2rFrHSsXggaPSnCcrHc4YPAMCCt2pN9VqbKYMqMQKTha0234tIkoPEbsjrASRxW8Imi0PgQJGdj/V7UbuWwnW+XCvup8FE8wu6HRxuK+x7XQNv5S7NGuLpsRSV6Q0QM2kK9hEElmZVwxQDI2xJTUAoHaelhGaQBaKDcPAjzgXuN/zw0ERVsaaCvHUyoep02uEYGNw6KOanHdlrkp37MeYptq8I/NBQKhFawBpcOo1kiayIAjFmmJkxhZqI9QjD074uUC5Ou0vQMILWf+hCs1yxRvpH0NjLi7X1LVhb6/o0YeyGZS1kOEW2iTZXkaJPbYo4RSSdcCkNeOErW8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 7:07=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/18/26 14:50, Albert Esteve wrote:
> > On Mon, May 18, 2026 at 9:20=E2=80=AFAM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> >>
> >> On 5/15/26 19:06, T.J. Mercier wrote:
> >>> On Fri, May 15, 2026 at 6:53=E2=80=AFAM Christian Brauner <brauner@ke=
rnel.org> wrote:
> >>>>
> >>>> On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
> >>>>> On embedded platforms a central process often allocates dma-buf
> >>>>> memory on behalf of client applications. Without a way to
> >>>>> attribute the charge to the requesting client's cgroup, the
> >>>>> cost lands on the allocator, making per-cgroup memory limits
> >>>>> ineffective for the actual consumers.
> >>>>>
> >>>>> Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> >>>>
> >>>> Please be aware that pidfds come in two flavors:
> >>>>
> >>>> thread-group pidfds and thread-specific pidfds. Make sure that your =
API
> >>>> doesn't implicitly depend on this distinction not existing.
> >>>
> >>> Hi Christian,
> >>>
> >>> Memcg is not a controller that supports "thread mode" so all threads
> >>> in a group should belong to the same memcg.
> >>
> >> BTW: Exactly that is the requirement automotive has with their native =
context use case.
> >>
> >> The use case is that you have a deamon which has multiple threads were=
 each one is acting on behalve of some other process.
> >>
> >> At the moment we basically say they are simply not using cgroups for t=
hat use case, but it would be really nice if we could handle that as well.
> >>
> >> Summarizing the requirement of that use case: You need a different cgr=
oup for each thread of a process.
> >
> > Hi Christian,
> >
> > Thanks for sharing this atuomotive usecase. If I understand correctly,
> > the actual requirement is attributing dma-buf charges to the right
> > client, not putting each daemon thread in a different cgroup?
>
> Nope, exactly that's the difference.
>
> The thread acts as a filtering agent for both memory allocation and comma=
nd submission for somebody else, the process on which behalve the daemon do=
es things can even be in a client VM, completely remote over some network o=
r even something like a microcontroller.
>
> Everything the thread does regarding CPU time, GPU driver memory allocati=
on as well as resources like GPU processing and I/O time etc.. needs to be =
accounted to one client which can be different for each thread of the proce=
ss.
>
> The only thing which is shared with the main process thread is CPU memory=
 resources, e.g. malloc() because that is basically just needed for houseke=
eping and pretty much irrelevant for this kind of use case.
>
> The problem is now you can't do that with cgroups at the moment but unfor=
tunately only the kernel has the information you need to know to do this.
>
> So what you end up with is to define tons of interfaces just to get the n=
ecessary information from the kernel into userspace and then essentially du=
plicate the same infrastructure cgroup provides in the kernel in userspace =
again.
>
> > If so,
> > the `charge_pid_fd` approach achieves this directly by passing the
> > client's `pid_fd`, without needing to add per-thread cgroup
> > infrastructure.
>
> Well it's already a massive improvemt, we could basically stop doing the =
whole duplication part for the GPU driver stack and just use cgroups for th=
is part.
>
> Doing that automatically for CPU and I/O time would just be nice to have =
additionally.
>
> Regards,
> Christian.

Hopefully I'm following correctly here.... So you are duplicating the
GPU driver stack to achieve remote accounting on a per-thread basis?
Does this mean for GPU allocations you currently have some GFP_ACCOUNT
magic in your driver to attribute GPU memory to the correct remote
client? So this series would close the gap for dma-buf allocations,
but what about private GPU driver memory allocated on behalf of a
client?

