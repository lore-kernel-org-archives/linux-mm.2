Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96942FF8870
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A566B0088; Mon, 27 Apr 2026 17:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B156B008A; Mon, 27 Apr 2026 17:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FAC16B008C; Mon, 27 Apr 2026 17:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB2F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:29:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27332120318
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:29:22 +0000 (UTC)
X-FDA: 84705626964.23.96934B9
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21C9AC000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:29:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mq3HIfNX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777325360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ebg5+i/pOUuQx7xxuERTUppaj1qL6vIxTxgv86V/NC0=;
	b=Y/o8ygKxhd7e3e9SubrWmKAiBNR+D+3lFFGdNM9SJ818mm3RHKHYlfaNj9WWKk5AwjUf9O
	qdHnGRiG5ap5+Y6UmcUDgVAI63UA0QREjlyzdIp6Z0T3kUs/65jwvHCoBViAeZKv+9keS/
	83aMVRiYVh395AK+0wXuesCtTU/BYjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777325360; a=rsa-sha256;
	cv=none;
	b=4Fk7q7YwHIovZIpQXOnuN/blkKZ/3tpuK2Gs5uXYDb5gPFUolGlH23T7sduzAD5q6Bgij4
	yPTRu1D/tHeYdovgyrMREF2kcd8SPVBCoVuxmmYN3d38aAH2n7rqiYZmbDOY329M2ACQJB
	KDN0Y9LqA7q+2+Q8uAmCDvpEaD28ShE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mq3HIfNX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d0deb7ad5so8838786f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777325358; x=1777930158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ebg5+i/pOUuQx7xxuERTUppaj1qL6vIxTxgv86V/NC0=;
        b=Mq3HIfNXvXSxiXs+xK/mINbDV+6qd69vF6DygLSMQQHdqT1diHXDIFu/N2mjY4F/hr
         WzmMHD9iLm+WRhinCyptXnBK8eZgsHzdBoOpttYEgdndydtO01ZZTmb9SfGiwUR11CDn
         hWpQpRfOmnBG8JkocuRy9+7sidDbpQm4X/44EgLRbPRT4rfQdC2zdAtLuwofnBQdaWZD
         1nV4+6HOwxxZspty5zxCntGzM1EaypMCi2jHBFqybJM4nV3gYwsMldaqqhYVGW+wBgsc
         JUjfktk6BMIg3bh+LTNUmQwPSCGzf0bSK05HbHNmImYAlLbOUvuBS8HJRWBz84YrDSHo
         rM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777325358; x=1777930158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ebg5+i/pOUuQx7xxuERTUppaj1qL6vIxTxgv86V/NC0=;
        b=CM2B/2dvFUX/gI9X1J2Hsvjpbf+n8Lw+T0Ljik1M4wcU4am9WUtCXXv3hZKSq1mHsg
         Vgy8ZhFIanXHSPqw/1tDkRpzv8uJcdqgd+9ifOCexDzgRI/AawJuyOKmowRLA8Xop+NC
         XgtbbMoDr6uKuI02UArMpYLZoYaG/81hg0SgjTrV0+TSDRISsv8VJOcMgLpg/RZccoi1
         HUtCSywh0aPlU5h7/eEc9qfS1R4pJAu/xMYTUHKTlZlWoJEB0vF/+0S0IuXYSwGe6hKw
         F7td7TcfYgalXBx6Tw8pkWysQ8QGPn0gKPqILWzI9o6Uxx8LRvqZo+IKXGYRRsUgXDtB
         HtKQ==
X-Forwarded-Encrypted: i=1; AFNElJ/9KnLUo1VGetl/GjxDh6zQHZgz2l3l+tpvaPoqKzVEnBodr69dhWl82Z2FYJM062WaOICONankwg==@kvack.org
X-Gm-Message-State: AOJu0YxZHeQ+2GrcU00mNClf6/kJiHsiKcDLn92bYkNUDYMRlMqaf1cK
	4oDDaLM+Z+e9lbshRMhUTfWq4gVYv/iOMaUAmtgd0RBHmoP98UQv3dZo
