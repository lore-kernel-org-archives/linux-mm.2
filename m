Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D090BC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25C76B0088; Thu,  6 Aug 2026 15:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCB96B008A; Thu,  6 Aug 2026 15:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1DC6B0092; Thu,  6 Aug 2026 15:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82CAB6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:51:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1ED5D1401D3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:51:45 +0000 (UTC)
X-FDA: 85071889770.06.34226DC
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7812CA000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:51:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=YxHt4sU1;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786045902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkmaNtQ8BSIkFCQ/5kE6NoXn5l5qzjWnoHIHZn2DAkI=;
	b=MQPUbSNTAh+fE82XL45+9OqWn5NiEINdeeuHOfhLdQM7HklkjiM9k9puKsLKIUd0t8CUHk
	Uk82wUMAzLWjY+so2dEqJVSPJe3Ail27LfypnOIZTnuze4e1R56l3BuP2EnX4VGF7x3gtK
	7uNzweysF/msjbijZNVDmHdogTSGCjY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=YxHt4sU1;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786045902;
	b=v2klGLqDQODVt7mX2YAbU0Mexwwl7XegW3il5RI0i/HhspaCHX27YycnLh6VKCZ4yEp5bq
	IEP1Z9gtZkT1q2NofLyyPObT0y44w2XOrL0107SRX1EPmGtHaNoNy56tu3zRTIrourjAGX
	5ORpqjBMYIh6jsqUp/Y7Ob+qe7cDjOo=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676IYg0G449479
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 15:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Zkma
	NtQ8BSIkFCQ/5kE6NoXn5l5qzjWnoHIHZn2DAkI=; b=YxHt4sU1bLe939IWOhZb
	iVMmeBgmLwWs7T31I0opvtRBd0Nipn73SR99bDHGSlepuLOnV0Qgyt4RI5h5RRrV
	NA6iRkzhwa0faVOYd94hoCW+jnQtUot0zZqwgoU5fmQeZjZyXNDK0VMBcBUOCTH7
	fwoUbvzoe1Ai/S1oI4Xj246I/6m3WDt95ZjM7EdrFgnsKcV8n5D1snn8JJOCmaHK
	4fYcWO1QlqRfRcd0F4Pk+5P6bqZHXNEr4IiwDayCqCMUMoDyb0jppMuqUuny+xVb
	rXFOEkWflxcTfPBs60DV1RZFaeUdravsdMUMrVZE6Vg+8fGhl8wrqP+iFWRkszAA
	yA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fvy3s8tgm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:51:41 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52b4f6ac06aso40909011cf.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 12:51:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786045901; x=1786650701;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZkmaNtQ8BSIkFCQ/5kE6NoXn5l5qzjWnoHIHZn2DAkI=;
        b=jKpO56xMl924+mD1i92/h/nBYrt5rNGl3gXRf1KnILfhbV50LvflxV9pPV4DsBE+vS
         GvZZKmr4Bjz7911Bsa3aOPqZ8BzRP8vth/acIsLKinQlHJ3OQe4xQtgWHc6t2nxNYbpw
         HKnu6HoYCCmH+tzB4DpW9HJ40N6WcLbyPUdvms2aTJx+9gIgRuax91YYEPOPOtNVMdl/
         l3xJLMtDY13wZLCnqTWt4RAbXaJTzVuDcYSqADlu/QbGXU5kag5BrAmK6aPqPB6k+Vc7
         BjbpGRjbt+HggsxCU2UqoREx8LA3ZjKz/MrE0j5UiB9h9uZFwcymDZ8HICdkvVFWp1rP
         zOfQ==
X-Forwarded-Encrypted: i=1; AHgh+RpmrAO9FaaRYl2QcRMyMu0g/rIk4fKyUOwaPIvh4XCqteUOhxgee6SJQ7VBK9dyVFXE4/7RSekJRw==@kvack.org
X-Gm-Message-State: AOJu0YwGFY5zRQ1FOOBKn72RAVowbxekme9udnGaFnhmMKjSEsZu8sjP
	GZK3IIZFH4M5enMfm5biZW8srfTVyeiGorueIQdkFF74VSl6gGa5zIZ0StJQo+7FxfEPqWHyxAC
	Dvn226jRgJZgys9WAH7X42OF5a9s96KY6jMZvfDC7HbSuRxp4
