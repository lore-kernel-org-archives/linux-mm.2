Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE2D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cpTgU8y/
Received: by kanga.kvack.org (Postfix)
	id 9C0536B05B1; Tue, 10 Nov 2026 01:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997C26B05B2; Tue, 10 Nov 2026 01:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE436B05B3; Tue, 10 Nov 2026 01:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8576B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:27:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C64711C41CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:27:43 +0000 (UTC)
X-FDA: 85418228406.24.B26719D
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf24.hostedemail.com (Postfix) with ESMTP id E006D180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:27:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="cpTgU8y/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794292062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSj86Hc7K2z1X4Epw37BkpA+aLDPOX4tf6yZloUics8=;
	b=e8wxX50R/SgjL5ZdDlC5iWyMHhab1LeM6POntCNPBTqfJGCLZ/F93cgQ3Py/XBDU86QICN
	c78LgfEnSBS+CTrV3sgTt+D8d1vlmLSdoD1gNnFJyup8JbYKa4osTL4yrnl1zp58RdLfQK
	ZuU2aorBF9dfk5sNaxdHcz4mj9q5fMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794292062;
	b=OCF2YK5yG8oREJuD8xggA2SADdh8tX1iQlmPiDtchjmsyrSKdrtccR/X+gphgoIoY6TooH
	dRwPXW6GTr4/plYMERDgjHEVdnlztZsqi7j89TsWdouvfwMDfsfoOlhaoEkvoeTPNNi07J
	vDeFMAu9Xt9RhB8TTz4+SrvaI/c5Lo8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="cpTgU8y/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f6.google.com with SMTP id d9443c01a7336-2e987949882so12855755ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 22:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794292061; x=1794896861; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RSj86Hc7K2z1X4Epw37BkpA+aLDPOX4tf6yZloUics8=;
        b=cpTgU8y/LZWRSxNOekStp0K6rPVr+2jAriFV7zP+vfuojzsJv4ifzhGsyzlCBv4TJ3
         kGlrfiVLimS5C2hTzKVSCN9AgH8cptblduOZdzW9BHzgqPEO9ZSRhC81XmJaWCxLMiCF
         IWWoBU84Zp9zhz3WN6r0Tlki3MtRB5QbfhoY4zgkHiQnaHD+F4BFdFBXFzYM5w6ovZ7f
         yHC/aHTe7awEmo6cn4+UZtXTGdZCl94cT0PyS9/IDyRzjUfdxOTj/My1YbVDCMO4FoCQ
         uREWg4ND59lumRCb3lTQyxT2RQY2ImbzKh+CKFSPB4m3YIYR06GEMFUtvbwJJZlW5MpV
         i8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794292061; x=1794896861;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RSj86Hc7K2z1X4Epw37BkpA+aLDPOX4tf6yZloUics8=;
        b=iaMMEv40AH+wzZaQn3Mj29963mtKAOImGLSaqMSrNM3dAV3MlMRl0Z9Ou8Wyg0oBSo
         axjclwny60ZPCIc9S/jknMUE8KAo2996DKtrPni1tEvfEGf0bphFlH9doAgiPgHC2RNo
         Rwjhblpekbp32/paetroON3wtfod3jm+FoUMjUI/K+CVY4SOVvkTXtGOdJ74yaoRb0jL
         7xWvL/qoQPhsgkj74PIm1XIxFayNjlaQYBRc5DWoZ+9ne6I9YUyUNHrz7i2sWl4w3lA/
         wmLdrv6QG3pRfGfQ1k5A7TYQlKT8lI3wVPEwK8BUUzYaKciqbiXTz6LnTl+wUcHe+CcH
         1ARw==
X-Forwarded-Encrypted: i=1; AL+hErFrbrsT7bwYAavpRdjjP7Yo2s2Wwx2mosNS1yoxd590Zjk33RfIKil8ePFqXSWT33DS8NjZxOq8VQ==@kvack.org
X-Gm-Message-State: APuU4Z+0yTBXt3vvO32JZ0bEgjU6OTP2NqAAjCX/4/cc4e6/lrotqwv4
	tp/AV0oCHhlv57YjYX5BogOFKP1qTE4rc6swiH9VC8zjiDPLM3t0bj9M
