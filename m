Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69887CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C4A8E000D; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B708E0005; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4E78E000D; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC5E8E0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 561D616050B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
X-FDA: 84029969226.02.1D6FB57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65E8D140018
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhgXLxWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238271;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01TF3C3IWbmDJQaVCIvSXOwIY4WyGGy+JpyFPRSFpf0=;
	b=mlqeuyXDmRZgjc678OhsmBRFW88TNsNQlxmOaAYRerRS7foQbbql9RSJs2O37Av/ZbjlVs
	W5yumHqx7yJwnk9FbXvOtVZKJ0MrKH/6fmeQycDhg/h/sSaLEiQ9ItgG68Av2VPTmU5M15
	hbbfniO+JpF1UWSQnGogjetfvRK7EVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238271; a=rsa-sha256;
	cv=none;
	b=7iQprH5aJ9tVs5e6Ou1lXKPRMlJaByzCablSj/J4sukSHoZ/7Sz/iiGduazzZCPAGTPUO8
	z8ALooXOke/ubkVp4ovdSUShCDPJN2GHoa3uMrM3WBPpIDBE5T1lJsxaLm23ZaPgKA4IF7
	bd0xwYoOGmdIX8tdWE/bPoKxy2UABec=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhgXLxWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 811AD640FA;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A77CBC2BC87;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238269;
	bh=B6oYBetl6TQXfW1dNsiK6ccjw9VFfFfmPrPyliUaQyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mhgXLxWJhri72svG2Hc0KLYaTzOBcgoqLjbpiKvHCTgPKCQBzpe/gugMsj5GMtbRR
	 og+DozbFFwWIcnU+XnmqaFy+vNCdE/oFvBV+XNzbMERJAwM+M8Dq+DNuuXAY/Bohe8
	 FyvPH5Hz8cUm1vymw9pbHGFKq/EgCpYfAuMW50fNZQogYIeCSFIWZTqcxDRBOh8Wud
	 NOYpCOlWUwlHzFn/u+tiBgRVlmmSTaJo3IWj2h1nXR5PM+cTe13pzWbP7HDv1OSBCU
	 g3frPbBBJik+Dz2m2Wv88BGmaN4uizo75ztnFqzQeK52YW47sP+UUDfUFt1QejbNxR
	 WVJOpSX4yh5YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C35CCD1BC;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:07 -0700
Subject: [PATCH v22 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-2-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=1500;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=onQZPDO/5PI+EGQWomoauY3V7EJZG9au2H7fkbOgnBs=;
 b=lvCMW0ZxXnLNDcoSCS0dz8sseZUUceYVdmkvZqQMJJflgpNFfv8MskbwLB0L1hPH79GvUxSuA
 GNeooInsBj5CySypZFtJd60V+L+u/LKByXjcqfUg69jVPSLgO7SjJtn
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam01
X-Stat-Signature: qr16nmx7inn159t9ck54isjg3knmhawp
X-Rspam-User: 
X-Rspamd-Queue-Id: 65E8D140018
X-HE-Tag: 1761238271-468846
X-HE-Meta: U2FsdGVkX19bswxgWpnrbnSqR8Owb9gkdfD639emXYqo4Up0jbcjbTJovjLkNfD63VX9bbQ5/KThQz50NAP+r1gMHCJolsy98rDlADOFtzhucrOdIlvMyOp/udU0D7+l+GDUTAmaUcTakCtcC7T7XPt7zL5tQWdYleQXOctiYtS/E19cemVMLEVtU5o2vh3rG6nPLUbJ87vmVIdPY+qNNJZQX53aiL9i7/T6PFvfFKljMxpjMp+m8rYs1adORCTgHz6H4+Q735sA9I3H6bnl4k0zirrtxIhRBtefdc+iL1mnLd8J6+f/0yvlWYXQ6raP3L743l7AXnJSC1/Up6wHavtHzlXHVoew/Qov9mgJbreTVeE/6pxk8Hv0lpvRbjnR+3b6IvD5ZwwKGMH83cQTQN259Z7ltZYSE2RqASUXYNVuS/xpCCDYnAUoT7/UOexNmm6dq/0nJakgOEPDSEbikAtu0ljBsEg+c762XUkSeUt0IX83P5iAiUZC/jI6y8iYdsRFxT+1yd4Mq5Yt6miQyMJFxKK6U0KTomrQe5hKKwYUrjO90rC4i6zgxDqXDnqero4FytBGKXxqYJaKdPacfOI+xWN4yaFvArPn17bZkSF13o1U1OVX/qNIgsVqbuNV0lP9ZAU23k1qx3ENXSTostGZlQmp/3OHOi9+Opb6ilVXGZ2iBqjSlc1TjNEt3yFr8cv0YHegqNo2TlDj8udLd714712wK8UihIf5ZbyiMtPffIskk+KdG8S7Ye7isdjGumTo5gRcEilcFF1Y9PQDvwHHGInDVzZpRQ72/1h3Mh8IMWlewamnBXJqSNShea1vXB43NQJwGO/rPZKTzqnpizLRPHDCTVeN5QkoSuACRUwUonIKOgOkZhwT9ReFsVb30DPSYdfqcD/2MA7lUt4C5njdEVA+Si86MYV42jjI15Kiv5qGeOk3DoOieqKcVBVSvndKLFOQs7NzgbZYh3D
 MDSo+5I1
 HRcFScT3VPoDNNWUWSWvWnaFZPFfV9DEVXyTDj/eNg8yc1sV2aWJs5R7CAwqSUveQt5bRC1SZA1V5HT/xgLTGwicfJ41WQ7VJI84JY/Xj35iCI06HcUuX+zsTyEPc9fqbBy+mh14TNwzp8erl+5/rqvF+Sq9MCjRYKmw0NYrW1en7nKFRTNHIuwL9OrubthXPcJSj+AXhw7y6EhUngNGXPGsp8BFCzCEHmguOZnACCKS0pXK2W4ru73Z4AAMgS30ihZ/ARIamm/xfaANlZYBXsCK2AKB9YdWZGjMQo4QX2jPG2QNWylwsPqQSJrlvWnMzr9oxKMdQ7oLwCylWl0hClSXSkDBA0KtKZLiIAbOvUiFsKa4LlO4dq7NMQp9DKkX+LZWbJyhTFQO3k5S/4+H2lPOvH1dWJ2jdWW+KhMs7mXZzzkzEZjTuV2XtfYwAA6r8d9p9bm6WJIAAgOUe4GES77Z8u0z/Dai9UtMgu0XM28PgQqJPjCBcPuJrZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Make an entry for cfi extensions in extensions.yaml.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 543ac94718e8..3222326e32eb 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -444,6 +444,20 @@ properties:
             The standard Zicboz extension for cache-block zeroing as ratified
             in commit 3dd606f ("Create cmobase-v1.0.pdf") of riscv-CMOs.
 
+        - const: zicfilp
+          description: |
+            The standard Zicfilp extension for enforcing forward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
+        - const: zicfiss
+          description: |
+            The standard Zicfiss extension for enforcing backward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
         - const: zicntr
           description:
             The standard Zicntr extension for base counters and timers, as

-- 
2.43.0



