Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D58CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3C36B0005; Fri, 29 Aug 2025 12:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664AD6B0028; Fri, 29 Aug 2025 12:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BBD6B0029; Fri, 29 Aug 2025 12:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 468E36B0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:22:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6C8813A971
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:31 +0000 (UTC)
X-FDA: 83830312902.23.564B0EE
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id BD59CC000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=PvwfwtaD;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756484550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gq1giWJsUjnprgL3GS+9dVU3raENqscOMd2Do9VTPCY=;
	b=74juZrqO+7azAayCJBpyrvIneVzzj6mMH+O+0bpS6nzLchLkYQeojaFz5YDcFWL+ZB4sHI
	EkfRb8c++bF/PeONb600sDApGSceA0S4IVhzalRxkxbuS2XJIdhMgkXhwAjEg5E7L5qlOJ
	++1+0fiOyv6LJIqf5Kcvl1QN64HdFj4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=PvwfwtaD;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756484550; a=rsa-sha256;
	cv=none;
	b=Ege7eHYFiz0IRgm8pL/qNpBACAum/MlxPvC35ZffrDd2UpGi8FKA5Wg3XSWL4WpmqIrpEE
	c2Lk5aYYZFpOkSbvgEpzshuFRYgSF8s6D87/JfdnijfEePcfNIO0fFUz0Vr73r4XjYUdcr
	nAYHEqUW1X13gEpbiuBREJBjPTg23ZA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b0c8867so20303705e9.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756484548; x=1757089348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gq1giWJsUjnprgL3GS+9dVU3raENqscOMd2Do9VTPCY=;
        b=PvwfwtaDGgUgU/hnXorJ/aAZ4pJP3EJHB/VH7gbRM2OdrKfGeATgzdrO0rcSQ1g5g9
         AQPOpAmFt2l44h+ECX+FSH4KVyTfkOxRprKA0EuyLpqtUWhf9s5nkMRaMsDmSIhMMo4p
         ZqOQgWk2de/antfpqlYTjtI4K7hsibC/6Ifu3d/23XYKxAhcdMFxNrLkb+hmQam2iAJ7
         7vSwn3v6CswfGIUXyfv0HJIICRNvioWuIiP+nIrN1yby+TCCPrOgyirNU9pl+xCWh8jq
         eisY+e3LJAMBMsZCF8TPFe45HGXW/fDvZ2VmY0zJj6LS9DFCBLcoNGvpgkKskqGDqzft
         vKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756484548; x=1757089348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gq1giWJsUjnprgL3GS+9dVU3raENqscOMd2Do9VTPCY=;
        b=bgvtrO395EtJHOiWx29xMeXYuELu00hnoPtH6s/xLFCzv1Oy/JMA2BUqvYuvPNeYRX
         VjJYyy+JtKwTiPd7GE0jokFBZorjNlADxU/64pYu16flAgjK5uHIG5XbjtqYSK6c3jS3
         JvbbX/EVS/rPs8yJl6lXY2APpSudupVClARZgEzbyMA0gwo/DZ0MM5ahuG7UKf6H+D+8
         k0+jVse+sW5giI/vhmv/xX5h5oAelRqhgXVRxsLcrDRxzuPfFLk0jpxwwUbv1e3lzP21
         NUzi06e/lrSDxE7vQFdmbZ76+Gkz8mb0gHFm6XdB0+AvF56z/es0VAmmci6/koX4k0EU
         ysyg==
X-Forwarded-Encrypted: i=1; AJvYcCU71a1seG/b4nurwoE2vGF4epyHXZunJgZ5mt9IxflWeglyrd0ZtwczGEvf8Jzbs1o7EbCle7KjfQ==@kvack.org
X-Gm-Message-State: AOJu0YyBDbQeMVK8GGOWcSFyaMIUcOy0SrG/nuzQ07yyuaOoean9qiJ5
	yOuVYox6mEHl8NN2OuGIY79xZPaFiCFc9Z+VS945dQyr7S2iDjVt+muZVEpFpxWd98g=
X-Gm-Gg: ASbGncu4cxDPgbDqXk4w83pKShBgR8rvyStFr93XbNTxxffz3UZRB361ZSgvEy6jnZ2
	sLTWy6wVSpXX9GNJq4HcH359wNCvPL7qaI5WAs0R4RGj5UzHGux7AbGaCGWXn3aqOylhAUl30Vx
	XeeQXt4WLaWnrEZoIVP5yp3Ow5FCIBsaj+y8s6fpHv8J5tJe+JzatQHLeiRgn3aq8KS6mJwvArb
	7Fot0AtPfCvVIZFIkYpfzqwE128ha6eWFkW3g/Z7Ox0XxSSfqNH1yJZE3rpxU7bfvTDgON3EwBP
	ozyxGl8D17lI7xXQXeHKL/MsTGwIGI3tM7AziN0iNJpJR2/rgsAva8lLtC96UbIWa7q0o+pafs3
	+WFU=
