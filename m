Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45190C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218B56B0092; Thu, 10 Sep 2026 20:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0226B0093; Thu, 10 Sep 2026 20:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D716B0095; Thu, 10 Sep 2026 20:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D240B6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:58:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43DBD1606B4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:58:04 +0000 (UTC)
X-FDA: 85199669688.29.9BDAB28
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2845640004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:58:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oJ8nYRlU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789088282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06ewrVmtpiUthW0f0X+LeH7QcawiHpWQIKkhx26qBG4=;
	b=6Pf8m1U/qzRHKHmCXmTY/RRxRC0RLJXfxks+eBMndKVKJlqA9hPYXGIVEy/mrgPFX7urcq
	+TP295qemy03OYKUiYEcc1D37lumm1AHYHFqFlUkApPEai5tvJMKzVLFwUaAE4nr01fF1I
	+qmLyQOLC40i46nQN3CSAwig4akGcFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789088282;
	b=fE/fQ1iJVYWVWxJj1PDVYnaNXul5xGODN8qa30/2n0JlyjdK0nHRiBU8wJ9I/uzKwkFbtz
	LbLqtdbpuqp/VC9aXv/nxvd9GZaT9NOk0RoBhWEmiLAjgbzOFzf2qfbm5irdBGfGtnBxPb
	K+eGcQrL3s+bOW6UZOT7IAEH4s7Ac6o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oJ8nYRlU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=06ewrVmtpiUthW0f0X+LeH7QcawiHpWQIKkhx26qBG4=;
	b=oJ8nYRlUe0gbBczxWto/aUXlXyWSDiEjP/Mf743T2ujLnGFToOXhADQtS5kDyjj6qYd002ERB
	JMPiNcP7oElOizkrrypqA8tIlk077fMEj/x4k7Dh1dh9iG2Puu8vd9Wqt7VQSgF//LBM/D+N3PR
	ADwJzBiCpYdFOtsCtfve/5g=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hgwq84sgdzLlX5;
	Fri, 11 Sep 2026 08:47:00 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C2254056C;
	Fri, 11 Sep 2026 08:57:56 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 08:57:54 +0800
Message-ID: <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
Date: Fri, 11 Sep 2026 08:57:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux MM
	<linux-mm@kvack.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqLqeTsbKBMEsl-G@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2845640004
X-Stat-Signature: ekx8udqb49zfcc99ia1su8bzxkcsdnyb
X-HE-Tag: 1789088281-739366
X-HE-Meta: U2FsdGVkX1+cV0m68o3GXgkxYIlPjBHjw3L7mitpydg/lz0sgXwJT7w2Ibif4AeE4JrsktGu1VCSQZb/Npc2dblZZgOvAnWr0bZRPY1vMq255DcZzZGFhKlBRPM3tPQy1uscfOdUbL8k6grVOPqDqbA2V1SbhRMdr5Oc3Q0vXq2wQO3cK4ikNP1a1wx4vlC9y+xr1iIi9rfKwOIquc1aDU7UVhm3vhxothRXIYC5/8+qu15gRdyT1uqcKb0L5+N0a7rqImpEX0p2YpXdI5IeX0mbNDdeCHgLlCjYrEkHC8ilsmSbF3jrVZ9Fg38dwa6FNntDbMyb9uu5iZeFaoV68ibZgtzyuDqDdbwpg+M6IKYGe0e5zl3TcUvEn9dSHP8iK+2d9STRkZx5bj2bVul50aj9Yk14sAk8zSbiKhYRZdCV+1dVvspE2r0I5OjNU1TqafF+W5qJxoBkA1L+yjtsoTnbeYK3wJYbvzP84FTvnLb6zh8NkGWBalqo/sxMy2ottxI4hjUjiSZdhc72SQR1fU7M03PsX6ghz+JOMe+5Hctgkfbw0kgK4Ta8Tz5F/OejvgjL1t1NZEB6xPUPK1AzIOqFxi4yb/T2QZdsvute6UBX1Wy2cKPzgiy/Ygag1FmeFMcTKPVbGmlJK20CUAD63oaxXVOwRKDP3pss7wp2aqIzmF8EMUxCF199VFgR5z3s4ODeLs3Wam84VuRb/PCWD+KeVOSz/MkNp1hLQub0lowjRp9vQb/UnuwmKiv2DEoTzV5CxbzG93sBYQ9WzqneptHeJQTmQ0TaPqusXKVuQkIB+K67ZHBLU9/K1H29d7qBl1DeOVMuSSUk2J6o9zekg/WFpLTB73MghqV4QIXOZeZpTkfXcBKQOyMWeafXzlD6ThfimMDdNsZkJ+ui/kpjVG0LJormGOeaOfqlULLkprJeBkNC9ZhSJOau1TVPN6HIpP+wuQpm7XY/I4wcenJ
 fJuuEMJb
 9m+Xk7AyZcXhjZCg/wG4cUU5DlBvK7Wg32IleK5PSm+zwhwcY0cp6op/EBEe/BAPaBjtuMhDCe89vO01C6TR50wdp9uoI4xTtv8Npuk2T2rSrKIIq6sZxYVgon/VOMMoF2fxoC3l3Oc+bf9dV4HdrdpNO2SWtUH8acG5h6fjcukhpRAwZOFHtz2UF6CKd+od78dDPQYVPOQ+LY12StOmiS0Z+m/VlE/rQJmtcOSJBiGpn+ZS+tvMKgb6/nsL8yqsWbQ7x/IFnKwR4vA3OeuQ2yLJR/ify1oNHV8izY3GE5D15BxeG5xj2R72mGQB16pv1KFFfchXvQYmF/z4S7vL+x6PIdXjxMgGhzKsH3T0sORlFW4cfy4+9fiTib+iqIu39NN0y9V6HBmHX1cCwTB+DuPrDZXMUUhbvSyBqb1hgItEuabgRhvPR3uInacwV6H2EFSrZlRwdD0d8tMVXMvEH7X//UeLqpgC8j6o09sN18WGFpfPBvWvdfbqzqZToMfIf0Thx+peYOD/xYFyWCwY4yY6tgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc list

On 9/11/2026 1:35 AM, Brian Foster wrote:
> On Thu, Sep 10, 2026 at 10:07:41PM +0800, Kefeng Wang wrote:
>> Open code the helpers so that tp->t_pflags access is explicit, reducing
>> the risk of misusing them outside the transaction owner thread as seen
>> in xfs_btree_split_worker().
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> Any reason this is not cc'd to the list? That aside:

Oh，my bad, sorry for missing it, should I resend it?

Another question is the target repository for merging this patch.
Both this patch and the previous bug fix are based on the mm-new
branch. Merging into xfs separately (if an independent branch exists) 
might cause conflicts.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 


Thanks.

