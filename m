Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909E6F99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE2B6B0005; Thu, 23 Apr 2026 06:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7146B008A; Thu, 23 Apr 2026 06:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB376B008C; Thu, 23 Apr 2026 06:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB3026B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:38:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A2391C04BD
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:38:37 +0000 (UTC)
X-FDA: 84689471874.24.F0F2134
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 715AD4000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:38:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NOGs+0Jr;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haIdrYWGrTuwiLse2hZYYcuWW2obGUZovwL6KO1WjhQ=;
	b=1pqeDpOsIISM4r9l740jOcAhirU2EbMV406+NQ3gKR2+ujNB6y1OzNgv00A4wJ/iwBbSAM
	4xzgDkSyLm8Sx7hVDIS+l8seHl5Ms93UCq1ag8U4mLK1aMITOKZWPytBEdhbNxM+ejV9uz
	aKtFThD+G10yCHjZWpnVmMxmeAOKP1Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NOGs+0Jr;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940715; a=rsa-sha256;
	cv=none;
	b=u8V/B/9rU/ODYo+U7YHpBZdNyl1rM4tPos9E0MYMbtGmlToZPsazclYHkpBx0oZKOyMVTo
	E/7vwQGnK0QGmQ45BdTyH9MrPxYCtWg1JgI9+FLQCQbGx0A/vQx/v5SyYApt/eD3qJLR8F
	KGImPVtuma6dNTQJ1heZ2ObiIUtpd6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 562DD40566;
	Thu, 23 Apr 2026 10:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206FFC2BCAF;
	Thu, 23 Apr 2026 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776940714;
	bh=OykCGngjeVXxh+S5FhihKYrlA0mMJyXZVqRb3yjbltQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NOGs+0JrJ4V2SyqOjrtFCQhLPr6YNzdn9bI3as6PXFB7UQwCHKiLnzRPHyEUcB7ZN
	 VKGOTXW/gkIMWlDZFdEi6oECp+yHwo4lAx3NokhIMuokGolZjyGr/nsVX3mbl/27Vo
	 v7/vhuCEqkUK7uPz7wPEiT6mcRIUBnH2DMkpiEu/tktjWePw9DsAs0KodWlI72iVDz
	 H0ITnKBGxvzcxasSWRZcfAXV5DGRFsTtMbzeNb5VyCC7xt43PWdQ0Qj1iPKl7saBqy
	 3FJRdZzjsfdBx5KUS9/me1V0pBiumh481fCG5n7UpmfcuKvquCsHIESxS8bpeMWIdr
	 KGrBrssiZK2cA==
Message-ID: <e0ed4524-36d5-41ff-8ded-ba036d6ff6e4@kernel.org>
Date: Thu, 23 Apr 2026 12:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 v5 2/6] mm/memory_hotplug: Fix incorrect altmap passing
 in error path
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423071911.1962859-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g3y9x6pg51rjeq6ayity1a17qxz5ui5n
X-Rspamd-Queue-Id: 715AD4000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776940715-184716
X-HE-Meta: U2FsdGVkX18nWST3RXTJlmtTud7JkW0Hlsm0NSw2m2187jwu1v3sael6xP875qkorOui36pXiJBtL2M5rIyeHD6UvqE0T1u8+CEQw/nBwNqe4dxwatt8SpAMvQCF/8/F5P/QNkd847AVvxJt1a2k4ybLLGSSh1mq1AiKBJ+c66n8yR4/D3p9pc4lG9Ccw12LAnKasRcwz1m+wZ6KOAaJiN0dzhKfkmDw2phJutx+CAqRr6IZncyYN2M46roeLqgjZVRkkSfCHT1zzo84l9h5F7mLvl+fDsAMuwGy2m5i8vdjBQ2LWtf5GYgCIUzrSiIOixuPz7nENITZLIfIcmdqNcTNKeE0OZckDz7YRfSO741aXI9cc7lQpV0V7e7Njgk/1Snz9Jkr3C0AIhh7AjMEeZXYgQRkGueV2sN5Nd2FZPLHLkIySoaCgFLxdjKbxZh7xmzSaGEH+DrzOG02BwxSBKXTKLs5gRH69nXyOgUZrjMXoSMobHYBow/ocJ+GteFYCEruNt1ML2VSaXO3lCd50MI0w0uwtA30Jyo8gWKfMdOW8E+HIejhq9M5h1id3SBh+e6Em9+x7IGP+mLZNXRf24qyFujzoiqPh0Ta8fM8c6Q1i2KrKPJWX8/+MsAfkaVZEvkPXYb2QB4g3s+TK3SglFEHBp8txF+DhkrRZ+I6QkKfn68ZLkO5GJXwyDhIEIlOooGIpWbwSzATORjc+HP4uMedcMeG130XZEobHL0V3ftFkXkYBk8BcCRFTdLw8/s9kHQAeFZGQ98GXg8HTrRtRRS3n9nkHIdyqrHS9Hm5o/7ac6P+VOO9rOkpsPgagzgRJazsnsCWEgqylTdWN9onssnPc+NaG2CVGj/e1xDsPNj1psD/E39LrLmr5Yz9tNEQZ0X3v2SKPHR6P+gKzRMR8tYLUhjRg/twvf6bdYgm7HDjGv93JCUoDqf96McN6Xzp2wxW7eU01f4yapk3h3B
 L6HOYMd/
 T66Vls59wDtfKrVYNFbRciY+lXuejQEk3wfz8pOggo652PR3eNiNbf0qK4Dgfd2Nu+auWbbJvxn+jdMZL4IkPSH0eihIjxn5akRKZKhSx1vup+jsyyeXr9Kul851fhxfz0LeU4DMbbJQ+iZsJ9V7yPHd2qdomwIubxehcz2mdw6jeiCZ1QQYHXkD9AxTPrmXtdmz093EdF9adb25dBNuogw/ZlefQ8SIxzgIfzz5KJk4TQ47Ih6AllsF2WRIHcHjxQIudXMO+o5VNhlBT+/tTIY4yn0Yema7MfHWx0VBhB0AMybcXeaXhjQhLBp4kgXzIhWzX9VT5cs6WSEpMqWrw25WwW5z4a/ZdVVLa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 09:19, Muchun Song wrote:
