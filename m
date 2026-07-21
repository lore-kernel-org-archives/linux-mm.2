Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A6AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F246B0099; Tue, 21 Jul 2026 04:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9412E6B009B; Tue, 21 Jul 2026 04:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830B66B009D; Tue, 21 Jul 2026 04:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3DA6B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:06:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9FC0A0450
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:06:46 +0000 (UTC)
X-FDA: 85012052412.23.764B937
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52052C000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:06:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoXxF9gL;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRC91WJZB8K86VbjtUS5rd8+YdjblueKOYRzcZP+nsE=;
	b=nmYzNTvOiu6qbwzUgC5BOzxR55y8bbFnY586lLkJfyx4DcQ1BEYcw8lTnLjX/kau/0+BPQ
	O/RNoGEtpAeR9ngXYl/jJLXcg1M45pmb7zu2hramYnxqd65tkHqSVUTaIM3S8C/ulzIZGX
	z6bW+UMVS3Y2hyjNPzqVYBM6zy8vZ04=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoXxF9gL;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621205;
	b=UuJXqTMEIB2HwZADgLKFd4k2jUT+frYbXNxcs42yyPRS1hYGAF+rKLm2W7bGBc2nP2AGMJ
	DfJh0J7VJQ5VUQz30FFRz2aATEgNi43HxSZ9c9KNFDZVY/LrYmlyeecEdtaCYhmRifdA5o
	3EKbZcCFysrYifI5VFDuPc9N57g8wzs=
Date: Tue, 21 Jul 2026 16:06:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784621199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRC91WJZB8K86VbjtUS5rd8+YdjblueKOYRzcZP+nsE=;
	b=GoXxF9gLCWOZ154SIxCP7kilRCqGxaRA7Q2wYzfIT/kdR9Lh1rosaSxTn8PZx5kF15XCys
	MPvedDbt5SO/WrWkissscNc5BdndpOvP8zvbqY1rj/3dgtn7tag1ZzFxXz4Zf5CDos2kSr
	lIxAWyPrR5ammgU5UCOV2LQYBWgg3AE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <al8ohWshSSZ64AtT@MiWiFi-R3L-srv>
References: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
 <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv>
 <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv>
 <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52052C000A
X-Stat-Signature: 51jenfe6q3kxrmrkxcbjwnhcfhsn3tz5
X-HE-Tag: 1784621203-306129
X-HE-Meta: U2FsdGVkX18DLMBLZIO9aUk/tNPxIvqF+GSrhpTjLoP+MG1ndVZjR6WEY7tHxNYAvcuum297VP1uMLUWQZtvrXVwfnXm+WHve9poCIAHJ3Fa0PtMZgZAjSmdysY1bmiBR/ByA3P1yal/XZvh1Twb9lSChKKh8i3sOnNh7YQuqp1zLIqjrElurwjYotUNIxtWIgZ+zXj2BQ1gRhw3Zft/MFeuiebZmlHvEyQaQLi9myBfPp0kmN6vdJlLPbbVNSszIXlMpvyCgPN1U0SyXC/EYCqfz7My9M+kaZLI35pUKDpi+U08TBzVeUdoumdibHmgQRN/PhG0R0EzqBLDjtt1rPq9wvkNnFP6KPh4/lSgfaCuOXg5PVZr5QlBPpbFhY5GxplZ2kAP1I1hjUsuHUb2VKr0WonUJJGnflYQvjW/EFZdnhJZsT9Wk0HYmHaAW1nr7Oou6jeh0gIo/60SBAIL87Cf3alwNOrcIgTq3UkKZ9aW/kkYJqCjghtatwXVXTqeyCiWYxCIEMINtxnmS1FZRF7m3ip2QfphCYiiKl4g6Uw5NPwmrCPYOt8et/FTk2ttg0I4rKAc3ptiZqvS7sWk4+KYWLCy/LIL7I04UzBYKdK1nvWtP469lMBPkPJUvm29taDkO/BH31Af9K09sgorKAbK4qeGPNebJnTv5UXqRZ+Ajd6WwWR0L6FdCJMe/MRSB0Zj6/gytsexukurvKIurQ8nantyfOh9sEXbLxZbag9IQEJDX6RVz6qohRznjspTJyhZ6BeIQnXsBXCiNjn4RzAsVwR2G/1xsr0U9YcCqPqcBDsbs5l8e8iPLmSfTr2kzs4Kjw448vFzqG0BjK8O7T/ZDPDyNgNSSLlw6sBXvVgzz7F5Vxh7/uJG65LO5xlQoozDHLYgtzCG65UjKL7n2iIkm/iN9XFLlc8xhtIgVyB+wWupR1VCY/OwoGZiPm7VAouEjbxftemmQRtgUQR
 0Be7aKxB
 bZmEgZqcnCVzy42VRDi5xTON3qYxDNx7JBHbQ3nviv+/T49NDeJ1+CZVtYpSb4Hw0QduOJ6t0jaYI2lJoY+JWYavAGRTh741jlQp670Yz/CrOe4sl36m8APnIAb8spMbH3MVi8asleZ2cOWjoi1SyxC7sdrSKe7tyDfsXJ0CfEQegtKQ6HYkHGsT0KEXkUk7Cv2RnPit2GTlN2Do+hqfXdz2SHMxGcHquZu9cK8aB0eYwsjz6zzQVsaMkLK1k/H7Z2W2OEYM9WU0YQHXAaX/t2x/fPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/17/26 at 09:02am, Nhat Pham wrote:
> On Fri, Jul 17, 2026 at 7:27 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 07/16/26 at 09:49am, Nhat Pham wrote:
> >
> > Thanks for the thoughtful reply and the very constructive proposal.
> > Your suggestion about moving forward in small, incremental steps in
> > last mail is really appealing — I think that's the right way to make
> > progress on this. I need a little time to think it through more
> > carefully before giving you a proper response. Will get back to you
> > soon.
> 
> Yeah let me know what you think. I'm planning to send out v3 with some
> more cleanups and fixes, but I'm happy to hear what you and Chris
> wants to make it as useful as possible for everyone.

Hi Nhat,

I've thought about it more carefully. Here's what I think the path
forward could look like. I'll try to lay it out from the bottom up.

1. Data structure

   Instead of introducing a separate swap_cluster_info_dynamic wrapper,
   I'd prefer to add a per-slot backend pointer array directly into
   struct swap_cluster_info:

   struct swap_cluster_info {
       ...
   #ifdef CONFIG_ZSWAP
       atomic_long_t *vs_pointer;   /* or xs_pointer — per-slot backend pointers */
   #endif
       struct list_head list;
   };

   This is allocated together with or alongside the swap table when the
   cluster is first used.  No wrapper struct, no new ->cluster_info
   pointer type change — just one extra field that is NULL for clusters
   that don't need it.

   The name is bike-sheddable: vs_pointer (virtual-space pointer) or
   xs_pointer (cross-space pointer), xs_table (xswap extension table),
   aux_table (auxiliary table), priv_table (private data table),
   slot_priv (per-slot private data) or s_ext (slot extension).  The
   point is that it stores a pointer to the backend owner of each slot —
   initially just struct zswap_entry *, eventually extensible to other
   backend types. I prefer to name it ext_table, but we have had
   extend_table. My second favorite option is aux_table. What's your
   choice?

2. Eliminate the zswap xarray

   Once vs_pointer is in place, zswap can store and load entries
   through vs_pointer[ci_off] instead of xa_store/xa_load on the
   per-device zswap xarray.  The cluster lock protects the access.
   This is exactly the same idea as your virtual_table, just placed
   directly in swap_cluster_info rather than in a wrapper.

   The benefit: zswap_swapon and zswap_swapoff become no-ops (no
   global xarray to allocate or tear down).  The per-cluster allocation
   is lazy — only clusters that actually see a zswap store allocate the
   array.

