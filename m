Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54190D3CCAF
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 04:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC9F6B0088; Wed, 14 Jan 2026 23:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194286B0089; Wed, 14 Jan 2026 23:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAAC6B008A; Wed, 14 Jan 2026 23:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0C7B6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:59:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36C6D1401D4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:59:06 +0000 (UTC)
X-FDA: 84332993892.21.0D48E62
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47EC740005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:59:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C5iOAPL8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768453144; a=rsa-sha256;
	cv=pass;
	b=dTBV21pUXSAFkaSdt8J7qqYjRTBaRL0B6ttgUjCkWW645q/fzwYjsAcMgQ43rAF+n3OYsJ
	s2UYFM1X61LGnu6ipTv4NWJb1P8z1ZJGela+TGt/AaQcidTJ3U/NZ6I7aHQyrcqnn/6pfw
	s6hye8gfgHoXtA/zXKZTQKvErtU2GqQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C5iOAPL8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768453144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCIZ7u1zkfhqx/Xu8mDhsqq1oVpgqEICDeEKgd4jWME=;
	b=sSYhp39Zn6wFv0XNUZ/mG+tkFK2CGKa+GXanHHpvm3oa8twLYdmYcysnRyAzUZHAmE+Rz7
	bWu3DBmH6ZgNgZ1IIhoMN6h+PNPUNwICRBF+RuVlnInM2bWmZYc1O6wgusYfH36sL1zFGi
	kFUijw51GxFh1IIoOZqU0bCIgyzD1/U=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-501511aa012so344601cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:59:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768453143; cv=none;
        d=google.com; s=arc-20240605;
        b=bkTRXPaZ2cFISyA7+Aj0y8Qsov3mzyC3+g7XbpaVhhvQACY9g9f2XplMsYFFXed5UO
         IhmXTBIMrbDGW1sWRoGvyZID4SKDi/c7kGKixiu2eGxKWVRGEVX8l85z4Hiaw9O2HoQL
         kasJhz0yzfVGzA7/+zdCJLJrf5hTZOUYVnuHfAwVuGUXOXT7QFgieAukMIJrAoApMlgm
         GrM+FHx9JApRaS8PDez3rl0RtueK7UF2zVk/izUTcM51o5FVHqaWX5sEwgbMvL83bqVd
         p6AK9Rcmys/3PCL/1M3gMyL80WXgqCmSwUujqnJFalZQULvE5EdI9YEiC2UppF9rNru8
         xyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tCIZ7u1zkfhqx/Xu8mDhsqq1oVpgqEICDeEKgd4jWME=;
        fh=CzrEdTeWQgGu66Vz8QkRJKNUbw1tbz/8Yd2+OWoMhNM=;
        b=bVX96vhKa04rmxeQtLRegS2qRe21dzWu156Q/eU0arPD7CvopS9RpQoigb/ikONtVN
         0EjbTVUnmpjQB/2lu55/FiCm8C3I0jvGM72NPt+P4y5dXGqAzPm461c1VQEPWswOpXqH
         UieRG4+GCOOoYfpLHck6V3vuj6uFAC/rHirDbeGf2NeIk2HA/bK65g82Tg4E0c08PIkf
         K0nJeB/WshusZP7CZpY4ki5RgZ3+LzOvqIaik4irBXzs2rd1z51f/h0M3Bn+f9q2TGql
         EPv7iQbzA+5tXVX+Bknlvd8gO6Li4KuUu4rIICyHJNBRGXlP3WX5p+u44y0/TJ8Do9B1
         br3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768453143; x=1769057943; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCIZ7u1zkfhqx/Xu8mDhsqq1oVpgqEICDeEKgd4jWME=;
        b=C5iOAPL8EZ+yzGQZqZ1MWow4/cSt/NmWFm+5X7IS+SkXxvZnzMTmnuSLYupn+U0kH6
         shU8cFCbmeYDqYWzOHbO32xV76zL6EnjSRlnBPaoeZWy3QAi2ppKHpC8z4Lvhwej7MdW
         Q4ZQUY4bQr7F/Hh6z+k5yux4Lj6zUjGI6519etMN/kv+M/2k3JDhDOGLgLbjbqIpnUv5
         ZXQq37V8qqSjoj0xZvkmUoKqcXvYzGMDJaG6skv9Hc61pl5HiTvhZISs12v1D0zweLPy
         MJV/qGCEg3WeXse+gkrarPeHD7vub2H0v/qs7omFofGqWOpLb9yfvPIgJEZb3YSZAm2H
         hlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768453143; x=1769057943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tCIZ7u1zkfhqx/Xu8mDhsqq1oVpgqEICDeEKgd4jWME=;
        b=mkjtGeSd0kv38nZgzIkBiX1uSSJWJuq6QOFYv3eN/zPuvDYSxkHgMvFTz29b6jVYqy
         4IdNsDTSMZ5rsqvDM5Rx+66diTB9WaYlQUSwFEp4W7UYL/kvRtVEfTIpIJmPBwEm0nuC
         ZjHdYewi3KYqRxYO3ThP/DojWAqZizcqRgmvSW4SKMeRRE4fUjIujTFj+d5yjSYeL5zG
         dMbzGJgqbXYKNVZ1PvhSCzGQGxeUmLhb7SLHMnkpP6Mc2tsAde7LV2K8Nx1Rf3BAueje
         B79mJm3kEoDeER+myUaXgHFrI1Azg6R58+uW0RBuWwaif2Zkq/Hy2iItSpZvuOFRsl5J
         rFVA==
