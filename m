Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97CF9C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894B36B0204; Thu, 13 Aug 2026 04:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8455F6B0205; Thu, 13 Aug 2026 04:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784B86B0207; Thu, 13 Aug 2026 04:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50CEC6B0204
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:28:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF82B1C16A1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:45 +0000 (UTC)
X-FDA: 85095570210.27.3F78408
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E3F740004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMs9RZNC;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIuTH63rkuXcFm6et2f7wSWkhuN5eE2vt+vtDQrJL4s=;
	b=piIGEhOxDZZhPdBVFGaM6DQSyUP45bZmdnXEpGWKxECrQV3ZcexIA8kvh6QcG0u3E/I1CL
	5pCCrQs/5sAz3YiR18GpH9giNqaZtsZlu99WFllgJgUDZMknoAg1FqTgm8qmPluaBdwL7y
	8mjLs0amyV49qkF2WfB39TYS/aAEyeA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMs9RZNC;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609724;
	b=s34KBlw0PTE9RRmw2pvDvrpXah9fAai5ZcDzQHTqqKppokyHg2SR/zW51vEyTXxhaQuItT
	qdDmPB79UgTk1vPbhf7kpX3oJkse1ZhtPwB+yWtmO0O51Iz/Y79BHGE+GdwE6QMMo7LaiS
	IXfY6FHdMUfhk8WndnW82Ot511CQNIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D51B431FF;
	Thu, 13 Aug 2026 08:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34981F000E9;
	Thu, 13 Aug 2026 08:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786609722;
	bh=uIuTH63rkuXcFm6et2f7wSWkhuN5eE2vt+vtDQrJL4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bMs9RZNCuFCGpxMnuN/GlcJjkXynXrV0LclIUQD6JvPK5QrSyTBQJTqUF7+TVW6FO
	 1K6z3hMAOA099qVd5GR6tSZjx8FS/X+8lBZ0/AKAYK7ucrziX4+PuEoE80THntxuv/
	 TWHocyxmoUw4hOODVAZGbvUGeKk/JYZgzhdD45h8/FyxUgYRW7m/BKkgL54bPfKj6u
	 EfPE8kCQlMS8f7unbRmZMB3/eGv1hSRzv8p2/iyQRpRNe+A6xO/ZBBBYt2GyLBO/dI
	 GaO558pnhFY4zgrgplFktxr/jxQNTn7H5CDgLwqFJuRiUyz6PEVLR6PTunViHie0Jm
	 KQGFkf8cvD1DA==
Date: Thu, 13 Aug 2026 09:28:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>, linux-mm@kvack.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <an2AEAE8gXAHPY19@lucifer>
References: <anS-vK1MaC8sWoMK@fedora>
 <20260807000938.79851-1-sj@kernel.org>
 <an0rQM7ZwWnB0nVD@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an0rQM7ZwWnB0nVD@fedora>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E3F740004
