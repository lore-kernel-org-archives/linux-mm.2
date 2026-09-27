Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052DEC98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 07:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B9E6B0088; Sun, 27 Sep 2026 03:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CAA6B008A; Sun, 27 Sep 2026 03:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761B46B008C; Sun, 27 Sep 2026 03:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3F76B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 03:28:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C442540997
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:45 +0000 (UTC)
X-FDA: 85258715010.04.FAFF688
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id BE14C160006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790494123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=5mJA/dW9f2TO0MqN6qhjumDsevyMBlh3Bv/b/wgwaxY=;
	b=Zbi59rScgrlb58dShKDYgbYIoCkzrWxFMUXYA/nAeGtnMSemU95vEHJ5N2Mde5dGgBDB61
	5kkaId6Aia4/uTVn5MJ59S/HOJLdjX54y0jQDDGMR2Er1c6Qiegdui+WMaLsFcgQWrK8//
	nuIMIAqfMFcDDoh6F/XewtH7tgJyhag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790494123;
	b=4nXRJ8cLbBu0A+6GrTjLkwtZOWnrtU+ksJRwR/kvwblPMaF/jN7h6CIkMeki6DReYSR690
	GtnwEQZxCimTHKt+Tux3jNmDzVfvIWjoJlYgdNKkpsrHOxl8M2fqOZNU/BVZ6e5cuseLa6
	3ow/9v/UCkxAxrNO0pnAToXEVAR/9+Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 0ad6bb48ba4511f19a56ed5b684f684d-20260927
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8a7deb06-d4bc-4c41-bef8-37ea0f95f791,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:8a7deb06-d4bc-4c41-bef8-37ea0f95f791,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:097ba7729f98d559a1a08277f70a3465,BulkI
	D:260927151408ZWAW9HXW,BulkQuantity:2,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:40,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ad6bb48ba4511f19a56ed5b684f684d-20260927
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1466070180; Sun, 27 Sep 2026 15:28:32 +0800
From: Enze Li <lienze@kylinos.cn>
To: ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	sj@kernel.org
Cc: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	lienze@kylinos.cn
Subject: [RFC PATCH 0/4] rust: damon: a first small step, plus a Rust prcl sample
Date: Sun, 27 Sep 2026 15:28:08 +0800
Message-ID: <20260927072812.2393456-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE14C160006
X-Stat-Signature: xwior9ncunqt68ixkmyn3ybs876441zc
X-HE-Tag: 1790494121-245937
X-HE-Meta: U2FsdGVkX18pt5iHkMWkFovq196VUTNFz/exvlwjcN3jLT9/dLWv+CJRJhnUCQaxLpJOtMB5C3kKRmRIT0STeva93DY/R+thvCYpG1t6EDyEScN5z+3xycCWMz9W6CAEPS7zYX3KzkrgUcI2UuGYpzg/qyNPbQgqOcg+eDb9fUyMELbAMKz0enQdXmeeBCVkrVK3PmLsPVUkQ390xcgAW+m9yPNUZ0TSr6uG/0gbRPtYqxZDqghcVBN7qHZxzwMyVckDGfeq5walq5ArptOYYTfN/1Yx6u5k40dfUwpYOo1GStJGqyLOELo0yPZgLKOh9c1KcRqlew5gcv0NH7ZyfNFjVTI+/Z6j0xNWDBKNCTwjqWEZs1V6u6gfJGQoMWRtYRAUdSomYG75/AZiZiNctM2HVwyQaB8IojDpDHw8NSXBcHLF1gFJcqJqAtlip2j/2IVe1Mc9JLuu3jWW3Tt1sF+34oq0s5YUcZZuSCoypkZlSWyrIGBksa/iAzkO2nVFd2HJdm1imd2t3v2YBobK6zbaAuUmodm/F6/kdcwB/FRFQPqll/G/tpjnxiCVtovss2pTgQtBf48LEHCXlHQFOHJV+EDfM9BQKgDPPrLJrH+U+RZx4MPyPsUiZOhyCNqLnkdYdFe4N6rq536ulfIq2/78Ha7rUZVZL3i92YkYyqgCVoahb82HPHEnYn9buk6Y8ftrjyJUbJEHnD/Dg2TPyVPcF7+yPqof0J9RvMpfBeRh2kaLUPxv7rmRI8VTSfHErDih0YcLt0+NNdUJm2JJ84JqiJsIOCI3pOFE9GIcu5E/WxonAQefegTH1TvqUEphRoqOZP3olRs4zyCLEUVOhO0AOcvQV/1Q4ughVtSb1wMk3oZtETaaZ/rJp/Szcze2s5H0uVL2IVARzQr/M2vxHfzI6LhPweym96DkhikS1dZKB7dxXjf9lzkM8e9VddzWV2qRa2k76lrc4Veb66F
 0JuV7MZE
 zp025WQba6uNtmzrB5+KciNc/ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ, hi all,

