Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E46E6BF2F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 18:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840436B0088; Fri, 30 Jan 2026 13:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4106B0089; Fri, 30 Jan 2026 13:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF5F6B008A; Fri, 30 Jan 2026 13:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD346B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:02:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13186D4C29
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:02:18 +0000 (UTC)
X-FDA: 84389399556.22.2369EAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 676BB8000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:02:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IXfWF+Eb;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769796136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmGSi/m2wCr3AWBhZ5dFTLpKvJzPsS5WnnxMh+jR0/8=;
	b=EewQFkZWbPAMq+XX52YNFn4cXaqo2tBAAFZgDceUjkLRxjZV3C4UlqeJO+MEfmOXer+35t
	2E7Q9agben3u87KvjAbcHYBimhpv3VECIt/6WB0g6p77YgNVNrnO/i2fxDEjmmkw3e4jFx
	Ydz9v4uInQj5NjxQm5dHNhrpt/3MSK4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IXfWF+Eb;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769796136; a=rsa-sha256;
	cv=none;
	b=el4hxV7TLSAVJyhP4BCrfz9fZpDecTeksPv4+pyfy/Ajr9jRCfHMF9QwZNOsSVTR6OYJsp
	vUHzosLeAlRBmDkj0vvYJLit2w0Emdclas8xNNoTYlIqhwcTO7KDyUs0/VgtQ/ld83z8DV
	ZT46HBysAPbmtOAvILPiR5cDd6Yqd/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 382586001A;
	Fri, 30 Jan 2026 18:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663C5C116C6;
	Fri, 30 Jan 2026 18:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769796133;
	bh=GkPfhZNy4v37hIGDotZeCuD9mCNHLcE+cuTB3+wI914=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IXfWF+EbecoU0pgM7B+mRYloF0rvlkPEnOavouSEo+EpSfkHpiA8EMis5IvvjZ44D
	 yudmu3SItHvXjN5+XaNyqw95rLplMYX6df2qSDcqVbquXKBlNUfVsTo7MQmtDl3B7C
	 YLHPg/pWCoYV6+/tyb0EkvGxUjVeM7spmF6vdSD0=
Date: Fri, 30 Jan 2026 10:02:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
 <aliceryhl@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christian Kujau
 <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-Id: <20260130100212.61b66204717cecc40e8750cf@linux-foundation.org>
In-Reply-To: <vb2xas75xigzauqkfey7amtb6ux5oz4vnfxx7u7oks3nzbggy7@eaheqgwtwa34>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
	<20260121164526.2093265-23-Liam.Howlett@oracle.com>
	<bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
	<20260127151548.b57825c664d36fbff70ffa7c@linux-foundation.org>
	<vb2xas75xigzauqkfey7amtb6ux5oz4vnfxx7u7oks3nzbggy7@eaheqgwtwa34>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wuiz4isoonf5sdr5drhkhsi3o3eoe4pc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 676BB8000E
