Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D59C2FA0C5B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8096B0093; Wed, 15 Apr 2026 04:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497BB6B0095; Wed, 15 Apr 2026 04:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3871A6B0096; Wed, 15 Apr 2026 04:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 293FE6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:57:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAD55B9B5C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:17 +0000 (UTC)
X-FDA: 84660186114.22.C15BDAF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E08E140008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MheWrTxJ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52HLBVvHVecdaxTy8P7ZBrFPBClgeVlPlb7Bxuv2UKI=;
	b=6WLJeJ1qwFRqYLowaJnVIJNNvzYyhAQJHvqMhGnx3EfBaBZEU/0At50X5O/V/Nje0Dp+pS
	z/22HdGsrCKQkCZ/1JMNPfr+Wac1Yxc2SqNo0+pVzMzBQqlddYjB2RTQyFi11ZDXZ/XKVH
	EbW1h+Wenyh9re7vP5HSJoYBo6dQQR0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MheWrTxJ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243436; a=rsa-sha256;
	cv=none;
	b=NN19MiTRke32YK5PpFXzDr/bEe47HyLA6taUUKnbDDqoHqURFEm/dGeurXAte8bw2bvVH9
	e/LYHKaqWG/HTbg+b8K4zJtYysAG/MYGXoHvHH5FAGfI62S39WmdLnyZBGkX5l97wU56pc
	/wKbFcuIhYVzVhBntQmrfRERCgoM+MQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776243434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52HLBVvHVecdaxTy8P7ZBrFPBClgeVlPlb7Bxuv2UKI=;
	b=MheWrTxJEYOdf/Kyx1XxQdKXR06siIs9BpuMqrgbRC1jzBAiCtgjj3JHpw9wfpErU9q3wR
	wxvXlucBDP5CAfbcvLooGSr4Y4gYXlmijSPgtweXFaw4GyTHsRiEIqIpfjv7IlzKe1elPu
	KmUr7DE2FgzWFEC+rb6SLVky1JCGGOQ=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Wed, 15 Apr 2026 16:56:56 +0800
Message-ID: <20260415085658.993859-2-baoquan.he@linux.dev>
In-Reply-To: <20260415085658.993859-1-baoquan.he@linux.dev>
References: <20260415085658.993859-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E08E140008
X-Stat-Signature: czpbkbek86n6z967casebzz4hd8oxfkr
X-Rspamd-Server: rspam06
X-HE-Tag: 1776243435-143056
X-HE-Meta: U2FsdGVkX1+jSJ2jTmmdGvFwgxgJ3AIBA1/kpH+TwCa1gKhgahfhSkVuh07cfHXZXeWlLTxfSCXmNWO1/TpzHOyxm+PdRhnMdVFEFajv/7cpQn4R+7EjbDRFCQ+PdXdUP4xTbJ5AFu1pFDYpFDkKZC5QNhdqfDslFfCz+g13kn1aXtiamUvllKpJ215EF/R9uuwhEJaoJGKXJLSUZHStV7Qv1VIyAx8MtpMoKUNO3Wrt6Ls5e3Vpa53nJaOqdy6+SGCeGoYeeyIYtkM5jDldJw3us681U4KyzEQZ2BLhiMHklMYmnEBsBwi2BkQBjVCc5qhRFhVpzuUTOKiQNNEt9gHlDXB6nkHMMkg5qrVK7LdPOztmOTZ8m21ZPpfZE0GTijmdR57EW1lIg0uGzcEeHENcEn7/zrpSJiJYCOFhS6uiLq4bPDBxGn/krGGT3es2f2XbCFMHc0Gge6OAQtaRwbizLNLE1ElSUoHSuS2eP7U5BEHpn4jgguKWxtPf8Iv7kGNVY+OGikCuP3V/krgU8E04XDhebjoEJhOGf4J11+AZ22uvL8dtePCzpp4M1NA7XhmzBQjC8Qwxm5+6reIIocsrGfHHhMmaejk0JUD1ENEI9wHSCmU55c6vTRo20E4D3SOTJjZc2c6678+kwZ776OlvwVNaLX0okhxg2DotlctAUhlpkBmEW8vxNoX4FP99c2p2MVWG5HzNnEoNTNF6qGSUXCAf6oNxRLlQL8BtU6CPdat41qqFNnbb+beL8rXyzn9+KtkfzSP5VgVDbHD+nFmBWFit697QLStVFKX3HQn6QSKN0WZiIYEZ9u3yxkx/f37vZfFNDPaTUElDF6iHJFNi9KDtXvdjuOmhaD1hF9AaF8Byba0nXfjLzcTAq9pzVamLCt6qSssobDTzm/tWuNeUfB9C9YvLTGyuU0+iYp4ebTJELjpvOB7goowV38lchyfTm5wnqrfBIfPeOjy
 GLLdv7I3
 eyBZvpC0MTPi/6MCwfU1/RgIMomT04owy2PQmKJ6EeExXNG3lsnug3t0Oaif2Y7JEqmoxAF1h/8YB8ayVGEAPqMpXk3ThMnkpje2Y4O2SIPAzBFD9lZD162K7GzvSo+EKyrnAC85ddUAfnAneKj5GEPz0AG123wYgjjYf6BLteCpeJXI5rGzEmAeQ5DKmI4blpFshFRW2G8Dtldf/h+sIWxgPLyE974QgBOa/JrT+3zsevuvVR6zxm+StnmPhjNp78fWi39FyXHJutVQQ4sQWbQpyw015fCfbQ+Ee9ORbC2bM6gemI4cqVLME8KmlBCBpP62p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Codes in mm/page_io.c are only related to swap io, it has
nothing to do with other page io.

Rename it to avoid confusion.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 MAINTAINERS                 | 2 +-
 mm/Makefile                 | 2 +-
 mm/swap.h                   | 2 +-
 mm/{page_io.c => swap_io.c} | 2 --
 4 files changed, 3 insertions(+), 5 deletions(-)
 rename mm/{page_io.c => swap_io.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92eb723573aa..6fb19fe0bdd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16948,7 +16948,7 @@ F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-F:	mm/page_io.c
+F:	mm/swap_io.c
 F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..a65ac900096a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -75,7 +75,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= swap_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap.h b/mm/swap.h
index bfafa637c458..81a80605fc6a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -210,7 +210,7 @@ extern void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
 			      unsigned long offset, unsigned int nr_pages);
 
-/* linux/mm/page_io.c */
+/* linux/mm/swap_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
diff --git a/mm/page_io.c b/mm/swap_io.c
similarity index 99%
rename from mm/page_io.c
rename to mm/swap_io.c
index a2c034660c80..4bf210bd677e 100644
--- a/mm/page_io.c
+++ b/mm/swap_io.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/page_io.c
- *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
  *  Swap reorganised 29.12.95, 
-- 
2.52.0


