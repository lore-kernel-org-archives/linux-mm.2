Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA00DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3ED96B0096; Tue, 14 Jul 2026 09:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16896B009D; Tue, 14 Jul 2026 09:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08CA6B009F; Tue, 14 Jul 2026 09:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8596B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:09:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F38DDC022A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:09:33 +0000 (UTC)
X-FDA: 84987413826.01.94AE141
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20FE3A0013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:09:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpRJoLzw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034572;
	b=RxH47cy1lCMEr9vESWUUpwnFpJoxVgsGAY0LucsvAeeUwWPsQKhcXBN89Ov/LSChLkJbsZ
	q5h29jFd0v8K56SufbdVlgr4Zm92dzV1y+/lwEtxk8le2pbPYoHgb27+CCj/M8RTnKS6M8
	WEbIMJktDj/6q0tHg6CRqCH1o7aTjz0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpRJoLzw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuU7fP5JxANN4DJ9eHGNnkUQXlno2tJDQn4DVBGprns=;
	b=RkLxs3LgctMkFwL9hcJ3jc6wWLcFKhhlX5n3Hje3D/H8slo9OPdlcFID5R6gRsXkNjdAgq
	zFg7+uVu+WSMt38Mr5qIPyaZEn2yAUKHXrELdSX02gtPw2SW3oNAJMT1GTf4EUdyH43/Bc
	e3JEwQUKMDGvriLNcm+lgUA5l3t3NjU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC0D5601EC;
	Tue, 14 Jul 2026 13:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B171F000E9;
	Tue, 14 Jul 2026 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034571;
	bh=kuU7fP5JxANN4DJ9eHGNnkUQXlno2tJDQn4DVBGprns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dpRJoLzwZiGcUmL6g/gynlg3FDZmRkf9wZ079mK6qsQlHk4J4q4EbzA/9expriTFc
	 z50SZVFrYDmBd8SHH7a+CO7C3Nab3+2gTGPsMHOAakKTFlFIZS76gA6rxFGDLLIDDC
	 Na//Tc8iXHj3bkqxrXz0/0R4eT/lKmCGE3DENgoEWq60JYtw8J1oZu4Lh8TD9GkfCj
	 bZhkXbF4XhnuK4QZHa6I2sFQ3K3nOmaHKL62Kt+mpbhyturS7KpEG2RPQl333dv4E+
	 n3F9hbKeZEh+zoaW7Ap02LPRs+uSiRTgrW9TDkdIEnPyAEWCixkIvVLNPvTFzPCoZA
	 qF6RcIJIKV0uA==
Message-ID: <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
Date: Tue, 14 Jul 2026 15:09:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
 <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 20FE3A0013
