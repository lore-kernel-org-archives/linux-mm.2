Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A18606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQK63Jsz
Received: by kanga.kvack.org (Postfix)
	id DB39D6B05B5; Tue, 10 Nov 2026 07:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63BE6B05B6; Tue, 10 Nov 2026 07:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79476B05B8; Tue, 10 Nov 2026 07:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A19286B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:42:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 356C4140584
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:42:14 +0000 (UTC)
X-FDA: 85419172188.22.2B360DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71F5010000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:42:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQK63Jsz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRoErpQ0qdoUbWw0nfuYgIwgrTUDpslGsShVaP/Z9BQ=;
	b=vIx2A/lG1ssqmd/iYEL507uIlR7vyegXNr/R5XYj1D/E4MpWqVzEKU54iV9MojJVdt9+0I
	B/v32JpzP38C1Hp/Tja0BptYNmKCB+1lbFdn/Bu+deZe8A7w0yA4JMQ+8A5pcpPGoNSJUO
	+85v6i6hXRhr92QmJhGrqYv+d76wsF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314532;
	b=DsudFmFyUeTKG7djA2wFpbZwZdIoez3NM93EC6Z9EvPNJMXGv9YuDbajj/9/dyIwUy9jg3
	dgm0tx+iAP0M/pBxSvu1mA7Zk94EovgH3/I1vtOy0sr7AEi077lj67Lc7jGbiMYDJ24+gz
	KDAHzqDpEmLrRuNCBxXSog25G/+f6Bk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQK63Jsz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A47AA41226;
	Tue, 10 Nov 2026 12:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5EA1F0089F;
	Tue, 10 Nov 2026 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314531;
	bh=aRoErpQ0qdoUbWw0nfuYgIwgrTUDpslGsShVaP/Z9BQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jQK63JszJQWuuVVPMn7wOCpBAp5Qjsn9Ao4CS45p6vrYYXjwgXnuIlZAzNDlVU65t
	 BAqNUAcIdkjZ3eYq2E8M5JSgJg665YMLxoUirn3QjqWZkwiuKHn8Zcadz5vRbE89/9
	 X+vUwfAFfU5ajWYQ9DiDb7Dy1l4pIH9BFt5lc/MiLDCog2WGfxMqNDwNk5RzPWE+ad
	 w3G0qVRmhefIXgDRJx/pCFFU/LtKpBMJ4EyaUIzuUd3nBwoHUE+zQ7eKfGLkCWCXMS
	 DVmUOjRxd2gkSjyRefp8Jf3vJUewpZtJS4PgiWZb/GjiJvluv85aVpcRvjJqoPlaH5
	 oBGgfF4Wfv8lQ==
Date: Tue, 10 Nov 2026 12:42:04 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, corbet@lwn.net, 
	david@kernel.org, link@vivo.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	odys.yuan@gmail.com, rppt@kernel.org, surenb@google.com, tujinjiang@huawei.com, 
	vbabka@kernel.org, xiao.wang@vivo.com
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages
 under only_merge_zero_pages
Message-ID: <avMKhCLDv-ybpmIZ@gremlin>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
 <20261110074451.220524-2-xu.xin@linux.dev>
 <avLrHrnpP3tuXXPZ@gremlin>
 <avL+Xj5/Md58Gc98@dgvxl46587.localhost.localdomain>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avL+Xj5/Md58Gc98@dgvxl46587.localhost.localdomain>
