Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF27C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAAA6B0088; Fri,  8 Aug 2025 15:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2786B0089; Fri,  8 Aug 2025 15:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7E76B008A; Fri,  8 Aug 2025 15:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFEF66B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:51:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4815A1369DC
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:51:42 +0000 (UTC)
X-FDA: 83754635244.21.3593FCE
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 952A31C0011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:51:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kKoQ2f2e;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754682700; a=rsa-sha256;
	cv=none;
	b=YMlYPEE+WLf9Ha6KQxRmtlZabzQEz4JSh9OCsjNW+oz8278AHAgXFR08UoCs10+TAmlCNJ
	WiYVEJEFVfKUBlIyFzoQVKQNZqscGtjhlS9evqNEaAt1wZTR5cK8CaMnSEEYowdGJSoyyj
	oihV/fA0xpF6d7PH/+sW9bCkkSq7XCc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kKoQ2f2e;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754682700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI3NF4nmF87wkVHXd95sZzslTewp5Rg+7HCCf5M8kbU=;
	b=ywcAh7Y+JAGoos1ng7Y9jQdle90lzwprcSxdVkDoh4Iyq8mYo41YDQgkZwmWtF2UJwQkgb
	jzP1WOR11vcqAf/bv+yPpQ5moMnHlo8+wtgad7WdBPBTdhgOb58lfVe1qOPnJnjWlC6kiW
	2LH7gB7mxd8kGQEhmh5o0qd1/LXvzC8=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b07d777d5bso27308001cf.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754682699; x=1755287499; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI3NF4nmF87wkVHXd95sZzslTewp5Rg+7HCCf5M8kbU=;
        b=kKoQ2f2elyiBQO2hcd8/0y6Oxqt7eX4pcVlFH8xTNCuf8My94gOhxFKe0AmbS6bZTb
         spq3z2QjACkSMfJf1Cku7CMlWHxr/hzt7L0pRiEzHLMOBRP8uQriUQd6HtF35R6mqcew
         kBFR3/pAmDLi2yMwMO41QeRuJ0ccr8p665LGGj0LxOV4QvF6qhMct8WONln/kd6CmPRo
         TwS2QEkpfR5SglTm/8l59D+ZCCLOWjZvWo4AjM2ZK5BjPJOoZ+XMTvwbrlkeAAMCh0uF
         REfKkT/BogTBFHpGnWzUNZ73tm8g2nY3lH3LYS0iaqiucvzEPAiu44CsnViocKqR5xN9
         2Djw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754682699; x=1755287499;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZI3NF4nmF87wkVHXd95sZzslTewp5Rg+7HCCf5M8kbU=;
        b=s6HUEYZQdT7R691E4Q5FPcCckz65nVMmiE2rUXtL3RRi4KaTCKOsU9JFZmjKh7+px/
         P4RXCJlii3B/xJ4HSg76Cnz2iBDtOq5e29b+j9F36r4qBNHsy/zPQZLJitWXlfoSQ13s
         My25yghINpK4YAzLWbbzCRRXUiA21waIUGSIrtmSWK/tDqfHmnczjtcOCRastmATgh4p
         UgkVwL+qlAGxi9gKVENFGAFMiED+Jxz+BPyJuRx4O0FG9zQRZjLkiy9WdhR6CFClO50n
         JUFMS//Qgf2ew4yuulFBz+4XmmfG8/AbSdfdTclO3eSUgFNRUeTQb3vKHKEIV3CejmjS
         Yj0A==
X-Forwarded-Encrypted: i=1; AJvYcCUDqEN6/DieYN1vgjCE0ho+aOpN6LgKXc0eG7Bh/mYCbapIG2iBNPe35y6BPr8KF9vBY/pQhZDdqw==@kvack.org
X-Gm-Message-State: AOJu0Yw0a3xazdcAR0+awhR5F1rMiZawI6HC7IQU6kB40mjws7e2g7LJ
	4d8MBGlUVM9FbCrwvjJliUNPiDNLPoPlKgAWcdMu9PhUmsmtFDL+hlBbujRvmJOdybdUxaaFLAJ
	249CUDD96HZrql7ST958EGVRSrYmNFBKirz/3UDp80w==
X-Gm-Gg: ASbGncuz4sWJd+zbFk6g++n7Au5arTaP79gwI6RKUw6HibcMJfWtFsVZ1d4XLuU77/R
	f9cgqaqDR7d3IXvtOo6rwCBkxdprNtotVqtvweG+UL4hzRup/zoxRSuzoAslb/3ZcGmllgc3SyJ
	b4SmVcWWEVUq5DkBkHm8jNhEF8PsnhKZHWIWwb4RV2pzh5n6MvcAt9nULinbxRK58FgqpdyrnoN
	exQ
