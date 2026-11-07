Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28F2606D814
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LmLGIXJz
Received: by kanga.kvack.org (Postfix)
	id AEED06B05B2; Sat,  7 Nov 2026 10:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2906B05B3; Sat,  7 Nov 2026 10:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D85E6B05B4; Sat,  7 Nov 2026 10:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC1F6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:37:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75C5D8036F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:10 +0000 (UTC)
X-FDA: 85408726620.10.321E1C8
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1528180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LmLGIXJz;
	spf=pass (imf06.hostedemail.com: domain of 3okXvagUKCEk04z3trzzrwp.nzxwty58-xxv6lnv.z2r@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3okXvagUKCEk04z3trzzrwp.nzxwty58-xxv6lnv.z2r@flex--ptosi.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065828;
	b=18OYJY6Awxj84MRR1wQp5KYnJGWAjxNEQCrcipq3xtDacLxAKiRZCzjVIGKelsdlqSGCky
	bnh/otUW5FqQr6JK3Lwvo3gQen/ggtpn/VMJKLVohgmGm08eo4DZyVMxJfncD9i7egXpPA
	d6yOc0p3OIVbRoPVDYDMBK52XPGMuME=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LmLGIXJz;
	spf=pass (imf06.hostedemail.com: domain of 3okXvagUKCEk04z3trzzrwp.nzxwty58-xxv6lnv.z2r@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3okXvagUKCEk04z3trzzrwp.nzxwty58-xxv6lnv.z2r@flex--ptosi.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QyPiotEtbjmbAknxSU0jdiIPb/Ej3HeKpoXn1Xbs3Mw=;
	b=FKArarnJ2Q7ci0gHWFhC9bD8fzx6YnDfIFeE5/TFhTGASjuC5RbMJHp/REVbysRd6l1YyQ
	dvd3/kQPjYHGbnWmUB1QR8h+0E7ObitYBP1yaOOSVDdGRFjjwJKqNM0ZlL1IVasDisB0iH
	4ylhGqTHyu0TP/B0kd2KuWwOKtaSvl8=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4108bfb63dso107996266b.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794065827; x=1794670627; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QyPiotEtbjmbAknxSU0jdiIPb/Ej3HeKpoXn1Xbs3Mw=;
        b=LmLGIXJzf4DkG7crMve3EvOtkAQ4MwnMS0M3kVM5G5RSbtkjj+yzd4hgd2u8ZVYSB5
         ewJnqy21sAcwm7cdfn17V9Qn0Nn6wSl/lkbzW8PhCLmD4347SUrhvm2zoibYN7jgmdBC
         R97f32RZz/dTUji1HmXk8WCPQDNaa3sHXppElIj9uxeJAN+52uZZbBOMN/DBDCC8xEZj
         yEiZnMFmSjnjAUFW73f2EvxDfn8zIchkqCU7zm2frbkeGpp+5B1AoY/ZDX3e/JlyLj20
         ul79sc3cL261cqmw12SdWvz5bPBmRD+WtMJAvKaD7//2kO8dd8XMctHE8CEOyHWmG3Al
         IS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794065827; x=1794670627;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QyPiotEtbjmbAknxSU0jdiIPb/Ej3HeKpoXn1Xbs3Mw=;
        b=T/J7buogJUiPo/vucUqnlkMU2tkEXMG1KvFTe/yIqQMP/3ka76flJr5xk7k513nA3R
         0M+omHZPESLld3SgRwzrw0o0KrxWLA7djY3dePXAUnDoZD9AlF4Yci9YK5VUOY5Lnws4
         AkWbK2iy7M6omOR9iOmZ35i5AZO2+VkHFCmQGdzaggv7I9TgLNDKIzkmKrqRacrXiuH0
         tr9Lkj0EVmuoQO6WVkfsCX1MfKWNuUi9IJl2WUcTg8wnqPXDo8zqqNi/TE+z08SYhpVd
         DY1D6TaGmhXz1JdYce6bCMdQmCFreMlJnEN9VAmsL0B19fn8za/F7EK68XUPo098+eyS
         VMPA==
X-Forwarded-Encrypted: i=1; AL+hErHA4ZrSUjKAT0Hol3iFSUTOEVCH2He4XR+GFCdXLR/zzXExVTWFXhQZJsqFo02U+mEUjdo8UojqSA==@kvack.org
X-Gm-Message-State: APuU4Z95Wcacd4iW+dOjyCg+GoVIpql+znQzTB9hJ5g6bp6mLLL8zLbX
	OufEybtmf4lQCNZyEqBRoeMyfBgEazVxwGQKFf0wEkW0bD/rJXeAtvdB5l2OLwfUVvrlN3Sh3BM
	Xjw==
X-Received: from ejih2.prod.google.com ([2002:a17:906:2dc2:b0:c31:9613:6217])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:9f8a:b0:c40:d920:747c
 with SMTP id a640c23a62f3a-c4d3449c10dmr439396066b.7.1794065826487; Sat, 07
 Nov 2026 07:37:06 -0800 (PST)
Date: Sat, 07 Nov 2026 16:36:06 +0100
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAGZF72oC/x3MQQqAIBBA0avIrBtQg9KuEi2kphoqCyciiO6et
 HyL/x8QSkwCjXog0cXCe8wwhYJ+DnEi5CEbrLaVMbrG7SRcgoSIcqx8YlmVlpxxo/c15OpINPL 9H9vufT8GvSV/YQAAAA==
X-Change-Id: 20261107-mte-kasan-split-3632e818f997
X-Mailer: b4 0.14.3
Message-ID: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
Subject: [PATCH 00/24] arm64: Decouple MTE code from KASAN support
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Peter Collingbourne <peter@pcc.me.uk>, stable@vger.kernel.org, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A1528180002
X-Stat-Signature: disoiyqwyzjbf8iwk6c1qjiqhmbifbuy
X-Rspam-User: 
X-HE-Tag: 1794065828-162951
X-HE-Meta: U2FsdGVkX1/GhD9jQM5kD0Q9aDPcKfnAVtZD5RCjRvy/FMVwBBqVRtnQUdi2A1TwhzNKc4XGmsYG/RM8cfeGLhZOaF4eUq87ODTG3aDsN4Qqyvnb6G3aDBgqo+HK5vvL25k5uB3RJ1hLYxuepJYX8pRr+BZO16xK0IhVoH1HUJf18+oL3KHL1xmEb1/p90fWyPVHpu0wrxv6aMTvidwQhy6m1rVzj1CTdAN/toDX4QNPcKPp8lPRA+6Rm1W3Eb0XB/DFflLyUtu9tgQfA3n1dxHx3G1gx3JL9wYq9n+kJ+6gqzPg111A10NOWzQYTCcFHY1oJcDPRWiuegEZ107RHdyji969/Up/GeHG89WwqEXoQDKEcohDGWefhTMunc/XK59ku0rquth5KsCi36rBAPZff+EstwI1R1GsKwepV2n2c+ysSL/8HHXKpUJrjOLEwMZCUD2i8TGnKNlQjYhSZSu2U2F49s4PJvEJADYn97plw9OSwBqUgGkxakZjQ4SpyGimDiV1VjKOG1QwfQbPSkiqG/sv7VGVfDkKrt03fuD/RAOXjgwn0mM24PMIE+3Run240lP4joZ5KJS4nnxz4QhfucoVoisJ1riJGe67lpjlX0fspJxG1FyQLJEIfqz0546tUqoqsPAxv963tB1mzDUhu43AMCbjPY0nu/eTI6XlcLOlnlVTN92HG6IK08t8EOkjOWZlIFPNGGpAatJYlTe26wVGI9VFgh8V3Jk+k7HYlkJPykcoUbws6n+R7q/qM7vYtKk5+QrlKwEk/0mxMZEaAhqTps04GTzsdVbUVF+CKM/tup3bu/8k57rUnJZ5EFaYMN2vlZtsWqGkCQXCkjIellQTJtYx2pUuQENh0NugWN5T+7cXc8wDGpL8UBqX8e+PeeSRnfRlLNdj9nIS7CR259dkmw9klfdFTo+Kg7944uwYx2/4VZT2brkkN/EaHBdhpyzCCR84elYiVNe
 AdYPpml1
 n6ByXzRsDr7nuTySMk38lxKkOMBq23vjwtFvrSEH42nBulWWjfh5m1SdO3pGxWqc/7XULkQJF3qc+s6n7IXkgVoR6ENw+t9PEJssltHcap+VSVOmZht9YF80LF+PUBMR9sAnZ30KN7dmtuYh0ibPkJ3zOqbK8d5HmBzIVSyG9Myz0yai6yTrKNoPiC+wojvCivqWllWrU2HaXBMBVP/HZBERoL2xY5WKIMBUx05OttjcPwGfiAo6gwZn2CuC2G8SqMJzMBx94etUHfF/KJHbvNdL+EgUe5+F6vaQ4hDwh0ZLroprFaDNaUukcrSHw8Pb73WHigq7JplZS2p9b+9MVmu++aeTTuUhtC0Tp/c65EqkBu61DQOM9xsAOEa6J1YJDMCEKrYu7MY786cHUQ160PntYL6gqPelksH/M8JPXmp8YmkY4jU3g4pgABsSaBdX2m/SQDLEVQMsWXxwIiof9E6VQQd3rVbQ8bDXifu1GJ/0wVS2+Ttm7dYZpZ3PXmDOEsiN5BfN7h1FLYW4F1ghIbonq1ba+hK62wCHbglQPhT+NHWVRAAYzAUOjL3wQ8t3/KjKghEaYKonOj/959ntYOsqdsGCeLSEkoS907PQ+i15eZRiOIzu6QWBjzDkyGEv+GhOQ2DXoXzd4f+hM+eatmL2y9JfZlShktE7I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MTE is a hardware feature, KASAN is software infrastructure.

The direction of the dependency should be clear: KASAN uses MTE.

However, the code does not reflect this split: many mte_*() functions
are actually only intended for HW_TAGS such that there is no way to make
use of in-kernel MTE functionality without enabling KASAN. Furthermore,
there is a lot of unnecessary indirection in those functions, causing
duplication, code that is harder to follow than it should be, and making
it easier for subtle inconsistencies to hide.

Instead, this series aims to untangle the two into a set of reusable,
arch-level MTE functions and a thin wrapper around them that KASAN
needs. For non-KASAN MTE-related code, instead of attempting to reuse
KASAN functions, break out individual MTE primitives into KASAN-agnostic
functions and use them where needed by aligning in style with how other
features are supported e.g. during kernel entry/exit.

The result of this rework made some bugs and inefficiencies obvious so
I ordered the patches into 3 sets: first, bug fixes, then, functional
improvements, and finally the refactor. Specifically:

- patch 1 fixes a bug in the support for userspace MTE, with a kselftest
  reproducer in patch 2
- patch 3 fixes an unsound inline asm statement
- patches 4-7 address inefficiencies in PSTATE.TCO-guarded sections, TCO
  lazy clearing, and harden TTBR1 address categorization
- patches 9-12 rework MTE-specific code in arch-agnostic KASAN, with an
  arch-level early refactor in patch 8 to keep those minimal
- patches 13-23 then proceed with the methodical untangling of MTE
  from KASAN, leaving only a thin KASAN_HW_TAGS wrapper in <asm/kasan.h>
- patch 24 introduces a hidden Kconfig flag ARM64_MTE_KERNEL, to better
  document in the code when logic is required for EL1 MTE, as opposed to
  KASAN

This was tested on v7.4-rc1 and applies cleanly to arm64 for-next/core
at commit f46be4da2cbb ("selftests/arm64: GCS must not leak on a failed
clone3").

The following checkpatch.pl errors are consciously ignored:

- "WARNING: ... does MAINTAINERS need updating?" on patch 2 for the
  new kselftest but selftests/arm64/ is already properly maintained
- "WARNING: Macros with flow control statements should be avoided" on
  patch 5 but the new __raw_{get,put}_mem_tco() macros are intentionally
  consistent in style with the pre-existing __raw_{get,put}_mem()

while the other warnings/error are false-positives I fix in [1] and [2].

[1]: https://lore.kernel.org/r/20261107-checkpatch-asm-complex_macro-v1-1-9=
a7b3c69fc28@google.com
[2]: https://lore.kernel.org/r/20261107-checkpatch-file_path_changes-v1-1-8=
b11814560d8@google.com

---
Pierre-Cl=C3=A9ment Tosi (24):
      arm64: Fix lazy TCO clear when enabling user MTE
      kselftest/arm64: Test lazy PSTATE.TCO handling
      arm64: Fix volatility of IRG inline assembly
      arm64: Skip TCO on privileged uaccess without kMTE
      arm64: Check MTE once per fault-handling section
      arm64: Harden is_ttbr1_addr() on tagged addresses
      arm64: Skip redundant TCO clear post-kernel entry
      arm64: Introduce mte_get_reset_tfsr() helpers
      kasan: rework hw_{force=3D>flush}_async_tag_fault()
      kasan: rework hw_{get=3D>set}_random_tag()
      kasan: provide empty stub for kasan_report_async()
      kasan: drop mte-kasan.h from arch-agnostic header
      arm64: Introduce set_pstate_tco() helper macro
      arm64: Add mte_{enter,exit}_*_{kernel,user}_mode()
      arm64: Refactor and remove mte_disable_tco_entry()
      arm64: Refactor KERNEL_GCR_EL1 out of <sysreg.h>
      arm64: Introduce MTE & KASAN tag handling helpers
      arm64: Inline and remove mte_check_tfsr_*()
      arm64: Rework static branches for kernel MTE
      arm64: Move MTE insn wrappers to <asm/mte-def.h>
      arm64: Introduce mte_tag[_and_zero]_range()
      arm64: Consolidate MTE-based KASAN in mte-kasan.h
      arm64: Fold <asm/mte-kasan.h> into <asm/kasan.h>
      arm64: Introduce CONFIG_ARM64_MTE_KERNEL

 MAINTAINERS                                        |   2 +-
 arch/arm64/Kconfig                                 |   8 +
 arch/arm64/include/asm/kasan.h                     | 103 +++++++-
 arch/arm64/include/asm/memory.h                    |  14 --
 arch/arm64/include/asm/mte-def.h                   |  65 +++++
 arch/arm64/include/asm/mte-kasan.h                 | 266 -----------------=
----
 arch/arm64/include/asm/mte.h                       | 189 ++++++++++-----
 arch/arm64/include/asm/processor.h                 |   6 +-
 arch/arm64/include/asm/sysreg.h                    |  17 +-
 arch/arm64/include/asm/uaccess.h                   | 106 +++++---
 arch/arm64/include/asm/word-at-a-time.h            |  22 +-
 arch/arm64/kernel/entry-common.c                   |  58 ++++-
 arch/arm64/kernel/entry.S                          |   3 +-
 arch/arm64/kernel/mte.c                            |  72 +++---
 arch/arm64/lib/strlen.S                            |   4 +-
 arch/arm64/mm/copypage.c                           |   1 +
 arch/arm64/mm/fault.c                              |   2 +-
 include/linux/kasan.h                              |   8 +-
 mm/kasan/hw_tags.c                                 |   3 +-
 mm/kasan/kasan.h                                   |  14 +-
 tools/testing/selftests/arm64/mte/.gitignore       |   1 +
 tools/testing/selftests/arm64/mte/check_lazy_tco.c | 152 ++++++++++++
 22 files changed, 649 insertions(+), 467 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261107-mte-kasan-split-3632e818f997

Best regards,
--=20
Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>


