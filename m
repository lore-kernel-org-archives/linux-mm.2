Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968ECD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F165F6B007B; Mon,  1 Dec 2025 04:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC70E6B008C; Mon,  1 Dec 2025 04:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E506B0092; Mon,  1 Dec 2025 04:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C25C66B007B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A06A12B84
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:09 +0000 (UTC)
X-FDA: 84170426298.17.C92AD73
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id A72AD40010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YUYRsLo7;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8cjpu8d/6tUGU04oizfzdPq+lUGJcCtDUD1fOE/UMgc=;
	b=0SdbxqVSClccyoK5b8puurk7udyMBMMWHNJypopi0Cla60qAboYoZib1KFbxvMzjPf411r
	SdX3Ifl9U19FILpseQWJ5WfcE/gzKbyDtXpJi7DXz44qwJKoEksk+7+yZ7i+nWYYemGZsA
	CFQJevhNI+RejneL0NA0IPMrrYxETos=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YUYRsLo7;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582487; a=rsa-sha256;
	cv=none;
	b=QZ42p6xyJJkfVCmJ8oLxws4VZuR1R+I4D+RIM0cU+aRTlHFKih0oRCzjzdIGZRo9HCgNQk
	cRkONYCc6NW8sAkvwMZSjblGGvRG1gdseBBRuAOIanduU88VsanHriFs2L/3lEwtcT8lEG
	L5YdGxtedkj2h2bL8KaEp+hJteXOHu4=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so3284096b3a.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582486; x=1765187286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8cjpu8d/6tUGU04oizfzdPq+lUGJcCtDUD1fOE/UMgc=;
        b=YUYRsLo7SsOcRg/DUZ5ZNsDUNzUoV7Uk9Z/8jdJk4d7Jz6mStWXEytAX8CQOy7QSBi
         flzUnb2/6wezwxffBJvFnS30X/d/XzxcX5m87xmhF+N3sEFv8my9CnlmJaSbDYZS7d5Z
         +PuwlaRo0VZTOH2JOnJL6ANKSW1ip87FfmqlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582486; x=1765187286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8cjpu8d/6tUGU04oizfzdPq+lUGJcCtDUD1fOE/UMgc=;
        b=kfHFmaGzdNbihd57p5DxA2lOH1MIq0D9hs+q7S5d+ejpJqGc8ueZRdTd7Q3UiuGPkx
         tIBSSBJzqMUWAc2qIyElee6M/sV/6ZzA98hse+gLh1WLNUJjaBDzEh26C5RB7UA2Gy9o
         /o0ZbcSWbqHyveeDNz3v/AqBn13wxATavRnQd/3xRGexghP45uFJ9MDAC67b1jSR/PU0
         M/lRo3vXlhSeomiOGI5fUl1g7FsoYKw16tbHWCy+AhRN/zJEBWKbzOx0GSgaD4ZhEVZY
         Akl6GLP9xYq1lOM9Q5BkNZ2KObvUZnqu+PEEngh7drgkgFHZ4cqUCgQ4f5wBETd4nXkp
         uXbw==
X-Forwarded-Encrypted: i=1; AJvYcCW/GJl2kGnGT0pZll94ZmOUcE3d6WgeHUwYbp9Y/QXqPhsq2r2XU8GyREit0ePTFfIdjFzFMkxbTA==@kvack.org
X-Gm-Message-State: AOJu0YybfUErenxkp0EHtozunkjMtsGRabwbNxPzrp0cyAE37yBPxLcP
	Q6S4kwbyNWaZzMy5Oyin5mPGWybS+PTTpp6VMETLq2lBum5eJdsuhtK2qOUrCfOMrg==
X-Gm-Gg: ASbGncu2WlbkapkCqiV86Sf9Yh5LYx6kAz1+49mQa9656txCqdtAsK+m6kiG3qA9Ber
	SWvzgenKpBcOOcqh950CfN+bQhR7XdIhVfbisw+eEzb4pJ4vSHWk5BaDapZhb+OqF44P16Lpo6F
	tVNoktUax3DBSDAhm/heQ5YOb3F0Nvg5sLMXfqw3lpsXk2XWfwpIP/qQjN7Ko+dhyzUIy3PPMMy
	HQ2cjOGYiYEyLss9qH8Mo8thE5BxcVmlZ2SZzjqup355B9MEF5xqNwK4MREof5kx9/aMN/fkDey
	LNDCnW+3QfeeLpfu3s4plXO8fIdNba5VDnn0Stz6VKg2KchlDGbO9GUG9rNQ1P4jGPkhFWa809t
	NrmapR14bDPknYfRYQtE36DetmXXbymckT3d+KGu2haWszpKB6SCjbBkOpLk3tqY3+skW1bTOTw
	NChwOhWKTkizzq42Wl0osCif1b+KbOo/1Sx16WXxqzUmb1T5393DmuBZ81/NhqverNTcTQcLzO9
	A==