X-HE-Tag: 1769796136-265999
X-HE-Meta: U2FsdGVkX19YU7j9t//3VWAEQSHzPuyVkVJG4DKHvBsmx+mXZGMqxIsxAy0pouSGF93jYDzWUULOYUS/ZfoMD5dv+e8No0t56/ZTYjPWNXqqiGspK9XF1uKq+cjo5u1/yQ3ED/pbMT0C3GHAedrpmWmP3lHWj7WdcPbd59IJXPvFqVvb5wmr0dt826RfbASlF4YoxILyplO08gcunRYbWrCxEwSUC99VWHKkfCKAU+MQd9D+wPNJnxp6CTBoZOnE/AD3baPPDxigUyMzWYa6PJF2mGquq/FpVUOidpZubHRmfEkW8n1X4ukwg8v3pXW7TLQ+H+OkEtS9JBlLhm8FJhdpGM9loHCOu/h21JiIMqkzEg7m2Xcc7BITFurwRA0b39u3s6KDlBkTecu3Xivi76BhZp7q9kJ4gTepSoltXgU45W0wnzK4Iaa6aN06it7eTk6+ByJLe+S5WUz5dhD5tjlb3m49zqdkfYgDYztj7rMI8EAPya4x+Bgo7fRk1Bt0V5RTV5WnKz04S2yDx75L5cmPM1A4zJpsvpQ3s+CS36lfRCJ3Ro23W9FmmFa8N3WaXotl5IHEuMKcilnCPVfQvLEt1eIkZn5I99CIFIj2x8dtzOAqeGbBVLvSCzr/rvmrCZcPreFT73/TMLw5mK6P8L+EpaTNwHMllrqkC3zG5Ur2yn9AS+ixRFeVxLURY37jnGoy5hSk7hocpJX6XHTj51qIL+9iXJt8CipA7W5gDrTVKxkj75yPQOzWGs5i58NxuWApLATSy/WvZDsXMdtfE9u0nCW2REUJTNBUrEKWJqLAq+tL2LhIWi3/d9+b2GrYqnJXnWO8RJ4zrRPSs/nitITdoRpfTZCQWN23KdRRWqoLC7Rd4YnGSakQMjgFZV8dKZ+UIK9fyXNF9xE3GNRs/cSZA9LvYsVvhjQ+X77qrX2+VqNy+dhpBuIGHcPfYAtwqr0a+2TLxyoWhxROLec
 Fh0LOB8o
 3SIANXymV/ZT/CiojtqhPdmAxNREJzhZ2o+3YajrTVeXSyyqVGbAzhA2cqdbLujZxx7/SBNO9Hu+mNAbpj1XHAx+iNhO0cD12VspIOkCjzF6eAHWMlX3telu+1yVyFtTEy/Di7gsqxy/xagkPUVp5i2hvdMJYw7pe9E8qvkfte2sIQjbinq17gvTK8bLLKJ4N4ZmTPZRtHh2KwsB6iufSzI1zoY/jGw5H/gMlvk2b8roY2dtSMXO/AV1dJZCVhdCynCAMgIBqX7Jqa6qdbty/dJA0w9yd8xWH+nS0qNTcgk87lL0qT8QJzyuWO2OG+E678W3z2FAO/nxrAfT4ryaTGHEjy2vrr7aIki0H5htUXwyv4qx1pvOTDuWZXvO++9M01Koo6SIobUqXd0ksZ+Fm4LWnzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 11:42:49 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [260127 18:16]:
> > On Tue, 27 Jan 2026 23:05:48 +0000 Mark Brown <broonie@kernel.org> wrote:
> > 
> > > On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:
> > > > Stop using the maple big node for rebalance operations by changing to
> > > > more align with spanning store.  The rebalance operation needs its own
> > > > data calculation in rebalance_data().
> > > > 
> > > > In the event of too much data, the rebalance tries to push the data
> > > > using push_data_sib().  If there is insufficient data, the rebalance
> > > > operation will rebalance against a sibling (found with rebalance_sib()).
> > > 
> > > I'm seeing a test failure in the LTP linkat02 test on arm64 which we're
> > > also seeing on a range of platforms in the Arm lab.  A NULL pointer
> > > deference is generated handling the syscall in the updated code (log for
> > > the actual next-20260126 commit):
> > 
> > Cool, thanks.
> > 
> > Liam, I'll move this series back into mm-new to avoid disrupting
> > linux-next testing.
> > 
> > 
> 
> I know you like fixup patches on larger sets, but I've done three things
> to the patch set now:
> 
> 1. A small fix for this issue
> 2. Added a new test in its own patch for this issue
> 3. Cleaned up the old compiler pointer warning in a more readable way
> 
> Would you like me to send the delta or a new patch set?

A new patchset works.  I'll send my heres-what-changed-since v2 email to
aid people who reviewed v2 and so you can scan it and think "yup, I
meant to do that".

