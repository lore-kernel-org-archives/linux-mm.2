Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1E8D2629F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 02:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505426B0005; Tue, 20 Jan 2026 21:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488A06B0088; Tue, 20 Jan 2026 21:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394AC6B0089; Tue, 20 Jan 2026 21:05:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A57A6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:05:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D92DF1AF6AB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:05:18 +0000 (UTC)
X-FDA: 84354328716.27.0427AC3
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf01.hostedemail.com (Postfix) with ESMTP id 048EC4000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:05:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3DkuNGwH;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768961117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nhG0efajjDPdtA2NXbIKVI241CAeCQcgsQn0YOqAAw=;
	b=PE2yrTBy8pBjFGHL9QsTTaurplm+RT1KWuE8g4AaOBTteKob+jlgl6VAXcaT+RGVGrKYpY
	EHqcD3q+WonBqnO/fZrchm6ScP3W/0Lf9TRJmeTw052XJKMHPuCpEO5MAHR5BHnfjMKnuy
	RPHz1+tJL5ru4m9t73pTPeB92+C411c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3DkuNGwH;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768961117; a=rsa-sha256;
	cv=none;
	b=cxqO9I69GNxZ9GqUO3d8q/SsZFnSGM5JLZU7oVLMYGDyd4Cz70wCIFINKt3vp57+kyca/D
	t0Ti1QgZ+M2emoMcum2eZfOxBEqW+YHk0VUT4Gqtfp1y2d4TAUgBsRA28E6ixjlQLsU9Bm
	l607VouDKczidAUEx2Bh47tlEdJvGOA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0nhG0efajjDPdtA2NXbIKVI241CAeCQcgsQn0YOqAAw=;
	b=3DkuNGwHlMIR1X2OF/EXuyAarXsYXLrWYAQZJHgAAVjS08xCNOVfRcsrpTcbiwbD/FkXyGDRX
	5tiliLOEZUrVnQKut1J86wAoS7lSDW17B/Dq++rowX5vTYT44xCWKdP8ATNgKprme7ujlU54EWf
	9kf7NoPP8im6nqXQn08Yk34=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dwnVz457wz1K96q;
	Wed, 21 Jan 2026 10:01:47 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2405F40566;
	Wed, 21 Jan 2026 10:05:09 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 21 Jan 2026 10:05:08 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 21 Jan 2026 10:05:07 +0800
Subject: Re: [PATCH v2 1/3] selftests/mm: add memory failure anonymous page
 test
To: Mark Brown <broonie@kernel.org>
CC: <akpm@linux-foundation.org>, <shuah@kernel.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
References: <20260120123239.909882-1-linmiaohe@huawei.com>
 <20260120123239.909882-2-linmiaohe@huawei.com>
 <737310eb-05e5-4234-af67-9118b3f395ab@sirena.org.uk>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f1cb6029-9140-3784-5b44-ff58b4edde2c@huawei.com>
Date: Wed, 21 Jan 2026 10:05:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <737310eb-05e5-4234-af67-9118b3f395ab@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 048EC4000B
X-Stat-Signature: yuwimtfrzbbkjah87gecpeu67i4irsh5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768961115-760766
X-HE-Meta: U2FsdGVkX18cJ+R+wB9n8zCb+8WJxuEuuM8y+sZ3ChDSXmJoTqhj/+6gX3HJW/mUHjXLsfVXkOn4KkvSgLz990Sj+unqD49Yca5vHcd4cQByIOxmHunJOGTYYkWjUcf18uaw36IB7wqFkp23Zu9+X7v2+UYHZrZ41C1tp1xj6t0sACGqQjwvJlZYYtqd1qP5qdcdupkKzJgLADy+olWQxEa1ntXcDCjGnwGXF98re5llEgLjXwF/+iIVvzIDXPqWDuLdSrp3/QNxEeKY4GEDdqAiB1X3SOhY7hTIUGT47a8YsXaefORwdAyLeBslSGgwT3vjxM6UBsIdMqq3AH8kA61NaWfiOhyAzUpbZleG3NE0yNm77ZU0GAvdQK3AHQnpifhYX7J+GqqQKezizL3aIYJbXwU4f4Fjc5J6p+WZIvDPl+P4w4ibM7jssL35Hjo6D0PYvMuM0JzVtp27hEtTz/TC734kr8QRSW7xRPIFuJlCZ41aZcVv0xo/ZHhqKTDFBVPPhxwR/0FFFGrg0dJHEf+Bjc9x1oJXM4+HQYbMjQnRY2yfa9FmTFuIi6eMmyug8MQPvRZQgcZl3dK+Jasp2RA4jAMqhn9Owi8ZGoG4U5ORaUxKwB/RneL1hfHQyhgTPxC8LJ0/qRe7WA0eckkYBdQxxcG8IUF+wpyuS7fTOLXlQD/kFcCePhPx9waHRFaw1kEEOeyL/Fq0qo10N536wR9wN48Pby9zWVW1Zz12d6sZ3EBSXLvhLv+Y8Ol2M9hugJmd8zp1nr3a3K0pwMO45ptEMPYyq0hUih3ympzBOGrTmAudNeh364cx437gDgKkUPvBjmksa1dZd6aQosiYF/hmUgoErvtTpdPQFy0N5+TrnbXZFbbvY2UDZw3byZfb3LpTEkxoFM0BJN9WuZJCThlFHEKoZRCaa5rRBhC5KTCZCp1hWJyqtQoSkmFuLcRwa2VK4iOk5CV/lcRqTV5
 8s38msod
 SXwd8c9Ufk4Aadsp8yLzEbwgUzUaClDB/07Cq7yUE7R3hkTIFTM9pwlMKQftYDJsZYHi5u6JAWNJ9HZZXtaB+xQtjg38n/6dy3fsrFgTwsnQJfmuVVYUWVBpuLFXyQgD/IDOIKoUo+CZIjH2WN9Pt6fzyQ62VQ0Fnu2/FubXbP9ZhFaPNLuieYKrxeAfUFKfvIU2msFpeDUZSp1Ya7l17ijytYVtRpbn9c5Q0rAH+ri6x2srklpYsUQvRhM6OJxrkP/YCLIVUBNpBxYq+z+tAKr4NRK0tmTo9DNbJ5OmCDKoydD0QXbWhc/DlURZyd8cxz2jNSInaG9oD5e3hRVerhCF2jS6r0KHClXTv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/21 1:46, Mark Brown wrote:
> On Tue, Jan 20, 2026 at 08:32:37PM +0800, Miaohe Lin wrote:
> 
>> +# Try to load hwpoison_inject if not present.
>> +HWPOISON_DIR=/sys/kernel/debug/hwpoison/
>> +if [ ! -d "$HWPOISON_DIR" ]; then
>> +	if ! modprobe -q -R hwpoison_inject; then
>> +		echo "Module hwpoison_inject not found, skipping..."
>> +	else
>> +		modprobe hwpoison_inject > /dev/null 2>&1
>> +		LOADED_MOD=1
>> +	fi
>> +fi
> 
> You should also add HWPOISION_INJECT and likely also MEMORY_FAILURE
> (which it depends on) to the config fragment in
> 
>    tools/testing/selftests/mm/config

Currently if HWPOISION_INJECT or MEMORY_FAILURE isn't enabled, the test
will be skipped.

> 
> so people and tools know the config options are needed to get all the
> tests running.

Sounds reasonable. Will add it in next version.

Thanks.
.

