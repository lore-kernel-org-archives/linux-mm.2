Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603551077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A1C6B02E5; Wed, 18 Mar 2026 15:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AD66B02E6; Wed, 18 Mar 2026 15:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9A66B02E7; Wed, 18 Mar 2026 15:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1306B02E5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:07:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 000381A0127
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:07:41 +0000 (UTC)
X-FDA: 84560117964.11.FAF9C43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E8C240009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:07:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3ImtLCd;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WixAoxfcL5jhhT83Dfur4OdwyV5TsF5FITSYI32Dans=;
	b=QJmW8xKPqANzMaHBHXxFvJ+0hiZx3DxYTFGqEnm4btWCNtQDhiau4XueKjHIyU/hp23GvE
	tiThIIiY0R7opMkNgfsy1AQHfRYNSn+uKFTcEs1keugynwHO2YHWJT6bpvJywwJCscf0W0
	QeqPYSF3d4S1qCSC/Y/ps3ylBWKqmJI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3ImtLCd;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860859; a=rsa-sha256;
	cv=none;
	b=gPrU+dKp4CLV6PdaQsc4BPkWHdSJMWdvFJYJCDCp/sVi56I21Yib9bI0/UiLV2BLPt/Hhd
	B4jGiGahKHLs+0LN/QdUZy+4RARNLjTUuGBW+l5v4cO4ufFvOyqOS0RxKfUPfbmaWbJpjP
	c4Z+aB0SDG9/TaZJS7ZvrufRIe7GFYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773860859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WixAoxfcL5jhhT83Dfur4OdwyV5TsF5FITSYI32Dans=;
	b=i3ImtLCdmHyTHoCBnkIYMQ8TKml9iSxPWpDAfdbjvEuAypcEj5WA6vWIJ9xrrtZbMEhykr
	Es9xVNw8o77vuDGTrK+9QiWAvznDGmG67ydWHcc0qNS5tyJHjcVTFFN1LwsQO/yb94SAW6
	PxkYUZZaK4AYKun0cPN05IP8fMGccrg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-HV86Ty88N9GHEW3YFsD92g-1; Wed, 18 Mar 2026 15:07:37 -0400
X-MC-Unique: HV86Ty88N9GHEW3YFsD92g-1
X-Mimecast-MFC-AGG-ID: HV86Ty88N9GHEW3YFsD92g_1773860857
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-89c56300e64so24603766d6.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773860857; x=1774465657;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WixAoxfcL5jhhT83Dfur4OdwyV5TsF5FITSYI32Dans=;
        b=JONzClf1BBENZNSLdCqd42BCXTCzWppBhd1gEohlcXyLjRvvhZrbX0HKcZJN2qQvPC
         MnsLYdjNxs6aHswGe+232cULzK4g2JJ2xGNjDkq3Ve+Cn5t5pxT2RuT0MFLDYJBf43DL
         zC+zUxJ3gMwY3Al14NOfm6x/hKyRpGdBN7vvuvIECP5aBBIyjCmdLBaaZWYADBNBr6Nm
         7EfGNdKWXezfYxaOTfpns7QXSATg6F08StjKcE8iaXcUkrUHVW2QH/Wnlc+KpWJgpAk2
         mD0EECfCbYHQn3vo3UFgSjt0ElwuQxmzl4HXgkD8Scl09HS8wBdMbjDrl+68fFJALwhx
         RsPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXo3v3HTAYBk8whI4/tMjnI5TDDucEE8YMuh819Ft7FzSJfLyNtsve34cJdPQOjo4hb0G1PlWzUGg==@kvack.org
X-Gm-Message-State: AOJu0YwxiE8xsJMNaIPRaweY4TdIFlmjKq422x3i0lIHGgWnszVBdI3C
	VrRdQE/k55eYbLX8qFb0E8V80fl2sz+syX+jtnqtDTqJ4+2fwbl+79S8TroXzJGAptssnChxvVJ
	di+yt8T4KU1r7hbtlMGiL24kI10HBG2Zs1vDROpqt1dFBX1lMfUM2
