Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E203EC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1076B00A7; Mon,  7 Sep 2026 08:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88B46B00A9; Mon,  7 Sep 2026 08:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E9B6B00AA; Mon,  7 Sep 2026 08:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71B96B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:42:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E35EA2B22
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:42:15 +0000 (UTC)
X-FDA: 85186929030.14.9E0FA4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7652820003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:42:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BN062EFB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfMjjI2/7Y+3s7ee+yLarkRTyl6EkYifeRjlYtTl9Y8=;
	b=TAfSKs4ue5nSSfgquhIJO7rws4A0oObbtf+q3MppC9l2yUxmItoV7/MhzhqZzoEGnT+I+S
	D5P9izMbuomOHzeArlGhwP4RDVgiTPTLh/apYUhky8hV52k5V+ofk8S616fu5rmecuUQRr
	QCRScfeKcVXF8xm3nZNhChzbYpBiQNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784933;
	b=ASi2EV44j0yv48UEwQnWDB2nH9RZOPuQK02KlQR6QqSqXNU3Vyv7OSi1kCjHYxl6yiV1G3
	7NldoihsrWzpsp1V9KX+QwVCFWtzlor7vDzF3BEFkoDdtpkVLsNLCm/PRUOmCI1Oxa9HV8
	YFjcN/ArTLnUnRvOzotEqcDxOaAoeQA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BN062EFB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85B0643D56;
	Mon,  7 Sep 2026 12:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDD91F00A3A;
	Mon,  7 Sep 2026 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784932;
	bh=HfMjjI2/7Y+3s7ee+yLarkRTyl6EkYifeRjlYtTl9Y8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BN062EFBvF2RtBvaF2jcb9/4wctMQKXTnIVyY+FSkPOpdWwfOAtcGub+ZYo6hRNnC
	 uy/uQ/qMVG3Z/v4x/XFEMNJ51/MquyVxc5UoBSux4eqRB/gzl4tA1P2KSNrxetjcNi
	 aBLy0Htl8EZAlZyhf4Ly9gbsBRWSZLsrCBPwVs59igbx3sv6vtl4mAxYvw4YqbwopJ
	 czVe9Ogk1g4l1NAVXW++p3A5Z94J65+41Ma5rHiKdqE5/3jVjl+OA5Skjt/FekcW+t
	 cXZ3Iu9R2IvivAMx3yRFKMqGJJwFU7IhUy6yHCgSsa/Ki5EEQ6ThBXeJdiqqmB3FOU
	 dkVYKulSnFvJw==
Message-ID: <1ecffc76-55da-4831-8f21-04c97ce90ec8@kernel.org>
Date: Mon, 7 Sep 2026 14:42:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] tools/mm: add hwpoison-panic tool
To: Andrew Morton <akpm@linux-foundation.org>,
 Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, SJ Park <sj@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kernel-team@meta.com
References: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
 <20260829193758.b251f3c89f8201bdc585a305@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260829193758.b251f3c89f8201bdc585a305@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: giy865fzq1dru4k7qrpkptnd7ykqngmm
X-Rspamd-Queue-Id: 7652820003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788784933-160126
X-HE-Meta: U2FsdGVkX1/N5EGaqWESMiUQZmOOm/ZPT1Uksf3pffpJk3fiKKl7x3d36A2eaVSNy3Ega4B+MiPAbeRgLlA/xIYwo1LBlHXyFKah7c5ReK3uzQFGDoRvw1Ez+oNnhL8mwb1xLEmOraossIfb1UXAOSUz9RTegCAKCsUu0Z8v0mOVhjA93eN243wHttuCdEMUzKpEAVvC3NxSb6BgN74RFSRrrFiH9gi03CkOLFBM6SR0NPZce3+oXhxuYveu1BgyR5M/dWaEeAWnTJzunEvZrLCkW+WEiFvxDCpr7GPCQ8VUUrf5xdmaYC0AC+rwI9dFx08ysmCBoKc8KrBn72zyYS8orHA2PNCPUBiTzMd/gVikGClSsSd0gWuOvaILpScm8LWMbRbzNLam9nbO3tnKWBNDFziEYhm6ZPelM+glNMkYNg0nZrhcKCQuWe0bXdkrp6BxOTaICNQ2Kzg61MjFQCRmJtcmRS3avNCUH1oYfqnQVw0U1/5bML6gQYALSesLfhEgJG8FBZ3y5gkz6HTYMRtncGvMW3ww7p8Eu5n18K7PaI6l+WzMnDq/Ppr/xco1kcrhO8sBX6yOrMDdHnL4o6G6UMDhTzxg4JKH2tFKhB0Dqxf3b3kiCqCecNyJUpYwooeo+l/fsGLYkJpjYkn197MQqufC3zMzMXtSkW0lf+oL14bhbaxp3WDAlm9ehJVryJD0TexXKDHT87g91+ttms6fGwk66sd6liBsQ/g2WZZBF5vYDuVQq+siTxYHHv9cgBjkd68OOxaSqByKa6S0fCyI6rSSwbVxwtPFqRdXEciKpX6uAJ+qhoij8kuTjGhgBY87is6287ndt+qYKQg4DzSClriUq0/Q7v13eN4nU+/MLszc12fTlsTRcJAbqn2jX0UnH6Y3P9kXI3T/U8jXaqFa/pcZDYoQaKKBOjN1IaW16MjcTCcRWGDzQxhGo9pPltRZa4S7mwpFuaWYo4p
 vvgQbK4O
 tUMUon5M+/FJqVGz0A2FA3B6apJvbF0g0sqhsjD1tZRVViJY1kdoGU0Iwljt9qvO/rsCnFqbJrcgaqgZl53ZNBbhXDRhMsc62fAzMuJ/xoaXVlNddbyJNap0+FiEEJxrnV456MDzVxK6Zx8NlPB03Dg0ZgKPPxc3I0u4Xovd8ynrMu8CuMTZIVwFve7tt2ZuhZ7tUIGu24p6D91miMdAf6uhP6ERZc2d2nDd9E2lIx2SKGPCkm26DK6Ep+U8Tth7OtR7xeYJDJfbJ8dVEi2sGmo4nBCKEfQ1fvXdzvUWO5C8I5huGzoi3aQH4E+34iU7P6aeHjRzaBMSYT84/cHohjlD9jcnrKaetv0xHL5+oMXIZ/lY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/30/26 04:37, Andrew Morton wrote:
> On Mon, 03 Aug 2026 04:31:20 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
>> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
>> sysctl, picks a kernel-owned PFN and writes its physical address to
>> hard_offline_page.  Three page kinds are selectable with -k: rodata
>> (default), slab or pgtable. In all cases the host should panic.
>>
>> Example:
>>
>>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
>>
>> In dmesg, you will see:
>>
>>         Memory failure: 0x100032: unhandlable page.
>>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
>>
>> This lives in tools/mm rather than selftests/mm because every successful
>> run crashes the machine, which is not something to run from CI.
> 
> I wonder if we can fix this.  Add a knob which tells the kernel not to
> panic/oops/crash/etc.  Instead it sends a message "i tried to crash but
> you told me not to" and proceeds.
> 
> Set that knob around your hwpoison-panic tool and voila, it's now a
> selftest.

We just shot down a random "kernel-owned PFN" (marking it hwpoison etc).

That's really not something you want to do from a selftest.

You'd need some kind of hwpoison simulation mode.

-- 
Cheers,

David

