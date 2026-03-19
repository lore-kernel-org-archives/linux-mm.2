Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACED108E1E2
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60406B0474; Thu, 19 Mar 2026 07:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37726B0476; Thu, 19 Mar 2026 07:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E136B0477; Thu, 19 Mar 2026 07:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80D5B6B0474
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:04:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3337313B001
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:04:16 +0000 (UTC)
X-FDA: 84562528512.05.724EEA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B8A6100011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:04:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ynonna7/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPMRYKkbtMbn94uZ0URw8XlccS+DCeXKW/7wiMOXUaE=;
	b=gwVp9J0VGVtE6CEDiaWNpEEI0KHMbGOo7mVrFOB3CI0eDx4VpSsLwTGRnZjetLzWEkOO+Y
	EiQbZznuXu4jcsgtqsk3dZQ1nTh+lZl3LbPKtLXBS9xCrnZlqUZa2/PlbXlIGl2p7/woCl
	Cz0SnDDCKVyDiEg3wqnv0+PUIJhjP+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918254; a=rsa-sha256;
	cv=none;
	b=dcChC355bq+ShzQX4q8HICbDU60G58gvrYVmsCYJS0f83YsjZ9PuKCOmZkoiBExMOmiiyY
	rAmTOl6N4DnvWGWWiMcTzQQ7gV2I9pjjxy4F1x1p7goFg8AdbzywZO7CICn5r2wzMXGSxh
	Vf1uw783yMxN8Eo3uhT3bOrnBZ9jc4Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ynonna7/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76FF1434A1;
	Thu, 19 Mar 2026 11:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96266C2BCAF;
	Thu, 19 Mar 2026 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918253;
	bh=tiY/jpfXZ8QsNdAtW0yG99R1cQtZtW0U4CTYDaODYfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ynonna7/UaJfj4Xw/2Ijh11s7+H3Eljp4etVxlZFk8G8J/k9X/C1yqZ/0aUG6iWwv
	 NfHVjsom6xCGVSt2Oa5h/j9VvqZx/XiJClTZUomg0lJNKmZFMDhJM22cLwY3uym2rj
	 IClgbHvxttCCFTCJkjq0Z4FtnqNb4TLiB118NAqBCRzii1SqYzgpPeuacBna3JhntF
	 H+yr4rzAx/40b3kFFIz2lca6Nl25loP0tiL3Y10GO8PDAb0HEdO2npxJ+ibhZz0xzh
	 XT0XRbMWVHlAz7tAvLzV/DMwCa7W0bWj2rI/iOOgzuz44OnxMFFl7j++OIiQ8aWMVB
	 W2LVschDReDSA==
Date: Thu, 19 Mar 2026 11:04:07 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>, 
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>, david@kernel.org, willy@infradead.org, 
	Mark Brown <broonie@kernel.org>, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <a94ff663-1df9-4a3c-82c9-8ae8d0f8fdc3@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B8A6100011
