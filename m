Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DEE0EB1056
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643546B00A2; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423A96B0098; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD746B0099; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3BE06B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 991641BDAC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
X-FDA: 84529998378.24.02B38E9
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E95480018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=CWhZH8pY;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8Jm3vj7u3QNjr1p8t4oOjObln75+m5CO9VCo8tfBlU=;
	b=8UHzfmV607GeYGCC+tyqrByRv0NDxiBp6GWtnCdRYbhBByYzESn7tsu8mj8HNCYmBt2gFY
	5X0fh2XJHJL9ayIr4n8ZfSVJWO/wVRHR1iqBUqF+0tjWDS1MG5lm9soZJRc/JAfRHX+dSn
	bipLo9VBWzd2ezqA5nxPL/Qvo3ME9H0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=CWhZH8pY;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=GpdneNKRmJpV/+r90IFIxLT1vlem5JljbvS4yXdAOpKq1peJBlqn9V1GP7WX8chUwOdAiU
	q4qzG4JUx0ndF4jgsOKFAv1cqY5iv0RaElvRynLsxBXG+8WEZoseAOD/NKR7QsL+tDIx2d
	v5QUlGviDm9+imwLDP79p0yd1HWBi8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=TePjCBJ2mRHkUlSzKz9AEyXwCeNO/T4sJeJlLVRUEek=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CWhZH8pYoPHXJ9GodRv8bZf7CTCXPR5biEc/ESvLjFSG7M9EoK4FQxeOy1o2q/xFG
	 adtTUhZFnjWgEtd3EnUld9xRhtBPP2LCXHOMBXjK/IfTv5IvUPb5jOISEusb1eiq65
	 jalyJvpG8KfbWsOaQK+eTSDIbq4VvwVTL38wqr+Y=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001c000-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:44 +0100
Subject: [PATCH 18/61] sound: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-18-bd63b656022d@avm.de>
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
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Max Filippov <jcmvbkbc@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2160; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=TePjCBJ2mRHkUlSzKz9AEyXwCeNO/T4sJeJlLVRUEek=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYTbY49pcWmI+zPeufRNN/9dH/gm0tUhIW5M
 sSE0KnGvN+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGEwAKCRA0LQZT0ays
 20TjCACXYevOdzzWZ8zg+QT0mj5XNSQgsj+29ztKUJ+NhTXTaWid39EhUMP397Ax0ta31zsGPRm
 0odiGii9nvcNMTK3z0LbXHwAyd2Q0fNqi4zFsqaNgSljw41n6QLzk50RIIvlMAtwUsismcvcfkc
 GlGmvCqi0YMh5Ps6ZKTVJuHiANRfJwasfti849ayN0tL2bNpZjcStJrsD6oocum/i0yO/DOehLD
 OGOf2TSq2UVG28aLw7N49gUvv1bUDwk6CT215ovMEtUyRG0UE7FpDGWKSdiW4/MWJSzpOO7eARa
 NIfS+Ckmg34HqAiCowU5EbKs98L8LUAVBFgmoB7oAUhpavOc
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-26DC0A3D-7CFC2EAB/0/0
X-purgate-type: clean
X-purgate-size: 2162
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 4E95480018
X-Stat-Signature: 9drngkznx4cg54qbizbcbkoygz6dhhxx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143727-670962
X-HE-Meta: U2FsdGVkX19bZ07d527QbK0Rrb9pEel3EmbOCc15UvT7wVnhUXmi0+d//4MrrjMl3zkXDyD04J6r5yageh7EJygW0st6+mZQgr6sUZPWBlFkEtJhqbW3ViDuBdE2ygfjyGRHpqL0sf8Hvwh+uianw5D45J3mG8DIrFHuKpD7H5qrGQFp+5yMJxp8g4IonWOKeKPEJXjQiwl8cOemZxpq89XU1R/hghHHm1clbcPqBAVqK62U9OM1DL/j73chiSjFaHMU1ei9yN3E2u2iOnkQM8JYXetqJSDiZH0Ztoz3JTVQKm6sMGnV4rFsQfXvGNWxzlPCQ+t+8eNfQui91o6QComj00+wzOvqOyyjO2vj/EmdnFLmM6sZkYHsUMp0Tu8zFuKJ8ELeYYdCUdXFAjYQrucQSmIxfRjgi2y94lerwPNtRqW5ONrkWGKmHf9SB/BvxAtIPdaZJ0iHybhFsgYQ4pRnPB6U8WuZsRGBQTFr394YXT4hXCIS291IcMsUpzct/t11vTiclYWcEl1J0RL1gWx6argcKOZBWpWr5zh2lp/FmcojNeXAZDLnNnjiRpvZATlEAbJrkbiboQTA+g4cc/iI7AC7FCKO5+gpB1RltmAciH1XpSfDnwy6BDodA7GnwqsEAtqy/PT0nCTJJwTkmuZOQ0aDGGCter7BW7vsVv/HR/xHVBdUpQKHa+Eu7H5nR4OuDUan4HFnild7r//o42aIeX0ze8ChefydBDfylJO6DtwsbHJFpDwrxJiacjlukq5jeonMo4H0Dn2vSXgGQiLsMhfIDy8PSn4zQiySqR5EIsPh1OGiPD2FpPeOVLuPo0i+X90g/tCe9JcvBZ5qZy99/BVpOGl2dobCmAfHMGfz4u39lgxytDUFCOfU9zy3Y5Ff5fwpK4MsSw41l59aA9+ROSEGENHG5K+Z8USJsaSNqRACgOw8BNgj4UE28QScHWjZnJyCDM9CChok+S+
 1c7oFEI5
 ltvxCfmPcAl0mtKcwY+35/ppl2dDfJuRvQvTO6G/u4XkQ0ejbQUcwCNTDK3WUqnd69sqvp9zeBieAlARmIlbq73+elSQYp8RdHE7C/ce46nHhNbzEiiH63D3rUtu/JbQw1LAN+3CWSr0/p6REPSjXoHt2CNOiBbIw+/Xs0FsDkiir4JbWgw9XNoeVCO8gmrhZRX1sXh/xzk+rbWrj95xU5UpXUgtWyUUlNQqB9jNJncaRGFgE8G8uT61qm2ewXSNcPrwEIxdrzwDP8cUdsiLwR02ufW5K4KI1yCLL53GJ3qGDJQ/rjIa/Hv1SlJW14Ou/OmttqK6CYfCuZ2Eqj3Du3OHesD2jYR4A9zzAwtgPniMAuxZ6Yx1bwt4zwXiVrLNHKHmFIUP8kWocmT2qJtt4zfK2nHPUj2mBwJ+QNsYhAw8MqyshoBnZ8zOWBzuqPMC83d5Nq+XbL7EyO29xbm5cB0dbLU1Kb8tTzqEprAW3s5ptPBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>
