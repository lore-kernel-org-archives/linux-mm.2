Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28E060A260D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IFTqiyv0
Received: by kanga.kvack.org (Postfix)
	id B9A116B05C1; Fri, 20 Nov 2026 02:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A846B05C2; Fri, 20 Nov 2026 02:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FE66B05C3; Fri, 20 Nov 2026 02:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9336B05C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:42:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E781F140D3A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:42:46 +0000 (UTC)
X-FDA: 85454705532.17.66633D0
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0437618000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:42:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFTqiyv0;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160565;
	b=Kor7tEOdzcWdb8eOpHSe+P4HiE91MHjNaNaftKY+GQYLMrWnjY6mHU7meULeMWR3b2x5L9
	MxmLIo4PK2f/qRZYNX0H0Tbz9Gz+THx9UCr8369RGyS6mSSakKo1G3zBkT8/REexiAyymL
	TZd4Fp8PD+1Vn8n7tbEqE64zNRekpsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fHTdpM8nxSvx3evoOQbtGvFbq+YzrWfScABJx2vwaCs=;
	b=v+JwOFdIrsmJ93L17fWFzpsSnAU3jRhdG4zPxl4nwZkioJFzZf51FteJJyVVkUrjnSMHir
	Fldf6ir8Q+HQ5dS8xoRbVo2V+8e0sG4PEBkGWypPdv+1XcMfzDJv1TteYU/pc+iiI5BgpT
	xy5lW2HBzDpOTeJITQUUiiY1CGjl9sg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFTqiyv0;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rf68KggUysX1MYPELIpPD1pBE4j+ZU9neLaxwKPeBJ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795160563; v=1; x=1795765363;
 b=IFTqiyv0d1cpPHITuUombiXXqWGl7hr//7jd2CjBovzzMo11dyBnQzvFK7MgO5qpf9Toeb9G
 wOKN5J+0TMl4pxM6zqR4RaNWMTyf0HpLadpSsixbitZKecsLz2oNQr1sFTSo7EofyxKDv1cG/mb
 afX83lNtBRtyQE/1Cq/9onHY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id cc1442cd9fd56b76;
	Fri, 20 Nov 2026 07:42:43 +0000
