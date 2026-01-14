Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9F9D31A10
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 04:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52626B008C; Tue, 13 Jan 2026 23:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCD26B0092; Tue, 13 Jan 2026 23:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC106B0093; Tue, 13 Jan 2026 23:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFC1F6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:18:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F539587DA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:18:29 +0000 (UTC)
X-FDA: 84329262738.24.076D802
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id B039D40006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:18:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="M/Ble0jw";
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768364307; a=rsa-sha256;
	cv=none;
	b=Q89Q0Z/b7eet1vDbLZ9Nk35kKgwmWZ2aWKtuD40Df0unvufGpHTiPLUP9US1Gs5rcyu82F
	mr/ha4m3OlQTxqZMYaxcF11g7FENLbY2nvYKSnuRLGH20I9eHkmTPlz4MN1Rjsp/D4qS0A
	nlPsTdQPtbi7Y/YYxTF2piRpKzBXrL8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="M/Ble0jw";
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768364307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBxU2eKSNmP9tO8O5sNS43LQrbMo3ik3+QWCjvr1x9s=;
	b=AJoAKcMwjYLkVp4fAt9DGANRXSpg022MWguq4sAiJ2ZJZ1KsJYfYWHr8ah0DW9itEtXbDY
	z26S2IpGnDit7RZpmFKZSq5QGCu8W6C++C/pxwQqlAwumh8N6FgZmbKbPAbUAkpJ6r2Y74
	cpW/2XdWBF6hnkrE6FTOPpGGfvHnf9E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zBxU2eKSNmP9tO8O5sNS43LQrbMo3ik3+QWCjvr1x9s=; b=M/Ble0jwJPOjujGaAlUGrGXdYX
	igMnEekYGz9MFyjMGCsDBQB63dBGPsdYvnDP37KtN4qqHY/f3Frvuo3hyJSkMIuLJhKw18xr899Fl
	KLpr7nv7eWj6xDb+1h1nhBAkPBilirCcs2VTHyK7OVThfOCedBLIc01Nh/B1dDsafsrVesaMpIXTf
	K/hvtpqWtUcYxH1b8MhdA6abdCWeYzYEA7h28MEYzgFkQ8wld0dgPjbjP2WyAQDy2xWI8IR3D5qo/
	6nrIrEaADDkRo9737JewAlG9VYkyIoN1PH82ML0dzlDfojruTclmxD1zYEvQ9RPw8qpTlBJwJsnnN
	TzN2tWuQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfsKq-00000005faS-0WeX;
	Wed, 14 Jan 2026 04:18:20 +0000
Date: Wed, 14 Jan 2026 04:18:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: wang.yaxin@zte.com.cn
Cc: akpm@linux-foundation.org, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, david@kernel.org, vbabka@suse.cz,
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	xu.xin16@zte.com.cn, yang.yang29@zte.com.cn, fan.yu9@zte.com.cn,
	he.peilin@zte.com.cn, tu.qiang35@zte.com.cn, qiu.yutan@zte.com.cn,
	jiang.kun2@zte.com.cn, lu.zhongjun@zte.com.cn