X-Gm-Gg: AeBDieuYVs8bTpGKt7lpkxChZWs6b82+EB8ODKfJq6iH4iGCBESJIr386iZOn3Ndkha
	77WXxP8xEi7TYFH1+Q7bppcoCEjpWMHThac13H5E00wgarkOTdHL5TSrXdRfyqphNBST/g8cEOX
	qSt2Zz8iIVeqBypTZrPeUgkMSOpxLlTLTbPUR3Fz9QZOaDIHdS7F3D/yAb2+gSGzwfDQnrzQ6Vh
	HDqmO5xby+uDcL/z8XviVYRVWhFuRHx6vQc/kzI8KdjQ0tnsmWPn4CmFpwQN9R6fwaMrUGTYDU6
	kFLhp6yAyGCSiWgUM8BogrdtYeDHGE8oBw/6pDPa8XWJ4VVRGq6ElDMhgRZF/muugF96aHXNq/E
	L/flUBWUpAnzIdvNkh87VWw1U5sApWaJAvGCtWUp4d00fGMpZMabGkkMytd1NNaBRWIyB6+ipnU
	OTb4HC0abKhq0tR/6Uz4W5B/v9tHanGCYUgrxqtaUqhlnD/3Jo0FByVu5YtPmWE0Sgqb2pKeDKU
	XuOKah+iBcgFQ==
X-Received: by 2002:a05:6000:3109:b0:43d:7d6f:f531 with SMTP id ffacd0b85a97d-44649ba1f4amr816127f8f.30.1777325358072;
        Mon, 27 Apr 2026 14:29:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463d02f270sm1120515f8f.9.2026.04.27.14.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 14:29:17 -0700 (PDT)
Date: Mon, 27 Apr 2026 22:29:14 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Yury Norov
 <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas
 Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
 linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-x25@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-sound@vger.kernel.org,
 sound-open-firmware@alsa-project.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to
 copy_{to/from}_user_partial() when relevant
Message-ID: <20260427222914.1cb2dd3b@pumpkin>
In-Reply-To: <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com>
References: <cover.1777306795.git.chleroy@kernel.org>
	<289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
	<CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 21C9AC000D
X-Rspamd-Server: rspam04
X-Stat-Signature: pyehakbtg88wwi3pmjyiep56sksjskwb
X-HE-Tag: 1777325359-520832
X-HE-Meta: U2FsdGVkX18VVILthK6ACfInxt597ZLG/dqWLRV8NpMvcamXlDJiCEzjrErhIv+G1FD8AuZLhVmY96ZEV8f7Is2xG2PZWWIKq9umjUeKZxNRJd82h03zb5rg1+fDf7YSCKvpyUj5cnS8MxV0DRfGa6E/R420e9JLIfRswbVgTxPGLJoZQffQHFgPLqm/5PcPRd4iinMvmfdH/sJghUU/S0Kk4AsTITz2/P7ECuvK/srmCMKYQ82T4d/4lZxUHH7iPHtEvSgwhq7IBDl9HXs0+exaIp5au2jZuDxiK621mOe8kBq4VwdNmqm8zPptvLBQIRFi9OGFXrpz8w2Gp7CGPJ3tddQqkQe0D0YoMJD87c8S4WMCMfpALqXIwv+yU7gNgBw92AlKTU7NCrA3LQun1YPIysF1eY3se8GshfeRzPqmGmn5E4duBn3+AZwalF947hSqetToEFQX/RmbOfnFMRSMLMVWvseeD7wxbkqDgX6NHCSoL4fUBaqpsLqJkjhRUwWzFHbksN5XSMlqX7dqXxxUjJL6FsNCP/SkQxxFxIlh0Uruw+KKTzMWCaMWz4OVVNID6X9TJxIDrvewuTd7fPeQkgUQxFbJeraGcjQ75zEhtE7RB4EK5ALSFiClco568vTTVy57FK1+6EFVUhZOSBjuiA7M7CO90ezq2MniPao6WLoUO+qzl/WHUIuOjCXhZ0ztzjvAUcpNFEZ0xW5f4I44zw8Np1x0K5a7BjVVyX1z+XmqaIgTuAyx6WgK63SwCjlu4Ml0rlcbcddNAVZYOaxJJXoqoeSq5jTBacyapOcuHJgXaMYk+C8TGWtucApXbfo6cAtCdDeGoNtlHTkYXR/6mw/1uzXc9WM4FEaI8UCH/g91jBcrQQVBUKg+4EYJEjgWRs/rCJLfmdKA/suHTKfsTDpyLi3P6UESyQEDQQcpuUC/IgziX+34b9DLhamBSQnaBaUGcyxVXw+svxR
 s7EDoyvD
 GQ+Gaeoe49cia5lkbdMxW2e+KLBlia41YmUUA8ht3ibRW9KRsXPuzPTtAH7W+2GRM6+Gz0km2tt1n31YbC+F3Tgdy1bwD+QQX4TlZtDG4GMYEw0cs1fmzD3aZ+bUgt1rUNkAGWra+EeDfrpg1OU7jQptBL5Ja07E7/qF3OBi9yA/d6SMZNQbVa8i8Z8D13/MHb2Q+Al9OnV1IYRHJrH3qOEB9AYbQnrkUbEMMqGErHwhs01qG9m1JPdOdhH5onnpnDTZGS2eAqkOHJLHSZhkb3BIJbA0cFmt1uT34MJpn6z7bTIilwSofnULvomrMKCq8ns89kWMBuAvlBwm7HFjYIBh+ZeKr3vuWJ33t2brWgYZhu3Si+3ZGyR5E1csy/YI9xHokYCVhSCdWt1DSSufjyAe4HSUkx5YyUnR9fPIyc0wzNjRuZaCJo5irlvmjphldqBTTOfpQyUDGK+qfuPglX35zT7Knu5sag5G2OW8jkEJ5EM5IVxucfBQ47bZFUKRkZrFBauxkZaWom/V2xVuqSrhkhgD4Qwoil73jwaW3dwS2LiFHyQXehf0QldgzzLWMBR0QO3aT4QZlwReCgy+ZA1jZ1KjJe5Qosz5rK59w9Zt2d10SAIYxh7vZCfntKH5EEVlC/DfFb98L4Ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 12:01:23 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 27 Apr 2026 at 10:18, Christophe Leroy (CS GROUP)
