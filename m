Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF73C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F3B6B008C; Wed,  8 Jul 2026 23:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D00E6B0092; Wed,  8 Jul 2026 23:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF6A6B0093; Wed,  8 Jul 2026 23:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6195A6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:34:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1F32A038E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:34:21 +0000 (UTC)
X-FDA: 84967820322.13.FCE3827
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81507180005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:34:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s1YxTUUF;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783568060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVEML/8+IfGqKnREo8nPgV/r4XM8JifO5Ewy94XS6pg=;
	b=Jg+q6Htj9nrwkMPnRCnlUVPFGrvO32uLdPZzEciYq+zqgivycqaAlpf1lvvwU9m5cWyIaz
	BDV0M0s65m8/Ko6ZKIKG0MqRATT1laNTP31pTae4q8eQ4bv510YhO5ZwC45B5mlFExc9DJ
	wiS8QnpXKrOZ5ie0f/hp9SSzAg5r2SA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s1YxTUUF;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783568060;
	b=aefxUlmDPmeTUc+hVjHP/XSxs7tFvv7/473KDBVIWMSwNSP5Ao2MOQdqyvW2B2yL7/u7TU
	rXWgqAGusvShxZ2X6s9yGudtfkYNG5yPJduW6KoPsydxZXJbN3Mlk+/bBY/H7Smmqjcm6m
	WsIKnkbFjheS+0m7KBv4m/6wHQc9zmo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DVEML/8+IfGqKnREo8nPgV/r4XM8JifO5Ewy94XS6pg=;
	b=s1YxTUUFRO0IDT3TRih2RrpHuePCChnVY1Mkfh7aw6vzmcXWSDsaD/PefLdIgQrWYKrRr760I
	J0UTyncxTlRkDJk2ft7zpqwc1K4HGrWewU8pL/7+2gH89gAlACBs05EnHdXm983Y8+baCSGO9XB
	72nkG9EEvBIkpxxLpurm4G8=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gwgLt3mgwz1cyPZ;
	Thu,  9 Jul 2026 11:24:54 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9889E4048B;
	Thu,  9 Jul 2026 11:34:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 11:34:07 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 11:34:06 +0800
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
	<lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
Date: Thu, 9 Jul 2026 11:34:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81507180005
X-Stat-Signature: 9ckkxx69o55xby6tiuquzkfss79nrpit
X-HE-Tag: 1783568058-761802
X-HE-Meta: U2FsdGVkX1+z+1dhq2kaxJbugtWEPINVJnj7ymQqaZStk4AIDBcvPSmwQ8t3QPOOTH7zKhqaZ9y1P1nyWCVgABZmCMtgqyaEAp933A8LWKgvWMQsIfXmuqquYO4vabgjA28guSm2TVZKnaX6juCOSp8hkuYiJyIw2fZG8Lm/cJpwv2RIkokaqLCjNjBWxP6adDtpYsj2kSe1VU2tr3hVBIuIi1jOdm8AtRAUVxlnQDFGC+QVoaOI3U97zJqwp6xgvG8EzPMq28dGEuQ/bSUJe3umDYbMREniIj5TVz/4PY2WQS9nQbye40LfX03mNTngQQWvQ1NFL/QSdwgCf3NoN1AYI8gY+RcqgAmV7/+UEFDpjlVqIFqzqW67jtqDxZm0MW37zj5I+uCdswDvzaPQ6mwSj+4Tkqcf+pOcIljKFr3oxQNyVbJ48mm/9Vr07KA768vvR2hEn/RxvB6O6vm/9ZiQDNe2PW/mVk2KoUja8WRLxmtOFzBBTI9dgJMz9dZqKJ+q2SMkhe0Hq7bQ0r+kk7B3nV0kyBtrHI2bw80MggjdtsED8d7E8BLdqquDcbRQPCyRThAn4S/Dq/SbXxM+SDkNVxXzyQu8gBbvBfmQsQKuo6rHfq0uoNU8vYuohkeJPHt0lEof71FyOOJOSD/1GEjWT3jxddATcr1uPD3E5tzOSONDZM71lYnteTRv2ZKn3D14pvJJPwG4TioRaUH8LDDqGoSHa+H8HU57JqkQf16o6u7nCb/KiOYH7LHZvzNA5+k5wreViNa/qpQvkLBTTw8hem0vSXm6AHUxRSOk2LEw0mbnAbeSAjkZNPAkm112qh2ZC24PX4AlaF7j/zL8nctEI35KebMAJ03csgViXdWnAv/hclHdWZBtKTzrF3OrOloduIdeq3LbdAGiNET5Dg7hCUAY1eLlWBXsVJTJtjKKI7/gtywjkOes9mqFwmGGS4AuK5KG5Ya2SqEkB+1
 TQRoUK+N
 NpFb4g+zytRAsWZz6ridTMxNEmssox85iNUJpCGgiM1Qm4b/kzRbLPHvTise2ksoljIf0Y5hYkzqSI2b2Baoh40m4vPZnN9656avIz9EoUZl80m4ApplffN407oLHE0HTXzOYrmLsKj0uG1cvcfagRGk6vjVIqjRuzSbfYEfQIv6XNInHXcOhcGD4akXQDdrq3M5laz9cRcxXgdsCXPPiR5yp90ozgytRzU9C8HllwbqUnwAimXS1EHi9Ya4Y9hpBrVpsQu8IfMN/jLFIJyfkvmHC0JDg4hFWo07Id7vE32EA6qU9vZDSIgLMayWweYDO/R6FPzNQ0geym4nu654OJnhhtwSXAAa5gPEXKN1I8oX0LwmbQ21FtK6fcWlxr/MnqXYZvgSjiMPL44DbNKh12a8sdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/30 20:46, Breno Leitao wrote:
> Add a destructive selftest that verifies
> vm.panic_on_unrecoverable_memory_failure actually panics when a
> hwpoison error hits a kernel-owned page.
> 
> Three "kinds" of kernel-owned page can be targeted, selectable via
> the script's first positional argument (default: rodata):
> 
>   rodata  - a PG_reserved page in the kernel rodata range, sourced
>             from the "Kernel rodata" sub-resource of "System RAM" in
>             /proc/iomem.  That entry is reported on every major
>             architecture and guarantees the chosen PFN is backed by
>             struct page (an online System RAM range, not a firmware
>             hole), is PG_reserved, and is read-only -- so even if
>             the panic fails to fire for some reason, the resulting
>             PG_hwpoison marker on rodata does not corrupt writable
>             kernel state.
> 
>   slab    - a slab page found by walking /proc/kpageflags for the
>             first PFN with KPF_SLAB set (and KPF_HWPOISON / KPF_NOPAGE
>             / KPF_COMPOUND_TAIL clear).  Exercises the get_any_page()
>             path on a non PG_reserved kernel-owned page and so
>             catches regressions where get_any_page() collapses
>             kernel-owned pages into a transient -EIO instead of
>             -ENOTRECOVERABLE.
> 
>   pgtable - same as slab, but the PFN is selected via KPF_PGTABLE.
> 
> PageLargeKmalloc, the fourth page type matched by
> is_kernel_owned_page(), is intentionally not covered: it is a
> PAGE_TYPE_OPS flag with no /proc/kpageflags bit, so selecting such
> a PFN from userspace is not feasible.  The slab and pgtable
> variants already exercise the same get_any_page() positive-check
> branch.
> 
> The script enables the sysctl and writes the selected physical
> address to /sys/devices/system/memory/hard_offline_page.  A
> successful run crashes the kernel with
> 
>   Memory failure: <pfn>: unrecoverable page
> 
> A return from the inject means no panic fired.  Before reporting, the
> script restores the sysctl and best-effort unpoisons the target PFN
> through the hwpoison debugfs interface (hard_offline_page() injects
> with MF_SW_SIMULATED, so the page stays unpoisonable), then re-reads
> /proc/kpageflags: a PFN that is still the kernel-owned type it selected
> is a genuine failure, while one that raced to a different type before
> the inject is skipped as inconclusive.  Test outcome is therefore
> observed externally (serial console, kdump) rather than from the
> script's own exit code.
> 
> The script is intentionally NOT wired into run_vmtests.sh: every
> successful run panics the kernel, which is incompatible with the
> sequential "run each category in the same VM" model that
> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
> ksft_* wrapper so a default kselftest run does not opt itself into
> a panic.  The script is meant to be executed manually inside a
> disposable VM (e.g. virtme-ng), one variant per VM boot, and
> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

With Mike's comment addressed:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

