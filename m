Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C73FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3F56B00AE; Fri, 24 Apr 2026 10:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273846B00AF; Fri, 24 Apr 2026 10:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162AB6B00B0; Fri, 24 Apr 2026 10:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F247E6B00AE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:19:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93DF91A01B3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:19:35 +0000 (UTC)
X-FDA: 84693657510.06.DD88DC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B685510000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:19:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K0IngNMP;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777040373; a=rsa-sha256;
	cv=none;
	b=ABPlPOXxyb6b2u28Ccy2ikdsoandg3ZFnAJhjrm2SG1Iq3grcrNklDEJcx6FROAmHVs+Eo
	/1jNJ/sMVCJHyI4ex7euv7Qo3GQwWDjDwEAH5AORkmp4v1SZKZ8SKXEDNQbeTMaMqcf2sN
	axvvFs9+luvVEenT8aBr0DIF08O+BGo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K0IngNMP;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBzBZbtGTnLGYQpxva7hiLu4CLuL8IOdg7NebXi7Ifo=;
	b=RyUQxYR+V4ZnrP0DI8YVRPd5lh2SXr9hiHfLL+nwHBnFW/BrEshPvcwp0ROVjqBN8FFzGB
	2IKdvzTuY5voHrbzAJNebkdwV+dqVivBvRuitPUOZKjlLO0/3woEXF/AhFM1+UIsriFpBC
	juBOukA+J4scpzxtGm12wHl0O+K4IxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DAA4345F;
	Fri, 24 Apr 2026 14:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9998C19425;
	Fri, 24 Apr 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777040372;
	bh=XuFBaYFsxNxJuAT5m5PmvNcPPDaWLvDhlZjjhyfsrpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K0IngNMPxAAEI2TDeCeCwYC8Vvs1HT4fE9HmmudRcIoD4y/iMXvym80IhDwFTrdp8
	 tpoHGBsvaugUDeKCl0zBVlNEnGIox0SKjJC6JdaU/xfLm8UNmkH2Nga4F2MYcETzgL
	 KiHKTp/p4Bjyg2u+QwQJqALX+Z+KzikpBS14CJok=
Date: Fri, 24 Apr 2026 07:19:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-trace-kernel@vger.kernel.org>, <aarcange@redhat.com>,
 <anshuman.khandual@arm.com>, <apopple@nvidia.com>, <baohua@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <byungchul@sk.com>,
 <catalin.marinas@arm.com>, <cl@gentwo.org>, <corbet@lwn.net>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <dev.jain@arm.com>,
 <gourry@gourry.net>, <hannes@cmpxchg.org>, <hughd@google.com>,
 <jack@suse.cz>, <jackmanb@google.com>, <jannh@google.com>,
 <jglisse@google.com>, <joshua.hahnjy@gmail.com>, <kas@kernel.org>,
 <lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, <ljs@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <mhiramat@kernel.org>, <mhocko@suse.com>,
 <peterx@redhat.com>, <pfalcato@suse.de>, <rakie.kim@sk.com>,
 <raquini@redhat.com>, <rdunlap@infradead.org>, <richard.weiyang@gmail.com>,
 <rientjes@google.com>, <rostedt@goodmis.org>, <rppt@kernel.org>,
 <ryan.roberts@arm.com>, <shivankg@amd.com>, <sunnanyong@huawei.com>,
 <surenb@google.com>, <thomas.hellstrom@linux.intel.com>, <tiwai@suse.de>,
 <usamaarif642@gmail.com>, <vbabka@suse.cz>, <vishal.moola@gmail.com>,
 <wangkefeng.wang@huawei.com>, <will@kernel.org>, <willy@infradead.org>,
 <yang@os.amperecomputing.com>, <ying.huang@linux.alibaba.com>,
 <ziy@nvidia.com>, <zokeefe@google.com>
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-Id: <20260424071930.62318a9294e07c99ba0ff8a2@linux-foundation.org>
In-Reply-To: <aet4nz/Ljn0kDjDk@gsse-cloud1.jf.intel.com>
References: <20260419185750.260784-1-npache@redhat.com>
	<20260424065828.031775921990de37f83a2468@linux-foundation.org>
	<aet4nz/Ljn0kDjDk@gsse-cloud1.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B685510000D
