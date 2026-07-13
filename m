Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0FEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9866B00BD; Mon, 13 Jul 2026 12:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64F96B00BE; Mon, 13 Jul 2026 12:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AFC6B00BF; Mon, 13 Jul 2026 12:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 815676B00BD
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:17:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FC29165C09
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:00:15 +0000 (UTC)
X-FDA: 84984063990.11.0BB901F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8AFBCA0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:00:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I32dqgWU;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783954813;
	b=mvwU08KbXi4H3eJNlZw1mfz4uO8eGkq/gGuxbzlEXRfA6poe9h1zZSXO1pEOCjNtpL3QU4
	6v1jjLaHtt9b5b94z7a/sZUZm1G5v7iG5l0QMZYcvkxo9cr7ybwEzjfha2prmoImDvl9CT
	9SNo+O6o5ZYbi1wIABPmvXDGHaQkNyM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I32dqgWU;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783954813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5fiDa/fj5SvXJxwaq/LucqFFHHfPASlU0kMK3p5WGY=;
	b=gIR+cOuPoDOtGh3hPK/dHmaVQ4LrlbqmnnKBYoXGlyxT7UcgFubdswJbIMKR9bHUKKo9a9
	2dsCfSjCi0YoiT53lO6v6BCYXJCvld1PG23+pnncjjvl7Ybgn3rA2CFVaqbhJHOu1JORyl
	jzBSpRndZe7xd1YGbBsBJPO3qqQTBxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD908600D8;
	Mon, 13 Jul 2026 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274AE1F000E9;
	Mon, 13 Jul 2026 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783954812;
	bh=L5fiDa/fj5SvXJxwaq/LucqFFHHfPASlU0kMK3p5WGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I32dqgWUovV+6UTILJ1hPHG2Ah6V3FEIqgUwNz1L1+KZaZO+6JFNk8EvIaPIJJWfW
	 Di059jpXLRPNzd9QD8Ca69U8jck7wMLlLgFoaHu0+HJD4LBLhMMbCQZnXwNQVF3uIy
	 TOtE78v+5HW4SmbfRldLFT8gF/ylN8dXQXev7l+Wlicvhjtqge00fO0AZ35gxp2axB
	 PojGQNZAunUwNBZVGMsSIrHAbqrVc+mEZwAChGzDDTC7pM6zl0BWaQaDkqkijOXhss
	 PoTM5bY5kPP/7zBrAZMkBOMLx6VqMiDnvf1eGAax3omJerdzIevFOpv2TS34dYBVaf
	 sSgYQ4PWAHEAQ==
Message-ID: <16e7eb78-f107-4f26-83a8-7e41924659e5@kernel.org>
Date: Mon, 13 Jul 2026 16:59:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 19/34] x86: power: use proper set_pXd() for generic
 compile-time folded patable in resume_one_md_table_init()
To: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-20-yeoreum.yun@arm.com>
 <595e5ba5-0bc4-4630-b8f0-8637298076ce@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <595e5ba5-0bc4-4630-b8f0-8637298076ce@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8AFBCA0005
