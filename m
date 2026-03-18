Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5602110775E7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5376B02BA; Wed, 18 Mar 2026 12:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955A96B02BC; Wed, 18 Mar 2026 12:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E3C6B02BD; Wed, 18 Mar 2026 12:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BED96B02BA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:54:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 188C01A0688
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:54:29 +0000 (UTC)
X-FDA: 84559782258.19.2C59091
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BAC7B1C000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:54:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TRQoWLI+;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773852866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OuDH7w+MEOkpCyOkBC284YTNWCtVlDRe0pmxFHD+ck=;
	b=s6EOPp0kGDC/QAF8lcuDkjLSj9kSLELYa4F/eUZ/tykN3Pz7Xxoly1DiedlJXqwTSOdAOf
	RfkfX5/+j//x7KPxxg1pk/GgFUWZ0ilsK/HpVeHcuhRZvR17f8kPD5+h6elGi+n0o22TlB
	9nAIDU3SNhqeJyHIS3FVeB7HKvr25eU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773852866; a=rsa-sha256;
	cv=none;
	b=PiX2nC1xWTfxGq7rn7pv0P30XTHYVdbbuhUNRE2WnFLY+TabcqxWTauEqaxFPRp1ffew0v
	Q5WkXkcmf7cEXbsaPgJfvblUaXz9G0L0GiO1tTDKjwKGtzY0LytGvWJoCKAV1ZjiQq4ejH
	naoFIx0ZW7RRaFbJMWU6ClAnA6WMWpI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TRQoWLI+;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773852866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5OuDH7w+MEOkpCyOkBC284YTNWCtVlDRe0pmxFHD+ck=;
	b=TRQoWLI+AwIqHGLuy0zas+naJhpSpi7niHW1L0c9d7iJh5bLsh7NWmEATrvr0dgmYYSvtM
	+0GLahVjYFVkxKeUDstCEIQ79E+IFCG67/qTQjtk6210OKDOragJ7tasNtYwYTPuCXUE+T
	oxYzqMFDhvhI/gjn6n+HaK0dO30l4C8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-DWx-Q8c9MDyZ0yXQ1WvdVw-1; Wed, 18 Mar 2026 12:54:25 -0400
X-MC-Unique: DWx-Q8c9MDyZ0yXQ1WvdVw-1
X-Mimecast-MFC-AGG-ID: DWx-Q8c9MDyZ0yXQ1WvdVw_1773852864
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5093b92f327so342631cf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773852864; x=1774457664;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OuDH7w+MEOkpCyOkBC284YTNWCtVlDRe0pmxFHD+ck=;
        b=d7zIsv5UVRm5eh74XpbHYK1F+f52OJiRCZMmG8cmSxPGWc0osR7Apkmon5QDFvy7hE
         2iAeVB5LNsFnsNiqNxjrk2TZl1u6jqFOlCNhqcxILNG8gz/CU6S0jLbgb0kQ4WtFiGh7
         5cJiKojp86k/Snb5YMC/4ij3L++UYqBckL4WBY8pXToLSh9vEu5wrAqgap5tcoOp9aGv
         jUn1eL4qqUGmdTX3y1q2P30gMM3sDp3dU3fmhTJxrfrJ8GIbNX2V2tRgB/tjOZe/Xxft
         j60A2zKLAJkGf8uhCiX+q/JLNo3HH+C0SxULwAfrh4in91oALR7pyTQ3SP3P4Al+/srl
         Ct1w==
X-Forwarded-Encrypted: i=1; AJvYcCWCdVTKuzi4WcovKfzBQPGdVqFztn79TWIftZCR/7Qa44u3AONYaPPW2IRJbVmK0FQ/saVYilGOPA==@kvack.org
X-Gm-Message-State: AOJu0Yyq5ExbCal5NpsBBu3Q4Aa9SZj/UcDcJbhX+XOrSZMjEJMZ2ZoY
	7cDoSykVe6mQLoi6PEaiWXvrKYlWUdPDqBsSlt//Pavm7jShhEjeJ/BWnXKoO43NnbvPZpLfb9J
	Zfrl58URZ8dbHo6MAmx6SU7IzqovtIz3PqFsKSoN65s+XfaQsC848
