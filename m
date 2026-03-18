Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 087BF103E18F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF946B025C; Wed, 18 Mar 2026 10:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A76A6B025E; Wed, 18 Mar 2026 10:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E41F6B025F; Wed, 18 Mar 2026 10:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF746B025C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:42:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0585F1A078F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:42:01 +0000 (UTC)
X-FDA: 84559448442.23.B399AB7
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 944F210000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:41:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4WjxDGAf/nsXeN821xpX/Rs9Sl+P93CQBgnucnzWB5Y=;
	b=WHm2I4yg35GHZaIdNv7D/HzwvPD2jJ0xI/MMu3vQHyFzDXt5oTlrpHONwiId5cCLhwitg1
	T0iPyOnuvvJmmIiTjAu/sf/44vpgrWSPnZRQCRTGwdQQRb+0eHLA2xbVfcv8Q0d2qHOMuQ
	azSlgWfd5EAZUVd8XXrCJBiB42vUjtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844918; a=rsa-sha256;
	cv=none;
	b=fec/aHdji70eEC351CerZTGk0Vq9FY/loxvsdsAiYqLi3GkRsg58+1wYpZ9pfIZIIZs/XK
	u6OuweDze6zXs0B+ksaDR8R2AhV4eSGN+TpW61EX5IzdUJsVHmNjO7TxJjW3EGqdknUfd5
	GN6Kw4yyMDfYpFRCLoEq4F4s5Njc+0Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fbWjk2zqjzHnH7y;
	Wed, 18 Mar 2026 22:41:30 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 181334056A;
	Wed, 18 Mar 2026 22:41:52 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Mar 2026 17:41:51 +0300
Message-ID: <e51c09dc-81bd-441c-90ce-b973d21fe311@huawei-partners.com>
Date: Wed, 18 Mar 2026 17:41:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via
 DAMOS_COLLAPSE scheme action
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260318005226.132181-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260318005226.132181-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: aaqrw4je433docihonihgbp8g6cipuia
X-Rspamd-Queue-Id: 944F210000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773844917-362139
X-HE-Meta: U2FsdGVkX198kAvi/ljgAlbzDBaJIByUi+qgbp511wZ22fSjqkXO3jmL9yjn6oAAcsFbR7Mz69i+WMydNbVnWHDfKDVu9V8Dlpz1MZfCAz+fcpeTh7rGiCG+nW1CRngI39ndaJNjMtKTbzUHPrkCma/R+BOFwfkjc/O36m38khZctWDrtzUnt+M4FOfE3FPski78npGQpPw0Y4ktJPmZ6rhE09+Nm1TsAGEnWxy+SVqcQuh1ReoHjHAiUm7gAMqPztwjGxQUu88RPZm2Ta0H6L/wNJCptsfb+/q8WEdM2DTpfL4opD15eOenoVjau5wxoyaVkoPRc+HJlUks9KmOQqm3GVUej5wDIA0ihvDSoT7BOANcdJEnTLGBisLz65bAXskTHBdqN6u95g01ikdzOFTTNPHeZVRQiQC3k9OnMFBX+8TUJMqCXr1gtmcrYTv9m+asCDf0w7pAOzxXmhN/Qfzf8ARDH3jSQAFDLNmTWuyKY7aMnB/1mxWCUy2izd/6KGdp1zI8DZRYxy1siY5rp9atVT0kgyHiIEnBsKR3sJKEjL2gkC9CcM0ILj0y9pxKwN5V4D+pyxfUMSAD/DH6TPwDtJKHd8i5izaGmON3uea8v5TAat18C53dWETKWQk8ynst0Ej9ESnQFknd4Jv3lEcSpGXBFPsC/QvynlvAi7mHnn3jkXbP2C4Sx/yMAyPBPdOFujtjEpSJMnx7nNF7tk5sO8rS7ydiVhIIaqwtzYJkb7CYPGH3YRbZUszZ9H7zEDSGcEhK4LCqgjLLta3og29ne6xMfp2BVIxxDxFegjwANc57fS2Nh8kk/QeaBLWWR7cMqGL5Ah8XxXD/ngVOiSParUr3EGprO1IsO5Q6pXg/9oOEYq2syLQDViv5mh09A69+01FrTjKgLI+PZrrKS45bW613yYLSqnaV9ZJMt8blP0Lr/2ysYuuRTKhKZxc8JV6yrm3sBSleXUhepHt
 yF2O1sdQ
 xtmtpgNF+NcSD9QLxs80rJlXTaSP58wk/keO9KFMqVUH1Y890qu7e0V2NjCxkaV+4ePb1Bf4tkoTDrxZRfnDOvQhv/YLnpL9UneNuAV451cbU5FOzFtz9S6Isg6lhrK8kb3Ihj/BGO63wB7xESDedWyMZeSiuO17xGHVj29poZ/cGpBx/J9XCvyxuVW/XHcloqfXRg6ncaC7glGklfgAMbqrGnmApHZQnTUMZdQEFrISLvCqUcYhXfdAPnPlUOGZ/wxohZ5e2o0FHGZcUIdGwKz00sV3saNRubvNcMxdRFX9EFOVaYIVBWZEPOMAdRyHHgblTwnGTBfBDKEl/NkQcUosuZGD2vw81VLDoSeboP/w9IKgl/YcS1ykTiJ7y4de/J9RzY+knPS2vdiYvRiMlEcug95n2o3gfOqcx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/2026 3:52 AM, SeongJae Park wrote:
