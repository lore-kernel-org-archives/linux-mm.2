Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62318CD98DA
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3FE6B0092; Fri, 12 Jun 2026 07:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875AA6B0093; Fri, 12 Jun 2026 07:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763C36B0095; Fri, 12 Jun 2026 07:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6688A6B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:37:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7DF3120349
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:37:18 +0000 (UTC)
X-FDA: 84871059756.24.EC94A0C
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id C363140007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:37:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kPUbTjBd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781264236;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9dyxygjV/3RofubGPQY9xrYK9q7NJvG8u++ttMJ7jM=;
	b=5CGDm7+QKEzQZ3SHpIj5U4/SR/gc2h5uC2AzRR8bd1xwjOp7ULhbjomvHmqSdPehiKLJcT
	DKqJ+EOlq51WQrF+Bo2VdTooev/y+O8AK264gvs17rp/G/PnHMfB5uoRHBQIjVUgihI82t
	DUyQpYS03BE4RyQJRGFzlye/QZTvifg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kPUbTjBd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781264236;
	b=uF9bYKpkMmRB/lsFJWzU4VolC0o03h23ijk6BlzbykrQNsa9JhvLMI0pJMdNMvVF8mGoPJ
	J4uUwbh71SrKltMGzjXRZr84N1Sl1HswJesk6skMnHqmflMFojpNowqJsgbf8irvUwM7wk
	I1voYvePD9Scj0pQFFrennRtDI342mQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-491b390f9e9so1927905e9.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781264235; x=1781869035; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=j9dyxygjV/3RofubGPQY9xrYK9q7NJvG8u++ttMJ7jM=;
        b=kPUbTjBd75KchMOhamSWqZJ9c2A6yBEENLy54vQ/FTB3jTmYnjA4TbMe2eMTfKRViB
         548v7ypfPPjqJnHGSwXA2XE3KD0uUbyoUc1NaOJTQxZyLFTHzTG84HYIkcoVQF8n1cV5
         QpVB3/Xm+jLl33wKUqBy3KRdWlcrzF9F6m59LXe3X+68i/I3KDBcP8HcYC5Gqu2dmVtQ
         A6zWCrn/s6lS5PxUhRgXvuCsEKrBBfxqLjfXlbm9m7StrH8AVgOEZQ52LM0raWf+8IfH
         7YhvLSf8cHPNBQHPDmNTQV0RlLFWZ25uhVa+hTjIHYEoCi/YlQC46phUmm55GfOEwIXO
         fwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264235; x=1781869035;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9dyxygjV/3RofubGPQY9xrYK9q7NJvG8u++ttMJ7jM=;
        b=ZZeH7O6vDg7z3HwcFtZ8XyahHdWeJW6UrImDQmJ06dEPjzTtt+Ik6CIBoEh47Ly6US
         C6c6QJ+KJK3AbJhud9cYzPeOgBPR0mIBpDYujd8iQWES0RlzmvwHWLXYvvC7bmqTjbfi
         GxZiZLUUbxxabojLu3unDh10j8BLeCvIvkFNfN4TqmM7TLv8MEApOzwvBH1nhGz1xLUk
         Me30eufSdfb7jCjsz33KVGX2KyhUMSKZSDJqU4mTMa1awEYSrTHTRkmn8oCjgoIL4KDl
         7Q3tblhRtDYdOy8jQ5Eta/cOddcnYsLan7/1ZiOfRxpGSky37usLsJSLPWxIieiuvDaj
         6sGw==
X-Forwarded-Encrypted: i=1; AFNElJ++rj0Vdp+BftnJZEOR6I/aIeGBTm3/8vlS3EZXbbDZFqfuBCOhDHcZcbX+kLETQDpSB8K3/qa1Lg==@kvack.org
X-Gm-Message-State: AOJu0Yz4GBKHkiOxQRjFwSgZ7uQZapo59DuI+nMVobfVNLqWv36EBdKa
	L46FypD3LiRRyo/4VBG8Fio7xv7zvHhjiefphp8e/1uf7YJxlINiYojx
X-Gm-Gg: Acq92OH/+O8+zXX573qkgZUtGHGvfXYFd9gbMs2HfGqw0Qsj0nECoSXDoT8UOETZWbP
	OeWP9HQkTQR7Go0ZuIkmYmpJNjgb+KsUPtlOKm2lrVc5KbOOru0SO3uMrXkCQRmbejyvT9gJ8UD
	vXZEG4nVfcgbsnkZqQu3y9JNTk/N/qlbGNhjyT4jmaWklu6Fi8wD4B6EvaTRZTE4ciq3INn+2MG
	PN0Da3dSt7CfhmXMuFNTGQmR2SomR19t4IcNhDi2TH2gE4CEl9p39r7C6R34yj9fEk8RK98LFLi
	akTz3BhWhLvpBwz471n7Zs5A9C44wumHQiqypwvgC3FyXgcAfBAI7Ufzj/xnlOuHXaZd3cIlBwF
	Qqn69vuErOGplBsrf0/FN72pHNtQNyowhJFTbdDG+q1XDO3gOXOFymJn2dtFkEPFPHwCSghz3qc
	1E5kPpzD4VpnCkPKyDV50rr4m7f7hBxe2lopzets6KcL2c4Rj0TwmIuAEXay1GjIttIOAkDWau6
	Xvjp28A8MuB4mak+9k=
X-Received: by 2002:a05:600c:8486:b0:490:a298:acf7 with SMTP id 5b1f17b1804b1-490ec4ee700mr36638215e9.17.1781264235050;
        Fri, 12 Jun 2026 04:37:15 -0700 (PDT)
