Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F03D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9314F6B002C; Mon,  1 Dec 2025 11:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1946B002D; Mon,  1 Dec 2025 11:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D10D6B002E; Mon,  1 Dec 2025 11:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6697E6B002C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:30:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 165ED58436
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:30:21 +0000 (UTC)
X-FDA: 84171439842.24.0952C4E
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35C0AC0015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:30:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mCLdjzQ+;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764606619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1MajTuyRJjvyDGO8DdgU3FYNJ3zCPF5BkNOmEe9i38=;
	b=f7yupayw43m8+YYJXwLZ4I2+1rxChY83A3YkNCBBBYUdhSXm34Y8md9nUbGf093O8t2V1Q
	jJlQoJXl5+/+ej36/5rDYRJwo2naHzN38ejJa39yHtLBhixnW9U7f5UnPH4vd1klnM6/9M
	zStfuRYoiJvEzcx+CoTz1nilzcxF2X0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764606619; a=rsa-sha256;
	cv=none;
	b=PrTRQFXZhzzk+QXLfA25DqxD9rMQzZqypRxUvLPRU7eZ0CFLfX9+clcLfEhY3IycieSo2B
	dzefZ73lmjYqWjWyzgHC77oC7scXvMYclaW2Z7O11BkTeSCv6Cu3SciC4wfkF3+b7RvFV1
	Ev9Mteyv1IbozjPKJjBMikO65GQLFEs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mCLdjzQ+;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7866aca9ff4so43275987b3.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 08:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764606618; x=1765211418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1MajTuyRJjvyDGO8DdgU3FYNJ3zCPF5BkNOmEe9i38=;
        b=mCLdjzQ+aykbZzAu3yDeOh0VlW9cj3tv9yWpyN01Ymt9G1AEPQHZJF4ckEVsv9nXrY
         H415BesPZTIS/ePjA45LuRzjUAV7MO6KEBDyxsKiAYV2kDJpwVQC3FMeBnrss5cFg0CO
         z3+nucTP/q+M4bDSo4u4Pdp+8JLEBE8UcmLF6ZOU1nwvmTL+oxLnMeBwGf6WMaO3/vaf
         DNhbKqgAMKsJVz4AHRtIbgnrbseId8IDWiRaSgG5Br2kF6JD17kCeizqPMZ7QwUDOolR
         L2PDjqo3TphcT9cKSgWuCj8iWTYvk1oSzNjUpDn4UrJ//TXVpUubXP3tqALDcpamBLVi
         0UKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764606618; x=1765211418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O1MajTuyRJjvyDGO8DdgU3FYNJ3zCPF5BkNOmEe9i38=;
        b=eQaRYKu5tzJxCi1P73DvhhT0WFXqm6gT1Je90GHJFQlOYRa+VGhyow+AdX+dBVwqV5
         Ed65Mn+DF7yFWol495HxDJcyNncE0oi9qimEgQKk0vwEjfDH7ih1m9lv7BSdF8Pv/YxZ
         uj4tPKMSe9NNKTkG6skXyVBuDI0gmci3F72njJKJxTvJPny/0RtGz4R/gY4GXVccUZjE
         Pnms7OhJJmeSv6VGgBJYTt2B9zKmRjllGs92vmb7chMiir+QERd+aYrpI6OPTM6ogCu1
         kUuhYlSKg0LSImu3LExoIBPYd44M3BOXMHyTNxNi/VbombVN/ECNzxbb/CPneW4YSaq/
         q/XQ==
X-Gm-Message-State: AOJu0YyMOPyks+h0RrR5gTosxK/+9B+Jsve63rscz6C3NoknZ4oIK/kB
	nq/imwOamzouRb3swPUC9U1a/b2TPvclWY6JyzuEWLQHbCSTYP+eEhbl
X-Gm-Gg: ASbGncvwJav1MCxssZMKEOiBMCQ8odEYe6mpg8pbbEyrMUZbdiWEXWNdTavoKcZl5DG
	1E4w+pyzElI7OJnO9J49LMMQMnUA+AHmDdJ4e0FbPeklba1TWn00rm3Hi6T6Rfd1vbJ+LYalItY
	TV4ee6PMhaE/3qtQi0DAydPuo4pruN3+yLKEeV/6Gd8RUCcc3EQ1APDiwviCmRXGI3W5zs1OVCp
	Qo5sbnt0RcqJHLN3hhlq2Mu9iEuoAUJgwv3usX3SAsQj4dmzgUcwh6FERjhCBJMqonjy3lRJJk7
	QAGlZhVVAN08OuQaWWciwZrE45nC93FykzApNcYlrwj93kbqpyTZozPTYzz/qssaaDAd347TzNh
	PdnfPVBcUEr155Of9ggLbmcTtHxL1p1s0kkyNqKEFdfulbOp6OnjabpcSmS47Yf98zY1TrgH+ZL
	ZQz3YZBJiRxu1kEI8+lHufsw==
X-Google-Smtp-Source: AGHT+IEsE9BFE/RlSs1hU8C9RyDgvjXgVsC/va7mMiteAnwqy29gcnBHujnkqzBPbQB4Bj4DPQkfDw==
X-Received: by 2002:a53:c048:0:10b0:63f:9a63:46e5 with SMTP id 956f58d0204a3-64302a4e69emr25312990d50.28.1764606617944;
        Mon, 01 Dec 2025 08:30:17 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:54::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c073a70sm5100381d50.8.2025.12.01.08.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 08:30:17 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	kernel-team@meta.com,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Mon,  1 Dec 2025 08:30:14 -0800
