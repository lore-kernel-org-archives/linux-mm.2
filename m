Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED196606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YszLrDm7
Received: by kanga.kvack.org (Postfix)
	id DC89F6B00EF; Wed,  4 Nov 2026 08:12:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D786E6B05B1; Wed,  4 Nov 2026 08:12:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66F96B05B3; Wed,  4 Nov 2026 08:12:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75786B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:12:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4535FA838B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:12:34 +0000 (UTC)
X-FDA: 85397475828.24.E7BE5E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 940D318000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:12:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YszLrDm7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igfYjZBC1z7oz2tB7LOGKxebDo1zSqF72VL8oFRUUWs=;
	b=7Z/vMlVqOhKYaOCYXNJYha/SCdtBKwE6pNJluyvf3hFeCCkaL8kLYf1UOYewKjByjuqF0l
	5kqeay0/gWZE9ZdJL+VX/Amh2I4IAy3mvIEFAWwZ054gN2XSggNCoWNaQB5zlV/nvasl4Z
	3su3e1eHwVOkW/spuYVuffW4NiAaZSM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797952;
	b=cb815bowa8oacBLSSUYuYT+C/tNpgV6Vdf2q4jVVFkyQfQvSBSWXkT4HtAeRzGcqDCJe8j
	Qa0tJ6i29iqULoItrnZJaBWxyTHJI/g9xZVpJKOy4NtbQ01KU3L0NCPSAPrsFg5kKgxJAT
	paqFamkvdq4golfpn+Ur9tDy5CVFOMk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YszLrDm7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C01A6022E;
	Wed,  4 Nov 2026 13:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EFD1F000C1;
	Wed,  4 Nov 2026 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797951;
	bh=igfYjZBC1z7oz2tB7LOGKxebDo1zSqF72VL8oFRUUWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YszLrDm7E5X0ADtQEhQGrD8z6v6psWNerL88xMg8+OZgSubLYs+KtG+zHHUvooDMn
	 fDKL3vykaKW73ZG1MvhZXoYqBdoQN5Hyh1pkcN2rU/3ea6OrS7zJNnUTcsYV48Kd8T
	 a5iAa4my1Ew1KgtPhAnFG1sBdglz05Su+rkKtDaaXO7pXob0H/+FQYW6eYK4qi5gew
	 q070O9r7GI852zLWju7c6fFaH6Oi7jWjy/9r4/psGpCdtSjImn9MgDndpN6Tjxeikk
	 d4I6KL3r5dCjxaLbLtWxp+MuVm3jvoZveGlXI5uKgL2Ft6bnDsb3iPWPREl7JdRj9v
	 eTiX1I3yQB1xA==
Date: Wed, 4 Nov 2026 14:12:25 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/12] mm: hugetlb_vmemmap: make vmemmap restoration
 folio-oriented
Message-ID: <ausvOSLonALVM62h@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-11-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-11-songmuchun@bytedance.com>
X-Stat-Signature: h1515paud9cpuf74bs7upqk6errzqbio
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 940D318000F
X-HE-Tag: 1793797952-117473
X-HE-Meta: U2FsdGVkX1+trIQEVNdjb3ScX1RcGZcrdIOw/seH/q6YQ9MdRC7h0ml4+3DTtiVEQW3/v5K3DA3KJ/F4/qSn+UA2INx3HGWhzgToHBq82+vru0YiMD6eyNi5/XZR8fBI32aADLEMaP/W6/jj44AxluYUmrmG3ZWu9lsE7W/A8R9L4v6lleqfXPYurNEIENVKXjVRC2fwB4rDserHGsdHrNHoau9h9Xqypn8S2to5/9MvAvMUMwj+YGcqK3SZto0aYcTgwSMv8F2YXPZhPDG+bL8HYFyNpgS+6o3WeaUNtxcRLKyMMbeKR9dpTWsdD5TvdEXMidZmEjqno4rApQZNOhVXfDu/FL8OxkeQEFwX1d+GFLxhalx/Kw1FcENufFO7Na6m5ShSiSVzd+BLN1vW0DmzMHMZTuZpVn37Uhe+r3K0SICeUzgtC6ohm3Ljmu9rVMlnh0CyANJpHKJ+LRJAmuI6KQfNlxqkun4wHPEWu6bZl3I+FZuaEH3JiyXXXCCvfSmkCatsv3fvMWjpKUORXrUJ1Taq3LYh6X14AFomji/qGW+UMK9yX2jjBWGcoLIsAPsRLeLJ/XtB25KIsFzFqNaaAf+vkAjPVx9Jx6b/N7V2BAbrMz7QJieni04fZ2SqLYhhNBYG4P4AdtLWGXDZzR56k2W2OpxepIxTrdJohI4j2nGW+AjiAu+Lmcr7phxOpHB3T6rULI8OzKjFFqs0jTEuaCk9CzM5DpxbfxbKru5mHXiEgWrL3qzkDzd2mm/PtMg2HQA5nY3j5dh9DuYmjG60tCZot95dSIBH8UxkzHunuqGKTFN0aEWMKCXWGov1knvj+rRYkvIDiEGwyNUAtacw91skADsXBz3fGDASXvxoQNHEaP5BtgCJGWVxP3pZOAeS1ltQUmt4iekKmZ3ceXnxh2EzwyyJNQ/XKQNCZBMlGmy+6vVeXfuL1fW2pX+kcezEuBky9NUe3tZy/jf
 EYBBcfSX
 8WfA3e/MGvtVsJBxgA9XcUXUQzoVPNTu6ZVDSnSTdW1oPKCT3poa+4yKOAVCbocOo1btO+AOY074hRAx8FnR1ZZ7j3ED/++WkK1S58RMGy828+TEA4tqeOoGHrNE/NerJkGPyek/nRd0PC0BkRZ3oA2N19VVilpOmtOg4JVwnh5ppnEjKHib8aizh+P08NKPTgOgysqcbrZoTZtkWMusexra/4LUZnbI1Ms4WyC6xgdTqQy9qWWEuc6ekagKOnZgTHe1kW2dEsLrFwbPjsH+chP9atqhbqVyyZezHXCGrE9HGybYtg8bUdFOQMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:08AM +0800, Muchun Song wrote:
> Like optimization, vmemmap restoration operates on one folio at a time,
> but the current interface exposes a raw address range and requires the
> HugeTLB caller to prepare part of the operation.  This splits the common
> mechanism across layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap restoration and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
> eligibility and state in the caller and gives both directions of HVO
> consistent folio-level interfaces.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

