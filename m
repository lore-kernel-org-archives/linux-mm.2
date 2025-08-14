Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFEBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22143900128; Thu, 14 Aug 2025 06:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8D4900121; Thu, 14 Aug 2025 06:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E880900128; Thu, 14 Aug 2025 06:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5F49900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:01:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A09A41DDA9F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:01:25 +0000 (UTC)
X-FDA: 83774920530.14.4991968
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9858B40005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:01:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iiTsXeAEW1jVa5G1SqdHmVSu/lmUktgB5xyatHY/nA=;
	b=o9x/sq7RnceJ+NmWS9kCs+3T44Y06uuSVTutBdDdiILgz7wwDXEAh/F22+UNI9Tzs10RzS
	Rmo1qlksC6yHWCTVTsGSaH1Hl2wPKts5LMQw7qaAXTFHwqmtFfypp2rutfIF0oJueo3Hez
	1tsHg27/a4V70yz71CarOXx2aLQaQAs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165683; a=rsa-sha256;
	cv=none;
	b=0ZIHoC/+M9EidtmHnkmLfjINTMJV94oBvDn82CTgh8OBqd/jQvvxppXHb9r5HbmxokpA7B
	1oYbqaNMOfHK9UdrHoph/rkbFS4bS+me99J+8d1QeT1SLGapp0vxqcUliW1ObwBzpUtJdl
	5ZI0W2HVsxdy0FmnFKlyAfhxsWeHeZk=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4B06E43380;
	Thu, 14 Aug 2025 10:01:21 +0000 (UTC)
Message-ID: <ce64a10b-74ff-407f-a8a8-94c114f753bf@ghiti.fr>
Date: Thu, 14 Aug 2025 12:01:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/13] mm: Provide address parameter to
 p{te,md,ud}_user_accessible_page()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-10-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-10-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Stat-Signature: pjk4dkd5oxedbeey7dmrzgxhkchup77d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9858B40005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755165683-463581
X-HE-Meta: U2FsdGVkX1+MA4QCIyUpVBDtWP0ee3xXzjfdcNSSDhDU/PyJSicY5nROjrnquSSVRBWYuu6VerQJ6VImZoNxYI0Q+HfZmgzeGMTg7DMHIe4sbAZXajDN/s92Y2LVq5sgbR7aD1ftTU+4xv2orwVcbKlKpm1YmL+CsmTJhPlMWE1VP0XdEY3OjeGSbIJlGUmAI/za1b5j4KpuWJtEe1uX6NKMuprg6mqL0c8jTsvTcun6RSEXAAWWgMwjsHEXVCdf7/s5V/0hfLgfHiDa4fFOCNNcwC+mUUMcDL7x6Y1jxUX6JzOXNNwlCtR8qQYwK5r87eiUjGHUDZqa+L5k8vgg547tGzjWbO1CmLf2Rh2+K7rD9AwxZ7a2T2Q9QdTxOFJsyEPr7R+bpIMtqgmnT63v4xgDDIZ4TzGQj0vBaYWMHo9D2A7deBsVriOEYaxrVPPdyDgtB63UeCqmiDSWiwkgHirHPfkt/LFHiFiqPESdcR77zl146g4IcmX8+e8Y1tlv4EvDU9Ddk5hTPpw7HxwSf1ug/PdM/SAJZlXtmArC5Vt8zz8pD+TjPjDWc2vlb0BDZmLTElAqQFwp8TMw5mUQq0RsXPZGjeDw7gJ+vWFe10Uv1E0k+/gvi5uNi63hpBhMzOrfWiNAx06JR8vhIWIoEsbk3zdzkkaDljWavppTnXOHof/CO2cfwRg1OJCv6IVzH5ycts20kOrG8Dwq2bnyYd+uYUSKY9n3cztoDUGWisTH8dJ6bvbyMCSGBd8pH7YDYH/Oia0wivTNYLJG19IW3cj7+635O63t8Ux9Zc34TZ7QRUNiLFM3uf20qnAc8awXnodA/HWzygsDV+7noIv6MfuljXwNlJPsFbDBla406CWiNHNB0HoKSNIlu1Fv5O2CFpOs62G/7JnNUN/yY5DuU/DWN9EqWXrMHSeqbyiAs174wH6NQ2jCSfUwgwaroubxPKwAeLrKZYugN/Fk/h6
 lsHMQXIe
 Fx8+TLWKRVMJYJRn4MVzovMaRTl+STVckqVAfbuh+EMaYk6WtenJmB4ek5OdzdshX5oki6YGRirXhaXA3RbB+nQhTIpOC9ZenrQiAfHQj9JH/kOdjLOdxeiW/o5lTlckB2IzWrPgIb4hkKJfwyKwKEp/coDQvgiTVke/dUB+NEccd8IB0TUiR1IveXRB6AaZCyUhDrZf8QjtrWOV4/2kwv/0ZhN3MPJW9Xog/zGwcRT6hBZtvcn/P1rA3wvo/nyquJHilMeeRNRXhhicaZF1YKVLle57N+TmNtGBi565x25YNLs3dbbg8ydmiAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/13/25 08:26, Andrew Donnellan wrote:
> From: Rohan McLure <rmclure@linux.ibm.com>
>
> On several powerpc platforms, a page table entry may not imply whether
> the relevant mapping is for userspace or kernelspace. Instead, such
> platforms infer this by the address which is being accessed.
>
> Add an additional address argument to each of these routines in order to
> provide support for page table check on powerpc.
>
> [ajd@linux.ibm.com: rebase on arm64 changes]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v15: rebase
> ---
>   arch/arm64/include/asm/pgtable.h |  6 +++---
>   arch/riscv/include/asm/pgtable.h |  6 +++---
>   arch/x86/include/asm/pgtable.h   |  6 +++---
>   mm/page_table_check.c            | 12 ++++++------
>   4 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 2203ebac81d9..254265e9a423 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1290,17 +1290,17 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
>   #endif
>   
>   #ifdef CONFIG_PAGE_TABLE_CHECK
> -static inline bool pte_user_accessible_page(pte_t pte)
> +static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
>   {
>   	return pte_valid(pte) && (pte_user(pte) || pte_user_exec(pte));
>   }
>   
> -static inline bool pmd_user_accessible_page(pmd_t pmd)
> +static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
>   {
>   	return pmd_valid(pmd) && !pmd_table(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
>   }
>   
> -static inline bool pud_user_accessible_page(pud_t pud)
> +static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
>   {
>   	return pud_valid(pud) && !pud_table(pud) && (pud_user(pud) || pud_user_exec(pud));
>   }
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index d60e1604852d..f3dd94929d58 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -817,17 +817,17 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>   }
>   
>   #ifdef CONFIG_PAGE_TABLE_CHECK
> -static inline bool pte_user_accessible_page(pte_t pte)
> +static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
>   {
>   	return pte_present(pte) && pte_user(pte);
>   }
>   
> -static inline bool pmd_user_accessible_page(pmd_t pmd)
> +static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
>   {
>   	return pmd_leaf(pmd) && pmd_user(pmd);
>   }
>   
> -static inline bool pud_user_accessible_page(pud_t pud)
> +static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
>   {
>   	return pud_leaf(pud) && pud_user(pud);
>   }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 63350b76c0c6..b977cebb5f44 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1679,17 +1679,17 @@ static inline bool arch_has_hw_nonleaf_pmd_young(void)
>   #endif
>   
>   #ifdef CONFIG_PAGE_TABLE_CHECK
> -static inline bool pte_user_accessible_page(pte_t pte)
> +static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
>   {
>   	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
>   }
>   
> -static inline bool pmd_user_accessible_page(pmd_t pmd)
> +static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
>   {
>   	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd) & _PAGE_USER);
>   }
>   
> -static inline bool pud_user_accessible_page(pud_t pud)
> +static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
>   {
>   	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud) & _PAGE_USER);
>   }
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 1c33439b9c0b..abc2232ceb39 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -151,7 +151,7 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
>   	if (&init_mm == mm)
>   		return;
>   
> -	if (pte_user_accessible_page(pte)) {
> +	if (pte_user_accessible_page(pte, addr)) {
>   		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
>   	}
>   }
> @@ -163,7 +163,7 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
>   	if (&init_mm == mm)
>   		return;
>   
> -	if (pmd_user_accessible_page(pmd)) {
> +	if (pmd_user_accessible_page(pmd, addr)) {
>   		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
>   	}
>   }
> @@ -175,7 +175,7 @@ void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
>   	if (&init_mm == mm)
>   		return;
>   
> -	if (pud_user_accessible_page(pud)) {
> +	if (pud_user_accessible_page(pud, addr)) {
>   		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
>   	}
>   }
> @@ -208,7 +208,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
>   
>   	for (i = 0; i < nr; i++)
>   		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
> -	if (pte_user_accessible_page(pte))
> +	if (pte_user_accessible_page(pte, addr))
>   		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
>   }
>   EXPORT_SYMBOL(__page_table_check_ptes_set);
> @@ -234,7 +234,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
>   
>   	for (i = 0; i < nr; i++)
>   		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
> -	if (pmd_user_accessible_page(pmd))
> +	if (pmd_user_accessible_page(pmd, addr))
>   		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
>   }
>   EXPORT_SYMBOL(__page_table_check_pmds_set);
> @@ -250,7 +250,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
>   
>   	for (i = 0; i < nr; i++)
>   		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
> -	if (pud_user_accessible_page(pud))
> +	if (pud_user_accessible_page(pud, addr))
>   		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
>   }
>   EXPORT_SYMBOL(__page_table_check_puds_set);


Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