X-Rspamd-Server: rspam12
X-Stat-Signature: 95fuco4x8stp8c83qk78xs5rij5pzr9f
X-Rspam-User: 
X-HE-Tag: 1777040373-144018
X-HE-Meta: U2FsdGVkX1+Yn/8zeN3iempoCiAmdeFuK9Fg1MJjTv8lLvxoN1uxWgqbOeZfByRQ6UaoFLzRCkoKOkAwbAWCAHi/kbv25A6wtlqnAdyunIKxGB9PLAkhxMysDwaj9uiKlSB1xOrF6K0ecLIfwUaU+eRgmNCKteFkwwjUuqgi2o/sx3TWpvt45KtY5no/bhmq6fzbKXLthEtOci0IM2EU7i+5rJmG9sT/OKSA202/pSxArb3b3hjzA2vu/XzJ9SeCEDmsVKWQGmuaYKpYC7VEP8Cb46NfAigzh95uKwq+0HCQNJ82umuZ8xFja8KYBhXFcLUphKvHu32r0CogaA+nhxVg0FQaLJlOoM2UDGADDIPHNXV4DrBfrnCggiaQ+cpWA3lZQ59CnSA49og70j3inli2/HshS8nUSglZPKAmwSOK07IkAJieER9FAWhQCt/dTHA2iNuTzS4DHbxZ55qVT5z2MIQp8EV3Bb5TStloAZGMKejjeggpkcWabOORpQKIh/z3Z5P0sog5csAuMLEidloDUFJm6oSMBmZgSWnyEoGYyULIvqoBdlR6NEkYh/1a03LJgQcNDxSOG9M2TgH16ZyIiyT9svibQV0tPEmfovTFKiiLLvkr/A26L0g9i3U0u4yR/SrLi3wL/i9/07UBvqrDS9Mq4rEnpWrIZbcOhMZKy2ngWpEQoFgFjZRry11jvlKH111036cnFSrfaLOku+Rq6VAmnoqH8Dr+/h9Yf+6wdKBeHd3mvih/k+/0cHVTO1EO+TAa5/C0vtMZ4PfAO0Gg4i6pIcuhB3WEGEnYRQhPCNwV479WD7dKFMJC6kdtcG5mucxnh14HluPWcasFfHwneOMtG7Jm8Ih2OOHOxceC1Z9/UCIy0lwfuqNCntL/CrS0qpK5DsaD3ck758MrzByPfNNhAd5UWFpjNghSnNnxTaBJ2S7fJnj0X9XpjMj7B/4/Sg6KjFJLLWEJjJh
 pA/4EKyS
 G2mGcexgz+oFI3xsLhjEWV6d4tWDsgWyrE2OeWkXbPc2POmKvOcEMryXhJjV6pj/dresh/hvuwJ81YJH8IUdAxnqRwAIGRhJFdw6tOVELrEiqRhWt56aciFPQZrWeOLzNjri/sYPv2sKN4Icj1K+/d5SBFL+Tb+sWofNxp4h2ltH1KOY5qjKILJtJUkME5MV5rdz1IrZdcX4qVYg95TxsyKYyptdKjGyH21r25+41aHhtizwpq0esSLiS9tTvWpMrAHjw54vRdy58eJ+LgJOR3fWgHKfbPZv+4tTngLDn8NWHeIHVII1FobUkAPfsdXY6T7y6+aR1lKENUe60JymBKCd5cPRbT2+jEEfnCFVk6k9XTSPBnb/Cu/qYCVsbHf9afIv9xEWc34X9UBdtjvzT9V5kPDTS9cE1PlFR0xgJYOf7Dc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 07:05:19 -0700 Matthew Brost <matthew.brost@intel.com> wrote:

> On Fri, Apr 24, 2026 at 06:58:28AM -0700, Andrew Morton wrote:
> > On Sun, 19 Apr 2026 12:57:37 -0600 Nico Pache <npache@redhat.com> wrote:
> > 
> > > The following series provides khugepaged with the capability to collapse
> > > anonymous memory regions to mTHPs.
> > 
> > Lots of stuff here:
> > 	https://sashiko.dev/#/patchset/20260419185750.260784-1-npache@redhat.com
> > 
> > It's going to take some time.  Hopefully worthwhile.
> > 
> > As always, it's useful to hear about the usefulness of the AI review.
> 
> Drive by comment.
> 
> On the DRM side sashiko batting average is about .500 but even on misses
> it is generally is helpful in questioning assumptions made in patches.

Interesting, thanks.

Personally, not adding bugs to Linux is so damn important, I'd be happy
with a lot less than 50%.

> Matt sashiko

"A sashiko mat is a decorative or functional mat, such as a coaster,
table mat, or place mat, made using traditional Japanese, functional,
and meditative embroidery stitching".

So there.

