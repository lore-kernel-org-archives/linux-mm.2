Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90C0C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D6C6B0092; Thu, 27 Aug 2026 07:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915866B0095; Thu, 27 Aug 2026 07:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C4F6B0096; Thu, 27 Aug 2026 07:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5732D6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:08:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D102B1603CE
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:08:32 +0000 (UTC)
X-FDA: 85146776064.27.62F50E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 246F7C0011
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:08:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/cKQ6g/";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828911;
	b=zW4d4Toi5vpJsKiZfLs0Lgi1G0FvxYTC3aY9TZ9Hk5S3vRqowgt3zu9s1XIxE949H/lYV4
	g9hI25NhDN1HtdYB6+ptn6UMfE8HyhvikoqCOwdyvW/3vjwIW44SWFhVXWNXxtQVyxLXJP
	Pgd1QcG6iu6Y2ZWKZH7mETw3jZxcYUo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/cKQ6g/";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x0zBWdMtgqZiQur8SMfQr/RwwtWwQSC5GfZhLiryLQ=;
	b=0obk4/eqYsKMcgRbOrFTTl97em47ylI/+AxN4/bKiQZatR4CEcLG5g1s0uNq6ZUkCRF3n9
	SRqYXBF7K3UWREijr4U4krdEim8XTLuKkqOTYkdZqzuGgr7tKruyMowXD01YUusIsb7/jK
	j+UqI00ri6UvMzMrK+96aZJDvN6ZYwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 611D1600D3;
	Thu, 27 Aug 2026 11:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A61F000E9;
	Thu, 27 Aug 2026 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787828910;
	bh=1x0zBWdMtgqZiQur8SMfQr/RwwtWwQSC5GfZhLiryLQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q/cKQ6g/TLt2dqqMpsGuq4/xHZqR0cRp812aS7hA6QfuKfmqgPUfUEGoaLLYDZZSP
	 Mnwc9dN0Fa4TBFOATCyM5pjkeuce0Ze+S5aZwmujhkdFGXeY0sVALZBN/qsnxUC6U7
	 KIsJCoTQrzzE1GLC/6MtPhl2YgjQqcIlWKWsUQdfucgVgLS2JDA9Q9LXNDNs9BzCqC
	 oYvSwn3BKOaIrBbwftXxpOfNhz1n0pJNLtDOkDPGuYHtFc1KaopfCiw8UtG7ernwwz
	 y8BdEGIWDRT7DkM0z3vpvaLrmHg1lgcJdOfb4vuxdkud813Qa1MaFqyL9GgP0N3UPQ
	 KZWhg2/Ca3zcQ==
Message-ID: <21329b69-1a58-4b3e-918b-26753a961339@kernel.org>
Date: Thu, 27 Aug 2026 13:08:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] riscv: mm: Flush vmemmap TLB after sparse_init()
To: Yaxing Guo <guoyaxing@bosc.ac.cn>, Paul Walmsley <pjw@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Zhizun Wang <anzoso@outlook.com>
References: <20260827073603.141426-1-guoyaxing@bosc.ac.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827073603.141426-1-guoyaxing@bosc.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 246F7C0011
X-Stat-Signature: zxbfkhht75idf7k51ao6ht7tb79tcutf
X-Rspam-User: 
X-HE-Tag: 1787828911-244902
X-HE-Meta: U2FsdGVkX19YzeqTTXv/qV8bzqX1Tpu9uMWJjqBWm+GMJtXzVCs9u3QRNuASdlavYJzzmlrWtN//ZG04CmfvBZ08TkN/bxcNzV+WRJM/dhlwqjdcmQaQdnGrSt+WyNqQJD5vFulAbRCftIfKQfG719p+49XI7I7H4sXHHnywRA2M9AOqOQWV+h+YNgq2k41ssveuul8YtZ4+cP30CFIsRdNyeiGreTDbgE1aqc768sVNXkscZcp6W3bK1wN4AdrfqduPo8lJurGx98ElnXu6C2aRspyPZ+WdwBA5JUJ2NG1X3r4qtjeStfwLh6qoRNvObocmKtkmHylfuRmM5JemNdTE/wGqyx/upGNlFA01QYPg1N0pgZ/W1nE31mHUj9yqy6O180j3c5HiEwio27KXxecWhqobrmfoWWVkst4gR6MvshUIEW6Rc+X6U4loSWqSRP51n1exantpRpmnvrHe7qh96kohV9QL5vS32rcvo27qZpZDoDqApGjaxzfQ81HTaRzWyZ2L334LtSnRoCw5lqDiZAUiD4lui0JJcokLmwbLbpEkMX9kwtDyi4Fl8fvGCAvCN5xDwJRbxHJNOXcJHiBPY9hR2ytJYkWKQrkcw4FWhEAZsh0BEbMsq9YqQOrMBhGAPwylyjo6/Fa6cIAPTObeE3g2nRr67xzPBsUaeXXXG4WmHqQV6kFkD4sBBc6TLvk9Brlbbp9Zu25Q0TvZA6y3vykUetIKoTXzOM0gnDDQLsrUXbBdAJqcE2eYYJzYXgRedmcgTSwFeEVaMqNAwbdSBOA3KoZnnNwKUuocJQXNdC+gu4Ez1GRiSPcch4hBJbDZz3cRshVZ5Bq5u+mJh/uojv2V0afCmK1RtD7LNhpJmtpGh2VycYmtoBM6SyOpaVWk/+x+zgzq/xjZU0Wwj9Vcg4QeFWXmBR4aoAD/zZh68FX+htCanukaJY292XwXBR03OifnWy2pd5v3dM7
 ysKEZYJt
 N5TufmAu6BP20ZkL90yN3s0vg31iN3AxEX396piefqsq4i9wOLfeI0BMpcZk9d32vnjqzlsDFn0N3xX3O1JAfpVxdmP71zmxu6iKn0LFeCkPCMyAtel/Xv/CdlSBJHFw7waWsTKR5kUqxGJ43O3oAhsE+CLLTay6/6zoOxnbjPDzBfs29XKqvqYpYxeacJKmUHq/RIdQEfWp0Efp6ra+KLz5MXYTR0Kh1R3VBgpaKV0/yvbtPEUTov9lZ1MBxyy4KucxQ8C4aMFysFPiXF3XsdeTHjEahFmPDoX/G7k7N8Qon8u9/cZEeTv+qGReNB7CyfhYlWY3Af0tmqmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 09:36, Yaxing Guo wrote:
> Commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE
> memory model") moved sparse_init() from RISC-V arch setup code into
> free_area_init(), but left the RISC-V VMEMMAP TLB flush in
> misc_mem_init(). RISC-V now flushes the VMEMMAP range before
> sparse_init() populates the vmemmap page tables.
> 
> RISC-V supports caching non-present entries in the TLB. If a hart cached
> a non-present translation for the VMEMMAP range, installing the vmemmap
> page-table entries is not guaranteed to be observed until an sfence.vma
> invalidates the stale entry. The first access to the corresponding
> struct page during memmap initialization can then hit the old non-present
> entry.
> 
> Call an arch hook at the end of sparse_init(), after the boot-time
> vmemmap population has completed.

If it's a vmemmap thing, it should go into the vmemmap machinery, not slapped
into sparse.c.

Why can't the proposed vmemmap_populate_finalize() [1] cleanly take care of that?

[1]
https://lore.kernel.org/linux-riscv/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn/

(independent of that, I really don't enjoy the suggested callback name)

-- 
Cheers,

David

