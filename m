Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3CBC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF176B0089; Mon,  4 Aug 2025 05:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958866B0092; Mon,  4 Aug 2025 05:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8474B6B0093; Mon,  4 Aug 2025 05:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA7B6B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:04:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F336C1411CD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:04:14 +0000 (UTC)
X-FDA: 83738488428.22.F3D50EB
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id E949A40005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:04:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI4aZSGi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754298253; a=rsa-sha256;
	cv=none;
	b=ET+ENWSKInQpwc0P6/SVpc867PWR+fjNuChrA+0GoKeCyKXlSGdEeBoHHG/y0688l8T7/d
	efg2jRe8HGu0wkTw1epPqHYOToaFAxxJFCDvHc3WZiwtHOxoYrxPZAtL8Lm7/xHzbAiFDy
	rcvksoP9DtQ87yCDYVsP+3PBk4uNAY8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI4aZSGi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298253;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acSH/YECNzPqrJpecMNECSlF0Ozf4k+b5plEpSVAioQ=;
	b=kFWdYO89WuCxXCEZlJbDzYm9ejDz177sP+lMfU3FNBDe78VdDGW++EkqFjQMhr3haOmnr1
	j2Tvn3M6NDJNxELnULjJ8c3QKkesBpbG+JpQOEg1SGfydsJClebnJDuH9kfoYxbzP2jlmb
	tLafr3xE+qaSNBuCsJS2u2TBmgCOFoU=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae401ebcbc4so714028866b.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754298251; x=1754903051; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acSH/YECNzPqrJpecMNECSlF0Ozf4k+b5plEpSVAioQ=;
        b=WI4aZSGioXy+N/+q3JVWgN1axZ/3yiMAHObUZjjnbkwznIiapQvgwB7R27x8tPp3kV
         2RJ7qySCAlPUz4/ipT/IyYTMarNd6CR6S9oHET7xdM2o17zxJYAXEl1TCuA2zFZN2wWx
         Rexpkb14ZA990nqLtWq06JGlsZ5bBiFSJmrSWlqNVRdij15/L5NjPnYyK0kIrIX/83Rs
         k+Tlgt6e8LfFV4Gx2ZwdU76PcCXNwnvHOwYvCj1XheknRsAMtBfxLiARi0kSsW0Zq8PS
         g6+DCsHX/JCCQjdOMyBnIbZ3umk7FRguYEiyfD+Nt15ANeji7flLsUpkgpP8mo8z99Ks
         Toig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298251; x=1754903051;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=acSH/YECNzPqrJpecMNECSlF0Ozf4k+b5plEpSVAioQ=;
        b=GBsQlOWRnoZB4Y0JROT9T/X2dtLXrFkkxTGU42tAOVBqIJIYlGQj9lJtm9c/G80qaM
         an0ydKrGx3f2D0TcfBpskbmtkRrhIBYNfCvphDZRmf586J41zQe8VEBe+m/jF/jnJ+zS
         0tkumCSpE74++jfUIMOEbbd7pPaJKZgPkt5FPZNts/+y8DHYiYNr+GNGpJ7GFNmlYVY1
         WUlrQLH47adYpvcA3mmv98GJBBjz9JFTKGfL0HfHd0cFRq4Js8rLSRfR5HmVTQRzXKoc
         +c0QPnhDujK/lV+Qn27C/JK3xsFuLEB6KhD2dNiDR/qrX93AOQXOtXvJyG41qIG81eE7
         /u/g==
X-Forwarded-Encrypted: i=1; AJvYcCUAZ67SZMMCMwDEbvZUny0sihF6sZedDp6avgdh8gcEZsc56kivllZhsNzeXN1GPwiDqQ4zohlG3w==@kvack.org
X-Gm-Message-State: AOJu0YyniY9LM2gJeEMm9kZgzhU/Rmx4Z/QHmt16qPmsBCpLFqv6pQFF
	YhMo9ditBPKk1PaW7O1LwPy8RjqkaOYIMuhkrvEh5y9NYwmOCGCPCdNO
