Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AD9C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C006B00B9; Mon, 17 Aug 2026 08:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5634F6B00BB; Mon, 17 Aug 2026 08:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1416B00BC; Mon, 17 Aug 2026 08:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6D86B00B9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:11:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7A4F1C1B29
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:11:00 +0000 (UTC)
X-FDA: 85110645480.08.735E22C
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2064AC0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:10:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QeEsg/dq";
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786968659;
	b=xinchOJH5qPLSmuCu7vRhjW8vaI+jlF+LbcXqHF/kcuciubs8aYDHSEqNxdpjVQt5i/6V8
	peTdVFghu5xfftrykNlaxgYTztAhQ0Lzx+BF84M2jWt3Yqp6J+u82sQcAmMtNGkoMoPgbf
	twi0Nbpd4rHjzpLYctezQwkLlCdTzR8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QeEsg/dq";
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786968659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ2+ubnMZf3r3CY3qPXvHtyj9j+4FAMip4TP+iqz1vo=;
	b=JHb7VXNZL/X0fW2O30ovKyp/gmJoGRdDGWepfoGjs9eov/Frl9H+pS767W3ckUWSM53GHO
	HfA/gHSmRZ056cgbUyCO4+1NEC0TGC/WeXpo9KJnUyeH+XJuP7NWxsZ3MFVO5oSAJBCguh
	PnVNtUvb+g1LkTarItZx/hwU+iAbc4E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HixNdaF24ntDEuguIuhpK7haYmS/JSSrlBPi1Y1tptI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786968655; v=1; x=1787573455;
 b=QeEsg/dqo1TZKqifzrBNzsykZmrFrlTHIwqmU/NfoUZuilMqfjcwRFQWsUqqIc1hgw0/A0kg
 JvEop+e9FDiowsS/ZKpFBBgvwCfaYypnG3Eq7CzMxKIlFsxztHVZ7HgwayE3nz2eXd+UkW0TJqe
 HoN2VbcomdRbSPmB6Q4EDzfU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (185.201.63.253)
	by smtp.migadu.com with ESMTPS id f0badc6dc42a8a86;
	Mon, 17 Aug 2026 12:10:55 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 14:10:39 +0200
Message-Id: <DKR7IK0VAERF.3ALVHRNQMSXZU@linux.dev>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, "Albert Ou"
 <aou@eecs.berkeley.edu>, "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andy Lutomirski" <luto@kernel.org>,
 "Borislav Petkov" <bp@alien8.de>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko Carstens"
 <hca@linux.ibm.com>, "Huacai Chen" <chenhuacai@kernel.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Len Brown" <lenb@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>, "Pavel Machek"
 <pavel@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Sven Schnelle" <svens@linux.ibm.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "WANG Xuerui" <kernel@xen0n.name>,
 "Will Deacon" <will@kernel.org>, <x86@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <loongarch@lists.linux.dev>
