Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1919DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614A18E0003; Thu, 28 Aug 2025 05:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECBE8E0001; Thu, 28 Aug 2025 05:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529788E0003; Thu, 28 Aug 2025 05:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6F18E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:23:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D445085085
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:23:50 +0000 (UTC)
X-FDA: 83825629020.06.74A3F78
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23F2740009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:23:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J2CgbZbP;
	spf=pass (imf07.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373029; a=rsa-sha256;
	cv=none;
	b=e4Ocd5SEE18oxEIn/JOzyW/ljcy23OyFCDK6yh57TSNj8GFbuGbjryV+2Q6HuY2jUMsseP
	AT3FC8aNWtjsUe0xgvAQWFUC+dGDn+t6IZrlGtO6uUcsrIAg9bqi9tsYlHFEfWXpOKqSN5
	Rm6D5ZziKO31QM/W2pfV52dEl/JWZ1A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J2CgbZbP;
	spf=pass (imf07.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KiEI/MNllscjBydiuZhBDQoXCblw/sdc1toMUg90I4=;
	b=A7LOylWMCWmCDeNkl9kLYhdvwFWp68/0Zu2P6V3jg0kpKFnbffFtX9xK8Cq0FHeTInUqUj
	+GyTSACCTdvp1sINLrmLfYkFr0LAecQNCRsPurfsMwB7tRAyyF8eV3gfuBmz2YgIDgYBqF
	dIMYAlEEyAMF4aTKknk43q9ZXGcl57Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756373023; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1KiEI/MNllscjBydiuZhBDQoXCblw/sdc1toMUg90I4=;
	b=J2CgbZbPrh2IEYV0W6yBjX9bkUXGQAP29+02M4yGr1upSspNXb//JfeSKPccFc51KthqwDdCDGcCoLUguaVi1Gx/Ux1e7vhRWYROnvxKlmwVXgdUGyi+pKLcbNYjbtDugQz4zTQ6mxK7S0HcMZa9d+/YmhYAESImv8ty7W99vFQ=
Received: from 30.74.128.191(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WmmiZOF_1756373021 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 17:23:41 +0800
Message-ID: <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
Date: Thu, 28 Aug 2025 17:23:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, baolin.wang@linux.alibaba.com
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
 <aK_7GKJ4BWjye4tZ@tiehlicka>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <aK_7GKJ4BWjye4tZ@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23F2740009
X-Stat-Signature: ihb54pzfwzbbufgidp68yy6iepp4tko3
X-Rspam-User: 
X-HE-Tag: 1756373027-329962
X-HE-Meta: U2FsdGVkX1+Y66JjXAhWwM3DQTNc8xQC2miHDcLOkTGz8d8rSHN4OvSjmCeLMNCQ+LUwZVOmCe+/JfQcTUuK8NDw1/9S5GDfoewxZ5yY+WIY8/hK11ZWwim55xIgxhooN6g9XV+f6wkz+2HX+NmxxrZqA6pyV/GSoCLaVWgSFiP9DT9K97JGVcDo319mGf3N52E9ktQC05oYpcpH6NJ7qbPCynHGtuvluUliGbQkoqA0IyZstDi1RelQWOtwj3xGq9lnmSWgk5h3feYUjnUvlKgSJxj9aKmpbmY2lI/ajQqhF2LJkqFsPmjM4XUL7obqc8BDFVeqM72Fx1lAIaa0OVbAVQVQEiiAi2GuIJONNZjz9pu0k3cZDyaFbUPu8iOj3hgp/qgHiI8Yp0dxV44dp+niW1SsyTrspPbRWBe6O8aS2oUVb1RXQ2RyFzW/2XyTBg6zYXNsBeHfJKQvgVugdmTw/1rTkeRE8djuvO4L11JC3CIFqnI8yIfaicG0XvY7RbxEXCgEQW3elxydwChpGhydty1CpQDxmVTQsagzYisJDMP9Cfw8BbnHl9DY9lwxsa/PEXhMFurircGcmw6Qlbeu3IfCWv7FMyQapVSpCTk6BjZ9fAPDgoCSv+9uIWXuTL3yQtT34O5Elpoq7iS6MLadODHxwhkI6LwLB7i71o2pVJSTj1o8aJpKDBXHkSuhEQ29rtbeaSst7mCB4toKyxlH0lQsRuTy27qcm/XAogW6JE/1LI/0ffsgEoXWw2NOWjhrcuZ07LahYGFHqrb4ysG8H7ZL2NRLBm1eay1YdEa4NCK/WAxSInKp+KYY/AEMPQHHqlzEmpXHcrYZEgdPDxtg7aHNlvGDTswLO51wFzEaT3ygxj9vUJxRpSTRAkWCs3K9FXlQvuWHDvgH0ogn2eXSikvBTF/IlPBLBreu7gDdeA+EJXIORcVKEzT1Ayse7u2wWljSAEWKFjvPODv
 +R3H5y2v
 K4VxStPXT+ei7OB3e7cHDSCVqn0x9+0YOcpdg1ZU/PgfFe+TREXwhc1xEOH19rv7e/UU02Ar0yIq0fQaCk+VoE6KUlpiBEFKfp9FQZdRqv0NdBAMYOg2zqLXNbAoiS0DyMtI4yeHCdeUSrfK/6492G0GhlRSM1GSikKUxBmSt7iDcO2vx6rh9Qc5B+EAFiHAuNl296mL3mU0cAeRmPNMEAMH3i8H8TRwiQ1dRaStl9ZrFadIx97IvFc4wC6Xej2VdyiXBiitrCFuCFHAit63xqhYAi2Jc2dyzIoawed+DJ6lxgfJ0c8LKDm9WNzIoIrdffAHNdreIJrXg+fKh7+fG7fAMV9SLg7zfJBJzc6qCGS45XmfvoZDqBa3GJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2025/8/28 14:45, Michal Hocko 写道:

> On Thu 28-08-25 11:06:02, Weilin Tong wrote:
>> When min_free_kbytes is user-configured, increasing system memory via memory
>> hotplug may trigger multiple recalculations of min_free_kbytes. This results
>> in excessive warning messages flooding the kernel log if several memory blocks
>> are added in a short period.
>>
>> Sample dmesg output before optimization:
>> ...
>> [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>> ...
>>
>> Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
>> preventing large volumes of repeated log entries and improving log readability.
> pr_warn_once seems too aggressive as we could miss useful events. On the
> other hand I agree that repeating the same message for each memory block
> onlining is not really helpful. Would it make sense to only pr_warn when
> new_min_free_kbytes differs from the previous one we have warned for?
Thanks for your feedback!

The dmesg output above comes from hotplugging a large amount of memory 
into ZONE_MOVABLE, where new_min_free_kbytes does not actually change, 
resulting in repeated warnings with identical messages.

However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type 
memory), new_min_free_kbytes changes on each operation, so we still get 
a large number of warnings—even though the value is different each time.

If the concern is missing useful warnings, pr_warn_ratelimited() would 
be an acceptable alternative, as it can reduce log spam without 
completely suppressing potentially important messages. However I still 
think that printing the warning once is sufficient to alert the user 
about the overridden configuration, especially since this is not a 
particularly critical warning.
>> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
>> ---
>>   mm/page_alloc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index baead29b3e67..774723150e5b 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6412,7 +6412,7 @@ void calculate_min_free_kbytes(void)
>>   	if (new_min_free_kbytes > user_min_free_kbytes)
>>   		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
>>   	else
>> -		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
>> +		pr_warn_once("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
>>   				new_min_free_kbytes, user_min_free_kbytes);
>>   
>>   }
>> -- 
>> 2.43.7

