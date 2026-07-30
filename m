Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16265C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041A36B0088; Thu, 30 Jul 2026 06:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34CA6B0092; Thu, 30 Jul 2026 06:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23256B0093; Thu, 30 Jul 2026 06:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD0FF6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:56:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45F71A1F1F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:15 +0000 (UTC)
X-FDA: 85045138710.20.1996B12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5599514000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNgre85X;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785408973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wfNj/VIelatDoZfj8ovdI+CcS7FJ5Qn9mwg8mtP50AY=;
	b=WHKQDDYEXGIgJSGbCMeA7d91gnSoP2ZUNHoOJlPh+IYgUNTJ44ocPYHLjkIFO+Sx5SKRi3
	7jccn2vZ2Fx7FPaliXa8C8eMSVWWbRN16Smp5sOmlEuB3OqXDuuClFMZuZU0IiBidgproJ
	nl5mGh0WSgu91XlWjmHS+iUpPvVHz0g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNgre85X;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785408973;
	b=zYdOWOIClvv5qYLoYrBOa32ZdjbdQamZNUDfpqKfKP7XCwLvWinHkUMPsJMvx9FeNXYP7h
	fEIjp00pE7MQEeLtzxLLLwTOES3cecLGdS387Aj0X+9+S3BmDdYBYB49bTRbKWSIOfKvck
	eixRZ8bJeLNRK3jnYyAI7OIAweITRsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDDF4156D;
	Thu, 30 Jul 2026 10:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B241F00A3A;
	Thu, 30 Jul 2026 10:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408972;
	bh=wfNj/VIelatDoZfj8ovdI+CcS7FJ5Qn9mwg8mtP50AY=;
	h=From:Subject:Date:To:Cc;
	b=CNgre85XCyrLPGr3zMKNY+S1JueAGUuexUDQ/yvWoDU1hIkQUNo5C9dzfCCP7xgFs
	 T+nYTF+w6QzGv82x6d48oVA0cgkF28FSc/8YZAH52ZBibFiC5S4hWIdqqe5QhwrAS5
	 lP9bagxs6ADmCUagtNA98gLrnmvHTFoAnOFPtXe4godFeMI09RKyGAWKIIdicXViJr
	 W36wFtZ29DB8KW5nxGYcGyC6t449S+m2nUBrQ8sEisW+4/5DnN26fucI/fOluvRgXm
	 Ix7KS+78jAtXC+LgDph0YhHZTTevL1EznD65ocOI3UnqZPCPIO0OraC1WZPyc3ySi2
	 hxe8Kx3om2lYQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH mm-hotfixes v2 0/2] mm/huge_memory: fix huge_zero_pfn race
Date: Thu, 30 Jul 2026 11:55:46 +0100
Message-Id: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALMta2oC/4WOQQ6CMBBFr2Jm7Zi2IBhX3sOwgDKlVWlNWwhKu
 LsFDuDyZd7/f2YI5A0FuB5m8DSaYJxNII4HkLq2HaFpE4NgomCluKAyE3pS0g02Uot6SMqXvEP
 BZcPKJld1RpDi72SZaau+Q9+jdnHnaj+GoXmQjGv5qmsTovOf7ZGRb6H/myNHhpkSBVfnPE/jt
 yd5S6+T8x1Uy7L8ADJNqbngAAAA
X-Change-ID: 20260728-fix-refcounted-huge-zero-21cb07b4fa3e
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, 
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hengbin Zhang <uqbarz@gmail.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3044; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Tz1wBhT8fjQPH4rplQ3wnVB93b1/+MbegCle+YCQO1M=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKydbdfWXSi5spEpktXTDvNpzbZ/xWYbGZovdvyAKNhd
 QLPYkPXjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkchnDH56FB1fmhl/PMZ53
 /7Zbd3Rrz6Wsqt8Cc39Y3dHIK91+up3hv++2t6vNlzSzRqc/70iftyo6d7fLKz6ZN5L2Xp+1vxX
 IcAIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 5599514000C