Subject: Re: [PATCH linux-next] mm/madvise: prefer VMA lock for MADV_REMOVE
Message-ID: <aWcZCwz__qwwKbxw@casper.infradead.org>
References: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
X-Stat-Signature: 1wtsmu9ibpbkn99y18kecjn7ncdpyrrs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B039D40006
X-Rspam-User: 
X-HE-Tag: 1768364306-408277
X-HE-Meta: U2FsdGVkX1+Mt2ju4G77AA7uqHsSmQr7GLfogc9GV/UvsBMqlAObjWCU2XvEXPJnXQo4IV8Pw+7ZSLwPrNby2Hst9yUhRIsEDTFRoROHw1RiRj7jUknQeSFva8nyNWE5n+2Lxmqf8FVcmNP3w1jE1wvXpRHpV8QleuGHsYDGK6Hg7Yzf1JWihc4Qz6c/zx0qfJ4efH0JRMNPfgr3F3G4jmdOE5oWcjHCAG5iGR/XOOWFG7DYuayZh3Mw0GOIpB6Zik04Tr2rRgdq/+0B6NOmpkqQALiJPsy19la4nClASb19JX2vMjcwGRtA6WUDs77wK97L8Ym3Cg+8iV6TwZ57NfQ+y9UGdhvCBt+VUN7qOrdczQPdD5RxyOxmDbcvsBC2gt1HPQMOVkiXltAWwtnIcG3ORCtFgqdJj2uTZGwjNDggOrNlDPvh5N1ZIGUtyHz59Ugfgoqfel/wMHk7OBkqkCNHD2m06gES9UAPrOb/KEQjookaaM5NYFwhQyTS8YFWcu/8Vr6qfE2kTf0dnlcMF3Yx9FnX/+emOUzgjQomVyeAlZo5+sS9WV/4dMohS+B/zVMl2uClizdRM+lOP58cx1Kt+JzE6y99BrMEXiozG2MKwf85JfcR2e404lhoSSvoYPnHFFhaOQkArY/H6FYKMIWqlksyNNIpLCIl0MhKjXBt0es4bT6+QXVz9e3oZvAG2uX8pdxr2koa74x7k6fFteCM8cQlIQANrny7kC6oM8JIuChaWNTNy/QnKVXTAAm3Uen6/LjeYZTEw710xY6Vd7exfUTMgknZMuDsbVSlQEUPAJ3xIwKYYNKnKx5YHCJ8i0LJUOY/8gy4TcwLG14ztwxBDhdPTKi0olavk53NKIKcgBK93Rlg79iyCDt+PhQlPJiDPvAhs7LV8hj+3ixkcxTRrvdvSZxm4/Makq4vVpsrNN33c6KW1KjgBzLpyiMxhofFjFjyixc4z95DWBC
 8Xd//SpG
 Aq2ut0NM8D3OWjzpHOIrKx9x7CGk1cbZiATC/PJkybIkQ8IrfTE1SKAs5HnP6qfYOKkg8O1U0EYDtGfi3G8O1FXfZjRNmmRCcqr4XpC6ude/1syzFNrdomZwNOGTKTB8xiY4bXLrFZasN7sm1hErJsEfzLfrRGw7AKZD4zAf3/O7Rjgj9rvbVXMHjPCXZz2kExHTzqDt0hwLCD+K5/XS6gv8R8reMQECxt0kBQDPruBGIZ9jf1RbOCFiKxW8Tt7+U0j2nrAvtW62BUGq5UkBqZh+2PnlO3CZlHBIcV6AGf4NoaWFGGfE9Ql7NhQAvXltDeaWsveoXhZ5HtMI82jTVDDamER4O9S8vhqbQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:24:17AM +0800, wang.yaxin@zte.com.cn wrote:
> -	mark_mmap_lock_dropped(madv_behavior);
> +	/*
> +	 * Prefer VMA read lock path: when operating under VMA lock, we avoid
> +	 * dropping/reacquiring the mmap lock and directly perform the filesystem
> +	 * operation while the VMA is read-locked. We still take and drop a file
> +	 * reference to protect against concurrent file changes.

How does taking a reference prevent file changes?  What do you mean by
"file changes" anyway?

> +	 * When operating under mmap read lock (fallback), preserve existing
> +	 * behaviour: mark lock dropped, coordinate with userfaultfd_remove(),
> +	 * temporarily drop mmap_read_lock around vfs_fallocate(), and then
> +	 * reacquire it.

This is not the way to write an inline comment; that's how you describe
what you've done in the changelog.

> @@ -1033,12 +1045,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> 
>  	/*
> -	 * Filesystem's fallocate may need to take i_rwsem.  We need to
> -	 * explicitly grab a reference because the vma (and hence the
> -	 * vma's reference to the file) can go away as soon as we drop
> -	 * mmap_lock.
> +	 * Execute filesystem punch-hole under appropriate locking.
> +	 * - VMA lock path: no mmap lock held; call vfs_fallocate() directly.
> +	 * - mmap lock path: follow existing protocol including UFFD coordination
> +	 *   and temporary mmap_read_unlock/lock around the filesystem call.

Again, I don't like what you've done here with the comments.


