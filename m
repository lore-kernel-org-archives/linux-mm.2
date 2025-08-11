Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C70C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CB46B0103; Mon, 11 Aug 2025 02:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14846B0104; Mon, 11 Aug 2025 02:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A546B0105; Mon, 11 Aug 2025 02:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B380C6B0103
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:45:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E3BD1605D7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:45:54 +0000 (UTC)
X-FDA: 83763541428.01.FF356A3
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C3F4C000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:45:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NLUnB8TF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tU05oYk7AfZHOTyMB3YXf3i+Q/YA1x3QXxmOIdL0jBs=;
	b=I+m8rzmLtZBeAJiplLRUl2QyKusWq9+KbXZd/wGSuI59/qMm9vTJ9Onu4JA5pdyy2h0A/X
	MXILuh8m48Z62pz+eitG9AGtALUFEBGxgem0gphdRgMuk2SVCtsJvGOJuui3iwQWqlVC9g
	b3SCs2QwY37vO1HAgMBgfz6gdRvsh7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894752; a=rsa-sha256;
	cv=none;
	b=nV1ZEvoNPTLpwAhxA6zAA/tTOF+kbhTBs0SCMVDcIlYkxshDpdAfr6WhoG5zUUL0QI0Dri
	SiAVKbLxh8ooruKkMDKcjxtc047t6+XUzvR86My5uBvTytn/oXmSQAGYZ7J823lBCfrBzO
	Z54vAjaCnsNt6CdGHIiVT64RysYGBWM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NLUnB8TF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754894747; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tU05oYk7AfZHOTyMB3YXf3i+Q/YA1x3QXxmOIdL0jBs=;
	b=NLUnB8TFiRlsSgxgXKkYBOdkthed7noubdP2Id2nDq+lbZd7Wg5rT1XaC4Sc/sRJHSDaCHrjSpmk+SYbr6uilnAFg3kK7P1/AGwJwCqtvHvbjX1t+udW0ClTnM53R6iZh8MY3Y37Sj5WSKnWAzJsfRl9JvseOocFarvkBhfHl+Y=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlPK.CB_1754894745 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:45:46 +0800
Message-ID: <4c60ece9-ed21-4a09-b1c2-5f59074d57eb@linux.alibaba.com>
Date: Mon, 11 Aug 2025 14:45:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-2-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C3F4C000F
X-Stat-Signature: fcmso9zjzxwek9euoa35rt3dguhhyui4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754894750-880126
X-HE-Meta: U2FsdGVkX19eNoq44o8TJaR7IFuKmSL9bU3gImdX+H3PchiJhT7LOO2oQSQ5+Op0XbjYFWb0ctAoV3ZAgM4b2ScWzOhZg44Nh2CUv8GNDlHB/5kRB5++KILMYLPxfzclUql19lVCCJBy81ZSmj1fT8qnb6q56rgDrT3j1hTdJF5a4l6fzi4K6e2lc87O/51VbOJgl75ZKLFvRsnVRlQXIAMVQeWbRXnv2aDTpeyu2wNa+vsZH6dhB3wKIF3Fb2hJWCMeuPPP2wQyB/2WXPkdRQH+k2TJNS6w50tLIH5IfJqNgw7SV4aIWIDdeLpOJGAS6aUa9T9rMsffrOJZLtPdny7KcGTSBAFHW0BMcOmMAjNUWIwbYtCB4/nkSpnh5Ho1r0LBKlEjBVnoHZk3tr5AVBU02zxFd7MC2N5Td4v0n+DEUEEgNkIG5u/gcq6H8eOZk9RJoSI4fjm3tDkuEoHfX7a0rB8VgDM/WOLVN8e7UInU6ra058IG4HTxejvJ5NcYA6h/JQhpL7EoCMiu9t1f8La0XIzHzJW9wzb5vG3tuCpDCfuV40woou1hujfZa+PbWoeSBwMYLJULXhtQRHW+1xQruxOlVB5Zr6oJcK8nEjk7IydSYAjUfHxgZK/HJsLRKE5yHsJENB4m25fsV58f6rzj+z3Z65Uvedx1l7BkVDd2vlE4IVAu9djd/XVmuhy3x6KIVwruPSCvI8yOWF0uxV97VlWsq25xPUt/+3x76jjQUDRE9jD43cmbPRR+zbM2SZguAIl2xWL7xXUPHfDjUHWgIf7wlrSYxkoUpCzXVCoFIUmAXTircOqGmoBPVctXtIlaYbijDob+GCd3JauUz6GE51Fhp7Mr/XRA5Y8mbab2wwi13EqY1L5uPdMtpWEuD4jxS8JLIobXYPS5pOicjWfGv4wpxppV0ShHlDm2oJsmDTYO00ybdn5eh47FpQn0zj/2uP7CGahCovRvcdu
 QJC8dmQU
 oixgqhA+b7z9uZKV+yxaSyC30zQsCQEQFIpDFJ1mIuT0QO0a/4swOPLVNoAregQwFs0s2DG2iG/64d1U64Q3uC/P+goIXZXgpx13fW3Re45/ofxkZTTWUAVQwliahTGgyrobs5rzp5VKB5xjBLw+an8vb2fOoo2WjfdfNWChKfqdDoGNfKT9TsnzZvGa3EZ1o8ns7Fvs+YrxF3YjhgADBQRu5b1+hZkufQEVehPsbSIXUisk2INR7SXvuQc7mSXZlF+32SDdqsx27+ZEMHp89clXQd7utIC+zGKkOFGH2Xx0ke8kHiXJxzN0j6IfXb8/Ir6gkiSi/fpK47fPlGBXAKVcHs3DCLQbRnDkJ4gIHe1MVu11KMqqPQuauAdAB8NOCFc7KkaQK6o03qxJv6I6kdmfLkhQUlksi6jflfrUagGQ9aoXY5TYjx9KzF8RfMm5m5xwx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/9 03:01, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/huge_memory.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..ebf875928bac 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>   		goto out;
>   	}
>   
> -	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -		 pid, vaddr_start, vaddr_end);
> +	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
>   
>   	mmap_read_lock(mm);
>   	/*
> @@ -4438,8 +4438,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
>   	if (IS_ERR(candidate))
>   		goto out;
>   
> -	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
> -		 file_path, off_start, off_end);
> +	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 file_path, off_start, off_end, new_order, in_folio_offset);
>   
>   	mapping = candidate->f_mapping;
>   	min_order = mapping_min_folio_order(mapping);


