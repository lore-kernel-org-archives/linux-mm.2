Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18ABCD10F20
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A0C6B002D; Wed, 26 Nov 2025 05:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAAD6B002E; Wed, 26 Nov 2025 05:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9C76B002F; Wed, 26 Nov 2025 05:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 341F46B002D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:19:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DECEF89612
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:19:40 +0000 (UTC)
X-FDA: 84152361720.17.3F99613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 096AF40019
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:19:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVwJbqF5;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nv0Ia9Ab7WWEHHM0k3Im5+0Yircf5KaIa7EgL+leHIM=;
	b=45/kzNFdLjgQQEm4g5WpBC1T8OCsPdTu4FTNxU/lZpoEY1QI3p3EDCw46qo7/EYFjUrwRE
	dtqTvfTJO8wWoXdrccVfS0pM9dwtXVZK/V5QRRa5svS5EggT4ZpiMHVWFMpI+dXVyIrp2F
	YAjEteBFiyoWkXNF1+be+6gea19wSTk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVwJbqF5;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152379; a=rsa-sha256;
	cv=none;
	b=I7ZPXXB2Zgvjz4dABfCoNw+AlwnaHwgL9ptxfqFa7r5+xZAmDtZexgHXjWAaNjh1zOzAoh
	y0YsHcr33j7wi9ikJFlz24anJJK9l7dZCQvJEShecJLu3XA9BmU5mtoZnBTblKN2nHRG7T
	Az+jts9S7L2z2pwYmhPVXT3MkYzg6yQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB3ED44477;
	Wed, 26 Nov 2025 10:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3A2C113D0;
	Wed, 26 Nov 2025 10:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764152377;
	bh=e9FOp73QbX/qH1ICAIHKKQ91Oue3tJPhRgVdlzZS0s0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aVwJbqF5LwtL/GBKSUM5lJlYOc5Cq82JW3QAUHKZUy6XidPIAMiJBSP3E4lH2cDHG
	 X2Ly6ckgxDIJj4VnA4AZ02oTyXeySLUkMQ51x4rI1m7tbW8hdSz8VLQAYDgA3yquMO
	 u6becA6wo00CKuOCaiqLIYWeKbFktTC6jhiALlraSWGCnAx/bKsccS7Y0ipgbUSIUc
	 6ZhvqjZbMYnY+1beJ3/ghajKkAq2PTzStQyj+UpyKGe4FR6G4z6+y4u+49klpKMLqS
	 nFA73WD+j0GyBzg6b8/ljzsvszZFDzmfMTUq/CQKql4wVXnHk3ariH1xzaNjIjwGu0
	 Gux6LkgjkAB3Q==
Message-ID: <de66cef2-de14-4503-bbc6-21467e0e3e29@kernel.org>
Date: Wed, 26 Nov 2025 11:19:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251125183840.2368510-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h1nedmpayph17c9qu8ha8n35jan5s19h
X-Rspam-User: 
X-Rspamd-Queue-Id: 096AF40019
X-Rspamd-Server: rspam09
X-HE-Tag: 1764152378-349829
X-HE-Meta: U2FsdGVkX1/iLORaFjZpDEKqHOjQy0bfFW9R31mSGCCmDNw6igQYtvwSC4s44dqh53YEfaC1MBPnmhSz3XPjOeTxDmi8K7vpdxwsT+wjJxVeyayuRzdKWxB3jBByNTsiDJ+27jSIPKq4Y95xNcA9rYuGvzGKv3GItgl3c23zZ2xjvbym4TlzkzHRBJs5h2qGIPOhajQ4OeOAvYwZAPgWCLBwYxOjXFJWEaJYsN+XK4j+HeEmJ+zJC0FqpnmoCZXdc0LXocg2VBW0ACUdlhAyZMdypIi8IS751U5YJBUEtFWsSuO9UQ1oMwSUMI/wrXONcZRKa9PpxiFD1am/FzXgfHs7tWIJDDSBLbJ1Qr/TDMl1BJR0R+lQJWalBR2BcCvISlNakz3CUx+D0oU8cylYzdEmkXoc0c/PYuNwM3Za1FwEraojd/ey0AsPBbE9ibpTJktmJrE/2KWiv6j6rHA45CAht4FNwnO4+ozxJYz0k4+OUd4u9PvT1UtRw8cKXdUW+dZN+WNYha/iFO5co5ZagaEDBgnlsOPz0OASYUy9FfKSYm+QgBRtPEKnySc/2esBo8a1PgmoX8MVMRBtef3fZuBoHx7wS0yVcGsZXeUO5wlhUk0aoSSM9ImbJQ60C9cI2n4Q0IFc+oj+qjJaDD/N+Eu969Ntia8gHEbfs5s4uciQiEBvnLzAj/N6k+rGcDU0YlUn9nJS1RNBoo3k8Ww13lRQTkIhNBSByt5R6k3Ls/wqoFRLv9ZbS/9NDmi7rhSBsOsGf5OrX+a2fZl1VStPFueIY9WC2iuG6MXZ8jP9K0N7vvBD4o7LpxT1mWHYcaaemgkJwmDgBsH1MYH/yq5BS3B4rgkT2ck7SQIo/w4Mb8aXEdbj3CVns1y0uNrW9FsiD1sgIJ1/Oi1n7KE2Qa8rtROZmYTNOhjB7Z2Z6ttNKWdxuboWIaW7LNSAN7zB8o3D0s2LYn55GKYfTw1LANs
 S+LHP3pY
 kUJeipqO9pqp92DgW6Q7TAwfepVFBx5C9EJ6m5zzUHtNB5GPFiU0UB0T6PXZcR6IILZBbGfd0i6IujtmQjeoCzlPd7hbS2DOuiVUJ5s1QXw3rWAlZxuFJslPg6CAxfcvMQaLF8gBb6IBF9XxjM7MDDL7XOWPChnq6Or+UtZlmeJKiJKu1gkQY2cm8RDrXea/TA135ClBDS6yE7y9uuK5m9AfTOFXqhNnItXhNBbTMloe7ZtUZxy62naDr/A2Uy5WQXstk9AtDF3hFAkEDaPxEsDW/CEiUoLwXc6ZzmPba3K6QJLayyVY5YbyJoQ9Y73x9ZCvHDXSr/ROrinEeqOskZPAnAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -1564,7 +1571,8 @@ enum vm_fault_reason {
>   	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
>   	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
>   	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> -	{ VM_FAULT_COMPLETED,           "COMPLETED" }
> +	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
> +	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" },	\
>   
>   struct vm_special_mapping {
>   	const char *name;	/* The name, e.g. "[vdso]". */
> diff --git a/mm/memory.c b/mm/memory.c
> index b59ae7ce42eb..94acbac8cefb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>   	}
>   
>   	ret = vma->vm_ops->fault(vmf);
> +	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
> +		return handle_userfault(vmf, VM_UFFD_MINOR);
>   	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
>   			    VM_FAULT_DONE_COW)))

If we want to reduce the overhead on the fast path, we can simply do

if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
		    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
		return handle_userfault(vmf, VM_UFFD_MINOR);
	return ret;
}

Maybe the compiler already does that to improve the likely case.

LGTM

-- 
Cheers

David

