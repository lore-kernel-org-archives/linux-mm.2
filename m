Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE29CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 15:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF126B0088; Sun, 18 Oct 2026 11:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FAD6B008C; Sun, 18 Oct 2026 11:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275246B0092; Sun, 18 Oct 2026 11:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02F7A6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 11:05:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68B49120553
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:05:58 +0000 (UTC)
X-FDA: 85336071996.23.DDEFCDF
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D63340008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:05:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=eRlcKfG4;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=BvruNTxp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792335956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42GIB4EF1Cmol4K/G9B35dhI5HuTBXj4CSGbnrCD4+c=;
	b=BWcN0BF4wEc6Po7X83Jn1A0S8kXTKxvOkEA3sh+u2xkLI5WlDKY7YmoofnYN9MOIjvSlX5
	4bLG/ODrHW4+EC+8FjzAjsPoKwI7dkk8Rwlqa1cSRvHhNR1M7zT7JrI2CaAQk7XtIgZhk/
	KUV5HMpefHexeWj1/mcIv6BflVWrWNo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=eRlcKfG4;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=BvruNTxp;
	spf=none (imf01.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792335956;
	b=5WQLp91c1bGalxYPQJhzGJL6DtLMHUc057COMIliZAsUOiWI1PGKvP8FxIVM/KQpY+WNUi
	4vOnuaCo9HQHhVfTa+H1ozfXEL1iYErVRt6nQqGyyRQJgQtrmQVShUHxhOp7xYXXkXcTJN
	QQEOygGrk1HK3QO6+3D5L7dkH3Mv9UI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792335953; x=1792940753;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=42GIB4EF1Cmol4K/G9B35dhI5HuTBXj4CSGbnrCD4+c=;
	b=eRlcKfG4sQQGXsB5DSf8JsUHOamiYeMUWDVLNKUCdHr8matOquTWQJSfFRKUYbwQZZrTcACuoU6JS
	 n0OQ4IPa3zYm3eXbopk5wi2dbTAsazImLsVbf6m9A/aAG9k3s1x4NY4DfmDqRAFFRTTxvkeJVP6owT
	 NjjGwd+IeUHPWxrrPAKK0eWE/o6z8odrdkFTuTJFLl3A5vfsNsneYfTXOr5mYZaRRNAoeu1tjlmOES
	 xEguMVkyzPEWlIyhDvJS98Ks2ISt0dnYjqnuUWvt/bx5htWs7ZkEUsXh/0dMDtPvwYfgp0FsvLhvki
	 nF2cEHztGmEJjU27EXaG+agRNZcv0gQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792335953; x=1792940753;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=42GIB4EF1Cmol4K/G9B35dhI5HuTBXj4CSGbnrCD4+c=;
	b=BvruNTxpw062T2ILscHjttL097ild0JkfIrErF613G69TLVQx2znAvmL27FUhXdCZhpR0Tpc4M55z
	 ez6jjeVCw==
X-HalOne-ID: 690684ca-cb05-11f1-81a7-33fc7c51c1c8
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay3.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 690684ca-cb05-11f1-81a7-33fc7c51c1c8;
	Sun, 18 Oct 2026 15:05:52 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	hch@lst.de,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nickolai@csail.mit.edu,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vbabka@kernel.org,
	vitaly.vul@partner.samsung.com,
	vitaly.wool@konsulko.se
Subject: Re: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after concurrent resizes
Date: Sun, 18 Oct 2026 17:01:52 +0200
Message-Id: <20261018150152.1464225-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <atJBK6hWYh2AqXwK@thinkstation>
References: <atJBK6hWYh2AqXwK@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x3ti1wd9x7j7zo63gnrzy39bqkw4ah17
X-Rspamd-Queue-Id: 0D63340008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792335955-709913
X-HE-Meta: U2FsdGVkX1+QYvdKS9WtyJp8uHracPWC/qnU1NSaecrm9Gudgr9+zU2b+J1oARKM9XOWhTOw3a0609f1tFF7kTMRt1cpX3Y+xwxJ+8exbeZNUiIVKBPCKoImWy7+csDA/zPbnSnd0OTH3CWzgop3DbPkmmX+apveKt/ecIvvuakx3PBtVCHRd8du6WSDUjgrrCBhtp5hj5ijx1nARh/0jYrCYAWxGoEmu6KCB//Ka2e0gwACg+DofvU7Y0dsqJyrf2MzAZ++7gDe4MVU19MzaukK+SZFOs0BVsmw0SY3s0e+WySufO6JPfil30FlEhtb1l3+Y3vkPj7ea/fNfgIGzRHM3ObP1KFxGKKwGpLr9oEl+45OaqVT1j3p7nsQDdRajua2CZfxYFno7vEEKNsum/ltidbNdxykLQRol/r0Feixi98xHGyw6+AxH9LqEqNEUlMDW1kWedpetQDq+16eB+wRR7Z8e4KlXC7KWmCCPiUTxw9U6OcuK1LSaTRaXL/UMHYQJztYsfEbUUKp2jUtTNrQCa6vUWr+Wuw8OMOkvLm+z+W1pBNGyBxIPIvkrRBvkRjAgnWcOEZjTae/F1mWXQMoCW79yuTsPk99mmYdiWkcVtMgRar2kwIeKNuAQIOsGDFkrOoINSbUORuUPxlClo+oH93W0Lsicmgb9WgwmTfAM5domI0AYlduOEs0kzd4LrrJlHbZsaeIZgeWVp5j3wXHmnBtFX6ZlJiaoJIe+ff4LB60clpDWefA3rlw9vo7eHhWL9RZrluCeRPmDPSm+Yq1MF4Y9posI8j8FjabUMtmL3/5JbRWBdFpnKq9ETYslZh4fmTXdOVFoYZh9oB4RbX4g/nGbVo/hb36ByTsZr2aQY+++wRkMoYYxDoe3g3vf9pjswiRNp1E51VmBYjCg+1IAyJ6vyejoJnfEZ6Exd7W36ip74pmaGw3mU8xo+v17Qcc7SBZPVSrlYFUrP1
 w8Vdu9SN
 uTmHStGwUPqs5OM1HDrlLUpaZVW7ZXLkQXa6t1S3XQcYucusm1AwvAB4IUqminzSs06mN6w8oGHk9uNjiochyQFod7eiQjHC35ALN3f2yx94XZEqpmAVK9/coAMhFuNbl76Y0ePoKjnORcq9W8jcsAuEQtWjBiPeXhGxw3XDGRMGudYiq7YTWiZXplT4eYEYiWqIAqnSa6I/8Fw8ttPc1U2ArU9nHXHG0kqLtg0D1Wmaz9PVVVS5TodfSPaBZaZicnILEBJCS9Pre6on+Xll5bwANTeQNEdsuxjK0Zdfdg8kp3nS0hQO120uSfeDuBQ3U1nBsUW2agIHn14Ou7R0eqJRtjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [+Cc Christoph Hellwig and Vitaly Wool ]

Thanks for CC'ing me on this. How about we take my patch [1] instead since
it isn't prone to this bug and is a nice optimization to the existing
mempool_resize() at the same time?

[1] https://lore.kernel.org/linux-mm/20261013091408.1231786-1-vitaly.wool@konsulko.se/

~Vitaly


