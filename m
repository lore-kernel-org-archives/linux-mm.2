Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23117EB1056
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC836B00AC; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8E66B00B3; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8872A6B00AA; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224ED6B00B0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE81F138337
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.11.57F978D
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf12.hostedemail.com (Postfix) with ESMTP id B7C4140004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=qDt+eOK1;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkVJJN6s61vqv/oYn7Rklty5Kyy7/KKuT2I194xYAyU=;
	b=OEMY2H73iU4Qrb/O9etLyLxMoT1NaXGRnwaVCSW1r3TgxlbIsdvVgfq3PZLjCzG9uy+FzF
	rsR3Z9KtLa9qhDlU5QfZS/WwTgKUgaSde/Oz44jyAhDLaNyolCmTBp9/XMeug3Ar12OmVN
	Umjn3GELOBROjQaPKqecXS4YLsPc7CE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=qDt+eOK1;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=xM57mY50zFSVfYLfJ+plWKaDuZXH6MpRnO24+ChzO5C1kY+FuN2IBltzsBQt3ejF3M6t4U
	GqzGWkue+yg4cJkI41O2N6aoNnpB3E30KZ2GGwNqgPSuQv3lncwTTXoXeDLKBqWr7qom5f
	E1E1Dra+2e2ayyXiiJcXlOZE6XKGWek=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=x2oaB0qg8CghMqZVE4wv6e6u03uqEA8RFTswQdfTK1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qDt+eOK17tgbgqdmabp3KToGWo0cL117JvmRPKJVxtawLwwb7ps7z1wEd3vWO7I7I
	 4b7B5Oqe+82BCygMvdbmbm7KFHTrarRdpcpv9cxBTuo4h8o6I4dLLRK4rlBY6AdxnJ
	 EBWBkLJwSKE2HvUxw9o04CGzwbSOLqvvPPh3XW/0=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f0000019d98-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:52 +0100
