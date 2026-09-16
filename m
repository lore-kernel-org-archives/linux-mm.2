Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC67EC88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D893F6B0088; Tue, 15 Sep 2026 23:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B1B6B008C; Tue, 15 Sep 2026 23:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55996B0092; Tue, 15 Sep 2026 23:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A14B46B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:24:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33F884050D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:24:08 +0000 (UTC)
X-FDA: 85218181776.30.848D73D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62D4A180005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:24:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fdto37Ns;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789529046;
	b=iT/X+goqhOkVyGDr/ESnRe0FoyeepfkpSiN3kWfTsA07ecDGQDsxSESrGGq9LglyMpV0CI
	eTcIRkCV4coFzk5aMrj0lTgLXdmmvIKMNdZpWIjcNw7lbRZGcPYUT5x1lfQ3pWMxl4HuVa
	3azqYtTxG3DYA7PML4BKHiWrun+YsN4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fdto37Ns;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789529046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUYb0DZMMP72i2B5f0BuQh15vGJ+u1qohoIAllECgHE=;
	b=LgwGglW8AhJWdMI5zM51hPeDLe2CdFMwzRVETjin5f7tpWepnvUCYwxsFbfrZYUce0v+re
	l0953t6HBxK2sg9Bqvw+I/Hl/aUwrIY2LSdxWa4ZCUyyBC7eLJuyh3m0yNgKM9vBUYQ21y
	MTdSiMXlhsC7fKHiEuslLdyVbQaMIaE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789529042; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vUYb0DZMMP72i2B5f0BuQh15vGJ+u1qohoIAllECgHE=;
	b=Fdto37NsxkGWyHA+unNKY45cJTXS6k+L6e6X5/wGfyX+2C/j55hVVbxiT7RzRrR47b1P8kxLXPrFq8y6qgq8K3fPfU4Z/y718PrvodjBmV/aaJMrj6KkH5vyP05WXVXvoMbQ2RNWa4YG+Lmffb1xfhSQrU5JITsDjqJwPp9sWBE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XB3ciWe_1789529039;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB3ciWe_1789529039 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 11:24:00 +0800
Message-ID: <7afc2108-710d-4f54-9472-6b9f156ce945@linux.alibaba.com>
Date: Wed, 16 Sep 2026 11:23:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: restore accidentally removed seq < max_seq
 check
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 ridong.chen@linux.dev, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, yuzhao@google.com,
 Chuanhua Han <hanchuanhua802@gmail.com>
References: <20260915101556.50467-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260915101556.50467-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62D4A180005
X-Stat-Signature: 3kkuebebhifykf54dmmba9gxjbs8xpgk
X-HE-Tag: 1789529045-602164
X-HE-Meta: U2FsdGVkX18OLakrx1jLdctpDklDr+AOifFu/CSebD4VzGoukWEM2mryfhxY0fZA0zaZs/FOGWO7wiLkECc06SShwClyeAxKUqr7VehGNCzwPo8+AD3s2k0pvJ1DF8ty085mj0rc/qCe0JVBSCp8T4LgFR8yci+wP+6ouc0xy4xxU882gmQsJfvQzYQB/2kvS9JulyXb32V2nVY9fyUqSQH4LGUZl3PNy8ep8ACqw4+AnPlyQaTxvrwrv8j/FVdRVkmGb5rvSUgEMHAA4vXBArxhsxDBT9zQH0TNgNofNAnXi6MFtdiQjqG5/dloSL8R/MXD6N2sw4BQnvasSISQtn1txQiCvQQjxAeeHKxZXihPfPI4zAhMul1Ikj6fnSMOdUUZMIBx49g/3/l7VyBT3WO2ViY/db0Ev77ZvVXsx5lJONbx+ssP88igY9XKUuF3DPDnz951j79GsxPaxiLVEloTCPry0tD+He7OdcEycSYYp/YxVeUm/OikpBGrTU8uAfeGrJgXAwIrJPZzP8cL8NUd+ZBh6piJKIL+g0s9niiuVxi8JSK9a6NpzMmXBbpZlVJaiGt48whfzUwchUSo4xmRi2deylXcH3yat3eEt97oqeYWhyNJNDaqcJThCAlmvp7bptXuLDDL44m6ErC50AaKuw6XXCKF67QjQi856wl8R9cMACBfoM7Vpzajgm3rN3lppZdF9nV9mV9qpqwH91jYUtfx4X2rZv23NNwg8RCL/WH0oluHxobU0MpPcGaXpj820dBZDEe5e5PN1yNRMrBziYVSexuckW1JDHDjswmWwVWKRjglSPtNlEONmXj9b0YQ7a/6fnUepJ6vqZ8tvylVvvg0kIG28D9mcgfthzq+yu1E/xeuWWcolwLd1WfJ4+idhKQIomhKgyRL6CTvyqkqIt/zeXHnxiY86prjPzsMbu0yKcmbrOp0wBDh0UJZFuZNVHtbOvZNj+M0whK
 DI6VfOtN
 9VJ9sriIMY/fyPlVbqnTONrd7n8KL8yqKSwyAI+hPLTyRosnW7wkYSbNqeLMUU6TcsWxfssCXcw+6+JJrSmGDkOSBrDjU84gqWpGk7FZMlNjj40XwWSTCpeSqyMJM+irfQxYR0uArT4TdQNc1D+oQKBtWdap9MIeyZnqP3FdlPLC/l97KFTEtipbobWVSs+tuQk1qdTczRMEMiyPwN+sXvZexRH+9a9ssKoUXaZ956jQOtedsUf4tDvsHpQJ1pF4k1HXcuQtwddhKaDdzemPuDVekaI1wu+56MHnrKdLoQnRdGjwNWajv8dBuMtUYssq8kAeJItYH0JrT4uKHuK43wXNNdjO+tbO33x1pmajOLkmMN4IPXKR89Tt47wTsmaQXG+9Cs8b+etHe+5uXc9UulrhHD3SSpcZMXMFLTilJgZVD3DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/26 6:15 PM, Barry Song (Xiaomi) wrote:
> Since commit 798c0330c2ca ("mm/mglru: rework aging feedback"),
> the following sanity check was accidentally removed:
>         if (seq < max_seq)
>                 return 0;
> 
> That means we can perform aging for any value less than or equal to
> max_gen_nr.
> 
> This has been inconsistent with
> Documentation/admin-guide/mm/multigen_lru.rst, which states:
> 
>   Users can write the following command to ``lru_gen`` to create a new
>   generation ``max_gen_nr+1``:
> 
>       ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``
> 
> The correct semantics are that writing a value smaller than
> max_gen_nr should return 0, since the requested generation already
> exists.
> 
> Fixes: 798c0330c2ca ("mm/mglru: rework aging feedback")
> Reported-by: Chuanhua Han <hanchuanhua802@gmail.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

