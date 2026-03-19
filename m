Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B08108E1FD
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C82A6B049A; Thu, 19 Mar 2026 08:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878EF6B049C; Thu, 19 Mar 2026 08:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E5D6B049D; Thu, 19 Mar 2026 08:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3716B049A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:09:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00D2F1A0543
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:09:42 +0000 (UTC)
X-FDA: 84562693446.21.5709AD3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23E2040006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:09:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773922181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IJ4WIStSSV7fmI+rD+2HcG1uK56zJNOoF3Q0UnlUfx4=;
	b=vUTtagvOEY3dPKR20UdQ68NXqT5sqRcQhT5/gIRrpO6YvYrvHvJgU5ScLVN8zQLMoAsy+N
	0+OoEsdzLFeEmtuB/8LAM34aoHzRTaCbFXPvLjbx6VjdLHzCIlTwF3NGZxyy/5CbY/Vy8w
	C2Y5I6S4sRa+Cb7DaI5AESfBzrdgyWE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773922181; a=rsa-sha256;
	cv=none;
	b=SDEDYEKteyWxU0eG2LuY6Qk8Rf5ZC2S88JefDf4fYXvuB1G6QqVZPUNCBBA9f+V1VX7xy2
	YF1qFOjY700eGcEdE0abQ4aKrPERB8awbZXT7y64i9jTXpAifvDLUfqncBIc+vUlkI10+Z
	ECUxvbiEo1MB2N3qzlY1/uQF3wUikFU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 431231BD0;
	Thu, 19 Mar 2026 05:09:34 -0700 (PDT)
Received: from [10.57.85.34] (unknown [10.57.85.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 648373F778;
	Thu, 19 Mar 2026 05:09:36 -0700 (PDT)
Message-ID: <75705c3d-2654-47cf-8fd3-8343136715fa@arm.com>
Date: Thu, 19 Mar 2026 12:09:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: SKIP KASAN for page table allocations
Content-Language: en-GB
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <20260319114952.3241359-4-usama.anjum@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260319114952.3241359-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: notjbybbt4sobatxgt39fyoe1pjhtwq1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 23E2040006
X-HE-Tag: 1773922180-150920
X-HE-Meta: U2FsdGVkX19Fo7P1g/LGsMlfFKTqI+ehfiWsIZWuD43wi+Hs1/R3IpeI4rl5E8AY0bN+sVtc2WxZuy5r0Iho09FUs8ZoKeyXi3tDNTCtauvbISalWyV316tpw+gtjWNKNOB2ljTRve4twlnx4hLeGYlJyJXSytjzjDMeRmHJ7v8U8mdcrdtz/c3JY273S+Zx6wDC+pZVE3nttu+mOaLRLNL5kPc8+XciKQ5Qb58ua0K8+5qTNbzE4o7HdfzJN3vLL9wTr6NeSJ+/BLQgU2/8I8Zwz7vIIqj1HFa59hxyCrDag6oNjnk/7PmYc2XSthCAqMxPUfr24pZ2xsQeoLGE+R/ZTzwypVUwQu9r6qcBfZrO7GY+5RFzxxGaepH0kxN/njSiOqgubwIBDvme5CMkdMy5eLb/nOvfz9K1eWdafTX1SCqeJsjmvMC8Kn9DcXeGb0eu9DZkCp0OZw3T7lDj3SCYwPyIxkhK+YAyCRRUz8Y7bTLlgHea7R6SOl5dCIyz01sU9RhQNflmi3PyGVNBKZzoUNNrroof8fO5JnSdNsDkr80fYCTQk5UzIAG5PVzV67Rjc+7pUrGnbcEz9k0g5g3fksiNm9KCcZ5zVRvLO0cJyowtzusGoJCP7k/EP4PNkdqphve/mULa/bqUOeO8Yxeq05O56axE7V7CoGuWzpBSgRIiTtYl8jhTgBPSTsrLkcMjOV0l+F1TE5IaDVeVglsYz1B+dm4WnzLFjzKzhSY/ZaiZSaickV/bvjygVpKi5G+1CyamtJdJdgWh//PVCSPYJolus9t4I6q7yHlRDdI9wEjq1Y+9LOiRm/YlL+wlyIhBbRVNhia7ja04zPzS3h5DhXGpjnQOjA9X7uISJhc0WA1g92qVT4prkHlzuBj/nSPE6B39PWZq6iH9jh9YH7MnZUgM1AxeGDyPLes3JLtwP3vbChpPDAFqeX6Z9APu5BtbcOazO5u7xEn+JOb
 gcmET4WK
 1wGIts+n+kV1CJ2WcXU4gbhUUClz0AnoIVIU0Aje1Iai8oL9TRZB2VDvWCtWa7BGd2gog/AC6WCN4HbJv3PrlN1nU3iX6Dq2NmfosLY56NmYIYZvvpaNoTL/lqL4TNq6yUd1G8ukc9hAXz1YhOSISNud/yRJvBt/Ny6c9CHDbw5d8ZhA8nOPsUvFMjaC/B7+JHtjuZpuO0mYTv7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/03/2026 11:49, Muhammad Usama Anjum wrote:
> Page tables are always accessed via __va(phys) / phys_to_virt(phys).
> With a match-all tag in the pointer, MTE never checks memory tags on
> access. Therefore: KASAN HW tags are set during page table allocation
> but never checked during use. KASAN poisoning on free provides no
> value for these pages as well. Its pure overhead - both at allocation
> time and free time. Hence, skip the tag setting for all page tables.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/asm-generic/pgalloc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 57137d3ac1592..051aa1331051c 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -4,7 +4,7 @@
>  
>  #ifdef CONFIG_MMU
>  
> -#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
> +#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>  
>  /**


