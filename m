Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D6FCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 21:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B586B0092; Thu,  4 Jun 2026 17:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163006B0093; Thu,  4 Jun 2026 17:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079436B0095; Thu,  4 Jun 2026 17:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F14866B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:14:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A4B41C10EC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:14:37 +0000 (UTC)
X-FDA: 84843484194.20.95F0821
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5471E4000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:14:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XyrRI1sn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780607675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyPEsnWgMEwVBTMM4vHE6GHrBW2HxmanLD1B4poadMk=;
	b=lPcCmC9w0lWimJl47clMGxeBlIz4uSk2WvaaRcIl0r4nrQVY29dMyJm6Vja/zmHIeg40Zj
	Nuh8QikKgfxg6z7jfNwwh6PrEXdYsJhnsejisMRSduPiTaILk1HaR9/qhsQkxobikSd7oL
	Vz20Ec2dzQJN+9vKAJ3eV3TnyH2rTKM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XyrRI1sn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780607675;
	b=upJ7k4qZioLEB5cqfGNqhCkcTWsJED50TbK1dS7qC6PEpt4P1dG/RD8QjJN4PxkbjsViTj
	L1XTZkmFPhfl0ToKE/wEKgoZZBjcGnZd42we6NfNWk3QF3uzuWSl1/3KQe7kVKSIlV6RYh
	M7ZNwWOT5gLhvZzw4NufOMJEvIItIo0=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-307631dbfedso2397676eec.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 14:14:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780607674; cv=none;
        d=google.com; s=arc-20240605;
        b=I3pENZ5lqjGA/NBS9W1YFFiF1+SEqPgxd8NZK2RixfVYHukLAwwIlJDz5oaDdDbqx8
         thmX3OBLC0bK1soSC9mzoW4dYXnlJMQ3B+6v1UethGwBshaKmK/jDVPGKtlqVdcL9Koe
         W4mI+/Xj5QM/3AF3bJ9M8fYD3zSrsBx4NyUCBd14ObqLucWgTv6XKV3zyMtOTMQ+SepH
         /4mgzbhgjK0p+0iQ3jcHC/9NvtowNSMMPe78EsVEMOHKAeK9x3Ar/R9GEA56kbD6hwA3
         4WwbLaamPGRd6uXq4LiCvQtySLRefJBZ/CcchiexLIFxwdnYzsMXhyiTvJ7C66PB+HvP
         O3YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=lyPEsnWgMEwVBTMM4vHE6GHrBW2HxmanLD1B4poadMk=;
        fh=hV6wxGjuR/5S7eH6JnSeORahSbZVoEDewOd7Ooh+bJ4=;
        b=b1+twQ3zp9XDBXguqrvKdZndb5GxzqXp6zPzzdv6usxjszfQpMPyj38QbbGpxgW9XW
         hzxZkFVGe9ceWjVnj2yHHSvkxxlHnB1PqfRcEP4IXalAb3ltC6yLlrjUVzKmFernO+Lz
         uaP/4w2jipKbaHDQp0DgLQoVOiSYBIVFZFENn9ZQ/nqOj/4gW1+2fCsjIqLjtnmOwXA5
         o8EhruprMvwoj1E/hdZyrNbk5IfOPx1yOQi7BPMHHoUPRy25VuccCcIasu1oWj64Sx9g
         fD0uK+QHKjA1FYKZn72w32A0r74JiKZfOhoDensUC52uCbM6CD9qmqEiW4RJT7vxdzfZ
         +Png==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780607674; x=1781212474; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lyPEsnWgMEwVBTMM4vHE6GHrBW2HxmanLD1B4poadMk=;
        b=XyrRI1snGLdYvbivoylVnGhIEYrB9lnOzBqiVqgfTPKZwHCqBL7qRkL2rdehCY5AAc
         J4OEfhAEeXb3UvxMXZaX4GwC1bTDjDqas6tfZaWz1xc0L4UiKBZy+45kBXu97/uCv6RE
         mURoQCs2wvw5z4Ge36kHpfLepvPPlPjC+XoOVct7HjbCykLHJ+KWX00MIa8S/eIXZdOX
         3vQa2Hmh3BM9FZc6j1+5Dc9UL/gGNrX7a4TgXUbJci3GjRMWFKRd9GWoZYvYNS2zzqv7
         K+bFi/jaShpOg0R1Mlc0TXxlgFCufOxvTK/YUaIPZtLueR1ALCWsYvDM/JIWP9HTlTwd
         Hfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780607674; x=1781212474;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lyPEsnWgMEwVBTMM4vHE6GHrBW2HxmanLD1B4poadMk=;
        b=QqXqogRLR8QNad3x0hoPcIYcRYUWxAcrDMezLA8qbIPmZfU3wheQoQyk66XlGfYmdC
         FTcDoKYG9kHI3V/pBlbXITjJuHeesJZNgfA6nIIh64tOmO32WwtduebCJIZHmzJtKblv
         qDQUHpJ6CPVoXlx0fBz5zV/S3/gf47kt0cAoEIhXlqmAoBLxcFhSg81eJrJn6UiHesNd
         Lw1HZf6Cg+CSwn6u+4yO5yIXRP8vnkACG4JoLPvw1BSJOsACfCANyrWb4hCEe/+9BqvT
         o1tAuIWNyjnva9iGiXeY6NtUC0qe/yDLkpxmtA3axqCJtgaFv+PCoIliq9hKIjTmKNkw
         osKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8J6FRW6sRr9O35deLthrAJqALRtfnDIweK0xK+Pwt+0qWcnYuOTOmTFzmxtwHhbRTM1C4XyFUeYw==@kvack.org
