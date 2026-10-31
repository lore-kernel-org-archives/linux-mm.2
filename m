Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E6B606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PclglMTo
Received: by kanga.kvack.org (Postfix)
	id 665BE6B05B3; Sat, 31 Oct 2026 05:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616226B05B4; Sat, 31 Oct 2026 05:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509326B05B5; Sat, 31 Oct 2026 05:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2555D6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:24:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DEE0405FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:24:39 +0000 (UTC)
X-FDA: 85382386278.21.D6343BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 78F5540006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:24:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PclglMTo;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXh+2aOwYc2JDfIEb59G/0Ycvxx7AFATCF/zpWSEjmM=;
	b=lsXWbFC+ZZANZuqAousdfFwX75CWF96ANuv93qwfsIZ3MSsnpVXpOIwMudfz/FeCsvVcSp
	lHJs9hms+dHgWQZqL7xBVJpcJwJcTz5mr+R63ym7UXHEW2tiZZEupafCgX/NRLOrQHPMPw
	tsnCEViOuLEgL0kyE/ndeXDrQKwINaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438677;
	b=2pCcfcFj61mz8NDftfvrrJVABV8UjnOtxkg2rD/vufStZ5HY0qw5G8ost4A0/6SioGdgec
	8Ged5CrJO8qF/c6GjD/IyVSCKHYa/aDyuSNm1PWeUxZ7I38hmBw77x02nsdWRfItJxqGyP
	raSV/y1RsT7Cyg2ATFgTfPaCFkruZT4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PclglMTo;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9771418CA;
	Sat, 31 Oct 2026 09:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345351F000C1;
	Sat, 31 Oct 2026 09:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438676;
	bh=HXh+2aOwYc2JDfIEb59G/0Ycvxx7AFATCF/zpWSEjmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PclglMToHToR9eZkkA/90N6AKsCeo83YnlJHtyM3h9ySsATyu5fBIfxFQemCgohFc
	 EeVOrF2gjuldWOCS5zxeuCOWIXVm3YdhHLTZ40C+RugswYEAG8KRIDaCswpU6wUgh2
	 LVgA9lL0AYVol54ToYBJPLKHil4muxZzJ+Oe0dYOQPETB6kq0+U5l5+7VLrps9CIef
	 +dFUFvSCx2X5+9W7ba9i3ihugrLfvgBD99WX09rqUsGsOtxwFpo4soMOb7glC8KG7g
	 iwDtp9My5FOo3Z3zZqqjJfdO/ukdz+Q5H3A88s5OGfvIZaA4kho+3tdUBwfgAsIFhn
	 TvKM6aKiiCGBQ==
