Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F8CECD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 17:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7116B0005; Thu, 14 May 2026 13:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50F66B0088; Thu, 14 May 2026 13:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F736B008A; Thu, 14 May 2026 13:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFDB16B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:42:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6979A1C1846
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:42:16 +0000 (UTC)
X-FDA: 84766744272.14.FBF0913
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 839562000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:42:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kxFwcweq;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778780534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sht5IerBv+Ecgij0pJTbslvBml9tDFuej5I3FwU81dI=;
	b=o2cT4ZxYeESce4t0cfEuJYqGvMSQVK5YWshTcNVEVhfj341NqOlErpoNBK8mlUOPm0RT8o
	jHrlRuwXxGyHy5uksMTms2xopXUcnOsbYLiqLLlnwTLBBtZ1bzT/KY7Wkqh4V1Kdusmzi4
	Qz+VPjhQe0lLoVg93Yp+aRiSkTrJQNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778780534; a=rsa-sha256;
	cv=none;
	b=q5DRhzw0hTakE1XtQGIof8krcG0vhXwEj0HEBzigy81s1Lk7WZnbgBol4DpKCBfm3OEcru
	jtaPvjm+yQenMJ2D4XYVIlUD5nrlq9mccQ1LyI0JxvIb1BQ9JSL7Zat07JSJHaNrfWgG7V
	P3kxJnBAek3002UF/nPIOlJkc5impEw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kxFwcweq;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-91173f20ccdso28624485a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 10:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778780533; x=1779385333; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sht5IerBv+Ecgij0pJTbslvBml9tDFuej5I3FwU81dI=;
        b=kxFwcweqwluR9cYPnYAQB4YlBJQNypHdLljvKEogw+frmkFi3znsFXVZ3sVQUOdCpd
         x+BBvCRNBSiWQ8jZ9fNpk6ciCHAdXyR/Bg17rK1sRg+YBe0vHw9EvvSwodlg2VDtkcF3
         u6AfrJZWLkwV/B7739Fe9aThsivwZo0/yGeEyW0RY52jwJKPXySb8tDwWJ7fY1v8s4Eb
         6fe3c3EnPTZ77zdjNiX+iriuHEJ6TJmvnAz5nNAR2Fwm3ynJlYCtrfPkLKxi0aoy/+7W
         ZmhaFdapLiYjuQEMNLj23BSkOsRjNnY3TbVxun3aPolLsWocEOwlQHcYXN8TDpYoU26U
         mD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778780533; x=1779385333;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sht5IerBv+Ecgij0pJTbslvBml9tDFuej5I3FwU81dI=;
        b=mI4ja/DJQtXa5mt5lxb2CjdRcju73Xy0p7dTdUOck4Q99ldeCHG2OzGSmC212G9cf6
         nPH7XsqLHy9d9dhgLcSdHu9YlmCX0YW55JYuJDaqKqw5oTQ4fkM8qGI7IJjqvaZUeqnu
         84/MzfXJl9+jK5cP3oTn5U3iO+ByG5xfYhvXAQOh5icPTctJ1qMphelP53faTpwhport
         m8wW3/B+LR2pggWuH2SZ6sltPYAbHlRbfyZbxUorBP9KxDWvteVhNtQgL/ERwKIW6Pi5
         lPgmeMdYywbx7yadkiCZ9y695MyHnw+hWP1H6LKrrk4beXSIkW4IcUEONVuzhaBmXvK3
         JXqA==
X-Gm-Message-State: AOJu0Ywu/UDKvG+C7cRahOYf54U9egwMSoij7dVjQg/oveEQ5k1ZV1tx
	w6ngWKKWm0olxL/9XHe/11E8R7URbisv/f5zdxgaCd3frnnpbex2jibQBDSfYkDHDYlbWQ3DMY0
	8ytDl
X-Gm-Gg: Acq92OH64HgAl7JMwGPJ5wiRAtuC1SzmIJpwP1bI/i/dtAijDtlrqUqdHdjxIb/S52I
	TopF6B82glO8tW2C07nU9UTSDbTmFmxDDh4pyfDCP4V/np9GC+gVkxHyLIZqYK2GZClbBRJRMif
	l+1bSklfFAicgEHPj6qmkCX5rYYe+8VDd3SM0lTSy4xCgFwo//qk+nG5Kc2dFWIZTuehpbEhYvI
	WDJg3ZidfP4iBxNylRhIXDOrLFPAuZ37IB6V+bq3p5rito2HTdKrgGjWEn6EjJbpNJ+RxZtSytr
	cxUx/CwjFX7A2tsUDd6HVLb8Od3hE291TuR59cdXmM427RrO6svRC0vABpCMPXvE+u4fHOdpAym
	O9bpxwbbCBFgrhXQcv3VfzPpv0wn/6ENeFMOVMfzyeE232XbWxDzIZY4V3papQZGoKiG+gBYo6r
	ojYxNXunMuIuJup7xLaEy2iLVutw9reaeT4ihwKI5KQMnyxjRxe+HC74wzL4tzgJqPsREfEcXfw
	5wBv/sifgGd
