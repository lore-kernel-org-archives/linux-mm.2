Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE155CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4496B0093; Mon, 25 May 2026 00:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B5C6B0095; Mon, 25 May 2026 00:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA766B0096; Mon, 25 May 2026 00:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE6AF6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:46:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BBFD40149
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:56 +0000 (UTC)
X-FDA: 84804707232.10.2B19C15
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 886A54000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=O0YukV3x;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779684414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TFGrB40YVl0RiMjOPw5S6164abjThq91k5UXmx0HKGA=;
	b=vvqRB38ovOOHdbe0/MohTvQGkKIguX/OjFqF0oJsYJo1WEl4/mJ8xFNjZ+O5xs4sV45vZ6
	DmFunpTnXuVnD8mdSJw2DQWacl/l/WKjb7LyTSBtC/nN0QNVfKxsmqKJzPqA0rm04Dlomm
	KB2ZQKB2zdhCr2FBL3Y95yda7cXjCEs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=O0YukV3x;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779684414; a=rsa-sha256;
	cv=none;
	b=UOlF0aNuPBZr0VL1KnfC+Ti3T24Nv7as8siVxwwjFLRFgjZthHklP2T1eQ2Yvu/bVbVKvP
	xZO8vYZl9OgN7ZD1Ln2QxzpM5QG+TgkcXbIKjF9zSRQ1ezleNE1nWwqU62RbSVxtFXsbio
	AFmj7dQBNdnNtH95oE0UOgU+w/KlxOE=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36a8ee1e28cso1786995a91.0
        for <linux-mm@kvack.org>; Sun, 24 May 2026 21:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779684413; x=1780289213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TFGrB40YVl0RiMjOPw5S6164abjThq91k5UXmx0HKGA=;
        b=O0YukV3xo7B2ui/MPc6hVAtuYHhkvg7KnUvyKOpxsPAinMmBi21xNmsVrwj3lXlSd1
         N7+H5ZhAKrVG3UsZEphYxQ4/lrgn7F9Mr44rb59trTQdMFOKrRW3sbkDzfzwKP9lGcbJ
         mWM+uHBhwmJnHrNFTLt9sXsS4nkhPaWWMbdP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779684413; x=1780289213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFGrB40YVl0RiMjOPw5S6164abjThq91k5UXmx0HKGA=;
        b=qiHgbYxofL4qhQhNpcxYqPkrTCoicTZPCSPYW8iH9vahtrK748JxDvxbjQ1ISiSEbJ
         KBkf7+k4gzQQWVgEPFbOtJacMHSDQ5uET5oFsQdxY7seKnLJTpPjIr2spKdOUK93dOj4
         FPFu5nsKpx+rxhn5u1/ie7onbNkHcgYuID8y1ZqA9PmvQqJS4MuZs5OOzOoJEwU/ta04
         R3IrIXF/Xa2YI5VLvxSdrLhpQlJYogOTWcYsVL52VYkqg7pC032GUsjrqnZvhbZP43pS
         UDKUkDIf8sv1zIj8KzV421f1YBuqqiX7ZB4alkX/zrvdw6kivz//CrL2G7KblTsie4Gi
         Ea7Q==
X-Forwarded-Encrypted: i=1; AFNElJ8YaNCYRM9IiPJEjdB1NdwUR6awE2TPIGx5SFLh4Nc4Bt+68En85e+NaBWX77u1vVQJf/Vr9U1lQw==@kvack.org
X-Gm-Message-State: AOJu0YxvcossE3WSJ6K+ckc9cSGUeNtEkMjeflsNbBa+xbK73sVY9qn4
	MnZb6eZ0YKBU0pE1LaxV4EMpKhEVVNyjmFTHrpB0fy011cGsUNnjTeGJQt7GjAzIkA==
X-Gm-Gg: Acq92OG8d/Pd5wB+8exBZxZliKShezi2P48TFN9hUXDuKN3VBO9/hwhhrDI7gKhr3GI
	u1BGJcrLfxNxCVAtQz2Hcwq2JvUzOHbwJbvl+jEXhOzx58Ia8SbHHug4uevORoF/mmlFxGEN/Jm
	uYMN19PGygJOEyMLwjLxNAwM5kjw4nftk8ZwwKJAzZCquUfVLMQzPYvZ9tWo/wlteJug5zdJefD
	Z9YbC+BZ4VVW7xNUBtOpFBiqQB1+SBsVsASPFGii8yXaR0S3Z7TyiWIsLEOVDx9pdMoWi3lqsYt
	S+5BJMVvkhOXMr+7p/IXXiog2RLVpHlOYi8WMQBTlZcLC6Ygw/e5loXt3WA5Yf8wPL2XrnwZhim
	cqP60gUnhawRaV8uqJH3DKClUkFDxAWoxAyQn6/qIXjzRNnva1kr+XN6bkFjBWJN8MDWfBn5p1+
	RnJcJcl4byoe9FhPIzj3ocgq2a6U1qVufJ7saS2At0CHvTz/S62hPMFPdwwTR6GMBISebQz5WQ8
	LbWUKvj2wP5z7SVQRrY7a+LvguNxvuMvA==
