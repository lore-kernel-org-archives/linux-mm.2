Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F59CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CD96B00AE; Wed,  6 Aug 2025 03:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334A76B00B1; Wed,  6 Aug 2025 03:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2716E6B00B2; Wed,  6 Aug 2025 03:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18C396B00AE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:17:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 981D11A02DE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:17:14 +0000 (UTC)
X-FDA: 83745476388.29.2D96C46
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id CA45240005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:17:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iir2aUhK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754464632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXLDPCGDjNvdOeR7jZ736CzN/nAMcYgqmwaHMi4ddf4=;
	b=KbC5oQZRZ7LoS8cVhoQH/QKvAnJl2pg8243CLOkYikqGAUrHNRN9iPz7HVSgMlk2Loxfht
	GJhNx/HO0fmvXXIrqIyVwhEmbXeQuCFRb+Vs7Xq3xeAtknytT59kGUUY+tk9IAmHi9m4HU
	Ct+fz/08rzAcAcP1XJj8MmlQxLu6L7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754464632; a=rsa-sha256;
	cv=none;
	b=NjQyvj9NxF4RWJ3wCSd+67URA6BD16Nv2z9Ey4DdlYLHpeGP374O7kz/S+ZYStJ35ynC5Z
	waXj2Pdsy/gPBm+hbDems0rXjrkG/84WBEOBEJ+9tZISbuZpJq2TlDFC0p+sOoCJOpkUQ5
	op/AW0Vp1fbKTH5V0XGQonXET/3nYtk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iir2aUhK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24022261323so6763045ad.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 00:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754464632; x=1755069432; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wXLDPCGDjNvdOeR7jZ736CzN/nAMcYgqmwaHMi4ddf4=;
        b=iir2aUhKrHVnP9y2ONhZRKpzSeOodLUGFpgUR0UT+jIaCpFj1Iun/NF4sjFo3LLm+7
         PWYQzaZV+rIIXneZbmcZx7fk9JZBaEejYIkwu7rptNNk/ymE8daGc/gOmzQHn27HIHUc
         m38ZzwbWD9sv5NIBJLNCwVpXvXUC7QGyvMqLfw3+ubYHEm/kxODdHruSaO3GmyLPvAIL
         d8BLWA/NlfTPvw/SHmQ69hVy47wbA60Q4Fliom2NDNALnj74g0TiZocr3dPdlZvsrJpm
         86mu/bnV29v1d0/x/rHpIr+BxjyGHsvSvE3S1pq4od7Ex8eWrKjvgzAAJdkmR5G5Unyv
         32pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754464632; x=1755069432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wXLDPCGDjNvdOeR7jZ736CzN/nAMcYgqmwaHMi4ddf4=;
        b=kvB4buaLIsyZ2410aPk6FCl//p2x31kFVdqVc1P1Lk1nFgQK2vGcLEmbbH1gq86ZMI
         jFzeDJiNVPZ4Oqm/lWdDwaxSvVzIB4yuvKOZNPPLVHCWfU0HL/ZxYYNgX6uqh/bNWdIN
         5iMEzcW5lJrueL8qRV3m1sEEx9gQANqldOLIdjTVpuho8inYyUKIvSPb01gIZlHhpjTE
         0nCN/Ycze2btsfl7YxTmdT6dEo4bPN3U/jKctTZkWa7cxMBYIXEldFq0eGNQZ9E9CGTF
         C/Y31kIGLRT1qg4fl3+QaRV/cfIH+YggY6MorxrXSeaE3lOMN99MnKscHs36SzKH14yx
         stHA==
X-Gm-Message-State: AOJu0YwxtkXnATEkCpqExz9a+uSk7Vl1rjzF/mF17lcU9Z8G7kOCJdT1
	QP8AvKvvg8d57d4iQ+FivV0zfxUiANV+0e4QklbVYLPZ+T57RXbbFIUfLp4HOzxNLbSCzz7MK0p
	RX3NZ6BEqaielB/aNMcUonU8r+TNnL1CmhiwghEwT
X-Gm-Gg: ASbGncuTrruOK29STfm7Jv1dJ7ml3I4sFLjsyqm8LXN/PU1BLwOKFTBNUWh3dvXZoP9
	pGvUWF8OhEdmz5To+8ujOjVGzX9arW2/t31PuklLKP0DFA9f12uDiduq2si9JhoaOBStTRFLxc5
	8UHvyMWNpQaLB1xhfJ+ZfiFAzdYbs+BYMcmlN/9PZOf9OwLE1jwxjxvBEeAM+rkYSNUppOrVYF7
	g9FAygzdqsSsC2/L9cl/X/suARlyU48DvYHGec=
X-Google-Smtp-Source: AGHT+IGfHgl2Mg+qBoCrK1ngL7bmW44UgruqWF91vJSpnlAVaiAXHK2sy4pm6D5yit5Nm36Buca8JPYmaeowROChcNw=
X-Received: by 2002:a17:902:f691:b0:23f:75d1:3691 with SMTP id
 d9443c01a7336-2429f959eacmr24836285ad.15.1754464631438; Wed, 06 Aug 2025
 00:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250805062333.121553-1-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
From: Marco Elver <elver@google.com>
Date: Wed, 6 Aug 2025 09:16:34 +0200
X-Gm-Features: Ac12FXwlK-cs-vH-SavIGCKnyqqqvtGaUUbmDgA0yfosyX6KUMYZkchuphMeuWE
Message-ID: <CANpmjNP-29cuk+MY0w9rvLNizO02yY_ZxP+T0cmCZBi+b5tDTQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com, 
	akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CA45240005
