Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1559CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E656B0005; Thu, 28 May 2026 05:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF0C6B008A; Thu, 28 May 2026 05:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001716B0005; Thu, 28 May 2026 05:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32D06B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9891A07EA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:12 +0000 (UTC)
X-FDA: 84816365424.14.4AD62D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E2BD20004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aco6Gx/G";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0tbtnOuHhIH4p/NZ7nvRGoECzQt7IqPJgxAKHDaqYjY=;
	b=2iWF4W7s12vS6tbhI08y1K0kkBkx6lyZnm7PCu36JLUmmQDTSjjr6RhlXKmShoXRHVpzLC
	04I7w53g7MvHvUGv1b0ndA5hHUWr1Ly/7IwY4CKFLqy0qjOKLHP4ipPCjlad82Ygn/lNCW
	MJj+Uqx8DoQxR9rLHViZWRuLGD5NuuQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aco6Gx/G";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961991; a=rsa-sha256;
	cv=none;
	b=6Bp131rbuFCC7npt6KD1kgiNUcg1Wa6Ayp0fcKCeQAQib0OP9UG4j0+dUo01/2MRdvVv/I
	N6Vjx7M9/X2I5SIs8xo1oIBLffhVHYTLBXPnkmXy2S1Y+qNMABqIiTvlq5ADwjT/5CP+s3
	KmLzkUD6JerglQXtVLcS+O1RG4ihmwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39FE0402C1;
	Thu, 28 May 2026 09:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6749D1F000E9;
	Thu, 28 May 2026 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961990;
	bh=0tbtnOuHhIH4p/NZ7nvRGoECzQt7IqPJgxAKHDaqYjY=;
	h=From:Subject:Date:To:Cc;
	b=aco6Gx/GpBhsPG/P3VohKBtFNaTzZ98Ku0yJRh/58TyUNEpm5KJrSzFMpJuoeLMjE
	 9u/R8z90S1sXcgJnnhwfrueYDDVRoD5D+En37T0ibrdvFjdJzvifmAi796YjscyOOm
	 dJvUmikOKI6OHNAoRKiR60cYfSqLXCPGlT/l44L07VL9c7nTNK3jAlBahFqkKS59uX
	 ciXYGer7SEQjiAaD2bUBv70L27T59EBgqJTbXnmE21m9BRPBvLB73Pjcm998Ua2fBM
	 bL40igHYhpg6M5THEMgU17zuC5FDEvmJi/31eG0lOsjuoZF3W1CTP6yNsuLXDPqnP2
	 WpsNYaMQSOqFA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Thu, 28 May 2026 12:52:59 +0300
