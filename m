Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B154E60A382E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Pg5TSOa+
Received: by kanga.kvack.org (Postfix)
	id BF5106B093D; Thu, 22 Oct 2026 09:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7EFF6B093E; Thu, 22 Oct 2026 09:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F3B6B093F; Thu, 22 Oct 2026 09:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5B96B093D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:43:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D8441407CC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:43:04 +0000 (UTC)
X-FDA: 85350378288.22.9834021
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 643462000F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:43:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Pg5TSOa+;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792676582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gizFMxgAiNeNcK9yHAVbAAuSg3KjclB/mQKEXDByXnY=;
	b=iimAY0RfkevVOktiWz3bTC9iKv4yWYLdhtHkBPltfJvBTpQ1vPsNPhvc+KpjQi87QcI4FZ
	42Ma3C6Z4UsStEyD5F6I9QNj2b2HRx0M70X1pTklnVVfD1ANur7l3FZrLldAD5i6aM+FXL
	xVdVtBAk3xruLC0irjq73ERTi9I4kkg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Pg5TSOa+;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792676582;
	b=h/BMqol2hYl9EzpA0ztyiA9qEhGrx+eAZfi2ZEmJkk6e/hoax8iDfHUaVT+nhzbG+iz82w
	071s2JzRVb0+kddd79dTXoCnpKIFOoGkTHKr/Ra5k5b5zekl2psMYs0atlmKXW7Dchzyyf
	C8cc1qHHhx6xzWlnudVz9ShN1L79pDs=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so2010361a12.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:43:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792676581; cv=none;
        d=google.com; s=arc-20260327;
        b=Nhp/H/LztV1QeeNi6k0T/TSA+Qe4cF24AEXkXqaRXfOTZuhjrUG6TpOCqv9gGpXj5y
         i71RAa6B5Ile/O7/KZXKI+QOgFTZDFqycV8My5wroUHZZK1zVAFDGYVTu4UR/+Q7G3nt
         oMAH/bigCBJpP2TRuMBzM6PGcuWV32abwcmdkMu00Kvs5jU6cJecw8YCH+2FdmL3ouAE
         lE9nnCY7frwmRBe127FDl8vaf9kDgl48bVKYPoso2/JkwjPKs4i0sVJc6kd54RQ3UHp7
         0VS+59QUMWCdrcLglKtYq1XtuIsLT5MAc0fOZYt5WLHacbewp7IvqiQrz/LMXpnERTuH
         VQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gizFMxgAiNeNcK9yHAVbAAuSg3KjclB/mQKEXDByXnY=;
        fh=JETJ5OV//K+63zxNNZBo6QmmqlnFLAXwrK1D/vx4t38=;
        b=fKbeN7FSz/6juiuB4J3OHyZzlOAmt6SCUIDneu7IiDzsfVWPs/eMwpjP0J5UkF4sGE
         NJdF99NmJGFDYBjRc9bRsneKL+xQ+IKKbxvDKcGBel1d5KlO/VcZb6cL1xymXU8Lct9k
         883NgEh9UiXQ10TiEU0CLbygK4Smvm391U7fpc2nfwkVDNVYN7wMrgAStLtelsUKGaWc
         3ruH78Vpb2aJitdhmXO2HA1RVHJaLs3YZjbCeUhp5HwLJ7RftOsXzypb97f7Og1ppYts
         EULEWzLc9G8qfB4Q/3ZXCnyrcfEgUoEqZ1aE4v7UTWtTzTrKxd1dnwrL2B7Q6OCF2WD7
         J7Gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792676581; x=1793281381; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gizFMxgAiNeNcK9yHAVbAAuSg3KjclB/mQKEXDByXnY=;
        b=Pg5TSOa+djuz16Aojvlq4GsyTyA/871KajmEqGFMyK9sc0xBgylinXTI7Yd6aj3+A5
         PGNWKj1B2DTbwrru1kr/UdQgu6zU7ryGpghG/GieKyE7BRrOoSVyXgaN7ZqSQdN3VrRO
         5pS3neoRTzsaMkP0iDvxt56mJBKTT+NCQw3npvcKRaZDaUKu5JdMyGj/NqCxjbPHootd
         qjkV5YTRv9sSZXqV22kvJN4FXYYW+GpszC6fQho/gflA/f18siDbBiH1zzNWIk4hyWRU
         /CpK3P1+dYWCkQaZoxaHlK82AZilpgujKqjECmWbbnfmTQDbE/whj/6/RaT38ugfVwmG
         DI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792676581; x=1793281381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gizFMxgAiNeNcK9yHAVbAAuSg3KjclB/mQKEXDByXnY=;
        b=NdQLZ6gNAuI6LDFcf3jS4oLfALkjq1cm+YLH6ZHcxNWNREZ9fFc9zV8nSRq4lyll5R
         b8GkfXmH4P/QPPRPT9WsdYXjCzkCg2S3aQPnRNH49DLmgVVogdgLyrMr03M/RcxM/2vx
         8GgfpdItLvaKNnFKOmQXf5NHE1sixLqxaCD/DDW1fAyjctjHTMvtks64gV98T2iIgZ4n
         n7Hi2SUxMlwtA1aHTTFUVtn9K92wq7BCNeuAEjRWvwbOQaBg3oEG2MxYUbwRyCFtUy0+
         5YwxEM9IXqfQ4OsqBnw3UiKQrukF28myzWI1tnHQILvHXIHy9TByDUPGxrOFhKr0vyIX
         xkdw==
