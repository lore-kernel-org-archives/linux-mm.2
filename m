Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F84C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 20:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465936B007B; Fri,  1 Aug 2025 16:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416E66B0089; Fri,  1 Aug 2025 16:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CD46B008A; Fri,  1 Aug 2025 16:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227616B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:13:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78DA5C010F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:13:31 +0000 (UTC)
X-FDA: 83729288622.26.36AD5C7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF48314000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:13:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W4canb2S;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754079209; a=rsa-sha256;
	cv=none;
	b=qNVI0JjfpZh+C7qfTlFCf0N0QAA9ZIeqaMYSYzIgPQziQuEn0/bpCWwfp1iJHt4zM92dEY
	tnVaVNZbKJ0FJIgDjWIoBq/XlvJZ+BC3Fh3xQV/rl7Pq5fAUVdRRe954Mmf6sYpt0Uel4i
	dxYYHMemxC+fVPke9AVSUaK1kQnUWk4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W4canb2S;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754079209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRxRA81UCOepWIEaQkaCu6xBDyfNQBkbQLYOh2c2n7k=;
	b=Hw12a4IUW0N8SpHAcAeXkA9R5kjvkoiimM0d1ED4HxYou4ybrk1KebuJpuhJuWbPIWgE9H
	Vll5eO75uEsXwlw9g0e5qIT8E6HLevxl2G9pf/xKwW6MlWzdN5KZAX+eleYdB5TtdBOKXx
	v6BsG4+cnRXPdFCI6LNsIWx1H41M+MQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D057EA5596F;
	Fri,  1 Aug 2025 20:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348F2C4CEE7;
	Fri,  1 Aug 2025 20:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754079208;
	bh=Qg0kvxsXNNpQlr8Zn+FdmlEiWcpF6OIoZvDXUYGqrFg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W4canb2SF5TnJOwxq82Fn+CSgL8a8vreR9ladXrIK9QT/uR42ZpwLxtto1soRZkt1
	 MFi7dhpFK8Vrhxx7lo0QSpzhKWWGZrVqGPAmDvuDVpZlHuJ55EcSjbArnQLym4WYkv
	 E8cngteSQ17Jk4ZPH81ClCD3K2q1Yc4wV8oFOHa0=
Date: Fri, 1 Aug 2025 13:13:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: thomas.weissschuh@linutronix.de, ryabinin.a.a@gmail.com,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kunit: kasan_test: disable fortify string checker on
 kasan_strings() test
