Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94026606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N9gTsIvA
Received: by kanga.kvack.org (Postfix)
	id ABC9F6B00EF; Wed, 11 Nov 2026 17:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D4F6B05B0; Wed, 11 Nov 2026 17:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982C46B05B3; Wed, 11 Nov 2026 17:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6C56B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:18:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13E75A0461
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:18:55 +0000 (UTC)
X-FDA: 85424254230.26.B2F3A69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 45C301C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:18:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N9gTsIvA;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794435533;
	b=8CLF/dHrEjGpfD+5r1aduB8ym9xQf5aLm5GGL9tEyZfxFVRujQ0kLZVCyxH/qauurutytj
	rdUkkrEMtd0aF1VLKwMVEL47kK5i0RvdbqQyU1OhMF543PoBBWkNQm6SBAkJL73mkVgQM2
	vE+EJa3MXjFFY/EtT/GUvLiGErY7SJo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N9gTsIvA;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794435533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhV5+1cS0emO9WNIGDx6eBvv8/9J401vylAgxkfRXbk=;
	b=MRGZDHBoQkqPGKhF7tGnaK/h9l7WSEIdRQLSfxpSqjia4ItPXvAy0Q5xDx1ilYSLRD/NEc
	Ich/ZFF0TG81GtJYUw75dlvAUAF1+dxJpg/y8/3RURCx74/F99FQ3YGncBucFnQVt+ccZl
	T93ltczpo1g3b2oS8Y7JMq+MY5b7aGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4F2D62F92;
	Wed, 11 Nov 2026 22:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388ED1F00A05;
	Wed, 11 Nov 2026 22:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794435531;
	bh=YhV5+1cS0emO9WNIGDx6eBvv8/9J401vylAgxkfRXbk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N9gTsIvABmWA9FG/AxHE9BOkDd+PvfjEmh/9xkTi4E6r7N/z2bxN7nq40VisAO49F
	 IgUSAQYdoqkEMhROZYKhYAJjC/XC2ncIl2uqCE9C4Ngoz2nsfjoacmgz3/SUlnrv7j
	 f2Mcda/BOS1gCJ4w3EOHrh9rdEh2rSgXT1W+3JxY=
Date: Wed, 11 Nov 2026 14:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, David Rientjes
 <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, Kairui Song
 <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, =?ISO-8859-1?Q?J?=
 =?ISO-8859-1?Q?=E9r=F4me?= Glisse <jglisse@redhat.com>, Yu-cheng Yu
 <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dennis
 Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 04/13] mm/migrate_device: allocate THP deferred split
 heads
Message-Id: <20261111141848.11762f60e737c97c3a239fe1@linux-foundation.org>
In-Reply-To: <95682ddd-d200-4827-a009-77ee59d14f86@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
	<20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
	<avTB6h61nXfvCXUS@thinkstation>
	<95682ddd-d200-4827-a009-77ee59d14f86@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 45C301C0004
X-Stat-Signature: ei1q3zudm6zcbn4oxunkw34dxfykkrcd
X-Rspam-User: 
X-HE-Tag: 1794435533-412098
X-HE-Meta: U2FsdGVkX1/yAV5Uj36wYOBN2+VKi16B3uxWxr1+OypuJ9poaimgDMGoT7rgwO12ayx5XsT0buJBzomEfxr8wXPSKoHnobJqOZ3dIOtzHLbi3NXOK9KIKR2npvdnjvP3AaukRX8mHoZQvsdsLxGvKjJOk2LcGkSze8GFu1CmEVnIRbn6dZKzcGJnBybElXUwcPRQBEBo5BSkzhNlIjQWroUVtbEFqXyHmYmXapuPv25cd/988Y+Op2K2qoErFgrVQ2OLP9R2RL2UEQ3ehh7Ancb0MuECQQY+V7LkUUWFeD2V1tUils97y+KIzCHhJcVyyRGee+fwYxJjk8FfOth9hWrHxswNDnjmusoi6OZEaysx0QYNob8+f2Fy6eL6Dlrg4vChsT5bQEr40H5QFfB/buljHo+SDZ47jo0pCw/zesQQmdwIU07MHvMQVNBOCCbsphYPb67AEEwtjUG/8TvsEY6Xkxc8rBd7Utdte43XQDZ1IKsrAFapBXFT98faHJneUWN60w0AOS3i8ET6tlVRynUeWaWXOJ/DrQ+TJr5XKiIwzgCA2Nt8RAiRbWEzS265fJjWaepToY4t8A8SVvEZIbRhVTfCi8hKslya3P+qzeaYB2QN14vkM5ND21g/8C3TsAMxGQTIhg9aWhGm3SATmhj1aUWNReyaIDAueVSMPbrQHdCnEcK0eOZlvOSll1aTMy9UoQ2Trx8cqfoma/VchGg8BwuACEUi0EeWWQ4Yv7IIlVcdEIqkHFFQsy8AaQPZ2te9PfEmFzhS7SulpagBotuMS3mYynGhkAYUtXf5cP1eVfjw46KpseyYRJz7SU+FL6cu8BrTJfUVd2yMbR6ZVnto/t3dR3iRIE6FMzxUl1n9QYYDQ/4aBH1j+MeEjfDbMKmDKdQiw2xS9iQV4zcYzOQckdxGMVRjdEKKWJ1hQkSEgVgJrdpZ+c9pDNmEjSGAcMgx55ejLIrdVeaNvAx
 R2+GQ28c
 FoMFQ1YacFbyCWiFgH6cNBxZjMeubOh14wB4x4hzKE8Wa4Lvmwst+4pXSy286LUfUfV7U6QvOqefKli19ewrP8CQT4Palkf9qnCEhzrKbgz8jCZwS/MY8T7XR4hTTWThTe4DeemI8YNLh/WGHvV+PIPDQkz8rE22VDJ6wTN/jJclTJTt80Imwspr+NsyLtk18HuVkOEtdj4ZHcf0qnF38Q1WvBtLBFMtqFMXHFTt82fmqmaqkh3OZ3bN+I3p9MCH0oPyq/oAt0rgjnv51La30X7A0Xx5PFrHxvArbciXBHFb176gltzHJJU0ZgysUEi6zKeU83bNZFb6xKVILjnvVbUFDBkDTknXyyr9JYMRxGIYDwR22ja/MwAmZnO0A5fZnOIrx6eVOSucfAPs72QFqE/y9zU9PfzFcN845FNbF38EKpDXAphVCnqbu58ErLAGZ0Mw3flI485t5sdXgPuonhhURxmTjDFJFixy+e8eHa4Xmep/VDukbazoL6Q/6z89Pv7zaeGftf07qQqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 20:40:17 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 11/11/26 20:30, Kiryl Shutsemau wrote:
> > On Wed, Nov 11, 2026 at 06:13:18PM +0000, Lorenzo Stoakes (ARM) wrote:
> >> From: Josef Bacik <josef@toxicpanda.com>
> >>
> >> A THP that device migration maps into an empty PMD can end up on the wrong
> >> deferred split list when it is later queued for a deferred split.
> >>
> >> This occurs if the memcg has no heads yet (resulting in a warning if
> >> CONFIG_DEBUG_VM is set), where deferred_split_folio() will then queue the
> >> folio on the parent's list.
> >>
> >> Once a later THP fault in the same memcg allocates the heads,
> >> __folio_unqueue_deferred_split() and the split path resolve folio_memcg()
> >> to the memcg's own, now existing, list and take its lock.  They then
> >> list_del_init() a folio that is linked on the parent's list, racing with
> >> anything holding the parent's lock, and both lists' nr_items counts go
> >> wrong.
> >>
> >> Resolve the issue by calling folio_memcg_alloc_deferred() after the charge
> >> in migrate_vma_insert_huge_pmd_page() and falling back like a failed charge
> >> if that fails, as __do_huge_pmd_anonymous_page() does.
> >>
> >> This was originally discovered by code inspection.
> >>
> >> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >> [ ljs: tweak commit message, remove unnecessary comment ]
> >> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > 
> > mm-new already has this: "mm/migrate_device: allocate deferred split
> > sublists for new huge folios", same Fixes: tag.
> > 
> > Hm?
> 
> I assume that's one from Andrew that he created after a security report (where I
> was CCed and the reporter didn't follow up), but he never sent it out officially.

oops, that's supposed to be commented out.

> So let's review this one here. It's supposed to go through my tree either way :)

Patches are identical.  So I can say

Tested-by: Andrew Morton <akpm@linux-foundation.org>


Based on Ada's supplied fix and reproducer. The report uses CONFIG_TEST_HMM
and privileged guest setup; ordinary-user reachability through a production
driver has not been established.

Built matching pre-patch and patched 7.4.0-rc1 kernels and ran the same
one-folio HMM migration test in each. The x86-64 KVM guest had 8 GiB RAM,
one virtual NUMA node and four single-threaded vCPUs in one virtual socket.
CONFIG_TEST_HMM, CONFIG_MEMCG, CONFIG_SHRINKER_DEBUG and CONFIG_DEBUG_LIST
were enabled; KASAN was disabled.

Both kernels migrated 512 pages to device memory and one huge folio back.
After a partial unmap, normal THP allocation and freeing the migrated
folio, the pre-patch kernel still reported one deferred-split entry on
the root list. The patched kernel reported no entry. Both one-folio
tests completed without a panic or warning.

In two further bounded pre-patch guest runs, eight migrated folios were
queued on the root deferred-split list. Both runs produced DEBUG_LIST
"list_del corruption" warnings during folio release, with
__folio_unqueue_deferred_split() in the trace. In the second run the
warning occurred during a timed scan/removal trial. Neither run crashed
or hung; no delay or fault injection was needed.

The patched guest did not create misplaced root-list entries, so the
concurrent scan test stopped at its setup check rather than running
identical timed trials. These tests do not establish unprivileged
production-driver reachability or privilege escalation.


