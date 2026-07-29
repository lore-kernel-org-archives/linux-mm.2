Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5F3C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA40F6B0116; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFAD6B0117; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15616B0118; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703196B0116
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D5A6120573
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:47 +0000 (UTC)
X-FDA: 85042093374.02.943D42D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E54671C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZgotZjgc;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	b=ewpRXpVMySyGxsp4w2RDQiqP0THajjJmOq5E57/2MzPiHeYRIu6yOFkKBIXVSXIhchyjb1
	dvs/OAuVu4BcnUIO52WVrhF/xpu7EWASN7PSByzPC/Bu29Knlo2shDy+ncntgPf5Rtj+66
	Jy1wu+nybcbTz4gHrLrp/3DcljYi7Sc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZgotZjgc;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336466;
	b=OUgyDQoIHdnj11Am83GMN0LPtybSRy8OfVj8zGC4fA90dri66dRFpchrNwhYkQmK9KBKzo
	QI7K28oLnupEmoOUFjf6Pb1sffgZv1Hal2O51RXgjltP3gRvOS7vQmJ9vjBxF01Pp96DuH
	kEupTm4mCy2bgaR48TsT6rvgdhmWkBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A32343CC4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38321F00ADF;
	Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336465;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgotZjgcWhh/HHekUuR450+WnuFoBpIEPEnKN/COLJ7BI9rXBJRIIn2VOMwHETiPT
	 pi1qlDGztuEvmHpHXKH7i5gSQYMBEcLFpA7OpyFiFsW/24Ae0SqkQtAgRrW1DPd+Wu
	 7kdzvMnr/4GYdvm/S0YWdkbTnK95LhZ2hpVZVRarabtDYZh8JVaGWXmQ2GvPQ+OUHi
	 Isa7HoW/9S/LKiPxJOWAfRwTBxp1nZ/OWdFO1aEGHjBSG4sAPk3HyFbZH98EZmRK8t
	 BIHt6bcuWqXwaX1kp7mASyVBut0Zmj2O5I76SE8yLSUaB51XvzA67RETFrwcPkwAuo
	 LdZOLORa0Py+Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/6] selftests/damon/sysfs.py: test damon probes
Date: Wed, 29 Jul 2026 07:47:37 -0700
Message-ID: <20260729144738.90895-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E54671C000B
X-Rspam-User: 
X-Stat-Signature: fokgz9wga6hn3etnmmtf5r1boze3848t
X-Rspamd-Server: rspam04
X-HE-Tag: 1785336465-568099
X-HE-Meta: U2FsdGVkX19Js0Byuvt/wHQn2pie/OOH/m4EyTJIjcTQ6pwB2GQ4biTotJhM51PUt4h1HXUX3NSRFeu77SAgbHUXRiafl/ba0pe2lv+LGz0vrgyNYWwY/JLbWJ2mdjM9jF39c3D+l+t1h6B+6mUJzmWeGz20EmtwF1Ssfw45H9JZWUatvgGFnBIEJJuyudNu8BbQxwCibCVdp9vPwMPIFv7I+bDCOogRL0S2uMa7DcNpzOZvEurrjeXMMZ56nrKZnYXo/UswTncfK9+npN2VKUCg1Kw74IXk05tA4pP2MIpYJs7XnHXTKXVA8vL50046uIVHvFUq2Rnczw6umaRogDLZi4VTa5xlOJHqn+lNqJ5G3JXcVcssZbS1JbCkPkxZrpjrKfkBM2BgCsbMhjNv7QrKuiHgvVvb1LDZJCP13/9eaiOOzYGIHwokmd/lDRSOJ7rbdPMfDvQ1g4ePBxVBluIREQAwv+S+kV5UDrvhydiwBcgW082+PWfZoDhuPyWE2NTFR/lucWcuGJD4dBtXbucnrzTqmzsW3dPurhYDe3O0T/HdUFCTAKnwhsR7hZS50ElVSQinx6I12TLSkTK/tsrg+IjbiUE0k6rh1BIcOgOQmB2ZFOJ4rhRAs8lw6cKn2CMLn5ddi3BkuDV0K3BNlSfQdfMPPSGjpeKSs/0qNIuf1/zNBGEWFloBbPKLupL+5HNLh6N99CjW3siebhVVyQIGgglnzqLOtmRuxmw/r0GaRkNsZEcgDz+aI1/vfxxHdFzHqfHUmr+83xJimYjXOyyDtz/tTqNEM/qAGj0eEf8YMg+En1vFvN8ipoZfKIVhQFG4lYdSCAkB4V6Gf+vbk0CBegWW5Bsa584bVJ1uNb/NdgkUUztazl+KMiSjChrpW2ta9yL9woXJS3eakOngPrcgAhHjRrSthsmkUxsvizIN8zMBdWeV1v+hhDJPzD76aMpTdXp5SoFTHD/WTQK
 fqkBDmem
 D61uVJ6j7XheaWaw1xiHCAN7TYMIUzL+gMmh2SJb5Mf1hsxr3T7BjsjSoaAlN17Us9eZgoU40wAwVnSA2PqWn77IW7X5WAT/D/EFvCFGrSu3Eiydud/P2bfvDFbTkTWr4DPO1HkxIzUVx5n0CQWzPClMhnk+HE9vskZ0seBwGbBDPF1aTJtCO0lTdRRdm7GyauoeID9HiewcfhaNIzAiNUIebm2vnEPLPqoDc7aNwzxQccp4349NdEIbb2DRF1BtYrS6l2By3iOkzzYlJmMfHJ8ZMwR4R8BFxGUHW0Cf2gMLSkuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py to commit DAMON probes via sysfs, and see if it changed
in-kernel DAMON status as expected using drgn.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 159cbeac067f8..66c826189320d 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -319,7 +319,21 @@ def main():
                 intervals_goal=_damon_sysfs.IntervalsGoal(
                     access_bp=400, aggrs=3, min_sample_us=5000,
                     max_sample_us=10000000),
-                update_us=2000000),
+                update_us=2000000,
+                probes=_damon_sysfs.DamonProbes(
+                    probes=[_damon_sysfs.DamonProbe(
+                        weight=42,
+                        filters=_damon_sysfs.DamonFilters(
+                            filters=[
+                                _damon_sysfs.DamonFilter(
+                                    type_='anon',
+                                    matching=True,
+                                    allow=True,
+                                    ),
+                                ]),
+                            ),
+                            ]),
+                    ),
             schemes=[_damon_sysfs.Damos(
                 action='pageout',
                 access_pattern=_damon_sysfs.DamosAccessPattern(
-- 
2.47.3

