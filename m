Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20761C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCB46B008A; Fri, 18 Sep 2026 05:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F1D6B008C; Fri, 18 Sep 2026 05:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135366B0093; Fri, 18 Sep 2026 05:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4EF86B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:01:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3B2212060E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:01:49 +0000 (UTC)
X-FDA: 85226290338.11.8D6CB9B
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55CC7120008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:01:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=btRjn6cd;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722107;
	b=10zN+4MJlhz9SWcLr1SctQ+36NK7sC+8U376aFPFtVzI9hMs+uD2haGytF6e+cGgtsQc+t
	XbafZwCkNPsHJGg3/XLGYDewPJCZcLrdMHwVFK5fWDOW0CIkdNbc/XT/cGmeHna+PrXBnS
	C3pxZvk5oi6BuYPFiuvZ3q9ZYT2xOn0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=btRjn6cd;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cXjWzaRtWxw32n4xjyS3mKbdHRC6dQcSY+YfxC7m4k=;
	b=G8SV0DpiHXonyshodvfmT7kIqTcpkmtytDYyQslm+Mt3NwIaItDOWVFVyxC62CVmMHvsWE
	CnI8eM5Qz9Ipq4PUbmHZLJmNOW9fhNU6rqDbO3iE7iahTmwBbBVKt6o7T5OikBUABPzVSR
	Cccp1jYlbmUJXPWWl4g78FHnd4p/KP0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789722103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7cXjWzaRtWxw32n4xjyS3mKbdHRC6dQcSY+YfxC7m4k=;
	b=btRjn6cdcPuxWThkS5JR2V2Wr6f0tKNaRyZNvjzW8Na5cQzzLd5qIPJ+E+4TFef/gIWkCsjvBSulXa0Q4RTB5svo5zYfkaUjcV8NK7wTyo+0yQubl59Fc+2FCbbMN0jiL+8dxeFvpCgwyNGe8O5iIxw0V1zl9oEhO8ZhI6xPGVw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XBArCsH_1789722100;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBArCsH_1789722100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 17:01:42 +0800
Message-ID: <5ae6a85d-1e74-4ef2-905b-0bc3491d1450@linux.alibaba.com>
Date: Fri, 18 Sep 2026 17:01:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55CC7120008
X-Stat-Signature: poeqxyfpoiueetwn9h11fe4iwrpz3xc8
X-HE-Tag: 1789722105-993549
X-HE-Meta: U2FsdGVkX1+x4LgYjQX800pD+GjkM+9+4BiPA/HrVvQIYh05zB2ww+Jv+qFR8ytopklb8CpR6GFrFB3Q7tvm+havWPiAcg1hE4RUSzuZxy/MB04SE7ZDyneJdBGjxMBiMv/q3J04DWilcgwCen116ofzrjZ5FTPCPZqglXDDF3Arl0vR2Jpv+OM/hDWUpgMIY28VTDia4Ggf++hXqaIEnNYg/3FvTk2S3PZ8ctBSodXdkusBtd8mMj5XuMc2X8ULBUGJMon9RMdGe3OYRI8NtHSLzgOqVTFjbDXs+Xi6FAuUsEfusuMKZiDnIJCQliasstdIBiV1iCRRqHNFI3BjE+YC8J1nJCsnvzM9NZ4/Xs8yQi45LmZ4YJiN+9SSJNWqljTGWdOJh+GEBT+cLnZ4bXKGeg1QfjUZRJLqJFDm5njGYdAlvjy2b9d3TehZNPrkEcUvr+f/lQM/nw8tW951HJp09F/dkvMAsl8tcQNFkxiiBxPDeyXN9Fxxe7Gj56qMEq9skquSJmlca2gnUXRdiwOtBk2isVTHjVu+q4JSwGKOxVbAQigSRYDmMke0eUHlR02rSShFn/D4xmezWigWujl2Bp0P+3S6jjpa+gFXVwzlqbC2zleia2F3aArUA9q/hW2stCDN0nC3jkNDmOD4xX5VPefFglrJdo+DE89n3WZWK0Sxfpm2wGzkdAUHUYiz5X0g/ofxmXRR/3xWXdYDqNknUXhhysiT/rx3nN2s9tZ6cIzn84pB6Pyq17jl/qbpZxBTBYKAtgr6mzpwm99LVXtxvav1BJneCwnEpQ//0piT65SRFj/JBaDg4wUp/3GeEoO7hAkG6dKoGK/bq58ewtuh4zitLOnQB7GNE61C65Gt95mDkZJgkpiCw2Ow5TQUORhGmUxbutz8Poxs8B3cYBFHYHTO6D4Q9Hw+RXaHUj/H3mh5ufl68iQ3wHpFASyxjKown11R/YEebFeJy+x
 mQAQfWpN
 zhVrwZM2HSVzBHYNoXG4ReBn8Mu3Q3u9znaP1ervT/18EhIfhfD8GDZuyaXx4mykvruOQnC0aGffP5Jp7UwWYwZlst+hDFFtvk/99wvGtP0BZg/2Dy3Akd1+HO70O9NzEkfUkI0uzTyXbZnZFQEQ1FxImDY3FTmbJFjcOudFUAeTivJs/Mk0420v04qhyRpyYhGAzpFbyi2QtLJ6SRvhTa1aTsj6rdBFoVBhz5b7JrRKQpNJNDF4LRDUNf7r5B0yLEzYlQt/gjpR3u/TEZKp4eUUyRsyFgaLcKfpR6+ncd7JRCJodLAPodYp60rD0MIydSQpbzNGfbXMwO0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 9:45 AM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>     considered
>   - Filter out PMD and PUD orders from allowable orders when
>     PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

