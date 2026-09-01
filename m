Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F42C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2510B6B00A3; Tue,  1 Sep 2026 04:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228AF6B00A4; Tue,  1 Sep 2026 04:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E8D6B00A5; Tue,  1 Sep 2026 04:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71AB6B00A4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:01:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 761EB1C1E3D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:46 +0000 (UTC)
X-FDA: 85164449412.16.4A72AE1
Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	by imf12.hostedemail.com (Postfix) with ESMTP id CBC4D4000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJQa40UO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTBrZZpx5zoPkhwnTnNjv/+juqMhukP5Qr6j58UXze0=;
	b=X/l1JtoZ78FAFKaswX2BydCo9JmnLDE5ZWWnGEravuRYMauR6uBaYeqAs5TsQ4c1LcUyvn
	XHrtv7EwJEDASIXMH+vbM31sPaBFqiHY8NYcRyEtQtdMAEOYWOHjApr6IKxE5MOMMCzR1w
	2jTH5NHjR5jhGM/ZCztJGLKTbG5lRHE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJQa40UO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249704;
	b=tUeXK7PhQyxdcxDVT/GzzfPe0ovJFrOWTfDEaxG5tpQQwzwERGyj+NaWOO4KILkfNmqUiP
	/P3Q3M2wpLM+KEgBS9CFk2YEJWz3QDTFjUgO+dznd7SedYWpKJaomAvFaj3jCLxsk1SiG/
	av/RVJooIPgaPp5N99JfnOtRncFgI3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3P9E5Gl1EjxsctRSZt48H99/ZpRYw60ocxNGWi1RFnI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788249702; v=1; x=1788854502;
 b=pJQa40UO9UQHN7ajDgxqllZtiBYy9OuWuBFtJlpyTkC82lJo0epx856D4xMKboHlkoZWFTOZ
 +8lLWYTPt418+NlO5zSETH+4LtmHq8xC2oeCDKNSkRyoJ7RFdGyed7gpwAC/G7W6ewwJsFY6cty
 3JDz1TN2c51SfxykPgxdjjrc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a86daf4b28b58d77;
	Tue, 01 Sep 2026 08:01:42 +0000
X-Mizu-Trace-ID: a86daf4b28b58d77
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3361e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:01:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByvrQmry/LwTktqewgNTFyiRzwl8zqNZXk8QFXFBe2RiDUU7GGJqOoL61+c8zOArLMfbf6I5gnSqA==@kvack.org
X-Gm-Message-State: AFuF++lkTuWcxCf6oRNq/kTeG8HheGsGo5djflgTks/gdJiKN2Lre/Fu
	Aa4Rk4uqxuTlhrIGcPMw1kSF7IyiA3E8Xd8GFafUJUSo3KLo2VjjygOsXY7v0Dn3BjdUCDTO+xh
	wKXEq+1VEFvJCmX6hBQJm1PjJudhDabxPwaec3bPE
X-Received: by 2002:a05:6512:3b0d:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b5fefc71e5mr128710e87.0.1788249695751; Tue, 01 Sep 2026
 01:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-14-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-14-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 09:00:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyU1Ldbw-qqdQOx_P8jrt85QEcKSGae2h+AahsDQdbmLw@mail.gmail.com>
X-Gm-Features: AcwNN1U1NN91vo14dSs3E4M2DDFHxxtZ_83sNMiwJfMd7svq3f7bIIAQvr3cTJo
Message-ID: <CA+EHjTyU1Ldbw-qqdQOx_P8jrt85QEcKSGae2h+AahsDQdbmLw@mail.gmail.com>
Subject: Re: [PATCH v12 14/45] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y5y361673hgpns8atzh35ssh89b59m7d
X-Rspamd-Queue-Id: CBC4D4000B
X-HE-Tag: 1788249703-743703
X-HE-Meta: U2FsdGVkX1+73kHomBjVhamN9YQYWoD8oIu3wjBQWay7HLkDo/ZakWz8Sm1Jl7yhPf4Rc5Bs5CYDztf+ZJhikQMazm6twImskn1rdah6A1cL6hryc2EWw04HLs8lW6XS9cptIknW1peK9C4UDhAzn6U7AqD5OptD35P0p6MUWhARaA3Hwek5NgLKQ/PQNYUhukKzovjmOVir8jyPFcnGiugON69d8vjmxSvzHWdY/E3q/gIZOsRKd3j8cGagcaitbZuInE4+kojcAFo6PdUb61btZgX1M9uJdgujzgcBK8AhkFAABmkeJWahbg7yFh8zgNdZL4yT9Brzz7acQHnaVefCNGwpipL87zL7ddib4QiugCX1ptDlcZoDKzXoH3sl5vK7DfhbnjrGGM2ryJVbP0vkNA16mqYnTH7FkxTI+MmnSzBki53voBWwMb5flF+LKRwYKvFUTHBE3CqeFG5S7PVE/Czi8HwhBDks5FSXSCQNjuCHgqUGwvBAW+dzP8/nBaBTVQ/Y59COkRmYnsAZyotzMwZ2+h7UcKWQ2ZLoxyHDw2DOpWrysc+USnfD2OEXjMWpRS+8T+2K3hOVxOFqkNFFoY3ILVCRaTK9b2M8qb2mKdUdU6G/mYNM5HonnnmFD+2Wblhia3fFK+3DWfxQaoDBF+bQF10BmBZz11jBR5AWzgKGQF8LKWve/b4RbUqMFrbonuWnE/C43zBSACkqsWa33naFTOewnbg8dDhD2q/hSyNw4xafsoTXnSNCVhQhJexK39nAo+dSmbHcUifxgv5deFx8ZFuC2oR1M9PVKuk8aIxMOvXZ6RUxGc93863u8s+EQ6Kp4RbW+cdLB/J6Hs9TFUhe7Z1cGSeQZqSxNRxWLSPH7acSnjRzB4tJsr6k8uF+lkDo+5BBu5kg1QD3Fs/qo23SPES0lSWovK4Z+12lNvuTmLmU8xhNrxIB/aVTJ9Fb7+8F61z3p+s9GK/
 QcLoKUt7
 taAyvh4XrzAkCpLefG5AnDAQRvM4Kr8nAfxsoDT/qZaTKB2UlG+MSn+hXizP4hBK8/L9geq36ot3Dv8AWW4FCj5iZbHppWLlZtpSDEmm37NLlhrebgw0QXdtCovZwN//aiKJy0L4Ivq9VuY5oFTsZhvjpYa0EQ98zwNjnY91rKeyXxnlJZAvJLoK7dVskf/P9TkMtklGJByxFxklMyN68uZcrDDBM9vrXXiCrxo5ILskzsF/sqkrMRMRiW9tqlNyyPWX6mnAQ/R0CJDi4jrC7aFYgRvseDRXYKDneTBeVeGxCP448s9NSDPVvoyk7crSIRd0V28WoML9CD1Btdtcy8XD3m9x3bii0pmxeC0Wm0827hd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
...
> +.. _KVM_SET_MEMORY_ATTRIBUTES2:
> +
> +4.145 KVM_SET_MEMORY_ATTRIBUTES2

This section number collides with the existing 4.145 (KVM_PPC_GET_COMPAT_CAPS)
below, so api.rst ends up with two 4.145 sections. One of them needs
renumbering.

...
>  4.145 KVM_PPC_GET_COMPAT_CAPS

Cheers,
/fuad

