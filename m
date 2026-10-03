Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F94FCA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 03:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2686B008A; Fri,  2 Oct 2026 23:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52E66B008C; Fri,  2 Oct 2026 23:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41986B0092; Fri,  2 Oct 2026 23:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8146B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:13:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4930A790E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:13:17 +0000 (UTC)
X-FDA: 85279844034.22.C3A800B
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4363040007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:13:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U0QW/e+Z";
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790997196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lw3PuQ4xjxPUxFAVJLp4fgiRRTl9Tnn1Ve+gMsj5BIU=;
	b=LZSAzo4ea+Y7RpgSwBvAAH3h+Th69U/PtWutAHTu1ea6NQJQr5tQ3TZ3urQQqi8um+A6D4
	jxG61TdOlKQnsObquvL2YxCjQQTZrLrYpACthMEO76cmxR7PTfo51L6uZBwRvLdKOEymxp
	enJThCDQTCX3gxEYyckuTL106NmLD2s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790997196;
	b=6nizMmzgX9tLAQwzgCpG2GJQy0e/h8Siuu0kK5i9tjvDt9YDsl3EbTXQiAzd6375w4qAB4
	oDt4zMM24NbMwdIaKzltu9R5Og838OvyBd7GDQB1Qw0nDXmFLjOlMNYbMSiBTkVPIqcchq
	fqBrMisbclDhArqobUcywPuei3yNPxE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U0QW/e+Z";
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a+kpo4RTI73sNREzPUOPFUKRo2xgeedGd8FmVAtqOtU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790997189; v=1; x=1791601989;
 b=U0QW/e+ZRJPrY5CkUuANDzNlE2UrRxjzwb++LpzB+T5crj9TqK2olKSavX7CfzKYc0s/SuG3
 JWW+ttw5Q13SuJhnBeLkvnJfeb9+FZi9hGhfSp0OTpr/0pQH/pT9tbcNZUPBqsB9lUqqQi0OPtv
 8a2XE8hEZU0TLWHTLhgIUSTA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 60bba976d3c550d3;
	Sat, 03 Oct 2026 03:13:09 +0000
X-Mizu-Trace-ID: 60bba976d3c550d3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
Date: Sat,  3 Oct 2026 11:13:01 +0800
Message-ID: <20261003031301.48957-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
References: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4363040007
X-Stat-Signature: p5hosanhq4rkwky6gacc1d68rfj5qxdb
X-HE-Tag: 1790997195-22478
X-HE-Meta: U2FsdGVkX19Ap4/Ur0GtN55JXf4+SsJHpi1ys/0CSv+rtRGRYsh46aq82rxogrgkwC0jdNceT47urOFxxX91ATBDh6VDey3GOaXBbJ4+S/hynraXUq+tvgzf6HhHf+WFiUrWznYZaaM1xMq0m9l9S+2rvdbtlu/rEXXHcQVMu/jT5kXvgBND8yk0k/6kSPzmjICXSav88Em3p7hyB9ncm3um8CL31MeCPpMc4/TjKgYntvrpM4UVXmyesy84w9GSwyvaO90pDC0j7lUFUyn68i0sSuN/dORhTQ0klK+ze77QxS6UzfYR7njvkT8mfZI5NSJqLFoIYfdB6/vq7tkByoF9FHUKPu5pvU6sAgHieWW6r+vdqHgHdf916gLVpb5++DAMeZeg5W7P0KmVrzySlDYyMZoT7KfDa3Z0//+sNViQT84GBtzwV05by/6FAHTGogWV7u21oVUpQINpS5Cs5bhuiZbopPrhgqCmo4axa7OSZqzVPXtmFMMz70+m6LtZsQogq0Z7n8VdjceDbsQb+m0KDyKOdtzJJJc50r8xI5ZZUgdFmfy9xId8dnd68b3E57hrjgpE5Ei642hazb4BBWU5P3tz0soP1UYcp3f1hI4/ykV7Et0uDDphRGuOVxfU81QUpktBEQbV1JCA9LsCuGyH6xMQe5NW3zIzCQg6NziHiH1Y8mTjgwUxTghgIesl00C4Gy31fKCCB21fLrrWSpb5ZkIA9s1B4LHc5+1qH32rcMByA+ekKmrtq27QHnSjy/iyjuWJkImSLuXTflasaRsRU3FgE8r6DWlCn7uDMS+1JADduKb0paheEA1VlXs0aRYubsl/hF5z+1xbXDqtbRTrati7kRh58mRMyLTGhy+r2u9SqTuF20h2uvWjEJokxOOi3xSZmpSRS++GhS0UsUrOMfQQC0cO6694j9D3SQmEnsWbQ++Qet1vTWOwUieEuTbcqIzVZy7aAhAHkR2
 TlX0AoEN
 uobef+/U6oRYxQAtUQMN6vqffBH87FU0CNKT+62/G8qU0G6oKSlLLHhsAa7mnPWTc2pibPGy19zMcGQhYly/BZIMmY+Cn15bPXHi225U9kloJUipUZ2lejIwwNv4vVgJWsFVvQeCo19d0kb4WNRsBFHNa3HoILg3RUZWjKZNkndouTPYb+BJstKH5w4++1b64S+40507ZUmhoVT2BSdP8ppl86UQ7B8K1ibESF8wO6IM2nQ0IrtYHhz8Clh6Er0o3uEgP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 09:45:35PM -0400, Luiz Capitulino wrote:
>If PMD-sized pages are not supported on an architecture (ie. the
>arch implements arch_has_pmd_leaves() and it returns false) then the
>current code disables all THP, including mTHP.
>
>This commit fixes this by allowing mTHP to be always enabled for all
>archs. When PMD-sized pages are not supported, its sysfs entry won't be
>created and their mapping will be disallowed at page-fault time.
>
>Similarly, this commit implements the following changes for shmem in
>shmem_allowable_huge_orders():
>
> - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>   considered
> - Filter out PMD and PUD orders from allowable orders when
>   PMD-sized pages are not supported by the CPU

Nit: "and PUD" can go. 

David mentioned

"
There is no need to disable PUD-orders, as shmem does not support PUD-orders
(unlike DAX). So you can keep it simpler here.
"

in v4

https://lore.kernel.org/all/ff7bcd65-d444-4da1-890e-75504303ec3f@kernel.org/

Cheers, Lance

