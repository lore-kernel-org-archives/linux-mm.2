Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414DFEE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22406B00A8; Fri,  6 Feb 2026 16:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB2E6B00AA; Fri,  6 Feb 2026 16:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7446B00AB; Fri,  6 Feb 2026 16:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D40C6B00A8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48BA8140359
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:25 +0000 (UTC)
X-FDA: 84415280250.06.C2ED51D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5416F40005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AIDqMWe2;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q2P4QehJo/gsXbiR3hse/KUBtr1Saf4WbGhtA5/GLOM=;
	b=5RZZydl002sk2KIj+Ajt+Z2/y+aoUkPx6GIRB09mLaMzWLxtnwfrcZMjuks2iO103jBroY
	J7ARi5wKcIxRO/F16k0O/uEzsXiY4GKOIS/k18tHm5hVup3mPDdnG0FTf/ATvwBOrH6Qhi
	052L2Cjr/LBYDv9JxZ/bydXm/fGZ8GY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412343; a=rsa-sha256;
	cv=none;
	b=6RosVIAwuH+U1ShaHmQkYI0Xww97517evUNZN87Tvv8L7e4P3SmdjZdT6cW70FjEtEeWZb
	8npRcEbVg5jPe6m+4JdevMXU1yoNvLLzi9WFew76UVYfxyvvfRdRW6YfTPiEZ9XTkavszZ
	S9Xbon6SqHdgb4gm0M4Viz1PF2a5NEU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AIDqMWe2;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86A2F409C9;
	Fri,  6 Feb 2026 21:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A9BC4AF0B;
	Fri,  6 Feb 2026 21:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412342;
	bh=5WKo5uBUjX5QPLFNl8wA/Vj0sv5R32fKXQvQd1Ufft8=;
	h=From:Subject:Date:To:Cc:From;
	b=AIDqMWe2EuWYxcbk6HU96OXrBGRKa7exqwm8cvNYk3b3re/gtLxnpiGmsqnCnx5m4
	 yVqLwoiaMuAx223+5HA6vg5e+rW3mNMetkAek+mvkEZq+IMq7Z0ILfjcNeT/jNbB6X
	 DhkDTykKFs3S0MFk6vOx3QVBNI0+dix7Itorql7GgXCN7DyXL0OiqYxTOKcd9SzSuS
	 Ldvr/hQYqGJqVJ820u84T14mWauLzdlkNvrCkSaM1EUD+/kYnIJZx82Jv7SoMewDe3
	 PLSgsOUbNI/PMi8PQ9p+rcNDGVlb6apMoDCvhPdWoiEPPjUDd5GZWin9BORq9E4J5+
	 j1UUxRcjtlGGg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v2 00/11] rust: xarray: add entry API with preloading
Date: Fri, 06 Feb 2026 22:10:46 +0100
Message-Id: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANZYhmkC/32NQQ6CMBBFr0Jm7ZihgEZX3sOwIHQKE01rpqSBk
 N7dygFcvpf893eIrMIR7tUOykmiBF/AnCoY58FPjGILgyHT1YYaXAfVYUP2i24Y2VskMg05urY
 tX6DsPspO1qP57AvPEpeg23GR6p/9V0s1Et64c8523IyOHi9Wz+9z0An6nPMXPWSbv7MAAAA=
