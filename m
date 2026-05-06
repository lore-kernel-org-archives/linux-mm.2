Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A3FCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1E16B0088; Wed,  6 May 2026 14:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182926B008A; Wed,  6 May 2026 14:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071B36B008C; Wed,  6 May 2026 14:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC54D6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:20:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0A091A0180
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:53 +0000 (UTC)
X-FDA: 84737811186.13.3F1A3ED
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 68FF640009
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Bl3YEY1z;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ue8RpWElOJWTzQpGzar1fgpzJp6JMDiEfdJn24IqziI=;
	b=OEVlPTclfVRu70k21mGOikGsTYpi1FbcXXxxpPzFfRpAAO7NTg+G42YM9rs34YwiYKgp4v
	Embz0fzJRkTzwkfhK56KqGTSCqyt8akgXR8Zg7ACX2d4JWsuG+HUnwWVHh7TqYLWS2dTak
	zCYxNkaQA3dwwTRmH7JNmzALzKss0xA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Bl3YEY1z;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091651; a=rsa-sha256;
	cv=none;
	b=j6VIlrwXj7jgkoIZkWOCgquvT73nM3QzyobcV/gYUCTu9XD9tihBSXTyBlgEk4H2x21p2h
	tDJBL3eWar0nTzXVhSAjQVyTkz8ElftZjiFMzqy4hcXltqcfbfqi8Jw9jrIPGZ9p3IFRd2
	ZBRItHim/5wdspnq2oiyAGdTaDCSXX8=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-651c7ddf514so7111668d50.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778091650; x=1778696450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ue8RpWElOJWTzQpGzar1fgpzJp6JMDiEfdJn24IqziI=;
        b=Bl3YEY1zD47AdmYEk70cNYKJAyCepAI3jgyT+PWpVloXgWSturJX1i+OhzNdtRtbIU
         nXZuT1yHYSPE7XFddqCJi9NltuRNGRqeaCCu7dJcPcLopEgsOyiJ6BTBpVeWoW9rwjKl
         yoknIEOCN6RakiXn9HPYIz6J/z0HcHGLFENQqECar9j8Qkb9WxECAXqzp4bEewS1xfLG
         Y34iRk1XESlXL5v5y82IAflpdhZvLRy9WqHW138jWicPeLk46sb6A2nL5vt1FeZOrjEj
         Eal1SWz9oqY/nm6ypyOLAe/OD0bhlM861nx9oEl4Px+whYnobI2nTRrfrDmr+QX3s2hd
         iPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091650; x=1778696450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ue8RpWElOJWTzQpGzar1fgpzJp6JMDiEfdJn24IqziI=;
        b=AC1x1qJNBV7yFbd5VgR696WH4K8aCQg0PGUwk0aPeWdYAgdc0lEjPVKK1A031a/MXf
         TeO4BHIXwyKhfqcUK8xgUXNYlvwFmBaNjkE8BIyykEMkXTlpZHcs5vwv3TvO73jmujwA
         IGX5zuOoWUmmxliFoTxZi30Ou7stzyzW2E/ePkvbsdgTDDE94PrnTTAqK04Xn9oiVElo
         E3CmuYBrl2cIhpAmA2Y+pZYANYUyiXzXpcW6IjZ2OjmZxvf/3NCXCehK4R9dbivxAEiK
         fOcdIz1nqik7XBgDlDIiN+wHp08kQgaEs5tDYsxH7zs3hBKpSetTK0Gc3vBmUjNR8s8v
         L9Ow==
X-Forwarded-Encrypted: i=1; AFNElJ/sKJNucBfVf1N2fceCLuZxmcwuTN6kXh9WtG/fc7lbsHbRXbJ4GA67tzn9805lrl8ucseDTHM2UQ==@kvack.org
X-Gm-Message-State: AOJu0YzTNKC1KGcjMfu2I1x3OD//0d1n4MBRC0bM6EErMAYYFwcdiuc3
	E/343X/N7kZQgmO3Lglu8ejXTyKYR5ZTyE3VzoDT93pxG3dU4Wus15UEq1qxQ8BFc4g=
