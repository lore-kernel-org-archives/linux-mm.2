Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BADCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856DC8E000A; Fri,  3 Oct 2025 16:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E608E0008; Fri,  3 Oct 2025 16:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B458E000A; Fri,  3 Oct 2025 16:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6588A8E0008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:51:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC81116093D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:51:06 +0000 (UTC)
X-FDA: 83957997732.23.DED533E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99560100002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:51:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lrx+Opa8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759524665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIs3ppVLk6gw/qZXypZLZcOfa+yCn//X21VZFkDaLYU=;
	b=ZljmgFAU0pGctdmu9uosqfak8SEl/ckhplRbtkk3Kh4A5STGAPNHhInMaNaURZWR9WRcvA
	4a+2rATu/XyoELzZIfmDxSVHe/R2Nk5UcX3gFEZ0p4vGy9/X6/JK5E5i8DfnTpqNfX8jRm
	5KkjA50EXpK14C2p9VkFmGroHDOjcz0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lrx+Opa8;
	spf=none (imf14.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759524665; a=rsa-sha256;
	cv=none;
	b=O0D7kD9VKTfDdgCQCUrUM63j7phx3R/dj1yKdSgh0+BwN4AVEzuLdC0EGNGoe+ZiHTsYZx
	ZOx2QyF12z5s4YzXFnOrqWvDEOOHPYR9gcjzBc5cPMO4GZV8CXl5PtGM2hjVROY1D3haio
	z8JzwISEmMvPG4Ote3PS84smf3InCyk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=oIs3ppVLk6gw/qZXypZLZcOfa+yCn//X21VZFkDaLYU=; b=Lrx+Opa8kAlfEXuyu8nZrskDYS
	RMEVW1K3EtHWtp/TNPMDl4+TZidS8rII6LOpnPv0qEvXnZn1PtaWNoVRLLHkzUnhbCR3Tfh1MpEHf
	ZkZd/NEu3t0eSIf0IaCZTwNSp4G961ZaVD/mJjLljb3ViiQ31g8H8jJABJOEx687ZtuOQgxZ+AsqI
	LmC9fUttLZOzjyJF2FAdnCTKBCeWjOa6Rmq3x9FU9+hZojGWXCUyKadvy1un7W8qu/DrpcU76pUyT
	OX6o9m0+7SucZJP87UviQ0UOsMWHeilEIIYasmiArPjulk9Jci/3QFC7WnJj9QL3uPYwy+SzCuC2Q
	D0kAwH9A==;
Received: from [50.53.25.54] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4mjl-0000000D7bQ-0Z25;
	Fri, 03 Oct 2025 20:50:45 +0000
Message-ID: <3913273d-12e2-426f-aec7-263b7f49008a@infradead.org>
Date: Fri, 3 Oct 2025 13:50:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/23] MAINTAINERS: add entry for KStackWatch
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
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
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
 <20250930024402.1043776-24-wangjinchao600@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250930024402.1043776-24-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99560100002
X-Stat-Signature: 315rco9pqrb6n9zaqhmckpkfkmtzqg68
X-HE-Tag: 1759524664-492940
X-HE-Meta: U2FsdGVkX1+xGczuObbLqBf/8vXrke4TJrXS4DmY0YklhdgcqwwVUgs7m/X99kMxLVEJWATp7Jf2FekMQ1wtH4OLcUoMLYOjpLFa5anR9yd+1i2N4D5Pk/RMfXkseyTEAOjbnKwCCqupMBywyqzy4Ninsyt0T4/y/6MglfJPUhRfL+EGYTaF+UJKiQ3slHLv0kvjyIzYDAN+MJgONkCh/E6EZ1MYGanMRaqeasJ1BpCRG/Hus4fxZGnxfn+/eIElqTdaq5SXJ4kdzVp339euTwizOEnNKj9LJBHUfuiAHNLJGuRqq5HDzqslDKKp1zsYMMh5fZIktxHcnezVnG7GlDijm6FJ2tugRfaCS6WoOfam42rZqbGlWt/MlVfau+LW2lSOGWcgoBH7JlJfZFMTci5tdXivFQYxf5NcENJw5cZXGOOAnL/TE8MI1CLJgF7wLJFFZDur4aihgu4tZPbUaRonh8YkA0LfL6Bgpzw55uGqav2BuG69UVeZUAUQnpTAS0iBKkESH2EB+JhKqAPgyBsEedAiFpsHPdt3z/GQQC1td8N4Po3i80UKdI5xuv0GZxy2fJKvl0quA5MgLRdkc+Hb90FmFXOkpTCO+DMbwZzZFxNUpNc5ez7DWGtlyuk/dn2L2EAbdlnIMIVuMKYHqGlQSenckpTxnzlw1cS9x4SD/7CxuK6MnHSxcbG1uON58dIL1d95z2XMTi29Px1zlc2hoO9obYqHIEWUi+AEQAcd1R/hrKnZ99AT6OSRQA3VZaCEoS7H7IXzp2b5+Fyo/Z1bfex3BDDDPlVFC4Qncu1IWvd1eHw64QOfM0RRjwWNJCPXfBYzlv0+ZlDKoD8AS3Q+JmYhVVfmKZ9GYAWRJb+yIRYQYsifwiSOfu6NRbANNNT/euh7XLkBI9ltdLWGf9KJvyeSi8cJhqVj/JTJBmA77EQgxucFx1lQZ3SKwGl73FL2mYsEVmap2zaB05U
 +O3+5z9K
 1/mihQYyz1fl62H0e/HGx97fV4gJdjVk6uw4wJlDwmt6WvHhzn0rk5IRGdkKTtZVfg13YVRdqggqhXVm/tYY24i0iwyvM2f0QalHgsjzbwyGNixHPcJDj4Fpf8/fsKysrzUQBljXomquFlWpV86aacouFyNLS/vnyM93Mey2N57kDLs7bbERRNT134zaCrizJ1Et+4o4e+44StXhE76652SYt+25SkT2Dg+ALVSFJKX7IPMsRrhnrZboCYL4/8DZmM9pZy387/BoYznMY7LffsGlVo9CN740rVW5aB0GaZYDuYWFWQvZIBOdNiCfQ70v0fsQtoc3goG5zlT6Tqgt3o/9sa5fNVAR9a/fwlU728yUXmr+RKDnoMdtnIFXNx+PkdA0Es+rmO+47lmO0dKWK+O5/JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/29/25 7:43 PM, Jinchao Wang wrote:
> Add a maintainer entry for Kernel Stack Watch.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..3d4811ff3631 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13362,6 +13362,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
>  F:	Documentation/dev-tools/kselftest*
>  F:	tools/testing/selftests/
>  
> +KERNEL STACK WATCH
> +M:	Jinchao Wang <wangjinchao600@gmail.com>
> +S:	Maintained
> +F:	Documentation/dev-tools/kstackwatch.rst
> +F:	include/linux/kstackwatch_types.h
> +F:	mm/kstackwatch/
> +F:	tools/kstackwatch/
> +

Add entries in alphabetical order, please.

>  KERNEL SMB3 SERVER (KSMBD)
>  M:	Namjae Jeon <linkinjeon@kernel.org>
>  M:	Namjae Jeon <linkinjeon@samba.org>

-- 
~Randy


