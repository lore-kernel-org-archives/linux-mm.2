Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D73C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7D66B010F; Thu, 24 Jul 2025 03:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478C06B0115; Thu, 24 Jul 2025 03:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E736B0110; Thu, 24 Jul 2025 03:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 212546B010A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:45:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96044802D7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:45:52 +0000 (UTC)
X-FDA: 83698374144.14.6A07113
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3BA1C0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:45:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S0cMiknO;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjBHJMe/Q18LuysRuiW8kz7jNE0xs2d+Q0WubtH/tqk=;
	b=yRgOr0jepYzIZF7/puVjAEzk1GU5s0hLO3Nsyr8SQuTBo05KPg5t/kgLNVYE0yOROQVuLC
	rYVpqn6RmmS4ue9sH+8c/jiR4xsks2iYkf78CdNLG4b7aR47mu4FwxYgO+SByXBn7bDKBw
	Tgz8x5rO/B60afImL4RUSNX1F3y8qhg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S0cMiknO;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343151; a=rsa-sha256;
	cv=none;
	b=KKPtHkJ2c2+i+YU8Qd9Xu52WoJyTFEbbQfvE2vb5j/2IVgx85jvQkoxKz4qD5WCZ5OSN+F
	m/GwtFzOKS8UR1u5hbaTn/nEEjCBXmi/jmEeMf7GSOwnRNU3ZTj+zCLAGBVpkpCQk7Em76
	wpN1ywQCG5zohIuaZiQK5wDrShtZ4zo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753342536; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=hjBHJMe/Q18LuysRuiW8kz7jNE0xs2d+Q0WubtH/tqk=;
	b=S0cMiknOSAY03rZazQ7omK3e+BxfjLqrYgbI2biJFvznoUpLA4EIKfGzdegYhznwGaMOgNw45owCV2nKGTX1zwdLeIUwm7rxxZKYE34w261eo1iGMD85BJ5IVVEYuORXXbboVSUAcluUHDjkUDpQc9Ga3RaEIMoGrN0f7tnExEA=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WjlauW4_1753342521 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Jul 2025 15:35:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
Cc: "Shiyang Ruan (Fujitsu)" <ruansy.fnst@fujitsu.com>,
  "linux-mm@kvack.org" <linux-mm@kvack.org>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  "lkp@intel.com" <lkp@intel.com>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "Yasunori Gotou (Fujitsu)"
 <y-goto@fujitsu.com>,  "mingo@redhat.com" <mingo@redhat.com>,
  "peterz@infradead.org" <peterz@infradead.org>,  "juri.lelli@redhat.com"
 <juri.lelli@redhat.com>,  "vincent.guittot@linaro.org"
 <vincent.guittot@linaro.org>,  "dietmar.eggemann@arm.com"
 <dietmar.eggemann@arm.com>,  "rostedt@goodmis.org" <rostedt@goodmis.org>,
  "mgorman@suse.de" <mgorman@suse.de>,  "vschneid@redhat.com"
 <vschneid@redhat.com>,  Ben Segall <bsegall@google.com>
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
In-Reply-To: <ecc1622e-1076-4c03-9e1b-44aa701e6a5c@fujitsu.com> (Zhijian Li's
	message of "Thu, 24 Jul 2025 03:35:39 +0000")
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
	<ecc1622e-1076-4c03-9e1b-44aa701e6a5c@fujitsu.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Thu, 24 Jul 2025 15:35:20 +0800
