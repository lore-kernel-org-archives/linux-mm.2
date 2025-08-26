Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C545BCA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8FE8E00F6; Tue, 26 Aug 2025 13:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0A18E00EC; Tue, 26 Aug 2025 13:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD578E00F6; Tue, 26 Aug 2025 13:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F20EA8E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:04:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9EECC023B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:04:39 +0000 (UTC)
X-FDA: 83819532678.12.577A345
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6BC7100016
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:04:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Lbfp/Y4Q";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756227877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjIfaOrofazhAWITCaBIQC/PYR7khvFmaUUyG7Ja/eo=;
	b=UnbC43M6l1JEO7EH6xB8SekPhSwofITTB5Vm46rgy+OTL737wvCM3mWUN6dp8C83uJ1gYj
	PDkKe79qomuGcBEvfBFr1k4W4d534HusYDaSVHtbwi6riUFfWHEB+OizJWDSqM04wyDBSW
	R8tI9S7EEYBOT5DTj6Kl2hIh9cjypBw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Lbfp/Y4Q";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756227877; a=rsa-sha256;
	cv=none;
	b=yOgxSRT6PSYz9shR87wX8NnHId4uVRcl4LZCXz0IdVoT/v5rXGHpCrQLldRD4HlnLtkcki
	2eA/g+NMQHtRbagLJ2suqzg1yCYO33IcSJWnjsU0yXwarzG7L2cs1HbEscIVHOhG2ZaiyY
	MF37EjwLW0INBbOfLFHa7q5hSpPabB8=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b109bcceb9so68147891cf.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756227877; x=1756832677; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VjIfaOrofazhAWITCaBIQC/PYR7khvFmaUUyG7Ja/eo=;
        b=Lbfp/Y4QrWBg1TYY06WDy64jEpecwMPItXj6oyE8elfuf3luNu89b3VSvztr6aarKF
         9RuchSvk6rx9uQr+3cAUzElT2ENglcgwfPqJSBqixCwD1ngR1OskUi8bGdmr51CQG8tX
         IQEFFEsSeSgVzxpDiTBlIqA6Tixbs3YPRjX+AdufM0xpyHgK4I4RnUaIp2F9MbSeYFxk
         1xnSIvDRaQY3SsJUatV8eIquqtt30RkBQDJ0Ry7gorpo4A46iwsIV2L0riwCPHgi1/Aq
         W7cB3I6V7cp4v4mVwVlc5kGbozJem+gwSs/HsCZkHB0rlmT7rcyc9EcvZgmBPo3ukuPj
         zhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756227877; x=1756832677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjIfaOrofazhAWITCaBIQC/PYR7khvFmaUUyG7Ja/eo=;
        b=Hjojcb6ylMGzeI8En1NHsa4yEOu/YiBCP1iT0zpyOx8S3tN7Bt33cLtc/qbCgZLnFH
         VJnwQLBsW/lbitb77+0xlNRR4gm4xBVy2V6vRZwObwCDZeWzpsqaNkdrd19BRVYQKz06
         3QXeLC12m7cIb257O2cvRfnLwsaf01+xEYSRYF3ANZwQfLJzWjwgu2KUji/VD/MZeXg7
         88My44BX2jrFHT8/zu9EfQcD784bfdRLGJsZTG/PJCc2z9u35b6GDgExsiai2Oi0o0Bk
         uTAL0RnRWz53FduMcPOukd4XhbIR9VRiKEHsKGYX0Wa+FwhdKxt9w5uyv902d1jnNRha
         uy1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUeaGqz5WMQXuIUFJaklA5/x1gSE3oZxz/oWsgQVxj7vPABwjHR83drOyFDdUt3pz0AMdf5liqZ7A==@kvack.org
X-Gm-Message-State: AOJu0YxK7ZpHRcxpIcctbazSWOVf7Y/d2zVuNP+fWikWVsOpMj0X+EL3
	lDKIoA8HVYhkkRcemiF6Oi4PobYs400yNfjF4j1UAj3UXJP2zMtm8F8YTIdiaY2HLo7SZOfWf5E
	faXNmFSTW86Z4FWaOrfN3QoSmWp6FEwJ8+oNNw/zYqA==
X-Gm-Gg: ASbGnctfDpKVrDM5GPZolXuSSSUKP/Ft7+HIhNhNxCcUjrvjV7CaqnwBWLbG/cx5ZZR
	DRKr4ht69H1tiEDipt8m0MJqawFao2xdsH6wLx0OwBLU0NpsJ++ojAHaWvmZsKUp+5zHupckkpk
	BKdpd3N4gSXzCuYEOm30bKWaNeWiLes+lqgJKvDZ4ggOKBRIi1gieXSFYkgn9CH4XH9aohEcOS1
	oPD2b+DqHV8QRo=
X-Google-Smtp-Source: AGHT+IGhz39NCK5Fxfc9IjxwgHAO3YphwmnNvrOuu/ULmHzST7LVx0PTJH1sOUstAe48pYCpPqjEksP24bvYcCphrNY=
X-Received: by 2002:a05:622a:1213:b0:4b2:edd6:f1a2 with SMTP id
 d75a77b69052e-4b2edd6f516mr4884241cf.63.1756227876536; Tue, 26 Aug 2025
 10:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org> <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
 <20250826142406.GE1970008@nvidia.com> <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
 <20250826151327.GA2130239@nvidia.com> <CA+CK2bAbqMb0ZYvsC9tsf6w5myfUyqo3N4fUP3CwVA_kUDQteg@mail.gmail.com>
 <20250826162203.GE2130239@nvidia.com>
