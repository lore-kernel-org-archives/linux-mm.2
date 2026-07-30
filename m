Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73745C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2B36B0088; Thu, 30 Jul 2026 11:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553676B008A; Thu, 30 Jul 2026 11:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469916B008C; Thu, 30 Jul 2026 11:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 208526B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:34:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97156C01D9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:34:04 +0000 (UTC)
X-FDA: 85045838808.03.5E4C706
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51FE5180007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:34:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of yijiangshan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yijiangshan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785425642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IznK4iHQnOgKhIOVLkz3mKcjYpanEe1lysninVZ6qA=;
	b=0sw8TtB9MI6aOo5/FK1LsLjbA7tLzJQz02K1E0TXJNSAVx7b3EfUb96ovNGVXeCQ7R2fwS
	dGcgKVauQwkVjHqfuQNQ0d/amcugRcNLLloo7+4r//Im9L4Ku1lr3GBDLwD92dORGN7zYs
	xnZY/fdFXsaFuIhCYFAGQ2Sqk3RBU9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785425642;
	b=5Ou79vtdmyFWz7vbcqQyXBUcOkFB20/iuDCyoWwRvqICABJr5ZT3bD9C8HfSOBoO+RQ3U4
	tb4LdicRtBeP7KY7bn5TFZUMwU7YswvcOcLMSkz/J9d09dr6TPNhbM5f9B4JtMfo8/2C6c
	SeHyLnCiSzvcfoMvl+l5Jpe4KvtX+iI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of yijiangshan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yijiangshan@kylinos.cn;
	dmarc=none
X-UUID: 0ef62b4c8c2c11f1aa26b74ffac11d73-20260730
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:96b88caf-118d-4b7f-add6-2ee005fb4489,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:187b35f85e45fd9b64e635d5100d5755,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|850|865|898,TC:nil,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ef62b4c8c2c11f1aa26b74ffac11d73-20260730
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 880560079; Thu, 30 Jul 2026 23:33:48 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: david@kernel.org
Cc: 13667453960@163.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	yijiangshan@kylinos.cn
Subject: Re: Re: [PATCH] selftests/mm: make libnuma-dependent tests optional
Date: Thu, 30 Jul 2026 23:33:44 +0800
Message-Id: <20260730153344.3149433-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <fdfdf7ac-8ef5-457a-ad9e-c92f6df33ab1@kernel.org>
References: <fdfdf7ac-8ef5-457a-ad9e-c92f6df33ab1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 51FE5180007
X-Stat-Signature: p9spbd9sfwufhqwjcq6d7gjc4wcdz7e6
X-HE-Tag: 1785425640-18743
X-HE-Meta: U2FsdGVkX1+oLgV1WT4227EbP6mc6yJzZmzaO5noyUs0P1EeUaKwDv5CLc0NPHN+7O5MQxi0u+XnUiinvzcXEq+eJ8wSdUfqDgkm4caacLfDEKjakx28ZfdZYUrn0k80l3ZN3myTMJcTlFwy2H0ib9B0N8hGpG1+Awqajhb78vA4lmfzFm2Qn/t1WD9FXduslHhZoBSWxyr7KRMCOd2MrSi/BsTwLS7i40f1NfKmApbTdlarc3Ca5ypDWs5+usGg2UfE4yDrZXfYDdv5K4R08LdurcTJctcaj71U92fRDNcLcBtnkVugP96V8A2KquSiflaaHTxGS5z/+tFzV/rZ5duQEgum/2smNqdaNnwwnlvjFLFAUs3kP95d+b5R794CdTgixfhkUxN85Axjo7G9WlzRdBmTxyjIY3bJEeIlipFAHxXzWur8lndj3txVaP8uq1wUDGFfrOM/ufvbnuE4rCuOhD+e7MVDR2v418aKSFtYLPdZ7TX6nOSSGOJapbaGutiXDHLo7+6lmtX62WyruFMQOZyWUwiMiBLZ0F+3ioAkeRZnuB8APX79r8ZO5+SclAyeG2qENwCM8k0BH992QGb73XV8Vt5QpfdUweUOSEuyaFG4NLhtQoDocp8Nm2/fQW8s7YcIfRGSmZARoafwYKBhLm4f/zj8bPtSFvAa35mDVczi7+Ua3uC0FM9XTq7RGxhG+mjSTEycvEXuP8rRAglv2JbaMWp5ueEaXS+nKvV5xSAJ1ou/uPV5AEmCN7ZVhrp7QRVZdQEDAIPGCnrb9lCo+SCyuLTLFecquBeqH7BgSNp/abvxIXp6mPreRr4uAtRH0vNqi4ydHEqJF5C68COkzVwi4BkA6vorg4X9CF9IJzGATbAyVA4e0yaxJULZ1eBmfXFgsNcE8B32Dp+9STHTU1VggbM9bgsjXFTYLEdvlDYMI9Baasi2lng3/T1lqe45uaa1z9hm/J7voHv
 9VBrOxzA
 3W6q1TxoKycf6bKh6fDsRmPPeEt+JO87S5/EGXmINee3xniE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for the review and the historical context — very helpful.

You're right that the situations aren't parallel: liburing was made optional
because it wasn't universally easy to obtain at the time, whereas libnuma is
well established and trivial to install on most setups. My cover letter leaned
too heavily on that analogy without articulating the actual motivation — my
mistake.

The scenario I'm trying to address is the *minimal container / cross-build*
one: some CI images and embedded build environments deliberately omit
libnuma-dev to keep the footprint small, or because the target has no NUMA
topology. There, `migration`, `ksm_tests`, and `rmap` fail at **compile** time
(`#include <numa.h>` not found), and `make` exits non-zero — so the CI step is
judged failed even though the dozens of NUMA-independent tests would build
fine. The goal isn't to spare users the install, but to stop a missing optional
library from failing the whole `make`.

That said, your comment makes me reconsider whether silent skipping is the
right policy for selftests. I'd be happy to switch to: keep the tests
enabled-by-default, but on missing libnuma print a clear notice ("install
libnuma-dev to enable NUMA-dependent tests") and continue building the rest,
rather than aborting. This stays closer to the "run as much as possible"
philosophy while still guiding the user to the missing dependency.

If neither direction is of interest, I'll drop the patch — no point adding
maintenance surface for a problem that isn't real in practice. But if the
minimal-container scenario resonates, I'll respin a v2 with proper motivation
in the commit message.

Thanks again for the patience.

Best regards,
Jiangshan Yi

