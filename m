Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DDBD0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 19:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88526B00A5; Tue, 25 Nov 2025 14:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A126C6B00A6; Tue, 25 Nov 2025 14:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9186B00B1; Tue, 25 Nov 2025 14:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3436B00A5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:01:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A872B9547
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:01:53 +0000 (UTC)
X-FDA: 84150048906.02.B7CD536
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B54980002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:01:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A4hmAZ+B;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764097311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+cab5OoFiSAnh0Rr1KkIMrwuY0x0IPZJPyGZAN91W0=;
	b=rqQ1iKH9rgXK/Nu3hMiG1YYy9+g29QCmrcvG0NA68BOMviB6DhOQw/ISl5MCL0Nefx5EU8
	flDFbv6OYIUaaSqSOmnB3M3rO8B6t4vq2dWDayIHiWMc+M1T49kJyHNRxb9Z8tVl4cLH2k
	S7WiC3Yc+dtpt1m19WWSgzmnpEeFayw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764097311; a=rsa-sha256;
	cv=none;
	b=FcUEcnn/l0u9xv9lZG3600KN6jDVtlVoT0A1iqjfb7BJ5MUuQrUn9TrYA4OJbx3J+65LIC
	0MKh7IZEQuKk+E9Q9TGcVynPf0cbeiZfYI19LT2W8zk+CGddqQyi2cV9YSctPlVVGKLte2
	vJiOTg994WNGsP5Hl13GMMNwuaLYjQU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A4hmAZ+B;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso10144955a12.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764097309; x=1764702109; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+cab5OoFiSAnh0Rr1KkIMrwuY0x0IPZJPyGZAN91W0=;
        b=A4hmAZ+BZRmx6yglKDnyWo55ukJ7RsYL+uwe7JIC1u8v7WzRRqvtHBb9IPC2A330/h
         W+U0OCjaVXT7A7MA6PZaaCH4Z+PPGzxvBu4rdt3hcHXhFBjn1f9mESi7mkT7sYHPWsh1
         bV2btJh+g+SNRYYpNsWaLxt1EcNhUnDq0rNfTB791Ju9ExuWuH2+q0sIkITdup9o+mgx
         X1QmX2URyof3KuRjSn7jFEzyKitc0XABVOzu7qQlcPfXXbeL8OghkaolcA+4iNuMVLzn
         EEYPnEaZk8E2XSPH+rMBTMOxd3wjcNFGnCeC0yi0HRchEQzURxRfE93LQWWDREqovEKG
         IcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097310; x=1764702110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c+cab5OoFiSAnh0Rr1KkIMrwuY0x0IPZJPyGZAN91W0=;
        b=Tn96PqM3C9zoLYThb3G7S3PnjSYgBBggzViInMEJhYQ0AiNij5apXJJvw4dcqzYvrh
         KiN7eSwMgTnLEs9hKI9baUhKVsWWLP2r0w81ACeBzZycRw6AkWLVwsv0QOAIFtyV6iRe
         8W4yyuOc+qdTk4u42kSNewoXL6matdYvAFjghUlFWhDB2KhFytUwYn9hlkngFhM1XFVk
         xTIiJn6GoiXuQBt8zQI7/hWaBbrRwwK5KihK9MLEx2BbySSRzz0FpVXyLASZIc8IoLEe
         07quR1vc0pYGqradaQOkXHRBXg67zz7VBp1NAf/Z/abbfciPyhBK0v2t76Nvx8UnomSz
         x8Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUEt6X+gkWQyi752YLKe19Yd3VCmrKoEwMt9jfbFvhFH8NcRwyPK1hbwBaTNDLNS5Vg4ZdFDgDtZQ==@kvack.org
X-Gm-Message-State: AOJu0Yzl4uJqVd+WVYX4YFh2n7LIb1EeKNq8L+A6wzNsb7AbR5/ITxM2
	NT3ZcOwzEhMLv7i/91ivHd9Xi66RFGp2Yq6K258XatunOI5FezVpaxPtuNXlwyC6pg5LojWweGs
	XO0ie27B1cOv6P1XPp/lD3s1T+2CB9lJV/OTNuNXC3Q==
X-Gm-Gg: ASbGnctTtKQ99RoQhnfuUXi+EKEh2Y8zLpfSriOO+YiJy5aszTrDEeIFXcROwNyae/2
	0Dpj+5gQkFCY+GPkBjQwBARHKFzox8nrKb6aiiN84TDuhMrzGvWYONDu+AZBIo8xCy2uo7BqOOJ
	IwYAVcHATECkrmqOQaTQmOUazMMpzAHr1yunYvyg12n/M/v7HRAc5PMXuzYlHOSke7TV1xTwsE5
	Q4qYwzjomj+giKhbIMHQ+y6LpckEYiG/+sGos07T6boOLJcYWdHYloTe0dfLleRDxu1
X-Google-Smtp-Source: AGHT+IE7rh2493kGukystiIbPKWb0LUwVClME9rpzIqFBySy1Ee89iOW2xWboR8KNUdfVwKxse2RLFaevMjMIITj+Qo=
X-Received: by 2002:a05:6402:5252:b0:643:4e9c:d166 with SMTP id
 4fb4d7f45d1cf-6455443ed4cmr14156611a12.8.1764097309246; Tue, 25 Nov 2025
 11:01:49 -0800 (PST)
