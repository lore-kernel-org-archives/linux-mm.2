Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0104606A8BB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ioK3MhOP
Received: by kanga.kvack.org (Postfix)
	id 22D786B05B4; Wed, 11 Nov 2026 09:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204B66B05B5; Wed, 11 Nov 2026 09:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11ADB6B05B6; Wed, 11 Nov 2026 09:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E03156B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8041D1202E7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:22 +0000 (UTC)
X-FDA: 85423139004.24.3D26189
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7528D4000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ioK3MhOP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYyJqKHKy98cz/KTExGNTJetx9UGJc+W2b5O0OHZLt4=;
	b=gMjQxMK2JlEyjkw1RjNp5kusTvkpiNloer7QJOFqLvgl0kyIGpFZu8/PjTKEfNN+6EV129
	Jabz1ulRjxmN17V927psf8sy/bYW0NUHmckII4XwAuzdJoR4CmyfO1fGXtHYftRNJd0vUz
	zzkRPu80Gv4qLZohPrHS4RNXrjSTlsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408980;
	b=eBAikGFx+Pp2PXxAWS+QO76D4Tn9mPHMwg5f9SUiXLdBr2QGTrQ4Ra2LKAczb+vMZAtun+
	BSNG0gLI6z+NAEPUm8zDs+7WgVT8dZJxLPNZmqCoMhp2SjHXh/X8FEqJBZ633/uxI3cCU2
	Dows4hT/mVVUZE2ojj284lsA9h5J94o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ioK3MhOP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so32275905e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794408979; x=1795013779; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MYyJqKHKy98cz/KTExGNTJetx9UGJc+W2b5O0OHZLt4=;
        b=ioK3MhOPyZBapwkfbccQhOY80lJXmU2/+weMrVxg+KVVi/U6eEidyoL8mkmOlTsxfR
         DpUczt/CsCTJkC7AvoKjfXLCv0/e1yK4djU4PW1w2423Sn2pO0MOMU4YcbT3HkAUcBg8
         rxsdQwnGlkV2UbanqLVf+dyB3f62J/69i/Xv/zGxmUzpmZdT6jkzrmVsnxh1SIQt7zV6
         slrUIcvzNiTh63d6nMRpAUUwZt8igWYKihVAXOCR4L3TYpHgAvoI0WUuCaIC0bDYIabj
         u1xZAlw4pZmhsfqhz7rRRK6cCW0RQbytIEQg3Avn/bAdL0RH3OYJd5VhtptkHQkY36Ep
         pvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794408979; x=1795013779;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MYyJqKHKy98cz/KTExGNTJetx9UGJc+W2b5O0OHZLt4=;
        b=paas1H2ODXFUdmE60HLtD08OBNFfcoNuviLWZf515HLVCVOXNOgIcDcB15mW1eqU1m
         6khbyUmVGKXl+ctX3d9v+oUx5MovJTL4C1wBZg1HtPw7sBZ2LitVOxCityjTxbcsam/G
         PK09VBjs/vPvJOr9gwvW116tih66x06w4uJz3XmGkRzKQawLStEyGBgYYKCwMzP0SPaG
         cxy4WeRyxYxpOjyMQMPUuy5airtPnZROQv/NtTMr749Pu0OikjkcNFiq2DiDPIrLTu++
         XLOo1rJrdM6bDuC7ioJCg5U3tJ0fKtHbhZthswZZrhjBLFsBGu4GpnTGMZ83kESpV0qm
         BPIQ==
X-Forwarded-Encrypted: i=1; AL+hErFGzp44QGxmXOaA5RDyfsct86su/XRIYK5ZKouHInmAt/6XLoB2egxw1L35oXqgDDNRcEDyBGKSXQ==@kvack.org
X-Gm-Message-State: APuU4Z++I2EVj14Mf5svKlV9luvID+SG7RORytm/f78FUqKNQqo+kfKS
	yvsrU8zx4Lks0cw/TXic1MZrQzHhG9bh6bUdm3n/dbZcBq1IkDYigO7v
