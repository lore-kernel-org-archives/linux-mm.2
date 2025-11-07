Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3312CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C8F8E0005; Thu,  6 Nov 2025 21:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53468E0002; Thu,  6 Nov 2025 21:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69028E0005; Thu,  6 Nov 2025 21:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C516F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:59:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7810C4B25D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:59:33 +0000 (UTC)
X-FDA: 84082305426.22.C86BB2D
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DD64A000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:59:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gkM3biGF;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762484371;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRB1Tw7h2xkUcCCy6v82k8nRrxR/9OQEbGB4ap5uUfQ=;
	b=eMQJCvg2hvXBYfxbdJRisY3EB+4kFYY3vZt3qf+Y6Y+eDZwmg814rY0mtScdR959kmsbpG
	ZEuRcleF1Kg8JWHZfWvYVXQwIviqppWphdcy0MIgQAmSX++3Nyq3gpHFwVHLI2iSO9aOKx
	v7nf5QiRTSOr8Zjou8qpPbHRhmkaLus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762484371; a=rsa-sha256;
	cv=none;
	b=eUYl3AEwCInxQmpLF1JZUtDL5wCcJVXhWwBbDrhWN+BuIBg446kUPtAHKgWYoTE/W3fH0h
	4FVJ68fAr+L/KCEfvKZcibWXEzXMwSSZZfpjPPWEBFj/Fez3btUGk3Un6hSIjY/jzIHDXg
	/R4C+oBoJqZKe/Ibo/p3N4iQiPoup1U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gkM3biGF;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7042e50899so49975366b.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 18:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762484370; x=1763089170; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRB1Tw7h2xkUcCCy6v82k8nRrxR/9OQEbGB4ap5uUfQ=;
        b=gkM3biGFvSRJm9eUfBHFAojnX3quNFOtXAshLMxtzlfs5wNDZ6JXx++laGOlQ0EhMk
         Q1PpmvvDaHpob/Nlz52aq5Pi/iJ39Iz/eYK9Vc1qJziv4tDJ6EQM3tWat8IbstWy0Dpb
         hvlYF5sT3urMG7CzM4zbwCSoFWWHO0Q0G7jH6ALTkQl4R12FBFl96aVxosvCOQYoY+DZ
         Aj3MI7oKxxXZeOSFj2Xd2Pv9YxE+1y7a02Jpoz7umY9hEjwUqvv1zsq/Kvgu9xXb10xH
         zcgfWvHeMFJc3XR5iTHijd7J8teVMwILF4/+YiqOHu/iUUa4WaPs1ln1vCVxKa3oHCJo
         HcqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762484370; x=1763089170;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRB1Tw7h2xkUcCCy6v82k8nRrxR/9OQEbGB4ap5uUfQ=;
        b=h59K83QoK8GqXyfHUy85c0q+NjX4vW0Yloq4qJ1Y8OKnG+3F5JBDuBoiabhC5uXbRI
         WlF5mNzEchgxEYsXgL61EGCbVGN1cuKXkq90lor88FWCflu6jVB8Fterx8obDmh6Hvlu
         ZU2xirPNtZr9asFGb+eSuJWlCf+F8ufi/qPV0ow8JCTKfXlc6qQ7CBufyO7+rLS/GlM+
         QTwF6qm5HHi7rQvE+23Rlew9K9akY9nxCe9WxTqPGOVVT3/4DWlm7bbE1zW8fHDZglQC
         HMQKmQqfqvyc5ZQXFki0AmWFxEF/mZCDNRn/ag7RBYII5gSCuDNTi379SVKBT+To0lOy
         BasQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxSXSFmaKi5fKtERkinJ+2qFjTwzfFDJTe0lWq2YMJVVaGpuTtp55yfVkAEc6BHlGGqnnbknCSAw==@kvack.org
X-Gm-Message-State: AOJu0YztuGN5fgHkTcHVNXRcA/tkTdICuGslmdu6rPWBa/n0aMJf6en/
	iG2KgEGdq18AliMNMznocC3WZ4O4zoo/KSdJwhikfsydpgqTmb9Z8g78
X-Gm-Gg: ASbGncvCwCjUAmMotv4iBvVTQ1376U1ECRAE6lH6vX4tS/FwitVJtE6Mejkn9vZefLf
	7HYDfs9sDgwQrfm1yDkP00jYTwhlAautcDazP3clvBrZcPgeTIhDdvM9zaPj8EjpLncVyF6Cv4f
	I2Hlgg+0NdCnigct+6xOdhV2VkTky6DLPx3SV5bC2OmnAsla7IZW6hkhd8o0ZkneWjsVyCqcwb7
	hJKstB1D99DiBdeC8v4uQdkZNVqTkJEuJ0vY4Hw3ej4KqtV4hxf6KME28Da/w2qFynSAgcb5gxe
	MXbKvY0U4ecJN/OTyfiWMeQGP01vCprc+yLMsVArUUfC+zyrFZE/iJFbD8yRGOV/WWzxgc8aKz1
	JLZFhVFSA9L3+Myn+iHiIOH0b99/lKMwt1CmUF1+UKq/skfmWMvVdGKzeoCa/PszaQKZVBkaIy+
	8=