X-Gm-Gg: AR+sD12fAE5+rILKYG4k1ZczJ79e+4zULKp/y2+FZWRdaPmQCBy+jR+1ws1woSb0ZIx
	rmStN33ePodGArrh4drZx352ZDRJrKCcQF235vbcju5GCIPuwmkOpHCiJcr9FThdPPeaYLxUhXk
	1EB8jTX82BBex8TErk0j21pKUyyiESessY7ICEO8pHm5mNjU3W+rchIMyzFh5o5yXcBrt+TEYbl
	M4Crl/VSb2HZRnVwY6zttiuiBJXFAEdXdhk611hk9pC86Pva/BO8HeBdMwOouh0kjBtKR7X3kQZ
	C0Ec60YGJVvXjNaep9sghOkYLvxBZ7GxtgN8CaPPOdS0pQANbHSawYxhGlBpAzw7iuXpg2OCMm6
	/2encF7/JORIDINBbWkv07wfCfhJHSbHblk7tZ4kF9WJWTRCofpAJqed2SM6TbIip
X-Received: by 2002:a05:622a:261a:b0:516:d83c:edb6 with SMTP id d75a77b69052e-52d0b06e247mr51577191cf.12.1786045900672;
        Thu, 06 Aug 2026 12:51:40 -0700 (PDT)
