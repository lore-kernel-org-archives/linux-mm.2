Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E67D711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 03:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6596B008A; Thu, 18 Dec 2025 22:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD836B008C; Thu, 18 Dec 2025 22:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9326B0092; Thu, 18 Dec 2025 22:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A87196B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:12:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52DA61355CC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:12:17 +0000 (UTC)
X-FDA: 84234747114.02.6A946EB
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5AFAE80002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:12:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FZgbOJz0;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766113935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOpFX73lOcA2xaIOC+spZOCBK4vYcGfoiXQtRzVcKYU=;
	b=AgQP8t3o0vy3oMUhCdCcdIO3pCAaMk7xGP379clOluLDiBrbYUeOmvoBZj0i06UtQ19xzb
	OuQGPm7PYRuWJJ6DDXBzr88zzQwX21ikAc46vb4RNVPdm1g51Eo2OjY/QjjZq9jTezh0kq
	n/F7F8ukZSP7pbwZGsiekpCkHOUEu9E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FZgbOJz0;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766113935; a=rsa-sha256;
	cv=none;
	b=sHkC19dKRkak7VSjdGGP8lHITUQbMKYEdj6SfFO2EFAlcMi6Z4RDihMOfW80Y1aBLs/VEu
	kup6d1dwPMvAgZS5wxOQq3cqC+q3QK3XFkL5ay3RIX6/HuLa7GBDmta0D/08t9rw237MCZ
	P8J+FIPcIIr0PdRVpBgfk7onarGIIpE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6492e78ce07so1655272a12.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766113934; x=1766718734; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOpFX73lOcA2xaIOC+spZOCBK4vYcGfoiXQtRzVcKYU=;
        b=FZgbOJz0Wx8N2GN+npdXPlFhXD7Au+8UpNjD1R00wqz7YiGskeE7g0nCa6dFNRXU6j
         0LQXyO2A/hbP0/Nrk8NtQ4MSLPW4ZMk90KkwwVYJlkPcL9ODxDOx0yK77+GL9QQkNjaH
         9DaRlxSUqZ436sBonCJ3Tcndy3+TMIgtweb9L/rB1rOqFRkR+EFOYjVdqpf1U/RCHTio
         GFlzox04a/nVh/tYCisnhLlngbgnaIBqF1Vr62hUx41DTsID1MHg//qZ88PD2RqTSQTR
         hr3eViX91d5ZAFWdy3kzjzEt3fcd3TEuHUQSan8CitN5B9x/ROIrsh3qFOryZdoI6plJ
         IReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766113934; x=1766718734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hOpFX73lOcA2xaIOC+spZOCBK4vYcGfoiXQtRzVcKYU=;
        b=fFvhbm+jaJHK1ZtW5Px1gpKm87IPdSRQKTRIejxiOnJ1Q5pduhd1fVInn2BaxkVXo0
         Ytrc0XVEm2HvFAuQzLUi6GXtfI++0qcASQ7F2SJVB7SW4qAgijcyIg2p/DdHpH//aBXT
         4ttR2o/EuSj5H9JsGOhORSgylhexPlgxS56uyNuQbJt27ZCm757UnCGspWNmoeIuLPJE
         dsY9X0pMhYtxyZP9zO68bysVJzsHStGf//3Qy8q6z3Ismd+T0gwSKGtMXAW0Ifpp0xj6
         MuQJgNWTqxATHQlUGvXkhGVVARWGFViX3dJpGzvHvlVXxRljSp5T5Z+WWl657S7ACntb
         KoQA==
X-Forwarded-Encrypted: i=1; AJvYcCVhPCP67ms+k7HVH5q6553XQCWaosVJ6+vZ9JSb4QBDjEKxpTlw+a6vNGA9B8+uk+HXLmAhGB8iFA==@kvack.org
X-Gm-Message-State: AOJu0Yzd60f/zUMnMy657cPffjf1hbh8648kM+OpYfz5EM8LUqZ4jrmq
	mrdXwvBRm/LjE3dVQn+PqlHqrxzhSi43osz9Sn0O9XkPOhwyx2sdGnzLTuIR2+M6LcmjMBynbgL
	Q2smEwBHXXvBayISErrPQ57ih8mSDW9qkAPSbymohgA==
