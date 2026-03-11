Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD9EFD065A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208D26B0005; Wed, 11 Mar 2026 04:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5FE6B0089; Wed, 11 Mar 2026 04:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1776B008A; Wed, 11 Mar 2026 04:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE066B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620868C138
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:33 +0000 (UTC)
X-FDA: 84533143506.08.EBC1D15
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91A6040003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RM6qnaC7;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LeDMkbax8m50ldc7k8TQfgLLao3Zaj4KnHyl4VPdUU4=;
	b=oWruHh2TG4Iy+1GS6EKnzdPmgAIaJ1K6RKHJwFTW3l9obJw+746VyP9yAG/vSyUIamrEuc
	z0RrdnqzkJEqVLw1lLvr2ZJp5vvPm/K9ZNETDR62/BsvAlsqlBIdzSOS3F5RoHSQjzuUaK
	a/W/C7oF1H4kRgQ2u6AIO5y3aQEeWjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218611; a=rsa-sha256;
	cv=none;
	b=5DjSHHvcs4rPO9Qks5HIhqv0mrzsZWs35GvGQzzakCNHiOaIu1YNoNHzqEIx2AdVX5YEQg
	eny/Fyu8hkq3Ec+NQM6ywitYuHxX4B9EdatuaN3Y0PLzkAUmAjErP9nUFRMI7CAUGKgf83
	R0NQTt9V6qjhR9jjqT12e4gobmF6Q/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RM6qnaC7;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ae82df847bso33577265ad.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218610; x=1773823410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LeDMkbax8m50ldc7k8TQfgLLao3Zaj4KnHyl4VPdUU4=;
        b=RM6qnaC7ZgrRXjBd7d3IP45+QhPFYxkqhzgEpHr6WqQqlDwp+yCnVKxOrO1L4h1vgl
         N8LP0w3eWMvd5DCSAoIUmC5BO5/i+Ffl1Z2mWlFla5EFPdSX5wAjuVImiNPe39tTwPaO
         dmvbHMSkOlAHr7EZVW1kaVmCfOFykhKc2EtkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218610; x=1773823410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeDMkbax8m50ldc7k8TQfgLLao3Zaj4KnHyl4VPdUU4=;
        b=KtYw5R6enNaVPmT/vK+Bp0huGZAwUGI1DIS+3Oju6tSU86E+Y/JUZL4jco4PzXlyZg
         qnQMy+HUf86dXkmnnHvOQRMQhpqBzSJUO/Xi3SZz/MXKnZx3/6AKQp6T07CS7v4Qq3ut
         CgvxWSLBBWefS6n4iAGqKvsch1gCTw1GwcNo/SHuyqe0E9jltMN6RLZ7OZiUP9sOG/4q
         YSYG0CsijnqgudJInNI3skAxKMC90kgXzsYWRW+ZK/I6F8isaTDN+uFy7XrajR/e0zD2
         LP3b8a7hLVCGYwYPsjm/IYCDcf/2+vLvoVwwX0+Q7sZc1HC1i/MaMkFkpC85WPJVt4p+
         1vww==
X-Forwarded-Encrypted: i=1; AJvYcCV6O0MWoG/TCfv/5DpOqCV7tZv6swH9+B8qxkSxp3h/RfbNm161ZSVlBzBJ9c2DpJyUysfIoPg7MA==@kvack.org
X-Gm-Message-State: AOJu0YyrhH2d/xMz8BO+GkPGj8b03gDZpIB3orq7+GpVmhM0waJfrSgK
	XTk2evvAz49XtaAXUMvTUqPCBHMJZG8tX9avOKVnNMAgMavfB4dAyVKe9qK5OMdjHA==
X-Gm-Gg: ATEYQzxXXJAH/f4f8PM7P27LRMHGH6mFu6Ca/sHoi3jR9xPaGJ1/lj7wQwWevZ0zROm
	8OSsi+74rImMmg2g4yLE1O4t87r0NHulvWzalHzzMCm2kptQ/UrcllzW4mNrQ43sImIoCrmUp/Z
	5G6xi7XXS/YMwKzpqFJP5/wFY/f7mmWLMTTdmXO1ID6vk1gJwCMBNG91uWaFuYPOj0TdGGiodBY
	r22SlGe2aHKZ0IWMcii2PNfYweytOOrOLzuNr73ltyA31BpsypEtTY8B4u8XnwfIXTVVx/tlSmK
	4Aydvx2Ky/Aa4EUFn/jh1fWOC9Sfn5bXcZLkVKu3IUNdXFB14DEV60njbt8e6eR0hQwygmXqdEf
	mG/8a4N2RCeP7usjOwDSjQ8IMg2v7+NJOBwl2qYvSjUpJc1O7kwLUC2hFn+Rz8b7hxAel9fidfq
	/VXZK9gyULDFjRQLXgJPW49UobK3uD+fsjyNyjfi5KP74GDI7JDxtGJn4AaxE61b2fIh7HzMFzo
	5t9Yns5WV3RtA==
