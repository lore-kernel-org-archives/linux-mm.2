Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4351103E190
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366FE6B0260; Wed, 18 Mar 2026 10:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337836B0266; Wed, 18 Mar 2026 10:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225D56B0269; Wed, 18 Mar 2026 10:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 111DC6B0260
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:42:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDF788C0AE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:42:40 +0000 (UTC)
X-FDA: 84559450080.07.54B2607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 178EB1C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:42:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Brfo6kwq;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYBZKpgI6tybeKvEVdsHvPcDW9/RMvTX7D+4dmU7p0I=;
	b=rjxHadRvJ00gF3E/ur1bPd20XASq4sU1TpUfbA9G0HClzU0josrH/ML2f/g8ZyjNPv+a7h
	IqpoJaECB9sdxOlcYiVecHqqKvMr85gRKnC2iTtKYvb1IbA4vcljeaKcGwQtR1vj24tsjS
	d72buyHJHMuJgSgK21ZnP+tTFXVNBWA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Brfo6kwq;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844959; a=rsa-sha256;
	cv=none;
	b=h6+u9nQnBwzibsFx1oeGZZwY0YMV0iWT7upfDDxoD2FNPXlSUTDq61NbU0Jqkp9x8HBXhs
	Whg5cbvgmp34B5Yf2M5jjL3CGn67tntGL6rk+WGjnsWnERPaD4aNETY/Jd+z65u8Brcyl2
	sFdBhBUCJXOjydKvqmukeOSsmRsFE8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 616DA600C4;
	Wed, 18 Mar 2026 14:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C9AC19421;
	Wed, 18 Mar 2026 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773844958;
	bh=o3Vqfegoze9voxgxHT8hNS1xVKI7tWzSZbrQEQde8dg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Brfo6kwquW7beM2eQzf+4i3bKNLjG6pitESp5wXj5j3/u4EMe+7TKVtW2kDQi189b
	 ksXjz2HFO5CzN39JGKjLjl5Cz6xte8b16X4vUnfN0qyNtCbUwrFXww9J7LQMWeH4tV
	 XxLcTaXa36dEp3pR9f5ACT1A0MF31tlrAm2w9z71HsxNJA+lhDEy4wTslHSjno+Jr+
	 oUiTxttBYh7Xfz9WqNET76CHoWG5D2z7or5j/VSvQHP6oD/BMerKadPNSlJmAi/h8i
	 4hOfDPVsWi8QZQJI/KS7nt3ccmQBTwTGOCza7YTyeCo9Fsju2QNwapLG0bKt1L3tAC
	 KTJlXh0jWxX4A==
Message-ID: <b706a64f-c142-419d-a151-931847cf8444@kernel.org>
Date: Wed, 18 Mar 2026 15:42:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/23] mm/vma: add further vma_flags_t unions
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773665966.git.ljs@kernel.org>
 <a37030f2eefc90147e84f9273e325cc289cb9e1d.1773665966.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <a37030f2eefc90147e84f9273e325cc289cb9e1d.1773665966.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 178EB1C000A
X-Stat-Signature: umffqsf4wj7j5kibn3p78p15xcgp91xi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773844958-687036
X-HE-Meta: U2FsdGVkX1+XcT+NWoMwBsIndMV3/t8stTcBwiDWlo/8c9UQ5BtK9lESPelw/vx57E8G/Cr2WAaNuzpoHsL3hX8pPOPACcRNXpohIu9WKfhjIe+gMCZ5R/mvW2c/8gY1za28zIohjZRxXtO19dGlwh5AtnMaqV5pYoUoYeMnPkUTEHcCOvc1LmCwfsYk2OVfj/xVm8IOu68E5lQiToBk29TnoFcaLlwk7ey6CH1g8ekXl2HXKmu0yD+bk7zKWjyEE9ZONDxjYClbvG5jtaj+IeiPXQInnAMPoROWVCXuKedhNf82YqBVFtfrqQ6zyV0c+vhWi8S8ws/OuN1mFgdyujv/NJm6JsWZZOEkQzu1E7lR6PQQBNr0H/OPRYCP7D2Janxznjhnr4SGPMunury76SIMlcC6rW3NwuJ5azM6rn9iis7qS2lX93+HllQQR1elwcqGfDZwurHl+0LsvtprsZF/y79ANkWw1sHP24XVEQXQSLWbpMavQjgGziHCCyQA2pnqcRVBUwELpxOwcWsSBwGmuWNu70fHFTVaWPu+SctiGbWF+pqDrOfroqJWaRkXiAC61l/oXcw/HDNCGKB7+2ZaLVlbnIChmUG6r+fnsGMdsz+R8YSNg68eJiTRWTK6ibFsp+AP8D8VjDCL3uXVvr+TwOFr8XfqrdXlfHO6rbq6XGhfl1jEWzWZrBTPRusRbv01BPky/L/Fa0lob0qyxCiLAGOV15UEp6jBHfvBo79KPG1DlI8cKDPktcz9OdWCHeUrEyEt5FA7zCg2A/TSAa8GNXSn8ucZ2t6jnKoCNfqLEL66Zfj3q1CH7KWoz2MPEmfjvRQp41/scQKon4WiNr/gIilfpk1D2sF9B7rGFtUNd+iZDm+9D7/4zxUPgp5QgJVBgie/PktYu4CL5GSfm1y0Jkvk//Cwol1oT5o8xQKz5Np7VQ/OPM1dg1lYhsklmE9jqUyzsvRxfiCWkvj
 /vXvgySz
 6FXJK3ywhWVwLjMjBGNwCC4ZwLGh6U1LaZKSA1GlEYXntsO9jwaoF9ZTiPSlg/XGIWcG1tSJNgj1vutYp/gR9rVy+Z/0MWNCZP/DEXF03WKxCzgXXnjMdCsE5qWiCOTuE7zHa+0/HrVHWlzFeWQADuZQZt1u3qI13UUZmE1vwQ4a+ojm65rf/DlXHmIjGu3SIqFfN/Jyo6Hb+EN9/p6rXTHcM4iiFJsuawVRku6oORf10X3KI1ks/R/sF31xv+V5GKzNAupDnb7S9coX6/7jKwh8qGQE0P63YIuOK3OeOaHDMAWp1OWDCEFtTfSnpV7oWpzZLkjz+FdZSfKkwWl9Rg92j/HAjlVXlEii2mC+GssLbfrQ1kKPXVO0E8ebeaAdgeHLuXZm4tIOE4tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 14:07, Lorenzo Stoakes (Oracle) wrote:
> In order to utilise the new vma_flags_t type, we currently place it in
> union with legacy vm_flags fields of type vm_flags_t to make the transition
> smoother.
> 
> Add vma_flags_t union entries for mm->def_flags and vmg->vm_flags -
> mm->def_vma_flags and vmg->vma_flags respectively.
> 
> Once the conversion is complete, these will be replaced with vma_flags_t
> entries alone.
> 
> Also update the VMA tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


