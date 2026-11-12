Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF299606A880
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3zQOrdN
Received: by kanga.kvack.org (Postfix)
	id CCCCF6B05B2; Thu, 12 Nov 2026 06:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4396B05BC; Thu, 12 Nov 2026 06:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93216B05BD; Thu, 12 Nov 2026 06:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCE66B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:57:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F5B2A0554
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:57:33 +0000 (UTC)
X-FDA: 85426317186.03.3C03971
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2BC33160007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:57:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3zQOrdN;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/+u8wryAfnhidm+5ywgfAqYpYqGesuyWI0G9gxrH3M=;
	b=G5uePx5N72H+3Mf9dBx9VrXjzhxUNnqFOjD9/9LupIxXSPBMezZdOWfebQ719UyaG9As0B
	CsPITx48SY+tKmYTH6jtLsurnBitDLSIlutW8hHHcO3Kl5q14MXP1JSAb94qFa49UvcopM
	raQf9TmTx7ORlFwiF2Ys5MSL7Jecsp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484651;
	b=XuOyUFw4IwIi7r2Dtx4PPVmAmNtw8zddug7UZJpVHGA3Jp7FVGBFQQBkvH9vFRdZBVTIuk
	BOxEIvA+B3FDW9uD48KJIkjBlw2MtvI2EpleoM2qqSnkHxKEmks2pqYp1O/BpC5Kp3M4db
	golnenF7rfCyWPpfIJ2VZI2Ienhmnlo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3zQOrdN;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B8763619;
	Thu, 12 Nov 2026 11:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D7E1F00A0B;
	Thu, 12 Nov 2026 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484650;
	bh=k/+u8wryAfnhidm+5ywgfAqYpYqGesuyWI0G9gxrH3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3zQOrdNgul9MB7prRZt7XD4EGkGFdeC+C3HzVNHwAMV0RSVzO6CzfgZWnzLmwI7z
	 MtJpZdBTjvwg5XCxH+ZJOVI8FiMN4i9rLq5RLNBe3cSTOb78W85wHzmUU4NIhVxUQK
	 Kk9b0IRIyxbNpPPdw8wiKIWjvsejEQnXmHiXjSnR4ZFl1MxNjoSW29e5V72LPrE0s9
	 MzewkAy+G808m7jz6VSIgt16VCWf6px3epIOq/hgnbIvZOUj0js+FOcQJZHDywaE+7
	 Q+AAt1Im5qfJGVnn0bDhD8Lv1X7OOGWm4Qrjwdc9FYefeae0HEAvJCeH2kkXOlyokV
	 obNRpu/+1RHmw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 87819198003A;
	Thu, 12 Nov 2026 06:57:19 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 12 Nov 2026 06:57:26 -0500
X-ME-Sender: <xms:n6n1asRvSMKt8lZqdd3RjXkBszv8fyN7gvudjZ6B-hleSXeLQe5oLQ>
    <xme:n6n1anW0Fi28Ad5aW0HqQq03DJ5D4Lus8cC55QBxYpFOj1lLblchYvpcU0dVye168
    wrRB9hgAI55MllvGHJLe-HoL0KoEtuA5KhIQipSngKG9ZkXNOKLOpkX>
