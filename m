Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D093F46100
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC696B0088; Mon, 23 Mar 2026 08:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC35C6B008A; Mon, 23 Mar 2026 08:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF906B0088; Mon, 23 Mar 2026 08:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5356B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:47:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F67A1EC52
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:47:30 +0000 (UTC)
X-FDA: 84577303860.11.92AEFA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FD942000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:47:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gVAhHJfW;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774270048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u4DoGQ4lmcA23oqYqC/015Lk/NUWNVl1j8NoB4BI6w=;
	b=DtbjlEDdWwuczOjHFwxUvFMv1w4P+la1K8sTKX1eeMeZQcfIC+CSGOaQh+pkC2z4Yb8CP7
	In/b1lOOBJqVpuHQctrK7QSF0oyLltvEJlzoP7q2z+1yIPUnNQiwcwVjK9K0rurNX9fMD7
	wzD3aU9vMP7EBZibF9QqfSW+0BZ2Jw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774270048; a=rsa-sha256;
	cv=none;
	b=NXZKwMFpe06zijaLg04rDpW6e4ZZfeMaVIMgoClqJqacD1EHzs/oFDW4+N3n7QDnYbA4fL
	d14V58REg3zKSr7Yl3seTAXmw/YJcOrblr3WFiBaOo7Je7K2g8lzvwpfLwQyBPB0wHCVDP
	DwFV5Lisu4jlhtUDh8VXV4c6DvQQOPo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gVAhHJfW;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774270047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0u4DoGQ4lmcA23oqYqC/015Lk/NUWNVl1j8NoB4BI6w=;
	b=gVAhHJfWwk5dzTHveNoTTd8ShrpNxZegFV6V8+J9Pbqh4XfLoLBUvxbzAmB4UkSqeRkqyY
	1zuPkNO6r5V9q20stT5YVCmBWz74TdPe0YtbmWFoQ/0067Q4ct1a0a9wg5pw2SbfY8yCYC
	qwT6ea3biQtEMkrNoCGUjaVKuUNFql4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-ryCH7UWdO_2ASxzjo9TqoQ-1; Mon, 23 Mar 2026 08:47:24 -0400
X-MC-Unique: ryCH7UWdO_2ASxzjo9TqoQ-1
X-Mimecast-MFC-AGG-ID: ryCH7UWdO_2ASxzjo9TqoQ_1774270043
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35be4ea8292so1693400a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774270043; x=1774874843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0u4DoGQ4lmcA23oqYqC/015Lk/NUWNVl1j8NoB4BI6w=;
        b=EVwnDZEdTkO2DwAyBn+6MaKlfouMdLnSzLCjccyINRZ1+XM0uj6sVFVuO4mmtQWw61
         rQOGIIviWwxEYVZNlXv0/t7DCfrxyw6SRCl0pe1kxISmL/+QIzLvNQ+2KOO/ppHC46sY
         S24wEjOBpc0G9F0wSuOfscUnKYydlQ2ecgI5xoWSnhy8js9qISN6mwCb7nFr7Z8FfEq9
         OF8J/DN+yp/FaErtrx6D8uhSXiPa3MP39A0yZo5ihbCj+8S/hUCG494a2Fw3rg1Ynyw/
         cimnpahXUh+BbrQ5PmNHUOaowdG5AP23tQqTOqUPNw3W4Frmz3F6YRMwiGlLxJ16X9D2
         M/rg==
X-Forwarded-Encrypted: i=1; AJvYcCUQOg2e9d4p7ic4xRXBdj7dis1f3cn+fIDl8NpwXOVus09QTHnpxqnKcwx/GpfI0yqNNe4wpzv4TQ==@kvack.org
X-Gm-Message-State: AOJu0Yyq/37vjaZ3d4EgMZJTq6grnTOrPkVhld5/Zr+0hN5bSoElsqT1
	3bhsyJL5ZofA0TIp3UrbWeZFy4PFic0z76jZlTd10hNabpNqDL17wTpcYOw3H5z0iIj3g+iKw5V
	ITYbI/mHgMBzjzGoqzEK9rJZrNVoQkTed8EKJ5bXmzCQXMlEy9Ycj
