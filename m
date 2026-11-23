Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E640606A685
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nAPVMx2m
Received: by kanga.kvack.org (Postfix)
	id 28B2B6B05B0; Mon, 23 Nov 2026 12:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215176B05B2; Mon, 23 Nov 2026 12:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE156B05B3; Mon, 23 Nov 2026 12:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2A246B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:55:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8051A1A0985
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:55:24 +0000 (UTC)
X-FDA: 85467135768.18.382A8F4
Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id 34EA24000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:55:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAPVMx2m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795456522;
	b=7X/5k9hV3xPwczHw971d4NBkZq05uBCAnwNdpUjUylEBL+PbtE6MSJKzFj1h0B5G1mefeR
	YgzsW7GKY0SaW7EwuupIyGAZBN3UE1Q0QAwPuecVjz/qRG9oxriMsiysffkj+Wbauorur2
	rXF9IKdKRH/epV7CVw9N/gNg2xJSViQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMHaM0uSgX3eSpN4mZEmyB3Lyh48q6GW6tOkCnfZECI=;
	b=AxuppfEnmSF+gscXRrVhJMB9ZC1SjtqxVuEukRzlRaUjLrpIAR8feEZWeXwcenban5djPK
	XqCw7xXOX2DQa4LTiijEuyjUSXLpnAwVuZSoclYt96cmMz854DdRAAERz1G8zvxC6qs+GA
	3u+tFelQIeP3rCmk+0+cbpJj/yEZArA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAPVMx2m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/8a5s3NnlmOS+o3OmDGmvQNljvm+stDs8p/PoHCQulk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795456520; v=1; x=1796061320;
 b=nAPVMx2mzQQTQbJbg0Z4a11SsMepXBqjha69zs3FDfbtuGRPkWP1ni8+Rrj820a196YSt3Tl
 sV1fP26pVukADIcJguZEuVdEWZNamVKifmfXXaa70LE/TjQBU7FEt7+mqC9hDqhrks7KckKI0pC
 2KBTh+s3+ooN7vphvD7KPThA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9cef6277f6cdfc24;
	Mon, 23 Nov 2026 17:55:19 +0000
X-Mizu-Trace-ID: 9cef6277f6cdfc24
X-Migadu-Flow: FLOW_OUT
Message-ID: <94a074f1-753c-4ed1-99e8-59d227f70ea3@linux.dev>
Date: Mon, 23 Nov 2026 17:55:17 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in
 smaps_pmd_entry()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-4-usama.arif@linux.dev> <awR2bZl4CvSuInmk@gremlin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <awR2bZl4CvSuInmk@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34EA24000A
