Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82554C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DF06B009D; Tue, 25 Aug 2026 07:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946126B009E; Tue, 25 Aug 2026 07:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882206B009F; Tue, 25 Aug 2026 07:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67B556B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:23:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D48961C1950
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:23:14 +0000 (UTC)
X-FDA: 85139555508.02.37369ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E89B100007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:23:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuMLJAY1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787656991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tyn/y+MG68HEs9Pp5bTgaiJX3rDDKIVre5+E3+QTbSE=;
	b=XgGIcKw7rQUAW+bdSn+kKLQuRLdRRGG1XfmAShglxC+pL96L455CCTfQkQoggB22DfVtu8
	U/3cIpHJZ00+CmoLqLou/+LVOVw22hY+m+3MtpnfO6+Unac4rsHs4FDa46KJ+t5qoOH5qW
	DMrmj6nN4lNFWoM8VbZh3ndHEcAldbw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuMLJAY1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787656991;
	b=Wkb+LLB/dxEJvF0+4rQAGd2c9padMvxVHLVEEprMfsB+PwMr33hxW2LGFfnXZCk/eliZDr
	HAzSh+dnzjkbQLEydthOr5bYBDsxcL/3jxg5hMx+JmCrqvFQh4iDHjJBwUoIbGm9Laxudr
	ESaow9XhYmzoj8toU86JbtkP70GKqwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DE376011F;
	Tue, 25 Aug 2026 11:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164141F000E9;
	Tue, 25 Aug 2026 11:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787656990;
	bh=Tyn/y+MG68HEs9Pp5bTgaiJX3rDDKIVre5+E3+QTbSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WuMLJAY1UgWB45R12EQH+XX1KX79CgVVtBokflTkOcqEHlWAQUSnPp1lMDVi5OQYA
	 mij4WTcyisHP0A1CVOBIBhZRwkxcNLj2qjKm6RBOSWKx6WgK28cTRWXIhNYK+LeD/b
	 IO29TRKJuOrxaL0pPVEu6CCe6RZfAuvDxRqkzwwC0fUNYlbhBN2Fst3Skod8NIvlDy
	 Xe6NLKcvQEuzgPzmrjXy21ARNlBPmdiw5py+xhm9P3yDqG2311iQuCL1cBCAISqAI4
	 NTtlz3EVDQ4KiW8GiMY+yIpu/vWfyesUicZ3JHIxk+JddjhZfLlVQ8NbHtAF5kII8K
	 VR6CWa//69wJg==
Date: Tue, 25 Aug 2026 12:23:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
Message-ID: <ao17EcW1-iNN4Y8i@gremlin>
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E89B100007
X-Stat-Signature: m1uykww3utd96njjwumask3b4y5muejr
X-Rspam-User: 
X-HE-Tag: 1787656991-776968
X-HE-Meta: U2FsdGVkX1+yigShPebQr8/6Aza/YQVoCr/W8cL8K3658aMNnUEWqi+OobqlZh89lnSsOG2cAYfyk2B2y4xEgxposjr8eGMNmG/QWtjbLpCzXMd9WrEMZlTwLavKMEAi5hpr6saLM0IGBka/8eqhRMfrIUog0NSMNxrncdIOaPcbIA/HWgAcmyRDjTkGnYw5S9eoiAKwiehQAYG/CRxCNkkssu3kftoNrurdWqA1cAYW5n2b6QCB+mB5zLzBcjSQcTgKEnS18jIdRD0oB+DStMebgy2OqH5ITlAvTMmcyMR6wod28U+K2Y00sE4mI+c7ynhfPZrfXdJrwpH9Mq1ewuM6MhRUhUnmHCZdxC3pJ2Ujb29wER8xrEGLCAV7Sx88+/331iK5Lzecjys4OTQxynmb/IRokYkvBmQ8xQ/LWzJqhMZPmYwmZZRaMuKXFznhGOpxHc+utvzM+4bn5216Ok4Y0OAMWwZiIr4M7pIJH4yL5JZwFMB8nWES3rIqFW28m3NaRr5MFmvojQnsreEb7Ur4QrBD8JldeJRUgkrejVvu54b6N/NEHwWn2jn32tGv5z3PHGUNkd6UoYEdpCVrWmUgkYXRxx9gntsNR9l+sv/6/3RbjvgyotJOdLcpo0of7WN6ijVEgqSVhX3EbeSVShk9pjYZOJapy3kS8TCxYXyAQx/uwj3oV57yUGPvO/dtn5y5+5jc3PJwD31+1aaWeZY4UUtBKju+nkeJqBcMyUCBUyUC1TN1i+ujBUpIierF+YsTpuZ/g/hhB8h5Oz574zoR7tPdP8DLurd8xPWVegNqjs0TYpfj82nXmYNRSMVSbrsLVloqo7N/X4Gn3FeI9eAJ/HKW1WV2VKw8Mo9k0/V47emS0ayXO3yQBPnZiDUj7eSocd+QsTfLPJkKb+724+2TNygHflqF2mv5QdSEfgkTHAa+kqQKEVwF339r8hTrXWtLVz3PZeGwpRAiOU9
 9zlxmIug
 6ssVoJPBZJ4iMtMwfwKkrGSn8Af03AdAbpH9kM5sWtaCCJRr9rnKMTDk8szHF9AlTbeD+gUEVIEztypf0nvWYaWvMFeBSjomjyP19yLc7Y81Dk/QCoS/Egga5N2cvFEmG5CCbRmyWGGg0fBPvF/GAayFE1ugxjn5QIrioSlwDeIcH/UFznpwsKmoJo9RgED04vFpD45bjeB/yqI86wz+DtEp8U0EbPSdWpsAViIP2/5A5ObIOlwWfCBGMZg46M3Y+dt3UhIoDQbxFkQv98v82GSIavnC1WQtiVBSYO2ybYFr7wuzXkrKrIEUhCr+TmBB4vXFasqrsKrpcYRfnVe3C7A3udgoqRJGu3KBi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:20:59PM +0200, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
>
> Nobody after us needs these parts of the argv[0] string anyway.
>
> This patch is inspired by previous work from Anshuman Tewari [1].
>
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 1d2d6bd72fd2a..83d27d069c413 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1227,7 +1227,7 @@ static void parse_test_type(int argc, char **argv)
>  		return;
>  	}
>
> -	buf = strdup(argv[0]);
> +	buf = argv[0];
>  	token = strsep(&buf, ":");
>
>  	if (!strcmp(token, "all")) {
>
> ---
>
> base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
>
> change-id: 20260825-remove_str_dup-bb089e93094f
>
> --
>
> Cheers,
>
> David
>

--
Cheers, Lorenzo