X-Gm-Gg: ATEYQzxA5ZawqSdNXtvpV3cfYG4qvDd2TSfH8fWsMLmcSyMgj/YI1TWDmkM64scIuLq
	R5QOrnVLWbxYp7uBTqCYZd2koQ3Yfvladhyll9TXTVNvCKpdS8bBfzvxzY336mfdraaYJ7UWxqZ
	EzD4fdfBzwyGnfNo9SP3Tf2srzSqOc8p/BrEfm1MhpzeRkG4vSvPD8wwZzDkaOvHMiwdAAQcpAB
	FUv8uUbwDo65nP/pl+1JHMzqqheEcjGEWX6Q7CjhuAnFhwPL6WDOiK7LN5AgQ6/hiUKwZa5rKjn
	WkgK5xxgGqDzWmW0fvoYRTUhfYrzf/7GRWhDqyjzwv/K+m4B8QF91BwqlHgtzc/UsFGECaGsW/i
	+8Kgrz20uRrHRYf9Y4pGVKAzS0rgnjBg1U1OmrUwlJ05PCeTiNb5VSmNBQ5a4
X-Received: by 2002:a05:622a:5d1:b0:509:1253:fb27 with SMTP id d75a77b69052e-50b1476270amr53569211cf.15.1773852864241;
        Wed, 18 Mar 2026 09:54:24 -0700 (PDT)
X-Received: by 2002:a05:622a:5d1:b0:509:1253:fb27 with SMTP id d75a77b69052e-50b1476270amr53568281cf.15.1773852863475;
        Wed, 18 Mar 2026 09:54:23 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b135d6194sm26020621cf.28.2026.03.18.09.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 09:54:22 -0700 (PDT)
Message-ID: <ac9a96a0-18d7-489f-aba2-675d8ff1af03@redhat.com>
Date: Wed, 18 Mar 2026 10:54:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
 ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
 surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
 usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
 <20260312020454.qpwjldisaqcstjer@master>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260312020454.qpwjldisaqcstjer@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YuOyo83pg-upeWP_cik1ll42tP0lJrrrO8WXfL9_lM4_1773852864
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8tsmik9bpa4677p7wo6sk5wuijd7jdjr
X-Rspamd-Queue-Id: BAC7B1C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773852866-436751
X-HE-Meta: U2FsdGVkX1/uhuduveIF9r+nM9UnZkY5pOXUd/3PCMm0NkcnHEcS6mjryBUDncsOeKaqaiTaqvG0IwtEcxN1Ewyb+BxAX/z9XAbyHSFHriaq5/PcTudOWmgjLpWSYMFqOvelk95dPsZpJtpkmITR1IC0Wl1RBMq9eaX2IzuGHpIEOotUv6ksXLSGjbnzTqwGlphKkOcmshIGF1CsfTrWtUPTfFDOd7wBu5pIMPftfodiACO+p0fQlifibM3iJPya8ruZOTpBQFB2DWHfmr8z2Qoy3iNIH1dv2enoQiajLBj+Vv99Ow+Tc7k1VVPiOtn+vMmKnOJm7r58GxyScjIJTziBfNVwUqbMGBtjtknTOr98xIPXpS+U5hDfaoJ+Wf8+CkQTcgeykJkVspfLa/JT/AAFuUPrwe5iunkRmf4+d3lXel4kPyRQy9aycTJs+7ZarY2bgs+Esrz6gtuc3FP5TFcHmsAY36aKdPbg1rFs0KVdfn5BzZi4fgDIKvYRwHFtyTtIwBSoimY/PLUR0OvuPD4ZtuHBfEskEzBO1yhoDuRoLmbBvJ8Cvla4IDwy6iDLbrgDkqSXuC900O3qnPsXtchWGzmVS74RMZCGwAarbkL5z4JW9yj59wVz7qNkhHCe8Lz5x3CPlMP3ERu1eXHV0tZullkqfCRIl/f/++i7AcPJphNKtcPnJ17KoHaF8sMBMXTrsMKAHGtKRhOYNPZhR2NIGRCZdoNQ30ZabyY0sUbR8fA7SCFOCSMD+epmuId0TOsqa6LefKONwZ6npRIDS5TPZIIZFUpqIZnSn/UDEtpOrYbhRFKxSOYMaIwsQBLeD8LwLeaD/nMVJ47WZvub3nYGUQthBri3urnqHzMDQxYSJdJZ4E27XHOT0X2Os2t/vXXPDn269esVJzGcVAeKEL+HCsLM+0vplFgh3Edr20pheJhlAdR1DHcxFJS2K1/0elN5/uUPwhvAvRW5Tl1
 +tn80aia
 baMKe2t/h5DEI7dI0u3hd0yQX0Z3mxbuho0Wim/kS1ImxG/19gAsweBzf9/P8CUdqha0nHUQgrZElk5KB9EP1beXWLsrjH1ecP/yXVcKEQe/eXgfBIyy42hmxTdZRHvmZCVjZBdLnaCutkMU52jenUiHSe9DnmOLMFuiSuDCyXbRvojOolCznORA409SGMvexoMferlx5bPXZdhtUtbJbEvnxU5H4if6lXpMD8OD08waerO3cbDusZolb1zUYgQNYd3dPYYjWZpBoF9eYDWGAcLFbbyDs2Q2uoMt+MuRHnzVx4Pr37gMb1lfuTgGJba+hnISDNjtkcpiNpj/a+bjfy5x5jdTUYFf9xwXmk46nBGjtRtdDVdeOnps7HhCBNCT+wXi+klQQTzTk+QsJNB8vOxq0aD0YxknKJzolq45Eaj/H9YMqYWdkDQPlrcAcWpjy+eZ4c+MN4rnlRQ6YZEVn4G8AV7SqMe9tEok6762MMr45UVlOWcgILBYOW+O5ysnYYdVDGxGMn93o5q8ma3mSkPoStlZuJaNszMAgzBH2ra1o6yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/26 8:04 PM, Wei Yang wrote:
> On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
> [..]
>> @@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>> 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>> 		}
>> 		mmap_assert_locked(mm);
>> -		if (!vma_is_anonymous(vma)) {
>> -			struct file *file = get_file(vma->vm_file);
>> -			pgoff_t pgoff = linear_page_index(vma, addr);
>>
>> -			mmap_read_unlock(mm);
>> -			mmap_locked = false;
>> -			*lock_dropped = true;
>> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> -
>> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>> -			    mapping_can_writeback(file->f_mapping)) {
>> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>>
>> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> -				triggered_wb = true;
>> -				fput(file);
>> -				goto retry;
>> -			}
>> -			fput(file);
>> -		} else {
>> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>> -		}
>> 		if (!mmap_locked)
>> 			*lock_dropped = true;
>>
>> -handle_result:
>> 		switch (result) {
>> 		case SCAN_SUCCEED:
>> 		case SCAN_PMD_MAPPED:
>> 			++thps;
>> 			break;
>> -		case SCAN_PTE_MAPPED_HUGEPAGE:
>> -			BUG_ON(mmap_locked);
>> -			mmap_read_lock(mm);
>> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
>> -			mmap_read_unlock(mm);
>> -			goto handle_result;
>> 		/* Whitelisted set of results where continuing OK */
>> 		case SCAN_NO_PTE_TABLE:
>> +		case SCAN_PTE_MAPPED_HUGEPAGE:
> 
> It looks we won't have this case after refactor?
> 
> Current code flow is like this:
> 
>   result = collapse_single_pmd()
>       result = collapse_scan_file()
>           result = collapse_file()
> 
>       if (result == SCAN_PTE_MAPPED_HUGEPAGE) {            --- (1)
>           result = SCAN_ANY_PROCESS;
> 	  or 
> 	  result = try_collapse_pte_mapped_thp();
>       }
> 
> Only collapse_scan_file() and collapse_file() may return
> SCAN_PTE_MAPPED_HUGEPAGE, and then handled in (1). After this, result is set
> to another value to indicate whether we collapse it or not.
> 
> So I am afraid we don't expect to see SCAN_PTE_MAPPED_HUGEPAGE here. Do I miss
> something?

No your assessment is correct, should I remove it from the list? I've been quite
confused about requests to list all the available ENUMs, does that mean we want
all the enums that are reachable or all the enums that are available as a
result? Im guessing the former based on your comment.

Cheers,
-- Nico

> 
>> 		case SCAN_PTE_NON_PRESENT:
>> 		case SCAN_PTE_UFFD_WP:
>> 		case SCAN_LACK_REFERENCED_PAGE:
>> -- 
>> 2.53.0
>>
> 


