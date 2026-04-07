Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DB7FF512C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26916B0005; Tue,  7 Apr 2026 13:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7D46B0088; Tue,  7 Apr 2026 13:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC65E6B0089; Tue,  7 Apr 2026 13:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9982B6B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:09:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1579513B470
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:09:10 +0000 (UTC)
X-FDA: 84632395260.28.4F6CA2A
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3869E80002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:09:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kah9W3Ms;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775581748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb9coQca3Zd+zQgIwS/KrYzVgQyjmsyw37GVCirWHqw=;
	b=ErZCNqiFP7sGwKCmZ5Ses+f6L2S9G4cE3+xjFZeC/knPGb0phsnWwk2j4QmLNksnajMDpf
	DEpveUaGehTMryJYbDgcR+aFpalhhjNLOpnmptFzBGBHFnVPalxJm99T7qtGE+nXXDsG9f
	HbWfr9CNhF1MBSvqF3BhyWfZsZ/dJbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775581748; a=rsa-sha256;
	cv=none;
	b=aejcKoO8yauBd+maPuiHweg6xqYPYh/6J6qquyQdMXsOXf//tJGFMpwWpoE3ohuM7TqzrD
	tAsC0DX55cDZAo1sAn1skgvkUs4hNG9Oj9+A1SoNmWXJvwPTsCvo0kcwoJLGF/fdd4eChv
	XInJO6fw9i9yTxSARxxgpnT46t94bPg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kah9W3Ms;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8d424af6282so508068785a.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775581747; x=1776186547; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eb9coQca3Zd+zQgIwS/KrYzVgQyjmsyw37GVCirWHqw=;
        b=Kah9W3MsocJP8FvCjcmrzStkFVdg/HJ1saP7SD/aXbySf/D7e3wImW5ucgyuUBWZ2P
         ZE0RPKtyXrbMJs2HKTZSpDiEjuDlMnQE3vpqMum/2QMGl6+b6wYa2lQg38EG1n06GN9B
         G3eXKd+ra7WpltMNp4+GnbjJMmwSH4PEfK51mZfAZqn6+eTZK3u5isLjWMCbtZ9/erCf
         a5E7mHMNC8MeFEDWLMrMbpH/MgDaVux8++AACZwSH9o04RLFtc5/UiV7jpwFHzPymxqV
         A8mXxqP0MtSZsAuy/+1Ir/5nrwk2X3SezEiYd8T3/8jVMXjHBALUehczCMomb53Yxm5I
         DpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775581747; x=1776186547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eb9coQca3Zd+zQgIwS/KrYzVgQyjmsyw37GVCirWHqw=;
        b=H91vs/yeiPfZsCzeSE0y8WaKkeHJAfpIXqq89Cq7h8FjxT8rjFt6VvOWKXW93rrCUQ
         jvNHDglCzvul2Q82IHaoft1WO3zzTFX6CPEx0ptQ3+oLqAs3sJgM+8jNfgBcH+SMIo4h
         7Tfro0MGD2xU9zRTDnYpBPGUP1+8uPKooguGWGcHE97jgHo+nA1IpWLXo9COMrlUKfM5
         QL5U6nQx4SuHWVwPq8SAO0z7n3Q1GFDSqflABeOSpt0PzOKy5ibluBeRH49yJcyPPlEr
         aMPaR2sSISu51173CwXQ0esWIPUgiHTBoZoAUgWY5NJHy8VLGj1SPOOllLC5i2D6aIzu
         yrVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd7DjPe9bn4MzNSBmKgwwuJSQBwOxjCPFaUnWf9h8rk87X8AKFdtXkL0QZhmKzv/mDnhK8o1hbMg==@kvack.org
X-Gm-Message-State: AOJu0YwiBjxpqQi6ILeP0k3ZI7K7oX82Ky5p6zLA/JY7rj5Zu876uo7U
	l3p48CY4jOiXGz4O0fgIWbRJ/OApsxIe+1k4SdalZkf047AfxN0zzArj57aUlhCRBo0=
X-Gm-Gg: AeBDietqXCmUaNgDil+PCs2FzLHN1/Ux2V2Da0fxCHcpVNnWgKzOoBBVSqIFzonfmcH
	gvaYR+fOmm5B+416AqEewtKb69bC1NCAJRgmJjVs4Lq6ynE85FvfX03oWSVGiA6+0X4kFv0yeoK
	v5cwOXUriP0iPNbTheRUwJxYa/k/6WMqXZEmhZWIJhWp7odrnpOJIIbfY9oBaOgJbseXHYSirjV
	MXAFkzafu3WzL5MZWLN33F1uq61gY4xinG5lzjiBIferXZy7H+ZZU3FR19DSPnBoW3eMo4fHKOf
	sJfYNzq4b5DA5jbYQcKJgTKrnzc0zN571rY6+0dggbT5e5GUW4eeesMrhBv9QrRYNl8xywioKwA
	kFSQab8QenHhyM7vW6ZanxVryUqj6RtBx63ZiNBxpattIWknEfkIVL+fQ59L93wbDqYzlQU7db3
	ANj+C9YhbyC6DXgZUO6J/b2cR+G7mFyjdHSpQbhJxA/7gW1Q1X3InR9aE5UJEXNUejnXa2eLJ2S
	tDY8Mhy87Bp
