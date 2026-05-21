Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE105CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 18:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C2A6B008A; Thu, 21 May 2026 14:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00466B008C; Thu, 21 May 2026 14:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0E26B0092; Thu, 21 May 2026 14:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C64A46B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:21:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D1561C02BD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:21:33 +0000 (UTC)
X-FDA: 84792244866.01.B0E7ED4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B23081A000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:21:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWlKw5Ih;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779387691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g93oEA0kKGwcSFIhOeRYyzi6rhykJxN/BHB6cIc81/M=;
	b=WNRZ35mQsX+ltxVbCIhk89YZfFnSUUDN5zv/4+lTEZWOjsKiNC+dcxpFC7rV5d0/Im5WO4
	oz8eqNfNdrnh8qd9PrbOAe04WrX5VudL16vvl8jjwAutVnRb14Om3R2jX+OPdiV9A+EMwJ
	kcEt2elk9Hj0QQzSJ00MTowd9pKXYe0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779387691; a=rsa-sha256;
	cv=none;
	b=8ii/LMByh5yPRqjzijPAB3+aRZgO16nui7ykVnx72gwJqQlRsgOP4N7gOqv52B0XmXsl0g
	FnFqBb7UGwDdr8LMTeWkI7/F+cFxv0k+2KeGVJdjINnqei2WxDr4V3YA0cV3BRf0ADEfN/
	BM53HhVmtWW4+IS/lE+DLk25he5TeKE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWlKw5Ih;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDDC940E3F;
	Thu, 21 May 2026 18:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB39D1F000E9;
	Thu, 21 May 2026 18:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779387690;
	bh=g93oEA0kKGwcSFIhOeRYyzi6rhykJxN/BHB6cIc81/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWlKw5IhDq20Bi7OkJjkoSnepsxPd7RmpB8SbJ7Pm7vmUSIy3ZC+6b8RTlFBuv2Lm
	 C6j3OFiVe/w6v1QuS7L57dQBTchfTyU9nIxTiHejXx73dv/EiYPDmRsiig0Z+YFWwr
	 ve3Weottoxt7rnkTrstJ3GODm0/n3J/PIDDWV+poUy0Cwc4KlW+suHMjXAEMfxnUFU
	 R47zjXgYHOh2sMATN7OzSRTZGZzjkhxJtjZvLLaDz+9XnBVnnMayPNHUWlgkpAp91j
	 dZoVR3pHhC6sciqO+jmS1Yl+jni8vFM3ir+jZy7ML464k4W02OUOVmOaRyfu5WSNno
	 l/d1HLowZvciA==
From: Christian Brauner <brauner@kernel.org>
To: akpm@linux-foundation.org,
	Philipp Weber <kernel@phwe.de>
Cc: Christian Brauner <brauner@kernel.org>,
	kees@kernel.org,
	jack@suse.cz,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ipc/msg: Use dedicated slab buckets for msg_msgseg
