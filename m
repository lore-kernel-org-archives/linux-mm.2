Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8D5109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198E66B0005; Wed, 25 Mar 2026 10:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170E56B0089; Wed, 25 Mar 2026 10:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADD56B008C; Wed, 25 Mar 2026 10:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F03946B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:49:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93818160777
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:49:47 +0000 (UTC)
X-FDA: 84584869614.25.DB57C80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE8C91C0014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:49:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hIvE9/sy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450186; a=rsa-sha256;
	cv=none;
	b=2xSaNvAe69+rLWZqDJtPcWg7Ph7Ou6t5wn1xfncJ+J10RQE/Jh5djkEhHOLjYhm1CRrAhe
	vYdt/vTtm9Y6folRDvani3QyxcXPuExfQ6NIz3Ruo0mHCLSmRA7CK1vKuOEQDQTB2TS9Hy
	ZnTfahBB2OsFt+kZodLodyuFLBdSziI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hIvE9/sy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdWnaW52OsF7GWkudyaJaZPtWfOFC41QjwCdtOIDjs0=;
	b=GkZ+kV6+FXr6NqczU5F7a9Hv9YVoVaLPmPMFC/d6yVPM7cCuyFnO0WDh1qi3Q8HBhWs6nf
	w//h+OWvugoTIl9SB/oFoh7Wzaa0FzJHHoxx63V5pRn7UanTBwUrnWx5KVLVKNMsoDf4Mb
	RoHxYkNiJdyjkYs20Vk21Aw7WJ+//gk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 451B8600AC;
	Wed, 25 Mar 2026 14:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381DCC4CEF7;
	Wed, 25 Mar 2026 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450185;
	bh=vdWnaW52OsF7GWkudyaJaZPtWfOFC41QjwCdtOIDjs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hIvE9/sy1vmKBSUAPVv4Qy9n2m0p+NOPQ8XGAZUYs6NMNe3LUc5bgbq08wWIM3FNS
	 kMH63dXBn5+ImPB59lsIqBesbous6WDSgw/0VUitiZsHOlb9SbA6fufyNyypBimWbA
	 DLkTep8Nqz0CgOm8NEQBuS/003Vv/s24so29PGsUFrsB57HCKngKJTm5rjESnQNCvT
	 tajAKihUY+kGVGs+PBiglNd4ccT7cqBNkBSbkL7ZL/IQwBT5Uzfaog2JTAOB7B2cOk
	 i/kfRpczYNrDRuaeQLDAYqd7nJQthNzFGOhDHXcaB4qYNcsgmzjUf2T7W3+g2GhmaV
	 Q2MMe06tMBk3g==
Date: Wed, 25 Mar 2026 14:49:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 2/5] mm: introduce is_pmd_order helper
Message-ID: <74104214-5759-451d-9279-37498918ec3e@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-3-npache@redhat.com>
 <eed250c8-7a31-4ace-b5e2-9f2898599ec8@lucifer.local>
 <20260325074516.46bfcf772d5eb4482d7df36d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325074516.46bfcf772d5eb4482d7df36d@linux-foundation.org>
X-Rspamd-Queue-Id: EE8C91C0014
X-Stat-Signature: aubsu896uy8edk9x4x8snefqoyu8sm7f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774450185-101959
X-HE-Meta: U2FsdGVkX1/ZsDT0s8O6aDLfXdOBGP7hauABQdGiIMvevACe7Q9KA5erPuYtX1GDjwvpWVZpW08Gq9UfSGWCrQCgf0VVjK0wYVnW7m1LY0oYEqejHogoKyMTkt10CLRS9fE0/dK4kzqPvw8GahvelgEP3174jWu/25WJ8ud//2qewAeOfMSkWyN7XMg/ur1hQTAS1ULJeGOoeBloFk1yfP4G34+wuTnW4J5I8rGCnokPhicLCCsD1rixp5xB7BgU/E283NyUg+37/M6617QhLSe7lAXic0qXuwS66QKgZIFQgY9i5HRDoHhEgcx1mp4F/J8JboQ/a4GajSNdU+xkq0qnx6zLo2hma777MHhaF+B+tSgoKx+GkVp9nt0Ae1DC5tbLG0vxsck9ytsLVwd0jUAV/YwcUk1igpC2juwudamYtAOo0qLxSJAAHGQoJkMG79DBy37Hr6eu49FElMVjwqr+T6pw9B6K9cGBmfnDx0dqQU+Ad9aYvrB5PK9iAcrEDhLkEjfJUC1033tpCsiowbKdm9gWxFfRNppeSKR4pJgoPLaga/Il5xp5xJHAkhtCnOvsL2oGzzsLT+45lQvAmmzTXu0tJBNKhEQhD98sMZMEOyoqrcK/pKQBEZrmyY0nKy3sXnBb8/4uebXPnazXXaOhhvYwQLgm4UVpsjhjQi2g8u40q3jO0zQ+7smi15bIU7bT5cyM2eI1Op15u4CTIUM7XzV7ONO9Ajw+hWDbDT+TT8ciRUf+4v2FZmWHuEe6AeO+zzaV5GWADQ0Zc9BKmbIJniWF0EkLo/5LK8POvRQDgHC11B3xhx9dkUGl23Tz8fOrwS2VUDTGYTMetyaEvqPe6rxkdb5HTdJocmG0M2ChMKeGGubMQ/HUT/ORUhkyPt8Br3ROjFdseqlcfQepqlfC7PaCY1YK/cM4YjqYcbPfBjdWyiFAk/PwhnGSPvZsCLmpFOeOQg5Jkm8vx7I
 l+O74Q/G
 XH6tSqVJdJCMcmmIUfdVqv7fX3pdgIo0/sA1trbiNRExOzIBjxQSk6AkZWm9X0DjHEyON3O7+g5iuDBbgvHi/xTnm7TjRudRlWnZz580Ar8Y3IZpDvSie0PqsuMTlFhZK0SfwKkgv4IpTYv+E6AUTViQ2bLTvJDc1jfJbIMDcfthBFGGy4pGygilk1qqxGM+Eqcr5vcTsIrZgiGtkDbbu+Cyj+zB0L9Cbmuyqs7K9ilBwDe2dCMtDWkXfgrUasDIFKsXlnNP4zoInO/wdlwuSd8m6GqCa0XxTHC50syrdwoRtitwltac+eJdXzu8gfazg+VBkIEpdcBepre0RVX8w466DYIlg3fXDFPeewN07Y6yIv3rMmSfB0yhNqNBx6P6wjQvAt4vLx5nIfmHVRQNX5Yy10ODed4xM5QdKB1z7yO6Ieg09bh6L2+kQaDbZY2fo99jLMmbUOZ6qhQ0Es28+vmvNYFSetk1AvkKu9YjVzaTr65PWwSeyc5ng3xtGIczgTiVB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 07:45:16AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 12:11:43 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Mar 25, 2026 at 05:40:19AM -0600, Nico Pache wrote:
> > > In order to add mTHP support to khugepaged, we will often be checking if a
> > > given order is (or is not) a PMD order. Some places in the kernel already
> > > use this check, so lets create a simple helper function to keep the code
> > > clean and readable.
> > >
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Nit, but could we please update both to:
> >
> > Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> hp2:/usr/src/25> grep lorenzo.stoakes@oracle.com patches/*.patch|wc -l
> 105
>
> Please lmk if you'd prefer that I go through these and update the email
> address.

That'd be useful thanks.

It's not a huge big deal, but trying to gently nudge the transition forwards a
bit...

Cheers, Lorenzo