Message-ID: <20251201163015.1438580-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251121191540.253624-1-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35C0AC0015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: dpb7ef8o151jugtt47ih1j8gnn9xwphd
X-HE-Tag: 1764606619-471772
X-HE-Meta: U2FsdGVkX18HafgEdpeRNeOdpsPmQVBxsl7Lq4fz2v8V6yh/XsZ1ImLqngSpc1lesQirPkMeyhEdXv5olHHLMsW6M28ow9oTUI/W4zTi9laRHltKhfbA53SpKv9WHp5OZ/SHzRwkbl0ZaaeOi/wFZfUg/6MDt6/S/dKVokHLrMJhlaPVodmr+/EsGNfZ07xFUBXRH4KD/iYw72IVSi8q3mjwdAaqbkuXW4PSwYqTfY3e5735JPSoqMErMULIzfFbX8MyCLlwTwu6YyVBhcStR8n2GE8MUdQE5F9R5VzX35qEJIxwSygehEz2G3eOWbK9f67Fbs0wXhJeBLnlzcPn4NBT7nX2EAVIHYd7YX9j4fbDc5RnZu09ioWI2/pI0XRwGaHqvL5HEsDGhoygQSxp5f8+37e24mc3CyhXlgkyqD8ua3q5j69KRSdTyEG16NcVx0b15u05Q690fsv2m+KiFWUF39fywEMlKUnVvakQPJfVk7CUkjBDKhXbBYhvGY923CFCzytkenfvvWhqIg1Y1UoO5ye/Gk0FkEZd7U+iGES+DrX820V7bx5Ii6NyT71CZdgXoZpw5Id1mXpPpoKU+eVmnujYWy5jKGJokpmiy7YD07eq1CNGmI/ZRc4VAb+SehEVTp12hqGxpbg3h107m+NFXre5szK9cg7vt/3YVun/rw0D0vNwgn9gJmsgWaEZ6/GTX77vu13joqDzkhpo9wo+caN80p2h/rbEnEQh4ftKTYXc3ksuwZN+1a4V8/2zCkwMpwrWM9ioWkCO1cH9FQsIaFmCmLcmgMPzwUOsEOV8MAuqZQWsfp4QR6mPTd1LhynqMLwx8LZh7qFUiboNkAhyW4SoWMUvWBuGyGzkusSS598VnVW/MI0zB5wi9emsWGCON9y8l4zWj7iX420wGhljOTKnE//yICol/yWuluMdA8iFhvfzkMegZex7w5MOw88A65MoMLgMPVP8aV4
 FE/EsQR4
 X82IN5za5eMsgxbtxT8tSQ7p+DWakgwjRo7Fu7XR+7AROCylmqPqqs5ygffa+/YDJ8L3ux4vydEtuNAF9ThvQ7IJW9POW1YI6PjVi1EICyEO2SYAu/q9gc1N/1SvuoRLzVjckBd0oJBf7M2bDc6W9Heih6lkqZ1ZWJTYNfz7ryWqABuazRRzKC/j6AEY5WIqwLHqiyqe6dQIjRQoEajU2yYDkCFcVo/ubJyqo6TJXJKxY9ITpRjQpmdkc+SkRk/NgYG9uyAQxxVr89qSxi4NLlW3MVPC7J0ueFvKFhX2A4FacgE6u8vyJdk4Bgc84IHaGLAVVJVx0uEfyX67xo0nzExn2Ke0andCqaAn8QtTwyODqpwQ13fdwRnv5VsXngzXvmVqCu1OteDbx0pbjt650X6b84iBEKN9L972ECVJ2S2skjkXKve/2A7oNPQylbG7i5v9+kyUxEPcs+H+YJ0XvtrCIQbo2uvpx9pZfa6E/MLUQ2TwE+dWGhwR/EhAxHVhp9hn7bgFwuU6EVKetSX1gYGnoOzSJJkqlPqOlmrAycJE1itp714G7vbvsKjOpaUIQpkiJowK+LhyX/ozuyEy8+xYqB4OoeN0kuuVn9H4QSZZZchiyiyJTMDZpXh/Co8rshSM+lzgGZGWGtbW8e+AMSFS6E8L36k+zAioTG8agycHltNdrbaJuGIHSYwzQL4WdpHRQCE5JSXI9ODcLizlqF3cpBy30vLxj5iush3rwKklVmZNiY+gLk0qqVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 14:15:40 -0500 Gregory Price <gourry@gourry.net> wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.
> 
> isolate_migrate_pages_block() already expects requests with hugepages
> to originate from alloc_contig, and hugetlb code also does a migratable
> check when isolating in folio_isolate_hugetlb().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Hello folks, sorry for arriving late to the party, it seems like the patch
has gotten a lot of reviews already. I thought I would stop by to share
some simple testing that I've done: On a machine with 62GiB memory, I tried to
see if I could allocate a bunch of 2MB hugeTLB pages, then allocate 1GB hugeTLB
pages on top to see if that attempt would succeed.

To test this, I made a really simple setup:
1. Allocate 48GB worth of 2MB hugeTLB pages (24576)
2. Allocate 4 1G hugeTLB pages

Before this patch, I get 0 1G hugeTLB pages.
After this patch, I can get all 4 requested 1G hugeTLB pages!

I would share the script, but it really is just as simple as echoing 24576
and 4 to .../hugepages-{2048kB, 1048576kB}/nr_hugepages, respsectively.
If you want to reproduce this at home, you might have to change how many
2MB pages to allocate to see this difference, depending on the size of your
machine.

With this, please feel free to add:
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Have a great day, everyone!
Joshua

