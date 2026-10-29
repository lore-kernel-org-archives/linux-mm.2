Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A644606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Gr+jRJjG
Received: by kanga.kvack.org (Postfix)
	id BB1FA6B05B4; Thu, 29 Oct 2026 18:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62A26B05B5; Thu, 29 Oct 2026 18:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CC26B05B6; Thu, 29 Oct 2026 18:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9826B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:37:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1B93A7C02
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
X-FDA: 85377126870.05.378A7A9
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 039D4100009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:37:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gr+jRJjG;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793313454;
	b=g1oBvuMdrb9v45DRGZuNZn4akTu030wNuC+wUOsQti1mZ1pBiLPwdjNY7se0XWXXOBf9UY
	5JzO6U25HqvtjM8HYBCVAi5tsG82Gnn5PkZMYff+xNbtAnQaD9e8dt45DCZPMsK8yPDG/v
	FiSMulf1rT390JZOXh+pPxMDaeGpL7k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gr+jRJjG;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793313454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsPG26s54J59UedVlJRCxJXndkzu8TR98XKtjA3+1AU=;
	b=TzhN5YFyo+jacXe8+7Jz6i46ExVOfw1+PZsM14vuc3FxS5GFRPS2mODiRzArWNFEXVyiZm
	eNsofo/DQVguIYn8RNTdNKnVcNnUKY/jYCStQhAKX7VTKjStXilJJz1VVrjEr/l6ruVihA
	xfqCrm0g1usWjVVRsrIR6DXFnzRDqKQ=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91b9e758c50so1457896d6.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793313453; x=1793918253; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QsPG26s54J59UedVlJRCxJXndkzu8TR98XKtjA3+1AU=;
        b=Gr+jRJjGKUnGmSFkOogiukvOUnT2xzMPew4o2jcGeoA/rONO58SWMfdagZ/08z6VCh
         kHMG6Zg6tcCgMXv9tFvEQJSXyFsXOdcRppZEKP87kc+/8O43eM0ecAEsYq3KHMwKwZu4
         pH/fLgNIuy0mzoXzOBMq0OKRQ0t3VN+LOpxfmdiRLdVWlokiVrUpmbIbjtGAB06Q2cGn
         rPfUwgnGb4Gh4/tjJYrGwwRhrLx/wxv4iv+DBd+PpWKRzyqMA8rN1Zo1S5NxMYuIRfW4
         dEfAt47uHR1caitv8aqOeyg8m/8ycPsfCM7GothDzTaLPUptG1ujItpSin8mKxif0gXo
         RPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793313453; x=1793918253;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QsPG26s54J59UedVlJRCxJXndkzu8TR98XKtjA3+1AU=;
        b=jr5yFZlej/wYrakeSu1ZDMPXU7GGPZcVKPnuuFdmZ9izgAiSWsREjZ4eKpK4Rd85e5
         QL6RwwC5+ohaG3ffbgWIxf4jKGoumi2+lUhmymT+g0xtthIvKTD55JaR2Sr23nkx3P7U
         WZNoE23uyc3bE+BALOIff66D4MLG5YN1CtVra/S/GzgDY2CTjRbdOfMcITGgWkgAqN8O
         +7XxCcPuxBY/hbUihr/Xe8dj/qSH2d+rGVH1sXGwr4WUc3q/3X4f6nkPjjN2tkNS8537
         2Bmh/y8NhE6Dni5bHb+k3XkoOLqerH2hrsF7wK2OeWG851uHyW/W7MN4maVnvHO+32w+
         qKnA==
X-Forwarded-Encrypted: i=1; AKwUvBwIEDwbdl20KTaLwDnFyKLPHlVCF3RnSaePbIVB2eapLEFwS3SaTzOULwGsfbwst1lTjnnJKibFWA==@kvack.org
X-Gm-Message-State: AFq9FYIOeWVTe+7iMor8WMZmj3cSxTxHIVCTakH6z78hvsdfHAfXTN1/
	3lT1TavhD37tSgTTXw3LgO57JAc8Z8TtjyQNg7ZlpPa6KP88QH2Ns89eTeY7xS1pIng=
X-Gm-Gg: AYBFou1i3+KKcfHyupfn6ZqMFSmJVSfken8sTI/uQj/60uK4IRrFHw8ndYllmajPq8c
	gsIsnxy/y0mzfhhrCujGN8UEPPU0oNG02gOK77zgz4K87zZafTKWJOz7XNSeCnrAPaL+FUDY1RO
	wnh8UG8lQdjmb3OaLNq4NlACha40936bVInAB136xwAXw2Xc8QotLGvKcPLlw26Xwxp3FvnwHus
	Vka17pL+MjwPttXcFQmMD4/L6NncA/zmXgSWRAfj8qQVrC9S/TbSfbUb3TMdBvO1mlaE502ot7C
	/9GNk7nYWdX137oz9NO0PkXE6RiVfvRDCFrfuE/L7SEJFuHyrEuwlptSvZmxFjnBuqDiwCnz/nb
	7v/LLz+J4/eFqsrUOM/I4vdj/ubQoQXuUKEEpHWkSGw9wYw+B6mQ6VsPuZEjWXUkNJuyM7uO29M
	RACxMndG0WgLiVL3LKzQSkro0g36Z7gb+axnLW3OJII0E7N68vZnHAVfNZKZfZvtQpKX1Qu5Hek
	jpx6PBEXc7auXzsHG8APrMnTQgAgv8ab8v4xXULOEyGqGtwXDudDajwXnHjd3ponax5c+qiUBBn
	HNbQy5aXZrKiG1FNSJht+IHFPLDV1PQvAGEAZxD15Yydx9mc41U9blB5lTuQmMs9lQCt2aFROtj
	8ge/d8GkxLjsouIaOvGVm/g==
