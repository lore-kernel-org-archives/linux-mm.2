Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A611109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C906B0550; Thu, 19 Mar 2026 12:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104D06B0552; Thu, 19 Mar 2026 12:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019F66B0553; Thu, 19 Mar 2026 12:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8FC46B0550
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:34:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB20A1606B9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:34:19 +0000 (UTC)
X-FDA: 84563360238.29.E1CC312
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 05E181A0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:34:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AL2p7D4n;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773938058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=We2az9rV2uZhEm2AbxZxzNYfpPMKfj/UCTlthMox8c8=;
	b=iR8ygpnkcfjl5yz286KwCoNnXUDE7lunHrCbKA1tUeHmAVJjixlX5xviTPQxtbUeeaSOVm
	sRfmKt5UlATFVkS/5zlVIVWqOyE+KrGcayGmi1TNMm+J8iDCchNltaU/V1gBXh5QgGm/Z3
	z/Rdy1K0ZNYnrQ9XYeTYoYpHH2z1WiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773938058; a=rsa-sha256;
	cv=none;
	b=i3Mh/xA20xsGpSGPirqid3tMRpBC2GaG5VjXt8XaCvok6OQEbS9f1uUQn0/KWS6oMNEj85
	5cwyKO9Q17GJmRDaXU7eRi3EDn3/0pMHjPq2E5RiHQKK0bkqjnVJoj1gFAg0B+unytBbuQ
	I/v+pdz6vK93/EtvbHHGckz4X/lcuCc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AL2p7D4n;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5783360133;
	Thu, 19 Mar 2026 16:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6525C19424;
	Thu, 19 Mar 2026 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773938057;
	bh=We2az9rV2uZhEm2AbxZxzNYfpPMKfj/UCTlthMox8c8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AL2p7D4nNNuwVwc7Lph39O0JFakdkYyaKrzGaPHTF2GlW3nDaBEjsMovt8IMS1cvj
	 nF/Y3zcnq4HLceLlcb6ZNa8uwOSPS9SWkhVjLMbig3i7KtVn/sUAbfmVPQesBc+smm
	 1em/bPnI5cwFnbtL9+1T0wOIIFyaOYswLb8TV3Jrtgd9OpVCyzRy0/2cXUKGL7tmOg
	 p/vGe+nw48VyFu5vUn7QxEbTeLZzSpoqZVdkf5aZk90hZ1WePMNrOHlWOcl6wQkke1
	 ZJTW5adr2V3cuwzpxHwFD5YXGP9Xk9BnMlUdpEnaAU+qap2KVjtghs04ibjGQEjgmW
	 /TmfbXYeRDlPg==
Date: Thu, 19 Mar 2026 16:34:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Message-ID: <8ebdbdba-d0b5-4887-98e5-bc45f4565d51@lucifer.local>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
 <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05E181A0005
X-Stat-Signature: e4hemfnuu5ffe7xu949jirpixohmmb1j
X-HE-Tag: 1773938057-917717
X-HE-Meta: U2FsdGVkX19CDewoqz/H3g9FQgh9c8atRSYd9BnzsRjXPGFA5N2cjX/P6wxw2uz6qTv8EeO+RlNORULnECTxU+3eqkCeOhTulUEk0+Y7jAqO9FC611XJBE/vm8M5xOe2SBlNoSUdBoLfBfVoQ2DZyr1NuyrwIDkXU6pNNZ3bfJ1PQz+ez600dncd3eXJpOWOHnep5YKcCSDGvUU7oZAb41DfuLcvAN/UBXZ9x9WL2i5W4g3Vc37rwKy4DTaE/G4rz2sldP99ikIsyAqIRDWmfw5LL03kisQwYBzSNv1BzKlPgqjwA4HqSF5siFa82r9/gO/US7p8YlmlAniW/vEE/4RBOy9ROmrObD0Ne0U/DG7LIxbA7cRGnbR2RS0va7C/QwCvWT/ukS0eXMb0nZLkDeJwZ1ejzrcpwkNu7HMshJ4L6VezC2KHqhzsnjUe0hdecadonZK1y3+Oi42Cncyg4uldIVSbfBfQRAbWnMw3+Jf4oiB7eq90o4N81Npl8bEotVKYeQ+1DZPv7/bzkRWuY2keOp21mEqOZ7IOS/vsUrb3R5dQKybFtyNlo2ZrEh8tsWi8zzop385Nt3ZkUcYFE5zK4YF4BuO37Qj4nASP2dTS5XmCXA2BnTyftTlsSQYN/sU0m5B+F4gfQyLIWQLb8A6VP9140wkjF/7J8JRKBXMqytUbEBRHbE80padr3SwUb11gbn32uUSw5v5VZqnELh7pLx+ED6ZsqsRuQQ9BOav7r8jRhPMJywjK5XHL4lowBNgN+YcOeiU7oX/z2sGPXh4pGsj3D73qKCetS3DuPRQ3dGAZ8TAh8AFUdwTtkdByeicbxlG3OU0mH9O/jf9r2dN1t8rf0wezp0xyYTWFJCEuugvco7PHNMSi84U0r3Mo0d856C/BRVF+qwnIjqTP/8lPXW/IaApINAP7y6nuUEOcDcncToepaVaKxaZXDAJCZiL0kHWYfvztBzpjpvb
 XbaR+NjA
 N+IkCwa1L0n6GPeAIc+7gg9URTci62gzm3kcr+YwTmI6DV6lKVUdEH+tJK6yx+XPcNC66V5hKvKf4qe8s3V7tek4P4g6e/Op7KevuJkay8ITw9N4YhRdV5iaLcHLtdnLsrcR39SHWRWZyuStmt3iO5YivLm0VrcCDa8F9SsngmjrzXN8kfqqN29zuCxKsu2ZTx+WGjCFexcs2+FxjqwqB6AB712MiwlyPSS0/5zVK+X+CaS0ObMnmxwJSXJJyz9+i6IDmiRDOcB2C3CY99ZzEdfda82ZhnWIhd++enWQMTuEVSQhDJolo0wT16Z9qUCwFyJJhpRrnytB+0L4OLl0GkqCFp5Wnte/SJVh/81VpSSKuwbHmVKdDQdSlr8XBK77GHHwUk7JQh+/aNSH5c6XzxDkdha/csZa+rZbD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:24:27AM -0400, Gregory Price wrote:
> On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
> > All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> > select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> > CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
> >
> > For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> > and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> > CONFIG_CMA and CONFIG_COMPACTION already do).
> >
> > We'll clean up CONFIG_MIGRATION next.
> >
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> HOTREMOVE has long been a thorn in my side, I appreciate you cleaning
> this up.

That is quite the HOTTAKE young Gregory!

(It seems my pun crimes are continuing)

>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> ~Gregory

Cheers, Lorenzo

