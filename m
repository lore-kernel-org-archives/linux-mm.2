Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EAB10F930F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1BA6B0092; Tue, 31 Mar 2026 20:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9C36B0095; Tue, 31 Mar 2026 20:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6936B0096; Tue, 31 Mar 2026 20:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5D06B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:37:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2FC913B002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:37:48 +0000 (UTC)
X-FDA: 84608124216.09.ADB3F75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49B2F18000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:37:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fZ1I4KD5;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775003867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhoM5s28MSstwLnNC/fbULJnTNZBpwem+xga1L/XPyI=;
	b=8p9jSu6W+9Lz0KIpU/NNXwD6O3xs/uri+IZgpO4BIOSFR6EkxSY+n/BpEpS64mvIyWI6cw
	vIZ9hr7vpOoaI8nTLP4FgwwGIfYEWgvZushobNMXGDT8jLChkRuOxcJPCin72G1omzMQUe
	jncLjWOrMeyf7IZ887ox63hxyDD/ceU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775003867; a=rsa-sha256;
	cv=none;
	b=75goBvfWcLNnUycPg5pvgjIK7rqOsYdnve6ebDeaSEr89QD34pfCA6pkVn3+PSm68/kcBJ
	kS7Ep2Y0MwN+uGvqHq5SKMXHtqMPueexeGCILBil1smfTPja4pzGN1G8liHzkxEi8oGAaT
	DFgxFNncW6Sqy1tACto771nlHEsFSA8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fZ1I4KD5;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F0D74358D;
	Wed,  1 Apr 2026 00:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81664C19423;
	Wed,  1 Apr 2026 00:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775003865;
	bh=EUB6KlhS067OIJFuEHObxGU9Kx1ZmJomYtU/7QHJu70=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fZ1I4KD5B4mP40k+L0qU+TUYv0CZTJLnn7ymdiXyA14u4IHTZd/YfMrguZta6ws7I
	 XsNcUdzwlhDnt9hXWsiOf1Fh2tajis4CYDisgPKtsUG7X59vItAAEOoxMiwtwLX1It
	 0Qt2JynzLTJjbeokwOj7el/IZUOvHRCacfvVV+5M=
Date: Tue, 31 Mar 2026 17:37:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Julian Braha <julianbraha@gmail.com>, vbabka@kernel.org,
 hannes@cmpxchg.org, mhocko@suse.com, surenb@google.com, rppt@kernel.org,
 Liam.Howlett@oracle.com, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
Message-Id: <20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
In-Reply-To: <bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
References: <20260331070730.33915-1-julianbraha@gmail.com>
	<bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49B2F18000E
X-Stat-Signature: 9bo85cieo3ppw6f3mz355eske56chnbj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775003867-865660
X-HE-Meta: U2FsdGVkX1+uBGoKftJ9P9BFN5RFq1QgDm+W0o/imDGEjRPHxOOMQdXxGwoH835wEfQfmGXyZEmumW4piW3qcS5oLE6J8Z04LNu6dxeGSMLbDDfq1bNAuigtoK2ZkH3pnWZJTAoa+blU3Z2BMuQGw06Gw7DyFRAoYdifFclNwfQPwP6fZuw1sr+9ngVDcYlUVsp3bNOHnZrF4Mo7VcxLbhydrEeIiHwFTpwOr5/NjXKeAIKTXzvf2SQrIJ4nioPD9iVsZiNHKFzbAi/8lqTp8Tz/3TTi5O5OS+o1g2gbHxMOKhpH6erSondCYJu+Bg4CzemmYZ1Mu+Am9XbcXWTj9Ey+p8hm59QcXLPEYayNdDImHDiWlpLiKSCd6gZRBqtvqxrke121Hn+ecM2GPkkDfpMJMXpsOQhHixKN2/zJ5tC9++9Xy91IuyVKB4CKsR0J0okL5I7vmMpu5fTVlhEVDb9gSwT2gkIhsfLyeaHjrsjMB2MRahpzfsmtWu+qhOgLWZzUKZgA0cEemkdG4ClOgAaFJ+44gbPV+zzkwfUpvGnBoZZCbqWgAdWHWdF5U9c01finkayIowUqhHFaXrRavp2uttlRNuOZqxGfQJf+5JZdBotvuz4N8eFqnoWSK1FFJPYrzm0YL21BG3NHSy8Pq9lJ0K7WHSTArU5i4Mr67YgUp6F9yt3maJLE91pP7WKCoIau46EWPSALpFn0Qd3WdofVHdF7vW9kLD9dFX3QE7tZhIgvqKUHCURQute4rpFpw6q5kdfvRqB+ohgVGYsE/yMej7HvZosdodKovb5C91pLWiH3qfufkFcK82YOb/w3cGLZ16wiiOKQXvUFNLtOr0U1wWTGdpAhPj7sLSbD5q2m7tpgz059MH3xI16NZKQpVuJ0UFnfPwGobuGFE3bqsfZcyYE8TXUToXcU05i9yW9vTO1pmFjSxqgDmYGSHcVFBYy7QTLADrRkDVFlUyZ
 QeHjPvnI
 hirk+U8v/iAMtuRcT1u/8nLu6gF/fi7T2WA2xUVfHJ52/lq6ajxNlsLGM44HvHk5EbxLqkgFKCqaZrlSZS+qsp5FtcTUmNh30ZQ+A0SA7/iF6wN5yRTogo7GAG8P4L1Rj+7MN8M5ee5C+RF4vFA8URPetMWpNvBB0cDlPVrrbWRnL5UbnE1vnHj6nXEkMn63LQ/TPWDY6GCahBQvBpSqz5FsqKx9eMRHecFt+BKClLkPNZeDQbzUtmivfYwECZc/EVneN31tLCD1eMf5sbNmPRMfLDY5ocazrub7EpZ7Rx8BiMYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 08:22:32 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Tue, Mar 31, 2026 at 08:07:30AM +0100, Julian Braha wrote:
> > There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
> > config options e.g. 'READ_ONLY_THP_FOR_FS', making
> > the 'depends on' statement for each of these a duplicate dependency
> > (dead code).
> >
> > I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
> > the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
> > option.
> >
> > This dead code was found by kconfirm, a static analysis tool for Kconfig.
> 
> Thanks for acking tooling used :) much appreciated.

OK, I give up.  Where do I learn about kconfirm?


> >
> > Signed-off-by: Julian Braha <julianbraha@gmail.com>
> 
> Unless there's some weird semantics I'm not aware of, this LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks.  I'll add this to my (small!) post-rc1 pile.

