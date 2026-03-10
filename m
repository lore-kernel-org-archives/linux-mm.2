Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1ECEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95126B00B7; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922486B00B9; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650C86B00AA; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01B2E6B00AA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD933C029F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.28.205C979
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A479140017
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ITpeZZvC;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW7ZW/AdL6DqQMQ550rS8xJYq7Gaxx6/BDwT0RbjjT0=;
	b=D2EYWoJbleYFfaG2UIBIFTcGH3dpSzavHq/FTDTPVZ58+cQuaGO0aZZr5wjXUj1yDlvhhN
	RuCldKuRrpRG/tRSaG/IKxAM/I83GFUg0OZIsbpo3zHpxqrERKdEqVmhputzQCl9X3eeNt
	Mkj68r9Lnw+wnl1dmVEDjX4ag1mK9jI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=XkjCCYIZUwUHLkTkm+MBN2LHvEVnL2ZJM7OoH2WdPPrnRz4vax5jMn/9PayDtO8GwGRQqw
	zW2f8u7+fMSAgSrCxW6AUJk9t9yU/07kzZMXBFHspxZbQmkLs3RY0TRbYksvigKbir1DSn
	UNPQvQAqEjOjSuJM10v6CN+SqxxmTCU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ITpeZZvC;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=K9CWTyYKGB0w6Tk2xrcCabYj/9tltesZ0HvDiXE6CGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ITpeZZvCuurO6PtLvdRtRS5nd/bZCx1ndt94VbmepmWY6QteCwWswdiO1VbAljY8r
	 fKxVkij1nMq0v9Gab/FV6dxJIQZxwXhWwA5TgvQnG1MilGO8jeOzxFRlzhEz0vggaA
	 hWfQSJYU7rq79j74Br0/ZAepDgNZ+brN6WE4sbn0=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c05e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:54 +0100
