Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F17CA5FF1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5ED6B0120; Mon, 19 Jan 2026 02:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3E86B0121; Mon, 19 Jan 2026 02:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9C86B0122; Mon, 19 Jan 2026 02:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39D896B0120
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:00:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94B01D220A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:00:55 +0000 (UTC)
X-FDA: 84347816070.22.3849A62
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD356100014
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:00:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rqH8axJf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768806053; a=rsa-sha256;
	cv=none;
	b=u+UOPW4rOKNamSGr+SvgHxuAgCksmHYJbh7eMfUUy1CcnchREfZWXIWHk6wzGj/QeKThq9
	A8NPiStFhDB9dNX7q/DygcpcddGHmghpMaZOx165m9MQVaQ1o4NxbcDGaWM9ZN/Lryw4Dh
	Hr31dEU/GNMo9/30Cue61nawj0SMKIM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rqH8axJf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768806053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fo5muEEC/4uiFscWJK7IYUZtOorTUjdByfuGa30k45c=;
	b=LEZGn0OrZXIJsZUjK4oF/esrsDGeHNzlHoC1YFNwjPQ4vyjdMoEUhWITf6ZuU1FwxDvceW
	xfPzWcRrJgW/9DEz3lnya2Fiof+ldVwcDHNdSPvVWA9chnER7jO8suJ8udC7M7rlKDEb0o
	8yeDaMoA9Ic4k71io1nLcRWIVEIx7rc=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1232d9f25e9so7772061c88.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 23:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768806052; x=1769410852; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fo5muEEC/4uiFscWJK7IYUZtOorTUjdByfuGa30k45c=;
        b=rqH8axJfX/i/V+COnW84ZJmppG81wnZ96a8rOckz0p2jhMYCkQ+9LV7HdjbapfmTT7
         fwCPG8TGidQz9ritGACJXguMKrT7ihk3p/0iRMSH+hElxkJQCDQzQ0l6SV+PAA3uR1cS
         +R8BXjDPDaI+qBDuZ2ewAQAbTJ21cpwAff8N75kq9/AFCZ5QYkCEAvxQTS/GG0JtJpQ7
         NUcKVV5vyCMASM5AoZcVEbaJYRGU5mP89OSrzyvgOhXEPqVBNISGmCeNGE+1II7lXaH7
         KxkjyouUMoePImUMGIOCNhQsy83PisIweO6OVEcUS6qKi2UVyQJxGglgRR1LQ5ITYPSB
         RNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768806052; x=1769410852;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo5muEEC/4uiFscWJK7IYUZtOorTUjdByfuGa30k45c=;
        b=uEVBgZhk7nkPnYQezasuPLxn6B02rttKfLkhychz5dBl5DN3xYWNsyz5KPFnQEmgnu
         gYbUdTMVNC+AqQCmmZX2rGsjc6R3Wx7jwYIrs8WRgHh6wUmlZVZwMB0uePWxZ4dzs6UL
         OWIcDe6XfSKCQGyFKLndjQqh1PJMbH+HzQWJV9twcRNquQGOnT871/HRoly6V9PStYvZ
         PixTVuZz9yZ76raGj2ZsLbLwLZv7Enskv2Gpsne2/gmrT+Zvo1a5O3TGWblNGLXOvZg2
         EVyw7ciyU2bvRXPqjZyIBRXhPTUtPckCthRn3F2Ua8/a5/7Uk0WvXp0JHmgC5G5DD8Fx
         iu+A==
X-Forwarded-Encrypted: i=1; AJvYcCX4fO2gE/g2zD7MoQEkhe7/Pa/8utnLuZ9/YCp+4MYjNWLsK7tKRP871jcfAIfv/dFo18BegN4iXg==@kvack.org
X-Gm-Message-State: AOJu0YzexbGt+1d4tP80fjphdYXGi0mOgZSXmgqahV5B1sB/7ZWhuGua
	kzXO0mG25w4QMYMNmRIg9fBrxD18O6486sYuiLrUL9Wd2Wztuw5z5tGbPPHuNANLHGX1xsUM+Oh
	cfvU3hh1cT8WJFTvnLRNsEb+SfRAiaGWdG59Jo2XC
