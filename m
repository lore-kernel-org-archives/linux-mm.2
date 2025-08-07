Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C8AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D373D8E0006; Thu,  7 Aug 2025 14:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EFB8E0001; Thu,  7 Aug 2025 14:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25038E0006; Thu,  7 Aug 2025 14:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4B718E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:32:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66BE3160B01
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:32:38 +0000 (UTC)
X-FDA: 83750807196.08.22097E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id ADDD5A0003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:32:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUG4nBJa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptip2nfpePNIt4ba/R+NnDmeC8nEi44rmzESa+AsoYQ=;
	b=Ev2QoQzV/0Av3jcVLLnJEo52OfxBuVBabtYLz9Lf8TxflAr6LsrBVxEl2/oanakW0FtMrI
	mSN2R6RnjpnHw6wmf76xBcGjCRcqeOpZvD3Cw11jiOxXowMFBliv7XDpN4lCa6FD1sShAT
	qUAjJQ8AZRrWwmH+Zbmw+wwY79FpIiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591556; a=rsa-sha256;
	cv=none;
	b=7UEkIQJMOHY34B5tFfY+fMZzow0g3IfTrF+ja8XN+hsJ5Fr4Key8wxxwNMiaAH6uXnetyI
	cHYiC4PLnyepnQ+u8m9Yo9lmQRpCass6ctSjtmZP4Up2M3d/ytcRzAumbMsszE/dqIzLb1
	V4i0TvnWfC2mtNKsftyeH2xbLIaDBTk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUG4nBJa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B32941986;
	Thu,  7 Aug 2025 18:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F38DC4CEEB;
	Thu,  7 Aug 2025 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754591555;
	bh=xWH0pR9x7HbcaeApYBNbCReET9nnVMFg2R4I7UwyZsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUG4nBJanX6vYcUxO8k4uEwTeZzlAxplWE4XTEJ8qQRlZMcYw+wtUXkJUlooRf1ij
	 ytri5u9Ex1UKD+Jo2hwScc+EvNY0uHMimsorzZejGPfXlEysMx/k9crYtIQVVhV4NM
	 ggVkipbRQfXmeAG0rIsV3s6z7148o1CZRdiza6baaTqzY2xEodOh0wkGJejKUJy/9r
	 daz40ONuhLg6KFb9CSyHsRBU8i5jbWXIrWWOg6nzYvgFHviRdXeTp5gUKhnOk8+3JG
	 +1K8cofcYSowX4+Exx/lj6nnJSXdvZGEa9oGqggrwOkKcL2H5lqRv0yPmlDSwNOms4
	 8fa1XYvZccBgg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu,  7 Aug 2025 11:32:33 -0700
Message-Id: <20250807183233.2055-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807181616.1895-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADDD5A0003
X-Stat-Signature: obetjuyact48shmm46pm59bntuqbw69w
X-Rspam-User: 
X-HE-Tag: 1754591556-131707
X-HE-Meta: U2FsdGVkX18iEji/l7Xqmg4sCEcbzH2phnI/M7fXbogX2O0p4cYds3m5V1GcbAvOa9ZUNYSVf5CzCCivdQm5PbB5cV2yJBU/nKMgppNfYXmcNkagZ7gCkkxX2IS2zKRu1G/+rsivaXyuej2zfFG4bqbl7Hf4QzKKlmNJ7Jse2mwR+qN+ik8XtFG4ke9F+ak9jRxdz7S2TsftzRJuAU6+/C/DCOsxoN7v5sr0Ipv/gixkd3206taSsJx+ysjfBBs/29f4QjVIFnMmxlYIrrcsuSv0wsXXjc/1HaTUbLQ1Rgr2fTiq/DUjQ9Vp1K5VqEcsV0A3Kqi23pH4WHNh8uDlmPkzs6Hb/wPOkfqmuBQtVmAjNZUyzhY+zhcYPBMiNu1/pBA9mh3QEB5lUOVzxUoDIjvEd1cqRsoT3err4KBb+Xx0NlabCHmwEJiGO0RiZNcksl07mLAkEcwTGuYDTw7o7dhjUbkwdgFSgwNvkY+ItvlpcoTKieQI64Cfz0+vEnNfg4Hnmpr1GykOAekZzQnVU+dfF4e7UuePjBPv/bw/1rDROwdc0xkQxlovidMnwSER0WP0yKqFMwKDbcP8ukPE8qXT6RDRxTOpFtJQPoJr0TJP/l/qFk7JqgSgTbT6Ni1eJkW6w7clzt1mC/U+hA6SXNljveJI+dcYetMF3//pX8MGlxMOPu8VCtcj4MJliDwlhLSNEkDWvdxvYgVoftvwr4RKfZ46EUXGObS3Du2gRIwpTz0MaxZMiHbvcSSEiXS3Iageqq2rCzecDgrKW46l02ijp/kXgy4lGkejsoNVuQupHM6eY/xqdtm8OHwPRSjCoIgkK/gtLaaRmyVVpxqIDms4urnm8zgIsc8J8zh8IXu/TAnObomq/1Kj83+B7Elip+6O/SaXYp3V/4Tmn3KPx7356BSufF6MPCv7hWLIuLU9TWleyHdV9TjqVcuWJ/McSQor9CN75eY7glo7i9Q
 HX0TFp5c
 CERieW+/MsoygxDQ7CYCySIXV51cmVL5xLGd7WeVLhJWOcs5kKZX7HZh6XdkZGbmLQw678/KWdUNRPZdyLUs+01coUX2JuO3EELUYaTTeIC/CUFLyJIIG13TlmImZiI/KcnHZvY2JgZCr0+JgIGzrFYx9jqROLmS80vyy/dq27VWzrwz9mWl0d4h3i/SrKJxntVzlznQr87zzOAHU2BGAXydHRUAdg73fWfaRIkX//ugGsQ9fAzpBzfYk86/hTTFZEfqDqER9W1VxqJT+tIPgoZD+V2AX8JqicLyBvkI85hCS4UM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 Aug 2025 11:16:16 -0700 SeongJae Park <sj@kernel.org> wrote:

> Tests
> -----
> 
> I tested this patch using a simple self-written microbenchmark that is
> available at GitHub[1].  You can reproduce the test I did by executing
> run_tests.sh of the repo on your system.  Note that the repo's
> documentation is not good as of this writing, so you may need to read
> and use the code.

The test script assumes the kernel has save_incompressible_pages zswap
parameter, which dropped on this version of this patch.  To run the test script
as is, you may need to build your test kernel with a patch that introduces the
parameter back, to use the test script as is.  An example of such patch is
available[1] at my GitHub tree.

[1] https://github.com/sjp38/linux/commit/3a8122e9cb947c13878f5fab1cd2d106be3f3d2f


Thanks,
SJ

[...]

