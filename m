Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403EBF3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 14:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC256B0092; Sun, 15 Mar 2026 10:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159D26B0093; Sun, 15 Mar 2026 10:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059166B0095; Sun, 15 Mar 2026 10:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E629B6B0092
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 10:53:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBDA31A0A30
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:53:32 +0000 (UTC)
X-FDA: 84548591064.25.058D13D
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5C37180003
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dImkLE75;
	spf=pass (imf24.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773586410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4CJCRlVmNcmaaBkWvC+xv0ht0aAw3516GPBlPoEz/U=;
	b=HJFinOFRUB0onKl/8IFCuXZ6vSF+6Yv/bncdCslVRWuLHE0Q+FYITbdjzl/Q7qH97SjC4U
	G4K1TkDyqQ++I8P+6mK5+bs0l4+2IC7i2+eKsfL4xQIET/IS738QSrZZOfEbrQhdMbcr8l
	wXrypG2TL2B41rQk2JT8R5Rgg0cpXb4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dImkLE75;
	spf=pass (imf24.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773586410; a=rsa-sha256;
	cv=pass;
	b=PCenRnV11WKF2KxgHDH23lMW/8STRXj9jX8H9WH770t2DVpNoz/oeVuBnGhr/QHO/+2rcX
	zUU7WbuqQ/i+XH6oHTKoK936CukkKnCR26q9FuIp0nE1/bAz5e2H8nrpFl75nxjM1upIbP
	6ie5gRIlTVewj45TiucpKTElpq8M+ik=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65a1faf828bso433582a12.2
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 07:53:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773586409; cv=none;
        d=google.com; s=arc-20240605;
        b=gHI+iKme0GYmrq18L0zdKqQlKwSCp7cZ7xdasqVIuGz3NUn+L+Ue/v4LX1Viv3gMAF
         ziOZqWq5YehwGmpwl40m6505UdENyQa5XQZkUBrP9mK2u+fqoz8cizhQkCBPs61OHzz5
         C00/xmPVMUViNgMe5WenGdDY0BK3BNbyO0bAsxnFTRzRcQygq4dvOorDknX/gctHMixQ
         Za6u7SyUI7AQGk/NuUP1d2IlaaMF3dlzFEtSwsaAhf4zrIgDk9Z8sJBBwzTVgxZMHxMN
         t55sxeY+Mza7PPXie6Y2U5SfRedJrh7MI4Ve9o/cTM729O6ZHQ1vS7bREywW2M9w4a5x
         vzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T4CJCRlVmNcmaaBkWvC+xv0ht0aAw3516GPBlPoEz/U=;
        fh=7y0BB6PyJWajtiWP9I8Q50gHjxJ2z8YoXg2UetclmC8=;
        b=FhZ0nc+4IYnER1yPNyBGRqI7rjEhzy527TQkLh0gYn7gkBNrZXxjSWA0QtIy8V6L/d
         8XbYjrh+9B89oYnziLgG7//kDk3WZIy6iPt1u0J3jjp3Rqcl1TC3EnwY3Tc8JTrj/n+V
         BmLsFGhGjQs1Kj0ZBnB1XAEb9vzzqPYZy/4jzVT/yDKDHcN2UbiSzEE/bCR9UfSIygBQ
         ZUdg7AjqhnZqhmRKPFoVOPPHhVgE9cEZRMRDsUg52PAtw22ao9KRMgBhjsLlhiAe3Ur+
         /ZoIJhfBpEEfvPuTskACBOpFYodWQDvItQwgdOP0GfxYcoe8wutlUtdeA+g8/BeZz5yJ
         EvKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773586409; x=1774191209; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4CJCRlVmNcmaaBkWvC+xv0ht0aAw3516GPBlPoEz/U=;
        b=dImkLE75KRwsDwMwsjO70LEfPUgMCqwVHpqi/9lmFc6DXUbMV9gVsDh5xgbbRHYQAJ
         E6Pchqko04hIhwD2z2mL6s9B2eVJsxguzNJbCQaYNcNLWSgScAMwh/3DjRyaoWj6AZJ8
         C8XO2sd6bPJ3XekT6jKzKH3GR5uCSnsWtIoNClHQQXpiQj63IOP8L8Iq46IJKIEc65pt
         0Dx2XZvRPfhZihlSTj++MTYUcrhPeejZSqYRgAUKq9hie+Sl7gdSnxof5apNnarjD6Jj
         jDD4YEPmfh8Sb/YQbf80OoYdCruxLw3UmQIjZ/Heou5Y9BKSCOx35Q2Ie8M4rtOHWUcR
         oYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773586409; x=1774191209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T4CJCRlVmNcmaaBkWvC+xv0ht0aAw3516GPBlPoEz/U=;
        b=ghZ3EpxDAeDFJV+3WW/vl6Pl7pCZfuU3o2c394NKuzcyWcFHfMcGH0/0ef0kgxuxm3
         +a5sSbymvwgPbg8veuYj9QR/Y31o6BNxjb1anFPm7wl+rFu2qGYAjnbys9opp7D88Vep
         eafGExysepMwUziM5SMw2UFJO51uOhcqun3nq+gLt7ftxB5LkEs6M9aB3bPXqezTi6hG
         /z3OPAElybX/S8FTekNEuAQBlo/cj/lVRq3XRzmzXkqMmhrobeFKMd3miXs5i5ilyeL+
         s61nWS8DvK9dyhPxZWavSrlY5NxPJqp7eUVn74ZzIKs/Z0NWoVZohrFrJa8Z7nYzHR8g
         MlIg==
X-Forwarded-Encrypted: i=1; AJvYcCWWDv6sgG/G1sBADduELv8rSe/uagNykvRmWPyC/7cf8bJG++a0cl6KFzfAcHD+mqhPiaIPKHCCJA==@kvack.org
X-Gm-Message-State: AOJu0YyXREaA7U47+IMZ/LlSxQqBRfeK6t/P1eEP7KaZSJei/s+z6m/D
	CAFUpUkUD7TNEeOhLaHPOgVKGhMRW6lqWgUtE8ZEGp5WjbeqQyTy5vynlHq8we4UEN0sb5aMStz
	Hv5zlf01Kb3dZ8Nhs8jz0deVqQY2EwIg=
X-Gm-Gg: ATEYQzyVlK6a8LqpOU8ti9L6SBuFCa8PKts/EEWAsC3KfwSjMapEVjCQEwsi0a904v+
	9f3yfEqiiUDRET4yqp47wjVZWZOalIkAvuamYN1mLxbHuRiZVkgZS0drK3KZ2rW9fdEfVdBcxzp
	Bgcd87XL7OdGyy7gnSDoDycCuspqMbcu38ZvKV63iY0DO+WA1DvUlk/9r5Zxw3gv5045mlPXZG+
	VHjy7idSbqNTohM8+Rr97URJE7SnRJcb6bgh9s2zzhQKE2sJIPIU9w+H6kLcvL3ykHGlt+qxnIA
	Chm4Fak=
X-Received: by 2002:a05:6402:13c7:b0:665:ea0:3aeb with SMTP id
 4fb4d7f45d1cf-6650ea03c0fmr549081a12.1.1773586409038; Sun, 15 Mar 2026
 07:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de> <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de> <aVgjpWaIRkerdgCa@eldamar.lan>
 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de> <aVj-mz8vaw53TWtX@debian>
 <abX53NWDsG8oW7H6@monoceros>
In-Reply-To: <abX53NWDsG8oW7H6@monoceros>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 15 Mar 2026 14:52:52 +0000
X-Gm-Features: AaiRm50qoW5875jVMg8blrX-fMQiTqfJs8s9vRfUb-tlNoJDYMwZIeq1FVYugT8
Message-ID: <CADVatmPm5Xs1W-f-u34bXs1ok=8zyySGSSZk0KKy5dWXZLXQZg@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Salvatore Bonaccorso <carnil@debian.org>, 
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, regressions@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Hans de Goede <hansg@kernel.org>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	benh@debian.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5C37180003
X-Stat-Signature: 4xb7nodnk18i6odpfzkmpwdbak4zgftd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773586410-886778
X-HE-Meta: U2FsdGVkX18ayJ4QDH7N2GK3Lbmk74jgexxWkti6TBh7dCa1LY83mpYrq8nRnMkK9nCRx/TmwUBlFXn4lwq0zf/JF2gPlbf1BU8jCgHLMBxfPpEEQZo1rza8Lpgqil6ocwwYSf4rAIh6jlBn3jGdnDuhmZOWInLd0MyYUKRb1vZho23Pyrme5Bk29UfNoxauh9/B9K4cLKuLhe2O4N9L40BHbBa4UfgREnZVUy2iqz0/Nc7i6qJVEIoL2pR4VGWJWq2RH49d7/KFb7CLsg89x/iQ2W9zeabXM2SL+MOG/enFbj0rPYTd93AXlrmffPokudR5i4RM+D+TUkrlgYYD0jYPtHoN5NM24z8yNPFsZbUwHUoY2sQNvQfO5CzguI0EnOR4g1QelubdDgcfqp1wZY+7g/8k4PBeQKZ4nvj63XoMnhsFrL/YnfYha49o/3s73P+9POcFtcuXXEliKLtFtbiMY/2RCxFo0akaM7crMB+GZmXUUJWjm9Zc+WwqM9xP6yGQ1plh5WNRLQCoXrH62wP6Lood++GU/oYpmFYx1NOBXtTfNDZ60hG8ZDPcgVfbiPvWqImMePbJcNTnjuyA4im6DLZ+XiBW9uNSgqquzu46Mg41taRDpgIIkjFfiSxPwhV60C40fK0D8mlTW+tphGgkZQwVDGPIrj0UxqB8xt8J5qysgdrwVLpA//OMoYv/YfK1DXy/4K9KcxOgCzszwJvWFhwY8GHbFbK2nfjeBNbIXeaJ0y56EmpJjOH6cP87Lyww4oG4ar/2FcZb1yHLj4OYxLAFhV7wqmrViKUR05BY1N36sYO+zA25n63dCl4wDlHepELOB3tLZRrik5nYSdftMk+iu1GlTu5xR6Bvqehotr1oRufYNZasyydWc0NaSHjD2mUZ85AtM7eYqicbMhz6Inmys61mtHg284rWpXY6q32e7CP1v206pIgCpvucnoIT8XuETU3VzLOq61/
 JlaBGYVQ
 CuwMZz2zWRyLm1MuMg4zAmQ4VwpKmlWqFydvBer6yNG8u3Wr/uVb0dfoEDcOXY7rRzMIH7PnhpFZiv9A3iojzjqr27f2ub0DQTlB/GpEYgA0PpRFhJtZiltN9pZd/Bx+9fuWbZLmdfxO3NN+fNNxAxgH/4l1GCFsYU6FUIu4D94FRS4RginquDeoVM32WdWfzBRzTOem3fjTVWXtu7hCVGMfg610RZ2gwr+u7cK39nXBM3tRyP34jB5rNZVtTLrJVOUN0mMQo4abD/DbcgwLRRAchD4FD7KtApABPvqWM1FxUXjosi/YPzbhVitUMOnNYZIg2MrwZ1GK2tzHyIIrrw9OLDlim3KC6gNp7EtxFE6Pvvh38eBxmfR12smUR3V34oLKEkE1gzaYNOfwkmJZ633286qv0Dz3uG9/eiZK5bsbm2XHhjQVneWKnffxGrWakj+yvyCgpX0Tb3c/5VrWz+9E6EjxQ7lggvSUay1SsH+MnAe73AzIQgZNdpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 at 00:37, Uwe Kleine-K=C3=B6nig <ukleinek@debian.org> w=
rote:
>
> On Sat, Jan 03, 2026 at 11:33:47AM +0000, Sudip Mukherjee wrote:
> > On Sat, Jan 03, 2026 at 12:01:19PM +0600, Paul Menzel wrote:
> > > Dear Salvatore,
> > >
> > >
> > > Thank you for the follow-up.

<snip>

>
> There are several backtraces, I looked at two of them and both trap at
> an address that corresponds to:
>
>         /*
>          * This has to be run as last thing since init_state may need oth=
er
>          * pardevice fields. -arca
>          */
> ->      port->ops->init_state(par_dev, par_dev->state);
>         if (!test_and_set_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags=
)) {
>                 port->proc_device =3D par_dev;
>                 parport_device_proc_register(par_dev);
>         }
>
>
> in parport_register_dev_model(). However the trapping machine code
> doesn't match the kernel modules of the respective kernels, so that's a
> bit strange and I'm unable to tell which of the pointer dereferences
> there results in the NULL pointer exception.
>
> Maybe this is also an instance of the hardware disappearing? At least
> port->ops and pardev are non-NULL earlier in that function and all
> static initialisations of a struct parport_operations have an
> init_state() callback.

Thanks for confirming. That is also my understanding that the
underlying hardware disappeared and mentioned that in my first reply
at https://lore.kernel.org/lkml/CADVatmM_mRnkDX=3DhpUjbyKkZnGynxJfRSujGxm2L=
aWWMEL_2ew@mail.gmail.com/#t


--=20
Regards
Sudip