X-Received: by 2002:a17:902:f651:b0:2ae:3a77:a1f4 with SMTP id d9443c01a7336-2aeae7d8956mr21121285ad.24.1773218610440;
        Wed, 11 Mar 2026 01:43:30 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:29 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 0/6] zram: recompression cleanups and tweaks
Date: Wed, 11 Mar 2026 17:42:43 +0900
Message-ID: <20260311084312.1766036-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okb6aw5iubts3a6f4ymjoykt8j5a41ec
X-Rspam-User: 
X-Rspamd-Queue-Id: 91A6040003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773218611-841379
X-HE-Meta: U2FsdGVkX19bcKtHsgF9QIkOV4rMn7Vrw6Ocfl6t4I3/Yb/8NAF83Xf0iTWt5kowX2HtQXfncJOjntUJZRSXy7aZbhSKE5BRxVMD103Qf7xtluF5CducvLOI1CrxMGWhX/RORIu/tAv+lIUOiuXkfYD7hgph+vHhQ8aukrpeJ/l90Qt4pfMtZqz5jcX6r0+cpV/9tQVR3cMW8AzDO2hltUQt60HzPPBjLDatx2+L0T5maQpSoS8dTzBkk0KDzqJp2XktvlMCO3M5caUceJ7HZ9CzdCuKEmChgKmWoMCeO72E3+sBom0A/tmsEo/8bH+yl7DCEogJdbqzxrxtyrQBjNfU9FfruIKNWoDyj0XjWOZ+AuCbveK311ft6Ct6eYtbRFtpqtJUoJtYiMZ9mREiSvDCHdyZG53gT1QvxLY5MCBI2ybyMQzwnqSZVzU8hofS6xagI4kIRQpK4HjQqVndz5Zl1cXwUPVSl3LdxQR3DRAYhIvbA6xisOJtepVWYwgOFstmyC44gfuLo343v8kubfJfYQRt0ESe7gwPOBgxdk6rHDvVmx8SGl4k8/m4M266wlwEqBkA7ASugMkwnwy8EqwZFKBplpLQD+Ma1cbLr/aBILKJHUpir/kuWUOA7/c2UvDrW+NHgWwDuK6R5ACtvWICSwdWAWnbWOE/eO6bz0k8n6QNU38LDcn8mzVRKJZU8PTKqOT2fQ/D2rbGfZ9ZXUWZcKqez0W3QwltmL9e2sbe5dCwOopMeyqDOqpWkErBrgWNCVQdE4JT26eOIB2b1/TXsEesBjC0Q9my1a9qdzp53ZMhJN/7N1u0CAo/66LPsLie89Z9NtepWeVFg/j6vVOU5+1YAwB1ZYS/i8G+Ebpf+yY7s841N8KxaFdL0nk4UY7aFJ9JuWJ1L5H4sKmrllKG9OsSwndq3KC9J/A4XLsdi82kY6QFolqC2MsIkcxW2heFl+LmDzeGOaots1d
 PIAmRl4u
 ftYhq0QwKj4pHqmflu0/VTylABy7qgvQmc+S2mFt6EtF4kCiRh3NKE5ApYEU0poNbgx2tm7ay2kVDypPi1pS6Hd/EsmXc6XuCcq6HRd7r9P52oIiWoZlMy3ssWpnNXys7/kwHlvLmcFYiLobcsqJ6hs5RseCgOI1Z4mtTDVVWhKPV3cVnxWG6vzaEruj7UPsWGlcJngFVTk+2CqHRq6kl1Byykzj92fF0sg27YMC3RkIpGSPfzVMpxo2yKkO1oVJ/NjXAbjyudXv4Rdyr/UVmnH7UKNASGAt1hnIVDtiR0AHQWEQTXlQuK+X3JbsgVVrw7cpR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is a somewhat random mix of fixups,
recompression cleanups and improvements partly based
on internal conversations.  A few patches in the series
remove unexpected or confusing behaviour, e.g. auto
correction of bad priority= param for recompression,
which should have always been just an error.  Then it
also removes "chain recompression" which has a tricky,
unexpected and confusing behaviour at times.  We also
unify and harden the handling of algo/priority params.
There is also an addition of missing device lock in
algorithm_params_store() which previously permitted
modification of algo params while the device is active.

Sergey Senozhatsky (6):
  zram: do not permit params change after init
  zram: do not autocorrect bad recompression parameters
  zram: drop ->num_active_comps
  zram: update recompression documentation
  zram: remove chained recompression
  zram: unify and harden algo/priority params handling

 Documentation/admin-guide/blockdev/zram.rst |  49 ++---
 drivers/block/zram/zram_drv.c               | 214 ++++++++++----------
 drivers/block/zram/zram_drv.h               |   1 -
 3 files changed, 123 insertions(+), 141 deletions(-)

-- 
2.53.0.473.g4a7958ca14-goog


