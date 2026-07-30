Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815BCC55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9FB6B008C; Thu, 30 Jul 2026 18:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A626B0092; Thu, 30 Jul 2026 18:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A166B0093; Thu, 30 Jul 2026 18:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08E346B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:22:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8312F1C07BB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:22:34 +0000 (UTC)
X-FDA: 85046868228.11.511073D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 901271C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:22:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STQllpHS;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785450152;
	b=j/M2UZPVC3XJJ5Mx7sBbStSnVzV71MzaXyAgXWiT/JVxax8v+/yPtsE9XxaAu4FQbdbrnA
	MBGmg3O8lHFJSFFL0m3XGQOH0v5NvvnhZSV0WHeYi8uZc6BoOgJtRf2VN1x5RiLbypz94U
	AtWgCb2nSYUA2NiQ5SuS4+3XUZ83NZE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STQllpHS;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785450152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKK3RxskpKfni5OmmKwhdX+l3ihKYPthumPMEB1IvdA=;
	b=tdawj7F1tkHaz6j5yHyRBB+vKtHzwo1hnB8ELe+ulf6XOaPGppez14Xfl9ATVxD3EaZDgt
	G2fehMYh/3VGew038pMxa8iJYeEGTf/Pw1QdM0iRmqAP4fKmQhsaSaZAgvTAX8toggWvRi
	h4faTS1i83iYhzxc0Na8GKpygRAxAAo=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc61541f8cso14907195ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785450151; cv=none;
        d=google.com; s=arc-20260327;
        b=Q+6x7j5mCwhyZXzF9QB7cbO5jY6oL/Bo+78hf4Db2VaN9f3p0iS/InFs2DL1o3GCGT
         IjMZ7b/ZdZerc59s/90eawz/Ge7S4KDcNXZtmI1H38uIQejArnP7P71j/rxZ4f0anBii
         lB4mgu9oQ4stcfGw2TnDpW+iSlDOH4Juj9s4cBWKi/RTVZAvsq2NafINRXvUWKqueJlE
         JQ8BCYOkGpKrkkqWbtiNw5lpUs1MFUWlPxq+h0/EnU8mPuRrjAQCuXCmtrRCzJPwYBL1
         T5qV1Gj4Ucqp4VtdMMpN09Gl5PLMDAtyRP7cqm6UJENEnE3Cewsn9ihKHeSaU02d7kWZ
         sAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KKK3RxskpKfni5OmmKwhdX+l3ihKYPthumPMEB1IvdA=;
        fh=ir3a4FDRQAvyLOr/1ZM6E82wn84AxephbzM42VKQzhQ=;
        b=SOxY/hHIKvCQwiYqkBBlZ9F0558oh8WPzOthJQ6ET40Fw+a/z+dtkp2Rnq9s06FRNr
         J+gdnXs3fCZZ2WfxSnCgl6mQGDvvHbEGOHYQk6Eaq3nnwsVQkMyTeJXbG0f37evXLA1S
         8w2KCCqpb1ptUGuiTTIJvbqDsRfe4z1ZCl7aPhccmw8Kv7okelsmg4++eYMk5hYfklkl
         XlXb3wexem6qxYSLipLo23XpWpwUlXTVV87iEx4BuoPiEQzICp+0XNnMW0O3Iqmnrl2M
         21zmtm7Te6Eumx2quH7gRzoyJOx/DjZ82IJw6dMDfDY0i5XM0nnMJ5CXfh3rXi99Z/BB
         8Ezw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785450151; x=1786054951; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KKK3RxskpKfni5OmmKwhdX+l3ihKYPthumPMEB1IvdA=;
        b=STQllpHSOEZVsyvv3bjVdVp6C3iSbOcbpRRiBXCbVRpAvkAoNAEdYmuwPjXa4gI9ip
         lgOWhv23tUXSbfm1lohRuujyXdP9oq8pXICZfDD20Zr2vqJIvcIU9FW6H/1AXLF3V4+S
         O/l27mnn+/XMB+bXVx71UmSs+DxJyRnoE5AlXLa/LGBxM4+2GHF95fkgnx8fXFnCuyW4
         Rs1mXCWX6R/hzVJrpfBQn2iUfyAQUVuXlLHl2ibdOkcEYpHMbxJ0dfLLvZDaHjdLDvTG
         NWCGDONsyc09FxO1S8btV0m5BsD64MvU+znqQjTOmf976leOM6uvYnsAYHMBZHpuey4D
         3Png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785450151; x=1786054951;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KKK3RxskpKfni5OmmKwhdX+l3ihKYPthumPMEB1IvdA=;
        b=L2QU74riEr3uK21pzreuw7eb7EuLANTr5wDMvzY5Lv1FnSGW3jzYspZZanbt9YYC75
         tagD7kAUjeW/rJlnhi/vY+wGp/e6WwNY51phLcQyKqd4ckuyfhc7kZ3GT+SSOcFTGW3N
         iJYgX1Zie6Eu1ukbwBMGTUJORksMiZGdyCZtdRGoeTSkxj0R0Uv6EX23gCgCZSyxf0UQ
         TB1FrMI3c2+iNBhLWAtCaFu08JpeSnzmCR1o3c8hWPrT3WsXytPCIn+aOmsNEd7o5tfV
         8V0zo2qoPmaW9wPRbiextwmrozYR+JGjBrIZqd821LKUnOaTbEXnmPmiPQkx2pfbdB/d
         3k5w==
