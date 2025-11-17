Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E49CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B518E0007; Mon, 17 Nov 2025 13:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4035B8E0002; Mon, 17 Nov 2025 13:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318D48E0007; Mon, 17 Nov 2025 13:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD5E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:24:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDE8C139F1C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:24:29 +0000 (UTC)
X-FDA: 84120924258.05.9100DAB
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id D6DF41C0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:24:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="XVDgK/HT";
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763403868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSVaYS00Ppz/lXA0EJ/lwtUlZcIIPkWYwoyJByW18bU=;
	b=VlviLf36zbBuy4NvdB4lWKPaK6A2gUOcsWJBilsfu0myqGVAvYbnxA6sk0g8UqOSRvR9WV
	Y+LyYoNBUEH0r4Z2AB5E7z3w0wdj3fYaJr1NVfgM/DHYIKo1vNYIV4qosEwu2B70cN4TBo
	4lNAi94ffa+KxHm4RYgoHq4GzRB1xGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763403868; a=rsa-sha256;
	cv=none;
	b=bfWWi+mIcH8NDsytXeh26mBA03wB2sQYKzrB9Wz/bSlN5Le8ReSND0H1Kn/PaaA4BcgN8l
	LaVUciKlG48ZtK8KBoZaXmKF6vneFZyyYnJhF0VqNdn7dhRlVIvHEf9qjo+lxmr1qS+AlM
	lmjM2i+DdRcHLSnYjkhRpGRzWcICkNM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="XVDgK/HT";
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso7808083a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763403866; x=1764008666; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DSVaYS00Ppz/lXA0EJ/lwtUlZcIIPkWYwoyJByW18bU=;
        b=XVDgK/HTv8hHz8HpS8vQuFnoIOJCMbtjX3yb6UT9TtozJldxvI9rSobMT8w5Br0ZaO
         ZnpcqiX8XOnUqmrvUhuitQDXI53K+04QxsphdgddPlJ8M2OPkDcatvnv4SUt5EBocdAt
         rvk33QQIoPHnwLUwG8pQBMsgo1tC2smUcbQE3o/7YyHv+ved5RjQriV7kb1WhZCzU070
         YAHTE8QvxbkWHMtiJNEdA2v2mUlfNohfjho76+iyRYxKKssM7mzOgP6n5dI2mDLnob93
         HaO30KExd5ApdAkI2wgdWnuItjqmn8jn2mBJ0Wi5F3c3uZUd+jOPD7EFNCClWo75EDSO
         A16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763403866; x=1764008666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSVaYS00Ppz/lXA0EJ/lwtUlZcIIPkWYwoyJByW18bU=;
        b=f3ruyQbQftBdKRbgFmSKGAMYZjkPKt+RkjvugDgyP45cvT1Fx3h/CRtVWz4pIRWFzg
         SPsXmoCGSbGHRgBA7jKgiWbGYnCJz0SOhAKzwYkYiYVReqF5JfijEqf4wBuQA3E1uwUk
         nAiCHxT3jggl84yM82lP3MuEcHLV+bCirYR+3SEi+sdNjEHpFP31W7BEr5YxPYgIJd6s
         34HbxpAz5kSHdYjACNdgyD0VcBp/m/niZBrCcGacQhofgsB/AtujW3rP1kAiPk+Vnl/Z
         d9CO9gkrBkZSoWJsp8naYryzeE2u7F8q9u6PnaLA1DufT/hHAlByBvayd2p1LKKvoSeJ
         XiXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/9pKwYXPRaeXhFAIP1lyqsHYuOvbTnV4JEGdML7MVulX2MFqLe197+eiq7swdyXz0fC21LH1TqA==@kvack.org
X-Gm-Message-State: AOJu0YyzfgYzv2yKRkkORY5nLFzv4HchK9cLctMES/nvJ+87LuF99Kzm
	EZYCDYSUMUM7wzpTKGK5wzuxaJEayCSvjs6sXqLBq7r8USlP88jmBSboedyT9kTt4FAg4jukmx+
	tevVH0H8XAxUgZVR+yxhvZlaRQmQS3/tM6AgbGHKHoQ==
X-Gm-Gg: ASbGncvs3HXE2ehdTi3QBHJtaL2xFwx4tUAblHURSJjGekILqPwR27B0grwT3LEijej
	C4QXQ0HkPhJob84a6cO0QI//GtVoVXbua5yBNJ3hwk0LUcurirp6nIiejgsmwlCqOWoiGyiiC+Z
	pY8oEs46QsvBYUrJjyul112GMNlDC8WuvOdLkGmfjzoz3uxMGrCaP/TNDAFIRVXsZKFEDm2SWU5
	bfLBreN5XBwjCTTq1lPBxuRby+KFvqF5+TUg7Xl8UhOe7HF51v7xly3RZSObTUj/fnGCJrD+IhK
	l7E=
