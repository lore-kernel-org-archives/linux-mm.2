Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DF4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 19:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1356B0093; Mon, 27 Apr 2026 15:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692966B0095; Mon, 27 Apr 2026 15:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582896B0096; Mon, 27 Apr 2026 15:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42A476B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:08:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB2571B89FF
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:08:27 +0000 (UTC)
X-FDA: 84705271854.06.1CFF508
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 732E4180010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:08:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ILcQlrM6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777316905; a=rsa-sha256;
	cv=none;
	b=7/FSWP2mQPT6lKjXVUh3szowUd/6Ra680MBDukd2ruuKncUB8b7SQ+eSA9d3LGEcLY6ZRU
	LykAX7UMvLxnVZp6E3VbwvtqL9TM+rNT+RnmdWtRrbQenU9wApfgmf9jXUmmFmfh7TC1wx
	ymvbkp1MBPXctd6eNZnfbEiUwsCFKEU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ILcQlrM6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777316905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eo95+vxRQveZjyTXx2nQjz3zXl5qvV2nK5Gunw4PJlE=;
	b=2b3OH1IsIzet3D+pC2UUlha/WzvjRkvNeWtH6GebglEjc7EnQMio1wrRitERzWLN0ixy1i
	QtO+nTYmMlXsl0J3MtLXr5jMXYwa5VYMO3v8TXPpah9qqRjBi3/xV0ijVUyHhm/ItseJl3
	lR19Fpo5U1UeQQEhQPJlr5MSWlD0h9E=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a41099fa86so9251347e87.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777316903; x=1777921703; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eo95+vxRQveZjyTXx2nQjz3zXl5qvV2nK5Gunw4PJlE=;
        b=ILcQlrM6njV2CrhzN9zPIkQaP0r69XBEmvSeBe7YFH8Nhc3rGX/WBZJLeRnwT2hpHf
         sIP9+AD3xHiryLRIjbV7d6nQsN02xkKaIKUcSPiNSOrJWRKwwCDkh37OCY5pLav1iLId
         ktOg9+SEKe3/wvqyUzsr7EQSfYtljREAG1Jpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777316903; x=1777921703;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eo95+vxRQveZjyTXx2nQjz3zXl5qvV2nK5Gunw4PJlE=;
        b=EC21kumkCaBJa2giLDjegn9MdueeZxL1Jui1yIPJfHwkV8kGtu6z5maFGKEUxtJOda
         K8K7YLktwV49gW4e8gOy7+5DS8DQ73tuNm3kDaCnAqaaD2cMwyZCxT/4SYPS/RWkxxa/
         YnGQSMU6TYD771hhz5qrS/8+jZ9VNScSeFK+VIH97zDZ9LnQN7JNS9hgJ7E7IerTEP4x
         aKe058IIMYUA+oWOoQxlNKQfc6umpwh4Umc8mKQ/MUl8FIROtxnXqP6hXYCfTvY7rvcC
         L95te84NIXGOe9kHpU7sVcNuHH+Un/4fGgMpleCNAH2WaMZL3tpJb8HR9MFlCKoT8YLH
         AKeQ==
X-Forwarded-Encrypted: i=1; AFNElJ87HZTR+tlXn/yCjlcnspUQlaaI/WcwB8INTpHvhP1BjU11212O4hutGAST+ofjInCl595ybvaSsw==@kvack.org
X-Gm-Message-State: AOJu0YxTcgFoR2lSQR9cuXAhtqgkyo6DfDp3IhWSJ9VMOZ/yMi0AWq0T
	79zD2toYSYylO3e8PKVBdmFgH3rmvOT/bpskz636vMnRAhBSjBPXNMjqwpg9x3er617VDDZ6KGb
	FsUepCj/VGQ==
