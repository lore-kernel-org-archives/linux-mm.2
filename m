Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C1F606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tkfj1kIi
Received: by kanga.kvack.org (Postfix)
	id 3545B6B0740; Tue, 27 Oct 2026 09:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305626B0741; Tue, 27 Oct 2026 09:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4BA6B0742; Tue, 27 Oct 2026 09:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30076B0740
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:21:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BEB4160A2C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:21:06 +0000 (UTC)
X-FDA: 85368466932.28.1568BD7
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DCEF4000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:21:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tkfj1kIi;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793107264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuQkM5AxwZ9bvY/L5nF/RTWycJ4QV92AF8p0xtQA/Aw=;
	b=FQXvywxKKJ9vu1oaJOvN0Ymf1cLGwaoD6tB6EVX+UTqe36mG0BdJM0qFPq+ZQjPRu75vWP
	vmyLMqSiQSy4tSa3Zlh3RKR9lje5dbWh+a1Ge0DGNj/JHtTsIP1pRd6tyTIJIhhmN2lOXR
	I2L09iuLixJC9PMT3WECWr9M0K55lEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793107264;
	b=mHGin4AF1nePV/ZGpURy0KYVFtdxOj3DUQNqJhCcC7OxSYz+VE0Jodl7QAenKhttJFQX1c
	3aHidJdbhnzaHZ/Nrfx8Rd17RWRNKWc9+FEZQQ+fyCXm/xVwXZGH3cmE/V+Eur2r7+GOPB
	4By7/zNk9lZ0H4beRxIsZS/F12BKHRY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tkfj1kIi;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793107258; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CuQkM5AxwZ9bvY/L5nF/RTWycJ4QV92AF8p0xtQA/Aw=;
	b=tkfj1kIi880Z3d1ybcGk8rnamp8KmZ/Z5aMQubelVDpdmGlzMDRlo2+Fkrhy6Hst7PP16xIWR2el6G6whHLHhVmexta66pFToNa05a3q+skCHGIWCHnE64kPsxNEsPaCVf6ve+tHgnI1TqWn6agydDXVlO4pIaBp9OQakQRMqrg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0XDe0LQe_1793107255;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDe0LQe_1793107255 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 21:20:56 +0800
Message-ID: <de90d124-03f6-4657-a467-71ab3d441212@linux.alibaba.com>
Date: Tue, 27 Oct 2026 21:20:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/14] mm/shmem: various (urgent?) fixes
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DCEF4000C
X-Stat-Signature: 3hngakp8hjcbc8xucayaq6cmghjepaz3
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793107262-864973
X-HE-Meta: U2FsdGVkX1+fzggg03BkyNpeI5DSO6/jjD4ZnI9F4AG7c7+7c6ts+JVPSY9tw5wV8s1WFXOlELbfBrtmlBXS3t3rxTXiqDh7h4UyckPMTfWiRheR4AuY6fcps9YK/OQXu6C2Zm2wrrY1Dzpb7f8DSABl9B9qLaaSgqhLNylAyHEvpRBV7VTbC7Qjly9F/hEZ/HO88OUMIgelsLS1MIpD49si+GiYJBZb2bo29FM5pE3zJMtExT8J9u/2Rd6tpZNi0PWTlnsplImKFAag8nRVr8TEQkBPZExJ7lAn5ce8c66xCp7NHIKD5NwiOIHrpVx7zXqFTrH5FIg/vjmXXkOhPKHZ4SRGFJiRKOuo/L7U1vpqBaIt+AyKuyY3+5+S8eU7rzNcfBUg+ZOboV+QrpnQpWWrdkLuDipd5IMG4ochKQWKZYVqWE+f32Yx/FtKrxgwWnhHlpDkfxUPXTJExSS1G19h0HD2oOIRm/C9PIHLz7QTRlE8ui8vd15qkKdb6ZMKafUrRImzkJPNeFHKl/4o8qqBxhJmd8YP+HIkWXdbKH49P/3yYo5JvYT6a3wVmygHHcxGS7oRvT4Op+9BdiyjKInvnn/o0F5Mi501n9nhMxLVcXAztaO2fBub3qB3/WlZRHjFJbIAeY/Md7lCAbyzzFu+luSjEF+oo9o93PgkUmcdRSK4hkLSbEcDZZRrijiQbtcGCR8BXlrarIdmv5sp21Le99AymvPpPFDPKBI6iytkgIAzTpNvS76dJhwV48zYkaCp6uTpbE/z6SpaKoDFxfJK3+OikkpgNrZ0NNaCg9qTPZiFJ5spW9BKeqN9/EGSe15qd2CKzIKyHd6YcSNcChL6MybWD9EuNrr9cjdBDyjuuFPKcYfQqb5nuBLg7T9451m9rQtsVP973S5yXxHjOKaQA4ZpCNmb/XwPiVwfwDeXt2dmb5b3d0fxz1T4npVlYip5vnH7RU6clXpJYag
 FiOQbS+X
 cRFTSdxopqeuU4rnSXKHwp1UK7u+bZBsVOgYbfbJFoYw1qeMFcXIlinmZ/+b2e6PdraF6sIliLh5d2/e32dgdWKB4WP5Og9FP26bAtZpAprEb9rBXnbFsVfITfoL0b89f0pe0t30HkSpJ1ZrsHwlUYIN49lm7Eo3wJqbfaqmEKIzqhEeouJ9Pp+P+J8SGOlP20Ii/JUzXryg6RlvY7UZTChSW15tPEytQFSlFqxttW+koAX1KxHPehQpJrDGqhvHgSjQvRbiLaWfvXmg+UWPBjUVFUsVLB+DgkSFph4M+yOa/L9BoYVwGqStfJniB+FlqO6LHRq/RNz2ulMXi4SWaldKO3HwzAIuAv2stY1/LGCGCKiv+qxLD9X9aU7+ISU7BPKXDG2wM0C0KOC+YpMBSRoSMs2pohf9ciXoik+wb07sc5zRmLFZ39Yg4dUTczjXkRCR9ojtEki7XWjpNYXq0KV2a3KqNWNp18tRoAwcKMGTFWwdmlNKTdV/9SPjePnW1bpic6ScR6yp93J2fuuyxAeGCBZN3xEwQruPI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
> Hi,
> 
> see v1 for details. TL;DR various fixes.
> 
> I now rebased on top of mm-stable (thanks Zi!) and retested with
> Gregory's tests (thanks!). Thanks everyone for the fast review!
> 
> When sending this upstream there will be one conflict with the following
> upstream commit:
> 
> 	737362c7012a ("fs: port ->set_acl() to pass const mnt_idmap")
> 
> Which should get resolved through something like
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@
> -static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>   		struct posix_acl *acl, int type)
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Changes in v2:
> - Rebased on mm-stable
>   - Fixup shmem_set_acl() compilation issue after rebase
>   - Dropped: "mm/shmem: avoid moving the truncation start backwards"
>   - Fixed up: "mm/shmem: stop retrying folios that cannot be split"
> - In "hugetlbfs: enforce F_SEAL_EXEC in setattr", check for S_ISREG
> - Smaller patch description fixups
> - Picked up tags
> - Link to v1: https://patch.msgid.link/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org

why drop this fix "mm/shmem: hold off eviction in shmem_writeout()" from v2?

https://lore.kernel.org/all/20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org/#t

