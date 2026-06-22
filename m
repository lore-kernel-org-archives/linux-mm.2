Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF84CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34FF6B008A; Mon, 22 Jun 2026 10:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5466B00C1; Mon, 22 Jun 2026 10:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD2B6B00C2; Mon, 22 Jun 2026 10:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4ACD6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:28:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC191C09FD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:07 +0000 (UTC)
X-FDA: 84907760574.06.9DFB914
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 979CE160008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RWHqWPYA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138065;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTwUN8Q/4wLdeKzilYCyv8Ge+JFMwxPAhYfNtl9tb/Y=;
	b=rBWF/0hgCDPeZJG9VcJEtDbqxrPBgtLj6gvff9nwOPHEJIvSYI/97xraylMG+jqFZYF33w
	3KQBgzxIduaiAEdwsUzrzxtwpF1M/TeWM2rdIZCuTY/KWEtzBq/3ks/7y/VJkHbtSBwigA
	ty3pS/CSKaPTFXNfhJEIPU0I/AueG9k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138065;
	b=kmicTI06rs0liIvxFH//SfPcZWO03tPaIMjK+IFKG+B3YaRBaWmcud11sgLA5AefS006da
	yHngShSwytrbBP8p7C8ZRkj8SN65RgvT53sDgkrhCNpJGkaNWQ4XkPUmeqzm3XdRU5bbqT
	sBdMqtNTQVR7xTwSvkwkmv1yc6tJzao=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RWHqWPYA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6977dc206afso3874633a12.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782138064; x=1782742864; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HTwUN8Q/4wLdeKzilYCyv8Ge+JFMwxPAhYfNtl9tb/Y=;
        b=RWHqWPYAwvq8MKQ3LcPyzSE69XRnWLpOL0x72vjHcCHeWBQNd24/Yxm/RTRiKLkgLr
         0prH/6gC0IJj1jEMz8yZ/KKTwf1admYq25MAuZlmCbNeTa2TdN9x1Cg4mstuJ+f+fI01
         /LehxlSkV/Nw2AAoTCtq8SwRfSxa0t9AM0O6zmJJbetPSSOUsIByBA/Hf3/O5zVCO1Aa
         SFib4eynz2nZgShTZpmqKj7yQz63FzDZGXlaHEKJlbm5QS1l74+PzzgMZBVSrSEGWSDt
         gm11mVX1M0IUlbPhcgMtHTcSOytoyasLWrfqKGWE4tV3AXw7TL2pEZTTd9wxUoviL1KJ
         Wdhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782138064; x=1782742864;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HTwUN8Q/4wLdeKzilYCyv8Ge+JFMwxPAhYfNtl9tb/Y=;
        b=Cev6ZHeyNdl/+02vSgJAwG5Gp8HmN8FrIqwTxZp4XMdEEHlNqyz4Hltw64PrBDm1+g
         9hmn4f8e5TrIyaBqP+8KIYzaFlW9DQZPOLj+9qmHowh15OyeY8NVgaGEusmJP3fVlsI1
         58JTdrFl06SExYu7siHQMIk9jZXOGH8rwQVvjeyheCFV00WXpJnETegWWxZsILKy7pDe
         zXuqirGfz2dvmdIv85/K9RLvPa1/QHecpdlUcYsDOX09+6enljxJAmwuNVGFUoUE+FxG
         lRSM3YQV28AsAii3naLRsnYQmDdDO23JTg3NOAfXNjEtphmPu8++Bek6Ctls//oaGH9e
         If/A==
X-Forwarded-Encrypted: i=1; AFNElJ8vBl+aY0zvHBudKjrD3t9gH2iyuhh2OhwpEzPgTERmyv+VEKPYbKN6gvYsB2Z85MCawJv0OQSsIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+8sFQ+imgMOhf4YbvIuwrV/v4pgh0tYWx30HYXcI57RWPpTdC
	zF7r+MO/i5eaEuQcyPWnZ06qVoxtUp8Sp/WW/1qcLbuXRLoHiScOn9eT
