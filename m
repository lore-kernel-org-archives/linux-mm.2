Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F603F36BAB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EEBC6B0005; Fri, 10 Apr 2026 00:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378CA6B0089; Fri, 10 Apr 2026 00:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267846B008A; Fri, 10 Apr 2026 00:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B6B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:41:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B9DE58A8C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:41:58 +0000 (UTC)
X-FDA: 84641398716.30.325BF30
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4BF54000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:41:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=laXNy6Zb;
	spf=pass (imf04.hostedemail.com: domain of create0818@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6h2CeoH05L5D5drW/viG79qQjvldbeeqelsA44hB3/A=;
	b=43YWjb6AER7AA+HEpzKj7cKTVudOetC4KcPOKBoGXFgjc0D9Lzym+9MQ6Ak4fYJBz3fOfv
	3SxmFsS2nK9egyjGSrpNhzKIjtG/nRbxe+U0kLMpaLP+l9P5HPudO7cnGPky5bnP+SMV1H
	SoeZqQ22DPGAwFaf9ArIP2mvLnP7mFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796116; a=rsa-sha256;
	cv=none;
	b=ZnZQ7REUs9M9Qg+5FW6FFiM4PFQRd8UtwH+nFmIm0d4Dvnqas0Ga8JKNzaNrtL/ykjd22z
	ElTyyMt1NqNFORaVDLBFRrb66SKFWGv2f27ff5OgrI+K6q55YME0LETD5/lg2PduxvlO3a
	HwTvP9hO6qfnyc5qiDoKjNnaTDYvrcg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=laXNy6Zb;
	spf=pass (imf04.hostedemail.com: domain of create0818@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6h
	2CeoH05L5D5drW/viG79qQjvldbeeqelsA44hB3/A=; b=laXNy6ZbXQVRAparm9
	5CNQM8nOiibCZht+rlh5ehK6w6SQLRDLyEU88y5+s9btT8sDFGWbWElXAa/7s9O/
	FpxDIJ+Syd0EMwnwtvdoPxZAVPkprQE71wHsGT9oYKCcdyg3Qd7Lb1kGtns2H5er
	iovwKCAWE5nW4qrffjahpvM8k=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnn6SFf9hpjtA6EQ--.23811S2;
	Fri, 10 Apr 2026 12:41:43 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests: mm: skip charge_reserved_hugetlb without killall
Date: Fri, 10 Apr 2026 12:41:39 +0800
Message-Id: <20260410044139.67480-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260406053126.217196-1-create0818@163.com>
References: <20260406053126.217196-1-create0818@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnn6SFf9hpjtA6EQ--.23811S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw18CFyfAFWfXrW8tF1rtFb_yoW8Gr45pa
	4rJ3WY9ry8AFy7Kw4kGw47ZFyIvF4kZFW0yrs5t39xZr15Ga4xKr1IgF13XrWfurZ3Xws3
	ZFWFq3Z3u3WUJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UAUUbUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCvwiSy2nYf4iCXQAA33
X-Rspamd-Queue-Id: D4BF54000E
X-Stat-Signature: khdf9nyaz8kmrhpq77uzqqkopgfdgki1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775796115-486657
X-HE-Meta: U2FsdGVkX1/fhoak9U7vls2iaH6WLiHaUbXnrPF8BqMI1IMlbB3f8HqzNbuyDWNLTOwi3zND25iqvj0r8izey/pjqIhkPR0iGrfPC+bxr860rHg3oMCUFzqOCrZQFBJ8uLs6UZ4Lfl0nleYDCLpd8Goqy7ZSVSblmy53hb2/+lAhxqDlVcRo5Er9cbqQmOtEh6Nw8dbjEu4626EWrS1Sc6OJwPObf2frCPC5+jfxLQrndwbd9cb45FQPGmVul1+LGZePwa0Axy1q6C+9OvJQse5PCy0XiL0pg0lUs+WR226WMy5Ff2SZ9SOKBqXWHg2sO+jO+o4ugKJkbGeRidSeig2sAYGdWNxIN35RcgKRzdN+pRuQW40Hr+LMWYD3oDWhnbFFW7YcRGFwXH1xSuXvtrxHeSmqNHAdZtELIxqBwIbaUJ2ZW8e1XhGy9SpXtxamvG6jE0qr4TIvNA4CJZUkTMrPjlXiLb+2US1ontDh3LjmNBIA7UnarSL5xZJ4bJMOvXPxjwfdnmuqDt8tdKlrsaWjYFlxKgU3ijiGcg+edQ+McDDiHk3Rf0+4hmoznHEoMmT3V46RfNhhjfU8Qx1kSR/J2BgBcIJ2122P/8mGW6hKBlonNZw9kMLVm2In4J3CtRlmmxj6QTctKLd3WUDUm1QtvAZJVF4W7/G7iZopJ0TaEo10H1Dkgpgrw0FDg2Ou/1qcVIUzHHolmADmmw9tTEaeLNyZ+C3/vxQmlfyMjRUpFU8TUHKqfS7GPTpPGLmtlr8x5rYwJE752EZmhpnYKdXG8GEufKuTfSW+1RMjJ3ynev7dOKrVwDDyLZWbWp6lwyvi4K6kYO/XQx3lUNVI+opaKF+q4gj7JrdUiIhIshNmA06Rtt56tZj+DsKa+rNt5z3n2l4LJPK4snSatZ0D1Kt8DbPwSj6Vo22LECXOnRXKqdR2aGcdYUTIU4lGB26LRoD6KeS75dEVtQUgkRH
 1lC0PqB8
 DShFOxOKharyHDTinoJflckgn3qjGmc5EmQHeBymGBHYxcbN7vFGCbgot2XaAWR2T7BslxXvH4qzsKxoJFjmg6drTyzEqbjjuVJ/Ps0yQT37DTrYmkUirdpxwaa7z00oDDHWEYJGZvYfHMUVwTdvR1BNabFbjJxgtqR00us83TcwQ3upJELOYOuMBXbLGAG1EXdgEqJYqSStfG1uSG0F/PjFqRcNQ4JO5SDm7wiTt2wHl9rIA8nrIKYepiPihXI6uulvJLEmLOjHM9RPuD/WXGUHNsoHYOO9So9ugKUUSLvE3IoNkQqe8c3bLacHcr6cWwcvBnhpc4kMPoUANBywvtLtYeguFQqN/BLcdPM3np6qoQU3QtauGwfPGX6irH7Y0y560sugMvq1bXNXubIcxmli0by5gZ78MMF0Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

charge_reserved_hugetlb.sh tears down background writers with
killall from psmisc. Minimal Ubuntu images do not always provide
that tool, so the selftest fails in cleanup for an environment reason
rather than for the hugetlb behavior it is trying to cover.

Skip the test when killall is unavailable, similar to the existing
root check, so these environments report the dependency clearly
instead of failing the test.

Signed-off-by: Cao Ruichuang <create0818@163.com>
---
v2:
- replace the PID tracking approach with a simple skip when killall is
  unavailable
- follow Mike Rapoport's review suggestion

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 44776965763..44f4e703deb 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -11,6 +11,11 @@ if [[ $(id -u) -ne 0 ]]; then
   exit $ksft_skip
 fi
 
+if ! command -v killall >/dev/null 2>&1; then
+  echo "killall not available. Skipping..."
+  exit $ksft_skip
+fi
+
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 
 fault_limit_file=limit_in_bytes
-- 
2.39.5 (Apple Git-154)


