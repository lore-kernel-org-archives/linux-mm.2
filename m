Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67758F483E4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6F06B0005; Mon, 23 Mar 2026 14:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56836B0088; Mon, 23 Mar 2026 14:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45D66B008C; Mon, 23 Mar 2026 14:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63356B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:48:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CE8E140CAD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:48:21 +0000 (UTC)
X-FDA: 84578213202.16.C7537AF
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C6D940015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:48:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bxpMiN27;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcYV5qmYcsnRNOVKxHhuAn3tOig0z+BjjlFLGSFtEKI=;
	b=P/uZB8t1uLM6NS5Ut/FnKV4Kv8EOtg0Gm12ubxe++mEMmYP+5jMF2jGbN5cm3UkHv1flKy
	7iZ8xcR7OQDgwbOgx0+I4hoIpVF3eAzv/daJdEeXKQAcMeH2k9aJxSeaw5Ao5QMQsy4EOr
	R4sOWjzTM8UqQXu/p3MPImlHQ8OWmwo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774291699; a=rsa-sha256;
	cv=pass;
	b=7J6W+JDNFx13Q4Q8vjUve8uPSQif2LS4zt4QBVjWEkzcAOR1VK1qGQ77K3ZaMWp8a6HcBc
	3P57S5O7Rh0aIdERczeNei2/kbA7uk7PyN/jq8ZGFd3ZA+bIZlhlQ5A5S4Jm41js6cH9x+
	T5qMIs854vmUmQXixjzeKRELrb5ePwk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bxpMiN27;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so56021cf.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:48:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774291698; cv=none;
        d=google.com; s=arc-20240605;
        b=EJGEQYTdishHEUWLi2Gv1R7FE8hIWRQHY5BbUQkmF08jaWS3k/MMO8xWlnHbuyTcIa
         xQn8grxjqMtQa2KhKLvNYVxNoONs3hGFX1Tf7iN4fbJtszXkI5JzKULp1PhnNdUT0/jk
         OsrwMZfo5LSyT+aw1Fj8XJlE8F2hB9ANGHRjSG1g7/zNBT4FnsLS1vtUmG54bKBFjuGT
         Q09Qm7EPXvRc6HD8aQ2r+CtQKx2av/kEjFCC+aIc0XTzDn+5+kjEefC6SWrtvwaWrm6L
         V5+FxJBAQ4Cy+2m9HHZG06LKvF1pUThFxOauAG7BvI7+VOGQcQII3s7jLolCsMV65H4M
         f0+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vcYV5qmYcsnRNOVKxHhuAn3tOig0z+BjjlFLGSFtEKI=;
        fh=Xu8g70JVMfJ7PGYvkgPwr1zdD7BMU8eTzZwClnIm4Lg=;
        b=ZkeHRq8mtDPFExhMNE7A7/5wd9DCb7zQAzlT/+PZ6VtoUTXDpWqu9wZSSRxyWSxU2G
         /yAS4Xlt2fC4ZufD4QGoBkqqyUd3YHUVg/Vvdp1d5sm5aqmBV6mO6QDjwzO+V7ODnDBN
         77v8plupxlRxKDVr8hcwgWxioX7mlOLstWR2h6AC972CRghJ3iWZE9LIZAQQWLlKcPSe
         X2HxkOw90lAifDfTqWvRRUAJh1hOq/Wqwtw28kXIzhk4dtZn2ZWW4E4osL0cQO30gaJG
         uuf+RyQHMIqBVijaaLoO3Is4agguAlJLZEInvjxc6RYJ160lCwgi0up+uC/ugZz3n/WR
         fJrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774291698; x=1774896498; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcYV5qmYcsnRNOVKxHhuAn3tOig0z+BjjlFLGSFtEKI=;
        b=bxpMiN27Ow+/Jbto/tQJvZYTzIbLfy1mQXpk/6NTDRGECElR0TBtatezShrdjz1hdc
         PGZbbSOYJElVCulZJTrLEV+k9yFiIzBfrD5AXSgrTMzf5NS0Av8PWsu4lLNJo1OT1+pW
         xPxLfX0dvMAcvyxFG/w2lB1zUY5GdGsb0+eS8iG+op2SQQhwypKZmkC4To201fBFxk5y
         M0kBQ5r5lATb4ixrdOQrVQYOSftnjpYmukWsTC4G2MMDOTmxJvHGJFj/WOruHI94G7Mz
         WOdd+rph60vtXi5st/DLCjJaGLVRDNMYizpkFt+s3zAoG1Ky4CMbrLa5aQW8aeFXAgFS
         6emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291698; x=1774896498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vcYV5qmYcsnRNOVKxHhuAn3tOig0z+BjjlFLGSFtEKI=;
        b=qbq/vLsNHG1TNkz1X82e0Vyjugq11R2Z3zxOu2WLYl0ZQW7cSTegXXv1IbG/45L364
         YR6Ukha5Kwx1tTjnmzJJxWSqrmibH5b3eMw7mhdAu9EMdQMmBYy0UTBPxTHBq91Uwr5s
         i6ji8IslePsxoNEWUkFc6XsZsSgU/6kFXTUgcsVAALzrhEBRCzeFkPgD4Rqp3pBaowxh
         eWhRC1s80FXQwAW2zjOmzoK0WjSS2BRHPA+/ilW+SpSMSIyP1cDureUC1coDXywKoW66
         vR78Yef4YugqPG2mwVR5knbJwagHOKebqj86YV/eNXx0BL3h4WYc/VNJZ3SG2AfGdT4I
         vC0A==
