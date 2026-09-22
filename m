Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BA2C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6808A6B009B; Tue, 22 Sep 2026 08:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AB86B00A0; Tue, 22 Sep 2026 08:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA986B00A1; Tue, 22 Sep 2026 08:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2904A6B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:35:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B26891604AF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:35:00 +0000 (UTC)
X-FDA: 85241342760.06.3A17E04
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0044620009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:34:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ApDtHShH;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/b2H83sBKLfZiu8TvApIXihDp5UwTxcEl76P0l59dTc=;
	b=NiSc9RJyxdGEo6zbH/h3zfSdVDOdx1hXGfohIi94VeEFi0EQE4nsx4dj6y8D7WpVKyqjR9
	XOamxJpMaUorMVhMqCnvU7V4Q+jWHNDQPe8+2xd+Wx9NhhFPn0rrF/uRIsz9UE1q98iUYq
	cBtjjELb2Q+9+Xs6SWx3xhGlVgMpgiU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ApDtHShH;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080499;
	b=4ymYL36LiJQQDhO4zmPhVHC90ZxqI0ZroGQ1Bzc2BjNziwts+SlZa/9BMQig3TeW+y5aKW
	2n0kGBN3kWK04dp/NOE9DoJoCUYc+R1Kuoi4fk5ZvQAA9eYOYIMEssIXsuOyBwR4V+qw6a
	Vsqf3ZviE3CwJbAgoptFr7LpWXHOSz8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/b2H83sBKLfZiu8TvApIXihDp5UwTxcEl76P0l59dTc=; b=ApDtHShHX9N6Hse7lBfOPq8nb+
	TgSY0Dz571CzSHnonuArzlVIuV7weX7CI3axguEuQWcj0BzXmXuLDDqrzOazmizDLYycePe+wsP6J
	SXQEt3zut1yHJ+rcqSJTH7kKPtZxQrXcDcuP5MtN6UzaKC+czp1RebfbbNH2/YmUuYt4NGYNItEl8
	vWOYEyEWHdXMSNzv8P3B4eTZ7c6pdJ4pnYmV/+Y6jCBUOAoTz5qF4FPI1NuSEecEh2ShBZ3T/aKEz
	wg1V5O840zlQLXVW+DXm18LCxo4pi4E48gE8KqJJ5derJP9tKG2ucy8SJjybNSKzyS0BsuPtFRwIP
	HWocWaJA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8zhO-002yym-2k;
	Tue, 22 Sep 2026 12:34:15 +0000
Date: Tue, 22 Sep 2026 05:34:06 -0700
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
Message-ID: <arJqVWN-prvI_0NP@gmail.com>
References: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
 <arE3UjqPsxctWckg@gmail.com>
 <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 0044620009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 37uf8rmsj5qurrsjqk3ibgqm1ipshe69
X-HE-Tag: 1790080498-724166
X-HE-Meta: U2FsdGVkX1/X+7Lb5Hme7HRXAxTc2MKJg14hyu0gv25KyU++wyXS+aH6kADTKEyMdKBBQhbMia6gP97cA2eMu7F1z0rNl+bSsoCPb/Fw3p8trFdf2lsrhJkHBiJZMpF7UJMljeFGt5a+rgpJrLMnIfQ/56EiZ9V0WFiv68f3TtK3DQAuWlxxRhXJzelzhcg4jhrDqR9hLuVUlBUMEj8BJykndgjVpeDaQwut5Ve/CXGzd/mJmzDgcZGgIwj7vmf3qljmF9O4Nyk6UnE+HAE7O1tWGoLoFXKzLURUB4iQUoBt/g6qG9zIK/Ezu2WPV9jiY5IC+ctRAzk1lMCPgKAGqLQkQ0LiTAl+/A9MI7AlesYF8kaqeExmBHwoQq4pVFnTzqfGAaOjedqUVOe1yZa606Sk6iig7JBQ0OJ9ABhrQRFQW0kXpqQ93MgaBVYCY+iPtS7gvoiMBZa67NLihU/lAZ97+Z8q4zw4DwTIofLblC7eUPT9NE3fzr3rY9d5PIoOAQCqOMhtNpZ/0N0/Dyzhd7IZ8cq92P76OK9bhaHToYEMCEzb2P4q6yWkwQ0iqtOwKyYpDX8RQ/HI94QCReaJ9Q83o5HXkqxZSkKlAijaJ1qaMH3kgDB6xCF6PyBKlV0cH6cFu6VGJSQuUSDrD8JgCx972sxSxm5e69II7bpv2LfQ0KG0hnFsOBhcvCAUbHl2Q8Iwdy/6FvYAXSAyR1UJb1sZOyEjdAmNpYIX610pN4eCfuiLUtHQYZZNRJY6GcYHzquwM2J+kpzJU6ZpAphDeTy8RrDgektVPmQFepHy3jbZuYoFar7j0qDyIMwjNPMpR2VGKy9ED0dyGcVFu1Lbddn/pv7Fe6TgE1RJHPc0nQYj0tTCDaAq7jvx1Y2JUjd6ziWQZo+0EmP5AnFtYKBJM3R09BitK6SBPxP0ibXMla/KsWMmetmlk8wpdGipQn/QVXZHfN9o04Xz5URc2wC
 gRE/ay3m
 5+0zCp3usjK2byd1F1+ZddhaylFYx/rl9aqgjKUWISdyqnrN/dyYTa0j3IC3MlpLrqU8kcvBfsuSA/EElu334+P6KeMhzx5Y618Bs6OLB4cr7hJJw92J11X8Ugf0uOaPAO6zixTCA37zoj7k4AY4PGuUtJg6RM+9OCf5RClrm5rZsrymOK5/AWFm+L9CSuQdZgsT/jz86kDG/v0DH4cdSCV4C2/MijqjUscF5fnlncv+lw2IJgd7C8kUh5xTzu/KzN/C3kMRiTpRpb2zYWwYv/TuxCleH9T0MOru9GcoqljF8y+eaPcjVSSYIaGWD8Dro6/Hbzh3r0Z4Y9szH58PPchnJN3PRvvgv3JktpdT+vt+LvuLqpDPBMk8JWlFeIySFxOWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello David,

On Tue, Sep 22, 2026 at 01:33:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/21/26 16:31, Breno Leitao wrote:
> > On Fri, Sep 18, 2026 at 10:16:25PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/18/26 17:22, Breno Leitao wrote:
> >>>
> >>> Right, we have two source for poisoned page information, today.
> >>>
> >>> 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
> >>>    poisioned, and will be passed around during kexec.
> >>> 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
> >>>    touching it.
> >>
> >> How are both kept in sync? See below.
> > 
> > The EFI table is only written when there is a memory failure. That is
> > the only thing that writes to it:
> > 
> > 	action_result() -> efi_hwpoison_record_pfn() -> set_bit()
> > 
> > You can see it on patch "mm/memory-failure: efi: record
> > hardware-poisoned frames into the poisoned-memory table"
> > 
> > Then, when the kernel kexecs into a second kernel, the EFI config table
> > is queried and the pages are poisoned from it at boot, as they are
> > getting into the buddy allocator, in __free_pages_core().
> 
> I am not sure that is really the right place. That means we only poison free
> memory.

Right, and that is a real gap. A frame only reaches __free_pages_core()
if it is handed to the buddy allocator, so anything this kernel already
took from memblock -- the memmap itself, early page tables, percpu --
can be sitting on a recorded frame with nobody noticing.

> Shouldn't we poison as soon as we initialize the memmap, and check
> whether any memblock allocations ended up on that poisoned memory and bail out?


That is close to what I had until v2, where the bitmap was walked at EFI
parse time and every set unit was memblock_reserve()d:

	for (off = 0; off < bitmap_size; off += PAGE_SIZE) {
		...
		for_each_set_bit(bit, map, nbits) {
			u64 unit = off * BITS_PER_BYTE + bit;

			memblock_reserve(phys_base + unit * unit_size, unit_size);
			nr_units++;
		}
		...
	}

Set the full v2 patch at
https://lore.kernel.org/all/20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org/

Kiryl raised some concerns, such as x86 does not keep memblock past
boot, and kexec picks placement from iomem_resource via
walk_system_ram_res(), which memblock_reserve() does not touch. So the
frames stay out of buddy, but the next image can still be placed on
them, and since nothing sets PG_hwpoison none of the existing hwpoison
users see them either.

Most of the discussion happened here:
https://lore.kernel.org/all/aog_uH5fTsJzXjjx@thinkstation/

v3 then poisoned the frames from mm_core_init(), right after
memblock_free_all(), taking them back off buddy. That breaks with
CONFIG_DEFERRED_STRUCT_PAGE_INIT, where the struct pages above
first_deferred_pfn do not exist yet at that point, and Kiryl's other
point was that the shape was wrong regardless: flag the frame on its
first add to buddy, not after buddy is up.

See the discussion at:
https://lore.kernel.org/all/apGbDOnPm5VXP5ez@thinkstation/

Which is how it ended up in __free_pages_core().

> >> The inconsistency is what worries me.
> >>
> >> And that we have pages we are told are hwpoisoned but we seem to ignore that and
> >> carry on with our kernel letting it boot?
> > 
> > The walk exists precisely because of that inconsistency: the counter has
> > to match the frames that actually carry the flag, and the bitmap says
> > more than that.
> > 
> > If we drop the page walk, then there is change for inconsistency, but,
> > as-is, there is no inconsistency.
> > 
> > So, I am planning to keep the page walk above, when there is a poisoned
> > page in the memory block, avoiding any inconsitency.
>
> How about we keep it very simple and don't mix information from two different
> sources? That is, remove that bitmap scan here entirely. We should process the
> bitmap exactly once when initializing the memmap.
> 
> From that point on, the memmap should be our reliable source of information.

Sure, is this approach better?

  - the bitmap is read as the struct pages are initialised, and the only
    thing it does there is SetPageHWPoison();

  - __free_pages_core() keeps the hook but tests PageHWPoison() instead
    of the table, so a recorded frame is still held back before it can
    enter buddy;

  - nothing else queries the table.

One caveat on "exactly once": if that means one pass at one point in
boot, it is what v3[1] did -- hwpoison_init_boot() from mm_core_init(),
right after memblock_free_all() -- and it does not work. With
CONFIG_DEFERRED_STRUCT_PAGE_INIT the struct pages above
first_deferred_pfn are not there yet at that point.

Link: https://lore.kernel.org/all/20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org/

So I _think_ we want to do it once per frame, as that frame's struct
page comes up. __init_single_page() is the single function they all pass
through. Is __init_single_page() the right place to query the bitmap and
mark is as poisoned?

> For this code here, just remember globally whether we hwpoisoned any page. If
> so, just walk the memmap. If not (the 99.9999% of all systems, no need to scan
> anything).

Yes, and the counter already exists: num_poisoned_pages and we can query
it. I am also planning to add something similar in the EFI table, like
an ->empty field, which will be cleared when a bit is set, avoiding
doing bitmap walk on the happy path (not a single poisoned page).

Anyway, range_hwpoison() short-circuits on it today,

      if (!size || !atomic_long_read(&num_poisoned_pages))
              return poison;

so memblk_nr_poison_init() can gate on the same thing and walk the
memmap, with no EFI call left in drivers/base/memory.c at all. That
disposes of the misleading name there too, which was where this
started.

Now, the half I am less sure about is checking whether a memblock
allocation landed on a recorded frame. Poisoning at memmap init cannot
prevent that -- the memmap is itself a memblock allocation, so the
struct pages do not exist while the early allocations are being made --
it can only detect it afterwards, as a pass over memblock.reserved
before memblock_free_all().

The alternative is to bring v2's memblock_reserve() back purely to keep
the early allocator off those frames, and still poison at memmap init
so the flag is there for everyone else. That gets both properties, at
the cost of frames that are Reserved and HWPoison and never in buddy,
which I have not thought through for unpoison.

Thanks for the suggestions!
--breno

