Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920F560A380B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxBON9BI
Received: by kanga.kvack.org (Postfix)
	id B05316B05B1; Wed, 11 Nov 2026 16:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD4F6B05B2; Wed, 11 Nov 2026 16:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D446B05B3; Wed, 11 Nov 2026 16:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC886B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:55:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 384831A044C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:55:15 +0000 (UTC)
X-FDA: 85424194590.07.9C5EFC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 99A3240009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:55:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxBON9BI;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4yuTBdLVdxEFVLBP82X+jniAKNXB01wfF6dHW83hW4=;
	b=uz6qeuxKmbrPISa6AyPr77ZMtAjHbYUDTDlxfxCzL6IosOg51gax/9Vj2gbOvjpIyqNRq9
	vfRNkH2AtOiS06iFaXrjakjFFZp2Ab9MkcLYmZAI5RGp5NGM+hzjl4A/1rb5nSwCQ76pKT
	QP5+NN9j2NlDNIiBMZ8eS+OdBDekvKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434113;
	b=75SgwTrosqURUBw1GsUj2syI2jiEZAvA5PbYwMCzUTlO/CuSWueyTqggtdm8FURmGTmAcf
	4o8HqotMVjv2wJHtS6pimq0SiErTdGAeIn2h2f18A29LWxMtsJjR52T3xJB2MhSOOXoVXl
	xcsLVqcsqSk4BQqCzMXerOfwL4QMS2Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxBON9BI;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C719D44FF4;
	Wed, 11 Nov 2026 21:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C5A1F00A06;
	Wed, 11 Nov 2026 21:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434112;
	bh=+4yuTBdLVdxEFVLBP82X+jniAKNXB01wfF6dHW83hW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxBON9BI3wPaCZVYgjY8RABuk84J2T2Y8FuF7LxOfNKkLJPyqmOrKttEIPzCgMjf6
	 Q9E40apKIKjtAa3ydg+Iafs1RbxQUA3gAM5k1tmD4OiCBlML0SPZdYARYfPsHGTTd5
	 krZm5E05P627tDb7bYWV5x8nEIowWwsUfIG60BTY/cssh4QzOV673I/C0onX6tPYK5
	 /+UyVjJPXh/M8y7AjPKeiKdfweLdUuPqxvWoqOPcp9XQ0iPylyxRZFjjw6f3Qo2Nx+
	 lTvpjPPI9G8OTiSFFflocdVIaoNeZEkzMjErGAYrbl1p3lKQvVvC1djg1W0y44MDxn
	 MHDgRwMfwe/5Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	david@kernel.org,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH v3 6.12 0/2] mm: replace free hugepage folios after migration
Date: Wed, 11 Nov 2026 16:54:47 -0500
Message-ID: <2026-11-11-1-daily-reply-0014-f65ad47bff8b905fe68d@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110220006.3259056-1-mkbund@amazon.com>
References: <20261110220006.3259056-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99A3240009
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: h1i3w8is6r8ckqhrc35uzm3r6n7j5xfx
X-Rspam-User: 
X-HE-Tag: 1794434113-449202
X-HE-Meta: U2FsdGVkX1+0c2PpNffKIiDHWXvnWg2BtcVT7w5cbV/w8aP9CZfc59v4Qr1U3a1TR4mUBqUj8dQyzr4bSteMt0qKJ4lJZF1jJHKmuFBgvOdkwV3Wp0tTSP1U4NP4SWXFIOeV8R7CFMS+XUEk7JcyaU5SWBuIfTXhSqGTMD3fu5/ulJ7NXC51cjUiVkc2a6RCcKGeVPKlrVx3+9Mu/+nJf61uF7RwDC+3LHI+1Ul0e7o86JmcSmtVqhBJ/Z9IPX+S+xkzokhNo4usucj+B/a/YSaaZaf3bHoh2QPP2inNu5Un7vy1+PzLeqv5vQ5Ts1J6XN0zPu4Dm7+LDIZSq3goNa+Z4aWpTd4uIverMh2lMuikAgAWlTuhIW2Ujy0nHQabhLXRikp/mMOrzjGoTdpXxlDeT8rILy0/ceBzuyM6JMF85x0x1VJe+RL8SfIlIzlmTjb16qKwq9JViAEgvMYgEArCYsgd919Q5Zw62tsGo4BphljJALwjLF+Qy8l+9nAaUlWsed5knW7DjOMS9VdBlTlMTwh4qtYBo3Pbr2EfAmg08FAc7EwE/Kx8AHieUwiC5nR5zLHQ/htVmqbGpHNY4/HrMOoZFODYF7CcU8djWBmy27UAPyZ0MAd/k8AAk7X2Y+IlgWLNkBjfSpksWuATOlMaOOT2CueVlUyorgX2HSIimUFYTUYSLm0+kUPoAWokT0EQmNVJQnOsfpHl1WLfhAQPzkMONQLIZeWqCAhVdeTSTYTC6jiQnn6hNA49pZhi9Sn49ILX8aNK2mlzGIE2sqVbiAr3z7QSMc6BCTRUaIhPKrX/tiJ77Uvtg9HWr3LI6nuXB4MQwy17DE4cvy6Oj8ZmnbPErRPfb6yZh75rsJE8f9/f7GUb8qzP2e68oB9/4OkUSgm1sitdMA4FS9j1vrxJ5HFJaOob+8e/zsFBttS/0I4lEZPobWVTrxmnglH5qAiGb8COZGxdj27h/nA
 SD4Qhc1x
 Syr29LvPOOyMNQ1QBy35A5hyfGTUoA3HsZhhBDpdEeYa5OmffmswOzC+KfXXMLNmTKqT4XbP3l8JHzGiSqZY+o7pQWGofLkql40+EbyzwSQD7s9mjGO056mDeVhI7OOQit38QHSTVIEbukVxzIP4hQY+9xlCjsss/KGum1G9ihzWl5GZznETf/1+lScPmxuoiNtQasKxuofLSx30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [PATCH v3 6.12 0/2] mm: replace free hugepage folios after migration
Queued the series for 6.12, thanks.

-- 
Thanks,
Sasha

