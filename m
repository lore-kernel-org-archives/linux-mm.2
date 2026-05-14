Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5056BCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8950B6B0088; Thu, 14 May 2026 03:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CA46B008A; Thu, 14 May 2026 03:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782116B008C; Thu, 14 May 2026 03:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 697676B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:55:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A31C1C03F5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:55:13 +0000 (UTC)
X-FDA: 84765264906.11.8875649
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B60EC0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:55:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlJC6ULd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILxCmYkL50pA0BzEcihF0YhatRIafK5z4/k4jZSf+Gs=;
	b=GIdL+Hj89Fh+RUj1aLWrXOQOXG8dyoCK2HRAkuG9e+y5kPH9cqXIK1YZhWP3oQVJa9QjHe
	gHw6P7ScPiXUQM1TkDuazFkxCtBl4Xe9UEg6LI1Gfq7zstGAnRO+zW+cITYRCKRuPF+bes
	38yrA4xKyCxue/3fEFbi+18/95tqUQs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778745311; a=rsa-sha256;
	cv=pass;
	b=qwp14xzLmCPbupjKe2iky/b37dd5Nsm9O4puZtgAouyM4KU+Subdt+yaK5LxUAXFMbgsGc
	sRg0PO+sXeuHxgsfqTBCCwaDIPYd403Irx/XWOG/kLcyMG6/xb+o3NPgj2IxkwloTWRdk7
	YEZUMDRUaYV/61XPruFBGZCWcOycnIE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlJC6ULd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2f7020a928eso10734346eec.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 00:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778745310; cv=none;
        d=google.com; s=arc-20240605;
        b=Ha+BYDIJDpbVSQly2HhDeIdkr9frdCycksZHJHeP0YVWWxVTHxPVkz3FaWwLhzrkL0
         OXsQKhVWNMvMAK7JPcG6LnRN6Pwo0qEfluPOhLDUntiDBI2FVZOxt8LqVKWWn2q+KVwN
         xLZkigwejXpGTsvePD32x+sU70ke3dSGMetKIZhyt1TwxIz/f4serZ7WJuQFNeeIS100
         Lv5JEwfFSUM3tUjmJDjMkFq27YMZEQbylQ9QTnEYIgKRUJGTxRANpyF2T6+Hs0MUXulr
         4llwkrCrodlshR6nFjmpb1+p8zy+eqwZeNYb+8qTIAFrcm4aGw7zJwGYTnWEH5gtQ56d
         rKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ILxCmYkL50pA0BzEcihF0YhatRIafK5z4/k4jZSf+Gs=;
        fh=qt6XF7MywLilf0JCEVusZqTve24byR3o+MTS7+xD9o4=;
        b=edIYl3v1HEoLCU/YKkRGXX3qoAGCYAsZgFiVvBg15H1tQ6+SU93ntdkXlgGKv9/BMU
         HKQ+/L3wd04r7ZwMUMk9ctho0+ja6AWcz66t1FpG96htAglj6HDicwrcyDG2sOg2d3Lf
         6SggDpb0ufQFASVLUGv5K4BnXwGPWQBDeFb6jItSf2QkeNQkbLa9FTugT6Y4SUaJqOHB
         oW3mITNwFwL1P48Jlx6V75IziXxdogbDFIlQXE41W0MIXROlRKhiASZnFDKKaKwBYsHS
         cJ6VwivVPQkvU+bKTAJGPyDR/sEww1OttW+Up+36XClhXdcqNwWgo3t7ttfnT4kqpyp6
         hLnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778745310; x=1779350110; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ILxCmYkL50pA0BzEcihF0YhatRIafK5z4/k4jZSf+Gs=;
        b=dlJC6ULdzBT3MBdLUT6iKzA1bXPKdeiQTWWz2HaoLF9HVnJK2/yN8K+mH09qQrR8OH
         cCmYarI5HVMzppzJOFKQDY0WX5FBGhwjRUwySOwCiA80QvTLHKZjNhkPvLCH3CbKq4oG
         GAc58zxWpONmtYH+Cn+2Y0v4vmXLy5zBAd9BVzgjiWBQ8yJg/jE/CY/rIbirXczQzmI5
         Z+Gt2//f2o6n5X0DY1mhYCKQ14YN/Gswb2zBleQz6A2TWHP0VmvwniQsmpdA6kzY6FT+
         R3j//48NNdCMVIiz6rCRI/fVnjzCMiROuVyrK+W/tpiuheAWsnPGNlCjSOr/NMvdk0gz
         JjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778745310; x=1779350110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILxCmYkL50pA0BzEcihF0YhatRIafK5z4/k4jZSf+Gs=;
        b=JzF5xpip670IhASBq4oaGp5rAqFfK7SSA+2gZdRTz5AQRiTMWFt6vqbeVzcVhWJ2FL
         jfAE4suxfCY0+llsPEvjHiI60CTCYxhl8RE4/Wta+XScD5v0JaJr1ICuiMc40OhQr2Re
         Xr5dHol+ykyZmUmwjN3NoOo5pmUiiSy7WZFY5bn4QOcFWN2VfpgeNDxSio9OrkeI/5hH
         PE7ZMlpoPw5uuVECbddjT1pKQzd4ddpYGjaKiAA/UzawQtK3gu5LrlW2vjxY6oRTPugk
         r+7+fY8o0qilIGgSLqjIylZgBR3sW/CoL/WlK2j2/RJt8uAE4x2rYJ+01blE9p4i1to5
         QWNw==
