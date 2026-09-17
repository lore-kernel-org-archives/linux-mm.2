Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18137C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4A26B0095; Thu, 17 Sep 2026 03:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84BB6B0096; Thu, 17 Sep 2026 03:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1F56B0098; Thu, 17 Sep 2026 03:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFC796B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:41:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37A04C0271
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:41:11 +0000 (UTC)
X-FDA: 85222458342.01.49EE3F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81FD240003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:41:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCKcHToy;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789630869;
	b=ZAlFkULE7AhnSY0Q6RH7lF6YJSiZxFWd6ACewLfcqK8Rmn7M7yA2jdDRK4dpaOyepd/n3s
	1mQD3BMDTuwuXh6B/puF3bNzphS5CQLfIl9ogtGCB8pLQ3ZGUjGjEZ2JXxKQQUVLdYGeQA
	zNLKNHlilCDAAklHaBuG52CLnVcCStI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCKcHToy;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789630869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unHzs8AmLeied82z5XajBgVCmX9rGOIH63gfwiwzlEw=;
	b=0nwXOGJLh2UrNSeh754gHRDwY6CXIxLw5hJZCiw8wGpBJyNH1MU3439VNjF7v/AhMalxVr
	D1boXOcmONIgbsnKUEWydfJXxn5akyhv0dFXUdytwInZvtFTksYl9N2OI4KwX20V+LzSZU
	RxYSku4EiA4go88wBGuNlQsSM5b+Q7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7507441B60;
	Thu, 17 Sep 2026 07:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2678A1F000FF;
	Thu, 17 Sep 2026 07:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630868;
	bh=unHzs8AmLeied82z5XajBgVCmX9rGOIH63gfwiwzlEw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VCKcHToykQHUK3KLMsFOfJi52WtYj2xDx3YhcffiTyYFiTbT6rrW1T5/H8XRz9fsd
	 LwPark6HFPoxdThTzS6OjSLTavEOAzfI4e6KFNCjcc6t68ZN5YdbcsukTWnFLPqikw
	 kk5B+/tgSEHiHx89VgzD8r/RrqJ6Xt9JvPtghBnZsrhePaUSTIGEwwYF+50ivLUeKC
	 NdAmMTPpwmtziWognzeSs1qypOIVOh1Cl5O17iYd7c079S+3BMFDCo7FWvPjfaTYNc
	 sGRsIhNTs+gKnb+GhDLX/tJU+MChR5gernDXVU4gEJMEJqpXTmpgpSF5uSSSz7BKNO
	 RCfUNUBOB/o9w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/2] init, hugetlb: fix early parameter ordering
From: Mike Rapoport <rppt@kernel.org>
To: Zhenghui Hao <zhenghui.hao@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
Date: Thu, 17 Sep 2026 10:41:04 +0300
Message-Id: <178963086483.2200502.14463144472620315064.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81FD240003
X-Rspam-User: 
X-Stat-Signature: sgaa83ziemyp47bkcae771yk8au65cr4
X-HE-Tag: 1789630869-155316
X-HE-Meta: U2FsdGVkX19QfGIcJ+931FhFhQ3rKz6VnuQrfFxiJzpmabjoH7tPFF005ViVjLN5ZP9X9ldy8Cd69pAstyriMtIIq37TO8hL3co93i8uwtjJWtcc7D+nwUFX9VoRTfK/jpvnxXcrTGIDpiREqiGgzEzl2TFRtpcP5Ww+GUQHa2O5KLuGZON0iX6+T3Q16hxQorAh1uikinZFMnF5TwSkA7hPgLU8bggjV6PHYbo5Rb3FJRlzjIni+PyLqBah4Drzw2zVeIPBdh5oHM2UqqXa83lJunnR8S9M38Jk1ZVXaUDreLpLRybApbBEjD8Oesf/pzBcqtKDnCUdFfZNoPSERT+S3983LvKbH0drtdYaATUX6Ic+FibfWxZoRN5eXTqABq3Y9F6tdC+ttp72I/9BnoaNtgyXNLC3/L2Q31U5UtT4aw+R0HDxnUmCxCfIHERjpZAMJrnQc6bT9eF/XbIqy0dQe0H+96PAS4O5rfjeV4seOC9gFx9UMeWvm//7Zv6kuYo4IA+E4G8SP+R9dpeAlJ1RrUbxEkxeYRsuuS05tFq0/KptTV+W+iHDpXW2YkrNf7inTjxBjZ/ZOyZwwfXVMRfC1fxhNgjjR5+PO6edilCkL/fYfUpe4XzpF6YEWK+TdZ0Qbc296oCJ3/jXoQhm/6ZIgK8SF6/7Y4ck7xDY9MjTGQT2sKRTXE7zCqiexmgXHdxWAj5FwSZjbyi8sAMt+1+mwx3OPrqUQobgRKjpArtHO6XJMHUu1mIu3RdOJ0WkmD2wRlOsbDSAHzKDlp+OQU8w+B5sJwYxU17n/1ExaDryAsVQJwPvFOBON54ZFVlr+fMR9Cxb0a6LoADXwCNeO4hYDahCSqb4uKd4Y5Oby1CzIZ8287cCofFI8YP4b0aj4AhJohS4JqEBfw+nnPWavg0z6niD66uVUXNii7lBmtmVH/wMgV+lMWt4pN0hEWmNGH6vKZaTWau+vN9upcX
 inLctdGU
 a1dMLxFxbjE9Ei0WUVQlqLlh2OjDEkixc6LjONxEnOqXzAQoXeHMixQXIkR0z24xUDMD8Ad0d9vWQv9DMZyiBRg8dyyrYEBmG0gE2YDmcqbehTXM3vTxz0Eo5oR92asJFY2tl724hyVNtopkJW0g+vwV1XzxdNGgAMh9FfH+UQ+ovOoDVj2V3mx/WqGD9NZ+EDLon7HTP9E/22Hpp3PsWiK9QHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-09-17 14:55 +0800, Zhenghui Hao wrote:
> hugetlb records its command line parameters from early_param()
> handlers and consumes them later from hugetlb_bootmem_alloc().
> 
> Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
> zones and memory map") moved that consumer into mm_core_init_early(),
> which runs before the generic parse_early_param() call in
> start_kernel().  Architectures that call parse_early_param() from
> setup_arch() are not affected, but on parisc the parameters are then
> recorded after they have already been consumed and are silently
> dropped.

Since parisc is one of very few architectures that does not call
parse_early_param() from setup_arch(), I think an easier fix would be
local to parisc.

And there is another related question more to parisc maintainers: do we
really need hugetlb on parisc these days?

> Patch 1/2 moves parse_early_param() before mm_core_init_early(),
> together with jump_label_init() and static_call_init() so that the
> "parameters may set static keys" guarantee still holds.
> 
> Patch 2/2 makes this class of ordering problem non-silent.  It cannot
> fire once 1/2 is applied; if you would rather take only the fix,
> please drop 2/2.
> 
> Not tested on parisc hardware.
> 
> Zhenghui Hao (2):
>   init: parse early parameters before memory initialization
>   hugetlb: report cmdline parameters recorded too late
> 
>  init/main.c  |  8 ++++----
>  mm/hugetlb.c | 14 ++++++++++++++
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> 
> base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
> -- 
> 2.53.0
> 
> 



