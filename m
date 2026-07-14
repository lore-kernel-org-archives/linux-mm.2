Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E564C4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8F56B0088; Tue, 14 Jul 2026 13:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EE16B0093; Tue, 14 Jul 2026 13:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F208E6B0095; Tue, 14 Jul 2026 13:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8A836B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:57:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52E4116046D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:57:56 +0000 (UTC)
X-FDA: 84988140552.08.EBB559C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46C6620004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:57:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Del5tMhz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784051874;
	b=tDo2oJNGybAlVVU3MciXBbxKDjSebDLCefffUSbwBeNvNuryEOFJUE3CHC3iRHhIUkqDLb
	Yzcetue12/nb4GWCicDrCfUGD0Ax1RhOAtwwjtnj6sLgqspmZJwsuzxSRYXrd3MxWq3LJY
	G0i3+1V/ioi5TyXbKdzXL/SA5NHMTrE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Del5tMhz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784051874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZsCQFEgcn6EMOCDEWdLwPkfWWcQqzlkLED/YqdY1Tc=;
	b=g/VQtIiTwdNv1rUSfBATxN2wwLD4tAHV545RR4793R2uE6surZp3JqOE0vwCRbsxfNNpKF
	OQdO7oOlnzBm5a5px9jh4/OZT/POsWjDWN1K0VaTV0hFnqWHDQjUOGjbSyQ/LQioEC7maS
	2BXqCJAunkv+4Ifkk/tHEzpxY/cWt84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB6641943;
	Tue, 14 Jul 2026 17:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234151F000E9;
	Tue, 14 Jul 2026 17:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784051873;
	bh=GZsCQFEgcn6EMOCDEWdLwPkfWWcQqzlkLED/YqdY1Tc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Del5tMhzu3youmLCKHjbgtPvdsDIH+7IGGFST8BzaPmqfbbkJZKJ/z7YuaAT/X/p7
	 YChgX7fSaBbak9aPutlauCQ1Jbkj4qG9n6iEshYriEkzHWNiPFv0rwct2vUBjwBQdh
	 kaZUweQ5gxNphKPDgOzYUI91+awAsCTyJPp5rwvA=
Date: Tue, 14 Jul 2026 10:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260714105751.f45ec4c70702c222febdbf07@linux-foundation.org>
In-Reply-To: <alZfTxfypj39OrCE@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
	<alG2-RSitzPWClAX@skinsburskii>
	<20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
	<alVRU38lMfvmUFqJ@skinsburskii>
	<20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
	<alZfTxfypj39OrCE@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46C6620004
X-Rspam-User: 
X-Stat-Signature: hszex4az7sdnz3dyw68os5ktg97iea8d
X-Rspamd-Server: rspam03
X-HE-Tag: 1784051874-46933
X-HE-Meta: U2FsdGVkX1+Ylt+lQcLWwAp2HrVmUreVcr3Y6OZRLOiOOa/YcUaekO6oFoWH/OsWe9s7xKfVPH6/8cq4axCfipoCLfS+Du/VHwQSoRerQCIf+dn/l6r2zouNNJatDfIm2K9nF/FvRbEn8kbVCMaU+1uOwUgA0v0TvWVRG5KFW8g2Iso8Xy4tmTvZIOGff2nDzANcjJdsY2i6qwW520GSvtKP3s0JbtdzK0s3zs5RauerCYos6Fqpg3EHCMMVuWVz+FWj7/b9Ep1nm0GnPnUlk8YiFFu6vKySs/Q0prw+8z17yp5/uALh3Y/fNl7uhezKJhNUcRcwnDowJgjIEXmmmgOCcEMImruqpOUtMA13uCFbZBBGny3oBlqcrbk0xi6vke7C8WqffPhNpt/GqLfpbCwcTNf5vtIiL3+ZCpqJXcUWz8rZ4nB/EchEojzd60Dcd0k8uflOpfnTu8g1Ta7Jfy6RHyepEz67905nftCTsaVEunMv43PNZ0s+siUSdhhdPxuTrrtuWjA5WJu8tCIUdTH4a00tCGbYdE+jX7Nmxwzays4JAQ7bnTP2HVADWlrSdQBmOvmlSEufFMXndDVOx4HMDEHSCHByUYfVdogX1zGeXvSzW9QjuZLvzscuLAHGRHL1wOiQrZ8ikePeGvlss8A2eadixb3rkvC3NEmzOppvMbRKdDh8zAeKA+aCuUI3OZfjbomaXjXI5NrKTPxh+V6tmrEaTmpf9sbBtLWdBj2Z8U0yT/EjcWLw3UXrGWTiaGiBUKCIytUla5R/stz8eAv+mgubJzrGgjW0YxHA/98xXYA0g6wY2OfkI5XWSGGlzjL026pvtMVleVqoT+RmUCsuPzD/+QOPMuGh1TByxqdqoN2SUJtK/wAsVrlCA6HSlCJfW2DbVVFUUlOiCG61yQK0h3J8oF/oWu8PiwadL6h+FGVeMZE1+/xmrGcY0FYMQgr0Tkp//DC41YJG8wS
 DjIbjLQ4
 dsRJ6AYx838A+p5fPXOAR2JYQ9kUUsbE7nhx/pvBGDvv5js+HFmohKI8C08YlM0GutYY0UCems8vubwoyGmKve/hMniPX4ozOR3f77RIYehnS9EtaG+dQl3NCGR0NIQjcE61/go9+o5SGHKcGB1YEO1GC6IAXNqpzqKZv8cnyFmJCK0SDUwq76s+DLUgc5kkR2hOqSd6Tjw2wGCbNf3T1kl1ZNPGXnODpF6gNFlyUeQ5rotujIbKkVrzn+gaDAAqDZWy9kFp2rvWy4sH/gHLobn9q5QCRQ+d8Jsv1RsZD+FZh4Fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 09:09:51 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> On Mon, Jul 13, 2026 at 03:45:35PM -0700, Andrew Morton wrote:
> > On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > > > I rebased this series on top of mm-new right before sending it out.
> > > > > Should I have used a different branch?
> > > > 
> > > > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > > > this point in the development cycle.
> > > > 
> > > 
> > > I’d like to send another revision addressing a few comments and also
> > > replace the `max/max_t` check with something simpler.
> > > 
> > > Which branch should I base it on so that Sashiko can apply it
> > > successfully?
> > 
> > mainline Linus would be safest.
> > 
> 
> Looks like linux-next/master has been updated with the v8 of the series.

That's because v8 is in mm.git's mm-unstable branch.

> I have v9 with a few small fixes, but it is too late to send it out already?

It's called "unstable" for a reason!  Material in mm-unstable is still
under review, test and the latest stages of development.  Getting
things finalized for movement into the non-rebasing mm-stable branch,
then into mainline.

So altering or replacing patchsets while they're in mm-unstable is
perfectly OK and expected.

> If it's not, then what should I base it on?

Well it's a bit tricky to replace a series when it's in mm-unstable. 
One can do a git-checkout of the commit which precedes the v8 series. 
Or base on current Linus mainline, which usually works out.

Sending little fixup patches against what's presently in mm-unstable
also works.  I'll queue each one immediately behind the patch which it
alters then squash them into their parent patch before moving the series
into mm-stable.

A third alternative is for me to drop v8 from mm-unstable, then you
wait until that has propagated onto the servers or into linux-next,
then base on that.  This approach is OK but I kinda unprefer it because
there's a bit of latency and it makes it harder for me to prepare my
"here's how v9 altered mm.git" summaries.


Which would you prefer?