X-Change-ID: 20251203-xarray-entry-send-00230f0744e6
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3494; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=5WKo5uBUjX5QPLFNl8wA/Vj0sv5R32fKXQvQd1Ufft8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljh88TuYii7jqXgpeEcQt0TpuDWaiygX/y51
 ufFoey9oNyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY4QAKCRDhuBo+eShj
 d+KDD/9gTRJ1O91fligko0DTkVdfyhGxSsRZXfjnPPssfmRXOSNxREFhjg1vA0EQZcBi/HJqiB/
 UvPh48lTNK4tnTe1W023qlWEZytLSLJQnqb56Mhshg1Uk7JzXVhujToiUzGhGrSPTzE2uZq2Kcr
 9oJubBG1rzYTH2jF0OM78izhnIkZPpa5rc1kmOiEtFD5EGThF59+W1+0G/YwCrkxzAdDFMKLPLd
 8GlmkusnY3PDlsSuhu5pHLFLD6Jm/Isk+UZQzDc0BkF0oCWSvdcElFaE4alh0piLxh2v3VNNLET
 knoTTJjrvJx1DLNCkQ1RG/cX7lLHlto5k2fPI7grlrrj7IsJSclS2w/WF0eHcrOipiqjAUwMiax
 iibQ+sKU301/7s5VaEjTWLsZoM1FAAS+C04ltf7uaVPjd4X89WF+dT9X/ZpAtmnntnCJr4h6MMd
 38Cz6Ec/aAOOXYdpGFkJ9qPcxW2a75YxiJM92XGZonTqYVo+HZ9Ru3zGc/z6zchw0qzI+UQs6Rp
 749c9IrgqKkKyvktraZwSIwvZStGybaoO77FgzNF2+4v/7WIdOoQFDBcZTf/64CyJiI17eFu4rS
 jl4t/Jsfdpg+wkP2ZRcXjPY34AFFhjuNRPOlXf2I0uN56OudVjoDqrO0lu8KeSe846VP4RoxUH7
 qBhe/TtPzHan/vQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 5416F40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: czbq6nrb4kp8s7usyjz7eoc1u17a7wnu
X-HE-Tag: 1770412343-335540
X-HE-Meta: U2FsdGVkX18O8oWzIx+aCGnXCZoPRh9KmONka7Lr6G2CJe5YccqjK7uY0TliMK8TMLmkzBHLJwGFpCifkeSkl1HCPfwlFaMNCpdZoNqZcW2OLnodZnTJ9xg0K5XBy+NCXb81H0uwlwdCaXvy2Lwzm1UFPrJz5nC9V+d3bPwV7J3Rtptcw/DLMQBtfFrJvalD0IxIHZJc3mue+8quO8O1AAvpp7azX8RQ+xy7KsPBfINuxsr6mALQNyMDX4wIhisUoXBPqDfk+Q7CzPnO3Vm1V/l49ORo5onz0mY3sOUhzgZX/k6KDde/XMSQo5lnsZzWgKinMgdE4t79jqRMgRFS5vJErFkXawNfYaIc+IoPdnIRzvosn2NAhOt77HLmo31QqOQpi7KigeGlk+ZuNpFlezLBD1v4dh30btsOo/5jMeaApDwX3qxWSeF46CHDeCj296do5CAN+kYI3fjR9ywzyjQwchK58lF9oKCHuSO+YTQy5ixlzqLU30CXKZcbXhGTbdnrvbiPvkeydLmxsmRVE8hV3R21SMwbqjX2KRWgjXW7AVTTEtiCayb2+VnxBFn45WTPTiqEqvns63zEh2VXJtW19Dw6wfLbUX5bXy4Pe4IfeY/heGYN2vMCe7KxAjETP+7ZUebUiBBjO4tCPLcPLo7JE0an3wQpUFhljokLjlWKBFQHfKuqvBoD3NyIJ3b05+LNvWozMrLsCKap8nxsiwD/pEICA4EW1I70l4Cm4nswiLHTXAKdl7vp+W1AonV+dRxzGsUBrRwTwO3AYVT6sAMVaLQ40iNUryZOpUSDu8725FgSqgr5hEXk1X/ohcRKvTGhZSruNbD78qc90RY0h/zARHtAMNz3Dg9pv/3kj9yj9afGLsufOU3GgfnNWF2DRlHwJ5Ykmi4NQP7IFiOSjCSIx5U53S8qI8DUW0JD5Me56pqO2mTiYcETNa3Anyxo+9tyOsPg7PuBX7FLG+L
 8aw3nhxk
 JlcxlXf0+sO2LMjA963s/0A7VFBqGl4FuJBLWwRR7zzE5+fea/e0aUScaph7T9GUeXT7E8eUzmxuTAj1veOx4oiO3WdC3TFhukpvZpZRdTjT7Fum7CdA7aRv2CRNFxaWMCk4zAqebmheHmlLJbCqr+UtC7QrZBPl1Huw6GWhKtGZCML/Cd1DAqHb9GIEtz7WjX4GL0Ciqn1XTZkc7SUj3iXAu1iZNNqSk4yCQMU47We48YOQoXQnbYiH8ybCGDFFXA4W6evbHY0WkxreJCOjLec57wTWMfzutTpoQ25ivXGjIctrGYzMy9LCcRZHCt1aEhUyH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is a mashup of cleanups, bugfixes and feature additions for
