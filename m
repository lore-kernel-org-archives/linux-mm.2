Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3609C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0026B0092; Tue,  7 Jul 2026 21:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1376B0093; Tue,  7 Jul 2026 21:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743846B0095; Tue,  7 Jul 2026 21:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3231E6B0092
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:14:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9024E16901E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:14:41 +0000 (UTC)
X-FDA: 84963839562.19.2DA8C1F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 637E1180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:14:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HyLsUw4S;
	spf=pass (imf06.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783473279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku4PapYckW8dbwQ0G/KnJTyAyuoC7+bOFDK3+GhNzig=;
	b=mEoFMq+K6KJBtAamiP2DpxAxcJGZki0UXJJBpBcf0/KW8odAJEd9zD6ylTQXOF43GXVc5k
	6m1tVgTLhDcQV5BJtu/kw8a/WsRH8rbE6GBpoXs96bPKoNDJMzquL9MPjkWwxCFdT96Y8p
	qftqDy/uWeNechxjTJnYxPCi1vB4iNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783473279;
	b=bL4qaG+lrtQlP0t35OQYaW6IGear2adc+goL3BIWiXkPzB7aWoanWmChiBvY8q99rnlpr2
	4bJgLCxOHyjTI6tl3ICzJ8l7Pl5bhyn5z78I0xxwLMtmMzE4IzrgT6+XspBgw4is3aQ5PN
	ZtbIlAt4Fjwz9xJ8Vcxqtob6tDPDQrE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HyLsUw4S;
	spf=pass (imf06.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ku4PapYckW8dbwQ0G/KnJTyAyuoC7+bOFDK3+GhNzig=;
	b=HyLsUw4SAyn+5/J+UNKHlyWI/SvXesd1deNMourwRlHUxMnLz0xWEkaXYtx0v0bOXs2V1oTe/
	kG/Mzrsyf85a4i2A5wMvEaX1qJcuHq3w0fSQU3tEuFESsxEtD5DIbY5gXcW1ntBcv9S4hQJ3e7K
	PwpvEMp1gG3CPvf6dkr4T2g=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gw0Jy1CMDz12LHk;
	Wed,  8 Jul 2026 09:05:54 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 8AC4340561;
	Wed,  8 Jul 2026 09:14:33 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 8 Jul 2026 09:14:32 +0800
Message-ID: <7ce07560-3314-4d5a-b81a-14a68b471995@huawei.com>
Date: Wed, 8 Jul 2026 09:14:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: fix missing migratable flag on same-node
 hugetlb migration
To: <akpm@linux-foundation.org>
References: <20260707110254.3147686-1-mawupeng1@huawei.com>
 <20260707132138.d11a3a759bac55ea5f0f8c22@linux-foundation.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20260707132138.d11a3a759bac55ea5f0f8c22@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 637E1180002
X-Stat-Signature: d3nthrmgjfm4btqafts7cs5e49da9zs9
X-HE-Tag: 1783473278-819627
X-HE-Meta: U2FsdGVkX18SncFL2LwdJGFBgx/gW0AY+xmHzbvCPtpbyDcHEHSt8A6migwVHmYTrAaV3ittxVBGpcmXrhCX/+YJ02EPdlEDNkZOCmaNJoq7b3o/pRVJlB3bGO3Jz8uysdaZBCEv/fC6s3J6qOFs/9ofE7VPxzddEZgAcYsGnNVlm8NVMFjzWCmrXqi6SchymfvJSDBwV0ftQGMHzRJ+pKHZLTBRpw1+rscsB//F/uYiDb46jwU6Tl+WrbHv4+QoiLrl1M1F7Jdbk+YhGB+uzeyp6GAOq/eu4U2G3zPFnP9TE/lUIM7Yx6uGhB9h7irdYqUEHIOgIUKrrd8pHHHBsR/PR/s0fTMXMtE/s9h0vl1zEwMhD9ATX/EKuuUZcORsixAHbn19L7pwwVP8OkCzBs4KKZrNgq567JtZ+J2AytjNAv+k7Y7BeENVegXudcCpnLhwTObHIcp41isGoeLxtHfSr6KSm6bc0CgYmUDt8GynEk0If5sv/tKaw2H4vOL1lxhDoXF59T1LQ1htSMVjo8H4vFUjqDVIWpEYue82LVy2Op8Y+uHUhLO8gHDxUbm1wHZh+E8QmFV3zB1Jjd+RtX3XULR5Lnm5R/i5qdTErEnkU6Ikwexf3BvTNrFDRtxfQMNIpIaXLpQXTalJVNI6g5E+ElHqYt4u9doWLvlCknDmhg8Jvc0Lmu+ZCftVnoVpe7qgsj17V0NKUZN9/JeByMwJvZUiK1jlRSCCoq41OAuSwvHXdBllgcubqtinD40vgyUTC8hUWE1AldV0O7Kfu9FFejFo6vEzcJZ058gX9x1jiw30gpULlPNBB7e2OKJkr9GNI5ZaWE+nWbzXfPcrOaWnZ98E5tmPHTXzhe9aKQ0ueiiXUjV4w2dHhwSu000ecBvN+794LrTxjpw8OTDUEHmynycaY+hQrR/LNCvlVWjzedo5j4KdpOjsteBlUR+BinMrvvb1qE0xNE80ZpT
 B5Sitj+s
 uWmt0b4V5eU93QIuecicEiQymqSpw0a2uGefe6Owt1blMIpFQal5bto1n5/gamGh3NS1pkafxwl8OR2A99GuRLaPh+haQEBa3Dvag18SSWiHJh17fKfu7GBQIBJxceuwxcaM6ztY9l/9CxLRaLBctR1XEWcuqLh9ia03QEtVyDYnI6BP2iEVGh1qdvO7KvHAkG4RyEzIDIC0TO88rKvr/zTczQsL311T4/f0Y1aAnEhlTViIOx+oSWB/sEi2L8ux4uuIYgP1bnI+nT2JeFvslTZvysPrtM/+Meh7NR7cX5YGhrNUxwHi7cgmVpV7AOEnvO/Kk7v5bEz7FaYOtYl/PrRXYPtc/cTH+ZO+xxVOn1tz8yo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周三 2026-7-8 04:21, Andrew Morton wrote:
> On Tue, 7 Jul 2026 19:02:54 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:
> 
>> Commit ba23f58de896 ("mm/migrate: don't call
>> folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
>> the migratable flag and active-list placement from
>> folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
>> the freshly allocated destination folio is handled where allocation is
>> known to have succeeded.
>>
>> Unfortunately, the new code was appended after the existing
>> temporary-folio block in move_hugetlb_state(), which contains an early
>> return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
>> the surplus state transfer code in move_hugetlb_state()"):
>>
>>   if (folio_test_hugetlb_temporary(new_folio)) {
>>       ...
>>       if (new_nid == old_nid)
>>           return;                       <-- skips the new code
>>       ...
>>   }
>>
>>   /* added by ba23f58 */
>>   folio_set_hugetlb_migratable(new_folio);
>>   list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);
>>
>> When the destination folio is temporary (i.e. the hugetlb pool was
>> exhausted and the migration callback fell back to
>> alloc_migrate_hugetlb_folio()) and the migration does not cross a
>> node -- the common case, and always true on a single-NUMA system --
>> move_hugetlb_state() returns before setting the migratable flag or
>> adding the new folio to the active list. The destination folio is
>> then installed in the page table but cannot be isolated afterwards,
>> since folio_isolate_hugetlb() rejects folios without the migratable
>> flag; a subsequent soft-offline, hard-offline or memory-hotplug
>> offline of that folio fails with -EBUSY.
>>
>> This was reproduced on a single-NUMA arm64 VM: a second
>> MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
>> and logged "hugepage isolation failed".
>>
>> Keep the surplus adjustment, which is the only part that depends on
>> the node crossing, guarded by `if (new_nid != old_nid)', while making
>> the migratable flag and active-list placement unconditional. This
>> preserves the cleanup intent of ba23f58 and closes the early-return
>> hole.
> 
> Thanks, I'll queue this for test and review.
> 
>> Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
> 
> It sounds like we should backport this into -stable kernels?

Yes, it is precisely because this patch was backported to 6.6 stable that
we discovered this issue.

> 
> 


