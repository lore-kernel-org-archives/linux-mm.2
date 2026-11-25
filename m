Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE52606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zR6DVtO1
Received: by kanga.kvack.org (Postfix)
	id BBA756B0975; Wed, 25 Nov 2026 05:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69EC6B0977; Wed, 25 Nov 2026 05:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59236B0978; Wed, 25 Nov 2026 05:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A256B0975
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:01:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A1B280E28
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:07 +0000 (UTC)
X-FDA: 85473198174.21.CA23990
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4B50E100009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zR6DVtO1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600865;
	b=d81uXTxVhQQ9+DUOLsnzpaMQcGt5/X4bZipvDoLCWfXABFb86YsYNaGAOTAls+xTSMDaxG
	tsdZT7vSAh6vcdjxrmDuiZv2Xrwcdg2LMO6S3cFoxxXjlRO1QQAIPAoEFKiCpBMAhRRd+U
	VtIM3tBh65nYKzsXHatKRDpx3ZBfWM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gcuNzP7ETPGzPiCQU7jBlHgAed31Q6Dufg+3EtNCvfU=;
	b=CTlcqiLEpmOLqtF+TxbLVXZFHmQKDyX/ZTWk90mYdK9RIH4F039nQr7R5Sv7a0kPI8O24W
	SAO5O4tZHbCvQiTLVyWlvQaZeMzAIz+9YjKsKWlvZBoeXSgKMfdm4354swX9ChGyVkksN7
	PKc6Dnd36M3pYnDZCcLrfUvDhDN6Y04=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zR6DVtO1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bba60271d7so3791825e9.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600864; x=1796205664; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gcuNzP7ETPGzPiCQU7jBlHgAed31Q6Dufg+3EtNCvfU=;
        b=zR6DVtO1O7HFgmQmBZxB1c79Ticeeu2BBLPKj0rsx9r0Lg0Qcs7DAH+bL8krbEq9On
         d30ssFKXN3Q61Co/6DLzlit8/ieA7APSpDQEzc0w24alCUyGQsmciz/rPCLC9VITauFA
         mDX6TMptxuAvL+Sbe7ydQAZ2dsHeunm6eWSzoaVhxIja508+BnSor8hWuIHDCWRTqDMI
         95b6UDXzRHJMvS5XOlEq8z5Iz4qXNr97bdxdNOkevlcztP62in7hpeGMCDPeIVzmfDKe
         wLg0XrfmzB5bozjG0bY1yzydZOZYizfC0no6e3uq7tWhcVtdHDUHQVbRzoCJ1zmVyAxa
         MuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600864; x=1796205664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gcuNzP7ETPGzPiCQU7jBlHgAed31Q6Dufg+3EtNCvfU=;
        b=Je++oZ1COPd5n0mohjPBkPJ4cDWp5Lf7f1n+9WBtYTXGSZTu2g3ACoJQzDaIz1xJQn
         FqS2FF16lpv/jeYTCgP9OC2FOoUvDBE2nEwzG/4F7jrsROGza+8xiNp2FtFblrz+1j1q
         D/pxCI6TTjMKvIncb/a2hsD0xuc53XSUMy0ppjUOCcq6JeoFAXFCngRlsgBGTvKzQVVy
         NDrMrt3dp8eH/YhirPLIfKFOycMzUwuGF++5CJqKJhbO9BV114lVfeZdtX2KetjYYLSI
         QaFA08leWCp8Ml/VpHIE+aC1VeBn6sxyDaX5Brx0tdhuChRNdWNm/VZn8WD7+8O++ozd
         3smA==
X-Forwarded-Encrypted: i=1; AL+hErEoNpzCmvqb9uEALN/U8MQYntRs/PFRrChoSOZHWbTS7nVCHjL9UApM6hpKi9O/qnq8RKRXHZHGTw==@kvack.org
X-Gm-Message-State: APuU4Z9QTArASRRDngMrgDbk0j1kIC5J6cDQIStQ5hdXoM3wqH4DBmOP
	RjXn6kNeOSLyawkDfYBNyFburKBE87TxHYJcTL0EusYG+BJmm/IO61n3
