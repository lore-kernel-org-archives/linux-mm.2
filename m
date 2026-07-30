Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F304C54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9596B008C; Wed, 29 Jul 2026 22:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055986B0092; Wed, 29 Jul 2026 22:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CAE6B0093; Wed, 29 Jul 2026 22:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C26A26B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:43:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5007EC0724
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:43:43 +0000 (UTC)
X-FDA: 85043897526.13.D32DA6F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf02.hostedemail.com (Postfix) with ESMTP id AAC9F80006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:43:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VMZ46RqI;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785379421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mxo84jFtDmlVPzlZM55LKGbQvKfWkJO0S8IHkeqn7c=;
	b=iO29qpbe3xcTb+Gr8SgD94xvvqmexq+P3p0GnuYAOiIeoGxv3/JgvnEOk9uMlgATEs5uAF
	K/Jfm3hPjuJlnEgaUSi/XsDoDIrN137jFsv2dT8kwUVklko8lChZtEscSDVJ6ZLuOSPSEU
	mi0Mcbgvn5rP4CB+AKZ9daLJFizpyzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785379421;
	b=F4H6S4hklrfWAeWkkNaTERPOrjp3oDgf4TRsrEVwCcDw9MINkmk0iNqmCfeMGW9PRIYRKV
	K11YX9Mgk8mGh29dMJnPDYJRwWGN21yT3+GJ6sekkHgWW6+tSP8czOx3Lf9QMhY97KZN5z
	1t9Tq57dH/ea6qLvq32LNiRNM0cDDCU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VMZ46RqI;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/mxo84jFtDmlVPzlZM55LKGbQvKfWkJO0S8IHkeqn7c=;
	b=VMZ46RqIq9OSd+MAcy0wUr504ndiZCamN9htiAl5ocn9npPx3vu+DhN/995QNmnJiZEqW4d+T
	uuI4RF/wqepMcoz+9rB+hpfl/O7c+UWyllcue4rXZnjpcOXEIzQzJvh7Wyti+lu3Y8nKHRuIGWE
	G40Gvhih4ds03O2iuvGo5qk=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h9YDZ2ZCJz1prLg;
	Thu, 30 Jul 2026 10:34:06 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id D7D322025F;
	Thu, 30 Jul 2026 10:43:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 10:43:35 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 10:43:34 +0800
Subject: Re: [PATCH v2] selftests/mm: unpoison pages in memory-failure
 teardown
To: Muhammad Usama Anjum <usama.anjum@arm.com>
CC: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260729091127.1001179-1-usama.anjum@arm.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <43cca64a-60fb-ef51-2ec9-a73205168fab@huawei.com>
Date: Thu, 30 Jul 2026 10:43:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260729091127.1001179-1-usama.anjum@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: qo7oz36uoohrqghbktjdjz9q76di7jn8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AAC9F80006
X-HE-Tag: 1785379420-441163
X-HE-Meta: U2FsdGVkX1/ISvdzBpqCLjMMvmR1D/LlRZrw0hxBYRg38wRUQB34j4virRnvPOXFMpQB2ToBAjJgwOg7d4cBYPUgbqkSdU8mt6f8+ZooRSftW0xi2OPsTVvHCqzzTcD9dkQz1fsGEzp0p0Ce/LE04hHndI/XX8+FULHo/AI6Va1x2y/Yx2ZRaL/IQ2Mgdgx0m0gEZnDRF6jdBxP7ljXW1pR7adHkhSsFt0yyeYlra0Iv3+NVxUSZw2KUMCAH/VaTbNSyWrZjR7kK72s3FjD31jtPQyFmhEoUwacbH3aBeMuy45wpRkQN9kvKHSx/VQod3ye34RY+8J+RMUgJUUVs6GWU/zLeVRCNEbNeRLHAtpQxf7YWo/hIBhGQ3OpAACL+vkp7Q0DyomfEyc0PJq2+dc9gyc5PbhiqGT+/g1x1ZOdCI0QMoop+w9ONOW6lmevRhfUGhRSqnidc+Mvr/zBMs7bbKCi8w8cuD/CjzVtvwXHqtcM/wSdYl2qkP2bs8/c+Ewc3rt0Qciwj53MFpzbVdXE1hGzVbIIP7MJcdYtxLNOvrl9TmQ8mr6PBjWIcuZyHvEmFv3ZxZ4jxVEpwQC0MehhB6kH8L89SNg3PW3RwJZBxyTKdvhL9zLN+mhs0ju9tDargb1pqJB7KwAb1Sw2kONhiHQU2tmS6WCxxZqfZFVV6aJBTVEh2/KHDFVZek0nmbWZ/F2FPqUyo5R24Mc918BJDIQ7kSGIAsJdBwu7p8MsGtsbB+wtMGOX7VngpbmgufsAP8kCHBpSgJ5Apvn2Hfcp9xoZ2eA1YWEuY5ke9Ty0OFbi/miEzqNNyeFeh1rGc8b19udbQ9f0DMvVI1H7yTM1xaIxfTQWaDypFW3sNZ8bU4ORAXFb1b3v+qOfsA/uLoN28VD6/5GmcAHHJI2rYVWLyebE+WOHOEpNdfmVTh+IKk7D5K8QeDK08K47/06xiT44TpJlapolqLmt3xrv
 U9yGK0Av
 V60xUll986ikVw/uVBBZRXchZdPr5CcUzvoGtKD90WdppyWks0dlMHeoWFfG7TPxGsNPjYmP85PIxksqVCeXXCcW4to4OtAYjkzDG+kWTGgJfAoziU9EoNvZotTwel5RLAI/7achIPUB408Oqt149aC4g8lX9Dlpe83AW/1AZfiwIrrvUger1b+F5SE3CR/ArNktvVvmJCqIdIgrMM3Fe2Lf/GP2uMHL+SnUAoltHAPaSbfRWgRiYE79Ebulfn2Jcsa4YeyX+4pSwx79Uh6jvs0ATw29g8rrHhw9ZxrtIqFST6sZbVYvdE43I4oAgQQpPqYlyla2nf1UiVo0nytMNXs4pubwYfBctVjy+dDTHQd7okOm7FSpNTUq2ZRNXHC/KE2jYLtFyEp41GsVbAVSln2eSjVr5dql4gu1qfIiLxsUlh12McdDNdQ6SSFnAXofPrIJdzoGpZkjgUiAoESXKxqY8I5f+FpAtbTVuCbFNiaEq6X4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 17:11, Muhammad Usama Anjum wrote:
> The memory-failure tests call cleanup() only after all result checks.
> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
> skips cleanup() and leaves the injected page hardware-poisoned.
> 
> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
> self->injection_attempted so tests that exit before injection do not try
> to unpoison a page when no injection was attempted. Injection can poison
> a page before returning an error or delivering SIGBUS, so teardown must
> clean up after every injection attempt. This runs the existing HWPoison
> and HardwareCorrupted checks on both normal and assertion-failure paths.
> 
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