X-Gm-Gg: AfdE7ckAf2iwQiAkrIv4TM6F47gBkY1+wPiLWpsS0KthwlDbOPDsT7SNiG/p0xbyVj3
	KsQLkxAUormKtL/kbFmUkg8EzXUNMcqAYe9QR/XtipLSg0v4VP6Z5wD5PSuqeSn7/HJbBKDbIkU
	/7o9BNQ/lcq3Xc2n1e8UvCQBnPajtnVXedt2uojJOyr/07YB2beziXgIDxs7kXBI9RV6lYmMdKU
	bm52T4kQIHtipVjBXupcREU8TEcw7+pKiS9/DyqiF/3V1GLIt914MNMnE+Kp9xN7fR5TLQovXIa
	i7ppmlr9/6hUUKB8xpo121PbIe0XY0w6LIcjnUIA2RetPaFDhnsxRjKn+MVEtA3ku25U1yvIrrD
	w/+DxfZ+0dubDj6WuupjdxqZnp5ViDvfoYq+LGmkwblkRw5hf4hLqozhtFlv2MvBmyss0KXDy+t
	JNe5SipaHbOc4=
X-Received: by 2002:a05:6402:550f:b0:695:df86:d774 with SMTP id 4fb4d7f45d1cf-696dde43a4emr5830085a12.9.1782138063649;
        Mon, 22 Jun 2026 07:21:03 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6977b84f362sm3136005a12.10.2026.06.22.07.21.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 07:21:02 -0700 (PDT)
Date: Mon, 22 Jun 2026 14:21:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com,
	linux-mm@kvack.org, stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260622142102.pcmr5pftshj5lvju@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <ajk0N3Aekapljaoh@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajk0N3Aekapljaoh@lucifer>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Stat-Signature: tfqj15pomg5m4tdzom943wjqicsajqo9
X-Rspamd-Queue-Id: 979CE160008
X-Rspam-User: 
X-HE-Tag: 1782138065-314983
X-HE-Meta: U2FsdGVkX1/XKMqwgpgjXq9KUc3T5A8W8j3cb9S4GwHp95maunbB8mnmfJzj8fWghYnFVdVL5PKKwEAG1omWx02CUGt2AOiFfY6OPDmfpmoqVa4LP3KIMCR9Z52OOqaseH9rOTcs3v0kWTdRejVuChUvN/8rroR4wzjUTg9oDMU1x6fKg+RM+7kX2K7gPRuEvx7iXFa5LWoKh+kB7q6D6V6CmFITNIefiq4MjX5dZ4sN4hWep3lbDMMHbllDZrsfNUUFbL68L+tohiwNPp9plczv0yJF58cQRPv2+Y72Lvk7YPBfn3HAd04551CjtSxUjTiNFLWM9DZAceAAQFVgAQiiBjltLrt6qtbPT3NW6hOdEbzUSIA8sMIBDXHb64DdGLwSjFGd7g0ZATbdn82G/KOtrrM6OtLHJEWNosCVVSPdHo1JUNs8T2zPxOl8sYDT/wEwaNXZ698KSFZVw78TII07D1CbkheHQ1PS+HU4ydIY5fkgby8bnuHeZ8BaYyo0ZMri5frAkNVOs3hycWIAzZYBE2QvF3CqfnGIFhenldXZ0cdhVClrK+fqdG5w2YeqAejOpdgmWkwCzhmA/VSK+NDcRSaLGi8rzHOhNj4bBa/YTJu1XUuajZZfyMw7Xlr/ajaztkYuGmIqTLvYeruPDOLIzPKn289M/SNDT7AzcwOqSm+lHcnZnsOjdU43X9CKx+kJ2bt9wlAWajeS9wThvtvKWA0cq5i8rs8oBbFvzbJUUdNYsgfdNztDuS4NmU/4UyrXRcfBx+QCHKc3I4vTG9frKW1MYTpj4qhNLaLcrT/pI3PA172GaPqW9XQ08PWT91tFlr5O1zbVjVH0J4wUZ+xz9E20HeyfaFv+P6ln/HdwfdOT1OjXp6mdb0IXX6vdiA5+xZOBAT+zSWpWwmIL/O5TaRq6+C8jz7Rl3rYB/z88hajyV8zoCWqaEaylNvwWV11Mj/1FLoOlzI1XabI
 Al0aWZih
 UsYt9MCJ/Gd4AHfa/IWcM2RUoQnEMKIraXYk10QzspqNq62d/9RFzFkHY8s0YThZ3g4dohAGFOovI3Db59qQhIR33oD0+n79Xf6rnUiuYyNamirlP9mMRFeBa1Arm+J32saSvvAdPloMYZsHd5SJwcLxKsyrFqOmuiBBHB4y0r+W4/qY200nFTzbxlfe6Kd5YTLnSuWYjDbRMMXvUQTQKcqSYBLdVB/wXgSp/U7rniJYgDTdg/362uW1tqiollONacNKt2bbTarB+lxZVVPKPWh0IXe0qglQOBvGbq7TeR+GVeMWUGW82CCsuXHbzteKTwASuHZs4Kz2xSaaXqhtG1ASwWx+MoXf/qfM+E9JXF6R6uwo8Yk+/F2MGSRfjvIjXPv9uwYEphcxuB0IGZTaeMjuTL05UEVln1SINYG8nQwu60CSuROydJH8958OG2oef8lOKZ5284vQrdDaOo6NuqOH4JOubQ4OImKJxatfsX/rQSbONcGEfF/8NJPc8jbFZ+npXdbiHzvnYmXFPnC/NTWL5yDBmUGQRyquPVdcIEeehZLB1VME6umac+3dbKgm00GXJ475/5CW6uZNnmGqyvq6n3xJ4EwsE3kWGy7s2fgvr9XuaWBFwC+KTwsEtqiuXkEg/LbCLsvvTqFgoN49vIUl1M4dbGh4xjKcRvA9bhZlO/3M8yNY7AaWOkPqFp8ZjmuRsdcOQb1qK4sPOPzE4eJssfwWow4G4c4BShIMzB+BLbWg5kU11pucOM8j/Ar3GClGoEFu0O1I3CT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 02:46:40PM +0100, Lorenzo Stoakes wrote:
>+cc Lance, linux-kernel
>
>Your subject line is 83 characters long and is way too detailed how about 'fix
>device-private PMD handling'?
>

Got it.

>You forgot to include linux-kernel@vger.kernel.org on the mail, lore seems to be
>a bit broken atm but in general it's helpful to include that.

Got it.

So usually we send a patch to both linux-mm and linux-kernel? If so, I
remember is later actions.

>
>Also is useful to make this [PATCH mm-hotfixes] to make it really clear it's
>intended as a hotfix.
>

Got it.

>Some commit msg language nits:
>
>On Mon, Jun 22, 2026 at 01:06:51PM +0000, Wei Yang wrote:
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>
>Sounds better as:
>
>	For PMD entries that satisfy pmd_trans_huge() or pmd_is_migration_entry(), we
>	perform the following actions:
>

Sure.

>>
>>   * re-validate pmd entry after PTL
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>>
>> But for device-private pmd, we just return after pmd_lock().
>
>->
>
>	However, for device-private PMD entries, we simply acquire the PMD lock
>	and return.
>

Sure.

>Also can you please give some justification here as to why all this also applies
>to device-private PMD? Right now it sounds hand wavey.
>

I thought below paragraph explain it. Not sure what justification is preferred.

>> If a softleaf entry is present, e.g. device-private pmd, the existing
>> code simply acquires the PMD lock and returns success even if
>> PVMW_MIGRATION is set (indicating a migration entry is sought), meaning
>> that the caller can incorrectly interpret the entry as something it is
>> not, causing data corruption.
>
>This is repetitive, you already mentioned device-private PMD, you already
>mentioned that it simply acquires the PMD lock.
>

Ah, I copied your suggestion from [1]. Hope I don't misunderstand it.

[1]: https://lore.kernel.org/linux-mm/ajUXNjRMraKb6k2n@lucifer/

>You should talk about what issue it caused and why:
>
>	This is particularly problematic when PVMW_MIGRATION is set (meaning a
>	migration entry is sought), as it causes a device-private PMD entry to
>	be returned with a different data layout, causing memory corruption.
>