X-Received: by 2002:a17:90b:2290:b0:36a:72d6:8cc0 with SMTP id 98e67ed59e1d1-36a72d6a600mr7388146a91.13.1779684413122;
        Sun, 24 May 2026 21:46:53 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8f7:7157:3ea6:a126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a6c680110sm4361447a91.4.2026.05.24.21.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 21:46:52 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/2] zram: writeback fixes
Date: Mon, 25 May 2026 13:46:00 +0900
Message-ID: <20260525044639.1888561-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k67j7f5k8isi1gtmc1w67ydagynbnbim
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 886A54000E
X-Rspam-User: 
X-HE-Tag: 1779684414-463770
X-HE-Meta: U2FsdGVkX19WZ8wUvLWjXqcMKlJ10ptVXEOTOdj523rw9hrcI0CjLGnflZcIK8gArRwwtGgNsPhl9/wlMKowVWyuwmTj3THI9nSjIVI5QOva4gSvLgCjmI+P08eM12DM0w04t2ZVweMSoTSDIlxhtZ7RMDmM6hpR0zucNsZKtdt+HB5DYxeB8e7Uzw4KirlLbYE5WFsqgz2k31LMPiYvAAwV29KX99RUWbWrjrLuDrLvsz3yHto0mlmMIqjPjkYB7pJokHbBxe1nahnz10J6BIDNPoUXMSzM5zQd0Vr3mEBSYUtKgtbUh/1+paaX7buZUwXDu+8NJ4Hhggp3QyI7xRD1mYmpD/BfHoCqbfIDr9zKi33I30TTl1TvMJ94N0IzH8sSp23kZLBUkn6MrHMZ22rkeoxI2Bue3LWDB/CeMbaYHdHE3hz0Jp1CQ0cGVI7GZi87CFYjdAbBUEYg4EjxQSW6Xka0UAx5vcG4sRxHzBxIu8K+wgwOSJHjCK+jakiWUwXwxT/FJTDdOj6ohMdeqmLDt4HB/5/a1khW9TIm34niGejWPt7uzGpzneGBNFrp3WIDwThdKrHtpg/howKeA2iywD23JqWLmdnTy82GyJMQadY4MfwuhHQWlQ06mQDuyyGcX5gy67Z0QfXlbdWF1S9mVZ/31Qjr8lKTawKxmu1bLIpbkSSfbjXiTz1Yl89m3EVdb7gnwQO4m6nJfpGyXgb7XSJDYWLGpV4/3CNamndLQpxcgQl2TKZTpzNPcx2EQpEpVOq3t85ZYPB1srDjH4rhxv0MlUaZMt+HExOleueky9SVsCW0w0fJuhbj5tB66Ejp2bwseJSxKlk/vX+deQuZor0Ri0gfNVWy5Q5loEyT/ECfq0d1gMUnvrEDmT3Xj93i8HIBcAvcy9AFBUVRf9jISRbUSHRy9nFoYTCcUMevGoL677jdJejB6HjMUWNGiSQNOoBFBj8ybN/Wpcr
 xkZdBF3E
 SFA1KIUJ0HTfh0YU0OyCJBp/gYPexO9HNdcILUcFNfOuR11GW9OJuw7OLQbyZyZGrbyL7CNgwCbZ3iUGmdtTz7mOpgN0Lu3c89/5TjEAEAjr8VRONL4bCfo5LQkM4sBNPDJY3wR//8/ywML4a26a14M6gS3m+e9+O2yuMaR7N5auAtzA7YYIZQmbfjoo4DeIzdMaubtsCY+M+4N9UpJ05WFCrolPqWlremZ0GIAhm43IEyUnV5wfuTAo7puOUx/HXPAeQxiLIy0lvZUdGKs+x8qkF9GJf/3j8hvnb24AN7RGOluhzOmTE32HSRL+lX/6V5hwKtFwPJOckELgN5MVe2F48YvDQgDOG4eqJy/EdS7jH9v9JqnVsCDHs556wS1ySQmiPTLFXiKP2cdbIEKZ3tWgi9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Brian reported several issues with zram's writeback implementation.
This small series addresses those issues.

Sergey Senozhatsky (2):
  zram: do not leak blk idx at the end of writeback
  zram: clear trailing bytes of compressed writeback pages

 drivers/block/zram/zram_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.54.0.746.g67dd491aae-goog


