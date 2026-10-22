Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507E2606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=U7c/a/Kc
Received: by kanga.kvack.org (Postfix)
	id 5C8426B0995; Thu, 22 Oct 2026 13:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F786B0996; Thu, 22 Oct 2026 13:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5E96B0997; Thu, 22 Oct 2026 13:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 204906B0995
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:01:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF536A01E7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:01:45 +0000 (UTC)
X-FDA: 85350878970.26.1CD72B4
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4ECFC80011
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:01:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="U7c/a/Kc";
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792688503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RT/hDzEuwThvLNevH0thxyzvch5KgmlhrTj6s7q01rE=;
	b=O01Ijx3jx7wtL+11k03XuWkSwcPNuDMX7d+VFlhZJ6SUgjwEdW05kAcMB9teg/QB6BabJL
	8gqPXfB2RotDrfUYopHQNgWYTW28Vx+d9z6qp4clucO1KgHIc5aFTONWcc4GdvapmxnFKV
	wfn/9VtUDmtI/2MEeMxxggfdRwCviAU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="U7c/a/Kc";
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792688503;
	b=Ts8E8pyZXfZ3gfESt05zcDIgiQicfp9VEOwdVPgbx+GNZbDrLMFkKECfLfomTPL4Ypz5RG
	6X6x+vv0PqfKfP1AjMB7gglirbp3l2jSq1URFCZk/mtXa5fk/0CQGcbDYxxaLAJ7F9Jhpl
	uXiP71KGIT6efVXOg+4aqlCtrBtf8G0=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8726acc5eadso768007b3.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792688502; x=1793293302; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RT/hDzEuwThvLNevH0thxyzvch5KgmlhrTj6s7q01rE=;
        b=U7c/a/KcbUTYuuWPv1IeMtfxvCxgPDjYtV/NfHfa0p/pOpbDloXr4AifT2khdtW0wa
         s5Zocd4cFnDqmYTrL5q/z01ICMI1a5YWa9a2U/x/zyX+X23lFAqZOykWC9TJsxBPQAEg
         8uxN5MVMkEzAauRUlLUgYQqBw0yjpxGKKoHrpDP2cE1XNL434VNfu6FeTi4+zmNWOfVy
         1yHT4iITagszA1ns7FPFZif1+R3vaUOj6qther3ucTuOkBA/QojkWRethtyNm/A7XM9U
         dfbFScvSEWxh+sq9fYAeaoI9dD9H63IW+0batpIy+R1myMVK0ASzTVnlSN3IqbtTcYIS
         mKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792688502; x=1793293302;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RT/hDzEuwThvLNevH0thxyzvch5KgmlhrTj6s7q01rE=;
        b=QD0JxupUJiSuHy4tFOt5+Dt6hQH3ZkVzZX0fZuwBRIrJrGPfQsB8DnRWdK8Fci3q79
         V/jnUDFdgBly6nmRos5T59PAOhx9kmfl6sv1/XQekTdybiNW5T0Jrn9Kcu2ys3yiVZrQ
         NyUc2xlxOKMPHz8U0stGa9IzAkShCN0/EAfAgM8SKHUNA7dZLhHcdWq3G/+VtJVZLw2W
         E9WIANtZ2GtP/oMaSUln3xbQzZ+0ymgBZtq3gXgWpjndGVSpD7dHwfNlXVRUy50BVwCR
         QD+8b1OGGUSmBh1fsauaTMBmrPABvdn8WkfGf9hk/zkJLhaEAt8NjEkGnSMVIBdBwLdk
         a5yQ==
X-Gm-Message-State: AFq9FYKyQMejT32I5dmgI7c+yCcHGghDT4rQ7JC604UF5I7U+ZgWWjFY
	jkNW6tHIE8Y+Pxfc31qMWFHJ96C04tJLiBqhZs7l6eYNqm2Tf8Qnbf7eTVEsr6zkEH8=
X-Gm-Gg: AYBFou1Lh8HEHxxPgA4dWsEAWpNqIWiuYVsC2+lEjtvzFRKUmd39ohteAl2ACbfu6tL
	UMGUHp46tcIq4h3SOIjNZaeVqirKSv6kjBu02GeCWyUNQw57epJxn29Sw6muE8nnseR0mjkXOPS
	NIlhFL85N9DN3F0eTUnPMe8N9m7aRFQT4WZECxjPzbjQds/S9C8AfABn5hFcDg5SkOrcai7Ud6i
	2mS3VrVKph1TrDItpyN4cWItpgQ/14HF9OSGsmeF/AjxjeQuokcghwg5pCuv0FhepagDdvve4Hi
	HvQlVVsks5f4fAMCcBlpux8aQejYJzGUVE7gPkMkOqw2VFuKDaDrm8vGV2z18KZ57SGTexfLAi2
	Z7OzveyTbOwxB3G/uYFju11aUAdR0eJKXVFSnRMzLc5dQkTRsi5XZiDxT25xk72hVUyGq+u7nwt
	7rmM0AaW3RWKzoqJPpGhamJxKYPoy8yFdH3irmBGUdfZo2yHz511LcBbiqcjmbp9EtAKlClS0pN
	MD0FTCTZDm9GST6KduM3sloV1Lb8stKNCgieL5LtEtFdCzEoJYEGqcAz4Fqi7Ulz+l8jcRFd4yB