X-Gm-Message-State: AOJu0Yy08s0bAd+aZ6tR/ii3EEJSQudUvIL89NWZTb9jHMe47NCRPT5z
	oN+8b0AILmTYn/XFxbc4PomOL8m6RuAPt+5wXGUN6Ba6eCNO/s4NugkSRYtEAwIpHYtg/Ccx9L+
	B2F6UEStCm688Lco9OwVdJH7gWfrV6GpmBhyJkKxw
X-Gm-Gg: Acq92OEKVdNWxXzzD+7UBefeyFdH2NweBTmz5oDUuN19BkXYcvXV+MM+s36Ygy0n0YG
	mtkjGD17Rr8PmqjMFPkrjJSEYDX6TTlJvD4Z9OdZg7E8Dkf+PSEWXjj53+noFV2iN1n3XbEbTTr
	75QqvTPiWMlc/7lBvjPlLQpXsFbMP36zcbOiOk/UBQ/0iGf3B/WMVSUJzpTLVmHrh6+Lg4Ye9zM
	feuP68iO2uVxpWwpboXG5WNQRYHh7UT4Fx5N7t8LAwbSkpH0wRNVwCfkOjVZ80Hv70Slk/iLzYC
	knoUsnfQGcBxaLvZiYeYjOj7m6p6XyH2RR9z+tyoyKBy8sZUKFHKtuDd0kvnp3d4kMfZYvwwvXL
	f38o=
X-Received: by 2002:a05:7300:5b83:b0:304:acc:f086 with SMTP id
 5a478bee46e88-3077b7ec417mr207174eec.33.1780607673246; Thu, 04 Jun 2026
 14:14:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 14:14:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 14:14:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aiHeDZEPkAcWcSkn@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com> <aiHeDZEPkAcWcSkn@google.com>
MIME-Version: 1.0
Date: Thu, 4 Jun 2026 14:14:32 -0700
X-Gm-Features: AVHnY4J7O-BvLwAbWwmNVfQCapmW0Jz58QA9MN7lFJVjBHp7oGK-p6NKEbfSA24
Message-ID: <CAEvNRgHz5GDjq0GqRmpQdHc-X45gCNr39VYWZH-T7XhPEtN5CQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/42] guest_memfd: In-place conversion support
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5471E4000D
X-Stat-Signature: back78ihh8fntpy4xn3k4s8rbqs3u383
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780607675-820565
X-HE-Meta: U2FsdGVkX19dLHJml2ggVOIGcgWQ0ID0Ryhkx4oqSr7v7T+/aEn78Blice61EUPtlYeKPtHXEWhma3xsrK0fLNEYNJcNF+5s+LCvlAHxm7Re9mXHGlz0UrS7W0LTQyf6p5aRsCKnEfJ3kMtJ4nyq40XQxaQYeEHx1BgnjQSZxTGs3gWgR28OU4py8fMLOOeCeB7fWU8TKYlHWYY/vmPzUbMiK7jAebhrO3HH1EkLj+kLQU8IXO8EwViSfBdjf+UPCiKFBMzbfMNw8nZMf5i3DFq2YpnZYCb3cU7aJG7THg/ij8Fn7pfLO+nxGbsk2qIM3eV7hp+KO4T/hTHRh8g9EOb+8xpOmB27In0/OqFY+oH3ieZCTkcLOwL6xdc44BoP2DhJQ6FTN3TZx/EpTEkJY5B83MWXBdSpILdg8pcfCvcawo8VhJDTUiWzPKvycrJf2gj6VLefWL1W1Xwx7f22KboNkuXhTHLk8dbyEYdWVDbO+AJb0O44KJElYGvEUZpabYUjZkRH0r3rcEHe2TFpk+Y3VHVuklhLujwm4XTKa7fs+0DcsvnsTClbH5aqN5Z4AScKZCv158rKG90v5S6nh/FK43yPNMrmH61EULgRCxSz08D3BEUK31F16EbYt/tsX0JW9OTJ1ALr0ppyniLuLQMfBeF5f+7YYCBA89n019E1YqqGTHP6EMpfw6YOo0bIJeTCyP0x94tQRMRtUnblZGnT+ussucwC7nB4lTgZchRT7Ljef4W7ulY+AQ/4M9OpQPBUQO7K1Ztd8IT6rq6cQCP/iTABr5DmE0i7rocuo5iDL+B5MTZJ7csXFkGGjuaQ6MCw7sXnJsZDywYVu2sxK1fXgAuJBzuNI2q9WnaoHudYyKjNqcMOut9BCwY4xoMfo18IvDYK0uS1zMJA+eNPXrxTlErIcwsNxyXjQIeyhy9NGTCYoQsql99/VIDSshakFis4NiakUgtp73pkhDn
 VMuyLZBM
 rkVSFJzwNlAKlr8qBXzq3jIy/dHpa7Tr6JPxNbqg3iQ1L7dWcosoy9IWnObX3WwyI6g1/QMbLjY5ufSlqNTzZe4WVJKPtQN30vfAEltz9jdm8XoS8HUDadvaANzv8Bigy2y1hnR4iCA3nQ2A9E8Gdnlr6uSTYVdm/lTNo7043Nhn0tIol4Iv+IWvMlyMSewDMtEOWQLgX1XE6BsM1cw2WBg1UW7C/V7wA1iNBiW6TfA0wNZaxUvJ9+Be5r37Tv/VmPOpuZAtcXfFZp0AcCbsrlCbxuGZ72mENRXDXuFbjIMRPkDVe5GbB6E3oW3Xmw0u5ejwb4OTkpa4Zs12MMuT2ReC1DjBAEr/03RBTxuSlZtt1c+qOTHawPZUMhIFrV1+ZwrsVwD4TKTeGWTMVrX4sgyXMoxOWlro0+26Jl49C2mFBlvuf6QHVhbx1oA7N+ee9erYqhYYlix/I+KudIWRYnJxCyuNE/hueTg25Opwfq7GGs+FN/RqyBpvH9kX+cIaCXfkkhtgC+W6JxUK5n03QTIrdwTU9MdsuDmsg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 03, 2026, Ackerley Tng wrote:
>> Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
>> writes:
>>
>> > This is v7 of guest_memfd in-place conversion support.
>> >
>>
>> Here's the outstanding items after going over everyone's comments
>> including Sashiko's:
>>
>> + KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
>>     + Need to move page clearing into __kvm_gmem_get_pfn to resolve
>>       leak where populate can put initialized kernel memory into TDX
>>       guest
>>     + See suggested fix at [1]
>
> That fix works for me.  The initial guest image will typically be a tiny subset
> of guest memory, so unnecessarily zeroing a few pages isn't a performance concern.
>

In regular usage moving the zeroing in [1] doesn't change anything,
since the same zeroing would have first happened when the host faults
the pages to put the initial image. When populating, there's no more
zeroing since it was zeroed.

[1] covers the case where the host doesn't write anything to the pages
and directly tries to populate the pages to the guest.

>> + KVM: guest_memfd: Only prepare folios for private pages,
>>     + s/non-CoCo/CoCo in commit message "INIT_SHARED is about to be
>>       supported for non-CoCo VMs in a later patch in this series
>>     + Use Suggested-by: Michael Roth <michael.roth@amd.com>
>> + KVM: selftests: Test that shared/private status is consistent across
>>   processes
>>     + Improve test reliability using pthread_mutex
>>     + I have a fixup patch offline.
>> 	
>> I would like feedback on these:
>> 	
>> + KVM: selftests: Test conversion with elevated page refcount
>>     + Askar pointed out that soon vmsplice may not pin pages. Should I
>>       pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
>>       take a dependency on CONFIG_GUP_TEST.
>
> I'm not exactly excited about taking a dependency on CONFIG_GUP_TEST either, but
> it probably is the least awful choice.  E.g. KVM also pins pages is certain flows,
> but we're _also_ actively working to remove the need to pin.
>
> Hmm, maybe IORING_REGISTER_PBUF_RING?  AFAICT, it's almost literally a "pin user
> memory" syscall.
>

Hmm that takes a dependency on io_uring, which isn't always compiled
in. Between CONFIG_IO_URING and CONFIG_GUP_TEST, I'd rather
CONFIG_GUP_TEST.

>> + KVM: selftests: Add script to exercise private_mem_conversions_test
>>     + Would like to know what people think of a wrapper script before
>>       I address Sashiko's comments.
>
> NAK to a wrapper script.  This sounds like a perfect fit for Vipin's selftest
> runner (which I'm like 4 months overdue for reviewing, testing, and merging).
> If the runner _can't_ do what you want, then I'd rather improve the runner.
>
> [*] https://lore.kernel.org/all/20260331194202.1722082-1-vipinsh@google.com
>

Good to know we have this!

Thanks, I'll work on a v8 to clean up the above.

>>
>> [1] https://lore.kernel.org/all/CAEvNRgEVC=fFuKVgZYvWyZD7t_zvUZihFG8hrACjvtkD5cwugw@mail.gmail.com/
>> [2] https://lore.kernel.org/all/baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com/
>>
>> >
>> > [...snip...]
>> >

