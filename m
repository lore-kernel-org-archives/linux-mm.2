Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A9BC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D571900079; Wed, 13 Aug 2025 09:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685A9900044; Wed, 13 Aug 2025 09:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57541900079; Wed, 13 Aug 2025 09:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8A7900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:42:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B357C56200
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:42:30 +0000 (UTC)
X-FDA: 83771848860.22.8D7EEE6
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id D158CA001A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:42:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UAFhh62E;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NX7QgU4RYkpyaIY+9NdW+KbcJXzTDUdRfjFR9v7XueI=;
	b=EmP9QZlKuPuA79CFaRm1b+dpoJ7Hd4TeRhOc9/hddCLoJYo+2mUtJzHDn9km3ZB1awJCIh
	5RyQO4vWZ0t8KWICgxBOwMc+RdY2zYBBMo36NQcNQqdoA3mUOVnsWJobukDvEtb+PMXLI+
	zTC5P7y/9a/qk0TRBtVV8D03+Fs97Nc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UAFhh62E;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092548; a=rsa-sha256;
	cv=none;
	b=mp+FoSFP13kkjnhGmuh7gCQZ+HRZ5tF4YLKLj1NfEdF38mK0x66HGWrqrReYUcy02PiwD4
	PEsdXqnUtZnVshDMvfEBhKkpwA8Q9SZHNF5KwQzwRt+dPRnkWGmK+BYZkeWU9Ys7Wp0lyx
	SNuGboKKVGeeKP2LquvkOLv6a3nqA7U=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4aeb5eb611bso65236841cf.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1755092548; x=1755697348; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NX7QgU4RYkpyaIY+9NdW+KbcJXzTDUdRfjFR9v7XueI=;
        b=UAFhh62EPRy8eLEvqcCCUV9Xp9MlVBp1+qmps4F4AwqBBkJSihmpvquGUAHObmUeFM
         /LjPz6WP9ySoD3/KNJ7VC+hhHONdVlgXn3/sjSAGf8DXobcaJMeJ+id5N83eRON0p50N
         YIrYrQdV0LQD3bHopgv75iQB2wOi+Ck9o3u9dcQpkYEaARQFUDWHgI2lxbHskLzPfsTW
         iI2MI/WCAFCmCgnHsCi89mY5X9xGNNVzyOR2wV58sTi2/DKVgphsRi/u7f4koOO49dnW
         +gOR1xl1brY2HYYpyMW84ncxQPlwT2WNUkqoLYGL2rQaPpcNFkqqkR2cTTDaJQGSqtN3
         ePUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092548; x=1755697348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NX7QgU4RYkpyaIY+9NdW+KbcJXzTDUdRfjFR9v7XueI=;
        b=NPKVGJN85wwpxd7IsMTcj9mKYk1O6jV5mGzKUh3JUct9rttJwawZuVX13Cwb2OzDIY
         PcJDApTAdrcLcSKX5aTaCikAwANkthEMQRmXRvZmsGu2Swh04I0azKh+RBFkBnetbkZC
         JaRCZNafmFl2Q1kD8KLZlUbSH7P7w5d8ciMyRJoU30LXXwGJZyVrP0u5IeW28xU4uHPF
         5HSK4FAztQoNlubvJiUJGR6k2AM4bRAUXr9ns293oVs9UXWqvsgQ8hhplgMN4bArm2hv
         jFozyyD4G3z3qs7SlcGzGDfQoDcVDFK4p+uZexjpZw+mrCa2hvtxEWdt8FxqdtBdqBWr
         o9ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWErUxtIDcexyIqetrYfbspBarSAYaB6emwXSdvbWiQKX1hce7iNYxLw5+OLsTpSw0cDf1JTElu6A==@kvack.org
X-Gm-Message-State: AOJu0YyLNmYwKtnh96RjTnAiTluIaIDbtMwtUXcPKILgRnslxcs4HkZ2
	KdcJisfjG4N844cQ79Nmji7CxCsywQFCGIbMv/qUgeggUo0V5/SmL9pBWDIldpnARCvH1axgyik
	MJC/LAhWIcoUVJzrGWBpj061/VA5DqdzrjVgAhJ9/lQ==
X-Gm-Gg: ASbGncsKcXu/FEvY7MbEXi208HJWuo5J4VE3UL/olhohW2F6eXmjwxafiGhpv6J4dk5
	ZT+Gz/uvRCGCQADxJ1kApcVPQ+S1Fa19khmasmUcGimp6LeNDfJQlTvDRyHKTdFlKmJzsnczXGK
	C6OaSpEZ1C1V6DrHRLgMrDYmfYmY/voKcQ5WwFQnpxAnM8n/11oGtsjoSEV/t9j4ae1b/LhroQp
	VNh
