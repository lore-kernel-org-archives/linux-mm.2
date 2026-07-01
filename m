Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6D4C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81A36B00A8; Wed,  1 Jul 2026 13:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34546B00A9; Wed,  1 Jul 2026 13:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22CB6B00AB; Wed,  1 Jul 2026 13:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9F86B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:19:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFCC91C73D6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:07 +0000 (UTC)
X-FDA: 84940868334.21.2BDA384
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 30707140003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YiXy0G1o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926346;
	b=MdrwkIWTvWtzWUBxeqmOxLi6SeTR5WTQnz16iJhCiyF4VqSJ7orQzn06k4eeolOrAV984m
	AoS1Dt7IpvSYh9VCAp5rxWiJ4njK7AShLyiqDeYDb9ZRnGLFG691xqcaerT3ZeASwaw3M/
	+xHgC0J9RBSy5LCNPQdH06qhYotq+80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OVZjtpTrxXxAVguXYAz4E7mi5sWPqKxrHjlHEoMDU8Q=;
	b=IDBOXaDNSgikUcCR28YTWR2LPtuvYGzC7BSGuEsjVonj1iW8/scG3KvCwpe1inCFcmhxHw
	F/DLwsSLK5u2SKYBSdS9nxkCqa6HqGmgosr4JQA+4qwycdECq4dNRGM0NmmLiCnTj5Ag+G
	+fFeND+Jgo/rGNcFumvVz+DPdRuHW7E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YiXy0G1o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-847917c3678so829699b3a.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926345; x=1783531145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OVZjtpTrxXxAVguXYAz4E7mi5sWPqKxrHjlHEoMDU8Q=;
        b=YiXy0G1oC1vhWcZq/Zz7FWboIHzOYhTXpdwm8ikwtnqXmJsQLlycp6fqwe734G5GL+
         CzZ/ZbNgfs6HlyXMtXyXp4fBdvgs6ZTvwDgWmFmkTDbTns9Tun2YC5pmdIQxv97xvGoS
         7paFuK52YLXDjsWrTJsmqJtRF6toHsVxWJBG/oibsNBN59PAAVKKyi1GxNH5rcXUKkuI
         kufAZHvlh7mpSuuGlhb2mQxg8LZ5FxC2+l9BLtkBLAvfCvcZ+nLv5RXY5x4nhKNEmFyy
         fjnCF9D0ZmTZWf1ST5D2RgLBn9G3OcfGyP0yKVgDEeu9C6OQjjCHrjIM3A0aVeMUZCGP
         HHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926345; x=1783531145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVZjtpTrxXxAVguXYAz4E7mi5sWPqKxrHjlHEoMDU8Q=;
        b=X8PW6ntHomQ/sFn1wslCHWz1jjmRCtU38bAGoIzWcPsQPES6mPOmA2Xff7JsDvL3of
         J3NPWi+H2MdLHkG4Po0TkJbL1pZjbOXzTu2CHsb1qI8fFmDjw4GlWxo5L4AGN6Ck5JAG
         Z2AMD0sHus1UfEwKOylDbFXhYZM4vebWrIeiyzy0OBw44dudwtvhVzJ1QJUMVgzh+KUM
         4H8NEX1L2hCIAPcyDir3Dygl+JIQHZ3F+K+s4xlofKc5nqIZ8n5qJjmg1eq1B7vdUmmI
         PxDpMcuSEWK/cmhCUPL0f0QxvX+h6RhRhlLDLw2xAdCgF0rK7sgU3PqhWhVhZYjocWwj
         k26Q==
X-Gm-Message-State: AOJu0Yx5H5eTRCq5ZFA4Eom/4amaFPysnUfOjFFSCv75jqbFii+LJ3pv
	T5hrIQmxqhlSMm/uYsoGRcELeqLuDzF8qFKrLO2v4ZnDfO/l/qwh9bQm
