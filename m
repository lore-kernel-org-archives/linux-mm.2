Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D672BCD3445
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475C16B00EE; Thu,  7 May 2026 19:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0246B00F1; Thu,  7 May 2026 19:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1566B00F1; Thu,  7 May 2026 19:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6EC56B00EE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4CED1C13FD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:04 +0000 (UTC)
X-FDA: 84742226688.16.0D6A753
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf14.hostedemail.com (Postfix) with ESMTP id C6EE510000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=AnYlSpPC;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf14.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NLY72APnZcOWaicaOBiY0/NfOa0z6RzbN6RJkb//zI=;
	b=kLB4Vzjc7tDGVg3Z7P2N9jUKDmqG+NjDs88W9yS8r4oyMx6MnWKUGUGBf6sbXliWpqN3ZZ
	1VY8Jii3FcpPv198Ah/lwKzGnx4Ec3A0cG+GOtL9kyb/dabYy0+X44vx8XtWw7Uw7wkt17
	Nl8UZy7HoTICnqcHLFGDNNq3SCyOCKo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196783; a=rsa-sha256;
	cv=pass;
	b=2yjpDog2sjbXLFxpav2Rnpd6XLPl1PH+cDaespyRkWPGRK/qeds9ij0QcmEyy5FDJzD1gp
	5rfomIPO7U2Elo+4lbS/eJOWXW6ofpuyc5lJMVk5E0inTm+jdRweuuTa2Do+ZOuEAiFO5Z
	atHMNljyaXmfQ69YJOlAdVt0qcpO7OQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=AnYlSpPC;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf14.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1778196767; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Z14Bj7DC4eNrGghUKaej8B9EyEr6aJlt54767kgVsjfSY+v2GDWo9k8q6FsodFpj4l9iPm5qQSZVX85Im/soanzyiLO6kJFvp6eO+VogOyV1Texfns6ZL641RrP8cKAI+dawYBoTeUbPChH4LCSt+DQkPgyDwr38LXPMJLhvC14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196767; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2NLY72APnZcOWaicaOBiY0/NfOa0z6RzbN6RJkb//zI=; 
	b=FPH9RnopzOOqgfTnfQDFSN4/2l7YcPTesrNrf1IeboROfmxihJYy2K7jvqm3l7bP7VZENSDv4qfWNB4ZZydkjMxmF5BIrnti+SJXTjSYfWppbS7AEpx6ipkoLjQ/x7Q3Uh3oygKhHGJ4u26vFnw7PJEACrNqYUFyGuwkunzWX7o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196767;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=2NLY72APnZcOWaicaOBiY0/NfOa0z6RzbN6RJkb//zI=;
	b=AnYlSpPCYOmyvmVegZhccULOjc6A2OXwMe8xbCFeG38X/bF3Fqsg9Z+zs/a1YN1N
	NSFJP425GMy3csNmJRQWRhMwkpMZQ3mbCXX+CYg2LxAyoCBlD2LyL9QBbOgX22fqhhW
	ylHSREN/6DCqlyAqbkth3SlQD77kCVRf4yhGz+o4=
Received: by mx.zohomail.com with SMTPS id 1778196765290540.1630003755475;
	Thu, 7 May 2026 16:32:45 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:40 -0700
