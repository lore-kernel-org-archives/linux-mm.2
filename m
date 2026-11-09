Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037A1606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 07:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dqsJtFkf
Received: by kanga.kvack.org (Postfix)
	id 1B37B6B05B1; Mon,  9 Nov 2026 02:57:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B726B05B2; Mon,  9 Nov 2026 02:57:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07AE16B05B3; Mon,  9 Nov 2026 02:57:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD26A6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:57:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3403B1A0545
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:57:41 +0000 (UTC)
X-FDA: 85414826322.17.B1B0837
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84F4B100005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:57:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dqsJtFkf;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794211059;
	b=r3XStDdqKig90M61OJxyEY3BfxSZPPvHgfTxWff2KNBWxM8W/YHfmJU6wf20+mvajkOVDh
	xPHxKl5EAPVXy2Yy8Te2B0I1zasBTUBPZuDkC+6T8F3px2M5vOJ1YvUG65TVEp3qvXq2VJ
	UoNQQakColnFqKCBi9tWgeXjp7z8Lh8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dqsJtFkf;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794211059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+qpfaa8PB4siPyxqqKNcOFnVRd7Su/+oqhhjIbgVahw=;
	b=ZEvP8XiU7UCvFjI3cuQbaiu28ebu5o47YZ2Og1In4gEYxBcrid/fpHTNx89dhPmIN7AlcE
	0PlAGHwakqAYdAPxK4zE5XDdWa9eeB0Via4uI4iKwt0K24nPchnW2/06neSoAYM1Z+cyLq
	BkpNN2/GrchMVdF8DHTYcCXhhgkZMEQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so4943735e9.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 23:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794211058; x=1794815858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+qpfaa8PB4siPyxqqKNcOFnVRd7Su/+oqhhjIbgVahw=;
        b=dqsJtFkfJFBUlVe8PzfWd3oct1Kz9sJxFw1bKc/aJZrnF0igMt6JghvVPnnV42y+ic
         FCH/sfj1sOZnC7vz/FOWJex/RVbw+Dahffz5rbHUzLK0IbmFdx0yIwwcRl4Kur/iBF3/
         9Zdt52716csPBOa7KPkAiNewh2N/dBdhgsMKZuk3upjE67fDjNt/omHu8YD+XrIuz2h5
         NMuFe7R55BQRAXVF2bktZ5XF4eWkm+/DAcSXiHdTi5eq12gkH6cdZ7botsWXV5cnPeed
         r7R9EUsSlvdF8+nqUvxPY8KDC1WK5JljmHOkJgg/f7sakHknzEH2ku4LkpLZ8PqYH6AR
         SFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794211058; x=1794815858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+qpfaa8PB4siPyxqqKNcOFnVRd7Su/+oqhhjIbgVahw=;
        b=RvRaknrWzN6mXSJnVzMie1/kQx3YOs8rfBtigjCv2KTi2lxoFlO93SpTAPgbHyRFb1
         y0Jc6QrFYObndPz4fjrqkwvlVB1Czd4SimFzi4pMO4BjIqDKu7Ce/WUNthrlwyaFzGds
         eVcp4EM0JRBX8VuKwf0enBm1s/BMqB8hmm/lHtqlDkrd6JwGPRdz35Ykigc3/Hm6dlkV
         bBjfdCPugE/68NcVXpXI7B1/mgKl1fShJ4vjP39VXowB1VWHXAg3t1M34PfEyHorK06H
         P84jy7AV2j+PBFLL4XtNzaq2PlUxlF0cPUbZ8R5h7mVgk3ABmTZij6hwN68QcNQ8un87
         C0Pg==
X-Forwarded-Encrypted: i=1; AL+hErHPJvJFAd7/Z8+ZJZMEK8bSINpSlxaayU0VpNCpTzmEvel1HoZ8p2dRwbebK+LzaLwg3UZMByrfSA==@kvack.org
X-Gm-Message-State: APuU4Z92yZ5A9XoOiNNEV+kGyv2g8YzVs/U4QpiDWLR56HNVfMw5z9yZ
	aTikVb1sGobV82kQswcwO6wD8Wmz40XCR1erNYewonOI7eejJQQTDRDi
