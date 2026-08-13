Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D346C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162C06B0516; Thu, 13 Aug 2026 11:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139F26B0517; Thu, 13 Aug 2026 11:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077236B0518; Thu, 13 Aug 2026 11:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAF036B0516
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:03:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47443C01C2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:52 +0000 (UTC)
X-FDA: 85096565904.12.7FD1639
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8E27BA0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GmCJqe/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=195pJpJg9JhscZJnJd0magMDqpiCbW2vvWLEm7sAFO4=;
	b=xnBQk3pWzEx09XMMYid+T7ZN53LhSNT8Xfw2I9F2QBpQUzPYwC0LwuKJR3dvz3JYrilFNS
	GKxogKBQSqGU/VpliwqxhjBK6WKBkfgDscIdGX1Vnh3UopHVVMUkOMYKz+KNX6qGIW8VR3
	9RUE1SYgCK6Le6/rXUJogEmOYF5g0LM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GmCJqe/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633430;
	b=ScRPQ3jT4xFa7XgiI7Kp2TTEjogUCiCyAjXFDdvsBkMYptLB1+3NbYrOugxcVBhzpMwQAs
	NTngCQNUIEFcZrH0UACPZ1vrXmjKMEwSjrAmn0IRcl9xRr5KrNovLUB8IkcR0DFEGdlOsS
	mZw7+HWWlRyTK9RQHsocuqJao+wXpB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E99A43A32;
	Thu, 13 Aug 2026 15:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097DD1F000E9;
	Thu, 13 Aug 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633429;
	bh=195pJpJg9JhscZJnJd0magMDqpiCbW2vvWLEm7sAFO4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GmCJqe/WLP6qsb0jrkR6huKEgxPo+cT/yHXHgYAVzEZb9n1YJcfKTckYuHqQxuGF5
	 fWCKbV9ej1kNlOg0bJe5uoCbOnB3Hvy9Outs3KRIDyY6wtpIjZLDIfxv1mdsxnI8tA
	 z9lBZ2Qr8TLDIbNef9C4kPUymwYXlqxuvIutiUIKeMVOPmij+7gRC2oBxB0SkN8CCq
	 yKrRi2/U1Co42evg927kH9E7+V7KpkdhARxYwAVr3Zqzcq1qcRSlFsz6amOUqM1zYq
	 v5ybn7OOccsIhjUzsk0SW9QVdJostmRsWpZyM2DU8JqKiK55wFYXrErz5ech7+4U37
	 IRbPTRriI09pA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/18] selftests/mm: skip collapse_compound_extreme
 where the PMD is too large
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260812132304.199287-3-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-3-kirill@shutemov.name>
Date: Thu, 13 Aug 2026 18:03:34 +0300
Message-Id: <178663341429.2230969.2263069830914903834.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 8E27BA0008
X-Stat-Signature: tdhb4hmbh7sgk3cem65hcchcbhmkwfzb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786633430-429408
X-HE-Meta: U2FsdGVkX1+IxC2DU984Jp9IKQ+PD3JqrI8KHpzhKdWEvje2MzUc36WwkufYxz92MCUktyvwsokMH8COMxBmCQRo1c6N/zy+z2fPVslhYyuWAJqjyZ0aWLpTI5plkx4a2BG3ipFjNnxhLjkvz4A5Lr8TCjdGXDck6RDlf+vwtfw+o713i6Rd+jeygd5+Db6z5ZHl5ZCPhF2FZJkEhLq+BoE2uWv/HSsfaPxv+0FIRHdUS5KvMm5pPCz+VaGSrmzr3FV8RbpUEIb6+Wval8Sit7CHO9DnGtEhsYXdKJlxvovi/3RMp9lX7j9F8IMu3bOo7C+otLNnfD6+hCffDTasXQSFBadt7hAkB3/foUJZjNIiix0SzqxP76dZEmWsNrMeTenHiMsqod4n4Li5QHT82ggZBXRQTv+bNsDHLMuZtw1DQqhhO/20lKshGAmsape7fcFMVSY9ZZ93inyFr+n4f7UnzLPvwh0K+LkAFzAic2f/MmT4GnfvoyvklqWF3qP2rfqWs/eGsH085RiFco+1rxXrZQWPcrSVF3Nm4J1+2Cx1IhNFZZ5ykPSW6H53S69+AVAeHQ/sPRNq6K9eWbRnWH8TxhJGi8DebIgya9WI7zUlcqIA5pchBN6JBmlolSqwB4NMtci+IF7kCsEozVmIPjp/7yOTb8bu78aOCQRkTbSkuXNYkq0Gs5ouL3WcqtuoHn1FQbtH/KU2fU/QPkSiPVNuOZjWpCZz0saYNUJtORS/BFGYfKAZyMSnfpI2GkPFWO/7FW6dXOeIrTL8L+omZssFd4AF7f8M2HNkyNw5p0djsu6YkLurlwdTBTXvV2J1Mj8w0ReStzI9t2JK31ylGF3R2/e6pyYgoX0bh6axH6kG0cQNly4zaKCdFVGvSVIR2Gx1qvzGVF7x6B127sxxuyACZdF2uLUcb5LjkHfWIH2IUg61RCX0Znutoo18O28i7rjs1MkjLCPWPQ1GfEA
 ZidPNcR3
 9VeDSZZRU9/xWuvdb2F2txkP4pH+q5FANOvsP2HXPr7b7hrDAPF36eIi1/K62TJIFy3TNZ/Tt4WiTV+XhktKuQ2SioKOXX+U+m7xasQxJw3IOkeRXx+avJF0KCipH5gMpBYCjALWa3E/5CFRqhno6ze3Hh2vm84tv6cMmhlGcXfHWq3xkHWL7no7Q3YuwJXXQwAOJANKXXyhBO3s9UTLDcdMCNgCc8WV8YjXKBc3Lgnil2s8XZfQ7j6OtJmZrhnl+YUcMAasn4Gk5wczfpbKfQzgEPUxAWpqoa9R/2wTEWU9ymCYK+TTK0MV7Jn0ZvOdQXhN1MGxVACQqCZDMZhZvVfinxQOsluzQJd/y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> collapse_compound_extreme builds a PTE table full of distinct PTE-mapped

Nit: we usually add brakets to function names :)

> compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> at a 2M PMD (4K base pages) or a 32M one (16K), but a 512M PMD -- arm64
> with 64K base pages -- makes each of those an order-13 allocation, which
> the allocator cannot reliably hand out even once, let alone 8192 times.
> 
> The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> whole binary stops and every case after it is lost.
> 
> Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> still cover PMD-order collapse on those configurations, and 4K and 16K
> PMDs are unaffected.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 018b0698229c..48eb74c255f6 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -974,6 +974,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  	void *p;
>  	int i;
>  
> +	/*
> +	 * The test needs hpage_pmd_nr PMD-order allocations, which is likely to
> +	 * fail for large PMD sizes.  Skip if the PMD size is over 32M.
> +	 */
> +	if (hpage_pmd_size > (32UL << 20)) {
> +		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
> +				      __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
>  	for (i = 0; i < hpage_pmd_nr; i++) {

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


