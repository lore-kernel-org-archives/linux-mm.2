Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDE5C43327
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 13:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB0E6B0005; Sun, 28 Jun 2026 09:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BE16B0088; Sun, 28 Jun 2026 09:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B1C6B008A; Sun, 28 Jun 2026 09:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963A96B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:58:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05E3E8D8CD
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:58:43 +0000 (UTC)
X-FDA: 84929476926.22.F9B8FA7
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55CAD100009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:58:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcEHFFS5;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782655121;
	b=bmkeHycFj+A+QIjTeuLK8oADmcuM4xV7Q2I2fF8agnDqtHVfcyoT3WDxxNl8RlSl8bkX5Q
	dQYtZigQJ9u23Tp0MdygrDQEYYf7mznXTDroJiecls4aRGh852+JVttBJ1tVVsjj78qFFS
	BqVn+ektqhWTOTfJ3s3zjgMR5+B69tY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782655121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ij65SijD3TAjZdNPDp/lCaocyGnY8KRthDqQSOYaHw0=;
	b=3B4/jLaWgT1zlP7o0K6eiGiai9wsru3vF6D5pLvZZvlGlYKg8/qVQEiJKGEMDe6zH0X9MS
	3tI3efn1IKp7CTJKeuwb6g/criVpx9M8emW1effR7MUBpXQ8Zf0vY5KBJvxGSG8qi4vAVH
	v5uHZBB7XxwSzFedywjm0x+WEnBZcNw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcEHFFS5;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-845b733e82cso1502332b3a.2
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782655120; x=1783259920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ij65SijD3TAjZdNPDp/lCaocyGnY8KRthDqQSOYaHw0=;
        b=fcEHFFS5pb49WUUv0xWPg6Sqdjorr6Ii89J3CgwZQaxtfqc5P0A117QXaK093ngAj+
         OTztUfIv3wwRbb6LoTRo4SkTTwsBiUHmzL2ES4yu77y4yvEVIZAh+tQaQAseUBhNd0XD
         QeMmw90bXPJnO/05+0PVzNnIts0LX88XF1cLB7fbMPmf/WwpBJYjDayXNrpAhB4ZIXZX
         gdlSbqDJiN97qhXonk5Yqgqq6v4DFNfDvRZbtjkDXMdh2J11xaBpaFXn6gnq+CzebVGR
         EigTqf6xTi80vCtBt7/II0ll74PFL0AjwBz+EG156Dl+9bLAlLrZSe9jFgUQlgHGHU2a
         HUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782655120; x=1783259920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ij65SijD3TAjZdNPDp/lCaocyGnY8KRthDqQSOYaHw0=;
        b=f6R+5Suac2v31qhaaUenbwOjglBWfdI+LZSnp6fUJshE3hzuWYGL5SzOml7EzcWWsD
         0Q3eKrEDk7g/Zcu9J3FhVdcn97xo5p/b94LZIDc9sCvdsrE2wOSeO1Lq1V+upCSOdeQs
         iTwzSq4YmYosknFKX/7sVZP+F0VVvFIl1N6JlusHAE3OCF2c7GMKw+9vc8B0hDt5qWX3
         0Liis9uWawtd99hJrsO71HrqJqGY28fVAJeL94ZaWVaYLVYpKC4170qkOYjb4tzchec/
         auNi/jtxgvzIoh0nIIy3ANaL8ayHs2BwivisuH2sxQgQjW6XbdCzUkjLlaKCjiKUNjVp
         BhQw==
X-Forwarded-Encrypted: i=1; AFNElJ8PpGoI4w7EOZXUylQKj3iX6K58CkoRMXGQzutKe0tBJF0EejdKuMlEHGRZzlPgiKbryJPhRwj03Q==@kvack.org
X-Gm-Message-State: AOJu0YzCGyoiUrwnTYUaTcxH/KaerAg8aePi++IEHyIWodZwO9yF+a8G
	r31EgBAWFoDp6qf5tZCQjgKVUjwhyKnL1SptkIKGH0dbsmAMBLZ5pz2C
X-Gm-Gg: AfdE7cnjSNg+88EHi08X0gfaHXN5T1unRrjZDGi3xr6sXfknbaZWCuW1Yg+hvsy0hnd
	JYsLidycR8WLRMXNhlQ9AfYbjX9TniGAY0aQZmPUgVf9E7pTRwtuqdDx+jOMyrUKUIoiv9wWy1c
	wk4c5K4DhoELkChiiylj2+QYtJqVakyNbWV16te20Vt/esSKM796aQzGe4nZPqpA860WZVOQoTS
	F2TIMsyV+zu/+W3bHWcmnrDhfnyMIEdGuC5iwt4j2W/IpaIE+XAvx02C0RxHcKHoJNyQPmqc09f
	kRUndnUCx9RC+oMNRF79j4YIoMk0BvXX0XQS2bYh8uVLqDgFHS3GBFP1czgodthBrI+CMPbeDEN
	tCVNk9uu2U3GdyIYaBEua8V8adSI13NOEfJn/wVXtriLpNVGwRN4iPvREV6+kqqtDAkuZOvuQYT
	eYmlZQDJQ=
X-Received: by 2002:a05:6a00:3e03:b0:845:d1fe:9cd0 with SMTP id d2e1a72fcca58-845d1fea7c0mr6017737b3a.0.1782655120131;
        Sun, 28 Jun 2026 06:58:40 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23d7sm10041108b3a.30.2026.06.28.06.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 06:58:39 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	devicetree@vger.kernel.org,
	driver-core@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	WANG Xuerui <kernel@xen0n.name>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] treewide, numa_memblks: remove redundant work during NUMA init
