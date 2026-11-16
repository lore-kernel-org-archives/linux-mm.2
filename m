Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE0D606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=daCQz1Zh
Received: by kanga.kvack.org (Postfix)
	id 3ACD86B05B5; Mon, 16 Nov 2026 08:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384D76B05B6; Mon, 16 Nov 2026 08:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C18A6B05B7; Mon, 16 Nov 2026 08:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06EDF6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:40:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34CE2A06B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:27 +0000 (UTC)
X-FDA: 85441091694.13.77AD351
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A80111A0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daCQz1Zh;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836425;
	b=07/siPfw7tYywQ0zUPmGliCYpXjHKirI0TUh8zFSR6f1JZg/Yb+bPeUbMz3AG7l9V1y+0r
	JX0nGpxDdyUsk1ID6SrSerfxMJr3WfuLyzh666YfhSt2WxtriPxqWQ39oT2ryhNYacOvkw
	wexymjEV1oL9xmMFUszfil9MT6oEgzY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daCQz1Zh;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7ZuahbF6+z1TKgPocK6b1w/LNWgw/JvkC15VlenM0sg=;
	b=QYVLjQt1bmIUDWem3a7hTTOLaBjouR5u1OKD/ccjWYqPAvWJpq5/Q/ut9yDRbO6mjqLFYm
	jEYQ/YEHG7fclkddnHrg1whYpeb+03XkBFJ/jvU/kWif1nEXBYoXwENWjHdbz03YK1VLmW
	Y/ETHfUeL6str50j+cccDFXKIeE1vBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32AEA60D5B;
	Mon, 16 Nov 2026 13:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8055B1F000C4;
	Mon, 16 Nov 2026 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836424;
	bh=7ZuahbF6+z1TKgPocK6b1w/LNWgw/JvkC15VlenM0sg=;
	h=From:To:Cc:Subject:Date;
	b=daCQz1ZhyWXtl44VERLjzwf4McgJ7N2+wucObuWTVBGvb3rE+VtwnoUq05dSgs42q
	 1LZSyEtpWtMTp71b7BeklLRhhuuUwIqs2mZggNQen0Ew07p5B1gk0cTr+zagFCAN9M
	 v69VqSUP8U86/2u44DncKRe2BjOVrkPNXnGxurTVOYsVFomucT6Pyk+1Dfyaquexel
	 kHDjwlalUXamnXa33LjHbumfNimFC4spzOSiCzA1uJn+jyoCiYr+cMboT4tQ/uFO1d
	 JSiqfaiFJgERJPTKDh/zU25XFfS/wFn/tKEn75KV3pVoj15wye93vm/YJke3oCo+px
	 6v6+5DB8GP/5Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/5] KHO map
Date: Mon, 16 Nov 2026 14:40:05 +0100
Message-ID: <20261116134013.1636689-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6wxqdpy464oza83948jr6bg79miw8tb
X-Rspamd-Queue-Id: A80111A0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794836425-557730
X-HE-Meta: U2FsdGVkX1/6AQ3uUQ65fHvfrAjlEhvS9PwF21ZSbg+Py4ikEcJn8ywImHLt8LbAXGUK6B0a3+fCCribUi4vU6+LpgVw87DAHtOnIg3HEGZKcRrwRz5+XFcPOYhWrJTdK7Aj243rDe5z/OuQjMBYCfB01biKO0UgxPkiCogQsaYLCysWjTfhTF1gd07h24Ok9xEG0yeqCOBFGcenCnXaLLmX/R19+zem2Ryv9OI1RcNcExkRqCxD4+XkRrGi8spuM+IyAKQ79BLb5MpEVffcZbEaiEi9DcJa05Urb6iDmkqG8NP5Oix0hOFNYE86p0vSPgvSAaIshXYtmXsyJoNmwvKGMzpKEEgmycRsrjnvUY9OLNLNks/CAPBnC9IYh5V0UBq5Szq/xt6KkGZbLsWwk3tp79iXxtXj/dxL71hrvfe10bg2ZRYTQlUxHSLZ4GUW2OxAH+RvxqlfQjGBEyio/StvZ74xniSu/uVUqLbNe8zUCtiQTfp/ENGz/I4HM037mOBusTHkw0ZWa8i6A2vopdqSmwKZ7SwhzAS9BejhT6ofB194fOqyQPA2H1VkL1nSxzjd1V9zWtznK/Hc1aBT2iSbm1h3R2eKWUWCPhqmrm966RWN8+CqxbxQuqLITSih4GDzMEUx/u8IyIODU1UxpgsbIyKtrGeeKINzgFkPYPRCPDsoMdm5zh5Di84gO/DH5Ly5j0tsNjpXzO+l9nCF+DQZ3LM6BVWQ3UlOz0ESbbP92WxqlCer+Fs9Wsd1ZVrJ62++UoAQvZ0dBkKOFFMy1v4hjbijd7D5DFUCOLIsTfYHswoRIzPuV1RwfMkf1sONhkMzvk0vDaYCJUsc4ZCPceywoTsvsvDZWbefI3X6vzFIqibUULM7j1vF9rN56Q4kDbqEYCRVUGxlmKDGXi1mhmU9QTkzMVvyoDRN2LXgGJGjKnYIjyti+P8cu23Tl07Ax57X46yGxkCyvuDq8pf
 sG5ztYdc
 xx67NpRG498Lzcb9QECwWOY0++tKFNk64W8qc5QBnd8TGHqLAjWznN1N3SDzzVcOVUzzlVlN/1/waWfRyKEhJ56eHzBXHl5P2E+k6gvhUlN4HVKi4fufAKoKgyqFID+bMHf0X16kSITxPDc/2KQ3Bcdg28rQF7qXk0j8ayC5EiM5WWx/SkV2Rrb4ITbkR18tSSoJBSc1kNBxZuH/3aaIwTrAmQ8DoU+h7JkDi/gcisM+R7VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series introduces the KHO map. It is a sparse map from integer keys
