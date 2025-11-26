Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631E2D116E0
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 23:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6096B000E; Wed, 26 Nov 2025 18:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DBA6B0012; Wed, 26 Nov 2025 18:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAEE6B0022; Wed, 26 Nov 2025 18:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEA46B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:51:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BF5EB9DD3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:51:41 +0000 (UTC)
X-FDA: 84154408002.13.6B80AC3
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B1981A0004
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:51:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=n1nD1sho;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764201099;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkC4EC2zssMx28s9No60sCNue+peZIp/avGbOKBlk10=;
	b=mvTGOqII6UiDTk3eQVjM48/aUXmryF0RFhPE9x9N2fbMAhUGL/Jt2I88p6kfKXo/riJonH
	WZkNpy6rhXEi2a7dk7tvOupoDOHxQ8NXfW+fqPsFFaG52AqW16w8LfVO9gIfQxKFVTCOk8
	pKhHC00GvH2EU1W8jOX/qJeKRBBVWO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764201099; a=rsa-sha256;
	cv=none;
	b=pSi32IcbVuLUGSfu3PdUJRXu6B4C0dEsY6i/Ecsfe6tYoGcKQGd4rNDa7zjk4szXTYRTDX
	QDLWF/wZRFTqpUQZMYF+VAdEd2cUDx7qf80XoeFgK8NPlcQlwyhcwTALb0BYDYuwoeru0h
	X3ZNKIUjrConUwj/hNbbij0f93vpzqQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=n1nD1sho;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wkC4EC2zssMx28s9No60sCNue+peZIp/avGbOKBlk10=; b=n1nD1shoa5nvuzhDtF44Purkpc
	5bjbZrX5nCdzonSHSYJqpHMlADRQU+VwdfC5fXQJk4ojTO3bemQGJkJw4CtbUfR3/1ghTrFjzhzLX
	xyxRHWbxXcWc/dcbMkci+w69UUeqkccHLZw+oxDejQ0dfn9XN7hKH3lGMnDlRq24PyViwiT8WzOce
	q2moRs0tG+D5MF9A0E0YYwDfqx8PGiMrkbyZL8OzaYBxQXeFNUwufzjmsRtaWbHmJMdD6AyCQLs21
	KjxSQ2LIwidiH62xuLMZf1PIo8EYJ2NeqssUZH5KpjxYnGZXyeoC6X9sAxibDbEo/JmThxsV/WJUM
	r/WQtNxg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOPII-00000006Ijc-3QlD;
	Wed, 26 Nov 2025 23:51:30 +0000
Date: Wed, 26 Nov 2025 23:51:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: david laight <david.laight@runbox.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Xie Yuanbin <xieyuanbin1@huawei.com>, brauner@kernel.org,
	jack@suse.cz, will@kernel.org, nico@fluxnic.net,
	akpm@linux-foundation.org, hch@lst.de, jack@suse.com,
	wozizhi@huaweicloud.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126235130.GG3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
 <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
 <20251126192640.GD3538@ZenIV>
 <aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
 <20251126200221.GE3538@ZenIV>
 <20251126222505.1638a66d@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126222505.1638a66d@pumpkin>