X-Gm-Gg: AfdE7cmXgAd7fv3al8hFgfo3IVSvF6DxV9OBrnuwCJvYKCzLy5Z0hI14Ctoiw12smaE
	5nYKeXLkcK0X0MGVQKPT7iGxPK0RllKe+MTHUtpbYmMKIbyqI+D6B3GmHWaJICHj2AboV9M/Y/t
	XVI8iSqNbL5ny3CUCFzMj9I3EU0CUeDGHv1s63T5suleQbzLL9nGy8Xd6qQkvj6ta6WOVTkHokS
	1i+4RDy4G804L8EV2jNRU6IjyVqGf2MHw2L2uwPQ5I7U390wnXn77SzjLerHdyIqPglraZ6pSRd
	OG+4wHJOhLhyB3+EKscLyS0PIpNdP1pd/rKetn77pSHAasm6e2wuiPTcl948xC11ymjMOdaOdur
	QVOKILzuvaXlgzFwMn/jAiroldfjZKnnTz+y4akdmpX3auCdwbKike0mr9oKyeFdZh5BDHqvMDi
	I8z0pXz3A=
X-Received: by 2002:a05:6a00:948e:b0:846:a04:acdc with SMTP id d2e1a72fcca58-847a831fb33mr4758788b3a.26.1782926345049;
        Wed, 01 Jul 2026 10:19:05 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94ab79sm105719b3a.31.2026.07.01.10.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:19:04 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yury Norov <yury.norov@gmail.com>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	sparclinux@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 0/4] treewide, mm: initialize node_possible_map like the other node maps
Date: Thu,  2 Jul 2026 02:18:47 +0900
Message-ID: <20260701171851.2447626-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30707140003
X-Rspam-User: 
X-Stat-Signature: 6thhh4iq5wsu3p58q11yhtri6qtb1gnt
X-HE-Tag: 1782926346-121330
X-HE-Meta: U2FsdGVkX1+z11lvXibLzrpizSSDEDsM6ahd31YhdMqpbH4XSkiyPSil1zvd76qfiL+nMm2X9fhpD5r6J4ex+0tdXC/CLXezdYEiXj9MQJNs71Fc7ScFKEk/1Yn6A7cKlcK/1Y+yqkMf8pIWXD6bgSKlkXmmeXxFF2IfJn41SN9GzyY9ipBs7myV6havvmCCV0rQp+OYi30AULuMYMFjckGCuTTQK0Z8jCzIUu34iSqSPl+NZYzW+F7miMaPmMfedSqFxxwc7cwsqovibC1+po4GcCj081bA87kXr6II88V6R5LbkDry0bpcGaQCw7oZLeMHxCXG6L8vYFDfvM8xXKtwO42eU6nfX5Hdwku9wYI7FJNbfs83gBTcU/eXUHQEcbXo+EqT8HiucXlOG08Sl73oSrtQeoLaFsZ7XFE08KX8D1U6MOHeXxNg5BkWhbCfzUf0kaSjKIRCYwRKt9Ak+M7pa0k1uh/bYdZyjiDnVrNw8cskdSMbJRDybBcP/894ZFB3Dn81WvW5FGMM5hZsHBIUDBhJmREmaHhper2KC8goz1w14MvOzxNRMtvaoKOzstWjuEmHWKG7y7n8uVJy/LlxBuGOysYCX7MbQ3nbDGbW1N/FyLLHsmcOGar7nPw0xQ8+A9+C2+/Q4LMYMbetKEh/Uz6qwg1/Quifv0/xeWiHdIUJ41n/DbsJbnsV+w9C0qyPQ7piWJCk5+36QBE3jV0+y27isSGq9k1hkNIdrRYp1cR//ycrm6T5x+weV1lD242bP34dxrOKc+T+jBMm81Q3RnXV3fchjsZrZUIb4fMH5TC8xa6IxFJ4zk/tuuulhwTy6PsdXgHfRAgU7JNXWFZLNEjz9QwBAZF1+kLIP8M2ed+ypxykZqxXU8twvoP/tQWFSeIBr52dBOPk1vo5vVQSAMVtdRm2nkHi8A6LMSIDPv6DFumL5ep3keyLupSBmBrTNb0DVqL8d0kky3Y
 nvoTwPfV
 s14Sa9zbRJ5VVrKLNkM3MMvmo/+VlD/R27emRCA6YNRkOSkHPaV52G9s2yEJEBbt9198zfUlZC3EXcuo6a2vKNqjIQNxCrsXYLH5fyU6ncBInwAP5X97o7FIxqqbKlNf+7TP6tKKwYVr6QFhDxFIfyHb1v4lGoVzl3hMIbUPC1lb7EVjVMrkuo7pqi3PINYFxagjdOxvsrSl5aBVZFCToPKvj1WwPdaFwOQPMJO/of0TuCIm1vbAG8rCusZLorETzCauvbqunYi5VebRnf+TgtKB9FYThmE5847SvCOVqIaZSPlY7EfXKzQTpxL1TdJ82QSRv+uO9J2P/zcJNR1vkjyDCRWuqMyeHcmjq8IZLbh0gqKoSIzMpp/yMNp43o9bT8oRzFBom4N0wEYT+KV3wMWb62bST/ESNXZFSL3kTB5s5XuKrtqqmXbTwqnYdY1+7ivc0Jg6Jgkmm48Wv5GNdjlE4UJm95o3ATAUQ+pud1G/xCFOVrVQVvv5x5R/kPLclhnceqyEUZe7hTP9IMLLaWe90YA5odXkGvfimM/FRI6dDV5BCNaAya16c7sCl+6Vc60VWvYToB9+nFazGAbnvjkeAVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While reviewing an earlier series [1], Andrew asked why we carefully