X-Stat-Signature: ae5b6bdeh4g8pqrzzsb8foejmgeaxcn4
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795456521-18754
X-HE-Meta: U2FsdGVkX188osagtATsAB0GFPY4ZZORqM3HswrMbg4/3bQa3xY9N+Xr/Z0XtrXasDycJpCpYPxgr/hvMeZZBtFPp0gVgeeyZTTk3Ixc4m6FOU5awxYACJHZzGMCnEomCmK0atWBH35vxrPC9eIZ7YVYyOiVhRElsfatvIegFy9ZNBjD1v7HLW68Prz41cwNrKhYSvuSCLERFZKCJjl5Q5Y8S2LjBpiOJBY4KkaSLGn+cfqOd3L7n8ntK5UZfslq/n6U+8b4YhYO8rBIcE3y9FulrCrQ8EBn895YS21fDaKyKBGuHpn6Q+ZosQLYjyJwFDkFz9n5uuPDzDsNp6zRgVVl03D8fEuK9ZaBY4+NUpq8cImZwWYft6OQo+tLzb3Py0uyyyemlennj1YNWpRakB61asIOzv9sBzA3skm0zhdpzsYYSdV2hjv8sgNA6uUVVtkohYHwvl763CL81WpYfhRTQ5gev4zAE/lKM8Afqp6FeHtw+lVQDW1ADVykY3HvDAcsEvQUNYtib3RFbNf4dFFjySfKPP1sgkKBvOklrFtVPDSdKitBjTITphWV9OfKsvc1/ee+iYWHcnmLtT59K5zjhz7E6/xSD4ludKiYd5dMRyNaYR2PhoSCO1cZHREzlDMmVbVo6300j/Nap5ZdlkBxbXPcDfDlDo5sCEuZH/DPecwpE6iqm8MZMJRWrMQXuipcMtvKiIpGehQp+1+azmPybSRSVjYMtryxNQEjg8Zok4gfJyD93khoS86oYM0hWVSPFCGf9ORvNDugx225LNaU/WL38L8YX3LJX6WaPnHjYo1khJ0NwixgXGEVN49JpQikkkPGFRR6jEfdW+AflHaGLfergTuSnDBh3qUuE1ThiH/zxgnARA71egn7ZCncSwyRq41H0cvz8vsLjulk2oGnZiGbUntaCELnxF0me3+HMNLkPJWLZZprfX5LTzNX5MS8UFkLi1eMBuRLI82
 dlDidoBw
 Sd3oGNEX3xB6WcOYTM/2wG4RgVEegaRP1eJlyaEGVt3PIfyLFABqFwXO+i4IpRTgccHTLq7Ke6R+h+CZzC0ZuvcdgKTfs+gMNdNSNt2OK491Nh5zkUYqxMfSTmoat9i6RRkoIiyBjkVi5zEQnDTHBQjC9Qzbh0+UKO/W5ys0KoXziJFVHqu9H/7ApwnH1u0fJiks4BuiDDpF9rFrB33Dqc5nxIibOBsEr/64GoI0lTquidPASmOm/aUV+hvuk57L0zy/3W0ipWsdViTpAebHNAQaXCnnd93WpDrBTt8htDLFEx4dpTy9rLum4E8Kdb3pObiggzu721TWCejanZSdCWiAwp1+UJsL9VVGP94Jm0ujbaAf/mOhz8ow1c/SEbjkFHqUOGMVvIhFjLTBnsrAVA5i/FmyH8atlIakLb32WbWjb0O4y43/FcRFggOxXxZSh0ITNWDqjzZHTyR6CPMHgg/kPz2lHrd5D0J9jqIXXQ+ZpE9kHXpAtrfh9/QAyqkTYBaO6sYHEWN6oLKOhTYkQf9+SbQCU+SgTzcqqzshtp9ZW+OmAuzOXzo+k47T9wcliXO4IU4yOys7J2T5XaQQfqFUvtWZ1OJ6BRw6NtmyJoZqgvKdwv0HUfWn5LDWpgqkj7iAZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/11/2026 09:24, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 23, 2026 at 08:32:09AM -0800, Usama Arif wrote:
>> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
>> into a local with pmdp_get(), the way smaps_pte_entry() already does
>> with ptep_get(), so that every test sees the same value.
>>
>> No functional change intended.
>>
>> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


Thanks for the reviews!!

> 
>> ---
>>  fs/proc/task_mmu.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 540c936aad4714..105c4998eef48f 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>>  	struct page *page = NULL;
>>  	bool present = false;
>>  	struct folio *folio;
>> +	pmd_t pmdval = pmdp_get(pmd);
> 
> NIT: Can this be const or are the helpers not safe for it?

Ah yes, good point. Its good to have const here.

I think the rest of the series is good to merge. Should I wait
a few days and send a new revision with the const change here?

> 
>>
>> -	if (pmd_none(*pmd))
>> +	if (pmd_none(pmdval))
>>  		return;
>> -	if (pmd_present(*pmd)) {
>> -		page = vm_normal_page_pmd(vma, addr, *pmd);
>> +	if (pmd_present(pmdval)) {
>> +		page = vm_normal_page_pmd(vma, addr, pmdval);
>>  		present = true;
>>  	} else if (unlikely(thp_migration_supported())) {
>> -		const softleaf_t entry = softleaf_from_pmd(*pmd);
>> +		const softleaf_t entry = softleaf_from_pmd(pmdval);
>>
>>  		if (softleaf_has_pfn(entry))
>>  			page = softleaf_to_page(entry);
>> @@ -1046,7 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>>  	else
>>  		mss->file_thp += HPAGE_PMD_SIZE;
>>
>> -	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
>> +	smaps_account(mss, page, true, pmd_young(pmdval), pmd_dirty(pmdval),
>>  		      locked, present);
>>  }
>>  #else
>> --
>> 2.53.1-Meta
>>
> 
> --
> Cheers, Lorenzo


