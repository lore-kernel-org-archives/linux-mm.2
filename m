Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B0DC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFAD6B0099; Mon, 31 Aug 2026 09:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60FC6B009B; Mon, 31 Aug 2026 09:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D767D6B009D; Mon, 31 Aug 2026 09:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDC626B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:42:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DCF8C0151
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:42:37 +0000 (UTC)
X-FDA: 85161679554.30.A11B3E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 907134000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:42:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcZpN2tt;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183755;
	b=hqRRT32NvYPRYKMLuayBenY1xTn3dMQKfWF/TDkcC4F2lryfcoIQSYnZyHWi2YgvVUkv9m
	36ZEcthAwdlD84u6VirDA7/tjicK+nSTTYyytv3BfyIFIliCgV8aBlYPUi/vxZNOe9WEwE
	fkWGoMxxW6De6sZzY+7RqIruAKYG+x8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9D2sLJLRMjg28ShnK//LuwgfrmGy0ErZnTjHVTXBcrA=;
	b=TFHHfkCgnUm/br2gPrKBr1YsBm4ij6MJzXw9oQf1xLM+El6Xil2JBi2LAL+Rfwxp7jQHce
	lz8LPv9nqVkoiTdY19RtmV2v6Y0BNNpGQp3GrKe1xkpuDdc1UTDas+0aWI/7PywDaJNwv7
	qNtG1mL/MjHdyCY4MqQVTP9ofqYC9i4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcZpN2tt;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3D5660238;
	Mon, 31 Aug 2026 13:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291F81F000E9;
	Mon, 31 Aug 2026 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183754;
	bh=9D2sLJLRMjg28ShnK//LuwgfrmGy0ErZnTjHVTXBcrA=;
	h=From:Date:Subject:To:Cc;
	b=VcZpN2ttA7WHS2V+Rbxx3nWkPttnI5ALTKjxwTD6+vcfG9pBKGoTWccS9IjtnFkv/
	 UXjFWfS7bdf4Hr3BPQpH7aIoX/Se133u7KQu/8ijo5rceiKaKH9xYYvv16CLAIW0YG
	 uEuhZvNzy9rOptLOq8XITfLLoY3iiH8DxrHt+Mapi0x6oP7TiGsSOB1x7FKHQgHRAT
	 RhXQ6EklgzJjPGcDawETbD060FtxrHcxPFmmgFsumISY4lrNJ5NuRFuL9czMpQiWUf
	 n61rwZyvcSys27QH8fQsSTI1g7a6VYWMwlQCtql+wO9lhfkNp4QG91EnnNiR1KCweF
	 itPXRv4aZTqIQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 31 Aug 2026 14:42:11 +0100
Subject: [PATCH] mm/vmpressure: remove window size TODO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
X-B4-Tracking: v=1; b=H4sIALKElWoC/yXM3QqCQBDF8VeRuW5g3cw+XkW6MPdoE+jGjC6B+
 O5tefnjcP4rGVRgdCtWUiQxiVNGeSioe7bTAJaQTd752l2OJSvGmMBpfCvMFgXPMUT24VxXfeX
 d6dpSPue1l88/3Nx32/J4oZt/Ndq2LzYWcVt6AAAA
X-Change-ID: 20260831-remove-vmpressure-todo-2d764f42059a
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1841; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VA88Bb5/UdC8IRm7ZMkG/SfASBhEQ3tiVRi2aqbk8vU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmtmyduPsTs74q/8cJT7YcvndnmUxOxOXyKoULk5KsJ
 2SrfV/N3FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ2P1mZPji+kN86iruuFi1
 e1e3um4J8P8zjzk03bdgsp2M6cnz0u0M/2MFXkv2b5HjnKa278nb+eJs/WtmrE4rm/tldrJnt87
 x//wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 907134000B
