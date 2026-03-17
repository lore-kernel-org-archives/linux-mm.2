Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66EBF33804
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 06:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC796B0088; Tue, 17 Mar 2026 02:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1846B0089; Tue, 17 Mar 2026 02:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8326B008A; Tue, 17 Mar 2026 02:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1B06B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:52:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E66B413B0AB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:52:18 +0000 (UTC)
X-FDA: 84554635956.30.C1591B8
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC6F1140003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:52:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773730336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLWL9Ka7LxJ5H6Jg3FjliSG0ZDtQPr88273zdRx1mMA=;
	b=oAIAjYCZlLWd0ZmtHg+uD4relL70lLvpaXj/K2/M3g5xwyWSLDLfbO7MHDPcVVqcfKsBbw
	Oh0pnxF4WKMAuSurmb75pt/Iz2brI1V4GQ1500WXR6j3xHZMFgB2siLXDxlFirI0TwNqsh
	XLJAJN+MB8Vrx00634l6uV63gO1V/34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773730336; a=rsa-sha256;
	cv=none;
	b=IB5Z/J7uezVmB+4yciYVkKHdPqc7gWjJhN4l+MhDztFHIkaqO309vH/Y/tQF+hKURYg2tu
	l52HUlMcig/WQQWtgOAzZuuOGidNGA7d18beMXjUamj4xT01vNag9IfcV/yQDRpNTynEqT
	E0MAY+TcwHEv9YlrNgGf5nJsX7WT3Uw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZjLH0lcbzHnGdn;
	Tue, 17 Mar 2026 14:51:51 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2765940584;
	Tue, 17 Mar 2026 14:52:10 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 09:52:09 +0300
Message-ID: <247cd41f-e703-4480-9de3-a8708bb3d9ee@huawei-partners.com>
Date: Tue, 17 Mar 2026 09:52:09 +0300
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
References: <20260317003206.89342-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260317003206.89342-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: bzmj78uasdo1f1raowa4mk4sgnce9sf6
X-Rspamd-Queue-Id: DC6F1140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773730334-858491
X-HE-Meta: U2FsdGVkX1+Jxf9R2Hzu4uxo3/XEeSJ/164GMUXMMVO2XwsYSv2omVeZCM3uSGs2ukT/CS7+GQuwcS3uJzV45nuhxmG6stt/w1N8qm+JlkPilwa/Dun3zDOJm85J37MDiq2541w3WhjDYYW8gQgrWRKNn7F/Og35VWWP0w8iCjW5MIBcClA2quVvAQbor8AlAydnU1DRXRpCWMvDUeF9lSpYDpFCYoo3yb3JVLL3uTuBPGDHfg82+HWMG8DAhlXkqI8wGs7y3z9VcFbH9R3teqlhDR1tQNqVBjj2eU+j7xRM8pZnKO/TV5G9u1leY9n7SnsSHv6AhqytOHwC054uNzdiu0phC+7GTxm73dAEc0Rb3ZHnOyAch6iSH4U3qFNnINlJyBPsDttaukM61Nd41qZcD70pulT24GioZr5gcXNacH4Gyu3Ugpo69mzeq9AWuFbZgOmU3LO4Geqfd8LJted27oRlViHvfteUsW3oVP3Fw1fz2/wGzzY25lKlLbKeAzPnPKDAseM9y6NoFwfagj8XhG5BifDWq6Rs7wTW9Y2eA55WgNz81YFDi9hTQbBBwHbVL6/Le3bwLNt18KZsi8aWNfDM4QOSJXNaqOrYGtO+RK7ibMiFOxeX/urxliby+H5bQ/McS6P4nnWS0qQFNTkcEpKMUIxEcJSh2tCTFkL6cf4eoNzBTN19zmTYAt6Q4h/5uUgA0SjEonhoFTqAqDH6T7SdZl9qyFQtPvrJjZns+aMc5B4Fz22hoIMi9erk/YRM8ZtJEE42V70u255teW1ZdR9uvGm1xwvZfvOVlhYbWyv1sFXscaGMsb3Tbpybi57ItciIuYunHO0eWYKl0M6tZn6VOZM1cYwfKA5Yf2P7fqXxA7qE6JBAIyIGI363WotDWxJnby0IJntfP1qSBEmttbUc0Uwyom6uKO08nf20Q/stmO0AoXSeW7Tw02v3g6mPx3QMhUUbNQqI5q4
 BmgzQQvg
 omjwfAXZIF6sEjsOwR1gpkOiwlWwbwDzPytNlg0p4JtCYQ6xBnuv7LKz91Gd3n3q3Xr5Dcf75+w3FOncM1Swu6O+X4nJ5DVxnELxo+BCqnlCkKc9AOYZL8qa0RK42VmUDCHofpjXRG7ZIyR1mVxVaItdMXfrcnOyiL7tCzOUFNI6A2eMvXYrPr+t4jsHvepDDF0WFVqikGp85uDZhUHoQr9sZWe71/1KKm8fc8DefJ3I3rp9qcSS4779ZcFavNX0W/cR6pRiSGd2oZC3F5+qUhwNE71e41Wsg+GFeGK/hFkeluqiZBZHxmKHWJwH73MLq/nsQJuBH5UiVtd75lYxVzKl6jNAMhCi2tvt6Qpt99DkeX/GCRTuDnn3JLL5dJM/rBxZL+4ceDBLUujnXvHpEow7+p5+gv9OuJQTM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

