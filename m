Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DEDF8A154
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB446B0089; Thu, 16 Apr 2026 06:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C827D6B008A; Thu, 16 Apr 2026 06:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98696B008C; Thu, 16 Apr 2026 06:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8D716B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:30:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50C298C543
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:30:39 +0000 (UTC)
X-FDA: 84664050198.27.0970E84
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 401D41C0012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:30:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776335437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z9HEDsaws+1AaPEcUyrGjtCss1Kv3jZQFAB8Oib7mmY=;
	b=u3rTrFDfz1vVF0Ij/SU0jnIxyA/Ys7nikcSsOXJkxIKJ3tFr7qc3H8+N7Bl2ikls3/4ZYy
	oiXZ6U8EUMYo30XWiMXqA9Xlwi+KKYdjsXloaUw+njaroQlyOPWqZhUPeCvgjJ34drc5cW
	0stdp2TOUQbRSPwx4RTG5504MyFz5Pw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776335437; a=rsa-sha256;
	cv=none;
	b=K/Q08UgCQa/VxZVk8sdl7LHyE6Bz11XrC/11lFHRiWGijrJ/SfeOK0SytxFjxE3Br6Eiho
	ZYNV6klHaN2WXJLwXdWLfQEH4YhRVicSTNvI6UieAoDl4hneOj/4pSlFdigvXwaTHr8acW
	hG5ymtQt/ZwFUD8lhAhPUYTQvfaBzbI=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d7ebe11bffso6492847a34.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335436; x=1776940236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9HEDsaws+1AaPEcUyrGjtCss1Kv3jZQFAB8Oib7mmY=;
        b=kF29Yl86XPERvUcqxk4axM0SAAhwpHgpZpBfup5xjtWKzwbtlB97kXDK+AqW/q4F8K
         +1gkRABzZLI5nASM4uSt0JQgdmV7KeSBq7bCt7GoSg9vJeRAx2OXya3lk5uF4OkTIugQ
         Zz8nsA09uJaxwNe7WnMEa0d/+aCaGF4xfONmGzVtGGOSK123hGMdmSEfQ9iZIdeAjVhq
         vRQ3yIm9J8bWO0uzdqezQVidRNZPpY8SMOStdiVN2NKgPGbMBWDsxAO7vnzFqHDkyYNA
         TGhToBDBW5cqZUukjHo6e1qFyC8xDbA//D+yTcYBlaHLhzjaYgybCkfcqKGlU9wZiDcg
         t1Bw==
X-Forwarded-Encrypted: i=1; AFNElJ/PU/KjuYL+ClXBSfYGOeDVejmeJXNu+HqCBtbHxzR9RLvVFtXFVnqDoxP8EOzhUzmLNEOmWIvjow==@kvack.org
X-Gm-Message-State: AOJu0YzwRa7HLqK7qBdLzX/+SnFIlWynkTllMuU5qNwNAmK6znCfl/sY
	+UpJhbSGauVjSt1SvBJ2TTwIUMkXPb4KdyB2rZr1oj44CmETM1BVlh0hKZ/31mX0
X-Gm-Gg: AeBDieu6K6Y9XvVloewaS3fvw8z7lr6HM6xTM15SChTIXdhXo3icaVBomaXs6zTJVIN
	d8vxPRryBR9t3MJndGGiml3NCwCPkgt/FARHNdv7AHnO9sWDoqSvSEjAw2cNwtdeneFSeXj+Hp/
	Y4ucAJocqeUbtXcQUoRYQ7iF3TJRT+4asMeg7Q5I8hnp0lSYTI0K/EDDV6AGDC1YTd9MQ/MC7AU
	dTHzrp4Rsvdtt7YKlTiO3kzHtLJhTrSL4dE1wvWtDgh/yCJmFcpzrzaCNYDrV8LyHUAQKGDjr2O
	rfrhbqE94DMAZyJWynhhl5Ysf0oezSylUpbA9b4crcZdVfxi+Ot4EOjY7Krj6xXqUidTYVes2Pq
	1HrRs9a82jUJyxEjKSVYBH0rIOS49eMtA2Nruz+KnbUEIvo505LmsBxj3hdEGMb+NON0SWsl2oT
	hsYf68KjN/QlUl6a5mXP7an+rGy2VMlpAX43QBFmn2kKh3M0mz2mq9GgG6OdwozTSGlqE4fpI=
