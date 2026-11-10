Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2353260A262A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CrmBV/WD
Received: by kanga.kvack.org (Postfix)
	id 372036B05C1; Tue, 10 Nov 2026 09:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3495E6B05C2; Tue, 10 Nov 2026 09:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287456B05C3; Tue, 10 Nov 2026 09:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECE7B6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:45:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CCB9A093D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:50 +0000 (UTC)
X-FDA: 85419483660.02.7178677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D1A840007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CrmBV/WD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R9lBEoIWVZ1hq7v8fJDQt0mB70S3ebuyMNcxrw2vw24=;
	b=K94CqMztAM4/UESf703PY7FDIpDjZp1A9FiIZb5QKK9Fe8ihsx2ZWgnhhDB11Y9nIR0UH5
	078nmMD4fIszcOgmPQw9+HuVMi6YqQvt7nUW4EiOj6fSH95L0s8NWX3BeUchSV3CHFA+ot
	9G/kZOb+ny+Tj9TqiqnvMXj/XuuAD9Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CrmBV/WD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321948;
	b=xO/idt3yRVkHx05TlrsBIR3SoSeBSZSHc1/yEqPMUOUUAVe9J6315U2NoLRtbyhQIlKZnV
	za/7mqt9STRBQdLKwWvTuD15hPhWNAmL7IO18sh7wurwalLdgvPLutIGpjZE3WxdRMNzlV
	yaCXslfT9ERen1GAIV0xiXAnUnX1KVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA79845EC8;
	Tue, 10 Nov 2026 14:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF241F008AB;
	Tue, 10 Nov 2026 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321947;
	bh=R9lBEoIWVZ1hq7v8fJDQt0mB70S3ebuyMNcxrw2vw24=;
	h=From:Subject:Date:To:Cc;
	b=CrmBV/WDDK8s7UxUEco04Menz3UIYnabxTXaDbMSrbR0SKNsyJ0WadwsoNIU3JuVN
	 HpJ3q1W262L4Qs/2+dmakPhpJ0JLP5TWa2+EXLwNfzVBQFRZFKO8Q8LRFe/wdXdQ6s
	 U2GVUzu3GxqpHqTE+jDXBOej/b6lNgvFfGHXJEoUf5dcCTrcewP948gfK8gmL68xB2
	 2BleWlGDj0aI3tCGkS2cn06GHkojl7fgrokDvCiXbZNgGS0/46b4adQ9n58EzFwS1+
	 lHtvt+a65Pvmf269FpQdTNQZPPYHHiGribnwyrvFywjptDZ1yyWmxYSQqvpCTfzVda
	 QPgT6CBFIbTmw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v5 0/4] rust: byte-wise atomic copies between `Page` and
 shared memory
Date: Tue, 10 Nov 2026 15:44:18 +0100
Message-Id: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMIt82oC/33Nz27CMAwG8FdBOS+T4/wp5bT3mDikjQPRqgalK
 AJVfXdcLmyimnz6Pss/z2KikmgSh90sCtU0pTxysB870Z/9eCKZAmeBgA6UBnnx3NU8+GsaeJk
 l2Bhtay00QQs+uxSK6fYkv4+cz2m65nJ/fqhqbf/BqpI8bdRB0z6is18/VEYaPnM5iVWr+BJQ4
 YaALHjt+q5tgrI9vgn6t6A3BM1CcGD2TQcmGHgTzEtwYDcEI0ECoWpC20Wl/B9hWZYHqP1u1Xc
 BAAA=
