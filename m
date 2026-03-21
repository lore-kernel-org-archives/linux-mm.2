Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8AF1093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA1F6B0088; Sat, 21 Mar 2026 02:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381C66B0089; Sat, 21 Mar 2026 02:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF3C6B008A; Sat, 21 Mar 2026 02:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E58B6B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:30:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2951583AD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:30:13 +0000 (UTC)
X-FDA: 84569095506.08.914D232
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37A1DC000F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:30:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ngMdEzFf;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774074612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gM+fv1OX3vBODJfoWDYk+AU+Hzbvk2rJwSdiRSKHo7w=;
	b=rILkTkSL4gW9tx2sd8wTK10XxKOZrgUA4yoXkyCVW5f4meh+G2N2tkboJPleHMk4JypLc/
	MhGArZndjUOOenSD+dKLDrVUQZEAU6LJATHRmdIu+bd8RVOJn7HAZTGcPPpWtj2VfUszEv
	be49gGVhIv7GdYZMx3no9ntwxI6aqu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774074612; a=rsa-sha256;
	cv=none;
	b=KUvigIxeuVI6P1tf9sOOO4t3MZRZS6SBoRmHntqzHo/mmSwD9F9QLTp2CN+Nyyiy47JiB3
	XZpzh5xMIJL7p28UD7I+6UaSfaj6um4RUxFRIK87ZYkoj19crkvRvcXuhma2zkGMp3e6pe
	UhJIqQcsGUwB8SBpi2A8pv6UpVwTh/c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ngMdEzFf;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774074607; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gM+fv1OX3vBODJfoWDYk+AU+Hzbvk2rJwSdiRSKHo7w=;
	b=ngMdEzFfeqESsT4ZELsglUb6BP1JlpRhOZGk5H/UPOdjV++iyCfedN4LOrLvaom3Ql4m90fkFbGLavJgTwm7eLCkz8VCfKFt/anzhpgpE36IKnsfGgTYGOp8ZRQAhsf84+epQAcCSqJoXN72SLowbqN0G3Wr00NryN2RG8ONTqI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0X.O7cqx_1774074604;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O7cqx_1774074604 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:30:06 +0800
Message-ID: <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
Date: Sat, 21 Mar 2026 14:30:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tipth7wsao678bdcq71ykxa9u5pfnkdm
X-Rspam-User: 
X-Rspamd-Queue-Id: 37A1DC000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1774074610-388051
X-HE-Meta: U2FsdGVkX19fPJN4+jnkFu/kUAq+R6Vqifd8SRi97TCZn+07Lpfb3Tv76gVZ411UBM4inBP729mwbG4AALYJez/M/H99TJCPPR9QIVX0f6vl6NlnTxpfEn68zeX6WcWuNaU/oL5aGqUfILy5hplRMoaJc5rjoIFSohdS7t/XbnZazYOZY0vL7vR/1jTROc7KmhZRiMaO19pwo4YUt0q7dGkpdXfXMSUKGzMPNc/4R5xm04gxGbEsBKGawOOXmgjrXnMIC/IYq0uF52c1zc4dP+F5p7DSXwcFVc8bEaNuKdOnxJLOdoCNknKETPS5IiSzVU7RZAy34RDnDasxyFO5ZSpZF3g+262GitWTCHhsx/fXUurTP1IVTfegJ9fb110Aa8n5Er9qNGTdQgbz8l1VKqmN1BU58elED0Q8AaUY994LeSSpoysPHGX+tBvDqffwAAvv7DCEOpyds32vCuDonQYhc5U6ShlnuOKVh/cxvpCIiLO3MJe5ReiCwL55zShYseG+DSB84O75K+C90FxjBhqZAMLGE5tuP5VtG9W33Zv522jTj5EA9nIqNP+V9GlxpMFLF+X47qMAbUFrM69DkUCaojfBc2Jv+zERLGn9/ZrSJxd1AF4ND2U4l5wWaaRcg1g5cam8tdadcLFjzbUmEgZ1oXN3bZEb1NyhRx1rkakdOdE7fNIgvcnRj+EfK7JpnAi/UeddssF5VWnJXxQ6EobnpzUooa2RvlSDjHtNEG+N2gY4U9bHuPVICwoOlDWlgBmhZsr7EH81U0RY7IaKl1dJR9fObjIR2xoNWbhywxrZRdZSj5Oela7pXRu9Kx1nqZwVgraJhrfsHTvQCrv5SdzRbdrtkdx/A9SPJkFI7KZ/D1Rn7sVHWM8DFRmJRBx0nVFhVn6PVv25ciDhwowRi4UBobNQSmWG5xc3qXdZ5hd6aioiZpv8Ul3t18WAwfEk6OHHG9VEOw3ZvmzcLNK
 qfjnQT0Y
 OH5gQrTKC9H7U4ON8p6RHTI3M7LheTAj9VpJ/NeRb7WFuSn5gkxRAmnETIkRD4OqkAWqSPU8o4GPL8vpPnQqC/zc2UGKWv3LJLLQMTBz36QDBAQsQeMWFa3eb9iizfDBi5R/LiEOt2pwlP7Rfcb7AZbSqdSNJc8NUObOmHdPOuXNok3/WEkRHYywEdB+tLZQEkEt9KbaA/Qj5/IlKiAD8AG1RkR4MqMCBxlYZJ7v+pVUEoaX5KXJYiifRPzAnTWU7x2NUqIZlEK5i9cclymCK1okobWSOGNcBlb/zKLif8supbwO5S0igd9FW1/49bPYidZOw3oL7oyh6KoptbxM5EQWTw57hc9xxzc8I0JaIkmfzIibtquVWuVUOWSeVry0Iag6M/iFgt150P2JzBWHRpDj+6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/20/26 7:30 AM, Lisa Wang wrote:
> Add a shmem memory failure selftest to test the shmem memory failure is
> correct after modifying shmem return value.
> 
> Test that
> + madvise() call returns 0 at the first time
> + trigger a SIGBUS when the poisoned shmem page is fault-in again.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---

Why not move the shmem memory failure test into memory-failure.c?

