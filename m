Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3A9606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SF34kpsq
Received: by kanga.kvack.org (Postfix)
	id A92E36B05B1; Sun,  1 Nov 2026 22:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43276B05B2; Sun,  1 Nov 2026 22:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959806B05B4; Sun,  1 Nov 2026 22:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB9A6B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:52:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E78401A05DA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:52:24 +0000 (UTC)
X-FDA: 85388806608.05.BB1DE35
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8F3D91C000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:52:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SF34kpsq;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793591543;
	b=yGidtuZPB71cSdCV5rRsty9nn6tlhPRZGPd5FDcDBnPUeXO9VS9OEMc6O7p7w+C073MGs+
	9SgLA4k+nZU49+qItRkRdZZPUQaD8BRkJ3wEHiR4dE+eSfemBMPHGhryUwNHyOjyUziTAj
	3zaIsT5gbghWVmNqds5eH+XzDdqg+RM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793591543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsyOruPU/4uzHcmKvCXiECAPVPbvFO7B0tp+W3CdJrI=;
	b=TU7h+FGylvWXIQwQcKvpZgWHC4o9HmMCy6J7Mknd2FL4O3mO0wdEHmbXf2AFwPJEuB/04H
	oE3U3pGrV/oaFYjb9YP+wKfgFqMCj4r5p4eRTc7MyOaWP5FzBAh76u86fPfm+Uh8gcXL90
	xdahgNeCLnJjIvVQnQQOZ1um4bi/Otc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SF34kpsq;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793591538; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UsyOruPU/4uzHcmKvCXiECAPVPbvFO7B0tp+W3CdJrI=;
	b=SF34kpsqFCapt2O8POrsULF5YJ7kz8UOHk5px2N5WzM66i4FJOko1sPuMRMQZZVfqXJsWre5USbHeWyqCYQHhc3wGol2G6IOyW5cJPneg7ZG0LAdw/Nk25+ET1u6HTc1w0IYQS9uuaFOwrCnLD1XM/UkHekLLJ7u22Up1yCH+7U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=65;SR=0;TI=SMTPD_---0XDsjDyn_1793591534;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDsjDyn_1793591534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 11:52:15 +0800
Message-ID: <b684dbff-6f38-4d44-9709-1e9303e2158c@linux.alibaba.com>
Date: Mon, 2 Nov 2026 11:52:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/47] mm/shmem: make shmem_file() check the file's
 inode
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-3-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-3-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: byh6jt5g4twn4gozy9tkog59a1hq4z99
X-Rspamd-Queue-Id: 8F3D91C000A
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793591541-652205
X-HE-Meta: U2FsdGVkX19wjQH3s3o3rHDXe0Pc6T0pufpM+ignWS0lS/9FVniqS3toaMBn5aWLUMHIc46nt9SaL79YbwhKLKz3ms/cpz7kOmSbw8uVy4g/63p7nGU5YwydhEphRKHGXq+W8yMklKVTiQ51n+T8I2m3AmjTCWCwPHAAfWKgwAevjFli8yMQGikxucPOASoAmm5MfIhEogMRokQ3v+PAEmCU+hk3zJpP0CCIi7WEqA+D9hq46dbq0XaFgOje7ZNJWbtWZnrGu0ayWJw52wkSiR6T0iQOoDg0j+JrnOclqXn116WfWiU2yM2FF7sDVRQph9ckFsBFoIxhwCwg3F1Br7Odw3ezfO/TQtHw5BPHIP10yFOKYvj/D12QUvluBIL88XfaPpAFii/Togx144k8+Ml4j0NwZo4/8NaP71AyWn2YzwWEmFzxfAW/m36Z1fdSR4IKGXYZ5C/MFzX3HRzsZ8s0sGye40GErJhjC2saHMxTEh3ZfT+qAQXmdHZiBHGiWD1VmtBuHwZII1EqQRFCeKhFEGn13DwEeQNrK/Z3VnrOsWmwgcRJVyoJnP+D3XTB8liMysCmDVgQWFAF0WX0bJEKeN71l1BH4jDH76tN1ACxdNd0S3bmb2qRbza4A/ZSQisAtHG2+RSy9zp6pkIdeZk9SHGB+Bd53WgMtX8yaO3WQEIdbPImNNJMdEmsiM16uA+DQcboptD+kE2h3EW8q9Ocpt5AqvuI1ofPGq7W7mApuqc6AyI02fpHRsZ9Zp0q+WwqmFcU+ktaY/aDR04uLuEa53p1UmCu/YwCqBA4kxinVRlqAwhjnT8JAz1E0SpuU42F1FOnlmWHzfIXkXfE8nlkEQOmzOlpG6jmv/qWsgep7HVKQLa9BAvTBOAhQzoIg6GWkvJjP0HFBic2EAQXGUfa9cEhQ8ZCQTpjz+vBvszvGHDzwj0vGWyufR1RClF5ec4Pj6wHBhtr1ttxBX5
 mWWFbTpM
 +2l+3FO0Auz/XKGqltNA8xFYf9yh4ETrPxM67n8WTKfHGAK3MVOw6lUeMhRYCYFOVpspFIC1Rvzj8cHTyA9CagDMaHJi4T1n0HzHE+y39f0AnfDHjgD62qfPUs7wpxnQO+GsGV7yr2muYCm+QPMIIZIhE9NbxEKQ6jGTLCFLhL5wbnWTzpietU2/x99O02zE9naCBG9PbHEFdebOuUFf6Pd2tqzAbqQGwmQfyDhLtrc+BqcAUuyExxIkEPXLgWvuM+UdDbOusSXTkau1hHlig0oHyLy9xiY3zoxvWBJBd9qlnuj2DXiQwuj4B8Sg//8gocxe3kt80rpqTW08oEfg/Ec5ntdKUb8JFKe8Jr9JX2wPfyDHnZ+boNpG2xbVFX0Tw2yMfufGIA1oSvX69i31xhEyz+68pM+DXLxCPYXD1hj/805KBRoo9DI+T3ujn426YO/vDqzbUwo4T+q/MnpT96Snue7+pUg5xxz6a3ZqXjSmlmvFsPgfwpB7WCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> shmem_file() only checks if file->f_mapping is a shmem mapping. This
> mapping can belong to another file, however, as with a Coda file backed
> by a tmpfs container after mmap().
> 
> So it does not guarantee that the file inode is an actual shmem inode.
> 
> Seal handling and memfd preservation use this check before accessing
> shmem inode state, so they can access an inode of the wrong type.
> 
> Let's make shmem_file() check the inode's file operations instead, to
> identify shmem inodes reliably. This will identify regular shmem inodes,
> including memfds and ordinary tmpfs files, independently of wrapper file
> operations.
> 
> Use shmem_mapping() in collapse_file() instead to not change the behavior
> of collapse_file(): it operates on the page cache and uses mapping->host
> for shmem inode operations. Focusing on the file does not seem relevant.
> 
> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

