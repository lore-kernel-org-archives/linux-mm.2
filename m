Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC98E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82ED6B011A; Mon,  2 Feb 2026 12:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06356B011B; Mon,  2 Feb 2026 12:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28AC6B011C; Mon,  2 Feb 2026 12:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFCAF6B011A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:37:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70AD9140146
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:37:06 +0000 (UTC)
X-FDA: 84400222452.20.0FA7EAD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id C78C62000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:37:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=eopOXT95;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770053824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Zxkngtuq35HTzxqeFUrhct/sRo7IwSyEooPYTzLXoP0=;
	b=oO09bG+Ttur+QKG/NLxfJmtTmM1g7po6+LOVWz91y8UNEQJwcCBA2N99v/iv5IrwgftgC6
	47Nu8jJcFOuS7S6k/Ji01/XU+Kj5fNCcEe0b9fPE2vQjzXVJtoB/3V9smvoHAYLFpWpzTG
	rVSEQsl9pnrVz1XIqWWWYxmGKqgElDY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=eopOXT95;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770053824; a=rsa-sha256;
	cv=none;
	b=1e4vw9RpITW9i1WPjVV7cW2EWfNOnCqwK/emw0ffdfSopZyfZ6HouWqrr2bs531qOTxgoF
	Hwwz4Jp3+4tzopGmydwrpzrH6HkJtquabN6Y1gwibnEFIW7Dp1JLILS4HOS8A6iI0eQbtp
	XHpqS2CM6PlQ8ikQ3glWXNVF8gVDH8M=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c532d8be8cso476432085a.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1770053824; x=1770658624; darn=kvack.org;
        h=subject:cc:to:from:message-id:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zxkngtuq35HTzxqeFUrhct/sRo7IwSyEooPYTzLXoP0=;
        b=eopOXT95dV44syJgzMcQySa4XJ9cjh75r/nu80/WzerSqt0E6RNOS5yM4qud0Vq7Ez
         UrSDGc8cqhNYmRfiRKm12YMG5egyegvzZkSOLl5/iNJHNS3x4xAN7BcMUSkapRvN9JJd
         PmK+mTKS8CUtCMl1EwLUJqciE5lIfd1wMxmT7ztOXAEfV+Y8CCzhtw6lXcUCOwWcDc+n
         G+fcNivG0c3mIzk0POtlSvlyDyuo/gsOvbml0KNmocRn/VQNWDqISv1gdfdLto3P6Twa
         ZjAil85eNVfiNW43k2YszXZvhZ07tleXSV8MQN9756DjYYjmCYYfo/o3/mQ8G85+wj53
         ZFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770053824; x=1770658624;
        h=subject:cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zxkngtuq35HTzxqeFUrhct/sRo7IwSyEooPYTzLXoP0=;
        b=qL6C6SXAY/c9Fo0yxB8vW0XHeg3U8fubVmASD5RvAoYFQvZox35n7vRMO6b8Wq1Kr8
         FbO1qSD3EGK18wCkaNx+0BVNoLc0QijwmPVmQDzvwpedqdQkZAVtao2bJqVxReQk/SyE
         lxOdKWWooorFAxuHBT+9W72oCmgmqq/Lxz+SZ9flVD3jqKQKfoKhgw9/XmMs/V4xeERs
         rKN8poD97gSB8TJoKMRaPBQEvQ40ErTO7gVdpLSiH5xZ2iYI2YukX3BiwfYgpHC0nXRK
         +0gV+Xq0gRFLmBwg6qgtFrudXrtGpIGN+Ydhb+VIioJoDt467qSmx/xQ5D1cBXujGUNy
         KJyg==
X-Forwarded-Encrypted: i=1; AJvYcCWtQt2/Tdl4IbgDI48KvSMvUeb8exRhS7/l1ImHeG4sZK/uJ+twavbzhoKDfVxWRy+jEKFt/tl7Vw==@kvack.org
X-Gm-Message-State: AOJu0YwHIwb3wb3Kuc79RyrorWkXScdsUkBbQ5Emo3q8Zh3VZmNuVIdW
	nQvaQbXnAKANbLtDNYjxgCOorHo0HAVTvChzcPZim+gv+VKcqcJDeO1D54/ErKVw2Q==
X-Gm-Gg: AZuq6aKj8dr10niKmRU3fU6NPJMSMtAlztfK+oh+1VufFl1UKHYti9RuxXiZeEk9rl/
	tX9qFlraxSnJ4xJgILm61sp5NWQCb5Wn10BXdy2ShQa2Yt0avki3pCTEjVoEgdxskd6/AyHQDpj
	b0e41nzc+Mgzj0ZENhRYbYHcT7lduiNBR6UiqaZLcLdP9eTUSaQ8pJ0HuHdAaX60nxsBKjCqnK4
	nxcJxO84HK1NaktRBGOiIOuU4q3/PAq+hpeusuVwpH8NeJbrlDY+8o2n98pCBHRCTAMMeP3cfx4
	9R3m1VOEcMPDP6weK9N5KYqDOwCY7LktWEcu920+vin3rGhME2eDQmBH/dyW5phxmofMf1PEWUr
	Fd/8jK9Y1WaJOb2TD0bFZ3c6kXeJ+9vcyKEYG0d4B0AlYw2KJxRRVPHFBcMx7muz5yaYaymCyVb
	T/UtpKw5sqAOGYxMkJbIbsmMT774amrkLneRP0/8XG0QMYR/jDJylEmqH9
