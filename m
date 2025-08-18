Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A486CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997D28E0010; Mon, 18 Aug 2025 14:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949888E000A; Mon, 18 Aug 2025 14:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886AB8E0010; Mon, 18 Aug 2025 14:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 797068E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:09:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE9F9BC33B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:09:37 +0000 (UTC)
X-FDA: 83790665994.28.3D86F34
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F5BB4000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:09:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8w4fxGe;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755540576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NoXk6wF4upM5MD1NxJihapZyhfLfld44JaMEonFugpM=;
	b=FqxGpGqX7Frl0Xi70RjWp/gUUuMoELm4v71CkbYd9cGnHef5DJXNXBvmd8zDBFWPkrbkfv
	DX+34tWVqyLZvZEM5hgEGjTVSKiw7t7jcEuskuR57BkdfNcebmwPC7qCkXa/aDRjZ2ScKY
	uTJ7Z5lEFmyRRO590rANr78nYh50gj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8w4fxGe;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755540576; a=rsa-sha256;
	cv=none;
	b=Tb1h2dpcCvz4PamatoHMJJMyDnFQpxWgHpuYChNv39/mBXe5W1LkAo6j6GDlXH52x+kotO
	0avYFUCXUNkmjl7YO4CTcoii/vvPH1cFCDZxDQnqhoHJUeYgRNNtUkv9V5hMCOuhKe3rjg
	3yeA2miN902G65ddN9+fzwAREE2a7QE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3E4BA5C61FB;
	Mon, 18 Aug 2025 18:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1F6C4CEF1;
	Mon, 18 Aug 2025 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755540575;
	bh=peVRwFkAy4cd93RYyjqqMQI+CX2IJLAUNljDQ1sWf2Y=;
	h=From:To:Cc:Subject:Date:From;
	b=G8w4fxGeON7xzbM2S5DvVAZO9YhdnhUbyYeKhZxkXko7lGL1RH5A3Dlisc/1GpcgB
	 rNgrW0rDLKxofXJj6LFAN/D5MN/jWGwSsP5QUyDnCT5KNHaG2QKduzOh9sqtxfA7TK
	 3nNHRsRmPwDYnBNoEgZ4KBLKsy/nDQbBpPWgsTjG0VjlkAuBzHpxRTuTq6+7cS0z6S
	 qlFHwpCpv8ZT79NEPKg5TIkYI/FUM6D7dDFRN8005kdgilU6PiONI+1a1QPgAGcW5g
	 gLx/T1Ay2qh7XiXtEGYmf/hWmPPMmUKg8ysg1FZcWN4ZyMZTzXH+S3DwbpRmnTFTMd
	 H25e1v5RvGYHA==
From: Danilo Krummrich <dakr@kernel.org>
To: lorenzo.stoakes@oracle.com,
	vbabka@suse.cz,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu
Cc: rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	Danilo Krummrich <dakr@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH] rust: alloc: add ARCH_KMALLOC_MINALIGN to bindgen blocklist
Date: Mon, 18 Aug 2025 20:08:48 +0200
Message-ID: <20250818180923.192042-1-dakr@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gdn9tugrrkufhct5wb6jz1gp3du6yydj
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F5BB4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755540576-742927
X-HE-Meta: U2FsdGVkX18c2LHjhNy6WoxtwTPkovWDhu69GCHXgdk1cPezshdQ1GBZllz0EUymbey9gw7n9uYvSY4JJpQTK/DjuDvRXFF8GPXPwXJOin52NgTa0ygMjiFcX1r86MvCzPhIHBZNgDX8AGgU/y3EgUKnovYXcoXGdaALz0t7S+wvjr8v90pAexpZ9T7j8Iw4Q9oDgtq6mLqOSgzR9h//GxVjJZtx2P/f/vJy87v9goZ7K7/QcB6TYJwFMVBPw4269KTbbgJ5oExVjgXSqtO2GnxgFpRb5fOxcyI7ioFfQZoEc/MTfZlZiqOKAttlpPcrA7Sa1uZWZx/aPwnJj1iyye/FkxMZSLBqJWbKEf+KAXzEsGqYmcKWI7ntDP+vRlvQ1ZRrmOkVjdeILEY7rB2onbqJGPUCFwsOXc9cO1gb8qHXWiTKenGOIxLIJclBA/tg0Ru1aSoOr2Zzp6bOUIc2KvMWcMA4SDojOqTmFoM5aRJzzmToG8ryqA+JktddTi/QMSU9FEPCuQJUZaBSKuoPGWvdvMP3UJwsSCGlTRS1LF6i43n46ctj30o3MVI2wQPbdRDoV1b0O2wa9fVEW4C++UOzL5rUtiYcee/yZJwNL4ts2CdBA8+hSNSHt1EOOgsT5k4LYK7xPN8hJ5dR+VHUmc+IhEIf4w0BJZV2k3/Vm/BCH03zWWCgWm9cWzo2Jdl4J4KChjcWKFMlwwsXcf0pTS6POKbr5rx+e6ElhrA9O3uEq7gwLWeS3ZYs6qdJPnL3qbNG39zCTRSox9GdlUJm3rAry4nZ8n1TkIaIL7G7TA8Tt6eJhaUOxLGbTVvYNMLsRqqAi6s4WtMbxqYcAMJlw4VRAmY2rXrw8rpUTIZMJ5iYLzsbvNi2LLJWmUd9aYRSXBC/P6U3w3BOgHB4IvYfduBTn0kWob48fMW1C39vb7EjDiL8YZXmxE/pAL1kIojmz/OoqQbt4A0+p4ksKzR
 keVSzgHG
 6ecipD8tpaGjbSStCw4Id0Dg6NWVuoC8XekTVHMrFJlOX9QyI9sfUzEtv1Qr4vhgvUOhs6fd+6shauCRVAMhs6qKWpwuhXFymVsfoGDBCKtU7DuFbE2Z/iQ29pQPUuRxiEqqLNMPxt5fu3fAJaNn1nZ9fQHX1zlgvSXAQWIs3csb0qEilXb1H9PtEWY98zY10Fqi0oDOzEpSWYHVgBfIeXtfZ3EgzaxsCRjY6XLNYCEEsIjye1oTNxy1fK4L9yIIKcEqBsccz5wjHmdf4oQ3fVg+DbtNCjJH++SH9wHKw24BCbxttwemnaU7MpuiDJfZ1QZsimzmXmjo7IQe8fJgHH35UP4phFZXqYAaUNuhMy2A31zQq4zGXLqkVcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For some architectures, such as X86_64, ARCH_KMALLOC_MINALIGN is not
resolvable for bindgen. E.g. due to being defined as
__alignof__(unsigned long long).

Hence, we have to create a rust helper, i.e. let the C compiler evaluate
the expression and store it in a const.

However, if for other architectures, such as arm64,
ARCH_KMALLOC_MINALIGN does evaluate to something that can be directly
processed by bindgen, we end up with multiple definitions of
ARCH_KMALLOC_MINALIGN in the generated bindings.

	error[E0428]: the name `ARCH_KMALLOC_MINALIGN` is defined multiple times
	      --> /builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250818/linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/rust/bindings/bindings_generated.rs:134545:1
	       |
	9622   | pub const ARCH_KMALLOC_MINALIGN: u32 = 8;
	       | ----------------------------------------- previous definition of the value `ARCH_KMALLOC_MINALIGN` here
	...
	134545 | pub const ARCH_KMALLOC_MINALIGN: usize = 8;
	       | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `ARCH_KMALLOC_MINALIGN` redefined here
	       |
	       = note: `ARCH_KMALLOC_MINALIGN` must be defined only once in the value namespace of this module

To fix this up, add ARCH_KMALLOC_MINALIGN to the blocklist of bindgen,
such that we always only generate the symbol from the rust helper.

Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
Closes: https://lore.kernel.org/all/8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info/
Fixes: 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each allocator")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
---
 rust/bindgen_parameters | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 0f96af8b9a7f..02b371b98b39 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -34,3 +34,4 @@
 # We use const helpers to aid bindgen, to avoid conflicts when constants are
 # recognized, block generation of the non-helper constants.
 --blocklist-item ARCH_SLAB_MINALIGN
+--blocklist-item ARCH_KMALLOC_MINALIGN

base-commit: 7e25d84f460c59322bf01dfeb1fb4745b488f714
-- 
2.50.1


