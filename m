Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6649606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oO5llueb
Received: by kanga.kvack.org (Postfix)
	id 04EEF6B05B6; Wed,  4 Nov 2026 11:15:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF32E6B05B7; Wed,  4 Nov 2026 11:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95216B05B8; Wed,  4 Nov 2026 11:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2A1A6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44AD61A07CD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:56 +0000 (UTC)
X-FDA: 85397937912.02.48C0DE4
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 27AAAC0014
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oO5llueb;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808954;
	b=H3ejmgp0zHfs1zBDZ7Kgt6dNXWSmULwdTOSM+kUi74E8P4fzEp4/hsrKwMEYkRYkX8edMj
	8U9LEM2er0xCplUYuZ0On4VOt0kji9ErtS9Zr4v/a1fYYgbm1h06DUZANKBaoe/D71+B9j
	+OVDGawduI57STNctOYfON3ftsf4TWw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oO5llueb;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fU8AEGdDcjq9JBv57injpYEq2ySiH6tspHTe3WsEnE=;
	b=FiIKzrYFJeXp4FsQG06zHUpX+ysP4uUcdvd9YSwhUgwssqt3dggTWB0Zcua24JS7RtnqWN
	NQrDWFEDFxdCixwDlBnyLguB4RTna2af+DVJz+/aHERO7+Sl5DrF4E+Vz3Q5iIIC9e09oc
	7KQ0RfltaC6dq0TKdl7FMF/QlFfYoGU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QhoInTD0Xt4NBSuls0AgRrgTJDXjCSOPGY4pmRsoD08=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793808948; v=1; x=1794413748;
 b=oO5llueb2uLLHAIztGoWQ9k0aJwHtRxomO9r6ciLu/m9aaoJCGqWBQobUJ4/gK0SNhXJ97nr
 ElLpG14EwNXY8YlLuxiBnZE31ra/RtD3OJcdO8OVaX39YfomEKzpN1x2NQniWCLhSg/wVqkFKSJ
 jiEDYnwTN7uWGrVGtczbdmrY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c6ae390f292ebaa1;
	Wed, 04 Nov 2026 16:15:48 +0000
X-Mizu-Trace-ID: c6ae390f292ebaa1
X-Migadu-Flow: FLOW_OUT
Message-ID: <81096741-0e14-4469-bdbb-497aba541fbb@linux.dev>
Date: Wed, 4 Nov 2026 16:15:46 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
 ruirui.yang@linux.dev, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, jbohac@suse.cz, sourabhjain@linux.ibm.com,
 ruanjinjie@huawei.com, leitao@debian.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20261104142727.2894800-1-usama.arif@linux.dev>
 <autMHwldMudQOO3j@thinkstation>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <autMHwldMudQOO3j@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27AAAC0014
X-Stat-Signature: docrbca74txdfzqwsogr51be4zrh4x45
X-Rspam-User: 
X-HE-Tag: 1793808951-488518
X-HE-Meta: U2FsdGVkX18M1FqBNF6HKqLDSNnDGbH41EIt/RflfvTqwhExjitUOio9dATfaNb3e3AWu76T5RYE1j4K4NO71QaM9P8zlm7UyeFXmP/92QIDBa5hIACj5S+8IXLJiTT7cVdivDHCefs44scS87M5OYBE4OkwDueu6ybBIPs0kQ9DwqF60PVCI2B7LcD4EQN+T1WDuIehfIxma/0JcwxQ3hseNnpU1kkNP+4L6odrpBgJqFPNRfe211JzWYIC6pLRpME+osr88SL53OiDRbiLlxR8yyjUER0FBN1oxUh+meb0dn0M1p/oJUtSiysKPYJaLSHHrw0IVM85nxIkuIyLB4YXEuQ/q0ahOtKmWuoRKbVdb2Ujyb3vcm52pklzIeG27Ie3oXNpvzBnWIE/vB3bvzplJOD0g7gATLdSHz4kgMFvPosuFr9f7AE+uMhzn4lVffnJEDsrwAYKA6Q2lTRaBr8cCRBRhOg4zCdM9eEhcPV1I6Scdp90D+L9Gosk5/mPEimPIWyx9YHlVoNl8wynGpN26KHBmBeMSwSm+mQwtXWIx5blCJauh0u/DUEvXeOaqzFxJF7ccWZ7hYdtUX7J8p5Cp1jYsmq+3n5bPdBoAmNDB7XOL7OPOMUXQpCuO9PDQwjUbH9dCTiZiBbxP4Egw27xwJYf+32NBqSdSg1T9CA3TrrHv99bAXReU2sXhqzF/j8XS/a9ldXsapL7tcOnA7y6pF73AgrGrbeQtnEEyc4c35X7WMsDFNA53oTVHpJY4tzWduHzqbjUlXim9hEGI9jDJSiCjQzYmCWnEMEof6nrDDbCVEYxogSPYNbQBNeR8KAUnwPxMJHCbClS4+HEwLoMq8LwyQnLVuTUro0TSM/ZN2FK7/2Atne/4HpaKByg/1XA8EkLqo8yeC/UNLwlJvJJgQCRyJOVpyF1Yc4BSDkepLXibmMgqE6wi0M2cnQ6YRqkOZVZeutHbdJzC4H
 qtTXXQ4L
 wsgcKoXqkBoqcTsPl4Rtr2mxW5UnAIHfJJB28dHaqTZapmKARmgT3ecAiRmRL9o7nqdalqgoLLelLm51Sx1A3BkqTQI2ANd1cj/QV0TZNFTPGVMqpKmRKnvIb7+dHvrTzQeBQpqheKFqlOfnsApoUYpM/Uwr2NCw08gjXQ12t51TkOmv5IJZFEfg7/ehqkCS6En/duX+iuIuppQk7j42hR1rAMQIWp5zDj0gcIRCXT/P1m5sGozLDror28VWI5+qSRDsl0lWpZzADw1mG8/DGP5nmCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 04/11/2026 15:20, Kiryl Shutsemau wrote:
> On Wed, Nov 04, 2026 at 06:27:27AM -0800, Usama Arif wrote:
>> Use a separate suffix to make the exclusion of existing HugeTLB
>> allocations from the vmcore an explicit choice.
> 
> The crashkernel=size,cma documentation already says that pages allocated
> from the range are not in the vmcore and that it should not be used if
> dumping of userspace memory is intended. HugeTLB pages are userspace
> memory. I don't see what a new suffix makes explicit that ",cma" does
> not already.
> 
> Why not let crashkernel=size,cma take hugetlb CMA first and reserve a
> dedicated area only for what hugetlb CMA does not cover? With
> hugetlb_cma=6G crashkernel=2G,cma there would be no extra CMA at all.
> With hugetlb_cma=2G crashkernel=4G,cma the crash kernel would reuse the
> 2G and a dedicated 2G area would be reserved for the rest. Either way,
> nobody has to learn a new option.
> 
> The catch is ordering. reserve_crashkernel_cma() runs from setup_arch(),
> but hugetlb_cma_reserve() runs later, from mm_core_init_early(). The arch
> code could record the size and leave the reservation to generic code
> right after hugetlb_cma_reserve(). That is still memblock time, so the
> remainder can be declared there. An early_initcall is too late for that.
> 

Makes sense to me, I will rewrite it in the above way and send v2.

Thanks for the review!
Usama


