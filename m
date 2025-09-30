Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FBCCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 08:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7076B8E000B; Tue, 30 Sep 2025 04:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE4C8E0002; Tue, 30 Sep 2025 04:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4998E000B; Tue, 30 Sep 2025 04:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 447B58E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:33:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4B421A0617
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:33:45 +0000 (UTC)
X-FDA: 83945253210.19.552CFC1
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 080F712000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:33:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XAokL+X0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759221224; a=rsa-sha256;
	cv=none;
	b=O8tEP5fJHWNkE8a0GsdTw4KUBjFLi8lcPEsq8x+kFyafWO9UmkMxbO5j49c9acagwQRAGq
	CPrbqoiL0L7M+lPPXpzRnmbUIMVNtAwsd/DaRxXjnNq5+q/Hf605Kp5ec4PeDs3pFx5pfb
	pbeg9dQ+bwBWqd3eazunro1oLaMHNb0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XAokL+X0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759221224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBOPU6N+QlAarzu9LlqnD6xE/6f1CWCmb96507SlQ5Q=;
	b=WsMBovItgpYATHGlElrgSxn8ACSbzFpcGXjEiz3Ag/16lLXb0xGyxAm6I9zMEd1L4fRogv
	TAq/vrFBI9OldU8OJSX6jPLVm2GSmexrS62saKUDtggXNgho7gBySH9UGTYbgD8iTFkJ5e
	+FwSRWKjRDdv4ChxSXwaOsW30DBN2mc=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-723ad237d1eso59717857b3.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759221223; x=1759826023; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBOPU6N+QlAarzu9LlqnD6xE/6f1CWCmb96507SlQ5Q=;
        b=XAokL+X0PsDrql7hGkhEigmVzZ5HfWsa3QFHEPebmzLvoTchs7/LIX0O4Cfz2cLksE
         mBKS6/Dtmf6B75/UxrWIiQK0V7cI8LBvOqxBhXiK3mZepCdxLB8b9fhOCeBPJbUmDmRZ
         XKnqOoppwdkRpLFZa7A8wB7w9kqgSG+hiwM0jPcNG7zbXPvJON9jcXIC8boFvJjC/rVv
         dPzOVf8DUejBbbu/ahgdHB6ZtZgI7zkBarmv/JHWXZiLb7JeCe/D4oFq4iTDaDGN+ze8
         vNLjVfeFua7rsRPqhda79/c5J7uhwBN7NBHWI8b57aSKnts5Uv8FHeaesz1SeKLQ817Y
         WxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759221223; x=1759826023;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBOPU6N+QlAarzu9LlqnD6xE/6f1CWCmb96507SlQ5Q=;
        b=joKafLBMrgzx+cmfraIsuFCegbH/6jXTigqS4JUV+gahHkAWXwmzRFLTwZh4hdnrxz
         Wh3VEbGkvXBxO5CRu2/TJPGxqTOYb9Jajrt+v6VUehaPX6JdrZAAY13NO6ZbPuirx88U
         PBWCF7CdsfF3Se1HGLFrE+58uIJUbTUa289jtjhcWUQZSdsViZzSTjAHofoQT+QZK7GR
         +pECeckV9IiZMo7xr+nReBaYikPrR842Sf9WYx0Xza3L0cOzDM0H3dMK2eTIXsXW83qs
         lOgdj53wdlkrQOvfUTXvBo2R0g0TXp41kNAB6LYcy8q6IalfyEiyAO7F8kR83GcIamnh
         3Aew==
X-Forwarded-Encrypted: i=1; AJvYcCUD1a+7Oa/Ds6gc9ha2FsFrKAO8ZwU8E4Wz6PMhLBnHCjD+wz79vwuqXR0x2WJrucc3y+7PorwDTQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5yQi69qnzalHWpJC1YO712lH2qepdpuWLWDH3a6AzXps7BogH
	Jqhkt9nWAu7AGxLXA/g21MP/OfzAjnD5u0Om09d/fI2VYpj/ONM3NzMZ
X-Gm-Gg: ASbGncuVDKVURxc21juTgqCn/eveWFaT3Bbqqd1BewAbgN7eT6Knc6lPQEqIj4XOqtl
	aPsDAripWy11NG3jwvVB3lDpG4W/DsaW5KUJDPy0k7ipbU0lt0DKEiQsl+IdhAJm+JKCFwVl2LK
	V/0wtwx2nlQGl5SIJnqCHPuLfXzNhu6sTsDJls8avowkWs5fESPp+ZAxTcdz3bp5BylQ1T39bzn
	38RUYH7V076pZBlZsUomdERRUcMuCaMbMB6a38X70IwBRX+sdzf0CkkIVmyts59jOdRdgOnJF9x
	UdqrAxWDf5KKBExsvUvoKQ0aLYgzsXia3bT0ej2nxr65uaWTTK/yrn8DdwLiFCvGxJ+jpY2LSX4
	ysoTm4fAqhTibpsCRMCF8GN4MjRkjId6ufXwNNtde3Tvyq0ck7uSypavN8uw8cH1G7Kzk
X-Google-Smtp-Source: AGHT+IGdR0AHEeCd0GI8ArsMTXFyr2HmyKLRFM1XYpy12MOYMkBlzY/X5jDZtYeuuUkt/8DMB9hqmQ==
X-Received: by 2002:a53:d015:0:b0:635:4ecf:bdd1 with SMTP id 956f58d0204a3-6361a8d4824mr21581008d50.51.1759221222864;
        Tue, 30 Sep 2025 01:33:42 -0700 (PDT)