> <chleroy@kernel.org> wrote:
> >
> > In a subsequent patch, copy_{to/from}_user() will be modified to
> > return -EFAULT when copy fails.  
> 
> Please don't do this.
> 
> This is a maintenance nightmare, and changes pretty much three decades
> of semantics, and will cause *very* subtle backporting issues if
> somebody happens to rely on the old / new behavior.
> 
> I understand the reasoning for the change, but I really don't think
> the pain of creating yet another user copy interface is worth it.
> 
> We already have a lot of different versions of user copies for
> different reasons, and while they all tend to have a good reason (and
> some not-so-good, but historical reasons) for existing, this one
> doesn't seem worth it.
> 
> The main - perhaps only - reason for this "partial" version is that
> you want to do that "automatically inlined and optimized fixed-sized
> case".
> 
> But here's the thing: I think you can already do that. Yes, it
> requires some improvements to unsafe_copy_from_user(), but *that*
> interface doesn't have three decades of history associated with it,
> _and_ you're extending on that one anyway in this series.
> 
> "unsafe_copy_from_user()" is very odd, is meant only for small simple
> copies that can be inlined and it's special-cased for 'objtool' anyway
> (because objtool would have complained about an out-of-line call,
> although it could have been special-cased other ways).
> 
> In other words: unsafe_copy_from_user() is *very* close to what you
> want for that "Oh, I noticed that it's a small fixed-size copy, so I
> want to special-case copy-from-user for that".
> 
> The _only_ issue with unsafe_copy_from_user() is that you can't see
> that there were partial successes. But if *that* was fixed, then this
> whole "create a new copy_from_user interface" issue would just go
> away.
> 
> So please - let's just change unsafe_copy_from_user() to be usable for
> the partial case.
> 
> And the thing is, all the existing unsafe_copy_from_user()
> implementations already effectively *have* the "how much did I not
> copy" internally, and they actually do extra work to hide it, ie they
> have things like that
> 
>         int _i;
> 
> that is "how many bytes have I copied" in the powerpc implementation,
> or the x86 code does
> 
>         size_t __ucu_len = (_len);
> 
> where that "ucu_len" is updated as you go along and is literally the
> "how many bytes are left to copy" return value that is missing from
> this interface.
> 
> So what I would suggest is
> 
>  - introduce a new user accessor helper that is used for *both*
> unsafe_copy_to/from_user() *and* the "inline small constant-sized
> normal copy_to/from_user()" calls
> 
>  - it's the same thing as the existing  unsafe_copy_to/from_user()
> implementation, except it exposes how many bytes are left to be copied
> to the exception label.

