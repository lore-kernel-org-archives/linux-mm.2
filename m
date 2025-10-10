Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD29CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 20:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0B38E003C; Fri, 10 Oct 2025 16:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C983D8E000A; Fri, 10 Oct 2025 16:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADF68E003C; Fri, 10 Oct 2025 16:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB5BA8E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:02:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4901316044A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:02:34 +0000 (UTC)
X-FDA: 83983277028.09.36B5CBB
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2AA0140017
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:02:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760126552; a=rsa-sha256;
	cv=pass;
	b=nzBMWSoINleIsPgVP+Wa63jkeCaBTDKZyiNTBWwo89Gwm+/rJyNavKtJdOE65hmFpHtIfM
	uXo6uvxt0zIIPvsiysfE8vowDSjBpTZ72dlvL+wQ72fZL4oA2RZs9NLK8QPJPYIFsbnEnR
	bLI+WB4YbxQxYer8r9gJQg0lk0ozx7o=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760126552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uOItTL0KBTFqu9SxT/ohOMw6976arZ30lgBj7Y1/To=;
	b=fFLVGkEkREXKXw2jC4BYQQPtrIqMu2BCU/8rt2DD2aHgmkbTzza+veKFGJDi4Ps+YkbJZb
	ARHVh2CDlOdeoEgDSqv2CeVDnw2kIBKz/Uy4dTn4HjqZtPDsbDQDnChm94W4ff2DSZkzBE
	rA52nlvcOT2FaS/Qazwxza6mAXgbwLk=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 769BE1DFED0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:02:31 +0000 (UTC)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44A7D58E6D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:02:31 +0000 (UTC)
X-FDA: 83983276902.17.EB87179
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDE60140009
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:02:28 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760126549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uOItTL0KBTFqu9SxT/ohOMw6976arZ30lgBj7Y1/To=;
	b=25qrFTvFa3IyHSDdEXHnPK2L5PQOkWYYW8WRZN6gtPF4/3X31fvM5c3i9el6rkR8gklkCk
	4yVenSMjlEYi/AeE6T8k8O/bfEiSH3epMDYvO9ZzSFkgnbvgQ20KNnc8kgKbcJ3eJO9ALj
	/Ir6LgGGjT8tbu62IB//oFPLOwyQaQ4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Avo+7IaE;
	spf=none (imf23.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760126549; a=rsa-sha256;
	cv=none;
	b=FOnZuSMxlEm9LLPJlPZwsXGM2oHGUcNtTFSGVQ0hgJvtYgJHzsLit2iYFxppM8SKHzzh0l
	yzSHVj0cnPsbRygrjaSocTfVwsRhEgWq/OUHagi0arx4zxqcOtKNWXqqwUxqetHhgdZPM3
	kp5JX2oMYc4Uk/Ye5XtMte9LmaEe+3s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=1uOItTL0KBTFqu9SxT/ohOMw6976arZ30lgBj7Y1/To=; b=Avo+7IaE91NLFjM4HOJOUnOGLL
	579y9RDwAw7L205S678TugPGGJueV/XNuSmkwxei4bF6/2W5x2VWUnbbqFLsBbXbeTAzX9Oa1uZld
	YjIbaZKfyuJOSs6+hja6mjaZfDPm2qk03Q/mtIgTM5vmnNklwo2byLo4ZYWpP4RF/H3JN7TSM/ka6
	2/InTtiMWRIs2bw+SE9iTahmLMs0c3T5iEQBBcJb9OjV5XJ4kyNWfuOf5SvoqqoBlyD4unvQNTRFh
	JFzLZKTphPb+Fw+WCUpW9lU986SZmFhw0U+sXf8mBU7+ecoo6KsCLQLI679yMaPn254rqJRJz6AZc
	y7T7E4/A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v7JJb-00000009HMt-11L2;
	Fri, 10 Oct 2025 20:02:11 +0000
Message-ID: <c1b2ec8c-0c09-4356-819c-7d2ee28b47f2@infradead.org>
Date: Fri, 10 Oct 2025 13:02:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/23] docs: add KStackWatch document
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
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
 <20251009105650.168917-23-wangjinchao600@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251009105650.168917-23-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX18xPnMewkE6hPLne1y/peS9e4vZndfsmRB5BBFsW4Vki31WC4jlJ61PwslMfdVsfNTvDdDKPaFpIOQwkBF8eXoXsCYia8/iT8iTvB4HUzt5WidVpVMA6qiYWjooPrA4tXZUG+bG8wcWEuy7nlj4LNjC/1Oe/Caqj3ywp9MxesPDN3oS4ZAApebXeQcN3eryEN02Y5YlknAezVEsY4vcgkJrKOuA+pUGO+m4S0xMP0qBRA8od1KwkymvTN74Pe3emUhgqeQXnpYEtk/d3aSgUMOlwW3Td7nRya18mf33uhrxwTZLH70HsOaTRZppHz7YY4uGorKreIjKlnyGrOmZsEFOF+7ntaPJip1k4B79N8uxTfF5N2qsgtyFUmf06rg/dxITMDxAe8eif3c9IU9OjSVZCl+uBVMwEyn3xt3yUYrDU2ArZ7TNT5bCBSP4JUchoUa5by01555jt2QJ4Qi+594bCX5DSNCsunu/KRIV3j5/d0viw6w2XCD16Outb2ifUgm++/mq0f8kVSTcnHY8e9eHSKIfQP5B/Ic2aCnBWeNtNVtLBMLSpSbGQqAoayvwm16SQJ5X1+ueZtWE31yVVxkn2hpZPNUmdzUeo+zEQWY7pW9cQLqlG5QOBLkySbu5EGpnZkAaN0B2EZdJES0xV322P+r3Py5phVk/DwidfnNJ3oT6/m1ApUb/PYNrDppTuqYvUZv8TZ06fokqYZsshBx1Mto9E+21NZeHjl9QHNcIDDpXSWhv5QI7WO5W34hA0za3bw+gTYmI/4hMG23WLgyDx8FQz1jM2HH5T+d6UH2b3z75LvjZ/LJUt4mAjF5fxiGmOLEYPtnHUYoE+HXWzl+tjvYza9Igxdy9nQ6mlwQUx38y/iBk0G/rB8Q9I24l2iSvkZRQGYCC90CapBko2yq8drhlzoAUWVhi2N5EsDcEpA5XbNoas+hvW7SJel5rQvpXH53BAkR
 74DzBiso
 PEMqasVXdIU1Pt58phy796RIDyQ3F8MhoAS2axFL6eVB2ivIfTrUnD+x1TplgL5r4PQLdqEJcEknZBOAg3BR0w2I0vL2bL/Scs8aBMGTM2NeHJaEtwKipTX1R5VFZQXJP+UYpk2gi1BEpQN6B8L/GzKayMmveBiihpVqkb/BOdvI1LghLbxjBfgHHYwAQrtB5I9jwQrgn4l5wVUCqjfH8K2jQDkZPA/qaGpJrFUmKsR8VlL1BTI+gcA20RfvutxLoUVNJ/MJy3zEo1lHvP8IfjeQ4vyzIRmvibXJBoAP77jlpMWu1aTb5HpP9i+mWTAk0nakDCl6Y/p6ZhMH35yRKETsfqyC7YC2ev2ETs2PLjaDdnMn3j8yyML3YoxRAAbomTGpA