X-Stat-Signature: mwxkiszaajgxempj9grce5qxzyhod5ha
X-Rspam-User: 
X-HE-Tag: 1786609723-728172
X-HE-Meta: U2FsdGVkX1+gDL6pNs42DESs4Smm83FLGCyMwiGwLdFp16ho83cnOLTeqFeTW/1JmZf+EDBkDC9DXuM9GJnAru+SXv8YSn0hnd7wsCU3G0JpCIAQf6kvVSHv2SIiozNL6oCXE+x8uK4tjyt4AK12U6Z9/I6tQLzax61a0tGdd8gWI9UJG+D9NMh+dCHKUFM+osDJQ1HhWyk6PkB/FElQXG9QTcxY/lh1Tf8ohqUCwFQWlF5gHANPYBLWLQNaqDPN+rINpi6OxNXAP6QfHAUIi2U4OEDtHWdltrwnVZYrXLsKi3bl+oRRBAQVlWF+3J7AZMHjBvYRBIvJXr7vJPMEhxbaH/+HNzgOV4ySrvIxm5EN9f3yph6Q/SCMxkFvJMKJlTVOaipHSxuEwoLbPlQCRR/TT5M9m7fMU0jcS4oaZxfPnoG4fF4pS1uhBvMqrHFg131khGcoFDeMbvLq2AmPRB7zQRZQ4tJXAAgqALj0Jb8y33at5zNBrQeRfUmhrm7j1eP/BocJh1f3HEsHGKmkXM8DmKSVzNKtxCnMxxlBO6E31eYHOF9tA+5QyjCQndD7cDh8+GGQeJhyHLlqnqWOc5TDJHzgI+M2FJLWKY7zK8Tl6dlHDGoR/o2WQIdQt/DI02iDxCrSk5RU53pMzPgJa/8eJznLXq1SAGM/D4v2UAHvYj0BfDbJlrDGPQn99I9ad9txY1QDwLfkjZXhXeOIw5q4qGZwrg3B5ftyMxXoigLs/uRMw7LsOEFGrYF3i0jiaC8MBlWDwUj9bBtxP5RtqzAU3jk6ANKQ+MLSpQHL6B7/cGfzS+uB+uX6u5v5lwMON9tLCt1uPMRHqTHAObC7/kZdAEKHFiPJSBSLTeJc/Hu/+4qQsu8z61KHUfpyHYl//A3xr1fyve2qElQ9WgKFkR+XWS9Z7tUulNdRQ3sAot2bAeW5+Jic1vhXtR+J5lquYMkz9/svHDSMSWdp8xC
 oeWW9709
 FBqW+zXRE7zpa7NYLkFc+hRBZj/ikpgCOoZzSoLGepKGHeb5a5wY6X6Jct+WdbmqV0QUuEEozK/KtuFa3wXhOipcgyh4GnTVcARZOldUj82oD8zgWewjch8mpPjWPoG9t/+4lUVPlJHZrd6IPZo2x1hyoYNm2bEFk0xAtfSabY5aErk1TdTkEh58KBno7QohUlBehaLSLZxzFfL1XVdWRl3WJ/cDf/ROA54XQzE0ejaK93U2D/62mWt8jK560+mHSh3ZERLGDPNCscgpzPAWiTk+3urJ3xn0TBCnMK0mqdCuf9i6b3E0dxji+VOBLadBrk3ObiRFo+b+orWfcO7zMYgMMKVQK1PQlgeHuT2ga6895NgvARxU/HAXafUiNqKPevLDyFswUf0xC74z6D/zvZGcpWnWaEq6neZsoPnDIj4Hlf/RRlGD6ODFjKzM3iO81Q5DfUe6JAuL0kno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 10:26:08PM -0400, Gregory Price wrote:
> On Thu, Aug 06, 2026 at 05:09:37PM -0700, SJ Park wrote:
> > On Thu, 6 Aug 2026 12:05:00 -0500 Gregory Price <gourry@gourry.net> wrote:
> >
> > > On Thu, Aug 06, 2026 at 02:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > On Tue, Jul 28, 2026 at 03:47:11PM -0400, Gregory Price wrote:
> > > > > All DAMON physical- and virtual-address operations obtain their folios
> > > > > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > > > > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > > > > this is inconsistent with other callers in mm/ which test explicitly.
> > > > >
> > > > > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > > > > so the guarantee lives in one place and covers every caller uniformly,
> > > > > consistent with other mm walkers that reject zone device folios.
> > > > >
> > > > > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > > >
> > > > Thanks, nice to make it explicit!
> > > >
> > > > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > >
> > >
> > > SJ Asked me to drop it,
> >
> > I didn't asked you to drop this.  I asked your thought about revisioning this
> > for my concern.  And you replied [1] you can drop this.
> >
>
> Sorry I didn't mean to imply you pushed for one side or another, just
> that the feedback you gave about not wanting dead code is reason enough
> to drop it.
>
> I will probably just go ahead and drop it unless Lorenzo thinks the
> patch is worth keeping.  In my next private node iteration, it ends up
> back in anyway - so we get a two for one without the intermediate patch.

Yeah it's damon code so if SJ isn't happy let's drop it for now and we can
revisit later!

>
> ~Gregory

--
Cheers, Lorenzo