> On Tue, 17 Mar 2026 09:52:09 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SJ,
>>
>> First of all, I just noticed that this was sent as v2 RFC, while
>> it should be v1. Bear in mind that the next series will also be
>> v2.
> 
> No worry :)
> 
>>
>> On 3/17/2026 3:32 AM, SeongJae Park wrote:
>>> Hello Asier,
>>>
>>> On Mon, 16 Mar 2026 18:38:05 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>>
>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>
>>>> This patch set introces a new action: DAMOS_COLLAPSE.
>>>>
>>>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>>>> working, since it relies on hugepage_madvise to add a new slot. This
>>>> slot should be picked up by khugepaged and eventually collapse (or
>>>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>>>> enabled, khugepaged will not be working, and therefore no collapse
>>>> will happen.
>>>>
>>>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>>>> the address range synchronously.
>>>>
>>>> This new action may be required to support autotuning with hugepage as
>>>> a goal.
>>>
>>> Above all makes sense.  Thank you for posting this patch.
>>>
>>> Do you have some test results that you can also share together?  It would be
>>> nice if it can demonstrate the benefit of DAMOS_COLLAPSE over DAMOS_HUGEPAGE.
>> I will run some tests and benchmarks.
> 
> Looking forward to.
> 
>>>
>>>>
>>>> [1] https://lore.kernel.org/lkml/20260314165156.86647-1-sj@kernel.org/
>>>
>>> Seems the above link is just added by a mistake?  If not, please clarify.
>> Yes, it looks like I copied the wrong link.
>>>>
>>>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>> Reviewed-by: SeongJae Park <sj@kernel.org>
>>>> ---
>>>>  Documentation/mm/damon/design.rst | 4 ++++
>>>>  include/linux/damon.h             | 1 +
>>>>  mm/damon/sysfs-schemes.c          | 4 ++++
>>>>  mm/damon/vaddr.c                  | 3 +++
>>>>  4 files changed, 12 insertions(+)
>>> [...]
>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>>>> index 3a441fbca170..6720dc70c487 100644
>>>> --- a/include/linux/damon.h
>>>> +++ b/include/linux/damon.h
>>>> @@ -140,6 +140,7 @@ enum damos_action {
>>>>  	DAMOS_PAGEOUT,
>>>>  	DAMOS_HUGEPAGE,
>>>>  	DAMOS_NOHUGEPAGE,
>>>> +	DAMOS_COLLAPSE,
>>>>  	DAMOS_LRU_PRIO,
>>>>  	DAMOS_LRU_DEPRIO,
>>>>  	DAMOS_MIGRATE_HOT,
>>>
>>> sashiko.dev adds [1] below comments.  Let me also add my comments in line.
>>>
>>> : This isn't a bug, but should a kernel-doc entry for @DAMOS_COLLAPSE be added
>>> : to the comment block above this enum?
>>>
>>> Makes sense.  'make htmldocs' may complain otherwise.  Asier, could you please
>>> add the kernel-doc comment for DAMOS_COLLAPSE in the next spin?
>> OK, I will split this patch into 2: one with the code and the other one with
>> the documentation.
> 
> Does the 'documentation' mean the change for 'design.rst'?  Or, the kernel-doc
> comment?  If that's the former case (separating 'design.rst' side change as
> another patch), that's completely good for me.
I meant the doc/mm/damon/design.rst
> 
> If that's the latter case (separating kernel-doc comment addition as another
> patch), that will make the commit trigger document build error, and the error
> will be fixed only after the followup commit is applied.  Please ensure keeping
> 'damon.h' side changes as a single patch, and therefore no warning or breaks in
> the middle of the patch series is introduced (and later fixed).
> 
>>> : 
>>> : Also, does inserting DAMOS_COLLAPSE here shift the integer values of the
>>> : subsequent enum entries like DAMOS_STAT?
>>> : 
>>> : The DAMON sysfs selftest script (tools/testing/selftests/damon/sysfs.py) uses
>>> : a hardcoded dictionary action_val to map string names to their integer enum
>>> : values.
>>> : 
>>> : If the enum values shift, the test's assertion:
>>> : 
>>> : assert_true(dump['action'] == action_val[scheme.action])
>>> : 
>>> : might fail when checking the struct memory via drgn. Could the python test
>>> : dictionary be updated to reflect the new values, or could the new action be
>>> : added at the end of the enum list?
>>>
>>> There is no test that uses DAMOS actions that defined after DAMOS_NOHUGEPAGE,
>>> so no real test will break.  But this is a good point.  It would be better to
>>> update the hard-coded value together.  Asier, could you also update the
>>> 'action_val' dict of assert_scheme_committed() function in
>>> tools/testing/selftets/damon/sysfs.py for the updated enum value in the next
>>> version?
>> OK, I will do it.
> 
> Thank you :)
> 
>>>
>>> [1] https://sashiko.dev/#/patchset/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com
>>>
>>>
>>> Thanks,
>>> SJ
>>>
>>> [...]
>>>
>> Thanks for the feedback.
> 
> My pleasure.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