Message-ID: <871pq659dz.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: F3BA1C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: ykj7mnwbzzwxtiz5ao1yu3c8xu3g4oip
X-HE-Tag: 1753343149-867307
X-HE-Meta: U2FsdGVkX18ZlveAIIRoExv5f+M5pAM6z8C6RNJi6mC/Ox/ZtOQzGqs7nZc29tgQ4TtEnXoOkLV2OrvGrwUy2tqATs7SHkRQdGZwfeixMvih3nazd9KL1omfPz2mOyBW00D4PMaDLyto1v5tFKTXFP0H6tI7JXc2sH97X8TOR8JvBe47/tNnawbXSyOARlrBZ71hc3/QwPiuttV8g8p6RkoRt2oYSTMxJVevqo1kAgg0T9jXzRGvXUbUTRO97tOCsXlBezIDPXp45Zv1v6FJIV/bbp322DF5nNq28uOrSp948WLA47crmMOlpgqBPLnuEckku8ExWpLK5grrzPYVOrC0ogxoHg3e3+Yq2jWlhirPQjwTlPRQ9jDN4itnd1xVKsmpljW78B2TUbFr12AAjCAm6TSFmDN2cnynOuMLw6ZYk+y85SmbFGs6Qu21lDsod2BMgoIKLZPz6YMQK21dH0yNLC1vgPaR8K16YeWvtavaKkvv//GN0+tihdIU3I7FfPWKvpka9j3ieQLrC98LGr9CRGY8bqINynSDVXBSFupasbUabZYVo+/ch4lziYDv6lc6fYl/Z6H+XWo8J72HiucqRdm+PtYVGjE0Jb7oCnQqgv2HlgpS/J1cbmjQSXHxLXDboj4xrsZ+w/0bLxVW2QtSmEqKIOD1426Vb9wp7BmjJKfSU/VaNfYZaZqS8vnReDb6JhXdqjQ9FI+cpqUrRhOaqG4sxtcuO8yo1PJbUyow9ewjl5B+4hsKF874JoIB1XcdjiABabn7/0iJ1tbOfyPIitObE3ptNJ20a0gw2mVLbCTubEwT7YU1+0JDddPgGxXZZHLrhVTSttgmApRhSzKqJaD7yNH+BXmC7E1NF2xoxNyNxpN5IyjXp6PU0v2qvTpaxazecpBqHESAdfX1ALn5ibEclio+XsI64vf0GuklJtt/1kaHLOyHjxi6iWGd0nUowxr8W97ZvGKXrOX
 2I9sjMRf
 mP1Awf57ODELA0JOHCZSRW1QX+E2D8ZMyoOflZhnABTh8cfL6ZdOnsmGh7jGZXFDgM0HsBjRfiriCobHvJ8CvzGw8oZCEoyWREhANqeNomUrbOAUrT7EiC7p4izKH0EnDcMAhxNlj0+DWiuE3/3LqHkLHAcaO8C/NpB0llobQRxqAKADT7dUquhz0AmUpolGdQcdNpAMONgr23l/I+Kc/tX7OToEkThlZA1GgOZ3T1031nTpZ/F5jlj+7fhN3CS9H0GzK8yspfcsVMC9UNhDEn/UxZtn53KQ+O6OcD7rn/IDBX4Zv4DiA/zf69A7AbTUDK5S3gHEYutINQ4nzcSODQMbN4Ba6eHJw3KlFPoGMl1DpcpOy0+CTl9QJVG3534x1qpJxKg7jEC6zqUwhhusHh00TxISJMkL1sYFpATqFJiP4tAzTTeumwWeXVac95hSF7BcdnT1NF7WLjXXL5LEllL/61UQyPjuj7/IlAPuesrV1oeNFUMfuwIP2VMcPkE749lRCR9wpSURZ0Z66n0c9bDCo7ZPlh1POfBAES2awiiu17+mPvl5KFiNTt6nFHXzsy09pBqMy2abTNFt1IT9FxZAMk+YOV5PCcKij7yvyeAH47/YhaCT0sQ4haw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com> writes:

> On 22/07/2025 22:16, Ruan Shiyang wrote:
>> From: Li Zhijian<lizhijian@fujitsu.com>
>> 
>
> I believe you are the actual author of this patch, so please change to yourself :)
>
>
>> Cc: Juri Lelli<juri.lelli@redhat.com>
>> Cc: Vincent Guittot<vincent.guittot@linaro.org>
>> Cc: Dietmar Eggemann<dietmar.eggemann@arm.com>
>> Cc: Steven Rostedt<rostedt@goodmis.org>
>> Cc: Ben Segall<bsegall@google.com>
>> Cc: Mel Gorman<mgorman@suse.de>
>> Cc: Valentin Schneider<vschneid@redhat.com>
>> Reported-by: Yasunori Gotou (Fujitsu)<y-goto@fujitsu.com>
>> Signed-off-by: Li Zhijian<lizhijian@fujitsu.com>
>> Signed-off-by: Ruan Shiyang<ruansy.fnst@fujitsu.com>
>> ---
>>   include/linux/mmzone.h | 2 ++
>>   kernel/sched/fair.c    | 6 ++++--
>>   mm/vmstat.c            | 1 +
>>   3 files changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 283913d42d7b..6216e2eecf3b 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -231,6 +231,8 @@ enum node_stat_item {
>>   #ifdef CONFIG_NUMA_BALANCING
>>   	PGPROMOTE_SUCCESS,	/* promote successfully */
>>   	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
>
> Additionally, I think the current comment for PGPROMOTE_CANDIDATE is inaccurate. If possible, I'd like to refine it along with this patch.
> For example:
> 	/*
> 	 * Candidate pages for promotion based on hint fault latency. This counter
> 	 * is used to control the promotion rate and adjust the hotness threshold.
> 	 */
> What are your thoughts, @Ying?

This looks good to me, Thanks!

---
Best Regards,
Huang, Ying

>
>
>> +	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
>> +					 * hot threshold */
>
> Similarly, the comment for PGPROMOTE_CANDIDATE_NOLIMIT can also be made more precise.
>
>
> Thanks
> Zhijian
>
>>   #endif

