Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F18C8CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAFA28003B; Thu, 18 Sep 2025 11:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292278E00F6; Thu, 18 Sep 2025 11:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF5D28003B; Thu, 18 Sep 2025 11:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2ED8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:32:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C99A8856A5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:32:13 +0000 (UTC)
X-FDA: 83902762146.24.1861689
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0347914000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:32:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758209532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QgLUSeV97No9nYtOeRYrbkT+0ZSSWLHTRfe2zSM1Sxs=;
	b=goDNL3Z9LOTpSBswRFRaYw2jGFvhNDNLOuKfDZfkGXjRYFPH1Oq+93g/a26WlDWyyqTvk7
	CeElNX+G4Dbg0ZKnjDx03TWFWmThv2WBdp0zbAU9kITcwWPyKnpjNCuhqODWqMAcbw2jSL
	ffp+UhjatUaxLKbZVwTzNCFZZRCKgVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758209532; a=rsa-sha256;
	cv=none;
	b=Cy44augQd7m67o9PY/TK2W8w+N4GDusgWHWzo/N5kYE9wS6vp3VpAR0kzIK33WpT20qYkx
	PTkKHLo9nE2o3FM0D1dBAQrr808jBw3fVYckK7JoEgZH7DXkZ+hyPe44dmL7Pw4db3r2SA
	zmXhBi1jSdgfVEwuAObNJ31oIjINvZA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC3D443FE4;
	Thu, 18 Sep 2025 15:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89847C4CEE7;
	Thu, 18 Sep 2025 15:32:08 +0000 (UTC)
Date: Thu, 18 Sep 2025 16:32:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: will@kernel.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
	dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 5/5] arm64: kprobes: call set_memory_rox() for kprobe
 page
Message-ID: <aMwl9mujvFknSulA@arm.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-6-yang@os.amperecomputing.com>
 <aMv_nhEuCSHKp5J6@arm.com>
 <22732cbe-20f8-4d1e-b086-e34d0f9bbb35@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22732cbe-20f8-4d1e-b086-e34d0f9bbb35@os.amperecomputing.com>
X-Stat-Signature: 6tx6wchdgsb8woxm1p6ja94dp5d48neh
X-Rspamd-Queue-Id: 0347914000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758209531-919031
X-HE-Meta: U2FsdGVkX1898gQQ/97hXFDTL4YG3eXT8iH/FjsX2mOdmmxDB6a6tZf6vH+DReHrFLPgdSDWgJN3LiAqJdxVKo5x6WzMhJ8HCUsb5cd5a8iTOgkYBvzPA7S5j5HPzxlIknyIx6gaIVNKeYcij/oLN3d1ogNItkk5CbtMHk4VrNvfEcndeSd/lRHMZNmJDD6JnSxnno7sq7noAk+5PScl4jsw63F3okzDC1N00sMVaiuhlpJ8o5mO/dgCwKxgqtutZHKjMoeExOKYwivo3w47x7A8cuUXoS+tdbILwhhMe0BO/GmfoFshQiv3T5eJLasXcX+2/kAGtvKBeyy6qfCj7HeBHzU17fbNtDETg+/v0cOcIf8etGGhVn60cEzgkh1uUxSkp1OboHysbtB6yONKGt7Kgju5Fc0GJd9Xpz21xlA6RgWWveB9ny+JpMqmZiHaScD7EGBEnlTx+xkkDKxeop2iQ3fzSscDW+FY/WmnBlnIyAkJs4vky6SYdjn9YXISWq+aStnD9iBSKICraHPzzJBVxe4XAfI8GOd7wTU783ScBeTYgT7O2J7eOpnz+TObFRLbROSqskeTYHARaju9NOtOCTB6xCJ8BSrqVKU+gb+wWd6OvzCw7NNp3Xu4qAiFt6pGj+RoXMiC7/zsBTXSGsHHShOBXuEj4TgbRHLl1qaF1Rk5vMwkVGhDm9lJYKsoKlCRTLmqHFDIHbkH3FR/nYV20zjphc7qe6YyNBzzcIqzZlqq7z7UqNIcK9RX26i5WeOj9l3z8SN1HzqWtg+Lshmm5zUawDrLOzRKupiAwfWJrpSKjo6vLEVpJ/vQTN/0f2fZNtqgdVQtKdTySmoUOx5rRMhV+XSWWvWioQf6uEggVZRu4PQCZA68ibzCqfsyYikcsaQd3ih0fauKqeX+QMbgKYjoclGRhZCr0H7IX3PFHiCi/w0TtB+0Jr2wtu1udcbR7VFQ2iSPRUuqEi9
 a5tjtL+X
 VuMRva5iQxJiID4I/EEXS2IioWQeHh8NyIRBjKFTn4MjK5m+Fb9fNzpKjn++btvof3pGGUmQMgnhG+SF+kAku1wb6AtRk4CSTZv26x7LHcq3+FJ+uUH89plch7DiUM7EbTfRbBPwr64yQ4bd2Zj/hkmQl1E1nuI3ozL6ge9xX5FwbQsj1oxr0vrBa7P5dn3oFJx19QK2W+z4WBPNP4YJOWY5MM+/PkwDJvoI0wxcINQQnNKKOx/2PkV31dYfWJE9wR8h5fbx5t2XJmkGX3qEXINS9Pp8l//WdbPe2bzKi56xkpD5f935Zkx+AbvhYf0QvIWqSBkzFWhLjDmoJo7UfUw1QLqyEqKt2N6RkLaHvKb1y3EC1RkvqZc6D0W8pp6nr+Yx0La4EN5xaOVftqYb3vsxaass9vgEBQtS+wAdBf4Pkgz6OJLwlWDVA1/0r+wb+FTsQFcmAE8wsUoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 08:05:55AM -0700, Yang Shi wrote:
> On 9/18/25 5:48 AM, Catalin Marinas wrote:
> > On Wed, Sep 17, 2025 at 12:02:11PM -0700, Yang Shi wrote:
> > > +	page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
> > > +	if (!page)
> > > +		return NULL;
> > > +	set_memory_rox((unsigned long)page, 1);
> > It's unfortunate that we change the attributes of the ROX vmap first to
> > RO, then to back to ROX so that we get the linear map changed. Maybe
> > factor out some of the code in change_memory_common() to only change the
> > linear map.
> 
> I want to make sure I understand you correctly, you meant set_memory_rox()
> should do:
> 
> change linear map to RO (call a new helper, for example,
> set_direct_map_ro())
> change vmap to ROX (call change_memory_common())

set_memory_rox() is correct. What I meant is that in alloc_insn_page(),
execmem_alloc() already returns RX memory. Calling set_memory_rox() does
indeed change the linear map to RO but it also changes the vmap memory
to RO and then to RX. There's no need for the alloc_insn_page() to do
this but we shouldn't change set_memory_rox() for this, the latter is
correct. I was thinking of alloc_insn_page() calling a new function that
only changes the linear map.

> And I think we should have the cleanup patch separate from this bug fix
> patch because the bug fix patch should be applied to -stable release too.
> Keeping it simpler makes the backport easier.

Yes, for now you can leave it as is, that's not a critical path.

> Shall I squash the cleanup patch into patch #1?

No, I'd leave it as a separate fix, especially if we want to backport
it.

Anyway, for now, with the nitpick on the address variable name:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