X-Change-ID: 20260130-page-volatile-io-05ff595507d3
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3532; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=YOVunpKh8rriMHxdsM4btTJnoAAZxpp6z69TlPOEWpw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq8y3JUG0x1nePgD55NR6MXTFhwklev6GpT7O63
 jSLg5bIyAaJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavMtyQAKCRD6UCkIqsW9
 0AOyD/45gUocLa+Lkb1gFgkWEP2yD2p6y0Pz+rdDUBXXjQDs+HePIJeJMsF3xvvVj8DQI20ZkBl
 GFVSfsQsMDw3yWtNCs13S4MIu4crVcNdryWmNUW8q7X7DB81wNJDWQVj+nFKjBy5u86/gXgW5jl
 2ZPm1JxnoRpdI7AIOIAZ0bc/qBlSxFSfHd+rGDNhkrjY8/gMDih/qIxs+W8VnU3On9h96RebNjm
 nG2u8Nrq/r2YYbm5U5kDlXN9kEDZKp3LzEFPkjUlFy/WH2MB+DO8lbc1OZCVLuPt2IuwO75BpP8
 8L2oH+shax6LvpS7ctTBELUHEFLvstzkG3G+c9dcHeLVwtOS+txAoueU819rpDYI0j0B9UdHROs
 WbC5w/HCC1J9p2eqaWMik2SwMiIZOLNkmoMfesOUzPT1RBsTMOJsTK2TjbDrYxu6KUNvccg7RZw
 m4x8laMxeVy7jrizDnWomsRPsj2Ojiut4DHpkeplcwq3W7Cwtjpf2muyeCIs08DZICw/r8yMnWi
 uS3lIpVwI79gBJs2bhBNAAhl7FsLvjD1om3Vlqip5+9rtpimPVUpnFtgASnJhfHzjoy1Q14RiFL
 9EGC0NWji7qL6WddMIch3gExiqXyMRRyqeSXjY/elz8vZxWazOzi/5oxBecgp6I2avTAsko2hXA
 L42uTiv9se6aarA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D1A840007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yeiu97ghinz1qpyum5qbcatroecq5qwp
X-HE-Tag: 1794321948-338305
X-HE-Meta: U2FsdGVkX19EzrKyK7bBywxr8ZKlsiValm+revFGuG3bpjwdIPp54qhn9neZMd63w3ZZhF3uGBi4rH1WddJyNDSxYvvMRxT/NU2KJsw1nMMK61mu5+0tkP2HxyGJdaNf8RJF6pwrDEorSgwfehDjMgBFYOwp2/kv/+pnhEM+HHZWYgzo4MI4zYmKLCGfAM2aXBXVDTMTdwpMNkHOjLk3i+VqZProP1xncXVxXk61uzK5Cik4y4JrBeFhguLMk320rYvdF7sr5zK/mgRggOa8jscqV3QD04zOqV4mm1hRYuLDc+O1tVYnOV2TuZRObk8gdF/aCCTvLjvD0qpsD6jkWWU3PIoPMY0PSEE3QvrzyZHFArZUTLpLvJ32UzUJ4sLPYCrrovem0fWy4pZtd3Buq8ouVTaSG0atKUthgp/bp/s1ts6P1Qszut/gNoLcUAz+CXs4rW6jSTplGdf7oqtm0KUuXrgpql7qtUS/+VnNqJu6vCss60JopUNS31WKiQbiUBGBWBcbZ3TmZFoMXpyyy54vuX4E7QiLk9xXsP2rj1CwNm8kGU7qg4D0dfJGkWiJbfj/Asxf7lQkIeRia9YqzYpzx6NdZJYrhAnYwstNp9SOTSjZqXwjDEMqGJE3nDQNExUOqF830ovSksH0vfE+G3E7UoJoNh/VZytXLOIyvfcFyuX5fEwCmniTCw1qNoOPJQj05xTdBWRlAMfwhbSUlpaZBLxq71poEWD8xW3JdXAADXwpcZxyrRBtutTOtXL6Ggya/GjkW5f8VzRsIHKImWGSUQbpXfFmtIdewZVw6+8FBO9bY7I2dD0RnBsoUnZK3ri0j6pmxJht+ebW9p2T+4fGlo8wW1AiTrk2XNpc+M3Q0dMjlW4MOhhwHSDJYcNvhzy38CA5DbhVZuVaHzsgVUPceCp3Nhk4fVlHyKuUu7zRWgrUQ0nmVhP9YI+ACaa9WxrfkK1WFGh9PQ1z+2Q
 7g/0P2hy
 HGNPnK+EB2t+T9Boa9acXwxrc6FzEDNI7LVI5iveBzNCzdRDb0pmwONGHrfEsVnWfF5minSDLwtt2OUhMjUK55YQwWZ3fJE29eTmfpPuzwwWJnEnWBk2HakLYhlwI+O0SYCqizMR3LrjPOUroSpsnEMOX9Y+Y3VK6zhgeHNFlKfHMeQ+2KzaVnMxS+mWp11nXbawx+C5DXdDCcvsaZJV5F5P69fdIpn+ekj+129i7URpW/IqVTBjJLwGy06LgzLnDJYtDnWfOtVfuJTKGwfp1/rTLlZN82+X2bThuJN5m7sqNETcbDAqGon32HN0phG+1WFpA2ocFjfd94m4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds a way to copy data between a `Page` and memory that is
