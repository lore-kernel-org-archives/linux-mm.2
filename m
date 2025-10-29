Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762B7CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8968E002D; Tue, 28 Oct 2025 23:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979368E0015; Tue, 28 Oct 2025 23:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B58C8E002D; Tue, 28 Oct 2025 23:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD788E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:12:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DEDD1A06C6
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:12:40 +0000 (UTC)
X-FDA: 84049679280.16.5D8E058
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA3AB160002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:12:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DruSDcLg;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761707558; a=rsa-sha256;
	cv=none;
	b=KGkp90zYcK2qO/Rje9hwwRUAk7xPRv0cvUciovlfr/GLoYp3vJlh2yVGUfJQg19k60XEBy
	sN/Ps2oeJvE+UStxtttx2ANM5+c2MtSdYGcjpeHtARVpqKMNcCcBQ8BQGZgcI9DoLE8dKy
	910f53mE9v0KjRA6rPOs7gtFGGm3bkU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DruSDcLg;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761707558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8U2/SRrzdo4Rwp5cpioI5+15rE47Gvkhsrn4dsdPbQM=;
	b=rrhQH+HO0p2IlyPZP5vgHWKItND7QAbb0pyvj3B2vpBhMbWsTYahX5Ez2jbeYquiHX4XQ6
	sk/L1ifgJB01zmC82G8LaRr4pRuHnqhwEwWGctNmxWWHKGKx5WbEISYTXg250VJWFbtSzf
	dWoaJOOCY+2cp7Ev8oF/NAh15hrzJYo=
Message-ID: <a8892c17-5161-4e27-9fdb-70e2e5c53f2c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761707555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8U2/SRrzdo4Rwp5cpioI5+15rE47Gvkhsrn4dsdPbQM=;
	b=DruSDcLgKCqasjSORgvtKLccMIgUgAw9AbnSQzVZDb1mLkpujqTjHHUBMYj1SRcHgLqZN9
	a2itK2hbxjSdRqD/XLybZHvtRP3ZIxiDA0D4Mrwv0f5/H4OsJIm8AfJOem4Es5HcY7726o
	G2rmoLCw0O5hZNmyy2+zlbFzAnWtuFw=
Date: Wed, 29 Oct 2025 11:12:24 +0800
MIME-Version: 1.0
Subject: Re: [syzbot ci] Re: Eliminate Dying Memory Cgroup
To: Harry Yoo <harry.yoo@oracle.com>,
 syzbot ci <syzbot+cie7d8f1fc805fcd7a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 cgroups@vger.kernel.org, chengming.zhou@linux.dev, david@redhat.com,
 hannes@cmpxchg.org, hughd@google.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, nphamcs@gmail.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, songmuchun@bytedance.com, weixugc@google.com,
 yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <69012e79.050a0220.3344a1.03ee.GAE@google.com> <aQFeMG8WEvrWaNf0@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aQFeMG8WEvrWaNf0@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: zjt1qsgjx7yigfag4xnef5ioe1r6ujet
X-Rspamd-Queue-Id: EA3AB160002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761707557-74695
X-HE-Meta: U2FsdGVkX18D61QiX8rWqnNYINAnGLkLDOlM9rfghCecy534o/mqpPjwKXV8iBjJJg19VPlYCDKiBlTovNpBtvezgiuu6xMLZsGUUo5CB8AntPMkoVMEiJzIGLBn0fEovZ6JyuyO8jX4k2OoNXEjG2BFlWZ7JeZJvGU4PgwkDUA7lKc6Oir2749Yx3Rh0TdIKiOH6c9yh0f5fcWibcByDDCuuIYTOlmwzoFTLHMkGcPncOU1gKK5U277Usg87SySBnWywY3RHpQ+1BzfQagg2Co3xb+PtdpiRW6u17noym47DZqoW8kQKk0xQJkIp9+lJRFTWvlQ6QjMACxdBkXyTJ6QEl86VxK9j8Gd4N/XG0QJ0/iWEGP4sActWSAbWTjxWY/lKAdiGRNAluA+qQ8ZkMzw+FlvDsrWv7KMSJWntSugASs41STdN7OJwzFfZKmw3vNUS54apjIYXs3AFUgFyTz/ypVxFQ5fh4MvOTCWUWjZ6hogY3wFEmGrZZ0MiLx4q0vY6yiTuSAZyXRWQvBTORS1rvlt6ZMrGxcek+dlEkZbVuLkhlnx3d3PAWgpRl4BsOGc7so38uqk+spq4EnL0Us5crH9IUzoKk+xu9Zxz/JmT6IgPbUCNc5l5Ld6VVs6j/y/dkQ8wnAb8jxuO2kq2EDwY0DwreKo+ll4MRH+POL44F3yjip2YxvOvINKc+HS00q1NqxfHquwWRb3vKaOkt98NwxDjGrcADpSRvV3gXPEn/daR8WUZSvhFiMv/PqEobRFPbaFNLl37VfgiKEd5kuYHPqVq94e6XtUND3oVqsEeI3az9ktSbwLlyrFbyvG7/OOn6Qc6Ns/LI5/eHB9Es97NdbyF7wdXiJWQX3rrNiP8v0nGur8UDCWHsDRXdGUy23C2vJNumyh+a75vAaiXhYsDBzlFZu1sgVi6xvKEaTE8d45cxlf29N8dfBNIXMXpRmDn+556l/mxMIio1I
 bVhkdIxK
 l7+FtEuGM8967tDeONC9X3Oat5+zqL8SysH5WSd0H9kauBonczTbjVsBcbC19/geJ/nQdJbCdtftE2rZ+w8v6wooXgPidqQAZpflF9Nnn82cbGvgyY0oEzkJErJvdod4Ig6CLCEXnm7jH2FjVNLlEYN5OlZdeF/k4ZvW9VSstfA0eCiPmAizGFRzRtHpy/ePGcz9rba3fLKO2UpdhI28weziJYdkY0gIN+2o4ACkRZaYyfFvt0n38fpPbxu5p8kZlmkRKtDl4DUcxdmUnVJ585j/Vr4GgIftVco+qBmyLOmg4NIyFuWCot8oAfMlsi9EBMJyUUvazAqYVOpQ6SKPsM5oj2iFogPFtJ2C40VWUFnrxkxDF3ulMxy0iMMP0zau7m6/DALQrOeqDpAdgm0Uhbo+iiXiw1H13KPR7p00F/+2B9H/BPYIoT6J0P98w9L96hvc3Y4TNo/OIairUoYJoFja5InHza84kKe9QCxgHHNQZoWNk648YIWLx/xfm2eqCfmkB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 10/29/25 8:22 AM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 01:58:33PM -0700, syzbot ci wrote:
>> syzbot ci has tested the following series
>>
>> [v1] Eliminate Dying Memory Cgroup
>> https://lore.kernel.org/all/cover.1761658310.git.zhengqi.arch@bytedance.com
>> * [PATCH v1 01/26] mm: memcontrol: remove dead code of checking parent memory cgroup
>> * [PATCH v1 02/26] mm: workingset: use folio_lruvec() in workingset_refault()
>> * [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its variants
>> * [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
>> * [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for non-kmem case
>> * [PATCH v1 06/26] mm: memcontrol: return root object cgroup for root memory cgroup
>> * [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
>> * [PATCH v1 08/26] buffer: prevent memory cgroup release in folio_alloc_buffers()
>> * [PATCH v1 09/26] writeback: prevent memory cgroup release in writeback module
>> * [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
>> * [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in page_io module
>> * [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
>> * [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in mglru
>> * [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
>> * [PATCH v1 15/26] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
>> * [PATCH v1 16/26] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
>> * [PATCH v1 17/26] mm: workingset: prevent lruvec release in workingset_refault()
>> * [PATCH v1 18/26] mm: zswap: prevent lruvec release in zswap_folio_swapin()
>> * [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
>> * [PATCH v1 20/26] mm: workingset: prevent lruvec release in workingset_activation()
>> * [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
>> * [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional LRU folios
>> * [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
>> * [PATCH v1 24/26] mm: memcontrol: refactor memcg_reparent_objcgs()
>> * [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
>> * [PATCH v1 26/26] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
>>
>> and found the following issue:
>> WARNING in folio_memcg
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/0d48a77a-fb4f-485d-9fd6-086afd6fb650
>>
>> ***
>>
>> WARNING in folio_memcg
>>
>> tree:      mm-new
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
>> base:      b227c04932039bccc21a0a89cd6df50fa57e4716
>> arch:      amd64
>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> config:    https://ci.syzbot.org/builds/503d7034-ae99-44d1-8fb2-62e7ef5e1c7c/config
>> C repro:   https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b6ab/c_repro
>> syz repro: https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b6ab/syz_repro
>>
>> exFAT-fs (loop0): failed to load upcase table (idx : 0x00010000, chksum : 0xe5674ec2, utbl_chksum : 0xe619d30d)
>> exFAT-fs (loop0): failed to load alloc-bitmap
>> exFAT-fs (loop0): failed to recognize exfat type
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
>> WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:434
> 
> This is understandable as the code snippet was added fairly recently
> and is easy to miss during rebasing.

My mistake, I should recheck it.

> 
> #syz test
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a341814468b9..738d914e5354 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -896,11 +896,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>   	 * to the active LRU list in the case.
>   	 */
>   	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> +		rcu_read_lock();
>   		if (!mem_cgroup_zswap_writeback_enabled(
>   					folio_memcg(page_folio(page)))) {
> +			rcu_read_unlock();
>   			comp_ret = comp_ret ? comp_ret : -EINVAL;
>   			goto unlock;
>   		}
> +		rcu_read_unlock();
>   		comp_ret = 0;
>   		dlen = PAGE_SIZE;
>   		dst = kmap_local_page(page);

LGTM, will do in the next version.

Thanks!

> 


