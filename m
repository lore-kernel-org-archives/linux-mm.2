Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99270C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 19:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B51A6B008C; Fri, 31 Jul 2026 15:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365AA6B0092; Fri, 31 Jul 2026 15:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230196B0093; Fri, 31 Jul 2026 15:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76596B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:42:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C5AF140119
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:42:40 +0000 (UTC)
X-FDA: 85050094080.17.78C0641
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9E127100002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:42:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfUbe38D;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785526958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHUrZC9D8Kn+bVi1wuG4azv63ZYMN8Zw9sBm5TqI920=;
	b=eA8ELtBD8Nlg3z4UWZb49Ru6ia+7eSldUBhudp44ZgIc6lb1LnaESY0Qrj/7Ma8O0q0pns
	lkGiGlqXPfi3GzgSlOZvyKHrVQ/am3hrpTeh4jBxGslwtFIXcwEWK9H+F/QGfX6k6LLTzO
	I+sHM/N2iPu4SbTxTN8Klh0hKu68Wg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785526958;
	b=QeD3PlgUCDbQtVPTO6VdFqPuh2Lp7aQI0C0HJa8p7AegByRFGDYu+NER7am/RVJBVZcDwr
	u45X8WApkjDK45HrZJd17gcGMWQfD4YkmFL0/sEFeDsTswwNdpfvIjsidkQEGjV3WIb1Tq
	toPUbVqQGQGFFEg+oYEWVCxzwW/S+Bs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfUbe38D;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6F2C600C3;
	Fri, 31 Jul 2026 19:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB71F00AC4;
	Fri, 31 Jul 2026 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785526957;
	bh=gHUrZC9D8Kn+bVi1wuG4azv63ZYMN8Zw9sBm5TqI920=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EfUbe38DtH7SFrUQAqM6Jrl7hIwJKOxwcTOlKNlYA2uSAOSMzuZxcHucCdmvqw9q8
	 xRp4WytcjvjRdHPu+zbmJ/hOety6Tg7qVuaI44vc7ZuYEN8iOWr0P6mWuAHfFvLljN
	 q2yqC5NHlUXhFvLKaNgqw+Br1/G3nMuzdDql5LWzwRvm+0G1QRUCV14PkZYbWRIwm+
	 ciXJgDKVmkPIVkHSbcHuA5YNVViATek4/j7nzK44I+steGeKWLMPvnb/wFxvNLiyGC
	 WHDX3u6+JLlKKjhumcyMSIfNPCI6egJ95QLdXZ89SV44Q6LarOzo59zzg2+2MZax3L
	 3v/+yTlvTQaOQ==
Message-ID: <9363ef0c-df71-454c-9bea-71ba9b3ec8f4@kernel.org>
Date: Fri, 31 Jul 2026 21:42:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: correct init section annotations
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260731164758.1210668-1-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731164758.1210668-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5n1gc5g68tzdr3tas34g8qipfmizh4rx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E127100002
X-HE-Tag: 1785526958-808738
X-HE-Meta: U2FsdGVkX19pylAoO73cLNJhDaXeaQYDo35uIYfgnKwkLsPQx2lFPLYS/dauebx+5nSwpPdJNAYR7T4M8sd1UdnGhMFofUQD43NPFvR2oeEElK7HL5mH9H6uLVBPPkKUQKlU8CdTA6h9U0K+4FDnILja9K3ykuiiqQWuCanjgxzSPOiCW89xd0vPw8rHw0oy1zMnOeYCPniqRusfbCmdDqGgfEi/6QWcSMT27DXspBcxy6olYWTSDsli9Q9ZLwfVfhoQqAPNwu9Zi4QxtRA9eZhDCNo+JE9VKcat7uoHFLeANKsK4gGnzyBgqwSBwQ9VgcpUDLzIbgc7syQZ2xj2GGGfjkyFkJaWfnbgdzgU5ntvPMETFMC0plKnxYpRv1YEWIuIwBsxIrgmoXDUior3MiSRZipvfqfTvvVVrbYNUWmGZdm1Zss1EdfWegZDDsGDxDFjGJwjrAUtrslEz5337C64Dl0YLaAhm4WBb7yQUOu5gAHHY4l9Q8U4bJrE5AP8SKS1Sf52n5PoJ310aQXNkKyGaV6EmTo9SGDEq1oQPZcD7/gPHNY2ZCBDVl4gOQFc1GC1f6hRKL/jAtMmRvS+pvgPzZedRM27ElNKpRaTFXAdu6mQd2Yr7WndEVBXcDzV1QHdqj5b3JDS7+Yu5n23ZruZjSsFAf4Z5Fzk3LgAN2ZndcpLa93Pwk9Y35KO2lvLbHLzgjIh3MLiphKD+eJ4ZhfdneTQMud6YwPElq9RZMY2giz0ynk727nbN49/sZBNiKPL+yKisbRjWSRNeiM8MebwfgSHEBwDwm7zGewqWxJbSY6Pk0ZmXWPiuxddGXfTsLcy3aZhzNg2JV4hXn42FNDASP1Cg/l3NyzwU9YdUDeq4Sv01v6b6vW6Sl9mQxdL2s94Q2e9cB+jAz5CMqiHYVJn7TJrryZ0+6/2ubslo8t8gTpCyqkTCyn1+0g1eRin20WmiPvkZ5+BMdcTmMk
 BbR5joKZ
 MATcWibLE3y5ggT8+uzVBe7NbGDLch6sVM//ksK/RSFykhmdAsmW8CKhWnM3esfdKMwfu0WEv1buCvTAyWE6GPlCp5XWCGuoR/Zn32DKytA3bkMkPhzQVQj+VnDTN1lX4En1BELEkMswPDJZcL6hJYLrnDjsUgBnJnXnOoGS3qyaVvw1gMnbhTnC1koNVtMxIG5xJsgiPXKPoKweKokX+/RdaYcddypbYyx3frHtPFOR8karGVWgeJFvt0ytk7SFn9jSkqoh1ESQNsxXQh/7rjkMtz4Vfu6matGaUtF1KSWnWaV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:47, Sang-Heon Jeon wrote:
> The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation
> but the SPARSEMEM_EXTREME variant is __meminit. So mark the stub
> __meminit too.
> 
> mminit_validate_memmodel_limits() is only called by memory_present(),
> which is __init. So mark it __init.
> 
> sparse_usagebuf and sparse_usagebuf_end are only used by
> sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
> which are all __init. So mark them __initdata.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