X-Gm-Gg: AZFdTZegdwdGXbUQbwXL+5YaLZ+FfIhiK6u8S0fd2hFgrfDiGW9sRZhOCxfNWvfBoM0
	YRarqBanDOOo+GdaR/WZdWfTqBqrAN1526mbwprTiBU8aMk0RvqCz1UwCKK/SYt3id5uSIgBvxa
	o477G6Sbg7GJD1LIJWsm5fwnDgAfxuyHZE5RPQbhFvStCsyvQnFD42KK4i0jlnq6hAGbq2habrP
	Pv5SdvI29Yw8goV4HS39j23PT47A/VdqPn7m6ZW//d+WIY2mFBEaiqfLszz99m/sMjUO3H0D9BF
	CX0nGfgiFWfiteAe9Ll2NAdEPK7Cjz+BSj3L7+JnFQk+6Q6nd0r/DQPKrNrVCAZJnGnIK80qlfS
	KSPIQDxlAle5y5PKSR4wU/v8ohiODxmzX0Bfi/YhccYSnXZPrtY9t3XUkWC0dKRQylxRBTlfzO6
	EZ9TlWqzpuPq8/X8ExxKchQ/e0QvAkt5r5y1eJg58liB1yJn94uNisM7o9MyPCQjDZ6/Wkhpa1y
	NpGcSDKLMQDjeSC0g8dyARv7Wnhr2XBTu13EKArafUfAa+xTudysYFMk7OHbSiAk4MVbSQ5v2L7
	ybzExZEeaS+pbjg=
X-Received: by 2002:a05:600c:3484:b0:4a2:133:45e1 with SMTP id 5b1f17b1804b1-4bb88812f16mr355106115e9.24.1795600863477;
        Wed, 25 Nov 2026 02:01:03 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm423898125e9.9.2026.11.25.02.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:01:02 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 0/4] mm: don't allocate page tables with the folio locked
