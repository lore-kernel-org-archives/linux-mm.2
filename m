Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69067CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 10:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DE68E013E; Thu, 30 Oct 2025 06:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEA58E0112; Thu, 30 Oct 2025 06:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4848E013E; Thu, 30 Oct 2025 06:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFB18E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:25:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E816893A3
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:25:19 +0000 (UTC)
X-FDA: 84054398358.10.A4E3114
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA1AA40017
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:25:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="E8jz/+bO";
	spf=pass (imf11.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761819917; a=rsa-sha256;
	cv=none;
	b=cUu/CBy6bZN2taV/q9MWTwA/FnAHOyYdTCMs7G8TXOVb3ui/ZZv0VLFMJTqSOLvUE7EDw+
	7F+tQnPSDb8Q1i5heYaUGtqvWp0AUuSjDjqiCq4uZhfLtbVbJpDb2R4fwMVx8F1QwCMMa/
	monWSqrIa0k1oCs8Qi+qcGDQiHQOGUw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="E8jz/+bO";
	spf=pass (imf11.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761819917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTgIsc3O+wDypaKqBlwZIo86kBPQGfr40arZuVCJ75M=;
	b=TdU8kty4J6boYMEKunqmsviT/nIlN/agYhOFxMo9UXKfv6jYUT/ygfOvkI9mwo3wE4jsuP
	I9sScT2mDm2gSAyh817QiHrUe/k13Ml0QfsaBb2kRicb4OOTdCQcwPbKF7L34bNPq2xtFs
	Fwt3PM2XEMV+qwN1cv+6U/jtumBttPc=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3c82276592so15106866b.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 03:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761819915; x=1762424715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTgIsc3O+wDypaKqBlwZIo86kBPQGfr40arZuVCJ75M=;
        b=E8jz/+bOH2/3rd5fymI7GznCiBAQ4aeFooREND7T7arA41aXIp3CDNUDjJd16kteo3
         1wWPQsZ4ZanBPkMcWmh5vitINAueoMCo1Y/FlWw43/hSfzuDKXvfr+Rb1xH73WD2y/lo
         iPj/DOf07C7Y0HnxQ9/XSZMymogeqt0oxibofgQvwb35ExrFeN9fm13Pf1iDC2CaPaiD
         wpt5rDT+cACpb02+1Ow8/yft6Y+GBy3yxCxt0uWifQj/Xbzuxd6EW7m56k9a1mPizjAV
         qOiHqCmIKPb5F6eB2yM1Dk49ZxrQr90/nVWQQ6WgIB4xKMg7RUtK/mh1JoFDG6dCwwvO
         zIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761819915; x=1762424715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lTgIsc3O+wDypaKqBlwZIo86kBPQGfr40arZuVCJ75M=;
        b=auq4SJ1yZpkb+IINiMtN/OWTKuSM5GYLXmZivEGTjBdJir6QwCkcO7k6PI0wtQ2BE1
         F9EQ5QV74ztZhLGzZbt45rk7aCRPaUQtqPGEcrJn1q69Km6cms2IVmiYV20vNaDv3aZ5
         +QYHa1RqYo0v8QTGWT6X/wbtj6g/lKnoIDMY3Z70v++S7QxovmIo6myl/HSfZfoMVD9Z
         pf7bgh37RS2B/TP3BiGQlVv4t/QOti277KWCQCZtw8DJQW3J+oag3cF8SOWD084jWK6f
         2yNQHWJ6DjRbcIv9Q1r+ZIsqBpB1tRcXtpcK14ymmW95psDsw7KRGcerJu0EIhhpyIOy
         oINg==
X-Forwarded-Encrypted: i=1; AJvYcCWIKKtd1GysT1LJCAe7sA0tDDzUxZ71MpYXfZeY2t+V786/sB8vnpC6ituW+l8aw1z+1lflGbf+AQ==@kvack.org
X-Gm-Message-State: AOJu0YwzzLHeFodthJIjxnPLgkvCDKtn/4aMKpckUps72kWRMe3t5IWs
	W0V3kUxnaCYfYrninlnHt44wUcJyUdj98FxdtZ//d53EV4Uk/gyN3OF3qcD5OtHordc=
X-Gm-Gg: ASbGncuqlRamVbsnCjMMVvV1/n9Du/WdlqKj/UVLf4NSwNKKCxDOs73qWcNnst6tWPA
	GBqZmODq+kzdgl+qEAWCGF8aypopka2QrD3XBBnsqOw0YAZ1iH6jc9ajsMACL6krhCfBFQ9+wpZ
	tLycpPegA89oLJr8Xcl6oQZVRMFAWL1J8qSXjEQH4LUkoBB3Ufjm59uDkseCVgG7EQ+L+6aOKAn
	1yVegKY57dNyqeKkPhjNMZTR2GROV+mFhUDmju1HEBvX6jy4YKIX2wENekBZx9NMQz/J0T/MWwW
	S3J5f/3vCqXH6YxAbsp+51hDpSwLl3kU4DOchy7k8yCVlFCyy/Lk1aqbvYoVrLTauVXsguvWKeI
	tUAxS+P881xviG43rPIvosabAT2B01RFCH2QN8dfJhp4NeBX6wE0OvwTthIMQsupznpy7Aa7ixZ
	8nFf40Pm7wkrWTobX/tx2A17C5gHcVWi5zNjPJbQ5GQADup946CX9R6Y/NQ0eknsGKB4+PNc3/s
	C3o
X-Google-Smtp-Source: AGHT+IEXsUOIqP3MBMqvuO3EOkZU6BKA34oP58piwLuVoouucxjytl3skX6Ka8nntE+ckkHO79CK6A==
X-Received: by 2002:a17:906:f586:b0:b6d:5439:e668 with SMTP id a640c23a62f3a-b703d55e454mr372826866b.8.1761819915166;
        Thu, 30 Oct 2025 03:25:15 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853c549fsm1728375066b.37.2025.10.30.03.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 03:25:14 -0700 (PDT)
Date: Thu, 30 Oct 2025 11:25:03 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Josh
 Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron
 <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel
 <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, "David S.
 Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn
 <jannh@google.com>, Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov
 <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Clark Williams
 <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v6 06/29] static_call: Add read-only-after-init static
 calls
Message-ID: <20251030112251.5afcf9ed@mordecai>
In-Reply-To: <20251010153839.151763-7-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
	<20251010153839.151763-7-vschneid@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: u1genuyb5njzehfbyzfuaae8rtirbr3r
X-Rspamd-Queue-Id: DA1AA40017
X-Rspamd-Server: rspam09
X-HE-Tag: 1761819916-439861
X-HE-Meta: U2FsdGVkX1841N6XMENELl1l/LdX4jaBfHgMenxe9agszunCyNXuw6Is1gBV+AqhBdeocX9Pv6q/mmqJ+qhulok20Lx7QQ42kk2ZlCMhAW742ysicW3G+m4hRvTbcxSR141GArAHZOUSvVYNJ6v4qiAyLg8m2ni8+yDeQ72TXWeQdYfebyv/zSRRHZomzktQQQpV9ajx7qRlQAZvN480kAgb1MJuxw19AqFbVV9YS5lKwgDbcJZRHO1AXmReCM//SSDtyGf7zv019QHanDqoRGEOqm7T+96EUgi8xf1Dsq7R76kOT71BHM8xGJaiUu1X+loXDILnrIKBbRSpDjsvGFmxUrqnNgurC8qDgxUOymKvufKGNR1yyyteJIDotVadAecsuVjPCswb6XT3Rx8BqutI2BVFLGZaEJVrSiXrpLY0aINGh4pa73/LnGoc10MZdQzHUZz+3ujeZKenSw9eKKAAp1gxJ8TYjzmKUQ7+RDNDbOndpZzSCmln0b9bBV2YJ8HJKUQRzSGZX8x1MEr5f3gY7Apw3pQWjnOQ5cqQeYIacAuvTXwt7krEF/kcDSQ8fK1LXv9qKCoOtHYFdjMjbGd/reGa4DGNpEogY9W9eqsd3XYN9oTxfE41oOxz5puUnzN97GsPYHPA0y5gOfSVljI7nGrVlEOCZoX8t2lYQAHwO/FEeKGIuUnH0PdzZ+TInkrwjIa56N3mkUfqBEvm7jaQgRvLtu/W3QCbSseK2nMElZfo8CMgDjpfuGMopQU1ggdpps3q6OOpVL7AME3rOOgRUaihM/KC4PryjO06iOfUg1U8lrVOz5faoGi/Rb3x+DLGaFDSkDsZTXunBaejkSgPmfV66kS4wzjAqCk5PyxS3ZW073E9aL45AM+5HnWlAzDSQRP167/DR6lqm0zHyQsldyoBYJHeWfhHw8rw9BnSnIyXXJeqqdtL7ymKoAWmziyUwwqjtqXwg84d/BY
 e3X6zD0q
 bIoFgwCLwit7dF8P2aT23KEC33PPGgs7E1efM0Sl6ovadv3uybbkM8cFS9+Cqft8Fvcgkz9NBApSJcxCDP5YpFYy/2tMhl/7ua2+Qs9LvzOUocb6psuc0QYV4oRigUgzMAd15RWE2LVaNJl6Ls87hNnHyY4LpL1WXkDJJCHM+V1e6gS2I7JnsExi/M/UCt1UUaLAX3foWh2V1RpM9QST1P3/TIWjqc898jvC5EdKvReROM4DHWxG7GEwB/numTFX9vvBkq62aXQoI1MdIdPfPvNngVl22/TjCNiMTK38YYe0YEp8E0JGORTbOVmnnbHdWALNfVp1B5hDzykNsc/J+eHuDdRQia/W3g5Zu8iXxOIg/ssMw8Lzp9ijRoc39CASArB/bqxE74oesKOVgeEGCuZ8dRrlna3eOSyCQFHCyajesJ9PFceQRxeRiRaW7p4p30TkHa8qug+Y/mGDx5hSAVKS8VCCj26+uPkfUM5hjbr7GkA7KBleg5wzMrFXEnGgDs2O0AHIY8HFbdwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Oct 2025 17:38:16 +0200
Valentin Schneider <vschneid@redhat.com> wrote:

> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Deferring a code patching IPI is unsafe if the patched code is in a
> noinstr region.  In that case the text poke code must trigger an
> immediate IPI to all CPUs, which can rudely interrupt an isolated NO_HZ
> CPU running in userspace.
> 
> If a noinstr static call only needs to be patched during boot, its key
> can be made ro-after-init to ensure it will never be patched at runtime.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  include/linux/static_call.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/static_call.h b/include/linux/static_call.h
> index 78a77a4ae0ea8..ea6ca57e2a829 100644
> --- a/include/linux/static_call.h
> +++ b/include/linux/static_call.h
> @@ -192,6 +192,14 @@ extern long __static_call_return0(void);
>  	};								\
>  	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
>  
> +#define DEFINE_STATIC_CALL_RO(name, _func)				\
> +	DECLARE_STATIC_CALL(name, _func);				\
> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
> +		.func = _func,						\
> +		.type = 1,						\
> +	};								\
> +	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
> +
>  #define DEFINE_STATIC_CALL_NULL(name, _func)				\
>  	DECLARE_STATIC_CALL(name, _func);				\
>  	struct static_call_key STATIC_CALL_KEY(name) = {		\
> @@ -200,6 +208,14 @@ extern long __static_call_return0(void);
>  	};								\
>  	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
>  
> +#define DEFINE_STATIC_CALL_NULL_RO(name, _func)				\
> +	DECLARE_STATIC_CALL(name, _func);				\
> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
> +		.func = NULL,						\
> +		.type = 1,						\
> +	};								\
> +	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
> +

I think it would be a good idea to add a comment describing when these
macros are supposed to be used, similar to the explanation you wrote for
the _NOINSTR variants. Just to provide a clue for people adding a new
static key in the future, because the commit message may become a bit
hard to find if there are a few cleanup patches on top.

Just my two cents,
Petr T