Subject: [PATCH 2/7] mm: rust: add VMA page offset helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-2-eec048a23c25@collabora.com>
References: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
In-Reply-To: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1487;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=3UoXpSu7KF/dfK+s5Hc4A4XTkRi7kKOM3Xgjk6aPxIU=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSVdSlzlPubFRC68xhprNO/CTfev10TqDBInbAx60
 H9OkiO9o5SFQYyLQVZMkeWsvVGPeNV7I935/5th5rAygQxh4OIUgImUVzD8FZp34dVrmzN7FnIl
 Sn4t2RFUFOJYHyPuGmgVquC370vJNYZ/moq8NZdWCZhl3TqZODlFv17+1YxLc3ZFbV9rlaV1/eI
 GBgA=
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6EE510000D
X-Stat-Signature: fkif76nh9i7zp168i5yit74dkrd5ib1y
X-Rspam-User: 
X-HE-Tag: 1778196782-546314
X-HE-Meta: U2FsdGVkX19RFRvwjr/unpwimVjMgLuLCcJjUluxWEgS5YhzNCGI7p9rykcbAwrXoVcbdcg0M/PMTYpKyIb0i69f2V9KVIcdbYuRCeu2/euzLsZz1jA3pMMpKcJyRux93J5Ph+fG1RPtbPcnIAsR2x6EmUzAs2yKy16WhBr/0HSVQMsmUp82wg/jfCelrXux2GIezJAQzk59bESvybJDQtEnNpebDDd4TyjN0HOnv+0F4NdZRKyLJDPvqnsToo4lnxhHF+AQ0482FJ5XLYv+PeVdtpAklErykQPYfoZ6NMawEvMaxjt9sfEvSLz3ebwOoMTrtgAzA4xuxYozBbpa1n9jTjbQInbHeqxw/y/+tolmecevncE0Y4JhGVJgS17k7QM6Bjhxr0Peuc+AJlUka+fck0rP6TDEoIjFOCzHN0Vtv/zxig/xsC8FouFN3T968wJ0OPMSvDltp6SzLKsdCNDx3RRvKJzx702QlaU2hVI2+t+TYeaS6e+u6+kK4AU6JL/bSVuyLLaPA7t3Ei6a6Y49PV23+/o/K2qvQaRgHiQOWAnLn1DSTSRMK2uWfO6pksZedu634hbHreGQ8kdSd+S+AGtLb/xCpaQw+nngn+WYch5JJtAieO71edicCOxta+QWE9POvCQXMXVvcZoD2roRRkgAZXwczd3GjwQsLBKbppjE4YB9L+48+tsgFRv7VxoAAQKxmYSqnKBJ1rU4kMWV47NZ+1hL7MMZ4j6qzhQ2ZMzg8VHbDvQK2IB0DQb0l3fqqyyloKkRa5TqGGBbBY9ftKx1uJ57G+ekNYEGEa536t9rw5Dv9YUXGU9z3hLln/W+UMrtAuI8cygbRxyfL4KSfzKfNRYpiPZ6p4LomOhJ+WNBvWuclf5L/W9qSPyoTRAQ7R6Z/wQjX+GdHTm/7d0m/p2v8svNtUswYVhZtzOViJIIleg9s3zGKXK2Qo/o13TcusschSLc8JQDf7v
 OwG5Et92
 1EmLP3rMODw41rULuWyzTZ6xC7tpMkHfIzW9+VufBwDpCGh1HWJoYkiADbY1QNlGU2IVYGkkD3UIl5g+vOMdbmI2pZyYJH25ug2FcN6I28eZG+dNW1t/tp4k3elwyQz+8uUqAcas2ABYm0TyJrXPHdZPlnYves9GWq6CSU6ebaiCQzznIr8h9fRZnRDZNjW1+irRp7ll6sEJDf+nU47Rar9OweclMaRPj0vAfGAEJz06SYnnb3UkuwwQXnQsXcGXsyRRYvGwEmz1/YsTyGV1tXavZsl5WLTSisZq9J9UH8SWhwEzhRsU9ByRNfAT8maB0jLa4AEWfgoU/G+6cM5MBOuhV94pV7lByZVDy2VAbzMeTl0QNe5ayXgXatqe3BxdQkdCOY+eGnsE+sJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Daniel Almeida <daniel.almeida@collabora.com>

Add VmaRef::pgoff() to expose vm_area_struct::vm_pgoff through the Rust
VMA abstractions.

vm_pgoff stores the mmap file offset in PAGE_SIZE units and can be used to
distinguish different mmap regions and dispatch mmap or fault handling
logic based on the requested offset.

This matches the existing start()/end()/flags() helpers and avoids
open-coded raw vm_area_struct access in Rust drivers.

Signed-off-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 rust/kernel/mm/virt.rs | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 63eb730b0b05..cb670e9d5fd9 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -92,6 +92,16 @@ pub fn end(&self) -> usize {
         unsafe { (*self.as_ptr()).__bindgen_anon_1.__bindgen_anon_1.vm_end }
     }
 
+    /// Returns the page offset of the virtual memory area.
+    ///
+    /// This is the offset in pages from the start of the file being mapped.
+    #[inline]
+    pub fn pgoff(&self) -> usize {
+        // SAFETY: By the type invariants, the caller holds at least the mmap read lock, so this
+        // access is not a data race.
+        unsafe { (*self.as_ptr()).vm_pgoff }
+    }
+
     /// Zap pages in the given page range.
     ///
     /// This clears page table mappings for the range at the leaf level, leaving all other page

-- 
2.53.0


