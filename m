Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A323C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22908E0012; Wed,  6 Aug 2025 06:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA1F8E0001; Wed,  6 Aug 2025 06:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E88A8E0012; Wed,  6 Aug 2025 06:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2168E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:11:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 474C6B9DAD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:11:42 +0000 (UTC)
X-FDA: 83745916044.05.B650A38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9EDF20009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:11:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ctjYqBdl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754475099; a=rsa-sha256;
	cv=none;
	b=VmjlNOgRzALj1LkasEb41ge2fbPi9t6LRfjrMGx3b3Iw5imT5ENfUpJP8c9gFvGSEuHTuO
	eVQCtjols4W24b9M0OhyD0BVLyIGhyaAPeanj30WzX73x5MUS/sq5Tf3vzu3eOZvhlPrCS
	6m7VlOnp+iwvT468tMcBM9mFvQ2QLnU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ctjYqBdl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754475099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qh2edeS0ZaNzvwBPknu4B1s/vixn92FnvJSgkjVQa5Q=;
	b=HdxWFAp0iHMh1DBGiVWHyVjrlZiyBX010tfr2UbVgA2MPeXYMFCzcDxeiSIbcIyRTwD3RT
	RREHZndHFSaGw6084+NdKmojcvfNHfweWnr44tTRcL/VXQqnB7dia5kgiINArR1oIocG5U
	Y8TGVmp9FNE0KFTEOhtHsyB+oVQdEVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754475099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qh2edeS0ZaNzvwBPknu4B1s/vixn92FnvJSgkjVQa5Q=;
	b=ctjYqBdlsY4Suv9th8QI8wRibkVHahxyio8I8cICxD9ThXqBBossLkStKS5P4+e7bCyojR
	lRp670cba5gXfTBhpFkIo58YWKOJOQKtNFkDKJXjBqyhgBsH4F2SZAv0V5ZC710brfs77G
	7FTjZu8ZYo5Wv3spWN6XVCq+Rw8YVcA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-Y_D4JsLRP4S4heFF_aFYTw-1; Wed, 06 Aug 2025 06:11:38 -0400
X-MC-Unique: Y_D4JsLRP4S4heFF_aFYTw-1
X-Mimecast-MFC-AGG-ID: Y_D4JsLRP4S4heFF_aFYTw_1754475097
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45526e19f43so17293425e9.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 03:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754475097; x=1755079897;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qh2edeS0ZaNzvwBPknu4B1s/vixn92FnvJSgkjVQa5Q=;
        b=TOWVjH/K3KrJQ8ybN0uHw2uwyq3zZFutfTJOE5/GB1C87uWfUHZ+8Wd2s4oOvRoe3J
         8OR8SIFSttfzs8yrwjADQMq6xDGq7bA+KsfHfIAQl9rOq4lEeGowNAmLfRbU7pVYmubK
         lXXS/BFNN9DjspkEMvlosXeciAamA35eMmeBqwsgh03YaaMn11SBEYlLB4zbhyBSCPRe
         juYmHTk5/376dMaaLJ+8ciaZ5w2uBZ+0yCRsVhqpLOq07g5AiV3TDXQXA+EO16PQKpBR
         zS7wPMEF6zYWJcgE43uIqlbn8DdkefH+b3NEd3IHEMNozIyY+EKJkaiCNE7dDDrEwmBr
         sC8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+0c6BMLUUkGXbsDI9OmfwC22pwgdpFdrignCpVkmSOePRkLWqk0vULdB1ZD1nDw5FRAU9LICtJA==@kvack.org
X-Gm-Message-State: AOJu0YyXD0vccJIoAlyrKoZ+EygYXHlANPmOSGpGzTa7CUUfECzwrp+G
	Spp8j8154eWdQRd6LcNymKaXNzau9iLms5zi8F88Ctc1cDIicryHIpYkrnmYJFD8LQNNO0L/ol/
	TIBPy1HDoOC63r6516kJhZzOlckiZvzKtta/sgDqLumHmysyMsy6E
