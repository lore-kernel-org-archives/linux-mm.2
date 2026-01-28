Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2ADD46BE5
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 17:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5FB6B0005; Wed, 28 Jan 2026 12:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DD56B0089; Wed, 28 Jan 2026 12:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F6F6B008A; Wed, 28 Jan 2026 12:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 615406B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:50:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AE6E1A073D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:50:51 +0000 (UTC)
X-FDA: 84382113102.26.F42B28C
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1328FC0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:50:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Niq8YF62;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769622649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNqWkOyueD1v7WuaKUDdc+x4jRQ5s6ulmoL4RqUerEM=;
	b=v8qJHZewrsLwOp3MYzy77Q3oRkjM0FOG7OqyxRXBU45Viu50smqq//Kf14GKio2C3i0tuL
	Jt3QR8kodLiEu62+0W6urr+N8mLELgzBwA64YGWKw2yWOZ0RXgX1bKOtaXkU7Nr+68MQJr
	biluGAPABZ3gehMsgmtuP43lmzf6z7w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769622649; a=rsa-sha256;
	cv=pass;
	b=2SO/qprvHzNCsQORRrIRmsaOPWuMkWpgURY2LTJPpH/Hc2CNMX6J7vSil5gUZgRKcyW+KJ
	PDYynO6tTM0EXZs3uGc3qvVL56L00yJIVd3iXk83dvYqouOZLLUfKhG0kFi3waPdVvBBG8
	ARv051J5fv8KRU0kxDZP2cwqj8YElJ0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Niq8YF62;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5f1b9fe06b8so90507137.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:50:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769622648; cv=none;
        d=google.com; s=arc-20240605;
        b=PPcmQrxF++DWTAv7YuT7ZKAxfgvyH6VLgi6j5xuwFIazyGXuP0AhSrkhW7DSRZQLLF
         lBmtifEsx10cTcQLY9bg5bbjtbvVLzv4Q0R3A/rTNdvkrWo7fDPYKnkY1mmTudqxkyAs
         jRFltU1xXOOjs+61Z+zJs6g4r8TNw/In2Vf0WnxOO5ApwpM/7/ACi+OCCzRRgWinq7tt
         sMo3GlgP5ERl0kszXwJ1N4flmZwnaojOk3lR5GhADy+RrETNh/tq28aaNADHDmGXrGje
         ZKKBBJWjCpINf0Ei32MCD091D/D5bYBsnpaVXU1ufbfpeeT/IJUNkbmqAnMx/RyYsAUl
         /GJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=CNqWkOyueD1v7WuaKUDdc+x4jRQ5s6ulmoL4RqUerEM=;
        fh=bgjoOizocUgYmyRqzL7b2NletyiLbbsMljzdisMyvIU=;
        b=ShdUPfvNsgIAqTOoU0XWeNBeqzeWFGunD0TKWJs1WdX1qfTf+yM+lnEUrahuxeNtrv
         rGNkV2GfepbrQ0NYVktt4BYVfzlLzpfjmKWJFEztX+c/YiryNbEPTfHqv+0VBX9KZJj4
         AA6ImFZ0YBDm+VZL0uSgmpws20nQATCQ6JrLEvrGQZGODlB6zvGkz7Yo3zwsoBDsJzWk
         0M5L1YOIeCObnyug2BrZG9o5WMzsWQfa5F2FGNp1MCyMb0qqfnV3wSr30mea51aUaGN6
         vOITduMYqjuATlbP421UeXuDwP5wH/uab4OeH8d9SOLhJpQjM/sjrVcQmRfRdrK/0s32
         ey1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769622648; x=1770227448; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CNqWkOyueD1v7WuaKUDdc+x4jRQ5s6ulmoL4RqUerEM=;
        b=Niq8YF62snNYLByt3UmLqxif9kQ89bsDvU9mylaJXGcAaHVDj0B2uFhmq5Ru0H+Ygp
         2W4w2PS0ZILEfqg8G1xf6V5wvIRgjxJLwfrh/m8sNKUlBzdWafOP/98wekIf3aPQgJs0
         wTcUEPKl2Wu7HadpAvSM1/6FopP6HlP36mawaph94PMOYZSRY4gDGYTFoj1dBuHkHSDz
         hEoMn3y9qesXUwMRA7ePeKtRIBkSjq7zQQRtn/cq3OpBb+Pb4BT1P4NEXJv5gCLnL2DO
         kfK7aRux6mjdexYdFY4jm+/9Ke4HUHNZGGYtk5YNBpSayu9FoJ1Xpr+jaR+BoXHCrQN3
         QXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769622648; x=1770227448;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNqWkOyueD1v7WuaKUDdc+x4jRQ5s6ulmoL4RqUerEM=;
        b=Qx+iKt4kTyj3YEEA6c98bZfaoJc8d4K1V4BMJcekpGs3V5WVSFiQnK5bsbx+5OzKt6
         /5dtAFtO6v/ciI8WhDj2LQeXXkAKH8/zTfdB0HRqiaMLEP98E+kVjS0djV7x+SliIhZF
         hBvroiUwAExSch6qbweqNzjMX3ovtebY37/LeqKuaJglfR5zKCqTKp0gykEEp/VmWwyp
         Wd2MtjCPaMqSVvLM5XDDhcGpHGryGkIqdPoFOg2KxfX+F2q6p2Pn9i2aYlB/ngCOHTdM
         3bDMGXhP6FqZ6xoi4EYSuUycwsU2mUyUtV191t3S3px3PCCcR7D1750kGG4dZNNq72FB
         32tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXztvec1zGO2C4hqKEfNyY/2xc7DFyAmYImj3zK40u7bwFi3tnCZhv4kqRICynmLUHoImsITvhmPg==@kvack.org