to u64 values. It is implemented as a radix tree of fixed depth.
Currently the tree depth is 6, so it can support keys up to 54 bits
wide.

The main user of the map is memfd. Currently memfd uses a vmalloc buffer
that has a pair of {index,pfn} to track the folios in the file. That
uses 16 bytes per page. The KHO map uses only 8 bytes per page with some
overhead. So for a 1 GiB memfd, it uses roughly half the memory.

In addition, it is a more versatile data structure. For example, it
allows for adding or removing pages from a memfd after preserve more
efficiently than the vmalloc array.

Post-LPC 2026, the plan is for KHO to maintain backwards compatibility
as much as possible. So this data structure allows the serialization
format to be more flexible to future changes. It can also be used by the
upcoming HugeTLB and guest_memfd preservation.

I have talked about this as "KHO xarray" before, but I think using
"xarray" is just going to confuse everyone since it isn't really a
xarray, and the API works a fair bit differently. So I renamed it to
"KHO map".

This series isn't complete yet, but it is in fairly good shape so I want
to share it to get some early feedback.

Things that are missing and planned in the future:

- Multi-index entry support: currently, while the map is very efficient
  with 4k folios, it is horribly inefficient with 2M folios. Each folio
  in the memfd takes up a full page to track. Multi-index entry support
  can fix this by tracking entries that cover a whole page in the
  previous level, similar to page tables.

- LUO versioning support: LUO versioning headers are still in
  discussion. This data structure should use them for future
  extensibility. I am mainly waiting for things to settle down there.

- Dynamic depth support: Currently the depth is static, so it can only
  support keys up to 54 bits wide. Adding support for multiple depth
  levels based on what the caller needs can improve efficiency and
  flexibility. I likely will only add support for this in the ABI and
  leave the actual implementation for later when we have a real use
  case.

This series is based on a couple of memfd patches I sent earlier [0][1].

[0] https://lore.kernel.org/kexec/20261103172251.2348370-1-pratyush@kernel.org/
[1] https://lore.kernel.org/kexec/20261110175855.2437084-1-pratyush@kernel.org/

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (5):
  kho: add KHOSER_CLEAR_PTR()
  kho: build KHO objects into a single kho.o
  kho: add KHO map
  kho: test: add KHO map test
  mm/memfd_luo: use KHO map for tracking folios

 Documentation/core-api/kho/abi.rst     |   5 +
 Documentation/core-api/kho/index.rst   |  12 +
 include/linux/kho/abi/kexec_handover.h |   5 +
 include/linux/kho/abi/map.h            |  94 ++++
 include/linux/kho/abi/memfd.h          |  39 +-
 include/linux/kho_map.h                |  77 ++++
 kernel/liveupdate/Makefile             |  13 +-
 kernel/liveupdate/kho_map.c            | 514 ++++++++++++++++++++++
 lib/Kconfig.debug                      |   4 +
 lib/Makefile                           |   2 +-
 lib/test_kho_map.c                     | 575 +++++++++++++++++++++++++
 mm/memfd_luo.c                         | 292 ++++++-------
 tools/testing/selftests/kho/vmtest.sh  |   2 +
 13 files changed, 1449 insertions(+), 185 deletions(-)
 create mode 100644 include/linux/kho/abi/map.h
 create mode 100644 include/linux/kho_map.h
 create mode 100644 kernel/liveupdate/kho_map.c
 create mode 100644 lib/test_kho_map.c


base-commit: a0dc8eddbfdb6dd9c5c2b70eb66ab49cb1978425
prerequisite-patch-id: dc555295a2263ea9482ab393c50296636ab1e84f
prerequisite-patch-id: b0c8f9caeb6fd99a352692083e4d2e9255f13d02
prerequisite-patch-id: af8beaebdb1687c349732dc4a7773f7baa4a2c17
-- 
2.56.0.611.g1030f0b940-goog


