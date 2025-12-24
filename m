Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC60EE78497
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 21:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6346B0088; Wed, 24 Dec 2025 16:45:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3786B0089; Wed, 24 Dec 2025 16:45:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C416B008A; Wed, 24 Dec 2025 16:45:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74CF96B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 16:45:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDE5958F81
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:45:25 +0000 (UTC)
X-FDA: 84255696210.16.0FB4D76
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2C21840002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:45:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgobh9xB;
	spf=pass (imf11.hostedemail.com: domain of rientjes@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766612724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVSrph4vFqsRAei4UBF49evcQq/UGcTwkAqjzFfFby4=;
	b=Rc5YcWLhWtfhPP/llhXBU0qtb2fe0nRuNatCm1vJQ2LDTW9clIXq1osTRSUl030DDiO1UZ
	Ozjd0/nlNtXCoITyY/LwDajcp+t8rKFD+nG/GSgsPI53CVNn1pQyP1G3CkpKTCy7mrc8EJ
	kUdSs1lj8pHquEeRFstABwcDFwZK2Go=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgobh9xB;
	spf=pass (imf11.hostedemail.com: domain of rientjes@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766612724; a=rsa-sha256;
	cv=none;
	b=cH1GF4nC7Tw6ahX+A123562fBeq+AdKCQlhAajNn4b/fPUJKVdJqeqhKNyU6h3wp0bRquI
	/Gp8B2IWEC/Y5Yr5R3SajftuyqR1KBTBsPMIdZg8rTm52aY7LZwsTnDdg/uh9/qZNYru44
	OKN3xnuRypdfbVipyoneCi1y57Vmqj0=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a0d06cfa93so906615ad.1
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766612723; x=1767217523; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BVSrph4vFqsRAei4UBF49evcQq/UGcTwkAqjzFfFby4=;
        b=bgobh9xBqErRdL+ZeYoMm39drEO6Pd0xMeozP56T0nBE9VXrstsVYE1fdPqAaP2XZ2
         euOc96AnG/nzIF8DBA6ifEfnCVttBfc/dar40esLuN39SUCE/+1FVxAefcOrNypqEjhV
         CGrW5xXfXzXjrrtYkbGmdlMBPlbJtakFBZYOj9Quc3n+vS6Klg/fnzrnezBRy3VjFUIe
         3VrcFQHFZiuxON1NFSF5a7P3p9FxsV4dmlxIlwdFtE6ese8S3YlwN8NvAyAGX3uskcah
         IqgWYKa8yzRrZzglUFsegKRYwG9Zus2RbkRrtgN6ruhAVhC+KT2qraz3ywpe79NBCoLa
         RyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766612723; x=1767217523;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVSrph4vFqsRAei4UBF49evcQq/UGcTwkAqjzFfFby4=;
        b=urjlLcfVq7JQY7ZmxeR44r+4okc/nTrdzR4PqVljmD4ZQyd1XfMLSaLekpo7r2U16x
         SOM+ud7wqJZOGevxVGVQovU0W3LkNb8ok7oW1ohyIHMtxrewM3vLB4QAcGzHYIJL7jkN
         PtnSwRSxrrKTo7Q4otxgH9Ev4tVUfAz1CVycJFgJ/txU4rO0vW3bqzPgKW70tEHXXUgx
         q+zAx7ETuHSqczWfFw5bsd9LouWhWcT+N1d6b8t+qw1Bpc7aEXoVsyjQdXAthAScjNsZ
         GdkDcSUiRoMfrYde337TtkfPZQA0PbN2b+GSU9xQPr5LFJw0rE4D8cf93u7FmpHs+n30
         Usdg==
X-Gm-Message-State: AOJu0YxeaGGlRRwLG4S8Xy0xN58+REuQrz2QDEuoHNzhKmEPYjZD1iz1
	zWFuAVUxuN6Nda+oO4I7nm9X554KCw+EoIbdZZHduWgWXzjD/6isKJtYALA/uxYeGQ==
X-Gm-Gg: AY/fxX63fuE1jyL2IAcA2FpS97DoGC7rYmoiKuJZIMGKEEvF/8AMFKc5rMy6ALag+IJ
	R/jXmaguKlfLA7fhj7slZQndK0uUr8T5MvYAe2SZhJmPIS6pgWj/djFniCCF0eXLhcP63aaVShC
	Ckg4tAwWo1ihecQMpU18ZsVGn6QV6eaYfhTZrhU8ZrklopGsu0Wqp/aiz4QnROTmZyfViiuEHn6
	Q4lowWByFczgNM5gxb3xIyFX7GqBiuZroQsI7YxPW4BKwsA7KW7aEPU+hovfuunwO4YKC0MubjQ
	sgBU5RXUYWD/1iVccjROmHKUuFmlsk9Xb9z7+R4gJnbD7howrdFzc32qO/6uvtx9HXiuOYphfTM
	jJZC0tvM613IbexGKmo/fgQPBjuycm55knwBVOyF1GPhdVx/yAdB5LcVdXYWmcNLLleyuj35Skd
	ROt9pE2MwavZCoK3jzQ+yD3b7YDVXxjEBK7MIiRoD0BZOft2GnK7toWZNThVmpfdxyoA/a+tVuN
	3/qpKpcgE46Nb8G3G8Tcyw9gJkPl3eeq+uumgrzxw==
X-Google-Smtp-Source: AGHT+IFinsP+qZuskXhMf0I7dlZgK8eVRNz1z/uGY3g6QJhLT6VgXkln24BNeTU7r9KKUD0or0bXNA==
X-Received: by 2002:a17:902:f70f:b0:29d:7b9e:6df8 with SMTP id d9443c01a7336-2a3522d57c7mr2328755ad.2.1766612722711;
        Wed, 24 Dec 2025 13:45:22 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:892f:1325:ec15:5ca8] ([2a00:79e0:2eb0:8:892f:1325:ec15:5ca8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3da7dabsm163086525ad.25.2025.12.24.13.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 13:45:22 -0800 (PST)
Date: Wed, 24 Dec 2025 13:45:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Gregory Price <gourry@gourry.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    linux-doc@vger.kernel.org, kernel-team@meta.com, david@kernel.org, 
    osalvador@suse.de, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
    Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
    surenb@google.com, mhocko@suse.com, corbet@lwn.net, muchun.song@linux.dev, 
    hannes@cmpxchg.org, David Hildenbrand <david@redhat.com>, 
    Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v5] mm, hugetlb: implement movable_gigantic_pages
 sysctl
In-Reply-To: <20251221125603.2364174-1-gourry@gourry.net>
Message-ID: <dd6428a4-2984-e8f0-2760-bc2c7056b009@google.com>
References: <20251221125603.2364174-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ssiddosgw4bhiscazqcr6qb8iyouwcot
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C21840002
X-HE-Tag: 1766612723-748791
X-HE-Meta: U2FsdGVkX1/fRdw/eb8T17W5jabY6Ol4UezpkHB/rK3sATQFhpGAAikCxgPTIZiPJlL4cGW8HwM6wpnfwwfb8kBZ0CUujk0RBfnbgTF2ZO1rllh86pmaFYxGIkKL120gi/+7bLjnxgQkrWbzflvVdDsKgSHL6tMTUA/X5POF0BVi8JFm1ffX6LY0r0Xyb+KBHzmNfSerVAtGQfTZsLkceveY9dLTkAEwDMS2ZWC9dD1C1qKloIvmtio1ulHBqmb1/lZycWxopwwKXGEBJOtSnTaYitXKBc/ajHXXFHkhhKU5AKmP3FzIK7uYXe+DrypTADDW/RT6BDpRvFJxmc3CLtQ+plvlfU13fsHW4G+nEi3EGHCxjkRFKasaOciNOJmWrkfczM7xmIDrZj3Ei0cnM52EL3NtKZLnMGDQHeS1+5J56M6WeUsVwbUGVq9iVirzDunhecuERxid+LJCOvYUeSqvnSrmjSc6uRQwNz3nhOjib0WsbAG5/zCTIO0oy1MsrkEuow0HK4PvJdVt4MFlv3uwODAX3EeS/2nOLPaqt2q6kVOoIOkLy2w9YJv9qf3aZA6QoJqaEh7I7s+IsUt02zX53xMk+XMMeKf0p89KulitoGnDcVqHI9DjiFDOvaSiTJFWT6IvcOBDAutzokGMyxK9bHm+QF8a/sUAiuBEvcgC6eOIBA+O5cK/uUztHCOaxt+pR3zgTNJYNUbxWq/VMPUYNy7WDgN0oUV0Qjyf5f0n0c0gPCFLT+RRcBduTldtoNgnCwM458Gh6eoRToRJ+3cUGVJJ/IyUDURl55A6j48FpGY170py4jG14yvmKNfofVOj58zd+//lQ76Xqrw7m7rfTFl6wzUqsZgPOAgl5nFI3gfpsQcfz+nxI74npD0FG8l5OyTExHAxsInL2xRorwPnZkSrExiUS1mJKe0YgQbKKkY/SURY+F6tFjNaTeDaMLCklhzWTb+FVIHtilp
 /C50Tgca
 SHdMafLUSxdKLSy/98PdPPLkWrUmwoD1gnvS9OjHY2tbc0nCEWetsbPgRvWJhTtpRVP4ot0fljB0gWM9oEpi1kb2Ye0M2adbLKEdXg0tLh4TEkqWqQ/ZKssUxR1ydqnmVMoLMURBkx1TEayd/ZXuU1lW6Ani1iq/kdtQyrVwC3+v1Gk/gacoMQSn4WJsRuUcVmXppy6qiMqzbhFn9cHOa8bn24VnyPwRLDvLZdQIaQjA22m70g9tkOUU48sMSpYhXPpOVE2mvRaoBRKFPNfRbh7C1rX0IAcWIMF2N1EJLE8iflHNLhnflVMVAr9ukWYk4WrAnm/asjUaFd/dIVSO2MlVdLd+J9k8ylqAAZF9W7c24LcCQlgRrK3oR3qrckIVCiNXIyYA4nlX6k7Q5/tbpSEcBSx5BRWtHS1dsifHKSqGApw1nXMEUrhzfnpcbOV8JDdq3H21rqTpQdxTEfrJoIMTYsUAV2tzi7jHBulOj1hDtoKf8E2C6707AEQDCinymGEP+zqvuRvUrb60einJm0uEOtN5eMfzxN1ZdWzlKW9ncXV4wdPijzpN//Idz5Mu1HTpajTxb5TGQACLZs9/EOfMtpYuqHD1uwhTDRvWGxLNHWrD7dDeq+PtHymhpYOpBOptnwwUoSo/tBa7nBBgzAyWksN5Zp1rzYSPPlXTtvmYL7feORvu0pdtOUZ709lovZrU34B8subJeLkObnw1+LnyMKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025, Gregory Price wrote:

> This reintroduces a concept removed by:
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides flexibility between ZONE_MOVABLE use cases:
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> 
> When ZONE_MOVABLE is used to make huge page allocation more reliable,
> disallowing gigantic pages memory in this region is pointless.  If
> hotplug is not a requirement, we can loosen the restrictions to allow
> 1GB gigantic pages in ZONE_MOVABLE.
> 
> Since 1GB can be difficult to migrate / has impacts on compaction /
> defragmentation, we don't enable this by default. Notably, 1GB pages
> can only be migrated if another 1GB page is available - so hot-unplug
> will fail if such a page cannot be found.
> 
> However, since there are scenarios where gigantic pages are migratable,
> we should allow use of these on movable regions.
> 
> When not valid 1GB is available for migration, hot-unplug will retry
> indefinitely (or until interrupted).  For example:
> 
>   echo 0 > node0/hugepages/..-1GB/nr_hugepages  # clear node0 1GB pages
>   echo 1 > node1/hugepages/..-1GB/nr_hugepages  # reserve node1 1GB page
>   ./alloc_huge_node1 &    # Allocate a 1GB page on node1
>   ./node1_offline  &      # attempt to offline all node1 memory
>   echo 1 > node0/hugepages/..-1GB/nr_hugepages  # reserve node0 1GB page
> 
> In this example, node1_offline will block indefinitely until the final
> step, when a node0 1GB page is made available.
> 
> Note: Boot-time CMA is not possible for driver-managed hotplug memory,
> as CMA requires the memory to be registered as SystemRAM at boot time.
> Additionally, 1GB huge pages are not supported by THP.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/

Acked-by: David Rientjes <rientjes@google.com>

Thanks for pursuing this, Gregory.

