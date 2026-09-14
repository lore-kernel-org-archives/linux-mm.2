Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3284C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 21:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36066B0088; Mon, 14 Sep 2026 17:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7016B008C; Mon, 14 Sep 2026 17:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FCA46B0092; Mon, 14 Sep 2026 17:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5676B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:25:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C56A120288
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:25:25 +0000 (UTC)
X-FDA: 85213649010.20.C3887AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E481320004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:25:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCLxnH1I;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789421124;
	b=4Tz6APx0babDC+w1np+gBWyY1yTBjO1FERBFPHcSg1E5RpWo9Tj/EoP+xkeYwAOJ4eNbh9
	s/N+bV2iiKMRLCpA6+NbmXS+bZPlagq513bFoJr3ok22IY35O1qYPSzeopgtedKf3a3jVt
	5tUaOOdBi97X5dcnMphPmqmRBz+SqUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCLxnH1I;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789421124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oPRlFur4gXE4ByuV90kyekDlYUa8AphmKSN18DFAX4=;
	b=S72j4Z/AYs3mnoo4HwlmZMh1VkXd6R94Q78cqYUOEiPJ3Pc4gablH3nOFjP7z/p4baTvSk
	ZScGdmZ1uT4siB9WFv0IgOS+GCGR9sKg0zu2+7XTEne8dsRW200krXmxy94DckLCb0dFNX
	4VZg7lyYuL5cv6zKoFGMxi1WARIT2wI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BE956025B;
	Mon, 14 Sep 2026 21:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3321F000FF;
	Mon, 14 Sep 2026 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789421123;
	bh=0oPRlFur4gXE4ByuV90kyekDlYUa8AphmKSN18DFAX4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XCLxnH1IdteGqLAeAU6TS91ZH8km0q7I9bnb0L3KXxE21GdTqg+QQWuYS3fSxgSyr
	 dmGDS5KLxAanB5BON1LL/ckCgc5cg1LtgHz0jLofvmBgqOb111CjMFfo00ZhBEznDF
	 0S82S/gQxM01tGPGgyX5d6pX5QesJEdUKPSXjRjI=
Date: Mon, 14 Sep 2026 14:25:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org,
 linux-mm@kvack.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in
 function definitions
Message-Id: <20260914142522.a249bc5e3e2b1f69e7e46f2e@linux-foundation.org>
In-Reply-To: <CAJuCfpEv2k+Z7q14UUpFXDL9_=Q66Gdemf0s=NXyXm4DLbWAcA@mail.gmail.com>
References: <20260914190631.3167420-1-surenb@google.com>
	<20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
	<CAJuCfpFoWjM61tFLiZ79ufr7TLvWBarP--nmtHCm7OdiY-95Gg@mail.gmail.com>
	<20260914135559.5784327913c6247fcddba4e0@linux-foundation.org>
	<CAJuCfpEv2k+Z7q14UUpFXDL9_=Q66Gdemf0s=NXyXm4DLbWAcA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E481320004
X-Stat-Signature: njmpcxyocphru1isp7pxgq7cuykkxf5j
X-HE-Tag: 1789421123-63956
X-HE-Meta: U2FsdGVkX19k+kth3X2z2LYKf6eMUYduIbMF2QmAJe3UeUI2b4fVE8+K/BWSelwyBOqxBfZIvCYY+TVNYkR1JfsWu7LLlQ0axVZJEoVSOMvjSoqhLAkKRNrDd66MoCMobaQudGXOOcN0d/1LpKqJIhPdiePMPfe4LZ0utLbEVfJ3kA90cLs7WLVxl8kVbITcB6JG30bPhvST80QCyYExiktaDjgWntlVTfUXFuJPGk4idclOakZIjOIPzjQ1oKhayz/jDPxB1+Ks+9MTnhn0KC8Avwm7TQfsOtE4Xs9GSb+0T+lQh8k4pzACujnfF2Q1g8Ou0fXrZRRoGzQbEqrzCo7IU11gtBI83n+hTfYPadZHXMBpMYAooU6xC77Vt2tFJnwaEd5c8J8qMjmEmE8VBiZpl7ODitHe8M3qfAc57MsAUU3ffpzzFfmYkWsLRITBKcKEWN14LBkqcVsV1U5+CjXrarI375z9NkYFJY16xfMFpShtVwCq0OgODz0dWDzZeXnaYBNof//rMSYCTD6PcBHAf8SMEOs+8NrsmmdJeplj6xuSOxHSbygHVPzLt1ypm0QLmC8pp3RZYreOyqpGG5D65mHqaiGp+Fd8Y1Pyusw1HKxjytKq1B8PFfofHsWuckKhn7vRA85RRkJ+JDCPWuDimuTFsn+izKmURFpoiMfoH5jNutlWT4cB1+iHr8k0bEHCbyWC23vCOmBURF/skWTdkmWTksXhOOIOjpkYsT3KcB/6vqbhYDeV8/WqeBe0fHpkTQgAn9OpoIzv38B6AfOFSqaes9VunWP8uijH2hDAGp/2PPpHtY5bflnb22z7HzNYQHSBxU6kt0rUYp6vXY1FdbfylhUVkSB+fZ6cXrjTqrmdPCaWOUQcWcxhR8T6yWkgpgP0DFJZ0qRL5BHbMksfZZY46JAS63+RPBed/rXbRT2nbdS9xACDKgzTi4KCJEAxapSatvw77sbipzo
 g0KQSD0y
 UvmtJkdNR8oQDkJss8301r5uOiw9D2ejd7d6tpVUjFCYrAXNDtTfl3D3Tgph/i6Be6ga5TQ7O/kEf28jWpBKd/wUfeHQXYbW9pVQhyk3rfZkr3GnRVWOqxs+mUQZBdlFOWUed78GRfnaQ9n66xO7xZ5FzkHA56A1JNkX0bAKkGZxkWionxYzdhH4oIj6dZXxf/Bl5R85WplLUPlx+XdvBRcew8uWA8q7fm+5RJF5+1bUtlqT9zfAMPecjWbbMEcbYb+uBq1atwVsiM4x7xeRrgU2xMqhxZjqOBSHX36IviIUC/We/EzLwEFGQePpW4RPBiQHHobViZ1wrCgaoYq+3rQDZYri9JXXiQacfaw27QVudpnbVUmAwyvT/4Cly+g53PgmsRfIqT+HlBwywD1fLTLXROA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 13:57:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Mon, Sep 14, 2026 at 1:56 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 14 Sep 2026 13:11:52 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > > On Mon, Sep 14, 2026 at 12:42 PM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Mon, 14 Sep 2026 12:06:31 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > > Uninlined drop_rcu() and reacquire_rcu() functions are not used when
> > > > > CONFIG_PROC_PAGE_MONITOR=n. Exclure them in this configuration.
> > > > >
> > > >
> > > > But there's also
> > > >
> > > > fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
> > > >   133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > > >       |            ^~~~~~~~~~~
> > >
> > > Ugh! This function is removed in later patches...
> >
> > Yes.  So it's a compile-time bisection hole, which is probably the
> > worst kind of bisection hole.
> >
> > > Should I just repost
> > > v5 instead of fixing up in different places?
> >
> > That would be best.  Leave it a few days, we'll survive.
> 
> Ack. I'll post v5 on Thursday if nothing else blows up.

np.  It's only in mm-new, which is performing its intended function. 
I'll keep this out of linux-next until we have the v2.