X-Stat-Signature: ycsw8u5bmsdm8x7q9bmaxd4d1c5skfec
X-HE-Tag: 1788183755-750549
X-HE-Meta: U2FsdGVkX1/l0qSFtXspxW+GSwlmp+XbBOogoblg0O2CloKJBEOf/mzB+Pa30UHP08I+tOxs7F1PhkiPAylCzGa6wHyjeEbffg4JkKYEocg0PK4t2vo+/v/8bSChwy/9gkvQOK6fikhckR2qMXEEVuxkE9BTKmwCzgtnzQq+Zv4OImpRsJakn388c3jBYbeY50+J3008VY9uJj6dFiI4zu+UcJe3NGSzIJCXYCJA7J/pwXi/UEn062liBICwQXg3k6MBpwkic3jAN8ao15CriJMowuXpyqNcVssVa2mhm7Yzq5N+4YAuEyVxl4s0GsphZ7iynSaQ2VWAVieeaqkO00bhwh6wH8yUWVvruedTJn7baXIPvBh8Fr2jorVMJIWk+LBoOnBIHNRx0JXTfNYhHgSkajOO4pmAebgeDPAvidFzheCj/Fza0OAaw5+JTvo+2Pl+LmjUbVgOErYSGKqJRE868RVXj9O/UeIWVY8oEKGJBRQZomUtpQypsVhR1BTJOeqV7TIVaLoimlCt70may8O4gWrlwO+vkRKp8Nn2e/ehHR+52oDYypgcRlKcd3X43ZxI6vVe3TMnw3dWa3M/40Pa/cFVDISxdtten/cf3t76pYQCHJjQ0HL8W37dg3W/oxfrVKyps4ZWmIe29X0E5aG5eii+YlA24oTdMr2mf36m024kOrKJJJ+0dV2NfYD4rtJkZJoOz/bvzRHbbBebTmykFNw4GGpSgHtSFTrroGZCmLZSTntDPyTn9/6IqKQtbtUCiJHqlRSBz/YdDLxSykd0rle12zDpY6Bgmq9rntQ8LHXu4e33sg9hGgpBZsbd9egWjExf1MqtIr6sMmasPwNHhFAV46XqjNr79kfw06c4HeHcb2R8NWofSdhwfWxwwOgrxgbMU4Kf/5ZgNnVoxSRbhfeoptKFPFaaXOTGf/TnQvzmuwz88EB2X/n5flxtHOQspIueBKbf81E//26
 OB4xOeR/
 a2117s2FSPdEgEt5+k1ths5/YX7xOlfochmlDUpRdvwarwcrVyG8T2kMvdCnE+wxPcWRWC0X4POucOKjDHKXd/LHu5z8aHm5pgytRJsfdN13IJvytq4xCW9eT1vD2+UEX5/Pnf1Y3lzyolWNn1Zc3n+R9Q8wquaBcbg7T1hh4YevCKbOOj4ntIv4slN2Jk/MmqyNIbpdVGUhj2pRomjAg43G1s/t7D/tttuK6HLHgtXg8inzDTXhKe5nZsqrQLhtGkMILr9l7TgMCH0gg1LIrRODMX93Bilo7ijI0E+pf7VFSnFeC33azXxyJ8gO78irjFYTxwm6erjIIK2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There has been a steady stream of patches that have been submitted by
newcomers to core mm 'fixing' this TODO, with all but the original having
very likely been generated by LLMs.

It appears that TODOs to LLMs are like red rags to a bull.

In addition, TODOs in code often bitrot and are distracting - those who
understand the code know what could be improved in future.

Therefore remove the TODO.

The work required to actually fix this TODO requires somebody who both has
understanding of the code and significant real-world data to back their
changes.

Such a person doesn't require a TODO prompt to implement this change, so
nothing of value is being lost here.

Link: https://lore.kernel.org/all/20260831130316.448-1-tahasezer.is@gmail.com/
Link: https://lore.kernel.org/linux-mm/20260724054305.516126-1-cui.tao@linux.dev/
Link: https://lore.kernel.org/linux-mm/20260715143646.15828-1-gaikwad.dcg@gmail.com/
Link: https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmpressure.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 9629240d77ad..3de99fef3928 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -30,9 +30,6 @@
  *
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
- *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
 const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
 

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-remove-vmpressure-todo-2d764f42059a

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