X-Forwarded-Encrypted: i=1; AFNElJ+cgbqvu4zxkQeGbsx/Hm4PZngqXfDGhwPy4XlGHLEFynT1pUe5jWwD5h8CzIN3pXRhmRGYtfJxzA==@kvack.org
X-Gm-Message-State: AOJu0YzTex81kjUH+jWgE3Hn30ZC/mcfME+NfLw6Dd54L08sv+HX+6iF
	UHkxW9J2ogfZ7Hz3TsxymfPOYAQnwpnW6NtSixuad1FEtwqy5T5uSwABUVNF1WqXR0Zb3rl2MYq
	xCURp9AnyXSg9HMgCj6yMVgSZs72iDnE53BJQ3t4i
X-Gm-Gg: Acq92OEO3vvsFsKvFKSHtogrxuEm/HrdGu7bgxTmVEBx7lBDowUchtcml3ZPmjI2LIv
	9AZEAyUaJrJLEdPOJVoN0pglVlQKSjnopGkWkOwxUtwL4bKVmWyXciqAifAPgpQG2SGZqF9Uokp
	pj1XYHmOZ8TcE4UYkHxIRqeJdUZhrSWlp2QGhi0+C9vspc+5dZtbWT7URT0oWHA2uuPgbDubydV
	emrMseW7aNbGLOuejofiTLigtNzx/Jvha+WQZ4UGtZIUpMUK7OgdZdrWpzFshhHL+9socGUP+qX
	EeU8TceIhW8/OanW00NeXAbeBxJ73jCzcI/lJBNCU29/5MZbHQ==
X-Received: by 2002:a05:7022:f9a:b0:132:2486:b47 with SMTP id
 a92af1059eb24-1342ef3d502mr4606238c88.3.1778745309159; Thu, 14 May 2026
 00:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260514050455.2954509-1-justin.he@arm.com> <20260514050455.2954509-3-justin.he@arm.com>
