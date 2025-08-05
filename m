Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5487C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49696B00B7; Tue,  5 Aug 2025 14:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21076B00B8; Tue,  5 Aug 2025 14:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36FB6B00B9; Tue,  5 Aug 2025 14:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEC6E6B00B7
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:20:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 426801401C3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:04 +0000 (UTC)
X-FDA: 83743517928.06.9D83790
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B25D4000F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VADu4qJg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418002; a=rsa-sha256;
	cv=none;
	b=oeQjU9g/StjhKwjYRsqnWVArGiJmWPsGIHESC11k4OQtCj6B1FWbpVZYYDiW4tipubAquH
	C83ooG3TxgM79jUVGn+/XCSp1IsqJ0Sw9V6gKBuBd4I8rWgoMEqN+2DtBcl4myprM8yWTV
	wF3W/djnsXAxxaLzxZ4E6GWiYncYoqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VADu4qJg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJOL+OvU/nrmYX0+Cdrz/7P1lhjrc0IsETGcPgFQaaY=;
	b=46WizKErPbm71YwnxD+/Ec1iZCGE4Rs474E8skZVt+/jClEJvUzn77h5Gzzrrm/3VghVuv
	YbUtun7NCPtlXgwFeuAspzTkhq6RPzmlTUDZ0NoECG6t8b/E4tIw5Fz5C2ukUzCjlANcUA
	jZxK7rDee3/rigrLMTRTyciGjAuQ9ZU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b062b6d51aso29395511cf.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 11:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754418001; x=1755022801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJOL+OvU/nrmYX0+Cdrz/7P1lhjrc0IsETGcPgFQaaY=;
        b=VADu4qJgnD1Tu21rLD4Y/PWjhLLgTyhS+oKqYIpF3rY2S8XOixYTjl6JvmAV/uUIdP
         DOFhgLDpMNBS294RsfES4eYRjGIj33hyBO3xPmR5TZad8mIOgegT22Hc09snL3i9CJDV
         nDXl2KHxg7hcuIzbbO9jgvCX57HCNkfbtFMtbDMxAZRJqJfQxWofAQJuUAZSEcA5tfxu
         yKhyAzQaD5LOO+DlyCgjaNOeA8R9imhompM8o6YMLCRRMPoyIfTTM/XeK5hSBgqHRKMh
         6cpZWroh1NQZ4LbItmTYpbjoFuFHBxtKtm8s+YYEA8iVmFLLqWBDuT0qBj2HX+RI0coR
         6DVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754418001; x=1755022801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJOL+OvU/nrmYX0+Cdrz/7P1lhjrc0IsETGcPgFQaaY=;
        b=Td4fVLgLoZQW9b8l11lRqbQkQR4KoXks/2qLNt99gQ+FhCZrIWJJJ9ZIOwOUlowlW+
         jNVJKf66P3pIzJVwmTauXcI1ZPoshazBaj1zOSGS/nRSlx3q5k6aoD6jbnLueXbPYfQe
         0lsU6uAhcXtOF8INoz5Ajgeno4CTp4XzuFHKhPccD/mfF4PgklKnfaDtaDRUKmoJedDJ
         VbjYZY6iAdB0/m6X5GeGyrmS1kAn+dYyiGok7KEp5w113PPxJ0vSNC6TncP5IjjYxLmp
         nyZvfkWnfnhO231Rxo9XMMyQgG2rZJU04dizJHnVUSJ72gx+gkzJ74LyZwMv4h4+At7n
         LHVg==
X-Forwarded-Encrypted: i=1; AJvYcCXH4yzCHI2pTh68I1PndVSxdRrnjFEjC96bdFfQ9jjvS7c+kGqzTwUgcqHxXFCtjpclORnbHVJWxA==@kvack.org
X-Gm-Message-State: AOJu0YykYV8ceMArLnkQ9AIskx8IkalRuQTXr9wiN70b92AZOthMSmDB
	ucoeaFlWX7JkYB/dpwpDar0fT/Ul1mI2dnQg08c1FNtcmBUdlMHkkI+X4NEFrJeGvJKHDpWrWli
	e0HiLnfAr700V9RBrIWY9nYT/hbQLoYsoxPNh0dcaSw==
