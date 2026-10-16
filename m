Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253C4CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5706B0095; Thu, 15 Oct 2026 20:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766EB6B0099; Thu, 15 Oct 2026 20:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6563D6B009B; Thu, 15 Oct 2026 20:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46A176B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:28:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C52541A0269
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:28:24 +0000 (UTC)
X-FDA: 85326602928.03.3E205D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF52D140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:28:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cQ3/riAL";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792110503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tChevyDCNpHwTF6VNwlTOZAk8TDbJCK/O52gp4miT8=;
	b=PyLb0Cc0VGviSZgxURpbhBG6UbmGO+Wj9EIbHl3T4Jk4dvmKr/uoLM/mRzZaWgtFGKcU53
	Fc5Iw42eBMo++u9Ntt+lNswtMqWQTgQNfYndyDHYda7nkJk0IExWH8S+ntRWT8SYFd4SBM
	SZAO+5BDQcIBrnCUDbEaolqsXx66jfs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cQ3/riAL";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792110503;
	b=JQC7he2BtY/r7cmxW/9nPi6hPLpAoKdoto2EijtkrUTh1iV1S8RutLwg9+D/dO/0n6tohL
	pk/L831boAOm8000Wva0ImM3b6xGz7ducb35MllJsgAtoBpxNG3AAM8MtI5TZpqqhmEBHT
	oTVcpaSG2AgkbVNQB7KhY36OFgTxwLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14CAF4137C;
	Fri, 16 Oct 2026 00:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686361F000C4;
	Fri, 16 Oct 2026 00:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792110502;
	bh=8tChevyDCNpHwTF6VNwlTOZAk8TDbJCK/O52gp4miT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cQ3/riAL9kw/dqN6Oigdw8FG/7/Hdfr7otqyORVpjcGZh1l+5sfriH2LIq58Lhe6q
	 jR9kJwWGxjvvmfdN3RFPvDBhfN7Ne5xo1MAC7SDWo2S+ls9jVdLCl8BwWvf4gFWQy0
	 MOLupzKsLaRhF+5VZL+c7h+2+ePrAswKvyMs/PLg=
Date: Thu, 15 Oct 2026 17:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, David Laight
 <david.laight.linux@gmail.com>, Rik van Riel <riel@surriel.com>,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Mike Rapoport <rppt@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, Kiryl
 Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, Tal
 Zussman <tz2294@columbia.edu>, Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-Id: <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
In-Reply-To: <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
References: <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
	<asAE3kLFDUx5v0Nw@gremlin>
	<asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
	<bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
	<20261005132113.43548696@pumpkin>
	<asP5xK4axiUk7jun@pcnci.linuxbox.cz>
	<aseMsMGpGPT/G548@pcnci.linuxbox.cz>
	<20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
	<20261009090042.39ba9c06@pumpkin>
	<aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
	<20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF52D140005
