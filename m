Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C3B606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EJiDRFfj
Received: by kanga.kvack.org (Postfix)
	id 9FCAF6B05B1; Mon,  9 Nov 2026 07:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2846B05B8; Mon,  9 Nov 2026 07:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B576B05B9; Mon,  9 Nov 2026 07:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69EE66B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:59:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 157F1A81F6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:48 +0000 (UTC)
X-FDA: 85415587656.29.0E655E4
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2695C1A0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EJiDRFfj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uACShyT2+cRLfD/fxPOkvmS+FRCydCrY0eS4MhiCrLk=;
	b=4m20JkAZaBuLICB2C6wJcF9EnUzFMZE02tDRntnNdLYc1TXB6+SR3KmcoTEOnA+shWzvHj
	vWOwdkUDjYlZ8fMvkjwE5MwzLhGB6mrnOHfofIrlGRGwF6J100EQiHLkYDqUnbP5dVUCMJ
	yeWAUYB4PldoSkaAxt+ckKYjz8YML1U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EJiDRFfj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229186;
	b=j++KOC1u2XeiMDGkJe+Eqlmi+bAT+HdKzvU0Ql/jmGgfr/NoWrGamIdl5dCZkujW9dNxui
	xS3OI7MBea3qmoA59qtSYhcaSD0okkyoBtLaXRi+9PyM1n4mVAwNqBy2/f+S7fas5lbARK
	4Tn5iUyXhJQBXHt1/OWZLk3crpn8OvY=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3adb9cbb0c3so74269a91.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794229185; x=1794833985; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uACShyT2+cRLfD/fxPOkvmS+FRCydCrY0eS4MhiCrLk=;
        b=EJiDRFfj9Fvm2pDiHMXrSFkccDGJf5ll8TZlNS9Cp0jUv2s6MkGExC8Eit5/rRPze9
         Pc1Sx5suwVdWT+Jk0S5Pnjrd1lBPD81XTlX1YQWKRZ1IVfFYmAa9v/13mLWWY4h/TroU
         oSLihaq2t384nxbfYj4jFHMlwft7ETjwznsLoAoz7PNeBsJb/1C8keygdMlVWS+MHvwX
         K7Nxb9LTBrsAi2N2I48w2NNnmgco0vYHAz9EgNnzWDAVxmcDPk2QgGKuYX+3D9l61EqV
         wyda5nqYHPSUEpwmahQdDbOJ8rmjBwSYd8/Va8jVfhyCId6udJzvExiHTSeKLo1LGZA6
         S0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794229185; x=1794833985;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uACShyT2+cRLfD/fxPOkvmS+FRCydCrY0eS4MhiCrLk=;
        b=oaXYHyQjFAhlvqhrxC1ALX694htt/P0Iw3irYGzppEYkg9QlYZO2QoO4G7u43i7faW
         gGYjm2Gg6qkavd4H3Que8WQ3z4B+b56NO0FEat0kH4T882pMONDedmgVFVrQqXHxI5W4
         FB41VYdnRTjqErCmih36i7ls5EfhppDLTEXgs+KNrsonTo5dRpl1NPrBqWOmrNhLQ/u8
         XOiH1RMfvxrelEs2x+I4qbppsYu9IvH5G0gTpTD61n8bJT6pihc9wqzSnLya8Ex/2v+E
         rfT0TK1QFlCjiatFnYMosXz6qiq31xRDQjrxzdXqVCoNJ9xCMGNRnwbMjz6RYVEartiE
         JeGg==
X-Forwarded-Encrypted: i=1; AL+hErEjXfUYWzKVxb+BG8Un2Jf2cPllMoH7L3eVZNUn/dl+YPj1rOCr1mCheMUzOQM3GQPFA60ArFqOew==@kvack.org
X-Gm-Message-State: APuU4Z+XS7wjW5wMmcuxyer5fVH3NYmgPQ+yM0IuCTQ5X6JKlMrBLDJx
	nFMZEEWnfTom9mMHENdNJcycoSkOajIRmnr7yVP9qZtUGlwpOUsi/+Ka
