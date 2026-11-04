Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73269606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O3sMTSo2
Received: by kanga.kvack.org (Postfix)
	id 410516B00EF; Tue,  3 Nov 2026 20:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0C66B05B1; Tue,  3 Nov 2026 20:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD956B05B2; Tue,  3 Nov 2026 20:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 107F76B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:15:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 870EFA827D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:15:50 +0000 (UTC)
X-FDA: 85395669660.21.B42204D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CF9B80005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:15:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O3sMTSo2;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793754948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHfpgenBkiZZTG6G9AXsdWAKG/dzpqqNAWD+meV026A=;
	b=noVpvHUu+hh55rOSIQ3jOiHYIshj2gnQTsv+x2+MD1DM8Q0Hwd1ynS9R+NNiE7WqjfTOVB
	axnItZybSm7HWOHWnclveRSAubB+kP8mTjQT9YJ7INNKHF+OoX80XuYqIDjCs9lJBbXkl6
	tMiOo3PiHFAW0zZrCnvt16G09mkSzxw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O3sMTSo2;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793754948;
	b=cgb1uXJq0vmhdbW02Tqcjdk/xvxFco4N7LMU6FlL6S4duGZ+MX/Tt822PW8TAA320pVaRG
	uqvXd9KG7RXpaTJWD2XqaNcRXNVHd81XPQahbNnlXJaoTA+5kawJGQy70XTLCFZgeLxVQ1
	NSvRdi5tw3+ISEGmz+Mx8w62TxLn8+0=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-535f598d126so71901cf.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 17:15:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793754947; cv=none;
        d=google.com; s=arc-20260327;
        b=WCJDjZryoLLvPNe93T1wLrEC042dJRfK9rU60kfTq0ozMfHmYjNbK5/xdqu6Yv075D
         NKwMSWOQmxas3e66879kGdF6gsFFDpXCy68K26yYZUpl6x8ed+SmuIi6aKD+B1GU67ag
         68iywxqmyNWU+Zr/G5zGZ3qLSKz/Wjtmx97v+VdOTVO5SwQke6lNBNkSpxKjzwKMAVxb
         E3dDjLDEhNXVUPht0VhN90t7NXge80QholYRieQ7s7w5V6srAyQbyI8gTp3kHx7P5h0S
         4AyE7YsnT0f5bqS98ki0JmjdYoI/V5DYJ8ov2g2jDBpkUuT1YVIUO4nm/sKJv8jURKNw
         c3TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OHfpgenBkiZZTG6G9AXsdWAKG/dzpqqNAWD+meV026A=;
        fh=vCWB17Yuj2MHA8nsyguTl265SXfTAa0DP0ScBTo7DVU=;
        b=BtLIiqK81thzsXum9vJIjcL0nvnNdhS6auAomd/DA4wlDxX8fjLwfgjH9dNCFBHBLu
         k4McCH0yyop1zyq5oI8gwCu8RkFHk7DYxMVu6OQU20ETmYhtl+GgHFy3TBCGA3saxP5t
         tNZXl32670fxQMJMBxLLxVB7okhxievDlhYI+9UkdcUKpai6E2puzL3bzbpJ3D7NvNPm
         7cTi3bKSEyUBdVDartBmsRDG1yAkgy4gWKLripJV2N425Ez5X7zV51PXCeGm0D8EcaLI
         3ILxNmdTRwpJ5LYpVAp92VGpXFxtxzzdEp/PIKnoQBD4R/iCBNNbKSHruGUJOQI5+TYi
         sEOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793754947; x=1794359747; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OHfpgenBkiZZTG6G9AXsdWAKG/dzpqqNAWD+meV026A=;
        b=O3sMTSo2MyluIVtl1m9NP2raDUUsru6XkqnG5axpR4/d1XMuhZ62BTbMFgk/Ta2G4c
         Ud3/OBgGpSwJc+kuBLJfBo6ynJbvEUEdQiiyE4Hwj+wrI1uL412ODW5xSLgNZWTKWOLm
         hudRw16AYdIU7iRfIqonncElbGy4KzJ9/cUwbjP76we+C770IMPd5kXR9ERtepbW/P3u
         VVpwIN2xTxX+OM21tWxvLrM47k9+Sp40oCPNiWmyhYG+t2N1F2v5wrgYzstMCYL30d1W
         7IgzIofP2GkFNbOnvNNQrHVuNG+xOk6FiGA2IvB0VwilYh3NLU6lURSxKiNJl36VRfem
         5g7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754947; x=1794359747;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OHfpgenBkiZZTG6G9AXsdWAKG/dzpqqNAWD+meV026A=;
        b=MptAhMc2VQr0ILRlJnhoqFTu4BbxKBFQMpJsp6yCzxzlZ2tEWp6gXgIQibu+7VFKCC
         SLJN5nU5OVY9ldnVXPss3/ljm2BcfPlw0u3PwD2GpwJojw/OKzHoosivgErlMHSUsUbA
         37ZT7hNFAvosggm9AOCeOPVeZxHXn6n3lk2s0ng3eEOywCKMuNWk2NqTwVgvVaQRzEYf
         1QrrzvuMC6QP24WZstfge5u3nvlXPhczdWrk3i5VgTWQLp812+Gc31Jz8ezn2yCmJqOd
         5wcGG4Y8mlo/4brha/zbaBkE3tbShaWIGGAC9nCYQXlHIBHy+Eqk2TnJDyZDotGkVpl1
         5gcA==
