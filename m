Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93C7CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542D26B008A; Sun, 17 Aug 2025 22:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCBA6B008C; Sun, 17 Aug 2025 22:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3096B0092; Sun, 17 Aug 2025 22:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24C286B008A
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:24:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B08BD138CEB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:24:47 +0000 (UTC)
X-FDA: 83788285014.26.114825F
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id 704C8100007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:24:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evwTvjSpZPPmrYBWStRZKBbpwt6AcDLZHCSyuyq4c58=;
	b=1nR8S76PLYtWD8aiMT8hMB9MNnitEEK/XtT7Vt/T3UzaHTUAphGTOINPgN8JuHWAcNvpJI
	wpiUfoAvV07qZ0Um20sPJwa1r4Q3lSnVBZWdWoiXq+9nASMOJi3AFL8u3MvYvrbnHcw5S3
	6wUc8UzMVWropOuymNcLdK8Nw4IKL+c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755483885; a=rsa-sha256;
	cv=none;
	b=yFwN1rnpprsemLtS4wDmDcLhFa8y45FI8Yv9cp8NTMvpb4ArpAPU5ufVR3+UcFFrO7Z0ON
	NX6U2sH300Ao/mLx3MuIWgio+zGDSPyn0HxRgyCQeM8JswWmNVcILs5t60S78GepGP0LCu
	IsevnZKXy0QDba4uBj+mOp0XXuQ2ThY=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c4xJL1VT8zdcLg;
	Mon, 18 Aug 2025 10:20:18 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D6EE1402C8;
	Mon, 18 Aug 2025 10:24:40 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 10:24:39 +0800
Message-ID: <2285c764-e6b3-4cb4-ae12-0bfaa1e67358@huawei.com>
Date: Mon, 18 Aug 2025 10:24:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
	<linux-mm@kvack.org>, Waiman Long <llong@redhat.com>, Breno Leitao
	<leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu Jialin
	<lujialin4@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com> <aJ3f05Dqzx0OouJa@arm.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <aJ3f05Dqzx0OouJa@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 704C8100007
X-Stat-Signature: wimzi9wp4zzzuqzqxiwuje5wasfweenf
X-Rspam-User: 
X-HE-Tag: 1755483884-150256
X-HE-Meta: U2FsdGVkX18Z73uOibo0+8ZqOLVhJf0ezQjY8KqRAxgu0Bz97MNg4ruWedXkOK3fhkfwN2Og9F9i4lAG98bx555BgOj/l0lOunaIp46bujG313V8CnWyRw9zipIwpLE36H4g6u3OoR/ICGPOwVW1/uq76dQjCkvjVv70vlEHfaakcCM4qc8yuoInjiulR6Hbg5ZnQ4mcYdaOX583HvWCnnH5fgSeX+tPhyTlkKnjICraZarV177fxsxvPFnVnp3Uf5Dd1VEYlFrIrJ8LmLgkXt+mfFiJfba7DJIxGoELAhKUHQwVrEbTRP2CyTeMprDB37IU44fqsH5meIDgf3GguXK/rowaLG1QK/7HGN0VZ+IhYtEy3JO5pTT0885MK+jqnGNwn+dHoFQxIRsO9bBa/oXvRKas28aBMPDsIakrXjOQwD5w9Y472e01mV2HMd1cNcVrQ520xz0C+PoHJ9dKg1jsiEIUtmQkboHGlb+qJhX6rBKS5qt0p57d0HoM2/Uv+jrxVheh41vge86AjxnfpnS4lSDYKd0MBBw2PZSmclGtQvK3W8+GGTpyP/CdLifSMCsA+8i2bduJN79xHRrKGoud8bihEe9bUVOv6iTkhUkHYBeVBPVGEaQEyCsL5DhCVueD5VpLxOOlvoH9LN7z7UbecdbawDHzZNSGJHPMiCRI/zZUlZKcZFk2ksNNSl/bt/tC8+I62ZcFMC2HBHUkKDrc6+x6JoF45dFgOxyUgjVWbgI7UrQ34fyd9fD2/AB9KUGiYTskw/33htwWPTuKbOSKvCoBNWpbrsB2kDHWkKG9agLTmK7BAGpO4uVmZzhoL+CssEpBHGqZ/U8W01lyghuz9IctdCcxIZS5FqIOo6CP1CvKqUBatQ1kd4ePizrhjLoYGNXTNlDpo+lTwcXshZrJgzDDBrebc2AqiSRnnNZC8RUzTgRy77IZZ+OvsP0pzJ4cDPBsIUiacO0DXXV
 QXsmp6oN
 PHT0opHsPTdCD1aQLA5EroDiwFJqIyUVLDOom8kCZEEegekXV+OBj+4LJ++vpsdMcgwthwsu/KnTt03vCf1oUzeFJRtQiOKDteQPP94znFAkaHcxYfDZXj4AXrMUbds+x3c07L/rT1rsyZcDo7hxwwSDF3t5ccJaROnuIAi0PwhE5xEjPiBl18lgqA7f6+cAZdIziGcOPYMnWEGP5EoVxeU2OFEXjnGQ+B8xym33vz5s8DKi9dG83+LSDJ34yiIS8I/QNFrVfFwCLvEynbHTbpIAD0wcgiOt7aZbVsCP03N6oKjA+I52U2PoNLSVb5BZVf1zMTztzSSWYKOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2025 9:08 PM, Catalin Marinas wrote:
> On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
>> On 8/14/2025 6:56 AM, Andrew Morton wrote:
>>> I'm not sure which kernel version this was against, but kmemleak.c has
>>> changed quite a lot.
>>>
>>> Could we please see a patch against a latest kernel version?  Linus
>>> mainline will suit.
>>>
>>> Thanks.
>>
>> I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
>> code of the mainline version and found that this deadlock path no longer
>> exists due to the refactoring of console_lock in v6.2-rc1. For details on
>> the refactoring, you can refer to this link :
>> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
>> Therefore, theoretically, this issue existed before the refactoring of
>> console_lock.
> 
> Oh, so you can no longer hit this issue with mainline. This wasn't
> mentioned (or I missed it) in the commit log.
> 
> So this would be a stable-only fix that does not have a correspondent
> upstream. Adding Greg for his opinion.
> 

I have discovered that I made a mistake, this fix patch should be merged 
into the mainline. Since we have identified two types of deadlocks, the 
AA deadlock [1] and the ABBA deadlock[2], the latter's deadlock path no 
longer exists in the mainline due to the 40 patches that refactored 
console_lock. However, the AA deadlock issue persists, so I believe this 
fix should be applied to the mainline.

[1] 
https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
[2] https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/

Best Regards,
Guber


