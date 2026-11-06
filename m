Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86ACB606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=PA/XBQAm
Received: by kanga.kvack.org (Postfix)
	id A193D6B05B3; Fri,  6 Nov 2026 03:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2B36B05B4; Fri,  6 Nov 2026 03:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8917D6B05B5; Fri,  6 Nov 2026 03:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 635586B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:51:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510FCA0CF2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:51:14 +0000 (UTC)
X-FDA: 85404074868.20.F255CC4
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id D7AB540003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:51:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="PA/XBQAm";
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793955072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uw2jcbo2K94Ipub2qP4Q99pSQbMkC01ncZoy8NZ7ZtE=;
	b=56HT7nOxlU4XhYEe6o8YG+kjazYIHfdVeiE4E1oRQoZNR5w3X8PL+zSeyXbHxTMphJZDMb
	fEXXY9AkkStWpTVVw1iRWLihgPJ9p6sNj5viPNM6fqNv6jqVyiKV/LqsSzMp6chn7/ixw+
	dmhbTDHjcn4qnmMyOBSpUzk5UKwbFGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793955072;
	b=ZNAnEbJWhB5eJJq/whwbc9KUhdT0AdyPEF+GKhaDowGd2H6CquaaXqXNWbKA2UZS/xgglZ
	XYoY7isjcXRXeQlAOUr87POWDqqSQgAb2tobeqj0mUzAVE8Nq/TwiZA6+Tx3BdtpHdczlt
	GnjFyeahMtraVnSuHpHlQP3hOjTETJ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="PA/XBQAm";
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793955065; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=uw2jcbo2K94Ipub2qP4Q99pSQbMkC01ncZoy8NZ7ZtE=;
 b=PA/XBQAmEx8IsPS/7OJFQLeZ4Vjk/Xgf6CGt3AkrAKm6p3LefoZj01Twa7vDqugD69JTCX
 OoLavvqGtxiChoXZtxmsdKYlGIOffsC3eZp2ygVGEhoOVkIQv/V0wdij/ExxrW9gptS4sC
 huFbds+bdNGUJQ5pscQMUUnTSvwRyhYbmRpMSuoA+T2UFt+TfZJvf67gSlEl3Zn81x+XTK
 mQqcX7/6ZQthHCYwoS+rLfXUyD2l4P7ZcBA9bUtUSn1hRuYf/bd4ZCUgVcf/YA5GdKe8D1
 AI1y+Li+bj7iFxzsRI/E00L2eRhtPBCcqpeBV17nEuyFfspF748Rn6I2/QnlNA==
