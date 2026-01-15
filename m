Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCFAD3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757A46B0088; Wed, 14 Jan 2026 22:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F096B0089; Wed, 14 Jan 2026 22:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E106B008A; Wed, 14 Jan 2026 22:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51CD06B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:12:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04657C0A90
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:12:02 +0000 (UTC)
X-FDA: 84332724126.01.0414280
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81EC414000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:12:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMpEibgL;
	spf=pass (imf23.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnNQefrMHCm98aS2OxfgpugYxSlSHwccBT+lM0D4crQ=;
	b=mDSFe6MqRDAb6FeYarhE+32zS59UpdoIs3a607tOPLGnkaKqwDANszxq/VHii3JGPUpfdh
	w/zW+cgGZ4wqEVQbP4ED421Yy0zn89X+JKJvcC1k+O1lF+ZDf5t/trIB4xOPLZmmM2aX9H
	uTFwJmHgkKwfomBSzN1+vnZ5DO+lPDE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMpEibgL;
	spf=pass (imf23.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446721; a=rsa-sha256;
	cv=none;
	b=UCEz5feHHGPF4YZU1Qg2XYcm46Ks21eK1z+FUsrpPnEY7254ga7+lxRFvwSs1Sb+yu15U4
	LtnNGyTJyRodjXPvA3JK0eC+nG2rOYclf9d/MAGcg4qibXIAc4ISVrYahv8dNNDu5CzKGy
	rD4nfh7JRDW69mWrmfwlZfl2gxH2ixg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E882F6013D;
	Thu, 15 Jan 2026 03:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C37C4CEF7;
	Thu, 15 Jan 2026 03:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768446720;
	bh=Gk/osH7DfvUyCVOdPI7ZwI4Yhgby74VLmpmAMH87lg4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=eMpEibgLnCCoCpngPx1LjqAwoqkiMOK1O4Pv6xFoiICf5Rumtl6OjcBtchzbPzV4f
	 fOrU3PDXtnHoFLULkmJ/EZqFFePw0CC8HldneMcrfYufeIQNp0HY07Vp5aHrp9IHkd
	 nq3R60jTiiN+shKdZGDZMryPH7AwCtKRTq/4XKMRhdBkC2k5bVNToMndvjt7czfLar
	 x/fNxwwiNZk1fqNCF6QXd4rCKWEMN/I5M7C9Cj3EXWXZgtlkLHJyt49efPTSWgzc7A
	 eZ765DSqUt+KUoiHEilrTQ4oXDTqCKP0wfcjXMwg2eLnQOGC//VRCZKowDLG0/42aI
	 VeqGUU4KYI+uA==
Date: Wed, 14 Jan 2026 20:11:56 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
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
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
    devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
    linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
    andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
    atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
    alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
    rick.p.edgecombe@intel.com
Subject: Re: [PATCH v9 02/26] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
In-Reply-To: <20250204-v5_user_cfi_series-v9-2-b37a49c5205c@rivosinc.com>
Message-ID: <9b663e94-696c-4678-829a-6471e7022895@kernel.org>
References: <20250204-v5_user_cfi_series-v9-0-b37a49c5205c@rivosinc.com> <20250204-v5_user_cfi_series-v9-2-b37a49c5205c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 568f41q439a3uccskgjbbdjeaf9zwpyg
X-Rspamd-Queue-Id: 81EC414000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768446721-738802
X-HE-Meta: U2FsdGVkX1+27muQmhWRPxLrfBRxFrxiMOUJ9FsceZwdMOR4xkZF9vLYi10qxcCLKdwAe//Vm44+DEP59S5+sFPqOQkXCzWQPj1UKnjVarTZDv1JI+WBFnoQEPOesXpDlpwN5RBht5mqySkAS3VTYRGWP9TGkXpCzLcqNz/VXZUuH5e3vpc0TV47WNXAzheoqL2Y1znbo/oICxplKQaJKEB0NCtoELe+A9q0WJHEgDSLi4+ANTRKHwiTTDurT/qI14ZoykmZRm8yO2SMGgI71f0MEpB7RnYmXj3XcdG+Vg2rWmnFxPWUARQOd8PjfG06rpVoxRtb2Hy0E75kjMAiPhtMuc35iFnUO8WhxUNKgahI63eoGzv/GPZfd4oJpnZ73WJwUm8YiP3EO0Cy19BJhqAj/1lafBzuMxANuVtxvE0UzNPcFBF4yYfxBsGjnv4fPufZ9MG4ObuQc27YH7omEw6Q8ULEN2bLQ7HJ4Y3fXzhraUjZpJYNBLsZJd7CLQd0EbL26dVwAdTfk4oEjpG1GSio0Ebd5kKk3MiWTrUx2Apf1SWoKnDziyRpm4KwkwxWR+61Zz8OpWMBjOIjnUDRUrITuKgL0he7Hldwex1xe+Z5SL5pLH5naI3wjc9Dv/IBA57O4GeIPDFAVVzSh6QAkuPDp433EzIfJMHX6zHekMh8/E79yrkHE6i39rbQT5xosYYQPDuRe5hPZhUUX95bsSQ/ZkLS+VD9T8V58qGoxIsYzFZe1rbrLpeHAsc1I0lY4/3UBYZ3RCUIJPfxcN+l8bS0QrtOPWZjFPZuCcBB5+SXZ/NpCIgOdGd7qDK2DZGE9P3FJt8UWso79KVsu2szOaN22Av5kKhHQHkKucZwd2i/ZAo7pWwKm+WJ3GaElXUgikiCZzsDE48xrOGzvxz3nIG+V9B7DCZonye/Szwr+A7MAkrXOA5ggkJaHXFYX/02xNkyAcGB57YDYPfrEDf
 cJdVCOY7
 mc0nuVsGyBzDunaJEuy4Hz3F+WP5piDwF2kl3uE3xc2ppLhJKtJwSrt0/lX8frNqs8x81gu8nJhEhWy8Wvg37y5hYfdc0JpHjir+sdVrOjwdswa0I5Dlb4Y7SCmqsth8ExDrrFcz7AKthKEOPsbU3FQLI524o/7J5kQhbikOCa3H/EWObMuFhDj/GCNREbScNzVfXFyc/AZ6ivdMY5mg0nt3vygGnTuvOiuXXFKR5OazWukNOPTiXqie14AIfZGEmxFyCdsJWGPs1c37cZMOFRLW9nauXe8BlJiRM8Kg1pFJPAPgScAsLfnMGDTwTDfQNAVtRmlERB4dZ6IthuhxonWwz6dSpF3iL7MPfZlzODAIipw4rsDHsHHV2FKK1gMQdYOf2wcfV1Xjmpehpv9EO03LwCv/IbJT/f2xlMusrei3RTgDsu6J6euEy660YZO01ruNZAPRhqnW0/ebMdWVSS7daHleqr0ItiWiHd87aACoPv7YnbriFhOrcfcufWTV3M81gRXuCRYHlw8s5bL7tuxgDUQNjkW2og2ryiU6Mi3zME08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Feb 2025, Deepak Gupta wrote:

> Make an entry for cfi extensions in extensions.yaml.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>

Here's what I'm planning to queue; please let me know if you want to 
change anything.


- Paul


From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 19 Nov 2025 09:55:05 -0700

dt-bindings: riscv: document zicfilp and zicfiss in extensions.yaml

Make an entry for cfi extensions in extensions.yaml.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de> # QEMU, custom CVA6
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Link: https://patch.msgid.link/20251112-v5_user_cfi_series-v23-2-b55691eacf4f@rivosinc.com
[pjw@kernel.org: updated subject]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
---
 .../devicetree/bindings/riscv/extensions.yaml      | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 5bab356addc8..1aeff17c7f24 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -469,6 +469,20 @@ properties:
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
2.51.0


