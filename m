Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE564C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986226B08DE; Tue, 18 Aug 2026 03:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9379A6B08E1; Tue, 18 Aug 2026 03:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8042F6B08EF; Tue, 18 Aug 2026 03:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59F386B08DE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:20:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 244DB1A0B66
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:20:03 +0000 (UTC)
X-FDA: 85113541086.30.FF17835
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id A971E1A000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:20:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RbfV32wO;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787037601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dex9usd/SGgT+PHMQGXC8Jk4Sa5Kicbq9IIgbD3ruw=;
	b=ZthCdcY6eZsgK6NihsvWjz/xptS0oYN5T3SP1mnbDgB09Cpt7JmuxYPn7ChmXxX8lmxZ/t
	lCOS7vfwMFGkYhHJ8D5/NINjBFx3IIWc5IRm/kQmNvQpQVA5cZdCs53lzaH+2qfW2+HbeC
	XXHBFiI0DDh7v1OtO9kjVocPHS/JO7M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RbfV32wO;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787037601;
	b=RI8YgGQtlChGgdENEfYhRlZ11ZjFrSeff4BlYnZt65GMAP7HLWJKkfgqlXaBGqb7J1tUFR
	OFerlJdKdB/bpIAGbBWg9/1DrSIB1Cywl5fugWQcvr5tSlXx8axlkPXWjvtAUhSkipRIea
	uqcLPiOI6j1NSKLlMWzdXIlPGSK2EYI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M/D4ZJ7WZLQYSekWO63cM3Lx+FOmlTfFl015biR0nTE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787037597; v=1; x=1787642397;
 b=RbfV32wOiDQkEwItlqEaOEJLm5vWxhe7mvHnWtAYpbK1VLEc0oo1aAco4iw7KSNnKAbNY3bR
 wBbxzMnWzTuyBohnS+P0zP/DLUa0IbqXgSITBMaFRcNtBzexnPBQq01BQCAn13zHlEEy9xjnzJY
 /gOowUYkXgQTeLKhU+nFxmTc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id e113e2322ca57fa1;
	Tue, 18 Aug 2026 07:19:57 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 15:19:54 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 10/15] mm/mglru: make folio lru referenced times
 count a generic API
Message-ID: <aoQHmlpoyMG_pJVE@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A971E1A000C
X-Stat-Signature: 9dc583c8gb5kdj5qmcrb63wbb3ttdktg
X-Rspam-User: 
X-HE-Tag: 1787037600-731126
X-HE-Meta: U2FsdGVkX18CZEaiCd+DyjkZ20LOUVV2AlLtDySYjf1o4xD+iQ6fPPp4s5sri2woFZIIdP4t3rgD4Cmu39JY08kZfoyU5zRXcr4iJc2qthgdTR5JmixliHzzpzoWkVAug/o23Ex324lXKWb3Yt6g2P59k6/+1XbkFmbmsj9+AhP3muSzUB1a/Q7eNjhmhpvCEcKOqt5ycTq7Sw8nOtftjh0ba6S4oRn2GJi4JnJOTwvBw3ibo8oNaXRs6//McFSBuivJ567W4f28ZXHkOIcbGXQtah43JLOezx+BAZfLrDrPRplHF0XQNkEmWK7HsWPu6gn5J8NM7vzf9OEP+9BNvjbXriKgvFWKCfaLVLGimPssCd7ORqiybdiQA2/JcP8HVqjL6T6btwPcRkVJLZTPD/o5sdfWvE8A9E0laBeYKMD8VzgVkgCGv7UThhJyiTLWiaHWUQ11Go7fev5zYyMcc9VcCPQTuB266cUjColTxZR70mnku8VeTOOueKxfV0diquCd7Rs25b842uoOewUE8sufLvpLSsgIgwKHYp2ho4zaB1tiTnfV4IQ6ueX26tH/BKp3IFwmJGpkNiW0ZwxGKAJJmEUZSw/JAMF8fjddaMANS+Fd+FTyYrvwre3hXCmFAQA7PxqpIbgGjjEJcjZq6Ywat7SUbiZJR3KMl0TRVJNBoqOnBnCtoOX0oOJRMWrIqeoyW97FVCo1byMtvUvFQ0SQSgdie3KDlX4O2mSnkEODcPOd0Dv7oT5n3GIEqWaIMdb1Q5p+B+wGoq6WfrrPGcndCkGJ/Krw7IUJ1gkyzKX3SU3w4r4XhaQJVYS5rtpOkcitdMtmtj9PY4E0TT4LSn3WIGiIpjxj8kTuS6ZtxEGLI7LKhFyY+HWdGNxQeXuPYlx0StPzNhgw+bvOa2nrhDRChfIzRcVjShfv7vd7192BOBUQOJKD2BExDMCMQVsId6IZmEvZA22nNKugAmI
 ifVNIE4A
 k6HrGSoPzaUlhDaRx6xbSaDn2ObWUU5PQ06WQJYrkSPDLFMJQ2etByhP1c4uORrAnA/qu0XEzdZ3VVwSbfU5BSmu49HvNndGFoSQGEuK8yCfrKkJqIz210nBKqsRl9VCBkm3RMTDr6WcMD4+KbZALzvT/syu2lo2mFc7gWic3hizzNgr3+DRHkK6wrpGZEaGahISRJJ+0IpRoTejdh3oM80P7meLlNSma6iXgHV8bhFBwCIUUKVu/DxeSf1n44DbadhmahERttWKVvUd4UI1ye0WkdM1USxldZKi6CEWoXgAakNDThvl5NY7DF0EH8zTSTahhNlOLovkvhLdiLsyWH4NXwLZwkUbO/eLdTuMuId8B49GXHcqUMrpoZsVjyQf2z2U38+FthwwATFdA7EjrgwS+stz3JpXOchIgLhAgqGRt/f42zFM60FvBsBvzRcHvD6sy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
...snip...
> diff --git a/mm/migrate.c b/mm/migrate.c
> index c737d0682fa4..806f1e913a38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  		folio_set_active(newfolio);
>  	} else if (folio_test_clear_unevictable(folio))
>  		folio_set_unevictable(newfolio);
> -	if (folio_test_workingset(folio))
> -		folio_set_workingset(newfolio);
>  	if (folio_test_checked(folio))
>  		folio_set_checked(newfolio);

Change in this place sneaks into this patch?

>  	/*
> 
> -- 
> 2.55.0
> 
> 

