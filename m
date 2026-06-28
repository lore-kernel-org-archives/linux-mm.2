Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07251C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E376B0005; Sun, 28 Jun 2026 17:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF106B0088; Sun, 28 Jun 2026 17:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71166B008A; Sun, 28 Jun 2026 17:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFE86B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:42:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E5C4140486
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:42:15 +0000 (UTC)
X-FDA: 84930645030.09.CC42496
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72299C0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:42:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzQP8hnP;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782682933;
	b=c5FnbDbTZiye+jdJ+RonBmoSqeJNBEEPSu08I5A6rF6sl4BtUwM4eLYq+Kxjy+Jz3TEPC0
	d2rz0ysaOtz2QMOeEZsv6dpjmE7+MhDGY0vtJTuAcLKRGM/CZxYhywvTtZC+rIIIcsLkYt
	U/KIsOBhnUPlhN4r8hrCu9CHDMUlXIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782682933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbdMQQtZX/wQMqAhMHFL3ANnWsMXWow+5Kt3DUx2tcM=;
	b=ZJnSJNrO8wWsAAXT28w2C5tujxlPucasOPRoffsMH6hkYlO3T1pcaTe2v8F+PU1mcLhwXE
	5VAL/iVF8UEqqY72e8WdF5e51P0xEPPN0Bf1ae8bkJ+80PwroMJxvqp0s5QXogLQ2P+3pT
	HrZPvlF1f+cuuRq21NQRYu17GSHlt7k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzQP8hnP;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5E906001D
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338D41F000E9;
	Sun, 28 Jun 2026 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782682932;
	bh=EbdMQQtZX/wQMqAhMHFL3ANnWsMXWow+5Kt3DUx2tcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzQP8hnP9w8tQjAlNhhCeNJYVMnTumfbEguSTvHdROlE3x2ub3H8uev+FllmpXJeS
	 oPo2iWuJKX6ISqKynapiZz6QoeBPP4NZD0gm5+iqS4JWa5iaRtT//0im6OL1xEaoDK
	 33iz663ery6mQiUmLZSH+tcf5X0vgl9juP3G2kI9qzRNzOk5PiXJ199LNZwA5gWy/N
	 2PhfWqdBjRrs74m7xEZ2YN3U6w6USTiQZEfPmTw09Ipd8GiHthMFYzDVYoXotO4q0C
	 l0AU/vgxJjIoEmkqN731PVuP4oFOgIw4P13A8e/XLn9oI/mlPD46eUhjyBzX7FOVgs
	 5SxIVvR4BkfFA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: DAMON Release Newsletter for v7.2-rc1
Date: Sun, 28 Jun 2026 14:42:08 -0700
Message-ID: <20260628214208.94619-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628211904.94361-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3gu3auizmasw61nmxqbayf6e5o8npihh
X-Rspamd-Queue-Id: 72299C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782682933-752796
X-HE-Meta: U2FsdGVkX1804D0SKX9htiIaxtxiq3VMEQTRP3K4XK8ihnrvhF0NvWWv9Q9fAvrhdVOGNOaq1AjVIALVWVWg3BX+RPhVt9s5DsTEpvTDR+gWOffK+x3EuyGwiOSHvIsXQXIyvXg9gYQswsoQpx57VUApmwT1hq9GZ4TXWhV4+P0YNfTUqxaukat3B5eJhvtfWPY0xgfdvRuhPXwHNFZR7yB+k6zzRfVcz6NiOZUCtSpMVukacCzKhQ9eCq4SZGkE+M1eSi0MGpRp+c6CgwdY9sQW6Y5dg0NyZ3snMhACdolmYLItF+moRaECY4bAkcVB+H6NqdqwsuP8bXTePaDPrI8bI3PpQPC8PrjBD3hxgb16xLoYuI5UgbLqyeSxRh4/SGEwHV+/nxpr0SzNyOjY9akcWVO/ELjKOfDV4dvFDy5nL2VjQhtp5jXrITrkAkrHdyYYAUVgfKurnIUaNrCGSxH4GDUvWmSMiC8nZCiHX+LA9l1thZV3M+4pNNs2O36+QOWCmmxDqpTFuI3yRFM2xBZaaIFYEhg4oOcUC+u0JR5W6ta4L/aS0d1t8++Dy8/I9oLTG0//qq0uhoEsLpumXYXPG0x12Bq9CNRZJru1JoiTWqWyfMnONBtxdcgNNmwnVtNt+hPXnjgsZ+S66dLN8HC6GelmJ3r5ZT62sbaUuENDXnV4bcmJ8FkI8ZIA87fTglFS0im2izTm63yK+uAy6saMITmfRFGnQDEikkNJgzpWO6sKFa9rbRoGyPVPNcHhUc+dl75sv++QpqS3L9DGrpQ9yU/wGABB4m4iRXLi5noFLFUGWFrkjUOnTHxVkMM0CLrZVw+TFAiUT5Ubp/AxemckValn/R8yoSTeKHHCEMYJ5On0Nby79yxykXItifPzC2HVE+YrCUxaBzndTcRwKfyPqwOfIY8DaS9vH8SuiC132OfMhLco73SxckeIDyrTnpXZlJjue/umT0UYmqn
 3E5shx/C
 QuJtsp1Bvkow9AHijV54lV9rt8VzhDXgIpwtaeCTayL0Hhn2U1JUCetQNkTrCumE9QJEvcN2X4nVxYCXKftiQV7NfF+rheisUaf2JXEdNGzqvMKcOjszPxbROaXZ3wAZScbul8jKeKmq5zaMY3cG5SDJKs7KpSKIVkvOezYyXOHo9/pwur6qqOg789GJ9WLkBO1ReQjdM7xYwku/GHNfP0wz74Tn4jj+wWJdP7C4xBzygGYpm9yNJ0c9Vv3bXAPxyiSFsxJGFg7loVkYlitqWaFHM2oVjonRN0NMq2Y+GoRCWioQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 14:19:03 -0700 SJ Park <sj@kernel.org> wrote:

> Hello community,
> 
> 
> This newsletter covers DAMON features that landed on the mainline, queued for
> the mainline, development statistics and misc events that were interesting to
> me that happened in v7.1-rc1..v7.2-rc1 time period (2026-04-26..2026-06-28).
> 
> The newsletter covering the previous release cycle (v7.0-rc1..v7.1-rc1) is
> also available [1].
> 
> TLDR
> ====
> 
> The last development cycle for DAMON was the busiest cycle of its mainline
> history (~6 years, since 2021 September).  12 Authors landed 106 DAMON patches

s/6 years/5 years/

Sorry, I'm definitely not good at counting.  Sometimes even worse than LLM.

> for a number of changes including 7 new features on the mainline.  A roadmap
> for extending DAMON to utilize AMD IBS, Intel PEBS like h/w features and do
> per-CPUs/threads/reads/writes monitoring is made.
[...]
> The 6.17 development cycle was the busiest DAMON development cycle in history
> (~6 years since 5.15).  This cycle broke the record.

s/6 years/5 years/


Thanks,
SJ

[...]

