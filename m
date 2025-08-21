Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAD5CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D590B8E0038; Thu, 21 Aug 2025 07:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30AA8E002F; Thu, 21 Aug 2025 07:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E138E0038; Thu, 21 Aug 2025 07:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3B5B8E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:45:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65A6C160370
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:45:19 +0000 (UTC)
X-FDA: 83800583958.09.568BE9F
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id A08F616000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:45:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foz8YIVqaMfuA6zgWXA9jz3g5prCaCw/dWI/AxmOgf4=;
	b=HCUroh+KqM61B/f5RLqGUgMHQwzKsZQMC9nn8iuZXDQsOBUmaZj+OIuXy9Jz3NHNFiisbN
	am0TkgchAbK4ngQLHK2mnZTR4iF0+jAWRNi2idorDnQsIy5BUsHhkAIQMem5Z7fnOI0RzD
	B/TJM8qu6SoXuVJNDQ04LwfggHKcWG4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776717; a=rsa-sha256;
	cv=none;
	b=aRoTzewnRWJ0FPURzbFsQXaGtoLmxAe6mvAPtuKik2HIJJBe8fL0Rz+6Z0qe8/96G8PSi7
	6/AYstOQ/iJ/dzl0RuEp83De3USJx4CcFMu5Ukkz3Y5Ka1pJB8xFrzdOYbLNnflhJrq2/V
	9W1q0efZFzmGzfYJibyjlZ1E+frUWfs=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c71bf3S3MzdcPl;
	Thu, 21 Aug 2025 19:40:46 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id EE962140279;
	Thu, 21 Aug 2025 19:45:09 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:45:09 +0800
Message-ID: <a038cd3a-2491-4a0c-aa7c-120ea7e58341@huawei.com>
Date: Thu, 21 Aug 2025 19:45:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
To: Catalin Marinas <catalin.marinas@arm.com>, Waiman Long <llong@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux-mm@kvack.org>,
	Breno Leitao <leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu
 Jialin <lujialin4@huawei.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
 <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com> <aKWrSfLD5f1r5rg_@arm.com>
 <fed73718-8001-4db6-af36-86c60e85d224@redhat.com> <aKX_HvAK6ZopNX35@arm.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <aKX_HvAK6ZopNX35@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Queue-Id: A08F616000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eojb9j5yeh1zryyg345x1hwwjxqj6q4f
X-HE-Tag: 1755776715-200239
X-HE-Meta: U2FsdGVkX19tfzyrBXV0Pmuwy1EN2JzGfn9xOQM32DrD927GFNLxYgIPZ/oNBZvCyrytEmNsdd9YjnpzwYz8Q9xkwEciv1eE7ShCJfyC2q/ks6xZGmUVz1Th6poag1wLnnGHaFSeUJ9PZngC54QB+nam8IhuY7cmzLD1spDJuFlEyviauA/dNOAbW/3SCSJcSxRRDApdr/67S6rP2AjUFxA05JX9YX/En6OSySeLgoIA/hDyMUNTmfhpdGd2YwjzzzC56h4/srArhk/nHUjAa0FEQDfWQmZm5buAGCw+5JZuFBqeKwkLJ8dW1fTYQSoUsb22SA1Ab4TT0UuQfSO4Jd0prxQH84SF9WF3EX5G4Zazzx+gJ11tbdI0IBF/1wJJTfjmXN4x25SCusx5dHafrXjXPBFbeEun04Qdj28DTbV+2qurNTFBCRRAmiBi+gUQim5cZAOiV6sTvNuM2u5ye0hCOozq1ojGld3Kn3xouZcVmEunjIq951ktclQgIEQoiNRXpz6zYG06dkavNl/wo2lFk2B3rzpqRvbbmfFarc80G4pLKdi6V82tZbWjZPqEpXPzqxj27e8In0LY/EygtDD/A+WIzS0TknfrTPcgNXQQhK3FqFS/Kt/q84OkJbKiALRDVDivb58sBIW7ItmMqXHQnZX9gALxriH8sy+vmRTMkGYbOv8tQleVMTHF71AteYcj31ro3MycZ5W9N4cwn5uWXgiYLXf9VVKDFC4phyCj6TVkQrN1pp+ZNYbehhFNcyLb0wMef552x4+BFA0pM5UA0YpmvohoB3u1nNTytqSSB16qon4QMjqUWmoeucdCgi+DX+rk9CDKUhqVxuJ1g+dX9goW4WyEX/Qw+9uF996DyZr4NbcQvslhz6tkkkMjLBMYL1O9X9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/2025 1:00 AM, Catalin Marinas wrote:
>
>> Anyway, I am not against using printk_deferred_enter/exit here. It is just
>> that they should be used as a last resort if there is no easy way to work
>> around it.
> 
> This works for me if Gu respins the patch
> 
This is indeed a better form, and I will send a new patch later.

Thanks,
Guber

