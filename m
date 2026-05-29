Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A83ACD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8615F6B0099; Thu, 28 May 2026 23:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811C36B009B; Thu, 28 May 2026 23:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7284B6B009D; Thu, 28 May 2026 23:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625F76B0099
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:41:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCB9CC3223
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:41:27 +0000 (UTC)
X-FDA: 84819057414.01.7B096AB
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6BF1E100003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:41:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ou2aIZQT;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780026086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwFcWOwJkeegfR4BbQvBChM0ATs2whx7uh0xno0g6bQ=;
	b=eNAlhdU9k8/nW8LJzbxRfVRySURtLcF8uhB0zUNTFKzgqUMYxSJiBMT6LmLkSrnesxg/Gi
	KOdisCwoW+4Vd8Atbd9sPJTuhOOooNgGtMX10PXkpamlmPZGSxakJBzsCpc+RtVbSn6FJu
	wYmoyWASUDzV4Z/5AaykynsglymYQeo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ou2aIZQT;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780026086; a=rsa-sha256;
	cv=none;
	b=AmDpJ7mynI5uwg2sKFrwVIVeLZXPlkNunGL5tQJWBwaYtuE9D88FsJA/rPAq8Xk0LVbS1x
	TZEdfiUOOAOpLrDQ9PrLGdsNXU/OWPN1QfNDsmUp73yzNfXzYJ8ti/Ui5l9U5M1dG1xPxS
	qssJQYmbdDfntBdXTQz7//eVjBAbKcQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uwFcWOwJkeegfR4BbQvBChM0ATs2whx7uh0xno0g6bQ=;
	b=Ou2aIZQTUFpHcWM+GeEoYlPUKFbytDZomcHoIvdgX1B/fp6vmhzUnHBLV6dN1fgZWhRAvfO00
	yyrmQqLpqo5kVx1iIuJMLmbbI7BFCRtFoxGVY+meJQsjXzhnrE9tpFozx8Yl/KY+cL5W/0poiWo
	ZeMftN5tD1TtYSkCuGzTk0g=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gRTTY4FLKz12Lgj;
	Fri, 29 May 2026 11:33:21 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5496D40561;
	Fri, 29 May 2026 11:41:20 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 29 May 2026 11:41:20 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 29 May 2026 11:41:18 +0800
