Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0037FCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 08:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A676B0007; Mon, 17 Nov 2025 03:12:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1420A6B0008; Mon, 17 Nov 2025 03:12:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EED6B000A; Mon, 17 Nov 2025 03:12:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7FEF6B0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:12:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90EE113C257
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:12:06 +0000 (UTC)
X-FDA: 84119381052.08.68D846A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 421ABC0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:12:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O1ezqFQs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763367125; a=rsa-sha256;
	cv=none;
	b=BAoJHTC2USrs7uXhm+lk8Dq+NAspOz+SLsNRRmzBqGG1+cBBb7MvJLOdGALiaqoHc7x50l
	GckG8FNZ07zHFw6gpCGKwhM/jPw88rpnK5Krb5+ewbL063f80TAAJ/SB24wE9at5ySIcIh
	Pcg73JMzZVnTw6QJ8F9qR4abk9XN/ZY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O1ezqFQs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763367125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KO0iXDj659dZrq6EeugGF6q3grZ3cl61BYTartNYOkc=;
	b=xGtLe2piWaCt2WFGL8trgxQHaQYTwN6Jjy4RXNlRoO1cZEEeOJSNkeMrbbNgMEk0Z81+wd
	mCvslXXRkhkqPRJBPJhCgNT7ryELdKgAOQDZXbCqa7w9UjDVZQ7R3tttsruGKdegP5Nz1i
	Itdc5c2TL9JVbbxjwGGGsXYMZuirPa8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763367120; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KO0iXDj659dZrq6EeugGF6q3grZ3cl61BYTartNYOkc=;
	b=O1ezqFQs2bF1XAHFblvP89oDYkSJludUKEmIH/XVSRp8ykPrJxrK9b5K18gyjjsqoOq8VPH+USmDb/NlRZHnWUfwVkA69naCHROc4OlvXrKDYFAunhE3XzlJewwKPRPvhousEheAJabyF2ARAmkNI4xxf6UQOhMFAWUFjqaUYAw=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsWxr8k_1763367118 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Nov 2025 16:11:58 +0800
Message-ID: <aebb1763-7a7a-4231-a781-7a76aec97b6a@linux.alibaba.com>
Date: Mon, 17 Nov 2025 16:11:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 3/3] mm/khugepaged: unify SCAN_PMD_NONE and
 SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-4-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251114030028.7035-4-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 421ABC0006
X-Stat-Signature: 7rm5if391t1dc3pkfp78pbb9dcd3aez9
X-Rspam-User: 
X-HE-Tag: 1763367123-534431
X-HE-Meta: U2FsdGVkX191YjdvzyDGEgN0UcwVr18evd/cJhnueklsPZLCGPf5Vpz2W7TXMXYevLp2GtofO90/7Cnzlxyy/tn7vJPMcKztkWZYTrQq+awFTOtEbZpXhJe+/CNkOox3poE1sjzhvetpfblaYYh3+LZYPsk/3YMnkXKryzqOYlyPSSP8TL0navol4nyNH4sUhs6ZHFpbu+8Z42EQ+eYwZow1GeJbfj2dEZkbURTr4DAWGDGKRfq7BEPkTm/G3jCK3kcyT+5vrsky6yJ48cMQrwmac7/DcX5KgGiu1rHHKT1rJjaQN9lVGlCofmfM8hFoE05ivak3/+AwVMGPb6RHg6/kupGV27UOtqt15W1+JNe5lrdjFW9+EVAIxs7G1EpJTilT2c0VlKy1jztO8r9En3Ag53gY9AyBfk1ifux6wIu0BPzWvzBelZ99m0G1Ha7D/dmI00BQTWp2FHT5CbFGSxM6c8V5wsC5qSl6s9zMa2LzalRhfTh09iuOxKQytuGD/Bs+usobq6oYfwK+EeLxLMtvolpXf08eZ8kDok3jZiYCS94cAakJUNk7d0FycXS2LUO3e/DsRne7/b7mwhWJwwdehYaCXeQVjGPzcDjpbebpRyxefrR8GnBiOlLN1WhC3vo1DHDXNjX+eTYr+Am07EBqqPVMVLwGQcK12jab9PgGuaa8ERWoVLqxS+ev8WdtfX4XAegy2eGgj+TW4SZxOUyLjo2jwyu97smFy+5eleTbYGw1D2dsudbn1MTB5v54LglZfJaLG0nViUZzSl7+rZ/rf6O9zlWT00seXReaXMw6mDp2zR88zJdMWkRT9LkTyy1b+JV1zndlq0ejisPSKqPmO2FcSS0DlSWNbjMGCb/XnKFNRf0rdSW6MVhRWPz0KcU+g/zC01KsfrxGyXV7jo5TecxvuHZM7+kHn1y9SmX34w3v0AhAJGsuBBt73/7TcVqf4CmkAx+oIhe9qdD
 YBRk5VLU
 RNKReaSTGS67xl3qGZUJwiWBJsQlIBr0Os7xUlZzvW8Ukpjq2+tg4UFLa+kKun1NfyvN+lpwr68guffTWiTGVEloXc0ynScsTVYcIVPqD/5KvaE+/qNvs3/x0Wa74Lt45GOxIARQ5jB4yjF3FmXpBFrQx/YYCc9zZJnjMob4r/sdUK9fdp9ofpRYFp8kscjD8ao+DuiVF20B68PtjTF3etY9gFo/AQ8TPGeDioCqhWeQFn8sySW2mvtDjaRqxuiZB33oiAN2hEZEz3Wmoh6yN4eJiXSdj0powtbDsRPUXahGzO5k8NuZsi0rq0iAKC2fZkcTN8wjK8y+0JJ8Du1m/7i75ZqZh7xYYVYhHD2Fy1WfMQeMhbDLe7CLYw4UTiSFDnDaL2v1odKczLYsBEiVlmBorwH2ozNWfRGu0GT2X+5dO808BzGOX8wfZKM92auXEeUwJgOzr1MXiWdbJL2zoAlIHVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/14 11:00, Wei Yang wrote:
> The current hugepage collapse scan results include two separate values,
> SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by
> the consuming code.
> 
> To reduce confusion and improve long-term maintenance, this commit
> merges these two functionally equivalent states into a single, clearer
> identifier: SCAN_NO_PTE_TABLE
> 
> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Looks cleaner. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

