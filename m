Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10224CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701776B0373; Mon,  1 Jun 2026 08:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8616B0375; Mon,  1 Jun 2026 08:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEF36B0376; Mon,  1 Jun 2026 08:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF636B0373
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:23:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E55BB120682
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:23:02 +0000 (UTC)
X-FDA: 84831258204.14.63FBBC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 200C540005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:23:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HZ3/nOyb";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316581; a=rsa-sha256;
	cv=none;
	b=U0doBNNysmC1oY2OraepAaV4keNoy/0MAPeX7bxhSUfwOoTNPMJQMSt33knUV37uzdzSwh
	D5qMujiD0thar6anvLxRtD2gp+D0uj7f40n71240l0QccpvM8murmIzQ23b1ckASnjqK5B
	lfNZEOeKS56dIFUoiFWuSeuHaitOwL4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HZ3/nOyb";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HJYM3dNzF5LORInRRkOcTckUxVkdRL/1E6g7brQZRI=;
	b=JxGCUkl6I1NYEhb5RAB0/zZMGwLKRag0p+l1EHvrvy3zMIwVNBBpt8h1hvHnFJD3u+iid9
	9H0ekjxLU4wBM5bWjKBaSmsE47H2fBuTVzgRbgrTT7nXhL3j0ImaK00XwcSX47fzedBKQN
	tLHphC8hPK9U17+ndvcpue2GoA6bROc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22FDD43730;
	Mon,  1 Jun 2026 12:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0ED1F00898;
	Mon,  1 Jun 2026 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316580;
	bh=2HJYM3dNzF5LORInRRkOcTckUxVkdRL/1E6g7brQZRI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HZ3/nOybNpQqn0VWCdJ2o/JEoKM5S5V32oi7n7pgsEbQHunMGrVGX/HLFHrTnWLHp
	 TH9t7N53LRFcLDUhY1wmjXCVr8VKlLfC8xgVuIgm1WZFJaBNVv1/BcyuAT4tV4dBut
	 d98zL8IwhBmWtTeTTBtXvqk9h+9KCqHW2PSEibV5EYrzX4NiM5zFe/etvUptu1g+G6
	 ZoDvZDh01VdKnmb62ATtqUPMivusVohx2G34SOXtciUYaYP1iwy21J8kTDyUMaVahX
	 i2ra0fXDTeknDXQ2P+LrkhpdhouEW/Bg2iz3DC7RdrI/LHEcSiyBw2ju1w08pXaLDy
	 4BVj1LSte2+dA==
Message-ID: <db8d440d-c8a1-4f77-b5d9-00bab8737f12@kernel.org>
Date: Mon, 1 Jun 2026 14:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
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
 <20260601084845.3792171-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601084845.3792171-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 200C540005
X-Rspamd-Server: rspam03
X-Stat-Signature: ghbb6tosjykwm3crurj4xwajfhwseg7a
X-HE-Tag: 1780316580-925860
X-HE-Meta: U2FsdGVkX1/B8YbeQrS09RLugvAjQqBDA1zIpb58oteSMb+KZvDu1j5NWGHjGM2GjVOB2b9+P2t3+JEie3XPbEntj0QKJWcvZ2WJpzprIU2AcLlgp1Aek01gK+5OCH92KKx8N7wlubXOEO4HSGLfgevqI4fC5eTOJeTn7rveBywat6Pweu0C4SfNhn49n3iErOn4ZSaAkQarlS1MztpVDMm9o8pN9RVcPkEWm7mmE1q1jJmrjUB73NkwXWKldazSTkIx++GHcGA0mIAFdpmWw5N0zsJ40psm0hVfG3ZXZUN2T4UVI05KUHN8zBZdy+/TpFk6vO5t0ca9NEcyNLl1YtBxBXfRSuiVDKvh4wcyzlWyRmpfxaFJmYUmuFiPinR7ZYH2HedV79eIeOmIDuDKoG+TPrfsSL6K+4jpbcot7+8s75/EQly4rf6WyVqzYNS3yw8+uMgCvMiSVANZllvcpR/YDKOfhuH4g5PJOK3QylfecKB50o2hZ1B4/08u2/CO3pRcbISE+luRVqwg9IVqZ0g1w7T53sJ419S6Y+VCl9IvC3oIgjuy64+0Q980thv8uh2xcx6qxv8yOJgqDeyyMMXoQzBA4MltCeZaq1oZ1ifnpVisNHkrwnM528Z4swcTJJZRxqkag9yTh05RGyLATeQyq3Rgcm/7xnpsD4O2bL4kWHG0wbOD8xr+ssoqWZiAytgMcfqn/RgrlHx5rd41lT7NAb/r563lrjDD4OyTETdrrdyXUi+GwNro894zeiRvMtuS261xhd6749Zh8TyAvPsvfiw0+Y4VEIiTP2BffAfhwwHcWvsO5+k3uiNyD+jWIhI/isre1sJMmP5e5QazpF6lJLXBLbc3gx5pK3awfvY/Zuf2YhQYt7ks/+dNzrUETP5+yKhIDPjlJowUNmNmGAvvUwD9Iz6nTSNVD6lrrA9fZV8Y/1HkqGM1h4WXjTVMpjrIUp2vCTlWhBLpjhY
 jrku+59a
 ELL1Rv0d5n+L99+S7fcZlo0Qiwc/WT9D4k0iesO+aeQsQdlKBSezZgf5Pd4CgpEOeXF/DkR3ygZwo0ygppB1KYoRGUWTlpIVoX2n0Mm0poKmuSy1nepL7bMKqb4EPM+y3ylE3GQAVgDPvMVMiMt3v4hthY/T4/idiipkyVhxlrQ7rCk93jfmOkwWJAowd8gVSD7pmlLzII7bDPJ72zUX7ttpbQ2ctShrj8PAA5NPFwDB+iknt/juxYp8HC4E04yRmiSjtYCdcs7kyNCwRHABzO3h6QiexOgg5yS74LnNV0sUgkKnkLg/tZZ4RGa+N+GzbOExhd85oHZV7NBInjlAB0WA96vBYJY18Gxi2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:48, Muchun Song wrote:
> The two weak functions are currently no-ops on every architecture,
> forcing each platform that needs them to duplicate the same handful
> of lines.  Provide a generic implementation:
> 
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> 
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>   then calls the existing vmemmap_verify() helper.
> 
> Architectures that need special handling can continue to override the
> weak symbols; everyone else gets the standard version for free.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2->v3:
> - Replace BUG_ON() with WARN_ON_ONCE() in vmemmap_set_pmd()
> ---
>  mm/sparse-vmemmap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 112ccf9c71ca..99e2be39671b 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -386,12 +386,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>  void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  				      unsigned long addr, unsigned long next)
>  {
> +	WARN_ON_ONCE(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));


Not sure if a VM_WARN_ON_ONCE() would be appropriate. (then, we have to move the
pmd_set_huge() out of the statement).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