X-Stat-Signature: 1d1k8m8nys6nyz1x6f4aw3hoegihpsod
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71F5010000B
X-HE-Tag: 1794314532-860903
X-HE-Meta: U2FsdGVkX1/vkauHQHashtpDCVCjSCdixNew86FZFK8nuGNGFv24GnJpa4NA7/vi+n8YGLAocq+UAAGEygw4AonDN9hjWtVTZy4rqM35dGa3rY0E0yGJ0VAKmupzJd+ihC/QDmEJOMNlcsdYzxqPOtZBfn8yfwYD0m8xsiUCd4dtM6wmGutuAIRwj24MjLrlctChVfoTfh8W0HHgaj+HdKdGv3m9O6pCcZvS7fKySf6WlBtBB8XDwFNvO+mINMewBeiMSki3fwebyAshV8CBdhyjya3UbJRzv3U0CzSy78Sx3BxZu1tmYpe707ijs+9EpnUQH78FG2a4rdhyLmLDUqYBzeg6m9Ml6LkVmqINI0QaGt1EKKRvSUSHK9k9c9qAZbqvIR53Y3jX6Pz2BW1Yik/zBGSWblMalP72Xn3ke0I23asQJqypmh2sv+REV1FkZSewZC+Qv02/VrZqTF0DYD/8cPxmRM5SSK5jZ5US3JHHrnM3CvvxDBuy56kYrOfn0RoUkGkRlTsKgh95mQh5yBsRQgCqav//mT7CphyzYPK7xFutMM2uB/PIysZlVVb6MNI6+QfdpOeEZM4A20dviUXLeXG33/u8X1ITJ23Szq+EPjRlbL+mCkz+xEdoNkIuNYbsU5l5aA/cT7cdQnWkqkLJYY7YKYnN4I2MnwlwflQoZdY4xIEiDEagRbBNz3rW0PIQNG74REK7QN6rkmMPfq5SWtCXEVHqleqBziQSYGxaY52RmlO0e7Bh8wG8t+L98R7jR4rsrCdfX2ZV/r83Pb06/S07oSQsLiLMhLA2SPNcVKBTV/0A92Rz9Br/zQK4rrOwHhYRZa1fdY5/QC2jhc98wW20FiutvpAVpWihCD8OnvMnOCINLvg2rdaiR8Nob/mPt8jFXJ79Qu+kCNLITRfsVENm3xjmyJl/fCId18xNm60/26SwALXGfihcC8lAaYSo8Vd8l7qaeJhWuyv
 ToCdVlyk
 V4pd3KVblfxqvoYiqf9aV2z87Hshvh0Qk1ow/r/vIRH1bomemiol53sQWMK4IBg1+6jUV5zc3TfzonmIg3PONvyeMrnaFma3qel4oxKdgMWGUrVg/NJG2SwpmlO3aTv2bPQK4sS/acpC+LOlMjN9yAvw7ps/b15oy4w/N9OPQ96YnbgoKW1niO3oN8H5Qtyo84EkZyha3J8kGf8H5qSmYhSUVqZyldR7Zh6CiYsTjk7RcpHxpKD2BtXqqr4qYeE3VL7/RTeHDZhdADhGRnFjD6nuWCELqn69Wg7KMPPBsW4GnRBNjEkBKX+EtpKDtGnFmZsNgal6Onuk18Ii8DQZf8W6ddErPnwwdAHTeCB5vyEZin5Zs0Jm2XvuSJdwbiz2DjY0whuer2AStKmHJTgxXcYb3GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:22:06PM +0800, Xu Xin (vivo) wrote:
> On Tue, Nov 10, 2026 at 10:05:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Nov 10, 2026 at 03:44:49PM +0800, Xu Xin (vivo) wrote:
> > > When only_merge_zero_pages is enabled, ksmd only ever merges empty
> > > (zeroed) anonymous pages with the kernel zero page. A page that carries
> > > data can never be merged, yet the current code still allocates an
> > > rmap_item for it in scan_get_next_rmap_item() before cmp_and_merge_page()
> > > decides to skip it.
> > >
> > > On workloads with a large amount of non-mergeable anonymous memory this
> > > is a real cost: every scanned non-zero page pays for an rmap_item
> > > allocation, and the rmap_items accumulate in the per-mm pending list.
> > > For example, a MySQL instance with hundreds of gigabytes of anonymous
> > > memory (mostly buffer pool pages that cannot be merged) ends up with
> > > ksmd creating rmap_item metadata for each candidate page; the metadata
> > > overhead can wipe out any gain from the zero-page merging and even turn
> > > the net benefit negative.
> > >
> > > Add should_skip_non_zero_page(), called in scan_get_next_rmap_item() before
> > > get_next_rmap_item(), which, when only_merge_zero_pages is enabled,
> > > checks whether the candidate page is all zeros. A non-zero page is
> > > skipped entirely: no rmap_item is allocated for it, and any stale
> > > pending rmap_items below it are freed (as get_next_rmap_item() would).
> > > The page is reported back to ksm_do_scan() as ERR_PTR(-EAGAIN), which
> > > counts it as scanned and continues, so the pages_to_scan budget is
> > > preserved.
> > >
> > > The all-zero check (pages_identical() against the kernel zero page) reads
> > > the whole page. For a non-zero page this is a net win: the extra page read
> > > is cheaper than the rmap_item allocation and the stable/unstable tree
> > > operations it would otherwise trigger.
> > >
> > > A page that is zero now but is written before cmp_and_merge_page() runs
> > > is still handled correctly, because the checksum-based decision in
> > > cmp_and_merge_page() (added by the previous patch) is the authoritative
> > > one.
> > >
> >
> > Please re-write this in your own words.
> >
> > It's rambling on and never gets to the point of _what this patch does and
> > why_.
> >
> > I'm not interested in reading a novel to understand the code :)
> >
> > It seems very LLM generated, LLMs are _terrible_ at writing commit messages
> > and commits, please re-write all of that.
>
> Indeed, the description was generated by LLM, but I thought that was clear enough
> to present what this patch do and why. Aparrently, you don't like that style, I'll
> rewrite that by handd.