X-Gm-Gg: AYBFou26VUvemgjMYX656bf8Cnv+LiujVpxlKo+l+JkmS6kYiCO0CZ7lCB37foLpfL5
	FnpZfrnNi/TudgJCSHuoy843hmbo0soEdf9EVPM4llAICac/TWxPPNFLHUGZ2ug+q6zigYP6GPI
	+1BhszYbsjl48TtDV3YOjAp5NFQgtSzAzvm5tjjAfcVhMcOOetK7+s358IBHV7U8HRgEx4bLato
	9s2Ilw4nPH29ZG+fADtX4yVygDyU6JTCPcMaR5XiJ9/0sgfIkg8Q8k6zQ/Y0tIiwikZZNp/O9ch
	WHnPAUaNpN8Fjq9NheNeR82gKDeqdDdUSbcO3we6uVl/w35sJnR6SH5TCkM7bUqqf1YN0Qk5eFq
	PpRMYeKnjGZBNL0N2Yn9DFnVijAjt4Zi3bsEENQXGT3+C9DBTHFvvi8/yrhbsg/RlrzpiBCUGhK
	+I+yCLQL+P4G5CSEn3rxZGT0x+QaoV28q1kEpHr7sKoszsX+y0KbMLzg+ty4n1QE3VXl8KROL3b
	oxpnCXTJw9JQgkbOj8WYg5DGY5b02gdLTsxH9lu/BD0EU/2bVriNGoCHLiHNcMkc9l1iz77sRh7
	HMWHM/V+qag83eHbAdGmMNbCqM/6/+Jfaj+C/pMFQg6nLRFgmIZxjYmWSYU/WdASjoo=
X-Received: by 2002:a17:90b:4405:b0:3a0:c162:51af with SMTP id 98e67ed59e1d1-3b12cb3d220mr5659477a91.0.1794229184648;
        Mon, 09 Nov 2026 04:59:44 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb969694aasm1534153a12.25.2026.11.09.04.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:59:44 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 0/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Date: Mon, 09 Nov 2026 20:59:28 +0800
Message-Id: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALDD8WoC/3WOyw6CMBREf4V07VXbVEhc+R+GmD4uUAOU9FaiE
 v7dFuPS5ZzMnMzCCINDYudiYQFnR86PKYhdwUynxhbB2ZSZOIqS82MJbxpU33tzo6giYKJWWsN
 FVbK0mQI27rn5rvU300Pf0cQsyQ2tCEEHNZouIy0hk8NPCzb4CbI7lztH0YfX9m7mWfrvyMyBg
 z5VspEVl8o2l3ZQrt8bP7B6XdcPrYz3zukAAAA=