X-Gm-Gg: AeBDieuEsFNdWYrYcriGa3hhmnhNUiImgpa5rQFSY+FnB4jMe2DAoDw/OV+HTJuwcg3
	ZCFex8yUmg2Bozy24sQcL6owvGm6RJkJKA6+paHrecX4Dl2YdeokZOUSzIDOslbd4FhvHY6Y7jr
	BgxTHRbB/x3OIjA8VVfqVENiDw7yT/YVSdZqGFFVKanDzF2OxT9JaepyDCXP+MwXIR4K2NAoYgt
	R0DrhNlzzmGSZSlgvQ1q4B5gPJznUOz6KYDyePZwfaYPhZE8w+a+hNMzmPSrsbTxAP1t6NzCKde
	SRXEAFUbzGcvbiGmZmgGcMgiaBHWqyBXotiOsNnkTnBGW/1EcGqyd1VyD4S5vW7RWRTQcJkUeD9
	g2DHfbiH1WST3e8tpvUiS9Ut0ilZ4wU6Rm8r7XEUv1aJ8M844Ata/9cqMcmxZo9pFtblEwaVS8r
	6DrciuAlO/ZQdoiK/6yFYY4TbdJVWrp8NFnAsyqbfzG7apapkn5tKpQWQiAI+kH4+fxKRumt9CZ
	+tOb0WtVOkzm40=
X-Received: by 2002:a05:6512:6ca:b0:5a7:42d6:529b with SMTP id 2adb3069b0e04-5a74662a791mr32255e87.34.1777316903201;
        Mon, 27 Apr 2026 12:08:23 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a7463f9fafsm17758e87.59.2026.04.27.12.08.22
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 12:08:22 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38def541b0bso91040531fa.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:08:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/lc5o56YTIOEevnayYraVdGeGyicQATqTGrvqhOLgRDInKwdTYnw6s+fHBFxyeMKsglCcgcadD4w==@kvack.org
X-Received: by 2002:a17:907:9495:b0:ba3:a8ef:3597 with SMTP id
 a640c23a62f3a-bb80443c92emr2812866b.25.1777316502372; Mon, 27 Apr 2026
 12:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
