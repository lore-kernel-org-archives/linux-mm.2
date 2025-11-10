Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66797CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B568E002E; Mon, 10 Nov 2025 13:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C624A8E0003; Mon, 10 Nov 2025 13:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA02A8E002E; Mon, 10 Nov 2025 13:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC2B08E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:09:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DCCF14024E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:09:19 +0000 (UTC)
X-FDA: 84095484438.20.ECC4529
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 37A5618000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:09:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LRugej1F;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762798157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxJDSz8lkcQI8drp7Prq4JYxNaLDzmQx4ulM/ZPcMeY=;
	b=YKI5DG4rH45D33B5FiMrN+WOYV3LDJxP9Bi/+2OtZi3bXtZ+YaJnGpgtRJa6nMx+kmu2ZE
	am+3N09xNUmS8WiYrKzGAPaAsE+443+Vg3/lthcXooVCfTobqXo1mfQ0klr/CerJomeUUm
	drDmUW5QUTbFuWdJKYNt7wEaFyH53p8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762798157; a=rsa-sha256;
	cv=none;
	b=r3IJgbAFFyd29MI2C72DzoT6g3BYCtqWvJx9ZAsnVJfkYg1yEQEIKoemBHsUGPkKmlScln
	ZpEDKLLjISXy7kSmpqKoGmMYTTgubtwIIbIigtTcsgtY99S+pCzlCDnAsPdLXqTjWnzWkd
	vf14gdviq9ujj313ggPi2Hwp5C7Dwp0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LRugej1F;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E15D3403D3;
	Mon, 10 Nov 2025 18:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1AEC4CEFB;
	Mon, 10 Nov 2025 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762798155;
	bh=bWAoMwFPwmev6XGzVDuTW34XLemkAhOwCMOC56+kBrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LRugej1FLuwbwrM2ekd19HYlCC5kDDwkZc4hqKG5Zq/mAwJfACdaVjOR32Gso6WQx
	 kSs5wCP/pPolWGp8z9XhkYNLuFuNkE0gqHq9lZvQ4218k7E5kyuOqOn6NCr7eY3jHd
	 VcroqitUMuCYtCwfrrjMu2BhUa3jCfUAVczRcpno=
Date: Mon, 10 Nov 2025 10:09:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wake Liu <wakel@google.com>
Cc: David Hildenbrand <david@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Ankit Khushwaha
 <ankitkhushwaha.linux@gmail.com>
Subject: Re: [PATCH] mm/selftests: Fix -Wtautological-compare warning in
 mremap_test.c
Message-Id: <20251110100914.af77cb0a5b4211313dd9f32a@linux-foundation.org>
In-Reply-To: <20251110175155.1314757-1-wakel@google.com>
References: <20251110175155.1314757-1-wakel@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37A5618000F
X-Stat-Signature: tg8kw7dsmeje6f9j69wuju3hcsortw1d
X-Rspam-User: 
X-HE-Tag: 1762798156-953026
X-HE-Meta: U2FsdGVkX1/Y/jdXN73IbAxOke2OQ9N4KQlbtJ2e1EjBICY701P3Cnpa1FTXoPqm1V7scxDn/tLaFasimIJApV4KzNQQnEYLFLEgUhc3lh4ymZmukPnwj33uovT889q9hCQ2uENyGiWZUvLFiqH2hcWP+i48HEMuDVF1BuLgK1l8JX/6PByXuBkopKE1F8Yy/K2/YTVQmdZ29ldXM+np23rngtBsUwc8uxYjbi5RveBEDuBrg907Gra+mVtLrEGXRKSYIGW430TmUjPHNbvhpHQax6D1DCw9k4xTKZjzQW2AFZ0LQvo7m8L54J1v6C1L4SRlC5ZLXv10waFwBsuPzlKX0RobbHUX+9uiLgpOjEjnqca63CFOdpROAAq8UI/uOsG24WCM4Ql7mlFw+pwTB+1f4nwqDi3H0p7/X30ePGEt/u2MX9u2AtE5S2uLd2BfslAkN2sBfP0+kCrjH+dHgeXe4GXhlY0IK4zqDu6qNyErZeJjgwp4ND5nnsoPTcnka8Wm3sRGyUc6AI8YZj0JA8tLPRkmEgkRMHXv0fMzfEOVq7JXF05hrvrf+kUTPP0tdLtBz1TEy40hYn75xvSbOexTFNAOI/RE7niluO29pf5vpm/dbjZuwoBb1v2bHd3NmHWAb2Ta+b6prFg+1xqFYlNoZ4FYKKcXxeyc8bgYL/vhZNQaGCR/gbEJF+i6U4+TEKvZAE1l4z1kMhyDei7Xceqxyose4i/L9r7YwAQbK6pebGp+FnaTjIUEBWaBNxX4GZ9Rs7j18liwqg0Fnpnk5BZ86qeDKoFKTQyX2heVNZt9gf5Zsh90LBt7vflKjTaxiw3cg0uta5Q7bwslNr1z+5rDnNiWQ+QLpRrCl5DuoTWOnhZhMy5lRIXAPV2A0F+WZFVM6xml4MkgTNPHUniUw5esTNYB5sTZhMLcb5Iv2+Ye+1GTXQcdyhwye2tT4MxS9k0t+05VOMxUuXGzfr/
 Tv7TLzQc
 VWf0UYuZIjSn8awhSRJvVGtAnTmqT1He2iHIyyq56qLMv+5d87rEXDp0W5aVly+WPuqOPc/SIAGpnreIdg/LYX7R7+WzQk+bxOtEGUMTNfjO7X3f6Niltm782hrooKoEOg0HV9IkNl1mI7W5N655zFBvejfS9bX/H35RcdmUkto4zQAFgAutnie3LdtbnFmtrgm5YsjlM+PXl8KyWauxC1hy3CPdwzDVvsmG6p94a+d/6+FFAGBxJ0shbq3dnGxD4U5YiVYPbuYY3AfcP+0L7Vi6GoM+j16IHXSEXxzncXkrR5ybZgQgZudvV40XgBmcdemiQX1r5jNJ+Y4CH7fKYbuz/V/gUin8qg3IKNrBJ+4W29Y+rudExTHPtYqPN8ZGRmyu1n3Wjn8Vj3enHFHXokjnV0a9EKSC1x/i8ssS0DnlD95hOJLFvABUeCROUOEUydbdQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 01:51:55 +0800 Wake Liu <wakel@google.com> wrote:

> The compiler warns about a tautological comparison in mremap_test.c:
> "pointer comparison always evaluates to false [-Wtautological-compare]"
> 
> This occurs when checking for unsigned overflow:
>   if (addr + c.dest_alignment < addr)
> 
> Cast 'addr' to 'unsigned long long' to ensure the comparison is performed
> with a wider type, correctly detecting potential overflow and resolving
> the warning.
> 

Thanks.  I recently merged

https://lore.kernel.org/all/20251108161829.25105-1-ankitkhushwaha.linux@gmail.com/T/#u

there has been some discussion...

> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -1032,7 +1032,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
>  	/* Don't destroy existing mappings unless expected to overlap */
>  	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
>  		/* Check for unsigned overflow */
> -		if (addr + c.dest_alignment < addr) {
> +		if ((unsigned long long)addr + c.dest_alignment < (unsigned long long)addr) {
>  			ksft_print_msg("Couldn't find a valid region to remap to\n");
>  			ret = -1;
>  			goto clean_up_src;

I wonder if we'd be better off borrowing ideas from
include/linux/overflow.h:check_add_overflow().  Did anyone try
__builtin_add_overflow() here?


