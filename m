Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64107C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263606B00E5; Wed, 12 Aug 2026 07:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23ABB6B00F5; Wed, 12 Aug 2026 07:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177F96B00F7; Wed, 12 Aug 2026 07:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2D486B00E5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:37:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88C8B1C0EB8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:37:05 +0000 (UTC)
X-FDA: 85092416010.16.DAF652B
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47C621C000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:37:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=jmUgl7iL;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zt5aG8T70pAVsz38Vf/LQqt7yVTDjwmbD2OUxXE/YKw=;
	b=rq8bFCxVB9w/nnjRL71Ftp2OoaapzVPTRje7N89QjkrKr29xS5RZidZ11ZQZSsw/5ttyw0
	SXqt2y//culMkuC3o3GrGNcsSF+Iws+N8Hbn2O4b4JMC1LKi9kXQ0GtS3Bxv8a3huMk9ed
	KS6icLUzsLQeA/syKhiwx3K0ETSSj1Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=jmUgl7iL;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534623;
	b=o7L6M2nEAJnP/C1OP1zq75kZ4GJL9JQMaW4kKZkSkmTFAwSMsCFJEv4weT/OXWNqHUjdu/
	9KA/0IO9uNPHLybRXG7dLezuf2faS0Rwmh4JalXe+z5yzueyImpQQmYy9Nwp8Tj+oZCen9
	4etzgLDLc+osIEMmKG6hdYKpJHjutQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786534620;
	bh=zt5aG8T70pAVsz38Vf/LQqt7yVTDjwmbD2OUxXE/YKw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=jmUgl7iLgfoUTZ1W8XhpUyUvliTn62FHeVsiCG0Z/UIJ61ojEssIleUCeHJiV0KQU
	 4oryrUMBdJkrk/FWrelE64YPMAu7FQKIr+CYhS2RtF7SRQ6xUrQ+6QcLU+j6mlA8X+
	 Do8TfjkyyO/aXIfS606LkNQrwlIw0nbvgzmTmueQ=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hKmg01XsJz6vGx;
	Wed, 12 Aug 2026 11:37:00 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hKmfz5Q9xz4y6W;
	Wed, 12 Aug 2026 11:36:59 +0000 (UTC)
Date: Wed, 12 Aug 2026 12:36:59 +0100
From: Bradley Morgan <include@grrlz.net>
To: Breno Leitao <leitao@debian.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 rmikey@meta.com, riel@surriel.com, kernel-team@meta.com,
 Kiryl Shutsemau <kas@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_0/2=5D_kexec=3A_keep_the_ne?=
 =?US-ASCII?Q?xt_kernel_off_hardware-poisoned_pages?=