initialize node_possible_map at compile time, then zero it within __init
code anyway.

node_possible_map, aliased by node_states[N_POSSIBLE], is initialized to
NODE_MASK_ALL at compile time, unlike the other entries, which are
initialized with only node 0 set.

Architectures that use numa_memblks set node_possible_map from
numa_nodes_parsed, so the compile-time value is meaningless for them.

However, a few architectures that do not use numa_memblks do not set
node_possible_map on their own. Once these architectures set
node_possible_map to match their own topology, the NODE_MASK_ALL
initialization can be removed.

Patches 1-2 handle sparc64 and sh, which do not set node_possible_map
themselves. Both set node_online_map from their topology, so set
node_possible_map from node_online_map.

Patch 3 handles powerpc, which sets node_possible_map by intersecting it
with node_online_map. Nothing sets node_possible_map before this, so it is
still NODE_MASK_ALL and the intersection is just node_online_map. Once
patch 4 changes that initial value, the intersection would no longer be
node_online_map, so assign node_online_map directly.

Patch 4 initializes node_possible_map with only node 0 set, like the other
node_states[] entries. NODE_MASK_ALL is then no longer used, so remove it
and its only helper NODE_MASK_LAST_WORD.

[1] https://lore.kernel.org/all/20260624204030.3c8baa67713b6ca1d537baba@linux-foundation.org/

Sang-Heon Jeon (4):
  sparc64: set node_possible_map in bootmem_init_numa()
  sh: set node_possible_map in do_init_bootmem()
  powerpc/numa: set node_possible_map from node_online_map
  mm/page_alloc: initialize node_possible_map like the other node maps

 arch/powerpc/mm/numa.c   |  2 +-
 arch/sh/mm/init.c        |  2 ++
 arch/sparc/mm/init_64.c  |  2 ++
 include/linux/nodemask.h | 20 --------------------
 mm/page_alloc.c          |  2 +-
 5 files changed, 6 insertions(+), 22 deletions(-)

-- 
2.43.0