X-Google-Smtp-Source: AGHT+IEEWqHLyN23GdmGqxp16gOz0H99ycEtpAQL2MFddiKttxJOs0DiTjbKI+yQFgL9TB9EokEIYjSn2RJfB01X0+U=
X-Received: by 2002:a05:6402:2806:b0:643:60b6:3eed with SMTP id
 4fb4d7f45d1cf-64360b63f56mr10022358a12.31.1763403866324; Mon, 17 Nov 2025
 10:24:26 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <c8b46600-d40f-41b4-a5a3-99300ef1a2eb@linux.dev>
In-Reply-To: <c8b46600-d40f-41b4-a5a3-99300ef1a2eb@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:23:49 -0500
X-Gm-Features: AWmQ_bmhggvke7xISGqUn7uC4niyXxh61OdHqC9kU_cJS8AOY1qqJ3NjJ9HlQrw
Message-ID: <CA+CK2bCUG4BVqPJYL5nxC-Uvomx2JT=sE4DrhqFjrBf+zN_m3A@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D6DF41C0003
X-Stat-Signature: y7ssu87az1q8h54wx79jnt1hyfgjguhf
X-HE-Tag: 1763403867-154040
X-HE-Meta: U2FsdGVkX1+qgpTvqVqpUMFAzyIOw22PagCTPRI+fgHX0R0BdqKHXz2YiIE6gaTncsP7+Ohm8pH4RjzKSLRnbUP68QoOxzMJEbiQw6+kg7Y+y88fjjzAgQgqwqV8wjvwgsu4xMl4sts888JhTiSSDA6+t2VdZi4a/3XipjeYFZ/daVHICoEJh9l3ftKQSdoiqc+CMWCWIfDWiIqGCwy5gdt56ngK4QNC1RAI6zX9sRxNiUrkeYd9oHHP2gy2cqR/9n2W9h+1xX833yYI/f9vIOX7m01n8YQB3HyxTg2z6DLkPdSNf/P7xl0Z6EqG9wLSCIS+k6XHQ+iX3AsSW1c2lo/vuQ3cg1gEMFbEhb50oKz+7O7SMaNLid0emmo+zliOl3zQV9lth4wTnvbOv6+M/88Imnuz9GHPTQ6kJ2LwSgI/3xkO6F0tAWqjVpAC1gdRmuZvpsdJQInyw/10o0xoQtuwmWiEDwuGiO5FHTL+s9KCEreBReqnMrPB/15MGJfkON0cfnMX0SZI4mfBxAqctrjHxFcpJi7wZvFNiH8THgoomz8XCgOdH7drhu1vxJ3N+AMC80S5jAujCjKtDoiTCgaT4Zddr+6GbBz+Zc9TyF9GUP6JDLSG22dn71f4NeJp5wbzZ1BQlcxMEh13CiSBLngcljp2RUBt5qfxwO5JomLGQaJ60ho229tlYbAgwLuxgfLUQmzvM1ewAt50MJK+TgoD2ZEUa0SqYkZJTD22VTrKRJr1xR2SErq4AeNXcOaFc0UG8F/wEQwnmkvtr7kxnffiYUMPjTo0I40vA4ZZe68VSBX0Dn7yFNj+tFuiFdmnJQ2OXo8Cen36YAVchrqv1At18wkZn454s48vPM/B8Mfk2yLAfWS3WlFZxY2Eo/GD08psZ7KXFdOATJFDgsPzrTm4FbIMofULag0xAS+ITS2yelzsKnFeysXlS3KKcfIvOgZF3VYH7JawV3k5IHi
 RMSf94oj
 avxGc0rDoTwTIcnEWqTMVMnGMAvWRkIya7v6zM4oI+BpB+602FQ7YIxhvxeUbR9YlHiSiyGXrNcXa4AKvDJ0CQ15ixD/nMA87ODTOPNDtVnbSdd9YpUw5yryx4m6VFyzSExDE9Gfdy72LB8PtlJJC2PdRXzK5L7fsg91V9YLSamIcoqqBz1cpPmNkWl3Al+bvCdHLLGQ4bf1bHWFp3y0IFPtbKs6hg+tqQ+KBPr4U2Evq4TfT0E7LtpScDQc2d7sT1Kw4H4t4mN5zERvD9w2dkAHc+9C40OPS+tvsQxG+GeuAKYRZFFF/1EyXaFQUnc5+NtIVNjCD8g1UqFWrA73bIgXIID7PJKsOHUENCWiDFGB7PbrWD11dkZotLzpl6aKKyPJdH922RaRhLWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thanks a lot. Just with kernel image, it is not enough to boot the host.
> Adding initramfs will avoid the crash when the host boots.
> I have made tests to verify this.
>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Thank you!

