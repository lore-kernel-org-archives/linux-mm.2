Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B62FF8865
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 06:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106186B0005; Mon, 27 Apr 2026 02:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B72E6B0088; Mon, 27 Apr 2026 02:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EF86B008A; Mon, 27 Apr 2026 02:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3F7B6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:51:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C5A71B8972
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:51:09 +0000 (UTC)
X-FDA: 84703413858.15.FA970A6
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 096A88000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:51:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=XD0n1FBt;
	spf=pass (imf30.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777272667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41mMcEQEek9HQ8wG1p8IAJCVbj8LtKhdJVFeik9c2TE=;
	b=zIFjnVv+oFWMe0A32bOuYh1CR9xfwkDTcd6X2AlPAEkl4R5WQXeZY63mt+c8Z3gliGeRp5
	tg4dLVmUEj0TuOWY0oA36HJ2QFMM12L2Y9hxVjpcXExUJqXpVoXFg+7xIs0D1xH1iQt1cV
	X2VQ3jfQrRB/dnyVr+MkH7PUt7lyQB4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=XD0n1FBt;
	spf=pass (imf30.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777272667; a=rsa-sha256;
	cv=none;
	b=djOkkeSMOO4rUtuv/pHgjDJs1lS3BV9jXlO5JnF9dZRySCUN1E1239Lfd5aajOSJNK2kTE
	clj8PtaKO8KK04/NguOvHIPSPkvpVfpRAkyc2oJyeE+zPOVXk3Y9UEgBrSITljr3Y65zBy
	DTQIc08RTTch8JaXw/4FXFuwLRTwKxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272662; bh=41mMcEQEek9HQ8wG1p8IAJCVbj8LtKhdJVFeik9c2TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD0n1FBtbAeaNwGIMmwlXMS9QbEMjJf3A/oa8irTeYcmSCnqOoNraL5jN9Q/V4aDt
	 a1hqBcIec2bzy99lCHXH58PqTrkqOSraH0635C+omQHBiGP+5r1CSeh8sTAzGbCXZm
	 hbW5Omjd9UMYLGNrHL/UZjFhbcOcCKtMFs3/rOKs=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id CC08F61E; Mon, 27 Apr 2026 14:51:00 +0800
X-QQ-mid: xmsmtpt1777272660t8n1s7rc1
Message-ID: <tencent_58F3A61E5F234437B8168A5C9BCF5D8A1508@qq.com>
X-QQ-XMAILINFO: OOO9dHjlsLs7MEJRXcZ2RppC1JUDtSNcjnYvVGF83ZSqTJONqb0E9R5crTONA2
	 6AJSuoY5ZXAJ22tWfgym4NDTzZfpDHz65OkdLi0yk8q7TphWy/RuMxceo6JN8AC8vvhwCrlHYVoa
	 zksRejtsiNM4X/m+Vv0bMrIK7K1lrOSRHhPVdgBz9zDYKqWyBVK/Ythz65qGzcCJB75jk8nukrez
	 Zw4wnX7ZNlW5vQCR24/eaUyf+QY4Qyt+jCvqR6kNrG2PnlLo8nh5na8s3XyE0J3t7wnS9b0Y8tcl
	 d+32/7KiiWntJrXL8CYIWH36IT7PxsdhfZYX1Z473yN/3xbiNKG7Fg0GjRe4l5LqX3i7GSTtfG8n
	 S+wSkmDvIENJiKgj+F8Kav7QEFzLb6YgTxB8kmmvC8fT4F01gpqOXlC9b5QR3bHLffFcD6nq4onN
	 4vQFz1UT55ljUBWWDubrgNLtfLXj4hxqLhglW5CNoQqi/aYx/jNR1P1PVkfK/xBg31iwJePQvWG1
	 JicVv5O8MDN+XBqpMl863KOSNZQ7opOtqieJ4d0Ckl7BA349RR5B0whL75e0lSil/qWOA90XwvCD
	 D6cS5UCaVYkQ8FdiMZwjSJGKghsOsc55glLNYf5x5yR5ZhJDn0hVMj6PZjy8bOzO3hnSRRo7ftYh
	 KFentOSSCM8ZDRhXvRdTlAxx87bED8q4cNxdBMTe473j63cdIREE2AOlk9iEaeP3EZCH5UQ7ctn3
	 n5PARyKWsjYboudU5elDQuTZdqyxVm4aXEYXHiMlKza/jNvkzg8H50DVEgbPrv6JA7Z813WxGdQC
	 KSF3KBP+nb/c2JUoPU39qz9DX5uZReFSz1NkBls81K9D2ifsrAWneG5e9nuK24J7L3xRrOQS/HI3
	 Ze2QLs4o/k9c4AYxbJN7TdNnJiQACX9J9JHiLmzXKj3IcTimlhJVLWGDidDyzTiqsq3COpOnzGlG
	 jV6sjSLhAt9S2TPn+yfpWL3+fC1WuyzS/X9J6U3zDE9tXj4wxqHw==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Mon, 27 Apr 2026 06:51:00 +0000
X-OQ-MSGID: <20260427065100.2583089-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260426124142.88cbda0e6695522d95ef6e24@linux-foundation.org>
References: <20260426124142.88cbda0e6695522d95ef6e24@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jc5hsu3e3pqwudbr5qbydmoy79r9enhf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 096A88000C
X-Rspam-User: 
X-HE-Tag: 1777272666-427037
X-HE-Meta: U2FsdGVkX1/gFrJ8V1rG34xwCa0OtOeIoKpAj/eQndd8Ad+XSaHG9UXETjHhbIBUCnYZIymIXTzJJKzJ0OO0AiQYGTetZ04WdXhENWU0ud+WaXzI5Dd0eRE8Uy4cS3brjS7TNwquvbouazRaWPyFEOQwMstmAylJvUO6IRBjPMPXl0NOart4vLJIKmaCeltmEKxiK11LlHO6TXkQzMoWc9/JIF9lYo8DvOpe36YcwnSZ+67c22x8IgTLbtcuZRhzGxwVZh6Q3cRQqfREzSqxQj9Mrl4LfMrA2pKblWvhMBdKEBBXO+KVPl2kq3JQUjnsZ30Xp2dHbhu4q2yaEshdAA4w3WhfhUeP2Aw2ARyfjrGNLGeMICHigIDm+PdCn70WQGYx122YlZ5jTLPMGtBzlDZh3qBatHGZLre1kcS6PeoGv4d0vZp/9BWyOry7QS3NucyzFEL3Y+/+pIeWH1oXsbBM1aBR0GKyCIvAzr4KUulTGgJpkHs5I56BdAMgkUq12cvXKiSw6FrCNXuAZj0BvtdkKObMSemCKFXV47/dHC7cySSgaM+1toiaM9dc+YEOmMOEcP3lSiCpLp5wsGloQ8/tmrLmpE0wo7Z/dNnJnV866TpmKSQ05CGqRlyO5Fsszq4pVGgHJYI7NwOhGhN6/Z9ZRVglLiUgFr5/LtB0rIZdAiNF5EVlG8IlIPaKyz//33MsAwYGdJj4tozQ3AiSN1D7tSTndQyP5yWq9hYFsbGxJsgLnYA97aR8Ein3Mfjn70b6ty2z/2f315+tsbPoZ1o61KaPCJp+GvEtbhaGgj+wM7hBc7pka0hVqZL0nJJdWGRP3xN1HmHGMKUtUKxAdf5xO+23ctEX8kLIK4hpJehZqHT7z3N7LNfNotkjqlfr/c00Yb1beeMBGpmIZQwll+Qhy4BEEpuTxgFjfH5TKBIIliXTHLhCjWd/jFa7sXJn0H2zt7SuCC+VlgZDuLa
 NLhEbaEP
 1fooR5wCbMZjrtKCpu8oPGOnT/w3hGk7RJr5SsYqZMoHSdP6OZS65KnYHug4DYVgpuru+MLNHcEmuj4DyyatKdLdNzyoXxetVGkEyAsX2vw4S+hSqfnE2WbdzT5KhtiB8E8ni7YUirG/zZjs8nxsnVgI7o6js7Cv0sWlmrZYweMTruLVvuH8ISuMQARMOxkm4ytALbbIM5hQkgOMl7CCWCGPsuabE+N5/E2R/+qJZiD/NxcB8JsSkcRCcYVDgYKEM2yHfCXh57EUwgKKZMYXiVFz6ytVKk0IKv1T+S7PUBR177KV3xyRxdNPG0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 12:41:42PM -0700, Andrew Morton wrote:
> Seems inefficient to be checking `behavior' repeatedly.  I wonder if
> your change will permit us to remove that madvise_behavior_valid()
> check from is_valid_madvise().

Yes, I think that makes sense.  I'll look into preparing a follow-up
patch for this in a few days.

Best regards,
Fujunjie


