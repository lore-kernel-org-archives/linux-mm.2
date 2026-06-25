Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9710ECDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890CA6B013E; Thu, 25 Jun 2026 08:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8694C6B0140; Thu, 25 Jun 2026 08:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7800A6B0141; Thu, 25 Jun 2026 08:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 507DB6B013E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:23:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9671A1A066F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:23:10 +0000 (UTC)
X-FDA: 84918349740.10.1734B1D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB5282000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:23:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Pu82SVzy;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782390188;
	b=Y7dckia0GJyMr4ZupaZVHHzFIfem068InI5owAptMH+hf6qGXWJ1nO8BF9f7/Y4m+8/nyD
	efljHg4fA1aiFe8IA0yRIZe9rTfR5oeqEJV/qHtSCZJQjyx9sJMLsgMsFQQYagGF+C9ZDe
	qb9KF/Dx5Y1YV6LKpnG5QmXfI5+tRKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782390188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtTrF+dkMhH5wL9XVdpqg+EYpu4n3AZ8BvYl3aOQkWs=;
	b=Eh2CnR86RS4m3A7jxxszgeLHcUIhICC8qqVb+gpvgHtltbdQYZLwf3w93H/DjOC7mb9acO
	CcKVakjJlzZTr0zCTkhh2CinmAVExBIvSQymgn7HPaMJ5sCQ8rzwxIoazaLjIajyXOpzJw
	+qfgE96AGaMSNJTkLKF8GD/m4bcg9C0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Pu82SVzy;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DtTrF+dkMhH5wL9XVdpqg+EYpu4n3AZ8BvYl3aOQkWs=;
	b=Pu82SVzyU7dKh9zHrrRfAFclb3zu86TYxOkI5vuEUY0eNHVES52yjxGbOXUnji1L3zyjo7tWr
	hpk2IGB9tsONDex78SNwtga9xcWfokjgnOQKPcT90UfVu7TxF3D3zYuR7ULMeiC3bH5wmKsMKGO
	95g0/YrBB8UU0mZl7x/5OaA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gmHlk23FBzmV6S;
	Thu, 25 Jun 2026 20:13:54 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 820C140539;
	Thu, 25 Jun 2026 20:23:00 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Jun 2026 20:23:00 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Jun 2026 20:22:58 +0800
Subject: Re: [PATCH v9 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
	<lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
 <20260609-ecc_panic-v9-4-432a74002e74@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <80c7ddaa-dd8c-1540-f72e-2a9a56aecdb1@huawei.com>
Date: Thu, 25 Jun 2026 20:22:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260609-ecc_panic-v9-4-432a74002e74@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: BB5282000F
X-Stat-Signature: phm4hypcqsgnyomnmgkyqnhki4ky4qzk
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782390186-253014
X-HE-Meta: U2FsdGVkX188hE18HBT9p00mMqXPwi96hUsx1oNhqK6tjVf+gLTUbhLaPATmzqFjp4UK9nYYBpEquIfPf4CAIDfA6z9WtlcgDYF2puN5vhGEymo43iLSHCQUwtXQJ0HvJ3HKVsqsASke/2yy5rUGS7AyLNS7J8pdWAALs3+V6JDXtHElxPnsgZaoESczX1iKUTqTf6QRyWmM7Q1Vi0a5lJyNdq8Q0fLDONABgsyM+3Mzvd6x6jMqFSRNtPLcoCBek03C5QDG7MmE8FBBCN+Za/BgN1tziSAWdOH3KBwub24Rsdj9Xe8hJBZnqZNCHUJsZqJK1qcw4MMC3u1Vrc4Ka39l1BGOByZBhSiyi796hbH+kpKG1XIgxN413GjHttLmExl8YIEYpBNzWJ8pRLtr17kWiXFT4sYmthxfweU7uTxYxEQhhGj0lR0wi7hrvwdogg3DN7uJHxjhfz69NduyTA6OIkosz7AA7qzVk1A04en0uHKiwlPW1BMNn9aopgSZ6WGu1G8nJNueTfdu7xsZDMhI/tQzuppR+z0pUir/YsLemzwtklXyvj5WDB6uSlO7IBpx7Cp2IKc8gJ/w0vje6VLEFEMm62ozOqSY5aOeAWFGZlD1XUj+p3Gs0ijO5senQnE8b56I4dM5Xl37sUSX7irDQhaqEi74xeUj+mBJo3AWhD5k2+mE1eNKFCljPKZoS3a6+qL9+1iDo52Pceok54YvposrFf/0HU9uZnBsAlLsOPIMInY8IZy86YTSL7p8JkeT4isLy1MopleRMUJmRxyswAq5jeiLjnz4UtejQt0KOOp1ttr9p+xs69bsFSAbS7vsUVlOHK+2iMjo6Z36n8Dr/7dt22fL4p0lGUXlWLTjmxZ5BnUujX4EY5+gqvZAibOhWdus2YZ6+n7A1p2Zvg+mbk8ah/3nzR+FNCk2nbntNT2oDfM7a1Ji40ss58hOUJGrko4BJu1FfzG9K9j
 H07yaimi
 efYlCgOQ+5yOgyVxxYKwvSTbTtVsv4HJsPsaJl9fI5I1VhSk4QOhbm9QTszHW8d1tZXjEwDtEdBxPdMfs65wAy+8NcSGykHYmucfqrSlSFF6lnLxED2/DoXovGfeORrwYF3o12RFitooduI39M3pdc6p9bkqRIcRp04ZPWRs2NWk1ao9w0lLWB2ADmzwMemVVc4k6T9ZRIWQAtTFvS7G3sS1+TQs3RYnSjC2HfsgGW0NT02X26NUzqzd4bbU522IkxT6xjhyAyOiuEUGQE2jCFWACJ4thQUU5zpuHdENTvUj/rPhR4N84GCRYWHmL8n9HnHBjY0Mv4ySGYlEQKOcwRgmSWK1LyAIw63EZATgIr/9Rl/Gzr/V/bWvLxGHOxBoVRKoRfKoMuoVUcLjZGQnmcNJXzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/9 18:56, Breno Leitao wrote:
> Add a sysctl panic_on_unrecoverable_memory_failure (disabled by
> default) that triggers a kernel panic when memory_failure()
> encounters pages that cannot be recovered.  This provides a clean
> crash with useful debug information rather than allowing silent
> data corruption or a delayed crash at an unrelated code path.
> 
> Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with
> result == MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL
> covers PG_reserved pages and the kernel-owned pages promoted from
> get_hwpoison_page() via -ENOTRECOVERABLE (slab, page tables,
> large-kmalloc).
> 
> All other action types are excluded:
> 
> - MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
>   transient refcount races with the page allocator (an in-flight buddy
>   allocation has refcount 0 and is no longer on the buddy free list,
>   briefly), and panicking on them would risk killing the box for what
>   is actually a recoverable userspace page.
> 
> - MF_MSG_UNKNOWN means identify_page_state() could not classify the
>   page; that is precisely the wrong basis for a panic decision.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

