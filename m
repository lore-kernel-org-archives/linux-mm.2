Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FACD606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDc23IAN
Received: by kanga.kvack.org (Postfix)
	id 777F06B05B4; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7287F6B05B5; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0C66B05BD; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280DE6B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC42214026C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:21 +0000 (UTC)
X-FDA: 85446348162.16.334B755
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A4D1340005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDc23IAN;
	spf=pass (imf11.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794961579;
	b=Pe8LxrEhYVNfhyk2h7CIe2q3N5PO2PjoEeo9PO/kDwzmBdetD5ooIMiHlrDRNPTlNrhwkg
	VwiYJmD/h/GH9ezVSz+1ySdt+ylkmhWhunV7pBOiCPRmY+eAwi5nLWbdwYJa7qE0IKM6mT
	xJ1BnuOIXbvkxunguxGVgsx8TZplgtI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDc23IAN;
	spf=pass (imf11.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYtG6DGXwBzTTL55vHMHEJqWnxHnMS2plSXaGsf2ruA=;
	b=Wg1zU0ULXFV3PLAhvDVqiHv4+rSEK/AU2sW0I+m4XOPVbUDQf4lDLEDicE90uPK2faRTt1
	ESFwObURl1dv1P2wp87DEvawcCxPSFk4DC1VCKCh2d+wuclEuVyClZX6z5zuiM1Z9LR20g
	3SqmhFx6RzarNj0aiHWzr0MaT1vptkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 333EB61E54;
	Wed, 18 Nov 2026 00:26:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794961578;
	b=MdTQPEr2+z7Kd2bCXAKxxMWNxFX4pYlMxXa3nvVxPBRcXwgRKpv0LrslIXc6kQnDoaV8
	 YUiyOo/22tnhNSNOnGvAhzSe1HWemFvYJ1MvuXcR8WFThCc4OUj3F41dUz3TV0YBQJH7v
	 MhPi1gTv3kh9THGl4S415/XsfN13xjFleyxmnf+4rSfU1kemqJXmzia3tOORVPykr1SmY
	 15Pa5ieOAM1z0c3SjaAS5jvoFbgl+TpYOKosI2leMsViTZ0AU3VsfP4Mhp/+6eKwMnVF5
	 ouBxqo04VvSd/RXqCw1yellGs59AzGRxTcCkQYV4QeKk1IMofwPM5XYJ7vO/Yg5/57w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794961578;
	h=DKIM-Signature:Received:From:Date:Subject:To:Cc:Message-Id:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VYtG6DGXwBzTTL55vHMHEJqWnxHnMS2plSXaGsf2ruA=;
	b=aHrhD9Gz7gvsS9La1TLIwmAP4I2oqmxapiqGXpeYmvQuS74Ls23NhSstWS52H/D73RdJ
	 jPD6pdCVcY3OmmZCXqAL8ZUx4i4xb9wINQyeJv8sIP3T5W4zwJYqzNVxDy96fU3Qqu6L2
	 ePRACaZmeOxdhuVX5cxuM9R3IOoYLUADb/i1oXC9VWekQCqzWKeF0LN5+jTiuMmJEbDWB
	 MXaWZiTY8WLpBPZIT+Uziwo49umzSHrf0A+F6exx7WMUgW4o/yl02BQzjX+TLY5l5siQp
	 9LJEaEbbl1NUhtbZxCyvddgTJDe5VWKgIlAUuq9ID5DgukV5Dawo7wjGMxDEKbeIguw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 510F91F000C5;
	Wed, 18 Nov 2026 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961578;
	bh=VYtG6DGXwBzTTL55vHMHEJqWnxHnMS2plSXaGsf2ruA=;
	h=From:Date:Subject:To:Cc:In-Reply-To:References:Reply-To;
	b=oDc23IANf0Hl5efMJ71Ivbc8Z33+vK0Zo3PBJjNaEhZk0p2WwLFvGcENFK4isv/NX
	 7tAZFYjwSUQ4Re9wh2Zu350E2B7J2eIGSsG+bL/7H9nfAmbiEV9g4fy7ZiFB7RYwYr
	 pFwSAknGAvAN+9Pu9gKPeyZ45w34kIcg69t3FkbbfOphGKT8f6R71T7RXOocA6WzoH
	 KBsYDDOK5ugoeMvgHSKsNvI4DRrz6EMBqYGwHFWgNqIL5PVpz8m1sR3k/nV7R1BMhK
	 g5tAV0XLJt+78W7kSimP7dzrI+81tKNf/8K3BEwWvsY6QO71sV0OjdojDu9itRlC1V
	 iss7D+3ButE/A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D0C334AB72;
	Wed, 18 Nov 2026 00:26:17 +0000 (UTC)
From: Matthew Salsamendi via B4 Relay <devnull+matthewsalsamendi.gmail.com@kernel.org>
Date: Tue, 17 Nov 2026 16:26:17 -0800
Subject: [PATCH v2 1/2] fs/proc/task_mmu: reset walk_end before each
 pagemap walk
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, matthewsalsamendi@gmail.com, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <20261118-pagemap-walk-end-v2-1-94cd92d838b3@gmail.com>
In-Reply-To: <20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com>
References: <20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com>
X-Mailer: b4 0.16.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794961577; l=1428;
 i=matthewsalsamendi@gmail.com; s=b4-kernel-20261117;
 h=from:subject:message-id;
 bh=7qGs2hd6Xj+UHbWpzY0D12fJy01dF02sQB04QPCEhTs=;
 b=Mc9ZX82EqhXsHrPuC5JbOue8KSUJJJe+aeJNlnoQt1oDt7qh63ZBSqkMCdmrEMHJu/jJe1kqN
 yPXCwPuokCXCNL51/tvJiRSpZrCbS+ZSW/xH8TYix1x9mLmSaQ/5PNB
X-Developer-Key: i=matthewsalsamendi@gmail.com; a=ed25519;
 pk=K4Lg4pTU46IL2CPz2Nb/u30nsnWJ38MlR2/Co4n0tto=
X-Endpoint-Received: by B4 Relay for
 matthewsalsamendi@gmail.com/b4-kernel-20261117 with auth_id=1555
X-Original-From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Reply-To: matthewsalsamendi@gmail.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6aenf8m16h4d69f5ktpshk5cihschij4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4D1340005
X-HE-Tag: 1794961579-952834
X-HE-Meta: U2FsdGVkX18DtsbzvjiCEn+6OMgY+7MEcvj/7hAVCCeElStmc076SGPe257EW+XNBNCKEN38eM6D5L6kMF7C8KamV7I4Bpnh31rrzAUoiFvdKu3JyJeWACvu84Box4eK3nOToMwzMhGBy7xmfvQdsIEicyhlKRIorZxiVtx90HpaYTH/Ju7av/CeTn97xkKD4IjINxMS383x8PmScjYvd3ekE4OIgs4eRFTMRm/WwOFW7SR/ePKQCEpGhy47j7UgqZ2e3QP0R01rnkc+bfzG9D2RKNYAaLAQLMeliBboK6OrZ1jhxALFZgCygRgYWChptBFTRwj64kkJ8OSF+TWDOO9qbfL5amTBlf5h6XQg4ZO7C6Pn9tM4LdzGEdOjC0+g+lC/0/KFQi00M5ngEltgYZnNJTXjYRqyUxz0rY0EnyeJ54E1WpAMj1UedYR6w3KxVOnDNyG7/30uB7Du6BVOQJLBu9kL8xu2+s0dfVqIkTRsMeLDp7GU0A4YKaB4aPblYwL87xvUzMPYfZ2Yr3cNjduYEb9UejCW+JayK4KoID7LvqjhrPpodshUgV31p2udp6TsVSUXM+PgiOY3I6t5iRhqV380nsuiVF+OUmtMUHVsAynW7j11MMB5V7FT3IT5U9GGMGBmWhHzX/T9ZkTzymCHnH+GaTkkXXgWq6GT+iFN1hxPI+WO7m+CKIrwKTA6QIjb9srC+dDvVJxE3Lyca29WwIyfcsH9Dw9/mNSko+ef7pf7Jambu1fpTm7LB6RkEYS6K8hYT8BpfC6NEVIfp3LH9UQF579pI1i5rJ+vuh9N4Cg64nlQ1mSKboyTpB6RrUFrDogBenc3kgOIXgUAG5RLEXKzOi0UhW1iMQCnc/2ELiJKeGoLYixL+jxsppkkNraKQ/fTXmVIUBEjF7GRRccfM0NMd1LRkCcgeXxd75tJhxwaWUTqPiWnPILmjLOPOtrxdcLa261IbGYubSa
 niJUqo/Y
 ygBkZjWvpqwVkdqfjouPkdDAwU54apRhv3OnKPqtXS1tuYskCygd2XokAwolxo9rVD3Gq+/JM1g6SuquZGYQIzpOd+8mxFjr8/mwodhA6Q0CVoeqUNoXuuVLreeDTA2lvsr9ehcbwkt6qVEdQ1ta3MfzX76+af8h4v1rBYv0BYWee9u10EbiF58QGQ7EveH7vN7Qhnr5IqKLjd0+/FVAPSZhoRUM7PwOpkh+Wu9t8a8H7YidL0w21B+f+8cFQRI5TcVsvcee/lLLEwjt2C1gKQKMs9ITtv011DJ9+J67iqPpvjUy8EIn2h0x4OarKpuDlxU6pRVrUdBOfnlEY+vOgHV77GqG1XgIB2ln39v4JzPChfUC13nxbwudQgP1CKaYIVG5MHSvJ1fFWlx8IclQ0DNGZ34Em1c82jRFKwKbo41vUI38jSxX+R603BDoQebwkvCxLO9QAfJmWUqI65o8vAK0dOMFeP3JHKMEvlYkg42t0yyOyEBI3bZuXIcMGfVyYty2csAIXh75hlG667vyeB/Ths+otKew2jle4PXp72/0lxSYKxPFvgR4QnX2E7SWAaAo3KQfbIhcisTv2clSmPePLzUN4FBtST+J1znegRQ7XTAjRG+waugmzJi9Ix75SA0aUI1pxbXAD+no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matthew Salsamendi <matthewsalsamendi@gmail.com>

When PAGEMAP_SCAN resumes after filling its buffer, it can return ranges
beyond a stale walk_end. This aborts a production game server during
dirty-page tracking.

Reset walk_end before each walk so a completed scan reports the end and
a partial HugeTLB write-protect request keeps its retry address.

Codex assisted with diagnosis, validation and this message.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Suggested-by: Chris Down <chris@chrisdown.name>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Matthew Salsamendi <matthewsalsamendi@gmail.com>
---
v2: Use the per-walk reset suggested by Chris and Lorenzo.
    Verified the 513-range refill and 2 MiB HugeTLB retry on x86-64.

Stable: The bug is present in v6.7. The hunk needs a context adjustment
on v6.7 and applies unchanged to v6.8.

 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b87d3e86442d..8723ffbff77c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3155,6 +3155,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
+		p.arg.walk_end = 0; /* Reset partial walks. */
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);
 