In-Reply-To: <20250826162203.GE2130239@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 17:03:59 +0000
X-Gm-Features: Ac12FXz3lP2hDCkW5MtqBiPoAwifNenh5414D4bEhipE2lcPWQY4sTh__rhBUIU
Message-ID: <CA+CK2bB9r_pMzd0VbLsAGTwh8kvV_o3rFM_W--drutewomr1ZQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
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
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C6BC7100016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n6pfp5t9ujfyj7tbq5wpf387u8wp8yek
X-HE-Tag: 1756227877-133028
X-HE-Meta: U2FsdGVkX1+f6Q9VKnT0ity0n2BWz7uI1uqX84K7mkkBZS9xsKPxmSMuoQk2n39MSyPwH8mxQAtxFsMWQjTpTn7nEChXoTiW/wfCcQbbPRLP9T1egcQIaqZIQV9Fm7JX6elpHn7UPWraDlmxCIYR4gZKTZI5WscCG+d2nNZUxBKKi4vfR9dvwkkVVqj5xGSRxGLPzQ/XI7jZCtWASwO1qMpNSiKpiJWwv6xoPCe3vQrl6LiUzEHEjr4bExR+pzUt/b7h/11lnxNIEVUz38q3mrtIZlOOi+eryxE3wRToVpYzQoKFr9ZniQjOo8QakF2KFmkp6lBpsccjjx85iZ5fQtTGN7PkSYD3WOdgdAv7mMCUG8IM0EVwbKx8g0YibHffvjmCqWBTzpry+oMp0S0Xzx1fy7NWs3DP22ZlKD15RLaOA8r4OF36kSxoo/grbnNfLe6i4IlGpFVaOLlcMoxuqROKjzqGcSx8bARRIX8F3YQUWkgLjlq5FthLUfguWsPm442gIGLteCT+BuwFmWbmH2kUORwtxI1YOaOADel4Ow8U2WdP0tqA6pFoDsEzRc7o+CILfgyyL5VBT4dNATksut1K2qLxJEMQDUJoTJj4eSuCGTzuDiSpNImKWhIKtVLc3QN6QsEaFw+Baa2Qi1DN75q6LInm1Z142M09BHct4sLXAq691hG9rQttScwYah9NrAQC66KYKof9L2YZI2n+rNW22xgfx++AiLHkKnPv/1y09rolJPnz4JlmxJz0bBJphQKgbLkTPIsbw2B4zkKWd2uj+FYgI7AqQ/NsFnZdrCSEl3AXhjHZOeQrsKKz+dbkMK2vWqRbR/CAWshykcjt7LHnbr8GjsAJzIH1161qDdYT7u8BLrUczEGQGFoSVhgvI2mxVEfRTxy5W0ugfET5x+W+qW2DU8CfLiIegwHlBeP9siCMnapJhfjWUm8yIhmb6hgQIz+AibYeQcSgp3t
 SuiQWbNJ
 5n9ryTXhfxa5hZue91HJxiOPwx10XI0C+AU5gHFpMX18ABartrBroMW6nhaxoKAl4qnojjZNQCF4QFsoGCOkaX262FU3pVralPxoULgHVtghOa2SxoEvlW8GxCWpMJqFOPwno6aXnwLUNYrI7NPhLmaCcMv9FE0o6aijUB5XamdFqKZYjsleQDuV9jggbgreo21O21NsEYigaMXZZQXqgAaI7OuY3ABcCM8OK3P3SwHgo2xgakbvsYkJp9Ic09MeWig/A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > The existing interface, with the addition of passing a pidfd, provides
> > the necessary flexibility without being invasive. The change would be
> > localized to the new code that performs the FD retrieval and wouldn't
> > involve spoofing current or making widespread changes.
> > For example, to handle cgroup charging for a memfd, the flow inside
> > memfd_luo_retrieve() would look something like this:
> >
> > task = get_pid_task(target_pid, PIDTYPE_PID);
> > mm = get_task_mm(task);
> >     // ...
> >     folio = kho_restore_folio(phys);
> >     // Charge to the target mm, not 'current->mm'
> >     mem_cgroup_charge(folio, mm, ...);
> > mmput(mm);
> > put_task_struct(task);
>
> Execpt it doesn't work like that in all places, iommufd for example
> uses GFP_KERNEL_ACCOUNT which relies on current.

That's a good point. For kernel allocations, I don't see a clean way
to account for a different process.

We should not be doing major allocations during the retrieval process
itself. Ideally, the kernel would restore an FD using only the
preserved folio data (that we can cleanly charge), and then let the
user process perform any subsequent actions that might cause new
kernel memory allocations. However, I can see how that might not be
practical for all handlers.

Perhaps, we should add session extensions to the kernel as follow-up
after this series lands, we would also need to rewrite luod design
accordingly to move some of the sessions logic into the kernel.

Thank you,
Pasha

