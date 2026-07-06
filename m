Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3F0C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3CB6B00B6; Mon,  6 Jul 2026 09:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB846B00C0; Mon,  6 Jul 2026 09:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D12A6B00C1; Mon,  6 Jul 2026 09:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCD66B00B6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:05:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E5C0403CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:05:12 +0000 (UTC)
X-FDA: 84958372464.21.9E4A760
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8386F2000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:05:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fhImI+Mf;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OH8Zt8IpG4afTGjwrwNv/V/3GqQR4XmcV5U6B0IG+d8=;
	b=7ViCeva7/glsbvmeI4F6MC5FE7TwSbUD0elzRyvrCK52WRcJE74kJbizr7rVbA2VKKFxYS
	QIdcuOosZ3bLfmeWPWOnax9rxZPGrLXTzuxkotZKWW3KB6cg56GgWIDq4uW8A6+wHAsLBu
	XrTpzhEgr1LPQKFXaplxDtC7XjlKlqU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fhImI+Mf;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343110;
	b=GePzRrsNW2YLV8yEKIEOGW3+AS85I2QmIF2OFnKLH6P8GLYptGreY5Bx3Ybb3LmxD9Eayy
	OugRKzIK1pL2vmXfHz5P7nR4DW5YqToj2WUU44gSPdbRwEn0oJRIEavBtSf4gMn/F3/h9a
	uEJ72lxWwQIxChdjDwe9LckbbvuuYlk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4706f016316so321783f8f.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783343109; x=1783947909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OH8Zt8IpG4afTGjwrwNv/V/3GqQR4XmcV5U6B0IG+d8=;
        b=fhImI+Mfot6xlimjk2pPfqSjuY88yWg1FrBmboVZWdMlxrUJ+dvQMyMsOuPK+6Qray
         PQGrP5dMpgifXl802AEFWnYeRGlniLMF+RIJ+SMbuZ56S98iT7Pyi0DuFscEHgv1bu00
         IWRh1C9SKZQ6MNfWsUxf6TbKnrdmf5MgYMFACLiZbG5ayGYbApfRlJ5OSYnqZ2kgHMHg
         iyofq8D28+uEj2myEOyMPDqjC47EvPQH7XyyCrkOetGJ+0CAlWOYd2NU7GM/YZBLXXI/
         GcbOCLSHOQxlSzdUyxpv1lkL0SK07YyyIHvoVPZ/xn3jmDoZIrPeHQAGTWtfg9g7b7by
         YBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343109; x=1783947909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OH8Zt8IpG4afTGjwrwNv/V/3GqQR4XmcV5U6B0IG+d8=;
        b=PXUWzGs83IPGXHgItuzXiXjigP6i7dlgqRNhGUR/RbjXuo8zKJSDlIiLIyZb7I5nWp
         207jPIQiAz2fZxlGiBauqgVUU6RNDi6/GbQyl/l416wplodJ3ei8YAZjzwPL3+HF9VOp
         ybxGdpj+VdZ1izi0Fo6c2pEJMYWqVR9heZv/rtcoCWv1vNqO1JWfK9t7dzXisNMEC4+x
         TOfkD9ye9MkSP3WhHtL8purawMRyrt3K3uHxXO7ZpLuxSQayoXKyWiGUARWRxV4dL+MC
         ciK0fjStY7sKWwkFkAi+bmr+qJWZkljHWheidGIGjKmPtH1J7QqNZ11IX2iCUImmRxVS
         6lbg==
X-Forwarded-Encrypted: i=1; AHgh+RpVAWKa/55/fg3YveZJqZFkZ8Y0Dfef6D+gy71nzjjKddIQiczYwrwAdgBqFIIEi9bW0S/H8rLtDQ==@kvack.org
X-Gm-Message-State: AOJu0YyOteP0g7D29rC+zzLo8AtWwE2Ju15+RImx63YKm10E1YsQ6mm0
	RcBet7YKzwVRWtRlDyYLcd1Jl3tdbSQ/vU16SAG6XagIISy6vMCnto0x
X-Gm-Gg: AfdE7ckb8WSlM1LMEbLW8BfairXG/3d0ZUwFlWtf9o8+P+FBpUVFDGWn5kHT1Mmm9ZP
	rUjnTdLUJbpjH63WH0SSte6zC1fCHykL+wRwT2elGbi/ybawrerT5G0v8VEWpHUb5F8MlBIoVx/
	J0x49taMLeGM7v7PVbg46cQOhy1l2jJ5n/ItONtnb0GGSLSJIUkEQag8PPS0iYjVwZburtZIMEG
	X9WLkgtC+pNy6PYDixriJXEgbzBHyCE2W5Ifu4HQfCa20f/w2MspWsuxW3YJQhQs62YE1tj46tV
	1yzUwxXB8tjo2lwLnzxqfGqyD28UcGSUVjXsnC8XXxXVtl2kf85LRMmNCH1EKJ9U3nyyyzrKsEW
	4+1L5r4lSCxur3PKI7xJ8tf47Dnadp8Ee0WGS+07P7mtQz15/HZKGQtoNNjXhXLhQstcnC+AFjc
	9/NMRpw3KIsSAu9cAzkktZJYqrthhsbUOIwJuLnipeaIcZgtqZS/30gYf9FnNwVdM6IlMwoRWFD
	L/+sKG52nwDbWaPe8vP+98wf5yiQ/uA0xo=
X-Received: by 2002:a05:6000:24c9:b0:474:3708:ca with SMTP id ffacd0b85a97d-47aabd3af09mr6808952f8f.3.1783343108571;
        Mon, 06 Jul 2026 06:05:08 -0700 (PDT)
