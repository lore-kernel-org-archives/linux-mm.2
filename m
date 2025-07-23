Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EFCC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082678E0026; Wed, 23 Jul 2025 10:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032818E0002; Wed, 23 Jul 2025 10:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AAB8E0026; Wed, 23 Jul 2025 10:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D68228E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:02:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83AC98072D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:02:01 +0000 (UTC)
X-FDA: 83695693242.13.DCB1A17
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 958AE100025
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:01:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=ryYYlQhZ;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753279319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nYQ1nxWVgdB6FCVcfOrCHIYHLuEY3Xl4xttYXGmsTA=;
	b=qZGkkW6GVQ3LfLeNB5+tMUZsznrf0KQ3SjBQmMmbzb5F3nmJPAs41Y94jfYEjBqnnUIjNZ
	Z1pRz8vuGnhOLP9kFt63RCJ5fc/J8rK9yThKLYZ+hr0IpqJ+R6Id9iYqf0hDxDl8smhgGg
	BzLW427UCs3j4hofhnB14trdF6jZpso=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=ryYYlQhZ;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753279319; a=rsa-sha256;
	cv=none;
	b=Vnocw9twdLSTAmpEwHJsCIYJTHvdts+Cr43rTAQDpVKBnMOz0eJ8jdVSVLxzb6BXq8seQo
	bQ2DRmyUWBl7hKRvKj6ssdh3TEfGw7+ECQvfjHNRpW4NgkkLCduNlFge+hcbd5tE4ccmaH
	Ji21gQgLM/eRGPHsTFO/HRbX6itTpTA=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-700fee04941so64062746d6.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753279319; x=1753884119; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nYQ1nxWVgdB6FCVcfOrCHIYHLuEY3Xl4xttYXGmsTA=;
        b=ryYYlQhZt3m8b3YisLtoBmlY33gTFJhGlMwNyejfMUJ5yF+v4t6X8LkGGzqkMhPLAv
         zbMZzOzc21FInpO0CkID2YQHaUVxkKjADBgXlP+geONCPZ+9NEs4C6x3KaTCRrv0atEv
         Zl+hM1z3oO67e/yNGKjBwZuH2otKHHVGUfB2C6lS2PzVioj1VNswsZw/Y6mDaWSFFNUQ
         NNi2+AMhe3TwGZmFxm3gQbs6aafRp6xhvvFPlroVB8IrLxE/YBP6U3WeqlAMRhHdue2l
         NcA+w3wPIultSTaHvav+LRymwZ7l4Oufrh9v/Q/y4k0qsdgUcRfHygpxpV7h+lPm6dFr
         YQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279319; x=1753884119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9nYQ1nxWVgdB6FCVcfOrCHIYHLuEY3Xl4xttYXGmsTA=;
        b=qloWHZCef4sYeTtKjVbJ8IidzMAQDo1P7h2S13pxV9SYtinJnlMCPBe12eOKoJC8YZ
         Ulji9jfEixvqnpDYt85/mje4dL8MkYTYopOxHr2IdfyMQZpTjvgbU3koEH5wmhZ3YgDq
         cliWgkskoCxZnNU6MPLBzC535geQXb/g1s4db7YPjM/IuQ4F+nXM7rESgO27BkXRti48
         hP234aJuB3x+6/HeIYh4/h0Z2T1TLz3KMfEjUqZ+jDNphuIk3dnbiAyf1TcTrxCDk+5J
         M6zfwrvxYKp+P6BbFAnEzwrJXblyaPlycBuoKcZzisCQ9fpMu/e/no55GGFEHtiBp2DI
         GJUw==
X-Forwarded-Encrypted: i=1; AJvYcCVSXHOEotk3zSqvvQ+vDwi5sXcU5yTM8Mz1s4bv1bRpPnImy7+V7RS+ikCoiXw4/+Sv+WNnf97kew==@kvack.org
X-Gm-Message-State: AOJu0YxWPcvY/aU7KJVjZ1QqbG2RCLETWuTDrAULgSzIj2seeFiU2Knc
	eu+fo+kjy9lXYlNmovFsJydGwERnQS5RBx/grO8xC0Pl5qWWpWK1P+a6M10W6aM4/9rBrQbQjon
	Ld6BTzmpbNLivUZo5bgAtSgroAVc4Fh6+Dbr+SbIegOItXGACSpgQ38I=