X-Stat-Signature: w6rjy7p1xmeryhoxgh9798uskc59x8bp
X-HE-Tag: 1783954813-588791
X-HE-Meta: U2FsdGVkX1+I5Z8sck9FTqCLaQ6ZbZu/TJntnN72wrTkuQILSUW10217dOxhEjbTMBmPxnWW4npa00/NgrD3G2eSPi0eI6NWfzF2sdtRdl0Bt2MT5UYeH5efOkuuecWmcWjNvKLOvTPxZE1g8CT4o38SaSq9lSa9mlZoyPxEdEHTK0Tb0neh/SKfCpP26EQA4cMb2E5S5Ct6CoqrTCobEblgRfZznVxKEm5yG5zMfDShA/RQRmVi41JeuaFsQnLLSpMaBJC94s7vy/NrA4JYvZ0Z2wPzfTkxBpG2ESyBlyXArPsloddgkqN1cTJD89jYjD2QkgMjFD+aAwdSHE1u8vFCfAKs4AfvzBK2ZPO/MhBEUyv0jI+gI217CFYXTbGGjxNjeCTggpOvurSaktIdi8fOU6XxFhnB0NM97aJ1H5QXFjcNVg0/iP3mJQ2ygEkC8AqeDCulI/ZHV9WxrOx4BtZ6LDUjhligxM/kXFmbInoU2xz4tln3xnIye4P/tvKlGxJuGB1yzkdfZJu4lyFY60C9K2svk4uZo9ooJ6zcLpZM0l1NwPXPSowol9AtwCjZFmLo8z4XbJqkJKB75wk6hFwq8dsgrCdmmDNFYOFm3wcl7YjUj1kxaGNhDEaS22mWISjcEd7m5fF/N9YamRmnVFfHemxDJLTytVIP7JOmro5Ckd+nRxlPkfgRMkWviM/zm94W/gOTLQAamZmxP9Xyk+P3p5wFsRmi92+h3y6LfAdeXQinI2Zwe1XIgl6TpNpSbwZKGgp2J+ZYbYBaViUJ2LTWGOk1dT4uTGEt6O4xLHgT5Y/nekYcBJQrO+j0ZY4gp1tqRefKLAtIl7GTeRWQQ/1lEgzGGkHLxDzsCaJrpwO5XE4izQdY8RigdBEAyVjO2NEUunp3JSL3jxHCF9mtAv0WGonkSVuNd3jpKdI1shML6RRA0oWZdXI/8MRjcHUQ2p+y99OAuVwOVHFnJQM
 KXh87JON
 cwVjnHYUUP+v91AxSYZ+hh+6J/SYOV2mOZnl+1BuupsHnJFeY5QY03LlsrM+koINWbftAfex2OIdrQFiTjazf6/Scji2AB8bFEKt9gfJumDXjqywBagK3MqoZftZz1n2Lv0vl5GzmkpCLl3s0TXYNAVF32rivuKD6GIfIUjp4RWrR5ZiCd0LeHvZ0D0NoP+S4SVq0bvovcXjY1TKqBV0XgTgbtVVwEWNQZJ1a4sxw4iqEv9mbUDTkvW2ztYn2oM+fQb2I47ih4gdgDEejFZj2NaNvmGdBbkkeTsdsLnZFsrUmxtacikmusLkn8QblkWfWfGo+o6cgr7I0hUfUGbIyOD3LpYqoD0exeL2s5slWHe4tfE+LTNv5cz2wsFJlN5CspnbsfEgIjxbChvHX1Avkx70v2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 16:38, Dave Hansen wrote:
> On 7/13/26 06:55, Yeoreum Yun wrote:
>> @@ -134,11 +129,12 @@ static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
>>  {
>>  #ifdef CONFIG_X86_PAE
>>  	int i;
>> +	pud_t *pud = pud_offset(p4d_offset(pg_dir, 0), 0);
>>  
>>  	/* Init entries of the first-level page table to the zero page */
>>  	for (i = 0; i < PTRS_PER_PGD; i++)
>> -		set_pgd(pg_dir + i,
>> -			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
>> +		set_pud(pud + i,
>> +			__pud(__pa(empty_zero_page) | _PAGE_PRESENT));
>>  #endif
>>  }
> 
> If this is the way forward, it's going to require the retraining of some
> awfully old brain cells.
> 
> It also doesn't really read correctly. Loop over each PGD entry:
> 
> 	for (i = 0; i < PTRS_PER_PGD; i++)
> 
> ... and set a pud?
> 
> 		set_pud(...)

The PTRS_PER_PGD is indeed a nasty aspect. Maybe we could clean that up to
exclusively work on PUDs here.

It's already nasty today if you take a look at e.g., patch #22 where we do:

	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));

Or patch #25:

	if (pgd_val(pgd) !=·0) {
		pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);


So yes, we know that we want to set a PMD already in these cases. And using a
PUD is the natural choice :)


> 
> I'm not sure how I'd ever learn the rules to write this code from
> scratch. Right now, the code says: "The pgd_t is the top level of the
> page tables. I know there are PTRS_PER_PGD of those top level entries
> entries I need to 'zero'."
> 
> You don't have to know what is folded, just that you're dealing with the
> top level.
> 
> But *this* code says:
> 
> 1. The pgd_t is the top level of the page tables. Start there.
> 2. "Walk" down *two* (folded) levels
> 3. Set the third-level (pud) entries to 'zero'
> 
> So the code now *has* to know how the folding occurs.
> 
> This seems really hard to work with to me.

It all goes back to the design choice people made to say for folded p4d that

	1) PGD entries are always treated as present page table entries.

static inline int pgd_none(pgd_t pgd)           { return 0; }
static inline int pgd_bad(pgd_t pgd)            { return 0; }
static inline int pgd_present(pgd_t pgd)        { return 1; }
static inline void pgd_clear(pgd_t *pgd)        { }
static inline bool pgd_leaf(pgd_t pgd)          { return false; }

	2) P4D entries are actually what we interpret later.


It kind-of makes sense, because then you have all of the folding happening "on
the top", and not somewhere down the chain.

But yes, ideally we wouldn't have

#define PTRS_PER_P4D            1

I wonder if we could clean that up ...


The good thing is, that the compiler will complain to you if you use the wrong
setter now.

Note the comments we remove in patch #29:

/*
 * (p4ds are folded into pgds so this doesn't get actually called,
 * but the define is needed for a generic inline function.)
 */
#define set_pgd(pgdptr, pgdval) set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })


Doesn't actually get called, right? ;)

-- 
Cheers,

David

