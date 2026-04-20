Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EA7F36C39
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 07:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733C56B00F3; Mon, 20 Apr 2026 03:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E44E6B00F4; Mon, 20 Apr 2026 03:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA9B6B00F5; Mon, 20 Apr 2026 03:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5047D6B00F3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:26:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D27855B717
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:26:48 +0000 (UTC)
X-FDA: 84678102096.19.ACCC73E
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5296B40005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:26:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FIuFuYZx;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776670007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkO6Nc68R7AMJu+lA9Su51P8nuTpDZ4kPudBZi+bg+8=;
	b=WBTkNF3KlkWP7I4n3CxUfeZcXp0gQNDUJ/lPQTTJtzYTT9GmAFoxTzOQtcGgLbKV24+orH
	8zPxZrALBRU0/H31+NLglq3RqXbZ2z9e/+YWHK6xV6qckqmpH8ytTZ/yPLG95ehHWI+MO8
	dyrws+k4+zawnYrZFrkysZVdchkZfEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776670007; a=rsa-sha256;
	cv=none;
	b=ZSYWOBUGnMNl8kebt2pzDmmnDLG2SYM3V/aaoAiIwMjpKiZQ4QHy1aP+dSyqhFVrXZM165
	aMaAaVO2hh7W2/lgtKOOm8hpZSH1jd9g6UvTQI/L433T47q0QZh8lP1MBff+tVyf7W47Xc
	lFBBNDVcWtva+kQRr+GOflC2ZTSXVEI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FIuFuYZx;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hkO6Nc68R7AMJu+lA9Su51P8nuTpDZ4kPudBZi+bg+8=;
	b=FIuFuYZx6PMxQ3fAVUZLYpHeiTSRPTIcJ20Ubhiz5fQF+InL/Iuja4kC8IcH3zRZ83hzoqqXY
	7j+swclZ2tWYU+DN9STn+/NZ1ogv85AdvFPfR14qbKswsVaeXuEnFwkeF5BL40b4q2Rw4U00Ui3
	zhpcdX1FjCecB0RuFlyEJDQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fzcML0ljLz1prN0;
	Mon, 20 Apr 2026 15:20:14 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E84040569;
	Mon, 20 Apr 2026 15:26:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 15:26:38 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 15:26:36 +0800
Subject: Re: [PATCH v5 13/14] selftests/mm: move hwpoison setup into
 run_test() and silence modprobe output for memory-failure category
To: Sayali Patil <sayalip@linux.ibm.com>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Michal
 Hocko" <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
	<Liam.Howlett@oracle.com>, <linuxppc-dev@lists.ozlabs.org>, "Venkat Rao
 Bagalkote" <venkat88@linux.ibm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
 <ec5a0e5e98c4fe55b8571c408ca891bd02208cc3.1776150071.git.sayalip@linux.ibm.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <bdcb1965-d59d-4cf8-d79b-a7997012aac6@huawei.com>
