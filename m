Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F73CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032AF6B0096; Fri, 22 May 2026 17:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEA06B0098; Fri, 22 May 2026 17:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9EF16B0099; Fri, 22 May 2026 17:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5EE26B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:16:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78B911A095B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:16:22 +0000 (UTC)
X-FDA: 84796314204.26.B22F032
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5A8FC0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:16:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nNwzPSZO;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779484580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGmWZbG2XGjAGwpaog1iRNN4n31HKv4MBqTgH3eSn90=;
	b=ZnpPk/j2Q6bEg/fRhfqKGbMd4hDFCitoYOFZOap3jkQ4XVBOQNqk9ZUTXOFfoWsuCurxaZ
	daYjCeOyER3po1u4N0zAS2ctasbkWrj4HoO9O7VHETb6xI4LmnMRq68z2yso6T/aimBMw9
	WpgZhBEVBL+DNjTJj67JZlQgJsf50WU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nNwzPSZO;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779484580; a=rsa-sha256;
	cv=none;
	b=Nrq11AwVsDCpKKHrQT+MfvMk+Mutll0am3f4qtIBs3a1bnjn0jAV5A5hXo3SlPhzC7aq+s
	1KVUA1qQX0CuCkLrvW9PPQeuG9L+z7tpPBdUPZcKKBlB1gowlPTqhT9RHf3ZauAoOnl9Fq
	IzVxfvm1/FIIsa3uebQwctwQxUod/eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87A9740B49;
	Fri, 22 May 2026 21:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495371F000E9;
	Fri, 22 May 2026 21:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779484579;
	bh=tGmWZbG2XGjAGwpaog1iRNN4n31HKv4MBqTgH3eSn90=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nNwzPSZO0ZEHyiAgw1qN6z/KxhNwy1BnxwrzxfF8GndiwcyyMdaCY7X5j2j5LaUFr
	 G4mnI05/cCDFJiSr3ohFweFxCMAqT1/Sr3dWxKvh7WtB8uu+PHmsa+HaLZqJ1RuLGB
	 YVzdC29OzzaPwCvyalyJNimn0BpZ9tbCAlDt/D+J6czOdZcvA+5feY/Ir603AcWDX/
	 EqvZN4LVid2f38MiJSe36TPmXRyJulrZcWynCXZjhnZ0/+FEyhtffNgG5HaY3IKmGs
	 9+7+hTgeuJDZX9ZCdi6abfB+XMebg6A9RgpDtVNy5oQsnvENBtYj7zGbUOB5bIXWm+
	 fRJIkUqBUP8Zw==
Message-ID: <dc79e35f-9e38-4338-8a92-aa26b7122ed8@kernel.org>
Date: Fri, 22 May 2026 23:16:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 03/14] mm/khugepaged: rework max_ptes_*
 handling with helper functions
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-4-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7ye5qu3gzssx9tuthj5regs53pztrzxt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B5A8FC0005
X-HE-Tag: 1779484580-62756
X-HE-Meta: U2FsdGVkX1/kwJAGQjWPDPCfsU1WiHvh4MkQq7UgujfSZoLL1QbKdXNyxAq8hx2ew6qUA5vkkOZAgvZ3bUY6QVUK/RhjYXs3HXsDgxDXvCR5rWxfNUwTbuCWjM5+F+C472zqDjyxAN4Q5OaHbDz3vYpKuNMdPzrEfUiFlcYZ/Y25ISYR67Hi/3Wt4Lf2FRGjaTw9cP9X5l2GlGCaMTfiy5MwrFlWchYQFZ5uO1W6Z2Cn4O1oFsFHT5C4wnfLRit2C/EhbjSeiLaCArRRiuFK1qYky8NZgv7DpoBR8vGLYxkXNBIGbEGIDqD/3AQ1MOiULyXHeRyUsj7pwmLNtruc3z8D9H1MR8TwnPAAm/YXt8ALAylMgYtnaRsj4WRLYHBBsoRw/NmiiB7+VBtqeTX4CmkLrGzcC6NVEUgFeynL4sHnT/4PksaOpFtKcsG2jWVIZ7FqcsuUOXyUnO9584hIFQUOiyCECX0JTA1492cS/x/ueGz4UINjsNwJaHV2hyFf/+cyXqNK9T1sgI9uSqN+DaqqxkEpEbWMcg0BAjF2vZLXCaGPnoeHZhZPVRXbw22h1ZKGALWz0VUaompKpgwDsEvQuzJDTkxque2+2JJqy3b24GxiCQWGA7eLJE19guvqP2OFb8mF9iGIjmIa7QSMZ4gbvKNVUP1JD3I6+h/WbhuxQa4zEzg1d9/cSXmHZVNWPUVUim+YIedGQxrIIRPGFiv5LS5HAfT9d2ts6eFym3Eg1E9qQaoMetERB4XGF4mMIfVrl8fpbp+hMwFejGHG59cp/Lh44F6kTrFhBWiv2WcskZdH9u+wiczPJ0mRPRc7Wq74WsKz4h5WHvpm7TN+vNkiw2iHTHMXoGXOgmrQ1/7f/vt5aUHVtc2aw1flZ6r2/FpS6WqZIcJHjx9rLVRLbpNGjy7e7nIsYYr5S+TVfvMGtLljPjvwl0sGpVNjOU3mhjx2EwK5Z8l/5hyQDyv
 GbpZBd/A
 kFYnlKu9/6RsEXyQk7rGMzuc0na2IQOb+++99W8wTI/lfItuNNAknVhfPdDx9T3u5xwvMRuU38K4gjLDgKq2dTpjx2YR0tn22oGjbaenr3N6ZORbX8HqMDzmdId7EjnNOJ3WFPlOLP9ito4AiXmOa7559mMcX/pROWBGMzX5D0AObb06AHXei0sqK8Z/7qV9NevpAWNbZrCdS3/svqgz4YkShgaAipW8KbXqJXAUL3N649NUB6iUZ4dTDOJ71f1Bz8Z830vFupm/7eoSxo8QA27OnrjBu1gsNtS0ekIUgci7p14ELJBUsoYnG+V1+hVZSDJlp8XVMAZxWno1KsqCtiXYWnWy/F5Fj8cvvYgWwtYj1ejyd5fElT2ClaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  int hugepage_madvise(struct vm_area_struct *vma,
>  		     vm_flags_t *vm_flags, int advice)
>  {
> @@ -540,6 +598,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		struct list_head *compound_pagelist)
>  {
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
> +	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);


Yeah, it's good that these are all const now.

-- 
Cheers,

David

