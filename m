Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1887C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED686B00A2; Wed,  2 Sep 2026 13:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC75C6B00A4; Wed,  2 Sep 2026 13:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02256B00A5; Wed,  2 Sep 2026 13:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB476B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:26:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C727120155
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:26:43 +0000 (UTC)
X-FDA: 85169501886.17.115B07C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8C130100007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:26:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cDJ5DEt6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788370001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ErMCT6oLuGCxeOK6BXBf1qfbH9FJh8mGL3DSmIsfQA=;
	b=4UcMSw/C/1HnLS9oq7Ix+W4eZpZqPPrKqpD54efyIHmITC5eFGLCIYtbeyd8TBPZHWOwHM
	AtHcxInpu79v3rJlqPei3BClXGZB344ee4P0ouj1syz4/08stmRIju3ksw0VjpITmyNX04
	SQ0syKAEe4qIX5Ei3MNZ/mXMzuIQKOo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cDJ5DEt6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788370001;
	b=GY8Qmfn4kzZ3uBDUfVBqJZQ9WQl/IPDUtwsarrWNnRLSACgk+bzxpLAqDuauKZEq4DjXDP
	JZzSHF+QSllxy2QfJkoSb8qi7QoC+hVPCwlqskoCoRproP6tmB66cg7eWBTIt9Qg/KVzjo
	JNLVpo6p6ZFidBs80HzNUXH4z8GU78A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=4ErMCT6oLuGCxeOK6BXBf1qfbH9FJh8mGL3DSmIsfQA=; b=cDJ5DEt6arbQfiU3k7+VkDRfdb
	pCnVqS+LXZC/rJF1CzCqMCfOXI973ZMfqPRCLCwVtcPfbUz89j1TCm+HB3gUBt9QZOiQNITVkm/s7
	iir9RlrY7YttvwqqvPPC5+2yKwDujckXIMtlNKhL12wVqk2Yz1pIMAM+pPE40mvHbqaZWTxImfzoV
	rWknhTh7FTatH/HOWcQXj6lXrYeMn8vWuSl23VewuCORMHIWD0HtRpYwCPNiw/kkcHAwBRhImEblx
	YUlZfcuM4vcmxYLLSZ056LVFGMaVlnzujOdn5Xck1mhdJ//QZBBn90oE54dkXecxtR1e/aNsGK0o/
	EsM+BRFg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1ojO-0000000FQxA-0p4s;
	Wed, 02 Sep 2026 17:26:38 +0000
Message-ID: <2e2333a9-dc4b-49e5-a09a-47fa502e0e22@infradead.org>
Date: Wed, 2 Sep 2026 10:26:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: admin-guide: Fix bracket
To: Manuel Ebner <manuelebnerli@mailbox.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260902152347.708070-2-manuelebnerli@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260902152347.708070-2-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ox74xobqn5qkrmx7357zmmrjcxxx81pm
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C130100007
X-Rspam-User: 
X-HE-Tag: 1788370000-387188
X-HE-Meta: U2FsdGVkX1/DXP3qLiGA5cR2NunpPJ49Im/oFd9hl18vuOKGpdQVfEOoO3s7woSUYYco/5MSEnJTYoY9sFjuhNte/KR6kY8jTG/CaLfhfCPMOxTwp6VdKqO2+e041EdnssGDf6t9nBfKVSk6bE5j/BPWipg6liTpIXDa9Exyn4H3BJSHno30od1bCjtps+2e9QVlvekimLUj5dxrBh9eQBj7tlWQCjX+39zingABQiL1CGoqg17f3gZ3TNzcLb5JH9JjLAhnb6bwgXAHO1f/PEnVGzAHMKYvny7ruUiaWFPjLabXR0LQ8X1geIjGFHRUxOXCK3d+Wc5v15HRiPFoi5eXrn+z1bTGuJ/nrHXrfImeQzjuR3MyRS9OCF8GSpKNCzql2VtLxns/m9LIB724eAvdSbQgJl3An7ZsrXQOvDCBMjP06DWHJ6wR39uuiqqg+341d32lMeQ3QHTaXkSv0c5T8OjZeegv+PdXUmSq2rbcZIkzZ3nLDUWZw4PYBczuufBDxVabrJ9xerymihHMA0LQ/03s4Szk0/69nXMCpz/+b7vJg/rkAdwYqGoeuJBKOcg+5R3pDzNVuhJ+h9vzRuv4ZXW5toNYVru2zJJYLtYLdXBTecyrtYsMZV63z6Do4dxUwewG9mevbE/btT8FBF5IOzi1sF6ICbhRodMiTk+2q6Yns2otJ5fpkPOOUaHcs/p3UEgkgeQD1mG2sidKZVucAdoyTgZjZaLn/TNn0nkbR931qly8TYLo5KnqE8oYhqOPDbcStc2q94GNORNG+glJa/PX/ZwuAuox48OLNT8RHTFG4SiWPvbko84bmypQe+9yOi8CDypMh+THFAiPaM5QkdmgPp0YifsGPbmhQKVH3P8JRXmk3OZMe5zDs46r52lVRCHfcQ4LhGCNXAMbuf30jSyl3gLci27iFqUHfneta4k6DZ+KWB4bxnMpJ3zpwITXoTOuCYxnR498H8G
 PTsJa/M0
 32GJMCF8BLrmQ79HAd0UYRotwLDFkgEqP8M4nbGpCNzidL8wCpOZ78fqH/B2feyYKajqSXqLSsEAxX3zYGJAUsOsjGTZopostlsUOk2zYug7+0/42YALQf6oEIKXVgMqaISjaeJqWM+vDttgdpZ+UnwbUle4TZOnbWK3bvcC82EJwdj3zAgDnVv9D292X5ohX4EkCzhr/eU4W3k/vZ95tsxC5nbJIsjXnSRTnTjZn600/9gCVeUmdY89OSTC0LLPKVmOrzzTrjwVOq+3/KVbHTVF4+yLfNj+x1mFPToaI8ZiUyaszu4XfosGqZHB2Vh8yrKdPq72Z9cifhsGghQ8m4aRTxQa1NiSJyuHOhXMqiKGczXcEx/s+4IJNWMKNKPjq8oqlp303aJgrWVfstUx1AjGcPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 8:23 AM, Manuel Ebner wrote:
> Add missing ')'.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17a..ebc281e6d 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -438,7 +438,7 @@ zone[i]'s protection[j] is calculated by following expression::
>      = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
>        / lowmem_reserve_ratio[i];
>    (i = j):
> -     (should not be protected. = 0;
> +     (should not be protected. = 0;)

I would probably drop the ';' character but don't bother with
a v2 just to do that.

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

>    (i > j):
>       (not necessary, but looks 0)
>  

-- 
~Randy