X-Received: by 2002:ae9:e215:0:b0:8d6:2beb:945c with SMTP id af79cd13be357-8d62beba34amr1394722485a.41.1775581747216;
        Tue, 07 Apr 2026 10:09:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5d5a096sm1359165885a.19.2026.04.07.10.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 10:09:06 -0700 (PDT)
Date: Tue, 7 Apr 2026 13:09:04 -0400
From: Gregory Price <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jackie Liu <liu.yun@linux.dev>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Message-ID: <adU6MOCggHJ3A-n8@gourry-fedora-PF4VCD3F>
References: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 3869E80002
X-Stat-Signature: nju7z4ka9egyn5s8akyfwfmnfu3jqkid
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775581748-626267
X-HE-Meta: U2FsdGVkX18n6b2zAQdPB+Vs1z5Rg9A8HEkPQR0b3dZMVbIPz2aU037a1MIHV4f3xEtzsUf6zBekxqgL8M9i1KyNquEntEDKYoq3hAAfwUD0+xl8+R/CCd0LKeSZB+6kqwJLb/32eqtZswyfI4xQzKUsQb+wbUkVAO1EdtGH21vT6N46eLS7DQ3YkMkCBhVAHLXM8fCEmLNekFYt6GPubBwYKes85AasfZoEX4BOIpRMZG5Izlu7FHbh72sB7mGEdhVC57zO75RjOLs7/HFkm7UfOhaauYV1xHURNcbYwUSTKMCUkA8zyZrfBzJzVoC2uxELO2cqmf1EsTzsYlX6bLDMzfgBrg9fzWIltzchK5aA9HpQQMk8VDbaWpy2LJipVqwcD53HTyEg85efQeqsrS81NczrxlNr31yfo5oU3y045ZLrSKg0EkCqrmCoJd+KYW+fhANzCgjkmJ+f/FPD7j1lohxvjLN6wjO7Oe8lnqwZK9c0N7T5rJp0K3qHtZY4MLEk/kQgwJxRiYMkPtW/D3CXRaKSyspyo13O0NUzSmTjRiD3+itKPXpx76nsmq4seUgWsNGaZbVX5WzArhzC7YJUzOfvQPvMPsWyMjXdiOHZP9GrL0p586a3IF3UNt0Ce3XIv75jg+oW4Y1Diho3mINOCppXsPB2GMwEWdsW9mhlT/JNG/6mxmsyBcvepfFgePj29U3gtfEVmCniIBrI2CqxWR5kFXJlmrVuMgTUzjNgJdgRGsdtUyyfR2nLDbmLeeIrqFW3tNixZ7/qmkov5MIgBFm1okaBKnbdjlyUdkBZbqV6Qbc+FJnAemwj4GllXh7dpn6YQVrUOKpNWn9pod54CKq5Kc1dHCf3py3VOa3FMUzeQAKmmbQhz29XQ+TuUE05XR6i3KsRrCI6iHfcCh/BxeAHm5avFmN5gkPaYPV9+Kwq22uJQA0JzB42AlPRNPU52jRNH4FGjBGX1nf
 yBwYo2Jn
 ZJ5a7G1B0mBIBYbVHscORPg1XnmgH+zmQ/VZDIBfWSLAANBG3wE1FbxkbIfusYZ3n0cKTOtXcRnHfUBMBtO+glKyuLR22IXbRPzTM+li5+qjxEd/2exFZRXIegWP5glAYqAlrxt3ZGr30sNzkcaSFnu5yXi/7AXv/Esn4MOgPUyNdQGjPXtI9iwFjvph8lkhhv2M0/j0HM65I4Vf2h6Q8xakYrRPKju67ovJ8JFkSnRjfPWkK7PvC1EZIN+yqkSu1oE/lVLhWxF9zC9ngy4D/ee/5B2oUO/SDEIOOLZi6ztS4bwoiAptiAbY1M2rFfPFCXcjxR7O7RXoBMEE20D4YmxZLyx19xL0m3ieOkNEBSrLjI+aOrce+6yD8Kcz5PD3Y63i4GALrryIEPgi9HGMuihLCQW5NiC48IymbGzbCySfLUSyCHAuUizPD2EZ7uwBcqlsjJKJWu6KqxDatiNgevyuxB13EzPfjef+oX2KHyqK1tRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 07:14:14AM -0700, Joshua Hahn wrote:
> The __ATTR macro is a utility that makes defining kobj_attributes easier
> by stringfying the name, verifying the mode, and setting the show/store
> fields in a single initializer. It takes a raw token as the first value,
> rather than a string, so that __ATTR family macros like __ATTR_RW can
> token-paste it for inferring the _show / _store function names.
> 
> Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> used the __ATTR macro to define the "auto" sysfs for weighted
> interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
> add "auto" as a macro for "__auto_type"") introduced a #define macro
> which expanded auto into __auto_type.
> 

Well that's really unfortunately.

Is this really the only "auto" in the entire sysfs structure?

> This led to the "auto" token passed into __ATTR to be expanded out into
> __auto_type, and the sysfs entry to be displayed as __auto_type as well.
> 
> Expand out the __ATTR macro and directly pass a string "auto" instead of
> the raw token 'auto' to prevent it from being expanded out. Also bypass
> the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is
> indeed the intended permissions for this sysfs file.
> 
> Before:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave
> __auto_type  node0
> 
> After:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave/
> auto  node0
> 
> Based on latest mm-new: 96881c429af1
> 

> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Maybe - 

Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")


Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

