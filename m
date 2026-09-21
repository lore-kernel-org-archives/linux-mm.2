Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D29DC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075996B00AF; Mon, 21 Sep 2026 10:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DCC6B00C2; Mon, 21 Sep 2026 10:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6636B00C7; Mon, 21 Sep 2026 10:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE5576B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:32:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 557CFA3F1E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:32:41 +0000 (UTC)
X-FDA: 85238010522.04.36ED74F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A76840009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:32:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jROXMDRf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jROXMDRf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790001159;
	b=KYgNkFmpI8CWAldDKHJqZmmNDJa+rJFAKLH0HHvNNLB62CKYiLusOet3uA+gfUuwQlZEWp
	8rEyMxzqsnsWj+GxaAO4xfZIjO5CqFK0AYDh9yXA50odJjY89l4FgjV1CrK/n+HO86hIv+
	RXvnfmfnWlh4RPpwKUbMf06iLd8nzYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790001159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DNM4B/DKlNamjDekFwegs2ASgo7JXOtIGUcdV58DYc=;
	b=WNKA4uIgtaxLcHTfeEDJ67pNlhuh22srzFu4t6pAbLeiy79raoaJTVGugea6JHBOv3cF1+
	+Yi0ssS1kH3c5tMeb9q/zbInjB1py35pH5okP360ooPtwSKDe9iQp0+WHsTGulaRgQHduL
	oF6vj/gtOUk1RhfbOD0lMWqCPweqUmw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1DNM4B/DKlNamjDekFwegs2ASgo7JXOtIGUcdV58DYc=; b=jROXMDRfo0GolAgRZOKDUIe1Ny
	oXuMeZRRQqhnqgHuusb8v8dJoNC9zcEOyLyZu+BZBcvWhFhozxE0ZJwYdMdP6PDSfDlIRIR+9FaPd
	t9XL38hNAX9fuXWR7lA9GQvwALO6oXas5lgdKJtQigxTlIok/zX9rUO5ZtjQtfnLoEcYl6U6r/OX/
	m/quCLTYp0ULCRVgY0tve0ib7FCqfpCfOIbSgBZhHNodcIB9U/8phtzDRWkQTu1/MWyVFGlcLJMPZ
	yjRrLCQKowCumoAukJuexM5Q8Xa7a8temrLWl6RqAXjilfvXE9hRDJxrA70tuTCIAY+RnvcX+UIFN
	5v4lKQZQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8f3Z-002Gnz-2x;
	Mon, 21 Sep 2026 14:31:46 +0000
Date: Mon, 21 Sep 2026 07:31:37 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <arE3UjqPsxctWckg@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A76840009
X-Stat-Signature: zj9tjbzfwob3snwqk6wkinotqs8jdzn9
X-Rspamd-Server: rspam01
X-HE-Tag: 1790001159-628611
X-HE-Meta: U2FsdGVkX1/Om5S2W6VCPnsJY7VbFy863/pNb/OY+rL10Lqq9U0Fs1UO6m9ATefScRZZgz93txXeyGZMh2mAmMzZyhd46U10aymveinODedGpxD8McHcDHc5ggShOxhfV5MQG+tBN09XipHhyjaeEWUGqNPnxnjyjZhujeAr1vA2/DiVjkvHc5ov3Xnq5Z8488R/3DSdZ46eMlbynY0dkqyVz4ZLleAnkyHhxIDL5Zv+CJ1xAiZdwRjnGytkKvXjY3el4/oQA2QLr06YVD6uYb8kOzSxKFziMleHaQQaj+x+MrpO7x7U+4A8Dq1I97LtvSfpyUT/34mph1ZWupMgDEw8mmxnGhB/HVUGpgIK/5Lw859ZscusFzbZ83EZzkoZenLsCk9UPZvx0XS7B+2gZ8p/TLVp8PLaiafl3JtA+el7Wo/IqfHnoOK598JgvJ0WFJ+cOR+/g86DddbJeE09TV1TQXCrbRNHbiTnzWBkjPo1Gln/BmsfBIatru8BdxX98L2NkcdsIQFAAuLaIVbFJDgzlg7hJAV+nrhbJUHRr6l0WfwrevhT/a8WM2ZvV96IjeHIAw/Q8LHj/5FeidVWpTGNeX0GYiZSyxPAhETV4p/q7EyHm/X2Hre1Yr+FWciJcQ8LgA0gaxMgJ5GC018qXqd8Sp0KF+RQRqgUWxJXJEyLcvWWvh4RhnnM0mEGCorn20apbnbBiGAlXslwfFwYwzzTtmBJP+ftWhgm5HYmjfzAIvesLRghymsir5HWbYNjmJ5U3xyLsFNyZxq7VCzlVtbVboAQP97Qm04WaxvDBN4OWWqmsA7PwSEaSczV/aroQwslPICbGbY8X0TqlCFjNIJPEBdcvvSfS9YB/B0nCHeC861pBGNUZx+qmzLy81qvMwPrS9CC2MXUp/T5wpOCsxS5O32noZe0YUh45DAsoCZUDoLljFtmjh3PQQ7CZLt/pw3yYuLyZHGelyswOVB
 //bGUulp
 ePlBor0n5ZkK4nJvC099g+OrnCChLJSyVr6+9NuB32EAlrf+2PgqcSJCFC9jcw3/DDVCnuFbdNCQwrq0+S17B6yOrIIaP0cXTyG8pmxoIhuJ6r4vsHcDQNvfo5dtxgcbMPzoXnU8h3H2IsW7o1bNlA7lRbSq0areh81xUHI9Um0VkeJPVABgsUpftjXMdICsieCpQZ6JsY8T5e4bKblQYvd2V0R8EXhreLXGQ+UdsO9AfrgeWkPxrhi6ku3IzXwriwUDue+J9VAnit6kOzoghykgYiUZopVwETrFJiQNn0H4NdAEhb9bqHGoP+ucDbeK/dznRxmFEasTJKK3jcWX40E0ZN8x1+BKTEmscxyGcDu7JwmB7BiZ5IQe3E4E/3uye/YO7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:16:25PM +0200, David Hildenbrand (Arm) wrote:
> On 9/18/26 17:22, Breno Leitao wrote:
> > On Fri, Sep 18, 2026 at 02:18:03PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/17/26 15:01, Breno Leitao wrote:
> >>>
> >>> Fair point, I'll clean up the naming in the next revision.
> >>>
> >>> I'll also add that ->empty field, which should help locate this bit
> >>> faster and may let us skip the bitmap query entirely on the happy path.
> >>>
> >>> Anything else you'd like addressed?
> >>>
> >>> Good to know this moved the needle from "David hates this feature" to
> >>> "David only hates the naming" -- I'll take that as progress.  :-P
> >>
> >> ;)
> >>
> >> I think the crucial part is to find a way to cleanly distinguish our source of
> >> information, and also how the source does only apply to some memory.
> >
> > Right, we have two source for poisoned page information, today.
> >
> > 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
> >    poisioned, and will be passed around during kexec.
> > 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
> >    touching it.
>
> How are both kept in sync? See below.

The EFI table is only written when there is a memory failure. That is
the only thing that writes to it:

	action_result() -> efi_hwpoison_record_pfn() -> set_bit()

You can see it on patch "mm/memory-failure: efi: record
hardware-poisoned frames into the poisoned-memory table"

Then, when the kernel kexecs into a second kernel, the EFI config table
is queried and the pages are poisoned from it at boot, as they are
getting into the buddy allocator, in __free_pages_core().

You can see this at patch "mm/memory-failure: keep inherited poisoned
frames out of the buddy allocator"

> > And I understand that this design is fine, and we want to be easy to
> > identify what we are querying on function name. For instance,
> > I understand you confusion in range_contains_poisoned_memory() came
> > from:
> >
> > range_contains_poisoned_memory():
> >    * What the caller reads:
> > 	* "is any memory in this range hardware poisoned?"
> >    * What actually runs:
> > 	* "is any bit set in an EFI table that a PREVIOUS kernel wrote,
> > 	   at 2 MiB granularity, for this memory region?"
>
> Right, and we should use that only as a source for anything during early boot.
> So maybe it should hint at the "early" aspect somehow.

Ack. What I have in mind is to make the read side mirror the write side:

	efi_hwpoison_record_pfn()	writes
	efi_hwpoison_recorded()		reads

"efi_" says where it comes from and "recorded" says an earlier kernel
wrote it down, rather than it being a property of the page.

On the "early" part: it is not strictly early boot, since
generic_online_page() reaches __free_pages_core() as well. The real
contract is "before the frame enters the allocator". I don't think a
name carries that, so I'd rather state it in a comment on the function,
unless you prefer something like efi_hwpoison_recorded_preinit().

> Which brings me back to: is the bitmap kept in sync when memory gets hwpoisoned?
>
> That is: as memory gets hwpoisoned, will the bitmap get set immediately?

Every hard offline does, yes, and by the same path:

	action_result() -> efi_hwpoison_record_pfn() -> set_bit()

Three deliberate exceptions, so the sync is one-way and conservative
rather than exact:

    - soft offline sets PG_hwpoison but no bit, on purpose: those are
      functional pages offlined predictively, and we do not want to turn
      them into a permanent loss for every kernel down the chain.

    - a bit is never cleared on unpoison, because a bit stands for 2M and
      cannot tell whether the whole unit is good again. So the table is a
      superset of PG_hwpoison, never a subset.

    - a bit covers 2M, a flag covers 4K, so one bad frame comes back as
      512 flagged frames in the next boot.

One more case is a bug rather than a design point: the
MF_MSG_ALREADY_POISONED guard also skips the record, so a hard error on
a frame that was soft offlined earlier is never recorded. Sashiko caught
it, and v6 moves the call out of the stats guard.

> > So, I think think this is a naming issue, and I need to think more about
> > it. Maybe appending efiposioned (on data that is coming from EFI config
> > table). Let me think more about it.
> >
> >> Regarding this patch here, I'd assume it's sufficient.
> >>
> >> But I do wonder why we are walking pages when we have a bitmap to walk/process
> >> at hand?
> >
> > Because the counter has to agree with the page flag, and the page flag is
> > not the bitmap.
>
> But how could they go out of sync? I'd assume only for memory holes
> (!pfn_to_online_page), but for that we don't need to test actual page flags.

True for the frames the table marks, so the walk could be narrowed to
those and not test the flag at all (untested):

static void memblk_nr_poison_init(struct memory_block *mem)
{
	....
	for (i = 0; i < nr_pages; i++) {
		struct page *page = pfn_to_online_page(pfn + i);

		if (!page)
			continue;
		if (!efi_hwpoison_recorded(PFN_PHYS(pfn + i), PAGE_SIZE))
			continue;

		nr_poison++;
	}


> > PG_hwpoison in a block is the union of every source that poisoned a
> > frame; the inherited EFI table is one of them, and it is the coarse and
> > partial one.
>
> So you're saying that this code is possibly racy with other setting code? Or
> which other sources might there be if the generically called
>
> range_contains_poisoned_memory()
>
> wouldn't be able to identify it (and it only queries the bitmap?).

Not racy: memblk_nr_poison_init() only ever runs at boot. It is gated on
MEM_ONLINE, and only one of the two callers passes that.

	memory_dev_init()		-> MEM_ONLINE	(boot)
	create_memory_block_devices()	-> MEM_OFFLINE	(hotplug)

So the hotplug path returns on the first line and never walks, and at
the point the boot path walks, the only thing that has set PG_hwpoison
in that block is hwpoison_boot_page().

> > You might ask why I do not just count the bits set in the bitmape and
> > multiply by the frames a unit covers.
> >
> > That was my first try. It over-counts: a bit stands for a whole 2M unit,
> > but only the frames that reach __free_pages_core() get flagged -- CMA
> > comes back through __free_pages(), the initrd and __init memory through
> > free_reserved_pages(), and KHO-preserved frames never get an initialised
> > struct page at all.
>
> Why are other hwpoisoned pages not flagged? If initrd or anything else is
> hwpoisoned, we should not be running this kernel?

For the initrd and the image, the previous kernel's record cannot stop
this kernel's loader from placing them on a bad frame. If that happens
we consumed the poison in the relocation memcpy, long before any of this
code runs. That is the kexec segment placement problem, which Kiryl
raised on the RFC and which I split into its own series, which is landed
in some mm tree already.

https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/


> >
> > And the over-count cannot be undone later.
>
> The inconsistency is worrisome.
> I wouldn't say that I hate it but it certainly has "great, more hwpoison hacks"
> smell to it.
>
> We have enough semi-broken hwpoison ... stuff ... in our code base already. So
> I'm hoping we're not adding more to it?
>
> > If the walk itself is what bothers you, the way out is not the bitmap
> > but counting as we flag: hwpoison_boot_page() already knows the pfn, so
> > it can bump a per-block-id counter in a small memblock array that
> > memblk_nr_poison_init() then just reads.
>
> The inconsistency is what worries me.
>
> And that we have pages we are told are hwpoisoned but we seem to ignore that and
> carry on with our kernel letting it boot?

The walk exists precisely because of that inconsistency: the counter has
to match the frames that actually carry the flag, and the bitmap says
more than that.

If we drop the page walk, then there is change for inconsistency, but,
as-is, there is no inconsistency.

So, I am planning to keep the page walk above, when there is a poisoned
page in the memory block, avoiding any inconsitency.

> > Exact by construction, no walk. Happy to go that way instead if you
> > prefer it.
>
> Let me first try to understand the semantics here.

Thanks for the review,
--breno