> In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
> with memmap_on_memory enabled, the vmemmap pages are allocated from
> params.altmap. If create_memory_block_devices() subsequently fails, the
> error path calls arch_remove_memory() with a NULL altmap instead of
> params.altmap.
> 
> This is a bug that could lead to memory corruption. Since altmap is
> NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
> system buddy allocator via free_pages() instead of the altmap.
> arch_remove_memory() then immediately destroys the physical linear
> mapping for this memory. This injects unowned pages into the buddy
> allocator, causing machine checks or memory corruption if the system
> later attempts to allocate and use those freed pages.
> 
> Fix this by passing params.altmap to arch_remove_memory() in the error
> path.
> 
> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memory_hotplug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2a943ec57c85..0bad2aed2bde 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  		ret = create_memory_block_devices(cur_start, memblock_size, nid,
>  						  params.altmap, group);
>  		if (ret) {
> -			arch_remove_memory(cur_start, memblock_size, NULL);
> +			arch_remove_memory(cur_start, memblock_size, params.altmap);
>  			kfree(params.altmap);
>  			goto out;
>  		}

Yeah, that's nasty. We should CC stable.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>



Should we extend the safety checks we already have on the other path?


diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..1c304468af08 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1402,6 +1402,12 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+static void altmap_free(struct vmemmap_altmap *altmap)
+{
+       WARN(altmap->alloc, "Altmap not fully unmapped");
+       kfree(altmap);
+}
+
 static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
        unsigned long memblock_size = memory_block_size_bytes();
@@ -1426,10 +1432,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
                remove_memory_block_devices(cur_start, memblock_size);
 
                arch_remove_memory(cur_start, memblock_size, altmap);
-
-               /* Verify that all vmemmap pages have actually been freed. */
-               WARN(altmap->alloc, "Altmap not fully unmapped");
-               kfree(altmap);
+               altmap_free(altmap);
        }
 }
 
@@ -1460,7 +1463,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
                /* call arch's memory hotadd */
                ret = arch_add_memory(nid, cur_start, memblock_size, &params);
                if (ret < 0) {
-                       kfree(params.altmap);
+                       altmap_free(params.altmap);
                        goto out;
                }
 
@@ -1469,13 +1472,12 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
                                                  params.altmap, group);
                if (ret) {
                        arch_remove_memory(cur_start, memblock_size, NULL);
-                       kfree(params.altmap);
+                       altmap_free(params.altmap);
                        goto out;
                }
        }
 
        return 0;
-out:
        if (ret && cur_start != start)
                remove_memory_blocks_and_altmaps(start, cur_start - start);
        return ret;


Maybe the helper should even go into altmap code? Not sure.


-- 
Cheers,

David

