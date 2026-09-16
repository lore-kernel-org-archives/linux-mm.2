Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A16C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 01:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B386B0088; Tue, 15 Sep 2026 21:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D446B008C; Tue, 15 Sep 2026 21:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B2C6B0095; Tue, 15 Sep 2026 21:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0646B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:23:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE10F160503
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:23:40 +0000 (UTC)
X-FDA: 85217878200.04.2E15658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 16DF420004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:23:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRyZpojy;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789521819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0W90VIeUB/IBMQozfKb1frW2yE+YJ2al62rTy8touI=;
	b=eFqpbF1KjiGI04s4mGB/DRBXl80+hf0w4aA42AiiFnlsOgTz7C5ZVWruyzfdI1J/irjb/r
	2jXJQgT0lif2JgPLMvP0MsvajObow3MOkmTgYulXrtSsF7FEOAMO5jdBNrionC7TqDZAEF
	3Z20/hK5SZqSCD/keA+wSUzVr8/lHY0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRyZpojy;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789521819;
	b=AjFo91iAszZfXoB2HCv0E2pFY+6L0ZsvRp8WBMrARvj1Sn83QQ0B0wk/sUYEPq6u+kOBFA
	1IIfmZdtRGlIDWPOBlKfyaXv5m+tzzt3Hxbl7/eIbbpBFh0BVQ3T/u4L7ZGgLY3yu4eZaX
	lv0KmWDPdYuC0RkpKr9fnuT5PpnNapo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4878A4395F;
	Wed, 16 Sep 2026 01:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD77B1F000FF;
	Wed, 16 Sep 2026 01:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789521818;
	bh=A0W90VIeUB/IBMQozfKb1frW2yE+YJ2al62rTy8touI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRyZpojyIkfGqtAYjWn5esKE2+0oYJ0ODs5DmjNbL4ra6Sl9gqoBAAzndgf/GYlDW
	 eJQKjAi2Q61lPAnXmrk3FJpXBY5Fc+AQKudHKMJMs9jJP+J5xMqUkXMcT0Dhdf61jz
	 sHcVnsb/u2OhpUAK4WyZaBm3yadKPjESvfWuN8UyZbA9h1LO6emlot06nzUqVLe2zq
	 XasURGPbpb1j3H57zzu2K4dFiI3Og3oFP3Mhg2RKVgg0XmW1HxusaS65w5I5iTJ056
	 dtTT45PF5Iww/CW8lpLffKGjmOfRzDjMD72/a4pZ1IkGo4CtIaW4OOn/coisZrQrXF
	 giNmtMYs2CWBg==
From: SJ Park <sj@kernel.org>
To: Zhenghui Hao <zhenghui.hao@qq.com>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix misspelled parameter names in comment
Date: Tue, 15 Sep 2026 18:23:30 -0700
Message-ID: <20260916012331.102450-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yseyr33ruaikwgo9qscaa6d999hdwu6g
X-Rspamd-Queue-Id: 16DF420004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789521818-90147
X-HE-Meta: U2FsdGVkX18thdrxIA4ByMgABTbBvixA3JLnp4XRlKcyEW3Eko/qHzzZEWIKrbmVCquy5nDIFiDkNBuUsxcjcYg78+XboxkbN68wfRzXfXJLylBrxOV7v5F7ybKDM/vfk+hAwWmNuIJLCGZBcbObyeZoQ5p+dAUaZj9V+Kpca0YdTujTKuzk/JN4CRbvHWYeJbpxWxE04Z107HAj+n+N/pUt1isHoMSPo/v9elPk8bkzc9jMBaov//vz7ZxcSXeshDsoA5lWsGw1ROTB/11BlH2lhLvR74yMp8qgsGCShAVv+GPwlOTwDsZZpr8tItGZxD2ZDNiKcg3Xm8i+3sZYFrEFYeD/armSH/PnHh7VguVZL5RykB5oQnUOevWH2XiGcqYATpBirXBmCcikhBac+7x82UeTKL14fpPgDOKskAOzK17DY3xq8u3IIbN5TzqsqMA3r8KTIHgWM1BgDHTctHbxqt36oLfPSibf4DXzgxErqlrwP2O0uHnGw6T3zeN1xf7hcBNNWTMPDBZtJkS+EB8i3D6f+DM8eTbU4J2ulUYav+Tk1ZdU2VRhmf92aOY0csVtyb+jeOv/Fqo5YwRUH8JpEsEwa3WLzrYDQ1lUwbVXPMtefk/Qpjg5wNa8XxLC551YNBHFg+1lZ+diKethqTxc7i9RwDu0w9oudvsBlpKO9AEO/Q8WooZrTmvFBX2XafP+lamX2zzJZ53sPWFy//r1kwH1t3UeT6oDgRruI1ndeqbDV3Ys16Lqc6E+hsZbHVVEgVAgc+nazPQBxQupuJBPZR3KEH9E0Oi0JislYAtyZKPST60Gcgyr24kKgrJtpDZgZ26xc3RaXcVr91Kld/FEye3rtxS0ZM2fW4zgGDVD6Xh3aOkNd3rPXZN5/IyN7dA5u2x3bxy+WE+FgCkDA2Unw2WH48A9I9SYlNeAxyD904ZQNKX8FdhtEcbPeI9w5mvzXnC5QzgLN8zlulu
 NR3Vxms/
 qWeyT9cNe82LH9jnycBIy6WY4+7cJPAXTBam3sdrG31RMiUkaxAsaNpWeITSpkXaE0EGF6bEpg0cmmAPfRYfB5iUdSLgJ9u+88/070BKHrKqa1l/62Nx7313mATT4+LAwepfFNwgJJY544HeQPFbNKqcQTLWC4gLr48XpbqXuHjj3imIs5FrVUmOJ3cq2QwrrD3pMT9nfrZf/DuvVDB3oc+TLPSG2e2W2nkLn1p/mr8KRrg0u2y6YXqtS5bQgfYSavWh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 16:20:29 +0800 Zhenghui Hao <zhenghui.hao@qq.com> wrote:

> The comment above hugepages_setup() refers to "hugepagsz" and
> "default_hugepagsz", but the parameters parsed by this code are
> "hugepagesz" and "default_hugepagesz".  Fix the spelling and also drop
> the redundant spaces so the comment reads normally.
> 
> No functional change.

Looks good to me.

> 
> Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

