Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498CE606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnMask3p
Received: by kanga.kvack.org (Postfix)
	id 4B8076B05C6; Thu, 12 Nov 2026 07:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F326B05C7; Thu, 12 Nov 2026 07:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330B26B05C8; Thu, 12 Nov 2026 07:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 063CC6B05C6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:19:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7713112057F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:19:01 +0000 (UTC)
X-FDA: 85426371282.15.44CD8ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB803A000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:18:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnMask3p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25rHB//DTA19AkBG+LmGkOqVCqlrxZXLVv/KBpqslEE=;
	b=zrdQNxxeuqxdhhmgGRLvNUwSeRkXP1zqGg8NYKZxMW5AtMEl5Q5jmR7AMhhl3DJEpqSjrV
	A6Gv2r10DdWjmoq1RbRKYqKj4rJvQI223U9BBVmrvo6+C1HthdM+5NhIORtsilzBJfAcM3
	jtGAhtSAlbnrAeu8hpUhqbN5/kspLrY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnMask3p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485939;
	b=53ROBBCDpwGZIMhtjggqFAEl9GKc2VMIseJm6GDoq0QJxFUenvBpyh1zH3dfSBmi1FMmC8
	vpecUaJL7i0kO85FEJEPT0AmhIAcNb9EZzxiP/aFrJEVgF8Za2k0pwmiFwnAaLlGaPmJ0S
	YApQctmMX0VSmIWbwCvOMtTqml3mJFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDDBF406DD;
	Thu, 12 Nov 2026 12:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE031F00A05;
	Thu, 12 Nov 2026 12:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485938;
	bh=25rHB//DTA19AkBG+LmGkOqVCqlrxZXLVv/KBpqslEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bnMask3pUReTtazaSjEd7UX4twP0xj2/zq4bNCoLyQMvGzj6B7L8OdMDz8qfunJ3T
	 IRLcCUL5wUMDwEPlAhgUsaMf/nvYyfH3n+STUeu6alIyswNcgmJhZhomp/K+AvYehQ
	 ejIoK5dGvB5ofSymMCFArJMx540CVaU5pNHl7JpgnlZ/fQsTld34jALF6uQUQDdaao
	 7uNZCm1wGFPo+zCXGtsAsnlF8zHEJ21egX1PinGzPUjQSW/DPdndwamEoAolglQJQH
	 m8UamT18OR3euOYZmbaex1O4mocS+YMwYGUO585Aa3nNTzHF9EkoxQHu0tK9kFSDy4
	 qZNe8OSGdrOMg==
Date: Thu, 12 Nov 2026 12:18:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
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
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWunRPQJQctsvYl@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
 <avWtxdIHSJJ_uNwG@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWtxdIHSJJ_uNwG@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB803A000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9a67aiezp6q8gmsiy5xndhm17ra1usid
X-HE-Tag: 1794485939-712698
X-HE-Meta: U2FsdGVkX1/U9oXLdrFBMTCFykuq6jbx8VC+RptDCIItTAH/Qx/3/TJTPJqwA3X0F0UetW9DXCp0APpS2XS9ytJnBHyQmNIqdIPusxxWRIT3/guJq7rengM96FdHLtind0v8MFlTD2FipzCOvZ5FOnGBxG6Ebba6DOAux8CAHNLRvvWgr1IDhLIWtr9RzLy//LIkLHYyHe6G4j8kt+zLcJTl3htXFZpUL8EC0ZSyWAJzK7lHhYS3vQ1wCBpnCUx4FLQhy/ibEvsdXxa9NDoP6myzh0FcH/72VE9Be9Pa9gdvLy901bgI0q24WH5Vk9l8jl95R5dH6pCDJTlB1F4kH5hGBpC3MfLSkjm97ldy44l6Z42NNsa1z3IyYRy6uBsxOJBSTXXk4NGTpxaMyG1LpUeP+LCaE9bOiWshrFv2FqVRt4Q8oHNRtgE3Tlr3bYwMCisRWhfnnsjnkX05Ft1PL2AmBvQPV0eKl0CAmNdKxhgdRpLywfXwYDM7ch29UhAerDg5BCm6LNBnxmKZfPG4Fo3ny8HPTIymgeuqdq3ZWB+iK/pOOGHpVNrticWUbIIsrkrS0AuhEAfxEeh+KPEnU65/3Ce/CzvvFwMbVA8or3Idq+2Hc5JBPUL4tVHaSKtH2RmJFP0PhIbrV74pajCzWfL4ff/m7Vw7TSb9PWIiclJKFebZU/VDvY83rIk+imS3bFpnGxy+giammmdUer9nGE5daBU0QQE8Y74yuQ/D0FjajK36TNzUTOpccS1OTU88UlI0i6MrhC4RbwgsYk4wUoUghnRsXNis9F8It6AoaxDAuHEq5rVcAX7Yn6Tq8oVYFLvmwaVUfCF2Exw8AI45TUsCBSNwuZTXLOXglUjQwtSrtdGLqpkgcMv5cs/wOcCVYEloMcWJKPaxNUurU5gNEJYMksgdhTTB9A2GSpgr6D8jRrROf0aDBz65cQIzzRGyl4OBpDhW42r+raLLs8q
 sB/bZ2KH
 j1mdLDZbynK7IM7EkiTdUwYngPddWaNDrISvzA+cZ667/6ati1JvN6GYVCckbeKehkQQlG4HvldADTZgXA8CN2oKFju0k5fibJcF4RnaYmzdu6W4zzDvaMxaY5kANox30QsEyT8QyVzlmaox+FQaQqpYTszwoq6hIp1rP3gtkDwCPzKrxymke0Unnu+s3SRz0XEGYi+J5WEtTX4XoI1ZA7veq7ZEm6MUaYZgi8200o51jfB5uDkTl6kt11oaH0cIXloeieKnMFN2F8y91hhj9T7n3tg5qhAJGJ+LXVNy6+9aD1/Oz5RpvL+0R1aH1Jl/8Bq3fe6AbT+AC4RQ/OZSEZXlkdOs1qhlCtOiikyWhEKtp1OfOpFMGTEoyDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:17:21PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 11:21:38AM +0000, Pedro Falcato wrote:
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> Thanks!
>
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 7618e72766a5..4cb18b217048 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
> [ ... ]
> > > +	if (mm_is_oom_victim(mm))
> > > +		tlb_flush_mmu(&tlb);
> >
> > I see there's a different tlb_flush_mmu() call below (in the actual function).
> > Is tlb_flush_mmu() idempotent?
>
> No, tlb_flush_mmu() is cromulent.

(kidding, yes it's idempotent :P)

--
Cheers, Lorenzo