Subject: [PATCH 28/61] net/sched: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-28-bd63b656022d@avm.de>
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
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1649; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=K9CWTyYKGB0w6Tk2xrcCabYj/9tltesZ0HvDiXE6CGA=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAY0Ab3VO2a9CLyi58wXwo/lqSwdB2G61GV4k
 bTbJSvyEGOJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGNAAKCRA0LQZT0ays
 24mRB/9btDfW+RDwuaye8LPDtf1ZUJwDncM7Zgyp6SHFDbDBBUCY5jMLThJncFGvw3pVn6MHlrR
 e+vSLwaJsDAVLn6K23Z4PPrutM/glgm9IAew2t89ZwRwFxQzfV+39rXZfBmOC/J16tW6tO1iy8k
 2C61WhK0hJtogp/FtZ3yHRbCwt8dKoLmF2qlw1QSQLKl8LOMWf3xw4Hzsu7PORnm8NiE+tP0SiT
 14xuZtoKpdLMjWGJyLVgKFIFQUVZBRep4Y+ogBPonV7uWFQl+T8Y21kTTXl++qp7tP7BH5AxDRw
 qjRRlFGTUp8rPbK2m+WUcf3WaJPpbUCWbYm05Bbm4z30Dms3
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-025C1A3D-E80041E6/0/0
X-purgate-type: clean
X-purgate-size: 1651
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: uuqinog7xfsmpytm8y5xqkm9w5oee8ep
X-Rspamd-Queue-Id: 8A479140017
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143731-310765
X-HE-Meta: U2FsdGVkX1/S6NiDoUVuTnkjWZJbWivbGKOIBkgMLeb7M2NhvXVbUyZcTTMWMSEXSsPHaDYnYsEt2kbNFSzHwbpi8S0Fgdkj/zo0Piq1WYWKAqZg6A3M3NeHqQQy+bTKqCPoOnus2p9HO8yQjmnja+ajYfSFsVwgZM12FAQvd87wkDYnSYAwHc7Zhrvn6obE+uc3ckDlhmBNFW+g/VmqXtsPSWtkbOEqXtVqVP6TGcpt3LCRl+yYZ0vFqd/8dlHJ7WMnVmPICadPizojaZHC2ckC28c7KUKu5GWCflY2Bx9f6f2Y3gnQ4muLN4ufxnntRX3CKckEdvsTyLmZcDeqUDjGPr64w7Ic2e9FH476zoBUdW/EQqqIk0kmGO/gFltKe04ijYsNtXGGhujIVLSKIL+DZ/5Qu8Z/+Xfq9jYBn8IvC+2nhqCsrqWP0WouymScrNJSsT+fNmFGMzaR6F3qMJoBtf60tv8Cz57ohIm47ssau2yJCFTac51IhF922wq4geS38lv8KtxTEkTUB8AvCNGfZDhk20+cOC8WORdwA8k1IafeXxpQB+Vy9ItfBuI8G09eyJCzlSJRtlsrbvZJVvjrpEiOjQG6r1HZl9Ee9BvtaQFOgbcPRscqLq5Mb8zaQ3nXZO4AaZoLL1s54k8yvQbbLWebgnFYW+y7P5opOtsRelLxjG9dVo9hyYiooZMQ+rpPYxVrRCGnMrYe9dZvPaa0y3klE2akVSODFaDJN9rFFW9vHWiwohmawWMl5fi4uYSucz8T3jTpSBKBiestSOgeX6rPhO+muH9Rs4ap9m1kDapUpMv/PcKCqaihOhFfc0imYnrIxN2NzK7dNZdAAX7kSXaERfHZcUS1Qsb9ZN6Bvuqx54Wurp2np9WA15f8OIoWPDKkquVigtnEsuxgbYXwtZmysUfAVqUdkY5ewXKFJ5tJHIkoAnMXO2zJ2HTQes49fNwaRAXOlj8sU2h
 ybol5cPi
 YJSiOnsV6V5ZqhC6LdFsb7wrK20EzmW/ghzbZ+szcCGeANqP5Z4DFRM0th6qe/k1qwxNwGzPT6B12zi4ccsvqYlrQbnBbl3s3tvBjgpY2K+6nUmskn5ed0Zkw2mTs/HYZE9AElAbhu2HVPjRgzbYO4ZqIeNOmrhFpQnGJ5y3gFHT4Ey4T5ExVYQhj0WkiknLJ/Y7rf8YlUbS9yWdIGWHANU6LXwNskrMqrULmSovx/1peGY1+DgtT2przGu2fCPj7wn7bkXV/6M3KERttDrGYQIISaoafVr3FIORE99qo/RYoRTDwk5behqijKThWb6jwmhwzT/hK7cU8lTaJe2T519Ru094s2A7uaoh8PYjlLgGSybagj6wqLhu6smO20qqOgWkMKCHvRQ38oiS3zmdO6kHBSjE+8waj75+WyV/HiLsEi87JzYGCFef4EpFcQvuyFpzR8Cis+GJOvMpsTwDvaeeNqWyoUhlAxhA7K5Z4Rmn37+4HI1WWFC3d6izK1w+uGzytAJ5gBtQJztn51dg33CdTczXI7JTfpHgHR8lfs6pIkFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Jamal Hadi Salim <jhs@mojatatu.com>
To: Jiri Pirko <jiri@resnulli.us>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/sched/cls_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4829c27446e3369ad2ae9b3fcb285eca47d59933..4208225e7a4acaf0c331096ebf941f68cc2ed992 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2444,7 +2444,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
 errout_tp:
 	if (chain) {
-		if (tp && !IS_ERR(tp))
+		if (!IS_ERR_OR_NULL(tp))
 			tcf_proto_put(tp, rtnl_held, NULL);
 		if (!tp_created)
 			tcf_chain_put(chain);
@@ -2612,7 +2612,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 errout:
 	if (chain) {
-		if (tp && !IS_ERR(tp))
+		if (!IS_ERR_OR_NULL(tp))
 			tcf_proto_put(tp, rtnl_held, NULL);
 		tcf_chain_put(chain);
 	}
@@ -2741,7 +2741,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	tfilter_put(tp, fh);
 errout:
 	if (chain) {
-		if (tp && !IS_ERR(tp))
+		if (!IS_ERR_OR_NULL(tp))
 			tcf_proto_put(tp, rtnl_held, NULL);
 		tcf_chain_put(chain);
 	}

-- 
2.43.0