In-Reply-To: <20260514050455.2954509-3-justin.he@arm.com>
From: Marco Elver <elver@google.com>
Date: Thu, 14 May 2026 09:54:32 +0200
X-Gm-Features: AVHnY4JSKKs4-AOrzjQCzwh9kSmbyo54JL-yInX3IhQgKt6h5_imJyB2qQ8DYtg
Message-ID: <CANpmjNMLa39q=Ss7TVzSi=TTef60AX4_C67XUifanio9YeHB9Q@mail.gmail.com>
Subject: Re: [PATCH 2/7] kfence: kunit: skip when no pool is available
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>, David Disseldorp <ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1B60EC0005
X-Stat-Signature: n9uk1dkyagnux4iedhddsdudbme8kutn
X-Rspam-User: 
X-HE-Tag: 1778745310-825519
X-HE-Meta: U2FsdGVkX1/lf4Hj67reSa6Hk2te4uxVoz5tfvYbZKKq7UxPI1BIdMxZHkpWkfgqP4vR3q51Vo3XQclFo+sTEhAYhh46ykbzazJp3nldMeV4GZ/9Qb+A7CKzgwgCrrrU2IrlCZb+GLJ9sHhMYPBmnyucxB+ODy03LSuQH6QqhJdfcPq8qFyWM2+WN6YtOX1CntBawNEKShtExOSYFwBYbvLYxAe/BSEpZsL4qAw43ls9OQsHK1fl20w5xJC/Hh95AIbxDWi7H8wAal6vOmsKTycGg0A6l5pRx72IBCFhAnS/2P0zAcuD0aTmSr0XWr/1fZhzR8apoGPoU5aQmTk2lVd7oW2NJwVqOb8gWWbgF+vCBE4PmHS8HwdA0XpNO+GwiPhFMqKmpVK16sUQL+T1Ohu/65gVztIYU7uCNItVa2FyhbRXDHm/8CblfHTtfvmuTc0Wlla2aoD1lHdwNI8LPkJaQZeVY2MQHrbNwXCZ/Rk3AJVrEyPRvpp8AiHXBEXYUCQA4jU9YDPUfbhgsiLf54XbRuOxMccCxxPP2synHj3Jn8Nlcc66Ub+Z3kv8VoYIjqloPIAXlkKwVFmvkIBHvGKtsCZ8ixTeVBw3emUrTZT1FivZql0damYuTowPB7guFIYT7ueG6KGrsGPLCRN8wIdC7qgZBgD34X6nV4t94WopzREF20taUDwd+aq8ATtYi+EfGNGWoJOIntHr5sDnApBJ60W/5Z76/jyAfP++/Wh+5gtn/VrSlkkMyDQgnGTgKOGEr8tmChtcK4ScuSx3DE62VGfDxlHcWWu0qZb682OEuOyqi4J8u4wY0sV1kZjuqt2LFG6MHQFopHITpnlJj7g/9OUe6/Ii7mc/b17v6DnLaXFgoMAQ9Zz1CitaB4U8sksUwUSxjXXXD7bAM+PMDmVZGUB1z1iXPv3AfoGtbUweQbavOxoMdhwSvUP127XUQPPMVLukNibyJOFQQqR
 2gzRA4aA
 nNV9MSQtyn8ak8blDxAwK3nXECU0UHYAmNNID6+Eg+ya7skJCi6068yWQ8lsgOfYkrGuavDN+lOrGQb6S40+VEqpF8LJmyQDoJde6JBlnkxV/qcbYu76RGUIWGATYEWXgwys4mdS/Gwy6bg/gjEvwbsSU+FkDkGas9QMM3rwRz93wywztlWNHXrc0TmXSoFwRxK5UY/hWtlfbafzV1pcPeXvj8rc/PgDQFDiXatoIp7EC+kyGvqvM2eoNHkRs4NNmjfO3z+IjMs8YQjTQAJpK4qY89WlQ4fhmBJmYU+CyK0memss1x+ah10rX9ldBkPDsJGHgs22YC7NxAQhBfQkUSHf0vPAM01r02ZxzUYP489olb44gLItiI6b7/C+KE7couM36dafv2yOysjJpgzfM7MKyY2NK0o3TQVyfzLbQ8Fbk/EhPwnsqY+rdsCAPW1qUfYl15pD/9VHvnFJPrOSk6xQJDeABBR7pHskaVbUlpFJ83DSV15sKpT0pYgY4RyX1gIba5ds9l6tbTGK4dDV+Wdy5E2liU7IsmBZyCnWI/ptgXdQ0FyuM0yGejuC43xhats5r+OhjXK0aoMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 at 07:07, Jia He <justin.he@arm.com> wrote:
>
> When KFENCE is compiled in but disabled at boot (KFENCE_SAMPLE_INTERVAL=0)
> or __kfence_pool is not allocated, every kfence kunit case fails with
> -EINVAL.
>
> Use kunit_skip() so they are reported as skipped instead.
>
> To: Alexander Potapenko <glider@google.com>
> To: Marco Elver <elver@google.com>
> To: Dmitry Vyukov <dvyukov@google.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: kasan-dev@googlegroups.com
> Cc: linux-mm@kvack.org
>
> Signed-off-by: Jia He <justin.he@arm.com>

Acked-by: Marco Elver <elver@google.com>

Fair enough - typically this failure was a way to know something went
wrong in the test setup. But I also understand that it's not always
possible to just not load this test if kfence is not enabled, say with
some compliance test suites or such.

> ---
>  mm/kfence/kfence_test.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index 5725a367246d..e376329dd621 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -822,8 +822,10 @@ static int test_init(struct kunit *test)
>         unsigned long flags;
>         int i;
>
> -       if (!__kfence_pool)
> -               return -EINVAL;
> +       if (!__kfence_pool) {
> +               kunit_skip(test, "kfence pool not allocated or kfence not enabled");
> +               return 0;
> +       }
>
>         spin_lock_irqsave(&observed.lock, flags);
>         for (i = 0; i < ARRAY_SIZE(observed.lines); i++)
> --
> 2.34.1
>