X-Received: by 2002:a05:6830:25d5:b0:7d7:57c4:367b with SMTP id 46e09a7af769-7dc27fe671emr16374696a34.28.1776335436152;
        Thu, 16 Apr 2026 03:30:36 -0700 (PDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc76b95a2csm3322885a34.22.2026.04.16.03.30.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 03:30:35 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dbcb467f2bso7038133a34.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:30:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+3Do32z6mV7HByv6zFsogO8BFDZjaB4s2eaBrzahvhJiFegel+Hhlpidd+JlfkpF2JnbDeZdyPdQ==@kvack.org
X-Received: by 2002:a05:6102:c48:b0:608:cd24:354c with SMTP id
 ada2fe7eead31-609fe9b0d22mr11966750137.3.1776335071251; Thu, 16 Apr 2026
 03:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.794680738@kernel.org>
In-Reply-To: <20260410120318.794680738@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 12:24:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
X-Gm-Features: AQROBzDRGGELVSySTko37h6zEj8YoV3p6pwZDCVQUlUW6sZbw_W5mbJzFIh35nQ
Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
Subject: Re: [patch 18/38] lib/tests: Replace get_cycles() with ktime_get()
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 401D41C0012
X-Stat-Signature: ixnub7xbgcya6xjpn3uy8a47pmys6ayj
X-Rspam-User: 
X-HE-Tag: 1776335437-439868
X-HE-Meta: U2FsdGVkX1/JHwrNfBG8VrdfaDxhnVqJCJ8mkd7zdwN1UqjDGIDyxpDvUUZwlJEY5Y+diXf0C9Il9gTmtSPVDq87qJMe1yx9UcimyXdStfHglC3HMgaiyNxVFo2habxi1zv5GzhKD1Vb725PVHS0BkKbS/+LeLnI7bBL3xOssQdMgAl/2hdOXxObKcfaIq5ny59xNv1x3xyUB+Fc+xQXySX1FQTM3GGPyeWpsDQMlLnytm9AsVu6aYCfxtgJhWUdgM4HIBXUWvQLieJOcTmiKqB0V+G6rc+Cdh573FTCgSfQBPiiJXgZ3I0AHGbaeefydgSj4nciLzaTOcbD8A285B9ZAAq5f0k3YTYIUbMMhQ9AVXRvs7VEsvricwPI1UfEVzpyYyoRfQnJqYjpGKgx7o6U+VgkVjqyVuCxzMqoHl+zHjgXQEMlnm+ZVl99WdNQnQ6ycU3pg2EUJ3syV/pRBBL3J0R+RNwtGa29e04Rk2yLyuPo/uKbaiVoVjs7puB8GmZUQ53Yckn+6w7fxR+30UNbGSysOTMmv1tE2js5e9V1e/v7FGUHqXoJBFv9d3wuwVh9sPb5p4zNmGbS5RXWewrBrfkS34W5nCvuw9Vo6wLhfv3Zfhi7fIYK6aNHr424Ebw0kb1ZK6FEOCFS6xah6nYGBz2CWmgwnws0BhWT3mLUIKkIh+KZeoPu94au7Juoszcq386WrjyQ2rJXAbh7/DvsoV9ZdEzMiIdsWmNfMSWuUNaC6h/EfnCMqktMWMx6HFP6UiKTTBApWmgvwvPO6zI00WLtgHC3ho98y3/K5dq+K/9bJa3GHuFjhsednw2mUNuuuEA15LEnfkuGb3YX4nvzLbodKCQTvfg05JlTeVGvtfmjrP+zaALO2ba2tGcYZVxy8N3TaVMQGW5buQ1VYMq/BhRg3UzRqi2eS1xwkZIezBYhyeh5/cJMa3J8XbT2NiYgXio06lbAhoiRlMb
 WFrDS0kN
 GLk0bSCCwcF6RbcTTVQGZ5E/4jmodA0k8AcifG3vJONkBHEOlob1epbsESPJt7baWwdImXtDAMcHziGjQT3C2B3gZc5mEWI3bFuthFDctcPINmG2ifOfPzHtbHqr63rqu3ilCzyKjMYXqtJ0HCnuPo7A6pCaeQ5oUDnaOiMPw4h7HSbdEW7SFReH2pA+VydhErF2ksBQ9j70wOvt3J0JBidT59r77YhWAaUd31STxC+udTE+7MAD/a2ne5EFHE5g3WJu3C5kztTdudbOSnGbqnZSxun5z7np5xgmppFv8ZyP3NY6dgONIVrpihBciq8c5qWMk1BEAjSVZ7IiOlw+AdpEDHwnhrT8RXohuccgoNYbbIBzpxEfSykamOaqYHtqy6xK+JT17rjPUoO/UjvCtjSgC1Yt4cbKZlmxv3hVBKigr5AMdKKyJnRXEGIcAiVY8P7Z+AOn7tcG2pMzCN05OD/K68KYImif779nCPIqQxnB9+jND682fpz1Of9afOdTT+qBJ010ngpcuxOMFGYkQ0HMg3KO3W5vdb1mY+y1jYOJVQSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> get_cycles() is the historical access to a fine grained time source, but it
> is a suboptimal choice for two reasons:
>
>    - get_cycles() is not guaranteed to be supported and functional on all
>      systems/platforms. If not supported or not functional it returns 0,
>      which makes benchmarking moot.
>
>    - get_cycles() returns the raw counter value of whatever the
>      architecture platform provides. The original x86 Time Stamp Counter
>      (TSC) was despite its name tied to the actual CPU core frequency.
>      That's not longer the case. So the counter value is only meaningful
>      when the CPU operates at the same frequency as the TSC or the value is
>      adjusted to the actual CPU frequency. Other architectures and
>      platforms provide similar disjunct counters via get_cycles(), so the
>      result is operations per BOGO-cycles, which is not really meaningful.
>
> Use ktime_get() instead which provides nanosecond timestamps with the
> granularity of the underlying hardware counter, which is not different to
> the variety of get_cycles() implementations.
>
> This provides at least understandable metrics, i.e. operations/nanoseconds,
> and is available on all platforms. As with get_cycles() the result might
> have to be put into relation with the CPU operating frequency, but that's
> not any different.
>
> This is part of a larger effort to remove get_cycles() usage from
> non-architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Thanks for your patch!

> --- a/lib/interval_tree_test.c
> +++ b/lib/interval_tree_test.c
> @@ -65,13 +65,13 @@ static void init(void)
>  static int basic_check(void)
>  {
>         int i, j;
> -       cycles_t time1, time2, time;
> +       ktime_t time1, time2, time;
>
>         printk(KERN_ALERT "interval tree insert/remove");
>
>         init();
>
> -       time1 = get_cycles();
> +       time1 = ktime_get();
>
>         for (i = 0; i < perf_loops; i++) {
>                 for (j = 0; j < nnodes; j++)
> @@ -80,11 +80,11 @@ static int basic_check(void)
>                         interval_tree_remove(nodes + j, &root);
>         }
>
> -       time2 = get_cycles();
> +       time2 = ktime_get();
>         time = time2 - time1;
>
>         time = div_u64(time, perf_loops);
> -       printk(" -> %llu cycles\n", (unsigned long long)time);
> +       printk(" -> %llu nsecs\n", (unsigned long long)time);

While cycles_t was unsigned long or long long, ktime_t is always s64,
so "%lld", and the cast can be dropped (everywhere).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

