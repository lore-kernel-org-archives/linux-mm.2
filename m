Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60C6FD8741
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2289C6B0005; Tue, 17 Mar 2026 07:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1EB6B0088; Tue, 17 Mar 2026 07:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A2C6B0089; Tue, 17 Mar 2026 07:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4CB86B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:24:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 908FB1B85C5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:24:16 +0000 (UTC)
X-FDA: 84555321312.09.41FCA66
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA2804000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:24:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CfuU8sp8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773746654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HYSPSrBr6XMwpPFaT+qL1xDiWXaJ1imWzB15lXKN0c=;
	b=R7N5wgaApbh4Tuqf+H8e9AoROsluNNIPYpxThHNua4OCpysYODU/jONrWH9QLh3uXD7z7f
	Kc0ze9/hA1U81wpURNLLQv57KgkUyTC9wzeOkyzpqvrH7eLR8m3m/wu4zkIUNXn3mJP4KL
	6ZFOeYI2PiEmXlyNm9xWIwDNlLwv6Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773746654; a=rsa-sha256;
	cv=none;
	b=wr1io67kk2N/voZfP7edwGbKcCyA0O1yRWYlhgeBDJ2Ml+TEToPkJ9sARwsvKvGhoz2/sc
	nBTFt4dZSrG7v6Snyx3cxwB5rxdtme3vTJDGaFSEjMvb8cSONghuq8wxAIQ3bpsUAiypvV
	Zin4Wa1FNCPygfsISiXY3MZchmKBiug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CfuU8sp8;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1HYSPSrBr6XMwpPFaT+qL1xDiWXaJ1imWzB15lXKN0c=; b=CfuU8sp8RV8jQo+WBsuSxW6xLc
	qT6oatdKGhOsEFIePrg9fySJCSPiVDj6wc7fv9mtJP/yZ9yFxhqaqufxoGtIkqhitJ+g/RyiyTmGP
	HNwuKYDriAvjjZJ+iLDi30N0189eNMdg05VTllYHaBsSqq4djgqDojZwO/Eimz/B3lJiH7eayAYUg
	rIChz3+THC5NmZkyzYw+YgsCjFmT3/gUrICB6jJsjmzHXU/qiYRTdeuiUOA7IZns1QIhuTYBORJHS
	NkwFYcbgS26+8GY3JvWheDTMgH1tcEhakMtJpgG/vQsEG0KKeK/EjdCoBJn7/ypxmRh8BlY/C9LaF
	YEoNHI4w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2SWX-002qgq-NI; Tue, 17 Mar 2026 11:23:44 +0000
Date: Tue, 17 Mar 2026 04:23:37 -0700
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	Wei Yang <richard.weiyang@gmail.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <abk5eqVbwlw1FGsI@gmail.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
 <abfVLky1zanZyEx8@gmail.com>
 <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
 <1b7d1bdf-c002-4543-b858-09fd2b1b73f9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b7d1bdf-c002-4543-b858-09fd2b1b73f9@lucifer.local>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA2804000F
