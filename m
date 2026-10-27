Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC53606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HzatrJB9
Received: by kanga.kvack.org (Postfix)
	id 5F9206B068A; Tue, 27 Oct 2026 06:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9936B068B; Tue, 27 Oct 2026 06:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498CA6B068C; Tue, 27 Oct 2026 06:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 161746B068A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:23:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E7BB140986
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:23:11 +0000 (UTC)
X-FDA: 85368018582.06.0EE346A
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 969C8120005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:23:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HzatrJB9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793096589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuWBfUhRw2eXbrJVRrdIsgOVF/qwEOWqwz0sZ/JDeUA=;
	b=SBikJzCFEOHRW5+lySkYaNKCgyHrsbXhuKzu6c/3+F3fQ/utiBx4crmhcuYbKCls+0o/IF
	6FIIy6jvTGRn8qw3AlYERu1KBt/XHO9bu8KoDC6eBT/MiuMgZs9/WssqctuxysHhkIsf0D
	hzhbBPED8uDcwxCBgokCOiT0bRPmO/M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HzatrJB9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793096589;
	b=76DSJt/ioiE8lbAkpMTX8x+18f1wnispHlrBwSd6TIru/IYtNDh46N3y6VVuIigopcMFcc
	YZewNpSAZzfPrd2MQ61proEUYDQxiEt7EsuVlX9wymT5XFYPn51hFlDAi+OZNC8qQs1l1X
	UcP2bi7/yP22vLKl9+9XZhovN5JqthU=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4322d310e7so585452866b.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:23:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793096588; cv=none;
        d=google.com; s=arc-20260327;
        b=YYYzDrRBVTGg9WBoGhpgB6P9Ovr7j4rL4Sz84iYxc7rjFFQYATgsgxqC5nbh7H9Rag
         J8T6jLwD3x5jtvNvKAUTAUNeTwO9L801ZMW7aNpW/VpaEc+M+aVaCWC3Ufy2uuTH3+YE
         dtUs9m202f5fSkvuzCznEBBG3RvqkaFlSvKy9zjT7M3X5PI1sCRSmXQ+/IrIPjUXWWFa
         fH0sVNTX785jgT6b0W6biymRoUk/az4hrg28DesvKV4+XLu4emlOM1Gc6diHX/UimOx7
         EFVZPQlLaRlJEipI7vErPu1IU+ImaraVQP42L12p8tK7jVxcSgiZyeuzj/9FXu/terdB
         EKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HuWBfUhRw2eXbrJVRrdIsgOVF/qwEOWqwz0sZ/JDeUA=;
        fh=VgOtQnQrEijEJlKmCSpoIfwei5kKNZ7gfIf7dUsvsMs=;
        b=E0nPX/VqoiuTfPWM7G3kGY8M0aTB+Z13mU9QKDg4paLrbby2vjrAgv74197Kiwy6i6
         CuAKzf9CNjqXnhcdlvWLnPpyRqtsA3r0o06qVAZCJVfNeAo0ZIdlxdVNN+0dawigF8X6
         J4FiCnnHtmiwIMLr+kmLrTGwE4GejQIuh1PjvDEG9nPuU0GF/u1jocHUnCPASI/yWtxP
         ELKb2zytGmX54y8cn3JaWfmIqyPW6vGT/A+EDyL6i9yAMV470hZkEYoaTpoy3bLQaMgk
         hFK+mjzlrLSGesEGJbUUtzHfJElAS7oNgHEhTMzHhojgAx3sS6hmsIEPrbERe9RRQ9dh
         HI+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793096588; x=1793701388; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HuWBfUhRw2eXbrJVRrdIsgOVF/qwEOWqwz0sZ/JDeUA=;
        b=HzatrJB9VwWeFSuRzL1KY0SCE95u2U46Kjp8yzOLK28Ex1b2s670lP4hPjxW7KR40h
         ZtXZUQAZ0v6jaFzA4daRiLy9Rg9RQEDBpjdUHUJlyIM/kfc47oaxCURjVREQBNsR7e4J
         hyV2PbsSa9B6Mv8PjQyjQ0bE7i5XtSfveNg680jPXyWC9q7r7+knpY7a/FFUgIprOis6
         q9dsyUgVFUE/RqUfvxfjwdf2oe3nph1zsiNx7v9W1RtCij8LmaIA1zI8iHkR0TKcqjyC
         X2JkGeylP5qgQqzo0m9nIca28NW0ttBK4ej7YockbG2WB0xvW1xQKMaReahWU/eBHTh5
         cxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096588; x=1793701388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HuWBfUhRw2eXbrJVRrdIsgOVF/qwEOWqwz0sZ/JDeUA=;
        b=WryDzt+4uHylPzIcBvtMAA3IZsAExJRPlxYiFq+KXzFIV6GSIGPdGOaJ3Wjgr+4heq
         96siSc/NKrdt4si2uKeYJoRaV9w+qGJFIDylC/yz2YxXjrxzzVboqFyKuRBpELB/+yIu
         gSv4YItXPHSuDS7nZJZSrkMoDx5i7KpOPcLf8mheuCNoKPCvFvVQGYjMKyqUfydScDDY
         wFQ4nQqMjeo8AR5Mb/IfKuDR5VSDRvmYoRh7cJVptero0J44fuXHICpC4eV1gepElXAB
         OJzCU2hadTCyD2iPcU1XIKSFKpBKnjUPcYdz5b1sXSObTTtOx6mrlKPM8kqeYzC3tZ8w
         fLxQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2ySPSf+phmRR9zKgcmcMHWTsZeKniE+VY1ZYvFyu56Xzqbjvh4wnl4VQwdxdIrB1MBgA2I8u49A==@kvack.org
