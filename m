Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8486D30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 21:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8416B0088; Tue, 13 Jan 2026 16:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3569F6B0089; Tue, 13 Jan 2026 16:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C076B008A; Tue, 13 Jan 2026 16:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1403F6B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:58:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B079A1602C8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:58:13 +0000 (UTC)
X-FDA: 84328304466.14.36719F3
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id E24EF180002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:58:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHlB25wL;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768341492; a=rsa-sha256;
	cv=none;
	b=tbdvfiH1S56C+Et/I4+KQt5GUCXCU/8WNzxz39I5BLd5ZIBT2KO3gAfvsc73cqNG+Bd2xF
	OveE6LJNe7t8n+6Df6PC3ak64RNPocPHpDRjlkm1GNMTZ7IAR4K2uWsohXEXRd9/Cw6cVU
	sRshNmyhzikw+B/n5vyW5cmoCfQYSfs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHlB25wL;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjQpoKoi4pzTkbGscUXDmca2AVl+LBzlv/bdYvtEAK0=;
	b=ot7pBkseSWSyXNp2l1ifbA+KX1PLUFFbPrxMxKzAbqJIhg02b/71vATjqIYzEqfUJ4FIgP
	bEKgOCUK8syppdVw0IVYnMk8bbCZlmu4BPnfLtK7rkwDkWI+0/GlkqDFklR8OLqu1Dse1c
	aXOUirnN31XB6AgoP/mXLPZSk67QFJQ=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso55340585e9.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768341490; x=1768946290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjQpoKoi4pzTkbGscUXDmca2AVl+LBzlv/bdYvtEAK0=;
        b=VHlB25wLgBCuTwtYu0/6JqmnqYF8NWaUFDsmvG01D4kfbhavGky0bhIDduKgzlVfOI
         Y1tuPbB/y4aUXFlDJCNPbqThun8PBPqXJp+KGreAsYsP7BwUfebBkmLswnpZvdNHAuCZ
         rp2EO92x3dlojUBgramUUBgQUGAVc2ptvKV70YkcmltEVAdZ86cj+t9jEIT8GRoVCO2H
         dR73+7zmrf3ti1kRuvD4zgJLVX29XnTkTZ+mhgTgR5t6WSib5oAS821NKs0MoHjEuow8
         +wlnYbtQUJBQvV0syIFCfxDy2jOmcvofcsU8UO3rNwaNJlN+nuFA40eB/aYZ/69CRHGo
         S6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768341490; x=1768946290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VjQpoKoi4pzTkbGscUXDmca2AVl+LBzlv/bdYvtEAK0=;
        b=pIy+y5M/xPlQypNeWkfL8V9PxjfaJaoQIQZpPP1AcRFXkilAxmecLtR/sh3TCpBCmt
         MNO0JXkgDBCMjdAzky2vCWjKxwYdug4sPDdfEvHwnRQY9Zv54ZbWOBQF7OOgmnjajyH7
         YxmI4Gcd+45GPXfK+rinxrINAWp1nlDdUx+u5cFN5OIt8ywnjmH0WQ+S/8YPQLafh8gX
         0Ly0QAHyJPe2BOhKEeD7e/JUC9DIVbO3fPDAPCHOFCr4qcaDikaT/T4gO2xTuUzjs4xm
         NJ4qI/Pig1PV8mEDfNpyr7rVhKkyT27JrMpdypZ6zShi/ZXCaqbp/zueCbBsUui9DHxe
         N4kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcqJAjOTtNI6Kgku8xeZacj7OMpOdzYfZob4p0JmXRn1iBwtXiSlG389tz77fd5XLJkfpyx6UsLQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3REM2WNtLNri8TQLQx4itfsPyrq095RzqEXRtTMKaA8DsS8xb
	kR1M816h/KGCcO+GBeXeteGm1CNqRBadqB495G6LBvIrxHwXwHa5tuC6
X-Gm-Gg: AY/fxX72oRzb27PmDKTDtpzl+tOglMLyT5llDjHNzrWj0wtFc9QNWBcsx1B1UvKJ6SU
	M9ynmDEqFQ+sS6zzdz19cnrmE7cDr+sEs+biMNd0kK6SolaZq3i7h+8f+MvS2vZPsBM9E2imTAz
	3nWhuAEjwVVxP/LI3mJ0ZemVej+CIG9FxcEAvdi0ifzneJlBlyycpqJSYxPspmjkRbtf8+kqI/p
	OAFgbcR3QSvcrSIW0Wbr9JaP4ZkZAkYkLyjA15S7raAc0vXuujTcmwLLcfQp+YSS5H1ld8nO/I7
	80c97Qm82uTNbm9pBxY87+Vo2p0mDoj1q0bngpPeSiqmT7f9r3g8GcWXp1tk430OyjceXeX7HHW
	dHVEclOdcf7sRDCjoLNIo07A0aT0dWcWc7zlifc47vtFS5hBHE2KBWRA/Cze29fa4QJwx4f3krs
	IT2noc6rl99DJJWbwivX90eTheTBfcWodP17re6/BuqtcjdmsfpB3r
