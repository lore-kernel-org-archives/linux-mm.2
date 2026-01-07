Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017EAD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8686B0099; Wed,  7 Jan 2026 15:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6625D6B009D; Wed,  7 Jan 2026 15:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F216B009E; Wed,  7 Jan 2026 15:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 464C96B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:35:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AD8A1AB059
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:35:35 +0000 (UTC)
X-FDA: 84306323430.18.8357BE9
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84C5CA0014
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:35:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/i757TN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767818133; a=rsa-sha256;
	cv=none;
	b=Zze5y2vKPXfHKs4CU7rDBUwKyNOycftjNSUFDqfzmcgoImJHQuP36FHZ6aa8Z2qtWUMT4O
	DXhH4oVgNiFdSC8DjXsTMmbPmsbkY8wh7MOA162hbIfk4Nfmz9+TERvMaDQI3k4BogQCW7
	CONKZLVgVPGGRPg5fZ+JXCrKwJLsF4o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/i757TN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwCFjFalN2/8s1wbIvxRRJTe8J6YxTX0NCS4gLgdyQE=;
	b=Rxb9YdpqjEEApMVmVHmPkBDCPT1so76PjWdxkZa2iekyWFv9x8SGeeGxebjRdbNGhVsNGH
	lGwIZdEd6I5PDHNzkR5qmHocuG2/VnJlew/4eAtqSzEXz3HfVMd7jXrLfh+WLE0+UUc7hb
	UXnYTvgRORoeq0NrSAhSbNPn/vnPa2Y=
Date: Wed, 7 Jan 2026 12:35:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767818128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BwCFjFalN2/8s1wbIvxRRJTe8J6YxTX0NCS4gLgdyQE=;
	b=s/i757TN1Q+PmiyZqrczqMqOj6PaAuzgQEDneTiRTrmkURkycvc+g6rgbwq8QyvK6BGb5z
	3mTYUHZiUOa1h1n9TUV2izrMQDP8aeHcR6pIoL6ojXnWR+9zdeY3iwM54pRqEAGLEL19/a
	ieDc0mtseSkFb1q4/GX8iftVYeN2z+Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <hpbntcznzgnwxerqzvyrauibecqg2ttgzch5d762mzn3q7dkzr@dm3vp6pnsnjo>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-2-tballasi@linux.microsoft.com>
 <62ia3v3oduyt2srkaneccoei7cwimifwduarteyn2ugpmmbw3p@rivcqvcksgpt>
 <ovqxo2mmjiuymqk36t2xydcyzvtppcqsog62yx3qtwsknbkgzq@3phadh5gfyjd>
 <20260107103208.e64fe3c26d02bfcb21404dd9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107103208.e64fe3c26d02bfcb21404dd9@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84C5CA0014
X-Stat-Signature: xon3gmff6na5eu8ko3qq66mwj6jj8o9x
X-Rspam-User: 
X-HE-Tag: 1767818131-898037
X-HE-Meta: U2FsdGVkX19s1RnICFJwH2SFA9EBHj31SXz7kEhegqPX8q9O/FZpArBgRWESnqRMzs9mS9PnWeP2HaBV5DoGSlzsyFUTfI93aptHkLDPycpguVH3Mc5Ph4awkUlxOJmOltFNayDr8PZ1Vrzhas+spE42qMlJW/4Em6+e/qx6NAWlZp0rjg1uvjVLhn/RfO/6m9n+KCgajNV4Z2JYRjp6vkGiWiouPMPlpINIZX3BuXw7fid3xegxzGx2JFc7EZ3aquNv3LXxJGb3kp9hwITu5ddyaZL8IbQ9kawFxJp4pnNnMjQS/pFJZ5fFSJpFiPJ9TVHtz15JNC7pX5tvWekeSohnJTuR0FX3z/n7gynJnGoUv0dttq0xspOWQkpQLBmAKdTYIWYeiu3iT1UIJivjcP6HrMwYpSCqHITH/akIom/6PZJFgxIquUNWiA0TVP2t6xynrSN9JNopULbD9x5jF5Zn2hQIdrEkp3eJW+3aNUe/cO3i0azUXKsejInfWtruG25qacAFQe7DE9DKj0jU9WgvbKBS9cZl0YqxG8lFnbWX7D6tdWsF8F6QksTDmyYhkOu/tElamDxUYYA6JtGx7YOfHhUgZZFW4W2joIy9a4EMixDh9/yPaoJTpyejfpP/9KUB2UM3FBDRxClvOGY3bOx6PZCmb9tdRE7ce92RPyFZrAWiDPA41ETLQkCS7FJV6bmjH1CuYayQstngqxVQ/bfWy2nNU4lZpiw4t41E5tmfN4UbflIGoLOh1Yfbt4JM2X/DCq/bEJ77avbQ+/mZJI/wCz6bW4JCXks6dCs3IryEqSk/Pz6U5Vgo2L3XIngVDD+vl3xar6NO2UQtrutLrQ4vml3uKIr1R9KvER+xPNbQ6RNafQckdfxTJJ+JU010Cl6va4PamaiIBKdLKu1xLHjXv7Tx2we/sPX5OPGbPubwJ6wsOyYIL0KNTswu5Li1Ly1Nsf2pLCICG/Ik4rG
 72z52Xzp
 WiHomAbTP2mQIzoTf9RNoNMWIoBuvtEcL0u8iPTipJEd36DR8tdZGIn0wRQWnSqweg9rUKQPcpP6lQ3EIBNH3Tk+V/YlnZO6gND6OsehVHtGKkzdYja6CO8J0f8HOVnXmlGofILJCwj2X19NfGMXXD2nXDtcHZGqJVGLJMsO1MYgFwC+LKUdFJRGpynFsh/zBicGH5ClfNOZEWOgM73QZXXIdaLEPabtsEUsK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:32:08AM -0800, Andrew Morton wrote:
> On Wed, 7 Jan 2026 10:14:53 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Mon, Jan 05, 2026 at 02:46:39PM -0800, Shakeel Butt wrote:
> > [...]
> > > 
> > > Orthogonally I am cleaning up memcg id usage and after that cleanup,
> > > mem_cgroup_id() would be preferred way to get the ID. No need to do
> > > anything now as I will cleanup this usage later as well.
> > 
> > The series has been landed in mm-new. Please use mem_cgroup_id() instead
> > of cgroup_id(memcg->css.cgroup).
> 
> fyi, I removed this series yesterday due to a CONFIG_MEMCG=n build failure.

Oh sorry, I meant my series [1] landed in mm-new and with that Thomas
can directly use mem_cgroup_id() without worrying about CONFIG_MEMCG=n.

[1] https://lkml.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev

