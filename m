Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36ADCD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A766B014B; Fri,  8 May 2026 07:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B2C6B014C; Fri,  8 May 2026 07:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0096F6B014D; Fri,  8 May 2026 07:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFB4E6B014B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:41:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70FC88D888
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:41:51 +0000 (UTC)
X-FDA: 84744063222.07.42505CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9BC79180008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:41:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWb4AFCp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778240509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbX5LqxscCH5WjpeBvd2gWE6WkZV9w1Jos44yiujkEI=;
	b=OdNR2NO4sUPkOJ9IL+angu6uo2UYrGIJPXzK8+H+6Rwi+ylF4zD84sELGopzofOi4KFPEn
	gHqne6fVc5joiC/7pDQfFvnn+BebFxKKWJS35tr0ocxUAM07mmwYU4ty22EVHXxuBO41jx
	2IWHfLJqFIZVjICXWxReopxdBPxFfyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778240509; a=rsa-sha256;
	cv=none;
	b=mJ+4o+CI6JEPzKsrA3MxPa0p/VZAQybyG5Rrl+lx6aM5Bhpw8CDIi3jzUFLd8EwnT8vYnW
	D+042RtkRTZFKO1uAdj1dm+Q0O2CvJYqzF4+wBruzjAFqYNQJJueOHH1Srwo9Ii/vxuOsu
	JwDBDxwOqFnTkRgy0FSscJuTEiQkR+k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWb4AFCp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1EE344458;
	Fri,  8 May 2026 11:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7409C2BCF7;
	Fri,  8 May 2026 11:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778240508;
	bh=9sE+9rgzuijK1BttMoVFWrSFZxHaWEB/Llh9fl4m9z4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rWb4AFCpR+Yvc1AnSJfwmbCMEBhHV8/k+vK0apWeLlLeBIoxqXRNlij5y9DTGYxcI
	 D+/5kAUbQKf+fNpfhfjEgnWZr5YlpP/8E119TZ/v+BmZXoK+rOd5Elgf6xLpRa0+Rc
	 z6pEoLYw2a9BtZBAG6mY8qg14rfG5UDpFsbP1lLQVFriXvsmrdQ9dU08jA4TDtE3Vi
	 fYFyrd4I4Rlme55RKhw+1SDVphWYuqQkQmrJjTIwR1oqKlf9PFCg4byyp64Xs2QMlt
	 Z1WiaKknJ4TU6HwkqFHmmAmGUuMBGx37VhPbNGW+Mny0Pm8vxtIV45LAxQZqcnj+2U
	 qy2JYl2WV8K5w==
Message-ID: <0e4e4bba-cf6a-42dd-bf7e-68438fb99cd0@kernel.org>
Date: Fri, 8 May 2026 13:41:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
 <24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org>
 <6f92ad63-e601-425c-a61a-5ff929cba738@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6f92ad63-e601-425c-a61a-5ff929cba738@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BC79180008
X-Rspamd-Server: rspam04
X-Stat-Signature: yzzeeq6zg5m9nz71amfu9yzuyee17wqa
X-HE-Tag: 1778240509-987843
X-HE-Meta: U2FsdGVkX19Tor6uiDPiLYgHH60WBhEv3E6F+KBA5fOBWiXJwmsaZIjN3AcvSu04UqGdHen+NywZlgV4FtKr+B8q5ukQZbQKMKtRaRkXhvkxEGlC2HJ3bBCs6Otos4G40go8I4Ozr+icE2XCqNbea5zh7rz5+qtJxtHP4jOV1nGgSfmOeJ6bxxP/yug4R0lKDoyFex1Ly/1DsZQ1jqtNLxYD1bhT7sozTOfT0Go/ns6mpWfN18J4Ieo2SrKeX0L99Nxmz1b4AqS2/ZbziEZVoKse7XSc1Pi+Ute9Z/nLwpVjaunlGkLeV9Qm6rjBYhtXccy69k4B85a4irbcbHpTKa9tAbH2U3XyDw2tvVpg7esbhE7Wgy5hL0XPBAg84DKKEZrke/Li+PlbJdaEbNhb1Zrzoj5p5luMrT4NApOeE7SDsmCthn6QtIV44/FgiSbB9SOQxafctPufAfKGMSxmKnZqaFf93hZODTtMScUKooo+vf7WfJnv04xuWZJyDxkqWrQVmGn+u+RS9bwwV0jhmr7FHfgmIgVQuQ8lsoDyMEyYTsa7LMOK8YJpAinBAF1Yex/fxJLpiDpdwE906bVefTKeoRovb+oQQrB8G1no51qShDQqsJx+n/JzDNsnEHdQVxA/8mb+ClCPxH6oBZJNvHs8JcVz0V/HzOjfLh4UbvwY4W//OvaBxo1GKge0NiNxc84+htwzAdSm1lhU19vqJuz6qRSWg/vrfwE2JkBSE/U0PQPMoi4RyEM52Hfsv/lzcjqZkl8uiYA4XASQPGie/7A0OK3WCAvds7TYVUiTUGC/DKDyIYm0ZfhCx6num5+C3c1dvsoOWe6Zo1WmEPq5hAFzNJaep7AZfrY/JlNp4BP7OmO/Ly2hLDWCDgraWjxh33nNsp6no38LqOUZP+LA0399YqfkI8nvDjnamtv9HCChL9OQIt/LfYlO2gH6pRBFsVJ8D0gys8I/krN2Q1N
 zA9+LE6F
 BIhbLTZB/DQahvfFRIgkdVFZZoQ5tAawh7+myzl/BhkJYEzTtwuk9Ps1HAd/1rRH9KpPvBzWTTF3s2oCCwyvWffAaGZeB79b06tJ96KViz3NKQUPZQZAhpOkrWVZBI1I8eSxbL/exomvO1wEZ8158O0/BgyGjhpmHBnMfF+Mn9B81qLyJOjL4s+59Dps5/iN26emLXEszXVZIrX/phsFwprxAHTyf0YuBEmYnIXrcEPjvNhs7Vdw+v6ZXzypYNWunxzBZcYdF3vFUKrgVhhLUzgatShXERTTzgkV+6Lt4UKwOW1xRUqfNSPUFSPhHe0OdBUBfPiQj32seLMrK+k09sz54LYcHevfnv2gvI+eQN9yst7GEY2w9E9jP5dZvpTr6WIrrXap87T1mwheuITaT5D+jqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> -unlock_abort:
>> -       spin_unlock(ptl);
>> -abort:
>> +error:
>> +       if (ptl)
>> +               spin_unlock(ptl);
>> +       if (pgtable)
>> +               pte_free(vma->vm_mm, pgtable);
>>         for (i = 0; i < HPAGE_PMD_NR; i++)
>>                 src[i] &= ~MIGRATE_PFN_MIGRATE;
>>         return 0;
>>
>>
> 
> The changes look good!
> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

Do we prefer that or what we have in v3?

In case we prefer what I posted, it would be great if Sunny could send a v4!

-- 
Cheers,

David

