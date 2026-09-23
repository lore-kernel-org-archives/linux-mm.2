Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13871C98310
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016406B008C; Wed, 23 Sep 2026 15:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2736B0092; Wed, 23 Sep 2026 15:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE456B0093; Wed, 23 Sep 2026 15:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11F96B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:53:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1353A808E2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:53:38 +0000 (UTC)
X-FDA: 85246076916.25.5B004F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CE48140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:53:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eE9WCS2o;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790193216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4edf0YYCmWA79RL5zC8Xmz8p09vaatBemczrDrD/n0=;
	b=0QxBuYEIc9dANENEceVENmEsrPLlCh9jtKGjHkFSa3CHeqH+hGdVHlsW6hanqEMTlETJm7
	WrtWImHViaJlRdsyqs+fulAS4BQoHN8Nl0/GgMbH/DRwN7srGcdMSHkuYHseLQ5AaCVVuJ
	eQ4iy1e0pQvVfoOnF9nM4CeD1EuGRrc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eE9WCS2o;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790193216;
	b=lAb6OWjPtie+LY6DvL8V7/pdXkYX5IEeD2B9fwAn5T6WlYgJpX19jWhW7HQ7TUbFYrpiEB
	kZrcGay6A2WmyIQsC5T38eJsaK55sf4eUZJFFsmDYsTLdSEwFBQqy6ZayL/Db3fJ3qWvW5
	piKAkB0+rFpn/ocMyQjiWO8wJAoh/gY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A726741A56;
	Wed, 23 Sep 2026 19:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0D01F000FF;
	Wed, 23 Sep 2026 19:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790193214;
	bh=p4edf0YYCmWA79RL5zC8Xmz8p09vaatBemczrDrD/n0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eE9WCS2ousaSTQemTQ4AA1ZkY9n6f+r4xISLZALK3AMHEPFEmixpwYev88YxZLXeN
	 CHmB0H3Bw3SM8Ql9Z+14bUyIFrP0hgQ5aVwbxlPcF2pYaWAyJOWebDVlGCFrkFZrGM
	 ck3P7oheu0DSTRvd14VSbm/sP0AV2Mko/VrdoIFk=
Date: Wed, 23 Sep 2026 12:53:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren
 <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne
 <shorne@gmail.com>, Rich Felker <dalias@libc.org>, John Paul Adrian
 Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>,
 Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris
 Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge
 Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel
 Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Randy
 Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins
 <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
Message-Id: <20260923125331.882dfeb1f43d284b146a4633@linux-foundation.org>
In-Reply-To: <arN7q5nHz7iebA_e@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
	<20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
	<arN7q5nHz7iebA_e@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jo9dnn54wd5go8kg995yiujmm8fmbeqg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CE48140004
X-HE-Tag: 1790193216-551856
X-HE-Meta: U2FsdGVkX18ESZxTQasrmWeAADoPlsfhkshBDnaR4sHLuD4MtJwR5ygEBw2ZCeOoZEP4L7+QoNRl6xXHLgWlyYl524kfxbTLOn3KlGb980bSv51dLvNOr0JW6GdIqjohEEZgkQh0Og5tTwWULFXxPCfJASxzH+s3EpyvrncEubLgGg4xeXfj7Ox0qP26mRKeOcKtd9H3KRWasjvkIYO1Uk469D262rct1l8gH9A9jLnh6UUqD8rF/OOeudi/6zxJ12ou14/aSh78uNgYnLoRLAtOpYfI9Ft0HY8OQPzlSoYYvfbXCHslIullTI7NvCWFdduW6qFLEKX2EJjRYynSUXWV3tVFsn/JBJZM4XFyl8i1v/AAZxxjjpVKxteeEDlKEQZVshwvQQXcWEHjU3zVvTd0KW8qGjq/ZjzMCSICLtPBFeCBafY0rMY48l4ZXzsshJowKuoJlDhy9b6H2EFX0F19lt5tkeRLnxx8ZZFoophcv7rwj9/UnUxT4rixhD1Yl11J1wMC3Q+tFs247W6sLgHVkseHQmDvJD6qidNM9ZmPiBA1qiWS21X5O1HeqMpkMhYGNLK/cd9hryjWz1iiC5BA9jfswBsLf6K3RRu6XCxboL1vsI9wTx9fPO+ozXv88MLnOHzveHBBkAkjqUDq5oeVL+xUDllRkhdK4rPD6W+27GgiLeyFnthEZMlMo0XVH6zLsKstuDM4+mt7lXBWPjwjutxsZsFSWB4zwhrIZF9ZJ0sNYJQwujqd0Ih0bYhdB6ka8/tse46vXljQEYzmULjKrXaYQVKkk5BAZE2WoX49kNQIOPJBmgQO1Ixd03nPs4WTGYwofh2zR7PUSsHcc/xPtcDOGPCRzDiRWUYkdUiVXYBI2dvFv7N8TTWiG+o+R8K0Ht2pRnAIsg/TzP3O22zAsv2RKkQmPMaK/TtvMekm7AJxHlq8GQhPg4pstRml0t+NCzRDL01kwxusjNu
 ogX8Bsi0
 g7I6YIinnDloumj1diOaks7dt6Upefv/aiK2nzjUHQfcRgLwQacbdHy3mIt7ULrh1rALwhQZuALYf2GtqCEZHL9vMEd0jgtxo7oqPTgMsZPJPgkDvILxzHjxDLxrpnWloR/Gjz53jg7x0Feg0xXeIo9MizYt32RP2yBs3NZ4WM895C/M/qlfpMbMzKkZtbufWWba92AXiRCRvL9n/xkASHk6GFEIbqI6kY5Aa7roIYr1ncOJeXYO/0QN3WyZSptwIaZD/mGzb95rkxgsZ3eH7npw/1dq1SCNYUaTYA5ZFoC8xJaDCfW1bQg/3Te2k/jSxnsyCpBITS4i1GInRcRXdDCpRk5Z08JJAWSyQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 08:14:01 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Andrew - would it be possible to make one quick fix up below?
> 
> Fixup is here:
> 
> -		if (!pgtable)
> -			goto out_nolock;
> +		if (!pgtable) {
> +			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
> +			goto out_nolock;
> +		}

--- a/mm/khugepaged.c~mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse-fix
+++ a/mm/khugepaged.c
@@ -1329,8 +1329,10 @@ static enum scan_result collapse_huge_pa
 
 	if (is_pmd_order(order)) {
 		pgtable = alloc_deposit_pte(mm);
-		if (!pgtable)
+		if (!pgtable) {
+			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
 			goto out_nolock;
+		}
 	}
 
 	mmap_read_lock(mm);
_


