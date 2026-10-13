Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DF2CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B38F6B0088; Tue, 13 Oct 2026 08:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264716B008A; Tue, 13 Oct 2026 08:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179F66B008C; Tue, 13 Oct 2026 08:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1D96B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:52:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85CBAA8A88
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:52:37 +0000 (UTC)
X-FDA: 85317591954.17.4C6C921
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED93740008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:52:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S7kj/CfI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791895956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08sJ15vQvPn22EKkE3fnR9OOkCBn/Y/3QGXwmX5Vt2Q=;
	b=C3DpF8czEz9kExgPh7erS2Mz8It4BtdLcLX29L1htmTadbUCYfsFwBhg9lBPquRHD5ndOC
	XMc8NjqJs0/kTToOFt5u+d5t8GHSXyX+uqc0SVOGIq1MZwISqqlso4/DEyH9KN47RoPCsJ
	dhTytXpYY/NLbyyGa++peuAynYm47zk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S7kj/CfI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791895956;
	b=YjA0W2I9/nvxmtIrbqpnlU8u7BbfoWK3fTHNWhLyyhPc9uFEk84wZnQRGhnzAq5g3X4J9U
	bcTX3xlpSjSnZqqRy8fn6Dctstg6I/3bC7qV5pzDyjS2z99RLnA0OkItYGZrTNl8RjW+GM
	AHcv3yUOkq5C5p2cCWdX1Z//5Ij1M2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 008E941593;
	Tue, 13 Oct 2026 12:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AC51F00893;
	Tue, 13 Oct 2026 12:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791895954;
	bh=08sJ15vQvPn22EKkE3fnR9OOkCBn/Y/3QGXwmX5Vt2Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=S7kj/CfIsRYfKCjGHwQxhK1cwvGWhLM8Jm/El2TwQ2t2QUjlfqSh/gvHEzw2iGOgF
	 62a7WM3l/vY0+jJqRmfZ5De8XiVDehL4EaN9oWkBOcgC6toVID6ZAtrSYLxZ3Wtl4s
	 2Y5DQAI5nZ/kCTcds+Q5CPw7MiKLwtYC4HkwnGpMa7EFGXzTJw2vYtYPAnb+gQNEiC
	 31Rbt7X2D9y7MS0taYY0fjtPWQNf6t/dFPOUn+SaZZFbrcYZfL3EyrX3VROWP5kSH3
	 TI9IbAcJr49hnKlyuacSX1wSZRFVENj5iNz0YRINVQbZVdaw5vzjEstx7AsO25a0qi
	 hqkkRKk+TeIUQ==
Date: Tue, 13 Oct 2026 14:51:30 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Harry Yoo <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in
 kmem_cache_destroy()