X-Gm-Gg: ASbGncsElM9l53JbwUD+yZyjJ5a/uNlFp5TB6GVHQXu2zRrQ1stBfaNu03zlOJ5yBp+
	qqjfQ4IGmfySr5RI+QfbcNT9sIza30Hg/iIXdw3+Ps2RSCAk3cJft9LloBkiMXkwah6b/1H5tRS
	C7i0Xb8UuYJA2Ecus1E8GW5WwNDbk9kz675XEQH3w/AlGiqL3v+4vHwdxy58BMwIBwV4XbcS2kz
	Inx
X-Google-Smtp-Source: AGHT+IEw+lnJXb281yq+trj2cDJrjXcg+zACfYTXT195jbevAktpYuj5aCvlB20L+shR7ta89N5uGsQOoFo/By5YjC8=
X-Received: by 2002:a05:622a:5c94:b0:4b0:67b0:867 with SMTP id
 d75a77b69052e-4b067b02bd2mr149540751cf.27.1754418000991; Tue, 05 Aug 2025
 11:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-17-pasha.tatashin@soleen.com> <20250729163536.GN36037@nvidia.com>
In-Reply-To: <20250729163536.GN36037@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 5 Aug 2025 18:19:23 +0000
X-Gm-Features: Ac12FXz1LXAIJ7aYVxZ3KJkjC5AKnczPYVgMksSZ0RYc1suLLyDEIPbV7Oa9zmM
Message-ID: <CA+CK2bBOu9oRiO7gih7JpePXQjds2vN8uFXodgHU48fxpP_bVQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/32] liveupdate: luo_ioctl: add ioctl interface
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B25D4000F
X-Stat-Signature: 4zt539egywqu3ah41kp1tg15g96dc4nm
X-Rspam-User: 
X-HE-Tag: 1754418002-651520
X-HE-Meta: U2FsdGVkX1+ZLmsuX2wPTJL3NYFGj6Ad/EYilcTfRl4qdzEB+41dy93iIn6Z/RjiL0RDgdm3Pn2ixMoxGQ9/MJFeVVuupFUYFidhAPuRH+bzKDoKHGRXcvalbv08qjGV4fynBsfeyBfY5GYb0Qbc4PfaNHmSAvTTpZo1uTGJXF3nkMP36sMf3qi7j4cTdJTkY8mam0NT/ddat1/DfNyv3PJwFTdj1O+/ee3PeK3my1JkEtik3DfXKvOF8VZuCFDQsOFtmF93aobdU17plsN13FEanYyisEb1pD+L8gtTdmgCTNg0dXGg1YNnTI3nloIypHopZkVSweqc/5oH2HU5Zgw3b6V5p/ScPj6numVm4mY5bmgbpbCV1yANAFxWw9a0dgAJ0XpGHSyjLzjdZgPiyrA55b4LWpCaEjz1dHlIqKPrklo6OM2rgWrCscxWopnyp+X/0JzjsgSDt5qHo5F6DdOaHblsf2u3NyTl83yCoMrkwSnWU7dtD6mLi08BKF9F45260HBOlNVVl7jFMa7UU+bHvFotpxb0XcoIjJmTzl9p6g9njY1qsx6Dlp/mvjuaWDIMNEjX+H7N6USjNnO6UxO/kJKLj9V69skTISdzcQBy0YmsHvT+ZIQrYDy6cD5KEhbt+B5P/U16i4pn4nfYAGU87hjY3CcW1/u2CmtY2EYAyga8ucha/imocbBwDBaQynA75V+avUJfSB9skK+MOf5ZSwrACaTDPeW4RJIN9/SgKVfMICoBO3xoj9BpYC/r1yEHheQMg3leqKxDLuo/MakTp+RSLElvhbNQwpjPynPhidhUf/6F/kuwLNxEcnCmAKCd9y4ofi4nqaJdFsDsC9zHxYji2aNTw9YaZXoo1gQ6gTSI3tECEWDP1pvUJ1XSmdWS/fiAf9Q+elFGsLLHkkWhu/qmqFPOoogf9SBsmigjdt08udEh5HIsQO+V8z4sEj1KTAvBWadim6o7/y8
 TYE0Yf24
 i19O/BdVqehQL9vyJlM02L03LHjGYE4NjShIYVjO3JADL2k1USgThZ6sjxcoHBl5HAgML1Nf1CeUe5UQPCJ2OVaW48rrn6b3kwIwUlgbikUbzF+HGMFt6nRfvRFHSG6jQRNsD17/wpHYo6i04vxf/G/AsYQf92TdoGjAodBpXvAw+YWcUCX4pB40h9yc6vbR+8xSlBJPQAqLDDTbYnf1K4C94JL8xAXSuVpRJR0ljs2U53O3+WPyJaNftgtdYtFB+jIvEmFJcigWnDxVonPk3UxZtoKbELxgj1Gnr2o9VGsXt7/mgHiMK5Lg217VlwLep1ev/6dmlFQHpFajlp9C3Y/qgnaC4SWzzuxwQEXPyleYV1Ep0eIdAO37JGb/X7epVs2aD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 12:35=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Wed, Jul 23, 2025 at 02:46:29PM +0000, Pasha Tatashin wrote:
> > Introduce the user-space interface for the Live Update Orchestrator
> > via ioctl commands, enabling external control over the live update
> > process and management of preserved resources.
>
> I strongly recommend copying something like fwctl (which is copying
> iommufd, which is copying some other best practices). I will try to
> outline the main points below.
>
> The design of the fwctl scheme allows alot of options for ABI
> compatible future extensions and I very strongly recommend that
> complex ioctl style APIs be built with that in mind. I have so many
> scars from trying to undo fixed ABI design :)

Thank you for bringing this up, I have reviewed fwctl ioctl
implementation, and also iommufd ioctl, and I made the necessary
changes to make luo similar.

> > +/**
> > + * struct liveupdate_fd - Holds parameters for preserving and restorin=
g file
> > + * descriptors across live update.
> > + * @fd:    Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: The user-space fil=
e
> > + *         descriptor to be preserved.
> > + *         Output for %LIVEUPDATE_IOCTL_FD_RESTORE: The new file descr=
iptor
> > + *         representing the fully restored kernel resource.
> > + * @flags: Unused, reserved for future expansion, must be set to 0.
> > + * @token: Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: An opaque, unique =
token
> > + *         preserved for preserved resource.
> > + *         Input for %LIVEUPDATE_IOCTL_FD_RESTORE: The token previousl=
y
> > + *         provided to the preserve ioctl for the resource to be resto=
red.
> > + *
> > + * This structure is used as the argument for the %LIVEUPDATE_IOCTL_FD=
_PRESERVE
> > + * and %LIVEUPDATE_IOCTL_FD_RESTORE ioctls. These ioctls allow specifi=
c types
> > + * of file descriptors (for example memfd, kvm, iommufd, and VFIO) to =
have their
> > + * underlying kernel state preserved across a live update cycle.
> > + *
> > + * To preserve an FD, user space passes this struct to
> > + * %LIVEUPDATE_IOCTL_FD_PRESERVE with the @fd field set. On success, t=
he
> > + * kernel uses the @token field to uniquly associate the preserved FD.
> > + *
> > + * After the live update transition, user space passes the struct popu=
lated with
> > + * the *same* @token to %LIVEUPDATE_IOCTL_FD_RESTORE. The kernel uses =
the @token
> > + * to find the preserved state and, on success, populates the @fd fiel=
d with a
> > + * new file descriptor referring to the restored resource.
> > + */
> > +struct liveupdate_fd {
> > +     int             fd;
>
> 'int' should not appear in uapi structs. Fds are __s32

done

>
> > +     __u32           flags;
> > +     __aligned_u64   token;
> > +};
> > +
> > +/* The ioctl type, documented in ioctl-number.rst */
> > +#define LIVEUPDATE_IOCTL_TYPE                0xBA
>
> I have found it very helpful to organize the ioctl numbering like this:
>
> #define IOMMUFD_TYPE (';')
>
> enum {
>         IOMMUFD_CMD_BASE =3D 0x80,
>         IOMMUFD_CMD_DESTROY =3D IOMMUFD_CMD_BASE,
>         IOMMUFD_CMD_IOAS_ALLOC =3D 0x81,
>         IOMMUFD_CMD_IOAS_ALLOW_IOVAS =3D 0x82,
> [..]
>
> #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
>
> The numbers should be tightly packed and non-overlapping. It becomes
> difficult to manage this if the numbers are sprinkled all over the
> file. The above structuring will enforce git am conflicts if things
> get muddled up. Saved me a few times already in iommufd.

Done

>
> > +/**
> > + * LIVEUPDATE_IOCTL_FD_PRESERVE - Validate and initiate preservation f=
or a file
> > + * descriptor.
> > + *
> > + * Argument: Pointer to &struct liveupdate_fd.
> > + *
> > + * User sets the @fd field identifying the file descriptor to preserve
> > + * (e.g., memfd, kvm, iommufd, VFIO). The kernel validates if this FD =
type
> > + * and its dependencies are supported for preservation. If validation =
passes,
> > + * the kernel marks the FD internally and *initiates the process* of p=
reparing
> > + * its state for saving. The actual snapshotting of the state typicall=
y occurs
> > + * during the subsequent %LIVEUPDATE_IOCTL_PREPARE execution phase, th=
ough
> > + * some finalization might occur during freeze.
> > + * On successful validation and initiation, the kernel uses the @token
> > + * field with an opaque identifier representing the resource being pre=
served.
> > + * This token confirms the FD is targeted for preservation and is requ=
ired for
> > + * the subsequent %LIVEUPDATE_IOCTL_FD_RESTORE call after the live upd=
ate.
> > + *
> > + * Return: 0 on success (validation passed, preservation initiated), n=
egative
> > + * error code on failure (e.g., unsupported FD type, dependency issue,
> > + * validation failed).
> > + */
> > +#define LIVEUPDATE_IOCTL_FD_PRESERVE                                 \
> > +     _IOW(LIVEUPDATE_IOCTL_TYPE, 0x00, struct liveupdate_fd)
>
> From a kdoc perspective I find it works much better to attach the kdoc
> to the struct, not the ioctl:
>
> /**
>  * struct iommu_destroy - ioctl(IOMMU_DESTROY)
>  * @size: sizeof(struct iommu_destroy)
>  * @id: iommufd object ID to destroy. Can be any destroyable object type.
>  *
>  * Destroy any object held within iommufd.
>  */
> struct iommu_destroy {
>         __u32 size;
>         __u32 id;
> };
> #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
>
> Generates this kdoc:
>
> https://docs.kernel.org/userspace-api/iommufd.html#c.iommu_destroy

Agreed, done the same as above.

>
> You should also make sure to link the uapi header into the kdoc build
> under the "userspace API" chaper.
>
> The structs should also be self-describing. I am fairly strongly
> against using the size mechanism in the _IOW macro, it is instantly
> ABI incompatible and basically impossible to deal with from userspace.
>
> Hence why the IOMMFD version is _IO().

Right, I came to the same conclusion while reviewing fwctl, I replaced
everything with pure _IO().

>
> This means stick a size member in the first 4 bytes of every
> struct. More on this later..
>
> > +/**
> > + * LIVEUPDATE_IOCTL_FD_UNPRESERVE - Remove a file descriptor from the
> > + * preservation list.
> > + *
> > + * Argument: Pointer to __u64 token.
>
> Every ioctl should have a struct, with the size header. If you want to
> do more down the road you can not using this structure.

Done

>
> > +#define LIVEUPDATE_IOCTL_FD_RESTORE                                  \
> > +     _IOWR(LIVEUPDATE_IOCTL_TYPE, 0x02, struct liveupdate_fd)
>
> Strongly recommend that every ioctl have a unique struct. Sharing
> structs makes future extend-ability harder.

Done

>
> > +/**
> > + * LIVEUPDATE_IOCTL_PREPARE - Initiate preparation phase and trigger s=
tate
> > + * saving.
>
> Perhaps these just want to be a single 'set state' ioctl with an enum
> input argument?

Added a IOCTL: LIVEUPDATE_SET_EVENT, and all events
PREPARE/FINISH/CANCEL are now done through it.

>
> > @@ -7,4 +7,5 @@ obj-$(CONFIG_KEXEC_HANDOVER)          +=3D kexec_handov=
er.o
> >  obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)   +=3D kexec_handover_debug.o
> >  obj-$(CONFIG_LIVEUPDATE)             +=3D luo_core.o
> >  obj-$(CONFIG_LIVEUPDATE)             +=3D luo_files.o
> > +obj-$(CONFIG_LIVEUPDATE)             +=3D luo_ioctl.o
> >  obj-$(CONFIG_LIVEUPDATE)             +=3D luo_subsystems.o
>
> I don't think luo is modular, but I think it is generally better to
> write the kbuilds as though it was anyhow if it has a lot of files:
>
> iommufd-y :=3D \
>         device.o \
>         eventq.o \
>         hw_pagetable.o \
>         io_pagetable.o \
>         ioas.o \
>         main.o \
>         pages.o \
>         vfio_compat.o \
>         viommu.o
> obj-$(CONFIG_IOMMUFD) +=3D iommufd.o

Done

>
> Basically don't repeat obj-$(CONFIG_LIVEUPDATE), every one of those
> lines creates a new module (if it was modular)
>
> > +static int luo_open(struct inode *inodep, struct file *filep)
> > +{
> > +     if (!capable(CAP_SYS_ADMIN))
> > +             return -EACCES;
>
> IMHO file system permissions should control permission to open. No
> capable check.

Removed

>
> > +     if (filep->f_flags & O_EXCL)
> > +             return -EINVAL;
>
> O_EXCL doesn't really do anything for cdev, I'd drop this.
>
> The open should have an atomic to check for single open though.

Removed, and added an enforcement for a single open.

>
> > +static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned l=
ong arg)
> > +{
> > +     void __user *argp =3D (void __user *)arg;
> > +     struct liveupdate_fd luo_fd;
> > +     enum liveupdate_state state;
> > +     int ret =3D 0;
> > +     u64 token;
> > +
> > +     if (_IOC_TYPE(cmd) !=3D LIVEUPDATE_IOCTL_TYPE)
> > +             return -ENOTTY;
>
> The generic parse/disptach from fwctl is a really good idea here, you
> can cut and paste it, change the names. It makes it really easy to manage=
 future extensibility:
>
> List the ops and their structs:
>
> static const struct fwctl_ioctl_op fwctl_ioctl_ops[] =3D {
>         IOCTL_OP(FWCTL_INFO, fwctl_cmd_info, struct fwctl_info, out_devic=
e_data),
>         IOCTL_OP(FWCTL_RPC, fwctl_cmd_rpc, struct fwctl_rpc, out),
> };
>
> Index the list and copy_from_user the struct desribing the opt:
>
> static long fwctl_fops_ioctl(struct file *filp, unsigned int cmd,
>                                unsigned long arg)
> {
>         struct fwctl_uctx *uctx =3D filp->private_data;
>         const struct fwctl_ioctl_op *op;
>         struct fwctl_ucmd ucmd =3D {};
>         union fwctl_ucmd_buffer buf;
>         unsigned int nr;
>         int ret;
>
>         nr =3D _IOC_NR(cmd);
>         if ((nr - FWCTL_CMD_BASE) >=3D ARRAY_SIZE(fwctl_ioctl_ops))
>                 return -ENOIOCTLCMD;
>
>         op =3D &fwctl_ioctl_ops[nr - FWCTL_CMD_BASE];
>         if (op->ioctl_num !=3D cmd)
>                 return -ENOIOCTLCMD;
>
>         ucmd.uctx =3D uctx;
>         ucmd.cmd =3D &buf;
>         ucmd.ubuffer =3D (void __user *)arg;
>         // This is reading/checking the standard 4 byte size header:
>         ret =3D get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
>         if (ret)
>                 return ret;
>
>         if (ucmd.user_size < op->min_size)
>                 return -EINVAL;
>
>         ret =3D copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
>                                     ucmd.user_size);
>
>
> Removes a bunch of boiler plate and easy to make wrong copy_from_users
> in the ioctls. Centralizes size validation, zero padding checking/etc.

Yeap, implemented as  above.

>
> > +             ret =3D luo_register_file(luo_fd.token, luo_fd.fd);
> > +             if (!ret && copy_to_user(argp, &luo_fd, sizeof(luo_fd))) =
{
> > +                     WARN_ON_ONCE(luo_unregister_file(luo_fd.token));
> > +                     ret =3D -EFAULT;
>
> Then for extensibility you'd copy back the struct:
>
> static int ucmd_respond(struct fwctl_ucmd *ucmd, size_t cmd_len)
> {
>         if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
>                          min_t(size_t, ucmd->user_size, cmd_len)))
>                 return -EFAULT;
>         return 0;
> }
>
> Which truncates it/etc according to some ABI extensibility rules.
>
> > +static int __init liveupdate_init(void)
> > +{
> > +     int err;
> > +
> > +     if (!liveupdate_enabled())
> > +             return 0;
> > +
> > +     err =3D misc_register(&liveupdate_miscdev);
> > +     if (err < 0) {
> > +             pr_err("Failed to register misc device '%s': %d\n",
> > +                    liveupdate_miscdev.name, err);
>
> Should remove most of the pr_err's, here too IMHO..

Removed.

>
> Jason

Thanks a lot for the thorough review!

Pasha