Received: from debian.lan (vmi1894487.contaboserver.net. [154.26.158.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8f1sm24515956f8f.3.2026.07.06.06.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:05:07 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH v3 0/3] make persistent huge zero folio read-only
Date: Mon,  6 Jul 2026 21:04:37 +0800
Message-ID: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8386F2000F
X-Stat-Signature: 9u98x1gj9fip5g3cnghgtf1ejfcohgoh
X-HE-Tag: 1783343110-481684
X-HE-Meta: U2FsdGVkX18lU6QFHqJg122/15Gz3z8Pi7tLIFUlgju5+l00cAbmK5Af2r9FpsIs3HJqBKE74+a0bP/1pfD/COO60U6x4Yjb1I5e9KDjIuDmbSUpe32Uqy6DUhgqwySD6xHti7tMeAu8Dox8pwwJZPQyJ7Eho4rV5SkAlBng3EPQvyDuILatzo7EVmpnUoZ6nz+/Z2rUS6h5WsLJXd1EWsf5VEfmXt+CKYq3X8UGWqTmQe5KrCtkpum8nacrhbVz/frGshkivJrenR2oersy96eEhoIjxTl8jvLZHzGuyA5gVPtDQUtlmisFq15uU5UzcR+lsc0QV+ZpGVQR9sAjEGm7pV1Khk62OgWojuARDuGQTEi6DZuFPJ1Gy4Z9rH5ovZHhrMJGiU+4GmYJPXk4kaDMyJPoSjkGtREXo9dLqaj1v7IZ8r9Lb7fMqcdKMQKk0qpHVDr5/eJS1iOJIbKduCrCT6zKDEdAY0P+jxBlXrmJVn7VnG3u7NaErIw80fjx4CPvgkpRE3EFhyBfIUlzJpMBP38XBZNe83GF8cYbEZdiNKLQQkboVFGTxE0NO2qkfBiHq+29y5G8vW+L/1GFSfVfEzL93SoAhqrlq0KajVo6ZVLq2X8VcINiVk2/LlgpJEjKQqKBUXykc8q+PpZVQTbVMtVBf5ipgxFxbydMyXywxr/mK1bxebHCZb6A4GidB7GV4jnUOHinw2H/+nQG6COQJkDPYw1UNM2iCErctVXDkm/x9phdrEnvAS9qDGjUmWXMM90phC3IKABOV10z5BMjU1Q0cQ0fUSRnkSl8J4dbIq9QwlvA9ddeXzmRyUmXa8fypQ2d3eilfHKLNZQsLB/4chJcT32SZ+oh4utO/mVloLQmnyEEXqA4xTdjdi2Bs47eyDIEuJ9XEhQEAPHYzaLX0lKBjblVJIQT2/c2RJhkHRp9HtaHwmTngiVr6O33HAcDe3YlGgxAICxx9qW
 afQ9j5m6
 xU9AIoQowdCe7zXYZFn7lzQeY+esgB5IMVmqjhP9uoRUd4CUKlNfAk50QgG4863yGx51gKR0Dv0mOHALQ2irI7NHdnqpt+AZFE9Y1eqbjLEb5VDSzVE1CEFvsKjjnGSSWG91FsJzgDI+BlsBgBmuFJxKaT35U5J2BjywG/MF/7HuauiQVYfblJQ6wPjFFVO0OFCN0utIVYWct4yKQagn/d0/vuT+VPcrFnG0rH8X8DiFNcPu90vrAWj3lYZ8FJN+HTbhstURiJj+tnKdzrtaB+6EFxTclVES6EDKrksDiGqXWonUXPXzBbqySwbfZuxiX2fzzbqBgE8zbT0pKThYrbNIv6/3ES6DIwoMmaV+BkKEa7Fw4WPh72p+cPXRYb5k3Gkj8cUXxccqCkjFrtdDXmK8qCxs1gOR023M+zga2cVQx9UKfnvyu5XGSwtWqswJLSXDt1WVVWqXZP1ZUbeY5bpYTa1vVYZtjihtu71nZ5etg2FEPZrhsYaE4+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the persistent huge zero folio read-only
in the direct map turns such writes into faults instead of silent zero-page
corruption.

This series adds set_direct_map_ro_noflush() so mm code can make a
direct-map range read-only, then uses it for persistent huge zero folio.
The helper is direct-map specific, takes an address-based range as
discussed for set_direct_map* helpers[2], and does not flush TLBs.

Persistent huge zero folio setup happens during early boot, so no explicit
TLB flush is needed here.

Inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[3] with Yang Shi.

Patches 2 and 3 add arm64 and x86 implementations.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
[3] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

RFC v2 -> RFC v3:
- Patch #01: Replace arch_make_pages_readonly() with
  set_direct_map_ro_noflush() in the existing set_direct_map* family
  (per Mike and David, thanks!).
- Patch #01: Use a direct-map address and number of pages, and document the
  direct-map-only and no-TLB-flush semantics (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for
  set_direct_map_ro_noflush().
- https://lore.kernel.org/linux-mm/20260609143801.7917-1-xueyuan.chen21@gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!)
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
- https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: add set_direct_map_ro_noflush()
  x86/mm: add set_direct_map_ro_noflush()

 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 arch/x86/include/asm/set_memory.h   |  2 ++
 arch/x86/mm/pat/set_memory.c        | 15 +++++++++++++++
 include/linux/set_memory.h          | 26 ++++++++++++++++++++++++++
 mm/huge_memory.c                    |  9 ++++++++-
 6 files changed, 63 insertions(+), 1 deletion(-)

-- 
2.49.0


