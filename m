Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B7BF44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC756B0088; Fri, 10 Apr 2026 09:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4196B0089; Fri, 10 Apr 2026 09:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0AE6B0095; Fri, 10 Apr 2026 09:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39E736B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:53:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8F5816056C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:53:23 +0000 (UTC)
X-FDA: 84642788286.26.60B9483
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 57C4320017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:53:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDkqlpeg;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDkqlpeg;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829202; a=rsa-sha256;
	cv=none;
	b=GwL9jFlbV9KC+IKFi0aZPUjecsXBkkREcoXI1YiH9VAMwdRwd5vKZtsXDBEkBRbv4R0uLG
	3X+OXzctFudnMPjd6QxkMVHZKnYMSe1AbY/hcRSM+MZ8knq/laxTb9j8vkUSbLw3eXQmyD
	yXGNC9mvuAX6/MSwN9aFGh27dzrcUt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac/FVgoqRavT4ZsEF94jgYY90cu+5WIrYb1+W5dGVtw=;
	b=wnLANLGXjxKi8ht8S7PbEn1zeF4vh7BCt9kIeUFVZ9URrGZQOmrvMeAhhrNsxyoSGXC2AB
	BKyIP+RbTtpwbWDy4BsjhdBFo2Bz8F2yV5mVGqlAJIhO2/5aSbgh7KYAKDT0+snxYXArMg
	bYK4SqqkPCVxgMe21Bpl+sWK8xFm+Kc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 553A7443CB;
	Fri, 10 Apr 2026 13:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D531DC19421;
	Fri, 10 Apr 2026 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829201;
	bh=Ac/FVgoqRavT4ZsEF94jgYY90cu+5WIrYb1+W5dGVtw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDkqlpegtnrnrb11OCV1tKhQEPk8uZPRaaYGNGvagrocnl/zdvskIX+dIzoNagifX
	 aERYl23i9v9Jsy8RAsf7fY8k1ZtSAoY5M4ZN3zrZoayQ/R4kPDNVZbD8U58EVU2xUC
	 zj1/LW6rpWM/vEBkH6XdGUU1XJvMcW5EvxpQVJ7HCDePvXWZgivViAURRLW1Nn2xV4
	 w0ETto9Qhrhk0H+65KZrdTUTwRiI9rRZ9r6/mG9ohiR+jJs5uNVfwh+8ZqOhGEi8vh
	 Cb1ME5Qix1gGcEQVJimLIhoN+ydkn8nOU3EBTSPHgmsnUOSXg6V7Ya5mqHp8AyJCEt
	 Rr7dODZ40IIaw==
Date: Fri, 10 Apr 2026 14:53:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	chrisl@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, harry@kernel.org, jannh@google.com, 
	pfalcato@suse.de, baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 0/9] Optimize anonymous large folio unmapping
Message-ID: <adkAgFpkZm1Ff_HJ@lucifer>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57C4320017
X-Stat-Signature: 9uqdr9mrw61fmqfd5otasacfxc89guwp
X-Rspam-User: 
X-HE-Tag: 1775829202-212245
X-HE-Meta: U2FsdGVkX189HEtcgM61omVENgDgYbK+MeZz+39KHc45YcODsFHAac6HB85MewM8Y9KYkfgM0EH21M26APhXhlOd+Gsg92LfMrmWnZt6Dc9zWfcUmAPZwyqmT6QDQE7oxip+ObEbwILnOmw67xaq6BZe7T3XoRz+H1k2UvygqlLl+N1MgSyUjkJ1Fp+cBNwdnICho02t6o04P/8Wu4R30rCML7CmJZv83E7llcKhrSw4DkzHvWG2yHVfG8jsfar1Zsr6+jscXZ2sGpTvGZeEJMJWeUGES/JhB9TGF2PgSayy5/qihJ49n/XsXy/JZwWVdkpXgpSOcuSsOQ36t3OuvDAbfalDxuVfasXSlOSui0ayuhxseNSmNo+ktWYGNdvoF6Bj1pcnK18NDlR4V0dc/euGJWVMpzqC0IhHgt9PtOENu50HDgBH/8KHTB1/bekTtzblpUfe5oJJS0v4zFdbqsIYcvODEVsEuAD+qzfSccMclR0Zu1cMiwZD0xC8UMTXPpy+92u3zmFd7D3hVZQnLPE0XktXRynhs7wZW8V+LNCugfz4jrIV9gCErGqpqNiy9KJkUnVmaq4MVpFhtJRQ0vJvMIZxdSMXJoVY6gz0K6KX24oVnQWzjmimuibEurvu50HVvKiBNuoDI7bX2vgvmMIBP+TPVZsHICtW4OKXLiZWSCF/IPXbWC8eMh9jWHpezezFByTc9vb0HU1ky4MktMmal6afrF0coV+DZ8KjcO3oQrIhqb2oVO/QvZNSop4//Piye1ItgVURPdrAHBzgHYwF0gxauvwZZL8A0zLp1EfhK73eAUaP2SjysUCkIxi41jdFMKIcYsQXQ36jmyUUeKevOpHEggK8z54rV9fyjhytMyWAaP+cEP3j/TA44wdTEMch/BNBfn3uxL/BGKuEAVPnqQWztJfzNFfkg69YNsxBbnavh57NRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Obviously this one is for v7.2, we're in a quiet period now so this may or may
not get review attention before v7.1-rc1, at which point please resend the
series rebased appropriately :)

Thanks, Lorenzo

