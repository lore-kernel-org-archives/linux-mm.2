Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8208CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D470A8E00E6; Wed, 29 Oct 2025 15:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6A48E00B2; Wed, 29 Oct 2025 15:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6098E00E6; Wed, 29 Oct 2025 15:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A84C18E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:56:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B46912AF7A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:38 +0000 (UTC)
X-FDA: 84052209276.10.F6A2FA6
Received: from sienna.cherry.relay.mailchannels.net (sienna.cherry.relay.mailchannels.net [23.83.223.165])
	by imf03.hostedemail.com (Postfix) with ESMTP id B5B052000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=SLyEyZvW;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.223.165 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCV8d8hkCWTgJ3eAolDw1gbKzjB4rwTY7mZr1G7gEsM=;
	b=TUoAB6dTPbQnOSdIRrt/x21U4TYyiWzvZ3rMlDRa8OSysL2aN5a6Qi7t1Vh8VJRfw9h8P9
	a3Q+dqMWDsoecDaNlNwI1n2Lvd60aEALaMtOBr8Bs/DatIMGF6fGzHv6g9TPWD87h2220I
	Neyj7cBa5GXyaz3TrC2vvpQrB/nWqWw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761767796; a=rsa-sha256;
	cv=pass;
	b=zLvhBtXl954urJAGU2gbuKb3JUN3deOoFnTGCTNh+WhglMp8QXtp5VgDj0EB5uOR+rVICD
	BRQ9PAUCf3LbbS+12HeBoFSnCOUDwsDfTPghIW87IRol+DYacnAundOLdW01VAT8NlMP4o
	ePCTRrpfBFCI67gZi1cA+DE6epBWbPU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=SLyEyZvW;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.223.165 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 05F78581A89;
	Wed, 29 Oct 2025 19:56:34 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (trex-green-6.trex.outbound.svc.cluster.local [100.120.23.87])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 8A6B0581B1A;
	Wed, 29 Oct 2025 19:56:32 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761767793; a=rsa-sha256;
	cv=none;
	b=MvdKsWQYOMXmJ9KJxpc0G1doQwdCvu9+yDrKpt5IV+09hpyPy3SIZbJ54wBbtQ3NOunmaG
	MZdh7rpLFXbWEm6nwJ3itD9XwlxMt94M/e1RNbZy0uDf2pDg08tHvGP22NsCD5qWz3ou1S
	mF/UXRky/o7Yu5dcJuH1xebP3ZWqJmSBC00J7vIxwSIaGCQWG+3RJkMklATZ3AMn2AoTOq
	fu4CuiTRr0PEuX/HkELc7q7iP2YgcMNT94E6GRY3/0iDMcKrV41Cx/M24e9+X0RJFgi6LX
	kVZSjEnWLhCrSYcTSGpFKu/GN0y78ulD4JrvNQnBpc1xabulfYr2B/aO7egeYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761767793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCV8d8hkCWTgJ3eAolDw1gbKzjB4rwTY7mZr1G7gEsM=;
	b=hnzqrJju1va0dw7TKJyyujXAm6ior4L3IqWpNjFXPgoCMdGBtJe+kYiXKL8oMSxuroZ5d6
	0fCpL040wh/h58rPyADiFxD8Sd3oIz0eb7Yz+77njhufAQJexd6jD0xvTyqkf6hYmmF5yE
	1Bd0iwq/hMTGzGUDTtCnR1LOPioXEd4kVxnKY3eGw74mbujTYgTYwGPfD2APx2RJNzbHK2
	e6jnPJwgZFnzJcVY6Hj1wvGK+cdrlXfYeBCnKNng3OMQ+6bxTyn95Omhlx7Viuklf2wNx3
	OkFjs4YHzDVwRL665wBEZ6QZuDytOIMNUiT/J6lXHFcpR8D5kp5Trmk6YeW82g==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-99j82;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Duck-Oafish: 4eeac15e4e8eb738_1761767793902_3281705601
X-MC-Loop-Signature: 1761767793902:1346860316
X-MC-Ingress-Time: 1761767793901
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.23.87 (trex/7.1.3);
	Wed, 29 Oct 2025 19:56:33 +0000
