Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573F1CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953936B009D; Thu,  4 Jun 2026 16:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AE16B00A5; Thu,  4 Jun 2026 16:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868336B00B8; Thu,  4 Jun 2026 16:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A99B6B009D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:20:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29221A0143
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:20:33 +0000 (UTC)
X-FDA: 84843347946.13.8D2B8D3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6AE764000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:20:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BR4kTL/0";
	spf=pass (imf04.hostedemail.com: domain of 3Dd4hagYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Dd4hagYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgeZ0o5WGa6wb92jyP428hFVqKsbxK2JJNVhO+w+THo=;
	b=d+F/MyOhJkT6e9uuBuERyX4LX74sUTRpfgpJNFBD6uHhzx7NtySH2ielb1BE1snc0riVbd
	rMygrEIZ0ASehIox/zgO2+m6CcYy8iODP6/85GA7qO3Ia77Tonz83Wv4nxpf625QzFcr4g
	OSSNAGLNsayoYZBzqvOOpYMjPikyT0g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BR4kTL/0";
	spf=pass (imf04.hostedemail.com: domain of 3Dd4hagYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Dd4hagYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604431;
	b=jqNR6RmqBFgqXRxqFCXdPuwt76lSwN1YYDxr4u1wutKE9iDI+/yUMyTUjWbCaocllwrC/G
	fSHMq2Q6fD/r+vu/tDqlLSAmNoowtCGHBkqdyUOoh9pu5S9SjZbi7t/l/feE4faeMrcmK2
	3SnVODF0y6ahaZjtHlQLVpg7zdOM3yA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-36d97a4e08fso1042218a91.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 13:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780604430; x=1781209230; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgeZ0o5WGa6wb92jyP428hFVqKsbxK2JJNVhO+w+THo=;
        b=BR4kTL/0ZccGPOI/SmrZBrMHGs47JRFUmSDV0ubbouWxVL9szrKqoyGiYSPeIVgCu3
         8MMtuAwf3Q3P1wcBTcsCAz1MGryb5oKf1oZeAfVf67RXibdkZMdgdMZtF0DPu6/sZDbj
         5ZazQ9zNzasxv0Uk/cUBkH3V1m6A4lkxJz+lDEzOm1pIWNpHyB1I9rlLfpoxjN2gcqgL
         wDAFHE8XqSfWzqUXdsIQ1KNiPo4OCeennQgdYn8qgFx8bJ9xNYKQoaru/oKNc7YVS9m1
         w08/kIny6Uct0Rdxp9vljoBnVGtSEMIqoavsMTlDK3bJZ1G9XMlMXAvN+rk5SJ2pHs6q
         gnog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780604430; x=1781209230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgeZ0o5WGa6wb92jyP428hFVqKsbxK2JJNVhO+w+THo=;
        b=F7rNkHLmYp3DT9WSpRtsQDAYfidAJHxE8Bowpr7WpUc6XHfgwyZKa2loDzsMoJvr3O
         YG1QhVU4Ob/+Pc+0tND0NMQJShTr0Mk0Ma6NpdUMlafn9R0HhGv+/cDnvr1VvVv/1NSE
         8If2UUz5r0Xq/K9LyYDZhFZ+DmwGO7w4aN7IJLPn8X0VDHK8lu3P4qyXqx2OCAhBVXe2
         ocvVD/ep5ktrO4+fGTJADPvyoiT+c/0nWxDJClOsbC8vzLEjrqNdOIJ6sBdyujIhZB1U
         MzifzqVQVz4mQSrJ4nDU+mz3v8TG551e2L9xll7N1fr7BVqEYaILclaBQzU0a5QSuKKX
         JY/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+6kcF6ByaukuBhCMOvZtXbYkzyPB7teG4jEtrEITMbz1u3P8LcVZSetYugW58H1PtaaXhxJxNgFg==@kvack.org
X-Gm-Message-State: AOJu0YxH76sY+2WRdkHw2kf0kg91vyE19tYBtWHmlooy0LJvoMyiGPbK
	SvbUX3Dts2n8l99Xyx4WK1RmPE+dapO9LJNBu1cNVtoldrz4+dTJcBamZ+NpjBSidz6P4g+yfM6
	DhCRYZg==
X-Received: from pjao2.prod.google.com ([2002:a17:90a:1682:b0:365:d2b3:f703])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b04:b0:36a:5d1f:7b6
 with SMTP id 98e67ed59e1d1-370ee5444e7mr546764a91.2.1780604429941; Thu, 04
 Jun 2026 13:20:29 -0700 (PDT)
Date: Thu, 4 Jun 2026 13:20:29 -0700
In-Reply-To: <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com> <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
Message-ID: <aiHeDZEPkAcWcSkn@google.com>
Subject: Re: [PATCH v7 00/42] guest_memfd: In-place conversion support
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6AE764000D
X-Stat-Signature: 6kq9kr7i5iuun6o14pdnt8rf7auzdahs
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780604431-694105
X-HE-Meta: U2FsdGVkX1+NLU9eeb28Jz2ju/4lZszTmX1eMawDsJ0KfVgo+JAp8p5Jp7GttDVJrtXYVxayELWoEhVTIWxZxvmkDbcU/GxsqhiVexd/uIoV86RksQwMya7+YTuUgsmztp17pQr0aFyJnx6M+dwPThufFo2BEyHWZblUNlw70fHIDvcp0HhW0JkFwq783jS2JYmPxvQ7tiMOQtbY8xBD3ysmbnSGZhGbD8Bs84HD3o77vVErr1hmjKbTbkg2E6r99+MjLOTRan4B2ZsGQysGySgzTE8Pv+NxI6MQxJn0WhLi+yd/BP/gyxdZMgSml61FN76p2KWUaPsukyrGnHOEfjc3uBwpWABMQwYo6ccSM8isAa02MlM+hgVih6LgWZzG9myOgWqCfPO5IHV68EtpXeJhCtI4DmHtMSBhYu/UPEkA56r74uWNqzMiE4j1tErc77rFH+za9vkU/44sCgB7MPNFpiHx//EakDqOOk+CuioLgD3FyjkW0K2mXVeZS0CD1fZQcDerWhgH90B07WBHXb0VHXyGAWLMtsQOJqG0ALeRAq5jEnrM5OZNKwpSROSOO98Y7ER3/W/2QLSAGOcCBitCgiiibxQwIAoBXU+lE9hQivqLw3KxHKtAkYH6MwDq3HCAaqZfIN+DPZUFkJBzGu/MPrqo0S7M906JrIJjsuFa9W7F+uT6WDY6b2HeIo4Oyw0+xUGlcklcIsd0aF7JqsggCTXQVzatSCwkWMv96RlRHxuqGNJMzsI14JN4+KrLMtiU69K217w6Qzk1XAE+emZh20mwImt172LFLvx9Wt9m8+tXZBlVJTn+sFIu4gLLcEeIQuPpF4ms3fyFtl08t8WLQCXfHZ0iAnHUQw9+QH6IH4Wpb0yWcm494AzOtPtPHufO3cvkfbh14/2/JnX/hkqssmh1VuvAX5sC0h+fTGKwofH0HK4K//Nhx43ZeBVSwEt5HdmtlrZZIl7w2ZF
 b8ddnXXi
 LEKGxlD9IMfv814EPMGbKt8c7nJy8D9jBidJl2e7lFum87l7X5qBe+m6DfERtYYkaMW6kPYTFDPK8l6ZfopiB0rTrAR05WeZDwJB3WfCYb05yqyLNTWGiKtcHRX9U/l8nLeMDYBtHc3PlLW6A3LOgG4a2o7wKVg9NjBLrxqMSmSZmWZumML68qhmHRyAAmn1jOyeDY8OEpXFWl20y6HEtwsOk3K1P7ejHSk23kdvrB27jH49eCQsq/dFGw56I2h5hmP8PANbd4rJb6i7rkcvVTFvpcrEwrhJ05sMXzSKTXZhef2auGsQVWQ4BZsWNptHp40Bhl/3zHscw4KZmr4chMyxp1RWIKzAsTEfQY0kFHOLkQgbeNl0K0f32HO96bgLGjkih/o4/iZUQyLzeU0MD3T7CqtxYwd4ZNU4S6u3sNOl8jlG/qnd3eF6AKsaE8uc1B48FploQ51K12UneVyY5lRUGLSR9bZ0m0cWQcFbvWSKTcD+/PqWQOqx89Mq9rDdRO1l1PNDa9xjtAYP8o3/2i1to16hMsMHevwswweCxiyhj/gLwkhJ7ADNsDJ0F2gINnGotzInZQMUisEymlb+FGQlQqVtvqDxIh47PU/Rfg8q8CQpuVQRlqVaHAqhCzUuPkAYW0lvaKR6KVTWycDvSGSR9LpzYWRurqH0I9U73nlnQtpvraOnXd7uMM4Y97rRIjTzTIeVbuCMVPts9J285FYEwX2B+j7HZ5xU3bCJbdJRIgNGIJS+ge+KpJeGsK+RIvTGPNUK2ciPhKydsWsVugvek3igQBD+bbkfSUTqAJlWPrrxOwOBjDgU4WYttJKt7BaQK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026, Ackerley Tng wrote:
> Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
> writes:
> 
> > This is v7 of guest_memfd in-place conversion support.
> >
> 
> Here's the outstanding items after going over everyone's comments
> including Sashiko's:
> 
> + KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
>     + Need to move page clearing into __kvm_gmem_get_pfn to resolve
>       leak where populate can put initialized kernel memory into TDX
>       guest
>     + See suggested fix at [1]

That fix works for me.  The initial guest image will typically be a tiny subset
of guest memory, so unnecessarily zeroing a few pages isn't a performance concern.

> + KVM: guest_memfd: Only prepare folios for private pages,
>     + s/non-CoCo/CoCo in commit message "INIT_SHARED is about to be
>       supported for non-CoCo VMs in a later patch in this series
>     + Use Suggested-by: Michael Roth <michael.roth@amd.com>
> + KVM: selftests: Test that shared/private status is consistent across
>   processes
>     + Improve test reliability using pthread_mutex
>     + I have a fixup patch offline.
> 	
> I would like feedback on these:
> 	
> + KVM: selftests: Test conversion with elevated page refcount
>     + Askar pointed out that soon vmsplice may not pin pages. Should I
>       pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
>       take a dependency on CONFIG_GUP_TEST.

I'm not exactly excited about taking a dependency on CONFIG_GUP_TEST either, but
it probably is the least awful choice.  E.g. KVM also pins pages is certain flows,
but we're _also_ actively working to remove the need to pin.

Hmm, maybe IORING_REGISTER_PBUF_RING?  AFAICT, it's almost literally a "pin user
memory" syscall.

> + KVM: selftests: Add script to exercise private_mem_conversions_test
>     + Would like to know what people think of a wrapper script before
>       I address Sashiko's comments.

NAK to a wrapper script.  This sounds like a perfect fit for Vipin's selftest
runner (which I'm like 4 months overdue for reviewing, testing, and merging).
If the runner _can't_ do what you want, then I'd rather improve the runner.

[*] https://lore.kernel.org/all/20260331194202.1722082-1-vipinsh@google.com

> 
> [1] https://lore.kernel.org/all/CAEvNRgEVC=fFuKVgZYvWyZD7t_zvUZihFG8hrACjvtkD5cwugw@mail.gmail.com/
> [2] https://lore.kernel.org/all/baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com/
> 
> >
> > [...snip...]
> >