X-Rspam-User: 
X-Stat-Signature: 9ydp8xjkfshh3n1mtbzaq4y3btqgpigz
X-HE-Tag: 1792110502-612802
X-HE-Meta: U2FsdGVkX1/IIljc3wIi68j1MH/WqoWm011ykMk0vojn1lz3hzP/K0N6m8a56KSE+A43B/Bua7ZSTMUqAuf1NFxyRetb8/IXqnCz1QXOFhisLZ/lH6o41zQ64XRqWOKgfVk38tdxUxQNNR+5/7AZvI6h6nInv3gYbAHoehmxHZ3BWy+JgaJdriSsRzpTbgzZk5nNA7VWsILgyl/+x1VSnKn+JVPPA6zw/5SJXmYdqmm9nL3oop+dO0adtdY2uAlUpjl42tqW7bTMIhQRlQq1J5UqB/5Ax1Q0io29oInlBgp6+9DFsWXaTggKXh+3zztmgmQWeaGu1iZkbTKiTnrEnHPSmqecczs7TTCLOdXbGU1HYW9B5/zeBY3exYpUHplKchHl3evXjuHhcfYOJYPhIgUe640n5ix8zgn8VfyenBSB/iTljGLzvFDIbA/WD5jPiMMcbz0jpNWW7WoJfy1gOqXxvnE/DCp7S+t67pSPyOyCtHCYImhOCEbLwABGQBw3oRgP3VT74O2sms+YXUQeqLUHMruB/6lfUuM0HczqZAKjGgcKlCvHSbuOUNcsAWoM2qLyE33r9zAWcJgoMs9Pmxx7v40Qh9SchHtfIvg9+9fj0qa1Lo7O73DUIJ01ogl6U8Yq2YBMYhKPEHDa1vJytur3F9OZppE6hM7UzD4LltlA15iUwAlFaiinCLQFdwn0ZJql5Vw6yfVOyR/YVcd+PBVkshYotCPjnrCFnGWSoroEOUdvbbXEjK/T3Py9ft4dHca80JDmhdZGd/KlNOnD5zrnQhjrKUMaaSl72YU892VPImwQPLNpxc+EPi4wEKshZw1y3KPhzAdkC2EEaSagQ/rf/Hb4S2XtC2ThHqYxceJ4+bc13V4m7ieny354wVW0ucTxOhfNW2eXe2hHYb3fumC6zPMmlxoQy0shgvqc9z5tuGjMzMof8n1oftNxxURkM/jaije/31rqZAlrI8v
 EIcZswIo
 tVDyNcdFanSxI1irLi6fVWdPCtklZ2whgPBDU+SwZauTwqJr7i0tTcCBT6Pnf9kH4Z0N902YGqoeaycg7TvKin3e0XXT0N6GFRgFXa8lx8ni3tWHf7r+aoSXGDpdDpVuYsBQ3j3priqNup48NB2KFqZ5XBQVFGRDIPcfbhsIGO18ZkZ8wrryNwxZXAo9IFxQCR5V00Th43yZ996sKNmPFUZDzcq6pCLdqsZydGxzPVXeaPhfUauY54Yk3AyWTLt0vV+WblxR53rvr+fq45MsEnT4WwqXv6/5rCuHvUoiO0+hPoRSdS+NSUiODwToMK61+o1Wa5HMOMTgDr9MQbxyMyaASj29b2jTXTyso
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 16:57:36 -0700 Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Oct 12, 2026 at 01:43:30PM +0200, Nikola Ciprich wrote:
> > Since I didn’t have anything else to try, and we started having
> > crashes on our own cluster nodes, where I can be a bit bolder,
> > I built 7.3-rc6, deployed it on two problematic AMD nodes, and
> > started a migration torture loop.
> > 
> > Over the weekend, there were ~70 migrations of ~160 VMs between
> > those two nodes without a single issue.
> 
> Did it reproduce usually with this?
> 
> If not, keep hammering on it with the latest kernel. We might've fixed
> whatever that was, along the way. :-(
> 
> And if so, that would be a damn nasty bisection to figure out what fixed it...
> 
> So pls hammer on it as long as possible to see if it is really fixed or it is
> simply harder to repro.

fwiw, I fed a lot of tokens into $LLM and it suggests that 55780d8a1dcc
fixed this.

If that sounds sane then testing 55780d8a1dcc on that 6.18.x kernel
would be useful.


: The repeated structures appear to be AMD VMCBs: 0x0fffffff0c930020
: decodes as segment state (selector 0x20, attributes 0xc93, limit
: 0x0fffffff), not a damaged pointer.  The FS/GS offsets in the dcache
: corruption and the LSTAR/CSTAR/SFMASK offsets in the earlier library
: corruption suggest misplaced VMLOAD/VMSAVE state transfers.  A
: candidate fix is 55780d8a1dcc (KVM: SVM: Stop toggling virtual
: VMSAVE/VMLOAD on intercept recalc), which is absent from the inspected
: v6.18.53/v6.18.55 code.  In the affected
: svm_recalc_instruction_intercepts(), VMLOAD/VMSAVE interception is
: changed in vmcb01, but virtualization enablement is changed in the
: currently selected VMCB, potentially vmcb02.
: 
: Although the commit describes this mismatch as benign, restoring a
: fresh destination vCPU directly into L2 appears to expose a case that
: assessment overlooks: deferred intercept recalculation could clear
: vmcb01s intercepts while enabling virtualization only in vmcb02,
: leaving L1s subsequent VMLOAD/VMSAVE instructions neither intercepted
: nor virtualized.  That could make guest-supplied physical addresses
: target host memory, consistent with the observed corruption.  This is a
: source-derived hypothesis, not a reproduced root cause, and depends on
: an affected vCPU actually being restored in nested guest mode.  Could
: we confirm that condition and test a backport of 55780d8a1dcc?  A
: useful vmcore check would also be whether any live vCPUs vmcb01 has
: both VMLOAD/VMSAVE intercepts clear and the virtual-VMLOAD/VMSAVE
: enable bit clear.