X-Gm-Gg: AeBDieud3TCg+Xwd2muevZbSBXKR3UfRbV3iMrnJaJW7DBtUzeKnA4wdeVcPP9xsADm
	gjsvk6dFP63SVUGo2LkwTEwB+c7d/4pqMa2Td1pMGmmw7UAiz/fpVgsAQUAGtjtEGNosKHYuxIf
	PtPyo2K5pTPfB6PeZgY/MnQhgsVLmuqf+Wol7RTG+jm924jatzoY3lrGi8xcJB55Melx+gynpBk
	csoOfxXzUOBdHp97RZcAHh+XxiLOwyDc8l5tezAJGld6fZ1C3lItUMdn6y5ospAKa4sSlScS3Lq
	q0vEcePh7UMUvR3Ts3GTzN8Mtch1cyDQ00fc3m211+GhhG6ZCyjlusLLxVKyjfquzYjlXQayYAS
	GtW+/XDTm82iqXOMfG/2zRTHIAFc+/6sapUYRk7GgPxcK7snK6mkJwn9PoXi8b1g4YZT709wtut
	bmiR5icNjGKANXUDFwylsUw9x79m+698M/u45naBUMtHirg1qM1WV57z3Pmy0nR0ZGurCyDido+
	7QfRRtnpaqSkCkFPxPUHMcFzWaKjA6XdRyokXPqXlHBeZRAMo7VNQG8MvvN
X-Received: by 2002:a05:690e:4401:b0:654:6cd0:f96b with SMTP id 956f58d0204a3-65c79cf0597mr3598241d50.5.1778091650422;
        Wed, 06 May 2026 11:20:50 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c7af9f8e7sm1389917d50.13.2026.05.06.11.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:20:49 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	sourabhjain@linux.ibm.com,
	jbouron@amazon.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	bhe@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.carpenter@linaro.org,
	pasha.tatashin@soleen.com,
	rafael.j.wysocki@intel.com,
	piliu@redhat.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com,
	changyuanl@google.com,
	mario.limonciello@amd.com
Subject: [PATCH v2 0/3] liveupdate: serialization safety and race fixes
Date: Wed,  6 May 2026 14:20:40 -0400
Message-ID: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1961; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=m05vVKwcBsXuT9wz7QIzEMSInuOTC578ENDk+r34blM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBp+4Z3c0D+XpYi6VubNAAFYjxJmiLLxeKkGeG0q
 Ve+c0QfVEWJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCafuGdwAKCRC7dyhM23N6
 3gtED/9AH1OD0iu7KRB44/No6yLpmYAfKN96w4BZ7rlCykWxr4qFFaxI0L5a9VLCh2S97yz1/bb
 Zi0BODW3Bu6XNAC/jDR9TFSqYVUMpZfrR0041jj4aX9QDBCi5Q8uSbNIBZayt3jdu2pE3Lyi7um
 55Aj4d54qD5mHma+O3j2aA+L4fbPxrB+D55MT8A2e4ayRFIwZcAbITB71399LcAWizEDYBKXeAU
 yr8mbMn/as9b9R99762WJIiNXsTXQzbSfCp4Cgabb/Upe7raCjpRpYTkCNTL2YqqfY9trpXECUw
 pCPTLNe9HasqymbyBMkiYHrF2VaYa/KPY5+5gDnegxDedUD6Sbc3Gpe9ZGY7TymYcWWbVw2HmSI
 Vf8LcJt2VovMWhhXR8uAzgI0ro7GHXRVEmr2gW3q3O4DvLcUJvoDVjmVlKnDUtBPnvoo6YcEzxi
 /7OB8pcL9pBLstnWQNPc1UQFUBAG665rEbqlsh+NUCbaOHVIR0EVRR6sq6mUV0jlE9fx1Bj106v
 REmN/PC1a9Z/GGaBqNDjhkD4YcCX/6HBQrq5+MIIyH1Z7javZQvc+9tAbzUYcfCu6hCJhBd6If9
 r0JYXPk1bdRv5w9SRuhthsD0r104yMoncJv6T/riSnrrhiqYYcqjXqjZPvYH/41NS2VED6LmVYr 3I1BQSSPlrNAb4g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68FF640009
