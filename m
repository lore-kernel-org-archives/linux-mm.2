Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB06E94108
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 09:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316C46B0089; Tue, 30 Dec 2025 04:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE4A6B008A; Tue, 30 Dec 2025 04:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED3F6B008C; Tue, 30 Dec 2025 04:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E87416B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:02:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DF4A1415BD
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:02:39 +0000 (UTC)
X-FDA: 84275546838.28.22117A0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40926120004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:02:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767085357; a=rsa-sha256;
	cv=none;
	b=l7alMoITGBWnkScDT5uI9PEeeipgqvGY4VmKZU0Ei25+vH9F0PUFij8cvKuEfNnnrZSXst
	AkxN6UA7G891IQmx3c+FUnD8quMoWVadP5kYkcRp1/OQhUJXE/Wj26O5y3v36cyFgJHpLj
	JmgseXip1eV8yxeaYADHCTEidhBbK4U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767085357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pnGbdI3FC5ujzfJVPgKc3rjeGx6tBIL6eudgqEYzE=;
	b=BlTNhiM+fTzGkGCGLKywGM/62qjUMDTKq+pipNubu8B8tvgbxZsD71EwGql1vzqI5901Xb
	HkHAh7BZEXQoj13hhtGfmW5wXbFJwPMuEylTIbvF5ph3HUHi7OHw9PIeuSsN0OHFVJBQFg
	twv0HPCXYKOPKuEeuA+H+kuZ7LlcdvE=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dgRsd6mtDzJ46fG;
	Tue, 30 Dec 2025 17:01:41 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4021940565;
	Tue, 30 Dec 2025 17:02:32 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 12:02:31 +0300
Message-ID: <4b367446-2248-4936-99b6-e9ee93298eb5@huawei-partners.com>
Date: Tue, 30 Dec 2025 12:02:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>
References: <20251229152250.78975-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20251229152250.78975-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 40926120004
X-Rspamd-Server: rspam04
X-Stat-Signature: 69f86cbuszmaumu4xneemch5yaptnqen
X-HE-Tag: 1767085356-666181
X-HE-Meta: U2FsdGVkX19hbaLAMgd9QuevqD56tuu5yOhTlD3my0bsLdML7ZJokhV5TgNsXwnw/dZvi7jnlZsaJmall1nmallFSo9b8fN5XlSaZ/GMIe62/ZwRCQ9AbHA9FqXejoCzD7CtSDbhtwVQIEeuCkM6bVp3jEifoThx0r8NCdMQVBkJUvoue/DvaV8bghkxle7YkknSkkh79uq8o/YoOjcSewY7ewam97nUFk1KTUYn6ulqQzEEh2IhxbGsPfrpDuK6zKcGamD8zlbRRXV+b6pt4qLvhonvi3CcB7fJ5dBtdBgtYclOaPUoSiaFqUZw9iccLCidm7iWtlrf5OBYxsr4x9rcggs+k/6qZPcOSV2GV3U+tOwYskPp+NqcIO3B5Zd/R1yE4TNCSyBw12qTbI524Sn9WzpyUPM/F5BM8afAtAgWuyBwRPVrY0wN5g+VZWoxTe8HJjorywjGl++c7zW17OoLBckgLDdvsGbcdZtvq+332jkad0Y6dGcCgwMsXgeSyEUP3ZYwKbEdxi1S60fMjRdJK1/OidawNahcrg8CFl2TbKC2K/xaM7sWn+MJmViFIgkvosqUoSVangCftU/8KllGexnaIY0e5haV8BD/DkT3WwqanZjPeLMBQsJNCM7xMgfs3IXbDqFwxULxZxHJZYnHiDMThOgJTvdt2Qv5rTgPq46PT33pUhgxubzR+0cdJZYhXLBUa8lWoiwk1u8LxunWDynUN4zeA2MQm2MRn2yV7BXmN8lAS7MPLz150d8cNyMYoFnYB8pagPbjA8+KB+ACCHMe82KBEV3Ophhb7Wc4KaYh6K8T+sMoEXnztKtE5nYhRY289H/W5zl5L7VhMrSggIfT0TttaSnW3A1cagJCWctjikzf3W6g7QoAgrjmm7VJ3JCp5pMnT+S3HKT428iGF6CD+T1Sb5fMIrDqIan8TvFHj//H0GvhIKvija+YYLG3SV7kNaBXyJVSn7q
 OOiqzg2k
 CAoejiWbHaJ2xkP43bsGxxwrqsYmtTq+1G4b4EsdVj49XJsOHWb+/FKjF2xS+yRAuT+PfBFkkaLS1lmCQUzg33HOvQDmx/cqwYEZHC/Hw1RIPKS26/Ker2QnL8tyYokN0GDB7V9xgvrEbY+iwP+zR+nV+Y4V5QUpdMDm/Y35dQcI3+s1iTfByMEWXF/PaZD6fwWV2pTEHtSfrZ3H855oOvsTCeRtA5xnmfLlBYrXOXrweFm56V00GyggxxAWlblx7STF9GZz9vTkVjhxcBvPuvIwbntLzSnZH1C7hwnx41GPo6KXwGHKw137jrZBgw8fgg3C7kzwyZLCGm0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/29/2025 6:22 PM, SeongJae Park wrote:
> Hello Asier,

Hi SeongJae,

> 
> Thank you for sending this patch!
> 
> On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> 
>> This is a minor patch set for a call_controls_lock synchronization improvement.
> 
> Please break description lines to not exceed 75 characters per line.
> 
>>
>> Spinlocks are faster than mutexes, even when the mutex takes the fast
>> path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> 
> But call_controls_lock is not being used on performance critical part.
> Actually, most of DAMON code is not performance critical.  I really appreciate
> your patch, but I have to say I don't think this change is really needed now.
> Please let me know if I'm missing something.

I was just reviewing the code and I noticed this. Yes, you are right, the performance 
is not critical.

>>
>> Initial benchmarking shows the following results
>>
>>
>> # bpftrace -e 'kprobe:kdamond_call { @start[tid] = nsecs; }
> 
> Commit log shouldn't start with '#'.  Please consider indenting the above
> command and below outputs of it.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Thanks a lot for the review!

-- 
Asier Gutierrez
Huawei