X-Forwarded-Encrypted: i=1; AKwUvBx4jEF4798pbc/AQMv3OZZNVXQeOf2BwPbMRRhWX/OvCVQHithHQdVYJTEJQuixQlLeMgoo5Ukxvw==@kvack.org
X-Gm-Message-State: AFq9FYI1CTKEBrFZA6sts8mlxzIwb8wCOr4ETglbESqy1Qrz9WZBA+83
	8KuLbAIfhupodVN+jgViaIeeEo2InHlLSJg3PnYVeoY3g7Dv01jQrKkyXSJKtmQOhiTOQ+3a3Sx
	HwpFZgE7q5kcG7Hlneo4mfIPtZW4lPqgkUVVn8FCWJA==
X-Gm-Gg: AYBFou2wYCtJqO25ZJqeo2FMGzd1VWvE8A5JIDd5TtY2bICSmxufpWpoqeWwcJH04rP
	seGTnsxXpkVgYGD5O+rSpjTeOUqiImyE7h7prU2yqlZJdkXGMu/MnNFNEWMl6uNxe0zKWT5Bmwy
	UOeqZ/oJ+s0+TyvqDxcKT170PnS66McoHcekpQHfg/1FCO01MF16uDlPg1gwd1NPIMZmOeCU8se
	Qof8+Fq66bnM8iXAiGxgNYuVn6dwhqPpE07RN0HAhDB3FPg36vV3ozEcxpxyw6J/KhxIgj0i9bC
	2qJbzbvKIP8QN9wxsIbqe49WJbrb7PLC6PBwGdFfxaaBnSFrVDG2ucGoZH5s9AKfmtWT+A6eWPs
	a75Yy5l99uJVvYhpI7OPmaHbjYRvblh5wOXV5v3v3WNcH7uGZr7dfaipdSpxCqTJeOOw4
X-Received: by 2002:a05:6402:51cb:b0:6b1:ba86:5f55 with SMTP id
 4fb4d7f45d1cf-6b408eda746mr4955017a12.35.1792676580475; Thu, 22 Oct 2026
 06:43:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com> <9huzik2t5281.fsf@tarunix.c.googlers.com>
