Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6406A606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAqpF+Kv
Received: by kanga.kvack.org (Postfix)
	id 81AE06B00EF; Sat, 21 Nov 2026 08:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB966B05B0; Sat, 21 Nov 2026 08:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC1B6B05B1; Sat, 21 Nov 2026 08:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3103F6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:07:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6C6E140498
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:07:28 +0000 (UTC)
X-FDA: 85459152576.22.1154BB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D5C2E20004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:07:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAqpF+Kv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266447;
	b=dF1zqHiXXDHZ43Vqg1BM75MHcFRiUFsrVtlRxfsgiRMe2KvLYY+t2YMvY98KSV6t78nsPL
	tyiTtjIbhZFWQoH1AsfRTSIT1UEspcvGafnp7QptUYxQY14CCELKf/5ZipWF82YdFaX65R
	wq19MpCnt2u4YJJ0rqUrnmtUVagu+aI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITRcNXOGOzf6fXvRxjYIfxCqRsSC7OU7PGM7ioDWcls=;
	b=QchWQuIJ27tBOOT3JqzN22nzvJh19cYyxln5YsrF6Vqiv+EUwRuW2qp7wkmG8FMiMLx42w
	x4l+yXSva/RjYmDFcEZnjvWRj0Wcywa+NguJJZW3HTVWmNGgnfde/DB6BYl/PSmWmz1xtN
	Snwfd28JOWs0fOUpgAPxsuPJ54W+6tc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAqpF+Kv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08D9741979;
	Sat, 21 Nov 2026 13:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3151F000C4;
	Sat, 21 Nov 2026 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266445;
	bh=ITRcNXOGOzf6fXvRxjYIfxCqRsSC7OU7PGM7ioDWcls=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EAqpF+KvlLeO6kE5YykOqSIJ9ejXREbKBnhV7ry++oRciNc1vR0VgN24cdQ5xbFHW
	 puchot6OjxmhQRuLsCDS89gPLMeqf3QBvWPwNWvcv/06IGHesIyDPqc/iz+2GmfTrM
	 t93R7oLVzxFc2dyKUIaCEI/RP2/bmAAp6B4AsUspIrCwLVyVa9KHQdWvgDr4if+11g
	 XxHIyQebpg3XQQ14sd3EYNBn7litRoH2UhXZ8E8ZFGFgV70gaQmQiI75ruU0aMIrGm
	 aiitkQIrC3zivfKa4BtO/2Fl2lMTyMsUO8SzuEiUVZ7mS7xEtPjeH0KbMm4cbTX1wz
	 9WFfFHzMo5yxw==
