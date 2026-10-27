Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E014606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uh7Vc+23
Received: by kanga.kvack.org (Postfix)
	id 0311A6B05BF; Tue, 27 Oct 2026 04:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD5B6B05C2; Tue, 27 Oct 2026 04:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4446B05C5; Tue, 27 Oct 2026 04:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A32B56B05BF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:00:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3AC840975
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:00:51 +0000 (UTC)
X-FDA: 85367659902.25.06D3DE0
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A3E218000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:00:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uh7Vc+23;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793088049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsqTgxlY/BA/8uomt0D4CyUz1chRyWUiTmuMkAfTR+I=;
	b=lKqRoOrcMvp3V1K4TeXhWZulVG2vaeFGhTxeaIDrY3sIK3mhG00/Nlw36V/ZExngV2Jjdy
	sAGER12FazPVQoGS4sPpsI6NKiaUgRZVTXyYq4dSuMDl39sp6cTbfe+IAcQuIhxHRczFP4
	v8np25lBaLSZYXJ6GM41fO5qMQMFm6w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uh7Vc+23;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793088049;
	b=sGN2Hzxsko/BeDrcYpSMo+pUkFC+Et2XBpiO4WQ7cwO7jE8kzDJVWZFBNr+IYgGDuTosoF
	hrV8Bse8OtnVthk0PHywhmdfvLd2fEA3mLF5R9unQTynE6tnDBehHCem4k0DRNumPg3j54
	TBI6xTOL7OfeJUhbyZDSrEmBAT6ahHM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793088043; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OsqTgxlY/BA/8uomt0D4CyUz1chRyWUiTmuMkAfTR+I=;
	b=uh7Vc+23et6rHP1cGcmyI/cpa8Pgnw3Yy68pK+tJEfKmUiSQIhGKcB2KIklBQU8vzUePzcu8chO7ZYtSIQIlWFCU1i75K+X73bu9JCEkZAlRTmH2qzbA+S59/+yZg/NghifZo4qvOMAns4YoorDr1JqrZj2uMZ8dvVyQ57sWKPk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDd63M7_1793088039;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDd63M7_1793088039 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 16:00:42 +0800
Message-ID: <68e7521d-6645-48cc-9e4b-f2c8f1159312@linux.alibaba.com>
Date: Tue, 27 Oct 2026 16:00:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] mm/shmem: rescan after nonuniform folio splitting
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
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
 <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
 <DMF9OO106FGX.3P7TZUBGHUFII@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <DMF9OO106FGX.3P7TZUBGHUFII@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A3E218000D
