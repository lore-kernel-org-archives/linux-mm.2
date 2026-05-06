Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C78CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30396B0005; Wed,  6 May 2026 08:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE04B6B008C; Wed,  6 May 2026 08:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7DA6B0093; Wed,  6 May 2026 08:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C55606B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:58:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6132C1C0124
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:58:46 +0000 (UTC)
X-FDA: 84736999452.03.1A8C197
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C5F2100019
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:58:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OvaRCQgY;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f/NoTfhD2VkFXRGNeCaBOGvpRgVDghkOR86RNNVoqOA=;
	b=z6nLiX0T9qG94dcthDXobOpsbx0J/9H1SU4B7Yo9MJ+C70CJE50TE//C8Z2eREix4j0Tku
	dSNdi/2R+uLd2yBJv50894msyCprvdwcLk3QsdF0SKAvVAbYGywl8/aP5x4PILdmGGANDl
	OS4yNXvHkKD321gBzELHFq8YabjweiM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OvaRCQgY;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778072324; a=rsa-sha256;
	cv=none;
	b=A7w7hBM826zv5CR3RXesjnAGUEAPcOyhTbvDfEY/YzgdNN3WT3YaLJJ1HmG+TY7YPGTmNG
	bFvyyliqiQNZkvjsmJGP7Js15Ggz3G29me6xFtg3b12qkIVIAzeEDVIuYW7DHvOilPLWRR
	I4kqX/y1Zl0mRqXoiB9BNJJTr/6HdS8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=f/NoTfhD2VkFXRGNeCaBOGvpRgVDghkOR86RNNVoqOA=; b=OvaRCQgYZdQUXHB77xJV8VAyy6
	rnK2gA04PqR8vUt464ypD7eVVA28VxTeZJS0ZRJb6ypW/Lewfoz8jjcLrozcn1wcLKDNDj65gGHWz
	OfakcvXlE2OygfiDR6Kn5Lr349rV6U+0iNNnt7i/xEnFkEmzgYw7gF8SDWkcPv1R2RPJTCPbaTEfJ
	D/NR2OJrp0tiGOjMgr4k/g+ifzoSkI88kgcPaw319x4QmoXnzUm3bmLqw0q2730qxc/mf6yNUhJDl
	KJOz9BpPF/Af0lxvrofYTNSk0UXwGSPdT1LxWh86zDTXIE8lX/jdMuKUBEFwA8XQXhSuqwHjiGWR3
	9vehShZg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wKbpl-003bWv-0r;
	Wed, 06 May 2026 12:58:38 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/2] mm/kmemleak: dedupe verbose scan output
Date: Wed, 06 May 2026 05:58:23 -0700
Message-Id: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAPA6+2kC/2XN2Q6CMBCF4Vdp5pqaUqAKV76HMabLABVZ0gLRE
 N7dFGPicjnJ+b9ZwKOz6KEgCzicrbd9BwVJIgK6ll2F1BooCHDGBUs5o02L7Q1lczFopoEqxCw
 tSyky3ENEYHBY2vsGns6v20/qinoMSljU1o+9e2wf5zjs3nj8i88xZVRkmMRaaFMyfTSorOx2v
 asg6DP/7NO/nlNGDwqlSHPFZc6/+nVdnw7cRUn/AAAA