In-Reply-To: <9huzik2t5281.fsf@tarunix.c.googlers.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Oct 2026 09:42:22 -0400
X-Gm-Features: AclHuK8k5bT2ZKs2HYGA795ETIkO2JydSGkbGrRRu0cT3FC7RgYcT81JMzNVsA4
Message-ID: <CA+CK2bA2zqQJryBqpoNG7RQqnUnQT1+d8G5xwrjx0Dqo58woHA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
To: tarunsahu@google.com
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 643462000F
X-Stat-Signature: 1auebme3x4jh5cr54nsw1ey3wo7eqrxc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792676582-635620
X-HE-Meta: U2FsdGVkX187QlfSIOmMquHjbKT+zZxv1svYO6xuadaR56Yi31HL32XN33aqVT5xb1JkVsgfMGb6Zxqyfnb6aWJ/KNBrFY7Bly5N78VxdI5r0CgbXu6u+kUrH3CEJFsbdkGb6Xp+GfxsWS12B0m90BFCRCdR8U9/SDQ1o0Vgk2ZHGh/ZE+xmQJ5NNnd0VSWMOuOnrl49c1CYBnqN/2kd+Nb8hCkv1gDOg7aVo+WF+hPINFj8E6STfHUaqLXNDtOB1JcdQgLGJLpU7GKwc06YvCAisv5Dof9u8wKxnBxs1SG8Ihj7mLhZeUTlKgYeLglDyIIVQeO6g+HpdOsbeLhmG02o2pQY5TVigXNhkvkoOHtkx7fCMEDS0SzGiHy3orMY/e8uTwawZ9riEkVjsrR/V4ax/zmNYXJK0ZD7TOBrxUSbEEaiqq+2HcyPcjvSmx/aVjDlTAkEksIsBOR4zzg9rj/+3/Ef8NNpsgYtV3RPZ9JYbN2WgqbOGsAgEMOI78L1y3lYABp5kKjLnaukArUQdWh93pFwpR4ol97bPYyPE9iW10VPiqLA8XnPquPJ/mKqszwEDxum9yXbKY8rVsu07+Qu60vHgGjGt2GLGfPrl5uqWxCXWTwsQCAgRZcaf2k+mGJjJXlR9ymsrawrnlYKFok6rz3KRHXnzirybkYXL2jjjqa7gJSyhnJtCZFjc11VQIF7Px18MdTqXva3AOUtdpfxnMyMXy7CDvKKx/JCqh20Qco5zxCr//N0SGtFofiixZKGXbDaVw5KgCo2LH1Jvh8TlMYmSSKUEdwhYTT7F/+DKDxcBz+/JwE59BYQd62Ur0eDeZf3DUR/Et11ancUFjIuGuM0MUogGxxpAeiIDxp7TTa6H93EDxey6uFvN/8RfC8nrKfFgUT/kdlp/TWLvUAZcYRUk5VkXdMV9E/2/rg7MYVbq9/pmK8wewfBWdiBrj8RzwFCCgXVRWmEEO0
 4h3FJvRq
 gPsxwXxXzHHT8SyHCM7wPuWcMgRkoBjyZjHHrOEWDHGwcMLl9fksYg7IpagN+mxH2Dv3vETaZjPv9/pueOSjjGJ8WgvUI1/bIU/5F3GFxm9WVn2GFXMTKWeoe4KS0yzltbmNSOTgs8G6D/sJGzPVPPFQSRF6M4XjNJl19YI/HDgsSuD3I+fs2148o2GCZRxj0Es9LW70p04MTFHGoo0dlRYEZxLsDggP16D9xJsxZDaMiNeNlKfxkf6mx/YD4HDBoGdxlLMvjHTkHzsuuZmPK4wckCpbNw8PbobZqQcWt308Vd5pwAvCBI0X6yTOmoKsXSwX1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 8:50=E2=80=AFAM <tarunsahu@google.com> wrote:
>
>
> I have gone through the discussion in reply to this thread between
> @dmatlack and @pasha
>
> I am not sure If I understood the discussion correctly.
>
> userspace IOCTL for FLB compatiblity might not necessary as each FLBs are
> registered with the file handler. So when new file handler introduced in =
the
> system, new flb handlers can be registered that is compatible with this
> new file handler. I have tried to explain this below.
>
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> >>
> >> Currently luo_preserve_file() iterates over luo_file_handler_list and
> >> picks the first registered handler whose .can_preserve() callback
> >> returns true. When a subsystem introduces a new, backwards-incompatibl=
e
> >> file handler alongside an existing one for the same file type, userspa=
ce
> >> has no way to choose which handler preserves a file descriptor, nor ca=
n
> >> the kernel keep the existing rollback-safe handler as the default whil=
e
> >> allowing callers to opt into the new handler.
> >
> > That is not how it will work.
> > If we are in the .can_preserve() call,
> > it means the user has already decided which file handlers to use.
>
> That is not true.

