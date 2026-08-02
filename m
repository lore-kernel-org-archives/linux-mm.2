Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93635C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 07:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121616B007B; Sun,  2 Aug 2026 03:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2A36B0088; Sun,  2 Aug 2026 03:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D716B008A; Sun,  2 Aug 2026 03:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFE656B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 03:40:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 357DF40457
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:35 +0000 (UTC)
X-FDA: 85055532030.28.728CE2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A94B510000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXe5/6cc";
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785656433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=46jnfdwMlaNGY+WPjRsEyPBfOheE1oNJe3QEnsupnCk=;
	b=JpXJi/KegreHrox6qwzB0j7FeGt5yfyMenpD5MhG8BF/fgIuYBM0yoY2SABn3pdgq2bAqn
	zGM2EJixpSnjXpiVLUQ3zf2Rk1/3hIxb6Ct7d42wM5O7o2FlURajtJeuAzcNij81pm0OvT
	glGaJHa5QCaORDOaGIMoSwQPJ+YkuOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785656433;
	b=3Z53LS+5lDhIukBKhxH+97iY0N6aQAtiSjjhjr4diYjauf71VAtnt0ipVBHdw4s1rlrEDu
	JIEjZB7tre18ThapSLpSsLwQz5XA3wMDM0mQC1i2Vf7W1POyoRHTDxGDCzmvoBo35wF4SW
	IDoPFmsraXMk5obJwt2iWT/4tNK4g/g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXe5/6cc";
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CEBE43971;
	Sun,  2 Aug 2026 07:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61EF1F00AC4;
	Sun,  2 Aug 2026 07:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785656432;
	bh=46jnfdwMlaNGY+WPjRsEyPBfOheE1oNJe3QEnsupnCk=;
	h=From:To:Cc:Subject:Date;
	b=RXe5/6ccLygZW7M8ERjzrGvEej+jrQdq6ny54rod4vAmYz2OQqbcb/EKy0q5fC/v/
	 e17Uvg16pRJrAeyKJ8NhtBIC8s2Rkkip407p/Bp5oJd1Gp1AcgRHoSbLd/HQO7Cvp7
	 SE5fTt6PDfxYsIihDlUBVIs6FP0TQpDgViMCS2hIk1ZhybI1v7cs/tDNm07jBBN201
	 0cVx6iqEqpRvgahrMOIMUF1aHhnrAjWdzUmvNT8gHOMK+8U00SFQDRGfRxzfrzTwYB
	 a9Azh5+Yp4oxVMXGM4gTwyhFB+mnWgFo/QHeep6CojMG+HPRK/EklnyD9jaZTxxn/D
	 JWgEe1I5S0b0Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	surenb@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanghongru@xiaomi.com,
	willy@infradead.org,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v1 0/2] mm: use VMA lock for kernel faults on user addresses