X-Change-ID: 20260420-kmemleak_dedup-bee54ffa65e7
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3351; i=leitao@debian.org;
 h=from:subject:message-id; bh=3Ctk1ueBYM7eZhy37SI20jpItOb6u/qilgxPdOBa4Q0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp+zr4eoaPHEJLh2XpEKHZWn0rDN2L2vJTfk/5V
 Xjns1o99YuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCafs6+AAKCRA1o5Of/Hh3
 bb72EACm6vbCSrmwesUK2Eeje66wKXaGTquJVs3/PFpqiRJnRZkP7X1/LX7G/+EVfl9U3XHbd87
 uG74LeMadn1j7O6qx1YXhNa2F75wL/grYB0g4ADzymlDZO3a4bKApJAE7Azff9gYqJG6BLx1aTe
 4xLk6dwY+Vaj25S9OPF6q9ivvPTMuzrhVBwviLtKdv+W99eWu8qs6hFIYwZKBHUAvD2Mtvm3Ezv
 8ktDq88qxtQBJrcjDCdCkBu3/OudQlHSqJEleROHx6KskOK5dt4bzgp9NYg6fQlzyJFgmcdAi3z
 syrYaciQTajHWHPfQXNfGuyjWErVvhds4TV+ibnh4DHfkaXaTWRFwv5V9KPUGKzGKyeB7bpdAMN
 NsSfjGJTvgpw9rmE72Dnrc7TULhBAcS0bz2FaHPNTAL/9psgThstzH8INjwA7xk7rjxTKzfrJVh
 FSxI/lb4AmixfIOZqMeu5oNFmdpPWizuL8vdKE3tewI/r67lMCBqGvs4w6nwK5vTkziiz55GxQ+
 R1zzgnJG62JGikD+4Db/RSKOKoshVLO/ADLhF2DwqmT6wukW9FLOhYzeMmqjhxUt/hwqiTPb4q+
 Eyd8HbPaF8yD1SD9rKdnqf1xusjdkeKq5FNSwNEcz1LU5lONCwMXm0bFX66SW+c7xbb/cL/PsSu
 RjblrHyeJ2pIukQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C5F2100019
X-Stat-Signature: 64g4punb6aqxondib8f4u8wdj5u7391p
X-HE-Tag: 1778072324-249258
X-HE-Meta: U2FsdGVkX1/qYcRORiFiJedPnrkiXD3HZr6A/RfrdJHfu6qVISO5xu2d9efaWufbaq0eurfu2t5tyH0vhvHtkxva8blh/+fH+JOnZcPQ1Y8GSa9W6XZs5EzNxVpFKhemI/XyDvrpkN3iax6dzIIAVCtBQDInHKaOzdxg5zvzbWepLrqXSTAcmABMV4oQHFDOEj6A+9qngUaguArpjgqJA/JBTrezkZf6f4Gyjef5M00fmfrjyanU5qbzZspy11/tcp9Yqkkt1KaErPOdpfAgigZ4S4Oiu/a3oDxGhKQl4AiWLpiLIJZh5wmsbAvaBeqAlIEfjlRdhNHFLqG+LsBAA3/iww1gtI9d2e/QbOtOPjLckj/LnwSnst8Xlh6hquy7ODjrDmODz4Z9XYht/IaFISfQBeb0R+NqcLsRAJq4D4oVX0dZAyhnGt9Y89TAIcVNlhxBTSW6UXHdFe7UkHGPs9FkApaKDiJEndPgBSJRnWwtMWKuBEAvw4PavTuDH9ppXsw4X92tfnzP7FEjTl35ZVkTHv/5ObI4p4CYzg/T1jM1067Nbma2EyfafqvkAO3fUGfmLONhYPhDKFC7gHYCcxSAhWSYY+4j0p5C9Ns2Am+55N9gmi8Ug2334MPK/zgilYS8l8t6U7dIS1NC6cM0dhd04NwO/HG43i6wwo12cOIvLvxooG5XOJ/R4IV+pnXIl3UWV7vtXszKXb4RmnpkUMDhucyW6SxyIfgpMs9c9jIhWpW8UVQb7H6m/KB7pk6UKgTBRS5PLNl4QAGGlrdMgvJuCWEv2kK+oEXZY0MqWtUf/hZOIbiD+VxCN+xJZ/VxKbhXLbi4ol1NMM+LqH99H0/1FHn8+xtdkwTRcGEtjmR/BNBla9G8j3WJkJAfl0Zfqx4J9EOQdkPbA9vMqktLSQmzRaSElybstSqEm1SZSd1dBvYRN6skoNPC/Qa5VfPW9cvxfItnsCpIfUndtZ8
 BpAy+Uxg
 hBcgIjMdiRB/8/JthcZ5kyQsGhlsEgPixLeNFO2ZwHEuX1OlG6NFDFb1/Zeg6ixl5GNyXpIRTxOh1WkXz8wVL1k/hsk2J8e1aU9LyRWvVsiT4tJlcv/SFGXzZnbdIq21YSRSopG+XzD1elrCgG/L7+CnAzNK5G/XT211IAxbbFNuRNntY1NUtBb0qxzbO7zo+8P9qqfYFuB/zyK565biqNbGZk4hGAy7jIxSlL+CRoBnOEhgo1elHhUaQ6ptz/dyGgk2QZxRB0lQPgESGRksRxnC3jM8Ky2PfFbWjCmucsguZu57KhI99FbPpmfdArMH0tHtDbBFYgpm+Wx7CmPoLPGOi88wsQ7RHQ2OlbcKv4n/oVlB8+jsCkM4HCaL6HSZzWSMAi1XSCQvt8dpSd9IyO8oO4PMFYiJ6UjQ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In this version, I am not touching the kernel code, but, just fixing
