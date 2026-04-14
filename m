Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268F3F9D0CB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D74F6B0088; Tue, 14 Apr 2026 08:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5616A6B008A; Tue, 14 Apr 2026 08:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4286E6B0092; Tue, 14 Apr 2026 08:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA156B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:11:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D340C16059A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:11:33 +0000 (UTC)
X-FDA: 84657046866.09.B9B4818
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A486140018
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:11:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XpFmzQXd;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776168692; a=rsa-sha256;
	cv=none;
	b=yAkWy8v8CwTMZvsl68LaJMedFCgRbZiBEZ0v3lvDLtToIjJjnYYNODeAmvwxapAcdXWrzs
	/1oe4CgmYIsZhyZDX87BAjZXqcISrc6Upgbu78wdzcwns82oLq1ZfasY6aBwi5d/omigqH
	u4lDEML0CNKPPYoN737Hyn01AIOlidU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776168692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUc1mhW49UDDmNPMBoYJ4cwl/kltxfh7iuVcRqAuDOc=;
	b=UTkzyqJt/E2VmLl0Ua10LN4VNUsc9XqmCd8Qo3jZ1NO2ihmB7F99C70MrY/qfb7aor9Ff9
	Z+MT1f+3KJWrOkvK5qN6viquGHaJ6TkVprW4uwX27lUkUzYk9EyzH0vWDgyWvQRKuuWuaX
	znyvH/ef5c2LdDSENZTciyzFtJLm7Q8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XpFmzQXd;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D94CD4426B;
	Tue, 14 Apr 2026 12:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C3CC19425;
	Tue, 14 Apr 2026 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776168690;
	bh=3AMLjyUGD+ddYpwxDxBklxSX3OdAWMZ2H9ltEQTzFd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XpFmzQXdTU+txPAX4O4mPOREpMLZXa2w4P12fq4IhcB5mwsA0ApNrgCrMyMV3Ghvg
	 7bM/f5t1MNAaSxmSf73TOvpGHpnM+ZSwEkkTwRnzW5TP8IHRUDI7m2BLwIIXZwS76R
	 6iGW+4oHwTwsVnq+eoOq2cxVDAHBG5EqJrP0pEzTgGms84mFox2aIO+tu6tdMspLOo
	 rO46EWeynG+gAazL0aQjWVBniaZusPsVLFr470i2gKKVTzfUIOFizbd+uDpogU7kaO
	 pFKP+x0YKmytshTGzYIS1dYzUWNboabP4Vi5XidMripAasArOBdjmneSOEWc/cyF5B
	 KEyfeqVVOopTQ==
Date: Tue, 14 Apr 2026 15:11:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/sparse: Remove sparse buffer pre-allocation
 mechanism
Message-ID: <ad4u64rfWAy19kup@kernel.org>
References: <20260410092419.2446420-1-songmuchun@bytedance.com>
 <abf05960-87e7-4f2d-9a10-d6ec419eb2f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abf05960-87e7-4f2d-9a10-d6ec419eb2f6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A486140018
X-Stat-Signature: frf8u56xcj9dmucs5tdrs3t96aoirkez
X-HE-Tag: 1776168691-319476
X-HE-Meta: U2FsdGVkX19Axoc0ONHk8tr/bBnt2AeEdD33SwTZZwIYAFmZD9DnhTO6BjSUYiMw4hdQCI/HxxpDY+dRaAvdbaW9LBA3cMEAj+yZtm5MhMwSpV2JMAlvLql9cN2PDxVfBjz1GRKc43doTM2YqxA1MQKKsak0kXhxCOCk+R6SVgizaVzdqGC640LSlwR+PYmVoVzcMKQSUYyAHj60rUm5Wx5o7ODleMKHypYb17Y+7VE1uATXMzjr8XyAtBwjYO8p6gPVs6PjVQ3QPD7nMdo3BFpo9cCOCcjgQESUnqlip/NyKQOeKcZCwSXOTvs6SpRcX1pjRl0vzc1X04O69vIAGUanIxjc9MbrmCGVBfltN3AobYT/SwNhL8CLFR6dgSOf0c6yT1kimE/NWQECYuJMiMvnpQgPZ6viZcdrzz2moS000zdL9xZMpn7JFq21Y5NezmXHo0yEYembxjp6R43S15qu+33S28FUIXuoS85FFsd3XiCimvq7XBKJov6HhYsYWxP5ITd8H09TwX4SIyY6NQnFxfaP6dOnmlGT8gJYox8MFZpTJIs75EpRQxmAtSmvzNgZNwiFFhs9LgYqz24zerw2z9aoVnMozYDRkM/tdJa15C3Gly4i8LXSiRNlvuR7JyeGZkN9/PXXs5HgC7ZwXcM6+LsruZ6eb7kcK83ewpVeaJIBkIvQmN09a+t4wI5ESN12v34H4xTxE0TC1W1E/o8D/UvHQZuWuobc2zlnMPS9jpk9B4/d5ztUZ0brd2IC4B22W1lLGLVou2y4C1dNy5OdH1TS7TDQwPhJsyCzVUgggsgJ7KpyYkydxPvxMCKC8z4CplAAtOYtp4SdGy/ZUBqDC4v1jmwFk6YigI3QNO5UcDEGGMX4A2VFWun27gyfK6DujLIwSJdf3iFgOALf3GbZ3zugkKj1cyUBshzXgI+UK0/hDWSL5k9kOSDWfDSebY7DLmbO+a5OzU6RIW6
 7EZSbvuO
 5+6QUM3TyrQPSj0KtcIZBTqIreMILRryuZ0j+AoP1YdBz6oqdhrVrxMqAVWSz2Nco8WcRux3gG362Ja0KLi+U2LYABrL6MYm2dFEdq8c0m2zDAdHGiook5ArkfS6aTSLH7WdZQhHheeXnbINMDm1SLoEoDKaTPoyTubiQC45TeW/Zy4SCAr6lxUU1+O8Qr0CPV5eN/ITDxTnYjZFl80+o4zy62LiDC47Y8oK9oyyhvRnsf0ghk1rWT/JDDVkxIpJuKdWw01HjxFx3oz8g/VGK8Kk3Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 09:02:43PM +0200, David Hildenbrand (Arm) wrote:
> > -
> > -void * __meminit sparse_buffer_alloc(unsigned long size)
> > -{
> > -	void *ptr = NULL;
> > -
> > -	if (sparsemap_buf) {
> > -		ptr = (void *) roundup((unsigned long)sparsemap_buf, size);
> > -		if (ptr + size > sparsemap_buf_end)
> > -			ptr = NULL;
> > -		else {
> > -			/* Free redundant aligned space */
> > -			if ((unsigned long)(ptr - sparsemap_buf) > 0)
> > -				sparse_buffer_free((unsigned long)(ptr - sparsemap_buf));
> > -			sparsemap_buf = ptr + size;
> 
> This code implied, that we would usually get contiguous memory sections
> (on the same node) to have contiguous PFNs in the SPARSE !VMEMMAP case.
> That will no longer be the case (reliably).
> 
> The code must be prepared to handle that, so I guess that is fine. And
> we don't care that much about SPARSE !VMEMMAP.

I've started to hunt them down ;-P 

https://lore.kernel.org/all/20260413104649.852228-1-rppt@kernel.org/
 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