X-Gm-Gg: AYBFou1JPIYTqsWE5+4NvmVj0CJdhdai9rRbcsAtkVzjDfJ4EXhlMGJeDDPHRaHEvI9
	EaVprq0gRgVydTkthYsQmwRT3Zg/ThQkBkK7fjs/9vNh3yv3qwzIb+/FododLNnfFjm555gWULJ
	vDPpij6hZ1fAWVpVmo4xPInKJ7lUxEnfJhnD9N3/qH91K8Q+8YhsNbdUs8WDNMvCtUSvvXJyd2s
	LZqCeh/VOU8vF69PhSlNqMZVOy4oGeLyEYqjK07T1ab58ii0NKdpObZuArraXlAww77fzWE8Kxe
	BwKW4ojWNLjp1DBl2JPdQeXCwOVEqphDg35WHNLbbxPuazWxm7SMQMF0Db6FW5JlaUog+HQeVke
	1PN/GsldxkpcSwokuE6JJi3U4L3TwAwYm7cwyHcHgo/knwROEAAU1Cjtgz4yg6KWrXOFaXMl+hG
	Rv9/yCXOIJirWpWew6y/bzGDQPapGuLTPbCK0F9RHld3wqu6Vnyy/PeDqMDUTl64V17L99aUS5z
	twgZEDR0minnDR9dqzPmGkx3FVCfWurFZOBGPiRrElmLsW2OOOrcwMj7VYsrDqHUR4tOrl8gQ8s
	6yE3j6ZhKNLIlqkXwJi18hY0WfgoMVu3/aGt7Dimfm5vA06IGZPQPqQRg/1tffIVsWAeqg==
X-Received: by 2002:a05:600c:e558:10b0:4a3:18ca:806 with SMTP id 5b1f17b1804b1-4ba0938e116mr29687345e9.20.1794408978700;
        Wed, 11 Nov 2026 06:56:18 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4c554832sm1533175e9.12.2026.11.11.06.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:56:18 -0800 (PST)
