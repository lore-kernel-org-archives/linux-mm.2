Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A65C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15216B008A; Thu, 17 Sep 2026 08:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6646B008C; Thu, 17 Sep 2026 08:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5066B0096; Thu, 17 Sep 2026 08:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 910866B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:32:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FA291A032E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:32:48 +0000 (UTC)
X-FDA: 85223193216.16.2FADB9D
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf28.hostedemail.com (Postfix) with ESMTP id 47180C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:32:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQu6iV4r;
	spf=pass (imf28.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789648366;
	b=GrVlQp2flK/2yd9LCUJNgPLzX1ba/Ql7nnsQP217WHaKXtpxfDBiLlh0DK6gfcyH3b699v
	WaQBERd5j4kNZ2u0+NZpr4am4s9tdTpCkWac/OJYVJ5ln2dnFlXKQFHY4NF0wwoOlg9NY1
	ec0CHi1VSeRQZ76qedvjrRypJQSwrTg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQu6iV4r;
	spf=pass (imf28.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789648366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pX0fdZFc2RLefcqbAqYKYTVdyFNxhnyETiiYgD7pF2c=;
	b=JecEtD+xC28KocNPmdn/h94v7McO778R3f01NVene56tUBrHzUMdqZEfE0ux5skc5Udb7w
	LV90g00ueRNGIRQXqCWvdIHVC8Q9APmJLEdqlN6Z5GVuPq3ucu8qoHwL4ItxbZodBYhqtO
	Ze6Nu6EeM0deaZUbgMEq5v+ZVv+ezmw=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd5cef0so551500a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789648365; x=1790253165; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pX0fdZFc2RLefcqbAqYKYTVdyFNxhnyETiiYgD7pF2c=;
        b=JQu6iV4rR1rHBy5doyrBeoAg/ijWr+zFXcy646NtKaGAkxnayEbJdUzSxyFXxPPn4o
         pkyiA23621xIi19t5LsqQUmNyRCteOuxKRkM0OGC0rmlSoz1XnK3PctfYs2VVw/sCItL
         fk20LJogL5MBLUgkzMUC9DdGovr2/LHwWWP3lJIDsEIfYmh63gELQpmz+O7/1TpXUE63
         8G8693tfHVN3iTVcDU0RYkGZ4Um608QE56WFppmY25gGVyqRG5ZkldH+F56iT0xguosj
         xTPosU1G0/qKWBBgrHR+HYP/Rq9gARuX2LXrR7NiYgAymTZKYNJXT2bI9ta/5WE1TRA4
         +0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789648365; x=1790253165;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pX0fdZFc2RLefcqbAqYKYTVdyFNxhnyETiiYgD7pF2c=;
        b=nNbF2mTMja7bopypTo2Hu8pliU7HzWl+c0olgv8+aC6zDFFCFwqZY7r3bQkWwqcVyZ
         /RL9TiU/xcd9sFUn37OCPPdq4q8toJ0RJEc7hROQP+hDzPpf6+l/Ys58/Mj7CzRbi5BC
         SO/YJMidMdw96EUw1mnRwKsvkY8wS3wUTj11gh45GNHBBo2lraHpwiig/5O68ZKQa+Fg
         t0ZiAKAy6pSzUxcpiCcDuYbXblpcACds5j7c3SxtebkqClRKeA3f6ifXqHIBkluYHWxS
         0PFYqpiKXpO9TF4dGWO2Cki1ILnCZsGRkWRGp/PkTrDND3FcZoyc8LzrWLbCZY5J5qWi
         ueUA==
X-Gm-Message-State: AFuF++l1NhWaSL1G0YjtBxagJybebM/nNjoR5q1+SW52eJV8QbHBC2N9
	ANdDu9T+CQ5Ifk90aKtfJHCMFkFtNTufOO3E7bVqihJlguHreuzUQiCG
X-Gm-Gg: AYBFou0Mtm+UuMj07p2ueuEtJPZ9nBDQgsKlOYMuslZTBi1Fwg/CIHB0vTjJS+e6O9g
	U3PoMhBY4gArHenZdjr31Kji11WcAyVhc9vfOFNY22veeLGTAHVq60y+eOUtFuWs7Fx7gNTAE2u
	SY9wcErm/Q0vDrwrPcNj/h+bMmVAUAqUIdihnMpr2JF7bxjQHeSY4x9exIxIjXfdU0A7gHiUWAy
	Cp2z1IC99lu71ZGwUFFwJIlpou9XWJR2Uq8LJGzGOEK80FFpiXKHwi67vZ8rLZPMxkOtYUnx36w
	xbiHsF1jHFeZTJR867pFtFBEuNJA8Rey3olPvBQnEmvh1cPVAF74BcmZIaYC2ZykNJsYVRUeQES
	vNGmgMTEKOsGLh4wUq/eH6qdsnTyTT8TDEmGlEhj0glaj5sqjV2ebg99UpaHGcDGPAnOrUSZLr/
	XTmRPcRgGtixgimw8rTGJgtACLG2FAGFSPITPUHJ/Nfqd1PFOC7ZFzhyHh9BLEGkLYVWaP5AJD3
	gdxrhImd1UdbyV76kA=
X-Received: by 2002:a17:90b:2c86:b0:39e:4c80:f67d with SMTP id 98e67ed59e1d1-39e4c80f73cmr236031a91.28.1789648364901;
        Thu, 17 Sep 2026 05:32:44 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35d9869csm5164981a91.4.2026.09.17.05.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 05:32:44 -0700 (PDT)
Message-ID: <997ebbdf-efc9-4dc2-91ee-254c66176c32@gmail.com>
Date: Thu, 17 Sep 2026 20:32:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/truncate: align truncation boundaries to
 mapping minimum folio order
To: Zi Yan <ziy@nvidia.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-3-yi.zhang@huaweicloud.com>
 <DLH1V7L6ECGU.3AIRGWUODR779@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DLH1V7L6ECGU.3AIRGWUODR779@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47180C0002
X-Stat-Signature: 8c7oufsa4xtr9xehwarey5w5pwo19kso
X-HE-Tag: 1789648366-611973
X-HE-Meta: U2FsdGVkX1+A1qR96SYrTwF/LUcrmriqll8g2oWVn3d4iLGRkea4rTxbOt8zQvTtRwja6w0LeCesd3LPIIltyrC3JYZoFMS6uUhq8v1iDz3N2uJWK6Vzd8HoHuGVyYNq6sqan86Ey+QgYpZzzvL6yzTZ3j9kZaaSJUEAY3Gf8JxPul9VLat94WZXFYAxWdRCd+hn2YUxonPv1cDKEaKjBnQbqauygzDFlU3FjO9Rnfy8rtE4jwHgcTTDwnSr4GJtENhijc5ZTBJiA6+oXobPONc/A98JVe1tlU2I8XyRM7v4MN4a2tmKv5gt20UQPgVF7zm4z5WaAemtm//OHzY40Ef+pPi5shlY2NUg6o6uQe79erXtwtpKUGVR6Bo+zKLKhjaLM0u4rMFPgPJju2g+J3HYTb8Q9hM/YvXy2B7C+rPMTaBhkteLPllzduSduRyIOc5d/K4gY3G3PaHTCAAlePlb2pMnEEAUgQRve7ty9S3JXofPoox30CrIY38gRV96ELa9t/1tyzcQCbEuetNDj6OjS+kmyr4X0R4qUwvCPZJ3hTxfmzKh08jQWQw4zcue1UfUak+QwQ+8zu+xkGd7N6kSohAvN7fJXP13gYFIe+xkqsYqoLum0NWkuB2uIRiT+1f2WZsiZASDDqyZS0DB9kRH1+X48uYlvaRFpjuJNw7tA+na3zvTnu2+L218ia9Mbflk73TifJ5PWJtMav2r84KUlkwoLmDU0OR47wa7oKINNM2djOEQF5m/eOcFGEXdrEKFEmRvnkFC0hz8Oo5cP4aqlDnNiF+2jaGoi7cW7dLUknyHyiUa5KgbC28xB9vZ18r2qnNg8aXJ+LWIX/GkwC0Gi672dNAp9ckRM0fLQKQ4RI+E5Bed6A/fQfle5T6r77c2qoSpxAAY+1geDRjVeLR1W8PCTLcXPjiWSiGbhUUs7+3ftFiFAndhm4CSayXd/NlRfTE6JLDQoUmTWGd
 JWe3dpJs
 E2mL8pv5OXIaEzayWXqIMctbxuenojbE+4cWIF4lxUVZaZNdVLM0YKgJsT0RbP8QsP3a3/POaL3yGXDKhZE/CSvvyVDky0HTj4r4n6VZi/5Rk9GEbCInDji5que2+p23/QwVIXmgmmDaUQoj74dcl0oX3wd0mqVnY5drERtp3WLbPTzqT1GqR2TQJqFs9So0VeqcsRGgS+nVR3nKuyTG7s0O558dBonzP4xowduwNoX05QfQt4FrQmxr8L1c5yV/wltl9mA3VRu5xOzJ/UbkdFPp/tNuMb2rr3Jovu88edwxIgectxG0emlsv9gizM1Yhh4U7duZ8qUmc9Hc196xIJ8jN7kPeyAz5H4HEzIad0Q4dR2io58dzT+c+7zNLpekt6FP4d3gOLw4LWvSIQpPf6EHHeOr8OLE6OzG2/Bc0H/ISoDFXqfwKJ0xAViHLjPCM2W63PSw3O0vWk+ZoNWvT/twiyzHV1xnHQ3P+AtoR9zFFbqBMAym3DNrwcqdY0quYvftf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/2026 5:14 AM, Zi Yan wrote:
> On Wed Sep 16, 2026 at 5:24 AM EDT, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> When the mapping has a non-zero minimum folio order (min_order),
>> folio_split() stops at min_order instead of order 0, so the sub-folio
>> containing a split point stays aligned to 1 << min_order rather than to
>> a single page. The original boundaries were based on page granularity,
>> so either boundary could land inside the min_order chunk at its edge,
>> and the truncation loop would drop that whole chunk, valid out-of-range
>> tail included.
>>
>> For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
>> offset 0 to 36K:
>>
>>    split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>>    folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
>>    2nd split of folio2 -> [p8-p11, p12-p15]    # success
>>    end(old) = p9                               # BUG: p9 inside [p8-p11]
>>    loop truncates ... p8-p11               # p9-p11's valid tail is lost
>>
>> It has gone unnoticed so far for two reasons. A non-zero min_order is
>> only used by filesystems with a block or sector size larger than the
>> page size, and those either always write back the affected range before
>> punching a hole or truncating, or they carry filesystem private data on
>> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
>> fail and folio_split() abort with -EBUSY, so the folio is never split
>> and the old start/end boundaries remain valid. The bug only becomes
>> reachable on paths that truncate dirty large folios without prior
>> writeback and without filesystem private data, such as the upcoming ext4
>> iomap buffered I/O path.
>>
>> Align both start (rounded up) and end (rounded down) to the mapping
>> minimum folio order so they always fall on a folio boundary.
>>
>> Reported-by: Joanne Koong <joannelkoong@gmail.com>
>> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
>> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   mm/truncate.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
> 
> This should be the first patch, since Fixes is older than the one in
> patch 1.
> 
> It can adjust start and end in truncate_inode_pages_range() instead,
> since shmem's min_order is always 0.
> 
> Something like below.
> 
> Am I missing anything? Thanks.

Yeah, this makes sense to me, thanks for your suggestion.

Yi.

> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..803ee61ebf624 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -374,6 +374,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>   	int		i;
>   	struct folio	*folio;
>   	bool		same_folio;
> +	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
>   
>   	if (mapping_empty(mapping))
>   		return;
> @@ -395,6 +396,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>   	else
>   		end = (lend + 1) >> PAGE_SHIFT;
>   
> +	start = round_up(start, min_nrpages);
> +	if (end != (pgoff_t)-1)
> +		end = round_down(end, min_nrpages);
> +
>   	folio_batch_init(&fbatch);
>   	index = start;
>   	while (index < end && find_lock_entries(mapping, &index, end - 1,
> 


