Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF81606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=bJdtSXo2
Received: by kanga.kvack.org (Postfix)
	id 04C1A6B06F3; Thu, 19 Nov 2026 22:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17E96B06F4; Thu, 19 Nov 2026 22:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03A66B0707; Thu, 19 Nov 2026 22:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B717E6B06F3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:28:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EDB6407ED
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:28:01 +0000 (UTC)
X-FDA: 85454063562.20.F5F5F60
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf21.hostedemail.com (Postfix) with ESMTP id B80C41C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:27:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bJdtSXo2;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795145279;
	b=Tu9Wj7/7mH2cOU1YHE+GBvmANDL/mkabP843E+y5fxCCcjq0Q13LJBM2mcU8trLeqHd4K/
	abxDId/PJUDZnTbp+0+6hp7zfqrRcBk+C1Z48d9LuPseFYCvBZo4qks3t8p88cPeG9fFTM
	4kCnObqIWeGm1U0myK8NaeFFmJDm1NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795145279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Dg095nuQm08w1mrGur5FXxR8nXjuDgQq1Pk8wkGwVI=;
	b=J+BXRpHuuvm4hEKKiluK1wg4A8mnrenmsY30+M3v2VktFuty4jtGWZPg2ph/ViGeViibWU
	CeMjJn7BXEtgHMirLMWi4Icojhi8TxQms3tGSdARu7pignVoc/NI3LmAhHXgtJvPKioFgO
	wFXm3UHNnEeEXUUtVx4hVyyR2hsv/4k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bJdtSXo2;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+Dg095nuQm08w1mrGur5FXxR8nXjuDgQq1Pk8wkGwVI=;
	b=bJdtSXo2zsPNNAWZHoqmIPvvPsucTx4ac5NrM9rYFhJ0E8wOXluASdeBe9kfYY0AIPpR/asys
	c6ETQCvnJrDpYQn0VZoOBlmVN4JhsRkQKTs9M+QbLBhTOJfxKheQYpVyRjNfMRpDncLXZzA5RzZ
	a0FAogV0ZKyp4dOS0sOJPMo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jW13S68TDz12LHl;
	Fri, 20 Nov 2026 11:27:00 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 143EA40683;
	Fri, 20 Nov 2026 11:27:52 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 20 Nov 2026 11:27:50 +0800
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
	<stable@vger.kernel.org>, David Hildenbrand <david@kernel.org>, Usama Arif
	<usama.arif@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan
	<ziy@nvidia.com>
References: <20261119134236.3745231-1-kas@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <a5c04d15-adc7-b7c2-fb1f-a68b0483fef7@huawei.com>
Date: Fri, 20 Nov 2026 11:27:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B80C41C0007
X-Rspam-User:
X-Stat-Signature: wgki7abhqk663yms5uy5dhix35mn14n8
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795145276-444645
X-HE-Meta: U2FsdGVkX19WNvVHiBmZK637K8IxLigWrX9UVtk4+uZOv6/mpsVjgti4jDVe6xjhvArwx1SeIIj9Ee0ceyfh4rZy5VyCZ5XcMB+8am/qyZncDp8RHJcrgv/dtSg739FR45mut0qx0dnXp7nni/EokfLkK6scY27AYVsZ+DxhZq5BTc9miYnRLZ64NkPStpjxMQ3MnBohbuVHuYHv+a7yFReq9cGIoazRf3tXILczUTsd4JtR478+WFr4pmqdDBmPChkzjXXuWnVpbvr++a0pjcigGgVx9GhaUxxgMQEH5RXYXcyuIpSFLHjUVCXn0CYVZDkdqcuvIRlGQ7Kf/+cqI9BvnOPY5uJ8HnvO+/ZDS9r4Hrj3rGpgGSXEMJi9t2NmKUwDrlPgrPggQ6E3wJpCpmkUNksowCtb5GpvrQvFhbOy6Pv5rsM6yRFN66U2JEhaXpPFsSFVV8X3OkNth6YP0m/+bg7sXPFRqjKFlqX/LlT3k+jolOK5ui6knqq7AnHew+49n7Khr8h7ySYQSeM9dxbBDwLH6JAxs4m0cdF9NoXa5P5zh2IuL7wnVErBl+ugh5t0LrMXxDLiV5ykiDyVKqUnLtgBQiKeGN2TVKEgyhGdY/Gl+nmsKK0U7WTdCraSBq1WqiKDQhRIHId/ES30z6euwtULyEyGCD3Kvgx7W65iAOobfAtRpQsJ8dZVo4aTTOndbfGsQf+LgsyLk7RCI3O62sCnpHFmdU6IO0YgjkxocuayGfZ3V4sHMbdPOyuEyozl/JGvVMzQamZcSxXtW6esrRbSsuYzBtGy+4ddTFdZp5zpFHUikowrxf61EXAOHzYhjpql9XKUGpvXmRQaXptApMzzNxumApVkfOFOMMT/J/YssForzfZXWfD8e6OEPrNqbD/bZqtAohcdhBIwrydtD4N1U+YuO0gpx4/WmffLeFHyeVgrBnkCofA+Yai1ffwwXSqRUVYEIeLi/ib
 J9NNMYnA
 Tq3w4dQbOnnJv8964Pn5PJYwcWt8ydQMOpJcetk1GLnhIt/xu9MAWfIZ3MY0/pHXTnwKzCaYlcPrXt+o+qgYe9wdZRGot5wQFh1sbZvnwxYbrig29NoVMMiXVQJI7108n/GVjmj5mn04CdOIO26mM1lcGS+Ex5ccJCHhZA3oA/actRUOe0JUYxIFrnEkmbS3bllrx1g1Y1Rw9FZcCsquPH03LvbryOgJhxC4k2qqLh1Va/m0s60OotJyyJNxuCsXrD6w2hRcybXARrzm73z/QgiVILXjF8VT+9r4oDLc3nPfQAdsaEQ0IFTLrHuHGJgjJVwoT+qjMtL1EvVGOFh/fCnUr63yrR/63taSH4jWBXpbVcX3HJsG37C8u88/OsQ6umYBFA/rhpLqZUFd2PYORheDSWoH5P6xJpLTVb4QUQrT0h7TjBfYolIVOjUN0Cg95YpodZUzz862isk52VBHxvNwt1eqE1lfLIRDij6f54djaDcDlmiwg60xWn7h5KlnQJj1aa/jSnmDi0zpdJ6m+ApfZGKBKbZmRLpGNlSHaOSE1qBzDPzgsabgY7yEacZUla+3sYkgl3Ff+IJoiwyzv4YOoJiKRyd6f8uAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/19 21:42, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
> 
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
> 
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
> 
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM. Thanks.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

