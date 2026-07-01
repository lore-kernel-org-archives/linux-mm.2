Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F98C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA64B6B00A6; Wed,  1 Jul 2026 03:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D826B00A8; Wed,  1 Jul 2026 03:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94126B00A9; Wed,  1 Jul 2026 03:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B54D66B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:51:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CB551C1E6C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:51:07 +0000 (UTC)
X-FDA: 84939436974.18.F8FAE89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D0CB20002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:51:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihupgV1H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892265;
	b=rZIy4X7hWlzAxRxj/gKFouIgEsYWu0ogPfuEta3snI4J57MewtNV5QAOV7+vaB+1leo45k
	BZuNCQI7TUEIzvkywTtwRKCqzkj0VVsUxb2yvnV1BIoqmQObOiqUWzF+lbBRm3NHkZXXdd
	KdZnk5exLd8k7x3QjZc0+TUFmuK0IQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNuPEiNyFh2OoeX/Rr7knz09YDzXqWO3J4KMINksMdo=;
	b=FcFO3EFgu3QoVciA1zJbk0IVSjFovvSDMILiVR7eGH2Mi7ATBJE7SE5YFk/kX9X4Kxfuk6
	iYnIGsNFihSKlLbG27VUFK2NUDSOMRuxV5jHKwb/uYBkMeOuhGPuF/xYk3vD6NSh3/uyqY
	DBNxB9u689HcwbWAxCgx9XUNVtjwJUo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihupgV1H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ED7E41311;
	Wed,  1 Jul 2026 07:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8248A1F000E9;
	Wed,  1 Jul 2026 07:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892264;
	bh=zNuPEiNyFh2OoeX/Rr7knz09YDzXqWO3J4KMINksMdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ihupgV1H5pLG3nAciwuNczOuw6UIPiM4A8Oe0STjMQb88pVjZEz/lrAF10Gej9sH6
	 WJazoS0DGkQjePkUjUgGSsMe3RUdUsNYjJUecUe5xgdoZCzN8gneBdy+X3P9lc5+50
	 oIlTT6xDfCd89y9DfdkXfvp1elcpJClwlvQid08bmlW2/ASb15dN2gKEsoCijHyHa3
	 eerXR0+IAiCtax4zZ8YnVgpNvU6atn+D5jUpaa4heXP59ueKNs9X+hgmtcOPZk9RBZ
	 yYxLRU34ULRoDd5EIT5KjxrWk0Cu57vHn8sPlUR5ZJh+GQAHUkSb4NXDuiAM8DE/d9
	 cixHmTkQ+Aj3A==
Message-ID: <f1a70a22-f66a-4793-b443-19e02452c9ee@kernel.org>
Date: Wed, 1 Jul 2026 09:50:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/16] KVM: VMX: Use higher-level allocator API
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-9-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-9-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D0CB20002
X-Rspam-User: 
X-Stat-Signature: mc5gxfgqd15com6ir4qmniz8f8da1uko
X-HE-Tag: 1782892265-347142
X-HE-Meta: U2FsdGVkX1/RU3nq4btmDT8nJDKlGtH12oF951qb9hrHAlDUgaX8A7SU7X5FtZcrEzaaGQwyJgXW0tUuyZETx2e733Y7Nw49pHuaOLgU+jG49VAM4eEtMqdkgqxzgE/aLbGkmLMxo5E2Sp0OXFlSPAL9G1X7KIgZpXyRnz2a8hQIi6CHnJ+tXxD5QjladF52595rilrn+f6QTq9nWLothraY5JcrSgVFrAxJmiP2XLUo+TJwo0IAePUeYOuCtUtSfnRyN+fVxlgCIbxA8CMifUuxpznM/eBWfNie6pIPD05fXAfkn5p05F5/YZKX1rMW9lxzXqPGLBsTWIJClm/tUPHh3kXQT6h1GHV/dzVeGxWERqdKcrpbI8y1VN+H8mXnmRAJ+SSeYGK2zJQKBFZodjJpDulglAigMA7kTySWiyaE7J7hdms2IYs0qmkuMmS80qiNKoCIFYlDG9cso9JDmoQBSXffhxi5qMJNJNZvyuA671BLfKQB3dzo/l17gIVCCav1Y9qUmpzxteegLhZWCOh9YN2Qo4Khp7sHLlFJM6mGzjTqVTwJRIzLQm92o+OZUIkAexDMBiumRCH2Oicim41SBejbHf1kCVO7dcclSGn6WzWYKBFSYfEyIp0nJohBX3p1yNicu+48+IGt9HLDfYMRwPYKuyFAf2uclJXMZsDXk311vAKQuAwWZEWb2r2EyaR01HvQxiY8imCynsM+k2vQ0F+BvlHJyulQ+23xq6BVEYmWncaByo1+9ZpxoxJChLA+eqQXLhmJ8xQUkfXufaALTQK7S+fhirmMqJMl/pgKmLwU8nXGbI7wyPcD1bBYX9ndW0a8UMGTiw05ZWN2NlYuIjYkADcjtDZ34jbAtgE5pvMjApFW/NikHOORJySLusY9wsEe7qORiPu5GVuxMeGwaWcsMacogza37zF91DYvknGG6mzUx+aY4iR79nE91PC2fddYcC9IjCE41z0
 weLb6SCN
 qfT+s8kTQ0l2t+OjolT0cCv8vIInIuALAKWUifmAM5vYNa4e9KfqNGpE6Y5v6eS9IADHQ/tzTb6Rhf1LiI/yZk7iOxt8lcrhvxxMvH5OzrnRPEJF54waL5G4Zm3VB7HrBWYByShf8HrA0P5e17UBLuDlQnZwDx/Vxin8Rex2+D3QWijNTZia2GEtVRWppsAgy7OrqUfQiGLZu6yXr6PJpfEKt7OH9pQLsBRupkoLkUQ0fBiaiQ7giSVcR413HFicxw8V6v0bWl/S+5MtDexNFsUo3RsQsc/vmH4BwM73iSWoYTCo2AaBmRk2AWbucQ2eXOIco3POs0TdEGr0YiefTVAD5BVCqPCOjmoMHSzD+6/+j4N9XYqXknyknyUGyYLzvT7tEl6OVTg+RANQAY7gb6HxiQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2325be57d3d75..ad6a7fc6a54da 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3028,7 +3028,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
>  	struct page *pages;
>  	struct vmcs *vmcs;
>  
> -	pages = __alloc_pages_node(node, flags, 0);
> +	pages = alloc_pages_node(node, flags, 0);
>  	if (!pages)
>  		return NULL;
>  	vmcs = page_address(pages);
> 


