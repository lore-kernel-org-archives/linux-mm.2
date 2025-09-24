Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2ACBCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 22:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481DA8E0007; Wed, 24 Sep 2025 18:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433658E0001; Wed, 24 Sep 2025 18:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322388E0007; Wed, 24 Sep 2025 18:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E14A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:52:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B15321601C4
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:52:01 +0000 (UTC)
X-FDA: 83925643242.06.CF0AD4C
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1404040006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:51:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=JCkCMpg9;
	spf=pass (imf12.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758754320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAeA7P6OD4ycKMwz9bR0cq11m4HVzCoNn6h4QDXMPwI=;
	b=y4M36+WWM6BE9/eGhHT42UYFe5B9mmxdJl/DL0DFCX3Z+3NIcvtsa1ZiPw83LKEeZtNEx0
	0Q7qtAcl+6tCkLYRqouzs/b2xXtj30B+L3KPi874ZE3JncxledgOwJwsXrhTNpmn9V3pZc
	uM+dWEZAtchDznul0d+WBduaYeN2dD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758754320; a=rsa-sha256;
	cv=none;
	b=MJlBvx4OUjA6V6DEzEdUhbog8Ncdv0djYXvdsFRhYhgWOFSnlMrtEZ1uA1eXkdgdSTYgtx
	W4zKDGBl1ugaq7Ebcl+eXK8ba5fmfWA1uUmt9HE5rpq/+rzaKZJrhqUYu6GI/MhTaNSpFz
	Ki1nYXaTvpHetJ7oijlIjkY8JarVMHs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=JCkCMpg9;
	spf=pass (imf12.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1758754318;
	bh=IYb7VmkC8waq1uiEkTNs1ha+Uf22LW177xDsSZHKOyE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=JCkCMpg9pMvCG5sdzhc/l9xavadn3mVYqBUWq+pWTTDU3r7/d4AWUZCljoC1cWS7U
	 fDA1Fm21fmLvxNdElU/Dn4buonvrfMmPZXnnToA2MLYjgrOTPbTvs+y8CedNIYA0B8
	 M/12NGGm6Z3KqTxAS5c4AWa+axj2Mkbgz0UcfNwM=
Received: by gentwo.org (Postfix, from userid 1003)
	id D4A7940293; Wed, 24 Sep 2025 15:51:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id D29D74028E;
	Wed, 24 Sep 2025 15:51:58 -0700 (PDT)
Date: Wed, 24 Sep 2025 15:51:58 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
    Kiryl Shutsemau <kirill@shutemov.name>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    David Hildenbrand <david@redhat.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats
 change detection
In-Reply-To: <20250924204409.1706524-2-joshua.hahnjy@gmail.com>
Message-ID: <fdb56260-8235-eb20-05cd-491fd512cec0@gentwo.org>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com> <20250924204409.1706524-2-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1404040006
X-Stat-Signature: dc5ahddmdbj8t6xpiz5afdnrn331tsw1
X-Rspam-User: 
X-HE-Tag: 1758754319-143903
X-HE-Meta: U2FsdGVkX19OMTaZkxSOEIUkxyNjkvjiG5MAPxex+/5SoNGPTyM6eyTGeqmnrOwHU1T3EGCa6dx+BXyFu32VkdwSWabn0MOD/ZvLUwFkRFxZ3B35by4lXxwwEThqaJQQq7RDBf0AUWbXbvAW6Y2KY1bC4OToVxpGWIHhSi8OfdNrkTYABrPosaDqNvIxBi1WFk4nI2Ree3uIn/fPEUqYQwCJXaZPDzYjWz2CvLSaK51nmUkgVb79w8cZl18A0/XS/5OJnz8GU762yq3Dtv94HMzKCkZdLS9LYNSOUOt0vgs3/0KvQtiEyUKsAMIZ7KKxEgswyPLrCiPDB07jT8R5KBApoAmhJC2bPop441iWTsCTg6uswN8iNXU3QDNdzw0pzrSOinv12jk28onnCunPNw4s7iuN1wg/tF3cJLB0GjgQqbCLIQs1c0Z8UnNmB87NcmNYxIwEjAAU5hw31bkFLks6Gnoavy6/TSheVfNNjZcEQ1C2oJ6cnb3y2zswt/L/9n11U1dt1G4L8y0XOKPqL838l8aZBerz6LGnOuYEQkrUWfOs0jG/ONPeWD7xxg6IQpszyZQ4xxl5Ukksqg6DO3lPcpie2WFrIfZcKLG8ZqhxUAyCLfHNp7bYuXKa5vjL6e+eCA7zbf0KRKinxalTccZvxh8eH2iA6g+DVBAzg6uu2nFZPfzH1N1d+DcU+vA6X7y3BmJlTQYNjCGVS2+2toSpgamuEhhTAv8z/Po80iKoiswzPwOObUnVEKTiLXOapcix7sw6Y9bnXU+U3ozaocHk6YYS6CMzHm2YJTHkdWa6ktsa4Fo5iNn168pviWRM4Lrk9CspGuJeV3/hcSTz5hzdXvVWDVqwLDwGZ2eEaiOobSe+PPxkUkQIf2tF3CvY3peEcjSWp6RL57sOQ4gYIebKmCqjZPIm0ZMjm1eBluMYvrBrUcocoRKyAejllTAxx37DtlDIIi/8ANVRFhO
 IYzGKIpl
 CCYICaydYGbehhXXDKF/mEc4KXVjcU+GjeEa8r0BGAeGyy81ofm59z6+4eusTn5UXUh20YnhlSTy+6mX6CwVeCKHf9ECoe2ycKSc/b5Mk+CM70Y6XLyUC4aFWzbsF3GqWDMlB/Y+BUheJ66+CX5pEVEFbmSC0p4kfKX2wkyoVQOjsEd7rnQ19kEq5N8SLfjpw+4RkmaIT+fwNVdbDhDdD5Bj7diZppFDp97z+tiV0DA5e+1e0md7dOH1i6sr9kLehJw1N0DrPqNoV2zW+LgR2JWgWyEO9GxlXifSPNwMu3GbHFVfOv5IytWqmoVBjPfdhhrP49xLAk9xTMd5kVzsBPWL1C1r2ohhjeKHjEZAiu5BypauFhz7fX0lT//1Veli5aSEBHF09Kj6J3TgECNnVvrh3ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025, Joshua Hahn wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..77e7d9a5f149 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2561,10 +2561,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>   * Called from the vmstat counter updater to decay the PCP high.
>   * Return whether there are addition works to do.
>   */
> -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
>  {
>  	int high_min, to_drain, batch;
> -	int todo = 0;
> +	bool todo;

	todo = false

is needed here.


