Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A21D0FD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50036B009B; Sun,  1 Mar 2026 12:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD34A6B009D; Sun,  1 Mar 2026 12:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2036B009E; Sun,  1 Mar 2026 12:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861936B009B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:35:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 074E41606C6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:35:12 +0000 (UTC)
X-FDA: 84498195264.09.A770044
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDF534000F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:35:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XcuAXeop;
	spf=pass (imf04.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772386510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbaWI1rdvFnK3dXsg9IM7gaVSYJE/E5Nt9w95el3T/8=;
	b=4WqIO2a1/qQKaN7s96ekq+gtp2Zeiife9tIuE96j/a1hkeS7KRLXXnwWCraIKS3hTmkKfy
	AA1hHIWqq6rfetbPdkhcVr1t0cXqquqdR9IXfjoRi6EyTWYzotHOrnAogTlQbwKTfrZeF3
	+5qiN3Z1MSX9I/ViCV+YfEe74fp7gU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772386510; a=rsa-sha256;
	cv=none;
	b=DlztMpBumpHfboi18wv1W61Cf8106yfqwqikKiT3kpyT4fiHFLTHa270XCbjpcTB5EyiVN
	tITFKyGHugoN3cmz1q8b2iS+OXnRQHIzFczZHwS+httGxmkI65FV0ug27NDKkbqCFYfRZ7
	mK6bAOZR/NjTUURfP9wxT8tNPwBw2dk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XcuAXeop;
	spf=pass (imf04.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772386510; x=1803922510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xjPAAHtXkL4Laj2flE1/mWKS7QSwyfAmuzBLpB07rhM=;
  b=XcuAXeopt6xGBf7cxQx6jxnS3MhFqwCc9Y7PZ03GXYQMOka2Q9NXWJZ7
   Va/VdX644wSTlU0VJuYbyHSEsSwHHS5v+02OVKHDnBKLHx/ui/uISWJ6A
   4S3PHmhmlJjI8vR649KsI458CPFtHFSaivcx5htDBB/zG4Qg6KF7bXw61
   FBDqWcsmYP/efFRIB5tTvOiLgixY+erQkl/xJD/lS0jq/i1+IObWI0TsP
   gqjn28WHYzubVTsDPzV7TuL5Rxs5sFY03x2HxeFDrYCQTjok1UqQlhjBd
   /D7shUYJhie6IzGynW559wp6Q38QKYgvityh7E78XRuCjAyxBCgjS4Ufe
   w==;
X-CSE-ConnectionGUID: /qv86TMzRM+L3bUyw/HuSQ==
X-CSE-MsgGUID: GWdArtnfS7OqYCmN7d8CEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11716"; a="98874309"
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="98874309"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 09:35:09 -0800
X-CSE-ConnectionGUID: dooRbjHuRiGFxi6qskE6EA==
X-CSE-MsgGUID: 19+eWo9dR1WLuG7+mpa5bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="222404431"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 09:35:08 -0800
Date: Sun, 1 Mar 2026 09:35:07 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aaR4y-lCl7YPEcnX@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
X-Rspam-User: 
X-Stat-Signature: dct4f17pn6k1emmzhyj77ggqzh4zuyfu
X-Rspamd-Queue-Id: BDF534000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1772386509-487661
X-HE-Meta: U2FsdGVkX1+yxFpZFfFZh0wEHkgRyQWHx9ucFmFjSDpQJR3ATEVH32Wke/L9fbPeNPdn395hnQBJl7gxBB99kalOtQD0okuG9OEad+SQPwfMGd3sgnKGpMOVLhEwAgVDxkdFRk2g4nVRYNvvjLpSMMn/ReP+kvB39R2N6Vr6Fo28+NgbPngSMBo5EmIfQ0+sUWFCOfTczXZuslrnKoScP8msZ1Kndb8hvH9dAFOLqSFWmwqVF5zyPZ+5A0WkIGeAjbl9qFTg4JaX8EuttbGVNgNI+X/6Ha4JU4tXhAXYOSGG64IdbNyjvz0UBJRvmvGmnZkM/+znZFnX4/hzv8ignkdUAWyVA6w2ffgt4HM/oVg+AU5zQBWP0Ps8yBAS6FgyrU94IROOe1CTJ1hoNxbq+rIOclwie0+JDISFEwmQ/dbgPervf8kzZDtL8D661FOJnjdmIGP+7xIqA8PeKJampsbT9dgnGbxzCD9D4TShIYU1JyYwMQGt1OQolpyjk69cjZAMIDDAeP588ABDVJg/FTy26cmJR/p4u+Lx61sNq2FCP8pYCsq0Gz3by1SGIZs91OP0DPX12p8vY2s9q4gqpMUku6A2zWAyzoBDDcrHY5xXe5yV4sWt+b+EmE+UijGFnJ3R+0kqCdZGWTo4/8zRV6oTw7I8hxgpqbXHHLmGTZoAJpt2DYQIykNXKxczPVrIKo9wIGsxFXdxqeOMjAydm2aeiq012gHZmzTECy07lGT0XXrD3Xe9GnXIhKE77VGm7DU0k30C0GRUxWTZLOoGUDArJXMoCiSTjF7Lo84REJk/w4wSDQyyZPgIrA5x6chdtvYA9exWw0ATyQeakGZ4QLixE8owxKUsCPYVF+5A61wk12Z7ZhbH8x5sSbschVUq6M97XIhevE6V/mCCa00dowwkYxSO2M8eiiu5ZvchaBybJIzOrS7MG9OFthnQCIpJ3GU31DxHSwPovidPaRh
 vJt6IBxt
 GE35/66svIDbWSFH8xQLLWGN7dgNq5nu9d4gIYuo5HPakce99F2/mFdTU6Wzq7LgN/M4DYhIjUgxo7cSGea2aegbCs6m+fZDzvXo3Dws0bdrggJ5wteTKf6RrbPk0UyONXVDUtC2Rfs7y/bIjxOK7j6JiMpKErJRHYDmDYsAz+2lh5+7YFz2ZuJAwRciCgB7mgfwt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> a) Just because a folio has a certain order does not imply that hw actually
> coalesces anything. MMUPageSize is otherwise misleading.

That's true. However reporting 4K for a 2MB THP mapping today is even
more misleading.  That's where I started, it misled me totally!

So you're asking for an architecture specific / cpu specific hook to filter it?
I suppose it could be added, however it might take a very long time
to get merged, and even that cannot handle all corner cases.

> b) Simply because you find a folio of a certain order does not imply that
> it is even fully mapped in there.

