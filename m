Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE42CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 22:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEAA6B0008; Sun, 30 Nov 2025 17:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77FAA6B000A; Sun, 30 Nov 2025 17:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6960E6B000C; Sun, 30 Nov 2025 17:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6046B0008
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:16:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF85A13C336
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:16:35 +0000 (UTC)
X-FDA: 84168683550.25.9C50D54
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D23980005
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:16:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=M4ZLyZXB;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764540993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcRycMVHU0Hww8GJa0solfhWtGZ+LWi9BgBVF9tAJWs=;
	b=YHkXouPjee/U7U7Jxl+OXQvFSNyJISNq/Sa1qm+s15UnkazvemfbSsgrFfsX8IO/ovYBTJ
	JH+x09XxlyXneT5n+JeY6TbReYGyQFmBhl7JNAyAzR48uZJMkpeU0sYQ5RG2X9Gvy/Okb0
	JcmaTL/yKdJ45whZmC30/bLtWXglnM4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=M4ZLyZXB;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764540993; a=rsa-sha256;
	cv=none;
	b=oOxFdkrM87JQ1cfSiTNh/30qFwWP+IvrJtVp4AZ9ToZrJX3ZhA4VqtQGrW4xrNwLJsiV+D
	RGhI4m0tOXZtBjkZXcZSjBqqEZZ9Kn815P6WXzbST4u2H5w2geMY/dicL6dLSShFrUlEUk
	4oZL8LavWxzG12cn9HQy+FGDOxm7Q9E=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso1047433a12.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 14:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764540991; x=1765145791; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OcRycMVHU0Hww8GJa0solfhWtGZ+LWi9BgBVF9tAJWs=;
        b=M4ZLyZXBr74qArr9CzqcmTH8iFdN0e6qrBgG9dlgD6n/0bWDoF62Yn1EZf40sSfqTJ
         PdlOSZ/IalNkbYAwv7Uja3GuO6Zo/3Ia8XPTGcskuZ8mNEthZCLbK8Kw/slo7GbgaZxm
         dqPxyRljOJ2XGRuPrAejUgTz0GTG1sp0IGnkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764540991; x=1765145791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcRycMVHU0Hww8GJa0solfhWtGZ+LWi9BgBVF9tAJWs=;
        b=d6Mk5kjZLdng60GqE+pA29/RIpwcR3oZrqi91vhNfd5/jdcJaik6KcVvyDA/tG4WO8
         /XxzqDyo3KhN+tIpSCr7aIVjOi09QSvAfE7J6MsQgVzna5oXL6k2agtQ2tU48YpktLB+
         Ui/V55ELKFpGKI/fmvYv1hhcJZc7Jjin29M9BLPBhK2er607UPxQLeGguHnJsy4IXBdK
         cSXWyN4w7MVqZ78b808kmDrCv1aH0yazyFqGddgYLOZsMsbYWyKuUGIQv1fsrU6uIRG1
         7xvZyvNWtl63JCQh+DhquT+4s51slzkR9QeDcQ4mKTUQj0ta7RcUvMvoMjQBw6vHOaq8
         tnkg==
X-Forwarded-Encrypted: i=1; AJvYcCVmBey3ZlnctjzSxRAZPR+DbX8SP6GdFNez0CGaZxRrl6Z0SWVEi2C9KmqY/PPXLnjyIg1xY/QYRA==@kvack.org
X-Gm-Message-State: AOJu0YyNmoR31f7idoAyyWxjhdPv02g6ecrgTm1hl/BDNtV+euX+6v7z
	NNkOa1XGbEdrGoS+9IJPq1SImMKVYEIJODhHztQpgcQYFzHMjP3wEYBaf31oLpQjskt61BqLEMo
	1kIHSpZU=
X-Gm-Gg: ASbGncv5QBHlpkeX7lPwN+k5aumKTS16DWy1NitvDbHPU9MRUeKiE/IQPVojZoeKEuW
	ycKE78EyOG2AFRIgRDtFzXwXK7Xcf5aubJChYdmoFUZ9Pnk+6VFjh6Bi2Gc78cPC1zumJEUly4Q
	cS4qEestO290BXC9nO2AgxCbLHmI1BunhjGd0di/ye64SiCGIDaWOSnMbyd9oRHkoUaaWJ764T9
	zVRhd7usseXg+04+4rlylCnZ9McISJ9UdcX97kvfkWuAxhL7GNmPUaMN9hPzHWsLlpx412apgUI
	AebiFNMxJQiNrCqZ/AN29X27uWCKa/XYjEAXCIV7NmpEzkNsMXwQRNbXnn7qcV564ACvfRke8Tn
	7G5pR+fLgvJ5usjBy1BX8FplpM9Tsk+Y9afeobasQDSY2txnUfr08o7H+Xsc5QWUuTHiNMi+IoY
	i+w7IwSYp2G/DoTb/jU2LFXR6AKP8V+ju/ZZVBnH6LQesO4snN49gS9eGROMI7
X-Google-Smtp-Source: AGHT+IGSRzXdHay5Cf/Sew/EMDYVzKPABzkLVeNxtNYK7aXV8ase2nxoROeu/V98LQCC2vBVEjNjvA==
X-Received: by 2002:a05:6402:2746:b0:640:9bb0:a059 with SMTP id 4fb4d7f45d1cf-645550b62e1mr38184917a12.10.1764540991324;
        Sun, 30 Nov 2025 14:16:31 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062081sm10555375a12.34.2025.11.30.14.16.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 14:16:30 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso6805554a12.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 14:16:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWqU72R2H8US6O0s4KYbHq5iSzO8B4D7P186WuMLxR+kG7vvbiyhHd0lpr/5hedoXTGKL3T3DDB8g==@kvack.org
