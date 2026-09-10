Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5EEC79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFEA6B008A; Wed,  9 Sep 2026 23:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0EE6B008C; Wed,  9 Sep 2026 23:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590486B0092; Wed,  9 Sep 2026 23:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272816B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:16:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D44C6A4968
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:16:15 +0000 (UTC)
X-FDA: 85196389110.20.4A1A0DD
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00583A0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:16:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gz3dOd/h";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789010174;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYSjnZ7o6t7LHnF5MCbffFkXr8Iwz82fqgMZavKGTtw=;
	b=AhKe6Xee+G5taocOZ19IvaDvG7m743XJZOWUGl/cIi0BmJ2EvstdxafWIFdF97Ksj/wUQ+
	2V+qB7fEEnEwKnjwfPlyTwYeyKDVaHJC26cZIzpTImkJT922IIOgIR1/PTZbWyexLe2QZ+
	gAdiGwnjaqDjMTA95BmysaKXaC+/q90=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789010174;
	b=U4bz5YWKZSZ7j1T6Ds8jRtwAFvgwVcdDE6vHUqoZa9FeE2A2ZLpW5T6m7YxoSPP3ibIQi6
	TxgyUHubxbrZJ3L0nXUof3/2wzlaEr3FbUqwSp+Kwy3ot2jCdgxMUG6H2uJlgK5sju2d2K
	Pnd4JLN0dq/X128ScVdnDMIFefILp9A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gz3dOd/h";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a64c7cdb46so1400523a12.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 20:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789010172; x=1789614972; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xYSjnZ7o6t7LHnF5MCbffFkXr8Iwz82fqgMZavKGTtw=;
        b=Gz3dOd/hYgIsg4MV/JBbFGn+2iHvZRkicGEJC9AGJS+1gyEP5S/puEEBuDcYBDRo0v
         eJ4In5c7eC/UuF56yvvpyMoV2MA+IFGOnp6O95IBPkKcwzb2YWZyuMVEnzkRZpkRQLac
         LbghD2wGKOd0MpKGDFg8Hw/7dUeseG8PzS2Wkcs7dIuw2olA/vzCA9CfDP2IuhEji+gT
         VU35K1OcEW/G6YDdbw0xIBH0dO1Q09gaLVFHHYiza7BdB8Kc5YxWMQMvMBaoYyVgZJmI
         T9TJC/MWY6z0ogFjE3zbNI5BD9ss1QVQL2hGxcwgViQh8YBaN2AlOOt9u57sM9bykgVX
         ZxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789010172; x=1789614972;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xYSjnZ7o6t7LHnF5MCbffFkXr8Iwz82fqgMZavKGTtw=;
        b=TyoTMaLqQv0CE94bTKhBWbGWO+7HgzA/3FNaOhWLeRv9ci07FCaVuEaIJsNGhlW6q1
         u9/VhYqkiaewqyCpXb+93cpjdDo8zko9U02nk60DiqAYvUsquXKRTqj7rKPXgiUxG5hm
         vGWxIegpJ6Td7QRzWxSXBU8K3KMpRvA5LTZVJl68rQMGdAGCBUEuV5pjXrdk6LY9F315
         wK9re5gq/axFSbn/JOXH61MC/YU+TgERCHRTghfqiJ5BkULt6GLXI6l5qp3OKFZzOxD+
         Qr8DcTjd6y/O4l+DAqIx3ses41B+7zEo7HthAxEXTxAlQ22ZbptEHGHmJdIipeF5+e+r
         H8iQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTPKIVB/ss6NDkXaniEDRqC6/xUkUUrF0vCyyhvcje4llD9c4c5kIYMbpX3Tac4kr7lhOcnIIvqw==@kvack.org
X-Gm-Message-State: AFuF++lXVEIUATSFllTzczOsxQC0t2NIB9X4Qn6NBSElq3Rk4bk/hN+W
	GR+lIssT/SnSIsoAv68xJL3jMk3ApHf8gY59w+OYr18IfO4O9aGnpzTr
