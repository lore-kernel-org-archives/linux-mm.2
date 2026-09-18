Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE42C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233D96B0095; Fri, 18 Sep 2026 17:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4BA6B0096; Fri, 18 Sep 2026 17:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D41F6B0098; Fri, 18 Sep 2026 17:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D156D6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:25:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B5441406C2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:25:04 +0000 (UTC)
X-FDA: 85228163328.06.897C746
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFE0A40003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:25:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+hbnWOb;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789766702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttXCrG08p/oBc6oZKbu1QRJWgL9obcgO5so+f03Mgbg=;
	b=vGx0Qzb2pjKk6fa9VjHGZL9U+2Aiap8PfksIiclh62BMjxxOeUEc6L9Q8gy+0entGWVpIZ
	99aRRkxVcqGpMUh6FlUymb3wnWFp9Dh91JsOO4N1fIOpV1K2Hlayx78jGEXTppYPbuZDo2
	nX30h9BWg8sN/541AmO7Q3bZoR9FR8w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+hbnWOb;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789766702;
	b=pfl1VEWhuv5pjt2Bi7TZ4FfPw7eqJlcKdcheTGUEolW2loIHvbu2q0gbUEDYo+HD5LJShB
	Af7P3YPW1VGUerAwiMPmaKD1Q+jyWuzkn24JOuObcoDoZm8R28P+NJEDdoJ8sgklakoqhd
	le5cFVycZiSLdmmkqJAv6M2PGEoUChk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54EB26053B;
	Fri, 18 Sep 2026 21:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A601F000FF;
	Fri, 18 Sep 2026 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789766702;
	bh=ttXCrG08p/oBc6oZKbu1QRJWgL9obcgO5so+f03Mgbg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l+hbnWOb0Wn/mLkdVSBGZbP3X6KdYSrGo79rDOB9JNFiRLUAwI+a/DzK8DYGSFPNG
	 ulCWPLQh0FKwLnHr1ZK0sSDCFuoNdA/noXajLb1kZjk3F2eiWMbZ+YWMq/Yfoz6auc
	 n75Dd0vOKo9QkmCiXXL0LLDgzRCxC9SUnuuj/08gw0RuvHhQMm0qZI/bhM7QQDo3jQ
	 yCTl3K/2wKX/gS1tjD85Sl/XepXxV0CnqBiIhhrAwjsxgG6rOt/bEPVjd1ouhL2ON3
	 Pi4BafoU/thlV8jwoK0ek3izYjjW5SaHfFNZkzpEm8Hl8QVG2/MWMOO78nLVChMirG
	 YzKs4sgV8UpJw==
Message-ID: <06e44dc2-ae67-4c48-8833-b3ec9d2827bd@kernel.org>
Date: Fri, 18 Sep 2026 23:24:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 05/29] riscv: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-6-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-6-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFE0A40003
X-Stat-Signature: hkrmzj4pcjo4znbhirx15ha51q3qnua6
X-Rspam-User: 
X-HE-Tag: 1789766702-210510
X-HE-Meta: U2FsdGVkX18AShZG8NsuukYHlGr5BC4TVLrqkb00KBF12+c2A54nN1WoZeJoFlYEy6sMeGSjOaMt8M3J6kQ8LQPOezJaSLsijgT7xP6akxDrP0U6tqbGOpik9b7D33ciUBKMml6St6DlkiipSF/GHeejsI477NO90oV6yDnTouPc8hMmtkE8+8abX4iF0EfR16YpBmP1334phzFa9wNKrcwDh+O63ROh99JvEJzxasSTfL41T+wqeUMtnURxBWx8cjrmrg9s27MxHebS38jpRYOoXN5maXLX3NPcMr62Ufk3m4psm03tC1OyAMld8JSPwylUZ3HFViKUWYujs2Xnnkxiewxej4M0cbX8uC+X21I9YazD8rwIiIpyaPq3gqhSBJl8qbUsB/w6VgY1KJqRFLyrmAw+rY0yCoLObXYNKAXHE3VCnHI34cTrgEQv/SoQRptRbBlMqIbMdx+lul7aZSMFkMo06HU4sBN6XXZfzuHaUVeuS3krP9yA/KcDBF5phUBpWEHvoIoa4UbwvwsXwuvjE+BWRLo05GLdxxKMBHKUMRwuJL5CLEx05WumnW2rM6kKAeL7g6UM69+KFMjF0mbCQj1GRSJo824UeqYKWIuKH64WUO4bWlfidI9AUzTWezU9rU17gaywJrK1vV5Tg4KGMcwRuCPraNkaXBE+PA7wr0FBkIjOip8ZACe3BONDmfh2VeMSSIH2WoD1gjHU0j9ifwe8qDPmxAwsGgAmzsFa/O+nuWoxjGRwLJavlzhixKH7C/WDg+MMc6SrJwc2O9T2MKQBWZy9fdh2KlkT5gVJ8B1zpTAvkPsdWO9sc9RYn/x+uYlPvpfVpxEmCMk/UMKD2/K4T3D3fJ2ssAGG9fyXPJJx5tOqJamMEzLzPwz8VSYDdhsRHC+czl6rnCReRjd8aHTCk0X5JzYUil7id3hXQJcEpXUhhX8TzgYbWBYd5muIBSUi8kI0aG6drrl
 35B+4tsQ
 aMdIH98p8/w3wvIao+1u3NMqOZx6lcs2/YUmRyrEi7ZaOB/QOT9jmplgBZ7orQCzsx3LWtzjVcEDgknhjjkgXmBGr6H/bTpu0BMT3x7ZWU/R2z6+OC9ld7sk4BoECUP2JXltjGgyQtsjLMbdncZPSdfhvCPgpF2X2tz7gJZcwt0B3R0wJmEr9jJhiehBx9fd/cDMpPOQK1FOaHhHfot50xReqJ1v24Yhq5VjE24HobNe/GPsRp9BtI+L9FyW7pxlpn05dkEZjgFIiuD+u5bA4doHRVubiuqKOvckkAmAnIaBp8HbjpWt6yp1S7BwDa1C/qg5cdXxLdJN0eycYFY1mm+Biuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> riscv encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
> the PTE ones and reuse _PAGE_SWP_EXCLUSIVE.
> 
> Cc: Paul Walmsley <pjw@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/riscv/include/asm/pgtable.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index d48f90140841e..b644db16bda94 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1219,6 +1219,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  }
>  
>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pte_swp_exclusive(pmd_pte(pmd));
> +}
> +
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
> +}
> +
>  #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
>  #define __swp_entry_to_pmd(swp) __pmd((swp).val)
>  #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