First of all, I just noticed that this was sent as v2 RFC, while
it should be v1. Bear in mind that the next series will also be
v2.

On 3/17/2026 3:32 AM, SeongJae Park wrote:
> Hello Asier,
> 
> On Mon, 16 Mar 2026 18:38:05 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch set introces a new action: DAMOS_COLLAPSE.
>>
>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>> working, since it relies on hugepage_madvise to add a new slot. This
>> slot should be picked up by khugepaged and eventually collapse (or
>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>> enabled, khugepaged will not be working, and therefore no collapse
>> will happen.
>>
>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>> the address range synchronously.
>>
>> This new action may be required to support autotuning with hugepage as
>> a goal.
> 
> Above all makes sense.  Thank you for posting this patch.
> 
> Do you have some test results that you can also share together?  It would be
> nice if it can demonstrate the benefit of DAMOS_COLLAPSE over DAMOS_HUGEPAGE.
I will run some tests and benchmarks.
> 
>>
>> [1] https://lore.kernel.org/lkml/20260314165156.86647-1-sj@kernel.org/
> 
> Seems the above link is just added by a mistake?  If not, please clarify.
Yes, it looks like I copied the wrong link.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Reviewed-by: SeongJae Park <sj@kernel.org>
>> ---
>>  Documentation/mm/damon/design.rst | 4 ++++
>>  include/linux/damon.h             | 1 +
>>  mm/damon/sysfs-schemes.c          | 4 ++++
>>  mm/damon/vaddr.c                  | 3 +++
>>  4 files changed, 12 insertions(+)
> [...]
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index 3a441fbca170..6720dc70c487 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -140,6 +140,7 @@ enum damos_action {
>>  	DAMOS_PAGEOUT,
>>  	DAMOS_HUGEPAGE,
>>  	DAMOS_NOHUGEPAGE,
>> +	DAMOS_COLLAPSE,
>>  	DAMOS_LRU_PRIO,
>>  	DAMOS_LRU_DEPRIO,
>>  	DAMOS_MIGRATE_HOT,
> 
> sashiko.dev adds [1] below comments.  Let me also add my comments in line.
> 
> : This isn't a bug, but should a kernel-doc entry for @DAMOS_COLLAPSE be added
> : to the comment block above this enum?
> 
> Makes sense.  'make htmldocs' may complain otherwise.  Asier, could you please
> add the kernel-doc comment for DAMOS_COLLAPSE in the next spin?
OK, I will split this patch into 2: one with the code and the other one with
the documentation.
> : 
> : Also, does inserting DAMOS_COLLAPSE here shift the integer values of the
> : subsequent enum entries like DAMOS_STAT?
> : 
> : The DAMON sysfs selftest script (tools/testing/selftests/damon/sysfs.py) uses
> : a hardcoded dictionary action_val to map string names to their integer enum
> : values.
> : 
> : If the enum values shift, the test's assertion:
> : 
> : assert_true(dump['action'] == action_val[scheme.action])
> : 
> : might fail when checking the struct memory via drgn. Could the python test
> : dictionary be updated to reflect the new values, or could the new action be
> : added at the end of the enum list?
> 
> There is no test that uses DAMOS actions that defined after DAMOS_NOHUGEPAGE,
> so no real test will break.  But this is a good point.  It would be better to
> update the hard-coded value together.  Asier, could you also update the
> 'action_val' dict of assert_scheme_committed() function in
> tools/testing/selftets/damon/sysfs.py for the updated enum value in the next
> version?
OK, I will do it.
> 
> [1] https://sashiko.dev/#/patchset/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com
> 
> 
> Thanks,
> SJ
> 
> [...]
> 
Thanks for the feedback.

-- 
Asier Gutierrez
Huawei