X-Gm-Gg: ASbGncsqIWN+//vfg0YyFI8HgXbMGYRNCAVyDB0gDnGZ2GGwQ0jrH/KmQBI7gAfnmqh
	1P2FZF/5oIui02v/r09ZreOyI3a3K+VCLJthkyKttpaFPbzKaD4pz7jRn7JTg001uPDnQDX0OTH
	Dnfh68+6h65uaQdq+Oeo2qaSWjQe8p95d6WBejgkqB7oEvPtdQZ5O03AhIcYoDAAG5BzSLXWXHF
	A84
X-Google-Smtp-Source: AGHT+IHnUuhdrD9l7/UqXUCaUGkjpnut9RPkUhkRsYy8dMo95ULrH9zUrOnS3/mgiyGB2gnOI0df5GH4vloe3EzyqoM=
X-Received: by 2002:a05:622a:13:b0:4ab:65c3:37d5 with SMTP id
 d75a77b69052e-4ae6e009e59mr39018621cf.27.1753278827759; Wed, 23 Jul 2025
 06:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250625231838.1897085-1-pasha.tatashin@soleen.com>
 <20250625231838.1897085-18-pasha.tatashin@soleen.com> <d6e44430-ec9c-4d77-a00b-15e97ab9beab@infradead.org>
In-Reply-To: <d6e44430-ec9c-4d77-a00b-15e97ab9beab@infradead.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 23 Jul 2025 13:53:11 +0000
X-Gm-Features: Ac12FXycG_A7VpBGI0ZPxdi4OoC_3NChOWXSX3JfSNxhPZyJt2s_1oWRajx-S3I
Message-ID: <CA+CK2bCpY3xnPeEyWCRYVpRcs3maKMqZnApQtm5upkwmM80a3g@mail.gmail.com>
Subject: Re: [PATCH v1 17/32] liveupdate: luo_sysfs: add sysfs state monitoring
To: Randy Dunlap <rdunlap@infradead.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, ilpo.jarvinen@linux.intel.com, 
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com, 
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nfgs7i7kzi94hmjpc71kd4wh1we99e15
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 958AE100025
X-Rspam-User: 
X-HE-Tag: 1753279319-424157
X-HE-Meta: U2FsdGVkX1/Xp7Nxptx49FgJOGh67fTYjCq6EoaiYJisizslr3cemVexMdISYvr9/0IU457l2/OBn1dqJrNoJnlRQX/u2PsZ3rDBl9JoevcOnhahd8NkXvqh6A3722tehslbBmNheJCO3uQh4cV+Iajy4sDX52G6P0VZXTxsNAymN/69KjyT06fpgG1e0NvFfStRAhb4mTKDheUR79HzbKQ6p8qRcollG1PWSuAqTF5G1UrvpF9ypAjFvHa8gC8E8EXhjGy2B/O/gHIwkYTyOExZZiREZ21NGASGNu2bd4VkeIUuAmjJjY+ee/+Z7QJljGxZdN+EAkr8n1BupSwPE3MwrWrx1AyomyH4e4nH+lkC1C0Fr23NMwOW36ZI50mB+r6VNAgKydKAVW+K9ZBFSBefNH7+hzSAFBV6kJLjkdDqgG1Zzo/7DQfw9RiJmb9JDYYlGF2FCjINcGG4zW78bVojIVdycwXYmyylUsOmrfOGdv3X96OAJySP7HfPznsD0D9yUkAbkucvi1ZeGkyF86KIHey6DwN5ovloFMkVK82U7QFiSdmemEhgEop5nTygULTNye19FvzFiuoa+W2VfHSMMS+ttyqbUcQz8oCSYmt6qQQck5kzNMdEaC9ldZ/XK/96PGKzZhjHajFAQalfOl5ehH+lQW7OIxdjnSklUqOMRaI895w4iiPN/Xl94oUZxhXpR2z6CBc0LhX5AQZM7BuUJbmOIUZqepnCr08xqp6Xy5o03gmWvZBwYJ7JpkIHkoDz5E+K+VxM5FeotOmzKFVqkM7+EKHCwa2TZ+aMKvFZbYvddQItmK3DSXLkV/9yC7M9htkuowi78vQKd3mK2m47Vh9/KS117qQ4wcKntFaap7mBp6py32aqGcNTUq7IMU0funCUpHkW4ueluSVPx+5MJ4Is5y5El7DqMRvIKgBsqY0xa7558VPHwHm1GLV8tCNIyaQg+d3WbmW9g7W
 S9Ps1p7t
 1spT32MhAeYLpkwtWkTwtC537U7aktO4uabBeUhWNSP2Tg1qrjnGnzjBI/I8U23K0F66ywanORmDf/oFMKrpr/jksgZMzsIp2HMOt7i/TmG3Lhj3aifEu0RZHBp1p38KSv5PK68H2sfjCe/44GXzkBv7TWduWFrUZgUtOxL1DXUhMq5+KjAIQDX4Wfi4uh/fTjCj2dVAIXigAx0NHanCQoqNZh61yVZFlPQfADQbcCTex5NvvjTqiIevq7BaAHYOV/TLiZmoM7LtskmeJB0l564xr2e1jXcb/aU0BcUsqoFKGYvfNWxT0sZNiOEK3IeX/8RoOhIiJQTMYmbeijerAN3XNr6Ex1Gtq/6lBXbO3R074jBNcZIrTd7CRFBHg5fG03XJYbSiSkvkjeLqjEkV0eOZnNd1AL0qA65yBSeFIZF7qZrY5KxebBBdDGi/yFZOj8zBhhQzB4YV1d0h6nJDy3YLGFHv6OXQnCxHXwScnvNBtuMfgaSLcL+t60THbu7dxXHriM6VGHEhGKpMtRr78ydqjb+82zs12E0tVfATTa3Xp/rM4O2aFfs9/Tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 26, 2025 at 12:29=E2=80=AFAM Randy Dunlap <rdunlap@infradead.or=