X-Rspamd-Queue-Id: 4B1981A0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 3aexismwc51h6beaf1u7ufamdadigbpb
X-HE-Tag: 1764201099-380680
X-HE-Meta: U2FsdGVkX18vQIrAUP02bPwoxxrtnnUZ6DOH573G8f/FCag3CMslSN+qNnqqbqXoAFwACx5HvjK8lVgzIbD6TG1V+sLrukO4F952bAE9jS+gMgEvHyfVuJDmCIe/G5X3NW8BzA94+hBoLisCnN7VxI1pN2h6FLjz6vnseJ/vdVRe4jKzpaCksMvQ7Y66Bkak0WHYb9OnL0kao4gDah/6lMoeI1RjqbTwuybhmXHDQL+kp4LNOVkqwjfFCqtr5JcsQA6QdlcZLwZfyv8C0YbLTj9NZcRf1IUwaIxfsijqXzG5CtIDttl2ecWQLKB/t8IC91aD20FK3lp8zkdmo+LNL4VLWBiTjx6ufDzLwJ7n+ICdtjD9Jhdms/0oYpirUn4l9ipj4higCVazxBrL+QCCWRPACZ5fIGCBG+uY5yaV4FNeU9nWAuzDiydcuQwmfDumtX/wMB6nLbnVOCL9ig8NcyW/RGLPjZE+/TT5BHvywbuehLynHIrc8cjO9E0PFFRwVq8fuRoR8iQWRCsDaT03GtRSM/TaaAOeadk5fqDzty2Ay3TxwjAxaCWJ7GIrSt4Fb4wedRsyZ+C6jLGV8SXfiSzauwewiPHEnAllUCA0TrLiTglqx+iciYHs5uoCOXWcZwtCEXQ64gZGtZLKAWqVOog8eGA73hobXqK2jGquPWkjEIxVVB49D3LB9/ax+pIRTvknACy9PBhyzVww+Q1phpe8bEwG3Jc10xDvbOMWKJTMDgQtdxvfpTPK48KUIzAEwEaTWWVB+TVPVFAIB8GqSkUQ4oXDXY/AexHc48SiVuaFq/hI0ClH1w+ywGivhWshJW3TW3Sgerez36/es2jxI/DHTXdYIxSBMHIr7vK1bQbuDV/kp2ga2sCA5WGKhtG78nrc0eH3qgKEc/espKM6bSnaiek0yRV7QXiBMPAk3Fm8I45fkBNWu/EcKTWjIUpBWk6KxaaNR+6oUUN1+D9
 oRgFRBqK
 19u/qQIc1vWZTO2tUFz30ioPhkR+V9byFI3dvdS2RdTKpmpr2VpE80WDuCISBUI1YW50ma7gRm6RY3d/nvaVxyVpwMEeoC5Dn8SHoeZlVAuCRTouU0lAA6N+Vo4DkWcZOHXv5xacCDXEg8ZGffof9ThtNz6QFfFHSwVTcu41QecaBHQjcw+Qk4YVa91p4JnVyPwxhEfVn/pJTxMEAbGs0UyhO5CeP9gXfoANpOEAzrt/ADBxKSz5gM5u8BHwb779ICWr2ep0YHgAwqM1k5L+HfTDuEPvg274iCn5ZPRB9TqAbWyZB2keQ0YuGu0Uhg7ki9lEoAlR13YE+OINCNcwj9OSJmDEsmf2hcEYqhZNXOMnmTaYnFt1G46kxPxyfwUemqE+eG4IFSQOtMuxrjWLqHMqWxV69qM5DYJ01XjOpiJdymXSjuGO4badBNEDxLTo5G3NL+InIFejWiIuwHn20KseJtx2+0Fp1Wvx7HJGi7h26JDQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 10:25:05PM +0000, david laight wrote:

> Can you fix it with a flag on the exception table entry that means
> 'don't try to fault in a page'?
> 
> I think the logic would be the same as 'disabling pagefaults', just
> checking a different flag.
> After all the fault itself happens in both cases.

The problem is getting to the point where you search the exception table
without blocking.

x86 #PF had been done that way from well before the point when
load_unaligned_zeropad() had been introduced, so everything worked
there from the very beginning.

arm and arm64, OTOH, were different - there had been logics for
"if trylock fails, check if we are in kernel space and have no
matching exception table entry; bugger off if so, otherwise we
are safe to grab mmap_sem - it's something like get_user() and
we *want* mmap_sem there", but it did exactly the wrong thing for
this case.

The only thing that prevented serious breakage from the very beginning
was that these faults are very rare - and hard to arrange without
KFENCE.  So it didn't blow up.  In 2017 arm64 side of problem had
been spotted and (hopefully) fixed.  arm counterpart stayed unnoticed
(perhaps for the lack of good reproducer) until now.

Most of the faults are from userland code, obviously, so we don't
want to search through the exception table on the common path.
So hanging that on a flag in exception table entry is not a good
idea - we need a cheaper predicate checked first.

x86 starts with separating the fault on kernel address from that on
userland; we are not going anywhere near mmap_sem (and VMAs in general)
in the former case and that's where load_unaligned_zeropad() faults
end up.  arm64 fix consisted of using do_translation_fault() instead
of do_page_fault(), with the former falling back to the latter for
userland addresses and using do_bad_area() for kernel ones.
Assuming that the way it's hooked up covers everything, we should
be fine there.

One potential problem _might_ be with the next PTE present, but
write-only.  Note that it has to cope with symlink bodies as well
and those might come from page cache rather than kmem_cache_alloc().
I'm nowhere near being uptodate on arm64 virtual memory setup, though,
so take that with a cartload of salt...

