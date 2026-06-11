Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4DFCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12C46B0005; Thu, 11 Jun 2026 11:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA956B0088; Thu, 11 Jun 2026 11:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00306B008C; Thu, 11 Jun 2026 11:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926886B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:46:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E2601406DA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:46:35 +0000 (UTC)
X-FDA: 84868059150.14.B65F67D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 58C7C4000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:46:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dB5SH20L;
	spf=pass (imf01.hostedemail.com: domain of 3V9gqagYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3V9gqagYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781192793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tkYI56ab44R+CGvXUlfI3ycHykGEF+9O0JMidioFwIA=;
	b=LManc8jnIP8wDM6IA/GNiBzwHKqZU0HYuZHb+FLV6zDUpmsvY9Mj9lDBkhAqZiXCcynVOy
	aL1Rx8q1zSWpExVUOjmvIfJtTRPOsBb1aUlCl7eTJado1213Fv2UikizrI3+vz0gNdmKV2
	u0HhF2y9fdVEzKOYgXRz39WuEXLPCdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781192793;
	b=ukdrvLxqe9tBppFh67xs6Y1Z816vhZRVJFs4+W3C1GzV2ojWUknHDEYGejTsqunmjySSCS
	2/f2S5K7aBY3LMqgndMfaFoazwe5PpNmnLBavjnQ4trcjDELoK+Ri4U9OE9yTMtxAixcg2
	pY0w5PtFg6DquxMBCi+cBq7MqAz32xM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dB5SH20L;
	spf=pass (imf01.hostedemail.com: domain of 3V9gqagYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3V9gqagYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bf3636d6c0so85382235ad.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781192792; x=1781797592; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tkYI56ab44R+CGvXUlfI3ycHykGEF+9O0JMidioFwIA=;
        b=dB5SH20LnrHtzO9EQ+wB/axitYSPZLNxzXjj/nEclzvMeG/v6N4v5x2EaOfTYw/tmy
         18yymARClnLAU+q6dwGVlBeDFXSMaObUKNqJHOvW2CndQsiFTfqrNX2HCdPbxYZQTFEm
         s1wmn4VTCnJkSX4oE3uL+LTzn9MHx4fDlwcJKJCqPjSRVJFouMHxuWU3N8tbBYqFoUPk
         wpZkLJN3q0BQJcc7M6KpKgf42KQcRCb4X4DooIVOSkoM0ksWRFPJsnLXg7F11tzdGoFc
         /7QvMPsE2C58/1S/4ChY6lrwKPlCR69ppG7gX1o8+8g1GKgUSgGtNJTBaDfo5GEMYtHt
         Y66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781192792; x=1781797592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkYI56ab44R+CGvXUlfI3ycHykGEF+9O0JMidioFwIA=;
        b=FLc5COmaFsLwDAffg/wX9RmExU559wR7M6B/WzQnxsLpimiwQWHdAx1z7LL8w2mLtw
         YLGeNzq77ZDjm5JoMKR40GsyFvvOIn22IPO3qTU28Z/gjwXr7abTL44Ii0aTXMrpcgRu
         DRIRx4EGK68l10F+em8j/Xa9M7bc2cCRw18nYO+mGLwgShbcgaKrA4c2Rbm3GKTci7eU
         1rKzCHYMgBRkfBxVDmwDO1fjKoOGvZy4rn0W5Qj51Z6vqiAwBDpkyuHrSxm1LHCP20Oi
         x2A5a55zsGUUFGqTnPZ50V280y2bl0UnNo6gK795WurpKtQL650cXP2IR0zNe4c5vttx
         zgOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pMtUnBypdOdZXbiNTNopITmd8VceeHO5on844NcqU8WPVi9lZa1yhfburacfFPTmjPMtTC9Pumw==@kvack.org
X-Gm-Message-State: AOJu0Yw3zIGqsYfT45laRhHp6DaP+Bpg/X4amW0mfy0TaiiMjh8YfhsO
	A1QR8nv6dHzUDyz/4ejogw/xjrfdv4358DJVemf3UyHx9hRPm/yX9FjpW2Ouj1k/9zVk/QxVWd3
	iam0CYA==
X-Received: from plbbb1.prod.google.com ([2002:a17:902:bc81:b0:2bf:17b5:30c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:947:b0:2c2:245a:3366
 with SMTP id d9443c01a7336-2c2f305aff9mr45838065ad.27.1781192791738; Thu, 11
 Jun 2026 08:46:31 -0700 (PDT)
Date: Thu, 11 Jun 2026 08:46:31 -0700
In-Reply-To: <CAEvNRgF31BzyFyVUa7tDJ=qJ-8ws2kxfNjLxmV=OxKSqhaOiPw@mail.gmail.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
 <aiHeDZEPkAcWcSkn@google.com> <CAEvNRgHz5GDjq0GqRmpQdHc-X45gCNr39VYWZH-T7XhPEtN5CQ@mail.gmail.com>
 <aiMVLtblIKu1DQWJ@google.com> <CAEvNRgF31BzyFyVUa7tDJ=qJ-8ws2kxfNjLxmV=OxKSqhaOiPw@mail.gmail.com>
Message-ID: <airYV9lcIM4xdA60@google.com>
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
X-Rspamd-Queue-Id: 58C7C4000C
X-Rspam-User: 
X-Stat-Signature: rxt5o8pd8ei3ptxs7dbk8nbcfw35xj6j
X-Rspamd-Server: rspam08
X-HE-Tag: 1781192793-509740
X-HE-Meta: U2FsdGVkX1+c40EptfzXBPzc1UkVkfGfAxbnWqsB6Ccq1llN4GqdeQEAe38tlIuRIwwsDyuOiEL+9tplFzzHxj+1bABsP3710RtcWERjCyIQD0DllC0zbmwibhQgVX0T+BzBnYr/Lf9x/d8kb5dGxKERa3fn+TYPlgAvr8Gu+3eEJYzWvW+rSrWOiK0F8FIbyrV3PdiY3njJ4Nfhcsrsn7cMVGEmRyRFf9H4Dxy3jvQd3Ukoj+Jn/NlUOOyp060uonn3/etPQ2qNA1RpxDWXKcYzUmKA6/txqaDDxTtVwwok2fzAvY2PRx2o24zI9CXKQvsa9B4refjehjHxpfvhIPykGShRdnxr2hNKTG5yHhhpzrzvVh9osuJlPsUhf/a9jp0sQAWQwlejv0P0fxSrGbv9Qhac2mCe44LxaYOyxxOpy3s/1h8/9M3snDTT7+DzaBIXhIFATgD1kemvjdEj8tZQmRRmRQPEKGfVIOfRDe3iVhglvs6o6ll4BT2+Zu0HUjxavQTTkAhBONvMfPluwu0KAWZD8J84vnO9pB64P3RldJnnqPmdaYkHHn9LBuYhBAT//QQMNNNVZuS2hsQNYNnNqDuFG8873jTSeh6wBhZC5HkVqVsIPS1h50DkMgzIM3otmXExkLeo6ZcTaT2kXvo6z7shFxaOCWSfLhD1qX0AqjX/C7kY1CMT4XAUE6B2Y3lScL+WCn/a5I1FdZAYvDlVyDuBHXlIyM2o8xH6/XAmbjvOpxwAD+PqG6JMIzPh8yg+ZpVmSOx6SkJYSA3nepqwWtXVwSSKS/joMOIkDidJmmI7o/buP7lk24QUFZHh1xRReGfpE8707UmJ2RygxnzpHDF6WsZ5ADEDjdUX+DPx9JyV6v8RF0ME9kxkzlrQi/jhSpatiDLSAKZN4JW1B0oUbkZ80CjDrwYFKAyCFABAsUdLSOoUEDoAVPg63hAooyDuji0AkCo/0zYeLd9
 1eh/6+k0
 EZUqSpwrmFcEGdtaLT6aWFwtHiNbwwu7YCbD0d0InAzm6yodUw6N04fUrweK21RPM6qR9rEVNKX44rjDO6J6xGUIFc/75D12GdHCNjV4oMSS4q4WJhf8FLEzsIJkD21L9EcFMmCEL1d5Ky9RZIeaBLiGg+zMCIU6VLupRhfOVaJjiUK9t/pvuozYlosFZXUpZsDwCpAgaDPfIODLaCIsMyen+LZbf3CmJ4TLsb37SUGhH2xn7FjHf4YhVf2F0DzwIg9Xgit+ZSgzmuO83Sq9M3XcZD6R1LGggvbQGvEIV4u1k2Y6u3GqhmneNyxYE/qaR9s0pFVvPl4dA4wOUc8pFmXgGX4OzklXcw48ipBUmVCHIPW9sL/Rm8/hlbPtaa/hZViK+O5OAS2w5jKjb1sEG+anvjLzYoKvUxOJUsH8e1olbQBkDe0jIkZpxOYDcPSgJBpxr+Wzv5G4J1PKqGhk3QA6A6v2ah5nlA0dMCasQfHJA1d++aYQLzw57kfG9oM114YGc/Isee5qW1/q2VnNVXon9/vx3YZXgiy+dWFMEK3mkksQHRGuXEhvCCecaZqpawZUte+3BBUf2OTzzebyzyns5eb1cE6d6hWKJ72224AF6WWasQRIFyKeZBSRerXNebX1e2UTg54CoYhbFAi69lGZDMi7L4BrUMo8rAtprqEF2mwvoDNbJFYNVvn0eoewfFnjC10hJSsIwPfe28hdHEpBQ6LH/Y8qgSmsnj6kklZKWfpo69v/A1/faxVoe0BMHsRH1gc1RtrKYcr9wSecYLdXr7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Jun 04, 2026, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> >> + KVM: selftests: Test conversion with elevated page refcount
> >> >>     + Askar pointed out that soon vmsplice may not pin pages. Should I
> >> >>       pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
> >> >>       take a dependency on CONFIG_GUP_TEST.
> >> >
> >> > I'm not exactly excited about taking a dependency on CONFIG_GUP_TEST either, but
> >> > it probably is the least awful choice.  E.g. KVM also pins pages is certain flows,
> >> > but we're _also_ actively working to remove the need to pin.
> >> >
> >> > Hmm, maybe IORING_REGISTER_PBUF_RING?  AFAICT, it's almost literally a "pin user
> >> > memory" syscall.
> >> >
> >>
> >> Hmm that takes a dependency on io_uring, which isn't always compiled
> >> in. Between CONFIG_IO_URING and CONFIG_GUP_TEST, I'd rather
> >> CONFIG_GUP_TEST.
> >
> > Or try both?  If it's not a ridiculous amount of work.
> 
> CONFIG_GUP_TEST was tried in [1]
> 
> [1] https://lore.kernel.org/all/baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com/
> 
> It looks like this
> 
>   static void pin_pages(void *vaddr, uint64_t size)
>   {
>   	const struct pin_longterm_test args = {
>   		.addr = (uint64_t)vaddr,
>   		.size = size,
>   		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
>   	};
> 
>   	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
>   	TEST_REQUIRE(gup_test_fd > 0);

Use __open_path_or_exit().  I also think it makes sent to make these available
to all KVM selftests, there are probably other testcases that could utilize page
pinning.

>   	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
>   }
> 
>   static void unpin_pages(void)
>   {
>   	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
>   }
> 
> So in the test I'll call pin_pages(), then try to convert, see that it
> fails with EAGAIN and reports the expected error_offset, then I call
> unpin_pages(), then I convert again and expect success.
> 
> Are you uncomfortable with the CONFIG_GUP_TEST interface?

No, my concern is/was the potential for leaking pages if the test fails/crashes,
but it looks gup_test_release() ensures all pins are dropped when the file is
released, so that should be a non-issue.

> What would you like me to try with CONFIG_IO_URING? I'm thinking that the
> main difference between the two is just down to which non-default CONFIG
> option we want to take for guest_memfd tests.

