Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8985A606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JjpWMhIm
Received: by kanga.kvack.org (Postfix)
	id 956C36B05B0; Thu,  5 Nov 2026 05:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F086B05B4; Thu,  5 Nov 2026 05:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845316B05B5; Thu,  5 Nov 2026 05:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67EC76B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:18:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC8DC140937
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:18:01 +0000 (UTC)
X-FDA: 85400664762.07.1C216C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2505040003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:18:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjpWMhIm;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873880;
	b=R9Qp8ZzYbBBMY7dl+aCOC3HocdAktqGgi2dPqgfjOJM9xbOzLeJ5e+LxkzwyL+SLjZUyuT
	8ih/G43yAqHtp4G7vmbVIGc/M/LV9p/2NFGneWItb5+ZAwMO+lPafLYLEnqj45uopKvg0U
	Q8UZisIG3KSPAayxnLZVjrTZiWn4rpA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjpWMhIm;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ge0csq01UDr23GRywGYDdJfNDf0j4kn1jvr1l1h6C8s=;
	b=Cw+suXeI90/0covCkLbFptJV6oSTNEC7HH5BCplSAopBo/NAdkrGCScp2CXaK0zYm030qZ
	xYWSa3MU/tCOTvMuEpySLdNbiYe2tIxnJ2UNO+CKMfP0fB79UFnhMoh3WSQNmsyC1CQHXy
	pgIU2j3dFopH+MNmP2imvS47r9tJGqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB789605FF;
	Thu,  5 Nov 2026 10:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9701F00919;
	Thu,  5 Nov 2026 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873879;
	bh=ge0csq01UDr23GRywGYDdJfNDf0j4kn1jvr1l1h6C8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JjpWMhImRu+LAmbhcVmFv2rI+GeyzSZNvjXT0r8xfZLpg331rjnt55cx0ggPww50w
	 VXDPTlps85VpjVB00uZULQZcEnh2cw4udDrqGKTfeDTF4YLWeROIoWjdXEkimWk4Tn
	 yTFjodeEJzt15GfJbm6XgFo3K6QcdTD9Ra2rJ7AOiUYNer7+yE8dSM5Fs+8SD2tmXw
	 kBnJBuXCOriKvzR15xIJkefyO9T8d+PxLBK94+JuZsnNWKJGfBzp6thjdLmBqkh1pM
	 3BnJxbvHoP5FebNWl+CUmyjdhMGN0sDhYBj/hZARkU7onHM1zCZ1BjrkFH9Sk15uLe
	 8XnrcyvfAgAqQ==
Message-ID: <e58309a5-1a5c-4c34-9c28-d1794400616f@kernel.org>
Date: Thu, 5 Nov 2026 11:17:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] Revert "mm/khugepaged: remove definition of struct
 khugepaged_mm_slot"
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-1-a07ab16ac860@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103-khugepaged-latency-fix-v1-1-a07ab16ac860@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b7tddda9fyho8epp7mxsfpd6zgibino5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2505040003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793873880-304303
X-HE-Meta: U2FsdGVkX1/IO7fLazUkLJvC/BHlmwJ3VEP0XwRa14BNyT77bzDP/WJu0ct+RvI70gQckebk1+f6EwSKfQkEvYtvCdoo7e6OTU4kZhFzbwCH6qUOmaAR6kKJDZ+uXqUpUnl9WbcZbKALKkG/U27Vy2HTpmVf4SWDoEmFvr+iV/qhNn0RYheQhkN4ESlm9ISkUsMAIooqBDK96glMMb9wn07sF9Hfb4zhSwfRv59e57rf8hUs46nqJag4UDj9ZHiJV3XW+LkuK6n2OekMT6aQa6YeztR2xFbN0ThfImDG9ICvWPYgL9m36qB0HcGZjEyPXbT78UMWYSN/giUJ4+g3e4Sg8KnkzuyPfm5Y61QndLHRCPMhju7Hwh7mcAeYvNBYIdEH765XiHjG0OWREgQVF424Fk5er/kAHHLOsuhLEtTeFEamgPnI0inQ+R4GM7BagiHkAcrBEFJFNN/cKa7xic2GCgVMW5yzj419/iPxBIvZauAdc5JVLEoYp6MDvBn5GQ0M5511F/Wi6FJ/kzE9m/7XIiSZieU8UhEwopSOPe6IvY/sw6tY4XQhakEJsrv0E2fwgGA1KylbLagQqwQezEWGyF9hp5XJKcSIKZ34qw2K58mvAHrTzmBZuNxtD9IpKCdGQDVz4Bn8jEul0QCfu35Znh1WH+6EmemwCUEuL8KankpoQT/r+kEvJjX2w+U4Bq8ClsX2lJMfL/5fjBI3kMA9ezQRIFpDAs2PJs28HIbkgDR6a2ZZfGJkpHnc50lWQER6UYgLitk+TFWW2kzlRt6W1AGpzzcE2zw3DwJdn2Dqo6OGcQ2URMwLTiV9OxvIt7tf0zAN2LtaiP2fuTrRVhWhZ54XMAlZeeMXZOk2CXhy2IIHUrnNrozA9+J5aO+HX/pWp/a+obsPVwHhhETHolFJkkcTFnKG62vjVPla8/RUQO6aXZCKuD75/pR7ywG0HDlTFLDVLuL0najU15x
 gh5uDg4I
 swFRY7eA6T/8jN8oSaF2CWxFRxnF2fq/J345dB1YvFc7IV1eKRQOZYMgluWwJRYMdgToac1NRw5HxkGVntSvwLZqOczaNBzpqSdMKS4VJ3g0sMuHFGi5H3D/4euJmTg5cQ5ZPBIRV/DJJttD3BvEGnrupbSSbvUnviPIyPugglrOzBtyRzaoN1bz2AUw4JxumKjXghoWgEKOezclwCbRk1b3edzMe47uQToYPHMqTNKpdBqpXemZJNcZWq094TsX0/PYjYhDKp7tI4PTBYq/hQr/pdhEhvBBju7HwfFsj6gs5c0/QTVpEH+ZEqo8oD/BiZ4iZjg/ms5nggcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
> This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
> definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
> resurrect this type to store additional data alongside the mm_slot.
> 
> The stated intent of the commit was to address a NULL check in
> __khugepaged_exit():
> 
> 	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> 
> slot can be NULL and mm_slot_entry() is an alias for container_of(), so
> this is container_of() a NULL value.
> 
> This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
> NULL at 0 results in NULL), however it was right to fix this, so retain the
> fix.
> 
> It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
> and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
> KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

