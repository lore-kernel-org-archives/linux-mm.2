Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C747C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002666B0005; Sun, 12 Jul 2026 13:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA576B0088; Sun, 12 Jul 2026 13:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D286B008A; Sun, 12 Jul 2026 13:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B61486B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:23:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D059169E63
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:23:41 +0000 (UTC)
X-FDA: 84980796642.09.DBC39C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BFD0C0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:23:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJKVgeN3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783877019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erlvsdImMPOzbt0J1t9Lju9UV9yCJY2fVSin6DJP3CM=;
	b=h8DhNg0XKx2+z1sjZox538MID2r13zJ4BW7wv8Tvop9hplj1S844QN0UihhTO5MaZb84HI
	m4A6k1P7n6qGq+Tp4dSGi6O934x3VaI3AgdPzko5naDv6ggLl5R5eIvvuIVPFpEgUqpmp3
	9OxIG5Vr8yBdqPk0t09HqMWYgw7rYhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJKVgeN3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783877019;
	b=T7rF/MxsoULxHQI40g825ALys8vXXoEPogUp3OhP2icpnh0wmIOcQmgc+BzaP8zY/hDvT/
	odLeyTXmTHNYym8uZAt8AchHhl+RlnmMHFMnWR0bRr93p1kcPu3EFpjzpxMS8dxdTBeqxz
	7croTN/eX0M+yikpQjp9WUTPEANVHWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C3DE6004E;
	Sun, 12 Jul 2026 17:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B51F000E9;
	Sun, 12 Jul 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783877018;
	bh=erlvsdImMPOzbt0J1t9Lju9UV9yCJY2fVSin6DJP3CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJKVgeN3+Qn9GQFaBZQs61WHX/XKRIQzg+VY+N85N3T4lXGBLDHUw6/kFxaqHeTDt
	 hSjbJ90rPOVOp/1M/6hIflDQN76PPxSyWqZO26rX6kvVtXrkviX6esW3Ecq/mKDDLn
	 cak6LKA9nGH4Tv0CmidCuQGTFUSRm9puODoduSJpRCxbrrX+RTjitGDi/WMLLSd1hZ
	 cGY0KNWr9a1qrorOJixlRykl4c5vVDjPs/yRFLYC8j0M6Nh1eh9HfMllpE2+979jlM
	 zfRtDJ7ZASjMRh/bLGJyhfboi66TXhAI8LRbPq7B0TJIJ7V6uU+4wbZKE57By28zEr
	 22ICvS1YigYNw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: skip aging from repeated aggressive merging
Date: Sun, 12 Jul 2026 10:23:34 -0700
Message-ID: <20260712172335.92448-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712165432.87609-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BFD0C0005
X-Stat-Signature: 99h4rq1pu5s14c5tyc6d9hxa8aqsyhn1
X-HE-Tag: 1783877019-474266
X-HE-Meta: U2FsdGVkX18SWWR07jpRbUof/8LosBUuzCY9DF54npoYJ6ABHO/lynOB1tVc3SNt8GfoAhovKLBkkH6J3sZ/0ucwaI5Fzl/CN91+aSvDO/fHBLz6xt6af7qWBhwcgrq6qFZ9ur07yK4O1+ziAhEIaP3Ygfmy8aWX7rU1Kf/9IsBVbGywuXbaNWun6kBBws28z4U7/mMbDIk/pN2RPfjPbBdFVVPWkY5LYANMCoCdRVkkdOQD9R31KMgShcQeXWGU2RCnXxqRn7haElJUjpHVyTnIjrcNui6EBQFMSNRnWTdV2yv288keabswfsykUe0XPItibA25VZHtaG/Al8xqF0EHTxibYfZiNb15G7+Nlo3dqxL2yr288+x+FgA/RXQVtwuzFMeClwgocPcCDZMVlE8a/W2o/4ovgt7ShZcpDOINmBt6eNfM8JCX6k0zl7A2dMTYOa6KEvUkrO07h5sEi9LNnRpGBwuhf5htxAMQG8xH6Sg9iNCwjrdLkfKtAg1x9sWCKgeOIzFtq+n3kGkCbyXpNOqF5u5Jn0I+N2WplXXQ0vNj47YwxClC+DJR0kRcDpo2MpHQeS7YNhLxOG72TYttyCissi48aJHPUMemhy9WA+GjIHfP3wzlIl9pIxdo8ltYo6Me2fQSI/dkQBdjSfTbuYjF8SQbd0vADRBPYsitb1weXXFhkHC48YoRtX9bdFdX5HrVESgUTzfSGCEt74vAmnFQEeUSZJCJWJbCfWUAdHP08O6sgu76oYnCMHcBmcEV8l1whk+Py26Tr1dcSi/31fH470TkzESz2fZpnPsKAM57qHmODdOCHlUu/n7/Vtoy8YRonAGbF4pscZxkUZNzbfgTqFMCAO/ZTUyRNbBlb8c/rSxjY0Df0tLnDQuOudp2KBErPnqZQSIeGm3fV0CA3lnMXRjeaJie2WYAGPXFIGzzEKGekhopcSW3DUo1/EP4MXz1N7gf60tTRdu
 syLEsKyT
 UMqz6r2O/ulE1EHYKN/ST5Bg4iHZvt1nHHLCq0EFtX7Kk67nv52c33oaPcTSdueYndJQvkIGmQPiOh7QWHdzpnxnW6qALzAHey21kWcA+y7HokdPBsr+e9awykOVoFQCSCrGOyyOM0km4SIF0IUfVUo1TMWuoaYKfbo8vLNuRWX8XciCslyfsxH0gQUFB2lwSswxpfclTPup9vtJav5wI0AgGtdwRg10LvbggHLYgLhK7m6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Jul 2026 09:54:30 -0700 SJ Park <sj@kernel.org> wrote:

> The number of DAMON regions could temporarily exceed the user-defined
> maximum number of regions limit for corner cases.  For example, users
> could lower the limit via runtime parameters update.  For such a case,
> kdamond_merge_regions() repeats merging regions in the case doubling the
> merge threshold.  The repeated merge operation could update the age of
> regions multiple times.  This corrupts the monitoring results.  Fix the
> issue by asking the merge operation to skip aging for the corner case.
> 
> The user impact is degradation of the monitoring quality.  The impact
> should be mild, since the degradation is only temporal, and it is not
> common to happen in realistic setups.

Sashiko found no blocker for this patch.  Sashiko sent findings to damon@
mailing list [1], and I replied.  Please read those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

