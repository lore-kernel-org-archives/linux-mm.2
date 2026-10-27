Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8B4606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=upDAjywK
Received: by kanga.kvack.org (Postfix)
	id 7F6146B0651; Tue, 27 Oct 2026 05:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7B46B0653; Tue, 27 Oct 2026 05:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDA76B0654; Tue, 27 Oct 2026 05:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5446A6B0651
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:19:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB2CC1A092C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:19:15 +0000 (UTC)
X-FDA: 85367857470.29.BD5EF66
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93E5240007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:19:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=upDAjywK;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793092754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjhWYuYz/Y0YoGs1RYFiIWHiS+9eIIpbtVl1mUgbHKU=;
	b=5/0e3zez6VinQ0WuJGCIiXqNMdpEg0oTT4jId+oYcR6P6eCaN4ZdV7FdcQyjHBNM5joo3y
	J++o0zJMi/l3hQEsxR3Qih8HI71tAcmAmSMWJPbjSwv2IYcwuemWrgeAJB71Vu80OpZm85
	sJfX9mM/W6nz8GU36idYTyxZdlIIZSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793092754;
	b=jRENOhIHjpTdnpkx7UC3ulHaKhgu/mCw25Dm6yz2ZsjOboahQ+LnUA5ecV109GO5+g6qm/
	aIsOn+WW3UyZQgEi1nXdTPQEkjDWGUZQ0OKt3247VuMAl/00LdHDuWNH302qFkQpZQ8KeY
	ryuY+62vTp3MX4M0UVFNmoQhhEQu5q8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=upDAjywK;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793092742; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wjhWYuYz/Y0YoGs1RYFiIWHiS+9eIIpbtVl1mUgbHKU=;
	b=upDAjywKQl+ahypZ9ORT4aBGw3gfuF6Uyc8KmLj6VnIfFGBBuv9kaH57Fpsjem2ATRdnK4QhqX+87IzB7jqN9mriDC+NEdqLA1vWbOf0OUm8LKjQetbxsvpougzPoDcFL8+pxK18/1oLN6txA3CwagohENK058I4HrUd/1HOZhQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDdLjEM_1793092738;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdLjEM_1793092738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 17:19:00 +0800
Message-ID: <6a2d3eba-d2e0-44ed-939e-001a5709565b@linux.alibaba.com>
Date: Tue, 27 Oct 2026 17:18:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] mm/shmem: preserve allocation errors when swapping
 in large entries
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-13-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-13-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93E5240007
X-Stat-Signature: j1tahfcg1e8dyqz58uysoupwan1u54sy
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793092752-556154
X-HE-Meta: U2FsdGVkX181TpB7FCQL9XeFYUaXX2ki34Lo/TWPokncVOSwBG8XEb50u8Uvf3Ve6bV3NpFUSChDSm9/3MtsHf3ZiUNX9DASs6sNSwtt/KI+Nj+p3Xll01xYvKavysC0UWodsTp36+lzRtVwSFStnKc9IlIY0kOCNC5r2YSguWBvgANDpjKWzSMY3RTh0KR7ZmYvgYKXpI8SNSA3CIbkH65avFBVD4lLna60ES+7pzxp4pXjSlmC8E69KR2DKgi+TF/ifh6e05xWg5rKqliXAQv4fMyiJyJeShbDUueQB5SPoL+stEO7A2iKwis2ExE1i09iy7Lcyxp27foMBytIYcrQQI0W+9oDZ/y7dgFOxC1KK6JuGiomNF7J1Vjdnaj+9ZEDSBytO6uO7nFzP3s5UawLkbOIhtmtLTqbR786pk8KVj655kpkWHqGIGYJQ783G/GlxbM+ganPtCZjTmmWmCXMbOqWVE4S3p0I7yNjtcGijYR72apbF/9JT5XXaxTTt2MJDjD9ya+Q1lQEZWrhe5QkywqQr8n1SMMCVkQjYd18/R26UZT+oUH7tfLVf604cwMBB+R2twYEKyOSk2lmdBUAZcPwFqyiYIUPvqNTpLChXwGzYluqBkKKRpVOdlE5HEiHOR1eET3SduiSRaMLjZ64CowxHdoyulKft1kPN1URKiD1zml+J+hts/9C9KuQMk+dbhAK7trK5T1AiS5c3lJNGttxjn66aJiO0EfCI9RavBSf0FKr5VOStYiFWXOU8J4j8pMz8TL/ZLz6rDi/ddGKiTgDp6f63QKH2naaXVAhjPKlUPE6XeomSlYGKlQ4l1WUSmP5/fovWVBr8vLbI9b5ZnZr7rih42oOQUWcl0Fu/0ToSGTpvPBE5mnGu7egP57Y5oAr+V0lNN6L/TkSGEl1M5Tp05birZm2+EQDbivL+xxNfxxirWXQ8TKQJmZtAJ1z+LLkkb0H1FoWava
 1tnwgsWZ
 UD/jWDoyWSQuQZ9uslQjwcfeqX/udB8/UASZb+D9z73GqOFSq8uuUfRBZ3Qko8zHZafEDjRhn1cfYIjs92lSjHrixZQ5oKDBmVbJqbQ9jqqm0EEh41FpMSdDpDPF1oeA5TzEZxC34dicmZkAlmoFPdlH3NEe9k2sAPnTQCWshkKheKorBfcgG1QIE+gbd5YOlLwrwxsH/nbnycohCSD082uuTJUQnOteg1/581pLXKCeYpLxyj6/oDZSSzXQEqHhAe82hfWo9ofnPUViMY7R+86PCOPJgOaFeN+yTGdP1FDAU45DbafzztkYv8pdGMtA24tB7H5I3TneKUYywXRj7VdK3EYh4GtrK2Rdm3bAa23gZDIkPsFGLmBKgGHyBVj77aEfM1R9ATtOw+CvGsurg9X8GTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> shmem_swapin_folio() adjusts swap to the requested slot within a large
> swap entry before allocating a folio. If allocation or charging fails,
> the error path compares this adjusted value with the original entry
> still stored in the XArray in shmem_confirm_swap().
> 
> Unless the index is at the start of the entry, this turns -ENOMEM into
> -EEXIST even though nothing changed.
> 
> The caller retries -EEXIST, so persistent allocation failures can leave
> the task spinning instead of returning the error.
> 
> Restore swap to index_entry on allocation failure so the existing error
> path checks the original entry. This preserves the allocation error if
> the entry is unchanged and still retries if it changed concurrently.
> 
> Original fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

