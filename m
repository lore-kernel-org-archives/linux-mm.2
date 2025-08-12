Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB5BCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1478E0121; Tue, 12 Aug 2025 09:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492E28E00E5; Tue, 12 Aug 2025 09:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381B48E0121; Tue, 12 Aug 2025 09:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 264818E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:09:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7D56C0335
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:09:57 +0000 (UTC)
X-FDA: 83768138034.19.FD05288
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id DEE6B40002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:09:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FI4H7F/C";
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/cuxRnTF/+sbokXrks651YRr5s4tLHJAN7bhV7Yv7fM=;
	b=rIhO9lR4u9CPHFqutMKPHO6rCGH1GfdckpF0DAN0GgH8hXjWHB8XJk3P//YSdB9m4abil5
	V7r2sa0gZIxg3wjLFFatPw33MkwnBqaVCs4XkVyHmw3uBV2/tFYZk0SWVr1w1/J2j2JYnn
	ypeUWuVQKx/0nYOt4vaqrJkEiw9jGdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004196; a=rsa-sha256;
	cv=none;
	b=MqpCeaN97TYfdp0PxkBH6gI0dUu4ayvleJp0soCwHGJs3MaijoasDsqZqxdNJs4JjZtQnE
	15Ca2YINumANSIrtjWWlDVj6Cabm6eJFPplgBoWMFEl4DoRhgO+3X/7HykTVNoBNE7FzrH
	3YL0C6n+CTFvTt0YPVYpBg+Z1kTcDRU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FI4H7F/C";
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755004195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/cuxRnTF/+sbokXrks651YRr5s4tLHJAN7bhV7Yv7fM=;
	b=FI4H7F/CAR29cyBJxMXRA3e9PZKQhk8cnaAppHl3K3h4SBk/XcveNqZEDyiquxjamRYhfj
	KjRh6ORF2idEVKd1clvTRchVg0p38lUyMAEsO4Fo70sZ56y5zIhy+jKGgP2aftQNLY5yKU
	rqMAtttX0q4YNbyzuQJ+edFAXOnJKhw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-SArAZdPZOtigwjx2dT9jhA-1; Tue,
 12 Aug 2025 09:09:49 -0400
X-MC-Unique: SArAZdPZOtigwjx2dT9jhA-1
X-Mimecast-MFC-AGG-ID: SArAZdPZOtigwjx2dT9jhA_1755004186
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87D20180036F;
	Tue, 12 Aug 2025 13:09:45 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BEA8195608F;
	Tue, 12 Aug 2025 13:09:36 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: snovitoll@gmail.com,
	ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com,
	kasan-dev@googlegroups.com,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	agordeev@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/4] mm/kasan: remove kasan_arch_is_ready()