Subject: [PATCH 26/61] net/core: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-26-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1267; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=x2oaB0qg8CghMqZVE4wv6e6u03uqEA8RFTswQdfTK1Q=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYuz1CTGrbQpXzwm84r9mgKg2KIh9nV8i33X
 Xzcah43D7uJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGLgAKCRA0LQZT0ays
 231ZB/0bxZ/Qbs9IAD9kpPvo4QA+XnJGKWUdztF9j621/TW306I8+ggVrnqlG+FNuG2wVrw0WhJ
 ixcD9BMxptD/u4aa6XFjRfTlj5zAYq7AiLoV88hQ2zukJ0WZTgZ9ho7LLdTHbtDdQJg3IZi/ib8
 fJneCHe6P6SZ1m2EjqIO05fxr5kL7CgbuXZRdzSHe3+MgFHVghSrb0gT6dh9+gXstARt02FCx1t
 CbFc8t5W3HCfOWn15oLGczjOwJcE0jsoiVRPvvyO1awUr0bgUV2AJDFjkVpAz2ZTueHBx4ee0oO
 uXTsT9eV0KkVBz5xaaOgAyF5s8m06WIrMfH8OhTYPEwluE5m
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-7ACF9E1F-2B37C654/0/0
X-purgate-type: clean
X-purgate-size: 1269
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7C4140004
X-Stat-Signature: 1xgda1arte6148wrz4wahx64dwwwsqwx
X-Rspam-User: 
X-HE-Tag: 1773143730-735740
X-HE-Meta: U2FsdGVkX1/FTGkQjGH72mk7qD5DD0N8FnsZXCUPZXyKjkxQ9en9hMYcPylPtWLddHnsF5QjcrRQ5AC8MMUf8e0m5AyWMdjjAxWMPvz0ecl3+EL7m/+zTXBkhO3LyvDaMXjrcYFJyxo3nuFcdU4P6M7OXq/Xs4zTluB4AfJDmj8bApPfYHu1jvAuN7UuiqM+Zi/pCple1bHvVpuDVS2EpUZA7gJUdr1Ya1Saay8RUCxRFLlNoknwjkU7SC3J6v1nHVaGpUZl6rgMC3jxwGxdXVF/byVQNSI5/JRwIf8Tua5qDP2fkDuXF9UPPv760joMPijMn3YrB/dKkJDk52ziyFmQqgPSIP9Z5h2pqDBkUxl0H4mUosMOOnD8VAjqZNB5JKgiiy6eGk8Tv2LlNtJ6ZSFTLaDbCyhxXV9RokJSIFflVqXGXRCJ4i/yuCjJB+KUtjoh1pSX9gnnl2FBGCNmgvTiDaTqiTiQK1fn/TIaKm94abMqe3wCqj3iZ3toMu6pm471b5MvK71eg1unepc4i8nh0SFlgCxpHUIyNMH2aTnAGjSq67o2BfO7txTV7duQMYfvw5QQX1fgGq1XLFVW0KII/5kg9ewVBRHLgUa1qOE9WBEoiRD6xOTLVrlDFg07sMvorEw/spwgjwidd9InzljjbYxZC0G1NJ8ifwZFAJSmD/rRS4kORlFoWVP6iG4jHn8RyGZW0MF39MjhzPwCwZkiaQXIMlMQ1HUUJSz5HRfveMB/KEBFSqjTIrAJDv9atgSlmNT3+D3ja5jQsE+/ZqLKaX8jpje27VFS79Vao4xaRivOd3Go23D6PnteTqSs/dUL9jBR43kmbPvoLMes6kn47kxPckvMZ0PnhFyr//y1mbMwGwAwQapf20YG+JFC38M0pZdYDxbKAi3Vkt3l528izThopCfEzTWlMcbeK0uDb9Iz+5BujLBBq4ePMx3xi0sNBBycPNUPpzscmrr
 s4RF5bTQ
 ldoK7WKiHwyM6qXoaKYTFnZwMz+bQSD/xPeRaFNB+2/CwWhrV8hiuoxRt7dP9rMq4xCIQJEa4oG8NYBSxrhmyzFGOSM7OhrqzUghYyRMmz+30Wrmb672wt6Z0RIBZgNFf37SIqixdtflhtjUq5jB+2kx0kWOA78Zc/jXgivVbf69RORj75iQNBkjFoX1L/vzjSr8xcJIXAFb7zkc7XguA8RZusL+7gNxMpGlyVIfmwQPfCGRL4dwPXCFtT1khVAcrvWr/I97kceQxdcM2nc67/GVQRq9D+Q44bDb4BlwOfB4FuU89EXxcB8MqsTxw+9AYAXVyCYxb2zhhCbvKsxcpBDbuB4B8BWIJwOHbrxme/cQQhTIuyLZw9mr0ZiUkfQ0B9YU3kbZ2OwcUxdxh8k9sI1d3nUHH3XyOVmRp3WoSoXx8QymhDA7oPMOvfIVtdRncS596FG3OB4rIJifdQjWKNUv6SxzUJxnwGfWF3DMLilB5MwNiODG2Cd1peNEvfjSG4dqWC5ZU6NdhHxJCVRLAilz16aMT9OWzgsmklNjC6kTYKZkI8DG9VgXiNYzzcIZDGf5I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <hawk@kernel.org>
To: John Fastabend <john.fastabend@gmail.com>
To: Stanislav Fomichev <sdf@fomichev.me>
To: Eric Dumazet <edumazet@google.com>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 9890a30584ba7b08b246dacb984b639908f16242..c92cac2ccdb759457c7ce6a38e04e20190dff2a3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -101,7 +101,7 @@ static void mem_allocator_disconnect(void *allocator)
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((xa = rhashtable_walk_next(&iter)) && !IS_ERR(xa)) {
+		while (!IS_ERR_OR_NULL((xa = rhashtable_walk_next(&iter)))) {
 			if (xa->allocator == allocator)
 				mem_xa_remove(xa);
 		}

-- 
2.43.0


