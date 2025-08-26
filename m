Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB78BCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEF28E00FA; Tue, 26 Aug 2025 15:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086BB8E00EC; Tue, 26 Aug 2025 15:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8378E00FA; Tue, 26 Aug 2025 15:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97A88E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:33:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75460118612
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:33:58 +0000 (UTC)
X-FDA: 83819908956.14.50A710D
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96587180015
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:33:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrvtYI4X;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tm1ThjdiITpVs/5qNYlAJVlYwS90i9/utLl/sZfPekY=;
	b=zNsEbnuH0ZGoT5Yc03kTdsy6AICejznPBkp+0IWT27lXWmXeABdGft2F6moJ7TglcZtS7N
	LKGj0dML8K44U/6tVY0v3Y4mWftOZkMrH9bm0C1f4uEixYhSrrdjl1fvPgRa0+Ytu3/iiW
	FabrQF2qn7BG1E+C6iFkGyaqVCu0tNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrvtYI4X;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236836; a=rsa-sha256;
	cv=none;
	b=3yS6KpBqkWJXC3jXXJyD2O34V7KGUQElvJt015Dt7oXQb5pBljJ3ai4zZI3ROczqTYce8w
	X8NjKodWOoc0OBea2d/odD5HrxCtTD7ehDJFNjd7DymM7hTHule0j0Z963BHWw1Owh+PG6
	XlBq5SOcbEBkiXKCoMCUHlFoK+hZlyk=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2e88c6a6so5377952b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236835; x=1756841635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tm1ThjdiITpVs/5qNYlAJVlYwS90i9/utLl/sZfPekY=;
        b=YrvtYI4XqfzLeKB2l19MFJGntbXFR/UoNoFI7d90p8nqHY34iLbT/UHJhSV8dASUIS
         ToZYsiCw9vEZXanCexuNNYrGKjcpllb2fEzh9qqzlRjtFcyP7k2BYbIY5Rd3eIgYY2l4
         PtKmSYh3s1dBHkahIjyXIjvgaW2LPdraPRjobB5Ui6Dz9XIi1QOUnaxjHNgoztwzYL3u
         MaZQSIX8Hi2w4qWh7zExrGszcUuamdmtQncEdwPDcqYq9YnjYftIo2LbRnPzmR8cqbG6
         45q2t+Bbt3Kq6gLu7l8pQLAgd5J00Jt9gLkRq0REhgI7dkSugGU41Cu6pPU70s3qTnUt
         qWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236835; x=1756841635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tm1ThjdiITpVs/5qNYlAJVlYwS90i9/utLl/sZfPekY=;
        b=VJayPU0O3Q8NmM89ySNmAnXgUQ+zkZcIUOPh3Qh1SU/CpLj57YWiwmDrki8Oq6zwIl
         wZEhFv2BP8HtS7ucUnandBBp08S76cxyU9woTg8tUIPKtWLzmF74o+Zrq3MpmSMcJbrn
         Km2VGgyGOytvya4VlGKb0CkOGGt185u3lgT04HHlNpBrfA/mTx2q+HtDpi1W6+JTqVbc
         9p5pi3I8tW+hQfmCd+cUI7DpDXQS6uP40823Iwqx8/6i7DnpUsHgyzR6QhO8xxr8pC3C
         hCNheBM63OxD4Ab0efOlqp/q43v/Aljiw/X7U00k2g87AhCSpNI/+2ExgFS/XkkET0Ts
         z8zQ==
X-Gm-Message-State: AOJu0YxMV9E3lgLKHwc2fqjwwEW/l76W4fkbZPDRyHh7fYcUeLlJjU9y
	bL84n1oz/at/FXDns9eNTf2PIw8hWFolc78c/ObUAEVQkBGOe5JP7frX7KZPbA==
X-Gm-Gg: ASbGncvhuRCfh3girE3KrJcf1vSDNgAg8GRVRFoPyaqgakz/qgnF7UiEEGG/x1outsw
	o58oAHYWzdtmpdsr19ZdWpikFYMu22mzbODQ9Sfl7xUMG8Qz9o7fjAjKzvfELHj+Caw/sdOYRM1
	CaMEeTlWLPfzhSYKY8e55fjucTqoXGJtwrjH0bS5lo0QB6c5dmDV9aXNszrYzSp9yIG4M3B1rD4
	cfm4bJQmzC3la5fogCDKmYQpWxxiTDPeXheuZZUv8I3iKrPDYPRm0dSYgr39x85YTf1vw4EGKn8
	eB7w/T2+AZrDG6A3d1hn0JwkiKnN02sIuWV3Sdv/FUj91GCIilNmACGBlKn14MDm6RQUEgv7qfP
	5riy/D2CYl6vE3RKExPRZ+bPpi13tkR8dZ6uBpfCsHlnMrGaNtQJzJQ==
X-Google-Smtp-Source: AGHT+IHHTKmoYSq74wYmgloh2oD/kfF5gandE6B1MYti56iY3wYs5IrguV2FzqTpRZlmU+WxRG5VRg==
X-Received: by 2002:a05:6a00:338d:b0:771:ece5:f3fe with SMTP id d2e1a72fcca58-771ece5f870mr7298702b3a.2.1756236834503;
        Tue, 26 Aug 2025 12:33:54 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:33:53 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 0/7] Cleanup free_pages() misuse
