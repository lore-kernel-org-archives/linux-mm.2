Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1F3EA7942
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDFE6B0005; Wed,  4 Feb 2026 13:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B226B0088; Wed,  4 Feb 2026 13:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769D56B0089; Wed,  4 Feb 2026 13:54:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61B726B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:54:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D7971A028C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:24 +0000 (UTC)
X-FDA: 84407674848.07.E1731CB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4DA6412000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jApE1COs;
	spf=pass (imf29.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770231262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a+NtN2OztplN/1Y7TLCohgAAyi7DmcCU6OswtRqXX3s=;
	b=gT0c1NIdme+Z+KE0/OV5wuP5Bn0C7CT0i4GYP6snI+TgJN03V0H8jh8giGj7pz7U8ASBTT
	jQi5HrroiCOhgLz1I5ALagno/ygaNPrFwA2rPn3Jfy/PzZYLPGA+71rxCMhLJhTQXB2fJ+
	EiVKwGr2NPgpMazxTEZW5CkV7WUyn38=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jApE1COs;
	spf=pass (imf29.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770231262; a=rsa-sha256;
	cv=none;
	b=QRNurcJ7l3+WFBWvNSFLi36nCEJHmTwBnYgGJQj0y/SFfWmf2LDMKV6G0xUJPRbGTpQfBo
	Pw90HXPBtOK3GMYutCvNeYiPA+2/YqFnr1whYI2I4VWw96tPWFOOWZzQ8+OaeNNL0Tpr8G
	V6HHA0EGgbVKGhyfStts5rldXWk8yjg=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a91215c158so1451635ad.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 10:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770231261; x=1770836061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a+NtN2OztplN/1Y7TLCohgAAyi7DmcCU6OswtRqXX3s=;
        b=jApE1COsmHpFFnGMtxAT7tCq+7frUYNKiwtDKMQZhMV2Mz0rQkyeSQtKN5fm80oxIg
         ltXJAfT9YqITgLlbPGyC6m9oIdQOxVqIlaGbtrGoyo1P9o5fZAoGf1mc/lZtdG1ndF6P
         qt12YNxFrVYLxTstW74IQk3jQYpUXYVpzxeTHKqLIj0CIwLXI3GlaK/CSJZLgosOyM08
         1JnhI7oS+6Nq0OE+8hLil4K5h/7VWq4nHfbktNLlJeHM18AUgZdCMtA811UNKTD6qpsw
         2L6veGZYxOyB+nny/oujQNqY2Lvvzl6IzX4+36Aay1UjWRd5xTk7/OAXBUghxkGyBMMV
         +Mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231261; x=1770836061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+NtN2OztplN/1Y7TLCohgAAyi7DmcCU6OswtRqXX3s=;
        b=bLA4/diEz85Va8ccWJYcAolxxFqPtPIaZWc5+rCX1e3CExqn/rNKtnt6hr6Y04pneW
         Lf9juFjGwKleG+7haZxNcitRWWiwWDmEUiP7StO6IJbmBjeqQv0ARbZ9E0XMzlnCINZ7
         dIjzaWQLXcJlpGTAyqoe4NRat5DZPRUi27YmR5PE8LfSRi1SFVnzwlPCJy6lkPJmMPs+
         GiMGUZGv1UW7bGDtnl6JRVefOXYmfHCyPssHcX8QClz3lyK8N1crsqSSxWW+AFK3/ZRQ
         XOKVhLScfr4P0UEYjH6zK+fj6GLzyuaYKeM1tPJtm0V/jArwGczG5EwMx4z7CvqvHGUM
         zYdg==
X-Forwarded-Encrypted: i=1; AJvYcCUXo/4NIGGU5JyRFmz92wJyv+gbugiZkzVDHXVOv/aVEX+NJOsu/tDWxFMFwSTl1HWzNwTZ07EigA==@kvack.org
X-Gm-Message-State: AOJu0YzU/0uvCKd7X1G8fJa6uiO5eUsdRZ0C3P/d7sb0lJBzDs1RxP+g
	1Hl5gkNxOLgFpP8Qo4bVE/hjaOnWUtkdjxPwtEwL3GTSZBzFxacmnp4Z
X-Gm-Gg: AZuq6aKQytlR2hGSBuI79eWbr6hrYM+Gh64y9qXIcHaQFymZ3iQj7r6bPsZBgrAC+fi
	0SFwADogPeO9O3IUZmMUMg+cUEePcnClmRyH+PdI+2Fuyj+Og7zzRJ+rHv5LhNSYf/3soWEyhJE
	W+lbGHYjncqAmFxIligkCzeBl9WwskNlzOToQqc5dSG/yqtc5HXeEsw9VL0wrBE21oFL8Zu4gkB
	YsWPwdrlb7Vo/rFWz6u47zPiEBLefA3d6udOfDlVQGCgjGBLKplsp++sbn8RdZzg8SRl9sPL7Y0
	hmCahDlg0vzqX06oQ1ptU4UW59qwulgSZ60dteNsml+YmLBinVUd5oT3lJ5x7xUWfMyfYWnOt2J
	4SvONuQB3XEhHExAE2syKZ5PO4SZDOhCyTb/9Bn6/w1v+Y7tTePnHQ8s9wACeYP854tWn3OTbJ7
	5vJL/J0Oev5rV0uNd1cvtQBPYIpg==
X-Received: by 2002:a17:90a:c2c6:b0:34c:c514:ee1f with SMTP id 98e67ed59e1d1-354870f541bmr3197764a91.11.1770231260905;
        Wed, 04 Feb 2026 10:54:20 -0800 (PST)
Received: from chandna.localdomain ([106.222.233.39])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c82f2c1fesm3128562a12.7.2026.02.04.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 10:54:20 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	david@kernel.org,
	sj@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v5 0/2]  mm: Coccinelle-driven cleanups across memory
Date: Thu,  5 Feb 2026 00:24:06 +0530
Message-ID: <cover.1770230135.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ba5am3ubkz4s9jrekfjpysrrz3zuwmxu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4DA6412000D
X-HE-Tag: 1770231262-487656
X-HE-Meta: U2FsdGVkX1/hXEZk2vulgExK9/4VG2xiN7FJTWmr+7OHWqkTdiwpyu5DX8KOSKL28HiYpHKKR9w3CCwpKg8KgRmJ1UqQe6QcDiGxA9NUjIe+/hpuUlrbQjsNq9KfaVhNKUDoN+WXLQnCkpKNCCsuvIcj3tfvglwGwC17ut9dN64+Tkwl64PRt/R4sKZ1z+FrUGlTs4DPIe2UAZzU3KNcHQCe1MIXMwvtgj5U/dSj733UoFRLeJcgIG0wYidUdtZX9MJBx/x9bcX0Vbvi5AvtJ5MjQ7E+ZtWnP+qBv0Fh+63fgfbvWudnMvvcak3M8Zjc2jERUICvlzzjz4R6PR3jzwllxKpjNfNeNpYw1pMjC5U0nBVNWeEfDywlvNrHaYF9TrHUrjnH8wJy0HyRPX1OvKuXUQNbx8GkyuXsuY9YhrXoTGlZljaX5XJzIXLMH29faKqCjBqNhO2BWhTWWOj7DxHCcFlDiuXit310DOtYZBrZXi7os89Avp61fHzkahrN/0afIy+81l1zZSVWSbgyK+0SY07F4TMs2tIVaZWSYVC7LNAnLhcPYHAFIbSJxRwtnRt6NYRSQGtqAeQr8Fe+384A2Fxee5rF09TWpyF6F2dX21ByXE09+TYyQwXqUSReheTrssiSCHchZf5LnJCyO2DAJlSY9RGVf+4xRgI2FRWH5ESWlBWqX6fdNCUppXtgLF0MAAG58BxJedlN3R+m2eAjPhA5gXSH/4qBPXIHd2Ix71UlRfIyKuHbhd1+RCor2PxEtkMvCXuNy5cUIRsQDwUeLmwa9QZ/KwEpLWHOxigqsiC62zNPfeIr8+xcrVbJl3aLCH6xvHZfWzBJnM74RkZTIVQ3QaxO60rMAXTIJ21mXC1HHt3qWntogc6pbcQ68OOYtmAMYsALoMBaO+qukQvN0fvItqhZyIkiJhH88C0ISVenBHDuTcMOyLpyE/wFZbB/Ytr6h7YuoU6SXUk
 OVKgR3pz
 nm6HjvsqpuNc7Tj/c+CNOhoNB0rx1JpMAqScVXD4a1P3vANN5eQtwXP/0SfYI8f5UckMuXHKnLtBQknJSbkMsbfHA2Fp4QqFRpvKi9ytFmMgG+1gsbz7LWDotvKAmKtC3+VlSEMdNZCBCVRO1nitzXVJfdF+Gq8xu/hcOAZfsWIIeunQCz4kjzB/hRJ6K+gIKQqGAUPb3Tt2Fktv7YFz+aA9EReDan6XJk3BlmuvzGiFmAoq+9qwAoVfjrVHv3W87ggW/uoB8AnpmuMJiwN/DWzKqwgK5Rv7zUFHzv8sNmokqzo3RX3m8bFTzGxv7TvUcveKjixc1k1vYCsQmN4Qyb27QaZjN+ncf2Q2GRzYv+7NtTWw8a7GDKhjFquRS63eNpyNcGzdtMweMfVzuzjvFqLOfqJ9GxGrmNt3WEKD/4OlHQnlan1fzvFtsvVAfC2OMUhRG6ugwxt1lR6HzuN+Bx1pvXxmE/2G6m5RdDnMOrEUnY5DeMhxJPekgPp3xHhfni93jyjFNnvZEuyv597/YCAduY4pdiUSiAbIEQDMfO+MpGdMvB/DnalPrcgKqXlNkvOB20x4rEEzJ3qCyHdUvAqhmcKaJ95+Ug7zqifpXdzgpaA9q76N0qUvuzFrrq69N/sWY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series contains minor changes identified by
Coccinelle scripts under scripts/coccinelle/misc/:

  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/

change since v4:
- Remove use of ALIGN() macro as it caused infinite loop in case page
was already aligned.
change since v3:
- Update the commit message to highlight change in computation of
boundary using ALIGN().
changes since v1 and v2:
- Patch 1/3: update return value as per review comments.
- patch 2/3 and 3/3: Add Acked-by and Reviewed-by tags.

link to v1: https://lore.kernel.org/all/cover.1763227530.git.chandna.sahil@gmail.com/
link to v2: https://lore.kernel.org/all/cover.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/cover.1764177933.git.chandna.sahil@gmail.com/
link to v4: https://lore.kernel.org/all/cover.1764312627.git.chandna.sahil@gmail.com/

Sahil Chandna (2):
  mm/vmscan: use %pe to print error pointers
  mm/zswap: use %pe to print error pointers

 mm/vmscan.c | 4 ++--
 mm/zswap.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.50.1


