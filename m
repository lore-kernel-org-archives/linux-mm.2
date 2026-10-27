Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4017606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZW8ZvckB
Received: by kanga.kvack.org (Postfix)
	id F21736B0743; Tue, 27 Oct 2026 09:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8FC6B0745; Tue, 27 Oct 2026 09:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FF66B0746; Tue, 27 Oct 2026 09:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB30C6B0743
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:27:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5885F120A31
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:27:23 +0000 (UTC)
X-FDA: 85368482766.17.6C1C520
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C87C1C0012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:27:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZW8ZvckB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793107641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPhl5nAJZ01PZ8pIqOHEqDA0GiiMUbdOvpcbcEC79Tk=;
	b=vkFP/s59ICPG7rT/3odVNck+/MfFK8JTqBJhAXzCz9+nG6bnNdgbQi5WSrAGzz2kwUZLY0
	TU8LHRFsdV9U3YQfEVjxj4sRx7cf4sGNj3naqhTV4mUFtfICHcbPXL5dMs6jEavFXzeyKV
	B4iDJAJJJSu6TwI60qoTZ5bB6mFeqzc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZW8ZvckB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793107641;
	b=WtNUVOU/hrTyG4rXE7lHQ2oCt3YvPeW94nilmfQmGjcaU4JLkMaBQcTw/xUtfJra6NOb9y
	/eHp40nr7Bo+ZvMl1zWO+dKO9Y+nF934smqvGKwJPtlehCcSyDFREUIBkZI6G0HBsv32Ry
	gCE+jpQobO1TjPE/0fSypHPbHhblcsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0526160218;
	Tue, 27 Oct 2026 13:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C045A1F01825;
	Tue, 27 Oct 2026 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793107640;
	bh=XPhl5nAJZ01PZ8pIqOHEqDA0GiiMUbdOvpcbcEC79Tk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZW8ZvckBIuhZsnT4fpJsTn4/Hz3bk28vHTe+4HCuOWflZVbVN1jF3sc8N7lnHK881
	 +VVQP8MA1CaTP/Meht3G9X7Jevm3Qnz73/ugNpIP/Hif99zxrJiB4kw7D7RCJxuku2
	 ubGzeWyejakF9Xe/lrsPIObVgEmdDXFa4JtWfnEvtDnuknKllIdfisQmcgItLvHq+M
	 OJbZggxIlWF4mf0UtVqPFoej5o1/fYnagV2KAwyfN0lRL2UBXYRRQsOEKrGQ0qoqC6
	 SxwkshJp2HYEY7cB8zu7BauvnmpPm1k/rTVI9vLo3/wd5Zg2+c7ReshWr+iPyVnoDl
	 7aS8/smFkjbtQ==
Message-ID: <74d45c5a-1815-44f0-890d-c847f84c0a57@kernel.org>
Date: Tue, 27 Oct 2026 14:27:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/14] mm/shmem: various (urgent?) fixes
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
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
 <de90d124-03f6-4657-a467-71ab3d441212@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <de90d124-03f6-4657-a467-71ab3d441212@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C87C1C0012
