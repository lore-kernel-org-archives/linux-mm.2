Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5145AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874A36B0165; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825CC6B0167; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B556B0168; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 417DD6B0165
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 240631202F5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:12 +0000 (UTC)
X-FDA: 85092403704.03.7D38AD2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62A82140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nBqpzEym;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534330;
	b=LFDVDZ8E4dvknfG30zK9FirErzrGxUk+zAamMXe9Ba9/NbvwDpyJyqUY53rvqxr16aS4Kz
	9m4V6GEmePtWtqTnRP4h1xiySELTraVj9VuJ9GzwpomaWym93SSR7dOBlopQyZQMkxYAK9
	HyaWyvokd+ginKoePWyUmZMOG1ueLa0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nBqpzEym;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XKdbUWVjqXoP5QkUXtvUTfFmZJO1U64wmy2Dn8sFEgY=;
	b=F+3Y20jKBfnjI+rHUkRSlVVlyQLbVr8B8DlM+QBzC+jS1yugSlRpNs+vlsIUebqrpVe+Os
	KHzVYhKrvzgU2T8JhJwLGHXsYk8u11XhVLJQMdPyCadfKIdqC6s8Lg8uDk6hhLmE7Jh9Da
	2dDROQmRXuFd5F1cDRvKuhnahRihhxA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=XKdbUWVjqXoP5QkUXtvUTfFmZJO1U64wmy2Dn8sFEgY=; b=nBqpzEymNpnG2HId4WtGj1MEdu
	S6GCQwciU8L1OUqLGN8J587I0XRVbYRruA9hE6AOieKa0nfA9YNRMeThxYiybpb4ebbZ0T95a309C
	RrMi5JRsPnai1lAY9uxzVZcZSO0aJsQvPFyA80Wl/WE6C2k2qo0pXVOp0M31VgbaSVfblaJ12jrSv
	hGQWdCfIaoDJJbDZRf+trKB6vAZsVH0AEKVXLupg9QzzE0ske1hrfv08+TS27YAculnFGC5TgBo5U
	VroTc5gKS436rfbSGtv2ApEnejh6J6o5w3/U6z24wZLjVFsPz4ZXseru4TriWBqQqixRm6vX0ZjYV
	475p7TMw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu7Bi-004JJE-0s;
	Wed, 12 Aug 2026 11:32:03 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v6 0/2] kexec: keep the next kernel off hardware-poisoned
 pages
Date: Wed, 12 Aug 2026 04:31:50 -0700
Message-Id: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKdZfGoC/2XQ22rDMAyA4Vcxuo6G5VPcXPU9xhhOLLdmkBRnm
 I6Sdx8pjGXzrdD3I/SAlUvmFQbxgMI1r3mZYRCuEzBdw3xhzBEGAUoqJ3vV4wffeXq/LfsiR+z
 VOMpgyOggoRNwK5zy/Rl8fesEXPP6uZSvZ7/SPv1J+f+pSkhITk6eInmZ+Bx5zGF+WcoF9lZVB
 69l4xUSppOK5K2l5Ezj9a/3UjdeI6HXITiOLLWlxpujb15RDRL2Mto+kXHKxsbbg6f2fouEJ8s
 0WlbsrPvjt237BuvIbZutAQAA