X-ME-Received: <xmr:n6n1arLLRDMZpcLHqdbwdiVwGBSthKLghs4bvAc7vJBX6XWSv5lcKlpFaH0>
X-ME-Proxy-Cause: dmFkZTGL2ysdhkk3Q9pSt2a5lMctqQHoVOdfgIyLipUx3E+AndjfL22w/xZNqzjFzzjnCp
    T7Ix2eZi3R+Ok4cLC5pDLZGlqK6/fRWNOk4EMBXA3XtDSI4SYuCWPZNLAf8yK5UlN8vx2C
    y7dwBVBBDzu1P0KLwuQU8Z5i+vDsCEutU7YUWMwYrfJczw5P7lhzk/UsejRyA6boaMFoIS
    gO9Rx78X/oRlsRLfma1744JtL3eevcxkOSlTvxTiPgGaJGIlNAZbWt2PIOgm0CnT5k0gVO
    82PkN21pLWvf37VPkhFIqCat/ZUGewQBQBbHv+FXP4g3ug7PyqL6jjLs0shLXMHOf2oNOb
    LlIpCM0cwQ14viXtqL9cJV2Dzw3UHNOvKh94ZVPVIb95qY/VnTh++hSbHErInnC1c8eQ9k
    5QtEibIXGPdPPWtarIYOe8cnUq8Ln0QU+1xjw5lVLGObRRtQ+aAuwOyD8B4w5t/O3/9zP7
    iiWasIeWv5WVygzL+iG0ByJ7ySSv9hE4kfY2O7AZY3rKC6Yu4fNHwCn26rxFCRrZVYLA60
    RATf+q+PGmsA0uLMtUucAQbXNRtHp/u0WqNfbv/1zM7Tqo78BfDLhqhH/2vxMT4Hx2jAln
    7KocoYABcsVaC+Be0Mi6oyEGDqdJBq6ebeRL6g0zbg1Ljb2ejRvtr6jj6V3A
X-ME-Proxy: <xmx:n6n1aqZLdv_DDmx5T42wQsF6revHzywPm8jyJN43zuQKciQRF2Aamw>
    <xmx:n6n1aj99ug-UY_yU0sIuRzEl7c2IXugeH0gaQRaXCBanrPZH3JXKng>
    <xmx:n6n1aiCqcIyXbRZ9kBG5nquPKtXvxBpYlhSmIWP2owWiuXFq6H_MTQ>
    <xmx:n6n1aglzBfNwD9G9fnVYF7FZKuJK2Sg0gIKJkGrXiLFmhuf7c4Cj3Q>
    <xmx:n6n1amv2QK_j6pHPaO1aeMV7A8UBidadsbclmalFiy1pnE1uiNHuKoqO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 06:57:18 -0500 (EST)
Date: Thu, 12 Nov 2026 11:57:17 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
Message-ID: <avWnaR7VVEGa7yNp@thinkstation>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
 <avTA58zlxJZ69TB8@thinkstation>
 <e19f1fff-f1a7-4c2b-8908-2d3ee6a49069@columbia.edu>
 <db9ed03f-0b85-4360-a2e9-f6719773c7eb@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db9ed03f-0b85-4360-a2e9-f6719773c7eb@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2BC33160007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: rfzuwyi1pusm4mfqbrpw87ei9hh4hyq6
