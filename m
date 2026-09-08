Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D8FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67476B0093; Tue,  8 Sep 2026 11:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0E86B0095; Tue,  8 Sep 2026 11:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB966B0096; Tue,  8 Sep 2026 11:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1736B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:56:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DAD6A4B33
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:51 +0000 (UTC)
X-FDA: 85191048222.16.320C4F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5836C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgzqAq0R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgzqAq0R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883009;
	b=Q7hJokTSQ8KV/8G8EWTiYr1CQV/NkR/2gyvhqk/Xls3txFAezMul5RCxTca+hBquab7dbr
	EDXlT1H389MbZbk6vDkTzPcU20aXfYkJyPGdh8ShG12PdBUDJPQZZhukCT3yvQJff451tb
	zeSmBLWUrcTWmCEFpIlOZfNovvCveZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sRrd8HW6tVkZeGdEyEtiUpIMBkv6a/57SRsi9SBmBeE=;
	b=Y141muh8tJwFtrNrxqxFeQz9FLtZQm7XiIAoc2bVfx3LIW13LPgqP8AuwCzl4zIWNxr3i5
	ppfCeL4l627fb9IfKtNxM+GpW8auaYo4lgyEgldoF4w8yiBljC2cK7CWvdMie+2d55VOvK
	i692+F9AYjf4V5nF9je2ED7HNEI26io=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D2C9601FA;
	Tue,  8 Sep 2026 15:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3E71F00A3D;
	Tue,  8 Sep 2026 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883008;
	bh=sRrd8HW6tVkZeGdEyEtiUpIMBkv6a/57SRsi9SBmBeE=;
	h=From:To:Cc:Subject:Date;
	b=dgzqAq0Rb4t3E65A90uWXQ8od7s2sZqu5HDBqaJYS739IKSVberiqznPYaCD46X76
	 hg7VF2iHl6HtZqNtYIGeMQKuNy1OcnIqdyV2Npj8y99of6jDpJGQaTtRm4sV8kXBrT
	 wZ28xpm0TQ+y8vNp9XgYu7sReJxXI2Srrf7PXc5BJKRImATk8y4scer0CX2Wdk+Ygs
	 7fNnOlWi69n052qHTsAJcBEsosfaF/dO113v1vD1Hs/MR9HMYD7A5rHRuc+yLNe696
	 iYg6m/WbEHurdr6ucmTDEdR45Zi7/yEnJJZLhMeePTkWBjoDdJMaLi/3GdTwdzmT7J
	 YMPEMq8UVBnJA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v2 0/4] kho: rename "scratch" to "bootmem"
