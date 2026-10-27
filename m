Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6627606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cje2C2JW
Received: by kanga.kvack.org (Postfix)
	id 8A15A6B08A7; Tue, 27 Oct 2026 15:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879E66B08A9; Tue, 27 Oct 2026 15:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78FC86B08AA; Tue, 27 Oct 2026 15:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 416DA6B08A7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:06:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AD021A0AC2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:06:33 +0000 (UTC)
X-FDA: 85369337466.02.D0FE5F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E923940007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:06:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cje2C2JW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lf2Hoc/RWmB0/QlKnoJRvWNvn+6TzYwCnLWNzrsTcSk=;
	b=225uTSYATyXeDOWU4VNtfrNe7cI1+XRd3N6Hp2wODerJcUP7RfSDDS/wXXWFJsTNV4NFvc
	FOyQx+jMQxKHZHDGB4iKWxHeeCocVKnoSckkJ6LsU5eiHYl+DDIIPv1bK4OLEXM/V4GePf
	zkoRM8FbIMiU3pl4Km6Y0XS6GRrRF58=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cje2C2JW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127991;
	b=KhsK3KPSb8lMV0m8pPj85I880Ax+plaX27Rs8Rowan4DAD0SvKEgrOJA9HlU0mhw1goBjx
	8oXXIVGYdaSjt64BXrbESz3wAfFpE4XGkATyiges/qSLU6rTsT1h6wGgeX+Y5XqksKcdsg
	83HDFU28szuhFXhsbPclRGBHLMLJhBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D6DD601FE;
	Tue, 27 Oct 2026 19:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4261F01825;
	Tue, 27 Oct 2026 19:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793127991;
	bh=lf2Hoc/RWmB0/QlKnoJRvWNvn+6TzYwCnLWNzrsTcSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cje2C2JW/W5/9ZEii8/tlACEPvMOnEjtWQcEG9HwUfuEGalcwYmRITtkhIzXgtM0F
	 zVZPSg6MqWG1EXqB5aEm/UM1ZGW6AUvIBMETQt4ATO4Biy4ylKhaNWcc3aETkNrUX0
	 +Rs2xhiojhULts3grC2OreKYDtZWNa7jmYsfkJOEIajVofwPjCJtjn26J2BasBa3/1
	 FBvLrtI8WsnLL8X/8SZDyxn+URbO+XTS1C7Oaenryfso2BZULJrKXufHYlcMtbRIRU
	 EO59ufQ81gNQ6SJ2yjHXTkjfgMYx5Sqa+hoHZTfCdWqAvmQc93hgNF4B+H7JFr5lqG
	 E8VnnHkkgYw3w==
Message-ID: <e5766fe2-6cbb-45bc-bc57-87314c130de8@kernel.org>
Date: Tue, 27 Oct 2026 20:06:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
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
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org> <auBbKP8UNI9talDL@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auBbKP8UNI9talDL@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E923940007
X-Stat-Signature: wccwug961r6jjkyj9d1kittcpr8i3d9j
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793127991-31302
X-HE-Meta: U2FsdGVkX1/sZLB5G5r09dYybIUVoPyHwdQa3G4FAyqWZnrDR18WCQ05ZRdb3PJbZOMzYWunZ7aLI1XFcSOlmsC7+vxyn1cYT8aD6Hi85jbJ3HiiJrnNutIGjL6VA9fzF9Y7fjPCc1AVvbyNquOW0WFUMOQwkfdUZP/JmruUlKtLYARlyv4zqSk1W7Jqt4HUeYGndnuSJFYSRfbMhTNO2Ag3Ey5cpY9i3kXx5nmVZ0CB0j9YUG7p71ar7XEmI6kVzM9gJI5ThehjxHkYIZfLWqZNAawWsKEzFDebWJhCT5cNuvi62D9iEuqP66OQMtd0T+Wq0Q5RNoRGXGdXwTtz1k06+EHGQn3JEuAsrdl93AgKl16hnz+qfRuik6IcTKIO7sxwdRij3v2axXPJvAQ3vxpmi0qpR88/0RIf1m3EEk84pKP/UIoyf72KuFfEmeTYjAtEZ7NNPoZsLwlNuwc+PW+GDjvRRWoHSGRoo2VjSzunQSKyuesXaQ9FAHZUvS1J7nKT9UbvZwfUVxlqjRh7l7y8XUl1Vt8uF9UdqLUGPrJ0sBuXSX9Ynem1M+HmxfcqrPZHCXDkLk1WUfHDgyQt+5IsRXi/htSq5a15AZ2hiqmvnLbCEVIlTjBkwfSB5kBkbJilRYGanti5HxU/BbO3D8VIawbjNdl8P+U52GdGuNMU+lmln+RdFFmDDJQEiRerf95/9AzfvQtGHAlAKjpkA3ONPJBhq22Qoak2qsIpYIpi4BJMjhtC40b4DR+pWoaKPWL2lPMGvFBNMA+ZhpFX+vqUC6XX18xL9/6rjg4Ny5JLY9OgWaftIfQt7kj/u2Bj5zib/ca6q1NruDjRg5AsSIL1xQMnVI0Bzzy3t3SQK8JWGnctOreFCaQTzzWzd355d3WFtxgRO7QlG5zFQbi9IwkCde79qnNAhNyd36DZKQ25Vf0U3lbGESEagEh6c7loZJ5sqAzowr6D7xx2Obc
 DMvi4gOY
 pihrYF5zbUgsBWzH6hYrkDXcheIDnyOC1sJpgyLM8dersysH+MAXzFH8mLcZLn2zK3Knf9fYYNle0voYLVsGfFQyQ+xw5Cg/w5PFh65j2uLWGnS2FAoOkTRATBNZqYz0OIOWmZxHheoNwUIpobC7FupAdxT8F1FsWX/c5Yu4h6n43OV3PKPLVek06brDkFM868F/DllH3a4/i1K3I6cPI6T9BKhZvavYJyYMq+Hh2nbSxTURxo86FPY/ikltPjnshhAMVCDt/bkVBU9hXgc6wP8zhg8BoHQ4ONYxIVdfWnY2PW7gxLbdOgdjN8bFhsThts7kuqVy0b4mLna6cTFFPT/jYtJ52F0bRRJh7B6jMkvWCnchx628G4GJUMrSNJ5Ke3Q0bNbt1ql8NQLg26umL1DIpVV6oywVw8lDJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 09:06, Lorenzo Stoakes (ARM) wrote:
> On Tue, Oct 27, 2026 at 12:17:21AM +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> MGLRU passes stack copies of page-table entries in walk_pud_range() and
>> walk_pmd_range() when walking to the next level. These copies can become
>> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
>> table concurrently.
>>
>> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
>> support page table walks"). Likely, earlier locking masked the latent
>> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
>> retract_page_tables() without mmap or vma lock") allowed concurrent
>> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
>> for MGLRU") dropped the walker's outer RCU protection.
>>
>> The fix is simple, so just fix the original commit so we don't have to
>> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
>> RCU-protected lookup and validation against the live PMD. Note that the PUD
>> handling is required as well to handle folded page tables correctly in all
>> cases.
>>
>> Fix generated by an LLM and sent by Josef Bacik in private.
>>
>> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ david: handle walk_pud_range() as well, clarify+simplify description,
>>          adjust Fixes: ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
> 
> God, terrible. And why does MGLRU feel it needs its own independent page
> walking mechanism?...

It's all a big mess. I think at LSF/MM there was some talk of using that also
for traditional LRU, but I guess it might take a while ...

-- 
Cheers,

David

