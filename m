Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41FDCA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1CE8E0013; Tue, 19 Aug 2025 21:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462A48E0011; Tue, 19 Aug 2025 21:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F928E0013; Tue, 19 Aug 2025 21:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 297D98E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:23:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4606A1402CC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:23:34 +0000 (UTC)
X-FDA: 83795388348.29.0A827EA
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4CD0380008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:23:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbZ5GU0VLxCc/J1wKxnJ3GKYSTXHR9AnUt7blRGunNA=;
	b=DqeqNBu69a38BHY1POy7nxzPVQH+iG9S+B0DkP5E67/l352bwok5A6ghTM7sYKEkMNUQ5u
	HMmqbh5NSwxs1PajuEXbqo3vHmq+ler0S46Z5fJqFRQd3O6wS870DC+hhy4pDce/O39Tp8
	cfLkfd4parXjNd7I3TMzxRa4oWYSQHU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653012; a=rsa-sha256;
	cv=none;
	b=3WWbWfd+XdF/GyKBAB0JLuscEph/0gm82D9NTW2qXQiAhlW4vHMVWkOKDQX6yGPpW0jdd9
	MBivOt3xiYWGpBsPwEV4sCphy2RqLfQp60wO4Y/6NH+pm0ORVIVFp9nVolN5MNw39Fe7lm
	hTO9FedtEK3eHIpnqyTtVWaaEDzZliU=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c67z43SRvz27jJ5;
	Wed, 20 Aug 2025 09:24:32 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 37C4A1A016C;
	Wed, 20 Aug 2025 09:23:27 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 09:23:26 +0800
Message-ID: <a7829822-42dc-499a-b092-b9003a0e156b@huawei.com>
Date: Wed, 20 Aug 2025 09:23:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux-mm@kvack.org>,
	Waiman Long <llong@redhat.com>, Breno Leitao <leitao@debian.org>, John Ogness
	<john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
 <aKSYq17EUrXRGFPO@arm.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <aKSYq17EUrXRGFPO@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Stat-Signature: 18xkqgdacpemkdnaoruq876r8r53zg5b
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CD0380008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755653010-172321
X-HE-Meta: U2FsdGVkX19+Jq2yGimXU2KzK1lRqiIYKLh+TZTH5OfptIT0nLW1xFy+dxkZCV103xFTIZmDyAB84QOMyqTaoBwbckjaJyvXqWWMCFlR05uWmqo27cuqhzPQEBm+LkU+A8hqjjN04K1ABdLj5Awne1bkhnSWC4IUkYwPhWgOL5gOFlql9VXTSZzMHFsyIBC2q9BXmUzItRT3yyP5M6N0uWPRgXU1PS8r/YhBPDFrOJrqObRIS04WiN9HcEFEBAvagJ6zS9hSUPOgyldxmeRHuyEMJd0DFrkVs8USEpBJOv4EIAZb+iju5x5gv4ljCdHiInFAJHGMDJnNWt2XlZ8DrnXm4nPih0MLFPuV9Yp+Z+GnmCWEarfc6FnXSeGrKFsD8XAvQ9EOhC2PR7tY7F+w9OaV9ZqKesQNWHb4IE+T5nII8Jl9McbFBkC1fvGtbF/DkV+wSUkJQgX9Ac+gf0r5d5fNcbZEw7ronDze8wp/fOKrjkXxqxjtMhlEyxvKwYnCYWEYnquj0g0MhavWYCn//RYiX21JgQvKBzxje30eCdzRmVM7DyQMDq2StNpviC5H9NjtmRc3SnN99hLcUZ3vxd00sZVwQu7Mt+g+xOBP/RcppYoHNgp9qfnAMtk0ah/Ml4ly4UV9RUvAUJbGpUQgfV+Cj8SM4mcUYpkMlZyYVa/41FzDR6en9qsevr/qqQkE4TTwCRRmG5Xuj7+TO8lpyrMS5TKIjGGYJj/W0746cw4VNTrNVXCGWpMr/TzQagorOlJdlqpggvYnf5SZr/SDyDsbgFydkafRpUe0cOhSLhHnQNpofg4W6kwUcvGZbx51c3MuBlT0ohf+NDpf/ZExl/PrHsfxzF6E6ab+ChDvV42g78D0zP1ZCB9A2uWTBcdWZfmXe/mozyuGzL9pnyuKMOQGmInaDz7gxxY6QOkxTLVOJO/eZB3P61IHcToYrfMwKIlVHuqqpP81L5aOVaM
 FxfQ14pI
 TRSYWQmBDPDbIMHt0Feeh8P4/BZEF7NrV9EYz3LMXPyKX0enQOSvY401X/qaAVR9kgaKfw9Nx3/eKIeCwp+aA3rDfsj8podV5LqN1Jly5uybgPiLLj0ENg5N/0Y+t9L/vJmVDF9e3LhCfZSQeDvwv77WAu5F3Xdyk7W9r2a+pG6uaobQE2vO15uud2pd0vK5f+M1ErQX5FE+/Tfg4hDpA5dFxZYqCJ1oUcgTted+ne49YW03jfCWe5glmWYz70AsvWuZ6w5cQDJt8FtUwRmdutCsLX1e69KjbRmWM6BxexFEB6EfSku7YTaDCZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/2025 11:30 PM, Catalin Marinas wrote:
> On Mon, Aug 18, 2025 at 05:09:44PM +0800, Gu Bowen wrote:
>> Our syztester report the lockdep WARNING [1], which was identified in
>> stable kernel version 5.10. However, this deadlock path no longer exists
>> due to the refactoring of console_lock in v6.2-rc1 [2]. Coincidentally,
>> there are two types of deadlocks that we have found here. One is the ABBA
>> deadlock, as mentioned above [1], and the other is the AA deadlock was
>> reported by Breno [3]. The latter's deadlock issue persists.
> 
> It's better to include the lockdep warning here rather than linking to
> other threads. Also since we are targeting upstream with this patch,
> I don't think we should mention lockdep warnings for 5.10.
> 
>> To solve this problem, switch to printk_safe mode before printing warning
>> message, this will redirect all printk()-s to a special per-CPU buffer,
>> which will be flushed later from a safe context (irq work), and this
>> deadlock problem can be avoided. The proper API to use should be
>> printk_deferred_enter()/printk_deferred_exit() [4].
>>
>> [1]
>> https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
>> [2]
>> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
>> [3]
>> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
>> [4]
>> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
>> ====================
>>
> 
> I suggest you add the 5.10 mention here if you want, text after "---" is
> normally stripped (well, not sure with Andrew's scripts).
> 
> Otherwise the patch looks fine.
> 

Thank you for your advice, I will pay attention to these points in the 
future.

Best Regards,
Guber

