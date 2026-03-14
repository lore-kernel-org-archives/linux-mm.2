Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B164107BCEE
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F776B0088; Fri, 13 Mar 2026 20:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CC46B0089; Fri, 13 Mar 2026 20:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E676B008A; Fri, 13 Mar 2026 20:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5052B6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:51:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FF0C1C51E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:51:43 +0000 (UTC)
X-FDA: 84542840886.29.9424B02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 474788000F
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:51:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUVw8RPc;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773449501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OWFP/yBtS9XqNOLU1HW0fExRdnGqJ0bAz8bsDQQtMg=;
	b=fn/feUVfcLyN02eWVPNF4tr3mUMi/U2PX5smiXUSRkbqyW/XE9qTkiV6FFMgUIxq+ePCiI
	Z5qdTuTwEpnsljCJspoPju72ryYngy3EB80eks/2ItFE8SXiKc966fmTKwAvZowAJVP1/y
	b9bGorapVx3drP9A2WfKcVrjxA46dZA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUVw8RPc;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773449501; a=rsa-sha256;
	cv=none;
	b=cK53MR8Y4AOSTRxDQTORQNjk1MqWi45PZ1D+Xe7AgN22J3Pl+ocwGNy+xRLKWPDwkMeoTv
	GPnFjdV4HjQD2Gpwva6ptNL3fp8RtxLEEEBPf45F+2HjbVfuUyVnNzAsn8IWIWrCq2UYcO
	XsK/1/qqtzyOXc6bdLiVCZf6JXrpxoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 946E760131;
	Sat, 14 Mar 2026 00:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2815CC19421;
	Sat, 14 Mar 2026 00:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773449500;
	bh=5oFToVeccDAd2N9DgEaFKQkj2YprgYCHqwTI2QbU0Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUVw8RPcEnZ9kdFwzRj9eGdZRrAnx8Lt8bGndKPK3aiA4BRzgE+SCWnsWPMRiaqvN
	 ubfz1jYBIthPu7W0fr0Z/w13MYZ7ZE7PzNZ2btspiU7B2zkucDcBWFMnVZw4wV16eR
	 7Rq5JyeK3eQU+zCbnaCviVEFtkcfAAQcb3svcgGe0loQQRx2Z1Hw1uyK61v7Lk5/nL
	 jN0UOEFqcwYgyWPfTFgUVA4j1+Dbrmchq7a/r35GdTHyxJ5upA5CyPgAJAC6NjUojr
	 6PA46gIywrB76Bp0Zvft8//idCGLjyQ0kCcIJXHq5oU/ii8vfcEB09eSU6WpRrnHRS
	 kXmHn/QDCBsjA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@list.linux.dev,
	linux-mm@kvack.org
Subject: Re: [DAMON][Question] DAMON_STAT and DAMON_LRU_SORT module parameter conflict?
Date: Fri, 13 Mar 2026 17:51:31 -0700
Message-ID: <20260314005131.80825-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313110953.37465-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 474788000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 8gibg96fimnxzaiybqyxs19gq8hpk15g
X-Rspam-User: 
X-HE-Tag: 1773449501-555130
X-HE-Meta: U2FsdGVkX1/BdSolZoWpgrBecqhPSiMMS18wCaK8/FLnU+NROg/V5DbZHfBW2Jc299x5lv0N9LoxwQ1t4rJs/fLpCx7rqKmlxvXA1it6uS1sIDyisWtf6nikI5RMm6yNaSXnHLuumErFphdFpp4HDbMAGFI9rkTzjUS2Lifw+vzIHF3or5xu6MUbv1Vz7HYxb9gnp3IUTd521vZR+xHV4fG/6rCpg4FQmwaHjQEHeR4Oqn5HK8H6FAWSa+j4L2RGzO9QaWppOlWQzw9B2hysHJ6hivojbWBqU9euEqswRI+tdc3Mp5BcL/mXFvf9LvkXXKE75OKkknLcwqZTKY8XgpfuQEu5+iaQ+E0q3qCVVgdCFQ0SBxg16V1OZqCa6YS7Hpgmuu2WfB1Sp46nHHars288gjqtEyGmFbyOWieOaNJFFMc5WfhvlODh4tLLVMottVTudM6E0rNBMMUY4MYXW2EtVXNehmq5eemIZUpNUTF8t66Qfd96MlvDAEhFAEHZ15//8vEXieiuSU1I7RQeQ1RT7CXu75FvCHEvGxNPJlsvqsfC1MLBaT+NbS2A+tWcE6mH++Op+yJX3udDVjZHwXwRXI+pLUssoxg1+iMF3vo1rw5lJl0QJeL0UkEurv1lhoTjwy10ULex5tDSIwJl0Nh7SaBg9xWSYwAPF9IUWnww5pqWnmcsDafjefoW+9m9nqd1AjHpPUEEcQNx1AXh5YNl8gj5psOYlobpIX2FT4yDuFqHE0Ak2UpRPddw2K5pW0LhNP0ycen1fy8qsyELvmWUu5uBfQaRQhNar586JbemMB2z9YZ7r3LI8kCi1H3INTDtC3cb0n0g5IDtoRXNaprAVQwIZIO8VeDhf0L2ruIIM6Tzv0M2dB3XpjlLKdZAX03Oa2kJtwjvqZb4UcloKCkSjCBCUOkI1FSvLxOb6Ac91P5rVu6aXI/md+e8ZnT1H9smvgQneEoBLKm6Acv
 THR4fhdO
 YtpE9IXp/Mhq7YF1bcX+OwWkiCFSZfaoDIUmVUIHa/7VTwWMp2tV8L6hlZ081IHfoO6e+NyIjctz+oLmRRsYpUoOYDAFIxfQ5qLC0uBjd6BVmfI2jmtvslUxMMRgcKKyZAEMN1Cr9QR1ZtSEftWr9XFW8NqzdQcrtA4mWpcaJkU10bAt8b+mnz44snwCHKdkpqMH182wnU6F2At7VhnE6a0tQezIKwEqsxF2aYv01nzI7JCnsDCqMPNtSfw7+xPmsN2Ky8wJq2BqavsQYLd2WnKxOIHRRjdnFZNvnw5DTIwg0ntgSacPlFryt+xThJrb9G6cMPwz8qZIPOEoTHZ1SjDDD+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 19:09:53 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> TL;DR
> =====
> When CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, enabling damon_lru_sort via sysfs
> "enabled" parameter returns -EBUSY. Is this expected behavior? If yes, should
> this limitation be documented?

Seems this is a duplicate of another similar question [1].  I believe our
discussion on the thread answers this.

[1] https://lore.kernel.org/20260313111702.38667-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

