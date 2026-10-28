Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D175606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GfmLq0jA
Received: by kanga.kvack.org (Postfix)
	id 12D4C6B0603; Tue, 27 Oct 2026 20:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090496B0928; Tue, 27 Oct 2026 20:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73D36B0929; Tue, 27 Oct 2026 20:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B15926B0603
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:10:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E47A7120B56
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:10:03 +0000 (UTC)
X-FDA: 85370102286.24.4EDB1F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5BDB920009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:10:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfmLq0jA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793146202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcj2nzk1x4TQs5h9GEfCeidwdxEiiMerDnsa+sFWmoI=;
	b=5IqHRDSf5+NUVtwi2812eALvcavTnv4TzgfHtq9FkHXm0QeRtLiuSzWeUzMgQNeh1eVN5M
	qrivmm55e1qhqDZdERIZHhb11ubkqcmQs+J65oeCN7rwxKthpYpxMgHCuvuBgEloACAp9G
	65JBBOIGkx2Z9QI0OJ1gwLflQy41xIk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfmLq0jA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793146202;
	b=YaWKw8vTmRKG+ckCpyWM7XoTpwBvRxDk1livYigGX6wVY99kJtgF5uU5CjAlBFF5X1Ae14
	dc84jMcBCwiktlF/5nT9zamPqBc7pvxauJBPrLucHbjdsj2IWrvjbL/sr9lU/koEYY6aI1
	hao3UzO8y8g6qd/iEe/3ozfCmXVyuyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8A0D60136;
	Wed, 28 Oct 2026 00:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4970E1F01825;
	Wed, 28 Oct 2026 00:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793146201;
	bh=dcj2nzk1x4TQs5h9GEfCeidwdxEiiMerDnsa+sFWmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfmLq0jAcRxZP+ZjJOf7WPSO7CIuv+AESEd8wJMsri2tjnHYAlCzwn+RCmjBRjbQn
	 rxrTYlNOwKxH/TFFTey8pAgJqHujFCYsB9oWuVULFqet4DCULHraLCIhUxEVnhJe2w
	 lU+L686Kv3kjmTqJHCczLJTTM+kWrlW0nwmw1kDR+zPltovBpRlbNblh8ivVcELgNm
	 swCIcOgJVPR0nYlX2l//FghDknWFQSUJpBFFjecGpF0lp+K6Q+fl6eesAQ1QZKWkrV
	 eQ51gDx+6sG735SVXVfU6XfludlkHgjQBAuTCtSpv6Lk/T6h3o8gQUssGUHR/Fa37l
	 1NMFMEy2+owYw==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
Date: Tue, 27 Oct 2026 17:09:53 -0700
Message-ID: <20261028000954.157268-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027190628.2527100-2-manuelebnerli@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BDB920009
X-Stat-Signature: w3tandf98gqks4katyj3dmhqptgkni3q
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793146202-97885
X-HE-Meta: U2FsdGVkX19rqlOlbKBCJ6vWbB0M3CVO2/vidsMytX2iBU2u4BdgRTSp2kJ0FLN0jj4tNNfJkS6OB5r91d5CEvyEcLHJHibaG4KRn+RAfV+opFmMpSSiSJj/0nRTIXjxXHBwfZiv4cLqbxhH0dhYawmubmwyqnjpszAm6BFWadzKhFBToFCmkXV7zbq0hHh2/mqXJawdjTru/+vugB31qlR6VnHPwzpwEBf2JfWlGsTRgOtFHtxFJa4DB6XYg+PE85tbFMqZpLFsqbvgDaCByVW0V0ieXh+1/W1VxyxkW8BHAAr43OBMO1eeePCe6l3vUdvUXwNLPrcvseYgTD37FLsgAxZogZ2RqbTJql8uGA5GJHwx2on1E99FZShNMd6CnXvsM2LMEj2Y3mEQnIfcDmbr+I76ufqdeQ4tiycdQNtW9DPo7zcOPzF5iuJLlNLO+l1Y2qKXf3m2H9426ODFzr4MCWHAQwd2w3r+he8EgnA8fBrdnLe2LeYm289zBvMK6OYk1PMGJH0DITXYZctaFiwVj/OqZWokjc8C68YbCra6H2QnX2M1LVHuJKi5cxJbjvMoSPATD3cuPvJqmkvIAItk3r7iwW9xRc7vek9Kco4Pedc44EUVZe0hxJzdlCkrT1yvdC0H8PwqvET8dnDGipOw2+icfCPoTBQ8ByyNi9Cw+IHNqKonHrVR4izc53sJLcJgxV/gfC7RHeFhUVUzMLdbjG034ROBzre2FmX0BqUBim/TLJvd+wWBiptuAbesehHHin//lAGPJ34UjuIRMmfQ67Lq0/0KRGCg4b/zSNcMo/LYIZNOgQKmVieyPvHXHWaQ3l5/pQh6zl13HGznlU02gZHxJaqVvdLpVrLCLZVPfVa2rWh5aQWioHEpFx3YIyCr/Mmap3W12pf2vyRWj6+ZOSBH1srPONJmT4f+um0ta27jXmcdtzrWXYyVwszqUAjQDrB39+vRCYFDxtg
 y6TsavDj
 hKQ4uZyhh/3oww0Ra7mCl9kRLBvnXnYWewBdepmYzC1UYGfR4pXh9c/hrJSybV5tiWrIc+/N9qsoLXUoNjl0v3yFzgxdG+3hAg4YGzXI5JWOVokc6Kea578PvALug1l2SBrwWkmMINxNBJ2h81VgLirakrZAKcLs/xScQl+r7kmgSacOthOQUn9/AhMZske+Xklgin2aYPqaVNy7NhLFr3SRvM0CqGQkWvTyVHUGM22BmAnqvCXqWmuPbqtFSn01mcjxAXgfwi5N9ExhIT82yQIAEIWfXQC+Dj/IVpQbhbtUJoxtzSJvETF+WNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Manuel,


Seems you sent a new version [1] of this?  I will skip reviewing this.

[1] https://lore.kernel.org/20261027212345.2586628-2-manuelebnerli@mailbox.org


Thanks,
SJ

[...]

