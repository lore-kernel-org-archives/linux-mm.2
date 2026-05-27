Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A83CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D426B008C; Wed, 27 May 2026 04:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD0A6B0092; Wed, 27 May 2026 04:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3B86B0093; Wed, 27 May 2026 04:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABD46B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:01:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BA9B8F97F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:04 +0000 (UTC)
X-FDA: 84812454048.09.DDBCC57
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 528B540011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779868862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7K0AP7Vb0kG2aAuJVBpnA8wKqyO115OnGpgOcKpb7w=;
	b=CcNB+vZ9a3aD5bEwhgyx2k9Xuz/MmKNk3kLuiI0YZrxCdYm/4nF/VWoGdb92nYZOM3dD5r
	d2iHQVG0S1KkPHJPyJ2+ZMUDSfaqnIWzhhEYtrMJ+3FJ+g0RV8+3yvXKSlNyu4pMvFO4Vp
	60WU2nzCHRVPIwuvW9gBodOBXGy5EzQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779868862; a=rsa-sha256;
	cv=none;
	b=DZRLjpqm9PYZqPrH5pXPHcwbYTG+MaFPRuJtH1gXDHjJ+nb+SxIMwzkN8zm+qqjy1CydvU
	nhOCmZLvTl3pOnCDKOr4j/OAVmQuUDtR9X2gWXv4rzfAwPpLZEZFz4DfUoxM8ARg2Qf5se
	IkC+iw4hpuin2gaGzscxa8PdNiu4RuU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFF7668C4E; Wed, 27 May 2026 10:00:56 +0200 (CEST)
Date: Wed, 27 May 2026 10:00:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zi Yan <ziy@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Message-ID: <20260527080056.GA20040@lst.de>
References: <20260527071816.GA17632@lst.de> <A68C1B33-053C-4406-B78E-871ECD7293B3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A68C1B33-053C-4406-B78E-871ECD7293B3@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Stat-Signature: np7s7rbu9of3b6n74pf559byy1bhnnxz
X-Rspam-User: 
X-Rspamd-Queue-Id: 528B540011
X-HE-Tag: 1779868862-504396
X-HE-Meta: U2FsdGVkX185MNqOiySK1PZTfF3rQWfgWpVGLI6rJHJZYoULIzyiCEOjW1/xRPiO+4z0s6KucULHUT8OM8EHl1B+PbvpLJ3zr6yB+KDZuoTP5GXz17gZ9Gqxy5DN+qE4Doi5xn1XCaJRCiMNa5jkWuy9glegaR8FFd8SSjfxn3efYXETR9bG9ILiWrLYCb2USoi6ymO64aDXTriI47YgL7XrW+TKCouJlvWF+saUTq9KSZB/qYhCOIlaV9xGlCS7a/NTfMAhi+ryJaFl/JXvRbd2mP4a+Ga5WHiB5KnUE6Ae9F7gbVU0put1n7r7q53yAeWBBiskj7QEwPmtRpgmmJRxpqXEQ0IlnUa0lUzUi6gsCi/MvkLfEG9wrl+jtSEPKIN+eBzdkoEiWKlAu3dwV8yTPsDaI8sn2o5DePS1uQzuWU8O3TzeKuO5IU2gN5eDjJj2N7E1zYunAzuwCSC1EY8Dur6CMgJ9pXQYn79A0kzJMRl7o1ZWEXg8efRvd7MiPk0szoKI1M0jwrQQZSRJrVPAWnslB7Ev8XxPOd8PYrw/0KCphXNrZn5ZDclSiia3xtzxmE9+op4rHrx8TMMqFheJqe5by0xn8LoA0dguRpI09/mfSBzcOkriC2Sn1rcaY61WlBrtN2L7avSNQ5zmeQDLAcmWm2kKz1EoY2cK6OiKAWBgonZV9veHB1rk4AvflE3m0Ng0HhnNc62joGQlkShVv8Rnbwfy9KYHXEe8i1M756JsIkbpsdx/EjhZWwT2P0M3bVv1asIy1AYx8PMbg0iYW1r2C97VgUzKcM8367r3FzKcWh0U6rgLr83xuBNOsUw3gdK3BIX4sFR02xmvgzNAfxruSHIp5E0RZFyszcECj08FE/YVZr9R9K+ucWF2R8O36wF1ZTQwtTkiWAFkVwYD+2e+G98FC1HwdOC8M6nqJWvIbVHt6gsFfnNC8aUS5yHAcguwTDOj7PBMn3l
 VTSghf9f
 qJq9pwUdXc62vEhn7HwXv7UpFzB8m6MJcGvIjRjThRJXNvDJXqyluDJUo0EwxPPngScvES5rKy2vwrqrv301QLDC/x42JBfFiiSud09lDCmbfoX3DLtoWZlpBK1xrCaXcLeshr4IKoTkc/W/ot4AiuqJQyaafINx1IxQueds0CfXshLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 03:53:53PM +0800, Zi Yan wrote:
> > 1) early fail semantics
> >
> > alloc_pages_bulks can do partial allocations for some reasons, and
> > users usually have a fallback by either looping and calling it again
> > or falling back to single page allocations.  This sucks!  Why can't
> > we get our usual try as hard as you can semantics, requiring
> > GFP_NORETRY or similar to relax it?
> 
> IIUC, current alloc_pages_bulks() tries to get free pages without doing
> compaction or reclaim unless none can be allocated.

Yes, which is really odd, as other page/folio allocators make that an
opt-in through GFP flags.

> Does your “usual try”
> mean possible invocation of compaction and/or reclaim for every page
> allocation?

If you look at most callers in tree, and my recently merged or to be
merged work isn't any different, they just bloody want the pages just
as any other allocator.  Failing under grave memory pressure is fine
of course, but just failing because getting the memory requires effort
is not.

> I guess it also relates to the order > 0 bulk allocation
> below? My gut feeling is that if one “usual try” fails, the following
> “usual try” might not work. So making alloc_pages_bulks() do heavy
> allocation might not buy you much.

Well, we need to centralize this.  Right now there is lots of divering
cargo culting in the callers.

> But can you elaborate on why looping alloc_pages_bulks() does not work
> well? That is essentially triggering compaction/reclaim repeatedly
> like your proposed “usual try” idea.

I'm not even sure if it works well.  There are some callers that do that,
some use individual fallbacks.  I don't really want to think about that
when all I need is a few folios.

> > The bulk allocator is limited to order 0 which limits it's usefulness
> > these days.  It would be really helpful to do bulk allocations for
> > the pagecache or bounce buffering.
> 
> Sounds reasonable to me, but when under memory pressure, I wonder
> how many > order 0 folios you can get in the end. And that might
> cause a storm of compaction and/or reclaim if combined with Idea 1.

Well, I really want them.  In some cases I might be fine falling down
to smaller sizes, but I also really don't want the logic in every
caller.

> For > order 0 bulk allocations, are you thinking about 1)
> a try and bail-out early model or 2) a keep-trying model?

Both are useful and as with other allocators should depend on the
passed in GFP flags.

> For the latter, I wonder how large the allocation latency can be
> and if that is tolerable or even makes sense, since for THP
> allocations, we have seen >30s allocation latency when under
> memory pressure. Is waiting minutes for bulk > order 0 allocation
> making sense in your use cases?

The allocations I have in mind would only require try hard allocations
for typical file system blocks sizes (64k at most), while eveything
larger is fair game for falling back.


