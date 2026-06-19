Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69456CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0A66B0095; Fri, 19 Jun 2026 00:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577F96B0096; Fri, 19 Jun 2026 00:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D556B0098; Fri, 19 Jun 2026 00:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 231E76B0095
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:41:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80C601C1151
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:41 +0000 (UTC)
X-FDA: 84895414002.13.0A082C7
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id B60CD1C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s1OgCiml;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
	b=rcKGFXVzREdp+l3khLevnimOZTuu1qt1LtCBB52qlNgQngYFJUcJp4NcWSSEoKoL68/N5B
	HKFDoLNy0YmoCVxB5GT/1a0WM1P3+ter5PnombSKzC25DTZnNUwTc/7dGXndZAIexcIley
	Vv81+tRQx2DwHwjm3udN6ldxnS74ofQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s1OgCiml;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844099;
	b=KF86/AexbQ8eQxqw5lMX5Cx+MbCM/6UiJWSRLC7VD+pe20ONkZYtxXQIgMOO+sDDiUjc6l
	4TfdN8jTWeNphccFQ3jLOwWXAPyJiuArzFO5zOve0P0vZr5+WwrBk/jiKUyD7Rtkv9k5ea
	DhZw1vuSGHpNT3cU4F34RhQDzfc+TZ4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c6c57c5bcfso15438945ad.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781844099; x=1782448899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=s1OgCimlntaDd3uEG5WRN1+4l+TD6WVZySUtsTIpj0oIc81/52+MlmRXkzYBU7yHGQ
         1IDZ/MhNYxpYaXGX84XGEivSC+36eG1HdGcGJqdWFVA9lkQHI/suxiZ8z4WSpxxv1JZK
         eJh3swTHOhj0imnR4ruaTJDGl8ZiqC0z2O41VIK6bJlj5DnUzwH91YHzftDvQ3AQ3ft5
         uRP67y02G44Kp1KxFFAB8S9vJ8IWGLLDlamn3r8bZ2J8BvUhtmYfyagtu7WIbgSzRTSj
         gypHkzgcB1hXomcV/w5IYDMElwEzc2E2AP994juvOuGXgInznxWA9IttP0s0X2OVYT74
         qZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781844099; x=1782448899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=bgVb/4gOYqIjbqo+gKT0v68rk0YEtTL+2vOgioDhaXEL+VwlFTCPaHIo+KWuK6NzIv
         AwYpmzhKlAzNPPs5P4jok13r3ktH7qnIXY77yprOp8nXxpLlIb/0ft4jzlN0+11Sih1U
         9wU46SsuASYAU5vQOgCyXCh+RY9h/oLAO+GfaEjJxUIqcyzg2TIUIQzr6DehLXXXhWj6
         GKwb0JTD40xk7bHUeKu1JeeovJuuaR36ZNglacRwjBZkra+2L81Vd09ztUCs2isgFRYK
         q8sajt21W3YNCqUE4AmOMsBOuyr9JLkI+e3oUoMfxI6L+neLm1aA9YGpLKGXAXLdeqgF
         o/aw==
X-Gm-Message-State: AOJu0YyI6YPmDA7LpaBvaT1ouco8+kNnljpBjHpC9x1MMBteQJALYYYq
	6fg95P8kdN6eG2SB5DZGBr3u5wiu+qfwgczsgw+z/AOl/1+8lutBI5UQAjAQ3A==
X-Gm-Gg: AfdE7clfDy6yaxA1mQtzymay0dHlxTVlqquH0zAhKbWME6oMD/YaNO6D8TGJEDhDHUZ
	AI+CodDh3751gLRYJVzoCZWsnX80bWpVRt8GAsvhpjssB1i9C5AikXaVlyzsRlSZ/jg/xorXs/v
	eIupMB8GwrF7iGJZ/zeg2dcqbE/ebZCJgxg1mtZO25y7CkmWeCCQfNHI6snWlhwqk9aZCMwNjAX
	DJnHLFcwtupXn8cK76Lqw25rLOm+ZHiUC442nUK0V6twgjGAX+3z2zRq8yaHgv4wTNVZuIR3CTV
	gxrRbDP6mG+I2gTV+9lWYsjnReV4aZgSgwpuI1vaP4sBqwIw4eadwYQW6t5PfwqOno4Tw3Qnynm
	9zkeRktkiTjPzw2F2QSa6nj+4VW64eXcUcqtfa1gsPJeZnrTDFhcYOojDJN37bEOFnqZqzbInGw
	kfljcc4jXBnDF6WcdoydyPkQ==
X-Received: by 2002:a17:902:d54f:b0:2b7:a350:463f with SMTP id d9443c01a7336-2c718dd8598mr24155975ad.10.1781844098519;
        Thu, 18 Jun 2026 21:41:38 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208e5760sm8293735ad.36.2026.06.18.21.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 21:41:37 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v4 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
