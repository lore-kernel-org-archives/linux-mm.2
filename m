Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3D1C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE626B00E8; Wed, 12 Aug 2026 07:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5336B00EA; Wed, 12 Aug 2026 07:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4926B00EB; Wed, 12 Aug 2026 07:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1F816B00E8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:06:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D307160246
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:06:12 +0000 (UTC)
X-FDA: 85092338184.17.6DD0E68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99E4D40007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:06:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwSyVabW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDzCYichzDSEcw3dqF/NDMA9kt8syQtQ95yT2do8fzk=;
	b=1I7/Xg6fcZSOnFMq662t9nn0wkhsBDO1NvwFYmKehLr6bXcZ5E3/cn3TI81TWWEj/3rbrO
	VaWBTt6wr9dcnCyGRcy2uJ/U9IcCihAL/sqD3e96XRAdw58UQ7jDGBP3eLgIZd3Az0Jt5z
	jL88taPf9X1/fNaGD0K8dpEn6tj1ZNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532770;
	b=GZULyjb/aRTfHa4cJmKIRu7gAUvTsqU1jYxMwpXzAMg9W8TpwvCkwlQb1rIqG1ZmFu8zgf
	IAyb1CNIXbWE0yGEOVy3wkoHDhX34uYo/yeqTBlfP19N+STcgF7vkaQPS290VvL2p+2YCr
	6RVarmJlxCvWP4Nfd02IMwnluPBsLZQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwSyVabW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2774F600E2;
	Wed, 12 Aug 2026 11:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3071F000E9;
	Wed, 12 Aug 2026 11:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532769;
	bh=HDzCYichzDSEcw3dqF/NDMA9kt8syQtQ95yT2do8fzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dwSyVabWR6PJJ4qz5yJ+EsK9GBIq2itvgzG6L0XS3n2UcUg4s5bKtQD7XBlFhVUwr
	 IKJUuHLRqgrJ9vrNJknI/ms+csBFrkPR9JjFPEH8hDpmFAFyOBXKLw3UTOznSBNG+V
	 5NdQG6AFIhb1XbdDCgRphAq83MLD6OYyCKIRzUXu5AgeXzKA+vkK+rP1j/IVYM3sBX
	 6K1LTweVvEKFyaoWWfhm6NRWAjtpf//iiek30y2yytEyU9fTdOLg6y68bQQ9atRgkA
	 IKZa4GrgHDHt5dTblJE4oZHCfhw4I43VhnOIFZ0LH3z/ly5ibt8ETM4XGtzCQin9TB
	 YtsKKPyerErQw==
Message-ID: <c99feb0b-cafa-4f3b-bc28-e7273379ed30@kernel.org>
Date: Wed, 12 Aug 2026 13:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
To: Pedro Falcato <pfalcato@suse.de>, Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-2-375ef0767206@debian.org>
 <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
 <anxOqNmL24Cj9A7K@gmail.com> <anxSXZ65lveAuGib@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anxSXZ65lveAuGib@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4eir15j7c19f8nufbifjzr5774dyb57h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99E4D40007
X-HE-Tag: 1786532770-582127
X-HE-Meta: U2FsdGVkX186BKJ7sYjEUI4jj0yVltkzAaQekxD+QwCoMmQ2KLIlTDvQyYLn69oveCr4c9Zl7tfUVP6TidtyGY0CX9FPwUtvE3FKcplq1mixO5vEGKPDaP4H0ImF/Af1PTVLW2xwgbGdYsQ5ObAyTqDk0dFn3KD88gP7JUM/zpOvvfuhqpGRpUFSPjMGnBoIFJpGeRrKPGqh2m5EwdCsKw/a0FBA+EnCTzKkkQicQMf1iMmqaH9fVuf/vIJKo/+wLv0fWrTDN6o6kKNuuQdIVM6mm2pHj6PB4bGF+3Uz8FcMP1iuH7bEZj1GimhiQDA/Pi53OKQ/qAYid2QSsEFe1XqOV16PRx0eFTYio4/x9IElrhpAcgrTADoVdtRUKXRewrDvfwXRLO+YIKv227lA/SRN6xuEwgvmez0ufSSsHaUfJupsLBcRHmXGTb7RE/DFFjIDWlMkfQt+xAu5vAomiLWS2b6QZYkGYMaMgHn8qQe/5opbTD4lKzbGa9gsvDh44vU8w4r3TZ7AtR/MHWr8RPgQtoDzN+dTcYu54lDm9efmOroD/HnWLlvC3qQe3zw5HM2My7538wEiK/tNZBgRlMWbvqDgStphKT3/lDXO3hDd9SUAdnQvfj/IS0K9ksw5oGUFYNBv/cMLq2h1ntytwTgpWSpvXaOMFqTUjb7VCGZ/9iF7A69H63L9FdsXeRtAS9hf09/i/1920pO7CHlXgl2S1dtJZtUM7RObkLVF4qe4ufRTDk1q5Dm1Q+qQKdf0d21/U/g9PDM6uGSGmQsUN5psbZlvDWQzbSNzTzWeBZhS6JfMbiQAREBvjAj6COknz+tzd7dXl9lvfWUjXPOZPrX6QyeUT/1Ba/jPsMFC/+3GywDSPAIKsrSit7rrjeFVcQ/0hfb40va1bgjwivMl5yCX+UgTeny1dzD1mhHEbGWWnfvAukO+XstmlHnJYK2jX5y8H4R9dtRl14EZK1I
 6/aOkaDH
 kki4H9XBbDhIKf47w0/oUg4k37Jr9Kp0y5XS1MTsyjxZC+TRFZCMeiJ+XP50WLAkAFMMlbu0OUe5ydshfDAzSwHxOvd3aDOAvmZ8E9i3t7M/fLBjVH/Akuojm7N+kmUXBX+50/6DysdiI5K5pp1deJCwbMnlfboASASuCfajxZaN6k8s3OteauIoKiTQlxt2GPd7Ge7U0fJPE/dG2aoNZKwxCW926+kiOsjJbqnmxiF4x4q0adN90SKntH3N5pInz5Aj4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 13:02, Pedro Falcato wrote:
> On Wed, Aug 12, 2026 at 03:48:56AM -0700, Breno Leitao wrote:
>> Hello David,
>>
>> On Tue, Aug 11, 2026 at 05:36:31PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Is -EINVAL really the logical right return value? Running into bad swap entries
>>> sounds more serious to me than "-EINVAL" :)
>>
>> Good point, maybe we need a strong drug here, what about -EIO?
>>
>> I picked -EINVAL because it is what the swap code already returns for
>> this exact condition. 
>>
>>
>> 	* Returns -EINVAL if the swap entry is invalid, which might
>> 	* occur if a page table entry has got corrupted.
>> 	*/
>> 	int swap_dup_entry_direct(swp_entry_t entry)
>> 	{
>> 		si = swap_entry_to_info(entry);
>> 		if (WARN_ON_ONCE(!si)) {
>> 			pr_err("%s%08lx\n", Bad_file, entry.val);
>> 			return -EINVAL;
>>
>> But, I do agree -EINVAL is too soft given the situation we are in.
>>
>> I will return -EIO in the next version, if I don't hear any concern.
> 
> Perhaps -EUCLEAN would be a more fitting error. It's generally what
> filesystems use, at least (EFSCORRUPTED = EUCLEAN). 

Not a big fan of EUCLEAN for the use case here. The details don't really matter,
but EINVAL just looked rather odd.

-- 
Cheers,

David

