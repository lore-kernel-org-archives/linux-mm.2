Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E6A606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fyTFJvvg
Received: by kanga.kvack.org (Postfix)
	id 62B426B06DD; Tue, 27 Oct 2026 08:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBD86B06DF; Tue, 27 Oct 2026 08:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1596B06E0; Tue, 27 Oct 2026 08:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F06D6B06DD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:11:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8D2F1A0366
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:11:32 +0000 (UTC)
X-FDA: 85368291624.15.6366116
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A094720006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:11:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyTFJvvg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOOdVBp1yruXWIq0c9+0VPmPMq3Hl+/FoCSys8OoW54=;
	b=MSuMmcKOE+1H97JMicPC/rKyh4N/RcxNnPaTVFa6GpdAgwUhccmJOPWrmIJKI/YKhqSZ5w
	Grjc0I5IOh/R/tzFJXU+HtmM3BO8scYMKCaZl1cCGfn4SbiY220wO5twnZUK+7yJYcB5ei
	yFYiHnDu2uJvC/4Ocxo/g5y42ThNdso=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyTFJvvg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103090;
	b=YuX4gZfcKoAdrJ6gUnXTAVe5U4pKXod6AHNIsMKI13MCw+mKyKLYJYd8gw67wAUCihb2hd
	qfJhxACUiUAgqp3Brb37Qf8NuoRc194YkJ0LRsrmi4CyVF4ItKvvy/1mQY36fcEqCknBB1
	WknG1Rr1O2SXo5547lQ/d3VDQ0C6lhQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CDD960267;
	Tue, 27 Oct 2026 12:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E2D1F01829;
	Tue, 27 Oct 2026 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103090;
	bh=tOOdVBp1yruXWIq0c9+0VPmPMq3Hl+/FoCSys8OoW54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fyTFJvvgoHCUYXMj/IaoGifAuZRrpVVmRm0YWBR7SS8Z+rFiw32VaDiWZNzK+dpaA
	 WJ1Lq24I0FstYu9BVMQ2l7xaKdIseZxb3CQnUE+iZObnIRmtACAm0WoPX77OLmUSIH
	 19yfgfh8p+D/Ivyqrm+xNBOIaGJWBE4Vw0jE2HO1CWIH/Ft0puRpoceaanqUBG1qIC
	 cqEFyvvohjOmgAvPbjJ9xONg68UUot+Y2k1fiIDKLrukLORNCG4Z3ByAaDfH/aihjO
	 LIkJVMf1TXBUjuIEtjAGf+rRSuqrTliEXLtq7hwK28pgYXSi5sG47YOjGrNFx3O0Kc
	 fwZHXMV0fAYIQ==
Message-ID: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
Date: Tue, 27 Oct 2026 13:11:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A094720006
X-Stat-Signature: 8cyobph6t5w5nuhrt4473jixabt4ahid
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103091-850450
X-HE-Meta: U2FsdGVkX18LCl3raWpJx9X0iBAhl5sgShxnugWk7r7WmwxLkGWEmeDb4TTqf4adXg4FZ8VixYWsliMkAcSbQi5E6qsWlUCEomPh7pMNmZghPqw73bRSpMWKJhmQDGhVCmQ+I4XYKMBQYTk2Hu2RrjnPvDhBuVsqpffMoNavIm/Kr/WyE4xoV/xqR55JhYFK89/g930Lpy8aMGGadn4xLW/YJ0WJV2Gnwon6VybuQw/MDdaAOBvnmU8x9mmJPdlYQ2nyO6g0ddFX3wUmxyBzM/GtssPiA6vrBWb0pNF19i06p9Km5mV1PQnmpCupk3Ck1DuSQwQevResAXmwbOVlLkh9IOUPy8KO/CH7X0ZnmlUX/vueF1D6+ZAjGhy3lg1eEyfcMIw4zGIO2IlonsfoEZaZPNgHza7D09wIDAsA9orr3wVd9vRpW6/bWJCHXr/4vgqZnhwYfG+A3erwe51C0W/qF/lMihTzOWSqNYJqJNqgXguvUoFUoPZ66dg8IfNj3Q7/F5e/PrFjrX73P3+NVDEFiBj/fXrUSZp0Sr1oGdd2TJiy0oWqjh3swPdclAnGjWNK5jaooSwQzHb3gf5bcusEQCTWmTYqX9gA1utUI7+tNhQyXOt3y6OrixDz7sn4hXsN/J2i3TqLraGnF2Q/oenrpXFltq7krVBXfC4k1vAeUhbSClOwFQZrrOMprNsL2gq3UI6BEJUK6l33p4vjvWD1lnMf9MgmgGFahwELbFRetGAgR5LgQD2DkLgqxyIZGhQ6mYNkN4klQyFMKMYm2Jz99xwODHdp6SVhCHYgEp5FKw9qKNDHHzMqon8ddsH7yGV+zD6QIr2endVoXVBQzTcdtzncAO0fp+xEkiU/UNnnDDHINi6eX4aapgaJGczQ96tqJP7L6Xzu77jOLVyEXFmi/0LBRnIouXu/PlS5xmjn/86amZ9j9xku/ByFIWHZ6KKkzmSozh5TsJUXfZt
 bOLbhKw2
 yOSY3/mj2xopEgJGhNL8PhKQ2ZRZEvZtI50iYR/L75fESCSX+vnoAWISOrIOmFDZYhN1ngQT/5mCeOWMItc7K9rO2MVXG7qpevnQUvlxUWGbedVAXegmaetRo3+TfXcBzaso2Pj0oVuOTzmtq2cZgl7aQyMY7K+noDQKa2Jsc2lxSxLe22wbwUjDhYFYbETvGcdiiKdbC1ttSM+zHw6ErUZcYQJG6LMXw/Jfwiz33RCgPDs9UDtiumyozOqeTs1fxoxy9dGkkBxoIhf5dNsz6G/TsD4GBVfqKzoMUah3vvmJ1z4B2ZceITzOxO/CZH2DoVzCqdJTmy2EnZ+gDhW1eFh46mfqwH0VyWfMDOsqrQNfpUco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 12:38, Guilherme Giacomo Simoes wrote:
> when attempt to do a madvise in a chunk of memory allocated by mmap, the
> folio_split is called to split a portion of memory, and despite the path
> leads to pmd_mkinvalid() they do not clear the pmd and clearer wording,
> leading to a BUG_ON inside page_table_check_set() because the map count
> is more than 1.
> 
> Call the page_table_check_pmd_clear() inside pmdp_invalidate() generic
> function to ensure that the pmd will have they map count decrement.
> 

The subject + description is rather confusing: you are not "clearing the pmd",
you tell page-table-check that the PMD was cleared.

This is all about apge-table-check.

Can you post the actual kernel splat you ran into? Or is this generated by an LLM?

Thanks!

-- 
Cheers,

David