Subject: Re: [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in
 guest_memfd_test
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-6-92c596402a7a@google.com>
 <149c954e-dfe1-6bdd-295c-792642a9d915@huawei.com>
 <ahjw6l7uznZ2bYfz@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <fceb92c3-3648-418f-6a07-0148d8690bd6@huawei.com>
Date: Fri, 29 May 2026 11:41:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ahjw6l7uznZ2bYfz@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: qqdynzqgk44psnrqzwfqgdw4pqx8aiwb
X-Rspamd-Queue-Id: 6BF1E100003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780026084-563590
X-HE-Meta: U2FsdGVkX19y1DgzANY0jbZVSaV8ZpvWT6L1CSLMDFLm+ZcR1r2ZNhVyWpf8z17biyKdCywYfp6SwwHakK1qWuPH1SGtoqgPCBQ9O85uS2Ui/Ls9bOimEcjwysZmrhnHNkOg/QoNzMffDT7OV9tyVRXZDQSlF8arGZwhyc3mZ8w2eZxI3p6rD2//YNfKMzqq3tK3c6bEm6R8pm4vbBNgrluGa94yyQHcVWiE74EFzqhC04r8ebriimseLXYZcrP15BRfvr9/8xpslcWYSHY3l0QtW7SCy9iPUhZelvY+n5yqGZWfM8Tz8AtnKVxXof7bXJhA60dVbVhRvAZbRVADbPkgpsoPgfu0v90mKKIojxmXdYbmZeCoF5JJGcx0wl6rcZb7F68rQVhXsTKAiR7HD0zgTQNj69vDJSz4vZagdMcQeuk01NvBxvx5+BXQdwsOKrZQeIfYGL0zDpETLh7HtdTZaGNXPNdNcwfulxE6zv340OAdzfNa2UX2qM+XMFSSW1J3Wgt3QHliv1f/Aa0jD7eHWdM95Wt4890XC8oGKaCSIyUD/MyaX4MypJQ5hT1hQr5A6npdAlBeoUy7mY2CnbV2aNMuSa+ou13DGu4pbvn6lliHyj0hwUvGruPRZ9bP4mcDfvdHv3gwcS1Tbi84u4uKPd6pxkmsl+yHaSmL8M/ww8dZ+sTDhlyp353FrkGkDTlkTkICxR2bahzLbbM+d/FgV84RKage2ppO/cLfdFBURlAEgkCn190EhydUoIzb5H5LDDMjJntVjoRfbWBH69d5jKwzQPPCQp0xCIAf+sLqqQTd6zrVT3wHavcVIEsndNiVYqlxd1+zDfL3zQJ7+MFWBgWgPptNvX+U1LiQOTPARsbRO+PxaFCKSY4QTkPZlW8+BIvTcJ1Qtsjzhx5XL/aVFpSRn1bLa4l/4oBGqFPhOQEAIKblhJiWgnShT1+/Pa6QxlmzYsfpwXYTCQt
 84NrpLD8
 iS7huACAz0Wj0tcMscxJG7SFL4+AMTa6z77rq00M7iSeY286QjIpyJ3BD1dpLuMtx2SJSzmp1PL65C9sk9PME7ZcJFXmgb+O7lUZPn2EtKwyrBQ5TIveLUY7ZD84+aRsZxGARz5vCqoEdc/XAv6JMufx6MNa/+OLmt/j8VMjdhBgHP7V/SRtXCw/zAaApILQ1Sq+DeCPivFYs+IBRcvJebq1stqlLHyMulMIRp+LJCXmY1XhYnZ0SWH5n63p7uixlQl0b4Wr0ST3Er8D3qrx5ABDwRlZNu1VcjYDSNANWue5+epXGKe+q5TFiNxII9sUxU7XIIkDT/svaWcR/8zL5MVVJptdJdDz5ab37RVD5GlViIqMwZt91XDL+yvsN99yLvVDRwvuL/kINp8I/o278ZHk4Db+S+lGvY9qp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/29 9:50, Lisa Wang wrote:
> On Mon, Mar 30, 2026 at 03:20:15PM +0800, Miaohe Lin wrote:
>> On 2026/3/20 7:30, Lisa Wang wrote:
>>> After modifying truncate_error_folio(), we expect memory_failure() will
>>> return 0 instead of MF_FAILED. Also, we want to make sure memory_failure()
>>> signaling function is same.
>>>
>>> Test that memory_failure() returns 0 for guest_memfd, where
>>> .error_remove_folio() is handled by not actually truncating, and returning
>>> MF_DELAYED.
>>>
>>> In addition, test that SIGBUS signaling behavior is not changed before
>>> and after this modification.
>>>
>>> There are two kinds of guest memory failure injections - madvise or
>>> debugfs. When memory failure is injected using madvise, the
>>> MF_ACTION_REQUIRED flag is set, and the page is mapped and dirty, the
>>> process should get a SIGBUS. When memory is failure is injected using
>>> debugfs, the KILL_EARLY machine check memory corruption kill policy is
>>> set, and the page is mapped and dirty, the process should get a SIGBUS.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Lisa Wang <wyihan@google.com>
>>
>> Should we add a testcase for hugetlbfs? It seems hugetlbfs_error_remove_folio() behaves same as shmem.
> 
> I agree that it would be more consistent to modify
> hugetlbfs_error_remove_folio() to return MF_DELAYED and update
> me_huge_page() to align with me_pagecache_clean().
> 
> However, I prefer to let this patch series focus on the
> me_pagecache_clean() path (affecting shmem, guest_memfd and generic
> pagecache), because the hugepage memory failure test is not working now
> (hugetlb-read-hwpoison.c). Commit 66802526298e changed madvise()
> behavior to always force-deliver a SIGBUS to the calling process if it
> has the poisoned dirty page mapped. Aligning HugeTLB would require us to
> fix this part together.
> 
> To keep this series focused, I would like to handle the HugeTLB
> alignment in the follow-up series. Would you be okay with this approach?

Sure, this will be better. Thanks for your work. It's really helpful. :)


