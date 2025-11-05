Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B380CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7581E8E0009; Tue,  4 Nov 2025 21:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FCA8E0002; Tue,  4 Nov 2025 21:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CD38E0009; Tue,  4 Nov 2025 21:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 574D38E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:45:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01C7D84E3B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:45:36 +0000 (UTC)
X-FDA: 84075012714.03.E51552D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10E2080008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:45:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vTL06P1R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310735; a=rsa-sha256;
	cv=none;
	b=WT1RyDyImtcJQDHkRBX1WHJsAX+DfRGLtS5ooIQ7Hz49M8cfFb0J+K8IwgNy/1kupZYVsz
	8B5eJ2p89WQPujFLosgW+Ve0YBDs1UobNgvWTZmwVOfx5NSOeK6Mi2nvFwhtd5rVl+PpqU
	vhCH74P3ADs0rC2JbSXTqd5oJcwKFMU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vTL06P1R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ggi/Q/B9Jjx+W4BbCfJWgLqE0uFZ19wuYTgC69T+VI=;
	b=5nMv/WFXBJUea3Gs4SeNPYdtG3SHnUYEvAvIjYojd9RiqRyCIpczICj7tce9iHYQSDbkd8
	XAZ9z5tUE8JDg4zoZz3Mpdt/JgY4UMvvl9kIseR9LidINOs61043rIdx3BmYY8b9CQrlB1
	SX6SgQ98FZ0YCuWlrma9ZfEkwRp+BYo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3Ggi/Q/B9Jjx+W4BbCfJWgLqE0uFZ19wuYTgC69T+VI=;
	b=vTL06P1RNNIlClyL1lwh43rq8s5bX7YszQJ7wdw8CC/98pbIztmydkexhOiDM2G6jZXESTZxf
	cXKvc+YlXQZ3kj62CtgIImOwKDQu7K8qtyI/8e6oY/B+18Tic/Q6vYCPhzVlGjszt8XnRPSK0Yx
	9j4OGKfkLgTJf7oa7VKtCos=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d1V5567bFzmV7D;
	Wed,  5 Nov 2025 10:43:53 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C2C4140156;
	Wed,  5 Nov 2025 10:45:29 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Nov 2025 10:45:27 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <dave.hansen@intel.com>, <david@kernel.org>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <david@redhat.com>, <hpa@zytor.com>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linmiaohe@huawei.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <luto@kernel.org>,
	<mhocko@suse.com>, <mingo@redhat.com>, <nao.horiguchi@gmail.com>,
	<peterz@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<tglx@linutronix.de>, <tony.luck@intel.com>, <vbabka@suse.cz>,
	<will@kernel.org>, <x86@kernel.org>, <xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Wed, 5 Nov 2025 10:45:23 +0800
Message-ID: <20251105024523.14300-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <47b3e8ba-bc95-41ce-be0a-ddfd1323bab3@intel.com>
References: <47b3e8ba-bc95-41ce-be0a-ddfd1323bab3@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10E2080008
X-Stat-Signature: 5ejy3yjrg8wsg6anahdq3rtt7f7drw38
X-Rspam-User: 
X-HE-Tag: 1762310733-419691
X-HE-Meta: U2FsdGVkX1+bgMkYtnv6tmmxEhHot5jPcse0odpVbf3zQxJwhX7TFk+wW6VTJ885b5V5KuKi4nW9Hvj7JDHBlfjnGBQbyP+3s0UD90yJ3yl/tqYLrHUP9wM4tGriKtVxNp0jRtoEF+6kDPv34SOl+PGtlBQgyuHHHmnKSQwHwUscKS7OOVWdhGt/yqkP3QrycxuMuW1QR8wdSlGr4fQJqwkge7Dt7TyalrIDR1X8eimq0jhQLivD5tC/rEs5jEvl3xtqkSq1/4I8qadRJVqDmTsd3tohpxsWs5V4Y99MWIjjrRQ6FMRENOlCLRrISvncybSzK8JX9kGUpH1KAj/UcnRcWrh85CWIBe2ClmmZd4j7MfPCJlnFDtnMHg1QYgJxkY5/eufF6C9ahHkXmi6imoXGRrEvxkoHX1nq3ISWdxsarSsik8YDq8wWCnT4943QLDmRXwZ9a0x1P65EWm5se2AfIEW8xOtu8sjHq5mU4GZv1CdZk4g+mvo1NlyN0YoMopQUa3IDKNs6U2Q4ctF71jwmHPJyobWWy5ZkartfM6L5WrSsYSquCdHFIjEGbdNdmDDl5muBUBg7Bw48yJFVajWWTPxLgu1USLRno3rXTZPOqBW8FDFYG3/2thYD3RSSg3sfZSsdyCsEw398E0ym4MEB90I61+oPxVK0Pn+xypvOXU69bdDV3dCsIRdy/QSqC84i8sBZPtCxup/mKzEzwQ3X18aaSIyU0LkTPdpefODagUNTmCTsM41byxFa31HGEgDVHbZxk/1Wg+knIM+VH90zQ8KM/TPKh8N1jJb6AQQBIqTlq2FQglxt9HmgwBguHmnpvAzYWiM1DISnYCK3malWm6/tmuWUTwxDIVEtW5BpLfHPCjlRslEKwtY8jObQESQOZwFOUSs9ORffVhD1fR/6voDuwaX9Xzs0VeJenAIlNrz0hpuU0Iou7AUbRZFxPJYDbjQpdRX8AHkZ829
 DLuXPNq1
 V5+3yCIKf8kxIwvGyu2gbSRFwJ7LlCK4uLSIlkjSEejQUAD4wtb3dwSUAH1MPC442jMbOK4k0ybuk27vYQSTZtkxBemmIcO/jKY2FK4JvP2JiHpM2DWihX5biUUKXgit69a3IOuWpyH+rFsjNcJZD7bAETCSBngWtkFCttlwQZRPNjyhgTVWge7aUyAYzFKgjBZlLTgZjY9ms/JzTbSGmBCHTenBXB4GujaiOtUYelNPr9l9v1Xb3rtX1NvBDBIEtjpOoP4LzEYIxy60z9tdhdNFKjPRXevIH/ksQBDraJMiVpd3BxYV2eJHrmvDY4KVh0ilD9W1CF2X+rRR/Tmd0KaKUD3aZhQ30N1zjzfgObqmbS1SFL/fGoCWGCHQMy8jYRAer
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Nov 2025 06:26:58 -0800, Dave Hansen wrote:
> Which LLM generated that for you, btw?

I wrote this myself; LLM just helped me with the translation. My English
isn't very good, so I apologize for any mistakes.

> I wanted to know _specifically_ what kind of hardware or 32-bit
> environment you wanted to support with this series, though.

I think I have explained it clearly enough in this email:
Link: https://lore.kernel.org/20251104133254.145660-1-xieyuanbin1@huawei.com

In simple terms, it refers to some old existing equipment and some
embedded devices. More specifically, it includes some routers, switches,
and similar devices. From what I know, there is no VM environment that
using it.
If you are asking about a specific CPU chip model, I'm sorry, but I may
not be able to provide that information for you.

Btw, why do you only ask about which x86_32 devices use memory-failure,
but not which x86_32 devices use sparsemem? This patch just allows both
to coexist, and perhaps both are important?

Thanks!

Xie Yuanbin