Message-Id: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHsQGGoC/2XOOw7CMAwG4KugzATyohQm7oEY4sShhipFSalAq
 HenoQuI8bf92X6xjIkws/3ixRIOlKmLUzDLBXONjWfk5KfMlFCV2CjBWwJe2wA7JbXRYsumyVv
 CQI/PluNpzvkOF3R9oWUCbEYOyUbXlBKYNUXqS6eh3Hfp+XlgkGXD761BcsEdaGE2gEH5+nDFF
 LFddenMyrFBfaNqRqogq4MIThmQ5g/pb1TPSE8ooHPeB+mg8j9oHMc3Gvoupy0BAAA=
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Stat-Signature: 7ybjuz5go9s988se14uqk56pgma8mz98
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E2BD20004
X-HE-Tag: 1779961990-917034
X-HE-Meta: U2FsdGVkX1+khVHUiXBQ4EnjiEZ+GOntYFWdwNIeUbZ2rxUSFA3eXpNm14R5xtCocL2zFSUMl9YwOykJRWvepYNqdJDpPOAL8u00V1hPEDUCqPva/+npKE7gPVeOcMe1jgTZVnldX4SNZUakJEE0Srfqv+Q24tU/KcQnr8u6miL46v5OsE7WWcFKbQzeTHjjCGAfwSm49s+eGcjEjOBLBqI1P4LOlkkHR7GQDwZhBehgy1d3CJT/RAEE7W8eXfNOtf/ySwjO9YR+hIcfPHrfslf80XG1ZLLhZO2umg6fSk7BGDvdiUVVKwc7ArcXLAiXezJnbOjT7FxJmUoy4QINwU7R3wyH19sUaAyLB/yBertvxP9ddoaCzuCjVHR25r8smJ2x8L8su7Fep8+eO+nhWotkBYysMfaTXz6GDaayNnzRtc7uVvZglh4VtVvXqKUdImgR7J3SRepE3jEojgoMDRsFe+Np493akY8wGZdl5Zh8YVSeTMc0iHgc2qmTD+R26rHPtSMT+R9fFIDvoY9dCuMhwTYrSNHoKFSbKTjsbaEsIttW7KyrCVZ9y1CXRAhcgPKanubXgk4e6fxJDiJPd2RqBuS2eufkqyg3wzSoVFSW5MpSMeebrYddGq66Y8qoHrBofBcUsQ3y9XPjjQBFWWKcxZlYgPQ8DdEufCHNYfRyFnclwfumTBBVY/LOIZ3+UJFRey/qm09djABfM0Hjm8FoGD3Y2c1+6rOzeEjLq1YhJNMNJzpUFYuz5ioq3TGkj9lrCOtoKNlo4hs3gYntBuJlayqrlzBsz9EAs4gzosoAz6VLhvWMyYdWRkMsK6GsrB027Oz/PsMvdCuBVkSl+jNAMBAjIwZQVYceypnGY+Hb1TNR501dcyULUpj6cbTKomG1qTvcUWuInvkZSmadwUIuuR5TURCsj2UwPoXHvIwwLPZTTt9xQY0CGv9MukpEXz+SPFOOLhV++58Rw3E
 sGfTJirh
 9G06kCXJmBAFisT42ZaO/BtIQ8XFhyllQbIGrFqt7uvfOPi8E49verFi46sbYcN6HACHK+pUMiJVfpwcLrfqi6+VLRxzAB7duJXZB+p6knbHk+MOo/iNjZjFlYJ3rtTinkrA2cgbNqYIQwh3pbQ5H6yI3iw/zg//qrr29fXO36qIYY3pW6IAdlAgAt+/EWxa9GGSy1Jg0PI+PN+pJN9nW09D2qX17T6/KSx4KPVKY6laKdWFQqVdBzYI8jkp0IBaWvjQDWTVjh2RqkLLp2JH+t+xOIyky/zu1y3OWpZqJi+sGX6i73+Bgh7jSt8SHAODix5g4ddQBc/fKuYE/vuVP+MRMXvJ/3ltDEh3D+8tMiphFpa7uvH3x/GynqVPIBdlcaWQo/4tGU1YG8bGKe2KbHuW2ruOJwlNX7tEDV43vtQg6iDnc1yoFh0aRagwBqm+NKorNQdzjA3sYajdFWlLQ7Hx57RGrKOxFLnAAhtwBBmWnCV+EbY7WSqooCRcl0/+ai/rDx4Pc+kBOOlbh3Gkx0/1jSyaKpHUJkCmU0nAVRjXKWaxAQoXirMuQbZ8Q/376sskjrhgxHDKzRf55RGmI4x0ytbKO0Ph5v70G8B5329bTtiFZH2b2FqMkfySzShe7JIs1bJxGTzkPTX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v4 changes:
* s/kvfee/kfree

v3: https://patch.msgid.link/20260528-lib-v3-0-feccddf1cb6d@kernel.org
* restore kmalloc() per Christoph
* update changelog

v2: https://patch.msgid.link/20260526-lib-v2-0-ca3f0fc24b14@kernel.org
* replace kmalloc() with kvmalloc()

v1: https://patch.msgid.link/20260520-lib-v1-0-cb3045bef2d8@kernel.org

---
Mike Rapoport (Microsoft) (2):
      xor: use kmalloc() in calibrate_xor_blocks()
      raid6: use kmalloc() in raid6_select_algo()

 lib/raid/xor/xor-core.c | 5 +++--
 lib/raid6/algos.c       | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-lib-8afb92134307

Best regards,
--  
Sincerely yours,
Mike.