Subject: Re: [RFC PATCH v3 0/3] mm: use non-temporal stores for demotion
Date: Fri,  6 Nov 2026 16:50:19 +0800
Message-Id: <20261106085019.90487-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26aed94f7+f6a36e+kvack.org+lizhe.67@bytedance.com>
To: <nhuhuan@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20261103223025.2482227-1-nhuhuan@google.com>
Cc: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, 
	<alirad.malek@zptcorp.com>, <anna@kernel.org>, <apopple@nvidia.com>, 
	<bharata@amd.com>, <bp@alien8.de>, <byungchul@sk.com>, 
	<dave.hansen@linux.intel.com>, <dave@stgolabs.net>, <david@kernel.org>, 
	<dimitrios.palyvos@zptcorp.com>, <fvdl@google.com>, <gourry@gourry.net>, 
	<hannes@cmpxchg.org>, <hpa@zytor.com>, <jackmanb@google.com>, 
	<jic23@kernel.org>, <joshua.hahnjy@gmail.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-nfs@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, 
	<ljs@kernel.org>, <mathieu.desnoyers@efficios.com>, 
	<matthew.brost@intel.com>, <mhiramat@kernel.org>, <mhocko@suse.com>, 
	<mingo@redhat.com>, <nifan.cxl@gmail.com>, <rakie.kim@sk.com>, 
	<rientjes@google.com>, <rkodsara@amd.com>, <rostedt@goodmis.org>, 
	<rppt@kernel.org>, <ryan.roberts@arm.com>, <shivankg@amd.com>, 
	<sj@kernel.org>, <surenb@google.com>, <tglx@kernel.org>, 
	<trondmy@kernel.org>, <vbabka@kernel.org>, <weixugc@google.com>, 
	<x86@kernel.org>, <xuezhengchu@huawei.com>, 
	<yiannis.nikolakop@gmail.com>, <yiannis@zptcorp.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20261103223025.2482227-1-nhuhuan@google.com>
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: eusoxuryn1cyayiujwhieb4goxs6fi1x
X-Rspamd-Queue-Id: D7AB540003
X-Rspam-User: 
X-HE-Tag: 1793955070-506225
X-HE-Meta: U2FsdGVkX1+UD9qzIJxjZ8+iZmgyX5/Oy8mxIJE1GocRXXrke169gXGgRv0vCc5mLhxrxpumgYA30Jc4dOz1XwMBaK/dVV+lEVeAoVSAjGQPAmhrOtMdQinBroDF+ijLT1wQqCe9rcn8udLF9tssE5hGhr4D3DQYveo/N/AE6RvTQqG+9fI9tdXA0F72CjAUKNgF2AEArY+er/jHfYsCdNMvfbcEsTOJk1rUW7YBSIU5GgeItZCqJ1+bR9Zv8RFOJROojLvJhEyvNqUvexMiM4+9qe1iPqYD032BbUT//HqOOfNlJ0tj+oLtTiHiUH2f0kqctBDfEmHJ/vacbSlfVJlKX6BVeqcozO9XlJVwNV7QXQMK/j0KcPCxMp21EK93bkTM6R0L3ytASxy5BHiGX5vNj8BznXMTTqADL9uu24nEgLBuAcoUDpo1W262XrJRV41wKEP5byjoFDikT7+72MyHPKFGD3Q/q6dciB8qElCcF4tU7/SSqcb2yFH21DNbrRIj52+4g5P4l/+3pJZkcXOumcILuyXuN+dJvJoeXhrxTQfTb4UF16fjkyH4rXrWEt/GbuFLjl8SvmSRqiG1bjhJMgclBy3H1FJOF8enoDhNM/g46JtJny052C2iSd3fnut4V3CClUekxW7md5Zm/dWH2wAfDIOZ8freslQynMzdVA2H1zSS572Z1pfFOra8nRxi6E9XcbmR/sGSHkuAQJJfzvK5cvxDAffbZF9Psn40Wg+DQCdO48nPCAyMQs4SF93hWftqReS7Vsh5N5kMXN5AobpTRYLvv2F4y+xQjOqcTZMTb1Hb7kOZxeKMtWC/fDQLUcBJVTRyKWT3ENZe4IMtiLUPKxwS0Zc1PGibC4svxWEL7A0kbjjNFf09k37HFlV0o/9PplBMnJfKwZ5KKPM0Xo4Je/s1Rbw0yQD6t5Z1tVDVnzNihlNJHoGwjOOZdtPk7W1U+4hBYP0eNxL
 A9F3xYdR
 5QtVfBfwOOD1sMCldEV+iG2BLlcLFpPImQKVJD5nIxNYEAM2saCAcyTptOrsv6fkJf862pEtntQrZPAnLUYyCor5cZnmqTaZkEEqchiWcdsaDaN3VtdmdE2w+bl1WajZ4TKSy0WgyRtNAvrkTj/LkFvQ4eKfAqpBtapD12A0T+kSmd86ee/MzMSvD1tkGLEL7QyxB/vKGurse/ik1yv86yd4s5xjYWP9Q3HqinJDF82y3KvGMNJaEXKE7p+76520AT9k9Zk1yW15RjEh/3dKoGwl46Wzuq8Ka0bOK+uKvUFfAw/WrqYvUMrWqGAwQhKUKvk7eDOnJph06t9eTkMixF/XjUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 14:30:22 -0800, Huan Nguyen wrote:

> Using non-temporal stores and prefetching on x86 bypasses CPU cache
> allocation, protecting active workload working sets and improving
> demotion throughput.

Could you show some real workload numbers for this? I am wondering
whether the reduced cache allocation and improved demotion throughput
also translate into visible application-level benefits.

> - Memory ordering:
>   Add a wmb() barrier at the end of folio_mc_copy_nt() to ensure weakly
>   ordered non-temporal stores are drained before page tables are updated.

I have not looked into all the details here, so I may be missing
something. But before migration completes, there should eventually be a
publication step that makes the new folio visible. In theory, that
publication step should already provide the required ordering before
userspace can observe the new folio. So I wonder whether the wmb() in
folio_mc_copy_nt() is really needed here.

Thanks,
Zhe