X-Stat-Signature: b1eis8pixxb6h69hx4zwqn5bhy8snpkg
X-Spam-Status: No, score=-29.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793088048-41862
X-HE-Meta: U2FsdGVkX1+r0/uJfne2UWmJ76V9y52M8Z9yxkPtAPj3dty4REbdnxkpssXPbkUNNp/ZQw/xTT4vNNcUSJZHIPVr+s4TIMwtkXdQOWi2yaRu4DzDhDGcsMswoDDN0ukPX0f07xOyJ94iu6jXpopUuLeplf0RA0IauMZT5aE4CbSpcpUvVG0zbRfBvTFbfVcn6tUpMOd3ypDbll3GqrR7bbutWOgD4MHmtNSU6/hrFRcx9h8XpworjmzRO5mfMP/bj+yAE9bLc5T1p1TSTtC33GRPD7jDzVvhf9Pmz6q+4w9jvkHskObJB2+3EIZGFJYaRkMQvOrefGpOeFbRupdNXqFtrco5mRmxvTlEIR/w9ahUTwDTC3DF39gNo45+7cSaTeaNYoJQTZkB9zOpikLP5Y/fFOnloGCpoWLy//3kaTkjbUSSSE0ji52fCPu1UyQ1RFjag3gRa0MsCjQhZtkfjVZnsR76+lp5cmkvYqka1zX6G08oAeiNzFfzwfuMppGeTlqwnEKhfVbtQm8gQl/8lEACD24hh/9CaXs+6WI63eXVoXiblaIHDaQNI9+FeYPxjd4aw34EMkbIMyjdV76Ds851eH/8MZDZ1wXMqKrqVkueGJ5uA/k3JWx13OTMydRVjozx5s8YBiUSl+tri9DgjkJn/0HiLpzz1jq0iEUNA0w76zwN41tI5BiQASVk1YIVK3sL/QShjMCI+W3VSWgPxBaI1R+8EBA7JzNv+YwxFpFWXK9MAROvjMDNt6wqfOtFQGjswV3Lp8rOC9i4kjARnkexxuA2dU3vhTz+x6tWo4dB2Gmq+sWKn6s0ILn521HHrRbIJOhz0AU7nogXw/8AgaKeTKNF4WzpuTqOMGG73YA24aQyEgjKZU9WbS83Bdt+o1kqapJPtQYajw30JHmTfLmcRIYHQ8kwXCkY/Ng0pEnvlCu21ocMQ+CZvA3QP/5/RdgRCKF2PWhleIy52kN
 pd9DXqb1
 PSNHVeQf5Gmr9lPGZDube4yuG7zhmkL6T//y74kkCPfDGr+nnhdf+meRv9WS+/Hw2hhEt8Xv+X45ZvIS+OxMMqVy4BgKidXmPGf7GxCfGwsm703aMMWh18fW1J9xDEz4X+zQ10jb4dLvmvS7JPGQHqKnU/MLTqB7fKq+YnCWejYdQc3mZ9h0Mzn+9gdzFE+I17bkE3T5/bViVc5j3mnfiQT1Wh7NAckaAfMKXzXyaHiDdUCFDfkMSBR4SqWCasl8PQJRIa1KQqMLPYWezQvWdgAXBeklU9wLVSgmiaLFw7ua+C6vSNZuYMEsXaAxSMTrxpYxmfiRlmH24PVUrC8CpaTX2kE2X5smY8mKmahlHAr6IJ2wnVLiVS5Bbc0tfX/tJdnW5z+QAKYfiPfCCrc+QrJn84Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 10:32 AM, Zi Yan wrote:
> On Mon Oct 26, 2026 at 5:40 AM EDT, David Hildenbrand (Arm) wrote:
>> The final scan in shmem_undo_range() restarts after a successful split
>> only if the original folio is no longer large. A nonuniform split can
>> leave that folio large, so the scan skips the newly created folios.
>> Hole punching then leaves pages within the hole allocated even though
>> they could be discarded.
>>
>> For example, a fault below the hole can allocate a 2 MiB folio after
>> boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
>> folio successfully but leaves the original folio at order 4. The scan
>> continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
>> The hole reads as zero, but the pages and their block charges remain.
>>
> 
> 
>> Restart when the original folio is still in the mapping after partial
>> truncation, identified by checking folio->mapping. If the helper
>> removed the whole folio, no rescan is needed.
> 
> This paragraph is no longer needed after Zhang Yi's truncate fix, since
> truncate_inode_partial_folio() returns true only if the folio is split.
> The function returns false when the whole folio is truncated[1].
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/truncate.c?h=mm-stable#n282
> 
>>
>> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>   mm/shmem.c | 11 ++++-------
>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>
> 
> folio->mapping check is dropped and the comment is adjusted after the
> patch is rebased on top of mm-stable because of the aforementioned
> reason:
> 
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 7cf5a4d9d1ace..ddea31f44fb32 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1477,18 +1477,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>   				} else if (truncate_inode_partial_folio(folio,
>   						lstart, lend, NULL, NULL)) {
>   					/*
> -					 * If we split a page, reset the loop so
> -					 * that we pick up the new sub pages.
> -					 * Otherwise the THP was entirely
> -					 * dropped or the target range was
> -					 * zeroed, so just continue the loop as
> -					 * is.
> +					 * The folio was split. Retry the scan
> +					 * to find the split folios.
>   					 */
> -					if (!folio_test_large(folio)) {
> -						folio_unlock(folio);
> -						index = start;
> -						break;
> -					}
> +					folio_unlock(folio);
> +					index = start;
> +					break;
>   				} else {
>   					/*
>   					 * Splitting failed, but the part in the

Thanks for explanation. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