X-Gm-Gg: AY/fxX4/JvTLZGjTDb5QnrB/fZccQta+oQbjJ0UQYqNLeM5Twpl4VI2av1Qu7yILut7
	1WZYiAufYBIQjjtitcoclsQ+AtDpiwBdG0K3xwF6dHM+y8xHJC5RQrMmw9RyOmtjdOjNCpu24iC
	Z9cCih7ksDo4jLUKL5UwWQ3Rc2br70PiBUbgc5hATeUE5szAwEf7Aroh8C5z3g1fl9JMqHvEcYv
	2If2JcxWanXArdLxW66ouiiBA+YCHjuThrLckzDZKyyGYNLoFGgZHcc/dVBUagB7yV6lrVisLuU
	9uie1JrpmNOgA2m1Fo8IjAuW
X-Google-Smtp-Source: AGHT+IFyooNIycCBqCq+5Jx2fOAIn6oqy4Jno8KDmH6oL5s3lOpN0tocGVfnZ64XVTzHRE4tjkXy4qtN942OJlkN/zw=
X-Received: by 2002:a05:6402:2345:b0:64b:42e8:4e38 with SMTP id
 4fb4d7f45d1cf-64b8eeeafd7mr1422809a12.34.1766113933641; Thu, 18 Dec 2025
 19:12:13 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-12-pasha.tatashin@soleen.com> <20251218215613.GA17304@ranerica-svr.sc.intel.com>
 <CA+CK2bDucySNG7QqE87bZndgjKH-QCw61romZVExD63S2iM6og@mail.gmail.com> <20251219024341.GC17600@ranerica-svr.sc.intel.com>
In-Reply-To: <20251219024341.GC17600@ranerica-svr.sc.intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 22:11:37 -0500
X-Gm-Features: AQt7F2omSeqxNLm45MnOPfOBzp5TCJGywWDkGT9aUu_9wUiHPCem8lSZwdriBwc
Message-ID: <CA+CK2bBg9xpkNyeWVR5+YQhpZYxSvWzB=nXV_d4D+DmzLdSB1A@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] kho: Allow kexec load before KHO finalization
To: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	ricardo.neri@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8wqi89pst3tungg3uqo8ufbg3r9j379p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5AFAE80002
X-HE-Tag: 1766113935-753680
X-HE-Meta: U2FsdGVkX1+lCN63nQV7GiVgmZq/5BybTNTh9dprdm6wmIWps6e8wjeurGbVkdcIEobMEanN1M/CUpd8Fm8N7XFB3B3APCEypkWHNwFQYJDNXLphQx05bY+lFqY/rkLnrtbpZS3ZAwxAscwfS3q2yXwL8CyMz6Tgzz9QXEfzbNcTsJPbPiErPpNVNsy6b6AiyfZp5Fne5GfNretkjaqkxOnxra6TZdEs2yKaFpOQ4gfwp2wmip/WKBL+rHrwL1NKcPm48l/DpS8dSTMuCWvzfwv/cQfB1U7oybjuykfByRbDrlFVayK/ZiDnBaWGnDslBRNMqzPdAnz6u+LvoH0YQtBqnbaRzVwJ05nTdog4l0/oNZDmbAwmSuD0ENrgHhSpwJ0E1FK9d+MAeRYmkhWpu1of4A4TeJVRck6QZlvrLrhulYL1k3nn48lJsplxYQPK413YdTEWolAkga9W+9vAmDOEyRoFpzM7mSBVSTZ3VO1vs4Ns1cTi6AyacqHoXeU9/t+fLbyLNnimrMDm3Gu4Y5yUc3V4b2He9jl/pWHw/Z6dTWBw/XIbP5L4gJkPx+vC3gUvbiOblkGCyU3d68y+h91Df/mEzSav3HRdmc8zNplsUVuq+WNJ85QXjNMQzdKpVFGLUOuy9h7JrqJ4M2VdOrgsi8zQXlhV1WTVQE1zBxKMYb4+SK8su017UiOr7P6wr9WHwj57VFAnR3N2pp8sOfxTyeIYDFKzFFLPtTH7fIfpaJEc/XDhI/LoKPBUij+KgM/vNWcudXIWTGJOoEaIW/inX+404e0oybMCiPqJJxZnUDW6Ey/TXvREmzd81FncF7lb5Sk7WVwzk/4PVEwQa/7GiatfyABPf7kqtoSW28srRVwa9Phv3NlVd3ecFL/91KxgbwlSWIy5xD886v06iUoqSlxuz1kj9n1HSCrKF3PnYCrS5hrdDj2wXoY/1VabMWkPqOVodpIDzsmd5lz
 OjziUUtz
 eC4xjF5obptaWM+9GUH/ui0NKRJY96nb7VKWOZdkmZAZdCgmiG2iynO32mebRPea1ybVyxawNKx3indBjWIRyPF3aQt8cN7n9tL8I5o4OiuWdOTPmGimeu4nDqurkQxsjppcxvFzW9osi768p2CmFL9d9iOjkGGMkHf81o05zeqqQMdDm1OuHve+G96Q+qcFZRR+1fx3cUoL03LUcgd4651PwvoFZ4yqoJoW1uS9H5TiHFf3nJIEdjj2M9B86N/r2m7t+PYMCwVsDXeG3OL605CnIOsfpAtZWVMFbR5H1Qb626dA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 9:37=E2=80=AFPM Ricardo Neri
