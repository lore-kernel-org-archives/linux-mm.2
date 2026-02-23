Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BB8EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C282D6B0005; Mon, 23 Feb 2026 14:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2C06B0089; Mon, 23 Feb 2026 14:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C996B008A; Mon, 23 Feb 2026 14:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4856B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:33:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47B8E1C1F3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:33:35 +0000 (UTC)
X-FDA: 84476720790.17.BF9F51C
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 660C01A0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:33:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YULXbRD4;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875213; a=rsa-sha256;
	cv=none;
	b=fXh8bpHbC/4N19vgdyhSlDUwqOg/zyNyY6UD3p01TovV9D2BZuEcb8Lng9don1oKdIWCO7
	kE893cHqBpHhzWX8OyR+DIpP5q9VUVgh5Knqib3cfJS4oQMaOQBQtb3PZ3t1Bvzp9D4jmu
	SVfWrZxHMFIcyPO+Z0XDnwb4g13docU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YULXbRD4;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtNSHW/b265W1kLR/SmhQJYrrQY0IXE1Gxp2ymx0KdM=;
	b=GXHzMqZw2TcuBhc6cXXnOom7/xCCXhPcU8m8pcKepVBclwdYRc1KuW0xK8BOXvh9JTDyxB
	ZzKG6I4GwwXGhHxCnUfMDe++UcxexKm64yKsHQIHUQp0BTxexkZidKvUC3AcwfcSl/7NTm
	dFfkqwFb+6oQnjlwrKMdpH4GzYYj5GU=
Date: Mon, 23 Feb 2026 11:33:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771875210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtNSHW/b265W1kLR/SmhQJYrrQY0IXE1Gxp2ymx0KdM=;
	b=YULXbRD4qhttVJj7wp9uK8Mc2g3wq0ncrNWHqsk3xpPUiy1xnYgb3yVWfaDxeF0Zt/Ahsr
	Eyc06LzZ9KCfvEwEWIivVoPDQSUvMMZWZeg0q0eKlQtBPMi3Umu/dTUzH0gGUJOmLCi2gA
	88CBS3hjLB9frMgeob9TPmtqkpObpuY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org, rostedt@goodmis.org, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v7 1/3] tracing: Add __event_in_*irq() helpers
Message-ID: <aZyrZ5c4dk_eshGM@linux.dev>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-2-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223171544.4750-2-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 660C01A0012
X-Stat-Signature: kq5nh7pqjazmttka4kui7yua1q3zeh7e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771875213-959100
X-HE-Meta: U2FsdGVkX1+I0l1f8Zre6jTqtjzD11PFyha6YZ4xRzYXmpT5tus7fuhlxknN+u1urNP7gwPQOkgf5DIxg0Qfdxa9Q1OBMSmJvJFdePUODjqPwzzjAL1Y84Kw/crlm+zkfDIj6JYarct2osMWkRC1UH44kAjzLqBH4Tolo5VH7qS/pSFTuZo9hkkCgnMKQQGSzADQ/gRSsFCBpGdFoQiE8AC78BWuXGnfiWJyqgdDhKBvVIgmueOpfB9wqX3mWH92np4Z5cd71gkllM+rrY8oaeH3n4fTvAPYhlDS7c6jzORlar5+sTy0GbahVJyvIlYXrMhm5a8Jem2WgDdNoIEmDgcoN3JSdWEvzII4CzAkZHOtT0QyPlBdYHaendTmunnQKG1JnbWGOmDFPO4+ohlWFZ5osRCE0Wcwu7cb7nDMOlmyRp5DTtVZCADzRxRA/8Vn0/+sSwhtgRDQ58sW0XvcrQEjxaXOOm1/DB3V3TDhxsd/qgFNu4j1pes7nlOmjCz+zCTvq7d8AbH9Yz1pDznp3Sl5SgDbnI8w2R+6GxBmxyhdaq3YVi39q03rGBeF47zdROTkVqe4anCbThpEnjylzoOIeCbfs9/vcAT6Z/mIWS7Tj/DjLoURkqoXwwF+TCM9fWJ9fxl6lkHvC0rMP2VOiiHRnUcfX8BRTZ3JXnhp6sqxT0gUXr0L4kUR/Xhdp9VSBPydNHCwZe7ThRBEGkE5ek3f2d+JVhpWjxVLH/2TUzrCdBA2Vp1KN2J+gXA95IY1ix1CWOSiM9CUfLa4xI678UDQBOtt1rKHu+Jq4Wt+x3bgWnxIzlrFdkCKo48uINxNbiSKAnurCXZHP2ypIvhP4HCHACRp2ryXgS8hMR6OWqHxASJ8JMCbWcToSixFoBqRGQXZ5auCx0rjDUcTU0cy3C3feeqltyZnrrUTDoV0LFi/lo0mlFc1Vl34Q6BGdmTOTsBC1S8bR9M1RHp9t6Q
 xNwGtpDz
 twbyxnEvuvll3M/btVgVIZC64qNTKs0zmOM4V5Uka5DbE7mIrypPwaoT8R/XmL6H71kjQc6Ky6bYbXfzF2ditfLbUDFKzQhvIAQx5nMmj7eUZkoHXvwQ2OqI9aIaF8teA9ZLwcOH6eCSztAGC0GmVQsUHuC9p6BmJInzX+y9+aV3nF9h3zRGXGO3T1SDykAPKvlnVpxqeCvs2/z6MGcbc3RweUoAJEdSb/r7eAf/VL+n3ULvs/EdSMosbLI/RWwNUucN3e4z223DkC+7Yacj3OMof2ZUoukuv0qP8IQ4DHUjRzfNkJUwuathtzT2rlB5uQO+HE2mLAVNlCNg6BiYBctFc5saSOaTnoUDr+W522HZBwG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 09:15:42AM -0800, Thomas Ballasi wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Some trace events want to expose in their output if they were triggered in
> an interrupt or softirq context. Instead of recording this in the event
> structure itself, as this information is stored in the flags portion of
> the event header, add helper macros that can be used in the print format:
> 
>   TP_printk("val=%d %s", __entry->val, __event_in_irq() ? "(in-irq)" : "")
> 
> This will output "(in-irq)" for the event in the trace data if the event
> was triggered in hard or soft interrupt context.
> 
> Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

