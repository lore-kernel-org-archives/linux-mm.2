Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16C5F8E499
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3D46B0088; Thu, 16 Apr 2026 21:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055416B0089; Thu, 16 Apr 2026 21:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85E06B008A; Thu, 16 Apr 2026 21:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D73B76B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:24:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FA7D8C50B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:24:28 +0000 (UTC)
X-FDA: 84666302616.11.A9F1AE9
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7FB55180005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:24:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuddANe9;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776389066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=cpOJeXbfkQGfp2oJxb2u3PSnQNyOEp2e2c25qGS5Duw=;
	b=QikC1ld5xCSVaABY0rI9cLKyY7E2U+YG/O4VsDv7IhDEub/kZ8meAR5phhT2Ofiqnv0z62
	i0E8Ntv+tuD5pRAgmJPFUU6YB3FOn+Jo8jOfs/IWD7Ccyjexs/NEQCyMt3cE7hC0UL/TqE
	8EBFTyO45b5VgGz/KepqLEo6bkIt3i0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuddANe9;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776389066; a=rsa-sha256;
	cv=none;
	b=E5LXbgsakIZzfSxT94BP0urH8EB0n23a7UyzajgRFZudt3fT6DxM3vG2z+CDDHFBCn04Zh
	SXoXjvlNoeuBGhEdwNxNhbDelBHcYUj/yRItbjbRChDJ50WwTB9kK5VtHVcltNBh34GbeN
	jWRnaqZwbX3u/cKcd0m+Sb6+yFS7tuU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso93635a91.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776389065; x=1776993865; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cpOJeXbfkQGfp2oJxb2u3PSnQNyOEp2e2c25qGS5Duw=;
        b=CuddANe98fcp20KvuGSi8gO8/PMxzlNYYusJlqmdzvAiXQpecULZuiC2PlFcIPaIII
         ACCQlb1jabYhg+uSks/wiBEDXykghN+kxe+4QruX+fDn9YWvNpYj5Fv5WucJNx+xbxQH
         nUo7y6u26c8Eu8+31uac3UPgGjkDujJL82uCGd5JbF11PqC9KcqukX5gs6MA5ymwkpte
         pIKukGuOUC315C/6wytAdUJ68lysSl0P8YTWp41YRxaxyCrPcuSSMxWYOuPBtZBQ7Ncz
         UiJr2uoIWHDn+BVNY3h/XIQmfuH8m1EDz8Xwb/vYqxiDCq4+VJo/4a01V5GS/WKKOnCN
         IJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776389065; x=1776993865;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpOJeXbfkQGfp2oJxb2u3PSnQNyOEp2e2c25qGS5Duw=;
        b=N53t8oaYfiHUKDkS92yw+3AziaqXvMuI/71eiZWPfGK6yGUw+IfQ3xQjTCaPeryaDi
         wZo0ly00tX6DTVtMOvAXpfn4XMHW1+vPBrsprOZIoKKqduX4fMf6Z8WVvZ7b1JXaV55O
         2NtHPmSy2Z1CUtDf0XBwHB4N/wY21IbJ164USlL742xEr6lTbazerXNuqFMIzSefidc3
         PO+PPxwx+zJrSJZ8vjD7g1U2vWFTKTRt3FbtqbWiOSm3X9Q8XjDhYZsZS/FoDzkbOQE9
         Z4pfxWl1HMPdgZMO+5vdeREtKlSYl/5Rx4OAy3s7crPqh/TCIgmr/PE2/ypJZXwMWUlf
         76sQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rM4CbTiJjN3d+Fy4ucVDZEWlDBPm5sdRy8O6IP20drERPltzAHz0QMgpYPc3xBYa2sQZpRF0FOQ==@kvack.org
X-Gm-Message-State: AOJu0YwxgXC/h4FeY1aEwaFqZiopeVlBkkZLs4rpXW3SuP7zGvhZwdqO
	FreFBwnUaaQ4T6hE4ZZly8R+VFU2WYkQckslgHD9merKEqpgKkCF8wSnQ9Z/B7VK
