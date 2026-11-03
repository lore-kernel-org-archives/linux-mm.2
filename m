Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46D9606D836
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYhaKxjT
Received: by kanga.kvack.org (Postfix)
	id D629B6B00EF; Tue,  3 Nov 2026 09:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D147C6B05B1; Tue,  3 Nov 2026 09:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C293F6B05B2; Tue,  3 Nov 2026 09:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A28206B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:10:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F26AA0447
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:10:08 +0000 (UTC)
X-FDA: 85393992096.25.267A617
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 873FF1C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:10:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYhaKxjT;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793715006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzg8QxS/frlrk57hvLDahMynox2KuT4SpVk1LZUW0TE=;
	b=pGyO4SyhbPanJDNkj7Mv52oSJCwUtTzq+7dK77oUtt0/YWszXCoT7sj0hP0bKZ8ufHdjFr
	daAzNmUG+kxbc8e+NAG+GekpZgxEtmCCIJHSI5U77/Ihp4es2rAB/v9uyiK3wusRVgENWN
	DQVNYldTrnU1rmM7HrR4JLS55Zy/6B4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYhaKxjT;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793715006;
	b=bUFgovx4/X6K1WdW+AXwsmhWNlvHXy8+zplBHI0H+7K+1QLTKhbSqPK9Jq22G+DtbMmFi6
	c8E3PcMl7vF44+kS3x0t1nbNLUtUm/pMbsIB+oX7Rs5vw3Q9mvSbKkhg0qC5W2bWAahwAi
	x3+Q9DnBeLViSe2/gJsZ34redO0Kegc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2F8E41166;
	Tue,  3 Nov 2026 14:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6821F000C1;
	Tue,  3 Nov 2026 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715005;
	bh=qzg8QxS/frlrk57hvLDahMynox2KuT4SpVk1LZUW0TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYhaKxjTGsgSF1PMtP9Gf1F86pV97/YQAze1GGUjGnXWkBFnXZK2xehoeEfPmzJOg
	 USZTxpFDj+mszdLE28PC+I8ZGzOr61vyVArCCUu3jehaqD9R3vorJrbf96S44NYHAM
	 2xs+INVT7guNgPWZuXUSXufObBs8J5RE5ZNUIQEBpMelI+cVrukICzVjIbv1oxMI+F
	 SjAOLIXCTaw3N80xQe1x1abSxVxXx36s2pOLUQqO3Dat3E9fuAnPD+WOFLCa/vCZF4
	 RBFNtDDSnU3xKWmkw72KUcgirP009qCstdh7psQZWr48PBiB4Qv80Sm9S5X99DY10+
	 OCK8d/k+PFWcg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 5/9] mm/damon/{p,v}addr: skip folios already on the migration target node
Date: Tue,  3 Nov 2026 06:09:57 -0800
Message-ID: <20261103140958.115634-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-6-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4paa7s678g9qmqynp19texoixyy4ae1r
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 873FF1C0002
X-HE-Tag: 1793715006-32976
X-HE-Meta: U2FsdGVkX19B9/MVeX1DY0rrR+a9o6Cq1pwm8otaNQ9hsLCrKxykXGb7AbggXSUBQQYKWeixBrDD6220lDBO7+W/i3RBqErC8LCb5c+xE8xJjbnxO8vqdy/t37D49PdKxWcF4CZsivnGgYXNsDwCygUcY0nIJi40L41YJa8SWA898mRpiv4FqI2nWcqUGM73RUf73jo6+tvvpOST97mzoLpeskxCcrolUGLgGWS8iVBk665h8L5dX7iQPuqjq1ro8beiRNYfbBObCGLSwJeF2/pcbz1eDL4X4y0DxVdGVYt9czJ67N+RyYsv03DS9soDqKOAwOvpXyt7g11lvfB0iWreskeT6NCXgy7HpB/xnj2V9pArnytLF9tJAVtZuMHdL7qqq1p3wX9i1+lCUXcCtmX3dD0lDyoqwq62LlqdKNCuUvrRQrWeZvF+c9nppq0P34HkAVa3rgzG9SBv34MEijigq1Umee9/DZKGjeke9hBC5u3wQ+SMvOpChe9AgEmOp2W4Nii3y9WCgNsIRWzDPgr5OWxBv4vaydUHB6ui7ZLkq0UMw7fo89sH/+UacDfx3Ms8aEVnsVeG6luiVL+9UNC4DKBRt1NWMKGn9sch02aQ49iYZVRdjPM8hnxMI0sDcohZwZ0R9jl7YF8Hlm0pU0a0vYihDzWXiO4T6Inz7JhP05dQ1/FkmagmvVmo4oe6ancqa9kELu8aVrLG6HDVUWiDcqVFys5yCuI1ccur0cpEFwwuJhOvrBPiGZK/d+cwWxT0wZjoKvt+owfLAEqiXK2GN2ew8CDH4ogBWsZtIoxONlQII4VGIXAZean93ldPduiFcCluFjzYdYl9r2ZRJZ0kxAFCIpihs+F6le7WEXtZPj5wsCLQaSVl375j/k5R+V04623nbMbxSIpE1XRMmBKIT3L1xzzlFxkXE8Tn60Nyg8PxcQuTMNAX3muZ1QxHhjeL9ytX2Od1ixXz7YT
 rO9hxZGP
 Ixyr+0vCy1KKoPP1Y5zPOrNVTAGnfVKCdxsbsrlxjrFSUORX6O3Bd3f6wwIaMLz7bS7/2aw8t3tUMX1diz0YOtbyAQ7RTpF/MXs8RR/e9UKItej43vtJrbpQESx4t2tn+R9Fbwi5Mo1ENrjoDrXM87NY8g5Kk/TB2tQB3jGfwn3/juY7yooRQz7lFY1DrBCtaUCgxIB+7m/VaEwFDg2fi8C/ekvyyp/LakUtV7WiG3W89mZkT+5WKbkwF1532YDw7p4Ub
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon,  2 Nov 2026 07:07:52 -0800 SJ Park <sj@kernel.org> wrote:

> From: Aveline Noir <jm5905938@gmail.com>
> 
> While measuring DAMOS migration overhead, I found that the target_nid
> path isolates folios already on the target node, then puts them back on
> the LRU without migrating them.
> 
> Skip them before isolation in vaddr and paddr, as the vaddr explicit
> destinations path already does.
> 
> In a synthetic same-node fvaddr test on a two-node x86-64 KVM guest (8
> interleaved runs per kernel), guest-kernel cycles fell by about 29% with
> 4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU time fell
> by about 76% with 16 MiB regions, with no clear change with 4 KiB
> regions.
> 
> Cc: Bijan Tabatabai <bijan311@gmail.com>
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Somehow I dropped my R-b, sorry.  Andrew, could you please add below?

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