X-Gm-Gg: ATEYQzz4BQapa9B/p9kp14WnhtF2bH5vrSyYHDNR3+Z0WmLxW9xrLA59QfYXANloVdO
	GGYX3dRXuxEyPN/kBbB6HXUue6a/hkaPhxcSLlRFCGpV0ib+Cu5ASIIwkRU/SsY+T5/JBVwZgnF
	WT5jmOjApzsRzJRVMlDyEA/lyzA6ATQKS4GzKAAs3Tgv4yuf5UjLor7lYy4pWgUnTJ/p61/pPhv
	gJ9rkJWGjjwznHqCYnxV2XnTFBLogpb+6BpMy1KYKLt2uCTHvBaz9La1IFru0gNoljYqktGZY+j
	3vy7DDaqs/WSw2UaT98XYETW30P2SQIqXMJL9Fkf9A90YxwnFocwgvgZgGL+c4/UP4RY6aWjwkN
	LfPKOOt5LMAt8KmAkgw==
X-Received: by 2002:a17:90a:1c0f:b0:35b:e4d8:bb10 with SMTP id 98e67ed59e1d1-35be4d8bc7fmr3116815a91.14.1774270043236;
        Mon, 23 Mar 2026 05:47:23 -0700 (PDT)
X-Received: by 2002:a17:90a:1c0f:b0:35b:e4d8:bb10 with SMTP id 98e67ed59e1d1-35be4d8bc7fmr3116793a91.14.1774270042836;
        Mon, 23 Mar 2026 05:47:22 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366b9aesm141494025ad.58.2026.03.23.05.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:47:22 -0700 (PDT)
Date: Mon, 23 Mar 2026 20:47:20 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with
 increase in PAGE_SIZE
Message-ID: <acE2WDuto9cdp5Lx@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-3-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-3-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0NL3nDafKD1_VyYLu81x43TeQl11ehkX3jOrAuaU-jc_1774270043
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: btm7ozb5n8degzw5q7fger1okexr7b3d
X-Rspamd-Queue-Id: 1FD942000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1774270047-80650
X-HE-Meta: U2FsdGVkX181KBCdUp6wYmg9Y31xa7l1pgijQDd57j+Vv0k1H7lnb/60qDXUqsUtz1Zkdo10/uWo+FB4wSnqpAGklG33ihgKxlMHhGz27kXFetQ6zw8pc90jqzv4MNypkhYkUg4/oOYRmPsfQZgDS3Rc197KygiBmb9xk4tv+9avtRwYQSJ+9+ooC555tpXQpEYwjKMieg7D0C8tq0AjqNOPDhTHFkaPNb+pS22BkIIe0pWL9GGm/JTiqYkoIhhpV2JyArclQ+xDEetYXrAtm66/tScjYsmuCd/sdudnvNrAj+bkq8WdXI745OmnQBs9ktAoGHIrckQPwZDz4l3sNZiyEv84VrHn2rOtTVRAinIzzslJnFxVZ+Khn3/AfNH6e7atcvszw57GOxa29NiOrpDN9+Ee/x413+eYDcunvx5LFptNYdXN+GQex3QXyD1pRG3KxIVI27Xgstw9j8389QBMj/FqumZi6dzdfQ/E0FKc/2wMKSIK9hIKss77k7W4w+DD9qERn7lgcTtv1HGFDsn4y2KZsBfjNxmjisCOHWaqDdYYKHY+jWiPA8jcne6iXm7kTtARjFGXsl4pH/KAUYwXLCVQUn8OtwPKdYbtBg/spHc96DiN8XZE7aQ+2s9+qIlonVEp4bFEXO+KWc4Q+s1uzWlogC8BuabCNY7KXwf1ZS2inNwWahduWvBT38XNiFVamlaHqaIY+d2RXSEKvvdxwwzT/mnMdfheULhgiSzYKqV3a9Rt1zm0/c9oa3WH3zuMUSBWsSrU7bmh6CccBhMNeIMrEOVmIouYweWdMT3jNfE+EfvQVdkHeuBt5mstHqVsmz06MesYtQVZrawMwGxbEJEq9zWMuI0PF6vRVOdlMFH8zq60uKH62loiVrbnFAg0l1CTq+UNzE6yxiF1w7FV+v0qo22q0rnabOBSy+L0+uNdM7rMn6hvBzfa4FEhHj2CpqB1O7YlN/XsyI7
 HKLXkp5h
 UuzT1NZ6WxWOZa/e+UxmJhoLhd7AaRTa/bUU2rQjcgTne9bWhQ6WkWPMbK1b4YWbLt3TXEbbvpTw/gIl9UyJCLxZrrLuoNYspuw5Vosl9AtxcKzyzryHKTlZhnbPPUXkiFJ5XaQ1lrqc16KL4SN8t4BV+sKMBh97/ixaElPF7YlFnwQRvklHEB5qPy0Au9Y93FdVDU3jRPvAO9G7rIo2YgPPeo+GDljNFCF89Gb7k7mXGORcfRU/y7AjwVTiKArkH9/9BKiNU6W6DvaXdRi/imaU0xzOmfzHBRVJ8ZToOGq9cvpiGmzBrfL+Obl5IvHtTrqn1h4ag+6EiefC7y2Use1XSpCkOQp8rtRi2fdfqZxcexbAJarw7kHf5riPazT4l0ZARE7ikUIJZmeopCzeZO0al5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:36PM -0400, Waiman Long wrote:
> For a system with 4k page size, each percpu memcg_stock can hide up
> to 256 kbytes of memory with the current MEMCG_CHARGE_BATCH value of
> 64. For another system with 64k page size, that becomes 4 Mbytes. This
> hidden charges will affect the accurary of the memory.current value.
> 
> This MEMCG_CHARGE_BATCH value also controls how often should the
> memcg vmstat values need flushing. As a result, the values reported
> in memory.stat cgroup control files are less indicative of the actual
> memory consumption of a particular memory cgroup when the page size
> increases from 4k.
> 
> This problem can be illustrated by running the test_memcontrol
> selftest. Running a 4k page size kernel on a 128-core arm64 system,
> the test_memcg_current_peak test which allocates a 50M anonymous memory
> passed. With a 64k page size kernel on the same system, however, the
> same test failed because the "anon" attribute of memory.stat file might
> report a size of 0 depending on the number of CPUs the system has.
> 
> To solve this inaccurate memory stats problem, we need to scale down
> the amount of memory that can be hidden by reducing MEMCG_CHARGE_BATCH
> when the page size increases. The same user application will likely
> consume more memory on systems with larger page size and it is also
> less efficient if we scale down MEMCG_CHARGE_BATCH by too much.  So I
> believe a good compromise is to scale down MEMCG_CHARGE_BATCH by 2 for
> 16k page size and by 4 with 64k page size.
> 
> With that change, the test_memcg_current_peak test passed again with
> the modified 64k page size kernel.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/memcontrol.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 70b685a85bf4..748cfd75d998 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -328,8 +328,14 @@ struct mem_cgroup {
>   * size of first charge trial.
>   * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
>   * workload.
> + *
> + * There are 3 common base page sizes - 4k, 16k & 64k. In order to limit the
> + * amount of memory that can be hidden in each percpu memcg_stock for a given
> + * memcg, we scale down MEMCG_CHARGE_BATCH by 2 for 16k and 4 for 64k.
>   */
> -#define MEMCG_CHARGE_BATCH 64U
> +#define MEMCG_CHARGE_BATCH_BASE  64U
> +#define MEMCG_CHARGE_BATCH_SHIFT ((PAGE_SHIFT <= 16) ? (PAGE_SHIFT - 12)/2 : 2)
> +#define MEMCG_CHARGE_BATCH	 (MEMCG_CHARGE_BATCH_BASE >> MEMCG_CHARGE_BATCH_SHIFT)
>  
>  extern struct mem_cgroup *root_mem_cgroup;

Reviewed-by: Li Wang <liwang@redhat.com>

-- 
Regards,
Li Wang