X-Received: by 2002:a05:6214:401e:b0:917:c073:1b98 with SMTP id 6a1803df08f44-91c90686fc8mr65881526d6.15.1793313453118;
        Thu, 29 Oct 2026 15:37:33 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca6855ea1sm646896d6.8.2026.10.29.15.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:37:32 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 13/47] mm/huge_memory: fix truncate racing with PMD
 zapping
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261029-fixes_core-v2-13-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <20261029-fixes_core-v2-13-a64ce7f83abb@kernel.org>
Date: Thu, 29 Oct 2026 18:37:31 -0400
Message-Id: <179331345102.2127828.8211829708894165734.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 039D4100009
X-Stat-Signature: mgie8rcy1z7w9r7p5jwj89nj3ja3a78g
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793313453-523947
X-HE-Meta: U2FsdGVkX18Yhli4OzZquTKhm3HmQEk6wjuWrVdO+pLaiqmgBluJFkx9BaeteJew+TwfSDwNo9HbR9EgSJGiNry0BMDx2ffbwR6qqbk2eRK2a7bYIiENfw3gE8iu4ojIDvZaAcYSfPI1auyryNNnp2a5Z/2r5MxKEESV26ssv0LE9MeMKjsu8geI5Qang6q7Vu8/9Zb4aIv7l7PsNt1vEZqZmXLNWcldqiPmFJRH5ix6x3YjmGoELGpkhtncY7y//elKT1rdMckzV3y22Cw/9YrauGP2ArHr6Ge5HWGpRnr+n/knfvuKWOxlUAu4YN9vjuXX/ajnIeMuABcQAyiQshZI8L/dNsqRVZy6++LCkRFIq1Dwtq5aFOVRucK/dzVOiP1Xp2Mbt+SphjFZTVuGWHiP+iCu1wpnOHAyT01kRfYKDaQ/4dBdtMiidA6jlW+0GetmPdUWVq1CI8cydvYkjoIlQschkEhmke2AvS4og5ueWrXHxZyIqav1HyvatEE/rIy4pbJ2TE0YicBmn5ZERSBQNzP0oHjmiyy5kdssnhQhmVWRDsO1FwcDvWkTJHlXpO1qiRwdUSfoR+ZquwnGUlH/7vv56EiVliGSMOyQEaarUukpUe5S4SjniSH5oItJSumruGy909wowP64JrW1EPaxJ68a2052GGMntwppIf4ANlauFJaLqh3ubjuvspmWxMN0SL8QWeA5q5ZFsgjrEZav+Y4HhRQK3pFUzrRgcYDVia4CQsRpOKHCiuIjmOu/L4cKDZNXOKhDWR+C9cOzDmRtXHsbwCDiAmaA+Egn2/dAk8NgZPhxhfI7qI7dYGzbYFiumrdfcdoBN3EUj39vvIEKnfGFH72A8AJ3gdnscnoBoXXieESTYRHZ65sze6s9pJVU+n8nVKP7579QdsOwbs9afvaBNiX6JDnS//XUTscFU6ch77FHomQIfpBO29o7ZsM9pRYRe81yHdf8I71
 M+RL4nY9
 ZY7IdS0NSblGnLLiiRR9L+QGyxQCfFrpnZVuBJJBao9nmJCpF+3JmoSLktrG+IwtvbMoZuwox8ysAf8yLhiN8PekgvH5J3+IExiq6NYq0uTqHoCbY3HfXSmYPFOlAwzwamGg+AcCAO7FaOK5By7D4TKNx1IJCTpnAH+ZveWtKfkkPBSCFLhd2vOyLDGyqOVl8kii1S44De19Lc9pDtW32Hh/MzMj8ZL35iO48BvpNs9GreyWFs6WriVrmulez6+Uz0iEPEfqmNQfV1V5rztl4lvJr1Ylf+rX/2uo3mJ3/Sv1M/vU+eBPet/6fuoYyi/TAt8VKkHMlh5LPjTtav5xPA287WiaDa4jdyOyhliSsx/a7wLdONNhAWtmaRHqcpmUNdg/btX1Hpr6nrfJi2bTK5ytvjPlfDRt76msp20GI7eegfaH/WKkVKX6FwYuckTmj5Z7y5jH3Jo3dS1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 21:33 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
> If this was the last mapping, truncation can skip unmapping the folio
> and proceed without waiting for the PMD lock, racing with dirtying.
> 
> ifs_set_range_dirty() can oops if MADV_DONTNEED races with
> ftruncate() on XFS, when we get the folio set dirty after it was found
> to not be mapped anymore.
> 
> Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
> matching the PTE zap path. This keeps the folio mapped while updating
> its state, so truncation must wait for the page table lock.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

didn't have time to run tests, but this looks trivially correct.

Might be some backport ordering issues between this and commit 14.
Hard to say, didn't look into the history too deeply.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