X-Google-Smtp-Source: AGHT+IGLfaaQwFEY+EAD7Oyb3ssHwz9Mxecc5gc1KtJUOKANujOZKp0yfy7BpGqxCbIGhcOB/MMwQSa7HBfsw+eWd5U=
X-Received: by 2002:a05:622a:1f09:b0:4b0:86b4:2513 with SMTP id
 d75a77b69052e-4b0fc70ed8fmr45524721cf.26.1755092547727; Wed, 13 Aug 2025
 06:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh> <mafs01ppfxwe8.fsf@kernel.org>
 <2025081351-tinsel-sprinkler-af77@gregkh> <20250813124140.GA699432@nvidia.com>
 <2025081334-rotten-visible-517a@gregkh> <mafs07bz7wdfk.fsf@kernel.org>
In-Reply-To: <mafs07bz7wdfk.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 13 Aug 2025 13:41:51 +0000
X-Gm-Features: Ac12FXxwYgoxAEMomw-_iEhgQJ-Al-xyM3lcJTz2IeukxaEHZZmWI0qPQ6BAJJ8
Message-ID: <CA+CK2bDs9prKNSo=Ris-L7T43ZFU7ji3cBH3KD1=FxXg7hFbFA@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Vipin Sharma <vipinsh@google.com>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D158CA001A
X-Stat-Signature: f8a41fxx37rfupsrhdpski4g3aunh9dk
X-Rspam-User: 
X-HE-Tag: 1755092548-180589
X-HE-Meta: U2FsdGVkX1+gZ3JipjLD85xrlwWHDblRnmKTD5H3QNA1K9fjjiyhV9/3vncg35uN0Wd1+VtLUGviBL+kfOBpDRTxmHmPgbWvA0gSyFiaOWQOH8q7+khgQY9Hp6IgULJNQTlPcinV97E/OaovbUaUSSGro9pQSx8jpaBqhRV4vViBDrKPeR9uigdxiYxNYRQgDd+5eYaVKt7G85wSI4mys25eyGKa+dNaK7AnX30F2r7wtdDla2WeAgybvIaFQ7SVYLUUrd5PohVDD5vwgxC5lCL5r8Rz8xmNjN9Jukaqalyo1ZJP0oV5X4BwA7YZIb06VgmyCG/pnMyNgv9kgZ6vndRX6CVFz0MiopSSvWtd62qouoniZS6t+DwpgvUYnu76XF5QkixNrVk0lAtRvcBbFE0jARA2Yfe7I4JylTXZkxVbkDObryyfaxL4zy6p1um1iXr7YqLYz6kokWux1TfV4kLXOLVmQ6YyOdc7CwEGNToferOm79JJzvHm4Q4oVfKZQCWfzYotiGzFnkFlWsyOfXhtpFfQ/iam5c/JRfG+WTvSAkjywLPCuiEcQwXqn4kZnUOinyDxqhN2Um2YOpE0WS3y5Wlctb2G0LyU1Is7oN9LNdTjIWlyZkBlA0f89aUEwcO8wzBGyOoDCdMBpfzakYjSePe/e0icFLTmmiJhDNdIRwjAx3q6De0uptr61+vbe1u79i9u9qibE3jGksSlmhvxxLvS+LawiBFEkTFXn+jx6ooXPM9BnIBHsBpaTjsYasK+pBW/Qug5pPBERbuQc98QPCVIMiIxxBVz8s+JTHePDBCzV30uGrpIA8Aj3JWz7pPIl0PL9NCebN0kVNqRGbU0IBSn9hkCebFq0gnjqMQHtC1Mwupd5RdxvIG0eJwVZtIyOQD/iolwZ7wPsZ0OQrHuWGPlptmNU+w79QTe2dBLfOtA1FrI0Y4+wYRbD83c2MGr6lQlN2uRx26gEoj
 T8YhwGaE
 +78tm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 1:37=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Wed, Aug 13 2025, Greg KH wrote:
>
> > On Wed, Aug 13, 2025 at 09:41:40AM -0300, Jason Gunthorpe wrote:
> [...]
> >> Use the warn ons. Make sure they can't be triggered by userspace. Use
> >> them to detect corruption/malfunction in the kernel.
> >>
> >> In this case if kho_unpreserve_folio() fails in this call chain it
> >> means some error unwind is wrongly happening out of sequence, and we
> >> are now forced to leak memory. Unwind is not something that userspace
> >> should be controlling, so of course we want a WARN_ON here.
> >
> > "should be" is the key here.  And it's not obvious from this patch if
> > that's true or not, which is why I mentioned it.
> >
> > I will keep bringing this up, given the HUGE number of CVEs I keep
> > assigning each week for when userspace hits WARN_ON() calls until that
> > flow starts to die out either because we don't keep adding new calls, O=
R
> > we finally fix them all.  Both would be good...
>
> Out of curiosity, why is hitting a WARN_ON() considered a vulnerability?
> I'd guess one reason is overwhelming system console which can cause a
> denial of service, but what about WARN_ON_ONCE() or WARN_RATELIMIT()?

My understanding that it is vulnerability only if it can be triggered
from userspace, otherwise it is a preferred method to give a notice
that something is very wrong.

Given the large number of machines that have panic_on_warn, a reliable
kernel crash that is triggered from userspace is a vulnerability(?).

Pasha

>
> --
> Regards,
> Pratyush Yadav