In general we never want LLM-generated commit messages/comments.

I do however obviously appreciate and empathise with using it to assist
non-native speakers. So that's fine, but ideally you would write it up yourself
and then have the LLM do simply a polishing layer, keeping the length as small
as possible, which should give us the best of both worlds. Thanks :)

>
> The goal is only to avoid rmap_item allocation for pages that can never merge
> under only_merge_zero_pages. The implementation is simple.
>
> I'll send a v3 with those changes.

Well let's wait on David's POV on this series for this cycle before a respin
first thanks!

>
> >
> > > Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> > > Co-developed-by: Jinjiang Tu <tujinjiang@huawei.com>
> > > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> >
> > Why are this and the other patches in-reply-to 1/4? That's not how you send
> > a series in mm.
>
> That was my mistake

Ack, sure I've made all sorts of mistakes like that myself :)

> >
> > > ---
> > >  mm/ksm.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 82 insertions(+)
> > >
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index 49f3728a3d03..e641c37ee096 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -2535,6 +2535,69 @@ static bool should_skip_rmap_item(struct folio *folio,
> > >  	return true;
> > >  }
> > >
> > > +/*
> > > + * Determines whether a candidate page should be skipped entirely when
> > > + * only_merge_zero_pages is enabled, before an rmap_item is allocated for
> > > + * it.
> > > + *
> > > + * A page that is not all zeros carries data and can never be merged with
> > > + * the kernel zero page, so there is no point in allocating an rmap_item
> > > + * for it. Skipping it here avoids the rmap_item metadata cost that full
> > > + * KSM would otherwise pay for every non-mergeable page.
> > > + *
> > > + * @rmap_list: head of the per-mm pending rmap_item list
> > > + * @addr:      address of the candidate page
> > > + * @folio:     folio containing the candidate page
> > > + * @page:      the candidate page
> > > + *
> > > + * Returns true if the page should be skipped (and any stale pending
> > > + * rmap_items below @addr are freed), false if it should be processed.
> > > + */
> >
> > This is a really weird mix of kdoc style + not kdoc style while not being a
> > kdoc, for a static function?
> >
>
> Will simplify it.

Thanks.

