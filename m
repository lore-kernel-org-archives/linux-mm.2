Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAABC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E380A6B00BD; Sat, 27 Jun 2026 03:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9F26B00BE; Sat, 27 Jun 2026 03:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA1F6B00BF; Sat, 27 Jun 2026 03:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF9D6B00BD
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:52:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 145E4A06BD
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:52:56 +0000 (UTC)
X-FDA: 84924926352.05.F9B22EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6AD9E20007
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:52:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoVc6vc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782546774;
	b=hAdzAC/H6EK+1K2M53FAB2PHB9y08sRxJPPQ0fxezV5D+NAFcPm0O2Amum+Rz5RBSoP21U
	BWK4BetQKlL/SteYJPNENPbShbGRgnNrcXPN+Wl5lRjiFxUBID38X1+8EnL1RlVRPc5HYI
	OaNfwGP0XswrEi5wd0NZ76hursaezEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782546774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0znFcK8j0MuvFWz2pu1AoWSdjFNtXQNpSRnuMwlEzE=;
	b=uVNd7Hclb+b1O272AqZIXmXNbXrzgQshXabb9PAOLt9HkwmUWBJuPx5+1R48E++LNMlVwx
	eEA1DPWYJRijddwoWNnpcxU8IhE63x9eGTfMWSb1jHj538SyOQPVSPXF5e6+aHl98OtbGG
	bkEUaxVZ1DH0M9WlSl5oa+7Xqfp1unA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoVc6vc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F56740876;
	Sat, 27 Jun 2026 07:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460311F000E9;
	Sat, 27 Jun 2026 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782546773;
	bh=S0znFcK8j0MuvFWz2pu1AoWSdjFNtXQNpSRnuMwlEzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eoVc6vc8yM9DIkM5Wo0O2t6uxw0sx2GB1/c2P9l0zVF+KOXagAc6gIrZVyliop+Qd
	 7nfZY0dAkzYyVw8jAvnHGx5geA4y/4CXYLq06OXBuKn3reSfTXhObbuHe9gQ5ZaFuT
	 lnyo5uaI8nyu5VAEtD/9IkEBv0GcC2DfWs3wxxr/6FtTbubs4oHPPXIVELVf4K+7VY
	 WgmFy2isk/o9L4WzXu/02pEIqSp8VuH6m8O3I3FqFMTgIE1ochTNLkzHylHG1NO/Nm
	 hlANvs76XOjLm23eV7mDwVjSLPNJUEtln/VbUrO/GiOuNH50gJRqnGhSm+ufJ+CDu7
	 A0lMLVpLMK2aA==
Date: Sat, 27 Jun 2026 10:52:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <aj-BShkN6BXex_ku@kernel.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
 <20260626-ecc_panic-v10-6-6dacb8ad024d@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626-ecc_panic-v10-6-6dacb8ad024d@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AD9E20007
X-Stat-Signature: cg5ixkazqu1snhqd6ryn6npmot6qikcg
X-HE-Tag: 1782546774-408215
X-HE-Meta: U2FsdGVkX18ZnwpBCxp7RsfEEVsRyZe1lVYjd4utRkUCIKMpmLmIVyW3cvA9AZOMDuPd+0IxAsnZ0d+8p0cT2H0kh5N6k4C3wLzyLMQmtw14O72334GmloomEWVRcin/7FlSwChHm/+4hk2njqwAoOEG5HzgWiswNrnOSrMMnENSbvlIFIVlRVWkCtyp0KrWsfkHdd8NPaiWBe3HsoFMIwnyVCFPRtEdSHuoQqU/S5Up1WZzVoHuXg5svrI4xKlBBmS4HOVWkKwrgCLHp27opnmzi7UBP5540KGeO6IT57Gn9nqqb+zUh67Tr3xYoy/pHJWUcbJQM3g5kvFQVTVhurZakoYabmZYSpUv0FRBcbAehidGKezwR32ukXlnsGaMhdl2mW5gSFsWZFMspwUY0z2gcT2WpABcE6c//qzb9+Fml9bbXanZHWeOq5mPGsAh5dXiL9/u8TJYIHSAGUk4d3MKW8JMszd+ehbjC3HKEl0EeuoCag0NZjJXkhRGKPv6a7p844/tkV8kewMdxwsy/IDMIngw/ieTTJ9lvvxYSilxFq40hUlrEjhv+lDv/fQIqMg5MWCUUpbGWURFu0zMb2saSIa5zPto57UABtywbYKbRY7jjljHlAcAzfZkQwsdD8DOzwSkTXqMJvmubQ3m8zzlquqjwPCXXGK0PwvR5CPLx+lzUDrfpGWNd9iBsv5I29+z4aJWFTzjMrxnb+Y366zpVWeyRIl6H97ONkJvE8vrhb7bslvNocZ3lHrumt38wsXwHgOEMWjeYYeYrkJjWJwc/smRgnI6NiwINqUXd6gBsJQYtl+khaZ+KjOcKbTWG7IA4vPqaqci+sT3nM4jDrQ3lY3ShyyeohsFoM0ekXS8TbLRzi3xqGqFSLn6XRYYUorcPfk+wrSQE9/rUSnHIjXRiIM+g6gG9dk51YIkhgK/oL10sc5fK+97smMl5+ikyeghuIbVM+hvz1xRktc
 fOniJ+I6
 hyhPC9A7dxMD8F+ezcNSUCqK2tTEGB4Ykj7Kh7+e+cXR+GFsweT7NetQqlZOzUfUzpzDhjcxxrvCMOHgVA60I2tgN2oviICjcLpi1KoH5lz9swl7uk4GZObRcT+n/l7fePwkOToFNbWFIteRqIJEWf4vfuxwtL/h7f4BRt69VKxkw6+CBE6Yi++g+532WX35PNOKcMp5sm9Wez5SPyvao/rXJs9XUXuhEYNbNUg1QsLAi2BshvF2uSOUaaFd7ZRCNG85fvTAD8n++Ufh57TxaGWL7aTZ4v4yMmjklg9JSwqzm/k0almy2kMGrX5Pj57sWqBNVH1WU81EeHY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Fri, Jun 26, 2026 at 08:33:20AM -0700, Breno Leitao wrote:
> Add a destructive selftest that verifies
> vm.panic_on_unrecoverable_memory_failure actually panics when a
> hwpoison error hits a kernel-owned page.

> +ksft_skip=4

...

> +ksft_print() { echo "# $*"; }
> +ksft_exit_skip() { ksft_print "$*"; exit "$ksft_skip"; }
> +ksft_exit_fail() { echo "not ok 1 $*"; exit 1; }

There is tools/testing/selftests/kselftest/ktap_helpers.sh that already
implements this :)

-- 
Sincerely yours,
Mike.