This looks good. I would take this one, if you prefer.

>>
>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
>
>This is pretty useless. We see what patch it fixes in the Fixes tag, and you're
>just repeating things you said above, I'd drop it.
>

Got it.

>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>
>> ---
>> v3:
>>   * remove cleanup part, only fix the issue for device-private entry
>>   * refine user effect description based on Lorenzo's suggestion
>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>   * specify the possible error case of current code and user visible effect
>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>>
>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>> ---
>>  mm/page_vma_mapped.c | 32 ++++++++++++++++++++++----------
>>  1 file changed, 22 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc1..8de3c6b82df6 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -270,21 +270,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  			spin_unlock(pvmw->ptl);
>>  			pvmw->ptl = NULL;
>>  		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +			softleaf_t entry = softleaf_from_pmd(pmde);
>>
>>  			if (softleaf_is_device_private(entry)) {
>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> -				return true;
>> -			}
>>
>> -			if ((pvmw->flags & PVMW_SYNC) &&
>> -			    thp_vma_suitable_order(vma, pvmw->address,
>> -						   PMD_ORDER) &&
>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +				entry = softleaf_from_pmd(*pvmw->pmd);
>>
>> -			step_forward(pvmw, PMD_SIZE);
>> -			continue;
>> +				if (softleaf_is_device_private(entry)) {
>
>This is all very horrible. You have an example of how pmde is re-got in the
>pmd_trans_huge() branch and pmd_is_device_private_entry() exists...
>
>We can just make this another branch and do the re-check more neatly.
>

I plan to keep the change small, but yeah it is ugly.

>I enclose a patch that does that (untested, please check).
>
>
>> +					if (pvmw->flags & PVMW_MIGRATION)
>> +						return not_found(pvmw);
>> +					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +						return not_found(pvmw);
>> +					return true;
>> +				}
>> +				/* device-private pmd was split under us: handle on pte level */
>> +				spin_unlock(pvmw->ptl);
>> +				pvmw->ptl = NULL;
>> +			} else {
>> +				if ((pvmw->flags & PVMW_SYNC) &&
>> +				    thp_vma_suitable_order(vma, pvmw->address,
>> +							   PMD_ORDER) &&
>> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +
>> +				step_forward(pvmw, PMD_SIZE);
>> +				continue;
>> +			}
>>  		}
>>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>>  			if (!pvmw->pte)
>> --
>> 2.34.1
>>
>
>Thanks, Lorenzo
>
>----8<----
>>From e6a3c1c782714ed831c4d46a14bb99226423bf59 Mon Sep 17 00:00:00 2001
>From: Wei Yang <richard.weiyang@gmail.com>
>Date: Mon, 22 Jun 2026 13:06:51 +0000
>Subject: [PATCH] refactored
>
>Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>---
> mm/page_vma_mapped.c | 20 +++++++++++++++-----
> 1 file changed, 15 insertions(+), 5 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc1..17dff8aab9f9 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			/* THP pmd was split under us: handle on pte level */
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
>-		} else if (!pmd_present(pmde)) {
>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>+		} else if (pmd_is_device_private_entry(pmde)) {
>+			softleaf_t entry;
>+
>+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+			pmde = *pvmw->pmd;
>+			entry = softleaf_from_pmd(pmde);
>
>-			if (softleaf_is_device_private(entry)) {
>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+			if (likely(softleaf_is_device_private(entry))) {
>+				if (pvmw->flags & PVMW_MIGRATION)
>+					return not_found(pvmw);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+					return not_found(pvmw);
> 				return true;
> 			}
>-
>+			/* device-private pmd was split under us: handle on pte level */
>+			spin_unlock(pvmw->ptl);
>+			pvmw->ptl = NULL;
>+		} else if (!pmd_present(pmde)) {
> 			if ((pvmw->flags & PVMW_SYNC) &&
> 			    thp_vma_suitable_order(vma, pvmw->address,
> 						   PMD_ORDER) &&
>--
>2.54.0

If we prefer this way, I will check and take it.

-- 
Wei Yang
Help you, Help me