X-Gm-Message-State: AOJu0YyybRnRo3uWsJBeQ8qJpUkVgDLXMEBCDtckyV/K1u4pjWBnkRKs
	6cv57ZmQz33RYp1RgePpvgSzL0KQcge3LGFlMCznlSFWrsnfPnktROBZ1wCH3FhIl+1HA7dn0/S
	7zenkab0PlxBy82UM4SynaGxNAerwtNJ2lu7mGCJGYGDPqHhZBBux/j7aBbk=
X-Gm-Gg: AZuq6aIdxeUSBE834J+h+uVkg7gzFZo3nAv++UV2rS1P+zd3u1lhpbbBARm3FtV0UPF
	3+rDalZB3JbtTET4eI04+krTTS7YIOIGsHn3lt7XCFA9VOu0+7vaem0wa3wSUuRzVfOqVJdiv6T
	0amNI5NOr/2xi6GND+bkYJDPdIUfFGFiWMcWb0kKhR2O0TIuFd3OKAobVdHVfSNA91jZiVS+LSV
	UHcZsvKabFybh1F2RPajChy2b6C0ESf1dG91kDTG7ssmnBsJRxjeXBWR3DzmlVLklgzNL3oHv0i
	AjrT7YoutYb54nM7CMShP31Kdg==
X-Received: by 2002:a05:6102:390c:b0:5db:e2c2:81a1 with SMTP id
 ada2fe7eead31-5f723765badmr2717805137.14.1769622647325; Wed, 28 Jan 2026
 09:50:47 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:50:46 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 09:50:46 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aW3kOgKL7TjpW4AT@yzhao56-desk.sh.intel.com>
References: <cover.1760731772.git.ackerleytng@google.com> <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
 <aW3kOgKL7TjpW4AT@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Wed, 28 Jan 2026 09:50:46 -0800