X-Received: by 2002:a05:6402:42c7:b0:640:b07c:5704 with SMTP id
 4fb4d7f45d1cf-645550f2186mr35236789a12.15.1764540989792; Sun, 30 Nov 2025
 14:16:29 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV> <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV> <20251130030146.GN3538@ZenIV>
In-Reply-To: <20251130030146.GN3538@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Nov 2025 14:16:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjhgYWmSA0zyXxWr+5T5y_aLWkZLXj0i+xyhVz0Q4jL7Q@mail.gmail.com>
X-Gm-Features: AWmQ_bmTUCdJWcv7cINUl1_LNv_Km0lC6yoktUJAc05I0M6Vkfdd5_maAqPfL2E
Message-ID: <CAHk-=wjhgYWmSA0zyXxWr+5T5y_aLWkZLXj0i+xyhVz0Q4jL7Q@mail.gmail.com>
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dcupb3qhomhde7oni9droq7e1jqtxw9f
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D23980005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764540993-703392
X-HE-Meta: U2FsdGVkX18hf0I/U7FDqW7aCLvDcDHbxSwfODIkxH8UFLcPsEmWCoHnAhLjCq8HcOCf+1trY/pEB7gviw2wIRBDQ3nFRlYCREc2p/0n1RaXrMXETQTCZCc1bOWGD6dSiAXQsNs1FR9pAyxaRSoWfT/4mGXwNwQgX3WgkDBXfHBGBMXB3teFlgK0NbOTGVcO79jHQ6BEJz0NObFeCG3y7zytqanJ/km7x9FHqpIkhghTkcALoXcPfjH5hFnfosf8S0jOQ1x+2u19Ap2VskqtUSVL+kXzDP+19heNSOYfU8ayAbbnEwMYWCnECGpsMu9QKa2f9aEblofoYogPsjuUxE6XLn7t6QEFkEELvmmqcsCVsTZ0ZsoWtY8g2K+W4XWbfU+ckYu4jXuR1XRN/NcwAhcANGaaHTMv6+bkRsqoxCoxZWO2dfnHD6tAkk9GQmDCKpuOFmY4D200jEXRrB5mlgg8krjMe+g9xAbNAdZPRp0r76YVgfLo/mYcjgu9KiFM7uiqGN2nAoQfHwKjbrf6MpkOrsbtvEqTkINWJ8NKAyfK21C+zbGGlUrZLBGez2pZUI76Hg9wYHO9FPC9v5oz0F8rUP8VRvvRmFDryhaPQZcj+xMwCY9+zp63PYiFKtEvkMhFHgFgCdc+9ff8VJUyls5AdkqojXJvoh4oDwlAKLsXycS+WGqxbwqJKDUBQzim6TahzPp8B83JiivB9BjQo1iCsKdmvYGT3oTw5Irr3fEYxOxsFh1jI89AhCvqGgmlHEmO1Eap9WwXVop5ycqUsgnt/4Z4n7cvIYMbbDeCNzGvS6wy7beLbMqAQmxrnhof++5DLH5ByXilv9CfUT2milqvGdvAcTRQMEGfCnaj8Dufa9pzHFdOwNr4gINgyERzQkRF5VfY2z9ni78FElmb7Yk/I9aMxNbxngDyknyVJy9DdXX2FDzWVxmGtaOEVKKueFexoNdGcvsdhj10W2/
 qQ/t51as
 R1dbeXJOVmAdK7w5bBtIpdJ2jyVASDs5QPoguw5yM3uLpZejUoCDwn2Qr+xiwm01HWklmo3LdKi1vVh6cF876yUbYzqc2e/NQVOwa4Vo++mAQiTJUFjbNVM/ZYLg0WKVF58N7Te3c/o/CHIw/IDKe6lj1LF4kcJgEZk5+zX3glcoICvWvJCF0pSmlgGSCQaLyc8y+VOYPVfolqdZTNh4OaYWKFeS6dHk2fjVmCFeSgYFulLYB7lnHpy1UquUBaRQ3UEnfKTzoL2//lgUGa+DCULTIChWiX47PXgij7MsapSCzfc0+NsPVUbF4tP5VsGlvwfOah5lmCqkazvRi+cL4Irqjri5qa+npqpVzEiBE2VSl0s2tlAGXMsR0gfawkk0yyE5Ts9bvsgLF97sZ/JnovzdCqzyJdqbGZMRsWU9hdWJ5S1W5AUtb+WZKiJlU14fF9C98f3CTt8rmZ2ECkTkd6Zpl7VmEXLZiMbKUeob2/fceC23wRHcmd8DdRYS90pQ5diWZ3JVz9DekQ2tNVRnJHYt1ynqWUmWTKQChXIXCk+xWlFLNesWlb9D6tRhXD7aqAN/SnVSrLZnJ/X3bSZ0yl12/4DSJbeT8Nbdx3kDJqN+VUigyCuzs1gU205xaW5lwMNCjdtKJ7ov9WJkNx7KvFYvuswkDI0Ayyr18RE5Wj1ZGAWwQNPNwMA3nH5qZqArlEhdpngU1XpNzc/SfN544+WxovD2AEeazBBeP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 at 19:01, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> +         Default is 8Gb total and under normal circumstances, this is so
> +         far and above what is needed as to be laughable.  However, there are
> +         certain applications (such as benchmark-grade in-kernel web serving)
> +         that can make use of as much vmalloc space as is available.

I wonder if we even need the config variable?

Because this reads like the whole feature exists due to the old 'tux'
web server thing (from the early 2000's - long long gone, never merged
upstream).

So I'm not sure there are any actual real use-cases for tons of
vmalloc space on alpha.

Anyway, I see no real objections to the patch, only a "maybe it could
be cut down even more".

                Linus

