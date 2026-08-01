Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930DAC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6DE6B007B; Sat,  1 Aug 2026 10:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740C06B0088; Sat,  1 Aug 2026 10:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A7F6B008A; Sat,  1 Aug 2026 10:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBA16B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:32:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A901B40323
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:32:42 +0000 (UTC)
X-FDA: 85052941764.07.A543B70
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2C6F180003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:32:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b1MJ2KvV;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785594761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ri60wTe3lRq/wyazLvLAJHMWphJ53DXAVPzpa92v8E=;
	b=0ShOhKsuig4yfa4AV8MgBD1nJZHTtxhU3YkqIZxGK1JI9g4b8HstW8U9zvrHVUoW3pWpiT
	pJmfLiCgv2B2+a9xnH4d9xQ3iMWpObzVuNLaHbF4gZHfs6hpKojdCcMVVVVKqnNvCScmx2
	Cvl1rTEgigFzDoTJaqO3XLr8WxOaVDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b1MJ2KvV;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785594761;
	b=31M9/brzg3MMy666c9qOpX+BMIy/cSNtc2k891SD8g3NcRHqT9+plTwWCmxCsAA4Z34FzO
	qYmVDexr/I2do/Ca7SoquLQSCI9b8gdCYZaKLqTzkgJMtkZYf+DP+PaOL1al5206sFVy/S
	5yNUPz8w0DRyvCRuBUnlxsp9mVhHIik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785594758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ri60wTe3lRq/wyazLvLAJHMWphJ53DXAVPzpa92v8E=;
	b=b1MJ2KvVydMkbGpiSM2vSJhXzcu6GCUhE0pgi57LctVN7QP7thbs+314VxzqPZ0y2fArlf
	zLY1i65Y6JE/Xt/8+PFW0EPl2ofxtl+fUxbw+hmqUM1Nk0YFt8YDyt37ciBE3FfwWAblHr
	Ops92EnsY7B5tMRb4P3SdCuy3WE/xkA=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH RFC 02/14] perf/ring_buffer: stop using PG_private as AUX page high-order marker
Date: Sat,  1 Aug 2026 07:32:26 -0700
Message-ID: <20260801143227.1267657-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-2-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C2C6F180003
X-Rspamd-Server: rspam01
X-Stat-Signature: t7hnq6zcz3wmduwhma9g6m1tcsgzji6f
X-HE-Tag: 1785594760-943973
X-HE-Meta: U2FsdGVkX1+rSXgZHTtAfEbk4NrAwEM9n9BEvZ9gXdqS4+/9FeIvp/bWthNkuiP975cMSkkIVAA88yyQFj2maAFffDtySEyD3BiBmyRDdmVPH4fyphnXylnn94NFmWFZXNpGI+VOb4iTgHHkhrnBZfWfo22QXbeJUEqtJzsqJ2bghxfYB6FV2UQULQeDzb+6PenGuuH/gbZYPUZypssDnKEfwFTLUfEu/Ml85XpHoIVucOcUHQkjqXzwDrTmx5H2nXdl0t61XXaE3O6vUp/neThvzChJK7V+W7MDXsFYtHsH0a2shwEkBTbXNRdjSzRhFbXMV8LYX79XNNHmcccT2wlY3/59VlNGUWaFNKq04y6IVmLi8trJ62tRsGFv30hmkgL+nm63NZv5w4dQXXbEdGML8zB8XfJE9qF6NDFJHI+LvUrRI2npek8IXjWO7jVnnRT3wwUjrhu3Vx2fTlclQyU+CfNm9buAbh3fV+giJgFhV7olRrKWBlD3gd8cbQnffTZRZiBMBUAUC9FD/CDFVi3kycRDAtxPyeMaCYVfCzt+0XcBzTBCCvyFNKmjlD6QdHcTD7v/jzDNVctdzuRUgc3+E6n6JDQDWZtoieNY9R6zhuXyBjFjr8IweAKEKlvoRYjWJSarY4xwGn+t+TZ0TObVcGre//oClc2kDvnHE+JhfKlFVJYqP2FnPaugQGf4Myba4NgGle21TGzCjZ+LESXWRsdJILypukxQDBNSlPlbeTFdz8ACuFAnTjBoVLH0FTPmz5KEO24zvAqNK4WrpDiDK1wsqFzYTs2rGVMvRJMJctynPku4ClWeQRYVntm94QeDvjBMUuL+5ORvXizA3YCaanIEFFceKmvl+bhjkVH17Apoi0Di9jhCoWar8ArLVCB2JpM+GU82ZQZ6kSvn4pSxWlZavejmD4TBUXWaArDDqqUsOukrXegrO7TIf/HYma19w5ZSroZhH5q7laG
 3pPank07
 6/CoB/x1o1E9Vn7+z0x9KAGiKKQaGkIgpJa+N+XVsZfQh/iDP6O9rHJl8cCmwxN8X8uUhWx1mJIpjpcHfAL5rEzovXUaY+kyfmA7FChP4w1ow8LXQ+F1/vfSeNMCtINVbm7NM83uQuf+T/iuWjvXXLGSoKATRNoUxmurpmXw6fakOMWce/lvm6S91TC4m/XFKbA7onId14D10PRfUHkwNGehtXgcNnYmVWa0YSq0abv8YJreCXf6eaGq59UHBtEOve34dLDCtPWhhEcQ0NmEt7uWVI9MKHSC3IGnyxuYuk1g9Gh59hAM9M7U1puzAaUkG9E/CJk1spy+FW0kqa6jC7rxLR2VD1rtaOvqViC0e1FAqdfomQJRkbQF8h1VSrptioqTyduWYXZi4mnqZmRmWd7rFCp/v0KksQPmJDxy7RZATmJafvAB92aBMzH8Bbckb7hwIk35f3QT56ZD6xNB4ErhsFauSblMQrX5NbCfFKg++Z/y5i7MbD8jnbpeu9ay5HtON05sqNUGKZFMTOQLlNgFK9pI8XcBnVdt0HwdLpxvo041A0w4+ih3HViIe40Knwv9S6tSluZoPD+exYDljT74Au6C8zybRYq8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:25 -0400 Zi Yan <ziy@nvidia.com> wrote:

> A high-order AUX page sets PG_private on its first page and stores the
> order in first_page->private. Stop using PG_private and check
> first_page->private for AUX page order only ring buffer and its users.
> 

nit: only "in the" ring buffer?

> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Peter Zijlstra <peterz@infradead.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Arnaldo Carvalho de Melo <acme@kernel.org>
> To: Namhyung Kim <namhyung@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> To: Borislav Petkov <bp@alien8.de>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: x86@kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: James Clark <james.clark@linaro.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/events/intel/bts.c | 3 ---
>  arch/x86/events/intel/pt.c  | 6 ++----
>  kernel/events/ring_buffer.c | 7 +++----
>  3 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
> index cbac54cb3a9ec..5849392cf26d5 100644
> --- a/arch/x86/events/intel/bts.c
> +++ b/arch/x86/events/intel/bts.c
> @@ -66,9 +66,6 @@ static struct pmu bts_pmu;
>  
>  static int buf_nr_pages(struct page *page)
>  {
> -	if (!PagePrivate(page))
> -		return 1;
> -


For order 0, 1 << 0 is 1, which is exactly what the !PagePrivate(page) so LGTM.

The commit message probably needs more text but everything else looks good.

Feel free to add

Acked-by: Usama Arif <usama.arif@linux.dev>


>  	return 1 << page_private(page);
>  }
>  
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index b5726b50e77db..29d8b4a3560cd 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -774,8 +774,7 @@ static int topa_insert_pages(struct pt_buffer *buf, int cpu, gfp_t gfp)
>  	struct page *p;
>  
>  	p = virt_to_page(buf->data_pages[buf->nr_pages]);
> -	if (PagePrivate(p))
> -		order = page_private(p);
> +	order = page_private(p);
>  
>  	if (topa_table_full(topa)) {
>  		topa = topa_alloc(cpu, gfp);
> @@ -1289,8 +1288,7 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
>  	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
>  		goto out;
>  
> -	if (PagePrivate(p))
> -		order = page_private(p);
> +	order = page_private(p);
>  
>  	if (1 << order != nr_pages)
>  		goto out;
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 9fe92161715e0..061b5cb222266 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(int node, int order)
>  		/*
>  		 * Communicate the allocation size to the driver:
>  		 * if we managed to secure a high-order allocation,
> -		 * set its first page's private to this order;
> -		 * !PagePrivate(page) means it's just a normal page.
> +		 * set its first page's private to this order, otherwise page's
> +		 * private remains zero.
>  		 */
>  		split_page(page, order);
> -		SetPagePrivate(page);
>  		set_page_private(page, order);
>  	}
>  
> @@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf_buffer *rb, int idx)
>  {
>  	struct page *page = virt_to_page(rb->aux_pages[idx]);
>  
> -	ClearPagePrivate(page);
> +	set_page_private(page, 0);
>  	__free_page(page);
>  }
>  
> 
> -- 
> 2.53.0
> 
> 

