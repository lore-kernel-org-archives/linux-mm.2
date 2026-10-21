Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D158D606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=TPAQ1qQ1
Received: by kanga.kvack.org (Postfix)
	id E45F36B074D; Wed, 21 Oct 2026 13:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF69D6B074E; Wed, 21 Oct 2026 13:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5536B074F; Wed, 21 Oct 2026 13:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A819C6B074D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:18:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40F05160600
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:18:00 +0000 (UTC)
X-FDA: 85347291120.16.AC6D6A4
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4484E2000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:17:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TPAQ1qQ1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792603078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
	b=ZN9OxuF4SMwJK4h316YubrXx8CEcT2+oxlSKqxvMzTyteccFpXVEPEVCiPUEcATHAl2qFI
	yJl2XbdVZgpuu9oCBEJtlKmZCoW8dGwtGic75q/QuTVUPommkjT+9o8aN0k0rAl79SG138
	9WlAmaw0WRCX4sea9TJTE2pheLGEPf0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TPAQ1qQ1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792603078;
	b=hcsevp+rhK2M1OUkulyxKYJD1iqIwZpJh1Sjhd6SsOaJYjT1UjcuaHH4DfR3rGb7adF8tm
	M+HlQ7fvHJdBciCu1OQeQlXP1Gmh9z8k64dpSncqZsNpEF28DvVk29EvrN0YclzSvRNuqR
	rYbjiOmeFxJkwdCNQ9VGuH9k8y2YUJ0=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4322d310e7so134156166b.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792603077; cv=none;
        d=google.com; s=arc-20260327;
        b=QtR23ZalRZNLg2zYDSMTLJE48NRXFb0YuNu+dNkRoh7FIOs/JRqj9/x5ZzEWfPASaI
         fdCmDbWiem1yEOXQajoCdkymv4jcGVkUUU3mGVJbsecsob/TVf2wTubmhuaKzpFeAAbR
         rXX4vSQd8bTZNjhLZ/fKmklbvNfgHekczR3nBghFDrr0gFzkzIfR7gxoRFTvzpYZMZqZ
         FqVYOEFW4pyIjD1PXWVg1ch0KdRwsUOtmzfEdHatS5FuteGFFk4aLEOwtNuKBS9z/JEQ
         DXg8hKz1m3Qn00VdNpewCCh4DPQEmalW281LTUGETcgCOa9QZFC755t2YsqQmuuRH+Cp
         5Bkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        fh=kIqcHLmKh45V9SUVxmRtAnox3Hz7e7O6tL5q+DWAUEs=;
        b=eMw4d89Y28VLX/gVrw5jp+S+7jeRHMazFnBB1j45xM/Z3Bj3gQcI7MEMp+adEp5ZyC
         O6os3QepFgY+KA7cnF2YtYQxwSSAynY12nrCsKGJWIy39873CTqXOSMSSj0o633liHBP
         8+t+0Wx8m0pFgnhN1ppybx2GzFSck4Lk15DseJU/z2hGmXzMgpqifblDHcHKfi0QBnzz
         1ZiL1AdV0G/VpVsLazRGfk9R2vhgqHAPRU0NnQLuCdR1zaqSy2YrLREqByPMrZmjGZCi
         3BQBxP+Ke9KjP7VXuBQMsBHo3xdv54DwfmDpTlJH7fpo5nu1qMCdIs1T0R01d1ebRXuo
         CoIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792603077; x=1793207877; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        b=TPAQ1qQ1Az4crx98zTgdaD6w86IfihSXxL7i0hcZKcTLuSmb+QLmLa42X9qWbeIeDr
         Pwy3XUOL+6uOQ6e7d7su/hNfCyxaajwkOgzInXC2Zc+0Fn6FzNX2tz6toS8504XgwK5w
         zpk4q8tbQwZxZkRtk2eNNspzCQdofRdnz6J22iTrBJORN8vfYZ/c/W9Cqly0Dj50nNww
         Bfh7gZ2c3/cY//3s9Z7xYCxxNOJ8ZRbADDGdYhlqZobOHOtq5iQsAEnvck3DQ4iR4vRs
         lVcDEp55jLKN2T1xJv1wcs4Boar44wnZP1P9pXo6OGbmLVVFZyIGwbx8ME6JF0gThtYy
         3mgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792603077; x=1793207877;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=elbAOUhGKDzUinaTQ0302ZCYZ7inGoSdWd2JTt/hv+g=;
        b=kWb+ItUzUS2n6wnAmvJJrkJn6Xy8Tz7eC6qg+zReqqnaSnBbgAIb+CjoapImTaHtWo
         IuYZEB7JYnSuR+bMWxkgmGaI+lN/7JVwSz1qqU9mP+TZ4D41TqjXXpBh6FU+k8EuLQnZ
         mpOXjhtWe4XRN9WORVsfbD1+/RlKrCfeb8ekqEIBA+WAbANk/Ugdj+vrtMLtOpldrHbI
         aQ2Augw1MDdMoEowT4vIWfy0IO6nN0TlqcTxV3LKUo8IHW5qGnPcN/q7AL8XGmVn9Y0X
         TW0tpVwIxtryaBjtQWdbFrb99i2+EkAt6aZE4+RXrMNmSzPemlxcmzUvT9F4+misK2Jt
         enzw==