Date: Fri, 19 Jun 2026 10:10:59 +0530
Message-Id: <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781843449.git.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B60CD1C0003
X-Rspam-User: 
X-Stat-Signature: g1uu851us3d5oujr697ky313ymx3pq4s
X-HE-Tag: 1781844099-156533
X-HE-Meta: U2FsdGVkX18kMXc8/HNJXSyRtmV2xPN3dae9zAAs396mO1S5zX3MJI72PfSe6M3skU5Wy2KlE+tqYxHkqvzkCue7xolXdefbeB3sc1vgkWUYpjfZEAlJTR76SuROQXkfXFhHvOrvyILywQMtIOi5bGBisu9anaA/0Okco5E/hJFRTBnTn9YdN3/KabWGV1pVvLOks/6UVjGaQN2xb3gKj6+VzMyJOYCBTpjj/uBjvPFY0iJtJ8ac1NimXSRl60lzg1VLzladxwVpEEmZdsdFmu2xgWWRoNckxuERxRNKxvl2CJoEi9ntsD1ytGbXpNdQuGXn9N7pZuP0cbDmXm0YLTlgIgCAyCy4OYhh978W5FEQwd0MwX0i/kCxYzg+NNy9GjVkDEiXgxxMZvQWXddxGwA73ePrHgJsDn2ve0MF86aPxkguMsHpEIyIUJoWhTLoHNVpwrhKdsp+oYtt2Tk0cNqnkqo3AYpzrL1aCY/QaX0Sb0ncX8CH8TtNV2kLG0N69JYG7slnyjJTkCC2lwNhayUvlmq+/ogE7ZYtzOBpwZbiGxiKDKoXCJR6FP4wxl86e92fVVxZWTTSzMewyU4Yc4S7mKsdlbXV9Zc051u91BLOjZfxhEoX+t4dMYqqfyk17AsIFrdhFOlclKzL+3magj8nOu1T1R89rtvW90fBUkv6+judPF2rVA/4n9B67EtHHUYSBJ3azyuOP5EjtG50vEPLxKmrbCCy3l1MsXA076nPll/mtwWUzDTCq3IWqfiWsS3qWnFigVgX19sL5byvjqlKiFuImqBx6rzw3A8M2Nk4bhnFSJq/OttqcQ3CX2kSyS1H+r6jD7XIP8rsZU7Ne+OBRC1wRxHN/47TEMBHO0rENzjQMgrpf+P3y5YJxG49SjrmjCHXwjzGAZXGePmYw239nkS+ZKApuERvUuXKhVszMvAnq5yWMc14BCcfOxdIWUazPm0p6wfKXOL1DdB
 pPVo6rKa
 Uf9MOiYYYOE/Nso5t9ABdJXYRZqiBDY9Bd/aMpM+ZjhI9yE16vEJZLH08zcwAXtMTxa3d2c6lT1xhwY6Rj9QR1yfRCbg0dBo/PJpdobYUJSJ2xml58Zajyi37KVOUrAjA3nzXfdFt8jiDxJYoHqxMM128cH21H+ozQE9fWHIv4j/uJEvq4j3FpKsMKoYiF6z+DH/Gu7IhjtkwT8pknRbqgtu5jQZzX4BYjv+2fhoHG6NF4CuvKdKmqFUZraA1Qas8xH3SG5fRhWoxs8B1ld5bWHMWgTBPQql95w9UvBC7X6qfwfH+7K2BbeRRbDiUa1/Qx9MVA281yIZczXnW5p5bAKBt3GcAOcKuj1RhbNkm7kZEF7ZcY0j65ruqwWSKrdWStpqCB7iKlA+8P43MnouJ9i4bWCwGyeGJqaBRUBdrytotEG+n+Yh72fU58nTNdA2nCNO0WtpS13jqTdJInixbLf9yCk/p44S0PP+MQCCj+PUfojx49Ts7dnnG9uGM2JmgeTUBUi+EvoCrkqLhyg2e2PQpvrEWrCF/7/8vAynE9louP4S/3dYyNBX4fMqP0bN8qjfJIhdTRAEzVTh7jeUqVEpBuvyrWFSZ+P4K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
(Hash-64K pagesize / 16M PMD), during swapout. This improves the
swapping performance since all the bookking & I/O submission happens
once per large folio. More details at [1].

PowerPC Book3S64 could not enable this before because PMD_ORDER is
selected at runtime depending upon the chosen MMU. The earlier patches
in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
changes, we can now enable THP SWAP for Book3S64.

This increases bandwidth throughput with zram backend for swapout by
40-50% with Radix and 100-130% with Hash (Tested by Sayali)

[1]: https://lore.kernel.org/all/20170515112522.32457-2-ying.huang@intel.com/

Tested-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/platforms/Kconfig.cputype | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..48f74bd22343 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -113,6 +113,7 @@ config PPC_THP
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
        select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_WANTS_THP_SWAP	if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "CPU selection"
-- 
2.39.5


