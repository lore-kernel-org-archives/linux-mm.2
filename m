Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9939EC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 09:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397976B0088; Sat,  5 Sep 2026 05:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FFE6B008A; Sat,  5 Sep 2026 05:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287496B008C; Sat,  5 Sep 2026 05:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010656B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:46:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F153402C4
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:46:46 +0000 (UTC)
X-FDA: 85179229212.09.CA65AE9
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF2BF40004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:46:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lZFsSHkM;
	spf=pass (imf11.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788601604;
	b=IXiOWMFUOAhqn2tQIJmDY60popaZ0bZr27oGcq0OOjfpKJ07t8FiCg6ZgY/HkimGdn/vav
	1/KzGV8aW6kHLtjFZ+d8rloyJuWWm15jAzcH8PHZGb/NP+Nx0xzZX63zICoLZskIifar8O
	eNuXXf/JIpFLffmLC0Aeo2Bh6WKtP80=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lZFsSHkM;
	spf=pass (imf11.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788601604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVsaUIOp3MDMERy1aS0TYMZktXDl9me/fb4JSc3XU3A=;
	b=FAxYy/KB3YDiS1XwK/3waqwjo5aKcsjX2MWbJ69TRjgAQkc9w7sBN7wq5sNrCgu3myhwVT
	vnecF7bm75MRMHHJUernpI3EnO8jayoz9d7SHt2yPifp/CFt9ClkI7avDwe8IC2Ad404OM
	nTG70SuSFONGJiSo1s/dz+rM4C8Vexk=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso1518449b3a.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 02:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788601603; x=1789206403; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVsaUIOp3MDMERy1aS0TYMZktXDl9me/fb4JSc3XU3A=;
        b=lZFsSHkMmNml8EAtM5EqxX9SQolh2nj/VkhKUlcCQRTf7qgpX5cTOFPiKPsbIUwYXC
         +r4pVQ/oq9vxXosEvcCB/pqGqDr9la66e2Mgip3Bf1zQP7lWGcFhaE9gYQ6j/9G3UF8Z
         FiES502mKyGcmHF/X97RmsGAub/s7EwcKC6KEBWtsvcEM2Hsdife3HvouGjJ5lc7HsMQ
         rehT9EG6EfcIvWphzc50TLVRUOXPxcwgXR8dB8PMMO3BTtY+eI5vrM9G24oblX6GHx2d
         5hEAQwU01cg3uzIWlaGsEw/66yawf33iv6zozsGmCNn5yxtXsN1Mx+bmRX5Qz96Xx0Qo
         XbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788601603; x=1789206403;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EVsaUIOp3MDMERy1aS0TYMZktXDl9me/fb4JSc3XU3A=;
        b=LPOFDiyRWa4aPPQf4RLiC61rRKP+1bA8vE2JDL0gJPlWAQ8D33zqQgDcqhWkfxwBM0
         NU1dlSJwuCXe6snw90dw1kBsDboAdMuWTlY7D0VTzF6HDAKsz1uwR2um2kdPoUWknF+/
         EQxDWo6yCwi7jDjLFoFNGMANm+JYNMRwOKIS9g270jb5iDmnapekUDPgXtcoWZttWd3z
         jFotKQGpZ8E6aL7FyvyA+rY+/Ll/H3e07ZgvPg1gYHQDkUukGR3nt7zVEUIibnL7eToh
         rxS1UDCcIaIZ53/KX6nbR5e9O6VqqzAFQv/SFKpjNsqGSAZIqGP5/TVRwAR6+PzI+/Ve
         1r/g==
X-Gm-Message-State: AFuF++mPnxLfvzXSsgF6YxxQ1uDfp59DQWlkdQHTIVozLslSIBX1HS5k
	hEd/G8fBVqUJqjFCXD4a88rkQJEP3esq+7FV9B87H7hqZePlL8f4Y9mx
X-Gm-Gg: AYBFou3ln/1lyljUxMeL7b1JXF/faIBaH8WN02nQljr1honguquyTWiYqVIdfDZAE/h
	7jEiav5AciRi0OK27bgByG4hqtxctBjkqFHdvxHCkyLGr7FLn0kkc45m+0BNsxAcSxlnIHZcja6
	9NmsnN1fS9EMu34d+n58TkaFzPcHaW77HxP4Z7e96Rj1IXnLq+Eo5p1DtLlcuccax5F/Pt6/3Wa
	KKxTveuGYWZAHtydllf4ra8Kgs1317tjChqpFhMrlrUquSCEQ0FKZyMqi7LYYYzuRk6Dd5h53JF
	aBo8e1gLJXYK5+D8vX84obBgtWvpGZCjFUB+/gHik/JsovbbuobnxHy+zj0iV2e2qPNvQ6f8Lu+
	6OpoXU+EpbIU3TjW3T34JqUVS/cwJdDba9JCil+sKhzCDIB+/+LDW+Tyr4oKU+9RF/HK2Osbelk
	/FjmmgIBFVjEmEpJifOj2t6AAgupADlh7kQ2Hgil7Gne1CJRAIzW1rgHP/MV96rkF1CGcgYvNIc
	ogztrMaIA==
X-Received: by 2002:a05:6a00:2187:b0:845:e440:d0ca with SMTP id d2e1a72fcca58-86166ac231bmr15412724b3a.8.1788601603461;
        Sat, 05 Sep 2026 02:46:43 -0700 (PDT)
Received: from [192.168.0.104] ([115.192.217.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45c62012bsm1419875a12.4.2026.09.05.02.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 02:46:43 -0700 (PDT)
Message-ID: <5555e6c7-5167-45ab-b1f0-f9a589d67f07@gmail.com>
Date: Sat, 5 Sep 2026 17:46:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
 <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
 <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jajkihinfu99ikamnsi1em1hg548jkzg
X-Rspamd-Queue-Id: AF2BF40004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788601604-551093
X-HE-Meta: U2FsdGVkX19QfRUgfX0tNgrd8Lfh7HZ/lwFhXkxNx6sAYKGd1WvXh9awBa9zGys82wIOWAgZgM2OwX9Vby5G/nR7+x78If/aRrKOOQi0Zi1sy8L5a50V1cz4tSbd8MDa4l9/JRJeDWIsDECuUoIkwRatR6IXsZsuOkqIQvve5cSg5+nBeeTFdmcXMPWciXzsTbRm2tMqb7NAZpGcrM0BCKjZSrsOgf6P8C1iVdDVmqADLnZrbz5wBFYR/Uz8Ee6i3lOPqv2xu0ViEOmFqtsfAv6urTN/sWa98eKVAXM7SXxerw3s/mlA5oG9Tq9rLlb9NrvN1nybL6djzmfiLTenABd+N1x3MeUX/0oYjNWIjYEY5gVQR6yVvYPizBMUAla3nvBaYe5GhhLWyKwd0EZK7t/h/ZNWiHoavogM9fm5sVc1DfU++RpEPkhhOx8rPUIN/RZ1eJOiMMze0fq4ei7/KiZROWsbCFdrqnTaaMo/pSLewJBuN9c0QTeGSqFQM7I8+jPu91v8RuepGlylgNqy/mWizKlBa2pCOTUXGRuDLc/Ibb2SLR2dO+kQPZfdqerGvv7gbpFqnNxgFmvXYAJ/LDgVnA+izhW8YzoFmG+vHug64Xh7Hw11vvtoeuh/UBU2ZoIv5Vk1fnw1RoMLPZUIfv/PBwzTy4XNxzmDnLMTbq8NxFall08NstQSGPm3PauA9rd2tDPhv/dGcOQocegd1uYxvKMw7tCSm7bFg7eD7e0YCGfw4Gzw0vqH7Katg9WUjVi7QRwNfgsmLo0SKyKubeFYU7LpO7O5O/6tcuRhGC2wzttyKe4BGxklgHae9xvCs7nuxvJCoT7JFzTmlMAya4YjW9p57vpxr4VYtaGAH6rezXDC3sDEvvH/4yBxes9v/D7xz0E/YAm/bIAc/SUMamBxetlIKB34BHsJVy79smHEUZYq6dEfDauPFx+NpffgwJVrCGg5v9ExCATkLft
 ISxKtbyF
 P9RgLTt7jvhX3Nvu04aOpFhG4WOLPqmrvXRJLxuPRLtXFGTw6JqXZTU/mDUF6pgI+z8NTB7JNF9e9Clo+588c3+wXfAX8LjX2DaUUc7Z8waAdavFUvymP7UT9yPcEjV4C8ihtFgu3SFPusjUDkZCoLkt7ka9S63KBVn8vuzmQpC/3eOYhQHrOXSmLweC8uCMggXqWT5QUgZUidkaqqKPtgifofbd6LBy0ZnTiGLLGxLc9Q9+P7m8DAKIS/iaQiZhEz+HpWIFOM8/rUSEEhoAvcjYlBxXZL5hrZjsn7cB0+1TGhs4wUXk3QZrH2QQLESCMVXo1AP81bYEVlewtlVCID4qhfDG8sn9wc4tkSN/F/cf1BxkurjdhYPr9PoZpHbETjjTSlHk3BzTYL7IHEukSl6Mt/cyh60MUpH8zkV5cIefSz4x3DNdBROEw9qKkXfgLIEAlO6fQMmJoEKD91ZVJhLD+yXEH1qrsrRjopqpXgePlORH0LZvlZNWXaBG4Lw8rIjlZDJtS9d1fbuLZ7hoAIyc90YT68sOU7Ryo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/2026 1:33 AM, Joanne Koong wrote:
> On Thu, Sep 3, 2026 at 11:27 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
>> On 9/4/2026 3:01 AM, Joanne Koong wrote:
>>>>          /*
>>>> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>>                   * for shmem truncate
>>>>                   */
>>>>                  struct folio *folio2;
>>>> +               bool tail_isolated = true;
>>>> +
>>>> +               if (end)
>>>> +                       *end = (pos + offset + length) >> PAGE_SHIFT;
>>>
>>> If I'm understanding it correctly, based on how
>>> truncate_inode_pages_range() uses the end value (eg the "while (index
>>> < end)" loop condition and the find_get_entries(..., end - 1, ...)),
>>> end needs to point to the start of the folio if the tail folio from
>>> the split is a large folio, in order to exclude that folio from then
>>> being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
>>> calculation here, does that result in some cases in it pointing to the
>>> middle of a large folio? Maybe some logic is needed to make sure that
>>> it points to the start?
>>>
>>
>> Hi Joanne,
>>
>> Thanks for your careful review! I don't think that case can actually
>> occur. Let me walk through the scenarios where the
>> (pos + offset + length) >> PAGE_SHIFT calculation is kept as the final
>> end value:
> 
> Hi Yi,
> 
> Thanks for your reply and for walking through the logic and explaining it.
> 
>>
>> 1) offset + length == size:
>>     The truncate range aligns exactly with the folio boundary, so
>>     (pos + offset + length) >> PAGE_SHIFT points to the start of the next
>>     folio, not the middle of one.
>>
>> 2) !folio_try_get(folio2):
>>     The folio at that position has already been freed or is being freed,
>>     so there is no folio in the page cache at that location. The
>>     subsequent find_get_entries() won't find anything there.
>>
>> 3) !folio_test_large(folio2):
>>     folio2 is no longer large, likely split to order-0 by a concurrent
>>     operation. For an order-0 folio, the page index and folio index are
>>     the same, so the calculation is correct.
>>
>> 4) folio2 becomes stale:
>>     The same to case 2), folio2 is removed from the address space, so
>>     there is no large folio straddling the boundary that needs
>>     protection. The caller won't get folio from here through
>>     find_get_entries(). Using the page index is safe here.
>>
>> If a large folio straddles the boundary at (offset + length), we will
>> successfully get a reference via folio_try_get(folio2) and
>> folio_test_large(folio2) will be true. In that case, if the split fails
>> (cannot lock or split operation fails), we set tail_isolated to false
>> and set *end = folio2->index to point to the start of that large folio
>> since tail_isolated.
> 
> The case I have in mind is the case where the 2nd split succeeds
> (returns 0) and tail_isolated will not be set to false, and *end still
> gets returned back to the caller as the original "(pos + offset +
> length) >> PAGE_SHIFT" calculation. I don't think it's guaranteed that
> the split will create a folio that starts at that page.
> 
> The example I'm thinking about is a 64k folio being truncated at
> offset 0 to 36k on a 16k blocksize filesystem with 4k pages:
> *end = (pos + offset + length) >> PAGE_SHIFT = 36k >> PAGE_SHIFT = page index 9
> start: [0 - 15]
> after 1st split: [0 - 3] [4 - 7] [8 - 15]
> split_at2 = 36k / PAGE_SIZE = 9
> 2nd split will try splitting [8 - 15] at split_at2
> after 2nd split: [8 - 11] [12 - 15]
> 
> in the truncate_inode_pages_range() logic, start = 0, end = 9, so
> find_get_entries(..., end - 1 (= 8) ...) returns the [8 - 11] folio
> and truncate_inode_folio() will drop all 4 of those pages (including
> 36k to 48k which might have dirty data).
> 
> Do you think this makes sense or am I missing something?
> 

Ha, indeed, thanks for pointing this out.  The second split only
isolates the tail when the boundary is min_order-aligned, otherwise
the straddler still remains and the valid tail gets dropped.  So this
problem is not only triggered when the second split fails and I've
reproduced this scenario. :)

>>
>> The page index from this setting is only kept when no large folio exists
>> at the boundary, which makes it safe to use. What is particularly
>> noteworthy is that for cases 2 and 4 above, aside from setting it to
>> (pos + offset + length) >> PAGE_SHIFT, there does not seem to be any
>> better alternative.
> 
> I think if we just rounded down *end by the min order (eg *end =
> round_down((pos + offset + length) >> PAGE_SHIFT, 1UL << min_order);),
> that would ensure end is always on a folio boundary and can't be
> inside a folio.
> 

Yeah, rounding *end down to a min_order boundary looks good to me.
I'll update the patch accordingly.

Thanks,
Yi.

