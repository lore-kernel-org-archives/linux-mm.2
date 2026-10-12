Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FE1CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7FB6B00A9; Mon, 12 Oct 2026 04:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91EF6B00AA; Mon, 12 Oct 2026 04:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5A76B00AB; Mon, 12 Oct 2026 04:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87B1B6B00A9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:26:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 163CDC09A8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:26:22 +0000 (UTC)
X-FDA: 85313292204.03.539CCCB
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B7E1C0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:26:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pN6PkNfl;
	spf=pass (imf22.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrJpgfxbdeXh3TTm50g8YTcfXTJnnoIJl6cuC+fESWI=;
	b=lmW8kad3q0ujNvijFDqXAebzvv8kzWz19QBSI7LMBY+UQ4IU0FYx98smA+6gdCoSi63it5
	YxIVXnUCFw7iPDL5p0i1/Rt4P0ewy0fLNpCLAVv64lp6Y8JTe18Emgc7ANQG1LyyuMfSae
	BJndPWNOZDCKEFZM3u/WoDL3Ji86GBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793580;
	b=SuV06guTSsRFOR8YxjrPvygOuRELPAwLY/YFqRpfXZkTNjM1G5PkUzBZGpp9ViVXEEqhXY
	Uip5Ie6ZXKW8UNCrHcZN780XiDDuRkU95RLTqBtqbe4S/yM0Qoa1WzwgeXoGjyJfUKz9Q3
	9ygeKePtOeRtvgdoBQNg+jGHuWkgTw0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pN6PkNfl;
	spf=pass (imf22.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791793573; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=SrJpgfxbdeXh3TTm50g8YTcfXTJnnoIJl6cuC+fESWI=;
 b=pN6PkNflcP0gnw2ZhlGe94rk6jBYoM5BDtNcaVeXvZ6KJXRRFScPTEEpS2AI45nFOhljuZ
 GQJ19rVb2zWy+uZ9dKS0EKAZzeNv8yRzYDxNm/MIPvTWaa+XgHSJUqdkUYjqBsX5q3Eapm
 KS2pi4yLc6XSyP7iNY6WSpTiDKgD7bddj2Ht+9ZnbvLQonLYeEkJC+yD/dUZ6Nzl+aUrD+
 nuymliRNwPL/RkoUv5SMUgWJYNLxzhsoNtkgEwEaPB9jBz178TGPjxG6M+cXsxAgI2tcSW
 aQ6UlNOTHzxs/lO1bU+m/4ZCrSF1ZS5EbnFYAnHYto5L5WWHf+3v17SRFLvOXw==
References: <20261010141057.599595-1-liuxiang.277@bytedance.com> <CAGsJ_4xxawPzb7MpmdNm9u-fgge3w49n-Cu026BpKYAUZZf=pA@mail.gmail.com>
To: <baohua@kernel.org>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26acc99a2+cf242e+kvack.org+liuxiang.277@bytedance.com>
Date: Mon, 12 Oct 2026 16:25:45 +0800
Mime-Version: 1.0
In-Reply-To: <CAGsJ_4xxawPzb7MpmdNm9u-fgge3w49n-Cu026BpKYAUZZf=pA@mail.gmail.com>
Cc: <akpm@linux-foundation.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <kasong@tencent.com>, 
	<mhocko@kernel.org>, <hannes@cmpxchg.org>, <zhangbo56@xiaomi.com>, 
	"Xiang Liu" <liuxiang.277@bytedance.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache in MGLRU
X-Original-From: Xiang Liu <liuxiang.277@bytedance.com>
From: "Xiang Liu" <liuxiang.277@bytedance.com>
Message-Id: <20261012082545.2926113-1-liuxiang.277@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B7E1C0002
X-Rspam-User: 
X-Stat-Signature: d56p3rx83nghadpfhs111gx9xhcnqeud
X-HE-Tag: 1791793579-480909
X-HE-Meta: U2FsdGVkX1+nogDz7TZ94zHeEqYhCIO4cw9KlhDXt0a6a5DC4kJntfdf2gGZkEGVNvEx4DMMLJjk5Hocs/be4prWqol2+pwtmrgnY7Vg6yDmODWq5ctDxrC0gSqN8IMM09x/OCS1xjVrSGAynBXXHWL346Aj01h+LQAVId236WoXQk9y6QP7pDjr91fUZIoyZuuCexdofP+LPa8eXS1VmFRdgCZA/jVv120cnAW0Ay2xtWrW609H86Q+X8zkJC/lt7z6btKFSvxdfMppEj4iH+aoN+G8olUeSLKcd908RPYVA62aEts116QSQjvewLcZLD/inU5etyVLKtJMx8O2J3c7kAKMJAT9Ypbu0rk1Uu147qB7PKoujEZBRDYu9COYgDr+E3gH4R2A4s1LuI99aHhLvTFdWNxMv+y6JeQBpS+ioSc7C5nUwc0fZad1HZR4oen2jpIf2qe4ps11vvYkmF+YmWCp1P0JJKuu7y4pPlj/1mWtJ/tTglbytSoGelCvbEhiQWccVkIsAipAuxGUo5oNJbPJyhDrGiqmXPxGJeLjcG+WIOyGFimShB18FMjFGcAwA3680KItmDXkDc3Gj2cw82kXCAESyBeVywgFfXWVcJMmvfal8GHpemnc2c+BLACbu/iTGJtePLvyKicO2SrMlTU+p3YvNU4XKvNIU5YLvbGawQYuZ55m0cgQRzlc4V+/qP7MlIeX3SzgqijWhoYZrij3+lmjjzv6tDWKsak3ZgEBe6dvVQP0FV0AjoC34r+8EKcogP/4LhjB46/YyuO4dsp32T7L58TR+h2sMOqJ2XqMFz2FNQbrJTGWrNHJ8okEPxgHMOT9Q3qmfg1T6Jy+1+so2bolzqRRtJU9pijNFCnuLaxQiN2Ip2+D7b/kQwW4c7YM3tldp3AwlHZdKjaLQp0VYelIUOKsBPOtiXq/SUsfu8QND4zZ8ptfdpoLz5llZzLVuzCCsNG+3r8
 AW/R/xUC
 SUWUVmHqZ6q25p3jqWcaXJCmcv9EnZlI392SB2/YFTRU/GrS2DNx1cV+5d8Czzs3valIP0Ff0DZuwUbLNoLRptDICY5Dy0xMHY8tmUGm6AWe/9hA4v29s38TGhhRO5xoIVom4cilDO9rNqYUVkKKTVYu/fPE9iXRYrDEOnw0jJzIlGgaTEREhF3tH1yN09h8qq8JqpBJ8rlGpIFKDaX1tYU8mgcjIyeFc3/LVlRjlBQiywqO0mHWkkZ3f9wHZ+7If9kzaCEbhS0gGFnpnSI9B1PQyjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

Thanks for reviewing.

> I'm not a fan of this fix, as setting
> scan_swappiness = MIN_SWAPPINESS will force a cold/hot
> inversion for anonymous folios.

The patch description outlines the tradeoff:

> The tradeoff is synchronous aging. With four anon generations and two
> file generations, advancing max_seq can require moving the oldest anon
> folios to the next generation. This patch accepts that cost to avoid
> low-yield anonymous scanning. It keeps the original swappiness in
> try_to_inc_max_seq(), avoiding additional use of the inc_min_seq()
> single-type shortcut that advances min_seq without processing the
> oldest folios and can cause cold/hot inversions.

To evaluate this tradeoff, we varied the oldest anon population and
compared synchronous aging with baseline evict_folios() time under
GFP_NOIO with very little swapcache. In the cases reported in the patch,
aging was substantially cheaper than low-yield anon eviction, and
allocation and reclaim times decreased. This motivated retaining the
synchronous cost while avoiding additional use of the existing
cold/hot-inversion shortcut.

The diff uses scan_swappiness to decide whether aging is needed, and
passes the original swappiness to try_to_inc_max_seq():

    if (should_run_aging(lruvec, max_seq, sc, scan_swappiness)) {
        if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
            need_rotate = true;
        should_age = true;
    }

inc_min_seq() receives the original swappiness through inc_max_seq().
With a nonzero original value, the anon shortcut is bypassed. When anon
has four generations, its oldest folios are processed before max_seq
advances, retaining the synchronous cost described above.

Am I missing another path where this change would trigger the shortcut?

Best regards,
Xiang