Please re-read what I wrote: I said that is not how it *will* work.
Currently, we only have one FH per supported FD type, and that is how
it will remain when we supply the target kernel specs. before the live
update begins.

>
> From the documentation of the luo_preserve_file(): 3rd point.
>
> * This function orchestrates the first phase of preserving a file. It per=
forms
>  * the following steps:
>  *
>  * 1. Validates that the @token is not already in use within the file_set=
.
>  * 2. Ensures the file_set's memory for files serialization is allocated
>  *    (allocates if needed).
> =3D>* 3. Iterates through registered handlers, calling can_preserve() to =
find one
>  *    compatible with the given @fd.
>  * 4. Calls the handler's .preserve() operation, which saves the file's s=
tate
>  *    and returns an opaque private data handle.
>  * 5. Adds the new instance to the file_set's internal list.
>  *
>
> luo_preserve_file():
>
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
>                 if (fh->ops->can_preserve(fh, file)) {
>                         if (try_module_get(fh->ops->owner))
>                                 err =3D 0;
>                         break;
>                 }
>         }
>
>
> the first handler whose can_preserve return true will be selected as the
> FH;
>
> later in code:
>
>         err =3D fh->ops->preserve(&args);
>
> So can_preserve() is called on every handler for a fd and once it finds
> the FH which reutrns true, it uses its preserve call to preserve the file=
.

And as I explained later in that e-mail, the set of FHs will be
decided ahead of time:

"Therefore, there should be a luoctl call (i.e via a new ioctl to set
compatability) that provides the kernel with the specs file of the
target kernel we are updating to, allowing the kernel to select the
compatible file handlers. Since .can_preserve() is called when the
user is already preserving files, the specification must have already
been supplied, or the kernel should fall back to using the default
(i.e., latest) file handlers."

The user/admin will configure the active set of FHs *before* the first
FD is preserved. By the time we search for a compatible FH via
.can_preserve(), that choice has already been made, and there will be
ONLY one active FH per supported FD type.

>
> > We
> > need to do that before any preservation happens; otherwise, we could
> > run into conflicts on FLBs i.e. FH of different version require
> > different FLBs.
>
> My change below will select the user passed handler directly if it is
> valid otherwise it fallbacks to looping .can_preserve based selection.
>
> ****For flb****:
>
> Registration of flb handlers happens with original
> subsytem fd handler, for example, for iommu
>
>  iommu_liveupdate_register_flb(&iommufd_ser_handler); ->liveupdate_regist=
er_flb(fh, flb);
>
> This function takes the FH argument. So every FH has direct relation
> with their flbs.
>
> If new FH will be introduced within the system, it must register
> compatible flbs handlers with it by liveupdate_register_flb.
>
> Currently, FLB objects are preserved with the first dependent file's
> preservation. and each flb handler in fh->flb_list (was associated
> using each flb handler registration) will call its ops to preserve itself=
.
>
> Same on retrieval side, handler name is preserved so the flb name is
> also preserved. And they can just call their respects ops to retrieve
> themselves.
>
> What about If user try to preserve other dependent but same subsystem
> files with different handler. Kernel must reject this. I have not
> integrated this support. Which can also be added as part of this series.
> Let me know if this sounds good, Then I will add that in the V3?

No, do not go this route. Rejecting mismatched handlers on subsequent
FDs still leaves handler selection as a per-FD decision, meaning the
first session/process to preserve an FD dictates the FH and FLB
version for the entire subsystem. Individual processes preserving FDs
should not need to know which handler version the target kernel
supports. Version compatibility is a global orchestration policy and
should be configured once up front before any FDs are preserved.

Pasha