Date: Mon, 20 Apr 2026 15:26:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ec5a0e5e98c4fe55b8571c408ca891bd02208cc3.1776150071.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: m3zsiox7738uexfkn96d3x3pp96w8obt
X-Rspam-User: 
X-Rspamd-Queue-Id: 5296B40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1776670004-796528
X-HE-Meta: U2FsdGVkX1/ONHqneyoVinSx1mmhHjM/KvtvvRfRC1BRov77d9c9CkRlY+qbWE0TwlntZLWlhDg9qJ4oYLFFlDLJ9l74x5yodMNXXHX5J6eHwOUjhxPzTNkq+FhMSUcYJI7G0eS+trgZyz9tIptiFrgwE0MeMcCLPfy4FL3Lkn9JMy4TsDhWy74FFKByg1g9hKNgeEDzsRPU2FQLJ9aGpRwrFX9vXlM2sEDnhhZOtKy8lPa2lFg0FMFu5mKYdUxKuUnocyuoKi69v6ef58Eal3leP33Ma/6XB2PHOKND1SZlj6jyO+uR37DWVaKy5w808TiOmThIb+IudBLXkXusLS8CY31lT4LMhPgaw6kY42dLgr7Ha5iSVrMqXEmdWzJGmJQBbaARcvPNafXEy/dpI11SQnS3NBnGmfmuvnKoNFPx5sp1nfwrFIz5Z1A/ylYBK8cVG6h0hi0hug1rqwGZHICbqatP0A5e5JxeQ0nHYduGJ4Pi4EpDWs//UpLruuwDO0V2WqRd9g3giOZZdYXpm2z0RTpb068VxoDT/gZE6mF4G0wmV3bZEzWR97OVHb/Db8tqyQmkPgRAAokES0okpFSBB05Wu8RpWCGs6e/8gr2im+Jyz8cPzf9pS25uNq03zclQQRyeBhdrjAbT5YnW64uOtq1gx1Hbq3FlurNzGUoP7/KTIkVApFOfk63ooQtgc8xm7lGN5RYeGgTc+IoN5Emey4vfTFFfVB9we7ds2Xeqqa2xgRR04xkNAk+sUD08Ildco0vgw+hmPHBDHABAcozRzdQHAKZik6mgvF0z966p5vfp4XALiivshdkss/KR1u3bMyzwGLcjkkQPkjZpBcZzNYa9YNy1rHQ0rrAZZCcqeHhN9vJllZ1NnHc8IuF60b9IHpLlWaL94gHspWwc/9o/UNk/rjuFO3xOVKvck+woz9IMYdlJr+j+/P8KPEcM27LAWeEpw0mq9aPjZsv
 eXuphgZt
 cMhVSkmwtkKrr5tFQBTB5CJNIzrUHn5ZLwT/6QoPvT5XaboQ6dsBc2wgAIvtQyh0IxVVyEvIQwgB4fIDWct4wvnNf8T+jMVSyab5Ofwt30ySYJh+JlwvalJt9tlBFq67Ug8UjIpqllAHfBM3eNpYZhhFr//FIPebn9kIeh+8Zb599xVCooxTT8VRzojEx946vhkBTf5BZbOJ8t3VZk4SsSpYhhiqcEhDBwgkIgdU3G6w0XxW2dr4APpzlvpcI/tmGj/twwY4kML1PS6IVFZ1u7JoTmyoOTMIwJ8ciPqsL9LtTIeVKsaKDmGdE9K6q/AMgH1UU5uz6x9flSBjfs1MYlidC3vEXhc2em3he+hi0+/z44tBx43+5+8ipMpx2ewvqWD1ZgTkCilg9ekbBydSkA8zlTI+Uo0oLEMlf6Q1qiuMwYGkteMVXqjrK6qSPfnDYZor9r1fHKtdEOZZU2lhaHRnPNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/14 16:22, Sayali Patil wrote:
> run_vmtests.sh contains special handling to ensure the hwpoison_inject
> module is available for the memory-failure tests. This logic was
> implemented outside of run_test(), making the setup category-specific
> but managed globally.
> 
> Move the hwpoison_inject handling into run_test() and restrict it
> to the memory-failure category so that:
> 1. the module is checked and loaded only when memory-failure tests run,
> 2. the test is skipped if the module or the debugfs interface
> (/sys/kernel/debug/hwpoison/) is not available.
> 3. the module is unloaded after the test if it was loaded by the script.
> 
> This localizes category-specific setup and makes the test flow
> consistent with other per-category preparations.
> 
> While updating this logic, fix the module availability check.
> The script previously used:
> 
> 	modprobe -R hwpoison_inject
> 
> The -R option prints the resolved module name to stdout, causing every
> run to print:
> 
> 	hwpoison_inject
> 
> in the test output, even when no action is required, introducing
> unnecessary noise.
> 
> Replace this with:
> 
> 	modprobe -n hwpoison_inject
> 
> which verifies that the module is loadable without producing output,
> keeping the selftest logs clean and consistent.
> 
> Also, ensure that skipped tests do not override a previously recorded
> failure. A skipped test currently sets exitcode to ksft_skip even if a
> prior test has failed, which can mask failures in the final exit status.
> Update the logic to only set exitcode to ksft_skip when no failure has
> been recorded.
> 
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

