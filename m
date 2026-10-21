Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A76B606A330
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 04:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P1nAFsAZ
Received: by kanga.kvack.org (Postfix)
	id A89886B05EE; Wed, 21 Oct 2026 00:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39A26B05F0; Wed, 21 Oct 2026 00:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9570E6B05F1; Wed, 21 Oct 2026 00:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7921E6B05EE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:57:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 751F1160322
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:57:54 +0000 (UTC)
X-FDA: 85345426068.01.44DA8BE
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 43A46C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:57:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P1nAFsAZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792558672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx+oBx+DrGbWNeI4VpjTvUMhvmqGs16Tkaf005DeV3I=;
	b=v4Txtf0a8xunW1caXF4GB0dyyEc2h3FO55EZ8owWfsJevyJf69G8dyCw/O5YTUQNHg9+Cr
	oamAIp6V+/1H0e0oPO4qCSLw/+yeWijhdqaVw5zFtmqA4eJdox/Z+C8PYg9ZnniQuHPvdx
	laYoWEDqsrxDGDjshOc3RCYqvwCrb1Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P1nAFsAZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792558672;
	b=k+rpL+3hROH9Uzz0uzvJRH1EvKEfijp36cPkxglNjwB4lmEuKUdUr6SDB0OLx+fTXlkQrW
	6MwrirfgFW0UF2VbgiputbDY9JcaUQtNOaNNU6959dqpsfrtwfJoAmeahrhIqf9sxzjFZF
	rsFqaEAiYU6xJzB4pcm4xrjQOR5dBHQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sjeGNUTRu2TxaiR+y3T0ejou+De0JFn1tmqrXPbKj/s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792558670; v=1; x=1793163470;
 b=P1nAFsAZzDdN1cB/IenFnLQPPipDFBuS9xym0lWq5mfYtRLAmQt3QeAFqd9UdI9Z5L9z2SEB
 NkcYKNd/A305qIJHE0prhUlfm8WKsSHDgxEauR4yWMbISsWDa+qtw2breNYExxYCEAtViGNp8eK
 VBrXq8Bz1w3n/fLR8eQeH2sQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7971245a92a56791;
	Wed, 21 Oct 2026 04:57:50 +0000