X-Google-Smtp-Source: AGHT+IHCcrYg7/jG4VG+Cw86KyymKHrjmDEsAzQfWB1gMcCPUUW3z00Eo/TfCPxNGcOawpm+qrN8GOrYgzTiH++NeZ4=
X-Received: by 2002:ac8:58d1:0:b0:4b0:82ee:f732 with SMTP id
 d75a77b69052e-4b0aee3b087mr66564781cf.53.1754682699519; Fri, 08 Aug 2025
 12:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-2-pasha.tatashin@soleen.com> <mafs0o6sqavkx.fsf@kernel.org>
 <mafs0bjoqav4j.fsf@kernel.org> <CA+CK2bBoMNEfyFKgvKR0JvECpZrGKP1mEbC_fo8SqystEBAQUA@mail.gmail.com>
 <20250808120616.40842e9a9fdc056c9eb74123@linux-foundation.org>
In-Reply-To: <20250808120616.40842e9a9fdc056c9eb74123@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 19:51:01 +0000
X-Gm-Features: Ac12FXzwr7BB3_YD7FWm0iRwopXjM6LILZ73ll6nomRu2PpALziQgUA6db3Oe8A
Message-ID: <CA+CK2bCVziiUZzdGaEabmPSB4Dq41QZe7gVxtgwy4pWmpo=D_w@mail.gmail.com>
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, tj@kernel.org, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 952A31C0011
X-Stat-Signature: q69kdfkrd56tynisp7obbp7sq6j1g9f4
X-Rspam-User: 
X-HE-Tag: 1754682700-390175
X-HE-Meta: U2FsdGVkX1+iUk8HjMEAH72pn1KSBKdTKzXCoq0gXet/qVFrJgbFXZ8lZFRNqgm9sslk+mRfvjbL7eBsb9sO6Ree80F67JzKCv7QfBNW1N8FaSGN8xnaXQsx//DmaRtvLtqqA7wq26z693NWs8ZsNX91xADb6NgfRyWL2RkQH8yc3e+jtbDOTqzHjQ650Eycnry6agLXice+RvobdfWUEN3SPBRdX4++IRUMO//u8IVPW2WR49IAxMdFjTFcD3/undNVdU2acqbJAeNk/JfyfBTg3pLVLXPifgXLCfRAOlZ2MvLs/+aLB/XFLiNRLr/splDZmblk9+Coq8bjBI6mL0hx2k2le2yJWXjCn+242Bq7VBqShQe1A8TnMNUm1dG7sucLmjdqh0H7FofPqet2Idsft6ZaAPlJec9pU0JthI+hj7+ed3Sf9uxQeTQQpFie3Qhd9DEEp4K1/rn2WrA6wqL3ZIgfHpgI5eQUjCIY+N6wkOogdpL3PQyjax0B472Y2+D8Ii/vfUIuY+sjgWHTOJP0+yPsMARZExyeOOfh04qluN7nZ9Z1+znATrZXElnky/w/WoUHlEXgn8oY3IuYXza3meANGurmiSWX3Qt8E0jscqAM5lEN6hQRI0665/zUM4fxpL3ql1zSLGeCyfTNdAE5u+kE3Ogl6XiYKMYqhxFIBsCf6FLu5u+eMJhZp7uX854eQzLVkPZzW7v/QOpZYy6yL1Bae66h4+AsDCNyffhPewWhFNMZwzM5eZZGi34GES5vAAMkzqFwllWoUwiLCWJIgOl9UbZzahtSft6y52n27CQLfO/iTmFqkODHw42luu6SK5wyPOvcTprvE1XUM44v+vQgL40k0yni5jAkc8KKxCyuyw+V/xaY2jfF7Bw7VGuMNjNoRldxQA1+Q2QNG+meg3r2TuMih6QCHEMyrKWaPXMPRlNmqYcrDeejFbHfuULx91oJCFmb6XWDbsT
 DzDNV0c0
 oU5nwYnEECtTM8uz8tEBUG+Crwwxmzqc28mPzN8XF2otXqDAjEGo9dayGQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Thanks Pratyush, I will make this simplification change if Andrew does
> > not take this patch in before the next revision.
> >
>
> Yes please on the simplification - the original has an irritating
> amount of kinda duplication of things from other places.  Perhaps a bit
> of a redo of these functions would clean things up.  But later.
>
> Can we please have this as a standalone hotfix patch with a cc:stable?
> As Pratyush helpfully suggested in
> https://lkml.kernel.org/r/mafs0sei2aw80.fsf@kernel.org.

I think we should take the first three patches as hotfixes.

Let me send them as a separate series in the next 15 minutes.

Pasha