In-Reply-To: <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 12:01:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com>
X-Gm-Features: AVHnY4JOOuu1ghb35GF5M7sO3SAfkj4A7WtLiFNY579kWyh92WWRKfW5QE_KjRI
Message-ID: <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial()
 when relevant
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Laight <david.laight.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, dmaengine@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-fsi@lists.ozlabs.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, linux-wpan@vger.kernel.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000c765e2065075bee2"
X-Stat-Signature: p7uzzxoy7rop8yqto6zugncacr54dd1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 732E4180010
X-Rspamd-Server: rspam07
X-HE-Tag: 1777316905-736628
X-HE-Meta: U2FsdGVkX18rjSRTbA2zNaTSEUONgxIYIJAYqeZ7OtJAeO+6iX0eqN+m2pk/7bpPm0JyZnwjShU3hhLpZFIG6zUXgboBKa84MNiFM/zjLF3vbGMUeEj0r3ZRlNRZo+5s2PPJW3po8sXlekrl5hkxnaShmYXSvK6PVRlVH9FhN4o+Oxx1sInlqoKdjfz0NzBmUaFpzgVikwdW660YRAh9b5/bbcDBoLXEOnhUFHpRc8NfMGV0qJEOe2H305vUOIhaOthBPEYR95WCNGnsSgaGofT7/2eMwTWVVLlDuyfcaKF+PFj1ZLkq+Lu8M3Nz9hYFunNIDX2+vBl9FmBwiXV1+69kMRAGThuNAAxSfL42v9MnLhjFhoWezfF6PHUPlv2av38MN/qBkaAcDTd3gc+/VYJYTe9RfijLePALqVtAD484h9LuthsPd4Y3/H8rOfIEDeDFN5cdWYb4rq0rVeY/oR1NmcpGfM6AKC98PWTc2e1eDWwlt10hGPIqIcbaJGtmpJYR/vxxK2NaR3gL/R+vdbLKSbMEZXqbiQKYfzGF4Ykn3+NsbvP0eljiHCv3mqcprod7ng60b0EtfhOxEsUvYyDQ6/9BbtdZ28rLtT1dnOH66mTjvzXCNXZQpzoMcIHLJa46Zzw4L3TIXyqLubdP7fIcNljxo2Yo8F42WUtJRs/A/Mg6WvCvkhJ0E3CGd3DBc2Ec0FgOUAGPMGgAh9b4wWPEDjrStL8Z67ljUt9lyFJciw88yUuz1Wyms84ElYBWd1bEOLaQ937RuhprgNnLazJJVWrOQUbRkwVd6yCpiVPIP+20zwrQhvrklKIRdKO50emXG9pfFkn/a2kcCaopCQspB3MZhQK41JHuXii76Hw/UPpXe71gDdYpYa/foRdcI787gkhuPioNagb1o8k97Zch590QNqa878zH6IdDsgJPnbC1c6DHizkJkNsUKvUikm5N4JnpyBFstyIkrvi
 DZrKZvyv
 V9+T0xb+v7TQIyTGbiXzojynt2LMmq1cpmxehPNe+XYIK+l0/G4Qs1Vd7CeYExCP2GyxpHTjD9Lc3vV3y0sQ1dKVHg1//A7AVNnYoJqwAyN3CO3erOG7xVdX6LxMUZcL7chcnr1MD8t1UEB8yY3+eTgG+/gF+RIXA390UZcdBxx0QJ6Jr7KJWZsiPZ5KCOCYJuEW101NMlYSSa4A4supBBADJxYt7l9dMw1PwhGLv3d51m0Fwt+YW5oyV8SNpF3MbJheRJwt39pYLI7holz24G57yUHB9btCH3CKqR/ggiBtYu30BR+GFtLm7/+M++QmvwmNn4D6CjYh8nQfE+TrKaNR+JZjZqtmvfXpJg7VUQJ8eWuxnbUg5TtpMQSH6xwGZCBrkIzbgAs1DDbDQxPj/AE90dfmcTtbrbO7up7y3NGGljPCFTHaKD51c9tliDZHl5ezfHbDAhzryjm6HJoJfqModdpbuBKoGd/Fsm4HpV5JwhmEw3Ji7HFoXhKsHuzQ1TqcNXpIQ4sEuzXkeKgiugF38MP5TM2rJBHL3rBv08BbTVW0a68flSOJsl951yu/kJVzh7SzetB0wduv89Jk5cCoh0N+6aFK+mR7Z83DmpwuJnRY643vfH0IvLrpnNj0NEQiS4FQqP4iZPb8guA/eY8910X7WGkElMzsOtAVChgvqtIqD6h8zFbu/N/7FpVh+uGTmlTJbM+dl0O80ZT87kwhMfWzQ7g8Sn/Tpef2cr84N5lslkBeZMCDzwfHriJXrNsg/bqAkVIuWEwThA62qj5KO2OXiy0vuZq7p5ZKLp4RKItzLN1wsJfY7Iqv8mft7Hrero23aXgj9y78XUo/ZdG4nHSzSgwFxXQN7/mtTM3RJFEDISYyOAQ3RWCsWOFbW3egRtpUjelLgCUpC2Eza2ePIixcagQLZdEBQeYGt9HJMcxTUk9n41d+/i5uVShtB2IuAgrEyG0zCxf6PanBtJmUJL36o
 ujXMWMEo
 fO4Mz1VDeOjp7AS8ZQIRvYfZeYZs2HyPwCuncUcPB6V/p0xLdwJOvQKkXPdsXOpwHEn6OGRpPhkKkcOjL3kBte3OK2szmQ+ePe5Ikq+14+hMklAgKlvALz7aFab4CN+k4CfMGHUfbZigk5OT0X02Rroi81Rq8084mr6PmAtCeOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c765e2065075bee2
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 10:18, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
> In a subsequent patch, copy_{to/from}_user() will be modified to
> return -EFAULT when copy fails.

Please don't do this.

This is a maintenance nightmare, and changes pretty much three decades
of semantics, and will cause *very* subtle backporting issues if
somebody happens to rely on the old / new behavior.

I understand the reasoning for the change, but I really don't think
the pain of creating yet another user copy interface is worth it.

We already have a lot of different versions of user copies for
different reasons, and while they all tend to have a good reason (and
some not-so-good, but historical reasons) for existing, this one
doesn't seem worth it.

The main - perhaps only - reason for this "partial" version is that
you want to do that "automatically inlined and optimized fixed-sized
case".

But here's the thing: I think you can already do that. Yes, it
requires some improvements to unsafe_copy_from_user(), but *that*
interface doesn't have three decades of history associated with it,
_and_ you're extending on that one anyway in this series.