X-Received: by 2002:a05:622a:261a:b0:516:d83c:edb6 with SMTP id d75a77b69052e-52d0b06e247mr51576641cf.12.1786045900174;
        Thu, 06 Aug 2026 12:51:40 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:b593:3821:1a47:8a5e? ([2a00:a040:199:782e:b593:3821:1a47:8a5e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79b529fsm9689344f8f.12.2026.08.06.12.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:51:39 -0700 (PDT)
Message-ID: <43fbe30d-54da-4bcd-ad2e-5391b327b642@columbia.edu>
Date: Thu, 6 Aug 2026 22:51:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] ceph: convert ceph_submit_write() to folios
From: Tal Zussman <tz2294@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-5-81f0ab065284@columbia.edu>
 <f835fc25-7841-47ff-bb2a-7f91b534dec1@columbia.edu>
Content-Language: en-US
In-Reply-To: <f835fc25-7841-47ff-bb2a-7f91b534dec1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=UY9hjqSN c=1 sm=1 tr=0 ts=6a74e5cd cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22 a=b_efBAy1TN-SQDnTdmkA:9
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: srT7kmSGMQP6v6D0hlrX_5eovOCpTDCX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE1NSBTYWx0ZWRfX0V7PZYsjV4P6
 eKnWkVcqorSf0Bf8Sp/9tGWwNAXme5GrcbLbt6ylnKFM/dfm0wTKN3QlZEHt6rONq9Nt1rUFEKR
 +3B6QIazD29OKLVZRDVnD8DfySm+RVaawwVMIVEvKugLy3euLOmG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE1NSBTYWx0ZWRfXyssdnplBJoW3
 IvYfwXmWbVnELvZf+E0Twa+Z90K+Xk+MeMB1pKrKwAQOvXc+cf9rXbt08gWYsw5+cLs9r75yR41
 pS44ApIveRHZ22DQhtGJli9bJ7WzqODE7X9FARQQyIUD5l20F1rtobHthlvZ20SwZmEum6oO/Pc
 DP/09RyE0Hi3mn6IvX8L38kqCVYfVaIm5+ZtuIe6+HuVlUz0ynAThGnOumm3y53x3utMiHuJttb
 0RDwpZhfkchZLSoSXIuEWCiA3mpgiEpzF6ceWRKqyeYiYOlgaatUlii4rq6+iVXL6VJv9oDz1xO
 zowM+N7xKfNxJkF0zsgRgAOSR4iLJVX8ya97oz+964jWoU0vnOV8i91tYv4yTI7SDYybQg2DHeL
 b7pC9TIAiqS6nLW+n9/E91vrkEjH9I1oxtimN05qf+LFNxkq3xNy/qjxqnpc7XBJXycPfhe8ndi
 iiuADn/MgUfFIwYp1Zg==
X-Proofpoint-ORIG-GUID: srT7kmSGMQP6v6D0hlrX_5eovOCpTDCX
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 phishscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 adultscore=0 lowpriorityscore=10 bulkscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060155
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7812CA000A
X-Stat-Signature: 5ck81fykeo5y1nxo41kn7zn1x8fb7cyc
X-HE-Tag: 1786045902-761600
X-HE-Meta: U2FsdGVkX18/xgitAtTCwcac7opqYNB5Vwg0mLFAdslHI9TG7Fs1TtIL2QGmKkPsdzRaX/1wbxA2pnXO+WnREGM2fD7hx+LOqhrLrEachuSkaVXPm4bES22lMU8Ea+JdQxmGq00t6Sq1K7dXJ5dnt32G11EU1jsoHvmKux1B9cY+7YEaSJucDUx7og5Ins0XvWIv8g1D6Sg39bAQjhcZEbJdn/HbG3s05q0u3X/hVYNGV9Fbg/uwH7tXcU8yis6/KAfY+G6OtBNJETNPquQ4Hmal8P0Li+NKceu9u4AW3stmeGHuDV2NArNONVBJspcVyYSC8LlNT1MusFBdHIJhMTywWmo+ayZ/yPcpHbz2foDM3s5A1O6xvVtt2Vy6wtjOLLAmY1NeO4QyVwrJv/oRbuoq+OdYJj67b4GIVz1GEZcEfeJRGUMz7FUe7PgNyDvCx3KndYshaUvRylp1u1Ku+6Y9FZqni6PpCGx0xX04xvz+GPP4ZDzeg65/woo4sebyXiPM1tSCoKWqJFtGNO5YTalGIu+TJV7J1KRUJ5KqDDhpRqrEpadyETp1t94p7zlvPGhD/mDgyIBsAb0mCYjDYd/4F3x09tvwzbZW5bnbgwru7WfSxqnWOwLIVwlPfvTXjBZ+pXj+ROHI+Wz9yQfDHac0Tz6Z2jERJ4T1sHEGvm4G/83uwyLB3pX7J6dRCSN6VG6Ir+nNPMvkcyDlKZcPAq//zJDnv0dYofPpLxJiJly7fcKlxcvlQ/z/YeF0XCLAFo+5aV2j4ibctf5Pc+iTMZuWegF03DEECnLBiLhsgmecn4SuHVlmdoVY2kF2QY40pq2LsxCz1UWDyf1TF9ISsZfssgg+EN2QnH/l2vDusZ8og0opfAEaNTrffJbEMKJzRF4kNZW8/E5+zrqUJHouaqMtVjJNVjz9t/qdf14vf0LjN1C33ESlgVzBhxENkRfV6cN7Rti/lUW8CDpnexp
 drTJl6k9
 vxW4b00m7g5HRoLisYJRf1hi4SRe8OGaGdbRQQe16HAaAAi5QoNsxiY+GbEdUMwXCdRKHwmnFvrs6RuiRFCynMjwbEu7HJ+TeosLnCBNPLQIx+lcWh0MMgZ5jU6MeK4i2fQtXZR7LNWkIpuSWtaur9RrLXZiC9o+ESLPFcA3UvjM9ztJW/I8jyJdhhzS6aKH+wpZQsJnTnq9lasy/osguQHtUJnt8+3UEVp0Qr2RLAUl/h0+Vh3wyKUJzcsaEps7oVdoMarxWhQ5sD9x2GVhkd9jQWp5S/hFHoF2UG/Hbz84PXLJZmimpi7wISTUXFQbzhbKHGRrSczxMmH2IRkSz+G7xVStZZO9d5iHAAn0aBlnz+OHYiYDMYyyPuSQQEXqPYcuQr7Y5dsNh3NfCi7qn5Ju06G0/KjI6MVguQ7igxGOAzg7Hjrdvb7iIFQXu/Eo0Ml/scPrEf8ZdPeQWBUCmS3+Q6gMEnp7cG3i1rdKbfxRHMK61n31Oy7Eb/Ts2wSdpu0mbww7yDfPpN5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 2:58 PM, Tal Zussman wrote:
> On 8/4/26 2:52 PM, Tal Zussman wrote:
>> @@ -1436,14 +1445,14 @@ int ceph_submit_write(struct address_space *mapping,
>>  	struct ceph_client *cl = fsc->client;
>>  	struct ceph_vino vino = ceph_vino(inode);
>>  	struct ceph_osd_request *req = NULL;
>> -	struct page *page = NULL;
>> +	struct folio *folio = NULL;
>>  	bool caching = ceph_is_cache_enabled(inode);
>>  	u64 offset;
>>  	u64 len;
>>  	unsigned i;
>>  
>>  new_request:
>> -	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
>> +	offset = ceph_fscrypt_folio_offset(page_folio(ceph_wbc->pages[0]));
>>  	len = ceph_wbc->wsize;
>>  
>>  	req = ceph_osdc_new_request(&fsc->client->osdc,
>> @@ -1467,29 +1476,28 @@ int ceph_submit_write(struct address_space *mapping,
>>  		BUG_ON(IS_ERR(req));
>>  	}
>>  
>> -	page = ceph_wbc->pages[ceph_wbc->locked_pages - 1];
>> -	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
>> +	folio = page_folio(ceph_wbc->pages[ceph_wbc->locked_pages - 1]);
>> +	BUG_ON(len < ceph_fscrypt_folio_offset(folio) + folio_size(folio) - offset);
>>  
>>  	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
>>  		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
>> -			struct folio *folio = ceph_wbc->fbatch.folios[i];
>> +			folio = ceph_wbc->fbatch.folios[i];
>>  
>>  			if (!folio)
>>  				continue;
> 
> This, ...
> 
>>  
>> -			page = &folio->page;
>> -			redirty_page_for_writepage(wbc, page);
>> -			unlock_page(page);
>> +			folio_redirty_for_writepage(wbc, folio);
>> +			folio_unlock(folio);
>>  		}
>>  

Actually, Sashiko points out a deeper issue with this loop:

"Could this unconditional folio_unlock() crash the kernel?
Looking at ceph_process_folio_batch(), folios that fail folio_trylock() or
are already under writeback are left in the fbatch array without being locked
by the current thread.
Then ceph_shift_unused_folios_left() shifts these unprocessed, unlocked folios
to the start of the batch.
If ceph_submit_write() subsequently fails the ceph_inc_osd_stopping_blocker()
check, it iterates over all remaining folios in ceph_wbc->fbatch and calls
folio_unlock() on folios we don't hold the lock for."

...along with 5 other pre-existing issues.

Seems like the folio_batch loop here should just be deleted? But that seems
like it should be a separate patch with a Fixes tag...

>>  		for (i = 0; i < ceph_wbc->locked_pages; i++) {
>> -			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
>> +			folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
>>  
>> -			if (!page)
>> +			if (!folio)
>>  				continue;
>>  
> 
> ... and this check are unnecessary. ceph_fscrypt_pagecache_page() can't
> take or return NULL, and ceph_shift_unused_folios_left() compacts NULLs
> out of ceph_wbc->fbatch. Will remove both in v3.
> 
>> -			redirty_page_for_writepage(wbc, page);
>> -			unlock_page(page);
>> +			folio_redirty_for_writepage(wbc, folio);
>> +			folio_unlock(folio);
>>  		}
>>  