the selftest, as sashiko reported some issues, and I am addressing them
in here.

https://sashiko.dev/#/patchset/20260424-kmemleak_dedup-v2-0-8bea649b2a92%40debian.org

NOTE: Additional testing has revealed that lockdep detects a potential lock
inversion issue on kmemleak and legacy console.

The problem occurs because the function holds &object->lock (a raw spinlock)
while invoking printk to report the leak. This printk requires the legacy
console_owner lock, which remains in active use despite the ongoing transition
to the nbcon framework.

Concurrently, console drivers such as hvc (hypervisor virtual console) acquire
the console_owner lock and may subsequently free memory. This kfree() operation
calls into kmemleak's __delete_object(), which in turn acquires object->lock.

Although these code paths hold locks from different object instances, lockdep
operates on lock classes rather than individual instances. Since all
kmemleak_object->lock instances belong to the same lock class, lockdep
identifies this as a circular dependency, even though the actual deadlock
scenario cannot occur in practice (?!).

This problem was not introduced by this patchset/selftest, but, it is exposing
it. I plan to solve it once this patchset is done.

Breno Leitao (2):
  mm/kmemleak: dedupe verbose scan output by allocation backtrace
  selftests/mm: add kmemleak verbose dedup test

mm/kmemleak.c                                 | 102 +++++++++++++++++-
 .../selftests/mm/test_kmemleak_dedup.sh       |  78 ++++++++++++++
 2 files changed, 175 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/mm/test_kmemleak_dedup.sh
-- 
2.52.0

Signed-off-by: Breno Leitao <leitao@debian.org>

---
Changes in v3:
 - No changes to the first patch (Kernel changes). All changes below are
   for the selftest.
 - Pre-cleanup before modprobe — rmmod "$MODULE" 2>/dev/null added before
   modprobe so a stale load doesn't cause modprobe to be a no-op.
 - dmesg -C between the two scans — isolates printed count to the second
   (reporting) scan only.
- Link to v2: https://patch.msgid.link/20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org

Changes in v2:
- Drop struct kmemleak_dedup_entry and its kmalloc. (Catalin)
- Handle trace_handle == 0 instead of dropping it.
- Skip hex dump for coalesced entries (dup_count > 1) — bytes would differ
  across objects sharing a trace anyway, and it removes the only
  object->pointer read left in the deferred path.
- Counter narrowed from unsigned long count to unsigned int dup_count.
- Link to v1: https://patch.msgid.link/20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org

---
Breno Leitao (2):
      mm/kmemleak: dedupe verbose scan output by allocation backtrace
      selftests/mm: add kmemleak verbose dedup test

 mm/kmemleak.c                                     | 148 ++++++++++++++-
 tools/testing/selftests/mm/Makefile               |   1 +
 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh | 222 ++++++++++++++++++++++
 3 files changed, 363 insertions(+), 8 deletions(-)
---
base-commit: 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0
change-id: 20260420-kmemleak_dedup-bee54ffa65e7

Best regards,
--  
Breno Leitao <leitao@debian.org>