X-Forwarded-Encrypted: i=1; AJvYcCWAigtBIOZ184fN783HGzr+k52yyjBSpVs6dLzypdVg1COD5/RNoM1ZIjYzj2gVwuTeTEWXSfrLUA==@kvack.org
X-Gm-Message-State: AOJu0Yw+vzecNir5KfDSh4LgeOo44CmX4bfLr1tpBFDNTo8bsiqnt6FE
	Mj5/dzz05NuEL6aK8wY64TtmwLJpgCvD/kJJOrnCRX79kFwifIpReecse4hxIpv//G4WLx/gsQb
	sF0VYDHFvV0GiEW+hBdxVty5u4VQtK/TBuHk9lY9g
X-Gm-Gg: ATEYQzytqD2OaCagWblXWULpZpPCvZeU4OCCVWNZGQHfxpqKaML64mmYBwgkTq9kfn4
	fIM9Qm9ccvNZNUH78bQ9Bw5N6pFO9fbRUwuuxRizzGkTSJX/sDSRQqBfhg7bBI7cTnZKGZsNHhi
	n/6VPdwGn8Y7mS3Cm/SpECUOtlGmCA22lcF+eotfmRa0io6CsTxI5BJqP/IJBL9nuW/O329iH3G
	JUiNbHUUl6aNTfKAMSOh7WSjjm32kn9IuXWanMaP+AEg9QtceBZ5VAdJ3+1dfJj2nk6/38Q0IJk
	rBkdZbUZfbDCfn4+
X-Received: by 2002:a05:622a:1f85:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-50b6fd357cbmr1787911cf.9.1774291697776; Mon, 23 Mar 2026
 11:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322054309.898214-4-surenb@google.com>
 <fb38ecc9-36f8-49a1-bf20-a2c03244e574@lucifer.local>