X-Rspam-User: 
X-HE-Tag: 1794484651-319511
X-HE-Meta: U2FsdGVkX1+IILm8wpNuHDVZlkIFHMtkOojKI9ykYIk+80xl9HAiaZKXNkXkeGjEc1PLkx1dpx2bf2iZHeqvsEcP25GsP05fbkMz8tys7qi46Md6X9P/VxlVIJsSL3zE7preFxx4fjxkSAjw2zkwv04cOjS569FAEtvdWkZc0yo7NlO2DPogeDdeyQgXnLwzt3dIeNKr3L23gZMeTFtK+lUAiU8d0LWM0ucK71ktaqyCsJkbUTigF6gNkkVtMe2s0/KCpTZiTbGAk4P1nyGiAP8ejx4tP42JZj5XM92RPqI4C6aF4DcdIAamkBn4O0djE61K3858eXCTEg7btigQR13/8hMjrYgmRZRWg9Y0KyVPF7nu75th9aqPD8ZsRyKboYi17AWKoyhpsp0h/wUOMIIdphg4Nrdv0MmbpAeN9ZMlmJMyHPNx5LX7cTHjI9GcBYmm3kce80SfdGxEySooEzf5hDzlCA9PeL4u0FMgc5pVr5pFPXfZ1W/rvgNpTUrbvy2HKWRAi6wgkrUtw4EuhW8SNoSfJ2X8upDa9ifiuLij26fkxxZh36tm5epsJWsXnx9xXJcja0zoTmo9Pz/UsI3xqj1yQLzldtIU9xXXyygYUFYz80RT+g3BZaiddgShibStqaGvV2HpCko5JkARjUszdOTzttv3CcXNlNXSmiYxQX8TpnSHMi59dffyi/OR5GU6RfTaVvDbjhQY4n8rw/jMpEjGO55no8hJIbb0o08wUpIbL+/IvDowr2MI8Dr6TESANYGR9+l04AB5foD2Qgo9bD4o1eledswWwkJMXDsQBoexym49P+V3ySeRGdt1N/qyt5Ju+uX32qbl4WcAgX82p+fNQHWvFCqilbV/0RJsZVrHqTd83NQ5TYy0Ap4HNgX+4JJPro1Dj6JmVqvkMbrY3KmRJneamXBnRktV6sjbMgV3Gw65t5j0OEVbqTcf+y24qdMkPLsf3Y9oqEd
 wkstW1fp
 ijjV3T24PbORU1i+CI9d6umOoYU7U3yqO0y5nsn1X0CanzqYTOZljX7fbBo0XFYRn+99GqdjMqceIm0TELnXB740iR+FhumV1VEZQE0WEdDv/y1y1qGdxO28nWH7VDfetrPgSemFHiGLewf1yIjJcHeIpWPs5+OkhAzFgu12Zv75O0XFyIuTCEBzEhfTCKWIs/7wMRoHDiD2af7defMODuHRHjb7WvILWmQYK8EP+PeTL0qcnY4EfUdhqrl0YtbYraPD+AR9JzGwmacWcOSi9TN/MnvDaJySFZ9RRZJcIbk0JJXQvJwCqBCwMFas5GfDVZEgetGgMjLV5XDIyJ2u3OqDk6F0OdHN+cT6MIhzUgr0gLj/d4vIepaM9+Y1CrAooVx2ETI4abqTK55H1lorwknxtOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:40:38AM +0100, Jose A. Perez de Azpillaga wrote:
> On 11/12/26 12:21 AM, Tal Zussman wrote:
> > + Jose
> > 
> > On 11/11/26 2:25 PM, Kiryl Shutsemau wrote:
> >> On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
> >>> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
> >>> the pages. Writes and accesses to the range after the guard is removed
> >>> are then not reported, and the manager cannot know that it has to
> >>> protect the range again.
> >>
> >> For RWP this only holds if the range is registered without MISSING.
> >>
> >> The zap frees the pages, so with MISSING the first access after the
> >> guard is removed is reported as a missing fault. And there is nothing to
> >> protect again: RWP only covers present PTEs, and a page faulted back in
> >> shows up as accessed in PAGEMAP_SCAN.
> >>
> > So this makes sense, but I think this gets at the documentation point
> > raised in the other thread. It seems that to use sync RWP "properly" it
> > needs to be combined with MINOR for shmem and hugetlb (and MISSING for
> > holes) and with MISSING for anonymous memory. Is that accurate?

Yes. Async mode needs neither: a page faulted back in is mapped without
the uffd bit and PAGEMAP_SCAN reports it as accessed.

> > If so, this should be stated much more explicitly in the
> > documentation + man page. I see that co-registering with MISSING is
> > mentioned, but not the rest of the points (reclaim, collapse, etc.)
> > The example in userfaultfd.rst also registers a MAP_SHARED mapping
> > only with RWP and MISSING, no MINOR, so that should be clarified
> > too.

Without MINOR the example can lose data. Eviction runs in sync mode,
but an offset that is not mapped in guest_mem, either pre-populated or
zapped by shmem reclaim or collapse, is mapped back on access without a
fault. A vCPU write between the pwrite() and the hole punch is lost.
With MINOR the access faults and waits for the handler, like an RWP
fault.

> > Hopefully this will make it into Jose's documentation patch.
> 
> okay, if Kiryl is okay with that I will add it to my upcoming patch.

Yes, please.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

