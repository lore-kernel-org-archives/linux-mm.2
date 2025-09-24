Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF8CCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95238E000E; Wed, 24 Sep 2025 13:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CE68E0001; Wed, 24 Sep 2025 13:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82C68E000E; Wed, 24 Sep 2025 13:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 977818E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:06:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DB6A87993
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:06:38 +0000 (UTC)
X-FDA: 83924772876.10.A665EAF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 35AD11C0006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:06:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yMVBBGhb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758733596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYQIoIaOKCIxSPFzuBjsQ4uTXQsp3WYZ5kAt8a5vPEc=;
	b=Sx8vfOwzorxrN7Ly/4YUbdcfSarWi+zMvJvARFUevupdiih+iGPp8p4Unahg4KtCS9LgLD
	W/Ued1FMAwaZSjDgXGIKqj9XPPy8YJ2xWp2VrVIzO7Wzh1PjyzpzfQapCt1NqcXpNqEVcj
	vzVGKwgczWJdUd1w2598LHjXvcbeJiI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yMVBBGhb;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758733596; a=rsa-sha256;
	cv=none;
	b=e/iQge0R4H9sOWO2XTLgfsplTXXOPPEQv3VcJuLoSTEo/JkuMjjRDHcEbbr+P+WdrRyOQg
	wOFy1HuAOz7gIL2SOgT+VLh+Xylq3r3yqPNe84QmYam+zyQcJNAlq4XzoIVVFpakyCnqF8
	aUeR9bLjKMsoVtJ4M3WzQRdaCW5IZXM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=IYQIoIaOKCIxSPFzuBjsQ4uTXQsp3WYZ5kAt8a5vPEc=; b=yMVBBGhbm0CLYR9iFKaFxB3NzJ
	FXsEMYpXS5BwrQo17beyxJiRF2eVpGI37E9rSScck4hHw7aBHt5YlROsnbqzqNynVBbOpBK+bH4xA
	d4oSxLXDN+d1N4dURwP2zisz/dR1m1MfYNw52WiMxW4vz4mLOMWOKB0Wa7U7jG3vPDZ/fDAtkynDe
	/yChEJFGyaVg0aegV7Xclx32TR9w6OXlJSugh0eeEuBAmJUWTbXUouRNbYmBC26Ch6S9bG4KkD/JN
	0sJx+0tCnHqSZtp844pJs4qAs3W/+Y2If0aodsX3aSvG4UBodN3W37nDPJ172u5zEg0HNdRMsOaW/
	z06hMXNQ==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1SwW-00000001yYJ-3ITs;
	Wed, 24 Sep 2025 17:06:12 +0000
