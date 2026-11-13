Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8235606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1CBzsMzp
Received: by kanga.kvack.org (Postfix)
	id DB6116B00EF; Fri, 13 Nov 2026 17:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F586B05B0; Fri, 13 Nov 2026 17:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DDE6B05B1; Fri, 13 Nov 2026 17:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 881086B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:43:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06AE11C27B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:43:21 +0000 (UTC)
X-FDA: 85431573402.10.972286B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 220C0120004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:43:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1CBzsMzp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794609799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AV0Au8QBelDJjxw6Cr2O9VNvKQKnOvtzVap3a+AAzd8=;
	b=oIl9Gz/RGTatpMZvfMKVJBDbEOZg6TycUKTUdUEeLI7CL29Xw5TSvDKXM2fTraEodWpryT
	15YnWP/kDH35WQVDjlW4dSfv96T8f61SXy27hMsauxkKxxTUSbSRuAiSrgOz+25ESAfRQi
	94lVejZwVIBnEAO9OB5dAiky8CZACTg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794609799;
	b=IxT1ul0NGNcO2LKdBmbWiAdcuudplfGLAwMM8TjzMj97Sv2KbQYou5IWIByOAZTgLeMRJf
	FNn5elklAbly5r3dyOzmR0QbWMk/V28i6OwtyZ5GDxwYsKr/PFDw/999q0Qlp4HVPXcLGC
	abZvlAgkhsK9N5Q4LgqMsaD00Xhtm/Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1CBzsMzp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 250F46020A;
	Fri, 13 Nov 2026 22:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D5D1F000C4;
	Fri, 13 Nov 2026 22:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794609797;
	bh=AV0Au8QBelDJjxw6Cr2O9VNvKQKnOvtzVap3a+AAzd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1CBzsMzpCICjs5j6eDtHq8t1cEfqzBvtc9lGjgI1+IyXUv2H1631WtgfyIQBCdvzV
	 zISHw8Yrd2rmW54POF/RKoYHcSRZGhasj94Gbft7w2/PfcWLfb7qcr0ABgoUWDELoj
	 xP/PQlWzaqIvQZirgI6H07h5Phi6ysTz3InJu1i0=
Date: Fri, 13 Nov 2026 14:43:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, sashiko-reviews@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, David
 Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann
 Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham
 <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul
 Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Usama
 Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, Balbir Singh
 <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Peng Fan
 <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason
 <mason@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>, Dennis Zhou <dennisszhou@gmail.com>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow
 stacks
Message-Id: <20261113144316.57192d4ab088e7fc64eee47a@linux-foundation.org>
In-Reply-To: <F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
References: <avYJ-CxBEpdO1Wmu@gremlin>
	<816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
	<avdveCV9uW1zwXXd@gremlin>
	<F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zjty7h7kbpgqfwq9i59zw7rqwswzqzzs
X-Rspamd-Queue-Id: 220C0120004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794609798-378762
X-HE-Meta: U2FsdGVkX1/kMF9ZUswhtdCeuaDqpsPTWcHRNdcRjHldRW3HMgsvBWb1j9wXDdHicgw+gGjVD/16szjzN7bLNIe+xokbYJ62wwp+764vBDjkSDin0ypy5U1oT1vOn7vP1If6Sb35BHxcZ5n0B6ohyvQnZgQPp9sC9wa5mbqjwPNAHm9NLTvb4UKRTG2rWC07RlFIPtvvz6BkhZU2EW93eJqW443yKRu3VksiPB+vYk8Aqot/IEnOPr/aBZrb9FPTBQ3wqu7NtjR0xpXwcMR3iK9NAU/h7uz5Z7cZN7CIXKIaf+Liq9uzVUsGIn4t8/2RQ8spbH2nJAdU9q7vmzx9oZiqNGuVdO3V1hVP1n81TeH0WsfREc7fhT3+gi/TFJQF6MncLs09TwJU9PEAMGxaO/YXnNumniFchX0ICFO8VItSR+5INlUzDPREKvPVOcr72uu4cE8B6jDGMNEKqy+IInrHXJNaUsQ+qsTwQD2SiaC+fa9R6inlsUP6rOHXP+/S4xo+AK9V8/f7C6GSU8KQsBsRXzYyXqlDfk3AzZV0P6meWg0Co9MBLMXrjfSzMZMOnJpU+eqny3KHtcyxvuZs7S/jVo7nDrWB4iQgEe+2TUa3EKb45CYfpQG0sE/4shg4ZeJmXvGhHOeW2X5GmWuN7hvZV/KeCvsN/MCVvFraz54LN6d26o3NKxCAZdKDb0KczpAHx9/dPrYspyDfRFzUcs5cGMuFHogWIr3+KvS5aR03LRn9N2ig9FdnmYA4zh9J+0YzahW5S/cuwuL3g37/mAkFHI5F/5zZv/T1z5gtdfMTxIBmykTiUaKLwehYllBpSF5mjm9aCpCBppvdcHnZCqJWXQw3i4i8qhre3RqYQqryYlXzRxNxOo5dG6CF2SQUkh3XByOZlcAfvbMf4yvnoH2t9nCHfecOxM4nrORLz6rWT0EFrLTNlDKpSeERnMLSwiC/SvMfX6JIxylgR5Y
 IsnCVX6s
 TeehhnAYp0v1OGFEwq/0rEm5PwYZFU5B4isSUzE8LmBHLVLjy3UIoIcD/+zzvCgpDRNLNzxwoEwlYlY4LhdkJSwqh8WpLidMSCFzb5Wk/2ZKMUB6yK0NVGcZd+eszz+NrvjPdTIH9Ohs6DbFD9xPub6SLWrD7/5qMnJxFoKGWouhyBVOPuxuMC/IESExwbam7tkeCc9KnsZh54f1zWzqnepVQ2e0RGhLod5uXbqE2b/fK4WpAS2aVE6mC8F6s9u6Il/+PMXn7Ik6r6sRkRESWpG+tZaBKDAvGgRx0MWEhel1SzsrfkWOstisDLIS0nfra4JYyyZbi7EEsLB+Ua8/eCSJltAvHzrInyT6G27l+HRwGR5FsSGqMFZWgRotutqmjAjcuuSYUQbloAkYOVchNelId8LsdxHSJwqtYc6xSEVwihTTq4JQH1GR3+LDzObHEPDDHrYJRu2Ido6wqdUARxptSEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 15:20:45 -0500 Zi Yan <ziy@nvidia.com> wrote:

> On 13 Nov 2026, at 15:17, Lorenzo Stoakes (ARM) wrote:
> 
> > On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
> >>> On Nov 12, 2026, at 11:03 AM, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >>>
> >>> ﻿+cc Roman
> >>>
> >>> Roman - see below - I was under the impression mm was not supposed to receive
> >>> 'unrelated to this patch but' reports? Did something change?
> >>
> >> Yes, sashiko started reporting pre-existing bugs again, but in a better way:
> >> strictly once (per bug)
> >> only for the first non-rfc version
> >> somewhat related to the proposed patch
> >> not more than 1-2 per patch
> >> not exposing security-sensitive stuff this way
> >>
> >> Obviously the goal here it to increase the chances for the problem to be fixed.
> >> It’s global, not mm-specific.
> >
> > (Sorry only just saw this!)
> >
> > Ah, I thought it was an mm opt-out.
> >
> > In general they're spawning a lot of AI sloppers to go off and send ever
> > more fixes and causing ever longer days for us, it's quite a noticeable
> > impact unfortunately.
> >
> > And often they're duplicative of already-sent fixes so you can see the
> > conundrum with this :)
> 
> I wonder if there is a plan to make Sashiko identify duplicated fixes
> and send an email to point out the existing patches. So maintainers do
> not need to do that manually.

Yeah.  That might be judged off-topic for Sashiko but it would be a
useful addition and it'll be cheap.  But as usual it'll find every damn
thing and flood you with semi-on-topic info.

I've been training my thing to do this - fighting fire with fire.

The main issue is teaching it how to get reliable, high-bandwidth
access to git and to mailing list archives - LLMs are often blocked for
<reasons>.  For the mailing-list problem I gave it last-resort access
to my local 100GB of email archives.  Gulp.  Dovecot's indexing helps a
lot!

For this particular patch it went nuts - indiscriminate information
overload.  It's usually more useful than this!



In: "Check this patch.  Has anyone else attempted to address this issue?"

Out:

: Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
: 
: This looks right to me.  I looked for earlier attempts to prevent this
: and found fixes for related paths, but no earlier shadow-stack check in
: migrate_vma_setup().
: 
: The original shadow-stack series taught migrate_vma_insert_page() how
: to install a shadow-stack PTE.  That handles migration's insertion
: path; it does not decide whether a page may migrate to a device:
: https://lore.kernel.org/all/20230119212317.8324-20-rick.p.edgecombe@intel.com/
: 
: 6beb99580bc0 ("mm: Don't allow write GUPs to shadow stack memory")
: blocked ordinary writable GUP, while retaining FOLL_FORCE for
: debuggers.  It does not constrain the permissions handed to a device:
: https://lore.kernel.org/all/20230613001108.3040476-23-rick.p.edgecombe@intel.com/
: 
: 3c58f641e813 ("userfaultfd: prevent registration of special VMAs")
: closed another route, where UFFDIO_COPY could inject chosen contents
: into a shadow stack:
: https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org/
: 
: Nor did the recent VMA flag conversion remove an earlier safeguard
: here: the old VMA_SPECIAL_FLAGS test did not include VM_SHADOW_STACK. 
: So the proposed Fixes: target looks appropriate:
: https://lore.kernel.org/all/20261013-b4-mmap-prepare-vma-flag-sanify-v6-36-1aa3c9b139f9@kernel.org/
: 
: Alistair's hmm_range_fault() question deserves a separate follow-up. 
: That path also turns pte_write() into a device-writable HMM_PFN_WRITE,
: and nouveau uses that flag when mapping the page.  The proposed
: migrate_vma_setup() check does not cover HMM mirroring:
: https://lore.kernel.org/all/avT2FNTZoEuijEZP@nvdebian.thelocal/