Received: from [10.128.10.215] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2637ccsm4885808f8f.6.2026.06.12.04.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:37:14 -0700 (PDT)
Message-ID: <2e528372-aba4-4621-a9a3-7ce23571ef37@gmail.com>
Date: Fri, 12 Jun 2026 12:37:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/14] kcov: add per-task dataflow tracking for
 function arguments/return values
To: Yunseong Kim <yunseong.kim@est.tech>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Andrey Konovalov <andreyknvl@gmail.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 Yeoreum Yun <yeoreum.yun@arm.com>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ipth9j13f5jtrkcb4i4pwm8f1f7d7u68
X-Rspamd-Queue-Id: C363140007
X-HE-Tag: 1781264236-310140
X-HE-Meta: U2FsdGVkX1+yl3uwruOQIW3JdkVPNwIhQ1krz/dbsjsMIiZ9yC5rNdv7K3Rfjb52UPrRJ2tBQKN462qzTx4Vv10r4bEicb4GC0x39/+qYzswsAtiUmPD+gUGFQK/NTyc4CPCA10CP/mMNZdsIAu6M8MUgpdnk6i3ShPmlfmhsPHxdtWHenbQeQ/Ox9cYxqEa6v0IvHjtV42DGx4On+wnUR4ks68A8FkLrB+y2qc+hyXPkf+jkswIUwT1NDOhPOylo9JoMh+oYqsALVdT0aAPOCeO1XX4UmC40mIx1qsEQKGZAl523OwYeA+c6me6sSVadKcVMZq0pW2JZk88wj8+GU95iSVNkjlJM/VGfGQfwW/YhAQfBoEy+SMplWEu9W063PcguHzYJOxpTBWEKWDICoOpFh6NE5kYDnDJZ39PDThjx/VdwttSDhQ+T1c/+RnWoYuWP0XEzhLJEJ6pzsia6t3TFMsXhdI3NfKm9k0/Ifp+WvHFUPV6jOMV9llXizfQXklBq7ocfhOeGtOk0vb9656cDVv7LW8P1dxzfxZXPksiu/VhIZWG7ba4YT78O1ILeLJ4v9d4R410Brk4C1LgQCPLojTuqJ5p9vhd+0EAvWP4WvVOrbSWcVsZ8Va3SvNPIromrL83C9U3VDmjbY4I90hQeea9iVZfVRt70ebSZfaJyADbbHt9kmaAdw/JmLO1l0Th0JTM1jAhwRC12JompOgFZs2gwqQuDEOApI4T1XE1xNW7ngEv7gwlGbkVNrOneOmO7K+HslPPCguMBf9kBaPKWoqioKkIh1/6xh0Co0klpgG9JZ1aGUECIGmMqm573v7XNDVNaO959/VDRIdUX7XwFAJ/piY9f2hvEAE8a4zVou5ywS19MPlyYAqzrokTf5EvG6f44XjqYGkOjGAqkwWN97jfwExvkbkz1P4i9YMXNWWWHB17XBIGjvTcRReJF2WQC0dEKmsOcZlC2Dj
 133cZGOP
 uyw6ZsRGEsIpnpCo4v+33DbnBshrLFXrS3mavJbN3D4GO/gARqHY4OzpZ22Sdz5t6OuuaNa5+r2Rxf/WzkaP+mc7IAMcLaVIkTLvVYr7wG/j4g9+Y6wlu1HIounbAFppflrXxhG/dVUVJpHVu7bje71InbJbdpiB03NOnrJKp9MywJSyhy+o2KSNa8UWh0HM2nmzSmPDEWtqbKHRtvJvc9Ic4xPuc9u2Kkcc67Dl6s1etEUgunzNFxRR6dNFx9X0lmYR0OhtQRR0bGYgQ2f/M02cgsEH45JEm/gmgHMjJVBzOUMy0mrAVtRpG8ZcxcblruTlkrT7S9xwBIHdL4PywWVEXC6hVMeGklLPF3umC7h/rcJpYTSLJZc4Dt8JM8AnoS7NMYHyR53/0VagwJQe6AeG+Gk+1Oen7uhmDaL2vGBMg6oD96rtBPiGbkWyXjM3VHyhJFP+CeELweqvQ7GUKwl9e8z7tPY/4GAUUdMP6UmMZ6yqrIao1nRnsigfFMhudS+bjLD+gVpg6cX51hrduE/MAKEHM8Ve36fpTu0sh2Nhn+sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 17:21, Yunseong Kim wrote:
> +config KCOV_DATAFLOW_RET
> +	bool "Enable KCOV dataflow: return value capture"
> +	depends on KCOV
> +	depends on DEBUG_INFO
> +	depends on $(cc-option,-fsanitize-coverage=trace-ret)
> +	help
> +	  Captures function return values via /sys/kernel/debug/kcov_dataflow.
> +	  Struct pointer returns are auto-expanded using compiler DebugInfo
> +	  metadata, recording individual field values at runtime.
> +	  Enable per-module with: KCOV_DATAFLOW_file.o := y in the Makefile.
> +	  Requires clang with -fsanitize-coverage=trace-ret support.
> +
> +config KCOV_DATAFLOW_NO_INLINE
> +	bool "Disable inlining for dataflow-instrumented files"
> +	default n
In Kconfig, when you don't specify any default explicitly, it's
implicitly 'default n'.

I think either style (implicit or explicit) is fine and both are used
throughout the kernel, but is there any reason to make it explicit only
for KCOV_DATAFLOW_NO_INLINE, and implicit for the others?

- Julian Braha