X-Mizu-Trace-ID: 7971245a92a56791
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	maddy@linux.ibm.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	lance.yang@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/sparse-vmemmap: map shared vmemmap tail pages as read-only
Date: Wed, 21 Oct 2026 12:57:44 +0800
Message-ID: <20261021045744.93554-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261019090830.1917657-2-songmuchun@bytedance.com>
References: <20261019090830.1917657-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43A46C0005
X-Stat-Signature: kappn4wz6gcuag5ichnbnk9tuy6smyxr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792558672-244571
X-HE-Meta: U2FsdGVkX1+WphMX4InuQu63MHKQTnEtB6QEiwkShjhj2VhGJu0Br6+hhqdhIUAW0PWMztZHWydpWQ3MzMz563lWZZVPFalfWJGnC+oR0tiVlBIsyXJVokA8Jbo4ITVASZTKcgIQTAUjsjri+BQC+eG7fNfMWC0r3oQYByd1Mdx3OhfxbxHgKvvg8NjtIikZsj2kMT/6pDQLqJHd3WDiRxdzv5EnCxWQI+hM7qihzQkcjG5vLm0BpjMOToN4lJfxINdvQczjKxx1K3fX2VoKV+f+OFSs9r6lQdkrXTuavkixeIcmLpaKg9IEviH7gnJKP6H9IIlkjCmOrEamttLUL4RpQdNdzfWhp1lw0JzpEoPLD2WCLEkZ07LgkC3eGnqpkFzcOMcKDpOfWvZf8EAx3M98xgoCGk9yAcCeTHAYpIWc+viYE+rd/fq0W7A6vQPuOu7j3ronAXC6Ty5DO+/FWbphrxrP967aO02iGSqsq9uZXhQJZarJKes5VelFEDlqVw+kUy4nNa0/8vA0XblCHSAaJPx6Jg3JZOzJb3EJrsiUtX1n3ekVT7lo0oSi7YvrO9ADSVIAKrHWIrBhnt3tnriXewMryhqQLPmgT+02Y0m98+BKR0c9srHTEeYSFGKrODukz6+yDTwLn/gVh8tKC5j59yBoCa91T8w6ZXQ/J8amSwRoPQqHOWaE1g+BNxQbieRFIR/x1JBdYXeOM2S0/gWNq4/82BRMsUulikDUPfornNXvCNmaN1dn85V9YJDjj52f+3kuB3NNdgPAO+ick9I6VR4A+klMv2DB/fpiffLp4Y9Bf4hDFcHhUKCsI9Ehap8u6pxtEwJNYIlTbUxHS9e/6su8S/c3gZDrc6/nh9iHX2dwsdGUEUueU3PgBJkPzZLrZAqoWGSyHxrQ/aQEItKNBwYRpuQLF5lYNWF791yWnNKe4o8BmIDEvQzMKsTJJ8uyk7c5lKEed41VZct
 LbjwVhh4
 T83dNK1MQS/nWpyWJZOgEFmhahflQTdshypSCxsWEq5Bmwm5hCpuu+8NwoSz8mvTDjp+IruqmpMLkd9ZFkTfg5+1NPtzco9rC37Ev0dS4NGko9YlpCQrijPhxwvu+kvIZl7B7dj2NfKjvd3rIuPYclRcNYkpvia+QkBeVHrzkZEL5+qDDuTOibi+bg/EUTw4HRr7IeG+R8AtD4n1XtbMbDgOFiAgdTN77nZum35ldFVK0jLqRVfHSz1gcNyJOH8S+IzKGUz0UuRa8t1k9nAFTDrqZ4FAC1iSGCJOcu8+rUmhsbFs3XgiBemEHImXGy1DXc7KfvfTcKwbXkEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 05:08:27PM +0800, Muchun Song wrote:
>Both early HugeTLB HVO and device DAX use the common vmemmap population
>path for shared tail mappings. Map these pages read-only so that illegal
>writes fault instead of corrupting metadata shared by multiple tail
>pages.
>
>For early HugeTLB, this moves existing write protection into initial
>population without changing the final mapping. Device DAX gains the same
>protection.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---
> Documentation/mm/vmemmap_dedup.rst | 3 +--
> mm/sparse-vmemmap.c                | 3 +++
> 2 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
>index 8c287ae3f86c..76f903975a40 100644
>--- a/Documentation/mm/vmemmap_dedup.rst
>+++ b/Documentation/mm/vmemmap_dedup.rst
>@@ -193,5 +193,4 @@ There's no remapping of vmemmap given that device-dax memory is not part of
> System RAM ranges initialized at boot. Thus the tail page deduplication
> happens at a later stage when we populate the sections.
> 
>-Deduplicated tail pages are not mapped read-only. The mapping layout is the same
>-as HugeTLB.
>+The mapping layout is the same as HugeTLB.
>diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>index 40eba70c0048..ba0496daf4de 100644
>--- a/mm/sparse-vmemmap.c
>+++ b/mm/sparse-vmemmap.c
>@@ -295,6 +295,9 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
> 			return NULL;
> 
> 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
>+		/* Map the shared tail page as read-only to catch illegal writes. */
>+		if (vmemmap_optimizable_pfn(pfn))
>+			entry = pte_wrprotect(entry);

LLM pointed out that an AO MCE before bootmem gather could still reach
TestSetPageHWPoison() on a shared tail, since the head isn't marked
hugetlb yet.

Wouldn't that trigger an Oops ... Anyway, I wouldn't expect to hit that
during boot.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

[...]

Cheers, Lance