X-Gm-Features: AZwV_QifG6FXcq-qNYCcE_MoQgt6DAo9uPq6fzN3xKHneI_AD0mm_Yxu6BjCe84
Message-ID: <CAEvNRgEjo5idG7OtMqHt+kCRCQnWjzWzQN7nwNGDExwmf4fyvA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1328FC0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: iguhf5u59gnyzpaoomggh85bpsqtr63x
X-HE-Tag: 1769622648-602789
X-HE-Meta: U2FsdGVkX18NquMbJpF/iOW6i/3Nvoy0vy5bDozf1z/hFop0fiyFqBAR/oSXI2QyW1qCZI3AwFPqUNjLNCqcp+nV1TPrlXyzyKp6YTQ2kakBQ+2JL/zIC+nP8kNiHBKTrsnKXVw5vr/dSCWo4Q8+aoww4gEcoI3wF1AQgtTNwdCzLw952bB2wKI4wgCg7/9kBDzGtzUXMCwplikDOj0WGL/nFvF15KcfSZYir5uIxd4o1B0jvq/a8n1FtIATkI6N5B5oWQLGghM6PbiFWaAyX7dTZQ1rt5N7V7cNmgCEKwcmDNMh5FY2isiWu4QLlo4JVQaXy8W9nztB/es0AGTOIofGf22xqrzmBr5N+QtYsQOPmly4u4X3ewPESb/0Bej1kG++4dCN7rJt6LmjFahdkr4Xe3UsLoBlWOf7GEI/OdkclWjod6o1wIj8HUInxlM+XQte4/+GJH1uZbUE1gu5evny7TnyOUH+Yh7oAc6HSxgey5FEqBPWivVxHAQONrOFOnsR3V/QGztXabE53T8EjfLt1VEPkaJ4bAzjxO8KqceGGcN8OD2OawQtGt76caJccU9J3coWxjx56ca9RQXmYZ9LDbgzRreUoc5/CpyxSTCU7xgX4wV4NR+LqTRqSCmYtbv3ibNgboZ0805TAG4F5OpcC3ngD1FE0O9gnJn0SWpVsVw8tnFtNFbldcUeCUTqzc4ekrswfjojPdK106iBhTxqKxLzkomrlcmIxGi5MQAkCwq6x4HvCsY5RyiFsSfP+nt9nUgFSJc1T+Lh75J6sgbTD/UDf4hfX/3ctUKuqBrikhxvN2SgYqYaCXO/mhi6f1nEd0IlCRrkKxlzPeD/zdpMQht5SzV7TmVUhuIkCFV2XSQkWa3ZhzD92RHFekLDzcMCnt3yEeXfNcT7peVJm1WYKUj7zDi5KU6jGsI+2SQSRk7lb6aTwCKuOb64TW932nb+wYjWp2n25A5fMGy
 K1LXZIzs
 t4Xcrl6R7/e/nqOMaLBhoBAaoNviMbmUsM2FkHVyNASp8YQ7HEfil746GtAjYciulYqNM/qhbE0kKxmrmOzELj3c5QbsxMwNgZBhaL/fMZONzHhGLe/CHK0DiWg07tOMHFpa3JNDG3yW79qt1ByaKSNhKYIRjZ516kK+R6PzKWhkMYV+8wQ0pC2Vk3LbbXrKxCwlGgKhk48u3CNPUMPX4Nf838bYI1JPAQS5srsPIGM4H+AFOJ8uvxCgWo1KUlHxU2qcAka28NCfEnLaZs5/CZ9LPSe1tNXQdGQj6W5iZoKph5Vf0SbjgSJHOJm2yonGaLrXfOhtf8wSPEuYQCkJvO9MSWYL4ow/Gy7UKC9RF3oIziQpEtaitPUPJMSjqhEGqVtX+W3xUwcCL/M0+F3MPyp8vCFRfYgvp0khRstdFSIMKifBOixUW5jyyttsmbr3/M0Elq9RwrPGh019K7NtvVQzYL7NfHkAd5f0jtQwkl5MCrGBmYao9RSSc1FXQm00BSkI/KwPEvNLwowU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

>
> [...snip...]
>
>
> So, it's possible for kvm_mem_is_private() to access invalid mtree data and hit
> the WARN_ON_ONCE() in kvm_gmem_get_attributes().
>
> I reported a similar error in [*].
>
> [*] https://lore.kernel.org/all/aIwD5kGbMibV7ksk@yzhao56-desk.sh.intel.com
>

Will add locking in the next revision. Thanks!