X-Stat-Signature: mb4ka5qhrh4pjzf4yyztarij1ag5g6f8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754464632-283940
X-HE-Meta: U2FsdGVkX1+yWJHvZmQrM5QNDhB21wez8wpQzFnZxK98CZV3AypUl5/CzpQm+wXskD/7vebrQNpTrO/wsAPOc73flO5/as0cMVLPaIwSqeNCUaT7D7syxVY56uScnkfxL/4Ki1fGxErqM0TIYJoqAwfGq8ZFVmDD+6iIO1TkZfF/a1b78tT2CMKRCvPrUTDT2louuliuet4uWS5NL4PVupf3qqNqeUKThAdb7DfJSevtny9Cyof8tR472V7OXCfJuucUv1F8fyWzmPIpuHaRVpAPTfaiiMuDT3p99vvo+NefjTYAqYAYwSwXOom07FTfepDMKn7hOOyQRcVH5Tx0QsGDOCVLMxmQIiW9aOXW9Zk6bR3yA5c2fNMNZUf2hDln6KsUIe2s3EsP36hNXV2emaq9HZnW45+smh7+NDtVSGSw6Kop9sFaw3Yixqa3mrvwJBO3JZ5fQxz79IhCsVtWGGE3EaCUOij6NMdlT4X4VYdBW48BVl5MsBw1hxir2Pn6PrNa8uM6i/h0pso53cMgt/1rXV57kz+KZI8493FiHWNnmzBfSm0fsOHIbA+ZKwwbNG5+Xtb0K/bciv2bhJ2XMh/y1093sNZHX0kwsBtgAj+HuKx796NQQnWvJFdZcqgB2UgORQPpL3l8g0JGDxk7+D3Vvyfs1AWigekS7tDyU+OHWqagJYgDS9QVRB7kqg1vChJvJ6A7N55Y+KcVa6bAGilcUB5idgJd3TO+FD9FEwMDF/IOvkjVhn7Z5Orr8kQlm0OI46GBaWxu4DEcc8K+5XH8JNy5H8TI+sA9wMrV7M5a4LRDWYTX/5lG1iRJxSYG1BHEQ0rUVxVWo9eJ3kBC5PbJIaTsJ98BB8klT4Fbz34D+GXMdj4TZ0L5PTqgVN+yPq6xZDahtsupmxm9DuugNOq7RrrrsMcDjO5+DJUlKkRpK9AnRd5GawzVJyr1C9KZHXZxZ5B3cyxTMh2z2bZ
 KT8g7SHl
 abT7vV6cFz8QMvC0lTK2ZElLmPC8wMd8zZ65ARUlkui9eJvMR9KteGNbQwi3fKfinrC4aYUk8Te1QUrwXDhOPtjkdYb0WriGJ8JWZllXjdeJcn+qYtWR+nLxqokE6dFSGyqDeyRp0psX3fJh5OrT5zMawWJ8W0S37GjS854cbmlAN5Q+m3O/6bUj8dSfOEJO6jv0GRtUUUXVyb2RzOvHar3RquFtS+dF79m8bYRMg/vvE5OezwhDyz6N64pXsJg4qlxH0ZgcOzNOEfZ2xSzunSVu6D+Uhr7P0br+h0vh5C/1AohbLzbDBP8YEnbMVJRhE+paqKQVFvUqMiJD0cwvb8oBnVlulRjV7q/No9vjKCVEVcsm+49FnSVEn9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 Aug 2025 at 08:23, 'Baoquan He' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=on|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.

Are you using KASAN generic or SW-tags is production?
If in a test environment, is the overhead of the kdump kernel really
unacceptable?

> So this patchset moves the kasan=on|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> kasan.
>
> Test:
> =====
> I only took test on x86_64 for generic mode, and on arm64 for
> generic, sw_tags and hw_tags mode. All of them works well.

Does it also work for CONFIG_KASAN_INLINE?

> However when I tested sw_tags on a HPE apollo arm64 machine, it always
> breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug
> can always be seen too.
>
> "BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"
>
> I haven't got root cause of the bug, will report the bug later in
> another thread.
> ====
>
> Baoquan He (4):
>   mm/kasan: add conditional checks in functions to return directly if
>     kasan is disabled
>   mm/kasan: move kasan= code to common place
>   mm/kasan: don't initialize kasan if it's disabled
>   mm/kasan: make kasan=on|off take effect for all three modes
>
>  arch/arm/mm/kasan_init.c               |  6 +++++
>  arch/arm64/mm/kasan_init.c             |  7 ++++++
>  arch/loongarch/mm/kasan_init.c         |  5 ++++
>  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
>  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
>  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
>  arch/riscv/mm/kasan_init.c             |  6 +++++
>  arch/um/kernel/mem.c                   |  6 +++++
>  arch/x86/mm/kasan_init_64.c            |  6 +++++
>  arch/xtensa/mm/kasan_init.c            |  6 +++++
>  include/linux/kasan-enabled.h          | 11 ++------
>  mm/kasan/common.c                      | 27 ++++++++++++++++++++
>  mm/kasan/generic.c                     | 20 +++++++++++++--
>  mm/kasan/hw_tags.c                     | 35 ++------------------------
>  mm/kasan/init.c                        |  6 +++++
>  mm/kasan/quarantine.c                  |  3 +++
>  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
>  mm/kasan/sw_tags.c                     |  9 +++++++
>  18 files changed, 150 insertions(+), 46 deletions(-)
>
> --
> 2.41.0
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250805062333.121553-1-bhe%40redhat.com.

