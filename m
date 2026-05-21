Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37ADCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 19:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3D66B0088; Thu, 21 May 2026 15:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CAF6B008A; Thu, 21 May 2026 15:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A145E6B008C; Thu, 21 May 2026 15:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEEC6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:32:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2255BC2640
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:06 +0000 (UTC)
X-FDA: 84792422652.24.AF4D08C
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7090F20007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N4PSz8xY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sl0PaggKCAMvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sl0PaggKCAMvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779391924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jj2uKcpS/Lnn6/o0vTIHKLE80CeHYkd6tam2XF0iGgs=;
	b=3i7cKUGVfBtrN6XwdRlt/Ds0dvPkFmiyGEcEzGgwwGWAkkMcODU8xym4EFBPVLXMkuwBIW
	pxMZ5AHHjNNfomhUUMTtF7yekbacs1no294EorACeHRsm70+Vx4deuJEA86okuquqHY1rs
	QPCT/uwrhe1QWfO8cLsHeMSSBnPiwQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N4PSz8xY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sl0PaggKCAMvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sl0PaggKCAMvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779391924; a=rsa-sha256;
	cv=none;
	b=cClNOgZWG0YZ4oR0h24mk8RBqdQzFiY1KwbVJdghEq1X7nMZndmXzZaYIz43CPG4HV9V6K
	KSmKjp66s7aDuUZKOedAltbb3G+YO9/qsoNEp1DurDzVlp2EJowrOjXzQvoCLY8lnyGmBW
	9wM45hMKIpacM1OkJ4o9GYkTeNmvN0Q=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c850ff84ddfso2311539a12.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 12:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779391923; x=1779996723; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jj2uKcpS/Lnn6/o0vTIHKLE80CeHYkd6tam2XF0iGgs=;
        b=N4PSz8xYzjCJDQiMBGarfrbok6j0ZKzhAmk6KqRiP2KSA+YzpHBFjt6qxqQYnk6kjR
         ZvqmX51mxi5m2OC75AqcZSGnkVafV6jWRd2/rm9RCG6ZBX88et8iNcNdM+0TiB1gt5jE
         vKkue4PUAXnHvrxXBR0ygglbNNk7wZw8BPATKoc2Eq20iy784C9A5nPkr587wfk1j+lC
         gzMAXNrIGhLg+sUuutFKkbVAJDk0E/xLjH2XcNQ2DdtfaQvI3ML8ha7+jKHldWO5JOKj
         G4zbhjHUUe5C1iBaW4gKOQuPVPZF/WRokSrGZdpwElbp38dPytJpqLxpk186mfDSSF7l
         Mwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779391923; x=1779996723;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jj2uKcpS/Lnn6/o0vTIHKLE80CeHYkd6tam2XF0iGgs=;
        b=MB+uj/+nW/SWWnXqas1xueYEna0ceOlxlVCJ7+d+F/284Z4r6O65JcK0Mt2qUqj/tu
         7aRzKvp84kU9501xp/fX66kBaba3Ed4kr1Rb1GiSVFJi+zgCbrersMlSNnQ2D0KKtpe1
         bioREMLOx3HxsVABV9Jikh6/6F2gpnossatFb9qDLTTNM+y0hwWYZnlgmS+MbDp6iE//
         t3MZ2SVlnZUiPGdlekaPCiDCJt1A2jEjHGxKXIL+WStxMFv1P4sQvIlxOkpqrFHPK198
         OqtwYlT88GHqKHXwBnXrlR1coVmU1xWg5Pkm9rkaLnj91fN5LURs1Y51W1PTT4NSbXOJ
         4iCg==
X-Forwarded-Encrypted: i=1; AFNElJ+Yb3pXeahavTVXh86SJ2BZ301ZreTKQwxQ32j7ku9SeHtOgKbfxx2UPJSX25YVpHqIKk1XZSas7A==@kvack.org
X-Gm-Message-State: AOJu0YyWdl3d6ngGXee82vVEL6aFP7UDCivsC6RvT2jr3/cowmzU8dhR
	S3hE7R0mBWd0uG8l2OsIkUuc1rtiRMw/HRiDBlALYS4exOJo8mNaOPeKNRLlK8ltn4gn2OXhD9/
	48y3g5lx4frWVRw==
X-Received: from pfbdu2.prod.google.com ([2002:a05:6a00:2b42:b0:82f:4d28:b8c5])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d85:b0:3a2:c685:f9af with SMTP id adf61e73a8af0-3b328fc0643mr327670637.50.1779391922774;
 Thu, 21 May 2026 12:32:02 -0700 (PDT)