X-Forwarded-Encrypted: i=1; AKwUvBzo9S23bRJZoKOFkmSthiaqmdGvdWCUHX/S9mYkKZhBeHcUzGZ/LwM9kjaCeSyfEIDukeiNtxtwuw==@kvack.org
X-Gm-Message-State: AFq9FYIiQh0ZAZnRNSYwaNxwl8qh7ClYHFRg50/oSszT4o8CnuO1R6/x
	Yohl6iz/A2CKsZnfvF4rA4+iXOSGMuJX3aqFrqnWAKwKXWcJJWVHICIeQWvNLvs6K0H4tvclnqW
	sbQ/dyD+vtpWZCRjvJT/l3x96a21CCdVC+0i19w9BhA==
X-Gm-Gg: AYBFou2yK0peuK7i9w4RKiusYKB7SHIM/w/64/o05DxOAk2uRj+6BEmYVHdY0VTmuFu
	Be3qSH+UBGKMNc44VwUICtvr5+gi9Ylyl6XRfLJLVIPHOVcnqIT1vg084kRSSmO9qAAC30W/2SC
	RTa82A4ZK2NOLFTkwfDkGpMibHBM17f6VP+SWfoPg87WGG099+OuajnaEkIUZePa3REdlvmj04q
	kePv/sH7EZriQqh12pyeCiXoR2baWQzxrD044U2OeEFt30b0T1PSe28R9hTXkTE5nvOds2gzCdI
	nBmOEQ1qh+c/2pDiCLMmYlymsOYClHGrTQidw++feK/1OlJRi//Hp3f16jfN0Xtuakpf+kWL0yG
	yvQ84B9IqUy+iUGhZ93vi51j/ndEjSmbRNxAYmBvWs0UlMX17IJuf9iOx+DTrXW8PckA=
X-Received: by 2002:a17:906:f597:b0:c3e:f39b:2286 with SMTP id
 a640c23a62f3a-c4678f7c6cemr225893866b.0.1792603076743; Wed, 21 Oct 2026
 10:17:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-3-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:17:19 -0400