Message-ID: <3504b378-4360-4e55-b28d-74aabd4308d7@infradead.org>
Date: Wed, 24 Sep 2025 10:06:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/23] mm/ksw: add build system support
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Alexander Potapenko <glider@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Juri Lelli <juri.lelli@redhat.com>,
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
 David Hildenbrand <david@redhat.com>,
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
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115124.194940-5-wangjinchao600@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250924115124.194940-5-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35AD11C0006
X-Stat-Signature: zr3uq6piu7ucbqczk8bmdawzka41za38
X-HE-Tag: 1758733594-595391
X-HE-Meta: U2FsdGVkX1/WKaIleksWd8V04dPlMAxLmFfg0qgLFKBpkKX0gugsDOGMHHqDX9V+GxI/C1D9vc6sWnDjwwmGU2hfl6FnC2JwwIcKTuI2pKk6fv2pFRyjou8rSNnfPykMKgWWnTwh8EnRx7d2iT8lo8ckYOgtvaJwFThJMCJIDHyrzG8DlhLmXHlRcEl0BAwEcTPsKlm8jnTtezu7hspFDroFONtQXZykwEgJDL5e33TNR8k1nKJKYN4CRufxiFvWoVxj9hhvGOV8UJtU/XhUU0JX7npHPX+AwKJkQXs0PbC1HVPqmBoIcquc6bxhieEOLD8g0BSlHyOnu5M7Fn03DZhXJfYgqrKruntAQMC2m81Nr8B+o5i7+vNBmgFHGO3d6Sw09qcFSsJFMLEzl42hF5Y1jk+H3FTuooxr6H1C2jSrtFXnWjpIHYBaLvTaITFJ/V4YA6Arj03bp0tRfGauvxmlUVJ7mToM1rmLF/6CH8AA8bLMzIz+8JxldB7yz5z7dD+WQyulq2+HIEOcVnYie+WzVmBHItH3qM4wya3JGX7Vg+vuOfiWalAMFHDO91n9oEj3yFGinmMKxG87sMfhWpAq9/o9Ae5m3+bRnRKvRwo9EgN4uYBxt+heJGjO274MmBduIJyUJD/nlvbHdk4P+MmHwEBoygJ//24OR22uFY1SVTtaBFXBq6odMmmzRNn6M30HKGTPEzq18aBssznek9nwIDoUhV1NR6zcFdY97y9mCW3vTxqWZdiM9stVOpfA+rtl6tXMiIIyHtoiQk3EBsyXiQiY7i149Kim0rY2cwMWkvd7fX5pLEemfKbqMlnj/Yu1MnuuOqVSv/EdAJSqYBppGvZgwcpGiI/1NqceTAdY0xtZGstSYE84/i1Ie7nyVuZN+v/ulnyJf/I5hsESZIXnqmDrK08LRVJsfk7g33qzsHrmXp/KZIlQlAz3yuYpvgJi9SmMQuN8XFyln5k
 iIspgatd
 Wboq9xs2NTiRFbz/a1bt3qy7ktEJ4OAomHvdiZ13rx9YuDxm3tJdOWEm1SHY6c87jm+ufruh4lr4Tsej7rj5L3tDU8wFRN7O1ndTATIImxslk13pCcRPJr1luOXaw7FCEH0gLgK2C7Nkn3TjoZGzd0BUzCNKWCK5yRYsKP6RFjdNtF7vkIAw2nYJUkPIXZa8cQVxOgbbfSGLVtsdcox5wiwmXYhv0K3/SWmQJo8ED3O3ZoLNeJFGGUsPAIiGNHoIEBGwIUiK3w446hlip+74axeEEcJJ15ZQHSWfpAu+SVEYNLyXvlCPJ/V6uQZEMXqSAaGm3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/25 4:50 AM, Jinchao Wang wrote:
> Add Kconfig and Makefile infrastructure.
> 
> The implementation is located under `mm/kstackwatch/`.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/Kconfig.debug             |  8 ++++++++
>  mm/Makefile                  |  1 +
>  mm/kstackwatch/Makefile      |  2 ++
>  mm/kstackwatch/kernel.c      | 23 +++++++++++++++++++++++
>  mm/kstackwatch/kstackwatch.h |  5 +++++
>  mm/kstackwatch/stack.c       |  1 +
>  mm/kstackwatch/watch.c       |  1 +
>  7 files changed, 41 insertions(+)
>  create mode 100644 mm/kstackwatch/Makefile
>  create mode 100644 mm/kstackwatch/kernel.c
>  create mode 100644 mm/kstackwatch/kstackwatch.h
>  create mode 100644 mm/kstackwatch/stack.c
>  create mode 100644 mm/kstackwatch/watch.c
> 
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 32b65073d0cc..89be351c0be5 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -309,3 +309,11 @@ config PER_VMA_LOCK_STATS
>  	  overhead in the page fault path.
>  
>  	  If in doubt, say N.
> +
> +config KSTACK_WATCH
> +	bool "Kernel Stack Watch"
> +	depends on HAVE_HW_BREAKPOINT && KPROBES && FPROBE && STACKTRACE
> +	help
> +	  A lightweight real-time debugging tool to detect stack corrupting.

	                                                         corruption.

> +
> +	  If unsure, say N.


-- 
~Randy