Date: Tue, 26 Aug 2025 12:32:51 -0700
Message-ID: <20250826193258.902608-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96587180015
X-Stat-Signature: 77ucukrk33jhkyf6gnc53afssxop8us4
X-Rspam-User: 
X-HE-Tag: 1756236836-524699
X-HE-Meta: U2FsdGVkX1+MigeLi+88rblko8W6AEA8r/c8K9Yo9TK1TDvrT4lQ0Kfyj36/EOZXFGbU65hD5UsSosbbIDdbFNs6umSiCN8YJewlXg/pmfuojkWAiezaPLU8/rC9mQwr6VseGehZREhtc4yRvPTSG1wE0F83RDyVabHE2s/3C6BkFHFz31t18C1i/w/ZqlYVxHoLpFl92J4Le9iyum/ABKLqk1rlDpQWUrScovNQyT7RyBXnN4rswXDGojXprAMuscAeQagK2bhOSx+DQU8omtBsPqmnG0UIy+pehFowJqElQHJvVggCffNIhS/IXG34ETSUU7e+DtRvR0oNgBdk6T7PDbuGdluMwd448XT4i3Ugs0kZFQr8m2+ZuRsToPTnl4rkhywGwqEj39o/VxqAdzPwZzWOeKCowoJ0h6QlfR6aNuIPuqjzIK8tfX669DWttAUG6T+ReAbt7au4TE1rrgaflbtDir/sMgVftruyil/3X1WjpwxSmNbpWmtC7eD7A9W7OMMNWJOzdW5BeTu47qcCzPZyroLk075YyNCYG0IA19+E0TOa04/cjL2PDg7+TLZvCGnXEF+Rp4xmL0aJTPTgYJw/YRodojPHZjeMyjrQmWsypPoQ7eXVpDRYT4z38KCvxKVoy91gtURZ+YYPFzIM3adyp9swrhC3WCY0WgfzjOglRuVlqaWAuinMpvt6cM/rjsO7hRmtaJUa48PccJfa1NBfBMhZzpT4b7SnoSC3pGZh/qUKK2G5HsOlSsPXYhzVx6S/FJafOlW+lYeRCIvFxFQtycLdGRC6f2Y8pgwTf35nqqoeGrPl5UDggkBwuj8KqQog8iVdOikUbAZATFIEkzqBKzYDaMFxX68FEtqCeUDFanI3yWPs/NjOXOQFQQSbB6ORFfxlvlD9FC6/acf2nwXu74FX4jITkXoH3ATk0kejDLM2OHnNgy5yc0lhSnt2F2AfghWZi6BNW+o
 b7IqPpLB
 War8GGvWEiQXu/Qhh92Fe5OJAXTxxVj5n0NYUSVvB4qC/AJ1PHhr4DUhoaZLiT+CsyIqUe1qYMqqE5fJEYZ646EBAlkEOdSj0vnbZLCySLLcN13Wuh/k58MrUss7sOl0ui4LySkB0pLYb/8pP02QV0t+xbNCfrYRU9gnf/TZcgGFanrCboAT6vSiDkvijSIgyCfUl1Fx11uYEFB/XxaajiyGeRneBJgSkluQN/oi56dy3J9eBklvGTUAcz+KE34qZ8gpGG7ghs8MRcmfTQmkpK9zJHrTkVQzcfQNJU6w/do+nutTMG0h8/KEONNq/Mk9GkJGAqyqAImQV+FYV8Uw+1/w3pJeno5VXBDlo9yeNwVdyxv75edvKN5pAfbCwZJGvTQJP4R3O45Tn672Opx2pjh8PnseupeL1eMPmqog0z2dwopSGIOOdv5PHR+Kj1zgI44aL0qbpeguXuxBjP3J0bYkh2FOA2/iuvUtfJNTClQy8MTuI1dpJXj3byi5FuZTI/e0QaWxs+yyH8HwHbQVO0Kb/xJ6fElcTlvVy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() is supposed to be called when we only have a virtual address.
__free_pages() is supposed to be called when we have a page.

There are a number of callers that use page_address() to get a page's
virtual address then call free_pages() on it when they should just call
__free_pages() directly.

Add kernel-docs for free_pages() to help callers better understand which
function they should be calling, and replace the obvious cases of
misuse.

-----------------
Based on mm-new. I intend to have all of these taken through the mm tree.

I've split the patches into separate subsystems to make it easier to
resolve conflicts, but there aren't any functional changes.

Vishal Moola (Oracle) (7):
  mm/page_alloc: Add kernel-docs for free_pages()
  aoe: Stop calling page_address() in free_page()
  x86: Stop calling page_address() in free_pages()
  riscv: Stop calling page_address() in free_pages()
  powerpc: Stop calling page_address() in free_pages()
  arm64: Stop calling page_address() in free_pages()
  virtio_balloon: Stop calling page_address() in free_pages()

 arch/arm64/mm/mmu.c                      | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 arch/riscv/mm/init.c                     | 4 ++--
 arch/x86/mm/init_64.c                    | 2 +-
 arch/x86/platform/efi/memmap.c           | 2 +-
 drivers/block/aoe/aoecmd.c               | 2 +-
 drivers/virtio/virtio_balloon.c          | 3 +--
 mm/page_alloc.c                          | 9 +++++++++
 8 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.51.0