Received: from [127.0.0.1] ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-636d5b1d875sm3280311d50.10.2025.09.30.01.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 01:33:42 -0700 (PDT)
Message-ID: <7530d25c-f4ef-40bc-9ac8-40de4abe3960@gmail.com>
Date: Tue, 30 Sep 2025 16:33:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/23] tools/ksw: add test script
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Alexander Potapenko <glider@google.com>, Randy Dunlap
 <rdunlap@infradead.org>, Marco Elver <elver@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Kees Cook <kees@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Sami Tolvanen <samitolvanen@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Rong Xu <xur@google.com>,
 Naveen N Rao <naveen@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>,
 Nam Cao <namcao@linutronix.de>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 "David S. Miller" <davem@davemloft.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
 <20250930024402.1043776-22-wangjinchao600@gmail.com>
 <3ed8a6a5-9983-4b9e-bae1-4c433568de16@redhat.com>
Content-Language: en-CA
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <3ed8a6a5-9983-4b9e-bae1-4c433568de16@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 080F712000B
X-Stat-Signature: jaiwrwamq7byhqkc4n4bazwpqhbzky3b
X-Rspam-User: 
X-HE-Tag: 1759221223-949439
X-HE-Meta: U2FsdGVkX19q9uMIlVlIKlNOVFHpI+/xB+wG6ouWYdIz3MmW2WCQ6l+vfVQN6c7BVtd654Ozi9bmmiwPmdVlXhnsWFuLvuHPADT2M1ztIiWdHva5D/m+HmArvuKyiysv9aM1HuHnA0lmWNGRQw1yYFRWfcnLjI+3V+HClu2BgiT8wO4rRPts7843FZvKh7U66cR82KvS6rm1IvcLKqVY8bnbpwaIeR2BbjzVZ2dxNKookZ8ldU8WiNMoP2BSKtRUIsR9fgirhNsFa5gsOSpuZIBxa/aTGXlP7uv3PYBXdGAVXlxAzBJDVz+FrUbiBu3skE13wBZMhBe2sKaDD5fpyAhRiDWhKv413d65qrxHEjBVK1JkQAFFa7qhCYFdotGZ/LVuff5PXf0Ma7BHai7kfuxKtQgm5sxv7eRvV/CAdSgOvaf0CPvioTJSICxet+D2XCGYEEOwsSKSNuVJ0EqmgpZhUh90regLR8/hD+ceFGEnbop/FEaIJBUA9okaeh9XU3wAEfAUz9WXyP6carbgZUjy8x5GIMbQBPPeLIRz4UJba5dmRhO5dxjWuu5ai+yv/mebJ8o5ynqJIOM3rUyA5nj6MQqHhhsq6ZF9vIYB0esvqsAeIbdl4Zle1e/an3qunPwG4oDhDnebPbT2PIwWsF4qCUq7H/8nxyAso9q7jjehDB3pGR6IWTkshMnKvgFBsIXdYnriYTbtv3q7MslKJs99ip0jJN5rKF1UiJf5gAj0Psmxml7OdQFE40QMUAXheoQkrei9t1aEqPcIP83GGbzp0s+t/fEGRebSbAyB1jmztG1/HeX8BXCji5azQJWLKMPOATIMRh9iliql0cg1xpGVZwpF6YiIbs3LsnA1MdU4HvqNwc2Dy+40PWTKPe3Y0heXdEOfdzbSZbJuBwce1MslKf1R6HOVr/OEFIZqvq5NjKLVi4e7FxlMFdQcCmRHnuSyWVsoq9qVQZjEzKg
 CaCSG6CW
 wWsMPpF8WD1dRLrc80F2C+A/qVLUeP+tAZihTnlcW7yYfBvhIVQqZSyKas4/8j0zdgdCn/OhywFjKKNLg/igV+O6URAPn1E6CQfbJFm3XMxju+vRugKO0W29y/H8QOKUbNjdEdPT0xwB8OZeGf3neTkjdU7HDpLxnxtBDiBf59X7Ty1UXr8EEvTpzSWI3iv5ZNBZbeSfSIF0SGpIepaIKpvRo5yVMnl+a3aYeZFKln1esJtkErhYcs7iuJULpMajBSzv8RqxTWeWPDA4SeZ/PI48gWmrRIWPdo98dM83yzTsEd+rTwFlHAPCXfbyE5lww/NzWuIXFBXYkkLcUEvSd1tpSFh0zQhRKvj/rXMVOsaes8V+N+MCJ+V9jZ7RY39vhAQ4NmheXZx34yfDoGkq0cXAjiSVCpumVx6zetp9cvov34edkEum/2Sxo3Xm4L7SxERDzKC9Yfj/PlHR7HDcl/QrvnbM77a4ecEFAo4le0BkibCAaSN7nYa6D+f4rxMJL6q87rs+vZSkBZPf3fAg16WNsXETfjwgcDRU8cqj4SOTK2rgMrqpLwy6NsvAFasHaRqU027vPv4uv0JI372e8WFA2Ta9Z84VGL0uV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 14:49, David Hildenbrand wrote:
> On 30.09.25 04:43, Jinchao Wang wrote:
>> Provide a shell script to trigger test cases.
>>
>> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
>> ---
> 
> Do you think there could be a way to convert this into an automated 
> selftests, living in tool/testing/selftests/TBD ?
> 
kstackwatch_test includes 6 cases. Because KStackWatch is aimed at
debugging stack corruption, several of the cases intentionally trigger
kernel panic. kselftest is designed for tests that exit cleanly with a
status code, so these panic cases do not map well to it.

-- 
Jinchao