Date: Wed, 25 Nov 2026 10:59:43 +0100
Message-ID: <20261125100058.15200-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B50E100009
X-Stat-Signature: h3g3zdsdqim8x9f7nun39yngng6fp573
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795600865-80925
X-HE-Meta: U2FsdGVkX1809ZlOYeWZPNivx0H86joQkU2XODfsjV2tEplRZyVQTjbH9Y8VkmVeUNsAFBgzAxlSkpFawS9ui3mjgr/hoBlWDLvLhpoXSBknmPKgq5Un4R6u23Ac36w2j+aIpp7tuDdIVd1PuTJv/0fWY4NnX6iovkeMCXvmf5ZSCdk30XV+hN7yLsDUbXeGAzHUUPLUxJ4rYg0dXmcRZn9X+n//QU5+tSv/NrR+a3kN3vBqz9yaAVgDft+Aqh0EXqPFOp4iAMB2dySfplwH2+GRj78hSfswm4b+Az9MIjYJ0loDGiAxMPU8ZpRmTrPfmEd/jKlMIkAbNxrLukeiXLgI7AcSKHbHAFT3WLX4C7PVQk5wp7TMGU1n5A6CC9FpPAMqImLbb3M2ftF6VUJupgriABr/T53EW2NPPBITQIoz5BLyfSFD13J5fQNQgWmEf883A3FSPgYL8OskFCnguQvSxm7ZrXaDpWVgG8wrKaWLEpYmkTAk31acxKGVDHr/L//Wqshc6F0LKt07PJS9U8snP1g/3QJHGb3Y/Isi5zim667pYG8g37QVFAYhZnT/V8PpFLc505tdClm/xz858M4tpDw5MHP7Cv6nkhy4WsEhuK1SXCNv+PCQvqO/IhQvlAHRPixEa3ON+g/aidDnR2B5HE/RtIJV8a4vMW88R7nxrCmQdutVkcZQgAdhyN+kWa/Mub55njtzG9t5HghOn1+rjFNb2llZqCxQr6CTLrppy2fSaiO7g9p6YjD4g5lzDbro5NGSdS6X2bVgtwnY6dOw8ijoX11dNQPn07F9OaRUbthGB99EG1OcjucAcNTm72hNTzPRdiYJ5RDSBybzs98uxZUeKNB7dDtcAhqk4vmDbDuHQnfIB08eafrwK5A3NGd7r++Z9AqDzVUhnO7ItGaZl+jBZB7uxWvHA3GvKvMNxT/oV/zi2qrJFZ3A62hUSrtkpDQRRNal8LxFg25
 OWKQ3HpU
 jgTW1ne00uD1Wb7+9paGbrf6Y+VQgiq8RA8J0eadNI0VKsDHAhr7lsHO6WOhRQR4Ef4zDy8augeGHRXga8iHRDYY4O/V/sojkZoaDXx3N+0GPOveSo9KwYEK8eYDo8S3QYfZxacUQFVAO4NvUoreAXVeEcU2HPNEkZoWZQ2lmGuarTFfWKxX/GgGU+adLw+BZndBUQX5fmyzkdMaTBkZL7hzeETH2o9iU6f+2CPYlxiKwl+iqmc7MLfbhCVrkMJlbvG37uGw/JmK1/ObiHK3rT2+hI525iyyuJ6vLfH63gvKAepVuRRMHjHXQhGy15FBp+09euCGi1mQpgCxFl4HjFt2Xj6uWTdc3PdJh4YFX9/InuJcOGT65rJURwfkeLHSeuxwWuBFJrcNJbPBpIbkzt9gpsywNLEQUycmXOf65Fqx9QfBZ9KU6UGdQNQSF1x2J76+z8RjbpdfZOBepEKm8xgm+4WAUWqZqOYGyXS7z3Zx7oZjk6U2ndsSr8ePWzyM/S0bcNzdlfuyIoxuTCVagxe/rHeCq2NTLpihmngeMcDnWJmUnN5rOMW7sKgXcJTFAs09AR+CyUS2gOGOcEXXWL31Z7Gr28NpcZCP8c2vXkAAW3AfEl8iEfDU74lQYLPPaoj72
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David asked for the remaining places that allocate with __GFP_FS while
holding a folio lock [1]. The fault path and khugepaged still allocate
page tables that way, and collapse_file() calls filemap_release_folio()
and swaps in shmem folios with folio locks held.

Patch 1 allocates the page tables khugepaged needs before locking the
folio.
Patch 2 makes finish_fault() retry the fault instead of allocating when
the page table went away after __do_fault() checked the PMD.
Patch 3 drops the allocation from do_set_pmd(), no caller needs it anymore.
Patch 4 runs the part of collapse_file() that holds folio locks in a NOFS
scope, like __folio_split().

I don't have a real deadlock for patch 4, it just does what [2] does for
splitting, so I left it without a stable tag.

Based on mm/core.git for-next, patch 3 needs the do_set_pmd() changes
there.

Tested on x86_64 and on ppc64le with the hash MMU in QEMU.

[1] https://lore.kernel.org/66e5f9e3-17d4-4635-8919-c67ed562f9f0@kernel.org
[2] https://lore.kernel.org/20261124-migrate_reclaim_deadlock-v2-1-03cc147e1e36@kernel.org

Jose A. Perez de Azpillaga (4):
  mm/khugepaged: allocate page tables before locking the folio
  mm/memory: don't allocate in finish_fault() with the folio locked
  mm/memory: never allocate a page table in do_set_pmd()
  mm/khugepaged: use NOFS while collapse_file() holds folio locks

 include/linux/mm.h |  3 +-
 mm/filemap.c       |  2 +-
 mm/khugepaged.c    | 91 ++++++++++++++++++++++++++++++++++------------
 mm/memory.c        | 39 ++++++++------------
 4 files changed, 85 insertions(+), 50 deletions(-)


base-commit: 98f6b507621822477db7ec7cef8519de0dd243c4
-- 
2.56.1


