Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD11F606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwnkNvoo
Received: by kanga.kvack.org (Postfix)
	id CEC7F6B0688; Tue, 27 Oct 2026 06:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D496B0689; Tue, 27 Oct 2026 06:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5516B068A; Tue, 27 Oct 2026 06:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2836B0688
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:13:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2500680960
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:13:57 +0000 (UTC)
X-FDA: 85367995314.01.AE5183B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6BC80180006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:13:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwnkNvoo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793096035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcjnV7QS2G+aidrtUKihb76qyh+JC3b0hokomy9CWtI=;
	b=qJ9kaZ4cwyh7wkndIxcI73FBo8GQ1aHOX8G3b5VAoDYdaxNBMME1LzTf72aPoIMiAMeFDG
	vzudmOtvqnqZpi2CA2tiLT+5K3710HaLU7Ra+u9eg+nMio4zpae9O4p17fhJSHzrJm8v0L
	gVRgAY5PqZ4SMkm2mcPuzLt73AfZZJI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwnkNvoo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793096035;
	b=T7oMbBOov4NkjWZM8GE2lW6EbP3Mqt/QWJG/g2zrJrn0KWttkeKeWRCSy7sE6ZWTBlP0wW
	B24L7zccDilu+8j01HOY+s6ngdtbFm5MlIFWxobVBz0nTlBX87a4FjXm6c6+Si9JMXa/Bo
	yQbxRtDcEYiG1fCOCXt+5NHjm+wr1GQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F58E60052;
	Tue, 27 Oct 2026 10:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B261F01825;
	Tue, 27 Oct 2026 10:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793096033;
	bh=VcjnV7QS2G+aidrtUKihb76qyh+JC3b0hokomy9CWtI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UwnkNvoos1ek2AkU4HMF6xMMIsDgOXZGtVXxowwR/TRjQw2QGKWFVBS9ZULzArNQM
	 vKjbhEVbAE3XPTSOdy8+zQwqfOB/4dPDOtAjgwfFuR+DqJwgHcwlxraumzkxaHA2ib
	 Va2JKy62cNXxS5F+0zUgxeVYwzpiDA2KcmRzwRB7TU2ZGdFjSlpkYuldKxpsncjev3
	 VX99o6PmXSBPUsXfoGoG2H1a1zhRt2weS+QJK9agGdCjnbHxq7Z4JjPoHfP4VxU7MW
	 OUTqfd8SpKL3+WjGAgmochCxIqilm+wXLSmTgUwZQGbAORhAlqKbDbjxETH1txy4HI
	 +owiB3GFSMiyg==
Message-ID: <b45a3b54-2b96-4325-a0a3-508ba0227c16@kernel.org>
Date: Tue, 27 Oct 2026 11:03:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
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
 <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
 <DMF8FVCUYJ5X.215YGBLZ7H56Y@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMF8FVCUYJ5X.215YGBLZ7H56Y@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BC80180006
X-Stat-Signature: azjadr49nwpa68rzocgu78wdt8f9f6x8
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793096035-309735
X-HE-Meta: U2FsdGVkX19Ks/oHitT68W8xTDPOiq77WFUMj/VtffPbSlYMzk1MjyAvmlHjc8aTNnBgg0xnK9TVZmrBrhRrudtBp6vwY533B8FanWraLvINi37fnU0eOSEih7Jl697ByujtTSuq3nq9aZA5J4VnzDPsmh2P3wV1cpPbxtk3lE8Ck1TRq4Jyaanx0aRMXLpGpm7elxpTg82U8Kk/WAcoEZOpawI+PJ2LWmtGNUfnkW0ee1tH6ejZaulOd98Az+qdNKrkSYeKxhqan3WtZd8ng9dmDQhvNuN5itm0BXrr0pqyEw3rYj6uwl/H4pbLHrJYir4l2lFK62B7IE58aBDPCe6BoH+nOBMd436kLFcn2Q4IDqj0WxoE3GYmQlo/7cmLAqqeGtlZLsdkb0uMkkgMeSR4ChjFHIvzJJrJk4/1WKCE2Ie7C4QsCs/3Pp7BFNE9/OyLR1D7TGPQugxfL8MVjdEZsJuxz/kAriV73sAuuUDig3jIQPFU1zXqjsiPU7sicPQGHTAK7fD+7LUk8ti+phQCWtjQI9yVBW2h/MMxgsv46FU4d6Fw3b6hKEDSAPRICfgT3hoTOd3DerlFfj8cgV9+vACwERt/DErn9F+BtzWw2YcpEXgaiBTwG58zoxmkWo1E+JyLNMhj/eF6T2x8ym3oRNghmqvp7uHAp317nAoBwSkhmxw7HlB3FA08zC52jHskCbvjzfn7Zk715fngoQE4/EnBda/HyyyS918niDO8k4UNP3uFcJUFGyafOvQzap+d1PoAggmZtbSefgR8Qh4fV225Eyz3okBNpK6saEPrXFXUJ5nRwInJCfoY5edTSBlqwrZ76Ix3dX6dFqi0+vxGLXgUiu7kyM6qAdCww93LlW4wdd1lEuOk0NxFC5AzinDPkeOPZOMiODh5+rJWIoYx8JVHaZWWOwsycLQInAjW5eXXYLFJBg6ZFupZoE2ndTpPLXm0XJlaIufYDsH
 ZB+LCZ0j
 vCSm3VgNxUjiFQYV6F1dlrSe9rlTTFZsXUmJYPS6oBgRnAx/9Slh1pvugcL0oP+5j1e+KV4BCip4k5IUCer2BQJ+7BOBrXIdoyrJNmrgk5TsdrHhCPCuN7RjEJRIQizDfCIf9UvP+DXdBfiytQozV7gH/1aJUo+bmg82F/Qp2o+ekr1Nn97QGzM5y74Ux/xsw1s8nvp060iylTVG6nhL88P57clDJZZ+CMt4UraU0b1GTJ8xfqgTNXS9HcalB9BV1soLUhbE4MoUQ8xVUDyQWtK0xTxlGbGe7epB2r6TxzDQpNIb4/FycE8uMR+32SUDa5mpjhTC25dGFx0nk6Sdfq07bBPoGDDeOTykKtjm9GK6QB+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 02:34, Zi Yan wrote:
> On Mon Oct 26, 2026 at 5:40 AM EDT, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> A fault or collapse can insert a large folio crossing EOF after
>> shmem_undo_range() has handled the boundary folios. If splitting that
>> folio fails, truncate_inode_partial_folio() retains it when it is dirty.
>> The final scan then repeatedly finds it because it restarts from an
>> unchanged start.
>>
>> Truncation keeps the inode lock and ignores fatal signals while looping.
>> A concurrent unlink() can then block other directory operations while
>> holding the directory lock and waiting for the file's lock.
>>
>> Advance start past the retained folio, whose truncated part has already
>> been zeroed. Do not move start backwards if the failed split has shrunk
>> the folio.
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: split fixes, simplify descriptions, adjust comments ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/shmem.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
> 
> I rebased your patch on mm-stable, which has Zhang Yi's fix, and
> 1. tweaked the comment,
> 2. skipped the dropped folio (this is to avoid a narrow case below).
> 
> Since after Zhang Yi's patchset, truncate_inode_partial_folio() is
> changed to return false when it drops the entire folio. Restetting
> start for a dropped folio in the scenario below would leave zeroed
> folios still in the memory, causing a waste, although it is very narrow:
> 
> folio A=[0, 512), B=[512, 1024), C=[1024, 1536],
> 
> 1. A, B and, C are inserted after the same_folio block check, so only the
>    code at whole_folios label sees all of them,
> 2. A is split partially and the split failed, A becomes [0, 32) and
>    [32, 512) zeroed,
>    truncate_inode_partial_folio() returns false, start is set to 32,
> 3. B is dropped entirely, false is returned, start is set to 1024,
> 4. C is split successfully
> 
> After 4, index is start=1024. The [32, 512) folio is not dropped. That
> is why I added the folio->mapping check to avoid changing start in 3.
> 
> 
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index fadf23f9e21ed..efd54a624974c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1480,6 +1480,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  						index = start;
>  						break;
>  					}
> +				} else {
> +					/*
> +					 * Splitting failed, but the part in the
> +					 * range is already zeroed. If the folio
> +					 * was not dropped, skip it when
> +					 * restarting the scan to avoid retrying
> +					 * it forever.
> +					 */
> +					if (folio->mapping)
> +						start = max(start, folio_next_index(folio));
>  				}
>  			}
>  			folio_unlock(folio);
> 
> 

Thanks, makes my life a lot easier!

I'll change that to an effective:

diff --git a/mm/shmem.c b/mm/shmem.c
index 1a81f6dca7510..c263f02fe07cf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1481,6 +1481,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
                                                index = start;
                                                break;
                                        }
+                               } else if (folio->mapping) {
+                                       /*
+                                        * Splitting failed, but the part in the
+                                        * range is already zeroed. The folio
+                                        * was not dropped, so skip it when
+                                        * restarting the scan to avoid retrying
+                                        * it forever.
+                                        */
+                                       start = max(start, folio_next_index(folio));
                                }
                        }

-- 
Cheers,

David

