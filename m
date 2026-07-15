Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD247C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325906B00DB; Wed, 15 Jul 2026 09:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6196B00DD; Wed, 15 Jul 2026 09:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177A56B00DE; Wed, 15 Jul 2026 09:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9B996B00DB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:44:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 794EC1A01AC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:44:37 +0000 (UTC)
X-FDA: 84991130994.07.197E399
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DCDF1C000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:44:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxyFpBfK;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NxeIMCQLUALFB3p9cZLEOe/ZyRxY6DXqkHXVUWxObw=;
	b=55e83hQhAFFL9ecevGkr4OCs9cjEsXMZfWn4P10/9aZxCJfJ0Ti/adiLh25SKlsUzke7+h
	cBDgHwdx48gzc5AnKaVgAuumkDUfm0sFJnuqx65utFE7JcyeWosPBv7QSmXHnjvjhaU94o
	e//4BUPF9DYPXBVPaJ5vIs/gsQQQmW8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxyFpBfK;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123075;
	b=06mQ7h3Y4dCmI0NQivk8g92v5Gq5ORi/wzJAPLSGk2992A7pDvj+X2FJ2VGWtoPFK82ZIg
	efALsrBJiqRQQCI3dQaUNmzIqSPRzSMH/m8p1z5cG0yG6C/+1l3qDVhFRhPqfVGsgHQeHw
	GysuxOcgNYdzLopT7D/8ckgvnqAH3S0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1AD74342D;
	Wed, 15 Jul 2026 13:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318791F000E9;
	Wed, 15 Jul 2026 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784123074;
	bh=9NxeIMCQLUALFB3p9cZLEOe/ZyRxY6DXqkHXVUWxObw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AxyFpBfKq5QOyikTyDSfvnH6Lvyt7riHpVkft1Wf5lTr1Omc9BJjA3kSwGI5RLKoU
	 ehCwOZjqLog2K13vsrhH0E/+d5D6ai59yo72ODnyXor0lGMl9gNx8Z0u1G9Hb+LsJe
	 yJNZ2sbm13kY7qkdAepORJyOpMC0rsG5v7VL4Az7YDbsg3M1rcbX3F47FcZ6ZCzK70
	 XXLAeoiJnCPqwxn0Vk0A7RrvpO6YmYF4DiCC9UZTJ2g8kuBreFke3CuK3RFsJpuF8i
	 IfHx9DcCEXpu4KX9lR5fs+4tzVAp9YCr09yFH0LtlO+1aNSm7LBQL8+n5qlfsmL8bR
	 3JVKmyhAjPp+w==
Date: Wed, 15 Jul 2026 16:44:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <aleOvBtB3WCSsqEd@kernel.org>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
 <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
 <aldv8U-lzCn0SCBL@kernel.org>
 <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
X-Stat-Signature: 3xzsryypwqtys81yiszcig143qf7ed94
X-Rspamd-Queue-Id: DCDF1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784123075-101120
X-HE-Meta: U2FsdGVkX193nFbyV5TvHHdLPitenN2fx/qcMIbtm/F1U6og7NucdZoEzlLOwjH2/q/Wo7qat9zFtwvD/3tJavGClUbRXImFJ8cXQETbOIBJX5ukW/muTY11crLIvorQ7fH//PEK68AcsrsRAgp4smiY8Usp8dFsarl1hZiXZL8WzA/iFFmGid8zt7uUXPuOXO4oynB2H1cXfsMpvEgZr9YpYplDO4UssjcowCQOqWPx5B3/7vm+Gi+lQ1+uXpbmrUqxs7iaCtv1Fc1LwYOZwGiAHgyPh813FI9My3fn5iWLOqTS1jz7atoqjaI0CP9t6+E2gYKeIOlWM3Bo1VANuHbkCQWUQOpRtEblv0840LFTNPEsRYvEVSPq/7pjR3CbR/g9UVNm74M9WuN+CygyCF+httr2FegSIDdoS2KPBc9jF5lf6acs3fFAJ+5ehSfKEsuWozYuczaCloxVQ5ZstDYNGnzIbIHHuuJP9qPV+iaoyGK2LAzVQ5CNwNzRjiWepNiqelH2ivldU5alTvizyo+HQhx2plhPXsZGQZdu8/hKEd6x3CeLM3goP9bnKcdz3dKp06t/ng67vAQwqSRtIhaWQrlSyCGmUNYVD4cbwmvFK/A046aP5lZFA5Pa+lI6vZYCgyx9eq5O/R+3PpslQ9PSz+CVKtHS+/XDxTiSbDtz4dgg+yPvFFfR8bsPsGNB6kTUhi32fPK22flTndieDKvkytltXwLlAd9z5yB5FimjdWyMJCN3O/GrLQxG2aL++tduVAoMZnSx9QbmK9Ew4MRTHCoWjmqkcEKrYeV7zFeZwPVvRkkk+loqTwIwJpKZZjvrvXtbcrWAIROOlZzVOzveTdq7TQz4kyMq4cjBF+dQG1Noe+q2MQOORslx83KcugGVxeUc1dpop8YiOiOcf2xsHkVBCgPYshqpduayLl0uT91DwsUKjHYBD42cXOofLhLxgH8gD1MVPC7l4P1
 lks3fSba
 BIkqpnykXnhgNjGeUz319oBF/ik+sazpu3eemHQeNc13hJLP6YlD5hjww8QNBmYKmxJltuztRHrJrIaeYRNVr3F9PJTOETXrh3NtO7jFOYTUINfbIR8pNKq+CdFyiqd7nEFIeNz/4j0fg1tXvdT6jSNFa1XUwXmX0V8mdxIgmf2lf4HiVZ91XtiGl3P9GBNGbwcgdYAXJwjL7kwh9WvXcR4Qq3sxs4sHpg8MxPC8HhBUlj1rxEjZlSyQx+sQPUnRaDq0z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 02:31:08PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 13:33, Mike Rapoport wrote:
> > On Wed, Jul 15, 2026 at 11:22:33AM +0000, Brendan Jackman wrote:
> >> On Mon Jul 6, 2026 at 8:42 AM UTC, David Hildenbrand (Arm) wrote:
> >>>
> >>> Right.
> >>>
> >>>
> >>> We could even limit it to 64BIT ;)
> >>
> >> I fear this in limbo, we have quite a wide range of opinions from "fix
> >> the broken configuration" all the way to "disable secretmem completely on
> >> 32bit". I'm not passionately committed to any one answer but I do think
> >> we need to pick something.
> >>
> >> Mike's position seems to be roughly "in the middle" of the spectrum, and
> > 
> > Right :)
> > Supporting 32-bit without HIGHMEM is easy, so I don't think we should limit
> > it to 64BIT at this point.
> 
> You mean
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 4877c262cb1f6..d29865075b6ea 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -202,7 +202,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>         if (IS_ERR(file))
>                 goto err_free_inode;
> 
> -       mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +       mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
>         mapping_set_unevictable(inode->i_mapping);
> 
>         inode->i_op = &secretmem_iops;
> 
> 
> then?

No, I mean what Brendan's patch did:

 config SECRETMEM
        default y
        bool "Enable memfd_secret() system call" if EXPERT
-       depends on ARCH_HAS_SET_DIRECT_MAP
+       depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM

We can change gfp_mask as well for the sake of pedancy
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