Ok. I suppose the walker could handle that.

> 
> c) PTE coalescing on AMD can even span folios

and d) it might randomly not happen due to various runtime reasons.

It seems the only thing that would satisfy all your correctness 
criteria would be to not report a MMUPageSize at all, but we cannot do that
for compatibility reasons as you yourself pointed out.

Given that your requirements are impossible, we have to settle on
something better. I still think that what I proposed is a good
compromise, although yes it's far from perfect.

> 
> But more importantly
> 
> d) MMUPageSize is independent of the actual page mappings, and I don't
>    think we should change these semantics.

That makes no sense. What is it good for then? Just a random number
that looks good?

> 
> 
> Let's see why MMUPageSize was added in the first place:
> 
> commit 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c
> Author: Mel Gorman <mel@csn.ul.ie>
> Date:   Tue Jan 6 14:38:54 2009 -0800
> 
>     mm: report the MMU pagesize in /proc/pid/smaps
>     
>     The KernelPageSize entry in /proc/pid/smaps is the pagesize used by the
>     kernel to back a VMA.  This matches the size used by the MMU in the
>     majority of cases.  However, one counter-example occurs on PPC64 kernels
>     whereby a kernel using 64K as a base pagesize may still use 4K pages for
>     the MMU on older processor.  To distinguish, this patch reports
>     MMUPageSize as the pagesize used by the MMU in /proc/pid/smaps.
> 
> 
> So instead of 64K (PAGE_SIZE), they reported 4K. Always. Even if nothing is mapped.

It doesn't seem like a good design. I don't know what that is good for.

What is reasonable to report something at least approximating what is
really mapped.

> 
> So you could indicate all MMUPageSize that hardware possibly supports in here.
> I don't think it's that helpful.

Right.

> 
> We once discussed exporting more stats here (similar to AnonHugePages/ShmemPmdMapped, ...)
> but we were concerned about creating a mess with mTHP stats.
> 
> For this reason, Ryan developed a tool (tools/mm/thpmaps) to introspect the
> actual mappings.


Some magic other tool doesn't help with the current output confusing
people.

Yes I can always dump the page tables through debugfs (or at least I could
if not most distributions don't bother to enable that config option
for unknown reasons)


-Andi

