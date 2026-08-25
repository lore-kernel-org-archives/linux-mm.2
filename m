Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8994AC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A605A6B00DA; Tue, 25 Aug 2026 09:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A378D6B00DC; Tue, 25 Aug 2026 09:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EA66B00DD; Tue, 25 Aug 2026 09:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9786B00DA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:55:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B63D1A03F6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:13 +0000 (UTC)
X-FDA: 85139938506.20.1D7CF3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 77A6420009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OM1HjBnq;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohIDpKKSWuY/nOCEckXndoguryNSiTf+Hx10lCL4gv4=;
	b=ahRM8dlGDKTFPeHOB4AmfATmkMsgWWAQhytaUcPUm0Hau24/ZByXd+W47gsKyYPw7MfpCR
	mW9TYUZvPJMG7e8IZ6IX5HIaFQ5czRFq+NQiMjiGsE2EgbCMhkV9KpHwWm20/7e6wKW74H
	TZRJE3540hkAu+GNc3AbEfZoKB1al3M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OM1HjBnq;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666111;
	b=R9AWsOPCe7NM3nwj6f1LUs+obEcphRmWltbfTERXNwvlkXr2gAEKFxWMmdr0IoYftZomDl
	ybaxh1jxfU571SeGJCr0zBAdMXijmAtSjOKOpuBm2kETZ59ctFzqIL3rgvwGCr5t/v2T0K
	up0ZMCAkuTbSDHocqz0VqkJ9s3JNFMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 660A9416DD;
	Tue, 25 Aug 2026 13:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DE61F00A3E;
	Tue, 25 Aug 2026 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787666110;
	bh=ohIDpKKSWuY/nOCEckXndoguryNSiTf+Hx10lCL4gv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OM1HjBnqp7yKkwww+cpXJ8aqdqp+eUcy4iK49H3GIU08V8TgUyd3oRxOpmO3O8oRC
	 6wjnYLsI9Bx6LVFZHPgKn0zz0G0GFG26iWp8pf7ILhz9XDFM0gr8OX2t1VQqAP9Mc0
	 YbavpHRreMLlvyYH8HU/R1uKDGbUh8C+cy4Alhbl6HIeVk+Tpolt59aOCJWQfQDuKO
	 HGB+hR0X1pCBR+fJpYGaKn8Ou/MCmw8biSTLsxawn/wBTQwFAlM1c0af4IxzPydOs4
	 yEK/dQGCVm8PJvMcbW2j3cugiY2bVZasgeei1bg3c3hJQd8aMj9+Bb9cJXWj3BZflD
	 XLvMfUvGBHefQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Tue, 25 Aug 2026 06:54:57 -0700
Message-ID: <20260825135458.64555-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825124616.5129-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77A6420009
X-Stat-Signature: 1uydh4x4szabkgcopfx4xgospfsg9mwt
X-Rspam-User: 
X-HE-Tag: 1787666111-470421
X-HE-Meta: U2FsdGVkX19mOz1lacokrv/Px9Kw4+7TjN1hH3HG9lQ1VGq9x23V6BfNj8I0eDBMdnjBUtezDWXWZ5G1k+F3buBZZ+s7TYn51zmBFanCa0bnKfOpFzQz4qMXIt9AttPtgTfDF7udjNlHcO27DTm9SvdvS3b7AGgx6FH0JJVGX/BG+eiMw6VDpoWSBbg61bz7JC3xsBopuWm/vF4cU07zBpD+HyJBM6UtSHJjp8Q0P2P43b6xII8ft2Rev90R/ski2COM4ovQqgaEJHq0UYKzGpNcbG8rHoueHh6OpVz72jT/xDBVL8YYO5nhAn9Tbfy8U7aav4OpPUdM+4+HpjlLmdrX956lrhTCQiJW45J1ZlbdEfLdQACLjScGaYzN0vrMEQAj2osuWN504eOOpUQwZ8W55kd//dzVyxBnGpjSp/4O2hx1NvnT7tfBoo5raPi3BFcjx/4oT+0Y7i44SsbqY13FfZDziX0hldOfxf2O09qiJdEZjer1MaPALtdaOy+GqAyNvFLNd7xK2om/1WXcWEkyxqxScefQbfCQ+TPSZ0ssnV6kC8GO7p6/i8HJWY7cktjNeKc4iRZ3IbUDitKyfTRSVR0v16lCq/hRHdMxGToENuJrB1+i0wH6QXkF8HEzhy66LKZGqO02nQbqf3xEJRyJO9mt6Uf9OdjQEv9oeuaq4R24pMUX5FPQphbP04NjDh2+h8XlyiTf/A2x8SRy2oS0cBVx7nnDtavHz0yPMNRh1ojr0bTm/4EBxPThZV1kPCcpAcH+0LScDRySSwYNxRphCOPgI5iBlePWDsL80UyafZTp3GHW3STN8zPW4ADzP08SwdQONkblJ6nL3sGgN49T56hby/8ESvzvHXDWb11mZikQfJVV3aYj2pDTViwaBZVJvCdZNQaMJVoVdpsyUvinSyrMCJkgOGYKEPXtn/qPVS4oLO+skyiLba6uPRRd/VkLnME2hoBqcSvd7b0
 SlnhiYcz
 jb37bg3VtDI+zmbhJLjvGf4zOhShvH3Jd7YHqHgVbCrwMAz/23EWZ4Pkk1D1EhVz2t+XMayTUglTjwa7gavWst5AVr8lcqqaK9PBuet+wwkVAgd5H3fslE2WwIemgpmnXY9KLY0VTPd1C1Mstp3gaL6ugbbONTbcFCJlavWZCfb/EC6chBcXm50VmVdXqWV5uByqpTppcVswqVSjTydhoeOYNVvktCB8BKC4AYk28iN4fc/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> DAMOS uses charge_target_from/charge_addr_from to remember how far a
> quota-limited walk has progressed.  The current implementation has two
> problems:
> 
> 1. Once set, the cursor unconditionally skips and resets at the last
>    region of the tracked target, so the last region can be skipped even
>    when it has not been processed.

I don't fully understand this.  Could you please clarify more?  Maybe adding a
realistic example scenario would be helpful.

> 
> 2. The cursor only advances when the quota becomes full.  Regions that
>    are filtered out do not move the cursor, and the scheme can remain
>    stuck on the same regions.

I don't fully understand this, either.  Could you pleae clarify more?

> 
> Fix this by treating the fields as a rotating walk cursor:
> 
> - Advance the cursor for every region walked while a quota is set,
>   regardless of whether the region is applied or filtered out.
> - Remove the unconditional last-region reset.
> - Skip regions before the cursor, and rotate to the next valid target
>   only after the current target has been fully walked.
> - Rename charge_{target,addr}_from to walk_{target,addr}_from and
>   damos_skip_charged_region() to damos_skip_walked_region().

Because I don't understand the problem, I can't understand benefit of this
change.  Again, more clarification would be helpful.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
>  include/linux/damon.h |   6 +-
>  mm/damon/core.c       | 156 +++++++++++++++++++++++++++++-------------
>  2 files changed, 111 insertions(+), 51 deletions(-)

Quite amount of change.  I will review the code after the high level
understanding is done.


Thanks,
SJ

[...]

