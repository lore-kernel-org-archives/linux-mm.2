Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11406CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 00:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A908E0006; Thu, 16 Oct 2025 20:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB6D8E0002; Thu, 16 Oct 2025 20:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBAAF8E0006; Thu, 16 Oct 2025 20:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B52BC8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:46:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 546F558B9C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:46:16 +0000 (UTC)
X-FDA: 84005764752.09.5EF35B5
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5504820003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:46:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TPdmNRfq;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760661974;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+B/rNIxGB0E8lYNQb7e+4S76Mddht/U4IBaRSdc7uX4=;
	b=7VvSDVinmWMBcKVIz8uZIvU9A71hNuJ0qVhjd5WWcqwhjHhZ5BHzTf6L5e5JEvR7w79r9J
	kB8fbtv5tuZ+DKl3ZO7kcOeUBp8zMfA2uqI7gLgulPdjLGrNuTB18C70aexZXPTdhQqDpO
	S63AK6zwLxr1CSRLmvurQAhFMN4zz3g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TPdmNRfq;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760661974; a=rsa-sha256;
	cv=none;
	b=08p2tmPiwtZMj5ya4f1HaZ95rtRgn9j7FtVSdK2PHcUdvrjMW+xMBKnDM2YngItunD+pCC
	lQAJMveKcwkzw0EerxLL9GyyGv7Y7u8eKIPcdlxqzzcjafJPoIpPaCBsaED6p5OqPP/yZQ
	EKOqvcPu35tUHQ3cVPyiF1nhMq5tr28=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63bea08a326so1815292a12.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760661973; x=1761266773; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+B/rNIxGB0E8lYNQb7e+4S76Mddht/U4IBaRSdc7uX4=;
        b=TPdmNRfqcCZ3g0NL5e4VNoS/QeUPF8XCzt7F25/X9asqAGivmhmyg1IdUSudrOsM6b
         hcknCOQn/owVS7sw1Zmd+G1U0mFNJLzMJEyw05XhcrvezjuT6lKzPnwG2qMJZ6Cgr1uG
         XYupYzMeGI8o+dtA8kK4JTxrZq6jkEoGQSnBkuxr8wz1AYLvLO135AhRUPWfSLYGsX9b
         qg8Ds2BtigyqofaVNO0ivY7XyzILD4urUNK7houqB8/lQlt6GXTIe3uaSKNd8LGzagSz
         kyUuNiFpFkvFzsU1YLPpNk0XXPlnN4RL4hMhxLQVbztiDiOO2vRhMYWgyqDW2YkoD+GJ
         DenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661973; x=1761266773;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+B/rNIxGB0E8lYNQb7e+4S76Mddht/U4IBaRSdc7uX4=;
        b=avRE3ciVsT1o6UisSQU2TRfKBYPddE4WfY7Wpe0Cyt4YCes4pbhELiqgvpi2dR8y9a
         9GjcB214ALgGQXy6eni+ngyi3Q1U3r9PTXxCsvydM/KQawR2HNMUI6SyWcvYkvT8lICf
         pBDwtOE1kkz71ylpZAEAL2wPWOuXbwR7SXgzh4NPEXuFinmfWx3l20tAGYl6VLM6+/Jz
         WYOjJiZxf149g2D/W44VLBeM0LL9p/cJmuvcf9IEzoHSNFqUAXtH1wNrXiPN3euGN+BT
         0h3CyWXylnRz148CON622vQ2VnAOGZfbNrFv5R6THxOpp+qKwB/c5KNSNYzv+a3bfygx
         NuqA==
X-Forwarded-Encrypted: i=1; AJvYcCWrEjhvau0Ncl2A5BqfPIq66u6jo5fO6pawZuIAyB7RjociJ+DyFjag8Q0Ou6U2e+JTdgGWLvEcyg==@kvack.org
X-Gm-Message-State: AOJu0Yzglu0WQ9LLRohCTJ1J2CE+qaBg5GKoGwkuqRH3Z9nrlEUP7Ia4
	aXZrNON+rQr2hppq07dHUjxRYy1JoZtYBP5+IF+GD4bw8F1x2AdRppm7