>
> > > +static bool should_skip_non_zero_page(struct ksm_rmap_item **rmap_list,
> > > +			     unsigned long addr, struct folio *folio,
> > > +			     struct page *page)
> > > +{
> > > +	struct ksm_rmap_item *rmap_item;
> > > +
> > > +	if (!ksm_only_merge_zero_pages)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * Pages already merged by KSM are handled by cmp_and_merge_page();
> > > +	 * do not skip them here.
> > > +	 */
> > > +	if (folio_test_ksm(folio))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * An all-zero page is exactly what we want to merge with the kernel
> > > +	 * zero page; process it.
> > > +	 */
> > > +	if (pages_identical(page, ZERO_PAGE(0)))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * The page carries data: free any pending rmap_items that are below
> > > +	 * it (they are stale, as get_next_rmap_item() would), and skip it so
> > > +	 * no rmap_item is allocated for it.
> > > +	 *
> > > +	 * Compare the masked address, unlike get_next_rmap_item() which
> > > +	 * compares the raw rmap_item->address (which may carry the
> > > +	 * UNSTABLE/STABLE_FLAG bits). That is intentional: a pending
> > > +	 * rmap_item at the same address as a non-zero page is stale and must
> > > +	 * be freed here, not returned for processing.
> > > +	 */
> >
> > We don't need a prose version of the code, and it reads like AI slop, we
> > don't want AI slop comments, thanks.
>
> Sorry, this is to clarify the difference between get_next_rmap_item() and here.
> Maybe too verbose to you ? I can simplify those words.

It is too verbose yes, and effectively writes out the code in comment form, this
is not helpful.

>
> >
> > > +	while (*rmap_list) {
> > > +		rmap_item = *rmap_list;
> >
> > Why is rmap_item function-scoped when it could be block-scoped here...
>
> You are right. Will fix it.

Thanks!

>
> >
> > > +		if ((rmap_item->address & PAGE_MASK) > addr)
> > > +			break;
> > > +		*rmap_list = rmap_item->rmap_list;
> > > +		remove_rmap_item_from_tree(rmap_item);
> > > +		free_rmap_item(rmap_item);
> > > +	}
> >
> > This code is very ugly.
> >
> > Newline...

In general I'd prefer a rethink though to make it cleaner.

> >
> > > +	return true;
> >
> >
> > > +}
> > > +
> > >  struct ksm_next_page_arg {
> > >  	struct folio *folio;
> > >  	struct page *page;
> > > @@ -2737,6 +2800,16 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> > >  			if (tmp_page) {
> > >  				flush_anon_page(vma, tmp_page, ksm_scan.address);
> > >  				flush_dcache_page(tmp_page);
> > > +
> > > +				if (should_skip_non_zero_page(ksm_scan.rmap_list,
> > > +						     ksm_scan.address, folio,
> > > +						     tmp_page)) {
> > > +					folio_put(folio);
> > > +					ksm_scan.address += PAGE_SIZE;
> > > +					mmap_read_unlock(mm);
> > > +					return ERR_PTR(-EAGAIN);
> > > +				}
> > > +
> >
> > I don't love just shoving more logic into an already massive function. No
> > to this.
> >
> > At some point technical debt has to be paid, clean up this code first please.
>
> Emmm... I agree scan_get_next_rmap_item() is already too large and needs cleanup.
>
> But it is the main KSM scan path, and a refactor there is high-risk. The cleanup
> deserves a separate series with careful review and testing.

Completely disagree. By this logic we'd never improve anything, and even if it
were true, it's valid to say there should be a feature freeze until that's fixed.

Anyway, let's work through this a bit.

At 50,000 ft:

static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
{
	...

	if (mm_slot == &ksm_mm_head) {
		... huge block ...
next_mm:
		... of course, nasty non-linear goto logic ...
	}

	for_each_vma(vmi, vma) {
		...
		while (ksm_scan.address < vma->vm_end) {
			...
			if (tmp_page) {
				... <-- you propose to add open-coded logic in
				        the most nested bit.
			}
			...
		}
		...
	}
	... huge amounts of other code ...
}

Now very clearly you can separate out these blocks into static functions with
no risk at all and eliminate most of this indentation.

Digging into your proposal:

			if (tmp_page) {
				flush_anon_page(vma, tmp_page, ksm_scan.address);
				flush_dcache_page(tmp_page);
+				if (should_skip_non_zero_page(ksm_scan.rmap_list,
+						     ksm_scan.address, folio,
+						     tmp_page)) {
+					folio_put(folio);
+					ksm_scan.address += PAGE_SIZE;
+					mmap_read_unlock(mm);
+					return ERR_PTR(-EAGAIN);
+				}
				rmap_item = get_next_rmap_item(mm_slot,
					ksm_scan.rmap_list, ksm_scan.address);
				if (rmap_item) {
					ksm_scan.rmap_list =
							&rmap_item->rmap_list;

					if (should_skip_rmap_item(folio, rmap_item)) {
						folio_put(folio);
						goto next_page;
					}

					ksm_scan.address += PAGE_SIZE;
					*page = tmp_page;
				} else {
					folio_put(folio);
				}
				mmap_read_unlock(mm);
				return rmap_item;
			}

Firstly, in context, this is:

			...
			if (tmp_page) {
				...
			}
next_page:
			ksm_scan.address += PAGE_SIZE;
			cond_resched();

Right?

So this could be:

			if (!tmp_page)
				goto next_page;

			... logic in block above ...


With zero risk and immediately you remove one level of indentation.

Since you're returning rmap_item anyway you could do:

			if (should_skip_non_zero_page(ksm_scan.rmap_list,
				ksm_scan.address, folio, tmp_page)) {
				ksm_scan.address += PAGE_SIZE;
				rmap_item = ERR_PTR(-EAGAIN);
			} else {
				rmap_item = get_next_rmap_item(mm_slot,
					ksm_scan.rmap_list, ksm_scan.address);
			}

Then:
			if (!IS_ERR_OR_NULL(rmap_item)) {
				...
			} else {
				folio_put(folio);
			}
			mmap_read_unlock(mm);
			return rmap_item;

Which does the mmap_read_unlock(), address update and return for you.

IMO none of this is risky, and this isn't even getting into bigger
refactorings you could do.

Adding a few of these kinds of things as patches early in the series really
isn't that hard and improves things for everybody.

I'd love for this to be an instinctive thing people did when adding new
functionality to stuff like this. That way we pay down technical debt as we
go :)

--
Cheers, Lorenzo