Received: from fedora.tail0cc0bf.ts.net (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cxdKm5YC2z1xqq;
	Wed, 29 Oct 2025 19:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761767789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MCV8d8hkCWTgJ3eAolDw1gbKzjB4rwTY7mZr1G7gEsM=;
	b=SLyEyZvWTNKz+voO/tYDzZmoW7Q+E1GwTZewG1JC59taQy3ovpR11hkseTq/3LtMuLPDqI
	lBbo4CTimtnVSsGUYlwgiFuSuTOxvfKR0tkprDnyAYhU8raH1kMdX9uJpzG2VDLqQ3OYHu
	esfT3rBAjMz5eaqS2S+neeGjbi19R421oI9GoJEAhYXKdcfiUZaiq87rO2E6vC7o3I1aAh
	HTk3Da0XjNcIHtXEenILmoLRm+uc5TpUUpYAssweEdhMLhp9Yw+dciWI5iUXFrI7to4Ql3
	ytFpRvAACp5c/McpeDmHYHhbiYtMkM8DQRmHFiy5sOF8Tq7dor4PPnA2E2OinQ==
From: Israel Batista <linux@israelbatista.dev.br>
To: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: osandov@osandov.com,
	linux-debuggers@vger.kernel.org
Subject: [PATCH v2 1/3] mm: convert memory block states (MEM_*) macros to enum
Message-ID: <20251029195617.2210700-2-linux@israelbatista.dev.br>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029195617.2210700-1-linux@israelbatista.dev.br>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Oct 2025 19:56:28 +0000 (UTC)
X-CM-Envelope: MS4xfGAOrk74A6FkVNKPp0W8ZdrhTgTvM9P38meGAhcWO3zTB4iIK52VPVYe6/DIKtEC0UsV09Ru9DcRC1wn3y6VxlJFCOOdyGySRMrb4wz+gCUAyZqdqglG KY2IbCubxB8CrHo5LcO/fnr/ydQBCY15Zu/MWVvjJl+RjigXgaPZNoJ3Xtr9zp0qyRxkPYljcxEix/XXm/9jY4BmMd+Om7ELIxHaVj2xQAuSbxtb08y/LJa7 BwBVxPG+oq67GD/jMUCL4NT8aso6HdKBEzGjhZ+tHFSvdjCvGD/qnvgflWrvZHHplQ+JP4GgzdSdQeEjRsReDv22uZgQV5Bya2+fmzgEZzB9uY9iaIrtrLeb cLTclJVKie7ZBAw8UF5ZHZ1KkI3OxRfNWWJ7zFN0Kxmkhe65XOn5MJRN42Nh9W2/0DQYPu6VUsSQxfHMI4czB6nPic3LvNGhQrxD8znnoWi/YGMzzX0=
X-CM-Analysis: v=2.4 cv=NuiDcNdJ c=1 sm=1 tr=0 ts=6902716d a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=_i9uciKyxjiCmyIxm1cA:9 a=TWtOS45hTxhqQf3p7L_t:22
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Queue-Id: B5B052000B
X-Rspamd-Server: rspam02
X-Stat-Signature: cufghz7xeth7iib1qqiosdy3xr8oiho9
X-HE-Tag: 1761767795-591553
X-HE-Meta: U2FsdGVkX1/c8GoQZrf+AQ2gONeJ07YyN4dl+/trrb1FKEXlWmzMEwPuNTWXV2466YoavQUZF0k8m+4knGsZAmnh6o6S8KfPzmAwFTGpzqtqEveETK3dq0v/3suvfTXzBrBbezVN3hxqy9KymRmYyr0yTWmHsDCKmJVpXezTuJjzDeEttw6YRblrofhvtXFoUsALGkz131iWuSNbfv4Yq9vIiQC4m3eBylv4Lj9LfAurR/uk/F2SSIF/Y+u14ZhZrT6/lf4qOCf876yB74fvMMAOxTsz31Zad/pprpKS+PuRbZKiv1RuaduaP8/5XfjMVW2A7lgch/a2WujONjbLqXvE3EoPJP6AgTAm6zzQDR2VXl5fp98I3PsnaHv+f69l7GRaWsYx/bAuNhOkkbs6eFzkoNEmCMdmPTv90f5oTTM/1wpSUAaT63JFHFymJNsLtt8UHiY+eulGBLh8SVp61Z2hrs5v222YV00cJOP+Si/sIi4BybYS4LlgSHs6douIqje2gLBg0RdDFMNtw5H97+S5KJsKHMhKIMY5XWtfG3yBXBklx+3EMC+VqObp7ElsonH8dyQG2yMqHP59bUNsqsLEzjLYr469J264MKjpRkWO/nNwE5Ivd+Zs4XBgfuldNUnJYh61bi+Uo7+lMhFt0tUcyOz+8KiLeNnXbUWgwjKTgB2lNSUUUROUZ4RetYt3P0psG4PJAYvNa3WkJpDKj8SxzxeRE0N53AypXJc4btEuN9g6vp+LZ6N+UMs87HdK6qcjy1Xj6Xp01ns7vkY8+rZ5vTOTTgyGK1dtkYaJoIC3XbsYExNN50OGqiQ2eKaLSH3YGYZ8rmGvjmleY4ikgVmxoHVE0JKX+aF+Gw5zG3HtdbiOFi/aR2bcywoN7b0FvlBLqSlBREjMT5UEb0e5LaDomGg83appWjAEoEvX4kr+8D92CngISN4T1YQUuLN+Qg6qSDpMmJz2Icn4kVx
 hZ6thPmu
 2FV6CXNSeOAZptTAp4Lig4Gj5UPQ6Fg0I/S7UMuKQ81GTQhpjH5/w/pvJ3nS6HjoP1nf21saKvPNpX1gnPgVLdRHgkckkygY6TkVcFgNitWy9Z1gOnyuVXD4SJsbODkI98a1eQLQ4M6EkvIeSSioVOCwkCZbJjsIUzskuz2IKSSrXC3BuDZz1et5Fg3rrnwyRQN6/hY0Z6VESDaXfisoQSlRZHPhejYI8D+hs/c1qhYrWZobJik0Ymx3kxw6gT5XWsNWBTit4xA9GX6s8hPmvDY2SOwLdFDAL5RcoHH45HrrKG2HMEpefmgR+t85br+wJr3l4+k/4EJWRlzPOp2vC3eIUe5aMA8pJsEcD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000117, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Converting the MEM_* constants from macros to an enum ensures that their
values will be correctly emitted in the debug symbols, making it easier
to trace the meaning of each value when debugging with tools such as
drgn, without the need to hard-code the values.

Since the values are mutually exclusive and they are not exposed directly to
userspace, I also dropped the misleading pattern (1<<X) that made it look like
they were combinable flags.

Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
---
 include/linux/memory.h | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 0c214256216f..f4e358477c6a 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -64,6 +64,18 @@ struct memory_group {
 	};
 };
 
+enum memory_block_state {
+	/* These states are exposed to userspace as text strings in sysfs */
+	MEM_ONLINE,		/* exposed to userspace */
+	MEM_GOING_OFFLINE,	/* exposed to userspace */
+	MEM_OFFLINE,		/* exposed to userspace */
+	MEM_GOING_ONLINE,
+	MEM_CANCEL_ONLINE,
+	MEM_CANCEL_OFFLINE,
+	MEM_PREPARE_ONLINE,
+	MEM_FINISH_OFFLINE,
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
@@ -89,16 +101,6 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
-/* These states are exposed to userspace as text strings in sysfs */
-#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
-#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
-#define	MEM_GOING_ONLINE	(1<<3)
-#define	MEM_CANCEL_ONLINE	(1<<4)
-#define	MEM_CANCEL_OFFLINE	(1<<5)
-#define	MEM_PREPARE_ONLINE	(1<<6)
-#define	MEM_FINISH_OFFLINE	(1<<7)
-
 struct memory_notify {
 	/*
 	 * The altmap_start_pfn and altmap_nr_pages fields are designated for
-- 
2.51.0