g> wrote:
>
> Hi,
>
>
> On 6/25/25 4:18 PM, Pasha Tatashin wrote:
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-liveupdate b/Docume=
ntation/ABI/testing/sysfs-kernel-liveupdate
> > new file mode 100644
> > index 000000000000..4cd4a4fe2f93
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-kernel-liveupdate
> > @@ -0,0 +1,51 @@
> > +What:                /sys/kernel/liveupdate/
> > +Date:                May 2025
> > +KernelVersion:       6.16.0
> > +Contact:     pasha.tatashin@soleen.com
> > +Description: Directory containing interfaces to query the live
> > +             update orchestrator. Live update is the ability to reboot=
 the
> > +             host kernel (e.g., via kexec, without a full power cycle)=
 while
> > +             keeping specifically designated devices operational ("ali=
ve")
> > +             across the transition. After the new kernel boots, these =
devices
> > +             can be re-attached to their original workloads (e.g., vir=
tual
> > +             machines) with their state preserved. This is particularl=
y
> > +             useful, for example, for quick hypervisor updates without
> > +             terminating running virtual machines.
> > +
> > +
> > +What:                /sys/kernel/liveupdate/state
> > +Date:                May 2025
> > +KernelVersion:       6.16.0
> > +Contact:     pasha.tatashin@soleen.com
> > +Description: Read-only file that displays the current state of the liv=
e
> > +             update orchestrator as a string. Possible values are:
> > +
> > +             "normal":       No live update operation is in progress. =
This is
> > +                             the default operational state.
>
> Just an opinion, but the ':'s after each possible value aren't needed
> and just add noise.

Removed columns, thanks.

Pasha