X-Change-ID: 20260727-kexec_posioned-72bb0a4143a0
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, 
 riel@surriel.com, kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>, 
 Bradley Morgan <include@grrlz.net>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4000; i=leitao@debian.org;
 h=from:subject:message-id; bh=MEuO2alc61B25/RbuNvMKIHActXYMHq90TiaCXPG2gM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfFmsIQEnDIumBT1dUzqWEh0n4xoEnjZzL5AyX
 uRmodHGmXuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCanxZrAAKCRA1o5Of/Hh3
 bZUWD/91dXzRWqOndMqQZW8KYQaSDpHWB5EzGhwM5+rZECR2+0h8C/+bLmI3gUsHIdixbYE/yh2
 LWHOiSJhopjAbzpKo2M5MlnhlFD/fEhmMUq/PvSbsO2NnKhYAFG6DDuApmgUHGOaHeBNQBF0dXU
 yC1fcWse9Xep2n3nwmmRekxkUziMX2FYj78rjQdkTnfWzlIZQjx5cKigcZZc9NxBYkwTVMY61B2
 D3HF2sEwu9+nkBMN/MfgbKhoVKRfZEfEl2kwAw86Gbih7GWBr6VXMJ4lhtzBETVfOWq+tJJdhMO
 KKbVpG4xVhBvGc0HkEW1UnSG3tEb0ZqzmFs5gxLTpFIsCk+rt6LEm8qzda/wVRwwFgXb804Ix5c
 xd9weCQyDdQw6sTbZfJU2JEuvtxds/Zv4L2FoBOcIf+ZHxOuQffSV9uYSJNUOpSHe+exqt2iJie
 vAkudANJRCTmaDM+54PO2nasXoB9PhtQGHJV+48InkGTgxZTGZs5/4legBfKMT7YsiyI9LaS/vZ
 MZ02c1ljfhOsBVceQs0P+WsfJ6jShGinCzLfw+j3CFNXCFkHEsmikbReimi01nCx+Nn3NL028Wo
 cctiIX+G67d/etdCT0a65SAMdIWjNWqM+CQ9aKkBvpFKvK4tvAjtSsGqzKHXUxnpgy4uY4vGomS
 DxRKjKNPpzKSHUA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 62A82140005
X-Rspam-User: 
X-Stat-Signature: 7k4oewztkkbtbn6pii3f3q6bw53ornjq
X-Rspamd-Server: rspam06
X-HE-Tag: 1786534330-12255
X-HE-Meta: U2FsdGVkX19cM4UKkbOhOoJiS+tUSKMe68wz6TCTLW0rHV55zd0E4M8BWZAwDTZtSbxJ2a0KopJ3DAJlOFoSalXJmPX3/8ypVsVbuyKjoLgOGbu5s6r78ZPveR/KRY2VmKq+aahiIzTEP331gB3jpznEfKRgD/t/VNgmSuTfk+11CNlrUVovAxWHuvTt9aRveMPt2ulJouM+GyYtmPoulvIRJqA5hge97BguVG5XGxqQy9pxzAse8ll1UUpwe5Hxm2v/Q35KtVrWqjkA78DXDw0y9/MdnkdkTXUp76sRvcGjwfNhAF9GqUYjn5UTjrtbsyFmMbj5jCjXRG9o2FJsEHlBmY8nZkyJKN86MfZuuKp3aA25Hwk4OHwhW3qw/+dpgbwIVEAJcpWTW5/IxmzT9B6uVd7kwpiBYq870K7FceL2jLrvKCPMgTmi641XzT6poXZlhEyNQYjnAhx5N2N+9Td6VoEqWrlMNFJKtlLS/tp5LWCoPjK2GEi8DWbQ2NsxOVP82OZgaMLCCzomS6KEtXh9y0fWtpVm2sF1YiVZtj7LWsYwzPnCl1GiGdZu5eziMTndV4rRQp1kR5s9xVX0Fznu4fL4STMVeD+CPX2Mp/U5rpjOuYep47DGBUEfhgGZF59RokFX0RyOsdCah0mg09speCng0nUbGA5jPWx3znYvTExwgPedAckbcVVLKWBFXN60m0pRwrhYbELei/kKxgKeFWwy3q/r6HAzYRTvIkT5hAjWj413E2wragnllohkqM7Rf8gRknrBZ0t1N03eH9er5xVFG9DzwLINORLR4DTwnGGIIieY7G6Ksn6NaOfv7hL294ZigG4VlZPnye/msbmroqUzZ2B8wvCE5EfnK1RDVVmVnYf1zp+JUNNCd64RbM5y/cg5XBjvWVAC+JP9xyVCt/vsEmRJKMzZz7mGQQwOqVHxlUY2kQQ8PTeYhKMEan6u3OpV2yWD0t3D8bZ
 dYWFFT3w
 k2KrwskWfPQfpAzId9OqICnW+SK/z7dbPI4+eN9Kuznppb1Oxo3r8H4vTW1nCi/EjLSPLWLyVrZWXHOhApYXcitcHhYFVktXJdBIf4yg/nZq5GyGu1xL0yUwL505WFaZHZXwLEnFhoQVi3UVkD5EWRLMapJAJS6HVpvjBwltXRL3TTeXy7wm5IeV8+KjYGl4cAfd7vykoWObZwXdJ0G0iIa05MRuji6k4O77irylvJq6jHLfSz8Lcx13PUZ0e4TFFo+JgTv43RWB1Zta820Bt09bx1szVbWAHipwfIWFFSWtlIw1RuB0hWbKZ6SfwMYa6kZorOyAz69AJCoLBFVg4Cq5mvRAFmR8UtjTksBMDEFwVShWYsPNdUwnwXbbVds+Wd5YEAMKqyNGkIbEL2pfY7IOx5DrOfF7DFAaymArAvebkavdUMLYCIRnvgO5mbY9zhOzcvPi2f+l/LEeKuANcvOk/DRUX5R8a8JCPJaxUhCTM1XaCiiqPrYulJIRqtK06qUhn2JkQrUJQX2bs5FlvO5tcEiYcwtCCliGH0qGgMeLQqnzIzEa43DXTFq81Pkna+BQDzGwEVlxABOFXNbm1Gpk96Yzd7MEkhNrWp2O7TU98L1iYl1yvNYHhfwEl2tHL0LsWgbbn+sM2UjnQAC1zQ+4/rixxIBL2aBMH3ZQXFkoqGdsVJv2bVHO2A31LAG6zOG9bZQgRo3qpymPxmjkSaArslT5sWDoQBFAOXhiuBaojcPjO6s5eVKNxsWZ2p6jHditeeU5l9E/0Ax80qVQQZrwEwTIsljNrSd2zV+5vo2Z4XVKgjr+8ccVj3/V0CSMwsdAjTTAHdHCvc8hC9Yo7ls/FjTUu0VgAHZ1a2kmGMsY+ldlQ8yrp51hy04+hjZ2GRXpWoWWK8kI7fMxqA5Mi7wJJz4mZHJfIb2mmXvngwEHHUUK2EaZ4c6r+7mR6ZOVyrpgK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory failures are common enough on large fleets that kexec regularly
lands the next kernel on a frame the memory failure subsystem has already
marked bad. Patch 2 teaches the segment placement to avoid those frames.

Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
downwards without ever checking that the subtraction stays above zero, so
the walk can wrap and report success with a destination outside of RAM.
Patch 2 adds one more downward step to that loop, so the bug is fixed
first and both patches rely on the same bail-out.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v6:
- Split the pre-existing top-down underflow out into its own patch, and
  drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
  that the loop bail-out covers it. (Mike Rapoport, Sashiko)
- Reword the changelog: the MCE comes from reading the poison back, not
  from the relocation copy writing it, and the placement paragraphs read
  better split up. (Mike Rapoport)
- Move cond_resched() after the struct page dereference, so the scan does
  not yield between pfn_to_online_page() and is_page_hwpoison().
  (Pratyush Yadav, Sashiko)
- Keep cond_resched() per pfn rather than batching it. (Kiryl Shutsemau,
  Rik van Riel)
- Link to v5: https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org

Changes in v5:
- Return -EHWPOISON instead of -EADDRNOTAVAIL
- Leverage is_page_hwpoison() instead of per-page check
- Link to v4: https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org

Changes in v4:
- Anchor the top-down hole finder on the first poisoned page in the
  window and the bottom-up one on the last, so each jumps clear of the
  poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
- Count a poisoned hugetlb folio in full: the flag lives on the folio,
  not on the subpages, so the per-pfn scan missed poisoned tail pages.
  (Kiryl Shutsemau)
- Link to v3: https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org

Changes in v3:
- Return the address of the last poisoned page in the range, or
  PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
  parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
- Add cond_resched() to the scan loop, as a segment can span half of
  memory. (Sashiko)
- Link to v2: https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org

Changes in v2:
- Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
- Return the poisoned address once we find a hit, to avoid the O(n^2)
  rescan. (Sashiko)
- Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org
Cc: rmikey@meta.com
Cc: riel@surriel.com

---
Breno Leitao (2):
      kexec_file: stop the top-down search before it underflows
      kexec: keep the next kernel off hardware-poisoned pages

 include/linux/mm.h  | 14 ++++++++++++++
 kernel/kexec_core.c | 10 ++++++++++
 kernel/kexec_file.c | 20 +++++++++++++++++++-
 mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 1 deletion(-)
---
base-commit: c5e32e86ca02b003f86e095d379b38148999293d
change-id: 20260727-kexec_posioned-72bb0a4143a0

Best regards,
--  
Breno Leitao <leitao@debian.org>


