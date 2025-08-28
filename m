Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3156CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E636B002C; Wed, 27 Aug 2025 22:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275E66B002D; Wed, 27 Aug 2025 22:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B31A6B0030; Wed, 27 Aug 2025 22:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B76B6B002C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:32:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9801D1609A9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:31:59 +0000 (UTC)
X-FDA: 83824591158.08.F96D1F9
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19A761C000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:31:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756348317; a=rsa-sha256;
	cv=none;
	b=rzcRLiFEJ0MLPaihChU9VyKRCjhMIQelVrxHqP2S/mWjH/tVKZvmWIfqgFJ+/nSS9igv4B
	kyek67FzbIOQptekwfhXnU4eZm5zxOiXG78oMZ9ITnRD9dFYgYnVZMLT1dmLkNlTqEh+L1
	s7/krm9U18Lv+zbqalIgZ3uNmnAyT4g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756348317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P/DBQMB2r+h6G0tu6v2l4tefO4iFanNusKV4yWYFRq8=;
	b=pVAoAjaBXJ2VygHCfCE5upknrbfEYbwOoVqPB+ceEasf3sVTass/38kQxnLce0AaZoTHlA
	EWmFKSBwxl1j7eEj2R9/aJi9fqATuKQREfoDsUuuGToyUXAZfRFrmcaXnw84d9zenqDW1t
	4YnkiiFKDiv9Lf03/KOXD65kAiXHS8A=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cC56M3ZxMz27j3Z;
	Thu, 28 Aug 2025 10:32:59 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C04BB14025A;
	Thu, 28 Aug 2025 10:31:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 10:31:52 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 10:31:51 +0800
Subject: Re: [PATCH] Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
To: Andrew Morton <akpm@linux-foundation.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20250826030955.2898709-1-linmiaohe@huawei.com>
 <20250826203552.b4340b12b16a374396f49343@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0138514f-c580-c066-c16d-2a0b207e0604@huawei.com>
Date: Thu, 28 Aug 2025 10:31:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20250826203552.b4340b12b16a374396f49343@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19A761C000A
X-Stat-Signature: 8c97pa8a7qu1kpbe9omr8eapinfrahy5
X-Rspam-User: 
X-HE-Tag: 1756348316-714853
X-HE-Meta: U2FsdGVkX18o9qutwEDhmYa76mdK3tFqQr8JWN2YaA9UD9ScOwMFGdUAkSzIZP9cZhSjeLeNbKpd9pMb2vsJPUTUTNJwmr2q8AO3RKvFjWaecjM1++RyU86qpd+EGVDrnp3EUG0iQhmdsVQNMrgEVUxiWsUdV25SFARckoUj5Uv666iHrjZfa3bKCA0oz2HEXvse1EtNuDHf0lsQTvLeNcXswP/LraBG6jRuh8lJpRLGg/bEcLTKb6/GbrX/P9eBmiBuAPUcVPErCPrOi8NUDh8eXGeTU6c+Q3StjIAkTst5w9XVfN/NFNMjpD8cQ19QTe4+T+6kCyktuGOpjHHdkUOKLUbCvndNZwSesdiPcz2rbDIIBchIPWVo6Po5e/gPb6Tx6zgWBLHiXUTHkRnjoheAL5dVafg1aRXdBENnfe1ENXAWQqkeOZM/MN1DyUH40GseRywXg9pdxMuCtXXzBdYNvnDJurnROnSCtQXutUYlwnI5eZLv0Xk2Ns38/etIqybxW0P1ahTjSI+qG21ewZnQFuYy14D5YwOJkPL39zMGc4UsNQ9KJv9whcFUKD09jJ4sE5oaxvJW4mAC3JnNG5GOtMeF7c6wHpYhKqC8J5mHtZoHodf1L/H5r1WJpzdvxHxfZn+6Ao8H5s/6nbFwC9HnW8JP2oFupm294IAIxdFtrDmpxUcimj2RaUPX+d8C9fMxSQ/Iu4OaCG4rq9dB5jOdJvjN2uzFpuZkq8F28Qp7zcUWUP4o/5x8DVTsrOmqmXou6qyLT26T3umq+ykNDCGucvxKu77FxtEZdpcHw4trKJFqEjxwqcGS2sQpTwhq2Eejgp6snIJEuaONVDhZKGy8q08XbyZvvOla+eWQvEzhuwHpDI76cJLFt3lggVkotAk3OvK6Qx/uwLBKhzwCJvaFfy2XMJiZCKVUxQMXdTupDZIqjgwL/W6aEqXcYrVApoRHA0GweBOU89n6Tmt
 mNxnM6Ts
 SJpVX0/IglPPBYz0382X6tgR34IOAEyc3UsfbjE3BEsAkryR1xBaijJm/8dnT8ASSgJfCd2at31qWGZnt5b0rdlXzlTaJmmyWf6uVPaqY9tBczBQUtyECuweWYDpnybUKUoGSToS0P7oj8yWc1ac32LfLehCSVDVTnQZydyExDqnE2B6T2clVIhaDL7rP5FO5x2dZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/27 11:35, Andrew Morton wrote:
> On Tue, 26 Aug 2025 11:09:55 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>> Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
>> added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
>> or SYSCTL. So this dependency is wrong and should be removed.
>>
>> This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.
> 
> f8142cf94d47 said:
> 
>     If CONFIG_SYSFS and CONFIG_SYSCTL are both undefined, hugetlb
>     doesn't work now as there's no way to set max huge pages.  Make
>     sure at least one of the above configs is defined to make hugetlb
>     works as expected.
> 
> So there is now a way to set max huge pages?  A reference tot he
> commit which made f8142cf94d47 unneeded might be helpful?

The commit is just wrong. It overlooked the scenario of using hugetlb through boot parameters
when it was submitted.

Thanks.
.

