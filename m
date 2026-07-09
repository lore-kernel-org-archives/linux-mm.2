Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C22C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC846B0088; Wed,  8 Jul 2026 23:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D996B008A; Wed,  8 Jul 2026 23:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176626B008C; Wed,  8 Jul 2026 23:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA16D6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:04:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 420A01A037B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:04:00 +0000 (UTC)
X-FDA: 84967743840.23.117027E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B0928000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:03:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783566238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqAb7UusK86izOYbDkIF6M311BQgnlbPqfjj6tfV+KA=;
	b=ZGvIt06UTBq6kMR2GxaV+toKwpG7wMlcIGKKXQxa33TsKYpEQkTdeehyreu2Kx123Nkd60
	WiQMkI7wCB0iDYthRNyPbhIwEEUangGF651/56alos76qnVUCy0y5jkbJWo2Ksq3TIKQtl
	ZJeXFS9gLc10gFCkATp+cgbDlx1yDG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783566238;
	b=fap1w11pYxMcUgFii6ZbeFewChkFYniwo2uuXMYEuTWu//8E9fOIab+C7ot19EySJgHSiT
	GM3up68X0BDNtUvtv3zWOVK5RKHaVDTxIGrjYGix+/IkxyND1S7ZjZnUz5ac9JOSaNzRtO
	eVfSaN5xFR9LPjO8yGjVsDYWKjUjGhM=
X-UUID: ce9ad4a27b4211f1aa26b74ffac11d73-20260709
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_7B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, UD_TRUSTED, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e883fde6-ce4f-4abd-b8f5-b11a700601e7,IP:10,
	URL:70,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:80
X-CID-INFO: VERSION:1.3.12,REQID:e883fde6-ce4f-4abd-b8f5-b11a700601e7,IP:10,UR
	L:70,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
	N:quarantine,TS:80
X-CID-META: VersionHash:e7bac3a,CLOUDID:0de3d54f95152217951725f6c7d421f6,BulkI
	D:260708211528KWIAZP6K,BulkQuantity:3,Recheck:0,SF:10|38|64|66|78|80|81|82
	|83|127|841|865|898|1209,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|14|93|
	82|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,S
	PR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ASC,TF_CID_SPAM_ULN,TF_CID_SPAM_UPP,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ce9ad4a27b4211f1aa26b74ffac11d73-20260709
X-User: lihongfu@kylinos.cn
Received: from [192.168.109.123] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 717094302; Thu, 09 Jul 2026 11:03:48 +0800
Message-ID: <06b77011-4c48-4d9e-a27e-e50f23e729f6@kylinos.cn>
Date: Thu, 9 Jul 2026 11:03:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
To: Andrew Morton <akpm@linux-foundation.org>, Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
 <20260708193721.5aae192c95bd8c7840e9c1b0@linux-foundation.org>
From: Hongfu Li <lihongfu@kylinos.cn>
In-Reply-To: <20260708193721.5aae192c95bd8c7840e9c1b0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yy5ec7f4gbihb1f18mdk17ngx4h1o5on
X-Rspamd-Queue-Id: 0B0928000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783566236-204412
X-HE-Meta: U2FsdGVkX19sWV0DHWjuNVhfzhpRu7HdSmc8poz1aRHtSZSueSS/4/f/ChtbscIiUSNzbCZoD4qwY668abEBjvJhfaVSmRSmcJINWj7q2YiLglpVZj2DmOY0zSeBhpcvDwx0QGplfSe/DgjJQvSBkP3wv138b51T7+UaHvphVMIAXPefctlN8IqVz3s5s92yRoRn81dtG4HQb4gzdN0M50wy+o8eFkWGL3IJtuQ+q3Ev9/lft+VSianx/XP0KZn9BLkQH/fAawjI7yPTzhVFUJm2mf96xJZkQIaXABOMf02uec8zUwOh3mUx7jzsa+ZYDJg1ifFNkTvUx/1bxwYWPdbKj92/kFHb2x8YCZwLcZ+PmWsPe5Hb3PtYAGM03msSozoC41TMW4t3bQarmdXMLdVRXDyMEXE9VDef/YPth834CMkzGonuD1njjl9aIeMU4LawWcMEqj79FdIKWlKLEgJBZznKT4vqSiE1fj5bP1zWJC4xlduefa6UUYmVU4SZMMWsrIlEmCVlNvnYx2IUvPuqLEsMVb7AdB4n6Ln1+Adf3k3tUw7fHtNlls/t2FGTjeP0YgmHlhJgpo34Sccsom1J0xJJONPNDJAgg7BKTqkTuBd4JEt8iiF3Sq2QNs7X77daYElXJx82HpAFVEbpeFytCQlt9aeACF7lSg0aY3M6abxQsUYddi4uReE62iK6gv7BgqOTaO4PVWTf037wQ3l93zTNp5PvbmYQ5GbNgT2O+hYmhd3ZrjwQNRPm13QZQvoQDIixRLoKe75/ouj1XA4VnNmHS3TkzaL8aVKrHyTtKIZ1sPWYQazdsQ6z9ta+WJgmY8dnA3JaNBOMsdGtXv1mab9dzgP2hS83UzzJb3J4q09HC9uEJ/HUd3fDPQMBUMuw7yfKQzL9WfrxqrOl/X1X/T7wM9OJ5giPMkIlYMbHEMPXG0Hbw255UF2hNr/idOOXQuNj/jEm0Crr9wu
 RaMX9YqK
 d9fHIQXTJMy86nM2kQPFStqSSAn/4fIEQiIJYe/1zavf1hE6LWcyyfPHiW5zf6WMJWjG2nqsUEPzH+qkdoDOtQtsFaBDvHEJSsn6e6Ou93u7oezY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/9/26 10:37 AM, Andrew Morton wrote:
>> Several early return paths in run_migration_benchmark() skip
>> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
>> label.
> Thanks.  Sashiko found a bug:
> 	https://sashiko.dev/#/patchset/20260708103705.840679-1-lihongfu@kylinos.cn

Thanks a lot for the reminder. I'll address it in the next revision of this patch.

Best regards,
Hongfu