X-Gm-Message-State: AFq9FYLZg7fWKjiCYR2WxqNOhIEc7wkH7nMsv49qdHhx2fmkaM1YW21X
	HRi3vdR2F/fT9E4tr61JsqfpiW+4PVTKbQydo1BlCBqcQFxCNH4gtEdIpcAg1+j8CrvddLk14Kk
	DxKo80I76FBqz+jAnKF+He8yVMWCDMI0=
X-Gm-Gg: AYBFou1JatelZ2hmjBNMoKvzTWfgSqooh91duX6d26lKeqhJCXyPil5pNcUPMyofGQi
	1UXxBXvy/nYksvrtGwDyBJhz3KoWpkYUK5fECOPvEIxhf381FaYGXF5fm3d2MAWihR0XukEDSv7
	XUUR9EeQOKqsL0u3kHb3ou6TZ2abEmwyKmO/2Vo0zP2TX2Z/LjjMZ+Ed4bq7Pu7frvD0vGO/Xdk
	j/mF4sbFmRayjYsDkUDo/3HSsoFhd5izLnll7W3Q/sA1dHlwsAR75y3LN6Yz96tAgTUuxPJexB9
	dA9v4AMhsaKRtBDVVzonXeYDjZKg6OtbLwwVr98+yFFat5LH+Z6KPkSR1gzv/KSz3LWw1tCTJJG
	sSqMhepcv5z65th/05KhD1pK2ZTVhWWGASGXpw4CjgyJzpFRXgNjghDoVmj/D0FuRerm9wg==
X-Received: by 2002:a17:907:86a3:b0:c31:5bb8:4b3b with SMTP id
 a640c23a62f3a-c46bdaf85e3mr1028439166b.2.1793096587718; Tue, 27 Oct 2026
 03:23:07 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org> <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 27 Oct 2026 18:22:29 +0800
