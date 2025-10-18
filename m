Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5FCCCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32788E0016; Sat, 18 Oct 2025 13:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A358E0002; Sat, 18 Oct 2025 13:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20458E0016; Sat, 18 Oct 2025 13:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8CA8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:59:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4768C11A257
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:59:49 +0000 (UTC)
X-FDA: 84011998098.21.A73BB24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C58A4000E
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:59:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hFaK/fFu";
	spf=pass (imf17.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760810387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBwfe+4QGOlx6BY+fUEM0MYWo5Djon2M+2L0u/bBFJo=;
	b=3uvRDHbSWx6+UeHkuqI+aT890U4UL0aZFS6OscNnXlVvmgrr4i/uxWWYiMlOrn+8LTwS7g
	r0hgRm+o5N3XQUVWuROFx0uLYJ/voVdoNcz7Ehh1AkQDo6zoo6x3v0rOD7QtIJ2kE+TmL0
	oHZMekrQXMs7+job1xgp8ffVHI5ZNqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760810387; a=rsa-sha256;
	cv=none;
	b=eKOgxUC5gCyvdtrLmqbeYCipgMqyIng6s3b98K+yMWE/mNVOcZkrMKGdIivtR9JcFaDrdE
	vPXPJrhRTtGN3+WcLN6kWX2TKxhUe2Pc4As4V6KwUkQb2rSk0CINbbMHYTHSxXKFCT8+um
	GfIaR5cOp4vVb4dAvI4vA0TBn0PjrcE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hFaK/fFu";
	spf=pass (imf17.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B58A46033F;
	Sat, 18 Oct 2025 17:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A7C4CEF8;
	Sat, 18 Oct 2025 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760810386;
	bh=BbV03NsBXX5OJ9htFnHtVePUGG3rfU9XY/re9DAiuaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hFaK/fFu1J6TjJFYjVfXaPI0hOPdiGti95Nbs4owUH3M4QRMw4F6+z431BPZZXI0Z
	 KYsmhheTcaM4UL/e3Nirgobp7h6OWLCAbtpU8nuqD+siA1PohVt3r2nu0iNJ05vzHJ
	 HwceSOpePInSDjNKbQa/gJ4xGzjXTV88r4LpgO2nRWgQgSIGkbRAnVHR7UP+37C2pb
	 RNF2vWXjLLWkoTKYvZRasHSH0pcnt4sWSKWz9ugqh8TfR5078VCRWezFOBtv+ERomV
	 IJDyelyvwleqtkTU2QeJNVJbTtDHnAL1nRVioT+QCU5Lodei/HV5v7oeWvQ9YdBkoA
	 waQa8GDeViieA==
Message-ID: <e0d09eb8-a53f-4dce-a858-8852cf8695d2@kernel.org>
Date: Sat, 18 Oct 2025 19:59:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm, vc_screen: move __free() handler that frees a
 page to a common header
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
 David Hildenbrand <david@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <20251018093002.3660549-2-rppt@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20251018093002.3660549-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: nq7hk8hpf9hzsx1z6j9pzqu1hq6mr3gt
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C58A4000E
X-HE-Tag: 1760810387-474478
X-HE-Meta: U2FsdGVkX18Or7OqaT5ThaDY8EtqOPFraikAKjv4nC+ggiKqxeX5RkUKXNHZts3BWb/hB+WhnIK03Su72Ro8XiOT4ziLfbqUnOWa5REirKnxcYzbAW/7rtAjipaiP8exmxd1nQU2dMaLfYM3aqxhQYtMIudmXx8dlqbUDbqFysWXDpIi59wugKFf/3O4BosGqu8divd6klh/+sDwNSIt35WdYNsm9DqX0iuciGM/4TbiYXvhtNsV/Pxfay9UGy8fNxwReJAzRqK5rF4PcLYmMYiq9aktPG/oVblILi2ILaJ++CriQi+Lbc5Va72FrMCGIlFJVs8NWGrWyFfMc1EI6gzpW6t/6hRcxN8XHay/4oWEDJ0bMrpMUAZYc/rbeWNzv0gmGwNvHO/BaM1E79uk6izubBgfGc06ab7WdHgFwz9IkcJBhNT8Tbdys693fGUiCVAfZ54Fu1kPrEQJiEQvbZv4QZ8EvF6Pwa0/2r0JdymvDG+qKyMtYGeYEqHyv95UvmbhJLwtC0WTVEdmtIckwJUpbGW+k9CSy4EDhEdoX95vKgES136Dwx8qq+S0xjKBDNzWjNxFVmxjjvxfTTAnedQPdkFkKWCnr2nHef4uevAYKz+LVFsWHnTjidaCSWpeOXdKOd+MUxVbJis2Z1k3hFzsrCoHf7ONwbDAhNdLI9lfogiMHg1fFqepKpG+d+EVGnZEn7f/6qp1lIuj3FM7NGw8UVHsr4T0FVfCxGIB7KlDFrwIpAsartNuzgwoWuUAtQv5Z1OycSSMbx1s2MfG208nwQtFgJ2bvhJ9DO3den7WvCIexHd3cFsOMD/x3k/vpU5ykbDtKExyBDXcb6zboUNNtaO1njA8bEmRhVkJXVvfOmLDpx7m5gPtWYbswLmX9bB5q8XvHHbpMjlv8qgZDJcblo5yXGLWfzOT/cRxGsFMWhwl+zM8snQ5uP153DNT/OCp6uHVvQgi3O6n1Sn
 9miPb2MF
 Sy2iGLmSQfUsUTth7iLcorjZP/IpPvCINT5PGb9iSl6Q1bcWhk5+tI3BUUowK163gnYb46CF0WKEkYa42VKA7n6tphWR2YsZiNpvybfWXNTcydxQVGNCl/sgL/DY7MJBnyoIONxd6yekKmGJCujrVuLvyB+5IXEDt+QveJ4BdxnS7OVLckn6yDYRpydtCprXgA1mVbhyPl/aQS7PNSgtVKKjh8340lWtXSg6XrPx4kFOKaRUv9hPLAE7qp4qXvnAxyTPN3rO3i6kCPWmQMRX4s/5so2LGhpA+hcdW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18. 10. 25, 11:30, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> vc_screen defines __free() handler that frees a page using free_page().
> Move that definition to include/linux/gfp.h next to free_page() and
> rename it from free_page_ptr to free_page.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/tty/vt/vc_screen.c | 6 ++----
>   include/linux/gfp.h        | 2 ++
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
> index c814644ef4ee..d2029f029de6 100644
> --- a/drivers/tty/vt/vc_screen.c
> +++ b/drivers/tty/vt/vc_screen.c
> @@ -53,8 +53,6 @@
>   #define HEADER_SIZE	4u
>   #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
>   
> -DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
> -
>   /*
>    * Our minor space:
>    *
> @@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>   	loff_t pos;
>   	bool viewed, attr, uni_mode;
>   
> -	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
> +	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
>   	if (!con_buf)
>   		return -ENOMEM;
>   
> @@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>   	if (use_unicode(inode))
>   		return -EOPNOTSUPP;
>   
> -	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
> +	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
>   	if (!con_buf)
>   		return -ENOMEM;
>   
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index f46b066c7661..ee3f27046667 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -385,6 +385,8 @@ extern void free_pages(unsigned long addr, unsigned int order);
>   #define __free_page(page) __free_pages((page), 0)
>   #define free_page(addr) free_pages((addr), 0)
>   
> +DEFINE_FREE(free_page, unsigned long, if (!IS_ERR_OR_NULL(_T)) free_page(_T));

This IMO breaks the build at this point, right? Makes sense after 3/3, 
though.

-- 
js
suse labs