X-Gm-Gg: AeBDieuW+orTSSlhT70ziXXah7f+btkAfH+lO5l6B2CS9sKSQ2MNtcMrdyo5KkV2iJW
	HaPWfFK5PQawU/Ddkp2RqsBQY9rS4oKWq9t89U4GNjBt5ZYoOoG0akfUm/HyQnyBNy65H4ZLmLj
	lnfTNaomOjNlY1XjeyzP0fhsjY5By5qQPAsqsnOKII0N8qzoH5x4QZogmsVWMv0k1Bs7YEuxMXF
	2D7jVnWL5lnMHhgB8490UKYs47LQIJ7Z06E+XVLT44cw+hNRqXpXYy0PMJsWYKAJLUViwIVm6Z1
	Xzk5xCt6lRCFuMZJ3hb3K4im+jZrZyo5URx8B34ll7+xfSlCsQSQND346Ycs6LFNn8IYhDTJdP0
	VryPUawUNP+4RuMRkgaJ7tWnxQ0+z5COAyPUc7wnJtnY0dYayOQM0BC9V6wCkMKwdyTf4C/28QA
	Sk/t4e4iZ8oEK5xv1bAlyIepjyjLZJLixSZMK0GqKUNgE=
X-Received: by 2002:a17:90b:2fc8:b0:35e:5a4c:9069 with SMTP id 98e67ed59e1d1-3614048a431mr688213a91.14.1776389064664;
        Thu, 16 Apr 2026 18:24:24 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20c6asm1525035ad.58.2026.04.16.18.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:24:23 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <5x66n04a.ritesh.list@gmail.com>
Date: Thu, 16 Apr 2026 20:44:05 +0530
Message-ID: <ldenszsy.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it> <adCQTF1PQnlbNMO8@casper.infradead.org> <5x66n04a.ritesh.list@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FB55180005
X-Stat-Signature: 9odzda6s3xm1kqpa6gbdpknm3bsjdz8j
X-Rspam-User: 
X-HE-Tag: 1776389066-18882
X-HE-Meta: U2FsdGVkX18hSAE60jC56MOwhtElssyLDoc7LkTm9Wg4s89v8/QaZoYP82KZljQEzybOc8Eunb9ucD061hHDAlKr+o1YHFL8r3N5FDhsgZ/R2pj6tfw/EIFWhhgrsBL+wKGKmMUsd9TqFWtUh1KXX5+/w0uOD/ncnoduNmrTfWbspR5A27VLJClL00NLcSr6PNA0Ul7bHR+NIeB7GoGyzBwIJITcw/zh2gg/RXKO1Jo8L1MiKsWAyR+VhFyFqSBpCwb8xSajWfqL0bDqDyAoUnVn+xEBVO2Mj4KjfjPv4YcuZ2Dzu7AkhI0P+BohgVLKtbKU0+S3M5W63As43ciONS7cdq7Zidv7If6Tp9JXl8lmlZ/Je5lARVISsRwVnZcRI8S5SJvc7NsxvMJAAe4pNa4iexpbYiVlcrjHlGEZbw364PE6mAi5MMnBlrOnK/veFh8NhGitCasuUPvVu1jggbGQh6nZJoLObP628NPxWYl/zFIcxwr4652YxTicKin459Ov7cLdQFlW429OixwDd4Emt/fiATExIIvy8SlH76Z5JkAsJ60xyxRu2HMBsheygUarEaClB79N3wqfZ0p7bFA19Q5B8uszx5itV+8XZaYKKndlb6vWuC6Ka+PMcTfCSc+afcZaYrhtzm2C+7rKEb9vgSClR6OfhTE3UTBsbPNuzoc6C38cJzYIZ0qq0aSiRA/6UL10IlMFsSSXq+7KhnKZIagGIxvjBLW29UGLh9BQVvrFkWUfz1buP9ghoySENV2a6EuoUXD64xY9M2VxMa49n/OsU4cv/2Hn3Dg6sHi+YR/AW9C3GwQrJVpz0QGuZkNsMq/Lfw8QeSbBs6StgabLgq0lhDa8XmHi+THUDo4pdozOPJH58CAbkqerN8cZsKyS+vWOjXL0zDapEKlCk2U0oP4MUK4iqhaFFRsKPtzoy18jmm0TaUWK+qdT5X7sKDYjzdouD8O2afjZ1LY
 d7gdHIBF
 mmNp8GROSuColpfBCa7t43d3vVMSf2P0KK5keWLCBvIuzu2HYb8u2FTkHu66Xb30kEa5gwdBTeAV3lWYQ4F03HxQjMcJ9YDxsaT7pBjWoKU0IIt7ug45shQv+oX8/SedDp4tcteF3UMp9XWYNRIf8Ufc0rab3GLx3X/GFfLhyo5XDPbH4VWnPYrdrLoqJrmhWFweXbxRR+PmrwSXTSQIqvhMHasC6NyAo8hqq51VNVwTRtIeGuRQLCmMNwXDpS8RQApAFJSIDoW+l5ViUydkEq2lFpKw8SyLtJR+BzSABAgl4co6iToftaXbPgE90nZBVaxhf3ncq/zbA6tCZe+2cEC9AwVsMhztYHqmPwJ0/vH6dhoGoaUNjRqSOTaGS2kQ2uFOuZarkS6DjdZgqoTxhHVC7jXVst8H4238VYHbotEqdbEgf4hre8nPnNsj91cxmRNT+1fYXN3UkVa0X3+pNwd0s+0W2T+qDp7dnLYVDIfUP6+q6JHTck3wHKOxpNMKYKTxFnwwDxhHEPrIFly1rS0nws6JSuA/cw7FtXn118s+KD6k6K0SycE89ERhM/eFa+1ja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> Matthew Wilcox <willy@infradead.org> writes:
>
>> On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
>>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>> introduced high-order folio allocations in the buffered write
>>> path. When memory is fragmented, each failed allocation triggers
>>> compaction and drain_all_pages() via __alloc_pages_slowpath(),
>>> causing a 0.75x throughput drop on pgbench (simple-update) with 
>>> 1024 clients on a 96-vCPU arm64 system.
>>> 
>>> Strip __GFP_DIRECT_RECLAIM from folio allocations in
>>> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
>>> making them purely opportunistic.
>>
>> If you look at __filemap_get_folio_mpol(), that's kind of being tried
>> already:
>>
>>                         if (order > min_order)
>>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>>
>>  * %__GFP_NORETRY: The VM implementation will try only very lightweight
>>  * memory direct reclaim to get some memory under memory pressure (thus
>>  * it can sleep). It will avoid disruptive actions like OOM killer. The
>>  * caller must handle the failure which is quite likely to happen under
>>  * heavy memory pressure. The flag is suitable when failure can easily be
>>  * handled at small cost, such as reduced throughput.
>>
>> which, from the description, seemed like the right approach.  So either
>> the description or the implementation should be updated, I suppose?
>>
>> Now, what happens if you change those two lines to:
>>
>> 			if (order > min_order) {
>> 				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
>> 				alloc_gfp |= __GFP_NOWARN;
>> 			}
>
> Hi Matthew,
>
> Shouldn't we try this instead? This would still allows us to keep
> __GFP_NORETRY and hence light weight direct reclaim/compaction for
> atleast the non-costly order allocations, right?
>
>  			if (order > min_order) {
> 				alloc_gfp |= __GFP_NOWARN;
> 				if (order > PAGE_ALLOC_COSTLY_ORDER)
> 					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> 				else
> 					alloc_gfp |= __GFP_NORETRY;
> 			}
>

Hi Salvatore,

Did you get a chance to test the above two options (shared by Matthew
and me)? And were you able to recover the performance back with those?

So, in a longer run, as Dave suggested, we might need to fix this by
maybe considering removing compaction in the direct reclaim path. But I
guess for fixing it in older kernel releases, we might need a quick fix
,so maybe worth trying the above suggested changes, perhaps.

Also, I am somehow not able to hit this problem at my end (even after
creating a bit of memory fragmentation). So please also feel free to
share the steps, if you have a setup to re-create it easily.

-ritesh

