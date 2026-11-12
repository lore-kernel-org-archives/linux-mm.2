Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D28606A8BB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X2DcnQfi
Received: by kanga.kvack.org (Postfix)
	id A25D16B05D5; Thu, 12 Nov 2026 14:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6576B05D6; Thu, 12 Nov 2026 14:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5186B05D7; Thu, 12 Nov 2026 14:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6832C6B05D5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:12:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE088C0AE3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:12:46 +0000 (UTC)
X-FDA: 85427413932.10.907B568
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 295C020002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:12:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2DcnQfi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7j0/jh5K7WkVjbCX+ro6AcPTgGQkDu7OOgaa2OHvFf0=;
	b=5cWOp/RvmA3XjU7Yy6Cwwo2eJo3VdFT/1zMlhahviOWc9GGEd110JoMNOdFrhI+yQ42Ls4
	yhahTOidysncVCGKhYuCYnNneCjeIyWZ5k3tSD77/UcEaKUTCSKzNUlYNTx0qImPy3tKt9
	J7GMWjUhdfiF1mtaTwQ/As7qYYNoaQM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2DcnQfi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510765;
	b=H+4faNlkzLsIArJTc6wP9NMTghyE2VEogc73CS5EBPIEW6mvFvqUz6PqkJBw5H3B4zek1U
	d1lIp5uSrB13FnOsyE7u9jebVL5GyGW2VWj2NxGPdYaGD0egIOc6aqWU7fms/DDqVCsn5f
	yHjtTR8G+5aN9NLAVvPHdNBTM4BRkpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D63E40729;
	Thu, 12 Nov 2026 19:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DA01F000C7;
	Thu, 12 Nov 2026 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510764;
	bh=7j0/jh5K7WkVjbCX+ro6AcPTgGQkDu7OOgaa2OHvFf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X2DcnQfispasGV6jq7eKqrWXQYe9QdoB0WVIKnVBn+qVUXoDQaMa2JP35NqG0rUDZ
	 Yrmii1CSQ2kC+kVMFrVPqXYqjbzLC+HPEtZK2S2L8c6rNB2GFxYyNJPZ5sRzmWjMFu
	 +dIYoXUFT/gQ+opKnKXgubaf3HqIYUBd2dghgWCQthT19T/pjLsHIlhSv2PdGSxZ72
	 Y6caRTdN4ASxjDMe8nlGd346MADQ4oacttKHM+fIxsG0Y7JqOVkTW9E8QoISZYwDzA
	 cnXP1rnM8wHxMGKeIsrR63rxWcT49L3AMLJO5Cgb7ay9St5N9w6vYoCxGoRx1+yipR
	 fXEha8CbDyJjw==
Date: Thu, 12 Nov 2026 19:12:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 07/13] mm/migrate_device: look up fault folio after a
 split
Message-ID: <avYPiLcx5okHyOZG@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-7-3d2454362e8d@kernel.org>
 <179450492332.482102.8905567682196853763.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179450492332.482102.8905567682196853763.b4-reply@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 295C020002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ze35j6c97epwnm5qrc9bgf3bf3wwfxy4
X-HE-Tag: 1794510765-215187
X-HE-Meta: U2FsdGVkX18c7oCklLVbMNfS/iK0gg3V2sWd0jNT0OcU4w+Zk7UOEbzLmGs+A8vXvRgIr1fwum4QWRJXojZth5ajQhKHOZeHjPzEcAVGMewFndxhAO5qGP9BlLs5XjM2+5vtCfjSNC1lp1dnECA8tV/URi5aeP2EBFWvfWHCo5Wiv2wH3Xf/Pspc1+w9Ae5hL5HkubsChQVDVHr5oP8aFJEJgGkZR1C+xpmJlk6KwGf96q0zEGRDgbz5gIwvqRDojc8IByhVyzJxV8J3QEDDR7j/ZnRGrx0xELrp7FQ7AQftJDtFggLoG62Xpd07ew1QUMbCHq3/YiilP4qTLABpFhcvCpDhib6aEb4GIdfUlaAqVw65Dqaokjl3HTeAM7skf7zfLVXdVCzxOWG15r6854YhJdIOqFW4AM2cuEQjbzEjJHtyszKaoQ+5/PpO0HtHyMH0KWI3D5vYxMSxKw51row/2ypq5nin1wu4E2J/SRSJdbXe5zQczlo9WYyObJpxPxSoQUF3R2JntNQyeWPdErWubBz30Ts1m18NTNnxdoVa4EcfMuhBOSdx+7B0NpXf+Kd0oItt19ZuleBmCzkg287h3C1rOwsvjPLMPI26PwC6T+dP0IQCJ+7jmbQvJrqNb4Q2dNDlLkHGVC1gBifId8Abbx139RZGr3eLEc+Y5d2l0wUL7VbwHbFzjleohzU6QXQn9Qu/QxPEe/CiWcyAPYgKqm25MSnqmd9fY/Mes9/MZohjncNrr/Qhv7bQCG9LQuxhrz41H1cIXC2tFIdnGMPKRNXFsf625krFbjdL9+cuQ/AUfbgybQ3btwMhWG78e4wy7JewhZyphY3zlf2Na1jY+oncT8HXHPCKiwAqQ7/hQL3xLnhnuuRcS1mfCYPokqjLdfJEoCnOq6J/ThUyPOKGXDnu+ktH5s3JWfJIKOGcEgrovUgZaoz1TZG61UvLttaNyrMevkEEw2L0Jcr
 3EoMwnbE
 1G5QrU7sa57+4r2rg9j65MH/FQbIunjOcoiGZNFnLa42EOcirShEv3yfeOUzaz31XDHMk/XaKVDCHqGNSMsq6DK9z6+ax+3wYuVyqcRtrBKo7yUIiazhuDpTeVV8z07wpzajDNj/Ck9/xMsYfabs41YEcLSfoB7KDZydi/JnQzxc7m5wnRjpddvuzevxaIzY1YzG8GgoqXi9mFXFU5ZC6Igl/EONP0OKHbZ5MGziPJWKnqDnTwv3a6AX/kKqGh2WPsbSD0kjU4xU1zPupil/QOdcQXkHYe08j1yYYDEYshaxIp3nUd0kBf6eNKKXUR3RKR4TKCVmE88FZH8GCTQYFgp4dlsisAI3IA0OMaCneonEzaOjVBb5a1HhkVV/sZZ8DKnvAEwcPATiSRJmRpdlnVknnESeR7kgBmIildvMJSjN5+cC/kg7P+hpMX+Y7iVMFaXbvvuLbmE5vHmnrvOaPDCBxejYDBP7naw7S7NQXUNRe53qChsn82oyS0L2pe0p0sPCSZ0UoPZ1Z4TY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:35:23PM -0500, Gregory Price (Meta) wrote:
> On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
> > when it is entered, at which point the folio is locked.
> >
> > The fault folio is assumed not to change after this, however if
> > migrate_vma_split_folio() splits a PTE-mapped large folio which contains
> > the fault page, the fault page ends up in a different folio.
> >
> > Resolve the issue by looking up fault_folio again after each restart of the
> > walk.
> >
> > Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > [ ljs: pared down commit message ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Was able to reproduce this, and i think this also reveals (and fixes)
> another bug in Nouveau (memory leak).  I think the Nouveau driver still
> needs a patch, but this otherwise looks correct.

I think there was also another in the series that touched nouveau actually
also... worrysome :)

>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks! :)

--
Cheers, Lorenzo