Date: Thu, 21 May 2026 19:31:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521193202.746810-1-skhawaja@google.com>
Subject: [PATCH v2 0/3] kho: Add support for kunit mocking KHO restore API
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xm8fwoceoh4sq5wgohax3pbnp9dricyd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7090F20007
X-Rspam-User: 
X-HE-Tag: 1779391924-167653
X-HE-Meta: U2FsdGVkX187ieLR4OD1sNfRtn884vhi0sBN2Iwi8buneIBMtlmXvaBW/auMVWrXBBBewjydGwrHRATtFyr0Sh4tA9e+bsqczyJVwOS6WcsBXTkfDrBovys6WukVo0TIqlkxfRHtyzbdm8Wm2H9JCZl5Qz1QwL5FST0qi89nmwG8wBADseotb/2KNzgwuPwr7MA6nGfgNO3s895IPI7nD5aWK2Xpprnml7Jm+Vc0XCYFeTmbrso7f3LTrVsjccLSn11dobC1eUyGuKwhoJUvovBLX0mcFSsmCPlmGKcExk/KPXGqYuTgJH1AbvWRHIsN1J7E/uSKr5FPCoTYk/yZgkeOMFbg+3dbVDVhviv9qV+hXpA6MGPnVWu6Ph16efml/kuRI65NEeFh6eKckNDshdf/kWPa7saEoTlImMXJakPxHHJ3Pvu9P5lPylw+z5mkjJ8L8O+t+MBAlVT1tNt7aZ4XKAYBW6REkD6iugcqaK5UlG/2GHtjeADS+r2fO69otOg1rImJb/GTjTR7ivMaj1Nwb0ExPLSu+u+glt8mjtwiBdlIGwSM3tgqPO+RKohoKm1TqkgsgXTIHg0X8VMQqZq6DIr9eV2Gicuq5FVo/vW/XsctEeTyD066ijnc+dS+VRelqzwPRl/iMaixm21SRQb6+gmQ60DoXJuh4wNcxL2IVWKYJsPqognLCh9Uk27uDW+Crz+DxIMus3JHUOhlL4idLFynog7dEMMwYcI3Io37MuFJ7JjPoL/J8JgdXy7CIvCShge0EPXzK4BN6+51xCpsw03Vgmn0C5PrlTkwtiqeAlspfViRqK5+d9X+1A1mU8gTm9L0UQKlhZHXVEyHXEOlY+JQwyQdrkcl8EcGJmtskVfhhU3lX5tbxAr8Q2pzb81Sz2fwBJGERx0Ga5n4yFHBprVUi2HlFA018IfaIoO1KIkEKiKOsIg6rn2vJLH1jr/XdgrjEj5QuWNhm3q
 V87PytEm
 pX9i0SxdEqTWFop2Edj5SA9xq1+boT8kAlhK44Yd9Km2QXiouz5IWqOo7XS2huuPQcNbHrjG0YnD4/jgoo+KDKoffmZArhLX9wKYar1xNPBfcK4SfffhdNhloNehoA7rjcQT4JCemNCssSPF3LOb4FQUHaCw0plo6zZ26L+5rdN2pgA+HPukUdzEqBrfvlfEOXcW1PFkcQ09SdqYnbMc1z/WodKq8fGl0VpGMPfBpPtCnpz0G72+KxYFSIciOASNKtl+If65GC59KYUVWW3Nuj2RIQbkmCvVS6NsH49YaN1mY9bywoihqmjzPFsrczXvwffcFxpd8N6Z678rI0fHIUVBp7hYJ+3wQBxjWSRnbpwKjOF3z1maoLDX0YE8LqrELVqtAbJrSGh/GZsWO1qx/xrNbCHRJg8xdvJp+JItMJRT7wySj4g+Vae6aRNlS2P1IduNLE21BlPvnnXF6AEwj+FFqhWVSacSXZBV/urmZmFiosZg+MrffAqwBnpt9gdWpR23Ved0BRCHQarG+hs/Ll2wI3ewdZW+UpqrBalIHsYrckr3WqBMGCQ7SxYmD7YUdKf+XAZk6RC/UnJO4B+Ib7bMilM2WDxd9+6I13WYiSuhNLVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To write kunit tests for preservation and restoration of liveupdate
state in various subsystems without triggering the actual kexec, the KHO
restore API needs to be mocked by the test writer. The mocking is done
to allow testing of the individual components or functions in isolation.

The patch series adds the following to support kunit testing when using the KHO
API:

- Add static stub hooks to mock the KHO restore API so the restore path
  can be tested without triggering kexec.
- Add helper function that can be used by the test writer to check if
  memory is preserved in KHO tree.

Finally, it adds a KUnit test for the KHO API that verifies the allocation of
preserved memory, and the preservation/restoration of pages and folios.

KHO Kunit test run:

 KTAP version 1
 1..1
     KTAP version 1
     # Subtest: kho_test
     # module: kexec_handover_test
     1..3
     ok 1 kho_test_alloc_preserve
     ok 2 kho_test_preserve_pages
     ok 3 kho_test_preserve_folio
 # kho_test: pass:3 fail:0 skip:0 total:3
 # Totals: pass:3 fail:0 skip:0 total:3
 ok 1 kho_test

v2:
 - Move kunit header includes above linux header includes.
 - Use the __kho_preserve_pages_order() to get the order of preserved
   pages instead of open order calculation math.

Samiullah Khawaja (3):
  kho: Add kunit static stubs
  kho: Add helper function to check if pages are preserved
  kho: Add kunit test to verify preserve/restore pages and folio

 include/linux/kexec_handover.h          |   5 +
 kernel/liveupdate/Kconfig               |  10 ++
 kernel/liveupdate/Makefile              |   1 +
 kernel/liveupdate/kexec_handover.c      |  63 +++++++++++-
 kernel/liveupdate/kexec_handover_test.c | 131 ++++++++++++++++++++++++
 5 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 kernel/liveupdate/kexec_handover_test.c


base-commit: ec4084bc445027a52f600e30a976928be1ba1950
-- 
2.54.0.746.g67dd491aae-goog