X-Rspamd-Server: rspam01
X-Stat-Signature: fjwbcged9g9xbdikbig71yo6qznq1xre
X-HE-Tag: 1785408973-332908
X-HE-Meta: U2FsdGVkX1+Pw6X/SYz1bpKUzQWN+BooU9LwfjI+ALXYdtY5lnYSfQ6KAoOJNLJ0P8uocCqryC75VaWZ0u+vSXlalbTI1uWrOGckNknAeUOMbi//FD/oSVrC5oI4c//xXDbISOJYDvsAtCvBKttOx9m5pNiFU4GNwomQvk46nW2xGN+7Iu4mNFV7xGrXzCiutdYx9i1IioVvDw8yAfg1l406CoDvMDHKpHb+BILO7fficdhVOotuia7jVYkVJtLus/YBTM2flXw3YZPrXyfsOUYkvraLkIzXcwOCwsRq8Q5mKmT1JCzAJQl51x++jrttwmGbotVbFNseNbo273Mg42ysLlXdMi25q5xGmb7C1zgX+JvyhqMv02QRipQnqlo/G2/lzaYQ2e73JVxvFwJu+z2MM1raC6bbEYdpNEFceA9VdZEiD6G5Q5K7F5xX5MxHQSYm+7zU1cTuM01BkaNjIuPForxZ4RcXgV0JU5aFvdTkW6btkwWeyJsfEKg4yCgqrs4RqxDxGIj1Rx1m5DUDG+krGUXX35D860lwhw7Dbxc7IvAjtkuXzo/UkWBoo391tKr67Wgj89DaWR/gGWyNvnem8qioa4Rr8UXXXInimWBclRKgTtKe8KsWN2eKNjCVOjg/TBBusMmi0iT2ebQ6gTi0mafN8qeXpaQ5beqZ4IrcfJ7ipT6eY4WuA624XgaP1RwXyh6XFGVaQVCOckKxWQAsTFiF3AwJBSDKLO/quIHl+TU5su0wjVNkScJrwPR9UljMZCee+Ngr62fzDfoLSNlptszZSzGX+g33HEAwuod5mTv4EEdYl/aGJRikvD6qq+C9SsOhlmnFB0NDr2u6D5hCMyuMiMS51I0DebahT/xx62pSx39RYFODKsjR6JiAcurUOiyt30DSpveV477j+b4+yDWjy6qMvnf6tnpO1n0hjyyxgaQ2IaOpZO34dAtdLLde5cTopIhFnn8uXXw
 kVvj1Dsq
 Z0cPiHoftOejG/tw46lC5UyARRyfHmKKlQ65rFTiDRSuEalyQmshD6PnrM62dY9FAMden8kbUZ+ulFBMr9yMA6zD3vNLF70+Moirh2kjdt0c7V1UGkQl2J3qS4gy81jj9OUFmZZt9YesjvoXWcUrP6ygXEhdnSuWGbHRcpvE53VjgeIk83hkHiOqqbH1vsSCvSRCsZrn3B512ojVNLR7c1wrX18RKksY08lOif9PJmMfXcneDfqFC/UjPv4ZBqnFkPuYIQ01y5WmCnghJyhRL7Pmr3gBTmamvRCflVm6PVH0MlpKqE1RplgpW7909HtE0iNvPL8Nlj3mW1hp9BoUPpsfpDqjo9PvSwLqiU/LLGrSkb3GHL87y9m4wDP2dWDP8KjwmjYkz7IJZPROFWjjQIDKRLYPVKAZ9X3mASfPIi0Xg2NM9zBiaAQytHUSi8uxrr6I28wgwjZoODjKBHH3wTrWYJzCWLMgySf2IfxdbSzII5KBF9Rno1PjmXjTBQ9Oaj2+22mIlLinJ8YqSU8GRaOPzRRj4E+0+8Ql4QtZ24U6tjluVH6XRmxlqglHhuVAZC6I3ycJtlVmOdVFLpuE9Mg1hpiICVBI5H01GJg83PvtvKF4TPhFxdsDW2Bifan+5JAKir/6ucLT+nn9LCZSZRKQFUkENM2bbYF5AeK+IpcXYNl4emMiwG/LwVHBi8SC8I3LCYd7thNz0ruY15MEoPwTCutcUsJfD1zfxUsT12KpCOKN8m7H6g3EYqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a subtle race in the reference-counted huge_zero_folio
implementation.

The fast path atomic logic fails to account for the fact that the
shrinker (which drops the final huge_zero_refcount pin) can overwrite
huge_zero_pfn with the ~0UL sentinel value in shrink_huge_zero_folio_scan()
after a racing get_huge_zero_folio() installed a valid value there.

This results in huge_zero_folio being correctly set but huge_zero_pfn being
set incorrectly and thus is_huge_zero_pfn() and consequently
is_huge_zero_pmd() will misidentify the huge zero folio as being an
ordinary THP folio.

This can result in the huge zero folio being split and otherwise treated
incorrectly.

The solution to this is very subtle as there is an atomic fast path, and
thus ordering in weakly ordered architectures has to be treated very
carefully.

The first commit fixes the issue by introducing a spinlock around
huge_zero_[pfn, folio, refcount] write, with careful consideration paid to
load/store ordering in the fast path. It is placed first and kept as small
as possible so that it can be backported on its own.

The second commit is a pure cleanup which reworks the
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic to better separate the persistent
logic from the dynamically allocated one.

Andrew - I know you don't like a mix of fix/cleanup, but thought it'd be
easier to keep the 2 together as there's a dependency.

---
v2:
- Reordered the series so the fix now comes first with the
  CONFIG_PERSISTENT_HUGE_ZERO_FOLIO separation following it as a pure
  cleanup as per David.
- Fixed up wording as per David.
- Cleaned up Cc's since dependency of fix on cleanup no longer exists.

v1:
https://patch.msgid.link/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Nico Pache <npache@redhat.com>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
To: Pankaj Raghav <p.raghav@samsung.com>
To: Hannes Reinecke <hare@suse.de>
To: Hugh Dickins <hughd@google.com>
To: Yang Shi <shy828301@gmail.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Hengbin Zhang <uqbarz@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

---
Lorenzo Stoakes (ARM) (2):
      mm/huge_memory: fix huge_zero_pfn race
      mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic

 mm/huge_memory.c | 189 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 116 insertions(+), 73 deletions(-)
---
base-commit: 5db85e34ec49beee590676d55f13e8e2b14c742f
change-id: 20260728-fix-refcounted-huge-zero-21cb07b4fa3e

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


