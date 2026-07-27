Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFAEC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832E66B00D2; Mon, 27 Jul 2026 10:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AC86B00D4; Mon, 27 Jul 2026 10:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7201C6B00D5; Mon, 27 Jul 2026 10:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF696B00D2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:53:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B53048077E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:53:39 +0000 (UTC)
X-FDA: 85034850558.23.0DF6297
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF761140009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:53:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zgu9IHyw;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0I3AbznuXO2mE0TFpsCIg9z38N+5sXNAYMvOlNx8ss=;
	b=BFsBjgz9tVcFKaf+ugKrd1bbUvDlQe4ZVzZ+eLWwVEt99LNxsQR3wNAgVDgVY9v8SDdsai
	8RDJcH9Vi0cIpgGVJuXsxIUEGJtjxshNEitCE4Zm90m6SPP1UMQE2+ivEOwvVqOwfzHSh1
	QsxPjcikveFkgLomCyuoZqh5tQ4Fubc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zgu9IHyw;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785164018;
	b=mHlPMJkoJvo+KEbJg2hgOUffSA2T/uH6+AYfFx0ef6ueCHbEOxfbykDebM7oEAZz2fAdVZ
	hTHHa5+5qYZrRh9gbXNmdIVnE41lUlUn2nGirte++ZHV4vxjo42u35We9DGR/212IrLspe
	DInXieEfyzoATKaHrGOhM2K8Ohd6O4o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A4E1601ED;
	Mon, 27 Jul 2026 14:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516591F000E9;
	Mon, 27 Jul 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164017;
	bh=O0I3AbznuXO2mE0TFpsCIg9z38N+5sXNAYMvOlNx8ss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zgu9IHywQkl2KWenokXQBUF+jY0uFmmy17+h8GUQ5iFgZKLbCfdUzfpwqisSTfW5e
	 p6FG3cFXLjkkFIiqLgoasU5ILijpG8E0yBJ81Dd9IcEdsEwLGkuABt+S3DUykaoGG/
	 nw6SG+p/C0gxJjXFaUvl+h1m1/bpIGJias8e/PLtCM9J/IkAjtv0uL/p7i4zExwNYy
	 xZOjdtcCcqfB0p8Qxmjiu8Yw9ofWtG7PrUMdNqISlK1Y+GA7wQV7yZAOeey4pohl35
	 5MldWmxihWYvo4mcv3xTxeBkYnM4jZoy1DlD96sPOKpO12ADxz7VHiJwruDKAw1mLb
	 WTDJPWv9rugZg==
Message-ID: <ff769460-e6fa-43a4-8258-33abfe91c1b5@kernel.org>
Date: Mon, 27 Jul 2026 16:53:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 10/20] riscv: kvm: remove stack copy address of pXd
 in pXd_offset()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-10-d9e4bad31e0a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260722-dummy_ptxp3-v2-10-d9e4bad31e0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF761140009
X-Stat-Signature: gnx83ba6behx3sc4gsbh457wku5q8wx8
X-HE-Tag: 1785164017-892637
X-HE-Meta: U2FsdGVkX18f6rL1BxzlQ2Iu8sXSuGtMgb8ZG5aF3s7eMjXcm+Xc95p0+F6WbuFiPaUlo1fHY/0eqnTPxoYnjuvUWhOL+RN+EJciL2Ic/IRBVdMZ4YTfmgfEwUTKDZFg9BUn87SRvXwUchD3s5ZOyDxp3689NC4d6RNjga5mgPj9sHNgw6r+zP1aH9SErpQa/uwgW5+5RkDpgf6lrs8JlDr85Q0+lW9RPlSNoNtPue2Kf9BUX1oJraeT5yMDFYsPqkt9hlWcQIbSmhZ2m9/VbVfjrHnuKFSBS7SicBh66zf/C0FECx6QBqgF34o3fBQdJsxaHYbom4HwSdF5AQcSqaZzCGq2XyReAEdoYejCnzifMkrXuV07kkTcJOR087Jnkl9uKMS4NYKuOWmniIHT/xBFPpXVycTyzZ2AMOX3QgFc9CgP51dotxDyJgamvl23BssRwTq79oGBUQzyQ+Dgj09XlablQVTaSs08lbNOwWZasQhCjfNtGEPXavHQbp923ksIdWaO21hEJhPCR5lNoV8F5atfwKV0e/Agd8qsIaMafLTF6+jEo1DqzdI/Kao6zygDOyO6AbyZXZpGAWkKUw8IupDtkBj/+79zgDK8JiQWpPxjOUqpmi7tfvYpGMVrt8X7VCsFU18bti395GdhQx08NkI1g6hERNHiAZntcuBg+1jR0e53keafNHee7aeIQxM/9+tNTQXwjQ4O/r2cCzFAP09bXVlw5RKRIY21tQIU63SK9oezBvtSc9Zo4UpLuBXOOkCMm/hdqNDXFDGXg+JWifV/GU2Nqs2clUpum9FCp3+9d0q7hVN/DNGQHumepxhmAtzAg1VtUT6NGPbnQPx7Lrb5bvF9TwhApP49ONDYFwEZij9ajEe6qDiXjHUauvef+m+LMPgBB5NJFKNDnA5pfAFxEIHIPA/9sDcen9Gj+vqNejX1LLq06SYvOJ2Pj5709jOoLYD1XVIYar+
 +9rKXjmV
 Ep++XwLhVDJCKVnGYpknc+jpzSOsGjrRMhUL5kVbvLGqhLb3NtHmHMdZcZv4U2++P+FpGAg42rAQEIomvo9+stL+LlNiy79dUXfwmo3k83HcwnKUBO1WuE09x0dQsuEJY6LoDWql3VCmr8wtKzCIjFRxwNQJBjI4nKmNEs3nt+rSrMWrjRE6ieSRY5c3IC5eUcD69x1PtUdhpjLYsY/7CgWmnlj+943HIGlaZBaovI1NoAUVMbBZFGU1Mj6jjE3Qm0H28t4J3dj9wfq42bzJhgMpWnjXyOA5Fcg/y3azUnz4ptg8wQUv6CcqEVYaABNqTtHjWZ/iuLwnmwSiI/wvalSVCpBHwUr+XwDqj99t3iqvdpX9SkaMpoUkqrW0jzYr9JTSH8y5Shp4ijpxcOlKdHEmoizg7O7wKaONH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 17:30, Yeoreum Yun wrote:
> The behaviour of pXdp_get() will change with generic compile-time folded
> page tables. To prepare for that, rework get_hva_mapping_size() to avoid
> use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
> the folded entries value is ignored.
> 
> Replace direct uses of stack-based pXd values with pXd_offset_lockless()
> and there should be no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