In-Reply-To: <as4QhUscRVtBzYpm@thinkstation>
Message-ID: <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org>
References: <20260930195110.13296-1-kaloz@kernel.org> <ar5pESlkEMqNsgxv@thinkstation> <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org> <as4QhUscRVtBzYpm@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Stat-Signature: tebk88t7p4erny8rnrqb7nfm88jcw7kk
X-Rspam-User: 
X-Rspamd-Queue-Id: ED93740008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791895955-873717
X-HE-Meta: U2FsdGVkX1/DlUt43vl+vFLOwuYySTbgEJrni3Cm/8Bv+HGw2ajKXXEUp67CH/uqVaH/SwKboDPXLFAU3oUA4kMRMdssKMrH7Gvo2ieNNnmb1lbjWgHWiq0MbixPW/EUraCv35yhLdvxHAw4cKZxTVxtzMwO7WpPvyweVJbTFuynTQv/XvKmE8Nz2oE3xW0SRzqeNRDwNFomUeJuqWgKOQGgwt+MAaisZutnQavSUtmTmoGayAmT/xcUCXomCLBpYNqR91QeHdotknpml0GfAItj8QOg8xwq1pr4XrSnrQyW67Etzj5GLKeflblg3pXcLW7L8GcLz4C+q78G1uZvF0Urk4xhHPL4CFqZEn9ZUH1BOhoqcw2pfls7xFvRpg2JS4/3RKQMYO8V68wRy2oXzCw4j7FuJNqg114ozR3cl3dw8HxNsDzL5odjd0DwI9zpHKsA2+5YMBpIoaYlBTg8sIGBlm1AGo0vVvQShc7ZVKsmlZ1zcQzM1TLtdQYLetok87mVLADSvuiHORMNk0WB2CtFBiKSt2HCw6Kqo0dsXpgByKQkTPpxI1idIX+WhEYt6WHZ1H7hiW6o04POr5mEv7TTl2xVRWXM85zZG7hHsfx4zJfbn+2Cyd7acPmDC6qnY8qsBo5AuCifAZTvvJOZrrnaPkdx4NIwmJlqFg4x0jajjca1+S+ft40im3R63xES/E435AjYRVR3oG8fovMAaFDH1wfo87sqWf3fDLxeChY1/2gFuRcLc3/68AyPXHQo6LHmDd4qsZ5BjRfi0A9lNjoTyLuRhpsFmpQNzucwtLp3BxC+ztyT2drN2whQgyDkCI1G4ia7AHdpOsEuijgr8GmtbUD31r2Cd3cvAvsXwBG/3RB9v6lCU4MAN3XjdfO56rBTahQoNoiMdP47Srw9vD689EXsTCFpInMSvUAek5aKXnZWpLcN1JWDmcegJZ9RbDRtBS3m1NWZ1eZokbn
 +BtVcIfk
 3icaY6VUTTORo4wOMaK5/5Urka4O5/P7mFWx1KDlP+uxszKJdiOp83Dq/UoehsRccGitW+f/Twj8Id8sbpj8KneRVxl17cx8gr9NK/esaxB/puwRWRL8VD1c7iljgHN7wLi6JBW37vItj9vaNIpZAxCXuJA2VoPHrsP8LtVyPUNkg3TfzkfGq3NGdysYIQQhlSucVU5+PTzhSbGc4BrO26voVlV1nJ/Qhhp2IWv4/C+/OGgFP93XAIeY47xvLCVrTG7LSGLuuDlU0x8f1NsLupLusZHvPz97JHfrGGFSaRTY9bvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Tue, 13 Oct 2026, Harry Yoo wrote:

> Uh, apologies for the late reply.
> Catching up after trip at LPC...

No worries, hope LPC was good!

> On Thu, Oct 01, 2026 at 05:42:36PM +0200, Imre Kaloz wrote:

<snip>

>> There is a related older window: after list_del() and before that
>> single read, slab_sysfs_init() could set FULL, skip this cache, and
>> the single read would then call both unlink and release on an
>> uninitialized kobject.
>
> No, with this patch slab_sysfs_init() cannot set the state to FULL
> because the slab_caches list and slab_state are protected by slab_mutex.
>
>> I have not hit that, and this patch does not close it.
>
> I think the patch does close two bugs.
>
> One introduced by 4ec10268ed98 (reading slab_state twice),
> another (reading slab_state outside slab_mutex) introduced by, hmm,
> not sure which commit introduced it :) should be very old.

You're right, I got that one wrong. Sampling under slab_mutex in the
same section as the list_del() means slab_late_init() either sees the
cache on the list or we see slab_state < FULL, so the older window is
closed too.

As for where the outside-mutex read came from, as far as I can tell it's
0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy()
without holding slab_mutex/cpu_hotplug_lock"). Before that, the unlink
and release and their slab_state checks ran in shutdown_cache() under
slab_mutex. SLAB_TYPESAFE_BY_RCU caches were already released from the
workfn outside the mutex since 657dc2f97220.

Want me to send a v2 with a second Fixes: for 0495e337b703, or is it
fine to add it when applying?


Best,
Imre