Date: Sat, 31 Oct 2026 09:24:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/7] MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
Message-ID: <auWzvA7LoZg7dR8d@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-6-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-6-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78F5540006
X-Stat-Signature: gmig1mux3i916hs78pcj9nhsbxxwnnu1
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793438677-29106
X-HE-Meta: U2FsdGVkX1/y8lW/e70r3zRxWUT73ZJr25E3BZM8iiqgG5QeeecqJkfWQsZbodBoYCvyf8yoifK8z4QuuY0sJqpFBy2Y+O6ikthUylu7YLO3LTx0QX60bMuKpQ5p0PKOe4D7nYC6twMb7XOu2nu73oSNGdCOFfMi9kF6OTnmToFU53C7zzzUi9G+WzZgYANu2rKotP1A41NXpBF41xZeIqWWemydUMNT44npF6kqJU0efYaRvb4hcw77ebGTkHHRAj1eX/V0BpjrSgbM7T4qe5g7iiADdMzv2MjcP0oxe9PvLWw6uMjkg5lOPxwsz/9/KFhbZc8MItI5ZN7VdJbrs682XFcEHDxjV/wvNUxUsmTgxbqdjv8XfmGeQrO1U+DXcYQpZTsSpDT/zo/oTOI/P6+a9qVNpvCerA31ixaPPApRqIudKazUJAAJMt4po8KP5D9i402Q1sYjXFzIzbT3Eitr91zINZibZmrfMt5Y8QTQATbHU/BuhoUMGIvVMk8lZcugyG3Hgz01e30JMG8HxRLSd/3zKx3rw4Vr9qZd+o4Gsm8GKiiSRrZKWdPiZmupEw+vjSOaJfS1WQmhWdn1RnBarvj4I0vaO8qvPxQoZDjy+ENnzEfXeDmHhT+41xVk1T/pkSeowxfvmO6uvfwI/zhAwEHLtBdlyhWqyihd802irytNKkVCFY6eVluOtziXyuQmQcZYrL1OSv/FmN9CMo01y71pxj4tMfxcIe2FY9jLG+mS40HJBTh8IEAdqMitnZDetBE8m9966hFGVpwndGEfuz6b4n57T6Lcgnr/dh177T2ZWKGwWEM78y8Cj0eDQadOLxEyd1UeMZSZSGkXVMzP/J71sUbMX2sOgwCsdCiRtKbgS93TyBeV5Wx7yjmxQYZ21HqLRT6J/ZyoLupH1aXrMaqSQY7HzMADUcSoVXx/lLK2F5VjLPdUWZEB5l6+dzXPV5Mc041cT2sAoju
 dEFnhRyj
 c6R6mT/VaWk1+8tTHKd8jW9NXHKWntuQLUN5EPj8zUPErhNH62MUnYc9yFIWqRK+JNRRhkrMlTBDHHSZ4vw6oBox1FoejJSxII74zKQsIEUDQMKJzLdjUiLIbV6un5hjM/8X8EQFBr0zbvfzi1P4r2gBEKFXOv/CRIub31/wCvQY821dR9fyEH7m79+9XvNDkIZu9iSbBhoZfIosu9JHA7dD9YOrNhJoisYaiqy3KmJlIfL+HsL5fEHe5nzs9ySMLeLSchHv6BVcEqxxh7GIfCOh5c3ett6nIPjg4hVXRVYosIUHRKWLW18kmgIPcOI8L6323M4RHfcmZdgX0sJySO8OEzvs9dDDF/3BwC+HF+TBymuGI0QU93Pl/n0W3Zsy723V9xqwhX+u/OnsY46BOLMykS/h8gAifajRbe4upo2MoY3h3C0nqcFt6nusi3eiTSdR4bLQ5npRUBUVszj8s+yr02Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:30PM +0100, David Hildenbrand (Arm) wrote:
> Prefix "MEMORY HOT(UN)PLUG" with "MEMORY MANAGEMENT" and put it into the
> right spot in the MM component section list.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 98948d159173b..0adc674304987 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17423,22 +17423,6 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
>  F:	drivers/devfreq/tegra30-devfreq.c
>
> -MEMORY HOT(UN)PLUG
> -M:	David Hildenbrand <david@kernel.org>
> -M:	Oscar Salvador <osalvador@suse.de>
> -L:	linux-mm@kvack.org
> -L:	linux-cxl@vger.kernel.org
> -S:	Maintained
> -F:	Documentation/ABI/testing/sysfs-devices-memory
> -F:	Documentation/admin-guide/mm/memory-hotplug.rst
> -F:	Documentation/core-api/memory-hotplug.rst
> -F:	drivers/base/memory.c
> -F:	include/linux/memory_hotplug.h
> -F:	include/linux/memremap.h
> -F:	mm/memory_hotplug.c
> -F:	mm/memremap.c
> -F:	tools/testing/selftests/memory-hotplug/
> -
>  MEMORY MANAGEMENT
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  L:	linux-mm@kvack.org
> @@ -17576,6 +17560,22 @@ F:	include/trace/events/ksm.h
>  F:	mm/ksm.c
>  F:	mm/mm_slot.h
>
> +MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
> +M:	David Hildenbrand <david@kernel.org>
> +M:	Oscar Salvador <osalvador@suse.de>
> +L:	linux-mm@kvack.org
> +L:	linux-cxl@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/ABI/testing/sysfs-devices-memory
> +F:	Documentation/admin-guide/mm/memory-hotplug.rst
> +F:	Documentation/core-api/memory-hotplug.rst
> +F:	drivers/base/memory.c
> +F:	include/linux/memory_hotplug.h
> +F:	include/linux/memremap.h
> +F:	mm/memory_hotplug.c
> +F:	mm/memremap.c
> +F:	tools/testing/selftests/memory-hotplug/
> +
>  MEMORY MANAGEMENT - MEMORY MAP
>  M:	Muchun Song <muchun.song@linux.dev>
>  M:	Mike Rapoport <rppt@kernel.org>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