<ricardo.neri-calderon@linux.intel.com> wrote:
>
> On Thu, Dec 18, 2025 at 07:26:19PM -0500, Pasha Tatashin wrote:
> > On Thu, Dec 18, 2025 at 4:49=E2=80=AFPM Ricardo Neri
> > <ricardo.neri-calderon@linux.intel.com> wrote:
> > >
> > > On Fri, Nov 14, 2025 at 02:00:00PM -0500, Pasha Tatashin wrote:
> > > > Currently, kho_fill_kimage() checks kho_out.finalized and returns
> > > > early if KHO is not yet finalized. This enforces a strict ordering =
where
> > > > userspace must finalize KHO *before* loading the kexec image.
> > > >
> > > > This is restrictive, as standard workflows often involve loading th=
e
> > > > target kernel early in the lifecycle and finalizing the state (FDT)
> > > > only immediately before the reboot.
> > > >
> > > > Since the KHO FDT resides at a physical address allocated during bo=
ot
> > > > (kho_init), its location is stable. We can attach this stable addre=
ss
> > > > to the kimage regardless of whether the content has been finalized =
yet.
> > > >
> > > > Relax the check to only require kho_enable, allowing kexec_file_loa=
d
> > > > to proceed at any time.
> > > >
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > > > ---
> > > >  kernel/liveupdate/kexec_handover.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate=
/kexec_handover.c
> > > > index 461d96084c12..4596e67de832 100644
> > > > --- a/kernel/liveupdate/kexec_handover.c
> > > > +++ b/kernel/liveupdate/kexec_handover.c
> > > > @@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image)
> > > >       int err =3D 0;
> > > >       struct kexec_buf scratch;
> > > >
> > > > -     if (!kho_out.finalized)
> > > > +     if (!kho_enable)
> > > >               return 0;
> > >
> > > Hi Pasha,
> > >
> > > Using v6.19-rc1 (which has this changeset) and with:
> > >
> > > CONFIG_KEXEC_HANDOVER=3Dy
> > > CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=3Dy
> > > CONFIG_LIVEUPDATE=3Dn (i.e., nobody calling kho_finalize())
> > > no reserve_mem=3D entries in the kernel command line
> > >
> > > I omit doing
> > >
> > > echo 1 > /sys/kernel/debug/kho/out/finalize
> > >
> > > before doing
> > >
> > > kexec -l <kernel> --initrd=3D<initrd> --commandline=3D"$(cat /proc/cm=
dline)"
> > > kexec -e
> >
> > Hi Ricardo,
> >
> > Thank you for reporting this bug. I created a fix here:
> > https://lore.kernel.org/lkml/20251219002355.3323896-1-pasha.tatashin@so=
leen.com
> >
> > Please let me know if it works.
>
> Thanks for the quick reply, Pasha. Your patch does work for me (I saw you
> will post a v2).

I have sent v2:
https://lore.kernel.org/lkml/20251219030854.3527871-1-pasha.tatashin@soleen=
.com

>
> From this patchset, I gather that kho_finalize() can be called multiple
> times and in-kernel users of KHO should call it when done preparing their
> subrees. Is that correct?

This is correct, we now allow it to finalize multiple times. In kernel
users can choose to do that during reboot, we also removed abort.

Pasha

