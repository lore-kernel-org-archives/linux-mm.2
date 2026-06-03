Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61DBCD6E69
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4866B009E; Wed,  3 Jun 2026 13:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBCE6B00A6; Wed,  3 Jun 2026 13:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08C56B00B1; Wed,  3 Jun 2026 13:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A006B6B009E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:58:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AE0D1C1D5B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:58:17 +0000 (UTC)
X-FDA: 84839360634.04.1F49C5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 885B3180011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:58:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2TiUt6z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780509495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ykcodhu/XhN28Udohna/yV1olxzbiwJfyoyWGAC5NnM=;
	b=np5Ic5n9fDHUJ/HNZM7MjnHXbwf8LH8D2LBTfFBrY1mI1sGDJF87xEijzeHPzk5edmrojp
	EXQWOL3KCGWzao4TprQf/gYPscEd+0FdPtIve7lAfwdEIt+OVVswbxV/nr3W4C6irU7vCj
	W8n4r6nyVTCW4I6tD3hhKi8rwLH1x6c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2TiUt6z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780509495;
	b=l5OUud+/GJC1z3gpBp+Z509J7bWHJtYFz1sdCENtH9GpUp1Xp2MhVjQOAg1qb/4c4cZJpD
	GpLAU8vcXE7FwyQlSM4KV9wCGRYKe64VjR+dCke1dRFpEsk7UGt2VSCDGH9Eyq/iGNBP30
	waDXzXmkleeLLDis21nUtjvrHcVimCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB231442D5;
	Wed,  3 Jun 2026 17:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32A41F00893;
	Wed,  3 Jun 2026 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509494;
	bh=Ykcodhu/XhN28Udohna/yV1olxzbiwJfyoyWGAC5NnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2TiUt6zfW4qf6SwrC02SlsHFTbmLmtiLZLbf4P7PA8z2eEVp5ti6jzeRyOfR25dg
	 hj2iuGgjeuxq4rCJWfRPSCSUdOvsQIubNsgfikQ3l02ZMPm02WIrJdm3owUWEb+vpy
	 Clv2OlNXoKMHRUBD7heBvO+JAjOTG9q1tcuKc9jhmvPuAho2CCdFQ8EBuiVK2Y5v8M
	 WA8YJkM2ipgB26/ZHDGwwjOFxivIrZhWqTtDTwLSLewYnOtKDVv8b/qvfDpeNwHhU2
	 wEgnDH67/woY31cN6ZMp4Oi8hrN1mCjBh/J2EZ1GDwRtm15bjeLWF5AoLPhJs4Gh73
	 9lywnI06QpqZg==