X-Forwarded-Encrypted: i=1; AKwUvBz83jOgbVVq4kigQZELSBVHvKRNzAwMg1sBEY4HyWUkmhVYYnPzPvieswhlYhLVRDYvocXPjfQw1w==@kvack.org
X-Gm-Message-State: APuU4Z/4mPXsUyX21IeFnZcOLoPCbsuIX6g2MAkLzD9YhyIGIvtii8YH
	ZvGEP948nu/4EjYgH2x9r6MZ++wSd642hZWALQN11FGrf3zFQxGj5AtMsqhTzPsE5slHMPdJj5y
	QQg25Zhd62+KpACzfsaUHKSccWQ7v/jv1sVquXa9o
X-Gm-Gg: AYBFou3LHiwRgk3kn8PfkwXdkUWyLWe2mp5hYcyH1TYyQeol8lCdDew7u/US55vnUjR
	uZq8zsrJCbaHHcrmoFTyMF5HRKZm4aWZpkxxZ7MVGKhb+jRckdfxTxRZf/4InEb/PBGSIMzMV7d
	gTbKASsnC0gMnKSAHqUwehWOAJdjp+v23Uv50vgUfV7Ir0moBnIT3PYeel6WamHi8gU4ZJf5Lpc
	1lw4WMd1cxrpzU4ZwZUy4MeeUVpwDDsPw99nr7F1JJabPF/VUeXTqLDvkRHNxHKxwTjyYZjHX8O
	L8a1IAngQce285UFisnFvvb5ElWdx80EBNeboxp0PzIsnjRMYcLW+p/7gjMT9MJ27r8Hl8+l2Ku
	CndzcE1jVrihaQkjsubXTAGbjoAxi1b7+xv4=
X-Received: by 2002:a05:622a:250e:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-54b5a3083a5mr1086781cf.0.1793754946755; Tue, 03 Nov 2026
 17:15:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103155454.534649-1-sashal@kernel.org> <d3c8baa0-3ed9-4f3c-805d-86c98a6bdfe7@linux.dev>
