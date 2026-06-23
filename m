Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E9ACD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 04:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054F96B0088; Tue, 23 Jun 2026 00:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006496B008A; Tue, 23 Jun 2026 00:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E380A6B008C; Tue, 23 Jun 2026 00:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC6C46B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:03:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44CC91C5331
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:03:17 +0000 (UTC)
X-FDA: 84909832434.30.8E7C555
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF011180002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:03:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jtEUwR++;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782187395;
	b=anFkLK1tMg9oz8XHrGcyrGQt0K+2xcQWw2My4ZM+cP/0a/wnCuZl0V7YyQeshyByCeIDlU
	btU5Z/N4n9R8LbUF0tL/nIRY4VnE6HPdc23hfbzPw8R3C0cjrUvAj6b1m4nfi5pFw4io8X
	e4HtNQRv2kTbp2tNrWaZxhkvbC71DGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782187395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDml3DYC5pqWqIgrJTA2AlrjEEywE4UPFgWUZRf3Kqk=;
	b=QJb3LoDacZ66JpV73mWr0NF5jKm5A/EH+wl+fAFnRgxKn9hjwpC0EwfliWFWHe/pB5asET
	tQ8ckbYVQ+WHsphyumuCrWoYSqjcZ/tLUGEqXpNXaH0qyjdmMuvzYlB/yWWAYAiBOMlXvD
	wTAUtgZ3Oc8rKb71bJywTPr1cWL0GbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jtEUwR++;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782187390; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MDml3DYC5pqWqIgrJTA2AlrjEEywE4UPFgWUZRf3Kqk=;
	b=jtEUwR++9CvdONakBHMGhE9lnxzbVDtQ8IDS1adEO+vrzKqaJq2lY3WK7aWVETYrqMhcdD86tA0dsKXmSKywUNHO0aGNaYiuJVW2QXCshfYvGfFPracP0KNUtRO9X4VczQEnjzdZ5QCrF4AX7LUNVO31Fb5Iln8lBn2n0NDFRJ4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X5ShOlu_1782187388;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5ShOlu_1782187388 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 12:03:09 +0800
Message-ID: <c45653f6-0b2b-499b-aa51-09e934ddf1fb@linux.alibaba.com>
Date: Tue, 23 Jun 2026 12:03:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260623024237.45990-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF011180002
X-Stat-Signature: 6fnfifgbkm7z59ucm3dxihrhyceqxx9x
X-HE-Tag: 1782187393-36225
X-HE-Meta: U2FsdGVkX1/V5GIiGGOtOsxxWImMqnLUC5lCJl5KJ0h0rUjyH51XbfpFBEUaTWbJrRarWQ/P+ftEkL/WVux9zwKSZn4GN/aFZRQ9uOkmVQ1ksZsMvdjBeGlB4OWHRuu3286IRRwOspbYtvXsfn6VY9uuKgZO1G89eB8u1aA2g2nuR2bFkJaKVyteHf7k3K/x+n4XfDSjCnC4gPB6aGKPa2hG3ayp9zH0q70DSl6u9+tw6o6CZRO1HBCCYxa3Seb04KT/tYElZs7VUJ7c9iZ4DyzlrnKDdlvSBy+2nLjsvvbL0rPe+5cBmEfm+cQ9ZL6i8CAXzHUlHSRtgKbqJKUKJZfSjpTq8sf1lGLl3lLonI7ICByaU8fnftuXDcSyDlypqHinA0vKyvdqg/J9RimfXPDQFjeovaOFrGc5usFfAJ4I7ScCucuEWeOO3cbgKXmpCecf4Re3n5eqosL7r6SLaej+GU0JFcXGNVzpfP3IHJpQiLNlrN/tOrVzr+TrgsUGoJ43M8NzxPK7aDRtGaXRvIlg0FY265rf7RL/Wd+Yr9H/gGMrL7goZ0WifZ6sWSIXrV8MWsANBhI0WDEXu+pkceKU5GndRz+hQb6pqiZJno8+fKphxsc3D2/yjhHPfzH+FCx9/x0v5tG+5GiuazaMqZoyObuQATtFzxo48oh/twjFMyMr6sqxDcUifU5NO1PrzzidtlkSrOiTH4uW2oEpAAzeImix28HcNSnxkZZalEDe3PKPVPp0G3F1zojYrbGPLwR0A6v1YDE75bur1PvzO2ICKUMrmnQMppTHEHScmU7Gc+w+yuMZtbC7yYr6uQ0UoG9vdY2ED0e7Gdxa4roI3EAcnBwTKblPwhdO2jM0deW7JrZtne3FNd5/TfbJRd4PCxl4XyxHvP0BJFYT7xaDaC28WymYjXyjNGc4Hg83ZAWuLrEFwxDdn3mzqAJJlV7VJnnMC1FlsbHasvfmYF1
 pLpzSUOt
 zu1fhYTlFDwj3TFwLbChAgOvH70+yUXr5bH6ec69frv2mF3lrKx0GxV4EXqFez8fmYuDuST3V4gp7RJR5sG2w8zngml2XdmtVLUL189+1KUsreDsohKthvui1ak/9i+/9WrVr1zk4atN9yPY8knjd/iqU4V7UWFnSNGHp+VdpsfeUhNCPf5HZH5Esez6SMR3dwLVmxKlzt9/D9PKMYVRMhToowAXRtj7SgHGbd4jvmwMqlJwhQM3j7QxdwJH9c0VQJIXplNdQXIjtjMmlaoX5BsrpGDtyzscuWLrvsOPJsB1/C1igQ6vDgu7PDRQPQi2dJ+kyZWjUtGDiRPxdzc4odt8YMGolEnw7Y2CP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/26 10:42 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>      --> update_batch_size
>          --> walk->nr_pages += delta
> 
>                                mem_cgroup_css_offline
>                                --> memcg_reparent_objcgs
>                                    --> lock lruvec
>                                        lru_gen_reparent_memcg
>                                        --> reparent child folios to parent
>                                        unlock lruvec
> 
>      lock lruvec
>      reset_batch_size
>      --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> To fix it, add lrugen->reparented to remember the new owner of a
> reparented lruvec, and make reset_batch_size() charge pending deltas to
> that owner.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Looks reasonable to me. Thanks for the fix.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