To: Mark Brown <broonie@kernel.org>
To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-sound@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 sound/soc/samsung/i2s.c       | 4 ++--
 sound/soc/xtensa/xtfpga-i2s.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index e9964f0e010aee549cced75d8fe2023e8271d443..6e86f3a0a52dd3f8fc728d634594eb81f9945c57 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -559,7 +559,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 			clk_id = 1;
 
 		if (!any_active(i2s)) {
-			if (priv->op_clk && !IS_ERR(priv->op_clk)) {
+			if (!IS_ERR_OR_NULL(priv->op_clk)) {
 				if ((clk_id && !(mod & rsrc_mask)) ||
 					(!clk_id && (mod & rsrc_mask))) {
 					clk_disable_unprepare(priv->op_clk);
@@ -812,7 +812,7 @@ static int i2s_hw_params(struct snd_pcm_substream *substream,
 	i2s->frmclk = params_rate(params);
 
 	rclksrc = priv->clk_table[CLK_I2S_RCLK_SRC];
-	if (rclksrc && !IS_ERR(rclksrc))
+	if (!IS_ERR_OR_NULL(rclksrc))
 		priv->rclk_srcrate = clk_get_rate(rclksrc);
 
 	return 0;
diff --git a/sound/soc/xtensa/xtfpga-i2s.c b/sound/soc/xtensa/xtfpga-i2s.c
index 678ded059b959d475b6be3766867c8a78bdd4e54..698905257b690457a5d3d315e77d99d487d91f77 100644
--- a/sound/soc/xtensa/xtfpga-i2s.c
+++ b/sound/soc/xtensa/xtfpga-i2s.c
@@ -609,7 +609,7 @@ static void xtfpga_i2s_remove(struct platform_device *pdev)
 {
 	struct xtfpga_i2s *i2s = dev_get_drvdata(&pdev->dev);
 
-	if (i2s->regmap && !IS_ERR(i2s->regmap)) {
+	if (!IS_ERR_OR_NULL(i2s->regmap)) {
 		regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG, 0);
 		regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, 0);
 		regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,

-- 
2.43.0


