Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A6DD41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150B06B002D; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8306B002E; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE09E6B002F; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBBAF6B002D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A46D12E4C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:19 +0000 (UTC)
X-FDA: 84207856278.23.0548AB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 792AE140005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4GgnHkt;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iECMerTAUVLGlPYW00F3cIDorrFSBKHkEEaZ/glZpso=;
	b=OwWT+cFWrdmAoLe15dz/7xrvnTf5eDoWpaaRqcC6R6xepXHbIApJPZ0XYhxY090ELcpRqm
	uoat0F4CPX+6vUGVFC4nk7atOhQH0Gxp9cUBHjxVbF/hjbyewhyxxhvMHfeBX/G9dOTsa0
	xfmFyRyyvW986Ppc43gt1ZnvHzYNQyI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4GgnHkt;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473677; a=rsa-sha256;
	cv=none;
	b=MUiAlqL34apDOCjaCb+FBzj92WLZvj1I/BlFidkJJdayHDSF5xhFFWwjdOg8Jlhn8jpumX
	T4JI7L+YTCTcgpyLhqB68wRbjKXRwTabba/+QRGkRZhKN50loqZmL0MOybUynCdUmrDNhO
	aTm1lyFsPI1sOMeptlceB1TtSM2ZIF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFC4944541;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FB53C19424;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=ly/QAA/61Anju/BdG7scvRW9qTC7lOqM9OgO/9B56Tk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m4GgnHkt46O6ubOxKQU7DnKUkdRsZ2EgS0hvB4i8Yl5PxegPy7dfAh4urscTmhOD6
	 v8ws+ql69frGc02Gjl8qvxwIhM6Tf9fWHRrinuJCblxh8bQYAgelSRdJSanazZAWZJ
	 8AIJRaj8aZH8+OR6zd75fQcn0t2fyxYG2oeDNgiaViCQBcl8tVXyBbkT51yHtytFwl
	 oVct8RkZ3ntsT4OSJttkTaYvAG61Tp0ozMZ4lUX/QbxNhGymbJTtc8fVZGIGb/q992
	 zcnW7Cwoxzp+KSD59uOGbQsi+011QbMpU7wXCMfBnxPcOClsBt62xTOo29shbKwgSO
	 kMQPIO/VWcZRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6DED41D6B;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:53 -0800
Subject: [PATCH v26 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-20-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=1494;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2JmRNzctibGknEiF/lJdumXBjnp4QWFhVuzyNKM/ZLQ=;
 b=KE1lLQse++AzNr8bFe7ngbv+UmadhK7drKBY7sWZTlFOOVqQ8FXrlU5d0owmEWV14WGj+kg+4
 gdfbGv8KPbXDdIzREHstiHYH8xcvl8Ys2gwEpXMZ43pDbO4S3lb5OWq
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 792AE140005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Stat-Signature: q497fn3indhd8mnnm9iw7fpahnkrtxgs
X-HE-Tag: 1765473677-754680
X-HE-Meta: U2FsdGVkX19lHAqeEapaD/28bXJF3y9+OGR11mrgnx8ZUfegoJReviD/21q8oBWp+qTju+ryIGtDdduDlUxqthwPHvbUkipvuT4HBkvFGwblQ2SO3DdxJZnHyWnRFJCwFAb4WKAvEQGJmSyunAn1o8+yDLYSQc+vNrUfV4I3/VbPeQtUaFkPRINNkqatvh4JyH899XuGuigJ3OqMoxyurecKn9UgdO24g0sLqt9UINxUJcbPupqANjyVsfqjTzISwpLUH6Tm7EZCXf5yl8Fza21HSUTznM7RKIZdUk98fqUYdEjkCfoZlBOQwwuKA74226iSwHYKb15jQYaujDU0ITO7e8Gy9/BCe8f+Dllje9W3JywIkdBN9+CGptzj3nFD68NoxptmZ0ZnqspwAECQEPmJijgSHrxnTQ7LLuXtg70715bFouvGJzMttIgZv7Q/Kd777ZMNQw1c1C3ZoILLo5il3FN+zcmnuXtT+rQMoV6K+VWOAWUps/FwqExOun5qiQJHz1+N6cuaVadWlRfO7LVblniZ4fL0dB0TuUaazIVtoP8NxDNAtgXACykZORYz27+wBCf7cirr/oDNIcNGuyQQYggZZIUxgvNupro/woVFyA1JvtGrzye8GwoogY9ozaa6yDKQyZHDx8ElfGLtZSYjYn3Kkndwmg/e9qAEcsl4oAQ/pwCjCGLT295cmyQqaFQJ5Pkks2h+T1pDXA9Zfpz4VBagA0prvIC978dWnm28p4OcY2T5DpnfZ5FrdU4RyWYhE1gwo7rsNFcDV4cBEpBWdlqoz+eTYhiGBO0wy1Sez8ltWb7UlXihv//O/q95QB3nVGPqBuoajFwJmBwfad5d+Nas2O7sqmMgc36BJuwcwRRiSIDKfqNJWkJ9X4L4pq11bhD2Bx4565MikKhoeHbKFPGKocsoCQ+gwGBSrnAwc4r4BId2M/0NojDTS/35ycmTIPcJhFruyxqlqlh
 SqWEQZnJ
 I94gRcU2h7QVMPxTWCnzkVnu4sEbVbFNfOStL1hEYGT6/P+RQX3BoaeaEcyRHP8d23ox0b2EOmEGJtTvUKQeguvaCXq6E8iRUfG+ZW8/QlsbUEWytlDSlIEaVnkYLo3q850eJ5R3YWwEWUaxxLDeUljN4BDIaPV/LCiUm7V+hQIH6MKeSfaf56wgFStG6MCntRK9VMSgoPgEC9tG74cAHkbnchpPpnwAD01x6ot0lfokPpE5KMypIl0rPQ7NPT47aSTJgS0etJ05pW06u9pLOBmsFXdBRpw0+9BXL/QS848OKCJJarVC4AQpdGqkq29vpu+PhS+QFLW5dmN2VPLeNlPK51Gsyt7my5ZitQIO0+c8ivI2CTTERFFFQEBDh8PY+Ox25q+MlcZp62UHxA048R59yu1UiKd48dv9hOFWExEu1x1FN+X28rWA+HmBoQYuzdlfrIKVNl3M3EJtjubfeAn5yHDoQ+sCJFtGOEnTNnzyi543lLBm5bsQaP6Zm1ODYA5+ng7Cd22ZHhXtswxFgeM7tF5ZPPVSef/uLYsTw7fHxqrH/5nFxutTyJhSA8H/TCSc5WZSpFqynvS8RgrJnrSW8A8DQ6gl48Xmj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Adding enumeration of zicfilp and zicfiss extensions in hwprobe syscall.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 5d30a4fae37a..0efc9c7d1199 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -82,6 +82,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZAAMO		(1ULL << 56)
 #define		RISCV_HWPROBE_EXT_ZALRSC	(1ULL << 57)
 #define		RISCV_HWPROBE_EXT_ZABHA		(1ULL << 58)
+#define		RISCV_HWPROBE_EXT_ZICFILP	(1ULL << 59)
+#define		RISCV_HWPROBE_EXT_ZICFISS	(1ULL << 60)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 000f4451a9d8..d13d9d0d1669 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCMOP);
 		EXT_KEY(ZICBOM);
 		EXT_KEY(ZICBOZ);
+		EXT_KEY(ZICFILP);
+		EXT_KEY(ZICFISS);
 		EXT_KEY(ZICNTR);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTNTL);

-- 
2.43.0



