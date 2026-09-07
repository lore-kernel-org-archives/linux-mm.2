Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEC0C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4466F6B0093; Mon,  7 Sep 2026 12:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7B96B0095; Mon,  7 Sep 2026 12:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E916B0098; Mon,  7 Sep 2026 12:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6926B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:26:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99D511C0AA5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:26:15 +0000 (UTC)
X-FDA: 85187493510.28.93E04AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E8AD720009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:26:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETrQgNG9;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798374;
	b=4plECJtiaBcr0kEHfSGXu/lsawX/dbfRbulVjnuiH2jwQQnJVVGlQgmnXpoIN6cs4zjday
	i/w8bHt8NkCDZ81IaNlGJi1Yc3ibZVlTTlKrZ+qlLhUERzxysB9uT0oV4zxix3fuVMKCde
	mW0IQrLqA0THzOjjOdPMGtmCUEzN4us=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7haBIfiIGhaU6/yfncxk2nIKY4oDyz2vAsQkjP7Gxfg=;
	b=lXEd0XNSI3VGFE85q+cabz2NSC8LNKiOcq4oyiN+N4WpSejVd/N0MiZgG8BjEObP+UGPwv
	Borq9gxqgTkwAE3kgElxAyMP9RG4z+DYMWVIjZw+odWnSgJV4vU45j8UBkUrW+6sOMVcM6
	XCzPiQTFoMX3nUw1p0m+X/0xqXDns74=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETrQgNG9;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9FBD4002F;
	Mon,  7 Sep 2026 16:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296EF1F00A3A;
	Mon,  7 Sep 2026 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798372;
	bh=7haBIfiIGhaU6/yfncxk2nIKY4oDyz2vAsQkjP7Gxfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ETrQgNG9R9OzQbrJlawv+3W86A8+IGTjRL2itbtyPn9PnaRLrc0POdBtnDb5FZgf7
	 /6MD3X4z7nl6ZkA+yuGN6YJssbv+SfPmSuDPs8I4pY6b5bZg2JBwmbTXgztr6wDR2c
	 edz8zWT8uJV5MZDxbV94aBQKG7Rlzk4NFLmoTPLfpWtV1DYVc5KbyxROXhy2IcTWXW
	 tWoYDybnoP3HUh2UQgYKUOq0w6KZP8mtmS5KIzQ4n5/jBMxsHua5H+TkN4XvDgZ+1z
	 ypB0E6SA07qKMKuNz3VGo34RenSMcMjZsvVeKDi+C4StNn8ByOX2Db5iFJBmtL8BNN
	 c9DDSyF48VPVw==
Date: Mon, 7 Sep 2026 17:26:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <ap7j0oVf_ZOzX6pB@gremlin>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
 <ap7fOu5DHkKtqlkg@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7fOu5DHkKtqlkg@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8AD720009
