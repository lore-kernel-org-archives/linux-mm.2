Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27D4606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=KcoqcTWv
Received: by kanga.kvack.org (Postfix)
	id 1CE4A6B05B4; Wed, 28 Oct 2026 21:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E1C6B05B5; Wed, 28 Oct 2026 21:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D326B05B6; Wed, 28 Oct 2026 21:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3D9B6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:27:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77C7A402DE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:27:25 +0000 (UTC)
X-FDA: 85373926050.11.D232844
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 980C214000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:27:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KcoqcTWv;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793237243;
	b=xOwNLmWuAfZt2iovlswuGt/hUud86fS2NZqcBkudkjBuNY7jAKnubkuuj7hwGujZGQ8n32
	Xe/qC8jf7nCNQbnubazi4hjaDSMwHQCOMTZBI/XnuCIHTZrHZbQ8VELbH54chZM6VK73Xq
	MzMO7UJxqA6Fs+KWNJ4c3qNcMqLu8vs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KcoqcTWv;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793237243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDgUtS6BmV52eDuX4xnh+bC+kNpwLNlhCSGJQEIkHH8=;
	b=r12ZlXZbqUwV0QJy0J2lPYIExgaeiV5WWWL22E9+k3wkJifGrzX/HURZD5k8hG0rOuTFRi
	xbXu7zIvBo1Z8vbM4qkqQhi6j+GyNPDL+GXDtFh0wzoLSECHLgN5T3LMRagaRw5bhsA8+t
	4+GtjRlInQHpgWQRF0s8rLl7AeZrwOE=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c40f29667e6so198022666b.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793237242; x=1793842042; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CDgUtS6BmV52eDuX4xnh+bC+kNpwLNlhCSGJQEIkHH8=;
        b=KcoqcTWvAfFpWiegfKk5NOchhe8eHK3fVEp0qKk0VHDmGKO8P0c/NcPLtNOEoA2oCA
         FAIuTyzwch/13hWvf+74HcoNABoNQrqQEZjGaUSfwalTtQLA1iYjewCIfijofXByKBNr
         JdZrGcmth05uQT5mBWy9ypxtpoQYg2E34BwGLyvKAxNLapfhWz41X2778d0uBDzHgQhy
         UxFZSrJyKkY64F1X7i3ZuGArE7UB59S2sR7ZrmwmsgLqp/tpKcx+ILwAj0KAd35cX1tN
         xQg2hiLT8e2Z7Pk2w+FflT6Uwd5FsQl+TEXaQvmtoADqgoruddq2BRritrmCynB7jMCq
         yO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793237242; x=1793842042;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CDgUtS6BmV52eDuX4xnh+bC+kNpwLNlhCSGJQEIkHH8=;
        b=J3gmAgWZv9vVaEokcc0fHPdS1H/hH4cXBTHQh4uweXxgs6lI1K0i8SUdBsT74nlp4x
         zSqdkAErRJRmQ6dXirtSu6gc3kGUfcDKIcHsHIGjT62XF3FQ1ivA6eLA6FyHuy8ef/uQ
         yIQ06f7PKrh6GmqqEgiWjI0rgvPdag8Dsb1MZVklJ5ORsucIU4tv+fbzQN5d4V6VfhhP
         lRjW0JbIBmWgtKuqXPPhBwz9is/YkcLwcwTCZjboVEtasWm5iyrX+SmXLVJ7AU3gTfN6
         mv9ZZPR4QQ2ww7a/7hvfcz2nXN5i3CCaKqTepCjlr4wr10J9CUTTTEYUTvdRlpxSQ86a
         ppuA==
X-Forwarded-Encrypted: i=1; AKwUvBx3Bw4qyHmkumqaPwcLPmFDMAjMObUQJeOSC0RCcf7erIb8ez5VBOgbWDu+rE0L497JfQiU8CyjWQ==@kvack.org
X-Gm-Message-State: AFq9FYIcBPuhmWrEsJIURG06BcUcugKkSklB1uE7BCZTmtdXn9pQK/pK
	6TDu1MqSiug7GXsN7/4wrO2LFtHFOMFeIepopJ9AKYIuOWpxUSgM5EtWRk3lq5V2SMI=
X-Gm-Gg: AYBFou2yyKQTjIdEfVDiL8OzSvi8/LD0wH2VKdwU/MuUqQLtxTtKFAuAR15JB+P/DeL
	lawJpEbFg/B+wOJobfPzhXH2hX++cd9WRBIopB2HmFbiatTIkaGahh349q+4/daBfyAjWBjI1VB
	lBj5NTAaNYIz+goPeVzuAtB2MRFC8wkfimHZXHZybQ/1swmC/N1J5WRdiZyPZ+fbF/c/4rpcQKM
	YPnj/uJIXz7npnQia+AJ7w+JH02bUVkg+i6O0s6N9aoBbB+IpGXUkq/jr7WNTIneie1jix3qJ8q
	cQMT4h3kpjyuJy5qpk7AZJ+/3IINnWqd6a6+NgD4rYPZVbNio4Xmwh7lpL6NB7nS7DDO+joLhYL
	4Q2Kfd811Jtxe3FdcC2wbCV9D7q1tX5cnx+2RmMvFzau02ba7OkLN8iUErQMwHAcIvtEuNPQcQQ
	CdzLFEOpXzohJuJIQSXvw2U3N6u5XMiUCE8Wdrcj0InC8CAKprYcsGqAiTjixdePsqP4eiJE+qr
	CNVOYKOxh8CUiWg83E6ijf7NTm8rVWJxmN3aao8+XfiiAOLpasBE/ezdkJEuIP/7tVvT1MbbIUJ
	G4Yoy+yyGNJRAuyx5tEM