X-Stat-Signature: uezu53otsyokaftn3jgtafqf561qw1fn
X-HE-Tag: 1778091651-207591
X-HE-Meta: U2FsdGVkX1+G0xZeiSa65BM+KxaapHvwBKnGW/pYoainnN7naIDVlNbXJgtEWGk81rjIftCHSm+Nb+Uhm9BC7T6AsDMzMVH3X0hKBoAKnX5DTBulxGjLNpWoh2lQDJG5qEz1fiqHtYQxVoC87L/Z5Pc6PaxKixI+PYgImst8f1Nr9b2F9ydDidWKIa+Ilom9RKVQaOSH/NOW3sRm0E7ROIkT+ZWRzKyRtOMfMMMuEUqNVT64zgPVj0mTGRyyMHUjmYpIGyJYjbtnrlIX3FgeCshnT7w0t9CtxL22e2sS+Og2Z9xQdaPonainqrpb/CcLKYWrJvN3G99SrpZguYf3adYqFjqsrpGSvTe0sLHo1QIyx1D07cOHko8AdaLa/bNyfaH1f+MYjEpvFG8Qr18o0XYUZVx+kvqeSHTB101jT97tWWD2O+cbSYoLq2YzB2HJDLfNF/+pWf9xlgWweGAsiIALfY2GiHlDFBURbKp8RZ7b/1MftlXSfCYyIpFwtNZ+uKB5HJeKREh271ECYasAPN91nRkqcMC0q73gjUCtQn7BI/eHP8pVqpa2vYGe4znvUAbbhi6RD7yft91MfjzRJlGOK+M3KRUppB618wsgXCq4h/MZNmJMZX92o6KLo7H9gnb1+roeik5alvwtSUvETi6smyyxbtBx/VL8JZKVajzZp02BSqdhNso6qtLjyJZ1jxms1X5WT20sGxlrRmddBPPhXPOLpN+IRTtshksyLsUJE75Erikx1sUPExTN19PdBvTQWh6AFbv3AN9bhwVKNnjBCv1q1B5V4FMVE4G/IkbwxhJSiCZhpIkzg5v+fCXrM4veG/IpNnolfr0J36ndB1nijM+ZguRPRBAEWj5QK0rScF9tErFwD9smRdam7W6bhR3f7PIG/4nhzqqyS1nRhVaZuCRLYx6n20KitoVaeli6drwLYMbJNaY1VgLIY8NEHY7kRHYOxPPLDcvdtYN
 WAidK74q
 6ig0byKnKGVOptudiajpGIxhM4KVutTIih2Zoeiug8P3cLMPPdcKKf9v/Dff8bWDsfiGjPaXzwJdy0LKXag4/LtiKdeby6DdeGUJm/gkk+27O5RISCW0gcOo/Ekh6iccoSFMmPY/3ldPpu5mbsRNc45uhAtHG7Ab4uXASVi3SOuKQRzEPjQhjd4yBcYW9QZZXet5jA2Gi33q5owDuv/ftaxfsDaK3TRc0zta/gPXpSSCBY4TUB5l6P2Gen15hwAqXloK+HBR/RHGYKz7P4KygzPYi58U2PEUhVjZtqLZ72q9PgSBHuoGVrHoSCaFVsL9e+tv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series addresses several issues related to the synchronization
between the reboot process and LUO session management.

Changes in v2:
- Added a patch to skip KHO data for context-preserving kexec (suggested
  by Pratyush Yadav).
- Dropped the 'rebooting' flag and manual session pinning patches from
  v1.
- Implemented a locking approach in luo_session_serialize() to prevent
  concurrent session mutations and release (suggested by Pratyush).

1. Skip KHO data for context-preserving kexec: A preserve_context kexec
returns to the current kernel, which means the 2nd kernel does not use
KHO data. Passing KHO data via setup_data or devicetree is unnecessary.

2. Skip LUO serialization for context-preserving kexec: A
preserve_context kexec returns to the current kernel, which is unrelated
to live update where state is passed to the next kernel. Skipping
serialization avoids unnecessary work and prevents sessions from being
left in a frozen state upon return.

3. Block outgoing session mutations using locks: During the reboot()
syscall, user processes may still be running concurrently and attempting
to mutate sessions. To prevent this, we hold the session header's rwsem
and each session's mutex indefinitely on successful serialization. This
effectively pins the sessions and blocks concurrent modifications
without needing custom flags.

Tree: git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git Branch:
luo-reboot-sync/v2

Pasha Tatashin (3):
  kho: skip KHO data for context-preserving kexec
  liveupdate: skip serialization for context-preserving kexec
  liveupdate: block outgoing session mutations

 kernel/kexec_core.c                |  8 +++++---
 kernel/liveupdate/kexec_handover.c |  3 ++-
 kernel/liveupdate/luo_session.c    | 12 +++++++++---
 3 files changed, 16 insertions(+), 7 deletions(-)


base-commit: 7b0b68b2b95606e65594958686833e53423f58f2
-- 
2.54.0.545.g6539524ca2-goog


