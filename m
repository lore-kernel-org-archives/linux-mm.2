Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C619AD6CFA5
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FCC6B0357; Thu, 22 Jan 2026 16:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD016B0358; Thu, 22 Jan 2026 16:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A456B0359; Thu, 22 Jan 2026 16:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25F16B0357
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:12:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 978B013D1DC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:12:31 +0000 (UTC)
X-FDA: 84360848502.27.7EFD25A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4206A0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:12:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cxBUblBF;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769116350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYfdqvT319RBpVhEW8fYIHSKc/aCjfRP65K3l5ZbsKg=;
	b=z1SLsHj6Q/F1NZBVl9tyTVvTBkRTsN0f53mDOYnLebj9TWEiQXvw7h8S0ODYgcM6RcSN85
	VaHl/IVGndq+pavXOCbvF1hfB0psYOJ9P/FzycALDJ3oc0t/C749KzrM93EmGGc4spVlIS
	7DfRA8v69ANrXR4k8EERZXrIRYyHnPI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cxBUblBF;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769116350; a=rsa-sha256;
	cv=none;
	b=2gXt0VVCjFPvqNpVy16Iy6UuaZ0rGX/vSZHC4ooJqUE6y6RiybK7gurnoq6pMhU3RUs77U
	/6mSw2C208H9LAh3sL2tb8DuvSWQc9OFdt4QtNVdjPwi86LoXhqAaQTFhsYkO49X/XELRf
	kp3cGMrGVpUKTHs+YfaLeERJdH460i8=
Date: Thu, 22 Jan 2026 13:12:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769116347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kYfdqvT319RBpVhEW8fYIHSKc/aCjfRP65K3l5ZbsKg=;
	b=cxBUblBFrRAcJdIrrBvrIM5okSmViN9tTDjm3kNwm7aSn8F/wSRIPfTKe4rFBn2RX/d7ri
	OSWCnaCrtzQjThsFELOlHHpm8wTMiT1MlEzBGf9x8PG1iDdmuTaCn99BxKvrMnNIsW7SiT
	4ySESML89TrncBDHVusXxo5XuMd0kRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	inwardvessel@gmail.com
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
Message-ID: <aXKRIOpDrZG37_wz@linux.dev>
References: <20260110042249.31960-1-jianyuew@nvidia.com>
 <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 966m7pymrj585sh4xf6mu3dbcu68k1gf
X-Rspamd-Queue-Id: A4206A0005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769116349-108874
X-HE-Meta: U2FsdGVkX19He/kOtd3Ajtv6yn3VdZg3Bq4aJXt66UUuCXOmcV4kKATtcjrn2b1BP+1e/e6xdNkQEHQ3wesCsklKfI0aGtHwo7lXYl1RbVTTzlsLijVC3So2hhLRio4Mwj6aSQPkV8ID4vScjrvRdmkQlLcdMJ43wEzD+lVVw8saO8qIcW6bznhFiAqtyYf85muNY+rMexOmc58BdvUyvipSmEnc/ooQH4pRSAS2WlRq+LZTxM9438yAbbJZxGTER1VohOCqdBJG/KpcyBtxSeW0zpv3Bf8HAnIcW058hdXcE35tr/8y2QO/hPP+CKLsIigZJaYW6p74C2x3S0JbVreccXN5vkRcW/xwHOE2UEHS4aP9WCXoifADLF9z7dA7Kjd9PHNwL4aqNWiQmC3lmG7MO1UobyO5hkrUUwty+ozI+tLAT0RD2CIdxA6ONvnH21X/jFjTXZPol1JNGEWwPUiQUZREn3IPhp2CFqQSQQywELw7vGwEPpHvHwuLR4b1O01y9mRhM5VHGVqmHn4OxBQH/lgE2EsJO96zAMZlerFr+Z8VryPi71yaIBbJifk4gFSl9o1cpxYnugC0hLbaBR55ngfPWhJg/T2c4cWTA+eQM4M8AgZIPpSvsR7OND+ul+BAoaWNurJxBX8Hq/OSeWI2Ob8erSTJscw2Z332nfHslT3H1yoDxKNCEDFj9PE0dUF4YZo3PDmk5G6ns/pYv4Rgwe1B/GK0Sxiwst5qLrhTJvfExedS9tuudWt7GQ8jlSSJ2QxLhfofGFrxCCxgtxJD0CaZ6CC2Go3kjHRtMJg8WD5FIyUXvQ57l1M3ZTkWax32nq/lrdUAzW/g9sM15Nj9I11HOqhSo2ujcYasdBDJLg7n2EsY3+3DCL+qrD7S7kJmoYjan5tt8H7m5R9EU+0gNXokvwmQXnpHm14JRFGc/0I14tNQZBM+V73/FZ3ORa/XJxXwGHVhlrsgSox
 wt7lTtbm
 HaE7CGEa03m3zqd8F2w0SRVE6Gc5ysR9eEcavyD0bPr5x5ZyiGvyPLMLRvRMVSsD+hJH7eq/DKaOh13TCWU7r0aj+PWmUvoqxoN02XoIwrx1U/WB4tsJO7AN4jFvU7tEYSn42ci3hzXWmjwk810KEv2dCCjwxLgh1lGQrrKc6umhmtriYTQoz4/90W4kwe81oPZw33n7VbUm0jFGHVEF0rgkqCZKwhGsgveJKV9Tj5wcqJL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:13:51AM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 19:42:42 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:
> 
> > Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> > printf parsing in memcg stats output.
> > 
> > Key changes:
> > - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> > - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> > - Update __memory_events_show(), swap_events_show(),
> >   memory_stat_format(), memory_numa_stat_show(), and related helpers
> > - Introduce local variables to improve readability and reduce line length
> > 
> > Performance:
> > - 1M reads of memory.stat+memory.numa_stat
> > - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> > - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> So the tl;dr here is "vfprintf() is slow". 
> 
> It's quite a large change, although not a complex one.
> 
> Do we need to change so much?  Would some subset of these changes
> provide most of the benefit?
> 
> It does rather uglify things so there's a risk that helpful people will
> send "cleanups" which switch back to using *printf*.  Explanatory code
> comments would help prevent that but we'd need a lot of them.
> 
> I dunno, what do people think?  Does the benefit justify the change?

It does come with significant benefit but there is no urgency and we can
definitely decrease the ugliness. JP told me he has some ideas to
improve this.

Andrew, let's skip this patch for the upcoming merge window and you can
drop it from mm-tree if it is a burden.


