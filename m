Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F78FE99057
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80556B0005; Fri, 10 Apr 2026 04:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30DC6B0089; Fri, 10 Apr 2026 04:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C470D6B008A; Fri, 10 Apr 2026 04:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B29456B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:52:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4793113AEA3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:52:22 +0000 (UTC)
X-FDA: 84642029724.13.FF8D3ED
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86849180005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:52:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jdzNlHbJ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775811140; a=rsa-sha256;
	cv=none;
	b=4JYoAn7ozGFZudaVBmMm30UXsgseMwrgsDVLF8+d+HxL5KDg/lc2RPBiFGh6dSK2pAr0zH
	jtyjBO7s3Bhyc+M5f1b7hv2iVGL2szwSCyJu4OexcZ3yXOQIJqA31T3HFyJ7RbecHrjghl
	VwbAvyvV1sTkJsNmL4k3YOtY524YvOc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jdzNlHbJ;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775811140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eX6xcryDUIa7Vylx/0UzTyLSmyeGAUYHjEMq2Mi0C0=;
	b=jahv7XGfsBuxPAC4tTV2ahSgDAH8TxnBO2s76yTviNCVxY0N3WyAFFtLLHKqxi9nnfmniv
	M+RBT2QsyXX9exelOUKKoTTP9nidWBomw28QvwnTqEn+8m86HH5LPxLBGiGIlLDJ5JzP/m
	6m/Cv/HZFhT6c/VNOPgYLbQp7a9mvZA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0eX6xcryDUIa7Vylx/0UzTyLSmyeGAUYHjEMq2Mi0C0=; b=jdzNlHbJtZA4YfAYyP5O25FLE4
	wKMHbefxjS0W6vs98qdeJa7V4gHj25FxGt5RkcNyejrww3iujsYvJedlbpghLpIyJXt6yg92o7HjH
	ejtUgep8gK+7Kk5Ir1vy3lSwOLbNk/SZIIhe0qaZa6nxv8sGiP/m5p16Zc2elgg5mOhuFOpsJ2xJq
	8fsQMLPXtU31MF2boEItGD0v7RZ5TBCYFxWx3WYHawnxPqIXGBH2VOXy4DPBqJRWvbROvMjl2i9Ey
	8XPy0a51PJuJDlGFP/Nt/gxjYLkfj5f96kCChp45u7g/wnhyg7uKJsfQmAzr6r5HSz0WtHVGp9hnW
	Z2ukoSlw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wB7b2-009rYK-2Y;
	Fri, 10 Apr 2026 08:52:13 +0000
Date: Fri, 10 Apr 2026 01:52:08 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: fix error handling in kho_add_subtree()
Message-ID: <adi51hPc8n5ITHbU@gmail.com>
References: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
 <20260409150802.fd7b91c9beea6abe4e8a63c2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409150802.fd7b91c9beea6abe4e8a63c2@linux-foundation.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 86849180005
X-Stat-Signature: 5kbrs3hc8jpc4ueaxqunctdgbsexqzdw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775811140-745452
X-HE-Meta: U2FsdGVkX18xEEPtR+BtyLruANmkjXwUJyNYlaZL5IW2FSfvMjJke3DB4yZ9yS87qQJtAa3InghHC/vti/Z11B332r6V7NnaQ5AUtgCb8Vl+WPYbT8htc5KtFjK/ZebkvIQHAzeVIspR7phyogZk9W2MxgLtXRZNmgIopwj0njxaLiu+qK1oYKXTr9OWEWzxNT3AN35NvXdaxshXXIKRFZedOvNhcSu3d4Vs765Sc76k78Eq0FTIP59BuV28C/7qmOqqwPhnG6nvYlcC2Z43JzyWDIXM+YPHfPgu0DHt9unH80urmv0iFWbEvpgITgiZba25k7sQFSqKZagt3AgSTPaouFDplqV9K0b0asmMUwM9VDwSrehvw0I+zT7Q2HKauJTsQq8b1bQfPsBmOIcJgjWZoYzL8i1pc5kqTMnrqpxbVeRAefPjKbHoV/2ICJMSVLAYwfsyDgUJe9yuuSStlz3MgweuOsSuImShworp23LMWDd/gvpwBrvj2LttyF1foCV22AU+DruBpkviN2k0AyFcTW6ntkHudvxc2gwSJIeTRodr01BJSY9vrcjYkETDBbbP91o7jU2eBIEiTJYWrICId8mLDTrvxpHkiiHeIGAvhlW/Lv2cYNSBr1scH5pWCOlAQh4T0sABFQYWlClrKo4DHNDCpN9N5HcLTt+eJOmWLDLq70T0S+vxqpiqi3FjW72kU/5bg7PfOyGxCvTUjYFt2I6c6SzVq6k2KY/6TbUMYS3lt5sn2yC1fSGfOEnvC3+ldDkCQB+4+ey9LkbZBxLH2Maomi7z5tlFOswGa4cb5HeeFiDLk6DKeWhCBSpO3XTxfkcpb6qIZapEhT4QiVVHm2jaQfIGCv6z1riyHMjf2/QVmR5C/l3beP2gcgMjSJs8NCElsEfBA9ogPtqsAFpOfDZBW4NqN81vrtfezeXEe9V49gCNUOoD59tHrzlQOvV2Jqer2oq+dG7IBD1
 wsAkD8ZS
 46VzUCstL1aBABsS+/77UVuEiwMqmODiTT6iHMOzvrJEjWnSIoglKoFLuhI3gKW1frQN6vUHM3g9XXrfZnmrXbNg/i/ftswE8kuHa6VzRvQ/YtJzHMySHZPbfl6idYfn5eaLoQu9kJh19K/f4mUGHS9MNlF2NWCRM43T36TLxk88w0ygKrl1uAYrc9iUxgzvZ1H7XxkH81tx4ZSqG0oAxmu9V8xgQXQmirOUu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 03:08:02PM -0700, Andrew Morton wrote:
> On Tue, 07 Apr 2026 10:01:47 -0700 Breno Leitao <leitao@debian.org> wrote:
>
> > Fix two error handling issues in kho_add_subtree(), where it doesn't
> > handle the error path correctly.
> >
> > 1. If fdt_setprop() fails after the subnode has been created, the
> >    subnode is not removed. This leaves an incomplete node in the FDT
> >    (missing "preserved-data" or "blob-size" properties).
> >
> > 2. The fdt_setprop() return value (an FDT error code) is stored
> >    directly in err and returned to the caller, which expects -errno.
> >
> > Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
> > out_del_node label that removes the subnode on failure, and only setting
> > err = 0 on the success path, otherwise returning -ENOMEM (instead of
> > FDT_ERR_ errors that would come from fdt_setprop).
> >
> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>
> v6.16.
>
> > Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
>
> Do -stable kernels want this?
>
> Changelog is missing a description of userspace-visible effects, So I
> (and others) can't tell!

Agreed. I'll improve the changelog to describe the user-visible impact
and CC stable in v2.