Date: Thu, 21 May 2026 20:21:21 +0200
Message-ID: <20260521-biografie-beehrt-267f674efd9d@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518182636.58134-1-kernel@phwe.de>
References: <20260518182636.58134-1-kernel@phwe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1254; i=brauner@kernel.org; h=from:subject:message-id; bh=flqBjIvACXmcu9g/NEwaQ8DCDDqkvRuR0b3vArHqtMQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx+6p5fP1y23uhad4S6x+zWa4KsDeUSfzX7/m71ePcv ugzTFavO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTAC4izvA//ZT15SqTgDihwmKl uef8f9+bGRD/InfJ1sv/axpvCysaMPyVzGjbr2zoMsen1uRJ0wSee5M/btkXqrJpqZlpUnFVZB0 bAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B23081A000A
X-Stat-Signature: dtesackqdqi4hhug1ob96emyjnkggpp3
X-Rspamd-Server: rspam06
X-HE-Tag: 1779387691-304117
X-HE-Meta: U2FsdGVkX1/FLO+2waaxunYtYQ9LHBio/EdnhorxJkv2oirp5UwtS0AWDhktnXyYL31pOVuivOsMtdveNpnAb0OHkMWcGTu7NYe15f9UcCCvbbhGDYzyEHERVyjkddgZ0ohOYluXS+NGiUOFOAITpuNHESO9cPZh2wtKl3d+mpswomQ/PM+DACZbSFrqJqhHsaQxulaFvaROc65QMJj5ByQiTjTDBkiljtm0fpdbtYa7uKCdH2AUPUtNr90kf5/nK2CFgsNQfQDJ7bEjjivkSuenORg0KHwemcfHlO4/vTmrO6ldXqauUyLx49CfDdv8o/+1MWuKAd/hkB+UIA1KUaxYDq10pyW8sa0DMkJ8zDm+NgkWQAPDMqeAILSFlA+7b06lvBMIvU+zW0OPtBQDINn3mRPcYKrg09/kHJcuPLzflg8ID6UlovXyosFM/Qf2SIyxol9CsL3pthwMb3Ptxj7SUjMvcEKvjae3HRLpXeIJyz0Zzm6yFjud/UkD17Y4+k5eVzP1oPH6EhHCs+9y1sfG9tp00lfiMzH3J5/OfKaRQ2Orksl7cPEvb1igmMmiT9jwY4s0tsqHSOeoOJ3xBBiYpoP/X4d8WHuLEshf6ABmb4vyRxVc1B7R7WdSqaJvXf6FGmr86NRV6rMsK9HfJtgg5fxZsF6FdDKu6HXlkV4sHy9rvpBhjiJxQUQ1FK0GNSzML8yGIHL1LLuOtkEa3X86ceX6iQJwk1huoSBHMTLhvYpfPmK+cRC1L4unijmAq1iEPGNvqkuxkgO+u/YUhW77inDEmG6ZTxEu8OInMX8LokUXQ29ErkEdvNAcp+LJsVojjLsVrsEZ/LXss1Zb3yhF9EGVzq0fsAwXuYVUubF+u3JUNI/RDCBK9TIXj44xZI51u6G5r+e+qbZd+WaLVpYCZVOfDb8wrRqO5KWomQ920IT3Keyfd5XcKPksrJuaJlvrw5b+EY7ys5WdRHd
 UXYOJT+d
 omq85MGC7NJEbjaNuSeTMT4WlviXCfebpQcEuMCrv6/gGrg2c8JxAk8rfmH+ThrgBO8z6TMx4+kJoAy58pHnxREc/xT8Xj5NH5Td0oGNQSQz+8vhF9A6+bFbvNqeydfVnUZLAtHSXtsC3KgTUuLsLf1ymVt7zkQeqz+1nYv3jyXv4c0VdYJLWejwoyP/7vSJj5/uS0GfX4UFdTzE+bekx169k7QtXIXG1Pe8CrFONxqHi6/DNGTtvSCUz/3pT6Cl+muadqXv7GCs7D5n25I7ZgkHcFQamzPGAh/0J0w6kgghC3hhSFOXJMgqJcwCLwBiPTi/IlpiZkuw1OzdmcT7E7OhBGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 20:26:31 +0200, Philipp Weber wrote:
> System V message queues already allocate struct msg_msg from dedicated
> kmem buckets, so user-controlled variable-sized message allocations do
> not share generic kmalloc buckets.
> 
> Large messages allocate additional struct msg_msgseg objects for the
> remaining payload. These allocations are also user-controlled in size
> and contents, but still come from generic kmalloc-cg buckets.
> 
> [...]

Applied to the kernel-7.2.misc branch of the vfs/vfs.git tree.
Patches in the kernel-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: kernel-7.2.misc

[1/1] ipc/msg: Use dedicated slab buckets for msg_msgseg
      https://git.kernel.org/vfs/vfs/c/6cedbc997a94

