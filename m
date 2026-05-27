Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E778CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831F76B00D1; Wed, 27 May 2026 10:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808E06B00D5; Wed, 27 May 2026 10:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748CF6B00D7; Wed, 27 May 2026 10:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62AFB6B00D1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:36:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10948A062F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:36:47 +0000 (UTC)
X-FDA: 84813451254.04.F1FF8FF
Received: from quickstop.soohrt.org (soohrt.org [85.131.130.220])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2224616000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:36:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kdesler@soohrt.org designates 85.131.130.220 as permitted sender) smtp.mailfrom=kdesler@soohrt.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779892605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=s85ZGRuBUmUk2iQ/0FH2yLj44D30vGbQ7jHq4I9PFwo=;
	b=qHGDeCILPacsMkH1Qr+PAJrZtFCuaiZ55AAdCb8ID/dkXpDYh5SsCtUYOfN/PEWAnZ1KhY
	DTP3RkY7AxwWjo6f+H1+Y/Aof4iNnE3s2TbqoQyA+OM1280fkFa7plcDlq+3KKIJx2NIOR
	M2ETQSFMTrO1yTYtwEm465ZKKx98E3U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kdesler@soohrt.org designates 85.131.130.220 as permitted sender) smtp.mailfrom=kdesler@soohrt.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779892605; a=rsa-sha256;
	cv=none;
	b=UwRqYXj6CoVrLVDG8knOGVSVNFejNDO+rV9phmxwtRjYVQe0J57/Cjm/FjEYbJg9WDtawR
	tEgsCCVe+W1LRmTMsy6M1r2DyH6DUfwg5esVrWunSp1HGRK92oWJymowm3N4olDj2GxWzV
	ZUBfCc8tj3pguGUdAo5jR/fYPG1/5f0=
Received: (qmail 3837 invoked by uid 1000); 27 May 2026 14:36:43 -0000
Date: Wed, 27 May 2026 16:36:43 +0200
From: Karsten Desler <kdesler@soohrt.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
  "H. Peter Anvin" <hpa@zytor.com>
Subject: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <20260527143643.GO31091@soohrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam12
X-Stat-Signature: 154ednp91cpe4dyykpqwupytkpe86ibu
X-Rspam-User: 
X-Rspamd-Queue-Id: 2224616000F
X-HE-Tag: 1779892604-51425
X-HE-Meta: U2FsdGVkX1+RhqHI4YQuMg1m2a1vlk0QqVD32NY/Yeb4TbQUDet59H9IQ6lBiymusr7EJkiZVtqq4GXD4ZXRvxGiSnSfOYTnl0RBhvLJ3Z6T6jmQDdSQTjd044i+WMOlp4hsHFbomk8tjohDqdtpZxLPmDCeFvUMllGjroYrEgwTmYZP/kZeqvypvQKlNdZ2P2P3O+39mZdpGlgoVNyNh3z/0fBi8C8cTD0uS3jDCeJUtSdCW8YXb9EzqlpEWJn+90AtAYHkM/eZ2naUlwOkBzzjuTNc+57zGvL/nVbApjcvvSXpXg5Bhsp5W0CMbEYRi2/RapLxwOrSRbyPpSjo4gHAfcSS9hKQuVEWPQUg2AQQjrZTXIh+htdBC2kl2FU6GMa+AJm1LTP81LgWWg6s6DaG7QH89fazLfcnh6NciiyI2297fnTn7DhaaLacyFHHjXkEInHF1vigD1DYuvLbes0tmnPYaXA1eYA3zd55K0NnghcCXxZpphn3iR2kok3dtiwXC7TCvEzfnWoJPnNs3YPODp52X94XgQ4/wyp7TzGmKyQLDlBb95ERoPvsyl3QkfHqNLlZ6usvzantQyTe1pxKLsbKDBr0HxProtC3mJhK0aGEnqOke6CWP+kh491VMwe9D9WREByoJ+nr2olSwLbfpWVrwFDvY62/fAz83iBsVdeFKALG9J/uXzT280pSgieJOWZ9pKjJPMY8my9aTaLUwa8S9UlggnqnEkKPGll8t5juoaP+IArRXu5+9EbSnQzDQPdsyGx2EvxQYQfgoZmnNGXxsKMgiymuLBC9LEn5OTE0BbsSFKl61J51fO3oyiR31IE0C+RTP9cwr+lbvi+E4KONSqXnmvG5ukmb/QbrdgxClBcJGuKX+3zE3+6thDSF/IppMrWDmdlKn0+d9qcPOMElXOMmL8OmbDpFj7HUBy3Wqxe39VW9kTl6tlC8vxp8bX/20phojtXV036
 dNPZPc28
 E1OkSYsBefR39q1Iai93KSeAY4mSglumv0kppQWUaz62JKdmTivPv0IDO8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I found a reproducible hugetlb regression on an AMD Family 15h system.

On some boots, mmap(MAP_HUGETLB) returns a virtual address that is not aligned
to the hugepage size. The mapping is nevertheless installed as a hugetlb VMA.
When the process exits, the kernel later BUGs in __unmap_hugepage_range().

6.18.33 x86_64, AMD opteron 6238, 2M hugepages

Example bad mapping captured from /proc/$pid/maps:

  7fc67f604000-7fc67f804000 rw-p 00000000 00:0f 12340 /anon_hugepage (deleted)

The address has offset 0x4000 within a 2 MiB hugepage.

smaps confirms it is really hugetlb:

  KernelPageSize:     2048 kB
  MMUPageSize:        2048 kB
  Private_Hugetlb:    2048 kB
  VmFlags: rd wr mr mw me de ht

Minimal reproducer:

  echo 1000 > /proc/sys/vm/nr_hugepages

  mmap(NULL, 1229824, PROT_READ|PROT_WRITE,
       MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE|MAP_HUGETLB, -1, 0)

On bad boots this returns e.g.:

  mmap returned 0x7fc67f604000 aligned=no offset=16384

and exiting the process triggers:

  Kernel BUG at __unmap_hugepage_range+0x5ef/0x640
  RIP: __unmap_hugepage_range+0x5ef/0x640
  Fixing recursive fault but reboot is needed!

The following is AI work, sorry if that's total BS but at the very least,
I can reproduce the kernelBUG and booting with
  align_va_addr=off
works around the issue.

This is boot-dependent. Some boots work, some fail. The reason appears
to be the per-boot AMD F15h VA alignment offset.

The old x86 hugetlb path in arch/x86/mm/hugetlbpage.c only set:

  info.align_mask = PAGE_MASK & ~huge_page_mask(h);

It did not add the AMD F15h align offset.

After the v6.13-rc1 hugetlb mmap rework, hugetlb mappings go through
arch_get_unmapped_area*(), and x86 currently does:

  if (filp) {
          info.align_mask = get_align_mask(filp);
          info.align_offset += get_align_bits();
  }

For hugetlb, get_align_mask(filp) correctly returns the hugepage alignment
mask, but get_align_bits() can still return the AMD F15h per-boot offset,
e.g. 0x4000. That produces a non-hugepage-aligned hugetlb VMA.

Likely introduced by the v6.13-rc1 series:

  1317a5e7f7b1 arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
  7bd3f1e1a9ae mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
  cc92882ee218 mm: drop hugetlb_get_unmapped_area{_*} functions

AI suggests passing filp to get_align_bits and doing
if (filp && is_file_hugepages(filp))
	return 0;

Best regards,
 Karsten

