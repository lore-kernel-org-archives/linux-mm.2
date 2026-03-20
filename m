Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843261093180
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3406B009D; Fri, 20 Mar 2026 03:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B636B009F; Fri, 20 Mar 2026 03:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90FF6B00A0; Fri, 20 Mar 2026 03:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4C56B009D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:53:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7486B160909
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:53:49 +0000 (UTC)
X-FDA: 84565677378.09.93887EC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D6F5100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:53:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f4EvclrW;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773993227;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFpbaxQig2N1E9CoxGPFMo/Re1RZWfP0uZzqavx7Efc=;
	b=EU3Xlz/FjIKFd9d0IIJ35GkTL8Y/cb9o6wjXK8yF8giNS+fzwLtgZb5W6fs/HVjTg+sZrE
	rEe0NA+Ol3aiotYDudZYGj4azir7zkgVhsBYwpkuXK2o7Wlvqhaw5H14PDhT3AVQR01Ada
	JiOFC2/eGThIYm6ktqpNUQYtUZy+5Ss=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f4EvclrW;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773993227; a=rsa-sha256;
	cv=none;
	b=SB9au6VXgrptgyYw7nLFPbJeAaBRGjzjMaQ0lH7mjaCQYoE2jeoqCuM4kggyjdqmpDRNrc
	thvHgZXeD7lnQveUINAwTpTQnv3qRDZ0Nl9zhRHcw8+1sXGsoh+pC4pcAhTOsQpKb9OySL
	tb+3I//HEtRWWq1X99Z616B4iBnxa0s=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so427043a12.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773993226; x=1774598026; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFpbaxQig2N1E9CoxGPFMo/Re1RZWfP0uZzqavx7Efc=;
        b=f4EvclrWT3cnyv+BBr/Y1GyeolIC98h6ZxPJYzNXtoO70XFWg9bMOv6DuVaG8wBuVj
         69QBl6j8berPsnF8/UXe+Kpyig0Rrf2jH3wfvh629RjdykB+2ct53rqO2joPqKzVS2nM
         FfMUzoezJKnu5Frxrr1x0UaBgupBfbayqRDTpBhDR/IANbIqZCwdq3dKfDPU1cOad+Ko
         bAYXDSq22Q831S3eSkKFT+oYrfsmP6VnS6kc4Tcdsiw6Z1bC9W9gyLpjwJCPy6tzAQlD
         d//fCzt14R+zqDsy4SVTubiVJyJ9/U8SlNynhtj1AOSzV4Vnn9cNJ8GiuE9uV9nTxuJq
         Qc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773993226; x=1774598026;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFpbaxQig2N1E9CoxGPFMo/Re1RZWfP0uZzqavx7Efc=;
        b=UGAy+kS9SXy1t4zbgOWrC0IUP2qkbJj0joPHkCQukqFAxhifRRGlhQGJlMiRZt/xPl
         kljV8fKJDY/vRCPurQOCEAIpy0vRrCKAbCOP7ySIU34G9U2m2R3+cIKH0AJTqqYartQM
         Lo/ngwrSjk6a0D22zpLiDWXCnqT2r+qfoCGNP5W0TCCfCwCBqJrJXAN5KyWY+IkhdC7O
         I/MsFMfpr1KVrEvV5sV780VnvnC459dB4IzR3s5S/WueGX3s04K4Wk0NKZctiXPsZ9Uo
         NY8FQ3Hc5LBw4J7Yyr4+v8WjU168POyhmU8rcAJbJ3X4dqc1DvndJU9c2Kl5sklaz3Rr
         uCRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlmnp24cl/thQaaeSEo35xDrDBTwfGufDLwSBVSCqln0/Zr01Mq8CKeLxtOIAsYoQOXxMc+S1TEg==@kvack.org
X-Gm-Message-State: AOJu0Ywz2OqqXVCEYMJmd6upM/47QlnKQq7TSNiF7Xtq4tKCIyZYcBVw
	/RLQWEUxdYuS1u7z7ZOmyJ3bbn5Awxp+++TENcA+1TWK11X2ut17Viue