X-Received: by 2002:a05:690c:6612:b0:8ae:b617:7138 with SMTP id 00721157ae682-8b133d6f248mr38447107b3.49.1792688501986;
        Thu, 22 Oct 2026 10:01:41 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b156164125sm1096567b3.31.2026.10.22.10.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:01:41 -0700 (PDT)
Date: Thu, 22 Oct 2026 13:01:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com
Subject: Re: [PATCH v2] mm/page_alloc: mark pages freed by
 __free_pages_core() as not tagged
Message-ID: <atpBcB-9GOfKFVdx@cmpxchg.org>
References: <20261022122752.74774-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022122752.74774-1-zenghui.yu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4ECFC80011
X-Stat-Signature: hjg53qtfbjimudiirc9sahgifhyu5o3y
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792688503-325732
X-HE-Meta: U2FsdGVkX19cBI2+e3lg3jxAjfHOMsBShS8ydq8tAtkm9arI+iPVBCzvglP8XI12K1p/o764n46SHImlbruHuUqMMgl2NW3TorfeeHZ85wv+9BgBHsSJLDy95giGSmXl8K2RuGdmaX3tGFJd0xcYtdxpYVbBE/T7lnf2KGUEP8ddXjWn0kITCQYOYg0Jlp2M+MAR9MK10PsmH/GL8MDiFbTUNUwjJVoUEolKT+LbpVQduzZU9XjW0t1U/J6E0xJjg4IpWQsyDGrTl9P3JCD+XEXfdATxG++iHc/WfF0BVfnFwuC+DNNqAL+cp1ykUBhihYojSeawwu0iU3GkWoFC0EW8OZqnDWFo+IpO3Tykxd+3ogbzjILkPPPdhOZYUzaujXFxf6sjm5n61XMcdqSvNA4usep0y/gM02FmEq7m0DdlmCBeG1fjj1KQoY49KB62bGzkjcy4zCLbYdJuvcmts45zEtWaH/1hKLqwBR4LIgtEzfGBTrfHS6YOA06mUEqAJT8kPN+cQ1+x9JKx5P+D7ky/j1t8tcDt83TULykq+DmgVYBIvMd1HMvqmES+q7miey7A5jhnwzNSn3KEYypBUYRJ60p3AjL37NNqGGYIMcnb/QkenZa31Jnk/xU7M6R3zgIs/ENEpwGtEYzAjCQwsg2NUMB9JGpUm0xc8CP1wkuNizy6H7Xq9RxmquRemksX66Lj8VLOMnG1O+WTb/0FAzkSVR2i6Ve251HgeHzqtYIDIQIzJK0ONGD/Wk0nuJyxDZtSb53kqyZmOMeKox3BRNd4EOTZ/6ZSFqgRAjupxTEKxLluXXfXuGB9SmdAdtkDGgm3ofKQ9oVmAjLkPIhEX4DYJiIa60h0NcPqMYuOxaHOBPFg9KrxSaJJfRA30aqS55bA+GGPlK8iVkxKf5tM8foyvPoThYPyN7Z2uXvqvFOCUrUTcOtr+e7RumJeoB9WWERQRUQwa1K2OfdsU81
 pw9xg6ww
 LHDd1T4JdqgbSTnWwg+/bHL24EjxYBCQDNvJT9hp7GbGgLNCPFAdSnOlpe876PPn6HV9wyxFAK9+OTs/kWBQLy5yxzOeCA2ZLlHbJPPHJVjCJe91rBx4PdYKnbNQhHnbrwUnSvoqK5uXL8NqzSN3liwwxUDpcagC22ckIDMDZj39COt+xzxvG7Mj+lhNfiZtK23eiVyRBlgLC1UNHA6qGDcEswlh8hWwgHj4KuvJsRUDERTTxlZmaKA5JlfDo9JjHsSOOY66NItHUI1AtVDn399uoQCXs8CgBvv7GHId/RfZYBhp4Nrv+SNz7lITifDg0SQTBGgDz9XXrn0ev/ndEAYMU46uCAG/h/a86ZfCp0bBZ/E2tRPn76KbT+CCiguspopMP/o4y7jfmfV0METMjd2caH3YtuF8NxQi5+mDSZYaYuc29MpTZA2r/Ts00lbl6qW06LcZ+Fu81Bd+LtVH0yvoxME3eHg32E968
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 08:27:52PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
> CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:
> 
>   alloc_tag was not set
>   WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
>   Call trace:
>    __pgalloc_tag_sub+0x1fc/0x254 (P)
>    __free_pages_ok+0x14c/0x6ac
>    __free_pages_core+0xa8/0x188
>    generic_online_page+0x14/0x20
>    online_pages+0x220/0x3b0
>    memory_subsys_online+0xfc/0x198
>    device_online+0x58/0xe0
>    state_store+0xf0/0xf8
> 
> Pages entering the buddy through __free_pages_core() have never been
> allocated, so their allocation tag references are NULL.  The free path,
> __free_pages_prepare() -> pgalloc_tag_sub(), expects a valid tag or a
> CODETAG_EMPTY mark and warns otherwise.  Paths feeding never-allocated
> pages into the buddy are therefore expected to mark them with
> clear_page_tag_ref() first, like init_cma_reserved_pageblock() and
> free_reserved_pages() do; of __free_pages_core()'s callers only
> memblock_free_pages() clears the tag ref itself, and the hotplug
> onlining path was missed.
> 
> Since all __free_pages_core() callers free never-allocated pages, mark the
> head page as not tagged in __free_pages_core() itself instead of relying on
> each caller, and drop the now-redundant clearing from
> memblock_free_pages().
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