X-Stat-Signature: 6wno3tw941yg3k881sf8pyqxbkj9tfdg
X-Rspam-User: 
X-HE-Tag: 1773746654-724610
X-HE-Meta: U2FsdGVkX1/zWkOkk9YAEXtI8KpnLKr3aROVRfjWUUdaqqtDm6ALpffYXNJHvETurcCN2Fopx3Ul18ZqVKqkAHNn4gRnC88ijwIwvb1JTEOVHDO0wCx9nABE9fZWTBpaVg8DviVCmKUp3NXx28i7y5hXo3saARmqDjO3uYffS32Q7NvZPN/+yiYwrCKAuM6ax6eRLRzkCtjrxiKoTd8lWK9CqfTvONSQvpXCJGl1SnQYQTRyrIkNctO3mFzS2v/oFTF6K5IQJ0Wq/WRMnVRvGtnouzSxngiZjgmiOHlxvh0TlRnNzqbnBqiK0hWaLBUVlgUTWuP+gcon/lFuLiXu7BzGT7ngu+LqMYVgMVFC32e9Zx5vYiyGSRQk0xSv7ywPhJqQMvCD0g1gKhXdKOtm30JwApEZ2CfrS3MmZPXq9KebmbdZrWb7zzQANL3cDbMY1dQjcjDhdVYDs6tbH9+KT10rfiRP9rMO5ndI3LAW59kcZR5d5NuCmKvwpoSINO48NmJ0n2+4IUEbWD1dMg6YLYKq/aZEuAdVkQZPJB9SiLH9poJSPJ8CJbkQ3HrbljCGoS+ta5TmHWQkWnnhkLfhfJAAdgAEkEdPpMZGIg5ILBtmrcbvCL98FRoFuM//HmrYVXTIe0hZDOeIzGgNZX8BVTGI3d4dw+zU/i1Bd+MHemj1PA1hKqZ/O+ttOC3maCluRgqpmaF0MJSKbn6Z9dG6v7F4FIyl91Dq5YjGJKsXrTDSnN+tyMhPD1uB3q9Y0IucflWuV18hxwTwqNwWywJY9z+4juFbTcdQteTqQkXVyYIG7HxqH2c+W0LNoWKewjH8dWBQRosLZdWfA7k4bVj3FkqWkDlYDwg26ZTBzkSVgBgOCR1rnkLU9G393TOxyaXQbQKTy5cne6pIG5V5ix7/9fzCC1+N56fVG8IHpQpqt4BmCeKzMOiW/eQrkKkyxNk8c5SgfpbiR65zBOhVOyn
 RhWzRN0O
 fFppqVbbIKGzwhRzbxFBnWFnXq1ZKRhrS7N3veIBof2ZdyeL5DdVyaIw4KWx7arnwpJncMUt1OBpZPB0gdxmqhHqcag9yazoxeuOUQmP/VXiFhXC92a0txI4feCcoiVewN3/NLK8puVPbiqBCVmkygKqGct5qATVI50cC3L55r4tpMn5hfS/SH78Dme58Zmn6M8ksMYGnerRwYuMeDhKFZ/n5dplgPqJpRbcCc9HcNnK0hD9chouib7+m2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 09:37:39AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 04:26:30PM -0700, Sohil Mehta wrote:
> > On 3/16/2026 3:12 AM, Breno Leitao wrote:
> >
> > >> I am not a mm expert and typically do not follow the mm list. Is there
> > >> an issue with the usage of non-atomic variants here? The commit message
> > >> says this uses the same pattern as set_anon_enabled_mode().
> > >>
> > >> However, set_anon_enabled_mode() has a spinlock=>huge_anon_orders_lock
> > >> protecting the access. But, transparent_hugepage_flags seems to be
> > >> unprotected in that regard.
> > >
> > > I don't think that the atomic vs non-atomic will not help much, given
> > > this is a compoud operation. Independently if this is atomic or not, it
> > > is racy with anyone changing these fields (transparent_hugepage_flags).
> > > In other words, Atomic ops make each individual bit flip safe, but
> > > set_global_enabled_mode() and defrag_store() need to flip multiple bits
> > > as a group. With atomic ops, two concurrent writers can still interleave
> > > and leave the flags in an invalid state.
> >
> > You are right it is a compound operation. So, there is an existing issue
> > with two concurrent writers which can leave the flags in an invalid state.
> >
> > But, I was wondering if there is a slightly different issue now due to
> > the non-atomic part. Some updates could be lost depending on the timing
> > of the operation.
> >
> > For example,
> >
> > CPU1 does:				CPU2 does:
> > set_global_enabled_mode("always")	defrag_store("always")
> >
> > ___test_and_set_bit():
> > // Trying to set bit 1
> >
> > old = *p
> > // reads flags, sees defrag bit=0
> >
> > 					set_bit(DEFRAG_DIRECT_FLAG)
> > 					// atomic: sets bit 3
> >
> >
> > *p = old | TRANSPARENT_HUGEPAGE_FLAG;
> 
> > // writes back old value with bit 1 set
> > // DEFRAG_DIRECT_FLAG is lost (reverted to 0)
> >
> > IIUC, this issue didn't exist before. I think it might be safer to use
> > the atomic test_and_set_bit() to be compatible with the older code.
> > Though, I'll leave it up to you as I don't have expertise here.
> 
> No, it's up to the maintainers :)
> 
> Given the above I think we should switch back to the atomic accessors.
> 
> We can address the broader issues with this horrible code in a separate
> series.

Ack. let me respin then.

> > Overall, as you mentioned below, protecting transparent_hugepage_flags
> > with a spinlock seems like a better, long-term solution to me as well.
> 
> Yeah, let's look at doing a follow up that cleans this up in general and
> address that then.

Sure. I am planning to improve defrag_store() as the next work, and then
come up with this additional spinlock for transparent_hugepage_flags.



