Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7FA606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oUiXfXRG
Received: by kanga.kvack.org (Postfix)
	id A19DE6B00EF; Wed,  4 Nov 2026 09:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB946B05B1; Wed,  4 Nov 2026 09:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA306B05B7; Wed,  4 Nov 2026 09:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65CC06B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:35:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5CEAA073D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:35:28 +0000 (UTC)
X-FDA: 85397684736.06.E31DA24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A5B3A0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:35:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUiXfXRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793802927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=259c1LmT7AqmM/9aZ6KRKIwG0j1/LADB8Zw7QHVbn7g=;
	b=i2hbApENpLnDrd9mN7gS2lrt6M8F7QJNj/o+UcqpR0Ad8Mh8+7mbx463mc7pcN+B88OpRz
	yw8/hrHVYufnjW9mTyE2kFengTnnfLoAL8v48FOiTThizTUFX4ew2oXhun27FvcRKBNX8D
	D+qzgjVJJYxQlcbhjQdbseoKHShVAms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793802927;
	b=RXQW9X/K6HAfdbEAecKkeZrIfHBpd0p6JQXeteJ4ZKWGgUT1cyw2kl2j5P0YKE0lxWS8UB
	3oZHHrOYRky64NgjYqMz8NyKsKaEpK/0DjM1UYq/dkhWyd2IboV019c6PlUDlhGW+DFTTo
	w6FDp6QXuDiSnIWmvklu8Y521ZE+qX8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUiXfXRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C225403E1;
	Wed,  4 Nov 2026 14:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36F01F0093A;
	Wed,  4 Nov 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802926;
	bh=259c1LmT7AqmM/9aZ6KRKIwG0j1/LADB8Zw7QHVbn7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oUiXfXRGMzDrLRdd6T0Oich0vIauJ1IxXJ1dFn9HNlQS7VRbIEYQoO5icKIFbDYQr
	 FIesjkf53ezMftVt9AD4US0AhPM55AOt/3/t0+EPXznJHtv46pzaI/tqJWeBBhawhp
	 ah2Z+RrmBGaLz/vTFwdBuZRRAC5Yx6UswFArajHFusFtCw7BjkTb1Z9G5ygQztzj0X
	 oZQ+pC6lBBtSH80vJoKzQmhxC4Xu7t4+iMh9oIXUuwMnMNQ53p4tBhIuK3Lh6et0NY
	 42k7EbDFannFvNeheyUQyuk+7awK7cJqVO7kQvbL6Ly+M4C2cMDqvLbMOR6aJBA5/j
	 DOKbg8gShIJOQ==
Message-ID: <12f80449-9d6c-4fb7-bcc4-e7d38e868da2@kernel.org>
Date: Wed, 4 Nov 2026 15:35:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] tools/mm: add hwpoison-panic tool
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, kernel-team@meta.com
References: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s3arbfxkobr3q4xxr6qcdaj453tf5wap
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A5B3A0004
X-HE-Tag: 1793802926-737196
X-HE-Meta: U2FsdGVkX1+ngYgJK2L1m8LkXs9nBEo5/ZwgNh6WG+qPUXx6thFpqFvKN4MR9B9Nl0Jb4oRT3f5C677QtV9XneJuTcV2yLpwxV45ocEF7Q2OKTLOwiBRNjLyHTiaCvp/FoiqMcwuEZxF+TM6Ci/nzPXzfSYMuPgpqrbeKW/i6vilri8GO8oGx2wXOIYiyiM4/DL2fTrmHvH9gkbpYxjWV810CwxKULyBIxJB8XxCaah5xZrjeVMqbacBbFXmLgR0fFG2T6AhYGx6GPTf9EafzpuG2Hl5PLB3kAjFoWAkw+BoDMCbCJPgUuioDJ3Bxj72eQt1ytKwGuoG3xpHWOYdcmHOjggySuyOaZMGKwTDRBf0yYHAzzex/uyZ/Y5PEGdVIs2wBOiyDmR6+3lS0ci3EPnqIxXNJgHqyOYRTmNeLSnPr4jFZm0MXQna2OulfnT6zGoU1847NZCB/CZ2s0yEVpDUxTT76ld7czRmTtUtk1PwPppbY20md2KNv/zqjDh45RzcTpSTGYAXHwLkzL/L4tNQl2dXAQP4MtxTSdsbDJZpg1U1wG66guyt8WaPe3M0oZNckkdK+4WIwitUzg3VztRaLo8Tpeqd52vvW3Z7IKQorGA/wUOXRpppSFVBBDQnv1YpzzXyDF/XpgnUOCMAR2Qe1ckVJGnGJac9aYuL5nIFuQgQasF4waLWOZBlfBT9wp64AajGLBhPBC49eX4sMSZYWEGiwyKHYXW3bRrNvh/9D0HQrwuGjJJiMhzAgBEe/wvFOatvD5Rug+3LPYRxm+eCLTQSW9LgmaVzD/gXXmv7tFVVMovU50+SGDkZcK7qPm7xWwL6iF2b98w+2upMajlHqwzOXHgElAoTFb8OCekC6+kqYX7wIN1Et2V5yrqcivK4B17eajXsDZCBFvGZHmiqcFL5piOltTFdAIT3maLkNE2YMq+aYA4V0bqbe9f+jNgKQU2+12nC2DgY2T9
 MjRHTWqe
 N7I8wVVqlI95bq7l0gZRFw+c+/Iz9ySn21FGg8DNEN48i+DiBd/oHGZJkBstNakw3myifCDlYj5xoNQNWO8pErKNXPEgpTsNekhnKFRvpKikJ7mG3Hs9n7T1Cd1jsghnibH0of5kaGmNoHOvpMTIqefaTq6jMLp1K9IEZ9iTHCYI1eJvikl4F7uQEpTtL4tkh/h6bghU4lFcE8cdN5nm2GIcC+t+Yl8Y1VEkEEtjFg+9PO8LHgoXdGyaeQWpbxTtF6t73FV+yxeyTkF8dufIrWnFEsrPouT0WpgqZ89I0R+P2eLRCw6pWL7OSLT4GVwnPVrYaQ2zPAyKnlD4vY1pXZoQ13Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 8/13/26 13:45, Breno Leitao wrote:
> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.
> 
> The --yes-panic-my-kernel argument is required so an accidental
> invocation does not take the box down.

This is not upstream yet, right?

Anything missing or is this good to go in?

-- 
Cheers,

David