X-Stat-Signature: 6c33jndxkdycg83e5c1d566zid4ftqax
X-HE-Tag: 1788798373-950622
X-HE-Meta: U2FsdGVkX18XZKVOZ1pwl46S12DXKSVv/Cm2WAVJ0DC8HylLjvzxzlQX4C+WiKAOOuKwGEdMYYV1fj+LEmMFnJ1AasHPrKjTAVIFukdQsxhM+20cy3IHewkCYa8bGmgQWnm+jYjVlXhV+athy31uhLpzWHIv6lrPrAk67Ter8Ue88ldNaI2aa+DDKOp/Bgsw1Lma7lPsvvSBlV1zsl9w7iBzo4TbBt0buTXWvOHTmr/75233q+NJlOLjcy5UmB1FrbE/e1D65tV1HvEjxqWcUanZ00f5rYhp6H9hktvwk8cgzRXYmw+yq/n8jQoWu/kq6g8w9EH566iLZ0xs1tuvhFGhXonxVwJFXp3DRwdxR2/a+SqGwoUKpkWD8a+Uk4vpb3GQ/Vdox3UA75OO0CdiSHpKVfnAfJGbiK9NA7Df24eGEGGGlbnc44XGo7vjgNgoDo3BpNDqKsoSVlWIhQtzqNiaxX9Z7CRJaKZ0ZzcTiMl15Q5yaIMTCGO4QaGtwtuL0TA0dWD+IRj61lI37qarWkpWdS22cw5VZJG28gYPQD8iUOSitT9eGim2/snlCFEcjXnAt1EAezMtVXiuaTnFHPjGWMosNJTS3icuqdZtQlVjac1EVvvHeTDFqFReNpuWtzJCsCx02GaPkKUVvrSUwJVPdzyoOIHZ7AX/PMeO1WqYS6kgftAD9trTfHOseS237zmswZlq6JAfZfJF5e1tzimjtwCiDdfaER7vVXorfVqOXods8o/zKwDtiY30f55t67xQgwN90eN+1tViKc5Oijez7Ep4YCNvojqejE4ZMdFsLBMilvJpuzCuH59n+EoZdq3BfDEooLGSwcZQB6w6Nr8kSDKusGXOnmaGLzkxQqwWAiWPB3FeMYUTFdE++dqILPPi6Idlb1WD5Kx8PXDs6uXHiWjF1ZIUal9nLzIweWx57bIxzdV44vXgwHTraWCJer4SWDbCFEESCnm9rLK
 Sy30rHMo
 ZV9Aoeq5Aoa7ipbk6JJcFLhKOecJJfgMDf9NRQwLI0n6nPCie1SGVY3xoNB0ZZRtA9gwzyBSAVdU4SPvvVRfG0ELSVWo2HdkK4rcdQzl97rMAUgb6ZHViWqf9dHAUmMW+ML8sB/iJZyEuRNDe7p0EmvPtf8PBjMBvPdA2ThVQC0xfpqL5MtFIVY9T/u8HLI0+Go5PU/IL3xKNq8I5EmAHAESQIADau/3P1QLQILkUJDAkTyuCNGcTaM6Y4JiehrUcawDpIwsHzABydf38juFdRs0XL3XdI0NOb+Dr0++Q75eiDm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 12:04:50PM -0400, Gregory Price wrote:
> On Wed, Sep 02, 2026 at 07:00:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
> > without the success_hook hack we explicitly permitted mmap_prepare handlers
> > to set NULL vm_ops.
> >
> > However this is dangerous and we really only want to allow this for
> > MAP_PRIVATE-mapped /dev/zero.
> >
>
> "this is dangerous" -> can you expand on this?
>
> I had been experimenting with mmap'ing kmem dax devices as a way to test
> generating a driver-defined efault mempolicy on an anonymous region, and
> this exact pattern came up for me during mmap_prepare trying to get rid
> of the "fileness" of the VMA.
>
> Basically looked exactly like the /dev/zero vma.
>
> I understand this is a hack, i'm just trying to better understand why
> "this is dangerous" and it shouldn't be a supported pattern.
>
> for clarity:
>
>    fd = open("/dev/dax0.0",...);
>    buf = mmap(fd, ...);
>    /*
>     * mmap(_prepare) callback marks the vma anonymous so it takes anon
>     * fault routes and sets an mbind mempolicy installed on the vma to
>     * prefer the node the dax device is registered to.
>     */
>    buf[0] = 0xDEADBEEF; /* faults an anon page from the node */

Well firstly it's a contradiction in terms as it has to be file-backed for a
driver to get it :)

This exception is just a historic artifact.

This kind of edge case VMA is a real footgun too, there's been bugs around it,
weird behaviour-by mistake and in general it's safer, more maintainable and
easier on the old noggin' to eliminate weirdo edge cases.

It's also probably a good idea from a security point of view, especially now
that can be LLM'd endlessly :)

But also the driver can't properly ensure that everything is set up correctly
re: rmap, mapcount, etc. and also drivers cannot be and should not be trusted to
do this.

The right away round here is for userland to allocate the memory and have a
driver use GUP to fiddle with it.

Finally CONFIG_DEBUG_VM warnings might go off because you set pgoff to something
random. We kinda tolerate pgoff abuse for file-backed memory, but now for anon
it's established as an invariant that it's what we expect (vm_start >>
PAGE_SHIFT if unfaulted, or if faulted from first fault time).

--
Cheers, Lorenzo