Message-ID: <998f89d2-774f-47d3-b6cd-df7bbfbf2b3b@gmail.com>
Date: Wed, 11 Nov 2026 15:56:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/hugetlb_vmemmap: fix deadlock during PMD split
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261111093747.50048-1-songmuchun@bytedance.com>
 <20261111093747.50048-4-songmuchun@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111093747.50048-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bo9kye7ppqrdwf644e3x4w3wmuwkbiac
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7528D4000E
X-HE-Tag: 1794408980-823928
X-HE-Meta: U2FsdGVkX1+InPvOar7IQKgsi4IlDCzK8UnrGsTwSfTEmQi1YXSRJDHE9E7Ax3b1SlcZZfR/Dpm39bC2lkyl+x+5991LsoSoXwyTUQERFkZkms92wGRjOPhpzVjcdiy7kNtBJ6U2DhDC8Pqr9a3AVlvzeeVkG952mARAioYvFPCETjBgjgqv6AdlCwGwf7DFrirVmeaB0dhAOhpFWjTblDkk7I+JRSadmlalO1yaMOOu0FcZhCB8JAHmwrugvQ53ei/a6gg2cq5of/ihgrn8GqRj64ca6dj/rELfhQGjC7LDWkccJ7lheoLMiS3uE6aSNmlrsO47NHzRHDG2oEpYJVWCzKanKyvDEYlCnT+xERe3UWqDep3sMp31Hc1IQpED5aX2Xd/bUwQlkx07IMKvT9AlkLxNpcJoj5rZkjobD3tRCbBkSzMQkvkI1xmagR79arzLStx9H7JWkhSJTFAxCD9sv8Ew2BSPk4piVGe9wwX5YsnWMIls2mJmlsNjT7EzfL3xo++VpHZN8XS6D8ddiICWM7TgwuMuhez/j6HTojU0GznNzumaRwkNH6eW299/XNNoZkOFmP2RFctHEOACpbCR9Y+lRdix7k3IanLwBwkk8BLap/4/Fq3W+2UcfyPavjpogluWW5d6+QTbjQTmCYlOlvdI4lm8uo/zNY0K9t0Y6RuQahdtDEUXxpHj3OQeA0YbnTW98KmDAb9nwAC6BEEL5WDNsQ7K0XZtYtmwuQ81siDgPmSPkcwJdo1KahreOUU47+emprEG5s+IVUbhau3WlezIx+cBwBtSgB7JksW7V+RNeyGfHmIRlu/a0qxuPPB5bA6IUK78KeYVGHzPZFdivpgudy1qNcVTsIcGcNvFoMLkQuXNngHWV+5Zqynssp7p8wnUgXSPOQXO+ms2aLf8W6JNwTapiLKKt/GX43qH0oDMAzx/NvwqrdWPf41boe3rGdbOrLMBQiWey21
 Uy0Ynv9S
 LsQqrleSUW8lHl9vicWL5QJr8geQCNbFM8q1qhvXTUtmim5xVS7ZjKNrFzgJT4rwkmWc3JNlBmqUSFhy/bN+I4Y+QOK+ytxjlH3waYt6SIIrgCp0JLumDauSocb4zGQnQMeUR8GzsO+6wWsJREk3eiblAspoOaMBFguKBMdJwiskfLHGWRRSeHpFFCwnrB7I5EY3XQbSXDQNVjB35BRcROaNazqpR/Lm7yQGvV/js/tvv44PMW0QbwNNRHsE9xqO2/GZ3dNznYjEsVBBvIJRKcRpPVfJmMDTYAoXBoRWnHX/rFkrNxMZl6rNsaDA+851OFNUX/715c6AoSf65lUqgRH9URDKXB2wN2Vqihtksb+ZIUbADOTAV/ziT1yzT96r1as2aYrXzhZB2/uIfK3LxMBeGPwhb3kZwyaKVIyj3T9xQ0mkiM3tukpa95NdlOM3eR4/ipVSOER/tHgikvaN1NiGuF35FSdr+JkM2e5ItZGxPHzGrsM/5OXAzVq59ZvCo5SyCLweQnMRlqUBerf+VlP96He8qpUlmXDtDZK29Va5UFHluxes6tkzeSU5OEgoBPlkI3PhGmXWLvYJ0v222+c+hAeA8coGBAeWM6dGd222mXozPKRtM684x2otXcgZ3f1e6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 10:37 AM, Muchun Song wrote:
> vmemmap_remap_range() currently walks vmemmap page tables under
> init_mm.mmap_lock. If the walk reaches a leaf PMD, vmemmap_split_pmd()
> allocates a PTE table with GFP_KERNEL and can enter direct reclaim:
> 
> hugetlb_vmemmap_optimize_folio()
>    vmemmap_remap_range()
>      mmap_read_lock(&init_mm)  <-- outer read lock
>      ...
>        vmemmap_split_pmd()
>          pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
>            <direct reclaim>
>              ttm_pool_shrinker_scan()
>                ...
>                  change_page_attr_set_clr()
>                    mmap_read_lock(&init_mm)  <-- self-deadlock
> 
> Since commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
> attribute changes to avoid UAF"), reclaim through TTM can enter CPA,
> which also takes init_mm.mmap_lock. If a writer is pending, the nested
> read blocks behind it while the outer read cannot be released, causing a
> self-deadlock.
> 
> HVO walks vmemmap ranges whose intermediate page tables remain present.
> vmemmap_split_pmd() revalidates the PMD under init_mm.page_table_lock
> before installing the PTE table. Use the lockless page-table walker so the
> allocation no longer runs under init_mm.mmap_lock.
> 
> Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-206969@kernel.org/


LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

