Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE00606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sON0xxmP
Received: by kanga.kvack.org (Postfix)
	id 740CB6B05B9; Mon, 23 Nov 2026 03:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F19A6B05BA; Mon, 23 Nov 2026 03:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607AF6B05BB; Mon, 23 Nov 2026 03:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46BF76B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:20:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 871CD12069E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:14 +0000 (UTC)
X-FDA: 85465686348.11.D92AF85
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7263BA0002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sON0xxmP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422012;
	b=RJdFDCrk6XVpWxRn6adIG4CtvktfhyOdtjLmEbK07u6XP1e5ppF4E//2J6q4gWCBx3hE/b
	tZ5NQqn4JuMwPcmA5ebzZAyw+erP/pA4Epc+2MQ3KqMnzLLKuM2O2OcPGjBBkIGcTBHbQB
	iwD6jgeVca4bddje4mkFr+hdXp2qq24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=do3hhy8BivBIPaCIu3eHt8n77a4uOX0QFMSHWM1VMf4=;
	b=ov/bqnXQxQI5aJHBuqWeCFPYjEX8bZQab61sLcwO6ugO98Uz8tFdmX4IptxGPGMFxuIjqd
	bzcYBNwSYt/EXUr44Oet8FjlN+CkTe5s1uJGIW3Jtubupg7Or13Alcm4ox5w6MoC+OMtXM
	130Hw2pIu+uQC9IRl/bQxDJ1ZUDJb8Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sON0xxmP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BjCUR/7yKwN3msaVE1SYKk/w8arWubDM2QA4cpLgvmQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795422009; v=1; x=1796026809;
 b=sON0xxmPibIieuLIk8tSkg2xw5kzUgOJWNfuVE6ys3rtCHnS7csKGHeDcb7eSq6oXBwcWArl
 Kk5CCZ8S/ldpqZ4xRaIvXQoO4/0zFddv/XC5GQJyC1tO4QxAraKQp2owatVK42vbL7jHHOoMibp
 9PCV0+tcK+fH5eb02srshf8Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9bb350d23e260834;
	Mon, 23 Nov 2026 08:20:06 +0000
X-Mizu-Trace-ID: 9bb350d23e260834
X-Migadu-Flow: FLOW_OUT
Message-ID: <a6029d44-7c7e-44b5-9433-452833152de3@linux.dev>
Date: Mon, 23 Nov 2026 16:19:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/11] mm/mm_init: move pageblock migratetype init to
 memmap helpers
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-12-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7263BA0002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 1o9ffxfrccb6speb4w99swizxshxy7km
X-Rspam-User:
X-HE-Tag: 1795422012-29951
X-HE-Meta: U2FsdGVkX18wV5aUR7xUWj9/kwJxM4K4L+lHs+9HLPKJ/k5aU4ioYi67J2x6q0iPdacZ03hyS0+UN807B85CX+A1eeZz9K37i0q+B9v+qQKjzBfUIhSMVqfh20IWMvEbOkmLC1e9mXzbtG5mTWt1wU4qBq0hKPwEV+1fu5OQCpyjkPRbtbmya1SVgatQpu8G6ncjDzw1j+tLBYQVO4m7kRUjE9kAeFjHWycLZrUj5neFqhsZk8CUHb032E2PKmA9rzqKy+CFZ1HAXJgdzsq1ooL/iK6NbKQlZOTqDMaLO66Vn8sgySeQkvo0yGZecqDPQguOzMNXRl+XoarLDCt3yxO8G70CFinS1H0bkPGL8DYV3fn6C4AM8X3Q+M+LU7f5P/0PTSq/gh+YxEwpUlh0PNZ26a0bVGYl5LS/2xQg8gF1wgcyEpIoAHYt1DiPRoXXMixGTL4wYgo3/i/FNWDa/NmrztZ5MCr7pyCjGv7z5xFUOItNasf+f2IPelgt9oGz3orGEdMO9eUfbWPwq+OqAIwVhht/ozUOhlSfemJwoC2Viqj5KvmTEutpyTNDmKAyPWuuct/CGoLMnO5x+FzLoWZmTJLyqRTcUD60MDJgF/JVmEPZq9lH1plzGAe1gxmHxF/JS7Vo51pYpwF95w7CmrQNVuONhhFo4oh3pI5PrNF2Qnt59Aaut9LbOoYd5binwYco5Dicq4Z52HH+VnfmdPABR7A0po9cRbQl3x+I0fPKLlJ0xIUwpWJZHv7djYLX16ABcwbGbudGD+8b2+i7k1a/2OHpf4kLh5HOc2yTVzf4CsTkjWrdTUWUcWCUjUduX1ROetUkDJt2n4SmJMX/EaRYv47L0lktAvfujsS+j+1r1gH0pWNxab/ox2d4ge+IZUtpSmIEasxY5cyRmIBNWxOGk3dshqMw26Lik6leYkdXmIdzkpuDDK4CxuYOpvWFt7p6aFqujwMCyrLNuCU
 ipM62poR
 3deeuuk3wy2FbXVGp5agTc1VPjLf1LSFHHoMxSEQipupeqKs+Zp4/meB+s+p8lJ6CP/26qoHiEXa9dm/h/n7pgbC91kIsTpdjAHAuvHU7GLB9ni9KGUV4jNtpskW9eeSR6dNaJCwmRHnAUYAo8XvPCZCP1J3cuwMcME9OhlotzE5ilvwv1pd7v+Pk9gBZ4pNllOLKQSdQtnUkPWF4gvl45lbbyaGM9/RLdHfdepfdhF4iqc6E/830FnabQ3G3fomOO03cOqHQcGNOeUn0wIPZ/OPAoCob1/xj9sT4lCUwIihx8G6pH9q61vIcaq22+xDHWjbdlbo9rZC0HMNVxVWwNON8jn9TsMa80BMWNodco48Li1s29xp31HuoOXctq9wbw03FyFSCfM4X+vKAyFTVyGPc3oi0Qz5rXQ/ViNsW7XLZfD7e47NHHU2FNmawXVGOGu38uX+pQkQsUnrCyfnWANoj2DsfVnl1yjl/C4K82sPAVNzRWznLrsxGhqSbR0PJlulFBrhYiiJWBA/YNAdBZeZsuIbQGC4lLyMoMiQMQGNrFtQz2YDY6yThOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> ZONE_DEVICE memmap initialization already initializes pageblock
> migratetype after all struct pages have been initialized, while hugetlb
> bootmem folios have their own duplicate bootmem-specific initialization.
> 
> Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
> initialization helpers instead, so the ZONE_DEVICE and hugetlb bootmem
> paths can share the same initialization.
> 
> The old hugetlb_bootmem_init_migratetype() skipped CMA folios via
> folio_test_hugetlb_cma(), but the shared helper always initializes
> pageblocks as MIGRATE_MOVABLE. This is safe because cma_activate_area()
> later overrides the migratetype for CMA pageblocks.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Fix the helper name in the commit message (reported by Sashiko).
> ---
>   mm/hugetlb.c | 25 -------------------------
>   mm/mm_init.c | 11 ++++++-----
>   2 files changed, 6 insertions(+), 30 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