In-Reply-To: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
Message-ID: <6D17A62B-3124-492F-9593-63F857DD475F@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47C621C000F
X-Stat-Signature: tahnfo1n7ytkhx5sy149iu36wmdaiij8
X-Rspam-User: 
X-HE-Tag: 1786534623-786999
X-HE-Meta: U2FsdGVkX1/6xJUKIMJRkxLQCeCQU7s8mUxf4BEISyP3yXKzxSAhfrISErtLSutFc9qP4H1ffWpwwD/alOPqBjGv+o7uYSR8bvv4qvi5E1P5uMUihAR1nKVXOJ3gFdSzq0GbGld/Fvz6yy0ELWkUpHK1hvM9t4s55leEEOtO+thx0P8uJLdZvCNKAkJ/WWCLJd+nLNz7tLCcUIH3NNVdo0vydYwQUOrh82JB94Bmfuji1/46h0DVggDXiPbAjyfiqVsHJQOAAgkn8Rwdzi44ZIYbv8CNqOP4EC+XRIzlEXU38fKqhkhlnfkMcCxVYkUUWOG9WN2h+odnWWdjUF7O0/xjwG7pYqnOFQGzWNgxi8auFtIz/HF+2W9L7GHGLFMofdSlhviZdytQm/JXbH/13/DRQR9cHgTKLkKBHIhxK9iQu3koHMGi1LxnezKrRCsPfvNciz17lRfmBUgPrOO8NwSbkkHrTojPqT8GoqnbjjMRzd5oS+klqpSloda2aF81bpgdpPCzC27bwmJP+HbJQb6fnibFPxV9gEyEwWdjn5GXmlEfdP2ZymvJ+wrAx/ZdHHD3wEHvMcTavNJa1Y37gdOSN0nfb29YeZohWccMaHJ/ohrOOcfdT4z1iS/EsceqDSzMgdESrdGpsXtRs/bOipyo/qlg63hQtZQp2sSFi3/MBCY7bQ7OkV04343doTPV8qhYoUvaPRqO8K3TnTkQ0FIysFX0slWdpazCllpfYSIyyWSFaOCo8QB3X1rTY9Z6r2RRs99fg4S+as+40nFr6OpKJ9Fm5ZXTit4O9nXMBpOIvORFCdnRSvcRtMLMD5sgPh4u1z6VIky4E0R4LMdXpxeuLbJ2roQIq3M0DGdV+iO+ik2RvR2yPDGhTHEBiiAwOXZfzPjtSI/KwIsPwLSFFu32kRaqB1OUFbDcmyIg88jIn9LoIrwDaReiRZKQ4lrVn+m4aPTDRjZa6PCTzid
 gQraU2HZ
 2+GtPczkiMvp3fJZTc7O1nhpJwRFMKogjxnckGVv94TFfoP/aINemmcbk0r62AJk8aCEd1yekJDNo6THw6Ucvg30hFZT5b9IUACWe78+wAsKqYOCEJGXETo8Kik3EibFcY9O5Tz+og1UNqkmw/MxRqaG5BPP+teVwdHL+QbMw9bU154vfDtnHciOcHM9xdIVVx1WLdSnQBwroxMvf2nYRFx0Avn91XZuRmEbLE7TV8WzeXoRBo0Bcc2qSt6sdpMznobD/VVm73WUWn92V/Y9mbDVkx3LIDHzSXTLtqcUlEFcf53gQc9etkt+dBq0Z5Sidk7rGdcEl7ndJMeStm5I9u2xGlz5KVFHXoEQRUtk3tkdtVfGU5Zj1vO82SMDaNhtzYMoFJa37Ibrjtb5ZQt3QGJZWCDSdYSfaaE1hINPmd5aBLRJ6fzx7zqvgflJOCkgMbGhD+B8YVAOl3mgCgMDYxtHGJeF+rRd2mMsTQ5LyaSBYUcnad+0u6uMYkiyJmuFsyNfwJV2c1YtqkQk0K9OQqzNHHBDv7zLRrC50tgSp3uG54dG8upJJg8VdSTZtSMtUhzK5CWrCeluvuxvEmA7IhJ1rRwB9G7zkom6ya9jyZ74O4NmN4CvzZ8mpoYh9iYj0qS88JPTPvwANDvqh0qk7Ywey4t3Br12EUzuaPraLYe1P0hZuvfLzjV6F37qPHHvuqU1WyYTgtxOxtPEn4fpESeBVoWQM5Iteu+rJxRjuOHJ51oZaSZDLWSuieVP/6mpMizKH9mn3e1O7og74a979bOZyTyb0zzJqtw2caLgO2yQIVKuWMop1v89gZ7bb5W22OtFjQLjjhaMPgZ+7XaobgjoWs0pZg1iIgISkJw5JsQBlYD+9FUKd73/p0mr7iZvceu/nSPgsSovzJEt8ANUH45j/RtclihsC4e61bQ/dTxve5BmbUlRlO8wAMxbvGjD8Hj2JXH1NK2TLR8oahjDcuwebISYw
 L5GqKAUo
 QLBXa2hTjhH65x2KBuVaf8+Lp9tbEboNC2tjASN+/IlulyfFlTUpuDlr97Qz41LC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 August 2026 12:31:50 BST, Breno Leitao <leitao@debian.org> wrote:
>Memory failures are common enough on large fleets that kexec regularly
>lands the next kernel on a frame the memory failure subsystem has already
>marked bad. Patch 2 teaches the segment placement to avoid those frames.
>
>Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
>downwards without ever checking that the subtraction stays above zero, so
>the walk can wrap and report success with a destination outside of RAM.
>Patch 2 adds one more downward step to that loop, so the bug is fixed
>first and both patches rely on the same bail-out.
>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>---
>Changes in v6:
>- Split the pre-existing top-down underflow out into its own patch, and
>  drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
>  that the loop bail-out covers it. (Mike Rapoport, Sashiko)
>- Reword the changelog: the MCE comes from reading the poison back, not
>  from the relocation copy writing it, and the placement paragraphs read
>  better split up. (Mike Rapoport)
>- Move cond_resched() after the struct page dereference, so the scan does
>  not yield between pfn_to_online_page() and is_page_hwpoison().
>  (Pratyush Yadav, Sashiko)
>- Keep cond_resched() per pfn rather than batching it. (Kiryl Shutsemau,
>  Rik van Riel)
>- Link to v5: https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org

This is a two patch series with one patch, why?


>
>Changes in v5:
>- Return -EHWPOISON instead of -EADDRNOTAVAIL
>- Leverage is_page_hwpoison() instead of per-page check
>- Link to v4: https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org
>
>Changes in v4:
>- Anchor the top-down hole finder on the first poisoned page in the
>  window and the bottom-up one on the last, so each jumps clear of the
>  poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
>- Count a poisoned hugetlb folio in full: the flag lives on the folio,
>  not on the subpages, so the per-pfn scan missed poisoned tail pages.
>  (Kiryl Shutsemau)
>- Link to v3: https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org
>
>Changes in v3:
>- Return the address of the last poisoned page in the range, or
>  PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
>  parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
>- Add cond_resched() to the scan loop, as a segment can span half of
>  memory. (Sashiko)
>- Link to v2: https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org
>
>Changes in v2:
>- Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
>- Return the poisoned address once we find a hit, to avoid the O(n^2)
>  rescan. (Sashiko)
>- Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
>
>To: Andrew Morton <akpm@linux-foundation.org>
>To: David Hildenbrand <david@kernel.org>
>To: Lorenzo Stoakes <ljs@kernel.org>
>To: "Liam R. Howlett" <liam@infradead.org>
>To: Vlastimil Babka <vbabka@kernel.org>
>To: Mike Rapoport <rppt@kernel.org>
>To: Suren Baghdasaryan <surenb@google.com>
>To: Michal Hocko <mhocko@suse.com>
>To: Baoquan He <baoquan.he@linux.dev>
>To: Pasha Tatashin <pasha.tatashin@soleen.com>
>To: Pratyush Yadav <pratyush@kernel.org>
>To: Miaohe Lin <linmiaohe@huawei.com>
>To: Naoya Horiguchi <nao.horiguchi@gmail.com>
>Cc: linux-mm@kvack.org
>Cc: linux-kernel@vger.kernel.org
>Cc: kexec@lists.infradead.org
>Cc: rmikey@meta.com
>Cc: riel@surriel.com
>
>---
>Breno Leitao (2):
>      kexec_file: stop the top-down search before it underflows
>      kexec: keep the next kernel off hardware-poisoned pages
>
> include/linux/mm.h  | 14 ++++++++++++++
> kernel/kexec_core.c | 10 ++++++++++
> kernel/kexec_file.c | 20 +++++++++++++++++++-
> mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 83 insertions(+), 1 deletion(-)
>---
>base-commit: c5e32e86ca02b003f86e095d379b38148999293d
>change-id: 20260727-kexec_posioned-72bb0a4143a0
>
>Best regards,
>--  
>Breno Leitao <leitao@debian.org>
>
>

Thanks!

