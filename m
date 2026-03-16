Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23109F53D6F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F3D6B0303; Mon, 16 Mar 2026 12:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856FE6B0306; Mon, 16 Mar 2026 12:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D246B0307; Mon, 16 Mar 2026 12:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64ABB6B0303
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:17:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B8CA160252
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:17:10 +0000 (UTC)
X-FDA: 84552430620.22.01FC941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F748100018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:17:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L29wqMAs;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiSRMwyGXPxDjFg+D5WWlFGeHW2UEWfaogDpHaDui1s=;
	b=YQvyqY6zId/HMzUAr1lYajc3xz92E8SZ56Ndy5v9ndblOu7n+swW5m+KHYsRSYamHUxr87
	gjkz62zQ8Tezkkzo+TN/EYxy97ilzi+wTaO48wTiCnQI2DhHE1QjKlf1qPUEz0PwvHpeTr
	B1xmU1X2BcYMNqq+PzASwxnHw9mrl1E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L29wqMAs;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677828; a=rsa-sha256;
	cv=none;
	b=ZINm9jdubN9620eU/m0NUO4K2uBNq3pzf1/31jcKUf1cBw4/trIhoCsot5T2H7NHO2q/Cl
	AFihYucxAIX+q5Q0+aXnXLoIrj2794zBKHPx7LunJju6bT39+vYVk+ubCyDmPMX6PAFvbO
	aS+CJqrAZzIVEqn7YTL/u8nxXCqhjmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 544DE439D2;
	Mon, 16 Mar 2026 16:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FBAC19421;
	Mon, 16 Mar 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773677827;
	bh=piGtJoQS85x055Jj6a8BM+ONk4RlzPnFJWtiG0/1/40=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L29wqMAsUJ+kd0X9h7g849lKpqLxCfCPG0hoLd+WtnJ50ZCOkgcNxIONjg5Cqui/L
	 XCAUjTPqdwvcgvUKcOIyocy046LFIx0+L2G9uLv5ICqCsBhbaAsDvCluEeycwL6k+7
	 sLjEpI9to3sgq/yF8A1DWAUyiyt23UTdiAafOEOE=
Date: Mon, 16 Mar 2026 09:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vineet
 Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh
 Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Michal
 Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 selinux@vger.kernel.org
Subject: Re: [PATCH v2 00/23] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260316091704.24d7f8230ad57e8b7d18e9f8@linux-foundation.org>
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F748100018
X-Rspamd-Server: rspam08
X-Stat-Signature: 6to8pcwf73qfx8sbkqys9dinnhckdghi
X-HE-Tag: 1773677828-783669
X-HE-Meta: U2FsdGVkX1/bEiRmQOhEDZmGm8JIcU0GULDA5ttmqb4RLiS6/4oPeJaFcnXy9bmtqgFW3KVFch6LD3SOYHALJMK4Py9nkU3cUPhFppYJvAS7ntXLDK2IWkdj2tPl05oDV4OHbCj0OgE4cp/g9mouuIueEGtiYesevmxbfOgGEYMMnn6drOP9dKHSNU+/0L+pBs4ov/e48muRJadIFJ1iCHG/zLJbiu41g+GQaU1Dk9tpsseyFaBwpgS37F6ChBm7ZmUvFV/mLJBpcXKVKlY9aQ0qqWoV34RG+t9kAAxrVow+fP3K9/JK8ELPlyKJnnvX1HjT5HB+o1COfwC/vkkyCxCw7neCsA8nOL2ODkLXUqSl5Eo1K5FJowhWNY61j79kR4HRIbY4YpfVsn2Fr9UvT0SIFti69OCvI2MeLcYx/N5AGnaNvGYV76n3hcVJ+4MCplknh5YTinD9fddvdVc8Dq+JNI1eVLvTAFM4l9rjwWsFSj59l1dYYGlLEeLlrElX1yt7tAvs2pdP4P0cqVrbhZC2IQiq0+2NlJBQzjDpf3jC6KM6CQ66hNwmKgVCioV4OxySqOqJKFMhYuYWMN5Vz9RnckIDyAHQXx9uAmtV5AV2rQeceGbpahBsn+8FI9TUDLZGJYX5fj90zb7nzeU36zi+4FA2pLbLbqRdTiRD/pFdEaMiLEh176K4MJEGpYcZ59sbsnMwMkEa2a+n1IazURFRs1LXmUjMcI6HWY2fIOYyiBSIGG5PGfd7Oka+v3qP0lAKasiqZt+5PHa4zM0MsBassp9JsxK6WcHp2DjRqYp5ze5IIc7UvUAV3qo7gn55XIiZlR7bUi+W3aAkZPa2T3xz62hCLpa/yzckodFtC4mCTdBpYRN2KMF7QE/JXGcSxqlYLOBcmKS6QO0yI1YjZpCF2aUK0XvhMUkHGDQCjC90GcYouQYIq4cQeAXIS7MuRVUe7Igpm+kFeOvZZPQ
 a/DMXpAF
 +LGJQ2CJQ3OCAShrddglstSsYkIsBwfXxeejJbZ5SSQ6yP3h/BarGJLncR6Cn2Y3UrieS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 13:07:49 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series converts a lot of the existing use of the legacy vm_flags_t
> data type to the new vma_flags_t type which replaces it.

This series assumes the non-presence of your series "mm: expand
mmap_prepare functionality and usage".  Seems that series is due for a
respin so I'll drop v1.

