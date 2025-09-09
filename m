Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F03CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAA98E0022; Tue,  9 Sep 2025 10:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092898E0003; Tue,  9 Sep 2025 10:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3998E0022; Tue,  9 Sep 2025 10:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D93C08E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:46:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B99911A44A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:46:31 +0000 (UTC)
X-FDA: 83869987782.19.6459D32
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id B236B160002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:46:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAWHSGLc;
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9r8is19th/mpc8+gBUPuFGFOMpuM+eINAVaHU5/+AZQ=;
	b=upY7M0ILemxu6Na4y4Pe+sPoBci+ivzXK8XNlWT1Eusv0S9gMvBnm1EwQ0BdmUM8zXIkwm
	JCYEzL2csMSDgU00P8kURi1IuS8fYN4oesLjE7Baxp67XRbj0HzvXhiCYKMw2bHVAUHTVP
	sm2CWhz+UA8bdT5mOlpDHf32ynWuPpU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAWHSGLc;
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429189; a=rsa-sha256;
	cv=none;
	b=oQrlxgHfbMHjjrUfVY39E1YFT8yonvI5WepNDp9bxfy3fTAe5zoWgaaKXesjt9y1hV3eZv
	KE4eNXfhDjOW2QZniFq2b+6SyfUWPnN7CVpwwzIV512p+TTV19R/vyZzClsp3vFrCq/5su
	sEbbMGXaMq6nJ31j5cR446OoDxsjtWg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45df09c7128so7056565e9.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757429188; x=1758033988; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r8is19th/mpc8+gBUPuFGFOMpuM+eINAVaHU5/+AZQ=;
        b=aAWHSGLceWs44aSVb8Js/UwCR/VepeLwnwLAmb52N90WvRbpjkOteHQHZIopQ19BuI
         tCDcmipC1+n2kS38TVqKkALGI7y0FO7Sq/kECieSQx78RwLukORUeT+lDlTsSBv4YOF0
         DcJn0Eh8plIlQJH9dcP8zKYPRgCskh5epOq2vr0uPxSt/BrrLHvCVpLS9gxUvTbntF5S
         mPFK5qVRlSqGDhVq9UQOWDCrhFAuKRbszTww/WkaUiyotKsVpyl1B0VypK9Bt88uxgtC
         K2K96Sg7/844V8l/ZTSr7lWvWeelEI7hYh5Qho3tnxtsS55zMXgYFBBZIooLS6IWHQqN
         QiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429188; x=1758033988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9r8is19th/mpc8+gBUPuFGFOMpuM+eINAVaHU5/+AZQ=;
        b=C5ScT9sPhltcXncLjy1sW/brLk/wY+Jip9x2CGszSyH6psKpbuiExKBOAxuuo0yjrY
         wkeZNFWBPhfRfvr/7vJyRhYoq5mDzBZZJmdb4uQ1a+KSwyhsm1pHTEqNy2YST3+WfQO/
         FdSxzV9ejyoI60uWtD6kFjjztLaa0PaOphYPnZy21sQhzvqPRDK7nr2vYxZ9MbKPjtTY
         Jmur7fq1ArzAGKHVuCnTsSwe1iSaBQOPoBGrQK7dz9Xpun3Kd5M+eY2UwnVwGTj32gja
         aG93ijBQxrrAmgXtYlCZq8IaVNc4BZSXbkW9fqJt2JqyhPmcpdwXz8ttkwBf1Xm5jhtU
         f7Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUfcRU3qW20J4eROnFUL9z/Nb5yGAQDvPaF1mVr0KqynqpHWTm9UJL2GMsotd5LqpAkwf3C+l/a8w==@kvack.org
X-Gm-Message-State: AOJu0Yw14bI4ETWk1eT5eHeK25OKMbpsDLzsPv3PK7nNbxAYvln5jvF8
	EVryGWTXwpm0/VKFcHsH0npeZap4BLS7kHr5wHgW8amw6Ozf/z9soFlgzCLOcvapo2D3Y4BMS6Z
	rZSqFwUwNxtBIwMRvEK33/rnDWViLZ9g=
X-Gm-Gg: ASbGncvLVUYZkb8gjvxkiLrP5X6fQSV0mI+Jye+r207FuBejKwAY6ZLk6nxQYtFqvSA
	RrzgR8z9G7XiOfNoqV9HPCuYgryvW1394H8u1x+GpnNqtgGDJXeoWs5FVlX7qjscB7PVxJxvj7Q
	cxMV3xpu8HkLJiA9hbGXpUh9OZkOd0/r+3Jz3HJqPURZUKijbOEnKCqv68F81zOQuWQzbR6S5H7
	VgFB7CqH/3xJU9ibDc=
