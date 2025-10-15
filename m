Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414A5CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDFF8E0012; Wed, 15 Oct 2025 02:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5628E0002; Wed, 15 Oct 2025 02:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2928E0012; Wed, 15 Oct 2025 02:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D06F8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:54:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29395BD172
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:54:28 +0000 (UTC)
X-FDA: 83999435016.20.3EB5EEF
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58D8D40009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:54:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XEpNLvCL;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760511266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1G6utL5DCeqFuLtZqRhRDoOQLJbNPGUsAg7wYRENEs=;
	b=lXMw5QniqbHLGS/ivvOZHGgkPdOX/Uu0Rvokfp8xO+FZDaGNvuk6QVMmw2VCnpGDNPRQUU
	jRFJLctb650LMIBbPkoBIKn1EZEE81qe1Ny95BggKhzpEX76rf0G1FYb1jdN6JooXU2PcH
	QMIt+nPXZhWMRtksfJCcDaSAdNlm8IE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760511266; a=rsa-sha256;
	cv=none;
	b=M2/7xMQwJ6bKJTplD6PMLutyv8P1o+V+xVjb6ElLERyhZRKXt11ySleqhUcnx2jip0uVgj
	F5fV2bdLA2sUFQpsfy7E7AeSenANWNrK0o1F6WlT36m5XEFOiYeBpvWn2WRCiRF4G4PRJ8
	46+ai9vxz3+msiUuufdvJkTXg61SlN4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XEpNLvCL;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <07ab102d-0034-43a5-9dad-e170e89ce60f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760511264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1G6utL5DCeqFuLtZqRhRDoOQLJbNPGUsAg7wYRENEs=;
	b=XEpNLvCLMvnVw+8R8y6htHgy5a76vZslYhcIgsbZaDrUPjBlqX4MN1Ym9q+/inQxF7bhT5
	/B/hSRF1Zch2wo0r8M9596xBjoJyDpRamB8NbdQRReSNcARcwHcV8rowAmr9cjjCLZyp7Q
	4rQ6A/htpGwShw8GTYnscLIEurFOUE8=
Date: Wed, 15 Oct 2025 14:54:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/khugepaged: fix comment for default scan sleep
 duration
Content-Language: en-US
To: wang lian <lianux.mm@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
 Rik van Riel <riel@redhat.com>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251015064333.31274-1-lianux.mm@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251015064333.31274-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: t37587urk6qc6fkuqgaeifhnbaxdmsk8
X-Rspam-User: 
X-Rspamd-Queue-Id: 58D8D40009
X-HE-Tag: 1760511266-207936
X-HE-Meta: U2FsdGVkX18vkURaCxqqV010tCV+mIK+OgsywzZObd5LZ8qdFnNPMrFZtBlZMAzudttovt7q4mnwYKRyv8dfe+xYEzop4gnH1xxC+bgl68beLRRRZtD0WueFpMAZ2v4nOoQ61fE2AbrhdzspIbofDi9yszDCnExNSzwmU/XLaQvS1YnoRvy7Y0a5jWkXwmIUYOdtE4YsjmKJi0nef7H6VbXdTCGAcbsOkeMIhIA8XztPZY5jiCUh/DNd6LX2hYFIeCo2FRx68z9DDVBa42qpk5O6OtmyWTBtIlJoQH7kwQPeefIn7mXbylykKBZlbNgobhyONUeHVlHs3aeMy4H/NM1DcQ2yXJLcwIqxaaOZD2QXMLjBHijw2noYjH8MsJO/wKO0316BNpnTmcJfwNj0Xl1hTrGmX1BGmq/2q66JIW0xqVscQN/yL+QkUYXPNMl5hBYyqLEK+MruLiAJ/QofEw0uk7bfnVSJhF2AFmLGzRDw8A3WvNoXsGYsacj7vFlte7QtMVXc/o4n1byzO3s9NXjWiCc58rYX+KkwWpp8CmrjaKfdehwyHm+eXZcZo9g7tGi09qitqxLsCpfEhEk8ePKfmbRHAuQmRRXcsj2VPuX1iErhyTrTUbpI9rjkIHTalG1gEY+qPPktSyVcXPQUGwcNIWSr9GQJcVd2x7ncbuh1rIE7DGT8nFFpbyjQA9zdJIzVcl6Nm8NOBZWq+aKhP4UyZEec69+vxlDyu7R9X4X841Wl2PiUABktQJN0ZWkuaEjiSNtd2jQsuRK+Fmwd9dNgnBZhbvjOrf5P+6LYbSsausif7KXDeiUwYx1OxJU9vMT9s7ZN9sUY7NesXyK8Qu+WFjH73MIQwhufy23jt9V0kJhWejwqno0JKPzONXhltzTQgN3meLvLSHm+/89eqDFL4J1nq9JAJrjls0FdhIryvuyN978EQuo1i8GB1Ih0EzeZV0vhx68hZTbrcvW
 1J7DAbHl
 +ZKAL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 14:43, wang lian wrote:
> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
> 
> Fixes: ba76149f47d8 ("thp: khugepaged")
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> ---

Thanks!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e947b96e1443..449f983b8891 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -67,7 +67,7 @@ enum scan_result {
>   static struct task_struct *khugepaged_thread __read_mostly;
>   static DEFINE_MUTEX(khugepaged_mutex);
>   
> -/* default scan 8*512 pte (or vmas) every 30 second */
> +/* default scan 8*512 pte (or vmas) every 10 second */
>   static unsigned int khugepaged_pages_to_scan __read_mostly;
>   static unsigned int khugepaged_pages_collapsed;
>   static unsigned int khugepaged_full_scans;


