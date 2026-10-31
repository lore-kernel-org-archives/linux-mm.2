Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BE4606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UJaB6/R7
Received: by kanga.kvack.org (Postfix)
	id 8BC8C6B00EF; Sat, 31 Oct 2026 06:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C2B6B05B2; Sat, 31 Oct 2026 06:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7829C6B05B3; Sat, 31 Oct 2026 06:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B636B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:52:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 365451C431F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:52:40 +0000 (UTC)
X-FDA: 85382608080.20.4FC73DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 604CBC0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:52:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJaB6/R7";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793443958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nELab0FR/ewF6MqcRa7dk90EvRC+uIJilTIJqRMELkA=;
	b=IifeErfeyIyX20yX9b2yURkPIBSdd/duXVgnLXPm1Sbr7uJK/mz2pBgy+JuWsiWE6HS0Fu
	MQFZzKkQxhQz0WeapiFQrPnm05wCkRl2RFb5fPOYlwGhYtWAfhjEZnlK+x3Re/BsG9phom
	T8/xjnDsHUey9ZTSCGw6+Y6TpAizlLg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJaB6/R7";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793443958;
	b=eH8tPOfAD5CUWHBuJzhuUO6VMEhXeAvVHKrMg1gm5mYb8VaAPzIdUCvMX9YB8ndfQyvoSN
	bGDF9V77WgXBO9qPuvaTg4jveHoOfiXI/l0n3TFHr9EIHpm7MbnE9rZH5MTNO6DBjIGJP7
	XyG3DsiF+rfICyk/zXLfhlGGgL7CNBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B52042DEC;
	Sat, 31 Oct 2026 10:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E911F000C1;
	Sat, 31 Oct 2026 10:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793443957;
	bh=nELab0FR/ewF6MqcRa7dk90EvRC+uIJilTIJqRMELkA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UJaB6/R7uk1mlmkAIzYMEc7DUTnLcT8xULUIpx66y+1F/KK6ZNgvK+sbbeRDlU0yS
	 ulN/zOlwsrFR53cUj7rj/bJ+Vq7YZe1Sf18FOuGYthYqNZZvmCD9Epe1JVyBVuXPFE
	 ghqt34gN5SdUWf0sYcfx6GtBeb2oiKClfvHGkRr0yAI4L5jkMNKpSDo5lRyTdQoD9N
	 bscu3+1RVSih/32Knb+bUHkgwgQAshk/mnTLhjZ7PcxYaX+twfLad4pcz26uPb1rpY
	 OrODKE69jW3mWAszw1sQtuG7tAJLqb9XlAIxziF6jTuNJw6Yf/tYL0k0JB70TTZas4
	 yQEQsZ0xeL/0w==
Message-ID: <76579248-64db-47bf-b8d0-4eb3ca556f5a@kernel.org>
Date: Sat, 31 Oct 2026 11:52:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_stat() with huge
 page arrays
To: Qi Xi <xiqi5703@163.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Qiliang Yuan <odys.yuan@gmail.com>, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com, xiqi2@huawei.com
References: <20261031033330.3416326-1-xiqi5703@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031033330.3416326-1-xiqi5703@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 604CBC0003
X-Stat-Signature: xugdwzea4uftp5jf673gybpswkqbt3rx
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793443958-814129
X-HE-Meta: U2FsdGVkX18SLkxDPZwNrfvNHDShNw1euLPBUNB/f7kTjMkNp+nGAi0adONsUpeoA2YzofV6fEnCkhX7kOfy/E6NwRroC2XBNfGNRu5+tFcp7CiL8pdRK+frmPEAi4NFIMJLy3N+ww4ZOxEYUVh0EmZp8GoQrPOH233hgoVn45bGuqFYohbs2oaZJYJdswgoLknlvLPXdcM2/njS5LbbK8BtOiO2FiZmGVY53TMF/cyKRhLWvgy3zQRUckwNJs8gH02H94puShhriYDcAC4V+4yDnz1Q2kkI2oIoVxir0nEu5DWq0WnB30WIPEe6irI8ukEyMFeXv2pNcigYhFDUrRAPvVVWwHsGrnIEJdTyipOtnKQzA6Pb3Y8SBCRv2hMiGynpaTCoD8kg86Dsu0UemiyzXKu/IFgX4O+TnxcgAGXAjw2TL9q4Zgv+Vj5DzCUeBoNByY3snP+GDpjxT4csZRTRC8W1hY61R/lDs2FqkizbMjITfVPY8nNEdhAxZoDu0Si/ibpKVmjU9Hv2BsChqmZXF7yVV7X523v/R0EOR9QxgNR1bFby1SPB/5Q/mlcdzA6ugMtsLHN6KZ2c6lgsTfB3cHZE3hhoAN7/bwUcG26RRfjEl1R5chYzLq90dK2CFvRthx08tYN6VU/s0P3tiRY/fWw7dUuYCw98/8bp9lPFnTBfQrqahIO2O264/UbkqKgqxhudxXSlnvb5lUarBDNdmE5pmQVGC8ImCf1jFYFsau0WswDsiaos2uxCJVOawmqendenaaURaaxAVNRQ2ZnX40eZ1/mS/i1gdeaCPujzGHay10YoR3Mzr0gcdzg/P4A4jAzRUI1qdHC5pJkNgPUoySndpDv8LasaahIeVSY/SL5HCp4hQj+w/0VIlkHpf2U6SfWYZC3zxJyiRAUqgGzZ7pagRt2hznrKOnceZCnW0hePmE8yWb/+5w1RQEquU3JxzqIaiH6ktWlv2Qm
 oEDHKHYd
 8tzUB9fBTiDBWzobnCPvvWJxr4ui1LkEGvjdabOTDhf1qkqteITlzyDDbDY/vVEqGLtM0RobhHSqpFsmiwCTg3EEbIWKuO1HdRvDYwmlUCtW6SmIiYEl1oO0tFUIZYqXo4IMOzOMYhiFm+nYes0B679W6rueA7bEO5V/m0g675D6CZWFq3Fkn6rxg7/vQ0d4MzOQUnRKrkNGGJr+cPQljAQYbpy8TFR9cKueuj9xe0ltSbDhpqzlDC7qz6UfDyExHQQBj3ij2t8p/+ojlquuvNe3NBUIw0htipgSaRp+vkJyc9bL8X5wp3CiB60BqzdM6aJFCiBRQX5Qcw4TJo479fu8i4XD6UGmn4ZVvxNPrkjZBAeR+WkOPZGtAgmGcvAulYzTT2JQ9Z/OzJfSAPBkir+HziA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 04:33, Qi Xi wrote:
> From: Qi Xi <xiqi2@huawei.com>
> 
> do_pages_stat() walks the user page array in 16-page chunks but never
> reschedules, so a huge nr_pages can hold a CPU past the watchdog
> threshold on non-preemptible kernels. Add cond_resched() to the loop so
> long move_pages() node-query calls yield periodically.
> 
> With KASAN and function tracing enabled, a move_pages() node query
> (nodes == NULL) over 10 million page entries (~40GB) can trigger the
> softlockup on a PREEMPT_NONE kernel.
> 
> Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  mm/migrate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7bdcdb57652f..6c2371020cc5 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>  
>  		chunk_offset += chunk_nr;
>  		nr_pages -= chunk_nr;
> +		cond_resched();
>  	}
>  	return nr_pages ? -EFAULT : 0;
>  }

I though we wanted to stop throwing in cond_resched() at this point?

-- 
Cheers,

David

