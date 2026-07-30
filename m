Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49159C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461B86B0088; Thu, 30 Jul 2026 13:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438BB6B008A; Thu, 30 Jul 2026 13:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F6D6B0093; Thu, 30 Jul 2026 13:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6E96B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:37:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95EEB801ED
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:36:59 +0000 (UTC)
X-FDA: 85046148558.04.E45279B
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8774E1A000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:36:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Di9iLuZp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785433017;
	b=bqoaSU+kn+sAt6XQWp2kT2OsX49NSgwY8WziUztYzcfqjZ6t6v5WNNUr1ChmM4390/SE5n
	OPeoh33VsEng71ZXjdKL32cnZGi7i8nRrRmvX3nBYqAEV44+XoMUGdN26jdK1jv3GIm+2g
	BC3tWr6Gpyzvmd4ZrbPufX7oXtEkk+I=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Di9iLuZp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785433017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
	b=BkRNcduKK4JvfPa0Fp9Mv7385XBIykK2Fd9wGuFcYR/KByfwd04lAI8AA6jCRHfiAC+GFe
	kpNsLDKcbG7I1itS1v/r30UyTMtGkC4cqnX66qFwASnDayVwwme0vkUsYKU4g/15KTTQy8
	hk95ziXSw/81gepEDUbwPUaFQc3y7Rc=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbb7926836eso32972a12.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:36:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433016; cv=none;
        d=google.com; s=arc-20260327;
        b=YabNv46YEXsTSH+4o2xpV9vnSZo/RtOX2V1qkg4ZEZ92h1d3w9akXJNvlRKt3FS7i+
         pgd/TRRZSIikLIzOmvfLvum58+1ZQ2I0IOLZ8nKqTjDt8rMUG0TVZ1TVtCm7b1zQ1YLJ
         qGjOPBM3S6PybByXTSThShaida25vhhrhoxIormUzxlIggBtmNqrASzlVQtC28P79H56
         hSP1EgRN3ZCs51keQitfv9g+pSld7JJhGsPpBouk2npaIfPeCmA8rXfNzBjXIvYdMyLu
         tDWL45z/Fuubwm0eWM+y8JsNUma7A18vVlVKYT/GJbGdUMjkNnqpjBfLCDkjnYceLuR8
         CVQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        fh=mFZLaAW+UVwWf6H8UaUr0x/1aItotLvvJJZerYiS8RM=;
        b=sfV//Ff5DWaxfHnv/1KkBmrgbWjzcMCuwzfyJTfQ8VbdUdsZf+HJGW5VxmCUj9qjKW
         o79ak4/8ieQyhsH7ZNQsCg4lbj4pC9mfhoq8J0+6seot5D86dSBkfyVqrg3W9JJR4lF4
         B3t7XHLJsWrZ8/wNgsLUIwGXAMl+m92W+ey4GmKGajckuc4N+/vLMkeDAMdSXmTMpRQ+
         8Y3zB05wSROmTb6DGTJRzSUIsM+DENwL2wa/wv8xHN2yK+shAvLn0N9h3BoGGczxzXxG
         lPZwuYcl4u11u3UxNwMX9dNYwERZD8nnfzpoOKW5g74Kc7CSA841W/Y9Jb9IbgqwdjQF
         8BDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433016; x=1786037816; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        b=Di9iLuZpdaCcFnQgF4b8qm9rZBhYdx3t8ixqEyyb1hW0K5SufYDz030me+KA880wae
         1X3BmYdGW975QqI2j34zBXSjPeX6HNlxwWjKOyoCfDsBgWlJU5gUWvx7qF/vbuzXleWC
         YthkPeD/evHG4goBeSjifNSjAb52l44XdsCdtpNwCcKdPTUJHmQinBjc7wPLNy/4x5F1
         EvPzG+3bk98gA6d6i//kMSxjd4s7fnHqjbtR7NPXu/XP+FqhHzlKs7enwUdinKIQJENF
         C5miIFDU5ggG7UuGcb/W66N7t9nwoZgjDjbtLTvmHi5sTvPiK4jUB5CODb9z8F5Co1wc
         Mpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433016; x=1786037816;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        b=Xt/3cGPp7mEvBA3NF8sMdTUExHgXq3yC6yaUQKaOIRJUwsjFEkxF5lucJgIE3JIUi4
         yP0kt0ZzupPVn8uBQJe002FVqmHmbpSmIhyA5OZ9e+E7jwHHQaN5iCzz/m6pw7tIzx9O
         spRg0b97pFa7kZmyh6xPwtBALg1+LcuhQMMLBs+BvHg3qtZNRPqdaV7rOyfkiio32xyb
         pcpCNAwZMbDLZfIn10gAZqZC5O+z/50VPdhLKh4lT4y/TMRTYg8IJKFcETVsgiGASuIM
         nVDJKDMibfudHZd721fzXAzJ5j051AXxR8aeWmBbfsbU9Np1LnEXkV+UylAQDb4nTeR8
         CBKg==
X-Forwarded-Encrypted: i=1; AHgh+RpNoj0wsuF/RsXxx421G4gHrrJVVnPKI8Y0sRko21Qh/OZb5f5/oXqPi4daIOlCMcqYRGdkAhtCnQ==@kvack.org
X-Gm-Message-State: AOJu0YzLe2ZBaTJx54AgLBigmJIS+T2LO9QmqlLmfUPXM55hoN1rnFmU
	404XGuStnlJfB5B0VkRIrxQcme5vQibvlPSjGjqNjA+JdupZEACxACR2z3FLMrjNtmajwCW96YU
	03w48fVvBW0xEnI75dCntGmOmkVP6gGy7NGEA2xpR