Date: Sun,  2 Aug 2026 15:40:16 +0800
Message-Id: <20260802074018.73887-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A94B510000B
X-Stat-Signature: 5wiaswngogignqg1s1aw3mrhjmr99wd3
X-Rspam-User: 
X-HE-Tag: 1785656433-288210
X-HE-Meta: U2FsdGVkX1/11r0M0pHNs0VmeRE8RYvl9NzoA4+CIPNdZvD+uCs8WxtJ7a/eK9D7IJsDdbPoOYRBR9vLkMCXfHoGa/7A4NzOJr0gb24nQsIvh5lgn5wvOGvtp2NO1EgApYRK6/prMMleZeUlb5Ba4b02Wg8SIUP9BRtqOp704ab/m0dVqIKnBLWKEPniJHcS2xLOLkS/+poaczkhbV4Z5oYFpiPfhxQNzrG37bsS4tMCztMCD/xmXKQj6CqkQzw98WjrNvXVhMa/5WSZPNw5Ns9c//vTJNlgMrk6aF8OjuVv001FYC1LwF4h0C6nSU7hdqToQXPwmTIKfWun4kq0v/AOKVgeN+zH4csinVjJDLArnbjZ3byAXZww+/BZkCkgeZtbx7wC0YOcgRSPMr2wYe04Mjs8jMChLbQ/pk5kVrQP3gVCLiAT/GyuC+QLgvRS3E5jg58MVXfRBLrE56impr209rlpIj6CISpVFjizifjXDAYSRySBC4gMvxZwUsZlFc17i9hGN/6HW6z8q+07zVz42FnS5h5bA3j4TMNrJA7xJlg/FU9Y44hw4Zkq+n4/trJ+q377pqrV7zRyg0HKQ3rpWe5MFTEZDEL06vQwNZKKj665yJtora1OaJrvts90cpf8ByHWAkNYgWc0otXunP1Z3xS8sOAGxMG2hlc6dNInj3DgPtWHjmUPa+aVNYDb6clqIiuNBD/Xptq8rjBV8vZMFbPQuWx1LmFkpG21uPZ4ICvPGu+VmbHo9SSgY+qKfv7C6g1A5Vuee+titfdAjvZbX8ukPug+1ee9gH6jUj+gOR513YywRV9y5Tf55695tvqi5wJPJuSaBD0ZiZNsGv3aXAzc2cNxO17zKv3213LEqUYgD+nchPT5wv83R/r7PtH5SM3EwlQ6I1bnyA6HeK/le91ldzhNVKHkTPie5ZpVGRL5K3Wy3GYdC/eOAtcTfsSG0qWQkJD4PSd0bpG
 2Z71n/6Q
 +siCpPtk+wb1zJLCLa4IrxC5HY6+tB/liRINBDRUPN+rMGQRLSqCrUlWQpVJKAtcpoLAr/W85C52XJ3K0OHUUWrKOkj4XE1nsJP8bHcEj2CNd2PuklbOQFtlLi4i18ytQ7nBYYWrnTotevQ3fGQBiVfvZlLIXAqTMDJNDTTZSSUOV37dOK5431AFKZz820Z3eIFA9l94HzpC4tG85N38kFbboBgU/HpQyGuNjQ9B8RYM57U3bBxayXh5IyE6DTp08gu5Utn7e5fef/vDekCMBYmob68bY0G1oEyTMtPlc+WXPupoHjh7WutpiqLtOE+134RMIDDKX2LlfGw/VGNzv5Zu4oKUpFEtt+UoqTFUmJtyg1dHOhli1XPDcGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now, kernel faults on user addresses, such as those from
copy_from_user() and copy_to_user(), unconditionally fall back
to the mmap_lock path.

This patchset switches them to the per-VMA lock path for three
reasons:

1. These faults are common. On a typical Ubuntu system, hundreds
   of kernel faults on user addresses occur every second in
   python3, apt-esm-hook, package-data-do, teamviewerd, bash,
   scudo, cscope, gnome-shell, systemd, and many other
   applications. Handling these faults under mmap_lock
   unnecessarily increases lock contention.

2. It removes one obstacle to simplifying filemap_fault().
   Matthew has proposed removing the page fault retry path and
   performing I/O while holding locks [1]. Based on that
   approach, Hongru has already reported regressions caused by
   performing I/O under mmap_lock for kernel faults on user
   addresses [2]. This patchset removes that obstacle.

   Another source of I/O under mmap_lock is GUP, which also
   relies on mmap_lock today and has been reported by Hongru to
   exhibit similar regressions [2]. It appears Rik van Riel may
   be addressing this separately [3].

3. The current implementation is inconsistent. Although kernel
   faults on user addresses always fall back to mmap_lock,
   arch/*/mm/fault.c still performs !user_mode checks in the
   per-VMA lock path, making that code effectively dead.

As an RFC, this patchset demonstrates the approach on x86 and
arm64 only. Other architectures will need to be updated as well.

[1] https://lore.kernel.org/linux-mm/20260625195040.2508362-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20260712132759.2030823-1-zhanghongru@xiaomi.com/
[3] https://lore.kernel.org/linux-mm/20260724222934.1463812-1-riel@surriel.com/

Barry Song (Xiaomi) (2):
  x86/mm: use VMA lock for kernel faults on user addresses
  arm64/mm: use VMA lock for kernel faults on user addresses

 arch/arm64/mm/fault.c | 4 +++-
 arch/x86/mm/fault.c   | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
2.39.3 (Apple Git-146)


