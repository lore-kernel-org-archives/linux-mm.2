Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240D1CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0996B0088; Sat, 17 Oct 2026 12:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152506B008A; Sat, 17 Oct 2026 12:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066E96B008C; Sat, 17 Oct 2026 12:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D72E16B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:01:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 622CB120298
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:01:53 +0000 (UTC)
X-FDA: 85332584106.18.85D8EBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5D92140003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:01:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ozF/zla8";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792252911;
	b=j9S1qQtVNhaMBPRQUmZQZVEjdt7KTSLcLYa8GeRxbGTMhhZ9iwYyCe17m56tmq4lhd7eYi
	OvyXM0TSGV4/YPbFEQ1vyHVmUi0kQBTXDhxhgKP5E1Rvl2kstw/gsPpUNSa2ZXPpDos8dA
	/Ka6Nj8q2j/QlA2ZKlrznS33mcGPF6I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ozF/zla8";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792252911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZnlanUf64i7B1h2EayrDWaBYC02Orq3PWtev+6wUVU=;
	b=srFdA/utObmriPfGTlmiITZ0jXb9JyUXWZEmupsobIhKv0PA5B29YDsS/f4J4BvKnbboOB
	VLMaUOeKUITAlqcMU59X82NxfyXMv4A4dvWjb+Pauh83+o+RloEhfoM2nowDVzEAZ+Pv6d
	VdV/PhUP4ZPxCIQVN1Kbr00DRkbdMJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2F2243D74;
	Sat, 17 Oct 2026 16:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560211F000C4;
	Sat, 17 Oct 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792252910;
	bh=eZnlanUf64i7B1h2EayrDWaBYC02Orq3PWtev+6wUVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozF/zla8N+wuHiDl4LAVU1crVf3wQFOQwFfB7d0lA2Y5HvxfNab2pvaTKfbhmJdSU
	 W6bK4+w1kEH4ciueTBuxkMOPHOghVgcAzq+7ZQg1wL0VxEuITSUlZZHORVNV0vTiDN
	 sN8ju76U+QIKAtJK8QLfPlV7Zb84jeJbIEc1XrNrbpEjG5sl93aI+ez+Nn9XIHnLtT
	 UN4Vy5PiPDTRbb4xv2JtC3EjSvMCfAcIgej5XhAP6rqMXIvG+ybAfZrLKOfWMHNRXu
	 VE2lbRaq5Iw/WOVyi4W2HPZSgxPpX0DRWQuW4G0brI5l449KhubASY1Dx1dbmDSRbT
	 u4ZSvSGXkuapg==
From: SJ Park <sj@kernel.org>
To: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/sysfs: make next_update_jiffies per-kdamond
Date: Sat, 17 Oct 2026 09:01:42 -0700
Message-ID: <20261017160143.102364-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017063152.994182-1-karthiproffesional@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B5D92140003
X-Stat-Signature: zp7hk6at8rt46g1pd55b86otkaihtsiq
X-HE-Tag: 1792252911-37543
X-HE-Meta: U2FsdGVkX19F3L5nqggpceWHuc2D6mrP1MRHhJhcc3lwwUKmMg/PNGiV8/l0AJ6nW/uLFdcqi9cBGkimO3GP8a8eVSQTDZ4shnUc41m50I70Ka+aY3ln//9pQE4DsnO2NAtj0ydLCTHAEpBd0/lXBXTrGlO813tNAxH063RZyqnaow+kJrmR8zp/i9gCDQ/ZcEehHvfxitoDgUXl/Qay3zjZwaSMy6h9Jm1J8mPMvPGMJp8QT39qxU106xd+ZjkWDld8TTlqW1NEBgfwmH8oamIyAzHwuwLeh79toEKkTAEWyCMWlvM+9q4SJZDqr2VjBbb2Uk4tS6+sVDwPtNfVw211eNBATx1pjH0yH4eRwCdt2aAm2hd5wQqRFH8hKUVHYu2v54YmAM2/8ldfNXq5fJVwNJyFRab66VMDdE7bfjejGTVr3OcFmBYA/a7DLsggkJeU2lhz7jnigQ/q871cLwtho6Re6iH2O87W57PxGwXpmi2j33oeQ4cGjwC77qscePa0F2Pd0E2rCE1woteH0u1tRkcC9Nxz1V6UgzFHON0k33CfpVftkZRhtk8XpamrDRJ/8Tg0GQPJpm4qKTJN2t/cT/vaiSacjAVoTwn7nK7iyyJBqREGtZ8xlEXugpIriXH4jCs1ZYXVK5ZfiM6Lw9m7socytNJsURjZzyXqzlcUxCOO8sKAyOaaErfYSZ8PUQWCUP6C7dXq7l7SVeM7kB7rQALEna52BbUHf9ztQhiYlkHa1seXOi1pYnMjTSecPoQRVdhEOnpGxTjvxsZxqku3lrgPcF/OmFaVxCIoAss9rudGheVNQXxk62lrSUsh6k5Cepo4CFXiDrUwriq+rTdiEiEdRqjUqBV040lihymKeCKAJOgYwHmibkGsi1vIaDltdGdfWkO5fHdEOFUEnijsZ2v3yiJLS+f5AsbguZyVpVA0dwY123WuprKLxCioz+JCpXd0oXLwTJNPXJd
 JG/++Hg1
 JqFcfsFWX5vT4JYj8+rm45BL6xzUiVNQGM9qz7xcxlZdLobMiRqZD8Pis6qok/ycaAjOzLZDLDCcJHdKFt07Tpwh/WkJbnTxGCJkcYmXUopn2jxIo4Rg13pZcc1XrSPXDGXq/msxzW2jEmGJC/f/W6j9/s7nPWzzJXv7LM+8f3ashIf7nWlgWHN6XxmyfcZH1k3BS8iZQwpum1civGL/KdoDbY3lVHHua0jGmL31MJZXbpkNuwbu2q7+D2azIBLSIPdIoxh0WlBik7zW9E/PJNk/hcnKowRmj1Lkgs5Uaz1ZG+yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Karthikeyan,

On Sat, 17 Oct 2026 06:31:52 +0000 Karthikeyan KS <karthiproffesional@gmail.com> wrote:

> damon_sysfs_next_update_jiffies was a single static variable shared by
> all kdamonds, so with two or more kdamonds using refresh_ms their
> threads race on it in damon_sysfs_repeat_call_fn().

Thank you for this patch.  However, I think the same issue is already fixed by
another patch [1].  Could you please check?

[1] https://lore.kernel.org/20260902002725.108635-5-sj@kernel.org


Thanks,
SJ

[...]

