Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4F5CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC538E000A; Thu,  6 Nov 2025 06:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D908E0002; Thu,  6 Nov 2025 06:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA708E000A; Thu,  6 Nov 2025 06:13:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07F648E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:13:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3D4C140688
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:13:56 +0000 (UTC)
X-FDA: 84079922472.15.55655CC
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.66.161])
	by imf02.hostedemail.com (Postfix) with ESMTP id DCA488000D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:13:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=aosc.io header.s=default header.b=YBjhiNdi;
	spf=pass (imf02.hostedemail.com: domain of wangyuli@aosc.io designates 217.182.66.161 as permitted sender) smtp.mailfrom=wangyuli@aosc.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGnMUKs+a16xWoar+O1Exr6sx95PE8I4R712yC0kWhI=;
	b=KGPdtCTpysDlX4DHNZa+OjWpUogi3Jkoa7hk3CDMcC5JRWVrqHUurRpJmTXaYAzS3ueSnM
	VQNL0Uk1bzatqyaNAmMg4ALM6UWdFKOp/cnuqx1CAAXofYd4t9WoVida7ovshLcXgupZhN
	rOZcws28y8K9nZaDBWwn26gQYy7D620=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=aosc.io header.s=default header.b=YBjhiNdi;
	spf=pass (imf02.hostedemail.com: domain of wangyuli@aosc.io designates 217.182.66.161 as permitted sender) smtp.mailfrom=wangyuli@aosc.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427635; a=rsa-sha256;
	cv=none;
	b=DAjuT1tnVtUsZdqxBmwX37VmHNBOYsOp+HgnhethrFfm25gf0i7ApYCjO2vd0qiaT1t12W
	dGSVkDecV/d6I6d5C6o5zLk3WWPIHfKIHf3w+ZknisekSM652dZz2lxQfteIIPQt66zECw
	vibSpv6TOqmPbriyaIxhVV2vM0ykluI=
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id 36D643E917;
	Thu,  6 Nov 2025 11:13:53 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 531B140178;
	Thu,  6 Nov 2025 11:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1762427631; bh=xGnMUKs+a16xWoar+O1Exr6sx95PE8I4R712yC0kWhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBjhiNdiuVLW2CQXTAinJ1VIejMNqxROO8nnng8nb2eFTT7OvGtBqq2CPSMkt0kDC
	 VrgTyCiWBgo1acsmGfAX+EaovZYHF2U2/rj2matPu0yUQRTeJVP5SAZHjTBVdkfB0o
	 0IZdJWf+HGX2X0GFjy+iTW8JyLu7NyCWS1K7CBJQ=
Received: from avenger-ThinkPad-T14-Gen-4 (unknown [114.247.186.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 64CED40594;
	Thu,  6 Nov 2025 11:13:47 +0000 (UTC)
From: WangYuli <wangyuli@aosc.io>
To: guanwentao@uniontech.com
Cc: Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com,
	vbabka@suse.cz,
	zhanjun@uniontech.com,
	WangYuli <wangyuli@aosc.io>
Subject: Re: [PATCH] mm: cleanup vma_iter_bulk_alloc
Date: Thu,  6 Nov 2025 19:13:32 +0800
Message-ID: <20251106111332.809322-1-wangyuli@aosc.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251106063424.3381872-1-guanwentao@uniontech.com>
References: <20251106063424.3381872-1-guanwentao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCA488000D
X-Stat-Signature: ud6kmp97nzyzmrqdzqek5i9nzq7ecjpb
X-Rspam-User: 
X-HE-Tag: 1762427634-157548
X-HE-Meta: U2FsdGVkX1/j8K0nBR9x+hj6O7HvF44MZwoIAk+SxbIjM04lAfAa5WAh3xt32eTsd516ll+q/jp5O+s0qAT8tobo4AYRJP8mbQ5kJOzb8qvhhYGFKbDihII3HgapOqiGJx690MBqcHckWk+3V4BUSVfh+kt7GKb66kvP8szQi+h3j25QQtVgVWMwLaztpB62j208am6MG9kQvs0ogVDTLBClgFMEeFpMhZUwmT5sghTcV4ThGpePSOTjKreh2M1SBB+S111KXfdtpHlG6aKndfOjjDuczJgXD6Sga4t+PGrRC+iQDGvVVxdCd2j4albN+mc1Tjr4jF7n4y7XTTcLiZRrTt1I65rrJ5t0PsmGg2oMlqPkuSXydCoSgB+T54B+vM+2ccH/4MBMTu22ZbKPIQqzDEyiq7xK6wlYe6Q2AuIvj7vNbM3996ka5L1CfcSJlsXu3fQVyw513gvoCqByRbDkns00HNlmdGt4gmnnBhnH1EFlhsE/53SLVcIE5/3X/nHKOS/kY+xdiOklOWJxXnDIzYSa1LeTFq9G8/VHgu1zOUHJkmwnB9LzvMm4pNEy99GXGXmcODYdA8dwc5th+9fk41yUnfaq1SjSA/ZIfZnNU5dSoJAe2YuVmoUiNdCZ3kmelY/7Gf3wPIH4pgyPRr4KtQWucJDr4HN0h6Hqbo0tZpJEXTBowFqSKUd9+JtyGi83I41gb3zRTtN8CfotFan/ic4BlF2fKs8RFlWC9iMSNtabyWnHUjcox6YiLCFMJwXeIeuH3WdXfO57dx1QrrtBG4JRDVBmrMWcCDkb6+HssqWaNbrll6/GwFlWO+7m+59IVRn6sEjNQ7fo/vg4gfP5XxVAfQqMRBFfyILM2VPfsZtKdbtyqt7gjtwtXrHIrfX2AGFZZmg822GoqiLwWVv+wNqvKoYrYaloD3BXEkU45eMDcD44Ja0kjA/VaV88ahbdyd2jo3xonPT2CAY
 L33JB+ni
 qlwjoPrgVEWSSgYyjuNfzRfHscFpJa7vFegHQ3Ze14b4tBdWaFoSCkPSyC0p5CvaJKjM072M4Vwkg4ONrnz5BCfCmT6ScbnMHBYGZGkXK0eMw4KrmTvkRNAygwsri7q2BCNJbFGw4s7L8IoExcmvnXA5OGeeg1qp3CquIizz5CSkgNP5D+hmTOzIke0e49MiOKMEu3aBORDKu6fbk+pOoLcBcrJTYlJ+EIAOvh+OQNm2XksOjaoFE6/fP+UFryyQ2SGISJ/LmsJtFUMHnURwlCtbvL8M6XIzCYR7Oyiw5NqlKIlVqHZUokoblP/fkwCB4kzydNOX5uintSGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: WangYuli <wangyuli@aosc.io>