X-Received: by 2002:a05:620a:1a8c:b0:8b2:dcde:b670 with SMTP id af79cd13be357-8c9eb329006mr1561201685a.70.1770053823814;
        Mon, 02 Feb 2026 09:37:03 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d3740e62sm118773246d6.26.2026.02.02.09.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:37:03 -0800 (PST)
Date: Mon, 02 Feb 2026 12:37:02 -0500
Message-ID: <1840fe300392f962e0bd444941c24969@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] lsm/lsm-pr-20260202
X-Stat-Signature: uaz4jw3fsh9suue1cirq4cpoh5q4qf3m
X-Rspamd-Queue-Id: C78C62000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770053824-486044
X-HE-Meta: U2FsdGVkX1+PK/mEmtecuNq+Hc6blfBfSNvU1wGUG9wXPgfC/H6DOCgPbrvpG90GfExY/9fLWqvNmeL1BLR23s6hmUyePlm/oHH56p6OARmCQDqvh16TL5RgqDlsZyJJJTma0/3lpiwviYAbuF1/X+IVguQjpWexB9yA8NBnAHNh5bgRO64oWIWAdbGxiq4zEgxVUGWxZq5SgyzfjrhvGe9a64reSvnLfBcbVgEYwBq133ZXg0c2gr45wJK2x+6Kdy7kjK6YgjPwjmqY35MloGBQPMEwHVsPKOx/MQdyRoU211XKUTZ8Q5otLMzDlkQhr+zrKia3q9Jsc1F81/wqsUWHEABwn04tPpKViOEVw8/eqbCTticVGw3jp2Nrfm+PYECmdhIf2TdQtwwDc7o8vIvHobX2UIMZl/KKsR+0dl4LGfck08AIiOIsdJaFX5wWImjtQYr2lcYt9I1BkXz5vv2b4AQFtxMKBFncaCNQUKXbUiRrS4wo+ENkzmGJ3zZ8RshocOHpJxvI+ejG8Co5d+W/oidY/Nmqm4yFsn4ZvSw0cJ/qDvPsB8gG7OuxAEZvec0+nEA4sHC25gExEK5jCIrd1OaAnsNkxpJwMV9EKtHPcYZHnvhCs2wlBOhurJPFWqVoU10ecY9siRq0ZYZ1YVqu3ThDotEtX+qrEaE9pnBOiKgBfqkkw/VHJKPmwsh5xuC3UBjZZoVtFCodWKsF6YVIROwQBB+gfdnD6cwGpPt5+pbIMQGELc9zNEUfDmHIh88+9sHI1IViV1AO4OOsJ0qWaTZnMcPjwy4nFAxlaHXWiVM2z0eke47KCSu6mjWWr8M8Ubvho5U4hSJ3D71l0YrEJ5AHuscrxMKct8pT6soxCfYU0JRl8FAu3O0XCAGTOQ/mKB7fGVzvjjEAuAs3jgAKTBHvYuYtbBBUEYCpcPBlOQGIG0tsFAzjPmlO/M6+/ed02nL1cnoFmgJ3RAu
 DpLTHhQH
 kHT/0k3ji6+yinM/jpzvvHc08Ng8Hkuc69Be6+Vg6f3VB98iAPUfWbldCB19xsK6hlt4d0/ZSZ2oFxinHS8fvdmtgbVGGlS0xKf5jiCGZ598KHtylf6jey9qNmwn3SkoIhoAlVaP6P+MDh1iedVnAXORDMbLVComIqjjRxj6+4h1i8Aax6j5LhVrEQkG/a7Mk6pTsyeCEhWZl8dlZkE0KMlith0hCCsXsH6ALMZAif/Jn6vtI012THdX3HwDV15qs8awjuNFEXnwnzvmHsiQ3DZ3dyoS/KehRsWrlmOpYWq5VVlaaMr/trOYhJZukuQqPmfb0/ceeTeywzsnJrO9DtbWW8G2a4gQbpIQkZutg35mcmBtdShNh4q8u9Ak2v3WfILhRgNvP0oNtLZNxgi31jjzDuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

A small LSM patch to address a regression found in the v6.19-rcX releases
where the /proc/sys/vm/mmap_min_addr tunable disappeared when
CONFIG_SECURITY was not selected.  Long term we plan to work with the MM
folks to get the core parts of this moved over to the MM subsystem, but
in the meantime we need to fix this regression prior to the v6.19
release.

Paul

--
The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd377:

  Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git
    tags/lsm-pr-20260202

for you to fetch changes up to bdde21d3e77da55121885fd2ef42bc6a15ac2f0c:

  lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
    (2026-01-29 13:56:53 -0500)

----------------------------------------------------------------
lsm/stable-6.19 PR 20260202
----------------------------------------------------------------

Paul Moore (1):
      lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY

 security/lsm.h      |    9 ---------
 security/lsm_init.c |    7 +------
 security/min_addr.c |    5 ++---
 3 files changed, 3 insertions(+), 18 deletions(-)

--
paul-moore.com

