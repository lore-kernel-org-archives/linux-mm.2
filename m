Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BE5606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GrExV6hp
Received: by kanga.kvack.org (Postfix)
	id EE6466B05B3; Thu,  5 Nov 2026 21:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F9C6B05BA; Thu,  5 Nov 2026 21:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FFD6B05BB; Thu,  5 Nov 2026 21:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEDCE6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:12:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C49C120C21
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:18 +0000 (UTC)
X-FDA: 85403069556.16.A3E3249
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf18.hostedemail.com (Postfix) with ESMTP id 44A9F1C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GrExV6hp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793931136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoPT4cnztlWhe++QcEIoMFQGVSkCAinjrbX3Ih95LjA=;
	b=xRQwP6WN5t19fX1WhCfsHkGA5XbeYMrKjr1IW/euEoTfvMhWNG+P6FFJfXZTVnCAoESrmr
	aE89pB4RKQvbygdPrgLuvuiOuzrQshCU90hi11HZdP31bBD6/eT9G8RVOl1dXj4vRT5oyt
	bkb3CHOd4mAt/TuoEOPPKFhzNZlphi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793931136;
	b=kCa+lA9CuQS9q0ghUGlX/746IOw9QIdtJdjNCgYg7Ck+bLs/IEQ6Zr+5WSWQ9EUm01zo0Z
	Syfq40k/UYIakCtsHALBTpadQKaXXADsMLmwyHrlqMMZiL0WL0iDUFBhGlMKokuwlCbc9z
	3sS5G/uKjq0R4UEzS8NOdw5MjTlxx6s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GrExV6hp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793931132; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BoPT4cnztlWhe++QcEIoMFQGVSkCAinjrbX3Ih95LjA=;
	b=GrExV6hpolJzr+iJAMeQiKPp/a5BgdQeN6RiU/nNaNo1coegw4al82RqRMgUwK4rXmeY6GfcED/Rb735MJU//nr0lnlWqKQuYbk9wrFgE2Jx9Rgb874N503WrALotE8NXZMhVpGI5Q3gYPBR5OIWu15dh4bwMX/vWygT7+6iw3k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEA4u3G_1793931129;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA4u3G_1793931129 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 10:12:10 +0800
Message-ID: <44740e38-77ae-457e-97db-d6e0a0149dc2@linux.alibaba.com>
Date: Fri, 6 Nov 2026 10:12:09 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gsbayknj5o4qdhbxskckbu5yfoii7hdd
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44A9F1C0005
X-HE-Tag: 1793931134-673219
X-HE-Meta: U2FsdGVkX1837s2QSqsv9GOrWKHKSSV7e50+9ppyc8zty7wsP3urFmrPhjDSMWhSnf0kh5KE2rFbROMbo4xEy4sZLg5OejxLz48NmPv/g3YktdYljBjxyavNgqGMvccAeuiGRd6qIsV5gczoA9QIqtsw7rf4uU2GeO5HwAnrzzllISSv+uquxUOHLfBVWfB27vgp640UY1iZ7war8Hfjzcbzo+Jk6p5mWjN5qHnt0ZXBec+8vzmOfFyjqFoNVUgdl/SadAsTOE6bJfYGLzfKxwcdyPLrbGIg50GfUV3ncXzsrH8MlxQTarSjV4F8B6GIf7jmqX0Bs92+JK5FQvd2WZtC7PSFZKp0z3FqJVJ72N4J3p4y5dLDwr101sXXOfF9MFlLfvTtZ5M7cRMIvMJul2X0ci0C4aY6vvBqkDE4AE5NQqZRwDky2Taj26mrged/R7Qe+MNGUDMP+7gDMoSI0IHA3NY864g12eZ5+j+JT+a5mspHF46Jd2mp02Art6FJMnh3K+D8YdR5f9UYlCDsHIqnTcbzX1q5t+4UxpCDicoq7/EjJYSQEJi53kSfe5HLx96FvlopD33ogDtp+IM7wFkGJUn7xZxKTUClfVHxLa6kHlU/4xrkFuTyFxr1wUzRUCQ5pXcD3ZzaVk1M7rPdnSKskCRUhjjB8AqDfrERdDSIoCA7xDElseoMXWWIaHam4xjkfX61YCUNbkZLMYHFH9cJ2Gu0LJxMvQucbkQXMd4J/XeohY1eNsdGNxtJBbgnhx5NH9awc7oaJG6REOjLJFDbONW1tJkA8pHW351L7S6oanJ71KpSX+MMp2Npho7MKZEfecwBfP/bjjL6dx9otC0qwJFJWX5mxMMUAJ+IKFqkeKhKNd+fSNhq6BF2z+Het3qtk7LS0Q8TJIT9XhEcT8oH0Wq7ibWupKw/nWzpQUyYDufUzNKQvNUGUf8kMtpWqg5u7BDN41guZrlm6CY
 e9AbtvCU
 QSzc5+EnZ1oHIIoldogRUVrpBerciQms2oGSBYHiGcDtSJvYeNBx3TALgHZV7j+cBG8jaNqLUWmcjMwlUuCLBnJ07eGCPArZJluXs34sYL7c/uOWTwRkwzd2Y4/b/G3jItiM7+gc/Kf9eIEWPnzQ7pw0MZjLRDPYt3UacjsKQ+5KAiQcuLDLgdqY8eEta4OGiZoPCEaKciVS9xfbX+vABoHj4VW/OxU3ueX4UnmDGpp5AWHb/NgpMoBpSdCzHkrmfuKkYoT26wduKQzGtWVaJKmVDKws616Jwh67FciIucba9HZKo/Tx3IWQZviPXVl0/hEQX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 7:37 PM, Pedro Falcato wrote:
> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>> with concurrent page table reclamation via zap_empty_pte_table().
>>
>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>> and try_to_migrate(), the other callers do not perform post-walk accounting
>> checks, so the race has no observable impact on them.
>>
>> For migration, the race can cause unnecessary retries. For reclaim via
>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>> fact already unmapped (as shown below), which may lead to unexpected OOM
>> or increased refaults.
> 
> This is very handwavy. Do you have numbers? Does this actually make sense?

This is hard to measure in practice. But in theory, if we can't reclaim 
cold large folios that are actually unmapped due to the racy checks, it 
could cause cold/hot inversion (e.g., in MGLRU) and increase refaults. 
In extreme cases, failing to reclaim unmapped large folios could even 
cause OOM.

