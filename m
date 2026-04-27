Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84504FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7106B0088; Mon, 27 Apr 2026 16:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9581A6B008A; Mon, 27 Apr 2026 16:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F7E6B008C; Mon, 27 Apr 2026 16:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 728FF6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:06:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F394D8A78E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:06:24 +0000 (UTC)
X-FDA: 84705417888.01.1516998
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E2B81C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:06:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouPioV8C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320383; a=rsa-sha256;
	cv=none;
	b=4eeSBmPcRJQz6RkkcUbYln+pyD+GwrQ8Tyk9gltMpr4rIovsRLtVBbWH1Kx+878RqMFnQL
	2tiiV/0sBdxDvoD5xxURYcBymBj7EvEzOX6m2cVpjAnwSXImltVGrMwysSgE40h/jSzjk8
	f5k8CBXyVKJBM2727fPw26/5TwPpaeM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouPioV8C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW4lwAIoSUhTlTlQ+ebOQPijiug1+Oa2z+ISjstKqKY=;
	b=Qj9dUUvTwoxTFKdeULPLaS90WM54vqTPajBpf3+bipDEa+TJ2eUMfnX5LKhpUfYPBYzZxR
	3m5Qmgn8owu7556FqRzzMSaW6cjKHY23f3IuYHy49MtD47lWWYdgr7UerR/pNjtJ5lEX0y
	hyfTQtxw/c/RQjZyKVZeEgmYNmesL6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70B8960138;
	Mon, 27 Apr 2026 20:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD152C19425;
	Mon, 27 Apr 2026 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777320382;
	bh=fv0JqyTf9qsZGD2A+KMfMgq2gCyaBP1nCHd0vigXPHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ouPioV8CWjhERioQebI+56NgMMJRid1vb5ijj2LqJJ6hXO2Q5aIq/KfWFufzJT/hD
	 qxeJdGmfn3cOtcJgc7Oz6eegcTuRqS3k49uwzju0ubI6b54KEqpXHHOciAlCy9LZME
	 IRMK/eJW9ESYjq88RVrXub3jBogxMh/fUjxXf05W60Mr5I0XZrn9VHEPJoQda6L+wn
	 23eSyGenUFdiKY4KrLNgeXNW+otQm3oXoCzlPG6yZZVl9H71OxlZxq1MjmF8Agyli/
	 FOGRnrWSHgaGO2ZyhnZPM6TjQekj5JA+RzLeEVIHm71Z34S9YvPXGaw/NIJhozVUBL
	 bAzi2fbqDpdzg==
Message-ID: <4dc7e142-9761-4b32-ad75-4b2ff45e9604@kernel.org>
Date: Mon, 27 Apr 2026 22:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v16 04/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Usama Arif <usama.arif@linux.dev>, Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 ljs@kernel.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260420135554.27067-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260420135554.27067-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bmokna69e1k7pcehnow95y8gcadcx9w8
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E2B81C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777320383-757902
X-HE-Meta: U2FsdGVkX1/Tnp15LMj4kKJx6Ji/H2CrvYeXseQ0Mn1qiu0vg9HQb7Z8ERc+cDR/BWFTcj/L2OI3P02OIS1FYKEPlQKYjbzj/O9ohTcrPIQ9ERFV84BGP4qhIWOiEnjPufaATLNfN+cznKZJ0ZiUDa97QSJkwr22fY7ZanatePyyuJUkfAL3hONpdoF1vYsn+XS+g/b3gM2AvCzFxiACBlFbK7dg8AcGPDdyKs8mMmatAgmlWyJcjf+zKttik3ULOD7LjadrPsAn+Z7TFUNGKBgT8cAqbC+g//QROcZSyfqeVsx/Z/xL8qly7utooaAurNxIr4nB2IjYEVkG3QDnk77Jq/kEUtLxDDx2m3OVX4lNRmalIew3Oxg3AwWG96HDlNtyRREGL8dcUrK49Ht6BtkANo48nBM2bKrLAIZTC8bUfTkKbrfqKVJqbgmLM/OYTtHccFb1OAQXCprheyQlo6mb/3C+1GFahcqqK0Y2hSZ585qPoT+xbpcAwvrsHWfKCc5Pis8H58/ebfAyBugU6bVXr54/T7+uAzCpJH7+bV8olDsttP8tDWEI+YCP1oVKvkXi7KUo0on3LyMgL20uMqy5rhwvtebC1G4qUAtcLsord/GdZPSQzp7ZvuSidQ8B5cis7N57+OHnZMDmf/qAtd6U2Njgs4rsjZTOYvmz/rFti1D+L/AE1a0bviYqmeqo5XdVMWj612AuFq+l7VCuPf5m41sMooWop6bp1634SUu/ZQ+ALHQlOQbxHQy8/Zyz4Gibz2gB2UMqTP6efhKcrLf+n7Ba5AlFBtyCcD75zffdepYFX0WH+c9+wqwU9eqK4tFXDhAZVIinQRwXocR6qrH/RQ/4WH4rv/5QCeFOIzkWgnCyjEHEr4u0+92OD4osW1omNMMxzYzyA1wdtPQMObbw1OCmYn61stD6BmRdv/czbZjrYAWLxAzGGB+HTRx3pabuHax1+kDD90GNAa+
 3BRIZ0dx
 qJIm4XOI5s9Uf/JgziI1EstWxY3YboKVQLGjsoaaL9OETuP5pi8dyH6De5whCMCLbi4vzPOuHWb1p3NzhL5a9mpkYVLhoMjA32tK6BX7KR7crthKMgslA+fSIVQWTKNJirUoMLsSsqzXSTxf9G2blkS203HU31p+VktLTMyiYL95AA+HzKZeXr+bJSzLD7/64dgYV/GR+NivOXxJ2e5rPknBz2F7djOGyJGIQR8LfxHgc3/lHeO1qvhPVXceCt4yIKsYjPPpcNA0a0i9zSlZaiEV5XZrw6IUu5WZgKpKkX/ym/i2JLlad/Vp7OvgFYDzmUKOpC8g02t4a1FNGQCmzk8ra8m+YybFJODryCPDF0htO6eYNMXfaOhgzmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
>> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
>> +		      KHUGEPAGED_MAX_PTES_LIMIT);
> 
> IMO, warn_once can get lost quickly in dmesg. Maybe pr_warn_ratelimited?
> 
> Not sure what others opinions are..

pr_warn_ratelimited() still creates *a lot* of noise from a system daemon ...

-- 
Cheers,

David