Date: Wed, 3 Jun 2026 17:58:12 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aiBqzOtEv5iAC_qC@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i9e1shaywn4o975ebc1sgmrbaz9yzemz
X-Rspamd-Queue-Id: 885B3180011
X-HE-Tag: 1780509495-154255
X-HE-Meta: U2FsdGVkX18fR1eyNxeaKg0/XEf+fzxyyBsgdEWGjyg7YdxN1S65K8IJBaWRJrLzoijenAr0yCFs6uVNpLmOlO5z9EJRDEXg9KSaGXt0neVkdFvAN6iCPbjc1wY9Cso8Q07fnCEQQ1ucb+sq5pxCd+V9RdSmKRaHR9FTBwwm7dpIiTvJSSbUm1gAInjx9GkciVrJsgjsfcIy/DLdOjEhTBfaJ2gNxeRDCsQIGms91kb197t3smKicA2ccRl5BugUiQlMnGwTnOvxqJ/5xc4D4mYI5A2pPKAcxjxa0s9DNyKCb4vSPPQyIVDdHGPKpAMq5TY/vtYENlvddcWIGAXRmHfh7/lfC91wRj3wtE9mTbZ9K2INuOrRS55M89dolj2qXSqtMFAVzOfv/v/Ai85kHcgvn8gEnjlKiNuF/NKdzyVQsAji0g4pWeeCkNQ3ytkIadOVUA1WiWFb/k2b/T42aPO9XUf1m6FKf3TxqeUvO7jBSQv695V4hTv7UsNFd5qjgm9MKpWcqy3awQRDBfTWrR+BRO63FDF7roxw1kH75FK5l+tlN0KAHEZFGeDdiIxYTdxa+aYesEqzWucDget549C1nViB8DEF+9cxZ+TrvJuVZkZlCWI8bGssmpkPqIXW07S77ygJHgXBzMBgikLCyGu6akUfnNHDaTDU60RfVLjxFRNZ8Q7MrsXC8X91LqGuMKkEx32g60TzojX4hLjIL5nQmH/i05Fxp0nuV2dP5LRmtWgu0bInsSDls+7rhhj/kXyBFBRvCTXFs1VmBpF9GENNiMiQEFJRJGxstgYPBqIT14i6ziJQWh0GA+DGulYERk00sMcxq3BC+ylv01tOtZnWP8UNsaQPsEytALwwEreeeYOLxMehY4H40tS8f9RtSdCvrg76PGyDyBwvmViXfD3mFqmKS2NtECjFAC+xN20MY1E4b9ZPglVGMw8Yo50ItL8u0HRIoa9sf0V5mzE
 bgaAr5Qo
 TrvD4AjLsdboncBy3LW+1pJv2LMAodS2EVjZ07qt27AQdewu4Xh08dYo2gxq3+an5nyC5Fh0/oeFix1/HUIGw5q8FFWykmiDH9jUa8ZOU7/sRvOqQTzwRB33/p7eN970Bxtb/K9gRlz05PYhfeaIVCWbOJQAsyYsue1M8pyPhbFfUSJRkpaRBQsLxerT5+V6bb2vSlS87aB4POYAN1JLlUUHitAjosLSkIXg2tt8Y57dq4YdATCNtUMINySO2+QfXnhN+KIpWDT3LuklCxQMijQroKVALc6XcaTTCZUJ1zefzrP03J0FZKOWGFm5YUKvp9MspFLrA1EPnRT0yFsKMZ7nl126N2TZmaweS8XSpasVF5ob9mvCF8PJ+kJxMzucAoZ6fQ6qXmQ3i8hnIUoFRYvMpshGmireSzPhC/OFLt+tT0Qg7jwTE+WD3PDKrdW9HElEMmY8hKRzuSxMaW/yTxMNudg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 07:22:36PM +0800, Hao Jia wrote:
> 
> 
> On 2026/5/30 09:40, Yosry Ahmed wrote:
> > On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
> > > On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
> > > > 
> > > > From: Hao Jia <jiahao1@lixiang.com>
> > > > 
> > > > Zswap currently writes back pages to backing swap reactively, triggered
> > > > either by the shrinker or when the pool reaches its size limit. There is
> > > > no mechanism to control the amount of writeback for a specific memory
> > > > cgroup. However, users may want to proactively write back zswap pages,
> > > > e.g., to free up memory for other applications or to prepare for
> > > > memory-intensive workloads.
> > > > 
> > > > Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> > > > interface. When specified, this key bypasses standard memory reclaim
> > > > and exclusively performs proactive zswap writeback up to the requested
> > > > budget. If omitted, the default reclaim behavior remains unchanged.
> > > > 
> > > > Example usage:
> > > >    # Write back 100MB of pages from zswap to the backing swap
> > > >    echo "100M zswap_writeback_only" > memory.reclaim
> > > 
> > > Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
> > > compresses to 25 MB, then you're only freeing 25 MB?
> > > 
> > > I'm ok-ish with this, but can you document it?
> > 
> > That's a good point. I think pre-compressed size doesn't make sense to
> > be honest. We should care about how much memory we are actually trying
> > to save by doing writeback here.
> > 
> > The pre-compressed size is only useful in determining the blast radius,
> > how many actual pages are going to have slower page faults now. But
> > then, I don't think there's a reasonable way for userspace to decide
> > that.
> > 
> > I understand passing in the compressed size is tricky because we need to
> > keep track of the size of the compressed pages we end up writing back,
> > but it should be doable.
> 
> Agreed. Using pre-compressed size is probably easier to implement. IIRC,
> interfaces like ZRAM writeback_limit are also calculated using the
> pre-compressed size.
> 
> I'll clarify this in the documentation in the next version.
> 
> > 
> > If we really want pre-compressed size here, then yes we need to make it
> > very clear, and I vote that we use a separate interface in this case
> > because memory.reclaim having different meanings for the amount of
> > memory written to it is extremely counter-intuitive.
> > 
> Agree. This would indeed break the semantics of memory.reclaim. I will use a
> separate interface for proactive writeback in the next version.

But doesn't it make more sense to specify the compressed size, which is
ultimately the amount of memory you actually want to reclaim.

Johannes, Nhat, WDYT?