X-Gm-Gg: ASbGncs/SHfA0fd+gBZLwLPgIFL7EUeEDZy2uhaDAb3kCOgNebfOURe3dDoGfeGsTiM
	VquQFtUsSPllLDmmM0LJDTYN/F0TRof2MhTzVwilc1vzWsQtVIHRXnpW8S+LYYR94LPHEgp1J8g
	mHFkLmtci07uMGdQwi6Gzg06poJWV/mhKJU9UFu1eu/iNfr3SqwnoMgQ2fVgF0J0ePzbRTawf2T
	rdWCkK6VWGSJiOsLCToF77dFftzbeNZrjArRqeAvft4DYZZVI9P5XIq5yvz/duL1cWvJKSkj72t
	BS6znj8Gm3vDqiaY91j75pErZlmVf1qLvecYanLPsDr2txvNOKB/0JfBO6XhQZBem16iNCgzCNA
	en+FHBnZROQysY0kM3bYLWYbzyTl6MuWV
X-Google-Smtp-Source: AGHT+IFo1FiK09kxSqh9OOz66lLLPAg3rVm2WiND0BXkRJXNrtebIpCavH4jstjbD8rfqeuDjfzk3Q==
X-Received: by 2002:a17:907:3fa2:b0:adb:2e9f:5d11 with SMTP id a640c23a62f3a-af940174eafmr807904766b.37.1754298250902;
        Mon, 04 Aug 2025 02:04:10 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3b77sm702303266b.51.2025.08.04.02.04.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 02:04:10 -0700 (PDT)
Date: Mon, 4 Aug 2025 09:04:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v3 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
Message-ID: <20250804090410.of5xwrlker665bdp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-5-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729053403.1071807-5-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: h4yiysdnwqiop7zhnbnsq43d6u934die
X-Rspam-User: 
X-Rspamd-Queue-Id: E949A40005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754298252-409393
X-HE-Meta: U2FsdGVkX1+YshN58wBzZgG/Q+ToCiT5e2ffE+8XycYUGN7ipZ4+GNYBm6oWARFThXRuaJPnikfkEWbsrRgKBkaA7pltUDXdBhot3QlgpPcpijBY4+JGK6kXLxRW1MLt3OQOxNewtYyFBxt7l7P67QyLLNbeyfVdAjLBdLdZEvqdmOwzVYIAAjgNvw3pQpQG6kaALnS53JHJGbMgb+4NeWl/lOrbo3sat+J10Y+XHPfgJNdKSP/jBXCGtJACZ1tnwBnEzGYdDn/dOp8mvjyIwBipacF3a+QU4KL8tN9IZQn5WtdjQPS+dQRX8B+b+byv0DtZBH5EIxnvuwXac+LgFA6ydkT+dgmzJ+1L527rxg4z+c1RY+W9FsI8KtD1Jhl9ziAfW/dV9EGh4w6N5UAIVFd3DY5jWGpsgvU4d0cFgmRPR6JrWUc9npAn1U9mcoD903//jBtr15PjBuBBKwDFEdpoziij+jWd4X46/jlPZtiq8EEFTLmQd9VVru5nTTfuYcVy9rS94auO8PbQhNcdgtCXc8L7/+9WQP9DDw9wrHdlpjEK7Ybpn7hMPJil/IMYBEVLoYhBIsQPOlfWIqKlQAo1oyp+mCA9rm2prDh020pswRxDsyK4VekdQXCIERU5g+GY+Ou4ED/Slk8WJvLkeGo7tpS2AMJuu2/f8qRlphnfu6Zco8OvtpxwSqmblF3g3T1rtSSiENRiT9pEfjKfSXQQHTcaEcfnpbmgyJEb4aQvlw63htfM1i/bIOyqpCj0CoHT+D2EnrMeINcaKeDKfO7CbwqrP5vRZciFeeoxk+hgqtYf4QQrhFcFNomm6pYjDSrp5pvZ6ZbIxMJKmXmF+rWom/AXmSXJoOWzqgTeKku/u12srXcuNjnQ73oOxaqTURD2DPO3TNY0udH5hajD/nFSmMWgMXfU8QmAcQ1S6eruMRer0uIFsd5foiBq5+1+gUX/4K7AOf45vfz1gpY
 qXhzO07+
 dzBwITjkkLS8QeUzxHK7BQBXYG9+q9+3bbLaB5w2rd+sLUPkGYqsPgch8IxJYPJI9EKnm7DW66uPfhEUdu8lJAoojNMi0Yqyse2wt9bKJIqQZSdc5SJxdm1fz2e+1v+N8AlzS1fns/JVK9YGZ3tzqWy15FjXiJSB5rubT51YuZKE7XZVxm+wG7NCz0G118E5/lTBz+wIQlMX8dWogZ9bKOQTedRmumzWSnUyjCum5MUrPN7WFyLFqZRB8T8HK1P4ajDsOzpovFsAG+4HBU8lDRehr/dQFZ9tgi3VkTE8/+eb7thYFSjc3Khtwwdr8xxRXZ33CtUknLEUYz/oGN+ffcsCq2QZ06GTiVUQVbC5KNCaJuTwCWEiEXvf5ES94W+60H7SsocOXSd9pLLLFzJKpGfm1NMhN8aJcYrAZoTeeFEzFZ0leg+R8QOV9gpG+TYxsQcXRSmqOVcd8r/8H9DjRf6o+7VMUiW6ICR1qxCT7fpppPSRIdWRWWi9PSfa4Ro0lAFnZW9SSYOCiPyv7W+lnlgGSZa0PxiTDRbIqDbdOLq2E9chUiULV7P13VgENu7hfri9gUI9DKFIAzu9tQ/NnBXMnZ5vAyjsoVMWXYbTDdCkS0+EIEU1WroyXf3s0P3d+uNTSpn/76ArzKoJZ2IXGhaT7HwbIpsUElhbTCx98hGGJ3wEIRNLEDGl9vKjFBzm6iCpeoX+Npp+2qgcbQMliSVy66m0VLFzEOfvLVad0ZHtTvV3wW9zuPjbqx5rafp8Sq4mFp4Pt+jmAt/II2aehcJGF11kMh6nms3IkvjIPIHynjnc8szQ2subi6TkIztd3YuKqegphNutvMReKet8t9VrW2bnSxvkL9pLU/MoT2Zpvb38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:04:00AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>The split_huge_page_test fails on systems with a 64KB base page size.