X-Gm-Features: AclHuK-sc-Sst_xgCP0rWexz2ICrmdMlmxE50eDjh8zWXXtcyxqz8s5Avp5yS-o
Message-ID: <CAMgjq7CgeA5OYUuXAQF-PQ_LkmsLw2V3VzRwPUdMYTcGCmYCbA@mail.gmail.com>
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 969C8120005
X-Stat-Signature: 6xguj1hsnfhgxpmxpn3ah3k9s8cbopo7
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793096589-379388
X-HE-Meta: U2FsdGVkX1/0VHsCW4CRCYw1uleHk7wbxTEg24Lcvr6GMLhGHa809hxoVK0oXhYeDD/6gRCmvKSZSXnh8TDqHga+hPfdtVHH4YMn1MAlVeBR5eokksa5XpHhOgZBNBJie+SBOnd8f18WHii6VflWH3tdFWaWIqv8heuToTkz+0b3kL2JqkTVcA/hUbE/Mcml29q+x+gt55+4KyWWNGEBwsMKNTO83oQ4v/xNGGIbwJnFsuvhCeCJnBglqowk8l+3nEnhLk6uLXD84oNVIcDRT3G3xJkVVCeOZDWo+iWNTwWEXtU/JzVVcloHWV3gY2p3odm3nkHS0zkEzMSsFd8EuIVFH2upqzTbwNAzjlbcM+gjYipGoTDo6LcnCqKo4NATcEEcnYtlViwRchH9Tgj3HGiCLZ+TDAngRWafGwqB6o/jK8S9yc6G0OsuKPs3NFsLuwUIGUfvAz7VDXnbN+uOH/wDZmrXKmL81n8V+Tw9smn9yJOT+/bRieqgQgYfd0OoQt4CgWts92IoEZcnv9vda9WKqnNFXZ2jBI57siUtDzHiB4hfLFfPJP2fGKoDOBtk1BXErRuhVEjiyMVkRzY1OKeKwRPc9KnZdgJ0xRQX8wgsLwO1yQzy4cmVzjOceXcKGISfXmYwDgTCLvDVy22eIcCLsn5z/4Q+uMgcgFK2G0FAGqnTb8oL+53AQskWfiDoGIuACmKSBXLGj9F+94YHk5RES2gLSwXXO8kyjagwfoZvi2DFCWlmSKA4af6UWvoEok7ViP0kqRiKLhKMLPRJ3kWM8gEy8p3TP4sVUkLrQdCRvCv129x9RacJU1PcgEybl/cEWBqEGabhnqyW7MosSWkMNWIHZnuj1Ozt6prTtsTGK/9ah8OkpxjBHz3lqs6phZi6U7wv0TKh5GoLfFIgthSBtIBoCOrz2XoxXe/KhF5QO+U2cxrgS8+5Nq5a/OyGY/NlOSfJA9Wn2NL8VUg
 6zO/tcfk
 codzDoNxl9moo8UcO0l1TWLWoIMQ1hJYq2mx4ujcoH0O7npKF87MnAvyVxbF6WfZjQv8h0ZZ6tusftQ/r+iV/beKigMkHY+Q1fny7ghjgLvYGxcC5dJPky1s4Nfyfncsmz4KGhGvxcMDYDd7OwaQ6C7ORYeDAyLPb/dZBO3Oito4nvwIcIIyq3OVWUskqjeXC9PiwiA6iMSt5QCLX6JCQEKUA2FXBdZNoT8k5gAybU+1SR/zWdsldMRWWs+ffUCXES9sjGG5tG9gseoKG26tWODM0uJd0gFsNKJPEaxPxCGxeSeuMMUTTmcDWAeZg7Aby6uQ46CPIdBLW5WVvEnfe80IBsxn79+TRInd7+pF+btE4kaDAdGUFKbFbH5i+p3kfpbCUJi84JdHSX8reHN54aGKF3ves/6WRXBN99VR7HKpG0tvJes5WJFKYGC0NHmxLkeEvmp+aYkJuWLmW/VWMks7MtubxpP4aP2UiQYIguX9Dr+fOvnJnYuTsbwM5fkinslCgPCOhnqDWlHF3aEB2RaLnUVsS5SVY2gnreHAXazIshR6VDmDkDa0dNL1jdS5s8D/8hbi/XW7CNUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:18=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
>
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
>
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the P=
UD
> handling is required as well to handle folded page tables correctly in al=
l
> cases.
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Reviewed-by: Kairui Song <kasong@tencent.com>