Almost a year ago, right after a memory-leak fix discussion on this list, I
asked whether introducing Rust for some DAMON modules could be worth
exploring as a proactive measure.  SJ's answer was positive: he was open to
Rust adoption in DAMON, both in kernel and user space, and even mentioned
he had been wanting to write a Rust sample DAMON module himself since LPC,
but had not found the time yet [1].

So, here is my attempt at making that start happen.  This RFC is
intentionally small: it adds just enough Rust support for DAMON to port the
proactive reclamation sample (prcl.c), and nothing more.

The series has four patches:

  1. Generate Rust bindings for include/linux/damon.h.
  2. Add thin safe wrappers in a new rust::kernel::damon module: contexts,
     targets, access patterns, quotas, watermarks, schemes, plus
     start/stop.  Everything FFI-related is confined to the wrappers, with
     the usual SAFETY comments; error codes are returned as kernel::Result.
  3. Add samples/damon/rust_prcl.rs, a Rust port of prcl.c.  It watches the
     virtual address space of a target process and pages out cold regions
     with the DAMOS_PAGEOUT action, same access-pattern filter as the C
     version.
  4. Add a MAINTAINERS entry for the two new files.

Two differences from the C sample are worth noting.

First, the control interface.  The C prcl sample is driven through
runtime-writable module parameters (target_pid and enabled, the latter via
module_param_cb), neither of which Rust can express yet -- its module
parameters are load-time only and do not show up under /sys/module/, and
there is no general sysfs abstraction in mainline or the RfL rust-next
tree.  The debugfs abstraction, however, already provides the safe
read/write wrappers we need, so the Rust sample exposes the same two knobs
under /sys/kernel/debug/rust_prcl/.  This is a temporary detour, not a
design preference: the sample will be switched over to match the C
interface once Rust supports sysfs-backed module parameters.

Second, the functional scope.  The C sample also repeatedly reports the
estimated working set size via a repeating damon_call() callback.  This
initial Rust version covers only the core monitoring/reclamation path
(context, target, PAGEOUT scheme, start/stop); wss reporting needs safe
wrappers for damon_call() and region iteration, which will come in a
follow-up series that also makes the Rust sample's output match the C
one's.

A quick word on the longer-term plan, so the design discussion here can
happen with the destination in mind:

  - Over roughly the next year, I would like to port the other two DAMON
    samples (wsse and mtier) to Rust as well, and let the DAMON Rust
    compatibility layer grow together with them, wrapping only what real
    in-tree users need.
  - Once that layer has matured, I would be happy to try Rust for the
    production modules - damon/reclaim, damon/lru_sort and damon/stat.
    That is a much bigger step, of course, and it only happens if SJ is
    comfortable with it.  Consider it a willingness statement, not a
    promise.

Regarding the MAINTAINERS patch: I listed myself for the new files, but did
not add SJ as a reviewer yet, since he mentioned limited bandwidth for Rust
work in that earlier discussion.  The existing DAMON entry already covers
samples/damon/, so the sample reaches him regardless; adding him to the
RUST [DAMON] entry would only additionally route future changes to
rust/kernel/damon.rs his way.  Happy to add the R: line if he wants it, or
leave it out if he prefers.

Testing: build test kernel with CONFIG_RUST=y and
CONFIG_SAMPLE_DAMON_RUST_PRCL=y.  Functionally exercised via debugfs:

  # echo <pid> > /sys/kernel/debug/rust_prcl/target_pid
  # echo y > /sys/kernel/debug/rust_prcl/enabled
  ... cold regions of the target get paged out ...
  # echo n > /sys/kernel/debug/rust_prcl/enabled

This is an RFC, so comments on the wrapper API shape, naming and the
debugfs detour are especially welcome.

[1] https://lore.kernel.org/all/20251015150701.68087-1-sj@kernel.org/

Enze Li (4):
  rust: add bindings for linux/damon.h
  rust: damon: add basic DAMON abstractions
  samples/damon: add Rust sample for DAMON access-aware proactive reclamation
  MAINTAINERS: add entry for the DAMON Rust abstractions

 MAINTAINERS                     |   8 +
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/damon.rs            | 292 ++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   2 +
 samples/Makefile                |   1 +
 samples/damon/Kconfig           |  12 ++
 samples/damon/Makefile          |   1 +
 samples/damon/rust_prcl.rs      | 158 +++++++++++++++++
 8 files changed, 475 insertions(+)
 create mode 100644 rust/kernel/damon.rs
 create mode 100644 samples/damon/rust_prcl.rs

-- 
2.25.1


