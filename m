Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E999CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400AB6B0088; Tue, 29 Sep 2026 07:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A4C6B008A; Tue, 29 Sep 2026 07:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AB06B008C; Tue, 29 Sep 2026 07:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1A6D6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:33:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 693A78049E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:33:17 +0000 (UTC)
X-FDA: 85266588834.20.6EA707E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC4BFC0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:33:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDfq3ESV;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790681595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+gknYVW9XCp81xeC0RXx9vcOUHAJigZEtqY/xe8b6c=;
	b=0L2FmijKb/GXtbKaqn/D6TO9B2ThTerlKdG4wtPRCqvz2ZXXgUWvMEGZxJeQEKqtFh7dDL
	VxP5Jb7nV18XhVxH9dWXwGWk1ILOD7E6gnuTTdcv3ZODw52L8JKUl48umtbjq0hS27cfZa
	w6WdjTZNpsPK7qPRq+JObAb5BzYsUVE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDfq3ESV;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790681595;
	b=b42ECiHNGTGsCYuPbmKh6II1I0yGOOD763zRFs7fzf2hxrDdnYmnvUHFfWLIQuFqIBxqff
	ktsVBQ3gYGKD3qDWTbONThK537C097ROT5RN5+9R5wN22nVeTM01XUi/YAS4h0M+hgjNEU
	kbota1JTV8tHTLO820KDZlUO1xeExq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5955860008;
	Tue, 29 Sep 2026 11:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998C31F000FF;
	Tue, 29 Sep 2026 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790681595;
	bh=e+gknYVW9XCp81xeC0RXx9vcOUHAJigZEtqY/xe8b6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eDfq3ESVa10xLkpSv+CeI5FF1JUQktUhny83NdvHPN+F/Gsl0SORQ8nYLanhlRObL
	 3rtdxQBVjPAYI6hiVUnHd2NqzqZjFK+DdiO30XeURd23enxO2BENrhbozvNTo5RMYo
	 MYRqeYSyedXYG4xB4W19ElcDnoU1dp5FvngYHL6+vLcL7hF3RwBnN7qcbNHBTDS8zJ
	 G4jFmbmUNbbCax96iFWSepuDD2HCv4SUjvmjwVLpy5ix5REIGjVm+psvkgOeJbOSOT
	 dtC2VTT9NqBZqFMgmDJbtzbdP8r2tD9CXrS2Vf0OI6pkF21ISs5ROETw/aW89lfLlc
	 xH4NbBNe8Tgjg==