>This is because the order of a 2MB huge page is different:
>
>On 64KB systems, the order is 5.
>
>On 4KB systems, it's 9.
>
>The test currently assumes a maximum huge page order of 9, which is only
>valid for 4KB base page systems. On systems with 64KB pages, attempting
>to split huge pages beyond their actual order (5) causes the test to fail.
>
>In this patch, we calculate the huge page order based on the system's base
>page size. With this change, the tests now run successfully on both 64KB
>and 4KB page size systems.
>
>Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>---
> .../selftests/mm/split_huge_page_test.c       | 23 ++++++++++++-------
> 1 file changed, 15 insertions(+), 8 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index 05de1fc0005b..718daceb5282 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -36,6 +36,7 @@ uint64_t pmd_pagesize;
> 
> #define PFN_MASK     ((1UL<<55)-1)
> #define KPF_THP      (1UL<<22)
>+#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
> 
> int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
> {
>@@ -522,6 +523,9 @@ int main(int argc, char **argv)
> 	const char *fs_loc;
> 	bool created_tmp;
> 	int offset;
>+	unsigned int max_order;
>+	unsigned int nr_pages;
>+	unsigned int tests;
> 
> 	ksft_print_header();
> 
>@@ -533,35 +537,38 @@ int main(int argc, char **argv)
> 	if (argc > 1)
> 		optional_xfs_path = argv[1];
> 
>-	ksft_set_plan(1+8+1+9+9+8*4+2);
>-
> 	pagesize = getpagesize();
> 	pageshift = ffs(pagesize) - 1;
> 	pmd_pagesize = read_pmd_pagesize();
> 	if (!pmd_pagesize)
> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
> 
>+	nr_pages = pmd_pagesize / pagesize;
>+	max_order = GET_ORDER(nr_pages);

There is a sz2ord() in cow.c and uffd-wp-mremap.c.

Maybe we can factor it into vm_util.h and use it here.

-- 
Wei Yang
Help you, Help me

