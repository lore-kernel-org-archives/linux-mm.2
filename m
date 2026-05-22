Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0B7CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEB06B0095; Thu, 21 May 2026 22:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEFD6B0096; Thu, 21 May 2026 22:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5436B0098; Thu, 21 May 2026 22:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAB826B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:58:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 770D01617AE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:58:03 +0000 (UTC)
X-FDA: 84793546446.27.D4AD900
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf03.hostedemail.com (Postfix) with ESMTP id 567C120005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:58:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YpzE0tdiXj4w88ryDWGBuBai6wJ7Ty4ZeXonfnpxkh4=;
	b=uDOZXFeIO7dDZwgaRQrRFVyosGF1Wt1dYeHABzmfZg0tzIsz/IwwOS++vf6LaLlEyAFeyY
	Xr07MkjVLOhU64/++dGpDSubL8AGbmlYyWpt8ZX5A0XJNZhcAO6qOsIF6bwhYp9QY34Tle
	J4hbnGwXI0w/fHYpRL8ApVIW8XdUQLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418681; a=rsa-sha256;
	cv=none;
	b=PquH9I8KO04pPRQgpdaPDGgYYzpAQIeJZZpSDnglo3ula4XcxLX1pyviUa2IRgfPK+zatv
	r32jDr8rOUxdvz5FLGZ9fuCVO0ZiIsW7xWfRea66gcYxa1HpLSPf6PtP8eC+gZetRZiLpv
	lIilFlHH+EOSQWhjmQfQ0pYBU6WlKkc=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gM91w53lNz51Srk;
	Fri, 22 May 2026 10:57:56 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64M2vru5021644;
	Fri, 22 May 2026 10:57:53 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 10:57:54 +0800 (CST)
X-Zmail-TransId: 2afc6a0fc632e7e-0d3f4
X-Mailer: Zmail v1.0
Message-ID: <20260522105754477r3fHG2ryVBxFDxUNA895E@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 10:57:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDMvNl0gTUFJTlRBSU5FUlM6IGFkZCBteXNlbGYgYXMgcmV2aWV3ZXIgZm9yIHJtYXAgc2VjdGlvbg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64M2vru5021644
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 22 May 2026 10:57:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC634.000/4gM91w53lNz51Srk
X-Stat-Signature: 84cntxi3yyzwny948myutenwgbydyobb
X-Rspamd-Queue-Id: 567C120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779418681-662001
X-HE-Meta: U2FsdGVkX18sw35Dy+NaFpCsYmuiAwtyulKnl69S5K2X9QegZ/7AQgPHiLoLOyhy9Dww6MMIf5oSwzS9EGMfPRrN90NEsZP/sM8QkJEdxatpjcr2l2DGnpp1RFJgwlxsyTwo/bhmRYLH9b8Rp67kzic+AG55PkDscw2/cVfFTiwEkcUE33EpshtQAT1x01snFIDkQd1MmNPCYOxkdduhsSUx1rTpoGECflb0GBayD+j8VwJu+SoCd88vx3bO78x+Vh5gzgcI/87apD8l7AJrvXVWe/fI1K4hlbjsbDfeCDHIV5Ubr6CjhFAJ5RAiBSYYDF07iIJs8Zfq/qy0CSY4vKjkz53R0fKrKeMQjYneD6ZEjRRgEzJsdFQ7Yh/lpTcuTZxGF6aZ6UUVM0pzeKllYin174X40tby6cB35R070bv9cKt5u+KIobl+fN8YNiMVrwKe6i2z0kVCr57lJzQZFMxSPYFiwUBzGovSjBtdZWsCnzIWd30lXTaAutMrsE6N2n7nDHYTnI5Qp75Fdia4LalDpjSyZefIuG/Kx5WjDqo9SPbzhadYoTHjYsdLfK5sxW3b/caeoig+IwsFG4amLySnPP8oKgnu9ZISzLAu0ZXbuQpqlrDGsQRQwXHbEO7WSzSsW22SSvJcpOaKIy9eFhs26UUM62xzcVC0tcxfFcGvmKD0UkIJCjMxMoHOjw2ELQnz7rZVE9BuDnix2LHjCWNUoZ8kNQJ29/u+1gVq+9NO+MFQEu5OrhILt5b5zPHgvZd1SxL7/KDaKCWpzvY7IJOtMI8r6hi3Md5qXge9bgaTIa4KPNnSt8JkTOsFAbWO+m/fau77urfSlKnARTDaDs4/IunSuJxp3ieX9633I0gFKiTmvZbT4kEMJZTpinFqyB47U0MzmHHyfLJvzTpHWT9u3ys6Cq8iQrO1gw3u+e1dhoQgDwtKqKTjZDAVmWc5Lkpv9iO2cS4MuCB8d0+
 T3jYZZVx
 BF02c/CBypPch0niKfz+ci6OQ2u53VPf861mqGa4lPu9uDJqiuPtr3+Qplx+Q5OZg/iVzmXvrHwJ8snGl7/tIO01t0FEH6xNpnalZIUEdCTUcxy7XBjKDqhLbtR9+7PL0p2wqLC0Fe1u49Rpra8by3JkWV8Em/qeBozVl3VF98o20qnP3xo1uvQtKarhxjBCDBdt2jGMEGZsD8whrYT8zzq8pOVy9/xs8zlqTc9ROvc5x/CJKTpw25ym7lmg5nFPDy5q8YQawW1oH05X6xpqzukKaAWu88Sm0jMNZ+0FKDXZqwPidfWmpdkwmgP/gvEJ4rnbJTT/QMD0+lKSgPqHHsodzzM4h5I9bgOdwK+nJS3Yb8aYzekYfijE25NJ+jpS7XCkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

To help review future changes related to rmap tracing and testing,
add myself as a reviewer (R:) for the rmap entry, and also update
the file patterns to include:

 - include/trace/events/rmap.h
 - tools/testing/rmap/rmap_benchmark.c

Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e7268d2f6ec..01cc34cc83a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17006,11 +17006,14 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Xu Xin <xu.xin16@zte.com.cn>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	include/trace/events/rmap.h
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
+F:	tools/testing/rmap/rmap_benchmark.c
 F:	tools/testing/selftests/mm/rmap.c

 MEMORY MANAGEMENT - SECRETMEM
-- 
2.25.1