Date: Tue, 29 Sep 2026 12:33:07 +0100
From: Will Deacon <will@kernel.org>
To: sumit.garg@kernel.org
Cc: brendan.jackman@linux.dev, Vincent Donnefort <vdonnefort@google.com>,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <aruh86rd5FMv2i9G@willie-the-truck>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <are21BjeS1O3RYE3@sumit-xelite>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC4BFC0005
X-Rspam-User: 
X-Stat-Signature: w3g6dw8g7wakx3z5nt9w6b9917o8nzm1
X-HE-Tag: 1790681595-244894
X-HE-Meta: U2FsdGVkX1+2TSXpIcWD6lDTcvWQdZgKj4cKzqF4cMG82X+cUxC6EtFPe0qa19IVkmJIBe1mwIvChGZwECa/prbCElBpvjecWPXdLpK+f8s/z4+C5EybD41v3b/ySoVnk9eWDLNZmYg3bn7L48Qf4sXK33NQgT4Ni8oMLlqL49sZB5IagyXQjoAwMCk04I6RCN3lOE3JCxh7jDPJNJs+2rexhreuNgpNl7N7Y+IO1R7N+qDDP8z593YjglSLn2bn1mRaDi+3oWAMnIJ0XVgqopMpf7jvfkLAwGJKk/qTKFMhFJQFRE/QDMNdkttCKR6nM+9slRZJoqLZrYI2kV2KgQLQrgQxVFdFPZ9N0B9E/MPmD2HSp3MaGESXPSo/wCAV3Kd65rb/M3oR1mUZ/2vpgZrXgsKBLZLxAublPFQGVKfcu+oCgsj/WPXcQDYGw5qt3vI43FQtzjmeXU/Pnyb7MHOPPSdJWoYvxou0aFwywXqdXqP+jsXYB+/i2AlwNgEMvnl3ATrfphPtfmPAGz+DlYIw7WCVG/dDs2a2O0N793RXJXjRGbriujmfkZtEKt4bhnEK/LDf5czk023yA6SIzo5uDKMsqt6IF7G5FfTTc1tRf3cfQngH7NWH5zaI8Z15ekuyJxs0h7zQ+T8gS9Av10BHyw4/RHqKonTE8pjgRmUUR4t5Dn/xkdFqxfSb0S3LgqiJ4cnbBCqUFubOFVMrNJR9KFfb/cwsV06om0AEeakV4cl7cOfwXIlOark9vwjQz/FdbtsINId+VDQSkrXsytmro4Tn9p3ZXzEeZ3YOW587MFzEPBaPJ0PrqW82SJ32Kld7PtVBVnIyigUsb5CWFyKI9lbofA/QAcgOK1oPp60tqDc3ptEFNq9KhIBwxMjIfg7eO5QcBiLHA6PrAxbfQWcK6Ot75wb/8JP6Xd+2K83gq99GZeyvb9PkmlvIw5yhi8cRm0WvzzfjpM5qEtb
 OcGN9tlj
 2ieWtQivTdkG8NuFaOrokVRK/XETOUz3zQqlFYc2DaL5Yz4S6F74p3ytt+Xpzg7vAoGvOoeToGY5y00EznMQ+gA084OWJfAPCo3792jE1VWG6DymgRbiqaEjY5pFy7JNBYahDBzmZbxl73DILsUwU0flE4IBQ+1+l79Q1WSutpuCPibVrtSGDurT4rIfgbw45NbN4Ce6i/HgmzESYDzro9aFY0Ipa11bfQdHNxVYIW5IX06kzgF3saFQASeZLJcQnFGixO2O0w7org+cNJbJr0oajnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
> Looks like you dropped me from your reply.

Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
CC list to To: and drops you. I suspect the same thing happened to Thierry
when he replied here:

https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/

I can't figure out why that's happening :/
I manually tried to fix the To: and Cc: lines in this message.

> On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
> > I spoke to Brendan at LPC (?) last year but this doesn't really work
> > for arm64 because it relies on being able to unmap arbitrary parts of
> > the linear map, which isn't generally possible unless you force pte-level
> > mappings for everything, which is prohibitive for perf/power.
> 
> As per the cover letter it's about allocating pages that are not present
> in the direct map. This essentially fits the protected DMABufs use-case
> where we don't want any kernel mapping to exist at any time. Bufers
> allocated from protected DMABufs are only meant to be accessed by the
> TEE implementation or HW accelerators like in the secure media pipeline.

That sounds like it should probably build on top of this series, then.
You could allocate the DMABufs from a CMA region that has no linear alias.

> > Vincent's series tackles that by using a pool so that only that part of
> > memory requires the pte-level mappings in the linear map. That's the
> > whole point of it, so I don't think it makes sense to drop it in favour
> > of Brendan's approach (which doesn't work).
> > 
> 
> For protected DMABufs, we even don't require any pte-level mappings in
> linear map. The whole idea of mapping and unmapping is just a bottleneck
> for performance sensitive secure media pipeline use-cases. That's why if
> we can support __GFP_UNMAPPED with the memory allocator on arm64 would
> be the best fit for this use-case.

The point is that you will require pte-level mappings for the linear map
if you want to unmap from it at runtime on arm64. If you don't, then you
can end up needing to split a block mapping (e.g. pmd-level) when you
decide to unmap only part of it and there isn't a safe way to do that on
arm64 without transiently unmapping the entire block, which can lead to
fatal translation faults during that window.

> Now the question is why arm64 can't support __GFP_UNMAPPED similar to
> how Brendan is doing it for x86?

Because arm64 != x86? Presumably x86 doesn't have the strict
break-before-make requirements we have on arm64.

Will