X-Received: by 2002:a05:620a:c43:b0:90f:624d:70d3 with SMTP id af79cd13be357-911cdd41abcmr99296085a.23.1778780533121;
        Thu, 14 May 2026 10:42:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf353b9sm313832385a.35.2026.05.14.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 10:42:12 -0700 (PDT)
Date: Thu, 14 May 2026 13:42:09 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, jackmanb@google.com
Cc: kernel-team@meta.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, sj@kernel.org, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, jannh@google.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, pfalcato@suse.de,
	rientjes@google.com, shakeel.butt@linux.dev, riel@surriel.com,
	harry.yoo@oracle.com, cl@gentwo.org, roman.gushchin@linux.dev,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
Message-ID: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 839562000F
X-Stat-Signature: fsz99u898scmbzsh47twxngqdiuydagn
X-Rspam-User: 
X-HE-Tag: 1778780534-978531
X-HE-Meta: U2FsdGVkX1/5dCeiIFwTtWXKcWUX/bEUrNjrR2IgBez2IGHQP+yTzmbkpTIYyEJAoGPn1z5BXvp1ScI2WPMLFnJtKxhCmiC/5fyV3jmx5hORtd5/3oU7YfnyB6njlVcoGvfFGmpbQlGerPesm7FIw3R6uvD7pk3Eq+mC9+KWMT+XnzxLA+naGzBvubMze+20BoSliQO8uaOBx3fEcB5TOIIbFyM4vqqXzE+ubVm0BL21yNPZaMxVpd38W7y0IAAvObQBHt4fqMo4EECw50GG51yYQhWRoqrC5C+WzbN6bFV0XXf3j4EKxzY3YnHTUaINz2qNU3c3yqhit5RZ76UNrdDn1S95Lcx83Uv5mmgtF7czQJNMe4taXgWX117rf9lB4ymple3ZkzFHtmwV4HZZwIJ0gezFfvlo4ZuTPiONgyiCRDx43W/rwLYOM2oXBvZP+zu+1gEmitttjF6rpr7Sjc4HugAuHUdFKJbaCMMxeH1pdpGFE/4PRUw2EbnWoYcIV2gDEtjSTEz2zEXR6EPE7CwczK9meTi2ovWf0XFsp9AheY3xlSYwrTXud0ZW5i8YcqJ70a0spC9HNJ3Ks1jDENXoXas0Uy81bFvZKErH5scV6Dl5YqBEY682BaUNLGKwgzdU2q9B2EENU332tl0LWi6pY0lkpO4ALMR1bDDfEVqaIa5wghd2OgFZqqSGHdk/nTfm1DXwvKGO7kCtfB/rZkHUkZyr9jOy2wY+L2YbWJq49njEWMRXp+kmq8Sl9ynuAoNtO1MWdKHrn81n3m9PO244aYvtpOrMBi6aAEr/B/kYHh2051KcolN/juhGqAWTXpdPhcITXcy9V6Fej20ZCZEXDLK1R3McU2jgaEdEMz8uA0f8G2udD5k6X0CvW2LoCiekBtaf/iC6GtE+CqFwaY52N2gy5YQj7CBRvuccm/dyphduWVuSYTLTc9/y1HIRq53vK4id/1rwKkeG+jD
 OCf0k6Rp
 LCg7I6ZciQMkxmpLbfbDbXJRWQ00Wd/y5vOWqC6adb8LR6RgGCoMaBd+6KCXY85k4QUssrAWvmeTQDanQLOf80Gd9OmmeLSPbbzRo0Sk+JV1uYykcgb/XvbMW70EIg8gQyez2HF6qQWmAUNGN1UdwV+SkcGHgPdJEpyPNcTlivnxdU0EVpD4KHhVZ8CpmEBy21fnv7ShN6UByiytWnC+QRf40QgLMKuaidG1GNFXBP8HY4gpmowXLSUKexdiLbWpGBVBuJLnCG1J27jtdmUl61BSqB9fCGQOIK1rOT8j1Aj8w44uwbSZLU/qqVq0+6PICrSfv06cTK7SFBZW+LumAS4JIzy3dxApmoIy+ku0XBCsEbHZYiA0CSp1kMfsqJdPShQIf3nzQFRPE5Lxi/lGiyuABMgrjbfSazhPlNqKu7Y5sKpYa98mbTh51OhJsIYCwp/XbgrBRpMHspouWgWGLXlixphrSaIQ5eCHj94PsDsCPScOwQ8L8NZLr6T3WKYM00viY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm sending this as a general follow up to the __GFP_UNMAPPED and