X-Gm-Features: AclHuK-IkiswuL9j-om2-Yvi6ZhWxvxntziJi6QKVuLB1ELR4YcI0vWO7hzjpeA
Message-ID: <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4484E2000C
X-Stat-Signature: f6uhc5mwrqzdzuwokd4ihzi9j6fg1jqw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792603078-771763
X-HE-Meta: U2FsdGVkX196ZB3xIvTHTJDj87hwd0GjNvrlqBaXXc/f/5PROVMqlmJIcdJTCilzZsQCgitCOZ1AZC4WZFspd1s6viDtNkhDjFGNG90knLhYijrov9D+jNKaM/yjyndmL2jGxIpIjGuSr4QYutZQRfvO92d1o0Hi+tXsHlgXYEtNLJX7sCj+M0pqbiLWWYMemZ97bAqLYnSbPbfQwOORmD3Hxo0JJ10AW1tgUxdobfBhNZk8+tclGuKg66KkU3qoIyrk8qdxcBo2fTn235GhNsF62OUufn6oRNsCr+WV2ejUjFoEFI0+RKv5pzjWAHjM0FOy6zHZnAkrMmu/yua9X+C1y8rcfpWVhLYLYU11pRJLm6uKmaNBCJuYRvu+OLfe8Bi23fMOeemY555tm+hZMTm1zcZ8AKmhtBbwOZdiRcujYsmVgT0I4q7iCZtVp8VZMaHYPux8HwmQefP4eRX30L44ELz15qo/2LlNEGtTSsmDTzsmVdyQMampniT+ryPOniAVe9fc3guLHbrWmC04P55V+zILTaSkScmBJ4YowJVB6vaJQ4/MfEmfdAnmsunjPmPnivqb5sNg91iW4iepc0fvKJS2z75FUSjLJa9uBpx0RUlnalkBj1qEASFuYajZ7D+nJNKYbE2UbWPuQIuo/NFaa3UMh2Xug2DfcZKJcRiE1m5IUFUfcJ3pi77SnKu/m9BM/c87fF8QL6LcOJP5g3g9HpcJ/YGu6liBOflkfH8Uxq8Cl0wyAgQNLmzZ9invky6Jax6sLNMWUXO9a93Vt8BwnBuV/kZv9p3yoyL7i+ow1uYa0VrhwcEewxKbLRaBY63OQsSi/Ng+JEg1XWG638V6cjYkwHjf+ixoQ1m89xeRrWQIRqpKp1MYez9SZkvRS9UA6HFqzjUHW3GuWxwU/8+ASm5+EDpup0SENNnSNkjjJ/23tg8bsv5eTZ4JU1Y50gUvrP2oVoqCGehMb6d
 jmkfMgVI
 AaXvEPEXxl33rwTOYLLc/o3FGJLz1crwlKxsGhodSt0YtqIyNZ87NHaqsFWkZLW9eiB+FItkCQGD8q5HtIHbzSjeFw0yhaSVxDN51wTW+Bji2RqJ7Pz9Yx9GXyHbcbQKlytgZCha6RsuWP+FFJjmxuYZGQpkqo46+sQ7Ky1hnudjQKDBsIGERcdvFpXQDnOwCz59ppC849Oh54BhEyiD1hVvTtb72FggPD2Ai+ykfZhlxhDzxuY/vu8X4JymE3Lp9DRvXMfSFiKajzdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.com> =
wrote:
>
> Currently luo_preserve_file() iterates over luo_file_handler_list and
> picks the first registered handler whose .can_preserve() callback
> returns true. When a subsystem introduces a new, backwards-incompatible
> file handler alongside an existing one for the same file type, userspace
> has no way to choose which handler preserves a file descriptor, nor can
> the kernel keep the existing rollback-safe handler as the default while
> allowing callers to opt into the new handler.

That is not how it will work. If we are in the .can_preserve() call,
it means the user has already decided which file handlers to use. We
need to do that before any preservation happens; otherwise, we could
run into conflicts on FLBs i.e. FH of different version require
different FLBs.

Therefore, there should be a luoctl call (i.e via a new ioctl to set
compatability) that provides the kernel with the specs file of the
target kernel we are updating to, allowing the kernel to select the
compatible file handlers. Since .can_preserve() is called when the
user is already preserving files, the specification must have already
been supplied, or the kernel should fall back to using the default
(i.e., latest) file handlers.