X-Mizu-Trace-ID: cc1442cd9fd56b76
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	xu.xin@linux.dev
Subject: [PATCH v2 0/3] mm/ksm: fix ksm_zero_pages accounting on fork
Date: Fri, 20 Nov 2026 15:42:30 +0800
Message-Id: <20261120074230.40269-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0437618000A
X-Rspam-User:
X-Stat-Signature: boszfraknyejjmkf1sgdu915k98aq9fr
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795160564-694742
X-HE-Meta: U2FsdGVkX18eZqj+vv/sntRbmFlE5BGS5B2H57G1z7t5RSiOCY/v5sB81rLrhnBz5hW9s92T4N/Y8zRItPk4ROD9C+t4g13RpibMGK6r3b1yJhUyDbkcwScosi3gJrHPPDPWu7HnR66DAh9LPThqremwKAROVLF/SrUsT+KXozj7zud1LtipCDqcmzQYwLfaslWSCad0Fn9obXL74wAwgiO1GagY/JJg0oJcgLoESmnupkLwqpdPrf/gkLNZr+pJrcG2c00JOFmUAqtaK+g8ByG/ETTVubo9H/lI8AnNRYaV5syYwC29oR9ZZMq2r99BB/U6B2klSri/Pc6jFHgrfhef5IN0nfxEVbQyjhm/7Sav7Z0VbLlSkW9wrwyTvQivoWqJjw4MDByL4kCemb7f+dGBuWLHhBm6HHi6cyM/jfmyQYb2i3Ef3N9nges2Kj56R3mgvB5ePeHc6z9b8t/P3gyz9UsffyYb8mMxHfTJPIPyqSke7IhBq1ru+4H5efix8cKFR6R/m8yHPq50n81rSNkDqFbK3WF7eOuVDKKGtfRV9l6DIKKB1kI8HOe9JyJ6rS77sbUCQ+ajCWJ2o7fTPkF7OOKdjG3po/46cbhqgqsBuqA0Bh6bzmPoESzwnvsnOhSWqFDZvHg3Bobnvl3joBQROz5WRcSXjSmtMrnSgnyt38fW7qstA0d7inlpK9I6Kt2a+uD0ZDnLsS+7rO96971Gi2awEI+VtnW041q9/AmSg7mwAifmy7J1Sj8A81Z27UcSNukutaTU2+Hpeni+wBz41bGhsMNpV3lCDWJ6IZxYst9TQgh4gPrtZgMnYqMAl/+ykK37eFQKYe1JKj9HiUIqaypazYsUwLBQaFGZUkcE9Rs/i+yopm8FoXP0EQ569VK2pz1Er0e2ti8RH8ZS6Ijt4BpVT86nTGtx3OiYjxupKsfYZzH4dVuffjwHUwqiGK+Gg33nnuF0fjKw6aJ
 idhKmE1r
 UFCEsYKTHXLiagWTjNspbuC5Z6j8SSubHA6uPNChsXZPybJcDQ1Gk3F3YkG0t94pP9z71hi0S0OFq4wOJWer31DZmP45fVTef1iesy+bBfkKDS+hugb9QbiXFGUYUcevL4HLDqwPzrkpmY5eiGUoDYH3JR2pCW1XR4jPozGV1bMsZR+Ixyx1EIGtEIyM0/cSbYTZJd0IOZ6zf9exnu7FWQCssVrQlHlv7JePleMXF3mYQMtiRmAcUNUGz4mY+17C3V6h5ARdAmSXqNk1uP11I8/bUOwbfoRaRIcrWC1h1FmTvxqdt5PnZew6djeP3nBKNysbGHyRDQeMC4+Mo6dHzl2+8tzde4R+CsFaqxomeW5Z28Yqd+UItjAQNI2cq45xVX2y5lBNIyo9Nqr+tCXB6iT4/QB5s0ncErn8gAe3FIZKQC3jSV1ndLpcAllrEaJyrfDQk6EN03Kznz0YENA2pQp0B09EFf13QVCS6kCCuZ+XhZRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, fork() wrongly inherits the parent's ksm_zero_pages counter
and keeps the KSM dirty-bit marker on zero-page PTEs, inflating both the
child's per-mm counter and the global ksm_zero_pages counter.

Patch 1 fixes this by resetting the child's mm->ksm_zero_pages to 0 in
ksm_fork() and clearing the KSM zero-page marker when copying present
PTEs, and documents the behavior.

Patch 2 fixes a false-positive bug in the existing KSM fork selftest by
removing a redundant init_global_file_handles() call in the child.

Patch 3 extends the selftest to verify that ksm_zero_pages is not
inherited across fork().

---
Changes in v2:
- Encapsulate zero-page PTE marker clearing into a dedicated
  might_clear_ksm_zero_pte() helper and simplify the code comment. (David)

- Fix compilation error by adding stub implementation of
  might_clear_ksm_zero_pte() for !CONFIG_KSM. (kernel test robot)

- Document the fork() interaction and MADV_UNMERGEABLE behavior for
  ksm_zero_pages in Documentation/admin-guide/mm/ksm.rst. (David)

- Fix a false-positive bug in the KSM fork selftest (patch 2/3) and
  extend it to verify ksm_zero_pages is not inherited on fork (patch 3/3).

Xu Xin (vivo) (3):
  mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
  selftests/mm: fix false-positive KSM fork test by dropping
    init_global_file_handles()
  selftests/mm: verify ksm_zero_pages is not inherited on fork

 Documentation/admin-guide/mm/ksm.rst          |  7 +++-
 include/linux/ksm.h                           | 18 ++++++++--
 mm/memory.c                                   |  2 ++
 .../selftests/mm/ksm_functional_tests.c       | 35 ++++++++++++++-----
 4 files changed, 49 insertions(+), 13 deletions(-)

-- 
2.34.1