X-Gm-Gg: AY/fxX4fjX07g2oitElwJvo1aZSfRFz/GV9P4/W8TI8eSzRko0xwLvGyHp8SFnIv2i7
	cRjWhSwKaAlDonP1x7oZmI68qOXW3wXQ8duvmWQ8eRER9A79emSB6KDFhGQX6EHsjUl0lgKad2s
	SEI07oYTyjXpz8cT9lIoCSS4MNUXV3oFR6JcjDC4CJr8rJVjebBwOqL+Y7DtiUwexodGASSS5/f
	RMKGZH/skcvs1RX2wI522M/Na8HoIMkWdE8RCBB3wfQfG7rwPw7d+LnC8kJWsi3JbQzgIJ/JNIq
	E2hYxQ+x8x3UktDoc6iBoP/FWQ==
X-Received: by 2002:a05:7022:e24:b0:119:e56b:959c with SMTP id
 a92af1059eb24-1244a780e97mr9208724c88.33.1768806052109; Sun, 18 Jan 2026
 23:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20260116-kfence_fix-v1-1-4165a055933f@debian.org>
In-Reply-To: <20260116-kfence_fix-v1-1-4165a055933f@debian.org>
From: Marco Elver <elver@google.com>
Date: Mon, 19 Jan 2026 08:00:00 +0100
X-Gm-Features: AZwV_Qj-7_C5RZeZFEzQ_TdoyMwljOGRCUd8lyAzdaF4C9d9CcGc1VCTIQrXvPk
Message-ID: <CANpmjNP5R3ALvtuMyLVhHGZpyZ2MoR7hq07jJFcSAN62Cnig2g@mail.gmail.com>
Subject: Re: [PATCH] mm/kfence: fix potential deadlock in reboot notifier
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, clm@meta.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CD356100014
X-Rspamd-Server: rspam06
X-Stat-Signature: ay1crpko5p1fjzhabwefpg5ejsjos89t
X-Rspam-User: 
X-HE-Tag: 1768806053-784238
X-HE-Meta: U2FsdGVkX1+wDQzvljwiq1kMfiwVnUaxHBY26YjJ9NO3tbQr1Ayu3ufLd7mPYvlQO1p2t/W/t5LKrjMlTxtzgdr3nL5V0aMu4o+CFjCgNHcz4VqoZWYp10zqdyUqHOlDlJwUTQz/zc8SM/MS5Y3HMzwc3VwILIAptAzWLE6RfE88PFM+btgJUaLFfF6XVGtDlqFgV+j0jxGTY1NtOrABmhDlmWs1qNszJCnxllZ3jwjf+o76T9v/SLepDSgpmzWcsqiUFwyaR5B3munaWJfjZF7pYsM5E+XYURCZh+Fv0OjKMTCJxpE0BaDRPghZArcE0EAS7aBS56xV5L6qu+QvlOFLIqd9znn1d+caO41PEDAh+UjCJPNvySqvqT/1EJDs/6ZlelJTFeVix6/OqT3Xvg0Xm3jJV+2L9cotFlo5cqilRwy3ahL2/v2DpwBZ/exYG2qp1XrPXyZ7rA5estfKZ0q2BL1r5Sgar3gcXYq7RPijo68TonQUm4hKx7iezscOia0lWvcyX+tOg9mKQSdsLUWo0aOS7m7GfIKyima9pq2yPH1cu7MAF4p8C6SctqBec4EjHoS9sEv7mt4be8vZCgVGQEFYYEVWeVZN9cFyRCTZpAqviY7A5DN7cyB1sPZ5+ybSiOhIh4bLQ31p4uusv331DLjlJvl0oXzmsZrBeR8La1AgVn9EiEPRaZZulGyLMHisBD0EEeyQ+I5Oj2tae1QtG5SAejsRmKIJAdt1DuR6vWZl+GO/TixfZINrcGHYD4KmYdxHURWa06jImNoBpLYvO0mm8q8J7EhPRMZfiGKtPD3RG7vH/+R9YuLQtRLUB4UDMb8hZowXtTDYQscckPeBa08lhGKJXavNtMwrGvzNGogl0bY9OUOiWJwb8pToyUXneIrfF7SwWApZ8n+TKb68KZfNINY/MLAq5k1Q3Jdx/Tup1auYpNsYhnqRnTB6vb5nxDvVm4P3ZDglAJt
 Rpupm9jE
 Q7Ftqg3yDUXa8mGVg4uZ0lbjPymgBA38vYcdPSq/g6FOXvAa+BWj/nmY1jTD3MkEDb82qiXyE/2MDMB6zluehmmM6PmmBWUqGOnqL+g7udW3TaO9bT4LwbMB8qSBgCKREYcz8WNA08+aOBbaDCHuMhZwD+d0o8B59n4iZj8kGYB5fwJhOpqxpjHQDHGxtidSDNa8sz+DbIjCCYPfd16htoqE4+bclnMsnYzM4IE2vSptP4mvKIYbK0jnMX4hljSuJ/BSmMXfb8StgVvQxP2+cPCEFPJ9ucmOvcWHK2PS7gmp6yf4YX38I32qdWRAmbdVwAKhp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 at 16:49, Breno Leitao <leitao@debian.org> wrote:
>
> The reboot notifier callback can deadlock when calling
> cancel_delayed_work_sync() if toggle_allocation_gate() is blocked
> in wait_event_idle() waiting for allocations, that might not happen on
> shutdown path.
>
> The issue is that cancel_delayed_work_sync() waits for the work to
> complete, but the work is waiting for kfence_allocation_gate > 0
> which requires allocations to happen (each allocation is increated by 1)

increated -> increased

> - allocations that may have stopped during shutdown.
>
> Fix this by:
> 1. Using cancel_delayed_work() (non-sync) to avoid blocking. Now the
>    callback succeeds and return.
> 2. Adding wake_up() to unblock any waiting toggle_allocation_gate()
> 3. Adding !kfence_enabled to the wait condition so the wake succeeds
>
> The static_branch_disable() IPI will still execute after the wake,
> but at this early point in shutdown (reboot notifier runs with
> INT_MAX priority), the system is still functional and CPUs can
> respond to IPIs.
>
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113140234.677117-1-clm@meta.com/
> Fixes: ce2bba89566b ("mm/kfence: add reboot notifier to disable KFENCE on shutdown")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 577a1699c553..da0f5b6f5744 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -823,6 +823,9 @@ static struct notifier_block kfence_check_canary_notifier = {
>  static struct delayed_work kfence_timer;
>
>  #ifdef CONFIG_KFENCE_STATIC_KEYS
> +/* Wait queue to wake up allocation-gate timer task. */
> +static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
> +
>  static int kfence_reboot_callback(struct notifier_block *nb,
>                                   unsigned long action, void *data)
>  {
> @@ -832,7 +835,12 @@ static int kfence_reboot_callback(struct notifier_block *nb,
>          */
>         WRITE_ONCE(kfence_enabled, false);
>         /* Cancel any pending timer work */
> -       cancel_delayed_work_sync(&kfence_timer);
> +       cancel_delayed_work(&kfence_timer);
> +       /*
> +        * Wake up any blocked toggle_allocation_gate() so it can complete
> +        * early while the system is still able to handle IPIs.
> +        */
> +       wake_up(&allocation_wait);
>
>         return NOTIFY_OK;
>  }
> @@ -842,9 +850,6 @@ static struct notifier_block kfence_reboot_notifier = {
>         .priority = INT_MAX, /* Run early to stop timers ASAP */
>  };
>
> -/* Wait queue to wake up allocation-gate timer task. */
> -static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
> -
>  static void wake_up_kfence_timer(struct irq_work *work)
>  {
>         wake_up(&allocation_wait);
> @@ -873,7 +878,9 @@ static void toggle_allocation_gate(struct work_struct *work)
>         /* Enable static key, and await allocation to happen. */
>         static_branch_enable(&kfence_allocation_key);
>
> -       wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate) > 0);
> +       wait_event_idle(allocation_wait,
> +                       atomic_read(&kfence_allocation_gate) > 0 ||
> +                       !READ_ONCE(kfence_enabled));
>
>         /* Disable static key and reset timer. */
>         static_branch_disable(&kfence_allocation_key);
>
> ---
> base-commit: 983d014aafb14ee5e4915465bf8948e8f3a723b5
> change-id: 20260116-kfence_fix-9905b284f1cc
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