X-Gm-Gg: AYBFou2WcWJz+FSLzdplNsa1cac7EqfexzjCj0W85HIk5gREjmKotuKGP3oZGDFKktQ
	mJIzgiC8wQ9PmsRmdXhdbo+87vtnzG3veO/heUMnIlnU2cYYg/BHePueufahwDY9MnZLSCAK+Ig
	uDGPp7pxvQlYFuOkAHmVq64D2HNgFrjmxILMQaHhuH1NyC8xLS9NCeT4ONXcVGxnD42MDcIEI4I
	6z7yqs0lfk1gTXDRnqIL5Vf5KIrUFNMlTgIJaobajOwlzk1ja8SRzwbou9kPpOm9peyvyh7784t
	185tPVxvUhceRb2TfdpIY4cpr802B9rPL2DrGCPlsi+mObbdwrrgfBfqlBwz2e+SpwWzjiHOi50
	2ADGCSGjp8V2MZBV5bJTgtqiWSg2nxt9n/Qk4E17KTpgcnpfIxyGJtw2UH+iVnjkB3INCn1U5OY
	ERFd0rIS0TnYUEeNB+KFuVuTAbuIs+meD94SC9ghKRRuuA/m+95WE4bWSM+QUPvOtTFtTffNGpK
	3ud97siQwhsZg5pKTvlwGexFztgS8LxgV3nXxoUQTv5o275htJSw8D+yIJtbIepUWR5TpbjxYnS
	aNFwDZLB8G9KQQ==
X-Received: by 2002:a05:600c:c0c8:b0:4a1:fbd2:f689 with SMTP id 5b1f17b1804b1-4b960d9c6afmr43080115e9.7.1794211057941;
        Sun, 08 Nov 2026 23:57:37 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm107949145e9.8.2026.11.08.23.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 23:57:37 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	Mukesh Pilaniya <mpilaniy@redhat.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v4] memblock: don't allocate new reserve_mem regions on a KHO boot
Date: Mon,  9 Nov 2026 08:57:25 +0100
Message-ID: <20261109075733.9051-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tf8umsib7kdprzsqgrf55bwsntxcwpg1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84F4B100005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794211059-15647
X-HE-Meta: U2FsdGVkX1+B/4lMYjgqXW27lmkvqEijYfoa2Uf05HnXkf5S9g4rRElnlI+csq1D/xvMHCyKsOHDsN06zs5wl5KrEoWzBw1EWCjhdDUyj3m74ZDvbxj75ImYefS87BtBfl0gD0A5NuV5giDlIhMhl79crenr5WhQZvGbyyIJuZPmdFD0YNkgysKPG355j2VaIIcA7dHXMvWbSJnRQAlApTxR1xW4teqqLv/zwDeTsaazB6CWm9pAmsy/0nvfIi7yC8OrRx7qyGRUpiA/2WNniwJhKwE1mL1oOE50h52pkWWSL4zbxgP5zkJANiSkDosUL1xJ7mK/89jyrYYCkomgyQT5iXpf70wWuD5l3/GSe3SsQtNdsxf8wnRydAL64IypEb9XTln1Y1aZGyUU+842uxjnHz9LmS4VStVwjEJMLZn+J1LVKbjKCqS4gJZZaOR+S2H1YBANy6t9PpmrrzrLU7olgbwGFD4R0R6AapbKAoLH5cluQ9mWvUI0Teb6wOSPWd8bB2ndeBFpiSct2Yy/QVfQGpUKUBBPvDJmoAcR3EaY6ilvrrCmbMrkBVcnZXC+HlivCkKT2VeN5+KuzNloAXyqxX18jgtvE95lMNw97NcL+ph7uqKh3B2f5+8X9aAvst7i465U+Py738W9P1pC9kJ/EK+3IWlnQ/laoc1bcjVkBaY0rVgb0KAVIQm0I9MExZ/NszUTT4ycW3cFQYeGVfjsE8AeM2SehIdks/lFysq7eR3xpByU9FZ2N84H81nriTC1OrlfbUp2+E3hr9ZnJa3g9CH/UzpYKOlt5ceeIjTPyQrtQFNtirgnfXhWkFnbD8Hc4+JEVCgRUldAPR/PcDRZj5A3jOdQHA61WODYo36Oz9GWifGpXJ5KUYl0swUv36GU38okBmlKfrKFqnLMh3bZtqiWVwC8mY6Y2J/5uUD8VvPK5F11gMQaSG6tNeHbX056290F0LvKwOgJVNg
 BY7VXs65
 CpzZdlsoI5ngd/vN9fH7y+M9nNEseBipOV+w55n0txee3StYMTUhRYcFppM8YdRx222WZMjBne+Ha9/WQTRwbN4QsHthxTd4bRj7t+04J5ehGnRQocN6UGzWOmp+mZwfUzgx4jZu67bvTPpdg+i2s8dvzn4BEXBCweVF0+zNFujSutX2O64I874TrElM11bx8T5oNSltc8pb92a/PsUsXq5BgdMcWDzFBGByAEBPAf+YT0cAu21HGXpkTabj9q/bMNn3duHI5MYopVgmcoV7OgHI2nhpr+Ipy7LAHJ1Y8erSe+eQEc74AqK4jDXfvWq+uvhqvAVMvmvO263OIv+TC2XqbrV21r/0nyUTbZP61GrxKbPCdsY9wGcLk4iuWsjCa51j964c8nGdzILWoeRErQzMuBXunsTGnLZt5TU/Sf8NueYFPO+mU6tf6aos47X5mmlOWFirWLVb2ti/Jmy16AGKRAUe7eMmbYm7SbAEucYbKhBQiBK3Qx5IcczkNrGDvc8958TXSSRw3WZ9hAChV4/XITjrNfty6g3JA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a KHO boot, a reserve_mem region that can't be revived is allocated