X-Forwarded-Encrypted: i=1; AHgh+RrrwIhWrUm/Ao2ZulOplhHNaqfost2VzGkvPu8mXESx1vpP1Sh3NUAaHC/GVQ8RBlj4efvheRB62g==@kvack.org
X-Gm-Message-State: AOJu0Yw4j7DcUdIRbC8y3U/iiTD8RhUvdsd5+JEjtISWCnZDjjqHfBLw
	aH2uvIEm2ecRgiCgq+zg3UxFvi1SicxDFy7Zy0vVSigp1dXW4oEpBPd7Kw3E0a+5Y+L2lmktBo3
	2LfSqtmCcyqu66VnaRtPB91d8YWfK2lKWUg49MUoc
X-Gm-Gg: AR+sD10V0yEiW1aIel/LrMEo4NHi2EtscH57XQ6teu/3DySZgm7q5Qd5TpKnqqsTS9I
	bZMq+8Yts3pfKH8PcGZsXPgN0moAxuahH93/CuiC6gBNm8JC0wxMPtLYUoDdTXif/UIyGDEBGxj
	Ww3tAV6he1Pgv5B/EpVNJBCwQ7RJp+1MAKc+Sn3Ch++GfE585bXVIwYqBS8aGFxgushZjSXuqP4
	74KHAs+RifCzDcu/CVQIqaouS+EUsMTyhrKE+ZjfKzwcuEK3gI+p0r1Q/TzUL0+8TFJHYYgsUuI
	x0BpIelI5rbR8Sj7umqiYODD7KwyQUTmNm9xeHDh2kSWmkoKIVcW8tdyfiCJbzCWaBMKnAMRISO
	FVfLOelAlOkjdacl48wF4TDpt1HjC8P6wPLE=
X-Received: by 2002:a05:6a21:6da8:b0:3bf:9e85:b423 with SMTP id
 adf61e73a8af0-3c90da9f0e9mr1921619637.34.1785450150418; Thu, 30 Jul 2026
 15:22:30 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:22:29 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:22:29 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com> <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:22:29 -0700
X-Gm-Features: AUfX_mw9STeH1QmcRlHkiOeSUMR5OU477trBpGu6VFzJOghNh8UuiEXaLRojjC4
Message-ID: <CAEvNRgHEDMnz7Fc7iyegC9wrc1R_AMHiWUN_rx=3Ly67bg1dNQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/41] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jtq59uwc9eywn8dzw63yum7b49ee5kkm
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 901271C0009
X-Rspam-User: 
X-HE-Tag: 1785450152-142343
X-HE-Meta: U2FsdGVkX19cklb275ZzDyeNeerBBkRTgb7IKzZmFi1wP37Bgqqy+8+rYmYXBEIziS/1yVCW+QoyJ8hIdlMFaBGTxlJTJJuU0lTa0Kkgcbv/tkkw3TaLAADuQsPhz4KCyDJe+ZzfNQDWNiCvIh/0aRbJwEK8Rbtvd3N/sPnwBY+MgjUEysqOezJY/EEHUat1MP/6T5KZoAtED0tWzh0aOssl+mnPdmNEB58nitOWiCC4x5Bo2n7kUwcB9MiBD27nFoBAwIPWlw0LS8Pey7rv33Xf0tTdX6SmHt2LH2K1QlI3PNIKV8rMiMdjRCEsCO6zRAuZ9GID9Rre/fjgl8R/E3yI7pksMtAMs+1c38YDGaZJ50Xd0psD9HPXZNI7n+CxuEFKMX4qoiMngm8wMxfGyYrc6eer1sbiAcmNv/SnVKwlYAbm98dO40ihcXWOKXNEXuqZKoQqBTtcrx6g12NkS2RHDggzIDVWz4F9egcd8cAUf0801yoqKNL6qzsK3GNHhym6GsqPnr7RT8sHopegH5SpeiAo1ywt5f/dcz6FSkiiAjc+KQSO8F3cE7kCipZmV3eF/H3HAAYN8jpCCITWcruLaZC+F/mmOEAU69C+R3BhfwegmkcIMmkpqROx26zrLrJAaS/jKxcNkiWKxGpKJYoqtfx/skwQ9Ul1CdEgLB5WRUo+ashfJCIThNMnadZYfPVkDobFYWTSUPz2vNb834cqXNDYjAqMYI+0/qRedIqygwfctnr4VFdRnF7yH+mPrld8pPo6OXK9byf9ZJjTQxDAMzcdOerKRml9GJSIYpIJFgLSIT4fj4KuNxxYAjtfJJAZ60QA2TaM0/Fq06TKjL+x0AYNhkc7OW3oCq8L+cVAd9YVjoPLdJ8ghcBp4swUo2/4HVz2nAmaNOJC+OWpPH2V4w3ZQZIGW2tc5IGitkWBDigZDElb+iovC2Cpnp51RqEZXpKi9XjFTO7BqJt
 fnrT0k5L
 Ww0wvn5SCinNAcT5jw0sf/MDKohkszfzUvE82+1sDoFrB057ckTVYg7qiwQEl9AeO4GlwgZZPibud2Myz1MNQovu5TDTalhY+PGTk1kd9xe+92Z0wt8Rz5ldhlq8H6N7/mPAXbIh4GBLgsatq7FJiMS8tx1jLOzSBQz2VSAuXS1MC3sfly/SPVPaO06dGsi+0H+r7pd4gAGtpfibZpsVkt11YTHbfHTxHrr6ZswucbPaHskvrEPA0qwYCJYuqtrpwkTQL6+doul/15O5/Dv8gxqxie1w91mvnudBreQ1JsdMecUJYlinSVR7QydV7+AQoRXksrp9q8TaHcxJzry08eDfeqC/jUhjEcDg3Mv1te1QJZorXDWVSJsSwqM2u0EkdJrw+PzB2pZmupXBnUC7IevTYuwRku4iYxerjzxMqsMTJa2a7nBXcMrk/Tiq2fA0UyD2ynrQ2u2qpfj3VQCVwX/MHTAol6gg0MzNwAePNtKxOqvW3QC6n9p27dAqj4gLQ8S1To4yhfd2GJ4ocaBbE1OkRz8a6B8cQ+neOdbuwS0NkInnz6I797TWZ8IKxfcP42Yd7vU8ug8dDD1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> Add a new ioctl (and matching struct), KVM_SET_MEMORY_ATTRIBUTES2, using
> the same base ioctl number (0xd2), but with R/W semantics for the kernel
> instead of just read semantics.  "Officially" documenting that KVM writes
> to the payload will allow KVM to support partial/incremental conversions,
> instead of all-or-nothing updates (which requires complex unwinding), by
> recording the failing offset if an error occurs.
>
> Opportunistically add a new struct as well, even though KVM could squeeze
> the error offset into "struct kvm_memory_attributes", as there's no cost to
> doing so in practice.  Pad the struct with a pile of extra space to try and
> avoid ending up with "struct kvm_memory_attributes3" in the future.  Use
> the same layout for the fields that common to version 1 of the struct,
> e.g. to ease upgrading userspace, and to provide flexibility if KVM ever
> adds support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.
>
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
>
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
>
> The process of setting memory attributes has a clear point of no return
> because, for CoCo VMs, zapping stage 2 page tables is a destructive
> operation. Unlike regular VMs, where re-faulting pages into the stage 2
> page tables merely incurs a performance penalty, CoCo guests must
> (re-):accept pages after every fault. To preserve CoCo security guarantees,
> guests will not accept pages they did not explicitly request faults
> for. Consequently, during memory conversions, any operation that could
> cause the process to abort must be completed before the stage 2 page tables
> are zapped.
>
> Zap only the ranges that are not already in the requested state to avoid
> inadvertently destroying (CoCo) data. ARM CCA guests will try to mark the
> entire DRAM as private at boot. If there are no shared pages at all, the
> to-private conversion can be skipped, but the existence of a single shared
> page would require the conversion process to proceed, and if it proceeds,
> zapping both shared and private pages would destroy data and break the
> guest.
>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
> tmpo

tmpo is a stray addition from my rebasing/squashing.

> ---
>  Documentation/virt/kvm/api.rst |  63 +++++++++++++++++++++-
>  include/uapi/linux/kvm.h       |  15 ++++++
>  virt/kvm/guest_memfd.c         | 119 +++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c            |  23 +++++---
>  4 files changed, 212 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>
> [...snip...]
>