X-Change-ID: 20261106-zsmalloc_stat-e261d4dc1276
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2695C1A0007
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yix3u4xzsh7rbd8rnte1dbd896qrgptg
X-HE-Tag: 1794229186-425056
X-HE-Meta: U2FsdGVkX1/ddI3wW7sRqHg5fJHyc9ehoRVIexzl7Sa7OPy/Acyp64hAFW5Rj65cUtrVZRcBr/cTBhTM2VUJpKV0Sv2+tktt96tbwq51Kwa57svqk0Rqw6SqMPAovIT1plLlFrHzbyT1PI+P+15xy8Ke8IucGHT5mGyZhcFOkn+3ApmQV5JMUGxhm+VpqsAlIAKliefH6Ha0Tb9fZoOkRFT92tJjEQ0D+M561GojAp6+RP/TYVL5LnDwoT+Gcp84NORy7tfdOc41IJPwWWXXKO2IKmpWRPW5KOtu4VfLC6yHGVY7b5yCzakPGhcTLK+U90dSTB1fKRF+cfiqgBjO2BCG0Tl28YiwOMTWYtmwW9CjHPWTmEVo4UivnJSs7cMlG7KnYZbVHVmqWUeOHYUuIo2sSrjIcInI8/TIyf17yzbU5cCIFYTLi8hDkj7wZMVrN4i0GgjLPbdgk0fJirvNvx7PxNbuWOGBNJkE9v17odvI+lEVI70ss+bVwqLunFfiLJTBsKezguA2jUcWM8Qpu8TZknWKLsP3Si62dg529hAaxP43DvDv5QbOaYpRQSCnw6VolV/zxwzQySL5XJ6h6NeNNgFK9jDlFlZvsckSoXedWXbb9JjzgoTYA2GDmwLbG9si24Ok1+djhvYVSZ3wONkvLnNEx63PIDvGpLdx90dJPIVoAcilnoY5QO3ydHR+S07fZ2IGVPNZj5j4pg65pFqgbViAUlWW+2D23GzjmFszpDEv+zta/gYGygokiFDcaLZ5VB/FdCGNaLWBBnryZaZssbhuR/2qyPpFeW8BBkd4k2phB26PHZpBQKCpzsRiHlYchl9gjFB/SdvhG/7TdMGQ2Y/MtDcNXwGpcwboS+4zpkGWbhthaJaRVVB1P1YC4MdbUYFGSMKd60roM/TsQkjf6MNOgjLkABe/8ISX7NZhh7NQeZ1QtkhbTzBq4hZDyxFtA+Edt2XgNNTa5mU
 BQcUh1v2
 +Swp6ie8o+exPB0lY+UZQTGfymF5YzGJw5rk5sFPwsBuUZ8Qb9d7cIU8X1gfRUo2EfFLB4I2tTdpeUIfGZ1QfvLbUcPUsfUh6yy+x29VyZdEfgeRNHNJYzrpnzekyC5xKyh/sC4PF9mM/hW7wDGeIyV+sP1qxDgKCHqlrr4OWzDNgFoK/Kv7kMAlVlsSf03kKozpLkrlG10GKJNh63ITsBGloWmhEEBLsQNSHwAJnobVekQIRpIGdB+J3t0HDRgysHdleFFzlccLpn2//kKY4xzI1ie3lUt2gjmwU2lORsDCGJiYne5rgysoRwdifTt3oOql7hlXbf2u8c3iTE8BhKlucxWbjUAzyUBTD9Nxb9QBxK3ID7AOvdOHbGXvzyqUyLuDMOH1XeJvJEAQSVpwAIAUqLpzfYpvmEIjadUMdXsREYfOni7xZZJFsKtGwC7eg4bgUXGbqWiha7m47q3uo2uSK62v1Lm7b3KJY/PnVMSmylPrAYTrowNKsjTiQUeVaOoorsO14kCZC5YjyrfBNcpxS2dJty+kbT6PDiaNEgvNouyZJ4XoJExYmwvFtYGLVZKHK44cnLZiQ4YJ8fu8PPZzMi0208Ref/+wObgj5yMIxpZuYAUQfSUXaSM3wILUfy6Oe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
option only controls the debugfs interface, while the class counters are
updated unconditionally. Removing it simplifies the code.

Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
the existing debugfs API stubs when CONFIG_DEBUG_FS=n.

---
Changes in v2:
- Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
- Update configuration files and documentation.
- Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com

---
Xueyuan Chen (3):
      mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
      mm: remove CONFIG_ZSMALLOC_STAT
      docs: zsmalloc: describe statistics with CONFIG_DEBUG_FS

 Documentation/mm/zsmalloc.rst                    |  2 +-
 Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
 arch/s390/configs/debug_defconfig                |  2 +-
 arch/s390/configs/defconfig                      |  2 +-
 drivers/gpu/drm/ci/arm.config                    |  2 +-
 drivers/gpu/drm/ci/arm64.config                  |  2 +-
 drivers/gpu/drm/ci/x86_64.config                 |  2 +-
 mm/Kconfig                                       |  9 -------
 mm/zsmalloc.c                                    | 33 ++----------------------
 9 files changed, 9 insertions(+), 47 deletions(-)
---
base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

--  
Best regards,
Xueyuan


