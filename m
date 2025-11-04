Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526D2CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FEBE8E0140; Tue,  4 Nov 2025 08:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6498E0124; Tue,  4 Nov 2025 08:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913C28E0140; Tue,  4 Nov 2025 08:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8216A8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:33:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1940612BE67
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:33:11 +0000 (UTC)
X-FDA: 84073015782.20.8B9311C
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE8198000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:33:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XjiOLUNL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762263189; a=rsa-sha256;
	cv=none;
	b=WpiuXJRDBr01JDaaP8R4n8ai5P5vX2/CGQBbJVLtdLYcWLl49rYCqxdBc3hXLEcBIPbqBn
	Moj37mUkRx6RW0P40pqHCpgr2uV4zIOXd+BTzelT/KrooSAf8Y9sOKlaBUywojpbRVUht5
	Vgt0pYKjqhaTWMILHrPQBCJGhhGTdpw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XjiOLUNL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762263189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZS1VP48kWsjQkafbWNPso8jvsGsHuCySVWgpy/tEr4=;
	b=IMAONiroR6hcjGJ+YbiCvtA7BzmAySpsgqZ0BfIAv2O/pcfj0LTIxo+8+ElAi1KwtS5MtI
	a0oSSVO/2TSOmXNP4cFy5snqGEsJKVEGIbyzBKS6JVo6wSjtQ14HhZAyuzkY8Chq1cNmdg
	bx1oou21kWa0k4gni74uXoFWXNZo1JM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1ZS1VP48kWsjQkafbWNPso8jvsGsHuCySVWgpy/tEr4=;
	b=XjiOLUNLvWed5Pa1dui1w83KfEcXZfFYdQ60V9KqJ6gWCulwSDVr23cqlpcQiTFoiEyrWDYv3
	k0q42A2tavuKJqxKuvm6AK2vXfp+vMNfUuihI9mqGHwnD4AIQuOl6ChNFnal/PILbpB8IofIp8W
	WqLrUCXS9qCHio9d8TZiFAo=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4d18Vp1QtkzpStX;
	Tue,  4 Nov 2025 21:31:30 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 703D41402F2;
	Tue,  4 Nov 2025 21:32:59 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 21:32:58 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <dave.hansen@intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 4 Nov 2025 21:32:54 +0800
Message-ID: <20251104133254.145660-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <1b316667-470b-4e1a-9c18-e42571e4769c@kernel.org>
References: <1b316667-470b-4e1a-9c18-e42571e4769c@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE8198000C
X-Stat-Signature: y37ohfsm6yoe4pemunebw4i8yegbo5rs
X-Rspam-User: 
X-HE-Tag: 1762263186-707286
X-HE-Meta: U2FsdGVkX18DkJIFX5lVSn0A8ew5/92XVby/yXrX/nFCpgVnSyyL8EC9ALNQQBn9SYpt3DS0ySjRaVXybGxJYQZUsnKwCyz5KJG4wUl5bwFpqTTGIPayI8/Pr/JKqQYJx8NyuSDMuEXgFuAtI1cE5ZYVEU3KYlcReSYa9AKsrS9lVzjwA5cUcyv6v53aj/vx2hpieDDcneZCbYRmJxxAZUboushMiIfZ+ezU3FH+HVMgO2rA+zWel8cbAxUQwnB05FsAcmwGYtr5GpAWxdA+O+phe6zZIeft7b3ywylmKdyrl4qonHUoztMGJmog4Xb2kI6h4/EJqOCFis5kxzOkmaryTGOTmNkOQ5e44DpWuEmataDLJHOfy+jn1h1+LXT/6CUqKuMFPLgV8X1keWmtvt+zGcDfW4ykeN4EdGdx8q90Gnfhjl84YdkGMNQxgN592f+e58h2RBiM09ISRfkVRAD3LwjkkqCgbitFcZp0wbVPkdBE4raGO5B6LC2qCMI8A7PybJrgtNaSd7g9pBO6bw8N4KZT48z2DwtLLeYFNdOn6gUOQMQXp5P7e556fAdV3roUpUB2hiFeoXfpBs79StGQRM2ZD50AIuhOwR8WAzYEhLGQ1KE/sw60RRk1cFjhI+awwtCPo4uYERQMnt6EOSwqVqrQFzGr7UEYzHPFTt4pRU3eEMJymnd8Epy1qt1IVSdjRvM8eNSNfkbpuNllbq2bc7xv373r2JtFcQA/0x2LF+zgFdglJgOsHSQFpa1wIALdwwRWwEFmlkWVM/GQtz9QChubBF81akKHNnIMB4Fl+QR96EjC6Z97coOEZ0q6+KQE/f1fiONYIeOaCu8dlXDqfPNqoYD+3aSQfwaiyIT01nNkpZ0355SHpPWVnW8wKgNeuET4MkrOVjlFhBLsbvIKVpoqaXbloZ5Q1WNS6YhEuVIesXyhY5woaJT0n/4Afalw11ca9jtS1kDRTLl
 ZykD1k3H
 dvsr6AspNM1vBQhTBrYPVhsu4bgSKc9anGYgQk6RzFgprPUPyBN4tZSNcTrFpcjWA9gLTUqAIQ/tJUyfW7ptqELyv2NDyvJdPzxX0b35VBsBtt7aGP00tP9ncWF/5uxYb5DUeC+WVUsB6SFCcu3P6LErRn4mFC9wtMBWKd8Ou/fNLTGYn11oyV7k0U2M7Vwrkvo5DAke1LJko6zonB1a1imWm/+q4Pte3e/Y82Qfx95NHXPaHgUHuyxDiCKwooz1gKFSwjMRoQUSgyjzcNBxw8yTtjgwSWEJnrAFpyNGV8vyHgBCfx4deMYx9URli9fiYWDQPxsBVg00Vl3TKEY3bTofdgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous email was corrupted; please ignore it.
I'm very sorry about this.

On Tue, 4 Nov 2025 10:33:39 +0100, David Hildenbrand wrote:
> This is a pretty generic description of MCEs.
>
> I think what we are missing is: who runs 32bit OSes on MCE-capable 
> hardware (or VMs?) and needs this to work.
>
> What's the use case?

I did indeed miss this part in my description, and I apologize for that.
Since the memory-failure feature was introduced, from
commit 6a46079cf57a7f7758e8 ("HWPOISON: The high level memory error
handler in the VM v7"), it can be enabled on x86_32, submitting these
patches only because MEMORY_FAILURE cannot be enabled together with
SPARSEMEM on x86_32. The memory-failure was introduced in 2009, when
64-bit hardware was not even very popular yet, and the first caller of
`memory_failure()` is from x86's MCE.
Even in latest version, with default i386_defconfig, MEMORY_FAILURE can be
enabled directly on x86_32, because i386_defconfig does not enable
SPARSEMEM by default.
Therefore, I did not consider the need to explain why MEMORY_FAILURE needs
to be enabled on the x86_32.

Now, let me try to explain it. From what I understand, it mainly comes
from two aspects:
1. Although almost all new CPUs are 64-bit, there are still many existing
32-bit x86 devices in uses.
2. On some embedded devices, in order to save memory overhead, even with
64-bit CPU hardware, a 32-bit kernel may still be used. You might wonder
why embedded devices need SPARSEMEM. This is because the MEMORY_HOTPLUG
feature depends on SPARSEMEM, not necessarily SPARSEMEM itself.

All of the above devices, the memory-failure feature may be used to
provide reliable memory errors handling, and to minimize service
interruptions as much as possible.

> Cheers
>
> David

Thanks!

Xie Yuanbin