X-Gm-Gg: AYBFou1AdUpv/KlCi/DQ6L2u8UTTUXaJ3XQigP/GJZnelnGBT2oFqE65OPJL6l9+95F
	AP/Py1oOVraHm6kfo2ZedUpzjkucaKNGricPVgp0qT2l1NfW1xOMCQwnhvmehaIeFt1MQdAjBmG
	ZMjAfIa9Banz0TtpQU1K3yufbBOhtg0DhL6A+gMN9IFAeJPnYUKFvW6O5LQ3BwqqA4YmdLF8fkA
	y2r05akr/sEgCf4SuuYUPt/oX0a5sdTewTm9jVrv2tnTwviR+BwY9qj7Yx9vflLKNbol+N7pkX6
	yw3oS215vqz4b0ggzS4YN6KmL6TImAH5hGQVJ1OLXnk4uATwOSvbhB5SB8C9pOYnv82KLGPXwsB
	Jc1wFQjKQ+HPLzxcX3WtY3svnYbg+hnTybeij2N73WJsVo79IfwQIXDwWF/6WXc1GE5kdUlGrZs
	3hAtwT+OGdULqpSwGWU/GJvBbeJGoW4KEHAd1Z+Q88fi6p6Hl5BaME9hIi24nncDDQNEqhtSo=
X-Received: by 2002:a05:6402:4496:b0:6a6:c4b:c92f with SMTP id 4fb4d7f45d1cf-6a99caa4ab3mr1949381a12.9.1789010172185;
        Wed, 09 Sep 2026 20:16:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9939349dcsm1765945a12.1.2026.09.09.20.16.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2026 20:16:10 -0700 (PDT)
Date: Thu, 10 Sep 2026 03:16:09 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [BUG] mm/memory_hotplug: panic due to race between compaction
 and memory hot-unplug
Message-ID: <20260910031609.qbn2qcxzbitau5xc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260903095543.3752338-1-yuan1.liu@intel.com>
 <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ueh83z5sm8eoa3bnewqqziym5u7aepop
X-Rspam-User: 
X-Rspamd-Queue-Id: 00583A0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789010173-798574
X-HE-Meta: U2FsdGVkX19FTi+OnK0zaoY5ZTyTRNVtRm0sa9k2jMNEUXvCcFIcJUZpR0EuL+CNsn0tIbcGcKprTbzQwGK2oWd/XPlBV9m+/W9FWNjWoBAQjm0YFn4w6j8HtCnKV7ELhEa0UBTzsV98OaqvJ392MUnnzfLFaHrtcjevIZkhK+ONUqUO1Zupu+VkKqmBK6ibGq3deH1lERuLNKZ0rArgq3GJx7jNvGrdSA6ke7RdRKAIJEgl6WEx84CLMq9aH/K6ptf1YyuWcAq8LvWuXNre52WKm1uq1oy9SCUiOHT8UuLf/w/1P4D5kB1OdTUSExxC7ABBkSXk6r2I2/On8L8Cge+ZN5Ltwcv6hb0s4dsluii95rOiGn7FM+S4eUO8t8d5vCdEKweFt1DRqwgBs14XXrvBeJeHtAoe0eXVoa80Di1sLlYz74YoIsFUPn9YKeWQjD2RQVz1jD9DxCwA5rmzl0p5Fx4Leu8Hz9QAWzJ1VKxYxn8g/hIzQxZM2+aNUpwUg9ixxCGgJy2AI5D61bZ6p3F2Ad2bT0zOI06zIrPqcbhLmDyWU4d8fkzANtl1Riiw1wOKcjInuJ+5g/UlHYfPxaVK2D7CkZY6wLfRVoo1UjnF6SwCO8nCA9p1WsRb2WW0Qqd2vUrJhltvacUdInoZirxcxukxJ02Grme/tUn1BqdFRJAsLGk7UrqYBALZiM6/BCC1xhgsYTzsxt64LEIYCxyxIiCnRgEc7hyTeRzVwUZRWVqIl/Iv/uwDkHxFCZDxrLx4z5/PPcHWLMVF5Q9bP+qr7dKk8aFB7uR/VpMSca/XnzJS9SDB5ojhNgz8UKXC5QZxZAEQ5MzGUnewVnPPtwn3OZWrU3P911UIZ31087dHKvLSjU1vvNwCgKxzRQJe94vm5PXtUjAgfHwHaIcGPZw1/MJXfbXpN7jcfGAvyfBJQpHN8WOEj73KD2bnuqsQQCslq8iurs2a/KuFr8M
 wxCp5dkQ
 TLJVzt3+k1gMcKwMvfTAeseqQAyS3KTLJ/zK4IFopHbnTBELtR/i2SzZ/Cpr0yYCXhBAJyqcOjWm+SXUmjjU3+ZS8pBkoxvVj68FKYKWr2pf0Rg4WjKpS/hTimrY/ir58a8ebtqpIUrQQqxxCXrr5kVRhbrtA7Jnw7G4pSLothBCkr4mL7DMwWckRiBJ5xCXavWJPFVb6MkEMsD7t2yNZtBb6dLlukpEQxxhpK+unAnmKB8KrbK3w73mkGO4Ot5f1n2s/1f9TzFOflA87KbNGEgkhTUgvIp8vQCkTRE/NbRSSo7It1yVEm1gUoiaIPcv+RdiPC1F4zX0QrHyk9fLTHc1jNs/0ahI2lBjE4+jawdv0kjr24YFO2mkNgXtxVaLLLIa7FDsRlFp1S2eoKXznF6Yl9QcU+xUxmg1+MqOt+moSqIhNqkczYinXBL37+boDY7Co5ZQiTkK+pKJ/IQzrJvKeALH905hzLqe3qY4tgZRS/z0qexTRUPYAcFRgWYobGksfY65NGjxIIen47XjMBMnU6ITzoUXrmmvm34k9UKF9h+lv/5gNrDuGOXDXTo1nU2uOWs11WIqX4n5QCTMngEDeUm/aA0YhkUlGpOI9qbbvvpO8eh/uQ8jeukj0+HYrr+1Wq0s2pnHzRH37G6fLAwFVaDOObcvOwsSy9WP8NSyKFq7bp37JpCCA56RnrW+RyEx+ZQMUJKdG9uiGKtmmeRY3wK98HY8TfUZkbYnYsLOSLhVNrpvGOTWbCXaf/7B84eXn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:27:50PM +0200, David Hildenbrand (Arm) wrote:
>On 9/3/26 11:55, Yuan Liu wrote:
>> Hi all,
>
>Hi!
>
>> 
>> While stress testing memory hotplug on a VM guest running an
>> unmodified vanilla mainline kernel (7.3.0-rc1, as reported by
>> uname -r), we hit a kernel panic in the guest when memory
>> hot-unplug runs concurrently with memory compaction.
>> 
>> The kernel was built from mainline at commit:
>> 
>>     cee9395acd80 ("Linux 7.3-rc1")
>> 
>> To be more specific, after a large virtio-mem hot-unplug, the guest
>> kernel takes a fatal page fault in suitable_migration_target(), called
>> from isolate_freepages() during compaction.
>
>Sounds like a real problem we should tackle.
>
>> 
>> We are not sure whether this race is reachable under realistic
>> workloads or only under this synthetic stress test. Sharing it here
>> in case it is useful, and in case this is already a known issue.
>> Thanks.
>> 
>> 
>> Call trace (top to bottom)
>> ==========================
>> - RIP: suitable_migration_target+0x5/0x70
>>    isolate_freepages() <- compaction_alloc() <-
>>    migrate_pages() <- compact_zone() <- compact_node() <-
>>    sysctl_compaction_handler().
>> 
>> 
>> Why the race happens
>> ====================
>> CPU0 (compaction free-scanner)          CPU1 (virtio-mem hot-unplug)
>> ----                                    ----
>> page = pageblock_pfn_to_page()
>>    /* checks pass, section ONLINE */
>>    /* returns valid struct page* */
>> 
>>                                          offline_pages()
>>                                            /* section -> offline */
>>                                          __remove_pages()
>>                                            vmemmap_free()
>>                                            /* struct page UNMAPPED */
>> 
>> suitable_migration_target(page)
>>    PageBuddy(page)
>>      read page->page_type
>>      *** not-present fault -> panic ***
>> 

Does it mean, the combination of pfn_to_online_page() / PageBuddy(page) is not
safe, when there is hot-remove, even for other users. Not only compaction.

>
>If it can be hit with virtio-mem, it can be hit with any other memory hotunplug
>code path (e.g., dimm, dax).
>
>It is known that pfn_to_online_page() is racy. We usually expect the race window
>to be extremely small. But for compaction the race window is much larger.
>
>We do have get_online_mems()/put_online_mems(), big its the big hammer.
>
>We once discussed using RCU to protect pfn_to_online_page(), but I suspect for
>comapction that's not actually helpful (again, large race window).
>
>We'd have to use the memory notifier or a dedicated callback to let memory
>offlining sync with compaction.
>
>That's where it gets tricky :)
>
>
>It would be sufficient to let MEM_OFFLINE wait until any previous compaction
>users would be done with the range. In that case, the sections would be offline,
>but the memmap and zone range would not have been adjusted yet.
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