>
> Append char handler[LIVEUPDATE_HNDL_NAME_LENGTH] to struct
> liveupdate_session_preserve_fd immediately after token, keeping
> IOCTL_OP min_size at offsetofend(..., token) so callers passing the
> original 16-byte structure continue to work:
> - When handler is empty (all-zero, or zero-filled when userspace
>   passes the 16-byte structure), luo_preserve_file() selects the first
>   registered handler whose .can_preserve() callback accepts the fd.
> - When handler is non-empty, it must be null-terminated within
>   LIVEUPDATE_HNDL_NAME_LENGTH bytes (returning -EINVAL otherwise);
>   luo_preserve_file() looks up the registered handler with that exact
>   name (returning -ENOENT if unknown) and verifies that its
>   .can_preserve() callback accepts the fd (returning -EINVAL if not).
>
> The retrieve ioctl is unchanged because the handler is identified by the
> name stored in the serialized payload from the source kernel.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/uapi/linux/liveupdate.h  | 12 +++++++++---
>  kernel/liveupdate/luo_file.c     | 21 ++++++++++++++++++---
>  kernel/liveupdate/luo_internal.h |  3 ++-
>  kernel/liveupdate/luo_session.c  |  7 ++++++-
>  4 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupd=
ate.h
> index 509c6236720d..2413b19dabc1 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -126,9 +126,14 @@ struct liveupdate_ioctl_retrieve_session {
>
>  /**
>   * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRES=
ERVE_FD)
> - * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
> - * @fd:    Input; The user-space file descriptor to be preserved.
> - * @token: Input; An opaque, unique token for preserved resource.
> + * @size:    Input; sizeof(struct liveupdate_session_preserve_fd)
> + * @fd:      Input; The user-space file descriptor to be preserved.
> + * @token:   Input; An opaque, unique token for preserved resource.
> + * @handler: Input; Optional null-terminated file handler name (max leng=
th
> + *           %LIVEUPDATE_HNDL_NAME_LENGTH including null terminator) sel=
ecting
> + *           which registered handler preserves @fd. If empty (all-zero,=
 or
> + *           omitted when passing the 16-byte structure), the kernel sel=
ects
> + *           the first registered handler whose .can_preserve() accepts =
@fd.
>   *
>   * Holds parameters for preserving a file descriptor.
>   *
> @@ -152,6 +157,7 @@ struct liveupdate_session_preserve_fd {
>         __u32           size;
>         __s32           fd;
>         __aligned_u64   token;
> +       char            handler[LIVEUPDATE_HNDL_NAME_LENGTH];
>  };
>
>  #define LIVEUPDATE_SESSION_PRESERVE_FD                                 \
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index fb81239bedf3..be20e0f1e0aa 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -207,6 +207,8 @@ static bool luo_token_is_used(struct luo_file_set *fi=
le_set, u64 token)
>   * @file_set: The file_set to which the preserved file will be added.
>   * @token:    A unique, user-provided identifier for the file.
>   * @fd:       The file descriptor to be preserved.
> + * @handler:  Optional NUL-terminated handler name. If NULL or empty, th=
e first
> + *            registered handler whose .can_preserve() accepts @fd is se=
lected.
>   *
>   * This function orchestrates the first phase of preserving a file. Upon=
 entry,
>   * it takes a reference to the 'struct file' via fget(), effectively mak=
ing LUO
> @@ -238,11 +240,13 @@ static bool luo_token_is_used(struct luo_file_set *=
file_set, u64 token)
>   *         -EBUSY if the file descriptor is already preserved by another=
 session.
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
> - *         -ENOENT if no compatible handler is found for the file type.
> + *         -ENOENT if no matching handler is registered or accepts @fd.
> + *         -EINVAL if the named handler cannot preserve @fd.
>   *         -ENOMEM on memory allocation failure.
>   *         Other erros might be returned by .preserve().
>   */
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +                     const char *handler)
>  {
>         struct liveupdate_file_op_args args =3D {0};
>         struct liveupdate_file_handler *fh;
> @@ -266,6 +270,18 @@ int luo_preserve_file(struct luo_file_set *file_set,=
 u64 token, int fd)
>         err =3D -ENOENT;
>         down_read(&luo_register_rwlock);
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> +               if (handler && handler[0]) {
> +                       if (strcmp(fh->name, handler))
> +                               continue;
> +                       if (!fh->ops->can_preserve(fh, file)) {
> +                               err =3D -EINVAL;
> +                               break;
> +                       }
> +                       if (try_module_get(fh->ops->owner))
> +                               err =3D 0;
> +                       break;
> +               }
> +
>                 if (fh->ops->can_preserve(fh, file)) {
>                         if (try_module_get(fh->ops->owner))
>                                 err =3D 0;
> @@ -274,7 +290,6 @@ int luo_preserve_file(struct luo_file_set *file_set, =
u64 token, int fd)
>         }
>         up_read(&luo_register_rwlock);
>
> -       /* err is still -ENOENT if no handler was found */
>         if (err)
>                 goto err_fput;
>
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_int=
ernal.h
> index dac6644bfb18..911ffedec9f3 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -101,7 +101,8 @@ int __init luo_session_setup_incoming(u64 sessions_pa=
);
>  int luo_session_serialize(void);
>  int luo_session_deserialize(void);
>
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +                     const char *handler);
>  void luo_file_unpreserve_files(struct luo_file_set *file_set);
>  int luo_file_freeze(struct luo_file_set *file_set,
>                     struct luo_file_set_ser *file_set_ser);
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index f48e9a4185f9..194ef45907c1 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -266,8 +266,13 @@ static int luo_session_preserve_fd(struct luo_sessio=
n *session,
>         struct liveupdate_session_preserve_fd *argp =3D ucmd->cmd;
>         int err;
>
> +       if (strnlen(argp->handler, sizeof(argp->handler)) =3D=3D
> +           sizeof(argp->handler))
> +               return -EINVAL;
> +
>         guard(mutex)(&session->mutex);
> -       err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd);
> +       err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd,
> +                               argp->handler);
>         if (err)
>                 return err;
>
> --
> 2.56.0.212.g129ede20d9-goog
>

