Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C877AF94CBB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4078B6B0088; Tue, 21 Apr 2026 22:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFD46B0089; Tue, 21 Apr 2026 22:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5326B008A; Tue, 21 Apr 2026 22:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9A76B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:07:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2B10E69B4
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:07:12 +0000 (UTC)
X-FDA: 84684554304.08.0A95B9D
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2919140005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:07:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kF6bVTji;
	spf=pass (imf09.hostedemail.com: domain of shicenci@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776823630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWpj8K5tVkivvOPzV8h13mA6RDX/L7gtRkhm/3EcP2M=;
	b=5+QAAAsi/pWu3tKEvfsykPSSnrnG6Qv19vHPeGH1SjAH7eAaon56HVkkslI0LdWXIfVMmU
	KnY5tag4xglv9v7K0Q6ZTs8lqH6trFLBxCpWRS24VQFuJNJMENyeqWDAEWTV8pU3Y8Xb3g
	u7SaSqUb8mgvP7fUMckpf+QnR+5CPvU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kF6bVTji;
	spf=pass (imf09.hostedemail.com: domain of shicenci@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776823630; a=rsa-sha256;
	cv=pass;
	b=emxc9phAFmkn81Kl85WVvmxM3X5tRVlanQ3msZ3UBBsP+Hm+2y97SkWV0QB2LybDECHZom
	ahravI6SlTsoaCNEoztwBcMxFyKvTIDE0Fdle63mxO3VMfamGJyJLu2bquMUOcnaTblBko
	IP2hIq2Cm2MZOW3xSHjsG3wdspUkidA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad9a9be502so30490695ad.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776823629; cv=none;
        d=google.com; s=arc-20240605;
        b=MemiX9x5Y1ReTt0WLNd5WMNhBcW6GVs+Sekt8egiQdv6Wjd1fVXco085p5y3EIZ7dr
         W1/pMv2tb0VBpX5lS9qvJZGTnQ8ZAne00eVqc9ZwhdFcvZhIVzJsE3FuRZrmcvffr7D6
         HQlWMtukhL1OPFGTu1PyM3j1V6+JZvGLAx+FBOndy2pnCIYR7VKUIhJa36jWCR86mBu2
         QI4imVGdhNDX1PjVzGAgAPWXc6NO7dRqWE5UcL5XLprsDrFxxQf4Sc28kH+XLPT5aZyV
         MZr3zXnDs3SoVLUNGA5M8j9XQbzhIhe0A6kIFRgDwRNiR1xLJXNaxBNRpv9m9q+20lQx
         6XVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WWpj8K5tVkivvOPzV8h13mA6RDX/L7gtRkhm/3EcP2M=;
        fh=Js38SYaKiMtI/Xb0ONcyMm9W1JjK3BuQQlObWrhG0dc=;
        b=lqPehMJEJhc0p03oWD7Tzr2DYkaN53QAy7rPiR7Hxiq4e62vooJk2jAWaQPyPieOTE
         v5R/mUU6jIFVqmZsDya71+lzd53q69iBIWpGrlOPmIo1EtBoP/iMj1aSD00W4idRnu9J
         SKw9WPmFLECG74Ii1Z7yf5NLlBHGBh4onBEyYWHzrRJfZODx7XSOiiRQ8ybOvEAu257c
         7QCe0l7ZGGbeMrjJhyo2/c5oeDsf+VXdy7mtIfgQYWYSWCgXsf6TP2Sv8m7V06EH+zXP
         Z33DPSB7/EnIhOSpjr/4wGQiSPDWj+cPs2cquMWszVgpqyqODKsRKJVUPF7qugc7iil9
         JK5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776823629; x=1777428429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWpj8K5tVkivvOPzV8h13mA6RDX/L7gtRkhm/3EcP2M=;
        b=kF6bVTjiuWyj0eHAKkLGg4ZcxSddE1CQyvdfSZ/8GAZIXgaeGHkitv/DYSk1cKIAGX
         uExvZyiJbLbzDWhIs2wsvUdcWVsymZG1xsu06ei7IoQHSqyzMWwSFK+N28CFEbYWT9La
         3BTg4FxzFQeqq3iUp6OKQFVBGEhUiHdTxgI+DhBHLZJWxDvYuM2Zx4l+kjOVRrCQLXbv
         ZYVmA1a+gjcg6x5+Jas02SVCtTf5dJ14WgPSTDKdaHnvBLOc7W1xzjGAY8Xxl63jOFAf
         8tGjHaTpodnJXuXOtZGlsdsBNfsNn6JPmT8QaIlQxWoJ91FZEFV31XjHaTSXazCKOHeN
         XkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776823629; x=1777428429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WWpj8K5tVkivvOPzV8h13mA6RDX/L7gtRkhm/3EcP2M=;
        b=X8tLoXcPPs9OMNAoCbUmNsSaThCDbE+0r/d9L90VIOoxjj30jFqSMjBa6m4Xrs1OYA
         a8B7lIIH8ltT2V32W+HIUHak7rfTxiASZqmr7f8uYsnQ+rX8L6yC8XDXu9pckiYn48GY
         BtSRoTyxqdiSWTkcHyqNKMAqSu4FlHi+u5wgIq8kzrh8avykcEfGCfOKUVQySuf/mVnQ
         YCkOYY1SRt8DJCs8ErcKUGJNunlkBL89ByOMlnrXx9K8sNUqUpRagT0UWov+yh302Nux
         u44EzUy7VEjE/3j+HkKUIqNqqr0zyWACzFK66YoTv/r1FffefTisNdN9lWrWrJUnzZ1U
         +//g==
X-Forwarded-Encrypted: i=1; AFNElJ8C0gFCBmF4TwDoADz6yM4M51sZDSKaFsYg9iJGJJ2N7tqEPfwFLM+SQ6J/bob1n8M15mdZeMNi0A==@kvack.org
X-Gm-Message-State: AOJu0YzhaUshOtPFAGYsJGmFwXes+t8CsATS6eKOBL0F2o13AbellIsO
	AkvVH1LIS/Q8hZx1IR0jtK95GQKA2088ByiHTuljlSVBk7sGfI4JfcVi7Q7hfsFajKjaDY13DdQ
	sXmNpsRhtN7FIddK63sqWKXOlpaGorec=
X-Gm-Gg: AeBDietqwQLyDQuAvMuS4U38xl8jgQ0vTDWr1ullif0q+jdiahlAqjrS0RbbYfDYpYk
	be2z7M+8qPGQJaxFR1xUVfZeaWotx4sr9gmLglXX8E6oQeE95neqqA6rltNBWOtEJxFqfmkP8gr
	igySGTC7vvTamlTE59BPkehBUTNvIovjh56XX45O/kX1c+HMYKPg81pDKLf/Ib/NNTuZiLYt4w+
	UM2HBcpqY6QzHmWIjWBgGlUJ6WMyvNXkc0Dxg6e+y+5Z1nEe2j7FYjzob+W7lRavUnhIe4WDO7h
	fP1I5rhK+DrFNkZhp1E=
X-Received: by 2002:a17:902:7585:b0:2b4:656b:aeb0 with SMTP id
 d9443c01a7336-2b5f9f61d74mr129202335ad.35.1776823629391; Tue, 21 Apr 2026
 19:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org> <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
In-Reply-To: <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
From: Zw Tang <shicenci@gmail.com>
Date: Wed, 22 Apr 2026 10:06:58 +0800
X-Gm-Features: AQROBzCiAonjo35s67_JoyIpUPtqTCm3_6UwO3hAdG0USmTimwNrRapE995lvK0
Message-ID: <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com>
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
To: "David Hildenbrand (Arm)" <david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2919140005
X-Stat-Signature: 8ihqh4wrxwabu7paj6ejdj9zxrap4p77
X-Rspam-User: 
X-HE-Tag: 1776823630-957625
X-HE-Meta: U2FsdGVkX19J9/imc0qadOUAJyY/6cJ6JhbShRgmv4mT5PuPzxf/TTYDkefHfg5O7pOTeyT7xNxX+UL4TOnbAUEA/Gaj3+AyA9AJeUj81oNZOwc+RYK/rv70FXGHJfp1ZcO5ZMStuuEIVkh6+McOCelRgcSRZIGUEUx43Me5pVx2AgOsabYjW4X/N2kJODDkJrLIZhbKCjcTfLf0bhXyDxG8Z1XcVRi02fmFY4towyxun2F9v8XvtD8sLvjxblRTdbE8aCc3qB8yIZrMiFE2HIP52q/kVH7gvlsG9pT5udTasCkVEuDEao2fls1+3kQeqvGB/Leq8fXjXW25jRPU5qrPKh5bQyKMKnQy/pxphk8kILypYTc2/pq6yWLbyUJ2RyVBiDVLlnz+BlR6QujwvPx9xFbhlzA7phoW6loINqe6em3OoOtwbp4glHTP+KmrbkSV3UD8EyPUO1oheTlMQy3BJO4gtxs9HTwby9I2xiV7uJIco6gLtXzqW2miHW/nffO9BMu7zI5z5fDGWok9KiIvuUTzPwmSVL2u2WaDhBVV5O/JlqY7/F8aUCtvsP/54gY5V3GevG0eujF7e9hf56QsvxL0ItH5uj8mz4WnCNlI3uy5EuHWJfvwbICX9y1Ru5VltY4WdV5n867mrYiJmtzATNff6iMGgsW+GzEVNDO7YVNJrIvA0fbNye2uCVPEV4SOgGrUdKDd0TQB4m9aRLTlWJVzgPyaGgwnrsMWb8CwxATyu3lJ8ADR8GoYJTAjoa8rwlXa7K+j8ZOVXKbPjmSqQ/QHGnZPvDZWJcd2+rS1vW0AyEPXEyAC517CM6oPYyNCnd6cvphMyMCPv1kw/lKs9cT4eJrLzkCTTIdpxQcf/Lw1pSoWSAwY//8s04NDb/yW03mg3wkJfwi4uSI5m9+9qHxdlSBvn2Kk6Y0z4Eqk3cnlB+W4tXBL3S7JQA8IeraSAzEfx1KpLdSy1mA
 vddE8zGo
 T0EuZe8cgJnig8wj5SUcwILtlPALOCwie8l6yUBEM8b2nFNPxfR23AtKL8shfUjRsaDcd1tTh7x2aC3ccDvtKL52SUt1QfuViIlwkiFUa8rrT0QLmjNWpbOIoeYYUO/kz1imbe4mhsfBLUOFPhZXRIZLFvhxWIA3nzJm2g0UYoBw36+pDOkgJYTlCMCWszI/YMmW3tuss0DX8hC0F9nZzRiSKRODlJW9gLHIkWqBpiF1Rx/P0UQg2OrEc8WuZq+UcDnfzbGVkaSOCAqCHloMcJUuPPVc+gLamkM/qQPke7TndCcpLPakdy0g7DOaAzIzRSLuc+EfsGsAUP5lAfIIQuhGucOMl9S5U2EoAPo+zu0/PMSoVtx7jHqq+JaS1fkV3Ni3+/Mje2j99uy6pOv7N0GnRLLGqSid7E01D/mZIbLLlnYGU6Dhh/983MnITRc2cUYjTs0VZNSq+CVViAQTjjt+BgLBVuRxALxcXKgR4OSJzEkNa5rrLTbebRuz8dOXnQkEDuuH0vNTMuy4s0XRccwfsKxUGGvhE91S5ot3sYgWb5LsPjEmv6PWQW1ldLV6fyVgpDgvOv8NsK5OfYwhdOdqUrYGIjtmkkHp2ci/9/MFsoEr9Mq2aXWzVm0M4hI7WkaUFLEez7X1Ya6jTsYLxWQkbUto5mb80vrmre8DqPrsuzIuZqSbtFsRL/Lo6r252gD+QuLQJVc9Z0CT3jmmPJKq1QOTU7Te5ZZnk1lEzOYLQya/QocdKPIxQF0RmzD6FM6Vf6g+nZYbaUUgKTaqppZ0fXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for pointing this out.

You are right. The commit id I sent was incorrect. I mistakenly used the
git describe-style suffix g1d51b370a0f8, but the actual git commit is:

1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2

The short commit id is:

1d51b370a0f8

Sorry for the confusion.

I am also re-checking whether the kernel image was built from a clean tree
and whether there were any local modifications when the crash was reproduce=
d,
so that the reported source line numbers match the exact build.

Thanks.

Zw Tang <shicenci@gmail.com> =E4=BA=8E2026=E5=B9=B44=E6=9C=8822=E6=97=A5=E5=
=91=A8=E4=B8=89 10:06=E5=86=99=E9=81=93=EF=BC=9A
>
>
> ________________________________
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Tang Zw <shicenci@gmail.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2026=E5=B9=B44=E6=9C=8822=E6=97=A5 =
10:03
> =E6=94=B6=E4=BB=B6=E4=BA=BA: David Hildenbrand (Arm) <david@kernel.org>; =
linux-mm@kvack.org <linux-mm@kvack.org>; akpm@linux-foundation.org <akpm@li=
nux-foundation.org>; hannes@cmpxchg.org <hannes@cmpxchg.org>
> =E6=8A=84=E9=80=81: kvm@vger.kernel.org <kvm@vger.kernel.org>; linux-kern=
el@vger.kernel.org <linux-kernel@vger.kernel.org>; pbonzini@redhat.com <pbo=
nzini@redhat.com>; seanjc@google.com <seanjc@google.com>
> =E4=B8=BB=E9=A2=98: =E5=9B=9E=E5=A4=8D: [BUG] WARNING in workingset_activ=
ation triggered by KVM page fault path on Linux 7.0.0-08391-g1d51b370a0f8
>
> Hi David,
> Thanks for pointing this out.
> You are right. The commit id I sent was incorrect. I mistakenly used the
> git describe-style suffix g1d51b370a0f8, but the actual git commit is:
> 1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
> The short commit id is:
> 1d51b370a0f8
> Sorry for the confusion.
> I am also re-checking whether the kernel image was built from a clean tre=
e
> and whether there were any local modifications when the crash was reprodu=
ced,
> so that the reported source line numbers match the exact build.
> Thanks.
>
> ________________________________
> =E5=8F=91=E4=BB=B6=E4=BA=BA: David Hildenbrand (Arm) <david@kernel.org>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2026=E5=B9=B44=E6=9C=8821=E6=97=A5 =
22:06
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Zw Tang <shicenci@gmail.com>; linux-mm@kvack=
.org <linux-mm@kvack.org>; akpm@linux-foundation.org <akpm@linux-foundation=
.org>; hannes@cmpxchg.org <hannes@cmpxchg.org>
> =E6=8A=84=E9=80=81: kvm@vger.kernel.org <kvm@vger.kernel.org>; linux-kern=
el@vger.kernel.org <linux-kernel@vger.kernel.org>; pbonzini@redhat.com <pbo=
nzini@redhat.com>; seanjc@google.com <seanjc@google.com>
> =E4=B8=BB=E9=A2=98: Re: [BUG] WARNING in workingset_activation triggered =
by KVM page fault path on Linux 7.0.0-08391-g1d51b370a0f8
>
> On 4/21/26 13:17, Zw Tang wrote:
> > Hi,
> >
> > I am reporting a WARNING in workingset_activation() triggered by a
> > syzkaller C reproducer on Linux 7.0.0-08391-g1d51b370a0f8.
>
> g1d51b370a0f8 is not a known git commit id.
>
> Do you have an upstream git commit where the line number
> include/linux/memcontrol.h:381 makes sense?
>
>
> --
> Cheers,
>
> David

