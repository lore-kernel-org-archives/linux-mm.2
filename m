Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDECCAC58E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 04:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303B36B0010; Sat, 13 Sep 2025 00:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4066B0011; Sat, 13 Sep 2025 00:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2D26B0012; Sat, 13 Sep 2025 00:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0706A6B0010
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:07:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BEBD11B144
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:07:53 +0000 (UTC)
X-FDA: 83882893626.14.8E28011
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6816180007
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:07:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Zvj7+2VJ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757736471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkZpc5dBMnXI4POCZ2TCFFqEd7xijX/+QZHk6h+vWnA=;
	b=hFDh5KvEnx2i8h7+R2y393S+733XOyNPtOwrQc5imULk1l9gBUDVkyjxbuhB7PC+DIqWeh
	RYgqJPovGQw7f55SZlUr+GSH2yuQXZvF/5BnrMtonwnmQAU9hnYzbFEpEQ8fkqWsvtdNUZ
	S9i5nW3URYtYy1U2rj1GZT1wh4ZM6Ps=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Zvj7+2VJ;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757736471; a=rsa-sha256;
	cv=none;
	b=k8PP7ZZAvXgo30T/XyJi3/cjaUZpG7D3CzxHku4roBsv7rtQ95r+MGOG2YVcvXVF/s+PaM
	ORC63yXFwDTeAcXs9dtAgHKzfpQ6B77SrPiHu4GxFRmY30eXf7Z6W++E3vOMERrODyCFrz
	e6JCF/mnLnWdsZ9BWgqFrHo1TgWVyvo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=ZkZpc5dBMnXI4POCZ2TCFFqEd7xijX/+QZHk6h+vWnA=; b=Zvj7+2VJQP1AUrM1oc0jI4D0df
	kZLbrgoF6tWC1TSXrQCzaRwf64BcIFqWM9jqgctShxRWwA64Z3cH3ZJp9xtz/vExBAcClQcmfIZn7
	yCcLB+AesJzDmEPSjA8I8PqMwPg+QtoHLtCCGQwR4t8mmkzazK/OjVldlPQMX7eK39OikaYuiFAkS
	f3j34JKAUXKzXllob2T5kCBHPFSR85WlWQfJBGW6vvdYMXS8Z3QXIbkl5YsAeQ69QGvyvU6VGYXVL
	zapYbucIouJWo+hLXEvQIBUIuwgelZEWHzU6JUYSd+NcP/fFDMoT6FMSctoEiTHXQLnPtkJJ7TQUx
	RnGJ92cg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uxHXd-0000000D5gz-1paw;
	Sat, 13 Sep 2025 04:07:13 +0000
Message-ID: <69198449-411b-4374-900a-16dc6cb91178@infradead.org>
Date: Fri, 12 Sep 2025 21:07:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/21] mm/ksw: add test module
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
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
 <20250912101145.465708-16-wangjinchao600@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250912101145.465708-16-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D6816180007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: igao4bu5zaxumyyprh84ypzy5rkt54bu
X-HE-Tag: 1757736470-213023
X-HE-Meta: U2FsdGVkX1+YwiA16BihnkTA8+W72XCFRa7vfx7CMmyNft913iY3W9VoYFoVRy0WYwOlU7r9blN1PAD15gu3GELVAYZ/4vxJ5QVYojlS6TUuYv+QX3ZzGOvjJ1vM2jd1np7zgnkjKpoqiBdzbneVqtn3SXRW6zm815kOCk/ACJn/YlmVo7wqAKyfi9rug+ky2EKn9u/D0W26TYRYQ10gl48DSAgJS9WHrGFZm2G9HEOwnaZ4xn4KWl/bbYka/7OMeUGgrQD4GowP1o8zSGCIXFk4fr8SIAcz7RGT4KteEomrFN/nN7TJBPp0CHGtfOS7NS0obQhcKyyxm+enNyHlbzi+JTMxLE/RNK7SRyFaHKVTZVtkxUXNOaCMKbReXEbo3biMxaad1K88gMizjgUblH+zhlizbG94wwTifYu0lyz4SwLRL/He+FM5AS4CGmk4+qqgaoP9tWSbmKiR+vyOnPjZ9q3GsJp7UjhD9golz5dOG6Nly0GnyvvcXYAKzF4CMqYmZjhy8K2nKcmTfgx4o18WeCjtwWY3XqhSnnUYE7pWu3Pom2ISbcJ4pSQeqeSZLztVoYp7hNUYCIw4YYqj1RCBKVQZWdwBZdoqsXzIKztjbG+rfrY6ETOpWWpv+RAkZySeUj7xZB18WX47HXtiNrk/1jNbH3tCruE/ofrsMpQY45eI0Nhx+DkGyLQOKW3XcfjRgL7n9RDYzVD1FoGJchVm+VWepQGWJqSAGOBuzndVxTUJ3yanZxpEKv6ADDgqebzIW05xSNmPg3opde8vGgtKTxKWhZyvXKe6puhmyFogeF2uAQ2pPnRWvVhkVT/EBaTK78bPhLeYpLskj6zM3QQdsGOmAr5R+aRBfen7FFG5QDSOv3b2zF/uLCFD/kGdr7cB6cl1OV2qHfJQuHIuy+45hyTXh3YxC83QTKbh0u0VQ2s/5hzqmLTIVsqXAtG8hmDMbM+hiXkW57xlDQs
 EiqSb56G
 VNVQ7EFzro+9Cz910Kan7bue0j+5oMM+3oI3fzQ+ClZ71y1OwjozTWkZdKzhPZQZNsIH0Bs+VcF3bCF8TFt70/y4f09yzc3SWq1McWSJ8e4DjttZz1RWATD6+Au53JL4WEGrnp+vsQeJF8Q0gGgBmL9ieI4k8G+pB/r7LUYtd/Rphe7QjIZZYfjXCPENAPkZv3I1XPWfEEZNQlzXK0Mr/IPeW6PZH15mBlfOW5qxyD4QxDh7cn2Z6C1GwYDxrebAVBqKKKAZVhtrNMD5a7cSmxHeepu9U9gDGBJGnNtubm87AzSWTQaLSJ5VKTVh+WBxVNniq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/25 3:11 AM, Jinchao Wang wrote:
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index fdfc6e6d0dec..46c280280980 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -320,3 +320,13 @@ config KSTACK_WATCH
>  	  the recursive depth of the monitored function.
>  
>  	  If unsure, say N.
> +
> +config KSTACK_WATCH_TEST
> +	tristate "KStackWatch Test Module"
> +	depends on KSTACK_WATCH
> +	help
> +	  This module provides controlled stack exhaustion and overflow scenarios
> +	  to verify the functionality of KStackWatch. It is particularly useful
> +	  for development and validation of the KStachWatch mechanism.

typo:	                                        ^^^^^^^^^^^

> +
> +	  If unsure, say N.

-- 
~Randy


