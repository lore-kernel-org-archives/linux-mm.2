Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D92606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LWwBG4F7
Received: by kanga.kvack.org (Postfix)
	id D24C66B05B0; Mon, 26 Oct 2026 23:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC8C6B05B6; Mon, 26 Oct 2026 23:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13676B05B7; Mon, 26 Oct 2026 23:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD366B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:45:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B0DB160728
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:45:37 +0000 (UTC)
X-FDA: 85367016714.15.D1ABD67
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8BF3180004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:45:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LWwBG4F7;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793072735;
	b=hWqC7vYv1H/bidvEXl0m2rb6bxoYC5dsKvBmpA0qNc5lhEkVO6oYdEqV0V9GgqgagPgNqb
	tvTVdsm/ZFuePWzRjoBzlUoUMYNnArm+eCwCtuCOtwqvL7QfNmY2Rh5t6G6TqFdmv3nfSN
	b3xYXkh4gKO4iERDJbLUGeYXbR2+4Dk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LWwBG4F7;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793072735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eblZIxYX7VzLbXt+5qoHuQCynpNoCaK48F6B5iELuyc=;
	b=mCrU6gN3NaIB1E1RlUhtQ1nu9XGpifkjNah6y4sP/6G6nU3FU+AGcXijAsfO7tWpxYv9jx
	KZQr4bt4Lzd3tbJOnNnVpdIBYqcfvV0vHZ84DeBlLz/QEtzL5V1TKAmmMAhpDPYzFN3H2H
	wdli28Q0A1cDqPe2c/rkFkwFuWDGM/U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793072731; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eblZIxYX7VzLbXt+5qoHuQCynpNoCaK48F6B5iELuyc=;
	b=LWwBG4F7yuVfRdx77I92nUFVs1uBDYwEF+G6k5cnIXLjeIdn7HCF6LRG5nUoLo746fjDmMtPvMwXsNA4ljGMsKdwoy2rJuRU9AydipAZc/Jiaqx4Ao92GLHFJ9+mwG7U9UUDwor4X9u1QZZHz2VneUwbF6/NexdfYs4HdmNryQI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0XDcSv8H_1793072727;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcSv8H_1793072727 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 11:45:29 +0800
Message-ID: <da613229-dae2-4e7a-b65f-beb1e16aaf1f@linux.alibaba.com>
Date: Tue, 27 Oct 2026 11:45:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] mm/shmem: honour F_SEAL_EXEC when an ACL is set
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D8BF3180004
X-Stat-Signature: 1h6dknmjh8o7e5a4pmg8oo1hsthj8s73
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793072733-482086
X-HE-Meta: U2FsdGVkX1+qMOQUwnf56BYYQH3DDU9+kpOscUqX8MP2dQuhYojW8+oAb/SD04bR9I/Cf1pYH412aekzlviU+aKififDv+KfkCjC+QnDmeB42ARFcWaCPgqz+CgP6NOsuso1MALsTvaB/R6+tqyMhvpvJlAU8JYyG6lQBQfSRxE78BdCHcxlkUbQkfgETI8bSWKfI9f4nycYegm01Cp4ydiWUXUphAFc5VywQRYi/cFfk52i4tTAv2oLRpN4/7xOdEFGlOze0Bb2h9kbmPLBieiDXhB/j8/sqfmOyvStd4LkoYLm5g8lol0104kzsZYbQzW+LDxIWmM8A2z68AQENaWkZI5s6ECFkQzOAT94JCsiWIPVwz05DcXfeDbhFjk1NSfYZ0Ct+ruFjctaAKHmU7IO8jQEdsr7dYz+WFDv+9obrYkicnjXsFwsT4QEaKUthHa4GPtaRnoZocddqHaOvlZkIo1iLtz1dRJsx9ueEk+hgWIgFm84e8aTHxeNHPWvnC22MMev8uoNeyeXCcyWpPS6rsWv2hVuytpMpyJrhUbBsdGQ0B4JyIk4brrTkYkLmAwJC55dqw9hW4r9S6zaR8tBXQUeFi9XKxvkHN3+no23TNw5wBRLuw+QgCbAEXceAd8l6zCqTQ66DQDlqj76tjDzG2BhJNPAvTxDi4Xw70rM8Dk16gCvOAl6UiewTAf2VjF89/gxFJ5daUqBJ6YuYM82aT7gxZfIy7szEYau4dB5wldgsmZxAUThU8dkcvMRhnWjY5GDUeYja4q/GM5cn5Fy1lpXCVVaYzz7BwR5tLDDvoXv0GKv2418znKrutAq/fhT1g/4Q0yHzyGIn4LRs+Pbg+IcX/6Po1lL0Y55WUr9OKiZ1hBrn7azkdKCCXl4shccsOuIbf8VjUgPMauk57vag9viEWSbplfqOSu065qIretq6mY09AiNDv3PjVCRJqx1d34wSL6ZvEOGfjX
 s0iZUX7R
 KkUUBagmZCT+CKxKHQDmDwRmxflhBGE9feOH267HrJ0qSOLZhcK/TmcbTocP3IYLjMEBuO/WpWHEtdMggnysmN64NDXXpynYnoybOxXOBNE25FlZGJDiRl3FEYrtCpUiHunhIkmaM7ZMaj1G5RnhpclkCNei0k6nh3ZAjGglZkKfurlZ+J+0ScMBRsWqQbziVjPWF+Bo/ITXZrimGm8HHxvKYtLJ68wZO+QznaMMm33ViTxW+2MFGi2Wbf7zL0nBLzX4xzwZUVdOYLhOHl6HLIxbf9EKouXeWQ8nHzuERZiAQ5RCH6uqAcN2BCkGlnzrjdWj65PyKIWY3kCo6XtNvQh1UD10Qge7l28u2pRxFembHVr3GFl2fIfcSDD0/EPergwT7Sioc7eyJgyYLCuZdX6Ibvu0NgL/N94dDg5Ru/G47qy3of9ocJf+Jl/+7Wtqaxt3JRJF112TwLfiGjwLeKx/gO/JyLzaQ/sCz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
> 
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