X-HE-Tag-Orig: 1760126548-164543
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2AA0140017
X-Stat-Signature: whpfbjb8zuso7oeiya4pdaahj7dt88ig
X-HE-Tag: 1760126551-168740
X-HE-Meta: U2FsdGVkX1/yQDU5vbmSnT7LFZ99/hfUUjb6O2Mko9aOpCvf5uhvQSK7p+vVhWBA1/2WdbTczM+G1CK97Of+BV+Fe19Ir1VhmJKBB5x1D+rvkIaWeFmwlTVNe1omjBttIJwVIa5jF0TkH83UsS3Nhd3ylw0LeNhFTV4G4tTjbSwzk1zwItbfMKcHUZ5HfWAuYl3A0Jipo4h9JKFUDC9u6iBs0KfPKUOXVwGp9Jo5D3NX9XpTgDQDSwv/jXTsvdImkou0yp+Xo0+CisZ8wBczW8ClTPvG85jWXOhLVd9B1RroLLMmlX3JaNy84NijCrZf7otsBsZyFvNb71m2AYOGhE5w4KynnzFqhqwk0ySKgGXydAp5fKTsHumQc5PZugzHlr44+TJFzT0Jo/PBb6qidWIMUsPU7zhV+yCeg9GPaJrLAan9nEiAUlQyJcWkWW+MX38MuO74Nmnp6+yNQBN/sIcRWZWqdEeNBeMNSAb3liU5vZsC2muBtPK2Yv63fwDxSoTNWumT7pQAoDTCfVnxN1SLnQBPnSmVvM/vsWbzfd5sPBSnqBL+P4k7F2uu/qlHF216Xk5sScqSmS73mBR0HoxGGZ2vwv7XfRTP19ScrTbm4KuOfXvSeFIEYZxJibMr8JJ0rfR9k9RkCBYWmtKT97Igsqg4P/EKOxZjLEsN3wkM/O8O1PTjgPEhzGYbPjsaNx1xq8iY5yUQ9qxbhYJVmkkjhuSGkMK0M7rWsOckyOICXyyx354pSF8zWL3WBxRJ9yTQr9dgFblxyke3OVIIWf9Utf24N9DrOsAcbcE24qrz3yhN3zVahPhs6mTJFkg4UcQHQFQ8Q+OSAuu0SsOKSqKCVC05Hk4V8rCJUWB21yKGqSq2IFg8U/9duSyz7ynwvWQy1bsny0vUFjcvW+pAEotZtmIGYY8/MwMupbIb9jrb2XIdRnON5aVYz1BSmAZFCh3tCaMN0y6IPCOQCCU
 0AkKn1Th
 OeqxfFuowqbewsghjsxko3PPWK/CmlhmNKTPopgPH64w1LUjau5NiF6WMZYZ8U3r3B49XSDeCnXzExoNjsH67BPBpCyO6ECKsFKWGgc2Zd8bu96Ami6IIuW8CRjfvrTgYefUSBUSHomn7K1nxNVLvNRHFot9H/lGRd7iDESNDwGuCRNbjcQMit5Czhu5WSJPOUcjKZxnl+DekdKnA/XnCRs4FoV3ASiqKL7RohGHMBt28mFBxvxjlQ7hF0trgUCd9/HSMyHnkPhqUfqzk7/KHwMhcQes5qMbi8ZrB++3KipEilOAz6ByezpMh8PzpUCFgbWbLmkRqfi5vENHKW602cOCxxbpty5nOrH+eC0roeEefDAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/25 3:55 AM, Jinchao Wang wrote:
> Add documentation for KStackWatch under Documentation/.
> 
> It provides an overview, main features, usage details, configuration
> parameters, and example scenarios with test cases. The document also
> explains how to locate function offsets and interpret logs.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  Documentation/dev-tools/index.rst       |   1 +
>  Documentation/dev-tools/kstackwatch.rst | 314 ++++++++++++++++++++++++
>  2 files changed, 315 insertions(+)
>  create mode 100644 Documentation/dev-tools/kstackwatch.rst
> 

Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy


