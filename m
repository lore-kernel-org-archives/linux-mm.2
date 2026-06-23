Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079A1CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92696B008C; Mon, 22 Jun 2026 20:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42B66B0092; Mon, 22 Jun 2026 20:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B346B0093; Mon, 22 Jun 2026 20:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A99DC6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:16:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 317C3402B7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:27 +0000 (UTC)
X-FDA: 84909260814.16.1BD5531
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E9FE4000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+duUSYZ;
	spf=pass (imf01.hostedemail.com: domain of 3VtA5agYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VtA5agYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782173785;
	b=gb3JZShHhoBC+w8IOcOjbWFUe/y+AKqaaGbBXXTUqieFU6VjwnVtQVPlixv/FDAWhKihWk
	KxOLUgSAu/tY7hRBrOtjJPqOFgJLsZ6Yx8wveRJqz0clYoD3PO23z7MDzpdkz5b7Vses9b
	XOZLC9QYP7+wa9SWLrmIJTulc5aEaFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782173785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ob/JScNjh/WWoydgNSe9txnAf4hRBZPGssYHA/PqDQI=;
	b=hsfOs9AjNH420VpGaYRqL0IYf7Glhra3pd9EcukMckkmxGznndvU6J0jhLcfnPN/pEUX8l
	J8M5rsDUhnYLqR2BHyKNmDwIjfNLilTNsqga00U4ZkbIgcrBXw3kfNWzSWhdbXojoso2st
	u+/G06x3ZFnXyNA8SG0afNjHX1r9jDk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+duUSYZ;
	spf=pass (imf01.hostedemail.com: domain of 3VtA5agYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VtA5agYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0b35fa876so50217105ad.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782173784; x=1782778584; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ob/JScNjh/WWoydgNSe9txnAf4hRBZPGssYHA/PqDQI=;
        b=L+duUSYZuXcJcR1qJR7jNkNstVLoQwFiE/gQROxuae16dCFrSH8RfJ16roQeljNOjm
         dyYAKMQpmmpApGabDlNC4QDaSdgrj+V0BbM+ooaCyHumPyGtwp+EZvRRoKbF8mDNBEWu
         eZNZn/U4t62qUXJ6+IcvQSGxPzZmPv0MLTC19+kT6PpK2KZ23bkqBzKJEgHHWTr3Vj2J
         G/HbD8iGlWH09WdTANzgLo4QbdZ65eWQpektTVdE2TqYZX13jshnmLe+WUroyG0+rwgk
         2YRlv4ZsMXfam6NdnEg9hqJWjKkwvgDZa1/U3cv5jaG0mfg87NZU3CVfStHMJ0joTAlx
         7uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782173784; x=1782778584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ob/JScNjh/WWoydgNSe9txnAf4hRBZPGssYHA/PqDQI=;
        b=G/0PT2ffmEqhNv+pkEami9TYj0w87EaXc9GNTaygf7BY56JvkN17+PEjNmwR9JxGb1
         tasa4fYopdmrMLRjRMJXPEeEbg9S+uhzYRlQee0tRJCnni602lSkt1EjQuxNNjv5DFr1
         SqaoNFjCu8mcG3+eRmHbl9HRvMQvcDjMax0/nVTQ4YBAEvNek+aNAsUccjw8pmgXsPIF
         ClZAbMe6FTooXZoLhWJlbzsZ1DqjcSgAkVT8btExT25vKyNd5d3RZali9yZZwzlO9nPO
         /spYHaiVjoKjXGIMqkys2Csj/lnTF8YQQebi5cY43pBMY5Qe0s1a8Nxuia8uVF8WNLzR
         Jdcw==
X-Forwarded-Encrypted: i=1; AHgh+Rrdn/MCJTT97haFPU03FcigPa0nMEhiv54KaCicmL02wjCdooPdStxwCsCqqaLTxplD4VJ/dOFBuA==@kvack.org
X-Gm-Message-State: AOJu0YwwaMXLCwrvQDPsbGvl8aAauQVKiyapaP7o9QiDkvH3uMB5m0GC
	0R0or/EvtbZnIn9fpcdeaAGHWvpglwrpTQfSFKjorBP/06kF/Fo6OnUTvLH6f6VwxG6bipsS2Mn
	TfYjX7w==
X-Received: from plbkx8.prod.google.com ([2002:a17:902:f948:b0:2bd:106:8ad0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da90:b0:2c7:c3a8:560b
 with SMTP id d9443c01a7336-2c7c3b7a5femr16356295ad.18.1782173782987; Mon, 22
 Jun 2026 17:16:22 -0700 (PDT)
Date: Mon, 22 Jun 2026 17:16:22 -0700
In-Reply-To: <8e53844c-f2f8-4a4b-bf72-f3140c170d43@gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com> <8e53844c-f2f8-4a4b-bf72-f3140c170d43@gmail.com>
Message-ID: <ajnQVkLvFl_lMuGB@google.com>
Subject: Re: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable
From: Sean Christopherson <seanjc@google.com>
To: Julian Braha <julianbraha@gmail.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: kj1foe5f3ozidsofzfmih3fznpu1yr3w
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E9FE4000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782173785-28214
X-HE-Meta: U2FsdGVkX1+rtncgbxm3OoTglmcftAoskuSTkTlS+F+YRhTiKfQXmRC/Y/AtlORzVgQFBQz6E6/wz5nrFka92MtZwPdLg+RTRE2aUk5hF7xAPrqcvCy+/DrwNh8qPhbanvA8ZcYeEXY2hi1A6aZrG1wYnJP/Alkl9EEKy7SGkvoxgZmI/WNV7/j8LVN0/ZYFSOVdLZlQuBK99mAxIX5XgVpbW+JKDRNn07rGqX3Qt/Gg7fPfcJykIKFpwB2QrZVgJtAFrktBWV5YMB+llWZZGRrIEB1VXUrcsIRIns2J0GAgqtWC2Z9B2U6RDBUgCy278oKtO/rgc87v8+Me7LsgUDTtz3BYYTfS9PFecxQiWMeoFKEpW1jAyA9r6frgwzuSA9DsKBdyQN2Uj152EilqS7Do75k78dtMhDfg+hJKWUDIm3QbOaoRFUmLjBQT/00DvoA/qyGNMQH6wYVX3dfP1QyaqvAfdjOUSJENqnkEWSV42Dh7wzdIEytPBBDzVE2wM59xOkhJoZxr011RQ5woWaXYrZ0jxjsd2Drg7pKlUMFExQJy3U9OgUfOkq4kLI+GP67aBV0roLqsUUd4lrbXjzVCdUkrsbMA+TxvYzSIzYS2mBW8CMXPxFKLBne5wFZc+y+2CBbafVHavjk9nBajZ8lTafHWvIMp6uLX0CGmqGqQAc6J5aqexaS1FDy2QfkrOjm1/mIwn8iREaAtENrjkQnImIxpjZaOEvVmMJzJUTIjeaPHPrXhkrWybqF/mqDHvjvJ7z0f799roLUFIoRFYN0EZWvoA8IfaVMCTBHD6jft6ttQ/9zO17T/Wlg8+Q+ZHNzwGnpJS08igK+40OE1ZgUluLAWUHaU+JqdPYaTvzPDz+GOh4W7I0ANQhZ2RlVm2ua5ynOoCsJwjnDHyjmStGn7vOLQxzFUEJdTpepQ3PoMwiFKkGEMg7a0+SGeR5iCYvUJqah9pSkmYaWxHP5
 WMfaqpqB
 JGWe1RnTbtAmp+iWh0swK049SxRPkyS7DtLa/EizDzQQCESJ2wW0ExcMseIcDC3ltwSf4LUvmo+l773yAiKO2NGiQxYZI5HQkGya/qki7Xs7xEr79iRLuakw//KEHskvZME/AKDodtQUvokT+6pSr6FzT7y2+OI1zNU36xj5fnPEqNHTeB+8lywBgfm2fQrEEm1Jzk0XrI5j4uj5NXAsJ3mXiIpTgGjUEZ/5WHkhERNAv+2G5aAYsw0zZmaf8dyfwZ3WrMjX6lx4UNMe37ELuFOo9oeUIUwgikLVC2aLSmZbmkPuOMmRxzYBD71JS90QjafAhVpd4Qcy+SJYdyFT9Fu2xOPiAoNOCBNl1QLPsqhb0n9udkJsv2ODXA46f7Nn1Cn3kVCgB+H3yczWY6GbTi/b1JsLQ5ZzNwTUAMz9qZREO+iz1c6u47T52DkTb0Fk/LfbO1c1MSfxBx/5GHYgOBfqVc4WHCJiVhc4kYjvCDjm2K+L7h5DZ+7Yzayw92fF+YTGx+VP7TBDUq5tXlF1Qk3u4aIkpg0Q4BcQ36mLcVYYQAEoVpvz9I2pHbvlQFhP4UTVaINbJH/KClIUADrxogJ3tLZqoYiQvOoPbMa4UZuuC/t2sgqaxIyhaltIvMKdQ8Fa5uUJRVDPdh6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026, Julian Braha wrote:
> Hi Ackerley,
> 
> On 6/19/26 01:31, Ackerley Tng via B4 Relay wrote:
> 
> >  config KVM_VM_MEMORY_ATTRIBUTES
> > -	bool
> > +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> > +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> 
> Sorry for the style nitpick, but could you keep the type and prompt as
> the first attribute in the Kconfig option definition (like the other
> options do)?

No need to be sorry, I've no idea why I put the "depends" first.  I don't even
know if that qualifies as a nit :-)

Ackerley, if you can provide your SoB (for Fuad's feedback), I can fixup when
applying (assuming nothing else necessitates v9).