Date: Tue,  8 Sep 2026 17:56:34 +0200
Message-ID: <20260908155639.2496551-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A5836C0004
X-Stat-Signature: qpratpd9w1prg9g4uazrwre5zhodxnqk
X-Rspamd-Server: rspam01
X-HE-Tag: 1788883009-751113
X-HE-Meta: U2FsdGVkX1/YOpztNFjnJ2Kay010rQUu3WgJhOj5ApicZaivf032XGocKXxc1LYlj69FyevbKCAXzGm8U2AaURTHRT+rqhV3HllJB0jW/J0nK1Ou7bG33KZOeamkxi3eVHn731v8goig8gtpSpXlqpejXGAK0ec0cGAVXkqH8SZXqnUmQL0zcwgqxKlmgKHvSW0sIUTaZCfFBBsj52qwVn5UBLw2AcJqEwDuSWzCBQ3sgE+us9470MrzOZmFzRFufw/pNALAgEX4hTWszu4/s/7OAJGDPY3Cw5tS6GuFCxkk09gvi9wS5/WdT2OXEmw4fQ8ZqrvRe7uT9k38ppzl3ivg94/IHGcdzz07pRioqoNhDSKiamw4idJ6TYtWArlNB6zKXUDFNQTo1yT0xQGRX8NsC6lH6Fsn+kDsaYaKAnb+aM+XhEksI3UMwtEtWybmGmFEBuwfAlIztX6/ominq0Jk7DyYD5oum1Zc7Gy25xFCUeKzuAt6dSBRu8Zs+7GEXPSN/lv9BuP+M9C24VaiSANH4qwsyjonOq1X3CKSIXhvg4cZu3lR02DsdXzh7ss4icEAGiqilZSjCyT5iLY2qmTEFV7plzu0zd0LFZhmMT+XfRoNMf/o8OZuzm9H1nbffDExaRlxR3FcFY+HkVRt37Yf0LCeQdFgM3nVbzt61SR8c1twSawSjsJ3d+kDJXO6zQD+T7fZRzgQbwLiQpcQcx/aLb7S5JnVUuJWS3LQrWpY+r7flCLbkhi0rWxMx5CuJkqkmCE8JtyLKU7O+k5HZqu1Z5LOH3JeqxRGc+DUJaPxCNqQVoR9mDcpOxX+EvEOEqvZz1I0UE8EQ9l12sNyxglXdUYByvycM4eThl9KE4c25IZXZL1meLIJKpSxwNmlsbS9YLO8pvJn9ERqPV47bfTKT8pu+XjLTgFMTPdRHdVBOgLdxSBv0RKvi3ipakdte7R7iuVn4qxvLF4BLYw
 9le+Ey8A
 /SykFEMdTd8PUBbcGW903dF810CWtR29Tb2ZEhjnvHWLcY1phcjRZBBcbq3g5AVg+WOP7aDuPntf9qxNhnQjOtDjlJO3r4fDni5PlIkMsMxeoowyd/A27rg6WMMt900Q/S7eUxFGTybHEXC8kWjgno4yxzZl9EiD3o5PElE/TIupE4wNJg4jVZmmvTCQ8zCXXLfyhjSz7cHUu7wMLQUWPLqo13tSPCmZbIKTBFchkrjLtc0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The term "KHO scratch" is vague and overloaded. It does not accurately
describe what the memory is for. This was discussed previously at [0].
The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
is memory passed by the previous kernel for early boot allocations.

In addition, memblock does not care about the provenance of the memory.
It cares more about how it should use it. Use MEMBLOCK_KHO_NOPRSRV,
instead of MEMBLOCK_KHO_SCRATCH, to describe this memory to memblock.

This series does the renames. It also gets rid of a redundant Kconfig.

While the diffstat is big and scary, most of the changes are mechanical.
The most interesting functional change is in patch 4.

This series touches a lot of files across a lot of trees. But since all
of that is purely KHO-related code, I would like to collect ACKs from
the maintainers and take it via the liveupdate tree.

Ideally we should queue it in liveupdate/next early in the v7.4 cycle
since it will cause a lot of conflicts with other patches throughout the
KHO tree.

[0] https://lore.kernel.org/kexec/agHGOxSnP_VraH1M@kernel.org/T/#u

Changes in v2:
- Rebase on latest liveupdate/next.

Pratyush Yadav (Google) (4):
  memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
  memblock: rename KHO_SCRATCH to KHO_NOPRSRV
  kho: rename KHO scratch to KHO bootmem
  kho: rename kho_scratch= commandline parameter to kho_bootmem=

 .../admin-guide/kernel-parameters.txt         |  15 +-
 Documentation/admin-guide/mm/kho.rst          |  18 +-
 Documentation/core-api/kho/index.rst          |  36 +-
 arch/x86/boot/compressed/kaslr.c              |  12 +-
 arch/x86/include/uapi/asm/setup_data.h        |   4 +-
 arch/x86/kernel/e820.c                        |   2 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/realmode/init.c                      |   2 +-
 drivers/firmware/efi/efi-init.c               |   6 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 include/linux/memblock.h                      |  30 +-
 kernel/liveupdate/Kconfig                     |   1 -
 kernel/liveupdate/kexec_handover.c            | 340 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/Kconfig                                    |   4 -
 mm/memblock.c                                 |  56 +--
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 23 files changed, 302 insertions(+), 304 deletions(-)


base-commit: c65687600ed075d237a204755d99ad538db34b47
-- 
2.55.0.979.g7e5102b832-goog


