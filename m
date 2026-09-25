Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11224C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0743A6B0088; Fri, 25 Sep 2026 08:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B886B0093; Fri, 25 Sep 2026 08:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2236B0088; Fri, 25 Sep 2026 08:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCA856B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:56:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67DE81A061D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:56:39 +0000 (UTC)
X-FDA: 85252283718.28.4A70CB4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F8E2140002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:56:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JQPp/4Pa";
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790340997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7SnpuRbhFJFzgkVobZlXzXiw+PNcOORF0vZ0Bl4vW4s=;
	b=NYqYxMWd/yoLSSmWwzXrrtJw3/InxqsC8vFu72TFeHNWVotugdnZiRvdXi7o9kHI9+JYv7
	TMSBpE26cCmP3yh/WgzfouibR1dGEVNtszECkbtvKGHYN0NTfUaYJADUmiY9435TCtXorH
	opmzXVHSfljHfYHu0GqGaJc/cTV4eE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790340997;
	b=kE7JhNcnj/yHlWyRHEBDv0rMltRbKo9IbFR7OJjxqWlIMnHgSzm36lVsZ/FzUwonYt5sAw
	IvOTngxjE9AEHvAJ6rDQutBSAM1TZAW7+Y93UYk6B6NgNt6PJWRaCqVUbpjFdu1QfPNlhH
	/Ej7K2yvutF2q1Ym/pRQxzjX25GCAzc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JQPp/4Pa";
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26934169C;
	Fri, 25 Sep 2026 05:56:33 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A27B3F86C;
	Fri, 25 Sep 2026 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790340996; bh=xm+mooZ0XkAGq6GKU7h4yi+KjgP6Je8ezgCLqOb4z6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JQPp/4PadiQm3gluMM0otFqo8NCqzpexmW4TOx/2YJgBOhy9iBaZzg/USMbgG6i8G
	 464Kwohpyq8Tb2u/dH+SbWe/zxdNlQkRc5bi07RReOMNdr0pxxsl2JAu2PC8Yl/rZY
	 4d8OEjgeYrfLLTzrBon7MlH/RNJHRL4V6f2LIdAU=
Message-ID: <ee423531-e2a0-4915-b089-905bba22d33a@arm.com>
Date: Fri, 25 Sep 2026 18:26:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/4] kselftest: mm: remove check_huge_shmem()
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-4-cba7359d882a@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260924-fix_split-v8-4-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F8E2140002
X-Stat-Signature: ad9rqqxcpaz3uicanhg4sqtbghxy1tw3
X-Rspam-User: 
X-HE-Tag: 1790340997-215117
X-HE-Meta: U2FsdGVkX19t3mYfWEnsdj/z08lItRCkkw/vzPre/qlQtm/SccvGEnYvlbS9NU2wjRM1WKiw4AaF8CYEUT2eV4BGEK3MoeIPX3HQCmeSSdOHI19ETUyywYQgmAUQNyG0U/hl3O0j9nF1So9vsWfkXpO853L9748ya4bwP1dWozi4EKjwm6YshUuihEzZlEEeZ7JwcowayS4k89SI4pzxT7ML/D2jBtJhGrO/3aN5mMIbistez4Jyckcq5P19rHtEKhTrM431umJgaK/V6Z6YEOasFRPWl61t1JtflcgrQx6+Bw13+bbzM/4cik6no7PIjKR3Q6cN5L9BvCbhm3mlJ3KL3jgKLT2gaCffTkxP5B5ZoZ+X0DwsKyz0k96vsqYmUDpg9S0nMZep3P4jWvDuCeWM1aPhBctja7QdB+3EWiRieURvMQvPqIAqLtb9OBl29PyCwsM+oO79Llt8NiFQWpwUvBy8iFDNvV389U84MXmcrSPd1UYQr3LZM2tqTDDKldhi0la+syD7vT6AwCcq3a2cWLqCFaileVpUfzO8T0V30Ld0qzXaKH6cF44tCx9N/IA4Ohggy8Tvqnb+Ey78H6wv1n9vG/6djy+5VOYAO/3U+9gER/wv4R4C9NyPhcFxVFKpLux1nL54F8Asn+xloe3WtwSGmpVSBDfjXjP3afAgfYzRstA8smrok7NMP5m/b/JGhxzXNqhja1id8HrS3cxDBcYsLOTD47mSx3xhfdNVFa+9WY/+SvTmTgrHIx5WIDCAacycZt+NrJY524UA93/S5OJ0f0P0dXnVEEhv6rdDzsa7bQ/Rn9xsZmMWVHssM3S2niR9PYkzvMLJMGKolLK00N9k4doXgkGA43OkQ+QPIqeaRaBg5KsGcs3Sau1Bs+86OWzX6WsUYT16a4TU7DqG/QURQ/xwAc3Zf23gzh4uC0pMkLMifSc36Y3aZDK2/8E6QGmXMBnRndV7dmS
 QPp4yzok
 1CNV6SVR1ESZCYDv+Sr20Ll8IH9WNXI4iXOQIfKW2HA+K9FUSnasTIgZu2iDXqMNyni3tR9JCcW8IOgkIYb4E+/zdsaoWmQ3yKeLJ12/KmoPhXSqczt1wmPTL5jAcfVnQukIGDMXu6EPLeRhxyzXZd3FwbwtuEJVxCfSoXJBQ4wTlISOUFshRidIUiETPQb4/b6OF9WTm+7FdGj+yrWFJ8W39oiy3aBhQEPB3CVA1EB7uRvZiSOS+6AHZwISCDTNri/jn6WVYiY/C27reRjjqwDdVyZUGC4hq0k6ZsaGqXgydqgCvDCkncomUE1wMpAVn4BehNkdNk4rviWOorCM0p0ub/I2MJeVhZwcH+FLCn73O71USi0z/oiaNKRCnznMoINZAsNOeJwcJCfyh4Q6QFj7yzZvfSIvc5b2zKjyF1Y79IXW2rGcrII+qMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> as opposed to “FilePmdMapped” for file-backed huge pages.
> 
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
> 
> Therefore, remove check_huge_shmem() and use check_huge_file() instead
> and cleanup khugepaged's check_huge operation in mem_ops.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
Looks good to me, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

