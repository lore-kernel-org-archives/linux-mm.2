Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B84C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F956B00A5; Fri, 24 Jul 2026 06:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9386B00A7; Fri, 24 Jul 2026 06:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB15C6B00AA; Fri, 24 Jul 2026 06:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECCB6B00A5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:39:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25BCFC0376
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:39:14 +0000 (UTC)
X-FDA: 85023323028.23.E9F8D2C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F7BF8000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:39:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nPz4q9Un;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784889552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5FfeGZ8ZGKn9Ad6ByGszcDZ17FyujPG7USz2ODcO/Y=;
	b=syqCB5U/kzc0urX9Ti7oNXZpPcqp5puNUbOcjSyTkrO2o9V6Df2BFzv4ErpOjTlLCqM8bh
	5THmcwuRd2xHTA0IDmw/vdnPe7K/shDFOiTY3auvnUyyMlXg2ABIJk5pmoX7gdm3Z6RykD
	6zKQE8rxjhZM9OQxLFHMnuL13h/7lqI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nPz4q9Un;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784889552;
	b=0GXh5EXQ1OFSTRj9x/+dnl19xyPp5Nvkf4paG5dsM2ECqT7UTxFXxnjb0Yi7UOuSxaPZOf
	Q/cJqDy5NAFVzykCm9nFUrPdh73g6eW2OQTPBReX/bkB9PsMxwGiqmqZ+tgXLTeds6waei
	Lu5QmKHs1ibOyDvNZ67l3tvBX7IAlIk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E56B1477;
	Fri, 24 Jul 2026 03:39:06 -0700 (PDT)
Received: from [10.2.198.93] (unknown [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EF243F66F;
	Fri, 24 Jul 2026 03:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784889550; bh=8ucxzJzKRncGbmLH/iEQkI2exC3zh2zSlJ8zSRx26rg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=nPz4q9UnTmIpC3f1IrnhhOXc+A/Z2VLc2MvO7S07Y0dMBj6vYrB5Dye4ym8oVNhXD
	 BOcxcXhOs2SceDUmzESNakuvRw/Lz60Kb4I5oFZwEpDHzbiEUv3iW7H4ZPf9e+CZSj
	 HrNea7YK425Wt8aVXd2zUUsc5hB2FRPkxg9XWQf4=
Message-ID: <85146377-9c7a-43d9-a5af-b976d25cb93f@arm.com>
Date: Fri, 24 Jul 2026 11:38:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/20] mm: vmscan: remove stack copy address of pud
 pass in wallk_pud_range()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-8-d9e4bad31e0a@arm.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260722-dummy_ptxp3-v2-8-d9e4bad31e0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F7BF8000C
X-Rspam-User: 
X-Stat-Signature: k43q5wfossnonnx7uxzjqqdoqu4tyhyu
X-HE-Tag: 1784889552-306075
X-HE-Meta: U2FsdGVkX18dq520/RZlGl5FA7jWMd+CYCFEfe+E9V1P4T4VqHLW7se+XjYAwwQbCf5TAe+AgcmbNh3T94Zyt1Dqd5hUPB84lgpgvwfsXtqPAbLBZ6vGJtUj9pSsJ2HcOta7VEnU15ALi8xR0WdtGoR3E2pmkDjTsG7/L7f9h28ZqedNxWii/yCQJQb/W/NJHwQy2XZpV00BDQdKqgnjSk8rp2oQl84fBNut2yPESN1SMVvNSMkwGsxWwHO0WdNjykH8EsP/jjocITEnMjjCdDKbJkoUyv6iFzgpfE3vPNC1jFipbBxpAwSZrDSZ+9N00wS+IkA+Lrw6Ge5HT4WpAjtwxh46pQzqBDYZDF5niK1/9y2nVcF6onXK65m+h/N98WqX4DkVVZ6G78ZDa1MKqD5CHlhDpRagb9WQVCrlaJPHzgtqa/wAhLPczmOq5xLyq0TO3QdU9bagKzHkLHhFiXXpK2GC/VaitfG47LD5hKglwumMwHJzehooGGsFgbmcRBtB1DanBzMneU5sGKBymbVPNC3afxTDXZ3Q+ViCAvEPO7AvtLUk84+Y+uE1Pi3kvM9NJqYleXDdYiTU0a0svRNr0Jcwgx8cMcZGHI94rQoBJeDeSrFUDvSnrFr1TNoWXdwvx8bENOBpEXLW0PXGdJ0BOm2L5kW2uAgKXgOsZMVxigYAPRC9SZiYQZIZIBpBzf1v0CwqUTHh4ewmdl0w8kSSeU5mSJ1PQ/ZsPX6UviN3uZinSnsnPtJRUdRwhWGQGM/V79bBf7Fnqm6aaf97HwYAwVclsVVEUWlJA81bjPRxyMrV+hlQDdG/OBrBfz1peJclyfj/iK7qjgC2Wb+BiRKGmRkxqidHOrGgDkjY24MPDrTVubgx2FDOJhDVqi7IR1yKbaXe1MM8A7u4OF4iYM9ZMnprEpo4Qbdm6YuRLRbV1I7WoR9VHjoaRx6BPr2LgQ8q9AGHdAxCObIBRXA
 UyriNR9n
 8Dq8aZsPrNtlxVKrYf1q1cCdY68DQ1/zX+OJm1fLV8Pd0pLhkdmF9pQiUkOx3nljfdD2SZla2s578m7t9e5g7D4N3BOaTf5srKw5T8Ho2+Q75PcDknphyli3P1HqbvEuwMMMlMOpqF1O+b2OzTfACFX7Ed6NbQM9iAutjUEa8dr5m907/A78Q/ev7FPacQwPoCz6f8laKpdSygW82PUrXjehM4cb/hS/r0GdysWPPIkFNQa+ScsULpTVApeRiiiihHtNdidK/4nBjY5SzZG+pFGEkQTiLGc4ukLJ4BJxOlUeCTEDxxMUA7NoZWs+KWZB60SCAbcJXNIuEzwV2RFGPTTJdeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/07/2026 4:30 pm, Yeoreum Yun wrote:
> The behaviour of pXdp_get() will change with generic compile-time folded
> page tables. To prepare for that, replace passing the address of a stack
> copy of a pXd to walk_pmd_range() with passing the pud pointer directly,
> allowing folded entries to be ignored.
> 
> There should be no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Probably my reviewed-by tag was lost in previous version. Posting here again:

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 06e103f9781e..0c9c4ac89e09 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3727,7 +3727,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
>  		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
>  			continue;
>  
> -		walk_pmd_range(&val, addr, next, args);
> +		walk_pmd_range(pud + i, addr, next, args);
>  
>  		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
>  			end = (addr | ~PUD_MASK) + 1;
> 