I think there is a slight difference in that the normal copy_to_user()
will determine the exact offset of the error by retrying with byte copies.

There is also the issue of misaligned copies.

Then there is the 'bugbear' of hardened user copies.
Chasing down the stack to find whether the kernel buffer crosses
a stack frame is probably more expensive than the copy for the typically
small copies that will use on-stack buffers.

	David

> 
> IOW, it would look something like
> 
>      #define unsafe_copy_to_user_outlen(_dst,_src,_len,label)...
> 
> which is exactly the same as the current unsafe_copy_to_user(),
> *except* it changes "_len" as it does along.
> 
> And then you use that for both the "real" unsafe_copy_user and for the
> "small constant values" case.
> 
> Just as an example, attached is a completely stupid rough draft of a
> patch that does this for x86 and only for unsafe_copy_to_user().
> 
> And I made a very very hacky change to kernel/sys.c to see what the
> code generation looks like.
> 
> This is what it results in on x86 with clang (with all the magic
> .section data edited out):
> 
>         ... edited out the code to generate the times
>         ... this is the actual user copy:
>         # HERE!
>         movabsq $81985529216486895, %rcx        # imm = 0x123456789ABCDEF
>         cmpq    %rcx, %rbx
>         cmovaq  %rcx, %rbx
>         stac
>         movq    %r13, (%rbx)                    # exception to .LBB45_8
>         movq    %r14, 8(%rbx)                   # exception to .LBB45_8
>         movq    %r15, 16(%rbx)                  # exception to .LBB45_8
>         movq    %rax, 24(%rbx)                  # exception to .LBB45_8
>         clac
> .LBB45_6:
>         movq    jiffies(%rip), %rdi
>         callq   jiffies_64_to_clock_t
> .LBB45_7:
>         addq    $16, %rsp
>         popq    %rbx
>         popq    %r12
>         popq    %r13
>         popq    %r14
>         popq    %r15
>         retq
> .LBB45_8:
>         clac
>         movq    $-14, %rax
>         jmp     .LBB45_7
> 
> and notice how the compiler noticed that the 'outlen' isn't actually
> used, and turned the exception label into just a "return -EFAULT" and
> never actually generated any code for updating remaining lengths?
> 
> That actually looks pretty much optimal for a 32-byte user copy.
> 
> And it didn't involve changing the semantics at all.
> 
> Just to check, I changed that "times()" system call to return the
> number of bytes uncopied instead (to emulate the "I actually want to
> know what's left" case), and it generated this:
> 
>         # HERE!
>         movabsq $81985529216486895, %rcx        # imm = 0x123456789ABCDEF
>         cmpq    %rcx, %rbx
>         cmovaq  %rcx, %rbx
>         stac
>         movl    $32, %ecx
>         movq    %r13, (%rbx)                    # exception to .LBB45_7
>         movl    $24, %ecx
>         movq    %r15, 8(%rbx)                   # exception to .LBB45_7
>         movl    $16, %ecx
>         movq    %r14, 16(%rbx)                  # exception to .LBB45_7
>         movl    $8, %ecx
>         movq    %rax, 24(%rbx)                  # exception to .LBB45_7
>         clac
>         xorl    %ecx, %ecx
> .LBB45_8:
>         movq    %rcx, %rax
>         addq    $16, %rsp
>         popq    %rbx
>         popq    %r12
>         popq    %r13
>         popq    %r14
>         popq    %r15
>         retq
> .LBB45_6:
>         movq    jiffies(%rip), %rdi
>         jmp     jiffies_64_to_clock_t           # TAILCALL
> .LBB45_7:
>         clac
>         jmp     .LBB45_8
> 
> so it all seems to work - although obviously the above is *not* the normal case.
> 
> NOTE NOTE NOTE! The attached patch is entirely untested. I obviously
> did some "test code generation" with it, but I only *looked* at the
> result, and maybe it has some fundamental problem that I just didn't
> notice. So treat this as a "how about this approach" patch, not as
> anything more serious than that.
> 
> And the kerrnel/sys.c hack is very obviously just that: a complate
> hack for testing.
> 
> A real patch would do that "for small constant-sized copies, turn
> copy_to_user() automatically into "_small_copy_to_user()".
> 
> The attached is *not* a real patch. Treat it with the contempt it deserves.
> 
>              Linus