In-Reply-To: <fb38ecc9-36f8-49a1-bf20-a2c03244e574@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 11:48:05 -0700
X-Gm-Features: AQROBzAcISvCKuZDTq5gxGva_UwU6WnzRjvi5ru0PTUHh42qSaWhag7QAbSow20
Message-ID: <CAJuCfpFDv1JC-wXR2d_KyrisnJTXxZbPSCY6Bpo4vLxj+FNw5Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: s390: avoid kvm_s390_handle_pv() error overwrite
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4C6D940015
X-Stat-Signature: 3ikp9dunjhcdrtrgbg9y4dppwpt1r4rw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774291699-584924
X-HE-Meta: U2FsdGVkX1/Oc+z8uEB1fmFvRDBsDSS5z60zlRpp76V5ZRDTCtlYMXoropwCnB6n2ZB6G0mT8PukoqdooWbAAj2sXnRRQTrmYucYMG4qfoRX3meO8kTTbpE1P4GEvity9xAH8ZJmP5yRxh9vY8vxkyqLcZfSRdydUnB3j8XH0+TUCViiey0SH43lgm2cxnOEd1dGGn066lMsyhp7/Fd1uYkbki2NL7HRQLvIaEhF5MXiEiOile7cYLYJX8VfEOCzb3Qz3ke2dqzNZcgGXL/uQlptN9lJNFn06CzNqGSF/mPI9EnuITYQThQ48sNLfaJxKstgH3BzP79/cxHAL7tCb6nUFrHy6b8VR7AS8U6OvRlIeKdjY184sL6qOJjiWQ7ed1hAUQgiDFTU83oh8Wi6DaGc+XoxwUy2u5LltuefFZ+qAhuT4yYaf4CNUPm/NeQf7LgePO40zGHmlMSagZ1VhSLpoZwjxK+z/bXsWQh0ZHqIqyxXrRtoomOdTvmGVAr6Vl9eKcAeQMyVgk6XrBouP4LGIYtC45C+9DCK9/Z0DbVy8iy28aTbsGUeGrbdoNOefrPH0S4M1uYqB/FxxT9aoZEXuLzBsPbX0wBx8leRYeXCEdHyzcK7wO/ph4CGxgUSwDAU3J1wh+64/bTcXdTyGUR7Y+Ii66kKArJSt9pvfXhb0nNXXbrePllso/SWSKL/GabtXH42aL5s5zcd1qCLVS7fLl+ThTfC0DGUq8bS0INGPXScsyaL4JviqizD6A72ml8ItgZ1sRpvtyIJw3/iQl35aiDkHNfdHyWk3Iml3lr6BF72KzHAwIeCeG/3ftd1Z/eJ3Sioq/FgxB7fNEpszFkeBIw3LX7i+au5fMTXekR8xwQth9fAFJsIV9zUStG29eUeHFyBIPuKgzS8S56JcYwMrGvKCNTdwXRpcpafYl0YLBqdwAsR8HlBcGbdZ5wwYAVOGOKkAWCLwg6THOW
 FJcXEyFX
 jQT8ww5EU0cYSao1dd8wpGZEnRlg8WLjQOXbWyLRck3PCbiV9OlLayP/hxkGFRBcQYjTc6Lz8ztv8qx1Ay37NUlGTygWGmG+cthm0lhWow9Isg6P6FDfSozvLl7kWsEEtwzaajpi/iA2DUoudiCuhh+B9TEbKdCQDLjtvuXdsm3KICE67F/7eSHF/UyNHE9E84+9pyDkPVDQZO5nb4s1yfcp6nEXW+Xz2xp2/LQiriu6TsIDbVsDqPzRBNcjBXQnyLHxhnNDTmRzoGIdlsn+xDbrQPGZhq4bnu8RLzKL2boEK4XXUDpYsbSQTCQR4t/gDXOfdmZjEeO3F8BGHHqlFelvrEIKTfcFraC1AJbNWYT/4MsfYojyfy1iSyQqaTM/1ZTlIPxdxq3fXXhb7fS/ZnHnWsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:53=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sat, Mar 21, 2026 at 10:43:07PM -0700, Suren Baghdasaryan wrote:
> > If kvm_s390_handle_pv() call fails its error code gets recorded but
> > execution proceeds as if the call was successful. If the next call to
> > copy_to_user() fails then the original error is overwritten.
>
> Is that really a big deal though, as you're returning an error in either =
case?
>
> > The follow-up patch adds fatal signal checks during VMA walk, which
> > makes it possible for kvm_s390_handle_pv() to return EINTR error.
> > Without this fix any error including EINTR can be overwritten and
> > original error will be lost.
> >
> > Change error handling for kvm_s390_handle_pv() to alter normal flow
> > once failure happens. This is consistent with how kvm_arch_vm_ioctl
> > handles errors for other ioctl commands.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 3eb60aa932ec..ddad08c0926f 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2947,6 +2947,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >               }
> >               /* must be called without kvm->lock */
> >               r =3D kvm_s390_handle_pv(kvm, &args);
> > +             if (r)
> > +                     break;
> >               if (copy_to_user(argp, &args, sizeof(args))) {
>
> Yeah as per Sashiko we probably need to copy_to_user() still.
>
> But in that case, do we even need a change at all? I'm not sure it really
> matters which error code terminates things does it?

I agree. I plan to drop this patch from the series (see my former
reply) unless someone tells me otherwise.

>
> >                       r =3D -EFAULT;
> >                       break;
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >
>
> Thanks, Lorenzo