"unsafe_copy_from_user()" is very odd, is meant only for small simple
copies that can be inlined and it's special-cased for 'objtool' anyway
(because objtool would have complained about an out-of-line call,
although it could have been special-cased other ways).

In other words: unsafe_copy_from_user() is *very* close to what you
want for that "Oh, I noticed that it's a small fixed-size copy, so I
want to special-case copy-from-user for that".

The _only_ issue with unsafe_copy_from_user() is that you can't see
that there were partial successes. But if *that* was fixed, then this
whole "create a new copy_from_user interface" issue would just go
away.

So please - let's just change unsafe_copy_from_user() to be usable for
the partial case.

And the thing is, all the existing unsafe_copy_from_user()
implementations already effectively *have* the "how much did I not
copy" internally, and they actually do extra work to hide it, ie they
have things like that

        int _i;

that is "how many bytes have I copied" in the powerpc implementation,
or the x86 code does

        size_t __ucu_len = (_len);

where that "ucu_len" is updated as you go along and is literally the
"how many bytes are left to copy" return value that is missing from
this interface.

So what I would suggest is

 - introduce a new user accessor helper that is used for *both*
unsafe_copy_to/from_user() *and* the "inline small constant-sized
normal copy_to/from_user()" calls

 - it's the same thing as the existing  unsafe_copy_to/from_user()
implementation, except it exposes how many bytes are left to be copied
to the exception label.

IOW, it would look something like

     #define unsafe_copy_to_user_outlen(_dst,_src,_len,label)...

which is exactly the same as the current unsafe_copy_to_user(),
*except* it changes "_len" as it does along.

And then you use that for both the "real" unsafe_copy_user and for the
"small constant values" case.

Just as an example, attached is a completely stupid rough draft of a
patch that does this for x86 and only for unsafe_copy_to_user().

And I made a very very hacky change to kernel/sys.c to see what the
code generation looks like.

This is what it results in on x86 with clang (with all the magic
.section data edited out):

        ... edited out the code to generate the times
        ... this is the actual user copy:
        # HERE!
        movabsq $81985529216486895, %rcx        # imm = 0x123456789ABCDEF
        cmpq    %rcx, %rbx
        cmovaq  %rcx, %rbx
        stac
        movq    %r13, (%rbx)                    # exception to .LBB45_8
        movq    %r14, 8(%rbx)                   # exception to .LBB45_8
        movq    %r15, 16(%rbx)                  # exception to .LBB45_8
        movq    %rax, 24(%rbx)                  # exception to .LBB45_8
        clac
.LBB45_6:
        movq    jiffies(%rip), %rdi
        callq   jiffies_64_to_clock_t
.LBB45_7:
        addq    $16, %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        retq
.LBB45_8:
        clac
        movq    $-14, %rax
        jmp     .LBB45_7

and notice how the compiler noticed that the 'outlen' isn't actually
used, and turned the exception label into just a "return -EFAULT" and
never actually generated any code for updating remaining lengths?

That actually looks pretty much optimal for a 32-byte user copy.

And it didn't involve changing the semantics at all.