X-Received: by 2002:a05:600c:3487:b0:477:9f34:17b8 with SMTP id 5b1f17b1804b1-47ee47bbe36mr467055e9.1.1768341489984;
        Tue, 13 Jan 2026 13:58:09 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee0bb3383sm8819575e9.2.2026.01.13.13.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 13:58:09 -0800 (PST)
Date: Tue, 13 Jan 2026 21:58:08 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Nicolas Pitre <npitre@baylibre.com>,
 linux-mips@vger.kernel.org, tsbogend@alpha.franken.de
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
Message-ID: <20260113215808.135dc8b6@pumpkin>
In-Reply-To: <20260113200455.3dffe121@pumpkin>
References: <202601140146.hMLODc6v-lkp@intel.com>
	<20260113200455.3dffe121@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E24EF180002
X-Stat-Signature: bphjjfipkc585se1a3gzkiy4dzqam63m
X-Rspam-User: 
X-HE-Tag: 1768341491-950669
X-HE-Meta: U2FsdGVkX1++ksm44aay7oJAVF1Y2CtW53xDbN7166QzVTmK1DmrnGSKEiLFvqRUmELhQ/f8v9s6GoO4OPjpy5OGK4gPKfmai44XVglkpanhAUW7q1UkEOeyVsksbSJAvNKj4fXm9k6n+RU+1ATw46qKO8lLacL6jEAYQCc/woVitPZVShNIoLiQOQqKYcj9x0AqlQrtzd4zfXaxI/BKkVb4SIJD/90R9WUkRrA9O9NoGXHkH00+Jg7163mqjAeioqO/BM/yTAOYVxqNK7kU3IXKoZgdnRUpORcX+svSPoNNv85qdP94fdFgcaiaq+fMU5ZevppXcxc8tTWtWGrOpjAUhiGSBWeLJ9H532gr7bVEWobz7ejTBIkHP/u8pmA6bI1TPwCKIngz4zXMApG+BmJAbwbccLxrDWZkSmvDDGkpPN1HOdR2N3GWdw4p8ke2/oCskAJa3Nf1Wf6IeaHf9wrfbOyUvez0C0BOfb3NI4x++CXabx5natHHa4yC3JPhqHwCJhK3i2/ni5QLRZay7gQS+CQD3M5LVCq5bVHvoidD429+eroW0Xun4uMV8Z5gi0eS887NBh3Eevs+wiYPsMhnsxpYIWLV2YevSgcmBHXs1l/+df1FPuuB97bdV+1mTvv62PE82Bv2ltE72RJt3viGYMAirs0QBQuk7KPo1RIKm+oG8VhjRtnPj/sJcZ57c/mQIPxj+zgbPE6UEgxUgjtnOol2gF9K9Ftimmr+kJofDtrPDZvNHPqjXOV36LQZuwc3G8QZHx4ma+TXUJx+ytU5wSbZLst+YXv60WFrGTrw8RrqpaqD5dGpvnunceOjnTf1yH9pxN7q7qvll1W3pli9/rqJ8kNpZyTeOaLXB5LTEgzNT+mcobN7gwy+DEHPGUVR+iJ2/ELAfZYpWeKEdv/VrqqLQs3rYyA0WqKfQlvl+W20QCma1Eoz+MhU0Cw/cK2NHgd1xqujfHJw4Pf
 U6p3rpAd
 vnE6NGBiydxN6XrUj6ztCU40GfeEsmoF73hSxSySiF9KuGXC++gCdKlvP9ehX7yvDoWwtPdGoC/2AkB04CC2bsSAe7NwrtAB6Hwvz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 20:04:55 +0000
David Laight <david.laight.linux@gmail.com> wrote:

Resend fixing Thomas's email

> On Wed, 14 Jan 2026 01:59:24 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   b71e635feefc852405b14620a7fc58c4c80c0f73
> > commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
> > date:   8 weeks ago
> > config: mips-randconfig-r113-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/config)
> > compiler: mips64-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601140146.hMLODc6v-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
> >    div64.c:(.text+0x84): undefined reference to `__multi3'  
> > >> mips64-linux-ld: div64.c:(.text+0x11c): undefined reference to `__multi3'    
> >   
> 
> This looks like a bug in the mips 'port'.
> arch/mips/lib/multi3.c has the comment:
> 
> /*
>  * GCC 7 & older can suboptimally generate __multi3 calls for mips64r6, so for
>  * that specific case only we implement that intrinsic here.
>  *
>  * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82981
>  */
> #if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 8)
> 
> So this code is excluded for gcc 8.5 but the compiler is generating the call.
> 
> Looking at the git log for that file there is a comment that includes:
> 	"we wouldn't expect any calls to __multi3 to be generated from
> 	 kernel code".
> Not true....
> Not sure why the link didn't fail before though, something subtle must
> have changed.
> 
> I think the fix is just to remove the gcc version check.
> The code itself just adds the results of four multiply instructions together.
> 
> 	David