the Rust XArray abstractions.

 - Patch 1 starts by fixing minor formatting issues and bringing use
   statements up to date with the new coding guidelines.

 - Patch 2-3 add some minor convenience functionality.

 - Patch 4 adds an abstraction for the C `xa_state` structure. This is a
   prerequisite for all the subsequent patches.

 - Patch 5 removes an unnecessary rcu lock in `xarray::Guard::load`.

 - Patch 6 is a simplifying refactor of `xarray::Guard::load`.

 - Patch 7 adds two new methods for finding items with keys that are larger
   than a given integer.

 - Patch 8 adds an entry API.

 - Patch 9-10 adds support for object caches based on sheafs.

 - Patch 11 adds preloading to the new entry API.

The feature additions in this series are dependencies for the rust null
block driver, most of which is still downstream.

Best regards,
Andreas

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v2:
- Rebase on v6.19-rc8.
- Update the cover letter.
- Implement preloading with sheafs.
- Investigate generating RUST_CONST_HELPER_XAS_RESTART as pointer -> Not possible.
- Correct wording of commit message for patch "rust: xarray: use `xas_load` instead of `xa_load` in `Guard::load`".
- Correct wording of commit message for patch "rust: xarray: add `find_next` and `find_next_mut`".
- Remove last patch (lockdep static key fix) from series, to be sent separately.
- Expand note on why store to occupied slot cannot fail.
- Change signature of `OccupiedEntry::swap` to match core::mem::swap.
- Move // NOTEs about storing NULL closer to relevant checks.
- Move `insert_internal` to `XArrayState`.
- Share logic between `find_next` and `find_next_entry`.
- Rename `XArray::get_entry` to `XArray::entry`.
- Make `load_next` a method on `XArrayState`.
- Move load logic to `XArrayState`.
- Use `PhantomData` to capture lifetime of `Guard` for `XArrayState`.
- Link to v1: https://lore.kernel.org/r/20251203-xarray-entry-send-v1-0-9e5ffd5e3cf0@kernel.org

---
Andreas Hindborg (11):
      rust: xarray: minor formatting fixes
      rust: xarray: add debug format for `StoreError`
      rust: xarray: add `contains_index` method
      rust: xarray: add `XArrayState`
      rust: xarray: use `xas_load` instead of `xa_load` in `Guard::load`
      rust: xarray: simplify `Guard::load`
      rust: xarray: add `find_next` and `find_next_mut`
      rust: xarray: add entry API
      rust: mm: add abstractions for allocating from a `sheaf`
      rust: mm: sheaf: allow use of C initialized static caches
      rust: xarray: add preload API

 MAINTAINERS                     |   1 +
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |   5 +-
 mm/slub.c                       |   4 +
 rust/bindings/bindings_helper.h |   4 +
 rust/helpers/xarray.c           |  17 +
 rust/kernel/mm.rs               |   2 +
 rust/kernel/mm/sheaf.rs         | 689 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/xarray.rs           | 477 ++++++++++++++++++++++++++--
 rust/kernel/xarray/entry.rs     | 378 ++++++++++++++++++++++
 rust/kernel/xarray/preload.rs   |   3 +
 11 files changed, 1549 insertions(+), 34 deletions(-)
---
base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
change-id: 20251203-xarray-entry-send-00230f0744e6

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