X-Google-Smtp-Source: AGHT+IHZWIfqgvYtW19pUMdEmDIw2QMzqT/iN9KHitqW3NbObqaxx+9cBOKOGWjP5SKNXmxENmlFvA==
X-Received: by 2002:a05:600c:4f03:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-45b5daacd8bmr160920075e9.2.1756484547804;
        Fri, 29 Aug 2025 09:22:27 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:954])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6ee66bddsm125489115e9.0.2025.08.29.09.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 09:22:26 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: remove zpool
Date: Fri, 29 Aug 2025 17:15:25 +0100
Message-ID: <20250829162212.208258-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD59CC000D
X-Rspam-User: 
X-Stat-Signature: f3c3k957y5zqnfqwrkgurhhmeqo56syu
X-Rspamd-Server: rspam09
X-HE-Tag: 1756484549-626872
X-HE-Meta: U2FsdGVkX19lhBVcXSfe2mF7DULCRicDa4NGoWcaHTG/lUUdGoEzxnyUxY5guN4EMP70D84b9QRmI+5XNMY1ifu3u2/PAIWcUkzf2r3YTuk3xOIGRM00zPPCvAh40BcJkINjYDTyQS0RittN+SG+H3IIki1kabvW+1BBZ96KBbuZF/fyGDUBYzv1PVw3qCZOVfsK8EcgoPXwXHhFtIgI2DAIvx5KjWtRWQWSj2+LWYaYa9vn4tC3gWHcMC6TypXsRCXYyUn2T+CuYHOe0cTj9D7pj2tTvnseYdEz0MFY0BXwsxz6SGWe1GsVyrPVifsPGSm5wxZBisvlStjye2coTcMsN2QqSs7fjTJw6gQY6xKj0BzLTj83EcsRxBfMxnpK7+mTdU7JEN5R+uMXiN3abtvyfKbBVKgTc5gUxO1S0D/gVKU3hOfkHWLMojCGyWaOZUJp91R04RQeHnAvTjeDeD8OSdxly0MFj9e3pSs+vm2SwqNpOxtEpKnluLLJX9r5C0AGhAl6aKDGQFmgMtrgbbtwiO8tTtrp97NOxsd53pSBgnWSjnwDCGG9+3kuJOG0RbZKJ7LPZUuVsNS09Bv7yFuOlqddVjAuz8aofK/UWtxnKFPP5pQ117vr6IlE9HuhL3reuZ81QoEyi6UTy9BmqJoOKQxOvF1G+i7axsX5/sgHHhQLJN7ZniINhbgNDEpddldpT6iZkbEF+9HStZALR7hsVZPHwnWkPDmNcSEVYRkO6xBGOsTp3fR+oaxvsV2DIc1XklSTFYN2BMcgRjfRC46hBJbhoxwCv3MoLy0NHqGjsLkLhISjLGfLLkCGAExNnF0jr7RnNt9proPnWf71fJUoqOG7eSI0Sjk9kqVcy70Opqn7zwIperZACnCco2OThpDwpe1CB5NNDT6EcmVuTPNdsnQLw5ZrmJrfk2cEV2Rmut9sgTarCXY5RQDBjO6qqQSO7dQn3TOHk5hfOLU
 Sv5ETf9l
 T8TJ+lx6OLZueY66GtGduGF5JprpGEObEhdjTDEM7UWcIDozJNH3xaGTzhzzidt3wmLS3QowS8D0CUe7CnUtqVvqnQA3OXFmC43x+rvYDS0/wbpya7ntMaydEise6ppO3xcIoJ4L9t78vfL8lYtS1GKMxGpvWgH4l5RSv5FxPeaMPC/CHOBsDFM0C1DNHUj2QsPzTXUWjQICOl+A50tLpC9u6F/26HyQdFA47YGPcjAIRHcex6qGcm3nnU318je7J+oEZSzy4ydfa7yVP++jvU88pwpO8cbdXvZ4WDa9ue4Nojf3kAxz8HmNn/2v30axHPQfLulnzPl8GjaQjOc5yCFT3BJynceJ8wRhAzS6Xp9LPFCELNNK5opCfnSYswtbBiomP291YuHagq5maomHY9myDKtj+XNZ5hBY0B+w4Urw92+k3+oWFMbD17QHTgfI4ui9VWq1TgYUELNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zpool is an indirection layer for zswap to switch between multiple
allocator backends at runtime. Since 6.15, zsmalloc is the only
allocator left in-tree, so there is no point in keeping zpool around.

Based on mm-everything-2025-08-29-00-23.

 Documentation/admin-guide/mm/zswap.rst             |  33 +--
 Documentation/core-api/mm-api.rst                  |   1 -
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |   2 -
 MAINTAINERS                                        |   2 -
 arch/loongarch/configs/loongson3_defconfig         |   1 -
 include/linux/zpool.h                              |  86 ------
 mm/Kconfig                                         |  49 +--
 mm/Makefile                                        |   1 -
 mm/zpdesc.h                                        |  14 +-
 mm/zpool.c                                         | 328 ---------------------
 mm/zsmalloc.c                                      |  79 -----
 mm/zswap.c                                         | 202 ++++---------
 tools/testing/selftests/zram/README                |   1 -
 13 files changed, 84 insertions(+), 715 deletions(-)


