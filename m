Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD99606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MLrCcQeJ
Received: by kanga.kvack.org (Postfix)
	id C44CC6B05B1; Sun,  1 Nov 2026 01:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5096B05B2; Sun,  1 Nov 2026 01:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B166B05B3; Sun,  1 Nov 2026 01:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91EB86B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:39:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90B08808C5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:39:35 +0000 (UTC)
X-FDA: 85385599110.13.8ECDF02
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	by imf19.hostedemail.com (Postfix) with ESMTP id 883811A0002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:39:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MLrCcQeJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793515173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNuwgZxs8v17OaRi5wYNgk0NBjjWdX2IWjeKGNZGg80=;
	b=ZSPc5wFyIUDQVJ2LPE9+RNVG4pgdguB4c+Zvmk66lmk1Je5j+9Y2Yvgexho0aNia1D+6LK
	A475XYxHelz04ZAisBIDJZnZvlpI8dCRupsI58YCuWSpyfKeCDoTgfZMGsOy2yquuGwyJd
	BZ8QinL2wd7Zxz5e7ojvBIdKKscEDQs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MLrCcQeJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793515173;
	b=1yh6fg0S1RPEX0HZF7vReksMPlHnUNACZzfCCAJfKdKEhHY0XPVDV7PfZZ4W4GFcJ9viGw
	ksAVoOLhyMkBUy+MrrpaDarun9jK0ZnZB/96mqhgk7tIfAnvIpQuWFpHB8fdeG8chYbBfT
	JPEL3tCXzvqX1Lx+EHBQT+eIBo4hsP4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Jv2Mo7I2fjHgwZIVG8WGkD+xa/rkd22ydPpwY3VwsqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793515172; v=1; x=1794119972;
 b=MLrCcQeJ4CA7vY8IVFsWbVTfQ005iuULp+doAldRXuEchelse5tEe0nUQ0YbG3urXNaLFWtb
 /zfF8jjphfS/DQgOsXmpWNcocxGA+5FDghvkrMV+Sbqejxtx5krpFrL7QOSWQxzNNdE+8yMJC/r
 B8rzaTt8upXygCpuzzvxW4yQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d9cc37b665f33f48;
	Sun, 01 Nov 2026 06:39:32 +0000
X-Mizu-Trace-ID: d9cc37b665f33f48
X-Migadu-Flow: FLOW_OUT
Message-ID: <ac015015-c661-43ea-bc05-2a37e5420b72@linux.dev>
Date: Sun, 1 Nov 2026 14:39:22 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 883811A0002
X-Stat-Signature: wx34g6c9szfw9jihk5i9hyx4byu84ufg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793515173-369527
X-HE-Meta: U2FsdGVkX18Irrq2G1Oh7ZHsxQhoodlcN8dxuCm1udAtRyC4ydAAa2duGddyPNsLE6eO3vaX+e8d0voKK0JO8dtnMd+NIQQKgWuCjVvgah4nayiitY837gh94nUL58URBnFlj1kqcwmTeIdLfGgD/xApVwdQYmIMN4E3HvVNOfIbivm4JbH/i49b0SnoFBR+8hkXzFxXtMicCGQbwKxXh8tXnLZlcSCcbnSzF1IZgr+BpNMGp3Hsoe/HXJVj3lulPHuZi9dNOSiwLIhiHKLrtS4G/UyXZNulKboXNsuuDmGNsfkpJ7XRwkU35HHLCSYENbC67Di7oOrTXc5FI3LtMrU+NVV7vov5co5p+TwZxmYbBUKgyr3G+RFpA6JTxvOZwaYyJmWjz7QTMCrmJCZ/4io28X8b+nql74HTFVLUljro2qgCP4vWaQoBSPNo6erw0LAFaDQisda6a/xq3wpvAtjdPHBIpHzkFiuSgNcMzgiihAv2FEsehAxBhQVyTWgAiJbLZlxYzo0QPHzO6QmtY7YzlrcbOmyMzKGQ/So3mYevtgSZANak4e9SFkb9JAeZfhdsTKybA/Jn2hXPQvofV4rCgNX0m3enAcX+ekVPWZ8F7QHcxOF7vtLHc9v6aL60fX5Zfwh0xY+22Jf9ecg7Npq+w+ayOUhxVV0PIw9uHeYMIgYI5F3eAHnE0UsFbT+9oio2LAV7q8qzKkNUNnuvjZBDlPzO55hMYfVoIrKrq+5PwDzNyZMAEx0ZoUxhme+lhRBPZ+fcNa4KiZHoI7DyH4yKCLTSRKnUe4hiYtV8o+tqouwI7KgF3PFuedRTS8035cZHY4D/CAgrUQGeYT7aeLgA+G9Di/OCZMP+E1hueb9MeZ7M1746JGqwwNS1GRWOLtWHAWL6rw7UvJjkZJeGcMIkVGnhqHOjuPz1jrnOKpgjlmnAEcVloPeu+cPVVGDW7fLwZDGwT2+UHb0YGKD
 fKFvPrrj
 zFo4AKYCerA7d2SVJVhE0OIU0RVHBw35IV/oDC1c9jD3iqEYs7Lyw9NfiBcsc765VL7VN3cZ0hP0uTbtG3MsMeGeJCCfm14QzhD1Icp3hH4Prs3jFZWGKjrPZwE5yty5mX2z3zn2LxNH3MkhJUUMuo+RZSbrhGgUM1pOpxCdt++LU9E8UQbQwlRBbQT3CTe+tXkjKkzDMui+E0owVlLNJw9KGzf/vTkjO/tVHbCbdNzh6oIxYKvVImg4nwBiyDmHL2EcrDZD2Zv8wi5plORVzAJhFCxQm36VS7ilXEurEj+zdV2g566R2kesb3x0KusC7wiFyX2FV8ZH7xcMAtwg85Qv8dTCPoDNjWhqSW7uxK+A30nss9FyiLtA7Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Vmemmap page allocation is currently tied to restoring a virtual range
> and assumes an empty destination list.  These constraints prevent it from
> being reused when pages are requested independently of a vmemmap range or
> appended to an existing list.
> 
> Generalize the allocator and give it an all-or-nothing list contract so
> the restore and optimization paths can share the same allocation policy.
> This also allows HVO head-page allocation to fail gracefully under memory
> pressure without triggering the OOM killer.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 40 ++++++++++++++++++----------------------
>   1 file changed, 18 insertions(+), 22 deletions(-)

LGTM. so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



