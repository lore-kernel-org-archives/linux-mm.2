Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0E2C87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EAF8E0006; Sat, 16 Aug 2025 00:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFA16B015C; Sat, 16 Aug 2025 00:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5128E0006; Sat, 16 Aug 2025 00:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE0C6B015B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:50:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0EDD82FF1
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:50:20 +0000 (UTC)
X-FDA: 83781394200.09.7A22578
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22022140004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:50:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5fZAR9T;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755319819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNvSs17H30Pojr0mYh58UbN4qSdGEsmKv1b+WURr28o=;
	b=RbxXNoqwj7hURGek+UvPNKEFN0ZyU2gycR04CUnkKUV6rgjkwfPL0+aQKCSO7fm+SpNM6m
	CJdtrPooTJxaAx/nog6RbDX/NSuo+cAz000T4kM9qQevFAempJ871bg9OpChl7tZJyMQaS
	1fsTx3U9Zsu7f5Dy4Kn9vOjQohdsfZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755319819; a=rsa-sha256;
	cv=none;
	b=bkLtWVDgzGvOqyIRRbSAy92NjS3nIxxBPWmsuj7U+jqcObfK/XpMg/3N9QS7PK8aJfepWi
	oyddz20D4Fwr0qVqKbuzk2yygFhEkwfAuNESQi+7OTL4R9cbexETNX+KCauMi6/wbARjbn
	FNXiGweOus7AHO/HymdrUK7MEiPgZiM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5fZAR9T;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso2318772f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755319817; x=1755924617; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNvSs17H30Pojr0mYh58UbN4qSdGEsmKv1b+WURr28o=;
        b=T5fZAR9TWka81peHd6gUcGerDJbtKQLMfsVrsxQ5V0rOKU21aIMbWLJu25knsM2Zdg
         ZCPOHB82UquSN6lB2AwkUZLAX/gp0V1PGYr0LIM0UWCrLn36zpGdAfe9d4ajxjTBqcFw
         orFhu535TCg0D++WYAzR/TBinr7GFQezs5mK8taAA7FdzOMlaPskJPJ7CjQwGaSCb26Q
         XFdl0uwMmNLyeih//eihWBo7RprqQ8xizN/ltPdZVUg2wWRTdrGWYgOP3uxNHO3jGIQ7
         kgOI2NjimALN6RRWA8goBSeyrQcbONIfkc8HaxK9O+kcgPtYnSHMYsnsccKXIwgyIlpQ
         PupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755319817; x=1755924617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNvSs17H30Pojr0mYh58UbN4qSdGEsmKv1b+WURr28o=;
        b=NIYOBlgD5aNJFzbhy2mx6IstYuxpx5nJiBuNneozSLqcXnHzNTsWeUKH73LgSi5DrL
         Pm+r84ZxYJAdZnzzP4D59QR209S9p7vVcVaXC/oV+NXuAFyJ3F2wxX0kXoCXw7/Ooq+e
         VFWKPg3chjxK/pRdpxweqD2lKZoGODsIcgEsJtre/Twj9ZiLO9N+dKiiiNssijcrCvpb
         NVpx6ecOWV3LX1Yu79397ymPQy7vyOInPmIXHhsfrToo8+LvI2p+f9c/YDN5rDJLIbmZ
         r1VFhd1WyHtEl71nLESWZjzsXQat4H0K4+8rCw7c+d7n0h8qG9gO7GQshawtfwcExein
         R+/g==
X-Gm-Message-State: AOJu0Yy2MjO7XyeI1ahE/a6EV9KtKB02wE3kyNxmFphrdH5F2XN+OzCs
	HWvojwKYvlVpG3Djqc4PVKzMLkmu4Qp+W/D3q5Ld4OJhLJKo5T7vTYfcGRPvviNShF1S6oCqsF/
	hv0xyq0rLTWNRey1wAT6viueV5RegkHg=
X-Gm-Gg: ASbGncsbRS5rbUl5jVUUTZfSG3oX0uV+1DV63Mit33zGDmfJDzFAYkQgX18fGpoYsG2
	jmQ8peBZ7yixEgKkY2CKzpaIYv0J/4Rg+P7R6EdnBvZ58+OO6yoLWBK3LI+2Oe2b0KFYzv5tfcK
	XnPnpHgMA8yES1jKdJiMyFNhC7hMrX++AfRLxpkI4FeLJDFe+wiIgN5vzdcepvNwdf9wyxDLvya
	kHiNIpZ
X-Google-Smtp-Source: AGHT+IFPvY8ec5Jn5OTlpsBfvFYtAsonj3tCEjtnK0os5EQlDMqmiyj8gQxFAf5K2RSyQc73thlVSiKnZ0ALE9aWQug=
X-Received: by 2002:a05:6000:200e:b0:3b7:735f:25c9 with SMTP id
 ffacd0b85a97d-3bb67100411mr3698495f8f.21.1755319817249; Fri, 15 Aug 2025
 21:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250812124941.69508-1-bhe@redhat.com> <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
 <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
 <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv> <CA+fCnZfv9sbHuRVy8G9QdbKaaeO-Vguf7b2Atc5WXEs+uJx0YQ@mail.gmail.com>
 <aJ2kpEVB4Anyyo/K@MiWiFi-R3L-srv>