>
> ~Tarun
>
> >
> > Therefore, there should be a luoctl call (i.e via a new ioctl to set
> > compatability) that provides the kernel with the specs file of the
> > target kernel we are updating to, allowing the kernel to select the
> > compatible file handlers. Since .can_preserve() is called when the
> > user is already preserving files, the specification must have already
> > been supplied, or the kernel should fall back to using the default
> > (i.e., latest) file handlers.
> >
> >>
> >> Append char handler[LIVEUPDATE_HNDL_NAME_LENGTH] to struct
> >> liveupdate_session_preserve_fd immediately after token, keeping
> >> IOCTL_OP min_size at offsetofend(..., token) so callers passing the
> >> original 16-byte structure continue to work:
> >> - When handler is empty (all-zero, or zero-filled when userspace
> >>   passes the 16-byte structure), luo_preserve_file() selects the first
> >>   registered handler whose .can_preserve() callback accepts the fd.
> >> - When handler is non-empty, it must be null-terminated within
> >>   LIVEUPDATE_HNDL_NAME_LENGTH bytes (returning -EINVAL otherwise);
> >>   luo_preserve_file() looks up the registered handler with that exact
> >>   name (returning -ENOENT if unknown) and verifies that its
> >>   .can_preserve() callback accepts the fd (returning -EINVAL if not).
> >>
> >> The retrieve ioctl is unchanged because the handler is identified by t=
he
> >> name stored in the serialized payload from the source kernel.
> >>
> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> ---
> >>  include/uapi/linux/liveupdate.h  | 12 +++++++++---
> >>  kernel/liveupdate/luo_file.c     | 21 ++++++++++++++++++---
> >>  kernel/liveupdate/luo_internal.h |  3 ++-
> >>  kernel/liveupdate/luo_session.c  |  7 ++++++-
> >>  4 files changed, 35 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/live=
update.h
> >> index 509c6236720d..2413b19dabc1 100644
> >> --- a/include/uapi/linux/liveupdate.h
> >> +++ b/include/uapi/linux/liveupdate.h
> >> @@ -126,9 +126,14 @@ struct liveupdate_ioctl_retrieve_session {
> >>
> >>  /**
> >>   * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_P=
RESERVE_FD)
> >> - * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
> >> - * @fd:    Input; The user-space file descriptor to be preserved.
> >> - * @token: Input; An opaque, unique token for preserved resource.
> >> + * @size:    Input; sizeof(struct liveupdate_session_preserve_fd)
> >> + * @fd:      Input; The user-space file descriptor to be preserved.
> >> + * @token:   Input; An opaque, unique token for preserved resource.
> >> + * @handler: Input; Optional null-terminated file handler name (max l=
ength
> >> + *           %LIVEUPDATE_HNDL_NAME_LENGTH including null terminator) =
selecting
> >> + *           which registered handler preserves @fd. If empty (all-ze=
ro, or
> >> + *           omitted when passing the 16-byte structure), the kernel =
selects
> >> + *           the first registered handler whose .can_preserve() accep=
ts @fd.
> >>   *
> >>   * Holds parameters for preserving a file descriptor.
> >>   *
> >> @@ -152,6 +157,7 @@ struct liveupdate_session_preserve_fd {
> >>         __u32           size;
> >>         __s32           fd;
> >>         __aligned_u64   token;
> >> +       char            handler[LIVEUPDATE_HNDL_NAME_LENGTH];
> >>  };
> >>
> >>  #define LIVEUPDATE_SESSION_PRESERVE_FD                               =
  \
> >> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file=
.c
> >> index fb81239bedf3..be20e0f1e0aa 100644
> >> --- a/kernel/liveupdate/luo_file.c
> >> +++ b/kernel/liveupdate/luo_file.c
> >> @@ -207,6 +207,8 @@ static bool luo_token_is_used(struct luo_file_set =
*file_set, u64 token)
> >>   * @file_set: The file_set to which the preserved file will be added.
> >>   * @token:    A unique, user-provided identifier for the file.
> >>   * @fd:       The file descriptor to be preserved.
> >> + * @handler:  Optional NUL-terminated handler name. If NULL or empty,=
 the first
> >> + *            registered handler whose .can_preserve() accepts @fd is=
 selected.
> >>   *
> >>   * This function orchestrates the first phase of preserving a file. U=
pon entry,
> >>   * it takes a reference to the 'struct file' via fget(), effectively =
making LUO
> >> @@ -238,11 +240,13 @@ static bool luo_token_is_used(struct luo_file_se=
t *file_set, u64 token)
> >>   *         -EBUSY if the file descriptor is already preserved by anot=
her session.
> >>   *         -EBADF if the file descriptor is invalid.
> >>   *         -ENOSPC if the file_set is full.
> >> - *         -ENOENT if no compatible handler is found for the file typ=
e.
> >> + *         -ENOENT if no matching handler is registered or accepts @f=
d.
> >> + *         -EINVAL if the named handler cannot preserve @fd.
> >>   *         -ENOMEM on memory allocation failure.
> >>   *         Other erros might be returned by .preserve().
> >>   */
> >> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int f=
d)
> >> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int f=
d,
> >> +                     const char *handler)
> >>  {
> >>         struct liveupdate_file_op_args args =3D {0};
> >>         struct liveupdate_file_handler *fh;
> >> @@ -266,6 +270,18 @@ int luo_preserve_file(struct luo_file_set *file_s=
et, u64 token, int fd)
> >>         err =3D -ENOENT;
> >>         down_read(&luo_register_rwlock);
> >>         list_private_for_each_entry(fh, &luo_file_handler_list, list) =
{
> >> +               if (handler && handler[0]) {
> >> +                       if (strcmp(fh->name, handler))
> >> +                               continue;
> >> +                       if (!fh->ops->can_preserve(fh, file)) {
> >> +                               err =3D -EINVAL;
> >> +                               break;
> >> +                       }
> >> +                       if (try_module_get(fh->ops->owner))
> >> +                               err =3D 0;
> >> +                       break;
> >> +               }
> >> +
> >>                 if (fh->ops->can_preserve(fh, file)) {
> >>                         if (try_module_get(fh->ops->owner))
> >>                                 err =3D 0;
> >> @@ -274,7 +290,6 @@ int luo_preserve_file(struct luo_file_set *file_se=
t, u64 token, int fd)
> >>         }
> >>         up_read(&luo_register_rwlock);
> >>
> >> -       /* err is still -ENOENT if no handler was found */
> >>         if (err)
> >>                 goto err_fput;
> >>
> >> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_=
internal.h
> >> index dac6644bfb18..911ffedec9f3 100644
> >> --- a/kernel/liveupdate/luo_internal.h
> >> +++ b/kernel/liveupdate/luo_internal.h
> >> @@ -101,7 +101,8 @@ int __init luo_session_setup_incoming(u64 sessions=
_pa);
> >>  int luo_session_serialize(void);
> >>  int luo_session_deserialize(void);
> >>
> >> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int f=
d);
> >> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int f=
d,
> >> +                     const char *handler);
> >>  void luo_file_unpreserve_files(struct luo_file_set *file_set);
> >>  int luo_file_freeze(struct luo_file_set *file_set,
> >>                     struct luo_file_set_ser *file_set_ser);
> >> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_s=
ession.c
> >> index f48e9a4185f9..194ef45907c1 100644
> >> --- a/kernel/liveupdate/luo_session.c
> >> +++ b/kernel/liveupdate/luo_session.c
> >> @@ -266,8 +266,13 @@ static int luo_session_preserve_fd(struct luo_ses=
sion *session,
> >>         struct liveupdate_session_preserve_fd *argp =3D ucmd->cmd;
> >>         int err;
> >>
> >> +       if (strnlen(argp->handler, sizeof(argp->handler)) =3D=3D
> >> +           sizeof(argp->handler))
> >> +               return -EINVAL;
> >> +
> >>         guard(mutex)(&session->mutex);
> >> -       err =3D luo_preserve_file(&session->file_set, argp->token, arg=
p->fd);
> >> +       err =3D luo_preserve_file(&session->file_set, argp->token, arg=
p->fd,
> >> +                               argp->handler);
> >>         if (err)
> >>                 return err;
> >>
> >> --
> >> 2.56.0.212.g129ede20d9-goog
> >>