Just to check, I changed that "times()" system call to return the
number of bytes uncopied instead (to emulate the "I actually want to
know what's left" case), and it generated this:

        # HERE!
        movabsq $81985529216486895, %rcx        # imm = 0x123456789ABCDEF
        cmpq    %rcx, %rbx
        cmovaq  %rcx, %rbx
        stac
        movl    $32, %ecx
        movq    %r13, (%rbx)                    # exception to .LBB45_7
        movl    $24, %ecx
        movq    %r15, 8(%rbx)                   # exception to .LBB45_7
        movl    $16, %ecx
        movq    %r14, 16(%rbx)                  # exception to .LBB45_7
        movl    $8, %ecx
        movq    %rax, 24(%rbx)                  # exception to .LBB45_7
        clac
        xorl    %ecx, %ecx
.LBB45_8:
        movq    %rcx, %rax
        addq    $16, %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        retq
.LBB45_6:
        movq    jiffies(%rip), %rdi
        jmp     jiffies_64_to_clock_t           # TAILCALL
.LBB45_7:
        clac
        jmp     .LBB45_8

so it all seems to work - although obviously the above is *not* the normal case.

NOTE NOTE NOTE! The attached patch is entirely untested. I obviously
did some "test code generation" with it, but I only *looked* at the
result, and maybe it has some fundamental problem that I just didn't
notice. So treat this as a "how about this approach" patch, not as
anything more serious than that.

And the kerrnel/sys.c hack is very obviously just that: a complate
hack for testing.

A real patch would do that "for small constant-sized copies, turn
copy_to_user() automatically into "_small_copy_to_user()".

The attached is *not* a real patch. Treat it with the contempt it deserves.

             Linus

--000000000000c765e2065075bee2
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mohk3mm10>
X-Attachment-Id: f_mohk3mm10

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3VhY2Nlc3MuaCB8IDE3ICsrKysrKysrKysrLS0tLS0tCiBp
bmNsdWRlL2xpbnV4L3VhY2Nlc3MuaCAgICAgICAgfCAxNiArKysrKysrKysrKysrKysrCiBrZXJu
ZWwvc3lzLmMgICAgICAgICAgICAgICAgICAgfCAgMyArKy0KIDMgZmlsZXMgY2hhbmdlZCwgMjkg
aW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS91YWNjZXNzLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS91YWNjZXNzLmgKaW5kZXgg
M2EwZGQzYzJiMjMzLi4zYjJjNTdjOTE0MTggMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3VhY2Nlc3MuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS91YWNjZXNzLmgKQEAgLTYw
NiwxNSArNjA2LDIwIEBAIF9sYWJlbDoJCQkJCQkJCQlcCiAJCWxlbiAtPSBzaXplb2YodHlwZSk7
CQkJCQkJXAogCX0KIAotI2RlZmluZSB1bnNhZmVfY29weV90b191c2VyKF9kc3QsX3NyYyxfbGVu
LGxhYmVsKQkJCVwKKyNkZWZpbmUgdW5zYWZlX2NvcHlfdG9fdXNlcl9vdXRsZW4oX2RzdCxfc3Jj
LF9sZW4sbGFiZWwpCVwKIGRvIHsJCQkJCQkJCQlcCiAJY2hhciBfX3VzZXIgKl9fdWN1X2RzdCA9
IChfZHN0KTsJCQkJXAogCWNvbnN0IGNoYXIgKl9fdWN1X3NyYyA9IChfc3JjKTsJCQkJCVwKLQlz
aXplX3QgX191Y3VfbGVuID0gKF9sZW4pOwkJCQkJXAotCXVuc2FmZV9jb3B5X2xvb3AoX191Y3Vf
ZHN0LCBfX3VjdV9zcmMsIF9fdWN1X2xlbiwgdTY0LCBsYWJlbCk7CVwKLQl1bnNhZmVfY29weV9s
b29wKF9fdWN1X2RzdCwgX191Y3Vfc3JjLCBfX3VjdV9sZW4sIHUzMiwgbGFiZWwpOwlcCi0JdW5z
YWZlX2NvcHlfbG9vcChfX3VjdV9kc3QsIF9fdWN1X3NyYywgX191Y3VfbGVuLCB1MTYsIGxhYmVs
KTsJXAotCXVuc2FmZV9jb3B5X2xvb3AoX191Y3VfZHN0LCBfX3VjdV9zcmMsIF9fdWN1X2xlbiwg
dTgsIGxhYmVsKTsJXAorCXVuc2FmZV9jb3B5X2xvb3AoX191Y3VfZHN0LCBfX3VjdV9zcmMsIF9s
ZW4sIHU2NCwgbGFiZWwpOwlcCisJdW5zYWZlX2NvcHlfbG9vcChfX3VjdV9kc3QsIF9fdWN1X3Ny
YywgX2xlbiwgdTMyLCBsYWJlbCk7CVwKKwl1bnNhZmVfY29weV9sb29wKF9fdWN1X2RzdCwgX191
Y3Vfc3JjLCBfbGVuLCB1MTYsIGxhYmVsKTsJXAorCXVuc2FmZV9jb3B5X2xvb3AoX191Y3VfZHN0
LCBfX3VjdV9zcmMsIF9sZW4sIHU4LCBsYWJlbCk7CVwKK30gd2hpbGUgKDApCisKKyNkZWZpbmUg
dW5zYWZlX2NvcHlfdG9fdXNlcihfZHN0LF9zcmMsX2xlbixsYWJlbCkJCQlcCitkbyB7CQkJCQkJ
CQkJXAorCXNpemVfdCBfX3VjdV9sZW4gPSBfbGVuOwkJCQkJXAorCXVuc2FmZV9jb3B5X3RvX3Vz
ZXJfb3V0bGVuKF9kc3QsX3NyYyxfX3VjdV9sZW4sbGFiZWwpOwkJXAogfSB3aGlsZSAoMCkKIAog
I2lmZGVmIENPTkZJR19DQ19IQVNfQVNNX0dPVE9fT1VUUFVUCmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3VhY2Nlc3MuaCBiL2luY2x1ZGUvbGludXgvdWFjY2Vzcy5oCmluZGV4IDU2MzI4NjAx
MjE4Yy4uMWE3MGVmNzA3ODRjIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3VhY2Nlc3MuaAor
KysgYi9pbmNsdWRlL2xpbnV4L3VhY2Nlc3MuaApAQCAtODc0LDQgKzg3NCwyMCBAQCB2b2lkIF9f
bm9yZXR1cm4gdXNlcmNvcHlfYWJvcnQoY29uc3QgY2hhciAqbmFtZSwgY29uc3QgY2hhciAqZGV0
YWlsLAogCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgbGVuKTsKICNlbmRpZgogCitzdGF0aWMgX19h
bHdheXNfaW5saW5lIF9fbXVzdF9jaGVjayB1bnNpZ25lZCBsb25nCitfc21hbGxfY29weV90b191
c2VyKHZvaWQgX191c2VyICp0bywgY29uc3Qgdm9pZCAqZnJvbSwgdW5zaWduZWQgbG9uZyBuKQor
eworCXNpemVfdCB1bmNvcGllZCA9IG47CisKKwltaWdodF9mYXVsdCgpOworCWlmIChzaG91bGRf
ZmFpbF91c2VyY29weSgpKQorCQlyZXR1cm4gbjsKKwlpbnN0cnVtZW50X2NvcHlfdG9fdXNlcih0
bywgZnJvbSwgbik7CisJc2NvcGVkX3VzZXJfd3JpdGVfYWNjZXNzX3NpemUodG8sIG4sIGZhaWxl
ZCkKKwkJdW5zYWZlX2NvcHlfdG9fdXNlcl9vdXRsZW4odG8sIGZyb20sIHVuY29waWVkLCBmYWls
ZWQpOworCXJldHVybiAwOworZmFpbGVkOgorICAgICAgIHJldHVybiB1bmNvcGllZDsKK30KKwog
I2VuZGlmCQkvKiBfX0xJTlVYX1VBQ0NFU1NfSF9fICovCmRpZmYgLS1naXQgYS9rZXJuZWwvc3lz
LmMgYi9rZXJuZWwvc3lzLmMKaW5kZXggNjJlODQyMDU1Y2M5Li42NWIyZDAxMDNhNzMgMTAwNjQ0
Ci0tLSBhL2tlcm5lbC9zeXMuYworKysgYi9rZXJuZWwvc3lzLmMKQEAgLTEwNjcsNyArMTA2Nyw4
IEBAIFNZU0NBTExfREVGSU5FMSh0aW1lcywgc3RydWN0IHRtcyBfX3VzZXIgKiwgdGJ1ZikKIAkJ
c3RydWN0IHRtcyB0bXA7CiAKIAkJZG9fc3lzX3RpbWVzKCZ0bXApOwotCQlpZiAoY29weV90b191
c2VyKHRidWYsICZ0bXAsIHNpemVvZihzdHJ1Y3QgdG1zKSkpCisJCWFzbSB2b2xhdGlsZSgiIyBI
RVJFISIpOworCQlpZiAoX3NtYWxsX2NvcHlfdG9fdXNlcih0YnVmLCAmdG1wLCBzaXplb2Yoc3Ry
dWN0IHRtcykpKQogCQkJcmV0dXJuIC1FRkFVTFQ7CiAJfQogCWZvcmNlX3N1Y2Nlc3NmdWxfc3lz
Y2FsbF9yZXR1cm4oKTsK
--000000000000c765e2065075bee2--