X-Gm-Gg: ATEYQzxC+0ZFPmg32V2fvUQr6bY1gUQSVGk6BAMAVoDkjx1oxxZN8T1e5NJLq9+S+EB
	XM6o87UOnMnj2kAP4qomswLjQgEIGHKKsfXRmLimkW4hMPNpu3ISLnK9deNpLS3BWE/oIHVaYsB
	O/ZwerbiQjd4B0n6NHNt6Fo8kPEEbedex5nBmTtE+s0J5cKkaXXdN0FZSYO2WKGg9y1BRp/AVN4
	qPZMNlBSpFJJAW5BwoSt5l9RAjB8dwpJvQJ7dPPMsxpRpjHBaHy0AKsrjo+4y9Zp9Tx3heL37Nd
	w/APC2TtoHIe8X25OXCZs66O3eWK9eD7mySi45MLjIT+BxaP7g43BvHhe0z+SiXpl6+7DWP4vMk
	Obt0MZ5qStmDt4jUpdj2mlLTyH+ep+DvLERPaRHgZkioFWC2UaVQPGgcmvR1NWpwzS1tJTKnFkJ
	t4bBOb2lUUqqZE4eSziattymJdKzzmHiHM
X-Received: by 2002:a05:6402:510a:b0:668:599e:1038 with SMTP id 4fb4d7f45d1cf-668c90fa1d6mr1647081a12.3.1773993225454;
        Fri, 20 Mar 2026 00:53:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-668cf4f89fesm1056118a12.4.2026.03.20.00.53.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2026 00:53:44 -0700 (PDT)
Date: Fri, 20 Mar 2026 07:53:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org,
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jackmanb@google.com, jack@suse.cz, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com,
	raquini@redhat.com, rdunlap@infradead.org, rientjes@google.com,
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
	shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <20260320075343.zjxztyhhdudbbhgk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
 <20260312020454.qpwjldisaqcstjer@master>
 <ac9a96a0-18d7-489f-aba2-675d8ff1af03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac9a96a0-18d7-489f-aba2-675d8ff1af03@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: uc1rmgrsh1ke47o5b3bchuiebzkek9xp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D6F5100005
X-HE-Tag: 1773993227-286480
X-HE-Meta: U2FsdGVkX19T2SZGO7Mm6sYKVN96MqoZr3yDAE/LsUfP6SNkUf7uBT7aJuVA6LNIpgn8O+Z2CzEnNIllhPD7cvy3ErntVI7ghuyYcVbUskWVOm0k/9GdoZejh0R/lnwr9bSYWqM04muPnupeWEKWDE35zxnZqpdunuTT2pNSWQCTa2SvqyI05uk1RDnhZpUQWX4OiC9z6PLNzSW1hWSPTDxvrMFout0vOkR140iS1Ai3ObJChgZkxiyxLvpONLwCZzx7tDJP7AWe/dx7oNREW2uoSv9nSTz2nXxzQ7lboiIT6iJi4vWmVYjlPK05qT+oTPmaSQ6bBSejXumiuWv7pNOkpUWJw8Ei85am6ZSdGwcdpUmGnamUGOZstNJxfq1QSk4tGBo4MM7BWyTPd3jHcXcBzK/cBjYG9bvIjmzUXELY+HZg4u1Kp67vYuxKoy1Y+Vx1nU4Ce6KQmlsoAoMOObW3+m5cxK5XY4uZs4XzV63xlI7FVjb0FecigDg0pYlu2SvbZ2EOA510UxqKvJnqu/RVGEYof1AF4+jdkz2aiNF92cXD85cmors8NjsCaA1vFUzlVz77774j9L49eq54WGeoSxeicN6Px7h5EmB/Iq9H2Dx5IdzgNCNFO5OaqIgwpqAyj5c6PxGdIYBMZ/ofsiMbVQhJrjbkbyVWd7/+lFZq004DCFBFZ89/NpVZpom3Hrcu4oWqCzFMzJ1EQHsntgDptKE9ogpl7VQN4HdVwjMZWTU+pkTWUFOn/0fsdH8dYsmLMmGP1LRe2zEIrQI0QmY8TMu87y07fV1C+mWO4G8Mq2M3RSCzUZkkaTMcoyx3q8AvxjZPnGUKaNCbTOB7LRB8v+M8l5YngZaPsPaFWdlf4ck9pI3O+R2XyX5d8ziQmtbX1X87IFZzmclN3WxrXn2BdLpdEi3NogxF00nK9XusG5IrZnuRUbkMmdt81EtCW4ml65sOPb4g8UvWgty
 Xq0hBqS/
 fQYqtJU5Uus4+2GqHou/Eez9hu27X9MUNu2hBh4ID5HHCJIB4c3ulG/lEkZiigAYm30l20/U6DmtGhC4GB8XGf+diz4Epxg+UIHvgZPKKpj3+X4Q6Ejvyp1/VP1IUwA6XBQrESjHhfltblBtT7+YYUM3iIoLx9jFRAebVt50TQ7tofUSDgM/zkvDD9AfYkFxN5XexdDOIYmh6s7CLMHj8Q9SPw4sdz5mMEsDhzLl6oLifH3qIsb94+jrTjQeu4NvzsoBPJDNsyVRumF0agHnP0X+b5D9bBZwLkWmulcHuBr/DeegEgRLdTVL8ZHofSEIPLTbxFKEt0g7/gv+4ojomYCQrB4y2L07LWKExa+nCU9kU5heIWPqnaWNSpt4mRzK86jk5laepkiDMPK8ywuG36A5Aq/CjCXZxXx2fQRy1trB987zygpbz92CEU4CUKtITyOltW6HIeKOjQS1bCbeCNbftVuSsQHOcE3q8otFqpjw/e7OLuWs4IL8U0c1AzfBZd8B+Q8dB0/p5pUsfLxaIy1E6Sra5c+UNoYtHn8y/moVfM6YvR1dJCs37/xblnYbVHd2TwbySWIWPQOnjQf7P4eU/Lxm6rUE2WEHYd3SOxzZGB5kA1eRiNg1rIHK4WoyPG3Ut5t3erIa4/5tRGbKi1AcHzFhnfhIU0XV7gl9qMvxbFbPU49iPrjRDYzm/CmP8/N9oxaUdvta/UgAZfPeJetEncPUQ4DPb9UO+ndcg9JX/IRI+eGhKdLEO5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:54:17AM -0600, Nico Pache wrote:
>
>
>On 3/11/26 8:04 PM, Wei Yang wrote:
>> On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
>> [..]
>>> @@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>> 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>> 		}
>>> 		mmap_assert_locked(mm);
>>> -		if (!vma_is_anonymous(vma)) {
>>> -			struct file *file = get_file(vma->vm_file);
>>> -			pgoff_t pgoff = linear_page_index(vma, addr);
>>>
>>> -			mmap_read_unlock(mm);
>>> -			mmap_locked = false;
>>> -			*lock_dropped = true;
>>> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>>> -
>>> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>> -			    mapping_can_writeback(file->f_mapping)) {
>>> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>>>
>>> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> -				triggered_wb = true;
>>> -				fput(file);
>>> -				goto retry;
>>> -			}
>>> -			fput(file);
>>> -		} else {
>>> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>>> -		}
>>> 		if (!mmap_locked)
>>> 			*lock_dropped = true;
>>>
>>> -handle_result:
>>> 		switch (result) {
>>> 		case SCAN_SUCCEED:
>>> 		case SCAN_PMD_MAPPED:
>>> 			++thps;
>>> 			break;
>>> -		case SCAN_PTE_MAPPED_HUGEPAGE:
>>> -			BUG_ON(mmap_locked);
>>> -			mmap_read_lock(mm);
>>> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
>>> -			mmap_read_unlock(mm);
>>> -			goto handle_result;
>>> 		/* Whitelisted set of results where continuing OK */
>>> 		case SCAN_NO_PTE_TABLE:
>>> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>> 
>> It looks we won't have this case after refactor?
>> 
>> Current code flow is like this:
>> 
>>   result = collapse_single_pmd()
>>       result = collapse_scan_file()
>>           result = collapse_file()
>> 
>>       if (result == SCAN_PTE_MAPPED_HUGEPAGE) {            --- (1)
>>           result = SCAN_ANY_PROCESS;
>> 	  or 
>> 	  result = try_collapse_pte_mapped_thp();
>>       }
>> 
>> Only collapse_scan_file() and collapse_file() may return
>> SCAN_PTE_MAPPED_HUGEPAGE, and then handled in (1). After this, result is set
>> to another value to indicate whether we collapse it or not.
>> 
>> So I am afraid we don't expect to see SCAN_PTE_MAPPED_HUGEPAGE here. Do I miss
>> something?
>
>No your assessment is correct, should I remove it from the list? I've been quite
>confused about requests to list all the available ENUMs, does that mean we want
>all the enums that are reachable or all the enums that are available as a
>result? Im guessing the former based on your comment.
>

If it is me, I would remove it :-) Otherwise, I will think
collapse_single_pmd() may return SCAN_PTE_MAPPED_HUGEPAGE.

But, yeah, this is really trivial.

>Cheers,
>-- Nico
>
>> 
>>> 		case SCAN_PTE_NON_PRESENT:
>>> 		case SCAN_PTE_UFFD_WP:
>>> 		case SCAN_LACK_REFERENCED_PAGE:
>>> -- 
>>> 2.53.0
>>>
>> 

-- 
Wei Yang
Help you, Help me