X-Forwarded-Encrypted: i=1; AJvYcCULYqTWDnkAyOAMZRWhE1e2E6mpOO4gMsrBT+8swRk3RE105TgxuQfRCFGfzmKjFYxDiTztMkoY2Q==@kvack.org
X-Gm-Message-State: AOJu0YxX+hV9AsezyzefNLaAiNw/CXFU2eBPxTXB+q4wJNsJKxFDJLA5
	VzO6zDNFOL0virMsWZfh7mKLOzua0gFaaRa4u20FniBGDTIpJOx0c0mgWIWEmPyLdD+qbI6fibE
	AbMzg+TGR+/gp9+ZGtC9Yw+7IUqqG8mXavAQMJmR9
X-Gm-Gg: AY/fxX5Gk4bFLM8gLVY9REUbCIwvyNcr5YMfgrpBHLMZgaotmhuWHn3lbS+fsQsKj7I
	vXyRfKugHZ0lO8eMzFMnnNlnT5zgYtRfgBI9vHruSWYWckKstFQxBNwtFHypsvfC1pQ0yXxHeVF
	xI9s3Zyk5iRMBCtVLPnM7IpYaz8/YxVkMud29h9JIA08HVmiKNF/sjrv38ovuynN8rY5YRAMOoN
	ekfqacKsbSEjaWEejvoscDev+hxYUZvaveHY6Ww9IG0XlFODCw0VhHePj4I5J/OO1N0nVm97Fdc
	cUj/
X-Received: by 2002:a05:622a:1302:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-5026ecda30emr4457201cf.3.1768453142896; Wed, 14 Jan 2026
 20:59:02 -0800 (PST)
