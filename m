Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7C0C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 20:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8816B0088; Tue, 15 Sep 2026 16:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AAE86B008C; Tue, 15 Sep 2026 16:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C01D6B0092; Tue, 15 Sep 2026 16:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3A26B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:24:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43805A0540
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:24:12 +0000 (UTC)
X-FDA: 85217123544.26.7AEB900
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C53EC4000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:24:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f77Drhjh;
	spf=pass (imf04.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789503850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tbK5dBu9nRTU3QvieHc3/0LbLcHA07gVdSlPwNAJ1Wc=;
	b=rjCfMsmKXpiwANePfdLGXhd+Gm59XbjxtAWzEwteEtd4u5WLbEAJIlx3EJQKrBsOaBjF1O
	bsvLuog81lpc3CTNSNh4RF4xpwejuQNrXF5m2FFO4AGvuywLDzJC5QUTBBMshwf4aMW+Qp
	g4a3Gszg/ptuxVC47UAkpkDbN0Bybfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789503850;
	b=z064sH9nQGRyJ0q+ASFHKHxEmoIpm/wrCQ7MJxlZoYKzcTA0Pm3/cNGc/J8NU/3aGL0dK7
	P5/vGKZl4+hN7B7O21kN70mPGKa/XvFUTjhQpPQpg21bW7W/nRiYkGHscdAiSyLhhSYOo5
	ZLGhX+TkmirOQ3QCQCP0hrxfB19ASLo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f77Drhjh;
	spf=pass (imf04.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47AE160008;
	Tue, 15 Sep 2026 20:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648E21F000FF;
	Tue, 15 Sep 2026 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789503850;
	bh=tbK5dBu9nRTU3QvieHc3/0LbLcHA07gVdSlPwNAJ1Wc=;
	h=From:To:Cc:Subject:Date;
	b=f77DrhjhRDPVvupB4apEZa6an41Br5nbzOwCCzspB3gl5aQHM9gDvvUBTtGrLO5z0
	 Ed/7m3uT6RpomTpwemThYmRwXwF4Se6z8ROwYgwaFuq4IiCzuu2BTWKthtLM0eseQu
	 nx1NIh+Lo2+OuPCrKjKNLaDOit5ZTcwAkfxjWytZI6Z4s/c1EQ0Wd3zUrinFLrAHc0
	 y8ay1nUarPTC1JI6UzySBU38fuV63tq93e2WF7CIMEGS8cVKMy7zVumaNiA+GGc8V/
	 NawrWEjZousSrqOvNih8IHBPOfUA3PMEPNGx2wEwuEEQ/IxGMR30fTfXhMLb9z/WlW
	 /w4d0sbwP24iQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Ge <hao.ge@linux.dev>,
	Abhishek Bapat <abhishekbapat@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] alloc_tag: avoid implicit padding in uapi
Date: Tue, 15 Sep 2026 22:23:47 +0200
Message-ID: <20260915202404.3568029-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: baqizk893i1w17bttcpjtwmz4839dqt4
X-Rspam-User: 
X-Rspamd-Queue-Id: C53EC4000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789503850-400217
X-HE-Meta: U2FsdGVkX1/LvylcvJCaei117yoDZLnaS/G+kESDLUqqK35+sFB5XW1vCAARW95RGVq2A1plwlO7LgUN+b/VUm8s/XQqsQ4/PxREIkOWqb+w4gL7B8l/Fv21lOjI8N8MVU9GOBuTl7V5SVKO0Ow19Zpdx7GWZDSV1iX0sEA1elSHJCRrVq3kexTsudp0c1dnyMQEdZtnc+V/ANETHoUrdBeoxWVKUUTupLTg8dE5yAc+mcb2zpT7GlH+VJq21QOZb4lsG9SIfKL7K9avmhq52jghCNyFrtKzrEqRvb8mOt+YkhqrYhEb6e51LjfdjjAng7cFqB9MU5iYWt+EnBViZck+tE6onEDoaiA7PDxtvPKkUMs0+DQXcajgk5ujvBq/afc6uLN87Gkf1qJoRG+kVbkr5r2zq8sJb+0iM/ue6RrbZfR7XocvZ/HgbhELA7h63OdupATXWomlQL5Xfv4gpS9rM19WtxyFWz9UN6QjEo9K1haGj2ClG/0Kgnk+GsMb/oxBBt2qRnWYQP7CAmPPmJB5RVMd50KRgm+35uDgksbtnKLIVFNbpMgIMPI3sZeIVREIkBhwb2pi458g3ggQL9oSOkHeHDp/jojVfDEMoMpFadL+ntUWgtrwGVY1952JYDDxQWBpz1aETB6vbfFCamfQcNTgxxsABkwzhaPK8uldZg8oo7xP+MW3zkdnsW2T37EvTbehGQRtwclNeutRZUN/m3pvklvWunG3lMB1p9T1O5Zq2eRMoQi9Q9eWAdJQbDLZOjNVtFOH50Z+utODcHc67f6B2Lkyh4qpH/zVt4ve/EXjcKLV1kvgRPaiVUWqDe6QXE73FIfsRz3Pv4PiwVDJs7ahNRRTWEgIvqpwXP3FrXCc0HJbCBRyRiuMaJH+92vkKE2LEqgTi2vF2yu0LoJIbVa1sbe5KgQAVdZyDcfVSgknZCmWSZXOsX4a/6FlQZOURthSg3jHh3+YY/t
 tYn5NSbm
 SVwth5QXpT+4reYDSz+bH5cHJxab5MGs1716eIp6E8b0q2lZ34jIrsebGqGaYGSHW7q2VVxjmPT4svlLVB/w43JVEA/b66wCBV10Oj5g1Q5tQe9TzVlGjbYDsomG7lYkMvZiHK+PK4fRXYTVVQAepiIZNJLD+VvFUE8fiVU33gXbUlzSbnAweq+1eQCi/Kt3MeyQJ3qN3hmiTArCvH48xhtdVzSzbSVDMU210Dc9Q2uy1esIVvFHlQ8BfrcLTaW9SMU0qY/SLc1YwhZi2Y7Mz92FO/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The impliied padding causes a harmless warning when testing the uapi
headers with -Wpadded that could in theory indicate incompatibilies or
data leaks:

./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]

The code here is fine, but it's better to make the padding explicit
and avoid the warning here.

Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/linux/alloc_tag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index e3ad94444864..7d4618bea043 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -38,6 +38,7 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
+	__u8 pad[7];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
-- 
2.53.0


