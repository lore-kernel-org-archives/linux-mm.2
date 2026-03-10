Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FEDEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384336B00B4; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F5E6B00B6; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4FC6B00A7; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77CF86B00B5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AB5E1B6BEB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.15.E621E1C
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C7F5100017
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=EmfqFdXE;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf05.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iY5b+S6DY49d8oUcqDtGLxUKyWGyNfNq5dhmPPuwVI4=;
	b=IknEuaXummutXoh8718Djw9G1f2EPHdR2wrwa4CbjjYkv128sYwruCe5Y1E6lUTEAGAQVa
	ml0rFEV5T+Aw7qYU0jMFEkX0FP6XeZrio182nvixNinRQIpiPhCkhHO3yFESuzJwNJY0J5
	2pSG2Ryp5piW5c17POin/Da6MclrbKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=5/J7fRRUAt5Yq+vFMNQNEmoKicsJqE554WwSI3RgwCbLuVgSWDnCqGgURAEQPe3LsTId2I
	FhzrA1JUeGD3A13EOVsuYGTH+XrUFTLPnnZwBMz5Dj4JSxvjpLAs94FGPQNWZ94gBixux2
	6NGgekL4kXwmTLwnO/EFENAZ/m7FR4Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=EmfqFdXE;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf05.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=uPgyjK+s+NGMdE+cG5MPshRhc7ZZgUWwr7PoRjCZSpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EmfqFdXEdiCWqgoXgX8BLevw6sTpNgfg8llLMS9eEaTKVg51Kp8K29SjBZVEdIV/s
	 M7bvI3BPyHpPb6vMRi2BheqpUIfCWQ/6jm+gYuX79PpwCNDjLncHrcFsaokOkzLrgm
	 dBKJjX9bdtP/6DkQEVr2DPx5QPmWYl9+WXcAxUUE=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f0000019d9a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:55 +0100
Subject: [PATCH 29/61] net/sctp: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-29-bd63b656022d@avm.de>
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
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=uPgyjK+s+NGMdE+cG5MPshRhc7ZZgUWwr7PoRjCZSpk=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAY4baP8me9X19X7pKru5bhCt+OcLVsbTz9gw
 3EXL2x+9HiJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGOAAKCRA0LQZT0ays
 20eCB/9R10a8QtWnOE8FDIK68et8w+x4vBIl7DAH3ljWsVvEsJtllIM7WoriXoMKcy69weBfdTt
 udsIaDDf3FpSbi6d23LNVWvY7/j8StHi4Mb7YRTkDtjVuH7qFkxhMIEkO0P72RZbdjNmUsWZOT+
 4yfdZZ4sqiFeE73LKQ05t8sm9/1XHgZKcnk5I6ebEYNeQeVfoiugFSvaTmWSBPUItBis/2y3N1h
 19AfztgUerK/fadW7Y/vZ3pDRpIi5ZAslPLWaCgGa6B5OoDoVAvOz5XPc/Ut45LGyZkJYA2qiTr
 TmaKunQohnKINyK0THlxz9DBNJM47y+p9em5r+zCNMTJFQSn
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-73CEFE1F-39E0F1CD/0/0
X-purgate-type: clean
X-purgate-size: 1171
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C7F5100017
X-Stat-Signature: 56nf1pzsza16jb46csmjgy5j7ntgu48b
X-Rspam-User: 
X-HE-Tag: 1773143730-637100
X-HE-Meta: U2FsdGVkX18Xt7cSQTd7zSc4lSN789EXtc4mNBYR3ZztGrsWIp1cUUnB5w/H7AP+zGVvvltaaSCLPDC2eB3Jns1APTGKoBDv+ysF09WvAiousUZuq5mYcIQp25uemBZLkGKWS3eFXJa5G8zJ+aFSomu22FUVm4HgjH0PXExDfWpaBEcN0iuaUyi9VXWR0hn3G9Vr+ctL1nH/+l4UvbN7Cf7BtEE+g4twk9l77oompzvZskn4Rv2HSjvXvRXwOR3bzGDH9RUkUzaCD9y0mdo/xxZOXufctkuuPgTaNEPPKR/q9ta8hcN9YF9zB8hiK/EBbc7KZeb9y4JgledLzR1t2dFTZABWFmVRd7NO/P0vhQbcG4xIkw/zuqGP6/D8hbNVTnkYu74rzmfIy+EEcu/6dimbtFptGHNv1RWUaZB6tK4Ewqk2oZydusdXoPhIPS0305/mYQko4z5Fh625aONX5Dp4zWsDdjE3heaYCPkKBt7SgbN3npZGngVcyOXUJl7vmL8OoK/f4OOESi7ASw3WtYmOpgQk4El+A9ps8kNixXRPRD5DSALt9mswrLG62peg8yv0rvaaJYHFQxXyuXOwiBY1Uv4aOP8M74bmFFKf/Hfd//QnQibO+nmwOY8Qq7000EGFNb0xZ0TaVRR+izpRutO5W4JKT0Iq42H8d4S8eYi8hINQLToLC8BnfekoVgmVv9Jw4IcA6YFBqS4B0lWkxA1abNWRRI3R4FSYnvb+7ensWiiGPfQ5zkhbLuUcVkM3VgUzz4gvejJHJElSt2ajR9u2La6nL2+PCYZLGs1fYeyAXj6z1KR3crQ1z/Lgi4H+R1SHRLQHCcLv0oOy6AHpPqyVLYhSntovX8SfuWFroPdkIAc6354Se5PapjSbU/areBeZbxvB0iObPqHwd/W3J1PfTgfiMcEI8Yday9JMHKw7UTbSRzDxh5dHHI/jdemnB0ewF4q44ZIs8ezdY8u
 iUcfkIU2
 WSvsRuUjcXg2/onldjb2zNx2uaVyOPbjgB65A97SPK0ZA2u2gNvuKmQLxyb5Ah6D1to5/KfhKHey/R0vnuTduKRgeeb7NdVBABT7Z4iRp0nU+62erZ4kDnr4y0BglMpkbPleuigG3NLOSUaQ54F8uSqa8zz+Zfaj+2JIQHWaI9o/Ub7+jk1qCdtrSvON7/PlzCE2JRAqdtquu5nWtqbiWjiwtOfng5vpqcrQN5cDE1jb4XECx6pKgSSR5tdQ31VqQfFbBcMoHcevuybFIePfbVEKizwrJRwImucURA8avFcA0YtjdXAsFlI8++SeB31o4/Hz5RT9OgH8CmzBa4xsb0JeIOlNHrBM4aC3UOG0Mo7oEhxUrB70fDZ2/XEVuzzn9Q7T3urMUJMk30tPk4K3aaK46t3AUQaVrN5vxWcedUa+ABYJhSCPDJNVOXEn8xYL2dspLeCBs9faeqE+KifFZpqeQHLwX14KwA/qAjt82WTS3txJ5u+Tvb6U2eba/rjho06YY83DFLoY9qMksltJcIT78/WhDCMxFxmcv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 05fb00c9c33576d1e18ee31c34974d8b76efa768..a0596c94be4ad6afae6be13adb3bce17140264e9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5349,7 +5349,7 @@ struct sctp_transport *sctp_transport_get_idx(struct net *net,
 	if (!pos)
 		return SEQ_START_TOKEN;
 
-	while ((t = sctp_transport_get_next(net, iter)) && !IS_ERR(t)) {
+	while (!IS_ERR_OR_NULL((t = sctp_transport_get_next(net, iter)))) {
 		if (!--pos)
 			break;
 		sctp_transport_put(t);

-- 
2.43.0


