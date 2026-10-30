Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF77606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zc8ZNVO6
Received: by kanga.kvack.org (Postfix)
	id DAB336B05B2; Fri, 30 Oct 2026 10:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C386B05B3; Fri, 30 Oct 2026 10:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22DB6B05B4; Fri, 30 Oct 2026 10:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 943D46B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:35:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B842A7DF9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:35:55 +0000 (UTC)
X-FDA: 85379541870.19.0FEE0ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E5922000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:35:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zc8ZNVO6;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793370953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6XXbQ+HdgQmOTZa0aEBan+zjL/ycrb6TKGl8S7Q83w=;
	b=7AM/bQNhhDl1M9PBOYIfOBhKu24lMIKBYdoRNGsPS7C9+0asm6fTtngMsbt689bCbVNg4O
	/gE7dU7JHCm7vqyft+OeVfaQwuExaRDs3yBaVY+scE5K1jG9qENHg1ipSD7AfjkUEsovgN
	q0tqHkDH6QbpDxNv3rzrZ6511XGTyhE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zc8ZNVO6;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793370953;
	b=tKsyE7hMuo46ZC8RXh38Jc4aTyD1vr6RxQQCSC8nFOugeze1L31YDCN9cKhjG17STlhZUe
	T/aTFh5hj8A85RunAeAv7gyJXSxQvlx8rzJEYq3em2EDuH+244lj7XoCEQOG925g4lQSQp
	Ks40FYbrOnUSCUtnbK+WyMYORGgzdWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65EC4419C1;
	Fri, 30 Oct 2026 14:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697CF1F0093A;
	Fri, 30 Oct 2026 14:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793370952;
	bh=y6XXbQ+HdgQmOTZa0aEBan+zjL/ycrb6TKGl8S7Q83w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zc8ZNVO6uRM/ebf2tyuqkNg2F+fe5LIUT6QCAumzzPpOuGmyXnfnNO5s9RSYLm2rE
	 jwJf7qLnqMB1Nf2QO0gP2HzziZZK6letMz6x4Z1QebhXjhx6Lp5o3hUiQQDX2zhFLu
	 5wWBHnZAqJxpm4krMusfEm0ziwpBACmY2PLnP7EQIV+ROXKrDC2x0Z413kzf7TnVRa
	 1IzLYX7Ri/ykqtCagS6CsHGxfJq/AfR5jwjpZPHtLQClzkqVrG8JQ9OGKa/yrF53ml
	 FKD/f6zB3W/UEBSdx5AyFtTg6EeOre5o75pbwDLQQv3rT/OAi7RJN7FszZ+57tVf4M
	 radtUUXIQvVSg==
Message-ID: <43994c77-bde2-47cc-b6bd-5b479672bad2@kernel.org>
Date: Fri, 30 Oct 2026 15:35:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/47] mm/memfd: check for real shmem inodes before
 accessing shmem state
To: Pratyush Yadav <pratyush@kernel.org>
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
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <20261029-fixes_core-v2-3-a64ce7f83abb@kernel.org>
 <2vxzmrrvmnil.fsf@kernel.org>
 <297adf4c-1792-4dff-a7c8-2694dc2b1446@kernel.org>
 <2vxzik2jmkw1.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2vxzik2jmkw1.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E5922000B
