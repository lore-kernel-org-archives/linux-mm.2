Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C42CFA478
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114C36B0010; Fri, 21 Nov 2025 02:39:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC9C6B002F; Fri, 21 Nov 2025 02:39:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028C86B0031; Fri, 21 Nov 2025 02:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E76246B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:39:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9508B12FEEE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:39:17 +0000 (UTC)
X-FDA: 84133813554.13.3F0BAE5
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf06.hostedemail.com (Postfix) with ESMTP id 365BA180008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:39:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="N5/8B55n";
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763710755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jw7Ud8zh45h7Hnmg98SmQKRWVlaGwdOC5WqXH1EQ55o=;
	b=41M6bbogWWAZGI76dsTTCH41UKESF6BgPXpQusPsg3vRHk5DnwknwSOWIk8dopHW9xqIfK
	l9YYIYiptAv690w6GwDnKLR9SWWynxtiPORL2iZpmJmEerZNBrUSrNlvQl2AAQsDXk3QGx
	4IP58t43kVseisyxbIXwrAqbxyaNxQU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="N5/8B55n";
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763710755; a=rsa-sha256;
	cv=none;
	b=uXVClUIIWcNmcVDAaLedZSQLi5E2A4vcTaMxlooLfnhCowWLKDCttZus1+G9pQ2o8Zd4/c
	8WWqsapCQ5VfXweVRki4mv3s1NSjfqsPEdzAbnY6VZmRBSof6A1PiQx5pfWzSXM1eMnNkg
	BwMHJPpJ4ktZMArpe1eKVzuZHn9b+8o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jw7Ud8zh45h7Hnmg98SmQKRWVlaGwdOC5WqXH1EQ55o=;
	b=N5/8B55nKmRouJYEJQ31wAPlVWAbWvnSJEvXC4E4Y/iT7YlDm1xWdztV8ZlPBdi7UML01lUc1
	Fv8XbMPOj7kpwPW+tlnhHlLdprZnTT5vLaEvUbYWZSyYGWOxnOO7oHGFWOv5YELHAHIr5n25AxD
	y1ox9Sv5tlLGPqrKu9b8QeU=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dCRrL55nqz1cyP6;
	Fri, 21 Nov 2025 15:37:22 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F1326180043;
	Fri, 21 Nov 2025 15:39:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Nov 2025 15:39:07 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Nov 2025 15:39:06 +0800
Subject: Re: [PATCH v3] mm/memory-failure: remove the selection of RAS
To: Xie Yuanbin <xieyuanbin1@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<will@kernel.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<david@redhat.com>, <tony.luck@intel.com>, <bp@alien8.de>,
	<nao.horiguchi@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
References: <20251119095943.67125-1-xieyuanbin1@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <8567d8c5-e864-8f84-7805-c004698e72d7@huawei.com>
Date: Fri, 21 Nov 2025 15:39:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251119095943.67125-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 365BA180008
X-Stat-Signature: khriiwio1xxn496eeqgr4f8g4zwaknjr
X-Rspam-User: 
X-HE-Tag: 1763710753-911610
X-HE-Meta: U2FsdGVkX1+K1E9JytOmVgiCeqE+jK7kImgF1TcoIHA3kJ50WJodUWWLIm34Fmv2Vdsu31zsayI8TL3ssw6joa484omgycLD3gIgzg9at3P1w61tapEDZxHyFTgUor5zhAQyQ/1LadbwwxvwHZBbginGj2xEoEUqpbpVYUL7AS3t6JEpDzGfH1WPPg7rDR97qHKu5XUIolmtH2KObehBhg+agHKyHDvFwcIOTrEUJ+GtGwVHvweIOC8RWvRRUSsbefcmD12HsuTfuDY9b/IJEnPVMprxIRsso97Ce6bxCNWxC94O8jZOE77uaQYTERN6BpIvdRn5VcPtLiCVapRUW3xUCRVkjzvehrgLhUDjg1seR+Sc8zkpg7UXMmDYtOwwAUHbmDbQFOle8OKyI87t/PkISCmssKWRb9Kxi10slptZhR+8XjKs0zJf5s4BK9nZj7t70M6FcoQWqEnQ/BPZZVdpmjxEsoRfS0oRJxWccnDFRoIAtn7hp5aXuNR2/29cS7wAc5TMjWOIqz0fXvMR84O8fPnvVhUp8/CVYX0dWG3TGop6p6MXQU22AaszRPSV7oxz1KWKY+pW4YscCqDSjtPrztlz5IXdksikMfON3w3lMOOHBMjXx5yB0L+YnaDT/hzeTKmMcW1c8IMh4A0SygPSs2jMRCvSjwbTU0kGi4w8kSyRHurUX5l6LVLrlvboEI9sxl35+EML2nzNqaAn52muPe/+H4J+FZa3skQIjauI0O/3vgg+Hldonrk8ZLAVUNYUnS8I3EabHWmlt2URBSm1J+ul5Lp8dbHWX+jt1sX2iSGfTuIWL+uzOcaERkNVxyN4I9t7NYRPpw+26BO10pX8iDLc+Vc0oFcvrEJenYiMMHFxLevPWmQGONUuqkSQ38O+C3qmxfxhAKRTSeZdY9W222vbMBZWxBjFIJmHc7tNk5Nur+T3DzWF7YV7z9k5LC4EJMR8pMAkPTA0W4e
 ar3ZNOC4
 I1EmDkhIjDh72ObJf2gx2cKIsUL25BJQckLEj68pf/Z4eHvirFfgJMbgRJh/+to9Y09hVSsqMzYd161t6/mKvstfYPY2PzELRI9R+lsvtv4cP4tAT9bPFDNmaD5zGSqXwIa+FvjaJml1q6xLqaKb1rFP6LLUal/pBrMFtG0+7T3roLmbFMNW5OoRZv3fvWQumwBbplrF1tdkgWOjZKcl/tZ8Mx2mSi9F3ke2TGaqcqAb809R5peQtKCBO7VoplqiUQVYN/IaTTAIr0m3qoJKXMAXNs2XqkCZ73sRaOzX26ZbH3eiapg7KLsYRjCamH1ZK9MmXwCZVgyVJhM6mUPUUW+Xm25d80kLZDD/fyEGatqlc1c7E3p2CpPtaUIdqB9CinDXADsi5PQPX7Chw0FYSk/rk2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/11/19 17:59, Xie Yuanbin wrote:
> The commit 97f0b13452198290799f ("tracing: add trace event for
> memory-failure") introduces the selection of RAS in memory-failure.
> This commit is just a tracing feature; in reality, there is no dependency
> between memory-failure and RAS. RAS increases the size of the bzImage
> image by 8k, which is very valuable for embedded devices.
> 
> Move the memory-failure traceing code from ras_event.h to
> memory-failure.h and remove the selection of RAS.
> 
> v2->v3: https://lore.kernel.org/20251104072306.100738-3-xieyuanbin1@huawei.com
>   - Change define TRACE_SYSTEM from ras to memory_failure
>   - Add include/trace/events/memory-failure.h to
>     "HWPOISON MEMORY FAILURE HANDLING" section in MAINTAINERS
>   - Rebase to latest linux-next source
> 
> v1->v2: https://lore.kernel.org/20251103033536.52234-2-xieyuanbin1@huawei.com
>   - Move the memory-failure traceing code from ras_event.h to
>     memory-failure.h
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> Cc: David Hildenbrand (Red Hat) <david@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Miaohe Lin <linmiaohe@huawei.com>

LGTM. With David's comment addressed,

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


