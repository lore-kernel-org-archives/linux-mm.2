Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672CCCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA91A6B037B; Mon,  1 Jun 2026 08:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C598B6B037D; Mon,  1 Jun 2026 08:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F356B037E; Mon,  1 Jun 2026 08:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5D856B037B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:25:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FB4E12067B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:17 +0000 (UTC)
X-FDA: 84831263874.27.EE924B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 958271C000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaGrIm3b;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYcQT8q/6pcHDijPFpn7Zqm8UKJHm8ARfSL5dPPFUZg=;
	b=KkF0hfrpwBM4/0NJ1eDjBUx9O7NeSa8sQklO/F2aPl1s6WWFj/Fo2MbPpyVZh5Mwls0DBw
	tKOA+IF60U91qrNmhvsAn21tZHDifb2dG1z7o5d17hFj6P/dZZ4Qe1BdrBjmrC+ZAFV1jj
	3q5UV4JdlJYCOhn/le1m0GjeR1LN8mI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316715; a=rsa-sha256;
	cv=none;
	b=7M4PO4M8qopOL74XONsA+o/0Cs0vNyE8NBCiLCI1c/5iceceDuUoevOmcg5R+S6llW7aDi
	o5T0bmEB2m9gsovlrLJfn+CLhiwWTU2t5MmYcxl8zP/QnrXxj4RH40k6OSOL/Yll+C5i40
	8dE9S9PNaTpORa6pNnlyq8ck2Dl4mn0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaGrIm3b;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11D9D6001A;
	Mon,  1 Jun 2026 12:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5FC1F00893;
	Mon,  1 Jun 2026 12:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316714;
	bh=cYcQT8q/6pcHDijPFpn7Zqm8UKJHm8ARfSL5dPPFUZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RaGrIm3b37zExCbGvnLit9YPbCbouimlSert890a/KWdlqDOMPAzzGhWIDyy+iXNW
	 iQDuvjZwtTlNrECIrU+MzDI+wl73RBYmXFT0IdHeuZLJs95SUEXUMoTy/y0b7SZBgr
	 M+spxd9nWdqFKjdRrIINWoqjwaMwX0FJ1S02FZt0gJ8wzQVd5RiSByOkcr6bmaD2ti
	 Tip6dhSUWkdGITuWSg/IWj9e4tB1ItEu/mIzMghUODRITxqHgbDbGrN7t7KjLocMk5
	 haNINr8CIPKM3LJ7jbia1lh/IfJdbRaKrQJ18BnluCjEukmdNM+78elr5Y59+Nz3Xb
	 gkZE3Y19L54qw==
Message-ID: <61f0dae7-4e49-4142-8b0d-10c175856277@kernel.org>
Date: Mon, 1 Jun 2026 14:25:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] sparc/mm: drop vmemmap_check_pmd helper and use
 generic code
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-6-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601084845.3792171-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 958271C000D
X-Stat-Signature: c97u7skzys1rj6jytw55rh89k8ku3hww
X-Rspamd-Server: rspam06
X-HE-Tag: 1780316715-555655
X-HE-Meta: U2FsdGVkX1+YnHtWGpxGlkAnXXckbXitANPmnQi3sNxaU8i8+4CNeVF0ujWePMrMOdy0MIBfSCsLGefKBogXwIvppRuD9SoXRp/HSgZLQ1HlRdW33fCOGzGHc67bFs7lwdTXM+ncXT5WJxPCfYkms1ccVvdsRDO4afAygZO8RlYig0RtZuzQttBe5Y8xsxDY7XN6Q1hR7dpraGzoK+JMAV6MqJ0Waia17ZKlZuPLuzVK4d780ws6/oMvQF9lt0CfhvbXBHURw2pnbpWr5O6zqDARP5luzWh5zJzdruwOT77Uto7C2VslgIG2V8dT6L1nLWkddMc3wJcXmUMAH+GPy+Th75tQ7R5qoeYuhC9ljUVB4zftC9E0h09owVbIkirK+FDrdR/92KEBUOmB1Gfq7CjDSXQSFfckdM3rM2zCWtlC6VO63En+dBQKQq31B42PyXQ6mAKDg5WVY/SYkbHBWpfnif9ZqUZppPtja5Kfc3LN2Ffj+OO/AwoD3bqcO2ba9txLXTrVrcmlAr9VxHHkFYEVpcehJHzXazLzEc5GxAvcdYmz4yx4PF8fyT7NXsFTnAvCn3pKWfu2TUmelIyBlLDyvg79CgGbRixrTlZTL+bEHY7ZwHmG0jJe++hU4z8sg7floDUaz+vL5t1titawgQFSBIbnMp6Dfx1Rye5SfWhsk2lZnn7Cuf74JzI3qt3L1GbsJO5SpijSyWvkepVVeHzTQIu5sjsw1+feD1fSeziGTQtqdD1ulo9e11eALuWaLjvjTYRKVmFwa4sTKGIwCNWvvwl5bVhCaq9uDfLkjH0/O6r+RvN9y6REsEZ01r75WMh6Es5Oj8k68/dP3a31A69RiT2uUX977BGG/3m/sMKtPfEaBsQoaS2OXzouy9xjN8mRn0kGFgj6LFzZ0auJtg3+Zn/58vWsF9e3rtd6xps8zWBa5VBFgKDEml/prpqcoxpBlzmVX3HQhhHo0nf
 OAt305Di
 kb/aS4aylvGUf+r11aWYA/UuHLCsD0tDAnGCTrFDkln4APzIHQqH0fkKEartLOjyToVjQpmNRbXpqx7Hu76iYgyD/vjICgGvA18bRtCj2KC3mjdMjUR1OFgNbMD+x2kbpJHDVFTAQV4WyDKarj9vVWr0JDdTT32y4LCKaD4HE3tNQVfBKUJardQBjpzndgsYUki2M7ve7BIi/8fVI26XcSMkG1Oc0HsTBlrA/mmoCTMilj3zbG9NAXEytc1g4QMduRp3eVGysLLdC0tEX7q3EgDbi5TZkWC7Itwfk87KGHD8y8xmY7DZ3h02bEZnqpgmss25MOlDtUozsIz9rkuwnXvDALIEF65Yt+K/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:48, Muchun Song wrote:
> The generic implementations now suffice; remove the sparc copies.

"copy"

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