X-Gm-Gg: AR+sD111UhBTjKRSVIksZSpTjiLIZzT376LyHjcFvtwYZ2bIF4yV+5TR3+nx+RukgLB
	4u6l2SPfYAkJInNcYGBXwt5EbvvKpalP0feInwK20MrTQ6QAOl7fLPz7PEsFpGatKb4edfHnePB
	QjCECvC0Pwe1plXq6I0v7OZrQd7wWWB4ZXmftiKkxkx1saX3QiSYseGmJh0wWAWqxwyl22IRArn
	26BYDKusvqGlCyAhqYzFO1FRp3cO1WMIfdyVANIH/saQrPJy80Lv6GrVvd+GiRlMuFmEYoXbBE1
	nbmO/xwp5odyj9p7UEwdFVrVdZws8A4SI/AV84T58MFo6qE1eEKcAUtKDOKGjJ4eQ86uzjWQda+
	vN/W16DJXkR/crNDHf53+Ui232ERMLHE+2A==
X-Received: by 2002:a05:6a20:d805:b0:3c3:8651:b302 with SMTP id
 adf61e73a8af0-3c90072a2acmr3423693637.28.1785433015659; Thu, 30 Jul 2026
 10:36:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:36:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:36:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-3-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-3-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 10:36:54 -0700
X-Gm-Features: AUfX_mwFoYwitx3VhlqJDH1-k0l0ItJ6i-x625ej1dYBsVgzkh7R-MZiFMgMH5w
Message-ID: <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w3btwc7ygeosksb9d4cggy7eassg3m8b
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8774E1A000C
X-Rspam-User: 
X-HE-Tag: 1785433017-31210
X-HE-Meta: U2FsdGVkX18rDgQ3p8HwEKYJBCHhhl7ir7UPg0h1je9m8NFVCYTSNWBTaMLTRoGT3oZ0nL4gc2w1nGeSEXZNuGF9mNKvcbwqID0Dt3opDXB8iGdugtBIpJUGSFSoPDgwDaeA4EKtclWGb1gUah/bgxB5qTzZ6Z2f0LInnDSR684S86kAh/XpHrm8PKofPHifsG7dHC+Poa4uWVRa9hJXru/r9b9U9DgBjqG7T6eF2X6EGDXSSlekmXHDytaSBjhO6SCxI2vVXtAkLDuO2Nmyw/EnNSiP2Lh7CQ72wjFCP64leKtiRnEDrhyh0KMTyUSQBVlOQIXk5BmbPVG0qACmcxG7LrYV5AorpdyCk0phJF+qvP6l2I7csblKK9FPeKALhtxQeVU231PMLGo0KvJdBp99/kpj6267XwAo6BYljkP6J2NrMapF3ygC4Jzkw5um8+4DH4cYgdmSsKMUzKV0LeHSx9l8ramfvYG6ziKpXc6ScWTZVkJf9/6fLhWcL4CTAwYMh4tYzwCqrPpotndCw+LR6ZwRzUCHBo9sEkNBtpgCCJz4D/r+D9DAgX3jGK75PbX4v337M13wV9ZsH0Il4eY7F0fDq94afYFg1MC1fwyF2MSS6gqnMU0bpNwVo2aL59yg89+oJTEpMkMRkcLCfIoay0PH9hX5Kp1aO/9U9+PrmV/mZl2nOJUg2dFmSDkLH2rHj1GPEcUDOlzukMl4udRaBpSqN0gWm/RfvuPEGdxxKcQxJ53XwI1zyLECYW/MEKoEhjfQDBvl+A9fUGX2OHSGZsCgl9DebLuRJwYsjkA0l9pJQSZKnNG5NkcVCljxwyveXIqPNjH/aJOdtDXUw6ckvLDTVgWxF5n8fs0Bex0e2/MhpiyQCbFjkrjvU6q0yl8pbrIzxxo/oY16Ibywr1dkPBkqxKJvXu02nsk07NjXrBaZ4yVZocJbGo8fDU0d8KWrCRjq2KzNpdOmz/k
 LG51HaZ4
 rOoPm6tum9WfmAz9sMTb88fObdASWaiKzlYZyYJ/+xfiVyOf/H/GYkl3wp5sLnYpbujeEhZfkkikeFm1txP0aknbiZqHAaOYXJMY852NC9vxRbuEWITBqz3voEGQIQewxB2+MJVBRygX2jHR/elcPZhlbSZfdKuNoTrUSRbncoOXQ67mTNNRKpJemVWhIYiLZhe08jvMaZAnN3YKn9tLCVi8nq1ZoOKfiITgZRIjzoVwuh8UUqdIw4FaRR5AV5PX+jQJ2DddTZRb82bMoirmLkAPSCmM/QCYeiS2+9RVDt9L5Ut0qBgelzh+QdcIk/g8K9/eaqfxcUu+zn3NIiPgEeGTFEa4d7YQOLtdysDm7sBsEHritUXywJnKBiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>   anon_inode_getfile(), providing a unified VM file creation API.
>

I think these should be 2 separate patches.

>
> [...snip...]
>