In-Reply-To: <aJ2kpEVB4Anyyo/K@MiWiFi-R3L-srv>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 16 Aug 2025 06:50:06 +0200
X-Gm-Features: Ac12FXxYLTsqomvoG9UG93Lotus4fuW2rcu_NxDqALVSquB40p2BNceICCGi8q4
Message-ID: <CA+fCnZcdSDEZvRSxEnogBMCFg1f-PK7PKx0KB_1SA0saY6-21g@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	elver@google.com, snovitoll@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22022140004
X-Stat-Signature: 3rnsuaaskxuptaohqxiba6frtf1uz8bb
X-Rspam-User: 
X-HE-Tag: 1755319818-709280
X-HE-Meta: U2FsdGVkX1/oOrkySLhDweH3/oR0bQZpqTLepAQGJjtV7at5BZc0fMzfT6Lx3dAGzPJdLokk1bcBH9lX7zMok21BvbSEQEw9T0f8c+jAHTybLc72L1xRLg3C4KR5n2TGG1+mBECyioe8/U2joXiFzW1IZsWO40zeOc/SgCz2Tuqdf1iAoYrVC/xY1UQtrE03as7Fj2nXn4i44PuLf1BX2d715L1PNWHCebJeF//C/LWeI6jpVCAW8v7ezKaTdMZgiBMzEu11Lpv55Eq70xBwLbA/VkNHwHqhjlqwPu/pY1EtzH6K8d6mWLFUzIU3NMIoVQTrl26ZXpdBretg1ywnHcU/WwfOO6SC+gO5yyRsH8du+O8lCLY8Lqvio9MB/M0z57kCnZ+uonExR2KlAouQT2Je/v3tc6Vo0LyDZhppGVVYyXMZvXDjJNZJGlV/8toWPTDb3rNkLpUymYVCWsdxZbMTXQb9vWY12OrnDxaX30dJHV+tiFQb5DfPEACGzovJtsrFndsAYkYHxbjEygT093e7NTtrj64AMna79FQ0N075Iv5xzPTLY5pJqNjdUKVKsNI8IPH07Ooj/RcnIc+2C9nxRJphT3UxlwBWShOCdiUAi6CBqmGQTp3pwpVtnXUdGViRhDZlt2xCnHOr4mfN6RyJ6aie9NFvufVT3vezoJGpJMw+cClbA3x9Q44TTPZTAA9PQngn8pLvbNyQqL6p8x6RjY3TArAcpb0PVKW5oCPTXAU+H65He6tC6PuoQ9E6yn84Nu2hpifsz+3g3X+eH3xgpCajx6BQ0go/NUicROKhzhHlw5AnYHEg5G53oaGQgYo60wvic9uWFl9T4T9G1uCB88cczynlOJhtlqmCErkRi8UBh0vHrbxeUuIi30SDIzU8cKg0AgN6NQu0wfd3KCg9vBCuTqoPoLkSCzfXC2E6oTIO0VitCHSZUXVIVdFvNZBFcvYK4wHY5ibBGRE
 VpSZEnZk
 751q4Ho95dzMpGJkzzoe+6kiyH/mCimSKrXg/Gu10nqOcb4SRPk25T3RcQTxftGcJDb66mc5wkyaepW12XKsV0UJg2IkRaygjVBDbeW0dNiweNpwwHecsWWBAhv8JX8wnmkXcxGHS0JEOiyZMIVm8rbFjXDN9F2v+pKtSx8iwLJ4CGOkGFwcHsYVWLDGdGUF05x84IsdUI/rrY/jYffMZVwNn4TRjHk6BKY0kN2JVFB9zR4wdV8J3dami8y5P87U+ImFxTpS4Qn483GWJzuzVQZ3tiBfs2xDfBrlmx4C5YKS6lsHtviwOAdkaFQRM0uUT1Pbp0LJW3oGNEcruP52JU9DZH0sz0Btd97k3iTnbSOv1VOiJtv+8EW/f4vQpHc9tBIn7KFDsKDMIHSPg2UNruHnwQZhQbnbTPQ5J4xnFYipl9bZthwO42nN8L6grWVzg0VfC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:56=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Ah, I got what you mean. We probably are saying different things.
>
> In order to record memory content of a corrupted kernel, we need reserve
> a memory region during bootup of a normal kernel (usually called 1st
> kernel) via kernel parameter crashkernel=3DnMB in advance. Then load
> kernel into the crashkernel memory region, that means the region is not
> usable for 1st kernel. When 1st kernel collapsed, we stop the 1st kernel
> cpu/irq and warmly switch to the loaded kernel in the crashkernel memory
> region (usually called kdump kernel). In kdump kernel, it boots up and
> enable necessary features to read out the 1st kernel's memory content,
> we usually use user space tool like makeudmpfile to filter out unwanted
> memory content.
>
> So this patchset intends to disable KASAN to decrease the crashkernel
> meomry value because crashkernel is not usable for 1st kernel. As for
> shadow memory of 1st kernel, we need recognize it and filter it away
> in makedumpfile.

Ah, I see, thank you for the explanation!

So kdump kernel runs with the amount of RAM specified by crashkernel=3D.
And KASAN's shadow memory increases RAM usage, which means
crashkernel=3D needs to be set to a higher value for KASAN kernels. Is
my understanding of the problem correct?