shared with actors outside the kernel, such as user space threads or
hardware, without introducing a data race.

The copy is built on `SysMem` from `kernel::io`, which already accesses
system memory with volatile or byte-wise atomic operations. The series
first makes the requirements of `SysMem` explicit by requiring freedom
from plain accesses for the lifetime of a view. It then adds
`atomic_per_byte_memcpy()`, a wrapper around the kernel's `memcpy()`
with explicit safety requirements, and routes the `SysMem` copies
through it. Finally, it adds `Page::{read,write}_bytewise_atomic`, which
take a `SysMem<'_, [u8]>` view of the shared buffer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v5:
- Rebase on v7.4-rc2.
- Build on `SysMem` from `kernel::io` instead of adding raw pointer
  based helpers to `Page` (Gary).
- Add a patch that requires freedom from plain accesses for `SysMem`
  views (Gary).
- Route the `SysMemBackend` copies through `atomic_per_byte_memcpy()`,
  so that the requirements of the `memcpy()` call are explicit.
- Let `Page::{read,write}_bytewise_atomic` take a `SysMem<'_, [u8]>`
  instead of a raw pointer and a length.
- Drop the claim that `atomic_per_byte_memcpy()` is volatile.
- Add a non-overlap requirement to `atomic_per_byte_memcpy()`.
- Add examples to `Page::{read,write}_bytewise_atomic` (Alice).
- Link to v4: https://msgid.link/20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org

Changes in v4:
- Split `atomic_per_byte_memcpy` out into its own patch (Boqun).
- Expand `atomic_per_byte_memcpy` documentation to explain the
  concurrent-safe semantics and to note that the kernel's `memcpy()`
  uses byte-wise atomic load/store instructions (Boqun).
- Clarify the src/dst asymmetry in the documentation of
  `Page::{read,write}_bytewise_atomic` (Boqun).
- Use the "valid for atomic {reads,writes}" shorthand in the safety
  lists of the new methods and of `atomic_per_byte_memcpy` (Benno).
- Drop the redundant data-race bullets that v3 added on
  `Page::{read,write}_raw` (Miguel).
- Link to v3: https://msgid.link/20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org

Changes in v3:
- Update documentation adn safety requirements for `Page::{read,write}_bytewise_atomic`.
- Update safety comments in `Page::{read,write}_bytewise_atomic`.
- Call the correct copy function in `Page::{read,write}_bytewise_atomic`.
- Link to v2: https://msgid.link/20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org

Changes in v2:
- Rewrite patch with byte-wise atomic operations as foundation of operation.
- Update subject and commit message.
- Link to v1: https://lore.kernel.org/r/20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org

---
Andreas Hindborg (4):
      rust: io: require freedom from plain accesses for `SysMem`
      rust: sync: atomic: add atomic_per_byte_memcpy
      rust: io: copy `SysMem` with `atomic_per_byte_memcpy`
      rust: page: add byte-wise atomic copy methods for `SysMem`

 rust/kernel/io.rs          |  72 +++++++++++++++++----------
 rust/kernel/page.rs        | 121 +++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/atomic.rs |  35 +++++++++++++
 3 files changed, 203 insertions(+), 25 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20260130-page-volatile-io-05ff595507d3

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