X-Received: by 2002:a17:907:97d5:b0:c29:c079:676d with SMTP id a640c23a62f3a-c49bdd744a5mr330020866b.3.1793237242153;
        Wed, 28 Oct 2026 18:27:22 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:70::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4964488e8sm2081290a12.31.2026.10.28.18.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:27:20 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 17/46] mm/khugepaged: preserve dirty bits when
 collapsing PTE-mapped THPs
From: Gregory Price <gourry@gourry.net>
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
In-Reply-To: <20261027-fixes_core-v1-17-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-17-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 18:27:18 -0700
Message-Id: <179323723859.453251.1630776487784216917.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: cfjzr9hnb9q1kurt9mcwhih76i75idti
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 980C214000A
X-Rspam-User: 
X-HE-Tag: 1793237243-284626
X-HE-Meta: U2FsdGVkX1/dPLF4l6V6gQDMpQJ1yDFfaAE7Yu0vDypTnVnZa3RPVB8bQ7ZWQktlPzFy5r78NzYm0mRI9P04mM7ABGdGhEGW+uxHoU1JpAeTK+l2N/C3ZhZdcV+IPeTwdWBcmQruqR6LvZYxXnWLzrH7FTKIz+NMZn6k0YGlPTF8y5wc4UcK8uh441/ynsNB5dkUeJf9Hpw5RgAksVawaMcOjllkFo6rRw7BvuhcTTcAiyVT9hDbbz3OiGS0utU2ut/xawJPZndwxvfwQzb7crNjGMMAIwrdCrdiHL5O5VL7dOYIdifZJEXwAJOi3YTs4qYhUIZnRHoBQxFis3tVNg2/yqc+m30Up+zTJVI1D9/5GL2dXGOtgFEGDfACkr+NzyXjydTeZKkrvPuTBfiQI8Ck57zl+q6WeYjlKOp30pONqja/VIIWe46S8wGKTT/lyC4TAc1sIbqUbUQfKgRjzXefQQbNnXZiJ3eNfWZ8OAjPmB8MblBsNG+TaBu+L5RtvIJVDX0w3GhYgnaCERdiQ+xujATtOg8WLLSq/XBRxcuyptdgKkNBWxkndOZwhEoMyeUCMtxMmXi0Bq4Xx0Q2R8yQudip8viXzRp+sXgGNPFovtyB2LJWVXMCb1UunVK6V9Ohx42gCmq4pOAL6y8VVZtnEKDV0c5AOXQ7c1Vvy7utHl5vT6YONKhRJ7oQdnH22lsA0J0WxENwxrl2Y9dDdCBu2NiZOHqbxHqotDO+X3xQet6q8N3OY6cidGq9JphD1yMcPkO49pjUzjuTBYo0aYNyoe4AlwEXv6tGe3LhHjZy09ujfrsB7z+jTPn4rybhU3m/0AEYz56qW8jj7LuQqGRR+lCS56cmdlWx8O0kHv2LHjY2bqV1qQavA7j9nWqtK5GQ8yGwGknWIMF2PX87LuKP4+nTaJscEMcOTn59rNtF1wMNvlVNTbmv6l+kq9hZFm3J9lLLhrT3J6sDjdL
 t1Z3s1fg
 hHtNQCIoao2shkTHhf2oHH7WTEijYzzmYd0JZ2cL0AKnzY4jT859FmeG3CY3HiSjmT8gr0OcZGPO35mFtVwcJEnvZvWvaOx/RP7B2Eg2fDN4uvhDAzXJnAncSpaPfuZE9+acpE1h4QDQLvSFZPxvHiT7LllBSyzZ7AiEGYZPqD8rOwiV8fbSNo8AZ2t1fEHu/Pm8dn9IrjAjoygVXLnuybd/q0EA0InCAdH3BaWlzzo2P3ouwerbVSwzoqnKObDziiGJf5V73T7qr19iZxymI64B6ZH9GxJB2rj+wSULYOkp6w0Q/DV/KpqrHRmojN5ewFBOIJQrUNkj7f2wXCVaqSlIrxhhz6XKq2M9H1eFvNsW1ZcOQHSK/Baw/+mWw2d8S2l7QbkveUyCAjg28HI/ul4azkLalcUWmy+ibJXxBwVBzKLEHfXp75LXk/bGF29lCJtEkPgtbdNS8Bab2y+ztTIplYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
> bits to the folio. A shmem read fault can map a clean folio writable, so
> a later store only dirties the PTE. Losing that dirty bit allows reclaim
> to discard modified data.
> 
> The assumption that regular files are read-only is also obsolete since
> commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
> for writable files"). In any case, transferring PTE dirty bits to the folio
> when removing mappings (and while the folio is still mapped) is the right
> thing to do.
> 
> Use get_and_clear_ptes() to collect the dirty bits and mark the folio
> dirty before unmapping it. Update the comment.
> 
> This was reproduced with shmem using MADV_COLLAPSE followed by
> MADV_PAGEOUT.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
> Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust comment; simplify description; cover file-thp as well ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

