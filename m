Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EC0C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88086B008A; Sun, 26 Jul 2026 23:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38DE6B008C; Sun, 26 Jul 2026 23:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EE16B0093; Sun, 26 Jul 2026 23:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF72B6B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:55:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E96CA16DC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:55:39 +0000 (UTC)
X-FDA: 85033192398.01.CE6DD27
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 53C3480006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:55:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=yMzNgfCV;
	spf=pass (imf02.hostedemail.com: domain of shijianlin11@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785124537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNhVt3N8faPHC3GjrXv1Ky4JAUAzG610DpMGZjSIeIo=;
	b=DIYtLrqO1k7r/Bv7Lj3zoLykjJZMg0cCHSFuTLBUdTqWJZAsDp8xGHMJ2H444Vcwtw2Pke
	hAP/OTn2WOIHUpHO9HvLwWhWxTVwVbA+gpbVZhyeOBMlM/ZKJLnlxZyKXgfIRXumkc6Ek8
	hhODdjumx4Apn2cLc2MDwipPAFpqOjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785124537;
	b=MnIYI80TnqVxJvu6M1JjnWfCZlQvTYrewosCXW02cnLCnUZ8rTNEtsgNURw0yEHEWmruT3
	NFBLwrB2+PfJBN/x72X3lNtTeJ9RDfODJ+FQ5nQZC2hlfrRjFrZ3uTRi0D9pNc1vrA5+li
	qZq+yzri8S5JNt3F2XgMprqdzel+feE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=yMzNgfCV;
	spf=pass (imf02.hostedemail.com: domain of shijianlin11@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785124533;
	bh=gNhVt3N8faPHC3GjrXv1Ky4JAUAzG610DpMGZjSIeIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMzNgfCV1aX8i8ZNfqkchCy9bao1Cnxevex/qB/AyFxlqqeXd/j2x+wOL7FCR1fOz
	 +foFoth9iwwR3kOyDJGd0K08eIPT5l0K7jFlA9Tt0PdPMFZ2Al1n0a2qI/XVKJYs9s
	 Ir6myccNUkeqVulSyICPGKU5+XidH8ujXIBUMNm0=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id DDE3DA9F; Mon, 27 Jul 2026 11:55:30 +0800
X-QQ-mid: xmsmtpt1785124530tk0yrui4x
Message-ID: <tencent_0568926E157265E58214AB5ACE34DC28A706@qq.com>
X-QQ-XMAILINFO: NMiAo2azIaDA3GbxCyhJHR0h9a1Jc085fVBeCrj9nhp5K5qogbKwn16pA946vY
	 5c8JkT1b/S8KgGnOznTqcnn9l81i9xwpZwUrejjEU7nigcTIGDXWPdxM42rxIDmsIfC4vJmIjtnb
	 SInro83c/YERDRXm/BGOskir+z/Gt7+yuYVNeuIVMlpYhmAUGH8C4XGZ3cL1a11ldeXrgXQCH+qk
	 8scIatOu5naHkC+tDKWDirmwHVmExKlFx9cq/CZ3pTplbdUrmp4SciGRIfUaJMDMT3U6kJb/L5zb
	 lMb4qamK8YVfojEkFsArZkA7z0Y++fR2gfuIJ68vu6h9mgl6CbXRy+K56FPOKp+OVEHhXwLFkvIe
	 kA1B9/VB5FOGKIF1Y/O8VCVV/xiO2lQQP8gw2tOgYq9Z/JokshLOX8fDT/fTE8TMMDM6cucb03r9
	 kbUezw6pyBIShJw+mXA1dsXLqeWT+KuOhjVKlxfPqyPz5A6fECTFcgczcjHUHgCYYFGlbHw4PWFI
	 jTXpId+8RDV1kRpdtGBVO7Z6RaaCJUPiKTdZPoODJqCzB4RLGCZgaQ+CBr/MgwQkfMCM5t7rGmaN
	 F8z5jc3PyCkmk2Vm4HUCmSsgmEFqcNtAW/fRVmgKnDlkLi7Z51w4nx2buvpP4+oXsUrovEHLCAgx
	 +RtNtDlykffCmGG9JGEK1uyvJMzeIQaI+hXEkGMs95nOUItl9bTM1XWLKZqs/8tM7xNFwKT0lNNT
	 yhABlvqZGVyUvBu+t51j7BGK0+ZtkIxskuW1RRrajpTRgmmIfBoiROX/5LDTqxLucF4ephhHz107
	 RBbAjWGdRNqLI41O20OhSGNkWXqsnKIyrv5FmTJvl8+CGxF7b75c/uHuWH+bE75caFpfDnE7V46z
	 Y5zS7ACIIaW8EjTrm3JjA0Aslh3wiCmXD6d5Ihx9IDpELLWdFLvhfO7fIq923i0PdDqfiBDdxBzC
	 hV41CjJsybGFjgCwbt6wNRGAthVZfcaIcgfh1sFvd5bdJhTMGZKWZQjVQUolOPrtQ0YV7V9KJmVM
	 /5CQiKjzzSBvQn1lLf+oktfnzDk9w=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: only update NUMA min ratios on sysctl write
Date: Mon, 27 Jul 2026 11:55:30 +0800
X-OQ-MSGID: <20260727035530.1151593-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com>
References: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53C3480006
X-Stat-Signature: jrkdbbacqcpopxtge4xwpss9zes4h976
X-HE-Tag: 1785124535-486055
X-HE-Meta: U2FsdGVkX18xpxF4OUIs1w9jRXw1hj5Gyfl0nVw0X4BisAx5N+GXKgOjpC7qH2OlfKuA1LUWM06tzjzHeOcBMNSXH3/5d3EEEap5uzbg3cWbWXcFRl1pplIDBDs2sXYl5sV9BxNcwJTnRYK1XocyIqb/pyiAyAq896IS4ZpdlxI5jJdGOtcoqhYgHWNBOeP0TvnjUD/19x0oo8wSHjnre+G4JYmTipEDCcuybCoCznOQ+/ZHh31fYvZedPK4gFY1fdTyh3IfB30GVZrXQaNsDqk8fz6cuZ555XNNagV7alpVJkgf+CyiTTEQ07kpsojxRQE1F5ewTQ0pTZanPzrQ+tvajvstoKDbHi1v53mkvF63y19s4O/IIuriOANl3+7Ka3qLhVXhdc8Hh+t/RWyanXDH1aNL5yHXnw3fA1VCQBei1/sLnHZIB3OlUz4lKcPBe+LgZ9ZyreE7pjQjwPKCLJQUYA4OPTnAFFKzoGxj00I2TGODqMwk8bh/uIfULQieWTmjU2lA5/VGEclOJn9pGpzuUAWm5yVICSckY7me8UZ0LMnSK5Frgvg/2aC7fml/X2Prq1XJ7WE4UpyPoLKouYj9a1f4p/xngSHyAt7tr2pDjrkCdT0lVRx8bhMH/pCtbmT65dIhpWFrjiuYAMv6GF5oMj8vyTVfz+K45ix8lOOGnSliDHpPy2gs6aVxNDxUPyKV7aOL5IMsOFzLSyDHzkwLxL/96kY601HQs/dUDMf89IBjWYw4V+9T4PQRtI8P8QD1hOIXjoN1KV/Cx2rf0rMGqCE9f4/HagK7OMFkfM/LD7CDUVTKO+1VXKPTaGKtQv1SOYDSmOwI5EKg0TyRK6hDsY7W35GCTpVpMUTJCjxfrdlF5vOVT2HUL7ZyU0x/8yoKC2RPLg/xaix6uc1qEavV4ZunuGZoavh2uxM2ZuutjXYT7NyNDY0hrNqlSxdNWBGg6bibPUeYd1qmq20
 WOPA955V
 rfZV2di+hQ6dW8PrXAi+Ryd3g+6ijbRv+ha0eK3fixb2T7wwKleHHaMxcFHRCwVOvpppE+4Q4hQFYy5x2hi26GEtXZMnOqcHz3xuj4NuNSv0bcGR9LYnqTkYtU1vRxJi3zgdm1bLGWaLiFThTreyooQ/C3rshO8js2pJVE8PabzrjRvh1Uh9bTLrKBD6QmDGpPmIiTP+fBUK1DK3BMjGu5cQa1nQNPYh7BKJK4nfQNqz51zyvzeqYKOSrihMkbWaK+KZckU1RDGi5I74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Friendly ping.

Any further feedback on this patch?

Thanks,
Jianlin


