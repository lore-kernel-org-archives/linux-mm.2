Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C85FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2FF6B0088; Mon, 27 Apr 2026 07:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974226B008A; Mon, 27 Apr 2026 07:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889E26B008C; Mon, 27 Apr 2026 07:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 742236B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:43:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1548440184
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:29 +0000 (UTC)
X-FDA: 84704150538.15.2E67816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 628B64000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyvO8iCy;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OEDdWIqwVUBtvuq229g4pIRsqV0lFJ85CEltcqqEv/Q=;
	b=4gkuERhKi3N7RlI6mSwwXm+os1oipl1qUQ/UKsRVyaJWJ14g0rStZZ1NFHeEMDXK2KtkNS
	w3Q3oq7HJARxEGgY9thdGyU/5kbVHR2R4yn7tCBDbs7s8FSNFPuVhun54ktnbt7s67LP/z
	DCHnR9ZYm2QFBi+lf+LhNYCyFMvkCqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyvO8iCy;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290207; a=rsa-sha256;
	cv=none;
	b=Dgt+eCoTZjMizlMbud7r/jUB71BEkwnNSUmkreZKKwYqiXhhqbK8x6uZJ2k/iKQiHOlpy/
	5uHSt+L0tmbxfARR6m78WRRq0z5m+mZw2fJY3hA4tO110rKolLdJFsQPw39mIyMdq8s7Q4
	G4iFzHSMLllHB59MeaMXFfsIVGJrZR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 503F444271;
	Mon, 27 Apr 2026 11:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF83C19425;
	Mon, 27 Apr 2026 11:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290206;
	bh=uDBjCE9uwaCanxz5E5CzypxBYKKLu044ftwopYhbNFU=;
	h=From:Subject:Date:To:Cc:From;
	b=FyvO8iCy6U0CdSl4voD74NGPdf54CApAviztNsWG3LeztA9BljDb2zyoewVjhaSDO
	 dHcIp6qb4pKZlD/tOulDBgZrSVPB0/TmQWLv2XVGxJVBJRgvrmbjZO+xgCJdzdswcw
	 7AuSXWBhSyQpTDgLGIlCjsLv6Q/2HYNI7BXaZBg2qdegmxtt/bdb0LCrk7sFZAJcTm
	 26/jSP6STtn26qBhsDnRl6Wk057bbopoyAUgGD/fxNSl0pUISvMf7U4UjR9ejul7p2
	 rvLtw3V7wX2vWB3fNgckE4q0JJ2QLgIAKb1e4jfD0JsSKI8K0vqCh9QMdg+BnLu7Pv
	 bTSWlUgYXopkw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/3] mm: remove page_mapped()
Date: Mon, 27 Apr 2026 13:43:13 +0200
Message-Id: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANFL72kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMj3YLE9NT43MSCgtQU3UQTy0QLS6O0RBNjIyWgjoKi1LTMCrBp0bG
 1tQAYfElxXQAAAA==
To: Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: qhyjoagk96gkdkchr55xoytmqdu7sunt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 628B64000D
X-Rspam-User: 
X-HE-Tag: 1777290207-652942
X-HE-Meta: U2FsdGVkX1/Tz1AJ+XTAeDRUbGuXHD9ebYeOnIYGTL51lja5YeYdvbBypGU5BuazpPqQpIMhOJP9+v8snSBvQVBpGk7LWx0qtxm88ddY4XGeDSkFQxaaAHM3bNDzsC3cgxEqWCGqfXTfMg3cGOYc/x3MZSW7lJ8Z9FIruow82CqxzqiyPZmsji3Tt89pgqd+Zaaga353ufojuPKwc8ONxn5+D2b8+4LDklgvVRMoe4ymev+nitLuO4bfprBvx4cWCylpsqFdKcsFmadF5FEjWvHQe4dQ5zsianuNHfva8U1GV08B2HsYFuKKDNoirhElTj7PCn9Z4qVRzYPGTgMHC+g24+EKNVY3XcSv92mfgQY4A2d38PkYouhNeJAcLEAOILjxJgyGcmY0r3sf8r2X10JIv0mb4xVPSvW4Su8CMYUixVmsBZLPQQ3+/WwPWHXwTPY5DHs2LdzUW5d902a6FnnCT2s5GR9499nXDszPcmqqIpHTKynX5DpqHLIsKtTxFyKTatSOzVJ0i+7bpsVUqjyuNrS+hlV7S4vfFZYrNIy9cpEcKYj1A8g0H80YejHKvEjFLgnKdbtdX9Q9L2UPIo8DjfHXBuF+lw0Q4HPJqTDQZthZ9xMeu0mZ4/oCJN5OaGdMKcR1IkGXxChrGIvCbSxQECcSL1veVLKgvkPKM6HB0l0W/Af0GKve8NFLiG3ItHRp28SCvSWlbYjjVXwDD0H77Ha26XydDnjGgulfHVMPwYpgExEK+7y91kDTXum05lSyyFlpraqo2BCxOGypWQu9Dj5a7qxGSnPGZMwJM3k8FOJeKYh17D7ghiN0YKy9PUr37/gMBUMKtvmqiHhJ0zcZd6VRVsoRl2oCgwZW9Q5/gAWQxZ/BTwNJrJn3wYAG+hc0z+9dwbVQecsytK7olklKoGHibRluWgXTczzvEIgB4VGgP2JiHbvg18R2QJc6vAbPrb3IQkPQFdnGV5J
 mRJs4/tn
 V50aDNjmSY32SAK7f1Hf+cXj1B1YINGW199hqzm5Qw1zaJmDOc/voXuCt4OeJoK3LRTlZnat0E0pFgEfWOjXBuA6zZ61tjwfCyyF6d1mcPRXFDn9zWn1Lj6Nu9HZIPBKh9bxBIBMVHebBGlBSyBQCkG4BMTqmi3/cP01vPjEEozcO85Y59Wl3lVJn1mSwY7HmKvNrNZZifb93ffANAHqzh7kPuIjWlxkUiIaz7HHjJVTu7DQnmEGlZ2Mj+QJdTeFVH2Y7J2MsSzSFOji+Mg+gaJodzAw/dHGnVoZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While preparing my slides for an LSF/MM talk, I realized that I did not
yet remove page_mapped().

So let's do that. In the BPF arena code it's unclear which memdesc we
would want to allocate in the future: certainly something with a
refcount, but likely none with a mapcount. So let's just rely on
the page refcount instead to decide whether we want to try zapping the
page from user page tables.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (3):
      sh: use folio_mapped() instead of page_mapped() in sh4_flush_cache_page()
      bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
      mm: remove page_mapped()

 arch/sh/mm/cache-sh4.c |  2 +-
 include/linux/mm.h     | 10 ----------
 kernel/bpf/arena.c     |  2 +-
 mm/memory.c            |  2 +-
 mm/rmap.c              |  8 ++++----
 5 files changed, 7 insertions(+), 17 deletions(-)

---

base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d

change-id: 20260422-page_mapped-a49a892fa432

--

Cheers,

David


