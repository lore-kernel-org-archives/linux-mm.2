Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B40EB1056
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961B76B00BE; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B806B00B9; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312EB6B00C6; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C23856B00C7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93FD41B6826
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.18.F074234
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68DBAC0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=aVdcR7RT;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnRdJAitx6jOs8jJbv01Seyqv4d1C7aP2K2DqYjHEbY=;
	b=GviZJtHtVECCo8vmrDEpCn/p7K8q1cwSDv7dtOragLizx6EuQnQIKD4idcy5q76QAc9gNe
	kTgiRsDNSGkwJNatxs5bSOQ9U64SglXtpdwJpqBTYdvuPSth6Tptg7VLqUj9N64SWzl2pf
	W7s+kWOxpV13JDtF+AjGRNvzFvDeFmA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=aVdcR7RT;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=gf110Uj8kT8Cw1i0mr6CttSYZ4GSc0MZrs3EgZN41x/bSvTJ5AqjJtkFw70qHIT2Ri736U
	RkGTrRX4axx1VthiX/KaorFPFLMC97fN5QuSyogDGt7oPjPHJMATuZtyufgRhC708mvDdV
	YPKNwd+tDdSfbMlY0IFDo0+m3r8FKFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=ZbyyRff0LT6QULh5d8SMPc41iTaBzP0/3JVOQy1bx0k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aVdcR7RTuv8C7CerJpQOdVZlvXCBSYXBl1Kv3fGDCxhNKTGGiEGlaXMofbFocGsc4
	 PzD9er4ULxnCoKhdyrJwuV7PXDV42OgML5UN/9dor/cwn1OQ+AYgKJ5KgncLE+Nq9J
	 Tp/LrzPDmFSH5N41KkG4TAeS71Wuyf5xaF4BLtTc=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-2367-7f0000032729-7f000001c9d2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:15 +0100