3. First step for ghost swap / virtual swap: dynamic growth and shrink,
   no writeback yet

   I think we agree that the first landing should be narrow in scope:
   - A virtual swap device that decouples PTE swap entries from
     physical backing.
   - Backed only by zswap (and zero pages) initially.
   - No writeback to physical swap.
   - Dynamic growth and shrink of the cluster space.

   For the dynamic cluster management, I'd like to try a lazy vmalloc
   approach: allocate the cluster_info array as a vmalloc region, and
   use vm_area_map_pages() to map newly populated clusters on demand.
   Growth is automatic via page faults; shrink means reclaiming the
   physical pages backing freed clusters.

   The vmalloc approach has O(1) lookup (simple array index), which
   matters on the swapout hot path.  The trade-off is that shrink is
   coarser than xarray-based management (we can't easily unmap an
   individual cluster from the middle of the vmalloc region).  But for
   the initial landing where swap usage tends to be ratchet-like, I
   think this is a reasonable trade-off.  We can always switch to
   xarray later if shrink granularity becomes a real issue.

4. Writeback and rmap as follow-up

   Once the basic virtual swap device is upstream, we add writeback
   support:
   - When zswap store fails, fall back to allocating a physical swap
     slot and writing out.
   - The vs_pointer entry is updated to point to the physical slot
     (tagged to distinguish from a zswap_entry pointer).
   - rmap for physical -> virtual reverse lookup, needed for swapoff
     and physical slot reclaim.

   This is a natural extension: the vs_pointer is already per-slot, so
   adding a new backend type is a tag-bit change, not a rewrite.

5. Longer-term: swap tiering

   Looking further ahead, the per-slot pointer can also serve as the
   basis for a swap tiering model.  Imagine a memcg with multiple
   tiers: ghost/virtual swap at the top, then pmem, then SSD, then
   HDD.  Swapout goes to the top tier first; when that fills, data
   cascades down to the next tier.  Each swap device only needs to
   know about the device directly below it — a simple "push down"
   interface.

   This is a longer-term vision, but having a uniform per-slot backend
   pointer from the start keeps the door open without painting us into
   a corner.

6. Naming

   We have three names floating around: "ghost swap", "virtual swap",
   and Chris suggested "xswap".  We're going to be talking about this
   thing a lot, and having a single agreed-upon name would help avoid
   confusion in discussions, commit messages, and documentation.  I
   don't have strong feelings about which one — but I'd like us to
   settle on something everyone can live with.

7. How to swapon a ghost / virtual swap device

   There are several approaches on the table right now:

   a) A sparse file created via truncate (Chris's approach): a swap
      file that looks large (e.g. 1GiB) but only has one real backing
      page.  Works with the existing swapon syscall, but the sparse
      file has to live somewhere and the filesystem interaction is a
      bit of a hack.

   b) A boot-time, always-present device (your VSS approach): the
      vswap device is created unconditionally at late_initcall when
      CONFIG_VSWAP=y.  No userspace action needed, but no runtime
      control either — you can't create or destroy it, and you can't
      have per-memcg or per-workload virtual swap spaces.

   c) A swapon flag: something like SWAP_FLAG_VIRTUAL or
      SWAP_FLAG_GHOST passed to swapon(2), which tells the kernel to
      treat the swap device as a ghost device with no backing storage.

   d) A dedicated sysfs / debugfs knob: create and size the ghost
      swap device at runtime via a file under /sys/kernel/mm/swap/.

   e) Something I'm missing?

   Each has trade-offs between flexibility, simplicity, and the
   existing swap management model.  I'd like to hear what you and
   Chris think — especially whether the boot-time-only nature of the
   current VSS design is a deliberate simplification or something
   you'd be open to revisiting.

Curious to hear what you think — especially if you see any structural
issues with putting vs_pointer directly in swap_cluster_info rather
than in a wrapper.  If the wrapper is important for your v3 design,
I'd like to understand the rationale better.

Thanks,
Baoquan

