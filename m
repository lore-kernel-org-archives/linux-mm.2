Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633A6CDB462
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91758E0003; Thu, 13 Nov 2025 18:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A691D8E0002; Thu, 13 Nov 2025 18:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EAE8E0003; Thu, 13 Nov 2025 18:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 873198E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:08:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB68856B5B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:15 +0000 (UTC)
X-FDA: 84107124150.30.996DB53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2CA4E40012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2V0F07x9;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763075294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz6/SZauUBbNlBd3RH1toKaC8fR1t1d6HANf/8zakIQ=;
	b=Kd5TEit2OcWnzA9+A0hJZKKqTAl0fxfEvkZs7CdPLq0YCNshys4wTS56z/AGi0xsieCL7Z
	QaMJSwU8bv5MgattKDTNhxXDXvpEThIGevMiYOhgQMJdEtY522zzwCJP1FRHWmIqfwD0+l
	hcmurXGzwr7KqzewdzdX9WFRrp9bdk8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2V0F07x9;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763075294; a=rsa-sha256;
	cv=none;
	b=F6ValPWffC8+bFrTaaFl65ujwMCTx1bROxSyfHPw2zuKuBj396H0lxQqSpqK9QH7zq2qb1
	RVeaBV9FkEKxHWbUYpYHU79eVOT3elBAwAxqDDzPcF8MW4IbVb5ssWk+y7Vnvv6CwfDxCX
	Pe40J0ZzvH4KuJh02cFgqkBiCfwF2g0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEF2E44138;
	Thu, 13 Nov 2025 23:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BBCC4CEF7;
	Thu, 13 Nov 2025 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763075292;
	bh=2wvqa/HMit8pu0w6FTlokZJLz41y4povJ4/y0QBe68k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2V0F07x99YAiF85Sx7V1XWStJGYjslzh/mevzVy07rE/VuwVdP2ufpoJPqaCRs6Bk
	 EN1xQs77scGH//E4rc4vilieGQQUwW44aylFuMIPg20ze2nBtAe21fLQKQpDoPL5Sh
	 JXD/31O+MxpDt1neiBxsZiTtccuDP2TnCwhvKE60=
Date: Thu, 13 Nov 2025 15:08:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, Zi Yan
 <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Matthew Brost
 <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
Message-Id: <20251113150811.081a6dbdcca8b5c474d6e399@linux-foundation.org>
In-Reply-To: <5092cfb0-ad25-40ff-9a07-3de86d37665f@nvidia.com>
References: <20251113051352.1753714-1-balbirs@nvidia.com>
	<ed523668-92a3-4eaa-a999-4fb7a43e197d@lucifer.local>
	<dd1da795-d37a-47d2-87f5-50853ba43519@kernel.org>
	<5092cfb0-ad25-40ff-9a07-3de86d37665f@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CA4E40012
X-Stat-Signature: oshdaowte1qtpa3ydjpci7zzcm98nxei
X-Rspam-User: 
X-HE-Tag: 1763075294-975554
X-HE-Meta: U2FsdGVkX19UEi2eGxTnm0gf+NWG8CYWw3cZP6rVf4Oxx9xfYWOE1OxWQooXeTbMtiZI4aD2sDsoqDZZGA/ogk6klhgVSM0ctamkCA77A3DO5/pOYJnDNqB4bw4WI5DAQHXJxiia3tDLs/MTgjHQluYlSUsIisqqbk31t+hAj90ygA9nWM2lH+6veCwKMOx2sxR9+5p/TTgKwRY4pbm2BmiH7GHcl/9vWqgOiihUKs4I26bSnhDq+EFPmdSYdEKEvb/P83//yxXqtdkut8p9+kDofHCqtqCkrkf8tuLayFl1Z+quRCcgPe+9s4hNSKvNTvhDPQdASxyGXFgTqDxv9/vA+JrFlbpD2/t/9w2ZZeoFuMhN7ZzNEoT0PzMMCpDpOKQ6tyBBIdRnCs263/oD1qJC7gF0oGfML7ZiF3Uq1Xwmka2bbmrY6Ydbat8kmwi/fhImFaf2BZv79Qk0PopC+8eOPfZInGabI8mnnUv9tmszgizr7F7XKLtOsxTZVqX+3h5+REFE9pNVmDwz0VFKJPPsQIiKkROh4u+2eCkCP8sHAwcC2Iiku/vSI+4CnpYi0N4ffN8w5tqtOVtSTV2tIaGjEmbT0ayDUtTR7yxTyyIcrGbgPiG1MN+GKcmoV94uNRWQmS4iJGkCbuRwYoDpLRokWs2DwYqAMPtZZeGwPcgZR+1tivGRjFPrtz56uCrXn3UTqzNXkr3hyLW/0bg22ZVGY6ye5iwk6ZG53Xu5aZ6QWf/70k/+7vj9kjKnn4i5c6/XEYprW9EgnUZXdWU8fdpWrzwmODsoVoJPzWiIT1+o9+Ft14vgrAjd90P1X4xZUqrflHj5f+NJIJ4aY5sYZCTp8tlEHd4JYHLDrW7SXXEvrLDyZXFNs6UFyRijHvYOo1kQG4CFGmS2vn0/XE/oEFO1NmkAH4dPFWiUe7vRb2P/5QbYUfLwq9b9rY6PeHpnaIKhExCTF1galyS8YuQ
 KYckiCrz
 p4HHlaTjyooWwdt4iylWjaBnggrylYRNNVS/5r5jy2r+NanSwVJmJGlF4CxX1LD1UwrXdNQnhtWeU5paKlAcACMsRdHbXjp9oikke4g3soiLd0q9aESe86tHRQrp5IDVP5pjkLsporSlDswFUO8PTugN2GDTWZ28g2iqjZ4hqsjgeTt8dQm77H3fb2G0cAEz70LPAK01yQDOjYP7YXZ8F+G9YeOUY2it5UUKipdtKsnClq3HGRMY+sK7CdtfI4tkKREJZ56L4BMnJKgjxwKqjOXpbtgODp743xh55xy67ml1IxRYkpNHhxvmlash4AR0rHffOQ7W9f9BLlUNQK4ax5NMwXsOVxEug7VdgXf5qEi3jKFxC8S70xmbIiRu+jvU440iCleUUVF0C34U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 07:55:29 +1100 Balbir Singh <balbirs@nvidia.com> wrote:

> >> THe logic LGTM but we don't want to have a bisect hazard here by having the bug
> >> introduced earlier then resolved here.
> > 
> > Exactly.
> > 
> 
> The hazard is a VM_WARN_ON() that checks for is_migration_entry() in the
> call to softleaf_is_migration_young(). I am happy to go down that path,
> let me send out the fixups, it felt weird to break the rebase, but I
> am sure Andrew has a better way of dealing with this stuff.

Yes, please tell us which patch introduced the issue then send a fix
for that patch.  We can figure out the softleaf changes later.  (Which
this patch provides anyway).

Also, confusing that the changelog says "The softleaf changes exposed a
BUG in remove_rmap_pmd()" but it's remove_migration_pmd() that gets
altered.  Please expand and clarify?