Date: Sun, 28 Jun 2026 22:58:14 +0900
Message-ID: <20260628135828.1393120-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55CAD100009
X-Stat-Signature: n44kz5amnt1p9iz8jdxaypem9ythi58n
X-HE-Tag: 1782655121-984353
X-HE-Meta: U2FsdGVkX1+DJfrJqga5vO5DxRVU81gc2qVeM8BICaLNHJgHmH1mIOdR9BxDidvtvfhPCcW6GP5rZ9TmCYG1+tx/UihavKDYUenyQoKZQ2OsbEDgAMW3l2e3ZHHAWojiM6kRys/2XlOhOxKXmwTvTdd+qP4NYZ7ZG8KMwqFFUFf8PbWkCMAnZqL8WC0rGYlmLAfkuBDWK9X1S06zGA/cijLOhU33BzY6v7V1PWXxBudMyCsKjRccOOaiBT5CMj2p/OT9NnsktEkcWG02U5dSImNfz0pzdCf07TvrZzvtP+X8B9RtIOPhaEhv+LiLk33DgMGF5z6MAXkIekzq/p42XCUQHA/JiJX/RPmA5k0617LgYxl5B295m6Y8pMcORMEp644eGsJHl6DmTazrTge26Bda1keOtXbDdZnaTsplcrPnBndQr6oD3ESBpbb42ztL7tnXkzarSFeLX9pZb++dA0VBVKcRfYkOmEG5ZuwZygNJNGKfjFAFzUfdriEr8INwvwC80/GNhG6l7y/BYDIYKdXKUTH10C3B4rOYDZ2nr/wNcey3eks0+W3uVnR6aitKemCuoRnISeVrJu8iSqMYv9HDszrbE0QlMxjVigB9mP55wPXydjkF3YDP3EC8T22/5+nBg1C+/r6JUwuvI832MQZ/o58wW1bxSRXT+rPTOzHHPcozXlr2XvIB6/QYM9QuGBJmcwxBqk3D8t6XsjOBrlIR7lepwivzuU15Q1SuJ9OZV9pTs1CdCPjGr5K9Nh9yms84pnTv+EMTbeLYB2mNMPLid+2Qnt6sO2La0ZBmrp94pNzqIggh7VwvprdihCa0AIbKvJYk/HKj/iKQRd2nIfzv/BxfA8pEhhQo/6aW8h/O9iD1pQNN+DrAx51Q+u1l76n2gCxO3pnFSKrgAXU9XK2syt1A3gBDyUydhomcUSGaOl+n8Le2YmlqdJggs2jB4pB1aqD6nn4wfyiYjpe
 tnrZAeNW
 CTKdIQNwtNmeXPAm+mMWdJLtJ2RuAFN+eQh9+o/fcDscn8lBOTjrY5j48lUGSHMdRS4qOTNZjdyZLDhWoSeTlYNbrA7KSHSuoNfKh/XymqkRyJFiTxkYHpHHsGpHAucDvBvpJH34roYdcRkaeC/hums7KUKuUed5SOGlHH/NicpIv7ag5BPuXc4bRd0HktwT+1Fl84X7c5dF3QIGSjxVFTXTuu6sfslf8cpjSD169FJnfIQq9xJvom1WZFO0iOLvfY7ktMGq8/GyJbsuGR1FWhtRE7MCyWk8/6MtOjaxpClLcO1XKU7fbQS3Q/lSrHvENFYJublhgs4yPL42RCnNSp1m90bRfew82QymfCrHqLlyolTrG7h5408ckpAP9P1eLYGteNYogs3LTepzAk2Ih2ZahJJ7bBNVEW16H5tX6m4AyNhEGBnRKl3vNaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every existing numa_add_memblk() caller passes a valid node id and
separately marks that node in numa_nodes_parsed with node_set(). In
addition, numa_nodemask_from_meminfo() recomputes the same "nodes that own
memory" set from numa_meminfo, which numa_nodes_parsed already contains.

This redundancy implicitly depends on the callers' node_set(). So, before
removing the redundancy, make numa_add_memblk() set the node in
numa_nodes_parsed explicitly. Then remove the per-caller node_set() and
numa_nodemask_from_meminfo().

Also, since the generic numa_register_meminfo() already sets
node_possible_map to numa_nodes_parsed, remove the duplicate assignment in
arch_numa's numa_register_nodes().

Patch 1 adds the node_set() to numa_add_memblk() itself, so every memblk's
node is set in numa_nodes_parsed on add.

Patches 2-6 depend on patch 1 and remove the redundant per-caller node_set()
from all callers.

Patch 7 removes both numa_nodemask_from_meminfo() call sites and the unused
function itself.

Patch 8 removes the duplicate node_possible_map assignment in arch_numa.

Patch 9 is a minor cleanup, using the existing numa_add_reserved_memblk()
wrapper in numa_cleanup_meminfo().

No functional change.

Sang-Heon Jeon (9):
  mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
  ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
  of/numa: remove redundant numa_nodes_parsed node_set()
  x86/numa: remove redundant numa_nodes_parsed node_set()
  arch_numa: remove redundant numa_nodes_parsed node_set()
  LoongArch: remove redundant numa_nodes_parsed node_set()
  mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
  arch_numa: remove redundant node_possible_map assignment
  mm: numa_memblks: use numa_add_reserved_memblk() in
    numa_cleanup_meminfo()

 arch/loongarch/kernel/numa.c |  1 -
 arch/x86/mm/amdtopology.c    |  1 -
 arch/x86/mm/numa.c           |  1 -
 drivers/acpi/numa/srat.c     |  2 --
 drivers/base/arch_numa.c     |  4 ----
 drivers/of/of_numa.c         |  5 +----
 mm/numa_memblks.c            | 41 +++++++++++++++---------------------
 7 files changed, 18 insertions(+), 37 deletions(-)

-- 
2.43.0