MIME-Version: 1.0
References: <20260115031536.164254-1-ranxiaokai627@163.com> <20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org>
In-Reply-To: <20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 20:58:52 -0800
X-Gm-Features: AZwV_QjbSCcqvbMfcBP4zMfCNdzBJ_dR33Z1SBSIBpi_G6Pf9vG32tYWEzmSoDk
Message-ID: <CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix rw permission issue when handling boot parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ranxiaokai627@163.com, kent.overstreet@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: trasefj45cfbocics4kjgrdbxu8fe14m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 47EC740005
X-Rspam-User: 
X-HE-Tag: 1768453144-563871
X-HE-Meta: U2FsdGVkX1/ZieOeSRfadOGXpp1YCabXMpgeVSN3b4+1UGbtmrXjFh627FpFDLub4VB4hV1uZGcEeCVAVFeECFAlMkIq+bSYWRLzy76x+uew0C6LPi34JWHVtL7UhvmKQkD5Wz9K6JFvkyTwL3OWbkrus6n0CPBbhav/F29jr1HG+A5G0lLK+6fjpX1w9uUzTez4KBUpq7d5aGZVsXg1fYe4OxjJZnoFEMphHiH31hVOB+kLPIieYJRdLaZVyU6R5l/+LhIQBSpFolxBku4yra8hajNMYJwSB5F62LfPFwSzrQG8V1mdZEVH9P9QJnZ4nvAQfc4CcVerevlYUYfnvj/XMwbmKGsPqsbgLtEUZOQvAH2HJdB7fSCOnoKOYwv/qmRYMWFkKOKcaZTcMJu3Z0C/kdfoBYzaaEngzs+JRXBcUHdvj/rwUcG7ypDuV1YC/4cq+jXzDNVgMsgtJLOypuAO8MRP7WDBoXZfNcZ2IfyzPom8Qc/D7VIOGCSqTJpLIcTitdaC0zc0B64evuNH4AfUcYmS5lBtHx9vgQoDlMtCSJ+xML8YqDjwkhOE4PgUt/LJBVYGgv3HIj36+xUmVUHbX48TKrohqe1//U/eZT37sMzK/1RR9Fzf5vlnaZhqNlLIQ3dB18keOtE+freGXdjoQOK+aCcXrk6x91p449iUMX5L9Xr11gqHk+55Kpv5Ddb9CGpwudzpGRCI56PEUsjPqL4zNFeUwgWiC4klLvNwxzq6Gc3cwaMjWwbdpF6q2RfMnq1tVCbd/9Ndz5mMwJUY2pEuhk635mVM0ZWDZrXFDlUShvKlEmhEWJWNLKln1zFjwTUBaOD2aCnCTwIrJiclg/+SilKs74h6v+YipOczKs2f3I8Tr18TNdSyWA0vFiFyo3KW2t0h7BLV7t2XAqNAuMYmxzbG9VfmzElxErQNOPWs1AgUtXMMmlipf3yBBnjuqLo4JsW9Vga7hsS
 AcbQhBjS
 Ss/CY2bC0I+Qtw2hJ2Y27ksd0OeOv9yqLoHerLI6KYSH4BjUDW82aCMFSq7y470Uzl4U70RlMueVmtUMPp02YSGhLqHRah+3TdkVTTmdxZEskAsnLZwBcSb1iRclgeRagd6bhznzuYi33Olcvzq4W5YOqhTfj06Fx1qXmVt9N40/Wj4uVvt8rpX8lSVt3g/BLYkqJEF2w8O2anPqkfciDbecJMBM1Cg/PHiOT0MLxhPckf4TFu0vfFrlarHcguMTJ1DRPuFrrKrZbB1niKmXatNHr1YEL4N2SAh8wSARTcuJghpxkYwawBtP/NHg8wfyatUfK3QImYNTsOX4ZnnarQpq3VkoBrH6agIUju/0A3Uz5H1hM3LkVwg4xaFZQGsirwysZisCoMBDapUhuGw8ep6Ux68irOZAM6QNqxqa2e6ZDlZukrfKRdWb87lWZ2pCSfYm/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:23=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 15 Jan 2026 03:15:36 +0000 ranxiaokai627@163.com wrote:
>
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Boot parameters prefixed with "sysctl." are processed
> > during the final stage of system initialization via kernel_init()->
> > do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> > the sysctl.vm.mem_profiling entry is not writable and will cause
> > a warning.
>
> This sounds strange.  Why would setting a Kconfig debug thing disable
> alteration of a runtime control?

If debug is enabled we don't want the users toggling profiling on and
off because all allocations made while profiling is off will have no
tags. If used later enables profiling and these allocations get freed,
each one will prodice a warning about missing tag. We want to avoid
that by disallowing to toggle this control at runtime when debugging
is enabled.

> Documentation/mm/allocation-profiling.rst provided no hint.

True. I'll post a patch to add that limitation there with description why.

>
> > Before run_init_process(), system initialization executes in kernel
> > thread context. Use current->mm to distinguish sysctl writes during
> > do_sysctl_args() from user-space triggered ones.
> >
> > And when the proc_handler is from do_sysctl_args(), always return succe=
ss
> > because the same value was already set by setup_early_mem_profiling()
> > and this eliminates a permission denied warning.
> >
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Acked-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Should we backport it?

I'm not sure a single boot time warning produced only in debug mode
warrants backporting. Do you think we should do it anyway?