Date: Tue, 12 Aug 2025 21:09:29 +0800
Message-ID: <20250812130933.71593-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: DEE6B40002
X-Stat-Signature: zhfirh6w4tn6reo5w19ihr7rxa9ycepr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1755004195-450953
X-HE-Meta: U2FsdGVkX19TStKJE81WOc6ftxdfnfjVjqEobK3J3h1ZMLB3ODYxAFTzIqZH0aHy76fedvvmT/A4Oc19/FPy3o34DG1poTqzXqJmD8CwMQ8d4X7dUKfmidDy+iKc1f3jyosbdUwI/IT05v9dqmRgpzwoFw7WKyfVRjk6Z7oQ1HLbxCbwhd5Dq3lX9S0+3/TUNsbDoNV54V2Eaite+NtaRiYelkcfs6nWUfFlSKxuMT000Dp/LKTxJTPR7E/1x57OVd8Tdp2vmt8SIpEZNe6Bj3OfPSnWfwGE2yDfnQB/AH+VzoQxd86eP20E9Gj4xSegQKML/g++bOC74uekLOoPsJFEl7nSYH423Usw1clIiFJ0Iyhu7XRDYr+x5LbAxGsGxk0UyLsAhBbZCRIcRxyr4W9kVeNiIsd1BuSJO3g1rm5yUotS4AbsuyQU52iBRLLLIE5TC/4uURdhrikWax6uGn234BWsm4ahL+H1H7/Tx4AjoY51n0GviSnJk/KxY8UKtmmTriwk13LIx4Vtdl4Tt9zoEgTeIoHg6GIloIhIWi554dZVJhh7GIN+YLPUk6DFF0j4Vqog1Wi5KFsGnrNMEwBr4/Uyy9l6cPavNzJ6on3yEgr+8IQ9QBdjaYmp8laPBRXQrqq4OFPXOqDamU7Io77kjLZDE8YV8wJnTbGS0v6j/YdqhCElR9xWPs24x9qqrJQlwhpZBiS1HTT3NDr+oXNLMncA4iFJUb0VQRjQFSM/c2yDyFv19A8aLjk9kO3IGoofo3vbxDA+hJZacQImFdPgco27KLIKxJxJt4veq2JOaQORfCzyKIvbqSfSaAUzCMS2yJOjmRzVDge2r8ZPsNxIUGBRAVRerR/vFtz+8ZxAjiIRDnpikxAFoO+M9GfuCqHGV3sUadI6PM6IZfieTRmv+WkQHfBIVXwba3Nu/3CQQlmpSFc16kzQKtGks4tyE2gaPs9c9Jmej+jowCq
 iGDwAXCC
 dGIdFH2uB0BAbm3ZhHyrzFNa2jpd9hV3shEUZWtMkRFR1Ud3JTDnXKiuQbEJugfOli2C+5lBC/6m92QpzWMOxyqPGQ3Nr7tZbhEmMU4takOwzvI+C1ywauPH9rsAQij76eKlHhbmw8Ex/jZ45uAhhyYIuYFRUdPA+cImTcz3DE0avAVwjbdnqwunGG+6n0kObtl2p8nhsXcrUPG0N05SyPm86mDseLOhn28BXIQXX8E/mrD4SWd9kmmOD0CZtjVnm/J/pUVjP+Ld1WCBskXY3nX/OopMMtffPseB31OheoWewHmbzSjG9hzZF2ZvU4+KqpBN6cf+6yZyXxAY7y6kv+dImAc83Oeq+px3OlVpvmZJZ3ky25gZ8Mb/dptbKUoyZPzmbBfZyYoYj0jO5leH3rWiYx+G6DGEuAYHY1mThxH1a8y1eQQM9FTK9n0htSAYj8NSN9oYbqo+KIud0ZW2NP4NT65sn5mhM7ghjkNISjPvX3UlttwGSVGNF5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are made on top of below patchset in which all functional functions
will be skipped if kasan is disabled by checking kasan_enabled(). With
the changes, kasan_arch_is_ready() can be easily cleaned up to simplify
code.

[PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
https://lore.kernel.org/all/20250812124941.69508-1-bhe@redhat.com/T/#u

The 1st three patches are from Sabyrzhan Tasbolatov's patchset. After
clean up the kasan_arch_is_ready() definition in loongarch, power and UM, 
we can simply remove kasan_arch_is_ready() checking in mm/kasan since
all the checking has been covered by kasan_enabled().

[PATCH v6 0/2] kasan: unify kasan_enabled() and remove arch-specific implementations
https://lore.kernel.org/all/20250810125746.1105476-1-snovitoll@gmail.com/T/#u

Test:
======
I have tested the effect of this patchset on loongarch, power and UM.
Will try to find machine to do testing.

Baoquan He (1):
  mm/kasan: remove kasan_arch_is_ready()

Sabyrzhan Tasbolatov (3):
  arch/loongarch: remove kasan_arch_is_ready()
  arch/powerpc: remove kasan_arch_is_ready()
  arch/um: remove kasan_arch_is_ready()

 arch/loongarch/include/asm/kasan.h     |  7 -------
 arch/loongarch/mm/kasan_init.c         | 10 +++-------
 arch/powerpc/include/asm/kasan.h       | 13 -------------
 arch/powerpc/mm/kasan/init_book3s_64.c |  4 ----
 arch/um/include/asm/kasan.h            |  5 ++---
 arch/um/kernel/mem.c                   |  6 +++++-
 mm/kasan/common.c                      |  9 +++------
 mm/kasan/generic.c                     |  9 ---------
 mm/kasan/kasan.h                       |  6 ------
 mm/kasan/shadow.c                      | 18 ------------------
 10 files changed, 13 insertions(+), 74 deletions(-)

-- 
2.41.0


