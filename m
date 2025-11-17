Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D623CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3808E0027; Mon, 17 Nov 2025 12:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B3B8E0002; Mon, 17 Nov 2025 12:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7778E0027; Mon, 17 Nov 2025 12:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAE88E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:32:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33FE212D2BC
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:32:24 +0000 (UTC)
X-FDA: 84120793008.29.7871E77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 513234000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:32:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4YUPSr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400742; a=rsa-sha256;
	cv=none;
	b=NYqu+/cbAer5gqy2Sx0U0baVPCLJvsClorpN48aMN2jJb/Mb9xFIwYoAsEGq1Kh/8aHOYd
	iX0uJ6Gi7tB61vvQNgyxNaczwbadzfoW+J/I8bOg615nnbE3gX0BMijm6au/9Qk5Z0HTk8
	hEbdWGCkxXEOpLbF1cQx21Atjc3HLno=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4YUPSr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtMZbcA68RELXZigBokvX8Ij3ThB9jv1wgYeCLVN4B8=;
	b=NhUnrD5l3bA8SrSQWlZmyZnfi0+cdAgnSJ4GsI13j0d3vAXFf7vKqkKhOujM62LW14poH7
	uFuu8yryhtXJxppCUruVf3Pr87I2kRj1dFeXwS3ukQGO7eODbvGqlIkzcy7s8uvluF6q1e
	Nu7YYMcsGW7dGrSD68sUdnLGonp5L2o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BA4A40E87;
	Mon, 17 Nov 2025 17:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D67C2BCC4;
	Mon, 17 Nov 2025 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763400740;
	bh=p7UoWhSASKIFM9N8KEMQsy+JJvpT3vPnVBj279wToy4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R4YUPSr601WVdNpuA3i7oRljTsOUFQiDfSzCsz8spsNXDIYLK+rbEFMbhEHJ/tb5N
	 mdPOmWDl7QdROB6UOXtygsocqj4MIXlrwijvCPPZirdSH9iuODmjs2io91zCrf/RQW
	 bSstdD2UD6Q2GX2ncM50q1tkGAMkwCtKTj2xdS09FOoXsxyC/2FgqBJeSj7NqMfrbJ
	 Vk89MkQFXbl6xWUp92IbqjL4EvU0s7YIJQNDEfcDDATarK8vYHYqFyZSlz5aaj5SFV
	 6WORQJVNtQL2rICqXnj5YA1Hr+iD+TYfh/0QoEd5vaqCuRNbbWBUjGns/PAho/tpf9
	 Zvqnv2nnuz2Gw==
Message-ID: <8f4876a6-796d-4d08-9944-730be05b7088@kernel.org>
Date: Mon, 17 Nov 2025 18:32:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 05/10] drivers: nvdimm: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <ebf1b2e8e16e7bca4e2ae9b1f995f314a4697a34.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ebf1b2e8e16e7bca4e2ae9b1f995f314a4697a34.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 513234000B
X-Stat-Signature: 4xjp6bk711omkihww1wf647aa8q9bmk7
X-HE-Tag: 1763400742-193723
X-HE-Meta: U2FsdGVkX19iQ2QeAkiQyxL62s6gbqGy3H2Qzr/yf16IgwsrcFxZJ1CH9kCX7ylzjmy4576172i5sxxRr0A5oWfrW5psLbq5A1+lLww8g1NbMwZ5Z9KKT5m42UHwdF2HTkZi2TDfCZsaB2fLYloo8WNrBp4dPbOJrkdqKHHWaiDZBAknZ8pFkRWxUbl8qU09mcNjun/eiuuIP/s/OiWMn5SRbqu4gwov0fL5qvCs3VXWToH2H9pbFZTDFNUsRbG3E30Q9QqSnSWJlE8giGmdHp4XRrOlTm59y5Lmt5WZxNW8TRCG/vhIYPwZc/pgVGzOQEBIb0mDj27kZ5IABF/Rqx3iM64FCd+nvAUrLkXVyX+mnW+dD7Gxw95X2pU169nAZafdT+I+5VR74qtSA7j9oigFHGNOgFG7usXd8+guhhQGgq/uOa/9OYvLwIPWOS3jIHFR84nZKRlm7l8i2rFKxiY3sdcIbpEgE5KcBCw3dUHKZdLHoD6RLMUAgj1JgEyY41tVRtfLietLf3w9+z+u0MIdyUXB9lVIV2FKkcwiwokTekV/FdsyJC+69cp4Mh4BAMnF3Nn9asSI8GxwllSNnFX0L+r2gKeQURXQCUTXELUmXXQk4plizqJ8+ZEBHb08Pw3ABh9HA4hhSheDDfyxCutZNRdSKp0EtpVNKZdvcF58H7BFZLJpeDMNGavVqIAO1i7/BQ8ZBx12Jk+qgbuVauk05JyayMNIhgMPs9OvBFN33+L8Yg0ypJV4J1b+vIb5yRZhsbn0SWZ4h4+ey8DgCpUOuVXRCIX0l9aUJwVmN/a37kb+hQyinP+1nlCSMiterB5vPsQS2Aa2N8Ch5qbNS6AEkCdbcwSZoBrgHC42o4y939K6aQVORwA555n8yeheedgoOKGGqW5RnXQu+WL0ofnBgiyJbSPt6sFRlzf4VP4ctPvrF2WS1x5nF4qqDBupeI4scHyi9f5bNhu8mmw
 LooclRdx
 PzlfUE+tcIx2OrOacrVJXwLqz+fWrFkKEl5+oPgJ8F6ibpZzsPMWhMGKhU6OqqYJ6zP7gQBdI95f7hEt8XbphnK4bF0xw+fb5/gtwvnHUG6G4F+4Y94StR5DsYiH1AdeJSRxpE4gXtJ4EYJzfVFst9z+T4gODb2Hy2Dpha6/gZb01LASKyo1XKvOiptMGftxp5OnLsX1B4+DpSqkhAbEde7yEevSENAnWitFzLZV8blBcLyqKsRJLNcxIRqBhsoio9ZE+Trl45FjUHIaTOla8/O0cYG/a7vocyA+qlx5RH75v9z0jBKmwxFS3jhBRBGNEI8RwBTGkXyFfVGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> nd_pfn_supported_alignments() and nd_pfn_supported_alignments() use
> has_transparent_hugepage() to check if PMD-sized pages are supported,
> use pgtable_has_pmd_leaves() instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   drivers/nvdimm/pfn_devs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 42b172fc5576..989f87f07e0c 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -94,7 +94,7 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
>   
>   	alignments[0] = PAGE_SIZE;
>   
> -	if (has_transparent_hugepage()) {
> +	if (pgtable_has_pmd_leaves()) {
>   		alignments[1] = HPAGE_PMD_SIZE;
>   		if (has_transparent_pud_hugepage())

Yeah, that should become pgtable_has_pud_leaves() later.

>   			alignments[2] = HPAGE_PUD_SIZE;
> @@ -109,7 +109,7 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
>   static unsigned long nd_pfn_default_alignment(void)
>   {
>   
> -	if (has_transparent_hugepage())
> +	if (pgtable_has_pmd_leaves())
>   		return HPAGE_PMD_SIZE;
>   	return PAGE_SIZE;
>   }

Similar question, what if the kernel would be built without 
CONFIG_TRANSPARENT_HUGEPAGE, would it matter here?

In that case, an additional eary "if 
(!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))" might do the trick.

-- 
Cheers

David

