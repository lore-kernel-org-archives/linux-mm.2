Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2ECCAC58E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 04:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED248E0002; Sat, 13 Sep 2025 00:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C52E8E0001; Sat, 13 Sep 2025 00:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D058E0002; Sat, 13 Sep 2025 00:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFA338E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:13:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D6D61608D9
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:13:22 +0000 (UTC)
X-FDA: 83882907444.03.4B0B7D3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 18BC71C0004
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:13:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xPzy07H5
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757736801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7ndZnQxyXKvcCzhFli8oZf0PjWLBirdplU5n0FJmLw=;
	b=Aaek3iZBNKJ4sEfvJAC1N1Ha4xao0i7SzkASSZ2Q0X7rvIZTTjbbkIeDLjsNC2tPKJH7Zx
	/+EOmqDGkLLDEUISEcjmTj5+iRpsJuA14LRVX/dqygk/YfIxrWz0igBUQoUD8uLyKBQ25z
	TqTYaq0TMQgSLHgcF0hW9NzGovLxexc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xPzy07H5;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757736801; a=rsa-sha256;
	cv=none;
	b=XjezKsQUmpLdrbdeQzgkCYKXGs/Yre084TO3jr1xdwRrQ2rKw63/WTQaK+EJTB4HVmes1S
	Aj6/B4rhKbRljcgOxZyZnKem/CunNEY2L4pXx5Z2tU/Db2NF/LqSJh2vrMp4g7yJ8HYbPO
	PKspH3Q3p1Rnj8dHtx5c5dRjQErCj1s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=u7ndZnQxyXKvcCzhFli8oZf0PjWLBirdplU5n0FJmLw=; b=xPzy07H5oLyRzMkKUDnRYxRbA8
	FB9s/mgtYrIEncNja4JJjGye+zGOM5arCPaXRnqY0vBLCsFj8oDAeoSE0UqBh4+bDiLKE1WlvVIGg
	KVrxlIQZrGV8DB3SCKRdz/WridjNvy5CXv+SD1Va6LVYxjNBA+mGHiEbQRiwSEI+cHvjloDDoXglj
	0dK5WfUej0zVDXKQOXKsr5DuKq3kr+d9vFJrusNVKTTSLwcsCky4pU6kPywtug6qim/3Nk3gXwtyf
	vbw1VCU9MqDSbqZvzBQzA1VgqzMvxCdl5wn99ll+PJEWgdoqb2XafQieoBP+l+brAtdIBvxrTKifR
	pUY01Pvg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uxHdN-0000000D6om-3RkA;
	Sat, 13 Sep 2025 04:13:09 +0000
Message-ID: <6b5e5d3e-5db8-44f2-8dca-42f317be8e0d@infradead.org>
Date: Fri, 12 Sep 2025 21:13:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/21] HWBP: Add modify_wide_hw_breakpoint_local() API
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
 <20250912101145.465708-4-wangjinchao600@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250912101145.465708-4-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18BC71C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qaq453x9srp7gearj8dywucu3w8985e6
X-HE-Tag: 1757736800-135805
X-HE-Meta: U2FsdGVkX1+JD+5Q9z7dCTvmY3oCJRc4hzM7GEkKXB6Vjkc+T7B8pw0CpQOGY64Bg5vRj93llNHEJqBcoGRwItyUeOzJVENCio3/NDTbxJZu1/lH/U1FcPW1LGPjusn6sG5PCE50/5umPhgaGZmmqZ902JD1H7p27dF5t2J6ydV1JQmpKHXsWr0U2vPS2T4uZyv+PHAXUBd9r0JB+EuIjKSE+6OdyZZMe3gEHUlv9563behmepVFkwBkXCxY4HhD/jL6NWdlRjaNGAcfxFDcJnvOlsbzCu9Vpj366n4FBrkScp9u/kA8bUazzhxvfS6qNzW5bcPW64FMujOJK1T4SnagLqhzGyEkPY99BTqyI19mRZeFvsIra/9dI1NoaA4Mp8mw6jsB69MLFDdvEYnQpZYJgZ6ikCqRwTvq+onG3S2LyfJ80flYFPJ/PTiJ0U3CMGg7tjPxGCLSaZd+teV+NWJ7+7Bs5+zjTNfnXZk7sLIgNyAn0HE7G/WuwUyP31EYQTKKycDgKFa8xZ55S4oCXYdX73pXVCywCOMdL+8j7hHKUnxqJrhx3UXHEdqS2nnsRQcC6zAdgbI2Ga22JotO5dAUiltutgvKQNLs+SuEnDj350t1V8BRmdbPNWbWMbOMOlxvG+2iflGZvLEdPymzMpMx2uWigKQn/kTBnpKRCSH7Aor+xWGzc0pk5RnTuy9gfcqtGNIBQVCgdkrn3RH9CZEuuuOfLYWwOOwyapB5a1RB3d/RfhElp9AtxRPf1/p66YWtap/SnX+618vVSNtFN3Br6KaBdFC5AG30ZBUTf3hvImYm2TISCrL1rHXZpQRb1ehWDQ+zPgRHbKFqKEO5r/suL7I1Ywu4YiJwqrBm37aAJR/EFjEBipp8gRWYN8wDF/wk+IOIh8GWoL91vb9UntbhrVwMDPBTaINGZ7OLyQTxNsfDWvGydymLxhfBohkXGHpwGDnybvr4LAfQnlg
 L4I1ZP39
 vbf0fCDb+5k8CCtTwiiW9Oq8IskHtI+lcTAYlq8VayRG/LYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/25 3:11 AM, Jinchao Wang wrote:
> +/**
> + * modify_wide_hw_breakpoint_local - update breakpoint config for local cpu
> + * @bp: the hwbp perf event for this cpu
> + * @attr: the new attribute for @bp
> + *
> + * This does not release and reserve the slot of HWBP, just reuse the current

                                                 of a HWBP; it just reuses

and preferable s/cpu/CPU/ in comments.

> + * slot on local CPU. So the users must update the other CPUs by themselves.
> + * Also, since this does not release/reserve the slot, this can not change the
> + * type to incompatible type of the HWBP.
> + * Return err if attr is invalid or the cpu fails to update debug register
> + * for new @attr.
> + */
> +#ifdef CONFIG_HAVE_REINSTALL_HW_BREAKPOINT
> +int modify_wide_hw_breakpoint_local(struct perf_event *bp,
> +				    struct perf_event_attr *attr)
> +{

-- 
~Randy


