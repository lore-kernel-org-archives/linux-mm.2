Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53972606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e3rPUk5L
Received: by kanga.kvack.org (Postfix)
	id 3E0876B00EF; Mon,  9 Nov 2026 20:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3926E6B05B0; Mon,  9 Nov 2026 20:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2825F6B05B6; Mon,  9 Nov 2026 20:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3C56B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:34:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FDB0140827
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:34:49 +0000 (UTC)
X-FDA: 85417490298.11.3DD99CF
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A4331C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:34:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e3rPUk5L;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794274487;
	b=NJSaZVuryMTeMvfc1Sh+js/t6lpVkdAw+4dag2CSaGjb+sXm7fyPRCUi0QQ9+Ssm5WE2YR
	9V1zEcO9rL+P11lobllX0oZyFeDJHkUH5cso7NTlv/e9F31IZFrdYOQoecQVyp3Y67S6nW
	0XxXTVgNNTIAC8SeSISGN2YW4eIA3+Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e3rPUk5L;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794274487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mokQoEIcfGB/Z/vjqUY62jcJF6mYDAaM4ddLv+h/SLY=;
	b=w3CKLqMltzwiFWOKqpAXbklPrSvjrmrFdMAnKcpJjfwRHR5/9AzS1NopKZ6wJ5GvF3rwr/
	HpcCA78R6tZH8vy0YCRCXW35R+QFmhPFioFSobXH1ZPcGI1TPT6edFFXGY5xba3NHiU4yW
	/lPWD0ugmyeLtIjfFRC2hbx+fJedxfw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+CVoqE5ZB+NLoPvHg5KqhaCiBL96mDZaZ9g+LiiiVRw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794274484; v=1; x=1794879284;
 b=e3rPUk5LBsgmimyOy8skpozEtHUoQOutbtXA9TzeXUZUSvfztLKgH5mRGn6ssOXUbO9+5d1y
 BmPqVaSdwSHmHpbLMYEuVEpQucHa3jHQSMfny+2YvgTNzFQA4c6B0JehZakiTywzu0+EIA966+r
 /nURuxXHQnCai6wEcOdV7awQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c7e84b47a2292ca9;
	Tue, 10 Nov 2026 01:34:43 +0000
X-Mizu-Trace-ID: c7e84b47a2292ca9
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 09:34:31 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: g@dgvxl46587.localhost.localdomain,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only
 empty anonymous pages
Message-ID: <avJ0p8ZfjZc9EewW@dgvxl46587.localhost.localdomain>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
 <avEkWyGoKsVlCCRG@dgvxl46587.localhost.localdomain>
 <3e126b7a-d7d9-4a8c-9c83-b6fbf5bf1539@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e126b7a-d7d9-4a8c-9c83-b6fbf5bf1539@kernel.org>
X-Stat-Signature: juc1s7jfddx8ogry3h173b55nnf4u1gj
X-Rspamd-Queue-Id: 3A4331C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794274486-451867
X-HE-Meta: U2FsdGVkX1+liz9X2IEbMH+HuvzAvXymm8Xphj4ENO8HN8OAvVzYrF95os4TBKNj7dri1ILSD2mordLWxTCJV2bvaLHtFY+Om1WkQJo1bITYi3SKVNcMWgx+hF6dN+6bqBaCG4eEAVUwljGBdnBBhkJ0dQ07429pQGipBhVJs4I7u9GQYlfIqBhGgoWczfy7uuAiaW4kpbekg2fO5eJ6JCq6uP7FP0G6n27bxlbKQ+ou80fIyeA6+KRADcz5w1wEX2POQlGeEuhf/y4/3HHcZSnsVCQydQr/9iT3X/cAY7HNnuLFB5nrPUdC6jJbprejjB4Ydaprk01EA3QGpsSdNUQStBXkqZRnNtbXLjLR0UE8Md+J04XEI9QS7s9c0NVMLNjnoLcz+nrKmlq+Mk7kGYZyCvok4VmzYXr2pn++S5vljA0b0jIli/rEtaT/Jgt/2vqStuAzq7jLnJpYlgXakTgxz4wShciPk9+zQuZrV7xw+NZadANz590f99jRAKcNETpFLSlYv7ArfA3KXPdsJeVbKdlezURFd1zwgIUpQoHiVYV/QSCtBQnHLovxdXBvv+xWlGtJYvi4DYDAi961SnmO5SDI9BMOIUPOtZasQW6yA2zW0uCJ/41OThLEyCjJ+SowHi8C1No2I/ppgmX3mbfUvgwoY6t2uI2VZipqFPktHGX1JiqwxGInwv6yc8qbGK9x8Wfzcwpc+Pn4yVNXiuVxj1aeiEsThFQcgMpHIDtwXXXT586gfm0BOtgy7R/+D3iqyncsOwlQd8r/bEKPoaQwYGJZ5mnQwin3Vm+CBdtseVZ7t7V8S8UklrI0I+0i/rkJjzkt74nQq8y9PnoFOXZypWRxuzkOHKfdkvXIzCte18dS96tcpyoFgdB80wwq6J5bNLD//zwhzdMb12l5aaMVQl2SBKA6070Cg0FEohG3to+OgYlhAFeUyv/L2K7P+rx/2RW4/X/9YA4+Vk+
 Y9VxZiPA
 CcG9c+T307nokszt3fqsImjw/sPlh3/OBpBVKDbAdLgYPrJm8zxM75osaxtJaoJSZcFc6ryfEIpNnMX8TCitTJczs/DYiAap3chYIehJn8AhAgW0V9ZjIw+l+v3Xyz/4EumNpZjEc92upYJAaT+mWxDpU0tTXMQdw0PVoh+shLJ1UMSSKrXY6j2LaUokLbt6kF2z5GM1Po9XXoAmnShSPu2gHRm/xwwDw9pweOgP+ELk8HhQqB5Te8YiVemEx/UgRRlIfxHKi18STmeTpGkkxy4hTa26XhkLR3oIDeOAivciFGyhSGd3i9YF6VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:41:39PM +0100, David Hildenbrand (Arm) wrote:
> On 11/9/26 02:39, Xu Xin (vivo) wrote:
> > On Sat, Nov 07, 2026 at 07:28:50PM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/6/26 04:48, xu.xin@linux.dev wrote:
> >>> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> >>>
> >>> Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
> >>> which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> >>> pages with the kernel zero page and skip the stable and unstable trees
> >>> entirely for pages that carry data.
> >>>
> >>> The attribute requires use_zero_pages to be 1, and the two are kept
> >>> consistent by symmetric constraints: it cannot be enabled while
> >>> use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> >>> off while it is active (-EBUSY). The new attribute can be changed at
> >>> any time and is only effective for pages merged after the change.
> >>>
> >>> Benefits in three aspects
> >>> =========================
> >>> - Memory saving:
> >>>   On memory-constrained systems such as Android and embedded devices,
> >>>   zero-filled anonymous pages are the largest source of duplicate
> >>>   anonymous memory. They are produced by userspace allocators: the
> >>>   zeroing of freshly allocated Java objects and buffers in the ART heap
> >>>   (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
> >>>   preallocated media buffers. Merging them with the kernel zero page
> >>>   frees a significant amount of physical memory, which matters as DRAM
> >>>   costs keep rising. With this enabled, we measured 100MB–300MB saving
> >>>   tested with several popular applications on aarch64 (Android).
> >>>
> >>> - CPU overhead reduction:
> >>>   Merging only zero pages also reduces the overhead of ksmd. A page that
> >>>   is not merged with the zero page carries data and can never be merged
> >>>   with the zero page, so there is no point in searching the stable tree
> >>>   or inserting it into the unstable tree for it. Skipping those tree
> >>>   operations for data-bearing pages reduces both the CPU time and the
> >>>   rhashtable memory footprint of ksmd, which makes zero page merging
> >>>   practical on low-resource devices where full KSM scanning would be too
> >>>   expensive.
> >>>
> >>> - Security:
> >>>   Finally, this shrinks the KSM side-channel attack surface: only zero
> >>>   pages are ever merged, so the sharing status of data-bearing pages is
> >>>   no longer observable through KSM timing side channels.
> >>
> >> Lol. Did you come up with that or an LLM :)
> > 
> > Ha, fair question :) This came from our own investigation. We were looking
> > into whether KSM can actually provide benefits on Android phones, and this
> > observation came from real-world application workloads. To be fully honest:
> > I did use an LLM to help polish the English wording of the commit description,
> > but I carefully rechecked and verified every sentence myself..
> 
> The reason why I ask is that this effectively disables most deduplication where
> KSM was originally invented for: VMs running the same kernels, libaries,
> executables etc.

Yes, it closes the original scenarios like KVM, so I wrote a Note to say that in
commit description and Documentations. But it opens up some new application scenarios
 — scenarios with high security and low cpu-consuming requirements, where merging
zero pages alone can already bring benefits.

> 
> So yeah, disabling most deduplication shrinks side-channels ... by disabling the
> core functionality of KSM, to dedupicate pages with the same content :)
> 
> > 
> >>
> >>>
> >>> Note
> >>> =====
> >>> - Suitable for Android, embedded and low-memory devices, where zero-page
> >>>   deduplication is wanted but full KSM scanning is too costly, and reduced
> >>>   KSM side-channel exposure is desired. Many handset vendors may prefer
> >>>   this knob, which can be used as a default fallback policy.
> >>>
> >>> - Not suitable for server and virtualization workloads containing many
> >>>   non-zero duplicate pages, where vanilla KSM provides better memory
> >>>   savings.
> >>
> >> I proposed something similar when I was still at RH. My concern back then was
> >> that we don't want/need all of the stable/unstable trees.
> >>
> >> IIUC that's all still in place in your implementation, right?
> > 
> > We still keep the stable/unstable tree data structures, but zero-page merging
> > does not participate in the stable/unstable tree search path. One more reason
> > for keeping them is that merge_only_zero_page is designed as a dynamic knob
> > that can be toggled at runtime, so when it is disabled KSM can fall back to
> > the traditional full KSM behavior.
> 
> 
> What's the memory overhead from keeping these datastructures in the
> merge_only_zero_page-only path?

In the merge_only_zero_page-only path of current implementation, the main memory
overhead comes from the ksm_rmap_items for non-zero pages, RB trees of stable and
unstable, and mm_slots.

If the allocation of rmap_item can be avoided (following Tu Jinjiang’s idea), then
only the stable_tree and unstable_tree remain, which are basically empty, and these
overheads become so low that they are negligible. The mm_slots are essential so can't
be avoid, but won't take up much memory.