Subject: Re: [PATCH 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org> <20260816-execmem-set-vm-perms-v0-2-v1-1-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-1-90944a3ad43f@kernel.org>
X-Rspamd-Queue-Id: 2064AC0007
X-Rspam-User: 
X-Stat-Signature: i9p15sb4samz3qtba77n4hs3736icpb9
X-Rspamd-Server: rspam06
X-HE-Tag: 1786968656-633718
X-HE-Meta: U2FsdGVkX1/nFiKRaByETTbIunZSZ7kVX1MRgnsn4cM1BbGel7qeXp64FtHy66clbItOuFx9TeGcSRZXOXoPqlXsc6QE+VgVc1zatOJMFhKcC6Y59Klsf29ErQZ5WnmeVVfiz++miEc0y3k81AkWUZ8AsslvAP2pLWS5aeag4ZWsWKvfHfw1i++sQWDCIjiYk1rCcY4aPLf01j1xjjJeXXCBZkCBHH4vKS0K8QiKqqogc76kIRfMwAO8xjyNK3iX9AI1Lx9BrAHp9vwrd3GSiaBHiRat02C2Tlceo501xncvig06fl8n/jVWikleVfVMsmUCVAfE7Ij+hX0DrGWJQzXm+yPm6C4Md/2ti0wTnPa8yIWmKcjrmCSGyXW9teMcJFIvQWWSD1fqItMrqqRTBMi7BHRu/8ZxomkCBjuHm/hTnlF0B+rK4TTDBlMqjsLDy+elGnYjXL0PjOql6DWc5lUI1AL2JEe/Yl3IDemJghWq3G0l6lVMxJ8L5tGW2JtgcoE3gxqbHdlbwgWXDrDyXZPKo3TwXqjoexOwP4YhCs18XEBpCcw7hRcv8dh6c/4BlpjjyH8INPC3VUhceEbIt9lhXJEKsNDkEWfxuC/OGpkRkV7fo4pFNpQppQj5AkmekBO609qrrHugFbjGi0sBTJgH4Nb2U79/F/+VS4NdwHTSx8QdEmm34NKcmCbTv9+cNxgyhVG9l6K37UBx0C2TBAI1Px233vJQ7epT2sYaakwG5z/PBO9DedT5fs39rWJYu47ApXZe1DGj+FJk/vpEWI+HmdwjINbdWdTzswOHxWJQStH5eMauK9Yg66XmY0Y52B/Rvvk3F3fhW8E78y7kJOK3w8V9fv7Wa79nMHq9SpAS4DXMBRiZfflBzBikSia+bUjKiaYtQyGTh/V8g7qGkIDYkSDAROdY0LYedVta6FjRIYrrtH0gmh8ne+bk3Sk0wM2WOatLNiW749jAe/R
 Mz7uUjCd
 TnNG1G6S6AC1V1oxC/dtT///VUY5YETOhElAId600Z0ShfQnhUFYDWy+yi5s9sQxd4FjRzJD0yuVA2b7+gFdrDyH7HOlgQpAqrWWzHzepI86v6qxN2Eaa0KX6hRpdAXKwhRx45NGjBQNxzyyU0wKYkdPU+IMOI+M4KDry8tlj7G88QCsbKjKYkAOWKkiUQk62YRs2Vri7/WKY5dZwBjaJi8xp6dUrjh/Fwn/Hhgmum/ZES5HMJi34PWKVFpK+eHPfqC+NKTOUc026Bx36iGE5zlgzFtTASE1zqopcALxw6woyBzQGgg3cTd5i7hhxXxjaS484fVMcovz1/7P4b98nnqX1PkqILe2YUxcAAMYSRn09EjNFM+HevpPuSknoj6/QSTRG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> When set_direct_map APIs were introduced by the commit d253ca0c3865
> ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> parameter made sense because the initial callers (vmalloc and
> hibernation) had sets of unsorted struct pages that required changes of
> their mappings in the direct map.
>
> Since there is an increasing demand for direct map manipulation and it
> is also desirable to be able to update larger physically contiguous
> mappings, for example an entire large folio, extend set_direct_map APIs
> to receive number of pages parameter.
>
> As there is still only a handful of callers, change the existing
> functions directly and update all the call sites rather than adding
> wrappers for single page case.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I think if we add this arg we also need to specify how the
implementations are supposed to behave when they fail midway?

IIUC the incumbent answer for stuff like this is:

- The implementation might leave partial modifications behind when it
  fails. The caller needs to deal with that.

- ... But, that's gonna be due to allocation failure. So the caller can
  just do the inverse operation in the failure path as a cleanup, and
  assume that inverse operation succeeds since the pagetables are
  already allocated up to the failure point.

I guess it's worth making that a sort of explicit contract since it
makes certain implementation details load-bearing, e.g. I think...

- It forces the pagetable update algorithm to work in a fixed order.

- it forbids us to e.g. merge PTEs into a PMD if the region might be
  pending such a cleanup, since it would force that cleanup to
  reallocate a PTE table.