X-Google-Smtp-Source: AGHT+IHX8hpEThdKWhfgKRLr6W0FWhcfhr7A4C3lXlb+Th2laAYeLYdN8LPk5jePjYDY52XyG4mlIX7jog2+tQhQdNM=
X-Received: by 2002:a05:600c:3b1d:b0:45b:8ac2:9761 with SMTP id
 5b1f17b1804b1-45dde20e5c0mr116112155e9.13.1757429188072; Tue, 09 Sep 2025
 07:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
 <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
 <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
 <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb> <47ip2q7fc3q2igjjjg24bl3gwlpcr5y37pahkqb63ridzj262u@augjvsnpq4kz>
In-Reply-To: <47ip2q7fc3q2igjjjg24bl3gwlpcr5y37pahkqb63ridzj262u@augjvsnpq4kz>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 9 Sep 2025 16:46:15 +0200
X-Gm-Features: AS18NWBnjU96S1X9HzwLOYnj48ud-1aT029AYj3EOfOXKk4tlcXWbWhwT0m09CU
Message-ID: <CA+fCnZcG4Eqy84zNuvZ2Tumi=eA=KAGFFeduRLiUUHYRBMuDqQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B236B160002
X-Stat-Signature: yfe5mtki86cyxym4hbxtki1inesuc3mn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757429189-812661
X-HE-Meta: U2FsdGVkX19UiU5sfN78vgyH+CpDwEb9pi3D+OcYDWdVY92JrdrE6FXAkq9aWbeJEzPxBXrbdWKV/4C+CnXAo9hMu0cJhqE4JkkxLzbDKBU2TO5EvFALzq/W+a5IQQjxYtECMR8/IV/iMLeVw/Z52IVuJ7OP6+X5cWyhRzpIblKi3P6IZcUnE21N/124/ARFRA7tgUKlcLpxI15eXmKCFRUmHb0a7hesKIBfqnErTGeCyUz91S1eRwaR0TBvH+qB/Cj7cokbvNzkReCVDzDt7K+wF1CHO3KOjE3vJkqxweAFCFNOv/FbgmZgsESAgieInKoAh5K83QtwNVbXC53hSeowIiqBLCZa/JxX0jKUJoN/+DglqFq3ushT7PLZ1gZeJJtoaB+dlHrmh5qP2jthkgkPrpGFqnkJ5UI2gi5Ot33X8OnrqBCLnPadEvO/DHdgG3iZECBusJ5t0D6tx0PtetYJgcd/f82BYSmgqf+xDgsjvYI/7JRnD9PmuX7bA8ngg342EVsQf6WA9jL8BrFIzTSDuPlSTwYGk39+u/iWu97w0zfXxDYl0l0HhLJjbqpsl7EVQzMRIQ1w0AfeTOs6eJM94YOVCyMQY8kUZRpHDPGNzHOdkI+IkxVZDwgdJo2Aw3lFjE1qcm6aUmpp0RssAZ8Gy0egwmueit6y1izmSBEMgDsQsTHk7zleLUg7kb/ySL61QGutLT53SlmZv+7bWcoxzpP5CBciI5l8IXDeNGiwqd8/xGw/Qx7VQwpXJynvrEZhTV6Um01hV1eqzgeceVvvubSK0L2lTLNFi6BlF6lTei2xixlRmTpw3CuRMPNk97VpuRAQYPZd6NfNwngsvWxYqOHboKss16t9x4eIwGhFQllQs/FTGjL2r8T7C8EunFarrgop4V6C7rqfUUEa1gDbKyLBdkzIQzUiJzh1gyD+rAXcySMwRLiW3WA2dTHB5wXKlIDGFRx9/II1rVC
 i2cer/Oj
 RcDcAeH4Ob/Ai1zeuspQc/Q35FpFKs+xsYcTTagy50hy+pqkZrVq+0/v7aIz2ym9Pp8hdiWIu0YDdfxaUUPEH3NXE8mbOR8sULcP7QqUxg87HOEgMwnYFvVlLqVoo6INycGCnoqJIDAWSvDya1mP3zUQRWYXZLuRHfmBei54i9lHscs8oY07RxDRNFxvLWBxjrs8tOymNWOZ4eN7PEMOfPxl/dH6Z2wK2xIweVW3EDEuNeHMIJoWITnUy1cOLflRrdWCK5v3v/lemeS3VwZqIlHcv76WDUAgsk38QFIvPKdTUet3ieDx3pVNGT1HHVtmEzQSnUF+GaCcwHLx+RN0UMsPYCfhI5DLOJjBME/DT6aZf8oerP3rxwBdWmPhne54aiP8TavDOMMqeo28kXHFd0GYqB72lzTxGPDrXSGtjcjrKoVxU//Z/9HEBK9XiIINrHMogSLMojCxskKZj3ursoONeOBSadHhcnE3m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 10:54=E2=80=AFAM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> But as Peter Zijlstra noticed, x86 already uses the #UD instruction simil=
arly to
> BRK on arm64. So I think I'll use this one here, and then change INT3 to =
UD in
> the LLVM patch.

Sound good, thanks!

