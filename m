Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573AEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A1A6B00AB; Wed,  1 Jul 2026 14:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1CA6B00AC; Wed,  1 Jul 2026 14:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9A66B00AD; Wed,  1 Jul 2026 14:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2AE06B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:27:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 782FBA0489
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:27:35 +0000 (UTC)
X-FDA: 84941040870.16.FC1210A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BAA6E4000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:27:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwpAa3vH;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782930453;
	b=E+LIfRaOzbxl/wF9+zeJGWWfB98H38lquAVOXRmeQPUHpfNYLshQx9dWH+Ofh/WjrKevRJ
	+0PCB7HgHOYXDEDxsS2hZ+RXUil3RPOGIbUxCaWiFwg8fsaVZMShznC1IZOW0OcGacs/U0
	FKlk9fLli9IhGWPGhwWJU+q8fv93nFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782930453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGXu1Vzl4xthxtkNrFpmWrNk13elTZgSxWyMFFibyPk=;
	b=WW2+wc/5giF0VSOtXd7K1390oiLsGRrHv5w0dGKail1STcX4lkvZWjABNfb8RhWYC95Uru
	35j38mD4khLMUrfLlmiRrLwSI5dPgQICW/nurR3ZzXR/uXWP+5lT3NP2hBBLReKbHWDuHh
	csk0IpctKYhwJ5iSIY3Gl9bacAfEUTo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwpAa3vH;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F5A66001D;
	Wed,  1 Jul 2026 18:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B790C1F000E9;
	Wed,  1 Jul 2026 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782930453;
	bh=dGXu1Vzl4xthxtkNrFpmWrNk13elTZgSxWyMFFibyPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bwpAa3vHnF+SRbF4G7brgM/meulD9nVjCUoRBiZBXUear2bUo/JMaWwxjqAr8WbUw
	 U37DZLDveg07yNDfBpQvP8RRWlWkZmKKcbwbEOzXWX+2G6UA0YEPVIYNur/kL6/Bmn
	 pgarjpJs8aglMlQJ55xiGeqQ9R1d9JHX625gLbGqXRFZWna/LrwGpxCYBYv65kdgPT
	 WR0JjM+e7cHVJf6zDZepPcJofv8XIOXneLqtfhsjKgoUNrW2NcVXuY5h32N7Jm9VhE
	 Ek2l3ZxZ0J13ZXe6v/CwMxMp6AeOFoRfJ/nWI8iENlJ5dDT9CuklMXcwuCLVyXGbA+
	 BMtLCMKwTmPxg==
Message-ID: <40f47be9-76dc-40b5-81ff-c0f3ac32dffe@kernel.org>
Date: Wed, 1 Jul 2026 20:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT
 documentation
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701182102.1586784-1-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260701182102.1586784-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: misknr3jh3x1mdun6hipw4iz75bwadig
X-Rspamd-Queue-Id: BAA6E4000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782930453-294877
X-HE-Meta: U2FsdGVkX1+YknG68zopO1peJNYqg85XAjqoG/ae2WL/n0g+ncNu35jhZRoGaCWQQJtM8xY0pv3Co3cPNoYlNdJLd+aEO+2fX4npf+TKV27Tnj7fsIiGpHYSKzZaMO2zf9fEUW1IEP8K5wy9vLbWCFKxi/QnjX24x7BOEcjnigRItBt5RprSYjXH93YQNkW4nsi9ETdLmRWSBoI7dR6xboIJo9d4Ablhb1+qeMI9gHqzhM100iApGKazohX4AxtyArjzKnfLtnLZungR//cJJyKCE9yP0dmA6y5WcgSIvTP7iQb8RaBWKJD7dYSwHfK0rLTRX/vgELpPs8TLEfff42DVudNJi7msIIiZl4ptZ33ii5HsyxuNaQwgabM3zcUMXdOdOCwLwuv9uvJkqGV9v94do7AL884sgkOUwMUqwXcUQYN8aS2F2IRjL0zx+bZ2FLAx3yY9tNxREKsQl5lEMTWG9ZqJ1+7/IrmWuzwjDayq/xapIfoZGsl5E1dDfVscy0y+GB9DcUJwg21MF8Lt0okzQ7a/kGM/uvpk2d98nBA56n42Q4qjuDy4MKRzfecazbZrM+H8z7yvvoprBpY/PJGFz7degQr3kQwMz6RWkJG9oOe0WbKTVIih0GQ2Ui1GOv2iJn/iCHnLcx1AtU4EUeiqL7BqSXJIVUchi78ijtkVzowl6uf5RzmBm/3auc8FBKqRrh4C3eGa2UERNf1j/u5Dzul7sPtaxfyruDWoMLI9Vc1h3gVjBXk1LZAoIYPHJr+gRFANhoiktNiKMhSHxDAf/09x7fFqC2LERzOdFCmnIeN6Q5s/ozpybB44D14FpYHFCFdCoHs7V9z8Pa99fdMqz19mlNA+pJ3AEGSS29VuomxVSjPH//E1DR5/oz0kPcmfXobYD1HPMeMAwkdwwzox+8zPhvrjlkW7sv7VrwbxfkPWEJEc1/GXBmkicl5H1U7qDUMz/IPv++yucLJ
 CD1Iv0/M
 XDtzhNEg5F/ByQpUQWkoW2hiAb+HT+pVl0fu7MgKMn6e9OLRnu5vXqc8lcqarsppPLSmXnO9yTyinPkf+g6yGwtVlK8D7iUZSmg9OQr/fhnqsCEMRT4ltXN5Y7518+i6z0Mrwmuj6+6bjHFOKfwTdeIRoT2rMBxZwPjLjowzF1ouiguPwvxSJBsm//FQSFoXRPpt0vAkSWyEl3BNaMgv0KwK/Z/xwnV093kTBgMew+ZRZjfeOQVPiB2S4UPpern3eU3qvIjwfYVMZ0KQURaygE+13QAOfRKRujOJlQxT16NDZDWOgJN3lkAl33UzkaV2+JtzwDgsDGN3VyHO40eE3bGQFLsrPVcr1jAFc4a4zNfMKZQQD/+8EW+3FL9fsAOo0xjXUXlYddaU4UrWIpxDteKJ4ba9xNLri0uCOd/SXkZwUD2dD4QXsIj6zwLHxpnH4cr4x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 20:21, Johannes Weiner wrote:
> Gregory points out that these descriptions are cursed and confusing,
> considering what these flags actually do. This is mostly due to
> historic implementation choices and cgroup1 baggage. Improve the
> description of their actual effects.
> 
> Reported-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/gfp_types.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 54ca0c88bab6..463b551d12d9 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -136,7 +136,8 @@ enum {
>   * %__GFP_THISNODE forces the allocation to be satisfied from the requested
>   * node with no fallbacks or placement policy enforcements.
>   *
> - * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> + * %__GFP_ACCOUNT causes the allocation to be accounted to the active
> + * cgroup context.
>   *
>   * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
>   * mark_obj_codetag_empty() should be called upon freeing for objects allocated
> @@ -320,7 +321,7 @@ enum {
>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
>   *
>   * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
> - * accounted to kmemcg.
> + * accounted to the active cgroup context.
>   *
>   * %GFP_NOWAIT is for kernel allocations that should not stall for direct
>   * reclaim, start physical IO or use any filesystem callback.  It is very