X-Rspam-User: 
X-Stat-Signature: 99dpxs7ebhg31k9mc6cfxxoeu5uyf7kr
X-Rspamd-Server: rspam03
X-HE-Tag: 1784034572-896464
X-HE-Meta: U2FsdGVkX1/9DjuzCO8hak/2l4Wod0QJ3Yh65keCdVZ5k5gaPHHM92qRqLaPsUONjIOvD9k8uDNopJnxdprtLVsDWvfXnMws6Frd6veUKOUpTSO7G+j5aRvdIyBsvVF/9WqVjz5erezTUgDEMeR+qIHUAm1fIxhjIGxRtGr9cX5vGfhGy/cUeRI22c9Xt0i/OwjV2k2Ph1t5uKLSybwUAv3FYqDhw7Ow6cmmNWOBjllZbClQtNXkDhC3dYg2ivXf+oE874UR83YogtKm5OJD+vqUFV6k3r36VhZO+l+NCqltCvZAk+NwHs5MYxqWSI0FeuoAOnRE5dETNEznl1QXfuaNcvmV09qW1GmuvvmJuC4RJOSf5US7mEOoLmsTdYqGw8+YbWs9hj5MjC8kUlkiKeSCeABv01pT/42BNCRIsLPemVZIGKDCjHm8gVZmnV4dpDCIBjhaQbmrmmW+Z6tEfX3Mo34fdDKpREA5p8mH/3Amt2n8m0265QS7dVIh03UZ9h1Uun8nUcke5a+ah5/fYzq5FkifVteSizN/EkheUL67rWY4FbKnKJ59btZIH2pl9zgx2PXYmzjC+ulHIDAw4mNsHn8FY0v43O+wBhy4D7Hjkbe/wFo7/KBsETuIvqWA6m1nJDaqV8+8LfHIVdC3Na44+hIyBd6hnuPQOhLhCuJcyaPt3k3/d32B5jQLKDW0MVhcdmOYSfrlRVJIWAy0ticrDAd7Ck7TrUKNnNOVfkio1rddGD6WzfBJYzedR/0Z9FAeUrA6BQzV5DaArjAZVbyGff9FFOVg5ZfeCVmas20OGguOAaeE3FPca5cqQu9alVx+lkmOckUzFu6tQzf/tgonjmA7UiM4xbd7ge9iCu6o0MrNW1DL3cIyXURL7vnJNM3y1GABOgtDr6YUR+GdzDyPZPT5M3ACURZReoAI2ygWrNV+0vXxK2eYZQPiBRmToccRAYQ42mF9KCde20E
 anwp9a8Q
 kl7k3AxexJIsvbE2C6rhVM1HBrmIQZgly/wky34iFBwFqcPBaOmahxbPTkb3AiFEqL104/AKYoo3iqUSysZZdqZh1x0kp67kukl02FC/QQllCNdUosc/mzYzAR+55Y1dJPrJMtmyEJnOr5uU/sGL6EoSU97JMteI1v1rLwB7LvUfB2UXadETfBq/jpOqEIBRmBa4ujmK1XqBFKJmFPpl3vSSC5H3sc2rNDIGKIOAWqWyiZz3ZD6veHGaeHhGV63335VMPiinfNpPOvAkjnnPw2Ad2kfhidy3hJnb6hf1DO2wY+T+YdL689QFFE4/Dnt1QYAvw3Aa1g4041NuTMF4VGiXj9fcM5OGE5covppNdIU81gDMz8N2a4Cx/I+MqnxWw32N5TPU8O9oJprAFmzwv1BYCwusMv91e4XxpKNx/KKATffU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 15:05, David Hildenbrand (Arm) wrote:
> On 7/14/26 03:51, Ye Liu wrote:
>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>> migration has happened".  Replace the four bare -1 occurrences by
>> adding a proper MR_NEVER member to enum migrate_reason, defining a
>> corresponding "never_migrated" string in the MIGRATE_REASON trace
>> macro, and updating the GDB page_owner script to use MR_NEVER instead
>> of the hardcoded -1 so that lx-dump-page-owner does not incorrectly
>> report unmigrated pages as migrated.
>> 
>> No functional change.
>> 
>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  include/linux/migrate_mode.h    | 1 +
>>  include/trace/events/migrate.h  | 3 ++-
>>  mm/page_owner.c                 | 8 ++++----
>>  scripts/gdb/linux/page_owner.py | 4 +++-
>>  4 files changed, 10 insertions(+), 6 deletions(-)
>> 
>> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
>> index 265c4328b36a..05102d4d2490 100644
>> --- a/include/linux/migrate_mode.h
>> +++ b/include/linux/migrate_mode.h
>> @@ -25,6 +25,7 @@ enum migrate_reason {
>>  	MR_LONGTERM_PIN,
>>  	MR_DEMOTION,
>>  	MR_DAMON,
>> +	MR_NEVER,		/* page has never been migrated */
> 
> Shouldn't this be more like
> 
> "MR_NONE" ?
> 
> As "never" is not really a "reason" ?

It's not used ever as a reason that would be actually passed to migration.
So I think the name is more descriptive this way.