X-Google-Smtp-Source: AGHT+IFYQHUtWFRHWqFYpUOzfeOZKWLRs72LtDXtfw94FiLCK3pbE+9wjzmpCPK3XTLCfJO1tMrm1w==
X-Received: by 2002:a17:907:6d0e:b0:b6d:6c1a:31ae with SMTP id a640c23a62f3a-b72c0d30be8mr136231266b.49.1762484369606;
        Thu, 06 Nov 2025 18:59:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbca75bsm117386666b.14.2025.11.06.18.59.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 18:59:29 -0800 (PST)
Date: Fri, 7 Nov 2025 02:59:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, hannes@cmpxchg.org,
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
Message-ID: <20251107025928.fkevdc2ftewqrq7y@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
 <20251106145213.jblfgslgjzfr3z7h@master>
 <131176ed-8901-4a04-92ce-e270fc536404@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131176ed-8901-4a04-92ce-e270fc536404@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DD64A000C
X-Stat-Signature: k8wb46437nfbhki5odz4feqauapqtxg7
X-Rspam-User: 
X-HE-Tag: 1762484371-485565
X-HE-Meta: U2FsdGVkX1+1DTAhBnoo7PNijbwOhUs5cx/dRB4Rwxqu8h7EImOb+v0c/FKTbYFu6DD/Y/2ngaVBBUE1kNwuansLD+O3bz+e3xIrkptlPW78PiycMWTIG5nL1OOHWLRa3z6xqd50g+sG6EMvfR5PWEGweG5YMfQJ352tpg4/QyZC+7eeK23eemw16JZQq15U9xnJqWXSRgHtjcUlihZY+UPt2e45CK6Uet3cFPBPzJsApr148AhF23RMd6cM9dtfT051ZnoSEsQO7kpmOxNhMZelmBvQBYL2ZQSPlPms4fYRz11VNI3/yHA6OvXUCkpl+LizUA/06Zd8quwL945pMh+f+N8lPle3QN5tPOJyeGSBZG4ZT8ZnFZRPQexHdjHTEbldGS7np0VZz3qYLV1DitMCJSoKccvCFwuqONC6RUnGVgPrAkJ5z0JTnCvm8MiftIDZ/XTKzncRFYwg8r4+DVrJQaNo7xH9o+4yRHp5Lv0Nih3Y4suIyfOkJKawFpjWgq42+j1l1WL/nbPU8k7lQoK57RU6Q9TYD7zP1mk4Re8XH693JORP99sEa3rx3VU1+qBk69w0qAUEkQezYjZViET/E1yt3/fBhdgS7K2raUM4KMci3laV0C2okgVcgeW702eZKE2pJDJreta8yn8Uo1JGEfWgmfcfmKDqCr3HHGesul7WySCI6aKLXvNw93OMBy5UQ25auOpOkL+dtWahOAXrUVNR3IGATfKZZJ6uWwkEl+M9p4j8uBsHrYebJFsTvewy7Tcj2qG5fFJRkH9Jk3BedD9iIG9crnXC1+X5s0KrPlJVjXpdzHVKdkWP/WJ2gNrAlSsHtDpL0qKsv0fvlSOqcpce1d6eznK9Nt6JdYSfD930RZ6ZgrAcJNS8PLLoxPpzYkkZbd70b8HxnXIv3TnpjdVGwoVCLNqYEXSw5BudfuOv+EaE03xI0lR4lPwQhrJpBPVgXpHi4360Acz
 T0YOSGZG
 IcQpIGjGr0OJD/XYSYazH53Z40cJRvpOXsJinajTgZtMGbZ9Gua+/BrKqY5RijK7/Muv2VI3t1toy+VnXHGueFknQqew1Il+wVB9Mm+afmo8cnh8hED0uvgFAZXh0OyX1fX9BFMIMk8hKQ45EiwVIhkjqsoFA4rmXqzN9aVSbvS6gsvU+jqVFLllwOQS6LkxI/UFJ4NcrRqzv2Nvf9uKkU2rn/0RLGFmYEki6NAycLaFUOVQuwBIIpWfwzOq1Ytq65Eb0DQjAEw6kRfCyeE9zXeGCoV5HngiRLY7O7WHNOdZ4psfzFumV+fBmAAHIVGsz5CLibcJVaKaUJAdzFAuxA2yIUwLpMJU4CCEzoP0fGS4m1aS6CAH7sEFjKiRQiphIhJM8dOwVHS7980KeH7rsrk7j4zrGLZHFkSNLhAaqdkynPnDDR0wBBFgOFM9JNF8v5lwo0c75xIgJKM2+ml9BajXakYbRuZPrr8RXVrShegn7I1/ZeZYaYs9VrWKNwYlTRoearSbj9cLVzk+Co3XRj+IJ60JWU9BBPctj7AkgHBj+hasD3QynpSfR9Lx87/Wlm5LSG52heaRfc+/gAx5kdJ0lJCpbxr51hz6XFXkCs7FU3snYqCa0sWCc4b5Jv9O9SyyUlj4ATQ+DifNuj9blK/QucWLuka6+iPiftVZ/msz2DZJE4U5af6+Z+zifN7nx39HhkW6Y0eogIv4SjrvAHGPEgGZzYDwRZ7CgjwSGhz0xiqUhuwzs2vOdhtU0r//9UNIqyPPpNK6f6uMjJFOqdTqtGzPB73pVbYnjlR1h8wyLvKVhfLIVigQ0/hjiQijhkvCK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 10:51:15AM +0800, Qi Zheng wrote:
>
>
>On 11/6/25 10:52 PM, Wei Yang wrote:
>> On Wed, Oct 15, 2025 at 02:35:32PM +0800, Qi Zheng wrote:
>> > From: Muchun Song <songmuchun@bytedance.com>
>> > 
>> > The maintenance of the folio->_deferred_list is intricate because it's
>> > reused in a local list.
>> > 
>> > Here are some peculiarities:
>> > 
>> >    1) When a folio is removed from its split queue and added to a local
>> >       on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>> >       updated, leading to an inconsistency between it and the actual
>> >       number of folios in the split queue.
>> > 
>> >    2) When the folio is split via split_folio() later, it's removed from
>> >       the local list while holding the split queue lock. At this time,
>> >       the lock is not needed as it is not protecting anything.
>> > 
>> >    3) To handle the race condition with a third-party freeing or migrating
>> >       the preceding folio, we must ensure there's always one safe (with
>> >       raised refcount) folio before by delaying its folio_put(). More
>> >       details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>> >       split queue not partially_mapped"). It's rather tricky.
>> > 
>> > We can use the folio_batch infrastructure to handle this clearly. In this
>> > case, ->split_queue_len will be consistent with the real number of folios
>> > in the split queue. If list_empty(&folio->_deferred_list) returns false,
>> > it's clear the folio must be in its split queue (not in a local list
>> > anymore).
>> > 
>> > In the future, we will reparent LRU folios during memcg offline to
>> > eliminate dying memory cgroups, which requires reparenting the split queue
>> > to its parent first. So this patch prepares for using
>> > folio_split_queue_lock_irqsave() as the memcg may change then.
>> > 
>> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> > Reviewed-by: Zi Yan <ziy@nvidia.com>
>> > Acked-by: David Hildenbrand <david@redhat.com>
>> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> > ---
>> > mm/huge_memory.c | 87 +++++++++++++++++++++++-------------------------
>> > 1 file changed, 41 insertions(+), 46 deletions(-)
>> > 
>> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > index a68f26547cd99..e850bc10da3e2 100644
>> > --- a/mm/huge_memory.c
>> > +++ b/mm/huge_memory.c
>> > @@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>> > 		struct lruvec *lruvec;
>> > 		int expected_refs;
>> > 
>> > -		if (folio_order(folio) > 1 &&
>> > -		    !list_empty(&folio->_deferred_list)) {
>> > -			ds_queue->split_queue_len--;
>> > +		if (folio_order(folio) > 1) {
>> > +			if (!list_empty(&folio->_deferred_list)) {
>> > +				ds_queue->split_queue_len--;
>> > +				/*
>> > +				 * Reinitialize page_deferred_list after removing the
>> > +				 * page from the split_queue, otherwise a subsequent
>> > +				 * split will see list corruption when checking the
>> > +				 * page_deferred_list.
>> > +				 */
>> > +				list_del_init(&folio->_deferred_list);
>> > +			}
>> > 			if (folio_test_partially_mapped(folio)) {
>> > 				folio_clear_partially_mapped(folio);
>> > 				mod_mthp_stat(folio_order(folio),
>> > 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> > 			}
>> > -			/*
>> > -			 * Reinitialize page_deferred_list after removing the
>> > -			 * page from the split_queue, otherwise a subsequent
>> > -			 * split will see list corruption when checking the
>> > -			 * page_deferred_list.
>> > -			 */
>> > -			list_del_init(&folio->_deferred_list);
>> 
>> @Andrew
>> 
>> Current mm-new looks not merge the code correctly?
>> 
>> The above removed code is still there.
>> 
>> @Qi
>> 
>> After rescan this, I am confused about this code change.
>> 
>> The difference here is originally it would check/clear partially_mapped if
>> folio is on a list. But now we would do this even folio is not on a list.
>> 
>> If my understanding is correct, after this change, !list_empty() means folio
>> is on its ds_queue. And there are total three places to remove it from
>> ds_queue.
>> 
>>    1) __folio_unqueue_deferred_split()
>>    2) deferred_split_scan()
>>    3) __folio_split()
>> 
>> In 1) and 2) we all clear partially_mapped bit before removing folio from
>> ds_queue, this means if the folio is not on ds_queue in __folio_split(), it is
>> not necessary to check/clear partially_mapped bit.
>
>In deferred_split_scan(), if folio_try_get() succeeds, then only the
>folio will be removed from ds_queue, but not clear partially_mapped.
>

Hmm... you are right. Sorry for the trouble.

>> 
>> Maybe I missed something, would you mind correct me on this?
>> 

-- 
Wei Yang
Help you, Help me