X-Gm-Gg: ASbGnctPsZhrHfD4Pt9K8nKSyHeoJHiO4fb607siLZmW6ao6BQxk0dz52EagtNm1SXr
	+ZiNKUHXLruAThEBhYvzt6Vy1liLnSgh9VAlA8cAJrBMn6KDOfgf1LpjFdIKVFsc+G1nBhlN+Na
	v9gHbUX3Z5CbxeO9t8oPfwHsM0Ug+SyA/wyqE6LuqmhcwHl+enWrYmaRjBKT1IuKea1YwOr+xVf
	Q9M1WETZ8W368i8NogLwjK3sxBSrHx1B50lIH14AO/WQhOtqGEMUKSP3h/a80Y74WdE5zOQegRk
	hWrNApq+NH3yt2L98U4fsL3tz/2ciY/rJjqsroT3E4lEZr1Oz94gsWnw9sgrMJGGqUb9KxYwPPy
	NoCNke/t+j4dJ/JMfWc6k/WA8qrD7eAarazOmk1NFQUXm+HAJ2kX6JOeoWolDK4q9bMs=
X-Received: by 2002:a05:600c:4ecd:b0:458:a850:f857 with SMTP id 5b1f17b1804b1-459e711e5f5mr22019305e9.31.1754475096617;
        Wed, 06 Aug 2025 03:11:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECB8a+B/TWDtQecrYAbY89V39jfBkap9mCeJXvk++JnuEAN8c3eY64Hf3618Dec9c0Z5BLKw==
X-Received: by 2002:a05:600c:4ecd:b0:458:a850:f857 with SMTP id 5b1f17b1804b1-459e711e5f5mr22018795e9.31.1754475096051;
        Wed, 06 Aug 2025 03:11:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4a2187sm23345507f8f.70.2025.08.06.03.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 03:11:35 -0700 (PDT)
Message-ID: <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
Date: Wed, 6 Aug 2025 12:11:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GlParkKH4h2ZtvFWnJEZQNT8wr07et9dSBRfm7gMPMo_1754475097
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9EDF20009
X-Stat-Signature: 3r95wg1m6tbysd5xqroxi16r7xkzyan6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754475099-66540
X-HE-Meta: U2FsdGVkX19W3NC3zhE5I2OO7jT7QbzirUYPPI24KHhep2Tje6keZ0WyyroOZTg1ilm6b+tLSjzDxYLD7XbctmofdkHYYRrs1YVM2DlW2HK4WDrKTa+6JaTgctga08LIQEkNuiHbOqHpEuzDoi9GMf67CO3pBSbu9fFyn8kp/NzvawbjNs6FBUswA6pED47Y4lHOflzjTrXC5rcI8GlQ23PNpPGo1cRixNZnB7gvHPC72dqJagxHdbeAlUFeO2MaKjMrM5koiBYg+e9oQrHShnRfm6WcFarpRNGfTYhk7Js4IH4OKBM1U/gTlAKRNHXJM9uh7mzbSf37G/6QoI+FWOzUqUTa7V29+A/uLbEqbyWrp7urz8zQNNOCY2weE5CJbpXfkNxZygF0ppula8qMmRuHmvLK9JRo72Pg0GIeSFY9520nFfglt7zSaOTPZPHUcFGr3ak2wdbvhEbmxOvlkmd5wvhfwHXmFQ+lsES7DjOLB21h2DO39Qvdgq2F1na2vl2CFH1ItX6AVQE1JpdQ6wTfxNs6UNUzVKfAjlHom0RKV6ERRC5+p3cbxSKyQ8RRHtUDIM7oPqhgkBXmYjpdhVWU7iOMDaW4AnZxnoO7O7OFqne11XM34QMAItD3MlSnr0vxnSL4BC75XZFuvlBiBt0wzzjzGNFclrz1c+VZ+tHrzXJ47BkuajQIQt2k55TznWFZfkvbq7MrabBH4yv5MU51ttdOj0pJWVwD2jcztbmrqF2JI+xSj6J1X7f4HHwgsKwERJMFwDp5e7AbaNOROZzzxJVeQX1Fk5s2jhmAAW1McOEipuTQnHh5FR7iMii+9qxOdBgyd8pjmSDQkVThOMqxSfzcgO/2APd2MH9A/ufrI9gLMMHOnfXfMvxT79hp/HvXcTXmcISmetHn4z/Tvo9Pf6UvY+XwLfpIxZ/07QhqqIY4xQo5noQELk8Co1NZeZViipUlHiIFQ9sqXI1
 D/PO8HUy
 dI6/fSu7/jLZr2FsB4TH9UIZyV6MsJGBRvp6FMmobLvHQIowk2l0JV7Gs+eHPzt6AHlOe2SJ+S1SROwFDdsbZ0huZxNolfxFpNt8F9alV0MAkdmk9UC2xhj71CHeQeXHpxtMvtWk8qt68NjinNWEpme70juI70Fr1n5LSpkRHCPvjOrUH6jlURjCTHa5JbpP5O5TrrqYelvwOYoxhlNm+t8DS0qv8er49cfU9dGfxmmE/hZfY4HlNDgG1IBccdtZYf5Moe3h6fwDP7+Z3JAPWh8EpUT1MxKY3pK1Mj7MHa6S0uYe5kYhH2lr7P6Dwbw4dNnmMq9fAUYjIIv3GZDZQib6lRL0Y0CKqVqoFTiVj5mCPkYLmbN/N0PRZ6yxDbPvFMIUdfxLUBGx/0JKd+Fwd6oTTX3WA3BIrxg3XCErY7MtW9Anp+TP0acEvoNprk2Bmkx+2wzTQq2svAyOpfflwv1ixGCpKL7//Lm//bJLtJik6TAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 11:50, Lorenzo Stoakes wrote:
> On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
>>>>
>>>> You mean in _this_ PTE of the batch right? As we're invoking these
>>>> on each part
>>>> of the PTE table.
>>>>
>>>> I mean I guess we can simply do:
>>>>
>>>>      struct page *first_page = pte_page(ptent);
>>>>
>>>> Right?
>>>
>>> Yes, but we should forward the result from vm_normal_page(), which does
>>> exactly that for you, and increment the page accordingly as required,
>>> just like with the pte we are processing.
>>
>> Makes sense, so I guess I will have to change the signature of
>> prot_numa_skip()
>>
>> to pass a double ptr to a page instead of folio and derive the folio in the
>> caller,
>>
>> and pass down both the folio and the page to
>> set_write_prot_commit_flush_ptes.
> 
> I already don't love how we psas the folio back from there for very dubious
> benefit. I really hate the idea of having a struct **page parameter...
> 
> I wonder if we should just have a quick fixup for hotfix, and refine this more
> later?

This is not an issue in any released kernel, so we can do this properly.

We should just remove that nested vm_normal_folio().

Untested, but should give an idea what we can do.


diff --git a/mm/mprotect.c b/mm/mprotect.c
index 78bded7acf795..4e0a22f7db495 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -120,7 +120,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
  
  static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
  			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio **foliop)
+			   struct folio *folio)
  {
  	struct folio *folio = NULL;
  	bool ret = true;
@@ -131,7 +131,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
  	if (pte_protnone(oldpte))
  		goto skip;
  
-	folio = vm_normal_folio(vma, addr, oldpte);
  	if (!folio)
  		goto skip;
  
@@ -172,8 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
  	if (folio_use_access_time(folio))
  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
  
-skip:
-	*foliop = folio;
  	return ret;
  }
  
@@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
   * retrieve sub-batches.
   */
  static void commit_anon_folio_batch(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
  {
-	struct page *first_page = folio_page(folio, 0);
  	bool expected_anon_exclusive;
  	int sub_batch_idx = 0;
  	int len;
@@ -243,7 +239,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
  		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
  					first_page, expected_anon_exclusive);
-		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
+		prot_commit_flush_ptes(vma, addr, ptep, page, oldpte, ptent, len,
  				       sub_batch_idx, expected_anon_exclusive, tlb);
  		sub_batch_idx += len;
  		nr_ptes -= len;
@@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
  }
  
  static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
  {
  	bool set_write;
@@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
  				       /* idx = */ 0, set_write, tlb);
  		return;
  	}
-	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
  }
  
  static long change_pte_range(struct mmu_gather *tlb,
@@ -305,15 +301,20 @@ static long change_pte_range(struct mmu_gather *tlb,
  			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
  			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
  			struct folio *folio = NULL;
+			struct page *page;
  			pte_t ptent;
  
+			page = vm_normal_folio(vma, addr, oldpte);
+			if (page)
+				folio = page_folio(page);
+
  			/*
  			 * Avoid trapping faults against the zero or KSM
  			 * pages. See similar comment in change_huge_pmd.
  			 */
  			if (prot_numa) {
  				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, &folio);
+							 target_node, folio);
  				if (ret) {
  
  					/* determine batch to skip */
@@ -323,9 +324,6 @@ static long change_pte_range(struct mmu_gather *tlb,
  				}
  			}
  
-			if (!folio)
-				folio = vm_normal_folio(vma, addr, oldpte);
-
  			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
  
  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
@@ -351,7 +349,7 @@ static long change_pte_range(struct mmu_gather *tlb,
  			 */
  			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
  			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio,
+				set_write_prot_commit_flush_ptes(vma, folio, page,
  				addr, pte, oldpte, ptent, nr_ptes, tlb);
  			else
  				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-- 
2.50.1


-- 
Cheers,

David / dhildenb


