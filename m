Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF69CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F4D6B009F; Mon, 25 May 2026 02:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9CE6B00A0; Mon, 25 May 2026 02:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0069A6B00A1; Mon, 25 May 2026 02:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0FC66B009F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A047840169
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:40 +0000 (UTC)
X-FDA: 84804963600.13.99FA76F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13B36100005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yucifz/s";
	spf=pass (imf05.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690519; a=rsa-sha256;
	cv=none;
	b=PgoVsDPU5CnCjRDBNjpMicbC5/uR8xDuBRR3Yvscmn7EQLOcMjnJUgx1K6szv7AhF1sgaT
	kckRvjlk7vwCN4boKpvbzfKfl0lXx/FNCxgv3v5yra4HXzoA33i1E5ogjmsTkOCcA256+x
	ReMMFTwl+Yx2vI50BEAf6iNU29fwBP0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yucifz/s";
	spf=pass (imf05.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DpUemWUGyJtUUApdw/ETRvltxpRFxe9n1wlPX0btGE=;
	b=xGrS3VBCc82wDDWd4DQqUC3hTMAMR/v81DJ/IFiLVUMv56XPcsH/mgLLQolzyrbYQDwRmG
	dyuRloE/e91i/X2XVMpm17K4E2QbtoBAWSqJI9UVG3A7nuGav7z9OcZ19daglrBCP8B8fH
	9qzJldTrag7JRnyjAsch5o+r1kjHazw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1DpUemWUGyJtUUApdw/ETRvltxpRFxe9n1wlPX0btGE=;
	b=Yucifz/sdS2vKuW192qxuRBEWgSXVsddVL+KNGf+XI6D7sznnV9iJsKaKPcj5drGUYn+YD
	JBL+Z4v3QQJ3d074krQwygVweZ8fObWIwiw8MI7MMywq3T+IFQ2Ebk0zut2bAiCsDUu7KV
	PVHuh2mBNxiXm+o0Usrwp+1/B1cI60E=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 6/7] selftests/kho: LoongArch: disable PS/2 input devices for QEMU virt
Date: Mon, 25 May 2026 14:28:09 +0800
Message-Id: <20260525062810.103367-7-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 13B36100005
X-Rspamd-Server: rspam03
X-Stat-Signature: 7sq98ggrn3riuu8u1rxa1g9pxrkwqb1w
X-HE-Tag: 1779690518-419306
X-HE-Meta: U2FsdGVkX18CrUkJzJdkcNhgQFsEtI3fdp91QM2vB6I4Cd/UJMX3UI+TWX7lJgfssM7lvGRd/mn0mTi/nJJeHAiha5jufEYjTIU+XNWIlHD8fxSFHb2vEFtBj87C4jK4fRvYPZbGc7yPYsgBPLfTizci8QBpAZVpw+vFeQuzceioXcxUSdrbfI+YBIOA1P+qwTJtb/p2qdraNBabIy8jNEkRthBs99Zy7VoEFxDJCZp00r75E+fXSMAcBDSADxLzehf+p0S8d2mDjdtooD6zTZyZcIU6Vf/9xhnOFW1LSu3QcLvMKdrbv4Tp20g99Hddznv2IOZLGF1xCF1UIY9xno748gxpFBsbl7woqF+gy+SY6ErBZd/d7qr8/xya9NZHF3Uym6sEo0QU0uPK/OrGxRhHn77KmQmAGe2hE+ijj77KKQzfDhO5PdztJcQilVehiof0QxY9kg7j8S6NqyUeUe3hleCnyrmNrbaJHzxst3tfCtPjf6HcwLMH60b8NHmJ4dZkZBkvmu1j90xxMXfcn5dvDorFljC65bHz381VJJvwh1niS1QzYVaqyFNbR3qRdoJtUc0dJ9txLV7PINfWNBL29nAoKNlaqPzTZ2ZG0E+s5OJAPdIKZB8W7xoFEI4Wpx8bANIgJlpZecBrx+EQDGNxAXNGyaJiASB1eajg1IkvNmbanEKozWGMba8LGxGTwuQ0ADDlM3zOSPOjtHnNx83IiVl4ccFR2KJ1QMxpkAbQW7jl4J7Qzi35hxp13TSpz0ityi43owSsd9DEa0OSyuJI+2SvI7wOEfB39SOt0h8ab5VCTvpSH0HwOGDch9SpjDVkpNC2jVl5DMwoaOViXPs5+j6RSZM2rqiXks57lKsI1humm15slxSX+Oc6Xgv4DtZpEZZIS25+afKruW0AV1K/m59fTv4NdC7zztwbjOVRBXJFFs14VCoArrWYKFrHsITyOJHuPv4DdrWfH7v
 qjY+uzQ9
 SM+0WidkOyZQ3IPHZERf9CgzpHS3m5HbeFLs/riHAEfVfJ138DhfHUoT0RsoPk600P5LqGXnmqYR1h2Eu1fg3GfU+i5er4WYbiAKp0vVfyMVMIDn2L1I+tMPTdcqo5eIBUyXwnEsiDwmFLQUFK7JAP2OdvwC7Pi1DXylxkkSmmDs3nJXCe7dezOKDVlBZxLTGFbYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

QEMU's LoongArch virt machine has no i8042 PS/2 controller.  When PNP
detection finds nothing, i8042_init() falls back to probing the ports
directly.  On LoongArch the I/O ports are memory-mapped, and the i8042
port addresses are not backed by any device on the virt machine, so
i8042_flush() takes a page fault and the kernel panics:

  i8042: PNP: No PS/2 controller found.
  i8042: Probing ports directly.
  CPU 0 Unable to handle kernel paging request at virtual address ffff800000008064
  ERA: i8042_flush+0x50/0x198
   RA: i8042_init+0x2a8/0x35c
  Kernel panic - not syncing: Attempted to kill init!

Disable SERIO_I8042 and its dependents (KEYBOARD_ATKBD, MOUSE_PS2) in
the QEMU_KCONFIG fragment to prevent the driver from being built.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
index b0551e0c2d77..0145cb49e5b2 100644
--- a/tools/testing/selftests/kho/loongarch.conf
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -2,6 +2,9 @@ QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464"
 QEMU_KCONFIG="
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_MOUSE_PS2 is not set
+# CONFIG_SERIO_I8042 is not set
 "
 KERNEL_IMAGE="vmlinux.efi"
 KERNEL_CMDLINE="console=ttyS0 earlycon"
-- 
2.25.1


