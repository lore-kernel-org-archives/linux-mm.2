Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064B7606A89D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CbBMVAR+
Received: by kanga.kvack.org (Postfix)
	id 222E06B05EC; Fri, 20 Nov 2026 03:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D34D6B05ED; Fri, 20 Nov 2026 03:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C2A6B05EE; Fri, 20 Nov 2026 03:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAEB26B05EC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:43:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5750DC0DF9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:43:12 +0000 (UTC)
X-FDA: 85454857824.20.5A8447B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7670A180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:43:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbBMVAR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795164190;
	b=iYXDg7KDPZBJEaX51B8jp3apKEXlsZzXgYrfIkFKEJDG3epcsR7YWrjHf2Aq7rjLZLkaAn
	Re0O0MehTe1suSiDNy6YvhJr8EHBLKykMHhnQQ7YmRSo9444C3I0c35arVK0pIFPjhJLHO
	TxH8Di16pyvB7ZxjIEOvV1d3/ZyEkOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795164190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZLaZxjfAJipvGsXxKTangk09pxNmG/IyQG7106ki3o=;
	b=wXKU+Fw6LolCtaKURZDX4HvKjtoJ2SMoAhgqmGoUQWCOzjuq+q6xsSnCWAgqxDWu8qf9a5
	FbxHAFbrekupy0tUdFZWNtSa43MtbBDcKn0q3Ri+osFWtP2EK0lZjvidelGckHFfcg4M1v
	4YwBacaRejtZXN8OCJ1o1qyqidwQrPw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbBMVAR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4E8943F09;
	Fri, 20 Nov 2026 08:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E891F000C4;
	Fri, 20 Nov 2026 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795164189;
	bh=1ZLaZxjfAJipvGsXxKTangk09pxNmG/IyQG7106ki3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CbBMVAR+bpFFZvUzkMVw2v6pX60Ocn7g3BOFJJ2aKH9g2jJ4iZfFYjB6LfNdE2lRD
	 OxgEdx/+vZK8+gplEgngBi2HCeD70yuLQ3jFmCHs5NjYr+7IEz6eWB+0u5sSGpCDql
	 gSGScQCxJnIj96r9FZEaJi2wlGVkASscTuQqd5V+RoU8+/487JuxoW+yrTiTk1GaDW
	 klWPGJLzHrMeOWAxNkTEqXXSrJtld/5fLH6oSKE0ZEvhUUMUUL4maRpYYzQByr4AFM
	 gRZ/3LElO0dc2lJIVNXSOaHkGmaphdsGyM/lJieAmRumN+UKO1YvgsfHQfM6LR/lzK
	 YWScY6Mz7jj6A==
Message-ID: <356e610b-420c-4574-9d28-28a14c388938@kernel.org>
Date: Fri, 20 Nov 2026 09:43:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, baohua@kernel.org,
 usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com>
 <0d75991d-9381-440c-8d7c-07bca53cc8ff@kernel.org>
 <CAJnrk1ajoz95T1-vpnqkTLDtoXoY_hKHsxtNJLjtbusB4Gd+XQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1ajoz95T1-vpnqkTLDtoXoY_hKHsxtNJLjtbusB4Gd+XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7670A180003
X-Stat-Signature: 7k8o4q3wiapyppqxzmkykserkzp71xyg
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795164190-142706
X-HE-Meta: U2FsdGVkX18/opNlL4EnlunsKmejP458GgBL6tnRTznM49N+vx3gy2/XB+Px4iwgiLDiLdRe5lMsCE+aIEzz/OtmVJBoiOfiVSF0V4Ir2+gn715fKRDL76/bsu9QFDM0GlGeiqaHPcSJnOb+xV98skEe+tfVkrzcPGZeu14B6kfIoCIuxGoNkbafhJH+6PCL1Yvmws93giIl4fgGiSs1p/eQgCXhroW0TnX9r7PiwkF8NjRp35YGe5nB/9z1UTokQgNpyTuZMmpfyV3Exsrepu+u5v5qjFumrsV3l7j97n+7aNQ136wbe/eemu92dk05YO/zItLkt4pvPHyehzIUOG4YdpZOjka/XVpuElKM2poh5vX0GnkPLyjbgvST4dt8R37WtzgPKzqIyLkVnma2HRa+7GGFYsyFvdhql4SRP19uIQYInwIKow5Zv0AZGSDueRkr6S1rCQfOCaVZrv8ioaG8etyebVPtP5D/OTcsgW5xgUizDGGNyg3CTa4LyIso/7WGE0HMtQTWsYxnsM+34B0D6/cpd+5FA1lqUFGcHKws7V2EVZu08xk/T/uiB2PZKCLYbVegJr+nCY80gZdkPY0E0lhF7kIZLwvThjwBwS535O0CfYlxNLbULHYiDF4zmV6Lt1fKFuTTFtHsBVyPOc/skla/lxO0jS2lfe/Qt1C4ewPdmfojI7SQbLz2PXA1iJY0Ca6NBVsSO9yOswCErrRScZ+HnPi1oQuRW5gQee7o/CSEXtyqPW9IDd9U7/B1q81OdDXQ+Ay9Oz7PYcVNqCuIzLiJ0AlYyGynOpDngcziZKrMYXoJ+mnLWR3AcUpIqjLQIkLidtW6Pch5trZ8LYUzL+1jsznbUptI/kx658IlSc9SL6R8EuZ92x30xxz365qyjNXlRJxFlH2EyqYbFomZMg/zgqo88zJOBeB0S7bps9QluJgVk/kgLlVteygXW2SRTNFwmzffaLP3yAZ
 AjoVhor0
 y4ZUzDMycqFVFa1k5kRa5bUlKG34HUwYRZMZlK1rKFuF60yrIc6xta69EnyfmwVGRW4vxuVfgjh8q+d5Dh47BCms1rLQG5TDJA/1aC6URlulby4rqW9Ktk2CF1bukIMgOPUjCcy68lpY9Ht2q5QHcLBNfPjN0nVbACCBZaaUJuw5Du6eZWuL8bf6mUhje363RYS3guc1eieo/hcPA+uihlhVqUiunoIt7fdz8BafhiyBthjYffXTEDh2bdwLeQWglTFxUGrRNwWtzInMMiVzAQrQp6gAX84eP6t4LTSjrz6glbntLnanI4ipiY/stkjX+y6UjYgMWGp5qFk2aVODt5A1xBjpmZueyuBKCnbliJcEYPEge5pRV6RN///h7zXaVOTG4A+nDwuut6VRf+sviFo8j/WxYgmsDNqGObJDeqc79XGMNwPJ60SWtvLOmtWXgzfjWftRhwCRStlT4kaUkXB/Qkr2IlxEzkSMXTbJ2NngqMW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>>>
>>>       /*
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 0c9ed04528d8..44376321180b 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>>       folio_add_lru_vma(folio, vma);
>>>       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>>       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>>> +     if (folio_test_large(folio))
>>> +             deferred_split_folio(folio, false);
>>
>> Do we also ahve to take care of mTHP placed by khugepaged?
>>
> 
> From what I see, khugepaged maps collapsed mTHPs through
> map_anon_folio_pte_nopf() (from collapse_huge_page()), so I think
> they're already queued.

Ah, yes! :)

-- 
Cheers,

David

