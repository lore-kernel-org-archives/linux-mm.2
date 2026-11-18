Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA44160A2607
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFMkljvJ
Received: by kanga.kvack.org (Postfix)
	id 166AA6B05B4; Wed, 18 Nov 2026 11:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EFF6B05B5; Wed, 18 Nov 2026 11:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C2C6B05B6; Wed, 18 Nov 2026 11:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6F9D6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:42:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D750C0749
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:42:03 +0000 (UTC)
X-FDA: 85448806926.12.E2BD81D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B125C160010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:42:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFMkljvJ;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795020121;
	b=JgQZo/VIhUnfMmuSze8u9FMMbyzFT3XS9CrX6RwhMiptjRs+NfJJ3yj7FAImXPLHkq7HVg
	D1f/A7plH26NyHjvOpER9fqe4hHBIXPiM5pmb9HkW1tEu0gc5swKbaZJthaUHTY7R8ocXU
	fkAC/UG70H/w1DIH87oKVfgHQDV19AM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFMkljvJ;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795020121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCJizk8bzcFH2AbvcH+Cs7sTkFlxW/3L98puwCtipF8=;
	b=mkwqqSoT7qJuWPxwk/jTAZYqdoKPR3SAdY0EPdOOtLUSzLkTroCqZp8kY9MFXd9EPW+5TV
	MXTEX7E21b/yx/M9HnFeg3jkKSvjcin3y+q8zs9Y++94Ynzzamux4Ve4LH+XjXk9C+qbAv
	5e0oC8nj9uYNCUk2gy38gW/GSDV8SLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB09462C07;
	Wed, 18 Nov 2026 16:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99B41F000C6;
	Wed, 18 Nov 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020120;
	bh=NCJizk8bzcFH2AbvcH+Cs7sTkFlxW/3L98puwCtipF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFMkljvJawec5NmrO3WRFAgrg16D5amWq/3qOZJySjcI3zkdLFyHx7qt/VJlC9Lrm
	 rSHrnHsr0If7GeXaKoUgThoNSnbxJgzA69q6FDjUD+2mVMdOKq+wmTQ6MZMmKotJgE
	 66PhJDfZH9qhEu7eBErOQRP50O2w7i/CA1T0JD4324mFPMAOPAtUcAKsyDk61PYvzw
	 hlPic5EBWUu1uBSW3I1B3ik2XxIF8i8Ieqc0aaOP2wgzYy7SItackWUGeHDYhxDu4U
	 S9KDdlpsuTmsA232DK65bIXrfRmH3XiJEVKdKDJsb1aoT9T2chlBroNfWVnZEHpoX1
	 bYGA1hpCeJcjA==
Date: Wed, 18 Nov 2026 16:41:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 06/13] mm/migrate_device: don't let go of the fault
 page
Message-ID: <av3VJFuimrc9g9EY@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
 <0dc23953-328a-46b5-9432-4b1a1a16fac0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc23953-328a-46b5-9432-4b1a1a16fac0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B125C160010