X-Gm-Gg: ASbGncs1yuJ8hXg5fauzRrrcYMQ9TOQYPjyNyaLtFLCZGc1Rf21aIkgpqg3MuultDvd
	PbH66gpVixSZ8+dFU2ZuSu/Sx2ivx4TQwbRiEUWdp3Z0xlfW2UMqQp3yqb9II1pgZx/MZVvmBW1
	GiY42MX8fQihi3cuVE9uE4pMdaqQ3866uUM+1Q8A2RNqQ6PIBD0a8qKMCUkRhrOjgI+pFcpMrdX
	41a+KcB88BMpm387cueVQlcISWoI8ToB5SY0YgGOe5fbz7D+HVpbLrSH7O9DUAvSd4dklGqpi3Y
	uVh3eeAptpeb9N22NcxmCdiHOXxtiKGKu2BEpscz9UVp0YQQtTxeb72t+G7soEsYObRt0cA2OXv
	EqZJV7M28yCmQselXIlv8MfGT009XMzMSk+SeazZ2FBFMgtyyWDDvfMm3glLW11935dtDt03WNk
	RgscFDS+WxAjyKeA==
X-Google-Smtp-Source: AGHT+IHIrzM9nmQS/QH3e+TBJNCq5g1hcZGI45fz5wnzA+TbcN3hecCz0LjMxm3I+m+5Dg3KP8R8Xg==
X-Received: by 2002:a17:907:3e85:b0:b3e:8252:cd54 with SMTP id a640c23a62f3a-b647395033fmr219806766b.32.1760661972374;
        Thu, 16 Oct 2025 17:46:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cba06b7f6sm689297966b.30.2025.10.16.17.46.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 17:46:11 -0700 (PDT)
Date: Fri, 17 Oct 2025 00:46:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
Message-ID: <20251017004611.ccjq2343v43mimqq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5504820003
X-Stat-Signature: nad3141cazforxzsfy8e3hnw36gd63wr
X-Rspam-User: 
X-HE-Tag: 1760661974-802247
X-HE-Meta: U2FsdGVkX1/anmD/Lxadn02HeSmh33csGcdtetOP4vcZcoObgq9JmsS4GdwV4Q3u4N3eCfpK+at1wViV1D2ZsFdcQBgTn2hcXO1cfKmoT6qIeNP+1KWo1k5Q306fjn5Raczsl0gXstvgJpndh8JTULtxjPwtxw309seToZTqFUdsGq0RgIdZITbxYHBSzNhaNXvQFqauH8foroay9y8HiXSCtJkq96EE+w6IOOYKdQSSxJAg2T/ItIrucSWM1P6AJ97SH1JqmmS7Eyk8FxhfKMxrc7u2ze7rfdbRFhqQbTJNaBRygfKe1+yezzUuYat3sZk08FCPE31A4PUfkZUXYn4/f95zo4Cu1tuP1aMemOsoK73FW+bw/XsmHCN42VkHFLzQ1xB2AUGgvAPOzk23ZJlAXWPmHoLmv8ApWucO7DiDn0bizaPV07yG/bS909O+VFruiwSxwOBmTYDczWHHGMohmWDQGqxHl1CuSSt461cSIoaHAqxfigFsQEjwQ9MlO5mI+TPBhYCz2eovpPVK2q4/1UTOjFbsd0yMxVIOgKcYuA+WJL8eoQmpl0XYgsmYN3XCj+KyOJznAWf+w+It1OsUWA04k5p9ax36sKmwC3d/bsEA5i+oxsK6VJ+phVoeW5Z25rYkK37G3xjVGGI/0kLx48TKxkkuHv6Gsljx7wnOFC3a+et9S7/7bChaUDhJTPvm06LMlL971MDg1CLZHNzPLzm84b7BqIsPXh0eTn1UeZh2pbIxwbuX5bZRsIc+uCJTvVt0Gecn8AF+vjjI8kzrW9h9Wa5F1qPk1l1iD9k4YWQ7bMajrRGu9cd+1836ILs3LnAE+TBw0LxSp8GBaLZ06lmLCBtl0RKTZTO8GY3siPN3LmNgZjMXLgZyWb4yIxFAOTmO+ZWXkezbQC+/2D/vT5SIrFRRPc4JC4mEl8kOTwcomtIcZEBijT8cD1p8nZEZ9p+YD3iRm+hRLmG
 lLmRNhjA
 CAvxG1/FpC4Zc9zdoo8OZVwo9Zr1CvdAQjVCRmSiwl25Y+j7xvztgRqSYOXoYf/hQp/2W5MnAqt0QB24bV6+T9DwXg2jYxjf7r5GYX2J48UoeaB39EgC6Nyb+NjUEqy2meOxGSyqKAdiXOlHFFW4SgvwW75VMtFcwjPbf+nu7YHH1hbqx0Prsd+yFaSdqTv5jVp+jdyYI4oSBRznw3OZDAugQZGNv2vqKCes59oxIlYqQ5s5d+VQOw5s8f9ymZP1XiGCn7tnQAdq6+MKYwRzNsyQ4Cptg0o3Wf1Xmjj5E2Ycl/jd/H7flZsNdVmKzkNOxEyUaWexDMjc0KpQZw0dRa96MNpe9sjbnUsqeoris+MABZccKNaCVdd9XMS6G2cjlevHYPrNerC9x+Ep5WrRZFn+LIK5GzaqIgIUxqiTeynummI3BugbHtA99gr7KaMvGJe5TE19R9kloRFbBflESbGr04svBy7/ah+yVOqlDHdkRovcuMmzPPK+BOWog0jzsPWudbNhIMhcJk3gM4DPWl3oo4XPjJSJaMirSeDK+0/9L2F8JI5F+KiSIxr3kYHCPNwFbfgiHzomV2MD0mC0MWV2xoHZyo9mi9TYJPMQyYUSSeyzm5YbPHUDeQ+Q0z91XnhR3UROVdG5xPZqyi9WXPpf9USRUSbhonvltfoHR4wfWJxPcA7P78PRICI3RGgAtzNLKbCPlc5A6F/HgwlajEefxeOOGTujuswaLRb4OcVJEYJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 02:35:32PM +0800, Qi Zheng wrote:
>From: Muchun Song <songmuchun@bytedance.com>
>
>The maintenance of the folio->_deferred_list is intricate because it's
>reused in a local list.
>
>Here are some peculiarities:
>
>   1) When a folio is removed from its split queue and added to a local
>      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>      updated, leading to an inconsistency between it and the actual
>      number of folios in the split queue.
>
>   2) When the folio is split via split_folio() later, it's removed from
>      the local list while holding the split queue lock. At this time,
>      the lock is not needed as it is not protecting anything.
>
>   3) To handle the race condition with a third-party freeing or migrating
>      the preceding folio, we must ensure there's always one safe (with
>      raised refcount) folio before by delaying its folio_put(). More
>      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>      split queue not partially_mapped"). It's rather tricky.
>
>We can use the folio_batch infrastructure to handle this clearly. In this
>case, ->split_queue_len will be consistent with the real number of folios
>in the split queue. If list_empty(&folio->_deferred_list) returns false,
>it's clear the folio must be in its split queue (not in a local list
>anymore).
>
>In the future, we will reparent LRU folios during memcg offline to
>eliminate dying memory cgroups, which requires reparenting the split queue
>to its parent first. So this patch prepares for using
>folio_split_queue_lock_irqsave() as the memcg may change then.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

One nit below

>---
[...]
>@@ -4239,38 +4245,27 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> 		}
> 		folio_unlock(folio);
> next:
>+		if (did_split || !folio_test_partially_mapped(folio))
>+			continue;
> 		/*
>-		 * split_folio() removes folio from list on success.
> 		 * Only add back to the queue if folio is partially mapped.
> 		 * If thp_underused returns false, or if split_folio fails
> 		 * in the case it was underused, then consider it used and
> 		 * don't add it back to split_queue.
> 		 */
>-		if (did_split) {
>-			; /* folio already removed from list */
>-		} else if (!folio_test_partially_mapped(folio)) {
>-			list_del_init(&folio->_deferred_list);
>-			removed++;
>-		} else {
>-			/*
>-			 * That unlocked list_del_init() above would be unsafe,
>-			 * unless its folio is separated from any earlier folios
>-			 * left on the list (which may be concurrently unqueued)
>-			 * by one safe folio with refcount still raised.
>-			 */
>-			swap(folio, prev);
>+		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
>+		if (list_empty(&folio->_deferred_list)) {
>+			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
>+			fqueue->split_queue_len++;
> 		}
>-		if (folio)
>-			folio_put(folio);
>+		split_queue_unlock_irqrestore(fqueue, flags);
> 	}
>+	folios_put(&fbatch);
> 
>-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>-	list_splice_tail(&list, &ds_queue->split_queue);
>-	ds_queue->split_queue_len -= removed;
>-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>-
>-	if (prev)
>-		folio_put(prev);
>+	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {

Maybe we can use ds_queue->split_queue_len instead?

>+		cond_resched();
>+		goto retry;
>+	}
> 
> 	/*
> 	 * Stop shrinker if we didn't split any page, but the queue is empty.
>-- 
>2.20.1
>

-- 
Wei Yang
Help you, Help me