Subject: [PATCH 49/61] media: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-49-bd63b656022d@avm.de>
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
Cc: Shuah Khan <skhan@linuxfoundation.org>, 
 Kieran Bingham <kieran.bingham@ideasonboard.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1137; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=ZbyyRff0LT6QULh5d8SMPc41iTaBzP0/3JVOQy1bx0k=;
 b=owGbwMvMwMVoossWfHHNmtuMp9WSGDI3sNXOaG8LSpQxY8hSPVKqIh1pc5sxIOPz7VZbeXXdX
 ZHfDi7vZDRmYWDkYpAVU2SxzPmQuzbhSoEJ07IZMINYmUCmMHBxCsBETr7kYJhV9Mu9xk6ccYGt
 z5eI8srl4dfXXYqUXRzEX+fI1uJjH6WxrLeo7biojv5WpVXreE2zezbYn9tpWFQcfdhA7GboGts
 YsRtM2Sv+M4kcacuwnNqZvb/GZGJWrZS8LE8bh/QGFvGyvRsUfnm1/N3xyXReUlT8crHiVPEW88
 th9t3G59lklUJeXporbNhhPOddhfW2O0w/bnRvOz2h//fC3tr8X+mn7tezeLhE/9TY8ugub9qq6
 ED20BjzW2dmxov+rXp6lOvAkub/n+Z/6nD5cFX/zdFNpRcPRKxfsPR8nlf6/VdXbs812Sme8b7r
 xv6PtjP3CotJpB81uFK+Mnp2gw1/TIQQc7bV7OyuT17mAA==
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-1F4BEE1F-D1FCF248/0/0
X-purgate-type: clean
X-purgate-size: 1139
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: icmpzrjfoewhaeac3tsofruumrx571sk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 68DBAC0005
X-HE-Tag: 1773143733-890004
X-HE-Meta: U2FsdGVkX1/5sVX0PSBGAzvxmJmcsljVTQPd5ZvsygVaekq4U0x4pGkHW8gOyd1Y503wQVhSIiYHznhqknaCvI9xmKGuSMZQ81tY5Isf7dqqsr0RxF86TmkrtbY4Z6nO4TWAbUTggmNfbOHxDgL/7ouW+w+/oGgd121ryZUKFCVn6xoudTaACRTrMUc+YQThLY2TlsHhw5EG1eYtarBPoOcC55dcsWvLl6ox8J1vr/zosny++qXzhd6QRs9mEbSRrUni3YaEA933DSsdClq3Y6rB3JDS1id82qKoPJyZzXpCTtdGVIG8Ylybau9TCg8LHDhx+i2d+4rhw5oK9OLTk2xnm1WL5PxukIaTfJGInRvatBS33yAxHItA4FngHmihr53Z8VNLNCb/Xr+dGg5BWHSy1Jyos/YII9pVBZ6NnGKiEuqtnx1LFlC7CPutFgOuxkeUyjmEbhm9plSgqUS3g5/fzmRysioAO/kz5X6vqBgDLPkjNno9M93fbrLDVn9mnGsCPb537zJ+2PGLxfDWkhgDoLzTP87rGh/Jz0hCi7g04CzNoK4HR7yCbhmTUEtCe16eFZFXRl5Ai/xGZ+du7MuLXzMSXaO8F+yzFDMIDADTKaZkRBctgQUZ1BXG+ZhoO4HdT3fYQ9D+cce3/9s/wy4NyNFIqS1oq7KZs2FFx0fpBnMjERXuSJIa2mF8ZT6aPnow5XVC0QYP4ilVF9oWFyWR01LhxKLZbQAr+UiD+D4qVUz/QqlcRLQDj46+qh1mIttfcEM5YuSM/fCTyI5oQR9LWCJ1Pr+AkAW4u2feb0QjdXEdFyd78a4n2/Dg5YDLz26OLUrh3Lx7qfLISOEvDmARWuX8mRUbBLlJHAH7TRLwh9E/pLUaCQwcB0WBf9RDoZvuIL8EFKcf7ChU+mUr8s6pBBU8N5cL8bB2K20EzGpJ0Q7GzcEZAG12Wo1DtKM3OXMWamvVBDZiTS24WAv
 WUJ7Z3O9
 bouOlZVAANg0IRnY8LZsYNDIS9uZan9fQ9SPo8DijrgNOY0PP5Lt/ohUHOdriV/NwaB3tAUjNx7JsIvXDTFX/FUtfsP95U4rHgGOf7ZGlFFkMwe8SKCtGtexlzYvzd1ul+sFuHgxUEKMyHv4Ge+65XF1kqBq9I0hafev8/Kmag3WI3n9AmGWTedaOzYMKgUg67tJ3tb4Q36wsHoLUSieAz4GJXfl7Gvl4RzWSlKc6fLh44KbMmgrQttN3uuO+o9FBiwwmUz3+5kDuYJd0SzTT6Yh3F17XfIpkjg26Ep1ZsFUaEX8rGqhqXckANl4oRYNg63cHZy6SITy7Og1+rQiIoa7oYw+RgUijOwiOcn25yZ9EQPcisX2ycZWGuCHpQT2Njay3KVbzuxt53GFDRPN2Kfm3SRIIAtkBJmSgglB3rRyfKAPtMo7ztez7wZnqs9t/HvvjxZH5lOdDW0BOSEhgw8D5JxtihC+Skq5qjOJ5rkDhqdeDI7JHQKTeQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Shuah Khan <skhan@linuxfoundation.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/media/test-drivers/vimc/vimc-streamer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vimc/vimc-streamer.c b/drivers/media/test-drivers/vimc/vimc-streamer.c
index 15d863f97cbf96b7ca7fbf3d7b6b6ec39fcc8ae3..da5aca50bcb4990c06f28e5a883eb398606991e9 100644
--- a/drivers/media/test-drivers/vimc/vimc-streamer.c
+++ b/drivers/media/test-drivers/vimc/vimc-streamer.c
@@ -167,7 +167,7 @@ static int vimc_streamer_thread(void *data)
 		for (i = stream->pipe_size - 1; i >= 0; i--) {
 			frame = stream->ved_pipeline[i]->process_frame(
 					stream->ved_pipeline[i], frame);
-			if (!frame || IS_ERR(frame))
+			if (IS_ERR_OR_NULL(frame))
 				break;
 		}
 		//wait for 60hz

-- 
2.43.0


