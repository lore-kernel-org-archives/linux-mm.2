Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C308606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=F4fEIglX
Received: by kanga.kvack.org (Postfix)
	id EE23C6B0940; Tue, 27 Oct 2026 22:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92E96B0941; Tue, 27 Oct 2026 22:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84BC6B0942; Tue, 27 Oct 2026 22:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B543B6B0940
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:07:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25A2FA8988
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:07:16 +0000 (UTC)
X-FDA: 85370397672.16.219705A
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf26.hostedemail.com (Postfix) with ESMTP id 572AE140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:07:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F4fEIglX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793153234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y20JnGk++kh3G1ZhtF9SMWZyhV7r1s5SsFeCJ6a8Zww=;
	b=fGyB65UgFXCvzyG/FHtd/HVUOJvnA+inwZwq+KWucTrhowuDcLGLLDRv2EVV4bWtcDqzLM
	iCOILKNQ293CsmdQ7bkFAFmZN42iBi8rjZXKYpihkbxCa3GNe+3xJOlzHm1B/lieYCsHrN
	gDOZ8ZMy8Kwj7ciHz10q3Cy93QtO9B4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F4fEIglX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793153234;
	b=6oZIEd4yC39xqd4+nYwuiTA5hjW0FGmemmC4JPcPyRMZRgeWiZxbg5z1F4cFZ9O9jYqIo4
	IBA8i6u3XrdVgrBNWvnz6LzkuF0qkx1EMspag8HwHTrZBLtyJ3iF57KQv+vpd6owmy7EsE
	sArsWTr6TypDfjEjuzjfZMp0+cOzSu4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793153230; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Y20JnGk++kh3G1ZhtF9SMWZyhV7r1s5SsFeCJ6a8Zww=;
	b=F4fEIglXDCKGCPXvj+VscR1cQrHQ+PlDk0q0rC7HBAfubHSP/T++DvxhyF6OnIB+AMuneQ/eA4c+XWR9qZvUMYZKn3JN0v81Gyvm1sbK2WkN3Xr7LTZ2MWdZpYLnQUzirFCJeL4I/aPGPSDvZuqEbb8391vU3f8kXfaBj3mI01k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDfCXNz_1793153227;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDfCXNz_1793153227 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 10:07:08 +0800
Message-ID: <cd23161d-939d-4da7-9da1-1a555c485924@linux.alibaba.com>
Date: Wed, 28 Oct 2026 10:07:07 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/14] mm/shmem: fix accounting of swapin-error markers
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
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-13-86a00952acb9@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-fixes_shmem-v2-13-86a00952acb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 572AE140006
X-Stat-Signature: wpbgspwypeecyog9mhdscrpoxn3pndch
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793153232-923727
X-HE-Meta: U2FsdGVkX1/cL8mWpxYmLEg4y4zxV42qsD8deipKVVyDaxlkxIFlB2nfi/YZcvLXqVGmmqclMnPsbj1NSGgANKb9s/A7bduUZfPdS1JMExD+3STqRw64kvv7gQVZBKsB70oMbqjg4hwK9CWX9igvb1e3m4vy+FZra8UWV7gQltCZSzPCCiuaIKWyjHKAgLhEfm7kPu9rVybEQiuRZTjBh7ETc/laEb1uKVkmjEWnhyu+5cHTiP+WXeurMtxzBuGeObq2mHeuon2p5mgdsLQbLIfh7XLabylZsjHb3116JlNBeGYPDYiU5mXzoGW+tQhZbwW8HJaeJUWuQIYsPa5lajg34ZhPE+6SlvSAbmP5YC+rbPoLOn1tlLyZ/HXFpAs8UpXDVOA+T04LvCEWeQ9taEy+dOt6/Jq7TGxtv0K9rIL4GBJ2dSrb55oBayCjdJo5NkJdZZJluQFDSuy+wO1VT7Ajhm+ydvMkG4LvWETeetzNNJegIZJvATkvpKHOvELEqZhxbnazQHIEh3QJS+8ntDMuoKCa3izbm39RMLMITppM2ijRWj5D+z4S3wjKFY82e5gJfOTOc1+k0zPyYIV/5oLnU/hDNuDf5zp7YkGEXZwC3LvzYjAn7idSIw0aR4oUVJj4qQlNjb7RZxYwA9r4XY6c4kVunaAxVhwCxeTsizUMjQF4/oWQa30Ot3KMeWe02+IDxIfVkIXTNgPzsbUMzgWDP7cgHTxWHjWpw9pr9GjNr8PWnUZc+DD178odIB0XRaJpnihsRpa3K3GyteKvFwWDOn/XIAokEqDBismf8gHeCKjTfP/PfIBZwy94fY9NbBB1egMVyAV8985EFTBG/zSK5W9X3BN92EHrXLBvy9K9okK7Tx+qi2gHwp/1WoJPvwfyQN4GVv3OEFSSik2jOrqI2w6dTSf5lm9vGJm5isaB5KcCl6l25btGlYMFd0Vjtub7P2RQom12DuOUuf0
 FakNDprY
 glDqVn4XlBCZ8ldRntjcBwelC7UPydgTMgNbd9YR/bJKju4PxAVizdkfnSo6hH5n2/bG8ndrOSOcoBdN7TgMAbZCPGg1cT6pipBdUpT/bi1wSEkuwWFhfUHn+K+8FyRu5EaW4Jf6opMD5YoZ00Mgtgi6smYJn8f1F45bS+DtkjPHN4+3d8/akg8GLmNesTr1YdauzeaVgACQn73TlrP1Ctv4F0GlD0xahDgfguAN0T2Esc40LfS46tunVG+SpmptBNdnnT2eaYdQKz1XmKXkSlbC3EvHBf6HhyE0eam603T4lmNmzsTSu6jmIZe0tTa/44vHKVdCGWc5ZKelBm6ALEHlWoYpwwTW/d+iyT9alZZKc/MfexKRQZAUKXsLaqmKnlkX2Z3ttNn7L+mAY6BWu1PJx1I/4UELZjsM6OIj6NFLEGxWTkPbGUAl3M7/yuV+LmSi8lEfqYyvDDp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
> A failed swap read replaces the swap entry with a swapin-error marker in
> the page-cache and subtracts its pages from "alloced" and "swapped";
> however, it leaves their block charge in place.
> 
> Removing the marker during truncate then subtracts from "swapped" again.
> This can underflow the counters or make swapped reach zero while other
> pages remain swapped out, causing swapoff to loop without finding them.
> 
> When installing the marker, subtract only from "swapped" and let
> shmem_recalc_inode() reduce "alloced" and release the block charge.
> 
> Make shmem_free_swap() report successful removal separately from the
> number of swap pages freed, so removing a swapin-error marker does not
> subtract from "swapped" again.
> 
> It's a bit confusing, but replacing a swapped out page by a swapin-error
> marker in shmem_set_folio_swapin_error() behaves as follows:
> 
> Initially:
> 	alloced=1, swapped=1, nrpages=0
> Calling shmem_recalc_inode(inode, 0, -1)
> 	-> swapped = 0
> 	-> freed =  1 - 0 - 0 = 1
> 	-> alloced -= freed
> 	-> alloced=0, swapped=0, block charge released
> 
> Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
> Cc: stable@vger.kernel.org
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

