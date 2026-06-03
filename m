Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F140CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15DC6B0088; Wed,  3 Jun 2026 06:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDA36B008A; Wed,  3 Jun 2026 06:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903476B008C; Wed,  3 Jun 2026 06:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 823566B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:00:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BD651A029D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:00:58 +0000 (UTC)
X-FDA: 84838157796.14.BE845DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 315A140007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:00:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML4vg+Og;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRdMcuu42g8NujGeqFbFyl8BzMHa5wjh/TcLvEawNqo=;
	b=ty2eGpUCdoPstI+QotfgoolY+eb4FXi+GSyLK9dz5N8pgRoYTnOLOzpxhn8AeC/UVoJF1V
	XacJ9IXS+F31cfd2lFHwZW80mmDUBpq8FsweRF/+81UYbRpIf6y5f7on+4qaC8Of17GZGc
	e7pez0+LoxrnKAZuwIp/0eIsKSBvhY0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML4vg+Og;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480856;
	b=8lFmwWC5MfAjx4KXbIV0mnlL4MmPF9PmMMDIpwd3doOsXW3qwPBPDfmlzs5CmWloVQ22bh
	HmaZzryEnAgQMValXCZjZbfpJ80YZfUF6l3HcwAndG+aRFzBSX/AL063rvWovy9XbfJZeA
	5mCIqlVadszUjOT2vmEQvGoaH/vnN/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45292408CA;
	Wed,  3 Jun 2026 10:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E421F00893;
	Wed,  3 Jun 2026 10:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780480855;
	bh=hRdMcuu42g8NujGeqFbFyl8BzMHa5wjh/TcLvEawNqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ML4vg+Og81CMlnLPvxVs5MrQVqYveAx2EOfh/vz8+WH982gQ4cOdmExulhZkEyb67
	 6sYPKIdUJXww6AoSUjAUgQd/9avs6hnBswbwhx/7EzRLDIvAM+lHf08TjVoCiV3oWK
	 yyQSxT4rvZtEjS+XxRxCeEkyCHZ6S63bVV+pkXEWa7NH0F4SKWDhp3I9ni1RRt1r4m
	 BVIw1ytGmJ5EmW5Yk+6DvmTGpobmnvrK3208l74upJzInwN1UYlrdzL5davJqxGkff
	 IxrNmd7mlABoVWjVz/0q4tzReon4fotvSoaJiG0O4zizGDgUktuYyUPmKwbwUNK6cE
	 k8ciaPyNs/YfQ==
Message-ID: <ef5c470f-3c32-418d-9566-17ec01b691bb@kernel.org>
Date: Wed, 3 Jun 2026 12:00:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com, Usama Arif <usama.arif@linux.dev>, usamaarif642@gmail.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
 <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
 <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fuxhfar9437n39xacryipzsesrcswxif
X-Rspamd-Queue-Id: 315A140007
X-HE-Tag: 1780480855-39922
X-HE-Meta: U2FsdGVkX1/SZXPGjFWzVeuvn457x5xm0sGNimk2SfR3OaeROMdEUEm1IT7kpd8hyEV2JELeGSCJnQSINcm/u6CzeTcKhMJCI1tnc/6r6s4i6udAtAgXH1hPqXtQHk1Jj+4gJ/W2nqdajdjVTKfhjYdV1nNSZwX6XhWhjr3INuzl8X39UVKk2jFUpESL6ZpXf6wzD/D64yEn1jHcOjalG6x0l+n/qeRoMn9qq4fho0AOxDUf0MhzYdBan5+mxjwCvczvP3qwBUVLPhcRtPq6dKAJ6xGWTdeOPyfeb3s1MILmtSZTy8vmh9/87JzE5SgKoTNMB3gaYuwLUeofWhVjUogec1FtPz29dZzIpNTg4RgSsVn/FHAjS8CEGFOGOOlzS7eEA05X5OQt0R68AYZy50EUHXA5+Xuk381VYHbrzcmipG0Q7OmnzvE2kPpT+aeXYCNVtoVA1TR7rs+4ewiOVuBuvbUI7xg9+YFv4eYVswxqZQMWcDFAyCh0dMDvYD0OpeUAhHw3t9hhpC2t41oldmlMMKmbCSyj8RyjZ6R3eWSySns+Gd6TCZOJcNA6wRCivzUu79dV05Z5hyz4mfU0k+JKWurh3IAShQZRBvW1VHJvI+KUENnH7CAtT/eGA6o3x053wpLp1qkRFKB5o3O6ZHiLR2egIs4AL6xMolp0+a2kkHPfjRn3PGMMYP+mStw8jqKbnYak3ge9pkCZ1FYaNWwB8p7zTGVUCTUj73rB8iHP+YDPWp0rcCrr9lRSENctqqNTimjGKmPIGrOScVU3CBNHIeoUdz/cIuaGpyGYG6u5M5wIpHZeh2RNZLvGcMQ8okkLNqYmDsi2H+TANMfrmrGNTu9asO/VdahoUgJ+rsjK4C7N0hyUo8VXlmhHDHhYMSyLE5h33cOu3FDfguYQ6dsrT5eIeRxNpl66f4a0WfZfOqpf382t+IAcHyCAWUXRvoSDyNLvUgX1EKpFDlW
 e/7sdiWx
 ptI9uR7ca03JEw9XLgELWh8Om91MSnHgb7zHbiSX0PzcPe5zTk4QJJh+AvlY4+HK2cUS1PME2umXU5SZD5Zo9CvwDpwKWGM9oflLt8B2s3avsmzXcuy+grMJZ8wqAQTOa3MbheB6YOVgfLAIpGVdg1jtcqTj1nOMA0XeIpDp9tZY7gEUmGCTJ3MVuEAMfgUhKgfKis+72kVVtmKt4MiKXCxDdcEeUinO+V/vg/3WJguO81saCcmdawXfDZr+tgvr4RK9T51y49A9f83GHJpGqw2i4ZYIJ1mTRs/NCGC3fQVcReAQgQN7v0qdbm+QyPjD5l1MRIKLBZtRVmew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  next_order:
> -		if ((BIT(order) - 1) & enabled_orders) {
> -			const u8 next_order = order - 1;
> -			const u16 mid_offset = offset + (nr_ptes / 2);
> -
> -			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
> -						 next_order);
> -			collapse_mthp_stack_push(cc, &stack_size, offset,
> -						 next_order);
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> +			(BIT(order) - 1) & enabled_orders) {

Why not a test_bit() ?


But, wouldn't you want to skip orders that are not enabled and try with the next
smaller one in any case before you advance the offset?

-- 
Cheers,

David

