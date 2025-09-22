Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C10DCAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D74C8E0006; Mon, 22 Sep 2025 05:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988278E0001; Mon, 22 Sep 2025 05:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E468E0006; Mon, 22 Sep 2025 05:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76C348E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:45:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB8E21199EE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:45:22 +0000 (UTC)
X-FDA: 83916403284.06.8525B21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5CA7C140010
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:45:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDEa3ciO;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758534321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6kGXerqfd0vSg53QavRXmh6XHC8JG3TW/ZkICij4qM=;
	b=npN+3meYZ42ibSH9hKDeWF/Z0aeBOPWLxFqxTInwJrABeUkM/0Gr3kqsVT5G3gkD/bHxZX
	KognrW/U7vYpGSwEkVEi457fOVzF0oCO8h64f5uL286FL0+GQqsaHuWOiUpxDStu+pkxGX
	xaBvowTlNSvglre6omZYIYWoa51jLxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758534321; a=rsa-sha256;
	cv=none;
	b=i3O8ovoOv9CsKY9B+MCFMFSKa71ugvHl/AGy5yWrKt7DvTfyeO28od99DQCR5XTNoq7Lm9
	X9mZWeA0z+m+rQTx1Zs2pOULXhhfolQq/fgWA/AiYA3lzbGmRUWPpvkufBsdkwEDWJq21D
	Sp/YMdNejdJ5a1Miz3kEYuwtrIJGHv0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDEa3ciO;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5B39601FD;
	Mon, 22 Sep 2025 09:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EADBC4CEF0;
	Mon, 22 Sep 2025 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758534320;
	bh=hdfRT2uy44XDHp2YpNE/KGcCQuuBYA4VB2AZtgCJD4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDEa3ciO/uGMbDaO5Ar6pxZcGSvMnhdw7agtbXBLDKnkmkrf0bgw1MDOz+TSJX6I7
	 Vmmd9aTinZqOQYdsjJkNALe5NhemddYM1ubWJfygFFxgEyaATwZtwjFwkn/TgKUlgj
	 yfBCM3qPHtE6bmTUpdvsVM8axCuRANP1jlwdKKv4gTGbff3BUBVFtMLUKfsPkUp6qE
	 nNnZ8UVOP/q+0Wo7Xqt+lSZz+6RalvqD3cDUqEp12vqrZLkx+ILil7aZo8PoIbnkPw
	 KrQ2hi0MGo0vIhiIDJ4xi5tf/tzbnVwZGfeJIYm9bP6KVOkqjkwwTQI5c/ytny3BAY
	 MjnbjTP/JUaEA==
From: SeongJae Park <sj@kernel.org>
To: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread operations
Date: Mon, 22 Sep 2025 02:45:17 -0700
Message-Id: <20250922094517.58153-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <LV3PR11MB8768BC4A1DF99E07DE49FAD8F512A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CA7C140010
X-Stat-Signature: japj7dfbrraxh7oiw3t856fqrcqm84oq
X-Rspam-User: 
X-HE-Tag: 1758534321-340100
X-HE-Meta: U2FsdGVkX19vBgYcfxIfvQWLcN4ZGb0ECnNjadABw9PLm6iUm7YTOBUsVssKAlbqmiO2xb8Q+4MidSZcJUczDIg+oefiCVJx7t9fftvibW9fMx8WESgLioaxVkRf850tGXrO3OUyoN0ki1qXzWUtFypX6tUkmTGURAIR4Km2tGJv54jJuLwCHjTyJ9p+ZFErgMTh1yMg0n0HBjZwby5HjhoYf/Z8gv/DURBv4MQYOuzU1clYKVMawkmL75YvgyZ43ZZD7Bds2/s3PDsyPiJ+P14VWmPz2gsXXSi43Ncn/w73plKiO9u1RQmxDz9StKqTk0BEIhGsQuRRCdMkV2Jmcgn2CLItZtAu/uii2ESkOIEiAMj34VIK1iER/w+VwexKgXO5jNfSb/rewpKCnxQOiz4ecYNIrw6P/XeKrf5ey9OcUWJxHgfMDWhfWSx8u2z2imlys1TfNyVTEBgAYMI4AOq+FGxtpuiy/qIxeqcv10tDEj7zDHbfyfIotolHJQ0POuIw0p1DDGjDqFL6hfT2ZvsTD3e1pKTgBIaQLhYpjBN17PVca2Ms4EM9XaerBSZNM4bOYaeazkSpD/7/mQsrB9PNprg7Fw5RzY3IgtYcmzMw7vl6UPREM6aY+kXJUwJ3ztraN/qKzTVerWz9GVAvu9kVJLYA4BoJgl15dc4mPPBo3uYKMnj29YfAO1OVZHGaLC52HBxo6yRoabLSLguvQridYKM7hZgC0FFsKViRN2k3J2UqCQoFhe0cojwFe8tHkTzafb9BBz+Y/Q4qGk88UmpEfeT6QVLulAf1QMecme87w2ieymdAl3occ6pZbOssWYdSpfFLDSCo0t1kie4ITHpko3ICm5ECiKc+z+QQ6O3S7WHQ2x9M6R1F00QEd0gOdGo+V4+S3rl9lcjbv4ew+zoIJWoAGbdm8Iwo7KYg1T8J/SV+yJswB0lKQvt6InCx5NpOnBXh7DfACzKCF98
 DpkFLDCr
 HopyLR7xI1+IygJI6+KLq0yHOwkELdHdTAlylAEnZY/XKmom/ZQ4f8Ee9n087Wa7K9bxAfk0v4h4WwEqedeXYDuIGARPb2weDQEEGtyFXLY4JqBmU8AQg79j1BSaNkgrB6IaMldvJFGfHbD6vgqDtUYs+LUfEqhiwa2sZaaUDj6Dn2I/ikbsS3SoVRHneQLKRHIB112RcmF8jY4O1NnhoBUUI7ZiS+YGNLtkY+TpI3MHgjcAUv4qfEjH8Iw9vFfnIh4w2HtQcrjuuJaxOcHGAcAVYOL9kNnu69QYm/NOck+eZ5cI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 02:40:11 +0000 "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com> wrote:

> On Fri, 29 Aug 2025, SeongJae Park wrote:
> > On Fri, 29 Aug 2025 15:29:47 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:
> > 
> > > The fread() calls in read_slab_obj() and read_debug_slab_obj() can 
> > > read up to sizeof(buffer) bytes, but then unconditionally write a null 
> > > terminator at buffer[l]. If fread() returns sizeof(buffer), this 
> > > writes beyond the allocated buffer boundaries.
> > > 
> > > Fix by limiting reads to sizeof(buffer) - 1 bytes in both functions, 
> > > ensuring space is always reserved for null termination. This prevents 
> > > buffer overflows while maintaining proper string handling.
> > > 
> > > Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> > 
> > Acked-by: SeongJae Park <sj@kernel.org>
> > 
> > 
> > Thanks,
> > SJ
> 
> Hi SeongJae,
> 
> Thank you for the Acked-by! 
> 
> Since this patch has received your acknowledgment, are we going to merge this 
> patch? Should I expect it to be picked up for the next kernel release, or 
> are there any additional steps needed from my side?

I'm not a maintainer or a reviewr of slabinfo, so my Acked-by: doesn't mean
many things.  I think the next steps and decisions are up to Andrew.

And I think Andrew should be busy for the preparation of the next merge window.
I'd suggest pinging Andrew again, after the next MM pull requests for 6.18-rc1
are done.


Thanks,
SJ

[...]

