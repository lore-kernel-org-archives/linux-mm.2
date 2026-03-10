Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5572BEB1058
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED8A6B00A5; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D25C6B00A8; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FCE6B00A6; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47F0B6B00A8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 128D21A015D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.30.4612268
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1C2540018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=dw1nuFFW;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy402GJXbgyAJ+YKb8LodXTXPBtJ8ptnh7Eq9VEeyMQ=;
	b=c4ICYJ+LNwK66t+NxxEnqjplJgjkEhlMhF87tpv4uROKv8U+svzRMq57PW2wzCNU6HvNBQ
	C1CMYOZ2kcYOUiY0951ujSH1iC8zuBNBnpnAd/xtAJqe7D8Z6UwV6n06SNuarZeW2xqPLf
	vCbxxoCM8vyt3daYDtKEWAOBA/HspzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=FFSs3UEsv6vJqt/qTv544Diwz7UoZCWpWbq97GegzXnx6fqYYKsFdPi7wPWfecry/VPsrF
	jHl7DOQYHCYPXt5nCxnguvmirIQHipyUVsoLdoay8/W80DHG+NsBpYE9is4SegH/BxD5gI
	xxsQCpbkwdGWiFVCy+YbM+3CmcgkX9Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=dw1nuFFW;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=ObADPYZ6pJh7dF4ZtW/umhCREHwhUDWMyq9N6rBcVwQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dw1nuFFWpVVdrKOfBC8Dj4wKZMjU9ddsg9cir5xT91Je3Qc4zdD9Tv9d84zEGU77U
	 bneXu7o4d3sJr/YNLcP9VRF/8FE25ShEW6LPrPIHkFN36JlEXF0VOvnj++ND2duaOC
	 CYWW988mCr9Su8D1d7S5dskAeFMN3TEqL7EVGhxg=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-e21d-7f0000032729-7f000001da1a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:57 +0100
Subject: [PATCH 31/61] net/tipc: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-31-bd63b656022d@avm.de>
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
Cc: Jon Maloy <jmaloy@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1121; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=ObADPYZ6pJh7dF4ZtW/umhCREHwhUDWMyq9N6rBcVwQ=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAY/UcXAwJovG6A4nB7YjchfS8dWMTKJR/2Zu
 MZwvRUzfSuJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGPwAKCRA0LQZT0ays
 2xl9CAC38JfIZK13/o0jdZIM8Gu3hUV57MgGCpPmPgAkgZQzEtBGs2FDO8Fx54b796heUI6C17z
 ZbGY2wRKWGjXSBCngfD+Y2a/1jCSzGEuQ4jVEtxbgFKGiVGPc8zPo3j7RIqGt+XkDfXhUJV/WGs
 +J2xRVA9B3RKAYgO58tDVBDDKVuZmX4cu+ETIaOpu3+o52epJyZqzezdrVwvwMz+c005iQpPVgY
 LKvEVu+vfw1C/S2Bm6+j0K7soEoH7Q1wM0z8TR821F0SvZ3KgnganCVQOD062Ix1eouKRv0CD2a
 gtvYCJFRo6JoTu9p/1jJVnIebiN1A5uUYXaP+Bibs/sNVbrI
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-2FBCCF2F-19F0E4AB/0/0
X-purgate-type: clean
X-purgate-size: 1123
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: x9g3gatdtxtx75z7eatdki6n161s7qm4
X-Rspam-User: 
X-Rspamd-Queue-Id: B1C2540018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143729-339421
X-HE-Meta: U2FsdGVkX19mLBSakji81Di9fIL5BfZv1o2qGzvAu8QuVfnSNSZ2MZvoIdyzieGBjgVvFKaU3QSpRpWo0Pr8XpWs0MJaqFZAL7kKie5GZkno6nM4Nmmd702JnHrOyAnUeaxDf8kCpaUs+r6oYJev1LvP+iAuZ6oe48BS3TzZHQzYSOukLUNdbDLDPYve7nO22aunZhaoApvOmH5m7MKk0PG3nHxyqO2DcX8rlM+H13gdIt1IkJ157q6N7qodFWpz38ZpPNXtj/pb/7CCYPBn4FEWKhUneDUtJaZKQJ3SS1j+9OFLA8kNffaNT7feqAIdSWPHpMSRCtALLVHe16aUV+xc7gxCe5WBN1Z8vwp9nT25/GrYRl8vLCusFZ4243uJiCwQNy2k/TUkD7G+zhR09t6cAE8xD4jggzwV2KQcacYQYcicsqgR8HaNE2nwWsR4Z1HaN7CnSK5BLDkpalJ/d+KjnmTnBX3Nq5g8bYbHTgRD+WygL45IHDZXDRSxNKd3GkYktrcPreMGwPgZGjx9cXmL9SMuZwJijl8j6cEIDfJKyUgzhSHRBQoYiOq+/Cu9UKXMsL0fS+ZxuicTxRU+WVKVTDmeYZ8HGnegqxi8pYQuIh4LKQW5nh4VolMJe1pZne57eF9eFJe9qjICo7aNspj4ajE3JP9ANnaidd1cmMSp+myXyhz/IV7pzR1lZl+On756cM5VufzOgsgL3QyUM40WaZFpGa2Hembn9sjAqW6Fhv1hSbnYlUR0JP0VEZpDloKM10XI49kOcT5JYZVTYn39M3mo84x1V0YW7Yifw/WXWsbZeyAZCk2q/XkQOqVz4JE0Pj/LORx9MqGXQYMghXMArlPHdWMLSIdpb3fL/jXT3wS9uGJw9iI8Thb3RhjiEIFZadLMiVlZCL49wVHzoFY7gsUcPIgnWQNSGNHu8qWajEYigdYqfgKS2sKyHmSC5+Kf356TABp7kAY9SrJ
 6jUd7YJZ
 1VoXJKNBCnegZxwkEGW41d/zCBqGcFBBR8RxKYoXNPPXH461ART3OXWFmCh7O/9TPpL6yuyqDOx//+DFiFOjuLPnmgNZj5oBSi0FpOn2ikEW9dS6/XuXWYM9mx1alFRQQaTjOPLMAKrXxIszpzZg/zlqMcvXZTT/QCfXl5wxmx0j+vS8SGnOAItrmVB0LuA2y/Y6iKpQOFxch7wa8n8F0I2NZuSKC+94mAndlhMG8mNw8QKurUYf0WG+bslqNCkbcbqeEPGam7RmWzgEGLjPfnK7oavgrfK2GpJeWYqSkA6Hx06/8UN9ccn3HAFplZH1ldHAabRPNoRh88ThE81gRVKpDmsnrN38mNCx/UtkVBFhYmREbBQzH+59+mEVK/xkZ92ASma1BXNKPPl0g4MP7GXcC9RvNrpftD5DNYtRFE4oKE0d9nSvfAcQzBsOitPhwhbMfuOZE+8CyaY9rFOhaTl7Ku8r2I/7gtXiBdtv02rJ5KVtguEIFCUe4zRcEoiqmg4Sp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Jon Maloy <jmaloy@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 4c618c2b871db681e69f7aec8f660d6130a13346..0d9cb21ffbf1539b7740e76521e3aac5fde322e3 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2971,7 +2971,7 @@ void tipc_sk_reinit(struct net *net)
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((tsk = rhashtable_walk_next(&iter)) && !IS_ERR(tsk)) {
+		while (!IS_ERR_OR_NULL((tsk = rhashtable_walk_next(&iter)))) {
 			sock_hold(&tsk->sk);
 			rhashtable_walk_stop(&iter);
 			lock_sock(&tsk->sk);

-- 
2.43.0