In-Reply-To: <d3c8baa0-3ed9-4f3c-805d-86c98a6bdfe7@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Nov 2026 17:15:35 -0800
X-Gm-Features: AclHuK9K5AyCjIDUUWGXTgKHl6lHpNmZBhcxz9wcjVeAYMDz_SXNrtQhBbk_zso
Message-ID: <CAJuCfpHZEgGwogySAbUOWxb152sDhMrbRO3gMteCRt0VGLc+aA@mail.gmail.com>
Subject: Re: [PATCH] kselftest: alloc_tag: use the ll64 types on powerpc64
To: Hao Ge <hao.ge@linux.dev>
Cc: Sasha Levin <sashal@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xkdibdjepo9bcbzbtibajrh5gr73urpj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 6CF9B80005
X-HE-Tag: 1793754948-913706
X-HE-Meta: U2FsdGVkX1/wyuGLTRPYs0eHz5bkr0GqrlXl33EkNiW/JdrAvnwXm9ejLDOzqnOWCgvnEpx497bet9m4L1DS4aOuXwTF2UgIkSyeQ4/+9dIdkp1o+97xUW6QUkcfH20p44Qunx+YdiJAqlWJUe+zFsZM9xWQzC/fi9HZORNymbu6pi7NWmKqi4TiGtChagB5MsD0KLBUVljWb1HAEeAmB2mB8sxU5Tgd6UHpXDDVVFB3m5c8nc1aqmyPEPOwpm7id/7iC3/IIDRKSSosvh+m/ID//CEj7XXEEYGtH+37BLw7notwj7QqMauZevNsVvVYSgA0FndeNesFZS1Wzt4Oyd51C2AcFRWiIb1FbOXCV2Po7avwy2OaLWnxuuBc2cC2Rn8Xo98dmTxac+5HOVN2RQQEz3merKHftRUOps+dQl9upI+yCHdvI3w/krIaLWCOtVG/E9sv6BII7MFk/e0u0xq/rm2aAMxoV+bOUIvCi0uR6OOzGbL1fF7u2w/32fmQvCUpp/h+ctuo3toTu4gCAJln2gEm9i9A5ZN0RBFGFD9029mIbDIEEG6TqZ59dHtSaTjKTqYO+WprmfWSVMPWUFVMGS2LaOeL3fD99I09NVPVaFlBVF3VEis1/d6Uu/Q5aN3LVe3YDw0n9Dl/MFx6QudD+c4p5XKlSd6AIE6tM8dhH44vNZ2dM97ivfg5dPgIsrU4yQIthSA4qOsdd/U18AI5KZ/aQOlFVp3/RVHwWeqUshio/Tmqyp30sugDEsHMhThIsT0MKJvnW2xFlzssfiDxlQgD8EHPt+rM6k3+4OEQYcKass/242nQ2+5cOrBKNx4eDLH6vg63ZRvzXShwazQJVpWxAF0mcAHqfRMYedkSWdrSYNEH8XhBQOGh09aLUlZC5nSOqZ+JK/vChftu/QbTgCMoBneu+Fx5M+tr9fQDCuv3YGWsZCL4XeW+HoKT2f187u/eV6DJfcs78jY
 HVoBVes8
 Q97+mvPk62iAeR8G6zw9OW4gnvRiI1NVO06uvfkCPGYI1TSI8z2I3g4CqyoA/ec5UDzgVQlVsOdYwdG+4SST/O4LwLSYaB+MvaPxPHpUuoCh7eqK2yodrVZNaeJATqOfpaJPluVbzUp/W7fbKjZWeXDvFX89JqTi+td33IROZz7lVEB6z/gG92XTmTJWeadCqZVbDPKR3ocOQs9lNoFEekbS4vTHt9osdDUkRp+WHPs3a/0FJF1NiuPMOQfjLihfqzrvJpNoAh76t2wVB329JcAVrT+OW8GP1K6+nFegkyqb01EuriHEazmi63eAnpBYojRmhgd0VdAKceu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 5:09=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
>
> On 2026/11/3 23:54, Sasha Levin wrote:
> > On powerpc64 __u64 is an unsigned long unless __SANE_USERSPACE_TYPES__
> > is defined, so printing and scanning the __u64 fields with %llu warns:
> >
> >   allocinfo_ioctl_test.c:93:73: warning: format '%llu' expects argument=
 of type 'long long unsigned int', but argument 2 has type '__u64' {aka 'lo=
ng unsigned int'} [-Wformat=3D]
> >
> > Define __SANE_USERSPACE_TYPES__, as other selftests do.
> >
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> Acked-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> > KernelCI's powerpc kselftest builds show this. The define makes the sam=
e
> > change on alpha and mips64 and none on the other architectures; the
> > x86_64 and 32-bit builds don't change.
> >
> >  tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b=
/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > index 74fd64b2370cc..18c761fecfde0 100644
> > --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > @@ -1,4 +1,5 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> > +#define __SANE_USERSPACE_TYPES__
> >
> >  /* kselftest for allocinfo ioctl
> >   * allocinfo ioctl retrieves allocinfo data through ioctl