MIME-Version: 1.0
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
 <20251125165850.3389713-3-pasha.tatashin@soleen.com> <aSX7Nm_yrXHeejQU@kernel.org>
In-Reply-To: <aSX7Nm_yrXHeejQU@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 14:01:12 -0500
X-Gm-Features: AWmQ_bn2a3c7qeqfEVEla4N9ePeEsUIzOpDhVQeyvGV93y9dTtTiY8YHmxuVAOw
Message-ID: <CA+CK2bDJ0QwbVi07A2tAohceuOur8JNp2Dut3DEZ5z4EFwXz5g@mail.gmail.com>
Subject: Re: [PATCH v8 02/18] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3B54980002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: q4mjyg37t1798qqroph936ko76myiqgt
X-HE-Tag: 1764097310-168791
X-HE-Meta: U2FsdGVkX1/5/8sETHj7GcSZNnfL8m1/eRP1WYk7vUIrkgf+Oi/TSOOKTRKgA4QVHKOsiY8nQ9xZ+Pog3X3jLS6lKHLktTVRMmtyt+JmrdbhiJA+ulXcMzoZjlVO6Xhw3MZvDSnChjDTMS79LmGLbLUx3fuJRRY5M3RzNyguhFAajoPuhWIqcWLj9+N77RAZDeUTeuAz6cegPN6e1RVLBE5suKAeGIAShQU0DhTJnoq5QxmSRWq0YhWj6XAmp2mKU3FImc3vwUNkl095PpgKttlYx9i0jpP7ODl+J3r1mivjM3mBMkEmk0PHD2iHEj2XpqNCkyRrUkxaVntgI4yfvvynjbGu42lhAwd9I1z1Ue5l7hFCb/Md8AY6USSnY38WWJ+vE1ffwJA2Gl02t4PLvYTsMdi3kMFFo+mp048VjtxXrJK4FQ2/+x6jJaLoJTxNIGinLfeb/w+DEzoCsjeE5S6M8RthFmij8phZ0+UjE1uxTNTO8xaB3nb1LR02sIghwW8tq4I/KNapMPtjYG4xKneO0IVqgHytzWfj9GEnWXoM0SUlxMrCVHBGbmdF1nXnzfTQDIAUhjIJGWSIMaAyCHbEFnmBb78ABbp8AW8exXiNd5xX7P8P9iZPszAytrU1wBP7DwtJwjV8z4Gn2zNVTWwXE2vGeQ3SAtrhcwYhxvwD4etoqjuLrdZe0PkjbmesqKoGQyU5zSiVlpKp9CxOErUhY7y+4sn+IaFHHn5BL6bcQcFO3yRb9n9JdYymW2EawDEsaO8KAy8k/HbfRHxtAMd58zp8r2U3ARNLKa/WbAd14mLqvebck7Skc9xMpSKoy8Nv3kXMAb1wiYIVyIzBAyyVs4cozHy33q4KYF0xy5etED1fVrvcAoKhEZt8bawWJq+UgKt19QKJFBvjxanvght2vcGCd2I3TavlpHKQt1WeVItuY8vsmI0MnNEM9e/ZOVj50AIM4j8OchAhTMl
 BPcJRgWj
 vxXnpMt8pvHIYVI+K2PN5Vun2eldpMNNjWnvkbBZu/4z9OzBAE22YfoQxy5G0bJKc/g06hinDBjksHbYFn/m1lO7yOADyX1LUSSRa8WJkdCD58Kw6/tZVS2d5mtcs/6q825qMkj3AG2WUi1IVuae05T6M1WOjsUQZY4WyhoyaI7aiAZCYXzey9r77oG4z7Kl2BJbqrdYADlXs+BLTJrjH+fyphjFYwJeoj96QxRc3pBQy373GyaTHA9mTD2MG4JSM9gzkQugESmScYJWnf1UwI3TdLsayr0o/8FP20kCTMW9JcMNzObAkuYNXsmJCYxDz0e+RoG3pt+kvxUxH5T+Xkk8uFPwwuz20RXB2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 1:54=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Nov 25, 2025 at 11:58:32AM -0500, Pasha Tatashin wrote:
> > Integrate the LUO with the KHO framework to enable passing LUO state
> > across a kexec reboot.
> >
> > This patch implements the lifecycle integration with KHO:
> >
> > 1. Incoming State: During early boot (`early_initcall`), LUO checks if
> >    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
> >    "luo-v1" compatibility string, and reads the `liveupdate-number` to
> >    track the update count.
> >
> > 2. Outgoing State: During late initialization (`late_initcall`), LUO
> >    allocates a new FDT for the next kernel, populates it with the basic
> >    header (compatible string and incremented update number), and
> >    registers it with KHO (`kho_add_subtree`).
> >
> > 3. Finalization: The `liveupdate_reboot()` notifier is updated to invok=
e
> >    `kho_finalize()`. This ensures that all memory segments marked for
> >    preservation are properly serialized before the kexec jump.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you!

Pasha