X-Stat-Signature: eht3ezetmn8bsteaywycuxzjhpgyqb56
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795020121-843410
X-HE-Meta: U2FsdGVkX1+s/NEWYIqj6v1cJa/zVHDxlbzrQYaj6We8jiEWGHCSYWX2gcUw/YfX13BMt0s1zD7HbdPHgQQK+nQweihRYmYQIXrXayL0vNqg7EJFnuKM/uDyaqv/YN+0VftUjYePGSLE0sPaTkDNtRtcYEvC0vHmJ6rfUGXFbvgWwiW3IpWSYGkdF6wOtkZcaVjCVo5wZ0rKyBczePXPUQxHSMGt2pUhdYCmW6EeGMprG3pls/E0bq5bZ5MQ5bmEuqsX1wmh0uYPLdHYK02u3xozrG1WRdyJBnQx4JluE1At/g21O0Q4KfAgdAwU+MZy6R+rRIbj+wP6KaccYfZMTTpHaVxTINvdIj8g2XWNg9zuRLBlOiV6EFnvb9LvnXdNUlCFHuMsUXCfrvDmCbXb/SIThSw9I4gHXYDCvNzQsQLgViy+wCFslXPWqoDBtaR3mxkE2k0SpH4TqvVcEMpS1eYusZJzjrNaH57hjEcTkKW20gCdEayXcvA39QM60bWVkuOnw1ZEcvWCfLSjcMdPkPiddqro9pCHjsW+SCT7xtHIh/n5b1SNEcLa4/Ur+QnUvLM/1G0fa1Jgoz01EUS4gtTqnpjmnARBKEiUmOAv29uOceLwBz9lBbXaSlmDbYDp/S9xsJp5GnLidTRYNTdU7wgQg5RgAfPgBndcnzm0Xrmgz6w4rwNNFsAli0lToqt4KNr+neT7TNT6VxjT3rp1DywMkG57v1Un5+Uw1/8HRKwqDWmGMKA+tLHa8bQwB21L7o0VPDAgGfaEifvjmhRZL180GOk1sIMS0QkBE492meR8mya/akorxOZiCH5S27fJxcnM06W3cPEb0ldzhnTh8HveOPBU3Q4yDhpnwamdqj2WOf5idAr6VQZh3yMDfmSzVTF/mPdRnc3m3+4V6dr/7hgU6oOMSNrG8CSuIxXK1mYJVall5AwS9udDlbsLtkCsGVGbOa8qZF0f2INvV6d
 oFazjR3h
 1mQxtsvrosjdt6eCRKUeGNtmJerBakyM4F6oFvzgige67PB6CYbcsu/9w/aQ9e5L0HPpbsh8lCzjxYge98s/C7JFAN/7Kg3/5ushEptGxtb61S7zHOkOYADnlD775QfyqkrHP6YvtFZdKWd1C9DDQAN3wEy1fAsf/tuUdF1v9t7EukxV7ziGPzVRKfcl/fvEEdkFkAXlhPgMFe6VTo7DPZM6ivKlunCuBsGu3c8ojjiYsuq83ueKiwh8vQ4Jk2jO+2KLUoYjbfon66to+p/VwGQp43FEGKq95wZ8PXBDQkUwGm4eXN1SZTVBeSnp0l7m/XhBq1frEifAwb5ObFkBQfI7cZMq2HPrhLKraTUqDh8pux0S3gylPxtcqOczk2NhLvIfR2aXqbYQfAGsxH8jOZBgyiYTuqalBykk2udy2Eh6RHh2PpDyyAaAX0Wj09vgPft7NyktA53xTrUz0axuNXiHsfWudd1BKobCgG+Dnu5CrqeWIAyMrFCShREVcbwKtbKiy/7FMuBt0Frc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 04:31:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > When migrate_vma_split_folio() has split the folio of the fault page,
> > the lock and the reference which the fault handler has taken are at the
> > former head page.
> >
> > It then moves them to the folio which now holds the fault page, by
> > taking a reference on and locking that folio, then unlocking and putting
> > the former head.
> >
> > split_folio() has unlocked the new folio and has dropped its own
> > reference on it, so until folio_get() nothing but the page table entry
> > holds it.
> >
> > Only the mmap lock is held for read, which does not prevent another thread
> > from zapping the entry with MADV_DONTNEED.
> >
> > If this happens the folio is freed which results in folio_get() taking a
> > reference on a free device page, which the driver can hand out again at any
> > time.
> >
> > In addition, folio_lock() can sleep here with the lock of the head page
> > held.
> >
> > Utilise split_huge_page() which will leave the lock and reference at the
> > fault page correctly.
> >
> > Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > [ ljs: tweaked commit message ]
> > Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> This code is so bad we should remove all of that from the tree, seriously.

Yes stuff like this really does remind me of many scenes from the all-time
classic movie Event Horizon... :)

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks! :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