Message-ID: <0c228778-1091-421e-9caf-2a476bf5ee1e@kernel.org>
Date: Sat, 21 Nov 2026 14:07:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v6] mm: vmstat_kunit: add synthetic benchmark for mm stats
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: acjogs9d664oribwefrg57wdobfhn6qn
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5C2E20004
X-HE-Tag: 1795266446-367289
X-HE-Meta: U2FsdGVkX1+CzSQJkFYOmxyAnHK2rby1ApYbi4Zv89yS9mCpNFg68LOvPBBF5+oBeVzqq1HKDF7On6Pr4j52kD6XTu0gRo8/UpigTlrZRPdHXXdukr8GUCGcXTzdZV91Qnl0F4aIakvjooZEYlB2QEnSnVfAJwQ+z/Pg+fateOUpIEJ99lgIoIpdKaqQYEqXPbhLaEEkZdDME/9n+tSnLmbl3Cd6aAwZq8HmCIQimx3Y6zyTbOx4bPXZ0xUlhsDrUs/On8rP5Bj8Bj/IuT3vyuq/L+DPyMYX6b0g173FWigJ5kXdYELIayTsY75Mhqh8I8IEURIXlTGLOvdjyim1eMa+Xup5qG+b0DaM3Xkcxe8i6GoG0e9/XYQ6aezyCI8NseSX0avW1cMBThHsVTMNMLzkLC+MtddE+VOBQ3QvZw/w1QCkHQq3aeeZGFClCteMv2nmifJ23ixHXbiZKry/u2wXvns+7rsij0uwY7j5bmMg+xc7s00SQ9sKX7WcpjfMyFFB61jF8rNx9NHOjeoxAgCvLcwQRnjONjvAhA2bUR7J1CwOYARWMXWnFqAseKAHEW2piBZr1ftVcM90TQwU0pwLtHa3pRFLcPnldjLytDHVhNqus5tFrdst25qszFbTvadx8tUhU/Z2d08y7nVynPJbkdU19LMkMIvaexxc1jeh6WHhpr6F6LuLSBNpTxx7HW4/D2FXCdiAHJxUElwzWnfAD9zDmlmrsfxQQasDhFnkuH7Urvele+WxhlXeD9RvlsXtance2BHSMXWoYWAQCDhFg0yLxW1HFiaf9OT6gdxMeRF+vWUxGQq+Gd69OScC++9voV6b0EZd6HTSwv9xoHyE5vT8jNLFUmz1gT3UUa+bVWGBk2sl25EWqrwQ/ACnb5u3DdJPrXd9dbUk0O0TmEMFeG56WbMbmSI4OBMvzv3DC2rGf8bfGFur6grgwnvLLLzvwkFe3KZE2zTAOh7
 38snn/hn
 WlkMq/WDXeSXo5u+8fH9/23HTxvzhwLGl9x1tmXxyKf2PckzlmHz+kN7JMTcN9/RDlIgWV392niUwXPMmNMK9oxwhOWhA2lw9+Dwsl8Dtr4xjgO5qKHhnhSvbo4SpbcBcmfVD6pOp//pGI7Hu+UUrchdZCNOCWlzxYtyaFqnneeaXLwGunpgNg+5Jdf4AjpVtvns6iIiI7vpirxr4qlz4NySN9dw4Z8zdX3r0IAFG/yCNpECDP92hNx4fXAmzhFrYuVb5QBmqecgQOUEwZicGDRSvtLkRXb/rCwgjIqDfwSAvE59VABBV3l3/gYmCDo16J/es6CfyneBp+eKWWUWV5S+scpPgk1HbEq4ZjnLtOwW4z9Ir8vOT34n38V1YWu3oRQFTxhoHCuazz0kIktlOM2mJ2oQRaekPsTfWOdG9DFVXWG8lSkzi2Aa/uWAJKFJuK5gEFVDAufOacWCw0m6HXhgKLsUsG8z4gO79yXXh4mR/6uBm2BBNxpAmwQBkfQ14w+N05n9tfkq7sD1tzYnGRcq/JZeawFnTefCYXvPuurgQ85SaEBs44FN4WNDoDkoPeZhrfEXkOi/OyHe9X/rxOAbv15UfPeG1IdK8GSeR2NIDw2a7oXVaSaoQnZpMyspRd44O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 02:53, David Rientjes wrote:
> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of MM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> This is the first of three tests that measure the execution times of
> critical MM functions anticipated to be used by developers to measure the
> impact of any core changes that would end up causing workload performance
> issues.  Vmstats are embedded into MM hotpaths, so any regression can
> cause performance and scalability impact for users.  Google has carried
> these tests internally and kept them updated since Christoph posted them
> back in 2009 for this purpose.
> 
> This can also be used to detect regressions over time, from kernel
> version to kernel version, independent of development use cases.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Sample output:
>  KTAP version 1
>  1..1
>  KTAP version 1
>  # Subtest: vmstat
>  # module: vmstat_kunit
>       1..3
>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>       ok 1 vmstat_test_inc_dec_zone_page_state
>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>       ok 2 vmstat_test_interleaved_zone_page_state
>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>       ok 3 vmstat_test_count_vm_event
>  # vmstat: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3
>  ok 1 vmstat
> 
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

@Andrew, can you do the honors and queue this?

-- 
Cheers,

David