__GFP_PRIVATE proposals that were discussed at LSFMMBPF '26

__GFP_PRIVATE
https://lore.kernel.org/linux-mm/20260222084842.1824063-3-gourry@gourry.net/
__GFP_UNMAPPED
https://lore.kernel.org/linux-mm/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/

There is a general push to avoid new GFP flags, and there were common
questions about alloc_context.


I have an idea for that, but first, let me address something about
__GFP_PRIVATE.

For __GFP_PRIVATE there was a question about whether the global nodemask
interfaces could be fixed. I've taken a bit of time to look at this and
I'm again left saying: Not without completely reinventing the wheel.

In particular, there's nothing that prevents an N_MEMORY_PRIVATE node
from also being N_CPU or N_GENERIC_INTIATOR. 

In addition, there are a few hundred instances across the kernel of
nodemasks being cobbled together from node_states[] masks and stuff
like remap operations that may result in a private node finding its
way into a nodemask.

This kind of pattern isn't going away, and node_states have UAPI
implications associated with them :[.

The reality we really need to make the allocation request explicit
via some argument to the allocator if we want to re-use that code.


Yesterday I spitballed the addition of a new alloc interface:
https://lore.kernel.org/linux-mm/agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F/

I cannot speak for Brendan, however, in his cover letter he said:
https://lore.kernel.org/linux-mm/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/

  For now I still assume a GFP flag is the cleanest way to get that
  but in principle I'm not opposed to alloc_unmapped_pages() ...


His proposal looks a lot like ALLOC_CMA, in my opinion.

I'm wondering if we can solve both of these with an alloc_context
extension.  In fact, I'm wondering if some GFP flags should actually
be alloc flags anyway.

We have more flexibility with alloc_flags (for now) because they're only
defined in mm/internal.h.

Maybe we could modify alloc_flags to be a struct, and export that
without being tied to down to a 32/64-bit flag field - and mark certain
sets of alloc flags verboten (internally controlled / controlled by GFP
flags, and will either be ignored or cause a BUG()).

Then we could get something like:

    struct alloc_flags {
        /* 
	 * internal only: will be ignored, cleared, or cause BUG() if used,
	 * or should be applied via the appropriate __GFP flag.
	 */
        uint64_t wmark_min : 1;
        uint64_t wmark_low : 1;
        uint64_t wmark_high : 1;
	... etc ...
	/* 
	 * external context flags
	 * allows explicit access to certain resources
	 */
	uint64_t cma          : 1; /* allows access to CMA regions */
	uint64_t unmapped     : 1; /* return pages in unmapped state */
	uint64_t managed_node : 1; /* allows access to managed node */
	... etc ...
    };

    ___alloc_frozen_pages_noprof(..., struct alloc_context *ac) {
        ac->flags.wmark_low = 1;
	...
	prepare_alloc_pages(..., ac);
	ac->flags.nofrag = alloc_flags_nofragment(...)

	/* First allocation attempt */
        page = get_page_from_freelist(alloc_gfp, order, &ac);
	...
    }

    __alloc_frozen_pages_noprof(...) {
        struct alloc_context ac = {};

	___alloc_frozen_pages_noprof(..., ac);
    }

    __alloc_frozen_pages_context_noprof(..., struct alloc_flags *aflags) {
        struct alloc_context ac = {};
	
        /* Snapshot to prevent external changes */
	ac.flags = aflags ? *aflags : 0;

        sanitize_alloc_flags(&ac.flags); /* BUG() on insanity */
        ___alloc_frozen_pages_noprof(..., ac);
    }

For existing users, they can continue to use __GFP flags and existing
allocation interfaces.  For special context users, they can use the
context interface.

For __GFP_PRIVATE, this would look like modifying just a handful of
interfaces to include alloc_context or alloc_flags - e.g.:

   folio_alloc_mpol(gfp, order, pol, ilx, nid)
       ->
   folio_alloc_mpol(ac, order, pol_ilx, nid);

And a bit of logic to simply set:

   ac.flags.managed_node = 1;

This kind of pattern already exists with things like scan_control,
oom_control, etc - which carry gfp masks around.  Maybe those things
should just carry the full alloc_context around (w/ gfp and flags).

~Gregory

