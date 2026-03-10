Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40045EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9556B00B6; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F9F6B00B9; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E810E6B00BE; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 924776B00BC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67E7E87632
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.03.20CCC9F
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E092180005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="cflriKS/";
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XP4gpPWqTj9pDSzwMZXMboF2wk9nIzIBQDXj9hzH44E=;
	b=Ck9GmS9M9OBqSu5RqqiHRF2ezGComIIacKPuZKBKhFIP+G9RyC21WTBTSvDtZrJvzOqs1W
	HQj8Z8h/zbpWZ8g710LamYLxRY6wu9IcbmyFh6wSG7kizEWYFWG1p/zf3t2hBnG/Jh+0MY
	/s79qS/8XzATFsG++R79x7TFfp+QJEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=t2Inw5vlybqprJMoNRdepgQuFGialKGgd4xeVlN9e9pbdr/FbaW7ujTQqpX+m0iXXSLvBu
	NRHXMDo4BywlhMpwSPkawCtKVnSNTLskYHZi17qxOmECkfl2pH0yDED8nVS0KyY58L5ut5
	3BITyaXAiWA4P7x3iBLiZSRheUF3iBY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="cflriKS/";
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=Ch69HE8buqP46euP+YYFTxXSo2whzs/OaZa7KOXrnvQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cflriKS/Uv58AGT33/uwNkwB7J2sdEXakW9Rj3yjFGXI+RI4a366cceElHliZyuuJ
	 mPSZ4TFmYIg3AF1ANgH8AJ4fIbLOCMfBhLuXzJMYqTbevJEc4r+piLw+nWaz0hy5uE
	 Y9GvHMtmRIkJRf4y+wtLqshG0kOCxTBOOJdztUGI=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f000001c97a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:58 +0100
Subject: [PATCH 32/61] net/wireless: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-32-bd63b656022d@avm.de>
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
Cc: Johannes Berg <johannes@sipsolutions.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=917; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Ch69HE8buqP46euP+YYFTxXSo2whzs/OaZa7KOXrnvQ=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZCB6VtswQFIkNrtK394BinlB0uxLllvDTnj
 z6f33li4q+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGQgAKCRA0LQZT0ays
 29wzCAChPFrcW+FfvZBVjABe7F29XZ5724a8XRQE85Iu6UGQCVTrGSBLyo8jXYsg5J3peaPVeKT
 KKhoEQfBVKbt6EAaScrTEpLi3KNOnd86Q8Wna7PddPHX6e15k2MlGUGDjd2Bw64F5NdG8ERAjc6
 DA0lCDlLGGjTu5XPxTGz5ABOwv4DjK6Yeb1iOXElewR1+d8c0JuR13TfzCtZK7b2pKqoZzkmtsk
 88UMWo9/5GiOCX9lUMyP/7qRCJPVDMHslX+kZfg6K27OVxqrHU+QQ1K66P5yscc52ULdw9obFw9
 w1Ny2/RuJ7C5Uaac1egGmoDY7u2Te8bNEht0/tO/Xq6O2NMq
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-964B0E1F-7D6D0A0A/0/0
X-purgate-type: clean
X-purgate-size: 919
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E092180005
X-Stat-Signature: g5tocaysmoocfkguf94k8xc9u8tyu7fx
X-Rspam-User: 
X-HE-Tag: 1773143731-298349
X-HE-Meta: U2FsdGVkX1+auN5bjIQq7XMWagy0hTSSHilVkHmccfoBKDoaU0dYUYVlW1LNsfWXPgN9L90khmPcBEUelTBvyc3UGoxgRCSk3psUvwDE5Hb85db9910dUg93vP6+AaKL8LoUXZ92fhBwy5ZQeLyjw8eLvbPaDpMHfhfFxZme0nhADdUyrtEGRi1/Q6qxCP5ubDlo7aNpqJ7zRyix3XiVmiwLyTJ9BhdyWFjcggmxYO0/zSuwbCxq8TFCtxD1/RFnnVs2TTVyAGPRFKWL/jT2+rOmaZxQd1mR0AzoVL989kMgz37A6IT/4Du6BS7/fSrRCtPCxigwRlW2iDcn0QrkCbeOiIr95KHBwg41YLTTEC27hyab9sKtsIDECYG6z7GJVdg+KTKi/hJZgb071C3xs7DA4yKCzBR8B76re7D7woF6GvMyvDt0/4BWdeyMKR+93HPT0Vjx1BAsz0oAz+I/ufpfNqzfILacjDDqo5894R5Il7KDWwgkw2hP9uBx48BorOE455vdlw+sKGAnlFq3C9PHdmvkb2tNaqYJCarOZLCtNuEFk8ERDYIV/RD89UwlSxgYF3Wft60YuWE07YQdphzIeZ/27GQDSmqIYjcBid9sFtst7ohwn/9fskyBR6WA0fkeN8l9KiOPUzaDfGmej37X9FbafsQHGBDtTdUc/3mXdyQsDThdLoOWYcVeM8Hz4L8e5hXpL4N4yLrM4/PnrNKdqmywy0PDVmeYAHiTzVwKmG+hsn1O9F5RKbdKGirihqontbrt5ZpKi5Tc6ly90OKdyzej8xu3vT2kh2qnSnhjJpB737F/4i00XFgkKYWGNEHZLYt87M5RxhhXef8q2lFfPErdwDg9aq7J4B1kKUW6cj6kY2f+WAxvbKXpb6/dPHW8NBvQzmUqrx/xeomIHO06CUx/NjhhZvINVtbKyoqR4WoWKijVfjYlfVaBFhZCDlFsk/guqZ2R9BKhfqw
 pGgB3Wqr
 9myK2m4BpLOZV06emDmif0zBOuFAwLbML295abfBGnL3ZJmzH0Mloykah+O2bN4/VrrRlPRmwTl1/59RwYFYsNuWJmlnOSsVaMK4MMRpuptvlGrV/VuDi3jG13UoZ6RgXZ4Cs8EN7PTOur5DMT8p46IBtcNaqcimU+lQjiuxzxkG6+hgjWoqLZDBNLiQlNIPtZek3ueazjzOTwzZVkFA6URvliuIBQnrIflKwdMVxuAtLR3dmh5fXuPy59LSckD1e06ZAlPiCjfvVTFTUmZ7/gtxZ9KPzUrk5auZ3kwPoJRr145/hBoi7uZvHLlVIWmAfw+KbtSUxh2lWAcrCCsdtG1jMq7DfSSj7fK8z76JpPLPkkqF2l0RdqKpFByFgsC57zrwqrK4wZXuQxQtI0rUtwB2gPLm0KprSThXx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1c5c38d18febd511285bc4aab93a60b4287dc054..222764a151ea25bec6179dbaffa87f34fdbf8da6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1014,7 +1014,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
-	if (regdb && !IS_ERR(regdb)) {
+	if (!IS_ERR_OR_NULL(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
 		 * queue, due to usage of asynchronous callback

-- 
2.43.0


