Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D920CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F526B035B; Mon,  1 Jun 2026 08:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16976B035D; Mon,  1 Jun 2026 08:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53576B035E; Mon,  1 Jun 2026 08:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C53946B035B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:09:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8055B1C0B3E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:09:21 +0000 (UTC)
X-FDA: 84831223722.19.E5CCECB
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BF5EC000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:09:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ktvkqc9S;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfB0ZqR87Vb3EIeBR7rBV20qtEzbHkO/sIK+WTO1F1c=;
	b=LC+viMpVpzoeFnZ4+g1AWxmOjfkBM8f/hBczQX0lJpOnSUYo1T9qSj2gVpdxwF3tbA/2Pz
	9lfEyZ+0n0+k/qLdSrdXzq0n+99itmrXQQKGsBAcAdgj0bSXdNpf5Y38cGlHDowhaDIBXR
	oIT8vsaETZGz+wMjeul/O0u0ZzP+3n8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ktvkqc9S;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315759; a=rsa-sha256;
	cv=none;
	b=oifjt0MWxqIjgi9R7gN/dSn644zppXssFyvNOiUfSEhFzc/W9WaDx4cM3zLeczlqhFd3h6
	rirnUqemjGCA+GS+iGHDycJNRIqHiIEHsF3ZPHg0xKe8r5SV3Kh9Ws2Mx78/+Nn/w5svoZ
	HYFAs0KAGsIhLbS6j7HiyP12f5yT2Io=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780315753; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WfB0ZqR87Vb3EIeBR7rBV20qtEzbHkO/sIK+WTO1F1c=;
	b=Ktvkqc9SCgNrFJNPLRSMRyIDPRVOCI9iwONxZkZyWk5MogF8zId/+zB3EiuV15kF5auUCfVTaxU1tISP1jHYNQ8Gyp1qR6Q/Le1kbkQ4j5GOSwwQXJK+BoFRaMks48wlZgHkBY+toCcuQ0FyP2cx3ssH3bzijEjQbzGHWiRwOsU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X4.VMA8_1780315750;
Received: from 30.166.19.62(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4.VMA8_1780315750 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 20:09:11 +0800
Message-ID: <bbf10c67-435a-4a32-97d4-a90fed2fecf8@linux.alibaba.com>
Date: Mon, 1 Jun 2026 20:09:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <144e7639734a501340bffe5652f8ce32b3657e23.1780066530.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <144e7639734a501340bffe5652f8ce32b3657e23.1780066530.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BF5EC000E
X-Stat-Signature: p9cdxgo8fbny8pskm4koei4u8owui8y8
X-Rspam-User: 
X-HE-Tag: 1780315757-982532
X-HE-Meta: U2FsdGVkX19MvShi56Hpc8tez4ns93aZgs/l345VQFhKsgXE9pEAWxntX5xeu38ib+IPH4D/3/OEShJnTzlqnhZXPyTiDBBgCr9BJFi6A1n3Kjpxxr8AxI4iMBjklCdsYhR55BrRrE6dc+ZuOrZE/Y6xF0A4swrvpgYhDoP4EmQH6ga3WYgsV02muSrzmThZO2j3/FZ1EutDWhh9BJXq08sPZ0Ua2aj37RoSJq4BphlQy9Q5YlLoStb8nDa2CqtDY0ifKnCKnOKotHMbVp4+loBibkq17tHDR7Q6vu7L+t7Cl6NaC6QVlRQjCDiMS0ZeOz4C55b8juUJgjG+ajerQHsR2k55KwXaWgc8eRO78oXHs+skfK6s7k4Ii/vRsJXQ6qOzRfiohBJ8UgAYYvNUkMmcrconOEdticORS2ad8RfXSnnwYjDmHFbH1QQLnNUAnG5p9F/a1yR/PbQnB743Vr4uFDz1VylBDvWOqiT3tve2+AnIAfzySx73BpmysrPZunS5v2qYxyA9DOcRBkUipkFjaoVQX8op7VR0zoZHvlm5kMHnJrYCDOeWAUGKEvupG25iJEg5mb/7vyl1FjbmnaoO8rSjmUIQUqKdkQsW7IWPYiHsnuwajIWy1rNPsmViOC6FHqpiH/5ylb0ncNpw5HbJfQx1jC6IrhT4RrVaBgn1w/VUJjQ7BjD2u6qNL0+buN+ykKXPxiyaTlMsKAkJcKkNxn/H0JfIySAx/JM4qpH/uLmHjp0q+33GFwjyy8JPX7xmU0dSYpwli9EhVGShAxkzT/C+yxJE+NfaZozPFwPkNmesTiR8nNGX4qG9kmqF4Wx9FbHFGDbBtWldjBkD8+0VDJHYhvEfUKv0bt1di1vcneE0xT3ZGkaU+VxVcP3F8UmBf+bo53eb9qvNTllev6crWRqGLFOELjQr9aaqshK/FZZNxe8fZcI+KXJvVDqlQNSB/iI0no6i8E8BSQA
 QyqhLNPN
 wZg689TMoV3ztdsIyavpCaAZjfmPKLWLPiiwhADmJlUildHWAWc1+nJodMWXBA46DCVW4MPGPju6c5l3T4HWAnlBFfH3CnNzVOnYjn86myjv3Excy3ziAQC+QjY9Zg48QfQZBPVUZwA9mkjD5vKlf0MsFa2aIafwZsB5D82ONNCzwgV2C7BimDkhaGcsAdUa6wKAkeVS6z8o83yq6GA2eOREKIoA2d/VRfamr8CIqTpRVXUPSagab/XoJoEMRfLSEFOet51I6pDG8qqTsMQbwYDKrn4xpjdlzdgExyCrpnY28kweWf/5GW6CFvvMjkHav63fkY8rVuouA9eShxysRBItmDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/29/26 10:55 PM, Luiz Capitulino wrote:
> In order to enable THP support in shmem today, besides the user
> configuration required, the CPU must support PMD-sized pages. This
> is the case because of the following has_transparent_hugepage()
> usage:
> 
> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>    if the CPU supports PMD-sized pages
> 
> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>    the code block calling has_transparent_hugepage(), the
>    has_transparent_hugepage() call is exclusively checking if the CPU
>    supports PMD-sized pages
> 
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
> in all cases, shmem can determine THP size support at folio allocation
> time. Therefore, drop the has_transparent_hugepage() usage listed above
> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
> 
> Additionally, we need to check if PMD size order is supported in
> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/shmem.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 88bc0c292f1a..108dc969b92a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>   	else
>   		return -EINVAL;
>   
> -	if (!has_transparent_hugepage() &&
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>   		return -EINVAL;
>   
> @@ -1303,6 +1303,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>   	generic_fillattr(idmap, request_mask, inode, stat);
>   
>   	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
> +	if (!pgtable_has_pmd_leaves())
> +		orders &= ~BIT(PMD_ORDER);

Ah, you did in this patch, but this change should belong in patch 14?

