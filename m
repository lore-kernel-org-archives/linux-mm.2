Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2DD606A889
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ntGyr1xD
Received: by kanga.kvack.org (Postfix)
	id 1B3806B05C9; Thu, 12 Nov 2026 07:23:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164336B05CE; Thu, 12 Nov 2026 07:23:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019A16B05D1; Thu, 12 Nov 2026 07:23:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5B0A6B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:23:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 683A2120599
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:43 +0000 (UTC)
X-FDA: 85426383126.30.7CB3A41
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 859B1180002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ntGyr1xD;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My+EyMv7kUK9PriD5W/MVAD9Fcc5R9RWddctNSFBcso=;
	b=bfj6I0S+zezjNbAobHYSZA4nSwCILQP1J0YDzZ1H2TjyInkelBCLO92lrp+0zqg8Wa5wKa
	fwfT+M/hG1QScAefBtxeikB8a4WbWHuqdAfqO5hcgEKmm8bz9p1mxifPfuZ7s4Ttt9CljW
	kFN/ytP08diMMYTWJMXcucENLJ68VoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486221;
	b=IpiSSSVhhHshZ+958y4zdE34xgoR9MV8f/fC3WBKSxHsaeIqfpAXSea4qCzx/eWIDIA7PG
	eaUfVT1o/hMOewuXVI5/Y9wB2tpVkLUztUnVqLNyi2a9f8UCUaByD81ettDKHyOENGQBWr
	MgIrpRHl0GDbWgGSULzlBTx8SaeD0VQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ntGyr1xD;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4697404c2bso571396266b.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794486220; x=1795091020; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=My+EyMv7kUK9PriD5W/MVAD9Fcc5R9RWddctNSFBcso=;
        b=ntGyr1xDn+f3eRbdxFn4ZePm86+fqhsAUkfQKeuEsu+uJ4afykWHMPYtuToASETsB4
         X9vqHn+WDm6aRSgXuS1jIdg9d2WU03xRnv6yJeR4/dwG37IvBAEnVaAP015dKmWyhIo0
         GhlV44D6SvQuJ+MFlB0GAFJLIdd081ij77bhQyFIuopmQCSyO4+maFAWBrifLp9m+IMw
         wVH9pAhkc5OZvjayy9BiTeVB4IgE/GkixlmhW+5/P+Fn1ootgesYMLs0Pi/SGYYvmovF
         NIcfMyZi9QO4T3rL/orhz3DTSeJzcpaN8dVg2n2xPWT+5sKuK3VqcvQYaQFxliZ05YWe
         iTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486220; x=1795091020;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=My+EyMv7kUK9PriD5W/MVAD9Fcc5R9RWddctNSFBcso=;
        b=zjFwFGMTBFRmHCcyFOz1j3miq+bX7HbwSJceJzt615PHJawSVVDwp2+leZBBatpdfZ
         ZsCJyz64/lMXBOktYcH00iC6SxNETTKVAmU6i46Twlsy03shrEfwppenxfAYGiIjoH6e
         qCq2Qdt3vm6ds0ZyXvWEO5gIjrORIrUWFltqhdWGONMETtJo4fCIUI5ayLUSE5JqGHoa
         brEofEunz2zpiy8fFx+TnlJfGmzyNekt8RCIj+jzf5cyazQqWie7thte+mNul7+q+C08
         XqS4SqAbWSJA3Tvz3ogDCsmagPwGqxtwAHslOXRQHlStEpVgmnaDUcjKqdk++qeBBqzL
         TMsw==
X-Forwarded-Encrypted: i=1; AL+hErEYq7hLboGlu22tySGm5v0wsH/RtvTVeJuBhtX/jydFf5AbPrVBdbiDjMkeRNgbvETbruqnKZdrbQ==@kvack.org
X-Gm-Message-State: APuU4Z8JoORyatJ9OV8vrleEtvPlNbFDnlKiIdHnEnGiXmc4FXsXM7/5
	weZsjw82Z+h0dWqXHS1OW54jY+FHxX9Mg8mk557K4BfVCgLWtV0k54ys
X-Gm-Gg: AYBFou1YmC7Syr4Qp+HTzjiGkiPh42iFzkf9vKaLmvZO4zKGuTwmd7XRPUZva5kxP9y
	8QAEYZhTXe0SNAMarh+807xHp3+3mzrDontwda/l9C89H6RMiFRrcu9KOXisNsnRoG4i3thtll6
	J+RCpg2Uaw9VwB2W+c1RLlvGbs/Foh75+vK0vcEFT/OCUVhaEJxbs3yVAyJ7IDEN5yiGOcEP2x6
	q1EltCDkPx81m9JIkDyH5HuRANJpvtjg0P51GlEOw+SI1GqYSQvjS1CI9O9e5GJw7PpZKEZoP/P
	BN92tdgOmRLtSKZKfy2CxXCQUlEDvyC5d83rMKBTJzac793FxuIgnuE6eYQLX6E+XUjqkW/zbUW
	5tua/1acbna+OtZzG3+IkwCs7AacqGqkqHAenMtMJGfvzlYAC4a2qnYqbk6NPZ3sU5ilnxQH7ne
	7Zgtvu2v5h+3DtZeML/xGQ2cF92AmoaKx9YrumPHP4Mwj3LIPa4mXj1IbUc7PGJRIk9bVK/a56Q
	EEkFHMrxVGP6pW1Zr3AHdBAHOZQfjM/e0mQh4GqqbIiugihDUkR6m0IBQP3dOX+dDz0Ow==
X-Received: by 2002:a05:6402:2108:b0:6b1:e8e1:a3cd with SMTP id 4fb4d7f45d1cf-6b777828d1dmr4207046a12.35.1794486219647;
        Thu, 12 Nov 2026 04:23:39 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7578eb0b1sm3345874a12.22.2026.11.12.04.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:23:39 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 12 Nov 2026 13:23:36 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 3/9] mm/vmalloc: BUG_ON() on an unaligned range in
 vmap_range_noflush()
Message-ID: <avWvyNo5qHbuk9hA@milan>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-4-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110112546.261415-4-hao.ge@linux.dev>
X-Stat-Signature: 9r1mrnan9hxhjn5y9918x37oskhm99kq
X-Rspamd-Queue-Id: 859B1180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794486221-728391
X-HE-Meta: U2FsdGVkX18OIzOQUIwkHQRrQX0wwpXWZSxVG7JFWE8JZ7xZVn+EVqaUwPHO07j+0BKPqopFMZOA/+1+xgUgGpxAHahGy+HDBCk+AHR5LW6kTnubJq+ew4a9fCCdzSOkEcH1816qvrpAoAJ/b7BT0Xg/JH/esREGHbg+uw/kbkC14jvImtfLSh55A9DTJmDcdU2PadynmuU1Y+uEuDsU85ZOkZR7jAeqFtP9cymObQiNympL3jCl20ZSJJWyTLZQGSh8qsL8QJ5LjIl5n/TYt7wIB1ifmeTOptv1iQEP5iN91UtkTw3+wa37klT6HrnvQi/NdQnZ4I29hW0GT3V8iKHSibzXoWjCKCWIaLHL987D9R0x3LFViJxKXxNlo9A4gA0PML6ic79KY5nXDEOic2O1kQLOT3623WmuzqtNmmymGsMdpKH3wflVjBVnC4pSG1MUqzaorH4YgCCRcxeluWATaU4wgY0u59bEG+DbGtV5V7i3ArOkc6S+xsYcn9ZyPPmem1dgliykw0sjEoPiY7J3iA0hBylQXDdRe/iYVGgkYQorGUa/FTqFO/F6fUCU3BDsgQD8JYpnBPyue34X9g9cfq+nCizgUhxn4Sgnlg+Ovd63pNNscWAqwF3PbjGiGcKLOMLdZcnVnrysq6RIkODY1/CNSZuFSw+pZfTV3WFBvJ8Lv4PDjm7Vj5KRwHaauHfFs+0DqicSBxR8kKWjf52VgCIj80glDzTBSCiQKoGgr/ij/gYVWUziGeO5ehdXbkHeUdhgUW28XOzkv+PQ/o1AZ+xTBROupKwPJqEotMehtbwYcIaWKo5LjTVJsMe3oKk/ZY7UFr37uXJ5zRKib3LsSatADoLLPXhAD+Tpi9d5zUN4bW+mubS7+ttjCUDOZBT061FTm4ffR4H7eB10F5gaMP7v84jBauhL/RtSddOVMLODW3CV3pF32UlKeib39bddD41GV8bKkkMUV9P
 NE6Sf/pY
 WKTd1kAb4AU7xWU6BZ7Fk9w3Yr1zzC9sCmAPvAsLqXNEpaY8a7a7yxeesCFgW9OgUhtoaH4Ntt+CeflWymj2NJB+ZCFRsGU7xV/MHSpQDzYuybM4KKos82WJVWxBEjJtGnZrLNvT+Yziq7aZV2JCgymnyQjBi6hmgmC7jXdVmb9jVASLR2zXQe3euWRBp4uOYJKUg0kEpRJr932ESS5/opIJIjauVXY1MkuAXVtpOuV57PJKFN0Fqe610IWc5UNHMqY+pfr6J1fETtLX4f7wRLuiuGazX80h1PWBCrca+QQyCrEOtWltLCWJn11Sz4WmwZYzImLZjZMfKsllRH4a2NkzCKaxJhMEp/LG1oKWdTpJIovf+ujp2m+yYsvVOK9aO7qKQdGlu39wCqkubj7dS57FdxBIyLO4dOw38hRPh2B4nyuNyvX5qmbVIS+UIef70B+YugYDA4saMlCcrKT4LqCKz1HAmseV93WJPO0PKVRkI+DiJv9SlzLEH4F1W8uapDR9ceXXYGavai79vIZ/E8Kw8l5bNo6Z52i+TrHCftZY2i7YJ7RaeBIYbdEYg6YdKxSH+GSLV+p8LIagGCCrrwK7ecQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:25:40PM +0800, Hao Ge wrote:
> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> late, because the upper levels may already have installed page
> tables for a range that is rejected anyway.
> 
> The pte loop maps whole pages and stops only when addr lands
> exactly on end.  An unaligned end lets addr jump over it and the
> loop keeps mapping past the range.  An unaligned start maps the
> page below the range and usually misses end too.  Such a range is
> never a legitimate request, and the corruption it leaves behind is
> hard to attribute to the caller afterwards, so bug out on addr and
> end at the entry of vmap_range_noflush() and drop the check from
> vmap_pte_range().
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 093b8d5f7b0e..27f2674a5556 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	unsigned long size;
>  	unsigned int nr_pages;
>  
> -	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> -		return -EINVAL;
> -
>  	pfn = phys_addr >> PAGE_SHIFT;
>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>  	if (!pte)
> @@ -347,6 +344,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	 */
>  	might_sleep();
>  	BUG_ON(addr >= end);
> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
>  
>  	start = addr;
>  	pgd = pgd_offset_k(addr);
> -- 
> 2.25.1
> 
Like Suren proposed, there is only one user of vmap_range_noflush() it
is vmap_page_range() function. You can add warn-on-once() there and
bail out.

Do not add BUG_ON().

--
Uladzislau Rezki

