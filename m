Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9AA8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A396B0088; Wed,  8 Jul 2026 12:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713A86B008A; Wed,  8 Jul 2026 12:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB976B008C; Wed,  8 Jul 2026 12:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8F96B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:18:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8F801201D1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:18:14 +0000 (UTC)
X-FDA: 84966116508.19.1A04CDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2742012000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:18:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j5Y/+nm7";
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783527493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y752DrbBFFJ8XerVisGtOLzv8nsy5PhYRKi3Iy7oc5I=;
	b=1kqX8Wf39MlnnQ7Ezwan1Q+5B7wfYD3dPJ4V1jVLCriepQNLq2pWOBx5qHhGj+mJTqiX5q
	SEs9ixOxU8LEhMEVdn1MJrLwd6jIk4hhWz3RUQeerYSBL+3HK1kaniTYsG3IscpmlPq6bA
	8EyUbZleqnfxXl+n2YWXuoAOG9vShfk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j5Y/+nm7";
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783527493;
	b=nsYiv2xDPymsHIzWSfKfV0h8qOfz9khFksUjsUWTlcvrGfQcO3sgIURsjL9PW7FpRbhEqt
	bZcpv6XdpQPhV+xq1eKN/SntZfj1yGDE2neD/VaHSvBCsK96ko5rtZmCDmJ+27nEoofZUC
	e7Jx286/loiXuBj7pVsTs+DBOA1lCTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D310601D9;
	Wed,  8 Jul 2026 16:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D25E1F00A3A;
	Wed,  8 Jul 2026 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783527492;
	bh=y752DrbBFFJ8XerVisGtOLzv8nsy5PhYRKi3Iy7oc5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5Y/+nm76DxQqxVQ2O+uA2O29guRVqRiECEnMndzrX6O1QnnGoIxp2bjapqLS2BHu
	 jVJFtqTe3UugvZNfBbhiRRNC2C5dzNv78ys6CYuC1x7c3La4ymr/QOU9C1SC/ELw9C
	 UtxVp80PMuvpJqW6zgM8iKoa0pRA8QDTVTmAmj4MuUy9sbe6S0HRJapHaQq1eCSqkQ
	 vITo2wO/XYgiIIlxI3nq5Q/sKSYW/K7QydMN4dv/+K9ad5hrS2QHakeJLErVlgknES
	 fagUYCD9M7NlJr1Cdn2xNEudUV4lb+ZY7JRq5CF2pLt/IRAMNRAagZOz01v0W0Jr2A
	 N7vZ4ppo4339g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	linux-mm@kvack.org
Cc: Sasha Levin <sashal@kernel.org>,
	jiayuan.chen@shopee.com,
	jiayuan.chen@linux.dev,
	yingfu.zhou@shopee.com,
	willy@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y 6.1.y 6.6.y 1/1] mm/vmscan: flush deferred TLB before freeing large folios
Date: Wed,  8 Jul 2026 12:18:00 -0400
Message-ID: <20260708120502.agent5-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708041237.289026-2-jiayuan.chen@linux.dev>
References: <20260708041237.289026-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2742012000C
X-Stat-Signature: 1sjqn5qk1tujnstgrd14gmdaqzqyrymd
X-HE-Tag: 1783527493-334797
X-HE-Meta: U2FsdGVkX18H2lg2zw3zWktofKjXEGTb/TLf5YUnWHEtpuObMQWVN8t/GTKHH6/aplesKzg2aHW1Y+yBGqaIw9s9tH7ilM1mEFEK98A3h8vh7E9TmrTFmz+vvo7EjF+KDO5WFzTIJAxdxVGE7pqiUosgk29hQwc4VNAgdHeXL48HDxO1XPDmSm/0fHicrMHbeJGGrRZ9OkysDTVh2kYGFMRHe2fGD73JxSYQJ4Smom81QeebJGL81m4NgZmIB70LTUt/FV+Rj59RCC1cpqzwws+kCy8TBiNsh+qEUWZnSV/poen9ohL8XF7zhEeF215z20UegMFrct1T5YeBSF3s4Vwu28YD0CEjStTHwXP9Ayu0/WC8tCEddC3fHC9/x17P2kFGMxlb7U3rhMsF0mrgla3p4Cyu5IEzTOFwEBZu0z7N8EocK9PUds3bOO/MxuwZRfoFoS0EFtEUgFNEQW6IQT07iz62tLlguA8ktSTJsbJK1UB5Cn2+nMMk4kQibZleHjk0koQKw930cPDIJrNd1bqUXwhe+si0Am0fg2L8ybVJKFjTIXuVHjKHFsrd8n3ymKNYdaCHIbT+D5a4OkAC1MkA4nh+ht8Uc5cBb+Wy1D2L2Opdq+ZPhO1Js7tVHF9ZHDJP265EblWJjG1Ds0cUZolvE97DUofzaIc7bSgKGHCYgMvsRO5R4ZIIt9XA/qAc6papFv3LwY5gOsyXE7hLvC5xa/pFXmAAFUpqTnlRtd9DyqoP0/aUTZdYO75bXxHqyKFhV5rhKC892puOxk8Ufzpl12qwiy4IeNrAhxKO58LpbwlocXF7v+a4+aB+LGjoY76ZAUUqq8CFdBqUDFBI22ytGbabw3DoS0HpU7MSvq3inIVmLQFU18SUHid/NxYIPMtBix9PVEuhHW1TIzICuxXoFseSz0LQ4Xwoyh5Re8B5+5hoIDkkzfos8+hVIVqTwN6s/2biAOeHx9cagB8
 aWTsuBoV
 fnabazgAqATLMW6jHh9z5iHaOj4ui41NIa1RmHhYG7fa4qH97PM3PEQF3QvSRNLRDRBMc2AoRS2nTJ1luYiW8G2uSICdwhMdosF/xA1a2724M7okJqB9/Ru/klGvLU4e22/AFV7+EydxQzWxhdHTjlh/k2MWEYxwAnZ9bvatw0fZFtMJpY0svSM5ps8q/yGk3Ydm6ZAS9D93cIbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:12:36PM +0800, Jiayuan Chen wrote:
> Flush the deferred batch before freeing a large folio inline, the same way
> the order-0 path already waits for the flush.

Queued for 6.6 and 6.1 with Matthew's Reviewed-by added, thanks.

> destroy_compound_page was recently renamed to destroy_large_folio.
> So it would be conflict when this patch was applied to 5.15/6.1

It actually applied cleanly to the current 6.1.y (that tree already
uses folio_test_large()/destroy_large_folio() there), but it does not
apply to 5.15.y, which is still page-based
(PageTransHuge()/destroy_compound_page()). Could you send a tested
per-branch version for 5.15.y? 5.10.y has the identical vulnerable code
shape, so a 5.10.y version would be welcome as well.

-- 
Thanks,
Sasha