X-Gm-Gg: AYBFou2eRrHRnC5bn6wBCp9LvDq3PkNXUCP+YNrmxitnUZIs/QcugkbJ+VRvLo6rwPW
	iTQv6VXiGENb1iXqyA1A6I8Bs8oKZPkWxLwju7A9moXifrsFmiITasMpBX4IQD86OsiJpwF1Xtc
	UCkjQKqiBjakAyGka9v3t4NFkHf7bkutmceosjCfcavP6eUdewNYvyVtf2xoBN6829CzBpVIZr9
	7PQhiGqJg+M/03P7XPBkuDVi/EPT9e8xqD4rWFAmeEGSBLCirPowJETfmxOnms0VTfq6GK7LKj9
	99in3Cs6PLrqK7dJQrGns2SeYePVgWpfDsUJyhTTGO5hTGGvdW3pgAWMqwXTpWeJo30xeXnIfw2
	wJEJL1HL5JoL4scKg4K43YAzFkn9/N22FZhmystkoRLoDtBUyCKeUby0er9vwSFb2xCMTTnAF6b
	MX/gnnHYbLwiKkt6FBybgX2Vvgqy051SKy+56E24BjQA+UgWX0u27GrOqzOZ3gd6O3BovR2GDHD
	peaf+Kr+VwJzkSqJWNY+nBx/yjBV70MJAKnntKbvoH2UbZS3usZGN56pc+IP8wVSu38qQ7NNPCZ
	NRQnszzmKRx3iJK3LUDKadq/R3W0v0aZNf/I
X-Received: by 2002:a05:6a20:9c94:b0:3dd:a197:edfb with SMTP id adf61e73a8af0-3f19057bee9mr1544827637.74.1794292060357;
        Mon, 09 Nov 2026 22:27:40 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa86e030sm473518b3a.27.2026.11.09.22.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 22:27:39 -0800 (PST)
Message-ID: <dff3e90b-f03a-4dfe-8c53-fd65db20de1b@gmail.com>
Date: Tue, 10 Nov 2026 14:27:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix mlock state loss when migrating
 PTE-mapped large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org, fengwei.yin@intel.com
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109090846.1068409-1-chenwandun1@gmail.com>
 <fc3c1e68-9321-46bd-9f1f-4209bf5c6a7d@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <fc3c1e68-9321-46bd-9f1f-4209bf5c6a7d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5wyipts9dqo1eoj6hec6a5886aqspx7e
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E006D180002
X-HE-Tag: 1794292061-133047
X-HE-Meta: U2FsdGVkX19i9e/QSi9kqHdP0rPn6r6HaOIJNvBYSrTw3w2Po4N8u2UI9Rr950jwgNG1KI/LDUTtdWgyiOqB+hFnnyn6ZvsN3tKJzjcF/1aDAU5aMbIu/go8LDxpJjPUWkxErUMrn+Psgw1zSd8EUgNcfmfzcUjtmax4zKLd8UTh8YWcBK/8VX5c13WXdy6zlGc+Cp5SgeIOTcxUX+ekekXV7yDyw6FTZI4oNu2ToknuTv2wZPTF0LjJmDl1dxWkhArcoSRt/y/zvxK9T9dGF8VWMuTY2dKHraRDDM9fyMIBqysspXk0YR6TJFWW0r7lZS1KT+2XXK4W7fSCLCCSWENQlcGNsJe/ZhSySLVKHgg60DibhQDaFwtyDvUOdLLgfZtf1OAVNbQPbbDelHTAQapExv7sHTVzha1sbPJvOsjidfXwFEGmh07joxR9/1u/xgvo/mOUjyGH45F8ZVNiQlRScO5NWBWVoN627v0fuv5Z6G3uCKasIQOBfkjLdeVqKDl3pvXHbO2CLlrQ4mQaJauuH9qrIg/3SGvCOZwG4jNKALLi2ywA0ys+MM/6eGJofIfISpBLZzn6i4Xko5a5TvyoyIqoNnBBf5tBTUkxwvlGrXzsOFHoTe6T1BMUztRFBz99OBQzA4TmGKiEn1Bmp+xuVjHCLel+gYmpYIj6puij/2WoilQhfrJt/1WDkb4Ssiqi82DHV5Hc/TJLANZmRZjYFkCrjSb1O2isr66oXOp03RL9D9l7IutFOw++z8IliNGm1fRdgQtJGsfINVIUGsArWqvlIEgzjeEUZjNuv/6MeYIGzm2n9zEi7rqGhRm8Ejz3AQzCNe3MOwJAIMDc8wFbJF2DvSHMGmrYlbu9sD7TtAfEM+WsLSIypVZpA8vDMFgdj2Y4YrU5pkV0VwtIFSlE7/F7a0mbFg4Yzhqp+LDRJj3vOVix1UebaS/lbgohhNe49PmU4Y0+R/aXsEE
 /J+drDGQ
 I+gd0uAn24Ic6u/dEHpBiaeR9iPcaRyQSSFwG8/uCaMYZSUaU0E6mutpHtDrMBz4/c4ZYBEOA5xZ1GTPsW5ZnDu4QBjkSOXcdr1EPoiOptrvfkvO+VqRnCeKKb1nTvMEA6g+xZRR25KLFwg0LwsB0cVvmF0ZlW2Lg2qnFG9MzYjk/I1/xXE8pO0/cAVFHkiGDhskGYWUHvjuIp9+K+uXKVlzZvPZ+fBTEqyzAS3m7cIHQLvsgR1VxgDfiNzuVQPKW+xCxXbpQcczDQkKfKyBrnrT++fmm66W1yjA7VygIokgStBrrqPrYMdhGB9KuvznGIl6SR/lX2ykV2ZO2gvEQEUc9eskVAaaMWgHrJprhzpPyDSKqYNabUMgFSsQkr+ho/bNJwvaWqtnW6mBfNY5l2SOeG4jk1/yep4hJOJd2Sq5dsPwNkZZugUo8GxZeZp2SqjyOo3e53q5urCk35YbOQNa1hbIcYoF2pfCL4eEVKK0RUkA+eEuijXbpjFCq8ffnDnIVkuk0i/a80/Vo9x/L0Phacal6Ry2bKd5ZA+d2olcFconEKQnXDHbCg6WfdGtGrFXy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/9/26 21:51, David Hildenbrand (Arm) wrote:
> On 11/9/26 10:08, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> try_to_migrate() clears PG_mlocked when unmapping the source folio.
>> For PTE-mapped large folios, remove_migration_pte() restores one PTE at
>> a time, but the rmap helpers only restore mlock for full-folio mappings.
>> This leaves the destination PTE-mapped large folio without PG_mlocked.
>>
>> Restore mlock once all PTEs of the destination folio are restored under
>> a single page table lock.
>>
>> Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> ---
>>  mm/migrate.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 94033c222e04..140e291d4587 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>>  {
>>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
>> +	unsigned long nr_ptes = 0;
>>  
>>  	while (page_vma_mapped_walk(&pvmw)) {
>>  		rmap_t rmap_flags = RMAP_NONE;
>> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>>  			else
>>  				folio_add_file_rmap_pte(folio, new, vma);
>>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>> +
>> +			nr_ptes++;
>>  		}
>> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
>> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>> +			if (folio_test_large(folio) &&
>> +			    nr_ptes == folio_nr_pages(folio) &&
>> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>> +				mlock_vma_folio(folio, vma);
>>  			mlock_drain_local();
>> +		}
> 
> I have the recollection that the next try_to_unmap() would fix that up? Or is
> that not the case?

It is the case, try_to_unmap() can restore it. However, until reclaim scans
the folio, Mlocked in /proc/meminfo can remain undercounted, giving users
a misleading impression that less memory is locked.

A similar fix was made in commit
	ab521b4142aa ("mm/rmap: improve mlock tracking for large folios").

and handles cases where an entire folio is added in one rmap operation.

However, when a PTE-mapped large folio is migrated, remove_migration_pte()
restores PTEs individually, passing nr_pages = 1 to the rmap helpers,
as a result, PG_mlocked is not set on the destination folio.

This patch handles that case once the full mapping has been restored,
rather than waiting for try_to_unmap() to restore the mlock state.

> 
> The "nr_ptes == folio_nr_pages(folio)" case is shaky either way for folios that
> are mapped into multiple VMAs, or what's the logic behind that, such that is is
> fine to only focus on large folios that getting fully pte-mapped?

The logic follows the mlock restoration in try_to_unmap_one(), IIUC
only mlock a large folio when it is fully mapped in a VM_LOCKED VMA.
nr_ptes is counted per VMA. A complete mapping in any one locked VMA
is sufficient, regardless of other mappings.

Best regards,
Wandun

> 