X-Stat-Signature: 7dcuqnanbc8coessgmdngzry4pb8hbe5
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793370953-564
X-HE-Meta: U2FsdGVkX1/ItwECZYyq6y+l7vBQ3oEhK3gnudO0tETQ3jeHi4UgCCCSKRVPSpi1dAaq6bb7V+vttLsTBtxL1XEsiOgahm5oPOMEfbUbt5dZZ7gU3Fb8Gn5QgEMcqh3gAktE7TGXuLzN5cXe88nIewyDGMw5yu6SrNmD+051uBzWoRriIzKlo1tgfyxYwWYVrDd1C6i1ZTco8yb3vCaHkxPEvYpAkaxl0I7RimtITptav3erC3V6B5l4BDpaLOOrvXg78whqQnvMwtqX+v6L5+ji3kfqp/UMN8Cy8SH2mgWAYkM8qjcyBgKxvT+ksGJokCN/vvPZoY7dUJkAb7xiJ5wF9TSS4pJlAWgGUFvQrZFSvPCqk0/xhKTefZBuwXrZQaC4jFqhe//sYoYRlXnv0h9c9+sMba6mcKAMiQLnYJdT3e5SxtNXztXg+Cwl/tI0a1nDWvT8oe2kuSv6X74kDrF2343h2LPoH4mrnbX3WKVf4U/Mj1pz8F1tM/iK5G6CyT6VnbCotgU15KYq3opZiKgQWlYSWB3vzf1GaPXlZ9XgpRMyvlRoZcSk3TK0gxJ27DE/nkgMhVOHcfkOGr4sNSwQN+C3WAC3TBRAwvnFsorlgo11R+Xc46xuWt73QDShATVvT5pjuSxrFePMuUbmiPWYkDSdvsPVHRL0VC+yF35jMer8OlYC69SCUTEQtXwxxJn8cJ9NobCooeFrYya7rj6y5C5UbkISNVwtMZjSEeAFdSwvdvdrbTiSMIj9lhGRGUZCo+qJqL1G+beR/jUd1YdjSsKX1tNkw61fenYfplZdSJYgQNQamGTEbMPOhWfAVdcufjWliYjEf/5c3dwmgVQ2ceS2Otlp3bCR04vUcRz+jeFyUOB4MAR6ce/68Ax2OprBRFb5wurysbLDOnfsEi8dcBOs95rzvOGIn2oFyS7TUp597mO04cGfeKO9WEhhAgYOvwu//B5n6JCLiV/
 eWrBpuBH
 +WG47xFcvrbVCLKjSWQi0O9Xo2Iy1DmlJySOpJFHTD5d5zr9Uc4IuidHKttCSQ0S64oQ2bJNLsZ9wdTkypB0ZT2L43DPMyVPxmCyh5V8mZYzbC63jYafAFgHc8hQg5Hr91EoJCOcBoHEfkfzHSlUtc+6I+uFfPCCpHYUQ1DNQzRb6YpKu4VN2rYrlAO0UFGwuce6Gvo7SlBnDoUb4QXJSargetbycXBuyulp/dAPPWvt/JU2NubnB9cOhEoKvsUUK/gJMvnyxOnjCQEiRcODdlkdBZq5e3Wxc3knh5nC/X1zpHIo8oGJgha4ArTNvGC2Tqaj2mbcj2xspVEGvqSjZR0MLYO9dJtAGBYD6p6wAyOqEC3mX6o9Sv6yG357h/xjy3L+2moL0SHWXn2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 13:29, Pratyush Yadav wrote:
> On Fri, Oct 30 2026, David Hildenbrand (Arm) wrote:
> 
>> On 10/30/26 12:33, Pratyush Yadav wrote:
>>> Hi David,
>>>
> [...]
>>> Both want to only look at "proper" shmem
>>> files, and should not do any work on a Coda file with a shmem mapping.
>>> Plus, someone later down the line might use shmem_file() without knowing
>>> this subtle problem, and we probably would miss it in review.
>>>
>>> For callers that only care about the mapping should then use
>>> shmem_mapping(). I am not sure if there are any. Perhaps that would be
>>> collapse_file()? But TBH I don't really understand khugepaged all that
>>> much. All other callers of shmem_file() seem to care about the actual
>>> inode.
>>
>> Looks like collapse_file() would then use shmem_mapping() for the time
>> being. God this is confusing.
> 
> Yes...
> 
>>
>> What about the following replacement:
>>
>>
>> From 6e3c4f92a651e36ed1ae8d7659d2ca08543fa430 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Sat, 24 Oct 2026 21:08:33 +0200
>> Subject: [PATCH] mm/shmem: make shmem_file() check the file's inode
>>
>> shmem_file() only checks if file->f_mapping is a shmem mapping. This
>> mapping can belong to another file, however, as with a Coda file backed
>> by a tmpfs container after mmap().
>>
>> So it does not guarantee that the file inode is an actual shmem inode.
>>
>> Seal handling and memfd preservation use this check before accessing
>> shmem inode state, so they can access an inode of the wrong type.
>>
>> Let's make shmem_file() check the inode's file operations instead, to
>> identify shmem inodes reliably. This will identify regular shmem inodes,
>> including memfds and ordinary tmpfs files, independently of wrapper file
>> operations.
>>
>> Use shmem_mapping() in collapse_file() instead to not change the behavior
>> of collapse_file(): it operates on the page cache and uses mapping->host
>> for shmem inode operations. Focusing on the file does not seem relevant.
>>
>> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
>> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
>> Cc: stable@vger.kernel.org
>> Reported-by: Chris Mason <mason@kernel.org>
>> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Looks great, thanks!
> 
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Thanks!

@Mike, @Rik, Ill drop your RB, so please re-review.

-- 
Cheers,

David

