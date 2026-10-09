Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AD7CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ED96B0098; Fri,  9 Oct 2026 02:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17426B0099; Fri,  9 Oct 2026 02:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54516B009B; Fri,  9 Oct 2026 02:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58586B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:35:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E4711601F3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:35:23 +0000 (UTC)
X-FDA: 85302126126.24.DA6BADB
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21471C0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:35:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RD7OVw1p;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527721;
	b=d49ymw06hHXeEgOun7DRKK4Pe49J9H3nB/4lQi4kOubbaVRlYTdQKpHtscraWjEe48015C
	Bw85lFRUn6LyV6MGZtCcrycoyKsyoBz8ue8wbWdEHTCKzMVS5k+iPtdWe+TL0wNWh5zyC6
	dOJalb8yhLsXsfj29foukfxulNiZAVA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RD7OVw1p;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ewDhzUV9xaVt5mKw3GI50ncC05J14fiW/QMxZNAxhg8=;
	b=wLLiwxScz8SP8inYjv7Ti4FB71W0KIjKLz4pnPmbSlTXS2H9pMJp3oTsSewY1byYAUPZTT
	9BzJgPvvYRZ17mwP9jPOhV/3l4wH4ui7JwE+vjV8ecY/ux9sf4mdkPn2axvqaLkVwYodGO
	Z1xaMZ/P22RUt/M6VJ3aZR7lwHaiIWQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tfre8IQfOGlwE6Sd6ZF0/CKAPq4d3X98BZ98KEdVsDo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527716; v=1; x=1792132516;
 b=RD7OVw1p3g/fZrB+c6jIv99zK9knIbVlVoj8N7B2zOzL+7Vo9ldkQoPk/fZN5iTjLIUKn86L
 j59RoYV5EpKrDYaJz7ST/CAasyDSYfi2mHC4eiT0mv9W+wFsPvd16Y8Jx2uHf2xwYZXMtvcUTse
 aWsBoFmobaJyuuoIY6FVeROU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 20cf8800623ca6ae;
	Fri, 09 Oct 2026 06:35:12 +0000
X-Mizu-Trace-ID: 20cf8800623ca6ae
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] mm/vmalloc: make the mapping functions undo their partial mappings
Date: Fri,  9 Oct 2026 14:36:15 +0800
Message-Id: <20261009063619.112313-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21471C0003
X-Stat-Signature: 36tnftoocfwhnfrqp8kje4hz5eyd53zi
X-HE-Tag: 1791527720-24778
X-HE-Meta: U2FsdGVkX19FZDmqB4FoWW64CirzXeVbukWIIVI8www/SwkT7f3kgOW7m+IWZCH0+jlFpqw5WMoChHnhNo23ys3wJLCKVAKq6Sk0rCWRh6UMKCdmH7sjx6VR32OCQkUfiJAL4mNTnHb9oeF18B2gd+q9MzBiwOj+CqZF4g+2qJ2UI89IAYxTX80KlPLJB5fyorVmEAcbi5vYL0++F7X8YCi2D1IBzbKVBpuhrPdVyG9jOzFJ+d68uQcOYlbiUqHM++IPQgH1XT/u8UFAlLJAvV18hZnYatQjTdglYb4vgJQku7k20OAagUMywYrb2h+bSfvKKnnWnzmcfJtUhRlB6DGoc9irRe1P3tJeaSAYDh7NZV9Q7yHv+2k4JbY1R7L+Q05l8Y+R0xgsEzjC72cAF5ncxcOAWwPdH/k7AiP36UFU6tLkYyVFIM9wUx/ATLI2XSmYjxEUnE1O2BLWx1H9kIkPdaP2bjjokJjC95rhGNNasD1/crQqYG8rAGGaJHOQex++U1qGH1QlCzGaEgcYWu150xDbUyyLLGTaZDcqSJAllbjnGY9ib3HIC5DVLXwhGU7SQBrip4rkj54VTRxJclLxYN9VpwaIj083yArfReEE5ta+NN8rEF5KVLQ8j+dy3L+Mlc62fjWorcvhrMS0GM5BbTFKix2KAH4WclHT5EeXjMLlxHGi6AilhShX3odw2uupwM40RsJ0nGpD+n+HasDEjitV4JchyOb/GXvntgHGPCBIjj3zWEU0sSc+6hMTUhl3yme8JxwYTYjk6arKWilaoa/kaOHOnGPonFjU1xXXsAHcvMl2mBpomBxQLPF8feykxTu4bjD0qtqZs71ZkLT29T3rnJluz+ILd77VpEwc2NKYPxBC3yIt2l+NXxXhH98j6sDN/Ao+F/L2q/tpIF8ssAF93jEDaWcqXJpMSSCrsGDiYd78m+Hog8gNglNOWZd9JZ8EjonEoNkXbTB
 TFm2waCy
 tCCuuZ482yLMfKd+iziO2F1xoCTWf3MnudZCSnXvuD6CwXKQ0tZKSkHdsODEtPF7a2fJAn8Rr92/rGla4NTAGqcVSXlZ5CQAJT/AEk2jTn0oHgDQUd4Qn+e7RYv/mL1kIIO0D2WnXnSWac1iGGaEul5gmZy91HPKHwKVb6mLaN5s13qbXeNNwfZobtscNf5J9TpE7CPeHsKwserW8yIWD2n2P6xwk0cy33FchJ4e2rN5NtisSnVSq4Bel4S6cQZHyUhqcE8Tl7W1tV/FehR+/nSHlFXJ5OyAKbWQmNyYTlxPYXSUkJounXWC0Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmap_pages_range_noflush() and friends can install some PTEs before
failing and leave them mapped, and the kernel callers do not agree on
who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
roll back what they mapped before the failure, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() rely on the mapping functions cleaning up and
do not call anything like vunmap_range() themselves. When the same
range is mapped again, the attempt hits the leftovers and fails, with
a BUG() in vmap_pte_range() for huge mappings and a warning on the
small-page path.

This moves the rollback into the mapping functions. A failed vmap
leaves nothing mapped, and the callers no longer clean up after it.

Patch 1 is the KMSAN part. The shadow and the origin of a range
are mapped by two separate calls, so the rollback there has to
cover both. Patch 2 adds it to __vmap_pages_range_noflush() and
vmap_page_range(). Patches 3 and 4 drop the powerpc and percpu
cleanups that are not needed anymore.

Hao Ge (4):
  mm/kmsan: undo the shadow mapping when the origin mapping fails
  mm/vmalloc: undo partial mappings inside the mapping functions
  powerpc: drop redundant unmaps of failed vmap mappings
  mm/percpu: stop unmapping the CPU that failed to map

 arch/powerpc/kernel/isa-bridge.c |  5 ++--
 arch/powerpc/kernel/pci_64.c     |  4 +--
 mm/kmsan/shadow.c                |  4 +++
 mm/percpu-vm.c                   |  5 ++--
 mm/vmalloc.c                     | 44 +++++++++++++++++++++++---------
 5 files changed, 42 insertions(+), 20 deletions(-)

-- 
2.25.1