Message-Id: <20250801131327.8627459bf3d94895d42b95b2@linux-foundation.org>
In-Reply-To: <20250801120236.2962642-1-yeoreum.yun@arm.com>
References: <20250801120236.2962642-1-yeoreum.yun@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF48314000C
X-Stat-Signature: fpq7tg8ibxepwqkqhx5trkcqbnra8ubr
X-Rspam-User: 
X-HE-Tag: 1754079209-364493
X-HE-Meta: U2FsdGVkX1/U2OJvjCvoDkXLC9UiejyRDicS5/dw/JIu62gkZqD8BM1p/r6V6y6aWBgGiK+levXbZ2rHH3lHsVYRUz/VzaNao2zw4Ez/nRGByHV/YWctzG3CvhmdgrdImKIlLh8fDQXtNb8iufu79ysaW4XMpmn7Zy6L6MBKQ4YUZoKrSzYaB4+oa7DcOkYB1OMmify6NsiadNYb3vpcvK/QjbFGEBHLc3Ey0bBXlaEn3xpXtIpNXU8OunSmjPakDu+agNi3A4LjqFwAPAyOE6i25mBylk6Q9MdNXt0MoQViVNiX67Hk63JCW351iUhclGSJAZGVj5OLI6S7i3UAdvzurpR5wuf1B5KKD++7nWr+G3pQQ+3HMDyY3mm7Dep2CzwnqCsWpN8P3gNw4mBhdyA6iHWU0By4LKj7Qcp/8pgEhDNxQqmD3mV2qRGgUKMV2SeMVR2yWE6w0dVNAusTQup1kp5vgMfta5r3zkYnMxaPWTDXoxNVQEnRARoluNXOH2DvrnmiwSjyaIeXVWmsSXyQY/qzX0FuouuGxAf3HNExlCJ2dh8U3kSP8dD1lCpeMX+ir3U/Ab9JrxhfR+mH1QGADzHhGrGY0DazzthqIeuCiYLMQZs5pHz+kaqSb6oKOnLD7+2sqBHbZ4QyygCyDt5YpILGCSzj/oi/tR+jpVu3ITmiI2gT4QXy7jQXImUwc0kW0FpuMDNo6Ni1OjPNbO5FrRYa6BHTRdF+BmRvHEH08MJJGBnhNvEZ4v5xW0wGFUFUYZSG8AJL0Ls51gXvKytkHbsqLMdhPGCAenfSIu/CaU79JilSYQyX4Rh9wy715dJCIWMj4SH45702LewDBcTMr/kkgldsoS1FWCmQH36bDgFTNSFX+lzaUDoezdAYSBN8a2X+072Xfb1gWZMz0GQnfavVpCmX43wMbBysxaaGqsB5DhNGjm1e9FFHyW7ylyXEgNnjABLkffeYPyr
 52eR7f3r
 Aa4BwBfd1OOkdLqB0s9pdIilKLJwHe64orNANE4vnKRNboAxW+n1SfgPL4sNc1JaFw+tKcPpXBh+X+y1pruCEymmdwxc1GKodCxmCcUg3q6bKJGeFK+46aXfdBTh/WFP+D4WN0tjzkyg+GG4nbOpr+6i51tA6nfZ2ed7Gs2501F5UYG04LJ67e/BlloN7dcqNMaP2IFbd9ffckZIp9k4riIP93ZidHoVFG8XDocY2EvkQmNhKJNW7AUeFLaquLa4HjAt870rY91eCRfJrxtzLGyae2IiNytiSnBigFrjwalJWGbRvUW6gW58Ol2M0Z9y+yUdskgQMcOC3OOIaLrq90az2BKmGjVkq/toht1MkSyfXEi+BqwpkRKS2BBjijxZdzniY90QY7u4cUHKorGBwu82DA/PnZFOQ2HbkbnfKz9DlctyM9KxqZRqTd39xhjUYFheL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 Aug 2025 13:02:36 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> Similar to commit 09c6304e38e4 ("kasan: test: fix compatibility with
> FORTIFY_SOURCE") the kernel is panicing in kasan_string().
> 
> This is due to the `src` and `ptr` not being hidden from the optimizer
> which would disable the runtime fortify string checker.
> 
> Call trace:
>   __fortify_panic+0x10/0x20 (P)
>   kasan_strings+0x980/0x9b0
>   kunit_try_run_case+0x68/0x190
>   kunit_generic_run_threadfn_adapter+0x34/0x68
>   kthread+0x1c4/0x228
>   ret_from_fork+0x10/0x20
>  Code: d503233f a9bf7bfd 910003fd 9424b243 (d4210000)
>  ---[ end trace 0000000000000000 ]---
>  note: kunit_try_catch[128] exited with irqs disabled
>  note: kunit_try_catch[128] exited with preempt_count 1
>      # kasan_strings: try faulted: last
> ** replaying previous printk message **
>      # kasan_strings: try faulted: last line seen mm/kasan/kasan_test_c.c:1600
>      # kasan_strings: internal error occurred preventing test case from running: -4
> 

We don't want -stable kernels to panic either.  I'm thinking

Fixes: 73228c7ecc5e ("KASAN: port KASAN Tests to KUnit")
Cc: <stable@vger.kernel.org>

What do you think?

We could perhaps go back earlier in time, but 73228c7ecc5e is 5 years
old.