X-Google-Smtp-Source: AGHT+IGEVzjUlLH/GkRDVU7CgSXvTY9wMuV82BLJ/ce6COqpbsj9rr5Py3oyw5UZRbSI0WOJUCs0Zw==
X-Received: by 2002:a05:6a00:139e:b0:7ab:e007:deec with SMTP id d2e1a72fcca58-7ca8b599b5amr26051878b3a.32.1764582486563;
        Mon, 01 Dec 2025 01:48:06 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:06 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 0/7] zram: introduce compressed data writeback
Date: Mon,  1 Dec 2025 18:47:47 +0900
Message-ID: <20251201094754.4149975-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A72AD40010
X-Stat-Signature: bsdaiez44t8fe4y6kdjtfsdenuqtezes
X-Rspam-User: 
X-HE-Tag: 1764582487-18754
X-HE-Meta: U2FsdGVkX1/+66bWRe0xXl5PKI5BjWQIkvEdI3XS6MfAJ5Mj1jQGllaH/wpENjZSM//xFHP/+vUQ584gMe+ZkAK+j+YZ+OOlUkjHM1FJKOydYy50BTYZXA/ui0XFMkkGfADnDXLRwjVexn5O42TDjC2SPTB7OYHbH4bHQWY1xfcnzVKR48Z2ao50tCH0choBu+pu3IzeqPi24ZiHCytrfhKDJK9U8nZjTghO+hsKV8ZtnOKwI8c1ehc2pY3A+QVmrdDH0nwgZDeB79xhZRCqHLmsuDv1OwDI+JHbYOx80E8n9eJwx1LHtzxmQT2C/EdvmUSWvAov2KsMsgw+oqK7uPDN2AgPcckT7CwQFhK2TS09IFlfPEXLaW0oNTiIQ3ID6ZgOjppZEazudvi8P+g9BYT9sOqyz77O607W+nazGTCkV04LmUb3v3/dPoINKjKRuwDRbB2lLXBXGD/mkGSRDOMdopbDd0jZtUWBAMS1lcDC+lirf7mgGfeLUeEowA8KWgiFH56fzcOvZB/5Pr07NbxNlx4384rFbWC3Apj32FMVeizvBbxA2aVBTCwpJUShay9BSQb2LHOCpgX/W9hagv+dLwp0SlmahqZd5Dgz71V4LRKIEiLmJLW8VjJCL0JDSiO5QUyOlTB0d6kwwKSJhY2dhVl+w4A6LSrfm7zoBTQRiI6dlhqrv1uBU3T3lIMJhHIHz8eyNarZe1jKN87MMinVxwq+7CJr7Z2rblsin03JOIBE7MXeZmKBpI5J8pdbybqK2xAaMt2FXeDNb334lp40Tv9CMly9VKVXd43Sh/6eSKqJ88n74YqzbRMVXjYP4r1eh3tY0pYxxV/Fp1MXwuGR4MCJRPHyPqYdD3GJjkbAnxrV5GhBx8HUWOsUsL8aQuNlPucJh8Jbw+Y+tKnFyWjzDnKcr07erxWbSwV0ukLr8U+TwIyTgfNWMRq3xbluGEUg+5HWBPlsD/EfF2i
 IxkdRG3U
 IYG0/TjVIAuMAb4fHUrDYdZlqduN9sytpce4+IaMcqBgN/afm/y3ddbMCSHJF+ARWuM2TnWYWsPaBPtwJOXp1rsXA2sB/Mi4C/+ZIsG9b6IEVrvLTLaWiFnQBGR3bS+fB0ravYAOIImSs7I/1Kr2i/nhxygRF7oPV7NY9a+pyYOUQAFGQMjSlzxqV062cZZnXrd5jUVU0O4yxAU0Am+nXmNatOfeekA2h3nOmqVe5qlmKPpBUOlyJ8+sAqpuTINnHZOUQ+VWelDuIQxCT4dBeRAl95x29zpRDWHfhdCwxaHgH7Kn9gTK+Kzsk8LFuxozGAgYK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As writeback becomes more common there is another shortcoming
that needs to be addressed - compressed data writeback.  Currently
zram does uncompressed data writeback which is not optimal due to
potential CPU and battery wastage.  This series changes suboptimal
uncompressed writeback to a more optimal compressed data writeback.

v1 -> v2:
- made compressed writeback configurable via device attribute
- added missing batch_size documentation
- switched to guard() for init_lock
- more code tweaks and cleanups

Richard Chang (2):
  zram: introduce compressed data writeback
  zram: introduce writeback_compressed device attribute

Sergey Senozhatsky (5):
  zram: document writeback_batch_size
  zram: move bd_stat to writeback section
  zram: rename zram_free_page()
  zram: switch to guard() for init_lock
  zram: consolidate device-attr declarations

 Documentation/ABI/testing/sysfs-block-zram  |  14 +
 Documentation/admin-guide/blockdev/zram.rst |  24 +-
 drivers/block/zram/zram_drv.c               | 589 ++++++++++++--------
 drivers/block/zram/zram_drv.h               |   1 +
 4 files changed, 406 insertions(+), 222 deletions(-)

--
2.52.0.487.g5c8c507ade-goog


