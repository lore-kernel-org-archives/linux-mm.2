Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECA3606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=eunwfoT8
Received: by kanga.kvack.org (Postfix)
	id F3B066B05BF; Tue,  3 Nov 2026 04:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAE06B05C0; Tue,  3 Nov 2026 04:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2E56B05C1; Tue,  3 Nov 2026 04:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9D366B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ACA3A036B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:13 +0000 (UTC)
X-FDA: 85393339626.08.484F15E
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5480340008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=eunwfoT8;
	spf=pass (imf27.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.108 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699471;
	b=XM/ox4HqGNkDXttcKWtgYGzoUvOLWZFacmJGwRIx9XXZPHFWyJfKRFuS+IZVJWhVsdyad2
	eO66h5lqkUO1Pl89Td9b+cP41C85ZEGQ801twMpeWT+cI6aDjXosvB2JaVSufTkttItKUL
	SX9ZrZBfX3vY6NfCB+VJsT82SpL1FyQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=eunwfoT8;
	spf=pass (imf27.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.108 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxMHbHcW0bcCswFq9k6faxMAZ4OoY4XSKBUYGTUqi5I=;
	b=swLGfY6601DC9f99mSURzXtHqa02oHoesWHKHH4RfliGyF11K9JvOSnmbVzDQGnHuFtMH2
	+swY+ww/8x4LXPPluaHkuYikmIGvCYALUZ11Y+h2xjnLWlSvhlP9QyPEABDLnGdpBShD9C
	2HHhOW2eiGe65P9laMK6rjsPUOyzUIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699469; x=1793958669;
	bh=HxMHbHcW0bcCswFq9k6faxMAZ4OoY4XSKBUYGTUqi5I=;
	h=From:Date:Subject:Message-Id:References:In-Reply-To:To:Cc:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=eunwfoT8ZlTWcs007nWnsW8Oeh/g4tEbRRD2T4dNh8mWyi2aQO6YA/vgKlXVU1PM6
	 +hqOAII1KuJ1jCtohrrD5RKvuS1B0dosYXEog8p7EVT2CMIk1ur29lR3NytoUpNthy
	 J0Or103AMhcWftJw8rQscbghBnKYCL9pDaq2DkZeQ6ILXE/sVgQXlTNpyp7+LdWLoN
	 Uu/hpJm84SuMSzopzxghFnTBsGdfpCH4Y5yLSDpRqF+WD5sID6UBWShwHOVG4gtYEY
	 lsbfQd32UcyGlLp4R4bazHIfZsarLOrfV0sDpgc00b5PqysggJn22/hUl5enuDMQGX
	 BLGs99EQeBY6w==
X-Pm-Submission-Id: 4jJkNW1X87z2Scj6
From: Nikolaos Karaolidis <nick@karaolidis.com>
Date: Tue, 03 Nov 2026 09:50:12 +0000
Subject: [PATCH RFC 6/6] Documentation/admin-guide/mm: document virtio-mem
 memmap_on_memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-virtio-mem-memmap-v1-6-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
In-Reply-To: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
 Hui Zhu <teawater@gmail.com>, 
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>, 
 virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Nikolaos Karaolidis <nick@karaolidis.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2275; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=9Fmh5NuyL8RhhgKP+TzDpDGr/90k+nu1z+yyKGLv62E=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprniVRbgFszd+tPH1XcKsBEFpdpjWocrOP
 chMaIO9Ut5PsYkCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a54AAoJENpoyJi/
 TPWIJRkP/1HyOCbdgqUgCgsDOEG0drBO5bgCHQOZFrl1Iu57GRvZWBy88fgRkacVoxcrRFGASrU
 xqIlqUVcmDamlsgH0IJTTHFqf3uBOBNe8l2Qu6KOW+r+c4GkquCdV/q+NJNYmQXCdeBCHtjFGM7
 z8RBCHWdGFsQlIBTE/qP5NBdT5mImNKrEPg94g9w+aHAY8szKVpCvEh7GXnB29bTK+cVS9liF2o
 xaWiT/m/tVdN7bJFNCIHTyY2yWr3iR++p/QcD/skVPXBkvx0ZaicZnu2YuaC43kgVl6ZpSTTVck
 42vENRHxgj4lDpz6sfRunj1XLXIZfYZ+PC6cE0mMCaBodfydU8qLnFFvc59+qUr66hGbH+YZLYm
 //de+riD0roZ2p46aJUvbqMcq9rToblaAKPQFFNm0aPsmtutuOxJ2DLf3xYuYZswySJR7X4KF8u
 DffHhhhBr4Gn4lTmkvkD3gvvvRwoO31Sx/F0rnaVczRU/vLXTex0UKe8tTN+WD2EHcqGfaO4HYg
 LQnEsc8y6A3fy41641Wka9eV0PxKH4C82huYoxI4C9AcA2MuOX18Fyh0ZsaidMLGv2tLMz9pqLf
 en7FdPfXT1WQ1q6LJbtcpV0XocD4kyM2d7K6qAysfLrVfXVNl5tgYfVeB1gUybibhA+sfcW3gwg
 VIVwiCo656C7OBys4+zksFg==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5480340008
X-Stat-Signature: 3pgswof5s4fww3464kobfd8wi597kg4t
X-Rspam-User: 
X-HE-Tag: 1793699471-644020
X-HE-Meta: U2FsdGVkX191/v3bkRzooA/pnzBXijuCNZrzYnA1L6A0eb4AKQ8S9QSlApZp9EcLrvMU3P5WTmHZqtuRAqQY38td/vlvbeFgtjdIZqlXgkUEgZPiUInoRyuLZ3kALTbishqpaa3H4hyxluBpkqKXQUSiO4CLpfde5Bkippon8z8TS6VXIU9TVkoulPHTCIVgRVNq/gzcn2yrzx+6JRwBl1jCM558h2mP6in8x5HukQFQXqeslQ+xJETTIz2UAPRY3ym0nRNcbxTyAG+s+Kokvoc3yeV4x0hHK9zx5OPEMppfLPGlHUBl4xGYyhdaA8E4jUf4kYWe4/6VIu/k6hvc9mq0zpOA6w73g1wlxlA0wa0gkZhSNCKlHIOWbuHzuXj0PAXo5/6EUK3xfoCAVgvwrMwkz0u/XeDUqOUniQQMatb4iOO/BDLbQmk9N+oujsBurvg2TNwXPaYT+Hwpvk1nZOPJsM9PxGEMrkMRDeoQLrAe4UKpRI/6eFe1FOOChdgZ7EfS+M53FaS1w2etgm40y9stwfQ6uOSeOnTl4GdYztaS6EXZR4uA1d5aMn+Gz9ktFwpkuNtlIGAVYBe5QjNaigqK2S2H6v29/dVVE2HbTxs/2900uowvlxd9GQ2CeTRY5f+nnW0WDS3S7Rt7SthioBsTfGuR0y/MKBf9GSLImd/pCkV9sjRR2YNkzBoKhvDx2OUREz2mzDFEbn729+U4bKcBbX/RSaa78oojcxNL9qUOqHciHW96ZY8Q/tbgJ7Ll4rvCZ5oMUOP/nmK+exW+GB0g/2+Pupg+TdJt4A9XVpiOgml7wHvlg+6E7kt0QpnBZQKJlvIDp6JrHYsIownWQaw1dQso8mLC//ywFm1Q+mTKUHt+ixXkGKEfhmjdFyF1XFGGPlJXf73KwtwGxoKYKkvn5ZeHxHnR+WFWIPHosueDRFV5AZ9PLiXGUkN/Rxx8gCMxUncpukp89/ETSKu
 LCdh+ivz
 qC4ht4tCBHFlURyvu5IvPXYW4P2E78YrHCBVzP7vuppft0rBQWsKWdrXsGsrcOYSGwvzxiSpCjlINMlYxekBLh2ytk4C8pYkcsk5bJl2/9YBNQMeAoLyxnwWwvcr6noXz5YTmE9greVwpfI/JnofnetGycpLeT3pcqHEm0PHJHx3QtCNtPAHb+fCGjnUiStNvlcC7SbuiC/XpfbXCXjY9m01NVkkUICUkwtDyCK++JffgRUMdn01BPoAqxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document that virtio-mem only uses memory_hotplug.memmap_on_memory with
virtio_mem.memmap_on_memory=1.

Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
 Documentation/admin-guide/mm/memory-hotplug.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 0207f8725142..b0f895766fb5 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -454,6 +454,10 @@ The following module parameters are currently defined:
 				 architecture does not support the forced mode
 				 in all configurations.
 
+				 virtio-mem additionally requires
+				 ``virtio_mem.memmap_on_memory=1``. See
+				 `ZONE_MOVABLE Sizing Considerations`_.
+
 ``online_policy``		 read-write: Set the basic policy used for
 				 automatic zone selection when onlining memory
 				 blocks without specifying a target zone.
@@ -628,6 +632,20 @@ ZONE_MOVABLE, especially when fine-tuning zone ratios:
 - In certain DAX configurations the memory map for the device memory will be
   allocated from the kernel zones.
 
+- The memory map of hotplugged memory is allocated from the kernel zones,
+  unless ``memory_hotplug.memmap_on_memory`` is used (for virtio-mem, together
+  with ``virtio_mem.memmap_on_memory=1``).
+
+  With virtio-mem in Sub Block Mode, the subblocks containing the memory map of
+  a memory block stay plugged until the memory block is removed. They count
+  towards the plugged size of the device but are not available to Linux:
+  plugging 128 MiB into an empty 128 MiB memory block makes 126 MiB available.
+  The plugged size can stay below the requested size by up to these subblocks
+  of one memory block. Sub Block Mode only uses the self-hosted memory map if
+  it spans complete subblocks, for example with 128 MiB memory blocks and a
+  2 MiB device block size; otherwise, virtio-mem continues without it.
+  ``virtio_mem.force_bbm=1`` can be used instead.
+
 - KASAN can have a significant memory overhead, for example, consuming 1/8th of
   the total system memory size as (unmovable) tracking metadata.
 

-- 
2.55.0