X-Stat-Signature: 6dwdfdjha4o3ewf7k9cjt958en8g9jmk
X-Rspam-User: 
X-HE-Tag: 1773918254-392296
X-HE-Meta: U2FsdGVkX183Dw6J2b0IPpUQlBVgSfOOUMG9IMrOBE7LMiJwEhK0Gyi8+iIKasmS4A0Tu3Vo05jxwPXJOKEfWf7SJBUhN+OjpoFDmyKRdmF4LnUwz1ToUEgJFiFdcfJ1rB8eNzEs5+GtYxFAZBkIpP1DseLMZEwIn5yGucVgfQmYERneFty4nEv9L7OMFjfg10BZoqD23YNoFLKxdk9cTO5nHLNPtpS0kE4vzPlSmS1rlHZJVjgpTRUR4Hcc9b5N9iQfJ3BmppRtkeW+L9a/zdZdUV2wMhsN0N7ELRdVdS0e+zAF51mFUS+YPBSWI2jj/TbKj/rQorPNvw1c0JkE+f1B35wS9Mh8tbe1nqSgZACansd3YiHJRy04LAju8mTqcoqpSTE8aZzqgkKn6I5oA5h0dmtXiw49wkzMJkuwWvk1h6kwaE1FSAhibumaRKJCPu+qnoJQikL5RkM8HLJJj2tnTa2JlwHde2FyzUYqXETptL83oJPembnUyAn7kapC5hh1BgSvIyTzCRMDnQfLUrjSxVBfTMZKbBMt0P56F4NUueFMWljmAgZuEBXB353Xi6o5GZtm1RjU01MOiW7RVck94WS+DNanV5IZoHVZuRP21h68YssQ0dw23mcl8yYfizbkR+Aj7qAwInU5ahQAybePdDw/DgbI2FqQ91IJ+W+Zq41xvqj5JiyRuWYay5dActRewVUiH4bZfHhkAaj98812d3G8/OBPBuLU3aA6JgYQzbcnC+C34A6PRe7PocI56v76bkV0Ks0uuNrPHHfHdtrp3KvEQK0TdiiEam18KzoQeJzH+WACNnTDulONCI/n0ubgviqm24JLFRmXb3gYUmpoK2dewvTRTz958NMAiTT0SHSw+zQPbz9rDGyBxGGbXBMHJLOUOxKlB4ZfYR1atBPZYmlu3+BNh133GAnjFWc8AfxPDc6waO/tSi2eUin1JqfYdyjHjcS/hhw5NB3
 6vwRQLoH
 sVJNvPHNC+daufO/DtOYGjGyEp/Xv6ywv9mUJGJra25JyoN6IZEHwGcZ2kb1GRG4GHqPxKEHfH/D9+6uQezxkJ6pQL9EZnLpeHCdc+B7ZondjYtaJDHpZfTVgHWBf33dM9coWQ8ki/lYkF2ZTVxrczWcs3jfxvdvf/p3qNMT/7tAkGHOFF6b5kJlztSuekGA0Tmq9VGjZbmlTa5OhKxRFsh932e8q08KnzrSLrPtz3Flp7EEslPN3d4UGB1QZ4NYOlWHiVkr5kggyIiGV5vTjGERn1OPq5L4UwKRKZ+tViNa6GnT6u15Q6ATUp1rSKJw/Wjy8fhaYIeIhCFAzpCA9pqJ8HKAtxlPkSQn/BqSSgQnjz+VISyP3vh2o3qCDEHmFvoh0hNfQH9b2C0knnamrW79akbsqC+eWHMB0yNwYNfHlziieCseabwW9etASgigOahq6tzsYlMfsJb4kyFYwxNfAVSf4Nj2TL7KmEU+2Nwgaczr4PotEBmq7Z7KA8zBRT9hCPC0G+ltbBimgnZf1z6OOEk9ZJ/JQVmH+BGBxADgTU8FI+KT6WJnPZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:56:21AM +0100, Vlastimil Babka wrote:
> On 3/19/26 09:05, Lance Yang wrote:
> > Ccing Willy
> >
> > IIUC, this is a dup of the earlier report[1], which I looked into back
> > in January. The root cause is the same: collapse_file() calls
> > xas_lock_irq() without resetting the xas state first, tripping the
> > XAS_INVALID() assertion:
> >
> > #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
> >
> > static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> > {
> > 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> > 	return xas;
> > }
> >
> > Added by commit:
> >
> > commit 43b00759f21b10142094d1ae5ff65cbb368953a3
> > Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Date:   Sun Dec 14 10:53:31 2025 -0500
> >
> >      XArray: Add extra debugging check to xas_lock and friends
> >
> >      While tracking down a recent bug, we discovered somewhere that had
> >      forgotten to call xas_reset() before calling xas_lock().  Add a debug
> >      check to be sure that doesn't happen in future and fix all the
> > places in
> >      the test suite which were carelessly doing just this.
> >
> >      Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> >      Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >
> > I posted a HACK fix at the time[2], but David pointed out that Willy
> > had mentioned it likely needs more thought[3].
> >
> > [1]
> > https://lore.kernel.org/all/69757ea0.a00a0220.33ccc7.0017.GAE@google.com/
> > [2] https://lore.kernel.org/all/20260125121001.32733-1-lance.yang@linux.dev/
> > [3]
> > https://lore.kernel.org/all/7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org/
>
> That "needs more thought" was Jan 5. After 2.5 months later this is still
> messing up linux-next testing due to a known unfixed problem. Completely
> unnaceptable. Willy, you need to drop the new bug check until the known
> problem is fixed.
>
> Mark, please drop https://git.infradead.org/users/willy/xarray.git from
> linux-next until it stops breaking linux-next. Thanks.

Thanks, also I don't see a Link: tag or any discussion of this patch anywhere
on-list (maybe I missed it?) the only think a search on lore brings up is a bug
report from jan 5th [0] about it.

If this is heading for a Linus PR, could we have the patch actually posted to
lore somewhere so there can be some discussion?

And is there a way to ensure this doesn't land in the next merge window unless
it's fixed? Not sure through which tree it's going (Willy's?).

In general I'm very uncomfortable 'just leaving' splatting kernels in the
-next tree.

[0]:https://lore.kernel.org/all/aVvz3tYdu49TGkjI@mozart.vkv.me/

Thanks, Lorenzo