X-Gm-Gg: ATEYQzxmZdurD1l0ZLpRIEGl6NJicCveLfM+J/gO+FZE5rX9eWyuwa1pOCtCf9jfwMj
	tsHs7xY1agM7OXx5ZpJ2cC2XhD5LxwpGKpBdVott2dXYu/ItcnIKYLNQ0H13BoNkvYNGuZz/JDC
	B+MDqTQxNM6TwaKKAX3Fy3ApZfLNSrFxTtPEXsxIoc4CdWVBt/CyTaqs/nd6VmYSgUgUnNhFdGf
	+k9qkZaKAxLRG5qPH3Fcx0ePfPCsNMnDytSc1kcjqa9OePfjv+yagIMboRw3y0zxPeune1OCufL
	aa2Mq5ebqCDPJfLIIDdRd6jpb3q5dLXDyRQRzRl1Ia30n/9bRbyHS5lVXyDmwrtLio2CoUr3M1h
	KwItA/W7sEiibTwNXmDRv7OxqXJislfFie7USZxz9V9Ro9XntIiTlYD5AhFeU
X-Received: by 2002:a0c:f08f:0:b0:899:fb4e:47aa with SMTP id 6a1803df08f44-89c6b557273mr60066086d6.39.1773860856720;
        Wed, 18 Mar 2026 12:07:36 -0700 (PDT)
X-Received: by 2002:a0c:f08f:0:b0:899:fb4e:47aa with SMTP id 6a1803df08f44-89c6b557273mr60065406d6.39.1773860856280;
        Wed, 18 Mar 2026 12:07:36 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9e9babsm25191566d6.38.2026.03.18.12.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 12:07:35 -0700 (PDT)
Message-ID: <587c8b0c-3004-49ee-a2eb-ef74aa8c4abb@redhat.com>
Date: Wed, 18 Mar 2026 13:07:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for
 all orders
To: Lance Yang <lance.yang@linux.dev>, baolin.wang@linux.alibaba.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org,
 corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226032650.234386-1-npache@redhat.com>
 <20260317113611.94006-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260317113611.94006-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bt_h9khCBrG4oe-dxabb1tbnWaPupgnB97UIPAH1veY_1773860857
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E8C240009
X-Rspamd-Server: rspam08
X-Stat-Signature: 5phq47ckki883akcyxefi48mg9jjh8zq
X-HE-Tag: 1773860859-508604
X-HE-Meta: U2FsdGVkX1941KjGSN5ec6tgJjUaDNuJ4oMwNfM4yMYQ1DHUP1aGPPlMaEg4fWKQ/mpqQ/v2rx2KFs17n6hzXmUjp1I06U73hr4D0HHcC+ztIVPnKkkSY87JOvkQKqt2JlGf/RfVAhoYG0PMmyExJGboe0LvFxbxeKD++buRPVjohElBshjAkjdbvBkTov2MTYxQcVvaa9Wl/dXzkw1GoLX1r9B0dxKcMCxp3rIyKWzs5T8XwuZKhzBNqA1kzPwTNJD2NzZYTogc3pmcA+W/+kJNFC+CzgjBlFIP3RC+2uRIF0Y8t7twD5jz+72ErQmU/UQUZ/HXz/DFWHnOUotO6C9V/Y0zvTSvGWpOiWvA1VUSJZuoBfE5Rm49LdjraaOZsqqELRqL1t8fXTPXTROkhnFr+ZfXFxDbM5g3nWnzOLSrlxiyIUw3mJ+BVIeCUXejWXbFtvRw08z3H2Oay/j0DWIcif/plvjDbK7DzRgSypeBk/bLGuPcT5O+55BE7FDFVDgo4aYj4OW7Z382znuN9zpdRNv7pOKOaQfOzPKGkY/lOotSGIaV1KV/o5qkDXbYJZnxAi/LF7mQjKuubfPLlW08GkypfHLsKF1wsIP7hHD0VBfPTCFwLM+iD9XCVPyZJuU0FWIUskLj5NKxb9chqWnps3BreEI+vuMp0lgZjU58kMLdsSIwHvqjqjEnpeVS3lJ8Po6v6GlM7IQDu6sU51hkILHYXqc+vE0teoTTw8xeYHJdDNLvXwE0YziUQeYonvCUPTOmetAgShn1ly0jO5c+/X7B0pGB1yARPtYv4CLu50ozO46lYQLq3Jst/AYz6DNdIpi6ORmTE0yfwtYakAUoXcyP/ecsaLt4FuSTk7OeYFHDBqbgbVJ8Rmm6M8PWO3xuJmnwsmRSojS1CeOIoCmxjTR/opHWIgPm4e2TLI8aS+AynSWLaKo8q/QgGZIcgohd1ZIJR+QX6waoTDE
 Fqs4pMVM
 abQfe5Hkyifrxl4YgUhhXg55U/S29NFzOl/jiImKfhMptJ7Tn6kppsMhMjsPK5XC7PJgSEFfRo4etXhAA0FPiMI2UcBzzxS2ponq6hMZWLP7Z171yAxuxryl/8D4CejYeJgZoNl+/rVCYiwlkX5Yaykkepga3s+Horh8Fclpf3P3olntln+Kvs+U5QI+rQm1ZlnYlwC3wNnt74/QXi5SkdZdak23CxgQIgmQdJXthQ87br8RRqRJI6tzHPpGCTp2gvAJqEJjgMbLn34BE1C6Zhx8gTALSNOiyVAgfIh0fOC5+LG8tkjYRJuM2chNkkWMvPhInqw8EKAxTTqnqYrNYLdlQsaHsjOiUzY/SBvQGO8K7FULS4QNj9oGOeu4VF4NXlhrfVJrcR8cEhITmz0ndVYmdqwOVwQeEIQTDiX+dWiB66LYaFTqrNlGH+P9AvfC/53Lt0ax9WOsy/0rbIwluE3b1Wr4bt/Vnp/RbTXUiAVydYppicUuxQ+xR6u7SOUzjNJ0xljs+wC3FcOi/pgnS6ClQb27rwQ+RpaMrEI4WCJRoaVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 5:36 AM, Lance Yang wrote:
> 
> On Wed, Feb 25, 2026 at 08:26:50PM -0700, Nico Pache wrote:
>> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
>> If any order (m)THP is enabled we should allow running khugepaged to
>> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
>> when only mTHP sizes are specified in sysfs, we must modify the predicate
>> function that determines whether it ought to run to do so.
>>
>> This function is currently called hugepage_pmd_enabled(), this patch
>> renames it to hugepage_enabled() and updates the logic to check to
>> determine whether any valid orders may exist which would justify
>> khugepaged running.
>>
>> We must also update collapse_allowable_orders() to check all orders if
>> the vma is anonymous and the collapse is khugepaged.
>>
>> After this patch khugepaged mTHP collapse is fully enabled.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>> mm/khugepaged.c | 30 ++++++++++++++++++------------
>> 1 file changed, 18 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 388d3f2537e2..e8bfcc1d0c9a 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -434,23 +434,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>> 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>> }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static bool hugepage_enabled(void)
>> {
>> 	/*
>> 	 * We cover the anon, shmem and the file-backed case here; file-backed
>> 	 * hugepages, when configured in, are determined by the global control.
>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>> +	 * Anon hugepages are determined by its per-size mTHP control.
>> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>> 	 */
>> 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> 	    hugepage_global_enabled())
>> 		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>> +	if (READ_ONCE(huge_anon_orders_always))
>> 		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> +	if (READ_ONCE(huge_anon_orders_madvise))
>> 		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>> 	    hugepage_global_enabled())
>> 		return true;
>> 	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>> @@ -521,8 +521,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
>> static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
>> 			vm_flags_t vm_flags, bool is_khugepaged)
>> {
>> +	unsigned long orders;
>> 	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>> -	unsigned long orders = BIT(HPAGE_PMD_ORDER);
>> +
>> +	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
>> +	if (is_khugepaged && vma_is_anonymous(vma))
>> +		orders = THP_ORDERS_ALL_ANON;
>> +	else
>> +		orders = BIT(HPAGE_PMD_ORDER);
>>
>> 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>> }
> 
> IIUC, an anonymous VMA can pass collapse_allowable_orders() even if it
> is smaller than 2MB ...
> 
> But collapse_scan_mm_slot() still scans only full PMD-sized windows:
> 
> 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
> 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> 		if (khugepaged_scan.address > hend) {
> 			cc->progress++;
> 			continue;
> 		}
> 
> and hugepage_vma_revalidate() still requires PMD suitability:
> 
> 	/* Always check the PMD order to ensure its not shared by another VMA */
> 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
> 		return SCAN_ADDRESS_RANGE;
> 
> 
>> @@ -531,7 +537,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>> 			  vm_flags_t vm_flags)
>> {
>> 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>> -	    hugepage_pmd_enabled()) {
>> +	    hugepage_enabled()) {
>> 		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
>> 			__khugepaged_enter(vma->vm_mm);
> 
> I wonder if we should also require at least one PMD-sized scan window
> here? Not a big deal, just might be good to tighten the gate a bit :)

IIUC, you are worried that we are operating on VMAs smaller than a PMD?
thp_vma_allowable_orders should guard from that via thp_vma_suitable. the
revalidation also checks this in hugepage_vma_revalidate() and is the reason we
must leave the suitable_order check in revalidate() checking the PMD_ORDER than
than the attempted collapse order.

lmk if that clears things up!

Thanks
-- Nico

> 
> Apart from that, LGTM!
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> 