X-Stat-Signature: f9jh91tntuqood9kfn3n8ir6pq1r5r1a
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793107641-409286
X-HE-Meta: U2FsdGVkX19MGUxaqZczsGueGFxg2+Thk+jWcLxL3UUPDNh29MOE0o/7Kjwyaa1hQwqo06zGl2foiTwexb65RK/3gjr9SPUXjW7FIsxbfXE9Q5aHIXVzjyUv2L7cwAdZ72PvgAe46rT+XU5wclJ9q4q2M3eIy4Xyzmxurmf2QyoKBiwc3DRhAjnHgVk4NYlI6lI6E77d+AzVnxVKqUaEOi8H7Enz12nNYsDZKGz3TLaqTo0kBx8MeewIR3pjDZaodt98N2SMe3zM0cupPn9wnv55x7ZY4vqzewRVvGwDNQyVtL/xYrDjxmWbT9V329hj2Iq+CSgAQt5DjbP10KukBeSAv3MDZ0ddvuQbvatp0KthoP/KEtRa+Ccg3V8ExBsAJSe1f8FGw3HZHfQBMqPU7PWBQn7CgIFb3CFwFbmPLnWIVrAsPpwH7zyDLup4Xp6g4Y0HJDIUPO47K1sw8kvJn5ZzC/J0nAzwpBVj2+m0+MM+Yhq79GukkTXdWQw0u1TlrRVQO3w9PQXEHkP3kxzA5YQydfGsvQ2Z3XeeYdVZgMKbtW1pfy1V/8OTdh9oWxs1JJom7mfzJ5id63ev8JfS7cPxh7DI9bjBmBdXUQ6CT8mRx55vKXo83G0nrIdpALnrAOmypFPltG5Q5AlTGpXbtBZrKHGBKCBxakeIWn8G5Sa29jGRmLjlrG1ZrNcYC+abGyDklndrCNK78df5lg5MiLVUHxfosbYqIXgPURKVnZR6exT7dNDP2GQHRIBo8vnP5Ke6UcC5WYTtU0bmuD3mbFGXmEijfz0EI4b1NIMA9ws8n0DKf7UHvEjdacP6iOFDnGPpH1yRh3WXTZ3DgI1v9uLNaT8Kt5KlvQ0NC1gO1Pm+Gy6TyVJTuwhk4XnsYbP66bVHS1mYOl5az2fgcWkMTxCNv81QxE2BSe0v38el6YMQnvEAXJ/hEcP4BhwHbQD0++Hq4dhPjn5aT8O7Sbt
 MPiIIpDX
 66pEV8Hzy2g8cySMUnlXPH8BEb9/gR7bllLO+hEaE9o0iy54HguvwziwRRH7TRkSp8vgezfa6ew7TxqSfwU5rR+1YInjU7ghYqXWfAfGVhOuAsd8DI1l4Iv7za7kb1Wglyy/uD+Q8W9SrI3cgOAPpRVnQhMiwcHD6aFtWD7s/mkF1b5lKTme1SXISPBr/Puzk6P8ZGpNJ4DO5PdwFfEUPpyzi6duoOaEGpN+xT5W/74ub5a4LvIbPwfZz+nYPHcKNyZnIgyUFEtlIg0VnF6Kamq2g6sbo6Fi5XxBUPWffGc3kolZLEB2TJ2xuF4VJZOleAzy8NdOpEIQ71FrARqrdzC8jBdh0jyCgqsM6uh6D9UafCZc4pM7HrdxbcDeHfg8L+Vq4DtOklOGHVZySaOKP9VPDUBb4oEK6CayTrgJqGYxCnbdaHNQ6MSmJv7c6LFd5EhBwPUYLsDB12tXPHwBHZzTAMGtqOWFP825TJaY9IwrCrpz0RvVAO/AkRyogbjaF6mMg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 14:20, Baolin Wang wrote:
> 
> 
> On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
>> Hi,
>>
>> see v1 for details. TL;DR various fixes.
>>
>> I now rebased on top of mm-stable (thanks Zi!) and retested with
>> Gregory's tests (thanks!). Thanks everyone for the fast review!
>>
>> When sending this upstream there will be one conflict with the following
>> upstream commit:
>>
>>     737362c7012a ("fs: port ->set_acl() to pass const mnt_idmap")
>>
>> Which should get resolved through something like
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@
>> -static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>> +static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>>           struct posix_acl *acl, int type)
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> Changes in v2:
>> - Rebased on mm-stable
>>   - Fixup shmem_set_acl() compilation issue after rebase
>>   - Dropped: "mm/shmem: avoid moving the truncation start backwards"
>>   - Fixed up: "mm/shmem: stop retrying folios that cannot be split"
>> - In "hugetlbfs: enforce F_SEAL_EXEC in setattr", check for S_ISREG
>> - Smaller patch description fixups
>> - Picked up tags
>> - Link to v1: https://patch.msgid.link/20261026-fixes_shmem-
>> v1-0-703206d5fa0c@kernel.org
> 
> why drop this fix "mm/shmem: hold off eviction in shmem_writeout()" from v2?
> 
> https://lore.kernel.org/all/20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org/#t

Because I'm stupid and dropped two commit instead of one :(

-- 
Cheers,

David