from KHO_NOPRSRV memory, which includes the bootmem the next kernel
boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
then fails:

  WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
  failed to prepare memblock FDT for KHO: -22

Without it, the next kernel puts its memmap on top of the region and
the ramoops records in it are lost.

There is no use case for adding regions across a live update, so fail
instead of allocating, and drop the TODO. A KHO boot with kho=off hands
nothing over, so it still allocates.

Add kho_is_enabled() and is_kho_boot() stubs so the memblock tests
still build.

Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v4:
- only fail when KHO is enabled, a KHO boot with kho=off hands nothing
  over (Mukesh).
- add a kho_is_enabled() stub to the memblock tests.

Changes in v3:
- add an is_kho_boot() stub to the memblock tests (Mike).
- add Pasha's Reviewed-by.

Changes in v2:
- fail on a KHO boot instead of allocating outside bootmem, as agreed
  with Pratyush [1]. this drops v1's patch 1.
- not an RFC anymore.
- based on v7.4-rc1.

v3: https://lore.kernel.org/all/20261105213153.9572-1-azpijr@gmail.com/
v2: https://lore.kernel.org/all/20261104204235.9066-1-azpijr@gmail.com/
v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/

[1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/

 mm/memblock.c                     | 12 +++++++++++-
 tools/testing/memblock/internal.h | 10 ++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a450092a80fb..0f466fcfc719 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2827,7 +2827,17 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
+	/*
+	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
+	 * which includes the bootmem the next kernel boots out of. Only regions
+	 * handed over by the previous kernel are supported, unless KHO is
+	 * disabled and nothing will be handed over.
+	 */
+	if (kho_is_enabled() && is_kho_boot()) {
+		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
+		return -EOPNOTSUPP;
+	}
+
 	start = memblock_phys_alloc(size, align);
 	if (!start) {
 		pr_err("reserve_mem: memblock allocation failed\n");
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index ba4d1c02fde5..a68124d76b10 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -51,4 +51,14 @@ static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+static inline bool kho_is_enabled(void)
+{
+	return false;
+}
+
+static inline bool is_kho_boot(void)
+{
+	return false;
+}
+
 #endif

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0


