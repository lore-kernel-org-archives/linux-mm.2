Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9574BC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBD96B007B; Tue, 28 Jul 2026 08:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D726B008A; Tue, 28 Jul 2026 08:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BA96B008C; Tue, 28 Jul 2026 08:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF4426B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:06:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D5F98035D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:14 +0000 (UTC)
X-FDA: 85038057468.26.4770EC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A283020012
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq88gclT;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240372;
	b=7Ni7P3d7TEtvD6AvFNYjznAyD+1rUf2qJvGguRGPHCp3TZTMq0mYcV+ppp4Dcze46mI3ym
	euo3JLkfecCeXuSTqxQ6WaW8vGvsqiQEFfahvSxLdjJCLJFRm+vSTXuXVN61SBU33RZXNq
	yOCLE/PZ0eMWNz0sEEIiaD1O5mzUYf0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq88gclT;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=utjVBhbZuqYLFro69FeNoLP7coVedkrv95kY4LIv95s=;
	b=ZtjGml/ZFjyvwGOIKbD87bPg/jlxYCs0oXh0QDy7YaHILprXyCtRAE12AJbGNixPHe537g
	8Af/IskY/yBTeVc+kGAhCbpp6KKzhNuZ+WSiZZpocmYRU9kSOVK8x5AuE3zEfXYWrUlrai
	OXYSKg7xVzGv+/7jw/W72LiNIWFNO7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 666DE41FC3;
	Tue, 28 Jul 2026 12:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DE91F000E9;
	Tue, 28 Jul 2026 12:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785240371;
	bh=utjVBhbZuqYLFro69FeNoLP7coVedkrv95kY4LIv95s=;
	h=From:Subject:Date:To:Cc;
	b=Oq88gclT4KvJyLnpoLcLM/OQkXLQRJTwu08ZSLC1AERu8MUMHfYCOwEy0yhXqTwGr
	 3hhunOZcngO3vhYrNPohYMXXH2TLCDMQ5JGf+jEX3rsQH+yl/MAkKg91ZTIZSreEvQ
	 DcXOQi964ll7aS8TlZDOtjWCtjpPPV6Oksjnzyx+a/jFHqSPkg7QU4gslj+XVGn+4j
	 pnX3IS+r2cxUwKbgC9lfq/jibv3kI81cTH16KJgHp/tp8GJAkCBdr1xhpgXApDPms5
	 U/CK1Bo7mouAzyrvi14Un5LQ0147KATZc82A99nUYKMSgEgeA1mnBv5vbAW8R7kBSq
	 VeG7Oi8U0CXEg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH mm-hotfixes 0/2] mm/huge_memory: fix huge_zero_pfn race
Date: Tue, 28 Jul 2026 13:05:43 +0100
Message-Id: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABebaGoC/yWMywqDMBBFf0Vm3YGYllr6K9KFiRMzgonkUaTiv
 3dal4d77tkhU2LK8Gx2SPTmzDEItJcGrB/CRMijMGil76rTD3S8YSJnYw2FRvRVlA+liLq1RnX
 m5oYrgdxXsXj7p3tYFvSxnPw6x1zNTLb84nAcX22LjvuJAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1751; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1iRX8kwEWPFZ/gPBRMQWQ6bqUokZs9NDs71srGyCKHM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIyZiv5P81KUQzfX27YtHf1/kXnIp7xOkfoOL5L/9Wyz
 4Hn91bnjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkvDUjQ0vRRakf3DnuqvVW
 K3j0zr59z7+iyskxpIDD/kVL9empbxkZji1Z6rcjmc38r8dTD6F2zwU1y5n5TjTJ/blWY6D8uDa
 IFwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A283020012
X-Stat-Signature: zzbzaqr4h9ohypk6n7cadr4hfbz831rw
X-Rspam-User: 
X-HE-Tag: 1785240372-816852
X-HE-Meta: U2FsdGVkX1+Fmp9puf7yQkcVK9zYetJdEPNtEG4lC4n+ZN1gNCT0UBsG0ofAB1Jn1ld+9NTYZM//Sio+jrsjTN30x2Ex/eQMdGQcudGTm0xyYFXIJ9NCvGkcebJ/ocPfLIRalqrFWrbJe2wbGp69Dh8/XcalJo97JTormXg/u32TvIBKFu36AAWRYTYrOSH9EofXDeso0SBgrafd8wPzhyw9vueWQk0mueJ93lHrDVV5+IQj9qhkq/M5fgQ0xMLeqWbD4p0gVMG6iNjOAkAIpwO7a1+wv4YmRwyc5oQBOfOiLhdrOqS2ocRuy7Gq/oKsgMeKVeFZk1Zz+i33rWFUs8PShPepidhGhT3fYKz89qZfw/gwlFX6IWrTHFmlPEaRm1G0acu2iatugNl4Zp3xIMVDt74lEXbcMbEAdoJRfJXVQmyANJfOsZ4sQON1I25h7dFlTzLBSb+Y0ax/7v1cWQ6TsLf9E6b2SvQqc3hmNFZ3zIx9rj+u4EiNPhJFnt5Hq+ga3EaMiWfxb7hocrH9gm6/kIo0qAkvMtWIPyCqjjf5WUSih0YioslXPOJSRVt78pvs8/r08oxlchpGAzbpmevE9YmvB0P0vayVraCRO5L/w5gqxW/y4YOWVETHbcxgRcI/f4WBEz6zxeTe9W7iAnLMpd7g+MDYN0pnKrKWxssvjbze3K7Kjtt4KNWGOAhDxLH5nQYpHA9D2/vcDKjjXM779/wVuCgZPupL4ztUxTDoMec2fDZByj7NyL4lkfz+9mGg9dVeNp+yRj4tA+odfErsxC6HCKULhvoPJv/iUogjBe2v/9GbpJ4RWMtx+BjpBC2GXFNI0RhUlAcv7ib8Ui92xOfTxoeSsZmUtXB7h6oqqw3450QAWIBY/2RXvxMo87nZT2u1v4LcKofOZ14mCUB2qqTPCiHvuIR+eYIBzPC0M9CNBDtd2yV87TYWNgKFsceV/xdCvKVfmu9ACrO
 PYhwKAYk
 2ic7m8bFHY1dTIJ2zpsKYy26MtemyF29gPiQso3aW0UI2RsQRrjKaPW1dEb1MSa89fNYCNcNI2OyFKHuXaSaPtOcOHFq8Ti0Z7POw0SMcdhdPiqDCPcG/H/kahGq7qLJvsEB8MLXW77Defj4OYM1QD+obC2hDjFN5r7YJ/f5DaWNlaQKzlTtuCD5wA6Kf1068/VquyDLrN3NnT1K/e3Ij+++uPbKaH1EOIKEf0GnkpvEtixUzrwZKE58BuQWM3GZH7CBe9IaUURx/Gnb9x9TJnHksaXYHe9XqnzP+
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

As a result, this series first reworks the
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic so it is separated from the
refcounted code in order to make the subsequent fix reasonably
understandable.

The second commit fixes the issue by introducing a spinlock around
huge_zero_[pfn, folio, refcount] write, with careful consideration paid to
load/store ordering in the fast path.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (2):
      mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
      mm/huge_memory: fix huge_zero_pfn race

 mm/huge_memory.c | 189 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 116 insertions(+), 73 deletions(-)
---
base-commit: 5db85e34ec49beee590676d55f13e8e2b14c742f
change-id: 20260728-fix-refcounted-huge-zero-21cb07b4fa3e

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


